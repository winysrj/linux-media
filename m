Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42942 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752435AbcHSU2A (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 16:28:00 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>,
        linux-doc@vger.kernel.org
Subject: [PATCH 2/6] [media] docs-rst: Convert V4L2 uAPI to use C function references
Date: Fri, 19 Aug 2016 17:27:49 -0300
Message-Id: <3145f1a8853f04c435373c370844335900ed9797.1471636893.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471636893.git.mchehab@s-opensource.com>
References: <cover.1471636893.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471636893.git.mchehab@s-opensource.com>
References: <cover.1471636893.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Name all ioctl references and make them match the ioctls that
are documented. That will improve the cross-reference index,
as it will have all ioctls and syscalls there.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/func-close.rst             |  2 +-
 Documentation/media/uapi/v4l/func-ioctl.rst             |  2 +-
 Documentation/media/uapi/v4l/func-mmap.rst              |  2 +-
 Documentation/media/uapi/v4l/func-munmap.rst            |  2 +-
 Documentation/media/uapi/v4l/func-open.rst              |  2 +-
 Documentation/media/uapi/v4l/func-poll.rst              |  2 +-
 Documentation/media/uapi/v4l/func-read.rst              |  6 ++++--
 Documentation/media/uapi/v4l/func-select.rst            | 16 +++++++++++++++-
 Documentation/media/uapi/v4l/func-write.rst             |  6 ++++--
 Documentation/media/uapi/v4l/vidioc-create-bufs.rst     |  6 ++----
 Documentation/media/uapi/v4l/vidioc-cropcap.rst         |  6 ++----
 Documentation/media/uapi/v4l/vidioc-dbg-g-chip-info.rst |  6 ++----
 Documentation/media/uapi/v4l/vidioc-dbg-g-register.rst  |  9 ++++-----
 Documentation/media/uapi/v4l/vidioc-decoder-cmd.rst     | 11 +++++++----
 Documentation/media/uapi/v4l/vidioc-dqevent.rst         |  6 ++----
 Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst  |  9 +++++----
 Documentation/media/uapi/v4l/vidioc-encoder-cmd.rst     |  9 +++++----
 Documentation/media/uapi/v4l/vidioc-enum-dv-timings.rst |  9 +++++----
 Documentation/media/uapi/v4l/vidioc-enum-fmt.rst        |  6 ++----
 .../media/uapi/v4l/vidioc-enum-frameintervals.rst       |  6 ++----
 Documentation/media/uapi/v4l/vidioc-enum-framesizes.rst |  6 ++----
 Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst |  6 ++----
 Documentation/media/uapi/v4l/vidioc-enumaudio.rst       |  6 ++----
 Documentation/media/uapi/v4l/vidioc-enumaudioout.rst    |  6 ++----
 Documentation/media/uapi/v4l/vidioc-enuminput.rst       |  6 ++----
 Documentation/media/uapi/v4l/vidioc-enumoutput.rst      |  6 ++----
 Documentation/media/uapi/v4l/vidioc-enumstd.rst         |  6 ++----
 Documentation/media/uapi/v4l/vidioc-expbuf.rst          |  6 ++----
 Documentation/media/uapi/v4l/vidioc-g-audio.rst         |  9 ++++-----
 Documentation/media/uapi/v4l/vidioc-g-audioout.rst      |  9 ++++-----
 Documentation/media/uapi/v4l/vidioc-g-crop.rst          |  9 ++++-----
 Documentation/media/uapi/v4l/vidioc-g-ctrl.rst          |  9 +++++----
 Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst    | 16 +++++++++++-----
 Documentation/media/uapi/v4l/vidioc-g-edid.rst          | 17 ++++++++++++-----
 Documentation/media/uapi/v4l/vidioc-g-enc-index.rst     |  6 ++----
 Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst     | 15 ++++++++++-----
 Documentation/media/uapi/v4l/vidioc-g-fbuf.rst          |  9 ++++-----
 Documentation/media/uapi/v4l/vidioc-g-fmt.rst           | 11 +++++++----
 Documentation/media/uapi/v4l/vidioc-g-frequency.rst     |  9 ++++-----
 Documentation/media/uapi/v4l/vidioc-g-input.rst         |  9 +++++----
 Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst      |  9 ++++-----
 Documentation/media/uapi/v4l/vidioc-g-modulator.rst     |  9 ++++-----
 Documentation/media/uapi/v4l/vidioc-g-output.rst        |  9 +++++----
 Documentation/media/uapi/v4l/vidioc-g-parm.rst          |  9 +++++----
 Documentation/media/uapi/v4l/vidioc-g-priority.rst      |  9 ++++-----
 Documentation/media/uapi/v4l/vidioc-g-selection.rst     |  7 ++++++-
 .../media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst          |  6 ++----
 Documentation/media/uapi/v4l/vidioc-g-std.rst           |  9 ++++-----
 Documentation/media/uapi/v4l/vidioc-g-tuner.rst         |  9 ++++-----
 Documentation/media/uapi/v4l/vidioc-log-status.rst      |  5 ++++-
 Documentation/media/uapi/v4l/vidioc-overlay.rst         |  6 ++----
 Documentation/media/uapi/v4l/vidioc-prepare-buf.rst     |  6 ++----
 Documentation/media/uapi/v4l/vidioc-qbuf.rst            |  9 +++++----
 .../media/uapi/v4l/vidioc-query-dv-timings.rst          |  9 +++++----
 Documentation/media/uapi/v4l/vidioc-querybuf.rst        |  6 ++----
 Documentation/media/uapi/v4l/vidioc-querycap.rst        |  6 ++----
 Documentation/media/uapi/v4l/vidioc-queryctrl.rst       | 12 ++++++------
 Documentation/media/uapi/v4l/vidioc-querystd.rst        |  6 ++----
 Documentation/media/uapi/v4l/vidioc-reqbufs.rst         |  6 ++----
 Documentation/media/uapi/v4l/vidioc-s-hw-freq-seek.rst  |  6 ++----
 Documentation/media/uapi/v4l/vidioc-streamon.rst        |  9 +++++----
 .../uapi/v4l/vidioc-subdev-enum-frame-interval.rst      |  6 ++----
 .../media/uapi/v4l/vidioc-subdev-enum-frame-size.rst    |  6 ++----
 .../media/uapi/v4l/vidioc-subdev-enum-mbus-code.rst     |  6 ++----
 Documentation/media/uapi/v4l/vidioc-subdev-g-crop.rst   |  9 ++++-----
 Documentation/media/uapi/v4l/vidioc-subdev-g-fmt.rst    |  9 +++++----
 .../media/uapi/v4l/vidioc-subdev-g-frame-interval.rst   | 10 +++++-----
 .../media/uapi/v4l/vidioc-subdev-g-selection.rst        |  9 +++++----
 Documentation/media/uapi/v4l/vidioc-subscribe-event.rst |  9 +++++----
 69 files changed, 262 insertions(+), 263 deletions(-)

diff --git a/Documentation/media/uapi/v4l/func-close.rst b/Documentation/media/uapi/v4l/func-close.rst
index 148fc009d033..e85a6744eb91 100644
--- a/Documentation/media/uapi/v4l/func-close.rst
+++ b/Documentation/media/uapi/v4l/func-close.rst
@@ -21,7 +21,7 @@ Synopsis
 
 
 .. c:function:: int close( int fd )
-
+    :name: v4l2-close
 
 Arguments
 =========
diff --git a/Documentation/media/uapi/v4l/func-ioctl.rst b/Documentation/media/uapi/v4l/func-ioctl.rst
index c207f0727cf1..ebfbe92f0478 100644
--- a/Documentation/media/uapi/v4l/func-ioctl.rst
+++ b/Documentation/media/uapi/v4l/func-ioctl.rst
@@ -21,7 +21,7 @@ Synopsis
 
 
 .. c:function:: int ioctl( int fd, int request, void *argp )
-
+    :name: v4l2-ioctl
 
 Arguments
 =========
diff --git a/Documentation/media/uapi/v4l/func-mmap.rst b/Documentation/media/uapi/v4l/func-mmap.rst
index e30b2981028f..bd19cef952f5 100644
--- a/Documentation/media/uapi/v4l/func-mmap.rst
+++ b/Documentation/media/uapi/v4l/func-mmap.rst
@@ -22,7 +22,7 @@ Synopsis
 
 
 .. c:function:: void *mmap( void *start, size_t length, int prot, int flags, int fd, off_t offset )
-
+    :name: v4l2-mmap
 
 Arguments
 =========
diff --git a/Documentation/media/uapi/v4l/func-munmap.rst b/Documentation/media/uapi/v4l/func-munmap.rst
index 51eafb215838..a1a4d8cb6c4b 100644
--- a/Documentation/media/uapi/v4l/func-munmap.rst
+++ b/Documentation/media/uapi/v4l/func-munmap.rst
@@ -22,7 +22,7 @@ Synopsis
 
 
 .. c:function:: int munmap( void *start, size_t length )
-
+    :name: v4l2-munmap
 
 Arguments
 =========
diff --git a/Documentation/media/uapi/v4l/func-open.rst b/Documentation/media/uapi/v4l/func-open.rst
index 1d9e75d4960a..deea34cc778b 100644
--- a/Documentation/media/uapi/v4l/func-open.rst
+++ b/Documentation/media/uapi/v4l/func-open.rst
@@ -21,7 +21,7 @@ Synopsis
 
 
 .. c:function:: int open( const char *device_name, int flags )
-
+    :name: v4l2-open
 
 Arguments
 =========
diff --git a/Documentation/media/uapi/v4l/func-poll.rst b/Documentation/media/uapi/v4l/func-poll.rst
index da0edfcf9b9b..186cd61b6cd1 100644
--- a/Documentation/media/uapi/v4l/func-poll.rst
+++ b/Documentation/media/uapi/v4l/func-poll.rst
@@ -21,7 +21,7 @@ Synopsis
 
 
 .. c:function:: int poll( struct pollfd *ufds, unsigned int nfds, int timeout )
-
+    name: v4l2-poll
 
 Arguments
 =========
diff --git a/Documentation/media/uapi/v4l/func-read.rst b/Documentation/media/uapi/v4l/func-read.rst
index 9c5b4be926db..ae38c2d59d49 100644
--- a/Documentation/media/uapi/v4l/func-read.rst
+++ b/Documentation/media/uapi/v4l/func-read.rst
@@ -21,7 +21,7 @@ Synopsis
 
 
 .. c:function:: ssize_t read( int fd, void *buf, size_t count )
-
+    :name: v4l2-read
 
 Arguments
 =========
@@ -30,8 +30,10 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``buf``
+   Buffer to be filled
+
 ``count``
-
+  Max number of bytes to read
 
 Description
 ===========
diff --git a/Documentation/media/uapi/v4l/func-select.rst b/Documentation/media/uapi/v4l/func-select.rst
index 78fa66b984d3..002dedba2666 100644
--- a/Documentation/media/uapi/v4l/func-select.rst
+++ b/Documentation/media/uapi/v4l/func-select.rst
@@ -23,11 +23,25 @@ Synopsis
 
 
 .. c:function:: int select( int nfds, fd_set *readfds, fd_set *writefds, fd_set *exceptfds, struct timeval *timeout )
-
+    :name: v4l2-select
 
 Arguments
 =========
 
+``nfds``
+  The highest-numbered file descriptor in any of the three sets, plus 1.
+
+``readfds``
+  File descriptions to be watched if a read() call won't block.
+
+``writefds``
+  File descriptions to be watched if a write() won't block.
+
+``exceptfds``
+  File descriptions to be watched for V4L2 events.
+
+``timeout``
+  Maximum time to wait.
 
 
 Description
diff --git a/Documentation/media/uapi/v4l/func-write.rst b/Documentation/media/uapi/v4l/func-write.rst
index c9351a0efd99..938f33f85455 100644
--- a/Documentation/media/uapi/v4l/func-write.rst
+++ b/Documentation/media/uapi/v4l/func-write.rst
@@ -21,7 +21,7 @@ Synopsis
 
 
 .. c:function:: ssize_t write( int fd, void *buf, size_t count )
-
+    :name: v4l2-write
 
 Arguments
 =========
@@ -30,8 +30,10 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``buf``
+     Buffer with data to be written
+
 ``count``
-
+    Number of bytes at the buffer
 
 Description
 ===========
diff --git a/Documentation/media/uapi/v4l/vidioc-create-bufs.rst b/Documentation/media/uapi/v4l/vidioc-create-bufs.rst
index d5107466b2c5..dc75f21e4b4c 100644
--- a/Documentation/media/uapi/v4l/vidioc-create-bufs.rst
+++ b/Documentation/media/uapi/v4l/vidioc-create-bufs.rst
@@ -15,7 +15,8 @@ VIDIOC_CREATE_BUFS - Create buffers for Memory Mapped or User Pointer or DMA Buf
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_create_buffers *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_CREATE_BUFS, struct v4l2_create_buffers *argp )
+    :name: VIDIOC_CREATE_BUFS
 
 
 Arguments
@@ -24,9 +25,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_CREATE_BUFS
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-cropcap.rst b/Documentation/media/uapi/v4l/vidioc-cropcap.rst
index 30a0493f404a..b41fdd69054b 100644
--- a/Documentation/media/uapi/v4l/vidioc-cropcap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-cropcap.rst
@@ -15,7 +15,8 @@ VIDIOC_CROPCAP - Information about the video cropping and scaling abilities
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_cropcap *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_CROPCAP, struct v4l2_cropcap *argp )
+    :name: VIDIOC_CROPCAP
 
 
 Arguments
@@ -24,9 +25,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_CROPCAP
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-dbg-g-chip-info.rst b/Documentation/media/uapi/v4l/vidioc-dbg-g-chip-info.rst
index f0310afe6606..9c97527dc2cf 100644
--- a/Documentation/media/uapi/v4l/vidioc-dbg-g-chip-info.rst
+++ b/Documentation/media/uapi/v4l/vidioc-dbg-g-chip-info.rst
@@ -15,7 +15,8 @@ VIDIOC_DBG_G_CHIP_INFO - Identify the chips on a TV card
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_dbg_chip_info *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_DBG_G_CHIP_INFO, struct v4l2_dbg_chip_info *argp )
+    :name: VIDIOC_DBG_G_CHIP_INFO
 
 
 Arguments
@@ -24,9 +25,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_DBG_G_CHIP_INFO
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-dbg-g-register.rst b/Documentation/media/uapi/v4l/vidioc-dbg-g-register.rst
index 2b508e8faa4b..6eeb0de24b50 100644
--- a/Documentation/media/uapi/v4l/vidioc-dbg-g-register.rst
+++ b/Documentation/media/uapi/v4l/vidioc-dbg-g-register.rst
@@ -15,9 +15,11 @@ VIDIOC_DBG_G_REGISTER - VIDIOC_DBG_S_REGISTER - Read or write hardware registers
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_dbg_register *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_DBG_G_REGISTER, struct v4l2_dbg_register *argp )
+    :name: VIDIOC_DBG_G_REGISTER
 
-.. c:function:: int ioctl( int fd, int request, const struct v4l2_dbg_register *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_DBG_S_REGISTER, const struct v4l2_dbg_register *argp )
+    :name: VIDIOC_DBG_S_REGISTER
 
 
 Arguments
@@ -26,9 +28,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_DBG_G_REGISTER, VIDIOC_DBG_S_REGISTER
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-decoder-cmd.rst b/Documentation/media/uapi/v4l/vidioc-decoder-cmd.rst
index 1d918ade637e..6077caac6086 100644
--- a/Documentation/media/uapi/v4l/vidioc-decoder-cmd.rst
+++ b/Documentation/media/uapi/v4l/vidioc-decoder-cmd.rst
@@ -15,7 +15,12 @@ VIDIOC_DECODER_CMD - VIDIOC_TRY_DECODER_CMD - Execute an decoder command
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_decoder_cmd *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_DECODER_CMD, struct v4l2_decoder_cmd *argp )
+    :name: VIDIOC_DECODER_CMD
+
+
+.. c:function:: int ioctl( int fd, VIDIOC_TRY_DECODER_CMD, struct v4l2_decoder_cmd *argp )
+    :name: VIDIOC_TRY_DECODER_CMD
 
 
 Arguments
@@ -24,10 +29,8 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_DECODER_CMD, VIDIOC_TRY_DECODER_CMD
-
 ``argp``
+    pointer to struct :ref:`v4l2_decoder_cmd <v4l2-decoder-cmd>`.
 
 
 Description
diff --git a/Documentation/media/uapi/v4l/vidioc-dqevent.rst b/Documentation/media/uapi/v4l/vidioc-dqevent.rst
index c2c2a3337d09..067e0aa27918 100644
--- a/Documentation/media/uapi/v4l/vidioc-dqevent.rst
+++ b/Documentation/media/uapi/v4l/vidioc-dqevent.rst
@@ -15,7 +15,8 @@ VIDIOC_DQEVENT - Dequeue event
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_event *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_DQEVENT, struct v4l2_event *argp )
+    :name: VIDIOC_DQEVENT
 
 
 Arguments
@@ -24,9 +25,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_DQEVENT
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst b/Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst
index 110e5783938d..741718baf14b 100644
--- a/Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst
@@ -15,7 +15,11 @@ VIDIOC_DV_TIMINGS_CAP - VIDIOC_SUBDEV_DV_TIMINGS_CAP - The capabilities of the D
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_dv_timings_cap *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_DV_TIMINGS_CAP, struct v4l2_dv_timings_cap *argp )
+    :name: VIDIOC_DV_TIMINGS_CAP
+
+.. c:function:: int ioctl( int fd, VIDIOC_SUBDEV_DV_TIMINGS_CAP, struct v4l2_dv_timings_cap *argp )
+    :name: VIDIOC_SUBDEV_DV_TIMINGS_CAP
 
 
 Arguments
@@ -24,9 +28,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_DV_TIMINGS_CAP, VIDIOC_SUBDEV_DV_TIMINGS_CAP
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-encoder-cmd.rst b/Documentation/media/uapi/v4l/vidioc-encoder-cmd.rst
index 756a85f78f31..802eac3ca9ec 100644
--- a/Documentation/media/uapi/v4l/vidioc-encoder-cmd.rst
+++ b/Documentation/media/uapi/v4l/vidioc-encoder-cmd.rst
@@ -15,7 +15,11 @@ VIDIOC_ENCODER_CMD - VIDIOC_TRY_ENCODER_CMD - Execute an encoder command
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_encoder_cmd *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_ENCODER_CMD, struct v4l2_encoder_cmd *argp )
+    :name: VIDIOC_ENCODER_CMD
+
+.. c:function:: int ioctl( int fd, VIDIOC_TRY_ENCODER_CMD, struct v4l2_encoder_cmd *argp )
+    :name: VIDIOC_TRY_ENCODER_CMD
 
 
 Arguments
@@ -24,9 +28,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_ENCODER_CMD, VIDIOC_TRY_ENCODER_CMD
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-dv-timings.rst b/Documentation/media/uapi/v4l/vidioc-enum-dv-timings.rst
index 2ca25a58ae4c..db9613c9b4bd 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-dv-timings.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-dv-timings.rst
@@ -15,7 +15,11 @@ VIDIOC_ENUM_DV_TIMINGS - VIDIOC_SUBDEV_ENUM_DV_TIMINGS - Enumerate supported Dig
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_enum_dv_timings *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_ENUM_DV_TIMINGS, struct v4l2_enum_dv_timings *argp )
+    :name: VIDIOC_ENUM_DV_TIMINGS
+
+.. c:function:: int ioctl( int fd, VIDIOC_SUBDEV_ENUM_DV_TIMINGS, struct v4l2_enum_dv_timings *argp )
+    :name: VIDIOC_SUBDEV_ENUM_DV_TIMINGS
 
 
 Arguments
@@ -24,9 +28,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_ENUM_DV_TIMINGS, VIDIOC_SUBDEV_ENUM_DV_TIMINGS
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst b/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
index eca4614a1b13..1a4834934085 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
@@ -15,7 +15,8 @@ VIDIOC_ENUM_FMT - Enumerate image formats
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_fmtdesc *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_ENUM_FMT, struct v4l2_fmtdesc *argp )
+    :name: VIDIOC_ENUM_FMT
 
 
 Arguments
@@ -24,9 +25,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_ENUM_FMT
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-frameintervals.rst b/Documentation/media/uapi/v4l/vidioc-enum-frameintervals.rst
index 39fbbb391c99..f9bb6fb4ca8e 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-frameintervals.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-frameintervals.rst
@@ -15,7 +15,8 @@ VIDIOC_ENUM_FRAMEINTERVALS - Enumerate frame intervals
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_frmivalenum *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_ENUM_FRAMEINTERVALS, struct v4l2_frmivalenum *argp )
+    :name: VIDIOC_ENUM_FRAMEINTERVALS
 
 
 Arguments
@@ -24,9 +25,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_ENUM_FRAMEINTERVALS
-
 ``argp``
     Pointer to a struct :ref:`v4l2_frmivalenum <v4l2-frmivalenum>`
     structure that contains a pixel format and size and receives a frame
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-framesizes.rst b/Documentation/media/uapi/v4l/vidioc-enum-framesizes.rst
index 1d428f88f329..4fb19b75abf1 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-framesizes.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-framesizes.rst
@@ -15,7 +15,8 @@ VIDIOC_ENUM_FRAMESIZES - Enumerate frame sizes
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_frmsizeenum *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_ENUM_FRAMESIZES, struct v4l2_frmsizeenum *argp )
+    :name: VIDIOC_ENUM_FRAMESIZES
 
 
 Arguments
@@ -24,9 +25,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_ENUM_FRAMESIZES
-
 ``argp``
     Pointer to a struct :ref:`v4l2_frmsizeenum <v4l2-frmsizeenum>`
     that contains an index and pixel format and receives a frame width
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst b/Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst
index 5fe84357d9cd..60ae938d5ef8 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst
@@ -15,7 +15,8 @@ VIDIOC_ENUM_FREQ_BANDS - Enumerate supported frequency bands
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_frequency_band *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_ENUM_FREQ_BANDS, struct v4l2_frequency_band *argp )
+    :name: VIDIOC_ENUM_FREQ_BANDS
 
 
 Arguments
@@ -24,9 +25,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_ENUM_FREQ_BANDS
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-enumaudio.rst b/Documentation/media/uapi/v4l/vidioc-enumaudio.rst
index 3127b9062d96..c9d9eb60551e 100644
--- a/Documentation/media/uapi/v4l/vidioc-enumaudio.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enumaudio.rst
@@ -15,7 +15,8 @@ VIDIOC_ENUMAUDIO - Enumerate audio inputs
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_audio *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_ENUMAUDIO, struct v4l2_audio *argp )
+    :name: VIDIOC_ENUMAUDIO
 
 
 Arguments
@@ -24,9 +25,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_ENUMAUDIO
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-enumaudioout.rst b/Documentation/media/uapi/v4l/vidioc-enumaudioout.rst
index 4cbba134e773..a7a27327fe88 100644
--- a/Documentation/media/uapi/v4l/vidioc-enumaudioout.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enumaudioout.rst
@@ -15,7 +15,8 @@ VIDIOC_ENUMAUDOUT - Enumerate audio outputs
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_audioout *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_ENUMAUDOUT, struct v4l2_audioout *argp )
+    :name: VIDIOC_ENUMAUDOUT
 
 
 Arguments
@@ -24,9 +25,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_ENUMAUDOUT
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-enuminput.rst b/Documentation/media/uapi/v4l/vidioc-enuminput.rst
index 075cdf2c5749..51747b7b7f29 100644
--- a/Documentation/media/uapi/v4l/vidioc-enuminput.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enuminput.rst
@@ -15,7 +15,8 @@ VIDIOC_ENUMINPUT - Enumerate video inputs
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_input *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_ENUMINPUT, struct v4l2_input *argp )
+    :name: VIDIOC_ENUMINPUT
 
 
 Arguments
@@ -24,9 +25,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_ENUMINPUT
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-enumoutput.rst b/Documentation/media/uapi/v4l/vidioc-enumoutput.rst
index d2c1d4eaaf47..d660c37d3516 100644
--- a/Documentation/media/uapi/v4l/vidioc-enumoutput.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enumoutput.rst
@@ -15,7 +15,8 @@ VIDIOC_ENUMOUTPUT - Enumerate video outputs
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_output *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_ENUMOUTPUT, struct v4l2_output *argp )
+    :name: VIDIOC_ENUMOUTPUT
 
 
 Arguments
@@ -24,9 +25,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_ENUMOUTPUT
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-enumstd.rst b/Documentation/media/uapi/v4l/vidioc-enumstd.rst
index 73c2358185a4..4c4b61561d85 100644
--- a/Documentation/media/uapi/v4l/vidioc-enumstd.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enumstd.rst
@@ -15,7 +15,8 @@ VIDIOC_ENUMSTD - Enumerate supported video standards
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_standard *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_ENUMSTD, struct v4l2_standard *argp )
+    :name: VIDIOC_ENUMSTD
 
 
 Arguments
@@ -24,9 +25,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_ENUMSTD
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-expbuf.rst b/Documentation/media/uapi/v4l/vidioc-expbuf.rst
index 5e2db6efce38..f7b8d643fd28 100644
--- a/Documentation/media/uapi/v4l/vidioc-expbuf.rst
+++ b/Documentation/media/uapi/v4l/vidioc-expbuf.rst
@@ -15,7 +15,8 @@ VIDIOC_EXPBUF - Export a buffer as a DMABUF file descriptor.
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_exportbuffer *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_EXPBUF, struct v4l2_exportbuffer *argp )
+    :name: VIDIOC_EXPBUF
 
 
 Arguments
@@ -24,9 +25,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_EXPBUF
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-audio.rst b/Documentation/media/uapi/v4l/vidioc-g-audio.rst
index 787668482198..224a09c2c53d 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-audio.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-audio.rst
@@ -15,9 +15,11 @@ VIDIOC_G_AUDIO - VIDIOC_S_AUDIO - Query or select the current audio input and it
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_audio *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_G_AUDIO, struct v4l2_audio *argp )
+    :name: VIDIOC_G_AUDIO
 
-.. c:function:: int ioctl( int fd, int request, const struct v4l2_audio *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_S_AUDIO, const struct v4l2_audio *argp )
+    :name: VIDIOC_S_AUDIO
 
 
 Arguments
@@ -26,9 +28,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_G_AUDIO, VIDIOC_S_AUDIO
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-audioout.rst b/Documentation/media/uapi/v4l/vidioc-g-audioout.rst
index ed5ccca8797d..da8db3b42262 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-audioout.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-audioout.rst
@@ -15,9 +15,11 @@ VIDIOC_G_AUDOUT - VIDIOC_S_AUDOUT - Query or select the current audio output
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_audioout *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_G_AUDOUT, struct v4l2_audioout *argp )
+    :name: VIDIOC_G_AUDOUT
 
-.. c:function:: int ioctl( int fd, int request, const struct v4l2_audioout *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_S_AUDOUT, const struct v4l2_audioout *argp )
+    :name: VIDIOC_S_AUDOUT
 
 
 Arguments
@@ -26,9 +28,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_G_AUDOUT, VIDIOC_S_AUDOUT
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-crop.rst b/Documentation/media/uapi/v4l/vidioc-g-crop.rst
index 2b171b5c003e..d4b0607162c5 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-crop.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-crop.rst
@@ -15,9 +15,11 @@ VIDIOC_G_CROP - VIDIOC_S_CROP - Get or set the current cropping rectangle
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_crop *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_G_CROP, struct v4l2_crop *argp )
+    :name: VIDIOC_G_CROP
 
-.. c:function:: int ioctl( int fd, int request, const struct v4l2_crop *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_S_CROP, const struct v4l2_crop *argp )
+    :name: VIDIOC_S_CROP
 
 
 Arguments
@@ -26,9 +28,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_G_CROP, VIDIOC_S_CROP
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-ctrl.rst b/Documentation/media/uapi/v4l/vidioc-g-ctrl.rst
index 8eeb33916a7c..6ced76016246 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-ctrl.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-ctrl.rst
@@ -15,7 +15,11 @@ VIDIOC_G_CTRL - VIDIOC_S_CTRL - Get or set the value of a control
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_control *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_G_CTRL, struct v4l2_control *argp )
+    :name: VIDIOC_G_CTRL
+
+.. c:function:: int ioctl( int fd, VIDIOC_S_CTRL, struct v4l2_control *argp )
+    :name: VIDIOC_S_CTRL
 
 
 Arguments
@@ -24,9 +28,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_G_CTRL, VIDIOC_S_CTRL
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst b/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
index 401a9ad2ad7b..d75bf6742c5d 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
@@ -15,7 +15,17 @@ VIDIOC_G_DV_TIMINGS - VIDIOC_S_DV_TIMINGS - VIDIOC_SUBDEV_G_DV_TIMINGS - VIDIOC_
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_dv_timings *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_G_DV_TIMINGS, struct v4l2_dv_timings *argp )
+    :name: VIDIOC_G_DV_TIMINGS
+
+.. c:function:: int ioctl( int fd, VIDIOC_S_DV_TIMINGS, struct v4l2_dv_timings *argp )
+    :name: VIDIOC_S_DV_TIMINGS
+
+.. c:function:: int ioctl( int fd, VIDIOC_SUBDEV_G_DV_TIMINGS, struct v4l2_dv_timings *argp )
+    :name: VIDIOC_SUBDEV_G_DV_TIMINGS
+
+.. c:function:: int ioctl( int fd, VIDIOC_SUBDEV_S_DV_TIMINGS, struct v4l2_dv_timings *argp )
+    :name: VIDIOC_SUBDEV_S_DV_TIMINGS
 
 
 Arguments
@@ -24,10 +34,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_G_DV_TIMINGS, VIDIOC_S_DV_TIMINGS,
-    VIDIOC_SUBDEV_G_DV_TIMINGS, VIDIOC_SUBDEV_S_DV_TIMINGS
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-edid.rst b/Documentation/media/uapi/v4l/vidioc-g-edid.rst
index 0940d46ad007..b288d8ee49ef 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-edid.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-edid.rst
@@ -15,7 +15,18 @@ VIDIOC_G_EDID - VIDIOC_S_EDID - VIDIOC_SUBDEV_G_EDID - VIDIOC_SUBDEV_S_EDID - Ge
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_edid *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_G_EDID, struct v4l2_edid *argp )
+    :name: VIDIOC_G_EDID
+
+.. c:function:: int ioctl( int fd, VIDIOC_S_EDID, struct v4l2_edid *argp )
+    :name: VIDIOC_S_EDID
+
+
+.. c:function:: int ioctl( int fd, VIDIOC_SUBDEV_G_EDID, struct v4l2_edid *argp )
+    :name: VIDIOC_SUBDEV_G_EDID
+
+.. c:function:: int ioctl( int fd, VIDIOC_SUBDEV_S_EDID, struct v4l2_edid *argp )
+    :name: VIDIOC_SUBDEV_S_EDID
 
 
 Arguments
@@ -24,10 +35,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_G_EDID, VIDIOC_S_EDID, VIDIOC_SUBDEV_G_EDID,
-    VIDIOC_SUBDEV_S_EDID
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-enc-index.rst b/Documentation/media/uapi/v4l/vidioc-g-enc-index.rst
index 479993e1fbbf..3decb810c8bb 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-enc-index.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-enc-index.rst
@@ -15,7 +15,8 @@ VIDIOC_G_ENC_INDEX - Get meta data about a compressed video stream
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_enc_idx *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_G_ENC_INDEX, struct v4l2_enc_idx *argp )
+    :name: VIDIOC_G_ENC_INDEX
 
 
 Arguments
@@ -24,9 +25,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_G_ENC_INDEX
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst b/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
index d0ddf3094c16..ee72c69f902a 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
@@ -15,7 +15,16 @@ VIDIOC_G_EXT_CTRLS - VIDIOC_S_EXT_CTRLS - VIDIOC_TRY_EXT_CTRLS - Get or set the
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_ext_controls *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_G_EXT_CTRLS, struct v4l2_ext_controls *argp )
+    :name: VIDIOC_G_EXT_CTRLS
+
+
+.. c:function:: int ioctl( int fd, VIDIOC_S_EXT_CTRLS, struct v4l2_ext_controls *argp )
+    :name: VIDIOC_S_EXT_CTRLS
+
+
+.. c:function:: int ioctl( int fd, VIDIOC_TRY_EXT_CTRLS, struct v4l2_ext_controls *argp )
+    :name: VIDIOC_TRY_EXT_CTRLS
 
 
 Arguments
@@ -24,10 +33,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_G_EXT_CTRLS, VIDIOC_S_EXT_CTRLS,
-    VIDIOC_TRY_EXT_CTRLS
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-fbuf.rst b/Documentation/media/uapi/v4l/vidioc-g-fbuf.rst
index e7a6e14adb4f..00f783692752 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-fbuf.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-fbuf.rst
@@ -15,9 +15,11 @@ VIDIOC_G_FBUF - VIDIOC_S_FBUF - Get or set frame buffer overlay parameters
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_framebuffer *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_G_FBUF, struct v4l2_framebuffer *argp )
+    :name: VIDIOC_G_FBUF
 
-.. c:function:: int ioctl( int fd, int request, const struct v4l2_framebuffer *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_S_FBUF, const struct v4l2_framebuffer *argp )
+    :name: VIDIOC_S_FBUF
 
 
 Arguments
@@ -26,9 +28,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_G_FBUF, VIDIOC_S_FBUF
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-fmt.rst b/Documentation/media/uapi/v4l/vidioc-g-fmt.rst
index 46e5b4de10bc..ebeb7e9a48ea 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-fmt.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-fmt.rst
@@ -15,8 +15,14 @@ VIDIOC_G_FMT - VIDIOC_S_FMT - VIDIOC_TRY_FMT - Get or set the data format, try a
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_format *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_G_FMT, struct v4l2_format *argp )
+    :name: VIDIOC_G_FMT
 
+.. c:function:: int ioctl( int fd, VIDIOC_S_FMT, struct v4l2_format *argp )
+    :name: VIDIOC_S_FMT
+
+.. c:function:: int ioctl( int fd, VIDIOC_TRY_FMT, struct v4l2_format *argp )
+    :name: VIDIOC_TRY_FMT
 
 Arguments
 =========
@@ -24,9 +30,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_G_FMT, VIDIOC_S_FMT, VIDIOC_TRY_FMT
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-frequency.rst b/Documentation/media/uapi/v4l/vidioc-g-frequency.rst
index 0810aec0e7b7..d517c7bb2182 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-frequency.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-frequency.rst
@@ -15,9 +15,11 @@ VIDIOC_G_FREQUENCY - VIDIOC_S_FREQUENCY - Get or set tuner or modulator radio fr
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_frequency *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_G_FREQUENCY, struct v4l2_frequency *argp )
+    :name: VIDIOC_G_FREQUENCY
 
-.. c:function:: int ioctl( int fd, int request, const struct v4l2_frequency *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_S_FREQUENCY, const struct v4l2_frequency *argp )
+    :name: VIDIOC_S_FREQUENCY
 
 
 Arguments
@@ -26,9 +28,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_G_FREQUENCY, VIDIOC_S_FREQUENCY
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-input.rst b/Documentation/media/uapi/v4l/vidioc-g-input.rst
index de87712f0336..32735d20066c 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-input.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-input.rst
@@ -15,7 +15,11 @@ VIDIOC_G_INPUT - VIDIOC_S_INPUT - Query or select the current video input
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, int *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_G_INPUT, int *argp )
+    :name: VIDIOC_G_INPUT
+
+.. c:function:: int ioctl( int fd, VIDIOC_S_INPUT, int *argp )
+    :name: VIDIOC_S_INPUT
 
 
 Arguments
@@ -24,9 +28,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_G_INPUT, VIDIOC_S_INPUT
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst b/Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst
index 9800037b5ba0..387c71c209bc 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst
@@ -15,9 +15,11 @@ VIDIOC_G_JPEGCOMP - VIDIOC_S_JPEGCOMP
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, v4l2_jpegcompression *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_G_JPEGCOMP, v4l2_jpegcompression *argp )
+    :name: VIDIOC_G_JPEGCOMP
 
-.. c:function:: int ioctl( int fd, int request, const v4l2_jpegcompression *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_S_JPEGCOMP, const v4l2_jpegcompression *argp )
+    :name: VIDIOC_S_JPEGCOMP
 
 
 Arguments
@@ -26,9 +28,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_G_JPEGCOMP, VIDIOC_S_JPEGCOMP
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-modulator.rst b/Documentation/media/uapi/v4l/vidioc-g-modulator.rst
index 4f8d2babe79a..c7729e67e8d9 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-modulator.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-modulator.rst
@@ -15,9 +15,11 @@ VIDIOC_G_MODULATOR - VIDIOC_S_MODULATOR - Get or set modulator attributes
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_modulator *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_G_MODULATOR, struct v4l2_modulator *argp )
+    :name: VIDIOC_G_MODULATOR
 
-.. c:function:: int ioctl( int fd, int request, const struct v4l2_modulator *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_S_MODULATOR, const struct v4l2_modulator *argp )
+    :name: VIDIOC_S_MODULATOR
 
 
 Arguments
@@ -26,9 +28,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_G_MODULATOR, VIDIOC_S_MODULATOR
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-output.rst b/Documentation/media/uapi/v4l/vidioc-g-output.rst
index 1b7fffe7f075..e0613e2d667f 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-output.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-output.rst
@@ -15,7 +15,11 @@ VIDIOC_G_OUTPUT - VIDIOC_S_OUTPUT - Query or select the current video output
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, int *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_G_OUTPUT, int *argp )
+    :name: VIDIOC_G_OUTPUT
+
+.. c:function:: int ioctl( int fd, VIDIOC_S_OUTPUT, int *argp )
+    :name: VIDIOC_S_OUTPUT
 
 
 Arguments
@@ -24,9 +28,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_G_OUTPUT, VIDIOC_S_OUTPUT
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-parm.rst b/Documentation/media/uapi/v4l/vidioc-g-parm.rst
index 000109a0c86d..9e9af1dd4f29 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-parm.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-parm.rst
@@ -15,7 +15,11 @@ VIDIOC_G_PARM - VIDIOC_S_PARM - Get or set streaming parameters
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, v4l2_streamparm *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_G_PARM, v4l2_streamparm *argp )
+    :name: VIDIOC_G_PARM
+
+.. c:function:: int ioctl( int fd, VIDIOC_S_PARM, v4l2_streamparm *argp )
+    :name: VIDIOC_S_PARM
 
 
 Arguments
@@ -24,9 +28,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_G_PARM, VIDIOC_S_PARM
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-priority.rst b/Documentation/media/uapi/v4l/vidioc-g-priority.rst
index cafa7d099b86..d6a07c076837 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-priority.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-priority.rst
@@ -15,9 +15,11 @@ VIDIOC_G_PRIORITY - VIDIOC_S_PRIORITY - Query or request the access priority ass
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, enum v4l2_priority *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_G_PRIORITY, enum v4l2_priority *argp )
+    :name: VIDIOC_G_PRIORITY
 
-.. c:function:: int ioctl( int fd, int request, const enum v4l2_priority *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_S_PRIORITY, const enum v4l2_priority *argp )
+    :name: VIDIOC_S_PRIORITY
 
 
 Arguments
@@ -26,9 +28,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_G_PRIORITY, VIDIOC_S_PRIORITY
-
 ``argp``
     Pointer to an enum v4l2_priority type.
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-selection.rst b/Documentation/media/uapi/v4l/vidioc-g-selection.rst
index e01e92549032..34be08541ed8 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-selection.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-selection.rst
@@ -15,7 +15,12 @@ VIDIOC_G_SELECTION - VIDIOC_S_SELECTION - Get or set one of the selection rectan
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_selection *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_G_SELECTION, struct v4l2_selection *argp )
+    :name: VIDIOC_G_SELECTION
+
+
+.. c:function:: int ioctl( int fd, VIDIOC_S_SELECTION, struct v4l2_selection *argp )
+    :name: VIDIOC_S_SELECTION
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst b/Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst
index 62072ffc11e5..6913f125c4f8 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst
@@ -15,7 +15,8 @@ VIDIOC_G_SLICED_VBI_CAP - Query sliced VBI capabilities
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_sliced_vbi_cap *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_G_SLICED_VBI_CAP, struct v4l2_sliced_vbi_cap *argp )
+    :name: VIDIOC_G_SLICED_VBI_CAP
 
 
 Arguments
@@ -24,9 +25,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_G_SLICED_VBI_CAP
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-std.rst b/Documentation/media/uapi/v4l/vidioc-g-std.rst
index 4fd57e7ed0d1..91162f5ea6b2 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-std.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-std.rst
@@ -15,9 +15,11 @@ VIDIOC_G_STD - VIDIOC_S_STD - Query or select the video standard of the current
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, v4l2_std_id *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_G_STD, v4l2_std_id *argp )
+    :name: VIDIOC_G_STD
 
-.. c:function:: int ioctl( int fd, int request, const v4l2_std_id *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_S_STD, const v4l2_std_id *argp )
+    :name: VIDIOC_S_STD
 
 
 Arguments
@@ -26,9 +28,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_G_STD, VIDIOC_S_STD
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-tuner.rst b/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
index 30ff994e5618..333457fcdbe0 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
@@ -15,9 +15,11 @@ VIDIOC_G_TUNER - VIDIOC_S_TUNER - Get or set tuner attributes
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_tuner *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_G_TUNER, struct v4l2_tuner *argp )
+    :name: VIDIOC_G_TUNER
 
-.. c:function:: int ioctl( int fd, int request, const struct v4l2_tuner *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_S_TUNER, const struct v4l2_tuner *argp )
+    :name: VIDIOC_S_TUNER
 
 
 Arguments
@@ -26,9 +28,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_G_TUNER, VIDIOC_S_TUNER
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-log-status.rst b/Documentation/media/uapi/v4l/vidioc-log-status.rst
index 6cf7904dd34c..bbeb7b5f516b 100644
--- a/Documentation/media/uapi/v4l/vidioc-log-status.rst
+++ b/Documentation/media/uapi/v4l/vidioc-log-status.rst
@@ -15,12 +15,15 @@ VIDIOC_LOG_STATUS - Log driver status information
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request )
+.. c:function:: int ioctl( int fd, VIDIOC_LOG_STATUS)
+    :name: VIDIOC_LOG_STATUS
 
 
 Arguments
 =========
 
+``fd``
+    File descriptor returned by :ref:`open() <func-open>`.
 
 
 Description
diff --git a/Documentation/media/uapi/v4l/vidioc-overlay.rst b/Documentation/media/uapi/v4l/vidioc-overlay.rst
index e7a3956cba3d..cd7b62ebc53b 100644
--- a/Documentation/media/uapi/v4l/vidioc-overlay.rst
+++ b/Documentation/media/uapi/v4l/vidioc-overlay.rst
@@ -15,7 +15,8 @@ VIDIOC_OVERLAY - Start or stop video overlay
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, const int *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_OVERLAY, const int *argp )
+    :name: VIDIOC_OVERLAY
 
 
 Arguments
@@ -24,9 +25,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_OVERLAY
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-prepare-buf.rst b/Documentation/media/uapi/v4l/vidioc-prepare-buf.rst
index 0baa692edd33..c3f6c1c615f6 100644
--- a/Documentation/media/uapi/v4l/vidioc-prepare-buf.rst
+++ b/Documentation/media/uapi/v4l/vidioc-prepare-buf.rst
@@ -15,7 +15,8 @@ VIDIOC_PREPARE_BUF - Prepare a buffer for I/O
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_buffer *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_PREPARE_BUF, struct v4l2_buffer *argp )
+    :name: VIDIOC_PREPARE_BUF
 
 
 Arguments
@@ -24,9 +25,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_PREPARE_BUF
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-qbuf.rst b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
index ec5cb57d4acf..dd3f2e069fcb 100644
--- a/Documentation/media/uapi/v4l/vidioc-qbuf.rst
+++ b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
@@ -15,7 +15,11 @@ VIDIOC_QBUF - VIDIOC_DQBUF - Exchange a buffer with the driver
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_buffer *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_QBUF, struct v4l2_buffer *argp )
+    :name: VIDIOC_QBUF
+
+.. c:function:: int ioctl( int fd, VIDIOC_DQBUF, struct v4l2_buffer *argp )
+    :name: VIDIOC_DQBUF
 
 
 Arguments
@@ -24,9 +28,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_QBUF, VIDIOC_DQBUF
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-query-dv-timings.rst b/Documentation/media/uapi/v4l/vidioc-query-dv-timings.rst
index c262b0a0ef4a..230ebcb8aa4b 100644
--- a/Documentation/media/uapi/v4l/vidioc-query-dv-timings.rst
+++ b/Documentation/media/uapi/v4l/vidioc-query-dv-timings.rst
@@ -15,7 +15,11 @@ VIDIOC_QUERY_DV_TIMINGS - VIDIOC_SUBDEV_QUERY_DV_TIMINGS - Sense the DV preset r
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_dv_timings *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_QUERY_DV_TIMINGS, struct v4l2_dv_timings *argp )
+    :name: VIDIOC_QUERY_DV_TIMINGS
+
+.. c:function:: int ioctl( int fd, VIDIOC_SUBDEV_QUERY_DV_TIMINGS, struct v4l2_dv_timings *argp )
+    :name: VIDIOC_SUBDEV_QUERY_DV_TIMINGS
 
 
 Arguments
@@ -24,9 +28,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_QUERY_DV_TIMINGS, VIDIOC_SUBDEV_QUERY_DV_TIMINGS
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-querybuf.rst b/Documentation/media/uapi/v4l/vidioc-querybuf.rst
index f180c42883fa..8edfc7931ec6 100644
--- a/Documentation/media/uapi/v4l/vidioc-querybuf.rst
+++ b/Documentation/media/uapi/v4l/vidioc-querybuf.rst
@@ -15,7 +15,8 @@ VIDIOC_QUERYBUF - Query the status of a buffer
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_buffer *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_QUERYBUF, struct v4l2_buffer *argp )
+    :name: VIDIOC_QUERYBUF
 
 
 Arguments
@@ -24,9 +25,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_QUERYBUF
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-querycap.rst b/Documentation/media/uapi/v4l/vidioc-querycap.rst
index c821a6c77ab5..d627b80c4141 100644
--- a/Documentation/media/uapi/v4l/vidioc-querycap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-querycap.rst
@@ -15,7 +15,8 @@ VIDIOC_QUERYCAP - Query device capabilities
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_capability *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_QUERYCAP, struct v4l2_capability *argp )
+    :name: VIDIOC_QUERYCAP
 
 
 Arguments
@@ -24,9 +25,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_QUERYCAP
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
index 25c7c035cccc..5817264e11ca 100644
--- a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
+++ b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
@@ -15,11 +15,14 @@ VIDIOC_QUERYCTRL - VIDIOC_QUERY_EXT_CTRL - VIDIOC_QUERYMENU - Enumerate controls
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_queryctrl *argp )
+.. c:function:: int ioctl( int fd, int VIDIOC_QUERYCTRL, struct v4l2_queryctrl *argp )
+    :name: VIDIOC_QUERYCTRL
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_query_ext_ctrl *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_QUERY_EXT_CTRL, struct v4l2_query_ext_ctrl *argp )
+    :name: VIDIOC_QUERY_EXT_CTRL
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_querymenu *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_QUERYMENU, struct v4l2_querymenu *argp )
+    :name: VIDIOC_QUERYMENU
 
 
 Arguments
@@ -28,9 +31,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_QUERYCTRL, VIDIOC_QUERY_EXT_CTRL, VIDIOC_QUERYMENU
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-querystd.rst b/Documentation/media/uapi/v4l/vidioc-querystd.rst
index 9324659cebc6..3ef9ab37f582 100644
--- a/Documentation/media/uapi/v4l/vidioc-querystd.rst
+++ b/Documentation/media/uapi/v4l/vidioc-querystd.rst
@@ -15,7 +15,8 @@ VIDIOC_QUERYSTD - Sense the video standard received by the current input
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, v4l2_std_id *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_QUERYSTD, v4l2_std_id *argp )
+    :name: VIDIOC_QUERYSTD
 
 
 Arguments
@@ -24,9 +25,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_QUERYSTD
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-reqbufs.rst b/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
index 2078b0b00a9e..39c9bf8af47a 100644
--- a/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
+++ b/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
@@ -15,7 +15,8 @@ VIDIOC_REQBUFS - Initiate Memory Mapping, User Pointer I/O or DMA buffer I/O
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_requestbuffers *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_REQBUFS, struct v4l2_requestbuffers *argp )
+    :name: VIDIOC_REQBUFS
 
 
 Arguments
@@ -24,9 +25,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_REQBUFS
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-s-hw-freq-seek.rst b/Documentation/media/uapi/v4l/vidioc-s-hw-freq-seek.rst
index 765a8453103f..efbe3a1f1134 100644
--- a/Documentation/media/uapi/v4l/vidioc-s-hw-freq-seek.rst
+++ b/Documentation/media/uapi/v4l/vidioc-s-hw-freq-seek.rst
@@ -15,7 +15,8 @@ VIDIOC_S_HW_FREQ_SEEK - Perform a hardware frequency seek
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_hw_freq_seek *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_S_HW_FREQ_SEEK, struct v4l2_hw_freq_seek *argp )
+    :name: VIDIOC_S_HW_FREQ_SEEK
 
 
 Arguments
@@ -24,9 +25,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_S_HW_FREQ_SEEK
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-streamon.rst b/Documentation/media/uapi/v4l/vidioc-streamon.rst
index d27afa21b925..25dfaa44af3b 100644
--- a/Documentation/media/uapi/v4l/vidioc-streamon.rst
+++ b/Documentation/media/uapi/v4l/vidioc-streamon.rst
@@ -15,7 +15,11 @@ VIDIOC_STREAMON - VIDIOC_STREAMOFF - Start or stop streaming I/O
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, const int *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_STREAMON, const int *argp )
+    :name: VIDIOC_STREAMON
+
+.. c:function:: int ioctl( int fd, VIDIOC_STREAMOFF, const int *argp )
+    :name: VIDIOC_STREAMOFF
 
 
 Arguments
@@ -24,9 +28,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_STREAMON, VIDIOC_STREAMOFF
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst b/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst
index 290ba88eb208..3df2099ceeb9 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst
@@ -15,7 +15,8 @@ VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL - Enumerate frame intervals
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_subdev_frame_interval_enum * argp )
+.. c:function:: int ioctl( int fd, VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL, struct v4l2_subdev_frame_interval_enum * argp )
+    :name: VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL
 
 
 Arguments
@@ -24,9 +25,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-size.rst b/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-size.rst
index d26709184369..8d2694a96b7d 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-size.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-size.rst
@@ -15,7 +15,8 @@ VIDIOC_SUBDEV_ENUM_FRAME_SIZE - Enumerate media bus frame sizes
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_subdev_frame_size_enum * argp )
+.. c:function:: int ioctl( int fd, VIDIOC_SUBDEV_ENUM_FRAME_SIZE, struct v4l2_subdev_frame_size_enum * argp )
+    :name: VIDIOC_SUBDEV_ENUM_FRAME_SIZE
 
 
 Arguments
@@ -24,9 +25,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_SUBDEV_ENUM_FRAME_SIZE
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-enum-mbus-code.rst b/Documentation/media/uapi/v4l/vidioc-subdev-enum-mbus-code.rst
index a1dabf071437..5ecc33daba8b 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-enum-mbus-code.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-enum-mbus-code.rst
@@ -15,7 +15,8 @@ VIDIOC_SUBDEV_ENUM_MBUS_CODE - Enumerate media bus formats
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_subdev_mbus_code_enum * argp )
+.. c:function:: int ioctl( int fd, VIDIOC_SUBDEV_ENUM_MBUS_CODE, struct v4l2_subdev_mbus_code_enum * argp )
+    :name: VIDIOC_SUBDEV_ENUM_MBUS_CODE
 
 
 Arguments
@@ -24,9 +25,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_SUBDEV_ENUM_MBUS_CODE
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-g-crop.rst b/Documentation/media/uapi/v4l/vidioc-subdev-g-crop.rst
index c3e32c94937b..b0fb5203e65f 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-g-crop.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-g-crop.rst
@@ -15,9 +15,11 @@ VIDIOC_SUBDEV_G_CROP - VIDIOC_SUBDEV_S_CROP - Get or set the crop rectangle on a
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_subdev_crop *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_SUBDEV_G_CROP, struct v4l2_subdev_crop *argp )
+    :name: VIDIOC_SUBDEV_G_CROP
 
-.. c:function:: int ioctl( int fd, int request, const struct v4l2_subdev_crop *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_SUBDEV_S_CROP, const struct v4l2_subdev_crop *argp )
+    :name: VIDIOC_SUBDEV_S_CROP
 
 
 Arguments
@@ -26,9 +28,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_SUBDEV_G_CROP, VIDIOC_SUBDEV_S_CROP
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-g-fmt.rst b/Documentation/media/uapi/v4l/vidioc-subdev-g-fmt.rst
index 55b113de91bb..2df1342ac6ea 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-g-fmt.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-g-fmt.rst
@@ -15,7 +15,11 @@ VIDIOC_SUBDEV_G_FMT - VIDIOC_SUBDEV_S_FMT - Get or set the data format on a subd
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_subdev_format *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_SUBDEV_G_FMT, struct v4l2_subdev_format *argp )
+    :name: VIDIOC_SUBDEV_G_FMT
+
+.. c:function:: int ioctl( int fd, VIDIOC_SUBDEV_S_FMT, struct v4l2_subdev_format *argp )
+    :name: VIDIOC_SUBDEV_S_FMT
 
 
 Arguments
@@ -24,9 +28,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_SUBDEV_G_FMT, VIDIOC_SUBDEV_S_FMT
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-g-frame-interval.rst b/Documentation/media/uapi/v4l/vidioc-subdev-g-frame-interval.rst
index 056af63b9cfa..f8405bf344fa 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-g-frame-interval.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-g-frame-interval.rst
@@ -15,7 +15,11 @@ VIDIOC_SUBDEV_G_FRAME_INTERVAL - VIDIOC_SUBDEV_S_FRAME_INTERVAL - Get or set the
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_subdev_frame_interval *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_SUBDEV_G_FRAME_INTERVAL, struct v4l2_subdev_frame_interval *argp )
+    :name: VIDIOC_SUBDEV_G_FRAME_INTERVAL
+
+.. c:function:: int ioctl( int fd, VIDIOC_SUBDEV_S_FRAME_INTERVAL, struct v4l2_subdev_frame_interval *argp )
+    :name: VIDIOC_SUBDEV_S_FRAME_INTERVAL
 
 
 Arguments
@@ -24,10 +28,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_SUBDEV_G_FRAME_INTERVAL,
-    VIDIOC_SUBDEV_S_FRAME_INTERVAL
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-g-selection.rst b/Documentation/media/uapi/v4l/vidioc-subdev-g-selection.rst
index 5c1626a4feaf..697fc40434cc 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-g-selection.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-g-selection.rst
@@ -15,7 +15,11 @@ VIDIOC_SUBDEV_G_SELECTION - VIDIOC_SUBDEV_S_SELECTION - Get or set selection rec
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_subdev_selection *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_SUBDEV_G_SELECTION, struct v4l2_subdev_selection *argp )
+    :name: VIDIOC_SUBDEV_G_SELECTION
+
+.. c:function:: int ioctl( int fd, VIDIOC_SUBDEV_S_SELECTION, struct v4l2_subdev_selection *argp )
+    :name: VIDIOC_SUBDEV_S_SELECTION
 
 
 Arguments
@@ -24,9 +28,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_SUBDEV_G_SELECTION, VIDIOC_SUBDEV_S_SELECTION
-
 ``argp``
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-subscribe-event.rst b/Documentation/media/uapi/v4l/vidioc-subscribe-event.rst
index 7015bb283a6a..04eee095952b 100644
--- a/Documentation/media/uapi/v4l/vidioc-subscribe-event.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subscribe-event.rst
@@ -16,7 +16,11 @@ VIDIOC_SUBSCRIBE_EVENT - VIDIOC_UNSUBSCRIBE_EVENT - Subscribe or unsubscribe eve
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct v4l2_event_subscription *argp )
+.. c:function:: int ioctl( int fd, VIDIOC_SUBSCRIBE_EVENT, struct v4l2_event_subscription *argp )
+    :name: VIDIOC_SUBSCRIBE_EVENT
+
+.. c:function:: int ioctl( int fd, VIDIOC_UNSUBSCRIBE_EVENT, struct v4l2_event_subscription *argp )
+    :name: VIDIOC_UNSUBSCRIBE_EVENT
 
 
 Arguments
@@ -25,9 +29,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
-``request``
-    VIDIOC_SUBSCRIBE_EVENT, VIDIOC_UNSUBSCRIBE_EVENT
-
 ``argp``
 
 
-- 
2.7.4


