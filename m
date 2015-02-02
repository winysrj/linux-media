Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55836 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752315AbbBBHoL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Feb 2015 02:44:11 -0500
Received: from lanttu.localdomain (lanttu.localdomain [192.168.5.64])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 2EE7E60093
	for <linux-media@vger.kernel.org>; Mon,  2 Feb 2015 09:44:07 +0200 (EET)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [REVIEW PATCH 1/1] smiapp: Make pixel_order_str static
Date: Mon,  2 Feb 2015 09:43:40 +0200
Message-Id: <1422863020-31129-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

pixel_order_str is only referred to in smiapp-core.c, it should be thus
static. Thanks to Hans Verkuil for pointing this out.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/i2c/smiapp/smiapp-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index d47eff5..ce4c719 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -344,7 +344,7 @@ static const struct smiapp_csi_data_format smiapp_csi_data_formats[] = {
 	{ MEDIA_BUS_FMT_SGBRG8_1X8, 8, 8, SMIAPP_PIXEL_ORDER_GBRG, },
 };
 
-const char *pixel_order_str[] = { "GRBG", "RGGB", "BGGR", "GBRG" };
+static const char *pixel_order_str[] = { "GRBG", "RGGB", "BGGR", "GBRG" };
 
 #define to_csi_format_idx(fmt) (((unsigned long)(fmt)			\
 				 - (unsigned long)smiapp_csi_data_formats) \
-- 
1.7.10.4

