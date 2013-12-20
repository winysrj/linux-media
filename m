Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3122 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756099Ab3LTJcM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Dec 2013 04:32:12 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 50/50] adv7842: add drive strength enum and sync names with adv7604.
Date: Fri, 20 Dec 2013 10:31:43 +0100
Message-Id: <1387531903-20496-51-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
References: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add a proper driver strength enum and use the same names in the platform
data as with adv7604.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7842.c |  7 ++++---
 include/media/adv7842.h     | 15 ++++++++++-----
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 515a870..1effc21 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -2541,9 +2541,10 @@ static int adv7842_core_init(struct v4l2_subdev *sd)
 	hdmi_write_and_or(sd, 0x1a, 0xf1, 0x08); /* Wait 1 s before unmute */
 
 	/* Drive strength */
-	io_write_and_or(sd, 0x14, 0xc0, pdata->drive_strength.data<<4 |
-			pdata->drive_strength.clock<<2 |
-			pdata->drive_strength.sync);
+	io_write_and_or(sd, 0x14, 0xc0,
+			pdata->dr_str_data << 4 |
+			pdata->dr_str_clk << 2 |
+			pdata->dr_str_sync);
 
 	/* HDMI free run */
 	cp_write_and_or(sd, 0xba, 0xfc, pdata->hdmi_free_run_enable |
diff --git a/include/media/adv7842.h b/include/media/adv7842.h
index d72a8a7..3932209 100644
--- a/include/media/adv7842.h
+++ b/include/media/adv7842.h
@@ -108,6 +108,13 @@ enum adv7842_select_input {
 	ADV7842_SELECT_SDP_YC,
 };
 
+enum adv7842_drive_strength {
+	ADV7842_DR_STR_LOW = 0,
+	ADV7842_DR_STR_MEDIUM_LOW = 1,
+	ADV7842_DR_STR_MEDIUM_HIGH = 2,
+	ADV7842_DR_STR_HIGH = 3,
+};
+
 struct adv7842_sdp_csc_coeff {
 	bool manual;
 	uint16_t scaling;
@@ -186,11 +193,9 @@ struct adv7842_platform_data {
 	unsigned output_bus_lsb_to_msb:1;
 
 	/* IO register 0x14 */
-	struct {
-		unsigned data:2;
-		unsigned clock:2;
-		unsigned sync:2;
-	} drive_strength;
+	enum adv7842_drive_strength dr_str_data;
+	enum adv7842_drive_strength dr_str_clk;
+	enum adv7842_drive_strength dr_str_sync;
 
 	/*
 	 * IO register 0x19: Adjustment to the LLC DLL phase in
-- 
1.8.4.4

