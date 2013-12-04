Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49946 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933078Ab3LDTPv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Dec 2013 14:15:51 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Enric Balletbo i Serra <eballetbo@gmail.com>
Subject: [PATCH 2/6] mt9v032: Fix pixel array size
Date: Wed,  4 Dec 2013 20:15:49 +0100
Message-Id: <1386184553-12770-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1386184553-12770-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1386184553-12770-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The active pixel array size is 753x481 with 4 additional black rows at
the top. Fix the driver accordingly.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/mt9v032.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
index 2055820..12360e4 100644
--- a/drivers/media/i2c/mt9v032.c
+++ b/drivers/media/i2c/mt9v032.c
@@ -27,8 +27,9 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-subdev.h>
 
-#define MT9V032_PIXEL_ARRAY_HEIGHT			492
-#define MT9V032_PIXEL_ARRAY_WIDTH			782
+/* The first four rows are black rows. The active area spans 753x481 pixels. */
+#define MT9V032_PIXEL_ARRAY_HEIGHT			485
+#define MT9V032_PIXEL_ARRAY_WIDTH			753
 
 #define MT9V032_SYSCLK_FREQ_DEF				26600000
 
-- 
1.8.3.2

