Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:36489 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161017AbbEUVYD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2015 17:24:03 -0400
Received: by wgbgq6 with SMTP id gq6so22734wgb.3
        for <linux-media@vger.kernel.org>; Thu, 21 May 2015 14:24:01 -0700 (PDT)
Message-ID: <555E4CEF.4000901@gmail.com>
Date: Thu, 21 May 2015 23:23:59 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>,
	linux-media <linux-media@vger.kernel.org>
CC: Michael Krufky <mkrufky@linuxtv.org>,
	Manu Abraham <abraham.manu@gmail.com>
Subject: Re: dvb_usb_af9015: command failed=1 _ kernel >=  4.1.x
References: <554C8E04.5090007@gmail.com> <554C9704.2040503@gmail.com> <554F352F.10301@gmail.com> <554FDAE7.4010906@gmail.com> <5550F842.3050604@gmail.com> <55520A08.1010605@iki.fi> <5552CB67.8070106@gmail.com> <5557CDBE.2030806@iki.fi> <555A3A48.2010002@gmail.com>
In-Reply-To: <555A3A48.2010002@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18.05.2015 21:15, poma wrote:
> On 17.05.2015 01:07, Antti Palosaari wrote:
...
>> try that
>> http://git.linuxtv.org/cgit.cgi/anttip/media_tree.git/commit/?h=af9015_mxl5007t_1
>>
>> Antti
>>
> 
> Thanks.
> For now, I have noticed, unlike before the EIT program data are updated in full and promptly.
> 
> I'll be back in a week.
> 
> 

No need to continue to test this patch because this is repeated:

BOOT from S5/Soft Off:

[    1.007886] usb 1-2: Product: DVB-T 2
[    1.032430] Afatech DVB-T 2: Fixing fullspeed to highspeed interval: 10 -> 7
[    1.035255] input: Afatech DVB-T 2 as /devices/pci0000:00/0000:00:02.1/usb1/1-2/1-2:1.1/0003:15A4:9016.0001/input/input5
[    1.089852] hid-generic 0003:15A4:9016.0001: input,hidraw0: USB HID v1.01 Keyboard [Afatech DVB-T 2] on usb-0000:00:02.1-2/input1
[   13.353105] usb 1-2: dvb_usb_v2: found a 'Afatech AF9015 reference design' in warm state
[   13.557671] usb 1-2: dvb_usb_v2: will pass the complete MPEG2 transport stream to the software demuxer
[   13.558315] DVB: registering new adapter (Afatech AF9015 reference design)
[   13.726582] usb 1-2: DVB: registering adapter 0 frontend 0 (Afatech AF9013)...
[   13.814649] mxl5007t 13-00c0: creating new instance
[   13.817588] mxl5007t_get_chip_id: MxL5007T.v4 detected @ 13-00c0
[   13.820460] mxl5007t_get_chip_id: MxL5007T.v4 detected @ 13-00c0
[   13.824594] usb 1-2: dvb_usb_v2: will pass the complete MPEG2 transport stream to the software demuxer
[   13.825234] DVB: registering new adapter (Afatech AF9015 reference design)
[   14.040582] usb 1-2: DVB: registering adapter 1 frontend 0 (Afatech AF9013)...
[   14.040921] mxl5007t 13-00c0: attaching existing instance
[   14.043201] usb 1-2: dvb_usb_af9015: command failed=1
[   14.043429] mxl5007t_read_reg: 505: failed!
[   14.043656] mxl5007t_get_chip_id: error -121 on line 824
[   14.043880] mxl5007t_get_chip_id: unable to identify device @ 13-00c0
[   14.044698] usb 1-2: dvb_usb_af9015: command failed=1
[   14.044911] mxl5007t_soft_reset: 527: failed!
[   14.046841] mxl5007t_attach: error -121 on line 914
[   14.051434] usbcore: registered new interface driver dvb_usb_af9015

$ ls /dev/dvb/
ls: cannot access /dev/dvb/: No such file or directory

# modprobe -rv dvb_usb_af9015 mxl5007t
rmmod dvb_usb_af9015
rmmod dvb_usb_v2
rmmod rc_core
rmmod dvb_core
rmmod mxl5007t

# modprobe -v dvb_usb_af9015
insmod /lib/modules/4.0.4-502.fc21.x86_64/kernel/drivers/media/rc/rc-core.ko.xz 
insmod /lib/modules/4.0.4-502.fc21.x86_64/kernel/drivers/media/dvb-core/dvb-core.ko.xz 
insmod /lib/modules/4.0.4-502.fc21.x86_64/kernel/drivers/media/usb/dvb-usb-v2/dvb_usb_v2.ko.xz 
insmod /lib/modules/4.0.4-502.fc21.x86_64/kernel/drivers/media/usb/dvb-usb-v2/dvb-usb-af9015.ko.xz 

[ 2101.659729] usbcore: deregistering interface driver dvb_usb_af9015
[ 2117.056136] usb 1-2: dvb_usb_v2: found a 'Afatech AF9015 reference design' in warm state
[ 2117.265520] usb 1-2: dvb_usb_v2: will pass the complete MPEG2 transport stream to the software demuxer
[ 2117.265607] DVB: registering new adapter (Afatech AF9015 reference design)
[ 2117.268348] i2c i2c-13: af9013: firmware version 5.1.0.0
[ 2117.274958] usb 1-2: DVB: registering adapter 0 frontend 0 (Afatech AF9013)...
[ 2117.280031] mxl5007t 13-00c0: creating new instance
[ 2117.281700] mxl5007t_get_chip_id: MxL5007T.v4 detected @ 13-00c0
[ 2117.284211] mxl5007t_get_chip_id: MxL5007T.v4 detected @ 13-00c0
[ 2117.287208] usb 1-2: dvb_usb_v2: will pass the complete MPEG2 transport stream to the software demuxer
[ 2117.287245] DVB: registering new adapter (Afatech AF9015 reference design)
[ 2117.493132] i2c i2c-13: af9013: found a 'Afatech AF9013' in warm state
[ 2117.496887] i2c i2c-13: af9013: firmware version 5.1.0.0
[ 2117.504373] usb 1-2: DVB: registering adapter 1 frontend 0 (Afatech AF9013)...
[ 2117.504664] mxl5007t 13-00c0: attaching existing instance
[ 2117.506848] usb 1-2: dvb_usb_af9015: command failed=1
[ 2117.506858] mxl5007t_read_reg: 505: failed!
[ 2117.506864] mxl5007t_get_chip_id: error -121 on line 824
[ 2117.506868] mxl5007t_get_chip_id: unable to identify device @ 13-00c0
[ 2117.507344] usb 1-2: dvb_usb_af9015: command failed=1
[ 2117.507350] mxl5007t_soft_reset: 527: failed!
[ 2117.509007] mxl5007t_attach: error -121 on line 914
[ 2117.511150] usbcore: registered new interface driver dvb_usb_af9015

$ ls /dev/dvb/
ls: cannot access /dev/dvb/: No such file or directory

REBOOT:

[    1.049265] usb 1-2: Product: DVB-T 2
[    1.067810] Afatech DVB-T 2: Fixing fullspeed to highspeed interval: 10 -> 7
[    1.068145] input: Afatech DVB-T 2 as /devices/pci0000:00/0000:00:02.1/usb1/1-2/1-2:1.1/0003:15A4:9016.0001/input/input5
[    1.118889] hid-generic 0003:15A4:9016.0001: input,hidraw0: USB HID v1.01 Keyboard [Afatech DVB-T 2] on usb-0000:00:02.1-2/input1
[   12.023590] usb 1-2: dvb_usb_v2: found a 'Afatech AF9015 reference design' in warm state
[   12.225419] usb 1-2: dvb_usb_v2: will pass the complete MPEG2 transport stream to the software demuxer
[   12.225524] DVB: registering new adapter (Afatech AF9015 reference design)
[   12.238958] usb 1-2: DVB: registering adapter 0 frontend 0 (Afatech AF9013)...
[   12.261783] mxl5007t 13-00c0: creating new instance
[   12.265081] mxl5007t_get_chip_id: MxL5007T.v4 detected @ 13-00c0
[   12.267236] mxl5007t_get_chip_id: MxL5007T.v4 detected @ 13-00c0
[   12.270335] usb 1-2: dvb_usb_v2: will pass the complete MPEG2 transport stream to the software demuxer
[   12.270376] DVB: registering new adapter (Afatech AF9015 reference design)
[   12.484761] usb 1-2: DVB: registering adapter 1 frontend 0 (Afatech AF9013)...
[   12.485016] mxl5007t 13-00c0: attaching existing instance
[   12.487225] usb 1-2: dvb_usb_af9015: command failed=1
[   12.487251] mxl5007t_read_reg: 505: failed!
[   12.487266] mxl5007t_get_chip_id: error -121 on line 824
[   12.487281] mxl5007t_get_chip_id: unable to identify device @ 13-00c0
[   12.487716] usb 1-2: dvb_usb_af9015: command failed=1
[   12.487753] mxl5007t_soft_reset: 527: failed!
[   12.489363] mxl5007t_attach: error -121 on line 914
[   12.490589] usbcore: registered new interface driver dvb_usb_af9015

$ ls /dev/dvb
ls: cannot access /dev/dvb: No such file or directory

$ uname -r
4.0.4-502.fc21.x86_64

