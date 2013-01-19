Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f172.google.com ([209.85.216.172]:52205 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab3ASQek (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Jan 2013 11:34:40 -0500
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: hdegoede@redhat.com
Cc: mchehab@redhat.com, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 17/24] use IS_ENABLED() macro
Date: Sat, 19 Jan 2013 14:33:19 -0200
Message-Id: <1358613206-4274-16-git-send-email-peter.senna@gmail.com>
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
 drivers/media/usb/gspca/spca561.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/gspca/spca561.c b/drivers/media/usb/gspca/spca561.c
index cfe71dd..d1db3d8 100644
--- a/drivers/media/usb/gspca/spca561.c
+++ b/drivers/media/usb/gspca/spca561.c
@@ -741,7 +741,7 @@ static void sd_pkt_scan(struct gspca_dev *gspca_dev,
 			return;
 		}
 
-#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
+#if IS_ENABLED(CONFIG_INPUT)
 		if (data[0] & 0x20) {
 			input_report_key(gspca_dev->input_dev, KEY_CAMERA, 1);
 			input_sync(gspca_dev->input_dev);
@@ -866,7 +866,7 @@ static const struct sd_desc sd_desc_12a = {
 	.start = sd_start_12a,
 	.stopN = sd_stopN,
 	.pkt_scan = sd_pkt_scan,
-#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
+#if IS_ENABLED(CONFIG_INPUT)
 	.other_input = 1,
 #endif
 };
@@ -879,7 +879,7 @@ static const struct sd_desc sd_desc_72a = {
 	.stopN = sd_stopN,
 	.pkt_scan = sd_pkt_scan,
 	.dq_callback = do_autogain,
-#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
+#if IS_ENABLED(CONFIG_INPUT)
 	.other_input = 1,
 #endif
 };
-- 
1.7.11.7

