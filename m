Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:40630 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030487AbeFSSuY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Jun 2018 14:50:24 -0400
Received: by mail-wr0-f195.google.com with SMTP id l41-v6so688798wre.7
        for <linux-media@vger.kernel.org>; Tue, 19 Jun 2018 11:50:23 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: mchehab@kernel.org, mchehab@s-opensource.com, rjkm@metzlerbros.de,
        mvoelkel@DigitalDevices.de
Cc: linux-media@vger.kernel.org
Subject: [PATCH v3 3/9] [media] ddbridge: header/boilerplate cleanups and cosmetics
Date: Tue, 19 Jun 2018 20:50:10 +0200
Message-Id: <20180619185016.24402-4-d.scheller.oss@gmail.com>
In-Reply-To: <20180619185016.24402-1-d.scheller.oss@gmail.com>
References: <20180619185016.24402-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Cleanup whitespaces and blank lines, remove wrong links to
http://www.gnu.org/copyleft/gpl.html (the driver is licensed under the
terms of GPLv2, but the link points to a copy of the GPLv3), and fix
the filename reference in ddbridge-i2c.h.

Cc: Ralph Metzler <rjkm@metzlerbros.de>
Cc: Manfred Voelkel <mvoelkel@DigitalDevices.de>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-ci.c   | 5 +----
 drivers/media/pci/ddbridge/ddbridge-ci.h   | 5 +----
 drivers/media/pci/ddbridge/ddbridge-core.c | 7 +------
 drivers/media/pci/ddbridge/ddbridge-hw.c   | 3 +--
 drivers/media/pci/ddbridge/ddbridge-hw.h   | 3 +--
 drivers/media/pci/ddbridge/ddbridge-i2c.c  | 3 +--
 drivers/media/pci/ddbridge/ddbridge-i2c.h  | 5 ++---
 drivers/media/pci/ddbridge/ddbridge-io.h   | 3 +--
 drivers/media/pci/ddbridge/ddbridge-main.c | 3 +--
 drivers/media/pci/ddbridge/ddbridge-max.c  | 3 +--
 drivers/media/pci/ddbridge/ddbridge-max.h  | 3 +--
 drivers/media/pci/ddbridge/ddbridge-regs.h | 6 +-----
 drivers/media/pci/ddbridge/ddbridge.h      | 6 +-----
 13 files changed, 14 insertions(+), 41 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-ci.c b/drivers/media/pci/ddbridge/ddbridge-ci.c
index 23b0e7d69e94..21cb7fc216ac 100644
--- a/drivers/media/pci/ddbridge/ddbridge-ci.c
+++ b/drivers/media/pci/ddbridge/ddbridge-ci.c
@@ -12,11 +12,8 @@
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
index c482132692f8..f2fb2b670165 100644
--- a/drivers/media/pci/ddbridge/ddbridge-ci.h
+++ b/drivers/media/pci/ddbridge/ddbridge-ci.h
@@ -12,11 +12,8 @@
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
index 3a8bb652de56..c543e0ee7c76 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -6,19 +6,14 @@
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
index 39c2c1750b05..c8160f523ea1 100644
--- a/drivers/media/pci/ddbridge/ddbridge-hw.c
+++ b/drivers/media/pci/ddbridge/ddbridge-hw.c
@@ -12,9 +12,8 @@
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
index 72fd59e8c7c7..fe4ef7e080a4 100644
--- a/drivers/media/pci/ddbridge/ddbridge-hw.h
+++ b/drivers/media/pci/ddbridge/ddbridge-hw.h
@@ -12,9 +12,8 @@
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
index f7c4a88e3e66..822f9704190b 100644
--- a/drivers/media/pci/ddbridge/ddbridge-i2c.c
+++ b/drivers/media/pci/ddbridge/ddbridge-i2c.c
@@ -12,9 +12,8 @@
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
index 996462e51eab..dbcac5aceb31 100644
--- a/drivers/media/pci/ddbridge/ddbridge-i2c.h
+++ b/drivers/media/pci/ddbridge/ddbridge-i2c.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
- * ddbridge-i2c.c: Digital Devices bridge i2c driver
+ * ddbridge-i2c.h: Digital Devices bridge i2c driver
  *
  * Copyright (C) 2010-2017 Digital Devices GmbH
  *                         Ralph Metzler <rjkm@metzlerbros.de>
@@ -12,9 +12,8 @@
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
index c458df31cc43..77df4f17e9be 100644
--- a/drivers/media/pci/ddbridge/ddbridge-io.h
+++ b/drivers/media/pci/ddbridge/ddbridge-io.h
@@ -12,9 +12,8 @@
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
index 419a30bd9c21..9715886899b7 100644
--- a/drivers/media/pci/ddbridge/ddbridge-main.c
+++ b/drivers/media/pci/ddbridge/ddbridge-main.c
@@ -12,9 +12,8 @@
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  * GNU General Public License for more details.
- *
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
diff --git a/drivers/media/pci/ddbridge/ddbridge-max.c b/drivers/media/pci/ddbridge/ddbridge-max.c
index dc6276b0d10e..5ed44da0e8f9 100644
--- a/drivers/media/pci/ddbridge/ddbridge-max.c
+++ b/drivers/media/pci/ddbridge/ddbridge-max.c
@@ -12,9 +12,8 @@
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
index cff35de3d173..8c3bc9c30f9d 100644
--- a/drivers/media/pci/ddbridge/ddbridge-max.h
+++ b/drivers/media/pci/ddbridge/ddbridge-max.h
@@ -12,9 +12,8 @@
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
index f755ea1a2d9a..f2bb787f831e 100644
--- a/drivers/media/pci/ddbridge/ddbridge-regs.h
+++ b/drivers/media/pci/ddbridge/ddbridge-regs.h
@@ -8,14 +8,10 @@
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
index 867f8d905883..a27a71ca59ac 100644
--- a/drivers/media/pci/ddbridge/ddbridge.h
+++ b/drivers/media/pci/ddbridge/ddbridge.h
@@ -9,14 +9,10 @@
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
2.16.4
