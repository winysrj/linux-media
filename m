Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:42984 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852Ab2LMJAd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Dec 2012 04:00:33 -0500
Received: by mail-vb0-f46.google.com with SMTP id b13so1840495vby.19
        for <linux-media@vger.kernel.org>; Thu, 13 Dec 2012 01:00:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1355311184-30029-1-git-send-email-k.debski@samsung.com>
References: <1355311184-30029-1-git-send-email-k.debski@samsung.com>
Date: Thu, 13 Dec 2012 14:30:31 +0530
Message-ID: <CAK9yfHyNO8jhjtueR9eL=q-85AB_CN9Ok61LftBG8ufmZzJzbQ@mail.gmail.com>
Subject: Re: [PATCH] s5p-mfc: Fix interrupt error handling routine
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Kamil Debski <k.debski@samsung.com>
Cc: linux-media@vger.kernel.org, jtp.park@samsung.com,
	arun.kk@samsung.com, s.nawrocki@samsung.com, posciak@google.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

Please add some description about the fix (in the commit log/message).


On 12 December 2012 16:49, Kamil Debski <k.debski@samsung.com> wrote:
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc.c |   88 +++++++++++++-----------------
>  1 file changed, 37 insertions(+), 51 deletions(-)
>
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> index 3afe879..5448ad1 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> @@ -412,62 +412,48 @@ leave_handle_frame:
>  }
>
>  /* Error handling for interrupt */
> -static void s5p_mfc_handle_error(struct s5p_mfc_ctx *ctx,
> -                                unsigned int reason, unsigned int err)
> +static void s5p_mfc_handle_error(struct s5p_mfc_dev *dev,
> +               struct s5p_mfc_ctx *ctx, unsigned int reason, unsigned int err)
>  {
> -       struct s5p_mfc_dev *dev;
>         unsigned long flags;
>
> -       /* If no context is available then all necessary
> -        * processing has been done. */
> -       if (ctx == NULL)
> -               return;
> -
> -       dev = ctx->dev;
>         mfc_err("Interrupt Error: %08x\n", err);
> -       s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
> -       wake_up_dev(dev, reason, err);
>
> -       /* Error recovery is dependent on the state of context */
> -       switch (ctx->state) {
> -       case MFCINST_INIT:
> -               /* This error had to happen while acquireing instance */
> -       case MFCINST_GOT_INST:
> -               /* This error had to happen while parsing the header */
> -       case MFCINST_HEAD_PARSED:
> -               /* This error had to happen while setting dst buffers */
> -       case MFCINST_RETURN_INST:
> -               /* This error had to happen while releasing instance */
> -               clear_work_bit(ctx);
> -               wake_up_ctx(ctx, reason, err);
> -               if (test_and_clear_bit(0, &dev->hw_lock) == 0)
> -                       BUG();
> -               s5p_mfc_clock_off();
> -               ctx->state = MFCINST_ERROR;
> -               break;
> -       case MFCINST_FINISHING:
> -       case MFCINST_FINISHED:
> -       case MFCINST_RUNNING:
> -               /* It is higly probable that an error occured
> -                * while decoding a frame */
> -               clear_work_bit(ctx);
> -               ctx->state = MFCINST_ERROR;
> -               /* Mark all dst buffers as having an error */
> -               spin_lock_irqsave(&dev->irqlock, flags);
> -               s5p_mfc_hw_call(dev->mfc_ops, cleanup_queue, &ctx->dst_queue,
> -                               &ctx->vq_dst);
> -               /* Mark all src buffers as having an error */
> -               s5p_mfc_hw_call(dev->mfc_ops, cleanup_queue, &ctx->src_queue,
> -                               &ctx->vq_src);
> -               spin_unlock_irqrestore(&dev->irqlock, flags);
> -               if (test_and_clear_bit(0, &dev->hw_lock) == 0)
> -                       BUG();
> -               s5p_mfc_clock_off();
> -               break;
> -       default:
> -               mfc_err("Encountered an error interrupt which had not been handled\n");
> -               break;
> +       if (ctx != NULL) {
> +               /* Error recovery is dependent on the state of context */
> +               switch (ctx->state) {
> +               case MFCINST_RES_CHANGE_INIT:
> +               case MFCINST_RES_CHANGE_FLUSH:
> +               case MFCINST_RES_CHANGE_END:
> +               case MFCINST_FINISHING:
> +               case MFCINST_FINISHED:
> +               case MFCINST_RUNNING:
> +                       /* It is higly probable that an error occured
> +                        * while decoding a frame */
> +                       clear_work_bit(ctx);
> +                       ctx->state = MFCINST_ERROR;
> +                       /* Mark all dst buffers as having an error */
> +                       spin_lock_irqsave(&dev->irqlock, flags);
> +                       s5p_mfc_hw_call(dev->mfc_ops, cleanup_queue,
> +                                               &ctx->dst_queue, &ctx->vq_dst);
> +                       /* Mark all src buffers as having an error */
> +                       s5p_mfc_hw_call(dev->mfc_ops, cleanup_queue,
> +                                               &ctx->src_queue, &ctx->vq_src);
> +                       spin_unlock_irqrestore(&dev->irqlock, flags);
> +                       wake_up_ctx(ctx, reason, err);
> +                       break;
> +               default:
> +                       clear_work_bit(ctx);
> +                       ctx->state = MFCINST_ERROR;
> +                       wake_up_ctx(ctx, reason, err);
> +                       break;
> +               }
>         }
> +       if (test_and_clear_bit(0, &dev->hw_lock) == 0)
> +               BUG();
> +       s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
> +       s5p_mfc_clock_off();
> +       wake_up_dev(dev, reason, err);
>         return;
>  }
>
> @@ -632,7 +618,7 @@ static irqreturn_t s5p_mfc_irq(int irq, void *priv)
>                                 dev->warn_start)
>                         s5p_mfc_handle_frame(ctx, reason, err);
>                 else
> -                       s5p_mfc_handle_error(ctx, reason, err);
> +                       s5p_mfc_handle_error(dev, ctx, reason, err);
>                 clear_bit(0, &dev->enter_suspend);
>                 break;
>
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
With warm regards,
Sachin
