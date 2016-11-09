Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:48973 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753217AbcKIQNi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 Nov 2016 11:13:38 -0500
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH] [media] nec decoder: wrong bit order for nec32 protocol
Date: Wed,  9 Nov 2016 16:13:35 +0000
Message-Id: <1478708015-1164-5-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The bits are sent in lsb first. Hardware decoders also send nec32
in this order (e.g. dib0700). This should be consistent, however
I have no way of knowing which order the LME2510 and Tivo keymaps
are (the only two kernel keymaps with NEC32).

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-nec-decoder.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
index 2a9d155..ba02d05 100644
--- a/drivers/media/rc/ir-nec-decoder.c
+++ b/drivers/media/rc/ir-nec-decoder.c
@@ -170,7 +170,10 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		if (send_32bits) {
 			/* NEC transport, but modified protocol, used by at
 			 * least Apple and TiVo remotes */
-			scancode = data->bits;
+			scancode = address     << 24 |
+				   not_address << 16 |
+				   command     << 8 |
+				   not_command;
 			IR_dprintk(1, "NEC (modified) scancode 0x%08x\n", scancode);
 			rc_type = RC_TYPE_NEC32;
 		} else if ((address ^ not_address) != 0xff) {
-- 
2.7.4

