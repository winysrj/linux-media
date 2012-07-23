Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:45496 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753392Ab2GWHIW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jul 2012 03:08:22 -0400
From: "Lad, Prabhakar" <prabhakar.lad@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Hans Verkuil <hansverk@cisco.com>,
	"Hadli, Manjunath" <manjunath.hadli@ti.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: RE: [PATCH v6 1/2] media: add new mediabus format enums for dm365
Date: Mon, 23 Jul 2012 07:07:58 +0000
Message-ID: <4665BC9CC4253445B213A010E6DC7B35CE165B@DBDE01.ent.ti.com>
References: <1342796290-18947-1-git-send-email-prabhakar.lad@ti.com>
 <1342796290-18947-2-git-send-email-prabhakar.lad@ti.com>
 <5460968.zn5gceMGBZ@avalon>
In-Reply-To: <5460968.zn5gceMGBZ@avalon>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Fri, Jul 20, 2012 at 23:02:23, Laurent Pinchart wrote:
> Hi Prabhakar,
> 
> Just one small comment below.
> 
> On Friday 20 July 2012 20:28:09 Prabhakar Lad wrote:
> > From: Manjunath Hadli <manjunath.hadli@ti.com>
> > 
> > add new enum entries for supporting the media-bus formats on dm365.
> > These include some bayer and some non-bayer formats.
> > V4L2_MBUS_FMT_YDYUYDYV8_1X16 and V4L2_MBUS_FMT_UV8_1X8 are used
> > internal to the hardware by the resizer.
> > V4L2_MBUS_FMT_SBGGR10_ALAW8_1X8 represents the bayer ALAW format
> > that is supported by dm365 hardware.
> > 
> > Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> > Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> > Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> > Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Cc: Sakari Ailus <sakari.ailus@iki.fi>
> > Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> >  Documentation/DocBook/media/v4l/subdev-formats.xml |  250 ++++++++++++++++-
> >  include/linux/v4l2-mediabus.h                      |   10 +-
> >  2 files changed, 252 insertions(+), 8 deletions(-)
> 
> 
> > @@ -2415,6 +2553,106 @@
> >  	      <entry>u<subscript>1</subscript></entry>
> >  	      <entry>u<subscript>0</subscript></entry>
> >  	    </row>
> > +	    <row id="V4L2-MBUS-FMT-YDYUYDYV8-1X16">
> > +	      <entry>V4L2_MBUS_FMT_YDYUYDYV8_1X16</entry>
> > +	      <entry>0x2014</entry>
> > +	      <entry></entry>
> > +	      <entry>-</entry>
> > +	      <entry>-</entry>
> > +	      <entry>-</entry>
> > +	      <entry>-</entry>
> > +	      <entry>y<subscript>7</subscript></entry>
> > +	      <entry>y<subscript>6</subscript></entry>
> > +	      <entry>y<subscript>5</subscript></entry>
> > +	      <entry>y<subscript>4</subscript></entry>
> > +	      <entry>y<subscript>3</subscript></entry>
> > +	      <entry>y<subscript>2</subscript></entry>
> > +	      <entry>y<subscript>1</subscript></entry>
> > +	      <entry>y<subscript>0</subscript></entry>
> > +	      <entry>d<subscript>7</subscript></entry>
> > +	      <entry>d<subscript>6</subscript></entry>
> > +	      <entry>d<subscript>5</subscript></entry>
> > +	      <entry>d<subscript>4</subscript></entry>
> > +	      <entry>d<subscript>3</subscript></entry>
> > +	      <entry>d<subscript>2</subscript></entry>
> > +	      <entry>d<subscript>1</subscript></entry>
> > +	      <entry>d<subscript>0</subscript></entry>
> 
> I would remove the subscripts for all the dummy bits (here and below), as 
> they're dummy.
> 
  Ok, I'll remove the subscript for dummy bits in the next version and add your
  ACK too.

Thx,
--Prabhakar Lad

> With that change,
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> > +	    </row>
> > +	    <row>
> > +	      <entry></entry>
> > +	      <entry></entry>
> > +	      <entry></entry>
> > +	      <entry>-</entry>
> > +	      <entry>-</entry>
> > +	      <entry>-</entry>
> > +	      <entry>-</entry>
> > +	      <entry>y<subscript>7</subscript></entry>
> > +	      <entry>y<subscript>6</subscript></entry>
> > +	      <entry>y<subscript>5</subscript></entry>
> > +	      <entry>y<subscript>4</subscript></entry>
> > +	      <entry>y<subscript>3</subscript></entry>
> > +	      <entry>y<subscript>2</subscript></entry>
> > +	      <entry>y<subscript>1</subscript></entry>
> > +	      <entry>y<subscript>0</subscript></entry>
> > +	      <entry>u<subscript>7</subscript></entry>
> > +	      <entry>u<subscript>6</subscript></entry>
> > +	      <entry>u<subscript>5</subscript></entry>
> > +	      <entry>u<subscript>4</subscript></entry>
> > +	      <entry>u<subscript>3</subscript></entry>
> > +	      <entry>u<subscript>2</subscript></entry>
> > +	      <entry>u<subscript>1</subscript></entry>
> > +	      <entry>u<subscript>0</subscript></entry>
> > +	    </row>
> > +	    <row>
> > +	      <entry></entry>
> > +	      <entry></entry>
> > +	      <entry></entry>
> > +	      <entry>-</entry>
> > +	      <entry>-</entry>
> > +	      <entry>-</entry>
> > +	      <entry>-</entry>
> > +	      <entry>y<subscript>7</subscript></entry>
> > +	      <entry>y<subscript>6</subscript></entry>
> > +	      <entry>y<subscript>5</subscript></entry>
> > +	      <entry>y<subscript>4</subscript></entry>
> > +	      <entry>y<subscript>3</subscript></entry>
> > +	      <entry>y<subscript>2</subscript></entry>
> > +	      <entry>y<subscript>1</subscript></entry>
> > +	      <entry>y<subscript>0</subscript></entry>
> > +	      <entry>d<subscript>7</subscript></entry>
> > +	      <entry>d<subscript>6</subscript></entry>
> > +	      <entry>d<subscript>5</subscript></entry>
> > +	      <entry>d<subscript>4</subscript></entry>
> > +	      <entry>d<subscript>3</subscript></entry>
> > +	      <entry>d<subscript>2</subscript></entry>
> > +	      <entry>d<subscript>1</subscript></entry>
> > +	      <entry>d<subscript>0</subscript></entry>
> > +	    </row>
> > +	    <row>
> > +	      <entry></entry>
> > +	      <entry></entry>
> > +	      <entry></entry>
> > +	      <entry>-</entry>
> > +	      <entry>-</entry>
> > +	      <entry>-</entry>
> > +	      <entry>-</entry>
> > +	      <entry>y<subscript>7</subscript></entry>
> > +	      <entry>y<subscript>6</subscript></entry>
> > +	      <entry>y<subscript>5</subscript></entry>
> > +	      <entry>y<subscript>4</subscript></entry>
> > +	      <entry>y<subscript>3</subscript></entry>
> > +	      <entry>y<subscript>2</subscript></entry>
> > +	      <entry>y<subscript>1</subscript></entry>
> > +	      <entry>y<subscript>0</subscript></entry>
> > +	      <entry>v<subscript>7</subscript></entry>
> > +	      <entry>v<subscript>6</subscript></entry>
> > +	      <entry>v<subscript>5</subscript></entry>
> > +	      <entry>v<subscript>4</subscript></entry>
> > +	      <entry>v<subscript>3</subscript></entry>
> > +	      <entry>v<subscript>2</subscript></entry>
> > +	      <entry>v<subscript>1</subscript></entry>
> > +	      <entry>v<subscript>0</subscript></entry>
> > +	    </row>
> >  	    <row id="V4L2-MBUS-FMT-YUYV10-1X20">
> >  	      <entry>V4L2_MBUS_FMT_YUYV10_1X20</entry>
> >  	      <entry>0x200d</entry>
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 
> 

