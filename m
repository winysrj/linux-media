Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:48369 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932838AbeCJL1s (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Mar 2018 06:27:48 -0500
Date: Sat, 10 Mar 2018 11:27:45 +0000
From: Sean Young <sean@mess.org>
To: Matthias Reichl <hias@horus.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Carlo Caione <carlo@caione.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Alex Deryskyba <alex@codesnake.com>,
        Jonas Karlman <jonas@kwiboo.se>, linux-media@vger.kernel.org,
        linux-amlogic@lists.infradead.org
Subject: Re: [PATCH] media: rc: meson-ir: add timeout on idle
Message-ID: <20180310112744.plfxkmqbgvii7n7r@gofer.mess.org>
References: <20180306174122.6017-1-hias@horus.com>
 <20180308164327.ihhmvm6ntzvnsjy7@gofer.mess.org>
 <20180309155451.gbocsaj4s3puc4cq@camel2.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180309155451.gbocsaj4s3puc4cq@camel2.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Matthias,

On Fri, Mar 09, 2018 at 04:54:51PM +0100, Matthias Reichl wrote:
> On Thu, Mar 08, 2018 at 04:43:27PM +0000, Sean Young wrote:
> > On Tue, Mar 06, 2018 at 06:41:22PM +0100, Matthias Reichl wrote:
> > > Meson doesn't seem to be able to generate timeout events
> > > in hardware. So install a software timer to generate the
> > > timeout events required by the decoders to prevent
> > > "ghost keypresses".
> > > 
> > > Signed-off-by: Matthias Reichl <hias@horus.com>
> > > ---
> > >  drivers/media/rc/meson-ir.c | 22 ++++++++++++++++++++++
> > >  1 file changed, 22 insertions(+)
> > > 
> > > diff --git a/drivers/media/rc/meson-ir.c b/drivers/media/rc/meson-ir.c
> > > index f2204eb77e2a..f34c5836412b 100644
> > > --- a/drivers/media/rc/meson-ir.c
> > > +++ b/drivers/media/rc/meson-ir.c
> > > @@ -69,6 +69,7 @@ struct meson_ir {
> > >  	void __iomem	*reg;
> > >  	struct rc_dev	*rc;
> > >  	spinlock_t	lock;
> > > +	struct timer_list timeout_timer;
> > >  };
> > >  
> > >  static void meson_ir_set_mask(struct meson_ir *ir, unsigned int reg,
> > > @@ -98,6 +99,10 @@ static irqreturn_t meson_ir_irq(int irqno, void *dev_id)
> > >  	rawir.pulse = !!(status & STATUS_IR_DEC_IN);
> > >  
> > >  	ir_raw_event_store(ir->rc, &rawir);
> > > +
> > > +	mod_timer(&ir->timeout_timer,
> > > +		jiffies + nsecs_to_jiffies(ir->rc->timeout));
> > > +
> > >  	ir_raw_event_handle(ir->rc);
> > >  
> > >  	spin_unlock(&ir->lock);
> > > @@ -105,6 +110,17 @@ static irqreturn_t meson_ir_irq(int irqno, void *dev_id)
> > >  	return IRQ_HANDLED;
> > >  }
> > >  
> > > +static void meson_ir_timeout_timer(struct timer_list *t)
> > > +{
> > > +	struct meson_ir *ir = from_timer(ir, t, timeout_timer);
> > > +	DEFINE_IR_RAW_EVENT(rawir);
> > > +
> > > +	rawir.timeout = true;
> > > +	rawir.duration = ir->rc->timeout;
> > > +	ir_raw_event_store(ir->rc, &rawir);
> > > +	ir_raw_event_handle(ir->rc);
> > > +}
> > 
> > Now there can be concurrent access to the raw IR kfifo from the interrupt
> > handler and the timer. As there is a race condition between the timeout
> > timer and new IR arriving from the interrupt handler, the timeout could
> > end being generated after new IR and corrupting a message. There is very
> > similar functionality in rc-ir-raw.c (with a spinlock).
> 
> Ah, thanks for the hint! Now I also noticed your commit a few
> weeks ago - must have missed that before.
> 
> > > +
> > >  static int meson_ir_probe(struct platform_device *pdev)
> > >  {
> > >  	struct device *dev = &pdev->dev;
> > > @@ -145,7 +161,9 @@ static int meson_ir_probe(struct platform_device *pdev)
> > >  	ir->rc->map_name = map_name ? map_name : RC_MAP_EMPTY;
> > >  	ir->rc->allowed_protocols = RC_PROTO_BIT_ALL_IR_DECODER;
> > >  	ir->rc->rx_resolution = US_TO_NS(MESON_TRATE);
> > > +	ir->rc->min_timeout = 1;
> > >  	ir->rc->timeout = MS_TO_NS(200);
> > > +	ir->rc->max_timeout = 10 * IR_DEFAULT_TIMEOUT;
> > 
> > Any idea why the default timeout is to 200ms? It seems very high.
> 
> Indeed it is very high, but I have no idea where that might be
> coming from - so I didn't touch it.
> 
> I've been testing rc-5 and NEC remotes with 20-50ms timeouts
> on meson-ir/upstream kernel and a couple of LibreELEC users are
> using 30-50ms timeouts without issues on Amlogic devices as well
> (on 3.14 vendor kernel with meson-ir timeout patch):
> 
> https://forum.libreelec.tv/thread/11643-le9-0-remote-configs-ir-keytable-amlogic-devices/?postID=83124#post83124
> 
> Out of curiosity: where does the 125ms IR_DEFAULT_TIMEOUT value
> come from? For raw IR signals processed by the decoders this seems
> rather high to me as well. On my RPi3 with gpio-ir-recv I'm
> using 30ms timeout (with an rc-5 remote) without issues.

So if the timeout is below N then you will never get a space of N or larger;
the largest space I know of in an IR message is 40ms in the sanyo protocol:

https://www.sbprojects.net/knowledge/ir/sharp.php

So if timeout is set to less than 40ms, we would have trouble decoding the
sharp protocol.

The space between nec repeats is a little less than 100ms. I'm trying to
remember what would could go wrong if the space between them would be
timeouts instead. Mauro do you remember? I can imagine some IR hardware
(e.g. winbond) queuing up IR after generating a timeout, thus delaying
delivering IR to the kernel and we ending up generating a key up.

The problem with a higher timeout is that the trailing space (=timeout)
is sometimes needed for decoding, and decoding of the last message is
delayed until the timeout is received. That means the keyup message is
delayed until that time, making keys a bit "sticky" and more likely to
generate repeats. I'm pretty sure that is needed for rc-5 and nec.

> > >  	ir->rc->driver_name = DRIVER_NAME;
> > >  
> > >  	spin_lock_init(&ir->lock);
> > > @@ -157,6 +175,8 @@ static int meson_ir_probe(struct platform_device *pdev)
> > >  		return ret;
> > >  	}
> > >  
> > > +	timer_setup(&ir->timeout_timer, meson_ir_timeout_timer, 0);
> > > +
> > >  	ret = devm_request_irq(dev, irq, meson_ir_irq, 0, NULL, ir);
> > >  	if (ret) {
> > >  		dev_err(dev, "failed to request irq\n");
> > > @@ -198,6 +218,8 @@ static int meson_ir_remove(struct platform_device *pdev)
> > >  	meson_ir_set_mask(ir, IR_DEC_REG1, REG1_ENABLE, 0);
> > >  	spin_unlock_irqrestore(&ir->lock, flags);
> > >  
> > > +	del_timer_sync(&ir->timeout_timer);
> > > +
> > >  	return 0;
> > >  }
> > >  
> > > -- 
> > > 2.11.0
> > 
> > Would you mind trying this patch?
> 
> Tested-by: Matthias Reichl <hias@horus.com>
> 
> Thanks a lot, this patch works fine! And having a common function
> in rc-core looks like a very good idea to me as well.
> 
> Only thing I'd like to have added is min/max timeout values set
> in meson-ir so it's configurable via ir-ctl. A separate patch for
> that would make sense, though, I guess.

Yes, that would be good. That should go into a separate commit.

Thanks for testing!

Sean
