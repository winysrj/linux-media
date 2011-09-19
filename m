Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:51072 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267Ab1ISFfj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Sep 2011 01:35:39 -0400
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id p8J5ZaR1027584
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 19 Sep 2011 00:35:38 -0500
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH RESEND 3/4] davinci vpbe: add dm365 and dm355 specific OSD changes
Date: Mon, 19 Sep 2011 11:05:28 +0530
Message-ID: <1316410529-14744-4-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1316410529-14744-1-git-send-email-manjunath.hadli@ti.com>
References: <1316410529-14744-1-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add OSD block changes to enable dm365 and dm355 for vpbe driver.
Changes are based on version number of OSD, which have incremental
changes over 644x OSD hardware interms of few registers.

VPBE_VERSION_2 = dm365 specific
VPBE_VERSION_3 = dm355 specific

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
---
 drivers/media/video/davinci/vpbe_osd.c |  474 +++++++++++++++++++++++++++++---
 1 files changed, 433 insertions(+), 41 deletions(-)

diff --git a/drivers/media/video/davinci/vpbe_osd.c b/drivers/media/video/davinci/vpbe_osd.c
index 5352884..cf472d3 100644
--- a/drivers/media/video/davinci/vpbe_osd.c
+++ b/drivers/media/video/davinci/vpbe_osd.c
@@ -248,11 +248,31 @@ static void _osd_set_rec601_attenuation(struct osd_state *sd,
 		osd_modify(sd, OSD_OSDWIN0MD_ATN0E,
 			  enable ? OSD_OSDWIN0MD_ATN0E : 0,
 			  OSD_OSDWIN0MD);
+		if (sd->vpbe_type == VPBE_VERSION_1) {
+			osd_modify(sd, OSD_OSDWIN0MD_ATN0E,
+				  enable ? OSD_OSDWIN0MD_ATN0E : 0,
+				  OSD_OSDWIN0MD);
+		} else if ((sd->vpbe_type == VPBE_VERSION_3) ||
+			   (sd->vpbe_type == VPBE_VERSION_2)) {
+			osd_modify(sd, OSD_EXTMODE_ATNOSD0EN,
+				  enable ? OSD_EXTMODE_ATNOSD0EN : 0,
+				  OSD_EXTMODE);
+		}
 		break;
 	case OSDWIN_OSD1:
 		osd_modify(sd, OSD_OSDWIN1MD_ATN1E,
 			  enable ? OSD_OSDWIN1MD_ATN1E : 0,
 			  OSD_OSDWIN1MD);
+		if (sd->vpbe_type == VPBE_VERSION_1) {
+			osd_modify(sd, OSD_OSDWIN1MD_ATN1E,
+				  enable ? OSD_OSDWIN1MD_ATN1E : 0,
+				  OSD_OSDWIN1MD);
+		} else if ((sd->vpbe_type == VPBE_VERSION_3) ||
+			   (sd->vpbe_type == VPBE_VERSION_2)) {
+			osd_modify(sd, OSD_EXTMODE_ATNOSD1EN,
+				  enable ? OSD_EXTMODE_ATNOSD1EN : 0,
+				  OSD_EXTMODE);
+		}
 		break;
 	}
 }
@@ -273,15 +293,72 @@ static void _osd_set_blending_factor(struct osd_state *sd,
 	}
 }
 
+static void _osd_enable_rgb888_pixblend(struct osd_state *sd,
+					enum osd_win_layer osdwin)
+{
+
+	osd_modify(sd, OSD_MISCCTL_BLDSEL, 0, OSD_MISCCTL);
+	switch (osdwin) {
+	case OSDWIN_OSD0:
+		osd_modify(sd, OSD_EXTMODE_OSD0BLDCHR,
+			  OSD_EXTMODE_OSD0BLDCHR, OSD_EXTMODE);
+		break;
+	case OSDWIN_OSD1:
+		osd_modify(sd, OSD_EXTMODE_OSD1BLDCHR,
+			  OSD_EXTMODE_OSD1BLDCHR, OSD_EXTMODE);
+		break;
+	}
+}
+
 static void _osd_enable_color_key(struct osd_state *sd,
 				  enum osd_win_layer osdwin,
 				  unsigned colorkey,
 				  enum osd_pix_format pixfmt)
 {
 	switch (pixfmt) {
+	case PIXFMT_1BPP:
+	case PIXFMT_2BPP:
+	case PIXFMT_4BPP:
+	case PIXFMT_8BPP:
+		if (sd->vpbe_type == VPBE_VERSION_3) {
+			switch (osdwin) {
+			case OSDWIN_OSD0:
+				osd_modify(sd, OSD_TRANSPBMPIDX_BMP0,
+					  colorkey <<
+					  OSD_TRANSPBMPIDX_BMP0_SHIFT,
+					  OSD_TRANSPBMPIDX);
+				break;
+			case OSDWIN_OSD1:
+				osd_modify(sd, OSD_TRANSPBMPIDX_BMP1,
+					  colorkey <<
+					  OSD_TRANSPBMPIDX_BMP1_SHIFT,
+					  OSD_TRANSPBMPIDX);
+				break;
+			}
+		}
+		break;
 	case PIXFMT_RGB565:
-		osd_write(sd, colorkey & OSD_TRANSPVAL_RGBTRANS,
-			  OSD_TRANSPVAL);
+		if (sd->vpbe_type == VPBE_VERSION_1) {
+			osd_write(sd, colorkey & OSD_TRANSPVAL_RGBTRANS,
+				  OSD_TRANSPVAL);
+		} else if (sd->vpbe_type == VPBE_VERSION_3) {
+			osd_write(sd, colorkey & OSD_TRANSPVALL_RGBL,
+				  OSD_TRANSPVALL);
+		}
+		break;
+	case PIXFMT_YCbCrI:
+	case PIXFMT_YCrCbI:
+		if (sd->vpbe_type == VPBE_VERSION_3)
+			osd_modify(sd, OSD_TRANSPVALU_Y, colorkey,
+				   OSD_TRANSPVALU);
+		break;
+	case PIXFMT_RGB888:
+		if (sd->vpbe_type == VPBE_VERSION_3) {
+			osd_write(sd, colorkey & OSD_TRANSPVALL_RGBL,
+				  OSD_TRANSPVALL);
+			osd_modify(sd, OSD_TRANSPVALU_RGBU, colorkey >> 16,
+				  OSD_TRANSPVALU);
+		}
 		break;
 	default:
 		break;
@@ -470,23 +547,187 @@ static int osd_enable_layer(struct osd_state *sd, enum osd_layer layer,
 	return 0;
 }
 
+#define OSD_SRC_ADDR_HIGH4	0x7800000
+#define OSD_SRC_ADDR_HIGH7	0x7F0000
+#define OSD_SRCADD_OFSET_SFT	23
+#define OSD_SRCADD_ADD_SFT	16
+#define OSD_WINADL_MASK		0xFFFF
+#define OSD_WINOFST_MASK	0x1000
+
 static void _osd_start_layer(struct osd_state *sd, enum osd_layer layer,
 			     unsigned long fb_base_phys,
 			     unsigned long cbcr_ofst)
 {
-	switch (layer) {
-	case WIN_OSD0:
-		osd_write(sd, fb_base_phys & ~0x1F, OSD_OSDWIN0ADR);
-		break;
-	case WIN_VID0:
-		osd_write(sd, fb_base_phys & ~0x1F, OSD_VIDWIN0ADR);
-		break;
-	case WIN_OSD1:
-		osd_write(sd, fb_base_phys & ~0x1F, OSD_OSDWIN1ADR);
-		break;
-	case WIN_VID1:
-		osd_write(sd, fb_base_phys & ~0x1F, OSD_VIDWIN1ADR);
-		break;
+
+	if (sd->vpbe_type == VPBE_VERSION_1) {
+		switch (layer) {
+		case WIN_OSD0:
+			osd_write(sd, fb_base_phys & ~0x1F, OSD_OSDWIN0ADR);
+			break;
+		case WIN_VID0:
+			osd_write(sd, fb_base_phys & ~0x1F, OSD_VIDWIN0ADR);
+			break;
+		case WIN_OSD1:
+			osd_write(sd, fb_base_phys & ~0x1F, OSD_OSDWIN1ADR);
+			break;
+		case WIN_VID1:
+			osd_write(sd, fb_base_phys & ~0x1F, OSD_VIDWIN1ADR);
+			break;
+	      }
+	} else if (sd->vpbe_type == VPBE_VERSION_3) {
+		unsigned long fb_offset_32 =
+		    (fb_base_phys - DAVINCI_DDR_BASE) >> 5;
+
+		switch (layer) {
+		case WIN_OSD0:
+			osd_modify(sd, OSD_OSDWINADH_O0AH,
+				  fb_offset_32 >> (OSD_SRCADD_ADD_SFT -
+						   OSD_OSDWINADH_O0AH_SHIFT),
+				  OSD_OSDWINADH);
+			osd_write(sd, fb_offset_32 & OSD_OSDWIN0ADL_O0AL,
+				  OSD_OSDWIN0ADL);
+			break;
+		case WIN_VID0:
+			osd_modify(sd, OSD_VIDWINADH_V0AH,
+				  fb_offset_32 >> (OSD_SRCADD_ADD_SFT -
+						   OSD_VIDWINADH_V0AH_SHIFT),
+				  OSD_VIDWINADH);
+			osd_write(sd, fb_offset_32 & OSD_VIDWIN0ADL_V0AL,
+				  OSD_VIDWIN0ADL);
+			break;
+		case WIN_OSD1:
+			osd_modify(sd, OSD_OSDWINADH_O1AH,
+				  fb_offset_32 >> (OSD_SRCADD_ADD_SFT -
+						   OSD_OSDWINADH_O1AH_SHIFT),
+				  OSD_OSDWINADH);
+			osd_write(sd, fb_offset_32 & OSD_OSDWIN1ADL_O1AL,
+				  OSD_OSDWIN1ADL);
+			break;
+		case WIN_VID1:
+			osd_modify(sd, OSD_VIDWINADH_V1AH,
+				  fb_offset_32 >> (OSD_SRCADD_ADD_SFT -
+						   OSD_VIDWINADH_V1AH_SHIFT),
+				  OSD_VIDWINADH);
+			osd_write(sd, fb_offset_32 & OSD_VIDWIN1ADL_V1AL,
+				  OSD_VIDWIN1ADL);
+			break;
+		}
+	} else if (sd->vpbe_type == VPBE_VERSION_2) {
+		struct osd_window_state *win = &sd->win[layer];
+		unsigned long fb_offset_32, cbcr_offset_32;
+
+		fb_offset_32 = fb_base_phys - DAVINCI_DDR_BASE;
+		if (cbcr_ofst)
+			cbcr_offset_32 = cbcr_ofst;
+		else
+			cbcr_offset_32 = win->lconfig.line_length *
+					 win->lconfig.ysize;
+		cbcr_offset_32 += fb_offset_32;
+		fb_offset_32 = fb_offset_32 >> 5;
+		cbcr_offset_32 = cbcr_offset_32 >> 5;
+		/*
+		 * DM365: start address is 27-bit long address b26 - b23 are
+		 * in offset register b12 - b9, and * bit 26 has to be '1'
+		 */
+		if (win->lconfig.pixfmt == PIXFMT_NV12) {
+			switch (layer) {
+			case WIN_VID0:
+			case WIN_VID1:
+				/* Y is in VID0 */
+				osd_modify(sd, OSD_VIDWIN0OFST_V0AH,
+					 ((fb_offset_32 & OSD_SRC_ADDR_HIGH4) >>
+					 (OSD_SRCADD_OFSET_SFT -
+					 OSD_WINOFST_AH_SHIFT)) |
+					 OSD_WINOFST_MASK, OSD_VIDWIN0OFST);
+				osd_modify(sd, OSD_VIDWINADH_V0AH,
+					  (fb_offset_32 & OSD_SRC_ADDR_HIGH7) >>
+					  (OSD_SRCADD_ADD_SFT -
+					  OSD_VIDWINADH_V0AH_SHIFT),
+					   OSD_VIDWINADH);
+				osd_write(sd, fb_offset_32 & OSD_WINADL_MASK,
+					  OSD_VIDWIN0ADL);
+				/* CbCr is in VID1 */
+				osd_modify(sd, OSD_VIDWIN1OFST_V1AH,
+					 ((cbcr_offset_32 &
+					 OSD_SRC_ADDR_HIGH4) >>
+					 (OSD_SRCADD_OFSET_SFT -
+					 OSD_WINOFST_AH_SHIFT)) |
+					 OSD_WINOFST_MASK, OSD_VIDWIN1OFST);
+				osd_modify(sd, OSD_VIDWINADH_V1AH,
+					  (cbcr_offset_32 &
+					  OSD_SRC_ADDR_HIGH7) >>
+					  (OSD_SRCADD_ADD_SFT -
+					  OSD_VIDWINADH_V1AH_SHIFT),
+					  OSD_VIDWINADH);
+				osd_write(sd, cbcr_offset_32 & OSD_WINADL_MASK,
+					  OSD_VIDWIN1ADL);
+				break;
+			default:
+				break;
+			}
+		}
+
+		switch (layer) {
+		case WIN_OSD0:
+			osd_modify(sd, OSD_OSDWIN0OFST_O0AH,
+				 ((fb_offset_32 & OSD_SRC_ADDR_HIGH4) >>
+				 (OSD_SRCADD_OFSET_SFT -
+				 OSD_WINOFST_AH_SHIFT)) | OSD_WINOFST_MASK,
+				  OSD_OSDWIN0OFST);
+			osd_modify(sd, OSD_OSDWINADH_O0AH,
+				 (fb_offset_32 & OSD_SRC_ADDR_HIGH7) >>
+				 (OSD_SRCADD_ADD_SFT -
+				 OSD_OSDWINADH_O0AH_SHIFT), OSD_OSDWINADH);
+			osd_write(sd, fb_offset_32 & OSD_WINADL_MASK,
+					OSD_OSDWIN0ADL);
+			break;
+		case WIN_VID0:
+			if (win->lconfig.pixfmt != PIXFMT_NV12) {
+				osd_modify(sd, OSD_VIDWIN0OFST_V0AH,
+					 ((fb_offset_32 & OSD_SRC_ADDR_HIGH4) >>
+					 (OSD_SRCADD_OFSET_SFT -
+					 OSD_WINOFST_AH_SHIFT)) |
+					 OSD_WINOFST_MASK, OSD_VIDWIN0OFST);
+				osd_modify(sd, OSD_VIDWINADH_V0AH,
+					  (fb_offset_32 & OSD_SRC_ADDR_HIGH7) >>
+					  (OSD_SRCADD_ADD_SFT -
+					  OSD_VIDWINADH_V0AH_SHIFT),
+					  OSD_VIDWINADH);
+				osd_write(sd, fb_offset_32 & OSD_WINADL_MASK,
+					  OSD_VIDWIN0ADL);
+			}
+			break;
+		case WIN_OSD1:
+			osd_modify(sd, OSD_OSDWIN1OFST_O1AH,
+				 ((fb_offset_32 & OSD_SRC_ADDR_HIGH4) >>
+				 (OSD_SRCADD_OFSET_SFT -
+				 OSD_WINOFST_AH_SHIFT)) | OSD_WINOFST_MASK,
+				  OSD_OSDWIN1OFST);
+			osd_modify(sd, OSD_OSDWINADH_O1AH,
+				  (fb_offset_32 & OSD_SRC_ADDR_HIGH7) >>
+				  (OSD_SRCADD_ADD_SFT -
+				  OSD_OSDWINADH_O1AH_SHIFT),
+				  OSD_OSDWINADH);
+			osd_write(sd, fb_offset_32 & OSD_WINADL_MASK,
+					OSD_OSDWIN1ADL);
+			break;
+		case WIN_VID1:
+			if (win->lconfig.pixfmt != PIXFMT_NV12) {
+				osd_modify(sd, OSD_VIDWIN1OFST_V1AH,
+					 ((fb_offset_32 & OSD_SRC_ADDR_HIGH4) >>
+					 (OSD_SRCADD_OFSET_SFT -
+					 OSD_WINOFST_AH_SHIFT)) |
+					 OSD_WINOFST_MASK, OSD_VIDWIN1OFST);
+				osd_modify(sd, OSD_VIDWINADH_V1AH,
+					  (fb_offset_32 & OSD_SRC_ADDR_HIGH7) >>
+					  (OSD_SRCADD_ADD_SFT -
+					  OSD_VIDWINADH_V1AH_SHIFT),
+					  OSD_VIDWINADH);
+				osd_write(sd, fb_offset_32 & OSD_WINADL_MASK,
+					  OSD_VIDWIN1ADL);
+			}
+			break;
+		}
 	}
 }
 
@@ -545,7 +786,7 @@ static int try_layer_config(struct osd_state *sd, enum osd_layer layer,
 {
 	struct osd_state *osd = sd;
 	struct osd_window_state *win = &osd->win[layer];
-	int bad_config;
+	int bad_config = 0;
 
 	/* verify that the pixel format is compatible with the layer */
 	switch (lconfig->pixfmt) {
@@ -554,17 +795,25 @@ static int try_layer_config(struct osd_state *sd, enum osd_layer layer,
 	case PIXFMT_4BPP:
 	case PIXFMT_8BPP:
 	case PIXFMT_RGB565:
-		bad_config = !is_osd_win(layer);
+		if (osd->vpbe_type == VPBE_VERSION_1)
+			bad_config = !is_vid_win(layer);
 		break;
 	case PIXFMT_YCbCrI:
 	case PIXFMT_YCrCbI:
 		bad_config = !is_vid_win(layer);
 		break;
 	case PIXFMT_RGB888:
-		bad_config = !is_vid_win(layer);
+		if (osd->vpbe_type == VPBE_VERSION_1)
+			bad_config = !is_vid_win(layer);
+		else if ((osd->vpbe_type == VPBE_VERSION_3) ||
+			 (osd->vpbe_type == VPBE_VERSION_2))
+			bad_config = !is_osd_win(layer);
 		break;
 	case PIXFMT_NV12:
-		bad_config = 1;
+		if (osd->vpbe_type != VPBE_VERSION_2)
+			bad_config = 1;
+		else
+			bad_config = is_osd_win(layer);
 		break;
 	case PIXFMT_OSD_ATTR:
 		bad_config = (layer != WIN_OSD1);
@@ -584,7 +833,8 @@ static int try_layer_config(struct osd_state *sd, enum osd_layer layer,
 
 	/* DM6446: */
 	/* only one OSD window at a time can use RGB pixel formats */
-	if (is_osd_win(layer) && is_rgb_pixfmt(lconfig->pixfmt)) {
+	  if ((osd->vpbe_type == VPBE_VERSION_1) &&
+		  is_osd_win(layer) && is_rgb_pixfmt(lconfig->pixfmt)) {
 		enum osd_pix_format pixfmt;
 		if (layer == WIN_OSD0)
 			pixfmt = osd->win[WIN_OSD1].lconfig.pixfmt;
@@ -602,7 +852,8 @@ static int try_layer_config(struct osd_state *sd, enum osd_layer layer,
 	}
 
 	/* DM6446: only one video window at a time can use RGB888 */
-	if (is_vid_win(layer) && lconfig->pixfmt == PIXFMT_RGB888) {
+	if ((osd->vpbe_type == VPBE_VERSION_1) && is_vid_win(layer) &&
+		lconfig->pixfmt == PIXFMT_RGB888) {
 		enum osd_pix_format pixfmt;
 
 		if (layer == WIN_VID0)
@@ -652,7 +903,8 @@ static void _osd_disable_vid_rgb888(struct osd_state *sd)
 	 * The caller must ensure that neither video window is currently
 	 * configured for RGB888 pixel format.
 	 */
-	osd_clear(sd, OSD_MISCCTL_RGBEN, OSD_MISCCTL);
+	if (sd->vpbe_type == VPBE_VERSION_1)
+		osd_clear(sd, OSD_MISCCTL_RGBEN, OSD_MISCCTL);
 }
 
 static void _osd_enable_vid_rgb888(struct osd_state *sd,
@@ -665,13 +917,15 @@ static void _osd_enable_vid_rgb888(struct osd_state *sd,
 	 * currently configured for RGB888 pixel format, as this routine will
 	 * disable RGB888 pixel format for the other window.
 	 */
-	if (layer == WIN_VID0) {
-		osd_modify(sd, OSD_MISCCTL_RGBEN | OSD_MISCCTL_RGBWIN,
-			  OSD_MISCCTL_RGBEN, OSD_MISCCTL);
-	} else if (layer == WIN_VID1) {
-		osd_modify(sd, OSD_MISCCTL_RGBEN | OSD_MISCCTL_RGBWIN,
-			  OSD_MISCCTL_RGBEN | OSD_MISCCTL_RGBWIN,
-			  OSD_MISCCTL);
+	if (sd->vpbe_type == VPBE_VERSION_1) {
+		if (layer == WIN_VID0) {
+			osd_modify(sd, OSD_MISCCTL_RGBEN | OSD_MISCCTL_RGBWIN,
+				  OSD_MISCCTL_RGBEN, OSD_MISCCTL);
+		} else if (layer == WIN_VID1) {
+			osd_modify(sd, OSD_MISCCTL_RGBEN | OSD_MISCCTL_RGBWIN,
+				  OSD_MISCCTL_RGBEN | OSD_MISCCTL_RGBWIN,
+				  OSD_MISCCTL);
+		}
 	}
 }
 
@@ -697,9 +951,30 @@ static void _osd_set_layer_config(struct osd_state *sd, enum osd_layer layer,
 
 	switch (layer) {
 	case WIN_OSD0:
-		winmd_mask |= OSD_OSDWIN0MD_RGB0E;
-		if (lconfig->pixfmt == PIXFMT_RGB565)
-			winmd |= OSD_OSDWIN0MD_RGB0E;
+		if (sd->vpbe_type == VPBE_VERSION_1) {
+			winmd_mask |= OSD_OSDWIN0MD_RGB0E;
+			if (lconfig->pixfmt == PIXFMT_RGB565)
+				winmd |= OSD_OSDWIN0MD_RGB0E;
+		} else if ((sd->vpbe_type == VPBE_VERSION_3) ||
+		  (sd->vpbe_type == VPBE_VERSION_2)) {
+			winmd_mask |= OSD_OSDWIN0MD_BMP0MD;
+			switch (lconfig->pixfmt) {
+			case PIXFMT_RGB565:
+					winmd |= (1 <<
+					OSD_OSDWIN0MD_BMP0MD_SHIFT);
+					break;
+			case PIXFMT_RGB888:
+				winmd |= (2 << OSD_OSDWIN0MD_BMP0MD_SHIFT);
+				_osd_enable_rgb888_pixblend(sd, OSDWIN_OSD0);
+				break;
+			case PIXFMT_YCbCrI:
+			case PIXFMT_YCrCbI:
+				winmd |= (3 << OSD_OSDWIN0MD_BMP0MD_SHIFT);
+				break;
+			default:
+				break;
+			}
+		}
 
 		winmd_mask |= OSD_OSDWIN0MD_BMW0 | OSD_OSDWIN0MD_OFF0;
 
@@ -749,12 +1024,58 @@ static void _osd_set_layer_config(struct osd_state *sd, enum osd_layer layer,
 		 * For YUV420P format the register contents are
 		 * duplicated in both VID registers
 		 */
+		if ((sd->vpbe_type == VPBE_VERSION_2) &&
+				(lconfig->pixfmt == PIXFMT_NV12)) {
+			/* other window also */
+			if (lconfig->interlaced) {
+				winmd_mask |= OSD_VIDWINMD_VFF1;
+				winmd |= OSD_VIDWINMD_VFF1;
+				osd_modify(sd, winmd_mask, winmd,
+					  OSD_VIDWINMD);
+			}
+
+			osd_modify(sd, OSD_MISCCTL_S420D,
+				    OSD_MISCCTL_S420D, OSD_MISCCTL);
+			osd_write(sd, lconfig->line_length >> 5,
+				  OSD_VIDWIN1OFST);
+			osd_write(sd, lconfig->xpos, OSD_VIDWIN1XP);
+			osd_write(sd, lconfig->xsize, OSD_VIDWIN1XL);
+			/*
+			  * if NV21 pixfmt and line length not 32B
+			  * aligned (e.g. NTSC), Need to set window
+			  * X pixel size to be 32B aligned as well
+			  */
+			if (lconfig->xsize % 32) {
+				osd_write(sd,
+					  ((lconfig->xsize + 31) & ~31),
+					  OSD_VIDWIN1XL);
+				osd_write(sd,
+					  ((lconfig->xsize + 31) & ~31),
+					  OSD_VIDWIN0XL);
+			}
+		} else if ((sd->vpbe_type == VPBE_VERSION_2) &&
+				(lconfig->pixfmt != PIXFMT_NV12))
+			osd_modify(sd, OSD_MISCCTL_S420D, ~OSD_MISCCTL_S420D,
+						OSD_MISCCTL);
+
 		if (lconfig->interlaced) {
 			osd_write(sd, lconfig->ypos >> 1, OSD_VIDWIN0YP);
 			osd_write(sd, lconfig->ysize >> 1, OSD_VIDWIN0YL);
+			if ((sd->vpbe_type == VPBE_VERSION_2) &&
+				lconfig->pixfmt == PIXFMT_NV12) {
+				osd_write(sd, lconfig->ypos >> 1,
+					  OSD_VIDWIN1YP);
+				osd_write(sd, lconfig->ysize >> 1,
+					  OSD_VIDWIN1YL);
+			}
 		} else {
 			osd_write(sd, lconfig->ypos, OSD_VIDWIN0YP);
 			osd_write(sd, lconfig->ysize, OSD_VIDWIN0YL);
+			if ((sd->vpbe_type == VPBE_VERSION_2) &&
+				lconfig->pixfmt == PIXFMT_NV12) {
+				osd_write(sd, lconfig->ypos, OSD_VIDWIN1YP);
+				osd_write(sd, lconfig->ysize, OSD_VIDWIN1YL);
+			}
 		}
 		break;
 	case WIN_OSD1:
@@ -764,14 +1085,43 @@ static void _osd_set_layer_config(struct osd_state *sd, enum osd_layer layer,
 		 * attribute mode to a normal mode.
 		 */
 		if (lconfig->pixfmt == PIXFMT_OSD_ATTR) {
-			winmd_mask |=
-			    OSD_OSDWIN1MD_ATN1E | OSD_OSDWIN1MD_RGB1E |
-			    OSD_OSDWIN1MD_CLUTS1 |
-			    OSD_OSDWIN1MD_BLND1 | OSD_OSDWIN1MD_TE1;
+			if (sd->vpbe_type == VPBE_VERSION_1) {
+				winmd_mask |= OSD_OSDWIN1MD_ATN1E |
+				OSD_OSDWIN1MD_RGB1E | OSD_OSDWIN1MD_CLUTS1 |
+				OSD_OSDWIN1MD_BLND1 | OSD_OSDWIN1MD_TE1;
+			} else {
+				winmd_mask |= OSD_OSDWIN1MD_BMP1MD |
+				OSD_OSDWIN1MD_CLUTS1 | OSD_OSDWIN1MD_BLND1 |
+				OSD_OSDWIN1MD_TE1;
+			}
 		} else {
-			winmd_mask |= OSD_OSDWIN1MD_RGB1E;
-			if (lconfig->pixfmt == PIXFMT_RGB565)
-				winmd |= OSD_OSDWIN1MD_RGB1E;
+			if (sd->vpbe_type == VPBE_VERSION_1) {
+				winmd_mask |= OSD_OSDWIN1MD_RGB1E;
+				if (lconfig->pixfmt == PIXFMT_RGB565)
+					winmd |= OSD_OSDWIN1MD_RGB1E;
+			} else if ((sd->vpbe_type == VPBE_VERSION_3)
+				   || (sd->vpbe_type == VPBE_VERSION_2)) {
+				winmd_mask |= OSD_OSDWIN1MD_BMP1MD;
+				switch (lconfig->pixfmt) {
+				case PIXFMT_RGB565:
+					winmd |=
+					    (1 << OSD_OSDWIN1MD_BMP1MD_SHIFT);
+					break;
+				case PIXFMT_RGB888:
+					winmd |=
+					    (2 << OSD_OSDWIN1MD_BMP1MD_SHIFT);
+					_osd_enable_rgb888_pixblend(sd,
+							OSDWIN_OSD1);
+					break;
+				case PIXFMT_YCbCrI:
+				case PIXFMT_YCrCbI:
+					winmd |=
+					    (3 << OSD_OSDWIN1MD_BMP1MD_SHIFT);
+					break;
+				default:
+					break;
+				}
+			}
 
 			winmd_mask |= OSD_OSDWIN1MD_BMW1;
 			switch (lconfig->pixfmt) {
@@ -822,15 +1172,44 @@ static void _osd_set_layer_config(struct osd_state *sd, enum osd_layer layer,
 		 * For YUV420P format the register contents are
 		 * duplicated in both VID registers
 		 */
-		osd_modify(sd, OSD_MISCCTL_S420D, ~OSD_MISCCTL_S420D,
-			   OSD_MISCCTL);
+		if (sd->vpbe_type == VPBE_VERSION_2) {
+			if (lconfig->pixfmt == PIXFMT_NV12) {
+				/* other window also */
+				if (lconfig->interlaced) {
+					winmd_mask |= OSD_VIDWINMD_VFF0;
+					winmd |= OSD_VIDWINMD_VFF0;
+					osd_modify(sd, winmd_mask, winmd,
+						  OSD_VIDWINMD);
+				}
+				osd_modify(sd, OSD_MISCCTL_S420D,
+					   OSD_MISCCTL_S420D, OSD_MISCCTL);
+				osd_write(sd, lconfig->line_length >> 5,
+					  OSD_VIDWIN0OFST);
+				osd_write(sd, lconfig->xpos, OSD_VIDWIN0XP);
+				osd_write(sd, lconfig->xsize, OSD_VIDWIN0XL);
+			} else
+				osd_modify(sd, OSD_MISCCTL_S420D,
+					   ~OSD_MISCCTL_S420D, OSD_MISCCTL);
+		}
 
 		if (lconfig->interlaced) {
 			osd_write(sd, lconfig->ypos >> 1, OSD_VIDWIN1YP);
 			osd_write(sd, lconfig->ysize >> 1, OSD_VIDWIN1YL);
+			if ((sd->vpbe_type == VPBE_VERSION_2) &&
+				lconfig->pixfmt == PIXFMT_NV12) {
+				osd_write(sd, lconfig->ypos >> 1,
+					  OSD_VIDWIN0YP);
+				osd_write(sd, lconfig->ysize >> 1,
+					  OSD_VIDWIN0YL);
+			}
 		} else {
 			osd_write(sd, lconfig->ypos, OSD_VIDWIN1YP);
 			osd_write(sd, lconfig->ysize, OSD_VIDWIN1YL);
+			if ((sd->vpbe_type == VPBE_VERSION_2) &&
+				lconfig->pixfmt == PIXFMT_NV12) {
+				osd_write(sd, lconfig->ypos, OSD_VIDWIN0YP);
+				osd_write(sd, lconfig->ysize, OSD_VIDWIN0YL);
+			}
 		}
 		break;
 	}
@@ -1089,6 +1468,11 @@ static void _osd_init(struct osd_state *sd)
 	osd_write(sd, 0, OSD_OSDWIN1MD);
 	osd_write(sd, 0, OSD_RECTCUR);
 	osd_write(sd, 0, OSD_MISCCTL);
+	if (sd->vpbe_type == VPBE_VERSION_3) {
+		osd_write(sd, 0, OSD_VBNDRY);
+		osd_write(sd, 0, OSD_EXTMODE);
+		osd_write(sd, OSD_MISCCTL_DMANG, OSD_MISCCTL);
+	}
 }
 
 static void osd_set_left_margin(struct osd_state *sd, u32 val)
@@ -1110,6 +1494,14 @@ static int osd_initialize(struct osd_state *osd)
 	/* set default Cb/Cr order */
 	osd->yc_pixfmt = PIXFMT_YCbCrI;
 
+	if (osd->vpbe_type == VPBE_VERSION_3) {
+		/*
+		 * ROM CLUT1 on the DM355 is similar (identical?) to ROM CLUT0
+		 * on the DM6446, so make ROM_CLUT1 the default on the DM355.
+		 */
+		osd->rom_clut = ROM_CLUT1;
+	}
+
 	_osd_set_field_inversion(osd, osd->field_inversion);
 	_osd_set_rom_clut(osd, osd->rom_clut);
 
-- 
1.6.2.4

