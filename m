Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43734 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab1LONAb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 08:00:31 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Manjunath Hadli <manjunath.hadli@ti.com>
Subject: Re: [PATCH 2/2] v4l2: add new pixel formats supported on dm365
Date: Thu, 15 Dec 2011 14:00:47 +0100
Cc: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
References: <1323951898-16330-1-git-send-email-manjunath.hadli@ti.com> <1323951898-16330-3-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1323951898-16330-3-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201112151400.48321.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Manjunath,

Thanks for the patch.

On Thursday 15 December 2011 13:24:58 Manjunath Hadli wrote:
> add new macro V4L2_PIX_FMT_SGRBG10ALAW8 to represent Bayer format
> frames compressed by A-LAW alogorithm.
> add V4L2_PIX_FMT_UV8 to represent storage of C (UV interleved) only.
> 
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  include/linux/videodev2.h |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)

Could you please also document these formats in 
Documentation/DocBook/media/v4l ?

> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 4b752d5..969112d 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -338,6 +338,9 @@ struct v4l2_pix_format {
>  #define V4L2_PIX_FMT_HM12    v4l2_fourcc('H', 'M', '1', '2') /*  8  YUV
> 4:2:0 16x16 macroblocks */ #define V4L2_PIX_FMT_M420    v4l2_fourcc('M',
> '4', '2', '0') /* 12  YUV 4:2:0 2 lines y, 1 line uv interleaved */
> 
> +/* Chrominance formats */
> +#define V4L2_PIX_FMT_UV8      v4l2_fourcc('U', 'V', '8', ' ') /*  8  UV
> 4:4 */ +
>  /* two planes -- one Y, one Cr + Cb interleaved  */
>  #define V4L2_PIX_FMT_NV12    v4l2_fourcc('N', 'V', '1', '2') /* 12  Y/CbCr
> 4:2:0  */ #define V4L2_PIX_FMT_NV21    v4l2_fourcc('N', 'V', '2', '1') /*
> 12  Y/CrCb 4:2:0  */ @@ -366,6 +369,9 @@ struct v4l2_pix_format {
>  #define V4L2_PIX_FMT_SRGGB12 v4l2_fourcc('R', 'G', '1', '2') /* 12  RGRG..
> GBGB.. */ /* 10bit raw bayer DPCM compressed to 8 bits */
>  #define V4L2_PIX_FMT_SGRBG10DPCM8 v4l2_fourcc('B', 'D', '1', '0')
> +	/* 10bit raw bayer a-law compressed to 8 bits */
> +#define V4L2_PIX_FMT_SGRBG10ALAW8 v4l2_fourcc('A', 'L', 'W', '8')
> +

That's not very future-proof, how would you describe SGBRG10ALAW8 for instance 
?

Maybe it's time to standardize FOURCCs for Bayer new formats. We have 4 
characters, we could start with 'B' to denote Bayer, followed by one character 
for the order, one for the compression, and one for the number of bits.

>  	/*
>  	 * 10bit raw bayer, expanded to 16 bits
>  	 * xxxxrrrrrrrrrrxxxxgggggggggg xxxxggggggggggxxxxbbbbbbbbbb...

-- 
Regards,

Laurent Pinchart
