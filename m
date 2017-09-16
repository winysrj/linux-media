Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:55259 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751259AbdIPScm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Sep 2017 14:32:42 -0400
Subject: [PATCH 2/2] [media] it913x: Improve three size determinations
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <0ad553a6-9aca-d20b-48df-4084d80e2223@users.sourceforge.net>
Message-ID: <d3a7f3ed-1a5e-87f5-44fd-a6f242b219eb@users.sourceforge.net>
Date: Sat, 16 Sep 2017 20:32:30 +0200
MIME-Version: 1.0
In-Reply-To: <0ad553a6-9aca-d20b-48df-4084d80e2223@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 16 Sep 2017 20:06:01 +0200

Replace the specification of data structures by variable references
as the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer according to the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/tuners/it913x.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/media/tuners/it913x.c b/drivers/media/tuners/it913x.c
index 6af9507823fa..149f36d5e503 100644
--- a/drivers/media/tuners/it913x.c
+++ b/drivers/media/tuners/it913x.c
@@ -393,5 +393,5 @@ static int it913x_probe(struct platform_device *pdev)
 	const struct platform_device_id *id = platform_get_device_id(pdev);
 	char *chip_ver_str;
 
-	dev = kzalloc(sizeof(struct it913x_dev), GFP_KERNEL);
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 	if (!dev)
@@ -404,8 +404,7 @@ static int it913x_probe(struct platform_device *pdev)
 	dev->role = pdata->role;
 
 	fe->tuner_priv = dev;
-	memcpy(&fe->ops.tuner_ops, &it913x_tuner_ops,
-			sizeof(struct dvb_tuner_ops));
+	memcpy(&fe->ops.tuner_ops, &it913x_tuner_ops, sizeof(it913x_tuner_ops));
 	platform_set_drvdata(pdev, dev);
 
 	if (dev->chip_ver == 1)
@@ -427,8 +426,7 @@ static int it913x_remove(struct platform_device *pdev)
 	struct dvb_frontend *fe = dev->fe;
 
 	dev_dbg(&pdev->dev, "\n");
-
-	memset(&fe->ops.tuner_ops, 0, sizeof(struct dvb_tuner_ops));
+	memset(&fe->ops.tuner_ops, 0, sizeof(it913x_tuner_ops));
 	fe->tuner_priv = NULL;
 	kfree(dev);
 
-- 
2.14.1
