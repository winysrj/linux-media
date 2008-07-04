Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m64EWvBN012210
	for <video4linux-list@redhat.com>; Fri, 4 Jul 2008 10:33:00 -0400
Received: from frosty.hhs.nl (frosty.hhs.nl [145.52.2.15])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m64EFZtx014002
	for <video4linux-list@redhat.com>; Fri, 4 Jul 2008 10:15:36 -0400
Received: from exim (helo=frosty) by frosty.hhs.nl with local-smtp (Exim 4.62)
	(envelope-from <j.w.r.degoede@hhs.nl>) id 1KEm4U-000432-C0
	for video4linux-list@redhat.com; Fri, 04 Jul 2008 16:15:34 +0200
Message-ID: <486E3061.3050408@hhs.nl>
Date: Fri, 04 Jul 2008 16:14:57 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Thierry Merle <thierry.merle@free.fr>
Content-Type: multipart/mixed; boundary="------------030509050000070805070903"
Cc: video4linux-list@redhat.com, v4l2 library <v4l2-library@linuxtv.org>
Subject: PATCH: libv4l-warnings.patch
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
--------------030509050000070805070903
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Fix all compiler warnings in libv4l

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

Regards,

Hans


--------------030509050000070805070903
Content-Type: text/plain;
 name="libv4l-warnings.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libv4l-warnings.patch"

Fix all compiler warnings in libv4l

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

diff -r ac2bd9892cf0 v4l2-apps/lib/libv4l/libv4l1/libv4l1-priv.h
--- a/v4l2-apps/lib/libv4l/libv4l1/libv4l1-priv.h	Fri Jul 04 14:13:03 2008 +0200
+++ b/v4l2-apps/lib/libv4l/libv4l1/libv4l1-priv.h	Fri Jul 04 15:50:05 2008 +0200
@@ -64,7 +64,7 @@
   unsigned int v4l1_pal;    /* VIDEO_PALETTE */
   unsigned int v4l2_pixfmt; /* V4L2_PIX_FMT */
   unsigned int min_width, min_height, max_width, max_height;
-  int width, height;
+  unsigned int width, height;
   unsigned char *v4l1_frame_pointer;
 };
 
diff -r ac2bd9892cf0 v4l2-apps/lib/libv4l/libv4l1/libv4l1.c
--- a/v4l2-apps/lib/libv4l/libv4l1/libv4l1.c	Fri Jul 04 14:13:03 2008 +0200
+++ b/v4l2-apps/lib/libv4l/libv4l1/libv4l1.c	Fri Jul 04 15:50:05 2008 +0200
@@ -70,9 +70,10 @@
 #define V4L1_PIX_SIZE_TOUCHED   0x08
 
 static pthread_mutex_t v4l1_open_mutex = PTHREAD_MUTEX_INITIALIZER;
-static struct v4l1_dev_info devices[V4L1_MAX_DEVICES] = { {-1}, {-1}, {-1},
-  {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1},
-  {-1} };
+static struct v4l1_dev_info devices[V4L1_MAX_DEVICES] = { { .fd = -1 },
+  { .fd = -1 }, { .fd = -1 }, { .fd = -1 }, { .fd = -1 }, { .fd = -1 },
+  { .fd = -1 }, { .fd = -1 }, { .fd = -1 }, { .fd = -1 }, { .fd = -1 },
+  { .fd = -1 }, { .fd = -1 }, { .fd = -1 }, { .fd = -1 }, { .fd = -1 }};
 static int devices_used = 0;
 
 static unsigned int palette_to_pixelformat(unsigned int palette)
@@ -135,8 +136,8 @@
   return 0;
 }
 
-static int v4l1_set_format(int index, int width, int height,
-  int v4l1_pal, int width_height_may_differ)
+static int v4l1_set_format(int index, unsigned int width,
+  unsigned int height, int v4l1_pal, int width_height_may_differ)
 {
   int result;
   unsigned int v4l2_pixfmt;
@@ -748,7 +749,7 @@
 
 
 void *v4l1_mmap(void *start, size_t length, int prot, int flags, int fd,
-  off_t offset)
+  __off_t offset)
 {
   int index;
   void *result;
diff -r ac2bd9892cf0 v4l2-apps/lib/libv4l/libv4l1/v4l1compat.c
--- a/v4l2-apps/lib/libv4l/libv4l1/v4l1compat.c	Fri Jul 04 14:13:03 2008 +0200
+++ b/v4l2-apps/lib/libv4l/libv4l1/v4l1compat.c	Fri Jul 04 15:50:05 2008 +0200
@@ -77,7 +77,7 @@
 }
 
 void mmap(void *start, size_t length, int prot, int flags, int fd,
-  off_t offset)
+  __off_t offset)
 {
   return v4l1_mmap(start, length, prot, flags, fd, offset);
 }
diff -r ac2bd9892cf0 v4l2-apps/lib/libv4l/libv4l2/libv4l2-priv.h
--- a/v4l2-apps/lib/libv4l/libv4l2/libv4l2-priv.h	Fri Jul 04 14:13:03 2008 +0200
+++ b/v4l2-apps/lib/libv4l/libv4l2/libv4l2-priv.h	Fri Jul 04 15:50:05 2008 +0200
@@ -27,7 +27,7 @@
 /* Warning when making this larger the frame_queued and frame_mapped members of
    the v4l2_dev_info struct can no longer be a bitfield, so the code needs to
    be adjusted! */
-#define V4L2_MAX_NO_FRAMES 32u
+#define V4L2_MAX_NO_FRAMES 32
 #define V4L2_DEFAULT_NREADBUFFERS 4
 #define V4L2_FRAME_BUF_SIZE (4096 * 4096)
 
diff -r ac2bd9892cf0 v4l2-apps/lib/libv4l/libv4l2/libv4l2.c
--- a/v4l2-apps/lib/libv4l/libv4l2/libv4l2.c	Fri Jul 04 14:13:03 2008 +0200
+++ b/v4l2-apps/lib/libv4l/libv4l2/libv4l2.c	Fri Jul 04 15:50:05 2008 +0200
@@ -80,9 +80,10 @@
 #define V4L2_MMAP_OFFSET_MAGIC      0xABCDEF00u
 
 static pthread_mutex_t v4l2_open_mutex = PTHREAD_MUTEX_INITIALIZER;
-static struct v4l2_dev_info devices[V4L2_MAX_DEVICES] = { {-1}, {-1},
-    {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1}, {-1},
-    {-1}, {-1}};
+static struct v4l2_dev_info devices[V4L2_MAX_DEVICES] = { { .fd = -1 },
+  { .fd = -1 }, { .fd = -1 }, { .fd = -1 }, { .fd = -1 }, { .fd = -1 },
+  { .fd = -1 }, { .fd = -1 }, { .fd = -1 }, { .fd = -1 }, { .fd = -1 },
+  { .fd = -1 }, { .fd = -1 }, { .fd = -1 }, { .fd = -1 }, { .fd = -1 }};
 static int devices_used = 0;
 
 
@@ -830,7 +831,7 @@
 ssize_t v4l2_read (int fd, void* buffer, size_t n)
 {
   ssize_t result;
-  int index, bytesused, frame_index;
+  int index, bytesused = 0, frame_index;
 
   if ((index = v4l2_get_index(fd)) == -1)
     return syscall(SYS_read, fd, buffer, n);
@@ -867,7 +868,7 @@
 }
 
 void *v4l2_mmap(void *start, size_t length, int prot, int flags, int fd,
-  off_t offset)
+  __off_t offset)
 {
   int index;
   unsigned int buffer_index;
@@ -877,7 +878,7 @@
       /* Check if the mmap data matches our answer to QUERY_BUF, if it doesn't
 	 let the kernel handle it (to allow for mmap based non capture use) */
       start || length != V4L2_FRAME_BUF_SIZE ||
-      (offset & ~0xff) != V4L2_MMAP_OFFSET_MAGIC) {
+      ((unsigned int)offset & ~0xFFu) != V4L2_MMAP_OFFSET_MAGIC) {
     if (index != -1)
       V4L2_LOG("Passing mmap(%p, %d, ..., %x, through to the driver\n",
 	start, (int)length, (int)offset);
diff -r ac2bd9892cf0 v4l2-apps/lib/libv4l/libv4l2/v4l2convert.c
--- a/v4l2-apps/lib/libv4l/libv4l2/v4l2convert.c	Fri Jul 04 14:13:03 2008 +0200
+++ b/v4l2-apps/lib/libv4l/libv4l2/v4l2convert.c	Fri Jul 04 15:50:05 2008 +0200
@@ -110,7 +110,7 @@
 }
 
 void mmap(void *start, size_t length, int prot, int flags, int fd,
-  off_t offset)
+  __off_t offset)
 {
   return v4l2_mmap(start, length, prot, flags, fd, offset);
 }
diff -r ac2bd9892cf0 v4l2-apps/lib/libv4l/libv4lconvert/libv4lconvert-priv.h
--- a/v4l2-apps/lib/libv4l/libv4lconvert/libv4lconvert-priv.h	Fri Jul 04 14:13:03 2008 +0200
+++ b/v4l2-apps/lib/libv4l/libv4lconvert/libv4lconvert-priv.h	Fri Jul 04 15:50:05 2008 +0200
@@ -57,7 +57,7 @@
 struct v4lconvert_data {
   int fd;
   int supported_src_formats; /* bitfield */
-  int no_formats;
+  unsigned int no_formats;
   char error_msg[V4LCONVERT_ERROR_MSG_SIZE];
   struct jdec_private *jdec;
 };
diff -r ac2bd9892cf0 v4l2-apps/lib/libv4l/libv4lconvert/libv4lconvert.c
--- a/v4l2-apps/lib/libv4l/libv4lconvert/libv4lconvert.c	Fri Jul 04 14:13:03 2008 +0200
+++ b/v4l2-apps/lib/libv4l/libv4lconvert/libv4lconvert.c	Fri Jul 04 15:50:05 2008 +0200
@@ -25,6 +25,7 @@
 #include "libv4lconvert-priv.h"
 
 #define MIN(a,b) (((a)<(b))?(a):(b))
+#define ARRAY_SIZE(x) ((int)sizeof(x)/(int)sizeof((x)[0]))
 
 static const unsigned int supported_src_pixfmts[] = {
   V4L2_PIX_FMT_BGR24,
@@ -39,13 +40,11 @@
   V4L2_PIX_FMT_SPCA561,
   V4L2_PIX_FMT_SN9C10X,
   V4L2_PIX_FMT_PAC207,
-  -1
 };
 
 static const unsigned int supported_dst_pixfmts[] = {
   V4L2_PIX_FMT_BGR24,
   V4L2_PIX_FMT_YUV420,
-  -1
 };
 
 
@@ -69,7 +68,7 @@
     if (syscall(SYS_ioctl, fd, VIDIOC_ENUM_FMT, &fmt))
       break;
 
-    for (j = 0; supported_src_pixfmts[j] != -1; j++)
+    for (j = 0; j < ARRAY_SIZE(supported_src_pixfmts); j++)
       if (fmt.pixelformat == supported_src_pixfmts[j]) {
 	data->supported_src_formats |= 1 << j;
 	break;
@@ -100,7 +99,7 @@
     return syscall(SYS_ioctl, data->fd, VIDIOC_ENUM_FMT, fmt);
 
   fmt->flags = 0;
-  fmt->pixelformat = -1;
+  fmt->pixelformat = 0;
   memset(fmt->reserved, 0, 4);
 
   /* Note bgr24 and yuv420 are the first 2 in our mask of supported formats */
@@ -121,7 +120,7 @@
       }
       break;
   }
-  if (fmt->pixelformat == -1) {
+  if (fmt->pixelformat == 0) {
     errno = EINVAL;
     return -1;
   }
@@ -134,16 +133,16 @@
   struct v4l2_format *dest_fmt, struct v4l2_format *src_fmt)
 {
   int i;
-  unsigned int try_pixfmt, closest_fmt_size_diff = -1;
+  unsigned int closest_fmt_size_diff = -1;
   unsigned int desired_pixfmt = dest_fmt->fmt.pix.pixelformat;
-  struct v4l2_format try_fmt, closest_fmt = { .type = -1 };
+  struct v4l2_format try_fmt, closest_fmt = { .type = 0 };
 
-  for (i = 0; supported_dst_pixfmts[i] != -1; i++)
+  for (i = 0; i < ARRAY_SIZE(supported_dst_pixfmts); i++)
     if (supported_dst_pixfmts[i] == desired_pixfmt)
       break;
 
   /* Can we do conversion to the requested format & type? */
-  if (supported_dst_pixfmts[i] == -1 ||
+  if (i == ARRAY_SIZE(supported_dst_pixfmts) ||
       dest_fmt->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
     int ret = syscall(SYS_ioctl, data->fd, VIDIOC_TRY_FMT, dest_fmt);
     if (src_fmt)
@@ -151,17 +150,17 @@
     return ret;
   }
 
-  for (i = 0; (try_pixfmt = supported_src_pixfmts[i]) != -1; i++) {
+  for (i = 0; i < ARRAY_SIZE(supported_src_pixfmts); i++) {
     /* is this format supported? */
     if (!(data->supported_src_formats & (1 << i)))
       continue;
 
     try_fmt = *dest_fmt;
-    try_fmt.fmt.pix.pixelformat = try_pixfmt;
+    try_fmt.fmt.pix.pixelformat = supported_src_pixfmts[i];
 
     if (!syscall(SYS_ioctl, data->fd, VIDIOC_TRY_FMT, &try_fmt))
     {
-      if (try_fmt.fmt.pix.pixelformat == try_pixfmt) {
+      if (try_fmt.fmt.pix.pixelformat == supported_src_pixfmts[i]) {
 	int size_x_diff = abs((int)try_fmt.fmt.pix.width -
 			      (int)dest_fmt->fmt.pix.width);
 	int size_y_diff = abs((int)try_fmt.fmt.pix.height -
@@ -176,7 +175,7 @@
     }
   }
 
-  if (closest_fmt.type == -1) {
+  if (closest_fmt.type == 0) {
     errno = EINVAL;
     return -1;
   }
@@ -322,7 +321,7 @@
     case V4L2_PIX_FMT_PAC207:
     {
       unsigned char tmpbuf[dest_fmt->fmt.pix.width*dest_fmt->fmt.pix.height];
-      unsigned int bayer_fmt;
+      unsigned int bayer_fmt = 0;
 
       switch (src_fmt->fmt.pix.pixelformat) {
 	case V4L2_PIX_FMT_SPCA561:
diff -r ac2bd9892cf0 v4l2-apps/lib/libv4l/libv4lconvert/sn9c10x.c
--- a/v4l2-apps/lib/libv4l/libv4lconvert/sn9c10x.c	Fri Jul 04 14:13:03 2008 +0200
+++ b/v4l2-apps/lib/libv4l/libv4lconvert/sn9c10x.c	Fri Jul 04 15:50:05 2008 +0200
@@ -139,7 +139,7 @@
 	int val;
 	int bitpos;
 	unsigned char code;
-	unsigned char *addr;
+	const unsigned char *addr;
 
 	if (!init_done)
 		sonix_decompress_init();
diff -r ac2bd9892cf0 v4l2-apps/lib/libv4l/libv4lconvert/spca561-decompress.c
--- a/v4l2-apps/lib/libv4l/libv4lconvert/spca561-decompress.c	Fri Jul 04 14:13:03 2008 +0200
+++ b/v4l2-apps/lib/libv4l/libv4lconvert/spca561-decompress.c	Fri Jul 04 15:50:05 2008 +0200
@@ -307,7 +307,7 @@
 	static int accum[8 * 8 * 8];
 	static int i_hits[8 * 8 * 8];
 
-	const static int nbits_A[] =
+	const int nbits_A[] =
 	    { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
 		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
 		    1, 1,
@@ -335,7 +335,7 @@
 		3, 3, 3, 3, 3,
 		3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
 	};
-	const static int tab_A[] =
+	const int tab_A[] =
 	    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 		    0, 0,
@@ -370,7 +370,7 @@
 		1
 	};
 
-	const static int nbits_B[] =
+	const int nbits_B[] =
 	    { 0, 8, 7, 7, 6, 6, 6, 6, 5, 5, 5, 5, 5, 5, 5, 5, 4, 4, 4, 4,
 		4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 3, 3, 3, 3, 3, 3, 3, 3,
 		    3, 3,
@@ -398,7 +398,7 @@
 		1, 1, 1, 1, 1,
 		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
 	};
-	const static int tab_B[] =
+	const int tab_B[] =
 	    { 0xff, -4, 3, 3, -3, -3, -3, -3, 2, 2, 2, 2, 2, 2, 2, 2, -2,
 		-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
 		    1, 1,
@@ -433,7 +433,7 @@
 		0, 0, 0, 0, 0, 0, 0,
 	};
 
-	const static int nbits_C[] =
+	const int nbits_C[] =
 	    { 0, 0, 8, 8, 7, 7, 7, 7, 6, 6, 6, 6, 6, 6, 6, 6, 5, 5, 5, 5,
 		5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 4, 4, 4, 4, 4, 4, 4, 4,
 		    4, 4,
@@ -461,7 +461,7 @@
 		2, 2, 2, 2, 2,
 		2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
 	};
-	const static int tab_C[] =
+	const int tab_C[] =
 	    { 0xff, 0xfe, 6, -7, 5, 5, -6, -6, 4, 4, 4, 4, -5, -5, -5, -5,
 		3, 3, 3, 3, 3, 3, 3, 3, -4, -4, -4, -4, -4, -4, -4, -4, 2,
 		    2, 2, 2,
@@ -497,7 +497,7 @@
 		    -1,
 	};
 
-	const static int nbits_D[] =
+	const int nbits_D[] =
 	    { 0, 0, 0, 0, 8, 8, 8, 8, 7, 7, 7, 7, 7, 7, 7, 7, 6, 6, 6, 6,
 		6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 5, 5, 5, 5, 5, 5, 5, 5,
 		    5, 5,
@@ -525,7 +525,7 @@
 		3, 3, 3, 3, 3,
 		3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
 	};
-	const static int tab_D[] =
+	const int tab_D[] =
 	    { 0xff, 0xfe, 0xfd, 0xfc, 10, -11, 11, -12, 8, 8, -9, -9, 9, 9,
 		-10, -10, 6, 6, 6, 6, -7, -7, -7, -7, 7, 7, 7, 7, -8, -8,
 		    -8, -8,
@@ -563,7 +563,7 @@
 	};
 
 	/* a_curve[19 + i] = ... [-19..19] => [-160..160] */
-	const static int a_curve[] =
+	const int a_curve[] =
 	    { -160, -144, -128, -112, -98, -88, -80, -72, -64, -56, -48,
 		-40, -32, -24, -18, -12, -8, -5, -2, 0, 2, 5, 8, 12, 18,
 		    24, 32,
@@ -571,7 +571,7 @@
 		72, 80, 88, 98, 112, 128, 144, 160
 	};
 	/* clamp0_255[256 + i] = min(max(i,255),0) */
-	const static unsigned char clamp0_255[] =
+	const unsigned char clamp0_255[] =
 	    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 		    0, 0,
@@ -680,14 +680,14 @@
 		255
 	};
 	/* abs_clamp15[19 + i] = min(abs(i), 15) */
-	const static int abs_clamp15[] =
+	const int abs_clamp15[] =
 	    { 15, 15, 15, 15, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3,
 		2, 1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
 		    15, 15,
 		15
 	};
 	/* diff_encoding[256 + i] = ... */
-	const static int diff_encoding[] =
+	const int diff_encoding[] =
 	    { 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,
 		7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,
 		    7, 7,

--------------030509050000070805070903
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------030509050000070805070903--
