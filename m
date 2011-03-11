Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:50993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920Ab1CKUMk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2011 15:12:40 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p2BKCe4F006158
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 11 Mar 2011 15:12:40 -0500
Received: from pedra (vpn-228-17.phx2.redhat.com [10.3.228.17])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p2BKCcll009816
	for <linux-media@vger.kernel.org>; Fri, 11 Mar 2011 15:12:39 -0500
Date: Fri, 11 Mar 2011 17:08:29 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/2] [media] several drivers: Fix a few gcc 4.6 warnings
Message-ID: <20110311170829.1b771081@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

au0828-dvb.c:99:6: warning: variable 'ptr' set but not used [-Wunused-but-set-variable]
au0828-video.c:1180:25: warning: variable 'maxheight' set but not used [-Wunused-but-set-variable]
au0828-video.c:1180:15: warning: variable 'maxwidth' set but not used [-Wunused-but-set-variable]
bttv-input.c:196:16: warning: variable 'current_jiffies' set but not used [-Wunused-but-set-variable]

Those variables are not used at all, so just remove them.

Cc: Steven Toth <stoth@hauppauge.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/au0828/au0828-dvb.c b/drivers/media/video/au0828/au0828-dvb.c
index f1edf1d..5182167 100644
--- a/drivers/media/video/au0828/au0828-dvb.c
+++ b/drivers/media/video/au0828/au0828-dvb.c
@@ -96,7 +96,6 @@ static struct tda18271_config hauppauge_woodbury_tunerconfig = {
 /*-------------------------------------------------------------------*/
 static void urb_completion(struct urb *purb)
 {
-	u8 *ptr;
 	struct au0828_dev *dev = purb->context;
 	int ptype = usb_pipetype(purb->pipe);
 
@@ -114,8 +113,6 @@ static void urb_completion(struct urb *purb)
 		return;
 	}
 
-	ptr = (u8 *)purb->transfer_buffer;
-
 	/* Feed the transport payload into the kernel demux */
 	dvb_dmx_swfilter_packets(&dev->dvb.demux,
 		purb->transfer_buffer, purb->actual_length / 188);
diff --git a/drivers/media/video/au0828/au0828-video.c b/drivers/media/video/au0828/au0828-video.c
index 9c475c6..6ad83a1 100644
--- a/drivers/media/video/au0828/au0828-video.c
+++ b/drivers/media/video/au0828/au0828-video.c
@@ -1177,10 +1177,6 @@ static int au0828_set_format(struct au0828_dev *dev, unsigned int cmd,
 	int ret;
 	int width = format->fmt.pix.width;
 	int height = format->fmt.pix.height;
-	unsigned int maxwidth, maxheight;
-
-	maxwidth = 720;
-	maxheight = 480;
 
 	if (format->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
diff --git a/drivers/media/video/bt8xx/bttv-input.c b/drivers/media/video/bt8xx/bttv-input.c
index e8b64bc..677d70c 100644
--- a/drivers/media/video/bt8xx/bttv-input.c
+++ b/drivers/media/video/bt8xx/bttv-input.c
@@ -193,12 +193,10 @@ static void bttv_rc5_timer_end(unsigned long data)
 {
 	struct bttv_ir *ir = (struct bttv_ir *)data;
 	struct timeval tv;
-	unsigned long current_jiffies;
 	u32 gap;
 	u32 rc5 = 0;
 
 	/* get time */
-	current_jiffies = jiffies;
 	do_gettimeofday(&tv);
 
 	/* avoid overflow with gap >1s */
-- 
1.7.1


