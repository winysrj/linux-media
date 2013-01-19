Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f171.google.com ([209.85.216.171]:56083 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211Ab3ASXm0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Jan 2013 18:42:26 -0500
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: hdegoede@redhat.com
Cc: mchehab@redhat.com, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH V2 10/24] usb/gspca/pac207.c: use IS_ENABLED() macro
Date: Sat, 19 Jan 2013 21:41:17 -0200
Message-Id: <1358638891-4775-11-git-send-email-peter.senna@gmail.com>
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

 drivers/media/usb/gspca/pac207.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/gspca/pac207.c b/drivers/media/usb/gspca/pac207.c
index 1f253df..3b75097 100644
--- a/drivers/media/usb/gspca/pac207.c
+++ b/drivers/media/usb/gspca/pac207.c
@@ -413,7 +413,7 @@ static void sd_pkt_scan(struct gspca_dev *gspca_dev,
 	gspca_frame_add(gspca_dev, INTER_PACKET, data, len);
 }
 
-#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
+#if IS_ENABLED(CONFIG_INPUT)
 static int sd_int_pkt_scan(struct gspca_dev *gspca_dev,
 			u8 *data,		/* interrupt packet data */
 			int len)		/* interrput packet length */
@@ -442,7 +442,7 @@ static const struct sd_desc sd_desc = {
 	.stopN = sd_stopN,
 	.dq_callback = pac207_do_auto_gain,
 	.pkt_scan = sd_pkt_scan,
-#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
+#if IS_ENABLED(CONFIG_INPUT)
 	.int_pkt_scan = sd_int_pkt_scan,
 #endif
 };
-- 
1.7.11.7

