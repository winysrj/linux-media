Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:33781 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbZFQC21 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jun 2009 22:28:27 -0400
Date: Tue, 16 Jun 2009 23:28:25 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: AH <andrzej.hajda@wp.pl>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] High resolution timer for cx88 remotes
Message-ID: <20090616232825.31978261@pedra.chehab.org>
In-Reply-To: <4A17E6A9.4070409@wp.pl>
References: <4A17E6A9.4070409@wp.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 23 May 2009 14:06:01 +0200
AH <andrzej.hajda@wp.pl> escreveu:

> Hi
> 
> Some remotes requires short polling interval which in modern kernels is 
> below resolution of standard scheduler (schedule_delayed_work), this 
> causes problem of missed keystrokes. One of the solutions is to raise 
> kernel timer frequency, my proposition is to use high resolution timers 
> which are present in kernel since 2.6.16 (at least API AFAIK).
> I have encountered this problem on my Winfast 2000XP Expert, but after 
> checking cx88-input.c it seems that following cards can be affected also:
> WINFAST2000XP_EXPERT
> WINFAST_DTV1000
> WINFAST_TV2000_XP_GLOBAL
> PROLINK_PLAYTVPVR
> PIXELVIEW_PLAYTV_ULTRA_PRO
> PROLINK_PV_8000GT
> PROLINK_PV_GLOBAL_XTREME
> KWORLD_LTV883
> MSI_TVANYWHERE_MASTER
> 
> Patched driver seems to work on my system, with kernel 2.6.28.
> I have removed kernel checks for versions below 2.6.20 - they were 
> because of API changes in scheduler.
> 
> I have not tested it on older kernels.
> 
> Regards
> AH
> 
> diff -r 315bc4b65b4f linux/drivers/media/video/cx88/cx88-input.c
> --- a/linux/drivers/media/video/cx88/cx88-input.c       Sun May 17 
> 12:28:55 2009 +0000
> +++ b/linux/drivers/media/video/cx88/cx88-input.c       Sat May 23 
> 14:04:17 2009 +0200
> @@ -23,10 +23,10 @@
>   */
> 
>  #include <linux/init.h>
> -#include <linux/delay.h>
>  #include <linux/input.h>
>  #include <linux/pci.h>
>  #include <linux/module.h>
> +#include <linux/hrtimer.h>
> 
>  #include "compat.h"
>  #include "cx88.h"
> @@ -49,7 +49,7 @@
> 
>         /* poll external decoder */
>         int polling;
> -       struct delayed_work work;
> +       struct hrtimer timer;
>         u32 gpio_addr;
>         u32 last_gpio;
>         u32 mask_keycode;
> @@ -144,31 +144,25 @@
>         }
>  }
> 
> -#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
> -static void cx88_ir_work(void *data)
> -#else
> -static void cx88_ir_work(struct work_struct *work)
> -#endif
> +enum hrtimer_restart cx88_ir_work(struct hrtimer *timer)
>  {
> -#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
> -       struct cx88_IR *ir = data;
> -#else
> -       struct cx88_IR *ir = container_of(work, struct cx88_IR, work.work);
> -#endif
> +       unsigned long missed;
> +       struct cx88_IR *ir = container_of(timer, struct cx88_IR, timer);
> 
>         cx88_ir_handle_key(ir);
> -       schedule_delayed_work(&ir->work, msecs_to_jiffies(ir->polling));
> +       missed = hrtimer_forward_now(&ir->timer, ktime_set(0, 
> ir->polling * 1000000));

Hmm... this patch got line wrapped. please fix it and re-send.

> +       if (missed > 1)
> +               ir_dprintk("Missed ticks %ld\n", missed - 1);
> +
> +       return HRTIMER_RESTART;
>  }
> 
>  void cx88_ir_start(struct cx88_core *core, struct cx88_IR *ir)
>  {
>         if (ir->polling) {
> -#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
> -               INIT_DELAYED_WORK(&ir->work, cx88_ir_work, ir);
> -#else
> -               INIT_DELAYED_WORK(&ir->work, cx88_ir_work);
> -#endif
> -               schedule_delayed_work(&ir->work, 0);
> +               hrtimer_init(&ir->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
> +               ir->timer.function = cx88_ir_work;
> +               hrtimer_start(&ir->timer, ktime_set(0, ir->polling * 
> 1000000), HRTIMER_MODE_REL);
>         }
>         if (ir->sampling) {
>                 core->pci_irqmask |= PCI_INT_IR_SMPINT;
> @@ -185,7 +179,7 @@
>         }
> 
>         if (ir->polling)
> -               cancel_delayed_work_sync(&ir->work);
> +               hrtimer_cancel(&ir->timer);
>  }
> 
>  /* 
> ---------------------------------------------------------------------- */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html




Cheers,
Mauro
