Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA84u4Cd011368
	for <video4linux-list@redhat.com>; Fri, 7 Nov 2008 23:56:04 -0500
Received: from QMTA06.emeryville.ca.mail.comcast.net
	(qmta06.emeryville.ca.mail.comcast.net [76.96.30.56])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA84tnqa021765
	for <video4linux-list@redhat.com>; Fri, 7 Nov 2008 23:55:49 -0500
Message-ID: <49151BD0.70604@personnelware.com>
Date: Fri, 07 Nov 2008 22:55:44 -0600
From: Carl Karsten <carl@personnelware.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <4909F85E.4060900@personnelware.com>
In-Reply-To: <4909F85E.4060900@personnelware.com>
Content-Type: multipart/mixed; boundary="------------080002090800060204050100"
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [patch] test code tweaks
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

This is a multi-part message in MIME format.
--------------080002090800060204050100
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

I have mods to 3 files that are all independent.  Should they be split into
separate patches/posts, or is adding them here fine?

And, what is the procedure to deal with a patch that supersedes a patch posted
but not applied?

v4l2_tests.diff

vivi: New features have been added, so VIVI_MINOR_VERSION gets bumped.

tests/Makefile: given this is for testing, it makes sense for debug symbols to
be included.

capture_example.c: Added command line option for number of frames to grab,
changed the default to 70, show the defaults in help, added a Version (1.3
because I consider the original to be 1.0 and at least 2 changes have been made.)

Signed-off-by: Carl Karsten  <carl@personnelware.com>

Carl K

--------------080002090800060204050100
Content-Type: text/x-patch;
 name="v4l2_tests.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="v4l2_tests.diff"

diff -r 46604f47fca1 linux/drivers/media/video/vivi.c
--- a/linux/drivers/media/video/vivi.c	Fri Nov 07 15:24:18 2008 -0200
+++ b/linux/drivers/media/video/vivi.c	Fri Nov 07 22:40:30 2008 -0600
@@ -53,7 +53,7 @@
 #include "font.h"
 
 #define VIVI_MAJOR_VERSION 0
-#define VIVI_MINOR_VERSION 5
+#define VIVI_MINOR_VERSION 6
 #define VIVI_RELEASE 0
 #define VIVI_VERSION \
 	KERNEL_VERSION(VIVI_MAJOR_VERSION, VIVI_MINOR_VERSION, VIVI_RELEASE)
diff -r 46604f47fca1 v4l2-apps/test/Makefile
--- a/v4l2-apps/test/Makefile	Fri Nov 07 15:24:18 2008 -0200
+++ b/v4l2-apps/test/Makefile	Fri Nov 07 22:40:30 2008 -0600
@@ -1,6 +1,7 @@
 # Makefile for linuxtv.org v4l2-apps/test
 
 CPPFLAGS += -I../include
+CFLAGS = -g
 
 binaries = ioctl-test 		\
 	   sliced-vbi-test 	\
@@ -26,6 +27,6 @@
 driver-test: driver-test.o ../lib/libv4l2.a
 
 pixfmt-test: pixfmt-test.o
-	$(CC) $(LDFLAGS) $^ $(LOADLIBES) $(LDLIBS) -o $@ -lX11
+	$(CC) $(LDFLAGS) $^ $(LOADLIBES) $(LDLIBS) $(CFLAGS) -o $@ -lX11
 
 include ../Make.rules
diff -r 46604f47fca1 v4l2-apps/test/capture_example.c
--- a/v4l2-apps/test/capture_example.c	Fri Nov 07 15:24:18 2008 -0200
+++ b/v4l2-apps/test/capture_example.c	Fri Nov 07 22:40:30 2008 -0600
@@ -47,6 +47,7 @@
 static unsigned int     n_buffers;
 static int		out_buf;
 static int              force_format;
+static int              frame_count = 70;
 
 static void errno_exit(const char *s)
 {
@@ -171,7 +172,7 @@
 {
 	unsigned int count;
 
-	count = 1000;
+	count = frame_count;
 
 	while (count-- > 0) {
 		for (;;) {
@@ -558,19 +559,21 @@
 {
 	fprintf(fp,
 		 "Usage: %s [options]\n\n"
+		 "Version 1.3\n"
 		 "Options:\n"
-		 "-d | --device name   Video device name [/dev/video0]\n"
+		 "-d | --device name   Video device name [%s]\n"
 		 "-h | --help          Print this message\n"
-		 "-m | --mmap          Use memory mapped buffers\n"
+		 "-m | --mmap          Use memory mapped buffers [default]\n"
 		 "-r | --read          Use read() calls\n"
 		 "-u | --userp         Use application allocated buffers\n"
 		 "-o | --output        Outputs stream to stdout\n"
 		 "-f | --format        Force format to 640x480 YUYV\n"
+		 "-c | --count         Number of frames to grab [%i]\n"
 		 "",
-		 argv[0]);
+		 argv[0],dev_name,frame_count );
 }
 
-static const char short_options[] = "d:hmruof";
+static const char short_options[] = "d:hmruofc:";
 
 static const struct option
 long_options[] = {
@@ -581,6 +584,7 @@
 	{ "userp",  no_argument,       NULL, 'u' },
 	{ "output", no_argument,       NULL, 'o' },
 	{ "format", no_argument,       NULL, 'f' },
+	{ "count",  required_argument, NULL, 'c' },
 	{ 0, 0, 0, 0 }
 };
 
@@ -630,6 +634,13 @@
 			force_format++;
 			break;
 
+		case 'c':
+		        errno = 0;
+			frame_count = strtol(optarg, NULL, 0);
+			if (errno)
+				errno_exit(optarg);
+			break;
+
 		default:
 			usage(stderr, argc, argv);
 			exit(EXIT_FAILURE);

--------------080002090800060204050100
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------080002090800060204050100--
