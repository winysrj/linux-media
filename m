Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4432 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758254Ab3HBJzK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Aug 2013 05:55:10 -0400
Message-ID: <51FB81E9.5090704@xs4all.nl>
Date: Fri, 02 Aug 2013 11:54:49 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
CC: linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Katsuya MATSUBARA <matsu@igel.co.jp>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH v5 6/9] v4l: Add V4L2_PIX_FMT_NV16M and V4L2_PIX_FMT_NV61M
 formats
References: <1375405408-17134-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1375405408-17134-7-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1375405408-17134-7-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 08/02/2013 03:03 AM, Laurent Pinchart wrote:
> NV16M and NV61M are planar YCbCr 4:2:2 and YCrCb 4:2:2 formats with a
> luma plane followed by an interleaved chroma plane. The planes are not
> required to be contiguous in memory, and the formats can only be used
> with the multi-planar formats API.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Reviewed-by: Sakari Ailus <sakari.ailus@iki.fi>

Just a few small changes below. Once that is corrected you can add my:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  Documentation/DocBook/media/v4l/pixfmt-nv16m.xml | 171 +++++++++++++++++++++++
>  Documentation/DocBook/media/v4l/pixfmt.xml       |   1 +
>  include/uapi/linux/videodev2.h                   |   2 +
>  3 files changed, 174 insertions(+)
>  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-nv16m.xml
> 
> diff --git a/Documentation/DocBook/media/v4l/pixfmt-nv16m.xml b/Documentation/DocBook/media/v4l/pixfmt-nv16m.xml
> new file mode 100644
> index 0000000..afec039
> --- /dev/null
> +++ b/Documentation/DocBook/media/v4l/pixfmt-nv16m.xml
> @@ -0,0 +1,171 @@
> +    <refentry>
> +      <refmeta>
> +	<refentrytitle>V4L2_PIX_FMT_NV16M ('NM16'), V4L2_PIX_FMT_NV61M ('NM61')</refentrytitle>
> +	&manvol;
> +      </refmeta>
> +      <refnamediv>
> +	<refname id="V4L2-PIX-FMT-NV16M"><constant>V4L2_PIX_FMT_NV16M</constant></refname>
> +	<refname id="V4L2-PIX-FMT-NV61M"><constant>V4L2_PIX_FMT_NV61M</constant></refname>
> +	<refpurpose>Variation of <constant>V4L2_PIX_FMT_NV16</constant> and <constant>V4L2_PIX_FMT_NV61</constant> with planes
> +	  non contiguous in memory. </refpurpose>
> +      </refnamediv>
> +      <refsect1>
> +	<title>Description</title>
> +
> +	<para>This is a multi-planar, two-plane version of the YUV 4:2:0 format.
> +The three components are separated into two sub-images or planes.
> +<constant>V4L2_PIX_FMT_NV16M</constant> differs from <constant>V4L2_PIX_FMT_NV16
> +</constant> in that the two planes are non-contiguous in memory, i.e. the chroma
> +plane do not necessarily immediately follows the luma plane.

s/do/does/

> +The luminance data occupies the first plane. The Y plane has one byte per pixel.
> +In the second plane there is a chrominance data with alternating chroma samples.

s/is a/is/

> +The CbCr plane is the same width and height, in bytes, as the Y plane.
> +Each CbCr pair belongs to four pixels. For example,
> +Cb<subscript>0</subscript>/Cr<subscript>0</subscript> belongs to
> +Y'<subscript>00</subscript>, Y'<subscript>01</subscript>,
> +Y'<subscript>10</subscript>, Y'<subscript>11</subscript>.
> +<constant>V4L2_PIX_FMT_NV61M</constant> is the same as <constant>V4L2_PIX_FMT_NV16M</constant>
> +except the Cb and Cr bytes are swapped, the CrCb plane starts with a Cr byte.</para>

Regards,

	Hans
