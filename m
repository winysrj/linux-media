Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:44349 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752256AbeCHQna (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Mar 2018 11:43:30 -0500
Date: Thu, 8 Mar 2018 16:43:27 +0000
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
Message-ID: <20180308164327.ihhmvm6ntzvnsjy7@gofer.mess.org>
References: <20180306174122.6017-1-hias@horus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180306174122.6017-1-hias@horus.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Matthias,

On Tue, Mar 06, 2018 at 06:41:22PM +0100, Matthias Reichl wrote:
> Meson doesn't seem to be able to generate timeout events
> in hardware. So install a software timer to generate the
> timeout events required by the decoders to prevent
> "ghost keypresses".
> 
> Signed-off-by: Matthias Reichl <hias@horus.com>
> ---
>  drivers/media/rc/meson-ir.c | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/drivers/media/rc/meson-ir.c b/drivers/media/rc/meson-ir.c
> index f2204eb77e2a..f34c5836412b 100644
> --- a/drivers/media/rc/meson-ir.c
> +++ b/drivers/media/rc/meson-ir.c
> @@ -69,6 +69,7 @@ struct meson_ir {
>  	void __iomem	*reg;
>  	struct rc_dev	*rc;
>  	spinlock_t	lock;
> +	struct timer_list timeout_timer;
>  };
>  
>  static void meson_ir_set_mask(struct meson_ir *ir, unsigned int reg,
> @@ -98,6 +99,10 @@ static irqreturn_t meson_ir_irq(int irqno, void *dev_id)
>  	rawir.pulse = !!(status & STATUS_IR_DEC_IN);
>  
>  	ir_raw_event_store(ir->rc, &rawir);
> +
> +	mod_timer(&ir->timeout_timer,
> +		jiffies + nsecs_to_jiffies(ir->rc->timeout));
> +
>  	ir_raw_event_handle(ir->rc);
>  
>  	spin_unlock(&ir->lock);
> @@ -105,6 +110,17 @@ static irqreturn_t meson_ir_irq(int irqno, void *dev_id)
>  	return IRQ_HANDLED;
>  }
>  
> +static void meson_ir_timeout_timer(struct timer_list *t)
> +{
> +	struct meson_ir *ir = from_timer(ir, t, timeout_timer);
> +	DEFINE_IR_RAW_EVENT(rawir);
> +
> +	rawir.timeout = true;
> +	rawir.duration = ir->rc->timeout;
> +	ir_raw_event_store(ir->rc, &rawir);
> +	ir_raw_event_handle(ir->rc);
> +}

Now there can be concurrent access to the raw IR kfifo from the interrupt
handler and the timer. As there is a race condition between the timeout
timer and new IR arriving from the interrupt handler, the timeout could
end being generated after new IR and corrupting a message. There is very
similar functionality in rc-ir-raw.c (with a spinlock).

> +
>  static int meson_ir_probe(struct platform_device *pdev)
>  {
>  	struct device *dev = &pdev->dev;
> @@ -145,7 +161,9 @@ static int meson_ir_probe(struct platform_device *pdev)
>  	ir->rc->map_name = map_name ? map_name : RC_MAP_EMPTY;
>  	ir->rc->allowed_protocols = RC_PROTO_BIT_ALL_IR_DECODER;
>  	ir->rc->rx_resolution = US_TO_NS(MESON_TRATE);
> +	ir->rc->min_timeout = 1;
>  	ir->rc->timeout = MS_TO_NS(200);
> +	ir->rc->max_timeout = 10 * IR_DEFAULT_TIMEOUT;

Any idea why the default timeout is to 200ms? It seems very high.

>  	ir->rc->driver_name = DRIVER_NAME;
>  
>  	spin_lock_init(&ir->lock);
> @@ -157,6 +175,8 @@ static int meson_ir_probe(struct platform_device *pdev)
>  		return ret;
>  	}
>  
> +	timer_setup(&ir->timeout_timer, meson_ir_timeout_timer, 0);
> +
>  	ret = devm_request_irq(dev, irq, meson_ir_irq, 0, NULL, ir);
>  	if (ret) {
>  		dev_err(dev, "failed to request irq\n");
> @@ -198,6 +218,8 @@ static int meson_ir_remove(struct platform_device *pdev)
>  	meson_ir_set_mask(ir, IR_DEC_REG1, REG1_ENABLE, 0);
>  	spin_unlock_irqrestore(&ir->lock, flags);
>  
> +	del_timer_sync(&ir->timeout_timer);
> +
>  	return 0;
>  }
>  
> -- 
> 2.11.0

Would you mind trying this patch?

Thanks

Sean
---
>From f98f4fc05d743ac48a95694996985b2c1f0c4a4b Mon Sep 17 00:00:00 2001
From: Sean Young <sean@mess.org>
Date: Thu, 8 Mar 2018 14:42:44 +0000
Subject: [PATCH] media: rc: meson-ir: add timeout on idle

Meson doesn't seem to be able to generate timeout events in hardware. So
install a software timer to generate the timeout events required by the
decoders to prevent "ghost keypresses".

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/meson-ir.c  |  3 +--
 drivers/media/rc/rc-ir-raw.c | 30 +++++++++++++++++++++++++++---
 include/media/rc-core.h      |  4 +++-
 3 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/drivers/media/rc/meson-ir.c b/drivers/media/rc/meson-ir.c
index f2204eb77e2a..64b0aa4f4db7 100644
--- a/drivers/media/rc/meson-ir.c
+++ b/drivers/media/rc/meson-ir.c
@@ -97,8 +97,7 @@ static irqreturn_t meson_ir_irq(int irqno, void *dev_id)
 	status = readl_relaxed(ir->reg + IR_DEC_STATUS);
 	rawir.pulse = !!(status & STATUS_IR_DEC_IN);
 
-	ir_raw_event_store(ir->rc, &rawir);
-	ir_raw_event_handle(ir->rc);
+	ir_raw_event_store_with_timeout(ir->rc, &rawir);
 
 	spin_unlock(&ir->lock);
 
diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index 984bb82851f9..374f83105a23 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -92,7 +92,6 @@ int ir_raw_event_store_edge(struct rc_dev *dev, bool pulse)
 {
 	ktime_t			now;
 	DEFINE_IR_RAW_EVENT(ev);
-	int			rc = 0;
 
 	if (!dev->raw)
 		return -EINVAL;
@@ -101,8 +100,33 @@ int ir_raw_event_store_edge(struct rc_dev *dev, bool pulse)
 	ev.duration = ktime_to_ns(ktime_sub(now, dev->raw->last_event));
 	ev.pulse = !pulse;
 
+	return ir_raw_event_store_with_timeout(dev, &ev);
+}
+EXPORT_SYMBOL_GPL(ir_raw_event_store_edge);
+
+/*
+ * ir_raw_event_store_with_timeout() - pass a pulse/space duration to the raw
+ *				       ir decoders, schedule decoding and
+ *				       timeout
+ * @dev:	the struct rc_dev device descriptor
+ * @ev:		the struct ir_raw_event descriptor of the pulse/space
+ *
+ * This routine (which may be called from an interrupt context) stores a
+ * pulse/space duration for the raw ir decoding state machines, schedules
+ * decoding and generates a timeout.
+ */
+int ir_raw_event_store_with_timeout(struct rc_dev *dev, struct ir_raw_event *ev)
+{
+	ktime_t		now;
+	int		rc = 0;
+
+	if (!dev->raw)
+		return -EINVAL;
+
+	now = ktime_get();
+
 	spin_lock(&dev->raw->edge_spinlock);
-	rc = ir_raw_event_store(dev, &ev);
+	rc = ir_raw_event_store(dev, ev);
 
 	dev->raw->last_event = now;
 
@@ -117,7 +141,7 @@ int ir_raw_event_store_edge(struct rc_dev *dev, bool pulse)
 
 	return rc;
 }
-EXPORT_SYMBOL_GPL(ir_raw_event_store_edge);
+EXPORT_SYMBOL_GPL(ir_raw_event_store_with_timeout);
 
 /**
  * ir_raw_event_store_with_filter() - pass next pulse/space to decoders with some processing
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index fc3a92668bab..6742fd86ff65 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -334,7 +334,9 @@ void ir_raw_event_handle(struct rc_dev *dev);
 int ir_raw_event_store(struct rc_dev *dev, struct ir_raw_event *ev);
 int ir_raw_event_store_edge(struct rc_dev *dev, bool pulse);
 int ir_raw_event_store_with_filter(struct rc_dev *dev,
-				struct ir_raw_event *ev);
+				   struct ir_raw_event *ev);
+int ir_raw_event_store_with_timeout(struct rc_dev *dev,
+				    struct ir_raw_event *ev);
 void ir_raw_event_set_idle(struct rc_dev *dev, bool idle);
 int ir_raw_encode_scancode(enum rc_proto protocol, u32 scancode,
 			   struct ir_raw_event *events, unsigned int max);
-- 
2.14.3
