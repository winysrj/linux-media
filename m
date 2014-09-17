Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55062 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756871AbaIQUpf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Sep 2014 16:45:35 -0400
Received: from lanttu.localdomain (salottisipuli.retiisi.org.uk [IPv6:2001:1bc8:102:7fc9::83:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id C009C60098
	for <linux-media@vger.kernel.org>; Wed, 17 Sep 2014 23:45:32 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [PATCH 16/17] smiapp: Update PLL when setting format
Date: Wed, 17 Sep 2014 23:45:40 +0300
Message-Id: <1410986741-6801-17-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1410986741-6801-1-git-send-email-sakari.ailus@iki.fi>
References: <1410986741-6801-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The media bus format BPP does affect PLL. Recalculate PLL if the format
changes.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 798c129..537ca92 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -1758,8 +1758,18 @@ static int smiapp_set_format(struct v4l2_subdev *subdev,
 
 			if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
 				if (csi_format->width !=
-				    sensor->csi_format->width)
+				    sensor->csi_format->width) {
+					int rval;
+
+					rval = smiapp_pll_update(sensor);
+					if (rval) {
+						mutex_unlock(&sensor->mutex);
+						return rval;
+					}
+
 					range_changed = true;
+				}
+
 
 				sensor->csi_format = csi_format;
 			}
-- 
1.7.10.4

