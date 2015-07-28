Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:50207 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751873AbbG1IeF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jul 2015 04:34:05 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id A0E1B2A0089
	for <linux-media@vger.kernel.org>; Tue, 28 Jul 2015 10:33:55 +0200 (CEST)
Message-ID: <55B73E73.2050006@xs4all.nl>
Date: Tue, 28 Jul 2015 10:33:55 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] mt9v032: fix uninitialized variable warning
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/i2c/mt9v032.c: In function ‘mt9v032_probe’:
  CC [M]  drivers/media/i2c/s5k4ecgx.o
drivers/media/i2c/mt9v032.c:996:20: warning: ‘pdata’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  if (pdata && pdata->link_freqs) {
                    ^

It can indeed be uninitialized in one corner case. Initialize to NULL.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/mt9v032.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
index 977f400..a68ce94 100644
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
2.1.4

