Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:37278 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752875AbeBSOII (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 09:08:08 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv3 05/10] staging: atomisp: i2c: Disable non-preview configurations
Date: Mon, 19 Feb 2018 15:07:57 +0100
Message-Id: <20180219140802.3514-6-hverkuil@xs4all.nl>
In-Reply-To: <20180219140802.3514-1-hverkuil@xs4all.nl>
References: <20180219140802.3514-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

These sensor drivers have use case specific mode lists. This is currently
not used nor there is a standard API for selecting the mode list. Disable
configurations for non-preview modes until configuration selection is
improved so that all the configurations are always usable.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
[hans.verkuil@cisco.com: clarify that this functionality it currently unused]
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/atomisp/i2c/gc2235.h        | 6 ++++++
 drivers/staging/media/atomisp/i2c/ov2722.h        | 6 ++++++
 drivers/staging/media/atomisp/i2c/ov5693/ov5693.h | 6 ++++++
 3 files changed, 18 insertions(+)

diff --git a/drivers/staging/media/atomisp/i2c/gc2235.h b/drivers/staging/media/atomisp/i2c/gc2235.h
index 45a54fea5466..0e805bcfa4d8 100644
--- a/drivers/staging/media/atomisp/i2c/gc2235.h
+++ b/drivers/staging/media/atomisp/i2c/gc2235.h
@@ -574,6 +574,11 @@ static struct gc2235_resolution gc2235_res_preview[] = {
 };
 #define N_RES_PREVIEW (ARRAY_SIZE(gc2235_res_preview))
 
+/*
+ * Disable non-preview configurations until the configuration selection is
+ * improved.
+ */
+#if 0
 static struct gc2235_resolution gc2235_res_still[] = {
 	{
 		.desc = "gc2235_1600_900_30fps",
@@ -658,6 +663,7 @@ static struct gc2235_resolution gc2235_res_video[] = {
 
 };
 #define N_RES_VIDEO (ARRAY_SIZE(gc2235_res_video))
+#endif
 
 static struct gc2235_resolution *gc2235_res = gc2235_res_preview;
 static unsigned long N_RES = N_RES_PREVIEW;
diff --git a/drivers/staging/media/atomisp/i2c/ov2722.h b/drivers/staging/media/atomisp/i2c/ov2722.h
index d8a973d71699..028b04aaaa8f 100644
--- a/drivers/staging/media/atomisp/i2c/ov2722.h
+++ b/drivers/staging/media/atomisp/i2c/ov2722.h
@@ -1148,6 +1148,11 @@ struct ov2722_resolution ov2722_res_preview[] = {
 };
 #define N_RES_PREVIEW (ARRAY_SIZE(ov2722_res_preview))
 
+/*
+ * Disable non-preview configurations until the configuration selection is
+ * improved.
+ */
+#if 0
 struct ov2722_resolution ov2722_res_still[] = {
 	{
 		.desc = "ov2722_480P_30fps",
@@ -1250,6 +1255,7 @@ struct ov2722_resolution ov2722_res_video[] = {
 	},
 };
 #define N_RES_VIDEO (ARRAY_SIZE(ov2722_res_video))
+#endif
 
 static struct ov2722_resolution *ov2722_res = ov2722_res_preview;
 static unsigned long N_RES = N_RES_PREVIEW;
diff --git a/drivers/staging/media/atomisp/i2c/ov5693/ov5693.h b/drivers/staging/media/atomisp/i2c/ov5693/ov5693.h
index 68cfcb4a6c3c..6d27dd849a62 100644
--- a/drivers/staging/media/atomisp/i2c/ov5693/ov5693.h
+++ b/drivers/staging/media/atomisp/i2c/ov5693/ov5693.h
@@ -1147,6 +1147,11 @@ struct ov5693_resolution ov5693_res_preview[] = {
 };
 #define N_RES_PREVIEW (ARRAY_SIZE(ov5693_res_preview))
 
+/*
+ * Disable non-preview configurations until the configuration selection is
+ * improved.
+ */
+#if 0
 struct ov5693_resolution ov5693_res_still[] = {
 	{
 		.desc = "ov5693_736x496_30fps",
@@ -1364,6 +1369,7 @@ struct ov5693_resolution ov5693_res_video[] = {
 	},
 };
 #define N_RES_VIDEO (ARRAY_SIZE(ov5693_res_video))
+#endif
 
 static struct ov5693_resolution *ov5693_res = ov5693_res_preview;
 static unsigned long N_RES = N_RES_PREVIEW;
-- 
2.15.1
