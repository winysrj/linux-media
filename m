Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:38173 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751904AbdHIUbf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Aug 2017 16:31:35 -0400
Received: by mail-wr0-f193.google.com with SMTP id g32so5184283wrd.5
        for <linux-media@vger.kernel.org>; Wed, 09 Aug 2017 13:31:35 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: r.scobie@clear.net.nz, jasmin@anw.at, d_spingler@freenet.de,
        Manfred.Knick@t-online.de, rjkm@metzlerbros.de
Subject: [PATCH v3 02/12] [media] ddbridge: split I/O related functions off from ddbridge.h
Date: Wed,  9 Aug 2017 22:31:18 +0200
Message-Id: <20170809203128.31476-3-d.scheller.oss@gmail.com>
In-Reply-To: <20170809203128.31476-1-d.scheller.oss@gmail.com>
References: <20170809203128.31476-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

While it seems valid that headers can carry simple oneline static inline
annotated functions, move them into their own header file to have the
overall code more readable. Also, keep them as header (and don't put in
a separate object) and static inline to help the compiler avoid
generating function calls.

(Thanks to Jasmin J. <jasmin@anw.at> for valuable input on this!)

Cc: Jasmin J. <jasmin@anw.at>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
Tested-by: Richard Scobie <r.scobie@clear.net.nz>
Tested-by: Jasmin Jessich <jasmin@anw.at>
Tested-by: Dietmar Spingler <d_spingler@freenet.de>
Tested-by: Manfred Knick <Manfred.Knick@t-online.de>
---
 drivers/media/pci/ddbridge/ddbridge-core.c |  1 +
 drivers/media/pci/ddbridge/ddbridge-i2c.c  |  1 +
 drivers/media/pci/ddbridge/ddbridge-io.h   | 71 ++++++++++++++++++++++++++++++
 drivers/media/pci/ddbridge/ddbridge-main.c |  1 +
 drivers/media/pci/ddbridge/ddbridge.h      | 43 ------------------
 5 files changed, 74 insertions(+), 43 deletions(-)
 create mode 100644 drivers/media/pci/ddbridge/ddbridge-io.h

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 9d28448524de..177775d7be4d 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -37,6 +37,7 @@
 #include "ddbridge.h"
 #include "ddbridge-i2c.h"
 #include "ddbridge-regs.h"
+#include "ddbridge-io.h"
 
 #include "tda18271c2dd.h"
 #include "stv6110x.h"
diff --git a/drivers/media/pci/ddbridge/ddbridge-i2c.c b/drivers/media/pci/ddbridge/ddbridge-i2c.c
index 376d8a7ca0b9..3d4fafb5db27 100644
--- a/drivers/media/pci/ddbridge/ddbridge-i2c.c
+++ b/drivers/media/pci/ddbridge/ddbridge-i2c.c
@@ -33,6 +33,7 @@
 #include "ddbridge.h"
 #include "ddbridge-i2c.h"
 #include "ddbridge-regs.h"
+#include "ddbridge-io.h"
 
 /******************************************************************************/
 
diff --git a/drivers/media/pci/ddbridge/ddbridge-io.h b/drivers/media/pci/ddbridge/ddbridge-io.h
new file mode 100644
index 000000000000..ce92e9484075
--- /dev/null
+++ b/drivers/media/pci/ddbridge/ddbridge-io.h
@@ -0,0 +1,71 @@
+/*
+ * ddbridge-io.h: Digital Devices bridge I/O inline functions
+ *
+ * Copyright (C) 2010-2017 Digital Devices GmbH
+ *                         Ralph Metzler <rjkm@metzlerbros.de>
+ *                         Marcus Metzler <mocm@metzlerbros.de>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 only, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef __DDBRIDGE_IO_H__
+#define __DDBRIDGE_IO_H__
+
+#include <linux/io.h>
+
+#include "ddbridge.h"
+
+/******************************************************************************/
+
+static inline u32 ddblreadl(struct ddb_link *link, u32 adr)
+{
+	return readl((char *) (link->dev->regs + (adr)));
+}
+
+static inline void ddblwritel(struct ddb_link *link, u32 val, u32 adr)
+{
+	writel(val, (char *) (link->dev->regs + (adr)));
+}
+
+static inline u32 ddbreadl(struct ddb *dev, u32 adr)
+{
+	return readl((char *) (dev->regs + (adr)));
+}
+
+static inline void ddbwritel(struct ddb *dev, u32 val, u32 adr)
+{
+	writel(val, (char *) (dev->regs + (adr)));
+}
+
+static inline void ddbcpyto(struct ddb *dev, u32 adr, void *src, long count)
+{
+	return memcpy_toio((char *) (dev->regs + adr), src, count);
+}
+
+static inline void ddbcpyfrom(struct ddb *dev, void *dst, u32 adr, long count)
+{
+	return memcpy_fromio(dst, (char *) (dev->regs + adr), count);
+}
+
+static inline u32 safe_ddbreadl(struct ddb *dev, u32 adr)
+{
+	u32 val = ddbreadl(dev, adr);
+
+	/* (ddb)readl returns (uint)-1 (all bits set) on failure, catch that */
+	if (val == ~0) {
+		dev_err(&dev->pdev->dev, "ddbreadl failure, adr=%08x\n", adr);
+		return 0;
+	}
+
+	return val;
+}
+
+#endif /* __DDBRIDGE_IO_H__ */
diff --git a/drivers/media/pci/ddbridge/ddbridge-main.c b/drivers/media/pci/ddbridge/ddbridge-main.c
index dde938ad1247..5332fd89f359 100644
--- a/drivers/media/pci/ddbridge/ddbridge-main.c
+++ b/drivers/media/pci/ddbridge/ddbridge-main.c
@@ -35,6 +35,7 @@
 #include "ddbridge.h"
 #include "ddbridge-i2c.h"
 #include "ddbridge-regs.h"
+#include "ddbridge-io.h"
 
 /****************************************************************************/
 /* module parameters */
diff --git a/drivers/media/pci/ddbridge/ddbridge.h b/drivers/media/pci/ddbridge/ddbridge.h
index ab6364ae0711..3790fd8465a4 100644
--- a/drivers/media/pci/ddbridge/ddbridge.h
+++ b/drivers/media/pci/ddbridge/ddbridge.h
@@ -353,49 +353,6 @@ struct ddb {
 	u8                     tsbuf[TS_CAPTURE_LEN];
 };
 
-static inline u32 ddblreadl(struct ddb_link *link, u32 adr)
-{
-	return readl((char *) (link->dev->regs + (adr)));
-}
-
-static inline void ddblwritel(struct ddb_link *link, u32 val, u32 adr)
-{
-	writel(val, (char *) (link->dev->regs + (adr)));
-}
-
-static inline u32 ddbreadl(struct ddb *dev, u32 adr)
-{
-	return readl((char *) (dev->regs + (adr)));
-}
-
-static inline void ddbwritel(struct ddb *dev, u32 val, u32 adr)
-{
-	writel(val, (char *) (dev->regs + (adr)));
-}
-
-static inline void ddbcpyto(struct ddb *dev, u32 adr, void *src, long count)
-{
-	return memcpy_toio((char *) (dev->regs + adr), src, count);
-}
-
-static inline void ddbcpyfrom(struct ddb *dev, void *dst, u32 adr, long count)
-{
-	return memcpy_fromio(dst, (char *) (dev->regs + adr), count);
-}
-
-static inline u32 safe_ddbreadl(struct ddb *dev, u32 adr)
-{
-	u32 val = ddbreadl(dev, adr);
-
-	/* (ddb)readl returns (uint)-1 (all bits set) on failure, catch that */
-	if (val == ~0) {
-		dev_err(&dev->pdev->dev, "ddbreadl failure, adr=%08x\n", adr);
-		return 0;
-	}
-
-	return val;
-}
-
 /****************************************************************************/
 /****************************************************************************/
 /****************************************************************************/
-- 
2.13.0
