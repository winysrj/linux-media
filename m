Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:17181 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbaGYDXf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Jul 2014 23:23:35 -0400
Message-ID: <53D1CDAA.4000509@atmel.com>
Date: Fri, 25 Jul 2014 11:23:22 +0800
From: Josh Wu <josh.wu@atmel.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Ben Dooks <ben.dooks@codethink.co.uk>
CC: <linux-media@vger.kernel.org>, <linux-sh@vger.kernel.org>,
	<magnus.damm@opensource.se>, <horms@verge.net.au>,
	<linux-kernel@lists.codethink.co.uk>
Subject: Re: [PATCH v6 4/6] soc_camera: add support for dt binding soc_camera
 drivers
References: <1404599185-12353-1-git-send-email-ben.dooks@codethink.co.uk> <1404599185-12353-5-git-send-email-ben.dooks@codethink.co.uk> <Pine.LNX.4.64.1407230816240.30243@axis700.grange> <Pine.LNX.4.64.1407232000410.1526@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1407232000410.1526@axis700.grange>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Guennadi

On 7/24/2014 2:01 AM, Guennadi Liakhovetski wrote:
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
> [g.liakhovetski@gmx.de add check for multiple subdevices]
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
I tested in sama5d3xek board with Atmel-isi dt and ov2640 dt. It works fine.
Tested-by: Josh Wu <josh.wu@atmel.com>

Best Regards,
Josh Wu
> ---
>
> Hi Ben,
>
> How about this version? Could you review and test?
>
> Thanks
> Guennadi
>
>   drivers/media/platform/soc_camera/soc_camera.c | 129 ++++++++++++++++++++++++-
>   1 file changed, 128 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
> index dc626b9..f4308fe 100644
> --- a/drivers/media/platform/soc_camera/soc_camera.c
> +++ b/drivers/media/platform/soc_camera/soc_camera.c
> @@ -36,6 +36,7 @@
>   #include <media/v4l2-common.h>
>   #include <media/v4l2-ioctl.h>
>   #include <media/v4l2-dev.h>
> +#include <media/v4l2-of.h>
>   #include <media/videobuf-core.h>
>   #include <media/videobuf2-core.h>
>   
> @@ -1585,6 +1586,130 @@ static void scan_async_host(struct soc_camera_host *ici)
>   #define scan_async_host(ici)		do {} while (0)
>   #endif
>   
> +#ifdef CONFIG_OF
> +
> +struct soc_of_info {
> +	struct soc_camera_async_subdev	sasd;
> +	struct soc_camera_async_client	sasc;
> +	struct v4l2_async_subdev	*subdev;
> +};
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
> +	info->subdev = &info->sasd.asd;
> +
> +	/* Or shall this be managed by the soc-camera device? */
> +	sasc = &info->sasc;
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
> +	sasc->notifier.subdevs = &info->subdev;
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
> +	struct device *dev = ici->v4l2_dev.dev;
> +	struct device_node *np = dev->of_node;
> +	struct device_node *epn = NULL, *ren;
> +	unsigned int i;
> +
> +	for (i = 0; ; i++) {
> +		epn = of_graph_get_next_endpoint(np, epn);
> +		if (!epn)
> +			break;
> +
> +		ren = of_graph_get_remote_port(epn);
> +		if (!ren) {
> +			dev_notice(dev, "no remote for %s\n",
> +				   of_node_full_name(epn));
> +			continue;
> +		}
> +
> +		/* so we now have a remote node to connect */
> +		if (!i)
> +			soc_of_bind(ici, epn, ren->parent);
> +
> +		of_node_put(epn);
> +		of_node_put(ren);
> +
> +		if (i) {
> +			dev_err(dev, "multiple subdevices aren't supported yet!\n");
> +			break;
> +		}
> +	}
> +}
> +
> +#else
> +static inline void scan_of_host(struct soc_camera_host *ici) { }
> +#endif
> +
>   /* Called during host-driver probe */
>   static int soc_camera_probe(struct soc_camera_host *ici,
>   			    struct soc_camera_device *icd)
> @@ -1836,7 +1961,9 @@ int soc_camera_host_register(struct soc_camera_host *ici)
>   	mutex_init(&ici->host_lock);
>   	mutex_init(&ici->clk_lock);
>   
> -	if (ici->asd_sizes)
> +	if (ici->v4l2_dev.dev->of_node)
> +		scan_of_host(ici);
> +	else if (ici->asd_sizes)
>   		/*
>   		 * No OF, host with a list of subdevices. Don't try to mix
>   		 * modes by initialising some groups statically and some

