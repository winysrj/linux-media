Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:53647 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750905Ab0HATia (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Aug 2010 15:38:30 -0400
Date: Sun, 1 Aug 2010 21:38:25 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Michael Grzeschik <m.grzeschik@pengutronix.de>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Robert Jarzmik <robert.jarzmik@free.fr>, p.wiesner@phytec.de
Subject: Re: [PATCH 12/20] mt9m111: s_crop add calculation of output size
In-Reply-To: <1280501618-23634-13-git-send-email-m.grzeschik@pengutronix.de>
Message-ID: <Pine.LNX.4.64.1008012132290.2643@axis700.grange>
References: <1280501618-23634-1-git-send-email-m.grzeschik@pengutronix.de>
 <1280501618-23634-13-git-send-email-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 30 Jul 2010, Michael Grzeschik wrote:

> Signed-off-by: Philipp Wiesner <p.wiesner@phytec.de>
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> ---
>  drivers/media/video/mt9m111.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
> index cc0f996..2758a97 100644
> --- a/drivers/media/video/mt9m111.c
> +++ b/drivers/media/video/mt9m111.c
> @@ -472,11 +472,19 @@ static int mt9m111_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
>  	struct mt9m111 *mt9m111 = to_mt9m111(client);
>  	struct mt9m111_format format;
>  	struct v4l2_mbus_framefmt *mf = &format.mf;
> +	s32 rectwidth	= mt9m111->format.rect.width;
> +	s32 rectheight	= mt9m111->format.rect.height;
> +	u32 pixwidth	= mt9m111->format.mf.width;
> +	u32 pixheight	= mt9m111->format.mf.height;
>  	int ret;
>  
>  	format.rect	= a->c;
>  	format.mf	= mt9m111->format.mf;
>  
> +	/* calculate output size, maintain current scaling factors */
> +	format.mf.width = pixwidth / rectwidth * format.mf.width;
> +	format.mf.height = pixheight / rectheight * format.mf.height;

Again - don't understand:

	u32 pixwidth    = mt9m111->format.mf.width;
	format.mf       = mt9m111->format.mf;
	format.mf.width = pixwidth / rectwidth * format.mf.width;

this means

	format.mf.width = mt9m111->format.mf.width / rectwidth * mt9m111->format.mf.width;

which makes no sense to me. Can you explain?

> +
>  	dev_dbg(&client->dev, "%s: rect: left=%d top=%d width=%d height=%d\n",
>  		__func__, a->c.left, a->c.top, a->c.width, a->c.height);
>  	dev_dbg(&client->dev, "%s: mf: width=%d height=%d pixelcode=%d "
> -- 
> 1.7.1

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
