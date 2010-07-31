Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:44409 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751737Ab0GaUJv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Jul 2010 16:09:51 -0400
Date: Sat, 31 Jul 2010 22:09:48 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Michael Grzeschik <m.grzeschik@pengutronix.de>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Robert Jarzmik <robert.jarzmik@free.fr>, p.wiesner@phytec.de
Subject: Re: [PATCH 02/20] mt9m111: init chip after read CHIP_VERSION
In-Reply-To: <1280501618-23634-3-git-send-email-m.grzeschik@pengutronix.de>
Message-ID: <Pine.LNX.4.64.1007312157200.16769@axis700.grange>
References: <1280501618-23634-1-git-send-email-m.grzeschik@pengutronix.de>
 <1280501618-23634-3-git-send-email-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 30 Jul 2010, Michael Grzeschik wrote:

> Moved mt9m111_init after the chip version detection passage: I
> don't like the idea of writing on a device we haven't identified
> yet.

In principle it's correct, but what do you do, if a chip cannot be probed, 
before it is initialised / enabled? Actually, this shouldn't be the case, 
devices should be available for probing without any initialisation. So, we 
have to ask the original author, whether this really was necessary, 
Robert?

Thanks
Guennadi

> 
> Signed-off-by: Philipp Wiesner <p.wiesner@phytec.de>
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> ---
>  drivers/media/video/mt9m111.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
> index e934559..39dff7c 100644
> --- a/drivers/media/video/mt9m111.c
> +++ b/drivers/media/video/mt9m111.c
> @@ -969,10 +969,6 @@ static int mt9m111_video_probe(struct soc_camera_device *icd,
>  	mt9m111->swap_rgb_even_odd = 1;
>  	mt9m111->swap_rgb_red_blue = 1;
>  
> -	ret = mt9m111_init(client);
> -	if (ret)
> -		goto ei2c;
> -
>  	data = reg_read(CHIP_VERSION);
>  
>  	switch (data) {
> @@ -994,6 +990,8 @@ static int mt9m111_video_probe(struct soc_camera_device *icd,
>  		goto ei2c;
>  	}
>  
> +	ret = mt9m111_init(client);
> +
>  ei2c:
>  	return ret;
>  }
> -- 
> 1.7.1
> 
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
