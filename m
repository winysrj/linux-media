Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f182.google.com ([209.85.216.182]:64691 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab3ASQeV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Jan 2013 11:34:21 -0500
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: hdegoede@redhat.com
Cc: mchehab@redhat.com, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 09/24] use IS_ENABLED() macro
Date: Sat, 19 Jan 2013 14:33:12 -0200
Message-Id: <1358613206-4274-9-git-send-email-peter.senna@gmail.com>
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
 drivers/media/usb/gspca/ov519.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/gspca/ov519.c b/drivers/media/usb/gspca/ov519.c
index 9aa09f8..9ad19a7 100644
--- a/drivers/media/usb/gspca/ov519.c
+++ b/drivers/media/usb/gspca/ov519.c
@@ -4238,7 +4238,7 @@ static void sd_stop0(struct gspca_dev *gspca_dev)
 	if (sd->bridge == BRIDGE_W9968CF)
 		w9968cf_stop0(sd);
 
-#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
+#if IS_ENABLED(CONFIG_INPUT)
 	/* If the last button state is pressed, release it now! */
 	if (sd->snapshot_pressed) {
 		input_report_key(gspca_dev->input_dev, KEY_CAMERA, 0);
@@ -4255,7 +4255,7 @@ static void ov51x_handle_button(struct gspca_dev *gspca_dev, u8 state)
 	struct sd *sd = (struct sd *) gspca_dev;
 
 	if (sd->snapshot_pressed != state) {
-#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
+#if IS_ENABLED(CONFIG_INPUT)
 		input_report_key(gspca_dev->input_dev, KEY_CAMERA, state);
 		input_sync(gspca_dev->input_dev);
 #endif
@@ -4924,7 +4924,7 @@ static const struct sd_desc sd_desc = {
 	.dq_callback = sd_reset_snapshot,
 	.get_jcomp = sd_get_jcomp,
 	.set_jcomp = sd_set_jcomp,
-#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
+#if IS_ENABLED(CONFIG_INPUT)
 	.other_input = 1,
 #endif
 };
-- 
1.7.11.7

