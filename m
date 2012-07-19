Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52948 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab2GSLjH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jul 2012 07:39:07 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Hadli, Manjunath" <manjunath.hadli@ti.com>
Cc: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	LMML <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	"g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
	"Lad, Prabhakar" <prabhakar.lad@ti.com>
Subject: Re: [PATCH v4 1/2] media: add new mediabus format enums for dm365
Date: Thu, 19 Jul 2012 13:39:12 +0200
Message-ID: <1797465.0SHSipVErv@avalon>
In-Reply-To: <E99FAA59F8D8D34D8A118DD37F7C8F753E93F90F@DBDE01.ent.ti.com>
References: <1333102154-24657-1-git-send-email-manjunath.hadli@ti.com> <41958950.qGmmsSpAPM@avalon> <E99FAA59F8D8D34D8A118DD37F7C8F753E93F90F@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Manjunath,

On Thursday 19 July 2012 11:33:56 Hadli, Manjunath wrote:
> On Wed, Jul 18, 2012 at 16:35:18, Laurent Pinchart wrote:
> > On Tuesday 17 July 2012 12:22:42 Hadli, Manjunath wrote:
> > > On Tue, Jul 17, 2012 at 17:25:42, Laurent Pinchart wrote:
> > > > On Tuesday 17 July 2012 11:41:11 Hadli, Manjunath wrote:
> > > > > On Tue, Jul 17, 2012 at 16:26:24, Laurent Pinchart wrote:
> > > > > > On Friday 30 March 2012 10:09:13 Hadli, Manjunath wrote:
> > > > > > > add new enum entries for supporting the media-bus formats on
> > > > > > > dm365.
> > > > > > > These include some bayer and some non-bayer formats.
> > > > > > > V4L2_MBUS_FMT_YDYC8_1X16 and V4L2_MBUS_FMT_UV8_1X8 are used
> > > > > > > internal to the hardware by the resizer.
> > > > > > > V4L2_MBUS_FMT_SBGGR10_ALAW8_1X8 represents the bayer ALAW format
> > > > > > > that is supported by dm365 hardware.
> > > > > > > 
> > > > > > > Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> > > > > > > Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > > > > > Cc: Sakari Ailus <sakari.ailus@iki.fi>
> > > > > > > Cc: Hans Verkuil <hans.verkuil@cisco.com>
> > > > > > > ---
> > > > > > > 
> > > > > > >  Documentation/DocBook/media/v4l/subdev-formats.xml |  171
> > > > > > >  ++++++++++++
> > > > > > >  include/linux/v4l2-mediabus.h                      |   10 +-
> > > > > > >  2 files changed, 179 insertions(+), 2 deletions(-)
> > > > > > > 
> > > > > > > diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml
> > > > > > > b/Documentation/DocBook/media/v4l/subdev-formats.xml index
> > > > > > > 49c532e..48d92bb
> > > > > > > 100644
> > > > > > > --- a/Documentation/DocBook/media/v4l/subdev-formats.xml
> > > > > > > +++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
> > > > 
> > > > [snip]
> > > > 
> > > > > > > @@ -965,6 +1036,56 @@
> > > > > > > 
> > > > > > >  	      <entry>y<subscript>1</subscript></entry>
> > > > > > >  	      <entry>y<subscript>0</subscript></entry>
> > > > > > >  	    
> > > > > > >  	    </row>
> > > > > > > 
> > > > > > > +	    <row id="V4L2-MBUS-FMT-UV8-1X8">
> > > > > > 
> > > > > > That's a weird one. Just out of curiosity, what's the point of
> > > > > > transferring chroma information without luma ?
> > > > > 
> > > > > DM365 supports this format.
> > > > 
> > > > Right, but what is it used for ?
> > > 
> > > Sorry about that. The Resizer in Dm365 can take only chroma and resize
> > > the buffer. It can also take luma of course. In general it can take UV8,
> > > Y8 and also UYVY.
> > 
> > So UV8 is used to resize an NV buffer in two passes (first Y8 then UV8) ?
> 
> No. The resizer can take has a capability to resize UV8 alone. Apart from
> this I don't see any use case for UV8.

Right, but what is standalone UV8 useful for ? Y8 images make sense, but an 
image made of UV8 data only doesn't sound very useful to me.

NV formats are made of a Y8 plane and a UV8 plane, so UV8 resizing could be 
used to resize an NV image in two passes (resizing the Y8 plane first, then 
the UV8 plane). That's the only use case I see, and in that case I wonder 
whether the driver shouldn't expose NV resizing capabilities to userspace and 
run the two passes internally.

> (Hans, Sakari, Guennadi, any opinion on exposing UV8 to user?)

-- 
Regards,

Laurent Pinchart

