Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:43715 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751660AbdG1Knc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Jul 2017 06:43:32 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v4] uvcvideo: add a metadata device node
Date: Fri, 28 Jul 2017 13:43:42 +0300
Message-ID: <1531130.FO5JegcqFe@avalon>
In-Reply-To: <Pine.LNX.4.64.1707280836040.15990@axis700.grange>
References: <Pine.LNX.4.64.1707071536440.9200@axis700.grange> <1573148.l0ngrOGOl6@avalon> <Pine.LNX.4.64.1707280836040.15990@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Friday 28 Jul 2017 10:59:29 Guennadi Liakhovetski wrote:
> On Fri, 28 Jul 2017, Laurent Pinchart wrote:
> > On Tuesday 25 Jul 2017 15:27:24 Guennadi Liakhovetski wrote:
> >> On Fri, 21 Jul 2017, Laurent Pinchart wrote:
> >>> Hi Guennadi,
> >>> 
> >>> Thank you for the patch.
> >>> 
> >>>> Some UVC video cameras contain metadata in their payload headers.
> >>>> This patch extracts that data, adding more clock synchronisation
> >>>> information, on both bulk and isochronous endpoints and makes it
> >>>> available to the user space on a separate video node, using the
> >>>> V4L2_CAP_META_CAPTURE capability and the V4L2_BUF_TYPE_META_CAPTURE
> >>>> buffer queue type. Even though different cameras will have different
> >>>> metadata formats, we use the same V4L2_META_FMT_UVC pixel format for
> >>>> all of them. Users have to parse data, based on the specific camera
> >>>> model information.
> >>> 
> >>> The issue we still haven't addressed is how to ensure that vendors
> >>> will document their metadata format :-S
> >> 
> >> Uhm, add a black list of offending vendors and drop 60% of their frames?
> >> ;-)
> > 
> > This was actually a serious question :-)
> > 
> > How about white-listing cameras instead, and enabling extended metadata
> > (after the standard header) support only for vendors who have documented
> > their format ?
> > 
> > Speaking of which, where's the documentation for the camera you're working
> > on ? :-)
> 
> The metadata definition is at the known to you page
> https://docs.microsoft.com/en-us/windows-hardware/drivers/stream/uvc-extensi
> ons-1-5 :-) But yes, I'll check with managers and submit a dev-flag patch
> too.

What bothers me is

"The MetadataId field is filled by an identifier from the following enum 
definition which contains well-defined identifiers as well as custom 
identifiers (identifiers >= MetadataId_Custom_Start)."

I want vendors to document the custom fields.

> >>>> This version of the patch only creates such metadata nodes for
> >>>> cameras, specifying a UVC_QUIRK_METADATA_NODE quirk flag.
> >>>> 
> >>>> Signed-off-by: Guennadi Liakhovetski
> >>>> <guennadi.liakhovetski@intel.com>
> >>>> ---
> >>>> 
> >>>> v4:
> >>>> - add support for isochronous cameras. Metadata is now collected from
> >>>> as many payloads as they fit in the buffer
> >>>> - add a USB Start Of Frame and a system timestamp to each metadata
> >>>> block for user-space clock synchronisation
> >>>> - use a default buffer size of 1024 bytes
> >>>> 
> >>>> Thanks to Laurent for patient long discussions and to everybody, who
> >>>> helped me conduct all the investigation into various past, present
> >>>> and future UVC cameras :-)
> >>>> 
> >>>>  drivers/media/usb/uvc/Makefile       |   2 +-
> >>>>  drivers/media/usb/uvc/uvc_driver.c   |   4 +
> >>>>  drivers/media/usb/uvc/uvc_isight.c   |   2 +-
> >>>>  drivers/media/usb/uvc/uvc_metadata.c | 158 ++++++++++++++++++++++++++
> >>>>  drivers/media/usb/uvc/uvc_queue.c    |  68 ++++++++++-----
> >>>>  drivers/media/usb/uvc/uvc_video.c    | 101 +++++++++++++++++++---
> >>>>  drivers/media/usb/uvc/uvcvideo.h     |  23 ++++-
> >>>>  drivers/media/v4l2-core/v4l2-ioctl.c |   1 +
> >>>>  include/uapi/linux/uvcvideo.h        |  19 +++++
> >>>>  include/uapi/linux/videodev2.h       |   3 +
> >>>>  10 files changed, 347 insertions(+), 34 deletions(-)
> >>>>  create mode 100644 drivers/media/usb/uvc/uvc_metadata.c

[snip]

> >>>> diff --git a/drivers/media/usb/uvc/uvc_queue.c
> >>>> b/drivers/media/usb/uvc/uvc_queue.c
> >>>> index aa21997..77dedbc 100644
> >>>> --- a/drivers/media/usb/uvc/uvc_queue.c
> >>>> +++ b/drivers/media/usb/uvc/uvc_queue.c
> > 
> > [snip]
> > 
> >>>> -static int uvc_buffer_prepare(struct vb2_buffer *vb)
> >>>> +int uvc_buffer_prepare(struct vb2_buffer *vb)
> >>>>  {
> >>>>  	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
> >>>>  	struct uvc_video_queue *queue = vb2_get_drv_priv(vb
> >>>> ->vb2_queue);
> >>>>  	struct uvc_buffer *buf = uvc_vbuf_to_buffer(vbuf);
> >>>> 
> >>>> -	if (vb->type == V4L2_BUF_TYPE_VIDEO_OUTPUT &&
> >>>> -	    vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0)) {
> >>>> -		uvc_trace(UVC_TRACE_CAPTURE, "[E] Bytes used out of
> >>>> bounds.\n");
> >>>> -		return -EINVAL;
> >>>> -	}
> >>>> -
> >>>>  	if (unlikely(queue->flags & UVC_QUEUE_DISCONNECTED))
> >>>>  		return -ENODEV;
> >>>> 
> >>>> +	switch (vb->type) {
> >>>> +	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> >>>> +		if (vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb,
> >>>> 0)) {
> >>>> +			uvc_trace(UVC_TRACE_CAPTURE,
> >>>> +				  "[E] Bytes used out of bounds.\n");
> >>>> +			return -EINVAL;
> >>>> +		}
> >>>> +
> >>>> +		buf->bytesused = vb2_get_plane_payload(vb, 0);
> >>>> +
> >>>> +		break;
> >>>> +	case V4L2_BUF_TYPE_META_CAPTURE:
> >>>> +		if (vb->num_planes != 1 ||
> >>>> +		    vb2_plane_size(vb, 0) < UVC_METATADA_BUF_SIZE) {
> >>> 
> >>> Can this happen, given that queue_setup rejects buffers that verify
> >>> those conditions ?
> >> 
> >> As far as I can see, e.g. in the USERPTR case the length is directly
> >> copied from the user-provided struct v4l2_buffer:
> >> 
> >> vb2_qbuf()
> >> vb2_core_qbuf()
> >> __buf_prepare()
> >> __prepare_userptr()
> >> __fill_vb2_buffer()
> >> 
> >> 	planes[0].length = b->length;
> > 
> > Right, but __fill_vb2_buffer() calls __verify_length(), which, unless I'm
> > mistaken, verifies the length passed by userspace.
> 
> I see this at the top of __verify_length():
> 
> 	if (!V4L2_TYPE_IS_OUTPUT(b->type))
> 		return 0;

I think you're right.

Not strictly related to this patch, but looking at __verify_length(), isn't 
the vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0) check in the 
V4L2_BUF_TYPE_VIDEO_OUTPUT above unneeded ?

> >> Still, the length check is optional. We could just as well omit it here
> >> and rely on the respective uvc_video_decode_*() function to limit the
> >> amount of copied data. But it does look like vb->num_planes cannot be
> >> wrong, you're right about that one.
> >> 
> >>>> +			uvc_trace(UVC_TRACE_CAPTURE,
> >>>> +				  "[E] Invalid buffer configuration.
> >>>> \n");
> >>>> +			return -EINVAL;
> >>>> +		}
> >>>> +		/* Fall through */
> >>>> +	default:
> >>>> +		buf->bytesused = 0;
> >>>> +	}
> >>>> +
> >>>>  	buf->state = UVC_BUF_STATE_QUEUED;
> >>>>  	buf->error = 0;
> >>>>  	buf->mem = vb2_plane_vaddr(vb, 0);
> >>>>  	buf->length = vb2_plane_size(vb, 0);
> >>>> 
> >>>> -	if (vb->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
> >>> 
> >>> Unless I was mistaken in my previous comment, I think you only need to
> >>> change the condition to vb->type != V4L2_BUF_TYPE_VIDEO_OUTPUT, no
> >>> other change to the function should be needed.
> >> 
> >> Yeah, ok, let's do that.
> >> 
> >>>> -		buf->bytesused = 0;
> >>>> -	else
> >>>> -		buf->bytesused = vb2_get_plane_payload(vb, 0);
> >>>> 
> >>>>  	return 0;
> >>>>  }
> > 
> > [snip]

-- 
Regards,

Laurent Pinchart
