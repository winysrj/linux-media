Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:58294 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752254AbdIASUv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Sep 2017 14:20:51 -0400
To: linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH] [media] si2168: Delete an error message for a failed memory
 allocation in si2168_probe()
Message-ID: <67e4ee2f-7fd8-5d46-4000-61dae57ca729@users.sourceforge.net>
Date: Fri, 1 Sep 2017 20:20:38 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 1 Sep 2017 19:50:45 +0200

Omit an extra message for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/dvb-frontends/si2168.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 172fc367ccaa..41d9c513b7e8 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -697,6 +697,5 @@ static int si2168_probe(struct i2c_client *client,
 	if (!dev) {
 		ret = -ENOMEM;
-		dev_err(&client->dev, "kzalloc() failed\n");
 		goto err;
 	}
 
-- 
2.14.1
