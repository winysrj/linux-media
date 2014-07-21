Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:61541 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933419AbaGUTEn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jul 2014 15:04:43 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N920039SSZTNO30@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Mon, 21 Jul 2014 15:04:41 -0400 (EDT)
Date: Mon, 21 Jul 2014 16:04:32 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org, Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de, Michael Olbrich <m.olbrich@pengutronix.de>
Subject: Re: [PATCH v3 18/32] [media] v4l2-mem2mem: export v4l2_m2m_try_schedule
Message-id: <20140721160432.12e34653.m.chehab@samsung.com>
In-reply-to: <1405071403-1859-19-git-send-email-p.zabel@pengutronix.de>
References: <1405071403-1859-1-git-send-email-p.zabel@pengutronix.de>
 <1405071403-1859-19-git-send-email-p.zabel@pengutronix.de>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 11 Jul 2014 11:36:29 +0200
Philipp Zabel <p.zabel@pengutronix.de> escreveu:

> From: Michael Olbrich <m.olbrich@pengutronix.de>
> 
> Some drivers might allow to decode remaining frames from an internal ringbuffer
> after a decoder stop command. Allow those to call v4l2_m2m_try_schedule
> directly.
> 
> Signed-off-by: Michael Olbrich <m.olbrich@pengutronix.de>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/media/v4l2-core/v4l2-mem2mem.c | 3 ++-
>  include/media/v4l2-mem2mem.h           | 2 ++
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
> index 178ce96..5f5c175 100644
> --- a/drivers/media/v4l2-core/v4l2-mem2mem.c
> +++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
> @@ -208,7 +208,7 @@ static void v4l2_m2m_try_run(struct v4l2_m2m_dev *m2m_dev)
>   * An example of the above could be an instance that requires more than one
>   * src/dst buffer per transaction.
>   */
> -static void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx)
> +void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx)
>  {
>  	struct v4l2_m2m_dev *m2m_dev;
>  	unsigned long flags_job, flags_out, flags_cap;
> @@ -274,6 +274,7 @@ static void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx)
>  
>  	v4l2_m2m_try_run(m2m_dev);
>  }
> +EXPORT_SYMBOL(v4l2_m2m_try_schedule);

Please use EXPORT_SYMBOL_GPL() instead.

Regards,
Mauro

>  
>  /**
>   * v4l2_m2m_cancel_job() - cancel pending jobs for the context
> diff --git a/include/media/v4l2-mem2mem.h b/include/media/v4l2-mem2mem.h
> index 12ea5a6..c5f3914 100644
> --- a/include/media/v4l2-mem2mem.h
> +++ b/include/media/v4l2-mem2mem.h
> @@ -95,6 +95,8 @@ void *v4l2_m2m_get_curr_priv(struct v4l2_m2m_dev *m2m_dev);
>  struct vb2_queue *v4l2_m2m_get_vq(struct v4l2_m2m_ctx *m2m_ctx,
>  				       enum v4l2_buf_type type);
>  
> +void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx);
> +
>  void v4l2_m2m_job_finish(struct v4l2_m2m_dev *m2m_dev,
>  			 struct v4l2_m2m_ctx *m2m_ctx);
>  
