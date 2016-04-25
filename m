Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:35510 "EHLO
	mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbcDYX04 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Apr 2016 19:26:56 -0400
Received: by mail-qk0-f169.google.com with SMTP id q76so52776506qke.2
        for <linux-media@vger.kernel.org>; Mon, 25 Apr 2016 16:26:55 -0700 (PDT)
From: Dominic Chen <d.c.ddcc@gmail.com>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, Dominic Chen <d.c.ddcc@gmail.com>
Subject: [PATCH/RFC] dmxdev: Add support for the FIONREAD ioctl
Date: Mon, 25 Apr 2016 19:26:43 -0400
Message-Id: <1461626803-78620-1-git-send-email-d.c.ddcc@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a standard ioctl supported by file descriptors, sockets (as
SIOCINQ), and ttys (as TIOCOUTQ) to get the size of the available
read buffer. It provides userspace with a feedback mechanism to
avoid overflow of the kernel ringbuffer, and is used by e.g.
libevent.

Signed-off-by: Dominic Chen <d.c.ddcc@gmail.com>
---
 drivers/media/dvb-core/dmxdev.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
index a168cbe..668c8d2 100644
--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -28,6 +28,7 @@
 #include <linux/poll.h>
 #include <linux/ioctl.h>
 #include <linux/wait.h>
+#include <asm/ioctls.h>
 #include <asm/uaccess.h>
 #include "dmxdev.h"
 
@@ -57,6 +58,22 @@ static int dvb_dmxdev_buffer_write(struct dvb_ringbuffer *buf,
 	return dvb_ringbuffer_write(buf, src, len);
 }
 
+static int dvb_dmxdev_get_buffer_avail(struct dvb_ringbuffer *src,
+				       u32 *len)
+{
+	if (!src->data) {
+		*len = 0;
+		return 0;
+	}
+
+	if (src->error)
+		return src->error;
+
+	*len = dvb_ringbuffer_avail(src);
+
+	return 0;
+}
+
 static ssize_t dvb_dmxdev_buffer_read(struct dvb_ringbuffer *src,
 				      int non_blocking, char __user *buf,
 				      size_t count, loff_t *ppos)
@@ -965,6 +982,16 @@ static int dvb_demux_do_ioctl(struct file *file,
 		return -ERESTARTSYS;
 
 	switch (cmd) {
+	case FIONREAD:
+		if (mutex_lock_interruptible(&dmxdevfilter->mutex)) {
+			mutex_unlock(&dmxdev->mutex);
+			return -ERESTARTSYS;
+		}
+		ret = dvb_dmxdev_get_buffer_avail(&dmxdevfilter->buffer, parg);
+		mutex_unlock(&dmxdevfilter->mutex);
+
+		break;
+
 	case DMX_START:
 		if (mutex_lock_interruptible(&dmxdevfilter->mutex)) {
 			mutex_unlock(&dmxdev->mutex);
@@ -1160,6 +1187,10 @@ static int dvb_dvr_do_ioctl(struct file *file,
 		return -ERESTARTSYS;
 
 	switch (cmd) {
+	case FIONREAD:
+		ret = dvb_dmxdev_get_buffer_avail(&dmxdev->dvr_buffer, parg);
+		break;
+
 	case DMX_SET_BUFFER_SIZE:
 		ret = dvb_dvr_set_buffer_size(dmxdev, arg);
 		break;
-- 
2.7.4

