Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:49042 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753987Ab0HAJdZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Aug 2010 05:33:25 -0400
Date: Sun, 1 Aug 2010 11:33:35 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Michael Grzeschik <m.grzeschik@pengutronix.de>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Robert Jarzmik <robert.jarzmik@free.fr>, p.wiesner@phytec.de
Subject: Re: [PATCH 10/20] mt9m111: rewrite make_rect for positioning in
 debug
In-Reply-To: <1280501618-23634-11-git-send-email-m.grzeschik@pengutronix.de>
Message-ID: <Pine.LNX.4.64.1008011127220.310@axis700.grange>
References: <1280501618-23634-1-git-send-email-m.grzeschik@pengutronix.de>
 <1280501618-23634-11-git-send-email-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 30 Jul 2010, Michael Grzeschik wrote:

> If DEBUG is defined it is possible to set upper left corner
> 
> Signed-off-by: Philipp Wiesner <p.wiesner@phytec.de>
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> ---
>  drivers/media/video/mt9m111.c |   31 +++++++++++++++++++++++--------
>  1 files changed, 23 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
> index e8d8e9b..db5ac32 100644
> --- a/drivers/media/video/mt9m111.c
> +++ b/drivers/media/video/mt9m111.c
> @@ -428,14 +428,7 @@ static int mt9m111_make_rect(struct i2c_client *client,
>  			     struct v4l2_rect *rect)
>  {
>  	struct mt9m111 *mt9m111 = to_mt9m111(client);
> -
> -	if (mt9m111->fmt->code == V4L2_MBUS_FMT_SBGGR8_1X8 ||
> -	    mt9m111->fmt->code == V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE) {
> -		/* Bayer format - even size lengths */
> -		rect->width	= ALIGN(rect->width, 2);
> -		rect->height	= ALIGN(rect->height, 2);
> -		/* Let the user play with the starting pixel */
> -	}
> +	enum v4l2_mbus_pixelcode code = mt9m111->fmt->code;
>  
>  	/* FIXME: the datasheet doesn't specify minimum sizes */
>  	soc_camera_limit_side(&rect->left, &rect->width,
> @@ -444,6 +437,28 @@ static int mt9m111_make_rect(struct i2c_client *client,
>  	soc_camera_limit_side(&rect->top, &rect->height,
>  		     MT9M111_MIN_DARK_ROWS, 2, MT9M111_MAX_HEIGHT);
>  
> +	switch (code) {
> +	case V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE:
> +		/* unprocessed Bayer pattern format, IFP is bypassed */
> +#ifndef DEBUG
> +		/* assure that Bayer sequence is BGGR */
> +		/* in debug mode, let user play with starting pixel */
> +		rect->left	= ALIGN(rect->left, 2);
> +		rect->top	= ALIGN(rect->top, 2) + 1;
> +#endif
> +	case V4L2_MBUS_FMT_SBGGR8_1X8:
> +		/* processed Bayer pattern format, sequence is fixed */
> +		/* assure even side lengths for both Bayer modes */
> +		rect->width	= ALIGN(rect->width, 2);
> +		rect->height	= ALIGN(rect->height, 2);
> +	default:

hm, don't think I like it. First, why do you only enable it for SBGGR10 
and not for SBGGR8? This choice has nothing to do with how many bytes per 
pixel this format has. It allows you to select the starting _pixel_, not 
byte. And I wouldn't bind this to DEBUG. Either enable or disable 
completely... If you want to disable it, you would have to check for 
regressions. I would keep it - just to make sure we don't break anything.

> +		/* needed to avoid compiler warnings */;
> +	}
> +
> +	dev_dbg(&client->dev, "%s: rect: left=%d top=%d width=%d height=%d "
> +		"mf: pixelcode=%d\n", __func__, rect->left, rect->top,
> +		rect->width, rect->height, code);
> +
>  	return mt9m111_setup_rect(client, rect);
>  }
>  
> -- 
> 1.7.1

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
