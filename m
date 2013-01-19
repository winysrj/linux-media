Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:57070 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab3ASQei (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Jan 2013 11:34:38 -0500
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: hdegoede@redhat.com
Cc: mchehab@redhat.com, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 16/24] use IS_ENABLED() macro
Date: Sat, 19 Jan 2013 14:33:18 -0200
Message-Id: <1358613206-4274-15-git-send-email-peter.senna@gmail.com>
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
 drivers/media/usb/gspca/sonixj.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/gspca/sonixj.c b/drivers/media/usb/gspca/sonixj.c
index 36307a9..671d0c6 100644
--- a/drivers/media/usb/gspca/sonixj.c
+++ b/drivers/media/usb/gspca/sonixj.c
@@ -3077,7 +3077,7 @@ static int sd_querymenu(struct gspca_dev *gspca_dev,
 	return -EINVAL;
 }
 
-#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
+#if IS_ENABLED(CONFIG_INPUT)
 static int sd_int_pkt_scan(struct gspca_dev *gspca_dev,
 			u8 *data,		/* interrupt packet data */
 			int len)		/* interrupt packet length */
@@ -3109,7 +3109,7 @@ static const struct sd_desc sd_desc = {
 	.pkt_scan = sd_pkt_scan,
 	.dq_callback = do_autogain,
 	.querymenu = sd_querymenu,
-#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
+#if IS_ENABLED(CONFIG_INPUT)
 	.int_pkt_scan = sd_int_pkt_scan,
 #endif
 };
-- 
1.7.11.7

