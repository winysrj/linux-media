Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:55456 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751163AbdBFM7l (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Feb 2017 07:59:41 -0500
Subject: Re: [PATCH 1/6] staging: Import the BCM2835 MMAL-based V4L2 camera
 driver.
To: Eric Anholt <eric@anholt.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20170127215503.13208-1-eric@anholt.net>
 <20170127215503.13208-2-eric@anholt.net>
Cc: devel@driverdev.osuosl.org, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-rpi-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <1a19f3f3-6925-6477-9908-f7cbfb960f7f@xs4all.nl>
Date: Mon, 6 Feb 2017 13:59:35 +0100
MIME-Version: 1.0
In-Reply-To: <20170127215503.13208-2-eric@anholt.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/27/2017 10:54 PM, Eric Anholt wrote:
> - Supports raw YUV capture, preview, JPEG and H264.
> - Uses videobuf2 for data transfer, using dma_buf.
> - Uses 3.6.10 timestamping
> - Camera power based on use
> - Uses immutable input mode on video encoder
> 
> This code comes from the Raspberry Pi kernel tree (rpi-4.9.y) as of
> a15ba877dab4e61ea3fc7b006e2a73828b083c52.
> 
> Signed-off-by: Eric Anholt <eric@anholt.net>
> ---
>  .../media/platform/bcm2835/bcm2835-camera.c        | 2016 ++++++++++++++++++++
>  .../media/platform/bcm2835/bcm2835-camera.h        |  145 ++
>  drivers/staging/media/platform/bcm2835/controls.c  | 1345 +++++++++++++
>  .../staging/media/platform/bcm2835/mmal-common.h   |   53 +
>  .../media/platform/bcm2835/mmal-encodings.h        |  127 ++
>  .../media/platform/bcm2835/mmal-msg-common.h       |   50 +
>  .../media/platform/bcm2835/mmal-msg-format.h       |   81 +
>  .../staging/media/platform/bcm2835/mmal-msg-port.h |  107 ++
>  drivers/staging/media/platform/bcm2835/mmal-msg.h  |  404 ++++
>  .../media/platform/bcm2835/mmal-parameters.h       |  689 +++++++
>  .../staging/media/platform/bcm2835/mmal-vchiq.c    | 1916 +++++++++++++++++++
>  .../staging/media/platform/bcm2835/mmal-vchiq.h    |  178 ++
>  12 files changed, 7111 insertions(+)
>  create mode 100644 drivers/staging/media/platform/bcm2835/bcm2835-camera.c
>  create mode 100644 drivers/staging/media/platform/bcm2835/bcm2835-camera.h
>  create mode 100644 drivers/staging/media/platform/bcm2835/controls.c
>  create mode 100644 drivers/staging/media/platform/bcm2835/mmal-common.h
>  create mode 100644 drivers/staging/media/platform/bcm2835/mmal-encodings.h
>  create mode 100644 drivers/staging/media/platform/bcm2835/mmal-msg-common.h
>  create mode 100644 drivers/staging/media/platform/bcm2835/mmal-msg-format.h
>  create mode 100644 drivers/staging/media/platform/bcm2835/mmal-msg-port.h
>  create mode 100644 drivers/staging/media/platform/bcm2835/mmal-msg.h
>  create mode 100644 drivers/staging/media/platform/bcm2835/mmal-parameters.h
>  create mode 100644 drivers/staging/media/platform/bcm2835/mmal-vchiq.c
>  create mode 100644 drivers/staging/media/platform/bcm2835/mmal-vchiq.h
> 
> diff --git a/drivers/staging/media/platform/bcm2835/bcm2835-camera.c b/drivers/staging/media/platform/bcm2835/bcm2835-camera.c
> new file mode 100644
> index 000000000000..4f03949aecf3
> --- /dev/null
> +++ b/drivers/staging/media/platform/bcm2835/bcm2835-camera.c
> @@ -0,0 +1,2016 @@

<snip>

> +static int __init bm2835_mmal_init(void)
> +{
> +	int ret;
> +	struct bm2835_mmal_dev *dev;
> +	struct vb2_queue *q;
> +	int camera;
> +	unsigned int num_cameras;
> +	struct vchiq_mmal_instance *instance;
> +	unsigned int resolutions[MAX_BCM2835_CAMERAS][2];
> +
> +	ret = vchiq_mmal_init(&instance);
> +	if (ret < 0)
> +		return ret;
> +
> +	num_cameras = get_num_cameras(instance,
> +				      resolutions,
> +				      MAX_BCM2835_CAMERAS);
> +	if (num_cameras > MAX_BCM2835_CAMERAS)
> +		num_cameras = MAX_BCM2835_CAMERAS;
> +
> +	for (camera = 0; camera < num_cameras; camera++) {
> +		dev = kzalloc(sizeof(struct bm2835_mmal_dev), GFP_KERNEL);
> +		if (!dev)
> +			return -ENOMEM;
> +
> +		dev->camera_num = camera;
> +		dev->max_width = resolutions[camera][0];
> +		dev->max_height = resolutions[camera][1];
> +
> +		/* setup device defaults */
> +		dev->overlay.w.left = 150;
> +		dev->overlay.w.top = 50;
> +		dev->overlay.w.width = 1024;
> +		dev->overlay.w.height = 768;
> +		dev->overlay.clipcount = 0;
> +		dev->overlay.field = V4L2_FIELD_NONE;
> +		dev->overlay.global_alpha = 255;
> +
> +		dev->capture.fmt = &formats[3]; /* JPEG */
> +
> +		/* v4l device registration */
> +		snprintf(dev->v4l2_dev.name, sizeof(dev->v4l2_dev.name),
> +			 "%s", BM2835_MMAL_MODULE_NAME);
> +		ret = v4l2_device_register(NULL, &dev->v4l2_dev);
> +		if (ret)
> +			goto free_dev;
> +
> +		/* setup v4l controls */
> +		ret = bm2835_mmal_init_controls(dev, &dev->ctrl_handler);
> +		if (ret < 0)
> +			goto unreg_dev;
> +		dev->v4l2_dev.ctrl_handler = &dev->ctrl_handler;
> +
> +		/* mmal init */
> +		dev->instance = instance;
> +		ret = mmal_init(dev);
> +		if (ret < 0)
> +			goto unreg_dev;
> +
> +		/* initialize queue */
> +		q = &dev->capture.vb_vidq;
> +		memset(q, 0, sizeof(*q));
> +		q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +		q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_READ;

I'm missing VB2_DMABUF here!

In fact, with dmabuf support I wonder if you still need overlay support.

Using dma-buf and just pass a gpu buffer to v4l2 is preferred over overlays.

Regards,

	Hans

> +		q->drv_priv = dev;
> +		q->buf_struct_size = sizeof(struct mmal_buffer);
> +		q->ops = &bm2835_mmal_video_qops;
> +		q->mem_ops = &vb2_vmalloc_memops;
> +		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +		ret = vb2_queue_init(q);
> +		if (ret < 0)
> +			goto unreg_dev;
> +
> +		/* v4l2 core mutex used to protect all fops and v4l2 ioctls. */
> +		mutex_init(&dev->mutex);
> +
> +		/* initialise video devices */
> +		ret = bm2835_mmal_init_device(dev, &dev->vdev);
> +		if (ret < 0)
> +			goto unreg_dev;
> +
> +		/* Really want to call vidioc_s_fmt_vid_cap with the default
> +		 * format, but currently the APIs don't join up.
> +		 */
> +		ret = mmal_setup_components(dev, &default_v4l2_format);
> +		if (ret < 0) {
> +			v4l2_err(&dev->v4l2_dev,
> +				 "%s: could not setup components\n", __func__);
> +			goto unreg_dev;
> +		}
> +
> +		v4l2_info(&dev->v4l2_dev,
> +			  "Broadcom 2835 MMAL video capture ver %s loaded.\n",
> +			  BM2835_MMAL_VERSION);
> +
> +		gdev[camera] = dev;
> +	}
> +	return 0;
> +
> +unreg_dev:
> +	v4l2_ctrl_handler_free(&dev->ctrl_handler);
> +	v4l2_device_unregister(&dev->v4l2_dev);
> +
> +free_dev:
> +	kfree(dev);
> +
> +	for ( ; camera > 0; camera--) {
> +		bcm2835_cleanup_instance(gdev[camera]);
> +		gdev[camera] = NULL;
> +	}
> +	pr_info("%s: error %d while loading driver\n",
> +		 BM2835_MMAL_MODULE_NAME, ret);
> +
> +	return ret;
> +}
> +
> +static void __exit bm2835_mmal_exit(void)
> +{
> +	int camera;
> +	struct vchiq_mmal_instance *instance = gdev[0]->instance;
> +
> +	for (camera = 0; camera < MAX_BCM2835_CAMERAS; camera++) {
> +		bcm2835_cleanup_instance(gdev[camera]);
> +		gdev[camera] = NULL;
> +	}
> +	vchiq_mmal_finalise(instance);
> +}
> +
> +module_init(bm2835_mmal_init);
> +module_exit(bm2835_mmal_exit);

