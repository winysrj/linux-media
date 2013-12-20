Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3235 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755957Ab3LTJcA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Dec 2013 04:32:00 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mikhail Khelik <mkhelik@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 09/50] adv7604: add hdmi driver strength adjustment
Date: Fri, 20 Dec 2013 10:31:02 +0100
Message-Id: <1387531903-20496-10-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
References: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mikhail Khelik <mkhelik@cisco.com>

The driver strength is board dependent, so set it from the platform_data.

Signed-off-by: Mikhail Khelik <mkhelik@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7604.c |  7 ++++++-
 include/media/adv7604.h     | 11 +++++++++++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 6372d31..00ce271 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -1942,7 +1942,12 @@ static int adv7604_core_init(struct v4l2_subdev *sd)
 	/* TODO from platform data */
 	cp_write(sd, 0x69, 0x30);   /* Enable CP CSC */
 	io_write(sd, 0x06, 0xa6);   /* positive VS and HS */
-	io_write(sd, 0x14, 0x7f);   /* Drive strength adjusted to max */
+
+	/* Adjust drive strength */
+	io_write(sd, 0x14, 0x40 | pdata->dr_str_data << 4 |
+				pdata->dr_str_clk << 2 |
+				pdata->dr_str_sync);
+
 	cp_write(sd, 0xba, (pdata->hdmi_free_run_mode << 1) | 0x01); /* HDMI free run */
 	cp_write(sd, 0xf3, 0xdc); /* Low threshold to enter/exit free run mode */
 	cp_write(sd, 0xf9, 0x23); /*  STDI ch. 1 - LCVS change threshold -
diff --git a/include/media/adv7604.h b/include/media/adv7604.h
index 0c96e16..22fd1ac 100644
--- a/include/media/adv7604.h
+++ b/include/media/adv7604.h
@@ -78,6 +78,12 @@ enum adv7604_op_format_sel {
 	ADV7604_OP_FORMAT_SEL_SDR_ITU656_24_MODE2 = 0x8a,
 };
 
+enum adv7604_drive_strength {
+	ADV7604_DR_STR_MEDIUM_LOW = 1,
+	ADV7604_DR_STR_MEDIUM_HIGH = 2,
+	ADV7604_DR_STR_HIGH = 3,
+};
+
 /* Platform dependent definition */
 struct adv7604_platform_data {
 	/* connector - HDMI or DVI? */
@@ -110,6 +116,11 @@ struct adv7604_platform_data {
 	unsigned replicate_av_codes:1;
 	unsigned invert_cbcr:1;
 
+	/* IO register 0x14 */
+	enum adv7604_drive_strength dr_str_data;
+	enum adv7604_drive_strength dr_str_clk;
+	enum adv7604_drive_strength dr_str_sync;
+
 	/* IO register 0x30 */
 	unsigned output_bus_lsb_to_msb:1;
 
-- 
1.8.4.4

