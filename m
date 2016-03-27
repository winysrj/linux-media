Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:37554 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737AbcC0VPj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Mar 2016 17:15:39 -0400
Received: by mail-wm0-f52.google.com with SMTP id p65so78492195wmp.0
        for <linux-media@vger.kernel.org>; Sun, 27 Mar 2016 14:15:38 -0700 (PDT)
From: Claudiu Beznea <claudiu.beznea@gmail.com>
To: mchehab@osg.samsung.com, gregkh@linuxfoundation.org
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	Claudiu Beznea <claudiu.beznea@gmail.com>
Subject: [PATCH] Staging: media: bcm2048: defined region_configs[] array as const array
Date: Mon, 28 Mar 2016 00:15:14 +0300
Message-Id: <1459113314-7286-1-git-send-email-claudiu.beznea@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch defines region_configs[] array as const array since it
is not changed anywhere in code.

Signed-off-by: Claudiu Beznea <claudiu.beznea@gmail.com>
---
 drivers/staging/media/bcm2048/radio-bcm2048.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
index abf330f..8dade19 100644
--- a/drivers/staging/media/bcm2048/radio-bcm2048.c
+++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
@@ -308,7 +308,7 @@ module_param(radio_nr, int, 0);
 MODULE_PARM_DESC(radio_nr,
 		 "Minor number for radio device (-1 ==> auto assign)");
 
-static struct region_info region_configs[] = {
+static const struct region_info region_configs[] = {
 	/* USA */
 	{
 		.channel_spacing	= 20,
-- 
1.9.1

