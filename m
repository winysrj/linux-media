Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f65.google.com ([209.85.161.65]:41703 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726971AbeISJ5X (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Sep 2018 05:57:23 -0400
Received: by mail-yw1-f65.google.com with SMTP id q129-v6so1754687ywg.8
        for <linux-media@vger.kernel.org>; Tue, 18 Sep 2018 21:21:22 -0700 (PDT)
Received: from mail-yw1-f43.google.com (mail-yw1-f43.google.com. [209.85.161.43])
        by smtp.gmail.com with ESMTPSA id x184-v6sm4689905ywx.75.2018.09.18.21.21.20
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Sep 2018 21:21:20 -0700 (PDT)
Received: by mail-yw1-f43.google.com with SMTP id n21-v6so1757497ywh.5
        for <linux-media@vger.kernel.org>; Tue, 18 Sep 2018 21:21:20 -0700 (PDT)
MIME-Version: 1.0
References: <20180905220011.16612-1-ezequiel@collabora.com>
 <20180905220011.16612-6-ezequiel@collabora.com> <718d8a73-008a-a610-d090-91cc54a992ad@xs4all.nl>
 <710d4e77de63b46e6ffd440c9c98ca9af133117f.camel@collabora.com> <928a021c1e402f99eadd20e00aa5ec0cc218edbd.camel@paulk.fr>
In-Reply-To: <928a021c1e402f99eadd20e00aa5ec0cc218edbd.camel@paulk.fr>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 19 Sep 2018 13:21:08 +0900
Message-ID: <CAAFQd5BieqODJWO0wzHZ_zikU+v8JdiJ2zYu=WPHmZKzJ1EELQ@mail.gmail.com>
Subject: Re: [PATCH v5 5/6] media: Add controls for JPEG quantization tables
To: contact@paulk.fr
Cc: Ezequiel Garcia <ezequiel@collabora.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        devicetree@vger.kernel.org,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, myy@miouyouyou.fr,
        Shunqian Zheng <zhengsq@rock-chips.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Sep 16, 2018 at 1:48 AM Paul Kocialkowski <contact@paulk.fr> wrote:
>
> Hi,
>
> On Mon, 2018-09-10 at 10:25 -0300, Ezequiel Garcia wrote:
> > Hi Hans,
> >
> > Thanks for the review.
> >
> > On Mon, 2018-09-10 at 14:42 +0200, Hans Verkuil wrote:
> > > On 09/06/2018 12:00 AM, Ezequiel Garcia wrote:
> > > > From: Shunqian Zheng <zhengsq@rock-chips.com>
> > > >
> > > > Add V4L2_CID_JPEG_QUANTIZATION compound control to allow userspace
> > > > configure the JPEG quantization tables.
> > > >
> > > > Signed-off-by: Shunqian Zheng <zhengsq@rock-chips.com>
> > > > Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> > > > ---
> > > >  .../media/uapi/v4l/extended-controls.rst      | 31 +++++++++++++++++++
> > > >  .../media/videodev2.h.rst.exceptions          |  1 +
> > > >  drivers/media/v4l2-core/v4l2-ctrls.c          | 10 ++++++
> > > >  include/uapi/linux/v4l2-controls.h            | 12 +++++++
> > > >  include/uapi/linux/videodev2.h                |  1 +
> > > >  5 files changed, 55 insertions(+)
> > > >
> > > > diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
> > > > index 9f7312bf3365..1335d27d30f3 100644
> > > > --- a/Documentation/media/uapi/v4l/extended-controls.rst
> > > > +++ b/Documentation/media/uapi/v4l/extended-controls.rst
> > > > @@ -3354,7 +3354,38 @@ JPEG Control IDs
> > > >      Specify which JPEG markers are included in compressed stream. This
> > > >      control is valid only for encoders.
> > > >
> > > > +.. _jpeg-quant-tables-control:
> > > >
> > > > +``V4L2_CID_JPEG_QUANTIZATION (struct)``
> > > > +    Specifies the luma and chroma quantization matrices for encoding
> > > > +    or decoding a V4L2_PIX_FMT_JPEG_RAW format buffer. The :ref:`itu-t81`
> > > > +    specification allows 8-bit quantization coefficients for
> > > > +    baseline profile images, and 8-bit or 16-bit for extended profile
> > > > +    images. Supporting or not 16-bit precision coefficients is driver-specific.
> > > > +    Coefficients must be set in JPEG zigzag scan order.
> > > > +
> > > > +
> > > > +.. c:type:: struct v4l2_ctrl_jpeg_quantization
> > > > +
> > > > +.. cssclass:: longtable
> > > > +
> > > > +.. flat-table:: struct v4l2_ctrl_jpeg_quantization
> > > > +    :header-rows:  0
> > > > +    :stub-columns: 0
> > > > +    :widths:       1 1 2
> > > > +
> > > > +    * - __u8
> > > > +      - ``precision``
> > > > +      - Specifies the coefficient precision. User shall set 0
> > > > +        for 8-bit, and 1 for 16-bit.
> > >
> > > So does specifying 1 here switch the HW encoder to use extended profile?
> > > What if the HW only supports baseline? The rockchip driver doesn't appear
> > > to check the precision field at all...
> > >
> >
> > The driver is missing to check that, when the user sets this control.
> >
> > > I think this needs a bit more thought.
> > >
> > > I am not at all sure that this is the right place for the precision field.
> > > This is really about JPEG profiles, so I would kind of expect a JPEG PROFILE
> > > control (just like other codec profiles), or possibly a new pixelformat for
> > > extended profiles.
> > >
> > > And based on that the driver would interpret these matrix values as 8 or
> > > 16 bits.
> > >
> >
> > Right, the JPEG profile control is definitely needed. I haven't add it because
> > it wouldn't be used, since this VPU can only do baseline.
>
> Well, I suppose it would still be relevant that you add it for the
> encoder and only report baseline there.
>
> > However, the problem is that some JPEGs in the wild have with 8-bit data and
> > 16-bit quantization coefficients, as per [1] and [2]:
> >
> > [1] https://github.com/martinhath/jpeg-rust/issues/1
> > [2] https://github.com/libjpeg-turbo/libjpeg-turbo/pull/90
> >
> > So, in order to support decoding of these images, I've added the precision
> > field to the quantization control. The user would be able to set a baseline
> > or extended profile thru a (future) profile control, and if 16-bit
> > tables are found, and if the hardware supports them, the driver
> > would be able to support them.
> >
> > Another option, which might be even better, is have explicit baseline
> > and extended quantization tables controls, e.g.: V4L2_CID_JPEG_QUANT
> > and V4L2_CID_JPEG_EXT_QUANT.
>
> I think this makes more sense than a common structure with an indication
> bit on how to interpret the data.
>
> However, it seems problematic that userspace can't figure out whether
> 16-bit quant tables are supported with a baseline profile and just has
> to try and see.
>
> Hans, do you think this is an acceptable approach or should we rather
> stick to the standard here, at the cost of not supporting these pictures
> that were encoded with this common abuse of the standard?

Perhaps we just need a control called V4L2_CID_JPEG_QUANT_PRECISION,
where drivers can set the min/max (e.g. min = 8, max = 16, step = 8)
to the range they support and user space can select the precision it
wants, if the hardware gives a choice?

Best regards,
Tomasz
