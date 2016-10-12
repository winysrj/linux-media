Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:61630 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932983AbcJLOeX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Oct 2016 10:34:23 -0400
Subject: [PATCH 04/34] [media] DaVinci-VPBE: Combine substrings for four
 messages
To: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <a99f89f2-a3be-9b5f-95c1-e0912a7d78f3@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <8d486002-839c-bfd8-557c-04bb32f3b76f@users.sourceforge.net>
Date: Wed, 12 Oct 2016 16:34:05 +0200
MIME-Version: 1.0
In-Reply-To: <a99f89f2-a3be-9b5f-95c1-e0912a7d78f3@users.sourceforge.net>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 11 Oct 2016 13:40:14 +0200

The script "checkpatch.pl" pointed information out like the following.

WARNING: quoted string split across lines

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/platform/davinci/vpbe.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/davinci/vpbe.c b/drivers/media/platform/davinci/vpbe.c
index 496b27f..625bddf 100644
--- a/drivers/media/platform/davinci/vpbe.c
+++ b/drivers/media/platform/davinci/vpbe.c
@@ -702,15 +702,15 @@ static int vpbe_initialize(struct device *dev, struct vpbe_device *vpbe_dev)
 					  "v4l2 sub device %s registered\n",
 					  enc_info->module_name);
 			else {
-				v4l2_err(&vpbe_dev->v4l2_dev, "encoder %s"
-					 " failed to register",
+				v4l2_err(&vpbe_dev->v4l2_dev,
+					 "encoder %s failed to register",
 					 enc_info->module_name);
 				ret = -ENODEV;
 				goto fail_kfree_encoders;
 			}
 		} else
-			v4l2_warn(&vpbe_dev->v4l2_dev, "non-i2c encoders"
-				 " currently not supported");
+			v4l2_warn(&vpbe_dev->v4l2_dev,
+				 "non-i2c encoders currently not supported");
 	}
 	/* Add amplifier subdevice for dm365 */
 	if ((strcmp(vpbe_dev->cfg->module_name, "dm365-vpbe-display") == 0) &&
@@ -731,9 +731,9 @@ static int vpbe_initialize(struct device *dev, struct vpbe_device *vpbe_dev)
 					  "v4l2 sub device %s registered\n",
 					  amp_info->module_name);
 		} else {
-			    vpbe_dev->amp = NULL;
-			    v4l2_warn(&vpbe_dev->v4l2_dev, "non-i2c amplifiers"
-			    " currently not supported");
+			vpbe_dev->amp = NULL;
+			v4l2_warn(&vpbe_dev->v4l2_dev,
+				  "non-i2c amplifiers currently not supported");
 		}
 	} else {
 	    vpbe_dev->amp = NULL;
@@ -832,8 +832,8 @@ static int vpbe_probe(struct platform_device *pdev)
 	if (!cfg->module_name[0] ||
 	    !cfg->osd.module_name[0] ||
 	    !cfg->venc.module_name[0]) {
-		v4l2_err(pdev->dev.driver, "vpbe display module names not"
-			 " defined\n");
+		v4l2_err(pdev->dev.driver,
+			 "vpbe display module names not defined\n");
 		return ret;
 	}
 
-- 
2.10.1

