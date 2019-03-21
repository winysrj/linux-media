Return-Path: <SRS0=WMbR=RY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE966C43381
	for <linux-media@archiver.kernel.org>; Thu, 21 Mar 2019 13:02:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 960FC218E2
	for <linux-media@archiver.kernel.org>; Thu, 21 Mar 2019 13:02:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728208AbfCUNCq (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 21 Mar 2019 09:02:46 -0400
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:46171 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727870AbfCUNCq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Mar 2019 09:02:46 -0400
X-Originating-IP: 2.224.242.101
Received: from uno.localdomain (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 237864000F;
        Thu, 21 Mar 2019 13:02:39 +0000 (UTC)
Date:   Thu, 21 Mar 2019 14:03:19 +0100
From:   Jacopo Mondi <jacopo@jmondi.org>
To:     Marco Felsch <m.felsch@pengutronix.de>
Cc:     mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        sakari.ailus@linux.intel.com, devicetree@vger.kernel.org,
        p.zabel@pengutronix.de, javierm@redhat.com,
        afshin.nasser@gmail.com, laurent.pinchart@ideasonboard.com,
        linux-media@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH v4 2/7] media: tvp5150: add input source selection
 of_graph support
Message-ID: <20190321130319.ep6aespo65qvvwxz@uno.localdomain>
References: <20190129160757.2314-1-m.felsch@pengutronix.de>
 <20190129160757.2314-3-m.felsch@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5cvtt2x3uvtmexo3"
Content-Disposition: inline
In-Reply-To: <20190129160757.2314-3-m.felsch@pengutronix.de>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--5cvtt2x3uvtmexo3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Tue, Jan 29, 2019 at 05:07:52PM +0100, Marco Felsch wrote:
> This patch adds the of_graph support to describe the tvp connections.
> Physical the TVP5150 has three ports: AIP1A, AIP1B and YOUT. As result
> of discussion [1],[2] the device-tree maps these ports 1:1. The svideo
> connector must be conneted to port@0/endpoint@1, look at the Documentation
> for more information. Since the TVP5150 is a converter the device-tree
> must contain at least 1-input and 1-output port. The mc-connectors and
> mc-links are only created if the device-tree contains the corresponding
> connector nodes. If more than one connector is available the
> media_entity_operations.link_setup() callback ensures that only one
> connector is active.
>
> [1] https://www.spinics.net/lists/linux-media/msg138545.html
> [2] https://www.spinics.net/lists/linux-media/msg138546.html
>
> Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> ---
> Changelog:
>
> v4:
> - rebase on top of media_tree/master, fix merge conflict due to commit
>   60359a28d592 ("media: v4l: fwnode: Initialise the V4L2 fwnode endpoints
>   to zero")
>
> v3:
> - probe(): s/err/err_free_v4l2_ctrls
> - drop MC dependency for tvp5150_pads
>
> v2:
> - adapt commit message
> - unify ifdef switches
> - rename tvp5150_valid_input -> tvp5150_of_valid_input, to be more precise
> - mc: use 2-input and 1-output pad
> - mc: link svideo connector to both input pads
> - mc: enable/disable svideo links in one go
> - mc: change link_setup() behaviour, switch the input src don't require a
>       explicite disable before.
> - mc: rename 'local' media_pad param to tvp5150_pad to avoid confusion
> - mc: enable link to the first available connector and set the
>       corresponding tvp5150 input src per default during registered()
> - mc/of: factor out oftree connector allocation
> - of: drop svideo dt port
> - of: move svideo connector to port@0/endpoint@1
> - of: require at least 1-in and 1-out endpoint
>
>  drivers/media/i2c/tvp5150.c | 481 +++++++++++++++++++++++++++++++++---
>  1 file changed, 442 insertions(+), 39 deletions(-)
>
> diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
> index 89da921c8886..a89b83f69266 100644
> --- a/drivers/media/i2c/tvp5150.c
> +++ b/drivers/media/i2c/tvp5150.c
> @@ -44,15 +44,38 @@ MODULE_PARM_DESC(debug, "Debug level (0-2)");
>  #define dprintk0(__dev, __arg...) dev_dbg_lvl(__dev, 0, 0, __arg)
>
>  enum tvp5150_pads {
> -	TVP5150_PAD_IF_INPUT,
> +	TVP5150_PAD_AIP1A = TVP5150_COMPOSITE0,
> +	TVP5150_PAD_AIP1B,
>  	TVP5150_PAD_VID_OUT,
>  	TVP5150_NUM_PADS
>  };
>
> +#if defined(CONFIG_MEDIA_CONTROLLER)
> +enum tvp5150_pads_state {
> +	TVP5150_PAD_INACTIVE,
> +	TVP5150_PAD_ACTIVE_COMPOSITE,
> +	TVP5150_PAD_ACTIVE_SVIDEO,
> +};
> +
> +struct tvp5150_connector {
> +	struct media_entity ent;
> +	struct media_pad pad;
> +	unsigned int port_num;
> +	bool is_svideo;
> +};
> +#endif
> +
>  struct tvp5150 {
>  	struct v4l2_subdev sd;
> -#ifdef CONFIG_MEDIA_CONTROLLER
> +	/* additional additional endpoint for the svideo connector */
> +	struct device_node *endpoints[TVP5150_NUM_PADS + 1];
> +	unsigned int endpoints_num;
> +#if defined(CONFIG_MEDIA_CONTROLLER)
>  	struct media_pad pads[TVP5150_NUM_PADS];
> +	int pads_state[TVP5150_NUM_PADS];
> +	struct tvp5150_connector *connectors;
> +	int connectors_num;
> +	bool modify_second_link;
>  #endif
>  	struct v4l2_ctrl_handler hdl;
>  	struct v4l2_rect rect;
> @@ -1167,6 +1190,160 @@ static int tvp5150_enum_frame_size(struct v4l2_subdev *sd,
>  	return 0;
>  }
>
> +/****************************************************************************
> + *			Media entity ops
> + ****************************************************************************/
> +#if defined(CONFIG_MEDIA_CONTROLLER)
> +static int tvp5150_active_pad_idx(struct tvp5150 *decoder)
> +{
> +	int *pad_state = &decoder->pads_state[0];
> +	int i, idx = -1;
> +
> +	for (i = 0; i < TVP5150_NUM_PADS - 1; i++) {
> +		if ((pad_state[i] == TVP5150_PAD_ACTIVE_COMPOSITE) ||
> +		    (pad_state[i] == TVP5150_PAD_ACTIVE_SVIDEO)) {
> +			idx = i;
> +			break;
> +		}
> +	}
> +
> +	return idx;
> +}
> +
> +static int tvp5150_active_svideo_links(struct tvp5150 *decoder)
> +{
> +	int *pad_state = &decoder->pads_state[0];
> +	int i, links = 0;
> +
> +	for (i = 0; i < TVP5150_NUM_PADS - 1; i++)
> +		if (pad_state[i] == TVP5150_PAD_ACTIVE_SVIDEO)
> +			links++;
> +
> +	return links;
> +}
> +
> +static int tvp5150_modify_link(struct tvp5150 *decoder, unsigned int pad_idx,
> +			       struct media_pad *pad, int flags)
> +{
> +	struct media_pad *src_pad;
> +	struct media_link *link;
> +
> +	if (pad)
> +		src_pad = pad;
> +	else
> +		src_pad = media_entity_remote_pad(&decoder->pads[pad_idx]);
> +
> +	if (!src_pad)
> +		return -1;
> +
> +	link = media_entity_find_link(src_pad,
> +				      &decoder->pads[pad_idx]);
> +
> +	/*
> +	 * Don't use locked version, since we are running already within the
> +	 * media_entity_setup_link() context.
> +	 */
> +	return __media_entity_setup_link(link, flags);
> +
> +}
> +
> +static int tvp5150_s_routing(struct v4l2_subdev *sd, u32 input, u32 output,
> +			     u32 config);
> +
> +static int tvp5150_link_setup(struct media_entity *entity,
> +			      const struct media_pad *tvp5150_pad,
> +			      const struct media_pad *remote, u32 flags)
> +{
> +	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
> +	struct tvp5150 *decoder = to_tvp5150(sd);
> +	int *pad_state = &decoder->pads_state[0];
> +	int i, active_pad, ret = 0;
> +	bool is_svideo = false;
> +
> +	/*
> +	 * The tvp state is determined by the enabled sink pad link.
> +	 * Enabling or disabling the source pad link has no effect.
> +	 */
> +	if (tvp5150_pad->flags & MEDIA_PAD_FL_SOURCE)
> +		return 0;
> +
> +	/* check if the svideo connector should be enabled */
> +	for (i = 0; i < decoder->connectors_num; i++) {
> +		if (remote->entity == &decoder->connectors[i].ent) {
> +			is_svideo = decoder->connectors[i].is_svideo;
> +			break;
> +		}
> +	}
> +
> +	/* check if there is already a enabled svideo link and determine pad */
> +	active_pad = tvp5150_active_pad_idx(decoder);

could this return -1 ? Is this an error?

> +
> +	dev_dbg(sd->dev, "link setup '%s':%d->'%s':%d[%d]",
> +		remote->entity->name, remote->index, tvp5150_pad->entity->name,
> +		tvp5150_pad->index, flags & MEDIA_LNK_FL_ENABLED);
> +
> +	if (flags & MEDIA_LNK_FL_ENABLED) {
> +		if (active_pad >= 0 && !decoder->modify_second_link)
> +			tvp5150_modify_link(decoder, active_pad, NULL, 0);
> +
> +		dev_dbg(sd->dev, "Setting %d active [%s]\n", tvp5150_pad->index,
> +			is_svideo ? "svideo" : "composite");
> +		pad_state[tvp5150_pad->index] =
> +			is_svideo ? TVP5150_PAD_ACTIVE_SVIDEO :
> +				    TVP5150_PAD_ACTIVE_COMPOSITE;
> +
> +		if (is_svideo) {
> +			if (tvp5150_active_svideo_links(decoder) < 2) {
> +				unsigned int idx = tvp5150_pad->index ^ 1;
> +
> +				decoder->modify_second_link = true;
> +				tvp5150_modify_link(decoder, idx,
> +						    (struct media_pad *)remote,
> +						    MEDIA_LNK_FL_ENABLED);
> +			} else {
> +				decoder->modify_second_link = false;
> +				tvp5150_s_routing(sd, TVP5150_SVIDEO,
> +						  TVP5150_NORMAL, 0);
> +			}
> +		} else {
> +			tvp5150_s_routing(sd, tvp5150_pad->index,
> +					  TVP5150_NORMAL, 0);
> +		}

I admit I didn't get how you use modify_second_link and s_routing(),
so I'll just assume it's correct :)

> +	} else {
> +		/*
> +		 * Svideo streams on two pads and user can request to AIP1A or
> +		 * AIP1B pad. In either case both pads gets disabled in in go.
> +		 * So check only if user wants to disable a not enabled
> +		 * composite pad.
> +		 */
> +		if (!is_svideo && tvp5150_pad->index != active_pad)
> +			goto out;
> +
> +		dev_dbg(sd->dev, "going inactive\n");
> +		pad_state[tvp5150_pad->index] = TVP5150_PAD_INACTIVE;
> +
> +		/* in case of svideo we need to disable the second pad too */
> +		if (tvp5150_active_svideo_links(decoder) > 0) {

No need for "> 0"

> +			unsigned int idx = tvp5150_pad->index ^ 1;
> +
> +			decoder->modify_second_link = true;
> +			tvp5150_modify_link(decoder, idx,
> +					    (struct media_pad *)remote, 0);
> +		}
> +
> +		if (!decoder->modify_second_link)
> +			tvp5150_s_routing(sd, is_svideo ? TVP5150_SVIDEO :
> +					  active_pad, TVP5150_BLACK_SCREEN, 0);
> +		decoder->modify_second_link = false;
> +	}
> +out:
> +	return ret;
> +}
> +
> +static const struct media_entity_operations tvp5150_sd_media_ops = {
> +	.link_setup = tvp5150_link_setup,
> +};
> +#endif
>  /****************************************************************************
>  			I2C Command
>   ****************************************************************************/
> @@ -1314,6 +1491,76 @@ static int tvp5150_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
>  	return 0;
>  }
>
> +static int tvp5150_registered(struct v4l2_subdev *sd)
> +{
> +#if defined(CONFIG_MEDIA_CONTROLLER)
> +	struct tvp5150 *decoder = to_tvp5150(sd);
> +	unsigned int i;
> +	int ret;
> +
> +	/*
> +	 * Setup connector pads and links. Enable the link to the first
> +	 * available connector per default.
> +	 */
> +	for (i = 0; i < decoder->connectors_num; i++) {
> +		struct media_entity *con = &decoder->connectors[i].ent;
> +		struct media_pad *pad = &decoder->connectors[i].pad;
> +		unsigned int port = decoder->connectors[i].port_num;
> +		bool is_svideo = decoder->connectors[i].is_svideo;
> +		int flags = i ? 0 : MEDIA_LNK_FL_ENABLED;
> +
> +		pad->flags = MEDIA_PAD_FL_SOURCE;
> +		ret = media_entity_pads_init(con, 1, pad);
> +		if (ret < 0)
> +			return ret;
> +
> +		ret = media_device_register_entity(sd->v4l2_dev->mdev, con);
> +		if (ret < 0)
> +			return ret;
> +
> +		ret = media_create_pad_link(con, 0, &sd->entity, port, flags);
> +		if (ret < 0) {
> +			media_device_unregister_entity(con);
> +			return ret;
> +		}
> +
> +		if (is_svideo) {
> +			/* svideo links to both aip1a and aip1b */
> +			ret = media_create_pad_link(con, 0, &sd->entity,
> +						    port + 1, flags);

This would link to aip1b endpoint@0, right? It seems from your DT
bindings example that it is accepted to have aip1b with a composite
endpoint and an s_video endpoint@1 in aip1a, isn't it?

> +			if (ret < 0) {
> +				media_device_unregister_entity(con);
> +				return ret;
> +			}
> +		}
> +
> +		/* enable default input */
> +		if (flags == MEDIA_LNK_FL_ENABLED) {
> +			if (is_svideo) {
> +				decoder->pads_state[TVP5150_PAD_AIP1A] =
> +				decoder->pads_state[TVP5150_PAD_AIP1B] =
> +						TVP5150_PAD_ACTIVE_SVIDEO;
> +				decoder->input = TVP5150_SVIDEO;
> +			} else {
> +				if (port == 0) {
> +					decoder->pads_state[TVP5150_PAD_AIP1A] =
> +						TVP5150_PAD_ACTIVE_COMPOSITE;
> +					decoder->input = TVP5150_COMPOSITE0;
> +				} else {
> +					decoder->pads_state[TVP5150_PAD_AIP1B] =
> +						TVP5150_PAD_ACTIVE_COMPOSITE;
> +					decoder->input = TVP5150_COMPOSITE1;
> +				}
> +			}
> +			tvp5150_selmux(sd);
> +			decoder->modify_second_link = false;
> +		}
> +	}
> +#endif
> +	return 0;
> +}
> +
> +
>  /* ----------------------------------------------------------------------- */
>
>  static const struct v4l2_ctrl_ops tvp5150_ctrl_ops = {
> @@ -1367,6 +1614,10 @@ static const struct v4l2_subdev_ops tvp5150_ops = {
>  	.pad = &tvp5150_pad_ops,
>  };
>
> +static const struct v4l2_subdev_internal_ops tvp5150_internal_ops = {
> +	.registered = tvp5150_registered,
> +};
> +
>  /****************************************************************************
>  			I2C Client & Driver
>   ****************************************************************************/
> @@ -1515,38 +1766,197 @@ static int tvp5150_init(struct i2c_client *c)
>  	return 0;
>  }
>
> -static int tvp5150_parse_dt(struct tvp5150 *decoder, struct device_node *np)
> +#if defined(CONFIG_MEDIA_CONTROLLER)
> +static int tvp5150_add_of_connectors(struct tvp5150 *decoder)
>  {
> -	struct v4l2_fwnode_endpoint bus_cfg = { .bus_type = 0 };
> -	struct device_node *ep;
> -	unsigned int flags;
> -	int ret = 0;
> +	struct device *dev = decoder->sd.dev;
> +	struct device_node *rp;
> +	struct of_endpoint ep;
> +	struct tvp5150_connector *connectors;
> +	unsigned int connectors_num = decoder->connectors_num;
> +	int i, ret;
> +
> +	/* Allocate and initialize all available input connectors */
> +	connectors = devm_kcalloc(dev, connectors_num, sizeof(*connectors),
> +				  GFP_KERNEL);
> +	if (!connectors)
> +		return -ENOMEM;
>
> -	ep = of_graph_get_next_endpoint(np, NULL);
> -	if (!ep)
> -		return -EINVAL;
> +	for (i = 0; i < connectors_num; i++) {
> +		rp = of_graph_get_remote_port_parent(decoder->endpoints[i]);
> +		of_graph_parse_endpoint(decoder->endpoints[i], &ep);
> +		connectors[i].port_num = ep.port;
> +		connectors[i].is_svideo = !!of_device_is_compatible(rp,
> +							    "svideo-connector");
>
> -	ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep), &bus_cfg);
> -	if (ret)
> -		goto err;
> +		if (connectors[i].is_svideo)
> +			connectors[i].ent.function = MEDIA_ENT_F_CONN_SVIDEO;
> +		else
> +			connectors[i].ent.function = MEDIA_ENT_F_CONN_COMPOSITE;
> +
> +		connectors[i].ent.flags = MEDIA_ENT_FL_CONNECTOR;
> +		ret = of_property_read_string(rp, "label",
> +					      &connectors[i].ent.name);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	decoder->connectors = connectors;
> +
> +	return 0;
> +}
> +#endif
> +
> +static int tvp5150_mc_init(struct v4l2_subdev *sd)
> +{
> +#if defined(CONFIG_MEDIA_CONTROLLER)
> +	struct tvp5150 *decoder = to_tvp5150(sd);
> +	unsigned int i;
> +	int ret;
> +
> +	sd->entity.ops = &tvp5150_sd_media_ops;
> +	sd->entity.function = MEDIA_ENT_F_ATV_DECODER;
>
> -	flags = bus_cfg.bus.parallel.flags;
> +	/* Initialize all TVP5150 pads */
> +	for (i = 0; i < TVP5150_NUM_PADS; i++) {
> +		if (i < TVP5150_NUM_PADS - 1) {
> +			decoder->pads[i].flags = MEDIA_PAD_FL_SINK;
> +			decoder->pads[i].sig_type = PAD_SIGNAL_ANALOG;
> +		} else {
> +			decoder->pads[i].flags = MEDIA_PAD_FL_SOURCE;
> +			decoder->pads[i].sig_type = PAD_SIGNAL_DV;
> +		}
> +	}
> +	ret = media_entity_pads_init(&sd->entity, TVP5150_NUM_PADS,
> +				     decoder->pads);
> +	if (ret < 0)
> +		goto out;
>
> -	if (bus_cfg.bus_type == V4L2_MBUS_PARALLEL &&
> -	    !(flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH &&
> -	      flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH &&
> -	      flags & V4L2_MBUS_FIELD_EVEN_LOW)) {
> +	if (IS_ENABLED(CONFIG_OF))
> +		ret = tvp5150_add_of_connectors(decoder);
> +#endif
> +out:
> +	return ret;

if CONFIG_MEDIA_CONTROLLER is not enabled, ret is not defined.
Also please consider making a stub in the #else branch where you just
return 0;

As a general note, try to build without media controller support, I
see a few errors.

> +}
> +
> +static bool tvp5150_of_valid_input(struct device_node *endpoint,
> +				unsigned int port, unsigned int id)
> +{
> +	struct device_node *rp = of_graph_get_remote_port_parent(endpoint);
> +	const char *input;
> +	int ret;
> +
> +	/* perform some basic checks needed for later mc_init */
> +	switch (port) {
> +	case TVP5150_PAD_AIP1A:
> +		/* svideo must be connected to endpoint@1  */
> +		ret = id ? of_device_is_compatible(rp, "svideo-connector") :
> +			   of_device_is_compatible(rp,
> +						   "composite-video-connector");
> +		if (!ret)
> +			return false;
> +		break;
> +	case TVP5150_PAD_AIP1B:
> +		ret = of_device_is_compatible(rp, "composite-video-connector");
> +		if (!ret)
> +			return false;
> +		break;
> +	}
> +
> +	ret = of_property_read_string(rp, "label", &input);
> +	if (ret < 0)
> +		return false;

What are you using 'input' for, to make sure the property is there as
you use it later? Be aware that "label" is not mandatory for
connectors, and you need it only when media controller is enabled. If
you fail here, it will fail also for non-media controller devices that
do not need it. I would drop the check.

> +
> +	return true;
> +}
> +
> +static int tvp5150_parse_dt(struct tvp5150 *decoder, struct device_node *np)
> +{
> +	struct device *dev = decoder->sd.dev;
> +	struct v4l2_fwnode_endpoint bus_cfg = { .bus_type = 0 };

please use V4L2_MBUS_UNKNOWN instead of 0

> +	struct device_node *ep_np;
> +	unsigned int flags;
> +	int ret, i = 0, in = 0;
> +	bool found = false;
> +
> +	/* at least 1 output and 1 input */

Nitpicking: some comments start with lowercase other with upper case.
Also, sometimes there's a full stop  at the end of the statement,
sometimes not.

> +	decoder->endpoints_num = of_graph_get_endpoint_count(np);
> +	if (decoder->endpoints_num < 2 || decoder->endpoints_num > 4) {

I would print an error, as bindings are wrong and this should appear
in boot logs.

>  		ret = -EINVAL;
>  		goto err;
>  	}
>
> -	decoder->mbus_type = bus_cfg.bus_type;
> +	for_each_endpoint_of_node(np, ep_np) {
> +		struct of_endpoint ep;
> +
> +		of_graph_parse_endpoint(ep_np, &ep);
> +		if (decoder->endpoints[i]) {

Can you trigger this error condition with wrong bindings? I don't
think so. This is a development error, and if your code is correct,
this won't happen. I would drop the check, if I'm not mistaken.

> +			/* this should never happen */
> +			dev_err(dev, "Invalid endpoint %pOF on port %d\n",
> +				ep.local_node, ep.port);
> +				ret = -EINVAL;
> +				goto err;
> +		}
>
> +		switch (ep.port) {
> +			/* fall through */
> +		case TVP5150_PAD_AIP1A:
> +		case TVP5150_PAD_AIP1B:
> +			if (!tvp5150_of_valid_input(ep_np, ep.port, ep.id)) {
> +				dev_err(dev,
> +					"Invalid endpoint %pOF on port %d\n",
> +					ep.local_node, ep.port);
> +				ret = -EINVAL;
> +				goto err;
> +			}
> +			in++;
> +			break;
> +		case TVP5150_PAD_VID_OUT:
> +			ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep_np),
> +							 &bus_cfg);

> +				goto err;
> +
> +			flags = bus_cfg.bus.parallel.flags;
> +
> +			if (bus_cfg.bus_type == V4L2_MBUS_PARALLEL &&
> +			    !(flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH &&
> +			      flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH &&
> +			      flags & V4L2_MBUS_FIELD_EVEN_LOW)) {

There's a bit of confusion in bindings related to this.
The properties are listed as required, then it says if none are
specified it is assumed embedded BT.656 sync, and indeed here you want
all of them to be present to accept the bus as parallel.

So you either make them optional, or use 'bus-type'
property and use the newly introduced bus hints to
v4l2_fwnode_endpoint_parse and try to parse
V4L2_MBUS_PARALLEL first, V4L2_MBUS_BT656 if parallel fails, and
return an error otherwise.

I think making the properties optional is the easiest way, you're
touching bindings anyway in the next patch.

Thanks
   j

> +				ret = -EINVAL;
> +				goto err;
> +			}
> +
> +			decoder->mbus_type = bus_cfg.bus_type;
> +			break;
> +		default:
> +			dev_err(dev, "Invalid port %d for endpoint %pOF\n",
> +				ep.port, ep.local_node);
> +			ret = -EINVAL;
> +			goto err;
> +		}
> +
> +		of_node_get(ep_np);
> +		decoder->endpoints[i] = ep_np;
> +		i++;
> +
> +		found = true;
> +	}
> +
> +	decoder->connectors_num = in;
> +	return found ? 0 : -ENODEV;
>  err:
> -	of_node_put(ep);
>  	return ret;
>  }
>
> +static void tvp5150_dt_cleanup(struct tvp5150 *decoder)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < TVP5150_NUM_PADS; i++)
> +		of_node_put(decoder->endpoints[i]);
> +}
> +
>  static const char * const tvp5150_test_patterns[2] = {
>  	"Disabled",
>  	"Black screen"
> @@ -1585,7 +1995,7 @@ static int tvp5150_probe(struct i2c_client *c,
>  		res = tvp5150_parse_dt(core, np);
>  		if (res) {
>  			dev_err(sd->dev, "DT parsing error: %d\n", res);
> -			return res;
> +			goto err_cleanup_dt;
>  		}
>  	} else {
>  		/* Default to BT.656 embedded sync */
> @@ -1593,25 +2003,16 @@ static int tvp5150_probe(struct i2c_client *c,
>  	}
>
>  	v4l2_i2c_subdev_init(sd, c, &tvp5150_ops);
> +	sd->internal_ops = &tvp5150_internal_ops;
>  	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
>
> -#if defined(CONFIG_MEDIA_CONTROLLER)
> -	core->pads[TVP5150_PAD_IF_INPUT].flags = MEDIA_PAD_FL_SINK;
> -	core->pads[TVP5150_PAD_IF_INPUT].sig_type = PAD_SIGNAL_ANALOG;
> -	core->pads[TVP5150_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
> -	core->pads[TVP5150_PAD_VID_OUT].sig_type = PAD_SIGNAL_DV;
> -
> -	sd->entity.function = MEDIA_ENT_F_ATV_DECODER;
> -
> -	res = media_entity_pads_init(&sd->entity, TVP5150_NUM_PADS, core->pads);
> -	if (res < 0)
> -		return res;
> -
> -#endif
> +	res = tvp5150_mc_init(sd);
> +	if (res)
> +		goto err_cleanup_dt;
>
>  	res = tvp5150_detect_version(core);
>  	if (res < 0)
> -		return res;
> +		goto err_cleanup_dt;
>
>  	core->norm = V4L2_STD_ALL;	/* Default is autodetect */
>  	core->detected_norm = V4L2_STD_UNKNOWN;
> @@ -1637,7 +2038,7 @@ static int tvp5150_probe(struct i2c_client *c,
>  	sd->ctrl_handler = &core->hdl;
>  	if (core->hdl.error) {
>  		res = core->hdl.error;
> -		goto err;
> +		goto err_free_v4l2_ctrls;
>  	}
>
>  	tvp5150_set_default(tvp5150_read_std(sd), &core->rect);
> @@ -1649,19 +2050,21 @@ static int tvp5150_probe(struct i2c_client *c,
>  						tvp5150_isr, IRQF_TRIGGER_HIGH |
>  						IRQF_ONESHOT, "tvp5150", core);
>  		if (res)
> -			goto err;
> +			goto err_free_v4l2_ctrls;
>  	}
>
>  	res = v4l2_async_register_subdev(sd);
>  	if (res < 0)
> -		goto err;
> +		goto err_free_v4l2_ctrls;
>
>  	if (debug > 1)
>  		tvp5150_log_status(sd);
>  	return 0;
>
> -err:
> +err_free_v4l2_ctrls:
>  	v4l2_ctrl_handler_free(&core->hdl);
> +err_cleanup_dt:
> +	tvp5150_dt_cleanup(core);
>  	return res;
>  }
>
> --
> 2.20.1
>

--5cvtt2x3uvtmexo3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEtcQ9SICaIIqPWDjAcjQGjxahVjwFAlyTi5cACgkQcjQGjxah
VjxfTA/9G+4BcVb79Xg8Ad4FR6nSDyCB+rl2WSluqhrq8f9gfg2Dd+VtM0LRTBCZ
KSoYZx7w97Z48Bl/OTGJdXF3rahjmu0tC4X0nqY//prEg/bqhiEYBsVRmd+CLv5Z
D4wOLVWZqu53NC58vYXTjKBbzEOOyExBbuh0a/rWuoJ/VjUjSFHBC4mGVh7ZSXFN
UogVdT5GSYycsrRenS+X8b5mkt0hUp+VHW59ntUd5+O49mWJgIvuDZ+7wdRS3Seb
OCTA0T/KFGK1CGsbHntg8z7EDlLyXvj2SLKDuSWjvAceGiX6sngEBEkNV0UBXNW9
gE26nphOlWvHnqLhebsH5HWwdOjO5n0RBOgV53LhOBVIy+6Tq6PEspy3OL/3TnaA
B0DQWnaWMyxpaZVi+Ni8YG++jxKpJqejMmqdKbFg5u5ixU5pM1lKpxC//aSv8avZ
qUqo8WQa76Nj3hfvLKd2F1A4lQP/Ufk20NWwFDNwTglYrzvXNcY8hTklcU3tNrLB
MakwDM3XLbg65K7mGzjGur+ZliswcS/W/xPUXHMVGQnJIXTzdsZnj8s0FcztUadt
H8fkmvJLUUXFXuAFiVPFHjLDxpSjHkheygqRywN2z7QQjM6k05+TV1cGgGue6pou
E7Svcyem2VN4stMsrBAIUaqbDN9QnLGmh+hGptDUBMktIO+Z/uM=
=cbcs
-----END PGP SIGNATURE-----

--5cvtt2x3uvtmexo3--
