Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:59039 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935657AbcJ0OgE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Oct 2016 10:36:04 -0400
Date: Thu, 27 Oct 2016 15:36:01 +0100
From: Sean Young <sean@mess.org>
To: Andi Shyti <andi.shyti@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andi Shyti <andi@etezian.org>,
        David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Subject: Re: [PATCH v2 5/7] [media] ir-lirc-codec: don't wait any
 transmitting time for tx only devices
Message-ID: <20161027143601.GA5103@gofer.mess.org>
References: <20160901171629.15422-1-andi.shyti@samsung.com>
 <20160901171629.15422-6-andi.shyti@samsung.com>
 <CGME20160902084206epcas1p26e535506ec1c418ede9ba230d40f0656@epcas1p2.samsung.com>
 <20160902084158.GA25342@gofer.mess.org>
 <20161027074401.wxg5icc6hcpwnfsf@gangnam.samsung>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161027074401.wxg5icc6hcpwnfsf@gangnam.samsung>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 27, 2016 at 04:44:01PM +0900, Andi Shyti wrote:
> Hi Sean,
> 
> it's been a while :)
> 
> I was going through your review fixing what needs to be fixed,
> but...
> 
> > > @@ -153,7 +153,7 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
> > >  	}
> > >  
> > >  	ret = dev->tx_ir(dev, txbuf, count);
> > > -	if (ret < 0)
> > > +	if (ret < 0 || dev->driver_type == RC_DRIVER_IR_RAW_TX)
> > 
> > Just because a driver only does transmit doesn't mean its transmit ABI
> > should change.
> > 
> > Now this bit of code is pretty horrible. It ensures that the call to write()
> > takes at least as long as the length of the transmit IR by sleeping. That's
> > not much of a guarantee that the IR has been sent.
> > 
> > Note that in the case of ir-spi, since your spi transfer is sync no sleep
> > should be introduced here.
> > 
> > The gap calculation in lirc checks that if the call to write() took _longer_
> > than expected wait before sending the next IR code (when either multiple
> > IR codes or repeats are specified). Introducing the sleep in the kernel
> > here does not help at all, lirc already ensures that it waits as long as
> > the IR is long (see schedule_repeat_timer in lirc).
> > 
> > This change was introduced in 3.10, commit f8e00d5. 
> 
> ... I'm not sure what can be done here. I get your point and I
> understand that this indeed is a kind of fake sync point and by
> doing this I 

My original plan was to send a patch which just removes the silly wait,
but on further investigating debian stable and testing still carry a
lirc version that depend on it, so that's not going to fly.

> How about creating two different functions:
> 
> - ir_lirc_transmit_ir where we actually do what the function
>   already does
> - ir_lirc_transmit_no_sync where the function we don't wait
>   because the the sync is done on a different level (for example
>   in the SPI case).
> 
> SPI does approximately the same thing.

Since we have to be able to switch between waiting and not waiting, 
we need some sort of ABI for this. I think this warrants a new ioctl;
I'm not sure how else it can be done. I'll be sending out a patch
shortly.


Sean
