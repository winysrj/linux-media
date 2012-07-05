Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44068 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430Ab2GEKni (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2012 06:43:38 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Florian Neuhaus <florian.neuhaus@reberinformatik.ch>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"sakari.ailus@iki.fi" <sakari.ailus@iki.fi>
Subject: Re: omap3isp: cropping bug in previewer?
Date: Thu, 05 Jul 2012 12:43:41 +0200
Message-ID: <1371650.7y1cE3s6ZE@avalon>
In-Reply-To: <B21EB8416BB7744FAB36AEE2627158CD0119103FEC61@REBITSERVER.rebit.local>
References: <B21EB8416BB7744FAB36AEE2627158CD0119103FEC61@REBITSERVER.rebit.local>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Florian,

On Thursday 05 July 2012 12:28:04 Florian Neuhaus wrote:
> Dear all,
> I am trying to get a mt9p031 sensor running on a beagleboard-xm with the
> following configuration:
> 
> Hardware:
> - beagleboard-xm, rev c1
> - Leopard Imaging cam module LI-5M03 with a mt9p031 5MP sensor
> 
> Software:
> - Angstrom-distro built with bitbake using the setup-scripts from [4]
> (commit da56a56b690bcc07a50716f1071e90e2b3a4fb47). - own bitbake recipe to
> build a linux-omap kernel 3.5-rc1 from the tmdlind branch (this source:
> [5], tag omap-fixes-for-v3.5-rc1) - some patches to update the 3.5-rc1
> omap3-isp module (not the whole kernel) to the latest omap3isp-sensors-next
> branch from Laurent Pinchart [1] - yavta with an extension to output data
> to stdout
> - mediactl to configure the omap3isp pipeline
> 
> Problem:
> 
> I configure a pipe with mediactl from OMAP3 ISP CCDC input to the previewer
> output (see [3] for a detailed log) with an example resolution of 800x600.
> This resolution is adapted by the omap3isp driver to 846x639 at the
> previewer output. In my understanding the adjustment of the resolution
> (from 800x600 to 846x639) is a result of the following process: 1) The
> closest possible windowing of the mt9p031 sensor is 864x648. 2) The
> ccdc-source pad crops the height by one line (see function ccdc_try_format
> in ispccdc.c) - we are now on 864x647 3) The previewer (isppreview.c) crops
> a left margin of 8px and a right margin of 6px (see the PREV_MARGIN_*
> defines) plus 4px if the input is from ccdc (see preview_try_crop) - we are
> now on 846x639. As there are no filters activated, the input size will not
> be modified by the preview_config_input_size function.
> 
> When I now capture a frame with yavta (see [3] for details), I must use
> 846x639 as frame size (as this size is reported by the driver). But it
> seems that the outputted image is 2px wider (that means 848x639). This
> results in a "scrambled"/unusable image on screen when streaming (see [6]
> bad-frame-846x639_on_display.bmp for an example how it looks like on
> screen). Also the file size too big for a 846x639 image: The frame size is
> 1083744 bytes, which is exactly 848*639*2 (NOT 846*639*2)!

The OMAP3 ISP pads lines to multiples of 32 or 64 bytes when reading 
from/writing to memory. 846 pixels * 2 bytes per pixel is not a multiple of 32 
bytes, so the line length gets padded to the next multiple, 848 pixels in this 
case. The information is reported by the bytesperline field of the 
v4l2_pix_format structure returned by VIDIOC_G_FMT and VIDIOC_S_FMT on the 
preview engine output video node. You need to take the padding into account in 
your application, that should solve your issue. raw2rgbpnm tries to detect 
padding at the end of lines, and skips it automatically.

> Then I transformed the "bad" yuv-picture with raw2rgbpnm which gives me a
> good picture with both frame-sizes (see bad-frame-846x639.pnm and
> bad-frame-848x639_on_display.bmp in [6]). So the picture-information seems
> to be good, but I guess that the input-size is configured badly by the
> driver. If you look in the isp-datasheet [7] in table 6-40 (page 1201) you
> see, that the CFA interpolation block for bayer-mode crops 4 px per line
> and 4 lines. So shouldn't we respect this in the preview_config_input_size
> function? My RFC is:
> 
> Index: git/drivers/media/video/omap3isp/isppreview.c
> ===================================================================
> --- git.orig/drivers/media/video/omap3isp/isppreview.c	2012-07-05
> 10:59:33.675358396 +0200 +++
> git/drivers/media/video/omap3isp/isppreview.c	2012-07-05 
12:14:33.723223514
> +0200 @@ -1140,6 +1140,12 @@
>  	}
>  	if (features & (OMAP3ISP_PREV_CHROMA_SUPP | OMAP3ISP_PREV_LUMAENH))
>  		sph -= 2;
> +	if (features & OMAP3ISP_PREV_CFA) {
> +		sph -= 2;
> +		eph += 2;
> +		slv -= 2;
> +		elv += 2;
> +	}
> 
>  	isp_reg_writel(isp, (sph << ISPPRV_HORZ_INFO_SPH_SHIFT) | eph,
>  		       OMAP3_ISP_IOMEM_PREV, ISPPRV_HORZ_INFO);
> ===================================================================
> NOTE: This still gives an unusable picture at the previewer output BUT if I
> extend the pipeline to the resizer output, the picture is good. So I must
> be missing something...
> 
> It would be nice, if someone could tell me, if my assumptions are right and
> point me the right direction.
> 
> Further information:
> - Bootup dmesg: [2]
> - Configuration of the pipe with mediactl, capturing of an image with yavta
> and analyze of the image with raw2rgbpnm: [3]
> 
> [1]
> http://git.linuxtv.org/pinchartl/media.git/commit/019214973ee4f03c8f2d58246
> 8b914fcf3385089 [2] http://pastebin.com/7PQnzcmx
> [3] http://pastebin.com/ChEaYHMy
> [4] https://github.com/Angstrom-distribution/setup-scripts
> [5] git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap.git
> [6] https://www.dropbox.com/sh/p2fy5u4i71c3vy8/Fyya25YqK-
> [7] http://www.ti.com/lit/ug/sprugn4q/sprugn4q.pdf

-- 
Regards,

Laurent Pinchart

