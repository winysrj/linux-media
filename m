Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42290 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab1AMDp2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Jan 2011 22:45:28 -0500
Received: by eye27 with SMTP id 27so643077eye.19
        for <linux-media@vger.kernel.org>; Wed, 12 Jan 2011 19:45:27 -0800 (PST)
Date: Thu, 13 Jan 2011 12:46:07 +0900
From: Dmitri Belimov <d.belimov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Stefan Ringel <stefan.ringel@arcor.de>,
	Felipe Sanches <juca@members.fsf.org>,
	Bee Hock Goh <beehock@gmail.com>,
	Luis Henrique Fagundes <lhfagundes@hacklab.com.br>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jarod Wilson <jarod@redhat.com>
Subject: [PATCH] tm6000: rework init code
Message-ID: <20110113124607.2d81ff84@glory.local>
In-Reply-To: <4D0BFF4B.3060001@redhat.com>
References: <4CAD5A78.3070803@redhat.com>
	<20101008150301.2e3ceaff@glory.local>
	<4CAF0602.6050002@redhat.com>
	<20101012142856.2b4ee637@glory.local>
	<4CB492D4.1000609@arcor.de>
	<20101129174412.08f2001c@glory.local>
	<4CF51C9E.6040600@arcor.de>
	<20101201144704.43b58f2c@glory.local>
	<4CF67AB9.6020006@arcor.de>
	<20101202134128.615bbfa0@glory.local>
	<4CF71CF6.7080603@redhat.com>
	<20101206010934.55d07569@glory.local>
	<4CFBF62D.7010301@arcor.de>
	<20101206190230.2259d7ab@glory.local>
	<4CFEA3D2.4050309@arcor.de>
	<20101208125539.739e2ed2@glory.local>
	<4CFFAD1E.7040004@arcor.de>
	<20101214122325.5cdea67e@glory.local>
	<4D079ADF.2000705@arcor.de>
	<20101215164634.44846128@glory.local>
	<4D08E43C.8080002@arcor.de>
	<20101216183844.6258734e@glory.local>
	<4D0A4883.20804@arcor.de>
	<20101217104633.7c9d10d7@glory.local>
	<4D0AF2A7.6080100@arcor.de>
	<20101217160854.16a1f754@glory.local>
	<4D0BFF4B.3060001@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/ezOVWxZxj8W+xYfCiqdNLbN"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--MP_/ezOVWxZxj8W+xYfCiqdNLbN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi

Rework device init part. Move common code part to a function.
Usefull for register multiple devices like video, radio, vbi etc.

diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
index 8fe017c..4d866cc 100644
--- a/drivers/staging/tm6000/tm6000-video.c
+++ b/drivers/staging/tm6000/tm6000-video.c
@@ -1450,29 +1450,55 @@ static struct video_device tm6000_template = {
  * ------------------------------------------------------------------
  */
 
-int tm6000_v4l2_register(struct tm6000_core *dev)
+static struct video_device *vdev_init(struct tm6000_core *dev,
+		const struct video_device
+		*template, const char *type_name)
 {
-	int ret = -1;
 	struct video_device *vfd;
 
 	vfd = video_device_alloc();
-	if(!vfd) {
+	if (NULL == vfd)
+		return NULL;
+
+	*vfd = *template;
+	vfd->v4l2_dev = &dev->v4l2_dev;
+	vfd->release = video_device_release;
+	vfd->debug = tm6000_debug;
+	vfd->lock = &dev->lock;
+
+	snprintf(vfd->name, sizeof(vfd->name), "%s %s", dev->name, type_name);
+
+	video_set_drvdata(vfd, dev);
+	return vfd;
+}
+
+int tm6000_v4l2_register(struct tm6000_core *dev)
+{
+	int ret = -1;
+
+	dev->vfd = vdev_init(dev, &tm6000_template, "video");
+
+	if (!dev->vfd) {
+		printk(KERN_INFO "%s: can't register video device\n",
+		       dev->name);
 		return -ENOMEM;
 	}
-	dev->vfd = vfd;
 
 	/* init video dma queues */
 	INIT_LIST_HEAD(&dev->vidq.active);
 	INIT_LIST_HEAD(&dev->vidq.queued);
 
-	memcpy(dev->vfd, &tm6000_template, sizeof(*(dev->vfd)));
-	dev->vfd->debug = tm6000_debug;
-	dev->vfd->lock = &dev->lock;
+	ret = video_register_device(dev->vfd, VFL_TYPE_GRABBER, video_nr);
 
-	vfd->v4l2_dev = &dev->v4l2_dev;
-	video_set_drvdata(vfd, dev);
+	if (ret < 0) {
+		printk(KERN_INFO "%s: can't register video device\n",
+		       dev->name);
+		return ret;
+	}
+
+	printk(KERN_INFO "%s: registered device %s\n",
+	       dev->name, video_device_node_name(dev->vfd));
 
-	ret = video_register_device(dev->vfd, VFL_TYPE_GRABBER, video_nr);
 	printk(KERN_INFO "Trident TVMaster TM5600/TM6000/TM6010 USB2 board (Load status: %d)\n", ret);
 	return ret;
 }

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>


With my best regards, Dmitry.

--MP_/ezOVWxZxj8W+xYfCiqdNLbN
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=tm6000_video_init.patch

diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
index 8fe017c..4d866cc 100644
--- a/drivers/staging/tm6000/tm6000-video.c
+++ b/drivers/staging/tm6000/tm6000-video.c
@@ -1450,29 +1450,55 @@ static struct video_device tm6000_template = {
  * ------------------------------------------------------------------
  */
 
-int tm6000_v4l2_register(struct tm6000_core *dev)
+static struct video_device *vdev_init(struct tm6000_core *dev,
+		const struct video_device
+		*template, const char *type_name)
 {
-	int ret = -1;
 	struct video_device *vfd;
 
 	vfd = video_device_alloc();
-	if(!vfd) {
+	if (NULL == vfd)
+		return NULL;
+
+	*vfd = *template;
+	vfd->v4l2_dev = &dev->v4l2_dev;
+	vfd->release = video_device_release;
+	vfd->debug = tm6000_debug;
+	vfd->lock = &dev->lock;
+
+	snprintf(vfd->name, sizeof(vfd->name), "%s %s", dev->name, type_name);
+
+	video_set_drvdata(vfd, dev);
+	return vfd;
+}
+
+int tm6000_v4l2_register(struct tm6000_core *dev)
+{
+	int ret = -1;
+
+	dev->vfd = vdev_init(dev, &tm6000_template, "video");
+
+	if (!dev->vfd) {
+		printk(KERN_INFO "%s: can't register video device\n",
+		       dev->name);
 		return -ENOMEM;
 	}
-	dev->vfd = vfd;
 
 	/* init video dma queues */
 	INIT_LIST_HEAD(&dev->vidq.active);
 	INIT_LIST_HEAD(&dev->vidq.queued);
 
-	memcpy(dev->vfd, &tm6000_template, sizeof(*(dev->vfd)));
-	dev->vfd->debug = tm6000_debug;
-	dev->vfd->lock = &dev->lock;
+	ret = video_register_device(dev->vfd, VFL_TYPE_GRABBER, video_nr);
 
-	vfd->v4l2_dev = &dev->v4l2_dev;
-	video_set_drvdata(vfd, dev);
+	if (ret < 0) {
+		printk(KERN_INFO "%s: can't register video device\n",
+		       dev->name);
+		return ret;
+	}
+
+	printk(KERN_INFO "%s: registered device %s\n",
+	       dev->name, video_device_node_name(dev->vfd));
 
-	ret = video_register_device(dev->vfd, VFL_TYPE_GRABBER, video_nr);
 	printk(KERN_INFO "Trident TVMaster TM5600/TM6000/TM6010 USB2 board (Load status: %d)\n", ret);
 	return ret;
 }

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

--MP_/ezOVWxZxj8W+xYfCiqdNLbN--
