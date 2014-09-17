Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:58422 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634AbaIQKzj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Sep 2014 06:55:39 -0400
Received: by mail-ig0-f178.google.com with SMTP id a13so991614igq.11
        for <linux-media@vger.kernel.org>; Wed, 17 Sep 2014 03:55:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <033201cfd25d$c13dfb90$43b9f2b0$%debski@samsung.com>
References: <1410763393-12183-1-git-send-email-avnd.kiran@samsung.com>
	<1410763393-12183-6-git-send-email-avnd.kiran@samsung.com>
	<02b901cfd1b9$55dfa9b0$019efd10$%debski@samsung.com>
	<CAFHkUjhTQKwVqAgCTJudz7pXK-cHa4xdWEZa2tLkidphPNmdWw@mail.gmail.com>
	<033201cfd25d$c13dfb90$43b9f2b0$%debski@samsung.com>
Date: Wed, 17 Sep 2014 16:25:37 +0530
Message-ID: <CAFHkUjj8qdRe+04Wh7g2o3A0kNyR3Ka3pKPOk=ciTTT5JmHZtQ@mail.gmail.com>
Subject: Re: [PATCH 05/17] [media] s5p-mfc: don't disable clock when next ctx
 is pending
From: Kiran Avnd <kiran@chromium.org>
To: Kamil Debski <k.debski@samsung.com>
Cc: linux-media@vger.kernel.org, Kiran AVND <avnd.kiran@samsung.com>,
	Wu-cheng Li <wuchengli@chromium.org>,
	Pawel Osciak <posciak@chromium.org>,
	Arun Mankuzhi <arun.m@samsung.com>,
	Ilja Friedel <ihf@chromium.org>,
	Prathyush <prathyush.k@samsung.com>,
	Arun Kumar <arun.kk@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 17, 2014 at 3:27 PM, Kamil Debski <k.debski@samsung.com> wrote:
> Hi,
>
>> From: Kiran Avnd [mailto:kiran@chromium.org]
>> Sent: Wednesday, September 17, 2014 11:26 AM
>>
>> Hi Kamil,
>>
>> On Tue, Sep 16, 2014 at 7:50 PM, Kamil Debski <k.debski@samsung.com>
>> wrote:
>> >
>> > Hi Kiran,
>> >
>> > > From: Kiran AVND [mailto:avnd.kiran@samsung.com]
>> > > Sent: Monday, September 15, 2014 8:43 AM
>> > >
>> > > From: Arun Mankuzhi <arun.m@samsung.com>
>> > >
>> > > In MFC's dynamic clock gating, we turn on the clock in try_run and
>> > > turn off the clock upon receiving an interrupt. But this leads to
>> > > excessive gating/ungating of the clocks in the case of
>> > > multi-instance video playback. The clock gets disabled in ctx1's
>> irq
>> > > and then immediately turned on for ctx2's try_run.
>> > >
>> > > A better solution is to turn off the clocks only when there are no
>> > > new frames to be processed in any context. This is done by
>> > > conditionally clocking on/off calls in try-run. clock-off is done
>> > > outside try-run only for suspend and error scenarios.
>> >
>> > Why is this solution better? According to my best knowledge clock
>> > gating is a simple register write that controls whether the clock is
>> passed.
>> >
>>
>> In newer versions of MFC we cannot turn off the clock asynchronously.
>> There is a bus reset procedure which is added in patch 08/17.
>>
>> Since this procedure involves an overhead of waiting for the bus to
>> complete data transaction, this patch removes clock off at different
>> places and optimizes the number of clock switching .
>
> The patch adds a new reset function - yes, but how this is connected with
> the clock? In s5p_mfc_try_run_* there are s5p_mfc_clock_on/off calls and
> no s5p_mfc_reset in that function. This contradict what you wrote above.
>

Thats right, its a mistake. The changes done in the clock_on and
clock_off functions
is part of another patchset that I will be posting soon, after this.
I shall postpone this change until then,and drop it now,
Thanks for the review,

Regards
Kiran

>>
>> Regards
>> Kiran
>
> Best wishes,
> --
> Kamil Debski
> Samsung R&D Institute Poland
>
>>
>> > Adding an if statement and a new flag in my opinion adds overhead.
>> >
>> > Best wishes,
>> > --
>> > Kamil Debski
>> > Samsung R&D Institute Poland
>> >
>> > >
>> > > Signed-off-by: Prathyush K <prathyush.k@samsung.com>
>> > > Signed-off-by: Arun Mankuzhi <arun.m@samsung.com>
>> > > Signed-off-by: Kiran AVND <avnd.kiran@samsung.com>
>> > > ---
>> > >  drivers/media/platform/s5p-mfc/s5p_mfc.c        |   26 ++++++++---
>> ----
>> > > -------
>> > >  drivers/media/platform/s5p-mfc/s5p_mfc_common.h |    2 +
>> > >  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c |   11 ++++++++-
>> > >  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |   16
>> ++++++++++++-
>> > >  4 files changed, 35 insertions(+), 20 deletions(-)
>> > >
>> > > diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c
>> > > b/drivers/media/platform/s5p-mfc/s5p_mfc.c
>> > > index e37fb99..9df130b 100644
>> > > --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
>> > > +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
>> > > @@ -150,7 +150,8 @@ static void s5p_mfc_watchdog_worker(struct
>> > > work_struct *work)
>> > >               mfc_err("Error: some instance may be
>> closing/opening\n");
>> > >       spin_lock_irqsave(&dev->irqlock, flags);
>> > >
>> > > -     s5p_mfc_clock_off();
>> > > +     if (test_and_clear_bit(0, &dev->clk_flag))
>> > > +             s5p_mfc_clock_off();
>> > >
>> > >       for (i = 0; i < MFC_NUM_CONTEXTS; i++) {
>> > >               ctx = dev->ctx[i];
>> > > @@ -174,7 +175,6 @@ static void s5p_mfc_watchdog_worker(struct
>> > > work_struct *work)
>> > >                       mfc_err("Failed to reload FW\n");
>> > >                       goto unlock;
>> > >               }
>> > > -             s5p_mfc_clock_on();
>> > >               ret = s5p_mfc_init_hw(dev);
>> > >               if (ret)
>> > >                       mfc_err("Failed to reinit FW\n"); @@ -338,7
>> > > +338,6 @@ static void s5p_mfc_handle_frame(struct s5p_mfc_ctx *ctx,
>> > >               wake_up_ctx(ctx, reason, err);
>> > >               if (test_and_clear_bit(0, &dev->hw_lock) == 0)
>> > >                       BUG();
>> > > -             s5p_mfc_clock_off();
>> > >               s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
>> > >               return;
>> > >       }
>> > > @@ -411,12 +410,11 @@ leave_handle_frame:
>> > >       wake_up_ctx(ctx, reason, err);
>> > >       if (test_and_clear_bit(0, &dev->hw_lock) == 0)
>> > >               BUG();
>> > > -     s5p_mfc_clock_off();
>> > > -     /* if suspending, wake up device and do not try_run again*/
>> > > +     /* if suspending, wake up device*/
>> > >       if (test_bit(0, &dev->enter_suspend))
>> > >               wake_up_dev(dev, reason, err);
>> > > -     else
>> > > -             s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
>> > > +
>> > > +     s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
>> > >  }
>> > >
>> > >  /* Error handling for interrupt */
>> > > @@ -460,7 +458,8 @@ static void s5p_mfc_handle_error(struct
>> > > s5p_mfc_dev *dev,
>> > >       if (test_and_clear_bit(0, &dev->hw_lock) == 0)
>> > >               BUG();
>> > >       s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
>> > > -     s5p_mfc_clock_off();
>> > > +     if (test_and_clear_bit(0, &dev->clk_flag))
>> > > +             s5p_mfc_clock_off();
>> > >       wake_up_dev(dev, reason, err);
>> > >       return;
>> > >  }
>> > > @@ -514,7 +513,6 @@ static void s5p_mfc_handle_seq_done(struct
>> > > s5p_mfc_ctx *ctx,
>> > >       clear_work_bit(ctx);
>> > >       if (test_and_clear_bit(0, &dev->hw_lock) == 0)
>> > >               BUG();
>> > > -     s5p_mfc_clock_off();
>> > >       s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
>> > >       wake_up_ctx(ctx, reason, err);  } @@ -554,15 +552,14 @@
>> static
>> > > void s5p_mfc_handle_init_buffers(struct
>> > > s5p_mfc_ctx *ctx,
>> > >               if (test_and_clear_bit(0, &dev->hw_lock) == 0)
>> > >                       BUG();
>> > >
>> > > -             s5p_mfc_clock_off();
>> > > -
>> > >               wake_up(&ctx->queue);
>> > >               s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
>> > >       } else {
>> > >               if (test_and_clear_bit(0, &dev->hw_lock) == 0)
>> > >                       BUG();
>> > >
>> > > -             s5p_mfc_clock_off();
>> > > +             if (test_and_clear_bit(0, &dev->clk_flag))
>> > > +                     s5p_mfc_clock_off();
>> > >
>> > >               wake_up(&ctx->queue);
>> > >       }
>> > > @@ -596,7 +593,6 @@ static void
>> > > s5p_mfc_handle_stream_complete(struct
>> > > s5p_mfc_ctx *ctx,
>> > >
>> > >       WARN_ON(test_and_clear_bit(0, &dev->hw_lock) == 0);
>> > >
>> > > -     s5p_mfc_clock_off();
>> > >       wake_up(&ctx->queue);
>> > >       s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);  } @@ -639,7
>> > > +635,6 @@ static irqreturn_t s5p_mfc_irq(int irq, void *priv)
>> > >                       wake_up_ctx(ctx, reason, err);
>> > >                       if (test_and_clear_bit(0, &dev->hw_lock) ==
>> 0)
>> > >                               BUG();
>> > > -                     s5p_mfc_clock_off();
>> > >                       s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
>> > >               } else {
>> > >                       s5p_mfc_handle_frame(ctx, reason, err); @@
>> > > -704,8
>> > > +699,6 @@ irq_cleanup_hw:
>> > >       if (test_and_clear_bit(0, &dev->hw_lock) == 0)
>> > >               mfc_err("Failed to unlock hw\n");
>> > >
>> > > -     s5p_mfc_clock_off();
>> > > -
>> > >       s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
>> > >       mfc_debug(2, "Exit via irq_cleanup_hw\n");
>> > >       return IRQ_HANDLED;
>> > > @@ -1216,6 +1209,7 @@ static int s5p_mfc_probe(struct
>> > > platform_device
>> > > *pdev)
>> > >       platform_set_drvdata(pdev, dev);
>> > >
>> > >       dev->hw_lock = 0;
>> > > +     dev->clk_flag = 0;
>> > >       dev->watchdog_workqueue =
>> > > create_singlethread_workqueue(S5P_MFC_NAME);
>> > >       INIT_WORK(&dev->watchdog_work, s5p_mfc_watchdog_worker);
>> > >       atomic_set(&dev->watchdog_cnt, 0); diff --git
>> > > a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
>> > > b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
>> > > index 01816ff..92f596e 100644
>> > > --- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
>> > > +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
>> > > @@ -289,6 +289,7 @@ struct s5p_mfc_priv_buf {
>> > >   * @watchdog_workqueue:      workqueue for the watchdog
>> > >   * @watchdog_work:   worker for the watchdog
>> > >   * @alloc_ctx:               videobuf2 allocator contexts for two
>> memory
>> > > banks
>> > > + * @clk_flag:                flag used for dynamic control of mfc
>> clock
>> > >   * @enter_suspend:   flag set when entering suspend
>> > >   * @ctx_buf:         common context memory (MFCv6)
>> > >   * @warn_start:              hardware error code from which
>> warnings
>> > start
>> > > @@ -332,6 +333,7 @@ struct s5p_mfc_dev {
>> > >       struct workqueue_struct *watchdog_workqueue;
>> > >       struct work_struct watchdog_work;
>> > >       void *alloc_ctx[2];
>> > > +     unsigned long clk_flag;
>> > >       unsigned long enter_suspend;
>> > >
>> > >       struct s5p_mfc_priv_buf ctx_buf; diff --git
>> > > a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
>> > > b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
>> > > index 58ec7bb..e2b2f31 100644
>> > > --- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
>> > > +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
>> > > @@ -1371,6 +1371,8 @@ static void s5p_mfc_try_run_v5(struct
>> > > s5p_mfc_dev
>> > > *dev)
>> > >
>> > >       if (test_bit(0, &dev->enter_suspend)) {
>> > >               mfc_debug(1, "Entering suspend so do not schedule any
>> > > jobs\n");
>> > > +             if (test_and_clear_bit(0, &dev->clk_flag))
>> > > +                     s5p_mfc_clock_off();
>> > >               return;
>> > >       }
>> > >       /* Check whether hardware is not running */ @@ -1383,6
>> +1385,8
>> > > @@ static void s5p_mfc_try_run_v5(struct s5p_mfc_dev *dev)
>> > >       new_ctx = s5p_mfc_get_new_ctx(dev);
>> > >       if (new_ctx < 0) {
>> > >               /* No contexts to run */
>> > > +             if (test_and_clear_bit(0, &dev->clk_flag))
>> > > +                     s5p_mfc_clock_off();
>> > >               if (test_and_clear_bit(0, &dev->hw_lock) == 0) {
>> > >                       mfc_err("Failed to unlock hardware\n");
>> > >                       return;
>> > > @@ -1396,7 +1400,9 @@ static void s5p_mfc_try_run_v5(struct
>> > > s5p_mfc_dev
>> > > *dev)
>> > >        * Last frame has already been sent to MFC.
>> > >        * Now obtaining frames from MFC buffer
>> > >        */
>> > > -     s5p_mfc_clock_on();
>> > > +     if (test_and_set_bit(0, &dev->clk_flag) == 0)
>> > > +             s5p_mfc_clock_on();
>> > > +
>> > >       if (ctx->type == MFCINST_DECODER) {
>> > >               s5p_mfc_set_dec_desc_buffer(ctx);
>> > >               switch (ctx->state) {
>> > > @@ -1474,7 +1480,8 @@ static void s5p_mfc_try_run_v5(struct
>> > > s5p_mfc_dev
>> > > *dev)
>> > >                * scheduled, reduce the clock count as no one will
>> > >                * ever do this, because no interrupt related to this
>> > > try_run
>> > >                * will ever come from hardware. */
>> > > -             s5p_mfc_clock_off();
>> > > +             if (test_and_clear_bit(0, &dev->clk_flag))
>> > > +                     s5p_mfc_clock_off();
>> > >       }
>> > >  }
>> > >
>> > > diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
>> > > b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
>> > > index 85600f2..8cf1c6f 100644
>> > > --- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
>> > > +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
>> > > @@ -1745,6 +1745,13 @@ static void s5p_mfc_try_run_v6(struct
>> > > s5p_mfc_dev *dev)
>> > >
>> > >       mfc_debug(1, "Try run dev: %p\n", dev);
>> > >
>> > > +     if (test_bit(0, &dev->enter_suspend)) {
>> > > +             mfc_debug(1, "Entering suspend so do not schedule any
>> > > jobs\n");
>> > > +             if (test_and_clear_bit(0, &dev->clk_flag))
>> > > +                     s5p_mfc_clock_off();
>> > > +             return;
>> > > +     }
>> > > +
>> > >       /* Check whether hardware is not running */
>> > >       if (test_and_set_bit(0, &dev->hw_lock) != 0) {
>> > >               /* This is perfectly ok, the scheduled ctx should
>> wait
>> > > */ @@ -1756,6 +1763,8 @@ static void s5p_mfc_try_run_v6(struct
>> > > s5p_mfc_dev
>> > > *dev)
>> > >       new_ctx = s5p_mfc_get_new_ctx(dev);
>> > >       if (new_ctx < 0) {
>> > >               /* No contexts to run */
>> > > +             if (test_and_clear_bit(0, &dev->clk_flag))
>> > > +                     s5p_mfc_clock_off();
>> > >               if (test_and_clear_bit(0, &dev->hw_lock) == 0) {
>> > >                       mfc_err("Failed to unlock hardware.\n");
>> > >                       return;
>> > > @@ -1775,7 +1784,9 @@ static void s5p_mfc_try_run_v6(struct
>> > > s5p_mfc_dev
>> > > *dev)
>> > >       /* Last frame has already been sent to MFC
>> > >        * Now obtaining frames from MFC buffer */
>> > >
>> > > -     s5p_mfc_clock_on();
>> > > +     if (test_and_set_bit(0, &dev->clk_flag) == 0)
>> > > +             s5p_mfc_clock_on();
>> > > +
>> > >       if (ctx->type == MFCINST_DECODER) {
>> > >               switch (ctx->state) {
>> > >               case MFCINST_FINISHING:
>> > > @@ -1855,7 +1866,8 @@ static void s5p_mfc_try_run_v6(struct
>> > > s5p_mfc_dev
>> > > *dev)
>> > >                * scheduled, reduce the clock count as no one will
>> > >                * ever do this, because no interrupt related to this
>> > > try_run
>> > >                * will ever come from hardware. */
>> > > -             s5p_mfc_clock_off();
>> > > +             if (test_and_clear_bit(0, &dev->clk_flag))
>> > > +                     s5p_mfc_clock_off();
>> > >       }
>> > >  }
>> > >
>> > > --
>> > > 1.7.3.rc2
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-
>> media"
>> > in the body of a message to majordomo@vger.kernel.org More majordomo
>> > info at  http://vger.kernel.org/majordomo-info.html
>
