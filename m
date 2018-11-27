Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:49193 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728985AbeK0TgK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Nov 2018 14:36:10 -0500
Date: Tue, 27 Nov 2018 10:38:59 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Luca Ceresoli <luca@lucaceresoli.net>
Cc: linux-media@vger.kernel.org, Leon Luo <leonl@leopardimaging.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] media: imx274: don't declare events, they are not
 implemented
Message-ID: <20181127083859.zljff4wk4hikel56@paasikivi.fi.intel.com>
References: <20181127083445.27737-1-luca@lucaceresoli.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181127083445.27737-1-luca@lucaceresoli.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Luca,

On Tue, Nov 27, 2018 at 09:34:43AM +0100, Luca Ceresoli wrote:
> The V4L2_SUBDEV_FL_HAS_EVENTS flag should not be set, event are just
> not implemented.
> 
> Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>

The driver supports controls, and so control events can be subscribed and
received by the user. Therefore I don't see a reason to remove the flag.

> ---
>  drivers/media/i2c/imx274.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/imx274.c b/drivers/media/i2c/imx274.c
> index 95a0e7d9851a..78746c51071d 100644
> --- a/drivers/media/i2c/imx274.c
> +++ b/drivers/media/i2c/imx274.c
> @@ -1878,7 +1878,7 @@ static int imx274_probe(struct i2c_client *client,
>  	imx274->client = client;
>  	sd = &imx274->sd;
>  	v4l2_i2c_subdev_init(sd, client, &imx274_subdev_ops);
> -	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;
> +	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
>  
>  	/* initialize subdev media pad */
>  	imx274->pad.flags = MEDIA_PAD_FL_SOURCE;

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
