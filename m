Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36412 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754177AbeFUKWJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Jun 2018 06:22:09 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hugues.fruchet@st.com
Subject: [PATCH 1/1] v4l-common: Make v4l2_find_nearest_size more sparse-friendly
Date: Thu, 21 Jun 2018 13:22:06 +0300
Message-Id: <20180621102206.29307-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This sparse warning is emitted by using v4l2_find_nearest_size in some
cases. Fix it in the framework.

>> drivers/media/i2c/ov5640.c:1394:14: sparse: incorrect type in assignment
+(different base types) @@    expected struct ov5640_mode_info const *mode @@
+got ststruct ov5640_mode_info const *mode @@
   drivers/media/i2c/ov5640.c:1394:14:    expected struct ov5640_mode_info const
+*mode
   drivers/media/i2c/ov5640.c:1394:14:    got struct ov5640_mode_info const ( *<
+noident> )[9]

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 include/media/v4l2-common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
index 160bca96d524..cdc87ec61e54 100644
--- a/include/media/v4l2-common.h
+++ b/include/media/v4l2-common.h
@@ -338,7 +338,7 @@ void v4l_bound_align_image(unsigned int *width, unsigned int wmin,
 	({								\
 		BUILD_BUG_ON(sizeof((array)->width_field) != sizeof(u32) || \
 			     sizeof((array)->height_field) != sizeof(u32)); \
-		(typeof(&(*(array))))__v4l2_find_nearest_size(		\
+		(typeof(&(array)[0]))__v4l2_find_nearest_size(		\
 			(array), array_size, sizeof(*(array)),		\
 			offsetof(typeof(*(array)), width_field),	\
 			offsetof(typeof(*(array)), height_field),	\
-- 
2.11.0
