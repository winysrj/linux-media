Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:38863 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755625Ab1BXOjf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Feb 2011 09:39:35 -0500
Date: Thu, 24 Feb 2011 15:33:52 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 5/7] s5p-fimc: Add a platform data entry for MIPI-CSI data
	alignment
In-reply-to: <1298558034-10768-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	kgene.kim@samsung.com, s.nawrocki@samsung.com
Message-id: <1298558034-10768-6-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1298558034-10768-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Allow the MIPI-CSI data alignment to be defined in the board setup
as it may be different across various camera sensors.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-reg.c |    6 ++++--
 include/media/s5p_fimc.h                |    2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-reg.c b/drivers/media/video/s5p-fimc/fimc-reg.c
index 10684ae..4d929a3 100644
--- a/drivers/media/video/s5p-fimc/fimc-reg.c
+++ b/drivers/media/video/s5p-fimc/fimc-reg.c
@@ -665,10 +665,12 @@ int fimc_hw_set_camera_type(struct fimc_dev *fimc,
 			    vid_cap->fmt.code);
 			return -EINVAL;
 		}
-		writel(tmp | (0x1 << 8), fimc->regs + S5P_CSIIMGFMT);
+		tmp |= (cam->csi_data_align == 32) << 8;
+
+		writel(tmp, fimc->regs + S5P_CSIIMGFMT);
 
 	} else if (cam->bus_type == FIMC_ITU_601 ||
-		  cam->bus_type == FIMC_ITU_656) {
+		   cam->bus_type == FIMC_ITU_656) {
 		if (cam->mux_id == 0) /* ITU-A, ITU-B: 0, 1 */
 			cfg |= S5P_CIGCTRL_SELCAM_ITU_A;
 	} else if (cam->bus_type == FIMC_LCD_WB) {
diff --git a/include/media/s5p_fimc.h b/include/media/s5p_fimc.h
index 96cd6fc..94c9a00 100644
--- a/include/media/s5p_fimc.h
+++ b/include/media/s5p_fimc.h
@@ -33,6 +33,7 @@ struct i2c_board_info;
  * @board_info: pointer to I2C subdevice's board info
  * @clk_frequency: frequency of the clock the host interface provides to sensor
  * @bus_type: determines bus type, MIPI, ITU-R BT.601 etc.
+ * @csi_data_align: MIPI-CSI interface data alignment in bits
  * @i2c_bus_num: i2c control bus id the sensor is attached to
  * @mux_id: FIMC camera interface multiplexer index (separate for MIPI and ITU)
  * @flags: flags defining bus signals polarity inversion (High by default)
@@ -41,6 +42,7 @@ struct s5p_fimc_isp_info {
 	struct i2c_board_info *board_info;
 	unsigned long clk_frequency;
 	enum cam_bus_type bus_type;
+	u16 csi_data_align;
 	u16 i2c_bus_num;
 	u16 mux_id;
 	u16 flags;
-- 
1.7.4.1
