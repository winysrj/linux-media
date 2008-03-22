Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from py-out-1112.google.com ([64.233.166.179])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mariofutire@googlemail.com>) id 1Jd1yD-0002E2-5C
	for linux-dvb@linuxtv.org; Sat, 22 Mar 2008 12:33:10 +0100
Received: by py-out-1112.google.com with SMTP id a29so2314417pyi.0
	for <linux-dvb@linuxtv.org>; Sat, 22 Mar 2008 04:32:56 -0700 (PDT)
Message-ID: <47E4EE65.1040901@googlemail.com>
Date: Sat, 22 Mar 2008 11:32:53 +0000
From: Andrea <mariofutire@googlemail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <mailman.1.1206183601.26852.linux-dvb@linuxtv.org>
In-Reply-To: <mailman.1.1206183601.26852.linux-dvb@linuxtv.org>
Content-Type: multipart/mixed; boundary="------------040907010300090409080103"
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
--------------040907010300090409080103
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I've updated this patch following your remarks about PATCH 1/3.

About your feedback, I am not sure I understand what you mean, but I will try:

  > Do not release the lock before the ringbuffer is consistent again.

If you mean that the lock should not be released while buf->data = NULL, this is *not* a problem.
A ringbuffer with NULL data *is* consistent (even though it is useless).
All functions in dmxdev.c check for a NULL pointer before calling read or write on the ringbuffer.
The same happens for the buffer of the demux.

  > We should not free the old buffer before we got a new one.

I like you idea, but I did not want to change the existing logic.

You might have noticed that the new function dvb_dvr_set_buffer_size is very similar to
dvb_dmxdev_set_buffer_size (which exists already): I did not want to introduce a new logic of
resizing the ringbuffer, but I've written a function very very similar.

Maybe in a following patch one could change both of them.

  > As the ring buffer can be written from an ISR, we have to use
    spin_lock_irqsave/spin_unlock_irqrestore here.

Ok, I've changed the patch.
If I use spin_lock_irqsave in dvb_dvr_set_buffer_size (called via IOCTL), do I need to use the same
kind of spin_lock on all other spin_lock on the same lock (e.g. dvb_dmxdev_ts_callback)?




Let me know if I should be more aggressive and change the resize for dvr and demux at once within
this patch. Otherwise if and when this is accepted I will rearrange the code.

Andrea


--------------040907010300090409080103
Content-Type: text/x-patch;
 name="size2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="size2.diff"

diff -r 1886a5ea2f84 linux/drivers/media/dvb/dvb-core/dmxdev.c
--- a/linux/drivers/media/dvb/dvb-core/dmxdev.c	Fri Mar 21 08:04:55 2008 -0300
+++ b/linux/drivers/media/dvb/dvb-core/dmxdev.c	Sat Mar 22 10:12:58 2008 +0000
@@ -259,6 +259,38 @@ static ssize_t dvb_dvr_read(struct file 
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
+	dvb_ringbuffer_reset(buf);
+	
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
@@ -1009,6 +1041,7 @@ static int dvb_dvr_do_ioctl(struct inode
 {
 	struct dvb_device *dvbdev = file->private_data;
 	struct dmxdev *dmxdev = dvbdev->priv;
+	unsigned long arg = (unsigned long)parg;
 	int ret;
 
 	if (mutex_lock_interruptible(&dmxdev->mutex))
@@ -1016,8 +1049,7 @@ static int dvb_dvr_do_ioctl(struct inode
 
 	switch (cmd) {
 	case DMX_SET_BUFFER_SIZE:
-		// FIXME: implement
-		ret = 0;
+		ret = dvb_dvr_set_buffer_size(dmxdev, arg);
 		break;
 
 	default:


--------------040907010300090409080103
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------040907010300090409080103--
