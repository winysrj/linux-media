Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:34474 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485Ab2JBH4t (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2012 03:56:49 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] media: add a VEU MEM2MEM format conversion and scaling driver
Date: Tue, 2 Oct 2012 09:56:37 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <Pine.LNX.4.64.1209111459340.22084@axis700.grange> <201209111544.29596.hverkuil@xs4all.nl> <Pine.LNX.4.64.1210011940380.3573@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1210011940380.3573@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210020956.37709.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon 1 October 2012 19:51:18 Guennadi Liakhovetski wrote:
> Hi Hans
> 
> Thanks for the review. As you might have seen, I just posted v2 of this 
> driver. In it I addressed almost all your comments. As for the rest:
> 
> On Tue, 11 Sep 2012, Hans Verkuil wrote:
> 
> > On Tue 11 September 2012 15:01:19 Guennadi Liakhovetski wrote:
> 
> [snip]
> 
> > > +struct sh_veu_dev;
> > > +
> > > +struct sh_veu_file {
> > 
> > struct v4l2_fh is missing here: needed to implement control events.
> 
> I removed ctrls completely instead. Don't think mine were useful for 
> anything.
> 
> [snip]
> 
> > > +static int sh_veu_try_fmt(struct v4l2_format *f, const struct sh_veu_format *fmt)
> > > +{
> > > +	struct v4l2_pix_format *pix = &f->fmt.pix;
> > > +	unsigned int y_bytes_used;
> > > +
> > > +	/*
> > > +	 * V4L2 specification suggests, that the driver should correct the
> > > +	 * format struct if any of the dimensions is unsupported
> > > +	 */
> > > +	switch (pix->field) {
> > > +	case V4L2_FIELD_ANY:
> > > +		pix->field = V4L2_FIELD_NONE;
> > 
> > Add a 'break' here.
> 
> That's a matter of taste, I think:-) The logic here is, that after setting 
> the field to NONE the "rest" should be identical with the case, where NONE 
> is already set by the user, so, just fall through.

Can you add a /* fall through */ comment in that case? That clarifies that it
is intentional.

> 
> [snip]
> 
> > > +static void sh_veu_colour_offset(struct sh_veu_dev *veu, struct sh_veu_vfmt *vfmt)
> > > +{
> > > +	/* dst_left and dst_top validity will be verified in CROP / COMPOSE */
> > > +	unsigned int left = vfmt->frame.left & ~0x03;
> > > +	unsigned int top = vfmt->frame.top;
> > > +	dma_addr_t offset = ((left * veu->vfmt_out.fmt->depth) >> 3) +
> > > +		top * veu->vfmt_out.bytesperline;
> > > +	unsigned int y_line;
> > > +
> > > +	vfmt->offset_y = offset;
> > > +
> > > +	switch (vfmt->fmt->fourcc) {
> > > +	case V4L2_PIX_FMT_NV12:
> > > +	case V4L2_PIX_FMT_NV16:
> > > +	case V4L2_PIX_FMT_NV24:
> > > +		y_line = ALIGN(vfmt->frame.width, 16);
> > > +		vfmt->offset_c = offset + y_line * vfmt->frame.height;
> > > +		break;
> > > +	case V4L2_PIX_FMT_RGB332:
> > > +	case V4L2_PIX_FMT_RGB444:
> > > +	case V4L2_PIX_FMT_RGB565:
> > > +	case V4L2_PIX_FMT_BGR666:
> > > +	case V4L2_PIX_FMT_RGB24:
> > > +		vfmt->offset_c = 0;
> > > +		break;
> > > +	default:
> > > +		BUG();
> > 
> > Wouldn't WARN_ON be more polite?
> 
> This "default" can be entered only if someone modifies the driver and does 
> this wrongly, so, I just make sure, that the author realises their mistake 
> before shipping to the user;-)
> 
> [snip]
> 
> > > +static int sh_veu_s_input(struct file *file, void *fh, unsigned int i)
> > > +{
> > > +	return i ? -EINVAL : 0;
> > > +}
> > > +
> > > +static int sh_veu_g_input(struct file *file, void *fh, unsigned int *i)
> > > +{
> > > +	*i = 0;
> > > +	return 0;
> > > +}
> > > +
> > > +static int sh_veu_enum_input(struct file *file, void *fh,
> > > +			     struct v4l2_input *inp)
> > > +{
> > > +	return inp->index ? -EINVAL : 0;
> > > +}
> > 
> > Why implement the input ioctls at all? I'm not sure whether they are
> > relevant here. If you do, then enum_input really has to fill in the
> > other fields of struct v4l2_input as well. But I would just remove
> > support for these ioctls.
> 
> Right, I don't need them, but in the beginning I tried using gstreamer for 
> testing, and, I think, it required them... In the end I anyway gave up on 
> it and used my own test program, so, yeah, can remove them...
> 
> [snip]
> 
> > Please run v4l2-compliance (the latest version from v4l-utils.git) over this
> > driver. Most if not all of the issues I've highlighted above would have been
> > found by v4l2-compliance.
> 
> As I also mentioned in v2, I think, the spec should be extended to also 
> allow other errors from REQBUFS.

EBUSY should be documented. Perhaps you can make a patch for that? :-)

BTW, in the second version of your patch you return -EPERM if the filehandle
was set up for streaming. But that isn't right. It is REQBUFS (or CREATE_BUFS
or read/write) that sets up a filehandle for streaming. Only after calling one
of those functions is everything locked into place. Until that time it is
perfectly valid to change formats.

If an app want to get exclusive access and prevent anyone else from messing
with formats, then it should use the priority ioctls.

Regards,

	Hans
