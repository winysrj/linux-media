Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55947 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755732Ab3HAXq3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Aug 2013 19:46:29 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Katsuya MATSUBARA <matsu@igel.co.jp>
Subject: Re: [PATCH v4 5/7] v4l: Renesas R-Car VSP1 driver
Date: Fri, 02 Aug 2013 01:47:31 +0200
Message-ID: <2084375.Zc7aZU04om@avalon>
In-Reply-To: <51FAE1B3.3020603@gmail.com>
References: <1375285954-32153-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <2229675.vM0yYbEmYz@avalon> <51FAE1B3.3020603@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Friday 02 August 2013 00:31:15 Sylwester Nawrocki wrote:
> On 08/01/2013 12:03 AM, Laurent Pinchart wrote:
> > On Wednesday 31 July 2013 23:02:05 Sylwester Nawrocki wrote:
> >> On 07/31/2013 05:52 PM, Laurent Pinchart wrote:
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
> >>> Signed-off-by: Laurent
> >>> Pinchart<laurent.pinchart+renesas@ideasonboard.com>
> 
> [...]
> 
> >>> +static int vsp1_pipeline_stop(struct vsp1_pipeline *pipe)
> >>> +{
> >>> +	struct vsp1_entity *entity;
> >>> +	unsigned long flags;
> >>> +	int ret;
> >>> +
> >>> +	spin_lock_irqsave(&pipe->irqlock, flags);
> >>> +	pipe->state = VSP1_PIPELINE_STOPPING;
> >>> +	spin_unlock_irqrestore(&pipe->irqlock, flags);
> >>> +
> >>> +	ret = wait_event_timeout(pipe->wq, pipe->state ==
> >>> VSP1_PIPELINE_STOPPED,
> >>> +				 msecs_to_jiffies(500));
> >>> +	ret = ret == 0 ? -ETIMEDOUT : 0;
> >> 
> >> Wouldn't be -ETIME more appropriate ?
> >> 
> >> #define	ETIME		62	/* Timer expired */
> >> ...
> >> #define	ETIMEDOUT	110	/* Connection timed out */
> > 
> > $ find Documentation/ -type f -exec egrep -- ETIME[^DO] {} \; | wc
> >        7      45     347
> > $ find Documentation/ -type f -exec egrep -- ETIMED?OUT {} \; | wc
> >       22     135    1162
> > 
> > The only two places where ETIME is used in the Documentation are USB and
> > the RxRPC network protocol.
> > 
> > $ find drivers/ -type f -name \*.[ch] -exec grep -- -ETIME[^DO] {} \; | wc
> >      295    1037    7339
> > $ find drivers/ -type f -name \*.[ch] -exec grep -- -ETIMEDOUT {} \; | wc
> >     1156    3769   30590
> > 
> > According to man errno, ETIME seems to be related to XSI STREAMS. I'm fine
> > with both, but it seems the kernel is goind towards -ETIMEDOUT.
> 
> Indeed, ETIMEDOUT seems to be more widely used. It's a bit strange because
> "Connection timed out" looks like a network specific error message and ETIME
> ("Timer expired") appeared more suitable for cases as above.
> 
> I guess it better to stay with ETIMEDOUT then.

OK. It's easier as well, no change needed :-)

> >>> +	list_for_each_entry(entity,&pipe->entities, list_pipe) {
> >>> +		if (entity->route)
> >>> +			vsp1_write(entity->vsp1, entity->route,
> >>> +				   VI6_DPR_NODE_UNUSED);
> >>> +
> >>> +		v4l2_subdev_call(&entity->subdev, video, s_stream, 0);
> >>> +	}
> >>> +
> >>> +	return ret;
> >>> +}
> >> 
> >> [...]
> >> 
> >>> +/*
> >>> ----------------------------------------------------------------------
> >>> + * videobuf2 Queue Operations
> >>> + */
> >>> +
> >>> +static int
> >>> +vsp1_video_queue_setup(struct vb2_queue *vq, const struct v4l2_format
> >>> *fmt,
> >>> +		     unsigned int *nbuffers, unsigned int *nplanes,
> >>> +		     unsigned int sizes[], void *alloc_ctxs[])
> >>> +{
> >>> +	struct vsp1_video *video = vb2_get_drv_priv(vq);
> >>> +	struct v4l2_pix_format_mplane *format =&video->format;
> >>> +	unsigned int i;
> >> 
> >> If you don't support VIDIOC_CREATE_BUFS ioctl then there should probably
> >> 
> >> be at least something like:
> >> 	if (fmt)
> >> 	
> >> 		return -EINVAL;
> >> 
> >> But it's likely better to add proper handling of 'fmt' right away.
> > 
> > OK, I will do so. What is the driver supposed to do when *fmt isn't
> > supported ? Use the closest format as would be returned by try_format() ?
> 
> Normally user space should pass valid format, as returned from
> VIDIOC_TRY_FMT or VIDIOC_G_FMT (this is what V4L2 spec says, as you may
> already know).
> 
> The drivers I wrote just return -EINVAL if an unsupported fourcc is passed.
> I'm not sure if this is the behaviour we want in general. I'm inclined to
> keep VIDIOC_CREATE_BUFS simple and require user space to pass supported
> formats, otherwise the ioctl would fail. Applications anyway have to verify
> the format, e.g. with VIDIOC_TRY_FMT.

I agree with that, applications should pass a valid format to 
VIDIOC_CREATE_BUFS. I will thus return -EINVAL if any of the format fields is 
not valid (most likely by running the format through TRY_FMT and check if 
anything changes).

> In any case it would be nice to have the expected behaviour documented in
> the videobuf2-core.h header. And perhaps in the VIDIOC_CREATE_BUFS ioctl
> DocBook section.

That's a good idea. I'll submit patches.

> > I suppose this also implies that buffer_prepare() should check whether the
> > buffer matches the current format.
> 
> Right, buffers unsuitable for the current format should be rejected in
> buffer_prepare().

OK.

> >>> +	*nplanes = format->num_planes;
> >>> +
> >>> +	for (i = 0; i<   format->num_planes; ++i) {
> >>> +		sizes[i] = format->plane_fmt[i].sizeimage;
> >>> +		alloc_ctxs[i] = video->alloc_ctx;
> >>> +	}
> >>> +
> >>> +	return 0;
> >>> +}
> > 
> > [snip]
> > 
> >>> +static int __vsp1_video_try_format(struct vsp1_video *video,
> >>> +				   struct v4l2_pix_format_mplane *pix,
> >>> +				   const struct vsp1_format_info **fmtinfo)
> >>> +{
> >>> +	const struct vsp1_format_info *info;
> >>> +	unsigned int width = pix->width;
> >>> +	unsigned int height = pix->height;
> >>> +	unsigned int i;
> >>> +
> >>> +	/* Retrieve format information and select the default format if the
> >>> +	 * requested format isn't supported.
> >>> +	 */
> >> 
> >> Nitpicking: Isn't proper multi-line comment style
> >> 
> >> 	/*
> >> 	 * Retrieve format information and select the default format if the
> >> 	 * requested format isn't supported.
> >> 	 */
> >> 
> >> ?
> > 
> > Yes it is. I got used to the
> > 
> > /* foo
> >   * bar
> >   */
> > 
> > style as it's more compact.
> > 
> >> In fact the media subsystem code is pretty messy WRT that detail.
> > 
> > Documentation/CodingStyle mentions
> > 
> > The preferred style for long (multi-line) comments is:
> >          /*
> >           * This is the preferred style for multi-line
> >           * comments in the Linux kernel source code.
> >           * Please use it consistently.
> >           *
> >           * Description:  A column of asterisks on the left side,
> >           * with beginning and ending almost-blank lines.
> >           */
> > 
> > For files in net/ and drivers/net/ the preferred style for long
> > (multi-line) comments is a little different.
> > 
> >          /* The preferred comment style for files in net/ and drivers/net
> >           * looks like this.
> >           *
> >           * It is nearly the same as the generally preferred comment style
> >           * but there is no initial almost-blank line.
> >           */
> > 
> > I'd love to add drivers/media/ to that list ;-)
> 
> Yup, that's one of the options ;) I personally don't mind which variant
> is used, as long as it is only one of them and used consistently.
> 
> But unfortunately it looks like it's to late already and nobody is going
> to bother with patches that change comments to one style or the other.
> I guess I wanted mostly to bring some attention to the problem rather
> than raising objections to this particular patch.

I'll try to keep an eye on that. I'll probably keep using my comments style 
for drivers I write, but will adjust to the format in use when submitting 
patches for existing code.

-- 
Regards,

Laurent Pinchart

