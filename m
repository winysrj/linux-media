Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:33108 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751685AbdDLAvE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Apr 2017 20:51:04 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
Subject: Re: [PATCH v6 17/39] platform: add video-multiplexer subdevice driver
To: Sakari Ailus <sakari.ailus@iki.fi>
References: <1490661656-10318-1-git-send-email-steve_longerbeam@mentor.com>
 <1490661656-10318-18-git-send-email-steve_longerbeam@mentor.com>
 <20170404124732.GD3288@valkosipuli.retiisi.org.uk>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mchehab@kernel.org, hverkuil@xs4all.nl,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        shuah@kernel.org, sakari.ailus@linux.intel.com, pavel@ucw.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Message-ID: <e7368555-1644-4e8f-f355-6b07dc020f90@gmail.com>
Date: Tue, 11 Apr 2017 17:50:58 -0700
MIME-Version: 1.0
In-Reply-To: <20170404124732.GD3288@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 04/04/2017 05:47 AM, Sakari Ailus wrote:
> Hi Steve, Philipp and Pavel,
>
> On Mon, Mar 27, 2017 at 05:40:34PM -0700, Steve Longerbeam wrote:
>> From: Philipp Zabel <p.zabel@pengutronix.de>
>>
>> This driver can handle SoC internal and external video bus multiplexers,
>> controlled either by register bit fields or by a GPIO. The subdevice
>> passes through frame interval and mbus configuration of the active input
>> to the output side.
>
> The MUX framework is already in linux-next. Could you use that instead of
> adding new driver + bindings that are not compliant with the MUX framework?
> I don't think it'd be much of a change in terms of code, using the MUX
> framework appears quite simple.

I would prefer to wait on this, and get what we have merged now so I can
unload all these patches first.

Also this is Philipp's driver, so again I would prefer to get this
merged as-is and then Philipp can address these issues in a future
patch. But I will add my comments below...


>
> In general the driver looks pretty good, especially regarding the user space
> API implementation which is important for use with other drivers.
>
> I have some more detailed comments below.
>

<snip>

>> +
>> +struct vidsw {
>> +	struct v4l2_subdev subdev;
>> +	unsigned int num_pads;
>
> You could use subdev.entity.num_pads instead of caching the value locally.

Agreed.

>
>> +	struct media_pad *pads;
>> +	struct v4l2_mbus_framefmt *format_mbus;
>> +	struct v4l2_of_endpoint *endpoint;
>> +	struct regmap_field *field;
>> +	struct gpio_desc *gpio;
>> +	int active;
>> +};
>> +
>> +static inline struct vidsw *v4l2_subdev_to_vidsw(struct v4l2_subdev *sd)
>> +{
>> +	return container_of(sd, struct vidsw, subdev);
>> +}
>> +
>> +static void vidsw_set_active(struct vidsw *vidsw, int active)
>> +{
>> +	vidsw->active = active;
>> +	if (active < 0)
>> +		return;
>> +
>> +	dev_dbg(vidsw->subdev.dev, "setting %d active\n", active);
>> +
>> +	if (vidsw->field)
>> +		regmap_field_write(vidsw->field, active);
>> +	else if (vidsw->gpio)
>> +		gpiod_set_value(vidsw->gpio, active);
>> +}
>> +
>> +static int vidsw_link_setup(struct media_entity *entity,
>> +			    const struct media_pad *local,
>> +			    const struct media_pad *remote, u32 flags)
>> +{
>> +	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
>> +	struct vidsw *vidsw = v4l2_subdev_to_vidsw(sd);
>> +
>> +	/* We have no limitations on enabling or disabling our output link */
>> +	if (local->index == vidsw->num_pads - 1)
>> +		return 0;
>> +
>> +	dev_dbg(sd->dev, "link setup %s -> %s", remote->entity->name,
>> +		local->entity->name);
>> +
>> +	if (!(flags & MEDIA_LNK_FL_ENABLED)) {
>> +		if (local->index == vidsw->active) {
>> +			dev_dbg(sd->dev, "going inactive\n");
>> +			vidsw->active = -1;
>> +		}
>> +		return 0;
>> +	}
>> +
>> +	if (vidsw->active >= 0) {
>> +		struct media_pad *pad;
>> +
>> +		if (vidsw->active == local->index)
>> +			return 0;
>> +
>> +		pad = media_entity_remote_pad(&vidsw->pads[vidsw->active]);
>> +		if (pad) {
>> +			struct media_link *link;
>> +			int ret;
>> +
>> +			link = media_entity_find_link(pad,
>> +						&vidsw->pads[vidsw->active]);
>> +			if (link) {
>> +				ret = __media_entity_setup_link(link, 0);
>
> I wouldn't implicitly disable a link, even if only one can be active at a
> given time. No other drivers do that either.
>
> Perhaps returning an error might be a better thing to do: if you're
> reconfiguring the pipeline anyway, there are likely issues elsewhere in it.
>
> We could also change the behaviour later to allow implicit changes but we
> can't later on go the other way without breaking the user space.

I think this whole if (vidsw->active >= 0) { ... } block should be
removed. This is left-over from the first implementation that tried
to propagate link setup upstream. This is not working yet, so for now
I think this should be removed.

<snip>

>
>>
>> +
>> +static bool vidsw_endpoint_disabled(struct device_node *ep)
>> +{
>> +	struct device_node *rpp;
>> +
>> +	if (!of_device_is_available(ep))
>
> ep here is the endpoint, whereas the argument to of_device_is_available()
> should correspond to the actual device.

Agreed, I think this if statement should be removed, and...

>
>> +		return true;
>> +
>> +	rpp = of_graph_get_remote_port_parent(ep);
>> +	if (!rpp)
>> +		return true;

this if statement can also be removed, since that is
handled automatically by of_device_is_available() below.

>> +
>> +	return !of_device_is_available(rpp);
>> +}
>> +
>> +static int vidsw_async_init(struct vidsw *vidsw, struct device_node *node)
>
> I think I'd arrange this closer to probe as it's related to probe directly.
> Up to you.
>
>> +{
>> +	struct device_node *ep;
>> +	u32 portno;
>> +	int numports;
>> +	int ret;
>> +	int i;
>> +	bool active_link = false;
>> +
>> +	numports = vidsw->num_pads;
>> +
>> +	for (i = 0; i < numports - 1; i++)
>> +		vidsw->pads[i].flags = MEDIA_PAD_FL_SINK;
>> +	vidsw->pads[numports - 1].flags = MEDIA_PAD_FL_SOURCE;
>> +
>> +	vidsw->subdev.entity.function = MEDIA_ENT_F_VID_MUX;
>> +	ret = media_entity_pads_init(&vidsw->subdev.entity, numports,
>> +				     vidsw->pads);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	vidsw->subdev.entity.ops = &vidsw_ops;
>> +
>> +	for_each_endpoint_of_node(node, ep) {
>> +		struct v4l2_of_endpoint endpoint;
>> +
>> +		v4l2_of_parse_endpoint(ep, &endpoint);
>> +
>> +		portno = endpoint.base.port;
>> +		if (portno >= numports - 1)
>> +			continue;
>> +
>> +		if (vidsw_endpoint_disabled(ep)) {
>> +			dev_dbg(vidsw->subdev.dev,
>> +				"port %d disabled\n", portno);
>> +			continue;
>> +		}
>> +
>> +		vidsw->endpoint[portno] = endpoint;
>> +
>> +		if (portno == vidsw->active)
>> +			active_link = true;
>> +	}
>> +
>> +	for (portno = 0; portno < numports - 1; portno++) {
>> +		if (!vidsw->endpoint[portno].base.local_node)
>> +			continue;
>> +
>> +		/* If the active input is not connected, use another */
>> +		if (!active_link) {
>> +			vidsw_set_active(vidsw, portno);
>> +			active_link = true;
>> +		}
>> +	}
>> +
>> +	return v4l2_async_register_subdev(&vidsw->subdev);
>> +}
>> +
>> +int vidsw_g_mbus_config(struct v4l2_subdev *sd, struct v4l2_mbus_config *cfg)
>
> We should get rid of g_mbus_config() in the long run, but as we don't have
> the alternative (frame descriptors) isn't up to the job yet I guess it's ok.
> I don't think we'll have too many users for the video switch right now.
>
>> +{
>> +	struct vidsw *vidsw = v4l2_subdev_to_vidsw(sd);
>> +	struct media_pad *pad;
>> +	int ret;
>> +
>> +	if (vidsw->active == -1) {
>> +		dev_err(sd->dev, "no configuration for inactive mux\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	/*
>> +	 * Retrieve media bus configuration from the entity connected to the
>> +	 * active input
>> +	 */
>> +	pad = media_entity_remote_pad(&vidsw->pads[vidsw->active]);
>> +	if (pad) {
>> +		sd = media_entity_to_v4l2_subdev(pad->entity);
>> +		ret = v4l2_subdev_call(sd, video, g_mbus_config, cfg);
>> +		if (ret == -ENOIOCTLCMD)
>> +			pad = NULL;
>> +		else if (ret < 0) {
>> +			dev_err(sd->dev, "failed to get source configuration\n");
>> +			return ret;
>> +		}
>> +	}
>> +	if (!pad) {
>> +		/* Mirror the input side on the output side */
>> +		cfg->type = vidsw->endpoint[vidsw->active].bus_type;
>> +		if (cfg->type == V4L2_MBUS_PARALLEL ||
>> +		    cfg->type == V4L2_MBUS_BT656)
>> +			cfg->flags = vidsw->endpoint[vidsw->active].bus.parallel.flags;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int vidsw_s_stream(struct v4l2_subdev *sd, int enable)
>> +{
>> +	struct vidsw *vidsw = v4l2_subdev_to_vidsw(sd);
>> +	struct v4l2_subdev *upstream_sd;
>> +	struct media_pad *pad;
>> +
>> +	if (vidsw->active == -1) {
>> +		dev_err(sd->dev, "Can not start streaming on inactive mux\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	pad = media_entity_remote_pad(&sd->entity.pads[vidsw->active]);
>> +	if (!pad) {
>> +		dev_err(sd->dev, "Failed to find remote source pad\n");
>> +		return -ENOLINK;
>> +	}
>> +
>> +	if (!is_media_entity_v4l2_subdev(pad->entity)) {
>> +		dev_err(sd->dev, "Upstream entity is not a v4l2 subdev\n");
>> +		return -ENODEV;
>> +	}
>> +
>> +	upstream_sd = media_entity_to_v4l2_subdev(pad->entity);
>> +
>> +	return v4l2_subdev_call(upstream_sd, video, s_stream, enable);
>
> Now that we'll have more than two drivers involved in the same pipeline it
> becomes necessary to define the behaviour of s_stream() throughout the
> pipeline --- i.e. whose responsibility is it to call s_stream() on the
> sub-devices in the pipeline?

In the case of imx-media, the capture device calls set stream on the
whole pipeline in the start_streaming() callback. This subdev call is
actually a NOOP for imx-media, because the upstream entity has already
started streaming. Again I think this should be removed. It also
enforces a stream order that some MC drivers may have a problem with.

For the remaining comments I'll let Philipp respond.

Steve


>
> I can submit a patch for that. I think the way you do it here is good, as it
> enables the caller to choose the appropriate behaviour, i.e. start the local
> device before or after the upstream sub-device.
>
>> +}
>> +
>> +static const struct v4l2_subdev_video_ops vidsw_subdev_video_ops = {
>> +	.g_mbus_config = vidsw_g_mbus_config,
>> +	.s_stream = vidsw_s_stream,
>> +};
>> +
>> +static struct v4l2_mbus_framefmt *
>> +__vidsw_get_pad_format(struct v4l2_subdev *sd,
>> +		       struct v4l2_subdev_pad_config *cfg,
>> +		       unsigned int pad, u32 which)
>> +{
>> +	struct vidsw *vidsw = v4l2_subdev_to_vidsw(sd);
>> +
>> +	switch (which) {
>> +	case V4L2_SUBDEV_FORMAT_TRY:
>> +		return v4l2_subdev_get_try_format(sd, cfg, pad);
>> +	case V4L2_SUBDEV_FORMAT_ACTIVE:
>> +		return &vidsw->format_mbus[pad];
>> +	default:
>> +		return NULL;
>> +	}
>> +}
>> +
>> +static int vidsw_get_format(struct v4l2_subdev *sd,
>> +			    struct v4l2_subdev_pad_config *cfg,
>> +			    struct v4l2_subdev_format *sdformat)
>> +{
>> +	sdformat->format = *__vidsw_get_pad_format(sd, cfg, sdformat->pad,
>> +						   sdformat->which);
>> +	return 0;
>> +}
>> +
>> +static int vidsw_set_format(struct v4l2_subdev *sd,
>> +			    struct v4l2_subdev_pad_config *cfg,
>> +			    struct v4l2_subdev_format *sdformat)
>> +{
>> +	struct vidsw *vidsw = v4l2_subdev_to_vidsw(sd);
>> +	struct v4l2_mbus_framefmt *mbusformat;
>> +
>> +	if (sdformat->pad >= vidsw->num_pads)
>> +		return -EINVAL;
>
> This check is already performed in v4l2-subdev.c.
>
>> +
>> +	mbusformat = __vidsw_get_pad_format(sd, cfg, sdformat->pad,
>> +					    sdformat->which);
>> +	if (!mbusformat)
>> +		return -EINVAL;
>> +
>> +	/* Output pad mirrors active input pad, no limitations on input pads */
>
> Source and sink pads.
>
>> +	if (sdformat->pad == (vidsw->num_pads - 1) && vidsw->active >= 0)
>
> I think it'd be cleaner to test for the pad flag instead of the number. Or,
> add a macro to obtain the source pad number.
>
>> +		sdformat->format = vidsw->format_mbus[vidsw->active];
>> +
>> +	*mbusformat = sdformat->format;
>> +
>> +	return 0;
>> +}
>> +
>> +static struct v4l2_subdev_pad_ops vidsw_pad_ops = {
>> +	.get_fmt = vidsw_get_format,
>> +	.set_fmt = vidsw_set_format,
>> +};
>> +
>> +static struct v4l2_subdev_ops vidsw_subdev_ops = {
>> +	.pad = &vidsw_pad_ops,
>> +	.video = &vidsw_subdev_video_ops,
>> +};
>> +
>> +static int of_get_reg_field(struct device_node *node, struct reg_field *field)
>> +{
>> +	u32 bit_mask;
>> +	int ret;
>> +
>> +	ret = of_property_read_u32(node, "reg", &field->reg);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	ret = of_property_read_u32(node, "bit-mask", &bit_mask);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	ret = of_property_read_u32(node, "bit-shift", &field->lsb);
>> +	if (ret < 0)
>> +		return ret;
>
> I think the above would look nice in a MUX driver. :-)
>
>> +
>> +	field->msb = field->lsb + fls(bit_mask) - 1;
>> +
>> +	return 0;
>> +}
>> +
>> +static int vidsw_probe(struct platform_device *pdev)
>> +{
>> +	struct device_node *np = pdev->dev.of_node;
>> +	struct of_endpoint endpoint;
>> +	struct device_node *ep;
>> +	struct reg_field field;
>> +	struct vidsw *vidsw;
>> +	struct regmap *map;
>> +	unsigned int num_pads;
>> +	int ret;
>> +
>> +	vidsw = devm_kzalloc(&pdev->dev, sizeof(*vidsw), GFP_KERNEL);
>> +	if (!vidsw)
>> +		return -ENOMEM;
>> +
>> +	platform_set_drvdata(pdev, vidsw);
>> +
>> +	v4l2_subdev_init(&vidsw->subdev, &vidsw_subdev_ops);
>> +	snprintf(vidsw->subdev.name, sizeof(vidsw->subdev.name), "%s",
>> +			np->name);
>> +	vidsw->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
>> +	vidsw->subdev.dev = &pdev->dev;
>> +
>> +	/*
>> +	 * The largest numbered port is the output port. It determines
>> +	 * total number of pads
>> +	 */
>> +	num_pads = 0;
>
> You can initialise num_pads in variable declaration.
>
>> +	for_each_endpoint_of_node(np, ep) {
>> +		of_graph_parse_endpoint(ep, &endpoint);
>> +		num_pads = max(num_pads, endpoint.port + 1);
>
> Port numbers come directly from DT.
>
> Shouldn't num_pads be only the number of pads that have links with actual
> physical connections? I.e. if a device is disabled, it shouldn't be
> counted here.
>
>> +	}
>> +
>> +	if (num_pads < 2) {
>> +		dev_err(&pdev->dev, "Not enough ports %d\n", num_pads);
>> +		return -EINVAL;
>> +	}
>> +
>> +	ret = of_get_reg_field(np, &field);
>> +	if (ret == 0) {
>> +		map = syscon_node_to_regmap(np->parent);
>> +		if (!map) {
>> +			dev_err(&pdev->dev, "Failed to get syscon register map\n");
>> +			return PTR_ERR(map);
>> +		}
>> +
>> +		vidsw->field = devm_regmap_field_alloc(&pdev->dev, map, field);
>> +		if (IS_ERR(vidsw->field)) {
>> +			dev_err(&pdev->dev, "Failed to allocate regmap field\n");
>> +			return PTR_ERR(vidsw->field);
>> +		}
>> +
>> +		regmap_field_read(vidsw->field, &vidsw->active);
>> +	} else {
>> +		if (num_pads > 3) {
>> +			dev_err(&pdev->dev, "Too many ports %d\n", num_pads);
>> +			return -EINVAL;
>> +		}
>> +
>> +		vidsw->gpio = devm_gpiod_get(&pdev->dev, NULL, GPIOD_OUT_LOW);
>> +		if (IS_ERR(vidsw->gpio)) {
>> +			dev_warn(&pdev->dev,
>> +				 "could not request control gpio: %d\n", ret);
>> +			vidsw->gpio = NULL;
>> +		}
>> +
>> +		vidsw->active = gpiod_get_value(vidsw->gpio) ? 1 : 0;
>> +	}
>> +
>> +	vidsw->num_pads = num_pads;
>> +	vidsw->pads = devm_kzalloc(&pdev->dev, sizeof(*vidsw->pads) * num_pads,
>> +			GFP_KERNEL);
>> +	vidsw->format_mbus = devm_kzalloc(&pdev->dev,
>> +			sizeof(*vidsw->format_mbus) * num_pads, GFP_KERNEL);
>> +	vidsw->endpoint = devm_kzalloc(&pdev->dev,
>> +			sizeof(*vidsw->endpoint) * (num_pads - 1), GFP_KERNEL);
>> +
>> +	ret = vidsw_async_init(vidsw, np);
>> +	if (ret)
>> +		return ret;
>> +
>> +	return 0;
>> +}
>> +
>> +static int vidsw_remove(struct platform_device *pdev)
>> +{
>> +	struct vidsw *vidsw = platform_get_drvdata(pdev);
>> +	struct v4l2_subdev *sd = &vidsw->subdev;
>> +
>> +	v4l2_async_unregister_subdev(sd);
>> +	media_entity_cleanup(&sd->entity);
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct of_device_id vidsw_dt_ids[] = {
>> +	{ .compatible = "video-multiplexer", },
>> +	{ /* sentinel */ }
>> +};
>> +MODULE_DEVICE_TABLE(of, vidsw_dt_ids);
>> +
>> +static struct platform_driver vidsw_driver = {
>> +	.probe		= vidsw_probe,
>> +	.remove		= vidsw_remove,
>> +	.driver		= {
>> +		.of_match_table = vidsw_dt_ids,
>> +		.name = "video-multiplexer",
>> +	},
>> +};
>> +
>> +module_platform_driver(vidsw_driver);
>> +
>> +MODULE_DESCRIPTION("video stream multiplexer");
>> +MODULE_AUTHOR("Sascha Hauer, Pengutronix");
>> +MODULE_AUTHOR("Philipp Zabel, Pengutronix");
>> +MODULE_LICENSE("GPL");
>
