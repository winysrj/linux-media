Return-path: <linux-media-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:44675 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217Ab2GBB7g (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Jul 2012 21:59:36 -0400
Date: Mon, 2 Jul 2012 11:59:37 +1000
From: Anton Blanchard <anton@samba.org>
To: mchehab@infradead.org, david@hardeman.nu
Cc: linux-media@vger.kernel.org
Subject: [PATCH 3/3] [media] winbond-cir: Adjust sample frequency to improve
 reliability
Message-ID: <20120702115937.623d3b41@kryten>
In-Reply-To: <20120702115800.1275f944@kryten>
References: <20120702115800.1275f944@kryten>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


When using my Logitech Harmony remote I get regular dropped events
(about 1 in every 3). Adjusting the sample frequency to 6us so we
sample at a multiple of an RC-6 pulse (444us) fixes it.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux/drivers/media/rc/winbond-cir.c
===================================================================
--- linux.orig/drivers/media/rc/winbond-cir.c	2012-07-01 14:54:28.993475033 +1000
+++ linux/drivers/media/rc/winbond-cir.c	2012-07-01 14:55:50.500939910 +1000
@@ -358,7 +358,7 @@ wbcir_irq_rx(struct wbcir_data *data, st
 		if (data->rxstate == WBCIR_RXSTATE_ERROR)
 			continue;
 		rawir.pulse = irdata & 0x80 ? false : true;
-		rawir.duration = US_TO_NS((irdata & 0x7F) * 10);
+		rawir.duration = US_TO_NS((irdata & 0x7F) * 6);
 		ir_raw_event_store_with_filter(data->dev, &rawir);
 	}
 
@@ -874,8 +874,8 @@ wbcir_init_hw(struct wbcir_data *data)
 	/* prescaler 1.0, tx/rx fifo lvl 16 */
 	outb(0x30, data->sbase + WBCIR_REG_SP3_EXCR2);
 
-	/* Set baud divisor to sample every 10 us */
-	outb(0x0F, data->sbase + WBCIR_REG_SP3_BGDL);
+	/* Set baud divisor to sample every 6 us */
+	outb(0x09, data->sbase + WBCIR_REG_SP3_BGDL);
 	outb(0x00, data->sbase + WBCIR_REG_SP3_BGDH);
 
 	/* Set CEIR mode */
