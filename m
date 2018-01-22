Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:56302 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751041AbeAVKTA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Jan 2018 05:19:00 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 4/9] staging: atomisp: i2c: Disable non-preview configurations
Date: Mon, 22 Jan 2018 11:18:52 +0100
Message-Id: <20180122101857.51401-5-hverkuil@xs4all.nl>
In-Reply-To: <20180122101857.51401-1-hverkuil@xs4all.nl>
References: <20180122101857.51401-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

Disable configurations for non-preview modes until configuration selection
is improved.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/atomisp/i2c/gc2235.h        | 2 ++
 drivers/staging/media/atomisp/i2c/ov2722.h        | 2 ++
 drivers/staging/media/atomisp/i2c/ov5693/ov5693.h | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/drivers/staging/media/atomisp/i2c/gc2235.h b/drivers/staging/media/atomisp/i2c/gc2235.h
index 45a54fea5466..817c0068c1d3 100644
--- a/drivers/staging/media/atomisp/i2c/gc2235.h
+++ b/drivers/staging/media/atomisp/i2c/gc2235.h
@@ -574,6 +574,7 @@ static struct gc2235_resolution gc2235_res_preview[] = {
 };
 #define N_RES_PREVIEW (ARRAY_SIZE(gc2235_res_preview))
 
+#if 0 /* Disable non-previes configurations for now */
 static struct gc2235_resolution gc2235_res_still[] = {
 	{
 		.desc = "gc2235_1600_900_30fps",
@@ -658,6 +659,7 @@ static struct gc2235_resolution gc2235_res_video[] = {
 
 };
 #define N_RES_VIDEO (ARRAY_SIZE(gc2235_res_video))
+#endif
 
 static struct gc2235_resolution *gc2235_res = gc2235_res_preview;
 static unsigned long N_RES = N_RES_PREVIEW;
diff --git a/drivers/staging/media/atomisp/i2c/ov2722.h b/drivers/staging/media/atomisp/i2c/ov2722.h
index d8a973d71699..f133439adfd5 100644
--- a/drivers/staging/media/atomisp/i2c/ov2722.h
+++ b/drivers/staging/media/atomisp/i2c/ov2722.h
@@ -1148,6 +1148,7 @@ struct ov2722_resolution ov2722_res_preview[] = {
 };
 #define N_RES_PREVIEW (ARRAY_SIZE(ov2722_res_preview))
 
+#if 0 /* Disable non-previes configurations for now */
 struct ov2722_resolution ov2722_res_still[] = {
 	{
 		.desc = "ov2722_480P_30fps",
@@ -1250,6 +1251,7 @@ struct ov2722_resolution ov2722_res_video[] = {
 	},
 };
 #define N_RES_VIDEO (ARRAY_SIZE(ov2722_res_video))
+#endif
 
 static struct ov2722_resolution *ov2722_res = ov2722_res_preview;
 static unsigned long N_RES = N_RES_PREVIEW;
diff --git a/drivers/staging/media/atomisp/i2c/ov5693/ov5693.h b/drivers/staging/media/atomisp/i2c/ov5693/ov5693.h
index 68cfcb4a6c3c..15a33dcd2d59 100644
--- a/drivers/staging/media/atomisp/i2c/ov5693/ov5693.h
+++ b/drivers/staging/media/atomisp/i2c/ov5693/ov5693.h
@@ -1147,6 +1147,7 @@ struct ov5693_resolution ov5693_res_preview[] = {
 };
 #define N_RES_PREVIEW (ARRAY_SIZE(ov5693_res_preview))
 
+#if 0 /* Disable non-previes configurations for now */
 struct ov5693_resolution ov5693_res_still[] = {
 	{
 		.desc = "ov5693_736x496_30fps",
@@ -1364,6 +1365,7 @@ struct ov5693_resolution ov5693_res_video[] = {
 	},
 };
 #define N_RES_VIDEO (ARRAY_SIZE(ov5693_res_video))
+#endif
 
 static struct ov5693_resolution *ov5693_res = ov5693_res_preview;
 static unsigned long N_RES = N_RES_PREVIEW;
-- 
2.15.1
