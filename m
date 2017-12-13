Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:37892 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751088AbdLMJlE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Dec 2017 04:41:04 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v8] uvcvideo: Add a metadata device node
Date: Wed, 13 Dec 2017 11:41:07 +0200
Message-ID: <1776907.6M9RIR1GJL@avalon>
In-Reply-To: <alpine.DEB.2.20.1712120922250.26789@axis700.grange>
References: <1510156814-28645-1-git-send-email-g.liakhovetski@gmx.de> <6880941.qHIMnLEYKN@avalon> <alpine.DEB.2.20.1712120922250.26789@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Tuesday, 12 December 2017 10:30:39 EET Guennadi Liakhovetski wrote:
> On Mon, 11 Dec 2017, Laurent Pinchart wrote:
> > On Monday, 11 December 2017 23:44:09 EET Guennadi Liakhovetski wrote:
> >> On Mon, 11 Dec 2017, Laurent Pinchart wrote:
> >>> On Monday, 11 December 2017 22:16:23 EET Laurent Pinchart wrote:
> >>>> On Wednesday, 6 December 2017 17:15:40 EET Guennadi Liakhovetski wrote:
> >>>>> From: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
> >>>>> 
> >>>>> Some UVC video cameras contain metadata in their payload headers.
> >>>>> This patch extracts that data, adding more clock synchronisation
> >>>>> information, on both bulk and isochronous endpoints and makes it
> >>>>> available to the user space on a separate video node, using the
> >>>>> V4L2_CAP_META_CAPTURE capability and the V4L2_BUF_TYPE_META_CAPTURE
> >>>>> buffer queue type. By default, only the V4L2_META_FMT_UVC pixel
> >>>>> format is available from those nodes. However, cameras can be added to
> >>>>> the device ID table to additionally specify their own metadata format,
> >>>>> in which case that format will also become available from the metadata
> >>>>> node.
> >>>>> 
> >>>>> Signed-off-by: Guennadi Liakhovetski
> >>>>> <guennadi.liakhovetski@intel.com>
> >>>>> ---
> >>>>> 
> >>>>> v8: addressed comments and integrated changes from Laurent, thanks
> >>>>> again, e.g.:
> >>>>> 
> >>>>> - multiple stylistic changes
> >>>>> - remove the UVC_DEV_FLAG_METADATA_NODE flag / quirk: nodes are now
> >>>>>   created unconditionally
> >>>>> - reuse uvc_ioctl_querycap()
> >>>>> - reuse code in uvc_register_video()
> >>>>> - set an error flag when the metadata buffer overflows
> >>>>> 
> >>>>>  drivers/media/usb/uvc/Makefile       |   2 +-
> >>>>>  drivers/media/usb/uvc/uvc_driver.c   |  15 ++-
> >>>>>  drivers/media/usb/uvc/uvc_isight.c   |   2 +-
> >>>>>  drivers/media/usb/uvc/uvc_metadata.c | 179+++++++++++++++++++++++++++
> >>>>>  drivers/media/usb/uvc/uvc_queue.c    |  44 +++++++--
> >>>>>  drivers/media/usb/uvc/uvc_video.c    | 132 +++++++++++++++++++++++--
> >>>>>  drivers/media/usb/uvc/uvcvideo.h     |  16 +++-
> >>>>>  include/uapi/linux/uvcvideo.h        |  26 +++++
> >>>>>  8 files changed, 394 insertions(+), 22 deletions(-)
> >>>>>  create mode 100644 drivers/media/usb/uvc/uvc_metadata.c
> >>>> 
> >>>> [snip]
> >>>> 
> >>>>> diff --git a/drivers/media/usb/uvc/uvc_video.c
> >>>>> b/drivers/media/usb/uvc/uvc_video.c index 13f459e..2fc0bf2 100644
> >>>>> --- a/drivers/media/usb/uvc/uvc_video.c
> >>>>> +++ b/drivers/media/usb/uvc/uvc_video.c
> >>>> 
> >>>> [snip]
> >>>> 
> >>>>> +static void uvc_video_decode_meta(struct uvc_streaming *stream,
> >>>>> +				  struct uvc_buffer *meta_buf,
> >>>>> +				  const u8 *mem, unsigned int length)
> >>>>> +{
> >>>>> +	struct uvc_meta_buf *meta;
> >>>>> +	size_t len_std = 2;
> >>>>> +	bool has_pts, has_scr;
> >>>>> +	unsigned long flags;
> >>>>> +	ktime_t time;
> >>>>> +	const u8 *scr;

[snip]

> >>>>> +	meta = (struct uvc_meta_buf *)((u8 *)meta_buf->mem +
> >>>>> meta_buf->bytesused);
> >>>>> +	local_irq_save(flags);
> >>>>> +	time = uvc_video_get_time();
> >>>>> +	meta->sof = usb_get_current_frame_number(stream->dev->udev);
> >>>> 
> >>>> You need a put_unaligned here too. If you're fine with the patch
> >>>> below there's no need to resubmit, and
> >>> 
> >>> One more thing, __put_unaligned_cpu16() and __put_unaligned_cpu64()
> >>> don't compile on x86_64 with v4.12 (using media_build.git). I propose
> >>> replacing them with put_unaligned() which compiles and should do the
> >>> right thing.
> >> 
> >> Sure, thanks for catching! Shall I fix and resubmit?
> > 
> > If you're fine with
> > 
> > 	git://linuxtv.org/pinchartl/media.git uvc/next
> 
> I was a bit concerned about just using "int" for unaligned writing of a
> 16-bit value, but looking at definitions, after a couple of macros
> put_unaligned() currently resolves to one inline functions, which should
> make that safe. However, at least theoretically, an arch could decide to
> implement put_unaligned() as a macro, which might turn out to be unsafe
> for this... Not sure how concerned should we be about such a possibility
> :-) If you think, that's fine, then I'm ok with using the version from
> that your branch.

Why do you think that would be unsafe ? The return type of 
usb_get_current_frame_number() is int, so introducing an intermediate int 
variable should at least not make things worse. If put_unaligned() is 
implemented solely using macros I would still expect them to operate on the 
type of the destination operand, and cast the source value appropriately.

[snip]

-- 
Regards,

Laurent Pinchart
