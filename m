Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35215 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933181AbeBVQGh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Feb 2018 11:06:37 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc: linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-renesas-soc@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 1/4] v4l: vsp1: fix mask creation for MULT_ALPHA_RATIO
Date: Thu, 22 Feb 2018 18:07:20 +0200
Message-ID: <2482046.sGQsectxr6@avalon>
In-Reply-To: <20180205201002.23621-2-wsa+renesas@sang-engineering.com>
References: <20180205201002.23621-1-wsa+renesas@sang-engineering.com> <20180205201002.23621-2-wsa+renesas@sang-engineering.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Wolfram,

Thank you for the patch.

On Monday, 5 February 2018 22:09:58 EET Wolfram Sang wrote:
> Due to a typo, the mask was destroyed by a comparison instead of a bit
> shift. No regression since the mask has not been used yet.
> 
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>

Oops.

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and taken in my tree.

> ---
> Only build tested. To be applied individually per subsystem.
> 
>  drivers/media/platform/vsp1/vsp1_regs.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_regs.h
> b/drivers/media/platform/vsp1/vsp1_regs.h index
> 26c4ffad2f4656..b1912c83a1dae2 100644
> --- a/drivers/media/platform/vsp1/vsp1_regs.h
> +++ b/drivers/media/platform/vsp1/vsp1_regs.h
> @@ -225,7 +225,7 @@
>  #define VI6_RPF_MULT_ALPHA_P_MMD_RATIO	(1 << 8)
>  #define VI6_RPF_MULT_ALPHA_P_MMD_IMAGE	(2 << 8)
>  #define VI6_RPF_MULT_ALPHA_P_MMD_BOTH	(3 << 8)
> -#define VI6_RPF_MULT_ALPHA_RATIO_MASK	(0xff < 0)
> +#define VI6_RPF_MULT_ALPHA_RATIO_MASK	(0xff << 0)
>  #define VI6_RPF_MULT_ALPHA_RATIO_SHIFT	0
> 
>  /* ------------------------------------------------------------------------

-- 
Regards,

Laurent Pinchart
