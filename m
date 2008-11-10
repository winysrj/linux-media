Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAAKUKEQ029963
	for <video4linux-list@redhat.com>; Mon, 10 Nov 2008 15:30:20 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id mAAKUA1m012160
	for <video4linux-list@redhat.com>; Mon, 10 Nov 2008 15:30:10 -0500
Date: Mon, 10 Nov 2008 18:30:13 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Carl Karsten <carl@personnelware.com>
Message-ID: <20081110183013.16a00f7c@pedra.chehab.org>
In-Reply-To: <4916255E.8020303@personnelware.com>
References: <4916255E.8020303@personnelware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH]  command line: added --frames, touched up defaults
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

Hi Carl,

On Sat, 08 Nov 2008 17:48:46 -0600
Carl Karsten <carl@personnelware.com> wrote:

I found several troubles on your email:

1) It is a mime message. This generally cause lots of troubles on scripts.
Please send it as a plain old text-only messages.

2) Your SOB is after the patch. SOB is part of the description, being the last
line. All lines after the patch are discarded;

3) Your patch is inside 2 mime types: it is at text/plain part of your email,
and _also_ at a separate section:

Content-Type: text/x-patch;
 name="capture_example.c.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="capture_example.c.diff"

Due to that, your patch is applied twice, causing errors with the second version of the patch:

Reversed (or previously applied) patch detected!  Skipping patch.
5 out of 5 hunks ignored -- saving rejects to file v4l2-apps/test/capture_example.c.rej
*** ERROR at: patch -s -t -p1 -l -N -d . -i /tmp/mailimport16584/patch.diff

4) Your patch is adding whitespaces instead of tabs, or adding after the file.
To remove it, just do:

$ make whitespace
Cleaning bad whitespaces
patching file v4l2-apps/test/capture_example.c

I've corrected the problems and committed. Please avoid those on next patches.

For reference, I'm enclosing your msg as seen by the scripts.

Thanks,
Mauro.

---

Date: Sat, 08 Nov 2008 17:48:46 -0600
From: Carl Karsten <carl@personnelware.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: video4linux-list@redhat.com
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH]  command line: added --frames, touched up defaults
Content-Type: multipart/mixed;
 boundary="------------050907030809040302080205"
X-Spam-Score: 0.0 (/)

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

--------------050907030809040302080205--

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
