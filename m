Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:54692 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237Ab1FKRrG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jun 2011 13:47:06 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, Kassey Lee <ygli@marvell.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 6/8] marvell-cam: Right-shift i2c slave ID's in the cafe driver
Date: Sat, 11 Jun 2011 11:46:47 -0600
Message-Id: <1307814409-46282-7-git-send-email-corbet@lwn.net>
In-Reply-To: <1307814409-46282-1-git-send-email-corbet@lwn.net>
References: <1307814409-46282-1-git-send-email-corbet@lwn.net>
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
index 1027265..3dbc7e5 100644
--- a/drivers/media/video/marvell-ccic/cafe-driver.c
+++ b/drivers/media/video/marvell-ccic/cafe-driver.c
@@ -84,7 +84,14 @@ struct cafe_camera {
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
index 0d60234..d5f18a3 100644
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
1.7.5.4

