Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754083Ab1J0LTh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Oct 2011 07:19:37 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: hverkuil@xs4all.nl,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 1/2] uvcvideo: Refactor uvc_ctrl_get and query
Date: Thu, 27 Oct 2011 13:19:51 +0200
Message-Id: <1319714392-4406-2-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1319714392-4406-1-git-send-email-hdegoede@redhat.com>
References: <1319714392-4406-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a preparation patch for adding ctrl event support.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/video/uvc/uvc_ctrl.c |   62 +++++++++++++++++++++++++-----------
 1 files changed, 43 insertions(+), 19 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_ctrl.c b/drivers/media/video/uvc/uvc_ctrl.c
index 254d326..1a2c1a3 100644
--- a/drivers/media/video/uvc/uvc_ctrl.c
+++ b/drivers/media/video/uvc/uvc_ctrl.c
@@ -886,24 +886,14 @@ static int uvc_ctrl_populate_cache(struct uvc_video_chain *chain,
 	return 0;
 }
 
-int uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
+static int __uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
+	struct uvc_control *ctrl,
+	struct uvc_control_mapping *mapping,
 	struct v4l2_queryctrl *v4l2_ctrl)
 {
-	struct uvc_control *ctrl;
-	struct uvc_control_mapping *mapping;
 	struct uvc_menu_info *menu;
 	unsigned int i;
-	int ret;
-
-	ret = mutex_lock_interruptible(&chain->ctrl_mutex);
-	if (ret < 0)
-		return -ERESTARTSYS;
-
-	ctrl = uvc_find_control(chain, v4l2_ctrl->id, &mapping);
-	if (ctrl == NULL) {
-		ret = -EINVAL;
-		goto done;
-	}
+	int ret = 0;
 
 	memset(v4l2_ctrl, 0, sizeof *v4l2_ctrl);
 	v4l2_ctrl->id = mapping->id;
@@ -972,6 +962,28 @@ int uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
 				  uvc_ctrl_data(ctrl, UVC_CTRL_DATA_RES));
 
 done:
+	return ret;
+}
+
+int uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
+	struct v4l2_queryctrl *v4l2_ctrl)
+{
+	struct uvc_control *ctrl;
+	struct uvc_control_mapping *mapping;
+	int ret;
+
+	ret = mutex_lock_interruptible(&chain->ctrl_mutex);
+	if (ret < 0)
+		return -ERESTARTSYS;
+
+	ctrl = uvc_find_control(chain, v4l2_ctrl->id, &mapping);
+	if (ctrl == NULL) {
+		ret = -EINVAL;
+		goto done;
+	}
+
+	ret = __uvc_query_v4l2_ctrl(chain, ctrl, mapping, v4l2_ctrl);
+done:
 	mutex_unlock(&chain->ctrl_mutex);
 	return ret;
 }
@@ -1135,17 +1147,16 @@ done:
 	return ret;
 }
 
-int uvc_ctrl_get(struct uvc_video_chain *chain,
+static int __uvc_ctrl_get(struct uvc_video_chain *chain,
+	struct uvc_control *ctrl,
+	struct uvc_control_mapping *mapping,
 	struct v4l2_ext_control *xctrl)
 {
-	struct uvc_control *ctrl;
-	struct uvc_control_mapping *mapping;
 	struct uvc_menu_info *menu;
 	unsigned int i;
 	int ret;
 
-	ctrl = uvc_find_control(chain, xctrl->id, &mapping);
-	if (ctrl == NULL || (ctrl->info.flags & UVC_CTRL_FLAG_GET_CUR) == 0)
+	if ((ctrl->info.flags & UVC_CTRL_FLAG_GET_CUR) == 0)
 		return -EINVAL;
 
 	if (!ctrl->loaded) {
@@ -1175,6 +1186,19 @@ int uvc_ctrl_get(struct uvc_video_chain *chain,
 	return 0;
 }
 
+int uvc_ctrl_get(struct uvc_video_chain *chain,
+	struct v4l2_ext_control *xctrl)
+{
+	struct uvc_control *ctrl;
+	struct uvc_control_mapping *mapping;
+
+	ctrl = uvc_find_control(chain, xctrl->id, &mapping);
+	if (ctrl == NULL)
+		return -EINVAL;
+
+	return __uvc_ctrl_get(chain, ctrl, mapping, xctrl);
+}
+
 int uvc_ctrl_set(struct uvc_video_chain *chain,
 	struct v4l2_ext_control *xctrl)
 {
-- 
1.7.7

