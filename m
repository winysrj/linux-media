Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:42844 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755332Ab2IAB36 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Aug 2012 21:29:58 -0400
Received: by vbbff1 with SMTP id ff1so3832179vbb.19
        for <linux-media@vger.kernel.org>; Fri, 31 Aug 2012 18:29:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1346419084-10879-3-git-send-email-s.hauer@pengutronix.de>
References: <1346419084-10879-1-git-send-email-s.hauer@pengutronix.de> <1346419084-10879-3-git-send-email-s.hauer@pengutronix.de>
From: Pawel Osciak <pawel@osciak.com>
Date: Fri, 31 Aug 2012 18:29:17 -0700
Message-ID: <CAMm-=zDdZmEz2Lp4UvBeMobXUHabd9xyHnNZy-8RX4sXwpGoEQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] media v4l2-mem2mem: fix src/out and dst/cap num_rdy
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-media@vger.kernel.org, Pawel Osciak <p.osciak@samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Aug 31, 2012 at 6:18 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> src bufs belong to out queue, dst bufs belong to in queue. Currently
> this is not a real problem since all users currently need exactly one
> input and one output buffer.
>
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---

Acked-by: Pawel Osciak <pawel@osciak.com>

>  include/media/v4l2-mem2mem.h |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/include/media/v4l2-mem2mem.h b/include/media/v4l2-mem2mem.h
> index 16ac473..131cc4a 100644
> --- a/include/media/v4l2-mem2mem.h
> +++ b/include/media/v4l2-mem2mem.h
> @@ -140,7 +140,7 @@ void v4l2_m2m_buf_queue(struct v4l2_m2m_ctx *m2m_ctx, struct vb2_buffer *vb);
>  static inline
>  unsigned int v4l2_m2m_num_src_bufs_ready(struct v4l2_m2m_ctx *m2m_ctx)
>  {
> -       return m2m_ctx->cap_q_ctx.num_rdy;
> +       return m2m_ctx->out_q_ctx.num_rdy;
>  }
>
>  /**
> @@ -150,7 +150,7 @@ unsigned int v4l2_m2m_num_src_bufs_ready(struct v4l2_m2m_ctx *m2m_ctx)
>  static inline
>  unsigned int v4l2_m2m_num_dst_bufs_ready(struct v4l2_m2m_ctx *m2m_ctx)
>  {
> -       return m2m_ctx->out_q_ctx.num_rdy;
> +       return m2m_ctx->cap_q_ctx.num_rdy;
>  }
>
>  void *v4l2_m2m_next_buf(struct v4l2_m2m_queue_ctx *q_ctx);
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Best regards,
Pawel Osciak
