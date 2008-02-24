Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.187])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mariofutire@googlemail.com>) id 1JTPn8-0002VN-7C
	for linux-dvb@linuxtv.org; Sun, 24 Feb 2008 23:57:54 +0100
Received: by nf-out-0910.google.com with SMTP id d21so699827nfb.11
	for <linux-dvb@linuxtv.org>; Sun, 24 Feb 2008 14:57:50 -0800 (PST)
Message-ID: <47C1F667.8060602@googlemail.com>
Date: Sun, 24 Feb 2008 22:57:43 +0000
From: Andrea <mariofutire@googlemail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] [PATCH] how to make gnutv more resilient
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi,

I usually save TV to a network disk using gnutv.
Sometimes I get

"DVR device read failure"

The network is wireless, I'm using 54 Mb/s which should be more that enough for at least 1 channel.
Sometimes though, under heavy load it stops.
I think some network congestion makes gnutv read too slowly from dvr0 so that it breaks.

I would rather loose a couple of frames instead than everything after that point.

The patch does 2 things

1) removes poll. I don't knot it much, but once it fails, it keeps failing. While read can go back 
to normal after a read failure. To be honest I don't know why it is there.

2) instead of returning from the function we just skip and continue.

I've tested it adding a sleep(3) every 20 seconds and the file I get is not perfect, but can be 
played in mplayer with a bad frame every 20 seconds (as expected).

I thought in the beginning that I should read/write multiples of 188 bytes, but mplayer seems not to 
bother about that.

What do you think?

diff -r 29e190fef1e3 util/gnutv/gnutv_data.c
--- a/util/gnutv/gnutv_data.c   Tue Feb 12 18:01:37 2008 +0100
+++ b/util/gnutv/gnutv_data.c   Sun Feb 24 22:47:11 2008 +0000
@@ -213,28 +213,15 @@ static void *fileoutputthread_func(void*
  {
         (void)arg;
         uint8_t buf[4096];
-       struct pollfd pollfd;
         int written;

-       pollfd.fd = dvrfd;
-       pollfd.events = POLLIN|POLLPRI|POLLERR;
-
         while(!outputthread_shutdown) {
-               if (poll(&pollfd, 1, 1000) != 1)
-                       continue;
-               if (pollfd.revents & POLLERR) {
-                       if (errno == EINTR)
-                               continue;
-                       fprintf(stderr, "DVR device read failure\n");
-                       return 0;
-               }
-
                 int size = read(dvrfd, buf, sizeof(buf));
                 if (size < 0) {
                         if (errno == EINTR)
                                 continue;
                         fprintf(stderr, "DVR device read failure\n");
-                       return 0;
+                       continue;
                 }

                 written = 0;

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
