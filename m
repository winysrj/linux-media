Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.osadl.org ([62.245.132.105]:53726 "EHLO www.osadl.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751212AbdAPN5m (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Jan 2017 08:57:42 -0500
From: Nicholas Mc Guire <hofrat@osadl.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH] [media] ov9650: use msleep() for uncritical long delay
Date: Mon, 16 Jan 2017 14:58:33 +0100
Message-Id: <1484575113-24098-1-git-send-email-hofrat@osadl.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ulseep_range() uses hrtimers and provides no advantage over msleep()
for larger delays. Fix up the 25ms delays here to use msleep() and
reduce the load on the hrtimer subsystem.

Link: http://lkml.org/lkml/2017/1/11/377
Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
---
Problem found by coccinelle script

Patch was compile tested with: x86_64_defconfig + CONFIG_MEDIA_SUPPORT=m
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y, CONFIG_MEDIA_CONTROLLER=y
CONFIG_VIDEO_V4L2_SUBDEV_API=y, CONFIG_MEDIA_SUBDRV_AUTOSELECT=n
CONFIG_VIDEO_OV9650=m

Patch is aginast 4.10-rc3 (localversion-next is next-20170116)

 drivers/media/i2c/ov9650.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ov9650.c b/drivers/media/i2c/ov9650.c
index 502c722..2de2fbb 100644
--- a/drivers/media/i2c/ov9650.c
+++ b/drivers/media/i2c/ov9650.c
@@ -522,7 +522,7 @@ static void __ov965x_set_power(struct ov965x *ov965x, int on)
 	if (on) {
 		ov965x_gpio_set(ov965x->gpios[GPIO_PWDN], 0);
 		ov965x_gpio_set(ov965x->gpios[GPIO_RST], 0);
-		usleep_range(25000, 26000);
+		msleep(25);
 	} else {
 		ov965x_gpio_set(ov965x->gpios[GPIO_RST], 1);
 		ov965x_gpio_set(ov965x->gpios[GPIO_PWDN], 1);
@@ -1438,7 +1438,7 @@ static int ov965x_detect_sensor(struct v4l2_subdev *sd)
 
 	mutex_lock(&ov965x->lock);
 	__ov965x_set_power(ov965x, 1);
-	usleep_range(25000, 26000);
+	msleep(25);
 
 	/* Check sensor revision */
 	ret = ov965x_read(client, REG_PID, &pid);
-- 
2.1.4

