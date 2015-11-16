Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:38144 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbbKPTyJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2015 14:54:09 -0500
Received: by wmec201 with SMTP id c201so136406388wme.1
        for <linux-media@vger.kernel.org>; Mon, 16 Nov 2015 11:54:07 -0800 (PST)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 5/8] media: rc: move check whether a protocol is enabled to
 the core
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org,
	=?UTF-8?Q?David_H=c3=a4rdeman?= <david@hardeman.nu>
Message-ID: <564A3412.9090604@gmail.com>
Date: Mon, 16 Nov 2015 20:52:50 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Checking whether a protocol is enabled and calling the related decoder
functions should be done by the rc core, not the protocol handlers.

Properly handle lirc considering that no protocol bit is set for lirc.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/ir-jvc-decoder.c     | 3 ---
 drivers/media/rc/ir-mce_kbd-decoder.c | 3 ---
 drivers/media/rc/ir-nec-decoder.c     | 3 ---
 drivers/media/rc/ir-rc5-decoder.c     | 3 ---
 drivers/media/rc/ir-rc6-decoder.c     | 5 -----
 drivers/media/rc/ir-sanyo-decoder.c   | 3 ---
 drivers/media/rc/ir-sharp-decoder.c   | 3 ---
 drivers/media/rc/ir-sony-decoder.c    | 4 ----
 drivers/media/rc/ir-xmp-decoder.c     | 3 ---
 drivers/media/rc/rc-ir-raw.c          | 4 +++-
 10 files changed, 3 insertions(+), 31 deletions(-)

diff --git a/drivers/media/rc/ir-jvc-decoder.c b/drivers/media/rc/ir-jvc-decoder.c
index 30bcf18..182402f 100644
--- a/drivers/media/rc/ir-jvc-decoder.c
+++ b/drivers/media/rc/ir-jvc-decoder.c
@@ -47,9 +47,6 @@ static int ir_jvc_decode(struct rc_dev *dev, struct ir_raw_event ev)
 {
 	struct jvc_dec *data = &dev->raw->jvc;
 
-	if (!(dev->enabled_protocols & RC_BIT_JVC))
-		return 0;
-
 	if (!is_timing_event(ev)) {
 		if (ev.reset)
 			data->state = STATE_INACTIVE;
diff --git a/drivers/media/rc/ir-mce_kbd-decoder.c b/drivers/media/rc/ir-mce_kbd-decoder.c
index 9f3c9b5..d809862 100644
--- a/drivers/media/rc/ir-mce_kbd-decoder.c
+++ b/drivers/media/rc/ir-mce_kbd-decoder.c
@@ -216,9 +216,6 @@ static int ir_mce_kbd_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	u32 scancode;
 	unsigned long delay;
 
-	if (!(dev->enabled_protocols & RC_BIT_MCE_KBD))
-		return 0;
-
 	if (!is_timing_event(ev)) {
 		if (ev.reset)
 			data->state = STATE_INACTIVE;
diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
index 7b81fec..bea0d1e 100644
--- a/drivers/media/rc/ir-nec-decoder.c
+++ b/drivers/media/rc/ir-nec-decoder.c
@@ -52,9 +52,6 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	u8 address, not_address, command, not_command;
 	bool send_32bits = false;
 
-	if (!(dev->enabled_protocols & RC_BIT_NEC))
-		return 0;
-
 	if (!is_timing_event(ev)) {
 		if (ev.reset)
 			data->state = STATE_INACTIVE;
diff --git a/drivers/media/rc/ir-rc5-decoder.c b/drivers/media/rc/ir-rc5-decoder.c
index 84fa6e9..6ffe776 100644
--- a/drivers/media/rc/ir-rc5-decoder.c
+++ b/drivers/media/rc/ir-rc5-decoder.c
@@ -53,9 +53,6 @@ static int ir_rc5_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	u32 scancode;
 	enum rc_type protocol;
 
-	if (!(dev->enabled_protocols & (RC_BIT_RC5 | RC_BIT_RC5X | RC_BIT_RC5_SZ)))
-		return 0;
-
 	if (!is_timing_event(ev)) {
 		if (ev.reset)
 			data->state = STATE_INACTIVE;
diff --git a/drivers/media/rc/ir-rc6-decoder.c b/drivers/media/rc/ir-rc6-decoder.c
index d16bc67..e0e2ede 100644
--- a/drivers/media/rc/ir-rc6-decoder.c
+++ b/drivers/media/rc/ir-rc6-decoder.c
@@ -90,11 +90,6 @@ static int ir_rc6_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	u8 toggle;
 	enum rc_type protocol;
 
-	if (!(dev->enabled_protocols &
-	      (RC_BIT_RC6_0 | RC_BIT_RC6_6A_20 | RC_BIT_RC6_6A_24 |
-	       RC_BIT_RC6_6A_32 | RC_BIT_RC6_MCE)))
-		return 0;
-
 	if (!is_timing_event(ev)) {
 		if (ev.reset)
 			data->state = STATE_INACTIVE;
diff --git a/drivers/media/rc/ir-sanyo-decoder.c b/drivers/media/rc/ir-sanyo-decoder.c
index ad1dc6a..7331e5e 100644
--- a/drivers/media/rc/ir-sanyo-decoder.c
+++ b/drivers/media/rc/ir-sanyo-decoder.c
@@ -58,9 +58,6 @@ static int ir_sanyo_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	u32 scancode;
 	u8 address, command, not_command;
 
-	if (!(dev->enabled_protocols & RC_BIT_SANYO))
-		return 0;
-
 	if (!is_timing_event(ev)) {
 		if (ev.reset) {
 			IR_dprintk(1, "SANYO event reset received. reset to state 0\n");
diff --git a/drivers/media/rc/ir-sharp-decoder.c b/drivers/media/rc/ir-sharp-decoder.c
index 1f33164..317677f 100644
--- a/drivers/media/rc/ir-sharp-decoder.c
+++ b/drivers/media/rc/ir-sharp-decoder.c
@@ -48,9 +48,6 @@ static int ir_sharp_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	struct sharp_dec *data = &dev->raw->sharp;
 	u32 msg, echo, address, command, scancode;
 
-	if (!(dev->enabled_protocols & RC_BIT_SHARP))
-		return 0;
-
 	if (!is_timing_event(ev)) {
 		if (ev.reset)
 			data->state = STATE_INACTIVE;
diff --git a/drivers/media/rc/ir-sony-decoder.c b/drivers/media/rc/ir-sony-decoder.c
index 58ef06f..baa972c 100644
--- a/drivers/media/rc/ir-sony-decoder.c
+++ b/drivers/media/rc/ir-sony-decoder.c
@@ -46,10 +46,6 @@ static int ir_sony_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	u32 scancode;
 	u8 device, subdevice, function;
 
-	if (!(dev->enabled_protocols &
-	      (RC_BIT_SONY12 | RC_BIT_SONY15 | RC_BIT_SONY20)))
-		return 0;
-
 	if (!is_timing_event(ev)) {
 		if (ev.reset)
 			data->state = STATE_INACTIVE;
diff --git a/drivers/media/rc/ir-xmp-decoder.c b/drivers/media/rc/ir-xmp-decoder.c
index 1017d48..1859619 100644
--- a/drivers/media/rc/ir-xmp-decoder.c
+++ b/drivers/media/rc/ir-xmp-decoder.c
@@ -43,9 +43,6 @@ static int ir_xmp_decode(struct rc_dev *dev, struct ir_raw_event ev)
 {
 	struct xmp_dec *data = &dev->raw->xmp;
 
-	if (!(dev->enabled_protocols & RC_BIT_XMP))
-		return 0;
-
 	if (!is_timing_event(ev)) {
 		if (ev.reset)
 			data->state = STATE_INACTIVE;
diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index 763f8a8..c6433e8 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -59,7 +59,9 @@ static int ir_raw_event_thread(void *data)
 
 		mutex_lock(&ir_raw_handler_lock);
 		list_for_each_entry(handler, &ir_raw_handler_list, list)
-			handler->decode(raw->dev, ev);
+			if (raw->dev->enabled_protocols & handler->protocols ||
+			    !handler->protocols)
+				handler->decode(raw->dev, ev);
 		raw->prev_ev = ev;
 		mutex_unlock(&ir_raw_handler_lock);
 	}
-- 
2.6.2

