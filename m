Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.mnsspb.ru ([84.204.75.2]:39124 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754286Ab2JVOF4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Oct 2012 10:05:56 -0400
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, Kirill Smelkov <kirr@mns.spb.ru>
Subject: [PATCH 2/2] [media] vivi: Teach it to tune FPS
Date: Mon, 22 Oct 2012 17:54:44 +0400
Message-Id: <1350914084-31618-2-git-send-email-kirr@mns.spb.ru>
In-Reply-To: <1350914084-31618-1-git-send-email-kirr@mns.spb.ru>
References: <1350914084-31618-1-git-send-email-kirr@mns.spb.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I was testing my video-over-ethernet subsystem today, and vivi seemed to
be perfect video source for testing when one don't have lots of capture
boards and cameras. Only its framerate was hardcoded to NTSC's 30fps,
while in my country we usually use PAL (25 fps). That's why the patch.
Thanks.

Signed-off-by: Kirill Smelkov <kirr@mns.spb.ru>
---
 drivers/media/platform/vivi.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/vivi.c b/drivers/media/platform/vivi.c
index 3e6902a..48325f4 100644
--- a/drivers/media/platform/vivi.c
+++ b/drivers/media/platform/vivi.c
@@ -36,10 +36,6 @@
 
 #define VIVI_MODULE_NAME "vivi"
 
-/* Wake up at about 30 fps */
-#define WAKE_NUMERATOR 30
-#define WAKE_DENOMINATOR 1001
-
 #define MAX_WIDTH 1920
 #define MAX_HEIGHT 1200
 
@@ -58,6 +54,11 @@ static unsigned n_devs = 1;
 module_param(n_devs, uint, 0644);
 MODULE_PARM_DESC(n_devs, "number of video devices to create");
 
+static struct v4l2_fract fps = { 30000, 1001 }; /* ~ 30 fps by default */
+static unsigned __fps[2], __nfps;
+module_param_array_named(fps, __fps, uint, &__nfps, 0644);
+MODULE_PARM_DESC(fps, "frames per second as ratio (e.g. 30000,1001 or 25,1)");
+
 static unsigned debug;
 module_param(debug, uint, 0644);
 MODULE_PARM_DESC(debug, "activates debug info");
@@ -661,7 +662,7 @@ static void vivi_thread_tick(struct vivi_dev *dev)
 }
 
 #define frames_to_ms(frames)					\
-	((frames * WAKE_NUMERATOR * 1000) / WAKE_DENOMINATOR)
+	((frames * fps.denominator * 1000) / fps.numerator)
 
 static void vivi_sleep(struct vivi_dev *dev)
 {
@@ -1376,6 +1377,13 @@ static int __init vivi_init(void)
 	if (n_devs <= 0)
 		n_devs = 1;
 
+	if (__nfps > 0) {
+		fps.numerator   = __fps[0];
+		fps.denominator = (__nfps > 1) ? __fps[1] : 1;
+	}
+	if (fps.numerator <= 0)
+		fps.numerator = 1;
+
 	for (i = 0; i < n_devs; i++) {
 		ret = vivi_create_instance(i);
 		if (ret) {
-- 
1.8.0.rc3.331.g5b9a629

