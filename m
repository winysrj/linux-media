Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:50231 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932166AbdDRIqN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Apr 2017 04:46:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH for v4.12 3/3] cec: add MEDIA_CEC_RC config option
Date: Tue, 18 Apr 2017 10:46:01 +0200
Message-Id: <20170418084601.1590-4-hverkuil@xs4all.nl>
In-Reply-To: <20170418084601.1590-1-hverkuil@xs4all.nl>
References: <20170418084601.1590-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add an explicit config option to select whether the CEC remote control
messages are to be passed on to the RC subsystem or not.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/cec/Kconfig    |  8 +++++++-
 drivers/media/cec/cec-adap.c |  4 ++--
 drivers/media/cec/cec-core.c | 12 ++++++------
 3 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/media/cec/Kconfig b/drivers/media/cec/Kconfig
index 24b53187ee52..f944d93e3167 100644
--- a/drivers/media/cec/Kconfig
+++ b/drivers/media/cec/Kconfig
@@ -6,8 +6,14 @@ config CEC_CORE
 config MEDIA_CEC_NOTIFIER
 	bool
 
+config MEDIA_CEC_RC
+	bool "HDMI CEC RC integration"
+	depends on CEC_CORE && RC_CORE
+	---help---
+	  Pass on CEC remote control messages to the RC framework.
+
 config MEDIA_CEC_DEBUG
 	bool "HDMI CEC debugfs interface"
-	depends on MEDIA_CEC_SUPPORT && DEBUG_FS
+	depends on CEC_CORE && DEBUG_FS
 	---help---
 	  Turns on the DebugFS interface for CEC devices.
diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index 25d0a835921f..f5fe01c9da8a 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -1732,7 +1732,7 @@ static int cec_receive_notify(struct cec_adapter *adap, struct cec_msg *msg,
 		    !(adap->log_addrs.flags & CEC_LOG_ADDRS_FL_ALLOW_RC_PASSTHRU))
 			break;
 
-#if IS_REACHABLE(CONFIG_RC_CORE)
+#ifdef CONFIG_MEDIA_CEC_RC
 		switch (msg->msg[2]) {
 		/*
 		 * Play function, this message can have variable length
@@ -1769,7 +1769,7 @@ static int cec_receive_notify(struct cec_adapter *adap, struct cec_msg *msg,
 		if (!(adap->capabilities & CEC_CAP_RC) ||
 		    !(adap->log_addrs.flags & CEC_LOG_ADDRS_FL_ALLOW_RC_PASSTHRU))
 			break;
-#if IS_REACHABLE(CONFIG_RC_CORE)
+#ifdef CONFIG_MEDIA_CEC_RC
 		rc_keyup(adap->rc);
 #endif
 		break;
diff --git a/drivers/media/cec/cec-core.c b/drivers/media/cec/cec-core.c
index 430f5e052ab3..a21fca7f7883 100644
--- a/drivers/media/cec/cec-core.c
+++ b/drivers/media/cec/cec-core.c
@@ -220,7 +220,7 @@ struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
 	struct cec_adapter *adap;
 	int res;
 
-#if !IS_REACHABLE(CONFIG_RC_CORE)
+#ifndef CONFIG_MEDIA_CEC_RC
 	caps &= ~CEC_CAP_RC;
 #endif
 
@@ -256,7 +256,7 @@ struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
 		return ERR_PTR(res);
 	}
 
-#if IS_REACHABLE(CONFIG_RC_CORE)
+#ifdef CONFIG_MEDIA_CEC_RC
 	if (!(caps & CEC_CAP_RC))
 		return adap;
 
@@ -305,7 +305,7 @@ int cec_register_adapter(struct cec_adapter *adap,
 	adap->owner = parent->driver->owner;
 	adap->devnode.dev.parent = parent;
 
-#if IS_REACHABLE(CONFIG_RC_CORE)
+#ifdef CONFIG_MEDIA_CEC_RC
 	if (adap->capabilities & CEC_CAP_RC) {
 		adap->rc->dev.parent = parent;
 		res = rc_register_device(adap->rc);
@@ -322,7 +322,7 @@ int cec_register_adapter(struct cec_adapter *adap,
 
 	res = cec_devnode_register(&adap->devnode, adap->owner);
 	if (res) {
-#if IS_REACHABLE(CONFIG_RC_CORE)
+#ifdef CONFIG_MEDIA_CEC_RC
 		/* Note: rc_unregister also calls rc_free */
 		rc_unregister_device(adap->rc);
 		adap->rc = NULL;
@@ -357,7 +357,7 @@ void cec_unregister_adapter(struct cec_adapter *adap)
 	if (IS_ERR_OR_NULL(adap))
 		return;
 
-#if IS_REACHABLE(CONFIG_RC_CORE)
+#ifdef CONFIG_MEDIA_CEC_RC
 	/* Note: rc_unregister also calls rc_free */
 	rc_unregister_device(adap->rc);
 	adap->rc = NULL;
@@ -381,7 +381,7 @@ void cec_delete_adapter(struct cec_adapter *adap)
 	kthread_stop(adap->kthread);
 	if (adap->kthread_config)
 		kthread_stop(adap->kthread_config);
-#if IS_REACHABLE(CONFIG_RC_CORE)
+#ifdef CONFIG_MEDIA_CEC_RC
 	rc_free_device(adap->rc);
 #endif
 	kfree(adap);
-- 
2.11.0
