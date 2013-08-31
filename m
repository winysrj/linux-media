Return-path: <linux-media-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:38246 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753569Ab3HaTfx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Aug 2013 15:35:53 -0400
From: Christoph Jaeger <christophjaeger@linux.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org,
	Christoph Jaeger <christophjaeger@linux.com>
Subject: [PATCH] media: dvb-frontends: Remove unused SIZEOF_ARRAY
Date: Sat, 31 Aug 2013 21:31:07 +0200
Message-Id: <1377977467-28647-1-git-send-email-christophjaeger@linux.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SIZEOF_ARRAY is not used (anymore). Besides, ARRAY_SIZE, defined in
include/linux/kernel.h, should be used rather than explicitly coding some
variant of it.

Signed-off-by: Christoph Jaeger <christophjaeger@linux.com>
---
 drivers/media/dvb-frontends/drxd_hard.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/drxd_hard.c b/drivers/media/dvb-frontends/drxd_hard.c
index 9a213479..cbd7c92 100644
--- a/drivers/media/dvb-frontends/drxd_hard.c
+++ b/drivers/media/dvb-frontends/drxd_hard.c
@@ -46,10 +46,6 @@
 #define DRX_I2C_MODEFLAGS     0xC0
 #define DRX_I2C_FLAGS         0xF0
 
-#ifndef SIZEOF_ARRAY
-#define SIZEOF_ARRAY(array) (sizeof((array))/sizeof((array)[0]))
-#endif
-
 #define DEFAULT_LOCK_TIMEOUT    1100
 
 #define DRX_CHANNEL_AUTO 0
-- 
1.8.3.1

