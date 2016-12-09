Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52102 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932247AbcLIKVK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Dec 2016 05:21:10 -0500
Date: Fri, 9 Dec 2016 12:20:35 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Kevin Hilman <khilman@baylibre.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, Sekhar Nori <nsekhar@ti.com>,
        Axel Haslam <ahaslam@baylibre.com>,
        Bartosz =?utf-8?Q?Go=C5=82aszewski?= <bgolaszewski@baylibre.com>,
        Alexandre Bailon <abailon@baylibre.com>,
        David Lechner <david@lechnology.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v6 2/5] [media] davinci: vpif_capture: remove hard-coded
 I2C adapter id
Message-ID: <20161209102035.GM16630@valkosipuli.retiisi.org.uk>
References: <20161207183025.20684-1-khilman@baylibre.com>
 <20161207183025.20684-3-khilman@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161207183025.20684-3-khilman@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kevin,

On Wed, Dec 07, 2016 at 10:30:22AM -0800, Kevin Hilman wrote:
> Remove hard-coded I2C adapter in favor of getting the
> ID from platform_data.
> 
> Signed-off-by: Kevin Hilman <khilman@baylibre.com>
> ---
>  drivers/media/platform/davinci/vpif_capture.c | 5 ++++-
>  include/media/davinci/vpif_types.h            | 1 +
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
> index 20c4344ed118..c24049acd40a 100644
> --- a/drivers/media/platform/davinci/vpif_capture.c
> +++ b/drivers/media/platform/davinci/vpif_capture.c
> @@ -1486,7 +1486,10 @@ static __init int vpif_probe(struct platform_device *pdev)
>  	}
>  
>  	if (!vpif_obj.config->asd_sizes) {
> -		i2c_adap = i2c_get_adapter(1);
> +		int i2c_id = vpif_obj.config->i2c_adapter_id;

Is there a particular reason to use a temporary variable just once? I'd use
the i2c_adapter_field directly instead. Up to you.

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

> +
> +		i2c_adap = i2c_get_adapter(i2c_id);
> +		WARN_ON(!i2c_adap);
>  		for (i = 0; i < subdev_count; i++) {
>  			subdevdata = &vpif_obj.config->subdev_info[i];
>  			vpif_obj.sd[i] =
> diff --git a/include/media/davinci/vpif_types.h b/include/media/davinci/vpif_types.h
> index 3cb1704a0650..4282a7db99d4 100644
> --- a/include/media/davinci/vpif_types.h
> +++ b/include/media/davinci/vpif_types.h
> @@ -82,6 +82,7 @@ struct vpif_capture_config {
>  	struct vpif_capture_chan_config chan_config[VPIF_CAPTURE_MAX_CHANNELS];
>  	struct vpif_subdev_info *subdev_info;
>  	int subdev_count;
> +	int i2c_adapter_id;
>  	const char *card_name;
>  	struct v4l2_async_subdev **asd;	/* Flat array, arranged in groups */
>  	int *asd_sizes;		/* 0-terminated array of asd group sizes */

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
