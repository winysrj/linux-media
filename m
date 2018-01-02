Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60808 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752579AbeABLLm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 2 Jan 2018 06:11:42 -0500
Date: Tue, 2 Jan 2018 13:11:39 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: tian.shu.qiu@intel.com
Cc: linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH] yavta: Add support for intel ipu3 specific raw formats
Message-ID: <20180102111138.ohptdsm5nh3oihyu@valkosipuli.retiisi.org.uk>
References: <1514862157-4584-1-git-send-email-tian.shu.qiu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1514862157-4584-1-git-send-email-tian.shu.qiu@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tian Shu,

Thanks for the patch.

On Tue, Jan 02, 2018 at 11:02:37AM +0800, tian.shu.qiu@intel.com wrote:
> From: Tianshu Qiu <tian.shu.qiu@intel.com>
> 
> Add support for these pixel formats:
> 
> V4L2_PIX_FMT_IPU3_SBGGR10
> V4L2_PIX_FMT_IPU3_SGBRG10
> V4L2_PIX_FMT_IPU3_SGRBG10
> V4L2_PIX_FMT_IPU3_SRGGB10
> 
> Signed-off-by: Tianshu Qiu <tian.shu.qiu@intel.com>
> ---
>  include/linux/videodev2.h | 5 +++++
>  yavta.c                   | 4 ++++
>  2 files changed, 9 insertions(+)
> 
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index b1e36ee553da..6f7cd9622ea8 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -659,6 +659,11 @@ struct v4l2_pix_format {
>  #define V4L2_PIX_FMT_MT21C    v4l2_fourcc('M', 'T', '2', '1') /* Mediatek compressed block mode  */
>  #define V4L2_PIX_FMT_INZI     v4l2_fourcc('I', 'N', 'Z', 'I') /* Intel Planar Greyscale 10-bit and Depth 16-bit */
>  
> +#define V4L2_PIX_FMT_IPU3_SBGGR10   v4l2_fourcc('i', 'p', '3', 'b') /* IPU3 packed 10-bit BGGR bayer */
> +#define V4L2_PIX_FMT_IPU3_SGBRG10   v4l2_fourcc('i', 'p', '3', 'g') /* IPU3 packed 10-bit GBRG bayer */
> +#define V4L2_PIX_FMT_IPU3_SGRBG10   v4l2_fourcc('i', 'p', '3', 'G') /* IPU3 packed 10-bit GRBG bayer */
> +#define V4L2_PIX_FMT_IPU3_SRGGB10   v4l2_fourcc('i', 'p', '3', 'r') /* IPU3 packed 10-bit RGGB bayer */
> +

Could you update the kernel headers in a separate patch? This should
include all headers as they're produced by make headers_install .

>  /* SDR formats - used only for Software Defined Radio devices */
>  #define V4L2_SDR_FMT_CU8          v4l2_fourcc('C', 'U', '0', '8') /* IQ u8 */
>  #define V4L2_SDR_FMT_CU16LE       v4l2_fourcc('C', 'U', '1', '6') /* IQ u16le */
> diff --git a/yavta.c b/yavta.c
> index afe96331a520..524e549efd08 100644
> --- a/yavta.c
> +++ b/yavta.c
> @@ -220,6 +220,10 @@ static struct v4l2_format_info {
>  	{ "SGBRG10P", V4L2_PIX_FMT_SGBRG10P, 1 },
>  	{ "SGRBG10P", V4L2_PIX_FMT_SGRBG10P, 1 },
>  	{ "SRGGB10P", V4L2_PIX_FMT_SRGGB10P, 1 },
> +	{ "IPU3_GRBG10", V4L2_PIX_FMT_IPU3_SGRBG10, 1 },
> +	{ "IPU3_RGGB10", V4L2_PIX_FMT_IPU3_SRGGB10, 1 },
> +	{ "IPU3_BGGR10", V4L2_PIX_FMT_IPU3_SBGGR10, 1 },
> +	{ "IPU3_GBRG10", V4L2_PIX_FMT_IPU3_SGBRG10, 1 },
>  	{ "SBGGR12", V4L2_PIX_FMT_SBGGR12, 1 },
>  	{ "SGBRG12", V4L2_PIX_FMT_SGBRG12, 1 },
>  	{ "SGRBG12", V4L2_PIX_FMT_SGRBG12, 1 },

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
