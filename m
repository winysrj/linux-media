Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:38075 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751609AbeAEO2O (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 Jan 2018 09:28:14 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
Subject: [PATCH 1/2] media: rc: clean up leader pulse/space for manchester encoding
Date: Fri,  5 Jan 2018 14:28:11 +0000
Message-Id: <20180105142812.6191-1-sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The IR rc6 encoder sends the header using manchester encoding using 0
bits, which causes the following:

UBSAN: Undefined behaviour in drivers/media/rc/rc-ir-raw.c:247:6
shift exponent 4294967295 is too large for 64-bit type 'long long unsigned int'

So, allow the leader code to send a pulse and space and remove the unused
pulse_space_start field.

Cc: Antti Seppälä <a.seppala@gmail.com>
Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-mce_kbd-decoder.c |  2 +-
 drivers/media/rc/ir-rc5-decoder.c     |  9 +++------
 drivers/media/rc/ir-rc6-decoder.c     | 35 ++++++++++-------------------------
 drivers/media/rc/rc-core-priv.h       | 10 +++++-----
 drivers/media/rc/rc-ir-raw.c          | 12 +++++-------
 5 files changed, 24 insertions(+), 44 deletions(-)

diff --git a/drivers/media/rc/ir-mce_kbd-decoder.c b/drivers/media/rc/ir-mce_kbd-decoder.c
index 8cf4cf358052..2a279b3b9c0a 100644
--- a/drivers/media/rc/ir-mce_kbd-decoder.c
+++ b/drivers/media/rc/ir-mce_kbd-decoder.c
@@ -424,7 +424,7 @@ static int ir_mce_kbd_unregister(struct rc_dev *dev)
 }
 
 static const struct ir_raw_timings_manchester ir_mce_kbd_timings = {
-	.leader		= MCIR2_PREFIX_PULSE,
+	.leader_pulse	= MCIR2_PREFIX_PULSE,
 	.invert		= 1,
 	.clock		= MCIR2_UNIT,
 	.trailer_space	= MCIR2_UNIT * 10,
diff --git a/drivers/media/rc/ir-rc5-decoder.c b/drivers/media/rc/ir-rc5-decoder.c
index f589d99245eb..a1d6c955ffc8 100644
--- a/drivers/media/rc/ir-rc5-decoder.c
+++ b/drivers/media/rc/ir-rc5-decoder.c
@@ -173,16 +173,14 @@ static int ir_rc5_decode(struct rc_dev *dev, struct ir_raw_event ev)
 }
 
 static const struct ir_raw_timings_manchester ir_rc5_timings = {
-	.leader			= RC5_UNIT,
-	.pulse_space_start	= 0,
+	.leader_pulse		= RC5_UNIT,
 	.clock			= RC5_UNIT,
 	.trailer_space		= RC5_UNIT * 10,
 };
 
 static const struct ir_raw_timings_manchester ir_rc5x_timings[2] = {
 	{
-		.leader			= RC5_UNIT,
-		.pulse_space_start	= 0,
+		.leader_pulse		= RC5_UNIT,
 		.clock			= RC5_UNIT,
 		.trailer_space		= RC5X_SPACE,
 	},
@@ -193,8 +191,7 @@ static const struct ir_raw_timings_manchester ir_rc5x_timings[2] = {
 };
 
 static const struct ir_raw_timings_manchester ir_rc5_sz_timings = {
-	.leader				= RC5_UNIT,
-	.pulse_space_start		= 0,
+	.leader_pulse			= RC5_UNIT,
 	.clock				= RC5_UNIT,
 	.trailer_space			= RC5_UNIT * 10,
 };
diff --git a/drivers/media/rc/ir-rc6-decoder.c b/drivers/media/rc/ir-rc6-decoder.c
index 665025303c28..422dec08738c 100644
--- a/drivers/media/rc/ir-rc6-decoder.c
+++ b/drivers/media/rc/ir-rc6-decoder.c
@@ -288,13 +288,8 @@ static int ir_rc6_decode(struct rc_dev *dev, struct ir_raw_event ev)
 
 static const struct ir_raw_timings_manchester ir_rc6_timings[4] = {
 	{
-		.leader			= RC6_PREFIX_PULSE,
-		.pulse_space_start	= 0,
-		.clock			= RC6_UNIT,
-		.invert			= 1,
-		.trailer_space		= RC6_PREFIX_SPACE,
-	},
-	{
+		.leader_pulse		= RC6_PREFIX_PULSE,
+		.leader_space		= RC6_PREFIX_SPACE,
 		.clock			= RC6_UNIT,
 		.invert			= 1,
 	},
@@ -329,27 +324,22 @@ static int ir_rc6_encode(enum rc_proto protocol, u32 scancode,
 	struct ir_raw_event *e = events;
 
 	if (protocol == RC_PROTO_RC6_0) {
-		/* Modulate the preamble */
-		ret = ir_raw_gen_manchester(&e, max, &ir_rc6_timings[0], 0, 0);
-		if (ret < 0)
-			return ret;
-
 		/* Modulate the header (Start Bit & Mode-0) */
 		ret = ir_raw_gen_manchester(&e, max - (e - events),
-					    &ir_rc6_timings[1],
-					    RC6_HEADER_NBITS, (1 << 3));
+					    &ir_rc6_timings[0],
+					    RC6_HEADER_NBITS + 1, (1 << 3));
 		if (ret < 0)
 			return ret;
 
 		/* Modulate Trailer Bit */
 		ret = ir_raw_gen_manchester(&e, max - (e - events),
-					    &ir_rc6_timings[2], 1, 0);
+					    &ir_rc6_timings[1], 1, 0);
 		if (ret < 0)
 			return ret;
 
 		/* Modulate rest of the data */
 		ret = ir_raw_gen_manchester(&e, max - (e - events),
-					    &ir_rc6_timings[3], RC6_0_NBITS,
+					    &ir_rc6_timings[2], RC6_0_NBITS,
 					    scancode);
 		if (ret < 0)
 			return ret;
@@ -372,27 +362,22 @@ static int ir_rc6_encode(enum rc_proto protocol, u32 scancode,
 			return -EINVAL;
 		}
 
-		/* Modulate the preamble */
-		ret = ir_raw_gen_manchester(&e, max, &ir_rc6_timings[0], 0, 0);
-		if (ret < 0)
-			return ret;
-
 		/* Modulate the header (Start Bit & Header-version 6 */
 		ret = ir_raw_gen_manchester(&e, max - (e - events),
-					    &ir_rc6_timings[1],
-					    RC6_HEADER_NBITS, (1 << 3 | 6));
+					    &ir_rc6_timings[0],
+					    RC6_HEADER_NBITS + 1, (1 << 3 | 6));
 		if (ret < 0)
 			return ret;
 
 		/* Modulate Trailer Bit */
 		ret = ir_raw_gen_manchester(&e, max - (e - events),
-					    &ir_rc6_timings[2], 1, 0);
+					    &ir_rc6_timings[1], 1, 0);
 		if (ret < 0)
 			return ret;
 
 		/* Modulate rest of the data */
 		ret = ir_raw_gen_manchester(&e, max - (e - events),
-					    &ir_rc6_timings[3],
+					    &ir_rc6_timings[2],
 					    bits,
 					    scancode);
 		if (ret < 0)
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 3c3d2620f0e8..458e9eb2d6a9 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -166,17 +166,17 @@ static inline void init_ir_raw_event_duration(struct ir_raw_event *ev,
 
 /**
  * struct ir_raw_timings_manchester - Manchester coding timings
- * @leader:		duration of leader pulse (if any) 0 if continuing
- *			existing signal (see @pulse_space_start)
- * @pulse_space_start:	1 for starting with pulse (0 for starting with space)
+ * @leader_pulse:	duration of leader pulse (if any) 0 if continuing
+ *			existing signal
+ * @leader_space:	duration of leader space (if any)
  * @clock:		duration of each pulse/space in ns
  * @invert:		if set clock logic is inverted
  *			(0 = space + pulse, 1 = pulse + space)
  * @trailer_space:	duration of trailer space in ns
  */
 struct ir_raw_timings_manchester {
-	unsigned int leader;
-	unsigned int pulse_space_start:1;
+	unsigned int leader_pulse;
+	unsigned int leader_space;
 	unsigned int clock;
 	unsigned int invert:1;
 	unsigned int trailer_space;
diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index 3dabb783a1f0..8500b57923c0 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -246,17 +246,15 @@ int ir_raw_gen_manchester(struct ir_raw_event **ev, unsigned int max,
 
 	i = BIT_ULL(n - 1);
 
-	if (timings->leader) {
+	if (timings->leader_pulse) {
 		if (!max--)
 			return ret;
-		if (timings->pulse_space_start) {
-			init_ir_raw_event_duration((*ev)++, 1, timings->leader);
-
+		init_ir_raw_event_duration((*ev), 1, timings->leader_pulse);
+		if (timings->leader_space) {
 			if (!max--)
 				return ret;
-			init_ir_raw_event_duration((*ev), 0, timings->leader);
-		} else {
-			init_ir_raw_event_duration((*ev), 1, timings->leader);
+			init_ir_raw_event_duration(++(*ev), 0,
+						   timings->leader_space);
 		}
 		i >>= 1;
 	} else {
-- 
2.14.3
