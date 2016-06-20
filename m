Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:48749 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754042AbcFTP3z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2016 11:29:55 -0400
Subject: Re: [PATCH 6/6] v4l: Add packed Bayer raw14 pixel formats
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org
References: <1464353080-18300-1-git-send-email-sakari.ailus@linux.intel.com>
 <1464353080-18300-7-git-send-email-sakari.ailus@linux.intel.com>
Cc: g.liakhovetski@gmx.de
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <57680BDB.7070608@xs4all.nl>
Date: Mon, 20 Jun 2016 17:29:31 +0200
MIME-Version: 1.0
In-Reply-To: <1464353080-18300-7-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/27/2016 02:44 PM, Sakari Ailus wrote:
> These formats are compressed 14-bit raw bayer formats with four different
> pixel orders. They are similar to 10-bit variants. The formats added by
> this patch are
> 
> 	V4L2_PIX_FMT_SBGGR14P
> 	V4L2_PIX_FMT_SGBRG14P
> 	V4L2_PIX_FMT_SGRBG14P
> 	V4L2_PIX_FMT_SRGGB14P
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  .../DocBook/media/v4l/pixfmt-srggb14p.xml          | 118 +++++++++++++++++++++
>  Documentation/DocBook/media/v4l/pixfmt.xml         |   1 +
>  include/uapi/linux/videodev2.h                     |   5 +
>  3 files changed, 124 insertions(+)
>  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-srggb14p.xml
> 
> diff --git a/Documentation/DocBook/media/v4l/pixfmt-srggb14p.xml b/Documentation/DocBook/media/v4l/pixfmt-srggb14p.xml
> new file mode 100644
> index 0000000..ecb06ef
> --- /dev/null
> +++ b/Documentation/DocBook/media/v4l/pixfmt-srggb14p.xml
> @@ -0,0 +1,118 @@
> +    <refentry id="pixfmt-srggb14p">
> +      <refmeta>
> +	<refentrytitle>V4L2_PIX_FMT_SRGGB14P ('pREE'),
> +	 V4L2_PIX_FMT_SGRBG14P ('pgEE'),
> +	 V4L2_PIX_FMT_SGBRG14P ('pGEE'),
> +	 V4L2_PIX_FMT_SBGGR14P ('pBEE'),

Again comma too many.

> +	 </refentrytitle>
> +	&manvol;
> +      </refmeta>
> +      <refnamediv>
> +	<refname id="V4L2-PIX-FMT-SRGGB14P"><constant>V4L2_PIX_FMT_SRGGB14P</constant></refname>
> +	<refname id="V4L2-PIX-FMT-SGRBG14P"><constant>V4L2_PIX_FMT_SGRBG14P</constant></refname>
> +	<refname id="V4L2-PIX-FMT-SGBRG14P"><constant>V4L2_PIX_FMT_SGBRG14P</constant></refname>
> +	<refname id="V4L2-PIX-FMT-SBGGR14P"><constant>V4L2_PIX_FMT_SBGGR14P</constant></refname>
> +	<refpurpose>14-bit packed Bayer formats</refpurpose>
> +      </refnamediv>
> +      <refsect1>
> +	<title>Description</title>
> +
> +	<para>These four pixel formats are packed raw sRGB / Bayer
> +	formats with 14 bits per colour. Every four consecutive colour
> +	components are packed into 7 bytes. Each of the first 4 bytes
> +	contain the 8 high order bits of the pixels, and the fifth, sixth
> +	and seventh bytes contains the six least significants bits of each

s/significants/significant/

After fixing this:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> +	pixel, in the same order.</para>
> +
> +	<para>Each n-pixel row contains n/2 green samples and n/2 blue
> +	or red samples, with alternating green-red and green-blue
> +	rows. They are conventionally described as GRGR... BGBG...,
> +	RGRG... GBGB..., etc. Below is an example of one of these
> +	formats:</para>
> +
> +    <example>
> +      <title><constant>V4L2_PIX_FMT_SBGGR14P</constant> 4 &times; 4
> +      pixel image</title>
> +
> +      <formalpara>
> +	<title>Byte Order.</title>
> +	<para>Each cell is one byte. The bits in subscript denote bits
> +	  of the sample. The bits of the cell byte can be found in
> +	  parentheses.
> +
> +	  <informaltable frame="topbot" colsep="1" rowsep="1">
> +	    <tgroup cols="7" align="center">
> +	      <colspec align="left" colwidth="2*" />
> +	      <tbody valign="top">
> +		<row>
> +		  <entry>start&nbsp;+&nbsp;0:</entry>
> +		  <entry>B<subscript>00 bits 13--8</subscript></entry>
> +		  <entry>G<subscript>01 bits 13--8</subscript></entry>
> +		  <entry>B<subscript>02 bits 13--8</subscript></entry>
> +		  <entry>G<subscript>03 bits 13--8</subscript></entry>
> +		  <entry>G<subscript>01 bits 1--0</subscript>(bits 7--6)
> +			 B<subscript>00 bits 5--0</subscript>(bits 5--0)
> +		  </entry>
> +		  <entry>B<subscript>02 bits 3--0</subscript>(bits 7--4)
> +			 G<subscript>01 bits 5--2</subscript>(bits 3--0)
> +		  </entry>
> +		  <entry>G<subscript>03 bits 5--0</subscript>(bits 7--2)
> +			 B<subscript>02 bits 5--4</subscript>(bits 1--0)
> +		  </entry>
> +		</row>
> +		<row>
> +		  <entry>start&nbsp;+&nbsp;7:</entry>
> +		  <entry>G<subscript>10 bits 13--8</subscript></entry>
> +		  <entry>R<subscript>11 bits 13--8</subscript></entry>
> +		  <entry>G<subscript>12 bits 13--8</subscript></entry>
> +		  <entry>R<subscript>13 bits 13--8</subscript></entry>
> +		  <entry>R<subscript>11 bits 1--0</subscript>(bits 7--6)
> +			 B<subscript>10 bits 5--0</subscript>(bits 5--0)
> +		  </entry>
> +		  <entry>R<subscript>12 bits 3--0</subscript>(bits 7--4)
> +			 G<subscript>11 bits 5--2</subscript>(bits 3--0)
> +		  </entry>
> +		  <entry>R<subscript>13 bits 5--0</subscript>(bits 7--2)
> +			 B<subscript>12 bits 5--4</subscript>(bits 1--0)
> +		  </entry>
> +		</row>
> +		<row>
> +		  <entry>start&nbsp;+&nbsp;14:</entry>
> +		  <entry>B<subscript>20 bits 13--8</subscript></entry>
> +		  <entry>G<subscript>21 bits 13--8</subscript></entry>
> +		  <entry>B<subscript>22 bits 13--8</subscript></entry>
> +		  <entry>G<subscript>23 bits 13--8</subscript></entry>
> +		  <entry>G<subscript>21 bits 1--0</subscript>(bits 7--6)
> +			 B<subscript>20 bits 5--0</subscript>(bits 5--0)
> +		  </entry>
> +		  <entry>B<subscript>22 bits 3--0</subscript>(bits 7--4)
> +			 G<subscript>21 bits 5--2</subscript>(bits 3--0)
> +		  </entry>
> +		  <entry>G<subscript>23 bits 5--0</subscript>(bits 7--2)
> +			 B<subscript>22 bits 5--4</subscript>(bits 1--0)
> +		  </entry>
> +		</row>
> +		<row>
> +		  <entry>start&nbsp;+&nbsp;21:</entry>
> +		  <entry>G<subscript>30 bits 13--8</subscript></entry>
> +		  <entry>R<subscript>31 bits 13--8</subscript></entry>
> +		  <entry>G<subscript>32 bits 13--8</subscript></entry>
> +		  <entry>R<subscript>33 bits 13--8</subscript></entry>
> +		  <entry>R<subscript>31 bits 1--0</subscript>(bits 7--6)
> +			 B<subscript>30 bits 5--0</subscript>(bits 5--0)
> +		  </entry>
> +		  <entry>R<subscript>32 bits 3--0</subscript>(bits 7--4)
> +			 G<subscript>31 bits 5--2</subscript>(bits 3--0)
> +		  </entry>
> +		  <entry>R<subscript>33 bits 5--0</subscript>(bits 7--2)
> +			 B<subscript>32 bits 5--4</subscript>(bits 1--0)
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
> index 29e9d7c..296a50a 100644
> --- a/Documentation/DocBook/media/v4l/pixfmt.xml
> +++ b/Documentation/DocBook/media/v4l/pixfmt.xml
> @@ -1595,6 +1595,7 @@ access the palette, this must be done with ioctls of the Linux framebuffer API.<
>      &sub-srggb12;
>      &sub-srggb12p;
>      &sub-srggb14;
> +    &sub-srggb14p;
>    </section>
>  
>    <section id="yuv-formats">
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 2c4b076..63d141e 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -585,6 +585,11 @@ struct v4l2_pix_format {
>  #define V4L2_PIX_FMT_SGBRG14 v4l2_fourcc('G', 'B', '1', '4') /* 14  GBGB.. RGRG.. */
>  #define V4L2_PIX_FMT_SGRBG14 v4l2_fourcc('B', 'A', '1', '4') /* 14  GRGR.. BGBG.. */
>  #define V4L2_PIX_FMT_SRGGB14 v4l2_fourcc('R', 'G', '1', '4') /* 14  RGRG.. GBGB.. */
> +	/* 14bit raw bayer packed, 7 bytes for every 4 pixels */
> +#define V4L2_PIX_FMT_SBGGR14P v4l2_fourcc('p', 'B', 'E', 'E')
> +#define V4L2_PIX_FMT_SGBRG14P v4l2_fourcc('p', 'G', 'E', 'E')
> +#define V4L2_PIX_FMT_SGRBG14P v4l2_fourcc('p', 'g', 'E', 'E')
> +#define V4L2_PIX_FMT_SRGGB14P v4l2_fourcc('p', 'R', 'E', 'E')
>  #define V4L2_PIX_FMT_SBGGR16 v4l2_fourcc('B', 'Y', 'R', '2') /* 16  BGBG.. GRGR.. */
>  
>  /* compressed formats */
> 
