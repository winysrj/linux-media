Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:55953 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751913AbdHGUVC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Aug 2017 16:21:02 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 4/6] [media] rc: ensure we do not read out of bounds
Date: Mon,  7 Aug 2017 21:20:57 +0100
Message-Id: <c99b2994f221a43abd2de772c29fb7b3a52813ac.1502137028.git.sean@mess.org>
In-Reply-To: <cover.1502137028.git.sean@mess.org>
References: <cover.1502137028.git.sean@mess.org>
In-Reply-To: <cover.1502137028.git.sean@mess.org>
References: <cover.1502137028.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If rc_validate_filter() is called for CEC or XMP, then we would read
beyond the end of the array.

Suggested-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/rc-main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index f306e67b8b66..7aaf28bcb01e 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -733,7 +733,7 @@ EXPORT_SYMBOL_GPL(rc_keydown_notimeout);
 static int rc_validate_filter(struct rc_dev *dev,
 			      struct rc_scancode_filter *filter)
 {
-	static u32 masks[] = {
+	static const u32 masks[] = {
 		[RC_TYPE_RC5] = 0x1f7f,
 		[RC_TYPE_RC5X_20] = 0x1f7f3f,
 		[RC_TYPE_RC5_SZ] = 0x2fff,
@@ -757,6 +757,9 @@ static int rc_validate_filter(struct rc_dev *dev,
 	u32 s = filter->data;
 	enum rc_type protocol = dev->wakeup_protocol;
 
+	if (protocol >= ARRAY_SIZE(masks))
+		return -EINVAL;
+
 	switch (protocol) {
 	case RC_TYPE_NECX:
 		if ((((s >> 16) ^ ~(s >> 8)) & 0xff) == 0)
-- 
2.13.4
