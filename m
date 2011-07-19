Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:18567 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037Ab1GSNiK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2011 09:38:10 -0400
Received: from maxwell.research.nokia.com (maxwell.research.nokia.com [172.21.50.162])
	by mgw-sa02.nokia.com (Switch-3.4.4/Switch-3.4.3) with ESMTP id p6JDc8er027793
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 19 Jul 2011 16:38:08 +0300
Received: from kaali.localdomain (kaali.localdomain [192.168.239.7])
	by maxwell.research.nokia.com (Postfix) with ESMTPS id AE2C438639A
	for <linux-media@vger.kernel.org>; Tue, 19 Jul 2011 16:38:08 +0300 (EEST)
Received: from sailus by kaali.localdomain with local (Exim 4.72)
	(envelope-from <sakari.ailus@maxwell.research.nokia.com>)
	id 1QjAUy-0004E2-Ka
	for linux-media@vger.kernel.org; Tue, 19 Jul 2011 16:38:08 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [RFC 3/3] omap3isp: ccdc: Make frame start event generic
Date: Tue, 19 Jul 2011 16:38:08 +0300
Message-Id: <1311082688-16185-3-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <4E2588AD.4070106@maxwell.research.nokia.com>
References: <4E2588AD.4070106@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ccdc block in the omap3isp produces frame start events. These events
were previously specific to the omap3isp. Make them generic.

Also add sequence number to the frame. This is stored to the id field.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 Documentation/video4linux/omap3isp.txt |    9 +++++----
 drivers/media/video/omap3isp/ispccdc.c |    7 +++++--
 include/linux/omap3isp.h               |    2 --
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/Documentation/video4linux/omap3isp.txt b/Documentation/video4linux/omap3isp.txt
index 69be2c7..84f24cf 100644
--- a/Documentation/video4linux/omap3isp.txt
+++ b/Documentation/video4linux/omap3isp.txt
@@ -70,10 +70,11 @@ Events
 The OMAP 3 ISP driver does support the V4L2 event interface on CCDC and
 statistics (AEWB, AF and histogram) subdevs.
 
-The CCDC subdev produces V4L2_EVENT_OMAP3ISP_HS_VS type event on HS_VS
-interrupt which is used to signal frame start. The event is triggered exactly
-when the reception of the first line of the frame starts in the CCDC module.
-The event can be subscribed on the CCDC subdev.
+The CCDC subdev produces V4L2_EVENT_FRAME_START type event on HS_VS
+interrupt which is used to signal frame start. Earlier version of this
+driver used V4L2_EVENT_OMAP3ISP_HS_VS for this purpose. The event is
+triggered exactly when the reception of the first line of the frame starts
+in the CCDC module. The event can be subscribed on the CCDC subdev.
 
 (When using parallel interface one must pay account to correct configuration
 of the VS signal polarity. This is automatically correct when using the serial
diff --git a/drivers/media/video/omap3isp/ispccdc.c b/drivers/media/video/omap3isp/ispccdc.c
index 6766247..61c9e3d 100644
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
+	event.type = V4L2_EVENT_FRAME_START;
+	event.u.frame_sync.buffer_sequence = atomic_read(&pipe->frame_number);
 
 	v4l2_event_queue(vdev, &event);
 }
@@ -1688,7 +1691,7 @@ static long ccdc_ioctl(struct v4l2_subdev *sd, unsigned int cmd, void *arg)
 static int ccdc_subscribe_event(struct v4l2_subdev *sd, struct v4l2_fh *fh,
 				struct v4l2_event_subscription *sub)
 {
-	if (sub->type != V4L2_EVENT_OMAP3ISP_HS_VS)
+	if (sub->type != V4L2_EVENT_FRAME_START)
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

