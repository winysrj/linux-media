Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60238 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbbD3OI7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2015 10:08:59 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Pawel Osciak <pawel@osciak.com>,
	Mikhail Domrachev <mihail.domrychev@comexp.ru>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH 13/22] saa7134-empress: use pr_debug() for the saa7134 empress module
Date: Thu, 30 Apr 2015 11:08:33 -0300
Message-Id: <a339db607230decbb46beab03247624321fd5de1.1430402823.git.mchehab@osg.samsung.com>
In-Reply-To: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
References: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
In-Reply-To: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
References: <cf299adba61007966689167eae0f09265aa9abbc.1430402823.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As this module doesn't use any debug level, it is easy to
just replace all debug printks by pr_debug().

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/pci/saa7134/saa7134-empress.c b/drivers/media/pci/saa7134/saa7134-empress.c
index 5d687bcb74ce..e7db4a7166ad 100644
--- a/drivers/media/pci/saa7134/saa7134-empress.c
+++ b/drivers/media/pci/saa7134/saa7134-empress.c
@@ -39,13 +39,6 @@ static unsigned int empress_nr[] = {[0 ... (SAA7134_MAXBOARDS - 1)] = UNSET };
 module_param_array(empress_nr, int, NULL, 0444);
 MODULE_PARM_DESC(empress_nr,"ts device number");
 
-static unsigned int debug;
-module_param(debug, int, 0644);
-MODULE_PARM_DESC(debug,"enable debug messages");
-
-#define dprintk(fmt, arg...)	if (debug)			\
-	printk(KERN_DEBUG "%s/empress: " fmt, dev->name , ## arg)
-
 /* ------------------------------------------------------------------ */
 
 static int start_streaming(struct vb2_queue *vq, unsigned int count)
@@ -221,9 +214,9 @@ static void empress_signal_update(struct work_struct *work)
 		container_of(work, struct saa7134_dev, empress_workqueue);
 
 	if (dev->nosignal) {
-		dprintk("no video signal\n");
+		pr_debug("no video signal\n");
 	} else {
-		dprintk("video signal acquired\n");
+		pr_debug("video signal acquired\n");
 	}
 }
 
@@ -255,7 +248,7 @@ static int empress_init(struct saa7134_dev *dev)
 	struct vb2_queue *q;
 	int err;
 
-	dprintk("%s: %s\n",dev->name,__func__);
+	pr_debug("%s: %s\n",dev->name,__func__);
 	dev->empress_dev = video_device_alloc();
 	if (NULL == dev->empress_dev)
 		return -ENOMEM;
@@ -317,7 +310,7 @@ static int empress_init(struct saa7134_dev *dev)
 
 static int empress_fini(struct saa7134_dev *dev)
 {
-	dprintk("%s: %s\n",dev->name,__func__);
+	pr_debug("%s: %s\n",dev->name,__func__);
 
 	if (NULL == dev->empress_dev)
 		return 0;
-- 
2.1.0

