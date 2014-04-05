Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45768 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753573AbaDEUYD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 5 Apr 2014 16:24:03 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/4] msi3101: check I/O return values on stop streaming
Date: Sat,  5 Apr 2014 23:23:43 +0300
Message-Id: <1396729424-17576-4-git-send-email-crope@iki.fi>
In-Reply-To: <1396729424-17576-1-git-send-email-crope@iki.fi>
References: <1396729424-17576-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Coverity CID 1196496: Unchecked return value (CHECKED_RETURN)

Calling "msi3101_ctrl_msg" without checking return value (as is done
elsewhere 8 out of 10 times).

Reported-by: <scan-admin@coverity.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/msi3101/sdr-msi3101.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
index c6adf5f..559466f 100644
--- a/drivers/staging/media/msi3101/sdr-msi3101.c
+++ b/drivers/staging/media/msi3101/sdr-msi3101.c
@@ -1077,6 +1077,7 @@ static int msi3101_start_streaming(struct vb2_queue *vq, unsigned int count)
 static int msi3101_stop_streaming(struct vb2_queue *vq)
 {
 	struct msi3101_state *s = vb2_get_drv_priv(vq);
+	int ret;
 	dev_dbg(&s->udev->dev, "%s:\n", __func__);
 
 	if (mutex_lock_interruptible(&s->v4l2_lock))
@@ -1089,17 +1090,22 @@ static int msi3101_stop_streaming(struct vb2_queue *vq)
 
 	/* according to tests, at least 700us delay is required  */
 	msleep(20);
-	msi3101_ctrl_msg(s, CMD_STOP_STREAMING, 0);
+	ret = msi3101_ctrl_msg(s, CMD_STOP_STREAMING, 0);
+	if (ret)
+		goto err_sleep_tuner;
 
 	/* sleep USB IF / ADC */
-	msi3101_ctrl_msg(s, CMD_WREG, 0x01000003);
+	ret = msi3101_ctrl_msg(s, CMD_WREG, 0x01000003);
+	if (ret)
+		goto err_sleep_tuner;
 
+err_sleep_tuner:
 	/* sleep tuner */
-	v4l2_subdev_call(s->v4l2_subdev, core, s_power, 0);
+	ret = v4l2_subdev_call(s->v4l2_subdev, core, s_power, 0);
 
 	mutex_unlock(&s->v4l2_lock);
 
-	return 0;
+	return ret;
 }
 
 static struct vb2_ops msi3101_vb2_ops = {
-- 
1.9.0

