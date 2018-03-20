Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:55942 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751455AbeCTVBm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Mar 2018 17:01:42 -0400
Received: by mail-wm0-f67.google.com with SMTP id t7so6063443wmh.5
        for <linux-media@vger.kernel.org>; Tue, 20 Mar 2018 14:01:42 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: gregkh@linuxfoundation.org, mvoelkel@DigitalDevices.de,
        rjkm@metzlerbros.de, jasmin@anw.at
Subject: [PATCH 5/5] [media] ngene: add SPDX license headers
Date: Tue, 20 Mar 2018 22:01:32 +0100
Message-Id: <20180320210132.7873-6-d.scheller.oss@gmail.com>
In-Reply-To: <20180320210132.7873-1-d.scheller.oss@gmail.com>
References: <20180320210132.7873-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Add SPDX license headers in all ngene driver files and fix MODULE_LICENSE
accordingly.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ngene/Makefile      |  2 +-
 drivers/media/pci/ngene/ngene-cards.c | 10 +++-------
 drivers/media/pci/ngene/ngene-core.c  |  8 ++------
 drivers/media/pci/ngene/ngene-dvb.c   |  8 ++------
 drivers/media/pci/ngene/ngene-i2c.c   |  8 ++------
 drivers/media/pci/ngene/ngene.h       |  7 ++-----
 6 files changed, 12 insertions(+), 31 deletions(-)

diff --git a/drivers/media/pci/ngene/Makefile b/drivers/media/pci/ngene/Makefile
index ec450ad19281..115152c96d50 100644
--- a/drivers/media/pci/ngene/Makefile
+++ b/drivers/media/pci/ngene/Makefile
@@ -1,4 +1,4 @@
-# SPDX-License-Identifier: GPL-2.0
+# SPDX-License-Identifier: GPL-2.0-only
 #
 # Makefile for the nGene device driver
 #
diff --git a/drivers/media/pci/ngene/ngene-cards.c b/drivers/media/pci/ngene/ngene-cards.c
index 65fc8f23ad86..23fb6f33fa49 100644
--- a/drivers/media/pci/ngene/ngene-cards.c
+++ b/drivers/media/pci/ngene/ngene-cards.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * ngene-cards.c: nGene PCIe bridge driver - card specific info
  *
@@ -8,19 +9,14 @@
  *                         support for EEPROM-copying,
  *                         support for new dual DVB-S2 card prototype
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
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
@@ -1265,4 +1261,4 @@ module_exit(module_exit_ngene);
 
 MODULE_DESCRIPTION("nGene");
 MODULE_AUTHOR("Micronas, Ralph Metzler, Manfred Voelkel");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/media/pci/ngene/ngene-core.c b/drivers/media/pci/ngene/ngene-core.c
index 3b9a1bfaf6c0..5da1c2b9732f 100644
--- a/drivers/media/pci/ngene/ngene-core.c
+++ b/drivers/media/pci/ngene/ngene-core.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * ngene.c: nGene PCIe bridge driver
  *
@@ -8,19 +9,14 @@
  *                         support for EEPROM-copying,
  *                         support for new dual DVB-S2 card prototype
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
diff --git a/drivers/media/pci/ngene/ngene-dvb.c b/drivers/media/pci/ngene/ngene-dvb.c
index fee89b9ed9c1..fe250f4d37de 100644
--- a/drivers/media/pci/ngene/ngene-dvb.c
+++ b/drivers/media/pci/ngene/ngene-dvb.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * ngene-dvb.c: nGene PCIe bridge driver - DVB functions
  *
@@ -8,19 +9,14 @@
  *                         support for EEPROM-copying,
  *                         support for new dual DVB-S2 card prototype
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
diff --git a/drivers/media/pci/ngene/ngene-i2c.c b/drivers/media/pci/ngene/ngene-i2c.c
index 092d46c2a3a9..f023a6764dd4 100644
--- a/drivers/media/pci/ngene/ngene-i2c.c
+++ b/drivers/media/pci/ngene/ngene-i2c.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * ngene-i2c.c: nGene PCIe bridge driver i2c functions
  *
@@ -8,19 +9,14 @@
  *                         support for EEPROM-copying,
  *                         support for new dual DVB-S2 card prototype
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
 
 /* FIXME - some of these can probably be removed */
diff --git a/drivers/media/pci/ngene/ngene.h b/drivers/media/pci/ngene/ngene.h
index 01d9f1b58fcb..f1299f81ddf9 100644
--- a/drivers/media/pci/ngene/ngene.h
+++ b/drivers/media/pci/ngene/ngene.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * ngene.h: nGene PCIe bridge driver
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
 
 #ifndef _NGENE_H_
-- 
2.16.1
