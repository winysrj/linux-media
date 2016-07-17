Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:42090 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751093AbcGQPCu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 11:02:50 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 7/7] vivid: support monitor all mode
Date: Sun, 17 Jul 2016 17:02:34 +0200
Message-Id: <1468767754-48542-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1468767754-48542-1-git-send-email-hverkuil@xs4all.nl>
References: <1468767754-48542-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Just pass the transmitted CEC message to all CEC adapters.
This implements the Monitor All mode for vivid.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-cec.c | 44 +++++++++++---------------------
 1 file changed, 15 insertions(+), 29 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-cec.c b/drivers/media/platform/vivid/vivid-cec.c
index b5714fa..66aa729 100644
--- a/drivers/media/platform/vivid/vivid-cec.c
+++ b/drivers/media/platform/vivid/vivid-cec.c
@@ -40,19 +40,18 @@ void vivid_cec_bus_free_work(struct vivid_dev *dev)
 	spin_unlock(&dev->cec_slock);
 }
 
-static struct cec_adapter *vivid_cec_find_dest_adap(struct vivid_dev *dev,
-						    struct cec_adapter *adap,
-						    u8 dest)
+static bool vivid_cec_find_dest_adap(struct vivid_dev *dev,
+				     struct cec_adapter *adap, u8 dest)
 {
 	unsigned int i;
 
 	if (dest >= 0xf)
-		return NULL;
+		return false;
 
 	if (adap != dev->cec_rx_adap && dev->cec_rx_adap &&
 	    dev->cec_rx_adap->is_configured &&
 	    cec_has_log_addr(dev->cec_rx_adap, dest))
-		return dev->cec_rx_adap;
+		return true;
 
 	for (i = 0; i < MAX_OUTPUTS && dev->cec_tx_adap[i]; i++) {
 		if (adap == dev->cec_tx_adap[i])
@@ -60,9 +59,9 @@ static struct cec_adapter *vivid_cec_find_dest_adap(struct vivid_dev *dev,
 		if (!dev->cec_tx_adap[i]->is_configured)
 			continue;
 		if (cec_has_log_addr(dev->cec_tx_adap[i], dest))
-			return dev->cec_tx_adap[i];
+			return true;
 	}
-	return NULL;
+	return false;
 }
 
 static void vivid_cec_xfer_done_worker(struct work_struct *work)
@@ -71,18 +70,14 @@ static void vivid_cec_xfer_done_worker(struct work_struct *work)
 		container_of(work, struct vivid_cec_work, work.work);
 	struct vivid_dev *dev = cw->dev;
 	struct cec_adapter *adap = cw->adap;
-	bool is_poll = cw->msg.len == 1;
 	u8 dest = cec_msg_destination(&cw->msg);
-	struct cec_adapter *dest_adap = NULL;
 	bool valid_dest;
 	unsigned int i;
 
 	valid_dest = cec_msg_is_broadcast(&cw->msg);
-	if (!valid_dest) {
-		dest_adap = vivid_cec_find_dest_adap(dev, adap, dest);
-		if (dest_adap)
-			valid_dest = true;
-	}
+	if (!valid_dest)
+		valid_dest = vivid_cec_find_dest_adap(dev, adap, dest);
+
 	cw->tx_status = valid_dest ? CEC_TX_STATUS_OK : CEC_TX_STATUS_NACK;
 	spin_lock(&dev->cec_slock);
 	dev->cec_xfer_time_jiffies = 0;
@@ -91,21 +86,12 @@ static void vivid_cec_xfer_done_worker(struct work_struct *work)
 	spin_unlock(&dev->cec_slock);
 	cec_transmit_done(cw->adap, cw->tx_status, 0, valid_dest ? 0 : 1, 0, 0);
 
-	if (!is_poll && dest_adap) {
-		/* Directed message */
-		cec_received_msg(dest_adap, &cw->msg);
-	} else if (!is_poll && valid_dest) {
-		/* Broadcast message */
-		if (adap != dev->cec_rx_adap &&
-		    dev->cec_rx_adap->log_addrs.log_addr_mask)
-			cec_received_msg(dev->cec_rx_adap, &cw->msg);
-		for (i = 0; i < MAX_OUTPUTS && dev->cec_tx_adap[i]; i++) {
-			if (adap == dev->cec_tx_adap[i] ||
-			    !dev->cec_tx_adap[i]->log_addrs.log_addr_mask)
-				continue;
+	/* Broadcast message */
+	if (adap != dev->cec_rx_adap)
+		cec_received_msg(dev->cec_rx_adap, &cw->msg);
+	for (i = 0; i < MAX_OUTPUTS && dev->cec_tx_adap[i]; i++)
+		if (adap != dev->cec_tx_adap[i])
 			cec_received_msg(dev->cec_tx_adap[i], &cw->msg);
-		}
-	}
 	kfree(cw);
 }
 
@@ -245,7 +231,7 @@ struct cec_adapter *vivid_cec_alloc_adap(struct vivid_dev *dev,
 {
 	char name[sizeof(dev->vid_out_dev.name) + 2];
 	u32 caps = CEC_CAP_TRANSMIT | CEC_CAP_LOG_ADDRS |
-		CEC_CAP_PASSTHROUGH | CEC_CAP_RC;
+		CEC_CAP_PASSTHROUGH | CEC_CAP_RC | CEC_CAP_MONITOR_ALL;
 
 	snprintf(name, sizeof(name), "%s%d",
 		 is_source ? dev->vid_out_dev.name : dev->vid_cap_dev.name,
-- 
2.8.1

