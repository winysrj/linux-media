Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:32982 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756287Ab0I0Qzf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Sep 2010 12:55:35 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [RFC/PATCH 2/9] v4l: Group media bus pixel codes by types and sort them alphabetically
Date: Mon, 27 Sep 2010 18:55:44 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	sakari.ailus@maxwell.research.nokia.com
References: <1285517612-20230-1-git-send-email-laurent.pinchart@ideasonboard.com> <1285517612-20230-3-git-send-email-laurent.pinchart@ideasonboard.com> <Pine.LNX.4.64.1009271028160.16377@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1009271028160.16377@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009271855.45327.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Guennadi,

On Monday 27 September 2010 10:31:02 Guennadi Liakhovetski wrote:
> On Sun, 26 Sep 2010, Laurent Pinchart wrote:
> > Adding new pixel codes at the end of the enumeration will soon create a
> > mess, so sort the pixel codes by type and then sort them alphabetically.
> > 
> > As the codes are part of the kernel ABI their value can't change when a
> > new code is inserted in the enumeration, so they are given an explicit
> > numerical value. When inserting a new pixel code developers must use and
> > update the V4L2_MBUS_FMT_LAST value.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> >  include/linux/v4l2-mediabus.h |   54
> >  ++++++++++++++++++++++++---------------- 1 files changed, 32
> >  insertions(+), 22 deletions(-)
> > 
> > diff --git a/include/linux/v4l2-mediabus.h
> > b/include/linux/v4l2-mediabus.h index 127512a..bc637a5 100644
> > --- a/include/linux/v4l2-mediabus.h
> > +++ b/include/linux/v4l2-mediabus.h
> > @@ -24,31 +24,41 @@
> > 
> >   * transferred first, "BE" means that the most significant bits are
> >   transferred * first, and "PADHI" and "PADLO" define which bits - low
> >   or high, in the * incomplete high byte, are filled with padding bits.
> > 
> > + *
> > + * The pixel codes are grouped by types and (mostly) sorted
> > alphabetically. As
> 
> Why mostly? Wouldn't it make it easier for future additions if we sorted
> them strictly from the beginning?

I knew someone would raise that issue :-)

A pure alphebetical order would be a bit confusing. YUYV10 would come before 
YUYV8 for instance, while it should come after. We can say the list needs to 
be sorted according to general numerical value to solve this.

Another problem is the presence of optional specifiers. The following formats

V4L2_MBUS_FMT_SBGGR10_1X8
V4L2_MBUS_FMT_SBGGR10_1X10
V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE
V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE
V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE
V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_LE
V4L2_MBUS_FMT_SBGGR10_DPCM8_1X8

should instead be sorted this way

V4L2_MBUS_FMT_SBGGR10_1X8
V4L2_MBUS_FMT_SBGGR10_DPCM8_1X8
V4L2_MBUS_FMT_SBGGR10_1X10
V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE
V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE
V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE
V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_LE

Omitted optional components should come first in the sort order. If we 
consider that SBGGR10_DPCM8 is a format on its own instead of a format and a 
specifier, an alphabetical sort order will work. There could be other optional 
specifiers though.

What's your opinion ?

-- 
Regards,

Laurent Pinchart
