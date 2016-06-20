Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:50040 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752285AbcFTPZz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2016 11:25:55 -0400
Subject: Re: [PATCH 3/6] v4l: Add packed Bayer raw12 pixel formats
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org
References: <1464353080-18300-1-git-send-email-sakari.ailus@linux.intel.com>
 <1464353080-18300-4-git-send-email-sakari.ailus@linux.intel.com>
Cc: g.liakhovetski@gmx.de
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <576809F1.1010507@xs4all.nl>
Date: Mon, 20 Jun 2016 17:21:21 +0200
MIME-Version: 1.0
In-Reply-To: <1464353080-18300-4-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/27/2016 02:44 PM, Sakari Ailus wrote:
> These formats are compressed 12-bit raw bayer formats with four different
> pixel orders. They are similar to 10-bit variants. The formats added by
> this patch are
> 
> 	V4L2_PIX_FMT_SBGGR12P
> 	V4L2_PIX_FMT_SGBRG12P
> 	V4L2_PIX_FMT_SGRBG12P
> 	V4L2_PIX_FMT_SRGGB12P
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  .../DocBook/media/v4l/pixfmt-srggb12p.xml          | 103 +++++++++++++++++++++
>  Documentation/DocBook/media/v4l/pixfmt.xml         |   1 +
>  include/uapi/linux/videodev2.h                     |   5 +
>  3 files changed, 109 insertions(+)
>  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-srggb12p.xml
> 
> diff --git a/Documentation/DocBook/media/v4l/pixfmt-srggb12p.xml b/Documentation/DocBook/media/v4l/pixfmt-srggb12p.xml
> new file mode 100644
> index 0000000..affa366
> --- /dev/null
> +++ b/Documentation/DocBook/media/v4l/pixfmt-srggb12p.xml
> @@ -0,0 +1,103 @@
> +    <refentry id="pixfmt-srggb12p">
> +      <refmeta>
> +	<refentrytitle>V4L2_PIX_FMT_SRGGB12P ('pRCC'),
> +	 V4L2_PIX_FMT_SGRBG12P ('pgCC'),
> +	 V4L2_PIX_FMT_SGBRG12P ('pGCC'),
> +	 V4L2_PIX_FMT_SBGGR12P ('pBCC'),

Nitpick: the last comma should be removed otherwise the title would end with it.

Looks good otherwise.

With the comma removed:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> +	 </refentrytitle>
> +	&manvol;
> +      </refmeta>
> +      <refnamediv>
> +	<refname id="V4L2-PIX-FMT-SRGGB12P"><constant>V4L2_PIX_FMT_SRGGB12P</constant></refname>
> +	<refname id="V4L2-PIX-FMT-SGRBG12P"><constant>V4L2_PIX_FMT_SGRBG12P</constant></refname>
> +	<refname id="V4L2-PIX-FMT-SGBRG12P"><constant>V4L2_PIX_FMT_SGBRG12P</constant></refname>
> +	<refname id="V4L2-PIX-FMT-SBGGR12P"><constant>V4L2_PIX_FMT_SBGGR12P</constant></refname>
> +	<refpurpose>12-bit packed Bayer formats</refpurpose>
> +      </refnamediv>
> +      <refsect1>
> +	<title>Description</title>
> +
> +	<para>These four pixel formats are packed raw sRGB / Bayer
> +	formats with 12 bits per colour. Every four consecutive colour
> +	components are packed into 6 bytes. Each of the first 4 bytes
> +	contain the 8 high order bits of the pixels, and the fifth and
> +	sixth bytes contains the four least significants bits of each
> +	pixel, in the same order.</para>
> +
> +	<para>Each n-pixel row contains n/2 green samples and n/2 blue
> +	or red samples, with alternating green-red and green-blue
> +	rows. They are conventionally described as GRGR... BGBG...,
> +	RGRG... GBGB..., etc. Below is an example of one of these
> +	formats:</para>
> +
> +    <example>
> +      <title><constant>V4L2_PIX_FMT_SBGGR12P</constant> 4 &times; 4
> +      pixel image</title>
> +
> +      <formalpara>
> +	<title>Byte Order.</title>
> +	<para>Each cell is one byte.
> +	  <informaltable frame="topbot" colsep="1" rowsep="1">
> +	    <tgroup cols="6" align="center">
> +	      <colspec align="left" colwidth="2*" />
> +	      <tbody valign="top">
> +		<row>
> +		  <entry>start&nbsp;+&nbsp;0:</entry>
> +		  <entry>B<subscript>00high</subscript></entry>
> +		  <entry>G<subscript>01high</subscript></entry>
> +		  <entry>G<subscript>01low</subscript>(bits 7--4)
> +			 B<subscript>00low</subscript>(bits 3--0)
> +		  </entry>
> +		  <entry>B<subscript>02high</subscript></entry>
> +		  <entry>G<subscript>03high</subscript></entry>
> +		  <entry>G<subscript>03low</subscript>(bits 7--4)
> +			 B<subscript>02low</subscript>(bits 3--0)
> +		  </entry>
> +		</row>
> +		<row>
> +		  <entry>start&nbsp;+&nbsp;6:</entry>
> +		  <entry>G<subscript>10high</subscript></entry>
> +		  <entry>R<subscript>11high</subscript></entry>
> +		  <entry>R<subscript>11low</subscript>(bits 7--4)
> +			 G<subscript>10low</subscript>(bits 3--0)
> +		  </entry>
> +		  <entry>G<subscript>12high</subscript></entry>
> +		  <entry>R<subscript>13high</subscript></entry>
> +		  <entry>R<subscript>13low</subscript>(bits 7--4)
> +			 G<subscript>12low</subscript>(bits 3--0)
> +		  </entry>
> +		</row>
> +		<row>
> +		  <entry>start&nbsp;+&nbsp;12:</entry>
> +		  <entry>B<subscript>20high</subscript></entry>
> +		  <entry>G<subscript>21high</subscript></entry>
> +		  <entry>G<subscript>21low</subscript>(bits 7--4)
> +			 B<subscript>20low</subscript>(bits 3--0)
> +		  </entry>
> +		  <entry>B<subscript>22high</subscript></entry>
> +		  <entry>G<subscript>23high</subscript></entry>
> +		  <entry>G<subscript>23low</subscript>(bits 7--4)
> +			 B<subscript>22low</subscript>(bits 3--0)
> +		  </entry>
> +		</row>
> +		<row>
> +		  <entry>start&nbsp;+&nbsp;18:</entry>
> +		  <entry>G<subscript>30high</subscript></entry>
> +		  <entry>R<subscript>31high</subscript></entry>
> +		  <entry>R<subscript>31low</subscript>(bits 7--4)
> +			 G<subscript>30low</subscript>(bits 3--0)
> +		  </entry>
> +		  <entry>G<subscript>32high</subscript></entry>
> +		  <entry>R<subscript>33high</subscript></entry>
> +		  <entry>R<subscript>33low</subscript>(bits 7--4)
> +			 G<subscript>32low</subscript>(bits 3--0)
> +		  </entry>
> +		</row>
> +	      </tbody>
> +	    </tgroup>
> +	  </informaltable>
> +	</para>
> +      </formalpara>
> +    </example>
> +  </refsect1>
> +</refentry>
> diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
> index 5a08aee..457337e 100644
> --- a/Documentation/DocBook/media/v4l/pixfmt.xml
> +++ b/Documentation/DocBook/media/v4l/pixfmt.xml
> @@ -1593,6 +1593,7 @@ access the palette, this must be done with ioctls of the Linux framebuffer API.<
>      &sub-srggb10alaw8;
>      &sub-srggb10dpcm8;
>      &sub-srggb12;
> +    &sub-srggb12p;
>    </section>
>  
>    <section id="yuv-formats">
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 8f95191..7ace868 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -576,6 +576,11 @@ struct v4l2_pix_format {
>  #define V4L2_PIX_FMT_SGBRG12 v4l2_fourcc('G', 'B', '1', '2') /* 12  GBGB.. RGRG.. */
>  #define V4L2_PIX_FMT_SGRBG12 v4l2_fourcc('B', 'A', '1', '2') /* 12  GRGR.. BGBG.. */
>  #define V4L2_PIX_FMT_SRGGB12 v4l2_fourcc('R', 'G', '1', '2') /* 12  RGRG.. GBGB.. */
> +	/* 12bit raw bayer packed, 6 bytes for every 4 pixels */
> +#define V4L2_PIX_FMT_SBGGR12P v4l2_fourcc('p', 'B', 'C', 'C')
> +#define V4L2_PIX_FMT_SGBRG12P v4l2_fourcc('p', 'G', 'C', 'C')
> +#define V4L2_PIX_FMT_SGRBG12P v4l2_fourcc('p', 'g', 'C', 'C')
> +#define V4L2_PIX_FMT_SRGGB12P v4l2_fourcc('p', 'R', 'C', 'C')
>  #define V4L2_PIX_FMT_SBGGR16 v4l2_fourcc('B', 'Y', 'R', '2') /* 16  BGBG.. GRGR.. */
>  
>  /* compressed formats */
> 
