Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56925 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbaATXs4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jan 2014 18:48:56 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Peter Meerwald <pmeerw@pmeerw.net>
Cc: Tom <Bassai_Dai@gmx.net>, linux-media@vger.kernel.org,
	sakari.ailus@iki.fi
Subject: Re: ov3640 sensor -> CCDC won't become idle!
Date: Tue, 21 Jan 2014 00:49:40 +0100
Message-ID: <12760951.pQTrRGePo2@avalon>
In-Reply-To: <alpine.DEB.2.01.1401171507560.20274@pmeerw.net>
References: <loom.20130909T145536-271@post.gmane.org> <alpine.DEB.2.01.1401171507560.20274@pmeerw.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Peter,

On Friday 17 January 2014 15:45:22 Peter Meerwald wrote:
> Hello,
> 
> > as the subject says I got a problem with the ccdc.
> > 
> > My pipeline is: sensor -> ccdc -> memory
> > 
> > By doing some research I found a appropriate answer from Laurent:
> > 
> > "The OMAP3 ISP is quite picky about its input signals and doesn't
> > gracefully handle missing or extra sync pulses for instance. A "CCDC
> > won't become idle!" message usually indicates that the CCDC received a
> > frame of unexpected size (this can happen if the sensor stops in the
> > middle of a frame for instance), or that the driver had no time to
> > process the end of frame interrupt before the next frame arrived (either
> > because of an unsually long interrupt delay on the system, or because of
> > too low vertical blanking)."
> > 
> > That sounds logical, but whatever I do nothing works for me.
> > 
> > Can anyone who had that problem share what you did to solve that problem?
> > Or does anyone have a hint for me how to solve this?
> 
> I think I've stumbled upon a solution for this problem (stream doesn't start
> properly, resulting in 'CCDC won't become idle') today; the idea is to delay
> ccdc_enable() and SYN_MODE_VDHDEN after the first VSYNC has been received
> 
> the assumption is that the ov3640 outputs HSYNC/VSYNC in some
> weird/undeterministic way when started, but stabilizes afterwards; the OMAP3
> ISP gets confused by inproper HSYNC/VSYNC and never recovers...
> 
> OMAP3 ISP observations:
> SYN_MODE_VDHDEN enables the VSYNC/HSYNC processing of the CCDC (when
> VSYNC/HSYNC configured as input) of the ISP, i.e. the ISP starts counting
> horizontal lines needed to trigger VDINT0/VDINT1
> 
> the VS_HS_IRQ can be configured to trigger on VSYNC, this is independent
> from SYN_MODE_VDHDEN and VDINT0/VDINT1 and works even when neither
> SYN_MODE_VDHDEN nor CCDC_PCR_EN is set (i.e. before starting the CCDC)
> 
> so ccdc_hs_vs_isr() can be used to trigger on the first (maybe n-th) VSYNC
> (when the ov3640 has stabilized); at this point SYN_MODE_VDHDEN and
> CCDC_PCR_EN can be turn on
> 
> so the workflow is as follows:
> 
> 1. configure ISP: ccdc_set_stream() but no ccdc_enable() and no
> SYN_MODE_VDHDEN
> 2. start ov3640: ov3640_set_stream()
> 3. wait for VSYNC to trigger, enable SYN_MODE_VDHDEN and ccdc_enable() in
> ccdc_hs_vs_isr()
> 
> works for me :)
> tested with beagle-xm, ov3640 (Laurent's patches) in YUV 640x480, ISP
> direct to memory, kernel 3.7
> 
> the patch below illustrates this

The best solution would obviously be to find out why the OV3640 doesn't start 
correctly and fix that. However, I've tried pretty hard to do so in the past, 
and the lack of support from Omnivision (not mentioning the bad documentation 
quality) eventually made me give up. It thus believe it's reasonable to work 
around the problem on the OMAP3 ISP side.

How to mainline this is a different issue. The patch below is a good start and 
might need a bit of clean up to make it more generic (by skipping a 
configurable amount of VSYNCs for instance, and making this configurable 
somehow). On the other hand I don't think we want to introduce the same 
feature to all the ISP drivers that could be used with the OV3640 sensor, and 
there might not be a compelling reason to treat the OMAP3 ISP driver in a 
special way. Sakari, could I ask you for your opinion ?

> regards, p.
> 
> 
> diff --git a/drivers/media/platform/omap3isp/ispccdc.c
> b/drivers/media/platform/omap3isp/ispccdc.c index aa9df9d..7d587ee 100644
> --- a/drivers/media/platform/omap3isp/ispccdc.c
> +++ b/drivers/media/platform/omap3isp/ispccdc.c
> @@ -976,7 +976,8 @@ static void ccdc_config_sync_if(struct isp_ccdc_device
> *ccdc, {
>  	struct isp_device *isp = to_isp_device(ccdc);
>  	const struct v4l2_mbus_framefmt *format;
> -	u32 syn_mode = ISPCCDC_SYN_MODE_VDHDEN;
> +	u32 syn_mode = 0; // ISPCCDC_SYN_MODE_VDHDEN;
> +	ccdc->vdhden = 0;
> 
>  	format = &ccdc->formats[CCDC_PAD_SINK];
> 
> @@ -1416,9 +1417,19 @@ static int __ccdc_handle_stopping(struct
> isp_ccdc_device *ccdc, u32 event) static void ccdc_hs_vs_isr(struct
> isp_ccdc_device *ccdc)
>  {
>  	struct isp_pipeline *pipe = to_isp_pipeline(&ccdc->subdev.entity);
> +	struct isp_device *isp = to_isp_device(ccdc);
>  	struct video_device *vdev = ccdc->subdev.devnode;
>  	struct v4l2_event event;
> 
> +	if (!ccdc->vdhden) {
> +		isp_reg_set(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE,
> +			ISPCCDC_SYN_MODE_VDHDEN);
> +		ccdc_enable(ccdc);
> +		ccdc->vdhden = 1;
> +
> +		return;
> +	}
> +
>  	/* Frame number propagation */
>  	atomic_inc(&pipe->frame_number);
> 
> @@ -1765,8 +1776,9 @@ static int ccdc_set_stream(struct v4l2_subdev *sd, int
> enable) if (ccdc->output & CCDC_OUTPUT_MEMORY)
>  			omap3isp_sbl_enable(isp, OMAP3_ISP_SBL_CCDC_WRITE);
> 
> -		if (ccdc->underrun || !(ccdc->output & CCDC_OUTPUT_MEMORY))
> -			ccdc_enable(ccdc);
> +		if (ccdc->underrun || !(ccdc->output & CCDC_OUTPUT_MEMORY)) {
> +//			ccdc_enable(ccdc);
> +		}
> 
>  		ccdc->underrun = 0;
>  		break;
> diff --git a/drivers/media/platform/omap3isp/ispccdc.h
> b/drivers/media/platform/omap3isp/ispccdc.h index a5da9e1..a502bc3 100644
> --- a/drivers/media/platform/omap3isp/ispccdc.h
> +++ b/drivers/media/platform/omap3isp/ispccdc.h
> @@ -146,6 +146,7 @@ struct isp_ccdc_device {
>  	struct ispccdc_lsc lsc;
>  	unsigned int update;
>  	unsigned int shadow_update;
> +	unsigned int vdhden;
> 
>  	unsigned int underrun:1;
>  	enum isp_pipeline_stream_state state;

-- 
Regards,

Laurent Pinchart

