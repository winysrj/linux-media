Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay02.digicable.hu ([92.249.128.188]:39958 "EHLO
	relay02.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968032Ab0B1OUR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Feb 2010 09:20:17 -0500
Message-ID: <4B8A7B83.8060203@freemail.hu>
Date: Sun, 28 Feb 2010 15:19:47 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Kang Yong <kangyong@telegent.com>,
	Zhang Xiaobing <xbzhang@telegent.com>,
	Huang Shijie <zyziii@telegent.com>,
	Huang Shijie <shijie8@gmail.com>
CC: V4L Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] tlg2300: cleanups when power management is not configured
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

When power management is not configured (CONFIG_PM) then some code is no longer
necessary.

This patch will remove the following compiler warnings:
 * pd-dvb.c: In function 'poseidon_fe_release':
 * pd-dvb.c:101: warning: unused variable 'pd'
 * pd-video.c:14: warning: 'pm_video_suspend' declared 'static' but never defined
 * pd-video.c:15: warning: 'pm_video_resume' declared 'static' but never defined

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -r 37581bb7e6f1 linux/drivers/media/video/tlg2300/pd-dvb.c
--- a/linux/drivers/media/video/tlg2300/pd-dvb.c	Wed Feb 24 22:48:50 2010 -0300
+++ b/linux/drivers/media/video/tlg2300/pd-dvb.c	Sun Feb 28 15:13:05 2010 +0100
@@ -96,15 +96,17 @@
 	return ret;
 }

+#ifdef CONFIG_PM
 static void poseidon_fe_release(struct dvb_frontend *fe)
 {
 	struct poseidon *pd = fe->demodulator_priv;

-#ifdef CONFIG_PM
 	pd->pm_suspend = NULL;
 	pd->pm_resume  = NULL;
+}
+#else
+#define poseidon_fe_release NULL
 #endif
-}

 static s32 poseidon_fe_sleep(struct dvb_frontend *fe)
 {
diff -r 37581bb7e6f1 linux/drivers/media/video/tlg2300/pd-video.c
--- a/linux/drivers/media/video/tlg2300/pd-video.c	Wed Feb 24 22:48:50 2010 -0300
+++ b/linux/drivers/media/video/tlg2300/pd-video.c	Sun Feb 28 15:13:05 2010 +0100
@@ -11,8 +11,10 @@
 #include "pd-common.h"
 #include "vendorcmds.h"

+#ifdef CONFIG_PM
 static int pm_video_suspend(struct poseidon *pd);
 static int pm_video_resume(struct poseidon *pd);
+#endif
 static void iso_bubble_handler(struct work_struct *w);

 int usb_transfer_mode;
