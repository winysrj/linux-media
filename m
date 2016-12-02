Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:34609 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751990AbcLBRUW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Dec 2016 12:20:22 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v4l-utils 2/6] ir-ctl: fix rc5x encoding
Date: Fri,  2 Dec 2016 17:20:17 +0000
Message-Id: <1480699221-9267-2-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

6th command bit was missing.

Signed-off-by: Sean Young <sean@mess.org>
---
 utils/ir-ctl/ir-encode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/utils/ir-ctl/ir-encode.c b/utils/ir-ctl/ir-encode.c
index 1bf0ac6..704ce95 100644
--- a/utils/ir-ctl/ir-encode.c
+++ b/utils/ir-ctl/ir-encode.c
@@ -261,7 +261,7 @@ static int rc5_encode(enum rc_proto proto, unsigned scancode, unsigned *buf)
 		add_bits(scancode, 6);
 		break;
 	case RC_PROTO_RC5X:
-		add_bits(!!(scancode & 0x4000), 1);
+		add_bits(!(scancode & 0x4000), 1);
 		add_bits(0, 1);
 		add_bits(scancode >> 16, 5);
 		advance_space(NS_TO_US(rc5_unit * 4));
@@ -350,7 +350,7 @@ static const struct {
 	int (*encode)(enum rc_proto proto, unsigned scancode, unsigned *buf);
 } encoders[RC_PROTO_COUNT] = {
 	[RC_PROTO_RC5] = { "rc5", 0x1f3f, 24, 36000, rc5_encode },
-	[RC_PROTO_RC5X] = { "rc5x", 0x1f3f3f, 40, 36000, rc5_encode },
+	[RC_PROTO_RC5X] = { "rc5x", 0x1f7f3f, 40, 36000, rc5_encode },
 	[RC_PROTO_RC5_SZ] = { "rc5_sz", 0x2fff, 26, 36000, rc5_encode },
 	[RC_PROTO_SONY12] = { "sony12", 0x1f007f, 25, 40000, sony_encode },
 	[RC_PROTO_SONY15] = { "sony15", 0xff007f, 31, 40000, sony_encode },
-- 
2.9.3

