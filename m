Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:37364 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbbCJHDX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2015 03:03:23 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Michal Simek <michal.simek@xilinx.com>,
	Chris Kohn <christian.kohn@xilinx.com>,
	Hyun Kwon <hyun.kwon@xilinx.com>, devicetree@vger.kernel.org
Subject: Re: [PATCH v6 6/8] v4l: xilinx: Add Xilinx Video IP core
Date: Mon, 09 Mar 2015 22:09:40 +0200
Message-ID: <5751729.E5vYkMZhhg@avalon>
In-Reply-To: <54F720AF.6010501@xs4all.nl>
References: <1425480709-7545-1-git-send-email-laurent.pinchart@ideasonboard.com> <1425480709-7545-7-git-send-email-laurent.pinchart@ideasonboard.com> <54F720AF.6010501@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the review.

On Wednesday 04 March 2015 16:11:43 Hans Verkuil wrote:
> Hi Laurent,
> 
> Almost OK :-)

Great :-)

> Two small issues remain, see below.
> 
> On 03/04/15 15:51, Laurent Pinchart wrote:
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
> > 
> > ---
> > 
> > Cc: devicetree@vger.kernel.org
> > 
> > Changes since v5:
> > 
> > - Report frame field as V4L2_FIELD_NONE
> > - Update to the mainline pad-level subdev API changes
> > - Add VIDIOC_CREATE_BUFS support
> > - Add a comment to explain the lack of VB2_READ and VB2_WRITE
> > 
> > Changes since v4:
> > 
> > - Use a DT format description closer to the hardware
> > - Document the xvip_device clk field
> > 
> > Changes since v3:
> > 
> > - Rename V4L2_MBUS_FMT_* to MEDIA_BUS_FMT_*
> > - Cleanup unused vdma configuration.
> > - Add resource init and cleanup helpers
> > - Return buffers to vb2 when media pipeline start fails
> > 
> > Changes since v2:
> > 
> > - Remove explicit trailing \0 after snprintf
> > - Don't hardcode colorspace
> > 
> > Changes since v1:
> > 
> > - Remove unnecessary fields from struct xvip_dma_buffer
> > - Fix querycap capabilities and bus_info reporting
> > - Refuse to set format when the queue is busy
> > - Return buffers to vb2 when start_streaming fails
> > - Use vb2 fops and ioctl ops
> > 
> > v1 was made of the following individual patches.
> > 
> > media: xilinx: vip: Add yuv444 and bayer formats
> > media: xilinx: vip: Remove _TIMING_ from register definition
> > media: xilinx: dma: Add vidioc_enum_fmt_vid_cap callback
> > media: xilinx: dma: Fix alignments of xvip_dma_fops definition
> > media: xilinx: dma: Workaround for bytesperline
> > media: xilinx: vip: Add default min/max height/width definitions
> > media: xilinx: vip: Add common sink/source pad IDs
> > media: xilinx: vip: Add xvip_set_format_size()
> > media: xilinx: vip: Add xvip_enum_mbus_code()
> > media: xilinx: vip: Add xvip_enum_frame_size()
> > media: xilinx: vip: Add register clear and set functions
> > media: xilinx: vip: Add xvip_start()
> > media: xilinx: vip: Add xvip_stop()
> > media: xilinx: vip: Add xvip_set_frame_size()
> > media: xilinx: vip: Add enable/disable reg update functions
> > media: xilinx: vip: Add xvip_print_version()
> > media: xilinx: vip: Add xvip_reset()
> > media: xilinx: vip: Add xvip_get_frame_size()
> > media: xilinx: vip: Add suspend/resume helper functions
> > media: xilinx: vip: Change the return value of xvip_get_format_by_code()
> > media: xilinx: vip: Change the return value of xvip_of_get_format()
> > media: xilinx: vip: Change the return value of xvip_get_format_by_fourcc()
> > media: xilinx: vipp: Remove of_match_ptr()
> > media: xilinx: vipp: Add control to inherit subdevice controls
> > media: xilinx: Make disconnected video nodes return -EPIPE at stream on
> > media: xilinx: Make links configurable
> > media: xilinx: Rename xvip_pipeline_entity to xvip_graph_entity
> > media: xilinx: Rename xvip_pipeline to xvip_composite_device
> > media: xilinx: Rename xvipp_pipeline_* functions to xvip_graph_*
> > media: xilinx: Rename xvipp_v4l2_* functions to xvip_composite_v4l2_*
> > media: xilinx: Rename xvipp_* functions to xvip_composite_*
> > media: xilinx: Move pipeline management code to xilinx-dma.c
> > media: xilinx: Add missing mutex_destroy call
> > media: xilinx: Create xvip_pipeline structure
> > media: xilinx: Support more than two VDMAs in DT
> > media: xilinx: dma: Change vdma configuration to cyclic-mode
> > Revert "media: xilinx: dma: Workaround for bytesperline"
> > media: xilinx: Added DMA error handling
> > media: xilinx: Fix error handling
> > media: xilinx: Reordered mutexes initialization
> > media: xilinx: vipp: Add devicetree bindings documentation
> > media: xilinx: Reordered mutexes initialization
> > media: xilinx: Set format description in enum_fmt
> > media: xilinx: Remove global control handler
> > media: xilinx: dma: Use the interleaved dmaengine API
> > xilinx: Remove .owner field for drivers
> > v4l: xilinx: video: Rename compatible string to xlnx,video
> > v4l: xilinx: Remove axi- prefix from DT properties
> > v4l: xilinx: dma: Give back queued buffers at streamoff time
> > ---
> > 
> >  .../devicetree/bindings/media/xilinx/video.txt     |  35 +
> >  .../bindings/media/xilinx/xlnx,video.txt           |  55 ++
> >  MAINTAINERS                                        |   9 +
> >  drivers/media/platform/Kconfig                     |   1 +
> >  drivers/media/platform/Makefile                    |   2 +
> >  drivers/media/platform/xilinx/Kconfig              |  10 +
> >  drivers/media/platform/xilinx/Makefile             |   3 +
> >  drivers/media/platform/xilinx/xilinx-dma.c         | 766 ++++++++++++++++
> >  drivers/media/platform/xilinx/xilinx-dma.h         | 109 +++
> >  drivers/media/platform/xilinx/xilinx-vip.c         | 311 +++++++++
> >  drivers/media/platform/xilinx/xilinx-vip.h         | 238 +++++++
> >  drivers/media/platform/xilinx/xilinx-vipp.c        | 669 ++++++++++++++++
> >  drivers/media/platform/xilinx/xilinx-vipp.h        |  49 ++
> >  include/dt-bindings/media/xilinx-vip.h             |  39 ++
> >  14 files changed, 2296 insertions(+)
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
> >  create mode 100644 include/dt-bindings/media/xilinx-vip.h
> 
> <snip>
> 
> > diff --git a/drivers/media/platform/xilinx/xilinx-dma.c
> > b/drivers/media/platform/xilinx/xilinx-dma.c new file mode 100644
> > index 0000000..10209c2
> > --- /dev/null
> > +++ b/drivers/media/platform/xilinx/xilinx-dma.c
> 
> <snip>
> 
> > +/* ----------------------------------------------------------------------
> > + * Subdev operations handlers
> > + */
> > +
> > +/**
> > + * xvip_enum_mbus_code - Enumerate the media format code
> > + * @subdev: V4L2 subdevice
> > + * @cfg: V4L2 subdev pad configuration
> > + * @code: returning media bus code
> > + *
> > + * Enumerate the media bus code of the subdevice. Return the
> > corresponding
> > + * pad format code. This function only works for subdevices with fixed
> > format
> > + * on all pads. Subdevices with multiple format should have their own
> > + * function to enumerate mbus codes.
> > + *
> > + * Return: 0 if the media bus code is found, or -EINVAL if the format
> > index
> > + * is not valid.
> > + */
> > +int xvip_enum_mbus_code(struct v4l2_subdev *subdev,
> > +			struct v4l2_subdev_pad_config *cfg,
> > +			struct v4l2_subdev_mbus_code_enum *code)
> > +{
> > +	struct v4l2_mbus_framefmt *format;
> > +
> > +	if (code->index)
> > +		return -EINVAL;
> > +
> 
> You need to handle the case where code->which == ACTIVE (in which case
> cfg can be NULL).

Indeed. And I don't have access to the necessary information in this function 
to do so.

Would it be fine for you if I return an error when code->which == ACTIVE for 
now ? I'm working on refactoring that pushes more entity-specific code to 
helper functions, but I'd like not to delay the merge of this patch set until 
that work is complete.

The rationale is that there was no which field until recently, so enumerating 
formats based on the active configuration isn't needed by userspace at the 
moment, and kernelspace doesn't use it either.

> > +	format = v4l2_subdev_get_try_format(subdev, cfg, code->pad);
> > +
> > +	code->code = format->code;
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(xvip_enum_mbus_code);
> > +
> > +/**
> > + * xvip_enum_frame_size - Enumerate the media bus frame size
> > + * @subdev: V4L2 subdevice
> > + * @cfg: V4L2 subdev pad configuration
> > + * @fse: returning media bus frame size
> > + *
> > + * This function is a drop-in implementation of the subdev
> > enum_frame_size pad
> > + * operation. It assumes that the subdevice has one sink pad and one
> > source
> > + * pad, and that the format on the source pad is always identical to the
> > + * format on the sink pad. Entities with different requirements need to
> > + * implement their own enum_frame_size handlers.
> > + *
> > + * Return: 0 if the media bus frame size is found, or -EINVAL
> > + * if the index or the code is not valid.
> > + */
> > +int xvip_enum_frame_size(struct v4l2_subdev *subdev,
> > +			 struct v4l2_subdev_pad_config *cfg,
> > +			 struct v4l2_subdev_frame_size_enum *fse)
> > +{
> > +	struct v4l2_mbus_framefmt *format;
> > +
> 
> Ditto.
> 
> > +	format = v4l2_subdev_get_try_format(subdev, cfg, fse->pad);
> > +
> > +	if (fse->index || fse->code != format->code)
> > +		return -EINVAL;
> > +
> > +	if (fse->pad == XVIP_PAD_SINK) {
> > +		fse->min_width = XVIP_MIN_WIDTH;
> > +		fse->max_width = XVIP_MAX_WIDTH;
> > +		fse->min_height = XVIP_MIN_HEIGHT;
> > +		fse->max_height = XVIP_MAX_HEIGHT;
> > +	} else {
> > +		/* The size on the source pad is fixed and always identical to
> > +		 * the size on the sink pad.
> > +		 */
> > +		fse->min_width = format->width;
> > +		fse->max_width = format->width;
> > +		fse->min_height = format->height;
> > +		fse->max_height = format->height;
> > +	}
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(xvip_enum_frame_size);

-- 
Regards,

Laurent Pinchart

