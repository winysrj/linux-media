Return-path: <linux-media-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:34290 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753957AbcJZI4I (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Oct 2016 04:56:08 -0400
From: Brian Starkey <brian.starkey@arm.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Liviu Dudau <Liviu.Dudau@arm.com>
Subject: [RFC PATCH v2 5/9] drm: mali-dp: Add support for writeback on DP550/DP650
Date: Wed, 26 Oct 2016 09:55:04 +0100
Message-Id: <1477472108-27222-6-git-send-email-brian.starkey@arm.com>
In-Reply-To: <1477472108-27222-1-git-send-email-brian.starkey@arm.com>
References: <1477472108-27222-1-git-send-email-brian.starkey@arm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Liviu Dudau <Liviu.Dudau@arm.com>

Mali-DP display processors are able to write the composition result to a
memory buffer via the SE.

Add entry points in the HAL for enabling/disabling this feature, and
implement support for it on DP650 and DP550. DP500 acts differently and
so is omitted from this change.

Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
Signed-off-by: Brian Starkey <brian.starkey@arm.com>
---
 drivers/gpu/drm/arm/malidp_hw.c   |   52 +++++++++++++++++++++++++++++++++++--
 drivers/gpu/drm/arm/malidp_hw.h   |   18 +++++++++++++
 drivers/gpu/drm/arm/malidp_regs.h |   15 +++++++++++
 3 files changed, 83 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/arm/malidp_hw.c b/drivers/gpu/drm/arm/malidp_hw.c
index df1fce0..5004988 100644
--- a/drivers/gpu/drm/arm/malidp_hw.c
+++ b/drivers/gpu/drm/arm/malidp_hw.c
@@ -389,6 +389,48 @@ static int malidp550_rotmem_required(struct malidp_hw_device *hwdev, u16 w, u16
 	return w * bytes_per_col;
 }
 
+static int malidp550_enable_memwrite(struct malidp_hw_device *hwdev,
+				     dma_addr_t *addrs, s32 *pitches,
+				     int num_planes, u16 w, u16 h, u32 fmt_id)
+{
+	u32 base = MALIDP550_SE_MEMWRITE_BASE;
+	u32 de_base = malidp_get_block_base(hwdev, MALIDP_DE_BLOCK);
+
+	/* enable the scaling engine block */
+	malidp_hw_setbits(hwdev, MALIDP_SCALE_ENGINE_EN, de_base + MALIDP_DE_DISPLAY_FUNC);
+
+	malidp_hw_write(hwdev, fmt_id, base + MALIDP_MW_FORMAT);
+	switch (num_planes) {
+	case 2:
+		malidp_hw_write(hwdev, lower_32_bits(addrs[1]), base + MALIDP_MW_P2_PTR_LOW);
+		malidp_hw_write(hwdev, upper_32_bits(addrs[1]), base + MALIDP_MW_P2_PTR_HIGH);
+		malidp_hw_write(hwdev, pitches[1], base + MALIDP_MW_P2_STRIDE);
+		/* fall through */
+	case 1:
+		malidp_hw_write(hwdev, lower_32_bits(addrs[0]), base + MALIDP_MW_P1_PTR_LOW);
+		malidp_hw_write(hwdev, upper_32_bits(addrs[0]), base + MALIDP_MW_P1_PTR_HIGH);
+		malidp_hw_write(hwdev, pitches[0], base + MALIDP_MW_P1_STRIDE);
+		break;
+	default:
+		WARN(1, "Invalid number of planes");
+	}
+
+	malidp_hw_write(hwdev, MALIDP_DE_H_ACTIVE(w) | MALIDP_DE_V_ACTIVE(h),
+			MALIDP550_SE_MEMWRITE_OUT_SIZE);
+	malidp_hw_setbits(hwdev, MALIDP550_SE_MEMWRITE_ONESHOT | MALIDP_SE_MEMWRITE_EN,
+			  MALIDP550_SE_CONTROL);
+
+	return 0;
+}
+
+static void malidp550_disable_memwrite(struct malidp_hw_device *hwdev)
+{
+	u32 base = malidp_get_block_base(hwdev, MALIDP_DE_BLOCK);
+	malidp_hw_clearbits(hwdev, MALIDP550_SE_MEMWRITE_ONESHOT | MALIDP_SE_MEMWRITE_EN,
+			    MALIDP550_SE_CONTROL);
+	malidp_hw_clearbits(hwdev, MALIDP_SCALE_ENGINE_EN, base + MALIDP_DE_DISPLAY_FUNC);
+}
+
 static int malidp650_query_hw(struct malidp_hw_device *hwdev)
 {
 	u32 conf = malidp_hw_read(hwdev, MALIDP550_CONFIG_ID);
@@ -471,7 +513,8 @@ const struct malidp_hw_device malidp_device[MALIDP_MAX_DEVICES] = {
 					    MALIDP550_SE_IRQ_AXI_ERR,
 			},
 			.dc_irq_map = {
-				.irq_mask = MALIDP550_DC_IRQ_CONF_VALID,
+				.irq_mask = MALIDP550_DC_IRQ_CONF_VALID |
+					    MALIDP550_DC_IRQ_SE,
 				.vsync_irq = MALIDP550_DC_IRQ_CONF_VALID,
 			},
 			.pixel_formats = malidp550_de_formats,
@@ -485,6 +528,8 @@ const struct malidp_hw_device malidp_device[MALIDP_MAX_DEVICES] = {
 		.set_config_valid = malidp550_set_config_valid,
 		.modeset = malidp550_modeset,
 		.rotmem_required = malidp550_rotmem_required,
+		.enable_memwrite = malidp550_enable_memwrite,
+		.disable_memwrite = malidp550_disable_memwrite,
 	},
 	[MALIDP_650] = {
 		.map = {
@@ -505,7 +550,8 @@ const struct malidp_hw_device malidp_device[MALIDP_MAX_DEVICES] = {
 					    MALIDP550_SE_IRQ_AXI_ERR,
 			},
 			.dc_irq_map = {
-				.irq_mask = MALIDP550_DC_IRQ_CONF_VALID,
+				.irq_mask = MALIDP550_DC_IRQ_CONF_VALID |
+					    MALIDP550_DC_IRQ_SE,
 				.vsync_irq = MALIDP550_DC_IRQ_CONF_VALID,
 			},
 			.pixel_formats = malidp550_de_formats,
@@ -519,6 +565,8 @@ const struct malidp_hw_device malidp_device[MALIDP_MAX_DEVICES] = {
 		.set_config_valid = malidp550_set_config_valid,
 		.modeset = malidp550_modeset,
 		.rotmem_required = malidp550_rotmem_required,
+		.enable_memwrite = malidp550_enable_memwrite,
+		.disable_memwrite = malidp550_disable_memwrite,
 	},
 };
 
diff --git a/drivers/gpu/drm/arm/malidp_hw.h b/drivers/gpu/drm/arm/malidp_hw.h
index ce4ea55..8056efa 100644
--- a/drivers/gpu/drm/arm/malidp_hw.h
+++ b/drivers/gpu/drm/arm/malidp_hw.h
@@ -147,6 +147,24 @@ struct malidp_hw_device {
 	 */
 	int (*rotmem_required)(struct malidp_hw_device *hwdev, u16 w, u16 h, u32 fmt);
 
+	/**
+	 * Enable writing to memory the content of the next frame
+	 * @param hwdev - malidp_hw_device structure containing the HW description
+	 * @param addrs - array of addresses for each plane
+	 * @param pitches - array of pitches for each plane
+	 * @param num_planes - number of planes to be written
+	 * @param w - width of the output frame
+	 * @param h - height of the output frame
+	 * @param fmt_id - internal format ID of output buffer
+	 */
+	int (*enable_memwrite)(struct malidp_hw_device *hwdev, dma_addr_t *addrs,
+			       s32 *pitches, int num_planes, u16 w, u16 h, u32 fmt_id);
+
+	/*
+	 * Disable the writing to memory of the next frame's content.
+	 */
+	void (*disable_memwrite)(struct malidp_hw_device *hwdev);
+
 	u8 features;
 
 	u8 min_line_size;
diff --git a/drivers/gpu/drm/arm/malidp_regs.h b/drivers/gpu/drm/arm/malidp_regs.h
index 73fecb3..cab086c 100644
--- a/drivers/gpu/drm/arm/malidp_regs.h
+++ b/drivers/gpu/drm/arm/malidp_regs.h
@@ -64,6 +64,8 @@
 /* bit masks that are common between products */
 #define   MALIDP_CFG_VALID		(1 << 0)
 #define   MALIDP_DISP_FUNC_ILACED	(1 << 8)
+#define   MALIDP_SCALE_ENGINE_EN	(1 << 16)
+#define   MALIDP_SE_MEMWRITE_EN		(2 << 5)
 
 /* register offsets for IRQ management */
 #define MALIDP_REG_STATUS		0x00000
@@ -92,6 +94,15 @@
 #define MALIDP_DE_H_ACTIVE(x)		(((x) & 0x1fff) << 0)
 #define MALIDP_DE_V_ACTIVE(x)		(((x) & 0x1fff) << 16)
 
+/* register offsets relative to MALIDP5x0_SE_MEMWRITE_BASE */
+#define MALIDP_MW_FORMAT		0x00000
+#define MALIDP_MW_P1_STRIDE		0x00004
+#define MALIDP_MW_P2_STRIDE		0x00008
+#define MALIDP_MW_P1_PTR_LOW		0x0000c
+#define MALIDP_MW_P1_PTR_HIGH		0x00010
+#define MALIDP_MW_P2_PTR_LOW		0x0002c
+#define MALIDP_MW_P2_PTR_HIGH		0x00030
+
 /* register offsets and bits specific to DP500 */
 #define MALIDP500_DC_BASE		0x00000
 #define MALIDP500_DC_CONTROL		0x0000c
@@ -149,6 +160,10 @@
 #define MALIDP550_DE_LS_PTR_BASE	0x0042c
 #define MALIDP550_DE_PERF_BASE		0x00500
 #define MALIDP550_SE_BASE		0x08000
+#define MALIDP550_SE_CONTROL		0x08010
+#define   MALIDP550_SE_MEMWRITE_ONESHOT	(1 << 7)
+#define MALIDP550_SE_MEMWRITE_OUT_SIZE	0x08030
+#define MALIDP550_SE_MEMWRITE_BASE	0x08100
 #define MALIDP550_DC_BASE		0x0c000
 #define MALIDP550_DC_CONTROL		0x0c010
 #define   MALIDP550_DC_CONFIG_REQ	(1 << 16)
-- 
1.7.9.5

