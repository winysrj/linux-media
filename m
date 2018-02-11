Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:64265 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753040AbeBKL05 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 11 Feb 2018 06:26:57 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Inki Dae <inki.dae@samsung.com>,
        Kees Cook <keescook@chromium.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Satendra Singh Thakur <satendra.t@samsung.com>
Subject: [PATCH v2 2/4] media: dmxdev: Fix the logic that enables DMA mmap support
Date: Sun, 11 Feb 2018 09:26:48 -0200
Message-Id: <2a934801a219411fabe0623470f3132b51f63e96.1518347588.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1518347588.git.mchehab@s-opensource.com>
References: <cover.1518347588.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1518347588.git.mchehab@s-opensource.com>
References: <cover.1518347588.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some conditions required for DVB mmap support to work are reversed.
Also, the logic is not too clear.

So, improve the logic, making it easier to be handled.

PS.: I'm pretty sure that I fixed it while testing, but, somehow,
the change got lost.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dmxdev.c | 76 +++++++++++++++++++++++------------------
 include/media/dmxdev.h          |  2 ++
 2 files changed, 44 insertions(+), 34 deletions(-)

diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
index 15847b64698b..ad349fe26aa2 100644
--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -128,11 +128,7 @@ static int dvb_dvr_open(struct inode *inode, struct file *file)
 	struct dvb_device *dvbdev = file->private_data;
 	struct dmxdev *dmxdev = dvbdev->priv;
 	struct dmx_frontend *front;
-#ifndef CONFIG_DVB_MMAP
 	bool need_ringbuffer = false;
-#else
-	const bool need_ringbuffer = true;
-#endif
 
 	dprintk("%s\n", __func__);
 
@@ -144,17 +140,31 @@ static int dvb_dvr_open(struct inode *inode, struct file *file)
 		return -ENODEV;
 	}
 
-#ifndef CONFIG_DVB_MMAP
+	dmxdev->may_do_mmap = 0;
+
+	/*
+	 * The logic here is a little tricky due to the ifdef.
+	 *
+	 * The ringbuffer is used for both read and mmap.
+	 *
+	 * It is not needed, however, on two situations:
+	 * 	- Write devices (access with O_WRONLY);
+	 *	- For duplex device nodes, opened with O_RDWR.
+	 */
+
 	if ((file->f_flags & O_ACCMODE) == O_RDONLY)
 		need_ringbuffer = true;
-#else
-	if ((file->f_flags & O_ACCMODE) == O_RDWR) {
+	else if ((file->f_flags & O_ACCMODE) == O_RDWR) {
 		if (!(dmxdev->capabilities & DMXDEV_CAP_DUPLEX)) {
+#ifdef CONFIG_DVB_MMAP
+			dmxdev->may_do_mmap = 1;
+			need_ringbuffer = true;
+#else
 			mutex_unlock(&dmxdev->mutex);
 			return -EOPNOTSUPP;
+#endif
 		}
 	}
-#endif
 
 	if (need_ringbuffer) {
 		void *mem;
@@ -169,8 +179,9 @@ static int dvb_dvr_open(struct inode *inode, struct file *file)
 			return -ENOMEM;
 		}
 		dvb_ringbuffer_init(&dmxdev->dvr_buffer, mem, DVR_BUFFER_SIZE);
-		dvb_vb2_init(&dmxdev->dvr_vb2_ctx, "dvr",
-			     file->f_flags & O_NONBLOCK);
+		if (dmxdev->may_do_mmap)
+			dvb_vb2_init(&dmxdev->dvr_vb2_ctx, "dvr",
+				     file->f_flags & O_NONBLOCK);
 		dvbdev->readers--;
 	}
 
@@ -200,11 +211,6 @@ static int dvb_dvr_release(struct inode *inode, struct file *file)
 {
 	struct dvb_device *dvbdev = file->private_data;
 	struct dmxdev *dmxdev = dvbdev->priv;
-#ifndef CONFIG_DVB_MMAP
-	bool need_ringbuffer = false;
-#else
-	const bool need_ringbuffer = true;
-#endif
 
 	mutex_lock(&dmxdev->mutex);
 
@@ -213,15 +219,14 @@ static int dvb_dvr_release(struct inode *inode, struct file *file)
 		dmxdev->demux->connect_frontend(dmxdev->demux,
 						dmxdev->dvr_orig_fe);
 	}
-#ifndef CONFIG_DVB_MMAP
-	if ((file->f_flags & O_ACCMODE) == O_RDONLY)
-		need_ringbuffer = true;
-#endif
 
-	if (need_ringbuffer) {
-		if (dvb_vb2_is_streaming(&dmxdev->dvr_vb2_ctx))
-			dvb_vb2_stream_off(&dmxdev->dvr_vb2_ctx);
-		dvb_vb2_release(&dmxdev->dvr_vb2_ctx);
+	if (((file->f_flags & O_ACCMODE) == O_RDONLY) ||
+	    dmxdev->may_do_mmap) {
+		if (dmxdev->may_do_mmap) {
+			if (dvb_vb2_is_streaming(&dmxdev->dvr_vb2_ctx))
+				dvb_vb2_stream_off(&dmxdev->dvr_vb2_ctx);
+			dvb_vb2_release(&dmxdev->dvr_vb2_ctx);
+		}
 		dvbdev->readers++;
 		if (dmxdev->dvr_buffer.data) {
 			void *mem = dmxdev->dvr_buffer.data;
@@ -802,6 +807,12 @@ static int dvb_demux_open(struct inode *inode, struct file *file)
 	mutex_init(&dmxdevfilter->mutex);
 	file->private_data = dmxdevfilter;
 
+#ifdef CONFIG_DVB_MMAP
+	dmxdev->may_do_mmap = 1;
+#else
+	dmxdev->may_do_mmap = 0;
+#endif
+
 	dvb_ringbuffer_init(&dmxdevfilter->buffer, NULL, 8192);
 	dvb_vb2_init(&dmxdevfilter->vb2_ctx, "demux_filter",
 		     file->f_flags & O_NONBLOCK);
@@ -1206,6 +1217,9 @@ static int dvb_demux_mmap(struct file *file, struct vm_area_struct *vma)
 	struct dmxdev *dmxdev = dmxdevfilter->dev;
 	int ret;
 
+	if (!dmxdev->may_do_mmap)
+		return -EOPNOTSUPP;
+
 	if (mutex_lock_interruptible(&dmxdev->mutex))
 		return -ERESTARTSYS;
 
@@ -1323,12 +1337,6 @@ static unsigned int dvb_dvr_poll(struct file *file, poll_table *wait)
 	struct dmxdev *dmxdev = dvbdev->priv;
 	unsigned int mask = 0;
 
-#ifndef CONFIG_DVB_MMAP
-	bool need_ringbuffer = false;
-#else
-	const bool need_ringbuffer = true;
-#endif
-
 	dprintk("%s\n", __func__);
 
 	if (dmxdev->exit)
@@ -1338,11 +1346,8 @@ static unsigned int dvb_dvr_poll(struct file *file, poll_table *wait)
 
 	poll_wait(file, &dmxdev->dvr_buffer.queue, wait);
 
-#ifndef CONFIG_DVB_MMAP
-	if ((file->f_flags & O_ACCMODE) == O_RDONLY)
-		need_ringbuffer = true;
-#endif
-	if (need_ringbuffer) {
+	if (((file->f_flags & O_ACCMODE) == O_RDONLY) ||
+	    dmxdev->may_do_mmap) {
 		if (dmxdev->dvr_buffer.error)
 			mask |= (POLLIN | POLLRDNORM | POLLPRI | POLLERR);
 
@@ -1361,6 +1366,9 @@ static int dvb_dvr_mmap(struct file *file, struct vm_area_struct *vma)
 	struct dmxdev *dmxdev = dvbdev->priv;
 	int ret;
 
+	if (!dmxdev->may_do_mmap)
+		return -EOPNOTSUPP;
+
 	if (dmxdev->exit)
 		return -ENODEV;
 
diff --git a/include/media/dmxdev.h b/include/media/dmxdev.h
index 2f5cb2c7b6a7..baafa3b8aca4 100644
--- a/include/media/dmxdev.h
+++ b/include/media/dmxdev.h
@@ -163,6 +163,7 @@ struct dmxdev_filter {
  * @demux:		pointer to &struct dmx_demux.
  * @filternum:		number of filters.
  * @capabilities:	demux capabilities as defined by &enum dmx_demux_caps.
+ * @may_do_mmap:	flag used to indicate if the device may do mmap.
  * @exit:		flag to indicate that the demux is being released.
  * @dvr_orig_fe:	pointer to &struct dmx_frontend.
  * @dvr_buffer:		embedded &struct dvb_ringbuffer for DVB output.
@@ -180,6 +181,7 @@ struct dmxdev {
 	int filternum;
 	int capabilities;
 
+	unsigned int may_do_mmap:1;
 	unsigned int exit:1;
 #define DMXDEV_CAP_DUPLEX 1
 	struct dmx_frontend *dvr_orig_fe;
-- 
2.14.3
