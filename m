Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:43826 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727332AbeIMR7J (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Sep 2018 13:59:09 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/4] cec: make cec_get_edid_spa_location() an inline function
Date: Thu, 13 Sep 2018 14:49:41 +0200
Message-Id: <20180913124944.39863-2-hverkuil@xs4all.nl>
In-Reply-To: <20180913124944.39863-1-hverkuil@xs4all.nl>
References: <20180913124944.39863-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This function is needed by both V4L2 and CEC, so move this to
cec.h as a static inline since there are no obvious shared
modules between the two subsystems.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/cec/cec-edid.c | 60 -------------------------------
 include/media/cec.h          | 70 ++++++++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+), 60 deletions(-)

diff --git a/drivers/media/cec/cec-edid.c b/drivers/media/cec/cec-edid.c
index ec72ac1c0b91..f587e8eaefd8 100644
--- a/drivers/media/cec/cec-edid.c
+++ b/drivers/media/cec/cec-edid.c
@@ -10,66 +10,6 @@
 #include <linux/types.h>
 #include <media/cec.h>
 
-/*
- * This EDID is expected to be a CEA-861 compliant, which means that there are
- * at least two blocks and one or more of the extensions blocks are CEA-861
- * blocks.
- *
- * The returned location is guaranteed to be < size - 1.
- */
-static unsigned int cec_get_edid_spa_location(const u8 *edid, unsigned int size)
-{
-	unsigned int blocks = size / 128;
-	unsigned int block;
-	u8 d;
-
-	/* Sanity check: at least 2 blocks and a multiple of the block size */
-	if (blocks < 2 || size % 128)
-		return 0;
-
-	/*
-	 * If there are fewer extension blocks than the size, then update
-	 * 'blocks'. It is allowed to have more extension blocks than the size,
-	 * since some hardware can only read e.g. 256 bytes of the EDID, even
-	 * though more blocks are present. The first CEA-861 extension block
-	 * should normally be in block 1 anyway.
-	 */
-	if (edid[0x7e] + 1 < blocks)
-		blocks = edid[0x7e] + 1;
-
-	for (block = 1; block < blocks; block++) {
-		unsigned int offset = block * 128;
-
-		/* Skip any non-CEA-861 extension blocks */
-		if (edid[offset] != 0x02 || edid[offset + 1] != 0x03)
-			continue;
-
-		/* search Vendor Specific Data Block (tag 3) */
-		d = edid[offset + 2] & 0x7f;
-		/* Check if there are Data Blocks */
-		if (d <= 4)
-			continue;
-		if (d > 4) {
-			unsigned int i = offset + 4;
-			unsigned int end = offset + d;
-
-			/* Note: 'end' is always < 'size' */
-			do {
-				u8 tag = edid[i] >> 5;
-				u8 len = edid[i] & 0x1f;
-
-				if (tag == 3 && len >= 5 && i + len <= end &&
-				    edid[i + 1] == 0x03 &&
-				    edid[i + 2] == 0x0c &&
-				    edid[i + 3] == 0x00)
-					return i + 4;
-				i += len + 1;
-			} while (i < end);
-		}
-	}
-	return 0;
-}
-
 u16 cec_get_edid_phys_addr(const u8 *edid, unsigned int size,
 			   unsigned int *offset)
 {
diff --git a/include/media/cec.h b/include/media/cec.h
index ff9847f7f99d..603f2fa08f62 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -461,4 +461,74 @@ static inline void cec_phys_addr_invalidate(struct cec_adapter *adap)
 	cec_s_phys_addr(adap, CEC_PHYS_ADDR_INVALID, false);
 }
 
+/**
+ * cec_get_edid_spa_location() - find location of the Source Physical Address
+ *
+ * @edid: the EDID
+ * @size: the size of the EDID
+ *
+ * This EDID is expected to be a CEA-861 compliant, which means that there are
+ * at least two blocks and one or more of the extensions blocks are CEA-861
+ * blocks.
+ *
+ * The returned location is guaranteed to be <= size-2.
+ *
+ * This is an inline function since it is used by both CEC and V4L2.
+ * Ideally this would go in a module shared by both, but it is overkill to do
+ * that for just a single function.
+ */
+static inline unsigned int cec_get_edid_spa_location(const u8 *edid,
+						     unsigned int size)
+{
+	unsigned int blocks = size / 128;
+	unsigned int block;
+	u8 d;
+
+	/* Sanity check: at least 2 blocks and a multiple of the block size */
+	if (blocks < 2 || size % 128)
+		return 0;
+
+	/*
+	 * If there are fewer extension blocks than the size, then update
+	 * 'blocks'. It is allowed to have more extension blocks than the size,
+	 * since some hardware can only read e.g. 256 bytes of the EDID, even
+	 * though more blocks are present. The first CEA-861 extension block
+	 * should normally be in block 1 anyway.
+	 */
+	if (edid[0x7e] + 1 < blocks)
+		blocks = edid[0x7e] + 1;
+
+	for (block = 1; block < blocks; block++) {
+		unsigned int offset = block * 128;
+
+		/* Skip any non-CEA-861 extension blocks */
+		if (edid[offset] != 0x02 || edid[offset + 1] != 0x03)
+			continue;
+
+		/* search Vendor Specific Data Block (tag 3) */
+		d = edid[offset + 2] & 0x7f;
+		/* Check if there are Data Blocks */
+		if (d <= 4)
+			continue;
+		if (d > 4) {
+			unsigned int i = offset + 4;
+			unsigned int end = offset + d;
+
+			/* Note: 'end' is always < 'size' */
+			do {
+				u8 tag = edid[i] >> 5;
+				u8 len = edid[i] & 0x1f;
+
+				if (tag == 3 && len >= 5 && i + len <= end &&
+				    edid[i + 1] == 0x03 &&
+				    edid[i + 2] == 0x0c &&
+				    edid[i + 3] == 0x00)
+					return i + 4;
+				i += len + 1;
+			} while (i < end);
+		}
+	}
+	return 0;
+}
+
 #endif /* _MEDIA_CEC_H */
-- 
2.18.0
