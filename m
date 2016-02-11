Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:48635 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750905AbcBKHad (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Feb 2016 02:30:33 -0500
Subject: [PATCHv12 18/17] cec: check for RC_CORE support
To: linux-media@vger.kernel.org
References: <1455108711-29850-1-git-send-email-hverkuil@xs4all.nl>
 <1455108711-29850-18-git-send-email-hverkuil@xs4all.nl>
Cc: dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
	linux-input@vger.kernel.org, lars@opdenkamp.eu,
	linux@arm.linux.org.uk, Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56BC3893.10208@xs4all.nl>
Date: Thu, 11 Feb 2016 08:30:27 +0100
MIME-Version: 1.0
In-Reply-To: <1455108711-29850-18-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If CONFIG_RC_CORE is not enabled, then remove the rc support, otherwise
the module won't link.

This will be folded into patch 07/17 for the final pull request.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/Kconfig |  2 --
 drivers/media/cec.c   | 16 ++++++++++++++++
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index 4f7fd52..ef8192e 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -82,8 +82,6 @@ config MEDIA_RC_SUPPORT

 config MEDIA_CEC
 	tristate "CEC API (EXPERIMENTAL)"
-	depends on MEDIA_RC_SUPPORT
-	select RC_CORE
 	---help---
 	  Enable the CEC API.

diff --git a/drivers/media/cec.c b/drivers/media/cec.c
index a14ac73..e9fa698 100644
--- a/drivers/media/cec.c
+++ b/drivers/media/cec.c
@@ -744,6 +744,7 @@ static int cec_receive_notify(struct cec_adapter *adap, struct cec_msg *msg,
 		if (!(adap->capabilities & CEC_CAP_RC))
 			break;

+#if IS_ENABLED(CONFIG_RC_CORE)
 		switch (msg->msg[2]) {
 		/*
 		 * Play function, this message can have variable length
@@ -773,12 +774,15 @@ static int cec_receive_notify(struct cec_adapter *adap, struct cec_msg *msg,
 			rc_keydown(adap->rc, RC_TYPE_CEC, msg->msg[2], 0);
 			break;
 		}
+#endif
 		break;

 	case CEC_MSG_USER_CONTROL_RELEASED:
 		if (!(adap->capabilities & CEC_CAP_RC))
 			break;
+#if IS_ENABLED(CONFIG_RC_CORE)
 		rc_keyup(adap->rc);
+#endif
 		break;

 	/*
@@ -2059,6 +2063,7 @@ struct cec_adapter *cec_create_adapter(const struct cec_adap_ops *ops,
 	if (!(caps & CEC_CAP_RC))
 		return adap;

+#if IS_ENABLED(CONFIG_RC_CORE)
 	/* Prepare the RC input device */
 	adap->rc = rc_allocate_device();
 	if (!adap->rc) {
@@ -2089,6 +2094,9 @@ struct cec_adapter *cec_create_adapter(const struct cec_adap_ops *ops,
 	adap->rc->priv = adap;
 	adap->rc->map_name = RC_MAP_CEC;
 	adap->rc->timeout = MS_TO_NS(100);
+#else
+	adap->capabilities &= ~CEC_CAP_RC;
+#endif
 	return adap;
 }
 EXPORT_SYMBOL_GPL(cec_create_adapter);
@@ -2097,6 +2105,7 @@ int cec_register_adapter(struct cec_adapter *adap)
 {
 	int res;

+#if IS_ENABLED(CONFIG_RC_CORE)
 	if (adap->capabilities & CEC_CAP_RC) {
 		res = rc_register_device(adap->rc);

@@ -2108,13 +2117,16 @@ int cec_register_adapter(struct cec_adapter *adap)
 			return res;
 		}
 	}
+#endif

 	res = cec_devnode_register(&adap->devnode, adap->owner);
+#if IS_ENABLED(CONFIG_RC_CORE)
 	if (res) {
 		/* Note: rc_unregister also calls rc_free */
 		rc_unregister_device(adap->rc);
 		adap->rc = NULL;
 	}
+#endif
 	return res;
 }
 EXPORT_SYMBOL_GPL(cec_register_adapter);
@@ -2123,9 +2135,11 @@ void cec_unregister_adapter(struct cec_adapter *adap)
 {
 	if (IS_ERR_OR_NULL(adap))
 		return;
+#if IS_ENABLED(CONFIG_RC_CORE)
 	/* Note: rc_unregister also calls rc_free */
 	rc_unregister_device(adap->rc);
 	adap->rc = NULL;
+#endif
 	cec_devnode_unregister(&adap->devnode);
 }
 EXPORT_SYMBOL_GPL(cec_unregister_adapter);
@@ -2139,8 +2153,10 @@ void cec_delete_adapter(struct cec_adapter *adap)
 		kthread_stop(adap->kthread_config);
 	if (adap->is_enabled)
 		cec_enable(adap, false);
+#if IS_ENABLED(CONFIG_RC_CORE)
 	if (adap->rc)
 		rc_free_device(adap->rc);
+#endif
 	kfree(adap->name);
 	kfree(adap);
 }
-- 
2.7.0


