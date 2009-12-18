Return-path: <linux-media-owner@vger.kernel.org>
Received: from www84.your-server.de ([213.133.104.84]:52171 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbZLRV52 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2009 16:57:28 -0500
Subject: Re: [Fwd: [patch] media video cx23888 driver: ported to new kfifo
 API]
From: Stefani Seibold <stefani@seibold.net>
To: Andy Walls <awalls@radix.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <1261172359.3060.11.camel@palomino.walls.org>
References: <4B2B5622.80604@infradead.org>
	 <1261137648.3080.36.camel@palomino.walls.org>
	 <1261138265.8293.2.camel@wall-e>
	 <1261172359.3060.11.camel@palomino.walls.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 18 Dec 2009 22:57:22 +0100
Message-ID: <1261173442.13019.13.camel@wall-e>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Freitag, den 18.12.2009, 16:39 -0500 schrieb Andy Walls:
> On Fri, 2009-12-18 at 13:11 +0100, Stefani Seibold wrote:
> > Am Freitag, den 18.12.2009, 07:00 -0500 schrieb Andy Walls:
> > > On Fri, 2009-12-18 at 08:14 -0200, Mauro Carvalho Chehab wrote:
> 
> > > 
> > > Stefani and Mauro,
> > > 
> > > My comments/concerns are in line:
> > > 
> > > > -------- Mensagem original --------
> > > > Assunto: [patch] media video cx23888 driver: ported to new kfifo API
> > > > Data: Fri, 18 Dec 2009 09:12:34 +0100
> > > > De: Stefani Seibold <stefani@seibold.net>
> > > > Para: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,  Mauro Carvalho Chehab <mchehab@infradead.org>
> > > > 
> > > > This patch will fix the cx23888 driver to use the new kfifo API.
> > > > 
> > > > The patch-set is against current mm tree from 11-Dec-2009
> > > > 
> > > > Greetings,
> > > > Stefani
> > > > 
> > > > Signed-off-by: Stefani Seibold <stefani@seibold.net>
> > > > ---
> > > >  cx23888-ir.c |   35 ++++++++++-------------------------
> > > >  1 file changed, 10 insertions(+), 25 deletions(-)
> > > > 
> > > > --- mmotm.orig/drivers/media/video/cx23885/cx23888-ir.c	2009-12-18 08:42:53.936778002 +0100
> > > > +++ mmotm/drivers/media/video/cx23885/cx23888-ir.c	2009-12-18 09:03:04.808703259 +0100
> 
> > > > @@ -631,7 +629,7 @@ static int cx23888_ir_irq_handler(struct
> > > >  		cx23888_ir_write4(dev, CX23888_IR_CNTRL_REG, cntrl);
> > > >  		*handled = true;
> > > >  	}
> > > > -	if (kfifo_len(state->rx_kfifo) >= CX23888_IR_RX_KFIFO_SIZE / 2)
> > > > +	if (kfifo_len(&state->rx_kfifo) >= CX23888_IR_RX_KFIFO_SIZE / 2)
> > > >  		events |= V4L2_SUBDEV_IR_RX_FIFO_SERVICE_REQ;
> > > >  
> > > >  	if (events)
> > > 
> > > I am concerned about reading the kfifo_len() without taking the lock,
> > > since another thread on another CPU may be reading from the kfifo at the
> > > same time.
> > > 
> > > If the new kfifo implementation has an atomic_read() or something behind
> > > the kfifo_len() call, then OK.
> > > 
> > > 
> > > > @@ -657,7 +655,7 @@ static int cx23888_ir_rx_read(struct v4l
> > > >  		return 0;
> > > >  	}
> > > >  
> > > > -	n = kfifo_get(state->rx_kfifo, buf, n);
> > > > +	n = kfifo_out_locked(&state->rx_kfifo, buf, n, &state->rx_kfifo_lock);
> > > >  
> > > >  	n /= sizeof(u32);
> > > >  	*num = n * sizeof(u32);
> > > > @@ -785,7 +783,7 @@ static int cx23888_ir_rx_s_parameters(st
> > > >  	o->interrupt_enable = p->interrupt_enable;
> > > >  	o->enable = p->enable;
> > > >  	if (p->enable) {
> > > > -		kfifo_reset(state->rx_kfifo);
> > > > +		kfifo_reset(&state->rx_kfifo);
> > > >  		if (p->interrupt_enable)
> > > >  			irqenable_rx(dev, IRQEN_RSE | IRQEN_RTE | IRQEN_ROE);
> > > >  		control_rx_enable(dev, p->enable);
> > > 
> > > Same concern about kfifo_reset() not taking the lock, and another thread
> > > reading data from the kfifo at the same time.  In the cx23885 module,
> > > this would mostly likely happen only during module unload as things are
> > > being shut down.
> > > 
> 
> > Sorry, i ported it only to the new API. I did not touch the
> > functionality.
> 
> Stefani,
> 
> Huh?  The new kfifo implementation you wrote removed the locks from
> kfifo_len() and kfifo_reset().  By changing those two functions to not
> provide locking, you changed the functionality.

You are right. Brain was temporary switch off. But kfifo_len() did not
requiere a lock in my opinion. It is save to use without a look. 

But the use of kfifo_reset() is without locking dangerous. 

I will write a path to lock your operations and send it to andrew.

Stefani


