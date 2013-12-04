Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49945 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755973Ab3LDTPu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Dec 2013 14:15:50 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Enric Balletbo i Serra <eballetbo@gmail.com>
Subject: [PATCH 1/6] mt9v032: Remove unused macro
Date: Wed,  4 Dec 2013 20:15:48 +0100
Message-Id: <1386184553-12770-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1386184553-12770-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1386184553-12770-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The EXT_CLK macro is unused, remove it.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/mt9v032.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
index 2c50eff..2055820 100644
--- a/drivers/media/i2c/mt9v032.c
+++ b/drivers/media/i2c/mt9v032.c
@@ -215,8 +215,6 @@ mt9v032_update_hblank(struct mt9v032 *mt9v032)
 			     max_t(s32, mt9v032->hblank, 660 - crop->width));
 }
 
-#define EXT_CLK		25000000
-
 static int mt9v032_power_on(struct mt9v032 *mt9v032)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&mt9v032->subdev);
-- 
1.8.3.2

