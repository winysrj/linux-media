Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:33260 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab0EGGOu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 May 2010 02:14:50 -0400
Received: by bwz19 with SMTP id 19so379768bwz.21
        for <linux-media@vger.kernel.org>; Thu, 06 May 2010 23:14:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <y2n2256c86e1005061726n72921cb9r28d81df677f7b5e8@mail.gmail.com>
References: <y2n2256c86e1005061726n72921cb9r28d81df677f7b5e8@mail.gmail.com>
Date: Fri, 7 May 2010 08:14:48 +0200
Message-ID: <r2u156a113e1005062314yc9c974bcm8399cfa9251816e1@mail.gmail.com>
Subject: Re: [em28xx] No sound in Leadtek WinFast TV USB II (not Deluxe)
From: Magnus Alm <magnus.alm@gmail.com>
To: =?UTF-8?B?0JLQu9Cw0LTQuNC80LjRgCDQp9C10YDQvdGL0YjQtdCy?=
	<volch5@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2010/5/7 Владимир Чернышев <volch5@gmail.com>:
> Hello.
>
> I try to plug  Leadtek WinFast TV USB II (LR6021 Rev. C) to my Ubuntu
> 10.04 (2.6.32-22-generic #33-Ubuntu SMP Wed Apr 28 13:27:30 UTC 2010
> i686 GNU/Linux with all latest security and updates ). First I try
> card=8 - no results, then I try card=28 (because in Windows it seems
> like Leadtek WinFast TV USB II Deluxe) - TV works fine, tvtime scans
> all available channels, but no sound in any audio standards
> (/dev/mixer:line1 is ok with other sources). If I start tuner in
> Windows, make hard reset, boot Ubuntu and start tvtime then audio
> works fine at all channels while tuner is powered on. So I think
> em28xx doesn't execute some initializing sequence for turn on audio.
>
> With latest version from http://linuxtv.org/hg/v4l-dvb my tuner works
> only if i change SAA7115_COMPOSITE4 to SAA7115_COMPOSITE2 in
> EM28XX_VMUX_TELEVISION section for Leadtek WinFast TV USB II Deluxe in
> em28xx-cards.c and only video too. /dev/radio detected but not work
> too.
>
> Any tips, recommendations? I don't want use Windows to tuner init only :)
>
> The peace of dmesg when I don't set card:
>
> em28xx #0: found i2c device @ 0x30 [???]
> em28xx #0: found i2c device @ 0x3e [???]
> em28xx #0: found i2c device @ 0x4a [saa7113h]
> em28xx #0: found i2c device @ 0x86 [tda9887]
> em28xx #0: found i2c device @ 0xb0 [tda9874]
> em28xx #0: found i2c device @ 0xc2 [tuner (analog)]
> em28xx #0: Board i2c devicelist hash is 0x81bb00dc
>
> dmesg with "original" (srcversion: AC6C6B6C3CB530BED33DFD3) em28xx
>
> em28xx: New device @ 480 Mbps (eb1a:2820, interface 0, class 0)
> em28xx #0: chip ID is em2820 (or em2710)
> em28xx #0: board has no eeprom
> em28xx #0: Identified as Leadtek Winfast USB II Deluxe (card=28)
> em28xx #0:
> em28xx #0: The support for this board weren't valid yet.
> em28xx #0: Please send a report of having this working
> em28xx #0: not to V4L mailing list (and/or to other addresses)
> saa7115 2-0025: saa7113 found (1f7113d0e100000) @ 0x4a (em28xx #0)
> tuner 2-0043: chip found @ 0x86 (em28xx #0)
> tda9887 2-0043: creating new instance
> tda9887 2-0043: tda988[5/6/7] found
> tuner 2-0061: chip found @ 0xc2 (em28xx #0)
> tuner-simple 2-0061: creating new instance
> tuner-simple 2-0061: type set to 38 (Philips PAL/SECAM multi (FM1216ME MK3))
> em28xx #0: Config register raw data: 0x00
> em28xx #0: v4l2 driver version 0.1.2
> em28xx #0: V4L2 video device registered as /dev/video0
> usbcore: registered new interface driver em28xx
> em28xx driver loaded
>
> dmesg with latest (srcversion: 7B6A05D4D518CB79FF69F9D) em28xx (with
> minor change sad above).
>
> em28xx: New device @ 480 Mbps (eb1a:2820, interface 0, class 0)
> em28xx #0: chip ID is em2820 (or em2710)
> em28xx #0: board has no eeprom
> input: i2c IR (i2c IR (EM2820 Winfast  as /devices/virtual/irrcv/irrcv0/input7
> irrcv0: i2c IR (i2c IR (EM2820 Winfast  as /devices/virtual/irrcv/irrcv0
> ir-kbd-i2c: i2c IR (i2c IR (EM2820 Winfast  detected at
> i2c-2/2-001f/ir0 [em28xx #0]
> em28xx #0: Identified as Leadtek Winfast USB II Deluxe (card=28)
> em28xx #0:
> em28xx #0: The support for this board weren't valid yet.
> em28xx #0: Please send a report of having this working
> em28xx #0: not to V4L mailing list (and/or to other addresses)
> saa7115 2-0025: saa7113 found (1f7113d0e100000) @ 0x4a (em28xx #0)
> tvaudio 2-0058: found tda9874a.
> tvaudio 2-0058: tda9874h/a found @ 0xb0 (em28xx #0)
> tuner 2-0000: chip found @ 0x0 (em28xx #0)
> tuner 2-0043: chip found @ 0x86 (em28xx #0)
> tda9887 2-0043: creating new instance
> tda9887 2-0043: tda988[5/6/7] found
> tuner 2-0061: chip found @ 0xc2 (em28xx #0)
> tuner-simple 2-0000: unable to probe Alps TSBE1, proceeding anyway.
> tuner-simple 2-0000: creating new instance
> tuner-simple 2-0000: type set to 10 (Alps TSBE1)
> tuner-simple 2-0061: creating new instance
> tuner-simple 2-0061: type set to 38 (Philips PAL/SECAM multi (FM1216ME MK3))
> em28xx #0: Config register raw data: 0x00
> em28xx #0: v4l2 driver version 0.1.2
> em28xx #0: Registered radio device as radio0
> em28xx #0: V4L2 video device registered as video0
> usbcore: registered new interface driver em28xx
> em28xx driver loaded
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Hi, the main problem (I think) is that your box doesn't support audio
over usb. So when you use the "card=28" option, it doesn't turn on the
audio output connector. Your box has a Em2800 chip, where the "Deluxe"
version uses a Em2820.

I'll take a look at the code when I comes home, maybe I can figure
something out. Your box is supposed to be supported but maybe some
regression in the codes has happend.

/Magnus
