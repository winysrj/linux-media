Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3743 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075Ab3EZN1j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 May 2013 09:27:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 20/24] v4l2-common: remove unused v4l2_chip_match/ident_i2c_client functions
Date: Sun, 26 May 2013 15:27:15 +0200
Message-Id: <1369574839-6687-21-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369574839-6687-1-git-send-email-hverkuil@xs4all.nl>
References: <1369574839-6687-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-common.c |   47 +--------------------------------
 include/media/v4l2-common.h           |    9 -------
 2 files changed, 1 insertion(+), 55 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
index 5fd7660..3b2a760 100644
--- a/drivers/media/v4l2-core/v4l2-common.c
+++ b/drivers/media/v4l2-core/v4l2-common.c
@@ -61,7 +61,6 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
-#include <media/v4l2-chip-ident.h>
 
 #include <linux/videodev2.h>
 
@@ -227,51 +226,9 @@ u32 v4l2_ctrl_next(const u32 * const * ctrl_classes, u32 id)
 }
 EXPORT_SYMBOL(v4l2_ctrl_next);
 
-#if IS_ENABLED(CONFIG_I2C)
-int v4l2_chip_match_i2c_client(struct i2c_client *c, const struct v4l2_dbg_match *match)
-{
-	int len;
-
-	if (c == NULL || match == NULL)
-		return 0;
-
-	switch (match->type) {
-	case V4L2_CHIP_MATCH_I2C_DRIVER:
-		if (c->driver == NULL || c->driver->driver.name == NULL)
-			return 0;
-		len = strlen(c->driver->driver.name);
-		return len && !strncmp(c->driver->driver.name, match->name, len);
-	case V4L2_CHIP_MATCH_I2C_ADDR:
-		return c->addr == match->addr;
-	case V4L2_CHIP_MATCH_SUBDEV:
-		return 1;
-	default:
-		return 0;
-	}
-}
-EXPORT_SYMBOL(v4l2_chip_match_i2c_client);
-
-int v4l2_chip_ident_i2c_client(struct i2c_client *c, struct v4l2_dbg_chip_ident *chip,
-		u32 ident, u32 revision)
-{
-	if (!v4l2_chip_match_i2c_client(c, &chip->match))
-		return 0;
-	if (chip->ident == V4L2_IDENT_NONE) {
-		chip->ident = ident;
-		chip->revision = revision;
-	}
-	else {
-		chip->ident = V4L2_IDENT_AMBIGUOUS;
-		chip->revision = 0;
-	}
-	return 0;
-}
-EXPORT_SYMBOL(v4l2_chip_ident_i2c_client);
-
-/* ----------------------------------------------------------------- */
-
 /* I2C Helper functions */
 
+#if IS_ENABLED(CONFIG_I2C)
 
 void v4l2_i2c_subdev_init(struct v4l2_subdev *sd, struct i2c_client *client,
 		const struct v4l2_subdev_ops *ops)
@@ -290,8 +247,6 @@ void v4l2_i2c_subdev_init(struct v4l2_subdev *sd, struct i2c_client *client,
 }
 EXPORT_SYMBOL_GPL(v4l2_i2c_subdev_init);
 
-
-
 /* Load an i2c sub-device. */
 struct v4l2_subdev *v4l2_i2c_new_subdev_board(struct v4l2_device *v4l2_dev,
 		struct i2c_adapter *adapter, struct i2c_board_info *info,
diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
index e7821fb..015ff82 100644
--- a/include/media/v4l2-common.h
+++ b/include/media/v4l2-common.h
@@ -100,15 +100,6 @@ u32 v4l2_ctrl_next(const u32 * const *ctrl_classes, u32 id);
 
 /* ------------------------------------------------------------------------- */
 
-/* Register/chip ident helper function */
-
-struct i2c_client; /* forward reference */
-int v4l2_chip_match_i2c_client(struct i2c_client *c, const struct v4l2_dbg_match *match);
-int v4l2_chip_ident_i2c_client(struct i2c_client *c, struct v4l2_dbg_chip_ident *chip,
-		u32 ident, u32 revision);
-
-/* ------------------------------------------------------------------------- */
-
 /* I2C Helper functions */
 
 struct i2c_driver;
-- 
1.7.10.4

