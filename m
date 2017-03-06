Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:37756 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753133AbdCFOwZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Mar 2017 09:52:25 -0500
Subject: Re: [Patch v2 05/11] videodev2.h: Add v4l2 definition for HEVC
To: Smitha T Murthy <smitha.t@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, kamil@wypas.org, jtp.park@samsung.com,
        mchehab@kernel.org, pankaj.dubey@samsung.com, krzk@kernel.org,
        m.szyprowski@samsung.com, s.nawrocki@samsung.com
From: Andrzej Hajda <a.hajda@samsung.com>
Message-id: <1712b0fa-c86f-0b29-75f3-e22efc87f107@samsung.com>
Date: Mon, 06 Mar 2017 15:52:13 +0100
MIME-version: 1.0
In-reply-to: <1488532036-13044-6-git-send-email-smitha.t@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
References: <1488532036-13044-1-git-send-email-smitha.t@samsung.com>
 <CGME20170303090449epcas5p3adcab3282b760d01ccb775bbd95c57f5@epcas5p3.samsung.com>
 <1488532036-13044-6-git-send-email-smitha.t@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03.03.2017 10:07, Smitha T Murthy wrote:
> Add V4L2 definition for HEVC compressed format
>
> Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>
--
Regards
Andrzej
> ---
>  include/uapi/linux/videodev2.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 46e8a2e3..620e941 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -630,6 +630,7 @@ struct v4l2_pix_format {
>  #define V4L2_PIX_FMT_VC1_ANNEX_L v4l2_fourcc('V', 'C', '1', 'L') /* SMPTE 421M Annex L compliant stream */
>  #define V4L2_PIX_FMT_VP8      v4l2_fourcc('V', 'P', '8', '0') /* VP8 */
>  #define V4L2_PIX_FMT_VP9      v4l2_fourcc('V', 'P', '9', '0') /* VP9 */
> +#define V4L2_PIX_FMT_HEVC     v4l2_fourcc('H', 'E', 'V', 'C') /* HEVC */
>  
>  /*  Vendor-specific formats   */
>  #define V4L2_PIX_FMT_CPIA1    v4l2_fourcc('C', 'P', 'I', 'A') /* cpia1 YUV */
