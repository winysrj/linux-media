Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38597 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955AbcGEBbZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 21:31:25 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 04/41] Documentation: video_function_calls: improve man-like format
Date: Mon,  4 Jul 2016 22:30:39 -0300
Message-Id: <468ee53cda50b5dcd85ae42e6595953ce82893a1.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Parsing this file were causing lots of warnings with sphinx,
due to the c function prototypes.

Fix that by prepending them with .. cpp:function::

While here, use the same way we document man-like pages,
at the V4L side of the book and add escapes to asterisks.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../linux_tv/media/dvb/video_function_calls.rst    | 508 +++++++++++++--------
 1 file changed, 310 insertions(+), 198 deletions(-)

diff --git a/Documentation/linux_tv/media/dvb/video_function_calls.rst b/Documentation/linux_tv/media/dvb/video_function_calls.rst
index b8ea77d1f239..39f1f400b6d0 100644
--- a/Documentation/linux_tv/media/dvb/video_function_calls.rst
+++ b/Documentation/linux_tv/media/dvb/video_function_calls.rst
@@ -9,10 +9,11 @@ Video Function Calls
 
 .. _video_fopen:
 
-open()
-======
+dvb video open()
+================
 
-DESCRIPTION
+Description
+-----------
 
 This system call opens a named video device (e.g.
 /dev/dvb/adapter0/video0) for subsequent use.
@@ -30,13 +31,13 @@ returned. If the Video Device is opened in O_RDONLY mode, the only
 ioctl call that can be used is VIDEO_GET_STATUS. All other call will
 return an error code.
 
-SYNOPSIS
-
-int open(const char *deviceName, int flags);
-
-PARAMETERS
+Synopsis
+--------
 
+.. c:function:: int open(const char *deviceName, int flags)
 
+Arguments
+----------
 
 .. flat-table::
     :header-rows:  0
@@ -45,7 +46,7 @@ PARAMETERS
 
     -  .. row 1
 
-       -  const char *deviceName
+       -  const char \*deviceName
 
        -  Name of specific video device.
 
@@ -76,7 +77,8 @@ PARAMETERS
        -  (blocking mode is the default)
 
 
-RETURN VALUE
+Return Value
+------------
 
 
 
@@ -113,18 +115,21 @@ RETURN VALUE
 
 .. _video_fclose:
 
-close()
-=======
+dvb video close()
+=================
 
-DESCRIPTION
+Description
+-----------
 
 This system call closes a previously opened video device.
 
-SYNOPSIS
+Synopsis
+--------
 
-int close(int fd);
+.. c:function:: int close(int fd)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -140,7 +145,8 @@ PARAMETERS
        -  File descriptor returned by a previous call to open().
 
 
-RETURN VALUE
+Return Value
+------------
 
 
 
@@ -159,10 +165,11 @@ RETURN VALUE
 
 .. _video_fwrite:
 
-write()
-=======
+dvb video write()
+=================
 
-DESCRIPTION
+Description
+-----------
 
 This system call can only be used if VIDEO_SOURCE_MEMORY is selected
 in the ioctl call VIDEO_SELECT_SOURCE. The data provided shall be in
@@ -170,11 +177,13 @@ PES format, unless the capability allows other formats. If O_NONBLOCK
 is not specified the function will block until buffer space is
 available. The amount of data to be transferred is implied by count.
 
-SYNOPSIS
+Synopsis
+--------
 
-size_t write(int fd, const void *buf, size_t count);
+.. c:function:: size_t write(int fd, const void *buf, size_t count)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -191,7 +200,7 @@ PARAMETERS
 
     -  .. row 2
 
-       -  void *buf
+       -  void \*buf
 
        -  Pointer to the buffer containing the PES data.
 
@@ -202,7 +211,8 @@ PARAMETERS
        -  Size of buf.
 
 
-RETURN VALUE
+Return Value
+------------
 
 
 
@@ -236,7 +246,8 @@ RETURN VALUE
 VIDEO_STOP
 ==========
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl is for DVB devices only. To control a V4L2 decoder use the
 V4L2 :ref:`VIDIOC_DECODER_CMD` instead.
@@ -245,11 +256,13 @@ This ioctl call asks the Video Device to stop playing the current
 stream. Depending on the input parameter, the screen can be blanked out
 or displaying the last decoded frame.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(fd, int request = VIDEO_STOP, boolean mode);
+.. c:function:: int ioctl(fd, int request = VIDEO_STOP, boolean mode)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -287,7 +300,8 @@ PARAMETERS
        -  FALSE: Show last decoded frame.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -299,7 +313,8 @@ appropriately. The generic error codes are described at the
 VIDEO_PLAY
 ==========
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl is for DVB devices only. To control a V4L2 decoder use the
 V4L2 :ref:`VIDIOC_DECODER_CMD` instead.
@@ -307,11 +322,13 @@ V4L2 :ref:`VIDIOC_DECODER_CMD` instead.
 This ioctl call asks the Video Device to start playing a video stream
 from the selected source.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(fd, int request = VIDEO_PLAY);
+.. c:function:: int ioctl(fd, int request = VIDEO_PLAY)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -333,7 +350,8 @@ PARAMETERS
        -  Equals VIDEO_PLAY for this command.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -345,7 +363,8 @@ appropriately. The generic error codes are described at the
 VIDEO_FREEZE
 ============
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl is for DVB devices only. To control a V4L2 decoder use the
 V4L2 :ref:`VIDIOC_DECODER_CMD` instead.
@@ -357,11 +376,13 @@ If VIDEO_SOURCE_MEMORY is selected in the ioctl call
 VIDEO_SELECT_SOURCE, the DVB subsystem will not decode any more data
 until the ioctl call VIDEO_CONTINUE or VIDEO_PLAY is performed.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(fd, int request = VIDEO_FREEZE);
+.. c:function:: int ioctl(fd, int request = VIDEO_FREEZE)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -383,7 +404,8 @@ PARAMETERS
        -  Equals VIDEO_FREEZE for this command.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -395,7 +417,8 @@ appropriately. The generic error codes are described at the
 VIDEO_CONTINUE
 ==============
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl is for DVB devices only. To control a V4L2 decoder use the
 V4L2 :ref:`VIDIOC_DECODER_CMD` instead.
@@ -403,11 +426,13 @@ V4L2 :ref:`VIDIOC_DECODER_CMD` instead.
 This ioctl call restarts decoding and playing processes of the video
 stream which was played before a call to VIDEO_FREEZE was made.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(fd, int request = VIDEO_CONTINUE);
+.. c:function:: int ioctl(fd, int request = VIDEO_CONTINUE)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -429,7 +454,8 @@ PARAMETERS
        -  Equals VIDEO_CONTINUE for this command.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -441,7 +467,8 @@ appropriately. The generic error codes are described at the
 VIDEO_SELECT_SOURCE
 ===================
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl is for DVB devices only. This ioctl was also supported by the
 V4L2 ivtv driver, but that has been replaced by the ivtv-specific
@@ -451,12 +478,13 @@ This ioctl call informs the video device which source shall be used for
 the input data. The possible sources are demux or memory. If memory is
 selected, the data is fed to the video device through the write command.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(fd, int request = VIDEO_SELECT_SOURCE,
-video_stream_source_t source);
+.. c:function:: int ioctl(fd, int request = VIDEO_SELECT_SOURCE, video_stream_source_t source)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -484,7 +512,8 @@ PARAMETERS
        -  Indicates which source shall be used for the Video stream.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -496,15 +525,18 @@ appropriately. The generic error codes are described at the
 VIDEO_SET_BLANK
 ===============
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl call asks the Video Device to blank out the picture.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(fd, int request = VIDEO_SET_BLANK, boolean mode);
+.. c:function:: int ioctl(fd, int request = VIDEO_SET_BLANK, boolean mode)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -537,7 +569,8 @@ PARAMETERS
        -  FALSE: Show last decoded frame.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -549,17 +582,19 @@ appropriately. The generic error codes are described at the
 VIDEO_GET_STATUS
 ================
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl call asks the Video Device to return the current status of
 the device.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(fd, int request = VIDEO_GET_STATUS, struct video_status
-*status);
+.. c:function:: int ioctl(fd, int request = VIDEO_GET_STATUS, struct video_status *status)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -582,12 +617,13 @@ PARAMETERS
 
     -  .. row 3
 
-       -  struct video_status *status
+       -  struct video_status \*status
 
        -  Returns the current status of the Video Device.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -599,7 +635,8 @@ appropriately. The generic error codes are described at the
 VIDEO_GET_FRAME_COUNT
 =====================
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl is obsolete. Do not use in new drivers. For V4L2 decoders
 this ioctl has been replaced by the ``V4L2_CID_MPEG_VIDEO_DEC_FRAME``
@@ -608,11 +645,13 @@ control.
 This ioctl call asks the Video Device to return the number of displayed
 frames since the decoder was started.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(int fd, int request = VIDEO_GET_FRAME_COUNT, __u64 *pts);
+.. c:function:: int ioctl(int fd, int request = VIDEO_GET_FRAME_COUNT, __u64 *pts)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -635,13 +674,14 @@ PARAMETERS
 
     -  .. row 3
 
-       -  __u64 *pts
+       -  __u64 \*pts
 
        -  Returns the number of frames displayed since the decoder was
           started.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -653,7 +693,8 @@ appropriately. The generic error codes are described at the
 VIDEO_GET_PTS
 =============
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl is obsolete. Do not use in new drivers. For V4L2 decoders
 this ioctl has been replaced by the ``V4L2_CID_MPEG_VIDEO_DEC_PTS``
@@ -662,11 +703,13 @@ control.
 This ioctl call asks the Video Device to return the current PTS
 timestamp.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(int fd, int request = VIDEO_GET_PTS, __u64 *pts);
+.. c:function:: int ioctl(int fd, int request = VIDEO_GET_PTS, __u64 *pts)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -689,7 +732,7 @@ PARAMETERS
 
     -  .. row 3
 
-       -  __u64 *pts
+       -  __u64 \*pts
 
        -  Returns the 33-bit timestamp as defined in ITU T-REC-H.222.0 /
           ISO/IEC 13818-1.
@@ -699,7 +742,8 @@ PARAMETERS
           decoded frame or the last PTS extracted by the PES parser.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -711,16 +755,18 @@ appropriately. The generic error codes are described at the
 VIDEO_GET_FRAME_RATE
 ====================
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl call asks the Video Device to return the current framerate.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(int fd, int request = VIDEO_GET_FRAME_RATE, unsigned int
-*rate);
+.. c:function:: int ioctl(int fd, int request = VIDEO_GET_FRAME_RATE, unsigned int *rate)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -743,12 +789,13 @@ PARAMETERS
 
     -  .. row 3
 
-       -  unsigned int *rate
+       -  unsigned int \*rate
 
        -  Returns the framerate in number of frames per 1000 seconds.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -760,7 +807,8 @@ appropriately. The generic error codes are described at the
 VIDEO_GET_EVENT
 ===============
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl is for DVB devices only. To get events from a V4L2 decoder
 use the V4L2 :ref:`VIDIOC_DQEVENT` ioctl instead.
@@ -776,11 +824,13 @@ included in the exceptfds argument, and for poll(), POLLPRI should be
 specified as the wake-up condition. Read-only permissions are sufficient
 for this ioctl call.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(fd, int request = VIDEO_GET_EVENT, struct video_event *ev);
+.. c:function:: int ioctl(fd, int request = VIDEO_GET_EVENT, struct video_event *ev)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -803,12 +853,13 @@ PARAMETERS
 
     -  .. row 3
 
-       -  struct video_event *ev
+       -  struct video_event \*ev
 
        -  Points to the location where the event, if any, is to be stored.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -840,7 +891,8 @@ appropriately. The generic error codes are described at the
 VIDEO_COMMAND
 =============
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl is obsolete. Do not use in new drivers. For V4L2 decoders
 this ioctl has been replaced by the
@@ -851,12 +903,13 @@ subset of the ``v4l2_decoder_cmd`` struct, so refer to the
 :ref:`VIDIOC_DECODER_CMD` documentation for
 more information.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(int fd, int request = VIDEO_COMMAND, struct video_command
-*cmd);
+.. c:function:: int ioctl(int fd, int request = VIDEO_COMMAND, struct video_command *cmd)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -879,12 +932,13 @@ PARAMETERS
 
     -  .. row 3
 
-       -  struct video_command *cmd
+       -  struct video_command \*cmd
 
        -  Commands the decoder.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -896,7 +950,8 @@ appropriately. The generic error codes are described at the
 VIDEO_TRY_COMMAND
 =================
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl is obsolete. Do not use in new drivers. For V4L2 decoders
 this ioctl has been replaced by the
@@ -907,12 +962,13 @@ subset of the ``v4l2_decoder_cmd`` struct, so refer to the
 :ref:`VIDIOC_TRY_DECODER_CMD <VIDIOC_DECODER_CMD>` documentation
 for more information.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(int fd, int request = VIDEO_TRY_COMMAND, struct
-video_command *cmd);
+.. c:function:: int ioctl(int fd, int request = VIDEO_TRY_COMMAND, struct video_command *cmd)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -935,12 +991,13 @@ PARAMETERS
 
     -  .. row 3
 
-       -  struct video_command *cmd
+       -  struct video_command \*cmd
 
        -  Try a decoder command.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -952,15 +1009,18 @@ appropriately. The generic error codes are described at the
 VIDEO_GET_SIZE
 ==============
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl returns the size and aspect ratio.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(int fd, int request = VIDEO_GET_SIZE, video_size_t *size);
+.. c:function:: int ioctl(int fd, int request = VIDEO_GET_SIZE, video_size_t *size)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -983,12 +1043,13 @@ PARAMETERS
 
     -  .. row 3
 
-       -  video_size_t *size
+       -  video_size_t \*size
 
        -  Returns the size and aspect ratio.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -1000,17 +1061,19 @@ appropriately. The generic error codes are described at the
 VIDEO_SET_DISPLAY_FORMAT
 ========================
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl call asks the Video Device to select the video format to be
 applied by the MPEG chip on the video.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(fd, int request = VIDEO_SET_DISPLAY_FORMAT,
-video_display_format_t format);
+.. c:function:: int ioctl(fd, int request = VIDEO_SET_DISPLAY_FORMAT, video_display_format_t format)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -1038,7 +1101,8 @@ PARAMETERS
        -  Selects the video format to be used.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -1050,18 +1114,20 @@ appropriately. The generic error codes are described at the
 VIDEO_STILLPICTURE
 ==================
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl call asks the Video Device to display a still picture
 (I-frame). The input data shall contain an I-frame. If the pointer is
 NULL, then the current displayed still picture is blanked.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(fd, int request = VIDEO_STILLPICTURE, struct
-video_still_picture *sp);
+.. c:function:: int ioctl(fd, int request = VIDEO_STILLPICTURE, struct video_still_picture *sp)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -1084,12 +1150,13 @@ PARAMETERS
 
     -  .. row 3
 
-       -  struct video_still_picture *sp
+       -  struct video_still_picture \*sp
 
        -  Pointer to a location where an I-frame and size is stored.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -1101,17 +1168,20 @@ appropriately. The generic error codes are described at the
 VIDEO_FAST_FORWARD
 ==================
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl call asks the Video Device to skip decoding of N number of
 I-frames. This call can only be used if VIDEO_SOURCE_MEMORY is
 selected.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(fd, int request = VIDEO_FAST_FORWARD, int nFrames);
+.. c:function:: int ioctl(fd, int request = VIDEO_FAST_FORWARD, int nFrames)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -1139,7 +1209,8 @@ PARAMETERS
        -  The number of frames to skip.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -1165,17 +1236,20 @@ appropriately. The generic error codes are described at the
 VIDEO_SLOWMOTION
 ================
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl call asks the video device to repeat decoding frames N number
 of times. This call can only be used if VIDEO_SOURCE_MEMORY is
 selected.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(fd, int request = VIDEO_SLOWMOTION, int nFrames);
+.. c:function:: int ioctl(fd, int request = VIDEO_SLOWMOTION, int nFrames)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -1203,7 +1277,8 @@ PARAMETERS
        -  The number of times to repeat each frame.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -1229,18 +1304,20 @@ appropriately. The generic error codes are described at the
 VIDEO_GET_CAPABILITIES
 ======================
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl call asks the video device about its decoding capabilities.
 On success it returns and integer which has bits set according to the
 defines in section ??.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(fd, int request = VIDEO_GET_CAPABILITIES, unsigned int
-*cap);
+.. c:function:: int ioctl(fd, int request = VIDEO_GET_CAPABILITIES, unsigned int *cap)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -1263,12 +1340,13 @@ PARAMETERS
 
     -  .. row 3
 
-       -  unsigned int *cap
+       -  unsigned int \*cap
 
        -  Pointer to a location where to store the capability information.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -1280,16 +1358,19 @@ appropriately. The generic error codes are described at the
 VIDEO_SET_ID
 ============
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl selects which sub-stream is to be decoded if a program or
 system stream is sent to the video device.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(int fd, int request = VIDEO_SET_ID, int id);
+.. c:function:: int ioctl(int fd, int request = VIDEO_SET_ID, int id)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -1317,7 +1398,8 @@ PARAMETERS
        -  video sub-stream id
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -1343,16 +1425,19 @@ appropriately. The generic error codes are described at the
 VIDEO_CLEAR_BUFFER
 ==================
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl call clears all video buffers in the driver and in the
 decoder hardware.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(fd, int request = VIDEO_CLEAR_BUFFER);
+.. c:function:: int ioctl(fd, int request = VIDEO_CLEAR_BUFFER)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -1374,7 +1459,8 @@ PARAMETERS
        -  Equals VIDEO_CLEAR_BUFFER for this command.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -1386,17 +1472,20 @@ appropriately. The generic error codes are described at the
 VIDEO_SET_STREAMTYPE
 ====================
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl tells the driver which kind of stream to expect being written
 to it. If this call is not used the default of video PES is used. Some
 drivers might not support this call and always expect PES.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(fd, int request = VIDEO_SET_STREAMTYPE, int type);
+.. c:function:: int ioctl(fd, int request = VIDEO_SET_STREAMTYPE, int type)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -1424,7 +1513,8 @@ PARAMETERS
        -  stream type
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -1436,18 +1526,20 @@ appropriately. The generic error codes are described at the
 VIDEO_SET_FORMAT
 ================
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl sets the screen format (aspect ratio) of the connected output
 device (TV) so that the output of the decoder can be adjusted
 accordingly.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(fd, int request = VIDEO_SET_FORMAT, video_format_t
-format);
+.. c:function:: int ioctl(fd, int request = VIDEO_SET_FORMAT, video_format_t format)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -1475,7 +1567,8 @@ PARAMETERS
        -  video format of TV as defined in section ??.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -1501,19 +1594,21 @@ appropriately. The generic error codes are described at the
 VIDEO_SET_SYSTEM
 ================
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl sets the television output format. The format (see section
 ??) may vary from the color format of the displayed MPEG stream. If the
 hardware is not able to display the requested format the call will
 return an error.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(fd, int request = VIDEO_SET_SYSTEM , video_system_t
-system);
+.. c:function:: int ioctl(fd, int request = VIDEO_SET_SYSTEM , video_system_t system)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -1541,7 +1636,8 @@ PARAMETERS
        -  video system of TV output.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -1567,17 +1663,19 @@ appropriately. The generic error codes are described at the
 VIDEO_SET_HIGHLIGHT
 ===================
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl sets the SPU highlight information for the menu access of a
 DVD.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(fd, int request = VIDEO_SET_HIGHLIGHT ,video_highlight_t
-*vhilite)
+.. c:function:: int ioctl(fd, int request = VIDEO_SET_HIGHLIGHT ,video_highlight_t *vhilite)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -1600,12 +1698,13 @@ PARAMETERS
 
     -  .. row 3
 
-       -  video_highlight_t *vhilite
+       -  video_highlight_t \*vhilite
 
        -  SPU Highlight information according to section ??.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -1617,16 +1716,19 @@ appropriately. The generic error codes are described at the
 VIDEO_SET_SPU
 =============
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl activates or deactivates SPU decoding in a DVD input stream.
 It can only be used, if the driver is able to handle a DVD stream.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(fd, int request = VIDEO_SET_SPU , video_spu_t *spu)
+.. c:function:: int ioctl(fd, int request = VIDEO_SET_SPU , video_spu_t *spu)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -1649,13 +1751,14 @@ PARAMETERS
 
     -  .. row 3
 
-       -  video_spu_t *spu
+       -  video_spu_t \*spu
 
        -  SPU decoding (de)activation and subid setting according to section
           ??.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -1681,16 +1784,18 @@ appropriately. The generic error codes are described at the
 VIDEO_SET_SPU_PALETTE
 =====================
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl sets the SPU color palette.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(fd, int request = VIDEO_SET_SPU_PALETTE
-,video_spu_palette_t *palette )
+.. c:function:: int ioctl(fd, int request = VIDEO_SET_SPU_PALETTE, video_spu_palette_t *palette )
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -1713,12 +1818,13 @@ PARAMETERS
 
     -  .. row 3
 
-       -  video_spu_palette_t *palette
+       -  video_spu_palette_t \*palette
 
        -  SPU palette according to section ??.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -1744,18 +1850,20 @@ appropriately. The generic error codes are described at the
 VIDEO_GET_NAVI
 ==============
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl returns navigational information from the DVD stream. This is
 especially needed if an encoded stream has to be decoded by the
 hardware.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(fd, int request = VIDEO_GET_NAVI , video_navi_pack_t
-*navipack)
+.. c:function:: int ioctl(fd, int request = VIDEO_GET_NAVI , video_navi_pack_t *navipack)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -1778,12 +1886,13 @@ PARAMETERS
 
     -  .. row 3
 
-       -  video_navi_pack_t *navipack
+       -  video_navi_pack_t \*navipack
 
        -  PCI or DSI pack (private stream 2) according to section ??.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -1809,19 +1918,21 @@ appropriately. The generic error codes are described at the
 VIDEO_SET_ATTRIBUTES
 ====================
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl is intended for DVD playback and allows you to set certain
 information about the stream. Some hardware may not need this
 information, but the call also tells the hardware to prepare for DVD
 playback.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(fd, int request = VIDEO_SET_ATTRIBUTE ,video_attributes_t
-vattr)
+.. c:function:: int ioctl(fd, int request = VIDEO_SET_ATTRIBUTE ,video_attributes_t vattr)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -1849,7 +1960,8 @@ PARAMETERS
        -  video attributes according to section ??.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
-- 
2.7.4

