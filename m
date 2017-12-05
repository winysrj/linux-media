Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48152 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752151AbdLENew (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Dec 2017 08:34:52 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 3/3 v7] uvcvideo: add a metadata device node
Date: Tue, 05 Dec 2017 15:35:06 +0200
Message-ID: <29678788.jfO5ktnOBC@avalon>
In-Reply-To: <alpine.DEB.2.20.1712050918330.22421@axis700.grange>
References: <1510156814-28645-1-git-send-email-g.liakhovetski@gmx.de> <2006709.83fRcNtr9s@avalon> <alpine.DEB.2.20.1712050918330.22421@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Tuesday, 5 December 2017 12:56:53 EET Guennadi Liakhovetski wrote:
> On Tue, 5 Dec 2017, Laurent Pinchart wrote:
> > On Wednesday, 8 November 2017 18:00:14 EET Guennadi Liakhovetski wrote:
> >> Some UVC video cameras contain metadata in their payload headers. This
> >> patch extracts that data, adding more clock synchronisation information,
> >> on both bulk and isochronous endpoints and makes it available to the
> >> user space on a separate video node, using the V4L2_CAP_META_CAPTURE
> >> capability and the V4L2_BUF_TYPE_META_CAPTURE buffer queue type. Even
> >> though different cameras will have different metadata formats, we use
> >> the same V4L2_META_FMT_UVC pixel format for all of them. Users have to
> >> parse data, based on the specific camera model information. This
> >> version of the patch only creates such metadata nodes for cameras,
> >> specifying a UVC_QUIRK_METADATA_NODE quirk flag.
> > 
> > I don't think this is correct anymore, as we'll use different 4CCs for
> > different vendor metadata. How would you like to rephrase the commit
> > message ?
> 
> Something like
> 
> "
> Some UVC video cameras contain metadata in their payload headers. This
> patch extracts that data, adding more clock synchronisation information,
> on both bulk and isochronous endpoints and makes it available to the user
> space on a separate video node, using the V4L2_CAP_META_CAPTURE capability
> and the V4L2_BUF_TYPE_META_CAPTURE buffer queue type. By default, only the
> V4L2_META_FMT_UVC pixel format is available from those nodes. However,
> cameras can be added to the device ID table to additionally specify their
> own metadata format, in which case that format will also become available
> from the metadata node.
> "

Sounds good to me.

> >> Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
> >> ---
> >> 
> >> v7: support up to two metadata formats per camera - the standard one and
> >> an optional private one, if specified in device information
> >> 
> >>  drivers/media/usb/uvc/Makefile       |   2 +-
> >>  drivers/media/usb/uvc/uvc_driver.c   |  15 +++
> >>  drivers/media/usb/uvc/uvc_isight.c   |   2 +-
> >>  drivers/media/usb/uvc/uvc_metadata.c | 204 +++++++++++++++++++++++++++++
> >>  drivers/media/usb/uvc/uvc_queue.c    |  41 +++++--
> >>  drivers/media/usb/uvc/uvc_video.c    | 127 ++++++++++++++++++++--
> >>  drivers/media/usb/uvc/uvcvideo.h     |  19 +++-
> >>  drivers/media/v4l2-core/v4l2-ioctl.c |   1 +
> >>  include/uapi/linux/uvcvideo.h        |  26 +++++
> >>  9 files changed, 416 insertions(+), 21 deletions(-)
> >>  create mode 100644 drivers/media/usb/uvc/uvc_metadata.c
[snip]

> >> diff --git a/drivers/media/usb/uvc/uvc_metadata.c
> >> b/drivers/media/usb/uvc/uvc_metadata.c new file mode 100644
> >> index 0000000..21eeee9
> >> --- /dev/null
> >> +++ b/drivers/media/usb/uvc/uvc_metadata.c

[snip]

> >> +static int uvc_meta_v4l2_querycap(struct file *file, void *fh,
> >> +				  struct v4l2_capability *cap)
> >> +{
> >> +	struct v4l2_fh *vfh = file->private_data;
> >> +	struct uvc_streaming *stream = video_get_drvdata(vfh->vdev);
> >> +
> >> +	strlcpy(cap->driver, "uvcvideo", sizeof(cap->driver));
> >> +	strlcpy(cap->card, vfh->vdev->name, sizeof(cap->card));
> >> +	usb_make_path(stream->dev->udev, cap->bus_info,
> >> sizeof(cap->bus_info));
> >> +
> >> +	return 0;
> >> +}
> > 
> > Do you think we could reuse uvc_ioctl_querycap() as-is ?
> 
> AFAICS it still has
> 
> 	cap->capabilities = V4L2_CAP_DEVICE_CAPS | V4L2_CAP_STREAMING
> 			  | chain->caps;
> 
> in it, which doesn't suit the metadata node?

I'd say this is debatable, isn't the capabilities field supposed to include 
all capabilities from all video nodes for the device ? chain->caps would need 
to include metadata capability in that case.

Code reuse is not a big deal as the function is small, but getting the 
capabilities value right is important regardless.

> >> +
> >> +static int uvc_meta_v4l2_get_format(struct file *file, void *fh,
> >> +				    struct v4l2_format *format)
> >> +{
> >> +	struct v4l2_fh *vfh = file->private_data;
> >> +	struct uvc_streaming *stream = video_get_drvdata(vfh->vdev);
> >> +	struct v4l2_meta_format *fmt = &format->fmt.meta;
> >> +
> >> +	if (format->type != vfh->vdev->queue->type)
> >> +		return -EINVAL;
> >> +
> >> +	memset(fmt, 0, sizeof(*fmt));
> >> +
> >> +	fmt->dataformat = stream->cur_meta_format;
> >> +	fmt->buffersize = UVC_METATADA_BUF_SIZE;
> > 
> > You need to take the stream->mutex lock here to protect against races with
> > the set format ioctl.
> 
> Well, strictly speaking you don't? The buffersize is constant and getting
> the current metadata format is an atomic read.

I was concerned by the race condition due to lack of memory barriers, but if 
userspace issues concurrent G_FMT and S_FMT calls the order isn't guaranteed 
anyway, so you're right about that.

[snip]

> > > diff --git a/drivers/media/usb/uvc/uvc_queue.c
> > > b/drivers/media/usb/uvc/uvc_queue.c index c8d78b2..b2998f5 100644
> > > --- a/drivers/media/usb/uvc/uvc_queue.c
> > > +++ b/drivers/media/usb/uvc/uvc_queue.c
> 
> [snip]
> 
> >> +	if (!meta_buf || length == 2 ||
> >> +	    meta_buf->length - meta_buf->bytesused <
> >> +	    length + sizeof(meta->ns) + sizeof(meta->sof))
> >> +		return;
> > 
> > If the metadata buffer overflows should we also set the error bit like we
> > do for video buffers ? I have mixed feelings about this, I'd appreciate
> > your input.
> 
> I think it would be good to know if we ever run into such overruns.
> Setting an error flag is more likely to be noticed and reported than a
> printk()?

I believe so, yes.

> >> +	has_pts = mem[1] & UVC_STREAM_PTS;
> >> +	has_scr = mem[1] & UVC_STREAM_SCR;
> >> +
> >> +	if (has_pts) {
> >> +		len_std += 4;
> >> +		scr = mem + 6;
> >> +	} else {
> >> +		scr = mem + 2;
> >> +	}
> >> +
> >> +	if (has_scr)
> >> +		len_std += 6;
> >> +
> >> +	if (stream->cur_meta_format == V4L2_META_FMT_UVC)
> >> +		length = len_std;
> >> +
> >> +	if (length == len_std && (!has_scr ||
> >> +				  !memcmp(scr, stream->clock.last_scr, 6)))
> >> +		return;
> >> +
> >> +	meta = (struct uvc_meta_buf *)((u8 *)meta_buf->mem +
> >> meta_buf->bytesused);
> >> +	local_irq_save(flags);
> >> +	uvc_video_get_ts(&ts);
> > 
> > FYI, Arnd has posted https://patchwork.kernel.org/patch/10076887/. If the
> > patch gets merged first I can help with the rebasing.
> > 
> >> +	meta->sof = usb_get_current_frame_number(stream->dev->udev);
> >> +	local_irq_restore(flags);
> >> +	meta->ns = timespec_to_ns(&ts);
> > 
> > The meta pointer can be unaligned as the structure is packed and its size
> > isn't a multiple of the size of the largest field (and it can contain an
> > unspecified amount of vendor data anyway). You thus can't access it
> > directly on all architectures, you will need to use the put_unaligned
> > macro. As I haven't checked whether all architectures can handle
> > unaligned accesses without generating a trap, I would store the USB frame
> > number in a local variable and use the put_unaligned macro output of the
> > IRQ disabled section (feel free to show me that I'm unnecessarily
> > cautious :-)).
> 
> I think you're right. But __put_unaligned_cpu64() is an inline function,
> not a macro, so, no local variable is needed?

Even if it's a function I'm not 100% confident that it can work well with 
interrupts disabled on all architectures, but I'm probably overcautious.

> >> +	if (has_scr)
> >> +		memcpy(stream->clock.last_scr, scr, 6);
> >> +
> >> +	memcpy(&meta->length, mem, length);
> >> +	meta_buf->bytesused += length + sizeof(meta->ns) + sizeof(meta->sof);
> >> +
> >> +	uvc_trace(UVC_TRACE_FRAME,
> >> +		  "%s(): t-sys %lu.%09lus, SOF %u, len %u, flags 0x%x, PTS %u, STC
> >> %u frame SOF %u\n",
> >> +		  __func__, ts.tv_sec, ts.tv_nsec, meta->sof,
> >> +		  meta->length, meta->flags, has_pts ? *(u32 *)meta->buf : 0,
> >> +		  has_scr ? *(u32 *)scr : 0,
> >> +		  has_scr ? *(u32 *)(scr + 4) & 0x7ff : 0);
> >> +}

[snip]

> > For your convenience I've rebased your patch series on top of the two
> > patches I mentioned and added another patch on top that contains fixes
> > for all the small issues mentioned above. The result is available at
> > 
> > 	git://linuxtv.org/pinchartl/media.git uvc/metadata
> > 
> > There are just a handful of issues or questions I haven't addressed, if we
> > handle them I think we'll be good to go.
> 
> Thanks for rebasing. I've addressed the remaining issues, and once I get
> your answers to remaining questions above, I'll send an updated version.

Done :-)

Thank you.

-- 
Regards,

Laurent Pinchart
