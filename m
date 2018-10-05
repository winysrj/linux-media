Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:37714 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728003AbeJESvv (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2018 14:51:51 -0400
Message-ID: <90ef806ecfab6e93dc08e4acdce11cc2e15df637.camel@collabora.com>
Subject: Re: [PATCH v7 4/6] media: Add JPEG_RAW format
From: Ezequiel Garcia <ezequiel@collabora.com>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Miouyouyou <myy@miouyouyou.fr>,
        Shunqian Zheng <zhengsq@rock-chips.com>
Date: Fri, 05 Oct 2018 08:53:14 -0300
In-Reply-To: <20181005080924.78a1654b@coco.lan>
References: <20181005001226.12789-1-ezequiel@collabora.com>
         <20181005001226.12789-5-ezequiel@collabora.com>
         <20181005080924.78a1654b@coco.lan>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2018-10-05 at 08:09 -0300, Mauro Carvalho Chehab wrote:
> Em Thu,  4 Oct 2018 21:12:24 -0300
> Ezequiel Garcia <ezequiel@collabora.com> escreveu:
> 
> > From: Shunqian Zheng <zhengsq@rock-chips.com>
> > 
> > Add V4L2_PIX_FMT_JPEG_RAW format that does not contain
> > JPEG header in the output frame.
> > 
> > Signed-off-by: Shunqian Zheng <zhengsq@rock-chips.com>
> > Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> > ---
> >  Documentation/media/uapi/v4l/pixfmt-compressed.rst | 9 +++++++++
> >  drivers/media/v4l2-core/v4l2-ioctl.c               | 1 +
> >  include/uapi/linux/videodev2.h                     | 1 +
> >  3 files changed, 11 insertions(+)
> > 
> > diff --git a/Documentation/media/uapi/v4l/pixfmt-compressed.rst b/Documentation/media/uapi/v4l/pixfmt-compressed.rst
> > index ba0f6c49d9bf..ad73076276ec 100644
> > --- a/Documentation/media/uapi/v4l/pixfmt-compressed.rst
> > +++ b/Documentation/media/uapi/v4l/pixfmt-compressed.rst
> > @@ -23,6 +23,15 @@ Compressed Formats
> >        - 'JPEG'
> >        - TBD. See also :ref:`VIDIOC_G_JPEGCOMP <VIDIOC_G_JPEGCOMP>`,
> >  	:ref:`VIDIOC_S_JPEGCOMP <VIDIOC_G_JPEGCOMP>`.
> > +    * .. _V4L2-PIX-FMT-JPEG-RAW:
> > +
> > +      - ``V4L2_PIX_FMT_JPEG_RAW``
> > +      - 'Raw JPEG'
> > +      - Raw JPEG bitstream, containing a compressed payload. This format
> > +        contains an image scan, i.e. without any metadata or headers.
> > +        The user is expected to set the needed metadata such as
> > +        quantization and entropy encoding tables, via ``V4L2_CID_JPEG``
> > +        controls, see :ref:`jpeg-control-id`.
> 
> IMO, it is not very clear when someone should use V4L2_CID_JPEG or
> V4L2_PIX_FMT_JPEG_RAW. Some drivers do add a JPEG header internally.
> 

For device drivers, if the hardware can parse JPEG frames, then
V4L2_PIX_FMT_JPEG should be used. Otherwise, if the hardware can
only accept a parsed JPEG (i.e. payload and tables), then
only V4L2_PIX_FMT_JPEG_RAW should be supported.

Parsing headers in the driver is discouraged by the stateful codec
API specification.

With the Request API in place, and the stateful and stateless specs,
device driver writers should be now using the right model for each
type of hardware.

There are exceptions, though. If the hardware handles full JPEG frames,
but requires some extra parsing on the OS side, then the driver
should be using V4L2_PIX_FMT_JPEG, and doing some extra parsing.
For instance, mtk-jpeg seems to work like this.

> Also, if we're now starting to accept headerless JPEG images, you should
> very patch libv4l as well, in order to accept this new format.
> 

Right.

Thanks,
Eze
