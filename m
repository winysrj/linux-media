Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53070 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933958Ab0HLQTm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Aug 2010 12:19:42 -0400
Date: Thu, 12 Aug 2010 18:19:27 +0200
From: Dan Carpenter <error27@gmail.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] IR: ene_ir: problems in unwinding on probe
Message-ID: <20100812161927.GQ645@bicker>
References: <20100812074611.GI645@bicker> <1281623704.10393.2.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281623704.10393.2.camel@maxim-laptop>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Thu, Aug 12, 2010 at 05:35:04PM +0300, Maxim Levitsky wrote:
> On Thu, 2010-08-12 at 09:46 +0200, Dan Carpenter wrote: 
> > There were a couple issues here.  If the allocation failed for "dev"
> > then it would lead to a NULL dereference.  If request_irq() or
> > request_region() failed it would release the irq and the region even
> > though they were not successfully aquired.
> > 
> > Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> I don't think this is needed.
> I just alloc all the stuff, and if one of allocations fail, I free them
> all. {k}free on NULL pointer is perfectly legal.
> 
> Same about IO and IRQ.
> IRQ0 and IO 0 isn't valid, and I do test that in error path.
> 
>

Here is the original code:

Here is where we set "dev".

   785          dev = kzalloc(sizeof(struct ene_device), GFP_KERNEL);
   786  
   787          if (!input_dev || !ir_props || !dev)
   788                  goto error;

	[snip]

Here is where we set the IO and IRQ:

   800          dev->hw_io = pnp_port_start(pnp_dev, 0);
   801          dev->irq = pnp_irq(pnp_dev, 0);

	[snip]

Here is where the request_region() and request_irq() are.

   806          if (!request_region(dev->hw_io, ENE_MAX_IO, ENE_DRIVER_NAME))
   807                  goto error;
   808  
   809          if (request_irq(dev->irq, ene_isr, 
   810                          IRQF_SHARED, ENE_DRIVER_NAME, (void *)dev))
   811                  goto error;

	[snip]

Here is the error label:

   897  error:
   898          if (dev->irq)
		    ^^^^^^^^

	Oops!  The allocation of dev failed and this is a NULL
	dereference.

   899                  free_irq(dev->irq, dev);

	Oops!  Request region failed and dev->irq is non-zero but
	request_irq() hasn't been called.

   900          if (dev->hw_io)
   901                  release_region(dev->hw_io, ENE_MAX_IO);

	Oops! dev->hw_io is non-zero but request_region() failed and so
	we just released someone else's region.


Hehe.  :P

regards,
dan carpenter

