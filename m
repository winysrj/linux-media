Return-path: <mchehab@pedra>
Received: from nm20-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.218]:38601 "HELO
	nm20-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759084Ab1FAX6n convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Jun 2011 19:58:43 -0400
Message-ID: <850588.91894.qm@web112012.mail.gq1.yahoo.com>
Date: Wed, 1 Jun 2011 16:58:41 -0700 (PDT)
From: Chris Rodley <carlighting@yahoo.co.nz>
Subject: Re: [beagleboard] [PATCH v5 2/2] Add support for mt9p031 (LI-5M03 module) in Beagleboard xM.
To: javier.martin@vista-silicon.com
Cc: beagleboard@googlegroups.com, linux-media@vger.kernel.org,
	g.liakhovetski@gmx.de, laurent.pinchart@ideasonboard.com,
	mch_kot@yahoo.com.cn, koen@beagleboard.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

--- On Wed, 1/6/11, Chris Rodley <carlighting@yahoo.co.nz> wrote:
> From: Chris Rodley <carlighting@yahoo.co.nz>
> Subject: Re: [beagleboard] [PATCH v5 2/2] Add support for mt9p031 (LI-5M03 module) in Beagleboard xM.
> To: javier.martin@vista-silicon.com
> Cc: beagleboard@googlegroups.com, linux-media@vger.kernel.org, g.liakhovetski@gmx.de, laurent.pinchart@ideasonboard.com, mch_kot@yahoo.com.cn, koen@beagleboard.org
> Received: Wednesday, 1 June, 2011, 3:04 PM
> Hi Javier, Koen,
> 
> On 02/06/11 06:08, Koen Kooi wrote:
> >
> > Op 1 jun 2011, om 17:36 heeft Javier Martin het
> volgende geschreven:
> >
> >> New "version" and "vdd_io" flags have been added.
> >>
> >> A subtle change now prevents camera from being
> registered
> >> in the wrong platform.
> >
> > I get a decent picture now with the following:
> >
> > media-ctl -r -l '"mt9p031 2-0048":0->"OMAP3 ISP
> CCDC":0[1], "OMAP3 ISP CCDC":1->"OMAP3 ISP CCDC
> output":0[1]'
> > media-ctl -f '"mt9p031 2-0048":0[SGRBG12 320x240],
> "OMAP3 ISP CCDC":0[SGRBG8 320x240], "OMAP3 ISP
> CCDC":1[SGRBG8 320x240]'
> >
> > yavta-nc --stdout -f SGRBG8 -s 320x240 -n 4
> --capture=10000 --skip 3 -F $(media-ctl -e "OMAP3 ISP CCDC
> output") | mplayer-bayer - -demuxer  rawvideo -rawvideo
> w=320:h=240:format=ba81:size=76800 -vo fbdev2 -vf ba81
> >
> > 720p also seems to work.
> >
> > It is really, really dark though. Is this due to
> missing controls or due to the laneshifting?
> >
> > regards,
> >
> > Koen
> 
> I made changes the same as my last post.
> Output is MUCH more encouraging now with v6 patch.
> 
> # media-ctl -r -l '"mt9p031 2-0048":0->"OMAP3 ISP
> CCDC":0[1], "OMAP3 ISP CCDC":1->"OMAP3 ISP CCDC
> output":0[1]'
> Resetting all links to inactive
> Setting up link 16:0 -> 5:0 [1]
> Setting up link 5:1 -> 6:0 [1]
> 
> # media-ctl -f '"mt9p031 2-0048":0[SGRBG12 320x240], "OMAP3
> ISP CCDC":0[SGRBG8 320x240], "OMAP3 ISP CCDC":1[SGRBG8
> 320x240]'
> Setting up format SGRBG12 320x240 on pad mt9p031 2-0048/0
> Format set: SGRBG12 320x240
> Setting up format SGRBG12 320x240 on pad OMAP3 ISP CCDC/0
> Format set: SGRBG12 320x240
> Setting up format SGRBG8 320x240 on pad OMAP3 ISP CCDC/0
> Format set: SGRBG8 320x240
> Setting up format SGRBG8 320x240 on pad OMAP3 ISP CCDC/1
> Format set: SGRBG8 320x240
> 
> # yavta --stdout -f SGRBG8 -s 320x240 -n 4 --capture=100
> --skip 3 -F `media-ctl -e "OMAP3 ISP CCDC output"` | nc
> 10.1.1.16 3000
> Device /dev/video2 opened.
> Device `OMAP3 ISP CCDC output' on `media' is a video
> capture device.
> Video format set: width: 320 height: 240 buffer size:
> 76800
> Video format: GRBG (47425247) 320x240
> 4 buffers requested.
> length: 76800 offset: 0
> Buffer 0 mapped at address 0x40057000.
> length: 76800 offset: 77824
> Buffer 1 mapped at address 0x400aa000.
> length: 76800 offset: 155648
> Buffer 2 mapped at address 0x40220000.
> length: 76800 offset: 233472
> Buffer 3 mapped at address 0x402da000.
> 0 (0) [-] 4294967295 76800 bytes 457.431406
> 1306964763.471233 -0.001 fps
> 
> Hangs at this point - 'ctrl c'
> 
> [  464.115386] omap3isp omap3isp: CCDC stop timeout!
> [  465.125488] omap3isp omap3isp: Unable to stop OMAP3
> ISP CCDC
> 
> I can look at the frame - looks like noise on the left hand
> side only.

Now producing:
# yavta --stdout -f SGRBG8 -s 320x240 -n 4 --captur
e=100 --skip 3 -F `media-ctl -e "OMAP3 ISP CCDC output"` | nc 10.1.1.16 3000
Device /dev/video2 opened.
Device `OMAP3 ISP CCDC output' on `media' is a video capture device.
Video format set: width: 320 height: 240 buffer size: 76800
Video format: GRBG (47425247) 320x240
4 buffers requested.
length: 76800 offset: 0
Buffer 0 mapped at address 0x40209000.
length: 76800 offset: 77824
Buffer 1 mapped at address 0x402a4000.
length: 76800 offset: 155648
Buffer 2 mapped at address 0x40305000.
length: 76800 offset: 233472
Buffer 3 mapped at address 0x4033d000.
0 (0) [-] 4294967295 76800 bytes 161.364596 1306972315.470868 -0.001 fps
1 (1) [-] 4294967295 76800 bytes 161.847217 1306972315.953520 2.072 fps
2 (2) [-] 4294967295 76800 bytes 162.081111 1306972316.187383 4.275 fps
3 (3) [-] 4294967295 76800 bytes 162.314970 1306972316.421212 4.276 fps
4 (0) [-] 4294967295 76800 bytes 162.548792 1306972316.655095 4.277 fps
5 (1) [-] 4294967295 76800 bytes 162.782648 1306972316.888951 4.276 fps
6 (2) [-] 4294967295 76800 bytes 163.016504 1306972317.122807 4.276 fps
7 (3) [-] 4294967295 76800 bytes 163.250330 1306972317.356633 4.277 fps
8 (0) [-] 4294967295 76800 bytes 163.484186 1306972317.590489 4.276 fps
9 (1) [-] 4294967295 76800 bytes 163.718012 1306972317.824345 4.277 fps
10 (2) [-] 4294967295 76800 bytes 163.951868 1306972318.058171 4.276 fps
11 (3) [-] 4294967295 76800 bytes 164.185694 1306972318.291997 4.277 fps
12 (0) [-] 4294967295 76800 bytes 164.419550 1306972318.525883 4.276 fps
13 (1) [-] 4294967295 76800 bytes 164.653406 1306972318.759709 4.276 fps

Changed mt9p031.c:
#define MT9P031_EXTCLK_FREQ			12000000

I was digging around and found an Aptina driver for 2.6.32:
https://github.com/Aptina/BeagleBoard-xM/blob/master/MT9P031/Angstrom/mt9p031.c

They set it to 12000000 or 24000000 depending.

Mine is very washed out.. opposite to what Koen has observed.

Regards,
Chris

