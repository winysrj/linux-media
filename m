Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48004 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab2GEQZ6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2012 12:25:58 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Florian Neuhaus <florian.neuhaus@reberinformatik.ch>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"sakari.ailus@iki.fi" <sakari.ailus@iki.fi>
Subject: Re: omap3isp: cropping bug in previewer?
Date: Thu, 05 Jul 2012 18:26:04 +0200
Message-ID: <3874464.XaN5Rti32a@avalon>
In-Reply-To: <B21EB8416BB7744FAB36AEE2627158CD0119103FEC66@REBITSERVER.rebit.local>
References: <B21EB8416BB7744FAB36AEE2627158CD0119103FEC66@REBITSERVER.rebit.local>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Florian,

On Thursday 05 July 2012 16:06:03 Florian Neuhaus wrote:
> Laurent Pinchart wrote on 2012-07-05:
> >> When I now capture a frame with yavta (see [3] for details), I must use
> >> 846x639 as frame size (as this size is reported by the driver). But it
> >> seems that the outputted image is 2px wider (that means 848x639). This
> >> results in a "scrambled"/unusable image on screen when streaming (see
> >> [6] bad-frame-846x639_on_display.bmp for an example how it looks like
> >> on screen). Also the file size too big for a 846x639 image: The frame
> >> size is 1083744 bytes, which is exactly 848*639*2 (NOT 846*639*2)!
> > 
> > The OMAP3 ISP pads lines to multiples of 32 or 64 bytes when reading
> > from/writing to memory. 846 pixels * 2 bytes per pixel is not a multiple
> > of 32 bytes, so the line length gets padded to the next multiple, 848
> > pixels in this case. The information is reported by the bytesperline field
> > of the v4l2_pix_format structure returned by VIDIOC_G_FMT and VIDIOC_S_FMT
> > on the preview engine output video node. You need to take the padding into
> > account in your application, that should solve your issue. raw2rgbpnm
> > tries to detect padding at the end of lines, and skips it automatically.
> 
> Thanks for your fast answer and the explanation!
> So you're saying that yavta doesn't check that the image is coming from the
> previewer-output and has maybe a padding? So yavta needs a patch to extend
> the line width when not aligned on 32 bytes or strip out the padding?

yavta takes the bytesperline field into account, and writes full frames to
disk, including padding. We could patch it to (optionally) discard the padding
bytes, although that kind of feature might belong to higher-level component
(such as raw2rgbpnm or custom applications).

> >> If you look in the isp-datasheet [7] in table 6-40 (page
> >> 1201) you see, that the CFA interpolation block for bayer-mode crops 4
> >> px per line and 4 lines. So shouldn't we respect this in the
> >> preview_config_input_size function? My RFC is:
> >> 
> >> Index: git/drivers/media/video/omap3isp/isppreview.c
> >> 
> >> =========================================================
> >> --- git.orig/drivers/media/video/omap3isp/isppreview.c	2012-07-05
> >> 10:59:33.675358396 +0200 +++
> >> git/drivers/media/video/omap3isp/isppreview.c	2012-07-05
> >> 12:14:33.723223514 +0200 @@ -1140,6 +1140,12 @@
> >> 
> >>  	}
> >>  	if (features & (OMAP3ISP_PREV_CHROMA_SUPP |
> >>  OMAP3ISP_PREV_LUMAENH))
> >>  		sph -= 2;
> >> 
> >> +	if (features & OMAP3ISP_PREV_CFA) {
> >> +		sph -= 2;
> >> +		eph += 2;
> >> +		slv -= 2;
> >> +		elv += 2;
> >> +	}
> >> 
> >>  	isp_reg_writel(isp, (sph << ISPPRV_HORZ_INFO_SPH_SHIFT) | eph,
> >>  		       OMAP3_ISP_IOMEM_PREV, ISPPRV_HORZ_INFO);
> >> 
> >> =========================================================
> >> NOTE: This still gives an unusable picture at the previewer output BUT if
> >> I extend the pipeline to the resizer output, the picture is good. So I
> >> must be missing something...
> 
> After reading your explanation about the padding, I understand why the image
> is broken on the previewer out. But if I configure the pipeline to output
> on the resizer-out, the image is still broken (without my patch). I used a
> resolution of 800x600 for the resizer-out, so the alignment should be fine:
> 
> # media-ctl -v -r -l '"mt9p031 2-0048":0->"OMAP3 ISP CCDC":0[1], "OMAP3 ISP
> CCDC":2->"OMAP3 ISP preview":0[1], "OMAP3 ISP preview":1->"OMAP3 ISP
> resizer":0[1], "OMAP3 ISP resizer":1->"OMAP3 ISP resizer output": 0[1]'
> # media-ctl -v -f '"mt9p031 2-0048":0 [SGRBG12 800x600], "OMAP3 ISP CCDC":2
> [SGRBG10 800x600], "OMAP3 ISP preview":1 [UYVY 800x600], "OMAP3 ISP
> resizer":1 [UYVY 800x600]'
> # yavta -f UYVY -s 800x600 -n 8 --skip 3 --capture=1000 --stdout /dev/video6
> | mplayer - -demuxer rawvideo -rawvideo w=800:h=600:format=uyvy -vo fbdev
> 
> Does my patch just output a good picture by chance, or is there really an
> issue?

There's really an issue, which was introduced in v3.5-rc1. Could you please
try the following patch instead of yours ?

diff --git a/drivers/media/video/omap3isp/isppreview.c b/drivers/media/video/omap3isp/isppreview.c
index 9c6dd44..614752a 100644
--- a/drivers/media/video/omap3isp/isppreview.c
+++ b/drivers/media/video/omap3isp/isppreview.c
@@ -1116,7 +1116,7 @@ static void preview_config_input_size(struct isp_prev_device *prev, u32 active)
 	unsigned int elv = prev->crop.top + prev->crop.height - 1;
 	u32 features;
 
-	if (format->code == V4L2_MBUS_FMT_Y10_1X10) {
+	if (format->code != V4L2_MBUS_FMT_Y10_1X10) {
 		sph -= 2;
 		eph += 2;
 		slv -= 2;

-- 
Regards,

Laurent Pinchart

