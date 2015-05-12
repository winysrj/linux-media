Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58195 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932772AbbELOLY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 May 2015 10:11:24 -0400
Message-ID: <55520A08.1010605@iki.fi>
Date: Tue, 12 May 2015 17:11:20 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: poma <pomidorabelisima@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
CC: Michael Krufky <mkrufky@linuxtv.org>,
	Manu Abraham <abraham.manu@gmail.com>
Subject: Re: dvb_usb_af9015: command failed=1 _ kernel >=  4.1.x
References: <554C8E04.5090007@gmail.com> <554C9704.2040503@gmail.com> <554F352F.10301@gmail.com> <554FDAE7.4010906@gmail.com> <5550F842.3050604@gmail.com>
In-Reply-To: <5550F842.3050604@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/11/2015 09:43 PM, poma wrote:
> On 05/11/2015 12:25 AM, poma wrote:
>> On 10.05.2015 12:38, poma wrote:
>>> On 08.05.2015 12:59, poma wrote:
>>>> On 08.05.2015 12:20, poma wrote:
>>>>>
>>>>> [    0.000000] Linux version 4.0.2-200.fc21.x86_64 ...
>>>>>
>>>>> [    0.870875] usb 1-2: new high-speed USB device number 2 using ehci-pci
>>>>> [    0.990286] usb 1-2: New USB device found, idVendor=15a4, idProduct=9016
>>>>> [    0.992575] usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
>>>>> [    0.994859] usb 1-2: Product: DVB-T 2
>>>>>
>>>>> [    1.001398] usb 1-2: Manufacturer: Afatech
>>>>> [    1.003555] usb 1-2: SerialNumber: 010101010600001
>>>>> [    1.009194] Afatech DVB-T 2: Fixing fullspeed to highspeed interval: 10 -> 7
>>>>> [    1.011694] input: Afatech DVB-T 2 as /devices/pci0000:00/0000:00:02.1/usb1/1-2/1-2:1.1/0003:15A4:9016.0001/input/input5
>>>>> [    1.066814] hid-generic 0003:15A4:9016.0001: input,hidraw0: USB HID v1.01 Keyboard [Afatech DVB-T 2] on usb-0000:00:02.1-2/input1
>>>>>
>>>>> [   11.997119] usb 1-2: dvb_usb_v2: found a 'Afatech AF9015 reference design' in warm state
>>>>> [   12.206778] usb 1-2: dvb_usb_v2: will pass the complete MPEG2 transport stream to the software demuxer
>>>>> [   12.207412] DVB: registering new adapter (Afatech AF9015 reference design)
>>>>>
>>>>> [   12.286137] i2c i2c-13: af9013: firmware version 5.1.0.0
>>>>> [   12.289121] usb 1-2: DVB: registering adapter 0 frontend 0 (Afatech AF9013)...
>>>>> [   12.343650] mxl5007t 13-00c0: creating new instance
>>>>> [   12.346003] mxl5007t_get_chip_id: unknown rev (3f)
>>>>> [   12.346156] mxl5007t_get_chip_id: MxL5007T detected @ 13-00c0
>>>>> [   12.350371] usb 1-2: dvb_usb_v2: will pass the complete MPEG2 transport stream to the software demuxer
>>>>> [   12.350649] DVB: registering new adapter (Afatech AF9015 reference design)
>>>>> [   12.553632] i2c i2c-13: af9013: found a 'Afatech AF9013' in warm state
>>>>> [   12.557256] i2c i2c-13: af9013: firmware version 5.1.0.0
>>>>> [   12.563779] usb 1-2: DVB: registering adapter 1 frontend 0 (Afatech AF9013)...
>>>>> [   12.564554] mxl5007t 13-00c0: attaching existing instance
>>>>> [   12.567004] usb 1-2: dvb_usb_af9015: command failed=1
>>>>> [   12.567555] mxl5007t_soft_reset: 521: failed!
>>>>> [   12.569745] mxl5007t_attach: error -121 on line 907
>>>>> [   12.571231] usbcore: registered new interface driver dvb_usb_af9015
>>>>>
>>>>>
>>>>> $ lsdvb
>>>>>
>>>>> 		lsdvb: Simple utility to list PCI/PCIe DVB devices
>>>>> 		Version: 0.0.4
>>>>> 		Copyright (C) Manu Abraham
>>>>> $
>>>>>
>>>>
>>>>
>>>> Afatech AF9015 reference design:
>>>>
>>>> 3.18.12-200.fc21.x86_64        - OK
>>>>
>>>> 3.19.7-200.fc21.x86_64         - KO
>>>> 4.0.2-200.fc21.x86_64          - KO
>>>> 4.1.0-0.rc2.git3.1.fc23.x86_64 - KO
>>>>
>>>>
>>>> If you have a patch to test, shout loudly.
>>>>
>>>>
>>>
>>> Looks like the same bug:
>>> AVerMedia HD Volar (A867) - Afatech AF9033
>>> http://forum.sifteam.eu/sifbox-by-sif-team/125122-kernel-3-19-a867-xgaz-dove.html
>>>
>>> http://git.linuxtv.org/cgit.cgi/media_build.git - no positive effect.
>>>
>>>
>>> Ho ho ho
>>>
>>
>> It seems the 'lsdvb' is what made the device unusable after re/boot.
>> Of course this applies to kernel >= 3.19.x
>> The device has to be unplugged and after a minute or two plugged back to be usable again.
>>
>>
>> $ lsdvb
>>
>> 		lsdvb: Simple utility to list PCI/PCIe DVB devices
>> 		Version: 0.0.4
>> 		Copyright (C) Manu Abraham
>>
>> usb (5:0 -868620712:32665) on PCI Domain:-874755276 Bus:32665 Device:2098 Function:0
>> 	DEVICE:0 ADAPTER:0 FRONTEND:0 (Afatech AF9013)
>> 		 FE_OFDM Fmin=174MHz Fmax=862MHz
>> 	DEVICE:0 ADAPTER:1 FRONTEND:0 (Afatech AF9013)
>> 		 FE_OFDM Fmin=174MHz Fmax=862MHz
>>
>> $ dmesg
>> [   80.332837] usb 2-2: dvb_usb_af9015: command failed=1
>> [   80.332857] i2c i2c-13: af9013: i2c wr failed=-5 reg=d607 len=1
>> [   80.337837] usb 2-2: dvb_usb_af9015: command failed=1
>> [   80.337848] mxl5007t_write_reg: 472: failed!
>> [   80.337853] mxl5007t_sleep: error -121 on line 709
>> [   80.338324] usb 2-2: dvb_usb_af9015: command failed=1
>> [   80.338328] mxl5007t_write_reg: 472: failed!
>> [   80.338332] mxl5007t_sleep: error -121 on line 711
>>
>>
>>
>
>
> Furthermore, it is sufficient to re/boot to the latest kernels,
> and the device is K.O. again,
>
> e.g.
> # modinfo -n mxl5007t
> /lib/modules/4.1.0-0.rc3.git0.1.fc23.x86_64+debug/kernel/drivers/media/tuners/mxl5007t.ko.xz
>
> ...
> [   13.874536] i2c i2c-13: af9013: found a 'Afatech AF9013' in warm state
> [   13.878031] i2c i2c-13: af9013: firmware version 5.1.0.0
> [   13.884691] usb 1-2: DVB: registering adapter 1 frontend 0 (Afatech AF9013)...
> [   13.884942] mxl5007t 13-00c0: attaching existing instance
> [   13.887166] usb 1-2: dvb_usb_af9015: command failed=1
> [   13.887179] mxl5007t_soft_reset: 521: failed!
> [   13.888780] mxl5007t_attach: error -121 on line 907
> [   13.897808] usbcore: registered new interface driver dvb_usb_af9015
> ...
>
> # ls -al /dev/dvb
> ls: cannot access /dev/dvb: No such file or directory
>
>
> Keep in mind, this time it has nothing to do with 'lsdvb',
>
> # lsdvb
> -bash: /bin/lsdvb: Permission denied

It is that commit which causes the problem:
commit fe4860af002a4516dd878f7297b61e186c475b35
[media] [PATH,1/2] mxl5007 move reset to attach

... but I am pretty sure actual root of cause something else. Likely 
your second tuner chip is on reset/powered off and due to that it does 
not answer. I have almost similar device which works (DigitalNow TinyTwin).

Maybe I should try to test which are that tuner GPIO reset lines... but 
I am a bit lazy :/

regards
Antti

-- 
http://palosaari.fi/
