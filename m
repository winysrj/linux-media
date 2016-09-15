Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39288 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1764459AbcIOLWl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Sep 2016 07:22:41 -0400
Received: from lanttu.localdomain (unknown [192.168.15.166])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id CC9B3600A9
        for <linux-media@vger.kernel.org>; Thu, 15 Sep 2016 14:22:35 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 11/17] smiapp: Use SMIAPP_PADS when referring to number of pads
Date: Thu, 15 Sep 2016 14:22:25 +0300
Message-Id: <1473938551-14503-12-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1473938551-14503-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1473938551-14503-1-git-send-email-sakari.ailus@linux.intel.com>
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

