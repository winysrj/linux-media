Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:45327 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753082AbcKIQNi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 Nov 2016 11:13:38 -0500
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH] [media] sanyo decoder: address was being truncated
Date: Wed,  9 Nov 2016 16:13:34 +0000
Message-Id: <1478708015-1164-4-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The address is 13 bits but it was stuffed in an u8, so 5 bits are
missing from the scancode.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-sanyo-decoder.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/ir-sanyo-decoder.c b/drivers/media/rc/ir-sanyo-decoder.c
index 7331e5e7..b07d9ca 100644
--- a/drivers/media/rc/ir-sanyo-decoder.c
+++ b/drivers/media/rc/ir-sanyo-decoder.c
@@ -56,7 +56,8 @@ static int ir_sanyo_decode(struct rc_dev *dev, struct ir_raw_event ev)
 {
 	struct sanyo_dec *data = &dev->raw->sanyo;
 	u32 scancode;
-	u8 address, command, not_command;
+	u16 address;
+	u8 command, not_command;
 
 	if (!is_timing_event(ev)) {
 		if (ev.reset) {
-- 
2.7.4

