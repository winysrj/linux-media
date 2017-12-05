Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:51134 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753153AbdLEK47 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Dec 2017 05:56:59 -0500
Date: Tue, 5 Dec 2017 11:56:53 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 3/3 v7] uvcvideo: add a metadata device node
In-Reply-To: <2006709.83fRcNtr9s@avalon>
Message-ID: <alpine.DEB.2.20.1712050918330.22421@axis700.grange>
References: <1510156814-28645-1-git-send-email-g.liakhovetski@gmx.de> <1510156814-28645-4-git-send-email-g.liakhovetski@gmx.de> <2006709.83fRcNtr9s@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for a review.

On Tue, 5 Dec 2017, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> Thank you for the patch. We're getting very close, I only have small comments, 
> please see below.
> 
> On Wednesday, 8 November 2017 18:00:14 EET Guennadi Liakhovetski wrote:
> > Some UVC video cameras contain metadata in their payload headers. This
> > patch extracts that data, adding more clock synchronisation information,
> > on both bulk and isochronous endpoints and makes it available to the
> > user space on a separate video node, using the V4L2_CAP_META_CAPTURE
> > capability and the V4L2_BUF_TYPE_META_CAPTURE buffer queue type. Even
> > though different cameras will have different metadata formats, we use
> > the same V4L2_META_FMT_UVC pixel format for all of them. Users have to
> > parse data, based on the specific camera model information. This
> > version of the patch only creates such metadata nodes for cameras,
> > specifying a UVC_QUIRK_METADATA_NODE quirk flag.
> 
> I don't think this is correct anymore, as we'll use different 4CCs for 
> different vendor metadata. How would you like to rephrase the commit message ?

Something like

"
Some UVC video cameras contain metadata in their payload headers. This 
patch extracts that data, adding more clock synchronisation information, 
on both bulk and isochronous endpoints and makes it available to the user 
space on a separate video node, using the V4L2_CAP_META_CAPTURE capability 
and the V4L2_BUF_TYPE_META_CAPTURE buffer queue type. By default, only the 
V4L2_META_FMT_UVC pixel format is available from those nodes. However, 
cameras can be added to the device ID table to additionally specify their 
own metadata format, in which case that format will also become available 
from the metadata node.
"

> > Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
> > ---
> > 
> > v7: support up to two metadata formats per camera - the standard one and
> > an optional private one, if specified in device information
> > 
> >  drivers/media/usb/uvc/Makefile       |   2 +-
> >  drivers/media/usb/uvc/uvc_driver.c   |  15 +++
> >  drivers/media/usb/uvc/uvc_isight.c   |   2 +-
> >  drivers/media/usb/uvc/uvc_metadata.c | 204 ++++++++++++++++++++++++++++++++
> >  drivers/media/usb/uvc/uvc_queue.c    |  41 +++++--
> >  drivers/media/usb/uvc/uvc_video.c    | 127 ++++++++++++++++++++--
> >  drivers/media/usb/uvc/uvcvideo.h     |  19 +++-
> >  drivers/media/v4l2-core/v4l2-ioctl.c |   1 +
> >  include/uapi/linux/uvcvideo.h        |  26 +++++
> >  9 files changed, 416 insertions(+), 21 deletions(-)
> >  create mode 100644 drivers/media/usb/uvc/uvc_metadata.c
> 
> [snip]
> 
> > diff --git a/drivers/media/usb/uvc/uvc_driver.c
> > b/drivers/media/usb/uvc/uvc_driver.c index cbf79b9..5f7ce97 100644
> > --- a/drivers/media/usb/uvc/uvc_driver.c
> > +++ b/drivers/media/usb/uvc/uvc_driver.c
> > @@ -1877,6 +1877,7 @@ static void uvc_unregister_video(struct uvc_device
> > *dev) continue;
> > 
> >  		video_unregister_device(&stream->vdev);
> > +		video_unregister_device(&stream->meta.vdev);
> > 
> >  		uvc_debugfs_cleanup_stream(stream);
> >  	}
> > @@ -1934,6 +1935,11 @@ static int uvc_register_video(struct uvc_device *dev,
> > return ret;
> >  	}
> > 
> > +	/* Register a metadata node, but ignore a possible failure, complete
> > +	 * registration of video nodes anyway.
> > +	 */
> > +	uvc_meta_register(stream);
> > +
> >  	if (stream->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
> >  		stream->chain->caps |= V4L2_CAP_VIDEO_CAPTURE;
> >  	else
> > @@ -2003,6 +2009,7 @@ static int uvc_register_chains(struct uvc_device *dev)
> > 
> >  struct uvc_device_info {
> >  	u32	quirks;
> > +	u32	meta_format;
> >  };
> > 
> >  static int uvc_probe(struct usb_interface *intf,
> > @@ -2038,8 +2045,16 @@ static int uvc_probe(struct usb_interface *intf,
> >  	dev->udev = usb_get_dev(udev);
> >  	dev->intf = usb_get_intf(intf);
> >  	dev->intfnum = intf->cur_altsetting->desc.bInterfaceNumber;
> > +	if (uvc_quirks_param != -1 &&
> > +	    uvc_quirks_param & UVC_DEV_FLAG_METADATA_NODE) {
> > +		uvc_quirks_param &= ~UVC_DEV_FLAG_METADATA_NODE;
> > +		if (uvc_quirks_param == 0)
> > +			uvc_quirks_param = -1;
> > +	}
> 
> I think we can remove the UVC_DEV_FLAG_METADATA_NODE flag. We can use the 
> metadata format specified in the device information structure if present, and 
> default to the standard metadata format otherwise. A metadata video node will 
> always be registered, which I think is the right thing to do as exposing 
> timestamp information to userspace is useful.
> 
> Do you see any adverse effect of registering a metadata video node 
> unconditionally ?

No, apart from confusion on behalf of applications and users.

> >  	dev->quirks = (uvc_quirks_param == -1)
> >  		    ? quirks : uvc_quirks_param;
> > +	if (info)
> > +		dev->meta_format = info->meta_format;
> > 
> >  	if (udev->product != NULL)
> >  		strlcpy(dev->name, udev->product, sizeof dev->name);
> 
> [snip]
> 
> > diff --git a/drivers/media/usb/uvc/uvc_metadata.c
> > b/drivers/media/usb/uvc/uvc_metadata.c new file mode 100644
> > index 0000000..21eeee9
> > --- /dev/null
> > +++ b/drivers/media/usb/uvc/uvc_metadata.c
> 
> [snip]
> 
> > +/* ------------------------------------------------------------------------
> > + * videobuf2 Queue Operations
> > + */
> > +
> 
> You can remove this now that the section is empty :-)
> 
> > +/* ------------------------------------------------------------------------
> > + * V4L2 ioctls
> > + */
> > +
> > +static int uvc_meta_v4l2_querycap(struct file *file, void *fh,
> > +				  struct v4l2_capability *cap)
> > +{
> > +	struct v4l2_fh *vfh = file->private_data;
> > +	struct uvc_streaming *stream = video_get_drvdata(vfh->vdev);
> > +
> > +	strlcpy(cap->driver, "uvcvideo", sizeof(cap->driver));
> > +	strlcpy(cap->card, vfh->vdev->name, sizeof(cap->card));
> > +	usb_make_path(stream->dev->udev, cap->bus_info, sizeof(cap->bus_info));
> > +
> > +	return 0;
> > +}
> 
> Do you think we could reuse uvc_ioctl_querycap() as-is ?

AFAICS it still has

	cap->capabilities = V4L2_CAP_DEVICE_CAPS | V4L2_CAP_STREAMING
			  | chain->caps;

in it, which doesn't suit the metadata node?

> > +
> > +static int uvc_meta_v4l2_get_format(struct file *file, void *fh,
> > +				    struct v4l2_format *format)
> > +{
> > +	struct v4l2_fh *vfh = file->private_data;
> > +	struct uvc_streaming *stream = video_get_drvdata(vfh->vdev);
> > +	struct v4l2_meta_format *fmt = &format->fmt.meta;
> > +
> > +	if (format->type != vfh->vdev->queue->type)
> > +		return -EINVAL;
> > +
> > +	memset(fmt, 0, sizeof(*fmt));
> > +
> > +	fmt->dataformat = stream->cur_meta_format;
> > +	fmt->buffersize = UVC_METATADA_BUF_SIZE;
> 
> You need to take the stream->mutex lock here to protect against races with the 
> set format ioctl.

Well, strictly speaking you don't? The buffersize is constant and getting 
the current metadata format is an atomic read.

[snip]

> With the uvc_register_video_device() helper this function would become
> 
> int uvc_meta_register(struct uvc_streaming *stream)
> {
> 	struct uvc_device *dev = stream->dev;
> 	struct video_device *vdev = &stream->meta.vdev;
> 	struct uvc_video_queue *queue = &stream->meta.queue;
> 
> 	/*
> 	 * Register metadata device nodes only if the METADATA_NODE quirk is
> 	 * set.
> 	 */
> 	if (!(dev->quirks & UVC_DEV_FLAG_METADATA_NODE))
> 		return 0;
> 
> 	stream->cur_meta_format = V4L2_META_FMT_UVC;
> 
> 	/*
> 	 * The video interface queue uses manual locking and thus does not set
> 	 * the queue pointer. Set it manually here.
> 	 */
> 	vdev->queue = &queue->queue;
> 
> 	return uvc_register_video_device(dev, stream, vdev, queue,
> 					 V4L2_BUF_TYPE_META_CAPTURE,
> 					 &uvc_meta_fops, &uvc_meta_ioctl_ops);
> }
> 
> What do you think, is it worth it ?

Sure, looks good to me, thanks.

> > diff --git a/drivers/media/usb/uvc/uvc_queue.c
> > b/drivers/media/usb/uvc/uvc_queue.c index c8d78b2..b2998f5 100644
> > --- a/drivers/media/usb/uvc/uvc_queue.c
> > +++ b/drivers/media/usb/uvc/uvc_queue.c

[snip]

> > +	if (!meta_buf || length == 2 ||
> > +	    meta_buf->length - meta_buf->bytesused <
> > +	    length + sizeof(meta->ns) + sizeof(meta->sof))
> > +		return;
> 
> If the metadata buffer overflows should we also set the error bit like we do 
> for video buffers ? I have mixed feelings about this, I'd appreciate your 
> input.

I think it would be good to know if we ever run into such overruns. 
Setting an error flag is more likely to be noticed and reported than a 
printk()?

> > +	has_pts = mem[1] & UVC_STREAM_PTS;
> > +	has_scr = mem[1] & UVC_STREAM_SCR;
> > +
> > +	if (has_pts) {
> > +		len_std += 4;
> > +		scr = mem + 6;
> > +	} else {
> > +		scr = mem + 2;
> > +	}
> > +
> > +	if (has_scr)
> > +		len_std += 6;
> > +
> > +	if (stream->cur_meta_format == V4L2_META_FMT_UVC)
> > +		length = len_std;
> > +
> > +	if (length == len_std && (!has_scr ||
> > +				  !memcmp(scr, stream->clock.last_scr, 6)))
> > +		return;
> > +
> > +	meta = (struct uvc_meta_buf *)((u8 *)meta_buf->mem + meta_buf->bytesused);
> > +	local_irq_save(flags);
> > +	uvc_video_get_ts(&ts);
> 
> FYI, Arnd has posted https://patchwork.kernel.org/patch/10076887/. If the 
> patch gets merged first I can help with the rebasing.
> 
> > +	meta->sof = usb_get_current_frame_number(stream->dev->udev);
> > +	local_irq_restore(flags);
> > +	meta->ns = timespec_to_ns(&ts);
> 
> The meta pointer can be unaligned as the structure is packed and its size 
> isn't a multiple of the size of the largest field (and it can contain an 
> unspecified amount of vendor data anyway). You thus can't access it directly 
> on all architectures, you will need to use the put_unaligned macro. As I 
> haven't checked whether all architectures can handle unaligned accesses 
> without generating a trap, I would store the USB frame number in a local 
> variable and use the put_unaligned macro output of the IRQ disabled section 
> (feel free to show me that I'm unnecessarily cautious :-)).

I think you're right. But __put_unaligned_cpu64() is an inline function, 
not a macro, so, no local variable is needed?

> > +	if (has_scr)
> > +		memcpy(stream->clock.last_scr, scr, 6);
> > +
> > +	memcpy(&meta->length, mem, length);
> > +	meta_buf->bytesused += length + sizeof(meta->ns) + sizeof(meta->sof);
> > +
> > +	uvc_trace(UVC_TRACE_FRAME,
> > +		  "%s(): t-sys %lu.%09lus, SOF %u, len %u, flags 0x%x, PTS %u, STC %u
> > frame SOF %u\n",
> > +		  __func__, ts.tv_sec, ts.tv_nsec, meta->sof,
> > +		  meta->length, meta->flags, has_pts ? *(u32 *)meta->buf : 0,
> > +		  has_scr ? *(u32 *)scr : 0,
> > +		  has_scr ? *(u32 *)(scr + 4) & 0x7ff : 0);
> > +}
> > +
> > +/* ------------------------------------------------------------------------
> >   * URB handling
> >   */
> > 
> > @@ -1152,8 +1222,28 @@ static void uvc_video_validate_buffer(const struct
> > uvc_streaming *stream,
> >  /*
> >   * Completion handler for video URBs.
> >   */
> > +
> > +static struct uvc_buffer *uvc_video_step_buffers(struct uvc_streaming
> > *stream,
> > +		struct uvc_buffer *video_buf, struct uvc_buffer **meta_buf)
> 
> I find the name uvc_video_step_buffers() a bit confusing and would have gone 
> for uvc_video_next_buffers(), but that might just be because I'm not used to 
> the new name :-)

I don't like step_buffers either, but next_buffers doesn't sound a lot 
better to me. Anyway, if you prefer that, let's rename.

> I still dislike the fact that the video and metadata buffers are handled 
> differently :-/ Do you really think it would be a bad idea to pass both as 
> struct uvc_buffer ** ?

This will result in one superfluous assignment per bulk decode call :-) 
But ok, let's do that, will look better indeed. We couls then also change 
the uvc_queue_next_buffer() function similarly to have an input-output 
parameter instead of returning the next buffer, but that isn't related, 
would be a separate patch.

> > diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c
> > b/drivers/media/v4l2-core/v4l2-ioctl.c index 7961499..fba8021 100644
> > --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> > +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> > @@ -1246,6 +1246,7 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
> > case V4L2_TCH_FMT_TU08:		descr = "8-bit unsigned touch data"; break; 
> case
> > V4L2_META_FMT_VSP1_HGO:	descr = "R-Car VSP1 1-D Histogram"; break; case
> > V4L2_META_FMT_VSP1_HGT:	descr = "R-Car VSP1 2-D Histogram"; break; +	case
> > V4L2_META_FMT_UVC:		descr = "UVC payload header metadata"; break;
> > 
> >  	default:
> >  		/* Compressed formats */
> 
> I think this belongs to patch 1/3. I'll move it there.
> 
> [snip]
> 
> For your convenience I've rebased your patch series on top of the two patches 
> I mentioned and added another patch on top that contains fixes for all the 
> small issues mentioned above. The result is available at
> 
> 	git://linuxtv.org/pinchartl/media.git uvc/metadata
> 
> There are just a handful of issues or questions I haven't addressed, if we 
> handle them I think we'll be good to go.

Thanks for rebasing. I've addressed the remaining issues, and once I get 
your answers to remaining questions above, I'll send an updated version.

Thanks
Guennadi
