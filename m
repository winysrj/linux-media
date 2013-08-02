Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59272 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab3HBLPb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Aug 2013 07:15:31 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Katsuya MATSUBARA <matsu@igel.co.jp>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH v5 7/9] v4l: Renesas R-Car VSP1 driver
Date: Fri, 02 Aug 2013 13:16:35 +0200
Message-ID: <85967578.E7nGVEdzp4@avalon>
In-Reply-To: <51FB9481.2090202@xs4all.nl>
References: <1375405408-17134-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <2025148.Pz9nW8WD9Z@avalon> <51FB9481.2090202@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 02 August 2013 13:14:09 Hans Verkuil wrote:
> On 08/02/2013 12:57 PM, Laurent Pinchart wrote:
> > On Friday 02 August 2013 11:23:46 Hans Verkuil wrote:
> >> On 08/02/2013 03:03 AM, Laurent Pinchart wrote:
> >>> The VSP1 is a video processing engine that includes a blender, scalers,
> >>> filters and statistics computation. Configurable data path routing logic
> >>> allows ordering the internal blocks in a flexible way.
> >>> 
> >>> Due to the configurable nature of the pipeline the driver implements the
> >>> media controller API and doesn't use the V4L2 mem-to-mem framework, even
> >>> though the device usually operates in memory to memory mode.
> >>> 
> >>> Only the read pixel formatters, up/down scalers, write pixel formatters
> >>> and LCDC interface are supported at this stage.
> >>> 
> >>> Signed-off-by: Laurent Pinchart
> >>> <laurent.pinchart+renesas@ideasonboard.com>
> >>> Acked-by: Sakari Ailus <sakari.ailus@iki.fi>
> >>> 
> >>> diff --git a/drivers/media/platform/vsp1/vsp1_uds.h
> >>> b/drivers/media/platform/vsp1/vsp1_uds.h new file mode 100644
> >>> index 0000000..972a285
> > 
> > [snip]
> > 
> >>> +int vsp1_video_init(struct vsp1_video *video, struct vsp1_entity *rwpf)
> >>> +{
> >>> +	const char *direction;
> >>> +	int ret;
> >>> +
> >>> +	switch (video->type) {
> >>> +	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> >>> +		direction = "output";
> >>> +		video->pad.flags = MEDIA_PAD_FL_SINK;
> >>> +		break;
> >>> +
> >>> +	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> >>> +		direction = "input";
> >>> +		video->pad.flags = MEDIA_PAD_FL_SOURCE;
> >>> +		video->video.vfl_dir = VFL_DIR_TX;
> >>> +		break;
> >>> +
> >>> +	default:
> >>> +		return -EINVAL;
> >>> +	}
> >>> +
> >>> +	video->rwpf = rwpf;
> >>> +
> >>> +	mutex_init(&video->lock);
> >>> +	spin_lock_init(&video->irqlock);
> >>> +	INIT_LIST_HEAD(&video->irqqueue);
> >>> +
> >>> +	mutex_init(&video->pipe.lock);
> >>> +	spin_lock_init(&video->pipe.irqlock);
> >>> +	INIT_LIST_HEAD(&video->pipe.entities);
> >>> +	init_waitqueue_head(&video->pipe.wq);
> >>> +	video->pipe.state = VSP1_PIPELINE_STOPPED;
> >>> +
> >>> +	/* Initialize the media entity... */
> >>> +	ret = media_entity_init(&video->video.entity, 1, &video->pad, 0);
> >>> +	if (ret < 0)
> >>> +		return ret;
> >>> +
> >>> +	/* ... and the format ... */
> >>> +	video->fmtinfo = vsp1_get_format_info(VSP1_VIDEO_DEF_FORMAT);
> >>> +	video->format.pixelformat = video->fmtinfo->fourcc;
> >>> +	video->format.colorspace = V4L2_COLORSPACE_SRGB;
> >>> +	video->format.field = V4L2_FIELD_NONE;
> >>> +	video->format.width = VSP1_VIDEO_DEF_WIDTH;
> >>> +	video->format.height = VSP1_VIDEO_DEF_HEIGHT;
> >>> +	video->format.num_planes = 1;
> >>> +	video->format.plane_fmt[0].bytesperline =
> >>> +		video->format.width * video->fmtinfo->bpp[0] / 8;
> >>> +	video->format.plane_fmt[0].sizeimage =
> >>> +		video->format.plane_fmt[0].bytesperline * video->format.height;
> >>> +
> >>> +	/* ... and the video node... */
> >>> +	video->video.v4l2_dev = &video->vsp1->v4l2_dev;
> >>> +	video->video.fops = &vsp1_video_fops;
> >>> +	snprintf(video->video.name, sizeof(video->video.name), "%s %s",
> >>> +		 rwpf->subdev.name, direction);
> >>> +	video->video.vfl_type = VFL_TYPE_GRABBER;
> >>> +	video->video.release = video_device_release_empty;
> >>> +	video->video.ioctl_ops = &vsp1_video_ioctl_ops;
> >>> +
> >>> +	video_set_drvdata(&video->video, video);
> >>> +
> >>> +	/* ... and the buffers queue... */
> >>> +	video->alloc_ctx = vb2_dma_contig_init_ctx(video->vsp1->dev);
> >>> +	if (IS_ERR(video->alloc_ctx))
> >>> +		goto error;
> >>> +
> >>> +	video->queue.type = video->type;
> >>> +	video->queue.io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
> >>> +	video->queue.drv_priv = video;
> >>> +	video->queue.buf_struct_size = sizeof(struct vsp1_video_buffer);
> >>> +	video->queue.ops = &vsp1_video_queue_qops;
> >>> +	video->queue.mem_ops = &vb2_dma_contig_memops;
> >>> +	video->queue.timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> >> 
> >> If you set video->queue.lock to &video->lock, then you can drop all the
> >> vb2 ioctl and fop helper functions directly without having to make your
> >> own wrapper functions.
> > 
> > Right, I'll do so. I will also drop the manual lock handling from the
> > STREAMON and STREAMOFF handlers, as the core will use the queue lock for
> > those.
> >
> >> It saves a fair bit of code that way. The only place where there is a
> >> difference as far as I can see is in vb2_fop_mmap: there the queue.lock
> >> isn't taken whereas you do take the lock. It has never been 100% clear to
> >> me whether or not that lock should be taken. However, as far as I can
> >> tell vb2_mmap never calls any driver callbacks, so it seems to be me that
> >> there is no need to take the lock.
> > 
> > Couldn't mmap() race with for instance REQBUFS(0) if we don't lock it ?
> 
> Hmm, good point. It would require a very convoluted program, but yes, there
> is a possible race condition. The same is true for vb2_get_unmapped_area.
> 
> Can you prepare a patch adding locking for these two fops?

Sure, will do.


-- 
Regards,

Laurent Pinchart

