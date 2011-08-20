Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:39002 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab1HTF0W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Aug 2011 01:26:22 -0400
Date: Sat, 20 Aug 2011 08:26:17 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] v4l: Add V4L2_PIX_FMT_NV24 and V4L2_PIX_FMT_NV42
 formats
Message-ID: <20110820052617.GJ8872@valkosipuli.localdomain>
References: <1313734460-7479-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313734460-7479-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the patch.

On Fri, Aug 19, 2011 at 08:14:20AM +0200, Laurent Pinchart wrote:
> NV24 and NV42 are planar YCbCr 4:4:4 and YCrCb 4:4:4 formats with a
> luma plane followed by an interleaved chroma plane.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  Documentation/DocBook/media/v4l/pixfmt-nv24.xml |  128 +++++++++++++++++++++++
>  Documentation/DocBook/media/v4l/pixfmt.xml      |    1 +
>  include/linux/videodev2.h                       |    2 +
>  3 files changed, 131 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-nv24.xml
> 
> This format will be used by an fbdev driver. I'm already posting the patch for
> for review and will send a pull request later.
> 
> diff --git a/Documentation/DocBook/media/v4l/pixfmt-nv24.xml b/Documentation/DocBook/media/v4l/pixfmt-nv24.xml
> new file mode 100644
> index 0000000..e77301d
> --- /dev/null
> +++ b/Documentation/DocBook/media/v4l/pixfmt-nv24.xml
> @@ -0,0 +1,128 @@
> +    <refentry>
> +      <refmeta>
> +	<refentrytitle>V4L2_PIX_FMT_NV24 ('NV24'), V4L2_PIX_FMT_NV42 ('NV42')</refentrytitle>
> +	&manvol;
> +      </refmeta>
> +      <refnamediv>
> +	<refname id="V4L2-PIX-FMT-NV24"><constant>V4L2_PIX_FMT_NV24</constant></refname>
> +	<refname id="V4L2-PIX-FMT-NV42"><constant>V4L2_PIX_FMT_NV42</constant></refname>
> +	<refpurpose>Formats with full horizontal and vertical
> +chroma resolutions, also known as YUV 4:4:4. One luminance and one
> +chrominance plane with alternating chroma samples as opposed to
> +<constant>V4L2_PIX_FMT_YVU420</constant></refpurpose>
> +      </refnamediv>
> +      <refsect1>
> +	<title>Description</title>
> +
> +	<para>These are two-plane versions of the YUV 4:4:4 format.
> +The three components are separated into two sub-images or planes. The
> +Y plane is first. The Y plane has one byte per pixel. For

Are all 8 bits being used per sample, or is there padding?

> +<constant>V4L2_PIX_FMT_NV24</constant>, a combined CbCr plane
> +immediately follows the Y plane in memory.  The CbCr plane is the same
> +width and height, in pixels, as the Y plane (and of the image).
> +Each line contains one CbCr pair per pixel.

How may bits / bytes per Cb / Cr sample? Perhaps you could mention this once
somewhere if all have the same.

> +<constant>V4L2_PIX_FMT_NV42</constant> is the same except the Cb and
> +Cr bytes are swapped, the CrCb plane starts with a Cr byte.</para>
> +	<para>If the Y plane has pad bytes after each row, then the
> +CbCr plane has twice as many pad bytes after its rows.</para>

[clip]

Cheers,

-- 
Sakari Ailus
sakari.ailus@iki.fi
