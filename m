Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:23880 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750941AbdBBIeW (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Feb 2017 03:34:22 -0500
Subject: Re: [PATCH 06/11] [media] videodev2.h: Add v4l2 definition for HEVC
To: Smitha T Murthy <smitha.t@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, kamil@wypas.org, jtp.park@samsung.com,
        mchehab@kernel.org, pankaj.dubey@samsung.com, krzk@kernel.org,
        m.szyprowski@samsung.com, s.nawrocki@samsung.com
From: Andrzej Hajda <a.hajda@samsung.com>
Message-id: <c8733135-dd3d-cff9-df99-68a900f71cfc@samsung.com>
Date: Thu, 02 Feb 2017 09:34:14 +0100
MIME-version: 1.0
In-reply-to: <1484733729-25371-7-git-send-email-smitha.t@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
References: <1484733729-25371-1-git-send-email-smitha.t@samsung.com>
 <CGME20170118100742epcas5p1bb390dffa4fe530d94573f41d8791ef7@epcas5p1.samsung.com>
 <1484733729-25371-7-git-send-email-smitha.t@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18.01.2017 11:02, Smitha T Murthy wrote:
> Add V4L2 definition for HEVC compressed format
>
> Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
Beside small nitpick.

Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>

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

I am not sure if it shouldn't be sorted alphabetically in compressed
formats stanza.

--
Regards
Andrzej


>  
>  /*  Vendor-specific formats   */
>  #define V4L2_PIX_FMT_CPIA1    v4l2_fourcc('C', 'P', 'I', 'A') /* cpia1 YUV */


