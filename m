Return-path: <linux-media-owner@vger.kernel.org>
Received: from d1.icnet.pl ([212.160.220.21]:59786 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932535Ab1LERs7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Dec 2011 12:48:59 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] V4L: soc-camera: fix compiler warnings on 64-bit platforms
Date: Mon, 5 Dec 2011 18:48:13 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Stephen Rothwell <sfr@canb.auug.org.au>
References: <Pine.LNX.4.64.1112051542430.29177@axis700.grange> <201112051823.44446.jkrzyszt@tis.icnet.pl>
In-Reply-To: <201112051823.44446.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201112051848.13512.jkrzyszt@tis.icnet.pl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 05 of December 2011 at 18:23:44, Janusz Krzysztofik wrote:
> On Monday 05 of December 2011 at 16:15:28, Guennadi Liakhovetski wrote:
> > On 64-bit platforms assigning a pointer to a 32-bit variable causes a
> > compiler warning and cannot actually work. Soc-camera currently doesn't
> > support any 64-bit systems, but such platforms can be added in the
> > and in any case compiler warnings should be avoided.
> > 
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> > 
> > This is a long-standing warning in the 3.2 kernel. The fix should only 
> > affect sh-mobile platforms, of which I tested some, and the ov6650 camera 
> > sensor driver.
> > 
> >  drivers/media/video/ov6650.c               |    2 +-
> >  drivers/media/video/sh_mobile_ceu_camera.c |   34 +++++++++++++++++----------
> >  drivers/media/video/sh_mobile_csi2.c       |    4 +-
> >  drivers/media/video/soc_camera.c           |    2 +-
> >  include/media/soc_camera.h                 |    7 +++++-
> >  5 files changed, 31 insertions(+), 18 deletions(-)
> > 
> > diff --git a/drivers/media/video/ov6650.c b/drivers/media/video/ov6650.c
> > index 9f2d26b..6806345 100644
> > --- a/drivers/media/video/ov6650.c
> > +++ b/drivers/media/video/ov6650.c
> > @@ -540,7 +540,7 @@ static u8 to_clkrc(struct v4l2_fract *timeperframe,
> >  static int ov6650_s_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf)
> >  {
> >  	struct i2c_client *client = v4l2_get_subdevdata(sd);
> > -	struct soc_camera_device *icd = (struct soc_camera_device *)sd->grp_id;
> > +	struct soc_camera_device *icd = v4l2_get_subdev_hostdata(sd);
> 
> Hi Guennadi,
> Where is the v4l2_set_subdev_hostdata() supposed to be called from? I 
> can find it called only from drivers/media/video/s5p-fimc/fimc-mdevice.c 
> for now, and introduced with your patch into sh_mobile_ceu_camera.c 
> only. What about other soc_camera host interfaces? Are those supposed to 
> call v4l2_set_subdev_hostdata() themselves if a sensor is expected to be 
> calling v4l2_set_subdev_hostdata()? Perhaps the soc_camera framework 
               ^
             s/set/get/, sorry.

> should take care of this?
> 
> >  	struct soc_camera_sense *sense = icd->sense;
> 
> Don't we risk a NULL pointer dereference here in case 
> v4l2_set_subdev_hostdata() was not called?
> 
> Thanks,
> Janusz
> 
> >  	struct ov6650 *priv = to_ov6650(client);
> >  	bool half_scale = !is_unscaled_ok(mf->width, mf->height, &priv->rect);
> > diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
> > index f390682..c51decf 100644
> > --- a/drivers/media/video/sh_mobile_ceu_camera.c
> > +++ b/drivers/media/video/sh_mobile_ceu_camera.c
> > @@ -566,8 +566,10 @@ static int sh_mobile_ceu_add_device(struct soc_camera_device *icd)
> >  	ret = sh_mobile_ceu_soft_reset(pcdev);
> >  
> >  	csi2_sd = find_csi2(pcdev);
> > -	if (csi2_sd)
> > -		csi2_sd->grp_id = (long)icd;
> > +	if (csi2_sd) {
> > +		csi2_sd->grp_id = soc_camera_grp_id(icd);
> > +		v4l2_set_subdev_hostdata(csi2_sd, icd);
> > +	}
> >  
> >  	ret = v4l2_subdev_call(csi2_sd, core, s_power, 1);
> >  	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV) {
> > @@ -768,7 +770,7 @@ static struct v4l2_subdev *find_bus_subdev(struct sh_mobile_ceu_dev *pcdev,
> >  {
> >  	if (pcdev->csi2_pdev) {
> >  		struct v4l2_subdev *csi2_sd = find_csi2(pcdev);
> > -		if (csi2_sd && csi2_sd->grp_id == (u32)icd)
> > +		if (csi2_sd && csi2_sd->grp_id == soc_camera_grp_id(icd))
> >  			return csi2_sd;
> >  	}
> >  
> > @@ -1089,8 +1091,9 @@ static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, unsigned int
> >  			/* Try 2560x1920, 1280x960, 640x480, 320x240 */
> >  			mf.width	= 2560 >> shift;
> >  			mf.height	= 1920 >> shift;
> > -			ret = v4l2_device_call_until_err(sd->v4l2_dev, (long)icd, video,
> > -							 s_mbus_fmt, &mf);
> > +			ret = v4l2_device_call_until_err(sd->v4l2_dev,
> > +					soc_camera_grp_id(icd), video,
> > +					s_mbus_fmt, &mf);
> >  			if (ret < 0)
> >  				return ret;
> >  			shift++;
> > @@ -1389,7 +1392,8 @@ static int client_s_fmt(struct soc_camera_device *icd,
> >  	bool ceu_1to1;
> >  	int ret;
> >  
> > -	ret = v4l2_device_call_until_err(sd->v4l2_dev, (long)icd, video,
> > +	ret = v4l2_device_call_until_err(sd->v4l2_dev,
> > +					 soc_camera_grp_id(icd), video,
> >  					 s_mbus_fmt, mf);
> >  	if (ret < 0)
> >  		return ret;
> > @@ -1426,8 +1430,9 @@ static int client_s_fmt(struct soc_camera_device *icd,
> >  		tmp_h = min(2 * tmp_h, max_height);
> >  		mf->width = tmp_w;
> >  		mf->height = tmp_h;
> > -		ret = v4l2_device_call_until_err(sd->v4l2_dev, (long)icd, video,
> > -						 s_mbus_fmt, mf);
> > +		ret = v4l2_device_call_until_err(sd->v4l2_dev,
> > +					soc_camera_grp_id(icd), video,
> > +					s_mbus_fmt, mf);
> >  		dev_geo(dev, "Camera scaled to %ux%u\n",
> >  			mf->width, mf->height);
> >  		if (ret < 0) {
> > @@ -1580,8 +1585,9 @@ static int sh_mobile_ceu_set_crop(struct soc_camera_device *icd,
> >  	}
> >  
> >  	if (interm_width < icd->user_width || interm_height < icd->user_height) {
> > -		ret = v4l2_device_call_until_err(sd->v4l2_dev, (int)icd, video,
> > -						 s_mbus_fmt, &mf);
> > +		ret = v4l2_device_call_until_err(sd->v4l2_dev,
> > +					soc_camera_grp_id(icd), video,
> > +					s_mbus_fmt, &mf);
> >  		if (ret < 0)
> >  			return ret;
> >  
> > @@ -1867,7 +1873,8 @@ static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
> >  	mf.code		= xlate->code;
> >  	mf.colorspace	= pix->colorspace;
> >  
> > -	ret = v4l2_device_call_until_err(sd->v4l2_dev, (long)icd, video, try_mbus_fmt, &mf);
> > +	ret = v4l2_device_call_until_err(sd->v4l2_dev, soc_camera_grp_id(icd),
> > +					 video, try_mbus_fmt, &mf);
> >  	if (ret < 0)
> >  		return ret;
> >  
> > @@ -1891,8 +1898,9 @@ static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
> >  			 */
> >  			mf.width = 2560;
> >  			mf.height = 1920;
> > -			ret = v4l2_device_call_until_err(sd->v4l2_dev, (long)icd, video,
> > -							 try_mbus_fmt, &mf);
> > +			ret = v4l2_device_call_until_err(sd->v4l2_dev,
> > +					soc_camera_grp_id(icd), video,
> > +					try_mbus_fmt, &mf);
> >  			if (ret < 0) {
> >  				/* Shouldn't actually happen... */
> >  				dev_err(icd->parent,
> > diff --git a/drivers/media/video/sh_mobile_csi2.c b/drivers/media/video/sh_mobile_csi2.c
> > index ea4f047..8a652b5 100644
> > --- a/drivers/media/video/sh_mobile_csi2.c
> > +++ b/drivers/media/video/sh_mobile_csi2.c
> > @@ -143,7 +143,7 @@ static int sh_csi2_s_mbus_config(struct v4l2_subdev *sd,
> >  				 const struct v4l2_mbus_config *cfg)
> >  {
> >  	struct sh_csi2 *priv = container_of(sd, struct sh_csi2, subdev);
> > -	struct soc_camera_device *icd = (struct soc_camera_device *)sd->grp_id;
> > +	struct soc_camera_device *icd = v4l2_get_subdev_hostdata(sd);
> >  	struct v4l2_subdev *client_sd = soc_camera_to_subdev(icd);
> >  	struct v4l2_mbus_config client_cfg = {.type = V4L2_MBUS_CSI2,
> >  					      .flags = priv->mipi_flags};
> > @@ -202,7 +202,7 @@ static void sh_csi2_hwinit(struct sh_csi2 *priv)
> >  static int sh_csi2_client_connect(struct sh_csi2 *priv)
> >  {
> >  	struct sh_csi2_pdata *pdata = priv->pdev->dev.platform_data;
> > -	struct soc_camera_device *icd = (struct soc_camera_device *)priv->subdev.grp_id;
> > +	struct soc_camera_device *icd = v4l2_get_subdev_hostdata(&priv->subdev);
> >  	struct v4l2_subdev *client_sd = soc_camera_to_subdev(icd);
> >  	struct device *dev = v4l2_get_subdevdata(&priv->subdev);
> >  	struct v4l2_mbus_config cfg;
> > diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
> > index b72580c..8491cf7 100644
> > --- a/drivers/media/video/soc_camera.c
> > +++ b/drivers/media/video/soc_camera.c
> > @@ -1103,7 +1103,7 @@ static int soc_camera_probe(struct soc_camera_device *icd)
> >  	}
> >  
> >  	sd = soc_camera_to_subdev(icd);
> > -	sd->grp_id = (long)icd;
> > +	sd->grp_id = soc_camera_grp_id(icd);
> >  
> >  	if (v4l2_ctrl_add_handler(&icd->ctrl_handler, sd->ctrl_handler))
> >  		goto ectrl;
> > diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
> > index b1377b9..5fb2c3d 100644
> > --- a/include/media/soc_camera.h
> > +++ b/include/media/soc_camera.h
> > @@ -254,7 +254,7 @@ unsigned long soc_camera_apply_board_flags(struct soc_camera_link *icl,
> >  static inline struct video_device *soc_camera_i2c_to_vdev(const struct i2c_client *client)
> >  {
> >  	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> > -	struct soc_camera_device *icd = (struct soc_camera_device *)sd->grp_id;
> > +	struct soc_camera_device *icd = v4l2_get_subdev_hostdata(sd);
> >  	return icd ? icd->vdev : NULL;
> >  }
> >  
> > @@ -279,6 +279,11 @@ static inline struct soc_camera_device *soc_camera_from_vbq(const struct videobu
> >  	return container_of(vq, struct soc_camera_device, vb_vidq);
> >  }
> >  
> > +static inline u32 soc_camera_grp_id(const struct soc_camera_device *icd)
> > +{
> > +	return (icd->iface << 8) | (icd->devnum + 1);
> > +}
> > +
> >  void soc_camera_lock(struct vb2_queue *vq);
> >  void soc_camera_unlock(struct vb2_queue *vq);
> >  
> > 
> 
