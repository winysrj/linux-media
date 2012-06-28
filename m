Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41329 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755245Ab2F1Rvk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jun 2012 13:51:40 -0400
Message-ID: <4FEC999E.9090609@redhat.com>
Date: Thu, 28 Jun 2012 14:51:26 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Antti Palosaari <crope@iki.fi>, Kay Sievers <kay@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFC 3/4] em28xx: Workaround for new udev versions
References: <4FE9169D.5020300@redhat.com> <1340739262-13747-1-git-send-email-mchehab@redhat.com> <1340739262-13747-4-git-send-email-mchehab@redhat.com> <20120626204242.GC3885@kroah.com> <4FEA27BE.8020306@redhat.com> <20120626212710.GA4572@kroah.com> <4FEA3120.7000504@redhat.com>
In-Reply-To: <4FEA3120.7000504@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 26-06-2012 19:01, Mauro Carvalho Chehab escreveu:
> Em 26-06-2012 18:27, Greg KH escreveu:
>> On Tue, Jun 26, 2012 at 06:21:02PM -0300, Mauro Carvalho Chehab wrote:
>>> Em 26-06-2012 17:42, Greg KH escreveu:
>>>> On Tue, Jun 26, 2012 at 04:34:21PM -0300, Mauro Carvalho Chehab wrote:
>>>>> New udev-182 seems to be buggy: even when usermode is enabled, it
>>>>> insists on needing that probe would defer any firmware requests.
>>>>> So, drivers with firmware need to defer probe for the first
>>>>> driver's core request, otherwise an useless penalty of 30 seconds
>>>>> happens, as udev will refuse to load any firmware.
>>>>>
>>>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>>>>> ---
>>>>>
>>>>> Note: this patch adds an ugly printk there, in order to allow testing it better.
>>>>> This will be removed at the final version.
>>>>>
>>>>>     drivers/media/video/em28xx/em28xx-cards.c |   39 +++++++++++++++++++++++++----
>>>>>     1 file changed, 34 insertions(+), 5 deletions(-)
>>>>>
>>>>> diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
>>>>> index 9229cd2..9a1c16c 100644
>>>>> --- a/drivers/media/video/em28xx/em28xx-cards.c
>>>>> +++ b/drivers/media/video/em28xx/em28xx-cards.c
>>>>> @@ -60,6 +60,8 @@ static unsigned int card[]     = {[0 ... (EM28XX_MAXBOARDS - 1)] = UNSET };
>>>>>     module_param_array(card,  int, NULL, 0444);
>>>>>     MODULE_PARM_DESC(card,     "card type");
>>>>>     
>>>>> +static bool is_em28xx_initialized;
>>>>> +
>>>>>     /* Bitmask marking allocated devices from 0 to EM28XX_MAXBOARDS - 1 */
>>>>>     static unsigned long em28xx_devused;
>>>>>     
>>>>> @@ -3167,11 +3169,14 @@ static int em28xx_usb_probe(struct usb_interface *interface,
>>>>>     	 * postponed, as udev may not be ready yet to honour firmware
>>>>>     	 * load requests.
>>>>>     	 */
>>>>> +printk("em28xx: init = %d, userspace_is_disabled = %d, needs firmware = %d\n",
>>>>> +	is_em28xx_initialized,
>>>>> +	is_usermodehelp_disabled(), em28xx_boards[id->driver_info].needs_firmware);
>>>>
>>>> debug code?
>>>
>>> Yes, temporary debug code, for people @linux-media that might be interested
>>> on testing the patch. It will be removed at the final version, of course.
>>>
>>>> Also, this doesn't seem wise.  probe() will be called and
>>>> is_em28xx_initialized will be 0 before it can be set if the device is
>>>> present when the module is loaded.  But, if a new device is added to the
>>>> system after probe() already runs, is_em28xx_initialized will be 1, yet
>>>> it isn't true for this new device.
>>>
>>> Yes.
>>
>> So you really want that?  That doesn't make any sense, sorry.
>>
>>>> So this doesn't seem like a valid solution, even if you were wanting to
>>>> paper over a udev bug.
>>>
>>> The problem with udev-182 is that it blocks firmware load while
>>> mode_init() is happening. Only after the end of module_init(), udev will
>>> handle request_firmware.
>>
>> How does udev "know" that module_init() is completed, or even in the
>> picture at all?  Is this due to the change to use kmod?
> 
> Yes, I suspect so. It is probably running on a single thread mode. So,
> while driver is loaading/probing, it is blocking request firmwares on
> that driver.
> 
>> And you really should be using the async firmware loading path, that
>> would solve this problem entirely, right?
> 
> As already explained, async firmware won't solve, as probe() cannot complete
> without firmware. Em28xx is a good media device Citizen (and it might be possible
> to use async firmware on this particular case), as the em28xx bridge
> firmware is stored on a ROM memory inside the chip, but devices based
> on Cypress FX2 CPU can only be probed after firmware load.
> 
>>
>>> This is what happens before this patch series:
>>>
>>> [    3.605783] tvp5150 0-005c: tvp5150am1 detected.
>>> [    3.627674] tuner 0-0061: Tuner -1 found with type(s) Radio TV.
>>> [    3.633695] xc2028 0-0061: creating new instance
>>> [    3.638406] xc2028 0-0061: type set to XCeive xc2028/xc3028 tuner
>>> [   64.422633] xc2028 0-0061: Error: firmware xc3028-v27.fw not found.
>>> [   64.429090] em28xx #0: Config register raw data: 0xd0
>>> [   64.434959] em28xx #0: AC97 vendor ID = 0xffffffff
>>> [   64.440206] em28xx #0: AC97 features = 0x6a90
>>> [   64.444654] em28xx #0: Empia 202 AC97 audio processor detected
>>> [   64.607494] em28xx #0: v4l2 driver version 0.1.3
>>> [  125.574760] xc2028 0-0061: Error: firmware xc3028-v27.fw not found.
>>> [  125.645012] em28xx #0: V4L2 video device registered as video0
>>> [  125.650851] em28xx #0: V4L2 VBI device registered as vbi0
>>>
>>> The 60s delay is due to the bug (firmware doesn't load there just
>>> because I didn't ask dracut to add it there).
>>
>> Ok, if you ask for firmware that you don't have, stalling is normal.
>> Not good though, and one big reason you should switch to using the async
>> model of firmware loading (a long time ago I wanted that to be the only
>> model, but I lost that argument...)
>>
>>> After the patch series, the artificial delay introduced due to udev-182
>>> goes away:
>>
>> Wait, if the firmware isn't present, how could any delay go away?  Why
>> would it go away?
>>
>> still confused,
> 
> Good point. I'll do more tests there, forcing dracut to store the firmware
> for this device at initfs and see what happens with and without the patch.
> 
> Maybe there's something else happening here.

The deferred probe() doesn't work as I would expect. It will only "flush" the
deferred events when a new device is plugged.

This is what happens with the patches applied and driver compiled as module
(so, the firmware file for xc3028 is there):

[   13.466116] Linux video capture interface: v2.00
[   14.161928] em28xx: init = 0, userspace_is_disabled = 0, needs firmware = 1
[   14.169149] em28xx: probe deferred for board 16.
[   14.169167] usb 1-6:1.0: Driver em28xx requests probe deferral
[   14.175271] usbcore: registered new interface driver em28xx
[   14.181062] em28xx driver loaded
[   14.616160] snd_hda_intel 0000:00:1b.0: irq 67 for MSI/MSI-X
...

[   14.810557] em28xx: init = 1, userspace_is_disabled = 0, needs firmware = 1
[   14.817698] em28xx: New device  WinTV HVR-980 @ 480 Mbps (2040:6513, interface 0, class 0)
[   14.826135] em28xx: Audio Vendor Class interface 0 found
...
[   16.570085] xc2028: Xcv2028/3028 init called!
...
[   16.581414] xc2028 3-0061: Reading firmware xc3028-v27.fw


However, If I remove the modules and re-insert them, with the device connected,
the em28xx device load fails:

[ 1081.216543] usbcore: registered new interface driver em28xx
[ 1081.222094] em28xx driver loaded

Only after connecting another device, the probe will happen:

[ 1093.278511] usb 1-6.4: new high-speed USB device number 11 using ehci_hcd
[ 1093.360211] usb 1-6.4: New USB device found, idVendor=eb1a, idProduct=2875
[ 1093.367074] usb 1-6.4: New USB device strings: Mfr=0, Product=1, SerialNumber=2
[ 1093.374363] usb 1-6.4: Product: USB 2875 Device
[ 1093.378876] usb 1-6.4: SerialNumber: 123456789ABCD?USB 2875 Device
[ 1093.385431] em28xx: init = 1, userspace_is_disabled = 0, needs firmware = 0
[ 1093.392449] em28xx: New device  USB 2875 Device @ 480 Mbps (eb1a:2875, interface 0, class 0)
[ 1093.400884] em28xx: DVB interface 0 found
[ 1093.405063] em28xx #0: chip ID is em2874
[ 1093.506333] em28xx #0: found i2c device @ 0xa0 [eeprom]
[ 1093.523324] em28xx #0: Your board has no unique USB ID.
[ 1093.528535] em28xx #0: A hint were successfully done, based on i2c devicelist hash.
[ 1093.536168] em28xx #0: This method is not 100% failproof.
[ 1093.541552] em28xx #0: If the board were missdetected, please email this log to:
[ 1093.548919] em28xx #0: 	V4L Mailing List  <linux-media@vger.kernel.org>
[ 1093.555508] em28xx #0: Board detected as EM2874 Leadership ISDBT
[ 1093.645024] em28xx #0: Identified as EM2874 Leadership ISDBT (card=77)
[ 1093.651536] em28xx #0: v4l2 driver version 0.1.3
[ 1093.660990] em28xx #0: V4L2 video device registered as video0
[ 1093.667177] em28xx: init = 1, userspace_is_disabled = 0, needs firmware = 1

The above logs are due to the new device that doesn't require any firmware:
As already said, em28xx firmware is written inside the chip's ROM. On this
device, both ISDB-T tuning and demod are provided by s921 frontend, and this
frontend doesn't require firmware. So, probing here is never deferred.

After finishing the non-deferred probe(), the deferred one happens:

[ 1093.674162] em28xx: New device  WinTV HVR-980 @ 480 Mbps (2040:6513, interface 0, class 0)
[ 1093.682398] em28xx: Audio Vendor Class interface 0 found
[ 1093.687693] em28xx: Video interface 0 found
[ 1093.691890] em28xx: DVB interface 0 found
[ 1093.696103] em28xx #1: chip ID is em2882/em2883
[ 1093.713968] s921: s921_attach: 
[ 1093.713972] DVB: registering new adapter (em28xx #0)
[ 1093.718934] dvb_register_frontend
[ 1093.722251] DVB: registering adapter 0 frontend 0 (Sharp S921)...
[ 1093.728421] dvb_frontend_clear_cache() Clearing cache for delivery system 8
[ 1093.736805] em28xx #0: Successfully loaded em28xx-dvb
[ 1093.741846] Em28xx: Initialized (Em28xx dvb Extension) extension
[ 1093.843211] em28xx #1: i2c eeprom 00: 1a eb 67 95 40 20 13 65 d0 12 5c 03 82 1e 6a 18
[ 1093.851221] em28xx #1: i2c eeprom 10: 00 00 24 57 66 07 01 00 00 00 00 00 00 00 00 00
[ 1093.859206] em28xx #1: i2c eeprom 20: 46 00 01 00 f0 10 02 00 b8 00 00 00 5b 1c 00 00
[ 1093.867189] em28xx #1: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 01 01 00 00 00 00
[ 1093.875178] em28xx #1: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 1093.883158] em28xx #1: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 1093.891200] em28xx #1: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 18 03 34 00 30 00
[ 1093.899192] em28xx #1: i2c eeprom 70: 32 00 38 00 34 00 34 00 39 00 30 00 31 00 38 00
[ 1093.907179] em28xx #1: i2c eeprom 80: 00 00 1e 03 57 00 69 00 6e 00 54 00 56 00 20 00
[ 1093.915165] em28xx #1: i2c eeprom 90: 48 00 56 00 52 00 2d 00 39 00 38 00 30 00 00 00
[ 1093.923150] em28xx #1: i2c eeprom a0: 84 12 00 00 05 50 1a 7f d4 78 23 b1 fe d0 18 85
[ 1093.931133] em28xx #1: i2c eeprom b0: ff 00 00 00 04 84 0a 00 01 01 20 77 00 40 fa 40
[ 1093.939132] em28xx #1: i2c eeprom c0: 1d f0 74 02 01 00 01 79 4f 00 00 00 00 00 00 00
[ 1093.947128] em28xx #1: i2c eeprom d0: 84 12 00 00 05 50 1a 7f d4 78 23 b1 fe d0 18 85
[ 1093.955118] em28xx #1: i2c eeprom e0: ff 00 00 00 04 84 0a 00 01 01 20 77 00 40 fa 40
[ 1093.963122] em28xx #1: i2c eeprom f0: 1d f0 74 02 01 00 01 79 4f 00 00 00 00 00 00 00
[ 1093.971113] em28xx #1: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x994b2bdd
[ 1093.977617] em28xx #1: EEPROM info:
[ 1093.981091] em28xx #1:	AC97 audio (5 sample rates)
[ 1093.985865] em28xx #1:	500mA max power
[ 1093.989599] em28xx #1:	Table at 0x24, strings=0x1e82, 0x186a, 0x0000
[ 1093.995929] em28xx #1: Identified as Hauppauge WinTV HVR 950 (card=16)
[ 1094.003609] tveeprom 4-0050: Hauppauge model 65201, rev A1C0, serial# 1917178
[ 1094.010755] tveeprom 4-0050: tuner model is Xceive XC3028 (idx 120, type 71)
[ 1094.017809] tveeprom 4-0050: TV standards PAL(B/G) PAL(I) PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xd4)
[ 1094.026962] tveeprom 4-0050: audio processor is None (idx 0)
[ 1094.032654] tveeprom 4-0050: has radio
[ 1094.038164] tvp5150 4-005c: chip found @ 0xb8 (em28xx #1)
[ 1094.091327] tvp5150 4-005c: tvp5150am1 detected.
[ 1094.114072] tuner 4-0061: Tuner -1 found with type(s) Radio TV.
[ 1094.120031] xc2028: Xcv2028/3028 init called!
[ 1094.120038] xc2028 4-0061: creating new instance
[ 1094.124644] xc2028 4-0061: type set to XCeive xc2028/xc3028 tuner
[ 1094.130716] xc2028 4-0061: xc2028_set_config called
[ 1094.130734] xc2028 4-0061: xc2028_set_analog_freq called
[ 1094.130736] xc2028 4-0061: generic_set_freq called
[ 1094.130739] xc2028 4-0061: should set frequency 567250 kHz
[ 1094.130741] xc2028 4-0061: check_firmware called
[ 1094.130743] xc2028 4-0061: load_all_firmwares called
[ 1094.130746] xc2028 4-0061: Reading firmware xc3028-v27.fw
[ 1094.131248] xc2028 4-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
[ 1094.140707] xc2028 4-0061: Reading firmware type BASE F8MHZ (3), id 0, size=8718.
[ 1094.140714] xc2028 4-0061: Reading firmware type BASE F8MHZ MTS (7), id 0, size=8712.
[ 1094.140719] xc2028 4-0061: Reading firmware type BASE FM (401), id 0, size=8562.
[ 1094.140725] xc2028 4-0061: Reading firmware type BASE FM INPUT1 (c01), id 0, size=8576.
[ 1094.140731] xc2028 4-0061: Reading firmware type BASE (1), id 0, size=8706.
[ 1094.140735] xc2028 4-0061: Reading firmware type BASE MTS (5), id 0, size=8682.
[ 1094.140739] xc2028 4-0061: Reading firmware type (0), id 100000007, size=161.
[ 1094.140741] xc2028 4-0061: Reading firmware type MTS (4), id 100000007, size=169.
[ 1094.140744] xc2028 4-0061: Reading firmware type (0), id 200000007, size=161.
[ 1094.140746] xc2028 4-0061: Reading firmware type MTS (4), id 200000007, size=169.
[ 1094.140748] xc2028 4-0061: Reading firmware type (0), id 400000007, size=161.
[ 1094.140750] xc2028 4-0061: Reading firmware type MTS (4), id 400000007, size=169.
[ 1094.140752] xc2028 4-0061: Reading firmware type (0), id 800000007, size=161.
[ 1094.140755] xc2028 4-0061: Reading firmware type MTS (4), id 800000007, size=169.
[ 1094.140757] xc2028 4-0061: Reading firmware type (0), id 3000000e0, size=161.
[ 1094.140759] xc2028 4-0061: Reading firmware type MTS (4), id 3000000e0, size=169.
[ 1094.140761] xc2028 4-0061: Reading firmware type (0), id c000000e0, size=161.
[ 1094.140764] xc2028 4-0061: Reading firmware type MTS (4), id c000000e0, size=169.
[ 1094.140766] xc2028 4-0061: Reading firmware type (0), id 200000, size=161.
[ 1094.140768] xc2028 4-0061: Reading firmware type MTS (4), id 200000, size=169.
[ 1094.140770] xc2028 4-0061: Reading firmware type (0), id 4000000, size=161.
[ 1094.140772] xc2028 4-0061: Reading firmware type MTS (4), id 4000000, size=169.
[ 1094.140775] xc2028 4-0061: Reading firmware type D2633 DTV6 ATSC (10030), id 0, size=149.
[ 1094.140778] xc2028 4-0061: Reading firmware type D2620 DTV6 QAM (68), id 0, size=149.
[ 1094.140781] xc2028 4-0061: Reading firmware type D2633 DTV6 QAM (70), id 0, size=149.
[ 1094.140784] xc2028 4-0061: Reading firmware type D2620 DTV7 (88), id 0, size=149.
[ 1094.140787] xc2028 4-0061: Reading firmware type D2633 DTV7 (90), id 0, size=149.
[ 1094.140790] xc2028 4-0061: Reading firmware type D2620 DTV78 (108), id 0, size=149.
[ 1094.140792] xc2028 4-0061: Reading firmware type D2633 DTV78 (110), id 0, size=149.
[ 1094.140795] xc2028 4-0061: Reading firmware type D2620 DTV8 (208), id 0, size=149.
[ 1094.140798] xc2028 4-0061: Reading firmware type D2633 DTV8 (210), id 0, size=149.
[ 1094.140800] xc2028 4-0061: Reading firmware type FM (400), id 0, size=135.
[ 1094.140803] xc2028 4-0061: Reading firmware type (0), id 10, size=161.
[ 1094.140805] xc2028 4-0061: Reading firmware type MTS (4), id 10, size=169.
[ 1094.140807] xc2028 4-0061: Reading firmware type (0), id 1000400000, size=169.
[ 1094.140809] xc2028 4-0061: Reading firmware type (0), id c00400000, size=161.
[ 1094.140812] xc2028 4-0061: Reading firmware type (0), id 800000, size=161.
[ 1094.140814] xc2028 4-0061: Reading firmware type (0), id 8000, size=161.
[ 1094.140816] xc2028 4-0061: Reading firmware type LCD (1000), id 8000, size=161.
[ 1094.140818] xc2028 4-0061: Reading firmware type LCD NOGD (3000), id 8000, size=161.
[ 1094.140821] xc2028 4-0061: Reading firmware type MTS (4), id 8000, size=169.
[ 1094.140823] xc2028 4-0061: Reading firmware type (0), id b700, size=161.
[ 1094.140825] xc2028 4-0061: Reading firmware type LCD (1000), id b700, size=161.
[ 1094.140827] xc2028 4-0061: Reading firmware type LCD NOGD (3000), id b700, size=161.
[ 1094.140830] xc2028 4-0061: Reading firmware type (0), id 2000, size=161.
[ 1094.140832] xc2028 4-0061: Reading firmware type MTS (4), id b700, size=169.
[ 1094.140834] xc2028 4-0061: Reading firmware type MTS LCD (1004), id b700, size=169.
[ 1094.140837] xc2028 4-0061: Reading firmware type MTS LCD NOGD (3004), id b700, size=169.
[ 1094.140840] xc2028 4-0061: Reading firmware type SCODE HAS_IF_3280 (60000000), id 0, size=192.
[ 1094.140843] xc2028 4-0061: Reading firmware type SCODE HAS_IF_3300 (60000000), id 0, size=192.
[ 1094.140846] xc2028 4-0061: Reading firmware type SCODE HAS_IF_3440 (60000000), id 0, size=192.
[ 1094.140849] xc2028 4-0061: Reading firmware type SCODE HAS_IF_3460 (60000000), id 0, size=192.
[ 1094.140852] xc2028 4-0061: Reading firmware type DTV6 ATSC OREN36 SCODE HAS_IF_3800 (60210020), id 0, size=192.
[ 1094.140856] xc2028 4-0061: Reading firmware type SCODE HAS_IF_4000 (60000000), id 0, size=192.
[ 1094.140859] xc2028 4-0061: Reading firmware type DTV6 ATSC TOYOTA388 SCODE HAS_IF_4080 (60410020), id 0, size=192.
[ 1094.140862] xc2028 4-0061: Reading firmware type SCODE HAS_IF_4200 (60000000), id 0, size=192.
[ 1094.140865] xc2028 4-0061: Reading firmware type MONO SCODE HAS_IF_4320 (60008000), id 8000, size=192.
[ 1094.140869] xc2028 4-0061: Reading firmware type SCODE HAS_IF_4450 (60000000), id 0, size=192.
[ 1094.140872] xc2028 4-0061: Reading firmware type MTS LCD NOGD MONO IF SCODE HAS_IF_4500 (6002b004), id b700, size=192.
[ 1094.140876] xc2028 4-0061: Reading firmware type LCD NOGD IF SCODE HAS_IF_4600 (60023000), id 8000, size=192.
[ 1094.140880] xc2028 4-0061: Reading firmware type DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0, size=192.
[ 1094.140884] xc2028 4-0061: Reading firmware type SCODE HAS_IF_4940 (60000000), id 0, size=192.
[ 1094.140887] xc2028 4-0061: Reading firmware type SCODE HAS_IF_5260 (60000000), id 0, size=192.
[ 1094.140890] xc2028 4-0061: Reading firmware type MONO SCODE HAS_IF_5320 (60008000), id f00000007, size=192.
[ 1094.140893] xc2028 4-0061: Reading firmware type DTV7 DTV78 DTV8 DIBCOM52 CHINA SCODE HAS_IF_5400 (65000380), id 0, size=192.
[ 1094.140897] xc2028 4-0061: Reading firmware type DTV6 ATSC OREN538 SCODE HAS_IF_5580 (60110020), id 0, size=192.
[ 1094.140901] xc2028 4-0061: Reading firmware type SCODE HAS_IF_5640 (60000000), id 300000007, size=192.
[ 1094.140904] xc2028 4-0061: Reading firmware type SCODE HAS_IF_5740 (60000000), id c00000007, size=192.
[ 1094.140907] xc2028 4-0061: Reading firmware type SCODE HAS_IF_5900 (60000000), id 0, size=192.
[ 1094.140910] xc2028 4-0061: Reading firmware type MONO SCODE HAS_IF_6000 (60008000), id c04c000f0, size=192.
[ 1094.140913] xc2028 4-0061: Reading firmware type DTV6 QAM ATSC LG60 F6MHZ SCODE HAS_IF_6200 (68050060), id 0, size=192.
[ 1094.140917] xc2028 4-0061: Reading firmware type SCODE HAS_IF_6240 (60000000), id 10, size=192.
[ 1094.140920] xc2028 4-0061: Reading firmware type MONO SCODE HAS_IF_6320 (60008000), id 200000, size=192.
[ 1094.140923] xc2028 4-0061: Reading firmware type SCODE HAS_IF_6340 (60000000), id 200000, size=192.
[ 1094.140926] xc2028 4-0061: Reading firmware type MONO SCODE HAS_IF_6500 (60008000), id c044000e0, size=192.
[ 1094.140929] xc2028 4-0061: Reading firmware type DTV6 ATSC ATI638 SCODE HAS_IF_6580 (60090020), id 0, size=192.
[ 1094.140933] xc2028 4-0061: Reading firmware type SCODE HAS_IF_6600 (60000000), id 3000000e0, size=192.
[ 1094.140936] xc2028 4-0061: Reading firmware type MONO SCODE HAS_IF_6680 (60008000), id 3000000e0, size=192.
[ 1094.140939] xc2028 4-0061: Reading firmware type DTV6 ATSC TOYOTA794 SCODE HAS_IF_8140 (60810020), id 0, size=192.
[ 1094.140942] xc2028 4-0061: Reading firmware type SCODE HAS_IF_8200 (60000000), id 0, size=192.
[ 1094.140950] xc2028 4-0061: Firmware files loaded.
[ 1094.140952] xc2028 4-0061: checking firmware, user requested type=MTS (4), id 000000000000b700, scode_tbl (0), scode_nr 0
[ 1094.173746] xc2028 4-0061: load_firmware called
[ 1094.173749] xc2028 4-0061: seek_firmware called, want type=BASE MTS (5), id 0000000000000000.
[ 1094.173755] xc2028 4-0061: Found firmware for type=BASE MTS (5), id 0000000000000000.
[ 1094.173759] xc2028 4-0061: Loading firmware for type=BASE MTS (5), id 0000000000000000.
[ 1095.319660] xc2028 4-0061: Load init1 firmware, if exists
[ 1095.319664] xc2028 4-0061: load_firmware called
[ 1095.319666] xc2028 4-0061: seek_firmware called, want type=BASE INIT1 MTS (4005), id 0000000000000000.
[ 1095.319672] xc2028 4-0061: Can't find firmware for type=BASE INIT1 MTS (4005), id 0000000000000000.
[ 1095.319677] xc2028 4-0061: load_firmware called
[ 1095.319680] xc2028 4-0061: seek_firmware called, want type=BASE INIT1 MTS (4005), id 0000000000000000.
[ 1095.319685] xc2028 4-0061: Can't find firmware for type=BASE INIT1 MTS (4005), id 0000000000000000.
[ 1095.319690] xc2028 4-0061: load_firmware called
[ 1095.319692] xc2028 4-0061: seek_firmware called, want type=MTS (4), id 000000000000b700.
[ 1095.319696] xc2028 4-0061: Found firmware for type=MTS (4), id 000000000000b700.
[ 1095.319700] xc2028 4-0061: Loading firmware for type=MTS (4), id 000000000000b700.
[ 1095.345750] xc2028 4-0061: Trying to load scode 0
[ 1095.345754] xc2028 4-0061: load_scode called
[ 1095.345756] xc2028 4-0061: seek_firmware called, want type=MTS SCODE (20000004), id 000000000000b700.
[ 1095.345762] xc2028 4-0061: Found firmware for type=MTS SCODE (20000004), id 000000000000b700.
[ 1095.345766] xc2028 4-0061: Loading SCODE for type=MTS LCD NOGD MONO IF SCODE HAS_IF_4500 (6002b004), id 000000000000b700.
[ 1095.359368] xc2028 4-0061: xc2028_get_reg 0004 called
[ 1095.360387] xc2028 4-0061: xc2028_get_reg 0008 called
[ 1095.361389] xc2028 4-0061: Device is Xceive 3028 version 1.0, firmware version 2.7

The last log shows that the firmware load went fine and that the device got successuly bind/recognized,
as the get_firmware_version firmware call returned the expected firmware version (2.7).

So, if we go to the deferred probe(), we'll need to add a way to queue the deferred probe after
the end of the driver's load.

/me is still trying to figure out an approach that would work.

Regards,
Mauro
