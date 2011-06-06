Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:43037 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758415Ab1FFWks (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Jun 2011 18:40:48 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, Kassey Lee <ygli@marvell.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 6/7] marvell-cam: Right-shift i2c slave ID's in the cafe driver
Date: Mon,  6 Jun 2011 16:40:02 -0600
Message-Id: <1307400003-94758-7-git-send-email-corbet@lwn.net>
In-Reply-To: <1307400003-94758-1-git-send-email-corbet@lwn.net>
References: <1307400003-94758-1-git-send-email-corbet@lwn.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This makes the cafe i2c implement consistent with the rest of Linux so that
the core can use the same slave ID everywhere.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/media/video/marvell-ccic/cafe-driver.c |    9 ++++++++-
 drivers/media/video/marvell-ccic/mcam-core.c   |    2 +-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/marvell-ccic/cafe-driver.c b/drivers/media/video/marvell-ccic/cafe-driver.c
index ec9257e..30a5065 100644
--- a/drivers/media/video/marvell-ccic/cafe-driver.c
+++ b/drivers/media/video/marvell-ccic/cafe-driver.c
@@ -83,7 +83,14 @@ struct cafe_camera {
 #define	  TWSIC0_EN	  0x00000001	/* TWSI enable */
 #define	  TWSIC0_MODE	  0x00000002	/* 1 = 16-bit, 0 = 8-bit */
 #define	  TWSIC0_SID	  0x000003fc	/* Slave ID */
-#define	  TWSIC0_SID_SHIFT 2
+/*
+ * Subtle trickery: the slave ID field starts with bit 2.  But the
+ * Linux i2c stack wants to treat the bottommost bit as a separate
+ * read/write bit, which is why slave ID's are usually presented
+ * >>1.  For consistency with that behavior, we shift over three
+ * bits instead of two.
+ */
+#define	  TWSIC0_SID_SHIFT 3
 #define	  TWSIC0_CLKDIV	  0x0007fc00	/* Clock divider */
 #define	  TWSIC0_MASKACK  0x00400000	/* Mask ack from sensor */
 #define	  TWSIC0_OVMAGIC  0x00800000	/* Make it work on OV sensors */
diff --git a/drivers/media/video/marvell-ccic/mcam-core.c b/drivers/media/video/marvell-ccic/mcam-core.c
index f7c3315..efe8c4b 100644
--- a/drivers/media/video/marvell-ccic/mcam-core.c
+++ b/drivers/media/video/marvell-ccic/mcam-core.c
@@ -1549,7 +1549,7 @@ int mccic_register(struct mcam_camera *cam)
 {
 	struct i2c_board_info ov7670_info = {
 		.type = "ov7670",
-		.addr = 0x42,
+		.addr = 0x42 >> 1,
 		.platform_data = &sensor_cfg,
 	};
 	int ret;
-- 
1.7.5.2

