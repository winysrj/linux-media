Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:20985 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927Ab2LMJRX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Dec 2012 04:17:23 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MEY007PCPVX4K50@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 13 Dec 2012 09:19:58 +0000 (GMT)
Received: from AMDN910 ([106.116.147.102])
 by eusync4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MEY0074GPSQ3S00@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 13 Dec 2012 09:17:21 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: 'Sachin Kamat' <sachin.kamat@linaro.org>
Cc: linux-media@vger.kernel.org, jtp.park@samsung.com,
	arun.kk@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>,
	posciak@google.com, 'Kyungmin Park' <kyungmin.park@samsung.com>
References: <1355311184-30029-1-git-send-email-k.debski@samsung.com>
 <CAK9yfHyNO8jhjtueR9eL=q-85AB_CN9Ok61LftBG8ufmZzJzbQ@mail.gmail.com>
In-reply-to: <CAK9yfHyNO8jhjtueR9eL=q-85AB_CN9Ok61LftBG8ufmZzJzbQ@mail.gmail.com>
Subject: RE: [PATCH] s5p-mfc: Fix interrupt error handling routine
Date: Thu, 13 Dec 2012 10:17:12 +0100
Message-id: <016a01cdd912$a4243f10$ec6cbd30$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

No problem. First I would like to see this tested by Arun Kumar (he has
Exynos 5) and Pawel Osciak (he did report the problem to me).

I did test it using my test suite but the more tests we run the better.
If you have some MFC tests then I would appreciate your input too.

Best wishes,
-- 
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center


> From: Sachin Kamat [mailto:sachin.kamat@linaro.org]
> 
> Hi Kamil,
> 
> Please add some description about the fix (in the commit log/message).
> 
> 
> On 12 December 2012 16:49, Kamil Debski <k.debski@samsung.com> wrote:
> > Signed-off-by: Kamil Debski <k.debski@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >  drivers/media/platform/s5p-mfc/s5p_mfc.c |   88 +++++++++++++-------
> ----------
> >  1 file changed, 37 insertions(+), 51 deletions(-)
> >
> > diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> > b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> > index 3afe879..5448ad1 100644
> > --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> > +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> > @@ -412,62 +412,48 @@ leave_handle_frame:
> >  }
> >
> >  /* Error handling for interrupt */
> > -static void s5p_mfc_handle_error(struct s5p_mfc_ctx *ctx,
> > -                                unsigned int reason, unsigned int
> err)
> > +static void s5p_mfc_handle_error(struct s5p_mfc_dev *dev,
> > +               struct s5p_mfc_ctx *ctx, unsigned int reason,
> unsigned
> > +int err)
> >  {
> > -       struct s5p_mfc_dev *dev;
> >         unsigned long flags;
> >
> > -       /* If no context is available then all necessary
> > -        * processing has been done. */
> > -       if (ctx == NULL)
> > -               return;
> > -
> > -       dev = ctx->dev;
> >         mfc_err("Interrupt Error: %08x\n", err);
> > -       s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
> > -       wake_up_dev(dev, reason, err);
> >
> > -       /* Error recovery is dependent on the state of context */
> > -       switch (ctx->state) {
> > -       case MFCINST_INIT:
> > -               /* This error had to happen while acquireing instance
> */
> > -       case MFCINST_GOT_INST:
> > -               /* This error had to happen while parsing the header
> */
> > -       case MFCINST_HEAD_PARSED:
> > -               /* This error had to happen while setting dst buffers
> */
> > -       case MFCINST_RETURN_INST:
> > -               /* This error had to happen while releasing instance
> */
> > -               clear_work_bit(ctx);
> > -               wake_up_ctx(ctx, reason, err);
> > -               if (test_and_clear_bit(0, &dev->hw_lock) == 0)
> > -                       BUG();
> > -               s5p_mfc_clock_off();
> > -               ctx->state = MFCINST_ERROR;
> > -               break;
> > -       case MFCINST_FINISHING:
> > -       case MFCINST_FINISHED:
> > -       case MFCINST_RUNNING:
> > -               /* It is higly probable that an error occured
> > -                * while decoding a frame */
> > -               clear_work_bit(ctx);
> > -               ctx->state = MFCINST_ERROR;
> > -               /* Mark all dst buffers as having an error */
> > -               spin_lock_irqsave(&dev->irqlock, flags);
> > -               s5p_mfc_hw_call(dev->mfc_ops, cleanup_queue, &ctx-
> >dst_queue,
> > -                               &ctx->vq_dst);
> > -               /* Mark all src buffers as having an error */
> > -               s5p_mfc_hw_call(dev->mfc_ops, cleanup_queue, &ctx-
> >src_queue,
> > -                               &ctx->vq_src);
> > -               spin_unlock_irqrestore(&dev->irqlock, flags);
> > -               if (test_and_clear_bit(0, &dev->hw_lock) == 0)
> > -                       BUG();
> > -               s5p_mfc_clock_off();
> > -               break;
> > -       default:
> > -               mfc_err("Encountered an error interrupt which had not
> been handled\n");
> > -               break;
> > +       if (ctx != NULL) {
> > +               /* Error recovery is dependent on the state of
> context */
> > +               switch (ctx->state) {
> > +               case MFCINST_RES_CHANGE_INIT:
> > +               case MFCINST_RES_CHANGE_FLUSH:
> > +               case MFCINST_RES_CHANGE_END:
> > +               case MFCINST_FINISHING:
> > +               case MFCINST_FINISHED:
> > +               case MFCINST_RUNNING:
> > +                       /* It is higly probable that an error occured
> > +                        * while decoding a frame */
> > +                       clear_work_bit(ctx);
> > +                       ctx->state = MFCINST_ERROR;
> > +                       /* Mark all dst buffers as having an error */
> > +                       spin_lock_irqsave(&dev->irqlock, flags);
> > +                       s5p_mfc_hw_call(dev->mfc_ops, cleanup_queue,
> > +                                               &ctx->dst_queue,
> &ctx->vq_dst);
> > +                       /* Mark all src buffers as having an error */
> > +                       s5p_mfc_hw_call(dev->mfc_ops, cleanup_queue,
> > +                                               &ctx->src_queue,
> &ctx->vq_src);
> > +                       spin_unlock_irqrestore(&dev->irqlock, flags);
> > +                       wake_up_ctx(ctx, reason, err);
> > +                       break;
> > +               default:
> > +                       clear_work_bit(ctx);
> > +                       ctx->state = MFCINST_ERROR;
> > +                       wake_up_ctx(ctx, reason, err);
> > +                       break;
> > +               }
> >         }
> > +       if (test_and_clear_bit(0, &dev->hw_lock) == 0)
> > +               BUG();
> > +       s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
> > +       s5p_mfc_clock_off();
> > +       wake_up_dev(dev, reason, err);
> >         return;
> >  }
> >
> > @@ -632,7 +618,7 @@ static irqreturn_t s5p_mfc_irq(int irq, void
> *priv)
> >                                 dev->warn_start)
> >                         s5p_mfc_handle_frame(ctx, reason, err);
> >                 else
> > -                       s5p_mfc_handle_error(ctx, reason, err);
> > +                       s5p_mfc_handle_error(dev, ctx, reason, err);
> >                 clear_bit(0, &dev->enter_suspend);
> >                 break;
> >
> > --
> > 1.7.9.5
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-
> media"
> > in the body of a message to majordomo@vger.kernel.org More majordomo
> > info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
> --
> With warm regards,
> Sachin


