Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:41603 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754050AbdCaIzW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Mar 2017 04:55:22 -0400
Message-ID: <1490950514.2371.21.camel@pengutronix.de>
Subject: Re: [PATCH] [media] docs-rst: clarify field vs frame height in the
 subdev API
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
Date: Fri, 31 Mar 2017 10:55:14 +0200
In-Reply-To: <1790355.cli1gBmIc5@avalon>
References: <20170330153820.14853-1-p.zabel@pengutronix.de>
         <1790355.cli1gBmIc5@avalon>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Fri, 2017-03-31 at 11:09 +0300, Laurent Pinchart wrote:
> Hi Philipp,
> 
> Thank you for the patch.
> 
> On Thursday 30 Mar 2017 17:38:20 Philipp Zabel wrote:
> > VIDIOC_SUBDEV_G/S_FMT take the field size if V4L2_FIELD_ALTERNATE field
> > order is set, but the VIDIOC_SUBDEV_G/S_SELECTION rectangles still refer
> > to frame size, regardless of the field order setting.
> > VIDIOC_SUBDEV_ENUM_FRAME_SIZES always returns frame sizes as opposed to
> > field sizes.
> > 
> > This was not immediately clear to me when reading the documentation, so
> > this patch adds some clarifications in the relevant places.
> > 
> > Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> >  Documentation/media/uapi/v4l/dev-subdev.rst              | 16 +++++++++----
> >  Documentation/media/uapi/v4l/subdev-formats.rst          |  3 ++-
> >  .../media/uapi/v4l/vidioc-subdev-enum-frame-size.rst     |  4 ++++
> >  .../media/uapi/v4l/vidioc-subdev-g-selection.rst         |  2 ++
> >  4 files changed, 20 insertions(+), 5 deletions(-)
> > 
> > diff --git a/Documentation/media/uapi/v4l/dev-subdev.rst
> > b/Documentation/media/uapi/v4l/dev-subdev.rst index
> > cd28701802086..2f0a41f3796f0 100644
> > --- a/Documentation/media/uapi/v4l/dev-subdev.rst
> > +++ b/Documentation/media/uapi/v4l/dev-subdev.rst
> > @@ -82,7 +82,8 @@ Pad-level Formats
> >  .. note::
> > 
> >      For the purpose of this section, the term *format* means the
> > -    combination of media bus data format, frame width and frame height.
> > +    combination of media bus data format, frame width and frame height,
> > +    unless otherwise noted.
> > 
> >  Image formats are typically negotiated on video capture and output
> >  devices using the format and
> > @@ -120,7 +121,9 @@ can expose pad-level image format configuration to
> > applications. When they do, applications can use the
> > 
> >  :ref:`VIDIOC_SUBDEV_G_FMT <VIDIOC_SUBDEV_G_FMT>` and
> >  :ref:`VIDIOC_SUBDEV_S_FMT <VIDIOC_SUBDEV_G_FMT>` ioctls. to
> > 
> > -negotiate formats on a per-pad basis.
> > +negotiate formats on a per-pad basis. Note that when those ioctls are
> > +called with or return the field order set to ``V4L2_FIELD_ALTERNATE``,
> > +the format contains the field height, which is half the frame height.
> 
> Isn't that also the case for the TOP and BOTTOM field orders ?

Oh, those exist, too. I'll change all occurences to list ALTERNATE, TOP,
and BOTTOM. I hope this is not going to be too verbose for people that
don't have to care about interlacing.

> >  Applications are responsible for configuring coherent parameters on the
> >  whole pipeline and making sure that connected pads have compatible
> > @@ -379,7 +382,10 @@ is supported by the hardware.
> >     pad for further processing.
> > 
> >  2. Sink pad actual crop selection. The sink pad crop defines the crop
> > -   performed to the sink pad format.
> > +   performed to the sink pad format. The crop rectangle always refers to
> > +   the frame size, even if the sink pad format has field order set to
> > +   ``V4L2_FIELD_ALTERNATE`` and the actual processed images are only
> > +   field sized.
> 
> I'm not sure to agree with this. I think all selection rectangle coordinates 
> should be expressed relative to the format of the pad they refer to.

But that's not how I understood Hans yesterday, and it shows that you
were quite on point with your suggestion to extend the docs.

> For sink pad crop rectangles, if the sink pad receives alternate (or
> top or bottom only) fields, the rectangle coordinates should be
> relative to the field size. Similarly, if the source pad produces
> alternate/top/bottom fields, the rectangle coordinates should also be
> relative to the field size.

That's also not how TVP5150 currently implements it. The crop rectangle
is frame sized even though the pad format reports alternating fields,
the same is true for vivid capture, even though that is not using the
subdev selection API.

Personally, I don't care whether the selection rectangles refer to frame
size or to the field size depending on the respective pad's field order
setting, but I'd really like to have it clearly spelled out in the
places this patch modifies.

> If the subdev transforms alternate fields to progressive or interlaced
> frames, then the sink crop rectangle should be relative to the frame
> size.

I'm confused. The sink pad is set to alternate fields in this case,
didn't you just argue that the sink crop/compose rectangles should refer
to field size?

Actually, this is exactly the case I want to handle. The CSI receives
FIELD_ALTERNATE frames from the TVP5150 with BT.656 synchronisation, but
it produces SEQ_TB or SEQ_BT (depending on standard) at its output pad.
If the input pad height is 288 lines for example, the output pad height
is 576 lines (in case of no cropping or scaling), and there's a sink
crop and a sink compose rectangle. Should those refer to the 288 lines
per field, or to the 576 lines per frame?

> The rationale behind this is that a subdev that receives and outputs alternate 
> fields should only care about fields and shouldn't be aware about the full 
> frame size.

regards
Philipp
