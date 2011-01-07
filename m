Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49390 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065Ab1AGQAB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jan 2011 11:00:01 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/5] uvcvideo: Deprecate UVCIOC_CTRL_{ADD,MAP_OLD,GET,SET}
Date: Fri,  7 Jan 2011 17:00:37 +0100
Message-Id: <1294416040-28371-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1294416040-28371-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1294416040-28371-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Those ioctls are deprecated, list them in the features removal schedule
for 2.6.39.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 Documentation/feature-removal-schedule.txt |   23 +++++++++++++++++++++++
 drivers/media/video/uvc/uvc_v4l2.c         |   14 ++++++++++++++
 2 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index f2742e1..0251dff 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -566,3 +566,26 @@ Why:	This field is deprecated. I2C device drivers shouldn't change their
 Who:	Jean Delvare <khali@linux-fr.org>
 
 ----------------------------
+
+What:	Support for UVCIOC_CTRL_ADD in the uvcvideo driver
+When:	2.6.39
+Why:	The information passed to the driver by this ioctl is now queried
+	dynamically from the device.
+Who:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+
+----------------------------
+
+What:	Support for UVCIOC_CTRL_MAP_OLD in the uvcvideo driver
+When:	2.6.39
+Why:	Used only by applications compiled against older driver versions.
+	Superseded by UVCIOC_CTRL_MAP which supports V4L2 menu controls.
+Who:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+
+----------------------------
+
+What:	Support for UVCIOC_CTRL_GET and UVCIOC_CTRL_SET in the uvcvideo driver
+When:	2.6.39
+Why:	Superseded by the UVCIOC_CTRL_QUERY ioctl.
+Who:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+
+----------------------------
diff --git a/drivers/media/video/uvc/uvc_v4l2.c b/drivers/media/video/uvc/uvc_v4l2.c
index 7432336..c03046a 100644
--- a/drivers/media/video/uvc/uvc_v4l2.c
+++ b/drivers/media/video/uvc/uvc_v4l2.c
@@ -1020,10 +1020,20 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 
 	/* Dynamic controls. */
 	case UVCIOC_CTRL_ADD:
+		uvc_printk(KERN_INFO, "Deprecated UVCIOC_CTRL_ADD ioctl "
+			   "will be removed in 2.6.39.\n");
+		uvc_printk(KERN_INFO, "See http://www.ideasonboard.org/uvc/ "
+			   "for upgrade instructions.\n");
+
 		/* Legacy ioctl, kept for API compatibility reasons */
 		return -EEXIST;
 
 	case UVCIOC_CTRL_MAP_OLD:
+		uvc_printk(KERN_INFO, "Deprecated UVCIOC_CTRL_MAP_OLD ioctl "
+			   "will be removed in 2.6.39.\n");
+		uvc_printk(KERN_INFO, "See http://www.ideasonboard.org/uvc/"
+			   "for upgrade instructions.\n");
+
 	case UVCIOC_CTRL_MAP:
 		return uvc_ioctl_ctrl_map(chain, arg,
 					  cmd == UVCIOC_CTRL_MAP_OLD);
@@ -1041,6 +1051,10 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 			.data		= xctrl->data,
 		};
 
+		uvc_printk(KERN_INFO, "Deprecated UVCIOC_CTRL_[GS]ET ioctls "
+			   "will be removed in 2.6.39.\n");
+		uvc_printk(KERN_INFO, "See http://www.ideasonboard.org/uvc/ "
+			   "for upgrade instructions.\n");
 		return uvc_xu_ctrl_query(chain, &xqry);
 	}
 
-- 
1.7.2.2

