Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:50715 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728547AbeHMRdM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Aug 2018 13:33:12 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Osipenko <digetx@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-media@vger.kernel.org, linux-tegra@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH 03/14] staging: media: tegra-vde: Prepare for interlacing support
Date: Mon, 13 Aug 2018 16:50:16 +0200
Message-Id: <20180813145027.16346-4-thierry.reding@gmail.com>
In-Reply-To: <20180813145027.16346-1-thierry.reding@gmail.com>
References: <20180813145027.16346-1-thierry.reding@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Thierry Reding <treding@nvidia.com>

The number of frames doubles when decoding interlaced content and the
structures describing the frames double in size. Take that into account
to prepare for interlacing support.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/staging/media/tegra-vde/tegra-vde.c | 73 ++++++++++++++++-----
 1 file changed, 58 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/media/tegra-vde/tegra-vde.c b/drivers/staging/media/tegra-vde/tegra-vde.c
index 3027b11b11ae..1a40f6dff7c8 100644
--- a/drivers/staging/media/tegra-vde/tegra-vde.c
+++ b/drivers/staging/media/tegra-vde/tegra-vde.c
@@ -61,7 +61,9 @@ struct video_frame {
 };
 
 struct tegra_vde_soc {
+	unsigned int num_ref_pics;
 	bool supports_ref_pic_marking;
+	bool supports_interlacing;
 };
 
 struct tegra_vde {
@@ -205,8 +207,12 @@ static void tegra_vde_setup_frameid(struct tegra_vde *vde,
 	u32 cr_addr = frame ? frame->cr_addr : 0x6CDEAD00;
 	u32 value1 = frame ? ((mbs_width << 16) | mbs_height) : 0;
 	u32 value2 = frame ? ((((mbs_width + 1) >> 1) << 6) | 1) : 0;
+	u32 value = y_addr >> 8;
 
-	VDE_WR(y_addr  >> 8, vde->frameid + 0x000 + frameid * 4);
+	if (vde->soc->supports_interlacing)
+		value |= BIT(31);
+
+	VDE_WR(value,        vde->frameid + 0x000 + frameid * 4);
 	VDE_WR(cb_addr >> 8, vde->frameid + 0x100 + frameid * 4);
 	VDE_WR(cr_addr >> 8, vde->frameid + 0x180 + frameid * 4);
 	VDE_WR(value1,       vde->frameid + 0x080 + frameid * 4);
@@ -229,20 +235,23 @@ static void tegra_setup_frameidx(struct tegra_vde *vde,
 }
 
 static void tegra_vde_setup_iram_entry(struct tegra_vde *vde,
+				       unsigned int num_ref_pics,
 				       unsigned int table,
 				       unsigned int row,
 				       u32 value1, u32 value2)
 {
+	unsigned int entries = num_ref_pics * 2;
 	u32 *iram_tables = vde->iram;
 
 	dev_dbg(vde->miscdev.parent, "IRAM table %u: row %u: 0x%08X 0x%08X\n",
 		table, row, value1, value2);
 
-	iram_tables[0x20 * table + row * 2] = value1;
-	iram_tables[0x20 * table + row * 2 + 1] = value2;
+	iram_tables[entries * table + row * 2] = value1;
+	iram_tables[entries * table + row * 2 + 1] = value2;
 }
 
 static void tegra_vde_setup_iram_tables(struct tegra_vde *vde,
+					unsigned int num_ref_pics,
 					struct video_frame *dpb_frames,
 					unsigned int ref_frames_nb,
 					unsigned int with_earlier_poc_nb)
@@ -251,13 +260,17 @@ static void tegra_vde_setup_iram_tables(struct tegra_vde *vde,
 	u32 value, aux_addr;
 	int with_later_poc_nb;
 	unsigned int i, k;
+	size_t size;
+
+	size = num_ref_pics * 4 * 8;
+	memset(vde->iram, 0, size);
 
 	dev_dbg(vde->miscdev.parent, "DPB: Frame 0: frame_num = %d\n",
 		dpb_frames[0].frame_num);
 
 	dev_dbg(vde->miscdev.parent, "REF L0:\n");
 
-	for (i = 0; i < 16; i++) {
+	for (i = 0; i < num_ref_pics; i++) {
 		if (i < ref_frames_nb) {
 			frame = &dpb_frames[i + 1];
 
@@ -277,10 +290,14 @@ static void tegra_vde_setup_iram_tables(struct tegra_vde *vde,
 			value = 0;
 		}
 
-		tegra_vde_setup_iram_entry(vde, 0, i, value, aux_addr);
-		tegra_vde_setup_iram_entry(vde, 1, i, value, aux_addr);
-		tegra_vde_setup_iram_entry(vde, 2, i, value, aux_addr);
-		tegra_vde_setup_iram_entry(vde, 3, i, value, aux_addr);
+		tegra_vde_setup_iram_entry(vde, num_ref_pics, 0, i, value,
+					   aux_addr);
+		tegra_vde_setup_iram_entry(vde, num_ref_pics, 1, i, value,
+					   aux_addr);
+		tegra_vde_setup_iram_entry(vde, num_ref_pics, 2, i, value,
+					   aux_addr);
+		tegra_vde_setup_iram_entry(vde, num_ref_pics, 3, i, value,
+					   aux_addr);
 	}
 
 	if (!(dpb_frames[0].flags & FLAG_B_FRAME))
@@ -309,7 +326,8 @@ static void tegra_vde_setup_iram_tables(struct tegra_vde *vde,
 			"\tFrame %d: frame_num = %d\n",
 			k + 1, frame->frame_num);
 
-		tegra_vde_setup_iram_entry(vde, 2, i, value, aux_addr);
+		tegra_vde_setup_iram_entry(vde, num_ref_pics, 2, i, value,
+					   aux_addr);
 	}
 
 	for (k = 0; i < ref_frames_nb; i++, k++) {
@@ -326,7 +344,8 @@ static void tegra_vde_setup_iram_tables(struct tegra_vde *vde,
 			"\tFrame %d: frame_num = %d\n",
 			k + 1, frame->frame_num);
 
-		tegra_vde_setup_iram_entry(vde, 2, i, value, aux_addr);
+		tegra_vde_setup_iram_entry(vde, num_ref_pics, 2, i, value,
+					   aux_addr);
 	}
 }
 
@@ -339,9 +358,20 @@ static int tegra_vde_setup_hw_context(struct tegra_vde *vde,
 				      unsigned int macroblocks_nb)
 {
 	struct device *dev = vde->miscdev.parent;
+	unsigned int num_ref_pics = 16;
+	/* XXX extend ABI to provide this */
+	bool interlaced = false;
+	size_t size;
 	u32 value;
 	int err;
 
+	if (vde->soc->supports_interlacing) {
+		if (interlaced)
+			num_ref_pics = vde->soc->num_ref_pics;
+		else
+			num_ref_pics = 16;
+	}
+
 	tegra_vde_set_bits(vde, 0x000A, vde->sxe + 0xF0);
 	tegra_vde_set_bits(vde, 0x000B, vde->bsev + CMDQUE_CONTROL);
 	tegra_vde_set_bits(vde, 0x8002, vde->mbe + 0x50);
@@ -369,12 +399,12 @@ static int tegra_vde_setup_hw_context(struct tegra_vde *vde,
 	VDE_WR(0x00000000, vde->bsev + 0x98);
 	VDE_WR(0x00000060, vde->bsev + 0x9C);
 
-	memset(vde->iram + 128, 0, macroblocks_nb / 2);
+	memset(vde->iram + 1024, 0, macroblocks_nb / 2);
 
 	tegra_setup_frameidx(vde, dpb_frames, ctx->dpb_frames_nb,
 			     ctx->pic_width_in_mbs, ctx->pic_height_in_mbs);
 
-	tegra_vde_setup_iram_tables(vde, dpb_frames,
+	tegra_vde_setup_iram_tables(vde, num_ref_pics, dpb_frames,
 				    ctx->dpb_frames_nb - 1,
 				    ctx->dpb_ref_frames_with_earlier_poc_nb);
 
@@ -396,22 +426,27 @@ static int tegra_vde_setup_hw_context(struct tegra_vde *vde,
 	if (err)
 		return err;
 
-	err = tegra_vde_push_to_bsev_icmdqueue(vde, 0x800003FC, false);
+	value = (0x20 << 26) | (0 << 25) | ((4096 >> 2) & 0x1fff);
+	err = tegra_vde_push_to_bsev_icmdqueue(vde, value, false);
 	if (err)
 		return err;
 
 	value = 0x01500000;
-	value |= ((vde->iram_lists_addr + 512) >> 2) & 0xFFFF;
+	value |= ((vde->iram_lists_addr + 1024) >> 2) & 0xffff;
 
 	err = tegra_vde_push_to_bsev_icmdqueue(vde, value, true);
 	if (err)
 		return err;
 
+	value = (0x21 << 26) | ((240 & 0x1fff) << 12) | (0x54c & 0xfff);
 	err = tegra_vde_push_to_bsev_icmdqueue(vde, 0x840F054C, false);
 	if (err)
 		return err;
 
-	err = tegra_vde_push_to_bsev_icmdqueue(vde, 0x80000080, false);
+	size = num_ref_pics * 4 * 8;
+
+	value = (0x20 << 26) | (0x0 << 25) | ((size >> 2) & 0x1fff);
+	err = tegra_vde_push_to_bsev_icmdqueue(vde, value, false);
 	if (err)
 		return err;
 
@@ -1290,19 +1325,27 @@ static const struct dev_pm_ops tegra_vde_pm_ops = {
 };
 
 static const struct tegra_vde_soc tegra20_vde_soc = {
+	.num_ref_pics = 16,
 	.supports_ref_pic_marking = false,
+	.supports_interlacing = false,
 };
 
 static const struct tegra_vde_soc tegra30_vde_soc = {
+	.num_ref_pics = 32,
 	.supports_ref_pic_marking = false,
+	.supports_interlacing = false,
 };
 
 static const struct tegra_vde_soc tegra114_vde_soc = {
+	.num_ref_pics = 32,
 	.supports_ref_pic_marking = true,
+	.supports_interlacing = false,
 };
 
 static const struct tegra_vde_soc tegra124_vde_soc = {
+	.num_ref_pics = 32,
 	.supports_ref_pic_marking = true,
+	.supports_interlacing = true,
 };
 
 static const struct of_device_id tegra_vde_of_match[] = {
-- 
2.17.0
