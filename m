Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:36650 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752622Ab2GQMW7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jul 2012 08:22:59 -0400
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	LMML <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: RE: [PATCH v4 1/2] media: add new mediabus format enums for dm365
Date: Tue, 17 Jul 2012 12:22:42 +0000
Message-ID: <E99FAA59F8D8D34D8A118DD37F7C8F753E93EE3C@DBDE01.ent.ti.com>
References: <1333102154-24657-1-git-send-email-manjunath.hadli@ti.com>
 <9731012.hn1ecEuNnk@avalon>
 <E99FAA59F8D8D34D8A118DD37F7C8F753E93EDDE@DBDE01.ent.ti.com>
 <1521995.bdrhyBupKO@avalon>
In-Reply-To: <1521995.bdrhyBupKO@avalon>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Tue, Jul 17, 2012 at 17:25:42, Laurent Pinchart wrote:
> Hi Manjunath,
> 
> On Tuesday 17 July 2012 11:41:11 Hadli, Manjunath wrote:
> > On Tue, Jul 17, 2012 at 16:26:24, Laurent Pinchart wrote:
> > > On Friday 30 March 2012 10:09:13 Hadli, Manjunath wrote:
> > > > add new enum entries for supporting the media-bus formats on dm365.
> > > > These include some bayer and some non-bayer formats.
> > > > V4L2_MBUS_FMT_YDYC8_1X16 and V4L2_MBUS_FMT_UV8_1X8 are used
> > > > internal to the hardware by the resizer.
> > > > V4L2_MBUS_FMT_SBGGR10_ALAW8_1X8 represents the bayer ALAW format
> > > > that is supported by dm365 hardware.
> > > > 
> > > > Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> > > > Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > > Cc: Sakari Ailus <sakari.ailus@iki.fi>
> > > > Cc: Hans Verkuil <hans.verkuil@cisco.com>
> > > > ---
> > > > 
> > > >  Documentation/DocBook/media/v4l/subdev-formats.xml |  171  ++++++++++++
> > > >  include/linux/v4l2-mediabus.h                      |   10 +-
> > > >  2 files changed, 179 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml
> > > > b/Documentation/DocBook/media/v4l/subdev-formats.xml index
> > > > 49c532e..48d92bb
> > > > 100644
> > > > --- a/Documentation/DocBook/media/v4l/subdev-formats.xml
> > > > +++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
> 
> [snip]
> 
> > > > @@ -965,6 +1036,56 @@
> > > >  	      <entry>y<subscript>1</subscript></entry>
> > > >  	      <entry>y<subscript>0</subscript></entry>
> > > >  	    </row>
> > > > +	    <row id="V4L2-MBUS-FMT-UV8-1X8">
> > > 
> > > That's a weird one. Just out of curiosity, what's the point of
> > > transferring chroma information without luma ?
> > 
> > DM365 supports this format.
> 
> Right, but what is it used for ?
> 
Sorry about that. The Resizer in Dm365 can take only chroma and resize the buffer. It can also take luma of course.In general it can take UV8, Y8 and also UYVY.  
> [snip]
> 
> > > > @@ -2415,6 +2536,56 @@
> > > >  	      <entry>u<subscript>1</subscript></entry>
> > > >  	      <entry>u<subscript>0</subscript></entry>
> > > >  	    </row>
> > > > +	    <row id="V4L2-MBUS-FMT-YDYC8-1X16">
> > > 
> > > What is this beast ? We at least need a textual description, as I have no
> > > idea what the format corresponds to.
> > 
> > This was discussed earlier over here
> > http://patchwork.linuxtv.org/patch/8843/
> 
> My bad, I should have remembered that. Please add a textual description of the 
> format, it's not clear from the name what D and C are.
> 
I see no description for individual MBUS formats but a collective para on everything together.
Would you like me to add in the same or otherwise can you point to me where I can add this description?
 
Thx,
--Manju
> -- 
> Regards,
> 
> Laurent Pinchart
> 
> 

