Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:49825 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751481AbdFGOqW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Jun 2017 10:46:22 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH 5/9] cec: add CEC_CAP_NEEDS_HPD
Date: Wed,  7 Jun 2017 16:46:12 +0200
Message-Id: <20170607144616.15247-6-hverkuil@xs4all.nl>
In-Reply-To: <20170607144616.15247-1-hverkuil@xs4all.nl>
References: <20170607144616.15247-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add a new capability CEC_CAP_NEEDS_HPD. If this capability is set
then the hardware can only use CEC if the HDMI Hotplug Detect pin
is high. Such hardware cannot handle the corner case in the CEC specification
where it is possible to transmit messages even if no hotplug signal is
present (needed for some displays that turn off the HPD when in standby,
but still have CEC enabled).

Typically hardware that needs this capability have the HPD wired to the CEC
block, often to a 'power' or 'active' pin.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/media/cec/cec-adap.c | 20 ++++++++++++++------
 drivers/media/cec/cec-api.c  |  5 ++++-
 drivers/media/cec/cec-core.c |  1 +
 include/media/cec.h          |  1 +
 include/uapi/linux/cec.h     |  2 ++
 5 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index bd76c15ade4f..bf45977b2823 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -368,6 +368,8 @@ int cec_thread_func(void *_adap)
 			 * transmit should be canceled.
 			 */
 			err = wait_event_interruptible_timeout(adap->kthread_waitq,
+				(adap->needs_hpd &&
+				 (!adap->is_configured && !adap->is_configuring)) ||
 				kthread_should_stop() ||
 				(!adap->transmitting &&
 				 !list_empty(&adap->transmit_queue)),
@@ -383,7 +385,9 @@ int cec_thread_func(void *_adap)
 
 		mutex_lock(&adap->lock);
 
-		if (kthread_should_stop()) {
+		if ((adap->needs_hpd &&
+		     (!adap->is_configured && !adap->is_configuring)) ||
+		    kthread_should_stop()) {
 			cec_flush(adap);
 			goto unlock;
 		}
@@ -682,7 +686,7 @@ int cec_transmit_msg_fh(struct cec_adapter *adap, struct cec_msg *msg,
 		return -EINVAL;
 	}
 	if (!adap->is_configured && !adap->is_configuring) {
-		if (msg->msg[0] != 0xf0) {
+		if (adap->needs_hpd || msg->msg[0] != 0xf0) {
 			dprintk(1, "%s: adapter is unconfigured\n", __func__);
 			return -ENONET;
 		}
@@ -1158,7 +1162,9 @@ static int cec_config_log_addr(struct cec_adapter *adap,
  */
 static void cec_adap_unconfigure(struct cec_adapter *adap)
 {
-	WARN_ON(adap->ops->adap_log_addr(adap, CEC_LOG_ADDR_INVALID));
+	if (!adap->needs_hpd ||
+	    adap->phys_addr != CEC_PHYS_ADDR_INVALID)
+		WARN_ON(adap->ops->adap_log_addr(adap, CEC_LOG_ADDR_INVALID));
 	adap->log_addrs.log_addr_mask = 0;
 	adap->is_configuring = false;
 	adap->is_configured = false;
@@ -1387,6 +1393,8 @@ void __cec_s_phys_addr(struct cec_adapter *adap, u16 phys_addr, bool block)
 	if (phys_addr == adap->phys_addr || adap->devnode.unregistered)
 		return;
 
+	dprintk(1, "new physical address %x.%x.%x.%x\n",
+		cec_phys_addr_exp(phys_addr));
 	if (phys_addr == CEC_PHYS_ADDR_INVALID ||
 	    adap->phys_addr != CEC_PHYS_ADDR_INVALID) {
 		adap->phys_addr = CEC_PHYS_ADDR_INVALID;
@@ -1396,7 +1404,7 @@ void __cec_s_phys_addr(struct cec_adapter *adap, u16 phys_addr, bool block)
 		if (adap->monitor_all_cnt)
 			WARN_ON(call_op(adap, adap_monitor_all_enable, false));
 		mutex_lock(&adap->devnode.lock);
-		if (list_empty(&adap->devnode.fhs))
+		if (adap->needs_hpd || list_empty(&adap->devnode.fhs))
 			WARN_ON(adap->ops->adap_enable(adap, false));
 		mutex_unlock(&adap->devnode.lock);
 		if (phys_addr == CEC_PHYS_ADDR_INVALID)
@@ -1404,7 +1412,7 @@ void __cec_s_phys_addr(struct cec_adapter *adap, u16 phys_addr, bool block)
 	}
 
 	mutex_lock(&adap->devnode.lock);
-	if (list_empty(&adap->devnode.fhs) &&
+	if ((adap->needs_hpd || list_empty(&adap->devnode.fhs)) &&
 	    adap->ops->adap_enable(adap, true)) {
 		mutex_unlock(&adap->devnode.lock);
 		return;
@@ -1412,7 +1420,7 @@ void __cec_s_phys_addr(struct cec_adapter *adap, u16 phys_addr, bool block)
 
 	if (adap->monitor_all_cnt &&
 	    call_op(adap, adap_monitor_all_enable, true)) {
-		if (list_empty(&adap->devnode.fhs))
+		if (adap->needs_hpd || list_empty(&adap->devnode.fhs))
 			WARN_ON(adap->ops->adap_enable(adap, false));
 		mutex_unlock(&adap->devnode.lock);
 		return;
diff --git a/drivers/media/cec/cec-api.c b/drivers/media/cec/cec-api.c
index 0860fb458757..1359c3977101 100644
--- a/drivers/media/cec/cec-api.c
+++ b/drivers/media/cec/cec-api.c
@@ -202,7 +202,8 @@ static long cec_transmit(struct cec_adapter *adap, struct cec_fh *fh,
 		err = -EPERM;
 	else if (adap->is_configuring)
 		err = -ENONET;
-	else if (!adap->is_configured && msg.msg[0] != 0xf0)
+	else if (!adap->is_configured &&
+		 (adap->needs_hpd || msg.msg[0] != 0xf0))
 		err = -ENONET;
 	else if (cec_is_busy(adap, fh))
 		err = -EBUSY;
@@ -521,6 +522,7 @@ static int cec_open(struct inode *inode, struct file *filp)
 
 	mutex_lock(&devnode->lock);
 	if (list_empty(&devnode->fhs) &&
+	    !adap->needs_hpd &&
 	    adap->phys_addr == CEC_PHYS_ADDR_INVALID) {
 		err = adap->ops->adap_enable(adap, true);
 		if (err) {
@@ -565,6 +567,7 @@ static int cec_release(struct inode *inode, struct file *filp)
 	mutex_lock(&devnode->lock);
 	list_del(&fh->list);
 	if (list_empty(&devnode->fhs) &&
+	    !adap->needs_hpd &&
 	    adap->phys_addr == CEC_PHYS_ADDR_INVALID) {
 		WARN_ON(adap->ops->adap_enable(adap, false));
 	}
diff --git a/drivers/media/cec/cec-core.c b/drivers/media/cec/cec-core.c
index 2f87748ba4fc..b516d599d6c4 100644
--- a/drivers/media/cec/cec-core.c
+++ b/drivers/media/cec/cec-core.c
@@ -230,6 +230,7 @@ struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
 	adap->log_addrs.cec_version = CEC_OP_CEC_VERSION_2_0;
 	adap->log_addrs.vendor_id = CEC_VENDOR_ID_NONE;
 	adap->capabilities = caps;
+	adap->needs_hpd = caps & CEC_CAP_NEEDS_HPD;
 	adap->available_log_addrs = available_las;
 	adap->sequence = 0;
 	adap->ops = ops;
diff --git a/include/media/cec.h b/include/media/cec.h
index a2e184d1df00..7e32e80b243e 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -164,6 +164,7 @@ struct cec_adapter {
 	u8 available_log_addrs;
 
 	u16 phys_addr;
+	bool needs_hpd;
 	bool is_configuring;
 	bool is_configured;
 	u32 monitor_all_cnt;
diff --git a/include/uapi/linux/cec.h b/include/uapi/linux/cec.h
index a0dfe27bc6c7..44579a24f95d 100644
--- a/include/uapi/linux/cec.h
+++ b/include/uapi/linux/cec.h
@@ -336,6 +336,8 @@ static inline int cec_is_unconfigured(__u16 log_addr_mask)
 #define CEC_CAP_RC		(1 << 4)
 /* Hardware can monitor all messages, not just directed and broadcast. */
 #define CEC_CAP_MONITOR_ALL	(1 << 5)
+/* Hardware can use CEC only if the HDMI HPD pin is high. */
+#define CEC_CAP_NEEDS_HPD	(1 << 6)
 
 /**
  * struct cec_caps - CEC capabilities structure.
-- 
2.11.0
