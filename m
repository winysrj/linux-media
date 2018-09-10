Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:57514 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727970AbeIJST1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Sep 2018 14:19:27 -0400
Message-ID: <710d4e77de63b46e6ffd440c9c98ca9af133117f.camel@collabora.com>
Subject: Re: [PATCH v5 5/6] media: Add controls for JPEG quantization tables
From: Ezequiel Garcia <ezequiel@collabora.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-rockchip@lists.infradead.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Miouyouyou <myy@miouyouyou.fr>,
        Shunqian Zheng <zhengsq@rock-chips.com>
Date: Mon, 10 Sep 2018 10:25:10 -0300
In-Reply-To: <718d8a73-008a-a610-d090-91cc54a992ad@xs4all.nl>
References: <20180905220011.16612-1-ezequiel@collabora.com>
         <20180905220011.16612-6-ezequiel@collabora.com>
         <718d8a73-008a-a610-d090-91cc54a992ad@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the review.

On Mon, 2018-09-10 at 14:42 +0200, Hans Verkuil wrote:
> On 09/06/2018 12:00 AM, Ezequiel Garcia wrote:
> > From: Shunqian Zheng <zhengsq@rock-chips.com>
> > 
> > Add V4L2_CID_JPEG_QUANTIZATION compound control to allow userspace
> > configure the JPEG quantization tables.
> > 
> > Signed-off-by: Shunqian Zheng <zhengsq@rock-chips.com>
> > Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> > ---
> >  .../media/uapi/v4l/extended-controls.rst      | 31 +++++++++++++++++++
> >  .../media/videodev2.h.rst.exceptions          |  1 +
> >  drivers/media/v4l2-core/v4l2-ctrls.c          | 10 ++++++
> >  include/uapi/linux/v4l2-controls.h            | 12 +++++++
> >  include/uapi/linux/videodev2.h                |  1 +
> >  5 files changed, 55 insertions(+)
> > 
> > diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
> > index 9f7312bf3365..1335d27d30f3 100644
> > --- a/Documentation/media/uapi/v4l/extended-controls.rst
> > +++ b/Documentation/media/uapi/v4l/extended-controls.rst
> > @@ -3354,7 +3354,38 @@ JPEG Control IDs
> >      Specify which JPEG markers are included in compressed stream. This
> >      control is valid only for encoders.
> >  
> > +.. _jpeg-quant-tables-control:
> >  
> > +``V4L2_CID_JPEG_QUANTIZATION (struct)``
> > +    Specifies the luma and chroma quantization matrices for encoding
> > +    or decoding a V4L2_PIX_FMT_JPEG_RAW format buffer. The :ref:`itu-t81`
> > +    specification allows 8-bit quantization coefficients for
> > +    baseline profile images, and 8-bit or 16-bit for extended profile
> > +    images. Supporting or not 16-bit precision coefficients is driver-specific.
> > +    Coefficients must be set in JPEG zigzag scan order.
> > +
> > +
> > +.. c:type:: struct v4l2_ctrl_jpeg_quantization
> > +
> > +.. cssclass:: longtable
> > +
> > +.. flat-table:: struct v4l2_ctrl_jpeg_quantization
> > +    :header-rows:  0
> > +    :stub-columns: 0
> > +    :widths:       1 1 2
> > +
> > +    * - __u8
> > +      - ``precision``
> > +      - Specifies the coefficient precision. User shall set 0
> > +        for 8-bit, and 1 for 16-bit.
> 
> So does specifying 1 here switch the HW encoder to use extended profile?
> What if the HW only supports baseline? The rockchip driver doesn't appear
> to check the precision field at all...
> 

The driver is missing to check that, when the user sets this control.

> I think this needs a bit more thought.
> 
> I am not at all sure that this is the right place for the precision field.
> This is really about JPEG profiles, so I would kind of expect a JPEG PROFILE
> control (just like other codec profiles), or possibly a new pixelformat for
> extended profiles.
> 
> And based on that the driver would interpret these matrix values as 8 or
> 16 bits.
> 

Right, the JPEG profile control is definitely needed. I haven't add it because
it wouldn't be used, since this VPU can only do baseline.

However, the problem is that some JPEGs in the wild have with 8-bit data and
16-bit quantization coefficients, as per [1] and [2]:

[1] https://github.com/martinhath/jpeg-rust/issues/1
[2] https://github.com/libjpeg-turbo/libjpeg-turbo/pull/90

So, in order to support decoding of these images, I've added the precision
field to the quantization control. The user would be able to set a baseline
or extended profile thru a (future) profile control, and if 16-bit
tables are found, and if the hardware supports them, the driver
would be able to support them.

Another option, which might be even better, is have explicit baseline
and extended quantization tables controls, e.g.: V4L2_CID_JPEG_QUANT
and V4L2_CID_JPEG_EXT_QUANT.

Thanks,
Ezequiel
