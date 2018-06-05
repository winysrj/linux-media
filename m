Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:35557 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751685AbeFEOXF (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Jun 2018 10:23:05 -0400
Message-ID: <1528208578.4074.19.camel@pengutronix.de>
Subject: Re: [RFC PATCH 2/2] media: docs-rst: Add encoder UAPI specification
 to Codec Interfaces
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Tomasz Figa <tfiga@chromium.org>,
        Pawel Osciak <posciak@chromium.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Alexandre Courbot <acourbot@chromium.org>, kamil@wypas.org,
        a.hajda@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>,
        jtp.park@samsung.com,
        Tiffany Lin =?UTF-8?Q?=28=E6=9E=97=E6=85=A7=E7=8F=8A=29?=
        <tiffany.lin@mediatek.com>,
        Andrew-CT Chen =?UTF-8?Q?=28=E9=99=B3=E6=99=BA=E8=BF=AA=29?=
        <andrew-ct.chen@mediatek.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        todor.tomov@linaro.org, nicolas@ndufresne.ca,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Date: Tue, 05 Jun 2018 16:22:58 +0200
In-Reply-To: <CAAFQd5DYu+Oehr1UUvvdmWk7toO0i_=NFgvZcAKQ8ZURKy51fA@mail.gmail.com>
References: <20180605103328.176255-1-tfiga@chromium.org>
         <20180605103328.176255-3-tfiga@chromium.org>
         <1528199628.4074.15.camel@pengutronix.de>
         <CAAFQd5DYu+Oehr1UUvvdmWk7toO0i_=NFgvZcAKQ8ZURKy51fA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2018-06-05 at 21:31 +0900, Tomasz Figa wrote:
[...]
> +Initialization
> > > +--------------
> > > +
> > > +1. (optional) Enumerate supported formats and resolutions. See
> > > +   capability enumeration.
> > > +
> > > +2. Set a coded format on the CAPTURE queue via :c:func:`VIDIOC_S_FMT`
> > > +
> > > +   a. Required fields:
> > > +
> > > +      i.  type = CAPTURE
> > > +
> > > +      ii. fmt.pix_mp.pixelformat set to a coded format to be produced
> > > +
> > > +   b. Return values:
> > > +
> > > +      i.  EINVAL: unsupported format.
> > > +
> > > +      ii. Others: per spec
> > > +
> > > +   c. Return fields:
> > > +
> > > +      i. fmt.pix_mp.width, fmt.pix_mp.height should be 0.
> > > +
> > > +   .. note::
> > > +
> > > +      After a coded format is set, the set of raw formats
> > > +      supported as source on the OUTPUT queue may change.
> > 
> > So setting CAPTURE potentially also changes OUTPUT format?
> 
> Yes, but at this point userspace hasn't yet set the desired format.
> 
> > If the encoded stream supports colorimetry information, should that
> > information be taken from the CAPTURE queue?
> 
> What's colorimetry? Is it something that is included in
> v4l2_pix_format(_mplane)? Is it something that can vary between raw
> input and encoded output?

FTR, yes, I meant the colorspace, ycbcr_enc, quantization, and xfer_func
fields of the v4l2_pix_format(_mplane) structs. GStreamer uses the term
"colorimetry" to pull these fields together into a single parameter.

The codecs usually don't care at all about this information, except some
streams (such as h.264 in the VUI parameters section of the SPS header)
may optionally contain a representation of these fields, so it may be
desirable to let encoders write the configured colorimetry or to let
decoders return the detected colorimetry via G_FMT(CAP) after a source
change event.

I think it could be useful to enforce the same colorimetry on CAPTURE
and OUTPUT queue if the hardware doesn't do any colorspace conversion.

> > > +3. (optional) Enumerate supported OUTPUT formats (raw formats for
> > > +   source) for the selected coded format via :c:func:`VIDIOC_ENUM_FMT`.
> > > +
> > > +   a. Required fields:
> > > +
> > > +      i.  type = OUTPUT
> > > +
> > > +      ii. index = per spec
> > > +
> > > +   b. Return values: per spec
> > > +
> > > +   c. Return fields:
> > > +
> > > +      i. pixelformat: raw format supported for the coded format
> > > +         currently selected on the OUTPUT queue.
> > > +
> > > +4. Set a raw format on the OUTPUT queue and visible resolution for the
> > > +   source raw frames via :c:func:`VIDIOC_S_FMT` on the OUTPUT queue.
> > 
> > Isn't this optional? If S_FMT(CAP) already sets OUTPUT to a valid
> > format, just G_FMT(OUT) should be valid here as well.
> 
> Technically it would be valid indeed, but that would be unlikely what
> the client needs, given that it probably already has some existing raw
> frames (at certain resolution) to encode.

Maybe add a clarifying note that G_FMT is acceptable as an alternative?
We don't have to put this front and center if it is not the expected use
case, but it would still be nice to have it documented as valid use.

This could be part of a still ongoing negotiation process if the source
is a scaler or some frame generator that can create frames of any size.

> > > +
> > > +   a. Required fields:
> > > +
> > > +      i.   type = OUTPUT
> > > +
> > > +      ii.  fmt.pix_mp.pixelformat = raw format to be used as source of
> > > +           encode
> > > +
> > > +      iii. fmt.pix_mp.width, fmt.pix_mp.height = input resolution
> > > +           for the source raw frames
> > 
> > These are specific to multiplanar drivers. The same should apply to
> > singleplanar drivers.
> 
> Right. In general I'd be interested in getting some suggestions in how
> to write this kind of descriptions nicely and consistent with other
> kernel documentation.

Maybe just:

	a. Required fields:

	   i.   type = OUTPUT or OUTPUT_MPLANE

	   ii.  fmt.pix.pixelformat or fmt.pix_mp.pixelformat = ...

           iii. fmt.pix.width, fmt.pix_mp.height or fmt.pix_mp.width,
                fmt.pix_mp.height = ...


[...]
> > > +7. Begin streaming on both OUTPUT and CAPTURE queues via
> > > +   :c:func:`VIDIOC_STREAMON`. This may be performed in any order.
> > 
> > Actual encoding starts once both queues are streaming
> 
> I think that's the only thing possible with vb2, since it gives
> buffers to the driver when streaming starts on given queue.
>
> > and stops as soon
> > as the first queue receives STREAMOFF?
> 
> Given that STREAMOFF is supposed to drop all the buffers from the
> queue, it should be so +/- finishing what's already queued to the
> hardware, if it cannot be cancelled.

Oh, right.

> I guess we should say this more explicitly.
> 
[...]
> > > +Encoding parameter changes
> > > +--------------------------
> > > +
> > > +The client is allowed to use :c:func:`VIDIOC_S_CTRL` to change encoder
> > > +parameters at any time. The driver must apply the new setting starting
> > > +at the next frame queued to it.
> > > +
> > > +This specifically means that if the driver maintains a queue of buffers
> > > +to be encoded and at the time of the call to :c:func:`VIDIOC_S_CTRL` not all the
> > > +buffers in the queue are processed yet, the driver must not apply the
> > > +change immediately, but schedule it for when the next buffer queued
> > > +after the :c:func:`VIDIOC_S_CTRL` starts being processed.
> > 
> > Does this mean that hardware that doesn't support changing parameters at
> > runtime at all must stop streaming and restart streaming internally with
> > every parameter change? Or is it acceptable to not allow the controls to
> > be changed during streaming?
> 
> That's a good question. I'd be leaning towards the latter (not allow),
> as to keep kernel code simple, but maybe we could have others
> (especially Pawel) comment on this.

Same here.

[...]
> > > +2. Enumerating formats on OUTPUT queue must only return OUTPUT formats
> > > +   supported for the CAPTURE format currently set.
> > > +
> > > +3. Setting/changing format on OUTPUT queue does not change formats
> > > +   available on CAPTURE queue. An attempt to set OUTPUT format that
> > > +   is not supported for the currently selected CAPTURE format must
> > > +   result in an error (-EINVAL) from :c:func:`VIDIOC_S_FMT`.
> > 
> > Same as for decoding, is this limited to pixel format? Why isn't the
> > pixel format corrected to a supported choice? What about
> > width/height/colorimetry?
> 
> Width/height/colorimetry(Do you mean color space?) is a part of
> v4l2_pix_format(_mplane). I believe that's what this point was about.

Yes. My question was more about whether this should return -EINVAL or
whether TRY_FMT/S_FMT should change the parameters to valid values.

> I'd say that we should have 1 master queue, which would enforce the
> constraints and the 2 points above mark the OUTPUT queue as such. This
> way we avoid the "negotiation" hell as I mentioned above and we can be
> sure that the driver commits to some format on given queue, e.g.
> 
> S_FMT(OUTPUT, o_0)
> o_1 = G_FMT(OUTPUT)
> S_FMT(CAPTURE, c_0)
> c_1 = G_FMT(CAPTURE)
> 
> At this point we can be sure that OUTPUT queue will operate with
> exactly format o_1 and CAPTURE queue with exactly c_1.

Agreed.

regards
Philipp
