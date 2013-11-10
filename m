Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40226 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772Ab3KJRRV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Nov 2013 12:17:21 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC] libv4l2: use mmap and stream conversion by libv4l2
Date: Sun, 10 Nov 2013 19:17:08 +0200
Message-Id: <1384103828-4880-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

1) Use v4l2_mmap.
2) Use libv4lconvert for sample conversion.

That implementation is heavily copied from v4l2grab application:
v4l2grab.c (C) 2009 Mauro Carvalho Chehab

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 lib/libv4l2_x_impl.cc | 120 +++++++++++++++++++++++++++++++++++++++++++++-----
 lib/libv4l2_x_impl.h  |   7 +++
 2 files changed, 116 insertions(+), 11 deletions(-)

diff --git a/lib/libv4l2_x_impl.cc b/lib/libv4l2_x_impl.cc
index 3362044..c726ffc 100644
--- a/lib/libv4l2_x_impl.cc
+++ b/lib/libv4l2_x_impl.cc
@@ -24,6 +24,8 @@
 
 #include <gr_io_signature.h>
 #include "libv4l2_x_impl.h"
+#include <sys/mman.h>
+#include <linux/videodev2.h>
 
 /* Control classes */
 #define V4L2_CTRL_CLASS_USER    0x00980000 /* Old-style 'user' controls */
@@ -39,6 +41,21 @@
 #define CID_TUNER_IF              ((V4L2_CID_USER_BASE | 0xf000) + 12)
 #define CID_TUNER_GAIN            ((V4L2_CID_USER_BASE | 0xf000) + 13)
 
+#define CLEAR(x) memset(&(x), 0, sizeof(x))
+
+static void xioctl(int fh, unsigned long int request, void *arg)
+{
+        int ret;
+
+        do {
+                ret = v4l2_ioctl(fh, request, arg);
+        } while (ret == -1 && ((errno == EINTR) || (errno == EAGAIN)));
+        if (ret == -1) {
+                fprintf(stderr, "error %d, %s\n", errno, strerror(errno));
+                exit(EXIT_FAILURE);
+        }
+}
+
 namespace gr {
   namespace kernel {
 
@@ -56,11 +73,64 @@ namespace gr {
               gr_make_io_signature(0, 0, 0),
               gr_make_io_signature(1, 1, sizeof (gr_complex)))
     {
+        struct v4l2_format fmt;
+        struct v4l2_buffer buf;
+        struct v4l2_requestbuffers req;
+        enum v4l2_buf_type type;
+        unsigned int i;
+
         fd = v4l2_open(filename, O_RDWR | O_NONBLOCK, 0);
         if (fd < 0) {
-            perror(filename);
-            throw std::runtime_error("can't open file");
+                perror("Cannot open device");
+                exit(EXIT_FAILURE);
+        }
+
+        CLEAR(fmt);
+        fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+        fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_FLOAT;
+        xioctl(fd, VIDIOC_S_FMT, &fmt);
+        if (fmt.fmt.pix.pixelformat != V4L2_PIX_FMT_FLOAT) {
+                printf("Libv4l didn't accept FLOAT format. Cannot proceed. Pixelformat %4.4s\n",
+                        (char *)&fmt.fmt.pix.pixelformat);
+                exit(EXIT_FAILURE);
+        }
+
+        CLEAR(req);
+        req.count = 8;
+        req.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+        req.memory = V4L2_MEMORY_MMAP;
+        xioctl(fd, VIDIOC_REQBUFS, &req);
+
+        buffers = (struct buffer*) calloc(req.count, sizeof(*buffers));
+        for (n_buffers = 0; n_buffers < req.count; n_buffers++) {
+                CLEAR(buf);
+                buf.type        = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+                buf.memory      = V4L2_MEMORY_MMAP;
+                buf.index       = n_buffers;
+                xioctl(fd, VIDIOC_QUERYBUF, &buf);
+
+                buffers[n_buffers].length = buf.length;
+                buffers[n_buffers].start = v4l2_mmap(NULL, buf.length,
+                              PROT_READ | PROT_WRITE, MAP_SHARED,
+                              fd, buf.m.offset);
+
+                if (buffers[n_buffers].start == MAP_FAILED) {
+                        perror("mmap");
+                        exit(EXIT_FAILURE);
+                }
         }
+
+        for (i = 0; i < n_buffers; i++) {
+                CLEAR(buf);
+                buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+                buf.memory = V4L2_MEMORY_MMAP;
+                buf.index = i;
+                xioctl(fd, VIDIOC_QBUF, &buf);
+        }
+
+        // start streaming
+        type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+        xioctl(fd, VIDIOC_STREAMON, &type);
     }
 
     /*
@@ -68,8 +138,17 @@ namespace gr {
      */
     libv4l2_x_impl::~libv4l2_x_impl()
     {
-        if (fd > 0)
-            v4l2_close(fd);
+        unsigned int i;
+        enum v4l2_buf_type type;
+
+        // stop streaming
+        type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+        xioctl(fd, VIDIOC_STREAMOFF, &type);
+
+        for (i = 0; i < n_buffers; i++)
+                v4l2_munmap(buffers[i].start, buffers[i].length);
+
+        v4l2_close(fd);
     }
 
     void
@@ -156,17 +235,36 @@ namespace gr {
               gr_vector_void_star &output_items)
     {
         gr_complex *out = (gr_complex *) output_items[0];
-        int ret, errors = 0, i;
+        int ret;
+        struct timeval tv;
+        struct v4l2_buffer buf;
+        fd_set fds;
 
         // Read data from device
-        ret = v4l2_read(fd, out, noutput_items * sizeof (gr_complex));
+        do {
+                FD_ZERO(&fds);
+                FD_SET(fd, &fds);
+
+                // Timeout
+                tv.tv_sec = 2;
+                tv.tv_usec = 0;
+
+                ret = select(fd + 1, &fds, NULL, NULL, &tv);
+        } while ((ret == -1 && (errno = EINTR)));
+        if (ret == -1) {
+                perror("select");
+                return errno;
+        }
 
-        // Tell runtime system how many output items we produced.
-        if (ret > 0)
-            ret = ret / sizeof (gr_complex);
-        else
-            ret = 0;
+        CLEAR(buf);
+        buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+        buf.memory = V4L2_MEMORY_MMAP;
+        xioctl(fd, VIDIOC_DQBUF, &buf);
+        memcpy(out, buffers[buf.index].start, buf.bytesused);
+        ret = buf.bytesused / sizeof (gr_complex);
+        xioctl(fd, VIDIOC_QBUF, &buf);
 
+        // Tell runtime system how many output items we produced.
         return ret;
     }
 
diff --git a/lib/libv4l2_x_impl.h b/lib/libv4l2_x_impl.h
index 276a64f..e0439b3 100644
--- a/lib/libv4l2_x_impl.h
+++ b/lib/libv4l2_x_impl.h
@@ -25,12 +25,19 @@
 
 namespace gr {
   namespace kernel {
+    // v4l2_mmap
+    struct buffer {
+      void *start;
+      size_t length;
+    };
 
     class libv4l2_x_impl : public libv4l2_x
     {
     private:
       // v4l2 device file handle
       int fd;
+      struct buffer *buffers;
+      unsigned int n_buffers;
 
     public:
       libv4l2_x_impl(const char *filename);
-- 
1.8.4.2

