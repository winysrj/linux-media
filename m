Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34619 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932532AbcCQTjc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Mar 2016 15:39:32 -0400
Received: by mail-wm0-f68.google.com with SMTP id p65so1594961wmp.1
        for <linux-media@vger.kernel.org>; Thu, 17 Mar 2016 12:39:31 -0700 (PDT)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH v2] media: rc: reduce size of struct ir_raw_event
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org
Message-ID: <56EB07E1.5030701@gmail.com>
Date: Thu, 17 Mar 2016 20:39:13 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

struct ir_raw_event currently has a size of 12 bytes on most (all?)
architectures. This can be reduced to 8 bytes whilst maintaining
full backwards compatibility.
This saves 2KB in size of struct ir_raw_event_ctrl (as element
kfifo is reduced by 512 * 4 bytes) and it allows to copy the
full struct ir_raw_event with a single 64 bit operation.

Successfully tested with the Nuvoton driver and successfully
compile-tested with the ene_ir driver (as it uses the carrier /
duty_cycle elements).

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
v2:
- don't change type of bit field members
---
 include/media/rc-core.h | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 0f77b3d..f6f55b7 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -215,12 +215,9 @@ enum raw_event_type {
 struct ir_raw_event {
 	union {
 		u32             duration;
-
-		struct {
-			u32     carrier;
-			u8      duty_cycle;
-		};
+		u32             carrier;
 	};
+	u8                      duty_cycle;
 
 	unsigned                pulse:1;
 	unsigned                reset:1;
@@ -228,13 +225,7 @@ struct ir_raw_event {
 	unsigned                carrier_report:1;
 };
 
-#define DEFINE_IR_RAW_EVENT(event) \
-	struct ir_raw_event event = { \
-		{ .duration = 0 } , \
-		.pulse = 0, \
-		.reset = 0, \
-		.timeout = 0, \
-		.carrier_report = 0 }
+#define DEFINE_IR_RAW_EVENT(event) struct ir_raw_event event = {}
 
 static inline void init_ir_raw_event(struct ir_raw_event *ev)
 {
@@ -256,8 +247,7 @@ void ir_raw_event_set_idle(struct rc_dev *dev, bool idle);
 
 static inline void ir_raw_event_reset(struct rc_dev *dev)
 {
-	DEFINE_IR_RAW_EVENT(ev);
-	ev.reset = true;
+	struct ir_raw_event ev = { .reset = true };
 
 	ir_raw_event_store(dev, &ev);
 	ir_raw_event_handle(dev);
-- 
2.7.3


