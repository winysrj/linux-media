Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:33820 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759623Ab0I0QFs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Sep 2010 12:05:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [RFC/PATCH 1/9] v4l: Move the media/v4l2-mediabus.h header to include/linux
Date: Mon, 27 Sep 2010 18:05:55 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	sakari.ailus@maxwell.research.nokia.com
References: <1285517612-20230-1-git-send-email-laurent.pinchart@ideasonboard.com> <1285517612-20230-2-git-send-email-laurent.pinchart@ideasonboard.com> <Pine.LNX.4.64.1009270959100.16377@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1009270959100.16377@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009271805.56330.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Guennadi,

Thanks for the review.

On Monday 27 September 2010 10:20:57 Guennadi Liakhovetski wrote:
> On Sun, 26 Sep 2010, Laurent Pinchart wrote:
> > The header defines the v4l2_mbus_framefmt structure which will be used
> > by the V4L2 subdevs userspace API.
> > 
> > Change the type of the v4l2_mbus_framefmt::code field to __u32, as enum
> > sizes can differ between different ABIs on the same architectures.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> >  include/linux/Kbuild          |    1 +
> >  include/linux/v4l2-mediabus.h |   70
> >  +++++++++++++++++++++++++++++++++++++++++ include/media/soc_mediabus.h 
> >  |    3 +-
> >  include/media/v4l2-mediabus.h |   53 +------------------------------
> 
> Hm, yeah... I guess, you have to move them to make available to the
> user-space...

Yes, that's why.

> >  4 files changed, 73 insertions(+), 54 deletions(-)
> >  create mode 100644 include/linux/v4l2-mediabus.h
> > 
> > diff --git a/include/linux/Kbuild b/include/linux/Kbuild
> > index f836ee4..38127c2 100644
> > --- a/include/linux/Kbuild
> > +++ b/include/linux/Kbuild
> > @@ -369,6 +369,7 @@ header-y += unistd.h
> > 
> >  header-y += usbdevice_fs.h
> >  header-y += utime.h
> >  header-y += utsname.h
> > 
> > +header-y += v4l2-mediabus.h
> > 
> >  header-y += veth.h
> >  header-y += vhost.h
> >  header-y += videodev.h
> > 
> > diff --git a/include/linux/v4l2-mediabus.h
> > b/include/linux/v4l2-mediabus.h new file mode 100644
> > index 0000000..127512a
> > --- /dev/null
> > +++ b/include/linux/v4l2-mediabus.h
> > @@ -0,0 +1,70 @@
> > +/*
> > + * Media Bus API header
> > + *
> > + * Copyright (C) 2009, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + */
> > +
> > +#ifndef __LINUX_V4L2_MEDIABUS_H
> > +#define __LINUX_V4L2_MEDIABUS_H
> > +
> > +#include <linux/types.h>
> > +#include <linux/videodev2.h>
> > +
> > +/*
> > + * These pixel codes uniquely identify data formats on the media bus.
> > Mostly + * they correspond to similarly named V4L2_PIX_FMT_* formats,
> > format 0 is + * reserved, V4L2_MBUS_FMT_FIXED shall be used by
> > host-client pairs, where the + * data format is fixed. Additionally,
> > "2X8" means that one pixel is transferred + * in two 8-bit samples, "BE"
> > or "LE" specify in which order those samples are + * transferred over
> > the bus: "LE" means that the least significant bits are + * transferred
> > first, "BE" means that the most significant bits are transferred + *
> > first, and "PADHI" and "PADLO" define which bits - low or high, in the +
> > * incomplete high byte, are filled with padding bits.
> > + */
> > +enum v4l2_mbus_pixelcode {
> 
> If you now do not want to use this enum in the API, maybe better make it
> unnamed and switch all users to __u32 for consistency? I'm not sure this
> would be an advantage, just something to maybe think about...

I think it makes sense to keep the enumeration type for type checking reasons 
(both in kernel space and user space). Unfortunately it can't be used in the 
kernel <-> user API because of ABI incompatibilities.

-- 
Regards,

Laurent Pinchart
