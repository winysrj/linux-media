Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:42846 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449Ab2HaSfi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Aug 2012 14:35:38 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M9M000GRUBDHKB0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Sat, 01 Sep 2012 03:35:37 +0900 (KST)
Received: from [106.210.235.55] by mmp2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0M9M00JVSUB9Y210@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Sat, 01 Sep 2012 03:35:37 +0900 (KST)
Message-id: <504103F4.4000808@samsung.com>
Date: Fri, 31 Aug 2012 20:35:32 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
MIME-version: 1.0
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-media@vger.kernel.org, Pawel Osciak <pawel@osciak.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 2/2] media v4l2-mem2mem: fix src/out and dst/cap num_rdy
References: <1346419084-10879-1-git-send-email-s.hauer@pengutronix.de>
 <1346419084-10879-3-git-send-email-s.hauer@pengutronix.de>
In-reply-to: <1346419084-10879-3-git-send-email-s.hauer@pengutronix.de>
Content-type: text/plain; charset=ISO-8859-2; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 8/31/2012 3:18 PM, Sascha Hauer wrote:
> src bufs belong to out queue, dst bufs belong to in queue. Currently
> this is not a real problem since all users currently need exactly one
> input and one output buffer.
>
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>   include/media/v4l2-mem2mem.h |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/include/media/v4l2-mem2mem.h b/include/media/v4l2-mem2mem.h
> index 16ac473..131cc4a 100644
> --- a/include/media/v4l2-mem2mem.h
> +++ b/include/media/v4l2-mem2mem.h
> @@ -140,7 +140,7 @@ void v4l2_m2m_buf_queue(struct v4l2_m2m_ctx *m2m_ctx, struct vb2_buffer *vb);
>   static inline
>   unsigned int v4l2_m2m_num_src_bufs_ready(struct v4l2_m2m_ctx *m2m_ctx)
>   {
> -	return m2m_ctx->cap_q_ctx.num_rdy;
> +	return m2m_ctx->out_q_ctx.num_rdy;
>   }
>
>   /**
> @@ -150,7 +150,7 @@ unsigned int v4l2_m2m_num_src_bufs_ready(struct v4l2_m2m_ctx *m2m_ctx)
>   static inline
>   unsigned int v4l2_m2m_num_dst_bufs_ready(struct v4l2_m2m_ctx *m2m_ctx)
>   {
> -	return m2m_ctx->out_q_ctx.num_rdy;
> +	return m2m_ctx->cap_q_ctx.num_rdy;
>   }
>
>   void *v4l2_m2m_next_buf(struct v4l2_m2m_queue_ctx *q_ctx);
>


Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center
