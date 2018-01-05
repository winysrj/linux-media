Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:50287 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751731AbeAEO2O (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 Jan 2018 09:28:14 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
Subject: [PATCH 2/2] media: rc: do not remove first bit if leader pulse is present
Date: Fri,  5 Jan 2018 14:28:12 +0000
Message-Id: <20180105142812.6191-2-sean@mess.org>
In-Reply-To: <20180105142812.6191-1-sean@mess.org>
References: <20180105142812.6191-1-sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The rc5 protocol does not have a leading pulse or space, but we encode
the first bit using a single leading pulse. For other protocols, the
leading pulse or space does not represent any bit. So, don't remove the
first bit if a leading pulse is present.

Cc: Antti Seppälä <a.seppala@gmail.com>
Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-mce_kbd-decoder.c |  4 ++--
 drivers/media/rc/ir-rc5-decoder.c     | 13 ++++++++-----
 drivers/media/rc/ir-rc6-decoder.c     |  4 ++--
 drivers/media/rc/rc-ir-raw.c          |  1 -
 4 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/media/rc/ir-mce_kbd-decoder.c b/drivers/media/rc/ir-mce_kbd-decoder.c
index 2a279b3b9c0a..2c3df02e05ff 100644
--- a/drivers/media/rc/ir-mce_kbd-decoder.c
+++ b/drivers/media/rc/ir-mce_kbd-decoder.c
@@ -452,11 +452,11 @@ static int ir_mce_kbd_encode(enum rc_proto protocol, u32 scancode,
 	if (protocol == RC_PROTO_MCIR2_KBD) {
 		raw = scancode |
 		      ((u64)MCIR2_KEYBOARD_HEADER << MCIR2_KEYBOARD_NBITS);
-		len = MCIR2_KEYBOARD_NBITS + MCIR2_HEADER_NBITS + 1;
+		len = MCIR2_KEYBOARD_NBITS + MCIR2_HEADER_NBITS;
 	} else {
 		raw = scancode |
 		      ((u64)MCIR2_MOUSE_HEADER << MCIR2_MOUSE_NBITS);
-		len = MCIR2_MOUSE_NBITS + MCIR2_HEADER_NBITS + 1;
+		len = MCIR2_MOUSE_NBITS + MCIR2_HEADER_NBITS;
 	}
 
 	ret = ir_raw_gen_manchester(&e, max, &ir_mce_kbd_timings, len, raw);
diff --git a/drivers/media/rc/ir-rc5-decoder.c b/drivers/media/rc/ir-rc5-decoder.c
index a1d6c955ffc8..11a28f8772da 100644
--- a/drivers/media/rc/ir-rc5-decoder.c
+++ b/drivers/media/rc/ir-rc5-decoder.c
@@ -225,9 +225,9 @@ static int ir_rc5_encode(enum rc_proto protocol, u32 scancode,
 		/* encode data */
 		data = !commandx << 12 | system << 6 | command;
 
-		/* Modulate the data */
+		/* First bit is encoded by leader_pulse */
 		ret = ir_raw_gen_manchester(&e, max, &ir_rc5_timings,
-					    RC5_NBITS, data);
+					    RC5_NBITS - 1, data);
 		if (ret < 0)
 			return ret;
 	} else if (protocol == RC_PROTO_RC5X_20) {
@@ -240,10 +240,11 @@ static int ir_rc5_encode(enum rc_proto protocol, u32 scancode,
 		/* encode data */
 		data = commandx << 18 | system << 12 | command << 6 | xdata;
 
-		/* Modulate the data */
+		/* First bit is encoded by leader_pulse */
 		pre_space_data = data >> (RC5X_NBITS - CHECK_RC5X_NBITS);
 		ret = ir_raw_gen_manchester(&e, max, &ir_rc5x_timings[0],
-					    CHECK_RC5X_NBITS, pre_space_data);
+					    CHECK_RC5X_NBITS - 1,
+					    pre_space_data);
 		if (ret < 0)
 			return ret;
 		ret = ir_raw_gen_manchester(&e, max - (e - events),
@@ -254,8 +255,10 @@ static int ir_rc5_encode(enum rc_proto protocol, u32 scancode,
 			return ret;
 	} else if (protocol == RC_PROTO_RC5_SZ) {
 		/* RC5-SZ scancode is raw enough for Manchester as it is */
+		/* First bit is encoded by leader_pulse */
 		ret = ir_raw_gen_manchester(&e, max, &ir_rc5_sz_timings,
-					    RC5_SZ_NBITS, scancode & 0x2fff);
+					    RC5_SZ_NBITS - 1,
+					    scancode & 0x2fff);
 		if (ret < 0)
 			return ret;
 	} else {
diff --git a/drivers/media/rc/ir-rc6-decoder.c b/drivers/media/rc/ir-rc6-decoder.c
index 422dec08738c..55bb19bbd4e9 100644
--- a/drivers/media/rc/ir-rc6-decoder.c
+++ b/drivers/media/rc/ir-rc6-decoder.c
@@ -327,7 +327,7 @@ static int ir_rc6_encode(enum rc_proto protocol, u32 scancode,
 		/* Modulate the header (Start Bit & Mode-0) */
 		ret = ir_raw_gen_manchester(&e, max - (e - events),
 					    &ir_rc6_timings[0],
-					    RC6_HEADER_NBITS + 1, (1 << 3));
+					    RC6_HEADER_NBITS, (1 << 3));
 		if (ret < 0)
 			return ret;
 
@@ -365,7 +365,7 @@ static int ir_rc6_encode(enum rc_proto protocol, u32 scancode,
 		/* Modulate the header (Start Bit & Header-version 6 */
 		ret = ir_raw_gen_manchester(&e, max - (e - events),
 					    &ir_rc6_timings[0],
-					    RC6_HEADER_NBITS + 1, (1 << 3 | 6));
+					    RC6_HEADER_NBITS, (1 << 3 | 6));
 		if (ret < 0)
 			return ret;
 
diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index 8500b57923c0..18504870b9f0 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -256,7 +256,6 @@ int ir_raw_gen_manchester(struct ir_raw_event **ev, unsigned int max,
 			init_ir_raw_event_duration(++(*ev), 0,
 						   timings->leader_space);
 		}
-		i >>= 1;
 	} else {
 		/* continue existing signal */
 		--(*ev);
-- 
2.14.3
