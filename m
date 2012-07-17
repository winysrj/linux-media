Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway16.websitewelcome.com ([67.18.21.17]:49106 "EHLO
	gateway16.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754815Ab2GQIea (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jul 2012 04:34:30 -0400
Received: from gator886.hostgator.com (gator886.hostgator.com [174.120.40.226])
	by gateway16.websitewelcome.com (Postfix) with ESMTP id A53DAB43DAE88
	for <linux-media@vger.kernel.org>; Tue, 17 Jul 2012 03:00:48 -0500 (CDT)
Message-ID: <a6143f96ee9995c7bf9c7700058b3806.squirrel@sensoray.com>
In-Reply-To: <1342468678.2083.7.camel@tbastian-desktop.localdomain>
References: <1342265363.2362.12.camel@tbastian-desktop.localdomain>
    <000901cd637b$77c9e620$675db260$@com>
    <1342468678.2083.7.camel@tbastian-desktop.localdomain>
Date: Tue, 17 Jul 2012 03:00:47 -0500
Subject: Re: libv4l2: error dequeuing buf: Resource temporarily unavailable
From: charlie@sensoray.com
To: "llarevo@gmx.net" <llarevo@gmx.net>
Cc: "Charlie X. Liu" <charlie@sensoray.com>,
	linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

"ffmpeg -t 30 -f video4linux2 -s vga -r 25 -b 2000k -i /dev/video0
out-vga-2M-30sec.mpg" works, right? If PAL, you may add "-tvstd pal"
option.


> Am Montag, den 16.07.2012, 10:50 -0700 schrieb Charlie X. Liu:
>> Your driver load may not be quite right or got some conflicts. According
>> to:
>> http://www.kernel.org/doc/Documentation/video4linux/CARDLIST.saa7134,
>> the Terratec Cinergy 400 TV should be card=8. Have you tried: restart,
>> "modprobe -r saa7134", "modprobe saa7134 card=8", "dmesg | grep
>> saa7134", and checked if the Terratec Cinergy 400 TV showed up
>> correctly? If right, it should be Ok:
>>
>> ffmpeg -f video4linux2 -i /dev/video0 out.mpg
>> ffmpeg -t 30 -f video4linux2 -s vga -r 30 -b 2000k -i /dev/video0
>> out-vga-2M-30sec.mpg
>> ffmpeg -t 60 -f video4linux2 -s vga -r 30 -b 2000k -i /dev/video0
>> out-vga-2M-60sec.avi
>> ..., etc.
>
> Thanks a lot for your help. The card is loaded OK. I tried it with the
> card=8 parameter in a newly created file /etc/modprobe.d/saa7134.conf.
>
> It seems to be loaded properly:
>
> dmesg | grep saa7134
> [   24.978050] saa7134[0]: found at 0000:04:01.0, rev: 1, irq: 17,
> latency: 32, mmio: 0xfe500000
> [   24.978058] saa7134[0]: subsystem: 153b:1142, board: Terratec Cinergy
> 400 TV [card=8,insmod option]
> [   24.978073] saa7134[0]: board init: gpio is 50000
> [   25.053979] input: saa7134 IR (Terratec Cinergy 40
> as
> /devices/pci0000:00/0000:00:1c.4/0000:03:00.0/0000:04:01.0/rc/rc0/input6
> [   25.054018] rc0: saa7134 IR (Terratec Cinergy 40
> as /devices/pci0000:00/0000:00:1c.4/0000:03:00.0/0000:04:01.0/rc/rc0
> [   25.187509] saa7134[0]: i2c eeprom 00: 3b 15 42 11 ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   25.187517] saa7134[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   25.187523] saa7134[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   25.187529] saa7134[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   25.187535] saa7134[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   25.187541] saa7134[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   25.187547] saa7134[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   25.187553] saa7134[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   25.187559] saa7134[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   25.187566] saa7134[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   25.187571] saa7134[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   25.187577] saa7134[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   25.187583] saa7134[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   25.187589] saa7134[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   25.187595] saa7134[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   25.187601] saa7134[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   25.716134] saa7134[0]: registered device video0 [v4l2]
> [   25.716157] saa7134[0]: registered device vbi0
> [   25.998624] saa7134 ALSA driver for DMA sound loaded
> [   25.998650] saa7134[0]/alsa: saa7134[0] at 0xfe500000 irq 17
> registered as card -1
>
>
> ffmpeg -f video4linux2 -i /dev/video0 test.mpg
>
> gives still the error mentioned in the subject,
>
> ffmpeg -t 30 -f video4linux2 -s vga -r 30 -b 2000k -i /dev/video0
> out-vga-2M-30sec.mpg
>
> gives an I/O error while setting the framerate
>
> ffmpeg version 0.10.4 Copyright (c) 2000-2012 the FFmpeg developers
>   built on Jun 13 2012 09:51:06 with gcc 4.7.0 20120507 (Red Hat
> 4.7.0-5)
>   configuration: --prefix=/usr --bindir=/usr/bin
> --datadir=/usr/share/ffmpeg --incdir=/usr/include/ffmpeg
> --libdir=/usr/lib64 --mandir=/usr/share/man --arch=x86_64
> --extra-cflags='-O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions
> -fstack-protector --param=ssp-buffer-size=4 -m64 -mtune=generic'
> --enable-bzlib --disable-crystalhd --enable-gnutls --enable-libass
> --enable-libcdio --enable-libcelt --enable-libdc1394
> --disable-indev=jack --enable-libfreetype --enable-libgsm
> --enable-libmp3lame --enable-openal --enable-libopenjpeg
> --enable-libpulse --enable-librtmp --enable-libschroedinger
> --enable-libspeex --enable-libtheora --enable-libvorbis --enable-libv4l2
> --enable-libvpx --enable-libx264 --enable-libxvid --enable-x11grab
> --enable-avfilter --enable-postproc --enable-pthreads --disable-static
> --enable-shared --enable-gpl --disable-debug --disable-stripping
> --shlibdir=/usr/lib64 --enable-runtime-cpudetect
>   libavutil      51. 35.100 / 51. 35.100
>   libavcodec     53. 61.100 / 53. 61.100
>   libavformat    53. 32.100 / 53. 32.100
>   libavdevice    53.  4.100 / 53.  4.100
>   libavfilter     2. 61.100 /  2. 61.100
>   libswscale      2.  1.100 /  2.  1.100
>   libswresample   0.  6.100 /  0.  6.100
>   libpostproc    52.  0.100 / 52.  0.100
> Please use -b:a or -b:v, -b is ambiguous
> [video4linux2,v4l2 @ 0x9bd440] ioctl set time per frame(1/30) failed
> /dev/video0: Input/output error
>
> While we have PAL here I tried
>
> ffmpeg -t 30 -f video4linux2 -s vga -r 25 -b 2000k -i /dev/video0
> out-vga-2M-30sec.mpg
>
> Regards
> --
> Felix
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
