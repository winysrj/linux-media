Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:41671 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752391Ab0GaUZu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Jul 2010 16:25:50 -0400
Date: Sat, 31 Jul 2010 22:25:47 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Michael Grzeschik <m.grzeschik@pengutronix.de>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Robert Jarzmik <robert.jarzmik@free.fr>, p.wiesner@phytec.de
Subject: Re: [PATCH 05/20] mt9m111: added default row/col/width/height values
In-Reply-To: <1280501618-23634-6-git-send-email-m.grzeschik@pengutronix.de>
Message-ID: <Pine.LNX.4.64.1007312221540.16769@axis700.grange>
References: <1280501618-23634-1-git-send-email-m.grzeschik@pengutronix.de>
 <1280501618-23634-6-git-send-email-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 30 Jul 2010, Michael Grzeschik wrote:

> Signed-off-by: Philipp Wiesner <p.wiesner@phytec.de>
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> ---
>  drivers/media/video/mt9m111.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
> index aeb2241..5f0c55e 100644
> --- a/drivers/media/video/mt9m111.c
> +++ b/drivers/media/video/mt9m111.c
> @@ -133,6 +133,10 @@
>  #define MT9M111_MIN_DARK_COLS	24
>  #define MT9M111_MAX_HEIGHT	1024
>  #define MT9M111_MAX_WIDTH	1280
> +#define MT9M111_DEF_DARK_ROWS	12
> +#define MT9M111_DEF_DARK_COLS	30
> +#define MT9M111_DEF_HEIGHT	1024
> +#define MT9M111_DEF_WIDTH	1280

Don't think this split makes sense. Please, call them "DEFAUL": "DEF" is 
too ambiguous, and unite with patch 08/20. In general, you're exaggerating 
splitting og patches. Many of them make little sense with this kind of a 
split and have to be merged.

>  
>  /* MT9M111 has only one fixed colorspace per pixelcode */
>  struct mt9m111_datafmt {
> -- 
> 1.7.1

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
