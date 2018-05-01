Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-sn1nam02on0063.outbound.protection.outlook.com ([104.47.36.63]:22230
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751004AbeEAVWB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 1 May 2018 17:22:01 -0400
Date: Tue, 1 May 2018 14:21:43 -0700
From: Hyun Kwon <hyun.kwon@xilinx.com>
To: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "laurent.pinchart@ideasonboard.com"
        <laurent.pinchart@ideasonboard.com>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        Hyun Kwon <hyunk@xilinx.com>,
        Jeff Mouroux <jmouroux@xilinx.com>,
        Satish Kumar Nagireddy <SATISHNA@xilinx.com>
Subject: Re: [PATCH v4 05/10] uapi: media: New fourcc codes needed by Xilinx
 Video IP
Message-ID: <20180501212143.GB9872@smtp.xilinx.com>
References: <cover.1524955156.git.satish.nagireddy.nagireddy@xilinx.com>
 <2e6044636d652e5492f457123dadd29d61d460cb.1524955156.git.satish.nagireddy.nagireddy@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <2e6044636d652e5492f457123dadd29d61d460cb.1524955156.git.satish.nagireddy.nagireddy@xilinx.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Satish,

Thanks for the patch.

On Mon, 2018-04-30 at 18:35:08 -0700, Satish Kumar Nagireddy wrote:
> From: Jeffrey Mouroux <jmouroux@xilinx.com>
> 
> The Xilinx Video Framebuffer DMA IP supports video memory formats
> that are not represented in the current V4L2 fourcc library. This
> patch adds those missing fourcc codes. This includes both new
> 8-bit and 10-bit pixel formats.
> 
> Signed-off-by: Jeffrey Mouroux <jmouroux@xilinx.com>
> Signed-off-by: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
> ---
>  include/uapi/linux/videodev2.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 600877b..97b6633 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -510,6 +510,7 @@ struct v4l2_pix_format {
>  #define V4L2_PIX_FMT_RGB32   v4l2_fourcc('R', 'G', 'B', '4') /* 32  RGB-8-8-8-8   */
>  #define V4L2_PIX_FMT_ARGB32  v4l2_fourcc('B', 'A', '2', '4') /* 32  ARGB-8-8-8-8  */
>  #define V4L2_PIX_FMT_XRGB32  v4l2_fourcc('B', 'X', '2', '4') /* 32  XRGB-8-8-8-8  */
> +#define V4L2_PIX_FMT_BGRX32  v4l2_fourcc('X', 'B', 'G', 'R') /* 32  XBGR-8-8-8-8 */
>  
>  /* Grey formats */
>  #define V4L2_PIX_FMT_GREY    v4l2_fourcc('G', 'R', 'E', 'Y') /*  8  Greyscale     */
> @@ -537,6 +538,7 @@ struct v4l2_pix_format {
>  #define V4L2_PIX_FMT_VYUY    v4l2_fourcc('V', 'Y', 'U', 'Y') /* 16  YUV 4:2:2     */
>  #define V4L2_PIX_FMT_Y41P    v4l2_fourcc('Y', '4', '1', 'P') /* 12  YUV 4:1:1     */
>  #define V4L2_PIX_FMT_YUV444  v4l2_fourcc('Y', '4', '4', '4') /* 16  xxxxyyyy uuuuvvvv */
> +#define V4L2_PIX_FMT_VUY24   v4l2_fourcc('V', 'U', '2', '4') /* 24  VUY 8:8:8 */

This format needs documentation, and probably entries v4l_fill_fmtdesc()?

Then would it make sense to squash this into 4/10 which documents these?
Or at least, this should come before documentation.

Thanks,
-hyun

>  #define V4L2_PIX_FMT_YUV555  v4l2_fourcc('Y', 'U', 'V', 'O') /* 16  YUV-5-5-5     */
>  #define V4L2_PIX_FMT_YUV565  v4l2_fourcc('Y', 'U', 'V', 'P') /* 16  YUV-5-6-5     */
>  #define V4L2_PIX_FMT_YUV32   v4l2_fourcc('Y', 'U', 'V', '4') /* 32  YUV-8-8-8-8   */
> @@ -551,6 +553,8 @@ struct v4l2_pix_format {
>  #define V4L2_PIX_FMT_NV61    v4l2_fourcc('N', 'V', '6', '1') /* 16  Y/CrCb 4:2:2  */
>  #define V4L2_PIX_FMT_NV24    v4l2_fourcc('N', 'V', '2', '4') /* 24  Y/CbCr 4:4:4  */
>  #define V4L2_PIX_FMT_NV42    v4l2_fourcc('N', 'V', '4', '2') /* 24  Y/CrCb 4:4:4  */
> +#define V4L2_PIX_FMT_XV20    v4l2_fourcc('X', 'V', '2', '0') /* 32  XY/UV 4:2:2 10-bit */
> +#define V4L2_PIX_FMT_XV15    v4l2_fourcc('X', 'V', '1', '5') /* 32  XY/UV 4:2:0 10-bit */
>  
>  /* two non contiguous planes - one Y, one Cr + Cb interleaved  */
>  #define V4L2_PIX_FMT_NV12M   v4l2_fourcc('N', 'M', '1', '2') /* 12  Y/CbCr 4:2:0  */
> -- 
> 2.1.1
> 
