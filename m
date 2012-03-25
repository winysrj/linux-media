Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236Ab2CYLzC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Mar 2012 07:55:02 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 10/10] uvcvideo: Send control change events for slave ctrls when the master changes
Date: Sun, 25 Mar 2012 13:56:50 +0200
Message-Id: <1332676610-14953-11-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1332676610-14953-1-git-send-email-hdegoede@redhat.com>
References: <1332676610-14953-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This allows v4l2 control UI-s to update the inactive state (ie grey-ing
out of controls) for slave controls when the master control changes.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/video/uvc/uvc_ctrl.c |   55 ++++++++++++++++++++++++++++++++++--
 1 file changed, 52 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_ctrl.c b/drivers/media/video/uvc/uvc_ctrl.c
index 91d9007..2d06fd8 100644
--- a/drivers/media/video/uvc/uvc_ctrl.c
+++ b/drivers/media/video/uvc/uvc_ctrl.c
@@ -1179,21 +1179,70 @@ static void uvc_ctrl_send_event(struct uvc_fh *handle,
 
 	list_for_each_entry(sev, &mapping->ev_subs, node)
 		if (sev->fh && (sev->fh != &handle->vfh ||
-		    (sev->flags & V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK)))
+		    (sev->flags & V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK) ||
+		    (changes & V4L2_EVENT_CTRL_CH_FLAGS)))
 			v4l2_event_queue_fh(sev->fh, &ev);
 }
 
-static void uvc_ctrl_send_events(struct uvc_fh *handle,
+static void uvc_ctrl_send_slave_event(struct uvc_fh *handle, u32 slave_id,
 	struct v4l2_ext_control *xctrls, int xctrls_count)
 {
 	struct uvc_control_mapping *mapping;
 	struct uvc_control *ctrl;
+	u32 changes = V4L2_EVENT_CTRL_CH_FLAGS;
+	s32 val = 0;
 	int i;
 
+	/*
+	 * We can skip sending an event for the slave if the slave
+	 * is being modified in the same transaction.
+	 */
+	for (i = 0; i < xctrls_count; i++)
+		if (xctrls[i].id == slave_id)
+			return;
+
+	ctrl = uvc_find_control(handle->chain, slave_id, &mapping);
+	if (ctrl == NULL)
+		return;
+
+	if (__uvc_ctrl_get(handle->chain, ctrl, mapping, &val) == 0)
+		changes |= V4L2_EVENT_CTRL_CH_VALUE;
+
+	uvc_ctrl_send_event(handle, ctrl, mapping, val, changes);
+}
+
+static void uvc_ctrl_send_events(struct uvc_fh *handle,
+	struct v4l2_ext_control *xctrls, int xctrls_count)
+{
+	struct uvc_control_mapping *mapping;
+	struct uvc_control *ctrl;
+	u32 changes = V4L2_EVENT_CTRL_CH_VALUE;
+	int i, j;
+
 	for (i = 0; i < xctrls_count; ++i) {
 		ctrl = uvc_find_control(handle->chain, xctrls[i].id, &mapping);
+
+		for (j = 0; j < ARRAY_SIZE(mapping->slave_ids); ++j) {
+			if (!mapping->slave_ids[j])
+				break;
+			uvc_ctrl_send_slave_event(handle,
+						  mapping->slave_ids[j],
+						  xctrls, xctrls_count);
+		}
+
+		/*
+		 * If the master is being modified in the same transaction
+		 * flags may change too.
+		 */
+		if (mapping->master_id)
+			for (j = 0; j < xctrls_count; j++)
+				if (xctrls[j].id == mapping->master_id) {
+					changes |= V4L2_EVENT_CTRL_CH_FLAGS;
+					break;
+				}
+
 		uvc_ctrl_send_event(handle, ctrl, mapping, xctrls[i].value,
-				    V4L2_EVENT_CTRL_CH_VALUE);
+				    changes);
 	}
 }
 
-- 
1.7.9.3

