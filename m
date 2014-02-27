Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48958 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbaB0Qo7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Feb 2014 11:44:59 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: prabhakar.csengg@gmail.com, Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 1/2] [media] tvp5150: Fix type mismatch warning in clamp macro
Date: Thu, 27 Feb 2014 17:44:47 +0100
Message-Id: <1393519488-5427-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes the following warning:

drivers/media/i2c/tvp5150.c: In function '__tvp5150_try_crop':
include/linux/kernel.h:762:17: warning: comparison of distinct pointer types lacks a cast [enabled by default]
  (void) (&__val == &__min);  \
                 ^
drivers/media/i2c/tvp5150.c:886:16: note: in expansion of macro 'clamp'
  rect->width = clamp(rect->width,
                ^
include/linux/kernel.h:763:17: warning: comparison of distinct pointer types lacks a cast [enabled by default]
  (void) (&__val == &__max);  \
                 ^
drivers/media/i2c/tvp5150.c:886:16: note: in expansion of macro 'clamp'
  rect->width = clamp(rect->width,
                ^
include/linux/kernel.h:762:17: warning: comparison of distinct pointer types lacks a cast [enabled by default]
  (void) (&__val == &__min);  \
                 ^
drivers/media/i2c/tvp5150.c:904:17: note: in expansion of macro 'clamp'
  rect->height = clamp(rect->height,
                 ^
include/linux/kernel.h:763:17: warning: comparison of distinct pointer types lacks a cast [enabled by default]
  (void) (&__val == &__max);  \
                 ^
drivers/media/i2c/tvp5150.c:904:17: note: in expansion of macro 'clamp'
  rect->height = clamp(rect->height,
                 ^

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/i2c/tvp5150.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 542d252..8ac52fc 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -16,9 +16,9 @@
 
 #include "tvp5150_reg.h"
 
-#define TVP5150_H_MAX		720
-#define TVP5150_V_MAX_525_60	480
-#define TVP5150_V_MAX_OTHERS	576
+#define TVP5150_H_MAX		720U
+#define TVP5150_V_MAX_525_60	480U
+#define TVP5150_V_MAX_OTHERS	576U
 #define TVP5150_MAX_CROP_LEFT	511
 #define TVP5150_MAX_CROP_TOP	127
 #define TVP5150_CROP_SHIFT	2
-- 
1.8.5.3

