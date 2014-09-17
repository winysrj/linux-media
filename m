Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55060 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756392AbaIQUpf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Sep 2014 16:45:35 -0400
Received: from lanttu.localdomain (salottisipuli.retiisi.org.uk [IPv6:2001:1bc8:102:7fc9::83:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 8D938600AD
	for <linux-media@vger.kernel.org>; Wed, 17 Sep 2014 23:45:32 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [PATCH 15/17] smiapp: Take valid link frequencies into account in supported mbus codes
Date: Wed, 17 Sep 2014 23:45:39 +0300
Message-Id: <1410986741-6801-16-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1410986741-6801-1-git-send-email-sakari.ailus@iki.fi>
References: <1410986741-6801-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some media bus codes may be unavailable depending on the available media bus
codes.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index b108b15..798c129 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -806,14 +806,6 @@ static int smiapp_get_mbus_formats(struct smiapp_sensor *sensor)
 			dev_dbg(&client->dev, "jolly good! %d\n", j);
 
 			sensor->default_mbus_frame_fmts |= 1 << j;
-			if (!sensor->csi_format
-			    || f->width > sensor->csi_format->width
-			    || (f->width == sensor->csi_format->width
-				&& f->compressed
-				> sensor->csi_format->compressed)) {
-				sensor->csi_format = f;
-				sensor->internal_csi_format = f;
-			}
 		}
 	}
 
@@ -854,6 +846,22 @@ static int smiapp_get_mbus_formats(struct smiapp_sensor *sensor)
 					f->compressed
 					- SMIAPP_COMPRESSED_BASE]);
 		}
+		if (!sensor->valid_link_freqs[f->compressed
+					      - SMIAPP_COMPRESSED_BASE]) {
+			dev_info(&client->dev,
+				 "no valid link frequencies for %u bpp\n",
+				 f->compressed);
+			sensor->default_mbus_frame_fmts &= ~BIT(i);
+			continue;
+		}
+
+		if (!sensor->csi_format
+		    || f->width > sensor->csi_format->width
+		    || (f->width == sensor->csi_format->width
+			&& f->compressed > sensor->csi_format->compressed)) {
+			sensor->csi_format = f;
+			sensor->internal_csi_format = f;
+		}
 	}
 
 	if (!sensor->csi_format) {
-- 
1.7.10.4

