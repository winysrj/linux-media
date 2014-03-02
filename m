Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43157 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbaCBKat (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Mar 2014 05:30:49 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH] media DocBook: fix NV16M description.
Date: Sun, 02 Mar 2014 11:32:10 +0100
Message-ID: <6224050.YuhZzId860@avalon>
In-Reply-To: <5312FD30.3070908@xs4all.nl>
References: <5312FD30.3070908@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Sunday 02 March 2014 10:43:12 Hans Verkuil wrote:
> The NV16M description contained some copy-and-paste text from NV12M,
> suggesting that this format is a 4:2:0 format when it really is a
> 4:2:2 format.
> 
> Fixed the text.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  Documentation/DocBook/media/v4l/pixfmt-nv16m.xml | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/pixfmt-nv16m.xml
> b/Documentation/DocBook/media/v4l/pixfmt-nv16m.xml index c51d5a4..fb2b5e3
> 100644
> --- a/Documentation/DocBook/media/v4l/pixfmt-nv16m.xml
> +++ b/Documentation/DocBook/media/v4l/pixfmt-nv16m.xml
> @@ -12,18 +12,17 @@
>        <refsect1>
>  	<title>Description</title>
> 
> -	<para>This is a multi-planar, two-plane version of the YUV 4:2:0 format.
> +	<para>This is a multi-planar, two-plane version of the YUV 4:2:2 format.
>  The three components are separated into two sub-images or planes.
>  <constant>V4L2_PIX_FMT_NV16M</constant> differs from
> <constant>V4L2_PIX_FMT_NV16 </constant> in that the two planes are
> non-contiguous in memory, i.e. the chroma -plane does not necessarily
> immediately follows the luma plane.
> +plane does not necessarily immediately follow the luma plane.
>  The luminance data occupies the first plane. The Y plane has one byte per
> pixel. In the second plane there is chrominance data with alternating
> chroma samples. The CbCr plane is the same width and height, in bytes, as
> the Y plane. -Each CbCr pair belongs to four pixels. For example,
> +Each CbCr pair belongs to two pixels. For example,
>  Cb<subscript>0</subscript>/Cr<subscript>0</subscript> belongs to
> -Y'<subscript>00</subscript>, Y'<subscript>01</subscript>,
> -Y'<subscript>10</subscript>, Y'<subscript>11</subscript>.
> +Y'<subscript>00</subscript>, Y'<subscript>01</subscript>.
>  <constant>V4L2_PIX_FMT_NV61M</constant> is the same as
> <constant>V4L2_PIX_FMT_NV16M</constant> except the Cb and Cr bytes are
> swapped, the CrCb plane starts with a Cr byte.</para>

-- 
Regards,

Laurent Pinchart

