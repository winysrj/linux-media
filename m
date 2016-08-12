Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:40067 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752325AbcHLJlX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Aug 2016 05:41:23 -0400
Subject: Re: [PATCH v8 10/10] Input: sur40 - use new V4L2 touch input type
To: Nick Dyer <nick@shmanahar.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <1468876238-24599-1-git-send-email-nick@shmanahar.org>
 <1468876238-24599-11-git-send-email-nick@shmanahar.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Benson Leung <bleung@chromium.org>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Chris Healy <cphealy@gmail.com>,
	Henrik Rydberg <rydberg@bitmath.org>,
	Andrew Duggan <aduggan@synaptics.com>,
	James Chen <james.chen@emc.com.tw>,
	Dudley Du <dudl@cypress.com>,
	Andrew de los Reyes <adlr@chromium.org>,
	sheckylin@chromium.org, Peter Hutterer <peter.hutterer@who-t.net>,
	Florian Echtler <floe@butterbrot.org>, mchehab@osg.samsung.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e5d7b260-fbfa-df1a-054e-f606455a2290@xs4all.nl>
Date: Fri, 12 Aug 2016 11:41:08 +0200
MIME-Version: 1.0
In-Reply-To: <1468876238-24599-11-git-send-email-nick@shmanahar.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nick,

On 07/18/2016 11:10 PM, Nick Dyer wrote:
> Support both V4L2_TCH_FMT_TU08 and V4L2_PIX_FMT_GREY for backwards
> compatibility.
> 
> Note: I have not tested these changes (I have no access to the hardware)
> so not signing off.

I can't merge this without your Signed-off. The Signed-off has nothing to do with
whether or not you have tested the code. I'm leaving this out of the pull request
for now.

Regards,

	Hans

> ---
>  drivers/input/touchscreen/sur40.c |  122 +++++++++++++++++++++++++++----------
>  1 file changed, 89 insertions(+), 33 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/sur40.c b/drivers/input/touchscreen/sur40.c
> index 4ea4757..fc275cb 100644
> --- a/drivers/input/touchscreen/sur40.c
> +++ b/drivers/input/touchscreen/sur40.c
> @@ -139,6 +139,27 @@ struct sur40_image_header {
>  #define SUR40_GET_STATE   0xc5 /*  4 bytes state (?) */
>  #define SUR40_GET_SENSORS 0xb1 /*  8 bytes sensors   */
>  
> +static const struct v4l2_pix_format sur40_pix_format[] = {
> +	{
> +		.pixelformat = V4L2_TCH_FMT_TU08,
> +		.width  = SENSOR_RES_X / 2,
> +		.height = SENSOR_RES_Y / 2,
> +		.field = V4L2_FIELD_NONE,
> +		.colorspace = V4L2_COLORSPACE_SRGB,
> +		.bytesperline = SENSOR_RES_X / 2,
> +		.sizeimage = (SENSOR_RES_X/2) * (SENSOR_RES_Y/2),
> +	},
> +	{
> +		.pixelformat = V4L2_PIX_FMT_GREY,
> +		.width  = SENSOR_RES_X / 2,
> +		.height = SENSOR_RES_Y / 2,
> +		.field = V4L2_FIELD_NONE,
> +		.colorspace = V4L2_COLORSPACE_SRGB,
> +		.bytesperline = SENSOR_RES_X / 2,
> +		.sizeimage = (SENSOR_RES_X/2) * (SENSOR_RES_Y/2),
> +	}
> +};
> +
>  /* master device state */
>  struct sur40_state {
>  
> @@ -149,6 +170,7 @@ struct sur40_state {
>  	struct v4l2_device v4l2;
>  	struct video_device vdev;
>  	struct mutex lock;
> +	struct v4l2_pix_format pix_fmt;
>  
>  	struct vb2_queue queue;
>  	struct list_head buf_list;
> @@ -169,7 +191,6 @@ struct sur40_buffer {
>  
>  /* forward declarations */
>  static const struct video_device sur40_video_device;
> -static const struct v4l2_pix_format sur40_video_format;
>  static const struct vb2_queue sur40_queue;
>  static void sur40_process_video(struct sur40_state *sur40);
>  
> @@ -420,7 +441,7 @@ static void sur40_process_video(struct sur40_state *sur40)
>  		goto err_poll;
>  	}
>  
> -	if (le32_to_cpu(img->size) != sur40_video_format.sizeimage) {
> +	if (le32_to_cpu(img->size) != sur40->pix_fmt.sizeimage) {
>  		dev_err(sur40->dev, "image size mismatch\n");
>  		goto err_poll;
>  	}
> @@ -431,7 +452,7 @@ static void sur40_process_video(struct sur40_state *sur40)
>  
>  	result = usb_sg_init(&sgr, sur40->usbdev,
>  		usb_rcvbulkpipe(sur40->usbdev, VIDEO_ENDPOINT), 0,
> -		sgt->sgl, sgt->nents, sur40_video_format.sizeimage, 0);
> +		sgt->sgl, sgt->nents, sur40->pix_fmt.sizeimage, 0);
>  	if (result < 0) {
>  		dev_err(sur40->dev, "error %d in usb_sg_init\n", result);
>  		goto err_poll;
> @@ -586,13 +607,14 @@ static int sur40_probe(struct usb_interface *interface,
>  	if (error)
>  		goto err_unreg_v4l2;
>  
> +	sur40->pix_fmt = sur40_pix_format[0];
>  	sur40->vdev = sur40_video_device;
>  	sur40->vdev.v4l2_dev = &sur40->v4l2;
>  	sur40->vdev.lock = &sur40->lock;
>  	sur40->vdev.queue = &sur40->queue;
>  	video_set_drvdata(&sur40->vdev, sur40);
>  
> -	error = video_register_device(&sur40->vdev, VFL_TYPE_GRABBER, -1);
> +	error = video_register_device(&sur40->vdev, VFL_TYPE_TOUCH, -1);
>  	if (error) {
>  		dev_err(&interface->dev,
>  			"Unable to register video subdevice.");
> @@ -651,10 +673,10 @@ static int sur40_queue_setup(struct vb2_queue *q,
>  		*nbuffers = 3 - q->num_buffers;
>  
>  	if (*nplanes)
> -		return sizes[0] < sur40_video_format.sizeimage ? -EINVAL : 0;
> +		return sizes[0] < sur40->pix_fmt.sizeimage ? -EINVAL : 0;
>  
>  	*nplanes = 1;
> -	sizes[0] = sur40_video_format.sizeimage;
> +	sizes[0] = sur40->pix_fmt.sizeimage;
>  
>  	return 0;
>  }
> @@ -666,7 +688,7 @@ static int sur40_queue_setup(struct vb2_queue *q,
>  static int sur40_buffer_prepare(struct vb2_buffer *vb)
>  {
>  	struct sur40_state *sur40 = vb2_get_drv_priv(vb->vb2_queue);
> -	unsigned long size = sur40_video_format.sizeimage;
> +	unsigned long size = sur40->pix_fmt.sizeimage;
>  
>  	if (vb2_plane_size(vb, 0) < size) {
>  		dev_err(&sur40->usbdev->dev, "buffer too small (%lu < %lu)\n",
> @@ -741,7 +763,7 @@ static int sur40_vidioc_querycap(struct file *file, void *priv,
>  	strlcpy(cap->driver, DRIVER_SHORT, sizeof(cap->driver));
>  	strlcpy(cap->card, DRIVER_LONG, sizeof(cap->card));
>  	usb_make_path(sur40->usbdev, cap->bus_info, sizeof(cap->bus_info));
> -	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE |
> +	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_TOUCH |
>  		V4L2_CAP_READWRITE |
>  		V4L2_CAP_STREAMING;
>  	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> @@ -753,7 +775,7 @@ static int sur40_vidioc_enum_input(struct file *file, void *priv,
>  {
>  	if (i->index != 0)
>  		return -EINVAL;
> -	i->type = V4L2_INPUT_TYPE_CAMERA;
> +	i->type = V4L2_INPUT_TYPE_TOUCH;
>  	i->std = V4L2_STD_UNKNOWN;
>  	strlcpy(i->name, "In-Cell Sensor", sizeof(i->name));
>  	i->capabilities = 0;
> @@ -771,19 +793,57 @@ static int sur40_vidioc_g_input(struct file *file, void *priv, unsigned int *i)
>  	return 0;
>  }
>  
> -static int sur40_vidioc_fmt(struct file *file, void *priv,
> +static int sur40_vidioc_try_fmt(struct file *file, void *priv,
> +			    struct v4l2_format *f)
> +{
> +	switch (f->fmt.pix.pixelformat) {
> +	case V4L2_PIX_FMT_GREY:
> +		f->fmt.pix = sur40_pix_format[1];
> +		break;
> +
> +	default:
> +		f->fmt.pix = sur40_pix_format[0];
> +		break;
> +	}
> +
> +	return 0;
> +}
> +
> +static int sur40_vidioc_s_fmt(struct file *file, void *priv,
> +			    struct v4l2_format *f)
> +{
> +	struct sur40_state *sur40 = video_drvdata(file);
> +
> +	switch (f->fmt.pix.pixelformat) {
> +	case V4L2_PIX_FMT_GREY:
> +		sur40->pix_fmt = sur40_pix_format[1];
> +		break;
> +
> +	default:
> +		sur40->pix_fmt = sur40_pix_format[0];
> +		break;
> +	}
> +
> +	f->fmt.pix = sur40->pix_fmt;
> +	return 0;
> +}
> +
> +static int sur40_vidioc_g_fmt(struct file *file, void *priv,
>  			    struct v4l2_format *f)
>  {
> -	f->fmt.pix = sur40_video_format;
> +	struct sur40_state *sur40 = video_drvdata(file);
> +
> +	f->fmt.pix = sur40->pix_fmt;
>  	return 0;
>  }
>  
>  static int sur40_vidioc_enum_fmt(struct file *file, void *priv,
>  				 struct v4l2_fmtdesc *f)
>  {
> -	if (f->index != 0)
> +	if (f->index >= ARRAY_SIZE(sur40_pix_format))
>  		return -EINVAL;
> -	f->pixelformat = V4L2_PIX_FMT_GREY;
> +
> +	f->pixelformat = sur40_pix_format[f->index].pixelformat;
>  	f->flags = 0;
>  	return 0;
>  }
> @@ -791,22 +851,28 @@ static int sur40_vidioc_enum_fmt(struct file *file, void *priv,
>  static int sur40_vidioc_enum_framesizes(struct file *file, void *priv,
>  					struct v4l2_frmsizeenum *f)
>  {
> -	if ((f->index != 0) || (f->pixel_format != V4L2_PIX_FMT_GREY))
> +	struct sur40_state *sur40 = video_drvdata(file);
> +
> +	if ((f->index != 0) || ((f->pixel_format != V4L2_TCH_FMT_TU08)
> +		&& (f->pixel_format != V4L2_PIX_FMT_GREY)))
>  		return -EINVAL;
>  
>  	f->type = V4L2_FRMSIZE_TYPE_DISCRETE;
> -	f->discrete.width  = sur40_video_format.width;
> -	f->discrete.height = sur40_video_format.height;
> +	f->discrete.width  = sur40->pix_fmt.width;
> +	f->discrete.height = sur40->pix_fmt.height;
>  	return 0;
>  }
>  
>  static int sur40_vidioc_enum_frameintervals(struct file *file, void *priv,
>  					    struct v4l2_frmivalenum *f)
>  {
> -	if ((f->index > 1) || (f->pixel_format != V4L2_PIX_FMT_GREY)
> -		|| (f->width  != sur40_video_format.width)
> -		|| (f->height != sur40_video_format.height))
> -			return -EINVAL;
> +	struct sur40_state *sur40 = video_drvdata(file);
> +
> +	if ((f->index > 1) || ((f->pixel_format != V4L2_TCH_FMT_TU08)
> +		&& (f->pixel_format != V4L2_PIX_FMT_GREY))
> +		|| (f->width  != sur40->pix_fmt.width)
> +		|| (f->height != sur40->pix_fmt.height))
> +		return -EINVAL;
>  
>  	f->type = V4L2_FRMIVAL_TYPE_DISCRETE;
>  	f->discrete.denominator  = 60/(f->index+1);
> @@ -862,9 +928,9 @@ static const struct v4l2_ioctl_ops sur40_video_ioctl_ops = {
>  	.vidioc_querycap	= sur40_vidioc_querycap,
>  
>  	.vidioc_enum_fmt_vid_cap = sur40_vidioc_enum_fmt,
> -	.vidioc_try_fmt_vid_cap	= sur40_vidioc_fmt,
> -	.vidioc_s_fmt_vid_cap	= sur40_vidioc_fmt,
> -	.vidioc_g_fmt_vid_cap	= sur40_vidioc_fmt,
> +	.vidioc_try_fmt_vid_cap	= sur40_vidioc_try_fmt,
> +	.vidioc_s_fmt_vid_cap	= sur40_vidioc_s_fmt,
> +	.vidioc_g_fmt_vid_cap	= sur40_vidioc_g_fmt,
>  
>  	.vidioc_enum_framesizes = sur40_vidioc_enum_framesizes,
>  	.vidioc_enum_frameintervals = sur40_vidioc_enum_frameintervals,
> @@ -891,16 +957,6 @@ static const struct video_device sur40_video_device = {
>  	.release = video_device_release_empty,
>  };
>  
> -static const struct v4l2_pix_format sur40_video_format = {
> -	.pixelformat = V4L2_PIX_FMT_GREY,
> -	.width  = SENSOR_RES_X / 2,
> -	.height = SENSOR_RES_Y / 2,
> -	.field = V4L2_FIELD_NONE,
> -	.colorspace = V4L2_COLORSPACE_SRGB,
> -	.bytesperline = SENSOR_RES_X / 2,
> -	.sizeimage = (SENSOR_RES_X/2) * (SENSOR_RES_Y/2),
> -};
> -
>  /* USB-specific object needed to register this driver with the USB subsystem. */
>  static struct usb_driver sur40_driver = {
>  	.name = DRIVER_SHORT,
> 
