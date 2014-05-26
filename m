Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47618 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbaEZMz6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 May 2014 08:55:58 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] mt9v032: fix hblank calculation
Date: Mon, 26 May 2014 14:56:16 +0200
Message-ID: <10306015.xT1Dl4KFnB@avalon>
In-Reply-To: <1400831277-2108-1-git-send-email-p.zabel@pengutronix.de>
References: <1400831277-2108-1-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

Thank you for the patch.

On Friday 23 May 2014 09:47:57 Philipp Zabel wrote:
> Since (min_row_time - crop->width) can be negative, we have to do a signed
> comparison here. Otherwise max_t casts the negative value to unsigned int
> and sets min_hblank to that invalid value.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/media/i2c/mt9v032.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
> index 40172b8..4d7afad 100644
> --- a/drivers/media/i2c/mt9v032.c
> +++ b/drivers/media/i2c/mt9v032.c
> @@ -305,7 +305,7 @@ mt9v032_update_hblank(struct mt9v032 *mt9v032)
> 
>  	if (mt9v032->version->version == MT9V034_CHIP_ID_REV1)
>  		min_hblank += (mt9v032->hratio - 1) * 10;
> -	min_hblank = max_t(unsigned int, (int)mt9v032->model->data->min_row_time
> - crop->width,
> +	min_hblank = max_t(int, (int)mt9v032->model->data->min_row_time
> - crop->width, (int)min_hblank);

As max_t now casts to int, wouldn't it make sense to remove the manual casts 
on both operands ? The first one is useless anyway, as the compiler will cast
mt9v032->model->data->min_row_time back to an unsigned int as crop->width is 
unsigned.

>  	hblank = max_t(unsigned int, mt9v032->hblank, min_hblank);

-- 
Regards,

Laurent Pinchart

