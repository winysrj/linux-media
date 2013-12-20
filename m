Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3595 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756115Ab3LTJcM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Dec 2013 04:32:12 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Martin Bugge <marbugge@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>
Subject: [REVIEW PATCH 45/50] adv7842: obtain free-run mode from the platform_data.
Date: Fri, 20 Dec 2013 10:31:38 +0100
Message-Id: <1387531903-20496-46-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
References: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Martin Bugge <marbugge@cisco.com>

The free-run mode can be board-specific.

Also updated the platform_data in ezkit to ensure that what was the old
default value is now explicitly specified, so the behavior for that board
is unchanged.

Signed-off-by: Martin Bugge <marbugge@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Scott Jiang <scott.jiang.linux@gmail.com>
---
 arch/blackfin/mach-bf609/boards/ezkit.c |  2 ++
 drivers/media/i2c/adv7842.c             | 11 ++++++++---
 include/media/adv7842.h                 | 14 ++++++++++++--
 3 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/arch/blackfin/mach-bf609/boards/ezkit.c b/arch/blackfin/mach-bf609/boards/ezkit.c
index 28bdd8b..39a7969 100644
--- a/arch/blackfin/mach-bf609/boards/ezkit.c
+++ b/arch/blackfin/mach-bf609/boards/ezkit.c
@@ -1025,6 +1025,8 @@ static struct adv7842_platform_data adv7842_data = {
 	.ain_sel = ADV7842_AIN10_11_12_NC_SYNC_4_1,
 	.prim_mode = ADV7842_PRIM_MODE_SDP,
 	.vid_std_select = ADV7842_SDP_VID_STD_CVBS_SD_4x1,
+	.hdmi_free_run_enable = 1,
+	.sdp_free_run_auto = 1,
 	.i2c_sdp_io = 0x40,
 	.i2c_sdp = 0x41,
 	.i2c_cp = 0x42,
diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index ecbe3f2..518f1e2 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -1624,8 +1624,6 @@ static void select_input(struct v4l2_subdev *sd,
 		/* deinterlacer enabled and 3D comb */
 		sdp_write_and_or(sd, 0x12, 0xf6, 0x09);
 
-		sdp_write(sd, 0xdd, 0x08); /* free run auto */
-
 		break;
 
 	case ADV7842_MODE_COMP:
@@ -2538,7 +2536,14 @@ static int adv7842_core_init(struct v4l2_subdev *sd)
 			pdata->drive_strength.sync);
 
 	/* HDMI free run */
-	cp_write(sd, 0xba, (pdata->hdmi_free_run_mode << 1) | 0x01);
+	cp_write_and_or(sd, 0xba, 0xfc, pdata->hdmi_free_run_enable |
+					(pdata->hdmi_free_run_mode << 1));
+
+	/* SPD free run */
+	sdp_write_and_or(sd, 0xdd, 0xf0, pdata->sdp_free_run_force |
+					 (pdata->sdp_free_run_cbar_en << 1) |
+					 (pdata->sdp_free_run_man_col_en << 2) |
+					 (pdata->sdp_free_run_force << 3));
 
 	/* TODO from platform data */
 	cp_write(sd, 0x69, 0x14);   /* Enable CP CSC */
diff --git a/include/media/adv7842.h b/include/media/adv7842.h
index a4851bf..772cdec 100644
--- a/include/media/adv7842.h
+++ b/include/media/adv7842.h
@@ -192,8 +192,18 @@ struct adv7842_platform_data {
 	unsigned sd_ram_size; /* ram size in MB */
 	unsigned sd_ram_ddr:1; /* ddr or sdr sdram */
 
-	/* Free run */
-	unsigned hdmi_free_run_mode;
+	/* HDMI free run, CP-reg 0xBA */
+	unsigned hdmi_free_run_enable:1;
+	/* 0 = Mode 0: run when there is no TMDS clock
+	   1 = Mode 1: run when there is no TMDS clock or the
+	       video resolution does not match programmed one. */
+	unsigned hdmi_free_run_mode:1;
+
+	/* SDP free run, CP-reg 0xDD */
+	unsigned sdp_free_run_auto:1;
+	unsigned sdp_free_run_man_col_en:1;
+	unsigned sdp_free_run_cbar_en:1;
+	unsigned sdp_free_run_force:1;
 
 	struct adv7842_sdp_csc_coeff sdp_csc_coeff;
 
-- 
1.8.4.4

