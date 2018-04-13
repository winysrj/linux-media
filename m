Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:54851 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752446AbeDMJGw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Apr 2018 05:06:52 -0400
Date: Fri, 13 Apr 2018 06:06:46 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sean Young <sean@mess.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Patrice Chotard <patrice.chotard@st.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 15/17] media: st_rc: Don't stay on an IRQ handler
 forever
Message-ID: <20180413060646.25b8a19d@vento.lan>
In-Reply-To: <20180412222132.z7g5enhin2uodbk7@gofer.mess.org>
References: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
        <16b1993cde965edc096f0833091002dd05d4da7f.1523546545.git.mchehab@s-opensource.com>
        <20180412222132.z7g5enhin2uodbk7@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sean,

Em Thu, 12 Apr 2018 23:21:32 +0100
Sean Young <sean@mess.org> escreveu:

> On Thu, Apr 12, 2018 at 11:24:07AM -0400, Mauro Carvalho Chehab wrote:
> > As warned by smatch:
> > 	drivers/media/rc/st_rc.c:110 st_rc_rx_interrupt() warn: this loop depends on readl() succeeding
> > 
> > If something goes wrong at readl(), the logic will stay there
> > inside an IRQ code forever. This is not the nicest thing to
> > do :-)
> > 
> > So, add a timeout there, preventing staying inside the IRQ
> > for more than 10ms.  
> 
> If we knew how large the fifo was, then we could limit the loop to that many
> iterations (maybe a few extra in case IR arrives while we a reading, but
> IR is much slower than a cpu executing this loop of course).

IR is slower, but this code is called at IRQ time, e. g. when the
controller already received the IR data. Also, it reads directly
via a memory mapped register, with should be fast. I suspect that
10ms is a lot more time than what would be required to go though
all the FIFO data.

> 
> Patrice is something you could help with?
> 
> Thanks
> 
> Sean
> 
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > ---
> >  drivers/media/rc/st_rc.c | 16 ++++++++++------
> >  1 file changed, 10 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/media/rc/st_rc.c b/drivers/media/rc/st_rc.c
> > index d2efd7b2c3bc..c855b177103c 100644
> > --- a/drivers/media/rc/st_rc.c
> > +++ b/drivers/media/rc/st_rc.c
> > @@ -96,19 +96,24 @@ static void st_rc_send_lirc_timeout(struct rc_dev *rdev)
> >  
> >  static irqreturn_t st_rc_rx_interrupt(int irq, void *data)
> >  {
> > +	unsigned long timeout;
> >  	unsigned int symbol, mark = 0;
> >  	struct st_rc_device *dev = data;
> >  	int last_symbol = 0;
> > -	u32 status;
> > +	u32 status, int_status;
> >  	DEFINE_IR_RAW_EVENT(ev);
> >  
> >  	if (dev->irq_wake)
> >  		pm_wakeup_event(dev->dev, 0);
> >  
> > -	status  = readl(dev->rx_base + IRB_RX_STATUS);
> > +	/* FIXME: is 10ms good enough ? */
> > +	timeout = jiffies +  msecs_to_jiffies(10);
> > +	do {
> > +		status  = readl(dev->rx_base + IRB_RX_STATUS);
> > +		if (!(status & (IRB_FIFO_NOT_EMPTY | IRB_OVERFLOW)))
> > +			break;
> >  
> > -	while (status & (IRB_FIFO_NOT_EMPTY | IRB_OVERFLOW)) {
> > -		u32 int_status = readl(dev->rx_base + IRB_RX_INT_STATUS);
> > +		int_status = readl(dev->rx_base + IRB_RX_INT_STATUS);
> >  		if (unlikely(int_status & IRB_RX_OVERRUN_INT)) {
> >  			/* discard the entire collection in case of errors!  */
> >  			ir_raw_event_reset(dev->rdev);
> > @@ -148,8 +153,7 @@ static irqreturn_t st_rc_rx_interrupt(int irq, void *data)
> >  
> >  		}
> >  		last_symbol = 0;
> > -		status  = readl(dev->rx_base + IRB_RX_STATUS);
> > -	}
> > +	} while (time_is_after_jiffies(timeout));
> >  
> >  	writel(IRB_RX_INTS, dev->rx_base + IRB_RX_INT_CLEAR);
> >  
> > -- 
> > 2.14.3  



Thanks,
Mauro
