Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:62979 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751297AbdIPScC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Sep 2017 14:32:02 -0400
Subject: [PATCH 1/2] [media] it913x: Delete two error messages for a failed
 memory allocation in it913x_probe()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <0ad553a6-9aca-d20b-48df-4084d80e2223@users.sourceforge.net>
Message-ID: <a1686dac-ad24-e46e-c1fc-64f897b458ff@users.sourceforge.net>
Date: Sat, 16 Sep 2017 20:31:42 +0200
MIME-Version: 1.0
In-Reply-To: <0ad553a6-9aca-d20b-48df-4084d80e2223@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 16 Sep 2017 19:40:47 +0200

* Omit extra messages for a memory allocation failure in this function.

  This issue was detected by using the Coccinelle software.

* Delete the label "err" and the variable "ret" which became unnecessary
  with this refactoring.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/tuners/it913x.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/media/tuners/it913x.c b/drivers/media/tuners/it913x.c
index 27e5bc1c3cb5..6af9507823fa 100644
--- a/drivers/media/tuners/it913x.c
+++ b/drivers/media/tuners/it913x.c
@@ -392,14 +392,10 @@ static int it913x_probe(struct platform_device *pdev)
 	struct it913x_dev *dev;
 	const struct platform_device_id *id = platform_get_device_id(pdev);
-	int ret;
 	char *chip_ver_str;
 
 	dev = kzalloc(sizeof(struct it913x_dev), GFP_KERNEL);
-	if (dev == NULL) {
-		ret = -ENOMEM;
-		dev_err(&pdev->dev, "kzalloc() failed\n");
-		goto err;
-	}
+	if (!dev)
+		return -ENOMEM;
 
 	dev->pdev = pdev;
 	dev->regmap = pdata->regmap;
@@ -423,9 +419,6 @@ static int it913x_probe(struct platform_device *pdev)
 		 chip_ver_str);
 	dev_dbg(&pdev->dev, "chip_ver %u, role %u\n", dev->chip_ver, dev->role);
 	return 0;
-err:
-	dev_dbg(&pdev->dev, "failed %d\n", ret);
-	return ret;
 }
 
 static int it913x_remove(struct platform_device *pdev)
-- 
2.14.1
