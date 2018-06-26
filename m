Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:47787 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751945AbeFZQdT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Jun 2018 12:33:19 -0400
Date: Tue, 26 Jun 2018 17:33:16 +0100
From: Sean Young <sean@mess.org>
To: Jerome Brunet <jbrunet@baylibre.com>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>
Subject: Re: [1/3] media: rc: drivers should produce alternate pulse and
 space timing events
Message-ID: <20180626163316.pl4hxncyfz4t2j2s@gofer.mess.org>
References: <20180512105531.30482-1-sean@mess.org>
 <1529410092.28510.20.camel@baylibre.com>
 <20180619125755.cd3tyfgsx5yqjohw@gofer.mess.org>
 <1529417360.28510.23.camel@baylibre.com>
 <20180626143710.v5v4sqbxlknlhxx7@gofer.mess.org>
 <1530023991.2900.52.camel@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1530023991.2900.52.camel@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 26, 2018 at 04:39:51PM +0200, Jerome Brunet wrote:
> On Tue, 2018-06-26 at 15:37 +0100, Sean Young wrote:
> > On Tue, Jun 19, 2018 at 04:09:20PM +0200, Jerome Brunet wrote:
> > > On Tue, 2018-06-19 at 13:57 +0100, Sean Young wrote:
> > > > On Tue, Jun 19, 2018 at 02:08:12PM +0200, Jerome Brunet wrote:
> > > > > On Sat, 2018-05-12 at 11:55 +0100, Sean Young wrote:
> > > > > > Report an error if this is not the case or any problem with the generated
> > > > > > raw events.
> > > > > 
> > > > > Hi,
> > > > > 
> > > > > Since the inclusion of this patch, every 3 to 15 seconds, I get the following
> > > > > message: 
> > > > > 
> > > > >  "rc rc0: two consecutive events of type space"
> > > > > 
> > > > > on the console of amlogic s400 platform (arch/arm64/boot/dts/amlogic/meson-axg-
> > > > > s400.dts). I don't know much about ir protocol and surely there is something
> > > > > worth investigating in the related driver, but ...
> > > > > 
> > > > > > 
> > > > > > Signed-off-by: Sean Young <sean@mess.org>
> > > > > > ---
> > > > > >  drivers/media/rc/rc-ir-raw.c | 19 +++++++++++++++----
> > > > > >  1 file changed, 15 insertions(+), 4 deletions(-)
> > > > > > 
> > > > > > diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
> > > > > > index 2e50104ae138..49c56da9bc67 100644
> > > > > > --- a/drivers/media/rc/rc-ir-raw.c
> > > > > > +++ b/drivers/media/rc/rc-ir-raw.c
> > > > > > @@ -22,16 +22,27 @@ static int ir_raw_event_thread(void *data)
> > > > > >  {
> > > > > >  	struct ir_raw_event ev;
> > > > > >  	struct ir_raw_handler *handler;
> > > > > > -	struct ir_raw_event_ctrl *raw = (struct ir_raw_event_ctrl *)data;
> > > > > > +	struct ir_raw_event_ctrl *raw = data;
> > > > > > +	struct rc_dev *dev = raw->dev;
> > > > > >  
> > > > > >  	while (1) {
> > > > > >  		mutex_lock(&ir_raw_handler_lock);
> > > > > >  		while (kfifo_out(&raw->kfifo, &ev, 1)) {
> > > > > > +			if (is_timing_event(ev)) {
> > > > > > +				if (ev.duration == 0)
> > > > > > +					dev_err(&dev->dev, "nonsensical timing event of duration 0");
> > > > > > +				if (is_timing_event(raw->prev_ev) &&
> > > > > > +				    !is_transition(&ev, &raw->prev_ev))
> > > > > > +					dev_err(&dev->dev, "two consecutive events of type %s",
> > > > > > +						TO_STR(ev.pulse));
> > > > > > +				if (raw->prev_ev.reset && ev.pulse == 0)
> > > > > > +					dev_err(&dev->dev, "timing event after reset should be pulse");
> > > > > > +			}
> > > > > 
> > > > > ... considering that we continue the processing as if nothing happened, is it
> > > > > really an error ? 
> > > > > 
> > > > > Could we consider something less invasive ? like dev_dbg() or dev_warn_once() ?
> > > > 
> > > > Maybe it should be dev_warn(). The fact that it is not dev_warn_once() means
> > > > that we now know this occurs regularly.
> > > 
> > > It seems weird to report this over and over again.
> > > 
> > > > 
> > > > Would you mind testing the following patch please?
> > > > 
> > > > Thanks
> > > > 
> > > > Sean
> > > > 
> > > > From 6a44fbe4738d230b9cf378777e7e9a93e5fda726 Mon Sep 17 00:00:00 2001
> > > > From: Sean Young <sean@mess.org>
> > > > Date: Tue, 19 Jun 2018 13:50:36 +0100
> > > > Subject: [PATCH] media: rc: meson: rc rc0: two consecutive events of type
> > > >  space
> > > > 
> > > > The meson generates one edge per interrupt. The duration is encoded in 12
> > > > bits of 10 microseconds, so it can only encoding a maximum of 40
> > > > milliseconds. As a result, it can produce multiple space events.
> > > > 
> > > > Signed-off-by: Sean Young <sean@mess.org>
> > > > ---
> > > >  drivers/media/rc/meson-ir.c | 3 ++-
> > > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/drivers/media/rc/meson-ir.c b/drivers/media/rc/meson-ir.c
> > > > index f449b35d25e7..9747426719b2 100644
> > > > --- a/drivers/media/rc/meson-ir.c
> > > > +++ b/drivers/media/rc/meson-ir.c
> > > > @@ -97,7 +97,8 @@ static irqreturn_t meson_ir_irq(int irqno, void *dev_id)
> > > >  	status = readl_relaxed(ir->reg + IR_DEC_STATUS);
> > > >  	rawir.pulse = !!(status & STATUS_IR_DEC_IN);
> > > >  
> > > > -	ir_raw_event_store_with_timeout(ir->rc, &rawir);
> > > > +	if (ir_raw_event_store_with_filter(ir->rc, &rawir))
> > > > +		ir_raw_event_handle(ir->rc);
> > > >  
> > > >  	spin_unlock(&ir->lock);
> > > >  
> > > 
> > > Solve the problem on meson. Thx
> > > Feel free to add this submitting the patch
> > 
> > Actually this patch is broken. ir_raw_event_store_with_timeout() generates
> > IR timeouts, but ir_raw_event_store_with_filter() does not.
> > 
> > So this will need some rethinking. I think we need a 
> > ir_raw_event_store_with_timeout_with_filter() but that is getting silly now.
> > 
> > Maybe filter should be a boolean property of an rc device and happen
> > transparently. I'll write something like that when I get some time.
> > 
> 
> would you still object to use dev_warn_once() in the meantime ?
> Console flooding is quite annoying.

Yes, as much as I dislike it, I think that is the right solution for now.

Thanks,

Sean

>From 2f61a8b6e850e34def282f1cbd1bfee0f5ab66c5 Mon Sep 17 00:00:00 2001
From: Sean Young <sean@mess.org>
Date: Tue, 26 Jun 2018 16:03:18 +0100
Subject: [PATCH] media: rc: be less noisy when driver misbehaves

Since commit 48231f289e52 ("media: rc: drivers should produce alternate
pulse and space timing events"), on meson-ir we are regularly producing
errors. Reduce to warning level and only warn once to avoid flooding
the log.

A proper fix for meson-ir is going to be too large for v4.18.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/rc-ir-raw.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index 2e0066b1a31c..e7948908e78c 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -30,13 +30,13 @@ static int ir_raw_event_thread(void *data)
 		while (kfifo_out(&raw->kfifo, &ev, 1)) {
 			if (is_timing_event(ev)) {
 				if (ev.duration == 0)
-					dev_err(&dev->dev, "nonsensical timing event of duration 0");
+					dev_warn_once(&dev->dev, "nonsensical timing event of duration 0");
 				if (is_timing_event(raw->prev_ev) &&
 				    !is_transition(&ev, &raw->prev_ev))
-					dev_err(&dev->dev, "two consecutive events of type %s",
-						TO_STR(ev.pulse));
+					dev_warn_once(&dev->dev, "two consecutive events of type %s",
+						      TO_STR(ev.pulse));
 				if (raw->prev_ev.reset && ev.pulse == 0)
-					dev_err(&dev->dev, "timing event after reset should be pulse");
+					dev_warn_once(&dev->dev, "timing event after reset should be pulse");
 			}
 			list_for_each_entry(handler, &ir_raw_handler_list, list)
 				if (dev->enabled_protocols &
-- 
2.17.1
