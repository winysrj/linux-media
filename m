Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:59503 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbbBWXNb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2015 18:13:31 -0500
Message-ID: <54EBB413.6020608@southpole.se>
Date: Tue, 24 Feb 2015 00:13:23 +0100
From: Benjamin Larsson <benjamin@southpole.se>
MIME-Version: 1.0
To: Gilles Risch <gilles.risch@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
CC: Antti Palosaari <crope@iki.fi>, Olli Salonen <olli.salonen@iki.fi>
Subject: Re: Linux TV support Elgato EyeTV hybrid
References: <CALnjqVkteEsFGQXRdh3exzGrqdC=Qw4guSGRT_pCF50WjGqy1g@mail.gmail.com> <CAAZRmGwmNhczjXNXdKkotS0YZ8Tc+kKb4b+SyNN_8KVj2H8xuQ@mail.gmail.com> <54E9DDFE.4010507@gmail.com> <54EA3633.3030805@southpole.se> <54EA4A3B.9060000@iki.fi> <54EB8C86.3040700@gmail.com> <54EB8F38.9080806@southpole.se> <54EBAFB8.9010105@gmail.com>
In-Reply-To: <54EBAFB8.9010105@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/23/2015 11:54 PM, Gilles Risch wrote:
> On 02/23/2015 09:36 PM, Benjamin Larsson wrote:
>> On 02/23/2015 09:24 PM, Gilles Risch wrote:
>>> On 02/22/2015 10:29 PM, Antti Palosaari wrote:
>>>> On 02/22/2015 10:04 PM, Benjamin Larsson wrote:
>>>>> On 02/22/2015 02:47 PM, Gilles Risch wrote:
>> [...]
> Not sure if it helps, but I also tried:
>      $ modprobe em28xx card=82
>      $ modprobe xc5000
>      $ echo 0fd9 0018 > /sys/bus/usb/drivers/em28xx/new_id
>      $ dmesg
> [  142.728289] usb 8-6: new high-speed USB device number 3 using ehci_hcd
> [  142.862556] usb 8-6: New USB device found, idVendor=0fd9, idProduct=0018
> [  142.862565] usb 8-6: New USB device strings: Mfr=3, Product=1,
> SerialNumber=2
> [  142.862571] usb 8-6: Product: EyeTV Hybrid
> [  142.862576] usb 8-6: Manufacturer: Elgato
> [  142.862581] usb 8-6: SerialNumber: 100904010917
> [  142.863146] em28xx: New device Elgato EyeTV Hybrid @ 480 Mbps
> (0fd9:0018, interface 0, class 0)
> [  142.863153] em28xx: Audio interface 0 found (Vendor Class)
> [  142.863159] em28xx: Video interface 0 found: isoc
> [  142.863163] em28xx: DVB interface 0 found: isoc
> [  142.863993] em28xx: chip ID is em2884
> [  142.927681] em2884 #0: EEPROM ID = 26 00 01 00, EEPROM hash = 0x1a01bca5
> [  142.927688] em2884 #0: EEPROM info:
> [  142.927694] em2884 #0:     microcode start address = 0x0004, boot
> configuration = 0x01
> [  142.935299] em2884 #0:     I2S audio, 5 sample rates
> [  142.935306] em2884 #0:     500mA max power
> [  142.935312] em2884 #0:     Table at offset 0x27, strings=0x1a78,
> 0x1a92, 0x0e6a
> [  142.935466] em2884 #0: Identified as Terratec Cinergy HTC Stick
> (card=82)
> [  142.935474] em2884 #0: analog set to isoc mode.
> [  142.935478] em2884 #0: dvb set to isoc mode.
> [  142.975149] em2884 #0: Binding audio extension
> [  142.975152] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
> [  142.975153] em28xx-audio.c: Copyright (C) 2007-2014 Mauro Carvalho
> Chehab
> [  142.975180] em2884 #0: Endpoint 0x83 high-speed on intf 0 alt 7
> interval = 8, size 196
> [  142.975184] em2884 #0: Number of URBs: 1, with 64 packets and 192 size
> [  142.975537] em2884 #0: Audio extension successfully initialized
> [  142.975540] em28xx: Registered (Em28xx Audio Extension) extension
> [  143.003553] WARNING: You are using an experimental version of the
> media stack.
> [  143.003554]     As the driver is backported to an older kernel, it
> doesn't offer
> [  143.003555]     enough quality for its usage in production.
> [  143.003556]     Use it with care.
> [  143.003556] Latest git patches (needed if you report a bug to
> linux-media@vger.kernel.org):
> [  143.003557]     135f9be9194cf7778eb73594aa55791b229cf27c [media]
> dvb_frontend: start media pipeline while thread is running
> [  143.003558]     0f0fa90bd035fa15106799b813d4f0315d99f47e [media]
> cx231xx: enable tuner->decoder link at videobuf start
> [  143.003560]     9239effd53d47e3cd9c653830c8465c0a3a427dc [media]
> dvb-frontend: enable tuner link when the FE thread starts
> [  143.010977] em2884 #0: Binding DVB extension
> [  143.567751] usb 8-6: firmware: agent loaded
> dvb-usb-terratec-htc-stick-drxk.fw into memory
> [  143.585103] drxk: status = 0x639260d9
> [  143.585113] drxk: detected a drx-3926k, spin A3, xtal 20.250 MHz
> [  147.656822] drxk: DRXK driver version 0.9.4300
> [  147.695203] drxk: frontend initialized.
> [  147.764493] tda18271 11-0060: creating new instance
> [  147.766552] TDA18271HD/C2 detected @ 11-0060

I am not sure how certain the TDA18271HD detection is but when I look at 
the images from here:

http://www.linuxtv.org/wiki/index.php/Elgato_EyeTV_hybrid

I don't see the tuner chip, so it could be a tda chip.

> [  147.997562] DVB: registering new adapter (em2884 #0)
> [  147.997571] usb 8-6: DVB: registering adapter 0 frontend 0 (DRXK
> DVB-C DVB-T)...

This sounds good.

> [  147.998567] em2884 #0: DVB extension successfully initialized
> [  147.998571] em28xx: Registered (Em28xx dvb Extension) extension
> [  148.023086] WARNING: You are using an experimental version of the
> media stack.
> [  148.023087]     As the driver is backported to an older kernel, it
> doesn't offer
> [  148.023088]     enough quality for its usage in production.
> [  148.023089]     Use it with care.
> [  148.023089] Latest git patches (needed if you report a bug to
> linux-media@vger.kernel.org):
> [  148.023090]     135f9be9194cf7778eb73594aa55791b229cf27c [media]
> dvb_frontend: start media pipeline while thread is running
> [  148.023091]     0f0fa90bd035fa15106799b813d4f0315d99f47e [media]
> cx231xx: enable tuner->decoder link at videobuf start
> [  148.023092]     9239effd53d47e3cd9c653830c8465c0a3a427dc [media]
> dvb-frontend: enable tuner link when the FE thread starts
> [  148.034348] em2884 #0: Registering input extension
> [  148.064107] Registered IR keymap rc-nec-terratec-cinergy-xs
> [  148.064420] input: em28xx IR (em2884 #0) as
> /devices/pci0000:00/0000:00:1d.7/usb8/8-6/rc/rc0/input11
> [  148.064808] rc0: em28xx IR (em2884 #0) as
> /devices/pci0000:00/0000:00:1d.7/usb8/8-6/rc/rc0
> [  148.065325] em2884 #0: Input extension successfully initalized
> [  148.065333] em28xx: Registered (Em28xx Input Extension) extension
>
> The dmesg shows that a TDA18271HD/C2 tuner has been detected.
>
> A w_scan produced a kernel Oops:
> [  193.580994] BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000010
[...]
> [  193.581998] RIP: 0010:[<ffffffffa05a9289>] [<ffffffffa05a9289>]
> media_entity_pipeline_start+0x30/0x2d2 [media]

Try apply this patch:

[PATCH v2] [media] dvb core: only start media entity if not NULL

MvH
Benjamin Larsson
