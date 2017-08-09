Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51854 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752467AbdHIHxX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Aug 2017 03:53:23 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jeffrey Mouroux <jeff.mouroux@xilinx.com>
Cc: mchehab@kernel.org, hansverk@cisco.com,
        laurent.pinchart+renesas@ideasonboard.com,
        sakari.ailus@linux.intel.com, tiffany.lin@mediatek.com,
        ricardo.ribalda@gmail.com, evgeni.raikhel@intel.com,
        nick@shmanahar.org, linux-media@vger.kernel.org,
        Jeffrey Mouroux <jmouroux@xilinx.com>
Subject: Re: [PATCH v1 1/2] uapi: media: New fourcc codes needed by Xilinx Video IP
Date: Wed, 09 Aug 2017 10:53:37 +0300
Message-ID: <5292400.sDssS5K49F@avalon>
In-Reply-To: <1502242278-14686-2-git-send-email-jmouroux@xilinx.com>
References: <1502242278-14686-1-git-send-email-jmouroux@xilinx.com> <1502242278-14686-2-git-send-email-jmouroux@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jeffrey,

Thank you for the patch.

On Tuesday 08 Aug 2017 18:31:17 Jeffrey Mouroux wrote:
> The Xilinx Video Mixer andn Xilinx Video Framebuffer DMA IP
> support video memory formats that are not represented in the
> current V4L2 fourcc library.  This patch adds those missing
> fourcc codes.

Could you please also document the new formats in 
Documentation/media/uapi/v4l/ ? You can have a look at pixfmt-*.rst for 
examples. Please make sure that the documentation compiles without any error 
("make htmldocs") before submitting the patch.

> Signed-off-by: Jeffrey Mouroux <jmouroux@xilinx.com>
> ---
>  include/uapi/linux/videodev2.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 45cf735..a059439 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -509,6 +509,7 @@ struct v4l2_pix_format {
>  #define V4L2_PIX_FMT_RGB32   v4l2_fourcc('R', 'G', 'B', '4') /* 32 
> RGB-8-8-8-8   */ #define V4L2_PIX_FMT_ARGB32  v4l2_fourcc('B', 'A', '2',
> '4') /* 32  ARGB-8-8-8-8  */ #define V4L2_PIX_FMT_XRGB32  v4l2_fourcc('B',
> 'X', '2', '4') /* 32  XRGB-8-8-8-8  */ +#define V4L2_PIX_FMT_XBGR30 
> v4l2_fourcc('R', 'X', '3', '0') /* 32  XBGR-2-10-10-10 */
> 
>  /* Grey formats */
>  #define V4L2_PIX_FMT_GREY    v4l2_fourcc('G', 'R', 'E', 'Y') /*  8 
> Greyscale     */ @@ -536,12 +537,16 @@ struct v4l2_pix_format {
>  #define V4L2_PIX_FMT_VYUY    v4l2_fourcc('V', 'Y', 'U', 'Y') /* 16  YUV
> 4:2:2     */ #define V4L2_PIX_FMT_Y41P    v4l2_fourcc('Y', '4', '1', 'P')
> /* 12  YUV 4:1:1     */ #define V4L2_PIX_FMT_YUV444  v4l2_fourcc('Y', '4',
> '4', '4') /* 16  xxxxyyyy uuuuvvvv */ +#define V4L2_PIX_FMT_XVUY32 
> v4l2_fourcc('X', 'V', '3', '2') /* 32  XVUY 8:8:8:8 */ +#define
> V4L2_PIX_FMT_AVUY32  v4l2_fourcc('A', 'V', '3', '2') /* 32  AVUY 8:8:8:8 */
> +#define V4L2_PIX_FMT_VUY24   v4l2_fourcc('V', 'U', '2', '4') /* 24  VUY
> 8:8:8 */ #define V4L2_PIX_FMT_YUV555  v4l2_fourcc('Y', 'U', 'V', 'O') /* 16
>  YUV-5-5-5     */ #define V4L2_PIX_FMT_YUV565  v4l2_fourcc('Y', 'U', 'V',
> 'P') /* 16  YUV-5-6-5     */ #define V4L2_PIX_FMT_YUV32   v4l2_fourcc('Y',
> 'U', 'V', '4') /* 32  YUV-8-8-8-8   */ #define V4L2_PIX_FMT_HI240  
> v4l2_fourcc('H', 'I', '2', '4') /*  8  8-bit color   */ #define
> V4L2_PIX_FMT_HM12    v4l2_fourcc('H', 'M', '1', '2') /*  8  YUV 4:2:0 16x16
> macroblocks */ #define V4L2_PIX_FMT_M420    v4l2_fourcc('M', '4', '2', '0')
> /* 12  YUV 4:2:0 2 lines y, 1 line uv interleaved */ +#define
> V4L2_PIX_FMT_XVUY10  v4l2_fourcc('X', 'Y', '1', '0') /* 32  XVUY 2-10-10-10
> */
> 
>  /* two planes -- one Y, one Cr + Cb interleaved  */
>  #define V4L2_PIX_FMT_NV12    v4l2_fourcc('N', 'V', '1', '2') /* 12  Y/CbCr
> 4:2:0  */ @@ -550,6 +555,8 @@ struct v4l2_pix_format {
>  #define V4L2_PIX_FMT_NV61    v4l2_fourcc('N', 'V', '6', '1') /* 16  Y/CrCb
> 4:2:2  */ #define V4L2_PIX_FMT_NV24    v4l2_fourcc('N', 'V', '2', '4') /*
> 24  Y/CbCr 4:4:4  */ #define V4L2_PIX_FMT_NV42    v4l2_fourcc('N', 'V',
> '4', '2') /* 24  Y/CrCb 4:4:4  */ +#define V4L2_PIX_FMT_XV20   
> v4l2_fourcc('X', 'V', '2', '0') /* 32 XY/UV 4:2:2 10-bit */ +#define
> V4L2_PIX_FMT_XV15    v4l2_fourcc('X', 'V', '1', '5') /* 32 XY/UV 4:2:0
> 10-bit */
> 
>  /* two non contiguous planes - one Y, one Cr + Cb interleaved  */
>  #define V4L2_PIX_FMT_NV12M   v4l2_fourcc('N', 'M', '1', '2') /* 12  Y/CbCr
> 4:2:0  */ @@ -557,6 +564,8 @@ struct v4l2_pix_format {
>  #define V4L2_PIX_FMT_NV16M   v4l2_fourcc('N', 'M', '1', '6') /* 16  Y/CbCr
> 4:2:2  */ #define V4L2_PIX_FMT_NV61M   v4l2_fourcc('N', 'M', '6', '1') /*
> 16  Y/CrCb 4:2:2  */ #define V4L2_PIX_FMT_NV12MT  v4l2_fourcc('T', 'M',
> '1', '2') /* 12  Y/CbCr 4:2:0 64x32 macroblocks */ +#define
> V4L2_PIX_FMT_XV20M   v4l2_fourcc('X', 'M', '2', '0') /* 32 XY/UV 4:2:2
> 10-bit */ +#define V4L2_PIX_FMT_XV15M   v4l2_fourcc('X', 'M', '1', '5') /*
> 32 XY/UV 4:2:0 10-bit */ #define V4L2_PIX_FMT_NV12MT_16X16 v4l2_fourcc('V',
> 'M', '1', '2') /* 12  Y/CbCr 4:2:0 16x16 macroblocks */
> 
>  /* three planes - Y Cb, Cr */

-- 
Regards,

Laurent Pinchart
