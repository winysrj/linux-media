Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:38227 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932487AbeAHPcu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 8 Jan 2018 10:32:50 -0500
Received: by mail-lf0-f68.google.com with SMTP id d19so4212146lfj.5
        for <linux-media@vger.kernel.org>; Mon, 08 Jan 2018 07:32:49 -0800 (PST)
Date: Mon, 8 Jan 2018 16:32:47 +0100
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Archit Taneja <architt@codeaurora.org>,
        Sean Paul <seanpaul@chromium.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] v4l: doc: clarify v4l2_mbus_fmt height definition
Message-ID: <20180108153247.GA23075@bigcity.dyn.berto.se>
References: <1515422746-5971-1-git-send-email-kieran.bingham@ideasonboard.com>
 <20180108151353.zn2ee2tbdq2yragp@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180108151353.zn2ee2tbdq2yragp@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Thanks for your patch.

On 2018-01-08 17:13:53 +0200, Sakari Ailus wrote:
> Hi Kieran,
> 
> On Mon, Jan 08, 2018 at 02:45:49PM +0000, Kieran Bingham wrote:
> > The v4l2_mbus_fmt width and height corresponds directly with the
> > v4l2_pix_format definitions, yet the differences in documentation make
> > it ambiguous what to do in the event of field heights.
> > 
> > Clarify this by referencing the v4l2_pix_format which is explicit on the
> > matter, and by matching the terminology of 'image height' rather than
> > the misleading 'frame height'.

Nice that this relationship is documented as it have contributed to some 
confusion on my side in the past!

> > 
> > Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> > ---
> >  Documentation/media/uapi/v4l/subdev-formats.rst | 6 ++++--
> >  include/uapi/linux/v4l2-mediabus.h              | 4 ++--
> >  2 files changed, 6 insertions(+), 4 deletions(-)
> > 
> > diff --git a/Documentation/media/uapi/v4l/subdev-formats.rst b/Documentation/media/uapi/v4l/subdev-formats.rst
> > index b1eea44550e1..a2a00202b430 100644
> > --- a/Documentation/media/uapi/v4l/subdev-formats.rst
> > +++ b/Documentation/media/uapi/v4l/subdev-formats.rst
> > @@ -16,10 +16,12 @@ Media Bus Formats
> >  
> >      * - __u32
> >        - ``width``
> > -      - Image width, in pixels.
> > +      - Image width in pixels. See struct
> > +	:c:type:`v4l2_pix_format`.
> >      * - __u32
> >        - ``height``
> > -      - Image height, in pixels.
> > +      - Image height in pixels. See struct
> > +	:c:type:`v4l2_pix_format`.
> >      * - __u32
> >        - ``code``
> >        - Format code, from enum
> > diff --git a/include/uapi/linux/v4l2-mediabus.h b/include/uapi/linux/v4l2-mediabus.h
> > index 6e20de63ec59..6b34108d0338 100644
> > --- a/include/uapi/linux/v4l2-mediabus.h
> > +++ b/include/uapi/linux/v4l2-mediabus.h
> > @@ -18,8 +18,8 @@
> >  
> >  /**
> >   * struct v4l2_mbus_framefmt - frame format on the media bus
> > - * @width:	frame width
> > - * @height:	frame height
> > + * @width:	image width
> > + * @height:	image height (see struct v4l2_pix_format)
> 
> Hmm. This is the media bus format and it has no direct relation to
> v4l2_pix_format. So no, I can't see what would be the point in making such
> a reference.

Well we have functions like v4l2_fill_pix_format() that do

    pix_fmt->width = mbus_fmt->width;
    pix_fmt->height = mbus_fmt->height;

So I think there at least is an implicit relation between the two 
structs. The issue I think Kieran is trying to address is in the case of 
TOP, BOTTOM and ALTERNATE field formats. From the v4l2_pix_format 
documentation on the height field:

   "Image height in pixels. If field is one of V4L2_FIELD_TOP, 
   V4L2_FIELD_BOTTOM or V4L2_FIELD_ALTERNATE then height refers to the 
   number of lines in the field, otherwise it refers to the number of 
   lines in the frame (which is twice the field height for interlaced 
   formats)."

But there are no such clear definition of the height field for 
v4l2_mbus_framefmt. This have cased some confusion for us which would be 
nice to clarify. I think it would be a good thing to add to the 
documentation if the height in v4l2_mbus_framefmt should describe the 
height of a frame or field. And if it should represent the frame height 
then v4l2_fill_pix_format() and v4l2_fill_mbus_format() should be 
updated to support converting from the two different formats for height.

> 
> >   * @code:	data format code (from enum v4l2_mbus_pixelcode)
> >   * @field:	used interlacing type (from enum v4l2_field)
> >   * @colorspace:	colorspace of the data (from enum v4l2_colorspace)
> 
> -- 
> Regards,
> 
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi

-- 
Regards,
Niklas Söderlund
