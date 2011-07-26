Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:35867 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248Ab1GZStz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jul 2011 14:49:55 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: hans.verkuil@cisco.com, snjw23@gmail.com,
	laurent.pinchart@ideasonboard.com
Subject: [PATCH 3/3] omap3isp: ccdc: Make frame start event generic
Date: Tue, 26 Jul 2011 21:49:44 +0300
Message-Id: <1311706184-22658-3-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <4E2F0C53.10907@iki.fi>
References: <4E2F0C53.10907@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ccdc block in the omap3isp produces frame start events. These events
were previously specific to the omap3isp. Make them generic.

Also add sequence number to the frame. This is stored to the id field.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 Documentation/video4linux/omap3isp.txt |    9 +++++----
 drivers/media/video/omap3isp/ispccdc.c |   11 +++++++++--
 include/linux/omap3isp.h               |    2 --
 3 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/Documentation/video4linux/omap3isp.txt b/Documentation/video4linux/omap3isp.txt
index 69be2c7..5dd1439 100644
--- a/Documentation/video4linux/omap3isp.txt
+++ b/Documentation/video4linux/omap3isp.txt
@@ -70,10 +70,11 @@ Events
 The OMAP 3 ISP driver does support the V4L2 event interface on CCDC and
 statistics (AEWB, AF and histogram) subdevs.
 
-The CCDC subdev produces V4L2_EVENT_OMAP3ISP_HS_VS type event on HS_VS
-interrupt which is used to signal frame start. The event is triggered exactly
-when the reception of the first line of the frame starts in the CCDC module.
-The event can be subscribed on the CCDC subdev.
+The CCDC subdev produces V4L2_EVENT_FRAME_SYNC type event on HS_VS
+interrupt which is used to signal frame start. Earlier version of this
+driver used V4L2_EVENT_OMAP3ISP_HS_VS for this purpose. The event is
+triggered exactly when the reception of the first line of the frame starts
+in the CCDC module. The event can be subscribed on the CCDC subdev.
 
 (When using parallel interface one must pay account to correct configuration
 of the VS signal polarity. This is automatically correct when using the serial
diff --git a/drivers/media/video/omap3isp/ispccdc.c b/drivers/media/video/omap3isp/ispccdc.c
index 6766247..842a930 100644
--- a/drivers/media/video/omap3isp/ispccdc.c
+++ b/drivers/media/video/omap3isp/ispccdc.c
@@ -1402,11 +1402,14 @@ static int __ccdc_handle_stopping(struct isp_ccdc_device *ccdc, u32 event)
 
 static void ccdc_hs_vs_isr(struct isp_ccdc_device *ccdc)
 {
+	struct isp_pipeline *pipe =
+		to_isp_pipeline(&ccdc->video_out.video.entity);
 	struct video_device *vdev = &ccdc->subdev.devnode;
 	struct v4l2_event event;
 
 	memset(&event, 0, sizeof(event));
-	event.type = V4L2_EVENT_OMAP3ISP_HS_VS;
+	event.type = V4L2_EVENT_FRAME_SYNC;
+	event.u.frame_sync.buffer_sequence = atomic_read(&pipe->frame_number);
 
 	v4l2_event_queue(vdev, &event);
 }
@@ -1688,7 +1691,11 @@ static long ccdc_ioctl(struct v4l2_subdev *sd, unsigned int cmd, void *arg)
 static int ccdc_subscribe_event(struct v4l2_subdev *sd, struct v4l2_fh *fh,
 				struct v4l2_event_subscription *sub)
 {
-	if (sub->type != V4L2_EVENT_OMAP3ISP_HS_VS)
+	if (sub->type != V4L2_EVENT_FRAME_SYNC)
+		return -EINVAL;
+
+	/* line number is zero at frame start */
+	if (sub->id != 0)
 		return -EINVAL;
 
 	return v4l2_event_subscribe(fh, sub, OMAP3ISP_CCDC_NEVENTS);
diff --git a/include/linux/omap3isp.h b/include/linux/omap3isp.h
index b6111f8..c73a34c 100644
--- a/include/linux/omap3isp.h
+++ b/include/linux/omap3isp.h
@@ -62,14 +62,12 @@
  * V4L2_EVENT_OMAP3ISP_AEWB: AEWB statistics data ready
  * V4L2_EVENT_OMAP3ISP_AF: AF statistics data ready
  * V4L2_EVENT_OMAP3ISP_HIST: Histogram statistics data ready
- * V4L2_EVENT_OMAP3ISP_HS_VS: Horizontal/vertical synchronization detected
  */
 
 #define V4L2_EVENT_OMAP3ISP_CLASS	(V4L2_EVENT_PRIVATE_START | 0x100)
 #define V4L2_EVENT_OMAP3ISP_AEWB	(V4L2_EVENT_OMAP3ISP_CLASS | 0x1)
 #define V4L2_EVENT_OMAP3ISP_AF		(V4L2_EVENT_OMAP3ISP_CLASS | 0x2)
 #define V4L2_EVENT_OMAP3ISP_HIST	(V4L2_EVENT_OMAP3ISP_CLASS | 0x3)
-#define V4L2_EVENT_OMAP3ISP_HS_VS	(V4L2_EVENT_OMAP3ISP_CLASS | 0x4)
 
 struct omap3isp_stat_event_status {
 	__u32 frame_number;
-- 
1.7.2.5

