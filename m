Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35147 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbbESLBL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2015 07:01:11 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antoine Jacquet <royale@zerezo.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>,
	Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>,
	Peter Senna Tschudin <peter.senna@gmail.com>,
	linux-usb@vger.kernel.org
Subject: [PATCH 1/2] usb drivers: use BUG_ON() instead of if () BUG
Date: Tue, 19 May 2015 08:00:56 -0300
Message-Id: <0fee1624f3df1827cb6d0154253f9c45793bf3e1.1432033220.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some USB drivers have a logic at the VB buffer handling like:
	if (in_interrupt())
		BUG();
Use, instead:
	BUG_ON(in_interrupt());

Btw, this logic looks weird on my eyes. We should convert them
to use VB2, in order to avoid those crappy things.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/cx231xx/cx231xx-417.c b/drivers/media/usb/cx231xx/cx231xx-417.c
index 855a708387c6..47a98a2014a5 100644
--- a/drivers/media/usb/cx231xx/cx231xx-417.c
+++ b/drivers/media/usb/cx231xx/cx231xx-417.c
@@ -1249,8 +1249,7 @@ static void free_buffer(struct videobuf_queue *vq, struct cx231xx_buffer *buf)
 	struct cx231xx *dev = fh->dev;
 	unsigned long flags = 0;
 
-	if (in_interrupt())
-		BUG();
+	BUG_ON(in_interrupt());
 
 	spin_lock_irqsave(&dev->video_mode.slock, flags);
 	if (dev->USE_ISO) {
diff --git a/drivers/media/usb/cx231xx/cx231xx-vbi.c b/drivers/media/usb/cx231xx/cx231xx-vbi.c
index 80261ac40208..a08014d20a5c 100644
--- a/drivers/media/usb/cx231xx/cx231xx-vbi.c
+++ b/drivers/media/usb/cx231xx/cx231xx-vbi.c
@@ -192,8 +192,7 @@ static void free_buffer(struct videobuf_queue *vq, struct cx231xx_buffer *buf)
 	struct cx231xx_fh *fh = vq->priv_data;
 	struct cx231xx *dev = fh->dev;
 	unsigned long flags = 0;
-	if (in_interrupt())
-		BUG();
+	BUG_ON(in_interrupt());
 
 	/* We used to wait for the buffer to finish here, but this didn't work
 	   because, as we were keeping the state as VIDEOBUF_QUEUED,
diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index af44f2d1c0a1..c6ff8968286a 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -749,8 +749,7 @@ static void free_buffer(struct videobuf_queue *vq, struct cx231xx_buffer *buf)
 	struct cx231xx *dev = fh->dev;
 	unsigned long flags = 0;
 
-	if (in_interrupt())
-		BUG();
+	BUG_ON(in_interrupt());
 
 	/* We used to wait for the buffer to finish here, but this didn't work
 	   because, as we were keeping the state as VIDEOBUF_QUEUED,
diff --git a/drivers/media/usb/tm6000/tm6000-video.c b/drivers/media/usb/tm6000/tm6000-video.c
index 77ce9efe1f24..26b6ae8d04da 100644
--- a/drivers/media/usb/tm6000/tm6000-video.c
+++ b/drivers/media/usb/tm6000/tm6000-video.c
@@ -714,8 +714,7 @@ static void free_buffer(struct videobuf_queue *vq, struct tm6000_buffer *buf)
 	struct tm6000_core   *dev = fh->dev;
 	unsigned long flags;
 
-	if (in_interrupt())
-		BUG();
+	BUG_ON(in_interrupt());
 
 	/* We used to wait for the buffer to finish here, but this didn't work
 	   because, as we were keeping the state as VIDEOBUF_QUEUED,
diff --git a/drivers/media/usb/zr364xx/zr364xx.c b/drivers/media/usb/zr364xx/zr364xx.c
index ca850316d379..7433ba5c4bad 100644
--- a/drivers/media/usb/zr364xx/zr364xx.c
+++ b/drivers/media/usb/zr364xx/zr364xx.c
@@ -377,8 +377,7 @@ static void free_buffer(struct videobuf_queue *vq, struct zr364xx_buffer *buf)
 {
 	_DBG("%s\n", __func__);
 
-	if (in_interrupt())
-		BUG();
+	BUG_ON(in_interrupt());
 
 	videobuf_vmalloc_free(&buf->vb);
 	buf->vb.state = VIDEOBUF_NEEDS_INIT;
-- 
2.1.0

