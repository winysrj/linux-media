Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:50288 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755485Ab2CEHpj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Mar 2012 02:45:39 -0500
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: "'Sakari Ailus'" <sakari.ailus@iki.fi>
CC: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: RE: [PATCH v3 2/2] v4l2: add new pixel formats supported on dm365
Date: Mon, 5 Mar 2012 07:45:18 +0000
Message-ID: <E99FAA59F8D8D34D8A118DD37F7C8F7531759F0A@DBDE01.ent.ti.com>
References: <1328609114-5487-1-git-send-email-manjunath.hadli@ti.com>
 <1328609114-5487-3-git-send-email-manjunath.hadli@ti.com>
 <20120304151935.GA879@valkosipuli.localdomain>
In-Reply-To: <20120304151935.GA879@valkosipuli.localdomain>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sakari,

On Sun, Mar 04, 2012 at 20:49:36, Sakari Ailus wrote:
> Hi Manju,
> 
> Thanks for the patch.
> 
> On Tue, Feb 07, 2012 at 03:35:14PM +0530, Manjunath Hadli wrote:
> > add new macro V4L2_PIX_FMT_SGRBG10ALAW8 and associated formats to 
> > represent Bayer format frames compressed by A-LAW algorithm, add 
> > V4L2_PIX_FMT_UV8 to represent storage of C data (UV interleaved) only.
> > 
> > Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> > Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> >  .../DocBook/media/v4l/pixfmt-srggb10alaw8.xml      |   34 +++++++++++
> >  Documentation/DocBook/media/v4l/pixfmt-uv8.xml     |   62 ++++++++++++++++++++
> >  Documentation/DocBook/media/v4l/pixfmt.xml         |    2 +
> >  include/linux/videodev2.h                          |    9 +++
> >  4 files changed, 107 insertions(+), 0 deletions(-)  create mode 
> > 100644 Documentation/DocBook/media/v4l/pixfmt-srggb10alaw8.xml
> >  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-uv8.xml
> > 
> > diff --git a/Documentation/DocBook/media/v4l/pixfmt-srggb10alaw8.xml 
> > b/Documentation/DocBook/media/v4l/pixfmt-srggb10alaw8.xml
> > new file mode 100644
> > index 0000000..b20f525
> > --- /dev/null
> > +++ b/Documentation/DocBook/media/v4l/pixfmt-srggb10alaw8.xml
> > @@ -0,0 +1,34 @@
> > +	<refentry>
> > +	  <refmeta>
> > +	    <refentrytitle>
> > +	      V4L2_PIX_FMT_SRGGB10ALAW8 ('aRA8'),
> > +	      V4L2_PIX_FMT_SGBRG10ALAW8 ('aGA8'),
> > +	      V4L2_PIX_FMT_SGRBG10ALAW8 ('agA8'),
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
> 
> The order here is different than earlier.
  I had taken a reference from your v3 patch series (v4l: Add DPCM compressed formats). Do you want me to change it?

> 
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
> > b/Documentation/DocBook/media/v4l/pixfmt-uv8.xml
> > new file mode 100644
> > index 0000000..e3e6b11
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
> > +	    <para>In this format there is no Y plane, Only C plane. ie
> > +	    (UV interleaved)</para>
> 
> How about referring to "CbCr" instead of "C"?
Ok.
> 
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
> > b/Documentation/DocBook/media/v4l/pixfmt.xml
> > index 9ddc57c..0b62750 100644
> > --- a/Documentation/DocBook/media/v4l/pixfmt.xml
> > +++ b/Documentation/DocBook/media/v4l/pixfmt.xml
> > @@ -673,6 +673,7 @@ access the palette, this must be done with ioctls of the Linux framebuffer API.<
> >      &sub-srggb8;
> >      &sub-sbggr16;
> >      &sub-srggb10;
> > +    &sub-srggb10alaw8;
> >      &sub-srggb12;
> >    </section>
> >  
> > @@ -696,6 +697,7 @@ information.</para>
> >  
> >      &sub-packed-yuv;
> >      &sub-grey;
> > +    &sub-uv8;
> 
> I might put this between the Y' and the rest of the YUV formats.
Ok.
> 
> >      &sub-y10;
> >      &sub-y12;
> >      &sub-y10b;
> > diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h 
> > index 012a296..8e6b3f2 100644
> > --- a/include/linux/videodev2.h
> > +++ b/include/linux/videodev2.h
> > @@ -338,6 +338,9 @@ struct v4l2_pix_format {
> >  #define V4L2_PIX_FMT_HM12    v4l2_fourcc('H', 'M', '1', '2') /*  8  YUV 4:2:0 16x16 macroblocks */
> >  #define V4L2_PIX_FMT_M420    v4l2_fourcc('M', '4', '2', '0') /* 12  YUV 4:2:0 2 lines y, 1 line uv interleaved */
> >  
> > +/* Chrominance formats */
> > +#define V4L2_PIX_FMT_UV8      v4l2_fourcc('U', 'V', '8', ' ') /*  8  UV 4:4 */
> > +
> 
> Could you put this before "/* Luminance+Chrominance formats */", please?
Ok.
> 
> >  /* two planes -- one Y, one Cr + Cb interleaved  */
> >  #define V4L2_PIX_FMT_NV12    v4l2_fourcc('N', 'V', '1', '2') /* 12  Y/CbCr 4:2:0  */
> >  #define V4L2_PIX_FMT_NV21    v4l2_fourcc('N', 'V', '2', '1') /* 12  Y/CrCb 4:2:0  */
> > @@ -366,6 +369,12 @@ struct v4l2_pix_format {  #define 
> > V4L2_PIX_FMT_SRGGB12 v4l2_fourcc('R', 'G', '1', '2') /* 12  RGRG.. GBGB.. */
> >  	/* 10bit raw bayer DPCM compressed to 8 bits */  #define 
> > V4L2_PIX_FMT_SGRBG10DPCM8 v4l2_fourcc('B', 'D', '1', '0')
> > +	/* 10bit raw bayer a-law compressed to 8 bits */ #define 
> > +V4L2_PIX_FMT_SBGGR10ALAW8 v4l2_fourcc('a', 'B', 'A', '8') #define 
> > +V4L2_PIX_FMT_SGBRG10ALAW8 v4l2_fourcc('a', 'G', 'A', '8') #define 
> > +V4L2_PIX_FMT_SGRBG10ALAW8 v4l2_fourcc('a', 'g', 'A', '8') #define 
> > +V4L2_PIX_FMT_SRGGB10ALAW8 v4l2_fourcc('a', 'R', 'A', '8')
> > +
> 
> Could you rebase this on top of my patchset, this patch in particular:
Ok.


WBR,
--Manju

> 
> <URL:http://www.spinics.net/lists/linux-media/msg44871.html>
> 
> >  	/*
> >  	 * 10bit raw bayer, expanded to 16 bits
> >  	 * xxxxrrrrrrrrrrxxxxgggggggggg xxxxggggggggggxxxxbbbbbbbbbb...
> 
> Looks good in general, assuming these changes. I'd still like to have comments to the related patches from Hans and Laurent.
> 
> Kind regards,
> 
> --
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
> 

