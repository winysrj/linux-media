Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:32852 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbZD1XlB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2009 19:41:01 -0400
Received: by ewy24 with SMTP id 24so930350ewy.37
        for <linux-media@vger.kernel.org>; Tue, 28 Apr 2009 16:40:59 -0700 (PDT)
Date: Tue, 28 Apr 2009 19:41:08 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: linux-media@vger.kernel.org, video4linux-list@redhat.com
Subject: [PATCH 1/3 ] increase MPEG encoder timout
Message-ID: <20090428194108.5bd76afd@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/TdzRCZz5bB2yP9jSNVsj/lb"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/TdzRCZz5bB2yP9jSNVsj/lb
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi All.

If video has a lot of changes in frame, MPEG encoder need more time for coding process.
Add new bigger timeout for encoder.

This is patch from our customer. I checked this.

diff -r b40d628f830d linux/drivers/media/video/saa7134/saa7134-ts.c
--- a/linux/drivers/media/video/saa7134/saa7134-ts.c	Fri Apr 24 01:46:41 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-ts.c	Tue Apr 28 05:26:09 2009 +1000
@@ -65,7 +65,7 @@
 	/* start DMA */
 	saa7134_set_dmabits(dev);
 
-	mod_timer(&dev->ts_q.timeout, jiffies+BUFFER_TIMEOUT);
+	mod_timer(&dev->ts_q.timeout, jiffies+TS_BUFFER_TIMEOUT);
 
 	if (dev->ts_state == SAA7134_TS_BUFF_DONE) {
 		/* Clear TS cache */
diff -r b40d628f830d linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h	Fri Apr 24 01:46:41 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134.h	Tue Apr 28 05:26:09 2009 +1000
@@ -367,6 +367,7 @@
 #define INTERLACE_OFF          2
 
 #define BUFFER_TIMEOUT     msecs_to_jiffies(500)  /* 0.5 seconds */
+#define TS_BUFFER_TIMEOUT  msecs_to_jiffies(1000)  /* 1 second */
 
 struct saa7134_dev;
 struct saa7134_dma;

Signed-off-by: Alexey Osipov <lion-simba@pridelands.ru>


With my best regards, Dmitry.
--MP_/TdzRCZz5bB2yP9jSNVsj/lb
Content-Type: text/x-patch; name=empress_buffer_timout.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=empress_buffer_timout.patch

diff -r b40d628f830d linux/drivers/media/video/saa7134/saa7134-ts.c
--- a/linux/drivers/media/video/saa7134/saa7134-ts.c	Fri Apr 24 01:46:41 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-ts.c	Tue Apr 28 05:26:09 2009 +1000
@@ -65,7 +65,7 @@
 	/* start DMA */
 	saa7134_set_dmabits(dev);
 
-	mod_timer(&dev->ts_q.timeout, jiffies+BUFFER_TIMEOUT);
+	mod_timer(&dev->ts_q.timeout, jiffies+TS_BUFFER_TIMEOUT);
 
 	if (dev->ts_state == SAA7134_TS_BUFF_DONE) {
 		/* Clear TS cache */
diff -r b40d628f830d linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h	Fri Apr 24 01:46:41 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134.h	Tue Apr 28 05:26:09 2009 +1000
@@ -367,6 +367,7 @@
 #define INTERLACE_OFF          2
 
 #define BUFFER_TIMEOUT     msecs_to_jiffies(500)  /* 0.5 seconds */
+#define TS_BUFFER_TIMEOUT  msecs_to_jiffies(1000)  /* 1 second */
 
 struct saa7134_dev;
 struct saa7134_dma;

Signed-off-by: Alexey Osipov <lion-simba@pridelands.ru>

--MP_/TdzRCZz5bB2yP9jSNVsj/lb--
