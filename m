Return-path: <linux-media-owner@vger.kernel.org>
Received: from xavier.telenet-ops.be ([195.130.132.52]:58776 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbbF2MXl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jun 2015 08:23:41 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] [media] mt9v032: Add missing initialization of pdata in mt9v032_get_pdata()
Date: Mon, 29 Jun 2015 14:23:41 +0200
Message-Id: <1435580621-21663-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/i2c/mt9v032.c: In function ‘mt9v032_get_pdata’:
drivers/media/i2c/mt9v032.c:885: warning: ‘pdata’ may be used uninitialized in this function

If parsing the endpoint node properties fails, mt9v032_get_pdata() will
return an uninitialized pointer value.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/media/i2c/mt9v032.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
index 977f4006edbd496d..a68ce94ee097604a 100644
--- a/drivers/media/i2c/mt9v032.c
+++ b/drivers/media/i2c/mt9v032.c
@@ -882,7 +882,7 @@ static const struct regmap_config mt9v032_regmap_config = {
 static struct mt9v032_platform_data *
 mt9v032_get_pdata(struct i2c_client *client)
 {
-	struct mt9v032_platform_data *pdata;
+	struct mt9v032_platform_data *pdata = NULL;
 	struct v4l2_of_endpoint endpoint;
 	struct device_node *np;
 	struct property *prop;
-- 
1.9.1

