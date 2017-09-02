Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:64243 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752684AbdIBPtu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 2 Sep 2017 11:49:50 -0400
Subject: [PATCH 2/7] [media] ov2640: Improve a size determination in
 ov2640_probe()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Bhumika Goyal <bhumirks@gmail.com>,
        =?UTF-8?Q?Frank_Sch=c3=a4fer?= <fschaefer.oss@googlemail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <c9f2ba21-c742-e1e8-26d9-a56c51c56d65@users.sourceforge.net>
Message-ID: <457f2678-da7f-cb67-8893-5cdb7ce804dd@users.sourceforge.net>
Date: Sat, 2 Sep 2017 17:49:28 +0200
MIME-Version: 1.0
In-Reply-To: <c9f2ba21-c742-e1e8-26d9-a56c51c56d65@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 2 Sep 2017 16:09:35 +0200

Replace the specification of a data structure by a pointer dereference
as the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer according to the Linux coding style convention.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/i2c/ov2640.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov2640.c b/drivers/media/i2c/ov2640.c
index e4ae53410097..456aa977bce8 100644
--- a/drivers/media/i2c/ov2640.c
+++ b/drivers/media/i2c/ov2640.c
@@ -1097,5 +1097,5 @@ static int ov2640_probe(struct i2c_client *client,
 		return -EIO;
 	}
 
-	priv = devm_kzalloc(&client->dev, sizeof(struct ov2640_priv), GFP_KERNEL);
+	priv = devm_kzalloc(&client->dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
-- 
2.14.1
