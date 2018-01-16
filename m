Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33610 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751101AbeAPLxI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 Jan 2018 06:53:08 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, magnus.damm@gmail.com,
        geert@glider.be, mchehab@kernel.org, festevam@gmail.com,
        sakari.ailus@iki.fi, robh+dt@kernel.org, mark.rutland@arm.com,
        pombredanne@nexb.com, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 3/9] v4l: platform: Add Renesas CEU driver
Date: Tue, 16 Jan 2018 13:53:11 +0200
Message-ID: <2652648.B6TWr8Lan7@avalon>
In-Reply-To: <ba0540cd-c0b9-31a3-4bc8-7f32e4d85cf5@xs4all.nl>
References: <1515765849-10345-1-git-send-email-jacopo+renesas@jmondi.org> <1515765849-10345-4-git-send-email-jacopo+renesas@jmondi.org> <ba0540cd-c0b9-31a3-4bc8-7f32e4d85cf5@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tuesday, 16 January 2018 11:46:42 EET Hans Verkuil wrote:
> Hi Jacopo,
> 
> Sorry for the late review, but here is finally is.
> 
> BTW, can you provide the v4l2-compliance output (ideally with the -f option)
> in the cover letter for v6?
> 
> On 01/12/2018 03:04 PM, Jacopo Mondi wrote:
> > Add driver for Renesas Capture Engine Unit (CEU).
> > 
> > The CEU interface supports capturing 'data' (YUV422) and 'images'
> > (NV[12|21|16|61]).
> > 
> > This driver aims to replace the soc_camera-based sh_mobile_ceu one.
> > 
> > Tested with ov7670 camera sensor, providing YUYV_2X8 data on Renesas RZ
> > platform GR-Peach.
> > 
> > Tested with ov7725 camera sensor on SH4 platform Migo-R.
> > 
> > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> >  drivers/media/platform/Kconfig       |    9 +
> >  drivers/media/platform/Makefile      |    1 +
> >  drivers/media/platform/renesas-ceu.c | 1648 +++++++++++++++++++++++++++++
> >  3 files changed, 1658 insertions(+)
> >  create mode 100644 drivers/media/platform/renesas-ceu.c

[snip]

> > diff --git a/drivers/media/platform/renesas-ceu.c
> > b/drivers/media/platform/renesas-ceu.c new file mode 100644
> > index 0000000..ccca838
> > --- /dev/null
> > +++ b/drivers/media/platform/renesas-ceu.c

[snip]

> > +static int ceu_s_input(struct file *file, void *priv, unsigned int i)
> > +{
> > +	struct ceu_device *ceudev = video_drvdata(file);
> > +	struct ceu_subdev *ceu_sd_old;
> > +	int ret;
> > +
> 
> Add a check:
> 
> 	if (i == ceudev->sd_index)
> 		return 0;
> 
> I.e. if the new input == the old input, then that's fine regardless of the
> streaming state.

On a side note this is the kind of checks that the core should handle, but 
that's out of scope for this patch.

> > +	if (vb2_is_streaming(&ceudev->vb2_vq))
> > +		return -EBUSY;
> > +
> > +	if (i >= ceudev->num_sd)
> > +		return -EINVAL;
> 
> Move this up as the first test.
> 
> > +
> > +	ceu_sd_old = ceudev->sd;
> > +	ceudev->sd = &ceudev->subdevs[i];
> > +
> > +	/* Make sure we can generate output image formats. */
> > +	ret = ceu_init_formats(ceudev);
> > +	if (ret) {
> > +		ceudev->sd = ceu_sd_old;
> > +		return -EINVAL;
> > +	}
> > +
> > +	/* now that we're sure we can use the sensor, power off the old one. */
> > +	v4l2_subdev_call(ceu_sd_old->v4l2_sd, core, s_power, 0);
> > +	v4l2_subdev_call(ceudev->sd->v4l2_sd, core, s_power, 1);
> > +
> > +	ceudev->sd_index = i;
> > +
> > +	return 0;
> > +}

[snip]

> > +
> > +static int ceu_notify_complete(struct v4l2_async_notifier *notifier)
> > +{
> > +	struct v4l2_device *v4l2_dev = notifier->v4l2_dev;
> > +	struct ceu_device *ceudev = v4l2_to_ceu(v4l2_dev);
> > +	struct video_device *vdev = &ceudev->vdev;
> > +	struct vb2_queue *q = &ceudev->vb2_vq;
> > +	struct v4l2_subdev *v4l2_sd;
> > +	int ret;
> > +
> > +	/* Initialize vb2 queue. */
> > +	q->type			= V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> > +	q->io_modes		= VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
> 
> Don't include VB2_USERPTR. It shouldn't be used with dma_contig.
> 
> You also added a read() fop (vb2_fop_read), so either add VB2_READ here
> or remove the read fop.

Agreed. I'd drop both VB2_USERPTR and vb2_fop_read().

> > +	q->drv_priv		= ceudev;
> > +	q->ops			= &ceu_vb2_ops;
> > +	q->mem_ops		= &vb2_dma_contig_memops;
> > +	q->buf_struct_size	= sizeof(struct ceu_buffer);
> > +	q->timestamp_flags	= V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> > +	q->lock			= &ceudev->mlock;
> > +	q->dev			= ceudev->v4l2_dev.dev;
> > +
> > +	ret = vb2_queue_init(q);
> > +	if (ret)
> > +		return ret;
> > +
> > +	/*
> > +	 * Make sure at least one sensor is primary and use it to initialize
> > +	 * ceu formats.
> > +	 */
> > +	if (!ceudev->sd) {
> > +		ceudev->sd = &ceudev->subdevs[0];
> > +		ceudev->sd_index = 0;
> > +	}
> > +
> > +	v4l2_sd = ceudev->sd->v4l2_sd;
> > +
> > +	ret = ceu_init_formats(ceudev);
> > +	if (ret)
> > +		return ret;
> > +
> > +	ret = ceu_set_default_fmt(ceudev);
> > +	if (ret)
> > +		return ret;
> > +
> > +	/* Register the video device. */
> > +	strncpy(vdev->name, DRIVER_NAME, strlen(DRIVER_NAME));
> > +	vdev->v4l2_dev		= v4l2_dev;
> > +	vdev->lock		= &ceudev->mlock;
> > +	vdev->queue		= &ceudev->vb2_vq;
> > +	vdev->ctrl_handler	= v4l2_sd->ctrl_handler;
> > +	vdev->fops		= &ceu_fops;
> > +	vdev->ioctl_ops		= &ceu_ioctl_ops;
> > +	vdev->release		= ceu_vdev_release;
> > +	vdev->device_caps	= V4L2_CAP_VIDEO_CAPTURE_MPLANE |
> > +				  V4L2_CAP_STREAMING;
> > +	video_set_drvdata(vdev, ceudev);
> > +
> > +	ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
> > +	if (ret < 0) {
> > +		v4l2_err(vdev->v4l2_dev,
> > +			 "video_register_device failed: %d\n", ret);
> > +		return ret;
> > +	}
> > +
> > +	return 0;
> > +}

[snip]

You can keep my ack after addressing Hans' comments.

-- 
Regards,

Laurent Pinchart
