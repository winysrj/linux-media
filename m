Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:54079 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751770AbdK1P0b (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Nov 2017 10:26:31 -0500
Date: Tue, 28 Nov 2017 16:26:26 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 1/3 v7] V4L: Add a UVC Metadata format
In-Reply-To: <6959169.cj8yPDWWnC@avalon>
Message-ID: <alpine.DEB.2.20.1711281625280.16991@axis700.grange>
References: <1510156814-28645-1-git-send-email-g.liakhovetski@gmx.de> <1510156814-28645-2-git-send-email-g.liakhovetski@gmx.de> <6959169.cj8yPDWWnC@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the review.

On Tue, 28 Nov 2017, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> Thank you for the patch.
> 
> Overall this looks good to me. Please see below for one small comment.

Yes, looks good to me, feel free to use your wording.

Thanks
Guennadi

> On Wednesday, 8 November 2017 18:00:12 EET Guennadi Liakhovetski wrote:
> > From: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
> > 
> > Add a pixel format, used by the UVC driver to stream metadata.
> > 
> > Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
> > ---
> > 
> > v7: alphabetic order, update documentation.
> > 
> >  Documentation/media/uapi/v4l/meta-formats.rst    |  1 +
> >  Documentation/media/uapi/v4l/pixfmt-meta-uvc.rst | 50 +++++++++++++++++++++
> >  include/uapi/linux/videodev2.h                   |  1 +
> >  3 files changed, 52 insertions(+)
> >  create mode 100644 Documentation/media/uapi/v4l/pixfmt-meta-uvc.rst
> > 
> > diff --git a/Documentation/media/uapi/v4l/meta-formats.rst
> > b/Documentation/media/uapi/v4l/meta-formats.rst index 01e24e3..0c4e1ec
> > 100644
> > --- a/Documentation/media/uapi/v4l/meta-formats.rst
> > +++ b/Documentation/media/uapi/v4l/meta-formats.rst
> > @@ -12,5 +12,6 @@ These formats are used for the :ref:`metadata` interface
> > only.
> >  .. toctree::
> >      :maxdepth: 1
> > 
> > +    pixfmt-meta-uvc
> >      pixfmt-meta-vsp1-hgo
> >      pixfmt-meta-vsp1-hgt
> > diff --git a/Documentation/media/uapi/v4l/pixfmt-meta-uvc.rst
> > b/Documentation/media/uapi/v4l/pixfmt-meta-uvc.rst new file mode 100644
> > index 0000000..06f603c
> > --- /dev/null
> > +++ b/Documentation/media/uapi/v4l/pixfmt-meta-uvc.rst
> > @@ -0,0 +1,50 @@
> > +.. -*- coding: utf-8; mode: rst -*-
> > +
> > +.. _v4l2-meta-fmt-uvc:
> > +
> > +*******************************
> > +V4L2_META_FMT_UVC ('UVCH')
> > +*******************************
> > +
> > +UVC Payload Header Data
> > +
> > +
> > +Description
> > +===========
> > +
> > +This format describes standard UVC metadata, extracted from UVC packet
> > headers +and provided by the UVC driver through metadata video nodes. That
> > data includes +exact copies of the standard part of UVC Payload Header
> > contents and auxiliary +timing information, required for precise
> > interpretation of timestamps, contained +in those headers. See section
> > "2.4.3.3 Video and Still Image Payload Headers" of +the "UVC 1.5 Class
> > specification" for details.
> > +
> > +Each UVC payload header can be between 2 and 12 bytes large. Buffers can
> > contain +multiple headers, if multiple such headers have been transmitted
> > by the camera +for the respective frame. However, headers, containing no
> > useful information, +e.g. those without the SCR field or with that field
> > identical to the previous +header, will be dropped by the driver.
> 
> If the driver receives too many headers with different SCR (more than the 
> buffer can hold for instance) it will have to drop some of them. The simplest 
> implementation would be to start dropping them when the buffer is full, but 
> I'd like to leave room for the driver to be a bit more clever and drop headers 
> that have a SCR too close to the previous one for instance. I propose wording 
> the above paragraph as follows.
> 
> "Each UVC payload header can be between 2 and 12 bytes large. Buffers can
> contain multiple headers, if multiple such headers have been transmitted
> by the camera for the respective frame. However, the driver may drop headers 
> when the buffer is full, when they contain no useful information (e.g. those 
> without the SCR field or with that field identical to the previous header), or 
> generally to perform rate limiting when the device sends a large number of 
> headers".
> 
> If you're fine with this there's no need to resent, I can update the 
> documentation when applying, and
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> > +Each individual block contains the following fields:
> > +
> > +.. flat-table:: UVC Metadata Block
> > +    :widths: 1 4
> > +    :header-rows:  1
> > +    :stub-columns: 0
> > +
> > +    * - Field
> > +      - Description
> > +    * - __u64 ts;
> > +      - system timestamp in host byte order, measured by the driver upon
> > +        reception of the payload
> > +    * - __u16 sof;
> > +      - USB Frame Number in host byte order, also obtained by the driver as
> > +        close as possible to the above timestamp to enable correlation
> > between +        them
> > +    * - :cspan:`1` *The rest is an exact copy of the UVC payload header:*
> > +    * - __u8 length;
> > +      - length of the rest of the block, including this field
> > +    * - __u8 flags;
> > +      - Flags, indicating presence of other standard UVC fields
> > +    * - __u8 buf[];
> > +      - The rest of the header, possibly including UVC PTS and SCR fields
> > diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> > index 185d6a0..0d07b2d 100644
> > --- a/include/uapi/linux/videodev2.h
> > +++ b/include/uapi/linux/videodev2.h
> > @@ -687,6 +687,7 @@ struct v4l2_pix_format {
> >  /* Meta-data formats */
> >  #define V4L2_META_FMT_VSP1_HGO    v4l2_fourcc('V', 'S', 'P', 'H') /* R-Car
> > VSP1 1-D Histogram */ #define V4L2_META_FMT_VSP1_HGT    v4l2_fourcc('V',
> > 'S', 'P', 'T') /* R-Car VSP1 2-D Histogram */ +#define V4L2_META_FMT_UVC   
> >      v4l2_fourcc('U', 'V', 'C', 'H') /* UVC Payload Header metadata */
> > 
> >  /* priv field value to indicates that subsequent fields are valid. */
> >  #define V4L2_PIX_FMT_PRIV_MAGIC		0xfeedcafe
> 
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 
