Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:38065 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932187AbdDDQKN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Apr 2017 12:10:13 -0400
Received: by mail-wm0-f41.google.com with SMTP id t189so32429200wmt.1
        for <linux-media@vger.kernel.org>; Tue, 04 Apr 2017 09:10:12 -0700 (PDT)
From: Lee Jones <lee.jones@linaro.org>
To: hans.verkuil@cisco.com, mchehab@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, patrice.chotard@st.com,
        linux-media@vger.kernel.org, benjamin.gaignard@st.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 2/2] [media] cec: Handle RC capability more elegantly
Date: Tue,  4 Apr 2017 17:10:05 +0100
Message-Id: <20170404161005.20884-2-lee.jones@linaro.org>
In-Reply-To: <20170404161005.20884-1-lee.jones@linaro.org>
References: <20170404161005.20884-1-lee.jones@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If a user specifies the use of RC as a capability, they should
really be enabling RC Core code.  If they do not we WARN() them
of this and disable the capability for them.

Once we know RC Core code has not been enabled, we can update
the user's capabilities and use them as a term of reference for
other RC-only calls.  This is preferable to having ugly #ifery
scattered throughout C code.

Most of the functions are actually safe to call, since they
sensibly check for a NULL RC pointer before they attempt to
deference it.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/media/cec/cec-core.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/media/cec/cec-core.c b/drivers/media/cec/cec-core.c
index cfe414a..51be8d6 100644
--- a/drivers/media/cec/cec-core.c
+++ b/drivers/media/cec/cec-core.c
@@ -208,9 +208,13 @@ struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
 		return ERR_PTR(-EINVAL);
 	if (WARN_ON(!available_las || available_las > CEC_MAX_LOG_ADDRS))
 		return ERR_PTR(-EINVAL);
+	if (WARN_ON(caps & CEC_CAP_RC && !IS_REACHABLE(CONFIG_RC_CORE)))
+		caps &= ~CEC_CAP_RC;
+
 	adap = kzalloc(sizeof(*adap), GFP_KERNEL);
 	if (!adap)
 		return ERR_PTR(-ENOMEM);
+
 	strlcpy(adap->name, name, sizeof(adap->name));
 	adap->phys_addr = CEC_PHYS_ADDR_INVALID;
 	adap->log_addrs.cec_version = CEC_OP_CEC_VERSION_2_0;
@@ -237,7 +241,6 @@ struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
 	if (!(caps & CEC_CAP_RC))
 		return adap;
 
-#if IS_REACHABLE(CONFIG_RC_CORE)
 	/* Prepare the RC input device */
 	adap->rc = rc_allocate_device(RC_DRIVER_SCANCODE);
 	if (!adap->rc) {
@@ -264,9 +267,7 @@ struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
 	adap->rc->priv = adap;
 	adap->rc->map_name = RC_MAP_CEC;
 	adap->rc->timeout = MS_TO_NS(100);
-#else
-	adap->capabilities &= ~CEC_CAP_RC;
-#endif
+
 	return adap;
 }
 EXPORT_SYMBOL_GPL(cec_allocate_adapter);
@@ -285,7 +286,6 @@ int cec_register_adapter(struct cec_adapter *adap,
 	adap->owner = parent->driver->owner;
 	adap->devnode.dev.parent = parent;
 
-#if IS_REACHABLE(CONFIG_RC_CORE)
 	if (adap->capabilities & CEC_CAP_RC) {
 		adap->rc->dev.parent = parent;
 		res = rc_register_device(adap->rc);
@@ -298,15 +298,13 @@ int cec_register_adapter(struct cec_adapter *adap,
 			return res;
 		}
 	}
-#endif
 
 	res = cec_devnode_register(&adap->devnode, adap->owner);
 	if (res) {
-#if IS_REACHABLE(CONFIG_RC_CORE)
 		/* Note: rc_unregister also calls rc_free */
 		rc_unregister_device(adap->rc);
 		adap->rc = NULL;
-#endif
+
 		return res;
 	}
 
@@ -337,11 +335,10 @@ void cec_unregister_adapter(struct cec_adapter *adap)
 	if (IS_ERR_OR_NULL(adap))
 		return;
 
-#if IS_REACHABLE(CONFIG_RC_CORE)
 	/* Note: rc_unregister also calls rc_free */
 	rc_unregister_device(adap->rc);
 	adap->rc = NULL;
-#endif
+
 	debugfs_remove_recursive(adap->cec_dir);
 	cec_devnode_unregister(&adap->devnode);
 }
@@ -357,9 +354,7 @@ void cec_delete_adapter(struct cec_adapter *adap)
 	kthread_stop(adap->kthread);
 	if (adap->kthread_config)
 		kthread_stop(adap->kthread_config);
-#if IS_REACHABLE(CONFIG_RC_CORE)
 	rc_free_device(adap->rc);
-#endif
 	kfree(adap);
 }
 EXPORT_SYMBOL_GPL(cec_delete_adapter);
-- 
2.9.3
