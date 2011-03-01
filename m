Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:2235 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752559Ab1CANTR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Mar 2011 08:19:17 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p21DJHXM013429
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 1 Mar 2011 08:19:17 -0500
Received: from pedra (vpn-225-140.phx2.redhat.com [10.3.225.140])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p21DIEb7025546
	for <linux-media@vger.kernel.org>; Tue, 1 Mar 2011 08:19:16 -0500
Date: Tue, 1 Mar 2011 10:17:58 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/3] [media] videodev2.h.xml: Update to reflect videodev2.h
 changes
Message-ID: <20110301101758.34c37a01@pedra>
In-Reply-To: <cover.1298985234.git.mchehab@redhat.com>
References: <cover.1298985234.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

A few changes happened at videodev2.h:
	- Addition of multiplane API;
	- removal of VIDIOC_*_OLD ioctls;
	- a few more video standards.

Update the file to reflect the latest changes.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/DocBook/v4l/videodev2.h.xml b/Documentation/DocBook/v4l/videodev2.h.xml
index 325b23b..2b796a2 100644
--- a/Documentation/DocBook/v4l/videodev2.h.xml
+++ b/Documentation/DocBook/v4l/videodev2.h.xml
@@ -71,6 +71,7 @@
  * Moved from videodev.h
  */
 #define VIDEO_MAX_FRAME               32
+#define VIDEO_MAX_PLANES               8
 
 #ifndef __KERNEL__
 
@@ -158,9 +159,23 @@ enum <link linkend="v4l2-buf-type">v4l2_buf_type</link> {
         /* Experimental */
         V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY = 8,
 #endif
+        V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE = 9,
+        V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE  = 10,
         V4L2_BUF_TYPE_PRIVATE              = 0x80,
 };
 
+#define V4L2_TYPE_IS_MULTIPLANAR(type)                  \
+        ((type) == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE   \
+         || (type) == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+
+#define V4L2_TYPE_IS_OUTPUT(type)                               \
+        ((type) == V4L2_BUF_TYPE_VIDEO_OUTPUT                   \
+         || (type) == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE         \
+         || (type) == V4L2_BUF_TYPE_VIDEO_OVERLAY               \
+         || (type) == V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY        \
+         || (type) == V4L2_BUF_TYPE_VBI_OUTPUT                  \
+         || (type) == V4L2_BUF_TYPE_SLICED_VBI_OUTPUT)
+
 enum <link linkend="v4l2-tuner-type">v4l2_tuner_type</link> {
         V4L2_TUNER_RADIO             = 1,
         V4L2_TUNER_ANALOG_TV         = 2,
@@ -246,6 +261,11 @@ struct <link linkend="v4l2-capability">v4l2_capability</link> {
 #define V4L2_CAP_HW_FREQ_SEEK           0x00000400  /* Can do hardware frequency seek  */
 #define V4L2_CAP_RDS_OUTPUT             0x00000800  /* Is an RDS encoder */
 
+/* Is a video capture device that supports multiplanar formats */
+#define V4L2_CAP_VIDEO_CAPTURE_MPLANE   0x00001000
+/* Is a video output device that supports multiplanar formats */
+#define V4L2_CAP_VIDEO_OUTPUT_MPLANE    0x00002000
+
 #define V4L2_CAP_TUNER                  0x00010000  /* has a tuner */
 #define V4L2_CAP_AUDIO                  0x00020000  /* has audio support */
 #define V4L2_CAP_RADIO                  0x00040000  /* is a radio device */
@@ -320,6 +340,13 @@ struct <link linkend="v4l2-pix-format">v4l2_pix_format</link> {
 #define <link linkend="V4L2-PIX-FMT-NV16">V4L2_PIX_FMT_NV16</link>    v4l2_fourcc('N', 'V', '1', '6') /* 16  Y/CbCr 4:2:2  */
 #define <link linkend="V4L2-PIX-FMT-NV61">V4L2_PIX_FMT_NV61</link>    v4l2_fourcc('N', 'V', '6', '1') /* 16  Y/CrCb 4:2:2  */
 
+/* two non contiguous planes - one Y, one Cr + Cb interleaved  */
+#define <link linkend="V4L2-PIX-FMT-NV12M">V4L2_PIX_FMT_NV12M</link>   v4l2_fourcc('N', 'M', '1', '2') /* 12  Y/CbCr 4:2:0  */
+#define <link linkend="V4L2-PIX-FMT-NV12MT">V4L2_PIX_FMT_NV12MT</link>  v4l2_fourcc('T', 'M', '1', '2') /* 12  Y/CbCr 4:2:0 64x32 macroblocks */
+
+/* three non contiguous planes - Y, Cb, Cr */
+#define <link linkend="V4L2-PIX-FMT-YUV420M">V4L2_PIX_FMT_YUV420M</link> v4l2_fourcc('Y', 'M', '1', '2') /* 12  YUV420 planar */
+
 /* Bayer formats - see http://www.siliconimaging.com/RGB%20Bayer.htm */
 #define <link linkend="V4L2-PIX-FMT-SBGGR8">V4L2_PIX_FMT_SBGGR8</link>  v4l2_fourcc('B', 'A', '8', '1') /*  8  BGBG.. GRGR.. */
 #define <link linkend="V4L2-PIX-FMT-SGBRG8">V4L2_PIX_FMT_SGBRG8</link>  v4l2_fourcc('G', 'B', 'R', 'G') /*  8  GBGB.. RGRG.. */
@@ -518,6 +545,62 @@ struct <link linkend="v4l2-requestbuffers">v4l2_requestbuffers</link> {
         __u32                   reserved[2];
 };
 
+/**
+ * struct <link linkend="v4l2-plane">v4l2_plane</link> - plane info for multi-planar buffers
+ * @bytesused:          number of bytes occupied by data in the plane (payload)
+ * @length:             size of this plane (NOT the payload) in bytes
+ * @mem_offset:         when memory in the associated struct <link linkend="v4l2-buffer">v4l2_buffer</link> is
+ *                      V4L2_MEMORY_MMAP, equals the offset from the start of
+ *                      the device memory for this plane (or is a "cookie" that
+ *                      should be passed to mmap() called on the video node)
+ * @userptr:            when memory is V4L2_MEMORY_USERPTR, a userspace pointer
+ *                      pointing to this plane
+ * @data_offset:        offset in the plane to the start of data; usually 0,
+ *                      unless there is a header in front of the data
+ *
+ * Multi-planar buffers consist of one or more planes, e.g. an YCbCr buffer
+ * with two planes can have one plane for Y, and another for interleaved CbCr
+ * components. Each plane can reside in a separate memory buffer, or even in
+ * a completely separate memory node (e.g. in embedded devices).
+ */
+struct <link linkend="v4l2-plane">v4l2_plane</link> {
+        __u32                   bytesused;
+        __u32                   length;
+        union {
+                __u32           mem_offset;
+                unsigned long   userptr;
+        } m;
+        __u32                   data_offset;
+        __u32                   reserved[11];
+};
+
+/**
+ * struct <link linkend="v4l2-buffer">v4l2_buffer</link> - video buffer info
+ * @index:      id number of the buffer
+ * @type:       buffer type (type == *_MPLANE for multiplanar buffers)
+ * @bytesused:  number of bytes occupied by data in the buffer (payload);
+ *              unused (set to 0) for multiplanar buffers
+ * @flags:      buffer informational flags
+ * @field:      field order of the image in the buffer
+ * @timestamp:  frame timestamp
+ * @timecode:   frame timecode
+ * @sequence:   sequence count of this frame
+ * @memory:     the method, in which the actual video data is passed
+ * @offset:     for non-multiplanar buffers with memory == V4L2_MEMORY_MMAP;
+ *              offset from the start of the device memory for this plane,
+ *              (or a "cookie" that should be passed to mmap() as offset)
+ * @userptr:    for non-multiplanar buffers with memory == V4L2_MEMORY_USERPTR;
+ *              a userspace pointer pointing to this buffer
+ * @planes:     for multiplanar buffers; userspace pointer to the array of plane
+ *              info structs for this buffer
+ * @length:     size in bytes of the buffer (NOT its payload) for single-plane
+ *              buffers (when type != *_MPLANE); number of elements in the
+ *              planes array for multi-plane buffers
+ * @input:      input number from which the video data has has been captured
+ *
+ * Contains data exchanged by application and driver using one of the Streaming
+ * I/O methods.
+ */
 struct <link linkend="v4l2-buffer">v4l2_buffer</link> {
         __u32                   index;
         enum <link linkend="v4l2-buf-type">v4l2_buf_type</link>      type;
@@ -533,6 +616,7 @@ struct <link linkend="v4l2-buffer">v4l2_buffer</link> {
         union {
                 __u32           offset;
                 unsigned long   userptr;
+                struct <link linkend="v4l2-plane">v4l2_plane</link> *planes;
         } m;
         __u32                   length;
         __u32                   input;
@@ -1623,12 +1707,56 @@ struct <link linkend="v4l2-mpeg-vbi-fmt-ivtv">v4l2_mpeg_vbi_fmt_ivtv</link> {
  *      A G G R E G A T E   S T R U C T U R E S
  */
 
-/*      Stream data format
+/**
+ * struct <link linkend="v4l2-plane-pix-format">v4l2_plane_pix_format</link> - additional, per-plane format definition
+ * @sizeimage:          maximum size in bytes required for data, for which
+ *                      this plane will be used
+ * @bytesperline:       distance in bytes between the leftmost pixels in two
+ *                      adjacent lines
+ */
+struct <link linkend="v4l2-plane-pix-format">v4l2_plane_pix_format</link> {
+        __u32           sizeimage;
+        __u16           bytesperline;
+        __u16           reserved[7];
+} __attribute__ ((packed));
+
+/**
+ * struct <link linkend="v4l2-pix-format-mplane">v4l2_pix_format_mplane</link> - multiplanar format definition
+ * @width:              image width in pixels
+ * @height:             image height in pixels
+ * @pixelformat:        little endian four character code (fourcc)
+ * @field:              field order (for interlaced video)
+ * @colorspace:         supplemental to pixelformat
+ * @plane_fmt:          per-plane information
+ * @num_planes:         number of planes for this format
+ */
+struct <link linkend="v4l2-pix-format-mplane">v4l2_pix_format_mplane</link> {
+        __u32                           width;
+        __u32                           height;
+        __u32                           pixelformat;
+        enum <link linkend="v4l2-field">v4l2_field</link>                 field;
+        enum <link linkend="v4l2-colorspace">v4l2_colorspace</link>            colorspace;
+
+        struct <link linkend="v4l2-plane-pix-format">v4l2_plane_pix_format</link>    plane_fmt[VIDEO_MAX_PLANES];
+        __u8                            num_planes;
+        __u8                            reserved[11];
+} __attribute__ ((packed));
+
+/**
+ * struct <link linkend="v4l2-format">v4l2_format</link> - stream data format
+ * @type:       type of the data stream
+ * @pix:        definition of an image format
+ * @pix_mp:     definition of a multiplanar image format
+ * @win:        definition of an overlaid image
+ * @vbi:        raw VBI capture or output parameters
+ * @sliced:     sliced VBI capture or output parameters
+ * @raw_data:   placeholder for future extensions and custom formats
  */
 struct <link linkend="v4l2-format">v4l2_format</link> {
         enum <link linkend="v4l2-buf-type">v4l2_buf_type</link> type;
         union {
                 struct <link linkend="v4l2-pix-format">v4l2_pix_format</link>          pix;     /* V4L2_BUF_TYPE_VIDEO_CAPTURE */
+                struct <link linkend="v4l2-pix-format-mplane">v4l2_pix_format_mplane</link>   pix_mp;  /* V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE */
                 struct <link linkend="v4l2-window">v4l2_window</link>              win;     /* V4L2_BUF_TYPE_VIDEO_OVERLAY */
                 struct <link linkend="v4l2-vbi-format">v4l2_vbi_format</link>          vbi;     /* V4L2_BUF_TYPE_VBI_CAPTURE */
                 struct <link linkend="v4l2-sliced-vbi-format">v4l2_sliced_vbi_format</link>   sliced;  /* V4L2_BUF_TYPE_SLICED_VBI_CAPTURE */
@@ -1636,7 +1764,6 @@ struct <link linkend="v4l2-format">v4l2_format</link> {
         } fmt;
 };
 
-
 /*      Stream type-dependent parameters
  */
 struct <link linkend="v4l2-streamparm">v4l2_streamparm</link> {
@@ -1809,16 +1936,6 @@ struct <link linkend="v4l2-dbg-chip-ident">v4l2_dbg_chip_ident</link> {
 /* Reminder: when adding new ioctls please add support for them to
    drivers/media/video/v4l2-compat-ioctl32.c as well! */
 
-#ifdef __OLD_VIDIOC_
-/* for compatibility, will go away some day */
-#define VIDIOC_OVERLAY_OLD      _IOWR('V', 14, int)
-#define VIDIOC_S_PARM_OLD        _IOW('V', 22, struct <link linkend="v4l2-streamparm">v4l2_streamparm</link>)
-#define VIDIOC_S_CTRL_OLD        _IOW('V', 28, struct <link linkend="v4l2-control">v4l2_control</link>)
-#define VIDIOC_G_AUDIO_OLD      _IOWR('V', 33, struct <link linkend="v4l2-audio">v4l2_audio</link>)
-#define VIDIOC_G_AUDOUT_OLD     _IOWR('V', 49, struct <link linkend="v4l2-audioout">v4l2_audioout</link>)
-#define VIDIOC_CROPCAP_OLD       _IOR('V', 58, struct <link linkend="v4l2-cropcap">v4l2_cropcap</link>)
-#endif
-
 #define BASE_VIDIOC_PRIVATE     192             /* 192-255 are private */
 
 #endif /* __LINUX_VIDEODEV2_H */
-- 
1.7.1


