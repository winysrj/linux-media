Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:45713 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750991AbaKCKMY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Nov 2014 05:12:24 -0500
Message-ID: <545754FF.9020208@xs4all.nl>
Date: Mon, 03 Nov 2014 11:12:15 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
CC: Michal Simek <michal.simek@xilinx.com>,
	Chris Kohn <christian.kohn@xilinx.com>,
	Hyun Kwon <hyun.kwon@xilinx.com>, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 11/13] v4l: xilinx: Add Xilinx Video IP core
References: <1414940018-3016-1-git-send-email-laurent.pinchart@ideasonboard.com> <1414940018-3016-12-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1414940018-3016-12-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Some small nitpicks...

On 11/02/2014 03:53 PM, Laurent Pinchart wrote:
> Xilinx platforms have no hardwired video capture or video processing
> interface. Users create capture and memory to memory processing
> pipelines in the FPGA fabric to suit their particular needs, by
> instantiating video IP cores from a large library.
> 
> The Xilinx Video IP core is a framework that models a video pipeline
> described in the device tree and expose the pipeline to userspace
> through the media controller and V4L2 APIs.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Hyun Kwon <hyun.kwon@xilinx.com>
> Signed-off-by: Radhey Shyam Pandey <radheys@xilinx.com>
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> 
> ---
> 
> Cc: devicetree@vger.kernel.org
> 
> Changes since v1:
> 
> - Remove unnecessary fields from struct xvip_dma_buffer
> - Fix querycap capabilities and bus_info reporting
> - Refuse to set format when the queue is busy
> - Return buffers to vb2 when start_streaming fails
> - Use vb2 fops and ioctl ops
> 
> v1 was made of the following individual patches.
> 
> media: xilinx: vip: Add yuv444 and bayer formats
> media: xilinx: vip: Remove _TIMING_ from register definition
> media: xilinx: dma: Add vidioc_enum_fmt_vid_cap callback
> media: xilinx: dma: Fix alignments of xvip_dma_fops definition
> media: xilinx: dma: Workaround for bytesperline
> media: xilinx: vip: Add default min/max height/width definitions
> media: xilinx: vip: Add common sink/source pad IDs
> media: xilinx: vip: Add xvip_set_format_size()
> media: xilinx: vip: Add xvip_enum_mbus_code()
> media: xilinx: vip: Add xvip_enum_frame_size()
> media: xilinx: vip: Add register clear and set functions
> media: xilinx: vip: Add xvip_start()
> media: xilinx: vip: Add xvip_stop()
> media: xilinx: vip: Add xvip_set_frame_size()
> media: xilinx: vip: Add enable/disable reg update functions
> media: xilinx: vip: Add xvip_print_version()
> media: xilinx: vip: Add xvip_reset()
> media: xilinx: vip: Add xvip_get_frame_size()
> media: xilinx: vip: Add suspend/resume helper functions
> media: xilinx: vip: Change the return value of xvip_get_format_by_code()
> media: xilinx: vip: Change the return value of xvip_of_get_format()
> media: xilinx: vip: Change the return value of xvip_get_format_by_fourcc()
> media: xilinx: vipp: Remove of_match_ptr()
> media: xilinx: vipp: Add control to inherit subdevice controls
> media: xilinx: Make disconnected video nodes return -EPIPE at stream on
> media: xilinx: Make links configurable
> media: xilinx: Rename xvip_pipeline_entity to xvip_graph_entity
> media: xilinx: Rename xvip_pipeline to xvip_composite_device
> media: xilinx: Rename xvipp_pipeline_* functions to xvip_graph_*
> media: xilinx: Rename xvipp_v4l2_* functions to xvip_composite_v4l2_*
> media: xilinx: Rename xvipp_* functions to xvip_composite_*
> media: xilinx: Move pipeline management code to xilinx-dma.c
> media: xilinx: Add missing mutex_destroy call
> media: xilinx: Create xvip_pipeline structure
> media: xilinx: Support more than two VDMAs in DT
> media: xilinx: dma: Change vdma configuration to cyclic-mode
> Revert "media: xilinx: dma: Workaround for bytesperline"
> media: xilinx: Added DMA error handling
> media: xilinx: Fix error handling
> media: xilinx: Reordered mutexes initialization
> media: xilinx: vipp: Add devicetree bindings documentation
> media: xilinx: Reordered mutexes initialization
> media: xilinx: Set format description in enum_fmt
> media: xilinx: Remove global control handler
> media: xilinx: dma: Use the interleaved dmaengine API
> xilinx: Remove .owner field for drivers
> v4l: xilinx: video: Rename compatible string to xlnx,video
> v4l: xilinx: Remove axi- prefix from DT properties
> v4l: xilinx: dma: Give back queued buffers at streamoff time
> ---
>  .../devicetree/bindings/media/xilinx/video.txt     |  52 ++
>  .../bindings/media/xilinx/xlnx,video.txt           |  55 ++
>  MAINTAINERS                                        |   9 +
>  drivers/media/platform/Kconfig                     |   1 +
>  drivers/media/platform/Makefile                    |   2 +
>  drivers/media/platform/xilinx/Kconfig              |  10 +
>  drivers/media/platform/xilinx/Makefile             |   3 +
>  drivers/media/platform/xilinx/xilinx-dma.c         | 770 +++++++++++++++++++++
>  drivers/media/platform/xilinx/xilinx-dma.h         | 109 +++
>  drivers/media/platform/xilinx/xilinx-vip.c         | 269 +++++++
>  drivers/media/platform/xilinx/xilinx-vip.h         | 227 ++++++
>  drivers/media/platform/xilinx/xilinx-vipp.c        | 669 ++++++++++++++++++
>  drivers/media/platform/xilinx/xilinx-vipp.h        |  49 ++
>  13 files changed, 2225 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/xilinx/video.txt
>  create mode 100644 Documentation/devicetree/bindings/media/xilinx/xlnx,video.txt
>  create mode 100644 drivers/media/platform/xilinx/Kconfig
>  create mode 100644 drivers/media/platform/xilinx/Makefile
>  create mode 100644 drivers/media/platform/xilinx/xilinx-dma.c
>  create mode 100644 drivers/media/platform/xilinx/xilinx-dma.h
>  create mode 100644 drivers/media/platform/xilinx/xilinx-vip.c
>  create mode 100644 drivers/media/platform/xilinx/xilinx-vip.h
>  create mode 100644 drivers/media/platform/xilinx/xilinx-vipp.c
>  create mode 100644 drivers/media/platform/xilinx/xilinx-vipp.h
> 

<snip>

> diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/platform/xilinx/xilinx-dma.c
> new file mode 100644
> index 0000000..a438e4a
> --- /dev/null
> +++ b/drivers/media/platform/xilinx/xilinx-dma.c

<snip>

> +/* -----------------------------------------------------------------------------
> + * V4L2 ioctls
> + */
> +
> +static int
> +xvip_dma_querycap(struct file *file, void *fh, struct v4l2_capability *cap)
> +{
> +	struct v4l2_fh *vfh = file->private_data;
> +	struct xvip_dma *dma = to_xvip_dma(vfh->vdev);
> +
> +	cap->capabilities = V4L2_CAP_DEVICE_CAPS | V4L2_CAP_STREAMING
> +			  | dma->xdev->v4l2_caps;
> +
> +	if (dma->queue.type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
> +	else
> +		cap->device_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
> +
> +	strlcpy(cap->driver, "xilinx-vipp", sizeof(cap->driver));
> +	strlcpy(cap->card, dma->video.name, sizeof(cap->card));
> +	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s:%u",
> +		 dma->xdev->dev->of_node->name, dma->port);
> +	cap->bus_info[sizeof(cap->bus_info) - 1] = '\0';

I'm fairly certain that snprintf (at least the kernel version) will always
0-terminate the string.

> +
> +	return 0;
> +}
> +
> +/* FIXME: without this callback function, some applications are not configured
> + * with correct formats, and it results in frames in wrong format. Whether this
> + * callback needs to be required is not clearly defined, so it should be
> + * clarified through the mailing list.
> + */
> +static int
> +xvip_dma_enum_format(struct file *file, void *fh, struct v4l2_fmtdesc *f)
> +{
> +	struct v4l2_fh *vfh = file->private_data;
> +	struct xvip_dma *dma = to_xvip_dma(vfh->vdev);
> +
> +	if (f->index > 0)
> +		return -EINVAL;
> +
> +	f->pixelformat = dma->format.pixelformat;
> +	strlcpy(f->description, dma->fmtinfo->description,
> +		sizeof(f->description));
> +
> +	return 0;
> +}
> +
> +static int
> +xvip_dma_get_format(struct file *file, void *fh, struct v4l2_format *format)
> +{
> +	struct v4l2_fh *vfh = file->private_data;
> +	struct xvip_dma *dma = to_xvip_dma(vfh->vdev);
> +
> +	format->fmt.pix = dma->format;
> +
> +	return 0;
> +}
> +
> +static void
> +__xvip_dma_try_format(struct xvip_dma *dma, struct v4l2_pix_format *pix,
> +		      const struct xvip_video_format **fmtinfo)
> +{
> +	const struct xvip_video_format *info;
> +	unsigned int min_width;
> +	unsigned int max_width;
> +	unsigned int min_bpl;
> +	unsigned int max_bpl;
> +	unsigned int width;
> +	unsigned int align;
> +	unsigned int bpl;
> +
> +	/* Retrieve format information and select the default format if the
> +	 * requested format isn't supported.
> +	 */
> +	info = xvip_get_format_by_fourcc(pix->pixelformat);
> +	if (IS_ERR(info))
> +		info = xvip_get_format_by_fourcc(XVIP_DMA_DEF_FORMAT);
> +
> +	pix->pixelformat = info->fourcc;
> +	pix->colorspace = V4L2_COLORSPACE_SRGB;

See my reply to your reply :-)

> +	pix->field = V4L2_FIELD_NONE;

Interlaced formats are not supported at the moment?

> +
> +	/* The transfer alignment requirements are expressed in bytes. Compute
> +	 * the minimum and maximum values, clamp the requested width and convert
> +	 * it back to pixels.
> +	 */
> +	align = lcm(dma->align, info->bpp);
> +	min_width = roundup(XVIP_DMA_MIN_WIDTH, align);
> +	max_width = rounddown(XVIP_DMA_MAX_WIDTH, align);
> +	width = rounddown(pix->width * info->bpp, align);
> +
> +	pix->width = clamp(width, min_width, max_width) / info->bpp;
> +	pix->height = clamp(pix->height, XVIP_DMA_MIN_HEIGHT,
> +			    XVIP_DMA_MAX_HEIGHT);
> +
> +	/* Clamp the requested bytes per line value. If the maximum bytes per
> +	 * line value is zero, the module doesn't support user configurable line
> +	 * sizes. Override the requested value with the minimum in that case.
> +	 */
> +	min_bpl = pix->width * info->bpp;
> +	max_bpl = rounddown(XVIP_DMA_MAX_WIDTH, dma->align);
> +	bpl = rounddown(pix->bytesperline, dma->align);
> +
> +	pix->bytesperline = clamp(bpl, min_bpl, max_bpl);
> +	pix->sizeimage = pix->bytesperline * pix->height;
> +
> +	if (fmtinfo)
> +		*fmtinfo = info;
> +}

<snip>

Regards,

	Hans

