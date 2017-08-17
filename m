Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58963 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752872AbdHQXj1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Aug 2017 19:39:27 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org
Subject: Re: [RFT PATCH] [media] partial revert of "[media] tvp5150: add HW input connectors support"
Date: Fri, 18 Aug 2017 02:39:52 +0300
Message-ID: <1586557.2YdV9WZC1V@avalon>
In-Reply-To: <1481643559-19666-1-git-send-email-javier@osg.samsung.com>
References: <1481643559-19666-1-git-send-email-javier@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

Thank you for the patch.

On Tuesday 13 Dec 2016 12:39:19 Javier Martinez Canillas wrote:
> Commit f7b4b54e6364 ("[media] tvp5150: add HW input connectors support")
> added input signals support for the tvp5150, but the approach was found
> to be incorrect so the corresponding DT binding commit 82c2ffeb217a
> ("[media] tvp5150: document input connectors DT bindings") was reverted.
> 
> This left the driver with an undocumented (and wrong) DT parsing logic,
> so lets get rid of this code as well until the input connectors support
> is implemented properly.
> 
> It's a partial revert due other patches added on top of mentioned commit
> not allowing the commit to be reverted cleanly anymore. But all the code
> related to the DT parsing logic and input entities creation are removed.
> 
> Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
> 
> Hello Laurent,
> 
> I've tested this patch on top of media/master on my IGEPv2 + tvp5150
> with the following:
> 
> $ media-ctl -r -l '"tvp5150 1-005c":1->"OMAP3 ISP CCDC":0[1], "OMAP3 ISP
> CCDC":1->"OMAP3 ISP CCDC output":0[1]' $ media-ctl -v --set-format '"OMAP3
> ISP CCDC":0 [UYVY2X8 720x240 field:alternate]' $ media-ctl -v --set-format
> '"OMAP3 ISP CCDC":1 [UYVY2X8 720x240 field:interlaced-tb]' $ yavta -f UYVY
> -s 720x480 -n 1 --field interlaced-tb --capture=1 -F /dev/video2 $
> raw2rgbpnm -f UYVY -s 720x480 frame-000000.bin frame.pnm
> 
> I've also tested the other composite input with the following change:
> 
> diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
> index 5fe5faefe212..973be68ff78c 100644
> --- a/drivers/media/i2c/tvp5150.c
> +++ b/drivers/media/i2c/tvp5150.c
> @@ -1371,7 +1371,7 @@ static int tvp5150_probe(struct i2c_client *c,
>                 return res;
> 
>         core->norm = V4L2_STD_ALL;      /* Default is autodetect */
> -       core->input = TVP5150_COMPOSITE1;
> +       core->input = TVP5150_COMPOSITE0;
>         core->enable = true;
> 
>         v4l2_ctrl_handler_init(&core->hdl, 5);
> 
> But as mentioned, it also worked for me without the revert so please let
> me know if the driver works with your omap3 board.
> 
> Best regards,
> Javier
> 
>  drivers/media/i2c/tvp5150.c | 142
> -------------------------------------------- 1 file changed, 142
> deletions(-)
> 
> diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
> index 48646a7f3fb0..5fe5faefe212 100644
> --- a/drivers/media/i2c/tvp5150.c
> +++ b/drivers/media/i2c/tvp5150.c
> @@ -42,8 +42,6 @@ struct tvp5150 {
>  	struct v4l2_subdev sd;
>  #ifdef CONFIG_MEDIA_CONTROLLER
>  	struct media_pad pads[DEMOD_NUM_PADS];
> -	struct media_entity input_ent[TVP5150_INPUT_NUM];
> -	struct media_pad input_pad[TVP5150_INPUT_NUM];
>  #endif
>  	struct v4l2_ctrl_handler hdl;
>  	struct v4l2_rect rect;
> @@ -1018,40 +1016,6 @@ static int tvp5150_enum_frame_size(struct v4l2_subdev
> *sd, }
> 
>  /**************************************************************************
> ** -			Media entity ops
> -
> ***************************************************************************
> */ -
> -#ifdef CONFIG_MEDIA_CONTROLLER
> -static int tvp5150_link_setup(struct media_entity *entity,
> -			      const struct media_pad *local,
> -			      const struct media_pad *remote, u32 flags)
> -{
> -	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
> -	struct tvp5150 *decoder = to_tvp5150(sd);
> -	int i;
> -
> -	for (i = 0; i < TVP5150_INPUT_NUM; i++) {
> -		if (remote->entity == &decoder->input_ent[i])
> -			break;
> -	}
> -
> -	/* Do nothing for entities that are not input connectors */
> -	if (i == TVP5150_INPUT_NUM)
> -		return 0;
> -
> -	decoder->input = i;
> -
> -	tvp5150_selmux(sd);
> -
> -	return 0;
> -}
> -
> -static const struct media_entity_operations tvp5150_sd_media_ops = {
> -	.link_setup = tvp5150_link_setup,
> -};
> -#endif
> -
> -/**************************************************************************
> ** I2C Command
>  
> ***************************************************************************
> */
> 
> @@ -1188,42 +1152,6 @@ static int tvp5150_g_tuner(struct v4l2_subdev *sd,
> struct v4l2_tuner *vt) return 0;
>  }
> 
> -static int tvp5150_registered(struct v4l2_subdev *sd)
> -{
> -#ifdef CONFIG_MEDIA_CONTROLLER
> -	struct tvp5150 *decoder = to_tvp5150(sd);
> -	int ret = 0;
> -	int i;
> -
> -	for (i = 0; i < TVP5150_INPUT_NUM; i++) {
> -		struct media_entity *input = &decoder->input_ent[i];
> -		struct media_pad *pad = &decoder->input_pad[i];
> -
> -		if (!input->name)
> -			continue;
> -
> -		decoder->input_pad[i].flags = MEDIA_PAD_FL_SOURCE;
> -
> -		ret = media_entity_pads_init(input, 1, pad);
> -		if (ret < 0)
> -			return ret;
> -
> -		ret = media_device_register_entity(sd->v4l2_dev->mdev, input);
> -		if (ret < 0)
> -			return ret;
> -
> -		ret = media_create_pad_link(input, 0, &sd->entity,
> -					    DEMOD_PAD_IF_INPUT, 0);
> -		if (ret < 0) {
> -			media_device_unregister_entity(input);
> -			return ret;
> -		}
> -	}
> -#endif
> -
> -	return 0;
> -}
> -
>  /* -----------------------------------------------------------------------
> */
> 
>  static const struct v4l2_ctrl_ops tvp5150_ctrl_ops = {
> @@ -1274,11 +1202,6 @@ static const struct v4l2_subdev_ops tvp5150_ops = {
>  	.pad = &tvp5150_pad_ops,
>  };
> 
> -static const struct v4l2_subdev_internal_ops tvp5150_internal_ops = {
> -	.registered = tvp5150_registered,
> -};
> -
> -
>  /**************************************************************************
> ** I2C Client & Driver
>  
> ***************************************************************************
> */ @@ -1360,12 +1283,6 @@ static int tvp5150_parse_dt(struct tvp5150
> *decoder, struct device_node *np) {
>  	struct v4l2_of_endpoint bus_cfg;
>  	struct device_node *ep;
> -#ifdef CONFIG_MEDIA_CONTROLLER
> -	struct device_node *connectors, *child;
> -	struct media_entity *input;
> -	const char *name;
> -	u32 input_type;
> -#endif
>  	unsigned int flags;
>  	int ret = 0;
> 
> @@ -1389,63 +1306,6 @@ static int tvp5150_parse_dt(struct tvp5150 *decoder,
> struct device_node *np)
> 
>  	decoder->mbus_type = bus_cfg.bus_type;
> 
> -#ifdef CONFIG_MEDIA_CONTROLLER
> -	connectors = of_get_child_by_name(np, "connectors");
> -
> -	if (!connectors)
> -		goto err;
> -
> -	for_each_available_child_of_node(connectors, child) {
> -		ret = of_property_read_u32(child, "input", &input_type);
> -		if (ret) {
> -			dev_err(decoder->sd.dev,
> -				 "missing type property in node %s\n",
> -				 child->name);
> -			goto err_connector;
> -		}
> -
> -		if (input_type >= TVP5150_INPUT_NUM) {
> -			ret = -EINVAL;
> -			goto err_connector;
> -		}
> -
> -		input = &decoder->input_ent[input_type];
> -
> -		/* Each input connector can only be defined once */
> -		if (input->name) {
> -			dev_err(decoder->sd.dev,
> -				 "input %s with same type already exists\n",
> -				 input->name);
> -			ret = -EINVAL;
> -			goto err_connector;
> -		}
> -
> -		switch (input_type) {
> -		case TVP5150_COMPOSITE0:
> -		case TVP5150_COMPOSITE1:
> -			input->function = MEDIA_ENT_F_CONN_COMPOSITE;
> -			break;
> -		case TVP5150_SVIDEO:
> -			input->function = MEDIA_ENT_F_CONN_SVIDEO;
> -			break;
> -		}
> -
> -		input->flags = MEDIA_ENT_FL_CONNECTOR;
> -
> -		ret = of_property_read_string(child, "label", &name);
> -		if (ret < 0) {
> -			dev_err(decoder->sd.dev,
> -				 "missing label property in node %s\n",
> -				 child->name);
> -			goto err_connector;
> -		}
> -
> -		input->name = name;
> -	}
> -
> -err_connector:
> -	of_node_put(connectors);
> -#endif
>  err:
>  	of_node_put(ep);
>  	return ret;
> @@ -1491,7 +1351,6 @@ static int tvp5150_probe(struct i2c_client *c,
>  	}
> 
>  	v4l2_i2c_subdev_init(sd, c, &tvp5150_ops);
> -	sd->internal_ops = &tvp5150_internal_ops;
>  	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> 
>  #if defined(CONFIG_MEDIA_CONTROLLER)
> @@ -1505,7 +1364,6 @@ static int tvp5150_probe(struct i2c_client *c,
>  	if (res < 0)
>  		return res;
> 
> -	sd->entity.ops = &tvp5150_sd_media_ops;
>  #endif
> 
>  	res = tvp5150_detect_version(core);

-- 
Regards,

Laurent Pinchart
