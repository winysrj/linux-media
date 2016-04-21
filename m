Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:34777 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbcDUQx0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Apr 2016 12:53:26 -0400
Received: by mail-lb0-f182.google.com with SMTP id b1so26853850lbi.1
        for <linux-media@vger.kernel.org>; Thu, 21 Apr 2016 09:53:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <57181B0B.7060006@iki.fi>
References: <1460734647-8941-1-git-send-email-alessandro@radicati.net>
	<5716B906.2090909@iki.fi>
	<CAO8Cc0qbTpcbJ0PwhNksGedWcNDD-15xOd4E_oFL5symHaAi8Q@mail.gmail.com>
	<57181B0B.7060006@iki.fi>
Date: Thu, 21 Apr 2016 18:53:24 +0200
Message-ID: <CAO8Cc0rpf18XwijH_163kNHKNH7DAYOxfr=ty6bUHZkDF6vgeQ@mail.gmail.com>
Subject: Re: [PATCH] [media] af9035: fix for MXL5007T devices with I2C read issues
From: Alex Rad <alessandro@radicati.net>
To: Antti Palosaari <crope@iki.fi>
Cc: Angel reguero marrero <areguero@telefonica.net>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 21, 2016 at 2:12 AM, Antti Palosaari <crope@iki.fi> wrote:
> On 04/20/2016 12:13 PM, Alex Rad wrote:
>>
>> On Wed, Apr 20, 2016 at 1:02 AM, Antti Palosaari <crope@iki.fi> wrote:
>>>
>>> Hello
>>> I am not happy with that new module parameter as I cannot see real need
>>> for
>>> it. So get rid of it.
>>
>>
>> My reasoning for this is:
>> 1) We know of just two devices which may have the issue, but there are
>> probably more.  The module parameter allows a user to apply the
>> workaround to other devices we did not consider or test.  Should we
>> perhaps apply for all mxl5007t devices?
>
>
> So what. It is easier for me add just new IDs to driver when problematic
> device is found than adding new module parameter which allows user to
> work-around issues and I will likely newer even hear about those issues.
>

I guess I like to be more user friendly, but your call... I'll remove it.

>> 2) Not all devices that match VID and PID have the issue, so it allows
>> the user to disable the workaround.
>
>
> Due to that better to add three checks
> 1) it is Avermedia VID
> 2) it is known problematic Avermedia device PID
> 3) it has tuner MxL5007t
>
> It is not surprise it is just only Avermedia which has this kind of
> problems. Not first time at all. I have added such Avermedia hacks for
> af9015 driver too and if you look af9035 there is tuner id hack - which was
> added also due to Avermedia.
>
> Worst case there could be is some mxl5007t device having reference design
> ID. But even on that case returning fake values is pretty much OK.
>

Well, considering the combined write/read bug in the driver, we can
say the same for all devices.  I'll add the checks and propose v2.

Regards,
Alessandro

>
> regards
> Antti
>
>
>
>>> Better to compare both VID and PID when enabling that work-around. Driver
>>> supports currently quite many different USB IDs and there is still small
>>> risk duplicate PID will exists at some point enabling work-around for
>>> wrong
>>> device.
>>>
>>
>> OK.  Will wait for comments on above before a v2.
>>
>> Thanks,
>> Alessandro
>>
>>> regards
>>> Antti
>>>
>>>
>>>
>>>
>>> On 04/15/2016 06:37 PM, Alessandro Radicati wrote:
>>>>
>>>>
>>>> The MXL5007T tuner will lock-up on some devices after an I2C read
>>>> transaction.  This patch adds a kernel module parameter "no_read" to
>>>> work
>>>> around this issue by inhibiting such operations and emulating a 0x00
>>>> response.  The workaround is applied automatically to USB product IDs
>>>> known
>>>> to exhibit this flaw, unless the kernel module parameter is specified.
>>>>
>>>> Signed-off-by: Alessandro Radicati <alessandro@radicati.net>
>>>> ---
>>>>    drivers/media/usb/dvb-usb-v2/af9035.c | 27
>>>> +++++++++++++++++++++++++++
>>>>    drivers/media/usb/dvb-usb-v2/af9035.h |  1 +
>>>>    2 files changed, 28 insertions(+)
>>>>
>>>> diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c
>>>> b/drivers/media/usb/dvb-usb-v2/af9035.c
>>>> index 2638e32..8225403 100644
>>>> --- a/drivers/media/usb/dvb-usb-v2/af9035.c
>>>> +++ b/drivers/media/usb/dvb-usb-v2/af9035.c
>>>> @@ -24,6 +24,10 @@
>>>>    /* Max transfer size done by I2C transfer functions */
>>>>    #define MAX_XFER_SIZE  64
>>>>
>>>> +static int dvb_usb_af9035_no_read = -1;
>>>> +module_param_named(no_read, dvb_usb_af9035_no_read, int, 0644);
>>>> +MODULE_PARM_DESC(no_read, "Emulate I2C reads for devices that do not
>>>> support them.");
>>>> +
>>>>    DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
>>>>
>>>>    static u16 af9035_checksum(const u8 *buf, size_t len)
>>>> @@ -348,6 +352,9 @@ static int af9035_i2c_master_xfer(struct i2c_adapter
>>>> *adap,
>>>>
>>>>                          ret = af9035_rd_regs(d, reg, &msg[1].buf[0],
>>>>                                          msg[1].len);
>>>> +               } else if (state->no_read) {
>>>> +                       memset(msg[1].buf, 0, msg[1].len);
>>>> +                       ret = 0;
>>>>                  } else {
>>>>                          /* I2C write + read */
>>>>                          u8 buf[MAX_XFER_SIZE];
>>>> @@ -421,6 +428,9 @@ static int af9035_i2c_master_xfer(struct i2c_adapter
>>>> *adap,
>>>>                  if (msg[0].len > 40) {
>>>>                          /* TODO: correct limits > 40 */
>>>>                          ret = -EOPNOTSUPP;
>>>> +               } else if (state->no_read) {
>>>> +                       memset(msg[0].buf, 0, msg[0].len);
>>>> +                       ret = 0;
>>>>                  } else {
>>>>                          /* I2C read */
>>>>                          u8 buf[5];
>>>> @@ -962,6 +972,23 @@ skip_eeprom:
>>>>                          state->af9033_config[i].clock =
>>>> clock_lut_af9035[tmp];
>>>>          }
>>>>
>>>> +       /* Some MXL5007T devices cannot properly handle tuner I2C read
>>>> ops. */
>>>> +       if (dvb_usb_af9035_no_read != -1) { /* Override with module
>>>> param
>>>> */
>>>> +               state->no_read = dvb_usb_af9035_no_read == 0 ? false :
>>>> true;
>>>> +       } else {
>>>> +               switch (le16_to_cpu(d->udev->descriptor.idProduct)) {
>>>> +               case USB_PID_AVERMEDIA_A867:
>>>> +               case USB_PID_AVERMEDIA_TWINSTAR:
>>>> +                       dev_info(&d->udev->dev,
>>>> +                               "%s: Device may have issues with I2C
>>>> read
>>>> operations. Enabling fix.\n",
>>>> +                               KBUILD_MODNAME);
>>>> +                       state->no_read = true;
>>>> +                       break;
>>>> +               default:
>>>> +                       state->no_read = false;
>>>> +               }
>>>> +       }
>>>> +
>>>>          return 0;
>>>>
>>>>    err:
>>>> diff --git a/drivers/media/usb/dvb-usb-v2/af9035.h
>>>> b/drivers/media/usb/dvb-usb-v2/af9035.h
>>>> index df22001..a76dafa 100644
>>>> --- a/drivers/media/usb/dvb-usb-v2/af9035.h
>>>> +++ b/drivers/media/usb/dvb-usb-v2/af9035.h
>>>> @@ -62,6 +62,7 @@ struct state {
>>>>          u8 chip_version;
>>>>          u16 chip_type;
>>>>          u8 dual_mode:1;
>>>> +       u8 no_read:1;
>>>>          u16 eeprom_addr;
>>>>          u8 af9033_i2c_addr[2];
>>>>          struct af9033_config af9033_config[2];
>>>>
>>>
>>> --
>>> http://palosaari.fi/
>
>
> --
> http://palosaari.fi/
