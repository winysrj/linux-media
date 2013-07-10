Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41286 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022Ab3GJOYX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jul 2013 10:24:23 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH 5/5] v4l: Renesas R-Car VSP1 driver
Date: Wed, 10 Jul 2013 16:24:58 +0200
Message-ID: <37123229.iGJOoGNLf7@avalon>
In-Reply-To: <201307101434.25019.hverkuil@xs4all.nl>
References: <1373451572-3892-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1373451572-3892-6-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <201307101434.25019.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the very quick review.

On Wednesday 10 July 2013 14:34:24 Hans Verkuil wrote:
> On Wed 10 July 2013 12:19:32 Laurent Pinchart wrote:
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
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> > ---
> > 
> >  drivers/media/platform/Kconfig            |   10 +
> >  drivers/media/platform/Makefile           |    2 +
> >  drivers/media/platform/vsp1/Makefile      |    5 +
> >  drivers/media/platform/vsp1/vsp1.h        |   73 ++
> >  drivers/media/platform/vsp1/vsp1_drv.c    |  475 ++++++++++++
> >  drivers/media/platform/vsp1/vsp1_entity.c |  186 +++++
> >  drivers/media/platform/vsp1/vsp1_entity.h |   68 ++
> >  drivers/media/platform/vsp1/vsp1_lif.c    |  237 ++++++
> >  drivers/media/platform/vsp1/vsp1_lif.h    |   38 +
> >  drivers/media/platform/vsp1/vsp1_regs.h   |  581 +++++++++++++++
> >  drivers/media/platform/vsp1/vsp1_rpf.c    |  209 ++++++
> >  drivers/media/platform/vsp1/vsp1_rwpf.c   |  124 ++++
> >  drivers/media/platform/vsp1/vsp1_rwpf.h   |   56 ++
> >  drivers/media/platform/vsp1/vsp1_uds.c    |  346 +++++++++
> >  drivers/media/platform/vsp1/vsp1_uds.h    |   41 +
> >  drivers/media/platform/vsp1/vsp1_video.c  | 1154 ++++++++++++++++++++++++
> >  drivers/media/platform/vsp1/vsp1_video.h  |  144 ++++
> >  drivers/media/platform/vsp1/vsp1_wpf.c    |  233 ++++++
> >  include/linux/platform_data/vsp1.h        |   25 +
> >  19 files changed, 4007 insertions(+)
> >  create mode 100644 drivers/media/platform/vsp1/Makefile
> >  create mode 100644 drivers/media/platform/vsp1/vsp1.h
> >  create mode 100644 drivers/media/platform/vsp1/vsp1_drv.c
> >  create mode 100644 drivers/media/platform/vsp1/vsp1_entity.c
> >  create mode 100644 drivers/media/platform/vsp1/vsp1_entity.h
> >  create mode 100644 drivers/media/platform/vsp1/vsp1_lif.c
> >  create mode 100644 drivers/media/platform/vsp1/vsp1_lif.h
> >  create mode 100644 drivers/media/platform/vsp1/vsp1_regs.h
> >  create mode 100644 drivers/media/platform/vsp1/vsp1_rpf.c
> >  create mode 100644 drivers/media/platform/vsp1/vsp1_rwpf.c
> >  create mode 100644 drivers/media/platform/vsp1/vsp1_rwpf.h
> >  create mode 100644 drivers/media/platform/vsp1/vsp1_uds.c
> >  create mode 100644 drivers/media/platform/vsp1/vsp1_uds.h
> >  create mode 100644 drivers/media/platform/vsp1/vsp1_video.c
> >  create mode 100644 drivers/media/platform/vsp1/vsp1_video.h
> >  create mode 100644 drivers/media/platform/vsp1/vsp1_wpf.c
> >  create mode 100644 include/linux/platform_data/vsp1.h
> 
> Hi Laurent,
> 
> It took some effort, but I finally did find some things to complain about
> :-)

:-)

> > diff --git a/drivers/media/platform/vsp1/vsp1_video.c
> > b/drivers/media/platform/vsp1/vsp1_video.c new file mode 100644
> > index 0000000..47a739a
> > --- /dev/null
> > +++ b/drivers/media/platform/vsp1/vsp1_video.c

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
> > +	info = vsp1_get_format_info(pix->pixelformat);
> > +	if (info == NULL)
> > +		info = vsp1_get_format_info(VSP1_VIDEO_DEF_FORMAT);
> > +
> > +	pix->pixelformat = info->fourcc;
> > +	pix->colorspace = V4L2_COLORSPACE_SRGB;
> > +	pix->field = V4L2_FIELD_NONE;
> 
> pix->priv should be set to 0. v4l2-compliance catches such errors, BTW.

Isn't this handled by the CLEAR_AFTER_FIELD() macros in v4l2-ioctl2.c ?

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
> > +	/* Compute and clamp the stride and image size. */
> > +	for (i = 0; i < max(info->planes, 2U); ++i) {
> > +		unsigned int hsub = i > 0 ? info->hsub : 1;
> > +		unsigned int vsub = i > 0 ? info->vsub : 1;
> > +		unsigned int bpl;
> > +
> > +		bpl = clamp_t(unsigned int, pix->plane_fmt[i].bytesperline,
> > +			      pix->width / hsub * info->bpp[i] / 8,
> > +			      round_down(65535U, 128));
> > +
> > +		pix->plane_fmt[i].bytesperline = round_up(bpl, 128);
> > +		pix->plane_fmt[i].sizeimage = bpl * pix->height / vsub;
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

[snip]

> > +static int
> > +vsp1_video_reqbufs(struct file *file, void *fh, struct
> > v4l2_requestbuffers *rb)
> > +{
> > +	struct v4l2_fh *vfh = file->private_data;
> > +	struct vsp1_video *video = to_vsp1_video(vfh->vdev);
> > +	int ret;
> > +
> > +	mutex_lock(&video->lock);
> > +
> > +	if (video->queue.owner && video->queue.owner != vfh) {
> > +		ret = -EBUSY;
> > +		goto done;
> > +	}
> > +
> > +	ret = vb2_reqbufs(&video->queue, rb);
> > +	if (ret < 0)
> > +		goto done;
> > +
> > +	video->queue.owner = vfh;
> > +
> > +done:
> > +	mutex_unlock(&video->lock);
> > +	return ret ? ret : rb->count;
> 
> On success reqbufs should return 0, not the number of allocated buffers.

Oops, my bad.

> Have you considered using the vb2 helper functions in videobuf2-core.c? They
> take care of the queue ownership and often simplify drivers considerably.

I have, and mistakenly believed that they relied on using the video device 
lock. I'll use them.

> > +}

[snip]

> > +static int
> > +vsp1_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
> > +{
> > +	struct v4l2_fh *vfh = file->private_data;
> > +	struct vsp1_video *video = to_vsp1_video(vfh->vdev);
> > +	struct vsp1_pipeline *pipe;
> > +	int ret;
> > +
> > +	mutex_lock(&video->lock);
> > +
> > +	if (video->queue.owner && video->queue.owner != vfh) {
> > +		ret = -EBUSY;
> > +		goto err_unlock;
> > +	}
> > +
> > +	video->sequence = 0;
> > +
> > +	/* Start streaming on the pipeline. No link touching an entity in the
> > +	 * pipeline can be activated or deactivated once streaming is
> > started.
> > +	 *
> > +	 * Use the VSP1 pipeline object embedded in the first video object
> > +	 * that starts streaming.
> > +	 */
> > +	pipe = video->video.entity.pipe
> > +	     ? to_vsp1_pipeline(&video->video.entity) : &video->pipe;
> > +
> > +	ret = media_entity_pipeline_start(&video->video.entity, &pipe->pipe);
> > +	if (ret < 0)
> > +		goto err_unlock;
> > +
> > +	/* Verify that the configured format matches the output of the
> > +	 * connected subdev.
> > +	 */
> > +	ret = vsp1_video_verify_format(video);
> > +	if (ret < 0)
> > +		goto err_stop;
> > +
> > +	ret = vsp1_pipeline_init(pipe, video);
> > +	if (ret < 0)
> > +		goto err_stop;
> 
> Shouldn't the code above be better placed in the vb2 start_streaming op?

The code needs to be run before buffers are enqueued to the driver, that's why 
I've placed it here.

> > +
> > +	/* Start the queue. */
> > +	ret = vb2_streamon(&video->queue, type);
> > +	if (ret < 0)
> > +		goto err_cleanup;
> > +
> > +	mutex_unlock(&video->lock);
> > +	return 0;
> > +
> > +err_cleanup:
> > +	vsp1_pipeline_cleanup(pipe);
> > +err_stop:
> > +	media_entity_pipeline_stop(&video->video.entity);
> > +err_unlock:
> > +	mutex_unlock(&video->lock);
> > +	return ret;
> > +
> > +}
> > +
> > +static int
> > +vsp1_video_streamoff(struct file *file, void *fh, enum v4l2_buf_type
> > type)
> > +{
> > +	struct v4l2_fh *vfh = file->private_data;
> > +	struct vsp1_video *video = to_vsp1_video(vfh->vdev);
> > +	int ret;
> > +
> > +	mutex_lock(&video->lock);
> > +
> > +	if (video->queue.owner && video->queue.owner != vfh) {
> > +		ret = -EBUSY;
> > +		goto done;
> > +	}
> > +
> > +	ret = vb2_streamoff(&video->queue, type);
> > +
> > +done:
> > +	mutex_unlock(&video->lock);
> > +	return ret;
> > +}

-- 
Regards,

Laurent Pinchart

