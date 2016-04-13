Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f53.google.com ([209.85.192.53]:33995 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030937AbcDMOXk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Apr 2016 10:23:40 -0400
Message-ID: <1460557416.18956.3.camel@gmail.com>
Subject: Re: [PATCH 1/7] [media]: v4l: add Mediatek MT21 video block format
From: Nicolas Dufresne <nicolas.dufresne@gmail.com>
Reply-To: nicolas@ndufresne.ca
To: Tiffany Lin <tiffany.lin@mediatek.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	daniel.thompson@linaro.org, Rob Herring <robh+dt@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>
Cc: Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-mediatek@lists.infradead.org, PoChun.Lin@mediatek.com
Date: Wed, 13 Apr 2016 10:23:36 -0400
In-Reply-To: <1460548915-17536-2-git-send-email-tiffany.lin@mediatek.com>
References: <1460548915-17536-1-git-send-email-tiffany.lin@mediatek.com>
	 <1460548915-17536-2-git-send-email-tiffany.lin@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le mercredi 13 avril 2016 à 20:01 +0800, Tiffany Lin a écrit :
> From: Daniel Kurtz <djkurtz@chromium.org>
> 
> Mediatek video format is YVU8_420_2PLANE_PACK8_PROGRESSIVE.
> 
> Create V4L2_PIX_FMT_MT21 and DRM_FORMAT_MT21 to be consistent with
> V4L2_PIX_FMT_NV12 notation.
> 
> Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
> ---
>  include/uapi/drm/drm_fourcc.h  |    1 +
>  include/uapi/linux/videodev2.h |    2 ++

Might be better to split this patch.

>  2 files changed, 3 insertions(+)
> 
> diff --git a/include/uapi/drm/drm_fourcc.h b/include/uapi/drm/drm_fourcc.h
> index 0b69a77..a193905 100644
> --- a/include/uapi/drm/drm_fourcc.h
> +++ b/include/uapi/drm/drm_fourcc.h
> @@ -116,6 +116,7 @@
>  #define DRM_FORMAT_NV24		fourcc_code('N', 'V', '2', '4') /* non-subsampled Cr:Cb plane */
>  #define DRM_FORMAT_NV42		fourcc_code('N', 'V', '4', '2') /* non-subsampled Cb:Cr plane */
>  
> +#define DRM_FORMAT_MT21		fourcc_code('M', 'T', '2', '1') /* Mediatek Block Mode */

Please document the tiling format, don't just add a define here.

>  /*
>   * 3 plane YCbCr
>   * index 0: Y plane, [7:0] Y
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index d0acd26..e9e3276 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -527,6 +527,8 @@ struct v4l2_pix_format {
>  #define V4L2_PIX_FMT_HM12    v4l2_fourcc('H', 'M', '1', '2') /*  8  YUV 4:2:0 16x16 macroblocks */
>  #define V4L2_PIX_FMT_M420    v4l2_fourcc('M', '4', '2', '0') /* 12  YUV 4:2:0 2 lines y, 1 line uv interleaved */
>  
> +#define V4L2_PIX_FMT_MT21    v4l2_fourcc('M', 'T', '2', '1') /* Mediatek Block Mode  */
> +

Same. On Linux Media side, there is docbook documentation where you can
explain in detail.

>  /* two planes -- one Y, one Cr + Cb interleaved  */
>  #define V4L2_PIX_FMT_NV12    v4l2_fourcc('N', 'V', '1', '2') /* 12  Y/CbCr 4:2:0  */
>  #define V4L2_PIX_FMT_NV21    v4l2_fourcc('N', 'V', '2', '1') /* 12  Y/CrCb 4:2:0  */
