Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:20210 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822AbbA2Peh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2015 10:34:37 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NIY00KH43G7PZ10@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 29 Jan 2015 15:38:31 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: 'Philipp Zabel' <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org
References: <1422031895-7740-1-git-send-email-p.zabel@pengutronix.de>
 <1422031895-7740-3-git-send-email-p.zabel@pengutronix.de>
In-reply-to: <1422031895-7740-3-git-send-email-p.zabel@pengutronix.de>
Subject: RE: [PATCH 02/21] [media] coda: bitrate can only be set in kbps steps
Date: Thu, 29 Jan 2015 16:34:25 +0100
Message-id: <029c01d03bd9$10b19580$3214c080$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

Could you add a one sentence description for this patch?
I know that it is really simple, but still the description is still
necessary.

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland


> -----Original Message-----
> From: Philipp Zabel [mailto:p.zabel@pengutronix.de]
> Sent: Friday, January 23, 2015 5:51 PM
> To: Kamil Debski
> Cc: linux-media@vger.kernel.org; Philipp Zabel
> Subject: [PATCH 02/21] [media] coda: bitrate can only be set in kbps
> steps
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/media/platform/coda/coda-common.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/coda/coda-common.c
> b/drivers/media/platform/coda/coda-common.c
> index 39330a7..1cc4e90 100644
> --- a/drivers/media/platform/coda/coda-common.c
> +++ b/drivers/media/platform/coda/coda-common.c
> @@ -1407,7 +1407,7 @@ static const struct v4l2_ctrl_ops coda_ctrl_ops =
> {  static void coda_encode_ctrls(struct coda_ctx *ctx)  {
>  	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
> -		V4L2_CID_MPEG_VIDEO_BITRATE, 0, 32767000, 1, 0);
> +		V4L2_CID_MPEG_VIDEO_BITRATE, 0, 32767000, 1000, 0);
>  	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
>  		V4L2_CID_MPEG_VIDEO_GOP_SIZE, 1, 60, 1, 16);
>  	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
> --
> 2.1.4

