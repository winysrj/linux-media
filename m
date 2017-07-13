Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38493 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752279AbdGMRtZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Jul 2017 13:49:25 -0400
Subject: Re: [PATCH v2 08/14] v4l: vsp1: Add support for new VSP2-BS, VSP2-DL
 and VSP2-D instances
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
References: <20170626181226.29575-1-laurent.pinchart+renesas@ideasonboard.com>
 <20170626181226.29575-9-laurent.pinchart+renesas@ideasonboard.com>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <22c14966-67d6-82b2-e305-d371efde0d23@ideasonboard.com>
Date: Thu, 13 Jul 2017 18:49:19 +0100
MIME-Version: 1.0
In-Reply-To: <20170626181226.29575-9-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 26/06/17 19:12, Laurent Pinchart wrote:
> New Gen3 SoCs come with two new VSP2 variants names VSP2-BS and VSP2-DL,
> as well as a new VSP2-D variant on V3M and V3H SoCs. Add new entries for
> them in the VSP device info table.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Code in the patch looks OK - but I can't see where the difference between the
horizontal widths are supported between VSPD H3/VC

I see this in the datasheet: (32.1.1.6 in this particular part)

Direct connection to display module
— Supporting 4096 pixels in horizontal direction [R-Car H3/R-Car M3-W/ R-Car M3-N]
— Supporting 2048 pixels in horizontal direction [R-Car V3M/R-Car V3H/R-Car
D3/R-Car E3]

Do we have this information encoded anywhere? or are they just talking about
maximum performance capability there?

Also some features that are implied as supported aren't mentioned - but that's
not a blocker to adding in the initial devices at all.

Therefore:

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> ---
>  drivers/media/platform/vsp1/vsp1_drv.c  | 24 ++++++++++++++++++++++++
>  drivers/media/platform/vsp1/vsp1_regs.h | 15 +++++++++++++--
>  2 files changed, 37 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
> index 6a9aeb71aedf..c4f2ac61f7d2 100644
> --- a/drivers/media/platform/vsp1/vsp1_drv.c
> +++ b/drivers/media/platform/vsp1/vsp1_drv.c
> @@ -710,6 +710,14 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
>  		.num_bru_inputs = 5,
>  		.uapi = true,
>  	}, {
> +		.version = VI6_IP_VERSION_MODEL_VSPBS_GEN3,
> +		.model = "VSP2-BS",
> +		.gen = 3,
> +		.features = VSP1_HAS_BRS,

32.1.1.5 implies:

| VSP1_HAS_WPF_VFLIP

But Figure 32.5 implies that it doesn't ...

Figure 32.5 also implies that | VSP1_HAS_CLU is there too on both RPF0, and RPF1

> +		.rpf_count = 2,
> +		.wpf_count = 1,
> +		.uapi = true,
> +	}, {
>  		.version = VI6_IP_VERSION_MODEL_VSPD_GEN3,
>  		.model = "VSP2-D",
>  		.gen = 3,
> @@ -717,6 +725,22 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
>  		.rpf_count = 5,
>  		.wpf_count = 2,
>  		.num_bru_inputs = 5,
> +	}, {
> +		.version = VI6_IP_VERSION_MODEL_VSPD_V3,
> +		.model = "VSP2-D",
> +		.gen = 3,
> +		.features = VSP1_HAS_BRS | VSP1_HAS_BRU | VSP1_HAS_LIF,
> +		.rpf_count = 5,
> +		.wpf_count = 1,
> +		.num_bru_inputs = 5,
> +	}, {
> +		.version = VI6_IP_VERSION_MODEL_VSPDL_GEN3,
> +		.model = "VSP2-DL",
> +		.gen = 3,
> +		.features = VSP1_HAS_BRS | VSP1_HAS_BRU | VSP1_HAS_LIF,

Hrm. 32.1.1.7 says:
— Vertical flipping in case of output to memory.
So thats some sort of a conditional : | VSP1_HAS_WPF_VFLIP

So looking at this and the settings of the existing models, I guess it looks
like we don't support flip if we have an LIF output (as that would then be
unsupported)

> +		.rpf_count = 5,
> +		.wpf_count = 2,
> +		.num_bru_inputs = 5,
>  	},
>  };
>  
> diff --git a/drivers/media/platform/vsp1/vsp1_regs.h b/drivers/media/platform/vsp1/vsp1_regs.h
> index 744217e020b9..ab439a60a100 100644
> --- a/drivers/media/platform/vsp1/vsp1_regs.h
> +++ b/drivers/media/platform/vsp1/vsp1_regs.h
> @@ -699,9 +699,20 @@
>  #define VI6_IP_VERSION_MODEL_VSPBD_GEN3	(0x15 << 8)
>  #define VI6_IP_VERSION_MODEL_VSPBC_GEN3	(0x16 << 8)
>  #define VI6_IP_VERSION_MODEL_VSPD_GEN3	(0x17 << 8)
> +#define VI6_IP_VERSION_MODEL_VSPD_V3	(0x18 << 8)
> +#define VI6_IP_VERSION_MODEL_VSPDL_GEN3	(0x19 << 8)
> +#define VI6_IP_VERSION_MODEL_VSPBS_GEN3	(0x1a << 8)
>  #define VI6_IP_VERSION_SOC_MASK		(0xff << 0)
> -#define VI6_IP_VERSION_SOC_H		(0x01 << 0)
> -#define VI6_IP_VERSION_SOC_M		(0x02 << 0)
> +#define VI6_IP_VERSION_SOC_H2		(0x01 << 0)
> +#define VI6_IP_VERSION_SOC_V2H		(0x01 << 0)
> +#define VI6_IP_VERSION_SOC_V3M		(0x01 << 0)
> +#define VI6_IP_VERSION_SOC_M2		(0x02 << 0)
> +#define VI6_IP_VERSION_SOC_M3W		(0x02 << 0)
> +#define VI6_IP_VERSION_SOC_V3H		(0x02 << 0)
> +#define VI6_IP_VERSION_SOC_H3		(0x03 << 0)
> +#define VI6_IP_VERSION_SOC_D3		(0x04 << 0)
> +#define VI6_IP_VERSION_SOC_M3N		(0x04 << 0)
> +#define VI6_IP_VERSION_SOC_E3		(0x04 << 0)
>  
>  /* -----------------------------------------------------------------------------
>   * RPF CLUT Registers
> 
