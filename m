Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.155])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mariofutire@googlemail.com>) id 1JcrV4-0001sp-8b
	for linux-dvb@linuxtv.org; Sat, 22 Mar 2008 01:22:18 +0100
Received: by fg-out-1718.google.com with SMTP id 22so1261952fge.25
	for <linux-dvb@linuxtv.org>; Fri, 21 Mar 2008 17:22:10 -0700 (PDT)
Message-ID: <47E4512E.5000602@googlemail.com>
Date: Sat, 22 Mar 2008 00:22:06 +0000
From: Andrea <mariofutire@googlemail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Content-Type: multipart/mixed; boundary="------------020402010108080001050305"
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
--------------020402010108080001050305
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I've been playing with DMX_SET_BUFFER_SIZE and I've had a problem when I tried to resize the buffer
to a smaller size.

dvb_dmxdev_set_buffer_size flushes the ringbuffer and then replaces it with a new one.
What happens if the current pointer is on a position that would be invalid in the new buffer? An
access violation.

This because dvb_ringbuffer_flush resets the 2 pointers to the vaule of pwrite (which could be after
the end of the new buffer).
I think it is safer to reset them to 0.

Andrea


--------------020402010108080001050305
Content-Type: text/x-patch;
 name="ring.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ring.diff"

diff -r 1886a5ea2f84 linux/drivers/media/dvb/dvb-core/dvb_ringbuffer.c
--- a/linux/drivers/media/dvb/dvb-core/dvb_ringbuffer.c	Fri Mar 21 08:04:55 2008 -0300
+++ b/linux/drivers/media/dvb/dvb-core/dvb_ringbuffer.c	Sat Mar 22 00:07:53 2008 +0000
@@ -86,7 +86,7 @@ ssize_t dvb_ringbuffer_avail(struct dvb_
 
 void dvb_ringbuffer_flush(struct dvb_ringbuffer *rbuf)
 {
-	rbuf->pread = rbuf->pwrite;
+	rbuf->pread = rbuf->pwrite = 0;
 	rbuf->error = 0;
 }
 


--------------020402010108080001050305
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------020402010108080001050305--
