Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:23965 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746AbaESI6F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 May 2014 04:58:05 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N5T00FESCWQAB80@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 19 May 2014 09:58:02 +0100 (BST)
Message-id: <5379C797.1080508@samsung.com>
Date: Mon, 19 May 2014 10:57:59 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Kamil Debski <k.debski@samsung.com>
Cc: linux-media@vger.kernel.org, arun.kk@samsung.com
Subject: Re: [PATCH 1/2] v4l: s5p-mfc: Fix default pixel format selection for
 decoder
References: <1400241824-18260-1-git-send-email-k.debski@samsung.com>
In-reply-to: <1400241824-18260-1-git-send-email-k.debski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 16/05/14 14:03, Kamil Debski wrote:
> The patch adding the v6 version of MFC changed the default format for
> the CAPTURE queue, but this also affects the v5 version. This patch
> solves this problem by checking the MFC version before assigning the
> default format.
> 
> Signed-off-by: Kamil Debski <k.debski@samsung.com>

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc_dec.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> index a4e6668..ac43a4a 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> @@ -32,9 +32,6 @@
>  #include "s5p_mfc_opr.h"
>  #include "s5p_mfc_pm.h"
>  
> -#define DEF_SRC_FMT_DEC	V4L2_PIX_FMT_H264
> -#define DEF_DST_FMT_DEC	V4L2_PIX_FMT_NV12MT_16X16
> -
>  static struct s5p_mfc_fmt formats[] = {
>  	{
>  		.name		= "4:2:0 2 Planes 16x16 Tiles",
> @@ -1190,9 +1187,12 @@ void s5p_mfc_dec_ctrls_delete(struct s5p_mfc_ctx *ctx)
>  void s5p_mfc_dec_init(struct s5p_mfc_ctx *ctx)
>  {
>  	struct v4l2_format f;
> -	f.fmt.pix_mp.pixelformat = DEF_SRC_FMT_DEC;
> +	f.fmt.pix_mp.pixelformat = V4L2_PIX_FMT_H264;
>  	ctx->src_fmt = find_format(&f, MFC_FMT_DEC);
> -	f.fmt.pix_mp.pixelformat = DEF_DST_FMT_DEC;
> +	if (IS_MFCV6_PLUS(ctx->dev))
> +		f.fmt.pix_mp.pixelformat = V4L2_PIX_FMT_NV12MT_16X16;
> +	else
> +		f.fmt.pix_mp.pixelformat = V4L2_PIX_FMT_NV12MT;
>  	ctx->dst_fmt = find_format(&f, MFC_FMT_RAW);
>  	mfc_debug(2, "Default src_fmt is %x, dest_fmt is %x\n",
>  			(unsigned int)ctx->src_fmt, (unsigned int)ctx->dst_fmt);
> 


-- 
Sylwester Nawrocki
Samsung R&D Institute Poland
