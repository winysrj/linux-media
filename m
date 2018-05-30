Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:36398 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751474AbeE3PHM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 May 2018 11:07:12 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 1/3] media: dvb/video.h: get rid of unused APIs
Date: Wed, 30 May 2018 12:07:03 -0300
Message-Id: <a0ab10ef59a28f8c8b35f4f647b55ac79d0c96d6.1527692791.git.mchehab+samsung@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are a number of other ioctls that aren't used anywhere
inside the Kernel tree.

Get rid of them.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 .../media/uapi/dvb/video-get-frame-rate.rst   |  61 ----------
 .../media/uapi/dvb/video-get-navi.rst         |  84 -------------
 .../media/uapi/dvb/video-set-attributes.rst   |  93 --------------
 .../media/uapi/dvb/video-set-highlight.rst    |  86 -------------
 Documentation/media/uapi/dvb/video-set-id.rst |  75 ------------
 .../media/uapi/dvb/video-set-spu.rst          |  85 -------------
 .../media/uapi/dvb/video-set-system.rst       |  77 ------------
 .../media/uapi/dvb/video_function_calls.rst   |   6 -
 Documentation/media/uapi/dvb/video_types.rst  | 113 ------------------
 Documentation/media/video.h.rst.exceptions    |   2 -
 fs/compat_ioctl.c                             |   6 -
 include/uapi/linux/dvb/video.h                |  51 --------
 12 files changed, 739 deletions(-)
 delete mode 100644 Documentation/media/uapi/dvb/video-get-frame-rate.rst
 delete mode 100644 Documentation/media/uapi/dvb/video-get-navi.rst
 delete mode 100644 Documentation/media/uapi/dvb/video-set-attributes.rst
 delete mode 100644 Documentation/media/uapi/dvb/video-set-highlight.rst
 delete mode 100644 Documentation/media/uapi/dvb/video-set-id.rst
 delete mode 100644 Documentation/media/uapi/dvb/video-set-spu.rst
 delete mode 100644 Documentation/media/uapi/dvb/video-set-system.rst

diff --git a/Documentation/media/uapi/dvb/video-get-frame-rate.rst b/Documentation/media/uapi/dvb/video-get-frame-rate.rst
deleted file mode 100644
index 400042a854cf..000000000000
--- a/Documentation/media/uapi/dvb/video-get-frame-rate.rst
+++ /dev/null
@@ -1,61 +0,0 @@
-.. -*- coding: utf-8; mode: rst -*-
-
-.. _VIDEO_GET_FRAME_RATE:
-
-====================
-VIDEO_GET_FRAME_RATE
-====================
-
-Name
-----
-
-VIDEO_GET_FRAME_RATE
-
-.. attention:: This ioctl is deprecated.
-
-Synopsis
---------
-
-.. c:function:: int ioctl(int fd, VIDEO_GET_FRAME_RATE, unsigned int *rate)
-    :name: VIDEO_GET_FRAME_RATE
-
-
-Arguments
----------
-
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
-
-
-    -  .. row 1
-
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals VIDEO_GET_FRAME_RATE for this command.
-
-    -  .. row 3
-
-       -  unsigned int \*rate
-
-       -  Returns the framerate in number of frames per 1000 seconds.
-
-
-Description
------------
-
-This ioctl call asks the Video Device to return the current framerate.
-
-
-Return Value
-------------
-
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
-:ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/dvb/video-get-navi.rst b/Documentation/media/uapi/dvb/video-get-navi.rst
deleted file mode 100644
index 114a9ac48b9e..000000000000
--- a/Documentation/media/uapi/dvb/video-get-navi.rst
+++ /dev/null
@@ -1,84 +0,0 @@
-.. -*- coding: utf-8; mode: rst -*-
-
-.. _VIDEO_GET_NAVI:
-
-==============
-VIDEO_GET_NAVI
-==============
-
-Name
-----
-
-VIDEO_GET_NAVI
-
-.. attention:: This ioctl is deprecated.
-
-Synopsis
---------
-
-.. c:function:: int ioctl(fd, VIDEO_GET_NAVI , struct video_navi_pack *navipack)
-    :name: VIDEO_GET_NAVI
-
-
-Arguments
----------
-
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
-
-
-    -  .. row 1
-
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals VIDEO_GET_NAVI for this command.
-
-    -  .. row 3
-
-       -  video_navi_pack_t \*navipack
-
-       -  PCI or DSI pack (private stream 2) according to section ??.
-
-
-Description
------------
-
-This ioctl returns navigational information from the DVD stream. This is
-especially needed if an encoded stream has to be decoded by the
-hardware.
-
-.. c:type:: video_navi_pack
-
-.. code-block::c
-
-	typedef struct video_navi_pack {
-		int length;          /* 0 ... 1024 */
-		__u8 data[1024];
-	} video_navi_pack_t;
-
-Return Value
-------------
-
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
-:ref:`Generic Error Codes <gen-errors>` chapter.
-
-
-
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
-
-
-    -  .. row 1
-
-       -  ``EFAULT``
-
-       -  driver is not able to return navigational information
diff --git a/Documentation/media/uapi/dvb/video-set-attributes.rst b/Documentation/media/uapi/dvb/video-set-attributes.rst
deleted file mode 100644
index b2f11a6746e9..000000000000
--- a/Documentation/media/uapi/dvb/video-set-attributes.rst
+++ /dev/null
@@ -1,93 +0,0 @@
-.. -*- coding: utf-8; mode: rst -*-
-
-.. _VIDEO_SET_ATTRIBUTES:
-
-====================
-VIDEO_SET_ATTRIBUTES
-====================
-
-Name
-----
-
-VIDEO_SET_ATTRIBUTES
-
-.. attention:: This ioctl is deprecated.
-
-Synopsis
---------
-
-.. c:function:: int ioctl(fd, VIDEO_SET_ATTRIBUTE ,video_attributes_t vattr)
-    :name: VIDEO_SET_ATTRIBUTE
-
-
-Arguments
----------
-
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
-
-
-    -  .. row 1
-
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals VIDEO_SET_ATTRIBUTE for this command.
-
-    -  .. row 3
-
-       -  video_attributes_t vattr
-
-       -  video attributes according to section ??.
-
-
-Description
------------
-
-This ioctl is intended for DVD playback and allows you to set certain
-information about the stream. Some hardware may not need this
-information, but the call also tells the hardware to prepare for DVD
-playback.
-
-.. c:type:: video_attributes_t
-
-.. code-block::c
-
-	typedef __u16 video_attributes_t;
-	/*   bits: descr. */
-	/*   15-14 Video compression mode (0=MPEG-1, 1=MPEG-2) */
-	/*   13-12 TV system (0=525/60, 1=625/50) */
-	/*   11-10 Aspect ratio (0=4:3, 3=16:9) */
-	/*    9- 8 permitted display mode on 4:3 monitor (0=both, 1=only pan-sca */
-	/*    7    line 21-1 data present in GOP (1=yes, 0=no) */
-	/*    6    line 21-2 data present in GOP (1=yes, 0=no) */
-	/*    5- 3 source resolution (0=720x480/576, 1=704x480/576, 2=352x480/57 */
-	/*    2    source letterboxed (1=yes, 0=no) */
-	/*    0    film/camera mode (0=camera, 1=film (625/50 only)) */
-
-
-Return Value
-------------
-
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
-:ref:`Generic Error Codes <gen-errors>` chapter.
-
-
-
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
-
-
-    -  .. row 1
-
-       -  ``EINVAL``
-
-       -  input is not a valid attribute setting.
diff --git a/Documentation/media/uapi/dvb/video-set-highlight.rst b/Documentation/media/uapi/dvb/video-set-highlight.rst
deleted file mode 100644
index 90aeafd923b7..000000000000
--- a/Documentation/media/uapi/dvb/video-set-highlight.rst
+++ /dev/null
@@ -1,86 +0,0 @@
-.. -*- coding: utf-8; mode: rst -*-
-
-.. _VIDEO_SET_HIGHLIGHT:
-
-===================
-VIDEO_SET_HIGHLIGHT
-===================
-
-Name
-----
-
-VIDEO_SET_HIGHLIGHT
-
-.. attention:: This ioctl is deprecated.
-
-Synopsis
---------
-
-.. c:function:: int ioctl(fd, VIDEO_SET_HIGHLIGHT, struct video_highlight *vhilite)
-    :name: VIDEO_SET_HIGHLIGHT
-
-
-Arguments
----------
-
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
-
-
-    -  .. row 1
-
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals VIDEO_SET_HIGHLIGHT for this command.
-
-    -  .. row 3
-
-       -  video_highlight_t \*vhilite
-
-       -  SPU Highlight information according to section ??.
-
-
-Description
------------
-
-This ioctl sets the SPU highlight information for the menu access of a
-DVD.
-
-.. c:type:: video_highlight
-
-.. code-block:: c
-
-	typedef
-	struct video_highlight {
-		int     active;      /*    1=show highlight, 0=hide highlight */
-		__u8    contrast1;   /*    7- 4  Pattern pixel contrast */
-				/*    3- 0  Background pixel contrast */
-		__u8    contrast2;   /*    7- 4  Emphasis pixel-2 contrast */
-				/*    3- 0  Emphasis pixel-1 contrast */
-		__u8    color1;      /*    7- 4  Pattern pixel color */
-				/*    3- 0  Background pixel color */
-		__u8    color2;      /*    7- 4  Emphasis pixel-2 color */
-				/*    3- 0  Emphasis pixel-1 color */
-		__u32    ypos;       /*   23-22  auto action mode */
-				/*   21-12  start y */
-				/*    9- 0  end y */
-		__u32    xpos;       /*   23-22  button color number */
-				/*   21-12  start x */
-				/*    9- 0  end x */
-	} video_highlight_t;
-
-
-
-Return Value
-------------
-
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
-:ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/dvb/video-set-id.rst b/Documentation/media/uapi/dvb/video-set-id.rst
deleted file mode 100644
index 18f66875ae3f..000000000000
--- a/Documentation/media/uapi/dvb/video-set-id.rst
+++ /dev/null
@@ -1,75 +0,0 @@
-.. -*- coding: utf-8; mode: rst -*-
-
-.. _VIDEO_SET_ID:
-
-============
-VIDEO_SET_ID
-============
-
-Name
-----
-
-VIDEO_SET_ID
-
-.. attention:: This ioctl is deprecated.
-
-Synopsis
---------
-
-.. c:function:: int ioctl(int fd, VIDEO_SET_ID, int id)
-    :name: VIDEO_SET_ID
-
-
-Arguments
----------
-
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
-
-
-    -  .. row 1
-
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals VIDEO_SET_ID for this command.
-
-    -  .. row 3
-
-       -  int id
-
-       -  video sub-stream id
-
-
-Description
------------
-
-This ioctl selects which sub-stream is to be decoded if a program or
-system stream is sent to the video device.
-
-
-Return Value
-------------
-
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
-:ref:`Generic Error Codes <gen-errors>` chapter.
-
-
-
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
-
-
-    -  .. row 1
-
-       -  ``EINVAL``
-
-       -  Invalid sub-stream id.
diff --git a/Documentation/media/uapi/dvb/video-set-spu.rst b/Documentation/media/uapi/dvb/video-set-spu.rst
deleted file mode 100644
index 739e5e7bd133..000000000000
--- a/Documentation/media/uapi/dvb/video-set-spu.rst
+++ /dev/null
@@ -1,85 +0,0 @@
-.. -*- coding: utf-8; mode: rst -*-
-
-.. _VIDEO_SET_SPU:
-
-=============
-VIDEO_SET_SPU
-=============
-
-Name
-----
-
-VIDEO_SET_SPU
-
-.. attention:: This ioctl is deprecated.
-
-Synopsis
---------
-
-.. c:function:: int ioctl(fd, VIDEO_SET_SPU , struct video_spu *spu)
-    :name: VIDEO_SET_SPU
-
-
-Arguments
----------
-
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
-
-
-    -  .. row 1
-
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals VIDEO_SET_SPU for this command.
-
-    -  .. row 3
-
-       -  video_spu_t \*spu
-
-       -  SPU decoding (de)activation and subid setting according to section
-	  ??.
-
-
-Description
------------
-
-This ioctl activates or deactivates SPU decoding in a DVD input stream.
-It can only be used, if the driver is able to handle a DVD stream.
-
-.. c:type:: struct video_spu
-
-.. code-block:: c
-
-	typedef struct video_spu {
-		int active;
-		int stream_id;
-	} video_spu_t;
-
-
-Return Value
-------------
-
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
-:ref:`Generic Error Codes <gen-errors>` chapter.
-
-
-
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
-
-
-    -  .. row 1
-
-       -  ``EINVAL``
-
-       -  input is not a valid spu setting or driver cannot handle SPU.
diff --git a/Documentation/media/uapi/dvb/video-set-system.rst b/Documentation/media/uapi/dvb/video-set-system.rst
deleted file mode 100644
index e39cbe080ef7..000000000000
--- a/Documentation/media/uapi/dvb/video-set-system.rst
+++ /dev/null
@@ -1,77 +0,0 @@
-.. -*- coding: utf-8; mode: rst -*-
-
-.. _VIDEO_SET_SYSTEM:
-
-================
-VIDEO_SET_SYSTEM
-================
-
-Name
-----
-
-VIDEO_SET_SYSTEM
-
-.. attention:: This ioctl is deprecated.
-
-Synopsis
---------
-
-.. c:function:: int ioctl(fd, VIDEO_SET_SYSTEM , video_system_t system)
-    :name: VIDEO_SET_SYSTEM
-
-
-Arguments
----------
-
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
-
-
-    -  .. row 1
-
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals VIDEO_SET_FORMAT for this command.
-
-    -  .. row 3
-
-       -  video_system_t system
-
-       -  video system of TV output.
-
-
-Description
------------
-
-This ioctl sets the television output format. The format (see section
-??) may vary from the color format of the displayed MPEG stream. If the
-hardware is not able to display the requested format the call will
-return an error.
-
-
-Return Value
-------------
-
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
-:ref:`Generic Error Codes <gen-errors>` chapter.
-
-
-
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
-
-
-    -  .. row 1
-
-       -  ``EINVAL``
-
-       -  system is not a valid or supported video system.
diff --git a/Documentation/media/uapi/dvb/video_function_calls.rst b/Documentation/media/uapi/dvb/video_function_calls.rst
index 8d8383ffaeba..3f4f6c9ffad7 100644
--- a/Documentation/media/uapi/dvb/video_function_calls.rst
+++ b/Documentation/media/uapi/dvb/video_function_calls.rst
@@ -21,7 +21,6 @@ Video Function Calls
     video-get-status
     video-get-frame-count
     video-get-pts
-    video-get-frame-rate
     video-get-event
     video-command
     video-try-command
@@ -31,12 +30,7 @@ Video Function Calls
     video-fast-forward
     video-slowmotion
     video-get-capabilities
-    video-set-id
     video-clear-buffer
     video-set-streamtype
     video-set-format
-    video-set-system
-    video-set-highlight
-    video-set-spu
-    video-get-navi
     video-set-attributes
diff --git a/Documentation/media/uapi/dvb/video_types.rst b/Documentation/media/uapi/dvb/video_types.rst
index 4cfa00e5c934..a0942171596c 100644
--- a/Documentation/media/uapi/dvb/video_types.rst
+++ b/Documentation/media/uapi/dvb/video_types.rst
@@ -246,116 +246,3 @@ following bits set according to the hardwares capabilities.
      #define VIDEO_CAP_SPU    16
      #define VIDEO_CAP_NAVI   32
      #define VIDEO_CAP_CSS    64
-
-
-.. _video-system:
-
-video_system_t
-==============
-
-A call to VIDEO_SET_SYSTEM sets the desired video system for TV
-output. The following system types can be set:
-
-
-.. code-block:: c
-
-    typedef enum {
-	 VIDEO_SYSTEM_PAL,
-	 VIDEO_SYSTEM_NTSC,
-	 VIDEO_SYSTEM_PALN,
-	 VIDEO_SYSTEM_PALNc,
-	 VIDEO_SYSTEM_PALM,
-	 VIDEO_SYSTEM_NTSC60,
-	 VIDEO_SYSTEM_PAL60,
-	 VIDEO_SYSTEM_PALM60
-    } video_system_t;
-
-
-.. c:type:: video_highlight
-
-struct video_highlight
-======================
-
-Calling the ioctl VIDEO_SET_HIGHLIGHTS posts the SPU highlight
-information. The call expects the following format for that information:
-
-
-.. code-block:: c
-
-     typedef
-     struct video_highlight {
-	 boolean active;      /*    1=show highlight, 0=hide highlight */
-	 uint8_t contrast1;   /*    7- 4  Pattern pixel contrast */
-		      /*    3- 0  Background pixel contrast */
-	 uint8_t contrast2;   /*    7- 4  Emphasis pixel-2 contrast */
-		      /*    3- 0  Emphasis pixel-1 contrast */
-	 uint8_t color1;      /*    7- 4  Pattern pixel color */
-		      /*    3- 0  Background pixel color */
-	 uint8_t color2;      /*    7- 4  Emphasis pixel-2 color */
-		      /*    3- 0  Emphasis pixel-1 color */
-	 uint32_t ypos;       /*   23-22  auto action mode */
-		      /*   21-12  start y */
-		      /*    9- 0  end y */
-	 uint32_t xpos;       /*   23-22  button color number */
-		      /*   21-12  start x */
-		      /*    9- 0  end x */
-     } video_highlight_t;
-
-
-.. c:type:: video_spu
-
-struct video_spu
-================
-
-Calling VIDEO_SET_SPU deactivates or activates SPU decoding, according
-to the following format:
-
-
-.. code-block:: c
-
-     typedef
-     struct video_spu {
-	 boolean active;
-	 int stream_id;
-     } video_spu_t;
-
-
-.. c:type:: video_navi_pack
-
-struct video_navi_pack
-======================
-
-In order to get the navigational data the following structure has to be
-passed to the ioctl VIDEO_GET_NAVI:
-
-
-.. code-block:: c
-
-     typedef
-     struct video_navi_pack {
-	 int length;         /* 0 ... 1024 */
-	 uint8_t data[1024];
-     } video_navi_pack_t;
-
-
-.. _video-attributes-t:
-
-video_attributes_t
-==================
-
-The following attributes can be set by a call to VIDEO_SET_ATTRIBUTES:
-
-
-.. code-block:: c
-
-     typedef uint16_t video_attributes_t;
-     /*   bits: descr. */
-     /*   15-14 Video compression mode (0=MPEG-1, 1=MPEG-2) */
-     /*   13-12 TV system (0=525/60, 1=625/50) */
-     /*   11-10 Aspect ratio (0=4:3, 3=16:9) */
-     /*    9- 8 permitted display mode on 4:3 monitor (0=both, 1=only pan-sca */
-     /*    7    line 21-1 data present in GOP (1=yes, 0=no) */
-     /*    6    line 21-2 data present in GOP (1=yes, 0=no) */
-     /*    5- 3 source resolution (0=720x480/576, 1=704x480/576, 2=352x480/57 */
-     /*    2    source letterboxed (1=yes, 0=no) */
-     /*    0    film/camera mode (0=camera, 1=film (625/50 only)) */
diff --git a/Documentation/media/video.h.rst.exceptions b/Documentation/media/video.h.rst.exceptions
index 89d7c3ef2da7..371cdbd7d062 100644
--- a/Documentation/media/video.h.rst.exceptions
+++ b/Documentation/media/video.h.rst.exceptions
@@ -34,6 +34,4 @@ replace typedef video_displayformat_t :c:type:`video_displayformat`
 replace typedef video_size_t :c:type:`video_size`
 replace typedef video_stream_source_t :c:type:`video_stream_source`
 replace typedef video_play_state_t :c:type:`video_play_state`
-replace typedef video_highlight_t :c:type:`video_highlight`
-replace typedef video_spu_t :c:type:`video_spu`
 replace typedef video_navi_pack_t :c:type:`video_navi_pack`
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 6c36b931ca90..1aae4551f59f 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -1207,16 +1207,10 @@ COMPATIBLE_IOCTL(VIDEO_FAST_FORWARD)
 COMPATIBLE_IOCTL(VIDEO_SLOWMOTION)
 COMPATIBLE_IOCTL(VIDEO_GET_CAPABILITIES)
 COMPATIBLE_IOCTL(VIDEO_CLEAR_BUFFER)
-COMPATIBLE_IOCTL(VIDEO_SET_ID)
 COMPATIBLE_IOCTL(VIDEO_SET_STREAMTYPE)
 COMPATIBLE_IOCTL(VIDEO_SET_FORMAT)
-COMPATIBLE_IOCTL(VIDEO_SET_SYSTEM)
 COMPATIBLE_IOCTL(VIDEO_SET_HIGHLIGHT)
-COMPATIBLE_IOCTL(VIDEO_SET_SPU)
-COMPATIBLE_IOCTL(VIDEO_GET_NAVI)
-COMPATIBLE_IOCTL(VIDEO_SET_ATTRIBUTES)
 COMPATIBLE_IOCTL(VIDEO_GET_SIZE)
-COMPATIBLE_IOCTL(VIDEO_GET_FRAME_RATE)
 /* cec */
 COMPATIBLE_IOCTL(CEC_ADAP_G_CAPS)
 COMPATIBLE_IOCTL(CEC_ADAP_G_LOG_ADDRS)
diff --git a/include/uapi/linux/dvb/video.h b/include/uapi/linux/dvb/video.h
index 6a0c9757b7ba..43ba8b0a3d14 100644
--- a/include/uapi/linux/dvb/video.h
+++ b/include/uapi/linux/dvb/video.h
@@ -37,18 +37,6 @@ typedef enum {
 } video_format_t;
 
 
-typedef enum {
-	 VIDEO_SYSTEM_PAL,
-	 VIDEO_SYSTEM_NTSC,
-	 VIDEO_SYSTEM_PALN,
-	 VIDEO_SYSTEM_PALNc,
-	 VIDEO_SYSTEM_PALM,
-	 VIDEO_SYSTEM_NTSC60,
-	 VIDEO_SYSTEM_PAL60,
-	 VIDEO_SYSTEM_PALM60
-} video_system_t;
-
-
 typedef enum {
 	VIDEO_PAN_SCAN,       /* use pan and scan format */
 	VIDEO_LETTER_BOX,     /* use letterbox format */
@@ -160,38 +148,6 @@ struct video_still_picture {
 };
 
 
-typedef
-struct video_highlight {
-	int     active;      /*    1=show highlight, 0=hide highlight */
-	__u8    contrast1;   /*    7- 4  Pattern pixel contrast */
-			     /*    3- 0  Background pixel contrast */
-	__u8    contrast2;   /*    7- 4  Emphasis pixel-2 contrast */
-			     /*    3- 0  Emphasis pixel-1 contrast */
-	__u8    color1;      /*    7- 4  Pattern pixel color */
-			     /*    3- 0  Background pixel color */
-	__u8    color2;      /*    7- 4  Emphasis pixel-2 color */
-			     /*    3- 0  Emphasis pixel-1 color */
-	__u32    ypos;       /*   23-22  auto action mode */
-			     /*   21-12  start y */
-			     /*    9- 0  end y */
-	__u32    xpos;       /*   23-22  button color number */
-			     /*   21-12  start x */
-			     /*    9- 0  end x */
-} video_highlight_t;
-
-
-typedef struct video_spu {
-	int active;
-	int stream_id;
-} video_spu_t;
-
-
-typedef struct video_navi_pack {
-	int length;          /* 0 ... 1024 */
-	__u8 data[1024];
-} video_navi_pack_t;
-
-
 typedef __u16 video_attributes_t;
 /*   bits: descr. */
 /*   15-14 Video compression mode (0=MPEG-1, 1=MPEG-2) */
@@ -236,16 +192,9 @@ typedef __u16 video_attributes_t;
 #define VIDEO_SLOWMOTION           _IO('o', 32)
 #define VIDEO_GET_CAPABILITIES     _IOR('o', 33, unsigned int)
 #define VIDEO_CLEAR_BUFFER         _IO('o',  34)
-#define VIDEO_SET_ID               _IO('o', 35)
 #define VIDEO_SET_STREAMTYPE       _IO('o', 36)
 #define VIDEO_SET_FORMAT           _IO('o', 37)
-#define VIDEO_SET_SYSTEM           _IO('o', 38)
-#define VIDEO_SET_HIGHLIGHT        _IOW('o', 39, video_highlight_t)
-#define VIDEO_SET_SPU              _IOW('o', 50, video_spu_t)
-#define VIDEO_GET_NAVI             _IOR('o', 52, video_navi_pack_t)
-#define VIDEO_SET_ATTRIBUTES       _IO('o', 53)
 #define VIDEO_GET_SIZE             _IOR('o', 55, video_size_t)
-#define VIDEO_GET_FRAME_RATE       _IOR('o', 56, unsigned int)
 
 /**
  * VIDEO_GET_PTS
-- 
2.17.0
