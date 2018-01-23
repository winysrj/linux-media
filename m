Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:55759 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751814AbeAWOs0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 Jan 2018 09:48:26 -0500
Date: Tue, 23 Jan 2018 15:47:42 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv2 2/9] media: convert g/s_parm to g/s_frame_interval in
 subdevs
Message-ID: <20180123144742.GA17416@w540>
References: <20180122123125.24709-1-hverkuil@xs4all.nl>
 <20180122123125.24709-3-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20180122123125.24709-3-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Jan 22, 2018 at 01:31:18PM +0100, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> --- a/drivers/media/platform/atmel/atmel-isi.c
> +++ b/drivers/media/platform/atmel/atmel-isi.c
> @@ -689,22 +689,14 @@ static int isi_g_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
>  {
>  	struct atmel_isi *isi = video_drvdata(file);
>
> -	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> -		return -EINVAL;
> -
> -	a->parm.capture.readbuffers = 2;
> -	return v4l2_subdev_call(isi->entity.subdev, video, g_parm, a);
> +	return v4l2_g_parm_cap(video_devdata(file), isi->entity.subdev, a);
>  }
>
>  static int isi_s_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
>  {
>  	struct atmel_isi *isi = video_drvdata(file);
>
> -	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> -		return -EINVAL;

I've now tested the right version with CEU, and v4l2-compliance
reports:

fail: v4l2-test-formats.cpp(1218): Video Capture cap not set, but
G/S_PARM worked

To get rid of this error I had to refuse V4L2_BUF_TYPE_VIDEO_CAPTURE
type in g/s_parm as my driver only supports VIDEO_CAPTURE_MPLANE type.

static int ceu_s_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
{
	struct ceu_device *ceudev = video_drvdata(file);

	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
		return -EINVAL;

	return v4l2_s_parm_cap(video_devdata(file), ceudev->sd->v4l2_sd, a);
}

To make sure the same error does not happen for atmel-isi/isc and other
platform drivers this patch modifies, I would keep the checks on
a->type you have removed here.

I now wonder if the following test in the newly added v4l2_g/s_parm_cap()
still makes sense if platform drivers have to check for the correct
buffer type anyhow (the same for the _cap name suffix)

int v4l2_g_parm_cap(struct video_device *vdev,
                struct v4l2_subdev *sd, struct v4l2_streamparm *a)
{
        struct v4l2_subdev_frame_interval ival = { 0 };
        int ret;

	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE &&
	    a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
		return -EINVAL;

Thanks
   j

> -
> -	a->parm.capture.readbuffers = 2;
> -	return v4l2_subdev_call(isi->entity.subdev, video, s_parm, a);
> +	return v4l2_s_parm_cap(video_devdata(file), isi->entity.subdev, a);
>  }
>
>  static int isi_enum_framesizes(struct file *file, void *fh,
> diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
> index 41f179117fb0..b7660b1000fd 100644
> --- a/drivers/media/platform/blackfin/bfin_capture.c
> +++ b/drivers/media/platform/blackfin/bfin_capture.c
> @@ -712,24 +712,18 @@ static int bcap_querycap(struct file *file, void  *priv,
>  	return 0;
>  }
>
> -static int bcap_g_parm(struct file *file, void *fh,
> -				struct v4l2_streamparm *a)
> +static int bcap_g_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
>  {
>  	struct bcap_device *bcap_dev = video_drvdata(file);
>
> -	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> -		return -EINVAL;
> -	return v4l2_subdev_call(bcap_dev->sd, video, g_parm, a);
> +	return v4l2_g_parm_cap(video_devdata(file), bcap_dev->sd, a);
>  }
>
> -static int bcap_s_parm(struct file *file, void *fh,
> -				struct v4l2_streamparm *a)
> +static int bcap_s_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
>  {
>  	struct bcap_device *bcap_dev = video_drvdata(file);
>
> -	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> -		return -EINVAL;
> -	return v4l2_subdev_call(bcap_dev->sd, video, s_parm, a);
> +	return v4l2_s_parm_cap(video_devdata(file), bcap_dev->sd, a);
>  }
>
>  static int bcap_log_status(struct file *file, void *priv)
> diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
> index 7b7250b1cff8..80670eeee142 100644
> --- a/drivers/media/platform/marvell-ccic/mcam-core.c
> +++ b/drivers/media/platform/marvell-ccic/mcam-core.c
> @@ -1443,24 +1443,24 @@ static int mcam_vidioc_s_input(struct file *filp, void *priv, unsigned int i)
>   * the level which controls the number of read buffers.
>   */
>  static int mcam_vidioc_g_parm(struct file *filp, void *priv,
> -		struct v4l2_streamparm *parms)
> +		struct v4l2_streamparm *a)
>  {
>  	struct mcam_camera *cam = video_drvdata(filp);
>  	int ret;
>
> -	ret = sensor_call(cam, video, g_parm, parms);
> -	parms->parm.capture.readbuffers = n_dma_bufs;
> +	ret = v4l2_g_parm_cap(video_devdata(filp), cam->sensor, a);
> +	a->parm.capture.readbuffers = n_dma_bufs;
>  	return ret;
>  }
>
>  static int mcam_vidioc_s_parm(struct file *filp, void *priv,
> -		struct v4l2_streamparm *parms)
> +		struct v4l2_streamparm *a)
>  {
>  	struct mcam_camera *cam = video_drvdata(filp);
>  	int ret;
>
> -	ret = sensor_call(cam, video, s_parm, parms);
> -	parms->parm.capture.readbuffers = n_dma_bufs;
> +	ret = v4l2_s_parm_cap(video_devdata(filp), cam->sensor, a);
> +	a->parm.capture.readbuffers = n_dma_bufs;
>  	return ret;
>  }
>
> diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
> index d13e2c5fb06f..1a9d4610045f 100644
> --- a/drivers/media/platform/soc_camera/soc_camera.c
> +++ b/drivers/media/platform/soc_camera/soc_camera.c
> @@ -1788,17 +1788,19 @@ static int default_s_selection(struct soc_camera_device *icd,
>  }
>
>  static int default_g_parm(struct soc_camera_device *icd,
> -			  struct v4l2_streamparm *parm)
> +			  struct v4l2_streamparm *a)
>  {
>  	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> -	return v4l2_subdev_call(sd, video, g_parm, parm);
> +
> +	return v4l2_g_parm_cap(icd->vdev, sd, a);
>  }
>
>  static int default_s_parm(struct soc_camera_device *icd,
> -			  struct v4l2_streamparm *parm)
> +			  struct v4l2_streamparm *a)
>  {
>  	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> -	return v4l2_subdev_call(sd, video, s_parm, parm);
> +
> +	return v4l2_s_parm_cap(icd->vdev, sd, a);
>  }
>
>  static int default_enum_framesizes(struct soc_camera_device *icd,
> diff --git a/drivers/media/platform/via-camera.c b/drivers/media/platform/via-camera.c
> index 805d4a8fc17e..c632279a4209 100644
> --- a/drivers/media/platform/via-camera.c
> +++ b/drivers/media/platform/via-camera.c
> @@ -1112,7 +1112,7 @@ static int viacam_g_parm(struct file *filp, void *priv,
>  	int ret;
>
>  	mutex_lock(&cam->lock);
> -	ret = sensor_call(cam, video, g_parm, parm);
> +	ret = v4l2_g_parm_cap(video_devdata(filp), cam->sensor, parm);
>  	mutex_unlock(&cam->lock);
>  	parm->parm.capture.readbuffers = cam->n_cap_bufs;
>  	return ret;
> @@ -1125,7 +1125,7 @@ static int viacam_s_parm(struct file *filp, void *priv,
>  	int ret;
>
>  	mutex_lock(&cam->lock);
> -	ret = sensor_call(cam, video, s_parm, parm);
> +	ret = v4l2_s_parm_cap(video_devdata(filp), cam->sensor, parm);
>  	mutex_unlock(&cam->lock);
>  	parm->parm.capture.readbuffers = cam->n_cap_bufs;
>  	return ret;
> diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
> index a2ba2d905952..2724e3b99af2 100644
> --- a/drivers/media/usb/em28xx/em28xx-video.c
> +++ b/drivers/media/usb/em28xx/em28xx-video.c
> @@ -1582,17 +1582,26 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id norm)
>  static int vidioc_g_parm(struct file *file, void *priv,
>  			 struct v4l2_streamparm *p)
>  {
> +	struct v4l2_subdev_frame_interval ival = { 0 };
>  	struct em28xx      *dev  = video_drvdata(file);
>  	struct em28xx_v4l2 *v4l2 = dev->v4l2;
>  	int rc = 0;
>
> +	if (p->type != V4L2_BUF_TYPE_VIDEO_CAPTURE &&
> +	    p->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> +		return -EINVAL;
> +
>  	p->parm.capture.readbuffers = EM28XX_MIN_BUF;
> -	if (dev->board.is_webcam)
> +	p->parm.capture.capability = V4L2_CAP_TIMEPERFRAME;
> +	if (dev->board.is_webcam) {
>  		rc = v4l2_device_call_until_err(&v4l2->v4l2_dev, 0,
> -						video, g_parm, p);
> -	else
> +						video, g_frame_interval, &ival);
> +		if (!rc)
> +			p->parm.capture.timeperframe = ival.interval;
> +	} else {
>  		v4l2_video_std_frame_period(v4l2->norm,
>  					    &p->parm.capture.timeperframe);
> +	}
>
>  	return rc;
>  }
> @@ -1601,10 +1610,27 @@ static int vidioc_s_parm(struct file *file, void *priv,
>  			 struct v4l2_streamparm *p)
>  {
>  	struct em28xx *dev = video_drvdata(file);
> +	struct v4l2_subdev_frame_interval ival = {
> +		0,
> +		p->parm.capture.timeperframe
> +	};
> +	int rc = 0;
> +
> +	if (!dev->board.is_webcam)
> +		return -ENOTTY;
>
> +	if (p->type != V4L2_BUF_TYPE_VIDEO_CAPTURE &&
> +	    p->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> +		return -EINVAL;
> +
> +	memset(&p->parm, 0, sizeof(p->parm));
>  	p->parm.capture.readbuffers = EM28XX_MIN_BUF;
> -	return v4l2_device_call_until_err(&dev->v4l2->v4l2_dev,
> -					  0, video, s_parm, p);
> +	p->parm.capture.capability = V4L2_CAP_TIMEPERFRAME;
> +	rc = v4l2_device_call_until_err(&dev->v4l2->v4l2_dev, 0,
> +					video, s_frame_interval, &ival);
> +	if (!rc)
> +		p->parm.capture.timeperframe = ival.interval;
> +	return rc;
>  }
>
>  static int vidioc_enum_input(struct file *file, void *priv,
> --
> 2.15.1
>
