Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58411 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757241AbbBEMAc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Feb 2015 07:00:32 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2] [media] mt9p031: fixed calculation of clk_div
Date: Thu, 05 Feb 2015 14:01:17 +0200
Message-ID: <5787881.fq9SL5Zs8d@avalon>
In-Reply-To: <1423072270-20078-1-git-send-email-enrico.scholz@sigma-chemnitz.de>
References: <1423061612-12623-1-git-send-email-enrico.scholz@sigma-chemnitz.de> <1423072270-20078-1-git-send-email-enrico.scholz@sigma-chemnitz.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Enrico,

Thank you for the patch.

On Wednesday 04 February 2015 18:51:10 Enrico Scholz wrote:
> There must be used 'min_t', not 'max_t' for calculating the divider.
> 
> Signed-off-by: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree. I'll send a pull request for v3.21.

> ---
>  drivers/media/i2c/mt9p031.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
> index 0cabf91..43ee299 100644
> --- a/drivers/media/i2c/mt9p031.c
> +++ b/drivers/media/i2c/mt9p031.c
> @@ -254,7 +254,7 @@ static int mt9p031_clk_setup(struct mt9p031 *mt9p031)
>  		div = DIV_ROUND_UP(ext_freq, pdata->target_freq);
>  		div = roundup_pow_of_two(div) / 2;
> 
> -		mt9p031->clk_div = max_t(unsigned int, div, 64);
> +		mt9p031->clk_div = min_t(unsigned int, div, 64);
>  		mt9p031->use_pll = false;
> 
>  		return 0;

-- 
Regards,

Laurent Pinchart

