Return-path: <linux-media-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:54438 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872AbZBKMxq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Feb 2009 07:53:46 -0500
Received: by ug-out-1314.google.com with SMTP id 39so8368ugf.37
        for <linux-media@vger.kernel.org>; Wed, 11 Feb 2009 04:53:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <49929D6D.1000507@koala.ie>
References: <49929D6D.1000507@koala.ie>
Date: Wed, 11 Feb 2009 13:53:44 +0100
Message-ID: <d2f9b55e0902110453h5644739dxfebc92607ca966f5@mail.gmail.com>
Subject: Re: failure of Cinergy Hybrid T USB XS on amd64
From: Alain Perrot <alain.perrot@gmail.com>
To: Simon Kenyon <simon@koala.ie>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 11, 2009 at 10:42 AM, Simon Kenyon <simon@koala.ie> wrote:
> does anyone know what is going on here?
>
> i know the device works because i can use it on my eee 900 running gentoo
>
> however i get a failure to load the driver (hg pull as of yesterday) on two
> different linux boxes. they are both running gentoo on an amd64
>
> uname -a gives:
>
> Linux newyork 2.6.27-gentoo-r8 #1 SMP PREEMPT Wed Feb 11 00:10:13 GMT 2009
> x86_64 AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ AuthenticAMD GNU/Linux

Hi,

I currently have the same issue while trying to make my Dazzle TV Hybrid
(USB ID eb1a:2881, looks like the exact same hardware as the Pinnacle Hybrid
Pro) work with the v4l-dvb tree from linuxtv.org on my 64-bit systems
(Kubuntu 8.10, Linux 2.6.27, AMD Sempron 64 and Intel Core 2 Duo).

My USB device seems very similar to yours : em288x, tvp5150, xc3028 and
zl10353 chips.

I've added some code to the em28xx driver to provide support for my device,
but for now I'm stuck with the "zl10353_read_register: readreg error (reg=127,
ret==-19)" error message...

Note that the device works with the em28xx-new driver from mcentral.de.


> and this is the output from the driver load:
>
> usb 2-1: new high speed USB device using ehci_hcd and address 4
> usb 2-1: configuration #1 chosen from 1 choice
> em28xx: New device TerraTec Electronic GmbH Cinergy Hybrid T USB XS @ 480
> Mbps (0ccd:0042, interface 0, class 0)
> em28xx #0: Identified as Terratec Hybrid XS (card=11)
> em28xx #0: chip ID is em2882/em2883
> tvp5150' 2-005c: chip found @ 0xb8 (em28xx #0)
> tuner' 2-0061: chip found @ 0xc2 (em28xx #0)
> em28xx #0: i2c eeprom 00: 1a eb 67 95 cd 0c 42 00 50 12 5c 03 6a 32 9c 34
> em28xx #0: i2c eeprom 10: 00 00 06 57 46 07 00 00 00 00 00 00 00 00 00 00
> em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 31 00 b8 00 14 00 5b 00 00 00
> em28xx #0: i2c eeprom 30: 00 00 20 40 20 6e 02 20 10 01 00 00 00 00 00 00
> em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 32 03 43 00 69 00
> em28xx #0: i2c eeprom 70: 6e 00 65 00 72 00 67 00 79 00 20 00 48 00 79 00
> em28xx #0: i2c eeprom 80: 62 00 72 00 69 00 64 00 20 00 54 00 20 00 55 00
> em28xx #0: i2c eeprom 90: 53 00 42 00 20 00 58 00 53 00 00 00 34 03 54 00
> em28xx #0: i2c eeprom a0: 65 00 72 00 72 00 61 00 54 00 65 00 63 00 20 00
> em28xx #0: i2c eeprom b0: 45 00 6c 00 65 00 63 00 74 00 72 00 6f 00 6e 00
> em28xx #0: i2c eeprom c0: 69 00 63 00 20 00 47 00 6d 00 62 00 48 00 00 00
> em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x41d0bf96
> em28xx #0: EEPROM info:
> em28xx #0:      AC97 audio (5 sample rates)
> em28xx #0:      500mA max power
> em28xx #0:      Table at 0x06, strings=0x326a, 0x349c, 0x0000
> xc2028 2-0061: creating new instance
> xc2028 2-0061: type set to XCeive xc2028/xc3028 tuner
> firmware: requesting xc3028-v27.fw
> xc2028 2-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028
> firmware, ver 2.7
> xc2028 2-0061: Loading firmware for type=BASE (1), id 0000000000000000.
> xc2028 2-0061: Loading firmware for type=(0), id 000000000000b700.
> SCODE (20000000), id 000000000000b700:
> xc2028 2-0061: Loading SCODE for type=MONO SCODE HAS_IF_4320 (60008000), id
> 0000000000008000.
> em28xx #0: Config register raw data: 0x50
> em28xx #0: AC97 vendor ID = 0x83847652
> em28xx #0: AC97 features = 0x6a90
> em28xx #0: Sigmatel audio processor detected(stac 9752)
> tvp5150' 2-005c: tvp5150am1 detected.
> em28xx #0: v4l2 driver version 0.1.1
> em28xx #0: V4L2 device registered as /dev/video1 and /dev/vbi1
> zl10353_read_register: readreg error (reg=127, ret==-19)
> em28xx #0/2: dvb frontend not attached. Can't attach xc3028
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
