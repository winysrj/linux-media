Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-sn1nam01on0041.outbound.protection.outlook.com ([104.47.32.41]:43036
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755699AbeBPRCM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Feb 2018 12:02:12 -0500
Date: Fri, 16 Feb 2018 09:02:02 -0800
From: Hyun Kwon <hyun.kwon@xilinx.com>
To: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "laurent.pinchart@ideasonboard.com"
        <laurent.pinchart@ideasonboard.com>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        Hyun Kwon <hyunk@xilinx.com>,
        Satish Kumar Nagireddy <SATISHNA@xilinx.com>
Subject: Re: [PATCH v3 6/9] v4l: xilinx: dma: Update video format descriptor
Message-ID: <20180216170201.GC9665@smtp.xilinx.com>
References: <1518676956-19618-1-git-send-email-satishna@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1518676956-19618-1-git-send-email-satishna@xilinx.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2018-02-14 at 22:42:36 -0800, Satish Kumar Nagireddy wrote:
> This patch updates video format descriptor to help information
> viz., number of planes per color format and chroma sub sampling
> factors.
> 
> This commit adds the various 8-bit and 10-bit that are supported
> to the table queried by drivers.
> 
> Signed-off-by: Satish Kumar Nagireddy <satishna@xilinx.com>
> ---
>  drivers/media/platform/xilinx/xilinx-vip.c | 18 ++++++++++--------
>  drivers/media/platform/xilinx/xilinx-vip.h | 11 ++++++++++-
>  2 files changed, 20 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/media/platform/xilinx/xilinx-vip.c b/drivers/media/platform/xilinx/xilinx-vip.c
> index d306f44..51b7ef6 100644
> --- a/drivers/media/platform/xilinx/xilinx-vip.c
> +++ b/drivers/media/platform/xilinx/xilinx-vip.c
> @@ -27,22 +27,24 @@
>   */
>  
>  static const struct xvip_video_format xvip_video_formats[] = {
> +	{ XVIP_VF_YUV_420, 10, NULL, MEDIA_BUS_FMT_VYYUYY8_1X24,
> +	  1, 15, V4L2_PIX_FMT_XV15M, 2, 2, 1, 2, "4:2:0, 10-bit 2-plane non-cont" },

So is the pixel scaling from 8 bit to 10 bit done hardware? In long term, I think
pixel format should be separate from bus formats.

Then why is bpp 15 for this? I think it's average of bpp from multiple planes.
The format can be modeled more clearly with per plane information instead.

>  	{ XVIP_VF_YUV_422, 8, NULL, MEDIA_BUS_FMT_UYVY8_1X16,
> -	  2, V4L2_PIX_FMT_YUYV, "4:2:2, packed, YUYV" },
> +	  2, 16, V4L2_PIX_FMT_YUYV, 1, 1, 2, 1, "4:2:2, packed, YUYV" },
>  	{ XVIP_VF_YUV_444, 8, NULL, MEDIA_BUS_FMT_VUY8_1X24,
> -	  3, V4L2_PIX_FMT_YUV444, "4:4:4, packed, YUYV" },
> +	  3, 24, V4L2_PIX_FMT_VUY24, 1, 1, 1, 1, "4:4:4, packed, YUYV" },
>  	{ XVIP_VF_RBG, 8, NULL, MEDIA_BUS_FMT_RBG888_1X24,
> -	  3, V4L2_PIX_FMT_RGB24, "24-bit RGB" },
> +	  3, 24, V4L2_PIX_FMT_RGB24, 1, 1, 1, 1, "24-bit RGB" },
>  	{ XVIP_VF_MONO_SENSOR, 8, "mono", MEDIA_BUS_FMT_Y8_1X8,
> -	  1, V4L2_PIX_FMT_GREY, "Greyscale 8-bit" },
> +	  1, 8, V4L2_PIX_FMT_GREY, 1, 1, 1, 1, "Greyscale 8-bit" },
>  	{ XVIP_VF_MONO_SENSOR, 8, "rggb", MEDIA_BUS_FMT_SRGGB8_1X8,
> -	  1, V4L2_PIX_FMT_SGRBG8, "Bayer 8-bit RGGB" },
> +	  1, 8, V4L2_PIX_FMT_SGRBG8, 1, 1, 1, 1, "Bayer 8-bit RGGB" },
>  	{ XVIP_VF_MONO_SENSOR, 8, "grbg", MEDIA_BUS_FMT_SGRBG8_1X8,
> -	  1, V4L2_PIX_FMT_SGRBG8, "Bayer 8-bit GRBG" },
> +	  1, 8, V4L2_PIX_FMT_SGRBG8, 1, 1, 1, 1, "Bayer 8-bit GRBG" },
>  	{ XVIP_VF_MONO_SENSOR, 8, "gbrg", MEDIA_BUS_FMT_SGBRG8_1X8,
> -	  1, V4L2_PIX_FMT_SGBRG8, "Bayer 8-bit GBRG" },
> +	  1, 8, V4L2_PIX_FMT_SGBRG8, 1, 1, 1, 1, "Bayer 8-bit GBRG" },
>  	{ XVIP_VF_MONO_SENSOR, 8, "bggr", MEDIA_BUS_FMT_SBGGR8_1X8,
> -	  1, V4L2_PIX_FMT_SBGGR8, "Bayer 8-bit BGGR" },
> +	  1, 8, V4L2_PIX_FMT_SBGGR8, 1, 1, 1, 1, "Bayer 8-bit BGGR" },
>  };
>  
>  /**
> diff --git a/drivers/media/platform/xilinx/xilinx-vip.h b/drivers/media/platform/xilinx/xilinx-vip.h
> index 42fee20..006dcf77 100644
> --- a/drivers/media/platform/xilinx/xilinx-vip.h
> +++ b/drivers/media/platform/xilinx/xilinx-vip.h
> @@ -109,8 +109,12 @@ struct xvip_device {
>   * @width: AXI4 format width in bits per component
>   * @pattern: CFA pattern for Mono/Sensor formats
>   * @code: media bus format code
> - * @bpp: bytes per pixel (when stored in memory)

This member is still there.

> + * @bpl_factor: Bytes per line factor

'bpl_factor' is not needed in my opinion.

I think you meant to add bpp here. Then it seems like bpp definition is
changed to bits per pixel in the table, and that should come with changes
in code where it's used, ex, 'bpp' to 'bpp / 8'.

Thanks,
-hyun

>   * @fourcc: V4L2 pixel format FCC identifier
> + * @num_planes: number of planes w.r.t. color format
> + * @buffers: number of buffers per format
> + * @hsub: Horizontal sampling factor of Chroma
> + * @vsub: Vertical sampling factor of Chroma
>   * @description: format description, suitable for userspace
>   */
>  struct xvip_video_format {
> @@ -118,8 +122,13 @@ struct xvip_video_format {
>  	unsigned int width;
>  	const char *pattern;
>  	unsigned int code;
> +	unsigned int bpl_factor;
>  	unsigned int bpp;
>  	u32 fourcc;
> +	u8 num_planes;
> +	u8 buffers;
> +	u8 hsub;
> +	u8 vsub;
>  	const char *description;
>  };
>  
> -- 
> 2.7.4
> 
