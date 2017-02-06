Return-path: <linux-media-owner@vger.kernel.org>
Received: from a-painless.mh.aa.net.uk ([81.187.30.51]:55950 "EHLO
        a-painless.mh.aa.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750994AbdBFLiK (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Feb 2017 06:38:10 -0500
Subject: Re: [PATCH 1/6] staging: Import the BCM2835 MMAL-based V4L2 camera
 driver.
To: Hans Verkuil <hverkuil@xs4all.nl>, Eric Anholt <eric@anholt.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20170127215503.13208-1-eric@anholt.net>
 <20170127215503.13208-2-eric@anholt.net>
 <f7f6bed9-b6c9-48cd-814d-9a2f4afe0a8b@xs4all.nl>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-rpi-kernel@lists.infradead.org, linux-media@vger.kernel.org
From: Dave Stevenson <linux-media@destevenson.freeserve.co.uk>
Message-ID: <4cb2ee48-0033-b5ac-bbed-80aa119ee9f5@destevenson.freeserve.co.uk>
Date: Mon, 6 Feb 2017 11:37:18 +0000
MIME-Version: 1.0
In-Reply-To: <f7f6bed9-b6c9-48cd-814d-9a2f4afe0a8b@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans.

On 06/02/17 09:08, Hans Verkuil wrote:
> Hi Eric,
>
> Great to see this driver appearing for upstream merging!
>
> See below for my review comments, focusing mostly on V4L2 specifics.
>
> On 01/27/2017 10:54 PM, Eric Anholt wrote:
>> - Supports raw YUV capture, preview, JPEG and H264.
>> - Uses videobuf2 for data transfer, using dma_buf.
>> - Uses 3.6.10 timestamping
>> - Camera power based on use
>> - Uses immutable input mode on video encoder
>>
>> This code comes from the Raspberry Pi kernel tree (rpi-4.9.y) as of
>> a15ba877dab4e61ea3fc7b006e2a73828b083c52.
>>
>> Signed-off-by: Eric Anholt <eric@anholt.net>
>> ---
>>  .../media/platform/bcm2835/bcm2835-camera.c        | 2016 ++++++++++++++++++++
>>  .../media/platform/bcm2835/bcm2835-camera.h        |  145 ++
>>  drivers/staging/media/platform/bcm2835/controls.c  | 1345 +++++++++++++
>>  .../staging/media/platform/bcm2835/mmal-common.h   |   53 +
>>  .../media/platform/bcm2835/mmal-encodings.h        |  127 ++
>>  .../media/platform/bcm2835/mmal-msg-common.h       |   50 +
>>  .../media/platform/bcm2835/mmal-msg-format.h       |   81 +
>>  .../staging/media/platform/bcm2835/mmal-msg-port.h |  107 ++
>>  drivers/staging/media/platform/bcm2835/mmal-msg.h  |  404 ++++
>>  .../media/platform/bcm2835/mmal-parameters.h       |  689 +++++++
>>  .../staging/media/platform/bcm2835/mmal-vchiq.c    | 1916 +++++++++++++++++++
>>  .../staging/media/platform/bcm2835/mmal-vchiq.h    |  178 ++
>>  12 files changed, 7111 insertions(+)
>>  create mode 100644 drivers/staging/media/platform/bcm2835/bcm2835-camera.c
>>  create mode 100644 drivers/staging/media/platform/bcm2835/bcm2835-camera.h
>>  create mode 100644 drivers/staging/media/platform/bcm2835/controls.c
>>  create mode 100644 drivers/staging/media/platform/bcm2835/mmal-common.h
>>  create mode 100644 drivers/staging/media/platform/bcm2835/mmal-encodings.h
>>  create mode 100644 drivers/staging/media/platform/bcm2835/mmal-msg-common.h
>>  create mode 100644 drivers/staging/media/platform/bcm2835/mmal-msg-format.h
>>  create mode 100644 drivers/staging/media/platform/bcm2835/mmal-msg-port.h
>>  create mode 100644 drivers/staging/media/platform/bcm2835/mmal-msg.h
>>  create mode 100644 drivers/staging/media/platform/bcm2835/mmal-parameters.h
>>  create mode 100644 drivers/staging/media/platform/bcm2835/mmal-vchiq.c
>>  create mode 100644 drivers/staging/media/platform/bcm2835/mmal-vchiq.h
>>
>> diff --git a/drivers/staging/media/platform/bcm2835/bcm2835-camera.c b/drivers/staging/media/platform/bcm2835/bcm2835-camera.c
>> new file mode 100644
>> index 000000000000..4f03949aecf3
>> --- /dev/null
>> +++ b/drivers/staging/media/platform/bcm2835/bcm2835-camera.c
>> @@ -0,0 +1,2016 @@
>
> <snip>
>
>> +static int start_streaming(struct vb2_queue *vq, unsigned int count)
>> +{
>> +	struct bm2835_mmal_dev *dev = vb2_get_drv_priv(vq);
>> +	int ret;
>> +	int parameter_size;
>> +
>> +	v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev, "%s: dev:%p\n",
>> +		 __func__, dev);
>> +
>> +	/* ensure a format has actually been set */
>> +	if (dev->capture.port == NULL)
>> +		return -EINVAL;
>
> Standard mistake. If start_streaming returns an error, then it should call vb2_buffer_done
> for all queued buffers with state VB2_BUF_STATE_QUEUED. Otherwise the buffer administration
> gets unbalanced.

OK.
This is an error path that I'm not convinced can ever be followed, just 
defensive programming. It may be a candidate for just removing, but yes 
otherwise it needs to be fixed to do the right thing.

>> +
>> +	if (enable_camera(dev) < 0) {
>> +		v4l2_err(&dev->v4l2_dev, "Failed to enable camera\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	/*init_completion(&dev->capture.frame_cmplt); */
>> +
>> +	/* enable frame capture */
>> +	dev->capture.frame_count = 1;
>> +
>> +	/* if the preview is not already running, wait for a few frames for AGC
>> +	 * to settle down.
>> +	 */
>> +	if (!dev->component[MMAL_COMPONENT_PREVIEW]->enabled)
>> +		msleep(300);
>> +
>> +	/* enable the connection from camera to encoder (if applicable) */
>> +	if (dev->capture.camera_port != dev->capture.port
>> +	    && dev->capture.camera_port) {
>> +		ret = vchiq_mmal_port_enable(dev->instance,
>> +					     dev->capture.camera_port, NULL);
>> +		if (ret) {
>> +			v4l2_err(&dev->v4l2_dev,
>> +				 "Failed to enable encode tunnel - error %d\n",
>> +				 ret);
>> +			return -1;
>
> Use a proper error, not -1.
>
>> +		}
>> +	}
>> +
>> +	/* Get VC timestamp at this point in time */
>> +	parameter_size = sizeof(dev->capture.vc_start_timestamp);
>> +	if (vchiq_mmal_port_parameter_get(dev->instance,
>> +					  dev->capture.camera_port,
>> +					  MMAL_PARAMETER_SYSTEM_TIME,
>> +					  &dev->capture.vc_start_timestamp,
>> +					  &parameter_size)) {
>> +		v4l2_err(&dev->v4l2_dev,
>> +			 "Failed to get VC start time - update your VC f/w\n");
>> +
>> +		/* Flag to indicate just to rely on kernel timestamps */
>> +		dev->capture.vc_start_timestamp = -1;
>> +	} else
>> +		v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
>> +			 "Start time %lld size %d\n",
>> +			 dev->capture.vc_start_timestamp, parameter_size);
>> +
>> +	v4l2_get_timestamp(&dev->capture.kernel_start_ts);
>> +
>> +	/* enable the camera port */
>> +	dev->capture.port->cb_ctx = dev;
>> +	ret =
>> +	    vchiq_mmal_port_enable(dev->instance, dev->capture.port, buffer_cb);
>> +	if (ret) {
>> +		v4l2_err(&dev->v4l2_dev,
>> +			"Failed to enable capture port - error %d. "
>> +			"Disabling camera port again\n", ret);
>> +
>> +		vchiq_mmal_port_disable(dev->instance,
>> +					dev->capture.camera_port);
>> +		if (disable_camera(dev) < 0) {
>> +			v4l2_err(&dev->v4l2_dev, "Failed to disable camera\n");
>> +			return -EINVAL;
>> +		}
>> +		return -1;
>> +	}
>> +
>> +	/* capture the first frame */
>> +	vchiq_mmal_port_parameter_set(dev->instance,
>> +				      dev->capture.camera_port,
>> +				      MMAL_PARAMETER_CAPTURE,
>> +				      &dev->capture.frame_count,
>> +				      sizeof(dev->capture.frame_count));
>> +	return 0;
>> +}
>> +
>> +/* abort streaming and wait for last buffer */
>> +static void stop_streaming(struct vb2_queue *vq)
>> +{
>> +	int ret;
>> +	struct bm2835_mmal_dev *dev = vb2_get_drv_priv(vq);
>> +
>> +	v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev, "%s: dev:%p\n",
>> +		 __func__, dev);
>> +
>> +	init_completion(&dev->capture.frame_cmplt);
>> +	dev->capture.frame_count = 0;
>> +
>> +	/* ensure a format has actually been set */
>> +	if (dev->capture.port == NULL) {
>> +		v4l2_err(&dev->v4l2_dev,
>> +			 "no capture port - stream not started?\n");
>
> Same with stop_streaming: all queued buffers should be returned to vb2
> by calling vb2_buffer_done with state VB2_BUF_STATE_ERROR.

OK.
Again this is an error path that I'm not sure can ever be taken.

>> +		return;
>> +	}
>> +
>> +	v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev, "stopping capturing\n");
>> +
>> +	/* stop capturing frames */
>> +	vchiq_mmal_port_parameter_set(dev->instance,
>> +				      dev->capture.camera_port,
>> +				      MMAL_PARAMETER_CAPTURE,
>> +				      &dev->capture.frame_count,
>> +				      sizeof(dev->capture.frame_count));
>> +
>> +	/* wait for last frame to complete */
>> +	ret = wait_for_completion_timeout(&dev->capture.frame_cmplt, HZ);
>> +	if (ret <= 0)
>> +		v4l2_err(&dev->v4l2_dev,
>> +			 "error %d waiting for frame completion\n", ret);
>> +
>> +	v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
>> +		 "disabling connection\n");
>> +
>> +	/* disable the connection from camera to encoder */
>> +	ret = vchiq_mmal_port_disable(dev->instance, dev->capture.camera_port);
>> +	if (!ret && dev->capture.camera_port != dev->capture.port) {
>> +		v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
>> +			 "disabling port\n");
>> +		ret = vchiq_mmal_port_disable(dev->instance, dev->capture.port);
>> +	} else if (dev->capture.camera_port != dev->capture.port) {
>> +		v4l2_err(&dev->v4l2_dev, "port_disable failed, error %d\n",
>> +			 ret);
>> +	}
>> +
>> +	if (disable_camera(dev) < 0)
>> +		v4l2_err(&dev->v4l2_dev, "Failed to disable camera\n");
>> +}
>> +
>> +static void bm2835_mmal_lock(struct vb2_queue *vq)
>> +{
>> +	struct bm2835_mmal_dev *dev = vb2_get_drv_priv(vq);
>> +	mutex_lock(&dev->mutex);
>> +}
>> +
>> +static void bm2835_mmal_unlock(struct vb2_queue *vq)
>> +{
>> +	struct bm2835_mmal_dev *dev = vb2_get_drv_priv(vq);
>> +	mutex_unlock(&dev->mutex);
>> +}
>
> You want to use the core helpers vb2_ops_wait_prepare/finish and just set
> the lock field of vb2_queue to this mutex.

OK

>> +
>> +static struct vb2_ops bm2835_mmal_video_qops = {
>> +	.queue_setup = queue_setup,
>> +	.buf_prepare = buffer_prepare,
>> +	.buf_queue = buffer_queue,
>> +	.start_streaming = start_streaming,
>> +	.stop_streaming = stop_streaming,
>> +	.wait_prepare = bm2835_mmal_unlock,
>> +	.wait_finish = bm2835_mmal_lock,
>> +};
>> +
>> +/* ------------------------------------------------------------------
>> +	IOCTL operations
>> +   ------------------------------------------------------------------*/
>> +
>> +static int set_overlay_params(struct bm2835_mmal_dev *dev,
>> +			      struct vchiq_mmal_port *port)
>> +{
>> +	int ret;
>> +	struct mmal_parameter_displayregion prev_config = {
>> +	.set = MMAL_DISPLAY_SET_LAYER | MMAL_DISPLAY_SET_ALPHA |
>> +	    MMAL_DISPLAY_SET_DEST_RECT | MMAL_DISPLAY_SET_FULLSCREEN,
>> +	.layer = PREVIEW_LAYER,
>> +	.alpha = dev->overlay.global_alpha,
>> +	.fullscreen = 0,
>> +	.dest_rect = {
>> +		      .x = dev->overlay.w.left,
>> +		      .y = dev->overlay.w.top,
>> +		      .width = dev->overlay.w.width,
>> +		      .height = dev->overlay.w.height,
>> +		      },
>> +	};
>> +	ret = vchiq_mmal_port_parameter_set(dev->instance, port,
>> +					    MMAL_PARAMETER_DISPLAYREGION,
>> +					    &prev_config, sizeof(prev_config));
>> +
>> +	return ret;
>> +}
>> +
>> +/* overlay ioctl */
>> +static int vidioc_enum_fmt_vid_overlay(struct file *file, void *priv,
>> +				       struct v4l2_fmtdesc *f)
>> +{
>> +	struct mmal_fmt *fmt;
>> +
>> +	if (f->index >= ARRAY_SIZE(formats))
>> +		return -EINVAL;
>> +
>> +	fmt = &formats[f->index];
>> +
>> +	strlcpy(f->description, fmt->name, sizeof(f->description));
>
> Drop this. The v4l2 core fills in the description for you to ensure consistent
> format descriptions.
>
> This likely means you can drop the fmt->name field as well.
>
>> +	f->pixelformat = fmt->fourcc;
>> +	f->flags = fmt->flags;
>> +
>> +	return 0;
>> +}
>> +
>> +static int vidioc_g_fmt_vid_overlay(struct file *file, void *priv,
>> +				    struct v4l2_format *f)
>> +{
>> +	struct bm2835_mmal_dev *dev = video_drvdata(file);
>> +
>> +	f->fmt.win = dev->overlay;
>> +
>> +	return 0;
>> +}
>> +
>> +static int vidioc_try_fmt_vid_overlay(struct file *file, void *priv,
>> +				      struct v4l2_format *f)
>> +{
>> +	struct bm2835_mmal_dev *dev = video_drvdata(file);
>> +
>> +	f->fmt.win.field = V4L2_FIELD_NONE;
>> +	f->fmt.win.chromakey = 0;
>> +	f->fmt.win.clips = NULL;
>> +	f->fmt.win.clipcount = 0;
>> +	f->fmt.win.bitmap = NULL;
>> +
>> +	v4l_bound_align_image(&f->fmt.win.w.width, MIN_WIDTH, dev->max_width, 1,
>> +			      &f->fmt.win.w.height, MIN_HEIGHT, dev->max_height,
>> +			      1, 0);
>> +	v4l_bound_align_image(&f->fmt.win.w.left, MIN_WIDTH, dev->max_width, 1,
>> +			      &f->fmt.win.w.top, MIN_HEIGHT, dev->max_height,
>> +			      1, 0);
>> +
>> +	v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
>> +		"Overlay: Now w/h %dx%d l/t %dx%d\n",
>> +		f->fmt.win.w.width, f->fmt.win.w.height,
>> +		f->fmt.win.w.left, f->fmt.win.w.top);
>> +
>> +	v4l2_dump_win_format(1,
>> +			     bcm2835_v4l2_debug,
>> +			     &dev->v4l2_dev,
>> +			     &f->fmt.win,
>> +			     __func__);
>> +	return 0;
>> +}
>> +
>> +static int vidioc_s_fmt_vid_overlay(struct file *file, void *priv,
>> +				    struct v4l2_format *f)
>> +{
>> +	struct bm2835_mmal_dev *dev = video_drvdata(file);
>> +
>> +	vidioc_try_fmt_vid_overlay(file, priv, f);
>> +
>> +	dev->overlay = f->fmt.win;
>> +	if (dev->component[MMAL_COMPONENT_PREVIEW]->enabled) {
>> +		set_overlay_params(dev,
>> +			&dev->component[MMAL_COMPONENT_PREVIEW]->input[0]);
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int vidioc_overlay(struct file *file, void *f, unsigned int on)
>> +{
>> +	int ret;
>> +	struct bm2835_mmal_dev *dev = video_drvdata(file);
>> +	struct vchiq_mmal_port *src;
>> +	struct vchiq_mmal_port *dst;
>
> Add newline.
>
>> +	if ((on && dev->component[MMAL_COMPONENT_PREVIEW]->enabled) ||
>> +	    (!on && !dev->component[MMAL_COMPONENT_PREVIEW]->enabled))
>> +		return 0;	/* already in requested state */
>> +
>> +	src =
>> +	    &dev->component[MMAL_COMPONENT_CAMERA]->
>> +	    output[MMAL_CAMERA_PORT_PREVIEW];
>> +
>> +	if (!on) {
>> +		/* disconnect preview ports and disable component */
>> +		ret = vchiq_mmal_port_disable(dev->instance, src);
>> +		if (!ret)
>> +			ret =
>> +			    vchiq_mmal_port_connect_tunnel(dev->instance, src,
>> +							   NULL);
>> +		if (ret >= 0)
>> +			ret = vchiq_mmal_component_disable(
>> +					dev->instance,
>> +					dev->component[MMAL_COMPONENT_PREVIEW]);
>> +
>> +		disable_camera(dev);
>> +		return ret;
>> +	}
>> +
>> +	/* set preview port format and connect it to output */
>> +	dst = &dev->component[MMAL_COMPONENT_PREVIEW]->input[0];
>> +
>> +	ret = vchiq_mmal_port_set_format(dev->instance, src);
>> +	if (ret < 0)
>> +		goto error;
>> +
>> +	ret = set_overlay_params(dev, dst);
>> +	if (ret < 0)
>> +		goto error;
>> +
>> +	if (enable_camera(dev) < 0)
>> +		goto error;
>> +
>> +	ret = vchiq_mmal_component_enable(
>> +			dev->instance,
>> +			dev->component[MMAL_COMPONENT_PREVIEW]);
>> +	if (ret < 0)
>> +		goto error;
>> +
>> +	v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev, "connecting %p to %p\n",
>> +		 src, dst);
>> +	ret = vchiq_mmal_port_connect_tunnel(dev->instance, src, dst);
>> +	if (!ret)
>> +		ret = vchiq_mmal_port_enable(dev->instance, src, NULL);
>> +error:
>> +	return ret;
>> +}
>> +
>> +static int vidioc_g_fbuf(struct file *file, void *fh,
>> +			 struct v4l2_framebuffer *a)
>> +{
>> +	/* The video overlay must stay within the framebuffer and can't be
>> +	   positioned independently. */
>> +	struct bm2835_mmal_dev *dev = video_drvdata(file);
>> +	struct vchiq_mmal_port *preview_port =
>> +		    &dev->component[MMAL_COMPONENT_CAMERA]->
>> +		    output[MMAL_CAMERA_PORT_PREVIEW];
>> +
>> +	a->capability = V4L2_FBUF_CAP_EXTERNOVERLAY |
>> +			V4L2_FBUF_CAP_GLOBAL_ALPHA;
>> +	a->flags = V4L2_FBUF_FLAG_OVERLAY;
>> +	a->fmt.width = preview_port->es.video.width;
>> +	a->fmt.height = preview_port->es.video.height;
>> +	a->fmt.pixelformat = V4L2_PIX_FMT_YUV420;
>> +	a->fmt.bytesperline = preview_port->es.video.width;
>> +	a->fmt.sizeimage = (preview_port->es.video.width *
>> +			       preview_port->es.video.height * 3)>>1;
>> +	a->fmt.colorspace = V4L2_COLORSPACE_SMPTE170M;
>> +
>> +	return 0;
>> +}
>> +
>> +/* input ioctls */
>> +static int vidioc_enum_input(struct file *file, void *priv,
>> +			     struct v4l2_input *inp)
>> +{
>> +	/* only a single camera input */
>> +	if (inp->index != 0)
>> +		return -EINVAL;
>> +
>> +	inp->type = V4L2_INPUT_TYPE_CAMERA;
>> +	sprintf(inp->name, "Camera %u", inp->index);
>> +	return 0;
>> +}
>> +
>> +static int vidioc_g_input(struct file *file, void *priv, unsigned int *i)
>> +{
>> +	*i = 0;
>> +	return 0;
>> +}
>> +
>> +static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
>> +{
>> +	if (i != 0)
>> +		return -EINVAL;
>> +
>> +	return 0;
>> +}
>> +
>> +/* capture ioctls */
>> +static int vidioc_querycap(struct file *file, void *priv,
>> +			   struct v4l2_capability *cap)
>> +{
>> +	struct bm2835_mmal_dev *dev = video_drvdata(file);
>> +	u32 major;
>> +	u32 minor;
>> +
>> +	vchiq_mmal_version(dev->instance, &major, &minor);
>> +
>> +	strcpy(cap->driver, "bm2835 mmal");
>
> Use strlcpy.
>
>> +	snprintf(cap->card, sizeof(cap->card), "mmal service %d.%d",
>> +		 major, minor);
>> +
>> +	snprintf(cap->bus_info, sizeof(cap->bus_info),
>> +		 "platform:%s", dev->v4l2_dev.name);
>> +	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OVERLAY |
>> +	    V4L2_CAP_STREAMING | V4L2_CAP_READWRITE;
>> +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
>
> Don't set device_caps and capabilities. Instead set the device_caps field of
> struct video_device to what you use here in cap->device_caps. The core will
> fill in these two cap fields for you based on vdev->device_caps.

OK

>> +
>> +	return 0;
>> +}
>> +
>> +static int vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
>> +				   struct v4l2_fmtdesc *f)
>> +{
>> +	struct mmal_fmt *fmt;
>> +
>> +	if (f->index >= ARRAY_SIZE(formats))
>> +		return -EINVAL;
>> +
>> +	fmt = &formats[f->index];
>> +
>> +	strlcpy(f->description, fmt->name, sizeof(f->description));
>
> Drop this.
>
>> +	f->pixelformat = fmt->fourcc;
>> +	f->flags = fmt->flags;
>> +
>> +	return 0;
>> +}
>> +
>> +static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
>> +				struct v4l2_format *f)
>> +{
>> +	struct bm2835_mmal_dev *dev = video_drvdata(file);
>> +
>> +	f->fmt.pix.width = dev->capture.width;
>> +	f->fmt.pix.height = dev->capture.height;
>> +	f->fmt.pix.field = V4L2_FIELD_NONE;
>> +	f->fmt.pix.pixelformat = dev->capture.fmt->fourcc;
>> +	f->fmt.pix.bytesperline = dev->capture.stride;
>> +	f->fmt.pix.sizeimage = dev->capture.buffersize;
>> +
>> +	if (dev->capture.fmt->fourcc == V4L2_PIX_FMT_RGB24)
>> +		f->fmt.pix.colorspace = V4L2_COLORSPACE_SRGB;
>> +	else if (dev->capture.fmt->fourcc == V4L2_PIX_FMT_JPEG)
>> +		f->fmt.pix.colorspace = V4L2_COLORSPACE_JPEG;
>> +	else
>> +		f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
>
> Colorspace has nothing to do with the pixel format. It should come from the
> sensor/video receiver.
>
> If this information is not available, then COLORSPACE_SRGB is generally a
> good fallback.

I would if I could, but then I fail v4l2-compliance on V4L2_PIX_FMT_JPEG
https://git.linuxtv.org/v4l-utils.git/tree/utils/v4l2-compliance/v4l2-test-formats.cpp#n329
The special case for JPEG therefore has to remain.

It looks like I tripped over the subtlety between V4L2_COLORSPACE_, 
V4L2_XFER_FUNC_, V4L2_YCBCR_ENC_, and V4L2_QUANTIZATION_, and Y'CbCr 
encoding vs colourspace.

The ISP coefficients are set up for BT601 limited range, and any 
conversion back to RGB is done based on that. That seemed to fit 
SMPTE170M rather than SRGB.

I do note that as there is now support for more RGB formats (BGR24 and 
BGR32) the first "if" needs extending to cover those. Or I don't care 
and only special case JPEG with all others just reporting SRGB.

>> +	f->fmt.pix.priv = 0;
>
> Drop this line, it's no longer needed.
>
>> +
>> +	v4l2_dump_pix_format(1, bcm2835_v4l2_debug, &dev->v4l2_dev, &f->fmt.pix,
>> +			     __func__);
>> +	return 0;
>> +}
>> +
>> +static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
>> +				  struct v4l2_format *f)
>> +{
>> +	struct bm2835_mmal_dev *dev = video_drvdata(file);
>> +	struct mmal_fmt *mfmt;
>> +
>> +	mfmt = get_format(f);
>> +	if (!mfmt) {
>> +		v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
>> +			 "Fourcc format (0x%08x) unknown.\n",
>> +			 f->fmt.pix.pixelformat);
>> +		f->fmt.pix.pixelformat = formats[0].fourcc;
>> +		mfmt = get_format(f);
>> +	}
>> +
>> +	f->fmt.pix.field = V4L2_FIELD_NONE;
>> +
>> +	v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
>> +		"Clipping/aligning %dx%d format %08X\n",
>> +		f->fmt.pix.width, f->fmt.pix.height, f->fmt.pix.pixelformat);
>> +
>> +	v4l_bound_align_image(&f->fmt.pix.width, MIN_WIDTH, dev->max_width, 1,
>> +			      &f->fmt.pix.height, MIN_HEIGHT, dev->max_height,
>> +			      1, 0);
>> +	f->fmt.pix.bytesperline = f->fmt.pix.width * mfmt->ybbp;
>> +
>> +	/* Image buffer has to be padded to allow for alignment, even though
>> +	 * we then remove that padding before delivering the buffer.
>> +	 */
>> +	f->fmt.pix.sizeimage = ((f->fmt.pix.height+15)&~15) *
>> +			(((f->fmt.pix.width+31)&~31) * mfmt->depth) >> 3;
>> +
>> +	if ((mfmt->flags & V4L2_FMT_FLAG_COMPRESSED) &&
>> +	    f->fmt.pix.sizeimage < MIN_BUFFER_SIZE)
>> +		f->fmt.pix.sizeimage = MIN_BUFFER_SIZE;
>> +
>> +	if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_RGB24)
>> +		f->fmt.pix.colorspace = V4L2_COLORSPACE_SRGB;
>> +	else if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_JPEG)
>> +		f->fmt.pix.colorspace = V4L2_COLORSPACE_JPEG;
>> +	else
>> +		f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
>
> See earlier comment.
>
>> +	f->fmt.pix.priv = 0;
>
> Drop this.
>
>> +
>> +	v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
>> +		"Now %dx%d format %08X\n",
>> +		f->fmt.pix.width, f->fmt.pix.height, f->fmt.pix.pixelformat);
>> +
>> +	v4l2_dump_pix_format(1, bcm2835_v4l2_debug, &dev->v4l2_dev, &f->fmt.pix,
>> +			     __func__);
>> +	return 0;
>> +}
>> +
>> +static int mmal_setup_components(struct bm2835_mmal_dev *dev,
>> +				 struct v4l2_format *f)
>> +{
>> +	int ret;
>> +	struct vchiq_mmal_port *port = NULL, *camera_port = NULL;
>> +	struct vchiq_mmal_component *encode_component = NULL;
>> +	struct mmal_fmt *mfmt = get_format(f);
>> +
>> +	BUG_ON(!mfmt);
>> +
>> +	if (dev->capture.encode_component) {
>> +		v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
>> +			 "vid_cap - disconnect previous tunnel\n");
>> +
>> +		/* Disconnect any previous connection */
>> +		vchiq_mmal_port_connect_tunnel(dev->instance,
>> +					       dev->capture.camera_port, NULL);
>> +		dev->capture.camera_port = NULL;
>> +		ret = vchiq_mmal_component_disable(dev->instance,
>> +						   dev->capture.
>> +						   encode_component);
>> +		if (ret)
>> +			v4l2_err(&dev->v4l2_dev,
>> +				 "Failed to disable encode component %d\n",
>> +				 ret);
>> +
>> +		dev->capture.encode_component = NULL;
>> +	}
>> +	/* format dependant port setup */
>> +	switch (mfmt->mmal_component) {
>> +	case MMAL_COMPONENT_CAMERA:
>> +		/* Make a further decision on port based on resolution */
>> +		if (f->fmt.pix.width <= max_video_width
>> +		    && f->fmt.pix.height <= max_video_height)
>> +			camera_port = port =
>> +			    &dev->component[MMAL_COMPONENT_CAMERA]->
>> +			    output[MMAL_CAMERA_PORT_VIDEO];
>> +		else
>> +			camera_port = port =
>> +			    &dev->component[MMAL_COMPONENT_CAMERA]->
>> +			    output[MMAL_CAMERA_PORT_CAPTURE];
>> +		break;
>> +	case MMAL_COMPONENT_IMAGE_ENCODE:
>> +		encode_component = dev->component[MMAL_COMPONENT_IMAGE_ENCODE];
>> +		port = &dev->component[MMAL_COMPONENT_IMAGE_ENCODE]->output[0];
>> +		camera_port =
>> +		    &dev->component[MMAL_COMPONENT_CAMERA]->
>> +		    output[MMAL_CAMERA_PORT_CAPTURE];
>> +		break;
>> +	case MMAL_COMPONENT_VIDEO_ENCODE:
>> +		encode_component = dev->component[MMAL_COMPONENT_VIDEO_ENCODE];
>> +		port = &dev->component[MMAL_COMPONENT_VIDEO_ENCODE]->output[0];
>> +		camera_port =
>> +		    &dev->component[MMAL_COMPONENT_CAMERA]->
>> +		    output[MMAL_CAMERA_PORT_VIDEO];
>> +		break;
>> +	default:
>> +		break;
>> +	}
>> +
>> +	if (!port)
>> +		return -EINVAL;
>> +
>> +	if (encode_component)
>> +		camera_port->format.encoding = MMAL_ENCODING_OPAQUE;
>> +	else
>> +		camera_port->format.encoding = mfmt->mmal;
>> +
>> +	if (dev->rgb_bgr_swapped) {
>> +		if (camera_port->format.encoding == MMAL_ENCODING_RGB24)
>> +			camera_port->format.encoding = MMAL_ENCODING_BGR24;
>> +		else if (camera_port->format.encoding == MMAL_ENCODING_BGR24)
>> +			camera_port->format.encoding = MMAL_ENCODING_RGB24;
>> +	}
>> +
>> +	camera_port->format.encoding_variant = 0;
>> +	camera_port->es.video.width = f->fmt.pix.width;
>> +	camera_port->es.video.height = f->fmt.pix.height;
>> +	camera_port->es.video.crop.x = 0;
>> +	camera_port->es.video.crop.y = 0;
>> +	camera_port->es.video.crop.width = f->fmt.pix.width;
>> +	camera_port->es.video.crop.height = f->fmt.pix.height;
>> +	camera_port->es.video.frame_rate.num = 0;
>> +	camera_port->es.video.frame_rate.den = 1;
>> +	camera_port->es.video.color_space = MMAL_COLOR_SPACE_JPEG_JFIF;
>> +
>> +	ret = vchiq_mmal_port_set_format(dev->instance, camera_port);
>> +
>> +	if (!ret
>> +	    && camera_port ==
>> +	    &dev->component[MMAL_COMPONENT_CAMERA]->
>> +	    output[MMAL_CAMERA_PORT_VIDEO]) {
>> +		bool overlay_enabled =
>> +		    !!dev->component[MMAL_COMPONENT_PREVIEW]->enabled;
>> +		struct vchiq_mmal_port *preview_port =
>> +		    &dev->component[MMAL_COMPONENT_CAMERA]->
>> +		    output[MMAL_CAMERA_PORT_PREVIEW];
>> +		/* Preview and encode ports need to match on resolution */
>> +		if (overlay_enabled) {
>> +			/* Need to disable the overlay before we can update
>> +			 * the resolution
>> +			 */
>> +			ret =
>> +			    vchiq_mmal_port_disable(dev->instance,
>> +						    preview_port);
>> +			if (!ret)
>> +				ret =
>> +				    vchiq_mmal_port_connect_tunnel(
>> +						dev->instance,
>> +						preview_port,
>> +						NULL);
>> +		}
>> +		preview_port->es.video.width = f->fmt.pix.width;
>> +		preview_port->es.video.height = f->fmt.pix.height;
>> +		preview_port->es.video.crop.x = 0;
>> +		preview_port->es.video.crop.y = 0;
>> +		preview_port->es.video.crop.width = f->fmt.pix.width;
>> +		preview_port->es.video.crop.height = f->fmt.pix.height;
>> +		preview_port->es.video.frame_rate.num =
>> +					  dev->capture.timeperframe.denominator;
>> +		preview_port->es.video.frame_rate.den =
>> +					  dev->capture.timeperframe.numerator;
>> +		ret = vchiq_mmal_port_set_format(dev->instance, preview_port);
>> +		if (overlay_enabled) {
>> +			ret = vchiq_mmal_port_connect_tunnel(
>> +				dev->instance,
>> +				preview_port,
>> +				&dev->component[MMAL_COMPONENT_PREVIEW]->input[0]);
>> +			if (!ret)
>> +				ret = vchiq_mmal_port_enable(dev->instance,
>> +							     preview_port,
>> +							     NULL);
>> +		}
>> +	}
>> +
>> +	if (ret) {
>> +		v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
>> +			 "%s failed to set format %dx%d %08X\n", __func__,
>> +			 f->fmt.pix.width, f->fmt.pix.height,
>> +			 f->fmt.pix.pixelformat);
>> +		/* ensure capture is not going to be tried */
>> +		dev->capture.port = NULL;
>> +	} else {
>> +		if (encode_component) {
>> +			v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
>> +				 "vid_cap - set up encode comp\n");
>> +
>> +			/* configure buffering */
>> +			camera_port->current_buffer.size =
>> +			    camera_port->recommended_buffer.size;
>> +			camera_port->current_buffer.num =
>> +			    camera_port->recommended_buffer.num;
>> +
>> +			ret =
>> +			    vchiq_mmal_port_connect_tunnel(
>> +					dev->instance,
>> +					camera_port,
>> +					&encode_component->input[0]);
>> +			if (ret) {
>> +				v4l2_dbg(1, bcm2835_v4l2_debug,
>> +					 &dev->v4l2_dev,
>> +					 "%s failed to create connection\n",
>> +					 __func__);
>> +				/* ensure capture is not going to be tried */
>> +				dev->capture.port = NULL;
>> +			} else {
>> +				port->es.video.width = f->fmt.pix.width;
>> +				port->es.video.height = f->fmt.pix.height;
>> +				port->es.video.crop.x = 0;
>> +				port->es.video.crop.y = 0;
>> +				port->es.video.crop.width = f->fmt.pix.width;
>> +				port->es.video.crop.height = f->fmt.pix.height;
>> +				port->es.video.frame_rate.num =
>> +					  dev->capture.timeperframe.denominator;
>> +				port->es.video.frame_rate.den =
>> +					  dev->capture.timeperframe.numerator;
>> +
>> +				port->format.encoding = mfmt->mmal;
>> +				port->format.encoding_variant = 0;
>> +				/* Set any encoding specific parameters */
>> +				switch (mfmt->mmal_component) {
>> +				case MMAL_COMPONENT_VIDEO_ENCODE:
>> +					port->format.bitrate =
>> +					    dev->capture.encode_bitrate;
>> +					break;
>> +				case MMAL_COMPONENT_IMAGE_ENCODE:
>> +					/* Could set EXIF parameters here */
>> +					break;
>> +				default:
>> +					break;
>> +				}
>> +				ret = vchiq_mmal_port_set_format(dev->instance,
>> +								 port);
>> +				if (ret)
>> +					v4l2_dbg(1, bcm2835_v4l2_debug,
>> +						 &dev->v4l2_dev,
>> +						 "%s failed to set format %dx%d fmt %08X\n",
>> +						 __func__,
>> +						 f->fmt.pix.width,
>> +						 f->fmt.pix.height,
>> +						 f->fmt.pix.pixelformat
>> +						 );
>> +			}
>> +
>> +			if (!ret) {
>> +				ret = vchiq_mmal_component_enable(
>> +						dev->instance,
>> +						encode_component);
>> +				if (ret) {
>> +					v4l2_dbg(1, bcm2835_v4l2_debug,
>> +					   &dev->v4l2_dev,
>> +					   "%s Failed to enable encode components\n",
>> +					   __func__);
>> +				}
>> +			}
>> +			if (!ret) {
>> +				/* configure buffering */
>> +				port->current_buffer.num = 1;
>> +				port->current_buffer.size =
>> +				    f->fmt.pix.sizeimage;
>> +				if (port->format.encoding ==
>> +				    MMAL_ENCODING_JPEG) {
>> +					v4l2_dbg(1, bcm2835_v4l2_debug,
>> +					    &dev->v4l2_dev,
>> +					    "JPG - buf size now %d was %d\n",
>> +					    f->fmt.pix.sizeimage,
>> +					    port->current_buffer.size);
>> +					port->current_buffer.size =
>> +					    (f->fmt.pix.sizeimage <
>> +					     (100 << 10))
>> +					    ? (100 << 10) : f->fmt.pix.
>> +					    sizeimage;
>> +				}
>> +				v4l2_dbg(1, bcm2835_v4l2_debug,
>> +					 &dev->v4l2_dev,
>> +					 "vid_cap - cur_buf.size set to %d\n",
>> +					 f->fmt.pix.sizeimage);
>> +				port->current_buffer.alignment = 0;
>> +			}
>> +		} else {
>> +			/* configure buffering */
>> +			camera_port->current_buffer.num = 1;
>> +			camera_port->current_buffer.size = f->fmt.pix.sizeimage;
>> +			camera_port->current_buffer.alignment = 0;
>> +		}
>> +
>> +		if (!ret) {
>> +			dev->capture.fmt = mfmt;
>> +			dev->capture.stride = f->fmt.pix.bytesperline;
>> +			dev->capture.width = camera_port->es.video.crop.width;
>> +			dev->capture.height = camera_port->es.video.crop.height;
>> +			dev->capture.buffersize = port->current_buffer.size;
>> +
>> +			/* select port for capture */
>> +			dev->capture.port = port;
>> +			dev->capture.camera_port = camera_port;
>> +			dev->capture.encode_component = encode_component;
>> +			v4l2_dbg(1, bcm2835_v4l2_debug,
>> +				 &dev->v4l2_dev,
>> +				"Set dev->capture.fmt %08X, %dx%d, stride %d, size %d",
>> +				port->format.encoding,
>> +				dev->capture.width, dev->capture.height,
>> +				dev->capture.stride, dev->capture.buffersize);
>> +		}
>> +	}
>> +
>> +	/* todo: Need to convert the vchiq/mmal error into a v4l2 error. */
>> +	return ret;
>> +}
>> +
>> +static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
>> +				struct v4l2_format *f)
>> +{
>> +	int ret;
>> +	struct bm2835_mmal_dev *dev = video_drvdata(file);
>> +	struct mmal_fmt *mfmt;
>> +
>> +	/* try the format to set valid parameters */
>> +	ret = vidioc_try_fmt_vid_cap(file, priv, f);
>> +	if (ret) {
>> +		v4l2_err(&dev->v4l2_dev,
>> +			 "vid_cap - vidioc_try_fmt_vid_cap failed\n");
>> +		return ret;
>> +	}
>> +
>> +	/* if a capture is running refuse to set format */
>> +	if (vb2_is_busy(&dev->capture.vb_vidq)) {
>> +		v4l2_info(&dev->v4l2_dev, "%s device busy\n", __func__);
>> +		return -EBUSY;
>> +	}
>> +
>> +	/* If the format is unsupported v4l2 says we should switch to
>> +	 * a supported one and not return an error. */
>> +	mfmt = get_format(f);
>> +	if (!mfmt) {
>> +		v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
>> +			 "Fourcc format (0x%08x) unknown.\n",
>> +			 f->fmt.pix.pixelformat);
>> +		f->fmt.pix.pixelformat = formats[0].fourcc;
>> +		mfmt = get_format(f);
>> +	}
>> +
>> +	ret = mmal_setup_components(dev, f);
>> +	if (ret != 0) {
>> +		v4l2_err(&dev->v4l2_dev,
>> +			 "%s: failed to setup mmal components: %d\n",
>> +			 __func__, ret);
>> +		ret = -EINVAL;
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +int vidioc_enum_framesizes(struct file *file, void *fh,
>> +			   struct v4l2_frmsizeenum *fsize)
>> +{
>> +	struct bm2835_mmal_dev *dev = video_drvdata(file);
>> +	static const struct v4l2_frmsize_stepwise sizes = {
>> +		MIN_WIDTH, 0, 2,
>> +		MIN_HEIGHT, 0, 2
>> +	};
>> +	int i;
>> +
>> +	if (fsize->index)
>> +		return -EINVAL;
>> +	for (i = 0; i < ARRAY_SIZE(formats); i++)
>> +		if (formats[i].fourcc == fsize->pixel_format)
>> +			break;
>> +	if (i == ARRAY_SIZE(formats))
>> +		return -EINVAL;
>> +	fsize->type = V4L2_FRMSIZE_TYPE_STEPWISE;
>> +	fsize->stepwise = sizes;
>> +	fsize->stepwise.max_width = dev->max_width;
>> +	fsize->stepwise.max_height = dev->max_height;
>> +	return 0;
>> +}
>> +
>> +/* timeperframe is arbitrary and continous */
>> +static int vidioc_enum_frameintervals(struct file *file, void *priv,
>> +					     struct v4l2_frmivalenum *fival)
>> +{
>> +	struct bm2835_mmal_dev *dev = video_drvdata(file);
>> +	int i;
>> +
>> +	if (fival->index)
>> +		return -EINVAL;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(formats); i++)
>> +		if (formats[i].fourcc == fival->pixel_format)
>> +			break;
>> +	if (i == ARRAY_SIZE(formats))
>> +		return -EINVAL;
>> +
>> +	/* regarding width & height - we support any within range */
>> +	if (fival->width < MIN_WIDTH || fival->width > dev->max_width ||
>> +	    fival->height < MIN_HEIGHT || fival->height > dev->max_height)
>> +		return -EINVAL;
>> +
>> +	fival->type = V4L2_FRMIVAL_TYPE_CONTINUOUS;
>> +
>> +	/* fill in stepwise (step=1.0 is requred by V4L2 spec) */
>> +	fival->stepwise.min  = tpf_min;
>> +	fival->stepwise.max  = tpf_max;
>> +	fival->stepwise.step = (struct v4l2_fract) {1, 1};
>> +
>> +	return 0;
>> +}
>> +
>> +static int vidioc_g_parm(struct file *file, void *priv,
>> +			  struct v4l2_streamparm *parm)
>> +{
>> +	struct bm2835_mmal_dev *dev = video_drvdata(file);
>> +
>> +	if (parm->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
>> +		return -EINVAL;
>> +
>> +	parm->parm.capture.capability   = V4L2_CAP_TIMEPERFRAME;
>> +	parm->parm.capture.timeperframe = dev->capture.timeperframe;
>> +	parm->parm.capture.readbuffers  = 1;
>> +	return 0;
>> +}
>> +
>> +#define FRACT_CMP(a, OP, b)	\
>> +	((u64)(a).numerator * (b).denominator  OP  \
>> +	 (u64)(b).numerator * (a).denominator)
>> +
>> +static int vidioc_s_parm(struct file *file, void *priv,
>> +			  struct v4l2_streamparm *parm)
>> +{
>> +	struct bm2835_mmal_dev *dev = video_drvdata(file);
>> +	struct v4l2_fract tpf;
>> +	struct mmal_parameter_rational fps_param;
>> +
>> +	if (parm->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
>> +		return -EINVAL;
>> +
>> +	tpf = parm->parm.capture.timeperframe;
>> +
>> +	/* tpf: {*, 0} resets timing; clip to [min, max]*/
>> +	tpf = tpf.denominator ? tpf : tpf_default;
>> +	tpf = FRACT_CMP(tpf, <, tpf_min) ? tpf_min : tpf;
>> +	tpf = FRACT_CMP(tpf, >, tpf_max) ? tpf_max : tpf;
>> +
>> +	dev->capture.timeperframe = tpf;
>> +	parm->parm.capture.timeperframe = tpf;
>> +	parm->parm.capture.readbuffers  = 1;
>> +	parm->parm.capture.capability   = V4L2_CAP_TIMEPERFRAME;
>> +
>> +	fps_param.num = 0;	/* Select variable fps, and then use
>> +				 * FPS_RANGE to select the actual limits.
>> +				 */
>> +	fps_param.den = 1;
>> +	set_framerate_params(dev);
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct v4l2_ioctl_ops camera0_ioctl_ops = {
>> +	/* overlay */
>> +	.vidioc_enum_fmt_vid_overlay = vidioc_enum_fmt_vid_overlay,
>> +	.vidioc_g_fmt_vid_overlay = vidioc_g_fmt_vid_overlay,
>> +	.vidioc_try_fmt_vid_overlay = vidioc_try_fmt_vid_overlay,
>> +	.vidioc_s_fmt_vid_overlay = vidioc_s_fmt_vid_overlay,
>> +	.vidioc_overlay = vidioc_overlay,
>> +	.vidioc_g_fbuf = vidioc_g_fbuf,
>> +
>> +	/* inputs */
>> +	.vidioc_enum_input = vidioc_enum_input,
>> +	.vidioc_g_input = vidioc_g_input,
>> +	.vidioc_s_input = vidioc_s_input,
>> +
>> +	/* capture */
>> +	.vidioc_querycap = vidioc_querycap,
>> +	.vidioc_enum_fmt_vid_cap = vidioc_enum_fmt_vid_cap,
>> +	.vidioc_g_fmt_vid_cap = vidioc_g_fmt_vid_cap,
>> +	.vidioc_try_fmt_vid_cap = vidioc_try_fmt_vid_cap,
>> +	.vidioc_s_fmt_vid_cap = vidioc_s_fmt_vid_cap,
>> +
>> +	/* buffer management */
>> +	.vidioc_reqbufs = vb2_ioctl_reqbufs,
>> +	.vidioc_create_bufs = vb2_ioctl_create_bufs,
>> +	.vidioc_prepare_buf = vb2_ioctl_prepare_buf,
>> +	.vidioc_querybuf = vb2_ioctl_querybuf,
>> +	.vidioc_qbuf = vb2_ioctl_qbuf,
>> +	.vidioc_dqbuf = vb2_ioctl_dqbuf,
>> +	.vidioc_enum_framesizes = vidioc_enum_framesizes,
>> +	.vidioc_enum_frameintervals = vidioc_enum_frameintervals,
>> +	.vidioc_g_parm        = vidioc_g_parm,
>> +	.vidioc_s_parm        = vidioc_s_parm,
>> +	.vidioc_streamon = vb2_ioctl_streamon,
>> +	.vidioc_streamoff = vb2_ioctl_streamoff,
>> +
>> +	.vidioc_log_status = v4l2_ctrl_log_status,
>> +	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
>> +	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
>> +};
>> +
>> +static const struct v4l2_ioctl_ops camera0_ioctl_ops_gstreamer = {
>> +	/* overlay */
>> +	.vidioc_enum_fmt_vid_overlay = vidioc_enum_fmt_vid_overlay,
>> +	.vidioc_g_fmt_vid_overlay = vidioc_g_fmt_vid_overlay,
>> +	.vidioc_try_fmt_vid_overlay = vidioc_try_fmt_vid_overlay,
>> +	.vidioc_s_fmt_vid_overlay = vidioc_s_fmt_vid_overlay,
>> +	.vidioc_overlay = vidioc_overlay,
>> +	.vidioc_g_fbuf = vidioc_g_fbuf,
>> +
>> +	/* inputs */
>> +	.vidioc_enum_input = vidioc_enum_input,
>> +	.vidioc_g_input = vidioc_g_input,
>> +	.vidioc_s_input = vidioc_s_input,
>> +
>> +	/* capture */
>> +	.vidioc_querycap = vidioc_querycap,
>> +	.vidioc_enum_fmt_vid_cap = vidioc_enum_fmt_vid_cap,
>> +	.vidioc_g_fmt_vid_cap = vidioc_g_fmt_vid_cap,
>> +	.vidioc_try_fmt_vid_cap = vidioc_try_fmt_vid_cap,
>> +	.vidioc_s_fmt_vid_cap = vidioc_s_fmt_vid_cap,
>> +
>> +	/* buffer management */
>> +	.vidioc_reqbufs = vb2_ioctl_reqbufs,
>> +	.vidioc_create_bufs = vb2_ioctl_create_bufs,
>> +	.vidioc_prepare_buf = vb2_ioctl_prepare_buf,
>> +	.vidioc_querybuf = vb2_ioctl_querybuf,
>> +	.vidioc_qbuf = vb2_ioctl_qbuf,
>> +	.vidioc_dqbuf = vb2_ioctl_dqbuf,
>> +	/* Remove this function ptr to fix gstreamer bug
>> +	.vidioc_enum_framesizes = vidioc_enum_framesizes, */
>> +	.vidioc_enum_frameintervals = vidioc_enum_frameintervals,
>> +	.vidioc_g_parm        = vidioc_g_parm,
>> +	.vidioc_s_parm        = vidioc_s_parm,
>> +	.vidioc_streamon = vb2_ioctl_streamon,
>> +	.vidioc_streamoff = vb2_ioctl_streamoff,
>> +
>> +	.vidioc_log_status = v4l2_ctrl_log_status,
>> +	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
>> +	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
>> +};
>> +
>> +/* ------------------------------------------------------------------
>> +	Driver init/finalise
>> +   ------------------------------------------------------------------*/
>> +
>> +static const struct v4l2_file_operations camera0_fops = {
>> +	.owner = THIS_MODULE,
>> +	.open = v4l2_fh_open,
>> +	.release = vb2_fop_release,
>> +	.read = vb2_fop_read,
>> +	.poll = vb2_fop_poll,
>> +	.unlocked_ioctl = video_ioctl2,	/* V4L2 ioctl handler */
>> +	.mmap = vb2_fop_mmap,
>> +};
>> +
>> +static struct video_device vdev_template = {
>> +	.name = "camera0",
>> +	.fops = &camera0_fops,
>> +	.ioctl_ops = &camera0_ioctl_ops,
>> +	.release = video_device_release_empty,
>> +};
>> +
>> +/* Returns the number of cameras, and also the max resolution supported
>> + * by those cameras.
>> + */
>> +static int get_num_cameras(struct vchiq_mmal_instance *instance,
>> +	unsigned int resolutions[][2], int num_resolutions)
>> +{
>> +	int ret;
>> +	struct vchiq_mmal_component  *cam_info_component;
>> +	struct mmal_parameter_camera_info_t cam_info = {0};
>> +	int param_size = sizeof(cam_info);
>> +	int i;
>> +
>> +	/* create a camera_info component */
>> +	ret = vchiq_mmal_component_init(instance, "camera_info",
>> +					&cam_info_component);
>> +	if (ret < 0)
>> +		/* Unusual failure - let's guess one camera. */
>> +		return 1;
>> +
>> +	if (vchiq_mmal_port_parameter_get(instance,
>> +					  &cam_info_component->control,
>> +					  MMAL_PARAMETER_CAMERA_INFO,
>> +					  &cam_info,
>> +					  &param_size)) {
>> +		pr_info("Failed to get camera info\n");
>> +	}
>> +	for (i = 0;
>> +	     i < (cam_info.num_cameras > num_resolutions ?
>> +			num_resolutions :
>> +			cam_info.num_cameras);
>> +	     i++) {
>> +		resolutions[i][0] = cam_info.cameras[i].max_width;
>> +		resolutions[i][1] = cam_info.cameras[i].max_height;
>> +	}
>> +
>> +	vchiq_mmal_component_finalise(instance,
>> +				      cam_info_component);
>> +
>> +	return cam_info.num_cameras;
>> +}
>> +
>> +static int set_camera_parameters(struct vchiq_mmal_instance *instance,
>> +				 struct vchiq_mmal_component *camera,
>> +				 struct bm2835_mmal_dev *dev)
>> +{
>> +	int ret;
>> +	struct mmal_parameter_camera_config cam_config = {
>> +		.max_stills_w = dev->max_width,
>> +		.max_stills_h = dev->max_height,
>> +		.stills_yuv422 = 1,
>> +		.one_shot_stills = 1,
>> +		.max_preview_video_w = (max_video_width > 1920) ?
>> +						max_video_width : 1920,
>> +		.max_preview_video_h = (max_video_height > 1088) ?
>> +						max_video_height : 1088,
>> +		.num_preview_video_frames = 3,
>> +		.stills_capture_circular_buffer_height = 0,
>> +		.fast_preview_resume = 0,
>> +		.use_stc_timestamp = MMAL_PARAM_TIMESTAMP_MODE_RAW_STC
>> +	};
>> +
>> +	ret = vchiq_mmal_port_parameter_set(instance, &camera->control,
>> +					    MMAL_PARAMETER_CAMERA_CONFIG,
>> +					    &cam_config, sizeof(cam_config));
>> +	return ret;
>> +}
>> +
>> +#define MAX_SUPPORTED_ENCODINGS 20
>> +
>> +/* MMAL instance and component init */
>> +static int __init mmal_init(struct bm2835_mmal_dev *dev)
>> +{
>> +	int ret;
>> +	struct mmal_es_format *format;
>> +	u32 bool_true = 1;
>> +	u32 supported_encodings[MAX_SUPPORTED_ENCODINGS];
>> +	int param_size;
>> +	struct vchiq_mmal_component  *camera;
>> +
>> +	ret = vchiq_mmal_init(&dev->instance);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	/* get the camera component ready */
>> +	ret = vchiq_mmal_component_init(dev->instance, "ril.camera",
>> +					&dev->component[MMAL_COMPONENT_CAMERA]);
>> +	if (ret < 0)
>> +		goto unreg_mmal;
>> +
>> +	camera = dev->component[MMAL_COMPONENT_CAMERA];
>> +	if (camera->outputs <  MMAL_CAMERA_PORT_COUNT) {
>> +		ret = -EINVAL;
>> +		goto unreg_camera;
>> +	}
>> +
>> +	ret = set_camera_parameters(dev->instance,
>> +				    camera,
>> +				    dev);
>> +	if (ret < 0)
>> +		goto unreg_camera;
>> +
>> +	/* There was an error in the firmware that meant the camera component
>> +	 * produced BGR instead of RGB.
>> +	 * This is now fixed, but in order to support the old firmwares, we
>> +	 * have to check.
>> +	 */
>> +	dev->rgb_bgr_swapped = true;
>> +	param_size = sizeof(supported_encodings);
>> +	ret = vchiq_mmal_port_parameter_get(dev->instance,
>> +		&camera->output[MMAL_CAMERA_PORT_CAPTURE],
>> +		MMAL_PARAMETER_SUPPORTED_ENCODINGS,
>> +		&supported_encodings,
>> +		&param_size);
>> +	if (ret == 0) {
>> +		int i;
>> +
>> +		for (i = 0; i < param_size/sizeof(u32); i++) {
>> +			if (supported_encodings[i] == MMAL_ENCODING_BGR24) {
>> +				/* Found BGR24 first - old firmware. */
>> +				break;
>> +			}
>> +			if (supported_encodings[i] == MMAL_ENCODING_RGB24) {
>> +				/* Found RGB24 first
>> +				 * new firmware, so use RGB24.
>> +				 */
>> +				dev->rgb_bgr_swapped = false;
>> +			break;
>> +			}
>> +		}
>> +	}
>> +	format = &camera->output[MMAL_CAMERA_PORT_PREVIEW].format;
>> +
>> +	format->encoding = MMAL_ENCODING_OPAQUE;
>> +	format->encoding_variant = MMAL_ENCODING_I420;
>> +
>> +	format->es->video.width = 1024;
>> +	format->es->video.height = 768;
>> +	format->es->video.crop.x = 0;
>> +	format->es->video.crop.y = 0;
>> +	format->es->video.crop.width = 1024;
>> +	format->es->video.crop.height = 768;
>> +	format->es->video.frame_rate.num = 0; /* Rely on fps_range */
>> +	format->es->video.frame_rate.den = 1;
>> +
>> +	format = &camera->output[MMAL_CAMERA_PORT_VIDEO].format;
>> +
>> +	format->encoding = MMAL_ENCODING_OPAQUE;
>> +	format->encoding_variant = MMAL_ENCODING_I420;
>> +
>> +	format->es->video.width = 1024;
>> +	format->es->video.height = 768;
>> +	format->es->video.crop.x = 0;
>> +	format->es->video.crop.y = 0;
>> +	format->es->video.crop.width = 1024;
>> +	format->es->video.crop.height = 768;
>> +	format->es->video.frame_rate.num = 0; /* Rely on fps_range */
>> +	format->es->video.frame_rate.den = 1;
>> +
>> +	vchiq_mmal_port_parameter_set(dev->instance,
>> +		&camera->output[MMAL_CAMERA_PORT_VIDEO],
>> +		MMAL_PARAMETER_NO_IMAGE_PADDING,
>> +		&bool_true, sizeof(bool_true));
>> +
>> +	format = &camera->output[MMAL_CAMERA_PORT_CAPTURE].format;
>> +
>> +	format->encoding = MMAL_ENCODING_OPAQUE;
>> +
>> +	format->es->video.width = 2592;
>> +	format->es->video.height = 1944;
>> +	format->es->video.crop.x = 0;
>> +	format->es->video.crop.y = 0;
>> +	format->es->video.crop.width = 2592;
>> +	format->es->video.crop.height = 1944;
>> +	format->es->video.frame_rate.num = 0; /* Rely on fps_range */
>> +	format->es->video.frame_rate.den = 1;
>> +
>> +	dev->capture.width = format->es->video.width;
>> +	dev->capture.height = format->es->video.height;
>> +	dev->capture.fmt = &formats[0];
>> +	dev->capture.encode_component = NULL;
>> +	dev->capture.timeperframe = tpf_default;
>> +	dev->capture.enc_profile = V4L2_MPEG_VIDEO_H264_PROFILE_HIGH;
>> +	dev->capture.enc_level = V4L2_MPEG_VIDEO_H264_LEVEL_4_0;
>> +
>> +	vchiq_mmal_port_parameter_set(dev->instance,
>> +		&camera->output[MMAL_CAMERA_PORT_CAPTURE],
>> +		MMAL_PARAMETER_NO_IMAGE_PADDING,
>> +		&bool_true, sizeof(bool_true));
>> +
>> +	/* get the preview component ready */
>> +	ret = vchiq_mmal_component_init(
>> +			dev->instance, "ril.video_render",
>> +			&dev->component[MMAL_COMPONENT_PREVIEW]);
>> +	if (ret < 0)
>> +		goto unreg_camera;
>> +
>> +	if (dev->component[MMAL_COMPONENT_PREVIEW]->inputs < 1) {
>> +		ret = -EINVAL;
>> +		pr_debug("too few input ports %d needed %d\n",
>> +			 dev->component[MMAL_COMPONENT_PREVIEW]->inputs, 1);
>> +		goto unreg_preview;
>> +	}
>> +
>> +	/* get the image encoder component ready */
>> +	ret = vchiq_mmal_component_init(
>> +		dev->instance, "ril.image_encode",
>> +		&dev->component[MMAL_COMPONENT_IMAGE_ENCODE]);
>> +	if (ret < 0)
>> +		goto unreg_preview;
>> +
>> +	if (dev->component[MMAL_COMPONENT_IMAGE_ENCODE]->inputs < 1) {
>> +		ret = -EINVAL;
>> +		v4l2_err(&dev->v4l2_dev, "too few input ports %d needed %d\n",
>> +			 dev->component[MMAL_COMPONENT_IMAGE_ENCODE]->inputs,
>> +			 1);
>> +		goto unreg_image_encoder;
>> +	}
>> +
>> +	/* get the video encoder component ready */
>> +	ret = vchiq_mmal_component_init(dev->instance, "ril.video_encode",
>> +					&dev->
>> +					component[MMAL_COMPONENT_VIDEO_ENCODE]);
>> +	if (ret < 0)
>> +		goto unreg_image_encoder;
>> +
>> +	if (dev->component[MMAL_COMPONENT_VIDEO_ENCODE]->inputs < 1) {
>> +		ret = -EINVAL;
>> +		v4l2_err(&dev->v4l2_dev, "too few input ports %d needed %d\n",
>> +			 dev->component[MMAL_COMPONENT_VIDEO_ENCODE]->inputs,
>> +			 1);
>> +		goto unreg_vid_encoder;
>> +	}
>> +
>> +	{
>> +		struct vchiq_mmal_port *encoder_port =
>> +			&dev->component[MMAL_COMPONENT_VIDEO_ENCODE]->output[0];
>> +		encoder_port->format.encoding = MMAL_ENCODING_H264;
>> +		ret = vchiq_mmal_port_set_format(dev->instance,
>> +			encoder_port);
>> +	}
>> +
>> +	{
>> +		unsigned int enable = 1;
>> +		vchiq_mmal_port_parameter_set(
>> +			dev->instance,
>> +			&dev->component[MMAL_COMPONENT_VIDEO_ENCODE]->control,
>> +			MMAL_PARAMETER_VIDEO_IMMUTABLE_INPUT,
>> +			&enable, sizeof(enable));
>> +
>> +		vchiq_mmal_port_parameter_set(dev->instance,
>> +			&dev->component[MMAL_COMPONENT_VIDEO_ENCODE]->control,
>> +			MMAL_PARAMETER_MINIMISE_FRAGMENTATION,
>> +			&enable,
>> +			sizeof(enable));
>> +	}
>> +	ret = bm2835_mmal_set_all_camera_controls(dev);
>> +	if (ret < 0)
>> +		goto unreg_vid_encoder;
>> +
>> +	return 0;
>> +
>> +unreg_vid_encoder:
>> +	pr_err("Cleanup: Destroy video encoder\n");
>> +	vchiq_mmal_component_finalise(
>> +		dev->instance,
>> +		dev->component[MMAL_COMPONENT_VIDEO_ENCODE]);
>> +
>> +unreg_image_encoder:
>> +	pr_err("Cleanup: Destroy image encoder\n");
>> +	vchiq_mmal_component_finalise(
>> +		dev->instance,
>> +		dev->component[MMAL_COMPONENT_IMAGE_ENCODE]);
>> +
>> +unreg_preview:
>> +	pr_err("Cleanup: Destroy video render\n");
>> +	vchiq_mmal_component_finalise(dev->instance,
>> +				      dev->component[MMAL_COMPONENT_PREVIEW]);
>> +
>> +unreg_camera:
>> +	pr_err("Cleanup: Destroy camera\n");
>> +	vchiq_mmal_component_finalise(dev->instance,
>> +				      dev->component[MMAL_COMPONENT_CAMERA]);
>> +
>> +unreg_mmal:
>> +	vchiq_mmal_finalise(dev->instance);
>> +	return ret;
>> +}
>> +
>> +static int __init bm2835_mmal_init_device(struct bm2835_mmal_dev *dev,
>> +					  struct video_device *vfd)
>> +{
>> +	int ret;
>> +
>> +	*vfd = vdev_template;
>> +	if (gst_v4l2src_is_broken) {
>> +		v4l2_info(&dev->v4l2_dev,
>> +		  "Work-around for gstreamer issue is active.\n");
>> +		vfd->ioctl_ops = &camera0_ioctl_ops_gstreamer;
>> +	}
>> +
>> +	vfd->v4l2_dev = &dev->v4l2_dev;
>> +
>> +	vfd->lock = &dev->mutex;
>> +
>> +	vfd->queue = &dev->capture.vb_vidq;
>> +
>> +	/* video device needs to be able to access instance data */
>> +	video_set_drvdata(vfd, dev);
>> +
>> +	ret = video_register_device(vfd,
>> +				    VFL_TYPE_GRABBER,
>> +				    video_nr[dev->camera_num]);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	v4l2_info(vfd->v4l2_dev,
>> +		"V4L2 device registered as %s - stills mode > %dx%d\n",
>> +		video_device_node_name(vfd), max_video_width, max_video_height);
>> +
>> +	return 0;
>> +}
>> +
>> +void bcm2835_cleanup_instance(struct bm2835_mmal_dev *dev)
>> +{
>> +	if (!dev)
>> +		return;
>> +
>> +	v4l2_info(&dev->v4l2_dev, "unregistering %s\n",
>> +		  video_device_node_name(&dev->vdev));
>> +
>> +	video_unregister_device(&dev->vdev);
>> +
>> +	if (dev->capture.encode_component) {
>> +		v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
>> +			 "mmal_exit - disconnect tunnel\n");
>> +		vchiq_mmal_port_connect_tunnel(dev->instance,
>> +					       dev->capture.camera_port, NULL);
>> +		vchiq_mmal_component_disable(dev->instance,
>> +					     dev->capture.encode_component);
>> +	}
>> +	vchiq_mmal_component_disable(dev->instance,
>> +				     dev->component[MMAL_COMPONENT_CAMERA]);
>> +
>> +	vchiq_mmal_component_finalise(dev->instance,
>> +				      dev->
>> +				      component[MMAL_COMPONENT_VIDEO_ENCODE]);
>> +
>> +	vchiq_mmal_component_finalise(dev->instance,
>> +				      dev->
>> +				      component[MMAL_COMPONENT_IMAGE_ENCODE]);
>> +
>> +	vchiq_mmal_component_finalise(dev->instance,
>> +				      dev->component[MMAL_COMPONENT_PREVIEW]);
>> +
>> +	vchiq_mmal_component_finalise(dev->instance,
>> +				      dev->component[MMAL_COMPONENT_CAMERA]);
>> +
>> +	v4l2_ctrl_handler_free(&dev->ctrl_handler);
>> +
>> +	v4l2_device_unregister(&dev->v4l2_dev);
>> +
>> +	kfree(dev);
>> +}
>> +
>> +static struct v4l2_format default_v4l2_format = {
>> +	.fmt.pix.pixelformat = V4L2_PIX_FMT_JPEG,
>> +	.fmt.pix.width = 1024,
>> +	.fmt.pix.bytesperline = 0,
>> +	.fmt.pix.height = 768,
>> +	.fmt.pix.sizeimage = 1024*768,
>> +};
>> +
>> +static int __init bm2835_mmal_init(void)
>> +{
>> +	int ret;
>> +	struct bm2835_mmal_dev *dev;
>> +	struct vb2_queue *q;
>> +	int camera;
>> +	unsigned int num_cameras;
>> +	struct vchiq_mmal_instance *instance;
>> +	unsigned int resolutions[MAX_BCM2835_CAMERAS][2];
>> +
>> +	ret = vchiq_mmal_init(&instance);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	num_cameras = get_num_cameras(instance,
>> +				      resolutions,
>> +				      MAX_BCM2835_CAMERAS);
>> +	if (num_cameras > MAX_BCM2835_CAMERAS)
>> +		num_cameras = MAX_BCM2835_CAMERAS;
>> +
>> +	for (camera = 0; camera < num_cameras; camera++) {
>> +		dev = kzalloc(sizeof(struct bm2835_mmal_dev), GFP_KERNEL);
>> +		if (!dev)
>> +			return -ENOMEM;
>> +
>> +		dev->camera_num = camera;
>> +		dev->max_width = resolutions[camera][0];
>> +		dev->max_height = resolutions[camera][1];
>> +
>> +		/* setup device defaults */
>> +		dev->overlay.w.left = 150;
>> +		dev->overlay.w.top = 50;
>> +		dev->overlay.w.width = 1024;
>> +		dev->overlay.w.height = 768;
>> +		dev->overlay.clipcount = 0;
>> +		dev->overlay.field = V4L2_FIELD_NONE;
>> +		dev->overlay.global_alpha = 255;
>> +
>> +		dev->capture.fmt = &formats[3]; /* JPEG */
>> +
>> +		/* v4l device registration */
>> +		snprintf(dev->v4l2_dev.name, sizeof(dev->v4l2_dev.name),
>> +			 "%s", BM2835_MMAL_MODULE_NAME);
>> +		ret = v4l2_device_register(NULL, &dev->v4l2_dev);
>> +		if (ret)
>> +			goto free_dev;
>> +
>> +		/* setup v4l controls */
>> +		ret = bm2835_mmal_init_controls(dev, &dev->ctrl_handler);
>> +		if (ret < 0)
>> +			goto unreg_dev;
>> +		dev->v4l2_dev.ctrl_handler = &dev->ctrl_handler;
>> +
>> +		/* mmal init */
>> +		dev->instance = instance;
>> +		ret = mmal_init(dev);
>> +		if (ret < 0)
>> +			goto unreg_dev;
>> +
>> +		/* initialize queue */
>> +		q = &dev->capture.vb_vidq;
>> +		memset(q, 0, sizeof(*q));
>> +		q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>> +		q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_READ;
>> +		q->drv_priv = dev;
>> +		q->buf_struct_size = sizeof(struct mmal_buffer);
>> +		q->ops = &bm2835_mmal_video_qops;
>> +		q->mem_ops = &vb2_vmalloc_memops;
>> +		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>> +		ret = vb2_queue_init(q);
>> +		if (ret < 0)
>> +			goto unreg_dev;
>> +
>> +		/* v4l2 core mutex used to protect all fops and v4l2 ioctls. */
>> +		mutex_init(&dev->mutex);
>> +
>> +		/* initialise video devices */
>> +		ret = bm2835_mmal_init_device(dev, &dev->vdev);
>> +		if (ret < 0)
>> +			goto unreg_dev;
>> +
>> +		/* Really want to call vidioc_s_fmt_vid_cap with the default
>> +		 * format, but currently the APIs don't join up.
>> +		 */
>> +		ret = mmal_setup_components(dev, &default_v4l2_format);
>> +		if (ret < 0) {
>> +			v4l2_err(&dev->v4l2_dev,
>> +				 "%s: could not setup components\n", __func__);
>> +			goto unreg_dev;
>> +		}
>> +
>> +		v4l2_info(&dev->v4l2_dev,
>> +			  "Broadcom 2835 MMAL video capture ver %s loaded.\n",
>> +			  BM2835_MMAL_VERSION);
>> +
>> +		gdev[camera] = dev;
>> +	}
>> +	return 0;
>> +
>> +unreg_dev:
>> +	v4l2_ctrl_handler_free(&dev->ctrl_handler);
>> +	v4l2_device_unregister(&dev->v4l2_dev);
>> +
>> +free_dev:
>> +	kfree(dev);
>> +
>> +	for ( ; camera > 0; camera--) {
>> +		bcm2835_cleanup_instance(gdev[camera]);
>> +		gdev[camera] = NULL;
>> +	}
>> +	pr_info("%s: error %d while loading driver\n",
>> +		 BM2835_MMAL_MODULE_NAME, ret);
>> +
>> +	return ret;
>> +}
>> +
>> +static void __exit bm2835_mmal_exit(void)
>> +{
>> +	int camera;
>> +	struct vchiq_mmal_instance *instance = gdev[0]->instance;
>> +
>> +	for (camera = 0; camera < MAX_BCM2835_CAMERAS; camera++) {
>> +		bcm2835_cleanup_instance(gdev[camera]);
>> +		gdev[camera] = NULL;
>> +	}
>> +	vchiq_mmal_finalise(instance);
>> +}
>> +
>> +module_init(bm2835_mmal_init);
>> +module_exit(bm2835_mmal_exit);
>> diff --git a/drivers/staging/media/platform/bcm2835/bcm2835-camera.h b/drivers/staging/media/platform/bcm2835/bcm2835-camera.h
>> new file mode 100644
>> index 000000000000..e6aeb7e7e381
>> --- /dev/null
>> +++ b/drivers/staging/media/platform/bcm2835/bcm2835-camera.h
>> @@ -0,0 +1,145 @@
>> +/*
>> + * Broadcom BM2835 V4L2 driver
>> + *
>> + * Copyright © 2013 Raspberry Pi (Trading) Ltd.
>> + *
>> + * This file is subject to the terms and conditions of the GNU General Public
>> + * License.  See the file COPYING in the main directory of this archive
>> + * for more details.
>> + *
>> + * Authors: Vincent Sanders <vincent.sanders@collabora.co.uk>
>> + *          Dave Stevenson <dsteve@broadcom.com>
>> + *          Simon Mellor <simellor@broadcom.com>
>> + *          Luke Diamand <luked@broadcom.com>
>> + *
>> + * core driver device
>> + */
>> +
>> +#define V4L2_CTRL_COUNT 29 /* number of v4l controls */
>> +
>> +enum {
>> +	MMAL_COMPONENT_CAMERA = 0,
>> +	MMAL_COMPONENT_PREVIEW,
>> +	MMAL_COMPONENT_IMAGE_ENCODE,
>> +	MMAL_COMPONENT_VIDEO_ENCODE,
>> +	MMAL_COMPONENT_COUNT
>> +};
>> +
>> +enum {
>> +	MMAL_CAMERA_PORT_PREVIEW = 0,
>> +	MMAL_CAMERA_PORT_VIDEO,
>> +	MMAL_CAMERA_PORT_CAPTURE,
>> +	MMAL_CAMERA_PORT_COUNT
>> +};
>> +
>> +#define PREVIEW_LAYER      2
>> +
>> +extern int bcm2835_v4l2_debug;
>> +
>> +struct bm2835_mmal_dev {
>> +	/* v4l2 devices */
>> +	struct v4l2_device     v4l2_dev;
>> +	struct video_device    vdev;
>> +	struct mutex           mutex;
>> +
>> +	/* controls */
>> +	struct v4l2_ctrl_handler  ctrl_handler;
>> +	struct v4l2_ctrl          *ctrls[V4L2_CTRL_COUNT];
>> +	enum v4l2_scene_mode	  scene_mode;
>> +	struct mmal_colourfx      colourfx;
>> +	int                       hflip;
>> +	int                       vflip;
>> +	int			  red_gain;
>> +	int			  blue_gain;
>> +	enum mmal_parameter_exposuremode exposure_mode_user;
>> +	enum v4l2_exposure_auto_type exposure_mode_v4l2_user;
>> +	/* active exposure mode may differ if selected via a scene mode */
>> +	enum mmal_parameter_exposuremode exposure_mode_active;
>> +	enum mmal_parameter_exposuremeteringmode metering_mode;
>> +	unsigned int		  manual_shutter_speed;
>> +	bool			  exp_auto_priority;
>> +	bool manual_iso_enabled;
>> +	uint32_t iso;
>> +
>> +	/* allocated mmal instance and components */
>> +	struct vchiq_mmal_instance   *instance;
>> +	struct vchiq_mmal_component  *component[MMAL_COMPONENT_COUNT];
>> +	int camera_use_count;
>> +
>> +	struct v4l2_window overlay;
>> +
>> +	struct {
>> +		unsigned int     width;  /* width */
>> +		unsigned int     height;  /* height */
>> +		unsigned int     stride;  /* stride */
>> +		unsigned int     buffersize; /* buffer size with padding */
>> +		struct mmal_fmt  *fmt;
>> +		struct v4l2_fract timeperframe;
>> +
>> +		/* H264 encode bitrate */
>> +		int         encode_bitrate;
>> +		/* H264 bitrate mode. CBR/VBR */
>> +		int         encode_bitrate_mode;
>> +		/* H264 profile */
>> +		enum v4l2_mpeg_video_h264_profile enc_profile;
>> +		/* H264 level */
>> +		enum v4l2_mpeg_video_h264_level enc_level;
>> +		/* JPEG Q-factor */
>> +		int         q_factor;
>> +
>> +		struct vb2_queue	vb_vidq;
>> +
>> +		/* VC start timestamp for streaming */
>> +		s64         vc_start_timestamp;
>> +		/* Kernel start timestamp for streaming */
>> +		struct timeval kernel_start_ts;
>> +
>> +		struct vchiq_mmal_port  *port; /* port being used for capture */
>> +		/* camera port being used for capture */
>> +		struct vchiq_mmal_port  *camera_port;
>> +		/* component being used for encode */
>> +		struct vchiq_mmal_component *encode_component;
>> +		/* number of frames remaining which driver should capture */
>> +		unsigned int  frame_count;
>> +		/* last frame completion */
>> +		struct completion  frame_cmplt;
>> +
>> +	} capture;
>> +
>> +	unsigned int camera_num;
>> +	unsigned int max_width;
>> +	unsigned int max_height;
>> +	unsigned int rgb_bgr_swapped;
>> +};
>> +
>> +int bm2835_mmal_init_controls(
>> +			struct bm2835_mmal_dev *dev,
>> +			struct v4l2_ctrl_handler *hdl);
>> +
>> +int bm2835_mmal_set_all_camera_controls(struct bm2835_mmal_dev *dev);
>> +int set_framerate_params(struct bm2835_mmal_dev *dev);
>> +
>> +/* Debug helpers */
>> +
>> +#define v4l2_dump_pix_format(level, debug, dev, pix_fmt, desc)	\
>> +{	\
>> +	v4l2_dbg(level, debug, dev,	\
>> +"%s: w %u h %u field %u pfmt 0x%x bpl %u sz_img %u colorspace 0x%x priv %u\n", \
>> +		desc == NULL ? "" : desc,	\
>> +		(pix_fmt)->width, (pix_fmt)->height, (pix_fmt)->field,	\
>> +		(pix_fmt)->pixelformat, (pix_fmt)->bytesperline,	\
>> +		(pix_fmt)->sizeimage, (pix_fmt)->colorspace, (pix_fmt)->priv); \
>> +}
>> +#define v4l2_dump_win_format(level, debug, dev, win_fmt, desc)	\
>> +{	\
>> +	v4l2_dbg(level, debug, dev,	\
>> +"%s: w %u h %u l %u t %u  field %u chromakey %06X clip %p " \
>> +"clipcount %u bitmap %p\n", \
>> +		desc == NULL ? "" : desc,	\
>> +		(win_fmt)->w.width, (win_fmt)->w.height, \
>> +		(win_fmt)->w.left, (win_fmt)->w.top, \
>> +		(win_fmt)->field,	\
>> +		(win_fmt)->chromakey,	\
>> +		(win_fmt)->clips, (win_fmt)->clipcount,	\
>> +		(win_fmt)->bitmap); \
>> +}
>> diff --git a/drivers/staging/media/platform/bcm2835/controls.c b/drivers/staging/media/platform/bcm2835/controls.c
>> new file mode 100644
>> index 000000000000..fe61330ba2a6
>> --- /dev/null
>> +++ b/drivers/staging/media/platform/bcm2835/controls.c
>> @@ -0,0 +1,1345 @@
>> +/*
>> + * Broadcom BM2835 V4L2 driver
>> + *
>> + * Copyright © 2013 Raspberry Pi (Trading) Ltd.
>> + *
>> + * This file is subject to the terms and conditions of the GNU General Public
>> + * License.  See the file COPYING in the main directory of this archive
>> + * for more details.
>> + *
>> + * Authors: Vincent Sanders <vincent.sanders@collabora.co.uk>
>> + *          Dave Stevenson <dsteve@broadcom.com>
>> + *          Simon Mellor <simellor@broadcom.com>
>> + *          Luke Diamand <luked@broadcom.com>
>> + */
>> +
>> +#include <linux/errno.h>
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/slab.h>
>> +#include <media/videobuf2-vmalloc.h>
>> +#include <media/v4l2-device.h>
>> +#include <media/v4l2-ioctl.h>
>> +#include <media/v4l2-ctrls.h>
>> +#include <media/v4l2-fh.h>
>> +#include <media/v4l2-event.h>
>> +#include <media/v4l2-common.h>
>> +
>> +#include "mmal-common.h"
>> +#include "mmal-vchiq.h"
>> +#include "mmal-parameters.h"
>> +#include "bcm2835-camera.h"
>> +
>> +/* The supported V4L2_CID_AUTO_EXPOSURE_BIAS values are from -4.0 to +4.0.
>> + * MMAL values are in 1/6th increments so the MMAL range is -24 to +24.
>> + * V4L2 docs say value "is expressed in terms of EV, drivers should interpret
>> + * the values as 0.001 EV units, where the value 1000 stands for +1 EV."
>> + * V4L2 is limited to a max of 32 values in a menu, so count in 1/3rds from
>> + * -4 to +4
>> + */
>> +static const s64 ev_bias_qmenu[] = {
>> +	-4000, -3667, -3333,
>> +	-3000, -2667, -2333,
>> +	-2000, -1667, -1333,
>> +	-1000,  -667,  -333,
>> +	    0,   333,   667,
>> +	 1000,  1333,  1667,
>> +	 2000,  2333,  2667,
>> +	 3000,  3333,  3667,
>> +	 4000
>> +};
>> +
>> +/* Supported ISO values (*1000)
>> + * ISOO = auto ISO
>> + */
>> +static const s64 iso_qmenu[] = {
>> +	0, 100000, 200000, 400000, 800000,
>> +};
>> +static const uint32_t iso_values[] = {
>> +	0, 100, 200, 400, 800,
>> +};
>> +
>> +static const s64 mains_freq_qmenu[] = {
>> +	V4L2_CID_POWER_LINE_FREQUENCY_DISABLED,
>> +	V4L2_CID_POWER_LINE_FREQUENCY_50HZ,
>> +	V4L2_CID_POWER_LINE_FREQUENCY_60HZ,
>> +	V4L2_CID_POWER_LINE_FREQUENCY_AUTO
>> +};
>> +
>> +/* Supported video encode modes */
>> +static const s64 bitrate_mode_qmenu[] = {
>> +	(s64)V4L2_MPEG_VIDEO_BITRATE_MODE_VBR,
>> +	(s64)V4L2_MPEG_VIDEO_BITRATE_MODE_CBR,
>> +};
>> +
>> +enum bm2835_mmal_ctrl_type {
>> +	MMAL_CONTROL_TYPE_STD,
>> +	MMAL_CONTROL_TYPE_STD_MENU,
>> +	MMAL_CONTROL_TYPE_INT_MENU,
>> +	MMAL_CONTROL_TYPE_CLUSTER, /* special cluster entry */
>> +};
>> +
>> +struct bm2835_mmal_v4l2_ctrl;
>> +
>> +typedef	int(bm2835_mmal_v4l2_ctrl_cb)(
>> +				struct bm2835_mmal_dev *dev,
>> +				struct v4l2_ctrl *ctrl,
>> +				const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl);
>> +
>> +struct bm2835_mmal_v4l2_ctrl {
>> +	u32 id; /* v4l2 control identifier */
>> +	enum bm2835_mmal_ctrl_type type;
>> +	/* control minimum value or
>> +	 * mask for MMAL_CONTROL_TYPE_STD_MENU */
>> +	s32 min;
>> +	s32 max; /* maximum value of control */
>> +	s32 def;  /* default value of control */
>> +	s32 step; /* step size of the control */
>> +	const s64 *imenu; /* integer menu array */
>> +	u32 mmal_id; /* mmal parameter id */
>> +	bm2835_mmal_v4l2_ctrl_cb *setter;
>> +	bool ignore_errors;
>> +};
>> +
>> +struct v4l2_to_mmal_effects_setting {
>> +	u32 v4l2_effect;
>> +	u32 mmal_effect;
>> +	s32 col_fx_enable;
>> +	s32 col_fx_fixed_cbcr;
>> +	u32 u;
>> +	u32 v;
>> +	u32 num_effect_params;
>> +	u32 effect_params[MMAL_MAX_IMAGEFX_PARAMETERS];
>> +};
>> +
>> +static const struct v4l2_to_mmal_effects_setting
>> +	v4l2_to_mmal_effects_values[] = {
>> +	{  V4L2_COLORFX_NONE,         MMAL_PARAM_IMAGEFX_NONE,
>> +		0,   0,    0,    0,   0, {0, 0, 0, 0, 0} },
>> +	{  V4L2_COLORFX_BW,           MMAL_PARAM_IMAGEFX_NONE,
>> +		1,   0,    128,  128, 0, {0, 0, 0, 0, 0} },
>> +	{  V4L2_COLORFX_SEPIA,        MMAL_PARAM_IMAGEFX_NONE,
>> +		1,   0,    87,   151, 0, {0, 0, 0, 0, 0} },
>> +	{  V4L2_COLORFX_NEGATIVE,     MMAL_PARAM_IMAGEFX_NEGATIVE,
>> +		0,   0,    0,    0,   0, {0, 0, 0, 0, 0} },
>> +	{  V4L2_COLORFX_EMBOSS,       MMAL_PARAM_IMAGEFX_EMBOSS,
>> +		0,   0,    0,    0,   0, {0, 0, 0, 0, 0} },
>> +	{  V4L2_COLORFX_SKETCH,       MMAL_PARAM_IMAGEFX_SKETCH,
>> +		0,   0,    0,    0,   0, {0, 0, 0, 0, 0} },
>> +	{  V4L2_COLORFX_SKY_BLUE,     MMAL_PARAM_IMAGEFX_PASTEL,
>> +		0,   0,    0,    0,   0, {0, 0, 0, 0, 0} },
>> +	{  V4L2_COLORFX_GRASS_GREEN,  MMAL_PARAM_IMAGEFX_WATERCOLOUR,
>> +		0,   0,    0,    0,   0, {0, 0, 0, 0, 0} },
>> +	{  V4L2_COLORFX_SKIN_WHITEN,  MMAL_PARAM_IMAGEFX_WASHEDOUT,
>> +		0,   0,    0,    0,   0, {0, 0, 0, 0, 0} },
>> +	{  V4L2_COLORFX_VIVID,        MMAL_PARAM_IMAGEFX_SATURATION,
>> +		0,   0,    0,    0,   0, {0, 0, 0, 0, 0} },
>> +	{  V4L2_COLORFX_AQUA,         MMAL_PARAM_IMAGEFX_NONE,
>> +		1,   0,    171,  121, 0, {0, 0, 0, 0, 0} },
>> +	{  V4L2_COLORFX_ART_FREEZE,   MMAL_PARAM_IMAGEFX_HATCH,
>> +		0,   0,    0,    0,   0, {0, 0, 0, 0, 0} },
>> +	{  V4L2_COLORFX_SILHOUETTE,   MMAL_PARAM_IMAGEFX_FILM,
>> +		0,   0,    0,    0,   0, {0, 0, 0, 0, 0} },
>> +	{  V4L2_COLORFX_SOLARIZATION, MMAL_PARAM_IMAGEFX_SOLARIZE,
>> +		0,   0,    0,    0,   5, {1, 128, 160, 160, 48} },
>> +	{  V4L2_COLORFX_ANTIQUE,      MMAL_PARAM_IMAGEFX_COLOURBALANCE,
>> +		0,   0,    0,    0,   3, {108, 274, 238, 0, 0} },
>> +	{  V4L2_COLORFX_SET_CBCR,     MMAL_PARAM_IMAGEFX_NONE,
>> +		1,   1,    0,    0,   0, {0, 0, 0, 0, 0} }
>> +};
>> +
>> +struct v4l2_mmal_scene_config {
>> +	enum v4l2_scene_mode			v4l2_scene;
>> +	enum mmal_parameter_exposuremode	exposure_mode;
>> +	enum mmal_parameter_exposuremeteringmode metering_mode;
>> +};
>> +
>> +static const struct v4l2_mmal_scene_config scene_configs[] = {
>> +	/* V4L2_SCENE_MODE_NONE automatically added */
>> +	{
>> +		V4L2_SCENE_MODE_NIGHT,
>> +		MMAL_PARAM_EXPOSUREMODE_NIGHT,
>> +		MMAL_PARAM_EXPOSUREMETERINGMODE_AVERAGE
>> +	},
>> +	{
>> +		V4L2_SCENE_MODE_SPORTS,
>> +		MMAL_PARAM_EXPOSUREMODE_SPORTS,
>> +		MMAL_PARAM_EXPOSUREMETERINGMODE_AVERAGE
>> +	},
>> +};
>> +
>> +/* control handlers*/
>> +
>> +static int ctrl_set_rational(struct bm2835_mmal_dev *dev,
>> +		      struct v4l2_ctrl *ctrl,
>> +		      const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
>> +{
>> +	struct mmal_parameter_rational rational_value;
>> +	struct vchiq_mmal_port *control;
>> +
>> +	control = &dev->component[MMAL_COMPONENT_CAMERA]->control;
>> +
>> +	rational_value.num = ctrl->val;
>> +	rational_value.den = 100;
>> +
>> +	return vchiq_mmal_port_parameter_set(dev->instance, control,
>> +					     mmal_ctrl->mmal_id,
>> +					     &rational_value,
>> +					     sizeof(rational_value));
>> +}
>> +
>> +static int ctrl_set_value(struct bm2835_mmal_dev *dev,
>> +		      struct v4l2_ctrl *ctrl,
>> +		      const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
>> +{
>> +	u32 u32_value;
>> +	struct vchiq_mmal_port *control;
>> +
>> +	control = &dev->component[MMAL_COMPONENT_CAMERA]->control;
>> +
>> +	u32_value = ctrl->val;
>> +
>> +	return vchiq_mmal_port_parameter_set(dev->instance, control,
>> +					     mmal_ctrl->mmal_id,
>> +					     &u32_value, sizeof(u32_value));
>> +}
>> +
>> +static int ctrl_set_iso(struct bm2835_mmal_dev *dev,
>> +		      struct v4l2_ctrl *ctrl,
>> +		      const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
>> +{
>> +	u32 u32_value;
>> +	struct vchiq_mmal_port *control;
>> +
>> +	if (ctrl->val > mmal_ctrl->max || ctrl->val < mmal_ctrl->min)
>> +		return 1;
>> +
>> +	if (ctrl->id == V4L2_CID_ISO_SENSITIVITY)
>> +		dev->iso = iso_values[ctrl->val];
>> +	else if (ctrl->id == V4L2_CID_ISO_SENSITIVITY_AUTO)
>> +		dev->manual_iso_enabled =
>> +				(ctrl->val == V4L2_ISO_SENSITIVITY_MANUAL ?
>> +							true :
>> +							false);
>> +
>> +	control = &dev->component[MMAL_COMPONENT_CAMERA]->control;
>> +
>> +	if (dev->manual_iso_enabled)
>> +		u32_value = dev->iso;
>> +	else
>> +		u32_value = 0;
>> +
>> +	return vchiq_mmal_port_parameter_set(dev->instance, control,
>> +					     MMAL_PARAMETER_ISO,
>> +					     &u32_value, sizeof(u32_value));
>> +}
>> +
>> +static int ctrl_set_value_ev(struct bm2835_mmal_dev *dev,
>> +		      struct v4l2_ctrl *ctrl,
>> +		      const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
>> +{
>> +	s32 s32_value;
>> +	struct vchiq_mmal_port *control;
>> +
>> +	control = &dev->component[MMAL_COMPONENT_CAMERA]->control;
>> +
>> +	s32_value = (ctrl->val-12)*2;	/* Convert from index to 1/6ths */
>> +
>> +	return vchiq_mmal_port_parameter_set(dev->instance, control,
>> +					     mmal_ctrl->mmal_id,
>> +					     &s32_value, sizeof(s32_value));
>> +}
>> +
>> +static int ctrl_set_rotate(struct bm2835_mmal_dev *dev,
>> +		      struct v4l2_ctrl *ctrl,
>> +		      const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
>> +{
>> +	int ret;
>> +	u32 u32_value;
>> +	struct vchiq_mmal_component *camera;
>> +
>> +	camera = dev->component[MMAL_COMPONENT_CAMERA];
>> +
>> +	u32_value = ((ctrl->val % 360) / 90) * 90;
>> +
>> +	ret = vchiq_mmal_port_parameter_set(dev->instance, &camera->output[0],
>> +					    mmal_ctrl->mmal_id,
>> +					    &u32_value, sizeof(u32_value));
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	ret = vchiq_mmal_port_parameter_set(dev->instance, &camera->output[1],
>> +					    mmal_ctrl->mmal_id,
>> +					    &u32_value, sizeof(u32_value));
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	ret = vchiq_mmal_port_parameter_set(dev->instance, &camera->output[2],
>> +					    mmal_ctrl->mmal_id,
>> +					    &u32_value, sizeof(u32_value));
>> +
>> +	return ret;
>> +}
>> +
>> +static int ctrl_set_flip(struct bm2835_mmal_dev *dev,
>> +		      struct v4l2_ctrl *ctrl,
>> +		      const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
>> +{
>> +	int ret;
>> +	u32 u32_value;
>> +	struct vchiq_mmal_component *camera;
>> +
>> +	if (ctrl->id == V4L2_CID_HFLIP)
>> +		dev->hflip = ctrl->val;
>> +	else
>> +		dev->vflip = ctrl->val;
>> +
>> +	camera = dev->component[MMAL_COMPONENT_CAMERA];
>> +
>> +	if (dev->hflip && dev->vflip)
>> +		u32_value = MMAL_PARAM_MIRROR_BOTH;
>> +	else if (dev->hflip)
>> +		u32_value = MMAL_PARAM_MIRROR_HORIZONTAL;
>> +	else if (dev->vflip)
>> +		u32_value = MMAL_PARAM_MIRROR_VERTICAL;
>> +	else
>> +		u32_value = MMAL_PARAM_MIRROR_NONE;
>> +
>> +	ret = vchiq_mmal_port_parameter_set(dev->instance, &camera->output[0],
>> +					    mmal_ctrl->mmal_id,
>> +					    &u32_value, sizeof(u32_value));
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	ret = vchiq_mmal_port_parameter_set(dev->instance, &camera->output[1],
>> +					    mmal_ctrl->mmal_id,
>> +					    &u32_value, sizeof(u32_value));
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	ret = vchiq_mmal_port_parameter_set(dev->instance, &camera->output[2],
>> +					    mmal_ctrl->mmal_id,
>> +					    &u32_value, sizeof(u32_value));
>> +
>> +	return ret;
>> +
>> +}
>> +
>> +static int ctrl_set_exposure(struct bm2835_mmal_dev *dev,
>> +		      struct v4l2_ctrl *ctrl,
>> +		      const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
>> +{
>> +	enum mmal_parameter_exposuremode exp_mode = dev->exposure_mode_user;
>> +	u32 shutter_speed = 0;
>> +	struct vchiq_mmal_port *control;
>> +	int ret = 0;
>> +
>> +	control = &dev->component[MMAL_COMPONENT_CAMERA]->control;
>> +
>> +	if (mmal_ctrl->mmal_id == MMAL_PARAMETER_SHUTTER_SPEED)	{
>> +		/* V4L2 is in 100usec increments.
>> +		 * MMAL is 1usec.
>> +		 */
>> +		dev->manual_shutter_speed = ctrl->val * 100;
>> +	} else if (mmal_ctrl->mmal_id == MMAL_PARAMETER_EXPOSURE_MODE) {
>> +		switch (ctrl->val) {
>> +		case V4L2_EXPOSURE_AUTO:
>> +			exp_mode = MMAL_PARAM_EXPOSUREMODE_AUTO;
>> +			break;
>> +
>> +		case V4L2_EXPOSURE_MANUAL:
>> +			exp_mode = MMAL_PARAM_EXPOSUREMODE_OFF;
>> +			break;
>> +		}
>> +		dev->exposure_mode_user = exp_mode;
>> +		dev->exposure_mode_v4l2_user = ctrl->val;
>> +	} else if (mmal_ctrl->id == V4L2_CID_EXPOSURE_AUTO_PRIORITY) {
>> +		dev->exp_auto_priority = ctrl->val;
>> +	}
>> +
>> +	if (dev->scene_mode == V4L2_SCENE_MODE_NONE) {
>> +		if (exp_mode == MMAL_PARAM_EXPOSUREMODE_OFF)
>> +			shutter_speed = dev->manual_shutter_speed;
>> +
>> +		ret = vchiq_mmal_port_parameter_set(dev->instance,
>> +					control,
>> +					MMAL_PARAMETER_SHUTTER_SPEED,
>> +					&shutter_speed,
>> +					sizeof(shutter_speed));
>> +		ret += vchiq_mmal_port_parameter_set(dev->instance,
>> +					control,
>> +					MMAL_PARAMETER_EXPOSURE_MODE,
>> +					&exp_mode,
>> +					sizeof(u32));
>> +		dev->exposure_mode_active = exp_mode;
>> +	}
>> +	/* exposure_dynamic_framerate (V4L2_CID_EXPOSURE_AUTO_PRIORITY) should
>> +	 * always apply irrespective of scene mode.
>> +	 */
>> +	ret += set_framerate_params(dev);
>> +
>> +	return ret;
>> +}
>> +
>> +static int ctrl_set_metering_mode(struct bm2835_mmal_dev *dev,
>> +			   struct v4l2_ctrl *ctrl,
>> +			   const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
>> +{
>> +	switch (ctrl->val) {
>> +	case V4L2_EXPOSURE_METERING_AVERAGE:
>> +		dev->metering_mode = MMAL_PARAM_EXPOSUREMETERINGMODE_AVERAGE;
>> +		break;
>> +
>> +	case V4L2_EXPOSURE_METERING_CENTER_WEIGHTED:
>> +		dev->metering_mode = MMAL_PARAM_EXPOSUREMETERINGMODE_BACKLIT;
>> +		break;
>> +
>> +	case V4L2_EXPOSURE_METERING_SPOT:
>> +		dev->metering_mode = MMAL_PARAM_EXPOSUREMETERINGMODE_SPOT;
>> +		break;
>> +
>> +	/* todo matrix weighting not added to Linux API till 3.9
>> +	case V4L2_EXPOSURE_METERING_MATRIX:
>> +		dev->metering_mode = MMAL_PARAM_EXPOSUREMETERINGMODE_MATRIX;
>> +		break;
>> +	*/
>> +
>> +	}
>> +
>> +	if (dev->scene_mode == V4L2_SCENE_MODE_NONE) {
>> +		struct vchiq_mmal_port *control;
>> +		u32 u32_value = dev->metering_mode;
>> +
>> +		control = &dev->component[MMAL_COMPONENT_CAMERA]->control;
>> +
>> +		return vchiq_mmal_port_parameter_set(dev->instance, control,
>> +					     mmal_ctrl->mmal_id,
>> +					     &u32_value, sizeof(u32_value));
>> +	} else
>> +		return 0;
>> +}
>> +
>> +static int ctrl_set_flicker_avoidance(struct bm2835_mmal_dev *dev,
>> +			   struct v4l2_ctrl *ctrl,
>> +			   const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
>> +{
>> +	u32 u32_value;
>> +	struct vchiq_mmal_port *control;
>> +
>> +	control = &dev->component[MMAL_COMPONENT_CAMERA]->control;
>> +
>> +	switch (ctrl->val) {
>> +	case V4L2_CID_POWER_LINE_FREQUENCY_DISABLED:
>> +		u32_value = MMAL_PARAM_FLICKERAVOID_OFF;
>> +		break;
>> +	case V4L2_CID_POWER_LINE_FREQUENCY_50HZ:
>> +		u32_value = MMAL_PARAM_FLICKERAVOID_50HZ;
>> +		break;
>> +	case V4L2_CID_POWER_LINE_FREQUENCY_60HZ:
>> +		u32_value = MMAL_PARAM_FLICKERAVOID_60HZ;
>> +		break;
>> +	case V4L2_CID_POWER_LINE_FREQUENCY_AUTO:
>> +		u32_value = MMAL_PARAM_FLICKERAVOID_AUTO;
>> +		break;
>> +	}
>> +
>> +	return vchiq_mmal_port_parameter_set(dev->instance, control,
>> +					     mmal_ctrl->mmal_id,
>> +					     &u32_value, sizeof(u32_value));
>> +}
>> +
>> +static int ctrl_set_awb_mode(struct bm2835_mmal_dev *dev,
>> +		      struct v4l2_ctrl *ctrl,
>> +		      const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
>> +{
>> +	u32 u32_value;
>> +	struct vchiq_mmal_port *control;
>> +
>> +	control = &dev->component[MMAL_COMPONENT_CAMERA]->control;
>> +
>> +	switch (ctrl->val) {
>> +	case V4L2_WHITE_BALANCE_MANUAL:
>> +		u32_value = MMAL_PARAM_AWBMODE_OFF;
>> +		break;
>> +
>> +	case V4L2_WHITE_BALANCE_AUTO:
>> +		u32_value = MMAL_PARAM_AWBMODE_AUTO;
>> +		break;
>> +
>> +	case V4L2_WHITE_BALANCE_INCANDESCENT:
>> +		u32_value = MMAL_PARAM_AWBMODE_INCANDESCENT;
>> +		break;
>> +
>> +	case V4L2_WHITE_BALANCE_FLUORESCENT:
>> +		u32_value = MMAL_PARAM_AWBMODE_FLUORESCENT;
>> +		break;
>> +
>> +	case V4L2_WHITE_BALANCE_FLUORESCENT_H:
>> +		u32_value = MMAL_PARAM_AWBMODE_TUNGSTEN;
>> +		break;
>> +
>> +	case V4L2_WHITE_BALANCE_HORIZON:
>> +		u32_value = MMAL_PARAM_AWBMODE_HORIZON;
>> +		break;
>> +
>> +	case V4L2_WHITE_BALANCE_DAYLIGHT:
>> +		u32_value = MMAL_PARAM_AWBMODE_SUNLIGHT;
>> +		break;
>> +
>> +	case V4L2_WHITE_BALANCE_FLASH:
>> +		u32_value = MMAL_PARAM_AWBMODE_FLASH;
>> +		break;
>> +
>> +	case V4L2_WHITE_BALANCE_CLOUDY:
>> +		u32_value = MMAL_PARAM_AWBMODE_CLOUDY;
>> +		break;
>> +
>> +	case V4L2_WHITE_BALANCE_SHADE:
>> +		u32_value = MMAL_PARAM_AWBMODE_SHADE;
>> +		break;
>> +
>> +	}
>> +
>> +	return vchiq_mmal_port_parameter_set(dev->instance, control,
>> +					     mmal_ctrl->mmal_id,
>> +					     &u32_value, sizeof(u32_value));
>> +}
>> +
>> +static int ctrl_set_awb_gains(struct bm2835_mmal_dev *dev,
>> +		      struct v4l2_ctrl *ctrl,
>> +		      const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
>> +{
>> +	struct vchiq_mmal_port *control;
>> +	struct mmal_parameter_awbgains gains;
>> +
>> +	control = &dev->component[MMAL_COMPONENT_CAMERA]->control;
>> +
>> +	if (ctrl->id == V4L2_CID_RED_BALANCE)
>> +		dev->red_gain = ctrl->val;
>> +	else if (ctrl->id == V4L2_CID_BLUE_BALANCE)
>> +		dev->blue_gain = ctrl->val;
>> +
>> +	gains.r_gain.num = dev->red_gain;
>> +	gains.b_gain.num = dev->blue_gain;
>> +	gains.r_gain.den = gains.b_gain.den = 1000;
>> +
>> +	return vchiq_mmal_port_parameter_set(dev->instance, control,
>> +					     mmal_ctrl->mmal_id,
>> +					     &gains, sizeof(gains));
>> +}
>> +
>> +static int ctrl_set_image_effect(struct bm2835_mmal_dev *dev,
>> +		   struct v4l2_ctrl *ctrl,
>> +		   const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
>> +{
>> +	int ret = -EINVAL;
>> +	int i, j;
>> +	struct vchiq_mmal_port *control;
>> +	struct mmal_parameter_imagefx_parameters imagefx;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(v4l2_to_mmal_effects_values); i++) {
>> +		if (ctrl->val == v4l2_to_mmal_effects_values[i].v4l2_effect) {
>> +
>> +			imagefx.effect =
>> +				v4l2_to_mmal_effects_values[i].mmal_effect;
>> +			imagefx.num_effect_params =
>> +				v4l2_to_mmal_effects_values[i].num_effect_params;
>> +
>> +			if (imagefx.num_effect_params > MMAL_MAX_IMAGEFX_PARAMETERS)
>> +				imagefx.num_effect_params = MMAL_MAX_IMAGEFX_PARAMETERS;
>> +
>> +			for (j = 0; j < imagefx.num_effect_params; j++)
>> +				imagefx.effect_parameter[j] =
>> +					v4l2_to_mmal_effects_values[i].effect_params[j];
>> +
>> +			dev->colourfx.enable =
>> +				v4l2_to_mmal_effects_values[i].col_fx_enable;
>> +			if (!v4l2_to_mmal_effects_values[i].col_fx_fixed_cbcr) {
>> +				dev->colourfx.u =
>> +					v4l2_to_mmal_effects_values[i].u;
>> +				dev->colourfx.v =
>> +					v4l2_to_mmal_effects_values[i].v;
>> +			}
>> +
>> +			control = &dev->component[MMAL_COMPONENT_CAMERA]->control;
>> +
>> +			ret = vchiq_mmal_port_parameter_set(
>> +					dev->instance, control,
>> +					MMAL_PARAMETER_IMAGE_EFFECT_PARAMETERS,
>> +					&imagefx, sizeof(imagefx));
>> +			if (ret)
>> +				goto exit;
>> +
>> +			ret = vchiq_mmal_port_parameter_set(
>> +					dev->instance, control,
>> +					MMAL_PARAMETER_COLOUR_EFFECT,
>> +					&dev->colourfx, sizeof(dev->colourfx));
>> +		}
>> +	}
>> +
>> +exit:
>> +	v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
>> +		 "mmal_ctrl:%p ctrl id:0x%x ctrl val:%d imagefx:0x%x color_effect:%s u:%d v:%d ret %d(%d)\n",
>> +				mmal_ctrl, ctrl->id, ctrl->val, imagefx.effect,
>> +				dev->colourfx.enable ? "true" : "false",
>> +				dev->colourfx.u, dev->colourfx.v,
>> +				ret, (ret == 0 ? 0 : -EINVAL));
>> +	return (ret == 0 ? 0 : EINVAL);
>> +}
>> +
>> +static int ctrl_set_colfx(struct bm2835_mmal_dev *dev,
>> +		   struct v4l2_ctrl *ctrl,
>> +		   const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
>> +{
>> +	int ret = -EINVAL;
>> +	struct vchiq_mmal_port *control;
>> +
>> +	control = &dev->component[MMAL_COMPONENT_CAMERA]->control;
>> +
>> +	dev->colourfx.enable = (ctrl->val & 0xff00) >> 8;
>> +	dev->colourfx.enable = ctrl->val & 0xff;
>> +
>> +	ret = vchiq_mmal_port_parameter_set(dev->instance, control,
>> +					MMAL_PARAMETER_COLOUR_EFFECT,
>> +					&dev->colourfx, sizeof(dev->colourfx));
>> +
>> +	v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
>> +		 "%s: After: mmal_ctrl:%p ctrl id:0x%x ctrl val:%d ret %d(%d)\n",
>> +			__func__, mmal_ctrl, ctrl->id, ctrl->val, ret,
>> +			(ret == 0 ? 0 : -EINVAL));
>> +	return (ret == 0 ? 0 : EINVAL);
>> +}
>> +
>> +static int ctrl_set_bitrate(struct bm2835_mmal_dev *dev,
>> +		   struct v4l2_ctrl *ctrl,
>> +		   const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
>> +{
>> +	int ret;
>> +	struct vchiq_mmal_port *encoder_out;
>> +
>> +	dev->capture.encode_bitrate = ctrl->val;
>> +
>> +	encoder_out = &dev->component[MMAL_COMPONENT_VIDEO_ENCODE]->output[0];
>> +
>> +	ret = vchiq_mmal_port_parameter_set(dev->instance, encoder_out,
>> +					    mmal_ctrl->mmal_id,
>> +					    &ctrl->val, sizeof(ctrl->val));
>> +	ret = 0;
>> +	return ret;
>> +}
>> +
>> +static int ctrl_set_bitrate_mode(struct bm2835_mmal_dev *dev,
>> +		   struct v4l2_ctrl *ctrl,
>> +		   const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
>> +{
>> +	u32 bitrate_mode;
>> +	struct vchiq_mmal_port *encoder_out;
>> +
>> +	encoder_out = &dev->component[MMAL_COMPONENT_VIDEO_ENCODE]->output[0];
>> +
>> +	dev->capture.encode_bitrate_mode = ctrl->val;
>> +	switch (ctrl->val) {
>> +	default:
>> +	case V4L2_MPEG_VIDEO_BITRATE_MODE_VBR:
>> +		bitrate_mode = MMAL_VIDEO_RATECONTROL_VARIABLE;
>> +		break;
>> +	case V4L2_MPEG_VIDEO_BITRATE_MODE_CBR:
>> +		bitrate_mode = MMAL_VIDEO_RATECONTROL_CONSTANT;
>> +		break;
>> +	}
>> +
>> +	vchiq_mmal_port_parameter_set(dev->instance, encoder_out,
>> +					     mmal_ctrl->mmal_id,
>> +					     &bitrate_mode,
>> +					     sizeof(bitrate_mode));
>> +	return 0;
>> +}
>> +
>> +static int ctrl_set_image_encode_output(struct bm2835_mmal_dev *dev,
>> +		      struct v4l2_ctrl *ctrl,
>> +		      const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
>> +{
>> +	u32 u32_value;
>> +	struct vchiq_mmal_port *jpeg_out;
>> +
>> +	jpeg_out = &dev->component[MMAL_COMPONENT_IMAGE_ENCODE]->output[0];
>> +
>> +	u32_value = ctrl->val;
>> +
>> +	return vchiq_mmal_port_parameter_set(dev->instance, jpeg_out,
>> +					     mmal_ctrl->mmal_id,
>> +					     &u32_value, sizeof(u32_value));
>> +}
>> +
>> +static int ctrl_set_video_encode_param_output(struct bm2835_mmal_dev *dev,
>> +		      struct v4l2_ctrl *ctrl,
>> +		      const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
>> +{
>> +	u32 u32_value;
>> +	struct vchiq_mmal_port *vid_enc_ctl;
>> +
>> +	vid_enc_ctl = &dev->component[MMAL_COMPONENT_VIDEO_ENCODE]->output[0];
>> +
>> +	u32_value = ctrl->val;
>> +
>> +	return vchiq_mmal_port_parameter_set(dev->instance, vid_enc_ctl,
>> +					     mmal_ctrl->mmal_id,
>> +					     &u32_value, sizeof(u32_value));
>> +}
>> +
>> +static int ctrl_set_video_encode_profile_level(struct bm2835_mmal_dev *dev,
>> +		      struct v4l2_ctrl *ctrl,
>> +		      const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
>> +{
>> +	struct mmal_parameter_video_profile param;
>> +	int ret = 0;
>> +
>> +	if (ctrl->id == V4L2_CID_MPEG_VIDEO_H264_PROFILE) {
>> +		switch (ctrl->val) {
>> +		case V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE:
>> +		case V4L2_MPEG_VIDEO_H264_PROFILE_CONSTRAINED_BASELINE:
>> +		case V4L2_MPEG_VIDEO_H264_PROFILE_MAIN:
>> +		case V4L2_MPEG_VIDEO_H264_PROFILE_HIGH:
>> +			dev->capture.enc_profile = ctrl->val;
>> +			break;
>> +		default:
>> +			ret = -EINVAL;
>> +			break;
>> +		}
>> +	} else if (ctrl->id == V4L2_CID_MPEG_VIDEO_H264_LEVEL) {
>> +		switch (ctrl->val) {
>> +		case V4L2_MPEG_VIDEO_H264_LEVEL_1_0:
>> +		case V4L2_MPEG_VIDEO_H264_LEVEL_1B:
>> +		case V4L2_MPEG_VIDEO_H264_LEVEL_1_1:
>> +		case V4L2_MPEG_VIDEO_H264_LEVEL_1_2:
>> +		case V4L2_MPEG_VIDEO_H264_LEVEL_1_3:
>> +		case V4L2_MPEG_VIDEO_H264_LEVEL_2_0:
>> +		case V4L2_MPEG_VIDEO_H264_LEVEL_2_1:
>> +		case V4L2_MPEG_VIDEO_H264_LEVEL_2_2:
>> +		case V4L2_MPEG_VIDEO_H264_LEVEL_3_0:
>> +		case V4L2_MPEG_VIDEO_H264_LEVEL_3_1:
>> +		case V4L2_MPEG_VIDEO_H264_LEVEL_3_2:
>> +		case V4L2_MPEG_VIDEO_H264_LEVEL_4_0:
>> +			dev->capture.enc_level = ctrl->val;
>> +			break;
>> +		default:
>> +			ret = -EINVAL;
>> +			break;
>> +		}
>> +	}
>> +
>> +	if (!ret) {
>> +		switch (dev->capture.enc_profile) {
>> +		case V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE:
>> +			param.profile = MMAL_VIDEO_PROFILE_H264_BASELINE;
>> +			break;
>> +		case V4L2_MPEG_VIDEO_H264_PROFILE_CONSTRAINED_BASELINE:
>> +			param.profile =
>> +				MMAL_VIDEO_PROFILE_H264_CONSTRAINED_BASELINE;
>> +			break;
>> +		case V4L2_MPEG_VIDEO_H264_PROFILE_MAIN:
>> +			param.profile = MMAL_VIDEO_PROFILE_H264_MAIN;
>> +			break;
>> +		case V4L2_MPEG_VIDEO_H264_PROFILE_HIGH:
>> +			param.profile = MMAL_VIDEO_PROFILE_H264_HIGH;
>> +			break;
>> +		default:
>> +			/* Should never get here */
>> +			break;
>> +		}
>> +
>> +		switch (dev->capture.enc_level) {
>> +		case V4L2_MPEG_VIDEO_H264_LEVEL_1_0:
>> +			param.level = MMAL_VIDEO_LEVEL_H264_1;
>> +			break;
>> +		case V4L2_MPEG_VIDEO_H264_LEVEL_1B:
>> +			param.level = MMAL_VIDEO_LEVEL_H264_1b;
>> +			break;
>> +		case V4L2_MPEG_VIDEO_H264_LEVEL_1_1:
>> +			param.level = MMAL_VIDEO_LEVEL_H264_11;
>> +			break;
>> +		case V4L2_MPEG_VIDEO_H264_LEVEL_1_2:
>> +			param.level = MMAL_VIDEO_LEVEL_H264_12;
>> +			break;
>> +		case V4L2_MPEG_VIDEO_H264_LEVEL_1_3:
>> +			param.level = MMAL_VIDEO_LEVEL_H264_13;
>> +			break;
>> +		case V4L2_MPEG_VIDEO_H264_LEVEL_2_0:
>> +			param.level = MMAL_VIDEO_LEVEL_H264_2;
>> +			break;
>> +		case V4L2_MPEG_VIDEO_H264_LEVEL_2_1:
>> +			param.level = MMAL_VIDEO_LEVEL_H264_21;
>> +			break;
>> +		case V4L2_MPEG_VIDEO_H264_LEVEL_2_2:
>> +			param.level = MMAL_VIDEO_LEVEL_H264_22;
>> +			break;
>> +		case V4L2_MPEG_VIDEO_H264_LEVEL_3_0:
>> +			param.level = MMAL_VIDEO_LEVEL_H264_3;
>> +			break;
>> +		case V4L2_MPEG_VIDEO_H264_LEVEL_3_1:
>> +			param.level = MMAL_VIDEO_LEVEL_H264_31;
>> +			break;
>> +		case V4L2_MPEG_VIDEO_H264_LEVEL_3_2:
>> +			param.level = MMAL_VIDEO_LEVEL_H264_32;
>> +			break;
>> +		case V4L2_MPEG_VIDEO_H264_LEVEL_4_0:
>> +			param.level = MMAL_VIDEO_LEVEL_H264_4;
>> +			break;
>> +		default:
>> +			/* Should never get here */
>> +			break;
>> +		}
>> +
>> +		ret = vchiq_mmal_port_parameter_set(dev->instance,
>> +			&dev->component[MMAL_COMPONENT_VIDEO_ENCODE]->output[0],
>> +			mmal_ctrl->mmal_id,
>> +			&param, sizeof(param));
>> +	}
>> +	return ret;
>> +}
>> +
>> +static int ctrl_set_scene_mode(struct bm2835_mmal_dev *dev,
>> +		      struct v4l2_ctrl *ctrl,
>> +		      const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
>> +{
>> +	int ret = 0;
>> +	int shutter_speed;
>> +	struct vchiq_mmal_port *control;
>> +
>> +	v4l2_dbg(0, bcm2835_v4l2_debug, &dev->v4l2_dev,
>> +		"scene mode selected %d, was %d\n", ctrl->val,
>> +		dev->scene_mode);
>> +	control = &dev->component[MMAL_COMPONENT_CAMERA]->control;
>> +
>> +	if (ctrl->val == dev->scene_mode)
>> +		return 0;
>> +
>> +	if (ctrl->val == V4L2_SCENE_MODE_NONE) {
>> +		/* Restore all user selections */
>> +		dev->scene_mode = V4L2_SCENE_MODE_NONE;
>> +
>> +		if (dev->exposure_mode_user == MMAL_PARAM_EXPOSUREMODE_OFF)
>> +			shutter_speed = dev->manual_shutter_speed;
>> +		else
>> +			shutter_speed = 0;
>> +
>> +		v4l2_dbg(0, bcm2835_v4l2_debug, &dev->v4l2_dev,
>> +			"%s: scene mode none: shut_speed %d, exp_mode %d, metering %d\n",
>> +			__func__, shutter_speed, dev->exposure_mode_user,
>> +			dev->metering_mode);
>> +		ret = vchiq_mmal_port_parameter_set(dev->instance,
>> +					control,
>> +					MMAL_PARAMETER_SHUTTER_SPEED,
>> +					&shutter_speed,
>> +					sizeof(shutter_speed));
>> +		ret += vchiq_mmal_port_parameter_set(dev->instance,
>> +					control,
>> +					MMAL_PARAMETER_EXPOSURE_MODE,
>> +					&dev->exposure_mode_user,
>> +					sizeof(u32));
>> +		dev->exposure_mode_active = dev->exposure_mode_user;
>> +		ret += vchiq_mmal_port_parameter_set(dev->instance,
>> +					control,
>> +					MMAL_PARAMETER_EXP_METERING_MODE,
>> +					&dev->metering_mode,
>> +					sizeof(u32));
>> +		ret += set_framerate_params(dev);
>> +	} else {
>> +		/* Set up scene mode */
>> +		int i;
>> +		const struct v4l2_mmal_scene_config *scene = NULL;
>> +		int shutter_speed;
>> +		enum mmal_parameter_exposuremode exposure_mode;
>> +		enum mmal_parameter_exposuremeteringmode metering_mode;
>> +
>> +		for (i = 0; i < ARRAY_SIZE(scene_configs); i++) {
>> +			if (scene_configs[i].v4l2_scene ==
>> +				ctrl->val) {
>> +				scene = &scene_configs[i];
>> +				break;
>> +			}
>> +		}
>> +		if (!scene)
>> +			return -EINVAL;
>> +		if (i >= ARRAY_SIZE(scene_configs))
>> +			return -EINVAL;
>> +
>> +		/* Set all the values */
>> +		dev->scene_mode = ctrl->val;
>> +
>> +		if (scene->exposure_mode == MMAL_PARAM_EXPOSUREMODE_OFF)
>> +			shutter_speed = dev->manual_shutter_speed;
>> +		else
>> +			shutter_speed = 0;
>> +		exposure_mode = scene->exposure_mode;
>> +		metering_mode = scene->metering_mode;
>> +
>> +		v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
>> +			"%s: scene mode none: shut_speed %d, exp_mode %d, metering %d\n",
>> +			__func__, shutter_speed, exposure_mode, metering_mode);
>> +
>> +		ret = vchiq_mmal_port_parameter_set(dev->instance, control,
>> +					MMAL_PARAMETER_SHUTTER_SPEED,
>> +					&shutter_speed,
>> +					sizeof(shutter_speed));
>> +		ret += vchiq_mmal_port_parameter_set(dev->instance,
>> +					control,
>> +					MMAL_PARAMETER_EXPOSURE_MODE,
>> +					&exposure_mode,
>> +					sizeof(u32));
>> +		dev->exposure_mode_active = exposure_mode;
>> +		ret += vchiq_mmal_port_parameter_set(dev->instance, control,
>> +					MMAL_PARAMETER_EXPOSURE_MODE,
>> +					&exposure_mode,
>> +					sizeof(u32));
>> +		ret += vchiq_mmal_port_parameter_set(dev->instance, control,
>> +					MMAL_PARAMETER_EXP_METERING_MODE,
>> +					&metering_mode,
>> +					sizeof(u32));
>> +		ret += set_framerate_params(dev);
>> +	}
>> +	if (ret) {
>> +		v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
>> +			"%s: Setting scene to %d, ret=%d\n",
>> +			__func__, ctrl->val, ret);
>> +		ret = -EINVAL;
>> +	}
>> +	return 0;
>> +}
>> +
>> +static int bm2835_mmal_s_ctrl(struct v4l2_ctrl *ctrl)
>> +{
>> +	struct bm2835_mmal_dev *dev =
>> +		container_of(ctrl->handler, struct bm2835_mmal_dev,
>> +			     ctrl_handler);
>> +	const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl = ctrl->priv;
>> +	int ret;
>> +
>> +	if ((mmal_ctrl == NULL) ||
>> +	    (mmal_ctrl->id != ctrl->id) ||
>> +	    (mmal_ctrl->setter == NULL)) {
>> +		pr_warn("mmal_ctrl:%p ctrl id:%d\n", mmal_ctrl, ctrl->id);
>> +		return -EINVAL;
>> +	}
>> +
>> +	ret = mmal_ctrl->setter(dev, ctrl, mmal_ctrl);
>> +	if (ret)
>> +		pr_warn("ctrl id:%d/MMAL param %08X- returned ret %d\n",
>> +				ctrl->id, mmal_ctrl->mmal_id, ret);
>> +	if (mmal_ctrl->ignore_errors)
>> +		ret = 0;
>> +	return ret;
>> +}
>> +
>> +static const struct v4l2_ctrl_ops bm2835_mmal_ctrl_ops = {
>> +	.s_ctrl = bm2835_mmal_s_ctrl,
>> +};
>> +
>> +
>> +
>> +static const struct bm2835_mmal_v4l2_ctrl v4l2_ctrls[V4L2_CTRL_COUNT] = {
>> +	{
>> +		V4L2_CID_SATURATION, MMAL_CONTROL_TYPE_STD,
>> +		-100, 100, 0, 1, NULL,
>> +		MMAL_PARAMETER_SATURATION,
>> +		&ctrl_set_rational,
>> +		false
>> +	},
>> +	{
>> +		V4L2_CID_SHARPNESS, MMAL_CONTROL_TYPE_STD,
>> +		-100, 100, 0, 1, NULL,
>> +		MMAL_PARAMETER_SHARPNESS,
>> +		&ctrl_set_rational,
>> +		false
>> +	},
>> +	{
>> +		V4L2_CID_CONTRAST, MMAL_CONTROL_TYPE_STD,
>> +		-100, 100, 0, 1, NULL,
>> +		MMAL_PARAMETER_CONTRAST,
>> +		&ctrl_set_rational,
>> +		false
>> +	},
>> +	{
>> +		V4L2_CID_BRIGHTNESS, MMAL_CONTROL_TYPE_STD,
>> +		0, 100, 50, 1, NULL,
>> +		MMAL_PARAMETER_BRIGHTNESS,
>> +		&ctrl_set_rational,
>> +		false
>> +	},
>> +	{
>> +		V4L2_CID_ISO_SENSITIVITY, MMAL_CONTROL_TYPE_INT_MENU,
>> +		0, ARRAY_SIZE(iso_qmenu) - 1, 0, 1, iso_qmenu,
>> +		MMAL_PARAMETER_ISO,
>> +		&ctrl_set_iso,
>> +		false
>> +	},
>> +	{
>> +		V4L2_CID_ISO_SENSITIVITY_AUTO, MMAL_CONTROL_TYPE_STD_MENU,
>> +		0, 1, V4L2_ISO_SENSITIVITY_AUTO, 1, NULL,
>> +		MMAL_PARAMETER_ISO,
>> +		&ctrl_set_iso,
>> +		false
>> +	},
>> +	{
>> +		V4L2_CID_IMAGE_STABILIZATION, MMAL_CONTROL_TYPE_STD,
>> +		0, 1, 0, 1, NULL,
>> +		MMAL_PARAMETER_VIDEO_STABILISATION,
>> +		&ctrl_set_value,
>> +		false
>> +	},
>> +/*	{
>> +		0, MMAL_CONTROL_TYPE_CLUSTER, 3, 1, 0, NULL, 0, NULL
>> +	}, */
>> +	{
>> +		V4L2_CID_EXPOSURE_AUTO, MMAL_CONTROL_TYPE_STD_MENU,
>> +		~0x03, 3, V4L2_EXPOSURE_AUTO, 0, NULL,
>> +		MMAL_PARAMETER_EXPOSURE_MODE,
>> +		&ctrl_set_exposure,
>> +		false
>> +	},
>> +/* todo this needs mixing in with set exposure
>> +	{
>> +	       V4L2_CID_SCENE_MODE, MMAL_CONTROL_TYPE_STD_MENU,
>> +	},
>> + */
>> +	{
>> +		V4L2_CID_EXPOSURE_ABSOLUTE, MMAL_CONTROL_TYPE_STD,
>> +		/* Units of 100usecs */
>> +		1, 1*1000*10, 100*10, 1, NULL,
>> +		MMAL_PARAMETER_SHUTTER_SPEED,
>> +		&ctrl_set_exposure,
>> +		false
>> +	},
>> +	{
>> +		V4L2_CID_AUTO_EXPOSURE_BIAS, MMAL_CONTROL_TYPE_INT_MENU,
>> +		0, ARRAY_SIZE(ev_bias_qmenu) - 1,
>> +		(ARRAY_SIZE(ev_bias_qmenu)+1)/2 - 1, 0, ev_bias_qmenu,
>> +		MMAL_PARAMETER_EXPOSURE_COMP,
>> +		&ctrl_set_value_ev,
>> +		false
>> +	},
>> +	{
>> +		V4L2_CID_EXPOSURE_AUTO_PRIORITY, MMAL_CONTROL_TYPE_STD,
>> +		0, 1,
>> +		0, 1, NULL,
>> +		0,	/* Dummy MMAL ID as it gets mapped into FPS range*/
>> +		&ctrl_set_exposure,
>> +		false
>> +	},
>> +	{
>> +		V4L2_CID_EXPOSURE_METERING,
>> +		MMAL_CONTROL_TYPE_STD_MENU,
>> +		~0x7, 2, V4L2_EXPOSURE_METERING_AVERAGE, 0, NULL,
>> +		MMAL_PARAMETER_EXP_METERING_MODE,
>> +		&ctrl_set_metering_mode,
>> +		false
>> +	},
>> +	{
>> +		V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE,
>> +		MMAL_CONTROL_TYPE_STD_MENU,
>> +		~0x3ff, 9, V4L2_WHITE_BALANCE_AUTO, 0, NULL,
>> +		MMAL_PARAMETER_AWB_MODE,
>> +		&ctrl_set_awb_mode,
>> +		false
>> +	},
>> +	{
>> +		V4L2_CID_RED_BALANCE, MMAL_CONTROL_TYPE_STD,
>> +		1, 7999, 1000, 1, NULL,
>> +		MMAL_PARAMETER_CUSTOM_AWB_GAINS,
>> +		&ctrl_set_awb_gains,
>> +		false
>> +	},
>> +	{
>> +		V4L2_CID_BLUE_BALANCE, MMAL_CONTROL_TYPE_STD,
>> +		1, 7999, 1000, 1, NULL,
>> +		MMAL_PARAMETER_CUSTOM_AWB_GAINS,
>> +		&ctrl_set_awb_gains,
>> +		false
>> +	},
>> +	{
>> +		V4L2_CID_COLORFX, MMAL_CONTROL_TYPE_STD_MENU,
>> +		0, 15, V4L2_COLORFX_NONE, 0, NULL,
>> +		MMAL_PARAMETER_IMAGE_EFFECT,
>> +		&ctrl_set_image_effect,
>> +		false
>> +	},
>> +	{
>> +		V4L2_CID_COLORFX_CBCR, MMAL_CONTROL_TYPE_STD,
>> +		0, 0xffff, 0x8080, 1, NULL,
>> +		MMAL_PARAMETER_COLOUR_EFFECT,
>> +		&ctrl_set_colfx,
>> +		false
>> +	},
>> +	{
>> +		V4L2_CID_ROTATE, MMAL_CONTROL_TYPE_STD,
>> +		0, 360, 0, 90, NULL,
>> +		MMAL_PARAMETER_ROTATION,
>> +		&ctrl_set_rotate,
>> +		false
>> +	},
>> +	{
>> +		V4L2_CID_HFLIP, MMAL_CONTROL_TYPE_STD,
>> +		0, 1, 0, 1, NULL,
>> +		MMAL_PARAMETER_MIRROR,
>> +		&ctrl_set_flip,
>> +		false
>> +	},
>> +	{
>> +		V4L2_CID_VFLIP, MMAL_CONTROL_TYPE_STD,
>> +		0, 1, 0, 1, NULL,
>> +		MMAL_PARAMETER_MIRROR,
>> +		&ctrl_set_flip,
>> +		false
>> +	},
>> +	{
>> +		V4L2_CID_MPEG_VIDEO_BITRATE_MODE, MMAL_CONTROL_TYPE_STD_MENU,
>> +		0, ARRAY_SIZE(bitrate_mode_qmenu) - 1,
>> +		0, 0, bitrate_mode_qmenu,
>> +		MMAL_PARAMETER_RATECONTROL,
>> +		&ctrl_set_bitrate_mode,
>> +		false
>> +	},
>> +	{
>> +		V4L2_CID_MPEG_VIDEO_BITRATE, MMAL_CONTROL_TYPE_STD,
>> +		25*1000, 25*1000*1000, 10*1000*1000, 25*1000, NULL,
>> +		MMAL_PARAMETER_VIDEO_BIT_RATE,
>> +		&ctrl_set_bitrate,
>> +		false
>> +	},
>> +	{
>> +		V4L2_CID_JPEG_COMPRESSION_QUALITY, MMAL_CONTROL_TYPE_STD,
>> +		1, 100,
>> +		30, 1, NULL,
>> +		MMAL_PARAMETER_JPEG_Q_FACTOR,
>> +		&ctrl_set_image_encode_output,
>> +		false
>> +	},
>> +	{
>> +		V4L2_CID_POWER_LINE_FREQUENCY, MMAL_CONTROL_TYPE_STD_MENU,
>> +		0, ARRAY_SIZE(mains_freq_qmenu) - 1,
>> +		1, 1, NULL,
>> +		MMAL_PARAMETER_FLICKER_AVOID,
>> +		&ctrl_set_flicker_avoidance,
>> +		false
>> +	},
>> +	{
>> +		V4L2_CID_MPEG_VIDEO_REPEAT_SEQ_HEADER, MMAL_CONTROL_TYPE_STD,
>> +		0, 1,
>> +		0, 1, NULL,
>> +		MMAL_PARAMETER_VIDEO_ENCODE_INLINE_HEADER,
>> +		&ctrl_set_video_encode_param_output,
>> +		true	/* Errors ignored as requires latest firmware to work */
>> +	},
>> +	{
>> +		V4L2_CID_MPEG_VIDEO_H264_PROFILE,
>> +		MMAL_CONTROL_TYPE_STD_MENU,
>> +		~((1<<V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE) |
>> +			(1<<V4L2_MPEG_VIDEO_H264_PROFILE_CONSTRAINED_BASELINE) |
>> +			(1<<V4L2_MPEG_VIDEO_H264_PROFILE_MAIN) |
>> +			(1<<V4L2_MPEG_VIDEO_H264_PROFILE_HIGH)),
>> +		V4L2_MPEG_VIDEO_H264_PROFILE_HIGH,
>> +		V4L2_MPEG_VIDEO_H264_PROFILE_HIGH, 1, NULL,
>> +		MMAL_PARAMETER_PROFILE,
>> +		&ctrl_set_video_encode_profile_level,
>> +		false
>> +	},
>> +	{
>> +		V4L2_CID_MPEG_VIDEO_H264_LEVEL, MMAL_CONTROL_TYPE_STD_MENU,
>> +		~((1<<V4L2_MPEG_VIDEO_H264_LEVEL_1_0) |
>> +			(1<<V4L2_MPEG_VIDEO_H264_LEVEL_1B) |
>> +			(1<<V4L2_MPEG_VIDEO_H264_LEVEL_1_1) |
>> +			(1<<V4L2_MPEG_VIDEO_H264_LEVEL_1_2) |
>> +			(1<<V4L2_MPEG_VIDEO_H264_LEVEL_1_3) |
>> +			(1<<V4L2_MPEG_VIDEO_H264_LEVEL_2_0) |
>> +			(1<<V4L2_MPEG_VIDEO_H264_LEVEL_2_1) |
>> +			(1<<V4L2_MPEG_VIDEO_H264_LEVEL_2_2) |
>> +			(1<<V4L2_MPEG_VIDEO_H264_LEVEL_3_0) |
>> +			(1<<V4L2_MPEG_VIDEO_H264_LEVEL_3_1) |
>> +			(1<<V4L2_MPEG_VIDEO_H264_LEVEL_3_2) |
>> +			(1<<V4L2_MPEG_VIDEO_H264_LEVEL_4_0)),
>> +		V4L2_MPEG_VIDEO_H264_LEVEL_4_0,
>> +		V4L2_MPEG_VIDEO_H264_LEVEL_4_0, 1, NULL,
>> +		MMAL_PARAMETER_PROFILE,
>> +		&ctrl_set_video_encode_profile_level,
>> +		false
>> +	},
>> +	{
>> +		V4L2_CID_SCENE_MODE, MMAL_CONTROL_TYPE_STD_MENU,
>> +		-1,	/* Min is computed at runtime */
>> +		V4L2_SCENE_MODE_TEXT,
>> +		V4L2_SCENE_MODE_NONE, 1, NULL,
>> +		MMAL_PARAMETER_PROFILE,
>> +		&ctrl_set_scene_mode,
>> +		false
>> +	},
>> +	{
>> +		V4L2_CID_MPEG_VIDEO_H264_I_PERIOD, MMAL_CONTROL_TYPE_STD,
>> +		0, 0x7FFFFFFF, 60, 1, NULL,
>> +		MMAL_PARAMETER_INTRAPERIOD,
>> +		&ctrl_set_video_encode_param_output,
>> +		false
>> +	},
>> +};
>> +
>> +int bm2835_mmal_set_all_camera_controls(struct bm2835_mmal_dev *dev)
>> +{
>> +	int c;
>> +	int ret = 0;
>> +
>> +	for (c = 0; c < V4L2_CTRL_COUNT; c++) {
>> +		if ((dev->ctrls[c]) && (v4l2_ctrls[c].setter)) {
>> +			ret = v4l2_ctrls[c].setter(dev, dev->ctrls[c],
>> +						   &v4l2_ctrls[c]);
>> +			if (!v4l2_ctrls[c].ignore_errors && ret) {
>> +				v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
>> +					"Failed when setting default values for ctrl %d\n",
>> +					c);
>> +				break;
>> +			}
>> +		}
>> +	}
>> +	return ret;
>> +}
>> +
>> +int set_framerate_params(struct bm2835_mmal_dev *dev)
>> +{
>> +	struct mmal_parameter_fps_range fps_range;
>> +	int ret;
>> +
>> +	if ((dev->exposure_mode_active != MMAL_PARAM_EXPOSUREMODE_OFF) &&
>> +	     (dev->exp_auto_priority)) {
>> +		/* Variable FPS. Define min FPS as 1fps.
>> +		 * Max as max defined FPS.
>> +		 */
>> +		fps_range.fps_low.num = 1;
>> +		fps_range.fps_low.den = 1;
>> +		fps_range.fps_high.num = dev->capture.timeperframe.denominator;
>> +		fps_range.fps_high.den = dev->capture.timeperframe.numerator;
>> +	} else {
>> +		/* Fixed FPS - set min and max to be the same */
>> +		fps_range.fps_low.num = fps_range.fps_high.num =
>> +			dev->capture.timeperframe.denominator;
>> +		fps_range.fps_low.den = fps_range.fps_high.den =
>> +			dev->capture.timeperframe.numerator;
>> +	}
>> +
>> +	v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
>> +			 "Set fps range to %d/%d to %d/%d\n",
>> +			 fps_range.fps_low.num,
>> +			 fps_range.fps_low.den,
>> +			 fps_range.fps_high.num,
>> +			 fps_range.fps_high.den
>> +		 );
>> +
>> +	ret = vchiq_mmal_port_parameter_set(dev->instance,
>> +				      &dev->component[MMAL_COMPONENT_CAMERA]->
>> +					output[MMAL_CAMERA_PORT_PREVIEW],
>> +				      MMAL_PARAMETER_FPS_RANGE,
>> +				      &fps_range, sizeof(fps_range));
>> +	ret += vchiq_mmal_port_parameter_set(dev->instance,
>> +				      &dev->component[MMAL_COMPONENT_CAMERA]->
>> +					output[MMAL_CAMERA_PORT_VIDEO],
>> +				      MMAL_PARAMETER_FPS_RANGE,
>> +				      &fps_range, sizeof(fps_range));
>> +	ret += vchiq_mmal_port_parameter_set(dev->instance,
>> +				      &dev->component[MMAL_COMPONENT_CAMERA]->
>> +					output[MMAL_CAMERA_PORT_CAPTURE],
>> +				      MMAL_PARAMETER_FPS_RANGE,
>> +				      &fps_range, sizeof(fps_range));
>> +	if (ret)
>> +		v4l2_dbg(0, bcm2835_v4l2_debug, &dev->v4l2_dev,
>> +		 "Failed to set fps ret %d\n",
>> +		 ret);
>> +
>> +	return ret;
>> +
>> +}
>> +
>> +int bm2835_mmal_init_controls(struct bm2835_mmal_dev *dev,
>> +			      struct v4l2_ctrl_handler *hdl)
>> +{
>> +	int c;
>> +	const struct bm2835_mmal_v4l2_ctrl *ctrl;
>> +
>> +	v4l2_ctrl_handler_init(hdl, V4L2_CTRL_COUNT);
>> +
>> +	for (c = 0; c < V4L2_CTRL_COUNT; c++) {
>> +		ctrl = &v4l2_ctrls[c];
>> +
>> +		switch (ctrl->type) {
>> +		case MMAL_CONTROL_TYPE_STD:
>> +			dev->ctrls[c] = v4l2_ctrl_new_std(hdl,
>> +				&bm2835_mmal_ctrl_ops, ctrl->id,
>> +				ctrl->min, ctrl->max, ctrl->step, ctrl->def);
>> +			break;
>> +
>> +		case MMAL_CONTROL_TYPE_STD_MENU:
>> +		{
>> +			int mask = ctrl->min;
>> +
>> +			if (ctrl->id == V4L2_CID_SCENE_MODE) {
>> +				/* Special handling to work out the mask
>> +				 * value based on the scene_configs array
>> +				 * at runtime. Reduces the chance of
>> +				 * mismatches.
>> +				 */
>> +				int i;
>> +				mask = 1<<V4L2_SCENE_MODE_NONE;
>> +				for (i = 0;
>> +				     i < ARRAY_SIZE(scene_configs);
>> +				     i++) {
>> +					mask |= 1<<scene_configs[i].v4l2_scene;
>> +				}
>> +				mask = ~mask;
>> +			}
>> +
>> +			dev->ctrls[c] = v4l2_ctrl_new_std_menu(hdl,
>> +			&bm2835_mmal_ctrl_ops, ctrl->id,
>> +			ctrl->max, mask, ctrl->def);
>> +			break;
>> +		}
>> +
>> +		case MMAL_CONTROL_TYPE_INT_MENU:
>> +			dev->ctrls[c] = v4l2_ctrl_new_int_menu(hdl,
>> +				&bm2835_mmal_ctrl_ops, ctrl->id,
>> +				ctrl->max, ctrl->def, ctrl->imenu);
>> +			break;
>> +
>> +		case MMAL_CONTROL_TYPE_CLUSTER:
>> +			/* skip this entry when constructing controls */
>> +			continue;
>> +		}
>> +
>> +		if (hdl->error)
>> +			break;
>> +
>> +		dev->ctrls[c]->priv = (void *)ctrl;
>> +	}
>> +
>> +	if (hdl->error) {
>> +		pr_err("error adding control %d/%d id 0x%x\n", c,
>> +			 V4L2_CTRL_COUNT, ctrl->id);
>> +		return hdl->error;
>> +	}
>> +
>> +	for (c = 0; c < V4L2_CTRL_COUNT; c++) {
>> +		ctrl = &v4l2_ctrls[c];
>> +
>> +		switch (ctrl->type) {
>> +		case MMAL_CONTROL_TYPE_CLUSTER:
>> +			v4l2_ctrl_auto_cluster(ctrl->min,
>> +					       &dev->ctrls[c+1],
>> +					       ctrl->max,
>> +					       ctrl->def);
>> +			break;
>> +
>> +		case MMAL_CONTROL_TYPE_STD:
>> +		case MMAL_CONTROL_TYPE_STD_MENU:
>> +		case MMAL_CONTROL_TYPE_INT_MENU:
>> +			break;
>> +		}
>> +
>> +	}
>> +
>> +	return 0;
>> +}
>
> This is IMHO unnecessarily complex.
>
> My recommendation is that controls are added with a set of v4l2_ctrl_new_std* calls
> or if you really want to by walking a struct v4l2_ctrl_config array and adding controls
> via v4l2_ctrl_new_custom.
>
> The s_ctrl is a switch that calls the 'setter' function.
>
> No need for arrays, callbacks, etc. Just keep it simple.

I can look into that, but I'm not sure I fully follow what you are 
suggesting.

In the current implementation things like V4L2_CID_SATURATION, 
V4L2_CID_SHARPNESS, V4L2_CID_CONTRAST, and V4L2_CID_BRIGHTNESS all use 
the one common ctrl_set_rational setter function because the only thing 
different in setting is the MMAL_PARAMETER_xxx value. I guess that could 
move into the common setter based on V4L2_CID_xxx, but then the control 
configuration is split between multiple places which feels less well 
contained.

> <snip>
>
> Final question: did you run v4l2-compliance over this driver? Before this driver can
> be moved out of staging it should pass the compliance tests. Note: always compile
> this test from the main repository, don't rely on distros. That ensures you use the
> latest code.
>
> The compliance test is part of the v4l-utils repo (https://git.linuxtv.org/v4l-utils.git/).
>
> If you have any questions about the v4l2-compliance output (it can be a bit obscure at
> times), just mail me or ask the question on the #v4l irc channel.

I haven't checked this version, but the downstream version has 43 
passes, 0 failures, 0 warnings.

The full output:
v4l2-compliance SHA   : 99306f20cc7e76cf2161e3059de4da245aed2130

Driver Info:
	Driver name   : bm2835 mmal
	Card type     : mmal service 16.1
	Bus info      : platform:bcm2835-v4l2
	Driver version: 4.4.45
	Capabilities  : 0x85200005
		Video Capture
		Video Overlay
		Read/Write
		Streaming
		Extended Pix Format
		Device Capabilities
	Device Caps   : 0x05200005
		Video Capture
		Video Overlay
		Read/Write
		Streaming
		Extended Pix Format

Compliance test for device /dev/video0 (not using libv4l2):

Required ioctls:
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second video open: OK
	test VIDIOC_QUERYCAP: OK
	test VIDIOC_G/S_PRIORITY: OK
	test for unlimited opens: OK

Debug ioctls:
	test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
	test VIDIOC_LOG_STATUS: OK

Input ioctls:
	test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
	test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
	test VIDIOC_ENUMAUDIO: OK (Not Supported)
	test VIDIOC_G/S/ENUMINPUT: OK
	test VIDIOC_G/S_AUDIO: OK (Not Supported)
	Inputs: 1 Audio Inputs: 0 Tuners: 0

Output ioctls:
	test VIDIOC_G/S_MODULATOR: OK (Not Supported)
	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
	test VIDIOC_ENUMAUDOUT: OK (Not Supported)
	test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
	test VIDIOC_G/S_AUDOUT: OK (Not Supported)
	Outputs: 0 Audio Outputs: 0 Modulators: 0

Input/Output configuration ioctls:
	test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
	test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
	test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
	test VIDIOC_G/S_EDID: OK (Not Supported)

Test input 0:

	Control ioctls:
		test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
		test VIDIOC_QUERYCTRL: OK
		test VIDIOC_G/S_CTRL: OK
		test VIDIOC_G/S/TRY_EXT_CTRLS: OK
		test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
		test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
		Standard Controls: 33 Private Controls: 0

	Format ioctls:
		test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
		test VIDIOC_G/S_PARM: OK
		test VIDIOC_G_FBUF: OK
		test VIDIOC_G_FMT: OK
		test VIDIOC_TRY_FMT: OK
		test VIDIOC_S_FMT: OK
		test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
		test Cropping: OK (Not Supported)
		test Composing: OK (Not Supported)
		test Scaling: OK

	Codec ioctls:
		test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
		test VIDIOC_G_ENC_INDEX: OK (Not Supported)
		test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

	Buffer ioctls:
		test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
		test VIDIOC_EXPBUF: OK (Not Supported)

Test input 0:


Total: 43, Succeeded: 43, Failed: 0, Warnings: 0

Cheers.
   Dave
