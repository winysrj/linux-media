Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:60289 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753905AbcKBMqj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 Nov 2016 08:46:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 07/11] cec: add proper support for CDC-Only CEC devices
Date: Wed,  2 Nov 2016 13:46:31 +0100
Message-Id: <20161102124635.11989-8-hverkuil@xs4all.nl>
In-Reply-To: <20161102124635.11989-1-hverkuil@xs4all.nl>
References: <20161102124635.11989-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

CDC-Only CEC devices are CEC devices that can only handle CDC messages,
all other messages are ignored.

Add a flag to signal that this is a CDC-Only device and act accordingly.

Also add helper functions to identify if a CEC device is configured as a
CDC-Only device, a second TV, a switch or a processor, since these variations
cannot be determined by the logical address alone.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/cec/TODO       |  4 ---
 drivers/staging/media/cec/cec-adap.c | 31 ++++++++++++++++++++-
 drivers/staging/media/cec/cec-api.c  |  9 ++++++-
 include/linux/cec.h                  | 52 ++++++++++++++++++++++++++++++++++++
 4 files changed, 90 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/media/cec/TODO b/drivers/staging/media/cec/TODO
index 5a4cfdf8..504d35c 100644
--- a/drivers/staging/media/cec/TODO
+++ b/drivers/staging/media/cec/TODO
@@ -1,9 +1,5 @@
 TODOs:
 
-- Should CEC_LOG_ADDR_TYPE_SPECIFIC be replaced by TYPE_2ND_TV and TYPE_PROCESSOR?
-  And also TYPE_SWITCH and TYPE_CDC_ONLY in addition to the TYPE_UNREGISTERED?
-  This should give the framework more information about the device type
-  since SPECIFIC and UNREGISTERED give no useful information.
 - Once this is out of staging this should no longer be a separate
   config option, instead it should be selected by drivers that want it.
 - Revisit the IS_REACHABLE(RC_CORE): perhaps the RC_CORE support should
diff --git a/drivers/staging/media/cec/cec-adap.c b/drivers/staging/media/cec/cec-adap.c
index a65d866..054cd06 100644
--- a/drivers/staging/media/cec/cec-adap.c
+++ b/drivers/staging/media/cec/cec-adap.c
@@ -1233,7 +1233,8 @@ static int cec_config_thread_func(void *arg)
 	mutex_unlock(&adap->lock);
 
 	for (i = 0; i < las->num_log_addrs; i++) {
-		if (las->log_addr[i] == CEC_LOG_ADDR_INVALID)
+		if (las->log_addr[i] == CEC_LOG_ADDR_INVALID ||
+		    (las->flags & CEC_LOG_ADDRS_FL_CDC_ONLY))
 			continue;
 
 		/*
@@ -1355,6 +1356,29 @@ int __cec_s_log_addrs(struct cec_adapter *adap,
 		return 0;
 	}
 
+	if (log_addrs->flags & CEC_LOG_ADDRS_FL_CDC_ONLY) {
+		/*
+		 * Sanitize log_addrs fields if a CDC-Only device is
+		 * requested.
+		 */
+		log_addrs->num_log_addrs = 1;
+		log_addrs->osd_name[0] = '\0';
+		log_addrs->vendor_id = CEC_VENDOR_ID_NONE;
+		log_addrs->log_addr_type[0] = CEC_LOG_ADDR_TYPE_UNREGISTERED;
+		/*
+		 * This is just an internal convention since a CDC-Only device
+		 * doesn't have to be a switch. But switches already use
+		 * unregistered, so it makes some kind of sense to pick this
+		 * as the primary device. Since a CDC-Only device never sends
+		 * any 'normal' CEC messages this primary device type is never
+		 * sent over the CEC bus.
+		 */
+		log_addrs->primary_device_type[0] = CEC_OP_PRIM_DEVTYPE_SWITCH;
+		log_addrs->all_device_types[0] = 0;
+		log_addrs->features[0][0] = 0;
+		log_addrs->features[0][1] = 0;
+	}
+
 	/* Ensure the osd name is 0-terminated */
 	log_addrs->osd_name[sizeof(log_addrs->osd_name) - 1] = '\0';
 
@@ -1575,6 +1599,11 @@ static int cec_receive_notify(struct cec_adapter *adap, struct cec_msg *msg,
 
 	dprintk(1, "cec_receive_notify: %*ph\n", msg->len, msg->msg);
 
+	/* If this is a CDC-Only device, then ignore any non-CDC messages */
+	if (cec_is_cdc_only(&adap->log_addrs) &&
+	    msg->msg[1] != CEC_MSG_CDC_MESSAGE)
+		return 0;
+
 	if (adap->ops->received) {
 		/* Allow drivers to process the message first */
 		if (adap->ops->received(adap, msg) != -ENOMSG)
diff --git a/drivers/staging/media/cec/cec-api.c b/drivers/staging/media/cec/cec-api.c
index 54148a6..d4bc4ee 100644
--- a/drivers/staging/media/cec/cec-api.c
+++ b/drivers/staging/media/cec/cec-api.c
@@ -163,7 +163,8 @@ static long cec_adap_s_log_addrs(struct cec_adapter *adap, struct cec_fh *fh,
 	if (copy_from_user(&log_addrs, parg, sizeof(log_addrs)))
 		return -EFAULT;
 	log_addrs.flags &= CEC_LOG_ADDRS_FL_ALLOW_UNREG_FALLBACK |
-			   CEC_LOG_ADDRS_FL_ALLOW_RC_PASSTHRU;
+			   CEC_LOG_ADDRS_FL_ALLOW_RC_PASSTHRU |
+			   CEC_LOG_ADDRS_FL_CDC_ONLY;
 	mutex_lock(&adap->lock);
 	if (!adap->is_configuring &&
 	    (!log_addrs.num_log_addrs || !adap->is_configured) &&
@@ -190,6 +191,12 @@ static long cec_transmit(struct cec_adapter *adap, struct cec_fh *fh,
 		return -ENOTTY;
 	if (copy_from_user(&msg, parg, sizeof(msg)))
 		return -EFAULT;
+
+	/* A CDC-Only device can only send CDC messages */
+	if ((adap->log_addrs.flags & CEC_LOG_ADDRS_FL_CDC_ONLY) &&
+	    (msg.len == 1 || msg.msg[1] != CEC_MSG_CDC_MESSAGE))
+		return -EINVAL;
+
 	msg.flags &= CEC_MSG_FL_REPLY_TO_FOLLOWERS;
 	mutex_lock(&adap->lock);
 	if (!adap->is_configured)
diff --git a/include/linux/cec.h b/include/linux/cec.h
index 3f2f076..9c87711 100644
--- a/include/linux/cec.h
+++ b/include/linux/cec.h
@@ -396,6 +396,8 @@ struct cec_log_addrs {
 #define CEC_LOG_ADDRS_FL_ALLOW_UNREG_FALLBACK	(1 << 0)
 /* Passthrough RC messages to the input subsystem */
 #define CEC_LOG_ADDRS_FL_ALLOW_RC_PASSTHRU	(1 << 1)
+/* CDC-Only device: supports only CDC messages */
+#define CEC_LOG_ADDRS_FL_CDC_ONLY		(1 << 2)
 
 /* Events */
 
@@ -1016,4 +1018,54 @@ struct cec_event {
 #define CEC_OP_HPD_ERROR_OTHER				3
 #define CEC_OP_HPD_ERROR_NONE_NO_VIDEO			4
 
+/* End of Messages */
+
+/* Helper functions to identify the 'special' CEC devices */
+
+static inline bool cec_is_2nd_tv(const struct cec_log_addrs *las)
+{
+	/*
+	 * It is a second TV if the logical address is 14 or 15 and the
+	 * primary device type is a TV.
+	 */
+	return las->num_log_addrs &&
+	       las->log_addr[0] >= CEC_LOG_ADDR_SPECIFIC &&
+	       las->primary_device_type[0] == CEC_OP_PRIM_DEVTYPE_TV;
+}
+
+static inline bool cec_is_processor(const struct cec_log_addrs *las)
+{
+	/*
+	 * It is a processor if the logical address is 12-15 and the
+	 * primary device type is a Processor.
+	 */
+	return las->num_log_addrs &&
+	       las->log_addr[0] >= CEC_LOG_ADDR_BACKUP_1 &&
+	       las->primary_device_type[0] == CEC_OP_PRIM_DEVTYPE_PROCESSOR;
+}
+
+static inline bool cec_is_switch(const struct cec_log_addrs *las)
+{
+	/*
+	 * It is a switch if the logical address is 15 and the
+	 * primary device type is a Switch and the CDC-Only flag is not set.
+	 */
+	return las->num_log_addrs == 1 &&
+	       las->log_addr[0] == CEC_LOG_ADDR_UNREGISTERED &&
+	       las->primary_device_type[0] == CEC_OP_PRIM_DEVTYPE_SWITCH &&
+	       !(las->flags & CEC_LOG_ADDRS_FL_CDC_ONLY);
+}
+
+static inline bool cec_is_cdc_only(const struct cec_log_addrs *las)
+{
+	/*
+	 * It is a CDC-only device if the logical address is 15 and the
+	 * primary device type is a Switch and the CDC-Only flag is set.
+	 */
+	return las->num_log_addrs == 1 &&
+	       las->log_addr[0] == CEC_LOG_ADDR_UNREGISTERED &&
+	       las->primary_device_type[0] == CEC_OP_PRIM_DEVTYPE_SWITCH &&
+	       (las->flags & CEC_LOG_ADDRS_FL_CDC_ONLY);
+}
+
 #endif
-- 
2.10.1

