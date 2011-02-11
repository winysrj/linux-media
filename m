Return-path: <mchehab@pedra>
Received: from queueout02-winn.ispmail.ntl.com ([81.103.221.56]:44959 "EHLO
	queueout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758012Ab1BKVq3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Feb 2011 16:46:29 -0500
From: Daniel Drake <dsd@laptop.org>
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org
Cc: corbet@lwn.net
Cc: dilinger@queued.net
Subject: [PATCH] via-camera: Add suspend/resume support
Message-Id: <20110211211502.D6D8E9D401D@zog.reactivated.net>
Date: Fri, 11 Feb 2011 21:15:02 +0000 (GMT)
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add suspend/resume support to the via-camera driver, so that the video
continues streaming over a suspend-resume cycle.

Originally implemented by Jon Corbet.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/media/video/via-camera.c |   64 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 64 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/via-camera.c b/drivers/media/video/via-camera.c
index 2f973cd..f307e5f 100644
--- a/drivers/media/video/via-camera.c
+++ b/drivers/media/video/via-camera.c
@@ -1246,6 +1246,62 @@ static const struct v4l2_ioctl_ops viacam_ioctl_ops = {
 /*
  * Power management.
  */
+#ifdef CONFIG_PM
+
+static int viacam_suspend(void *priv)
+{
+	struct via_camera *cam = priv;
+	enum viacam_opstate state = cam->opstate;
+
+	if (cam->opstate != S_IDLE) {
+		viacam_stop_engine(cam);
+		cam->opstate = state; /* So resume restarts */
+	}
+
+	return 0;
+}
+
+static int viacam_resume(void *priv)
+{
+	struct via_camera *cam = priv;
+	int ret = 0;
+
+	/*
+	 * Get back to a reasonable operating state.
+	 */
+	via_write_reg_mask(VIASR, 0x78, 0, 0x80);
+	via_write_reg_mask(VIASR, 0x1e, 0xc0, 0xc0);
+	viacam_int_disable(cam);
+	set_bit(CF_CONFIG_NEEDED, &cam->flags);
+	/*
+	 * Make sure the sensor's power state is correct
+	 */
+	if (cam->users > 0)
+		via_sensor_power_up(cam);
+	else
+		via_sensor_power_down(cam);
+	/*
+	 * If it was operating, try to restart it.
+	 */
+	if (cam->opstate != S_IDLE) {
+		mutex_lock(&cam->lock);
+		ret = viacam_configure_sensor(cam);
+		if (! ret)
+			ret = viacam_config_controller(cam);
+		mutex_unlock(&cam->lock);
+		if (! ret)
+			viacam_start_engine(cam);
+	}
+
+	return ret;
+}
+
+static struct viafb_pm_hooks viacam_pm_hooks = {
+	.suspend = viacam_suspend,
+	.resume = viacam_resume
+};
+
+#endif /* CONFIG_PM */
 
 /*
  * Setup stuff.
@@ -1369,6 +1425,14 @@ static __devinit int viacam_probe(struct platform_device *pdev)
 		goto out_irq;
 	video_set_drvdata(&cam->vdev, cam);
 
+#ifdef CONFIG_PM
+	/*
+	 * Hook into PM events
+	 */
+	viacam_pm_hooks.private = cam;
+	viafb_pm_register(&viacam_pm_hooks);
+#endif
+
 	/* Power the sensor down until somebody opens the device */
 	via_sensor_power_down(cam);
 	return 0;
-- 
1.7.4

