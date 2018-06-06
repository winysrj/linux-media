Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:46291 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932395AbeFFJkM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Jun 2018 05:40:12 -0400
Message-ID: <1528278003.3438.3.camel@pengutronix.de>
Subject: Re: [RFC PATCH 2/2] media: docs-rst: Add encoder UAPI specification
 to Codec Interfaces
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Tomasz Figa <tfiga@chromium.org>
Cc: Pawel Osciak <posciak@chromium.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
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
Date: Wed, 06 Jun 2018 11:40:03 +0200
In-Reply-To: <CAAFQd5DqHj65AdzfYmvHWkqHnZntiiA2AhAfgHbLA3AuWvsOTQ@mail.gmail.com>
References: <20180605103328.176255-1-tfiga@chromium.org>
         <20180605103328.176255-3-tfiga@chromium.org>
         <1528199628.4074.15.camel@pengutronix.de>
         <CAAFQd5DYu+Oehr1UUvvdmWk7toO0i_=NFgvZcAKQ8ZURKy51fA@mail.gmail.com>
         <1528208578.4074.19.camel@pengutronix.de>
         <CAAFQd5DqHj65AdzfYmvHWkqHnZntiiA2AhAfgHbLA3AuWvsOTQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2018-06-06 at 18:17 +0900, Tomasz Figa wrote:
> On Tue, Jun 5, 2018 at 11:23 PM Philipp Zabel <p.zabel@pengutronix.de> wrote:
> > 
> > On Tue, 2018-06-05 at 21:31 +0900, Tomasz Figa wrote:
> > [...]
> > > +Initialization
> > > > > +--------------
> > > > > +
> > > > > +1. (optional) Enumerate supported formats and resolutions. See
> > > > > +   capability enumeration.
> > > > > +
> > > > > +2. Set a coded format on the CAPTURE queue via :c:func:`VIDIOC_S_FMT`
> > > > > +
> > > > > +   a. Required fields:
> > > > > +
> > > > > +      i.  type = CAPTURE
> > > > > +
> > > > > +      ii. fmt.pix_mp.pixelformat set to a coded format to be produced
> > > > > +
> > > > > +   b. Return values:
> > > > > +
> > > > > +      i.  EINVAL: unsupported format.
> > > > > +
> > > > > +      ii. Others: per spec
> > > > > +
> > > > > +   c. Return fields:
> > > > > +
> > > > > +      i. fmt.pix_mp.width, fmt.pix_mp.height should be 0.
> > > > > +
> > > > > +   .. note::
> > > > > +
> > > > > +      After a coded format is set, the set of raw formats
> > > > > +      supported as source on the OUTPUT queue may change.
> > > > 
> > > > So setting CAPTURE potentially also changes OUTPUT format?
> > > 
> > > Yes, but at this point userspace hasn't yet set the desired format.
> > > 
> > > > If the encoded stream supports colorimetry information, should that
> > > > information be taken from the CAPTURE queue?
> > > 
> > > What's colorimetry? Is it something that is included in
> > > v4l2_pix_format(_mplane)? Is it something that can vary between raw
> > > input and encoded output?
> > 
> > FTR, yes, I meant the colorspace, ycbcr_enc, quantization, and xfer_func
> > fields of the v4l2_pix_format(_mplane) structs. GStreamer uses the term
> > "colorimetry" to pull these fields together into a single parameter.
> > 
> > The codecs usually don't care at all about this information, except some
> > streams (such as h.264 in the VUI parameters section of the SPS header)
> > may optionally contain a representation of these fields, so it may be
> > desirable to let encoders write the configured colorimetry or to let
> > decoders return the detected colorimetry via G_FMT(CAP) after a source
> > change event.
> > 
> > I think it could be useful to enforce the same colorimetry on CAPTURE
> > and OUTPUT queue if the hardware doesn't do any colorspace conversion.
> 
> After thinking a bit more on this, I guess it wouldn't overly
> complicate things if we require that the values from OUTPUT queue are
> copied to CAPTURE queue, if the stream doesn't include such
> information or the hardware just can't parse them.

And for encoders it would be copied from CAPTURE queue to OUTPUT queue?

> Also, userspace
> that can't parse them wouldn't have to do anything, as the colorspace
> default on OUTPUT would be V4L2_COLORSPACE_DEFAULT and if hardware
> can't parse it either, it would just be propagated to CAPTURE.

I wonder if this wouldn't change the meaning of V4L2_COLORSPACE_DEFAULT?
Documentation/media/uapi/v4l/colorspaces-defs.rst states:

      - The default colorspace. This can be used by applications to let
        the driver fill in the colorspace.

This sounds to me like it is intended to be used by the application
only, like V4L2_FIELD_ANY. If we let decoders return
V4L2_COLORSPACE_DEFAULT on the CAPTURE queue to indicate they have no
idea about colorspace, it should be mentioned explicitly and maybe
clarify in colorspaces-defs.rst as well.

[...]
> > > > > +Encoding parameter changes
> > > > > +--------------------------
> > > > > +
> > > > > +The client is allowed to use :c:func:`VIDIOC_S_CTRL` to change encoder
> > > > > +parameters at any time. The driver must apply the new setting starting
> > > > > +at the next frame queued to it.
> > > > > +
> > > > > +This specifically means that if the driver maintains a queue of buffers
> > > > > +to be encoded and at the time of the call to :c:func:`VIDIOC_S_CTRL` not all the
> > > > > +buffers in the queue are processed yet, the driver must not apply the
> > > > > +change immediately, but schedule it for when the next buffer queued
> > > > > +after the :c:func:`VIDIOC_S_CTRL` starts being processed.
> > > > 
> > > > Does this mean that hardware that doesn't support changing parameters at
> > > > runtime at all must stop streaming and restart streaming internally with
> > > > every parameter change? Or is it acceptable to not allow the controls to
> > > > be changed during streaming?
> > > 
> > > That's a good question. I'd be leaning towards the latter (not allow),
> > > as to keep kernel code simple, but maybe we could have others
> > > (especially Pawel) comment on this.
> > 
> > Same here.
> 
> Same as where? :)

I'd be leaning towards the latter (not allow) as well.

> > [...]
> > > > > +2. Enumerating formats on OUTPUT queue must only return OUTPUT formats
> > > > > +   supported for the CAPTURE format currently set.
> > > > > +
> > > > > +3. Setting/changing format on OUTPUT queue does not change formats
> > > > > +   available on CAPTURE queue. An attempt to set OUTPUT format that
> > > > > +   is not supported for the currently selected CAPTURE format must
> > > > > +   result in an error (-EINVAL) from :c:func:`VIDIOC_S_FMT`.
> > > > 
> > > > Same as for decoding, is this limited to pixel format? Why isn't the
> > > > pixel format corrected to a supported choice? What about
> > > > width/height/colorimetry?
> > > 
> > > Width/height/colorimetry(Do you mean color space?) is a part of
> > > v4l2_pix_format(_mplane). I believe that's what this point was about.
> > 
> > Yes. My question was more about whether this should return -EINVAL or
> > whether TRY_FMT/S_FMT should change the parameters to valid values.
> 
> As per the standard semantics of TRY_/S_FMT, they should adjust the
> format on given queue. We only require that the state on other queue
> is left intact.

This contradicts 3. above, which says S_FMT(OUT) should instead return
-EINVAL if the format doesn't match.

regards
Philipp
