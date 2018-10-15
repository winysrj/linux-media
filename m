Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:36352 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbeJOXxi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 Oct 2018 19:53:38 -0400
Message-ID: <1579e9b6bcce59ae43cf92c34e2114ebad45b0e9.camel@collabora.com>
Subject: Re: [PATCH v5 5/6] media: Add controls for JPEG quantization tables
From: Ezequiel Garcia <ezequiel@collabora.com>
To: Paul Kocialkowski <contact@paulk.fr>,
        Tomasz Figa <tfiga@chromium.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        devicetree@vger.kernel.org,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, myy@miouyouyou.fr,
        Shunqian Zheng <zhengsq@rock-chips.com>
Date: Mon, 15 Oct 2018 13:07:35 -0300
In-Reply-To: <2878c8fa36f6e775079f53ba79518a53e1ea6bc5.camel@paulk.fr>
References: <20180905220011.16612-1-ezequiel@collabora.com>
         <20180905220011.16612-6-ezequiel@collabora.com>
         <e7126e89d8984eb93216ec75c83ce1fc5afc437d.camel@paulk.fr>
         <CAAFQd5Bir0uMsaJPHdgQDvcYHpxZ4sUSn10OPpRXcnn-THUx2A@mail.gmail.com>
         <2878c8fa36f6e775079f53ba79518a53e1ea6bc5.camel@paulk.fr>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2018-10-12 at 22:00 +0200, Paul Kocialkowski wrote:
> Hi,
> 
> Le mercredi 19 septembre 2018 à 13:28 +0900, Tomasz Figa a écrit :
> > On Thu, Sep 13, 2018 at 9:15 PM Paul Kocialkowski <contact@paulk.fr> wrote:
> > > Hi,
> > > 
> > > On Wed, 2018-09-05 at 19:00 -0300, Ezequiel Garcia wrote:
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
> > > 
> > > I just had a look at how the Allwinner VPU handles JPEG decoding and it
> > > seems to require the following information (in addition to
> > > quantization):
> > 
> > I assume the hardware doesn't have the ability to parse those from the
> > stream and so they need to be parsed by user space and given to the
> > driver?
> 
> That's correct, we are also dealing with a stateless decoder here. It's
> actually the same hardware engine that's used for MPEG2 decoding, only
> configured differently.
> 
> So we will need to introduce a pixfmt for compressed JPEG data without
> headers, reuse JPEG controls that apply and perhaps introduce new ones
> too if needed.
> 
> I am also wondering about how MJPEG support should fit into this. As
> far as I understood, it shouldn't be very different from JPEG so we
> might want to have common controls for both.
> 

We've recently discussed this and we were proposing to just drop
MJPEG and stick to JPEG. The reason is that MJPEG is not clearly
defined. Note that others treat MJPEG and JPEG as aliases.

See "Re: [RFC] V4L2_PIX_FMT_MJPEG vs V4L2_PIX_FMT_JPEG".

Also, I'll be adding support for spec-compliant JPEG frames
in rockchip JPEG encoder. This will allow to use the driver
with already available userspace. IOW, we don't absolutely
need a new pixelformat for encoders.

Decoders, on the other side, would be a different story,
as parsing headers in the kernel can raise some safety
concerns.

Regards,
Ezequiel
