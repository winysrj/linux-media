Return-path: <mchehab@pedra>
Received: from mailout4.samsung.com ([203.254.224.34]:20312 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518Ab0HYIsa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Aug 2010 04:48:30 -0400
Received: from epmmp1 (mailout4.samsung.com [203.254.224.34])
 by mailout4.samsung.com
 (Sun Java(tm) System Messaging Server 7u3-15.01 64bit (built Feb 12 2010))
 with ESMTP id <0L7P00BQU9SQC2C0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 25 Aug 2010 17:48:26 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0L7P0094Y9SQBQ@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 25 Aug 2010 17:48:26 +0900 (KST)
Date: Wed, 25 Aug 2010 17:48:48 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: [PATCH 2/3] radio-si470x: Remove ifdef for RDS
In-reply-to: <1282726129-28408-1-git-send-email-jy0922.shim@samsung.com>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, tobias.lorenz@gmx.net,
	kyungmin.park@samsung.com
Message-id: <1282726129-28408-2-git-send-email-jy0922.shim@samsung.com>
Content-transfer-encoding: 7BIT
References: <1282726129-28408-1-git-send-email-jy0922.shim@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

The si470x i2c and usb driver support the RDS, so this ifdef statement
doesn't need more.

Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
---
 drivers/media/radio/si470x/radio-si470x-common.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/media/radio/si470x/radio-si470x-common.c b/drivers/media/radio/si470x/radio-si470x-common.c
index 7585566..5c80df8 100644
--- a/drivers/media/radio/si470x/radio-si470x-common.c
+++ b/drivers/media/radio/si470x/radio-si470x-common.c
@@ -679,12 +679,8 @@ static int si470x_vidioc_g_tuner(struct file *file, void *priv,
 	/* driver constants */
 	strcpy(tuner->name, "FM");
 	tuner->type = V4L2_TUNER_RADIO;
-#if defined(CONFIG_USB_SI470X) || defined(CONFIG_USB_SI470X_MODULE)
 	tuner->capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_STEREO |
 			    V4L2_TUNER_CAP_RDS;
-#else
-	tuner->capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_STEREO;
-#endif
 
 	/* range limits */
 	switch ((radio->registers[SYSCONFIG2] & SYSCONFIG2_BAND) >> 6) {
@@ -710,12 +706,10 @@ static int si470x_vidioc_g_tuner(struct file *file, void *priv,
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
1.7.0.4

