Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49082 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726672AbeHYS2a (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 25 Aug 2018 14:28:30 -0400
Date: Sat, 25 Aug 2018 17:49:15 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Luca Ceresoli <luca@lucaceresoli.net>
Cc: linux-media@vger.kernel.org, Leon Luo <leonl@leopardimaging.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-kernel@vger.kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH 3/7] media: imx274: don't hard-code the subdev name to
 DRIVER_NAME
Message-ID: <20180825144915.tq7m5jlikwndndzq@valkosipuli.retiisi.org.uk>
References: <20180824163525.12694-1-luca@lucaceresoli.net>
 <20180824163525.12694-4-luca@lucaceresoli.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180824163525.12694-4-luca@lucaceresoli.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Luca,

On Fri, Aug 24, 2018 at 06:35:21PM +0200, Luca Ceresoli wrote:
> Forcibly setting the subdev name to DRIVER_NAME (i.e. "IMX274") makes
> it non-unique and less informative.
> 
> Let the driver use the default name from i2c, e.g. "IMX274 2-001a".
> 
> Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
> ---
>  drivers/media/i2c/imx274.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/imx274.c b/drivers/media/i2c/imx274.c
> index 9b524de08470..570706695ca7 100644
> --- a/drivers/media/i2c/imx274.c
> +++ b/drivers/media/i2c/imx274.c
> @@ -1885,7 +1885,6 @@ static int imx274_probe(struct i2c_client *client,
>  	imx274->client = client;
>  	sd = &imx274->sd;
>  	v4l2_i2c_subdev_init(sd, client, &imx274_subdev_ops);
> -	strlcpy(sd->name, DRIVER_NAME, sizeof(sd->name));
>  	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;
>  
>  	/* initialize subdev media pad */

This ends up changing the entity as well as the sub-device name which may
well break applications. On the other hand, you currently can't have more
than one of these devices on a media device complex due to the name being
specific to a driver, not the device.

An option avoiding that would be to let the user choose by e.g. through a
Kconfig option would avoid having to address that, but I really hate adding
such options.

I wonder what others think. If anyone ever needs to add another on a board
so that it ends up being the part of the same media device complex
(likely), then changing the name now rather than later would be the least
pain. In this case I'd be leaning (slightly) towards accepting the patch
and hoping there wouldn't be any fallout... I don't see any board (DT)
containing imx274, at least not in the upstream kernel.

Cc Hans and Laurent.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
