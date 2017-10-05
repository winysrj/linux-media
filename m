Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:43957 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751315AbdJEIpm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Oct 2017 04:45:42 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 25/25] media: rc: nec decoder should not send both repeat and keycode
Date: Thu,  5 Oct 2017 09:45:27 +0100
Message-Id: <6d33ad5b3ff8ce55b07e8c3689e62c2aa791b10f.1507192752.git.sean@mess.org>
In-Reply-To: <88e30a50734f7d132ac8a6234acc7335cbbb3a56.1507192751.git.sean@mess.org>
References: <88e30a50734f7d132ac8a6234acc7335cbbb3a56.1507192751.git.sean@mess.org>
In-Reply-To: <cover.1507192751.git.sean@mess.org>
References: <cover.1507192751.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When receiving an nec repeat, rc_repeat() is called and then rc_keydown()
with the last decoded scancode. That last call is redundant.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-nec-decoder.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
index 5380a9b23c07..4ace5648866d 100644
--- a/drivers/media/rc/ir-nec-decoder.c
+++ b/drivers/media/rc/ir-nec-decoder.c
@@ -87,8 +87,6 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			data->state = STATE_BIT_PULSE;
 			return 0;
 		} else if (eq_margin(ev.duration, NEC_REPEAT_SPACE, NEC_UNIT / 2)) {
-			rc_repeat(dev);
-			IR_dprintk(1, "Repeat last key\n");
 			data->state = STATE_TRAILER_PULSE;
 			return 0;
 		}
@@ -151,19 +149,26 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		if (!geq_margin(ev.duration, NEC_TRAILER_SPACE, NEC_UNIT / 2))
 			break;
 
-		address     = bitrev8((data->bits >> 24) & 0xff);
-		not_address = bitrev8((data->bits >> 16) & 0xff);
-		command	    = bitrev8((data->bits >>  8) & 0xff);
-		not_command = bitrev8((data->bits >>  0) & 0xff);
+		if (data->count == NEC_NBITS) {
+			address     = bitrev8((data->bits >> 24) & 0xff);
+			not_address = bitrev8((data->bits >> 16) & 0xff);
+			command	    = bitrev8((data->bits >>  8) & 0xff);
+			not_command = bitrev8((data->bits >>  0) & 0xff);
+
+			scancode = ir_nec_bytes_to_scancode(address,
+							    not_address,
+							    command,
+							    not_command,
+							    &rc_proto);
 
-		scancode = ir_nec_bytes_to_scancode(address, not_address,
-						    command, not_command,
-						    &rc_proto);
+			if (data->is_nec_x)
+				data->necx_repeat = true;
 
-		if (data->is_nec_x)
-			data->necx_repeat = true;
+			rc_keydown(dev, rc_proto, scancode, 0);
+		} else {
+			rc_repeat(dev);
+		}
 
-		rc_keydown(dev, rc_proto, scancode, 0);
 		data->state = STATE_INACTIVE;
 		return 0;
 	}
-- 
2.13.6
