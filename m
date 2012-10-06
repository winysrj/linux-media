Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm1.bullet.mail.ird.yahoo.com ([77.238.189.58]:32654 "HELO
	nm1.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754767Ab2JFNrq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Oct 2012 09:47:46 -0400
Message-ID: <1349531264.14555.YahooMailNeo@web28905.mail.ir2.yahoo.com>
Date: Sat, 6 Oct 2012 14:47:44 +0100 (BST)
From: P Jackson <pej02@yahoo.co.uk>
Reply-To: P Jackson <pej02@yahoo.co.uk>
Subject: omap3isp: no pixel rate control in subdev
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm trying to get an mt9t001 sensor board working on a Gumstix Overo board using the latest omap3isp-omap3isp-stable branch from the linuxtv.org/media.git repository.

When I 'modprobe omap-isp' I see:

Linux media interface: v0.10
Linux video capture interface: v2.00
omap3isp omap3isp: Revision 15.0 found
omap-iommu omap-iommu.0: isp: version 1.1
mt9t001 3-005d: Probing MT9T001 at address 0x5d
mt9t001 3-005d: MT9T001 detected at address 0x5d

I then do:

media-ctl -r
media-ctl -l '"mt9t001 3-005d":0->"OMAP3 ISP CCDC":0[1]'
media-ctl -l '"OMAP3 ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
media-ctl -V '"mt9t001 3-005d":0 [SGRBG10 2048x1536]'
media-ctl -V '"OMAP3 ISP CCDC":1 [SGRBG10 2048x1536]'

Followed by:

yavta -p -f SGRBG10 -s 2048x1536 -n 4 --capture=1 /dev/video2 file=m.bin


For which I get:

Device /dev/video2 opened.
Device `OMAP3 ISP CCDC output' on `media' is a video capture device.
Video format set: SGRBG10 (30314142) 2048x1536 (stride 4096) buffer size 6291456
Video format: SGRBG10 (30314142) 2048x1536 (stride 4096) buffer size 6291456
4 buffers requested.
length: 6291456 offset: 0
Buffer 0 mapped at address 0x40272000.
length: 6291456 offset: 6291456
Buffer 1 mapped at address 0x4096b000.
length: 6291456 offset: 12582912
Buffer 2 mapped at address 0x4102f000.
length: 6291456 offset: 18874368
Buffer 3 mapped at address 0x416ac000.
Press enter to start capture

After pressing enter I get:

omap3isp omap3isp: no pixel rate control in subdev mt9t001 3-005d
Unable to start streaming: Invalid argument (22).
1 buffers released.

Thinking it might be the mt9t001 code, I also tried the mt9v032 code as I have one of those sensors too. I got exactly the same error message.

Is there a patch I have missed or have I not configured something I should have done?
