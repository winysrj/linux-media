Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:35613 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932552AbZKRTBY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2009 14:01:24 -0500
Date: Wed, 18 Nov 2009 20:01:14 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2/6] firedtv: packet requeuing is likely to succeed
To: linux-media@vger.kernel.org
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.7dc1f889fd1b69ad@s5r6.in-berlin.de>
Message-ID: <tkrat.f550f773f3d1da7d@s5r6.in-berlin.de>
References: <tkrat.7dc1f889fd1b69ad@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Packet DMA buffers are queued either initially all at once (then, a
queueing failure will cause firedtv to release the DMA context as a
whole) or subsequently one by one as they recycled after use (then a
failure is extremely unlikely).  Therefore we can be a little less
cautious when counting at which packet buffer to set the interrupt flag.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/media/dvb/firewire/firedtv-fw.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

Index: linux-2.6.32-rc7/drivers/media/dvb/firewire/firedtv-fw.c
===================================================================
--- linux-2.6.32-rc7.orig/drivers/media/dvb/firewire/firedtv-fw.c
+++ linux-2.6.32-rc7/drivers/media/dvb/firewire/firedtv-fw.c
@@ -79,19 +79,14 @@ struct firedtv_receive_context {
 static int queue_iso(struct firedtv_receive_context *ctx, int index)
 {
 	struct fw_iso_packet p;
-	int err;
 
 	p.payload_length = MAX_PACKET_SIZE;
-	p.interrupt = !(ctx->interrupt_packet & (IRQ_INTERVAL - 1));
+	p.interrupt = !(++ctx->interrupt_packet & (IRQ_INTERVAL - 1));
 	p.skip = 0;
 	p.header_length = ISO_HEADER_SIZE;
 
-	err = fw_iso_context_queue(ctx->context, &p, &ctx->buffer,
-				   index * MAX_PACKET_SIZE);
-	if (!err)
-		ctx->interrupt_packet++;
-
-	return err;
+	return fw_iso_context_queue(ctx->context, &p, &ctx->buffer,
+				    index * MAX_PACKET_SIZE);
 }
 
 static void handle_iso(struct fw_iso_context *context, u32 cycle,
@@ -150,7 +145,7 @@ static int start_iso(struct firedtv *fdt
 	if (err)
 		goto fail_context_destroy;
 
-	ctx->interrupt_packet = 1;
+	ctx->interrupt_packet = 0;
 	ctx->current_packet = 0;
 
 	for (i = 0; i < N_PAGES; i++)

-- 
Stefan Richter
-=====-==--= =-== =--=-
http://arcgraph.de/sr/

