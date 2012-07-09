Return-path: <linux-media-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:47184 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369Ab2GICCO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Jul 2012 22:02:14 -0400
Date: Mon, 9 Jul 2012 12:02:08 +1000
From: Anton Blanchard <anton@samba.org>
To: David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: <mchehab@infradead.org>, <linux-media@vger.kernel.org>
Subject: Re: [PATCH 3/3] [media] winbond-cir: Adjust sample frequency to
 improve reliability
Message-ID: <20120709120208.446f2bdf@kryten>
In-Reply-To: <9c21e63d50aba0e550a69a691dd12860@hardeman.nu>
References: <20120702115800.1275f944@kryten>
	<20120702115937.623d3b41@kryten>
	<20120703202825.GC29839@hardeman.nu>
	<20120705203035.196e238e@kryten>
	<9c21e63d50aba0e550a69a691dd12860@hardeman.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi David,

> Just to make sure something like that isn't happening, could you
> correct the line in wbcir_irq_rx() which currently reads:
> 
> rawir.duration = US_TO_NS((irdata & 0x7F) * 10);
> 
> so that it reads
> 
> rawir.duration = US_TO_NS(((irdata & 0x7F) + 1) * 10);

Sure, I have added the change. This is what my diff to mainline looks
like right now:

diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
index 342c2c8..6381c11 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -232,7 +232,7 @@ MODULE_PARM_DESC(invert, "Invert the signal from the IR receiver");
 
 static bool txandrx; /* default = 0 */
 module_param(txandrx, bool, 0444);
-MODULE_PARM_DESC(invert, "Allow simultaneous TX and RX");
+MODULE_PARM_DESC(txandrx, "Allow simultaneous TX and RX");
 
 static unsigned int wake_sc = 0x800F040C;
 module_param(wake_sc, uint, 0644);
@@ -358,7 +358,8 @@ wbcir_irq_rx(struct wbcir_data *data, struct pnp_dev *device)
 		if (data->rxstate == WBCIR_RXSTATE_ERROR)
 			continue;
 		rawir.pulse = irdata & 0x80 ? false : true;
-		rawir.duration = US_TO_NS((irdata & 0x7F) * 10);
+		rawir.duration = US_TO_NS(((irdata & 0x7F) + 1) * 10);
+		printk(KERN_DEBUG "%x %d %d\n", irdata, rawir.pulse, rawir.duration);
 		ir_raw_event_store_with_filter(data->dev, &rawir);
 	}
 
@@ -1026,6 +1027,7 @@ wbcir_probe(struct pnp_dev *device, const struct pnp_device_id *dev_id)
 	data->dev->input_id.product = WBCIR_ID_FAMILY;
 	data->dev->input_id.version = WBCIR_ID_CHIP;
 	data->dev->map_name = RC_MAP_RC6_MCE;
+	data->dev->timeout = MS_TO_NS(100);
 	data->dev->s_idle = wbcir_idle_rx;
 	data->dev->s_tx_mask = wbcir_txmask;
 	data->dev->s_tx_carrier = wbcir_txcarrier;

Here is the debug output:

http://ozlabs.org/~anton/winbond.log1.gz

> Another possibility is that the printk in the interrupt handler causes
> overhead...could you do a debug run without the printk in the
> interrupt handler?

Here is the output without the printk in the interrupt handler:

http://ozlabs.org/~anton/winbond.log2.gz

Anton
