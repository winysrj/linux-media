Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:33064 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752282AbbEHJIB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 8 May 2015 05:08:01 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: ovebryne@cisco.com, marbugge@cisco.com, matrandg@cisco.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 4/5] adv7604/adv7842: replace FMT_CHANGED by V4L2_DEVICE_NOTIFY_EVENT
Date: Fri,  8 May 2015 11:07:27 +0200
Message-Id: <1431076048-1963-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1431076048-1963-1-git-send-email-hverkuil@xs4all.nl>
References: <1431076048-1963-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This makes it easier for the bridge driver to just passthrough such
events to the corresponding device node.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7604.c | 12 +++++++++---
 drivers/media/i2c/adv7842.c | 11 +++++++++--
 include/media/adv7604.h     |  1 -
 include/media/adv7842.h     |  3 ---
 4 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index c1be0f7..275a322 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -341,6 +341,11 @@ static const struct adv76xx_video_standards adv76xx_prim_mode_hdmi_gr[] = {
 	{ },
 };
 
+static const struct v4l2_event adv76xx_ev_fmt = {
+	.type = V4L2_EVENT_SOURCE_CHANGE,
+	.u.src_change.changes = V4L2_EVENT_SRC_CH_RESOLUTION,
+};
+
 /* ----------------------------------------------------------------------- */
 
 static inline struct adv76xx_state *to_state(struct v4l2_subdev *sd)
@@ -1744,11 +1749,11 @@ static int adv76xx_s_routing(struct v4l2_subdev *sd,
 	state->selected_input = input;
 
 	disable_input(sd);
-
 	select_input(sd);
-
 	enable_input(sd);
 
+	v4l2_subdev_notify(sd, V4L2_DEVICE_NOTIFY_EVENT,
+			   (void *)&adv76xx_ev_fmt);
 	return 0;
 }
 
@@ -1915,7 +1920,8 @@ static int adv76xx_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 			"%s: fmt_change = 0x%x, fmt_change_digital = 0x%x\n",
 			__func__, fmt_change, fmt_change_digital);
 
-		v4l2_subdev_notify(sd, ADV76XX_FMT_CHANGE, NULL);
+		v4l2_subdev_notify(sd, V4L2_DEVICE_NOTIFY_EVENT,
+				   (void *)&adv76xx_ev_fmt);
 
 		if (handled)
 			*handled = true;
diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index dceabc2..f5248ba 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -242,6 +242,11 @@ static const struct adv7842_video_standards adv7842_prim_mode_hdmi_gr[] = {
 	{ },
 };
 
+static const struct v4l2_event adv7842_ev_fmt = {
+	.type = V4L2_EVENT_SOURCE_CHANGE,
+	.u.src_change.changes = V4L2_EVENT_SRC_CH_RESOLUTION,
+};
+
 /* ----------------------------------------------------------------------- */
 
 static inline struct adv7842_state *to_state(struct v4l2_subdev *sd)
@@ -1975,7 +1980,8 @@ static int adv7842_s_routing(struct v4l2_subdev *sd,
 	select_input(sd, state->vid_std_select);
 	enable_input(sd);
 
-	v4l2_subdev_notify(sd, ADV7842_FMT_CHANGE, NULL);
+	v4l2_subdev_notify(sd, V4L2_DEVICE_NOTIFY_EVENT,
+			   (void *)&adv7842_ev_fmt);
 
 	return 0;
 }
@@ -2208,7 +2214,8 @@ static int adv7842_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 			 "%s: fmt_change_cp = 0x%x, fmt_change_digital = 0x%x, fmt_change_sdp = 0x%x\n",
 			 __func__, fmt_change_cp, fmt_change_digital,
 			 fmt_change_sdp);
-		v4l2_subdev_notify(sd, ADV7842_FMT_CHANGE, NULL);
+		v4l2_subdev_notify(sd, V4L2_DEVICE_NOTIFY_EVENT,
+				   (void *)&adv7842_ev_fmt);
 		if (handled)
 			*handled = true;
 	}
diff --git a/include/media/adv7604.h b/include/media/adv7604.h
index 9ecf353..a913859 100644
--- a/include/media/adv7604.h
+++ b/include/media/adv7604.h
@@ -168,6 +168,5 @@ enum adv76xx_pad {
 
 /* notify events */
 #define ADV76XX_HOTPLUG		1
-#define ADV76XX_FMT_CHANGE	2
 
 #endif
diff --git a/include/media/adv7842.h b/include/media/adv7842.h
index 64a66d0..1f38db8 100644
--- a/include/media/adv7842.h
+++ b/include/media/adv7842.h
@@ -230,9 +230,6 @@ struct adv7842_platform_data {
 #define V4L2_CID_ADV_RX_FREE_RUN_COLOR_MANUAL	(V4L2_CID_DV_CLASS_BASE + 0x1001)
 #define V4L2_CID_ADV_RX_FREE_RUN_COLOR		(V4L2_CID_DV_CLASS_BASE + 0x1002)
 
-/* notify events */
-#define ADV7842_FMT_CHANGE	1
-
 /* custom ioctl, used to test the external RAM that's used by the
  * deinterlacer. */
 #define ADV7842_CMD_RAM_TEST _IO('V', BASE_VIDIOC_PRIVATE)
-- 
2.1.4

