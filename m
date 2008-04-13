Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.153])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mariofutire@googlemail.com>) id 1JkyXd-0001j2-KG
	for linux-dvb@linuxtv.org; Sun, 13 Apr 2008 11:30:33 +0200
Received: by fg-out-1718.google.com with SMTP id 22so1385228fge.25
	for <linux-dvb@linuxtv.org>; Sun, 13 Apr 2008 02:30:29 -0700 (PDT)
Message-ID: <4801D2B1.9050502@googlemail.com>
Date: Sun, 13 Apr 2008 10:30:25 +0100
From: Andrea <mariofutire@googlemail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org, o.endriss@gmx.de
References: <mailman.1.1206183601.26852.linux-dvb@linuxtv.org>
	<47E813C7.6070208@googlemail.com>
	<200804120235.52939@orion.escape-edv.de>
In-Reply-To: <200804120235.52939@orion.escape-edv.de>
Content-Type: multipart/mixed; boundary="------------080309080606030903010804"
Subject: Re: [linux-dvb] [PATCH] 2/3: implement DMX_SET_BUFFER_SIZE for dvr
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
--------------080309080606030903010804
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Oliver Endriss wrote:
> - With your code the demux becomes unusable if the memory allocation
>   failes for some reason. This should be avoided. It is better have a
>   working demux with a smaller buffer than to have an defunct demux.
> 
> - If there is not enough memory for both buffers, your machine has a problem
>   anyway, and you should not increase buffer size.
> 
 > ....
> I'm sorry, spin_lock_irqsave/spin_unlock_irqrestore was a typo.
> We have to use spin_[un]lock_irq because buffer writing _might_ occur
> in interrupt context. So the '_irq' is very important!
> 

Ok.

I've changed the second patch to
1) allocate the new buffer before releasing the old one
2) use spin_[un]lock_irq

3) On top of that, I have rearranged the code of DMX_SET_BUFFER_SIZE for the demux so that it does 
the same as the dvr (i.e. allocate the new buffer before releasing the old one). I think it is a 
good idea that 2 very similar functions are implemented in the same way. (if you don't agree, or if 
you think a 3rd separate patch for this point is a better idea, let me know.)

PS: Both patches 1/3 and 2/3 are against a clean v4l-dvb tree. I do not know how to generate 
incremental patch for 2/3.

Let me know what you think about that.

Andrea

--------------080309080606030903010804
Content-Type: text/plain;
 name="patch.2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch.2"

diff -r 54cdcd915a6b linux/drivers/media/dvb/dvb-core/dmxdev.c
--- a/linux/drivers/media/dvb/dvb-core/dmxdev.c	Fri Apr 11 08:29:44 2008 -0300
+++ b/linux/drivers/media/dvb/dvb-core/dmxdev.c	Sun Apr 13 10:14:54 2008 +0100
@@ -259,6 +259,39 @@ static ssize_t dvb_dvr_read(struct file 
 	return ret;
 }
 
+static int dvb_dvr_set_buffer_size(struct dmxdev *dmxdev,
+				      unsigned long size)
+{
+	struct dvb_ringbuffer *buf = &dmxdev->dvr_buffer;
+	void *newmem;
+	void *oldmem;
+	
+	dprintk("function : %s\n", __FUNCTION__);
+	
+	if (buf->size == size)
+		return 0;
+	if (!size)
+		return -EINVAL;
+	
+	newmem = vmalloc(size);
+	if (!newmem)
+		return -ENOMEM;
+	
+	oldmem = buf->data;
+
+	spin_lock_irq(&dmxdev->lock);
+	buf->data = newmem;
+	buf->size = size;
+	
+	// reset and not flush in case the buffer shrinks
+	dvb_ringbuffer_reset(buf);
+	spin_unlock_irq(&dmxdev->lock);
+
+	vfree(oldmem);
+	
+	return 0;
+}
+
 static inline void dvb_dmxdev_filter_state_set(struct dmxdev_filter
 					       *dmxdevfilter, int state)
 {
@@ -271,28 +304,32 @@ static int dvb_dmxdev_set_buffer_size(st
 				      unsigned long size)
 {
 	struct dvb_ringbuffer *buf = &dmxdevfilter->buffer;
-	void *mem;
+	void *newmem;
+	void *oldmem;
 
 	if (buf->size == size)
 		return 0;
+	if (!size)
+		return -EINVAL;
 	if (dmxdevfilter->state >= DMXDEV_STATE_GO)
 		return -EBUSY;
+
+	newmem = vmalloc(size);
+	if (!newmem)
+		return -ENOMEM;
+
+	oldmem = buf->data;
+
 	spin_lock_irq(&dmxdevfilter->dev->lock);
-	mem = buf->data;
-	buf->data = NULL;
+	buf->data = newmem;
 	buf->size = size;
-	dvb_ringbuffer_flush(buf);
+	
+	// reset and not flush, in case the new buffer is smaller
+	dvb_ringbuffer_reset(buf);
 	spin_unlock_irq(&dmxdevfilter->dev->lock);
-	vfree(mem);
-
-	if (buf->size) {
-		mem = vmalloc(dmxdevfilter->buffer.size);
-		if (!mem)
-			return -ENOMEM;
-		spin_lock_irq(&dmxdevfilter->dev->lock);
-		buf->data = mem;
-		spin_unlock_irq(&dmxdevfilter->dev->lock);
-	}
+
+	vfree(oldmem);
+	
 	return 0;
 }
 
@@ -1009,6 +1046,7 @@ static int dvb_dvr_do_ioctl(struct inode
 {
 	struct dvb_device *dvbdev = file->private_data;
 	struct dmxdev *dmxdev = dvbdev->priv;
+	unsigned long arg = (unsigned long)parg;
 	int ret;
 
 	if (mutex_lock_interruptible(&dmxdev->mutex))
@@ -1016,8 +1054,7 @@ static int dvb_dvr_do_ioctl(struct inode
 
 	switch (cmd) {
 	case DMX_SET_BUFFER_SIZE:
-		// FIXME: implement
-		ret = 0;
+		ret = dvb_dvr_set_buffer_size(dmxdev, arg);
 		break;
 
 	default:
diff -r 54cdcd915a6b linux/drivers/media/dvb/dvb-core/dvb_ringbuffer.c
--- a/linux/drivers/media/dvb/dvb-core/dvb_ringbuffer.c	Fri Apr 11 08:29:44 2008 -0300
+++ b/linux/drivers/media/dvb/dvb-core/dvb_ringbuffer.c	Sun Apr 13 10:14:54 2008 +0100
@@ -90,6 +90,11 @@ void dvb_ringbuffer_flush(struct dvb_rin
 	rbuf->error = 0;
 }
 
+void dvb_ringbuffer_reset(struct dvb_ringbuffer *rbuf)
+{
+	rbuf->pread = rbuf->pwrite = 0;
+	rbuf->error = 0;
+}
 
 
 void dvb_ringbuffer_flush_spinlock_wakeup(struct dvb_ringbuffer *rbuf)
diff -r 54cdcd915a6b linux/drivers/media/dvb/dvb-core/dvb_ringbuffer.h
--- a/linux/drivers/media/dvb/dvb-core/dvb_ringbuffer.h	Fri Apr 11 08:29:44 2008 -0300
+++ b/linux/drivers/media/dvb/dvb-core/dvb_ringbuffer.h	Sun Apr 13 10:14:54 2008 +0100
@@ -84,6 +84,12 @@ extern ssize_t dvb_ringbuffer_free(struc
 /* return the number of bytes waiting in the buffer */
 extern ssize_t dvb_ringbuffer_avail(struct dvb_ringbuffer *rbuf);
 
+/* 
+** Reset the read and write pointers to zero and flush the buffer
+** This counts as a read and write operation
+*/
+
+extern void dvb_ringbuffer_reset(struct dvb_ringbuffer *rbuf);
 
 /* read routines & macros */
 /* ---------------------- */

--------------080309080606030903010804
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------080309080606030903010804--
