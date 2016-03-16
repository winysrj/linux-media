Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:34414 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208AbcCPVSw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Mar 2016 17:18:52 -0400
Received: by mail-wm0-f49.google.com with SMTP id p65so207935133wmp.1
        for <linux-media@vger.kernel.org>; Wed, 16 Mar 2016 14:18:51 -0700 (PDT)
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH] media: rc: reduce size of struct ir_raw_event
Message-ID: <56E9CDAE.2040200@gmail.com>
Date: Wed, 16 Mar 2016 22:18:38 +0100
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
 include/media/rc-core.h | 26 ++++++++------------------
 1 file changed, 8 insertions(+), 18 deletions(-)

diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 0f77b3d..b8f27c9 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -214,27 +214,17 @@ enum raw_event_type {
 
 struct ir_raw_event {
 	union {
-		u32             duration;
-
-		struct {
-			u32     carrier;
-			u8      duty_cycle;
-		};
+		u32	duration;
+		u32	carrier;
 	};
-
-	unsigned                pulse:1;
-	unsigned                reset:1;
-	unsigned                timeout:1;
-	unsigned                carrier_report:1;
+	u8		duty_cycle;
+	u8		pulse:1;
+	u8		reset:1;
+	u8		timeout:1;
+	u8		carrier_report:1;
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
-- 
2.7.3

