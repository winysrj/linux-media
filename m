Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52401 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755499AbaKANYZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Nov 2014 09:24:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Michal Simek <michal.simek@xilinx.com>,
	Chris Kohn <christian.kohn@xilinx.com>,
	Hyun Kwon <hyun.kwon@xilinx.com>,
	Radhey Shyam Pandey <radheys@xilinx.com>,
	devicetree@vger.kernel.org
Subject: Re: [PATCH 09/11] v4l: xilinx: Add Xilinx Video IP core
Date: Sat, 01 Nov 2014 15:24:32 +0200
Message-ID: <1753132.KBqocWzxIH@avalon>
In-Reply-To: <542AB836.1060500@xs4all.nl>
References: <1412022477-28749-1-git-send-email-laurent.pinchart@ideasonboard.com> <1412022477-28749-10-git-send-email-laurent.pinchart@ideasonboard.com> <542AB836.1060500@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the review. I've fixed most of the issues you've pointed out, 
please find my replies to the remaining ones below.

On Tuesday 30 September 2014 16:03:34 Hans Verkuil wrote:
> On 09/29/14 22:27, Laurent Pinchart wrote:
> > Xilinx platforms have no hardwired video capture or video processing
> > interface. Users create capture and memory to memory processing
> > pipelines in the FPGA fabric to suit their particular needs, by
> > instantiating video IP cores from a large library.
> > 
> > The Xilinx Video IP core is a framework that models a video pipeline
> > described in the device tree and expose the pipeline to userspace
> > through the media controller and V4L2 APIs.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Signed-off-by: Hyun Kwon <hyun.kwon@xilinx.com>
> > Signed-off-by: Radhey Shyam Pandey <radheys@xilinx.com>
> > Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> > ---
> > 
> >  .../devicetree/bindings/media/xilinx/video.txt     |  52 ++
> >  .../bindings/media/xilinx/xlnx,video.txt           |  55 ++
> >  MAINTAINERS                                        |   9 +
> >  drivers/media/platform/Kconfig                     |   1 +
> >  drivers/media/platform/Makefile                    |   2 +
> >  drivers/media/platform/xilinx/Kconfig              |  10 +
> >  drivers/media/platform/xilinx/Makefile             |   3 +
> >  drivers/media/platform/xilinx/xilinx-dma.c         | 995 ++++++++++++++++
> >  drivers/media/platform/xilinx/xilinx-dma.h         | 109 +++
> >  drivers/media/platform/xilinx/xilinx-vip.c         | 269 ++++++
> >  drivers/media/platform/xilinx/xilinx-vip.h         | 227 +++++
> >  drivers/media/platform/xilinx/xilinx-vipp.c        | 666 ++++++++++++++
> >  drivers/media/platform/xilinx/xilinx-vipp.h        |  47 +
> >  13 files changed, 2445 insertions(+)
> >  create mode 100644
> >  Documentation/devicetree/bindings/media/xilinx/video.txt
> >  create mode 100644
> >  Documentation/devicetree/bindings/media/xilinx/xlnx,video.txt create
> >  mode 100644 drivers/media/platform/xilinx/Kconfig
> >  create mode 100644 drivers/media/platform/xilinx/Makefile
> >  create mode 100644 drivers/media/platform/xilinx/xilinx-dma.c
> >  create mode 100644 drivers/media/platform/xilinx/xilinx-dma.h
> >  create mode 100644 drivers/media/platform/xilinx/xilinx-vip.c
> >  create mode 100644 drivers/media/platform/xilinx/xilinx-vip.h
> >  create mode 100644 drivers/media/platform/xilinx/xilinx-vipp.c
> >  create mode 100644 drivers/media/platform/xilinx/xilinx-vipp.h
> > 
> > Cc: devicetree@vger.kernel.org

[snip]

> > diff --git a/drivers/media/platform/xilinx/xilinx-dma.c
> > b/drivers/media/platform/xilinx/xilinx-dma.c new file mode 100644
> > index 0000000..e09e8bd
> > --- /dev/null
> > +++ b/drivers/media/platform/xilinx/xilinx-dma.c

[snip]

> > +static void
> > +__xvip_dma_try_format(struct xvip_dma *dma, struct v4l2_pix_format *pix,
> > +		      const struct xvip_video_format **fmtinfo)
> > +{
> > +	const struct xvip_video_format *info;
> > +	unsigned int min_width;
> > +	unsigned int max_width;
> > +	unsigned int min_bpl;
> > +	unsigned int max_bpl;
> > +	unsigned int width;
> > +	unsigned int align;
> > +	unsigned int bpl;
> > +
> > +	/* Retrieve format information and select the default format if the
> > +	 * requested format isn't supported.
> > +	 */
> > +	info = xvip_get_format_by_fourcc(pix->pixelformat);
> > +	if (IS_ERR(info))
> > +		info = xvip_get_format_by_fourcc(XVIP_DMA_DEF_FORMAT);
> > +
> > +	pix->pixelformat = info->fourcc;
> > +	pix->colorspace = V4L2_COLORSPACE_SRGB;
> 
> Colorspace information can be tricky: for capture the colorspace should
> come from the subdevs (e.g. the HDMI receiver), for output the colorspace
> is set by the application and passed on to the transmitter.

I agree with you. However, in the general case, this will be impossible to 
implement.

Imagine for instance a pipeline with two inputs, one from an HDMI decoder and 
one from a sensor. They are both connected to a composing unit that writes the 
resulting image to memory. The colorspace on the capture video node is then 
undefined.

Given that this driver is media controller based and relies on userspace to 
propagate formats through the pipeline during configuration, I believe it 
should also be userspace's responsibility to retrieve colorspace information 
from the correct subdev(s).

> I'll have a presentation on this topic during the media mini-summit.

It was very interesting, thanks again :-)

> > +	pix->field = V4L2_FIELD_NONE;
> > +
> > +	/* The transfer alignment requirements are expressed in bytes.
> > Compute
> > +	 * the minimum and maximum values, clamp the requested width and
> > convert
> > +	 * it back to pixels.
> > +	 */
> > +	align = lcm(dma->align, info->bpp);
> > +	min_width = roundup(XVIP_DMA_MIN_WIDTH, align);
> > +	max_width = rounddown(XVIP_DMA_MAX_WIDTH, align);
> > +	width = rounddown(pix->width * info->bpp, align);
> > +
> > +	pix->width = clamp(width, min_width, max_width) / info->bpp;
> > +	pix->height = clamp(pix->height, XVIP_DMA_MIN_HEIGHT,
> > +			    XVIP_DMA_MAX_HEIGHT);
> > +
> > +	/* Clamp the requested bytes per line value. If the maximum bytes per
> > +	 * line value is zero, the module doesn't support user configurable 
line
> > +	 * sizes. Override the requested value with the minimum in that case.
> > +	 */
> > +	min_bpl = pix->width * info->bpp;
> > +	max_bpl = rounddown(XVIP_DMA_MAX_WIDTH, dma->align);
> > +	bpl = rounddown(pix->bytesperline, dma->align);
> > +
> > +	pix->bytesperline = clamp(bpl, min_bpl, max_bpl);
> > +	pix->sizeimage = pix->bytesperline * pix->height;
> > +
> > +	if (fmtinfo)
> > +		*fmtinfo = info;
> > +}

[snip]

> > +int xvip_dma_init(struct xvip_composite_device *xdev, struct xvip_dma
> > *dma,
> > +		  enum v4l2_buf_type type, unsigned int port)
> > +{
> > +	char name[14];
> > +	int ret;
> > +
> > +	dma->xdev = xdev;
> > +	dma->port = port;
> > +	mutex_init(&dma->lock);
> > +	mutex_init(&dma->pipe.lock);
> > +	INIT_LIST_HEAD(&dma->queued_bufs);
> > +	spin_lock_init(&dma->queued_lock);
> > +
> > +	dma->fmtinfo = xvip_get_format_by_fourcc(XVIP_DMA_DEF_FORMAT);
> > +	dma->format.pixelformat = dma->fmtinfo->fourcc;
> > +	dma->format.colorspace = V4L2_COLORSPACE_SRGB;
> > +	dma->format.field = V4L2_FIELD_NONE;
> > +	dma->format.width = XVIP_DMA_DEF_WIDTH;
> > +	dma->format.height = XVIP_DMA_DEF_HEIGHT;
> > +	dma->format.bytesperline = dma->format.width * dma->fmtinfo->bpp;
> > +	dma->format.sizeimage = dma->format.bytesperline *
> > dma->format.height;
> > +
> > +	/* Initialize the media entity... */
> > +	dma->pad.flags = type == V4L2_BUF_TYPE_VIDEO_CAPTURE
> > +		       ? MEDIA_PAD_FL_SINK : MEDIA_PAD_FL_SOURCE;
> > +
> > +	ret = media_entity_init(&dma->video.entity, 1, &dma->pad, 0);
> > +	if (ret < 0)
> > +		goto error;
> > +
> > +	/* ... and the video node... */
> > +	dma->video.v4l2_dev = &xdev->v4l2_dev;
> > +	dma->video.fops = &xvip_dma_fops;
> > +	snprintf(dma->video.name, sizeof(dma->video.name), "%s %s %u",
> > +		 xdev->dev->of_node->name,
> > +		 type == V4L2_BUF_TYPE_VIDEO_CAPTURE ? "output" : "input",
> > +		 port);
> > +	dma->video.vfl_type = VFL_TYPE_GRABBER;
> > +	dma->video.vfl_dir = type == V4L2_BUF_TYPE_VIDEO_CAPTURE
> > +			   ? VFL_DIR_RX : VFL_DIR_TX;
> > +	dma->video.release = video_device_release_empty;
> > +	dma->video.ioctl_ops = &xvip_dma_ioctl_ops;
> 
> Set dma->video.queue to &dma->queue. That's all you need to be able to
> use the vb2 helper functions.
> 
> > +
> > +	video_set_drvdata(&dma->video, dma);
> > +
> > +	/* ... and the buffers queue... */
> > +	dma->alloc_ctx = vb2_dma_contig_init_ctx(dma->xdev->dev);
> > +	if (IS_ERR(dma->alloc_ctx))
> > +		goto error;
> > +
> > +	dma->queue.type = type;
> > +	dma->queue.io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
> 
> Add VB2_READ/WRITE. It's basically for free, so why not?

Because we want to discourage the users from using it ? :-)

> > +	dma->queue.drv_priv = dma;
> > +	dma->queue.buf_struct_size = sizeof(struct xvip_dma_buffer);
> > +	dma->queue.ops = &xvip_dma_queue_qops;
> > +	dma->queue.mem_ops = &vb2_dma_contig_memops;
> > +	dma->queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC
> > +				   | V4L2_BUF_FLAG_TSTAMP_SRC_EOF;
> > +	ret = vb2_queue_init(&dma->queue);
> > +	if (ret < 0) {
> > +		dev_err(dma->xdev->dev, "failed to initialize VB2 queue\n");
> > +		goto error;
> > +	}
> > +
> > +	/* ... and the DMA channel. */
> > +	sprintf(name, "port%u", port);
> > +	dma->dma = dma_request_slave_channel(dma->xdev->dev, name);
> > +	if (dma->dma == NULL) {
> > +		dev_err(dma->xdev->dev, "no VDMA channel found\n");
> > +		ret = -ENODEV;
> > +		goto error;
> > +	}
> > +
> > +	dma->align = 1 << dma->dma->device->copy_align;
> > +
> > +	ret = video_register_device(&dma->video, VFL_TYPE_GRABBER, -1);
> > +	if (ret < 0) {
> > +		dev_err(dma->xdev->dev, "failed to register video device\n");
> > +		goto error;
> > +	}
> > +
> > +	return 0;
> > +
> > +error:
> > +	xvip_dma_cleanup(dma);
> > +	return ret;
> > +}

-- 
Regards,

Laurent Pinchart

