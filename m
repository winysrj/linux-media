Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-by2nam03on0059.outbound.protection.outlook.com ([104.47.42.59]:29856
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751126AbeEAVXV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 1 May 2018 17:23:21 -0400
Date: Tue, 1 May 2018 14:23:01 -0700
From: Hyun Kwon <hyun.kwon@xilinx.com>
To: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "laurent.pinchart@ideasonboard.com"
        <laurent.pinchart@ideasonboard.com>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        Hyun Kwon <hyunk@xilinx.com>,
        Satish Kumar Nagireddy <SATISHNA@xilinx.com>
Subject: Re: [PATCH v4 08/10] v4l: xilinx: dma: Update video format descriptor
Message-ID: <20180501212301.GD9872@smtp.xilinx.com>
References: <cover.1524955156.git.satish.nagireddy.nagireddy@xilinx.com>
 <7df8c3d2e8b7d1de140adb7879ea262f2ec9a340.1524955156.git.satish.nagireddy.nagireddy@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <7df8c3d2e8b7d1de140adb7879ea262f2ec9a340.1524955156.git.satish.nagireddy.nagireddy@xilinx.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Satish,

Thanks for the patch.

On Mon, 2018-04-30 at 18:35:11 -0700, Satish Kumar Nagireddy wrote:
> This patch updates video format descriptor to help information
> viz., number of planes per color format and chroma sub sampling
> factors.
> 
> Signed-off-by: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
> ---
>  drivers/media/platform/xilinx/xilinx-dma.c | 12 ++++++------
>  drivers/media/platform/xilinx/xilinx-vip.c | 28 +++++++++++++++++++---------
>  drivers/media/platform/xilinx/xilinx-vip.h |  8 +++++++-
>  3 files changed, 32 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/platform/xilinx/xilinx-dma.c
> index 16aeb46..658586e 100644
> --- a/drivers/media/platform/xilinx/xilinx-dma.c
> +++ b/drivers/media/platform/xilinx/xilinx-dma.c
> @@ -366,7 +366,7 @@ static void xvip_dma_buffer_queue(struct vb2_buffer *vb)
>  	}
>  
>  	dma->xt.frame_size = 1;
> -	dma->sgl[0].size = dma->format.width * dma->fmtinfo->bpp;
> +	dma->sgl[0].size = dma->format.width * dma->fmtinfo->bpp[0];
>  	dma->sgl[0].icg = dma->format.bytesperline - dma->sgl[0].size;
>  	dma->xt.numf = dma->format.height;
>  
> @@ -569,12 +569,12 @@ __xvip_dma_try_format(struct xvip_dma *dma, struct v4l2_pix_format *pix,
>  	 * the minimum and maximum values, clamp the requested width and convert
>  	 * it back to pixels.
>  	 */
> -	align = lcm(dma->align, info->bpp);
> +	align = lcm(dma->align, info->bpp[0]);
>  	min_width = roundup(XVIP_DMA_MIN_WIDTH, align);
>  	max_width = rounddown(XVIP_DMA_MAX_WIDTH, align);
> -	width = rounddown(pix->width * info->bpp, align);
> +	width = rounddown(pix->width * info->bpp[0], align);
>  
> -	pix->width = clamp(width, min_width, max_width) / info->bpp;
> +	pix->width = clamp(width, min_width, max_width) / info->bpp[0];
>  	pix->height = clamp(pix->height, XVIP_DMA_MIN_HEIGHT,
>  			    XVIP_DMA_MAX_HEIGHT);
>  
> @@ -582,7 +582,7 @@ __xvip_dma_try_format(struct xvip_dma *dma, struct v4l2_pix_format *pix,
>  	 * line value is zero, the module doesn't support user configurable line
>  	 * sizes. Override the requested value with the minimum in that case.
>  	 */
> -	min_bpl = pix->width * info->bpp;
> +	min_bpl = pix->width * info->bpp[0];
>  	max_bpl = rounddown(XVIP_DMA_MAX_WIDTH, dma->align);
>  	bpl = rounddown(pix->bytesperline, dma->align);
>  
> @@ -676,7 +676,7 @@ int xvip_dma_init(struct xvip_composite_device *xdev, struct xvip_dma *dma,
>  	dma->format.field = V4L2_FIELD_NONE;
>  	dma->format.width = XVIP_DMA_DEF_WIDTH;
>  	dma->format.height = XVIP_DMA_DEF_HEIGHT;
> -	dma->format.bytesperline = dma->format.width * dma->fmtinfo->bpp;
> +	dma->format.bytesperline = dma->format.width * dma->fmtinfo->bpp[0];
>  	dma->format.sizeimage = dma->format.bytesperline * dma->format.height;
>  
>  	/* Initialize the media entity... */
> diff --git a/drivers/media/platform/xilinx/xilinx-vip.c b/drivers/media/platform/xilinx/xilinx-vip.c
> index 3112591..81cc0d2 100644
> --- a/drivers/media/platform/xilinx/xilinx-vip.c
> +++ b/drivers/media/platform/xilinx/xilinx-vip.c
> @@ -27,22 +27,32 @@
>   */
>  
>  static const struct xvip_video_format xvip_video_formats[] = {
> +	{ XVIP_VF_YUV_420, 8, NULL, MEDIA_BUS_FMT_VYYUYY8_1X24,
> +	  {1, 2, 0}, V4L2_PIX_FMT_NV12, 2, 2, 2, "4:2:0, semi-planar, YUV" },
> +	{ XVIP_VF_YUV_420, 10, NULL, MEDIA_BUS_FMT_VYYUYY8_1X24,
> +	  {1, 2, 0}, V4L2_PIX_FMT_XV15, 2, 2, 2, "4:2:0, 10-bit 2-plane cont" },
>  	{ XVIP_VF_YUV_422, 8, NULL, MEDIA_BUS_FMT_UYVY8_1X16,
> -	  2, V4L2_PIX_FMT_YUYV, "4:2:2, packed, YUYV" },
> -	{ XVIP_VF_YUV_444, 8, NULL, MEDIA_BUS_FMT_VUY8_1X24,
> -	  3, V4L2_PIX_FMT_YUV444, "4:4:4, packed, YUYV" },
> +	  {2, 0, 0}, V4L2_PIX_FMT_YUYV, 1, 2, 1, "4:2:2, packed, YUYV" },
> +	{ XVIP_VF_VUY_422, 8, NULL, MEDIA_BUS_FMT_UYVY8_1X16,
> +	  {2, 0, 0}, V4L2_PIX_FMT_UYVY, 1, 2, 1, "4:2:2, packed, UYVY" },
> +	{ XVIP_VF_YUV_422, 8, NULL, MEDIA_BUS_FMT_UYVY8_1X16,
> +	  {1, 2, 0}, V4L2_PIX_FMT_NV16, 2, 2, 1, "4:2:2, semi-planar, YUV" },
> +	{ XVIP_VF_YUV_422, 10, NULL, MEDIA_BUS_FMT_UYVY8_1X16,
> +	  {1, 2, 0}, V4L2_PIX_FMT_XV20, 2, 2, 1, "4:2:2, 10-bit 2-plane cont" },
> +	{ XVIP_VF_RBG, 8, NULL, MEDIA_BUS_FMT_RBG888_1X24,
> +	  {3, 0, 0}, V4L2_PIX_FMT_BGR24, 1, 1, 1, "24-bit RGB" },
>  	{ XVIP_VF_RBG, 8, NULL, MEDIA_BUS_FMT_RBG888_1X24,
> -	  3, 0, NULL },
> +	  {3, 0, 0}, V4L2_PIX_FMT_RGB24, 1, 1, 1, "24-bit RGB" },
>  	{ XVIP_VF_MONO_SENSOR, 8, "mono", MEDIA_BUS_FMT_Y8_1X8,
> -	  1, V4L2_PIX_FMT_GREY, "Greyscale 8-bit" },
> +	  {1, 0, 0}, V4L2_PIX_FMT_GREY, 1, 1, 1, "Greyscale 8-bit" },
>  	{ XVIP_VF_MONO_SENSOR, 8, "rggb", MEDIA_BUS_FMT_SRGGB8_1X8,
> -	  1, V4L2_PIX_FMT_SGRBG8, "Bayer 8-bit RGGB" },
> +	  {1, 0, 0}, V4L2_PIX_FMT_SGRBG8, 1, 1, 1, "Bayer 8-bit RGGB" },
>  	{ XVIP_VF_MONO_SENSOR, 8, "grbg", MEDIA_BUS_FMT_SGRBG8_1X8,
> -	  1, V4L2_PIX_FMT_SGRBG8, "Bayer 8-bit GRBG" },
> +	  {1, 0, 0}, V4L2_PIX_FMT_SGRBG8, 1, 1, 1, "Bayer 8-bit GRBG" },
>  	{ XVIP_VF_MONO_SENSOR, 8, "gbrg", MEDIA_BUS_FMT_SGBRG8_1X8,
> -	  1, V4L2_PIX_FMT_SGBRG8, "Bayer 8-bit GBRG" },
> +	  {1, 0, 0}, V4L2_PIX_FMT_SGBRG8, 1, 1, 1, "Bayer 8-bit GBRG" },
>  	{ XVIP_VF_MONO_SENSOR, 8, "bggr", MEDIA_BUS_FMT_SBGGR8_1X8,
> -	  1, V4L2_PIX_FMT_SBGGR8, "Bayer 8-bit BGGR" },
> +	  {1, 0, 0}, V4L2_PIX_FMT_SBGGR8, 1, 1, 1, "Bayer 8-bit BGGR" },
>  };
>  
>  /**
> diff --git a/drivers/media/platform/xilinx/xilinx-vip.h b/drivers/media/platform/xilinx/xilinx-vip.h
> index 42fee20..5e7a978 100644
> --- a/drivers/media/platform/xilinx/xilinx-vip.h
> +++ b/drivers/media/platform/xilinx/xilinx-vip.h
> @@ -111,6 +111,9 @@ struct xvip_device {
>   * @code: media bus format code
>   * @bpp: bytes per pixel (when stored in memory)

Better to mention 'bpp' is per plane.

>   * @fourcc: V4L2 pixel format FCC identifier
> + * @num_planes: number of planes w.r.t. color format
> + * @hsub: Horizontal sampling factor of Chroma
> + * @vsub: Vertical sampling factor of Chroma
>   * @description: format description, suitable for userspace
>   */
>  struct xvip_video_format {
> @@ -118,8 +121,11 @@ struct xvip_video_format {
>  	unsigned int width;
>  	const char *pattern;
>  	unsigned int code;
> -	unsigned int bpp;
> +	unsigned int bpp[3];

Hm, only first one is used here, even when this becomes an array.

Thanks,
-hyun

>  	u32 fourcc;
> +	u8 num_planes;
> +	u8 hsub;
> +	u8 vsub;
>  	const char *description;
>  };
>  
> -- 
> 2.1.1
> 
