Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:41693 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966071AbcHBNRC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Aug 2016 09:17:02 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH (repost) 1/2] cec: rename cec_devnode fhs_lock to just lock
Date: Tue,  2 Aug 2016 15:16:50 +0200
Message-Id: <1470143811-9228-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1470143811-9228-1-git-send-email-hverkuil@xs4all.nl>
References: <1470143811-9228-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This lock will be used to protect more than just the fhs list.
So rename it to just 'lock'.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/cec/cec-adap.c | 12 ++++++------
 drivers/staging/media/cec/cec-api.c  |  8 ++++----
 drivers/staging/media/cec/cec-core.c |  6 +++---
 include/media/cec.h                  |  2 +-
 4 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/media/cec/cec-adap.c b/drivers/staging/media/cec/cec-adap.c
index b2393bb..9dcb784 100644
--- a/drivers/staging/media/cec/cec-adap.c
+++ b/drivers/staging/media/cec/cec-adap.c
@@ -124,10 +124,10 @@ static void cec_queue_event(struct cec_adapter *adap,
 	u64 ts = ktime_get_ns();
 	struct cec_fh *fh;
 
-	mutex_lock(&adap->devnode.fhs_lock);
+	mutex_lock(&adap->devnode.lock);
 	list_for_each_entry(fh, &adap->devnode.fhs, list)
 		cec_queue_event_fh(fh, ev, ts);
-	mutex_unlock(&adap->devnode.fhs_lock);
+	mutex_unlock(&adap->devnode.lock);
 }
 
 /*
@@ -191,12 +191,12 @@ static void cec_queue_msg_monitor(struct cec_adapter *adap,
 	u32 monitor_mode = valid_la ? CEC_MODE_MONITOR :
 				      CEC_MODE_MONITOR_ALL;
 
-	mutex_lock(&adap->devnode.fhs_lock);
+	mutex_lock(&adap->devnode.lock);
 	list_for_each_entry(fh, &adap->devnode.fhs, list) {
 		if (fh->mode_follower >= monitor_mode)
 			cec_queue_msg_fh(fh, msg);
 	}
-	mutex_unlock(&adap->devnode.fhs_lock);
+	mutex_unlock(&adap->devnode.lock);
 }
 
 /*
@@ -207,12 +207,12 @@ static void cec_queue_msg_followers(struct cec_adapter *adap,
 {
 	struct cec_fh *fh;
 
-	mutex_lock(&adap->devnode.fhs_lock);
+	mutex_lock(&adap->devnode.lock);
 	list_for_each_entry(fh, &adap->devnode.fhs, list) {
 		if (fh->mode_follower == CEC_MODE_FOLLOWER)
 			cec_queue_msg_fh(fh, msg);
 	}
-	mutex_unlock(&adap->devnode.fhs_lock);
+	mutex_unlock(&adap->devnode.lock);
 }
 
 /* Notify userspace of an adapter state change. */
diff --git a/drivers/staging/media/cec/cec-api.c b/drivers/staging/media/cec/cec-api.c
index 7be7615..4e2696a 100644
--- a/drivers/staging/media/cec/cec-api.c
+++ b/drivers/staging/media/cec/cec-api.c
@@ -508,14 +508,14 @@ static int cec_open(struct inode *inode, struct file *filp)
 
 	filp->private_data = fh;
 
-	mutex_lock(&devnode->fhs_lock);
+	mutex_lock(&devnode->lock);
 	/* Queue up initial state events */
 	ev_state.state_change.phys_addr = adap->phys_addr;
 	ev_state.state_change.log_addr_mask = adap->log_addrs.log_addr_mask;
 	cec_queue_event_fh(fh, &ev_state, 0);
 
 	list_add(&fh->list, &devnode->fhs);
-	mutex_unlock(&devnode->fhs_lock);
+	mutex_unlock(&devnode->lock);
 
 	return 0;
 }
@@ -540,9 +540,9 @@ static int cec_release(struct inode *inode, struct file *filp)
 		cec_monitor_all_cnt_dec(adap);
 	mutex_unlock(&adap->lock);
 
-	mutex_lock(&devnode->fhs_lock);
+	mutex_lock(&devnode->lock);
 	list_del(&fh->list);
-	mutex_unlock(&devnode->fhs_lock);
+	mutex_unlock(&devnode->lock);
 
 	/* Unhook pending transmits from this filehandle. */
 	mutex_lock(&adap->lock);
diff --git a/drivers/staging/media/cec/cec-core.c b/drivers/staging/media/cec/cec-core.c
index 112a5fa..73792d0 100644
--- a/drivers/staging/media/cec/cec-core.c
+++ b/drivers/staging/media/cec/cec-core.c
@@ -117,7 +117,7 @@ static int __must_check cec_devnode_register(struct cec_devnode *devnode,
 
 	/* Initialization */
 	INIT_LIST_HEAD(&devnode->fhs);
-	mutex_init(&devnode->fhs_lock);
+	mutex_init(&devnode->lock);
 
 	/* Part 1: Find a free minor number */
 	mutex_lock(&cec_devnode_lock);
@@ -181,10 +181,10 @@ static void cec_devnode_unregister(struct cec_devnode *devnode)
 	if (!devnode->registered || devnode->unregistered)
 		return;
 
-	mutex_lock(&devnode->fhs_lock);
+	mutex_lock(&devnode->lock);
 	list_for_each_entry(fh, &devnode->fhs, list)
 		wake_up_interruptible(&fh->wait);
-	mutex_unlock(&devnode->fhs_lock);
+	mutex_unlock(&devnode->lock);
 
 	devnode->registered = false;
 	devnode->unregistered = true;
diff --git a/include/media/cec.h b/include/media/cec.h
index dc7854b..fdb5d60 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -57,8 +57,8 @@ struct cec_devnode {
 	int minor;
 	bool registered;
 	bool unregistered;
-	struct mutex fhs_lock;
 	struct list_head fhs;
+	struct mutex lock;
 };
 
 struct cec_adapter;
-- 
2.8.1

