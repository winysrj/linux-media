Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54734 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751208Ab3G3LJj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Jul 2013 07:09:39 -0400
Date: Tue, 30 Jul 2013 14:09:34 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Katsuya MATSUBARA <matsu@igel.co.jp>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH v3 4/5] v4l: Add V4L2_PIX_FMT_NV16M and
 V4L2_PIX_FMT_NV61M formats
Message-ID: <20130730110934.GN12281@valkosipuli.retiisi.org.uk>
References: <1374757213-20194-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1374757213-20194-5-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374757213-20194-5-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 25, 2013 at 03:00:12PM +0200, Laurent Pinchart wrote:
> From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> 
> NV16M and NV61M are planar YCbCr 4:2:2 and YCrCb 4:2:2 formats with a
> luma plane followed by an interleaved chroma plane. The planes are not
> required to be contiguous in memory, and the formats can only be used
> with the multi-planar formats API.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> ---
>  Documentation/DocBook/media/v4l/pixfmt-nv16m.xml | 170 +++++++++++++++++++++++
>  Documentation/DocBook/media/v4l/pixfmt.xml       |   1 +
>  include/uapi/linux/videodev2.h                   |   2 +
>  3 files changed, 173 insertions(+)
>  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-nv16m.xml
> 
> diff --git a/Documentation/DocBook/media/v4l/pixfmt-nv16m.xml b/Documentation/DocBook/media/v4l/pixfmt-nv16m.xml
> new file mode 100644
> index 0000000..84a8bb3
> --- /dev/null
> +++ b/Documentation/DocBook/media/v4l/pixfmt-nv16m.xml
> @@ -0,0 +1,170 @@
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
> +The luminance data occupies the first plane. The Y plane has one byte per pixel.
> +In the second plane there is a chrominance data with alternating chroma samples.
> +The CbCr plane is the same width and height, in bytes, as the Y plane.
> +Each CbCr pair belongs to four pixels. For example,
> +Cb<subscript>0</subscript>/Cr<subscript>0</subscript> belongs to
> +Y'<subscript>00</subscript>, Y'<subscript>01</subscript>,
> +Y'<subscript>10</subscript>, Y'<subscript>11</subscript>.
> +<constant>V4L2_PIX_FMT_NV61M</constant> is the same as <constant>V4L2_PIX_FMT_NV16M</constant>
> +except the Cb and Cr bytes are swapped, the CrCb plane starts with a Cr byte.</para>
> +
> +	<para><constant>V4L2_PIX_FMT_NV16M</constant> is intended to be
> +used only in drivers and applications that support the multi-planar API,
> +described in <xref linkend="planar-apis"/>. </para>

I think you could refer to V4L2_PIX_FMT_NV61M or alternatively move the
sentence explaining V4L2_PIX_FMT_NV61M after the above. Up to you.

Reviewed-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
