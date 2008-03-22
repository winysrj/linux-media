Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fk-out-0910.google.com ([209.85.128.185])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mariofutire@googlemail.com>) id 1JcrV9-0001tR-2j
	for linux-dvb@linuxtv.org; Sat, 22 Mar 2008 01:22:24 +0100
Received: by fk-out-0910.google.com with SMTP id z22so2397029fkz.1
	for <linux-dvb@linuxtv.org>; Fri, 21 Mar 2008 17:22:19 -0700 (PDT)
Message-ID: <47E45138.1030107@googlemail.com>
Date: Sat, 22 Mar 2008 00:22:16 +0000
From: Andrea <mariofutire@googlemail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Content-Type: multipart/mixed; boundary="------------070702080601090906040509"
Subject: [linux-dvb] [PATCH] 2/3: implement DMX_SET_BUFFER_SIZE for dvr
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--------------070702080601090906040509
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This patch implements the ioctl DMX_SET_BUFFER_SIZE for the dvr.

The ioctl used to be supported but not yet implemented.

The way it works is that it replaces the ringbuffer with a new one.
Beforehand it flushes the old buffer.
This means that part of the stream is lost, and reading errors (like overflow) are cleaned.
The flushing is not a problem since this operation usually occurs at beginning before start reading.

Since the dvr is *always* up and running this change has to be done while the buffer is written:

1) On the userspace side, it is as safe as dvb_dvr_read is now:
	- dvb_dvr_set_buffer_size locks the mutex
	- dvb_dvr_read does *not* lock the mutex (the code is there commented out)

So as long as one does not call read simultaneously it works properly.
Maybe the mutex should be enforced in dvb_dvr_read.

2) On the kernel side
The only thing I am not 100% sure about is whether the spin_lock I've used is enough to guarantee
synchronization between the new function dvb_dvr_set_buffer_size (which uses spin_lock_irq) and
dvb_dmxdev_ts_callback and dvb_dmxdev_section_callback (using spin_lock).
But this looks to me the same as all other functions do.


I would like to change documentation about DMX_SET_BUFFER_SIZE, but I could not find the source of
http://www.linuxtv.org/docs/dvbapi/DVB_Demux_Device.html

Andrea






--------------070702080601090906040509
Content-Type: text/x-patch;
 name="size.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="size.diff"

diff -r 1886a5ea2f84 linux/drivers/media/dvb/dvb-core/dmxdev.c
--- a/linux/drivers/media/dvb/dvb-core/dmxdev.c	Fri Mar 21 08:04:55 2008 -0300
+++ b/linux/drivers/media/dvb/dvb-core/dmxdev.c	Sat Mar 22 00:07:56 2008 +0000
@@ -259,6 +259,37 @@ static ssize_t dvb_dvr_read(struct file 
 	return ret;
 }
 
+static int dvb_dvr_set_buffer_size(struct dmxdev *dmxdev,
+				      unsigned long size)
+{
+	struct dvb_ringbuffer *buf = &dmxdev->dvr_buffer;
+	void *mem;
+
+	if (buf->size == size)
+		return 0;
+
+	dprintk("function : %s\n", __FUNCTION__);
+
+	spin_lock(&dmxdev->lock);
+	mem = buf->data;
+	buf->data = NULL;
+	buf->size = size;
+	dvb_ringbuffer_flush(buf);
+	spin_unlock(&dmxdev->lock);
+	vfree(mem);
+
+	if (buf->size) {
+		mem = vmalloc(dmxdev->dvr_buffer.size);
+		if (!mem)
+			return -ENOMEM;
+		spin_lock(&dmxdev->lock);
+		buf->data = mem;
+		spin_unlock(&dmxdev->lock);
+	}
+
+	return 0;
+}
+
 static inline void dvb_dmxdev_filter_state_set(struct dmxdev_filter
 					       *dmxdevfilter, int state)
 {
@@ -1009,6 +1040,7 @@ static int dvb_dvr_do_ioctl(struct inode
 {
 	struct dvb_device *dvbdev = file->private_data;
 	struct dmxdev *dmxdev = dvbdev->priv;
+	unsigned long arg = (unsigned long)parg;
 	int ret;
 
 	if (mutex_lock_interruptible(&dmxdev->mutex))
@@ -1016,8 +1048,7 @@ static int dvb_dvr_do_ioctl(struct inode
 
 	switch (cmd) {
 	case DMX_SET_BUFFER_SIZE:
-		// FIXME: implement
-		ret = 0;
+		ret = dvb_dvr_set_buffer_size(dmxdev, arg);
 		break;
 
 	default:




--------------070702080601090906040509
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------070702080601090906040509--
