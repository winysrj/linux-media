Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:37744 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030446AbeFSSuW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Jun 2018 14:50:22 -0400
Received: by mail-wr0-f194.google.com with SMTP id d8-v6so702672wro.4
        for <linux-media@vger.kernel.org>; Tue, 19 Jun 2018 11:50:22 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: mchehab@kernel.org, mchehab@s-opensource.com, rjkm@metzlerbros.de,
        mvoelkel@DigitalDevices.de
Cc: linux-media@vger.kernel.org
Subject: [PATCH v3 2/9] [media] ddbridge: add SPDX license identifiers
Date: Tue, 19 Jun 2018 20:50:09 +0200
Message-Id: <20180619185016.24402-3-d.scheller.oss@gmail.com>
In-Reply-To: <20180619185016.24402-1-d.scheller.oss@gmail.com>
References: <20180619185016.24402-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Since the boilerplates and MODULE_LICENSE are now in sync regarding the
used license (GPL v2 only), add a matching GPLv2 SPDX license identifier
to all files of the ddbridge driver.

Cc: Ralph Metzler <rjkm@metzlerbros.de>
Cc: Manfred Voelkel <mvoelkel@DigitalDevices.de>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-ci.c   | 1 +
 drivers/media/pci/ddbridge/ddbridge-ci.h   | 1 +
 drivers/media/pci/ddbridge/ddbridge-core.c | 1 +
 drivers/media/pci/ddbridge/ddbridge-hw.c   | 1 +
 drivers/media/pci/ddbridge/ddbridge-hw.h   | 1 +
 drivers/media/pci/ddbridge/ddbridge-i2c.c  | 1 +
 drivers/media/pci/ddbridge/ddbridge-i2c.h  | 1 +
 drivers/media/pci/ddbridge/ddbridge-io.h   | 1 +
 drivers/media/pci/ddbridge/ddbridge-main.c | 1 +
 drivers/media/pci/ddbridge/ddbridge-max.c  | 1 +
 drivers/media/pci/ddbridge/ddbridge-max.h  | 1 +
 drivers/media/pci/ddbridge/ddbridge-regs.h | 1 +
 drivers/media/pci/ddbridge/ddbridge.h      | 1 +
 13 files changed, 13 insertions(+)

diff --git a/drivers/media/pci/ddbridge/ddbridge-ci.c b/drivers/media/pci/ddbridge/ddbridge-ci.c
index cfe23d02e561..23b0e7d69e94 100644
--- a/drivers/media/pci/ddbridge/ddbridge-ci.c
+++ b/drivers/media/pci/ddbridge/ddbridge-ci.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * ddbridge-ci.c: Digital Devices bridge CI (DuoFlex, CI Bridge) support
  *
diff --git a/drivers/media/pci/ddbridge/ddbridge-ci.h b/drivers/media/pci/ddbridge/ddbridge-ci.h
index 35a39182dd83..c482132692f8 100644
--- a/drivers/media/pci/ddbridge/ddbridge-ci.h
+++ b/drivers/media/pci/ddbridge/ddbridge-ci.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * ddbridge-ci.h: Digital Devices bridge CI (DuoFlex, CI Bridge) support
  *
diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index d5b0d1eaf3ad..3a8bb652de56 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * ddbridge-core.c: Digital Devices bridge core functions
  *
diff --git a/drivers/media/pci/ddbridge/ddbridge-hw.c b/drivers/media/pci/ddbridge/ddbridge-hw.c
index 1d3ee6accdd5..39c2c1750b05 100644
--- a/drivers/media/pci/ddbridge/ddbridge-hw.c
+++ b/drivers/media/pci/ddbridge/ddbridge-hw.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * ddbridge-hw.c: Digital Devices bridge hardware maps
  *
diff --git a/drivers/media/pci/ddbridge/ddbridge-hw.h b/drivers/media/pci/ddbridge/ddbridge-hw.h
index 7c142419419c..72fd59e8c7c7 100644
--- a/drivers/media/pci/ddbridge/ddbridge-hw.h
+++ b/drivers/media/pci/ddbridge/ddbridge-hw.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * ddbridge-hw.h: Digital Devices bridge hardware maps
  *
diff --git a/drivers/media/pci/ddbridge/ddbridge-i2c.c b/drivers/media/pci/ddbridge/ddbridge-i2c.c
index 667340c86ea7..f7c4a88e3e66 100644
--- a/drivers/media/pci/ddbridge/ddbridge-i2c.c
+++ b/drivers/media/pci/ddbridge/ddbridge-i2c.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * ddbridge-i2c.c: Digital Devices bridge i2c driver
  *
diff --git a/drivers/media/pci/ddbridge/ddbridge-i2c.h b/drivers/media/pci/ddbridge/ddbridge-i2c.h
index 7ed220506c05..996462e51eab 100644
--- a/drivers/media/pci/ddbridge/ddbridge-i2c.h
+++ b/drivers/media/pci/ddbridge/ddbridge-i2c.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * ddbridge-i2c.c: Digital Devices bridge i2c driver
  *
diff --git a/drivers/media/pci/ddbridge/ddbridge-io.h b/drivers/media/pci/ddbridge/ddbridge-io.h
index b3646c04f1a7..c458df31cc43 100644
--- a/drivers/media/pci/ddbridge/ddbridge-io.h
+++ b/drivers/media/pci/ddbridge/ddbridge-io.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * ddbridge-io.h: Digital Devices bridge I/O inline functions
  *
diff --git a/drivers/media/pci/ddbridge/ddbridge-main.c b/drivers/media/pci/ddbridge/ddbridge-main.c
index 6f3ea927bde5..419a30bd9c21 100644
--- a/drivers/media/pci/ddbridge/ddbridge-main.c
+++ b/drivers/media/pci/ddbridge/ddbridge-main.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * ddbridge.c: Digital Devices PCIe bridge driver
  *
diff --git a/drivers/media/pci/ddbridge/ddbridge-max.c b/drivers/media/pci/ddbridge/ddbridge-max.c
index 739e4b444cf4..dc6276b0d10e 100644
--- a/drivers/media/pci/ddbridge/ddbridge-max.c
+++ b/drivers/media/pci/ddbridge/ddbridge-max.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * ddbridge-max.c: Digital Devices bridge MAX card support
  *
diff --git a/drivers/media/pci/ddbridge/ddbridge-max.h b/drivers/media/pci/ddbridge/ddbridge-max.h
index 82efc53baa94..cff35de3d173 100644
--- a/drivers/media/pci/ddbridge/ddbridge-max.h
+++ b/drivers/media/pci/ddbridge/ddbridge-max.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * ddbridge-max.h: Digital Devices bridge MAX card support
  *
diff --git a/drivers/media/pci/ddbridge/ddbridge-regs.h b/drivers/media/pci/ddbridge/ddbridge-regs.h
index b978b5991940..f755ea1a2d9a 100644
--- a/drivers/media/pci/ddbridge/ddbridge-regs.h
+++ b/drivers/media/pci/ddbridge/ddbridge-regs.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * ddbridge-regs.h: Digital Devices PCIe bridge driver
  *
diff --git a/drivers/media/pci/ddbridge/ddbridge.h b/drivers/media/pci/ddbridge/ddbridge.h
index a66b1125cc74..867f8d905883 100644
--- a/drivers/media/pci/ddbridge/ddbridge.h
+++ b/drivers/media/pci/ddbridge/ddbridge.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * ddbridge.h: Digital Devices PCIe bridge driver
  *
-- 
2.16.4
