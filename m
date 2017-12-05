Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47551 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752766AbdLEJoN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Dec 2017 04:44:13 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 3/3 v7] uvcvideo: add a metadata device node
Date: Tue, 05 Dec 2017 11:44:28 +0200
Message-ID: <1983995.0cdEoutXEe@avalon>
In-Reply-To: <alpine.DEB.2.20.1712050904340.22421@axis700.grange>
References: <1510156814-28645-1-git-send-email-g.liakhovetski@gmx.de> <1780731.RZdITBElWU@avalon> <alpine.DEB.2.20.1712050904340.22421@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Tuesday, 5 December 2017 10:06:02 EET Guennadi Liakhovetski wrote:
> On Tue, 5 Dec 2017, Laurent Pinchart wrote:
> > On Tuesday, 5 December 2017 02:24:30 EET Laurent Pinchart wrote:
> >> On Wednesday, 8 November 2017 18:00:14 EET Guennadi Liakhovetski wrote:
> > [snip]
> > 
> >>> +static void uvc_video_decode_meta(struct uvc_streaming *stream,
> >>> +			struct uvc_buffer *buf, struct uvc_buffer *meta_buf,
> >>> +			u8 *mem, unsigned int length)
> >> 
> >> The buf parameter is unused, you can remove it. mem isn't modified, I
> >> would make it const.
> >> 
> >>> +{
> >>> +	struct uvc_meta_buf *meta;
> >>> +	size_t len_std = 2;
> >>> +	bool has_pts, has_scr;
> >>> +	unsigned long flags;
> >>> +	struct timespec ts;
> >>> +	u8 *scr;
> >> 
> >> And scr should be const too.
> >> 
> >>> +
> >>> +	if (!meta_buf || length == 2 ||
> >>> +	    meta_buf->length - meta_buf->bytesused <
> >>> +	    length + sizeof(meta->ns) + sizeof(meta->sof))
> >>> +		return;
> >> 
> >> If the metadata buffer overflows should we also set the error bit like
> >> we do for video buffers ? I have mixed feelings about this, I'd
> >> appreciate your input.
> >> 
> >>> +	has_pts = mem[1] & UVC_STREAM_PTS;
> >>> +	has_scr = mem[1] & UVC_STREAM_SCR;
> >>> +
> >>> +	if (has_pts) {
> >>> +		len_std += 4;
> >>> +		scr = mem + 6;
> >>> +	} else {
> >>> +		scr = mem + 2;
> >>> +	}
> >>> +
> >>> +	if (has_scr)
> >>> +		len_std += 6;
> >>> +
> >>> +	if (stream->cur_meta_format == V4L2_META_FMT_UVC)
> >>> +		length = len_std;
> >>> +
> >>> +	if (length == len_std && (!has_scr ||
> >>> +				  !memcmp(scr, stream->clock.last_scr, 6)))
> >>> +		return;
> >>> +
> >>> +	meta = (struct uvc_meta_buf *)((u8 *)meta_buf->mem +
> >>> meta_buf->bytesused);
> >>> +	local_irq_save(flags);
> >>> +	uvc_video_get_ts(&ts);
> >> 
> >> FYI, Arnd has posted https://patchwork.kernel.org/patch/10076887/. If
> >> the patch gets merged first I can help with the rebasing.
> > 
> > I've reviewed and merged Arnd patches in my tree, and...
> > 
> >>> +	meta->sof = usb_get_current_frame_number(stream->dev->udev);
> >>> +	local_irq_restore(flags);
> >>> +	meta->ns = timespec_to_ns(&ts);
> >> 
> >> The meta pointer can be unaligned as the structure is packed and its
> >> size
> >> isn't a multiple of the size of the largest field (and it can contain an
> >> unspecified amount of vendor data anyway). You thus can't access it
> >> directly on all architectures, you will need to use the put_unaligned
> >> macro. As I haven't checked whether all architectures can handle
> >> unaligned accesses without generating a trap, I would store the USB
> >> frame number in a local variable and use the put_unaligned macro output
> >> of the IRQ disabled section (feel free to show me that I'm
> >> unnecessarily cautious :-)).
> >> 
> >>> +	if (has_scr)
> >>> +		memcpy(stream->clock.last_scr, scr, 6);
> >>> +
> >>> +	memcpy(&meta->length, mem, length);
> >>> +	meta_buf->bytesused += length + sizeof(meta->ns) +
> >>> sizeof(meta->sof);
> >>> +
> >>> +	uvc_trace(UVC_TRACE_FRAME,
> >>> +		  "%s(): t-sys %lu.%09lus, SOF %u, len %u, flags 0x%x, PTS %u,
> >>> STC %u frame SOF %u\n",
> >>> +		  __func__, ts.tv_sec, ts.tv_nsec, meta->sof,
> >>> +		  meta->length, meta->flags, has_pts ? *(u32 *)meta->buf : 0,
> >>> +		  has_scr ? *(u32 *)scr : 0,
> >>> +		  has_scr ? *(u32 *)(scr + 4) & 0x7ff : 0);
> >>> +}
> > 
> > [snip]
> > 
> >> For your convenience I've rebased your patch series on top of the two
> >> patches I mentioned and added another patch on top that contains fixes
> >> for all the small issues mentioned above. The result is available at
> 
> In your rebased version you've also dropped the hunk for
> drivers/media/v4l2-core/v4l2-ioctl.c adding a description for the new
> V4L2_META_FMT_UVC format - is that on purpose?

Unless I'm mistaken I've moved it to patch 1/3.

> >> 	git://linuxtv.org/pinchartl/media.git uvc/metadata
> >> 
> >> There are just a handful of issues or questions I haven't addressed, if
> >> we handle them I think we'll be good to go.
> > 
> > ... updated the above branch with a rebased version of the series.

-- 
Regards,

Laurent Pinchart
