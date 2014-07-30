Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.inunum.li ([83.169.19.93]:54862 "EHLO
	lvps83-169-19-93.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753529AbaG3O4D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jul 2014 10:56:03 -0400
Message-ID: <53D90786.9090809@InUnum.com>
Date: Wed, 30 Jul 2014 16:56:06 +0200
From: Michael Dietschi <michael.dietschi@InUnum.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Enrico <ebutera@users.sourceforge.net>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: omap3isp with DM3730 not working?!
References: <53D12786.5050906@InUnum.com> <1915586.ZFV4ecW0Zg@avalon> <CA+2YH7vhYuvUbFHyyr699zUdJuYWDtzweOGo0hGDHzT-+oFGjw@mail.gmail.com> <2300187.SbcZEE0rv0@avalon>
In-Reply-To: <2300187.SbcZEE0rv0@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 29.07.2014 02:53, schrieb Laurent Pinchart:
> You're right. Maybe that's the first problem to be fixed though ;-) 
> Michael, could you try using the "official" (and under development) 
> BT.656 support code for the OMAP3 ISP driver ? I've just pushed the 
> branch to git://linuxtv.org/pinchartl/media.git omap3isp/bt656 

Laurent,

I did try this kernel and it does not work either - but with a different 
error.
Any Idea?

Michael


These are the commands and their output:

root@overo:~$  media-ctl -v -r -l '"tvp5150 3-005c":0->"OMAP3 ISP 
CCDC":0[1], "OMAP3 ISP CCDC":1->"OMAP3 ISP CCDC

output":0[1]'
Opening media device /dev/media0
Enumerating entities
Found 16 entities
Enumerating pads and links
Resetting all links to inactive
Setting up link 16:0 -> 5:0 [1]
Setting up link 5:1 -> 6:0 [1]

root@overo:~$  media-ctl -v -V '"tvp5150 3-005c":0 [UYVY2X8 720x576], 
"OMAP3 ISP CCDC":1 [UYVY2X8 720x576]'Opening

media device /dev/media0
Enumerating entities
Found 16 entities
Enumerating pads and links
Setting up format UYVY2X8 720x576 on pad tvp5150 3-005c/0
Format set: UYVY2X8 720x240
Setting up format UYVY2X8 720x240 on pad OMAP3 ISP CCDC/0
Format set: UYVY2X8 720x240
Setting up format UYVY2X8 720x576 on pad OMAP3 ISP CCDC/1
Format set: UYVY 720x240

root@overo:~$  yavta -f UYVY -s 720x576 --capture=1 --file=imagele 
/dev/video2

Device /dev/video2 opened.
Device `OMAP3 ISP CCDC output' on `media' is a video capture device.
Video format set: UYVY (59565955) 720x576 (stride 1440) buffer size 829440
Video format: UYVY (59565955) 720x576 (stride 1440) buffer size 829440
8 buffers requested.
length: 829440 offset: 0
Buffer 0 mapped at address 0xb6e79000.
length: 829440 offset: 831488
Buffer 1 mapped at address 0xb6dae000.
length: 829440 offset: 1662976
Buffer 2 mapped at address 0xb6ce3000.
length: 829440 offset: 2494464
Buffer 3 mapped at address 0xb6c18000.
length: 829440 offset: 3325952
Buffer 4 mapped at address 0xb6b4d000.
length: 829440 offset: 4157440
Buffer 5 mapped at address 0xb6a82000.
length: 829440 offset: 4988928
Buffer 6 mapped at address 0xb69b7000.
length: 829440 offset: 5820416
Buffer 7 mapped at address 0xb68ec000.
Unable to start streaming: Invalid argument (22).
8 buffers released.

