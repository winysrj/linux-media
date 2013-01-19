Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f178.google.com ([209.85.216.178]:60027 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab3ASQeu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Jan 2013 11:34:50 -0500
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: hdegoede@redhat.com
Cc: mchehab@redhat.com, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 20/24] use IS_ENABLED() macro
Date: Sat, 19 Jan 2013 14:33:22 -0200
Message-Id: <1358613206-4274-19-git-send-email-peter.senna@gmail.com>
In-Reply-To: <1358613206-4274-1-git-send-email-peter.senna@gmail.com>
References: <1358613206-4274-1-git-send-email-peter.senna@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

replace:
 #if defined(CONFIG_INPUT) || \
     defined(CONFIG_INPUT_MODULE)
with:
 #if IS_ENABLED(CONFIG_INPUT)

This change was made for: CONFIG_INPUT

Reported-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 drivers/media/usb/gspca/xirlink_cit.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/gspca/xirlink_cit.c b/drivers/media/usb/gspca/xirlink_cit.c
index d4b23c9..7eaf64e 100644
--- a/drivers/media/usb/gspca/xirlink_cit.c
+++ b/drivers/media/usb/gspca/xirlink_cit.c
@@ -2759,7 +2759,7 @@ static void sd_stop0(struct gspca_dev *gspca_dev)
 		break;
 	}
 
-#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
+#if IS_ENABLED(CONFIG_INPUT)
 	/* If the last button state is pressed, release it now! */
 	if (sd->button_state) {
 		input_report_key(gspca_dev->input_dev, KEY_CAMERA, 0);
@@ -2914,7 +2914,7 @@ static void sd_pkt_scan(struct gspca_dev *gspca_dev,
 	gspca_frame_add(gspca_dev, INTER_PACKET, data, len);
 }
 
-#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
+#if IS_ENABLED(CONFIG_INPUT)
 static void cit_check_button(struct gspca_dev *gspca_dev)
 {
 	int new_button_state;
@@ -3062,7 +3062,7 @@ static const struct sd_desc sd_desc = {
 	.stopN = sd_stopN,
 	.stop0 = sd_stop0,
 	.pkt_scan = sd_pkt_scan,
-#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
+#if IS_ENABLED(CONFIG_INPUT)
 	.dq_callback = cit_check_button,
 	.other_input = 1,
 #endif
@@ -3079,7 +3079,7 @@ static const struct sd_desc sd_desc_isoc_nego = {
 	.stopN = sd_stopN,
 	.stop0 = sd_stop0,
 	.pkt_scan = sd_pkt_scan,
-#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
+#if IS_ENABLED(CONFIG_INPUT)
 	.dq_callback = cit_check_button,
 	.other_input = 1,
 #endif
-- 
1.7.11.7

