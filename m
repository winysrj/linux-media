Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60020 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932126Ab0EMTBQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 May 2010 15:01:16 -0400
Received: by pwi10 with SMTP id 10so193705pwi.19
        for <linux-media@vger.kernel.org>; Thu, 13 May 2010 12:01:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BEC483E.2010006@redhat.com>
References: <4BEC483E.2010006@redhat.com>
Date: Thu, 13 May 2010 16:01:15 -0300
Message-ID: <o2m68cac7521005131201g10d18783yb89991e67429cebc@mail.gmail.com>
Subject: Re: [PATCH -hg] Build fix for mercurial tree
From: Douglas Schilling Landgraf <dougsland@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 13, 2010 at 3:43 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Fix backport tree compilations with kernels older than 2.6.33.
>
> Compile tested only, with 2.6.32.4 kernel.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>
> diff --git a/linux/drivers/media/IR/ir-core-priv.h b/linux/drivers/media/IR/ir-core-priv.h
> --- a/linux/drivers/media/IR/ir-core-priv.h
> +++ b/linux/drivers/media/IR/ir-core-priv.h
> @@ -28,7 +28,11 @@ struct ir_raw_handler {
>
>  struct ir_raw_event_ctrl {
>        struct work_struct              rx_work;        /* for the rx decoding workqueue */
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 33)
> +       struct kfifo                    *kfifo;         /* fifo for the pulse/space durations */
> +#else
>        struct kfifo                    kfifo;          /* fifo for the pulse/space durations */
> +#endif
>        ktime_t                         last_event;     /* when last event occurred */
>        enum raw_event_type             last_type;      /* last event type */
>        struct input_dev                *input_dev;     /* pointer to the parent input_dev */
> diff --git a/linux/drivers/media/IR/ir-raw-event.c b/linux/drivers/media/IR/ir-raw-event.c
> --- a/linux/drivers/media/IR/ir-raw-event.c
> +++ b/linux/drivers/media/IR/ir-raw-event.c
> @@ -61,8 +61,13 @@ static void ir_raw_event_work(struct wor
>        struct ir_raw_event_ctrl *raw =
>                container_of(work, struct ir_raw_event_ctrl, rx_work);
>
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 33)
> +       while (kfifo_get(raw->kfifo, (void *)&ev, sizeof(ev)) == sizeof(ev))
> +               RUN_DECODER(decode, raw->input_dev, ev);
> +#else
>        while (kfifo_out(&raw->kfifo, &ev, sizeof(ev)) == sizeof(ev))
>                RUN_DECODER(decode, raw->input_dev, ev);
> +#endif
>  }
>
>  int ir_raw_event_register(struct input_dev *input_dev)
> @@ -77,8 +82,15 @@ int ir_raw_event_register(struct input_d
>        ir->raw->input_dev = input_dev;
>        INIT_WORK(&ir->raw->rx_work, ir_raw_event_work);
>
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 33)
> +       ir->raw->kfifo = kfifo_alloc(sizeof(s64) * MAX_IR_EVENT_SIZE,
> +                                    GFP_KERNEL, NULL);
> +       if (ir->raw->kfifo == NULL)
> +               rc = -ENOMEM;
> +#else
>        rc = kfifo_alloc(&ir->raw->kfifo, sizeof(s64) * MAX_IR_EVENT_SIZE,
>                         GFP_KERNEL);
> +#endif
>        if (rc < 0) {
>                kfree(ir->raw);
>                ir->raw = NULL;
> @@ -87,7 +99,11 @@ int ir_raw_event_register(struct input_d
>
>        rc = RUN_DECODER(raw_register, input_dev);
>        if (rc < 0) {
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 33)
> +               kfifo_free(ir->raw->kfifo);
> +#else
>                kfifo_free(&ir->raw->kfifo);
> +#endif
>                kfree(ir->raw);
>                ir->raw = NULL;
>                return rc;
> @@ -106,7 +122,11 @@ void ir_raw_event_unregister(struct inpu
>        cancel_work_sync(&ir->raw->rx_work);
>        RUN_DECODER(raw_unregister, input_dev);
>
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 33)
> +       kfifo_free(ir->raw->kfifo);
> +#else
>        kfifo_free(&ir->raw->kfifo);
> +#endif
>        kfree(ir->raw);
>        ir->raw = NULL;
>  }
> @@ -128,8 +148,13 @@ int ir_raw_event_store(struct input_dev
>        if (!ir->raw)
>                return -EINVAL;
>
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 33)
> +       if (kfifo_put(ir->raw->kfifo, (void *)ev, sizeof(*ev)) != sizeof(*ev))
> +               return -ENOMEM;
> +#else
>        if (kfifo_in(&ir->raw->kfifo, ev, sizeof(*ev)) != sizeof(*ev))
>                return -ENOMEM;
> +#endif
>
>        return 0;
>  }
>
>

Applied, thanks.

Cheers
Douglas
