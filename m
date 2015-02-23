Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:50523 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbbBWUZi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2015 15:25:38 -0500
Received: by mail-wi0-f182.google.com with SMTP id l15so20388020wiw.3
        for <linux-media@vger.kernel.org>; Mon, 23 Feb 2015 12:25:37 -0800 (PST)
Message-ID: <54EB8C86.3040700@gmail.com>
Date: Mon, 23 Feb 2015 21:24:38 +0100
From: Gilles Risch <gilles.risch@gmail.com>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
CC: Antti Palosaari <crope@iki.fi>,
	Benjamin Larsson <benjamin@southpole.se>,
	Olli Salonen <olli.salonen@iki.fi>
Subject: Re: Linux TV support Elgato EyeTV hybrid
References: <CALnjqVkteEsFGQXRdh3exzGrqdC=Qw4guSGRT_pCF50WjGqy1g@mail.gmail.com> <CAAZRmGwmNhczjXNXdKkotS0YZ8Tc+kKb4b+SyNN_8KVj2H8xuQ@mail.gmail.com> <54E9DDFE.4010507@gmail.com> <54EA3633.3030805@southpole.se> <54EA4A3B.9060000@iki.fi>
In-Reply-To: <54EA4A3B.9060000@iki.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/22/2015 10:29 PM, Antti Palosaari wrote:
> On 02/22/2015 10:04 PM, Benjamin Larsson wrote:
>> On 02/22/2015 02:47 PM, Gilles Risch wrote:
>>> Hi,
>>>
>>> most of the used components are identified:
>>> - USB Controller: Empia EM2884
>>> - Stereo A/V Decoder: Micronas AVF 49x0B
>>> - Hybrid Channel Decoder: Micronas DRX-K DRX3926K:A3 0.9.0
>>> The only ambiguity is the tuner, but I think it could be a Xceive 
>>> XC5000
>>
>> This sounds like the Hauppauge WinTV HVR-930C:
>>
>> http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-930C
>
> It is pretty similar than 930C but not same. Compare pictures from my 
> blog and those on LinuxTV wiki. PCB is different.
>
> http://www.linuxtv.org/wiki/index.php/Elgato_EyeTV_hybrid
> http://blog.palosaari.fi/2013/06/naked-hardware-10-hauppauge-wintv-hvr.html 
>
I persuaded my laptop to identify the stick ass WinTV-HVR-930C:
     $ modprobe em28xx card=81
     $ echo 0fd9 0018 > /sys/bus/usb/drivers/em28xx/new_id
     $ dmesg
     ...
[  128.893703] media: Linux media interface: v0.10
[  128.910043] Linux video capture interface: v2.00
[  128.910047] WARNING: You are using an experimental version of the 
media stack.
[  128.910048]     As the driver is backported to an older kernel, it 
doesn't offer
[  128.910049]     enough quality for its usage in production.
[  128.910049]     Use it with care.
[  128.910050] Latest git patches (needed if you report a bug to 
linux-media@vger.kernel.org):
[  128.910051]     135f9be9194cf7778eb73594aa55791b229cf27c [media] 
dvb_frontend: start media pipeline while thread is running
[  128.910052]     0f0fa90bd035fa15106799b813d4f0315d99f47e [media] 
cx231xx: enable tuner->decoder link at videobuf start
[  128.910053]     9239effd53d47e3cd9c653830c8465c0a3a427dc [media] 
dvb-frontend: enable tuner link when the FE thread starts
[  128.942061] usbcore: registered new interface driver em28xx
[  141.148295] usb 2-6: new high-speed USB device number 3 using ehci_hcd
[  141.282672] usb 2-6: New USB device found, idVendor=0fd9, idProduct=0018
[  141.282681] usb 2-6: New USB device strings: Mfr=3, Product=1, 
SerialNumber=2
[  141.282688] usb 2-6: Product: EyeTV Hybrid
[  141.282693] usb 2-6: Manufacturer: Elgato
[  141.282697] usb 2-6: SerialNumber: 100904010917
[  141.283585] em28xx: New device Elgato EyeTV Hybrid @ 480 Mbps 
(0fd9:0018, interface 0, class 0)
[  141.283593] em28xx: Audio interface 0 found (Vendor Class)
[  141.283599] em28xx: Video interface 0 found: isoc
[  141.283604] em28xx: DVB interface 0 found: isoc
[  141.283744] em28xx: chip ID is em2884
[  141.343640] em2884 #0: EEPROM ID = 26 00 01 00, EEPROM hash = 0x1a01bca5
[  141.343647] em2884 #0: EEPROM info:
[  141.343653] em2884 #0:     microcode start address = 0x0004, boot 
configuration = 0x01
[  141.351257] em2884 #0:     I2S audio, 5 sample rates
[  141.351264] em2884 #0:     500mA max power
[  141.351271] em2884 #0:     Table at offset 0x27, strings=0x1a78, 
0x1a92, 0x0e6a
[  141.351416] em2884 #0: Identified as Hauppauge WinTV HVR 930C (card=81)
[  141.354712] tveeprom 11-0050: Encountered bad packet header [30]. 
Corrupt or not a Hauppauge eeprom.
[  141.354721] em2884 #0: analog set to isoc mode.
[  141.354726] em2884 #0: dvb set to isoc mode.
[  141.395223] em2884 #0: Binding audio extension
[  141.395226] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
[  141.395227] em28xx-audio.c: Copyright (C) 2007-2014 Mauro Carvalho Chehab
[  141.395256] em2884 #0: Endpoint 0x83 high-speed on intf 0 alt 7 
interval = 8, size 196
[  141.395258] em2884 #0: Number of URBs: 1, with 64 packets and 192 size
[  141.395458] em2884 #0: Audio extension successfully initialized
[  141.395460] em28xx: Registered (Em28xx Audio Extension) extension
[  141.423608] WARNING: You are using an experimental version of the 
media stack.
[  141.423609]     As the driver is backported to an older kernel, it 
doesn't offer
[  141.423610]     enough quality for its usage in production.
[  141.423611]     Use it with care.
[  141.423612] Latest git patches (needed if you report a bug to 
linux-media@vger.kernel.org):
[  141.423613]     135f9be9194cf7778eb73594aa55791b229cf27c [media] 
dvb_frontend: start media pipeline while thread is running
[  141.423614]     0f0fa90bd035fa15106799b813d4f0315d99f47e [media] 
cx231xx: enable tuner->decoder link at videobuf start
[  141.423615]     9239effd53d47e3cd9c653830c8465c0a3a427dc [media] 
dvb-frontend: enable tuner link when the FE thread starts
[  141.424714] em2884 #0: Binding DVB extension
[  142.754917] usb 2-6: firmware: agent loaded 
dvb-usb-hauppauge-hvr930c-drxk.fw into memory
[  142.765420] drxk: status = 0x639260d9
[  142.765430] drxk: detected a drx-3926k, spin A3, xtal 20.250 MHz
[  144.006316] drxk: DRXK driver version 0.9.4300
[  144.023065] drxk: frontend initialized.
[  144.042622] xc5000 11-0061: creating new instance
[  144.042938] xc5000: I2C read failed
[  144.042946] xc5000 11-0061: destroying instance
[  144.042956] em28xx: Registered (Em28xx dvb Extension) extension
[  144.066269] WARNING: You are using an experimental version of the 
media stack.
[  144.066273]     As the driver is backported to an older kernel, it 
doesn't offer
[  144.066276]     enough quality for its usage in production.
[  144.066278]     Use it with care.
[  144.066280] Latest git patches (needed if you report a bug to 
linux-media@vger.kernel.org):
[  144.066283]     135f9be9194cf7778eb73594aa55791b229cf27c [media] 
dvb_frontend: start media pipeline while thread is running
[  144.066286]     0f0fa90bd035fa15106799b813d4f0315d99f47e [media] 
cx231xx: enable tuner->decoder link at videobuf start
[  144.066290]     9239effd53d47e3cd9c653830c8465c0a3a427dc [media] 
dvb-frontend: enable tuner link when the FE thread starts
[  144.076221] em2884 #0: Registering input extension
[  144.100113] Registered IR keymap rc-hauppauge
[  144.100473] input: em28xx IR (em2884 #0) as 
/devices/pci0000:00/0000:00:1d.7/usb2/2-6/rc/rc0/input11
[  144.100717] rc0: em28xx IR (em2884 #0) as 
/devices/pci0000:00/0000:00:1d.7/usb2/2-6/rc/rc0
[  144.101208] em2884 #0: Input extension successfully initalized
[  144.101216] em28xx: Registered (Em28xx Input Extension) extension

What could one conclude with this dmesg?

>
>>
>>> because the windows driver comprises the xc5000 firmware and it is 100%
>>> identical:
>>>      $ mkdir extract-xc5000-fw
>>>      $ cd extract-xc5000-fw
>>>      $ wget
>>> http://linuxtv.org/downloads/firmware/dvb-fe-xc5000-1.6.114.fw
>>>      $ wget
>>> http://elgatoweb.s3.amazonaws.com/Documents/Support/EyeTV_Hybrid/EyeTV_Hybrid_2008_509081301_W8.exe 
>>>
>>>
>>>
>>>      $ 7z -y e EyeTV_Hybrid_2008_509081301_W8.exe
>>>      $ dd if=emBDA.sys of=dvb-fe-xc5000-test.fw bs=1 skip=518800
>>> count=12401 >/dev/null 2>&1
>>>      $ md5sum dvb-fe-xc5000-1.6.114.fw dvb-fe-xc5000-test.fw
>>>      b1ac8f759020523ebaaeff3fdf4789ed dvb-fe-xc5000-1.6.114.fw
>>>      b1ac8f759020523ebaaeff3fdf4789ed  dvb-fe-xc5000-test.fw
>>>
>>> The Elgato_EyeTV_Hybrid.inf file contains a comment with "TerraTec H5",
>>> which components are assembled on that USB stick?
>>
>> The TerraTec H5 has a TDA18271 tuner.
>>
>>>
>>>
>>> Regards,
>>> Gilles
>>
>>
>> So most likely the Elgato EyeTV hybrid is one of these combinations. And
>> it should quite feasible to add support for someone who knows the Empia
>> EM2884.
>
> That device could be supported just making proper board profile to 
> em28xx driver. Rather trivial stuff to one who has any experience. 
> Just one hour work or so.
>
> regards
> Antti
>

Regards,
Gilles
