Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:40935 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755770Ab1EATGF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 May 2011 15:06:05 -0400
Received: from tobias-t61p.localnet (unknown [10.2.3.10])
	by mail.lorenz.priv (Postfix) with ESMTPS id 62972142AD
	for <linux-media@vger.kernel.org>; Sun,  1 May 2011 21:06:01 +0200 (CEST)
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/6] remove #ifdef to show rds support by i2c driver.
Date: Sun, 1 May 2011 21:01:43 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105012101.43801.tobias.lorenz@gmx.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This removes some #ifdef statements.
RDS support is now indicated by I2C driver too.
The functionality was already in the driver.

Signed-off-by: Tobias Lorenz <tobias.lorenz@gmx.net>
---
 drivers/media/radio/si470x/radio-si470x-common.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/media/radio/si470x/radio-si470x-common.c 
b/drivers/media/radio/si470x/radio-si470x-common.c
index f016220..bf58931 100644
--- a/drivers/media/radio/si470x/radio-si470x-common.c
+++ b/drivers/media/radio/si470x/radio-si470x-common.c
@@ -687,12 +687,8 @@ static int si470x_vidioc_g_tuner(struct file *file, void 
*priv,
 	/* driver constants */
 	strcpy(tuner->name, "FM");
 	tuner->type = V4L2_TUNER_RADIO;
-#if defined(CONFIG_USB_SI470X) || defined(CONFIG_USB_SI470X_MODULE)
 	tuner->capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_STEREO |
 			    V4L2_TUNER_CAP_RDS | V4L2_TUNER_CAP_RDS_BLOCK_IO;
-#else
-	tuner->capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_STEREO;
-#endif
 
 	/* range limits */
 	switch ((radio->registers[SYSCONFIG2] & SYSCONFIG2_BAND) >> 6) {
@@ -718,12 +714,10 @@ static int si470x_vidioc_g_tuner(struct file *file, void 
*priv,
 		tuner->rxsubchans = V4L2_TUNER_SUB_MONO;
 	else
 		tuner->rxsubchans = V4L2_TUNER_SUB_MONO | V4L2_TUNER_SUB_STEREO;
-#if defined(CONFIG_USB_SI470X) || defined(CONFIG_USB_SI470X_MODULE)
 	/* If there is a reliable method of detecting an RDS channel,
 	   then this code should check for that before setting this
 	   RDS subchannel. */
 	tuner->rxsubchans |= V4L2_TUNER_SUB_RDS;
-#endif
 
 	/* mono/stereo selector */
 	if ((radio->registers[POWERCFG] & POWERCFG_MONO) == 0)
-- 
1.7.4.1

