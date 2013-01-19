Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f171.google.com ([209.85.216.171]:57717 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab3ASQer (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Jan 2013 11:34:47 -0500
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: lcostantino@gmail.com
Cc: hdegoede@redhat.com, mchehab@redhat.com,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org,
	Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 19/24] use IS_ENABLED() macro
Date: Sat, 19 Jan 2013 14:33:21 -0200
Message-Id: <1358613206-4274-18-git-send-email-peter.senna@gmail.com>
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
 drivers/media/usb/gspca/t613.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/gspca/t613.c b/drivers/media/usb/gspca/t613.c
index b92d4ef..e2cc4e5 100644
--- a/drivers/media/usb/gspca/t613.c
+++ b/drivers/media/usb/gspca/t613.c
@@ -823,7 +823,7 @@ static void sd_stopN(struct gspca_dev *gspca_dev)
 		msleep(20);
 		reg_w(gspca_dev, 0x0309);
 	}
-#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
+#if IS_ENABLED(CONFIG_INPUT)
 	/* If the last button state is pressed, release it now! */
 	if (sd->button_pressed) {
 		input_report_key(gspca_dev->input_dev, KEY_CAMERA, 0);
@@ -841,7 +841,7 @@ static void sd_pkt_scan(struct gspca_dev *gspca_dev,
 	int pkt_type;
 
 	if (data[0] == 0x5a) {
-#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
+#if IS_ENABLED(CONFIG_INPUT)
 		if (len > 20) {
 			u8 state = (data[20] & 0x80) ? 1 : 0;
 			if (sd->button_pressed != state) {
@@ -1019,7 +1019,7 @@ static const struct sd_desc sd_desc = {
 	.start = sd_start,
 	.stopN = sd_stopN,
 	.pkt_scan = sd_pkt_scan,
-#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
+#if IS_ENABLED(CONFIG_INPUT)
 	.other_input = 1,
 #endif
 };
-- 
1.7.11.7

