Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:60759 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751948Ab0GaTtR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Jul 2010 15:49:17 -0400
Date: Sat, 31 Jul 2010 21:49:12 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Michael Grzeschik <m.grzeschik@pengutronix.de>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Robert Jarzmik <robert.jarzmik@free.fr>, p.wiesner@phytec.de
Subject: Re: [PATCH 01/20] mt9m111: Added indication that MT9M131 is supported
 by this driver
In-Reply-To: <1280501618-23634-2-git-send-email-m.grzeschik@pengutronix.de>
Message-ID: <Pine.LNX.4.64.1007312136450.16769@axis700.grange>
References: <1280501618-23634-1-git-send-email-m.grzeschik@pengutronix.de>
 <1280501618-23634-2-git-send-email-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 30 Jul 2010, Michael Grzeschik wrote:

> From: Philipp Wiesner <p.wiesner@phytec.de>
> 
> Added this info to Kconfig and mt9m111.c, some comment cleanup,
> replaced 'mt9m11x'-statements by clarifications or driver name.
> Driver is fully compatible to mt9m131 which has only additional functions
> compared to mt9m111. Those aren't used anyway at the moment.
> 
> Signed-off-by: Philipp Wiesner <p.wiesner@phytec.de>
> ---
>  drivers/media/video/Kconfig   |    5 +++--
>  drivers/media/video/mt9m111.c |   37 +++++++++++++++++++++++--------------
>  2 files changed, 26 insertions(+), 16 deletions(-)
> 

[snip]

> diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
> index d35f536..e934559 100644
> --- a/drivers/media/video/mt9m111.c
> +++ b/drivers/media/video/mt9m111.c

[snip]

> @@ -970,21 +976,24 @@ static int mt9m111_video_probe(struct soc_camera_device *icd,
>  	data = reg_read(CHIP_VERSION);
>  
>  	switch (data) {
> -	case 0x143a: /* MT9M111 */
> +	case 0x143a: /* MT9M111 or MT9M131 */
>  		mt9m111->model = V4L2_IDENT_MT9M111;
> +		dev_info(&client->dev,
> +			"Detected a MT9M111/MT9M131 chip ID %x\n", data);
>  		break;
>  	case 0x148c: /* MT9M112 */
>  		mt9m111->model = V4L2_IDENT_MT9M112;
> +		dev_info(&client->dev, "Detected a MT9M112 chip ID %x\n", data);
>  		break;
>  	default:
>  		ret = -ENODEV;
>  		dev_err(&client->dev,
> -			"No MT9M11x chip detected, register read %x\n", data);
> +			"No MT9M111/MT9M112/MT9M131 chip detected, "
> +			"register read %x\n",

Please, join the strings onto one line. Don't worry about > 80 characters.

> +			data);
>  		goto ei2c;
>  	}
>  
> -	dev_info(&client->dev, "Detected a MT9M11x chip ID %x\n", data);
> -
>  ei2c:
>  	return ret;
>  }

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

