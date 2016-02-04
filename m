Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:32544 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbcBDOXH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Feb 2016 09:23:07 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0O2100L431AG0590@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Feb 2016 14:23:04 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: 'ayaka' <ayaka@soulik.info>, linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, jtp.park@samsung.com,
	mchehab@osg.samsung.com, linux-arm-kernel@lists.infradead.org
References: <1454180017-29071-1-git-send-email-ayaka@soulik.info>
 <1454180017-29071-4-git-send-email-ayaka@soulik.info>
In-reply-to: <1454180017-29071-4-git-send-email-ayaka@soulik.info>
Subject: RE: [PATCH 3/4] [media] s5p-mfc: don't close instance after free
 OUTPUT buffers
Date: Thu, 04 Feb 2016 15:23:02 +0100
Message-id: <003501d15f57$8f1904b0$ad4b0e10$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> From: ayaka [mailto:ayaka@soulik.info]
> Sent: Saturday, January 30, 2016 7:54 PM
>
> Free buffers in OUTPUT is quite normal to detect the driver's buffer
capacity,
> it doesn't mean the application want to close that mfc instance.
> 
> Signed-off-by: ayaka <ayaka@soulik.info>
> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc_dec.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> index aebe4fd..609b17b 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> @@ -474,7 +474,6 @@ static int reqbufs_output(struct s5p_mfc_dev *dev,
> struct s5p_mfc_ctx *ctx,
>  		ret = vb2_reqbufs(&ctx->vq_src, reqbufs);
>  		if (ret)
>  			goto out;
> -		s5p_mfc_close_mfc_inst(dev, ctx);
>  		ctx->src_bufs_cnt = 0;
>  		ctx->output_state = QUEUE_FREE;
>  	} else if (ctx->output_state == QUEUE_FREE) {

What exactly do you mean by "detecting buffer capacity"  ? Is it the max
number of buffer
that can be allocated?

Anyway, if the instance is not closed, then in a consecutive call to reqbufs
(with cound != 0)
the instance will be opened for a second time. So either the instance has to
be closed, or
it should be opened in another place.

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland

