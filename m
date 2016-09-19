Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:36599 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753471AbcISWV1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 18:21:27 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH] [media] rc: rc6 decoder should report protocol correctly
Date: Mon, 19 Sep 2016 23:21:22 +0100
Message-Id: <1474323685-16439-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When reporting decoded protocol use the enum rather than the bitmap.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-rc6-decoder.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/ir-rc6-decoder.c b/drivers/media/rc/ir-rc6-decoder.c
index e0e2ede..5cc54c9 100644
--- a/drivers/media/rc/ir-rc6-decoder.c
+++ b/drivers/media/rc/ir-rc6-decoder.c
@@ -248,7 +248,7 @@ again:
 				toggle = 0;
 				break;
 			case 24:
-				protocol = RC_BIT_RC6_6A_24;
+				protocol = RC_TYPE_RC6_6A_24;
 				toggle = 0;
 				break;
 			case 32:
@@ -257,7 +257,7 @@ again:
 					toggle = !!(scancode & RC6_6A_MCE_TOGGLE_MASK);
 					scancode &= ~RC6_6A_MCE_TOGGLE_MASK;
 				} else {
-					protocol = RC_BIT_RC6_6A_32;
+					protocol = RC_TYPE_RC6_6A_32;
 					toggle = 0;
 				}
 				break;
-- 
2.7.4

