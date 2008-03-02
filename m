Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m226gnj5027383
	for <video4linux-list@redhat.com>; Sun, 2 Mar 2008 01:42:49 -0500
Received: from QMTA07.emeryville.ca.mail.comcast.net
	(qmta07.emeryville.ca.mail.comcast.net [76.96.30.64])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m226gGcF025674
	for <video4linux-list@redhat.com>; Sun, 2 Mar 2008 01:42:16 -0500
Message-ID: <47CA4C4C.7010901@personnelware.com>
Date: Sun, 02 Mar 2008 00:42:20 -0600
From: Carl Karsten <carl@personnelware.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [patch] ioctl-test.c
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

I copied the command line parameter support from test/pixfmt-test.c, and used 
the prt_caps() func from lib/v4l2_driver.c.

I am hoping to merge all of the test code into one big test, and put all the 
generic code into one lib.

Carl K


diff -r 127f67dea087 v4l2-apps/lib/v4l2_driver.h
--- a/v4l2-apps/lib/v4l2_driver.h	Tue Feb 26 20:43:56 2008 +0000
+++ b/v4l2-apps/lib/v4l2_driver.h	Sun Mar 02 00:37:59 2008 -0600
@@ -12,6 +12,7 @@
     Lesser General Public License for more details.
    */

+#include <stddef.h>
  #include <stdint.h>
  #include <sys/time.h>
  #include <linux/videodev2.h>
diff -r 127f67dea087 v4l2-apps/test/ioctl-test.c
--- a/v4l2-apps/test/ioctl-test.c	Tue Feb 26 20:43:56 2008 +0000
+++ b/v4l2-apps/test/ioctl-test.c	Sun Mar 02 00:37:59 2008 -0600
@@ -29,14 +29,24 @@
   */
  //#define INTERNAL 1 /* meant for testing ioctl debug msgs */

+#include <errno.h>
+#include <stdlib.h>
  #include <stdio.h>
  #include <unistd.h>
+#include <stdarg.h>
  #include <string.h>
  #include <sys/types.h>
  #include <sys/stat.h>
  #include <sys/ioctl.h>
+#include <assert.h>
+
+#include <getopt.h>             /* getopt_long() */
+
  #include <fcntl.h>
-#include "linux/videodev.h"
+// #include "linux/videodev.h"
+#include <linux/videodev2.h>
+
+#include <lib/v4l2_driver.h>

  #ifdef INTERNAL
  typedef __u8 u8;
@@ -47,6 +57,25 @@ typedef __u32 u32;
  #else
  typedef u_int32_t u32;
  #endif
+
+static const char *             my_name;
+#define VERSION "1.1"
+static const char *             dev_name = "/dev/video0";
+
+#define CLEAR(var) memset (&(var), 0, sizeof (var))
+
+typedef enum {
+        IO_METHOD_READ = 1,
+        IO_METHOD_MMAP,
+} io_methods;
+
+
+static int                      fd;
+static v4l2_std_id              std_id;
+static io_methods               io_method;
+static struct v4l2_format       fmt;
+//static io_buffer *              buffers;
+static unsigned int             n_buffers;

  /* All possible parameters used on v4l ioctls */
  union v4l_parms {
@@ -209,26 +238,253 @@ int ioctls[] = {
  #define S_IOCTLS sizeof(ioctls)/sizeof(ioctls[0])

  /********************************************************************/
+static int
+xioctl                          (int                    fd,
+                                 int                    request,
+                                 void *                 arg)
+{
+        int r;

-int main (void)
+        do r = ioctl (fd, request, arg);
+        while (-1 == r && EINTR == errno);
+
+        return r;
+}
+
+/********************************************************************/
+static void
+error_exit                      (const char *           templ,
+                                 ...)
  {
-	int fd=0, ret=0;
+        va_list ap;
+
+        fprintf (stderr, "%s: ", my_name);
+        va_start (ap, templ);
+        vfprintf (stderr, templ, ap);
+        va_end (ap);
+
+        exit (EXIT_FAILURE);
+}
+
+/********************************************************************/
+static void
+errno_exit                      (const char *           s)
+{
+        error_exit ("%s error %d, %s\n",
+                    s, errno, strerror (errno));
+}
+
+
+/********************************************************************/
+static void
+open_device         (void)
+{
+    struct stat st;
+
+    if (-1 == stat (dev_name, &st)) {
+        error_exit ("Cannot identify '%s'. %s.\n",
+                dev_name, strerror (errno));
+    }
+
+    if (!S_ISCHR (st.st_mode)) {
+        error_exit ("%s is not a device file.\n", dev_name);
+    }
+
+    fd = open (dev_name, O_RDWR /* required */ | O_NONBLOCK, 0);
+
+    if (-1 == fd) {
+        error_exit ("Cannot open %s. %s.\n",
+                dev_name, strerror (errno));
+    }
+}
+
+/********************************************************************/
+static void
+printstat            (struct v4l2_capability cap)
+{
+    printf ("driver=%s\n" "card=%s\n" "bus=%s\n" "version=%d.%d.%d\n"
+            "capabilities=%s\n",
+            cap.driver,cap.card,cap.bus_info,
+            (cap.version >> 16) & 0xff,
+            (cap.version >>  8) & 0xff,
+            cap.version         & 0xff,
+            prt_caps(cap.capabilities));
+}
+
+/********************************************************************/
+
+static void
+init_device         (void)
+{
+    struct v4l2_capability cap;
+    struct v4l2_cropcap cropcap;
+    struct v4l2_crop crop;
+
+    if (-1 == xioctl (fd, VIDIOC_QUERYCAP, &cap)) {
+        if (EINVAL == errno) {
+            error_exit ("%s is not a V4L2 device.\n");
+        } else {
+            errno_exit ("VIDIOC_QUERYCAP");
+        }
+    }
+
+    printstat(cap);
+
+    switch (io_method) {
+    case 0:
+        if (cap.capabilities & V4L2_CAP_STREAMING) {
+            io_method = IO_METHOD_MMAP;
+        } else if (cap.capabilities & V4L2_CAP_READWRITE) {
+            io_method = IO_METHOD_READ;
+        } else {
+            error_exit ("%s does not support reading or "
+                    "streaming.\n");
+        }
+
+        break;
+
+    case IO_METHOD_READ:
+        if (0 == (cap.capabilities & V4L2_CAP_READWRITE)) {
+            error_exit ("%s does not support read i/o.\n");
+        }
+
+        break;
+
+    case IO_METHOD_MMAP:
+        if (0 == (cap.capabilities & V4L2_CAP_STREAMING)) {
+            error_exit ("%s does not support streaming i/o.\n");
+        }
+
+        break;
+
+    default:
+        assert (0);
+        break;
+    }
+
+    CLEAR (cropcap);
+
+    cropcap.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+
+    if (0 == xioctl (fd, VIDIOC_CROPCAP, &cropcap)) {
+        crop.type = cropcap.type;
+        crop.c = cropcap.defrect; /* reset to default */
+
+        /* Errors ignored. */
+        xioctl (fd, VIDIOC_S_CROP, &crop);
+    } else {
+        /* Errors ignored. */
+    }
+
+    if (-1 == xioctl (fd, VIDIOC_G_STD, &std_id))
+        errno_exit ("VIDIOC_G_STD");
+}
+
+
+/********************************************************************/
+static void
+mainloop            (void)
+{
+
+    int ret=0;
  	unsigned i;
-	char *device="/dev/video0";
  	union v4l_parms p;

-	if ((fd = open(device, O_RDONLY)) < 0) {
-		perror("Couldn't open video0");
-		return(-1);
-	}

  	for (i=0;i<S_IOCTLS;i++) {
  		memset(&p,0,sizeof(p));
  		ret=ioctl(fd,ioctls[i], (void *) &p);
  		printf("%i: ioctl=0x%08x, return=%d\n",i, ioctls[i], ret);
  	}
+}
+
+/********************************************************************/
+
+static void
+usage                           (FILE *                 fp,
+                                 int                    argc,
+                                 char **                argv)
+{
+        fprintf (fp, "\
+V4L2 test " VERSION "\n\
+Copyright (C) 2007 Michael H. Schimek\n\
+This program is licensed under GPL 2 or later. NO WARRANTIES.\n\n\
+Usage: %s [options]\n\n\
+Options:\n\
+-d | --device name  Video device name [%s]\n\
+-h | --help         Print this message\n\
+-m | --mmap         Use memory mapped buffers (auto)\n\
+-r | --read         Use read() calls (auto)\n\
+",
+                 my_name, dev_name);
+}
+
+static const char short_options [] = "d:hmr";
+
+static const struct option
+long_options [] = {
+        { "device",     required_argument,      NULL,           'd' },
+        { "help",       no_argument,            NULL,           'h' },
+        { "mmap",       no_argument,            NULL,           'm' },
+        { "read",       no_argument,            NULL,           'r' },
+        { "usage",      no_argument,            NULL,           'h' },
+        { 0, 0, 0, 0 }
+};
+
+
+
+int
+main                            (int                    argc,
+                                 char **                argv)
+{
+        my_name = argv[0];
+
+        for (;;) {
+                int index;
+                int c;
+
+                c = getopt_long (argc, argv,
+                                 short_options, long_options,
+                                 &index);
+
+                if (-1 == c)
+                        break;
+
+                switch (c) {
+                case 0: /* getopt_long() flag */
+                        break;
+
+                case 'd':
+                        dev_name = optarg;
+                        break;
+
+                case 'h':
+                        usage (stdout, argc, argv);
+                        exit (EXIT_SUCCESS);
+
+                case 'm':
+                        io_method = IO_METHOD_MMAP;
+                        break;
+
+                case 'r':
+                        io_method = IO_METHOD_READ;
+                        break;
+
+                default:
+                        usage (stderr, argc, argv);
+                        exit (EXIT_FAILURE);
+                }
+        }
+
+    open_device ();
+
+    init_device ();
+
+    mainloop ();

  	close (fd);

+    exit (EXIT_SUCCESS);
+
  	return (0);
  }

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
