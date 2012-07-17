Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:33642 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000Ab2GQLnR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jul 2012 07:43:17 -0400
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	LMML <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: RE: [PATCH v4 2/2] v4l2: add new pixel formats supported on dm365
Date: Tue, 17 Jul 2012 11:43:03 +0000
Message-ID: <E99FAA59F8D8D34D8A118DD37F7C8F753E93EDEE@DBDE01.ent.ti.com>
References: <1333102154-24657-1-git-send-email-manjunath.hadli@ti.com>
 <1333102154-24657-3-git-send-email-manjunath.hadli@ti.com>
 <35332134.OR43XtYrnk@avalon>
In-Reply-To: <35332134.OR43XtYrnk@avalon>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Tue, Jul 17, 2012 at 16:29:44, Laurent Pinchart wrote:
> Hi Manjunath,
> 
> Thank you for the patch.
> 
> A couple of comments below.
> 
> On Friday 30 March 2012 10:09:14 Hadli, Manjunath wrote:
> > add new macro V4L2_PIX_FMT_SGRBG10ALAW8 and associated formats
> > to represent Bayer format frames compressed by A-LAW algorithm,
> > add V4L2_PIX_FMT_UV8 to represent storage of CbCr data (UV interleaved)
> > only.
> > 
> > Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> > Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Cc: Sakari Ailus <sakari.ailus@iki.fi>
> > Cc: Hans Verkuil <hans.verkuil@cisco.com>
> > ---
> >  .../DocBook/media/v4l/pixfmt-srggb10alaw8.xml      |   34 +++++++++++
> >  Documentation/DocBook/media/v4l/pixfmt-uv8.xml     |   62
> > ++++++++++++++++++++ Documentation/DocBook/media/v4l/pixfmt.xml         |  
> >  2 +
> >  include/linux/videodev2.h                          |    8 +++
> >  4 files changed, 106 insertions(+), 0 deletions(-)
> >  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-srggb10alaw8.xml
> >  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-uv8.xml
> > 
> > diff --git a/Documentation/DocBook/media/v4l/pixfmt-srggb10alaw8.xml
> > b/Documentation/DocBook/media/v4l/pixfmt-srggb10alaw8.xml new file mode
> > 100644
> > index 0000000..9b5c80d
> > --- /dev/null
> > +++ b/Documentation/DocBook/media/v4l/pixfmt-srggb10alaw8.xml
> > @@ -0,0 +1,34 @@
> > +	<refentry>
> > +	  <refmeta>
> > +	    <refentrytitle>
> > +	      V4L2_PIX_FMT_SRGGB10ALAW8 ('aRA8'),
> > +	      V4L2_PIX_FMT_SGRBG10ALAW8 ('agA8'),
> > +	      V4L2_PIX_FMT_SGBRG10ALAW8 ('aGA8'),
> > +	      V4L2_PIX_FMT_SBGGR10ALAW8 ('aBA8'),
> > +	    </refentrytitle>
> > +	    &manvol;
> > +	  </refmeta>
> > +	  <refnamediv>
> > +	    <refname id="V4L2-PIX-FMT-SRGGB10ALAW8">
> > +	      <constant>V4L2_PIX_FMT_SRGGB10ALAW8</constant>
> > +	    </refname>
> > +	    <refname id="V4L2-PIX-FMT-SGRBG10ALAW8">
> > +	      <constant>V4L2_PIX_FMT_SGRBG10ALAW8</constant>
> > +	    </refname>
> > +	    <refname id="V4L2-PIX-FMT-SGBRG10ALAW8">
> > +	      <constant>V4L2_PIX_FMT_SGBRG10ALAW8</constant>
> > +	    </refname>
> > +	    <refname id="V4L2-PIX-FMT-SBGGR10ALAW8">
> > +	      <constant>V4L2_PIX_FMT_SBGGR10ALAW8</constant>
> > +	    </refname>
> > +	    <refpurpose>10-bit Bayer formats compressed to 8 bits</refpurpose>
> > +	  </refnamediv>
> > +	  <refsect1>
> > +	    <title>Description</title>
> > +	    <para>The following four pixel formats are raw sRGB / Bayer
> > +	    formats with 10 bits per colour compressed to 8 bits each,
> > +	    using the A-LAW algorithm. Each colour component consumes 8
> > +	    bits of memory. In other respects this format is similar to
> > +	    <xref linkend="V4L2-PIX-FMT-SRGGB8">.</xref></para>
> > +	  </refsect1>
> > +	</refentry>
> > diff --git a/Documentation/DocBook/media/v4l/pixfmt-uv8.xml
> > b/Documentation/DocBook/media/v4l/pixfmt-uv8.xml new file mode 100644
> > index 0000000..c507c1f
> > --- /dev/null
> > +++ b/Documentation/DocBook/media/v4l/pixfmt-uv8.xml
> > @@ -0,0 +1,62 @@
> > +	<refentry id="V4L2-PIX-FMT-UV8">
> > +	  <refmeta>
> > +	    <refentrytitle>V4L2_PIX_FMT_UV8  ('UV8')</refentrytitle>
> > +	    &manvol;
> > +	  </refmeta>
> > +	  <refnamediv>
> > +	    <refname><constant>V4L2_PIX_FMT_UV8</constant></refname>
> > +	    <refpurpose>UV plane interleaved</refpurpose>
> > +	  </refnamediv>
> > +	  <refsect1>
> > +	    <title>Description</title>
> > +	    <para>In this format there is no Y plane, Only CbCr plane. ie
> > +	    (UV interleaved)</para>
> > +	    <example>
> > +	    <title>
> > +	      <constant>V4L2_PIX_FMT_UV8</constant>
> > +	       pixel image
> > +	    </title>
> > +
> > +	    <formalpara>
> > +	      <title>Byte Order.</title>
> > +	      <para>Each cell is one byte.
> > +	        <informaltable frame="none">
> > +	        <tgroup cols="5" align="center">
> > +		  <colspec align="left" colwidth="2*" />
> > +		  <tbody valign="top">
> > +		    <row>
> > +		      <entry>start&nbsp;+&nbsp;0:</entry>
> > +		      <entry>Cb<subscript>00</subscript></entry>
> > +		      <entry>Cr<subscript>00</subscript></entry>
> > +		      <entry>Cb<subscript>01</subscript></entry>
> > +		      <entry>Cr<subscript>01</subscript></entry>
> > +		    </row>
> > +		    <row>
> > +		      <entry>start&nbsp;+&nbsp;4:</entry>
> > +		      <entry>Cb<subscript>10</subscript></entry>
> > +		      <entry>Cr<subscript>10</subscript></entry>
> > +		      <entry>Cb<subscript>11</subscript></entry>
> > +		      <entry>Cr<subscript>11</subscript></entry>
> > +		    </row>
> > +		    <row>
> > +		      <entry>start&nbsp;+&nbsp;8:</entry>
> > +		      <entry>Cb<subscript>20</subscript></entry>
> > +		      <entry>Cr<subscript>20</subscript></entry>
> > +		      <entry>Cb<subscript>21</subscript></entry>
> > +		      <entry>Cr<subscript>21</subscript></entry>
> > +		    </row>
> > +		    <row>
> > +		      <entry>start&nbsp;+&nbsp;12:</entry>
> > +		      <entry>Cb<subscript>30</subscript></entry>
> > +		      <entry>Cr<subscript>30</subscript></entry>
> > +		      <entry>Cb<subscript>31</subscript></entry>
> > +		      <entry>Cr<subscript>31</subscript></entry>
> > +		    </row>
> > +		  </tbody>
> > +		</tgroup>
> > +		</informaltable>
> > +	      </para>
> > +	      </formalpara>
> > +	    </example>
> > +	  </refsect1>
> > +	</refentry>
> > diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml
> > b/Documentation/DocBook/media/v4l/pixfmt.xml index 74d4fcd..9dc3024 100644
> > --- a/Documentation/DocBook/media/v4l/pixfmt.xml
> > +++ b/Documentation/DocBook/media/v4l/pixfmt.xml
> > @@ -674,6 +674,7 @@ access the palette, this must be done with ioctls of the
> > Linux framebuffer API.< &sub-sbggr16;
> >      &sub-srggb10;
> >      &sub-srggb10dpcm8;
> > +    &sub-srggb10alaw8;
> 
> Please move the ALAW formats above the DPCM formats to keep them 
> alphabetically sorted.
> 
  Ok.

> >      &sub-srggb12;
> >    </section>
> > 
> > @@ -701,6 +702,7 @@ information.</para>
> >      &sub-y12;
> >      &sub-y10b;
> >      &sub-y16;
> > +    &sub-uv8;
> >      &sub-yuyv;
> >      &sub-uyvy;
> >      &sub-yvyu;
> > diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> > index dbc0d77..71f9f94 100644
> > --- a/include/linux/videodev2.h
> > +++ b/include/linux/videodev2.h
> > @@ -328,6 +328,9 @@ struct v4l2_pix_format {
> >  /* Palette formats */
> >  #define V4L2_PIX_FMT_PAL8    v4l2_fourcc('P', 'A', 'L', '8') /*  8  8-bit
> > palette */
> > 
> > +/* Chrominance formats */
> > +#define V4L2_PIX_FMT_UV8      v4l2_fourcc('U', 'V', '8', ' ') /*  8  UV 4:4
> > */ +
> >  /* Luminance+Chrominance formats */
> >  #define V4L2_PIX_FMT_YVU410  v4l2_fourcc('Y', 'V', 'U', '9') /*  9  YVU
> > 4:1:0     */ #define V4L2_PIX_FMT_YVU420  v4l2_fourcc('Y', 'V', '1', '2')
> > /* 12  YVU 4:2:0     */ @@ -382,6 +385,11 @@ struct v4l2_pix_format {
> >  #define V4L2_PIX_FMT_SGBRG10DPCM8 v4l2_fourcc('b', 'G', 'A', '8')
> >  #define V4L2_PIX_FMT_SGRBG10DPCM8 v4l2_fourcc('B', 'D', '1', '0')
> >  #define V4L2_PIX_FMT_SRGGB10DPCM8 v4l2_fourcc('b', 'R', 'A', '8')
> > +	/* 10bit raw bayer a-law compressed to 8 bits */
> > +#define V4L2_PIX_FMT_SBGGR10ALAW8 v4l2_fourcc('a', 'B', 'A', '8')
> > +#define V4L2_PIX_FMT_SGBRG10ALAW8 v4l2_fourcc('a', 'G', 'A', '8')
> > +#define V4L2_PIX_FMT_SGRBG10ALAW8 v4l2_fourcc('a', 'g', 'A', '8')
> > +#define V4L2_PIX_FMT_SRGGB10ALAW8 v4l2_fourcc('a', 'R', 'A', '8')
> 
> Please move the ALAW formats above the DPCM formats to keep them 
> alphabetically sorted.
> 
  Ok.

Thx,
--Manju

> We still have no clear fourcc allocation scheme for Bayer formats, but I 
> suppose I'll need to give up on that.
> 
> >  	/*
> >  	 * 10bit raw bayer, expanded to 16 bits
> >  	 * xxxxrrrrrrrrrrxxxxgggggggggg xxxxggggggggggxxxxbbbbbbbbbb...
> -- 
> Regards,
> 
> Laurent Pinchart
> 
> 

