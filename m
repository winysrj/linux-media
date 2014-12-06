Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37548 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752441AbaLFLy7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Dec 2014 06:54:59 -0500
Date: Sat, 6 Dec 2014 13:54:26 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, aviv.d.greenberg@intel.com
Subject: Re: [REVIEW PATCH 2/2] v4l: Add packed Bayer raw10 pixel formats
Message-ID: <20141206115426.GC15559@valkosipuli.retiisi.org.uk>
References: <1417605249-5322-1-git-send-email-sakari.ailus@iki.fi>
 <1417605249-5322-3-git-send-email-sakari.ailus@iki.fi>
 <5481CB5F.8010600@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5481CB5F.8010600@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the review.

On Fri, Dec 05, 2014 at 04:12:31PM +0100, Hans Verkuil wrote:
> On 12/03/2014 12:14 PM, Sakari Ailus wrote:
> > From: Aviv Greenberg <aviv.d.greenberg@intel.com>
> > 
> > These formats are just like 10-bit raw bayer formats that exist already, but
> > the pixels are not padded to byte boundaries. Instead, the eight high order
> > bits of four consecutive pixels are stored in four bytes, followed by a byte
> > of two low order bits of each of the four pixels.
> > 
> > Signed-off-by: Aviv Greenberg <aviv.d.greenberg@intel.com>
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> >  .../DocBook/media/v4l/pixfmt-srggb10p.xml          | 83 ++++++++++++++++++++++
> >  Documentation/DocBook/media/v4l/pixfmt.xml         |  1 +
> >  include/uapi/linux/videodev2.h                     |  5 ++
> >  3 files changed, 89 insertions(+)
> >  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-srggb10p.xml
> > 
> > diff --git a/Documentation/DocBook/media/v4l/pixfmt-srggb10p.xml b/Documentation/DocBook/media/v4l/pixfmt-srggb10p.xml
> > new file mode 100644
> > index 0000000..3e88d8d
> > --- /dev/null
> > +++ b/Documentation/DocBook/media/v4l/pixfmt-srggb10p.xml
> > @@ -0,0 +1,83 @@
> > +    <refentry id="pixfmt-srggb10p">
> > +      <refmeta>
> > +	<refentrytitle>V4L2_PIX_FMT_SRGGB10P ('pRAA'),
> > +	 V4L2_PIX_FMT_SGRBG10P ('pgAA'),
> > +	 V4L2_PIX_FMT_SGBRG10P ('pGAA'),
> > +	 V4L2_PIX_FMT_SBGGR10P ('pBAA'),
> > +	 </refentrytitle>
> > +	&manvol;
> > +      </refmeta>
> > +      <refnamediv>
> > +	<refname id="V4L2-PIX-FMT-SRGGB10P"><constant>V4L2_PIX_FMT_SRGGB10P</constant></refname>
> > +	<refname id="V4L2-PIX-FMT-SGRBG10P"><constant>V4L2_PIX_FMT_SGRBG10P</constant></refname>
> > +	<refname id="V4L2-PIX-FMT-SGBRG10P"><constant>V4L2_PIX_FMT_SGBRG10P</constant></refname>
> > +	<refname id="V4L2-PIX-FMT-SBGGR10P"><constant>V4L2_PIX_FMT_SBGGR10P</constant></refname>
> > +	<refpurpose>10-bit packed Bayer formats</refpurpose>
> > +      </refnamediv>
> > +      <refsect1>
> > +	<title>Description</title>
> > +
> > +	<para>The following four pixel formats are packed raw sRGB /
> > +	Bayer formats with 10 bits per colour. Every four consequtive
> 
> Typo: consecutive
> 
> > +	colour components are packed into 5 bytes such that each of
> > +	the first 4 bytes contain their 8 high bits, and the fifth
> > +	byte contains 4 groups of 2 their low bits. Bytes are stored
> > +	in memory in little endian order.</para>
> > +
> > +	<para>Each n-pixel row contains n/2 green samples and n/2 blue
> > +	or red samples, with alternating green-red and green-blue
> > +	rows. They are conventionally described as GRGR... BGBG...,
> > +	RGRG... GBGB..., etc. Below is an example of one of these
> > +	formats</para>
> 
> s/formats/formats:/

Will fix the two.

> > +
> > +    <example>
> > +      <title><constant>V4L2_PIX_FMT_SBGGR10P</constant> 4 &times; 4
> > +      pixel image</title>
> > +
> > +      <formalpara>
> > +	<title>Byte Order.</title>
> > +	<para>Each cell is one byte.
> > +	  <informaltable frame="none">
> > +	    <tgroup cols="5" align="center">
> > +	      <colspec align="left" colwidth="2*" />
> > +	      <tbody valign="top">
> > +		<row>
> > +		  <entry>start&nbsp;+&nbsp;0:</entry>
> > +		  <entry>B<subscript>00high</subscript></entry>
> > +		  <entry>G<subscript>01high</subscript></entry>
> > +		  <entry>B<subscript>02high</subscript></entry>
> > +		  <entry>G<subscript>03high</subscript></entry>
> > +		  <entry>B+G<subscript>0-3low</subscript></entry>
> > +		</row>
> > +		<row>
> > +		  <entry>start&nbsp;+&nbsp;5:</entry>
> > +		  <entry>G<subscript>04high</subscript></entry>
> > +		  <entry>R<subscript>05high</subscript></entry>
> > +		  <entry>G<subscript>06high</subscript></entry>
> > +		  <entry>R<subscript>07high</subscript></entry>
> > +		  <entry>G+R<subscript>4-7low</subscript></entry>
> > +		</row>
> > +		<row>
> > +		  <entry>start&nbsp;+&nbsp;10:</entry>
> > +		  <entry>B<subscript>08high</subscript></entry>
> > +		  <entry>G<subscript>09high</subscript></entry>
> > +		  <entry>B<subscript>10high</subscript></entry>
> > +		  <entry>G<subscript>11high</subscript></entry>
> > +		  <entry>B+G<subscript>8-11low</subscript></entry>
> > +		</row>
> > +		<row>
> > +          <entry>start&nbsp;+&nbsp;15:</entry>
> > +		  <entry>G<subscript>12high</subscript></entry>
> > +		  <entry>R<subscript>13high</subscript></entry>
> > +		  <entry>G<subscript>14high</subscript></entry>
> > +		  <entry>R<subscript>15high</subscript></entry>
> > +		  <entry>G+R<subscript>12-15low</subscript></entry>
> > +		</row>
> > +	      </tbody>
> > +	    </tgroup>
> > +	  </informaltable>
> > +	</para>
> > +      </formalpara>
> > +    </example>
> > +  </refsect1>
> > +</refentry>
> > diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
> > index df5b23d..5a83d9c 100644
> > --- a/Documentation/DocBook/media/v4l/pixfmt.xml
> > +++ b/Documentation/DocBook/media/v4l/pixfmt.xml
> > @@ -716,6 +716,7 @@ access the palette, this must be done with ioctls of the Linux framebuffer API.<
> >      &sub-srggb10alaw8;
> >      &sub-srggb10dpcm8;
> >      &sub-srggb12;
> > +    &sub-srggb10p;

I'll bump this up as well.

> >    </section>
> >  
> >    <section id="yuv-formats">
> > diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> > index e9806c6..faba23a 100644
> > --- a/include/uapi/linux/videodev2.h
> > +++ b/include/uapi/linux/videodev2.h
> > @@ -402,6 +402,11 @@ struct v4l2_pix_format {
> >  #define V4L2_PIX_FMT_SGBRG10DPCM8 v4l2_fourcc('b', 'G', 'A', '8')
> >  #define V4L2_PIX_FMT_SGRBG10DPCM8 v4l2_fourcc('B', 'D', '1', '0')
> >  #define V4L2_PIX_FMT_SRGGB10DPCM8 v4l2_fourcc('b', 'R', 'A', '8')
> > +	/* 10bit raw bayer packed, 5 bytes for every 4 pixels */
> > +#define V4L2_PIX_FMT_SBGGR10P v4l2_fourcc('p', 'B', 'A', 'A')
> > +#define V4L2_PIX_FMT_SGBRG10P v4l2_fourcc('p', 'G', 'A', 'A')
> > +#define V4L2_PIX_FMT_SGRBG10P v4l2_fourcc('p', 'g', 'A', 'A')
> > +#define V4L2_PIX_FMT_SRGGB10P v4l2_fourcc('p', 'R', 'A', 'A')
> >  	/*
> >  	 * 10bit raw bayer, expanded to 16 bits
> >  	 * xxxxrrrrrrrrrrxxxxgggggggggg xxxxggggggggggxxxxbbbbbbbbbb...
> > 
> 
> After fixing those two typos you can add my:
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

I think I may separate this from the data_offset addition since there seems
to be more work and time needed on that side.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
