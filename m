Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:42075 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751863AbdKVJMo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Nov 2017 04:12:44 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cec: disable the hardware when unregistered
Message-ID: <e5bac5e8-1058-034e-3371-929d83aa2fc1@xs4all.nl>
Date: Wed, 22 Nov 2017 10:12:39 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When the device is being unregistered disable the hardware, don't wait
until cec_delete_adapter is called as the hardware may have disappeared by
then. This would be the case for hotplugable devices.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Bård Eirik Winther <bwinther@cisco.com>
Tested-by: Bård Eirik Winther <bwinther@cisco.com>
---
 drivers/media/cec/cec-api.c  | 11 ++++-------
 drivers/media/cec/cec-core.c | 15 +++++++++------
 include/media/cec.h          | 12 ++++++++++++
 3 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/drivers/media/cec/cec-api.c b/drivers/media/cec/cec-api.c
index a079f7fe018c..766b16e60c3b 100644
--- a/drivers/media/cec/cec-api.c
+++ b/drivers/media/cec/cec-api.c
@@ -45,12 +45,11 @@ static inline struct cec_devnode *cec_devnode_data(struct file *filp)
 static unsigned int cec_poll(struct file *filp,
 			     struct poll_table_struct *poll)
 {
-	struct cec_devnode *devnode = cec_devnode_data(filp);
 	struct cec_fh *fh = filp->private_data;
 	struct cec_adapter *adap = fh->adap;
 	unsigned int res = 0;

-	if (!devnode->registered)
+	if (!cec_is_registered(adap))
 		return POLLERR | POLLHUP;
 	mutex_lock(&adap->lock);
 	if (adap->is_configured &&
@@ -474,13 +473,12 @@ static long cec_s_mode(struct cec_adapter *adap, struct cec_fh *fh,

 static long cec_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
-	struct cec_devnode *devnode = cec_devnode_data(filp);
 	struct cec_fh *fh = filp->private_data;
 	struct cec_adapter *adap = fh->adap;
 	bool block = !(filp->f_flags & O_NONBLOCK);
 	void __user *parg = (void __user *)arg;

-	if (!devnode->registered)
+	if (!cec_is_registered(adap))
 		return -ENODEV;

 	switch (cmd) {
@@ -604,9 +602,8 @@ static int cec_release(struct inode *inode, struct file *filp)

 	mutex_lock(&devnode->lock);
 	list_del(&fh->list);
-	if (list_empty(&devnode->fhs) &&
-	    !adap->needs_hpd &&
-	    adap->phys_addr == CEC_PHYS_ADDR_INVALID) {
+	if (cec_is_registered(adap) && list_empty(&devnode->fhs) &&
+	    !adap->needs_hpd && adap->phys_addr == CEC_PHYS_ADDR_INVALID) {
 		WARN_ON(adap->ops->adap_enable(adap, false));
 	}
 	mutex_unlock(&devnode->lock);
diff --git a/drivers/media/cec/cec-core.c b/drivers/media/cec/cec-core.c
index 648136e552d5..a56171d4d072 100644
--- a/drivers/media/cec/cec-core.c
+++ b/drivers/media/cec/cec-core.c
@@ -164,8 +164,9 @@ static int __must_check cec_devnode_register(struct cec_devnode *devnode,
  * This function can safely be called if the device node has never been
  * registered or has already been unregistered.
  */
-static void cec_devnode_unregister(struct cec_devnode *devnode)
+static void cec_devnode_unregister(struct cec_adapter *adap)
 {
+	struct cec_devnode *devnode = &adap->devnode;
 	struct cec_fh *fh;

 	mutex_lock(&devnode->lock);
@@ -183,6 +184,11 @@ static void cec_devnode_unregister(struct cec_devnode *devnode)
 	devnode->unregistered = true;
 	mutex_unlock(&devnode->lock);

+	mutex_lock(&adap->lock);
+	__cec_s_phys_addr(adap, CEC_PHYS_ADDR_INVALID, false);
+	__cec_s_log_addrs(adap, NULL, false);
+	mutex_unlock(&adap->lock);
+
 	cdev_device_del(&devnode->cdev, &devnode->dev);
 	put_device(&devnode->dev);
 }
@@ -196,7 +202,7 @@ static void cec_cec_notify(struct cec_adapter *adap, u16 pa)
 void cec_register_cec_notifier(struct cec_adapter *adap,
 			       struct cec_notifier *notifier)
 {
-	if (WARN_ON(!adap->devnode.registered))
+	if (WARN_ON(!cec_is_registered(adap)))
 		return;

 	adap->notifier = notifier;
@@ -374,7 +380,7 @@ void cec_unregister_adapter(struct cec_adapter *adap)
 	if (adap->notifier)
 		cec_notifier_unregister(adap->notifier);
 #endif
-	cec_devnode_unregister(&adap->devnode);
+	cec_devnode_unregister(adap);
 }
 EXPORT_SYMBOL_GPL(cec_unregister_adapter);

@@ -382,9 +388,6 @@ void cec_delete_adapter(struct cec_adapter *adap)
 {
 	if (IS_ERR_OR_NULL(adap))
 		return;
-	mutex_lock(&adap->lock);
-	__cec_s_phys_addr(adap, CEC_PHYS_ADDR_INVALID, false);
-	mutex_unlock(&adap->lock);
 	kthread_stop(adap->kthread);
 	if (adap->kthread_config)
 		kthread_stop(adap->kthread_config);
diff --git a/include/media/cec.h b/include/media/cec.h
index df6b3bd31284..c3cb1af3ccc0 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -229,6 +229,18 @@ static inline bool cec_is_sink(const struct cec_adapter *adap)
 	return adap->phys_addr == 0;
 }

+/**
+ * cec_is_registered() - is the CEC adapter registered?
+ *
+ * @adap:	the CEC adapter, may be NULL.
+ *
+ * Return: true if the adapter is registered, false otherwise.
+ */
+static inline bool cec_is_registered(const struct cec_adapter *adap)
+{
+	return adap && adap->devnode.registered;
+}
+
 #define cec_phys_addr_exp(pa) \
 	((pa) >> 12), ((pa) >> 8) & 0xf, ((pa) >> 4) & 0xf, (pa) & 0xf

-- 
2.14.1
