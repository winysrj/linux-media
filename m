Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:32910 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754034AbdL1Pfh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Dec 2017 10:35:37 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Inki Dae <inki.dae@samsung.com>,
        devendra sharma <devendra.sharma9091@gmail.com>,
        Junghak Sung <jh1009.sung@samsung.com>
Subject: [PATCH] media: dvb-core: make DVB mmap API optional
Date: Thu, 28 Dec 2017 13:35:30 -0200
Message-Id: <899da6f6ae59d33b99c3d3f1ababa76784b0774d.1514475320.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This API is still experimental. Make it optional, allowing to
compile the code without it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/Kconfig            | 12 ++++++++
 drivers/media/dvb-core/Makefile  |  3 +-
 drivers/media/dvb-core/dmxdev.c  | 66 +++++++++++++++++++++++++++++++++++-----
 drivers/media/dvb-core/dvb_vb2.h | 29 +++++++++++++++---
 4 files changed, 97 insertions(+), 13 deletions(-)

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index edfe99b22d56..3f69b948d102 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -144,6 +144,18 @@ config DVB_CORE
 	default y
 	select CRC32
 
+config DVB_MMAP
+	bool "Enable DVB memory-mapped API (EXPERIMENTAL)"
+	depends on DVB_CORE
+	default n
+	help
+	  This option enables DVB experimental memory-mapped API, with
+	  reduces the number of context switches to read DVB buffers, as
+	  the buffers can use mmap() syscalls.
+
+	  Support for it is experimental. Use with care. If unsure,
+	  say N.
+
 config DVB_NET
 	bool "DVB Network Support"
 	default (NET && INET)
diff --git a/drivers/media/dvb-core/Makefile b/drivers/media/dvb-core/Makefile
index bbc65dfa0a8e..3756ccf83384 100644
--- a/drivers/media/dvb-core/Makefile
+++ b/drivers/media/dvb-core/Makefile
@@ -4,9 +4,10 @@
 #
 
 dvb-net-$(CONFIG_DVB_NET) := dvb_net.o
+dvb-vb2-$(CONFIG_DVB_MMSP) := dvb_vb2.o
 
 dvb-core-objs := dvbdev.o dmxdev.o dvb_demux.o		 	\
 		 dvb_ca_en50221.o dvb_frontend.o 		\
-		 $(dvb-net-y) dvb_ringbuffer.o dvb_vb2.o dvb_math.o
+		 $(dvb-net-y) dvb_ringbuffer.o $(dvb-vb2-y) dvb_math.o
 
 obj-$(CONFIG_DVB_CORE) += dvb-core.o
diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
index 4cbb9003a1ed..4edee131f1fa 100644
--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -128,6 +128,11 @@ static int dvb_dvr_open(struct inode *inode, struct file *file)
 	struct dvb_device *dvbdev = file->private_data;
 	struct dmxdev *dmxdev = dvbdev->priv;
 	struct dmx_frontend *front;
+#ifndef DVB_MMAP
+	bool need_ringbuffer = false;
+#else
+	const bool need_ringbuffer = true;
+#endif
 
 	dprintk("%s\n", __func__);
 
@@ -139,8 +144,19 @@ static int dvb_dvr_open(struct inode *inode, struct file *file)
 		return -ENODEV;
 	}
 
-	if (((file->f_flags & O_ACCMODE) == O_RDONLY) ||
-	    ((file->f_flags & O_ACCMODE) == O_RDWR)) {
+#ifndef DVB_MMAP
+	if ((file->f_flags & O_ACCMODE) == O_RDONLY)
+		need_ringbuffer = true;
+#else
+	if ((file->f_flags & O_ACCMODE) == O_RDWR) {
+		if (!(dmxdev->capabilities & DMXDEV_CAP_DUPLEX)) {
+			mutex_unlock(&dmxdev->mutex);
+			return -EOPNOTSUPP;
+		}
+	}
+#endif
+
+	if (need_ringbuffer) {
 		void *mem;
 
 		if (!dvbdev->readers) {
@@ -184,6 +200,11 @@ static int dvb_dvr_release(struct inode *inode, struct file *file)
 {
 	struct dvb_device *dvbdev = file->private_data;
 	struct dmxdev *dmxdev = dvbdev->priv;
+#ifndef DVB_MMAP
+	bool need_ringbuffer = false;
+#else
+	const bool need_ringbuffer = true;
+#endif
 
 	mutex_lock(&dmxdev->mutex);
 
@@ -192,8 +213,12 @@ static int dvb_dvr_release(struct inode *inode, struct file *file)
 		dmxdev->demux->connect_frontend(dmxdev->demux,
 						dmxdev->dvr_orig_fe);
 	}
-	if (((file->f_flags & O_ACCMODE) == O_RDONLY) ||
-	    ((file->f_flags & O_ACCMODE) == O_RDWR)) {
+#ifndef DVB_MMAP
+	if ((file->f_flags & O_ACCMODE) == O_RDONLY)
+		need_ringbuffer = true;
+#endif
+
+	if (need_ringbuffer) {
 		if (dvb_vb2_is_streaming(&dmxdev->dvr_vb2_ctx))
 			dvb_vb2_stream_off(&dmxdev->dvr_vb2_ctx);
 		dvb_vb2_release(&dmxdev->dvr_vb2_ctx);
@@ -361,6 +386,7 @@ static int dvb_dmxdev_section_callback(const u8 *buffer1, size_t buffer1_len,
 {
 	struct dmxdev_filter *dmxdevfilter = filter->priv;
 	int ret;
+
 	if (!dvb_vb2_is_streaming(&dmxdevfilter->vb2_ctx) &&
 	    dmxdevfilter->buffer.error) {
 		wake_up(&dmxdevfilter->buffer.queue);
@@ -402,7 +428,9 @@ static int dvb_dmxdev_ts_callback(const u8 *buffer1, size_t buffer1_len,
 {
 	struct dmxdev_filter *dmxdevfilter = feed->priv;
 	struct dvb_ringbuffer *buffer;
+#ifdef DVB_MMAP
 	struct dvb_vb2_ctx *ctx;
+#endif
 	int ret;
 
 	spin_lock(&dmxdevfilter->dev->lock);
@@ -414,10 +442,14 @@ static int dvb_dmxdev_ts_callback(const u8 *buffer1, size_t buffer1_len,
 	if (dmxdevfilter->params.pes.output == DMX_OUT_TAP ||
 	    dmxdevfilter->params.pes.output == DMX_OUT_TSDEMUX_TAP) {
 		buffer = &dmxdevfilter->buffer;
+#ifdef DVB_MMAP
 		ctx = &dmxdevfilter->vb2_ctx;
+#endif
 	} else {
 		buffer = &dmxdevfilter->dev->dvr_buffer;
+#ifdef DVB_MMAP
 		ctx = &dmxdevfilter->dev->dvr_vb2_ctx;
+#endif
 	}
 
 	if (dvb_vb2_is_streaming(ctx)) {
@@ -1081,6 +1113,7 @@ static int dvb_demux_do_ioctl(struct file *file,
 		mutex_unlock(&dmxdevfilter->mutex);
 		break;
 
+#ifdef DVB_MMAP
 	case DMX_REQBUFS:
 		if (mutex_lock_interruptible(&dmxdevfilter->mutex)) {
 			mutex_unlock(&dmxdev->mutex);
@@ -1127,7 +1160,7 @@ static int dvb_demux_do_ioctl(struct file *file,
 		ret = dvb_vb2_dqbuf(&dmxdevfilter->vb2_ctx, parg);
 		mutex_unlock(&dmxdevfilter->mutex);
 		break;
-
+#endif
 	default:
 		ret = -EINVAL;
 		break;
@@ -1168,6 +1201,7 @@ static unsigned int dvb_demux_poll(struct file *file, poll_table *wait)
 	return mask;
 }
 
+#ifdef DVB_MMAP
 static int dvb_demux_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct dmxdev_filter *dmxdevfilter = file->private_data;
@@ -1188,6 +1222,7 @@ static int dvb_demux_mmap(struct file *file, struct vm_area_struct *vma)
 
 	return ret;
 }
+#endif
 
 static int dvb_demux_release(struct inode *inode, struct file *file)
 {
@@ -1216,7 +1251,9 @@ static const struct file_operations dvb_demux_fops = {
 	.release = dvb_demux_release,
 	.poll = dvb_demux_poll,
 	.llseek = default_llseek,
+#ifdef DVB_MMAP
 	.mmap = dvb_demux_mmap,
+#endif
 };
 
 static const struct dvb_device dvbdev_demux = {
@@ -1245,6 +1282,7 @@ static int dvb_dvr_do_ioctl(struct file *file,
 		ret = dvb_dvr_set_buffer_size(dmxdev, arg);
 		break;
 
+#ifdef DVB_MMAP
 	case DMX_REQBUFS:
 		ret = dvb_vb2_reqbufs(&dmxdev->dvr_vb2_ctx, parg);
 		break;
@@ -1266,7 +1304,7 @@ static int dvb_dvr_do_ioctl(struct file *file,
 	case DMX_DQBUF:
 		ret = dvb_vb2_dqbuf(&dmxdev->dvr_vb2_ctx, parg);
 		break;
-
+#endif
 	default:
 		ret = -EINVAL;
 		break;
@@ -1286,6 +1324,11 @@ static unsigned int dvb_dvr_poll(struct file *file, poll_table *wait)
 	struct dvb_device *dvbdev = file->private_data;
 	struct dmxdev *dmxdev = dvbdev->priv;
 	unsigned int mask = 0;
+#ifndef DVB_MMAP
+	bool need_ringbuffer = false;
+#else
+	const bool need_ringbuffer = true;
+#endif
 
 	dprintk("%s\n", __func__);
 
@@ -1296,8 +1339,11 @@ static unsigned int dvb_dvr_poll(struct file *file, poll_table *wait)
 
 	poll_wait(file, &dmxdev->dvr_buffer.queue, wait);
 
-	if (((file->f_flags & O_ACCMODE) == O_RDONLY) ||
-	    ((file->f_flags & O_ACCMODE) == O_RDWR)) {
+#ifndef DVB_MMAP
+	if ((file->f_flags & O_ACCMODE) == O_RDONLY)
+		need_ringbuffer = true;
+#endif
+	if (need_ringbuffer) {
 		if (dmxdev->dvr_buffer.error)
 			mask |= (POLLIN | POLLRDNORM | POLLPRI | POLLERR);
 
@@ -1309,6 +1355,7 @@ static unsigned int dvb_dvr_poll(struct file *file, poll_table *wait)
 	return mask;
 }
 
+#ifdef DVB_MMAP
 static int dvb_dvr_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct dvb_device *dvbdev = file->private_data;
@@ -1325,6 +1372,7 @@ static int dvb_dvr_mmap(struct file *file, struct vm_area_struct *vma)
 	mutex_unlock(&dmxdev->mutex);
 	return ret;
 }
+#endif
 
 static const struct file_operations dvb_dvr_fops = {
 	.owner = THIS_MODULE,
@@ -1335,7 +1383,9 @@ static const struct file_operations dvb_dvr_fops = {
 	.release = dvb_dvr_release,
 	.poll = dvb_dvr_poll,
 	.llseek = default_llseek,
+#ifdef DVB_MMAP
 	.mmap = dvb_dvr_mmap,
+#endif
 };
 
 static const struct dvb_device dvbdev_dvr = {
diff --git a/drivers/media/dvb-core/dvb_vb2.h b/drivers/media/dvb-core/dvb_vb2.h
index a5164effee16..2b250bbaeece 100644
--- a/drivers/media/dvb-core/dvb_vb2.h
+++ b/drivers/media/dvb-core/dvb_vb2.h
@@ -54,13 +54,36 @@ struct dvb_vb2_ctx {
 	char	name[DVB_VB2_NAME_MAX + 1];
 };
 
-int dvb_vb2_init(struct dvb_vb2_ctx *ctx, const char *name, int non_blocking);
-int dvb_vb2_release(struct dvb_vb2_ctx *ctx);
 int dvb_vb2_stream_on(struct dvb_vb2_ctx *ctx);
 int dvb_vb2_stream_off(struct dvb_vb2_ctx *ctx);
+#ifndef DVB_MMAP
+static inline int dvb_vb2_init(struct dvb_vb2_ctx *ctx, const char *name, int non_blocking)
+{
+	return 0;
+};
+static inline int dvb_vb2_release(struct dvb_vb2_ctx *ctx)
+{
+	return 0;
+};
+#define dvb_vb2_is_streaming(ctx) (0)
+#define dvb_vb2_fill_buffer(ctx, file, wait) (0)
+
+static inline unsigned int dvb_vb2_poll(struct dvb_vb2_ctx *ctx,
+					struct file *file,
+				        poll_table *wait)
+{
+	return 0;
+}
+#else
+int dvb_vb2_init(struct dvb_vb2_ctx *ctx, const char *name, int non_blocking);
+int dvb_vb2_release(struct dvb_vb2_ctx *ctx);
 int dvb_vb2_is_streaming(struct dvb_vb2_ctx *ctx);
 int dvb_vb2_fill_buffer(struct dvb_vb2_ctx *ctx,
 			const unsigned char *src, int len);
+unsigned int dvb_vb2_poll(struct dvb_vb2_ctx *ctx, struct file *file,
+			  poll_table *wait);
+#endif
+
 
 int dvb_vb2_reqbufs(struct dvb_vb2_ctx *ctx, struct dmx_requestbuffers *req);
 int dvb_vb2_querybuf(struct dvb_vb2_ctx *ctx, struct dmx_buffer *b);
@@ -68,7 +91,5 @@ int dvb_vb2_expbuf(struct dvb_vb2_ctx *ctx, struct dmx_exportbuffer *exp);
 int dvb_vb2_qbuf(struct dvb_vb2_ctx *ctx, struct dmx_buffer *b);
 int dvb_vb2_dqbuf(struct dvb_vb2_ctx *ctx, struct dmx_buffer *b);
 int dvb_vb2_mmap(struct dvb_vb2_ctx *ctx, struct vm_area_struct *vma);
-unsigned int dvb_vb2_poll(struct dvb_vb2_ctx *ctx, struct file *file,
-			  poll_table *wait);
 
 #endif /* _DVB_VB2_H */
-- 
2.14.3
