Return-path: <linux-media-owner@vger.kernel.org>
Received: from exsmtp01.microchip.com ([198.175.253.37]:26258 "EHLO
        email.microchip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755094AbcILHsv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Sep 2016 03:48:51 -0400
From: Songjun Wu <songjun.wu@microchip.com>
To: <nicolas.ferre@atmel.com>, Hans Verkuil <hans.verkuil@cisco.com>
CC: Songjun Wu <songjun.wu@microchip.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>
Subject: [PATCH] [media] atmel-isc: set the format on the first open
Date: Mon, 12 Sep 2016 15:47:24 +0800
Message-ID: <1473666444-20271-1-git-send-email-songjun.wu@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Set the current format on the first open.

Signed-off-by: Songjun Wu <songjun.wu@microchip.com>
---

 drivers/media/platform/atmel/atmel-isc.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
index db6773d..ed8050d 100644
--- a/drivers/media/platform/atmel/atmel-isc.c
+++ b/drivers/media/platform/atmel/atmel-isc.c
@@ -924,10 +924,16 @@ static int isc_open(struct file *file)
 		goto unlock;
 
 	ret = v4l2_subdev_call(sd, core, s_power, 1);
-	if (ret < 0 && ret != -ENOIOCTLCMD)
+	if (ret < 0 && ret != -ENOIOCTLCMD) {
 		v4l2_fh_release(file);
-	else
-		ret = 0;
+		goto unlock;
+	}
+
+	ret = isc_set_fmt(isc, &isc->fmt);
+	if (ret) {
+		v4l2_subdev_call(sd, core, s_power, 0);
+		v4l2_fh_release(file);
+	}
 
 unlock:
 	mutex_unlock(&isc->lock);
@@ -1118,8 +1124,16 @@ static int isc_set_default_fmt(struct isc_device *isc)
 			.pixelformat	= isc->user_formats[0]->fourcc,
 		},
 	};
+	int ret;
 
-	return isc_set_fmt(isc, &f);
+	ret = isc_try_fmt(isc, &f, NULL);
+	if (ret)
+		return ret;
+
+	isc->current_fmt = isc->user_formats[0];
+	isc->fmt = f;
+
+	return 0;
 }
 
 static int isc_async_complete(struct v4l2_async_notifier *notifier)
@@ -1172,20 +1186,12 @@ static int isc_async_complete(struct v4l2_async_notifier *notifier)
 		return ret;
 	}
 
-	ret = v4l2_subdev_call(sd_entity->sd, core, s_power, 1);
-	if (ret < 0 && ret != -ENOIOCTLCMD)
-		return ret;
-
 	ret = isc_set_default_fmt(isc);
 	if (ret) {
 		v4l2_err(&isc->v4l2_dev, "Could not set default format\n");
 		return ret;
 	}
 
-	ret = v4l2_subdev_call(sd_entity->sd, core, s_power, 0);
-	if (ret < 0 && ret != -ENOIOCTLCMD)
-		return ret;
-
 	/* Register video device */
 	strlcpy(vdev->name, ATMEL_ISC_NAME, sizeof(vdev->name));
 	vdev->release		= video_device_release_empty;
-- 
2.7.4

