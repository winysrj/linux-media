Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:34287 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754953Ab0G3Cm3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jul 2010 22:42:29 -0400
Subject: Re: [PATCH 04/13] IR: fix locking in ir_raw_event_work
From: Andy Walls <awalls@md.metrocast.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: lirc-list@lists.sourceforge.net, Jarod Wilson <jarod@wilsonet.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Christoph Bartelmus <lirc@bartelmus.de>
In-Reply-To: <1280456235-2024-5-git-send-email-maximlevitsky@gmail.com>
References: <1280456235-2024-1-git-send-email-maximlevitsky@gmail.com>
	 <1280456235-2024-5-git-send-email-maximlevitsky@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Jul 2010 22:42:49 -0400
Message-ID: <1280457769.15737.72.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2010-07-30 at 05:17 +0300, Maxim Levitsky wrote:
> It is prefectly possible to have ir_raw_event_work
> running concurently on two cpus, thus we must protect
> it from that situation.

Yup, the work is marked as not pending (and hence reschedulable) just
before the work handler is run.


> Maybe better solution is to ditch the workqueue at all
> and use good 'ol thread per receiver, and just wake it up...

I suppose you could also use a single threaded workqueue instead of a
mutex, and let a bit test provide exclusivity.  With the mutex, when the
second thread finally obtains the lock, there will likely not be
anything for it to do.

Regards,
Andy


> Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> ---
>  drivers/media/IR/ir-raw-event.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/IR/ir-raw-event.c b/drivers/media/IR/ir-raw-event.c
> index 9d5c029..4098748 100644
> --- a/drivers/media/IR/ir-raw-event.c
> +++ b/drivers/media/IR/ir-raw-event.c
> @@ -40,13 +40,16 @@ static void ir_raw_event_work(struct work_struct *work)
>  	struct ir_raw_event_ctrl *raw =
>  		container_of(work, struct ir_raw_event_ctrl, rx_work);
>  
> +	mutex_lock(&ir_raw_handler_lock);
> +
>  	while (kfifo_out(&raw->kfifo, &ev, sizeof(ev)) == sizeof(ev)) {
> -		mutex_lock(&ir_raw_handler_lock);
>  		list_for_each_entry(handler, &ir_raw_handler_list, list)
>  			handler->decode(raw->input_dev, ev);
> -		mutex_unlock(&ir_raw_handler_lock);
>  		raw->prev_ev = ev;
>  	}
> +
> +	mutex_unlock(&ir_raw_handler_lock);
> +
>  }
>  
>  /**


