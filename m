Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:35610 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872AbZKRTBH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2009 14:01:07 -0500
Date: Wed, 18 Nov 2009 20:00:55 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 1/6] firedtv: shrink buffer pointer table
To: linux-media@vger.kernel.org
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.7dc1f889fd1b69ad@s5r6.in-berlin.de>
Message-ID: <tkrat.6b9442a2f97654ef@s5r6.in-berlin.de>
References: <tkrat.7dc1f889fd1b69ad@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cache only addresses of whole pages, not of each buffer chunk.  Besides,
page addresses can be obtained by page_address() instead of kmap() since
they were allocated in lowmem.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/media/dvb/firewire/firedtv-fw.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

Index: linux-2.6.32-rc7/drivers/media/dvb/firewire/firedtv-fw.c
===================================================================
--- linux-2.6.32-rc7.orig/drivers/media/dvb/firewire/firedtv-fw.c
+++ linux-2.6.32-rc7/drivers/media/dvb/firewire/firedtv-fw.c
@@ -6,9 +6,9 @@
 #include <linux/errno.h>
 #include <linux/firewire.h>
 #include <linux/firewire-constants.h>
-#include <linux/highmem.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
+#include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/types.h>
@@ -73,7 +73,7 @@ struct firedtv_receive_context {
 	struct fw_iso_buffer buffer;
 	int interrupt_packet;
 	int current_packet;
-	char *packets[N_PACKETS];
+	char *pages[N_PAGES];
 };
 
 static int queue_iso(struct firedtv_receive_context *ctx, int index)
@@ -100,7 +100,7 @@ static void handle_iso(struct fw_iso_con
 	struct firedtv *fdtv = data;
 	struct firedtv_receive_context *ctx = fdtv->backend_data;
 	__be32 *h, *h_end;
-	int i = ctx->current_packet, length, err;
+	int length, err, i = ctx->current_packet;
 	char *p, *p_end;
 
 	for (h = header, h_end = h + header_length / 4; h < h_end; h++) {
@@ -110,7 +110,8 @@ static void handle_iso(struct fw_iso_con
 			length = MAX_PACKET_SIZE;
 		}
 
-		p = ctx->packets[i];
+		p = ctx->pages[i / PACKETS_PER_PAGE]
+				+ (i % PACKETS_PER_PAGE) * MAX_PACKET_SIZE;
 		p_end = p + length;
 
 		for (p += CIP_HEADER_SIZE + MPEG2_TS_HEADER_SIZE; p < p_end;
@@ -130,8 +131,7 @@ static int start_iso(struct firedtv *fdt
 {
 	struct firedtv_receive_context *ctx;
 	struct fw_device *device = device_of(fdtv);
-	char *p;
-	int i, j, k, err;
+	int i, err;
 
 	ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
@@ -153,11 +153,8 @@ static int start_iso(struct firedtv *fdt
 	ctx->interrupt_packet = 1;
 	ctx->current_packet = 0;
 
-	for (i = 0, k = 0; k < N_PAGES; k++) {
-		p = kmap(ctx->buffer.pages[k]);
-		for (j = 0; j < PACKETS_PER_PAGE && i < N_PACKETS; j++, i++)
-			ctx->packets[i] = p + j * MAX_PACKET_SIZE;
-	}
+	for (i = 0; i < N_PAGES; i++)
+		ctx->pages[i] = page_address(ctx->buffer.pages[i]);
 
 	for (i = 0; i < N_PACKETS; i++) {
 		err = queue_iso(ctx, i);

-- 
Stefan Richter
-=====-==--= =-== =--=-
http://arcgraph.de/sr/

