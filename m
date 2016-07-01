Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:34657 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752023AbcGAI03 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Jul 2016 04:26:29 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cec: use same build config mode as MEDIA_SUPPORT
Message-ID: <ba5f1692-fe9b-93d0-3666-5bf5df4c251d@xs4all.nl>
Date: Fri, 1 Jul 2016 10:26:18 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The cec framework should not be build as a module if MEDIA_SUPPORT is set to
built-in. Otherwise drivers that are built-in would not be able to reference
the exported cec functions.

So do the same as is done for the media controller in drivers/media/Makefile:
make MEDIA_CEC a bool and use the same build mode as CONFIG_MEDIA_SUPPORT.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Arnd Bergmann <arnd@arndb.de>
---
diff --git a/drivers/staging/media/cec/Kconfig b/drivers/staging/media/cec/Kconfig
index b83b4d8..c623bd3 100644
--- a/drivers/staging/media/cec/Kconfig
+++ b/drivers/staging/media/cec/Kconfig
@@ -1,5 +1,5 @@
 config MEDIA_CEC
-	tristate "CEC API (EXPERIMENTAL)"
+	bool "CEC API (EXPERIMENTAL)"
 	depends on MEDIA_SUPPORT
 	depends on RC_CORE || !RC_CORE
 	select MEDIA_CEC_EDID
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
