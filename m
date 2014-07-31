Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.inunum.li ([83.169.19.93]:40424 "EHLO
	lvps83-169-19-93.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756077AbaGaKGp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jul 2014 06:06:45 -0400
Message-ID: <53DA1538.90709@InUnum.com>
Date: Thu, 31 Jul 2014 12:06:48 +0200
From: Michael Dietschi <michael.dietschi@InUnum.com>
MIME-Version: 1.0
To: Enrico <ebutera@users.sourceforge.net>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: omap3isp with DM3730 not working?!
References: <53D12786.5050906@InUnum.com>	<1915586.ZFV4ecW0Zg@avalon>	<CA+2YH7vhYuvUbFHyyr699zUdJuYWDtzweOGo0hGDHzT-+oFGjw@mail.gmail.com>	<2300187.SbcZEE0rv0@avalon>	<53D90786.9090809@InUnum.com> <CA+2YH7vrD_N32KsksU2G37BhLPBMHJDbizrVb_N+=mnHC3oNmQ@mail.gmail.com>
In-Reply-To: <CA+2YH7vrD_N32KsksU2G37BhLPBMHJDbizrVb_N+=mnHC3oNmQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 30.07.2014 17:21, schrieb Enrico:
> Standard question: are you using media-ctl from
> git://linuxtv.org/pinchartl/v4l-utils.git field branch and latest
> yavta from git://git.ideasonboard.org/yavta.git ?
>
> Enrico
No, not exactly. I used older versions which came with Yocto Poky Daisy. 
But I also tried with these newer ones and get the same:

root@overo:~$  ./media-ctl -v -r -l '"tvp5150 3-005c":0->"OMAP3 ISP 
CCDC":0[1], "OMAP3 ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'

Opening media device /dev/media0
Enumerating entities
Found 16 entities
Enumerating pads and links
Resetting all links to inactive
Opening media device /dev/media0
Opening media device /dev/media0
Opening media device /dev/media0
Opening media device /dev/media0
Opening media device /dev/media0
Opening media device /dev/media0
Opening media device /dev/media0
Opening media device /dev/media0
Opening media device /dev/media0
Opening media device /dev/media0
Opening media device /dev/media0
Opening media device /dev/media0
Opening media device /dev/media0
Setting up link 16:0 -> 5:0 [1]
Opening media device /dev/media0
Setting up link 5:1 -> 6:0 [1]
Opening media device /dev/media0

root@overo:~$  ./media-ctl -v -f '"tvp5150 3-005c":0 [UYVY2X8 720x576], 
"OMAP3 ISP CCDC":1 [UYVY2X8 720x576]'

Warning: the -f option is deprecated and has been replaced by -V.
Opening media device /dev/media0
Enumerating entities
Found 16 entities
Enumerating pads and links
Setting up format UYVY2X8 720x576 on pad tvp5150 3-005c/0
Format set: UYVY2X8 720x240
Setting up format UYVY2X8 720x240 on pad OMAP3 ISP CCDC/0
Format set: UYVY2X8 720x240
Setting up format UYVY2X8 720x576 on pad OMAP3 ISP CCDC/1
Format set: UYVY 720x240

root@overo:~$  ./yavta -f UYVY -s 720x576 --capture=1 --file=image.raw 
/dev/video2

Device /dev/video2 opened.
Device `OMAP3 ISP CCDC output' on `media' is a video output (without 
mplanes) device.
Video format set: UYVY (59565955) 720x576 (stride 1440) field none 
buffer size 829440
Video format: UYVY (59565955) 720x576 (stride 1440) field none buffer 
size 829440
8 buffers requested.
length: 829440 offset: 0 timestamp type/source: mono/(null)
Buffer 0/0 mapped at address 0xb6e59000.
length: 829440 offset: 831488 timestamp type/source: mono/(null)
Buffer 1/0 mapped at address 0xb6d8e000.
length: 829440 offset: 1662976 timestamp type/source: mono/(null)
Buffer 2/0 mapped at address 0xb6cc3000.
length: 829440 offset: 2494464 timestamp type/source: mono/(null)
Buffer 3/0 mapped at address 0xb6bf8000.
length: 829440 offset: 3325952 timestamp type/source: mono/(null)
Buffer 4/0 mapped at address 0xb6b2d000.
length: 829440 offset: 4157440 timestamp type/source: mono/(null)
Buffer 5/0 mapped at address 0xb6a62000.
length: 829440 offset: 4988928 timestamp type/source: mono/(null)
Buffer 6/0 mapped at address 0xb6997000.
length: 829440 offset: 5820416 timestamp type/source: mono/(null)
Buffer 7/0 mapped at address 0xb68cc000.
Unable to start streaming: Invalid argument (22).
8 buffers released.

