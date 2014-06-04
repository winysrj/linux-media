Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56196 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbaFDOtK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Jun 2014 10:49:10 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH v2 1/5] [media] mt9v032: reset is self clearing
Date: Wed, 04 Jun 2014 16:49:37 +0200
Message-ID: <2378157.AyxZjdgtXs@avalon>
In-Reply-To: <1401788155-3690-2-git-send-email-p.zabel@pengutronix.de>
References: <1401788155-3690-1-git-send-email-p.zabel@pengutronix.de> <1401788155-3690-2-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

Thank you for the patch.

On Tuesday 03 June 2014 11:35:51 Philipp Zabel wrote:
> According to the publicly available MT9V032 data sheet, the reset bits are
> self clearing and the reset register always reads 0. The reset will be
> asserted for 15 SYSCLK cycles. Instead of writing 0 to the register, wait
> using ndelay.

On the other hand, revision D of the datasheet states on page 71 ("Appendix A 
- Serial Configurations, Figure 46: Stand-Alone Topology") that the typical 
configuration of the sensor includes issuing a soft reset with 

4. Issue a soft reset (set R0x0C[0] = 1 followed by R0x0C[0] = 0.

I wonder whether it wouldn't be safer to keep the register write. Do you see 
any adverse effect of keeping it ?

> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/media/i2c/mt9v032.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
> index f04d0bb..29d8d8f 100644
> --- a/drivers/media/i2c/mt9v032.c
> +++ b/drivers/media/i2c/mt9v032.c
> @@ -315,6 +315,7 @@ mt9v032_update_hblank(struct mt9v032 *mt9v032)
>  static int mt9v032_power_on(struct mt9v032 *mt9v032)
>  {
>  	struct i2c_client *client = v4l2_get_subdevdata(&mt9v032->subdev);
> +	unsigned long rate;
>  	int ret;
> 
>  	ret = clk_set_rate(mt9v032->clk, mt9v032->sysclk);
> @@ -332,9 +333,9 @@ static int mt9v032_power_on(struct mt9v032 *mt9v032)
>  	if (ret < 0)
>  		return ret;
> 
> -	ret = mt9v032_write(client, MT9V032_RESET, 0);
> -	if (ret < 0)
> -		return ret;
> +	/* Wait 15 SYSCLK cycles, 564 ns @ 26.6 MHz */
> +	rate = clk_get_rate(mt9v032->clk);
> +	ndelay(DIV_ROUND_UP(15 * 125000000, rate >> 3));
> 
>  	return mt9v032_write(client, MT9V032_CHIP_CONTROL, 0);
>  }

-- 
Regards,

Laurent Pinchart

