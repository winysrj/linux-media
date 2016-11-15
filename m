Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:42996 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933957AbcKOVzU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Nov 2016 16:55:20 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] doc-rst: Specify raw bayer format variant used in the examples
Date: Tue, 15 Nov 2016 23:55:27 +0200
Message-ID: <2115656.8onqqhVbSa@avalon>
In-Reply-To: <1479246583-18789-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1479246583-18789-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Tuesday 15 Nov 2016 23:49:43 Sakari Ailus wrote:
> The documentation simply mentioned that one of the four pixel orders was
> used in the example. Now specify the exact pixelformat instead.
> 
> for i in pixfmt-s*.rst; do i=$i perl -i -pe '
> 	my $foo=$ENV{i};
> 	$foo =~ s/pixfmt-[a-z]+([0-9].*).rst/$1/;
> 	$foo = uc $foo;
> 	s/one of these formats/a small V4L2_PIX_FMT_SBGGR$foo image/' $i;
> done

Do we really need this in the commit message ? :-)

> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

As the patch applies on top of another one I took in my tree for the uvcvideo 
driver I've applied this one there as well.

> ---
>  Documentation/media/uapi/v4l/pixfmt-srggb10p.rst | 2 +-
>  Documentation/media/uapi/v4l/pixfmt-srggb12.rst  | 2 +-
>  Documentation/media/uapi/v4l/pixfmt-srggb16.rst  | 2 +-
>  Documentation/media/uapi/v4l/pixfmt-srggb8.rst   | 2 +-
>  4 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst
> b/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst index 9a41c8d..b6d426c
> 100644
> --- a/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst
> +++ b/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst
> @@ -28,7 +28,7 @@ bits of each pixel, in the same order.
>  Each n-pixel row contains n/2 green samples and n/2 blue or red samples,
>  with alternating green-red and green-blue rows. They are conventionally
>  described as GRGR... BGBG..., RGRG... GBGB..., etc. Below is an example
> -of one of these formats:
> +of a small V4L2_PIX_FMT_SBGGR10P image:
> 
>  **Byte Order.**
>  Each cell is one byte.
> diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb12.rst
> b/Documentation/media/uapi/v4l/pixfmt-srggb12.rst index a50ee14..15041e5
> 100644
> --- a/Documentation/media/uapi/v4l/pixfmt-srggb12.rst
> +++ b/Documentation/media/uapi/v4l/pixfmt-srggb12.rst
> @@ -26,7 +26,7 @@ high bits filled with zeros. Each n-pixel row contains n/2
> green samples and n/2 blue or red samples, with alternating red and blue
> rows. Bytes are stored in memory in little endian order. They are
> conventionally described as GRGR... BGBG..., RGRG... GBGB..., etc. Below is
> an example -of one of these formats:
> +of a small V4L2_PIX_FMT_SBGGR12 image:
> 
>  **Byte Order.**
>  Each cell is one byte, the 4 most significant bits in the high bytes are
> diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb16.rst
> b/Documentation/media/uapi/v4l/pixfmt-srggb16.rst index 06facc9..d407b2b
> 100644
> --- a/Documentation/media/uapi/v4l/pixfmt-srggb16.rst
> +++ b/Documentation/media/uapi/v4l/pixfmt-srggb16.rst
> @@ -22,7 +22,7 @@ sample. Each sample is stored in a 16-bit word. Each
> n-pixel row contains n/2 green samples and n/2 blue or red samples, with
> alternating red and blue rows. Bytes are stored in memory in little endian
> order. They are conventionally described as GRGR... BGBG..., RGRG...
> GBGB..., etc. Below is -an example of one of these formats:
> +an example of a small V4L2_PIX_FMT_SBGGR16 image:
> 
>  **Byte Order.**
>  Each cell is one byte.
> diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb8.rst
> b/Documentation/media/uapi/v4l/pixfmt-srggb8.rst index a3987d2..5ac25a6
> 100644
> --- a/Documentation/media/uapi/v4l/pixfmt-srggb8.rst
> +++ b/Documentation/media/uapi/v4l/pixfmt-srggb8.rst
> @@ -20,7 +20,7 @@ These four pixel formats are raw sRGB / Bayer formats with
> 8 bits per sample. Each sample is stored in a byte. Each n-pixel row
> contains n/2 green samples and n/2 blue or red samples, with alternating
> red and blue rows. They are conventionally described as GRGR... BGBG...,
> -RGRG... GBGB..., etc. Below is an example of one of these formats:
> +RGRG... GBGB..., etc. Below is an example of a small V4L2_PIX_FMT_SBGGR8
> image:
> 
>  **Byte Order.**
>  Each cell is one byte.

-- 
Regards,

Laurent Pinchart

