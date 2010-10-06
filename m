Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:38243 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758320Ab0JFGX2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Oct 2010 02:23:28 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH/RFC v3 01/11] v4l: Move the media/v4l2-mediabus.h header to include/linux
Date: Wed, 6 Oct 2010 08:23:34 +0200
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	linux-media@vger.kernel.org
References: <1286288714-16506-1-git-send-email-laurent.pinchart@ideasonboard.com> <4CAB39AB.2070806@maxwell.research.nokia.com> <Pine.LNX.4.64.1010051728360.31708@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1010051728360.31708@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010060823.35991.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Guennadi,

On Tuesday 05 October 2010 17:30:21 Guennadi Liakhovetski wrote:
> On Tue, 5 Oct 2010, Sakari Ailus wrote:
> > Laurent Pinchart wrote:
> > > The header defines the v4l2_mbus_framefmt structure which will be used
> > > by the V4L2 subdevs userspace API.
> > > 
> > > Change the type of the v4l2_mbus_framefmt::code field to __u32, as enum
> > > sizes can differ between different ABIs on the same architectures.
> > > 
> > > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[snip]

> > > +/**
> > > + * struct v4l2_mbus_framefmt - frame format on the media bus
> > > + * @width:	frame width
> > > + * @height:	frame height
> > > + * @code:	data format code
> > > + * @field:	used interlacing type
> > > + * @colorspace:	colorspace of the data
> > > + */
> > > +struct v4l2_mbus_framefmt {
> > > +	__u32				width;
> > > +	__u32				height;
> > > +	__u32				code;
> > > +	enum v4l2_field			field;
> > > +	enum v4l2_colorspace		colorspace;
> > > +};
> > 
> > I think this struct would benefit from some reserved fields since it's
> > part of the user space interface.
> 
> IIUC, this struct is not going to be used in ioctl()s, that's what struct
> v4l2_subdev_mbus_code_enum is for. But in this case - why don't we make
> the "code" field above of type "enum v4l2_mbus_pixelcode"?

The v4l2_mbus_framefmt structure isn't used directly as an ioctl argument, but 
it's embedded in the v4l2_subdev_format structure, used as an ioctl argument, 
so its size matters.

The v4l2_subdev_format structure has reserved fields right after the 
v4l2_mbus_framefmt member so there's some room for expansion. As for the 
enums, I've reused the ones already in use in the V4L2 API, but I can replace 
them with __u32.

-- 
Regards,

Laurent Pinchart
