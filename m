Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:41332 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753838AbeGENdX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Jul 2018 09:33:23 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, laurent.pinchart+renesas@ideasonboard.com,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH v2 33/34] media: camss: csid: Add support for events triggered by user controls
Date: Thu,  5 Jul 2018 16:33:04 +0300
Message-Id: <1530797585-8555-34-git-send-email-todor.tomov@linaro.org>
In-Reply-To: <1530797585-8555-1-git-send-email-todor.tomov@linaro.org>
References: <1530797585-8555-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changing a user control value can trigger an event to other
users. Add support for that.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 drivers/media/platform/qcom/camss/camss-csid.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/camss/camss-csid.c b/drivers/media/platform/qcom/camss/camss-csid.c
index a581377..b50eb96 100644
--- a/drivers/media/platform/qcom/camss/camss-csid.c
+++ b/drivers/media/platform/qcom/camss/camss-csid.c
@@ -17,6 +17,7 @@
 #include <linux/regulator/consumer.h>
 #include <media/media-entity.h>
 #include <media/v4l2-device.h>
+#include <media/v4l2-event.h>
 #include <media/v4l2-subdev.h>
 
 #include "camss-csid.h"
@@ -1266,6 +1267,8 @@ static int csid_link_setup(struct media_entity *entity,
 
 static const struct v4l2_subdev_core_ops csid_core_ops = {
 	.s_power = csid_set_power,
+	.subscribe_event = v4l2_ctrl_subdev_subscribe_event,
+	.unsubscribe_event = v4l2_event_subdev_unsubscribe,
 };
 
 static const struct v4l2_subdev_video_ops csid_video_ops = {
@@ -1311,7 +1314,8 @@ int msm_csid_register_entity(struct csid_device *csid,
 
 	v4l2_subdev_init(sd, &csid_v4l2_ops);
 	sd->internal_ops = &csid_v4l2_internal_ops;
-	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE |
+		     V4L2_SUBDEV_FL_HAS_EVENTS;
 	snprintf(sd->name, ARRAY_SIZE(sd->name), "%s%d",
 		 MSM_CSID_NAME, csid->id);
 	v4l2_set_subdevdata(sd, csid);
-- 
2.7.4
