Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38918 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249Ab1GNPn7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2011 11:43:59 -0400
Received: by qwk3 with SMTP id 3so183529qwk.19
        for <linux-media@vger.kernel.org>; Thu, 14 Jul 2011 08:43:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1310478404-9279-1-git-send-email-m.olbrich@pengutronix.de>
References: <1310478404-9279-1-git-send-email-m.olbrich@pengutronix.de>
From: Pawel Osciak <pawel@osciak.com>
Date: Thu, 14 Jul 2011 08:43:38 -0700
Message-ID: <CAMm-=zCofVVc=UuQO0YVdyGqyC4Hc7=9=-ZJhAAQ87oHv4n3rQ@mail.gmail.com>
Subject: Re: [PATCH] v4l: mem2mem: add wait_{prepare,finish} ops to m2m_testdev
To: Michael Olbrich <m.olbrich@pengutronix.de>
Cc: linux-media@vger.kernel.org, kernel@pengutronix.de,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Pawel Osciak <pawel@osciak.com>

Thanks Michael!
Pawel

On Tue, Jul 12, 2011 at 06:46, Michael Olbrich <m.olbrich@pengutronix.de> wrote:
> These are necessary to prevent dead-locks e.g. if one thread waits
> in dqbuf at one end and another tries to queue a buffer at the
> other end.
>
> Signed-off-by: Michael Olbrich <m.olbrich@pengutronix.de>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: Pawel Osciak <pawel@osciak.com>
> ---
>  drivers/media/video/mem2mem_testdev.c |   14 ++++++++++++++
>  1 files changed, 14 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/media/video/mem2mem_testdev.c b/drivers/media/video/mem2mem_testdev.c
> index b03d74e..effefa0 100644
> --- a/drivers/media/video/mem2mem_testdev.c
> +++ b/drivers/media/video/mem2mem_testdev.c
> @@ -795,10 +795,24 @@ static void m2mtest_buf_queue(struct vb2_buffer *vb)
>        v4l2_m2m_buf_queue(ctx->m2m_ctx, vb);
>  }
>
> +static void m2mtest_wait_prepare(struct vb2_queue *q)
> +{
> +       struct m2mtest_ctx *ctx = vb2_get_drv_priv(q);
> +       m2mtest_unlock(ctx);
> +}
> +
> +static void m2mtest_wait_finish(struct vb2_queue *q)
> +{
> +       struct m2mtest_ctx *ctx = vb2_get_drv_priv(q);
> +       m2mtest_lock(ctx);
> +}
> +
>  static struct vb2_ops m2mtest_qops = {
>        .queue_setup     = m2mtest_queue_setup,
>        .buf_prepare     = m2mtest_buf_prepare,
>        .buf_queue       = m2mtest_buf_queue,
> +       .wait_prepare    = m2mtest_wait_prepare,
> +       .wait_finish     = m2mtest_wait_finish,
>  };
>
>  static int queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *dst_vq)
> --
> 1.7.5.4
>
>



-- 
Best regards,
Pawel Osciak
