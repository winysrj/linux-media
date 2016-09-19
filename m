Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35324 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753416AbcISWDN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 18:03:13 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: sre@kernel.org
Subject: [PATCH v3 12/18] smiapp: Use SMIAPP_PADS when referring to number of pads
Date: Tue, 20 Sep 2016 01:02:45 +0300
Message-Id: <1474322571-20290-13-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1474322571-20290-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1474322571-20290-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace plain value 2 with SMIAPP_PADS when referring to the number of
pads.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp.h b/drivers/media/i2c/smiapp/smiapp.h
index e71271e..f9febe0 100644
--- a/drivers/media/i2c/smiapp/smiapp.h
+++ b/drivers/media/i2c/smiapp/smiapp.h
@@ -157,9 +157,9 @@ struct smiapp_binning_subtype {
 
 struct smiapp_subdev {
 	struct v4l2_subdev sd;
-	struct media_pad pads[2];
+	struct media_pad pads[SMIAPP_PADS];
 	struct v4l2_rect sink_fmt;
-	struct v4l2_rect crop[2];
+	struct v4l2_rect crop[SMIAPP_PADS];
 	struct v4l2_rect compose; /* compose on sink */
 	unsigned short sink_pad;
 	unsigned short source_pad;
-- 
2.1.4

