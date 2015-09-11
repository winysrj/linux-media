Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:50000 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753337AbbIKPed (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2015 11:34:33 -0400
Message-ID: <55F2F287.8000707@xs4all.nl>
Date: Fri, 11 Sep 2015 17:25:59 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Jonathan Corbet <corbet@lwn.net>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Heungjun Kim <riverful.kim@samsung.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Hyun Kwon <hyun.kwon@xilinx.com>,
	Michal Simek <michal.simek@xilinx.com>,
	=?windows-1252?Q?S=F6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	=?windows-1252?Q?Rafael_?=
	 =?windows-1252?Q?Louren=E7o_de_Lima_Chehab?=
	<chehabrafael@gmail.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>,
	Joe Perches <joe@perches.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Markus Elfring <elfring@users.sourceforge.net>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Antti Palosaari <crope@iki.fi>,
	Olli Salonen <olli.salonen@iki.fi>,
	Tommi Rantala <tt.rantala@gmail.com>,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Bryan Wu <cooloney@gmail.com>,
	Lars-Peter Clausen <lars@metafoo.de>,
	linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 13/18] [media] media-entity.h: rename entity.type to entity.function
References: <cover.1441559233.git.mchehab@osg.samsung.com> <10e7edf1c85965d8ef8c6c5f527fd695a2660fc4.1441559233.git.mchehab@osg.samsung.com>
In-Reply-To: <10e7edf1c85965d8ef8c6c5f527fd695a2660fc4.1441559233.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/06/2015 07:30 PM, Mauro Carvalho Chehab wrote:
> Entities should have one or more functions. Calling it as a
> type proofed to not be correct, as an entity could eventually
> have more than one type.
> 
> So, rename the field as function.
> 
> Please notice that this patch doesn't extend support for
> multiple function entities. Such change will happen when
> we have real case drivers using it.
> 
> No functional changes.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

I like this!

> 
> diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
> index 109cc3792534..2e0fc28fa12f 100644
> --- a/Documentation/video4linux/v4l2-framework.txt
> +++ b/Documentation/video4linux/v4l2-framework.txt
> @@ -303,8 +303,8 @@ calling media_entity_init():
>  	err = media_entity_init(&sd->entity, npads, pads);
>  
>  The pads array must have been previously initialized. There is no need to
> -manually set the struct media_entity type and name fields, but the revision
> -field must be initialized if needed.
> +manually set the struct media_entity function and name fields, but the
> +revision field must be initialized if needed.
>  
>  A reference to the entity will be automatically acquired/released when the
>  subdev device node (if any) is opened/closed.
> diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
> index df2fe4cc2d47..e925909bc99e 100644
> --- a/drivers/media/dvb-core/dvbdev.c
> +++ b/drivers/media/dvb-core/dvbdev.c
> @@ -229,7 +229,7 @@ static int dvb_create_tsout_entity(struct dvb_device *dvbdev,
>  		if (!entity->name)
>  			return ret;
>  
> -		entity->type = MEDIA_ENT_T_DVB_TSOUT;
> +		entity->function = MEDIA_ENT_T_DVB_TSOUT;
>  		pads->flags = MEDIA_PAD_FL_SINK;
>  
>  		ret = media_entity_init(entity, 1, pads);
> @@ -302,18 +302,18 @@ static int dvb_create_media_entity(struct dvb_device *dvbdev,
>  
>  	switch (type) {
>  	case DVB_DEVICE_FRONTEND:
> -		dvbdev->entity->type = MEDIA_ENT_T_DVB_DEMOD;
> +		dvbdev->entity->function = MEDIA_ENT_T_DVB_DEMOD;
>  		dvbdev->pads[0].flags = MEDIA_PAD_FL_SINK;
>  		dvbdev->pads[1].flags = MEDIA_PAD_FL_SOURCE;
>  		break;
>  	case DVB_DEVICE_DEMUX:
> -		dvbdev->entity->type = MEDIA_ENT_T_DVB_DEMUX;
> +		dvbdev->entity->function = MEDIA_ENT_T_DVB_DEMUX;
>  		dvbdev->pads[0].flags = MEDIA_PAD_FL_SINK;
>  		for (i = 1; i < npads; i++)
>  			dvbdev->pads[i].flags = MEDIA_PAD_FL_SOURCE;
>  		break;
>  	case DVB_DEVICE_CA:
> -		dvbdev->entity->type = MEDIA_ENT_T_DVB_CA;
> +		dvbdev->entity->function = MEDIA_ENT_T_DVB_CA;
>  		dvbdev->pads[0].flags = MEDIA_PAD_FL_SINK;
>  		dvbdev->pads[1].flags = MEDIA_PAD_FL_SOURCE;
>  		break;
> @@ -537,7 +537,7 @@ int dvb_create_media_graph(struct dvb_adapter *adap)
>  		return 0;
>  
>  	media_device_for_each_entity(entity, mdev) {
> -		switch (entity->type) {
> +		switch (entity->function) {
>  		case MEDIA_ENT_T_V4L2_SUBDEV_TUNER:
>  			tuner = entity;
>  			break;
> @@ -576,7 +576,7 @@ int dvb_create_media_graph(struct dvb_adapter *adap)
>  	/* Create demux links for each ringbuffer/pad */
>  	if (demux) {
>  		media_device_for_each_entity(entity, mdev) {
> -			if (entity->type == MEDIA_ENT_T_DVB_TSOUT) {
> +			if (entity->function == MEDIA_ENT_T_DVB_TSOUT) {
>  				if (!strncmp(entity->name, DVR_TSOUT,
>  				    strlen(DVR_TSOUT))) {
>  					ret = media_create_pad_link(demux,
> @@ -621,7 +621,7 @@ int dvb_create_media_graph(struct dvb_adapter *adap)
>  		}
>  
>  		media_device_for_each_entity(entity, mdev) {
> -			if (entity->type == MEDIA_ENT_T_DVB_TSOUT) {
> +			if (entity->function == MEDIA_ENT_T_DVB_TSOUT) {
>  				if (!strcmp(entity->name, DVR_TSOUT)) {
>  					link = media_create_intf_link(entity,
>  							intf,
> diff --git a/drivers/media/dvb-frontends/au8522_decoder.c b/drivers/media/dvb-frontends/au8522_decoder.c
> index 55cd42a584a5..a6fbe78a70e3 100644
> --- a/drivers/media/dvb-frontends/au8522_decoder.c
> +++ b/drivers/media/dvb-frontends/au8522_decoder.c
> @@ -775,7 +775,7 @@ static int au8522_probe(struct i2c_client *client,
>  	state->pads[AU8522_PAD_INPUT].flags = MEDIA_PAD_FL_SINK;
>  	state->pads[AU8522_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
>  	state->pads[AU8522_PAD_VBI_OUT].flags = MEDIA_PAD_FL_SOURCE;
> -	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_DECODER;
> +	sd->entity.function = MEDIA_ENT_T_V4L2_SUBDEV_DECODER;
>  
>  	ret = media_entity_init(&sd->entity, ARRAY_SIZE(state->pads),
>  				state->pads);
> diff --git a/drivers/media/i2c/adp1653.c b/drivers/media/i2c/adp1653.c
> index 5f76997f6e07..2b8f72ac0f7d 100644
> --- a/drivers/media/i2c/adp1653.c
> +++ b/drivers/media/i2c/adp1653.c
> @@ -516,7 +516,7 @@ static int adp1653_probe(struct i2c_client *client,
>  	if (ret < 0)
>  		goto free_and_quit;
>  
> -	flash->subdev.entity.type = MEDIA_ENT_T_V4L2_SUBDEV_FLASH;
> +	flash->subdev.entity.function = MEDIA_ENT_T_V4L2_SUBDEV_FLASH;
>  
>  	return 0;
>  
> diff --git a/drivers/media/i2c/as3645a.c b/drivers/media/i2c/as3645a.c
> index 9d579a836f79..a49ef7d6df18 100644
> --- a/drivers/media/i2c/as3645a.c
> +++ b/drivers/media/i2c/as3645a.c
> @@ -831,7 +831,7 @@ static int as3645a_probe(struct i2c_client *client,
>  	if (ret < 0)
>  		goto done;
>  
> -	flash->subdev.entity.type = MEDIA_ENT_T_V4L2_SUBDEV_FLASH;
> +	flash->subdev.entity.function = MEDIA_ENT_T_V4L2_SUBDEV_FLASH;
>  
>  	mutex_init(&flash->power_lock);
>  
> diff --git a/drivers/media/i2c/cx25840/cx25840-core.c b/drivers/media/i2c/cx25840/cx25840-core.c
> index 270135d06b32..d48a3a4df96b 100644
> --- a/drivers/media/i2c/cx25840/cx25840-core.c
> +++ b/drivers/media/i2c/cx25840/cx25840-core.c
> @@ -5208,7 +5208,7 @@ static int cx25840_probe(struct i2c_client *client,
>  	state->pads[CX25840_PAD_INPUT].flags = MEDIA_PAD_FL_SINK;
>  	state->pads[CX25840_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
>  	state->pads[CX25840_PAD_VBI_OUT].flags = MEDIA_PAD_FL_SOURCE;
> -	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_DECODER;
> +	sd->entity.function = MEDIA_ENT_T_V4L2_SUBDEV_DECODER;
>  
>  	ret = media_entity_init(&sd->entity, ARRAY_SIZE(state->pads),
>  				state->pads);
> diff --git a/drivers/media/i2c/lm3560.c b/drivers/media/i2c/lm3560.c
> index 9bd9def0852c..7c1abdca39d0 100644
> --- a/drivers/media/i2c/lm3560.c
> +++ b/drivers/media/i2c/lm3560.c
> @@ -368,7 +368,7 @@ static int lm3560_subdev_init(struct lm3560_flash *flash,
>  	rval = media_entity_init(&flash->subdev_led[led_no].entity, 0, NULL);
>  	if (rval < 0)
>  		goto err_out;
> -	flash->subdev_led[led_no].entity.type = MEDIA_ENT_T_V4L2_SUBDEV_FLASH;
> +	flash->subdev_led[led_no].entity.function = MEDIA_ENT_T_V4L2_SUBDEV_FLASH;
>  
>  	return rval;
>  
> diff --git a/drivers/media/i2c/lm3646.c b/drivers/media/i2c/lm3646.c
> index 4160e18af607..d609f2fa8e6c 100644
> --- a/drivers/media/i2c/lm3646.c
> +++ b/drivers/media/i2c/lm3646.c
> @@ -285,7 +285,7 @@ static int lm3646_subdev_init(struct lm3646_flash *flash)
>  	rval = media_entity_init(&flash->subdev_led.entity, 0, NULL);
>  	if (rval < 0)
>  		goto err_out;
> -	flash->subdev_led.entity.type = MEDIA_ENT_T_V4L2_SUBDEV_FLASH;
> +	flash->subdev_led.entity.function = MEDIA_ENT_T_V4L2_SUBDEV_FLASH;
>  	return rval;
>  
>  err_out:
> diff --git a/drivers/media/i2c/m5mols/m5mols_core.c b/drivers/media/i2c/m5mols/m5mols_core.c
> index f718a1009e4c..206319b88d7a 100644
> --- a/drivers/media/i2c/m5mols/m5mols_core.c
> +++ b/drivers/media/i2c/m5mols/m5mols_core.c
> @@ -978,7 +978,7 @@ static int m5mols_probe(struct i2c_client *client,
>  	ret = media_entity_init(&sd->entity, 1, &info->pad);
>  	if (ret < 0)
>  		return ret;
> -	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
> +	sd->entity.function = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
>  
>  	init_waitqueue_head(&info->irq_waitq);
>  	mutex_init(&info->lock);
> diff --git a/drivers/media/i2c/noon010pc30.c b/drivers/media/i2c/noon010pc30.c
> index a9761251b970..6cd407bcfddf 100644
> --- a/drivers/media/i2c/noon010pc30.c
> +++ b/drivers/media/i2c/noon010pc30.c
> @@ -779,7 +779,7 @@ static int noon010_probe(struct i2c_client *client,
>  		goto np_err;
>  
>  	info->pad.flags = MEDIA_PAD_FL_SOURCE;
> -	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
> +	sd->entity.function = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
>  	ret = media_entity_init(&sd->entity, 1, &info->pad);
>  	if (ret < 0)
>  		goto np_err;
> diff --git a/drivers/media/i2c/ov2659.c b/drivers/media/i2c/ov2659.c
> index 6bce9832ab7b..c085dec69201 100644
> --- a/drivers/media/i2c/ov2659.c
> +++ b/drivers/media/i2c/ov2659.c
> @@ -1445,7 +1445,7 @@ static int ov2659_probe(struct i2c_client *client,
>  
>  #if defined(CONFIG_MEDIA_CONTROLLER)
>  	ov2659->pad.flags = MEDIA_PAD_FL_SOURCE;
> -	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
> +	sd->entity.function = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
>  	ret = media_entity_init(&sd->entity, 1, &ov2659->pad);
>  	if (ret < 0) {
>  		v4l2_ctrl_handler_free(&ov2659->ctrls);
> diff --git a/drivers/media/i2c/ov9650.c b/drivers/media/i2c/ov9650.c
> index 8a8eb593fc23..2862244a6488 100644
> --- a/drivers/media/i2c/ov9650.c
> +++ b/drivers/media/i2c/ov9650.c
> @@ -1500,7 +1500,7 @@ static int ov965x_probe(struct i2c_client *client,
>  		return ret;
>  
>  	ov965x->pad.flags = MEDIA_PAD_FL_SOURCE;
> -	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
> +	sd->entity.function = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
>  	ret = media_entity_init(&sd->entity, 1, &ov965x->pad);
>  	if (ret < 0)
>  		return ret;
> diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
> index abae37321c0c..3f55168cce47 100644
> --- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
> +++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
> @@ -1688,7 +1688,7 @@ static int s5c73m3_probe(struct i2c_client *client,
>  
>  	state->sensor_pads[S5C73M3_JPEG_PAD].flags = MEDIA_PAD_FL_SOURCE;
>  	state->sensor_pads[S5C73M3_ISP_PAD].flags = MEDIA_PAD_FL_SOURCE;
> -	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
> +	sd->entity.function = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
>  
>  	ret = media_entity_init(&sd->entity, S5C73M3_NUM_PADS,
>  							state->sensor_pads);
> @@ -1704,7 +1704,7 @@ static int s5c73m3_probe(struct i2c_client *client,
>  	state->oif_pads[OIF_ISP_PAD].flags = MEDIA_PAD_FL_SINK;
>  	state->oif_pads[OIF_JPEG_PAD].flags = MEDIA_PAD_FL_SINK;
>  	state->oif_pads[OIF_SOURCE_PAD].flags = MEDIA_PAD_FL_SOURCE;
> -	oif_sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
> +	oif_sd->entity.function = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
>  
>  	ret = media_entity_init(&oif_sd->entity, OIF_NUM_PADS,
>  							state->oif_pads);
> diff --git a/drivers/media/i2c/s5k4ecgx.c b/drivers/media/i2c/s5k4ecgx.c
> index d207ddce31b6..45f6e6f2585a 100644
> --- a/drivers/media/i2c/s5k4ecgx.c
> +++ b/drivers/media/i2c/s5k4ecgx.c
> @@ -961,7 +961,7 @@ static int s5k4ecgx_probe(struct i2c_client *client,
>  	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
>  
>  	priv->pad.flags = MEDIA_PAD_FL_SOURCE;
> -	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
> +	sd->entity.function = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
>  	ret = media_entity_init(&sd->entity, 1, &priv->pad);
>  	if (ret)
>  		return ret;
> diff --git a/drivers/media/i2c/s5k5baf.c b/drivers/media/i2c/s5k5baf.c
> index 0513196bd48c..22dfeadf7672 100644
> --- a/drivers/media/i2c/s5k5baf.c
> +++ b/drivers/media/i2c/s5k5baf.c
> @@ -408,7 +408,7 @@ static inline struct v4l2_subdev *ctrl_to_sd(struct v4l2_ctrl *ctrl)
>  
>  static inline bool s5k5baf_is_cis_subdev(struct v4l2_subdev *sd)
>  {
> -	return sd->entity.type == MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
> +	return sd->entity.function == MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
>  }
>  
>  static inline struct s5k5baf *to_s5k5baf(struct v4l2_subdev *sd)
> @@ -1904,7 +1904,7 @@ static int s5k5baf_configure_subdevs(struct s5k5baf *state,
>  	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
>  
>  	state->cis_pad.flags = MEDIA_PAD_FL_SOURCE;
> -	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
> +	sd->entity.function = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
>  	ret = media_entity_init(&sd->entity, NUM_CIS_PADS, &state->cis_pad);
>  	if (ret < 0)
>  		goto err;
> @@ -1919,7 +1919,7 @@ static int s5k5baf_configure_subdevs(struct s5k5baf *state,
>  
>  	state->pads[PAD_CIS].flags = MEDIA_PAD_FL_SINK;
>  	state->pads[PAD_OUT].flags = MEDIA_PAD_FL_SOURCE;
> -	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
> +	sd->entity.function = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
>  	ret = media_entity_init(&sd->entity, NUM_ISP_PADS, state->pads);
>  
>  	if (!ret)
> diff --git a/drivers/media/i2c/s5k6aa.c b/drivers/media/i2c/s5k6aa.c
> index 39a461f9d9bb..71162c02d6d7 100644
> --- a/drivers/media/i2c/s5k6aa.c
> +++ b/drivers/media/i2c/s5k6aa.c
> @@ -1577,7 +1577,7 @@ static int s5k6aa_probe(struct i2c_client *client,
>  	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
>  
>  	s5k6aa->pad.flags = MEDIA_PAD_FL_SOURCE;
> -	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
> +	sd->entity.function = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
>  	ret = media_entity_init(&sd->entity, 1, &s5k6aa->pad);
>  	if (ret)
>  		return ret;
> diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
> index 5aa49eb393a9..bb1f891a1eb6 100644
> --- a/drivers/media/i2c/smiapp/smiapp-core.c
> +++ b/drivers/media/i2c/smiapp/smiapp-core.c
> @@ -2763,7 +2763,7 @@ static int smiapp_init(struct smiapp_sensor *sensor)
>  
>  	dev_dbg(&client->dev, "profile %d\n", sensor->minfo.smiapp_profile);
>  
> -	sensor->pixel_array->sd.entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
> +	sensor->pixel_array->sd.entity.function = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
>  
>  	/* final steps */
>  	smiapp_read_frame_fmt(sensor);
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index 97eb97d9b662..ccef9621d147 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -108,7 +108,7 @@ static long media_device_enum_entities(struct media_device *mdev,
>  	u_ent.id = media_entity_id(ent);
>  	if (ent->name)
>  		strlcpy(u_ent.name, ent->name, sizeof(u_ent.name));
> -	u_ent.type = ent->type;
> +	u_ent.type = ent->function;
>  	u_ent.revision = ent->revision;
>  	u_ent.flags = ent->flags;
>  	u_ent.group_id = ent->group_id;
> @@ -614,8 +614,8 @@ int __must_check media_device_register_entity(struct media_device *mdev,
>  {
>  	int i;
>  
> -	if (entity->type == MEDIA_ENT_T_V4L2_SUBDEV_UNKNOWN ||
> -	    entity->type == MEDIA_ENT_T_UNKNOWN)
> +	if (entity->function == MEDIA_ENT_T_V4L2_SUBDEV_UNKNOWN ||
> +	    entity->function == MEDIA_ENT_T_UNKNOWN)
>  		dev_warn(mdev->dev,
>  			 "Entity type for entity %s was not initialized!\n",
>  			 entity->name);
> diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/platform/xilinx/xilinx-dma.c
> index 8e14841bf445..8bee7313a497 100644
> --- a/drivers/media/platform/xilinx/xilinx-dma.c
> +++ b/drivers/media/platform/xilinx/xilinx-dma.c
> @@ -191,7 +191,7 @@ static int xvip_pipeline_validate(struct xvip_pipeline *pipe,
>  	while ((entity = media_entity_graph_walk_next(&graph))) {
>  		struct xvip_dma *dma;
>  
> -		if (entity->type != MEDIA_ENT_T_V4L2_VIDEO)
> +		if (entity->function != MEDIA_ENT_T_V4L2_VIDEO)
>  			continue;
>  
>  		dma = to_xvip_dma(media_entity_to_video_device(entity));
> diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
> index 399c6712faf9..44a2ab3c85ab 100644
> --- a/drivers/media/usb/au0828/au0828-core.c
> +++ b/drivers/media/usb/au0828/au0828-core.c
> @@ -263,7 +263,7 @@ static int au0828_create_media_graph(struct au0828_dev *dev)
>  		return 0;
>  
>  	media_device_for_each_entity(entity, mdev) {
> -		switch (entity->type) {
> +		switch (entity->function) {
>  		case MEDIA_ENT_T_V4L2_SUBDEV_TUNER:
>  			tuner = entity;
>  			break;
> diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
> index 806b8d320bae..5c01f37cd0b8 100644
> --- a/drivers/media/usb/au0828/au0828-video.c
> +++ b/drivers/media/usb/au0828/au0828-video.c
> @@ -1830,18 +1830,18 @@ static void au0828_analog_create_entities(struct au0828_dev *dev)
>  
>  		switch(AUVI_INPUT(i).type) {
>  		case AU0828_VMUX_COMPOSITE:
> -			ent->type = MEDIA_ENT_T_CONN_COMPOSITE;
> +			ent->function = MEDIA_ENT_T_CONN_COMPOSITE;
>  			break;
>  		case AU0828_VMUX_SVIDEO:
> -			ent->type = MEDIA_ENT_T_CONN_SVIDEO;
> +			ent->function = MEDIA_ENT_T_CONN_SVIDEO;
>  			break;
>  		case AU0828_VMUX_CABLE:
>  		case AU0828_VMUX_TELEVISION:
>  		case AU0828_VMUX_DVB:
> -			ent->type = MEDIA_ENT_T_CONN_RF;
> +			ent->function = MEDIA_ENT_T_CONN_RF;
>  			break;
>  		default: /* AU0828_VMUX_DEBUG */
> -			ent->type = MEDIA_ENT_T_CONN_TEST;
> +			ent->function = MEDIA_ENT_T_CONN_TEST;
>  			break;
>  		}
>  
> diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
> index c05aaef85491..b01d6bce3cf6 100644
> --- a/drivers/media/usb/cx231xx/cx231xx-cards.c
> +++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
> @@ -1249,7 +1249,7 @@ static int cx231xx_create_media_graph(struct cx231xx *dev)
>  		return 0;
>  
>  	media_device_for_each_entity(entity, mdev) {
> -		switch (entity->type) {
> +		switch (entity->function) {
>  		case MEDIA_ENT_T_V4L2_SUBDEV_TUNER:
>  			tuner = entity;
>  			break;
> diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
> index e8baff4d6290..ed4a49c850c7 100644
> --- a/drivers/media/usb/cx231xx/cx231xx-video.c
> +++ b/drivers/media/usb/cx231xx/cx231xx-video.c
> @@ -119,7 +119,7 @@ static int cx231xx_enable_analog_tuner(struct cx231xx *dev)
>  	 * this should be enough for the actual needs.
>  	 */
>  	media_device_for_each_entity(entity, mdev) {
> -		if (entity->type == MEDIA_ENT_T_V4L2_SUBDEV_DECODER) {
> +		if (entity->function == MEDIA_ENT_T_V4L2_SUBDEV_DECODER) {
>  			decoder = entity;
>  			break;
>  		}
> diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
> index b90f2a52db96..e8fc5ec8fc35 100644
> --- a/drivers/media/v4l2-core/tuner-core.c
> +++ b/drivers/media/v4l2-core/tuner-core.c
> @@ -698,7 +698,7 @@ register_client:
>  #if defined(CONFIG_MEDIA_CONTROLLER)
>  	t->pad[TUNER_PAD_RF_INPUT].flags = MEDIA_PAD_FL_SINK;
>  	t->pad[TUNER_PAD_IF_OUTPUT].flags = MEDIA_PAD_FL_SOURCE;
> -	t->sd.entity.type = MEDIA_ENT_T_V4L2_SUBDEV_TUNER;
> +	t->sd.entity.function = MEDIA_ENT_T_V4L2_SUBDEV_TUNER;
>  	t->sd.entity.name = t->name;
>  
>  	ret = media_entity_init(&t->sd.entity, TUNER_NUM_PADS, &t->pad[0]);
> diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
> index 8429da66754a..2446b2d8fe66 100644
> --- a/drivers/media/v4l2-core/v4l2-dev.c
> +++ b/drivers/media/v4l2-core/v4l2-dev.c
> @@ -197,7 +197,7 @@ static void v4l2_device_release(struct device *cd)
>  	if (v4l2_dev->mdev) {
>  		/* Remove interfaces and interface links */
>  		media_devnode_remove(vdev->intf_devnode);
> -		if (vdev->entity.type != MEDIA_ENT_T_UNKNOWN)
> +		if (vdev->entity.function != MEDIA_ENT_T_UNKNOWN)
>  			media_device_unregister_entity(&vdev->entity);
>  	}
>  #endif
> @@ -726,20 +726,20 @@ static int video_register_media_controller(struct video_device *vdev, int type)
>  	if (!vdev->v4l2_dev->mdev)
>  		return 0;
>  
> -	vdev->entity.type = MEDIA_ENT_T_UNKNOWN;
> +	vdev->entity.function = MEDIA_ENT_T_UNKNOWN;
>  
>  	switch (type) {
>  	case VFL_TYPE_GRABBER:
>  		intf_type = MEDIA_INTF_T_V4L_VIDEO;
> -		vdev->entity.type = MEDIA_ENT_T_V4L2_VIDEO;
> +		vdev->entity.function = MEDIA_ENT_T_V4L2_VIDEO;
>  		break;
>  	case VFL_TYPE_VBI:
>  		intf_type = MEDIA_INTF_T_V4L_VBI;
> -		vdev->entity.type = MEDIA_ENT_T_V4L2_VBI;
> +		vdev->entity.function = MEDIA_ENT_T_V4L2_VBI;
>  		break;
>  	case VFL_TYPE_SDR:
>  		intf_type = MEDIA_INTF_T_V4L_SWRADIO;
> -		vdev->entity.type = MEDIA_ENT_T_V4L2_SWRADIO;
> +		vdev->entity.function = MEDIA_ENT_T_V4L2_SWRADIO;
>  		break;
>  	case VFL_TYPE_RADIO:
>  		intf_type = MEDIA_INTF_T_V4L_RADIO;
> @@ -757,7 +757,7 @@ static int video_register_media_controller(struct video_device *vdev, int type)
>  		return 0;
>  	}
>  
> -	if (vdev->entity.type != MEDIA_ENT_T_UNKNOWN) {
> +	if (vdev->entity.function != MEDIA_ENT_T_UNKNOWN) {
>  		vdev->entity.name = vdev->name;
>  
>  		/* Needed just for backward compatibility with legacy MC API */
> @@ -784,7 +784,7 @@ static int video_register_media_controller(struct video_device *vdev, int type)
>  		return -ENOMEM;
>  	}
>  
> -	if (vdev->entity.type != MEDIA_ENT_T_UNKNOWN) {
> +	if (vdev->entity.function != MEDIA_ENT_T_UNKNOWN) {
>  		struct media_link *link;
>  
>  		link = media_create_intf_link(&vdev->entity,
> diff --git a/drivers/media/v4l2-core/v4l2-flash-led-class.c b/drivers/media/v4l2-core/v4l2-flash-led-class.c
> index 34c489fed55e..cf7b3cb9a373 100644
> --- a/drivers/media/v4l2-core/v4l2-flash-led-class.c
> +++ b/drivers/media/v4l2-core/v4l2-flash-led-class.c
> @@ -655,7 +655,7 @@ struct v4l2_flash *v4l2_flash_init(
>  	if (ret < 0)
>  		return ERR_PTR(ret);
>  
> -	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_FLASH;
> +	sd->entity.function = MEDIA_ENT_T_V4L2_SUBDEV_FLASH;
>  
>  	ret = v4l2_flash_init_controls(v4l2_flash, config);
>  	if (ret < 0)
> diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
> index b3bcc8253182..b440cb66669c 100644
> --- a/drivers/media/v4l2-core/v4l2-subdev.c
> +++ b/drivers/media/v4l2-core/v4l2-subdev.c
> @@ -535,9 +535,9 @@ v4l2_subdev_link_validate_get_format(struct media_pad *pad,
>  		return v4l2_subdev_call(sd, pad, get_fmt, NULL, fmt);
>  	}
>  
> -	WARN(pad->entity->type != MEDIA_ENT_T_V4L2_VIDEO,
> +	WARN(pad->entity->function != MEDIA_ENT_T_V4L2_VIDEO,
>  	     "Driver bug! Wrong media entity type 0x%08x, entity %s\n",
> -	     pad->entity->type, pad->entity->name);
> +	     pad->entity->function, pad->entity->name);
>  
>  	return -EINVAL;
>  }
> @@ -584,7 +584,7 @@ void v4l2_subdev_init(struct v4l2_subdev *sd, const struct v4l2_subdev_ops *ops)
>  	sd->host_priv = NULL;
>  #if defined(CONFIG_MEDIA_CONTROLLER)
>  	sd->entity.name = sd->name;
> -	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_UNKNOWN;
> +	sd->entity.function = MEDIA_ENT_T_V4L2_SUBDEV_UNKNOWN;
>  #endif
>  }
>  EXPORT_SYMBOL(v4l2_subdev_init);
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index 8bdc10dcc5e7..10f7d5f0eb66 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -152,7 +152,8 @@ struct media_entity_operations {
>   *
>   * @graph_obj:	Embedded structure containing the media object common data.
>   * @name:	Entity name.
> - * @type:	Entity type, as defined at uapi/media.h (MEDIA_ENT_T_*)
> + * @function:	Entity main function, as defined at uapi/media.h
> + *		(MEDIA_ENT_F_*)
>   * @revision:	Entity revision - OBSOLETE - should be removed soon.
>   * @flags:	Entity flags, as defined at uapi/media.h (MEDIA_ENT_FL_*)
>   * @group_id:	Entity group ID - OBSOLETE - should be removed soon.
> @@ -179,7 +180,7 @@ struct media_entity_operations {
>  struct media_entity {
>  	struct media_gobj graph_obj;	/* must be first field in struct */
>  	const char *name;
> -	u32 type;
> +	u32 function;
>  	u32 revision;
>  	unsigned long flags;
>  	u32 group_id;
> @@ -277,7 +278,7 @@ static inline bool is_media_entity_v4l2_io(struct media_entity *entity)
>  	if (!entity)
>  		return false;
>  
> -	switch (entity->type) {
> +	switch (entity->function) {
>  	case MEDIA_ENT_T_V4L2_VIDEO:
>  	case MEDIA_ENT_T_V4L2_VBI:
>  	case MEDIA_ENT_T_V4L2_SWRADIO:
> @@ -292,7 +293,7 @@ static inline bool is_media_entity_v4l2_subdev(struct media_entity *entity)
>  	if (!entity)
>  		return false;
>  
> -	switch (entity->type) {
> +	switch (entity->function) {
>  	case MEDIA_ENT_T_V4L2_SUBDEV_SENSOR:
>  	case MEDIA_ENT_T_V4L2_SUBDEV_FLASH:
>  	case MEDIA_ENT_T_V4L2_SUBDEV_LENS:
> 

