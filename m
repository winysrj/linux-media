Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:36043 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932529AbeFGLBw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Jun 2018 07:01:52 -0400
Message-ID: <1528369308.3308.9.camel@pengutronix.de>
Subject: Re: [RFC PATCH 1/2] media: docs-rst: Add decoder UAPI specification
 to Codec Interfaces
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Tomasz Figa <tfiga@chromium.org>, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        =?UTF-8?Q?Pawe=C5=82_O=C5=9Bciak?= <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Kamil Debski <kamil@wypas.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Jeongtae Park <jtp.park@samsung.com>,
        Tiffany Lin <tiffany.lin@mediatek.com>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Todor Tomov <todor.tomov@linaro.org>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Date: Thu, 07 Jun 2018 13:01:48 +0200
In-Reply-To: <83bebfbc-6cd4-fb9b-48c3-7b82846837be@xs4all.nl>
References: <20180605103328.176255-1-tfiga@chromium.org>
         <20180605103328.176255-2-tfiga@chromium.org>
         <83bebfbc-6cd4-fb9b-48c3-7b82846837be@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2018-06-07 at 10:47 +0200, Hans Verkuil wrote:
> Hi Tomasz,
> 
> First of all: thank you very much for working on this. It's a big missing piece of
> information, so filling this in is very helpful.
[...]
> > diff --git a/Documentation/media/uapi/v4l/dev-codec.rst b/Documentation/media/uapi/v4l/dev-codec.rst
> > index c61e938bd8dc..0483b10c205e 100644
> > --- a/Documentation/media/uapi/v4l/dev-codec.rst
> > +++ b/Documentation/media/uapi/v4l/dev-codec.rst
> > @@ -34,3 +34,774 @@ the codec and reprogram it whenever another file handler gets access.
> >  This is different from the usual video node behavior where the video
> >  properties are global to the device (i.e. changing something through one
> >  file handle is visible through another file handle).
> 
> To what extent does the information in this patch series apply specifically to
> video (de)compression hardware and to what extent it is applicable for any m2m
> device? It looks like most if not all is specific to video (de)compression hw
> and not to e.g. a simple deinterlacer.

Most of this is specific to codecs, or at least to mem2mem devices that
are not simple 1 input frame -> 1 output frame converters, and where
some parameters (resolution, colorspace) can be unknown in advance.

> Ideally there would be a common section first describing the requirements for
> all m2m devices, followed by an encoder and decoder section going into details
> for those specific devices.
> 
> I also think that we need an additional paragraph somewhere at the beginning
> of the Codec Interface chapter that explains more clearly that OUTPUT buffers
> send data to the hardware to be processed and that CAPTURE buffers contains
> the processed data. It is always confusing for newcomers to understand that
> in V4L2 this is seen from the point of view of the CPU.

Yes, please!

> > +EOS
> > +   end of stream
> > +
> > +input height
> > +   height in pixels for given input resolution
> 
> 'input' is a confusing name. Because I think this refers to the resolution
> set for the OUTPUT buffer. How about renaming this to 'source'?
>
> I.e.: an OUTPUT buffer contains the source data for the hardware. The capture
> buffer contains the sink data from the hardware.

This could be confusing as well to people used to the v4l2_subdev
sink/source pad model.

[...]
> > +Initialization sequence
> > +-----------------------
> > +
> > +1. (optional) Enumerate supported OUTPUT formats and resolutions. See
> > +   capability enumeration.
> > +
> > +2. Set a coded format on the source queue via :c:func:`VIDIOC_S_FMT`
> > +
> > +   a. Required fields:
> > +
> > +      i.   type = OUTPUT
> > +
> > +      ii.  fmt.pix_mp.pixelformat set to a coded format
> > +
> > +      iii. fmt.pix_mp.width, fmt.pix_mp.height only if cannot be
> > +           parsed from the stream for the given coded format;
> > +           ignored otherwise;
> > +
> > +   b. Return values:
> > +
> > +      i.  EINVAL: unsupported format.
> > +
> > +      ii. Others: per spec
> > +
> > +   .. note::
> > +
> > +      The driver must not adjust pixelformat, so if
> > +      ``V4L2_PIX_FMT_H264`` is passed but only
> > +      ``V4L2_PIX_FMT_H264_SLICE`` is supported, S_FMT will return
> > +      -EINVAL. If both are acceptable by client, calling S_FMT for
> > +      the other after one gets rejected may be required (or use
> > +      :c:func:`VIDIOC_ENUM_FMT` to discover beforehand, see Capability
> > +      enumeration).
> 
> This needs to be documented in S_FMT as well.
> 
> What will TRY_FMT do? Return EINVAL as well, or replace the pixelformat?
> 
> Should this be a general rule for output devices that S_FMT (and perhaps TRY_FMT)
> fail with EINVAL if the pixelformat is not supported? There is something to be
> said for that.

Why is trying to set an unsupported pixelformat an error, but trying to
set an unsupported resolution is not?

[...]
> > +5.  Begin parsing the stream for stream metadata via :c:func:`VIDIOC_STREAMON` on
> > +    OUTPUT queue. This step allows the driver to parse/decode
> > +    initial stream metadata until enough information to allocate
> > +    CAPTURE buffers is found. This is indicated by the driver by
> > +    sending a ``V4L2_EVENT_SOURCE_CHANGE`` event, which the client
> > +    must handle.
> > +
> > +    a. Required fields: as per spec.
> > +
> > +    b. Return values: as per spec.
> > +
> > +    .. note::
> > +
> > +       Calling :c:func:`VIDIOC_REQBUFS`, :c:func:`VIDIOC_STREAMON`
> > +       or :c:func:`VIDIOC_G_FMT` on the CAPTURE queue at this time is not
> > +       allowed and must return EINVAL.
> 
> I dislike EINVAL here. It is too generic. Also, the passed arguments can be
> perfectly valid, you just aren't in the right state. EPERM might be better.
[...]
> > +
> > +    a. Required fields: as per spec.
> > +
> > +    b. Return values: as per spec.
> > +
> > +    c. If data in a buffer that triggers the event is required to decode
> > +       the first frame, the driver must not return it to the client,
> > +       but must retain it for further decoding.
> > +
> > +    d. Until the resolution source event is sent to the client, calling
> > +       :c:func:`VIDIOC_G_FMT` on the CAPTURE queue must return -EINVAL.
> 
> EPERM?

I dislike returning an error here at all. If the queues are independent,
why can't the capture queue STREAMON and just not produce any frames?

If we guessed format and frame size correctly (maybe we know something
about the stream from container metadata), the capture queue can just
start producing images. If not, we get a source change event.

regards
Philipp
