Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:21118 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757273Ab1FILfF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Jun 2011 07:35:05 -0400
Message-ID: <4DF0AFE7.4070902@redhat.com>
Date: Thu, 09 Jun 2011 08:35:03 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Moacyr Prado <mwprado@yahoo.com>
CC: linux-media@vger.kernel.org
Subject: Re: Brazilian HDTV device
References: <277629.63658.qm@web33207.mail.mud.yahoo.com>
In-Reply-To: <277629.63658.qm@web33207.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 09-06-2011 00:21, Moacyr Prado escreveu:
> Hi guys, I got some improvements on em28xx to support my device, follow my log:
> 
> [ 1053.559124] usb 2-2: new high speed USB device using ehci_hcd and address 7
> [ 1053.674873] usb 2-2: New USB device found, idVendor=1b80, idProduct=e755
> [ 1053.674883] usb 2-2: New USB device strings: Mfr=0, Product=1, SerialNumber=2
> [ 1053.674890] usb 2-2: Product: USB 2885 Device
> [ 1053.674896] usb 2-2: SerialNumber: 1
> [ 1063.858533] em28xx: New device USB 2885 Device @ 480 Mbps (1b80:e755, interface 0, class 0)
> [ 1063.858902] em28xx #0: em28xx chip ID = 68
> [ 1063.980947] em28xx #0: board has no eeprom
> [ 1063.982123] em28xx #0: Identified as C3Tech U-200 FullSeg Hybrid (card=78)
> [ 1063.982130] em28xx #0: 
> [ 1063.982132] 
> [ 1063.982137] em28xx #0: The support for this board weren't valid yet.
> [ 1063.982142] em28xx #0: Please send a report of having this working
> [ 1063.982148] em28xx #0: not to V4L mailing list (and/or to other addresses)
> [ 1063.982151] 
> [ 1064.000652] i2c-core: driver [tuner] using legacy suspend method
> [ 1064.000655] i2c-core: driver [tuner] using legacy resume method
> [ 1064.006098] Chip ID is not zero. It is not a TEA5767
> [ 1064.006193] tuner 16-0060: chip found @ 0xc0 (em28xx #0)
> [ 1064.008180] tda18271 16-0060: creating new instance
> [ 1064.015727] TDA18271HD/C2 detected @ 16-0060
> [ 1064.905095] tda18271: performing RF tracking filter calibration
> [ 1068.512078] tda18271: RF tracking filter calibration complete
> [ 1068.634254] em28xx #0: Config register raw data: 0x9b
> [ 1068.646228] em28xx #0: AC97 vendor ID = 0x70947094
> [ 1068.652224] em28xx #0: AC97 features = 0x7094
> [ 1068.652230] em28xx #0: Unknown AC97 audio processor detected!
> [ 1068.861285] em28xx #0: v4l2 driver version 0.1.2
> [ 1069.415411] em28xx #0: V4L2 video device registered as video1
> [ 1069.421162] usbcore: registered new interface driver em28xx
> [ 1069.421169] em28xx driver loaded
> [ 1069.436428] em28xx-audio.c: probing for em28x1 non standard usbaudio
> [ 1069.436431] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
> [ 1069.438133] Em28xx: Initialized (Em28xx Audio Extension) extension
> [ 1069.560298] mb86a20s: mb86a20s_attach: 
> [ 1069.566738] Detected a Fujitsu mb86a20s frontend
> [ 1069.566852] tda18271 16-0060: attaching existing instance
> [ 1069.566858] DVB: registering new adapter (em28xx #0)
> [ 1069.566863] DVB: registering adapter 0 frontend 0 (Fujitsu mb86A20s)...
> [ 1069.567506] em28xx #0: Successfully loaded em28xx-dvb
> [ 1069.567515] Em28xx: Initialized (Em28xx dvb Extension) extension
> 
> But is not working yet, DVB scan always fail. It must be gpio settings. I got a sniffer data from win7 driver. Anybody has a tip to discover gpio settigs from data sniffed?  

Moacyr,

Take a look at the v4l-utils tree. There are some parsers there for some common sniffer
formats, at the utils dirs, and a parser for em28xx format. You may eventually need to 
write a new parser, if your sniffer has a different format.

Of course, you can just try to search for the changes at the GPIO registers, but doing
it manually may be very time-consuming.

Cheers,
Mauro

> 
> Thanks 
> Moa.
> --- On Fri, 5/27/11, Moacyr Prado <mwprado@yahoo.com> wrote:
> 
>> From: Moacyr Prado <mwprado@yahoo.com>
>> Subject: Brazilian HDTV device
>> To: linux-media@vger.kernel.org
>> Date: Friday, May 27, 2011, 9:20 AM
>> Hi, I have a board with empia
>> chipset. The em28xx driver not load, 
>> because the device ID is not listed on source(cards.c, I
>> guess). 
>>
>> Following bellow 
>> have some infos from board:
>> lsusb:
>> Bus 001 Device 004: ID 1b80:e755 Afatech
>>
>> Opening the device, shows this ic:
>>
>> empia em2888 d351c-195 727-00ag (em28xx)
>> nxp saa7136e/1/g SI5296.1 22 ZSD08411
>> NXP TDA 18271??C2 HDC2? (tda18271)
>> F JAPAN mb86a20s 0937 M01 E1 (mb86a20s)
>>
>> but... dmesg shows:
>>
>> [18373.454136] usb 6-1: USB disconnect, address 2
>> [18376.744074] usb 2-1: new high speed USB device using
>> ehci_hcd and address 9
>> [18376.860283] usb 2-1: New USB device found,
>> idVendor=1b80, idProduct=e755
>> [18376.860293] usb 2-1: New USB device strings: Mfr=0,
>> Product=1, SerialNumber=2
>> [18376.860300] usb 2-1: Product: USB 2885 Device
>> [18376.860306] usb 2-1: SerialNumber: 1
>>
>>
>> Could The em28xx module (writing some code for me)handle
>> this device?
>>
>> Thanks,
>> Moa
>> --
>> To unsubscribe from this list: send the line "unsubscribe
>> linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>

