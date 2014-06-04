Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56203 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbaFDOuF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Jun 2014 10:50:05 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH v2 3/5] [media] mt9v032: do not clear reserved bits in read mode register
Date: Wed, 04 Jun 2014 16:50:33 +0200
Message-ID: <2863074.Pbof0Rv7H7@avalon>
In-Reply-To: <1401788155-3690-4-git-send-email-p.zabel@pengutronix.de>
References: <1401788155-3690-1-git-send-email-p.zabel@pengutronix.de> <1401788155-3690-4-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

Thank you for the patch.

On Tuesday 03 June 2014 11:35:53 Philipp Zabel wrote:
> The read mode register bits 8 and 9 are set and marked as reserved.
> Don't clear them.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree.

> ---
> Changes since v1:
>  - Add MT9V032_READ_MODE_RESERVED #define
> ---
>  drivers/media/i2c/mt9v032.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
> index 83ae8ca6d..d969663 100644
> --- a/drivers/media/i2c/mt9v032.c
> +++ b/drivers/media/i2c/mt9v032.c
> @@ -87,6 +87,7 @@
>  #define		MT9V032_READ_MODE_COLUMN_FLIP		(1 << 5)
>  #define		MT9V032_READ_MODE_DARK_COLUMNS		(1 << 6)
>  #define		MT9V032_READ_MODE_DARK_ROWS		(1 << 7)
> +#define		MT9V032_READ_MODE_RESERVED		0x0300
>  #define MT9V032_PIXEL_OPERATION_MODE			0x0f
>  #define		MT9V034_PIXEL_OPERATION_MODE_HDR	(1 << 0)
>  #define		MT9V034_PIXEL_OPERATION_MODE_COLOR	(1 << 1)
> @@ -415,6 +416,7 @@ static int mt9v032_s_stream(struct v4l2_subdev *subdev,
> int enable) struct i2c_client *client = v4l2_get_subdevdata(subdev);
>  	struct mt9v032 *mt9v032 = to_mt9v032(subdev);
>  	struct v4l2_rect *crop = &mt9v032->crop;
> +	unsigned int read_mode;
>  	unsigned int hbin;
>  	unsigned int vbin;
>  	int ret;
> @@ -425,9 +427,13 @@ static int mt9v032_s_stream(struct v4l2_subdev *subdev,
> int enable) /* Configure the window size and row/column bin */
>  	hbin = fls(mt9v032->hratio) - 1;
>  	vbin = fls(mt9v032->vratio) - 1;
> -	ret = mt9v032_write(client, MT9V032_READ_MODE,
> -			    hbin << MT9V032_READ_MODE_COLUMN_BIN_SHIFT |
> -			    vbin << MT9V032_READ_MODE_ROW_BIN_SHIFT);
> +	read_mode = mt9v032_read(client, MT9V032_READ_MODE);
> +	if (read_mode < 0)
> +		return read_mode;
> +	read_mode &= MT9V032_READ_MODE_RESERVED;
> +	read_mode |= hbin << MT9V032_READ_MODE_COLUMN_BIN_SHIFT |
> +		     vbin << MT9V032_READ_MODE_ROW_BIN_SHIFT;
> +	ret = mt9v032_write(client, MT9V032_READ_MODE, read_mode);
>  	if (ret < 0)
>  		return ret;

-- 
Regards,

Laurent Pinchart

