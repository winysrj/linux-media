Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:32808 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755692Ab0BHALL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Feb 2010 19:11:11 -0500
Subject: Re: Any saa711x users out there?
From: Andy Walls <awalls@radix.net>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 07 Feb 2010 19:10:39 -0500
Message-Id: <1265587839.4186.16.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> I'll try to perform a quick test with my PVR-350 with NTSC and the YUV
> capture device BTW.

OK.  So my test setup:

a. DTV STB tuned to the SuperBowl :)

b. Composite out from the STB feeding my PVR-350/SAA7115 with an NTSC
CVBS input.

c. mplayer capturing raw YUV video from the PVR-350's composite input:
$ mplayer /dev/video32 -demuxer rawvideo -rawvideo w=720:h=480:format=hm12:ntsc


I did this:

# v4l2-dbg -d /dev/video32 -S
host0: cx23415    revision 0x00000000
i2c 0x21: saa7115    revision 0x00000000
i2c 0x40: msp4448g   revision 0x02173043
i2c 0x44: saa7129    revision 0x00000000

# v4l2-dbg -d /dev/video32 -c 0x21 --list-registers=min=0x00,max=0xff
ioctl: VIDIOC_DBG_G_REGISTER

          00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F
00000000: 10 48 80 20 90 90 eb e0 68 53 80 44 40 00 07 2e 
00000010: 06 00 9d 80 00 03 11 9c 40 80 77 42 a9 01 81 b1 
00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
00000030: cd 20 03 00 ce fb 30 00 03 10 00 00 00 00 00 00 
00000040: 20 ff ff ff ff ff ff ff ff dd dd dd dd dd dd dd 
00000050: dd dd dd dd dd ff ff ff 40 47 06 83 00 bd 35 00 
00000060: 00 00 00 00 00 00 a9 00 00 00 00 aa 00 00 00 00 
00000070: 00 00 aa 00 00 00 00 aa 00 00 00 00 00 00 00 00 
00000080: 30 01 00 00 20 21 c5 01 f0 00 00 00 00 00 00 3b 
00000090: 80 48 40 84 01 00 d0 02 05 00 0c 00 a0 05 0c 00 
000000a0: 01 00 00 00 80 40 40 00 00 02 00 00 00 01 00 00 
000000b0: 00 04 00 04 01 00 00 00 00 00 00 00 00 00 00 00 
000000c0: 00 08 00 80 02 00 d0 02 12 00 f8 00 d0 02 f8 00 
000000d0: 01 00 00 00 80 40 40 00 00 04 00 00 00 02 00 00 
000000e0: 00 04 00 04 01 00 00 00 00 00 00 00 00 00 00 00 
000000f0: ad 05 50 46 00 ad 01 4b 00 4b 00 4b 00 00 00 88 

# v4l2-dbg -d /dev/video32 -c 0x21 -g 2
ioctl: VIDIOC_DBG_G_REGISTER
Register 0x00000002 = 80h (128d  10000000b)

# v4l2-dbg -d /dev/video32 -c 0x21 -s 2 0xc0
Register 0x00000002 set to 0xc0

# v4l2-dbg -d /dev/video32 -c 0x21 -s 2 0x80
Register 0x00000002 set to 0x80

# v4l2-dbg -d /dev/video32 -c 0x21 -s 2 0xc0
Register 0x00000002 set to 0xc0

# v4l2-dbg -d /dev/video32 -c 0x21 -s 2 0x0
Register 0x00000002 set to 0x0

# v4l2-dbg -d /dev/video32 -c 0x21 -s 2 0x40
Register 0x00000002 set to 0x40

# v4l2-dbg -d /dev/video32 -c 0x21 -s 2 0x00
Register 0x00000002 set to 0x0

# v4l2-dbg -d /dev/video32 -c 0x21 -s 2 0x40
Register 0x00000002 set to 0x40

# v4l2-dbg -d /dev/video32 -c 0x21 -s 2 0x00
Register 0x00000002 set to 0x0

# v4l2-dbg -d /dev/video32 -c 0x21 -s 2 0x40
Register 0x00000002 set to 0x40

# v4l2-dbg -d /dev/video32 -c 0x21 -s 2 0x0
Register 0x00000002 set to 0x0

# v4l2-dbg -d /dev/video32 -c 0x21 -s 2 0x80
Register 0x00000002 set to 0x80

# v4l2-dbg -d /dev/video32 -c 0x21 -s 2 0x40
Register 0x00000002 set to 0x40

# v4l2-dbg -d /dev/video32 -c 0x21 -s 2 0x80
Register 0x00000002 set to 0x80

# v4l2-dbg -d /dev/video32 -c 0x21 -s 2 0xc0
Register 0x00000002 set to 0xc0

# v4l2-dbg -d /dev/video32 -c 0x21 -s 2 0x40
Register 0x00000002 set to 0x40

# v4l2-dbg -d /dev/video32 -c 0x21 -s 2 0x80
Register 0x00000002 set to 0x80


My observations:

1. With the amplifier on and anti-alias filter off things looked fine.
2. With the amplifier on and anti-alias filter on things looked fine.
3. With the amplifier off and anti-alias filter off things looked fine.
4. With the amplifier off and anti-alias filter on the screen washed brighter/whiter.

I guess the anti-alias filter peaks the luma a little or attenuates the color a little.
The amplifier and AGC is probably essential when using the anti-alias filter.

Regards,
Andy


