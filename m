Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:34050 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750903AbZCLILZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2009 04:11:25 -0400
Date: Thu, 12 Mar 2009 09:11:26 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/4] soc-camera: add board hook to specify the buswidth
 for camera sensors
In-Reply-To: <1236765976-20581-2-git-send-email-s.hauer@pengutronix.de>
Message-ID: <Pine.LNX.4.64.0903120856210.4896@axis700.grange>
References: <1236765976-20581-1-git-send-email-s.hauer@pengutronix.de>
 <1236765976-20581-2-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 11 Mar 2009, Sascha Hauer wrote:

> Camera sensors have a native bus width say support, but on some
> boards not all sensor data lines are connected to the image
> interface and thus support a different bus width than the sensors
> native one. Some boards even have a bus driver which dynamically
> switches between different bus widths with a GPIO.
> 
> This patch adds a hook which board code can use to support different
> bus widths.
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---
>  include/media/soc_camera.h |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
> index 7440d92..d68959c 100644
> --- a/include/media/soc_camera.h
> +++ b/include/media/soc_camera.h
> @@ -100,6 +100,12 @@ struct soc_camera_link {
>  	/* Optional callbacks to power on or off and reset the sensor */
>  	int (*power)(struct device *, int);
>  	int (*reset)(struct device *);
> +	/* some platforms may support different data widths than the sensors
> +	 * native ones due to different data line routing. Let the board code
> +	 * overwrite the width flags.
> +	 */

Please, format the comment according to CodingStyle:

	/*
	 * some
	 * comment
	 */

I know, I have some non-conforming (similar to yours) comments in 
soc-camera .c files, but this header is "clean" so far:-) Let's keep it 
that way.

> +	int (*set_bus_param)(struct device *, unsigned long flags);
> +	unsigned long (*query_bus_param)(struct device *);

Wouldn't the first parameter of type "struct soc_camera_link *" make more 
sense? I'll also then change .power and .reset similarly.

>  };
>  
>  static inline struct soc_camera_device *to_soc_camera_dev(struct device *dev)
> -- 
> 1.5.6.5
> 

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
