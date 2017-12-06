Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:34973 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751720AbdLFP5v (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Dec 2017 10:57:51 -0500
Received: by mail-lf0-f68.google.com with SMTP id j124so4803185lfg.2
        for <linux-media@vger.kernel.org>; Wed, 06 Dec 2017 07:57:50 -0800 (PST)
Date: Wed, 6 Dec 2017 16:57:48 +0100
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, jmondi <jacopo@jmondi.org>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [RFC 1/1] v4l: async: Use endpoint node, not device node, for
 fwnode match
Message-ID: <20171206155748.GF31989@bigcity.dyn.berto.se>
References: <20171204210302.24707-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20171204210302.24707-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CC Jacopo, Kieran

Hi Sakari,

Thanks for your patch.

On 2017-12-04 23:03:02 +0200, Sakari Ailus wrote:
> V4L2 async framework can use both device's fwnode and endpoints's fwnode
> for matching the async sub-device with the sub-device. In order to proceed
> moving towards endpoint matching assign the endpoint to the async
> sub-device.

Endpoint matching I think is the way to go forward. It will solve a set 
of problems that exists today. So I think this a good step in the right 
direction.

> 
> As most async sub-device drivers (and the related hardware) only supports
> a single endpoint, use the first endpoint found. This works for all
> current drivers --- we only ever supported a single async sub-device per
> device to begin with.

This assumption is not true, the adv748x exposes multiple subdevice from 
a single device node in DT and registers them using different endpoints.  
Now the only user of the adv748x driver I know of is the rcar-csi2 
driver which is not yet upstream so this can be consider a special case.

Unfortunately this patch do break already existing configurations 
upstream :-( For example the Koelsch board, from r8a7791-koelsch.dts:

hdmi-in {
        compatible = "hdmi-connector";
        type = "a";

        port {
                hdmi_con_in: endpoint {
                        remote-endpoint = <&adv7612_in>;
                };
        };
};

hdmi-in@4c {
        compatible = "adi,adv7612";
        reg = <0x4c>;
        interrupt-parent = <&gpio4>;
        interrupts = <2 IRQ_TYPE_LEVEL_LOW>;
        default-input = <0>;

        ports {
                #address-cells = <1>;
                #size-cells = <0>;

                port@0 {
                        reg = <0>;
                        adv7612_in: endpoint {
                                remote-endpoint = <&hdmi_con_in>;
                        };
                };

                port@2 {
                        reg = <2>;
                        adv7612_out: endpoint {
                                remote-endpoint = <&vin0ep2>;
                        };
                };
        };
};

&vin0 {
        status = "okay";
        pinctrl-0 = <&vin0_pins>;
        pinctrl-names = "default";

        port {
                #address-cells = <1>;
                #size-cells = <0>;

                vin0ep2: endpoint {
                        remote-endpoint = <&adv7612_out>;
                        bus-width = <24>;
                        hsync-active = <0>;
                        vsync-active = <0>;
                        pclk-sample = <1>;
                        data-active = <1>;
                };
        };
};

Here the adv7612 driver would register a subdevice using the endpoint 
'hdmi-in@4c/ports/port@0/endpoint' while the rcar-vin driver which uses 
the async parsing helpers would register a notifier looking for 
'hdmi-in@4c/ports/port@2/endpoint'.

Something like Kieran's '[PATCH v5] v4l2-async: Match parent devices' 
would be needed in addition to this patch. I tried Kieran's patch 
together with this and it did not solve the problem upstream. I did make 
a hack on-top of Kieran's patch to add a comparison 'sd_parent == 
asd_parent' in match_fwnode() which got rcar-gen2 working again, but I'm 
not sure if that will have other side effects.

> 
> For async devices that have no endpoints, continue to use the fwnode
> related to the device. This includes e.g. lens devices.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
> Hi Niklas,
> 
> What do you think of this one? I've tested this on N9, both sensor and
> flash devices work nicely there. No opportunistic checks for backwards
> compatibility are needed.

Over all I like it, endpoint matching I think is a good thing! If we can 
sort out the issue above I be happy to use the new async parsing helpers 
in rcar-csi2 driver.

> 
> The changes were surprisingly simple, there are only two drivers that
> weren't entirely trivial to change (this part is truly weird in exynos4-is
> and xilinx-vipp). Converting the two to use the common parsing functions
> would be quite a bit more work and would be very nice to test. The changes
> in this patch were still relatively simple.
> 
>  drivers/media/platform/am437x/am437x-vpfe.c    |  2 +-
>  drivers/media/platform/atmel/atmel-isc.c       |  2 +-
>  drivers/media/platform/atmel/atmel-isi.c       |  2 +-
>  drivers/media/platform/davinci/vpif_capture.c  |  2 +-
>  drivers/media/platform/exynos4-is/media-dev.c  | 14 ++++++++++----
>  drivers/media/platform/pxa_camera.c            |  2 +-
>  drivers/media/platform/qcom/camss-8x16/camss.c |  2 +-
>  drivers/media/platform/rcar_drif.c             |  2 +-
>  drivers/media/platform/stm32/stm32-dcmi.c      |  2 +-
>  drivers/media/platform/ti-vpe/cal.c            |  2 +-
>  drivers/media/platform/xilinx/xilinx-vipp.c    | 16 +++++++++++++---
>  drivers/media/v4l2-core/v4l2-async.c           |  8 ++++++--
>  drivers/media/v4l2-core/v4l2-fwnode.c          |  2 +-
>  13 files changed, 39 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
> index 0997c640191d..892d9e935d25 100644
> --- a/drivers/media/platform/am437x/am437x-vpfe.c
> +++ b/drivers/media/platform/am437x/am437x-vpfe.c
> @@ -2493,7 +2493,7 @@ vpfe_get_pdata(struct platform_device *pdev)
>  		if (flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH)
>  			sdinfo->vpfe_param.vdpol = 1;
>  
> -		rem = of_graph_get_remote_port_parent(endpoint);
> +		rem = of_graph_get_remote_endpoint(endpoint);
>  		if (!rem) {
>  			dev_err(&pdev->dev, "Remote device at %pOF not found\n",
>  				endpoint);
> diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
> index 13f1c1c797b0..c8bb60eeb629 100644
> --- a/drivers/media/platform/atmel/atmel-isc.c
> +++ b/drivers/media/platform/atmel/atmel-isc.c
> @@ -2044,7 +2044,7 @@ static int isc_parse_dt(struct device *dev, struct isc_device *isc)
>  		if (!epn)
>  			break;
>  
> -		rem = of_graph_get_remote_port_parent(epn);
> +		rem = of_graph_get_remote_endpoint(epn);
>  		if (!rem) {
>  			dev_notice(dev, "Remote device at %pOF not found\n",
>  				   epn);
> diff --git a/drivers/media/platform/atmel/atmel-isi.c b/drivers/media/platform/atmel/atmel-isi.c
> index e900995143a3..eafdf91a4541 100644
> --- a/drivers/media/platform/atmel/atmel-isi.c
> +++ b/drivers/media/platform/atmel/atmel-isi.c
> @@ -1119,7 +1119,7 @@ static int isi_graph_parse(struct atmel_isi *isi, struct device_node *node)
>  		if (!ep)
>  			return -EINVAL;
>  
> -		remote = of_graph_get_remote_port_parent(ep);
> +		remote = of_graph_get_remote_endpoint(ep);
>  		if (!remote) {
>  			of_node_put(ep);
>  			return -EINVAL;
> diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
> index fca4dc829f73..7c9c2b2bb710 100644
> --- a/drivers/media/platform/davinci/vpif_capture.c
> +++ b/drivers/media/platform/davinci/vpif_capture.c
> @@ -1572,7 +1572,7 @@ vpif_capture_get_pdata(struct platform_device *pdev)
>  		if (flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH)
>  			chan->vpif_if.vd_pol = 1;
>  
> -		rem = of_graph_get_remote_port_parent(endpoint);
> +		rem = of_graph_get_remote_endpoint(endpoint);
>  		if (!rem) {
>  			dev_dbg(&pdev->dev, "Remote device at %pOF not found\n",
>  				endpoint);
> diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
> index 0ef583cfc424..ab5dfe6d7ac4 100644
> --- a/drivers/media/platform/exynos4-is/media-dev.c
> +++ b/drivers/media/platform/exynos4-is/media-dev.c
> @@ -411,7 +411,7 @@ static int fimc_md_parse_port_node(struct fimc_md *fmd,
>  
>  	pd->mux_id = (endpoint.base.port - 1) & 0x1;
>  
> -	rem = of_graph_get_remote_port_parent(ep);
> +	rem = of_graph_get_remote_endpoint(ep);
>  	of_node_put(ep);
>  	if (rem == NULL) {
>  		v4l2_info(&fmd->v4l2_dev, "Remote device at %pOF not found\n",
> @@ -1363,11 +1363,17 @@ static int subdev_notifier_bound(struct v4l2_async_notifier *notifier,
>  	int i;
>  
>  	/* Find platform data for this sensor subdev */
> -	for (i = 0; i < ARRAY_SIZE(fmd->sensor); i++)
> -		if (fmd->sensor[i].asd.match.fwnode.fwnode ==
> -		    of_fwnode_handle(subdev->dev->of_node))
> +	for (i = 0; i < ARRAY_SIZE(fmd->sensor); i++) {
> +		struct fwnode_handle *fwnode =
> +			fwnode_graph_get_port_parent(
> +				of_fwnode_handle(subdev->dev->of_node));
> +
> +		if (fmd->sensor[i].asd.match.fwnode.fwnode == fwnode)
>  			si = &fmd->sensor[i];
>  
> +		fwnode_handle_put(fwnode);
> +	}
> +
>  	if (si == NULL)
>  		return -EINVAL;
>  
> diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
> index 4e0839829e6e..82aaafd113d4 100644
> --- a/drivers/media/platform/pxa_camera.c
> +++ b/drivers/media/platform/pxa_camera.c
> @@ -2334,7 +2334,7 @@ static int pxa_camera_pdata_from_dt(struct device *dev,
>  		pcdev->platform_flags |= PXA_CAMERA_PCLK_EN;
>  
>  	asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
> -	remote = of_graph_get_remote_port_parent(np);
> +	remote = of_graph_get_remote_endpoint(np);
>  	if (remote) {
>  		asd->match.fwnode.fwnode = of_fwnode_handle(remote);
>  		of_node_put(remote);
> diff --git a/drivers/media/platform/qcom/camss-8x16/camss.c b/drivers/media/platform/qcom/camss-8x16/camss.c
> index 390a42c17b66..73cac6301756 100644
> --- a/drivers/media/platform/qcom/camss-8x16/camss.c
> +++ b/drivers/media/platform/qcom/camss-8x16/camss.c
> @@ -332,7 +332,7 @@ static int camss_of_parse_ports(struct device *dev,
>  			return ret;
>  		}
>  
> -		remote = of_graph_get_remote_port_parent(node);
> +		remote = of_graph_get_remote_endpoint(node);
>  		of_node_put(node);
>  
>  		if (!remote) {
> diff --git a/drivers/media/platform/rcar_drif.c b/drivers/media/platform/rcar_drif.c
> index 63c94f4028a7..f6e0a08d72f4 100644
> --- a/drivers/media/platform/rcar_drif.c
> +++ b/drivers/media/platform/rcar_drif.c
> @@ -1228,7 +1228,7 @@ static int rcar_drif_parse_subdevs(struct rcar_drif_sdr *sdr)
>  		return 0;
>  
>  	notifier->subdevs[notifier->num_subdevs] = &sdr->ep.asd;
> -	fwnode = fwnode_graph_get_remote_port_parent(ep);
> +	fwnode = fwnode_graph_get_remote_endpoint(ep);
>  	if (!fwnode) {
>  		dev_warn(sdr->dev, "bad remote port parent\n");
>  		fwnode_handle_put(ep);
> diff --git a/drivers/media/platform/stm32/stm32-dcmi.c b/drivers/media/platform/stm32/stm32-dcmi.c
> index ac4c450a6c7d..18e0aa8af3b3 100644
> --- a/drivers/media/platform/stm32/stm32-dcmi.c
> +++ b/drivers/media/platform/stm32/stm32-dcmi.c
> @@ -1511,7 +1511,7 @@ static int dcmi_graph_parse(struct stm32_dcmi *dcmi, struct device_node *node)
>  		if (!ep)
>  			return -EINVAL;
>  
> -		remote = of_graph_get_remote_port_parent(ep);
> +		remote = of_graph_get_remote_endpoint(ep);
>  		if (!remote) {
>  			of_node_put(ep);
>  			return -EINVAL;
> diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
> index a1748b84deea..f4af6c5a7c6c 100644
> --- a/drivers/media/platform/ti-vpe/cal.c
> +++ b/drivers/media/platform/ti-vpe/cal.c
> @@ -1697,7 +1697,7 @@ static int of_cal_create_instance(struct cal_ctx *ctx, int inst)
>  		goto cleanup_exit;
>  	}
>  
> -	sensor_node = of_graph_get_remote_port_parent(ep_node);
> +	sensor_node = of_graph_get_remote_endpoint(ep_node);
>  	if (!sensor_node) {
>  		ctx_dbg(3, ctx, "can't get remote parent\n");
>  		goto cleanup_exit;
> diff --git a/drivers/media/platform/xilinx/xilinx-vipp.c b/drivers/media/platform/xilinx/xilinx-vipp.c
> index d881cf09876d..17d4ac0a908d 100644
> --- a/drivers/media/platform/xilinx/xilinx-vipp.c
> +++ b/drivers/media/platform/xilinx/xilinx-vipp.c
> @@ -82,6 +82,8 @@ static int xvip_graph_build_one(struct xvip_composite_device *xdev,
>  	dev_dbg(xdev->dev, "creating links for entity %s\n", local->name);
>  
>  	while (1) {
> +		struct fwnode_handle *fwnode;
> +
>  		/* Get the next endpoint and parse its link. */
>  		next = of_graph_get_next_endpoint(entity->node, ep);
>  		if (next == NULL)
> @@ -121,8 +123,11 @@ static int xvip_graph_build_one(struct xvip_composite_device *xdev,
>  			continue;
>  		}
>  
> +		fwnode = fwnode_graph_get_port_parent(link.remote_node);
> +		fwnode_handle_put(fwnode);
> +
>  		/* Skip DMA engines, they will be processed separately. */
> -		if (link.remote_node == of_fwnode_handle(xdev->dev->of_node)) {
> +		if (fwnode == of_fwnode_handle(xdev->dev->of_node)) {
>  			dev_dbg(xdev->dev, "skipping DMA port %pOF:%u\n",
>  				to_of_node(link.local_node),
>  				link.local_port);
> @@ -367,20 +372,25 @@ static int xvip_graph_parse_one(struct xvip_composite_device *xdev,
>  	dev_dbg(xdev->dev, "parsing node %pOF\n", node);
>  
>  	while (1) {
> +		struct fwnode_handle *fwnode;
> +
>  		ep = of_graph_get_next_endpoint(node, ep);
>  		if (ep == NULL)
>  			break;
>  
>  		dev_dbg(xdev->dev, "handling endpoint %pOF\n", ep);
>  
> -		remote = of_graph_get_remote_port_parent(ep);
> +		remote = of_graph_get_remote_endpoint(ep);
>  		if (remote == NULL) {
>  			ret = -EINVAL;
>  			break;
>  		}
>  
> +		fwnode = fwnode_graph_get_port_parent(of_fwnode_handle(remote));
> +		fwnode_handle_put(fwnode);
> +
>  		/* Skip entities that we have already processed. */
> -		if (remote == xdev->dev->of_node ||
> +		if (fwnode == xdev->dev->of_node ||
>  		    xvip_graph_find_entity(xdev, remote)) {
>  			of_node_put(remote);
>  			continue;
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> index e5acfab470a5..f53eff07e8b8 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -539,8 +539,12 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd)
>  	 * (struct v4l2_subdev.dev), and async sub-device does not
>  	 * exist independently of the device at any point of time.
>  	 */
> -	if (!sd->fwnode && sd->dev)
> -		sd->fwnode = dev_fwnode(sd->dev);
> +	if (!sd->fwnode && sd->dev) {
> +		sd->fwnode = fwnode_graph_get_next_endpoint(
> +			dev_fwnode(sd->dev), NULL);
> +		if (!sd->fwnode)
> +			sd->fwnode = dev_fwnode(sd->dev);
> +	}
>  
>  	mutex_lock(&list_lock);
>  
> diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
> index fb72c7ac04d4..9c17a26d544c 100644
> --- a/drivers/media/v4l2-core/v4l2-fwnode.c
> +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
> @@ -360,7 +360,7 @@ static int v4l2_async_notifier_fwnode_parse_endpoint(
>  
>  	asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
>  	asd->match.fwnode.fwnode =
> -		fwnode_graph_get_remote_port_parent(endpoint);
> +		fwnode_graph_get_remote_endpoint(endpoint);
>  	if (!asd->match.fwnode.fwnode) {
>  		dev_warn(dev, "bad remote port parent\n");
>  		ret = -EINVAL;
> -- 
> 2.11.0
> 

-- 
Regards,
Niklas Söderlund
