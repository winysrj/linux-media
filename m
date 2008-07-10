Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from main.gmane.org ([80.91.229.2] helo=ciao.gmane.org)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gldd-linux-dvb@m.gmane.org>) id 1KH4fA-0005TX-Dk
	for linux-dvb@linuxtv.org; Fri, 11 Jul 2008 00:30:57 +0200
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1KH4f3-0004aB-0N
	for linux-dvb@linuxtv.org; Thu, 10 Jul 2008 22:30:49 +0000
Received: from 77-103-126-124.cable.ubr10.dals.blueyonder.co.uk
	([77.103.126.124]) by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Thu, 10 Jul 2008 22:30:49 +0000
Received: from mariofutire by 77-103-126-124.cable.ubr10.dals.blueyonder.co.uk
	with local (Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Thu, 10 Jul 2008 22:30:49 +0000
To: linux-dvb@linuxtv.org
From: Andrea <mariofutire@googlemail.com>
Date: Thu, 10 Jul 2008 23:29:02 +0100
Message-ID: <g562if$ij9$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000207010306070006080906"
Subject: [linux-dvb] [PATCH 1/2] make gnutv more resilient to temporary slow
	reads.
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
--------------000207010306070006080906
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I have been using gnutv to save data to my network drive.
Event if the average speed required to save is way less than the bandwidth, gnutv sometimes does not
read fast enough to avoid overflow of the dvb ring buffer.

In that case gnutv prints an error message and stops recording.

In my opinion, it would be better to bite the bullet, loose a bit of the stream, and carry on, in
the hope that the system will not be too busy.

Here is the patch

diff -r 73b910014d07 util/gnutv/gnutv_data.c
--- a/util/gnutv/gnutv_data.c   Sat Jul 05 16:38:32 2008 +0200
+++ b/util/gnutv/gnutv_data.c   Thu Jul 10 23:19:48 2008 +0100
@@ -222,19 +238,26 @@
          while(!outputthread_shutdown) {
                  if (poll(&pollfd, 1, 1000) != 1)
                          continue;
+
+               // in case of read error, we should not abort in order to minimize the loss of data.
+
                  if (pollfd.revents & POLLERR) {
                          if (errno == EINTR)
                                  continue;
-                       fprintf(stderr, "DVR device read failure\n");
-                       return 0;
+                       fprintf(stderr, "DVR device poll failure\n");
+
+                       // This is tipically EOVERFLOW, i.e. dvb internal buffer run out of space
+
+                       // The next read will fail too, but it will also clear the error flag in the
driver
+                       // so that following reads will succeed
                  }

                  int size = read(dvrfd, buf, sizeof(buf));
                  if (size < 0) {
                          if (errno == EINTR)
                                  continue;
-                       fprintf(stderr, "DVR device read failure\n");
-                       return 0;
+                       fprintf(stderr, "DVR device read failure. Possible loss of data.\n");
+                       // The error flag has been cleared, next read should succeed.
                  }

                  written = 0;
@@ -243,6 +266,7 @@
                          if (tmp == -1) {
                                  if (errno != EINTR) {
                                          fprintf(stderr, "Write error: %m\n");
+                                       // abort loop
                                          break;
                                  }
                          } else {



--------------000207010306070006080906
Content-Type: text/plain;
 name="gnutv.diff3"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="gnutv.diff3"

diff -r 73b910014d07 util/gnutv/gnutv_data.c
--- a/util/gnutv/gnutv_data.c	Sat Jul 05 16:38:32 2008 +0200
+++ b/util/gnutv/gnutv_data.c	Thu Jul 10 23:19:48 2008 +0100
@@ -222,19 +238,26 @@
 	while(!outputthread_shutdown) {
 		if (poll(&pollfd, 1, 1000) != 1)
 			continue;
+
+		// in case of read error, we should not abort in order to minimize the loss of data.
+
 		if (pollfd.revents & POLLERR) {
 			if (errno == EINTR)
 				continue;
-			fprintf(stderr, "DVR device read failure\n");
-			return 0;
+			fprintf(stderr, "DVR device poll failure\n");
+
+			// This is tipically EOVERFLOW, i.e. dvb internal buffer run out of space
+
+			// The next read will fail too, but it will also clear the error flag in the driver
+			// so that following reads will succeed
 		}
 
 		int size = read(dvrfd, buf, sizeof(buf));
 		if (size < 0) {
 			if (errno == EINTR)
 				continue;
-			fprintf(stderr, "DVR device read failure\n");
-			return 0;
+			fprintf(stderr, "DVR device read failure. Possible loss of data.\n");
+			// The error flag has been cleared, next read should succeed.
 		}
 
 		written = 0;
@@ -243,6 +266,7 @@
 			if (tmp == -1) {
 				if (errno != EINTR) {
 					fprintf(stderr, "Write error: %m\n");
+					// abort loop
 					break;
 				}
 			} else {


--------------000207010306070006080906
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------000207010306070006080906--
