Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f49.google.com ([209.85.216.49]:39756 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240Ab3ASXmb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Jan 2013 18:42:31 -0500
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: hdegoede@redhat.com
Cc: mchehab@redhat.com, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH V2 12/24] usb/gspca/pac7311.c: use IS_ENABLED() macro
Date: Sat, 19 Jan 2013 21:41:19 -0200
Message-Id: <1358638891-4775-13-git-send-email-peter.senna@gmail.com>
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

 drivers/media/usb/gspca/pac7311.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/gspca/pac7311.c b/drivers/media/usb/gspca/pac7311.c
index ba3558d..a12dfbf 100644
--- a/drivers/media/usb/gspca/pac7311.c
+++ b/drivers/media/usb/gspca/pac7311.c
@@ -621,7 +621,7 @@ static void sd_pkt_scan(struct gspca_dev *gspca_dev,
 	gspca_frame_add(gspca_dev, INTER_PACKET, data, len);
 }
 
-#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
+#if IS_ENABLED(CONFIG_INPUT)
 static int sd_int_pkt_scan(struct gspca_dev *gspca_dev,
 			u8 *data,		/* interrupt packet data */
 			int len)		/* interrupt packet length */
@@ -661,7 +661,7 @@ static const struct sd_desc sd_desc = {
 	.stopN = sd_stopN,
 	.pkt_scan = sd_pkt_scan,
 	.dq_callback = do_autogain,
-#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
+#if IS_ENABLED(CONFIG_INPUT)
 	.int_pkt_scan = sd_int_pkt_scan,
 #endif
 };
-- 
1.7.11.7

