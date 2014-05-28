Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33645 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbaE1LMW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 May 2014 07:12:22 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v2] [media] mt9v032: fix hblank calculation
Date: Wed, 28 May 2014 13:12:39 +0200
Message-ID: <63696231.uYod94i5s6@avalon>
In-Reply-To: <1401112551-21046-1-git-send-email-p.zabel@pengutronix.de>
References: <1401112551-21046-1-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

Thank you for the patch.

On Monday 26 May 2014 15:55:51 Philipp Zabel wrote:
> Since (min_row_time - crop->width) can be negative, we have to do a signed
> comparison here. Otherwise max_t casts the negative value to unsigned int
> and sets min_hblank to that invalid value.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree. Do you see a need to fasttrack this to v3.16 or can it 
be applied to v3.17 ? Should I CC stable ?

> ---
> Changes since v1:
>  - Remove now unneeded casts to (int).
> ---
>  drivers/media/i2c/mt9v032.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
> index 40172b8..f04d0bb 100644
> --- a/drivers/media/i2c/mt9v032.c
> +++ b/drivers/media/i2c/mt9v032.c
> @@ -305,8 +305,8 @@ mt9v032_update_hblank(struct mt9v032 *mt9v032)
> 
>  	if (mt9v032->version->version == MT9V034_CHIP_ID_REV1)
>  		min_hblank += (mt9v032->hratio - 1) * 10;
> -	min_hblank = max_t(unsigned int, (int)mt9v032->model->data->min_row_time 
-
> crop->width, -			   (int)min_hblank);
> +	min_hblank = max_t(int, mt9v032->model->data->min_row_time - crop->width,
> +			   min_hblank);
>  	hblank = max_t(unsigned int, mt9v032->hblank, min_hblank);
> 
>  	return mt9v032_write(client, MT9V032_HORIZONTAL_BLANKING, hblank);

-- 
Regards,

Laurent Pinchart

