Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:56845 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932618AbaGWSAk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jul 2014 14:00:40 -0400
Date: Wed, 23 Jul 2014 20:00:35 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Ben Dooks <ben.dooks@codethink.co.uk>
cc: linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
	magnus.damm@opensource.se, horms@verge.net.au,
	linux-kernel@lists.codethink.co.uk
Subject: Re: [PATCH 4/6] [V3] soc_camera: add support for dt binding soc_camera
 drivers
In-Reply-To: <1404599185-12353-5-git-send-email-ben.dooks@codethink.co.uk>
Message-ID: <Pine.LNX.4.64.1407230816240.30243@axis700.grange>
References: <1404599185-12353-1-git-send-email-ben.dooks@codethink.co.uk>
 <1404599185-12353-5-git-send-email-ben.dooks@codethink.co.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ben,

Thanks for a patch update. According to my calculations, this is a v5, not 
a v3. And please follow the subject line convention like

[PATCH V5 4/6] subject text follows

and use the same version in all patches of a series - this simplifies 
their handling. You can use something like

--subject-prefix="PATCH V6"

for your git format-patch to automate this.

On Sat, 5 Jul 2014, Ben Dooks wrote:

> Add initial support for OF based soc-camera devices that may be used
> by any of the soc-camera drivers. The driver itself will need converting
> to use OF.
> 
> These changes allow the soc-camera driver to do the connecting of any
> async capable v4l2 device to the soc-camera driver. This has currently
> been tested on the Renesas Lager board.
> 
> It currently only supports one input device per driver as this seems
> to be the standard connection for these devices.
> 
> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
> ---
> 
> Fixes since v1:
> 	- Fix i2c mclk name compatible with other drivers
> 	- Ensure of_node is put after use
> Fixes since v2:
> 	- Updated freeing of dyn-pdev as requested
> 	- Coding style fixes
> 	- Allocate initial resources in one go
> ---
>  drivers/media/platform/soc_camera/soc_camera.c | 123 ++++++++++++++++++++++++-
>  1 file changed, 122 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
> index 7fec8cd..e25fc8e 100644
> --- a/drivers/media/platform/soc_camera/soc_camera.c
> +++ b/drivers/media/platform/soc_camera/soc_camera.c
> @@ -36,6 +36,7 @@
>  #include <media/v4l2-common.h>
>  #include <media/v4l2-ioctl.h>
>  #include <media/v4l2-dev.h>
> +#include <media/v4l2-of.h>
>  #include <media/videobuf-core.h>
>  #include <media/videobuf2-core.h>
>  
> @@ -1581,6 +1582,124 @@ static void scan_async_host(struct soc_camera_host *ici)
>  #define scan_async_host(ici)		do {} while (0)
>  #endif
>  
> +#ifdef CONFIG_OF
> +
> +struct soc_of_info {
> +	struct soc_camera_async_subdev	sasd;
> +	struct v4l2_async_subdev	*subdevs[2];
> +};

Yes, this is a right direction, however, why do you use an array of 2 
subdev pointers? You only seem to be using one of them?

> +
> +static int soc_of_bind(struct soc_camera_host *ici,
> +		       struct device_node *ep,
> +		       struct device_node *remote)
> +{
> +	struct soc_camera_device *icd;
> +	struct soc_camera_desc sdesc = {.host_desc.bus_id = ici->nr,};
> +	struct soc_camera_async_client *sasc;
> +	struct soc_of_info *info;
> +	struct i2c_client *client;
> +	char clk_name[V4L2_SUBDEV_NAME_SIZE];
> +	int ret;
> +
> +	/* allocate a new subdev and add match info to it */
> +	info = devm_kzalloc(ici->v4l2_dev.dev, sizeof(struct soc_of_info),
> +			    GFP_KERNEL);
> +	if (!info)
> +		return -ENOMEM;
> +
> +	info->sasd.asd.match.of.node = remote;
> +	info->sasd.asd.match_type = V4L2_ASYNC_MATCH_OF;
> +	info->subdevs[0] = &info->sasd.asd;
> +
> +	/* Or shall this be managed by the soc-camera device? */
> +	sasc = devm_kzalloc(ici->v4l2_dev.dev, sizeof(*sasc), GFP_KERNEL);

Why not also add struct soc_camera_async_client to struct soc_of_info?

Thanks
Guennadi

> +	if (!sasc)
> +		return -ENOMEM;
> +
> +	/* HACK: just need a != NULL */
> +	sdesc.host_desc.board_info = ERR_PTR(-ENODATA);
> +
> +	ret = soc_camera_dyn_pdev(&sdesc, sasc);
> +	if (ret < 0)
> +		goto eallocpdev;
> +
> +	sasc->sensor = &info->sasd.asd;
> +
> +	icd = soc_camera_add_pdev(sasc);
> +	if (!icd) {
> +		ret = -ENOMEM;
> +		goto eaddpdev;
> +	}
> +
> +	sasc->notifier.subdevs = info->subdevs;
> +	sasc->notifier.num_subdevs = 1;
> +	sasc->notifier.bound = soc_camera_async_bound;
> +	sasc->notifier.unbind = soc_camera_async_unbind;
> +	sasc->notifier.complete = soc_camera_async_complete;
> +
> +	icd->sasc = sasc;
> +	icd->parent = ici->v4l2_dev.dev;
> +
> +	client = of_find_i2c_device_by_node(remote);
> +
> +	if (client)
> +		snprintf(clk_name, sizeof(clk_name), "%d-%04x",
> +			 client->adapter->nr, client->addr);
> +	else
> +		snprintf(clk_name, sizeof(clk_name), "of-%s",
> +			 of_node_full_name(remote));
> +
> +	icd->clk = v4l2_clk_register(&soc_camera_clk_ops, clk_name, "mclk", icd);
> +	if (IS_ERR(icd->clk)) {
> +		ret = PTR_ERR(icd->clk);
> +		goto eclkreg;
> +	}
> +
> +	ret = v4l2_async_notifier_register(&ici->v4l2_dev, &sasc->notifier);
> +	if (!ret)
> +		return 0;
> +eclkreg:
> +	icd->clk = NULL;
> +	platform_device_del(sasc->pdev);
> +eaddpdev:
> +	platform_device_put(sasc->pdev);
> +eallocpdev:
> +	devm_kfree(ici->v4l2_dev.dev, sasc);
> +	dev_err(ici->v4l2_dev.dev, "group probe failed: %d\n", ret);
> +
> +	return ret;
> +}
> +
> +static void scan_of_host(struct soc_camera_host *ici)
> +{
> +	struct device_node *np = ici->v4l2_dev.dev->of_node;
> +	struct device_node *epn = NULL;
> +	struct device_node *ren;
> +
> +	while (true) {
> +		epn = of_graph_get_next_endpoint(np, epn);
> +		if (!epn)
> +			break;
> +
> +		ren = of_graph_get_remote_port(epn);
> +		if (!ren) {
> +			pr_info("%s: no remote for %s\n",
> +				__func__,  of_node_full_name(epn));
> +			continue;
> +		}
> +
> +		/* so we now have a remote node to connect */
> +		soc_of_bind(ici, epn, ren->parent);
> +
> +		of_node_put(epn);
> +		of_node_put(ren);
> +	}
> +}
> +
> +#else
> +static inline void scan_of_host(struct soc_camera_host *ici) { }
> +#endif
> +
>  /* Called during host-driver probe */
>  static int soc_camera_probe(struct soc_camera_host *ici,
>  			    struct soc_camera_device *icd)
> @@ -1832,7 +1951,9 @@ int soc_camera_host_register(struct soc_camera_host *ici)
>  	mutex_init(&ici->host_lock);
>  	mutex_init(&ici->clk_lock);
>  
> -	if (ici->asd_sizes)
> +	if (ici->v4l2_dev.dev->of_node)
> +		scan_of_host(ici);
> +	else if (ici->asd_sizes)
>  		/*
>  		 * No OF, host with a list of subdevices. Don't try to mix
>  		 * modes by initialising some groups statically and some
> -- 
> 2.0.0
> 
