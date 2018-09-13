Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:47476 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727391AbeIMR7K (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Sep 2018 13:59:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 4/4] cec: remove cec-edid.c
Date: Thu, 13 Sep 2018 14:49:44 +0200
Message-Id: <20180913124944.39863-5-hverkuil@xs4all.nl>
In-Reply-To: <20180913124944.39863-1-hverkuil@xs4all.nl>
References: <20180913124944.39863-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Move cec_get_edid_phys_addr() to cec-adap.c. It's not worth keeping
a separate source for this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/cec/Makefile   |  2 +-
 drivers/media/cec/cec-adap.c | 13 +++++++++++++
 drivers/media/cec/cec-edid.c | 24 ------------------------
 3 files changed, 14 insertions(+), 25 deletions(-)
 delete mode 100644 drivers/media/cec/cec-edid.c

diff --git a/drivers/media/cec/Makefile b/drivers/media/cec/Makefile
index 29a2ab9e77c5..ad8677d8c896 100644
--- a/drivers/media/cec/Makefile
+++ b/drivers/media/cec/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-cec-objs := cec-core.o cec-adap.o cec-api.o cec-edid.o
+cec-objs := cec-core.o cec-adap.o cec-api.o
 
 ifeq ($(CONFIG_CEC_NOTIFIER),y)
   cec-objs += cec-notifier.o
diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index 030b2602faf0..829878356e1e 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -62,6 +62,19 @@ static unsigned int cec_log_addr2dev(const struct cec_adapter *adap, u8 log_addr
 	return adap->log_addrs.primary_device_type[i < 0 ? 0 : i];
 }
 
+u16 cec_get_edid_phys_addr(const u8 *edid, unsigned int size,
+			   unsigned int *offset)
+{
+	unsigned int loc = cec_get_edid_spa_location(edid, size);
+
+	if (offset)
+		*offset = loc;
+	if (loc == 0)
+		return CEC_PHYS_ADDR_INVALID;
+	return (edid[loc] << 8) | edid[loc + 1];
+}
+EXPORT_SYMBOL_GPL(cec_get_edid_phys_addr);
+
 /*
  * Queue a new event for this filehandle. If ts == 0, then set it
  * to the current time.
diff --git a/drivers/media/cec/cec-edid.c b/drivers/media/cec/cec-edid.c
deleted file mode 100644
index e2f54eec0829..000000000000
--- a/drivers/media/cec/cec-edid.c
+++ /dev/null
@@ -1,24 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * cec-edid - HDMI Consumer Electronics Control EDID & CEC helper functions
- *
- * Copyright 2016 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
- */
-
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/types.h>
-#include <media/cec.h>
-
-u16 cec_get_edid_phys_addr(const u8 *edid, unsigned int size,
-			   unsigned int *offset)
-{
-	unsigned int loc = cec_get_edid_spa_location(edid, size);
-
-	if (offset)
-		*offset = loc;
-	if (loc == 0)
-		return CEC_PHYS_ADDR_INVALID;
-	return (edid[loc] << 8) | edid[loc + 1];
-}
-EXPORT_SYMBOL_GPL(cec_get_edid_phys_addr);
-- 
2.18.0
