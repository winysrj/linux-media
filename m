Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:62348 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1762592AbdJRHcP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Oct 2017 03:32:15 -0400
Date: Wed, 18 Oct 2017 09:32:10 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 4/6 v5] uvcvideo: add a metadata device node
In-Reply-To: <ee61391f-4183-eaf3-437a-666652cd4f23@xs4all.nl>
Message-ID: <alpine.DEB.2.20.1710180926280.11231@axis700.grange>
References: <1501245205-15802-1-git-send-email-g.liakhovetski@gmx.de> <1501245205-15802-5-git-send-email-g.liakhovetski@gmx.de> <ee61391f-4183-eaf3-437a-666652cd4f23@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for your comment.

On Fri, 28 Jul 2017, Hans Verkuil wrote:

> On 07/28/2017 02:33 PM, Guennadi Liakhovetski wrote:
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
> > 
> > Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
> > ---
> >  drivers/media/usb/uvc/Makefile       |   2 +-
> >  drivers/media/usb/uvc/uvc_ctrl.c     |   3 +
> >  drivers/media/usb/uvc/uvc_driver.c   |  12 +++
> >  drivers/media/usb/uvc/uvc_isight.c   |   2 +-
> >  drivers/media/usb/uvc/uvc_metadata.c | 139 +++++++++++++++++++++++++++++++++++
> >  drivers/media/usb/uvc/uvc_queue.c    |  41 +++++++++--
> >  drivers/media/usb/uvc/uvc_video.c    | 119 +++++++++++++++++++++++++++---
> >  drivers/media/usb/uvc/uvcvideo.h     |  17 ++++-
> >  drivers/media/v4l2-core/v4l2-ioctl.c |   1 +
> >  include/uapi/linux/uvcvideo.h        |  26 +++++++
> >  10 files changed, 341 insertions(+), 21 deletions(-)
> >  create mode 100644 drivers/media/usb/uvc/uvc_metadata.c

[snip]

> > diff --git a/include/uapi/linux/uvcvideo.h b/include/uapi/linux/uvcvideo.h
> > index 3b08186..ffe17ec 100644
> > --- a/include/uapi/linux/uvcvideo.h
> > +++ b/include/uapi/linux/uvcvideo.h
> > @@ -67,4 +67,30 @@ struct uvc_xu_control_query {
> >  #define UVCIOC_CTRL_MAP		_IOWR('u', 0x20, struct uvc_xu_control_mapping)
> >  #define UVCIOC_CTRL_QUERY	_IOWR('u', 0x21, struct uvc_xu_control_query)
> >  
> > +/*
> > + * Metadata node
> > + */
> > +
> > +/**
> > + * struct uvc_meta_buf - metadata buffer building block
> > + * @ns		- system timestamp of the payload in nanoseconds
> > + * @sof		- USB Frame Number
> > + * @length	- length of the payload header
> > + * @flags	- payload header flags
> > + * @buf		- optional device-specific header data
> > + *
> > + * UVC metadata nodes fill buffers with possibly multiple instances of this
> > + * struct. The first two fields are added by the driver, they can be used for
> > + * clock synchronisation. The rest is an exact copy of a UVC payload header.
> > + * Only complete objects with complete buffers are included. Therefore it's
> > + * always sizeof(meta->ts) + sizeof(meta->sof) + meta->length bytes large.
> > + */
> > +struct uvc_meta_buf {
> > +	__u64 ns;
> > +	__u16 sof;
> > +	__u8 length;
> > +	__u8 flags;
> 
> I think the struct layout is architecture dependent. I could be wrong, but I think
> for x64 there is a 4-byte hole here, but not for arm32/arm64.
> 
> Please double-check the struct layout.

You mean this can be a problem for 64- / 32-bit compatibility? If the 
difference is just between ARM and X86 then we don't care, do we? Or do 
video buffers have to be safe for cross-system transfer?

> BTW: __u8 for length? The payload can never be longer in UVC?

No, not the payload, a single payload header cannot be larger than 255 
bytes, that's right.

Thanks
Guennadi

> Regards,
> 
> 	Hans
> 
> > +	__u8 buf[];
> > +};
> > +
> >  #endif
> > 
> 
