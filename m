Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:49890 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab2KTSBc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Nov 2012 13:01:32 -0500
Received: from eusync3.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MDS00GSWSR2VL10@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 20 Nov 2012 18:01:50 +0000 (GMT)
Received: from AMDN910 ([106.116.147.102])
 by eusync3.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0MDS00AWGSQE3030@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 20 Nov 2012 18:01:30 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: 'Arun Kumar K' <arun.kk@samsung.com>, linux-media@vger.kernel.org
Cc: jtp.park@samsung.com, arun.m@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
References: <1352899605-12043-1-git-send-email-arun.kk@samsung.com>
In-reply-to: <1352899605-12043-1-git-send-email-arun.kk@samsung.com>
Subject: RE: [PATCH] [media] s5p-mfc: Handle multi-frame input buffer
Date: Tue, 20 Nov 2012 19:01:25 +0100
Message-id: <006901cdc749$0f75a280$2e60e780$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> From: Arun Kumar K [mailto:arun.kk@samsung.com]
> Sent: Wednesday, November 14, 2012 2:27 PM
> To: linux-media@vger.kernel.org
> Cc: k.debski@samsung.com; jtp.park@samsung.com; arun.m@samsung.com;
> arun.kk@samsung.com
> Subject: [PATCH] [media] s5p-mfc: Handle multi-frame input buffer
> 
> When one input buffer has multiple frames, it should be fed again to
> the hardware with the remaining bytes. Removed the check for P frame in
> this scenario as this condition can come with all frame types.
> 
> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
> Signed-off-by: ARUN MANKUZHI <arun.m@samsung.com>

Acked-by: Kamil Debski <k.debski@samsung.com>

> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc.c |    7 ++-----
>  1 files changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> index 0ca8dbb..d3cd738 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> @@ -382,11 +382,8 @@ static void s5p_mfc_handle_frame(struct
> s5p_mfc_ctx *ctx,
>  		ctx->consumed_stream += s5p_mfc_hw_call(dev->mfc_ops,
>  						get_consumed_stream, dev);
>  		if (ctx->codec_mode != S5P_MFC_CODEC_H264_DEC &&
> -			s5p_mfc_hw_call(dev->mfc_ops,
> -				get_dec_frame_type, dev) ==
> -					S5P_FIMV_DECODE_FRAME_P_FRAME
> -					&& ctx->consumed_stream + STUFF_BYTE
<
> -
src_buf->b->v4l2_planes[0].bytesused) {
> +			ctx->consumed_stream + STUFF_BYTE <
> +			src_buf->b->v4l2_planes[0].bytesused) {
>  			/* Run MFC again on the same buffer */
>  			mfc_debug(2, "Running again the same buffer\n");
>  			ctx->after_packed_pb = 1;
> --
> 1.7.0.4


