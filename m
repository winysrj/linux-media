Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:47126 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759935AbcJaGNv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 31 Oct 2016 02:13:51 -0400
Received: from epcpsbgm1new.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OFW00FOCEN0CY80@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 31 Oct 2016 15:13:49 +0900 (KST)
Date: Mon, 31 Oct 2016 15:13:45 +0900
From: Andi Shyti <andi.shyti@samsung.com>
To: Sean Young <sean@mess.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        linux-media@vger.kernel.org,
        David =?iso-8859-15?Q?H=E4rdeman?= <david@hardeman.nu>,
        Andi Shyti <andi@etezian.org>
Subject: Re: [PATCH] [media] lirc: introduce LIRC_SET_TRANSMITTER_WAIT ioctl
Message-id: <20161031061343.nxomwtrtwivgh7gz@gangnam.samsung>
References: <CGME20161027143559epcas4p393edfca7329f184cda2f1954d46216ed@epcas4p3.samsung.com>
 <1477578953-5309-1-git-send-email-sean@mess.org>
 <20161028073839.5xtl3e7ifip2dqsb@gangnam.samsung>
 <20161028090552.GA11697@gofer.mess.org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
In-reply-to: <20161028090552.GA11697@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sean.

> > >  	ret *= sizeof(unsigned int);
> > >  
> > > -	/*
> > > -	 * The lircd gap calculation expects the write function to
> > > -	 * wait for the actual IR signal to be transmitted before
> > > -	 * returning.
> > > -	 */
> > > -	towait = ktime_us_delta(ktime_add_us(start, duration), ktime_get());
> > > -	if (towait > 0) {
> > > -		set_current_state(TASK_INTERRUPTIBLE);
> > > -		schedule_timeout(usecs_to_jiffies(towait));
> > > +	if (!lirc->tx_no_wait) {
> > > +		/*
> > > +		 * The lircd gap calculation expects the write function to
> > > +		 * wait for the actual IR signal to be transmitted before
> > > +		 * returning.
> > > +		 */
> > > +		towait = ktime_us_delta(ktime_add_us(start, duration),
> > > +								ktime_get());
> > > +		if (towait > 0) {
> > > +			set_current_state(TASK_INTERRUPTIBLE);
> > > +			schedule_timeout(usecs_to_jiffies(towait));
> > > +		}
> > >  	}
> > > -
> > 
> > this doesn't fix my problem, though.
> > 
> > This approach gives the userspace the possibility to choose to
> > either sync or not. In my case the sync happens, but in a
> > different level and it's not up to the userspace to make the
> > decision.
> 
> What problem are you trying to solve?
> 
> I wrote this patch as a response to this patch:
> 
> https://lkml.org/lkml/2016/9/1/653

Actually no big problem here but what I wrote below.

If the user sets LIRC_SET_TRANSMITTER_WAIT to 0 and the driver
waits anyway, this patch wouldn't be of any use and it would
do exactly what it whas doing before.

> In the spi case, the driver already waits for the IR to complete so the 
> wait in ir_lirc_transmit_ir() is unnecessary. However it does not end up
> waiting. There are other drivers like yours that wait for the IR to 
> complete (ene_ir, ite-cir). Since towait in ir_lirc_transmit_ir is the 
> delta between before and after the driver transmits, it will be 0 and 
> will never goto into schedule_timeout(), barring some very minor rounding 
> differences.
> 
> > Besides, I see here a security issue: what happens if userspace
> > does something like
> > 
> >  fd = open("/dev/lirc0", O_RDWR);
> > 
> >  ioctl(fd, LIRC_SET_TRANSMITTER_WAIT, 0);
> > 
> >  while(1)
> >         write(fd, buffer, ENORMOUS_BUFFER_SIZE);
> 
> I don't understand what problem this would introduce.
> 
> You can't write more than 512 pulse/spaces and each write cannot
> have more than 500ms in IR (so adding up the pulses and spaces). The driver
> should only send once the previous send completed.

OK.

> > > +	case LIRC_SET_TRANSMITTER_WAIT:
> > > +		if (!dev->tx_ir)
> > > +			return -ENOTTY;
> > > +
> > > +		lirc->tx_no_wait = !val;
> > > +		break;
> > > +
> > 
> > Here I see an innocuous bug. Depending on the hardware (for
> > example ir-spi) it might happen that the device waits in any
> > case (in ir-spi the sync is done by the spi). This means that if
> > userspace sets 'tx_no_wait = true', the device/driver doesn't
> > care and waits anyway, doing the opposite from what is described
> > in the ABI.
> > 
> > Here we could call a dev->tx_set_transmitter_wait(...) function
> > that sets the value or returns error in case the wait is not
> > feasable, something like:
> > 
> > 	case LIRC_SET_TRANSMITTER_WAIT:
> > 		if (!dev->tx_ir)
> > 			return -ENOTTY;
> > 
> > 		if (dev->tx_set_transmitter_wait)
> > 			return dev->tx_set_transmitter_wait(lirc, val);
> > 
> > 		lirc->tx_no_wait = !val;
> > 		break;
> 
> That is true. Do you want the ir-spi driver to be able to send without
> waiting?

I think there should be some meccanism to keep it coherent with
the ABI, mine was a suggestion.

> > > --- a/drivers/media/rc/rc-core-priv.h
> > > +++ b/drivers/media/rc/rc-core-priv.h
> > > @@ -112,7 +112,7 @@ struct ir_raw_event_ctrl {
> > >  		u64 gap_duration;
> > >  		bool gap;
> > >  		bool send_timeout_reports;
> > > -
> > > +		bool tx_no_wait;
> > >  	} lirc;
> > 
> > this to me looks confusing, it has a negative meaning in kernel
> > space and a positive meaning in userspace. Can't we call it
> > lirc->tx_wait instead of lirc->tx_no_wait, so that we keep the
> > same meaning and we don't need to negate val?
> 
> This was just done to avoid having to initialise to true (non-zero).

OK, this was just a nitpick anyway :)

Thanks,
Andi
