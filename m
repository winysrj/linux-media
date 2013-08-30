Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:42167 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696Ab3H3Jup (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Aug 2013 05:50:45 -0400
Received: by mail-ee0-f51.google.com with SMTP id c1so797358eek.10
        for <linux-media@vger.kernel.org>; Fri, 30 Aug 2013 02:50:44 -0700 (PDT)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, m.chehab@samsung.com,
	hans.verkuil@cisco.com
Cc: Gianluca Gennari <gennarone@gmail.com>
Subject: [RFC PATCH] adv7842: fix compilation with GCC < 4.4.6
Date: Fri, 30 Aug 2013 11:50:27 +0200
Message-Id: <1377856227-22601-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With GCC 4.4.3 (Ubuntu 10.04) the compilation of the new adv7842 driver
fails with this error:

CC [M]  adv7842.o
adv7842.c:549: error: unknown field 'bt' specified in initializer
adv7842.c:550: error: field name not in record or union initializer
adv7842.c:550: error: (near initialization for 'adv7842_timings_cap_analog.reserved')
adv7842.c:551: error: field name not in record or union initializer
adv7842.c:551: error: (near initialization for 'adv7842_timings_cap_analog.reserved')
adv7842.c:552: error: field name not in record or union initializer
adv7842.c:552: error: (near initialization for 'adv7842_timings_cap_analog.reserved')
adv7842.c:553: error: field name not in record or union initializer
adv7842.c:553: error: (near initialization for 'adv7842_timings_cap_analog.reserved')
adv7842.c:553: warning: excess elements in array initializer
...

This is caused by the old GCC version, as explained in file v4l2-dv-timings.h.
The proposed fix uses the V4L2_INIT_BT_TIMINGS macro defined there.
Please note that I have also to init the reserved space as otherwise GCC fails with this error:

CC [M]  adv7842.o
adv7842.c:549: error: field name not in record or union initializer
adv7842.c:549: error: (near initialization for 'adv7842_timings_cap_analog.reserved')
adv7842.c:549: warning: braces around scalar initializer
adv7842.c:549: warning: (near initialization for 'adv7842_timings_cap_analog.reserved[0]')
...

Maybe the reserved space in struct v4l2_dv_timings_cap could be moved after
the 'bt' field to avoid this?

The same issue applies to other drivers too: ths8200, adv7511 and ad9389b.
If the fix is approved, I can post a patch serie fixing all of them.

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 drivers/media/i2c/adv7842.c | 28 ++++++++++------------------
 1 file changed, 10 insertions(+), 18 deletions(-)

diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index d174890..c21621b 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -546,30 +546,22 @@ static inline bool is_digital_input(struct v4l2_subdev *sd)
 
 static const struct v4l2_dv_timings_cap adv7842_timings_cap_analog = {
 	.type = V4L2_DV_BT_656_1120,
-	.bt = {
-		.max_width = 1920,
-		.max_height = 1200,
-		.min_pixelclock = 25000000,
-		.max_pixelclock = 170000000,
-		.standards = V4L2_DV_BT_STD_CEA861 | V4L2_DV_BT_STD_DMT |
+	.reserved = { 0 },
+	V4L2_INIT_BT_TIMINGS(0, 1920, 0, 1200, 25000000, 170000000,
+		V4L2_DV_BT_STD_CEA861 | V4L2_DV_BT_STD_DMT |
 			V4L2_DV_BT_STD_GTF | V4L2_DV_BT_STD_CVT,
-		.capabilities = V4L2_DV_BT_CAP_PROGRESSIVE |
-			V4L2_DV_BT_CAP_REDUCED_BLANKING | V4L2_DV_BT_CAP_CUSTOM,
-	},
+		V4L2_DV_BT_CAP_PROGRESSIVE | V4L2_DV_BT_CAP_REDUCED_BLANKING |
+			V4L2_DV_BT_CAP_CUSTOM)
 };
 
 static const struct v4l2_dv_timings_cap adv7842_timings_cap_digital = {
 	.type = V4L2_DV_BT_656_1120,
-	.bt = {
-		.max_width = 1920,
-		.max_height = 1200,
-		.min_pixelclock = 25000000,
-		.max_pixelclock = 225000000,
-		.standards = V4L2_DV_BT_STD_CEA861 | V4L2_DV_BT_STD_DMT |
+	.reserved = { 0 },
+	V4L2_INIT_BT_TIMINGS(0, 1920, 0, 1200, 25000000, 225000000,
+		V4L2_DV_BT_STD_CEA861 | V4L2_DV_BT_STD_DMT |
 			V4L2_DV_BT_STD_GTF | V4L2_DV_BT_STD_CVT,
-		.capabilities = V4L2_DV_BT_CAP_PROGRESSIVE |
-			V4L2_DV_BT_CAP_REDUCED_BLANKING | V4L2_DV_BT_CAP_CUSTOM,
-	},
+		V4L2_DV_BT_CAP_PROGRESSIVE | V4L2_DV_BT_CAP_REDUCED_BLANKING |
+			V4L2_DV_BT_CAP_CUSTOM)
 };
 
 static inline const struct v4l2_dv_timings_cap *
-- 
1.8.4

