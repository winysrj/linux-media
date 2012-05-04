Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:58301 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab2EDPFw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 May 2012 11:05:52 -0400
Date: Fri, 4 May 2012 17:05:46 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Aguirre, Sergio" <saaguirre@ti.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, Qing Xu <qingx@marvell.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] v4l: soc-camera: Add support for enum_frameintervals
 ioctl
In-Reply-To: <CAKnK67SK+CKBL-Dx0V0nyYtEWN3wp3D90M9irFCQOmqiX2fKPw@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1205041541100.21890@axis700.grange>
References: <CAKnK67SK+CKBL-Dx0V0nyYtEWN3wp3D90M9irFCQOmqiX2fKPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergio

Sorry about the delay.

On Wed, 18 Apr 2012, Aguirre, Sergio wrote:

> From: Sergio Aguirre <saaguirre@ti.com>
> 
> Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
> ---
>  drivers/media/video/soc_camera.c |   37 +++++++++++++++++++++++++++++++++++++
>  include/media/soc_camera.h       |    1 +
>  2 files changed, 38 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
> index eb25756..62c8956 100644
> --- a/drivers/media/video/soc_camera.c
> +++ b/drivers/media/video/soc_camera.c
> @@ -266,6 +266,15 @@ static int soc_camera_enum_fsizes(struct file
> *file, void *fh,
>  	return ici->ops->enum_fsizes(icd, fsize);
>  }
> 
> +static int soc_camera_enum_fivals(struct file *file, void *fh,

"fivals" is a bit short for my taste. Yes, I know about the 
*_enum_fsizes() precedent in soc_camera.c, we should have used a more 
descriptive name for that too. So, maybe I'll push a patch to change that 
to enum_frmsizes() or enum_framesizes().

But that brings in a larger question, which is also the reason, why I 
added a couple more people to the CC: the following 3 operations in struct 
v4l2_subdev_video_ops don't make me particularly happy:

	int (*enum_framesizes)(struct v4l2_subdev *sd, struct v4l2_frmsizeenum *fsize);
	int (*enum_frameintervals)(struct v4l2_subdev *sd, struct v4l2_frmivalenum *fival);
	int (*enum_mbus_fsizes)(struct v4l2_subdev *sd,
			     struct v4l2_frmsizeenum *fsize);

The problems are:

1. enum_framesizes and enum_mbus_fsizes seem to be identical (yes, I see 
my Sob under the latter:-()
2. both struct v4l2_frmsizeenum and struct v4l2_frmivalenum are the 
structs, used in the respective V4L2 ioctl()s, and they both contain a 
field for a fourcc value, which doesn't make sense to subdevice drivers. 
So far the only driver combination in the mainline, that I see, that uses 
these operations is marvell-ccic & ov7670. These drivers just ignore the 
pixel format. Relatively recently enum_mbus_fsizes() has been added to 
soc-camera, and this patch is adding enum_frameintervals(). Both these 
implementations abuse the .pixel_format field to pass a media-bus code 
value in it to subdevice drivers. This sends meaningful information to 
subdevice drivers, but is really a hack, rather than a proper 
implementation.

Any idea how to improve this? Shall we create mediabus clones of those 
structs with an mbus code instead of fourcc, and drop one of the above 
enum_framesizes() operations?

Thanks
Guennadi

> +				   struct v4l2_frmivalenum *fival)
> +{
> +	struct soc_camera_device *icd = file->private_data;
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
> +
> +	return ici->ops->enum_fivals(icd, fival);
> +}
> +
>  static int soc_camera_reqbufs(struct file *file, void *priv,
>  			      struct v4l2_requestbuffers *p)
>  {
> @@ -1266,6 +1275,31 @@ static int default_enum_fsizes(struct
> soc_camera_device *icd,
>  	return 0;
>  }
> 
> +static int default_enum_fivals(struct soc_camera_device *icd,
> +			  struct v4l2_frmivalenum *fival)
> +{
> +	int ret;
> +	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> +	const struct soc_camera_format_xlate *xlate;
> +	__u32 pixfmt = fival->pixel_format;
> +	struct v4l2_frmivalenum fival_sd = *fival;
> +
> +	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
> +	if (!xlate)
> +		return -EINVAL;
> +	/* map xlate-code to pixel_format, sensor only handle xlate-code*/
> +	fival_sd.pixel_format = xlate->code;
> +
> +	ret = v4l2_subdev_call(sd, video, enum_frameintervals, &fival_sd);
> +	if (ret < 0)
> +		return ret;
> +
> +	*fival = fival_sd;
> +	fival->pixel_format = pixfmt;
> +
> +	return 0;
> +}
> +
>  int soc_camera_host_register(struct soc_camera_host *ici)
>  {
>  	struct soc_camera_host *ix;
> @@ -1297,6 +1331,8 @@ int soc_camera_host_register(struct soc_camera_host *ici)
>  		ici->ops->get_parm = default_g_parm;
>  	if (!ici->ops->enum_fsizes)
>  		ici->ops->enum_fsizes = default_enum_fsizes;
> +	if (!ici->ops->enum_fivals)
> +		ici->ops->enum_fivals = default_enum_fivals;
> 
>  	mutex_lock(&list_lock);
>  	list_for_each_entry(ix, &hosts, list) {
> @@ -1387,6 +1423,7 @@ static const struct v4l2_ioctl_ops
> soc_camera_ioctl_ops = {
>  	.vidioc_s_std		 = soc_camera_s_std,
>  	.vidioc_g_std		 = soc_camera_g_std,
>  	.vidioc_enum_framesizes  = soc_camera_enum_fsizes,
> +	.vidioc_enum_frameintervals  = soc_camera_enum_fivals,
>  	.vidioc_reqbufs		 = soc_camera_reqbufs,
>  	.vidioc_querybuf	 = soc_camera_querybuf,
>  	.vidioc_qbuf		 = soc_camera_qbuf,
> diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
> index b5c2b6c..0a3ac07 100644
> --- a/include/media/soc_camera.h
> +++ b/include/media/soc_camera.h
> @@ -98,6 +98,7 @@ struct soc_camera_host_ops {
>  	int (*get_parm)(struct soc_camera_device *, struct v4l2_streamparm *);
>  	int (*set_parm)(struct soc_camera_device *, struct v4l2_streamparm *);
>  	int (*enum_fsizes)(struct soc_camera_device *, struct v4l2_frmsizeenum *);
> +	int (*enum_fivals)(struct soc_camera_device *, struct v4l2_frmivalenum *);
>  	unsigned int (*poll)(struct file *, poll_table *);
>  };
> 
> -- 
> 1.7.5.4
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
