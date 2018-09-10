Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:57442 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1728187AbeIJTFy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Sep 2018 15:05:54 -0400
Date: Mon, 10 Sep 2018 10:11:36 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
cc: linux-media@vger.kernel.org, <linux-usb@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <tglx@linutronix.de>
Subject: Re: [PATCH 3/3] usb: core: remove local_irq_save() around ->complete()
 handler
In-Reply-To: <20180910092000.14693-4-bigeasy@linutronix.de>
Message-ID: <Pine.LNX.4.44L0.1809101011100.1584-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 10 Sep 2018, Sebastian Andrzej Siewior wrote:

> The core disabled interrupts before invocation the ->complete handler
> because the handler might have expected that interrupts are disabled.
> 
> All handlers were audited and use proper locking now. With it, the core
> code no longer needs to disable interrupts before invoking the
> ->complete handler.
> Remove local_irq_save() statement before invoking the ->complete
> handler.
> 
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  drivers/usb/core/hcd.c | 13 -------------
>  1 file changed, 13 deletions(-)
> 
> diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
> index 1c21955fe7c00..f985d2303095c 100644
> --- a/drivers/usb/core/hcd.c
> +++ b/drivers/usb/core/hcd.c
> @@ -1755,20 +1755,7 @@ static void __usb_hcd_giveback_urb(struct urb *urb)
>  
>  	/* pass ownership to the completion handler */
>  	urb->status = status;
> -
> -	/*
> -	 * We disable local IRQs here avoid possible deadlock because
> -	 * drivers may call spin_lock() to hold lock which might be
> -	 * acquired in one hard interrupt handler.
> -	 *
> -	 * The local_irq_save()/local_irq_restore() around complete()
> -	 * will be removed if current USB drivers have been cleaned up
> -	 * and no one may trigger the above deadlock situation when
> -	 * running complete() in tasklet.
> -	 */
> -	local_irq_save(flags);
>  	urb->complete(urb);
> -	local_irq_restore(flags);
>  
>  	usb_anchor_resume_wakeups(anchor);
>  	atomic_dec(&urb->use_count);

Acked-by: Alan Stern <stern@rowland.harvard.edu>
