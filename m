Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50594 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752120AbaJBIrJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Oct 2014 04:47:09 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCH v2 15/18] smiapp: Take valid link frequencies into account in supported mbus codes
Date: Thu,  2 Oct 2014 11:46:05 +0300
Message-Id: <1412239568-8524-16-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1412239568-8524-1-git-send-email-sakari.ailus@iki.fi>
References: <1412239568-8524-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some media bus codes may be unavailable depending on the available media bus
codes.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index d65521a..926f60c 100644
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
 
@@ -850,6 +842,22 @@ static int smiapp_get_mbus_formats(struct smiapp_sensor *sensor)
 
 			set_bit(j, valid_link_freqs);
 		}
+
+		if (!*valid_link_freqs) {
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

