Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:33348 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751458AbdGWSQj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Jul 2017 14:16:39 -0400
Received: by mail-wr0-f195.google.com with SMTP id y43so15830767wrd.0
        for <linux-media@vger.kernel.org>; Sun, 23 Jul 2017 11:16:39 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: r.scobie@clear.net.nz, jasmin@anw.at, d_spingler@freenet.de,
        Manfred.Knick@t-online.de, rjkm@metzlerbros.de
Subject: [PATCH RESEND 04/14] [media] ddbridge: split I/O related functions off from ddbridge.h
Date: Sun, 23 Jul 2017 20:16:20 +0200
Message-Id: <20170723181630.19526-5-d.scheller.oss@gmail.com>
In-Reply-To: <20170723181630.19526-1-d.scheller.oss@gmail.com>
References: <20170723181630.19526-1-d.scheller.oss@gmail.com>
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
index d12deba635bd..66da4918cd74 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -36,6 +36,7 @@
 
 #include "ddbridge.h"
 #include "ddbridge-regs.h"
+#include "ddbridge-io.h"
 
 #include "tda18271c2dd.h"
 #include "stv6110x.h"
diff --git a/drivers/media/pci/ddbridge/ddbridge-i2c.c b/drivers/media/pci/ddbridge/ddbridge-i2c.c
index 540bbd211c19..3d0aefe05cec 100644
--- a/drivers/media/pci/ddbridge/ddbridge-i2c.c
+++ b/drivers/media/pci/ddbridge/ddbridge-i2c.c
@@ -32,6 +32,7 @@
 
 #include "ddbridge.h"
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
index 8262979b6257..de9da6077ec6 100644
--- a/drivers/media/pci/ddbridge/ddbridge-main.c
+++ b/drivers/media/pci/ddbridge/ddbridge-main.c
@@ -34,6 +34,7 @@
 
 #include "ddbridge.h"
 #include "ddbridge-regs.h"
+#include "ddbridge-io.h"
 
 /****************************************************************************/
 /* module parameters */
diff --git a/drivers/media/pci/ddbridge/ddbridge.h b/drivers/media/pci/ddbridge/ddbridge.h
index 7fe5820a78ff..fa471481a572 100644
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
