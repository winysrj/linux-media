Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.linuxtv.org ([130.149.80.248]:42324 "EHLO www.linuxtv.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557AbaB1RjQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Feb 2014 12:39:16 -0500
Message-Id: <E1WJRP0-0006ku-5J@www.linuxtv.org>
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Date: Fri, 28 Feb 2014 18:31:02 +0100
Subject: [git:media_tree/master] [media] omap_vout: avoid sleep_on race
To: linuxtv-commits@linuxtv.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an automatic generated email to let you know that the following patch were queued at the 
http://git.linuxtv.org/media_tree.git tree:

Subject: [media] omap_vout: avoid sleep_on race
Author:  Arnd Bergmann <arnd@arndb.de>
Date:    Thu Jan 2 09:07:29 2014 -0300

sleep_on and its variants are broken and going away soon. This changes
the omap vout driver to use wait_event_interruptible_timeout instead,
which fixes potential race where the dma is complete before we
schedule.

[hans.verkuil@cisco.com: replaced interruptible_sleep_on_timeout by
wait_event_interruptible_timeout in the commit msg, obvious typo]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

 drivers/media/platform/omap/omap_vout_vrfb.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

---

http://git.linuxtv.org/media_tree.git?a=commitdiff;h=6a859e09c40f09fd77411ca46d8b6ca1c08444fe

diff --git a/drivers/media/platform/omap/omap_vout_vrfb.c b/drivers/media/platform/omap/omap_vout_vrfb.c
index cf1c437..62e7e57 100644
--- a/drivers/media/platform/omap/omap_vout_vrfb.c
+++ b/drivers/media/platform/omap/omap_vout_vrfb.c
@@ -270,7 +270,8 @@ int omap_vout_prepare_vrfb(struct omap_vout_device *vout,
 	omap_dma_set_global_params(DMA_DEFAULT_ARB_RATE, 0x20, 0);
 
 	omap_start_dma(tx->dma_ch);
-	interruptible_sleep_on_timeout(&tx->wait, VRFB_TX_TIMEOUT);
+	wait_event_interruptible_timeout(tx->wait, tx->tx_status == 1,
+					 VRFB_TX_TIMEOUT);
 
 	if (tx->tx_status == 0) {
 		omap_stop_dma(tx->dma_ch);
