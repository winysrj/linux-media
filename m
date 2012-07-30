Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57504 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab2G3TG2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Jul 2012 15:06:28 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: davinci-linux-open-source@linux.davincidsp.com
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	LMML <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v7 1/2] media: add new mediabus format enums for dm365
Date: Mon, 30 Jul 2012 21:06:33 +0200
Message-ID: <1527741.DUREJZiXMg@avalon>
In-Reply-To: <201207302036.36180.hverkuil@xs4all.nl>
References: <1343386505-8695-1-git-send-email-prabhakar.lad@ti.com> <20120727220124.GC26642@valkosipuli.retiisi.org.uk> <201207302036.36180.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Monday 30 July 2012 20:36:36 Hans Verkuil wrote:
> On Sat July 28 2012 00:01:24 Sakari Ailus wrote:
> > On Fri, Jul 27, 2012 at 04:25:04PM +0530, Prabhakar Lad wrote:
> > > From: Manjunath Hadli <manjunath.hadli@ti.com>
> > > 
> > > add new enum entries for supporting the media-bus formats on dm365.
> > > These include some bayer and some non-bayer formats.
> > > V4L2_MBUS_FMT_YDYUYDYV8_1X16 and V4L2_MBUS_FMT_UV8_1X8 are used
> > > internal to the hardware by the resizer.
> > > V4L2_MBUS_FMT_SBGGR10_ALAW8_1X8 represents the bayer ALAW format
> > > that is supported by dm365 hardware.
> > > 
> > > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> > > Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> > > Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> > > Cc: Sakari Ailus <sakari.ailus@iki.fi>
> > > Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > > ---
> > > 
> > >  Documentation/DocBook/media/v4l/subdev-formats.xml |  250
> > >  +++++++++++++++++++- include/linux/v4l2-mediabus.h                    
> > >   |   10 +-
> > >  2 files changed, 252 insertions(+), 8 deletions(-)
> > > 
> > > diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml
> > > b/Documentation/DocBook/media/v4l/subdev-formats.xml index
> > > 49c532e..75dc275 100644
> > > --- a/Documentation/DocBook/media/v4l/subdev-formats.xml
> > > +++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
> > > @@ -353,9 +353,9 @@
> > > 
> > >  	<listitem><para>The number of bits per pixel component. All 
components
> > >  	are
> > >  	transferred on the same number of bits. Common values are 8, 10 and
> > >  	12.</para> </listitem>
> > > 
> > > -	<listitem><para>If the pixel components are DPCM-compressed, a 
mention
> > > of the -	DPCM compression and the number of bits per compressed pixel
> > > component.</para> -	</listitem>
> > > +	<listitem><para>The compression (optional). If the pixel components
> > > are
> > > +	ALAW- or DPCM-compressed, a mention of the compression scheme and the
> > > +	number of bits per compressed pixel component.</para></listitem>
> > > 
> > >  	<listitem><para>The number of bus samples per pixel. Pixels that are
> > >  	wider than the bus width must be transferred in multiple samples.
> > >  	Common values are 1 and 2.</para></listitem>
> > > 
> > > @@ -504,6 +504,74 @@
> > > 
> > >  	      <entry>r<subscript>1</subscript></entry>
> > >  	      <entry>r<subscript>0</subscript></entry>
> > >  	    
> > >  	    </row>
> > > 
> > > +	    <row id="V4L2-MBUS-FMT-SBGGR10-ALAW8-1X8">
> > > +	      <entry>V4L2_MBUS_FMT_SBGGR10_ALAW8_1X8</entry>
> > > +	      <entry>0x3015</entry>
> > > +	      <entry></entry>
> > > +	      <entry>-</entry>
> > > +	      <entry>-</entry>
> > > +	      <entry>-</entry>
> > > +	      <entry>-</entry>
> > > +	      <entry>b<subscript>7</subscript></entry>
> > > +	      <entry>b<subscript>6</subscript></entry>
> > > +	      <entry>b<subscript>5</subscript></entry>
> > > +	      <entry>b<subscript>4</subscript></entry>
> > > +	      <entry>b<subscript>3</subscript></entry>
> > > +	      <entry>b<subscript>2</subscript></entry>
> > > +	      <entry>b<subscript>1</subscript></entry>
> > > +	      <entry>b<subscript>0</subscript></entry>
> > > +	    </row>
> > > +	    <row id="V4L2-MBUS-FMT-SGBRG10-ALAW8-1X8">
> > > +	      <entry>V4L2_MBUS_FMT_SGBRG10_ALAW8_1X8</entry>
> > > +	      <entry>0x3016</entry>
> > > +	      <entry></entry>
> > > +	      <entry>-</entry>
> > > +	      <entry>-</entry>
> > > +	      <entry>-</entry>
> > > +	      <entry>-</entry>
> > > +	      <entry>g<subscript>7</subscript></entry>
> > > +	      <entry>g<subscript>6</subscript></entry>
> > > +	      <entry>g<subscript>5</subscript></entry>
> > > +	      <entry>g<subscript>4</subscript></entry>
> > > +	      <entry>g<subscript>3</subscript></entry>
> > > +	      <entry>g<subscript>2</subscript></entry>
> > > +	      <entry>g<subscript>1</subscript></entry>
> > > +	      <entry>g<subscript>0</subscript></entry>
> > > +	    </row>
> > > +	    <row id="V4L2-MBUS-FMT-SGRBG10-ALAW8-1X8">
> > > +	      <entry>V4L2_MBUS_FMT_SGRBG10_ALAW8_1X8</entry>
> > > +	      <entry>0x3017</entry>
> > > +	      <entry></entry>
> > > +	      <entry>-</entry>
> > > +	      <entry>-</entry>
> > > +	      <entry>-</entry>
> > > +	      <entry>-</entry>
> > > +	      <entry>g<subscript>7</subscript></entry>
> > > +	      <entry>g<subscript>6</subscript></entry>
> > > +	      <entry>g<subscript>5</subscript></entry>
> > > +	      <entry>g<subscript>4</subscript></entry>
> > > +	      <entry>g<subscript>3</subscript></entry>
> > > +	      <entry>g<subscript>2</subscript></entry>
> > > +	      <entry>g<subscript>1</subscript></entry>
> > > +	      <entry>g<subscript>0</subscript></entry>
> > > +	    </row>
> > > +	    <row id="V4L2-MBUS-FMT-SRGGB10-ALAW8-1X8">
> > > +	      <entry>V4L2_MBUS_FMT_SRGGB10_ALAW8_1X8</entry>
> > > +	      <entry>0x3018</entry>
> > > +	      <entry></entry>
> > > +	      <entry>-</entry>
> > > +	      <entry>-</entry>
> > > +	      <entry>-</entry>
> > > +	      <entry>-</entry>
> > > +	      <entry>r<subscript>7</subscript></entry>
> > > +	      <entry>r<subscript>6</subscript></entry>
> > > +	      <entry>r<subscript>5</subscript></entry>
> > > +	      <entry>r<subscript>4</subscript></entry>
> > > +	      <entry>r<subscript>3</subscript></entry>
> > > +	      <entry>r<subscript>2</subscript></entry>
> > > +	      <entry>r<subscript>1</subscript></entry>
> > > +	      <entry>r<subscript>0</subscript></entry>
> > > +	    </row>
> > > 
> > >  	    <row id="V4L2-MBUS-FMT-SBGGR10-DPCM8-1X8">
> > >  	    
> > >  	      <entry>V4L2_MBUS_FMT_SBGGR10_DPCM8_1X8</entry>
> > >  	      <entry>0x300b</entry>
> > > 
> > > @@ -853,10 +921,16 @@
> > > 
> > >        <title>Packed YUV Formats</title>
> > >        
> > >        <para>Those data formats transfer pixel data as (possibly
> > >        downsampled) Y, U
> > > 
> > > -      and V components. The format code is made of the following
> > > information. +      and V components. Some formats include dummy bits
> > > in some of their samples +      and are collectively referred to as
> > > "YDYC" (Y-Dummy-Y-Chroma) formats. +      One cannot rely on the values
> > > of these dummy bits as those are undefined. +      </para>
> > > +      <para>The format code is made of the following information.
> > > 
> > >        <itemizedlist>
> > >  	
> > >  	<listitem><para>The Y, U and V components order code, as transferred
> > >  	on the
> > > 
> > > -	bus. Possible values are YUYV, UYVY, YVYU and VYUY.</para></listitem>
> > > +	bus. Possible values are YUYV, UYVY, YVYU and VYUY for formats with 
no
> > > +	dummy bit, and YDYUYDYV, YDYVYDYU, YUYDYVYD and YVYDYUYD for YDYC
> > > formats. +	</para></listitem>
> > > 
> > >  	<listitem><para>The number of bits per pixel component. All 
components
> > >  	are
> > >  	transferred on the same number of bits. Common values are 8, 10 and
> > >  	12.</para> </listitem>
> > 
> > I dicussed dummy vs. padding (zeros) with Laurent and we concluded we
> > should use zero padding instead. The difference is that when processing
> > the pixels no extra operations are necessary to get rid of the dummy data
> > when the dummy bits are actually zero --- which in practice always is the
> > case.
> > 
> > I'm not aware of hardware that would assign padding bits (in this very
> > purpose) that are a part of writes the width of bus width something else
> > than zeros. It wouldn't make much sense either.
> > 
> > So I suggest that dummy is replaced by padding which is defined to be
> > zero.
> > 
> > The letter in the format name could be 'Z', for example.
> > 
> > Hans: what do you think?
> 
> Bad idea. First of all, some hardware or FPGA can insert different values
> there. It's something that Cisco uses in some cases: it makes it easier to
> identify the dummy values if they have a non-zero fixed value.
> 
> Another reason for not doing this is when such formats are used to display
> video: you don't want to force the software to fill in the dummy values
> with a specific value for no good reason. That would only cost extra CPU
> cycles.

On the other hand, when you process data that includes dummy bits stored in 
memory, knowing that the dummy bits are zero can save a mask operation.

I don't have a strong opinion whether we should use zero or dummy bits for 
media bus formats. For memory formats I'd be inclined to use zero bits (at 
least when capturing).

-- 
Regards,

Laurent Pinchart

