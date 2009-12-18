Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:39748 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932735AbZLRVkU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2009 16:40:20 -0500
Subject: Re: [Fwd: [patch] media video cx23888 driver: ported to new kfifo
 API]
From: Andy Walls <awalls@radix.net>
To: Stefani Seibold <stefani@seibold.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <1261138265.8293.2.camel@wall-e>
References: <4B2B5622.80604@infradead.org>
	 <1261137648.3080.36.camel@palomino.walls.org>
	 <1261138265.8293.2.camel@wall-e>
Content-Type: text/plain
Date: Fri, 18 Dec 2009 16:39:19 -0500
Message-Id: <1261172359.3060.11.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2009-12-18 at 13:11 +0100, Stefani Seibold wrote:
> Am Freitag, den 18.12.2009, 07:00 -0500 schrieb Andy Walls:
> > On Fri, 2009-12-18 at 08:14 -0200, Mauro Carvalho Chehab wrote:

> > 
> > Stefani and Mauro,
> > 
> > My comments/concerns are in line:
> > 
> > > -------- Mensagem original --------
> > > Assunto: [patch] media video cx23888 driver: ported to new kfifo API
> > > Data: Fri, 18 Dec 2009 09:12:34 +0100
> > > De: Stefani Seibold <stefani@seibold.net>
> > > Para: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,  Mauro Carvalho Chehab <mchehab@infradead.org>
> > > 
> > > This patch will fix the cx23888 driver to use the new kfifo API.
> > > 
> > > The patch-set is against current mm tree from 11-Dec-2009
> > > 
> > > Greetings,
> > > Stefani
> > > 
> > > Signed-off-by: Stefani Seibold <stefani@seibold.net>
> > > ---
> > >  cx23888-ir.c |   35 ++++++++++-------------------------
> > >  1 file changed, 10 insertions(+), 25 deletions(-)
> > > 
> > > --- mmotm.orig/drivers/media/video/cx23885/cx23888-ir.c	2009-12-18 08:42:53.936778002 +0100
> > > +++ mmotm/drivers/media/video/cx23885/cx23888-ir.c	2009-12-18 09:03:04.808703259 +0100

> > > @@ -631,7 +629,7 @@ static int cx23888_ir_irq_handler(struct
> > >  		cx23888_ir_write4(dev, CX23888_IR_CNTRL_REG, cntrl);
> > >  		*handled = true;
> > >  	}
> > > -	if (kfifo_len(state->rx_kfifo) >= CX23888_IR_RX_KFIFO_SIZE / 2)
> > > +	if (kfifo_len(&state->rx_kfifo) >= CX23888_IR_RX_KFIFO_SIZE / 2)
> > >  		events |= V4L2_SUBDEV_IR_RX_FIFO_SERVICE_REQ;
> > >  
> > >  	if (events)
> > 
> > I am concerned about reading the kfifo_len() without taking the lock,
> > since another thread on another CPU may be reading from the kfifo at the
> > same time.
> > 
> > If the new kfifo implementation has an atomic_read() or something behind
> > the kfifo_len() call, then OK.
> > 
> > 
> > > @@ -657,7 +655,7 @@ static int cx23888_ir_rx_read(struct v4l
> > >  		return 0;
> > >  	}
> > >  
> > > -	n = kfifo_get(state->rx_kfifo, buf, n);
> > > +	n = kfifo_out_locked(&state->rx_kfifo, buf, n, &state->rx_kfifo_lock);
> > >  
> > >  	n /= sizeof(u32);
> > >  	*num = n * sizeof(u32);
> > > @@ -785,7 +783,7 @@ static int cx23888_ir_rx_s_parameters(st
> > >  	o->interrupt_enable = p->interrupt_enable;
> > >  	o->enable = p->enable;
> > >  	if (p->enable) {
> > > -		kfifo_reset(state->rx_kfifo);
> > > +		kfifo_reset(&state->rx_kfifo);
> > >  		if (p->interrupt_enable)
> > >  			irqenable_rx(dev, IRQEN_RSE | IRQEN_RTE | IRQEN_ROE);
> > >  		control_rx_enable(dev, p->enable);
> > 
> > Same concern about kfifo_reset() not taking the lock, and another thread
> > reading data from the kfifo at the same time.  In the cx23885 module,
> > this would mostly likely happen only during module unload as things are
> > being shut down.
> > 

> Sorry, i ported it only to the new API. I did not touch the
> functionality.

Stefani,

Huh?  The new kfifo implementation you wrote removed the locks from
kfifo_len() and kfifo_reset().  By changing those two functions to not
provide locking, you changed the functionality.


>  Feel free to fix it and post it.

Please point me to the mmotm tree and I will try to get to this
tonight. 

I have a blizzard coming tonight threatening to leave 16 to 20 inches of
snow and I will likely lose power.  I have to purchase gas for my
generator and go split some wood for the fire.  I might not get the
change done before I lose power.

If you can't wait for me to provide a patch, just add spin locks and
unlocks around the calls to kfifo_len() and kfifo_reset() in addition to
the changes in your current patch.


Regards,
Andy

> Stefani


