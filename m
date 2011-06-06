Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.171]:64952 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab1FFRRz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jun 2011 13:17:55 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 599DE189B77
	for <linux-media@vger.kernel.org>; Mon,  6 Jun 2011 19:17:53 +0200 (CEST)
Date: Mon, 6 Jun 2011 19:17:53 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] V4L: soc-camera: MIPI flags are not sensor flags
Message-ID: <Pine.LNX.4.64.1106061917080.11169@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

SOCAM_MIPI_[1234]LANE flags are not board-specific sensor flags, they
are bus configuration flags.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 include/media/soc_camera.h |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 238bd33..e34b5e6 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -109,12 +109,6 @@ struct soc_camera_host_ops {
 #define SOCAM_SENSOR_INVERT_HSYNC	(1 << 2)
 #define SOCAM_SENSOR_INVERT_VSYNC	(1 << 3)
 #define SOCAM_SENSOR_INVERT_DATA	(1 << 4)
-#define SOCAM_MIPI_1LANE		(1 << 5)
-#define SOCAM_MIPI_2LANE		(1 << 6)
-#define SOCAM_MIPI_3LANE		(1 << 7)
-#define SOCAM_MIPI_4LANE		(1 << 8)
-#define SOCAM_MIPI	(SOCAM_MIPI_1LANE | SOCAM_MIPI_2LANE | \
-			SOCAM_MIPI_3LANE | SOCAM_MIPI_4LANE)
 
 struct i2c_board_info;
 struct regulator_bulk_data;
@@ -270,6 +264,12 @@ static inline struct v4l2_queryctrl const *soc_camera_find_qctrl(
 #define SOCAM_PCLK_SAMPLE_FALLING	(1 << 13)
 #define SOCAM_DATA_ACTIVE_HIGH		(1 << 14)
 #define SOCAM_DATA_ACTIVE_LOW		(1 << 15)
+#define SOCAM_MIPI_1LANE		(1 << 16)
+#define SOCAM_MIPI_2LANE		(1 << 17)
+#define SOCAM_MIPI_3LANE		(1 << 18)
+#define SOCAM_MIPI_4LANE		(1 << 19)
+#define SOCAM_MIPI	(SOCAM_MIPI_1LANE | SOCAM_MIPI_2LANE | \
+			SOCAM_MIPI_3LANE | SOCAM_MIPI_4LANE)
 
 #define SOCAM_DATAWIDTH_MASK (SOCAM_DATAWIDTH_4 | SOCAM_DATAWIDTH_8 | \
 			      SOCAM_DATAWIDTH_9 | SOCAM_DATAWIDTH_10 | \
-- 
1.7.2.5

