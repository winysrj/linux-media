Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:65125 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab2GSLnc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jul 2012 07:43:32 -0400
Date: Thu, 19 Jul 2012 13:43:22 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Hadli, Manjunath" <manjunath.hadli@ti.com>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	LMML <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	"Lad, Prabhakar" <prabhakar.lad@ti.com>
Subject: RE: [PATCH v4 1/2] media: add new mediabus format enums for dm365
In-Reply-To: <E99FAA59F8D8D34D8A118DD37F7C8F753E93F90F@DBDE01.ent.ti.com>
Message-ID: <Pine.LNX.4.64.1207191340220.300@axis700.grange>
References: <1333102154-24657-1-git-send-email-manjunath.hadli@ti.com>
 <1521995.bdrhyBupKO@avalon> <E99FAA59F8D8D34D8A118DD37F7C8F753E93EE3C@DBDE01.ent.ti.com>
 <41958950.qGmmsSpAPM@avalon> <E99FAA59F8D8D34D8A118DD37F7C8F753E93F90F@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 19 Jul 2012, Hadli, Manjunath wrote:

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

No particular objections from me. Just curious - what could this be used 
for... :-)

Thanks
Guennadi

> > > > [snip]
> > > > 
> > > > > > > @@ -2415,6 +2536,56 @@
> > > > > > > 
> > > > > > >  	      <entry>u<subscript>1</subscript></entry>
> > > > > > >  	      <entry>u<subscript>0</subscript></entry>
> > > > > > >  	    
> > > > > > >  	    </row>
> > > > > > > 
> > > > > > > +	    <row id="V4L2-MBUS-FMT-YDYC8-1X16">
> > > > > > 
> > > > > > What is this beast ? We at least need a textual description, as I have
> > > > > > no
> > > > > > idea what the format corresponds to.
> > > > > 
> > > > > This was discussed earlier over here
> > > > > http://patchwork.linuxtv.org/patch/8843/
> > > > 
> > > > My bad, I should have remembered that. Please add a textual description of
> > > > the format, it's not clear from the name what D and C are.
> > > 
> > > I see no description for individual MBUS formats but a collective para on
> > > everything together. Would you like me to add in the same or otherwise can
> > > you point to me where I can add this description?
> > 
> > What about the following patch ? Note that I've renamed YDYC to YDYU, as we
> > might later need a YDYV format.
> > 
> > (Hans, Sakari, any opinion ?)
> > 
> > diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml b/Documentation/DocBook/media/v4l/subdev-formats.xml
> > index 49c532e..47a485e 100644
> > --- a/Documentation/DocBook/media/v4l/subdev-formats.xml
> > +++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
> > @@ -853,10 +853,15 @@
> >        <title>Packed YUV Formats</title>
> >  
> >        <para>Those data formats transfer pixel data as (possibly downsampled) Y, U
> > -      and V components. The format code is made of the following information.
> > +      and V components. Some formats include dummy bits in some of their samples
> > +      and are collectively referred to as "YDYC" (Y-Dummy-Y-Chroma) formats.
> > +      </para>
> > +
> > +      <para>The format code is made of the following information.
> >        <itemizedlist>
> >  	<listitem><para>The Y, U and V components order code, as transferred on the
> > -	bus. Possible values are YUYV, UYVY, YVYU and VYUY.</para></listitem>
> > +	bus. Possible values are YUYV, UYVY, YVYU and VYUY for formats with no
> > +	dummy bit, and YDYU, YDYV, YUYD and YVYD for YDYC formats.</para></listitem>
> >  	<listitem><para>The number of bits per pixel component. All components are
> >  	transferred on the same number of bits. Common values are 8, 10 and 12.</para>
> >  	</listitem>
> > @@ -877,7 +882,21 @@
> >        U, Y, V, Y order will be named <constant>V4L2_MBUS_FMT_UYVY8_2X8</constant>.
> >        </para>
> >  
> > -      <para>The following table lisst existing packet YUV formats.</para>
> > +      <para><xref linkend="v4l2-mbus-pixelcode-yuv8"/> list existing packet YUV
> > +      formats and describes the organization of each pixel data in each sample.
> > +      When a format pattern is split across multiple samples each of the samples
> > +      in the pattern is described.</para>
> > +
> > +      <para>The role of each bit transferred over the bus is identified by one
> > +      of the following codes.</para>
> > +
> > +      <itemizedlist>
> > +        <listitem><para>y<subscript>x</subscript> for luma component bit number x</para></listitem>
> > +        <listitem><para>u<subscript>x</subscript> for blue chroma component bit number x</para></listitem>
> > +        <listitem><para>v<subscript>x</subscript> for red chroma component bit number x</para></listitem>
> > +        <listitem><para>- for non-available bits (for positions higher than the bus width)</para></listitem>
> > +        <listitem><para>/ for dummy bits</para></listitem>
>  As discussed with Hans, Ill use 'd' for dummy bits which would make more sense.
> 
> > +      </itemizedlist>
> >  
> >        <table pgwide="0" frame="none" id="v4l2-mbus-pixelcode-yuv8">
> >  	<title>YUV Formats</title>
> > @@ -2415,6 +2434,106 @@
> >  	      <entry>u<subscript>1</subscript></entry>
> >  	      <entry>u<subscript>0</subscript></entry>
> >  	    </row>
> > +	    <row id="V4L2-MBUS-FMT-YDYU8-1X16">
> > +	      <entry>V4L2_MBUS_FMT_YDYU8_1X16</entry>
> As discussed over the IRC chat ill change it to V4L2_MBUS_FMT_YDYUYDYV8_1X16
> 
> Thx,
> --Manju
> 
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
> > +	      <entry>/</entry>
> > +	      <entry>/</entry>
> > +	      <entry>/</entry>
> > +	      <entry>/</entry>
> > +	      <entry>/</entry>
> > +	      <entry>/</entry>
> > +	      <entry>/</entry>
> > +	      <entry>/</entry>
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
> > +	      <entry>/</entry>
> > +	      <entry>/</entry>
> > +	      <entry>/</entry>
> > +	      <entry>/</entry>
> > +	      <entry>/</entry>
> > +	      <entry>/</entry>
> > +	      <entry>/</entry>
> > +	      <entry>/</entry>
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
> > 
> > -- 
> > Regards,
> > 
> > Laurent Pinchart
> > 
> > 
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
