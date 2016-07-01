Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:52476 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752335AbcGAKhL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Jul 2016 06:37:11 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cec: fix Kconfig dependency problems
Message-ID: <619887af-e879-d4ec-5697-50ee101eaf51@xs4all.nl>
Date: Fri, 1 Jul 2016 12:37:06 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- Use IS_REACHABLE(RC_CORE) instead of IS_ENABLED: if cec is built-in and
  RC_CORE is a module, then CEC can't reach the RC symbols.
- Both cec and cec-edid should be bool and use the same build 'mode' as
  MEDIA_SUPPORT (just as is done for the media controller code).
- Add a note to staging that this should be changed once the cec framework
  is moved out of staging.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/Kconfig                |  2 +-
 drivers/media/Makefile               |  4 +++-
 drivers/staging/media/cec/Kconfig    |  2 +-
 drivers/staging/media/cec/Makefile   |  4 +++-
 drivers/staging/media/cec/TODO       |  5 +++++
 drivers/staging/media/cec/cec-adap.c |  4 ++--
 drivers/staging/media/cec/cec-core.c | 10 +++++-----
 7 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index 052dcf7..962f2a9 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -81,7 +81,7 @@ config MEDIA_RC_SUPPORT
 	  Say Y when you have a TV or an IR device.

 config MEDIA_CEC_EDID
-	tristate
+	bool

 #
 # Media controller
diff --git a/drivers/media/Makefile b/drivers/media/Makefile
index b56f013..081a786 100644
--- a/drivers/media/Makefile
+++ b/drivers/media/Makefile
@@ -2,7 +2,9 @@
 # Makefile for the kernel multimedia device drivers.
 #

-obj-$(CONFIG_MEDIA_CEC_EDID) += cec-edid.o
+ifeq ($(CONFIG_MEDIA_CEC_EDID),y)
+  obj-$(CONFIG_MEDIA_SUPPORT) += cec-edid.o
+endif

 media-objs	:= media-device.o media-devnode.o media-entity.o

diff --git a/drivers/staging/media/cec/Kconfig b/drivers/staging/media/cec/Kconfig
index cd52359..21457a1 100644
--- a/drivers/staging/media/cec/Kconfig
+++ b/drivers/staging/media/cec/Kconfig
@@ -1,5 +1,5 @@
 config MEDIA_CEC
-	tristate "CEC API (EXPERIMENTAL)"
+	bool "CEC API (EXPERIMENTAL)"
 	depends on MEDIA_SUPPORT
 	select MEDIA_CEC_EDID
 	---help---
diff --git a/drivers/staging/media/cec/Makefile b/drivers/staging/media/cec/Makefile
index 426ef73..bd7f3c5 100644
--- a/drivers/staging/media/cec/Makefile
+++ b/drivers/staging/media/cec/Makefile
@@ -1,3 +1,5 @@
 cec-objs := cec-core.o cec-adap.o cec-api.o

-obj-$(CONFIG_MEDIA_CEC) += cec.o
+ifeq ($(CONFIG_MEDIA_CEC),y)
+  obj-$(CONFIG_MEDIA_SUPPORT) += cec.o
+endif
diff --git a/drivers/staging/media/cec/TODO b/drivers/staging/media/cec/TODO
index a8f4b7d..8221d44 100644
--- a/drivers/staging/media/cec/TODO
+++ b/drivers/staging/media/cec/TODO
@@ -23,5 +23,10 @@ Other TODOs:
   And also TYPE_SWITCH and TYPE_CDC_ONLY in addition to the TYPE_UNREGISTERED?
   This should give the framework more information about the device type
   since SPECIFIC and UNREGISTERED give no useful information.
+- Once this is out of staging this should no longer be a separate
+  config option, instead it should be selected by drivers that want it.
+- Revisit the IS_REACHABLE(RC_CORE): perhaps the RC_CORE support should
+  be enabled through a separate config option in drivers/media/Kconfig
+  or rc/Kconfig?

 Hans Verkuil <hans.verkuil@cisco.com>
diff --git a/drivers/staging/media/cec/cec-adap.c b/drivers/staging/media/cec/cec-adap.c
index 307af43..7df6187 100644
--- a/drivers/staging/media/cec/cec-adap.c
+++ b/drivers/staging/media/cec/cec-adap.c
@@ -1456,7 +1456,7 @@ static int cec_receive_notify(struct cec_adapter *adap, struct cec_msg *msg,
 		if (!(adap->capabilities & CEC_CAP_RC))
 			break;

-#if IS_ENABLED(CONFIG_RC_CORE)
+#if IS_REACHABLE(CONFIG_RC_CORE)
 		switch (msg->msg[2]) {
 		/*
 		 * Play function, this message can have variable length
@@ -1492,7 +1492,7 @@ static int cec_receive_notify(struct cec_adapter *adap, struct cec_msg *msg,
 	case CEC_MSG_USER_CONTROL_RELEASED:
 		if (!(adap->capabilities & CEC_CAP_RC))
 			break;
-#if IS_ENABLED(CONFIG_RC_CORE)
+#if IS_REACHABLE(CONFIG_RC_CORE)
 		rc_keyup(adap->rc);
 #endif
 		break;
diff --git a/drivers/staging/media/cec/cec-core.c b/drivers/staging/media/cec/cec-core.c
index 61a1e69..112a5fa 100644
--- a/drivers/staging/media/cec/cec-core.c
+++ b/drivers/staging/media/cec/cec-core.c
@@ -239,7 +239,7 @@ struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
 	if (!(caps & CEC_CAP_RC))
 		return adap;

-#if IS_ENABLED(CONFIG_RC_CORE)
+#if IS_REACHABLE(CONFIG_RC_CORE)
 	/* Prepare the RC input device */
 	adap->rc = rc_allocate_device();
 	if (!adap->rc) {
@@ -282,7 +282,7 @@ int cec_register_adapter(struct cec_adapter *adap)
 	if (IS_ERR_OR_NULL(adap))
 		return 0;

-#if IS_ENABLED(CONFIG_RC_CORE)
+#if IS_REACHABLE(CONFIG_RC_CORE)
 	if (adap->capabilities & CEC_CAP_RC) {
 		res = rc_register_device(adap->rc);

@@ -298,7 +298,7 @@ int cec_register_adapter(struct cec_adapter *adap)

 	res = cec_devnode_register(&adap->devnode, adap->owner);
 	if (res) {
-#if IS_ENABLED(CONFIG_RC_CORE)
+#if IS_REACHABLE(CONFIG_RC_CORE)
 		/* Note: rc_unregister also calls rc_free */
 		rc_unregister_device(adap->rc);
 		adap->rc = NULL;
@@ -333,7 +333,7 @@ void cec_unregister_adapter(struct cec_adapter *adap)
 	if (IS_ERR_OR_NULL(adap))
 		return;

-#if IS_ENABLED(CONFIG_RC_CORE)
+#if IS_REACHABLE(CONFIG_RC_CORE)
 	/* Note: rc_unregister also calls rc_free */
 	rc_unregister_device(adap->rc);
 	adap->rc = NULL;
@@ -353,7 +353,7 @@ void cec_delete_adapter(struct cec_adapter *adap)
 	kthread_stop(adap->kthread);
 	if (adap->kthread_config)
 		kthread_stop(adap->kthread_config);
-#if IS_ENABLED(CONFIG_RC_CORE)
+#if IS_REACHABLE(CONFIG_RC_CORE)
 	if (adap->rc)
 		rc_free_device(adap->rc);
 #endif
-- 
2.8.1

