Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.pmeerw.net ([87.118.82.44]:59288 "EHLO pmeerw.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754292Ab2FMOtF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jun 2012 10:49:05 -0400
From: Peter Meerwald <pmeerw@pmeerw.net>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de,
	Peter Meerwald <p.meerwald@bct-electronic.com>
Subject: [PATCH] media: typo, change ctruct to struct in comment
Date: Wed, 13 Jun 2012 16:48:11 +0200
Message-Id: <1339598891-23915-1-git-send-email-pmeerw@pmeerw.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Peter Meerwald <p.meerwald@bct-electronic.com>

Signed-off-by: Peter Meerwald <p.meerwald@bct-electronic.com>

---
 drivers/media/video/mt9m001.c |    2 +-
 drivers/media/video/mt9v022.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/mt9m001.c b/drivers/media/video/mt9m001.c
index 7e64818..00583f5 100644
--- a/drivers/media/video/mt9m001.c
+++ b/drivers/media/video/mt9m001.c
@@ -22,7 +22,7 @@
 
 /*
  * mt9m001 i2c address 0x5d
- * The platform has to define ctruct i2c_board_info objects and link to them
+ * The platform has to define struct i2c_board_info objects and link to them
  * from struct soc_camera_link
  */
 
diff --git a/drivers/media/video/mt9v022.c b/drivers/media/video/mt9v022.c
index bf63417..7247924 100644
--- a/drivers/media/video/mt9v022.c
+++ b/drivers/media/video/mt9v022.c
@@ -23,7 +23,7 @@
 
 /*
  * mt9v022 i2c address 0x48, 0x4c, 0x58, 0x5c
- * The platform has to define ctruct i2c_board_info objects and link to them
+ * The platform has to define struct i2c_board_info objects and link to them
  * from struct soc_camera_link
  */
 
-- 
1.7.5.4

