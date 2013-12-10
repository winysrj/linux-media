Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3984 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158Ab3LJPGM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Dec 2013 10:06:12 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Martin Bugge <marbugge@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 21/22] adv7842: obtain free-run mode from the platform_data.
Date: Tue, 10 Dec 2013 16:04:07 +0100
Message-Id: <2a70c88bfd43fba42c714f0bf7278d1c74a63085.1386687810.git.hans.verkuil@cisco.com>
In-Reply-To: <1386687848-21265-1-git-send-email-hverkuil@xs4all.nl>
References: <1386687848-21265-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <0b624eb4cc9c2b7c88323771dca10c503785fcb7.1386687810.git.hans.verkuil@cisco.com>
References: <0b624eb4cc9c2b7c88323771dca10c503785fcb7.1386687810.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Martin Bugge <marbugge@cisco.com>

The free-run mode can be board-specific.

Signed-off-by: Martin Bugge <marbugge@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7842.c | 7 ++++---
 include/media/adv7842.h     | 7 +++++--
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 8b4e369..fac5c4f 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -1622,8 +1622,6 @@ static void select_input(struct v4l2_subdev *sd,
 		/* deinterlacer enabled and 3D comb */
 		sdp_write_and_or(sd, 0x12, 0xf6, 0x09);
 
-		sdp_write(sd, 0xdd, 0x08); /* free run auto */
-
 		break;
 
 	case ADV7842_MODE_COMP:
@@ -2536,7 +2534,10 @@ static int adv7842_core_init(struct v4l2_subdev *sd)
 			pdata->drive_strength.sync);
 
 	/* HDMI free run */
-	cp_write(sd, 0xba, (pdata->hdmi_free_run_mode << 1) | 0x01);
+	cp_write_and_or(sd, 0xba, 0xfc, pdata->hdmi_free_run & 0x03);
+
+	/* SPD free run */
+	sdp_write_and_or(sd, 0xdd, 0xf0, pdata->sdp_free_run & 0x0f);
 
 	/* TODO from platform data */
 	cp_write(sd, 0x69, 0x14);   /* Enable CP CSC */
diff --git a/include/media/adv7842.h b/include/media/adv7842.h
index a4851bf..4e36496 100644
--- a/include/media/adv7842.h
+++ b/include/media/adv7842.h
@@ -192,8 +192,11 @@ struct adv7842_platform_data {
 	unsigned sd_ram_size; /* ram size in MB */
 	unsigned sd_ram_ddr:1; /* ddr or sdr sdram */
 
-	/* Free run */
-	unsigned hdmi_free_run_mode;
+	/* HDMI free run, CP-reg 0xBA */
+	unsigned hdmi_free_run;
+
+	/* SDP free run, CP-reg 0xDD */
+	unsigned sdp_free_run;
 
 	struct adv7842_sdp_csc_coeff sdp_csc_coeff;
 
-- 
1.8.4.rc3

