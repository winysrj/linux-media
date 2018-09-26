Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52308 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726978AbeIZNbd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Sep 2018 09:31:33 -0400
Date: Wed, 26 Sep 2018 10:20:00 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] media: smiapp: Remove unused loop
Message-ID: <20180926072000.a54kfocjcka6o2lu@valkosipuli.retiisi.org.uk>
References: <20180926061242.8130-1-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180926061242.8130-1-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ricardo,

On Wed, Sep 26, 2018 at 08:12:42AM +0200, Ricardo Ribalda Delgado wrote:
> The loop seemed to be made to calculate max, but max is not used in that
> function.
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

The code has been left there probably when the valid link frequency
calculation was changed.

Thanks!

> ---
>  drivers/media/i2c/smiapp/smiapp-core.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
> index 99f3b295ae3c..bccbf4c841d6 100644
> --- a/drivers/media/i2c/smiapp/smiapp-core.c
> +++ b/drivers/media/i2c/smiapp/smiapp-core.c
> @@ -624,7 +624,7 @@ static int smiapp_init_late_controls(struct smiapp_sensor *sensor)
>  {
>  	unsigned long *valid_link_freqs = &sensor->valid_link_freqs[
>  		sensor->csi_format->compressed - sensor->compressed_min_bpp];
> -	unsigned int max, i;
> +	unsigned int i;
>  
>  	for (i = 0; i < ARRAY_SIZE(sensor->test_data); i++) {
>  		int max_value = (1 << sensor->csi_format->width) - 1;
> @@ -635,8 +635,6 @@ static int smiapp_init_late_controls(struct smiapp_sensor *sensor)
>  				0, max_value, 1, max_value);
>  	}
>  
> -	for (max = 0; sensor->hwcfg->op_sys_clock[max + 1]; max++);
> -
>  	sensor->link_freq = v4l2_ctrl_new_int_menu(
>  		&sensor->src->ctrl_handler, &smiapp_ctrl_ops,
>  		V4L2_CID_LINK_FREQ, __fls(*valid_link_freqs),
> -- 
> 2.19.0
> 

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
