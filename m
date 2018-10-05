Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lj1-f193.google.com ([209.85.208.193]:45556 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727581AbeJERvS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2018 13:51:18 -0400
Received: by mail-lj1-f193.google.com with SMTP id j4-v6so7408460ljc.12
        for <linux-media@vger.kernel.org>; Fri, 05 Oct 2018 03:53:01 -0700 (PDT)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Fri, 5 Oct 2018 12:52:58 +0200
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Tomasz Figa <tfiga@chromium.org>,
        snawrocki@kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 11/11] vidioc_cropcap -> vidioc_g_pixelaspect
Message-ID: <20181005105258.GV24305@bigcity.dyn.berto.se>
References: <20181005074911.47574-1-hverkuil@xs4all.nl>
 <20181005074911.47574-12-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181005074911.47574-12-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for your patch.

On 2018-10-05 09:49:11 +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Now vidioc_cropcap is only used to return the pixelaspect, so
> rename it accordingly.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

For the v4l2 and rcar-vin changes:

Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> ---
>  drivers/media/pci/bt8xx/bttv-driver.c         | 12 +++++------
>  drivers/media/pci/cobalt/cobalt-v4l2.c        | 10 +++++----
>  drivers/media/pci/cx18/cx18-ioctl.c           | 13 ++++++------
>  drivers/media/pci/cx23885/cx23885-video.c     | 12 +++++------
>  drivers/media/pci/ivtv/ivtv-ioctl.c           | 17 ++++++++-------
>  drivers/media/pci/saa7134/saa7134-video.c     | 21 +++++++++----------
>  drivers/media/platform/am437x/am437x-vpfe.c   | 13 ++++++------
>  drivers/media/platform/davinci/vpbe_display.c | 10 ++++-----
>  drivers/media/platform/davinci/vpfe_capture.c | 12 +++++------
>  drivers/media/platform/rcar-vin/rcar-v4l2.c   | 10 ++++-----
>  drivers/media/platform/vivid/vivid-core.c     |  9 ++++----
>  drivers/media/platform/vivid/vivid-vid-cap.c  | 18 +++++++---------
>  drivers/media/platform/vivid/vivid-vid-cap.h  |  2 +-
>  drivers/media/platform/vivid/vivid-vid-out.c  | 18 +++++++---------
>  drivers/media/platform/vivid/vivid-vid-out.h  |  2 +-
>  drivers/media/usb/au0828/au0828-video.c       | 12 +++++------
>  drivers/media/usb/cx231xx/cx231xx-417.c       | 12 +++++------
>  drivers/media/usb/cx231xx/cx231xx-video.c     | 12 +++++------
>  drivers/media/usb/pvrusb2/pvrusb2-v4l2.c      | 13 +++++++-----
>  drivers/media/v4l2-core/v4l2-dev.c            |  6 +++---
>  drivers/media/v4l2-core/v4l2-ioctl.c          | 15 +++++++------
>  include/media/v4l2-ioctl.h                    |  8 +++----
>  22 files changed, 131 insertions(+), 126 deletions(-)
> 
> diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
> index b2cfcbb0008e..52cac1d3f577 100644
> --- a/drivers/media/pci/bt8xx/bttv-driver.c
> +++ b/drivers/media/pci/bt8xx/bttv-driver.c
> @@ -2792,19 +2792,17 @@ static int bttv_g_tuner(struct file *file, void *priv,
>  	return 0;
>  }
>  
> -static int bttv_cropcap(struct file *file, void *priv,
> -				struct v4l2_cropcap *cap)
> +static int bttv_g_pixelaspect(struct file *file, void *priv,
> +			      int type, struct v4l2_fract *f)
>  {
>  	struct bttv_fh *fh = priv;
>  	struct bttv *btv = fh->btv;
>  
> -	if (cap->type != V4L2_BUF_TYPE_VIDEO_CAPTURE &&
> -	    cap->type != V4L2_BUF_TYPE_VIDEO_OVERLAY)
> +	if (type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
>  		return -EINVAL;
>  
>  	/* defrect and bounds are set via g_selection */
> -	cap->pixelaspect = bttv_tvnorms[btv->tvnorm].cropcap.pixelaspect;
> -
> +	*f = bttv_tvnorms[btv->tvnorm].cropcap.pixelaspect;
>  	return 0;
>  }
>  
> @@ -3162,7 +3160,7 @@ static const struct v4l2_ioctl_ops bttv_ioctl_ops = {
>  	.vidioc_g_fmt_vbi_cap           = bttv_g_fmt_vbi_cap,
>  	.vidioc_try_fmt_vbi_cap         = bttv_try_fmt_vbi_cap,
>  	.vidioc_s_fmt_vbi_cap           = bttv_s_fmt_vbi_cap,
> -	.vidioc_cropcap                 = bttv_cropcap,
> +	.vidioc_g_pixelaspect           = bttv_g_pixelaspect,
>  	.vidioc_reqbufs                 = bttv_reqbufs,
>  	.vidioc_querybuf                = bttv_querybuf,
>  	.vidioc_qbuf                    = bttv_qbuf,
> diff --git a/drivers/media/pci/cobalt/cobalt-v4l2.c b/drivers/media/pci/cobalt/cobalt-v4l2.c
> index 4a0205aae4b4..c088de551081 100644
> --- a/drivers/media/pci/cobalt/cobalt-v4l2.c
> +++ b/drivers/media/pci/cobalt/cobalt-v4l2.c
> @@ -1077,20 +1077,22 @@ static int cobalt_g_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
>  	return 0;
>  }
>  
> -static int cobalt_cropcap(struct file *file, void *fh, struct v4l2_cropcap *cc)
> +static int cobalt_g_pixelaspect(struct file *file, void *fh,
> +				int type, struct v4l2_fract *f)
>  {
>  	struct cobalt_stream *s = video_drvdata(file);
>  	struct v4l2_dv_timings timings;
>  	int err = 0;
>  
> -	if (cc->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +	if (type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
>  		return -EINVAL;
> +
>  	if (s->input == 1)
>  		timings = cea1080p60;
>  	else
>  		err = v4l2_subdev_call(s->sd, video, g_dv_timings, &timings);
>  	if (!err)
> -		cc->pixelaspect = v4l2_dv_timings_aspect_ratio(&timings);
> +		*f = v4l2_dv_timings_aspect_ratio(&timings);
>  	return err;
>  }
>  
> @@ -1132,7 +1134,7 @@ static const struct v4l2_ioctl_ops cobalt_ioctl_ops = {
>  	.vidioc_log_status		= cobalt_log_status,
>  	.vidioc_streamon		= vb2_ioctl_streamon,
>  	.vidioc_streamoff		= vb2_ioctl_streamoff,
> -	.vidioc_cropcap			= cobalt_cropcap,
> +	.vidioc_g_pixelaspect		= cobalt_g_pixelaspect,
>  	.vidioc_g_selection		= cobalt_g_selection,
>  	.vidioc_enum_input		= cobalt_enum_input,
>  	.vidioc_g_input			= cobalt_g_input,
> diff --git a/drivers/media/pci/cx18/cx18-ioctl.c b/drivers/media/pci/cx18/cx18-ioctl.c
> index 854116375a7c..8c54b17f382a 100644
> --- a/drivers/media/pci/cx18/cx18-ioctl.c
> +++ b/drivers/media/pci/cx18/cx18-ioctl.c
> @@ -441,15 +441,16 @@ static int cx18_enum_input(struct file *file, void *fh, struct v4l2_input *vin)
>  	return cx18_get_input(cx, vin->index, vin);
>  }
>  
> -static int cx18_cropcap(struct file *file, void *fh,
> -			struct v4l2_cropcap *cropcap)
> +static int cx18_g_pixelaspect(struct file *file, void *fh,
> +			      int type, struct v4l2_fract *f)
>  {
>  	struct cx18 *cx = fh2id(fh)->cx;
>  
> -	if (cropcap->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +	if (type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
>  		return -EINVAL;
> -	cropcap->pixelaspect.numerator = cx->is_50hz ? 54 : 11;
> -	cropcap->pixelaspect.denominator = cx->is_50hz ? 59 : 10;
> +
> +	f->numerator = cx->is_50hz ? 54 : 11;
> +	f->denominator = cx->is_50hz ? 59 : 10;
>  	return 0;
>  }
>  
> @@ -1079,7 +1080,7 @@ static const struct v4l2_ioctl_ops cx18_ioctl_ops = {
>  	.vidioc_g_audio                 = cx18_g_audio,
>  	.vidioc_enumaudio               = cx18_enumaudio,
>  	.vidioc_enum_input              = cx18_enum_input,
> -	.vidioc_cropcap                 = cx18_cropcap,
> +	.vidioc_g_pixelaspect           = cx18_g_pixelaspect,
>  	.vidioc_g_selection             = cx18_g_selection,
>  	.vidioc_g_input                 = cx18_g_input,
>  	.vidioc_s_input                 = cx18_s_input,
> diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
> index a9844c4020ff..168178c1e574 100644
> --- a/drivers/media/pci/cx23885/cx23885-video.c
> +++ b/drivers/media/pci/cx23885/cx23885-video.c
> @@ -668,17 +668,17 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
>  	return 0;
>  }
>  
> -static int vidioc_cropcap(struct file *file, void *priv,
> -			  struct v4l2_cropcap *cc)
> +static int vidioc_g_pixelaspect(struct file *file, void *priv,
> +				int type, struct v4l2_fract *f)
>  {
>  	struct cx23885_dev *dev = video_drvdata(file);
>  	bool is_50hz = dev->tvnorm & V4L2_STD_625_50;
>  
> -	if (cc->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +	if (type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
>  		return -EINVAL;
>  
> -	cc->pixelaspect.numerator = is_50hz ? 54 : 11;
> -	cc->pixelaspect.denominator = is_50hz ? 59 : 10;
> +	f->numerator = is_50hz ? 54 : 11;
> +	f->denominator = is_50hz ? 59 : 10;
>  
>  	return 0;
>  }
> @@ -1139,7 +1139,7 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
>  	.vidioc_dqbuf         = vb2_ioctl_dqbuf,
>  	.vidioc_streamon      = vb2_ioctl_streamon,
>  	.vidioc_streamoff     = vb2_ioctl_streamoff,
> -	.vidioc_cropcap       = vidioc_cropcap,
> +	.vidioc_g_pixelaspect = vidioc_g_pixelaspect,
>  	.vidioc_g_selection   = vidioc_g_selection,
>  	.vidioc_s_std         = vidioc_s_std,
>  	.vidioc_g_std         = vidioc_g_std,
> diff --git a/drivers/media/pci/ivtv/ivtv-ioctl.c b/drivers/media/pci/ivtv/ivtv-ioctl.c
> index a66f8b872520..6c269ecd8d05 100644
> --- a/drivers/media/pci/ivtv/ivtv-ioctl.c
> +++ b/drivers/media/pci/ivtv/ivtv-ioctl.c
> @@ -829,17 +829,18 @@ static int ivtv_enum_output(struct file *file, void *fh, struct v4l2_output *vou
>  	return ivtv_get_output(itv, vout->index, vout);
>  }
>  
> -static int ivtv_cropcap(struct file *file, void *fh, struct v4l2_cropcap *cropcap)
> +static int ivtv_g_pixelaspect(struct file *file, void *fh,
> +			      int type, struct v4l2_fract *f)
>  {
>  	struct ivtv_open_id *id = fh2id(fh);
>  	struct ivtv *itv = id->itv;
>  
> -	if (cropcap->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> -		cropcap->pixelaspect.numerator = itv->is_50hz ? 54 : 11;
> -		cropcap->pixelaspect.denominator = itv->is_50hz ? 59 : 10;
> -	} else if (cropcap->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> -		cropcap->pixelaspect.numerator = itv->is_out_50hz ? 54 : 11;
> -		cropcap->pixelaspect.denominator = itv->is_out_50hz ? 59 : 10;
> +	if (type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> +		f->numerator = itv->is_50hz ? 54 : 11;
> +		f->denominator = itv->is_50hz ? 59 : 10;
> +	} else if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> +		f->numerator = itv->is_out_50hz ? 54 : 11;
> +		f->denominator = itv->is_out_50hz ? 59 : 10;
>  	} else {
>  		return -EINVAL;
>  	}
> @@ -1923,7 +1924,7 @@ static const struct v4l2_ioctl_ops ivtv_ioctl_ops = {
>  	.vidioc_enum_input		    = ivtv_enum_input,
>  	.vidioc_enum_output		    = ivtv_enum_output,
>  	.vidioc_enumaudout		    = ivtv_enumaudout,
> -	.vidioc_cropcap			    = ivtv_cropcap,
> +	.vidioc_g_pixelaspect		    = ivtv_g_pixelaspect,
>  	.vidioc_s_selection		    = ivtv_s_selection,
>  	.vidioc_g_selection		    = ivtv_g_selection,
>  	.vidioc_g_input			    = ivtv_g_input,
> diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
> index 1a22ae7cbdd9..8a02e442a21b 100644
> --- a/drivers/media/pci/saa7134/saa7134-video.c
> +++ b/drivers/media/pci/saa7134/saa7134-video.c
> @@ -1650,23 +1650,22 @@ int saa7134_querystd(struct file *file, void *priv, v4l2_std_id *std)
>  }
>  EXPORT_SYMBOL_GPL(saa7134_querystd);
>  
> -static int saa7134_cropcap(struct file *file, void *priv,
> -					struct v4l2_cropcap *cap)
> +static int saa7134_g_pixelaspect(struct file *file, void *priv,
> +				 int type, struct v4l2_fract *f)
>  {
>  	struct saa7134_dev *dev = video_drvdata(file);
>  
> -	if (cap->type != V4L2_BUF_TYPE_VIDEO_CAPTURE &&
> -	    cap->type != V4L2_BUF_TYPE_VIDEO_OVERLAY)
> +	if (type != V4L2_BUF_TYPE_VIDEO_CAPTURE &&
> +	    type != V4L2_BUF_TYPE_VIDEO_OVERLAY)
>  		return -EINVAL;
> -	cap->pixelaspect.numerator   = 1;
> -	cap->pixelaspect.denominator = 1;
> +
>  	if (dev->tvnorm->id & V4L2_STD_525_60) {
> -		cap->pixelaspect.numerator   = 11;
> -		cap->pixelaspect.denominator = 10;
> +		f->numerator   = 11;
> +		f->denominator = 10;
>  	}
>  	if (dev->tvnorm->id & V4L2_STD_625_50) {
> -		cap->pixelaspect.numerator   = 54;
> -		cap->pixelaspect.denominator = 59;
> +		f->numerator   = 54;
> +		f->denominator = 59;
>  	}
>  	return 0;
>  }
> @@ -1987,7 +1986,7 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
>  	.vidioc_g_fmt_vbi_cap		= saa7134_try_get_set_fmt_vbi_cap,
>  	.vidioc_try_fmt_vbi_cap		= saa7134_try_get_set_fmt_vbi_cap,
>  	.vidioc_s_fmt_vbi_cap		= saa7134_try_get_set_fmt_vbi_cap,
> -	.vidioc_cropcap			= saa7134_cropcap,
> +	.vidioc_g_pixelaspect		= saa7134_g_pixelaspect,
>  	.vidioc_reqbufs			= vb2_ioctl_reqbufs,
>  	.vidioc_querybuf		= vb2_ioctl_querybuf,
>  	.vidioc_qbuf			= vb2_ioctl_qbuf,
> diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
> index 6d44531092ec..2b6882e6ca58 100644
> --- a/drivers/media/platform/am437x/am437x-vpfe.c
> +++ b/drivers/media/platform/am437x/am437x-vpfe.c
> @@ -2081,17 +2081,18 @@ static void vpfe_stop_streaming(struct vb2_queue *vq)
>  	spin_unlock_irqrestore(&vpfe->dma_queue_lock, flags);
>  }
>  
> -static int vpfe_cropcap(struct file *file, void *priv,
> -			struct v4l2_cropcap *crop)
> +static int vpfe_g_pixelaspect(struct file *file, void *priv,
> +			      int type, struct v4l2_fract *f)
>  {
>  	struct vpfe_device *vpfe = video_drvdata(file);
>  
> -	vpfe_dbg(2, vpfe, "vpfe_cropcap\n");
> +	vpfe_dbg(2, vpfe, "vpfe_g_pixelaspect\n");
>  
> -	if (vpfe->std_index >= ARRAY_SIZE(vpfe_standards))
> +	if (type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
> +	    vpfe->std_index >= ARRAY_SIZE(vpfe_standards))
>  		return -EINVAL;
>  
> -	crop->pixelaspect = vpfe_standards[vpfe->std_index].pixelaspect;
> +	*f = vpfe_standards[vpfe->std_index].pixelaspect;
>  
>  	return 0;
>  }
> @@ -2280,7 +2281,7 @@ static const struct v4l2_ioctl_ops vpfe_ioctl_ops = {
>  	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
>  	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
>  
> -	.vidioc_cropcap			= vpfe_cropcap,
> +	.vidioc_g_pixelaspect		= vpfe_g_pixelaspect,
>  	.vidioc_g_selection		= vpfe_g_selection,
>  	.vidioc_s_selection		= vpfe_s_selection,
>  
> diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
> index 5c235898af7b..9e86b0d36640 100644
> --- a/drivers/media/platform/davinci/vpbe_display.c
> +++ b/drivers/media/platform/davinci/vpbe_display.c
> @@ -759,18 +759,18 @@ static int vpbe_display_g_selection(struct file *file, void *priv,
>  	return 0;
>  }
>  
> -static int vpbe_display_cropcap(struct file *file, void *priv,
> -			      struct v4l2_cropcap *cropcap)
> +static int vpbe_display_g_pixelaspect(struct file *file, void *priv,
> +				      int type, struct v4l2_fract *f)
>  {
>  	struct vpbe_layer *layer = video_drvdata(file);
>  	struct vpbe_device *vpbe_dev = layer->disp_dev->vpbe_dev;
>  
>  	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev, "VIDIOC_CROPCAP ioctl\n");
>  
> -	if (cropcap->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
> +	if (type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
>  		return -EINVAL;
>  
> -	cropcap->pixelaspect = vpbe_dev->current_timings.aspect;
> +	*f = vpbe_dev->current_timings.aspect;
>  	return 0;
>  }
>  
> @@ -1263,7 +1263,7 @@ static const struct v4l2_ioctl_ops vpbe_ioctl_ops = {
>  	.vidioc_streamoff	 = vb2_ioctl_streamoff,
>  	.vidioc_expbuf		 = vb2_ioctl_expbuf,
>  
> -	.vidioc_cropcap		 = vpbe_display_cropcap,
> +	.vidioc_g_pixelaspect	 = vpbe_display_g_pixelaspect,
>  	.vidioc_g_selection	 = vpbe_display_g_selection,
>  	.vidioc_s_selection	 = vpbe_display_s_selection,
>  
> diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
> index ea3ddd5a42bd..9996bab98fe3 100644
> --- a/drivers/media/platform/davinci/vpfe_capture.c
> +++ b/drivers/media/platform/davinci/vpfe_capture.c
> @@ -1558,20 +1558,20 @@ static int vpfe_streamoff(struct file *file, void *priv,
>  	return ret;
>  }
>  
> -static int vpfe_cropcap(struct file *file, void *priv,
> -			      struct v4l2_cropcap *crop)
> +static int vpfe_g_pixelaspect(struct file *file, void *priv,
> +			      int type, struct v4l2_fract *f)
>  {
>  	struct vpfe_device *vpfe_dev = video_drvdata(file);
>  
> -	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_cropcap\n");
> +	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_g_pixelaspect\n");
>  
> -	if (crop->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +	if (type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
>  		return -EINVAL;
>  	/* If std_index is invalid, then just return (== 1:1 aspect) */
>  	if (vpfe_dev->std_index >= ARRAY_SIZE(vpfe_standards))
>  		return 0;
>  
> -	crop->pixelaspect = vpfe_standards[vpfe_dev->std_index].pixelaspect;
> +	*f = vpfe_standards[vpfe_dev->std_index].pixelaspect;
>  	return 0;
>  }
>  
> @@ -1677,7 +1677,7 @@ static const struct v4l2_ioctl_ops vpfe_ioctl_ops = {
>  	.vidioc_dqbuf		 = vpfe_dqbuf,
>  	.vidioc_streamon	 = vpfe_streamon,
>  	.vidioc_streamoff	 = vpfe_streamoff,
> -	.vidioc_cropcap		 = vpfe_cropcap,
> +	.vidioc_g_pixelaspect	 = vpfe_g_pixelaspect,
>  	.vidioc_g_selection	 = vpfe_g_selection,
>  	.vidioc_s_selection	 = vpfe_s_selection,
>  };
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> index dc77682b4785..7a2851790b91 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -404,16 +404,16 @@ static int rvin_s_selection(struct file *file, void *fh,
>  	return 0;
>  }
>  
> -static int rvin_cropcap(struct file *file, void *priv,
> -			struct v4l2_cropcap *crop)
> +static int rvin_g_pixelaspect(struct file *file, void *priv,
> +			      int type, struct v4l2_fract *f)
>  {
>  	struct rvin_dev *vin = video_drvdata(file);
>  	struct v4l2_subdev *sd = vin_to_source(vin);
>  
> -	if (crop->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +	if (type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
>  		return -EINVAL;
>  
> -	return v4l2_subdev_call(sd, video, g_pixelaspect, &crop->pixelaspect);
> +	return v4l2_subdev_call(sd, video, g_pixelaspect, f);
>  }
>  
>  static int rvin_enum_input(struct file *file, void *priv,
> @@ -620,7 +620,7 @@ static const struct v4l2_ioctl_ops rvin_ioctl_ops = {
>  	.vidioc_g_selection		= rvin_g_selection,
>  	.vidioc_s_selection		= rvin_s_selection,
>  
> -	.vidioc_cropcap			= rvin_cropcap,
> +	.vidioc_g_pixelaspect		= rvin_g_pixelaspect,
>  
>  	.vidioc_enum_input		= rvin_enum_input,
>  	.vidioc_g_input			= rvin_g_input,
> diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
> index 06961e7d8036..9f7bdb2c1385 100644
> --- a/drivers/media/platform/vivid/vivid-core.c
> +++ b/drivers/media/platform/vivid/vivid-core.c
> @@ -324,13 +324,14 @@ static int vidioc_s_dv_timings(struct file *file, void *fh, struct v4l2_dv_timin
>  	return vivid_vid_out_s_dv_timings(file, fh, timings);
>  }
>  
> -static int vidioc_cropcap(struct file *file, void *fh, struct v4l2_cropcap *cc)
> +static int vidioc_g_pixelaspect(struct file *file, void *fh,
> +				int type, struct v4l2_fract *f)
>  {
>  	struct video_device *vdev = video_devdata(file);
>  
>  	if (vdev->vfl_dir == VFL_DIR_RX)
> -		return vivid_vid_cap_cropcap(file, fh, cc);
> -	return vivid_vid_out_cropcap(file, fh, cc);
> +		return vivid_vid_cap_g_pixelaspect(file, fh, type, f);
> +	return vivid_vid_out_g_pixelaspect(file, fh, type, f);
>  }
>  
>  static int vidioc_g_selection(struct file *file, void *fh,
> @@ -519,7 +520,7 @@ static const struct v4l2_ioctl_ops vivid_ioctl_ops = {
>  
>  	.vidioc_g_selection		= vidioc_g_selection,
>  	.vidioc_s_selection		= vidioc_s_selection,
> -	.vidioc_cropcap			= vidioc_cropcap,
> +	.vidioc_g_pixelaspect		= vidioc_g_pixelaspect,
>  
>  	.vidioc_g_fmt_vbi_cap		= vidioc_g_fmt_vbi_cap,
>  	.vidioc_try_fmt_vbi_cap		= vidioc_g_fmt_vbi_cap,
> diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
> index 58e14dd1dcd3..7f0f89d7a5f6 100644
> --- a/drivers/media/platform/vivid/vivid-vid-cap.c
> +++ b/drivers/media/platform/vivid/vivid-vid-cap.c
> @@ -1003,26 +1003,24 @@ int vivid_vid_cap_s_selection(struct file *file, void *fh, struct v4l2_selection
>  	return 0;
>  }
>  
> -int vivid_vid_cap_cropcap(struct file *file, void *priv,
> -			      struct v4l2_cropcap *cap)
> +int vivid_vid_cap_g_pixelaspect(struct file *file, void *priv,
> +				int type, struct v4l2_fract *f)
>  {
>  	struct vivid_dev *dev = video_drvdata(file);
>  
> -	if (cap->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +	if (type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
>  		return -EINVAL;
>  
>  	switch (vivid_get_pixel_aspect(dev)) {
>  	case TPG_PIXEL_ASPECT_NTSC:
> -		cap->pixelaspect.numerator = 11;
> -		cap->pixelaspect.denominator = 10;
> +		f->numerator = 11;
> +		f->denominator = 10;
>  		break;
>  	case TPG_PIXEL_ASPECT_PAL:
> -		cap->pixelaspect.numerator = 54;
> -		cap->pixelaspect.denominator = 59;
> +		f->numerator = 54;
> +		f->denominator = 59;
>  		break;
> -	case TPG_PIXEL_ASPECT_SQUARE:
> -		cap->pixelaspect.numerator = 1;
> -		cap->pixelaspect.denominator = 1;
> +	default:
>  		break;
>  	}
>  	return 0;
> diff --git a/drivers/media/platform/vivid/vivid-vid-cap.h b/drivers/media/platform/vivid/vivid-vid-cap.h
> index 47d8b48820df..1e422a59eeab 100644
> --- a/drivers/media/platform/vivid/vivid-vid-cap.h
> +++ b/drivers/media/platform/vivid/vivid-vid-cap.h
> @@ -28,7 +28,7 @@ int vidioc_try_fmt_vid_cap(struct file *file, void *priv, struct v4l2_format *f)
>  int vidioc_s_fmt_vid_cap(struct file *file, void *priv, struct v4l2_format *f);
>  int vivid_vid_cap_g_selection(struct file *file, void *priv, struct v4l2_selection *sel);
>  int vivid_vid_cap_s_selection(struct file *file, void *fh, struct v4l2_selection *s);
> -int vivid_vid_cap_cropcap(struct file *file, void *priv, struct v4l2_cropcap *cap);
> +int vivid_vid_cap_g_pixelaspect(struct file *file, void *priv, int type, struct v4l2_fract *f);
>  int vidioc_enum_fmt_vid_overlay(struct file *file, void  *priv, struct v4l2_fmtdesc *f);
>  int vidioc_g_fmt_vid_overlay(struct file *file, void *priv, struct v4l2_format *f);
>  int vidioc_try_fmt_vid_overlay(struct file *file, void *priv, struct v4l2_format *f);
> diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
> index 50248e2176a0..164a4a7918d4 100644
> --- a/drivers/media/platform/vivid/vivid-vid-out.c
> +++ b/drivers/media/platform/vivid/vivid-vid-out.c
> @@ -785,26 +785,24 @@ int vivid_vid_out_s_selection(struct file *file, void *fh, struct v4l2_selection
>  	return 0;
>  }
>  
> -int vivid_vid_out_cropcap(struct file *file, void *priv,
> -			      struct v4l2_cropcap *cap)
> +int vivid_vid_out_g_pixelaspect(struct file *file, void *priv,
> +				int type, struct v4l2_fract *f)
>  {
>  	struct vivid_dev *dev = video_drvdata(file);
>  
> -	if (cap->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
> +	if (type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
>  		return -EINVAL;
>  
>  	switch (vivid_get_pixel_aspect(dev)) {
>  	case TPG_PIXEL_ASPECT_NTSC:
> -		cap->pixelaspect.numerator = 11;
> -		cap->pixelaspect.denominator = 10;
> +		f->numerator = 11;
> +		f->denominator = 10;
>  		break;
>  	case TPG_PIXEL_ASPECT_PAL:
> -		cap->pixelaspect.numerator = 54;
> -		cap->pixelaspect.denominator = 59;
> +		f->numerator = 54;
> +		f->denominator = 59;
>  		break;
> -	case TPG_PIXEL_ASPECT_SQUARE:
> -		cap->pixelaspect.numerator = 1;
> -		cap->pixelaspect.denominator = 1;
> +	default:
>  		break;
>  	}
>  	return 0;
> diff --git a/drivers/media/platform/vivid/vivid-vid-out.h b/drivers/media/platform/vivid/vivid-vid-out.h
> index e87aacf843c5..8d56314f4ea1 100644
> --- a/drivers/media/platform/vivid/vivid-vid-out.h
> +++ b/drivers/media/platform/vivid/vivid-vid-out.h
> @@ -23,7 +23,7 @@ int vidioc_try_fmt_vid_out(struct file *file, void *priv, struct v4l2_format *f)
>  int vidioc_s_fmt_vid_out(struct file *file, void *priv, struct v4l2_format *f);
>  int vivid_vid_out_g_selection(struct file *file, void *priv, struct v4l2_selection *sel);
>  int vivid_vid_out_s_selection(struct file *file, void *fh, struct v4l2_selection *s);
> -int vivid_vid_out_cropcap(struct file *file, void *fh, struct v4l2_cropcap *cap);
> +int vivid_vid_out_g_pixelaspect(struct file *file, void *priv, int type, struct v4l2_fract *f);
>  int vidioc_enum_fmt_vid_out_overlay(struct file *file, void  *priv, struct v4l2_fmtdesc *f);
>  int vidioc_g_fmt_vid_out_overlay(struct file *file, void *priv, struct v4l2_format *f);
>  int vidioc_try_fmt_vid_out_overlay(struct file *file, void *priv, struct v4l2_format *f);
> diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
> index d2250f594cf9..7876c897cc1d 100644
> --- a/drivers/media/usb/au0828/au0828-video.c
> +++ b/drivers/media/usb/au0828/au0828-video.c
> @@ -1616,19 +1616,19 @@ static int vidioc_g_fmt_vbi_cap(struct file *file, void *priv,
>  	return 0;
>  }
>  
> -static int vidioc_cropcap(struct file *file, void *priv,
> -			  struct v4l2_cropcap *cc)
> +static int vidioc_g_pixelaspect(struct file *file, void *priv,
> +				int type, struct v4l2_fract *f)
>  {
>  	struct au0828_dev *dev = video_drvdata(file);
>  
> -	if (cc->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +	if (type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
>  		return -EINVAL;
>  
>  	dprintk(1, "%s called std_set %d dev_state %ld\n", __func__,
>  		dev->std_set_in_tuner_core, dev->dev_state);
>  
> -	cc->pixelaspect.numerator = 54;
> -	cc->pixelaspect.denominator = 59;
> +	f->numerator = 54;
> +	f->denominator = 59;
>  
>  	return 0;
>  }
> @@ -1777,7 +1777,7 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
>  	.vidioc_enumaudio           = vidioc_enumaudio,
>  	.vidioc_g_audio             = vidioc_g_audio,
>  	.vidioc_s_audio             = vidioc_s_audio,
> -	.vidioc_cropcap             = vidioc_cropcap,
> +	.vidioc_g_pixelaspect       = vidioc_g_pixelaspect,
>  	.vidioc_g_selection         = vidioc_g_selection,
>  
>  	.vidioc_reqbufs             = vb2_ioctl_reqbufs,
> diff --git a/drivers/media/usb/cx231xx/cx231xx-417.c b/drivers/media/usb/cx231xx/cx231xx-417.c
> index f47d41de5ca7..e4ea4abcedab 100644
> --- a/drivers/media/usb/cx231xx/cx231xx-417.c
> +++ b/drivers/media/usb/cx231xx/cx231xx-417.c
> @@ -1500,18 +1500,18 @@ static const struct videobuf_queue_ops cx231xx_qops = {
>  
>  /* ------------------------------------------------------------------ */
>  
> -static int vidioc_cropcap(struct file *file, void *priv,
> -			  struct v4l2_cropcap *cc)
> +static int vidioc_g_pixelaspect(struct file *file, void *priv,
> +				int type, struct v4l2_fract *f)
>  {
>  	struct cx231xx_fh *fh = priv;
>  	struct cx231xx *dev = fh->dev;
>  	bool is_50hz = dev->encodernorm.id & V4L2_STD_625_50;
>  
> -	if (cc->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +	if (type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
>  		return -EINVAL;
>  
> -	cc->pixelaspect.numerator = is_50hz ? 54 : 11;
> -	cc->pixelaspect.denominator = is_50hz ? 59 : 10;
> +	f->numerator = is_50hz ? 54 : 11;
> +	f->denominator = is_50hz ? 59 : 10;
>  
>  	return 0;
>  }
> @@ -1883,7 +1883,7 @@ static const struct v4l2_ioctl_ops mpeg_ioctl_ops = {
>  	.vidioc_g_input		 = cx231xx_g_input,
>  	.vidioc_s_input		 = cx231xx_s_input,
>  	.vidioc_s_ctrl		 = vidioc_s_ctrl,
> -	.vidioc_cropcap		 = vidioc_cropcap,
> +	.vidioc_g_pixelaspect	 = vidioc_g_pixelaspect,
>  	.vidioc_g_selection	 = vidioc_g_selection,
>  	.vidioc_querycap	 = cx231xx_querycap,
>  	.vidioc_enum_fmt_vid_cap = vidioc_enum_fmt_vid_cap,
> diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
> index a24a278bc586..503e3d8240aa 100644
> --- a/drivers/media/usb/cx231xx/cx231xx-video.c
> +++ b/drivers/media/usb/cx231xx/cx231xx-video.c
> @@ -1482,18 +1482,18 @@ int cx231xx_s_register(struct file *file, void *priv,
>  }
>  #endif
>  
> -static int vidioc_cropcap(struct file *file, void *priv,
> -			  struct v4l2_cropcap *cc)
> +static int vidioc_g_pixelaspect(struct file *file, void *priv,
> +				int type, struct v4l2_fract *f)
>  {
>  	struct cx231xx_fh *fh = priv;
>  	struct cx231xx *dev = fh->dev;
>  	bool is_50hz = dev->norm & V4L2_STD_625_50;
>  
> -	if (cc->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +	if (type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
>  		return -EINVAL;
>  
> -	cc->pixelaspect.numerator = is_50hz ? 54 : 11;
> -	cc->pixelaspect.denominator = is_50hz ? 59 : 10;
> +	f->numerator = is_50hz ? 54 : 11;
> +	f->denominator = is_50hz ? 59 : 10;
>  
>  	return 0;
>  }
> @@ -2111,7 +2111,7 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
>  	.vidioc_g_fmt_vbi_cap          = vidioc_g_fmt_vbi_cap,
>  	.vidioc_try_fmt_vbi_cap        = vidioc_try_fmt_vbi_cap,
>  	.vidioc_s_fmt_vbi_cap          = vidioc_s_fmt_vbi_cap,
> -	.vidioc_cropcap                = vidioc_cropcap,
> +	.vidioc_g_pixelaspect          = vidioc_g_pixelaspect,
>  	.vidioc_g_selection            = vidioc_g_selection,
>  	.vidioc_reqbufs                = vidioc_reqbufs,
>  	.vidioc_querybuf               = vidioc_querybuf,
> diff --git a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
> index cea232a3302d..9b43f4e9da82 100644
> --- a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
> +++ b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
> @@ -703,16 +703,19 @@ static int pvr2_try_ext_ctrls(struct file *file, void *priv,
>  	return 0;
>  }
>  
> -static int pvr2_cropcap(struct file *file, void *priv, struct v4l2_cropcap *cap)
> +static int pvr2_g_pixelaspect(struct file *file, void *priv,
> +			      int type, struct v4l2_fract *f)
>  {
>  	struct pvr2_v4l2_fh *fh = file->private_data;
>  	struct pvr2_hdw *hdw = fh->channel.mc_head->hdw;
> +	struct v4l2_cropcap cap = { .type = type };
>  	int ret;
>  
> -	if (cap->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +	if (type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
>  		return -EINVAL;
> -	ret = pvr2_hdw_get_cropcap(hdw, cap);
> -	cap->type = V4L2_BUF_TYPE_VIDEO_CAPTURE; /* paranoia */
> +	ret = pvr2_hdw_get_cropcap(hdw, &cap);
> +	if (!ret)
> +		*f = cap.pixelaspect;
>  	return ret;
>  }
>  
> @@ -815,7 +818,7 @@ static const struct v4l2_ioctl_ops pvr2_ioctl_ops = {
>  	.vidioc_g_audio			    = pvr2_g_audio,
>  	.vidioc_enumaudio		    = pvr2_enumaudio,
>  	.vidioc_enum_input		    = pvr2_enum_input,
> -	.vidioc_cropcap			    = pvr2_cropcap,
> +	.vidioc_g_pixelaspect		    = pvr2_g_pixelaspect,
>  	.vidioc_s_selection		    = pvr2_s_selection,
>  	.vidioc_g_selection		    = pvr2_g_selection,
>  	.vidioc_g_input			    = pvr2_g_input,
> diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
> index d81141d51faa..626ac06b94e5 100644
> --- a/drivers/media/v4l2-core/v4l2-dev.c
> +++ b/drivers/media/v4l2-core/v4l2-dev.c
> @@ -621,14 +621,14 @@ static void determine_valid_ioctls(struct video_device *vdev)
>  		SET_VALID_IOCTL(ops, VIDIOC_TRY_DECODER_CMD, vidioc_try_decoder_cmd);
>  		SET_VALID_IOCTL(ops, VIDIOC_ENUM_FRAMESIZES, vidioc_enum_framesizes);
>  		SET_VALID_IOCTL(ops, VIDIOC_ENUM_FRAMEINTERVALS, vidioc_enum_frameintervals);
> -		if (ops->vidioc_g_selection)
> +		if (ops->vidioc_g_selection) {
>  			set_bit(_IOC_NR(VIDIOC_G_CROP), valid_ioctls);
> +			set_bit(_IOC_NR(VIDIOC_CROPCAP), valid_ioctls);
> +		}
>  		if (ops->vidioc_s_selection)
>  			set_bit(_IOC_NR(VIDIOC_S_CROP), valid_ioctls);
>  		SET_VALID_IOCTL(ops, VIDIOC_G_SELECTION, vidioc_g_selection);
>  		SET_VALID_IOCTL(ops, VIDIOC_S_SELECTION, vidioc_s_selection);
> -		if (ops->vidioc_cropcap || ops->vidioc_g_selection)
> -			set_bit(_IOC_NR(VIDIOC_CROPCAP), valid_ioctls);
>  	} else if (is_vbi) {
>  		/* vbi specific ioctls */
>  		if ((is_rx && (ops->vidioc_g_fmt_vbi_cap ||
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index a59954d351a2..26b199349fad 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -2264,18 +2264,21 @@ static int v4l_cropcap(const struct v4l2_ioctl_ops *ops,
>  	p->pixelaspect.numerator = 1;
>  	p->pixelaspect.denominator = 1;
>  
> +	if (s.type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> +		s.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	else if (s.type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> +		s.type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
> +
>  	/*
>  	 * The determine_valid_ioctls() call already should ensure
>  	 * that this can never happen, but just in case...
>  	 */
> -	if (WARN_ON(!ops->vidioc_cropcap && !ops->vidioc_g_selection))
> +	if (WARN_ON(!ops->vidioc_g_selection))
>  		return -ENOTTY;
>  
> -	if (ops->vidioc_cropcap)
> -		ret = ops->vidioc_cropcap(file, fh, p);
> -
> -	if (!ops->vidioc_g_selection)
> -		return ret;
> +	if (ops->vidioc_g_pixelaspect)
> +		ret = ops->vidioc_g_pixelaspect(file, fh, s.type,
> +						&p->pixelaspect);
>  
>  	/*
>  	 * Ignore ENOTTY or ENOIOCTLCMD error returns, just use the
> diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
> index 85fdd3f4b8ad..aa4511aa5ffc 100644
> --- a/include/media/v4l2-ioctl.h
> +++ b/include/media/v4l2-ioctl.h
> @@ -220,8 +220,8 @@ struct v4l2_fh;
>   *	:ref:`VIDIOC_G_MODULATOR <vidioc_g_modulator>` ioctl
>   * @vidioc_s_modulator: pointer to the function that implements
>   *	:ref:`VIDIOC_S_MODULATOR <vidioc_g_modulator>` ioctl
> - * @vidioc_cropcap: pointer to the function that implements
> - *	:ref:`VIDIOC_CROPCAP <vidioc_cropcap>` ioctl
> + * @vidioc_g_pixelaspect: pointer to the function that implements
> + *	the pixelaspect part of the :ref:`VIDIOC_CROPCAP <vidioc_cropcap>` ioctl
>   * @vidioc_g_selection: pointer to the function that implements
>   *	:ref:`VIDIOC_G_SELECTION <vidioc_g_selection>` ioctl
>   * @vidioc_s_selection: pointer to the function that implements
> @@ -487,8 +487,8 @@ struct v4l2_ioctl_ops {
>  	int (*vidioc_s_modulator)(struct file *file, void *fh,
>  				  const struct v4l2_modulator *a);
>  	/* Crop ioctls */
> -	int (*vidioc_cropcap)(struct file *file, void *fh,
> -			      struct v4l2_cropcap *a);
> +	int (*vidioc_g_pixelaspect)(struct file *file, void *fh,
> +				    int buf_type, struct v4l2_fract *aspect);
>  	int (*vidioc_g_selection)(struct file *file, void *fh,
>  				  struct v4l2_selection *s);
>  	int (*vidioc_s_selection)(struct file *file, void *fh,
> -- 
> 2.18.0
> 

-- 
Regards,
Niklas Söderlund
