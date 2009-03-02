Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:40405 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754417AbZCBWcv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Mar 2009 17:32:51 -0500
Subject: Re: General protection fault on rmmod cx8800
From: Andy Walls <awalls@radix.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-media@vger.kernel.org
In-Reply-To: <20090302200513.7fc3568e@hyperion.delvare>
References: <20090215214108.34f31c39@hyperion.delvare>
	 <20090302133936.00899692@hyperion.delvare>
	 <1236003365.3071.6.camel@palomino.walls.org>
	 <20090302170349.18c8fd75@hyperion.delvare>
	 <20090302200513.7fc3568e@hyperion.delvare>
Content-Type: text/plain
Date: Mon, 02 Mar 2009 17:33:06 -0500
Message-Id: <1236033186.3066.80.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2009-03-02 at 20:05 +0100, Jean Delvare wrote:
> On Mon, 2 Mar 2009 17:03:49 +0100, Jean Delvare wrote:

>From your original oops, the fault is in cx88_ir_work() but
cx88_ir_handle_key() gets inlined, so you'll need to look at both
functions:

   0:	56                   	push   %rsi
   1:	41 55                	push   %r13
   3:	41 54                	push   %r12
   5:	53                   	push   %rbx
   6:	48 83 ec 08          	sub    $0x8,%rsp
   a:	49 89 fc             	mov    %rdi,%r12
   d:	4c 8d af 40 fd ff ff 	lea    -0x2c0(%rdi),%r13   struct cx88_IR *ir = container_of(work, struct cx88_IR, work);
  14:	4c 8b b7 40 fd ff ff 	mov    -0x2c0(%rdi),%r14   struct cx88_core *core = ir->core;
  1b:	41 8b 85 48 03 00 00 	mov    0x348(%r13),%eax    fetch ir->gpio_addr [for gpio = cx_read(ir->gpio_addr);]
  22:	c1 e8 02             	shr    $0x2,%eax           ((reg)>>2)  [from cx_read() macro]
  25:	89 c0                	mov    %eax,%eax           [I don't know - maybe readl() related]
  27:	48 c1 e0 02          	shl    $0x2,%rax           [I don't know - maybe readl() related]
  2b:	49 03 46 40          	add    0x40(%r14),%rax   core->lmmio + ...  <--- Oops is here  
  2f:	8b 18                	mov    (%rax),%ebx       readl(core->lmmio + ((reg)>>2)) [cx_read() definition]
  31:	41 8b 86 10 0a 00 00 	mov    0xa10(%r14),%eax  switch (core->boardnr) {
  38:	83 f8 23             	cmp    $0x23,%eax        case CX88_BOARD_WINFAST_DTV1000:

"core" is invalid as %r14 holds junk:

R14: 2f4065766f6d6572

A valid address would start with  0xffff.....  In fact, %r14's value is
a magic cookie: "remove@/".

It's safe to assume that the work handler was called when the per device
instance of cx88_core was gone.



> > As far as I can see the key difference between bttv-input and
> > cx88-input is that bttv-input only uses a simple self-rearming timer,
> > while cx88-input uses a timer and a separate workqueue. The timer runs
> > the workqueue, which rearms the timer, etc. When you flush the timer,
> > the separate workqueue can be still active. I presume this is what
> > happens on my system. I guess the reason for the separate workqueue is
> > that the processing may take some time and we don't want to hurt the
> > system's performance?
 
> > So we need to flush both the event workqueue (with
> > flush_scheduled_work) and the separate workqueue (with
> > flush_workqueue), at the same time, otherwise the active one may rearm
> > the flushed one again. This looks tricky, as obviously we can't flush
> > both at the exact same time. Alternatively, if we could get rid of one
> > of the queues, we'd have only one that needs flushing, this would be a
> > lot easier...
> 
> Switching to delayed_work seems to do the trick (note this is a 2.6.28
> patch):
> 
> ---
>  drivers/media/video/cx88/cx88-input.c |   26 ++++++++------------------
>  1 file changed, 8 insertions(+), 18 deletions(-)
> 
> --- linux-2.6.28.orig/drivers/media/video/cx88/cx88-input.c	2009-03-02 19:11:24.000000000 +0100
> +++ linux-2.6.28/drivers/media/video/cx88/cx88-input.c	2009-03-02 19:49:31.000000000 +0100
> @@ -48,8 +48,7 @@ struct cx88_IR {
>  
>  	/* poll external decoder */
>  	int polling;
> -	struct work_struct work;
> -	struct timer_list timer;
> +	struct delayed_work work;
>  	u32 gpio_addr;
>  	u32 last_gpio;
>  	u32 mask_keycode;
> @@ -143,27 +142,20 @@ static void cx88_ir_handle_key(struct cx
>  	}
>  }
>  
> -static void ir_timer(unsigned long data)
> -{
> -	struct cx88_IR *ir = (struct cx88_IR *)data;
> -
> -	schedule_work(&ir->work);
> -}
> -
>  static void cx88_ir_work(struct work_struct *work)
>  {
> -	struct cx88_IR *ir = container_of(work, struct cx88_IR, work);
> +	struct delayed_work *dwork = container_of(work, struct delayed_work, work);
> +	struct cx88_IR *ir = container_of(dwork, struct cx88_IR, work);
>  
>  	cx88_ir_handle_key(ir);
> -	mod_timer(&ir->timer, jiffies + msecs_to_jiffies(ir->polling));
> +	schedule_delayed_work(dwork, msecs_to_jiffies(ir->polling));
>  }
>  
>  void cx88_ir_start(struct cx88_core *core, struct cx88_IR *ir)
>  {
>  	if (ir->polling) {
> -		setup_timer(&ir->timer, ir_timer, (unsigned long)ir);
> -		INIT_WORK(&ir->work, cx88_ir_work);
> -		schedule_work(&ir->work);
> +		INIT_DELAYED_WORK(&ir->work, cx88_ir_work);
> +		schedule_delayed_work(&ir->work, msecs_to_jiffies(ir->polling));
>  	}
>  	if (ir->sampling) {
>  		core->pci_irqmask |= PCI_INT_IR_SMPINT;
> @@ -179,10 +171,8 @@ void cx88_ir_stop(struct cx88_core *core
>  		core->pci_irqmask &= ~PCI_INT_IR_SMPINT;
>  	}
>  
> -	if (ir->polling) {
> -		del_timer_sync(&ir->timer);
> -		flush_scheduled_work();
> -	}
> +	if (ir->polling)
> +		cancel_delayed_work_sync(&ir->work);
>  }
>  
>  /* ---------------------------------------------------------------------- */
> 
> At least I didn't have any general protection fault with this patch
> applied. Comments?

Jean,

Reviewed-by: Andy Walls <awalls@radix.net>

I've done some research and this looks good.

1. It's a cleaner way to use the kernel event threads to perform a
periodic action.

2. No races with stopping the work, as cancel_delayed_work_sync()
reliably disarms even self-firing work handler functions like the one
here.  It even appears to make sure it is cancelled from every CPU for a
multithreaded handler, AFAICT.  (No flag variable is needed to signal
work is stopping to the work handler AFAICT.)



Not to start a flame war on supporting older kernels, but I must mention

3. Canceling of work is only supported on more recent kernels.

4. I'm not willing to waste brain cells on how to avoid work canceling
races for older kernels. :)

> Thanks,

Regards,
Andy

