Return-path: <mchehab@gaivota>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:21853 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073Ab0L1RDZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Dec 2010 12:03:25 -0500
Date: Tue, 28 Dec 2010 18:03:13 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 08/15] [media] s5p-fimc: Derive camera bus width from mediabus
 pixelcode
In-reply-to: <1293555798-31578-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com
Message-id: <1293555798-31578-9-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1293555798-31578-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Remove bus_width from s5p_fimc_isp_info data structure.
Determine camera data bus width based on mediabus pixel format.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-reg.c |   44 +++++++++++++++++-------------
 include/media/s5p_fimc.h                |    2 -
 2 files changed, 25 insertions(+), 21 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-reg.c b/drivers/media/video/s5p-fimc/fimc-reg.c
index ae33bc1..41a6a72 100644
--- a/drivers/media/video/s5p-fimc/fimc-reg.c
+++ b/drivers/media/video/s5p-fimc/fimc-reg.c
@@ -561,37 +561,43 @@ int fimc_hw_set_camera_source(struct fimc_dev *fimc,
 {
 	struct fimc_frame *f = &fimc->vid_cap.ctx->s_frame;
 	u32 cfg = 0;
+	u32 bus_width = 8;
+	int i;
+
+	static const struct {
+		u32 pixelcode;
+		u32 cisrcfmt;
+		u16 bus_width;
+	} pix_desc[] = {
+		{ V4L2_MBUS_FMT_YUYV8_2X8, S5P_CISRCFMT_ORDER422_YCBYCR, 8 },
+		{ V4L2_MBUS_FMT_YVYU8_2X8, S5P_CISRCFMT_ORDER422_YCRYCB, 8 },
+		{ V4L2_MBUS_FMT_VYUY8_2X8, S5P_CISRCFMT_ORDER422_CRYCBY, 8 },
+		{ V4L2_MBUS_FMT_UYVY8_2X8, S5P_CISRCFMT_ORDER422_CBYCRY, 8 },
+		/* TODO: Add pixel codes for 16-bit bus width */
+	};
 
 	if (cam->bus_type == FIMC_ITU_601 || cam->bus_type == FIMC_ITU_656) {
 
-		switch (fimc->vid_cap.fmt.code) {
-		case V4L2_MBUS_FMT_YUYV8_2X8:
-			cfg = S5P_CISRCFMT_ORDER422_YCBYCR;
-			break;
-		case V4L2_MBUS_FMT_YVYU8_2X8:
-			cfg = S5P_CISRCFMT_ORDER422_YCRYCB;
-			break;
-		case V4L2_MBUS_FMT_VYUY8_2X8:
-			cfg = S5P_CISRCFMT_ORDER422_CRYCBY;
-			break;
-		case V4L2_MBUS_FMT_UYVY8_2X8:
-			cfg = S5P_CISRCFMT_ORDER422_CBYCRY;
-			break;
-		default:
+		for (i = 0; i < ARRAY_SIZE(pix_desc); i++) {
+			if (fimc->vid_cap.fmt.code == pix_desc[i].pixelcode) {
+				cfg = pix_desc[i].cisrcfmt;
+				bus_width = pix_desc[i].bus_width;
+				break;
+			}
+		}
+		if (i == ARRAY_SIZE(pix_desc)) {
 			err("camera image format not supported: %d",
 			    fimc->vid_cap.fmt.code);
 			return -EINVAL;
 		}
 
 		if (cam->bus_type == FIMC_ITU_601) {
-			if (cam->bus_width == 8) {
+			if (bus_width == 8)
 				cfg |= S5P_CISRCFMT_ITU601_8BIT;
-			} else if (cam->bus_width == 16) {
+			else if (bus_width == 16)
 				cfg |= S5P_CISRCFMT_ITU601_16BIT;
-			} else {
-				err("invalid bus width: %d", cam->bus_width);
+			else
 				return -EINVAL;
-			}
 		} /* else defaults to ITU-R BT.656 8-bit */
 	}
 
diff --git a/include/media/s5p_fimc.h b/include/media/s5p_fimc.h
index eb8793f..d30b9dee 100644
--- a/include/media/s5p_fimc.h
+++ b/include/media/s5p_fimc.h
@@ -34,7 +34,6 @@ struct i2c_board_info;
  * @bus_type: determines bus type, MIPI, ITU-R BT.601 etc.
  * @i2c_bus_num: i2c control bus id the sensor is attached to
  * @mux_id: FIMC camera interface multiplexer index (separate for MIPI and ITU)
- * @bus_width: camera data bus width in bits
  * @flags: flags defining bus signals polarity inversion (High by default)
  */
 struct s5p_fimc_isp_info {
@@ -42,7 +41,6 @@ struct s5p_fimc_isp_info {
 	enum cam_bus_type bus_type;
 	u16 i2c_bus_num;
 	u16 mux_id;
-	u16 bus_width;
 	u16 flags;
 };
 
-- 
1.7.2.3

