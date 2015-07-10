Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:32975 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080AbbGJMUb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jul 2015 08:20:31 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, corbet@lwn.net,
	linux-media@vger.kernel.org, rob@landley.net,
	netdev@vger.kernel.org, davem@davemloft.net
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] Doc: z8530book: Fix typo in API-z8530-sync-txdma-open.html
Date: Fri, 10 Jul 2015 21:20:28 +0900
Message-Id: <1436530828-7734-1-git-send-email-standby24x7@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fix a spelling typo found in API-z8530-sync-txdma-open.html.
It is because this file was generated from comment in source,
I have to fix comment in source.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/net/wan/z85230.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wan/z85230.c b/drivers/net/wan/z85230.c
index feacc3b..2f0bd69 100644
--- a/drivers/net/wan/z85230.c
+++ b/drivers/net/wan/z85230.c
@@ -1044,7 +1044,7 @@ EXPORT_SYMBOL(z8530_sync_dma_close);
  *	@dev: The network device to attach
  *	@c: The Z8530 channel to configure in sync DMA mode.
  *
- *	Set up a Z85x30 device for synchronous DMA tranmission. One
+ *	Set up a Z85x30 device for synchronous DMA transmission. One
  *	ISA DMA channel must be available for this to work. The receive
  *	side is run in PIO mode, but then it has the bigger FIFO.
  */
-- 
2.5.0.rc1

