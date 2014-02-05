Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway15.websitewelcome.com ([69.41.245.9]:60388 "EHLO
	gateway15.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750888AbaBESvx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Feb 2014 13:51:53 -0500
Received: from gator3086.hostgator.com (ns6171.hostgator.com [50.87.144.121])
	by gateway15.websitewelcome.com (Postfix) with ESMTP id 19D60A1147FB3
	for <linux-media@vger.kernel.org>; Wed,  5 Feb 2014 11:58:12 -0600 (CST)
From: Dean Anderson <linux-dev@sensoray.com>
To: hverkuil@xs4all.nl, linux-dev@sensoray.com,
	linux-media@vger.kernel.org
Subject: [PATCH] s2255drv: buffer setup fix
Date: Wed,  5 Feb 2014 09:58:06 -0800
Message-Id: <1391623086-13485-1-git-send-email-linux-dev@sensoray.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Buffer setup should check if minimum number of buffers is used.

Signed-off-by: Dean Anderson <linux-dev@sensoray.com>
---
 drivers/media/usb/s2255/s2255drv.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index 2e24aee..1b267b1 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -69,7 +69,7 @@
 #define S2255_DSP_BOOTTIME      800
 /* maximum time to wait for firmware to load (ms) */
 #define S2255_LOAD_TIMEOUT      (5000 + S2255_DSP_BOOTTIME)
-#define S2255_DEF_BUFS          16
+#define S2255_MIN_BUFS          2
 #define S2255_SETMODE_TIMEOUT   500
 #define S2255_VIDSTATUS_TIMEOUT 350
 #define S2255_MARKER_FRAME	cpu_to_le32(0x2255DA4AL)
@@ -374,9 +374,6 @@ static long s2255_vendor_req(struct s2255_dev *dev, unsigned char req,
 
 static struct usb_driver s2255_driver;
 
-/* Declare static vars that will be used as parameters */
-static unsigned int vid_limit = 16;	/* Video memory limit, in Mb */
-
 /* start video number */
 static int video_nr = -1;	/* /dev/videoN, -1 for autodetect */
 
@@ -385,8 +382,6 @@ static int jpeg_enable = 1;
 
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Debug level(0-100) default 0");
-module_param(vid_limit, int, 0644);
-MODULE_PARM_DESC(vid_limit, "video memory limit(Mb)");
 module_param(video_nr, int, 0644);
 MODULE_PARM_DESC(video_nr, "start video minor(-1 default autodetect)");
 module_param(jpeg_enable, int, 0644);
@@ -671,18 +666,15 @@ static void s2255_fillbuff(struct s2255_vc *vc,
    Videobuf operations
    ------------------------------------------------------------------*/
 
-static int buffer_setup(struct videobuf_queue *vq, unsigned int *count,
+static int buffer_setup(struct videobuf_queue *vq, unsigned int *nbuffers,
 			unsigned int *size)
 {
 	struct s2255_fh *fh = vq->priv_data;
 	struct s2255_vc *vc = fh->vc;
 	*size = vc->width * vc->height * (vc->fmt->depth >> 3);
 
-	if (0 == *count)
-		*count = S2255_DEF_BUFS;
-
-	if (*size * *count > vid_limit * 1024 * 1024)
-		*count = (vid_limit * 1024 * 1024) / *size;
+	if (*nbuffers < S2255_MIN_BUFS)
+		*nbuffers = S2255_MIN_BUFS;
 
 	return 0;
 }
-- 
1.7.9.5

