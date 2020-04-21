import datetime

from dcim.models import Device
from dcim.choices import DeviceStatusChoices
from extras.models import CustomFieldValue
from extras.reports import Report



WEEKS_IN_HOURS_3 = 24 * 21
MONTHS_IN_HOURS_1 = 24 * 30
MONTHS_IN_HOURS_3 = 24 * 90
MONTHS_IN_HOURS_6 = 24 * 180


class MantDates(Report):
    """
    This report takes this Custom Field for reference:
        - Mant Expiry Day
    """

    description = "Check the remaining time of Device Maintenance."

    def test_check_mantymeexpiry(self):

        active_device = Device.objects.filter(
            status=DeviceStatusChoices.STATUS_ACTIVE
        )

        mantexpiry_dates = CustomFieldValue.objects.filter(
            field__name="mant_expiry_date", obj_id__in=active_device
        )

        # Get list of PKs for active devices to compare with
        # the custom field data later
        active_pks = active_device.values_list("pk", flat=True)

        today = datetime.datetime.utcnow().date()
        one_month_ago = today + datetime.timedelta(hours=MONTHS_IN_HOURS_1)
        three_months_ago = today + datetime.timedelta(hours=MONTHS_IN_HOURS_3)

        device_w_dates = []
        for device in mantexpiry_dates:

            device_obj = device.obj
            device_w_dates.append(device_obj.id)

            if not device.value:
                self.log_failure(device_obj, "You did not enter a maintenance expiration date.")
            elif device.value < today:
                self.log_failure(
                    device_obj,
                    "MANTENIMENT CADUCAT!!!".format(
                        device.value
                    ),
                )

            elif device.value < one_month_ago:
                self.log_failure(
                    device_obj,
                    "There is less than 1 month left for maintenance to expire".format(
                        device.value
                    ),
                )
            elif device.value > one_month_ago and device.value < three_months_ago:  # older than 3 months
                self.log_warning(
                    device_obj,
                    "There is 1-3 months for maintenance to expire".format(
                        device.value
                    ),
                )
            elif device.value > three_months_ago:  # older than 1 month
                self.log_success(
                    device_obj, "There are more than 3 months left for maintenance".format(device.value)
                )

            else:
                self.log_success(device_obj)

        for missing in set(active_pks) - set(device_w_dates):
            device_obj = Device.objects.get(pk=missing)
            self.log_failure(device_obj, "You did not enter a maintenance expiration date.")
