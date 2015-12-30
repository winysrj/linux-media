Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:37519 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749AbbL3MY1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Dec 2015 07:24:27 -0500
Received: by mail-wm0-f51.google.com with SMTP id f206so75936471wmf.0
        for <linux-media@vger.kernel.org>; Wed, 30 Dec 2015 04:24:26 -0800 (PST)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH] media: rc: core: simplify DEFINE_IR_RAW_EVENT
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Message-ID: <5683CCEF.5030306@gmail.com>
Date: Wed, 30 Dec 2015 13:24:15 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DEFINE_IR_RAW_EVENT can be simplified and doesn't provide much benefit
as all elements are initialized to 0. But keep it as it is used in a
lot of places.
duration is the first element of the embedded union and therefore
used for the initialization even if not explicitely mentioned.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 include/media/rc-core.h | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index f649470..91c6633 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -226,13 +226,7 @@ struct ir_raw_event {
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
@@ -254,8 +248,7 @@ void ir_raw_event_set_idle(struct rc_dev *dev, bool idle);
 
 static inline void ir_raw_event_reset(struct rc_dev *dev)
 {
-	DEFINE_IR_RAW_EVENT(ev);
-	ev.reset = true;
+	struct ir_raw_event ev = { .reset = true };
 
 	ir_raw_event_store(dev, &ev);
 	ir_raw_event_handle(dev);
-- 
2.6.4

