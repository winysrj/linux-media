Return-path: <linux-media-owner@vger.kernel.org>
Received: from co1ehsobe005.messaging.microsoft.com ([216.32.180.188]:46522
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753535Ab3DLKva (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Apr 2013 06:51:30 -0400
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	<linux-media@vger.kernel.org>,
	<uclinux-dist-devel@blackfin.uclinux.org>
CC: Scott Jiang <scott.jiang.linux@gmail.com>
Subject: [PATCH 2/2] [media] bfin_capture: add query_dv_timings/enum_dv_timings support
Date: Fri, 12 Apr 2013 19:52:59 -0400
Message-ID: <1365810779-24335-3-git-send-email-scott.jiang.linux@gmail.com>
In-Reply-To: <1365810779-24335-1-git-send-email-scott.jiang.linux@gmail.com>
References: <1365810779-24335-1-git-send-email-scott.jiang.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

More dv_timings ioctl ops are introduced in video core.
Add query_dv_timings/enum_dv_timings accordingly.

Signed-off-by: Scott Jiang <scott.jiang.linux@gmail.com>
---
 drivers/media/platform/blackfin/bfin_capture.c |   28 ++++++++++++++++++------
 1 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index 5f209d5..1d58846 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -649,18 +649,30 @@ static int bcap_s_std(struct file *file, void *priv, v4l2_std_id *std)
 	return 0;
 }
 
-static int bcap_g_dv_timings(struct file *file, void *priv,
+static int bcap_enum_dv_timings(struct file *file, void *priv,
+				struct v4l2_enum_dv_timings *timings)
+{
+	struct bcap_device *bcap_dev = video_drvdata(file);
+
+	return v4l2_subdev_call(bcap_dev->sd, video,
+			enum_dv_timings, timings);
+}
+
+static int bcap_query_dv_timings(struct file *file, void *priv,
 				struct v4l2_dv_timings *timings)
 {
 	struct bcap_device *bcap_dev = video_drvdata(file);
-	int ret;
 
-	ret = v4l2_subdev_call(bcap_dev->sd, video,
-				g_dv_timings, timings);
-	if (ret < 0)
-		return ret;
+	return v4l2_subdev_call(bcap_dev->sd, video,
+				query_dv_timings, timings);
+}
 
-	bcap_dev->dv_timings = *timings;
+static int bcap_g_dv_timings(struct file *file, void *priv,
+				struct v4l2_dv_timings *timings)
+{
+	struct bcap_device *bcap_dev = video_drvdata(file);
+
+	*timings = bcap_dev->dv_timings;
 	return 0;
 }
 
@@ -921,6 +933,8 @@ static const struct v4l2_ioctl_ops bcap_ioctl_ops = {
 	.vidioc_g_std            = bcap_g_std,
 	.vidioc_s_dv_timings     = bcap_s_dv_timings,
 	.vidioc_g_dv_timings     = bcap_g_dv_timings,
+	.vidioc_query_dv_timings = bcap_query_dv_timings,
+	.vidioc_enum_dv_timings  = bcap_enum_dv_timings,
 	.vidioc_reqbufs          = bcap_reqbufs,
 	.vidioc_querybuf         = bcap_querybuf,
 	.vidioc_qbuf             = bcap_qbuf,
-- 
1.7.0.4


