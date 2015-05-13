Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:33051 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559AbbEMD42 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 May 2015 23:56:28 -0400
Received: by wicmx19 with SMTP id mx19so471278wic.0
        for <linux-media@vger.kernel.org>; Tue, 12 May 2015 20:56:27 -0700 (PDT)
Message-ID: <5552CB67.8070106@gmail.com>
Date: Wed, 13 May 2015 05:56:23 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>,
	linux-media <linux-media@vger.kernel.org>
CC: Michael Krufky <mkrufky@linuxtv.org>,
	Manu Abraham <abraham.manu@gmail.com>
Subject: Re: dvb_usb_af9015: command failed=1 _ kernel >=  4.1.x
References: <554C8E04.5090007@gmail.com> <554C9704.2040503@gmail.com> <554F352F.10301@gmail.com> <554FDAE7.4010906@gmail.com> <5550F842.3050604@gmail.com> <55520A08.1010605@iki.fi>
In-Reply-To: <55520A08.1010605@iki.fi>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12.05.2015 16:11, Antti Palosaari wrote:
> On 05/11/2015 09:43 PM, poma wrote:
>> On 05/11/2015 12:25 AM, poma wrote:
>>> On 10.05.2015 12:38, poma wrote:
>>>> On 08.05.2015 12:59, poma wrote:
>>>>> On 08.05.2015 12:20, poma wrote:
>>>>>>
>>>>>> [    0.000000] Linux version 4.0.2-200.fc21.x86_64 ...
>>>>>>
>>>>>> [    0.870875] usb 1-2: new high-speed USB device number 2 using ehci-pci
>>>>>> [    0.990286] usb 1-2: New USB device found, idVendor=15a4, idProduct=9016
>>>>>> [    0.992575] usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
>>>>>> [    0.994859] usb 1-2: Product: DVB-T 2
>>>>>>
>>>>>> [    1.001398] usb 1-2: Manufacturer: Afatech
>>>>>> [    1.003555] usb 1-2: SerialNumber: 010101010600001
>>>>>> [    1.009194] Afatech DVB-T 2: Fixing fullspeed to highspeed interval: 10 -> 7
>>>>>> [    1.011694] input: Afatech DVB-T 2 as /devices/pci0000:00/0000:00:02.1/usb1/1-2/1-2:1.1/0003:15A4:9016.0001/input/input5
>>>>>> [    1.066814] hid-generic 0003:15A4:9016.0001: input,hidraw0: USB HID v1.01 Keyboard [Afatech DVB-T 2] on usb-0000:00:02.1-2/input1
>>>>>>
>>>>>> [   11.997119] usb 1-2: dvb_usb_v2: found a 'Afatech AF9015 reference design' in warm state
>>>>>> [   12.206778] usb 1-2: dvb_usb_v2: will pass the complete MPEG2 transport stream to the software demuxer
>>>>>> [   12.207412] DVB: registering new adapter (Afatech AF9015 reference design)
>>>>>>
>>>>>> [   12.286137] i2c i2c-13: af9013: firmware version 5.1.0.0
>>>>>> [   12.289121] usb 1-2: DVB: registering adapter 0 frontend 0 (Afatech AF9013)...
>>>>>> [   12.343650] mxl5007t 13-00c0: creating new instance
>>>>>> [   12.346003] mxl5007t_get_chip_id: unknown rev (3f)
>>>>>> [   12.346156] mxl5007t_get_chip_id: MxL5007T detected @ 13-00c0
>>>>>> [   12.350371] usb 1-2: dvb_usb_v2: will pass the complete MPEG2 transport stream to the software demuxer
>>>>>> [   12.350649] DVB: registering new adapter (Afatech AF9015 reference design)
>>>>>> [   12.553632] i2c i2c-13: af9013: found a 'Afatech AF9013' in warm state
>>>>>> [   12.557256] i2c i2c-13: af9013: firmware version 5.1.0.0
>>>>>> [   12.563779] usb 1-2: DVB: registering adapter 1 frontend 0 (Afatech AF9013)...
>>>>>> [   12.564554] mxl5007t 13-00c0: attaching existing instance
>>>>>> [   12.567004] usb 1-2: dvb_usb_af9015: command failed=1
>>>>>> [   12.567555] mxl5007t_soft_reset: 521: failed!
>>>>>> [   12.569745] mxl5007t_attach: error -121 on line 907
>>>>>> [   12.571231] usbcore: registered new interface driver dvb_usb_af9015
>>>>>>
>>>>>>
>>>>>> $ lsdvb
>>>>>>
>>>>>> 		lsdvb: Simple utility to list PCI/PCIe DVB devices
>>>>>> 		Version: 0.0.4
>>>>>> 		Copyright (C) Manu Abraham
>>>>>> $
>>>>>>
>>>>>
>>>>>
>>>>> Afatech AF9015 reference design:
>>>>>
>>>>> 3.18.12-200.fc21.x86_64        - OK
>>>>>
>>>>> 3.19.7-200.fc21.x86_64         - KO
>>>>> 4.0.2-200.fc21.x86_64          - KO
>>>>> 4.1.0-0.rc2.git3.1.fc23.x86_64 - KO
>>>>>
>>>>>
>>>>> If you have a patch to test, shout loudly.
>>>>>
>>>>>
>>>>
>>>> Looks like the same bug:
>>>> AVerMedia HD Volar (A867) - Afatech AF9033
>>>> http://forum.sifteam.eu/sifbox-by-sif-team/125122-kernel-3-19-a867-xgaz-dove.html
>>>>
>>>> http://git.linuxtv.org/cgit.cgi/media_build.git - no positive effect.
>>>>
>>>>
>>>> Ho ho ho
>>>>
>>>
>>> It seems the 'lsdvb' is what made the device unusable after re/boot.
>>> Of course this applies to kernel >= 3.19.x
>>> The device has to be unplugged and after a minute or two plugged back to be usable again.
>>>
>>>
>>> $ lsdvb
>>>
>>> 		lsdvb: Simple utility to list PCI/PCIe DVB devices
>>> 		Version: 0.0.4
>>> 		Copyright (C) Manu Abraham
>>>
>>> usb (5:0 -868620712:32665) on PCI Domain:-874755276 Bus:32665 Device:2098 Function:0
>>> 	DEVICE:0 ADAPTER:0 FRONTEND:0 (Afatech AF9013)
>>> 		 FE_OFDM Fmin=174MHz Fmax=862MHz
>>> 	DEVICE:0 ADAPTER:1 FRONTEND:0 (Afatech AF9013)
>>> 		 FE_OFDM Fmin=174MHz Fmax=862MHz
>>>
>>> $ dmesg
>>> [   80.332837] usb 2-2: dvb_usb_af9015: command failed=1
>>> [   80.332857] i2c i2c-13: af9013: i2c wr failed=-5 reg=d607 len=1
>>> [   80.337837] usb 2-2: dvb_usb_af9015: command failed=1
>>> [   80.337848] mxl5007t_write_reg: 472: failed!
>>> [   80.337853] mxl5007t_sleep: error -121 on line 709
>>> [   80.338324] usb 2-2: dvb_usb_af9015: command failed=1
>>> [   80.338328] mxl5007t_write_reg: 472: failed!
>>> [   80.338332] mxl5007t_sleep: error -121 on line 711
>>>
>>>
>>>
>>
>>
>> Furthermore, it is sufficient to re/boot to the latest kernels,
>> and the device is K.O. again,
>>
>> e.g.
>> # modinfo -n mxl5007t
>> /lib/modules/4.1.0-0.rc3.git0.1.fc23.x86_64+debug/kernel/drivers/media/tuners/mxl5007t.ko.xz
>>
>> ...
>> [   13.874536] i2c i2c-13: af9013: found a 'Afatech AF9013' in warm state
>> [   13.878031] i2c i2c-13: af9013: firmware version 5.1.0.0
>> [   13.884691] usb 1-2: DVB: registering adapter 1 frontend 0 (Afatech AF9013)...
>> [   13.884942] mxl5007t 13-00c0: attaching existing instance
>> [   13.887166] usb 1-2: dvb_usb_af9015: command failed=1
>> [   13.887179] mxl5007t_soft_reset: 521: failed!
>> [   13.888780] mxl5007t_attach: error -121 on line 907
>> [   13.897808] usbcore: registered new interface driver dvb_usb_af9015
>> ...
>>
>> # ls -al /dev/dvb
>> ls: cannot access /dev/dvb: No such file or directory
>>
>>
>> Keep in mind, this time it has nothing to do with 'lsdvb',
>>
>> # lsdvb
>> -bash: /bin/lsdvb: Permission denied
> 
> It is that commit which causes the problem:
> commit fe4860af002a4516dd878f7297b61e186c475b35
> [media] [PATH,1/2] mxl5007 move reset to attach
> 
> ... but I am pretty sure actual root of cause something else. Likely 
> your second tuner chip is on reset/powered off and due to that it does 
> not answer. I have almost similar device which works (DigitalNow TinyTwin).
> 
> Maybe I should try to test which are that tuner GPIO reset lines... but 
> I am a bit lazy :/
> 
> regards
> Antti
> 

Is a beer keg enough as bribe? :)
Just do not say that you drink juice.

After the reverting of all changes
http://git.linuxtv.org/cgit.cgi/media_tree.git/log/drivers/media/tuners/mxl5007t.c

device now survives both, 'lsdvb' and rc kernels.

Besides, despite all this, this device is already not working at its full potential.
One of the tuners can withstand a few hours and then hangs.
After that, in the application e.g. vlc is needed to select the second tuner and so continue to use the device.
So this is actually a "single-seater" as Formula 1.
Vroom vroom!


 mxl5007t.c |   28 +++++-----------------------
 1 file changed, 5 insertions(+), 23 deletions(-)

--- a/drivers/media/tuners/mxl5007t.c	2015-05-13 04:50:18.362256795 +0200
+++ b/drivers/media/tuners/mxl5007t.c	2015-05-13 05:05:15.070996638 +0200
@@ -374,6 +374,7 @@
 	mxl5007t_set_if_freq_bits(state, cfg->if_freq_hz, cfg->invert_if);
 	mxl5007t_set_xtal_freq_bits(state, cfg->xtal_freq_hz);
 
+	set_reg_bits(state->tab_init, 0x04, 0x01, cfg->loop_thru_enable);
 	set_reg_bits(state->tab_init, 0x03, 0x08, cfg->clk_out_enable << 3);
 	set_reg_bits(state->tab_init, 0x03, 0x07, cfg->clk_out_amp);
 
@@ -530,6 +531,10 @@
 	struct reg_pair_t *init_regs;
 	int ret;
 
+	ret = mxl5007t_soft_reset(state);
+	if (mxl_fail(ret))
+		goto fail;
+
 	/* calculate initialization reg array */
 	init_regs = mxl5007t_calc_init_regs(state, mode);
 
@@ -896,29 +901,6 @@
 		break;
 	}
 
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 1);
-
-	ret = mxl5007t_soft_reset(state);
-
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 0);
-
-	if (mxl_fail(ret))
-		goto fail;
-
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 1);
-
-	ret = mxl5007t_write_reg(state, 0x04,
-		state->config->loop_thru_enable);
-
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 0);
-
-	if (mxl_fail(ret))
-		goto fail;
-
 	fe->tuner_priv = state;
 
 	mutex_unlock(&mxl5007t_list_mutex);


$ modinfo mxl5007t
filename:       /lib/modules/4.1.0-0.rc3.git1.1.fc23.x86_64/updates/mxl5007t.ko
version:        0.2
license:        GPL
author:         Michael Krufky <mkrufky@linuxtv.org>
description:    MaxLinear MxL5007T Silicon IC tuner driver
srcversion:     72D27DB6EF6CEC612700FB9
depends:        
intree:         Y
vermagic:       4.1.0-0.rc3.git1.1.fc23.x86_64 SMP mod_unload 
parm:           debug:set debug level (int)


$ dmesg
[    1.114202] usb 1-2: new high-speed USB device number 2 using ehci-pci
[    1.235071] usb 1-2: New USB device found, idVendor=15a4, idProduct=9016
[    1.237463] usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    1.239831] usb 1-2: Product: DVB-T 2
[    1.242163] usb 1-2: Manufacturer: Afatech
[    1.244422] usb 1-2: SerialNumber: 010101010600001
[    1.251607] Afatech DVB-T 2: Fixing fullspeed to highspeed interval: 10 -> 7
[    1.254602] input: Afatech DVB-T 2 as /devices/pci0000:00/0000:00:02.1/usb1/1-2/1-2:1.1/0003:15A4:9016.0001/input/input5
[    1.311052] hid-generic 0003:15A4:9016.0001: input,hidraw0: USB HID v1.01 Keyboard [Afatech DVB-T 2] on usb-0000:00:02.1-2/input1
[   14.326420] usb 1-2: dvb_usb_v2: found a 'Afatech AF9015 reference design' in warm state
[   14.563618] usb 1-2: dvb_usb_v2: will pass the complete MPEG2 transport stream to the software demuxer
[   14.563854] DVB: registering new adapter (Afatech AF9015 reference design)
[   14.622564] usb 1-2: DVB: registering adapter 0 frontend 0 (Afatech AF9013)...
[   14.659556] mxl5007t: module verification failed: signature and/or required key missing - tainting kernel
[   14.660903] mxl5007t 13-00c0: creating new instance
[   14.663714] mxl5007t_get_chip_id: unknown rev (3f)
[   14.663727] mxl5007t_get_chip_id: MxL5007T detected @ 13-00c0
[   14.664450] usb 1-2: dvb_usb_v2: will pass the complete MPEG2 transport stream to the software demuxer
[   14.664603] DVB: registering new adapter (Afatech AF9015 reference design)
[   14.882505] usb 1-2: DVB: registering adapter 1 frontend 0 (Afatech AF9013)...
[   14.883176] mxl5007t 13-00c0: attaching existing instance
[   14.905227] input: Afatech AF9015 reference design as /devices/pci0000:00/0000:00:02.1/usb1/1-2/rc/rc0/input14
[   14.907885] rc0: Afatech AF9015 reference design as /devices/pci0000:00/0000:00:02.1/usb1/1-2/rc/rc0
[   14.907917] usb 1-2: dvb_usb_v2: schedule remote query interval to 500 msecs
[   14.908170] usb 1-2: dvb_usb_v2: 'Afatech AF9015 reference design' successfully initialized and connected
[   14.908490] usbcore: registered new interface driver dvb_usb_af9015


$ lsdvb 

		lsdvb: Simple utility to list PCI/PCIe DVB devices
		Version: 0.0.4
		Copyright (C) Manu Abraham

usb (5:0 -956221864:32726) on PCI Domain:-962356428 Bus:32726 Device:2098 Function:0
	DEVICE:0 ADAPTER:0 FRONTEND:0 (Afatech AF9013) 
		 FE_OFDM Fmin=174MHz Fmax=862MHz
	DEVICE:0 ADAPTER:1 FRONTEND:0 (Afatech AF9013) 
		 FE_OFDM Fmin=174MHz Fmax=862MHz


$ dmesg
[  306.258474] usb 1-2: dvb_usb_af9015: command failed=1
[  306.258500] i2c i2c-13: af9013: i2c wr failed=-5 reg=d607 len=1
[  306.264805] usb 1-2: dvb_usb_af9015: command failed=1
[  306.264819] mxl5007t_write_reg: 473: failed!
[  306.264826] mxl5007t_sleep: error -121 on line 714
[  306.265298] usb 1-2: dvb_usb_af9015: command failed=1
[  306.265306] mxl5007t_write_reg: 473: failed!
[  306.265309] mxl5007t_sleep: error -121 on line 716


