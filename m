Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44328 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070Ab2K0QvS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Nov 2012 11:51:18 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Adam Wozniak <awozniak@irobot.com>
Cc: linux-omap@vger.kernel.org, linux-media@vger.kernel.org,
	sakari.ailus@iki.fi
Subject: Re: need help debugging ISP problem
Date: Tue, 27 Nov 2012 17:52:21 +0100
Message-ID: <1508686.Xvv8pOooM8@avalon>
In-Reply-To: <50985380.8000706@irobot.com>
References: <50985380.8000706@irobot.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Adam,

On Monday 05 November 2012 16:02:08 Adam Wozniak wrote:
> I'm working with a custom board based on an Overo WaterStorm com. The
> processor is a DM3730.  The kernel is 2.6.32 based.

2.6.32 very probably means you're using the old TI driver. Please don't. 
That's buggy and totally unsupported. I advice upgrading to the latest 
mainline kernel.

> I'm trying to stress test the camera ISP by rapidly opening and closing
> the video device with ( while true; do gst-launch v4l2src
> device=/dev/video0 ! video/x-raw-yuv,width=320,height=240 !
> ffmpegcolorspace ! pngenc snapshot=true ! fakesink; done )
> 
> After many iterations, I will see the kernel spit out:
> 
> [ 2502.802795] Unhandled fault: external abort on non-linefetch (0x1028)
> at 0xfa0bce04
> [ 2502.810516] Internal error: : 1028 [#1]
> [ ... ]
> [ 2502.846893] PC is at isp_reg_readl+0x18/0x20
> [ 2502.851196] LR is at isp_reg_readl+0x10/0x20
> [ ... ]
> [ 2503.296447] [<c02954a0>] (isp_reg_readl+0x18/0x20) from [<c02954f8>]
> (isp_reg_and_or+0x1c/0x38)
> [ 2503.305206] [<c02954f8>] (isp_reg_and_or+0x1c/0x38) from [<c029bad0>]
> (isppreview_config_cfa+0x38/0x90)
> [ 2503.314666] [<c029bad0>] (isppreview_config_cfa+0x38/0x90) from
> [<c029bc5c>] (isppreview_config_datapath+0x134/0x330)
> [ 2503.325347] [<c029bc5c>] (isppreview_config_datapath+0x134/0x330)
> from [<c029be68>] (isppreview_s_pipeline+0x10/0xd0)
> [ 2503.336029] [<c029be68>] (isppreview_s_pipeline+0x10/0xd0) from
> [<c0296e98>] (isp_s_pipeline+0x1d8/0x280)
> [ 2503.345672] [<c0296e98>] (isp_s_pipeline+0x1d8/0x280) from
> [<bf036b98>] (cammux_streamon+0x218/0xa28 [cammux])
> [ ... ]
> 
> 
> The register we're trying to access here is the ISP PRV_PCR.  If I try
> to add debug code to read ISP_CTRL right before the fault, the ISP_CTRL
> access faults in the same way (i.e. the whole ISP is borked, not just
> the previewer).
> 
> At first I thought the clocks were being disabled somehow, but tracking
> them seems to indicate that's not the case.  Adding an early return in
> arch/arm/mach/omap2/clock.c omap2_dflt_clk_disable() (i.e. to disable
> disabling of clocks) does NOT help.
> 
> What else might I be missing?  What is necessary to be able to read the
> ISP registers?

-- 
Regards,

Laurent Pinchart

