Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.135]:56577 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752159AbeADKcV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Jan 2018 05:32:21 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] media: dvb: fix DVB_MMAP symbol name
Date: Thu,  4 Jan 2018 11:31:30 +0100
Message-Id: <20180104103215.15591-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CONFIG_DVB_MMAP was misspelled either as CONFIG_DVB_MMSP
or DVB_MMAP, so it had no effect at all. This fixes that,
to make it possible to build it again.

Fixes: 4021053ed52d ("media: dvb-core: make DVB mmap API optional")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/dvb-core/Makefile |  2 +-
 drivers/media/dvb-core/dmxdev.c | 30 +++++++++++++++---------------
 include/media/dvb_vb2.h         |  2 +-
 3 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/media/dvb-core/Makefile b/drivers/media/dvb-core/Makefile
index 3756ccf83384..045e2392c668 100644
--- a/drivers/media/dvb-core/Makefile
+++ b/drivers/media/dvb-core/Makefile
@@ -4,7 +4,7 @@
 #
 
 dvb-net-$(CONFIG_DVB_NET) := dvb_net.o
-dvb-vb2-$(CONFIG_DVB_MMSP) := dvb_vb2.o
+dvb-vb2-$(CONFIG_DVB_MMAP) := dvb_vb2.o
 
 dvb-core-objs := dvbdev.o dmxdev.o dvb_demux.o		 	\
 		 dvb_ca_en50221.o dvb_frontend.o 		\
diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
index bc198f84b9cd..41e0259fc1c7 100644
--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -128,7 +128,7 @@ static int dvb_dvr_open(struct inode *inode, struct file *file)
 	struct dvb_device *dvbdev = file->private_data;
 	struct dmxdev *dmxdev = dvbdev->priv;
 	struct dmx_frontend *front;
-#ifndef DVB_MMAP
+#ifndef CONFIG_DVB_MMAP
 	bool need_ringbuffer = false;
 #else
 	const bool need_ringbuffer = true;
@@ -144,7 +144,7 @@ static int dvb_dvr_open(struct inode *inode, struct file *file)
 		return -ENODEV;
 	}
 
-#ifndef DVB_MMAP
+#ifndef CONFIG_DVB_MMAP
 	if ((file->f_flags & O_ACCMODE) == O_RDONLY)
 		need_ringbuffer = true;
 #else
@@ -200,7 +200,7 @@ static int dvb_dvr_release(struct inode *inode, struct file *file)
 {
 	struct dvb_device *dvbdev = file->private_data;
 	struct dmxdev *dmxdev = dvbdev->priv;
-#ifndef DVB_MMAP
+#ifndef CONFIG_DVB_MMAP
 	bool need_ringbuffer = false;
 #else
 	const bool need_ringbuffer = true;
@@ -213,7 +213,7 @@ static int dvb_dvr_release(struct inode *inode, struct file *file)
 		dmxdev->demux->connect_frontend(dmxdev->demux,
 						dmxdev->dvr_orig_fe);
 	}
-#ifndef DVB_MMAP
+#ifndef CONFIG_DVB_MMAP
 	if ((file->f_flags & O_ACCMODE) == O_RDONLY)
 		need_ringbuffer = true;
 #endif
@@ -426,7 +426,7 @@ static int dvb_dmxdev_ts_callback(const u8 *buffer1, size_t buffer1_len,
 {
 	struct dmxdev_filter *dmxdevfilter = feed->priv;
 	struct dvb_ringbuffer *buffer;
-#ifdef DVB_MMAP
+#ifdef CONFIG_DVB_MMAP
 	struct dvb_vb2_ctx *ctx;
 #endif
 	int ret;
@@ -440,12 +440,12 @@ static int dvb_dmxdev_ts_callback(const u8 *buffer1, size_t buffer1_len,
 	if (dmxdevfilter->params.pes.output == DMX_OUT_TAP ||
 	    dmxdevfilter->params.pes.output == DMX_OUT_TSDEMUX_TAP) {
 		buffer = &dmxdevfilter->buffer;
-#ifdef DVB_MMAP
+#ifdef CONFIG_DVB_MMAP
 		ctx = &dmxdevfilter->vb2_ctx;
 #endif
 	} else {
 		buffer = &dmxdevfilter->dev->dvr_buffer;
-#ifdef DVB_MMAP
+#ifdef CONFIG_DVB_MMAP
 		ctx = &dmxdevfilter->dev->dvr_vb2_ctx;
 #endif
 	}
@@ -1111,7 +1111,7 @@ static int dvb_demux_do_ioctl(struct file *file,
 		mutex_unlock(&dmxdevfilter->mutex);
 		break;
 
-#ifdef DVB_MMAP
+#ifdef CONFIG_DVB_MMAP
 	case DMX_REQBUFS:
 		if (mutex_lock_interruptible(&dmxdevfilter->mutex)) {
 			mutex_unlock(&dmxdev->mutex);
@@ -1199,7 +1199,7 @@ static __poll_t dvb_demux_poll(struct file *file, poll_table *wait)
 	return mask;
 }
 
-#ifdef DVB_MMAP
+#ifdef CONFIG_DVB_MMAP
 static int dvb_demux_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct dmxdev_filter *dmxdevfilter = file->private_data;
@@ -1249,7 +1249,7 @@ static const struct file_operations dvb_demux_fops = {
 	.release = dvb_demux_release,
 	.poll = dvb_demux_poll,
 	.llseek = default_llseek,
-#ifdef DVB_MMAP
+#ifdef CONFIG_DVB_MMAP
 	.mmap = dvb_demux_mmap,
 #endif
 };
@@ -1280,7 +1280,7 @@ static int dvb_dvr_do_ioctl(struct file *file,
 		ret = dvb_dvr_set_buffer_size(dmxdev, arg);
 		break;
 
-#ifdef DVB_MMAP
+#ifdef CONFIG_DVB_MMAP
 	case DMX_REQBUFS:
 		ret = dvb_vb2_reqbufs(&dmxdev->dvr_vb2_ctx, parg);
 		break;
@@ -1322,7 +1322,7 @@ static __poll_t dvb_dvr_poll(struct file *file, poll_table *wait)
 	struct dvb_device *dvbdev = file->private_data;
 	struct dmxdev *dmxdev = dvbdev->priv;
 	__poll_t mask = 0;
-#ifndef DVB_MMAP
+#ifndef CONFIG_DVB_MMAP
 	bool need_ringbuffer = false;
 #else
 	const bool need_ringbuffer = true;
@@ -1337,7 +1337,7 @@ static __poll_t dvb_dvr_poll(struct file *file, poll_table *wait)
 
 	poll_wait(file, &dmxdev->dvr_buffer.queue, wait);
 
-#ifndef DVB_MMAP
+#ifndef CONFIG_DVB_MMAP
 	if ((file->f_flags & O_ACCMODE) == O_RDONLY)
 		need_ringbuffer = true;
 #endif
@@ -1353,7 +1353,7 @@ static __poll_t dvb_dvr_poll(struct file *file, poll_table *wait)
 	return mask;
 }
 
-#ifdef DVB_MMAP
+#ifdef CONFIG_DVB_MMAP
 static int dvb_dvr_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct dvb_device *dvbdev = file->private_data;
@@ -1381,7 +1381,7 @@ static const struct file_operations dvb_dvr_fops = {
 	.release = dvb_dvr_release,
 	.poll = dvb_dvr_poll,
 	.llseek = default_llseek,
-#ifdef DVB_MMAP
+#ifdef CONFIG_DVB_MMAP
 	.mmap = dvb_dvr_mmap,
 #endif
 };
diff --git a/include/media/dvb_vb2.h b/include/media/dvb_vb2.h
index 49b46e5bdcf0..f511b4d7760b 100644
--- a/include/media/dvb_vb2.h
+++ b/include/media/dvb_vb2.h
@@ -103,7 +103,7 @@ struct dvb_vb2_ctx {
 	char	name[DVB_VB2_NAME_MAX + 1];
 };
 
-#ifndef DVB_MMAP
+#ifndef CONFIG_DVB_MMAP
 static inline int dvb_vb2_init(struct dvb_vb2_ctx *ctx,
 			       const char *name, int non_blocking)
 {
-- 
2.9.0
