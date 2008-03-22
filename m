Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.158])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mariofutire@googlemail.com>) id 1Jd1y3-0002Cu-9m
	for linux-dvb@linuxtv.org; Sat, 22 Mar 2008 12:32:58 +0100
Received: by fg-out-1718.google.com with SMTP id 22so1444038fge.25
	for <linux-dvb@linuxtv.org>; Sat, 22 Mar 2008 04:32:48 -0700 (PDT)
Message-ID: <47E4EE5B.1010406@googlemail.com>
Date: Sat, 22 Mar 2008 11:32:43 +0000
From: Andrea <mariofutire@googlemail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <mailman.1.1206183601.26852.linux-dvb@linuxtv.org>
In-Reply-To: <mailman.1.1206183601.26852.linux-dvb@linuxtv.org>
Content-Type: multipart/mixed; boundary="------------070104040908080405050702"
Subject: [linux-dvb] [PATCH] 1/3: BUG FIX in dvb_ringbuffer_flush
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
--------------070104040908080405050702
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

linux-dvb-request@linuxtv.org wrote:
> Date: Sat, 22 Mar 2008 04:56:43 +0100
> From: Oliver Endriss <o.endriss@gmx.de>
> 
  > Nak. At the first glance one might think that this patch is correct.
  > Unfortunately, it introduces a subtle bug.

> So I suggest to leave dvb_ringbuffer_flush() as is and zero the read and
> write pointers only where it is really required...

Thanks for your feedback.
You are right and I have changed the code.

I've added a new function in the ringbuffer that resets the pointers to 0 and clears the error flag.
There might be some more factoring and one could move into that function 2 more lines

	buf->data = NULL;
	buf->size = size;
	dvb_ringbuffer_reset(buf);


Andrea


--------------070104040908080405050702
Content-Type: text/x-patch;
 name="ring2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ring2.diff"

diff -r 1886a5ea2f84 linux/drivers/media/dvb/dvb-core/dmxdev.c
--- a/linux/drivers/media/dvb/dvb-core/dmxdev.c	Fri Mar 21 08:04:55 2008 -0300
+++ b/linux/drivers/media/dvb/dvb-core/dmxdev.c	Sat Mar 22 10:12:59 2008 +0000
@@ -281,7 +313,7 @@ static int dvb_dmxdev_set_buffer_size(st
 	mem = buf->data;
 	buf->data = NULL;
 	buf->size = size;
-	dvb_ringbuffer_flush(buf);
+	dvb_ringbuffer_reset(buf);
 	spin_unlock_irq(&dmxdevfilter->dev->lock);
 	vfree(mem);
 
diff -r 1886a5ea2f84 linux/drivers/media/dvb/dvb-core/dvb_ringbuffer.c
--- a/linux/drivers/media/dvb/dvb-core/dvb_ringbuffer.c	Fri Mar 21 08:04:55 2008 -0300
+++ b/linux/drivers/media/dvb/dvb-core/dvb_ringbuffer.c	Sat Mar 22 10:12:59 2008 +0000
@@ -90,6 +90,11 @@ void dvb_ringbuffer_flush(struct dvb_rin
 	rbuf->error = 0;
 }
 
+void dvb_ringbuffer_reset(struct dvb_ringbuffer *rbuf)
+{
+	rbuf->pread = rbuf->pwrite = 0;
+	rbuf->error = 0;
+}
 
 
 void dvb_ringbuffer_flush_spinlock_wakeup(struct dvb_ringbuffer *rbuf)
diff -r 1886a5ea2f84 linux/drivers/media/dvb/dvb-core/dvb_ringbuffer.h
--- a/linux/drivers/media/dvb/dvb-core/dvb_ringbuffer.h	Fri Mar 21 08:04:55 2008 -0300
+++ b/linux/drivers/media/dvb/dvb-core/dvb_ringbuffer.h	Sat Mar 22 10:12:59 2008 +0000
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


--------------070104040908080405050702
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------070104040908080405050702--
