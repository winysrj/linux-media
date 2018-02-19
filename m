Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:57012 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752380AbeBSKiM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 05:38:12 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv3 01/15] vimc: fix control event handling
Date: Mon, 19 Feb 2018 11:37:52 +0100
Message-Id: <20180219103806.17032-2-hverkuil@xs4all.nl>
In-Reply-To: <20180219103806.17032-1-hverkuil@xs4all.nl>
References: <20180219103806.17032-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The sensor subdev didn't handle control events. Add support for this.
Found with v4l2-compliance.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/platform/vimc/vimc-common.c | 4 +++-
 drivers/media/platform/vimc/vimc-sensor.c | 8 ++++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/vimc/vimc-common.c b/drivers/media/platform/vimc/vimc-common.c
index 9d63c84a9876..617415c224fe 100644
--- a/drivers/media/platform/vimc/vimc-common.c
+++ b/drivers/media/platform/vimc/vimc-common.c
@@ -434,7 +434,9 @@ int vimc_ent_sd_register(struct vimc_ent_device *ved,
 	v4l2_set_subdevdata(sd, ved);
 
 	/* Expose this subdev to user space */
-	sd->flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
+	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+	if (sd->ctrl_handler)
+		sd->flags |= V4L2_SUBDEV_FL_HAS_EVENTS;
 
 	/* Initialize the media entity */
 	ret = media_entity_pads_init(&sd->entity, num_pads, ved->pads);
diff --git a/drivers/media/platform/vimc/vimc-sensor.c b/drivers/media/platform/vimc/vimc-sensor.c
index 457e211514c6..54184cd9e0ff 100644
--- a/drivers/media/platform/vimc/vimc-sensor.c
+++ b/drivers/media/platform/vimc/vimc-sensor.c
@@ -23,6 +23,7 @@
 #include <linux/v4l2-mediabus.h>
 #include <linux/vmalloc.h>
 #include <media/v4l2-ctrls.h>
+#include <media/v4l2-event.h>
 #include <media/v4l2-subdev.h>
 #include <media/tpg/v4l2-tpg.h>
 
@@ -284,11 +285,18 @@ static int vimc_sen_s_stream(struct v4l2_subdev *sd, int enable)
 	return 0;
 }
 
+static struct v4l2_subdev_core_ops vimc_sen_core_ops = {
+	.log_status = v4l2_ctrl_subdev_log_status,
+	.subscribe_event = v4l2_ctrl_subdev_subscribe_event,
+	.unsubscribe_event = v4l2_event_subdev_unsubscribe,
+};
+
 static const struct v4l2_subdev_video_ops vimc_sen_video_ops = {
 	.s_stream = vimc_sen_s_stream,
 };
 
 static const struct v4l2_subdev_ops vimc_sen_ops = {
+	.core = &vimc_sen_core_ops,
 	.pad = &vimc_sen_pad_ops,
 	.video = &vimc_sen_video_ops,
 };
-- 
2.16.1
