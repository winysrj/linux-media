Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:40939 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932334AbcLLVNs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Dec 2016 16:13:48 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v5 03/18] [media] rc: Add scancode validation
Date: Mon, 12 Dec 2016 21:13:44 +0000
Message-Id: <834c150606570ad00582562fc3ecb0ae0bf7662f.1481575826.git.sean@mess.org>
In-Reply-To: <cover.1481575826.git.sean@mess.org>
References: <cover.1481575826.git.sean@mess.org>
In-Reply-To: <cover.1481575826.git.sean@mess.org>
References: <cover.1481575826.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We need to valdiate that scancodes are valid for their protocol; an
incorrect necx scancode could actually be a nec scancode, for example.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/rc-main.c | 71 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 68 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 1ed06a9..33969ab 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -724,6 +724,64 @@ void rc_keydown_notimeout(struct rc_dev *dev, enum rc_type protocol,
 }
 EXPORT_SYMBOL_GPL(rc_keydown_notimeout);
 
+/**
+ * rc_validate_filter() - checks that the scancode and mask are valid and
+ *			  provides sensible defaults
+ * @protocol:	the protocol for the filter
+ * @filter:	the scancode and mask
+ * @return:	0 or -EINVAL if the filter is not valid
+ */
+static int rc_validate_filter(enum rc_type protocol,
+			      struct rc_scancode_filter *filter)
+{
+	static u32 masks[] = {
+		[RC_TYPE_RC5] = 0x1f7f,
+		[RC_TYPE_RC5X] = 0x1f7f3f,
+		[RC_TYPE_RC5_SZ] = 0x2fff,
+		[RC_TYPE_SONY12] = 0x1f007f,
+		[RC_TYPE_SONY15] = 0xff007f,
+		[RC_TYPE_SONY20] = 0x1fff7f,
+		[RC_TYPE_JVC] = 0xffff,
+		[RC_TYPE_NEC] = 0xffff,
+		[RC_TYPE_NECX] = 0xffffff,
+		[RC_TYPE_NEC32] = 0xffffffff,
+		[RC_TYPE_SANYO] = 0x1fffff,
+		[RC_TYPE_RC6_0] = 0xffff,
+		[RC_TYPE_RC6_6A_20] = 0xfffff,
+		[RC_TYPE_RC6_6A_24] = 0xffffff,
+		[RC_TYPE_RC6_6A_32] = 0xffffffff,
+		[RC_TYPE_RC6_MCE] = 0xffffffff,
+		[RC_TYPE_SHARP] = 0x1fff,
+	};
+	u32 s = filter->data;
+
+	switch (protocol) {
+	case RC_TYPE_NECX:
+		if ((((s >> 16) ^ ~(s >> 8)) & 0xff) == 0)
+			return -EINVAL;
+		break;
+	case RC_TYPE_NEC32:
+		if ((((s >> 24) ^ ~(s >> 16)) & 0xff) == 0)
+			return -EINVAL;
+		break;
+	case RC_TYPE_RC6_MCE:
+		if ((s & 0xffff0000) != 0x800f0000)
+			return -EINVAL;
+		break;
+	case RC_TYPE_RC6_6A_32:
+		if ((s & 0xffff0000) == 0x800f0000)
+			return -EINVAL;
+		break;
+	default:
+		break;
+	}
+
+	filter->data &= masks[protocol];
+	filter->mask &= masks[protocol];
+
+	return 0;
+}
+
 int rc_open(struct rc_dev *rdev)
 {
 	int rval = 0;
@@ -1229,11 +1287,18 @@ static ssize_t store_filter(struct device *device,
 		new_filter.data = val;
 
 	if (fattr->type == RC_FILTER_WAKEUP) {
-		/* refuse to set a filter unless a protocol is enabled */
-		if (dev->wakeup_protocol == RC_TYPE_UNKNOWN) {
+		/*
+		 * Refuse to set a filter unless a protocol is enabled
+		 * and the filter is valid for that protocol
+		 */
+		if (dev->wakeup_protocol != RC_TYPE_UNKNOWN)
+			ret = rc_validate_filter(dev->wakeup_protocol,
+						 &new_filter);
+		else
 			ret = -EINVAL;
+
+		if (ret != 0)
 			goto unlock;
-		}
 	}
 
 	if (fattr->type == RC_FILTER_NORMAL && !dev->enabled_protocols &&
-- 
2.9.3

