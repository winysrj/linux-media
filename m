Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4471 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865Ab0HAMAY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Aug 2010 08:00:24 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 1/2] v4l: Use v4l2_get_subdevdata instead of accessing v4l2_subdev::priv
Date: Sun, 1 Aug 2010 14:00:16 +0200
Cc: linux-media@vger.kernel.org
References: <1280521495-19922-1-git-send-email-laurent.pinchart@ideasonboard.com> <1280521495-19922-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1280521495-19922-2-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201008011400.16235.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 30 July 2010 22:24:54 Laurent Pinchart wrote:
> Replace direct access to the v4l2_subdev priv field with the inline
> v4l2_get_subdevdata method.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Hans Verkuil <hverkuil@xs4all.nl>

> ---
>  drivers/media/video/mt9m001.c    |   26 +++++++++++++-------------
>  drivers/media/video/mt9m111.c    |   20 ++++++++++----------
>  drivers/media/video/mt9t031.c    |   24 ++++++++++++------------
>  drivers/media/video/mt9t112.c    |   14 +++++++-------
>  drivers/media/video/mt9v022.c    |   26 +++++++++++++-------------
>  drivers/media/video/ov772x.c     |   18 +++++++++---------
>  drivers/media/video/ov9640.c     |   12 ++++++------
>  drivers/media/video/rj54n1cb0c.c |   26 +++++++++++++-------------
>  drivers/media/video/soc_camera.c |    2 +-
>  drivers/media/video/tw9910.c     |   20 ++++++++++----------
>  10 files changed, 94 insertions(+), 94 deletions(-)
> 
> diff --git a/drivers/media/video/mt9m001.c b/drivers/media/video/mt9m001.c
> index 79f096d..fcb4cd9 100644
> --- a/drivers/media/video/mt9m001.c
> +++ b/drivers/media/video/mt9m001.c
> @@ -157,7 +157,7 @@ static int mt9m001_init(struct i2c_client *client)
>  
>  static int mt9m001_s_stream(struct v4l2_subdev *sd, int enable)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  
>  	/* Switch to master "normal" mode or stop sensor readout */
>  	if (reg_write(client, MT9M001_OUTPUT_CONTROL, enable ? 2 : 0) < 0)
> @@ -206,7 +206,7 @@ static unsigned long mt9m001_query_bus_param(struct soc_camera_device *icd)
>  
>  static int mt9m001_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct mt9m001 *mt9m001 = to_mt9m001(client);
>  	struct v4l2_rect rect = a->c;
>  	struct soc_camera_device *icd = client->dev.platform_data;
> @@ -271,7 +271,7 @@ static int mt9m001_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
>  
>  static int mt9m001_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct mt9m001 *mt9m001 = to_mt9m001(client);
>  
>  	a->c	= mt9m001->rect;
> @@ -297,7 +297,7 @@ static int mt9m001_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
>  static int mt9m001_g_fmt(struct v4l2_subdev *sd,
>  			 struct v4l2_mbus_framefmt *mf)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct mt9m001 *mt9m001 = to_mt9m001(client);
>  
>  	mf->width	= mt9m001->rect.width;
> @@ -312,7 +312,7 @@ static int mt9m001_g_fmt(struct v4l2_subdev *sd,
>  static int mt9m001_s_fmt(struct v4l2_subdev *sd,
>  			 struct v4l2_mbus_framefmt *mf)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct mt9m001 *mt9m001 = to_mt9m001(client);
>  	struct v4l2_crop a = {
>  		.c = {
> @@ -340,7 +340,7 @@ static int mt9m001_s_fmt(struct v4l2_subdev *sd,
>  static int mt9m001_try_fmt(struct v4l2_subdev *sd,
>  			   struct v4l2_mbus_framefmt *mf)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct mt9m001 *mt9m001 = to_mt9m001(client);
>  	const struct mt9m001_datafmt *fmt;
>  
> @@ -367,7 +367,7 @@ static int mt9m001_try_fmt(struct v4l2_subdev *sd,
>  static int mt9m001_g_chip_ident(struct v4l2_subdev *sd,
>  				struct v4l2_dbg_chip_ident *id)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct mt9m001 *mt9m001 = to_mt9m001(client);
>  
>  	if (id->match.type != V4L2_CHIP_MATCH_I2C_ADDR)
> @@ -386,7 +386,7 @@ static int mt9m001_g_chip_ident(struct v4l2_subdev *sd,
>  static int mt9m001_g_register(struct v4l2_subdev *sd,
>  			      struct v4l2_dbg_register *reg)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  
>  	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0xff)
>  		return -EINVAL;
> @@ -406,7 +406,7 @@ static int mt9m001_g_register(struct v4l2_subdev *sd,
>  static int mt9m001_s_register(struct v4l2_subdev *sd,
>  			      struct v4l2_dbg_register *reg)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  
>  	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0xff)
>  		return -EINVAL;
> @@ -468,7 +468,7 @@ static struct soc_camera_ops mt9m001_ops = {
>  
>  static int mt9m001_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct mt9m001 *mt9m001 = to_mt9m001(client);
>  	int data;
>  
> @@ -494,7 +494,7 @@ static int mt9m001_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
>  
>  static int mt9m001_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct mt9m001 *mt9m001 = to_mt9m001(client);
>  	struct soc_camera_device *icd = client->dev.platform_data;
>  	const struct v4l2_queryctrl *qctrl;
> @@ -683,7 +683,7 @@ static void mt9m001_video_remove(struct soc_camera_device *icd)
>  
>  static int mt9m001_g_skip_top_lines(struct v4l2_subdev *sd, u32 *lines)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct mt9m001 *mt9m001 = to_mt9m001(client);
>  
>  	*lines = mt9m001->y_skip_top;
> @@ -704,7 +704,7 @@ static struct v4l2_subdev_core_ops mt9m001_subdev_core_ops = {
>  static int mt9m001_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
>  			    enum v4l2_mbus_pixelcode *code)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct mt9m001 *mt9m001 = to_mt9m001(client);
>  
>  	if (index >= mt9m001->num_fmts)
> diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
> index fbd0fc7..a30fe35 100644
> --- a/drivers/media/video/mt9m111.c
> +++ b/drivers/media/video/mt9m111.c
> @@ -434,7 +434,7 @@ static int mt9m111_make_rect(struct i2c_client *client,
>  static int mt9m111_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
>  {
>  	struct v4l2_rect rect = a->c;
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct mt9m111 *mt9m111 = to_mt9m111(client);
>  	int ret;
>  
> @@ -449,7 +449,7 @@ static int mt9m111_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
>  
>  static int mt9m111_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct mt9m111 *mt9m111 = to_mt9m111(client);
>  
>  	a->c	= mt9m111->rect;
> @@ -475,7 +475,7 @@ static int mt9m111_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
>  static int mt9m111_g_fmt(struct v4l2_subdev *sd,
>  			 struct v4l2_mbus_framefmt *mf)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct mt9m111 *mt9m111 = to_mt9m111(client);
>  
>  	mf->width	= mt9m111->rect.width;
> @@ -537,7 +537,7 @@ static int mt9m111_set_pixfmt(struct i2c_client *client,
>  static int mt9m111_s_fmt(struct v4l2_subdev *sd,
>  			 struct v4l2_mbus_framefmt *mf)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	const struct mt9m111_datafmt *fmt;
>  	struct mt9m111 *mt9m111 = to_mt9m111(client);
>  	struct v4l2_rect rect = {
> @@ -572,7 +572,7 @@ static int mt9m111_s_fmt(struct v4l2_subdev *sd,
>  static int mt9m111_try_fmt(struct v4l2_subdev *sd,
>  			   struct v4l2_mbus_framefmt *mf)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct mt9m111 *mt9m111 = to_mt9m111(client);
>  	const struct mt9m111_datafmt *fmt;
>  	bool bayer = mf->code == V4L2_MBUS_FMT_SBGGR8_1X8 ||
> @@ -612,7 +612,7 @@ static int mt9m111_try_fmt(struct v4l2_subdev *sd,
>  static int mt9m111_g_chip_ident(struct v4l2_subdev *sd,
>  				struct v4l2_dbg_chip_ident *id)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct mt9m111 *mt9m111 = to_mt9m111(client);
>  
>  	if (id->match.type != V4L2_CHIP_MATCH_I2C_ADDR)
> @@ -631,7 +631,7 @@ static int mt9m111_g_chip_ident(struct v4l2_subdev *sd,
>  static int mt9m111_g_register(struct v4l2_subdev *sd,
>  			      struct v4l2_dbg_register *reg)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	int val;
>  
>  	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0x2ff)
> @@ -652,7 +652,7 @@ static int mt9m111_g_register(struct v4l2_subdev *sd,
>  static int mt9m111_s_register(struct v4l2_subdev *sd,
>  			      struct v4l2_dbg_register *reg)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  
>  	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0x2ff)
>  		return -EINVAL;
> @@ -800,7 +800,7 @@ static int mt9m111_set_autowhitebalance(struct i2c_client *client, int on)
>  
>  static int mt9m111_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct mt9m111 *mt9m111 = to_mt9m111(client);
>  	int data;
>  
> @@ -843,7 +843,7 @@ static int mt9m111_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
>  
>  static int mt9m111_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct mt9m111 *mt9m111 = to_mt9m111(client);
>  	const struct v4l2_queryctrl *qctrl;
>  	int ret;
> diff --git a/drivers/media/video/mt9t031.c b/drivers/media/video/mt9t031.c
> index a9a28b2..9bd44a8 100644
> --- a/drivers/media/video/mt9t031.c
> +++ b/drivers/media/video/mt9t031.c
> @@ -163,7 +163,7 @@ static int mt9t031_disable(struct i2c_client *client)
>  
>  static int mt9t031_s_stream(struct v4l2_subdev *sd, int enable)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	int ret;
>  
>  	if (enable)
> @@ -393,7 +393,7 @@ static int mt9t031_set_params(struct i2c_client *client,
>  static int mt9t031_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
>  {
>  	struct v4l2_rect rect = a->c;
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct mt9t031 *mt9t031 = to_mt9t031(client);
>  
>  	rect.width = ALIGN(rect.width, 2);
> @@ -410,7 +410,7 @@ static int mt9t031_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
>  
>  static int mt9t031_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct mt9t031 *mt9t031 = to_mt9t031(client);
>  
>  	a->c	= mt9t031->rect;
> @@ -436,7 +436,7 @@ static int mt9t031_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
>  static int mt9t031_g_fmt(struct v4l2_subdev *sd,
>  			 struct v4l2_mbus_framefmt *mf)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct mt9t031 *mt9t031 = to_mt9t031(client);
>  
>  	mf->width	= mt9t031->rect.width / mt9t031->xskip;
> @@ -451,7 +451,7 @@ static int mt9t031_g_fmt(struct v4l2_subdev *sd,
>  static int mt9t031_s_fmt(struct v4l2_subdev *sd,
>  			 struct v4l2_mbus_framefmt *mf)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct mt9t031 *mt9t031 = to_mt9t031(client);
>  	u16 xskip, yskip;
>  	struct v4l2_rect rect = mt9t031->rect;
> @@ -490,7 +490,7 @@ static int mt9t031_try_fmt(struct v4l2_subdev *sd,
>  static int mt9t031_g_chip_ident(struct v4l2_subdev *sd,
>  				struct v4l2_dbg_chip_ident *id)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct mt9t031 *mt9t031 = to_mt9t031(client);
>  
>  	if (id->match.type != V4L2_CHIP_MATCH_I2C_ADDR)
> @@ -509,7 +509,7 @@ static int mt9t031_g_chip_ident(struct v4l2_subdev *sd,
>  static int mt9t031_g_register(struct v4l2_subdev *sd,
>  			      struct v4l2_dbg_register *reg)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  
>  	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0xff)
>  		return -EINVAL;
> @@ -528,7 +528,7 @@ static int mt9t031_g_register(struct v4l2_subdev *sd,
>  static int mt9t031_s_register(struct v4l2_subdev *sd,
>  			      struct v4l2_dbg_register *reg)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  
>  	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0xff)
>  		return -EINVAL;
> @@ -545,7 +545,7 @@ static int mt9t031_s_register(struct v4l2_subdev *sd,
>  
>  static int mt9t031_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct mt9t031 *mt9t031 = to_mt9t031(client);
>  	int data;
>  
> @@ -577,7 +577,7 @@ static int mt9t031_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
>  
>  static int mt9t031_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct mt9t031 *mt9t031 = to_mt9t031(client);
>  	const struct v4l2_queryctrl *qctrl;
>  	int data;
> @@ -703,7 +703,7 @@ static int mt9t031_runtime_resume(struct device *dev)
>  	struct soc_camera_device *icd = container_of(vdev->parent,
>  		struct soc_camera_device, dev);
>  	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct mt9t031 *mt9t031 = to_mt9t031(client);
>  
>  	int ret;
> @@ -780,7 +780,7 @@ static int mt9t031_video_probe(struct i2c_client *client)
>  
>  static int mt9t031_g_skip_top_lines(struct v4l2_subdev *sd, u32 *lines)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct mt9t031 *mt9t031 = to_mt9t031(client);
>  
>  	*lines = mt9t031->y_skip_top;
> diff --git a/drivers/media/video/mt9t112.c b/drivers/media/video/mt9t112.c
> index e4bf1db..74d8dd4 100644
> --- a/drivers/media/video/mt9t112.c
> +++ b/drivers/media/video/mt9t112.c
> @@ -804,7 +804,7 @@ static struct soc_camera_ops mt9t112_ops = {
>  static int mt9t112_g_chip_ident(struct v4l2_subdev *sd,
>  				struct v4l2_dbg_chip_ident *id)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct mt9t112_priv *priv = to_mt9t112(client);
>  
>  	id->ident    = priv->model;
> @@ -817,7 +817,7 @@ static int mt9t112_g_chip_ident(struct v4l2_subdev *sd,
>  static int mt9t112_g_register(struct v4l2_subdev *sd,
>  			      struct v4l2_dbg_register *reg)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	int                ret;
>  
>  	reg->size = 2;
> @@ -831,7 +831,7 @@ static int mt9t112_g_register(struct v4l2_subdev *sd,
>  static int mt9t112_s_register(struct v4l2_subdev *sd,
>  			      struct v4l2_dbg_register *reg)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	int ret;
>  
>  	mt9t112_reg_write(ret, client, reg->reg, reg->val);
> @@ -858,7 +858,7 @@ static struct v4l2_subdev_core_ops mt9t112_subdev_core_ops = {
>  ************************************************************************/
>  static int mt9t112_s_stream(struct v4l2_subdev *sd, int enable)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct mt9t112_priv *priv = to_mt9t112(client);
>  	int ret = 0;
>  
> @@ -968,7 +968,7 @@ static int mt9t112_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
>  
>  static int mt9t112_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct v4l2_rect *rect = &a->c;
>  
>  	return mt9t112_set_params(client, rect->width, rect->height,
> @@ -978,7 +978,7 @@ static int mt9t112_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
>  static int mt9t112_g_fmt(struct v4l2_subdev *sd,
>  			 struct v4l2_mbus_framefmt *mf)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct mt9t112_priv *priv = to_mt9t112(client);
>  
>  	if (!priv->format) {
> @@ -1000,7 +1000,7 @@ static int mt9t112_g_fmt(struct v4l2_subdev *sd,
>  static int mt9t112_s_fmt(struct v4l2_subdev *sd,
>  			 struct v4l2_mbus_framefmt *mf)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  
>  	/* TODO: set colorspace */
>  	return mt9t112_set_params(client, mf->width, mf->height, mf->code);
> diff --git a/drivers/media/video/mt9v022.c b/drivers/media/video/mt9v022.c
> index e7cd23c..1a02f67 100644
> --- a/drivers/media/video/mt9v022.c
> +++ b/drivers/media/video/mt9v022.c
> @@ -184,7 +184,7 @@ static int mt9v022_init(struct i2c_client *client)
>  
>  static int mt9v022_s_stream(struct v4l2_subdev *sd, int enable)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct mt9v022 *mt9v022 = to_mt9v022(client);
>  
>  	if (enable)
> @@ -273,7 +273,7 @@ static unsigned long mt9v022_query_bus_param(struct soc_camera_device *icd)
>  
>  static int mt9v022_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct mt9v022 *mt9v022 = to_mt9v022(client);
>  	struct v4l2_rect rect = a->c;
>  	int ret;
> @@ -334,7 +334,7 @@ static int mt9v022_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
>  
>  static int mt9v022_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct mt9v022 *mt9v022 = to_mt9v022(client);
>  
>  	a->c	= mt9v022->rect;
> @@ -360,7 +360,7 @@ static int mt9v022_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
>  static int mt9v022_g_fmt(struct v4l2_subdev *sd,
>  			 struct v4l2_mbus_framefmt *mf)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct mt9v022 *mt9v022 = to_mt9v022(client);
>  
>  	mf->width	= mt9v022->rect.width;
> @@ -375,7 +375,7 @@ static int mt9v022_g_fmt(struct v4l2_subdev *sd,
>  static int mt9v022_s_fmt(struct v4l2_subdev *sd,
>  			 struct v4l2_mbus_framefmt *mf)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct mt9v022 *mt9v022 = to_mt9v022(client);
>  	struct v4l2_crop a = {
>  		.c = {
> @@ -425,7 +425,7 @@ static int mt9v022_s_fmt(struct v4l2_subdev *sd,
>  static int mt9v022_try_fmt(struct v4l2_subdev *sd,
>  			   struct v4l2_mbus_framefmt *mf)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct mt9v022 *mt9v022 = to_mt9v022(client);
>  	const struct mt9v022_datafmt *fmt;
>  	int align = mf->code == V4L2_MBUS_FMT_SBGGR8_1X8 ||
> @@ -451,7 +451,7 @@ static int mt9v022_try_fmt(struct v4l2_subdev *sd,
>  static int mt9v022_g_chip_ident(struct v4l2_subdev *sd,
>  				struct v4l2_dbg_chip_ident *id)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct mt9v022 *mt9v022 = to_mt9v022(client);
>  
>  	if (id->match.type != V4L2_CHIP_MATCH_I2C_ADDR)
> @@ -470,7 +470,7 @@ static int mt9v022_g_chip_ident(struct v4l2_subdev *sd,
>  static int mt9v022_g_register(struct v4l2_subdev *sd,
>  			      struct v4l2_dbg_register *reg)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  
>  	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0xff)
>  		return -EINVAL;
> @@ -490,7 +490,7 @@ static int mt9v022_g_register(struct v4l2_subdev *sd,
>  static int mt9v022_s_register(struct v4l2_subdev *sd,
>  			      struct v4l2_dbg_register *reg)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  
>  	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0xff)
>  		return -EINVAL;
> @@ -568,7 +568,7 @@ static struct soc_camera_ops mt9v022_ops = {
>  
>  static int mt9v022_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	const struct v4l2_queryctrl *qctrl;
>  	unsigned long range;
>  	int data;
> @@ -625,7 +625,7 @@ static int mt9v022_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
>  static int mt9v022_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
>  {
>  	int data;
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	const struct v4l2_queryctrl *qctrl;
>  
>  	qctrl = soc_camera_find_qctrl(&mt9v022_ops, ctrl->id);
> @@ -820,7 +820,7 @@ static void mt9v022_video_remove(struct soc_camera_device *icd)
>  
>  static int mt9v022_g_skip_top_lines(struct v4l2_subdev *sd, u32 *lines)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct mt9v022 *mt9v022 = to_mt9v022(client);
>  
>  	*lines = mt9v022->y_skip_top;
> @@ -841,7 +841,7 @@ static struct v4l2_subdev_core_ops mt9v022_subdev_core_ops = {
>  static int mt9v022_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
>  			    enum v4l2_mbus_pixelcode *code)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct mt9v022 *mt9v022 = to_mt9v022(client);
>  
>  	if (index >= mt9v022->num_fmts)
> diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
> index 34034a7..4330c1f 100644
> --- a/drivers/media/video/ov772x.c
> +++ b/drivers/media/video/ov772x.c
> @@ -599,7 +599,7 @@ static int ov772x_reset(struct i2c_client *client)
>  
>  static int ov772x_s_stream(struct v4l2_subdev *sd, int enable)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct ov772x_priv *priv = to_ov772x(client);
>  
>  	if (!enable) {
> @@ -645,7 +645,7 @@ static unsigned long ov772x_query_bus_param(struct soc_camera_device *icd)
>  
>  static int ov772x_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct ov772x_priv *priv = to_ov772x(client);
>  
>  	switch (ctrl->id) {
> @@ -664,7 +664,7 @@ static int ov772x_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
>  
>  static int ov772x_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct ov772x_priv *priv = to_ov772x(client);
>  	int ret = 0;
>  	u8 val;
> @@ -715,7 +715,7 @@ static int ov772x_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
>  static int ov772x_g_chip_ident(struct v4l2_subdev *sd,
>  			       struct v4l2_dbg_chip_ident *id)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct ov772x_priv *priv = to_ov772x(client);
>  
>  	id->ident    = priv->model;
> @@ -728,7 +728,7 @@ static int ov772x_g_chip_ident(struct v4l2_subdev *sd,
>  static int ov772x_g_register(struct v4l2_subdev *sd,
>  			     struct v4l2_dbg_register *reg)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	int ret;
>  
>  	reg->size = 1;
> @@ -747,7 +747,7 @@ static int ov772x_g_register(struct v4l2_subdev *sd,
>  static int ov772x_s_register(struct v4l2_subdev *sd,
>  			     struct v4l2_dbg_register *reg)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  
>  	if (reg->reg > 0xff ||
>  	    reg->val > 0xff)
> @@ -954,7 +954,7 @@ static int ov772x_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
>  static int ov772x_g_fmt(struct v4l2_subdev *sd,
>  			struct v4l2_mbus_framefmt *mf)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct ov772x_priv *priv = to_ov772x(client);
>  
>  	if (!priv->win || !priv->cfmt) {
> @@ -977,7 +977,7 @@ static int ov772x_g_fmt(struct v4l2_subdev *sd,
>  static int ov772x_s_fmt(struct v4l2_subdev *sd,
>  			struct v4l2_mbus_framefmt *mf)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct ov772x_priv *priv = to_ov772x(client);
>  	int ret = ov772x_set_params(client, &mf->width, &mf->height,
>  				    mf->code);
> @@ -991,7 +991,7 @@ static int ov772x_s_fmt(struct v4l2_subdev *sd,
>  static int ov772x_try_fmt(struct v4l2_subdev *sd,
>  			  struct v4l2_mbus_framefmt *mf)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct ov772x_priv *priv = to_ov772x(client);
>  	const struct ov772x_win_size *win;
>  	int i;
> diff --git a/drivers/media/video/ov9640.c b/drivers/media/video/ov9640.c
> index 7ce9e05..faa71f3 100644
> --- a/drivers/media/video/ov9640.c
> +++ b/drivers/media/video/ov9640.c
> @@ -308,7 +308,7 @@ static unsigned long ov9640_query_bus_param(struct soc_camera_device *icd)
>  /* Get status of additional camera capabilities */
>  static int ov9640_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct ov9640_priv *priv = container_of(i2c_get_clientdata(client),
>  					struct ov9640_priv, subdev);
>  
> @@ -326,7 +326,7 @@ static int ov9640_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
>  /* Set status of additional camera capabilities */
>  static int ov9640_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct ov9640_priv *priv = container_of(i2c_get_clientdata(client),
>  					struct ov9640_priv, subdev);
>  
> @@ -360,7 +360,7 @@ static int ov9640_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
>  static int ov9640_g_chip_ident(struct v4l2_subdev *sd,
>  				struct v4l2_dbg_chip_ident *id)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct ov9640_priv *priv = container_of(i2c_get_clientdata(client),
>  					struct ov9640_priv, subdev);
>  
> @@ -374,7 +374,7 @@ static int ov9640_g_chip_ident(struct v4l2_subdev *sd,
>  static int ov9640_get_register(struct v4l2_subdev *sd,
>  				struct v4l2_dbg_register *reg)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	int ret;
>  	u8 val;
>  
> @@ -395,7 +395,7 @@ static int ov9640_get_register(struct v4l2_subdev *sd,
>  static int ov9640_set_register(struct v4l2_subdev *sd,
>  				struct v4l2_dbg_register *reg)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  
>  	if (reg->reg & ~0xff || reg->val & ~0xff)
>  		return -EINVAL;
> @@ -558,7 +558,7 @@ static int ov9640_prog_dflt(struct i2c_client *client)
>  static int ov9640_s_fmt(struct v4l2_subdev *sd,
>  			struct v4l2_mbus_framefmt *mf)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct ov9640_reg_alt alts = {0};
>  	enum v4l2_colorspace cspace;
>  	enum v4l2_mbus_pixelcode code = mf->code;
> diff --git a/drivers/media/video/rj54n1cb0c.c b/drivers/media/video/rj54n1cb0c.c
> index 47fd207..a626a2a 100644
> --- a/drivers/media/video/rj54n1cb0c.c
> +++ b/drivers/media/video/rj54n1cb0c.c
> @@ -493,7 +493,7 @@ static int rj54n1_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
>  
>  static int rj54n1_s_stream(struct v4l2_subdev *sd, int enable)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  
>  	/* Switch between preview and still shot modes */
>  	return reg_set(client, RJ54N1_STILL_CONTROL, (!enable) << 7, 0x80);
> @@ -503,7 +503,7 @@ static int rj54n1_set_bus_param(struct soc_camera_device *icd,
>  				unsigned long flags)
>  {
>  	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	/* Figures 2.5-1 to 2.5-3 - default falling pixclk edge */
>  
>  	if (flags & SOCAM_PCLK_SAMPLE_RISING)
> @@ -560,7 +560,7 @@ static int rj54n1_sensor_scale(struct v4l2_subdev *sd, s32 *in_w, s32 *in_h,
>  
>  static int rj54n1_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct rj54n1 *rj54n1 = to_rj54n1(client);
>  	struct v4l2_rect *rect = &a->c;
>  	int dummy = 0, output_w, output_h,
> @@ -595,7 +595,7 @@ static int rj54n1_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
>  
>  static int rj54n1_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct rj54n1 *rj54n1 = to_rj54n1(client);
>  
>  	a->c	= rj54n1->rect;
> @@ -621,7 +621,7 @@ static int rj54n1_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
>  static int rj54n1_g_fmt(struct v4l2_subdev *sd,
>  			struct v4l2_mbus_framefmt *mf)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct rj54n1 *rj54n1 = to_rj54n1(client);
>  
>  	mf->code	= rj54n1->fmt->code;
> @@ -641,7 +641,7 @@ static int rj54n1_g_fmt(struct v4l2_subdev *sd,
>  static int rj54n1_sensor_scale(struct v4l2_subdev *sd, s32 *in_w, s32 *in_h,
>  			       s32 *out_w, s32 *out_h)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct rj54n1 *rj54n1 = to_rj54n1(client);
>  	unsigned int skip, resize, input_w = *in_w, input_h = *in_h,
>  		output_w = *out_w, output_h = *out_h;
> @@ -983,7 +983,7 @@ static int rj54n1_reg_init(struct i2c_client *client)
>  static int rj54n1_try_fmt(struct v4l2_subdev *sd,
>  			  struct v4l2_mbus_framefmt *mf)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct rj54n1 *rj54n1 = to_rj54n1(client);
>  	const struct rj54n1_datafmt *fmt;
>  	int align = mf->code == V4L2_MBUS_FMT_SBGGR10_1X10 ||
> @@ -1014,7 +1014,7 @@ static int rj54n1_try_fmt(struct v4l2_subdev *sd,
>  static int rj54n1_s_fmt(struct v4l2_subdev *sd,
>  			struct v4l2_mbus_framefmt *mf)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct rj54n1 *rj54n1 = to_rj54n1(client);
>  	const struct rj54n1_datafmt *fmt;
>  	int output_w, output_h, max_w, max_h,
> @@ -1145,7 +1145,7 @@ static int rj54n1_s_fmt(struct v4l2_subdev *sd,
>  static int rj54n1_g_chip_ident(struct v4l2_subdev *sd,
>  			       struct v4l2_dbg_chip_ident *id)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  
>  	if (id->match.type != V4L2_CHIP_MATCH_I2C_ADDR)
>  		return -EINVAL;
> @@ -1163,7 +1163,7 @@ static int rj54n1_g_chip_ident(struct v4l2_subdev *sd,
>  static int rj54n1_g_register(struct v4l2_subdev *sd,
>  			     struct v4l2_dbg_register *reg)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  
>  	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR ||
>  	    reg->reg < 0x400 || reg->reg > 0x1fff)
> @@ -1185,7 +1185,7 @@ static int rj54n1_g_register(struct v4l2_subdev *sd,
>  static int rj54n1_s_register(struct v4l2_subdev *sd,
>  			     struct v4l2_dbg_register *reg)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  
>  	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR ||
>  	    reg->reg < 0x400 || reg->reg > 0x1fff)
> @@ -1248,7 +1248,7 @@ static struct soc_camera_ops rj54n1_ops = {
>  
>  static int rj54n1_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct rj54n1 *rj54n1 = to_rj54n1(client);
>  	int data;
>  
> @@ -1283,7 +1283,7 @@ static int rj54n1_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
>  static int rj54n1_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
>  {
>  	int data;
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct rj54n1 *rj54n1 = to_rj54n1(client);
>  	const struct v4l2_queryctrl *qctrl;
>  
> diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
> index 475757b..3bbd9cd 100644
> --- a/drivers/media/video/soc_camera.c
> +++ b/drivers/media/video/soc_camera.c
> @@ -899,7 +899,7 @@ static int soc_camera_init_i2c(struct soc_camera_device *icd,
>  	if (!subdev)
>  		goto ei2cnd;
>  
> -	client = subdev->priv;
> +	client = v4l2_get_subdevdata(subdev);
>  
>  	/* Use to_i2c_client(dev) to recover the i2c client */
>  	dev_set_drvdata(&icd->dev, &client->dev);
> diff --git a/drivers/media/video/tw9910.c b/drivers/media/video/tw9910.c
> index 445dc93..d5e4949 100644
> --- a/drivers/media/video/tw9910.c
> +++ b/drivers/media/video/tw9910.c
> @@ -469,7 +469,7 @@ tw9910_select_norm(struct soc_camera_device *icd, u32 width, u32 height)
>   */
>  static int tw9910_s_stream(struct v4l2_subdev *sd, int enable)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct tw9910_priv *priv = to_tw9910(client);
>  	u8 val;
>  	int ret;
> @@ -511,7 +511,7 @@ static int tw9910_set_bus_param(struct soc_camera_device *icd,
>  				unsigned long flags)
>  {
>  	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	u8 val = VSSL_VVALID | HSSL_DVALID;
>  
>  	/*
> @@ -565,7 +565,7 @@ static int tw9910_enum_input(struct soc_camera_device *icd,
>  static int tw9910_g_chip_ident(struct v4l2_subdev *sd,
>  			       struct v4l2_dbg_chip_ident *id)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct tw9910_priv *priv = to_tw9910(client);
>  
>  	id->ident = V4L2_IDENT_TW9910;
> @@ -578,7 +578,7 @@ static int tw9910_g_chip_ident(struct v4l2_subdev *sd,
>  static int tw9910_g_register(struct v4l2_subdev *sd,
>  			     struct v4l2_dbg_register *reg)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	int ret;
>  
>  	if (reg->reg > 0xff)
> @@ -600,7 +600,7 @@ static int tw9910_g_register(struct v4l2_subdev *sd,
>  static int tw9910_s_register(struct v4l2_subdev *sd,
>  			     struct v4l2_dbg_register *reg)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  
>  	if (reg->reg > 0xff ||
>  	    reg->val > 0xff)
> @@ -613,7 +613,7 @@ static int tw9910_s_register(struct v4l2_subdev *sd,
>  static int tw9910_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
>  {
>  	struct v4l2_rect *rect = &a->c;
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct tw9910_priv *priv = to_tw9910(client);
>  	struct soc_camera_device *icd = client->dev.platform_data;
>  	int                 ret  = -EINVAL;
> @@ -701,7 +701,7 @@ tw9910_set_fmt_error:
>  
>  static int tw9910_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct tw9910_priv *priv = to_tw9910(client);
>  
>  	if (!priv->scale) {
> @@ -748,7 +748,7 @@ static int tw9910_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
>  static int tw9910_g_fmt(struct v4l2_subdev *sd,
>  			struct v4l2_mbus_framefmt *mf)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct tw9910_priv *priv = to_tw9910(client);
>  
>  	if (!priv->scale) {
> @@ -778,7 +778,7 @@ static int tw9910_g_fmt(struct v4l2_subdev *sd,
>  static int tw9910_s_fmt(struct v4l2_subdev *sd,
>  			struct v4l2_mbus_framefmt *mf)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct tw9910_priv *priv = to_tw9910(client);
>  	/* See tw9910_s_crop() - no proper cropping support */
>  	struct v4l2_crop a = {
> @@ -813,7 +813,7 @@ static int tw9910_s_fmt(struct v4l2_subdev *sd,
>  static int tw9910_try_fmt(struct v4l2_subdev *sd,
>  			  struct v4l2_mbus_framefmt *mf)
>  {
> -	struct i2c_client *client = sd->priv;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct soc_camera_device *icd = client->dev.platform_data;
>  	const struct tw9910_scale_ctrl *scale;
>  
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
