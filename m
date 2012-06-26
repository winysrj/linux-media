Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11372 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753686Ab2FZVVR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jun 2012 17:21:17 -0400
Message-ID: <4FEA27BE.8020306@redhat.com>
Date: Tue, 26 Jun 2012 18:21:02 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Antti Palosaari <crope@iki.fi>, Kay Sievers <kay@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFC 3/4] em28xx: Workaround for new udev versions
References: <4FE9169D.5020300@redhat.com> <1340739262-13747-1-git-send-email-mchehab@redhat.com> <1340739262-13747-4-git-send-email-mchehab@redhat.com> <20120626204242.GC3885@kroah.com>
In-Reply-To: <20120626204242.GC3885@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 26-06-2012 17:42, Greg KH escreveu:
> On Tue, Jun 26, 2012 at 04:34:21PM -0300, Mauro Carvalho Chehab wrote:
>> New udev-182 seems to be buggy: even when usermode is enabled, it
>> insists on needing that probe would defer any firmware requests.
>> So, drivers with firmware need to defer probe for the first
>> driver's core request, otherwise an useless penalty of 30 seconds
>> happens, as udev will refuse to load any firmware.
>>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>> ---
>>
>> Note: this patch adds an ugly printk there, in order to allow testing it better.
>> This will be removed at the final version.
>>
>>   drivers/media/video/em28xx/em28xx-cards.c |   39 +++++++++++++++++++++++++----
>>   1 file changed, 34 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
>> index 9229cd2..9a1c16c 100644
>> --- a/drivers/media/video/em28xx/em28xx-cards.c
>> +++ b/drivers/media/video/em28xx/em28xx-cards.c
>> @@ -60,6 +60,8 @@ static unsigned int card[]     = {[0 ... (EM28XX_MAXBOARDS - 1)] = UNSET };
>>   module_param_array(card,  int, NULL, 0444);
>>   MODULE_PARM_DESC(card,     "card type");
>>   
>> +static bool is_em28xx_initialized;
>> +
>>   /* Bitmask marking allocated devices from 0 to EM28XX_MAXBOARDS - 1 */
>>   static unsigned long em28xx_devused;
>>   
>> @@ -3167,11 +3169,14 @@ static int em28xx_usb_probe(struct usb_interface *interface,
>>   	 * postponed, as udev may not be ready yet to honour firmware
>>   	 * load requests.
>>   	 */
>> +printk("em28xx: init = %d, userspace_is_disabled = %d, needs firmware = %d\n",
>> +	is_em28xx_initialized,
>> +	is_usermodehelp_disabled(), em28xx_boards[id->driver_info].needs_firmware);
> 
> debug code?

Yes, temporary debug code, for people @linux-media that might be interested
on testing the patch. It will be removed at the final version, of course.

> Also, this doesn't seem wise.  probe() will be called and
> is_em28xx_initialized will be 0 before it can be set if the device is
> present when the module is loaded.  But, if a new device is added to the
> system after probe() already runs, is_em28xx_initialized will be 1, yet
> it isn't true for this new device.

Yes.
>
> So this doesn't seem like a valid solution, even if you were wanting to
> paper over a udev bug.

The problem with udev-182 is that it blocks firmware load while
mode_init() is happening. Only after the end of module_init(), udev will
handle request_firmware.

This is what happens before this patch series:

[    3.605783] tvp5150 0-005c: tvp5150am1 detected.
[    3.627674] tuner 0-0061: Tuner -1 found with type(s) Radio TV.
[    3.633695] xc2028 0-0061: creating new instance
[    3.638406] xc2028 0-0061: type set to XCeive xc2028/xc3028 tuner
[   64.422633] xc2028 0-0061: Error: firmware xc3028-v27.fw not found.
[   64.429090] em28xx #0: Config register raw data: 0xd0
[   64.434959] em28xx #0: AC97 vendor ID = 0xffffffff
[   64.440206] em28xx #0: AC97 features = 0x6a90
[   64.444654] em28xx #0: Empia 202 AC97 audio processor detected
[   64.607494] em28xx #0: v4l2 driver version 0.1.3
[  125.574760] xc2028 0-0061: Error: firmware xc3028-v27.fw not found.
[  125.645012] em28xx #0: V4L2 video device registered as video0
[  125.650851] em28xx #0: V4L2 VBI device registered as vbi0

The 60s delay is due to the bug (firmware doesn't load there just
because I didn't ask dracut to add it there).

After the patch series, the artificial delay introduced due to udev-182
goes away:

[    2.884657] usbcore: registered new interface driver em28xx
[    2.884657] em28xx driver loaded
[    3.123482] em28xx: init = 1, userspace_is_disabled = 0, needs firmware = 1
[    3.123489] em28xx: New device  WinTV HVR-980 @ 480 Mbps (2040:6513, interface 0, class 0)
[    3.123491] em28xx: Audio Vendor Class interface 0 found
[    3.123492] em28xx: Video interface 0 found
[    3.123493] em28xx: DVB interface 0 found
[    3.123633] em28xx #0: chip ID is em2882/em2883
[    3.267680] em28xx #0: i2c eeprom 00: 1a eb 67 95 40 20 13 65 d0 12 5c 03 82 1e
[    3.283034] em28xx #0: i2c eeprom 10: 00 00 24 57 66 07 01 00 00 00 00 00 00 00 00 00
[    3.291857] em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 02 00 b8 00 00 00 5b 1c 00 00
[    3.300682] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20
[    3.315397] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    3.324263] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00
[    3.339330] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 18 03 34 00 30 00
[    3.348164] em28xx #0: i2c eeprom 70: 32 00 38 00 34 00 34 00 39 00 30 00 31 00 38 00
[    3.356996] em28xx #0: i2c eeprom 80: 00 00 1e 03 57 00 69 00 6e 00 54 00 56 00 20 00
[    3.365834] em28xx #0: i2c eeprom 90: 48 00 56 00 52 00 2d 00 39 00 38 00 30 00 00 00
[    3.371533] em28xx #0: i2c eeprom a0: 84 12 00 00 05 50 1a 7f d4 78 23 b1 fe d0 18 85
[    3.371537] em28xx #0: i2c eeprom b0: ff 00 00 00 04 84 0a 00 01 01 20 77 00 40 fa 40
[    3.371540] em28xx #0: i2c eeprom c0: 1d f0 74 02 01 00 01 79 4f 00 00 00 00 00 00 00
[    3.371544] em28xx #0: i2c eeprom d0: 84 12 00 00 05 50 1a 7f d4 78 23 b1 fe d0 18 85
[    3.371547] em28xx #0: i2c eeprom e0: ff 00 00 00 04 84 0a 00 01 01 20 77 00 40 fa 40
[    3.371551] em28xx #0: i2c eeprom f0: 1d f0 74 02 01 00 01 79 4f 00 00 00 00 00 00 00
[    3.371556] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x994b2bdd
[    3.371557] em28xx #0: EEPROM info:
[    3.371558] em28xx #0:	AC97 audio (5 sample rates)
[    3.371558] em28xx #0:	500mA max power
[    3.371560] em28xx #0:	Table at 0x24, strings=0x1e82, 0x186a, 0x0000
[    3.371562] em28xx #0: Identified as Hauppauge WinTV HVR 950 (card=16)
[    3.487464] tvp5150 0-005c: chip found @ 0xb8 (em28xx #0)
[    3.814980] em28xx #0: Config register raw data: 0xd0
[    3.820851] em28xx #0: AC97 vendor ID = 0xffffffff
[    3.826129] em28xx #0: AC97 features = 0x6a90
[    3.830561] em28xx #0: Empia 202 AC97 audio processor detected
[    3.996943] em28xx #0: v4l2 driver version 0.1.3
[    4.078987] em28xx #0: V4L2 video device registered as video0
[    4.078989] em28xx #0: V4L2 VBI device registered as vbi0
[    4.137199] em28xx #0: em28xx #0/2: xc3028 attached
[    4.173927] DVB: registering new adapter (em28xx #0)
[    4.188846] em28xx #0: Successfully loaded em28xx-dvb

In other words, only the .probe() that is called during usb_register() is affected
by this behavior. Subsequent device additions/removals aren't affected:

[ 8125.049183] xc2028 0-0061: destroying instance
[ 8127.217933] usb 1-6: new high-speed USB device number 3 using ehci_hcd
[ 8127.343456] usb 1-6: New USB device found, idVendor=2040, idProduct=6513
[ 8127.350144] usb 1-6: New USB device strings: Mfr=0, Product=1, SerialNumber=2
[ 8127.357261] usb 1-6: Product: WinTV HVR-980
[ 8127.361428] usb 1-6: SerialNumber: 4028449018
[ 8127.366176] em28xx: init = 1, userspace_is_disabled = 0, needs firmware = 1
[ 8127.373153] em28xx: New device  WinTV HVR-980 @ 480 Mbps (2040:6513, interface 0, class 0)
[ 8127.381416] em28xx: Audio Vendor Class interface 0 found
[ 8127.386709] em28xx: Video interface 0 found
[ 8127.390879] em28xx: DVB interface 0 found
[ 8127.395049] em28xx #0: chip ID is em2882/em2883
[ 8127.542105] em28xx #0: i2c eeprom 00: 1a eb 67 95 40 20 13 65 d0 12 5c 03 82 1e 6a 18
[ 8127.550112] em28xx #0: i2c eeprom 10: 00 00 24 57 66 07 01 00 00 00 00 00 00 00 00 00
[ 8127.558090] em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 02 00 b8 00 00 00 5b 1c 00 00
[ 8127.566074] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 01 01 00 00 00 00
[ 8127.574065] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 8127.582050] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 8127.590037] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 18 03 34 00 30 00
[ 8127.598023] em28xx #0: i2c eeprom 70: 32 00 38 00 34 00 34 00 39 00 30 00 31 00 38 00
[ 8127.606008] em28xx #0: i2c eeprom 80: 00 00 1e 03 57 00 69 00 6e 00 54 00 56 00 20 00
[ 8127.613989] em28xx #0: i2c eeprom 90: 48 00 56 00 52 00 2d 00 39 00 38 00 30 00 00 00
[ 8127.621979] em28xx #0: i2c eeprom a0: 84 12 00 00 05 50 1a 7f d4 78 23 b1 fe d0 18 85
[ 8127.629967] em28xx #0: i2c eeprom b0: ff 00 00 00 04 84 0a 00 01 01 20 77 00 40 fa 40
[ 8127.637951] em28xx #0: i2c eeprom c0: 1d f0 74 02 01 00 01 79 4f 00 00 00 00 00 00 00
[ 8127.645938] em28xx #0: i2c eeprom d0: 84 12 00 00 05 50 1a 7f d4 78 23 b1 fe d0 18 85
[ 8127.653924] em28xx #0: i2c eeprom e0: ff 00 00 00 04 84 0a 00 01 01 20 77 00 40 fa 40
[ 8127.661912] em28xx #0: i2c eeprom f0: 1d f0 74 02 01 00 01 79 4f 00 00 00 00 00 00 00
[ 8127.669898] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x994b2bdd
[ 8127.676402] em28xx #0: EEPROM info:
[ 8127.679875] em28xx #0:	AC97 audio (5 sample rates)
[ 8127.684648] em28xx #0:	500mA max power
[ 8127.688384] em28xx #0:	Table at 0x24, strings=0x1e82, 0x186a, 0x0000
[ 8127.694714] em28xx #0: Identified as Hauppauge WinTV HVR 950 (card=16)
[ 8127.701218] tveeprom 0-0050: Hauppauge model 65201, rev A1C0, serial# 1917178
[ 8127.708327] tveeprom 0-0050: tuner model is Xceive XC3028 (idx 120, type 71)
[ 8127.715351] tveeprom 0-0050: TV standards PAL(B/G) PAL(I) PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xd4)
[ 8127.724451] tveeprom 0-0050: audio processor is None (idx 0)
[ 8127.730090] tveeprom 0-0050: has radio
[ 8127.735621] tvp5150 0-005c: chip found @ 0xb8 (em28xx #0)
[ 8127.788094] tvp5150 0-005c: tvp5150am1 detected.
[ 8127.810607] tuner 0-0061: Tuner -1 found with type(s) Radio TV.
[ 8127.816574] xc2028 0-0061: creating new instance
[ 8127.821183] xc2028 0-0061: type set to XCeive xc2028/xc3028 tuner

>>   	if (em28xx_boards[id->driver_info].needs_firmware &&
>> -	    is_usermodehelp_disabled()) {
>> -		printk_once(KERN_DEBUG DRIVER_NAME
>> -		            ": probe deferred for board %d.\n",
>> -		            (unsigned)id->driver_info);
>> +	    (!is_em28xx_initialized || is_usermodehelp_disabled())) {
>> +		printk(KERN_DEBUG DRIVER_NAME
>> +		       ": probe deferred for board %d.\n",
>> +		       (unsigned)id->driver_info);
>>   		return -EPROBE_DEFER;
>>   	}
>>   
>> @@ -3456,4 +3461,28 @@ static struct usb_driver em28xx_usb_driver = {
>>   	.id_table = em28xx_id_table,
>>   };
>>   
>> -module_usb_driver(em28xx_usb_driver);
> 
> Hint, if you are removing this macro, you can almost be assured that you
> are doing something wrong :)

:)

Regards,
Mauro
