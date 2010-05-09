Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:56581 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751100Ab0EIUsN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 May 2010 16:48:13 -0400
Date: Sun, 9 May 2010 22:48:07 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: RFC PATCH: v4l2-subdev.h: fix enum_mbus_fmt prototype
In-Reply-To: <201005091541.25521.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1005092245580.15250@axis700.grange>
References: <201005091541.25521.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 9 May 2010, Hans Verkuil wrote:

> Hi Guennadi,
> 
> Can you review this patch?
> 
> It's a simple and sensible change, but I also had to make a similar change
> in soc-camera so I'd like to you to take a look as well.

No problem in general with this patch, just I would use "unsigned int" 
everywhere, even if only for consistency - search for "unsigned" in all 
affected files. Otherwise

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks
Guennadi

> 
> Regards,
> 
> 	Hans
> 
> enum_mbus_fmt received an index argument that was defined as an int instead
> of an unsigned int. This is now fixed. This had the knock-on effect that the
> index argument in the callback get_formats in soc_camera.h also had to be
> changed to unsigned.
> 
> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>  drivers/media/video/ak881x.c               |    2 +-
>  drivers/media/video/mt9m001.c              |    4 ++--
>  drivers/media/video/mt9m111.c              |    4 ++--
>  drivers/media/video/mt9t031.c              |    2 +-
>  drivers/media/video/mt9t112.c              |    4 ++--
>  drivers/media/video/mt9v022.c              |    4 ++--
>  drivers/media/video/mx3_camera.c           |    4 ++--
>  drivers/media/video/ov772x.c               |    4 ++--
>  drivers/media/video/ov9640.c               |    4 ++--
>  drivers/media/video/pxa_camera.c           |    4 ++--
>  drivers/media/video/rj54n1cb0c.c           |    4 ++--
>  drivers/media/video/sh_mobile_ceu_camera.c |    4 ++--
>  drivers/media/video/soc_camera.c           |    3 ++-
>  drivers/media/video/soc_camera_platform.c  |    2 +-
>  drivers/media/video/tw9910.c               |    2 +-
>  include/media/soc_camera.h                 |    2 +-
>  include/media/v4l2-subdev.h                |    2 +-
>  18 files changed, 48 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/media/video/ak881x.c b/drivers/media/video/ak881x.c
> index 35390d4..f2e71d1 100644
> --- a/drivers/media/video/ak881x.c
> +++ b/drivers/media/video/ak881x.c
> @@ -141,7 +141,7 @@ static int ak881x_s_mbus_fmt(struct v4l2_subdev *sd,
>  	return ak881x_try_g_mbus_fmt(sd, mf);
>  }
>  
> -static int ak881x_enum_mbus_fmt(struct v4l2_subdev *sd, int index,
> +static int ak881x_enum_mbus_fmt(struct v4l2_subdev *sd, unsigned index,
>  				enum v4l2_mbus_pixelcode *code)
>  {
>  	if (index)
> diff --git a/drivers/media/video/mt9m001.c b/drivers/media/video/mt9m001.c
> index b62c0bd..c55d766 100644
> --- a/drivers/media/video/mt9m001.c
> +++ b/drivers/media/video/mt9m001.c
> @@ -701,13 +701,13 @@ static struct v4l2_subdev_core_ops mt9m001_subdev_core_ops = {
>  #endif
>  };
>  
> -static int mt9m001_enum_fmt(struct v4l2_subdev *sd, int index,
> +static int mt9m001_enum_fmt(struct v4l2_subdev *sd, unsigned index,
>  			    enum v4l2_mbus_pixelcode *code)
>  {
>  	struct i2c_client *client = sd->priv;
>  	struct mt9m001 *mt9m001 = to_mt9m001(client);
>  
> -	if ((unsigned int)index >= mt9m001->num_fmts)
> +	if (index >= mt9m001->num_fmts)
>  		return -EINVAL;
>  
>  	*code = mt9m001->fmts[index].code;
> diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
> index d35f536..78dbb5d 100644
> --- a/drivers/media/video/mt9m111.c
> +++ b/drivers/media/video/mt9m111.c
> @@ -999,10 +999,10 @@ static struct v4l2_subdev_core_ops mt9m111_subdev_core_ops = {
>  #endif
>  };
>  
> -static int mt9m111_enum_fmt(struct v4l2_subdev *sd, int index,
> +static int mt9m111_enum_fmt(struct v4l2_subdev *sd, unsigned index,
>  			    enum v4l2_mbus_pixelcode *code)
>  {
> -	if ((unsigned int)index >= ARRAY_SIZE(mt9m111_colour_fmts))
> +	if (index >= ARRAY_SIZE(mt9m111_colour_fmts))
>  		return -EINVAL;
>  
>  	*code = mt9m111_colour_fmts[index].code;
> diff --git a/drivers/media/video/mt9t031.c b/drivers/media/video/mt9t031.c
> index 78b4e09..c1d12a0 100644
> --- a/drivers/media/video/mt9t031.c
> +++ b/drivers/media/video/mt9t031.c
> @@ -798,7 +798,7 @@ static struct v4l2_subdev_core_ops mt9t031_subdev_core_ops = {
>  #endif
>  };
>  
> -static int mt9t031_enum_fmt(struct v4l2_subdev *sd, int index,
> +static int mt9t031_enum_fmt(struct v4l2_subdev *sd, unsigned index,
>  			    enum v4l2_mbus_pixelcode *code)
>  {
>  	if (index)
> diff --git a/drivers/media/video/mt9t112.c b/drivers/media/video/mt9t112.c
> index 7438f8d..802312e 100644
> --- a/drivers/media/video/mt9t112.c
> +++ b/drivers/media/video/mt9t112.c
> @@ -1017,10 +1017,10 @@ static int mt9t112_try_fmt(struct v4l2_subdev *sd,
>  	return 0;
>  }
>  
> -static int mt9t112_enum_fmt(struct v4l2_subdev *sd, int index,
> +static int mt9t112_enum_fmt(struct v4l2_subdev *sd, unsigned index,
>  			   enum v4l2_mbus_pixelcode *code)
>  {
> -	if ((unsigned int)index >= ARRAY_SIZE(mt9t112_cfmts))
> +	if (index >= ARRAY_SIZE(mt9t112_cfmts))
>  		return -EINVAL;
>  
>  	*code = mt9t112_cfmts[index].code;
> diff --git a/drivers/media/video/mt9v022.c b/drivers/media/video/mt9v022.c
> index e5bae4c..9699c38 100644
> --- a/drivers/media/video/mt9v022.c
> +++ b/drivers/media/video/mt9v022.c
> @@ -838,13 +838,13 @@ static struct v4l2_subdev_core_ops mt9v022_subdev_core_ops = {
>  #endif
>  };
>  
> -static int mt9v022_enum_fmt(struct v4l2_subdev *sd, int index,
> +static int mt9v022_enum_fmt(struct v4l2_subdev *sd, unsigned index,
>  			    enum v4l2_mbus_pixelcode *code)
>  {
>  	struct i2c_client *client = sd->priv;
>  	struct mt9v022 *mt9v022 = to_mt9v022(client);
>  
> -	if ((unsigned int)index >= mt9v022->num_fmts)
> +	if (index >= mt9v022->num_fmts)
>  		return -EINVAL;
>  
>  	*code = mt9v022->fmts[index].code;
> diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
> index d477e30..5b908fb 100644
> --- a/drivers/media/video/mx3_camera.c
> +++ b/drivers/media/video/mx3_camera.c
> @@ -672,7 +672,7 @@ static bool mx3_camera_packing_supported(const struct soc_mbus_pixelfmt *fmt)
>  		 fmt->packing == SOC_MBUS_PACKING_EXTEND16);
>  }
>  
> -static int mx3_camera_get_formats(struct soc_camera_device *icd, int idx,
> +static int mx3_camera_get_formats(struct soc_camera_device *icd, unsigned idx,
>  				  struct soc_camera_format_xlate *xlate)
>  {
>  	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> @@ -689,7 +689,7 @@ static int mx3_camera_get_formats(struct soc_camera_device *icd, int idx,
>  	fmt = soc_mbus_get_fmtdesc(code);
>  	if (!fmt) {
>  		dev_err(icd->dev.parent,
> -			"Invalid format code #%d: %d\n", idx, code);
> +			"Invalid format code #%u: %d\n", idx, code);
>  		return 0;
>  	}
>  
> diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
> index 7f8ece3..a235067 100644
> --- a/drivers/media/video/ov772x.c
> +++ b/drivers/media/video/ov772x.c
> @@ -1092,10 +1092,10 @@ static struct v4l2_subdev_core_ops ov772x_subdev_core_ops = {
>  #endif
>  };
>  
> -static int ov772x_enum_fmt(struct v4l2_subdev *sd, int index,
> +static int ov772x_enum_fmt(struct v4l2_subdev *sd, unsigned index,
>  			   enum v4l2_mbus_pixelcode *code)
>  {
> -	if ((unsigned int)index >= ARRAY_SIZE(ov772x_cfmts))
> +	if (index >= ARRAY_SIZE(ov772x_cfmts))
>  		return -EINVAL;
>  
>  	*code = ov772x_cfmts[index].code;
> diff --git a/drivers/media/video/ov9640.c b/drivers/media/video/ov9640.c
> index 36599a6..e36fa65 100644
> --- a/drivers/media/video/ov9640.c
> +++ b/drivers/media/video/ov9640.c
> @@ -614,10 +614,10 @@ static int ov9640_try_fmt(struct v4l2_subdev *sd,
>  	return 0;
>  }
>  
> -static int ov9640_enum_fmt(struct v4l2_subdev *sd, int index,
> +static int ov9640_enum_fmt(struct v4l2_subdev *sd, unsigned index,
>  			   enum v4l2_mbus_pixelcode *code)
>  {
> -	if ((unsigned int)index >= ARRAY_SIZE(ov9640_codes))
> +	if (index >= ARRAY_SIZE(ov9640_codes))
>  		return -EINVAL;
>  
>  	*code = ov9640_codes[index];
> diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
> index 520a35b..2d9eb57 100644
> --- a/drivers/media/video/pxa_camera.c
> +++ b/drivers/media/video/pxa_camera.c
> @@ -1245,7 +1245,7 @@ static bool pxa_camera_packing_supported(const struct soc_mbus_pixelfmt *fmt)
>  		 fmt->packing == SOC_MBUS_PACKING_EXTEND16);
>  }
>  
> -static int pxa_camera_get_formats(struct soc_camera_device *icd, int idx,
> +static int pxa_camera_get_formats(struct soc_camera_device *icd, unsigned idx,
>  				  struct soc_camera_format_xlate *xlate)
>  {
>  	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> @@ -1262,7 +1262,7 @@ static int pxa_camera_get_formats(struct soc_camera_device *icd, int idx,
>  
>  	fmt = soc_mbus_get_fmtdesc(code);
>  	if (!fmt) {
> -		dev_err(dev, "Invalid format code #%d: %d\n", idx, code);
> +		dev_err(dev, "Invalid format code #%u: %d\n", idx, code);
>  		return 0;
>  	}
>  
> diff --git a/drivers/media/video/rj54n1cb0c.c b/drivers/media/video/rj54n1cb0c.c
> index bbd9c11..a107574 100644
> --- a/drivers/media/video/rj54n1cb0c.c
> +++ b/drivers/media/video/rj54n1cb0c.c
> @@ -481,10 +481,10 @@ static int reg_write_multiple(struct i2c_client *client,
>  	return 0;
>  }
>  
> -static int rj54n1_enum_fmt(struct v4l2_subdev *sd, int index,
> +static int rj54n1_enum_fmt(struct v4l2_subdev *sd, unsigned index,
>  			   enum v4l2_mbus_pixelcode *code)
>  {
> -	if ((unsigned int)index >= ARRAY_SIZE(rj54n1_colour_fmts))
> +	if (index >= ARRAY_SIZE(rj54n1_colour_fmts))
>  		return -EINVAL;
>  
>  	*code = rj54n1_colour_fmts[index].code;
> diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
> index 1604034..a426470 100644
> --- a/drivers/media/video/sh_mobile_ceu_camera.c
> +++ b/drivers/media/video/sh_mobile_ceu_camera.c
> @@ -877,7 +877,7 @@ static bool sh_mobile_ceu_packing_supported(const struct soc_mbus_pixelfmt *fmt)
>  
>  static int client_g_rect(struct v4l2_subdev *sd, struct v4l2_rect *rect);
>  
> -static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, int idx,
> +static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, unsigned idx,
>  				     struct soc_camera_format_xlate *xlate)
>  {
>  	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> @@ -896,7 +896,7 @@ static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, int idx,
>  	fmt = soc_mbus_get_fmtdesc(code);
>  	if (!fmt) {
>  		dev_err(icd->dev.parent,
> -			"Invalid format code #%d: %d\n", idx, code);
> +			"Invalid format code #%u: %d\n", idx, code);
>  		return -EINVAL;
>  	}
>  
> diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
> index 95cb336..7e8d106 100644
> --- a/drivers/media/video/soc_camera.c
> +++ b/drivers/media/video/soc_camera.c
> @@ -199,7 +199,8 @@ static int soc_camera_init_user_formats(struct soc_camera_device *icd)
>  {
>  	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
>  	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> -	int i, fmts = 0, raw_fmts = 0, ret;
> +	unsigned i, fmts = 0, raw_fmts = 0;
> +	int ret;
>  	enum v4l2_mbus_pixelcode code;
>  
>  	while (!v4l2_subdev_call(sd, video, enum_mbus_fmt, raw_fmts, &code))
> diff --git a/drivers/media/video/soc_camera_platform.c b/drivers/media/video/soc_camera_platform.c
> index 10b003a..09e1d68 100644
> --- a/drivers/media/video/soc_camera_platform.c
> +++ b/drivers/media/video/soc_camera_platform.c
> @@ -71,7 +71,7 @@ static int soc_camera_platform_try_fmt(struct v4l2_subdev *sd,
>  
>  static struct v4l2_subdev_core_ops platform_subdev_core_ops;
>  
> -static int soc_camera_platform_enum_fmt(struct v4l2_subdev *sd, int index,
> +static int soc_camera_platform_enum_fmt(struct v4l2_subdev *sd, unsigned index,
>  					enum v4l2_mbus_pixelcode *code)
>  {
>  	struct soc_camera_platform_info *p = v4l2_get_subdevdata(sd);
> diff --git a/drivers/media/video/tw9910.c b/drivers/media/video/tw9910.c
> index 76be733..0e1cc08 100644
> --- a/drivers/media/video/tw9910.c
> +++ b/drivers/media/video/tw9910.c
> @@ -903,7 +903,7 @@ static struct v4l2_subdev_core_ops tw9910_subdev_core_ops = {
>  #endif
>  };
>  
> -static int tw9910_enum_fmt(struct v4l2_subdev *sd, int index,
> +static int tw9910_enum_fmt(struct v4l2_subdev *sd, unsigned index,
>  			   enum v4l2_mbus_pixelcode *code)
>  {
>  	if (index)
> diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
> index c9a5bbf..79b2e21 100644
> --- a/include/media/soc_camera.h
> +++ b/include/media/soc_camera.h
> @@ -66,7 +66,7 @@ struct soc_camera_host_ops {
>  	 * .get_formats() fail, .put_formats() will not be called at all, the
>  	 * failing .get_formats() must then clean up internally.
>  	 */
> -	int (*get_formats)(struct soc_camera_device *, int,
> +	int (*get_formats)(struct soc_camera_device *, unsigned,
>  			   struct soc_camera_format_xlate *);
>  	void (*put_formats)(struct soc_camera_device *);
>  	int (*cropcap)(struct soc_camera_device *, struct v4l2_cropcap *);
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index a888893..a3b2e58 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -246,7 +246,7 @@ struct v4l2_subdev_video_ops {
>  			struct v4l2_dv_timings *timings);
>  	int (*g_dv_timings)(struct v4l2_subdev *sd,
>  			struct v4l2_dv_timings *timings);
> -	int (*enum_mbus_fmt)(struct v4l2_subdev *sd, int index,
> +	int (*enum_mbus_fmt)(struct v4l2_subdev *sd, unsigned index,
>  			     enum v4l2_mbus_pixelcode *code);
>  	int (*g_mbus_fmt)(struct v4l2_subdev *sd,
>  			  struct v4l2_mbus_framefmt *fmt);
> -- 
> 1.6.4.2
> 
> 
> -- 
> Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
