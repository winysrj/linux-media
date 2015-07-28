Return-path: <linux-media-owner@vger.kernel.org>
Received: from atl4mhob13.myregisteredsite.com ([209.17.115.51]:33623 "EHLO
	atl4mhob13.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752499AbbG1K5w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jul 2015 06:57:52 -0400
Received: from mailpod.hostingplatform.com ([10.30.71.207])
	by atl4mhob13.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id t6SAvowp021023
	for <linux-media@vger.kernel.org>; Tue, 28 Jul 2015 06:57:50 -0400
From: Mike Looijmans <mike.looijmans@topic.nl>
To: lars@metafoo.de
Cc: linux-media@vger.kernel.org,
	Mike Looijmans <mike.looijmans@topic.nl>
Subject: [PATCH] [media] i2c/adv7511: Fix license, set to GPL v2
Date: Tue, 28 Jul 2015 12:57:46 +0200
Message-Id: <1438081066-31748-1-git-send-email-mike.looijmans@topic.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Header claims GPL v2, so make the MODULE_LICENSE reflect that properly.

Signed-off-by: Mike Looijmans <mike.looijmans@topic.nl>
---
 drivers/gpu/drm/i2c/adv7511_core.c | 2 +-
 drivers/media/i2c/adv7511.c        | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i2c/adv7511_core.c b/drivers/gpu/drm/i2c/adv7511_core.c
index 2564b5d..12e8134 100644
--- a/drivers/gpu/drm/i2c/adv7511_core.c
+++ b/drivers/gpu/drm/i2c/adv7511_core.c
@@ -956,4 +956,4 @@ module_exit(adv7511_exit);
 
 MODULE_AUTHOR("Lars-Peter Clausen <lars@metafoo.de>");
 MODULE_DESCRIPTION("ADV7511 HDMI transmitter driver");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/media/i2c/adv7511.c b/drivers/media/i2c/adv7511.c
index 02d76c6..1a4275d 100644
--- a/drivers/media/i2c/adv7511.c
+++ b/drivers/media/i2c/adv7511.c
@@ -41,7 +41,7 @@ MODULE_PARM_DESC(debug, "debug level (0-2)");
 
 MODULE_DESCRIPTION("Analog Devices ADV7511 HDMI Transmitter Device Driver");
 MODULE_AUTHOR("Hans Verkuil");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
 
 #define MASK_ADV7511_EDID_RDY_INT   0x04
 #define MASK_ADV7511_MSEN_INT       0x40
-- 
1.9.1

