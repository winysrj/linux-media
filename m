Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48436 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757007Ab3GaWCZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Jul 2013 18:02:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Katsuya MATSUBARA <matsu@igel.co.jp>
Subject: Re: [PATCH v4 5/7] v4l: Renesas R-Car VSP1 driver
Date: Thu, 01 Aug 2013 00:03:27 +0200
Message-ID: <2229675.vM0yYbEmYz@avalon>
In-Reply-To: <51F97B4D.70305@gmail.com>
References: <1375285954-32153-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1375285954-32153-6-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <51F97B4D.70305@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Thank you for the review.

On Wednesday 31 July 2013 23:02:05 Sylwester Nawrocki wrote:
> Hi Laurent,
> 
> just a few small remarks...
> 
> On 07/31/2013 05:52 PM, Laurent Pinchart wrote:
> > The VSP1 is a video processing engine that includes a blender, scalers,
> > filters and statistics computation. Configurable data path routing logic
> > allows ordering the internal blocks in a flexible way.
> > 
> > Due to the configurable nature of the pipeline the driver implements the
> > media controller API and doesn't use the V4L2 mem-to-mem framework, even
> > though the device usually operates in memory to memory mode.
> > 
> > Only the read pixel formatters, up/down scalers, write pixel formatters
> > and LCDC interface are supported at this stage.
> > 
> > Signed-off-by: Laurent Pinchart<laurent.pinchart+renesas@ideasonboard.com>
> > 
> > Changes since v1:
> > 
> > - Updated to the v3.11 media controller API changes
> > - Only add the LIF entity to the entities list when the LIF is present
> > - Added a MODULE_ALIAS()
> > - Fixed file descriptions in comment blocks
> > - Removed function prototypes for the unimplemented destroy functions
> > - Fixed a typo in the HST register name
> > - Fixed format propagation for the UDS entities
> > - Added v4l2_capability::device_caps support
> > - Prefix the device name with "platform:" in bus_info
> > - Zero the v4l2_pix_format priv field in the internal try format handler
> > - Use vb2_is_busy() instead of vb2_is_streaming() when setting the
> >    format
> > - Use the vb2_ioctl_* handlers where possible
> > - Fix register macros that were missing a n argument
> > - Mask unused bits when clearing the interrupt status register
> > - Explain why stride alignment to 128 bytes is needed
> > - Use the aligned stride value when computing the image size
> > - Assorted cosmetic changes
> > ---
> > 
> >   drivers/media/platform/Kconfig            |   10 +
> >   drivers/media/platform/Makefile           |    2 +
> >   drivers/media/platform/vsp1/Makefile      |    5 +
> >   drivers/media/platform/vsp1/vsp1.h        |   73 ++
> >   drivers/media/platform/vsp1/vsp1_drv.c    |  497 +++++++++++++
> >   drivers/media/platform/vsp1/vsp1_entity.c |  181 +++++
> >   drivers/media/platform/vsp1/vsp1_entity.h |   68 ++
> >   drivers/media/platform/vsp1/vsp1_lif.c    |  238 ++++++
> >   drivers/media/platform/vsp1/vsp1_lif.h    |   37 +
> >   drivers/media/platform/vsp1/vsp1_regs.h   |  581 +++++++++++++++
> >   drivers/media/platform/vsp1/vsp1_rpf.c    |  209 ++++++
> >   drivers/media/platform/vsp1/vsp1_rwpf.c   |  124 ++++
> >   drivers/media/platform/vsp1/vsp1_rwpf.h   |   53 ++
> >   drivers/media/platform/vsp1/vsp1_uds.c    |  346 +++++++++
> >   drivers/media/platform/vsp1/vsp1_uds.h    |   40 +
> >   drivers/media/platform/vsp1/vsp1_video.c  | 1135 +++++++++++++++++++++++
> >   drivers/media/platform/vsp1/vsp1_video.h  |  144 ++++
> >   drivers/media/platform/vsp1/vsp1_wpf.c    |  233 ++++++
> >   include/linux/platform_data/vsp1.h        |   25 +
> >   19 files changed, 4001 insertions(+)
> >   create mode 100644 drivers/media/platform/vsp1/Makefile
> >   create mode 100644 drivers/media/platform/vsp1/vsp1.h
> >   create mode 100644 drivers/media/platform/vsp1/vsp1_drv.c
> >   create mode 100644 drivers/media/platform/vsp1/vsp1_entity.c
> >   create mode 100644 drivers/media/platform/vsp1/vsp1_entity.h
> >   create mode 100644 drivers/media/platform/vsp1/vsp1_lif.c
> >   create mode 100644 drivers/media/platform/vsp1/vsp1_lif.h
> >   create mode 100644 drivers/media/platform/vsp1/vsp1_regs.h
> >   create mode 100644 drivers/media/platform/vsp1/vsp1_rpf.c
> >   create mode 100644 drivers/media/platform/vsp1/vsp1_rwpf.c
> >   create mode 100644 drivers/media/platform/vsp1/vsp1_rwpf.h
> >   create mode 100644 drivers/media/platform/vsp1/vsp1_uds.c
> >   create mode 100644 drivers/media/platform/vsp1/vsp1_uds.h
> >   create mode 100644 drivers/media/platform/vsp1/vsp1_video.c
> >   create mode 100644 drivers/media/platform/vsp1/vsp1_video.h
> >   create mode 100644 drivers/media/platform/vsp1/vsp1_wpf.c
> >   create mode 100644 include/linux/platform_data/vsp1.h

[snip]

> > +/* ----------------------------------------------------------------------
> > + * Initialization and Cleanup
> > + */
> > +
> > +struct vsp1_lif *vsp1_lif_create(struct vsp1_device *vsp1)
> > +{
> > +	struct v4l2_subdev *subdev;
> > +	struct vsp1_lif *lif;
> > +	int ret;
> > +
> > +	lif = devm_kzalloc(vsp1->dev, sizeof(*lif), GFP_KERNEL);
> > +	if (lif == NULL)
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	lif->entity.type = VSP1_ENTITY_LIF;
> > +	lif->entity.id = VI6_DPR_NODE_LIF;
> > +
> > +	ret = vsp1_entity_init(vsp1,&lif->entity, 2);
> > +	if (ret<  0)
> > +		return ERR_PTR(ret);
> > +
> > +	/* Initialize the V4L2 subdev. */
> > +	subdev =&lif->entity.subdev;
> > +	v4l2_subdev_init(subdev,&lif_ops);
> > +
> > +	subdev->entity.ops =&vsp1_media_ops;
> > +	subdev->internal_ops =&vsp1_subdev_internal_ops;
> > +	snprintf(subdev->name, sizeof(subdev->name), "%s lif",
> > +		 dev_name(vsp1->dev));
> 
> Using dev_name() looks reasonable since it guarantees the subdev names
> are unique. But for dt and non-dt boot you will get different device
> names. Not sure if it would have been really an issue though.
> 
> > +	v4l2_set_subdevdata(subdev, lif);
> > +	subdev->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> > +
> > +	vsp1_entity_init_formats(subdev, NULL);
> > +
> > +	return lif;
> > +}
> 
> [...]
> 
> > +static int vsp1_pipeline_stop(struct vsp1_pipeline *pipe)
> > +{
> > +	struct vsp1_entity *entity;
> > +	unsigned long flags;
> > +	int ret;
> > +
> > +	spin_lock_irqsave(&pipe->irqlock, flags);
> > +	pipe->state = VSP1_PIPELINE_STOPPING;
> > +	spin_unlock_irqrestore(&pipe->irqlock, flags);
> > +
> > +	ret = wait_event_timeout(pipe->wq, pipe->state == 
> > VSP1_PIPELINE_STOPPED,
> > +				 msecs_to_jiffies(500));
> > +	ret = ret == 0 ? -ETIMEDOUT : 0;
> 
> Wouldn't be -ETIME more appropriate ?
> 
> #define	ETIME		62	/* Timer expired */
> ...
> #define	ETIMEDOUT	110	/* Connection timed out */

$ find Documentation/ -type f -exec egrep -- ETIME[^DO] {} \; | wc
      7      45     347
$ find Documentation/ -type f -exec egrep -- ETIMED?OUT {} \; | wc
     22     135    1162

The only two places where ETIME is used in the Documentation are USB and the 
RxRPC network protocol.

$ find drivers/ -type f -name \*.[ch] -exec grep -- -ETIME[^DO] {} \; | wc
    295    1037    7339
$ find drivers/ -type f -name \*.[ch] -exec grep -- -ETIMEDOUT {} \; | wc
   1156    3769   30590

According to man errno, ETIME seems to be related to XSI STREAMS. I'm fine 
with both, but it seems the kernel is goind towards -ETIMEDOUT.

> > +	list_for_each_entry(entity,&pipe->entities, list_pipe) {
> > +		if (entity->route)
> > +			vsp1_write(entity->vsp1, entity->route,
> > +				   VI6_DPR_NODE_UNUSED);
> > +
> > +		v4l2_subdev_call(&entity->subdev, video, s_stream, 0);
> > +	}
> > +
> > +	return ret;
> > +}
> 
> [...]
> 
> > +/* ----------------------------------------------------------------------
> > + * videobuf2 Queue Operations
> > + */
> > +
> > +static int
> > +vsp1_video_queue_setup(struct vb2_queue *vq, const struct v4l2_format
> > *fmt,
> > +		     unsigned int *nbuffers, unsigned int *nplanes,
> > +		     unsigned int sizes[], void *alloc_ctxs[])
> > +{
> > +	struct vsp1_video *video = vb2_get_drv_priv(vq);
> > +	struct v4l2_pix_format_mplane *format =&video->format;
> > +	unsigned int i;
> 
> If you don't support VIDIOC_CREATE_BUFS ioctl then there should probably
> be at least something like:
> 
> 	if (fmt)
> 		return -EINVAL;
> 
> But it's likely better to add proper handling of 'fmt' right away.

OK, I will do so. What is the driver supposed to do when *fmt isn't supported 
? Use the closest format as would be returned by try_format() ?

I suppose this also implies that buffer_prepare() should check whether the 
buffer matches the current format.

> > +	*nplanes = format->num_planes;
> > +
> > +	for (i = 0; i<  format->num_planes; ++i) {
> > +		sizes[i] = format->plane_fmt[i].sizeimage;
> > +		alloc_ctxs[i] = video->alloc_ctx;
> > +	}
> > +
> > +	return 0;
> > +}

[snip]

> > +static int __vsp1_video_try_format(struct vsp1_video *video,
> > +				   struct v4l2_pix_format_mplane *pix,
> > +				   const struct vsp1_format_info **fmtinfo)
> > +{
> > +	const struct vsp1_format_info *info;
> > +	unsigned int width = pix->width;
> > +	unsigned int height = pix->height;
> > +	unsigned int i;
> > +
> > +	/* Retrieve format information and select the default format if the
> > +	 * requested format isn't supported.
> > +	 */
> 
> Nitpicking: Isn't proper multi-line comment style
> 
> 	/*
> 	 * Retrieve format information and select the default format if the
> 	 * requested format isn't supported.
> 	 */
> 
> ?

Yes it is. I got used to the

/* foo
 * bar
 */

style as it's more compact.

> In fact the media subsystem code is pretty messy WRT that detail.

Documentation/CodingStyle mentions

The preferred style for long (multi-line) comments is:

        /*
         * This is the preferred style for multi-line
         * comments in the Linux kernel source code.
         * Please use it consistently.
         *
         * Description:  A column of asterisks on the left side,
         * with beginning and ending almost-blank lines.
         */

For files in net/ and drivers/net/ the preferred style for long (multi-line)
comments is a little different.

        /* The preferred comment style for files in net/ and drivers/net
         * looks like this.
         *
         * It is nearly the same as the generally preferred comment style,
         * but there is no initial almost-blank line.
         */

I'd love to add drivers/media/ to that list ;-)

> > +	info = vsp1_get_format_info(pix->pixelformat);
> > +	if (info == NULL)
> > +		info = vsp1_get_format_info(VSP1_VIDEO_DEF_FORMAT);
> > +
> > +	pix->pixelformat = info->fourcc;
> > +	pix->colorspace = V4L2_COLORSPACE_SRGB;
> > +	pix->field = V4L2_FIELD_NONE;
> > +	memset(pix->reserved, 0, sizeof(pix->reserved));
> > +
> > +	/* Align the width and height for YUV 4:2:2 and 4:2:0 formats. */
> > +	width = round_down(width, info->hsub);
> > +	height = round_down(height, info->vsub);
> > +
> > +	/* Clamp the width and height. */
> > +	pix->width = clamp(width, VSP1_VIDEO_MIN_WIDTH, 
> > VSP1_VIDEO_MAX_WIDTH);
> > +	pix->height = clamp(height, VSP1_VIDEO_MIN_HEIGHT,
> > +			    VSP1_VIDEO_MAX_HEIGHT);
> > +
> > +	/* Compute and clamp the stride and image size. While not documented 
> > +	 * in the datasheet, strides not aligned to a multiple of 128 bytes 
> > +	 * result in image corruption.
> > +	 */
> > +	for (i = 0; i<  max(info->planes, 2U); ++i) {
> > +		unsigned int hsub = i>  0 ? info->hsub : 1;
> > +		unsigned int vsub = i>  0 ? info->vsub : 1;
> > +		unsigned int align = 128;
> > +		unsigned int bpl;
> > +
> > +		bpl = clamp_t(unsigned int, pix->plane_fmt[i].bytesperline,
> > +			      pix->width / hsub * info->bpp[i] / 8,
> > +			      round_down(65535U, align));
> > +
> > +		pix->plane_fmt[i].bytesperline = round_up(bpl, align);
> > +		pix->plane_fmt[i].sizeimage = pix->plane_fmt[i].bytesperline
> > +					    * pix->height / vsub;
> > +	}
> > +
> > +	if (info->planes == 3) {
> > +		/* The second and third planes must have the same stride. */
> > +		pix->plane_fmt[2].bytesperline = pix->plane_fmt[1].bytesperline;
> > +		pix->plane_fmt[2].sizeimage = pix->plane_fmt[1].sizeimage;
> > +	}
> > +
> > +	pix->num_planes = info->planes;
> > +
> > +	if (fmtinfo)
> > +		*fmtinfo = info;
> > +
> > +	return 0;
> > +}

-- 
Regards,

Laurent Pinchart
