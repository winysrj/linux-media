Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:58083 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752576AbcDCUoc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 3 Apr 2016 16:44:32 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: awalls@md.metrocast.net, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/2] ivtv/cx18: use the new mask variants of the v4l2_device_call_* defines
Date: Sun,  3 Apr 2016 13:44:17 -0700
Message-Id: <1459716257-1542-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1459716257-1542-1-git-send-email-hverkuil@xs4all.nl>
References: <1459716257-1542-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Instead of rolling our own define, just use the new mask defines.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx18/cx18-driver.h | 13 ++-----------
 drivers/media/pci/ivtv/ivtv-driver.h | 13 ++-----------
 2 files changed, 4 insertions(+), 22 deletions(-)

diff --git a/drivers/media/pci/cx18/cx18-driver.h b/drivers/media/pci/cx18/cx18-driver.h
index 7e31f2a..47ce80f 100644
--- a/drivers/media/pci/cx18/cx18-driver.h
+++ b/drivers/media/pci/cx18/cx18-driver.h
@@ -707,11 +707,7 @@ static inline int cx18_raw_vbi(const struct cx18 *cx)
 /* Call the specified callback for all subdevs with a grp_id bit matching the
  * mask in hw (if 0, then match them all). Ignore any errors. */
 #define cx18_call_hw(cx, hw, o, f, args...)				\
-	do {								\
-		struct v4l2_subdev *__sd;				\
-		__v4l2_device_call_subdevs_p(&(cx)->v4l2_dev, __sd,	\
-			!(hw) || (__sd->grp_id & (hw)), o, f , ##args);	\
-	} while (0)
+	v4l2_device_mask_call_all(&(cx)->v4l2_dev, hw, o, f, ##args)
 
 #define cx18_call_all(cx, o, f, args...) cx18_call_hw(cx, 0, o, f , ##args)
 
@@ -719,12 +715,7 @@ static inline int cx18_raw_vbi(const struct cx18 *cx)
  * mask in hw (if 0, then match them all). If the callback returns an error
  * other than 0 or -ENOIOCTLCMD, then return with that error code. */
 #define cx18_call_hw_err(cx, hw, o, f, args...)				\
-({									\
-	struct v4l2_subdev *__sd;					\
-	__v4l2_device_call_subdevs_until_err_p(&(cx)->v4l2_dev,		\
-			__sd, !(hw) || (__sd->grp_id & (hw)), o, f,	\
-			##args);					\
-})
+	v4l2_device_mask_call_until_err(&(cx)->v4l2_dev, hw, o, f, ##args)
 
 #define cx18_call_all_err(cx, o, f, args...) \
 	cx18_call_hw_err(cx, 0, o, f , ##args)
diff --git a/drivers/media/pci/ivtv/ivtv-driver.h b/drivers/media/pci/ivtv/ivtv-driver.h
index 6c08dae..10cba305 100644
--- a/drivers/media/pci/ivtv/ivtv-driver.h
+++ b/drivers/media/pci/ivtv/ivtv-driver.h
@@ -827,12 +827,7 @@ static inline int ivtv_raw_vbi(const struct ivtv *itv)
 /* Call the specified callback for all subdevs matching hw (if 0, then
    match them all). Ignore any errors. */
 #define ivtv_call_hw(itv, hw, o, f, args...) 				\
-	do {								\
-		struct v4l2_subdev *__sd;				\
-		__v4l2_device_call_subdevs_p(&(itv)->v4l2_dev, __sd,	\
-			 !(hw) ? true : (__sd->grp_id & (hw)),		\
-			 o, f, ##args);					\
-	} while (0)
+	v4l2_device_mask_call_all(&(itv)->v4l2_dev, hw, o, f, ##args)
 
 #define ivtv_call_all(itv, o, f, args...) ivtv_call_hw(itv, 0, o, f , ##args)
 
@@ -840,11 +835,7 @@ static inline int ivtv_raw_vbi(const struct ivtv *itv)
    match them all). If the callback returns an error other than 0 or
    -ENOIOCTLCMD, then return with that error code. */
 #define ivtv_call_hw_err(itv, hw, o, f, args...)			\
-({									\
-	struct v4l2_subdev *__sd;					\
-	__v4l2_device_call_subdevs_until_err_p(&(itv)->v4l2_dev, __sd,	\
-		!(hw) || (__sd->grp_id & (hw)), o, f , ##args);		\
-})
+	v4l2_device_mask_call_until_err(&(itv)->v4l2_dev, hw, o, f, ##args)
 
 #define ivtv_call_all_err(itv, o, f, args...) ivtv_call_hw_err(itv, 0, o, f , ##args)
 
-- 
2.8.0.rc3

