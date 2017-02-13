Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48285 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752528AbdBMV34 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 16:29:56 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        kieran.bingham@ideasonboard.com
Subject: Re: [PATCH 1/8] v4l: vsp1: Provide UDS register updates
Date: Mon, 13 Feb 2017 23:30:21 +0200
Message-ID: <2133199.0UdPgKqoXa@avalon>
In-Reply-To: <bf28e7e9bf28ff60c505592072a234f8dd568f71.1486758327.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.ff94a00847faf7ed37768cea68c474926bfc8bd9.1486758327.git-series.kieran.bingham+renesas@ideasonboard.com> <bf28e7e9bf28ff60c505592072a234f8dd568f71.1486758327.git-series.kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Friday 10 Feb 2017 20:27:29 Kieran Bingham wrote:
> Provide register definitions required for UDS phase and partition
> algorithm support

I would mention here that those registers and bits are available on Gen3 only.

> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> ---
>  drivers/media/platform/vsp1/vsp1_regs.h | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_regs.h
> b/drivers/media/platform/vsp1/vsp1_regs.h index 47b1dee044fb..1ad819680e2f
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_regs.h
> +++ b/drivers/media/platform/vsp1/vsp1_regs.h
> @@ -388,6 +388,7 @@
>  #define VI6_UDS_CTRL_NE_RCR		(1 << 18)
>  #define VI6_UDS_CTRL_NE_GY		(1 << 17)
>  #define VI6_UDS_CTRL_NE_BCB		(1 << 16)
> +#define VI6_UDS_CTRL_AMDSLH		(1 << 2)
>  #define VI6_UDS_CTRL_TDIPC		(1 << 1)
> 
>  #define VI6_UDS_SCALE			0x2304
> @@ -420,11 +421,24 @@
>  #define VI6_UDS_PASS_BWIDTH_V_MASK	(0x7f << 0)
>  #define VI6_UDS_PASS_BWIDTH_V_SHIFT	0
> 
> +#define VI6_UDS_HPHASE			0x2314
> +#define VI6_UDS_HPHASE_HSTP_MASK	(0xfff << 16)
> +#define VI6_UDS_HPHASE_HSTP_SHIFT	16
> +#define VI6_UDS_HPHASE_HEDP_MASK	(0xfff << 0)
> +#define VI6_UDS_HPHASE_HEDP_SHIFT	0
> +
>  #define VI6_UDS_IPC			0x2318
>  #define VI6_UDS_IPC_FIELD		(1 << 27)
>  #define VI6_UDS_IPC_VEDP_MASK		(0xfff << 0)
>  #define VI6_UDS_IPC_VEDP_SHIFT		0
> 
> +#define VI6_UDS_HSZCLIP			0x231c
> +#define VI6_UDS_HSZCLIP_HCEN		(1 << 28)
> +#define VI6_UDS_HSZCLIP_HCL_OFST_MASK	(0x1ff << 16)

This field spans 8 bits, not 9.

With that fixed,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> +#define VI6_UDS_HSZCLIP_HCL_OFST_SHIFT	16
> +#define VI6_UDS_HSZCLIP_HCL_SIZE_MASK	(0x1fff << 0)
> +#define VI6_UDS_HSZCLIP_HCL_SIZE_SHIFT	0
> +
>  #define VI6_UDS_CLIP_SIZE		0x2324
>  #define VI6_UDS_CLIP_SIZE_HSIZE_MASK	(0x1fff << 16)
>  #define VI6_UDS_CLIP_SIZE_HSIZE_SHIFT	16

-- 
Regards,

Laurent Pinchart
