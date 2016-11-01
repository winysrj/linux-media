Return-path: <linux-media-owner@vger.kernel.org>
Received: from exsmtp02.microchip.com ([198.175.253.38]:19419 "EHLO
        email.microchip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1167926AbcKAIO4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 1 Nov 2016 04:14:56 -0400
From: Songjun Wu <songjun.wu@microchip.com>
To: <nicolas.ferre@atmel.com>
CC: <linux-arm-kernel@lists.infradead.org>,
        Songjun Wu <songjun.wu@microchip.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>
Subject: [PATCH] [media] atmel-isc: release the filehandle if it's not the only one.
Date: Tue, 1 Nov 2016 16:08:46 +0800
Message-ID: <1477987726-4257-1-git-send-email-songjun.wu@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Release the filehandle in 'isc_open' if it's not the only filehandle
opened for the associated video_device.

Signed-off-by: Songjun Wu <songjun.wu@microchip.com>
---

 drivers/media/platform/atmel/atmel-isc.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
index 8e25d3f..5e08404 100644
--- a/drivers/media/platform/atmel/atmel-isc.c
+++ b/drivers/media/platform/atmel/atmel-isc.c
@@ -926,21 +926,21 @@ static int isc_open(struct file *file)
 	if (ret < 0)
 		goto unlock;
 
-	if (!v4l2_fh_is_singular_file(file))
-		goto unlock;
+	ret = !v4l2_fh_is_singular_file(file);
+	if (ret)
+		goto fh_rel;
 
 	ret = v4l2_subdev_call(sd, core, s_power, 1);
-	if (ret < 0 && ret != -ENOIOCTLCMD) {
-		v4l2_fh_release(file);
-		goto unlock;
-	}
+	if (ret < 0 && ret != -ENOIOCTLCMD)
+		goto fh_rel;
 
 	ret = isc_set_fmt(isc, &isc->fmt);
-	if (ret) {
+	if (ret)
 		v4l2_subdev_call(sd, core, s_power, 0);
-		v4l2_fh_release(file);
-	}
 
+fh_rel:
+	if (ret)
+		v4l2_fh_release(file);
 unlock:
 	mutex_unlock(&isc->lock);
 	return ret;
-- 
2.7.4

