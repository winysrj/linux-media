Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:37691 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab2GSM6j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jul 2012 08:58:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Hadli, Manjunath" <manjunath.hadli@ti.com>
Subject: Re: [PATCH v4 1/2] media: add new mediabus format enums for dm365
Date: Thu, 19 Jul 2012 14:58:12 +0200
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	LMML <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	"g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
	"Lad, Prabhakar" <prabhakar.lad@ti.com>
References: <1333102154-24657-1-git-send-email-manjunath.hadli@ti.com> <41958950.qGmmsSpAPM@avalon> <E99FAA59F8D8D34D8A118DD37F7C8F753E93F90F@DBDE01.ent.ti.com>
In-Reply-To: <E99FAA59F8D8D34D8A118DD37F7C8F753E93F90F@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207191458.12262.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu 19 July 2012 13:33:56 Hadli, Manjunath wrote:
> Hi Laurent,
> 
> On Wed, Jul 18, 2012 at 16:35:18, Laurent Pinchart wrote:
> > Hi Manjunath,
> > 
> > On Tuesday 17 July 2012 12:22:42 Hadli, Manjunath wrote:
> > > On Tue, Jul 17, 2012 at 17:25:42, Laurent Pinchart wrote:
> > > > On Tuesday 17 July 2012 11:41:11 Hadli, Manjunath wrote:
> > > > > On Tue, Jul 17, 2012 at 16:26:24, Laurent Pinchart wrote:
> > > > > > On Friday 30 March 2012 10:09:13 Hadli, Manjunath wrote:
> > > > > > > add new enum entries for supporting the media-bus formats on dm365.
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
> > > Sorry about that. The Resizer in Dm365 can take only chroma and resize the
> > > buffer. It can also take luma of course. In general it can take UV8, Y8 and
> > > also UYVY.
> > 
> > So UV8 is used to resize an NV buffer in two passes (first Y8 then UV8) ?
> > 
>   No. The resizer can take has a capability to resize UV8 alone. Apart from 
>   this I don't see any use case for UV8.
> 
> (Hans, Sakari, Guennadi, any opinion on exposing UV8 to user?)

I have no problem with that. As far as I can tell they should be useful for
conversions between 4:2:0, 4:2:2 and 4:4:4 formats where you just want to resize
the chroma plane.

Regards,

	Hans
