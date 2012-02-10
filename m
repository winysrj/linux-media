Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58431 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722Ab2BJRDy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Feb 2012 12:03:54 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kruno Mrak <kruno.mrak@matrix-vision.de>
Cc: linux-media@vger.kernel.org, sakari.ailus@iki.fi
Subject: Re: omap3isp: sequence number in v4l2 buffer not incremented
Date: Fri, 10 Feb 2012 18:03:51 +0100
Message-ID: <2282092.nIujHkTqeG@avalon>
In-Reply-To: <4F35434E.6020405@matrix-vision.de>
References: <4F202102.5070701@matrix-vision.de> <3002082.9RrLpdpVPL@avalon> <4F35434E.6020405@matrix-vision.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kruno,

On Friday 10 February 2012 17:18:22 Kruno Mrak wrote:
> Laurent,
> 
> thank you for the patch.
> It was a bit tricky to get it work as our kernel is based
> on 2.6.38, but i succeeded.
> The frame_number is incremented now.

Thanks for the confirmation. I'll test the patch with the CCP2 and CSI2 
receivers, and I'll then push it to mainline.

> The following changes are not clear to me, are they really necessary to
> get frame_number incremented?

It isn't when using the CCDC parallel input. It removes frame number 
incrementation from the CCP2 module, as the frame number is now incremented in 
the CCDC module.

> @@ -350,7 +337,6 @@ static void ccp2_lcx_config(struct isp_ccp2_device
> *ccp2,
>  	      ISPCCP2_LC01_IRQSTATUS_LC0_CRC_IRQ |
>  	      ISPCCP2_LC01_IRQSTATUS_LC0_FSP_IRQ |
>  	      ISPCCP2_LC01_IRQSTATUS_LC0_FW_IRQ |
> -	      ISPCCP2_LC01_IRQSTATUS_LC0_FS_IRQ |
>  	      ISPCCP2_LC01_IRQSTATUS_LC0_FSC_IRQ |
>  	      ISPCCP2_LC01_IRQSTATUS_LC0_SSC_IRQ;
> 
> @@ -378,21 +378,17 @@ static void csi2_timing_config(struct isp_device *isp,
> static void csi2_irq_ctx_set(struct isp_device *isp,
>  			     struct isp_csi2_device *csi2, int enable)
>  {
> -	u32 reg = ISPCSI2_CTX_IRQSTATUS_FE_IRQ;
>  	int i;
> 
> -	if (csi2->use_fs_irq)
> -		reg |= ISPCSI2_CTX_IRQSTATUS_FS_IRQ;
> -
>  	for (i = 0; i < 8; i++) {
> -		isp_reg_writel(isp, reg, csi2->regs1,
> +		isp_reg_writel(isp, ISPCSI2_CTX_IRQSTATUS_FE_IRQ, csi2->regs1,
>  			       ISPCSI2_CTX_IRQSTATUS(i));
>  		if (enable)
>  			isp_reg_set(isp, csi2->regs1, ISPCSI2_CTX_IRQENABLE(i),
> -				    reg);
> +				    ISPCSI2_CTX_IRQSTATUS_FE_IRQ);
>  		else
>  			isp_reg_clr(isp, csi2->regs1, ISPCSI2_CTX_IRQENABLE(i),
> -				    reg);
> +				    ISPCSI2_CTX_IRQSTATUS_FE_IRQ);
>  	}
>  }

-- 
Regards,

Laurent Pinchart
