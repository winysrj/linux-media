Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauron-mordor.net ([82.227.150.75]:44525 "EHLO
        smtp.sauron-mordor.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755938AbcIKQRR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 11 Sep 2016 12:17:17 -0400
Date: Sun, 11 Sep 2016 18:07:59 +0200
From: Richard <rgroux@sauron-mordor.net>
To: mchehab@kernel.org, linux-media@vger.kernel.org
Subject: [PATCH] [media] staging/media/cec: fix coding style error
Message-ID: <20160911160753.7tiizqan5v3dt7sx@elias.sauron-mordor.intern>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Greetings Linux Kernel Developers,

This is Task 10 of the Eudyptula Challenge, i fix few line over 80
characters, hope you will accept this pacth.

/Richard

For the eudyptula challenge (http://eudyptula-challenge.org/).
Simple style fix for few line over 80 characters

Signed-off-by: Richard <rgroux@sauron-mordor.net>
---
 drivers/staging/media/cec/cec-adap.c | 20 +++++++++++++-------
 drivers/staging/media/cec/cec-api.c  |  6 ++++--
 drivers/staging/media/cec/cec-core.c |  9 ++++++---
 drivers/staging/media/cec/cec-priv.h |  3 ++-
 4 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/media/cec/cec-adap.c b/drivers/staging/media/cec/cec-adap.c
index 51bb581..fdb129c 100644
--- a/drivers/staging/media/cec/cec-adap.c
+++ b/drivers/staging/media/cec/cec-adap.c
@@ -1,7 +1,8 @@
 /*
  * cec-adap.c - HDMI Consumer Electronics Control framework - CEC adapter
  *
- * Copyright 2016 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
+ * Copyright 2016 Cisco Systems, Inc. and/or its affiliates.
+ * All rights reserved.
  *
  * This program is free software; you may redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -64,7 +65,8 @@ static int cec_log_addr2idx(const struct cec_adapter *adap, u8 log_addr)
 	return -1;
 }
 
-static unsigned int cec_log_addr2dev(const struct cec_adapter *adap, u8 log_addr)
+static unsigned int cec_log_addr2dev(const struct cec_adapter *adap,
+				     u8 log_addr)
 {
 	int i = cec_log_addr2idx(adap, log_addr);
 
@@ -330,9 +332,11 @@ int cec_thread_func(void *_adap)
 			 * see if the adapter is disabled in which case the
 			 * transmit should be canceled.
 			 */
-			err = wait_event_interruptible_timeout(adap->kthread_waitq,
+			err = wait_event_interruptible_timeout(
+				adap->kthread_waitq,
 				kthread_should_stop() ||
-				(!adap->is_configured && !adap->is_configuring) ||
+				(!adap->is_configured &&
+				 !adap->is_configuring) ||
 				(!adap->transmitting &&
 				 !list_empty(&adap->transmit_queue)),
 				msecs_to_jiffies(CEC_XFER_TIMEOUT_MS));
@@ -1527,13 +1531,15 @@ static int cec_receive_notify(struct cec_adapter *adap, struct cec_msg *msg,
 		/* Do nothing for CEC switches using addr 15 */
 		if (devtype == CEC_OP_PRIM_DEVTYPE_SWITCH && dest_laddr == 15)
 			return 0;
-		cec_msg_report_physical_addr(&tx_cec_msg, adap->phys_addr, devtype);
+		cec_msg_report_physical_addr(&tx_cec_msg,
+					     adap->phys_addr, devtype);
 		return cec_transmit_msg(adap, &tx_cec_msg, false);
 
 	case CEC_MSG_GIVE_DEVICE_VENDOR_ID:
 		if (adap->log_addrs.vendor_id == CEC_VENDOR_ID_NONE)
 			return cec_feature_abort(adap, msg);
-		cec_msg_device_vendor_id(&tx_cec_msg, adap->log_addrs.vendor_id);
+		cec_msg_device_vendor_id(&tx_cec_msg,
+					 adap->log_addrs.vendor_id);
 		return cec_transmit_msg(adap, &tx_cec_msg, false);
 
 	case CEC_MSG_ABORT:
@@ -1559,7 +1565,7 @@ static int cec_receive_notify(struct cec_adapter *adap, struct cec_msg *msg,
 		 * Unprocessed messages are aborted if userspace isn't doing
 		 * any processing either.
 		 */
-		if (!is_broadcast && !is_reply && !adap->follower_cnt &&
+		if (is_directed && !is_reply && !adap->follower_cnt &&
 		    !adap->cec_follower && msg->msg[1] != CEC_MSG_FEATURE_ABORT)
 			return cec_feature_abort(adap, msg);
 		break;
diff --git a/drivers/staging/media/cec/cec-api.c b/drivers/staging/media/cec/cec-api.c
index 049f171..a36f23b 100644
--- a/drivers/staging/media/cec/cec-api.c
+++ b/drivers/staging/media/cec/cec-api.c
@@ -1,7 +1,8 @@
 /*
  * cec-api.c - HDMI Consumer Electronics Control framework - API
  *
- * Copyright 2016 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
+ * Copyright 2016 Cisco Systems, Inc. and/or its affiliates.
+ * All rights reserved.
  *
  * This program is free software; you may redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -548,7 +549,8 @@ static int cec_release(struct inode *inode, struct file *filp)
 	mutex_lock(&adap->lock);
 	while (!list_empty(&fh->xfer_list)) {
 		struct cec_data *data =
-			list_first_entry(&fh->xfer_list, struct cec_data, xfer_list);
+			list_first_entry(&fh->xfer_list,
+					 struct cec_data, xfer_list);
 
 		data->blocking = false;
 		data->fh = NULL;
diff --git a/drivers/staging/media/cec/cec-core.c b/drivers/staging/media/cec/cec-core.c
index 112a5fa..1a381de 100644
--- a/drivers/staging/media/cec/cec-core.c
+++ b/drivers/staging/media/cec/cec-core.c
@@ -1,7 +1,8 @@
 /*
  * cec-core.c - HDMI Consumer Electronics Control framework - Core
  *
- * Copyright 2016 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
+ * Copyright 2016 Cisco Systems, Inc. and/or its affiliates.
+ * All rights reserved.
  *
  * This program is free software; you may redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -195,7 +196,8 @@ static void cec_devnode_unregister(struct cec_devnode *devnode)
 
 struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
 					 void *priv, const char *name, u32 caps,
-					 u8 available_las, struct device *parent)
+					 u8 available_las,
+					 struct device *parent)
 {
 	struct cec_adapter *adap;
 	int res;
@@ -311,7 +313,8 @@ int cec_register_adapter(struct cec_adapter *adap)
 	if (!top_cec_dir)
 		return 0;
 
-	adap->cec_dir = debugfs_create_dir(dev_name(&adap->devnode.dev), top_cec_dir);
+	adap->cec_dir = debugfs_create_dir(dev_name(&adap->devnode.dev),
+					   top_cec_dir);
 	if (IS_ERR_OR_NULL(adap->cec_dir)) {
 		pr_warn("cec-%s: Failed to create debugfs dir\n", adap->name);
 		return 0;
diff --git a/drivers/staging/media/cec/cec-priv.h b/drivers/staging/media/cec/cec-priv.h
index 70767a7..6ace587 100644
--- a/drivers/staging/media/cec/cec-priv.h
+++ b/drivers/staging/media/cec/cec-priv.h
@@ -1,7 +1,8 @@
 /*
  * cec-priv.h - HDMI Consumer Electronics Control internal header
  *
- * Copyright 2016 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
+ * Copyright 2016 Cisco Systems, Inc. and/or its affiliates.
+ * All rights reserved.
  *
  * This program is free software; you may redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
-- 
2.7.3

