Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56611 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbZLSKQE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Dec 2009 05:16:04 -0500
Message-ID: <4B2CA7B6.1000405@infradead.org>
Date: Sat, 19 Dec 2009 08:15:18 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
CC: Stefani Seibold <stefani@seibold.net>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [patch] media video cx23888 driver: fix possible races using
 new kfifo_API kfifo_reset()
References: <1261174870.13019.24.camel@wall-e> <1261179828.3060.15.camel@palomino.walls.org>
In-Reply-To: <1261179828.3060.15.camel@palomino.walls.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 18-12-2009 21:43, Andy Walls escreveu:
> On Fri, 2009-12-18 at 23:21 +0100, Stefani Seibold wrote:
>> Fix the cx23888 driver to use the new kfifo API. Using kfifo_reset() may
>> result in a possible race conditions. This patch fix it by using
>> spinlock around the kfifo_reset() function.
>>
>> The patch-set is against mm tree from 11-Dec-2009
>>
>> Greetings,
>> Stefani
>>
>> Signed-off-by: Stefani Seibold <stefani@seibold.net>
> 
> For both this patch together with your previous patch:
> 
> Reviewed-by: Andy Walls <awalls@radix.net>
> Acked-by: Andy Walls <awalls@radix.net>
Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> Thanks Stefani.
> 
> Regards,
> Andy
> 
>> ---
>>  cx23888-ir.c |    9 +++++++++
>>  1 file changed, 9 insertions(+)
>>
>> --- mmotm.orig/drivers/media/video/cx23885/cx23888-ir.c	2009-12-18 22:57:13.588337402 +0100
>> +++ mmotm/drivers/media/video/cx23885/cx23888-ir.c	2009-12-18 23:15:14.651365720 +0100
>> @@ -519,6 +519,7 @@ static int cx23888_ir_irq_handler(struct
>>  {
>>  	struct cx23888_ir_state *state = to_state(sd);
>>  	struct cx23885_dev *dev = state->dev;
>> +	unsigned long flags;
>>  
>>  	u32 cntrl = cx23888_ir_read4(dev, CX23888_IR_CNTRL_REG);
>>  	u32 irqen = cx23888_ir_read4(dev, CX23888_IR_IRQEN_REG);
>> @@ -629,8 +630,11 @@ static int cx23888_ir_irq_handler(struct
>>  		cx23888_ir_write4(dev, CX23888_IR_CNTRL_REG, cntrl);
>>  		*handled = true;
>>  	}
>> +
>> +	spin_lock_irqsave(&state->rx_kfifo_lock, flags);
>>  	if (kfifo_len(&state->rx_kfifo) >= CX23888_IR_RX_KFIFO_SIZE / 2)
>>  		events |= V4L2_SUBDEV_IR_RX_FIFO_SERVICE_REQ;
>> +	spin_unlock_irqrestore(&state->rx_kfifo_lock, flags);
>>  
>>  	if (events)
>>  		v4l2_subdev_notify(sd, V4L2_SUBDEV_IR_RX_NOTIFY, &events);
>> @@ -783,7 +787,12 @@ static int cx23888_ir_rx_s_parameters(st
>>  	o->interrupt_enable = p->interrupt_enable;
>>  	o->enable = p->enable;
>>  	if (p->enable) {
>> +		unsigned long flags;
>> +
>> +		spin_lock_irqsave(&state->rx_kfifo_lock, flags);
>>  		kfifo_reset(&state->rx_kfifo);
>> +		/* reset tx_fifo too if there is one... */
>> +		spin_unlock_irqrestore(&state->rx_kfifo_lock, flags);
>>  		if (p->interrupt_enable)
>>  			irqenable_rx(dev, IRQEN_RSE | IRQEN_RTE | IRQEN_ROE);
>>  		control_rx_enable(dev, p->enable);
>>
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

