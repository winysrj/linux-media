Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51045 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751230AbbCJBSr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 21:18:47 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: prabhakar.csengg@gmail.com, laurent.pinchart@ideasonboard.com
Subject: [PATCH 1/3] smiapp: Clean up smiapp_get_pdata()
Date: Tue, 10 Mar 2015 03:18:00 +0200
Message-Id: <1425950282-30548-2-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1425950282-30548-1-git-send-email-sakari.ailus@iki.fi>
References: <1425950282-30548-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Don't set rval when it's not used (the function returns a pointer to struct
smiapp_platform_data).

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/i2c/smiapp/smiapp-core.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index b1f566b..565a00c 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2988,10 +2988,8 @@ static struct smiapp_platform_data *smiapp_get_pdata(struct device *dev)
 		return NULL;
 
 	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
-	if (!pdata) {
-		rval = -ENOMEM;
+	if (!pdata)
 		goto out_err;
-	}
 
 	v4l2_of_parse_endpoint(ep, &bus_cfg);
 
@@ -3001,7 +2999,6 @@ static struct smiapp_platform_data *smiapp_get_pdata(struct device *dev)
 		break;
 		/* FIXME: add CCP2 support. */
 	default:
-		rval = -EINVAL;
 		goto out_err;
 	}
 
-- 
1.7.10.4

