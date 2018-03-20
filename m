Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:44394 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751455AbeCTVBq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Mar 2018 17:01:46 -0400
Received: by mail-wr0-f194.google.com with SMTP id u46so3122504wrc.11
        for <linux-media@vger.kernel.org>; Tue, 20 Mar 2018 14:01:45 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: gregkh@linuxfoundation.org, mvoelkel@DigitalDevices.de,
        rjkm@metzlerbros.de, jasmin@anw.at
Subject: [PATCH 4/5] [media] ddbridge: add SPDX license headers
Date: Tue, 20 Mar 2018 22:01:31 +0100
Message-Id: <20180320210132.7873-5-d.scheller.oss@gmail.com>
In-Reply-To: <20180320210132.7873-1-d.scheller.oss@gmail.com>
References: <20180320210132.7873-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Add SPDX license headers in all ddbridge driver files and fix
MODULE_LICENSE accordingly. Also, apply some cosmetics to the file
headers.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/Makefile        | 2 +-
 drivers/media/pci/ddbridge/ddbridge-ci.c   | 6 ++----
 drivers/media/pci/ddbridge/ddbridge-ci.h   | 6 ++----
 drivers/media/pci/ddbridge/ddbridge-core.c | 8 ++------
 drivers/media/pci/ddbridge/ddbridge-hw.c   | 4 ++--
 drivers/media/pci/ddbridge/ddbridge-hw.h   | 4 ++--
 drivers/media/pci/ddbridge/ddbridge-i2c.c  | 4 ++--
 drivers/media/pci/ddbridge/ddbridge-i2c.h  | 4 ++--
 drivers/media/pci/ddbridge/ddbridge-io.h   | 4 ++--
 drivers/media/pci/ddbridge/ddbridge-main.c | 8 ++++----
 drivers/media/pci/ddbridge/ddbridge-max.c  | 4 ++--
 drivers/media/pci/ddbridge/ddbridge-max.h  | 4 ++--
 drivers/media/pci/ddbridge/ddbridge-regs.h | 7 ++-----
 drivers/media/pci/ddbridge/ddbridge.h      | 7 ++-----
 14 files changed, 29 insertions(+), 43 deletions(-)

diff --git a/drivers/media/pci/ddbridge/Makefile b/drivers/media/pci/ddbridge/Makefile
index 745b37d07558..c79bbc6d6276 100644
--- a/drivers/media/pci/ddbridge/Makefile
+++ b/drivers/media/pci/ddbridge/Makefile
@@ -1,4 +1,4 @@
-# SPDX-License-Identifier: GPL-2.0
+# SPDX-License-Identifier: GPL-2.0-only
 #
 # Makefile for the ddbridge device driver
 #
diff --git a/drivers/media/pci/ddbridge/ddbridge-ci.c b/drivers/media/pci/ddbridge/ddbridge-ci.c
index cfe23d02e561..99a2d36e93b3 100644
--- a/drivers/media/pci/ddbridge/ddbridge-ci.c
+++ b/drivers/media/pci/ddbridge/ddbridge-ci.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * ddbridge-ci.c: Digital Devices bridge CI (DuoFlex, CI Bridge) support
  *
@@ -11,11 +12,8 @@
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  * GNU General Public License for more details.
- *
- * To obtain the license, point your browser to
- * http://www.gnu.org/copyleft/gpl.html
  */
 
 #include "ddbridge.h"
diff --git a/drivers/media/pci/ddbridge/ddbridge-ci.h b/drivers/media/pci/ddbridge/ddbridge-ci.h
index 35a39182dd83..1458b38d82e7 100644
--- a/drivers/media/pci/ddbridge/ddbridge-ci.h
+++ b/drivers/media/pci/ddbridge/ddbridge-ci.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * ddbridge-ci.h: Digital Devices bridge CI (DuoFlex, CI Bridge) support
  *
@@ -11,11 +12,8 @@
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  * GNU General Public License for more details.
- *
- * To obtain the license, point your browser to
- * http://www.gnu.org/copyleft/gpl.html
  */
 
 #ifndef __DDBRIDGE_CI_H__
diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 90687eff5909..2ec84ca516f1 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * ddbridge-core.c: Digital Devices bridge core functions
  *
@@ -5,19 +6,14 @@
  *                         Marcus Metzler <mocm@metzlerbros.de>
  *                         Ralph Metzler <rjkm@metzlerbros.de>
  *
- *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
  * version 2 only, as published by the Free Software Foundation.
  *
- *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  * GNU General Public License for more details.
- *
- * To obtain the license, point your browser to
- * http://www.gnu.org/copyleft/gpl.html
  */
 
 #include <linux/module.h>
diff --git a/drivers/media/pci/ddbridge/ddbridge-hw.c b/drivers/media/pci/ddbridge/ddbridge-hw.c
index c6d14925e2fc..be3eaf682455 100644
--- a/drivers/media/pci/ddbridge/ddbridge-hw.c
+++ b/drivers/media/pci/ddbridge/ddbridge-hw.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * ddbridge-hw.c: Digital Devices bridge hardware maps
  *
@@ -11,9 +12,8 @@
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  * GNU General Public License for more details.
- *
  */
 
 #include "ddbridge.h"
diff --git a/drivers/media/pci/ddbridge/ddbridge-hw.h b/drivers/media/pci/ddbridge/ddbridge-hw.h
index 7c142419419c..79e76bf293a3 100644
--- a/drivers/media/pci/ddbridge/ddbridge-hw.h
+++ b/drivers/media/pci/ddbridge/ddbridge-hw.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * ddbridge-hw.h: Digital Devices bridge hardware maps
  *
@@ -11,9 +12,8 @@
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  * GNU General Public License for more details.
- *
  */
 
 #ifndef _DDBRIDGE_HW_H_
diff --git a/drivers/media/pci/ddbridge/ddbridge-i2c.c b/drivers/media/pci/ddbridge/ddbridge-i2c.c
index 82a9a0e806fc..e87ae4a1849f 100644
--- a/drivers/media/pci/ddbridge/ddbridge-i2c.c
+++ b/drivers/media/pci/ddbridge/ddbridge-i2c.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * ddbridge-i2c.c: Digital Devices bridge i2c driver
  *
@@ -11,9 +12,8 @@
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  * GNU General Public License for more details.
- *
  */
 
 #include <linux/module.h>
diff --git a/drivers/media/pci/ddbridge/ddbridge-i2c.h b/drivers/media/pci/ddbridge/ddbridge-i2c.h
index 7ed220506c05..8d0d1674cf81 100644
--- a/drivers/media/pci/ddbridge/ddbridge-i2c.h
+++ b/drivers/media/pci/ddbridge/ddbridge-i2c.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * ddbridge-i2c.c: Digital Devices bridge i2c driver
  *
@@ -11,9 +12,8 @@
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  * GNU General Public License for more details.
- *
  */
 
 #ifndef __DDBRIDGE_I2C_H__
diff --git a/drivers/media/pci/ddbridge/ddbridge-io.h b/drivers/media/pci/ddbridge/ddbridge-io.h
index b3646c04f1a7..eaf08fc3b48d 100644
--- a/drivers/media/pci/ddbridge/ddbridge-io.h
+++ b/drivers/media/pci/ddbridge/ddbridge-io.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * ddbridge-io.h: Digital Devices bridge I/O inline functions
  *
@@ -11,9 +12,8 @@
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  * GNU General Public License for more details.
- *
  */
 
 #ifndef __DDBRIDGE_IO_H__
diff --git a/drivers/media/pci/ddbridge/ddbridge-main.c b/drivers/media/pci/ddbridge/ddbridge-main.c
index 26497d6b1395..39e14a9306ad 100644
--- a/drivers/media/pci/ddbridge/ddbridge-main.c
+++ b/drivers/media/pci/ddbridge/ddbridge-main.c
@@ -1,5 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
- * ddbridge.c: Digital Devices PCIe bridge driver
+ * ddbridge-main.c: Digital Devices PCIe bridge driver
  *
  * Copyright (C) 2010-2017 Digital Devices GmbH
  *                         Ralph Metzler <rjkm@metzlerbros.de>
@@ -11,9 +12,8 @@
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  * GNU General Public License for more details.
- *
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
@@ -343,5 +343,5 @@ module_exit(module_exit_ddbridge);
 
 MODULE_DESCRIPTION("Digital Devices PCIe Bridge");
 MODULE_AUTHOR("Ralph and Marcus Metzler, Metzler Brothers Systementwicklung GbR");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
 MODULE_VERSION(DDBRIDGE_VERSION);
diff --git a/drivers/media/pci/ddbridge/ddbridge-max.c b/drivers/media/pci/ddbridge/ddbridge-max.c
index dc6b81488746..e68155e8ddbb 100644
--- a/drivers/media/pci/ddbridge/ddbridge-max.c
+++ b/drivers/media/pci/ddbridge/ddbridge-max.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * ddbridge-max.c: Digital Devices bridge MAX card support
  *
@@ -11,9 +12,8 @@
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  * GNU General Public License for more details.
- *
  */
 
 #include <linux/module.h>
diff --git a/drivers/media/pci/ddbridge/ddbridge-max.h b/drivers/media/pci/ddbridge/ddbridge-max.h
index bf8bf38739f6..429ad662c3fe 100644
--- a/drivers/media/pci/ddbridge/ddbridge-max.h
+++ b/drivers/media/pci/ddbridge/ddbridge-max.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * ddbridge-max.h: Digital Devices bridge MAX card support
  *
@@ -11,9 +12,8 @@
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  * GNU General Public License for more details.
- *
  */
 
 #ifndef _DDBRIDGE_MAX_H_
diff --git a/drivers/media/pci/ddbridge/ddbridge-regs.h b/drivers/media/pci/ddbridge/ddbridge-regs.h
index b978b5991940..abf7a944eea4 100644
--- a/drivers/media/pci/ddbridge/ddbridge-regs.h
+++ b/drivers/media/pci/ddbridge/ddbridge-regs.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * ddbridge-regs.h: Digital Devices PCIe bridge driver
  *
@@ -7,14 +8,10 @@
  * modify it under the terms of the GNU General Public License
  * version 2 only, as published by the Free Software Foundation.
  *
- *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  * GNU General Public License for more details.
- *
- * To obtain the license, point your browser to
- * http://www.gnu.org/copyleft/gpl.html
  */
 
 #ifndef __DDBRIDGE_REGS_H__
diff --git a/drivers/media/pci/ddbridge/ddbridge.h b/drivers/media/pci/ddbridge/ddbridge.h
index f223dc6c9963..0e0ddacd0e80 100644
--- a/drivers/media/pci/ddbridge/ddbridge.h
+++ b/drivers/media/pci/ddbridge/ddbridge.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * ddbridge.h: Digital Devices PCIe bridge driver
  *
@@ -8,14 +9,10 @@
  * modify it under the terms of the GNU General Public License
  * version 2 only, as published by the Free Software Foundation.
  *
- *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  * GNU General Public License for more details.
- *
- * To obtain the license, point your browser to
- * http://www.gnu.org/copyleft/gpl.html
  */
 
 #ifndef _DDBRIDGE_H_
-- 
2.16.1
