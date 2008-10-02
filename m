Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m92HQV6b025131
	for <video4linux-list@redhat.com>; Thu, 2 Oct 2008 13:26:31 -0400
Received: from eldar.vidconference.de (dns.vs-node5.de [87.106.133.120])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m92HQQ5q004090
	for <video4linux-list@redhat.com>; Thu, 2 Oct 2008 13:26:27 -0400
Date: Thu, 2 Oct 2008 19:26:23 +0200
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Message-ID: <20081002172623.GC28699@vidsoft.de>
References: <48CE4B24.30902@hhs.nl>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MGYHOYXEY6WxJCY8"
Content-Disposition: inline
In-Reply-To: <48CE4B24.30902@hhs.nl>
From: Gregor Jasny <jasny@vidsoft.de>
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Re: libv4l release: 0.5.0
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

attached you'll find a patch to not link the wrapper libs against
libphread.

Thanks,
Gregor

--MGYHOYXEY6WxJCY8
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="dont-link-wrappers-against-libpthread.diff"

diff -r 10a002640754 v4l2-apps/lib/libv4l/libv4l1/Makefile
--- a/v4l2-apps/lib/libv4l/libv4l1/Makefile	Mon Sep 15 13:48:21 2008 +0200
+++ b/v4l2-apps/lib/libv4l/libv4l1/Makefile	Thu Oct 02 18:45:27 2008 +0200
@@ -3,7 +3,7 @@ CFLAGS := -g -O1
 CFLAGS := -g -O1
 CFLAGS += -Wall -Wno-unused -Wpointer-arith -Wstrict-prototypes -Wmissing-prototypes
 
-LIBS = -lpthread
+LIBS_libv4l1  = -lpthread
 
 V4L1_OBJS     = libv4l1.o log.o
 V4L1COMPAT    = v4l1compat.so
@@ -75,7 +75,7 @@ clean::
 	$(CC) -c -MMD $(CPPFLAGS) $(CFLAGS) -o $@ $<
 
 %.so:
-	$(CC) -shared $(LDFLAGS) -Wl,-soname,$@.$(LIB_RELEASE) -o $@.$(LIB_RELEASE) $^ $(LIBS)
+	$(CC) -shared $(LDFLAGS) -Wl,-soname,$@.$(LIB_RELEASE) -o $@.$(LIB_RELEASE) $^ $(LIBS_$*)
 	ln -f -s $@.$(LIB_RELEASE) $@
 
 %.a:
diff -r 10a002640754 v4l2-apps/lib/libv4l/libv4l2/Makefile
--- a/v4l2-apps/lib/libv4l/libv4l2/Makefile	Mon Sep 15 13:48:21 2008 +0200
+++ b/v4l2-apps/lib/libv4l/libv4l2/Makefile	Thu Oct 02 18:44:24 2008 +0200
@@ -3,7 +3,7 @@ CFLAGS := -g -O1
 CFLAGS := -g -O1
 CFLAGS += -Wall -Wno-unused -Wpointer-arith -Wstrict-prototypes -Wmissing-prototypes
 
-LIBS = -lpthread
+LIBS_libv4l2  = -lpthread
 
 V4L2_OBJS     = libv4l2.o log.o
 V4L2CONVERT   = v4l2convert.so
@@ -74,7 +74,7 @@ clean::
 	$(CC) -c -MMD $(CPPFLAGS) $(CFLAGS) -o $@ $<
 
 %.so:
-	$(CC) -shared $(LDFLAGS) -Wl,-soname,$@.$(LIB_RELEASE) -o $@.$(LIB_RELEASE) $^ $(LIBS)
+	$(CC) -shared $(LDFLAGS) -Wl,-soname,$@.$(LIB_RELEASE) -o $@.$(LIB_RELEASE) $^ $(LIBS_$*)
 	ln -f -s $@.$(LIB_RELEASE) $@
 
 %.a:

--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--MGYHOYXEY6WxJCY8--
