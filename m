Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33725 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751352AbdJOUwF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 15 Oct 2017 16:52:05 -0400
Received: by mail-wm0-f66.google.com with SMTP id u138so6186474wmu.0
        for <linux-media@vger.kernel.org>; Sun, 15 Oct 2017 13:52:04 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, rjkm@metzlerbros.de
Subject: [PATCH 5/8] [media] ddbridge/max: rename ddbridge-maxs8.[c|h] to ddbridge-max.[c|h]
Date: Sun, 15 Oct 2017 22:51:54 +0200
Message-Id: <20171015205157.14342-6-d.scheller.oss@gmail.com>
In-Reply-To: <20171015205157.14342-1-d.scheller.oss@gmail.com>
References: <20171015205157.14342-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Rename the MaxS4/8 support files following upstream. References to these
files and descriptions have been updated aswell.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/Makefile                             | 2 +-
 drivers/media/pci/ddbridge/ddbridge-core.c                      | 2 +-
 drivers/media/pci/ddbridge/{ddbridge-maxs8.c => ddbridge-max.c} | 4 ++--
 drivers/media/pci/ddbridge/{ddbridge-maxs8.h => ddbridge-max.h} | 8 ++++----
 4 files changed, 8 insertions(+), 8 deletions(-)
 rename drivers/media/pci/ddbridge/{ddbridge-maxs8.c => ddbridge-max.c} (99%)
 rename drivers/media/pci/ddbridge/{ddbridge-maxs8.h => ddbridge-max.h} (85%)

diff --git a/drivers/media/pci/ddbridge/Makefile b/drivers/media/pci/ddbridge/Makefile
index 00e89b6a0328..222045703020 100644
--- a/drivers/media/pci/ddbridge/Makefile
+++ b/drivers/media/pci/ddbridge/Makefile
@@ -3,7 +3,7 @@
 #
 
 ddbridge-objs := ddbridge-main.o ddbridge-core.o ddbridge-ci.o \
-		ddbridge-hw.o ddbridge-i2c.o ddbridge-maxs8.o
+		ddbridge-hw.o ddbridge-i2c.o ddbridge-max.o
 
 obj-$(CONFIG_DVB_DDBRIDGE) += ddbridge.o
 
diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 6354e00f4c9b..e2e793b749f2 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -37,7 +37,7 @@
 #include "ddbridge.h"
 #include "ddbridge-i2c.h"
 #include "ddbridge-regs.h"
-#include "ddbridge-maxs8.h"
+#include "ddbridge-max.h"
 #include "ddbridge-ci.h"
 #include "ddbridge-io.h"
 
diff --git a/drivers/media/pci/ddbridge/ddbridge-maxs8.c b/drivers/media/pci/ddbridge/ddbridge-max.c
similarity index 99%
rename from drivers/media/pci/ddbridge/ddbridge-maxs8.c
rename to drivers/media/pci/ddbridge/ddbridge-max.c
index 06d57a4772fa..67ab4e300a36 100644
--- a/drivers/media/pci/ddbridge/ddbridge-maxs8.c
+++ b/drivers/media/pci/ddbridge/ddbridge-max.c
@@ -1,5 +1,5 @@
 /*
- * ddbridge-maxs8.c: Digital Devices bridge MaxS4/8 support
+ * ddbridge-max.c: Digital Devices bridge MAX card support
  *
  * Copyright (C) 2010-2017 Digital Devices GmbH
  *                         Ralph Metzler <rjkm@metzlerbros.de>
@@ -34,7 +34,7 @@
 #include "ddbridge-regs.h"
 #include "ddbridge-io.h"
 
-#include "ddbridge-maxs8.h"
+#include "ddbridge-max.h"
 #include "mxl5xx.h"
 
 /******************************************************************************/
diff --git a/drivers/media/pci/ddbridge/ddbridge-maxs8.h b/drivers/media/pci/ddbridge/ddbridge-max.h
similarity index 85%
rename from drivers/media/pci/ddbridge/ddbridge-maxs8.h
rename to drivers/media/pci/ddbridge/ddbridge-max.h
index bb8884811a46..b1bfbbea4337 100644
--- a/drivers/media/pci/ddbridge/ddbridge-maxs8.h
+++ b/drivers/media/pci/ddbridge/ddbridge-max.h
@@ -1,5 +1,5 @@
 /*
- * ddbridge-maxs8.h: Digital Devices bridge MaxS4/8 support
+ * ddbridge-max.h: Digital Devices bridge MAX card support
  *
  * Copyright (C) 2010-2017 Digital Devices GmbH
  *                         Ralph Metzler <rjkm@metzlerbros.de>
@@ -16,8 +16,8 @@
  *
  */
 
-#ifndef _DDBRIDGE_MAXS8_H_
-#define _DDBRIDGE_MAXS8_H_
+#ifndef _DDBRIDGE_MAX_H_
+#define _DDBRIDGE_MAX_H_
 
 #include "ddbridge.h"
 
@@ -26,4 +26,4 @@
 int lnb_init_fmode(struct ddb *dev, struct ddb_link *link, u32 fm);
 int fe_attach_mxl5xx(struct ddb_input *input);
 
-#endif /* _DDBRIDGE_MAXS8_H */
+#endif /* _DDBRIDGE_MAX_H */
-- 
2.13.6
