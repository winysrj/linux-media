Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:38531 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726567AbeH1KYf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Aug 2018 06:24:35 -0400
Subject: Re: [PATCH] staging: Convert to using %pOFn instead of
 device_node.name
To: Rob Herring <robh@kernel.org>, linux-kernel@vger.kernel.org
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org
References: <20180828015252.28511-1-robh@kernel.org>
 <20180828015252.28511-44-robh@kernel.org>
From: Ian Arkver <ian.arkver.dev@gmail.com>
Message-ID: <a7c26cd7-2c56-7ec3-6c90-76998fcb4998@gmail.com>
Date: Tue, 28 Aug 2018 07:34:23 +0100
MIME-Version: 1.0
In-Reply-To: <20180828015252.28511-44-robh@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 28/08/2018 02:52, Rob Herring wrote:
> In preparation to remove the node name pointer from struct device_node,
> convert printf users to use the %pOFn format specifier.
> 
> Cc: Steve Longerbeam <slongerbeam@gmail.com>
> Cc: Philipp Zabel <p.zabel@pengutronix.de>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-media@vger.kernel.org
> Cc: devel@driverdev.osuosl.org
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>   drivers/staging/media/imx/imx-media-dev.c | 11 ++++++-----
>   drivers/staging/media/imx/imx-media-of.c  |  4 ++--
>   drivers/staging/mt7621-eth/mdio.c         |  4 ++--
>   3 files changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
> index b0be80f05767..818846f8c291 100644
> --- a/drivers/staging/media/imx/imx-media-dev.c
> +++ b/drivers/staging/media/imx/imx-media-dev.c
> @@ -89,8 +89,8 @@ int imx_media_add_async_subdev(struct imx_media_dev *imxmd,
>   
>   	/* return -EEXIST if this asd already added */
>   	if (find_async_subdev(imxmd, fwnode, devname)) {
> -		dev_dbg(imxmd->md.dev, "%s: already added %s\n",
> -			__func__, np ? np->name : devname);
> +		dev_dbg(imxmd->md.dev, "%s: already added %pOFn\n",
> +			__func__, np ? np : devname);

This won't work for the np==NULL case I think since devname is just a 
string.

Regards,
Ian
>   		ret = -EEXIST;
>   		goto out;
>   	}
> @@ -105,19 +105,20 @@ int imx_media_add_async_subdev(struct imx_media_dev *imxmd,
>   	if (fwnode) {
>   		asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
>   		asd->match.fwnode = fwnode;
> +		dev_dbg(imxmd->md.dev, "%s: added %pOFn, match type FWNODE\n",
> +			__func__, np);
>   	} else {
>   		asd->match_type = V4L2_ASYNC_MATCH_DEVNAME;
>   		asd->match.device_name = devname;
>   		imxasd->pdev = pdev;
> +		dev_dbg(imxmd->md.dev, "%s: added %s, match type DEVNAME\n",
> +			__func__, devname);
>   	}
>   
>   	list_add_tail(&imxasd->list, &imxmd->asd_list);
>   
>   	imxmd->subdev_notifier.num_subdevs++;
>   
> -	dev_dbg(imxmd->md.dev, "%s: added %s, match type %s\n",
> -		__func__, np ? np->name : devname, np ? "FWNODE" : "DEVNAME");
> -
>   out:
>   	mutex_unlock(&imxmd->mutex);
>   	return ret;
> diff --git a/drivers/staging/media/imx/imx-media-of.c b/drivers/staging/media/imx/imx-media-of.c
> index acde372c6795..cb74df356576 100644
> --- a/drivers/staging/media/imx/imx-media-of.c
> +++ b/drivers/staging/media/imx/imx-media-of.c
> @@ -79,8 +79,8 @@ of_parse_subdev(struct imx_media_dev *imxmd, struct device_node *sd_np,
>   	int i, num_ports, ret;
>   
>   	if (!of_device_is_available(sd_np)) {
> -		dev_dbg(imxmd->md.dev, "%s: %s not enabled\n", __func__,
> -			sd_np->name);
> +		dev_dbg(imxmd->md.dev, "%pOFn: %s not enabled\n", __func__,
> +			sd_np);
>   		/* unavailable is not an error */
>   		return 0;
>   	}
> diff --git a/drivers/staging/mt7621-eth/mdio.c b/drivers/staging/mt7621-eth/mdio.c
> index 7ad0c4141205..9ffa8f771235 100644
> --- a/drivers/staging/mt7621-eth/mdio.c
> +++ b/drivers/staging/mt7621-eth/mdio.c
> @@ -70,7 +70,7 @@ int mtk_connect_phy_node(struct mtk_eth *eth, struct mtk_mac *mac,
>   	_port = of_get_property(phy_node, "reg", NULL);
>   
>   	if (!_port || (be32_to_cpu(*_port) >= 0x20)) {
> -		pr_err("%s: invalid port id\n", phy_node->name);
> +		pr_err("%pOFn: invalid port id\n", phy_node);
>   		return -EINVAL;
>   	}
>   	port = be32_to_cpu(*_port);
> @@ -249,7 +249,7 @@ int mtk_mdio_init(struct mtk_eth *eth)
>   	eth->mii_bus->priv = eth;
>   	eth->mii_bus->parent = eth->dev;
>   
> -	snprintf(eth->mii_bus->id, MII_BUS_ID_SIZE, "%s", mii_np->name);
> +	snprintf(eth->mii_bus->id, MII_BUS_ID_SIZE, "%pOFn", mii_np);
>   	err = of_mdiobus_register(eth->mii_bus, mii_np);
>   	if (err)
>   		goto err_free_bus;
> 
