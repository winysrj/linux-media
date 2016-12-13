Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:41678 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754044AbcLMVTs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Dec 2016 16:19:48 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: mchehab@kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] vsp1: remove UAPI support for R-Car gen2 VSPDs
Date: Tue, 13 Dec 2016 23:20:12 +0200
Message-ID: <4446499.7CBsrQanHE@avalon>
In-Reply-To: <3095242.0tNrk30rsv@wasted.cogentembedded.com>
References: <3095242.0tNrk30rsv@wasted.cogentembedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergei,

On Wednesday 14 Dec 2016 00:15:34 Sergei Shtylyov wrote:
> We  are going to use the  R-Car  gen2 VSPDs as the DU compositors, so will
> have to disable  the UAPI support for them...

I'm glad to know that you have a use case for the Gen3 VSP-based DU 
composition on Gen2, but the VSPD on Gen2 can be used standalone, so I don't 
think this patch is applicable to mainline.

> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> 
> ---
> This patch is against the 'media_tree.git' repo's 'master' branch.
> 
>  drivers/media/platform/vsp1/vsp1_drv.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> Index: media_tree/drivers/media/platform/vsp1/vsp1_drv.c
> ===================================================================
> --- media_tree.orig/drivers/media/platform/vsp1/vsp1_drv.c
> +++ media_tree/drivers/media/platform/vsp1/vsp1_drv.c
> @@ -588,7 +588,6 @@ static const struct vsp1_device_info vsp
>  		.uds_count = 1,
>  		.wpf_count = 1,
>  		.num_bru_inputs = 4,
> -		.uapi = true,
>  	}, {
>  		.version = VI6_IP_VERSION_MODEL_VSPS_M2,
>  		.model = "VSP1-S",

-- 
Regards,

Laurent Pinchart

