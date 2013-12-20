Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2384 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756113Ab3LTJcM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Dec 2013 04:32:12 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>
Subject: [REVIEW PATCH 48/50] adv7842: set LLC DLL phase from platform_data
Date: Fri, 20 Dec 2013 10:31:41 +0100
Message-Id: <1387531903-20496-49-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
References: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The correct LLC DLL phase depends on the board layout, so this
should be part of the platform_data.

Also updated the platform_data in ezkit to ensure that what was the old
default value is now explicitly specified, so the behavior for that board
is unchanged.

Tested-by: Martin Bugge <marbugge@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Scott Jiang <scott.jiang.linux@gmail.com>
---
 arch/blackfin/mach-bf609/boards/ezkit.c | 1 +
 drivers/media/i2c/adv7842.c             | 6 +-----
 include/media/adv7842.h                 | 6 ++++++
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/blackfin/mach-bf609/boards/ezkit.c b/arch/blackfin/mach-bf609/boards/ezkit.c
index 39a7969..66e9edb 100644
--- a/arch/blackfin/mach-bf609/boards/ezkit.c
+++ b/arch/blackfin/mach-bf609/boards/ezkit.c
@@ -1027,6 +1027,7 @@ static struct adv7842_platform_data adv7842_data = {
 	.vid_std_select = ADV7842_SDP_VID_STD_CVBS_SD_4x1,
 	.hdmi_free_run_enable = 1,
 	.sdp_free_run_auto = 1,
+	.llc_dll_phase = 0x10,
 	.i2c_sdp_io = 0x40,
 	.i2c_sdp = 0x41,
 	.i2c_cp = 0x42,
diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index c697117..7898686 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -1593,9 +1593,6 @@ static void select_input(struct v4l2_subdev *sd,
 		afe_write(sd, 0x00, 0x00); /* power up ADC */
 		afe_write(sd, 0xc8, 0x00); /* phase control */
 
-		io_write(sd, 0x19, 0x83); /* LLC DLL phase */
-		io_write(sd, 0x33, 0x40); /* LLC DLL enable */
-
 		io_write(sd, 0xdd, 0x90); /* Manual 2x output clock */
 		/* script says register 0xde, which don't exist in manual */
 
@@ -2609,8 +2606,7 @@ static int adv7842_core_init(struct v4l2_subdev *sd)
 	io_write_and_or(sd, 0x20, 0xcf, 0x00);
 
 	/* LLC */
-	/* Set phase to 16. TODO: get this from platform_data */
-	io_write(sd, 0x19, 0x90);
+	io_write(sd, 0x19, 0x80 | pdata->llc_dll_phase);
 	io_write(sd, 0x33, 0x40);
 
 	/* interrupts */
diff --git a/include/media/adv7842.h b/include/media/adv7842.h
index 5a7eb50..d72a8a7 100644
--- a/include/media/adv7842.h
+++ b/include/media/adv7842.h
@@ -192,6 +192,12 @@ struct adv7842_platform_data {
 		unsigned sync:2;
 	} drive_strength;
 
+	/*
+	 * IO register 0x19: Adjustment to the LLC DLL phase in
+	 * increments of 1/32 of a clock period.
+	 */
+	unsigned llc_dll_phase:5;
+
 	/* External RAM for 3-D comb or frame synchronizer */
 	unsigned sd_ram_size; /* ram size in MB */
 	unsigned sd_ram_ddr:1; /* ddr or sdr sdram */
-- 
1.8.4.4

