Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.153])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mariofutire@googlemail.com>) id 1JkyXZ-0001j2-Rh
	for linux-dvb@linuxtv.org; Sun, 13 Apr 2008 11:30:26 +0200
Received: by fg-out-1718.google.com with SMTP id 22so1385228fge.25
	for <linux-dvb@linuxtv.org>; Sun, 13 Apr 2008 02:30:21 -0700 (PDT)
Message-ID: <4801D2A8.4020903@googlemail.com>
Date: Sun, 13 Apr 2008 10:30:16 +0100
From: Andrea <mariofutire@googlemail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org, o.endriss@gmx.de
References: <mailman.1.1206183601.26852.linux-dvb@linuxtv.org>
	<47E4EE5B.1010406@googlemail.com>
In-Reply-To: <47E4EE5B.1010406@googlemail.com>
Content-Type: multipart/mixed; boundary="------------020507000605030600080206"
Subject: Re: [linux-dvb] [PATCH] 1/3: BUG FIX in dvb_ringbuffer_flush
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
--------------020507000605030600080206
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Andrea wrote:
> linux-dvb-request@linuxtv.org wrote:
> I've added a new function in the ringbuffer that resets the pointers to 
> 0 and clears the error flag.
> There might be some more factoring and one could move into that function 
> 2 more lines
> 
>     buf->data = NULL;
>     buf->size = size;
>     dvb_ringbuffer_reset(buf);

I've just added a comment to patch 1/3.
I post it here again.

This patch fixes the bug in DMX_SET_BUFFER_SIZE for the demux.
Basically it resets read and write pointers to 0 in case they are beyond the new size of the buffer.

In the next patch (2/3) I rewrite this function to behave the same as the new DMX_SET_BUFFER_SIZE 
for the dvr.
I thought it is a good idea for the 2 very similar ioctl to be implemented in the same way.

Andrea

--------------020507000605030600080206
Content-Type: text/plain;
 name="patch.1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch.1"

diff -r 54cdcd915a6b linux/drivers/media/dvb/dvb-core/dmxdev.c
--- a/linux/drivers/media/dvb/dvb-core/dmxdev.c	Fri Apr 11 08:29:44 2008 -0300
+++ b/linux/drivers/media/dvb/dvb-core/dmxdev.c	Sun Apr 13 09:50:59 2008 +0100
@@ -281,7 +281,9 @@ static int dvb_dmxdev_set_buffer_size(st
 	mem = buf->data;
 	buf->data = NULL;
 	buf->size = size;
-	dvb_ringbuffer_flush(buf);
+	
+	// reset and not flush in case the buffer shrinks
+	dvb_ringbuffer_reset(buf);
 	spin_unlock_irq(&dmxdevfilter->dev->lock);
 	vfree(mem);
 
diff -r 54cdcd915a6b linux/drivers/media/dvb/dvb-core/dvb_ringbuffer.c
--- a/linux/drivers/media/dvb/dvb-core/dvb_ringbuffer.c	Fri Apr 11 08:29:44 2008 -0300
+++ b/linux/drivers/media/dvb/dvb-core/dvb_ringbuffer.c	Sun Apr 13 09:50:59 2008 +0100
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
+++ b/linux/drivers/media/dvb/dvb-core/dvb_ringbuffer.h	Sun Apr 13 09:50:59 2008 +0100
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

--------------020507000605030600080206
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------020507000605030600080206--
