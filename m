Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8RHP28T005465
	for <video4linux-list@redhat.com>; Sat, 27 Sep 2008 13:25:04 -0400
Received: from mailrelay012.isp.belgacom.be (mailrelay012.isp.belgacom.be
	[195.238.6.179])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8RHOopR028879
	for <video4linux-list@redhat.com>; Sat, 27 Sep 2008 13:24:51 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: video4linux-list@redhat.com
Date: Sat, 27 Sep 2008 19:24:57 +0200
References: <200809232317.44795.laurent.pinchart@skynet.be>
In-Reply-To: <200809232317.44795.laurent.pinchart@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809271924.58142.laurent.pinchart@skynet.be>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2] uvcvideo: Fix control cache access when setting
	composite auto-update controls
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Auto-update controls are never marked is loaded to prevent uvc_get_ctrl from
loading the control value from the cache. When setting a composite (mapped to
several V4L2 controls) auto-update UVC control, the driver updates the control
cache value before processing each V4L2 control, overwriting the previously
set V4L2 control.

This fixes the problem by marking all controls as loaded in uvc_set_ctrl
regardless of their type and resetting the loaded flag in uvc_commit_ctrl for
auto-update controls.

Signed-off-by: Laurent Pinchart <laurent.pinchart@skynet.be>
---
 drivers/media/video/uvc/uvc_ctrl.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_ctrl.c 
b/drivers/media/video/uvc/uvc_ctrl.c
index 6da37cd..0516fba 100644
--- a/drivers/media/video/uvc/uvc_ctrl.c
+++ b/drivers/media/video/uvc/uvc_ctrl.c
@@ -853,7 +853,12 @@ static int uvc_ctrl_commit_entity(struct uvc_device *dev,
 			       uvc_ctrl_data(ctrl, UVC_CTRL_DATA_BACKUP),
 			       ctrl->info->size);
 
-		if ((ctrl->info->flags & UVC_CONTROL_GET_CUR) == 0)
+		/* Reset the loaded flag for auto-update and read-only controls
+		 * that were marked as loaded in uvc_ctrl_set to prevent
+		 * uvc_ctrl_get from using the cached value.
+		 */
+		if (!(ctrl->info->flags & UVC_CONTROL_GET_CUR) ||
+		     (ctrl->info->flags & UVC_CONTROL_AUTO_UPDATE))
 			ctrl->loaded = 0;
 
 		ctrl->dirty = 0;
@@ -913,8 +918,7 @@ int uvc_ctrl_get(struct uvc_video_device *video,
 		if (ret < 0)
 			return ret;
 
-		if ((ctrl->info->flags & UVC_CONTROL_AUTO_UPDATE) == 0)
-			ctrl->loaded = 1;
+		ctrl->loaded = 1;
 	}
 
 	xctrl->value = uvc_get_le_value(
@@ -965,8 +969,7 @@ int uvc_ctrl_set(struct uvc_video_device *video,
 				return ret;
 		}
 
-		if ((ctrl->info->flags & UVC_CONTROL_AUTO_UPDATE) == 0)
-			ctrl->loaded = 1;
+		ctrl->loaded = 1;
 	}
 
 	if (!ctrl->dirty) {
-- 
1.5.6.4

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
