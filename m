Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:59811 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752135AbcLLLqs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Dec 2016 06:46:48 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v4l-utils] ir-ctl: rc5 command 6th bit missing
Date: Mon, 12 Dec 2016 11:46:46 +0000
Message-Id: <1481543206-8696-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is called extended rc5, not be confused with rc5x_20.

Signed-off-by: Sean Young <sean@mess.org>
---
 utils/ir-ctl/ir-encode.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/utils/ir-ctl/ir-encode.c b/utils/ir-ctl/ir-encode.c
index 9cc8c5d..3863779 100644
--- a/utils/ir-ctl/ir-encode.c
+++ b/utils/ir-ctl/ir-encode.c
@@ -250,7 +250,8 @@ static int rc5_encode(enum rc_proto proto, unsigned scancode, unsigned *buf)
 	default:
 		return 0;
 	case RC_PROTO_RC5:
-		add_bits(2, 2);
+		add_bits(!(scancode & 0x40), 1);
+		add_bits(0, 1);
 		add_bits(scancode >> 8, 5);
 		add_bits(scancode, 6);
 		break;
@@ -349,7 +350,7 @@ static const struct {
 	unsigned carrier;
 	int (*encode)(enum rc_proto proto, unsigned scancode, unsigned *buf);
 } encoders[RC_PROTO_COUNT] = {
-	[RC_PROTO_RC5] = { "rc5", 0x1f3f, 24, 36000, rc5_encode },
+	[RC_PROTO_RC5] = { "rc5", 0x1f7f, 24, 36000, rc5_encode },
 	[RC_PROTO_RC5X_20] = { "rc5x_20", 0x1f7f3f, 40, 36000, rc5_encode },
 	[RC_PROTO_RC5_SZ] = { "rc5_sz", 0x2fff, 26, 36000, rc5_encode },
 	[RC_PROTO_SONY12] = { "sony12", 0x1f007f, 25, 40000, sony_encode },
-- 
2.1.4

