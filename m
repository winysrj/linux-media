Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:38566 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab2GCU21 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Jul 2012 16:28:27 -0400
Date: Tue, 3 Jul 2012 22:28:25 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Anton Blanchard <anton@samba.org>
Cc: mchehab@infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 3/3] [media] winbond-cir: Adjust sample frequency to
 improve reliability
Message-ID: <20120703202825.GC29839@hardeman.nu>
References: <20120702115800.1275f944@kryten>
 <20120702115937.623d3b41@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120702115937.623d3b41@kryten>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 02, 2012 at 11:59:37AM +1000, Anton Blanchard wrote:
>
>When using my Logitech Harmony remote I get regular dropped events
>(about 1 in every 3). Adjusting the sample frequency to 6us so we
>sample at a multiple of an RC-6 pulse (444us) fixes it.

Sounds weird.

The in-kernel RC6 decoder already has margins of around 50% for most
pulse/spaces (i.e. 444us +/- 222us). Changing the sample resolution from
10 to 6 us should have little to no effect on the RC6 decoding (also,
the Windows driver uses a 50us resolution IIRC).

Do you have a log of a successful and unsuccesful event (the timings
that is)?

>Signed-off-by: Anton Blanchard <anton@samba.org>
>---
>
>Index: linux/drivers/media/rc/winbond-cir.c
>===================================================================
>--- linux.orig/drivers/media/rc/winbond-cir.c	2012-07-01 14:54:28.993475033 +1000
>+++ linux/drivers/media/rc/winbond-cir.c	2012-07-01 14:55:50.500939910 +1000
>@@ -358,7 +358,7 @@ wbcir_irq_rx(struct wbcir_data *data, st
> 		if (data->rxstate == WBCIR_RXSTATE_ERROR)
> 			continue;
> 		rawir.pulse = irdata & 0x80 ? false : true;
>-		rawir.duration = US_TO_NS((irdata & 0x7F) * 10);
>+		rawir.duration = US_TO_NS((irdata & 0x7F) * 6);
> 		ir_raw_event_store_with_filter(data->dev, &rawir);
> 	}
> 
>@@ -874,8 +874,8 @@ wbcir_init_hw(struct wbcir_data *data)
> 	/* prescaler 1.0, tx/rx fifo lvl 16 */
> 	outb(0x30, data->sbase + WBCIR_REG_SP3_EXCR2);
> 
>-	/* Set baud divisor to sample every 10 us */
>-	outb(0x0F, data->sbase + WBCIR_REG_SP3_BGDL);
>+	/* Set baud divisor to sample every 6 us */
>+	outb(0x09, data->sbase + WBCIR_REG_SP3_BGDL);
> 	outb(0x00, data->sbase + WBCIR_REG_SP3_BGDH);
> 
> 	/* Set CEIR mode */
>
