Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:53674 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751376AbcFYNGt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jun 2016 09:06:49 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv19 02/14] cec-edid: add module for EDID CEC helper functions
Date: Sat, 25 Jun 2016 15:06:26 +0200
Message-Id: <1466859998-17640-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1466859998-17640-1-git-send-email-hverkuil@xs4all.nl>
References: <1466859998-17640-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The cec-edid module contains helper functions to find and manipulate
the CEC physical address inside an EDID. Even if the CEC support itself
is disabled, drivers will still need these functions. Which is the
reason this is module is separate from the upcoming CEC framework.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/Kconfig    |   3 +
 drivers/media/Makefile   |   2 +
 drivers/media/cec-edid.c | 168 +++++++++++++++++++++++++++++++++++++++++++++++
 include/media/cec-edid.h | 104 +++++++++++++++++++++++++++++
 4 files changed, 277 insertions(+)
 create mode 100644 drivers/media/cec-edid.c
 create mode 100644 include/media/cec-edid.h

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index a8518fb..052dcf7 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -80,6 +80,9 @@ config MEDIA_RC_SUPPORT
 
 	  Say Y when you have a TV or an IR device.
 
+config MEDIA_CEC_EDID
+	tristate
+
 #
 # Media controller
 #	Selectable only for webcam/grabbers, as other drivers don't use it
diff --git a/drivers/media/Makefile b/drivers/media/Makefile
index e608bbc..b56f013 100644
--- a/drivers/media/Makefile
+++ b/drivers/media/Makefile
@@ -2,6 +2,8 @@
 # Makefile for the kernel multimedia device drivers.
 #
 
+obj-$(CONFIG_MEDIA_CEC_EDID) += cec-edid.o
+
 media-objs	:= media-device.o media-devnode.o media-entity.o
 
 #
diff --git a/drivers/media/cec-edid.c b/drivers/media/cec-edid.c
new file mode 100644
index 0000000..7001824
--- /dev/null
+++ b/drivers/media/cec-edid.c
@@ -0,0 +1,168 @@
+/*
+ * cec-edid - HDMI Consumer Electronics Control EDID & CEC helper functions
+ *
+ * Copyright 2016 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <media/cec-edid.h>
+
+/*
+ * This EDID is expected to be a CEA-861 compliant, which means that there are
+ * at least two blocks and one or more of the extensions blocks are CEA-861
+ * blocks.
+ *
+ * The returned location is guaranteed to be < size - 1.
+ */
+static unsigned int cec_get_edid_spa_location(const u8 *edid, unsigned int size)
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
+				if (tag == 3 && len >= 5 && i + len <= end)
+					return i + 4;
+				i += len + 1;
+			} while (i < end);
+		}
+	}
+	return 0;
+}
+
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
+void cec_set_edid_phys_addr(u8 *edid, unsigned int size, u16 phys_addr)
+{
+	unsigned int loc = cec_get_edid_spa_location(edid, size);
+	u8 sum = 0;
+	unsigned int i;
+
+	if (loc == 0)
+		return;
+	edid[loc] = phys_addr >> 8;
+	edid[loc + 1] = phys_addr & 0xff;
+	loc &= ~0x7f;
+
+	/* update the checksum */
+	for (i = loc; i < loc + 127; i++)
+		sum += edid[i];
+	edid[i] = 256 - sum;
+}
+EXPORT_SYMBOL_GPL(cec_set_edid_phys_addr);
+
+u16 cec_phys_addr_for_input(u16 phys_addr, u8 input)
+{
+	/* Check if input is sane */
+	if (WARN_ON(input == 0 || input > 0xf))
+		return CEC_PHYS_ADDR_INVALID;
+
+	if (phys_addr == 0)
+		return input << 12;
+
+	if ((phys_addr & 0x0fff) == 0)
+		return phys_addr | (input << 8);
+
+	if ((phys_addr & 0x00ff) == 0)
+		return phys_addr | (input << 4);
+
+	if ((phys_addr & 0x000f) == 0)
+		return phys_addr | input;
+
+	/*
+	 * All nibbles are used so no valid physical addresses can be assigned
+	 * to the input.
+	 */
+	return CEC_PHYS_ADDR_INVALID;
+}
+EXPORT_SYMBOL_GPL(cec_phys_addr_for_input);
+
+int cec_phys_addr_validate(u16 phys_addr, u16 *parent, u16 *port)
+{
+	int i;
+
+	if (parent)
+		*parent = phys_addr;
+	if (port)
+		*port = 0;
+	if (phys_addr == CEC_PHYS_ADDR_INVALID)
+		return 0;
+	for (i = 0; i < 16; i += 4)
+		if (phys_addr & (0xf << i))
+			break;
+	if (i == 16)
+		return 0;
+	if (parent)
+		*parent = phys_addr & (0xfff0 << i);
+	if (port)
+		*port = (phys_addr >> i) & 0xf;
+	for (i += 4; i < 16; i += 4)
+		if ((phys_addr & (0xf << i)) == 0)
+			return -EINVAL;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(cec_phys_addr_validate);
+
+MODULE_AUTHOR("Hans Verkuil <hans.verkuil@cisco.com>");
+MODULE_DESCRIPTION("CEC EDID helper functions");
+MODULE_LICENSE("GPL");
diff --git a/include/media/cec-edid.h b/include/media/cec-edid.h
new file mode 100644
index 0000000..bdf731e
--- /dev/null
+++ b/include/media/cec-edid.h
@@ -0,0 +1,104 @@
+/*
+ * cec-edid - HDMI Consumer Electronics Control & EDID helpers
+ *
+ * Copyright 2016 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#ifndef _MEDIA_CEC_EDID_H
+#define _MEDIA_CEC_EDID_H
+
+#include <linux/types.h>
+
+#define CEC_PHYS_ADDR_INVALID		0xffff
+#define cec_phys_addr_exp(pa) \
+	((pa) >> 12), ((pa) >> 8) & 0xf, ((pa) >> 4) & 0xf, (pa) & 0xf
+
+/**
+ * cec_get_edid_phys_addr() - find and return the physical address
+ *
+ * @edid:	pointer to the EDID data
+ * @size:	size in bytes of the EDID data
+ * @offset:	If not %NULL then the location of the physical address
+ *		bytes in the EDID will be returned here. This is set to 0
+ *		if there is no physical address found.
+ *
+ * Return: the physical address or CEC_PHYS_ADDR_INVALID if there is none.
+ */
+u16 cec_get_edid_phys_addr(const u8 *edid, unsigned int size,
+			   unsigned int *offset);
+
+/**
+ * cec_set_edid_phys_addr() - find and set the physical address
+ *
+ * @edid:	pointer to the EDID data
+ * @size:	size in bytes of the EDID data
+ * @phys_addr:	the new physical address
+ *
+ * This function finds the location of the physical address in the EDID
+ * and fills in the given physical address and updates the checksum
+ * at the end of the EDID block. It does nothing if the EDID doesn't
+ * contain a physical address.
+ */
+void cec_set_edid_phys_addr(u8 *edid, unsigned int size, u16 phys_addr);
+
+/**
+ * cec_phys_addr_for_input() - calculate the PA for an input
+ *
+ * @phys_addr:	the physical address of the parent
+ * @input:	the number of the input port, must be between 1 and 15
+ *
+ * This function calculates a new physical address based on the input
+ * port number. For example:
+ *
+ * PA = 0.0.0.0 and input = 2 becomes 2.0.0.0
+ *
+ * PA = 3.0.0.0 and input = 1 becomes 3.1.0.0
+ *
+ * PA = 3.2.1.0 and input = 5 becomes 3.2.1.5
+ *
+ * PA = 3.2.1.3 and input = 5 becomes f.f.f.f since it maxed out the depth.
+ *
+ * Return: the new physical address or CEC_PHYS_ADDR_INVALID.
+ */
+u16 cec_phys_addr_for_input(u16 phys_addr, u8 input);
+
+/**
+ * cec_phys_addr_validate() - validate a physical address from an EDID
+ *
+ * @phys_addr:	the physical address to validate
+ * @parent:	if not %NULL, then this is filled with the parents PA.
+ * @port:	if not %NULL, then this is filled with the input port.
+ *
+ * This validates a physical address as read from an EDID. If the
+ * PA is invalid (such as 1.0.1.0 since '0' is only allowed at the end),
+ * then it will return -EINVAL.
+ *
+ * The parent PA is passed into %parent and the input port is passed into
+ * %port. For example:
+ *
+ * PA = 0.0.0.0: has parent 0.0.0.0 and input port 0.
+ *
+ * PA = 1.0.0.0: has parent 0.0.0.0 and input port 1.
+ *
+ * PA = 3.2.0.0: has parent 3.0.0.0 and input port 2.
+ *
+ * PA = f.f.f.f: has parent f.f.f.f and input port 0.
+ *
+ * Return: 0 if the PA is valid, -EINVAL if not.
+ */
+int cec_phys_addr_validate(u16 phys_addr, u16 *parent, u16 *port);
+
+#endif /* _MEDIA_CEC_EDID_H */
-- 
2.8.1

