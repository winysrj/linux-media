Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm24-vm4.bullet.mail.ird.yahoo.com ([212.82.109.195]:48135 "HELO
	nm24-vm4.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754042Ab2JIIGI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Oct 2012 04:06:08 -0400
References: <1349531264.14555.YahooMailNeo@web28905.mail.ir2.yahoo.com> <20121008223311.GI14107@valkosipuli.retiisi.org.uk>
Message-ID: <1349769964.36347.YahooMailNeo@web28903.mail.ir2.yahoo.com>
Date: Tue, 9 Oct 2012 09:06:04 +0100 (BST)
From: P Jackson <pej02@yahoo.co.uk>
Reply-To: P Jackson <pej02@yahoo.co.uk>
Subject: Re: omap3isp: no pixel rate control in subdev
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>
In-Reply-To: <20121008223311.GI14107@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,




From: Sakari Ailus <sakari.ailus@iki.fi>
Sent: Monday, 8 October 2012, 23:33

Hi,

On Sat, Oct 06, 2012 at 02:47:44PM +0100, P Jackson wrote:
> I'm trying to get an mt9t001 sensor board working on a Gumstix Overo board using the latest omap3isp-omap3isp-stable branch from the linuxtv.org/media.git repository.
> 
> When I 'modprobe omap3-isp' I see:
> 
> Linux media interface: v0.10
> Linux video capture interface: v2.00
> omap3isp omap3isp: Revision 15.0 found
> omap-iommu omap-iommu.0: isp: version 1.1
> mt9t001 3-005d: Probing MT9T001 at address 0x5d
> mt9t001 3-005d: MT9T001 detected at address 0x5d
> 
> I then do:
> 
> media-ctl -r
> media-ctl -l '"mt9t001 3-005d":0->"OMAP3 ISP CCDC":0[1]'
> media-ctl -l '"OMAP3 ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
> media-ctl -V '"mt9t001 3-005d":0 [SGRBG10 2048x1536]'
> media-ctl -V '"OMAP3 ISP CCDC":1 [SGRBG10 2048x1536]'
> 
> Followed by:
> 
> yavta -p -f SGRBG10 -s 2048x1536 -n 4 --capture=1 /dev/video2 file=m.bin
> 
> 
> For which I get:
> 
> Device /dev/video2 opened.
> Device `OMAP3 ISP CCDC output' on `media' is a video capture device.
> Video format set: SGRBG10 (30314142) 2048x1536 (stride 4096) buffer size 6291456
> Video format: SGRBG10 (30314142) 2048x1536 (stride 4096) buffer size 6291456
> 4 buffers requested.
> length: 6291456 offset: 0
> Buffer 0 mapped at address 0x40272000.
> length: 6291456 offset: 6291456
> Buffer 1 mapped at address 0x4096b000.
> length: 6291456 offset: 12582912
> Buffer 2 mapped at address 0x4102f000.
> length: 6291456 offset: 18874368
> Buffer 3 mapped at address 0x416ac000.
> Press enter to start capture
> 
> After pressing enter I get:
> 
> omap3isp omap3isp: no pixel rate control in subdev mt9t001 3-005d
> Unable to start streaming: Invalid argument (22).

Really?

Could you check if you have this patch in your tree?

---
commit 0bc77f3f06fcf2ca7b7fad782d70926cd4d235f1
Author: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Date:   Wed May 9 09:55:57 2012 -0300

    [media] mt9t001: Implement V4L2_CID_PIXEL_RATE control
    
    The pixel rate control is required by the OMAP3 ISP driver and should be
    implemented by all media controller-compatible sensor drivers.
    
    Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---

I have checked my tree and cannot find that patch.

Regards,

Pete
