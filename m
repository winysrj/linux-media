Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35534 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752697AbbKKXDZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Nov 2015 18:03:25 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: mchehab@osg.samsung.com
Cc: linux-media@vger.kernel.org
Subject: [PATCH 1/1] smiapp: Move include/media/smiapp.h under include/media/i2c
Date: Thu, 12 Nov 2015 01:01:25 +0200
Message-Id: <1447282885-17566-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <413d2bb0b813a7e62867de7a94b0ab61e16cb1cb.1447261977.git.mchehab@osg.samsung.com>
References: <413d2bb0b813a7e62867de7a94b0ab61e16cb1cb.1447261977.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
Hi Mauro,

Your script appears to miss smiapp as it's in a separate directory. Could
you either change the script, or apply this patch, please?

Kind regards,
Sakari

 MAINTAINERS                       | 2 +-
 drivers/media/i2c/smiapp/smiapp.h | 2 +-
 include/media/{ => i2c}/smiapp.h  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)
 rename include/media/{ => i2c}/smiapp.h (98%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 42e81f9..bbeea09 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9614,7 +9614,7 @@ M:	Sakari Ailus <sakari.ailus@iki.fi>
 L:	linux-media@vger.kernel.org
 S:	Maintained
 F:	drivers/media/i2c/smiapp/
-F:	include/media/smiapp.h
+F:	include/media/i2c/smiapp.h
 F:	drivers/media/i2c/smiapp-pll.c
 F:	drivers/media/i2c/smiapp-pll.h
 F:	include/uapi/linux/smiapp.h
diff --git a/drivers/media/i2c/smiapp/smiapp.h b/drivers/media/i2c/smiapp/smiapp.h
index ed010a8..66e34b1 100644
--- a/drivers/media/i2c/smiapp/smiapp.h
+++ b/drivers/media/i2c/smiapp/smiapp.h
@@ -20,9 +20,9 @@
 #define __SMIAPP_PRIV_H_
 
 #include <linux/mutex.h>
+#include <media/i2c/smiapp.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-subdev.h>
-#include <media/smiapp.h>
 
 #include "smiapp-pll.h"
 #include "smiapp-reg.h"
diff --git a/include/media/smiapp.h b/include/media/i2c/smiapp.h
similarity index 98%
rename from include/media/smiapp.h
rename to include/media/i2c/smiapp.h
index 268a3cd..029142d 100644
--- a/include/media/smiapp.h
+++ b/include/media/i2c/smiapp.h
@@ -1,5 +1,5 @@
 /*
- * include/media/smiapp.h
+ * include/media/i2c/smiapp.h
  *
  * Generic driver for SMIA/SMIA++ compliant camera modules
  *
-- 
2.1.4

