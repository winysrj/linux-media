Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:56080 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162055Ab2CPXgV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Mar 2012 19:36:21 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 6/7] mmp-camera: Don't power up the sensor on resume
Date: Fri, 16 Mar 2012 17:14:55 -0600
Message-Id: <1331939696-12482-7-git-send-email-corbet@lwn.net>
In-Reply-To: <1331939696-12482-1-git-send-email-corbet@lwn.net>
References: <1331939696-12482-1-git-send-email-corbet@lwn.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We still need to power up the controller to avoid unsightly self-immolation
should something try to access its registers, but the sensor can stay
powered down unless the camera was actually operating at suspend time.
This gets rid of the camera LED flash on resume, fixing OLPC bug #11644.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/media/video/marvell-ccic/mmp-driver.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/marvell-ccic/mmp-driver.c b/drivers/media/video/marvell-ccic/mmp-driver.c
index 0d64e2d..d235523 100644
--- a/drivers/media/video/marvell-ccic/mmp-driver.c
+++ b/drivers/media/video/marvell-ccic/mmp-driver.c
@@ -106,6 +106,13 @@ static struct mmp_camera *mmpcam_find_device(struct platform_device *pdev)
 /*
  * Power control.
  */
+static void mmpcam_power_up_ctlr(struct mmp_camera *cam)
+{
+	iowrite32(0x3f, cam->power_regs + REG_CCIC_DCGCR);
+	iowrite32(0x3805b, cam->power_regs + REG_CCIC_CRCR);
+	mdelay(1);
+}
+
 static void mmpcam_power_up(struct mcam_camera *mcam)
 {
 	struct mmp_camera *cam = mcam_to_cam(mcam);
@@ -113,9 +120,7 @@ static void mmpcam_power_up(struct mcam_camera *mcam)
 /*
  * Turn on power and clocks to the controller.
  */
-	iowrite32(0x3f, cam->power_regs + REG_CCIC_DCGCR);
-	iowrite32(0x3805b, cam->power_regs + REG_CCIC_CRCR);
-	mdelay(1);
+	mmpcam_power_up_ctlr(cam);
 /*
  * Provide power to the sensor.
  */
@@ -335,7 +340,7 @@ static int mmpcam_resume(struct platform_device *pdev)
 	 * touch a register even if nothing was active before; trust
 	 * me, it's better this way.
 	 */
-	mmpcam_power_up(&cam->mcam);
+	mmpcam_power_up_ctlr(cam);
 	return mccic_resume(&cam->mcam);
 }
 
-- 
1.7.9.3

