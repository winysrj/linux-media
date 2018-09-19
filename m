Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f67.google.com ([209.85.161.67]:45487 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729926AbeISKEr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Sep 2018 06:04:47 -0400
Received: by mail-yw1-f67.google.com with SMTP id p206-v6so1751867ywg.12
        for <linux-media@vger.kernel.org>; Tue, 18 Sep 2018 21:28:45 -0700 (PDT)
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com. [209.85.219.181])
        by smtp.gmail.com with ESMTPSA id b16-v6sm5582694ywa.33.2018.09.18.21.28.43
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Sep 2018 21:28:44 -0700 (PDT)
Received: by mail-yb1-f181.google.com with SMTP id c4-v6so1840752ybl.6
        for <linux-media@vger.kernel.org>; Tue, 18 Sep 2018 21:28:43 -0700 (PDT)
MIME-Version: 1.0
References: <20180905220011.16612-1-ezequiel@collabora.com>
 <20180905220011.16612-6-ezequiel@collabora.com> <e7126e89d8984eb93216ec75c83ce1fc5afc437d.camel@paulk.fr>
In-Reply-To: <e7126e89d8984eb93216ec75c83ce1fc5afc437d.camel@paulk.fr>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 19 Sep 2018 13:28:31 +0900
Message-ID: <CAAFQd5Bir0uMsaJPHdgQDvcYHpxZ4sUSn10OPpRXcnn-THUx2A@mail.gmail.com>
Subject: Re: [PATCH v5 5/6] media: Add controls for JPEG quantization tables
To: contact@paulk.fr
Cc: Ezequiel Garcia <ezequiel@collabora.com>,
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

On Thu, Sep 13, 2018 at 9:15 PM Paul Kocialkowski <contact@paulk.fr> wrote:
>
> Hi,
>
> On Wed, 2018-09-05 at 19:00 -0300, Ezequiel Garcia wrote:
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
>
> I just had a look at how the Allwinner VPU handles JPEG decoding and it
> seems to require the following information (in addition to
> quantization):

I assume the hardware doesn't have the ability to parse those from the
stream and so they need to be parsed by user space and given to the
driver?

>
> * Horizontal and vertical sampling factors for each Y/U/V component:
>
> The number of components and sampling factors are coded separately in
> the bitstream, but it's probably easier to use the already-existing
> V4L2_CID_JPEG_CHROMA_SUBSAMPLING control for specifying that.
>
> However, this is potentially very much related to the destination
> format. If we decide that this format should match the format resulting
> from decompression, we don't need to specify it through an external
> control. On the other hand, it's possible that the VPU has format
> conversion block integrated in its pipeline so it would also make sense
> to consider the destination format as independent.

+1 for keeping it separate.

>
> * Custom Huffman tables (DC and AC), both for luma and chroma
>
> It seems that there is a default table when no Huffman table is provided
> in the bitstream (I'm not too sure how standard that is, just started
> learning about JPEG). We probably need a specific control for that.

What happens if there is one in the bitstream? Would the hardware pick
it automatically?

I think it might make sense to just have a general control for Huffman
table, which would be always provided by the user space, regardless of
whether it's parsed from the stream or default, so that drivers don't
have to care and could just always use it.

Best regards,
Tomasz
