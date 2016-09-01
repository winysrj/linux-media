Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51818 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750846AbcIAWqz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2016 18:46:55 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: mchehab@kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] vsp1: add R8A7792 VSP1V support
Date: Fri, 02 Sep 2016 01:47:18 +0300
Message-ID: <2246517.O4DQlKpR2A@avalon>
In-Reply-To: <10305550.upKOiT5SIy@wasted.cogentembedded.com>
References: <10305550.upKOiT5SIy@wasted.cogentembedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergei,

Thank you for the patch.

On Saturday 20 Aug 2016 00:57:59 Sergei Shtylyov wrote:
> Add  support for the R8A7792 VSP1V cores which are different from the other
> gen2 VSP1 cores...
> 
> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> 
> ---
> This patch is against the 'media_tree.git' repo's 'master' branch.

The vsp1/next branch of my media.git tree contains a few patches that conflict 
with this patch. I've resolved the conflicts manually and pushed the result to

	git://linuxtv.org/pinchartl/media.git vsp1/next

Could you please check the conflict resolution ?

Could you please also give me the full 32-bit IP version number for the VSP1V-
D and VSP1V-S on R8A7792 ?

>  drivers/media/platform/vsp1/vsp1_drv.c  |   20 ++++++++++++++++++++
>  drivers/media/platform/vsp1/vsp1_regs.h |    2 ++
>  2 files changed, 22 insertions(+)
> 
> Index: media_tree/drivers/media/platform/vsp1/vsp1_drv.c
> ===================================================================
> --- media_tree.orig/drivers/media/platform/vsp1/vsp1_drv.c
> +++ media_tree/drivers/media/platform/vsp1/vsp1_drv.c
> @@ -596,6 +596,26 @@ static const struct vsp1_device_info vsp
>  		.num_bru_inputs = 4,
>  		.uapi = true,
>  	}, {
> +		.version = VI6_IP_VERSION_MODEL_VSPS_V2H,
> +		.gen = 2,
> +		.features = VSP1_HAS_BRU | VSP1_HAS_CLU | VSP1_HAS_LUT |
> +			    VSP1_HAS_SRU | VSP1_HAS_WPF_VFLIP,
> +		.rpf_count = 4,
> +		.uds_count = 1,
> +		.wpf_count = 4,
> +		.num_bru_inputs = 4,
> +		.uapi = true,
> +	}, {
> +		.version = VI6_IP_VERSION_MODEL_VSPD_V2H,
> +		.gen = 2,
> +		.features = VSP1_HAS_BRU | VSP1_HAS_CLU | VSP1_HAS_LUT |
> +			    VSP1_HAS_LIF,
> +		.rpf_count = 4,
> +		.uds_count = 1,
> +		.wpf_count = 1,
> +		.num_bru_inputs = 4,
> +		.uapi = true,
> +	}, {
>  		.version = VI6_IP_VERSION_MODEL_VSPI_GEN3,
>  		.gen = 3,
>  		.features = VSP1_HAS_CLU | VSP1_HAS_LUT | VSP1_HAS_SRU
> Index: media_tree/drivers/media/platform/vsp1/vsp1_regs.h
> ===================================================================
> --- media_tree.orig/drivers/media/platform/vsp1/vsp1_regs.h
> +++ media_tree/drivers/media/platform/vsp1/vsp1_regs.h
> @@ -660,6 +660,8 @@
>  #define VI6_IP_VERSION_MODEL_VSPR_H2	(0x0a << 8)
>  #define VI6_IP_VERSION_MODEL_VSPD_GEN2	(0x0b << 8)
>  #define VI6_IP_VERSION_MODEL_VSPS_M2	(0x0c << 8)
> +#define VI6_IP_VERSION_MODEL_VSPS_V2H	(0x12 << 8)
> +#define VI6_IP_VERSION_MODEL_VSPD_V2H	(0x13 << 8)
>  #define VI6_IP_VERSION_MODEL_VSPI_GEN3	(0x14 << 8)
>  #define VI6_IP_VERSION_MODEL_VSPBD_GEN3	(0x15 << 8)
>  #define VI6_IP_VERSION_MODEL_VSPBC_GEN3	(0x16 << 8)

-- 
Regards,

Laurent Pinchart

