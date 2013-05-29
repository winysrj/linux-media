Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1507 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965694Ab3E2LBn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 07:01:43 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, Mike Isely <isely@isely.net>
Subject: [PATCHv1 33/38] pvrusb2: drop g/s_register ioctls.
Date: Wed, 29 May 2013 13:00:06 +0200
Message-Id: <1369825211-29770-34-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
References: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Register access to subdevices no longer needs bridge support for those
ioctls. The v4l2 core handles that these days.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mike Isely <isely@isely.net>
---
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c  |   36 ------------------------------
 drivers/media/usb/pvrusb2/pvrusb2-hdw.h  |    9 --------
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c |   34 ----------------------------
 3 files changed, 79 deletions(-)

diff --git a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
index 01d1c2d..d329209 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
@@ -5162,39 +5162,3 @@ static int pvr2_hdw_get_eeprom_addr(struct pvr2_hdw *hdw)
 	} while(0); LOCK_GIVE(hdw->ctl_lock);
 	return result;
 }
-
-
-int pvr2_hdw_register_access(struct pvr2_hdw *hdw,
-			     const struct v4l2_dbg_match *match, u64 reg_id,
-			     int setFl, u64 *val_ptr)
-{
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-	struct v4l2_dbg_register req;
-	int stat = 0;
-	int okFl = 0;
-
-	req.match = *match;
-	req.reg = reg_id;
-	if (setFl) req.val = *val_ptr;
-	/* It would be nice to know if a sub-device answered the request */
-	v4l2_device_call_all(&hdw->v4l2_dev, 0, core, g_register, &req);
-	if (!setFl) *val_ptr = req.val;
-	if (okFl) {
-		return stat;
-	}
-	return -EINVAL;
-#else
-	return -ENOSYS;
-#endif
-}
-
-
-/*
-  Stuff for Emacs to see, in order to encourage consistent editing style:
-  *** Local Variables: ***
-  *** mode: c ***
-  *** fill-column: 75 ***
-  *** tab-width: 8 ***
-  *** c-basic-offset: 8 ***
-  *** End: ***
-  */
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-hdw.h b/drivers/media/usb/pvrusb2/pvrusb2-hdw.h
index 91bae93..1a135cf 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.h
+++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.h
@@ -234,15 +234,6 @@ int pvr2_hdw_v4l_get_minor_number(struct pvr2_hdw *,enum pvr2_v4l_type index);
 void pvr2_hdw_v4l_store_minor_number(struct pvr2_hdw *,
 				     enum pvr2_v4l_type index,int);
 
-/* Direct read/write access to chip's registers:
-   match - specify criteria to identify target chip (this is a v4l dbg struct)
-   reg_id  - register number to access
-   setFl   - true to set the register, false to read it
-   val_ptr - storage location for source / result. */
-int pvr2_hdw_register_access(struct pvr2_hdw *,
-			     const struct v4l2_dbg_match *match, u64 reg_id,
-			     int setFl, u64 *val_ptr);
-
 /* The following entry points are all lower level things you normally don't
    want to worry about. */
 
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
index a8a65fa..82f619b 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
@@ -800,36 +800,6 @@ static int pvr2_log_status(struct file *file, void *priv)
 	return 0;
 }
 
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-static int pvr2_g_register(struct file *file, void *priv, struct v4l2_dbg_register *req)
-{
-	struct pvr2_v4l2_fh *fh = file->private_data;
-	struct pvr2_hdw *hdw = fh->channel.mc_head->hdw;
-	u64 val;
-	int ret;
-
-	ret = pvr2_hdw_register_access(
-			hdw, &req->match, req->reg,
-			0, &val);
-	req->val = val;
-	return ret;
-}
-
-static int pvr2_s_register(struct file *file, void *priv, const struct v4l2_dbg_register *req)
-{
-	struct pvr2_v4l2_fh *fh = file->private_data;
-	struct pvr2_hdw *hdw = fh->channel.mc_head->hdw;
-	u64 val;
-	int ret;
-
-	val = req->val;
-	ret = pvr2_hdw_register_access(
-			hdw, &req->match, req->reg,
-			1, &val);
-	return ret;
-}
-#endif
-
 static const struct v4l2_ioctl_ops pvr2_ioctl_ops = {
 	.vidioc_querycap		    = pvr2_querycap,
 	.vidioc_g_priority		    = pvr2_g_priority,
@@ -864,10 +834,6 @@ static const struct v4l2_ioctl_ops pvr2_ioctl_ops = {
 	.vidioc_g_ext_ctrls		    = pvr2_g_ext_ctrls,
 	.vidioc_s_ext_ctrls		    = pvr2_s_ext_ctrls,
 	.vidioc_try_ext_ctrls		    = pvr2_try_ext_ctrls,
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-	.vidioc_g_register		    = pvr2_g_register,
-	.vidioc_s_register		    = pvr2_s_register,
-#endif
 };
 
 static void pvr2_v4l2_dev_destroy(struct pvr2_v4l2_dev *dip)
-- 
1.7.10.4

