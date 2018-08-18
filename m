Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:59050 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbeHRV35 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 18 Aug 2018 17:29:57 -0400
Message-ID: <fe36727b86c1318b850e6d581b1bf337b0e3e15a.camel@collabora.com>
Subject: Re: [PATCH v2 5/6] media: Add controls for jpeg quantization tables
From: Ezequiel Garcia <ezequiel@collabora.com>
To: Tomasz Figa <tfiga@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Shunqian Zheng <zhengsq@rock-chips.com>
Date: Sat, 18 Aug 2018 15:21:11 -0300
In-Reply-To: <CAAFQd5C4jTfdB5Zmk6LQwTOBB2hs14ensZ+J-ZdTcQzzBNKn0A@mail.gmail.com>
References: <20180802200010.24365-1-ezequiel@collabora.com>
         <20180802200010.24365-6-ezequiel@collabora.com>
         <CAAFQd5C4jTfdB5Zmk6LQwTOBB2hs14ensZ+J-ZdTcQzzBNKn0A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2018-08-17 at 11:10 +0900, Tomasz Figa wrote:
> Hi Ezequiel,
> 
> On Fri, Aug 3, 2018 at 5:00 AM Ezequiel Garcia <ezequiel@collabora.com> wrote:
> > 
> > From: Shunqian Zheng <zhengsq@rock-chips.com>
> > 
> > Add V4L2_CID_JPEG_LUMA/CHROMA_QUANTIZATION controls to allow userspace
> > configure the JPEG quantization tables.
> > 
> > Signed-off-by: Shunqian Zheng <zhengsq@rock-chips.com>
> > Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> > ---
> >  Documentation/media/uapi/v4l/extended-controls.rst | 9 +++++++++
> >  drivers/media/v4l2-core/v4l2-ctrls.c               | 4 ++++
> >  include/uapi/linux/v4l2-controls.h                 | 3 +++
> >  3 files changed, 16 insertions(+)
> 
> Thanks for this series and sorry for being late with review. Please
> see my comments inline.
> 
> > 
> > diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
> > index 9f7312bf3365..80e26f81900b 100644
> > --- a/Documentation/media/uapi/v4l/extended-controls.rst
> > +++ b/Documentation/media/uapi/v4l/extended-controls.rst
> > @@ -3354,6 +3354,15 @@ JPEG Control IDs
> >      Specify which JPEG markers are included in compressed stream. This
> >      control is valid only for encoders.
> > 
> > +.. _jpeg-quant-tables-control:
> > +
> > +``V4L2_CID_JPEG_LUMA_QUANTIZATION (__u8 matrix)``
> > +    Sets the luma quantization table to be used for encoding
> > +    or decoding a V4L2_PIX_FMT_JPEG_RAW format buffer. This table is
> > +    expected to be in JPEG zigzag order, as per the JPEG specification.
> 
> Should we also specify this to be 8x8?
> 

Yes, could be.

> > +
> > +``V4L2_CID_JPEG_CHROMA_QUANTIZATION (__u8 matrix)``
> > +    Sets the chroma quantization table.
> > 
> 
> nit: I guess we aff something like
> 
> "See also V4L2_CID_JPEG_LUMA_QUANTIZATION for details."
> 
> to avoid repeating the V4L2_PIX_FMT_JPEG_RAW and zigzag order bits? Or
> maybe just repeating is better?
> 

In spec documentation I usually find it's clearer for readers to see
stuff repeated. Better to have an excess of clarity :-)

> > 
> >  .. flat-table::
> > diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> > index 599c1cbff3b9..5c62c3101851 100644
> > --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> > +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> > @@ -999,6 +999,8 @@ const char *v4l2_ctrl_get_name(u32 id)
> >         case V4L2_CID_JPEG_RESTART_INTERVAL:    return "Restart Interval";
> >         case V4L2_CID_JPEG_COMPRESSION_QUALITY: return "Compression Quality";
> >         case V4L2_CID_JPEG_ACTIVE_MARKER:       return "Active Markers";
> > +       case V4L2_CID_JPEG_LUMA_QUANTIZATION:   return "Luminance Quantization Matrix";
> > +       case V4L2_CID_JPEG_CHROMA_QUANTIZATION: return "Chrominance Quantization Matrix";
> > 
> >         /* Image source controls */
> >         /* Keep the order of the 'case's the same as in v4l2-controls.h! */
> > @@ -1284,6 +1286,8 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
> >                 *flags |= V4L2_CTRL_FLAG_READ_ONLY;
> >                 break;
> >         case V4L2_CID_DETECT_MD_REGION_GRID:
> > +       case V4L2_CID_JPEG_LUMA_QUANTIZATION:
> > +       case V4L2_CID_JPEG_CHROMA_QUANTIZATION:
> 
> It looks like with this setup, the driver has to explicitly set dims
> to { 8, 8 } and min/max to 0/255.
> 
> At least for min and max, we could set them here. For dims, i don't
> see it handled in generic code, so I guess we can leave it to the
> driver now and add move into generic code, if another driver shows up.
> Hans, what do you think?
> 

Since Hans agrees to move this to the core, let's give it a try.
I'll address this in v3.

Thanks for the feedback!
Eze
