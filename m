Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57550 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989AbbBDRTA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Feb 2015 12:19:00 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] mt9p031: fixed calculation of clk_div
Date: Wed, 04 Feb 2015 19:19:45 +0200
Message-ID: <2403470.jYcXEMRiZi@avalon>
In-Reply-To: <1423061612-12623-1-git-send-email-enrico.scholz@sigma-chemnitz.de>
References: <1423061612-12623-1-git-send-email-enrico.scholz@sigma-chemnitz.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Enrico,

Thank you for the patch.

On Wednesday 04 February 2015 15:53:32 Enrico Scholz wrote:
> There must be used 'min_t', not 'max_t' for calculating the divider

That I agree with.

> and the upper limit is '63' (value uses 6:0 register bits).

And this I don't. You can encode numbers from 0 to 127 on 7 bits.

> Signed-off-by: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
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
> +		mt9p031->clk_div = min_t(unsigned int, div, 63);
>  		mt9p031->use_pll = false;
> 
>  		return 0;

-- 
Regards,

Laurent Pinchart

