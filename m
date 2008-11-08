Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA8NndRJ023738
	for <video4linux-list@redhat.com>; Sat, 8 Nov 2008 18:49:39 -0500
Received: from QMTA02.westchester.pa.mail.comcast.net
	(qmta02.westchester.pa.mail.comcast.net [76.96.62.24])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA8Nmi5R018795
	for <video4linux-list@redhat.com>; Sat, 8 Nov 2008 18:48:44 -0500
Message-ID: <4916255E.8020303@personnelware.com>
Date: Sat, 08 Nov 2008 17:48:46 -0600
From: Carl Karsten <carl@personnelware.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: multipart/mixed; boundary="------------050907030809040302080205"
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH]  command line: added --frames, touched up defaults
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
--------------050907030809040302080205
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

1. Added command line option -f --frames for number of frames to grab

2. changed the default -f from 1000 to 70

3. show defaults in --help

4. added a Version, picked 1.3 as the current ver because I consider the
original to be 1.0 and at least 2 changes have been made.

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



Signed-off-by: Carl Karsten  <carl@personnelware.com>


--------------050907030809040302080205
Content-Type: text/x-patch;
 name="capture_example.c.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="capture_example.c.diff"

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

--------------050907030809040302080205
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------050907030809040302080205--
