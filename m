Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:46439 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751003AbeELLYi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 May 2018 07:24:38 -0400
Received: by mail-wr0-f195.google.com with SMTP id a12-v6so7659129wrn.13
        for <linux-media@vger.kernel.org>; Sat, 12 May 2018 04:24:38 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com, mchehab+samsung@kernel.org
Subject: [PATCH v3 2/3] [media] ddbridge: uAPI header for IOCTL definitions and related data structs
Date: Sat, 12 May 2018 13:24:31 +0200
Message-Id: <20180512112432.30887-3-d.scheller.oss@gmail.com>
In-Reply-To: <20180512112432.30887-1-d.scheller.oss@gmail.com>
References: <20180512112432.30887-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Add a uAPI header to define the IOCTLs and the related data structs used by
ddbridge, which currently are IOCTL_DDB_FLASHIO and IOCTL_DDB_IO. The
header can be included by userspace applications directly to make use of
the IOCTLs, and they even should use this header to keep things matching
with the kernel driver.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 MAINTAINERS                         |  1 +
 include/uapi/linux/ddbridge-ioctl.h | 61 +++++++++++++++++++++++++++++++++++++
 2 files changed, 62 insertions(+)
 create mode 100644 include/uapi/linux/ddbridge-ioctl.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 0a919a84d344..6b7da989fbed 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8710,6 +8710,7 @@ W:	https://linuxtv.org
 T:	git git://linuxtv.org/media_tree.git
 S:	Maintained
 F:	drivers/media/pci/ddbridge/*
+F:	include/uapi/linux/ddbridge-ioctl.h
 
 MEDIA DRIVERS FOR FREESCALE IMX
 M:	Steve Longerbeam <slongerbeam@gmail.com>
diff --git a/include/uapi/linux/ddbridge-ioctl.h b/include/uapi/linux/ddbridge-ioctl.h
new file mode 100644
index 000000000000..5b28a797da41
--- /dev/null
+++ b/include/uapi/linux/ddbridge-ioctl.h
@@ -0,0 +1,61 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * ddbridge-ioctl.h: Digital Devices bridge IOCTL API
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
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __LINUX_DDBRIDGE_IOCTL_H__
+#define __LINUX_DDBRIDGE_IOCTL_H__
+
+#include <linux/compiler.h>
+#include <linux/types.h>
+
+/******************************************************************************/
+
+#define DDB_IOCTL_MAGIC		0xDD
+#define DDB_IOCTL_SEQIDX	0xE0
+
+/* DDB_IOCTL_FLASHIO */
+struct ddb_flashio {
+	/* write_*: userspace -> flash */
+	__user __u8 *write_buf;
+	__u32        write_len;
+	/* read_*: flash -> userspace */
+	__user __u8 *read_buf;
+	__u32        read_len;
+	/* card/addon link */
+	__u32        link;
+};
+
+/* DDB_IOCTL_ID */
+struct ddb_id {
+	/* card/PCI device data, FPGA/regmap info */
+	__u16 vendor;
+	__u16 device;
+	__u16 subvendor;
+	__u16 subdevice;
+	__u32 hw;
+	__u32 regmap;
+};
+
+/* IOCTLs */
+#define DDB_IOCTL_FLASHIO \
+	_IOWR(DDB_IOCTL_MAGIC, (DDB_IOCTL_SEQIDX + 0x00), struct ddb_flashio)
+#define DDB_IOCTL_ID \
+	_IOR(DDB_IOCTL_MAGIC,  (DDB_IOCTL_SEQIDX + 0x03), struct ddb_id)
+
+/******************************************************************************/
+
+#endif /* __LINUX_DDBRIDGE_IOCTL_H__ */
-- 
2.16.1
