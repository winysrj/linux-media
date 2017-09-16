Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:49560 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751253AbdIPOch (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Sep 2017 10:32:37 -0400
To: linux-media@vger.kernel.org, Bhumika Goyal <bhumirks@gmail.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH] [media] Si4713: Delete an error message for a failed memory
 allocation in two functions
Message-ID: <807ef494-8995-59dc-ee51-c7fbad3e01fa@users.sourceforge.net>
Date: Sat, 16 Sep 2017 16:32:06 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 16 Sep 2017 16:15:44 +0200

Omit an extra message for a memory allocation failure in these functions.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/radio/si4713/radio-platform-si4713.c | 1 -
 drivers/media/radio/si4713/si4713.c                | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/media/radio/si4713/radio-platform-si4713.c b/drivers/media/radio/si4713/radio-platform-si4713.c
index 27339ec495f6..4b7943e385a0 100644
--- a/drivers/media/radio/si4713/radio-platform-si4713.c
+++ b/drivers/media/radio/si4713/radio-platform-si4713.c
@@ -162,5 +162,4 @@ static int radio_si4713_pdriver_probe(struct platform_device *pdev)
 	if (!rsdev) {
-		dev_err(&pdev->dev, "Failed to alloc video device.\n");
 		rval = -ENOMEM;
 		goto exit;
 	}
diff --git a/drivers/media/radio/si4713/si4713.c b/drivers/media/radio/si4713/si4713.c
index f4a53f1e856e..46b1fe36f713 100644
--- a/drivers/media/radio/si4713/si4713.c
+++ b/drivers/media/radio/si4713/si4713.c
@@ -1451,5 +1451,4 @@ static int si4713_probe(struct i2c_client *client,
 	if (!sdev) {
-		dev_err(&client->dev, "Failed to alloc video device.\n");
 		rval = -ENOMEM;
 		goto exit;
 	}
-- 
2.14.1
