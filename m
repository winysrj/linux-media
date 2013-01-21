Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40025 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895Ab3AUKRY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jan 2013 05:17:24 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Johannes Schellen <Johannes.Schellen@rwth-aachen.de>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] omap3isp: Fix histogram regions
Date: Mon, 21 Jan 2013 11:19:06 +0100
Message-ID: <1458907.C3QX6jGXBz@avalon>
In-Reply-To: <0MGG003PWV15AG70@relay-auth-2.ms.rz.rwth-aachen.de>
References: <0MGG003PWV15AG70@relay-auth-2.ms.rz.rwth-aachen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Johannes,

On Friday 11 January 2013 16:00:19 Johannes Schellen wrote:
> From: Johannes Schellen <Johannes.Schellen@rwth-aachen.de>
> 
> This patch fixes a bug which causes all histogram regions to start in the
> top left corner of the image. The histogram region coordinates are 16 bit
> values which share a 32 bit register. The bug is due to the region end
> value assignments overwriting the region start values with zero.
> Signed-off-by: Johannes Schellen <Johannes.Schellen@rwth-aachen.de>

Good catch, thanks.

I've applied the patch to my tree.

> ---
> The patch is against v3.8-rc3
> 
> --- linux-3.8-rc3/drivers/media/platform/omap3isp/isphist.c.orig
> +++ linux-3.8-rc3/drivers/media/platform/omap3isp/isphist.c
> @@ -114,14 +114,14 @@ static void hist_setup_regs(struct ispst
>  	/* Regions size and position */
>  	for (c = 0; c < OMAP3ISP_HIST_MAX_REGIONS; c++) {
>  		if (c < conf->num_regions) {
> -			reg_hor[c] = conf->region[c].h_start <<
> -				     ISPHIST_REG_START_SHIFT;
> -			reg_hor[c] = conf->region[c].h_end <<
> -				     ISPHIST_REG_END_SHIFT;
> -			reg_ver[c] = conf->region[c].v_start <<
> -				     ISPHIST_REG_START_SHIFT;
> -			reg_ver[c] = conf->region[c].v_end <<
> -				     ISPHIST_REG_END_SHIFT;
> +			reg_hor[c] = (conf->region[c].h_start <<
> +				     ISPHIST_REG_START_SHIFT)
> +			           | (conf->region[c].h_end <<
> +				     ISPHIST_REG_END_SHIFT);
> +			reg_ver[c] = (conf->region[c].v_start <<
> +				     ISPHIST_REG_START_SHIFT)
> +			           | (conf->region[c].v_end <<
> +				     ISPHIST_REG_END_SHIFT);
>  		} else {
>  			reg_hor[c] = 0;
>  			reg_ver[c] = 0;

-- 
Regards,

Laurent Pinchart

