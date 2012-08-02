Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55516 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750983Ab2HBA3n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Aug 2012 20:29:43 -0400
Date: Thu, 2 Aug 2012 03:29:38 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Prabhakar Lad <prabhakar.lad@ti.com>
Cc: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v7 2/2] v4l2: add new pixel formats supported on dm365
Message-ID: <20120802002938.GN26642@valkosipuli.retiisi.org.uk>
References: <1343386505-8695-1-git-send-email-prabhakar.lad@ti.com>
 <1343386505-8695-3-git-send-email-prabhakar.lad@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343386505-8695-3-git-send-email-prabhakar.lad@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prabhakar,

Thanks for the patch.

On Fri, Jul 27, 2012 at 04:25:05PM +0530, Prabhakar Lad wrote:
> From: Manjunath Hadli <manjunath.hadli@ti.com>
> 
> add new macro V4L2_PIX_FMT_SGRBG10ALAW8 and associated formats
> to represent Bayer format frames compressed by A-LAW algorithm,
> add V4L2_PIX_FMT_UV8 to represent storage of CbCr data (UV interleaved)
> only.
> 
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Sakari Ailus <sakari.ailus@iki.fi>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>  .../DocBook/media/v4l/pixfmt-srggb10alaw8.xml      |   34 +++++++++++
>  Documentation/DocBook/media/v4l/pixfmt-uv8.xml     |   62 ++++++++++++++++++++
>  Documentation/DocBook/media/v4l/pixfmt.xml         |    2 +
>  include/linux/videodev2.h                          |    8 +++
>  4 files changed, 106 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-srggb10alaw8.xml
>  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-uv8.xml
> 
> diff --git a/Documentation/DocBook/media/v4l/pixfmt-srggb10alaw8.xml b/Documentation/DocBook/media/v4l/pixfmt-srggb10alaw8.xml
> new file mode 100644
> index 0000000..c934192
> --- /dev/null
> +++ b/Documentation/DocBook/media/v4l/pixfmt-srggb10alaw8.xml
> @@ -0,0 +1,34 @@
> +	<refentry>
> +	  <refmeta>
> +	    <refentrytitle>
> +	      V4L2_PIX_FMT_SBGGR10ALAW8 ('aBA8'),
> +	      V4L2_PIX_FMT_SGBRG10ALAW8 ('aGA8'),
> +	      V4L2_PIX_FMT_SGRBG10ALAW8 ('agA8'),
> +	      V4L2_PIX_FMT_SRGGB10ALAW8 ('aRA8'),
> +	    </refentrytitle>
> +	    &manvol;
> +	  </refmeta>
> +	  <refnamediv>
> +	    <refname id="V4L2-PIX-FMT-SBGGR10ALAW8">
> +	      <constant>V4L2_PIX_FMT_SBGGR10ALAW8</constant>
> +	    </refname>
> +	    <refname id="V4L2-PIX-FMT-SGBRG10ALAW8">
> +	      <constant>V4L2_PIX_FMT_SGBRG10ALAW8</constant>
> +	    </refname>
> +	    <refname id="V4L2-PIX-FMT-SGRBG10ALAW8">
> +	      <constant>V4L2_PIX_FMT_SGRBG10ALAW8</constant>
> +	    </refname>
> +	    <refname id="V4L2-PIX-FMT-SRGGB10ALAW8">
> +	      <constant>V4L2_PIX_FMT_SRGGB10ALAW8</constant>
> +	    </refname>
> +	    <refpurpose>10-bit Bayer formats compressed to 8 bits</refpurpose>
> +	  </refnamediv>
> +	  <refsect1>
> +	    <title>Description</title>
> +	    <para>The following four pixel formats are raw sRGB / Bayer
> +	    formats with 10 bits per color compressed to 8 bits each,
> +	    using the A-LAW algorithm. Each color component consumes 8
> +	    bits of memory. In other respects this format is similar to
> +	    <xref linkend="V4L2-PIX-FMT-SRGGB8">.</xref></para>
> +	  </refsect1>
> +	</refentry>
> diff --git a/Documentation/DocBook/media/v4l/pixfmt-uv8.xml b/Documentation/DocBook/media/v4l/pixfmt-uv8.xml
> new file mode 100644
> index 0000000..c507c1f
> --- /dev/null
> +++ b/Documentation/DocBook/media/v4l/pixfmt-uv8.xml
> @@ -0,0 +1,62 @@
> +	<refentry id="V4L2-PIX-FMT-UV8">
> +	  <refmeta>
> +	    <refentrytitle>V4L2_PIX_FMT_UV8  ('UV8')</refentrytitle>
> +	    &manvol;
> +	  </refmeta>
> +	  <refnamediv>
> +	    <refname><constant>V4L2_PIX_FMT_UV8</constant></refname>
> +	    <refpurpose>UV plane interleaved</refpurpose>
> +	  </refnamediv>
> +	  <refsect1>
> +	    <title>Description</title>
> +	    <para>In this format there is no Y plane, Only CbCr plane. ie
> +	    (UV interleaved)</para>
> +	    <example>
> +	    <title>
> +	      <constant>V4L2_PIX_FMT_UV8</constant>
> +	       pixel image
> +	    </title>
> +
> +	    <formalpara>
> +	      <title>Byte Order.</title>
> +	      <para>Each cell is one byte.
> +	        <informaltable frame="none">
> +	        <tgroup cols="5" align="center">
> +		  <colspec align="left" colwidth="2*" />
> +		  <tbody valign="top">
> +		    <row>
> +		      <entry>start&nbsp;+&nbsp;0:</entry>
> +		      <entry>Cb<subscript>00</subscript></entry>
> +		      <entry>Cr<subscript>00</subscript></entry>
> +		      <entry>Cb<subscript>01</subscript></entry>
> +		      <entry>Cr<subscript>01</subscript></entry>
> +		    </row>
> +		    <row>
> +		      <entry>start&nbsp;+&nbsp;4:</entry>
> +		      <entry>Cb<subscript>10</subscript></entry>
> +		      <entry>Cr<subscript>10</subscript></entry>
> +		      <entry>Cb<subscript>11</subscript></entry>
> +		      <entry>Cr<subscript>11</subscript></entry>
> +		    </row>
> +		    <row>
> +		      <entry>start&nbsp;+&nbsp;8:</entry>
> +		      <entry>Cb<subscript>20</subscript></entry>
> +		      <entry>Cr<subscript>20</subscript></entry>
> +		      <entry>Cb<subscript>21</subscript></entry>
> +		      <entry>Cr<subscript>21</subscript></entry>
> +		    </row>
> +		    <row>
> +		      <entry>start&nbsp;+&nbsp;12:</entry>
> +		      <entry>Cb<subscript>30</subscript></entry>
> +		      <entry>Cr<subscript>30</subscript></entry>
> +		      <entry>Cb<subscript>31</subscript></entry>
> +		      <entry>Cr<subscript>31</subscript></entry>
> +		    </row>
> +		  </tbody>
> +		</tgroup>
> +		</informaltable>
> +	      </para>
> +	      </formalpara>
> +	    </example>
> +	  </refsect1>
> +	</refentry>
> diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
> index e58934c..930f55d 100644
> --- a/Documentation/DocBook/media/v4l/pixfmt.xml
> +++ b/Documentation/DocBook/media/v4l/pixfmt.xml
> @@ -673,6 +673,7 @@ access the palette, this must be done with ioctls of the Linux framebuffer API.<
>      &sub-srggb8;
>      &sub-sbggr16;
>      &sub-srggb10;
> +    &sub-srggb10alaw8;
>      &sub-srggb10dpcm8;
>      &sub-srggb12;
>    </section>
> @@ -701,6 +702,7 @@ information.</para>
>      &sub-y12;
>      &sub-y10b;
>      &sub-y16;
> +    &sub-uv8;
>      &sub-yuyv;
>      &sub-uyvy;
>      &sub-yvyu;
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 5d78910..2cdf2c1 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -329,6 +329,9 @@ struct v4l2_pix_format {
>  /* Palette formats */
>  #define V4L2_PIX_FMT_PAL8    v4l2_fourcc('P', 'A', 'L', '8') /*  8  8-bit palette */
>  
> +/* Chrominance formats */
> +#define V4L2_PIX_FMT_UV8      v4l2_fourcc('U', 'V', '8', ' ') /*  8  UV 4:4 */

Is that an extra space I see on the line above? :)

Now that you're defining a new kind of a format, could you add a few lines
about it to Documentation/video4linux/4CCs.txt, please? That may be a
separate patch if you wish.

>  /* Luminance+Chrominance formats */
>  #define V4L2_PIX_FMT_YVU410  v4l2_fourcc('Y', 'V', 'U', '9') /*  9  YVU 4:1:0     */
>  #define V4L2_PIX_FMT_YVU420  v4l2_fourcc('Y', 'V', '1', '2') /* 12  YVU 4:2:0     */
> @@ -378,6 +381,11 @@ struct v4l2_pix_format {
>  #define V4L2_PIX_FMT_SGBRG12 v4l2_fourcc('G', 'B', '1', '2') /* 12  GBGB.. RGRG.. */
>  #define V4L2_PIX_FMT_SGRBG12 v4l2_fourcc('B', 'A', '1', '2') /* 12  GRGR.. BGBG.. */
>  #define V4L2_PIX_FMT_SRGGB12 v4l2_fourcc('R', 'G', '1', '2') /* 12  RGRG.. GBGB.. */
> +	/* 10bit raw bayer a-law compressed to 8 bits */
> +#define V4L2_PIX_FMT_SBGGR10ALAW8 v4l2_fourcc('a', 'B', 'A', '8')
> +#define V4L2_PIX_FMT_SGBRG10ALAW8 v4l2_fourcc('a', 'G', 'A', '8')
> +#define V4L2_PIX_FMT_SGRBG10ALAW8 v4l2_fourcc('a', 'g', 'A', '8')
> +#define V4L2_PIX_FMT_SRGGB10ALAW8 v4l2_fourcc('a', 'R', 'A', '8')
>  	/* 10bit raw bayer DPCM compressed to 8 bits */
>  #define V4L2_PIX_FMT_SBGGR10DPCM8 v4l2_fourcc('b', 'B', 'A', '8')
>  #define V4L2_PIX_FMT_SGBRG10DPCM8 v4l2_fourcc('b', 'G', 'A', '8')

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
