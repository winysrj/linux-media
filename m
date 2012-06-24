Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2254 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879Ab2FXL3T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jun 2012 07:29:19 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Andy Walls <awalls@md.metrocast.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Manjunatha Halli <manjunatha_halli@ti.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>,
	Anatolij Gustschin <agust@denx.de>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Sensoray Linux Development <linux-dev@sensoray.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Sachin Kamat <sachin.kamat@linaro.org>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	mitov@issp.bas.bg, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 17/26] bfin_capture: remove V4L2_FL_LOCK_ALL_FOPS
Date: Sun, 24 Jun 2012 13:26:09 +0200
Message-Id: <b2dda39d22d754510be4dd390f55670f52249913.1340536092.git.hans.verkuil@cisco.com>
In-Reply-To: <1340537178-18768-1-git-send-email-hverkuil@xs4all.nl>
References: <1340537178-18768-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <f854d2a0a932187cd895bf9cd81d2da8343b52c9.1340536092.git.hans.verkuil@cisco.com>
References: <f854d2a0a932187cd895bf9cd81d2da8343b52c9.1340536092.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add proper locking to the file operations, allowing for the removal
of the V4L2_FL_LOCK_ALL_FOPS flag.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/blackfin/bfin_capture.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/blackfin/bfin_capture.c b/drivers/media/video/blackfin/bfin_capture.c
index 0aba45e..1677623 100644
--- a/drivers/media/video/blackfin/bfin_capture.c
+++ b/drivers/media/video/blackfin/bfin_capture.c
@@ -235,8 +235,13 @@ static int bcap_release(struct file *file)
 static int bcap_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct bcap_device *bcap_dev = video_drvdata(file);
+	int ret;
 
-	return vb2_mmap(&bcap_dev->buffer_queue, vma);
+	if (mutex_lock_interruptible(&bcap_dev->mutex))
+		return -ERESTARTSYS;
+	ret = vb2_mmap(&bcap_dev->buffer_queue, vma);
+	mutex_unlock(&bcap_dev->mutex);
+	return ret;
 }
 
 #ifndef CONFIG_MMU
@@ -259,8 +264,12 @@ static unsigned long bcap_get_unmapped_area(struct file *file,
 static unsigned int bcap_poll(struct file *file, poll_table *wait)
 {
 	struct bcap_device *bcap_dev = video_drvdata(file);
+	unsigned int res;
 
-	return vb2_poll(&bcap_dev->buffer_queue, file, wait);
+	mutex_lock(&bcap_dev->mutex);
+	res = vb2_poll(&bcap_dev->buffer_queue, file, wait);
+	mutex_unlock(&bcap_dev->mutex);
+	return res;
 }
 
 static int bcap_queue_setup(struct vb2_queue *vq,
@@ -942,10 +951,6 @@ static int __devinit bcap_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&bcap_dev->dma_queue);
 
 	vfd->lock = &bcap_dev->mutex;
-	/* Locking in file operations other than ioctl should be done
-	   by the driver, not the V4L2 core.
-	   This driver needs auditing so that this flag can be removed. */
-	set_bit(V4L2_FL_LOCK_ALL_FOPS, &vfd->flags);
 
 	/* register video device */
 	ret = video_register_device(bcap_dev->video_dev, VFL_TYPE_GRABBER, -1);
-- 
1.7.10

