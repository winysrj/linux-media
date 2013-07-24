Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f47.google.com ([209.85.214.47]:61210 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab3GXVXh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jul 2013 17:23:37 -0400
Message-ID: <51F045D4.4050705@gmail.com>
Date: Wed, 24 Jul 2013 23:23:32 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
CC: linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH v2 4/5] v4l: Add V4L2_PIX_FMT_NV16M and V4L2_PIX_FMT_NV61M
 formats
References: <1374072882-14598-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1374072882-14598-5-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1374072882-14598-5-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 07/17/2013 04:54 PM, Laurent Pinchart wrote:
> NV16M and NV61M are planar YCbCr 4:2:2 and YCrCb 4:2:2 formats with a
> luma plane followed by an interleaved chroma plane. The planes are not
> required to be contiguous in memory, and the formats can only be used
> with the multi-planar formats API.
>
> Signed-off-by: Laurent Pinchart<laurent.pinchart+renesas@ideasonboard.com>

Looks good,

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>	

Thanks,
Sylwester
> ---
>   Documentation/DocBook/media/v4l/pixfmt-nv16m.xml | 170 +++++++++++++++++++++++
>   Documentation/DocBook/media/v4l/pixfmt.xml       |   1 +
>   include/uapi/linux/videodev2.h                   |   2 +
>   3 files changed, 173 insertions(+)
>   create mode 100644 Documentation/DocBook/media/v4l/pixfmt-nv16m.xml
>
> diff --git a/Documentation/DocBook/media/v4l/pixfmt-nv16m.xml b/Documentation/DocBook/media/v4l/pixfmt-nv16m.xml
> new file mode 100644
> index 0000000..84a8bb3
> --- /dev/null
> +++ b/Documentation/DocBook/media/v4l/pixfmt-nv16m.xml
> @@ -0,0 +1,170 @@
> +<refentry>
> +<refmeta>
> +	<refentrytitle>V4L2_PIX_FMT_NV16M ('NM16'), V4L2_PIX_FMT_NV61M ('NM61')</refentrytitle>
> +	&manvol;
> +</refmeta>
> +<refnamediv>
> +	<refname id="V4L2-PIX-FMT-NV16M"><constant>V4L2_PIX_FMT_NV16M</constant></refname>
> +	<refname id="V4L2-PIX-FMT-NV61M"><constant>V4L2_PIX_FMT_NV61M</constant></refname>
> +	<refpurpose>Variation of<constant>V4L2_PIX_FMT_NV16</constant>  and<constant>V4L2_PIX_FMT_NV61</constant>  with planes
> +	  non contiguous in memory.</refpurpose>
> +</refnamediv>
> +<refsect1>
> +	<title>Description</title>
> +
> +	<para>This is a multi-planar, two-plane version of the YUV 4:2:0 format.
> +The three components are separated into two sub-images or planes.
> +<constant>V4L2_PIX_FMT_NV16M</constant>  differs from<constant>V4L2_PIX_FMT_NV16
> +</constant>  in that the two planes are non-contiguous in memory, i.e. the chroma
> +plane do not necessarily immediately follows the luma plane.
> +The luminance data occupies the first plane. The Y plane has one byte per pixel.
> +In the second plane there is a chrominance data with alternating chroma samples.
> +The CbCr plane is the same width and height, in bytes, as the Y plane.
> +Each CbCr pair belongs to four pixels. For example,
> +Cb<subscript>0</subscript>/Cr<subscript>0</subscript>  belongs to
> +Y'<subscript>00</subscript>, Y'<subscript>01</subscript>,
> +Y'<subscript>10</subscript>, Y'<subscript>11</subscript>.
> +<constant>V4L2_PIX_FMT_NV61M</constant>  is the same as<constant>V4L2_PIX_FMT_NV16M</constant>
> +except the Cb and Cr bytes are swapped, the CrCb plane starts with a Cr byte.</para>
> +
> +	<para><constant>V4L2_PIX_FMT_NV16M</constant>  is intended to be
> +used only in drivers and applications that support the multi-planar API,
> +described in<xref linkend="planar-apis"/>.</para>
> +
> +	<example>
> +	<title><constant>V4L2_PIX_FMT_NV16M</constant>  4&times; 4 pixel image</title>
> +
> +	<formalpara>
> +	<title>Byte Order.</title>
> +	<para>Each cell is one byte.
> +		<informaltable frame="none">
> +		<tgroup cols="5" align="center">
> +		<colspec align="left" colwidth="2*" />
> +		<tbody valign="top">
> +		<row>
> +		<entry>start0&nbsp;+&nbsp;0:</entry>
> +		<entry>Y'<subscript>00</subscript></entry>
> +		<entry>Y'<subscript>01</subscript></entry>
> +		<entry>Y'<subscript>02</subscript></entry>
> +		<entry>Y'<subscript>03</subscript></entry>
> +		</row>
> +		<row>
> +		<entry>start0&nbsp;+&nbsp;4:</entry>
> +		<entry>Y'<subscript>10</subscript></entry>
> +		<entry>Y'<subscript>11</subscript></entry>
> +		<entry>Y'<subscript>12</subscript></entry>
> +		<entry>Y'<subscript>13</subscript></entry>
> +		</row>
> +		<row>
> +		<entry>start0&nbsp;+&nbsp;8:</entry>
> +		<entry>Y'<subscript>20</subscript></entry>
> +		<entry>Y'<subscript>21</subscript></entry>
> +		<entry>Y'<subscript>22</subscript></entry>
> +		<entry>Y'<subscript>23</subscript></entry>
> +		</row>
> +		<row>
> +		<entry>start0&nbsp;+&nbsp;12:</entry>
> +		<entry>Y'<subscript>30</subscript></entry>
> +		<entry>Y'<subscript>31</subscript></entry>
> +		<entry>Y'<subscript>32</subscript></entry>
> +		<entry>Y'<subscript>33</subscript></entry>
> +		</row>
> +		<row>
> +		<entry></entry>
> +		</row>
> +		<row>
> +		<entry>start1&nbsp;+&nbsp;0:</entry>
> +		<entry>Cb<subscript>00</subscript></entry>
> +		<entry>Cr<subscript>00</subscript></entry>
> +		<entry>Cb<subscript>02</subscript></entry>
> +		<entry>Cr<subscript>02</subscript></entry>
> +		</row>
> +		<row>
> +		<entry>start1&nbsp;+&nbsp;4:</entry>
> +		<entry>Cb<subscript>10</subscript></entry>
> +		<entry>Cr<subscript>10</subscript></entry>
> +		<entry>Cb<subscript>12</subscript></entry>
> +		<entry>Cr<subscript>12</subscript></entry>
> +		</row>
> +		<row>
> +		<entry>start1&nbsp;+&nbsp;8:</entry>
> +		<entry>Cb<subscript>20</subscript></entry>
> +		<entry>Cr<subscript>20</subscript></entry>
> +		<entry>Cb<subscript>22</subscript></entry>
> +		<entry>Cr<subscript>22</subscript></entry>
> +		</row>
> +		<row>
> +		<entry>start1&nbsp;+&nbsp;12:</entry>
> +		<entry>Cb<subscript>30</subscript></entry>
> +		<entry>Cr<subscript>30</subscript></entry>
> +		<entry>Cb<subscript>32</subscript></entry>
> +		<entry>Cr<subscript>32</subscript></entry>
> +		</row>
> +		</tbody>
> +		</tgroup>
> +		</informaltable>
> +	</para>
> +	</formalpara>
> +
> +	<formalpara>
> +	<title>Color Sample Location.</title>
> +	<para>
> +		<informaltable frame="none">
> +		<tgroup cols="7" align="center">
> +		<tbody valign="top">
> +		<row>
> +		<entry></entry>
> +		<entry>0</entry><entry></entry><entry>1</entry><entry></entry>
> +		<entry>2</entry><entry></entry><entry>3</entry>
> +		</row>
> +		<row>
> +		<entry>0</entry>
> +		<entry>Y</entry><entry></entry><entry>Y</entry><entry></entry>
> +		<entry>Y</entry><entry></entry><entry>Y</entry>
> +		</row>
> +		<row>
> +		<entry></entry>
> +		<entry></entry><entry>C</entry><entry></entry><entry></entry>
> +		<entry></entry><entry>C</entry><entry></entry>
> +		</row>
> +		<row>
> +		<entry>1</entry>
> +		<entry>Y</entry><entry></entry><entry>Y</entry><entry></entry>
> +		<entry>Y</entry><entry></entry><entry>Y</entry>
> +		</row>
> +		<row>
> +		<entry></entry>
> +		<entry></entry><entry>C</entry><entry></entry><entry></entry>
> +		<entry></entry><entry>C</entry><entry></entry>
> +		</row>
> +		<row>
> +		<entry></entry>
> +		</row>
> +		<row>
> +		<entry>2</entry>
> +		<entry>Y</entry><entry></entry><entry>Y</entry><entry></entry>
> +		<entry>Y</entry><entry></entry><entry>Y</entry>
> +		</row>
> +		<row>
> +		<entry></entry>
> +		<entry></entry><entry>C</entry><entry></entry><entry></entry>
> +		<entry></entry><entry>C</entry><entry></entry>
> +		</row>
> +		<row>
> +		<entry>3</entry>
> +		<entry>Y</entry><entry></entry><entry>Y</entry><entry></entry>
> +		<entry>Y</entry><entry></entry><entry>Y</entry>
> +		</row>
> +		<row>
> +		<entry></entry>
> +		<entry></entry><entry>C</entry><entry></entry><entry></entry>
> +		<entry></entry><entry>C</entry><entry></entry>
> +		</row>
> +		</tbody>
> +		</tgroup>
> +		</informaltable>
> +	</para>
> +	</formalpara>
> +	</example>
> +</refsect1>
> +</refentry>
> diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
> index 99b8d2a..16db350 100644
> --- a/Documentation/DocBook/media/v4l/pixfmt.xml
> +++ b/Documentation/DocBook/media/v4l/pixfmt.xml
> @@ -718,6 +718,7 @@ information.</para>
>       &sub-nv12m;
>       &sub-nv12mt;
>       &sub-nv16;
> +&sub-nv16m;
>       &sub-nv24;
>       &sub-m420;
>     </section>
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 95ef455..fec0c20 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -348,6 +348,8 @@ struct v4l2_pix_format {
>   /* two non contiguous planes - one Y, one Cr + Cb interleaved  */
>   #define V4L2_PIX_FMT_NV12M   v4l2_fourcc('N', 'M', '1', '2') /* 12  Y/CbCr 4:2:0  */
>   #define V4L2_PIX_FMT_NV21M   v4l2_fourcc('N', 'M', '2', '1') /* 21  Y/CrCb 4:2:0  */
> +#define V4L2_PIX_FMT_NV16M   v4l2_fourcc('N', 'M', '1', '6') /* 16  Y/CbCr 4:2:2  */
> +#define V4L2_PIX_FMT_NV61M   v4l2_fourcc('N', 'M', '6', '1') /* 16  Y/CrCb 4:2:2  */
>   #define V4L2_PIX_FMT_NV12MT  v4l2_fourcc('T', 'M', '1', '2') /* 12  Y/CbCr 4:2:0 64x32 macroblocks */
>   #define V4L2_PIX_FMT_NV12MT_16X16 v4l2_fourcc('V', 'M', '1', '2') /* 12  Y/CbCr 4:2:0 16x16 macroblocks */
>
