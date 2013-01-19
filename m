Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f48.google.com ([209.85.216.48]:64356 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269Ab3ASXmh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Jan 2013 18:42:37 -0500
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: brijohn@gmail.com
Cc: hdegoede@redhat.com, mchehab@redhat.com,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org,
	Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH V2 14/24] usb/gspca/sn9c20x.c: use IS_ENABLED() macro
Date: Sat, 19 Jan 2013 21:41:21 -0200
Message-Id: <1358638891-4775-15-git-send-email-peter.senna@gmail.com>
In-Reply-To: <1358638891-4775-1-git-send-email-peter.senna@gmail.com>
References: <1358638891-4775-1-git-send-email-peter.senna@gmail.com>
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
Changes from V1:
   Updated subject

 drivers/media/usb/gspca/sn9c20x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/gspca/sn9c20x.c b/drivers/media/usb/gspca/sn9c20x.c
index 41f769f..4ec544f 100644
--- a/drivers/media/usb/gspca/sn9c20x.c
+++ b/drivers/media/usb/gspca/sn9c20x.c
@@ -2205,7 +2205,7 @@ static void qual_upd(struct work_struct *work)
 	mutex_unlock(&gspca_dev->usb_lock);
 }
 
-#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
+#if IS_ENABLED(CONFIG_INPUT)
 static int sd_int_pkt_scan(struct gspca_dev *gspca_dev,
 			u8 *data,		/* interrupt packet */
 			int len)		/* interrupt packet length */
@@ -2349,7 +2349,7 @@ static const struct sd_desc sd_desc = {
 	.stopN = sd_stopN,
 	.stop0 = sd_stop0,
 	.pkt_scan = sd_pkt_scan,
-#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
+#if IS_ENABLED(CONFIG_INPUT)
 	.int_pkt_scan = sd_int_pkt_scan,
 #endif
 	.dq_callback = sd_dqcallback,
-- 
1.7.11.7

