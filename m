Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43527 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753744Ab2IOVmI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Sep 2012 17:42:08 -0400
Received: from localhost.localdomain (salottisipuli.retiisi.org.uk [IPv6:2001:1bc8:102:6d9a::83:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id BB88E60099
	for <linux-media@vger.kernel.org>; Sun, 16 Sep 2012 00:42:05 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/2] smiapp: Use highest bits-per-pixel for sensor internal format
Date: Sun, 16 Sep 2012 00:43:28 +0300
Message-Id: <1347745409-21003-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <5054F66C.1050400@iki.fi>
References: <5054F66C.1050400@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The format shown on the links internal to the sensor was the first one
enumerated from the sensor, not the highest bit depth data that can be
produced by the sensor. Correct this.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/i2c/smiapp/smiapp-core.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 4f1c8d6..02bfa44 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -777,7 +777,11 @@ static int smiapp_get_mbus_formats(struct smiapp_sensor *sensor)
 			dev_dbg(&client->dev, "jolly good! %d\n", j);
 
 			sensor->default_mbus_frame_fmts |= 1 << j;
-			if (!sensor->csi_format) {
+			if (!sensor->csi_format
+			    || f->width > sensor->csi_format->width
+			    || (f->width == sensor->csi_format->width
+				&& f->compressed
+				> sensor->csi_format->compressed)) {
 				sensor->csi_format = f;
 				sensor->internal_csi_format = f;
 			}
-- 
1.7.2.5

