Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35912 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932907AbdCKNQo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 11 Mar 2017 08:16:44 -0500
Date: Sat, 11 Mar 2017 15:16:07 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        devicetree@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv5 07/16] atmel-isi: remove dependency of the soc-camera
 framework
Message-ID: <20170311131607.GM3220@valkosipuli.retiisi.org.uk>
References: <20170311112328.11802-1-hverkuil@xs4all.nl>
 <20170311112328.11802-8-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170311112328.11802-8-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Sat, Mar 11, 2017 at 12:23:19PM +0100, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This patch converts the atmel-isi driver from a soc-camera driver to a driver
> that is stand-alone.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/platform/soc_camera/Kconfig     |    3 +-
>  drivers/media/platform/soc_camera/atmel-isi.c | 1209 +++++++++++++++----------
>  2 files changed, 714 insertions(+), 498 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/Kconfig b/drivers/media/platform/soc_camera/Kconfig
> index 86d74788544f..a37ec91b026e 100644
> --- a/drivers/media/platform/soc_camera/Kconfig
> +++ b/drivers/media/platform/soc_camera/Kconfig
> @@ -29,9 +29,8 @@ config VIDEO_SH_MOBILE_CEU
>  
>  config VIDEO_ATMEL_ISI
>  	tristate "ATMEL Image Sensor Interface (ISI) support"
> -	depends on VIDEO_DEV && SOC_CAMERA
> +	depends on VIDEO_V4L2 && OF && HAS_DMA
>  	depends on ARCH_AT91 || COMPILE_TEST
> -	depends on HAS_DMA
>  	select VIDEOBUF2_DMA_CONTIG
>  	---help---
>  	  This module makes the ATMEL Image Sensor Interface available
> diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
> index 46de657c3e6d..a6d60c2e207d 100644
> --- a/drivers/media/platform/soc_camera/atmel-isi.c
> +++ b/drivers/media/platform/soc_camera/atmel-isi.c

...

> +static int isi_graph_init(struct atmel_isi *isi)
> +{
> +	struct v4l2_async_subdev **subdevs = NULL;
> +	int ret;
> +
> +	/* Parse the graph to extract a list of subdevice DT nodes. */
> +	ret = isi_graph_parse(isi, isi->dev->of_node);
> +	if (ret < 0) {
> +		dev_err(isi->dev, "Graph parsing failed\n");
> +		goto done;
> +	}
> +
> +	if (!ret) {
> +		dev_err(isi->dev, "No subdev found in graph\n");
> +		goto done;
> +	}
> +
> +	/* Register the subdevices notifier. */
> +	subdevs = devm_kzalloc(isi->dev, sizeof(*subdevs), GFP_KERNEL);
> +	if (subdevs == NULL) {
> +		ret = -ENOMEM;
> +		goto done;
> +	}
> +
> +	subdevs[0] = &isi->entity.asd;
> +
> +	isi->notifier.subdevs = subdevs;
> +	isi->notifier.num_subdevs = 1;
> +	isi->notifier.bound = isi_graph_notify_bound;
> +	isi->notifier.unbind = isi_graph_notify_unbind;
> +	isi->notifier.complete = isi_graph_notify_complete;
> +
> +	ret = v4l2_async_notifier_register(&isi->v4l2_dev, &isi->notifier);
> +	if (ret < 0) {
> +		dev_err(isi->dev, "Notifier registration failed\n");
> +		goto done;
> +	}
> +
> +	ret = 0;

You can replace this by

	return 0;

And remove the if () below.

> +
> +done:
> +	if (ret < 0) {
> +		v4l2_async_notifier_unregister(&isi->notifier);
> +		of_node_put(isi->entity.node);
> +	}
> +
> +	return ret;
> +}
> +

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
