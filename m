Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46166 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756601AbcAIXBv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Jan 2016 18:01:51 -0500
Date: Sun, 10 Jan 2016 01:01:15 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	"Prabhakar\"" <prabhakar.csengg@gmail.com>,
	Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 6/8] [media] tvp7002: Check v4l2_of_parse_endpoint()
 return value
Message-ID: <20160109230115.GE576@valkosipuli.retiisi.org.uk>
References: <1452191248-15847-1-git-send-email-javier@osg.samsung.com>
 <1452191248-15847-7-git-send-email-javier@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1452191248-15847-7-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

On Thu, Jan 07, 2016 at 03:27:20PM -0300, Javier Martinez Canillas wrote:
> The v4l2_of_parse_endpoint() function can fail so check the return value.
> 
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> ---
> 
>  drivers/media/i2c/tvp7002.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/tvp7002.c b/drivers/media/i2c/tvp7002.c
> index 83c79fa5f61d..4aac303da5d4 100644
> --- a/drivers/media/i2c/tvp7002.c
> +++ b/drivers/media/i2c/tvp7002.c
> @@ -905,11 +905,13 @@ tvp7002_get_pdata(struct i2c_client *client)
>  	if (!endpoint)
>  		return NULL;
>  
> +	if (v4l2_of_parse_endpoint(endpoint, &bus_cfg))

pdata is uninitialised here. There are many ways to fix this but I think I'd
just assign it to NULL in variable declaration.

> +		goto done;
> +
>  	pdata = devm_kzalloc(&client->dev, sizeof(*pdata), GFP_KERNEL);
>  	if (!pdata)
>  		goto done;
>  
> -	v4l2_of_parse_endpoint(endpoint, &bus_cfg);
>  	flags = bus_cfg.bus.parallel.flags;
>  
>  	if (flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
