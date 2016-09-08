Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44062 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965624AbcIHMEX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 08:04:23 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>
Subject: [PATCH 34/47] [media] fix broken references on dvb/video*rst
Date: Thu,  8 Sep 2016 09:03:56 -0300
Message-Id: <fe75f2a35ba0a1f1782a7dfc07fc11522f4482d8.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Trivially fix those broken references, by copying the structs
fron the header, just like other API documentation at the
DVB side.

This doesn't have the level of quality used at the V4L2 side
of the API, but, as this documents a deprecated API, used
only by av7110 driver, it doesn't make much sense to invest
time making it better.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/dvb/video-command.rst     | 30 ++++++++++++++++++++++
 Documentation/media/uapi/dvb/video-get-event.rst   | 17 ++++++++++++
 Documentation/media/uapi/dvb/video-get-navi.rst    | 10 +++++++-
 Documentation/media/uapi/dvb/video-get-size.rst    | 10 ++++++++
 Documentation/media/uapi/dvb/video-get-status.rst  | 11 ++++++++
 .../media/uapi/dvb/video-select-source.rst         | 10 ++++++++
 .../media/uapi/dvb/video-set-attributes.rst        | 16 ++++++++++++
 .../media/uapi/dvb/video-set-display-format.rst    |  2 +-
 Documentation/media/uapi/dvb/video-set-format.rst  |  9 +++++++
 .../media/uapi/dvb/video-set-highlight.rst         | 26 ++++++++++++++++++-
 .../media/uapi/dvb/video-set-spu-palette.rst       | 10 +++++++-
 Documentation/media/uapi/dvb/video-set-spu.rst     | 11 +++++++-
 include/uapi/linux/dvb/video.h                     |  3 ++-
 13 files changed, 159 insertions(+), 6 deletions(-)

diff --git a/Documentation/media/uapi/dvb/video-command.rst b/Documentation/media/uapi/dvb/video-command.rst
index 4772562036f1..536d0fdd8399 100644
--- a/Documentation/media/uapi/dvb/video-command.rst
+++ b/Documentation/media/uapi/dvb/video-command.rst
@@ -59,6 +59,36 @@ subset of the ``v4l2_decoder_cmd`` struct, so refer to the
 :ref:`VIDIOC_DECODER_CMD` documentation for
 more information.
 
+.. c:type:: struct video_command
+
+.. code-block:: c
+
+	/* The structure must be zeroed before use by the application
+	This ensures it can be extended safely in the future. */
+	struct video_command {
+		__u32 cmd;
+		__u32 flags;
+		union {
+			struct {
+				__u64 pts;
+			} stop;
+
+			struct {
+				/* 0 or 1000 specifies normal speed,
+				1 specifies forward single stepping,
+				-1 specifies backward single stepping,
+				>1: playback at speed/1000 of the normal speed,
+				<-1: reverse playback at (-speed/1000) of the normal speed. */
+				__s32 speed;
+				__u32 format;
+			} play;
+
+			struct {
+				__u32 data[16];
+			} raw;
+		};
+	};
+
 
 Return Value
 ------------
diff --git a/Documentation/media/uapi/dvb/video-get-event.rst b/Documentation/media/uapi/dvb/video-get-event.rst
index 8c0c622c380b..6ad14cdb894a 100644
--- a/Documentation/media/uapi/dvb/video-get-event.rst
+++ b/Documentation/media/uapi/dvb/video-get-event.rst
@@ -64,6 +64,23 @@ included in the exceptfds argument, and for poll(), POLLPRI should be
 specified as the wake-up condition. Read-only permissions are sufficient
 for this ioctl call.
 
+.. c:type:: video_event
+
+.. code-block:: c
+
+	struct video_event {
+		__s32 type;
+	#define VIDEO_EVENT_SIZE_CHANGED	1
+	#define VIDEO_EVENT_FRAME_RATE_CHANGED	2
+	#define VIDEO_EVENT_DECODER_STOPPED 	3
+	#define VIDEO_EVENT_VSYNC 		4
+		__kernel_time_t timestamp;
+		union {
+			video_size_t size;
+			unsigned int frame_rate;	/* in frames per 1000sec */
+			unsigned char vsync_field;	/* unknown/odd/even/progressive */
+		} u;
+	};
 
 Return Value
 ------------
diff --git a/Documentation/media/uapi/dvb/video-get-navi.rst b/Documentation/media/uapi/dvb/video-get-navi.rst
index b8de9ccf38c2..114a9ac48b9e 100644
--- a/Documentation/media/uapi/dvb/video-get-navi.rst
+++ b/Documentation/media/uapi/dvb/video-get-navi.rst
@@ -16,7 +16,7 @@ VIDEO_GET_NAVI
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, VIDEO_GET_NAVI , video_navi_pack_t *navipack)
+.. c:function:: int ioctl(fd, VIDEO_GET_NAVI , struct video_navi_pack *navipack)
     :name: VIDEO_GET_NAVI
 
 
@@ -54,6 +54,14 @@ This ioctl returns navigational information from the DVD stream. This is
 especially needed if an encoded stream has to be decoded by the
 hardware.
 
+.. c:type:: video_navi_pack
+
+.. code-block::c
+
+	typedef struct video_navi_pack {
+		int length;          /* 0 ... 1024 */
+		__u8 data[1024];
+	} video_navi_pack_t;
 
 Return Value
 ------------
diff --git a/Documentation/media/uapi/dvb/video-get-size.rst b/Documentation/media/uapi/dvb/video-get-size.rst
index ce8b4c6b41a5..d077fe2305a0 100644
--- a/Documentation/media/uapi/dvb/video-get-size.rst
+++ b/Documentation/media/uapi/dvb/video-get-size.rst
@@ -52,6 +52,16 @@ Description
 
 This ioctl returns the size and aspect ratio.
 
+.. c:type:: video_size_t
+
+.. code-block::c
+
+	typedef struct {
+		int w;
+		int h;
+		video_format_t aspect_ratio;
+	} video_size_t;
+
 
 Return Value
 ------------
diff --git a/Documentation/media/uapi/dvb/video-get-status.rst b/Documentation/media/uapi/dvb/video-get-status.rst
index 7b6a278b5246..ed6ea19827a6 100644
--- a/Documentation/media/uapi/dvb/video-get-status.rst
+++ b/Documentation/media/uapi/dvb/video-get-status.rst
@@ -53,6 +53,17 @@ Description
 This ioctl call asks the Video Device to return the current status of
 the device.
 
+.. c:type:: video_status
+
+.. code-block:: c
+
+	struct video_status {
+		int                   video_blank;   /* blank video on freeze? */
+		video_play_state_t    play_state;    /* current state of playback */
+		video_stream_source_t stream_source; /* current source (demux/memory) */
+		video_format_t        video_format;  /* current aspect ratio of stream*/
+		video_displayformat_t display_format;/* selected cropping mode */
+	};
 
 Return Value
 ------------
diff --git a/Documentation/media/uapi/dvb/video-select-source.rst b/Documentation/media/uapi/dvb/video-select-source.rst
index eaa1088f07da..2f4fbf4b490c 100644
--- a/Documentation/media/uapi/dvb/video-select-source.rst
+++ b/Documentation/media/uapi/dvb/video-select-source.rst
@@ -58,6 +58,16 @@ This ioctl call informs the video device which source shall be used for
 the input data. The possible sources are demux or memory. If memory is
 selected, the data is fed to the video device through the write command.
 
+.. c:type:: video_stream_source_t
+
+.. code-block:: c
+
+	typedef enum {
+		VIDEO_SOURCE_DEMUX, /* Select the demux as the main source */
+		VIDEO_SOURCE_MEMORY /* If this source is selected, the stream
+				comes from the user through the write
+				system call */
+	} video_stream_source_t;
 
 Return Value
 ------------
diff --git a/Documentation/media/uapi/dvb/video-set-attributes.rst b/Documentation/media/uapi/dvb/video-set-attributes.rst
index 8901520d7e43..b2f11a6746e9 100644
--- a/Documentation/media/uapi/dvb/video-set-attributes.rst
+++ b/Documentation/media/uapi/dvb/video-set-attributes.rst
@@ -55,6 +55,22 @@ information about the stream. Some hardware may not need this
 information, but the call also tells the hardware to prepare for DVD
 playback.
 
+.. c:type:: video_attributes_t
+
+.. code-block::c
+
+	typedef __u16 video_attributes_t;
+	/*   bits: descr. */
+	/*   15-14 Video compression mode (0=MPEG-1, 1=MPEG-2) */
+	/*   13-12 TV system (0=525/60, 1=625/50) */
+	/*   11-10 Aspect ratio (0=4:3, 3=16:9) */
+	/*    9- 8 permitted display mode on 4:3 monitor (0=both, 1=only pan-sca */
+	/*    7    line 21-1 data present in GOP (1=yes, 0=no) */
+	/*    6    line 21-2 data present in GOP (1=yes, 0=no) */
+	/*    5- 3 source resolution (0=720x480/576, 1=704x480/576, 2=352x480/57 */
+	/*    2    source letterboxed (1=yes, 0=no) */
+	/*    0    film/camera mode (0=camera, 1=film (625/50 only)) */
+
 
 Return Value
 ------------
diff --git a/Documentation/media/uapi/dvb/video-set-display-format.rst b/Documentation/media/uapi/dvb/video-set-display-format.rst
index 6abf19479939..2ef7401781be 100644
--- a/Documentation/media/uapi/dvb/video-set-display-format.rst
+++ b/Documentation/media/uapi/dvb/video-set-display-format.rst
@@ -16,7 +16,7 @@ VIDEO_SET_DISPLAY_FORMAT
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, VIDEO_SET_DISPLAY_FORMAT, video_display_format_t format)
+.. c:function:: int ioctl(fd, VIDEO_SET_DISPLAY_FORMAT)
     :name: VIDEO_SET_DISPLAY_FORMAT
 
 
diff --git a/Documentation/media/uapi/dvb/video-set-format.rst b/Documentation/media/uapi/dvb/video-set-format.rst
index 117618525538..4239a4e365bb 100644
--- a/Documentation/media/uapi/dvb/video-set-format.rst
+++ b/Documentation/media/uapi/dvb/video-set-format.rst
@@ -54,6 +54,15 @@ This ioctl sets the screen format (aspect ratio) of the connected output
 device (TV) so that the output of the decoder can be adjusted
 accordingly.
 
+.. c:type:: video_format_t
+
+.. code-block:: c
+
+	typedef enum {
+		VIDEO_FORMAT_4_3,     /* Select 4:3 format */
+		VIDEO_FORMAT_16_9,    /* Select 16:9 format. */
+		VIDEO_FORMAT_221_1    /* 2.21:1 */
+	} video_format_t;
 
 Return Value
 ------------
diff --git a/Documentation/media/uapi/dvb/video-set-highlight.rst b/Documentation/media/uapi/dvb/video-set-highlight.rst
index d93b69eef15b..90aeafd923b7 100644
--- a/Documentation/media/uapi/dvb/video-set-highlight.rst
+++ b/Documentation/media/uapi/dvb/video-set-highlight.rst
@@ -16,7 +16,7 @@ VIDEO_SET_HIGHLIGHT
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, VIDEO_SET_HIGHLIGHT ,video_highlight_t *vhilite)
+.. c:function:: int ioctl(fd, VIDEO_SET_HIGHLIGHT, struct video_highlight *vhilite)
     :name: VIDEO_SET_HIGHLIGHT
 
 
@@ -53,6 +53,30 @@ Description
 This ioctl sets the SPU highlight information for the menu access of a
 DVD.
 
+.. c:type:: video_highlight
+
+.. code-block:: c
+
+	typedef
+	struct video_highlight {
+		int     active;      /*    1=show highlight, 0=hide highlight */
+		__u8    contrast1;   /*    7- 4  Pattern pixel contrast */
+				/*    3- 0  Background pixel contrast */
+		__u8    contrast2;   /*    7- 4  Emphasis pixel-2 contrast */
+				/*    3- 0  Emphasis pixel-1 contrast */
+		__u8    color1;      /*    7- 4  Pattern pixel color */
+				/*    3- 0  Background pixel color */
+		__u8    color2;      /*    7- 4  Emphasis pixel-2 color */
+				/*    3- 0  Emphasis pixel-1 color */
+		__u32    ypos;       /*   23-22  auto action mode */
+				/*   21-12  start y */
+				/*    9- 0  end y */
+		__u32    xpos;       /*   23-22  button color number */
+				/*   21-12  start x */
+				/*    9- 0  end x */
+	} video_highlight_t;
+
+
 
 Return Value
 ------------
diff --git a/Documentation/media/uapi/dvb/video-set-spu-palette.rst b/Documentation/media/uapi/dvb/video-set-spu-palette.rst
index b24f7882089a..51a1913d21d2 100644
--- a/Documentation/media/uapi/dvb/video-set-spu-palette.rst
+++ b/Documentation/media/uapi/dvb/video-set-spu-palette.rst
@@ -16,7 +16,7 @@ VIDEO_SET_SPU_PALETTE
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, VIDEO_SET_SPU_PALETTE, video_spu_palette_t *palette )
+.. c:function:: int ioctl(fd, VIDEO_SET_SPU_PALETTE, struct video_spu_palette *palette )
     :name: VIDEO_SET_SPU_PALETTE
 
 
@@ -52,6 +52,14 @@ Description
 
 This ioctl sets the SPU color palette.
 
+.. c:type:: video_spu_palette
+
+.. code-block::c
+
+	typedef struct video_spu_palette {      /* SPU Palette information */
+		int length;
+		__u8 __user *palette;
+	} video_spu_palette_t;
 
 Return Value
 ------------
diff --git a/Documentation/media/uapi/dvb/video-set-spu.rst b/Documentation/media/uapi/dvb/video-set-spu.rst
index 2a7f0625de38..739e5e7bd133 100644
--- a/Documentation/media/uapi/dvb/video-set-spu.rst
+++ b/Documentation/media/uapi/dvb/video-set-spu.rst
@@ -16,7 +16,7 @@ VIDEO_SET_SPU
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, VIDEO_SET_SPU , video_spu_t *spu)
+.. c:function:: int ioctl(fd, VIDEO_SET_SPU , struct video_spu *spu)
     :name: VIDEO_SET_SPU
 
 
@@ -54,6 +54,15 @@ Description
 This ioctl activates or deactivates SPU decoding in a DVD input stream.
 It can only be used, if the driver is able to handle a DVD stream.
 
+.. c:type:: struct video_spu
+
+.. code-block:: c
+
+	typedef struct video_spu {
+		int active;
+		int stream_id;
+	} video_spu_t;
+
 
 Return Value
 ------------
diff --git a/include/uapi/linux/dvb/video.h b/include/uapi/linux/dvb/video.h
index 49392564f9d6..260f033a5b54 100644
--- a/include/uapi/linux/dvb/video.h
+++ b/include/uapi/linux/dvb/video.h
@@ -206,7 +206,8 @@ typedef __u16 video_attributes_t;
 /*    6    line 21-2 data present in GOP (1=yes, 0=no) */
 /*    5- 3 source resolution (0=720x480/576, 1=704x480/576, 2=352x480/57 */
 /*    2    source letterboxed (1=yes, 0=no) */
-/*    0    film/camera mode (0=camera, 1=film (625/50 only)) */
+/*    0    film/camera mode (0=
+ *camera, 1=film (625/50 only)) */
 
 
 /* bit definitions for capabilities: */
-- 
2.7.4


