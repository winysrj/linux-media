Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44881 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596AbcGDLrZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 07:47:25 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 11/51] Documentation: linux_tv: Replace reference names to match ioctls
Date: Mon,  4 Jul 2016 08:46:32 -0300
Message-Id: <8b0568f9b245238b5ce55f85e77da53e42d261d5.1467629488.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
MIME-Version: 1.0
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=true
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to a limitation at the DocBook language, the references
were using lowercase and slashes, instead of the name of the
ioctls. On ReST, make them identical. This will hopefully
help to cleanup the code a little bit.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../linux_tv/media/dvb/audio_function_calls.rst    |   2 +-
 .../linux_tv/media/dvb/video_function_calls.rst    |  18 +--
 Documentation/linux_tv/media/v4l/app-pri.rst       |  10 +-
 Documentation/linux_tv/media/v4l/audio.rst         |  24 ++--
 Documentation/linux_tv/media/v4l/buffer.rst        |  44 +++----
 Documentation/linux_tv/media/v4l/control.rst       |  14 +--
 Documentation/linux_tv/media/v4l/crop.rst          |  12 +-
 Documentation/linux_tv/media/v4l/dev-capture.rst   |   8 +-
 Documentation/linux_tv/media/v4l/dev-codec.rst     |   2 +-
 Documentation/linux_tv/media/v4l/dev-event.rst     |   4 +-
 Documentation/linux_tv/media/v4l/dev-osd.rst       |  12 +-
 Documentation/linux_tv/media/v4l/dev-output.rst    |   8 +-
 Documentation/linux_tv/media/v4l/dev-overlay.rst   |  38 +++---
 Documentation/linux_tv/media/v4l/dev-radio.rst     |   6 +-
 Documentation/linux_tv/media/v4l/dev-raw-vbi.rst   |  12 +-
 Documentation/linux_tv/media/v4l/dev-rds.rst       |   4 +-
 Documentation/linux_tv/media/v4l/dev-sdr.rst       |   8 +-
 .../linux_tv/media/v4l/dev-sliced-vbi.rst          |  36 +++---
 Documentation/linux_tv/media/v4l/dev-subdev.rst    |  22 ++--
 Documentation/linux_tv/media/v4l/diff-v4l.rst      |  96 +++++++--------
 Documentation/linux_tv/media/v4l/dmabuf.rst        |  20 ++--
 Documentation/linux_tv/media/v4l/dv-timings.rst    |  10 +-
 .../linux_tv/media/v4l/extended-controls.rst       |  40 +++----
 Documentation/linux_tv/media/v4l/field-order.rst   |   6 +-
 Documentation/linux_tv/media/v4l/format.rst        |  10 +-
 Documentation/linux_tv/media/v4l/func-mmap.rst     |   6 +-
 Documentation/linux_tv/media/v4l/func-open.rst     |   2 +-
 Documentation/linux_tv/media/v4l/func-poll.rst     |  12 +-
 Documentation/linux_tv/media/v4l/func-read.rst     |   4 +-
 Documentation/linux_tv/media/v4l/func-select.rst   |   8 +-
 Documentation/linux_tv/media/v4l/hist-v4l2.rst     | 130 ++++++++++-----------
 Documentation/linux_tv/media/v4l/io.rst            |   4 +-
 .../linux_tv/media/v4l/libv4l-introduction.rst     |  12 +-
 Documentation/linux_tv/media/v4l/mmap.rst          |  20 ++--
 Documentation/linux_tv/media/v4l/open.rst          |   6 +-
 Documentation/linux_tv/media/v4l/pixfmt-013.rst    |   4 +-
 Documentation/linux_tv/media/v4l/pixfmt.rst        |   4 +-
 Documentation/linux_tv/media/v4l/planar-apis.rst   |  16 +--
 Documentation/linux_tv/media/v4l/querycap.rst      |  12 +-
 Documentation/linux_tv/media/v4l/rw.rst            |   2 +-
 .../linux_tv/media/v4l/selection-api-004.rst       |   2 +-
 Documentation/linux_tv/media/v4l/standard.rst      |  12 +-
 Documentation/linux_tv/media/v4l/streaming-par.rst |   6 +-
 Documentation/linux_tv/media/v4l/tuner.rst         |  22 ++--
 Documentation/linux_tv/media/v4l/userp.rst         |  18 +--
 Documentation/linux_tv/media/v4l/v4l2.rst          |   2 +-
 Documentation/linux_tv/media/v4l/video.rst         |  14 +--
 .../linux_tv/media/v4l/vidioc-create-bufs.rst      |   8 +-
 .../linux_tv/media/v4l/vidioc-cropcap.rst          |   2 +-
 .../linux_tv/media/v4l/vidioc-dbg-g-chip-info.rst  |   2 +-
 .../linux_tv/media/v4l/vidioc-dbg-g-register.rst   |   6 +-
 .../linux_tv/media/v4l/vidioc-decoder-cmd.rst      |   8 +-
 .../linux_tv/media/v4l/vidioc-dqevent.rst          |   8 +-
 .../linux_tv/media/v4l/vidioc-dv-timings-cap.rst   |   2 +-
 .../linux_tv/media/v4l/vidioc-encoder-cmd.rst      |   8 +-
 .../linux_tv/media/v4l/vidioc-enum-dv-timings.rst  |   4 +-
 .../linux_tv/media/v4l/vidioc-enum-fmt.rst         |   2 +-
 .../media/v4l/vidioc-enum-frameintervals.rst       |   6 +-
 .../linux_tv/media/v4l/vidioc-enum-framesizes.rst  |   4 +-
 .../linux_tv/media/v4l/vidioc-enum-freq-bands.rst  |   2 +-
 .../linux_tv/media/v4l/vidioc-enumaudio.rst        |   4 +-
 .../linux_tv/media/v4l/vidioc-enumaudioout.rst     |   4 +-
 .../linux_tv/media/v4l/vidioc-enuminput.rst        |   2 +-
 .../linux_tv/media/v4l/vidioc-enumoutput.rst       |   2 +-
 .../linux_tv/media/v4l/vidioc-enumstd.rst          |   2 +-
 Documentation/linux_tv/media/v4l/vidioc-expbuf.rst |  10 +-
 .../linux_tv/media/v4l/vidioc-g-audio.rst          |   2 +-
 .../linux_tv/media/v4l/vidioc-g-audioout.rst       |   2 +-
 Documentation/linux_tv/media/v4l/vidioc-g-crop.rst |   4 +-
 Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst |  10 +-
 .../linux_tv/media/v4l/vidioc-g-dv-timings.rst     |   4 +-
 Documentation/linux_tv/media/v4l/vidioc-g-edid.rst |  10 +-
 .../linux_tv/media/v4l/vidioc-g-enc-index.rst      |   2 +-
 .../linux_tv/media/v4l/vidioc-g-ext-ctrls.rst      |  10 +-
 Documentation/linux_tv/media/v4l/vidioc-g-fbuf.rst |  18 +--
 Documentation/linux_tv/media/v4l/vidioc-g-fmt.rst  |   2 +-
 .../linux_tv/media/v4l/vidioc-g-frequency.rst      |   2 +-
 .../linux_tv/media/v4l/vidioc-g-input.rst          |   4 +-
 .../linux_tv/media/v4l/vidioc-g-jpegcomp.rst       |   2 +-
 .../linux_tv/media/v4l/vidioc-g-modulator.rst      |   4 +-
 .../linux_tv/media/v4l/vidioc-g-output.rst         |   4 +-
 Documentation/linux_tv/media/v4l/vidioc-g-parm.rst |   2 +-
 .../linux_tv/media/v4l/vidioc-g-priority.rst       |   2 +-
 .../linux_tv/media/v4l/vidioc-g-selection.rst      |   2 +-
 .../linux_tv/media/v4l/vidioc-g-sliced-vbi-cap.rst |   4 +-
 Documentation/linux_tv/media/v4l/vidioc-g-std.rst  |   4 +-
 .../linux_tv/media/v4l/vidioc-g-tuner.rst          |  10 +-
 .../linux_tv/media/v4l/vidioc-log-status.rst       |   2 +-
 .../linux_tv/media/v4l/vidioc-overlay.rst          |   6 +-
 .../linux_tv/media/v4l/vidioc-prepare-buf.rst      |   2 +-
 Documentation/linux_tv/media/v4l/vidioc-qbuf.rst   |  14 +--
 .../linux_tv/media/v4l/vidioc-query-dv-timings.rst |   4 +-
 .../linux_tv/media/v4l/vidioc-querybuf.rst         |   6 +-
 .../linux_tv/media/v4l/vidioc-querycap.rst         |   4 +-
 .../linux_tv/media/v4l/vidioc-queryctrl.rst        |   6 +-
 .../linux_tv/media/v4l/vidioc-querystd.rst         |   2 +-
 .../linux_tv/media/v4l/vidioc-reqbufs.rst          |   4 +-
 .../linux_tv/media/v4l/vidioc-s-hw-freq-seek.rst   |   6 +-
 .../linux_tv/media/v4l/vidioc-streamon.rst         |   8 +-
 .../v4l/vidioc-subdev-enum-frame-interval.rst      |   4 +-
 .../media/v4l/vidioc-subdev-enum-frame-size.rst    |   8 +-
 .../media/v4l/vidioc-subdev-enum-mbus-code.rst     |   4 +-
 .../linux_tv/media/v4l/vidioc-subdev-g-crop.rst    |   4 +-
 .../linux_tv/media/v4l/vidioc-subdev-g-fmt.rst     |   2 +-
 .../media/v4l/vidioc-subdev-g-frame-interval.rst   |   2 +-
 .../media/v4l/vidioc-subdev-g-selection.rst        |   4 +-
 .../linux_tv/media/v4l/vidioc-subscribe-event.rst  |   8 +-
 107 files changed, 537 insertions(+), 537 deletions(-)

diff --git a/Documentation/linux_tv/media/dvb/audio_function_calls.rst b/Documentation/linux_tv/media/dvb/audio_function_calls.rst
index 41a5757ffd72..d1a5b5970b71 100644
--- a/Documentation/linux_tv/media/dvb/audio_function_calls.rst
+++ b/Documentation/linux_tv/media/dvb/audio_function_calls.rst
@@ -456,7 +456,7 @@ AUDIO_SET_MUTE
 DESCRIPTION
 
 This ioctl is for DVB devices only. To control a V4L2 decoder use the
-V4L2 :ref:`VIDIOC_DECODER_CMD <vidioc-decoder-cmd>` with the
+V4L2 :ref:`VIDIOC_DECODER_CMD <VIDIOC_DECODER_CMD>` with the
 ``V4L2_DEC_CMD_START_MUTE_AUDIO`` flag instead.
 
 This ioctl call asks the audio device to mute the stream that is
diff --git a/Documentation/linux_tv/media/dvb/video_function_calls.rst b/Documentation/linux_tv/media/dvb/video_function_calls.rst
index 3add2b85450d..98c90dcdb587 100644
--- a/Documentation/linux_tv/media/dvb/video_function_calls.rst
+++ b/Documentation/linux_tv/media/dvb/video_function_calls.rst
@@ -239,7 +239,7 @@ VIDEO_STOP
 DESCRIPTION
 
 This ioctl is for DVB devices only. To control a V4L2 decoder use the
-V4L2 :ref:`VIDIOC_DECODER_CMD <vidioc-decoder-cmd>` instead.
+V4L2 :ref:`VIDIOC_DECODER_CMD <VIDIOC_DECODER_CMD>` instead.
 
 This ioctl call asks the Video Device to stop playing the current
 stream. Depending on the input parameter, the screen can be blanked out
@@ -302,7 +302,7 @@ VIDEO_PLAY
 DESCRIPTION
 
 This ioctl is for DVB devices only. To control a V4L2 decoder use the
-V4L2 :ref:`VIDIOC_DECODER_CMD <vidioc-decoder-cmd>` instead.
+V4L2 :ref:`VIDIOC_DECODER_CMD <VIDIOC_DECODER_CMD>` instead.
 
 This ioctl call asks the Video Device to start playing a video stream
 from the selected source.
@@ -348,7 +348,7 @@ VIDEO_FREEZE
 DESCRIPTION
 
 This ioctl is for DVB devices only. To control a V4L2 decoder use the
-V4L2 :ref:`VIDIOC_DECODER_CMD <vidioc-decoder-cmd>` instead.
+V4L2 :ref:`VIDIOC_DECODER_CMD <VIDIOC_DECODER_CMD>` instead.
 
 This ioctl call suspends the live video stream being played. Decoding
 and playing are frozen. It is then possible to restart the decoding and
@@ -398,7 +398,7 @@ VIDEO_CONTINUE
 DESCRIPTION
 
 This ioctl is for DVB devices only. To control a V4L2 decoder use the
-V4L2 :ref:`VIDIOC_DECODER_CMD <vidioc-decoder-cmd>` instead.
+V4L2 :ref:`VIDIOC_DECODER_CMD <VIDIOC_DECODER_CMD>` instead.
 
 This ioctl call restarts decoding and playing processes of the video
 stream which was played before a call to VIDEO_FREEZE was made.
@@ -763,7 +763,7 @@ VIDEO_GET_EVENT
 DESCRIPTION
 
 This ioctl is for DVB devices only. To get events from a V4L2 decoder
-use the V4L2 :ref:`VIDIOC_DQEVENT <vidioc-dqevent>` ioctl instead.
+use the V4L2 :ref:`VIDIOC_DQEVENT <VIDIOC_DQEVENT>` ioctl instead.
 
 This ioctl call returns an event of type video_event if available. If
 an event is not available, the behavior depends on whether the device is
@@ -844,11 +844,11 @@ DESCRIPTION
 
 This ioctl is obsolete. Do not use in new drivers. For V4L2 decoders
 this ioctl has been replaced by the
-:ref:`VIDIOC_DECODER_CMD <vidioc-decoder-cmd>` ioctl.
+:ref:`VIDIOC_DECODER_CMD <VIDIOC_DECODER_CMD>` ioctl.
 
 This ioctl commands the decoder. The ``video_command`` struct is a
 subset of the ``v4l2_decoder_cmd`` struct, so refer to the
-:ref:`VIDIOC_DECODER_CMD <vidioc-decoder-cmd>` documentation for
+:ref:`VIDIOC_DECODER_CMD <VIDIOC_DECODER_CMD>` documentation for
 more information.
 
 SYNOPSIS
@@ -900,11 +900,11 @@ DESCRIPTION
 
 This ioctl is obsolete. Do not use in new drivers. For V4L2 decoders
 this ioctl has been replaced by the
-:ref:`VIDIOC_TRY_DECODER_CMD <vidioc-decoder-cmd>` ioctl.
+:ref:`VIDIOC_TRY_DECODER_CMD <VIDIOC_DECODER_CMD>` ioctl.
 
 This ioctl tries a decoder command. The ``video_command`` struct is a
 subset of the ``v4l2_decoder_cmd`` struct, so refer to the
-:ref:`VIDIOC_TRY_DECODER_CMD <vidioc-decoder-cmd>` documentation
+:ref:`VIDIOC_TRY_DECODER_CMD <VIDIOC_DECODER_CMD>` documentation
 for more information.
 
 SYNOPSIS
diff --git a/Documentation/linux_tv/media/v4l/app-pri.rst b/Documentation/linux_tv/media/v4l/app-pri.rst
index 7f034852ae1f..bc50afca95fc 100644
--- a/Documentation/linux_tv/media/v4l/app-pri.rst
+++ b/Documentation/linux_tv/media/v4l/app-pri.rst
@@ -16,17 +16,17 @@ applications and automatically regain control of the device at a later
 time.
 
 Since these features cannot be implemented entirely in user space V4L2
-defines the :ref:`VIDIOC_G_PRIORITY <vidioc-g-priority>` and
-:ref:`VIDIOC_S_PRIORITY <vidioc-g-priority>` ioctls to request and
+defines the :ref:`VIDIOC_G_PRIORITY <VIDIOC_G_PRIORITY>` and
+:ref:`VIDIOC_S_PRIORITY <VIDIOC_G_PRIORITY>` ioctls to request and
 query the access priority associate with a file descriptor. Opening a
 device assigns a medium priority, compatible with earlier versions of
 V4L2 and drivers not supporting these ioctls. Applications requiring a
 different priority will usually call :ref:`VIDIOC_S_PRIORITY
-<vidioc-g-priority>` after verifying the device with the
-:ref:`VIDIOC_QUERYCAP <vidioc-querycap>` ioctl.
+<VIDIOC_G_PRIORITY>` after verifying the device with the
+:ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>` ioctl.
 
 Ioctls changing driver properties, such as
-:ref:`VIDIOC_S_INPUT <vidioc-g-input>`, return an EBUSY error code
+:ref:`VIDIOC_S_INPUT <VIDIOC_G_INPUT>`, return an EBUSY error code
 after another application obtained higher priority.
 
 
diff --git a/Documentation/linux_tv/media/v4l/audio.rst b/Documentation/linux_tv/media/v4l/audio.rst
index 95622902e86e..fa6bf5ad8d32 100644
--- a/Documentation/linux_tv/media/v4l/audio.rst
+++ b/Documentation/linux_tv/media/v4l/audio.rst
@@ -27,31 +27,31 @@ number, starting at zero, of one audio input or output.
 
 To learn about the number and attributes of the available inputs and
 outputs applications can enumerate them with the
-:ref:`VIDIOC_ENUMAUDIO <vidioc-enumaudio>` and
-:ref:`VIDIOC_ENUMAUDOUT <vidioc-enumaudioout>` ioctl, respectively.
+:ref:`VIDIOC_ENUMAUDIO <VIDIOC_ENUMAUDIO>` and
+:ref:`VIDIOC_ENUMAUDOUT <VIDIOC_ENUMAUDIOout>` ioctl, respectively.
 The struct :ref:`v4l2_audio <v4l2-audio>` returned by the
-:ref:`VIDIOC_ENUMAUDIO <vidioc-enumaudio>` ioctl also contains signal
+:ref:`VIDIOC_ENUMAUDIO <VIDIOC_ENUMAUDIO>` ioctl also contains signal
 :status information applicable when the current audio input is queried.
 
-The :ref:`VIDIOC_G_AUDIO <vidioc-g-audio>` and
-:ref:`VIDIOC_G_AUDOUT <vidioc-g-audioout>` ioctls report the current
+The :ref:`VIDIOC_G_AUDIO <VIDIOC_G_AUDIO>` and
+:ref:`VIDIOC_G_AUDOUT <VIDIOC_G_AUDIOout>` ioctls report the current
 audio input and output, respectively. Note that, unlike
-:ref:`VIDIOC_G_INPUT <vidioc-g-input>` and
-:ref:`VIDIOC_G_OUTPUT <vidioc-g-output>` these ioctls return a
-structure as :ref:`VIDIOC_ENUMAUDIO <vidioc-enumaudio>` and
-:ref:`VIDIOC_ENUMAUDOUT <vidioc-enumaudioout>` do, not just an index.
+:ref:`VIDIOC_G_INPUT <VIDIOC_G_INPUT>` and
+:ref:`VIDIOC_G_OUTPUT <VIDIOC_G_OUTPUT>` these ioctls return a
+structure as :ref:`VIDIOC_ENUMAUDIO <VIDIOC_ENUMAUDIO>` and
+:ref:`VIDIOC_ENUMAUDOUT <VIDIOC_ENUMAUDIOout>` do, not just an index.
 
 To select an audio input and change its properties applications call the
-:ref:`VIDIOC_S_AUDIO <vidioc-g-audio>` ioctl. To select an audio
+:ref:`VIDIOC_S_AUDIO <VIDIOC_G_AUDIO>` ioctl. To select an audio
 output (which presently has no changeable properties) applications call
-the :ref:`VIDIOC_S_AUDOUT <vidioc-g-audioout>` ioctl.
+the :ref:`VIDIOC_S_AUDOUT <VIDIOC_G_AUDIOout>` ioctl.
 
 Drivers must implement all audio input ioctls when the device has
 multiple selectable audio inputs, all audio output ioctls when the
 device has multiple selectable audio outputs. When the device has any
 audio inputs or outputs the driver must set the ``V4L2_CAP_AUDIO`` flag
 in the struct :ref:`v4l2_capability <v4l2-capability>` returned by
-the :ref:`VIDIOC_QUERYCAP <vidioc-querycap>` ioctl.
+the :ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>` ioctl.
 
 
 .. code-block:: c
diff --git a/Documentation/linux_tv/media/v4l/buffer.rst b/Documentation/linux_tv/media/v4l/buffer.rst
index e4cec63979c2..7d96ab74500f 100644
--- a/Documentation/linux_tv/media/v4l/buffer.rst
+++ b/Documentation/linux_tv/media/v4l/buffer.rst
@@ -12,9 +12,9 @@ planes, while the buffer structure acts as a container for the planes.
 Only pointers to buffers (planes) are exchanged, the data itself is not
 copied. These pointers, together with meta-information like timestamps
 or field parity, are stored in a struct :c:type:`struct v4l2_buffer`,
-argument to the :ref:`VIDIOC_QUERYBUF <vidioc-querybuf>`,
-:ref:`VIDIOC_QBUF <vidioc-qbuf>` and
-:ref:`VIDIOC_DQBUF <vidioc-qbuf>` ioctl. In the multi-planar API,
+argument to the :ref:`VIDIOC_QUERYBUF <VIDIOC_QUERYBUF>`,
+:ref:`VIDIOC_QBUF <VIDIOC_QBUF>` and
+:ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctl. In the multi-planar API,
 some plane-specific members of struct :c:type:`struct v4l2_buffer`,
 such as pointers and sizes for each plane, are stored in struct
 :c:type:`struct v4l2_plane` instead. In that case, struct
@@ -26,8 +26,8 @@ see flags in the masks ``V4L2_BUF_FLAG_TIMESTAMP_MASK`` and
 ``V4L2_BUF_FLAG_TSTAMP_SRC_MASK`` in :ref:`buffer-flags`. These flags
 are always valid and constant across all buffers during the whole video
 stream. Changes in these flags may take place as a side effect of
-:ref:`VIDIOC_S_INPUT <vidioc-g-input>` or
-:ref:`VIDIOC_S_OUTPUT <vidioc-g-output>` however. The
+:ref:`VIDIOC_S_INPUT <VIDIOC_G_INPUT>` or
+:ref:`VIDIOC_S_OUTPUT <VIDIOC_G_OUTPUT>` however. The
 ``V4L2_BUF_FLAG_TIMESTAMP_COPY`` timestamp type which is used by e.g. on
 mem-to-mem devices is an exception to the rule: the timestamp source
 flags are copied from the OUTPUT video buffer to the CAPTURE video
@@ -50,12 +50,12 @@ buffer.
 
        -  
        -  Number of the buffer, set by the application except when calling
-          :ref:`VIDIOC_DQBUF <vidioc-qbuf>`, then it is set by the
+          :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>`, then it is set by the
           driver. This field can range from zero to the number of buffers
-          allocated with the :ref:`VIDIOC_REQBUFS <vidioc-reqbufs>` ioctl
+          allocated with the :ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>` ioctl
           (struct :ref:`v4l2_requestbuffers <v4l2-requestbuffers>`
           ``count``), plus any buffers allocated with
-          :ref:`VIDIOC_CREATE_BUFS <vidioc-create-bufs>` minus one.
+          :ref:`VIDIOC_CREATE_BUFS <VIDIOC_CREATE_BUFS>` minus one.
 
     -  .. row 2
 
@@ -243,8 +243,8 @@ buffer.
        -  
        -  Size of the buffer (not the payload) in bytes for the
           single-planar API. This is set by the driver based on the calls to
-          :ref:`VIDIOC_REQBUFS <vidioc-reqbufs>` and/or
-          :ref:`VIDIOC_CREATE_BUFS <vidioc-create-bufs>`. For the
+          :ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>` and/or
+          :ref:`VIDIOC_CREATE_BUFS <VIDIOC_CREATE_BUFS>`. For the
           multi-planar API the application sets this to the number of
           elements in the ``planes`` array. The driver will fill in the
           actual number of valid elements in that array.
@@ -303,8 +303,8 @@ buffer.
        -  
        -  Size in bytes of the plane (not its payload). This is set by the
           driver based on the calls to
-          :ref:`VIDIOC_REQBUFS <vidioc-reqbufs>` and/or
-          :ref:`VIDIOC_CREATE_BUFS <vidioc-create-bufs>`.
+          :ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>` and/or
+          :ref:`VIDIOC_CREATE_BUFS <VIDIOC_CREATE_BUFS>`.
 
     -  .. row 3
 
@@ -506,9 +506,9 @@ buffer.
        -  The buffer resides in device memory and has been mapped into the
           application's address space, see :ref:`mmap` for details.
           Drivers set or clear this flag when the
-          :ref:`VIDIOC_QUERYBUF <vidioc-querybuf>`,
-          :ref:`VIDIOC_QBUF <vidioc-qbuf>` or
-          :ref:`VIDIOC_DQBUF <vidioc-qbuf>` ioctl is called. Set by the
+          :ref:`VIDIOC_QUERYBUF <VIDIOC_QUERYBUF>`,
+          :ref:`VIDIOC_QBUF <VIDIOC_QBUF>` or
+          :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctl is called. Set by the
           driver.
 
     -  .. row 2
@@ -609,10 +609,10 @@ buffer.
 
        -  The buffer has been prepared for I/O and can be queued by the
           application. Drivers set or clear this flag when the
-          :ref:`VIDIOC_QUERYBUF <vidioc-querybuf>`,
-          :ref:`VIDIOC_PREPARE_BUF <vidioc-qbuf>`,
-          :ref:`VIDIOC_QBUF <vidioc-qbuf>` or
-          :ref:`VIDIOC_DQBUF <vidioc-qbuf>` ioctl is called.
+          :ref:`VIDIOC_QUERYBUF <VIDIOC_QUERYBUF>`,
+          :ref:`VIDIOC_PREPARE_BUF <VIDIOC_QBUF>`,
+          :ref:`VIDIOC_QBUF <VIDIOC_QBUF>` or
+          :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctl is called.
 
     -  .. row 10
 
@@ -645,12 +645,12 @@ buffer.
 
        -  Last buffer produced by the hardware. mem2mem codec drivers set
           this flag on the capture queue for the last buffer when the
-          :ref:`VIDIOC_QUERYBUF <vidioc-querybuf>` or
-          :ref:`VIDIOC_DQBUF <vidioc-qbuf>` ioctl is called. Due to
+          :ref:`VIDIOC_QUERYBUF <VIDIOC_QUERYBUF>` or
+          :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctl is called. Due to
           hardware limitations, the last buffer may be empty. In this case
           the driver will set the ``bytesused`` field to 0, regardless of
           the format. Any Any subsequent call to the
-          :ref:`VIDIOC_DQBUF <vidioc-qbuf>` ioctl will not block anymore,
+          :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctl will not block anymore,
           but return an EPIPE error code.
 
     -  .. row 13
diff --git a/Documentation/linux_tv/media/v4l/control.rst b/Documentation/linux_tv/media/v4l/control.rst
index 16eb34472892..3e5c650707ae 100644
--- a/Documentation/linux_tv/media/v4l/control.rst
+++ b/Documentation/linux_tv/media/v4l/control.rst
@@ -47,7 +47,7 @@ changed or generally never without application request.
 
 V4L2 specifies an event mechanism to notify applications when controls
 change value (see
-:ref:`VIDIOC_SUBSCRIBE_EVENT <vidioc-subscribe-event>`, event
+:ref:`VIDIOC_SUBSCRIBE_EVENT <VIDIOC_SUBSCRIBE_EVENT>`, event
 ``V4L2_EVENT_CTRL``), panel applications might want to make use of that
 in order to always reflect the correct control value.
 
@@ -311,7 +311,7 @@ Control IDs
     180. Rotating the image to 90 and 270 will reverse the height and
     width of the display window. It is necessary to set the new height
     and width of the picture using the
-    :ref:`VIDIOC_S_FMT <vidioc-g-fmt>` ioctl according to the
+    :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl according to the
     rotation angle selected.
 
 ``V4L2_CID_BG_COLOR`` ``(integer)``
@@ -362,10 +362,10 @@ Control IDs
     and version, see :ref:`querycap`.
 
 Applications can enumerate the available controls with the
-:ref:`VIDIOC_QUERYCTRL <vidioc-queryctrl>` and
-:ref:`VIDIOC_QUERYMENU <vidioc-queryctrl>` ioctls, get and set a
-control value with the :ref:`VIDIOC_G_CTRL <vidioc-g-ctrl>` and
-:ref:`VIDIOC_S_CTRL <vidioc-g-ctrl>` ioctls. Drivers must implement
+:ref:`VIDIOC_QUERYCTRL <VIDIOC_QUERYCTRL>` and
+:ref:`VIDIOC_QUERYMENU <VIDIOC_QUERYCTRL>` ioctls, get and set a
+control value with the :ref:`VIDIOC_G_CTRL <VIDIOC_G_CTRL>` and
+:ref:`VIDIOC_S_CTRL <VIDIOC_G_CTRL>` ioctls. Drivers must implement
 ``VIDIOC_QUERYCTRL``, ``VIDIOC_G_CTRL`` and ``VIDIOC_S_CTRL`` when the
 device has one or more controls, ``VIDIOC_QUERYMENU`` when it has one or
 more menu type controls.
@@ -522,7 +522,7 @@ more menu type controls.
    the real IDs.
 
    Many applications today still use the ``V4L2_CID_PRIVATE_BASE`` IDs
-   instead of using :ref:`VIDIOC_QUERYCTRL <vidioc-queryctrl>` with
+   instead of using :ref:`VIDIOC_QUERYCTRL <VIDIOC_QUERYCTRL>` with
    the ``V4L2_CTRL_FLAG_NEXT_CTRL`` flag to enumerate all IDs, so
    support for ``V4L2_CID_PRIVATE_BASE`` is still around.
 
diff --git a/Documentation/linux_tv/media/v4l/crop.rst b/Documentation/linux_tv/media/v4l/crop.rst
index b9014d03865f..94f2d0e77ed8 100644
--- a/Documentation/linux_tv/media/v4l/crop.rst
+++ b/Documentation/linux_tv/media/v4l/crop.rst
@@ -14,17 +14,17 @@ offset into a video signal.
 
 Applications can use the following API to select an area in the video
 signal, query the default area and the hardware limits. *Despite their
-name, the :ref:`VIDIOC_CROPCAP <vidioc-cropcap>`,
-:ref:`VIDIOC_G_CROP <vidioc-g-crop>` and
-:ref:`VIDIOC_S_CROP <vidioc-g-crop>` ioctls apply to input as well
+name, the :ref:`VIDIOC_CROPCAP <VIDIOC_CROPCAP>`,
+:ref:`VIDIOC_G_CROP <VIDIOC_G_CROP>` and
+:ref:`VIDIOC_S_CROP <VIDIOC_G_CROP>` ioctls apply to input as well
 as output devices.*
 
 Scaling requires a source and a target. On a video capture or overlay
 device the source is the video signal, and the cropping ioctls determine
 the area actually sampled. The target are images read by the application
 or overlaid onto the graphics screen. Their size (and position for an
-overlay) is negotiated with the :ref:`VIDIOC_G_FMT <vidioc-g-fmt>`
-and :ref:`VIDIOC_S_FMT <vidioc-g-fmt>` ioctls.
+overlay) is negotiated with the :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>`
+and :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctls.
 
 On a video output device the source are the images passed in by the
 application, and their size is again negotiated with the
@@ -108,7 +108,7 @@ they may prefer a particular image size or a certain area in the video
 signal. If the driver has to adjust both to satisfy hardware
 limitations, the last requested rectangle shall take priority, and the
 driver should preferably adjust the opposite one. The
-:ref:`VIDIOC_TRY_FMT <vidioc-g-fmt>` ioctl however shall not change
+:ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` ioctl however shall not change
 the driver state and therefore only adjust the requested rectangle.
 
 Suppose scaling on a video capture device is restricted to a factor 1:1
diff --git a/Documentation/linux_tv/media/v4l/dev-capture.rst b/Documentation/linux_tv/media/v4l/dev-capture.rst
index 21207ab2e604..fd6357c995aa 100644
--- a/Documentation/linux_tv/media/v4l/dev-capture.rst
+++ b/Documentation/linux_tv/media/v4l/dev-capture.rst
@@ -25,7 +25,7 @@ Devices supporting the video capture interface set the
 ``V4L2_CAP_VIDEO_CAPTURE`` or ``V4L2_CAP_VIDEO_CAPTURE_MPLANE`` flag in
 the ``capabilities`` field of struct
 :ref:`v4l2_capability <v4l2-capability>` returned by the
-:ref:`VIDIOC_QUERYCAP <vidioc-querycap>` ioctl. As secondary device
+:ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>` ioctl. As secondary device
 functions they may also support the :ref:`video overlay <overlay>`
 (``V4L2_CAP_VIDEO_OVERLAY``) and the :ref:`raw VBI capture <raw-vbi>`
 (``V4L2_CAP_VBI_CAPTURE``) interface. At least one of the read/write or
@@ -65,7 +65,7 @@ To query the current image format applications set the ``type`` field of
 a struct :ref:`v4l2_format <v4l2-format>` to
 ``V4L2_BUF_TYPE_VIDEO_CAPTURE`` or
 ``V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE`` and call the
-:ref:`VIDIOC_G_FMT <vidioc-g-fmt>` ioctl with a pointer to this
+:ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` ioctl with a pointer to this
 structure. Drivers fill the struct
 :ref:`v4l2_pix_format <v4l2-pix-format>` ``pix`` or the struct
 :ref:`v4l2_pix_format_mplane <v4l2-pix-format-mplane>` ``pix_mp``
@@ -75,12 +75,12 @@ To request different parameters applications set the ``type`` field of a
 struct :ref:`v4l2_format <v4l2-format>` as above and initialize all
 fields of the struct :ref:`v4l2_pix_format <v4l2-pix-format>`
 ``vbi`` member of the ``fmt`` union, or better just modify the results
-of ``VIDIOC_G_FMT``, and call the :ref:`VIDIOC_S_FMT <vidioc-g-fmt>`
+of ``VIDIOC_G_FMT``, and call the :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`
 ioctl with a pointer to this structure. Drivers may adjust the
 parameters and finally return the actual parameters as ``VIDIOC_G_FMT``
 does.
 
-Like ``VIDIOC_S_FMT`` the :ref:`VIDIOC_TRY_FMT <vidioc-g-fmt>` ioctl
+Like ``VIDIOC_S_FMT`` the :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` ioctl
 can be used to learn about hardware limitations without disabling I/O or
 possibly time consuming hardware preparations.
 
diff --git a/Documentation/linux_tv/media/v4l/dev-codec.rst b/Documentation/linux_tv/media/v4l/dev-codec.rst
index f0b54c2b95c3..1540755b1735 100644
--- a/Documentation/linux_tv/media/v4l/dev-codec.rst
+++ b/Documentation/linux_tv/media/v4l/dev-codec.rst
@@ -15,7 +15,7 @@ A memory-to-memory video node acts just like a normal video node, but it
 supports both output (sending frames from memory to the codec hardware)
 and capture (receiving the processed frames from the codec hardware into
 memory) stream I/O. An application will have to setup the stream I/O for
-both sides and finally call :ref:`VIDIOC_STREAMON <vidioc-streamon>`
+both sides and finally call :ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>`
 for both capture and output to start the codec.
 
 Video compression codecs use the MPEG controls to setup their codec
diff --git a/Documentation/linux_tv/media/v4l/dev-event.rst b/Documentation/linux_tv/media/v4l/dev-event.rst
index afe24a72d8ea..5d21c6873b1a 100644
--- a/Documentation/linux_tv/media/v4l/dev-event.rst
+++ b/Documentation/linux_tv/media/v4l/dev-event.rst
@@ -14,9 +14,9 @@ events.
 
 To receive events, the events the user is interested in first must be
 subscribed using the
-:ref:`VIDIOC_SUBSCRIBE_EVENT <vidioc-subscribe-event>` ioctl. Once
+:ref:`VIDIOC_SUBSCRIBE_EVENT <VIDIOC_SUBSCRIBE_EVENT>` ioctl. Once
 an event is subscribed, the events of subscribed types are dequeueable
-using the :ref:`VIDIOC_DQEVENT <vidioc-dqevent>` ioctl. Events may be
+using the :ref:`VIDIOC_DQEVENT <VIDIOC_DQEVENT>` ioctl. Events may be
 unsubscribed using VIDIOC_UNSUBSCRIBE_EVENT ioctl. The special event
 type V4L2_EVENT_ALL may be used to unsubscribe all the events the
 driver supports.
diff --git a/Documentation/linux_tv/media/v4l/dev-osd.rst b/Documentation/linux_tv/media/v4l/dev-osd.rst
index 077e2cdc598d..93fb8f309091 100644
--- a/Documentation/linux_tv/media/v4l/dev-osd.rst
+++ b/Documentation/linux_tv/media/v4l/dev-osd.rst
@@ -17,7 +17,7 @@ The OSD function is accessible through the same character special file
 as the :ref:`Video Output <capture>` function. Note the default
 function of such a ``/dev/video`` device is video capturing or output.
 The OSD function is only available after calling the
-:ref:`VIDIOC_S_FMT <vidioc-g-fmt>` ioctl.
+:ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl.
 
 
 Querying Capabilities
@@ -26,7 +26,7 @@ Querying Capabilities
 Devices supporting the *Video Output Overlay* interface set the
 ``V4L2_CAP_VIDEO_OUTPUT_OVERLAY`` flag in the ``capabilities`` field of
 struct :ref:`v4l2_capability <v4l2-capability>` returned by the
-:ref:`VIDIOC_QUERYCAP <vidioc-querycap>` ioctl.
+:ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>` ioctl.
 
 
 Framebuffer
@@ -36,7 +36,7 @@ Contrary to the *Video Overlay* interface the framebuffer is normally
 implemented on the TV card and not the graphics card. On Linux it is
 accessible as a framebuffer device (``/dev/fbN``). Given a V4L2 device,
 applications can find the corresponding framebuffer device by calling
-the :ref:`VIDIOC_G_FBUF <vidioc-g-fbuf>` ioctl. It returns, amongst
+the :ref:`VIDIOC_G_FBUF <VIDIOC_G_FBUF>` ioctl. It returns, amongst
 other information, the physical address of the framebuffer in the
 ``base`` field of struct :ref:`v4l2_framebuffer <v4l2-framebuffer>`.
 The framebuffer device ioctl ``FBIOGET_FSCREENINFO`` returns the same
@@ -115,17 +115,17 @@ clipping/blending method to be used for the overlay. To get the current
 parameters applications set the ``type`` field of a struct
 :ref:`v4l2_format <v4l2-format>` to
 ``V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY`` and call the
-:ref:`VIDIOC_G_FMT <vidioc-g-fmt>` ioctl. The driver fills the
+:ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` ioctl. The driver fills the
 :c:type:`struct v4l2_window` substructure named ``win``. It is not
 possible to retrieve a previously programmed clipping list or bitmap.
 
 To program the source rectangle applications set the ``type`` field of a
 struct :ref:`v4l2_format <v4l2-format>` to
 ``V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY``, initialize the ``win``
-substructure and call the :ref:`VIDIOC_S_FMT <vidioc-g-fmt>` ioctl.
+substructure and call the :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl.
 The driver adjusts the parameters against hardware limits and returns
 the actual parameters as ``VIDIOC_G_FMT`` does. Like ``VIDIOC_S_FMT``,
-the :ref:`VIDIOC_TRY_FMT <vidioc-g-fmt>` ioctl can be used to learn
+the :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` ioctl can be used to learn
 about driver capabilities without actually changing driver state. Unlike
 ``VIDIOC_S_FMT`` this also works after the overlay has been enabled.
 
diff --git a/Documentation/linux_tv/media/v4l/dev-output.rst b/Documentation/linux_tv/media/v4l/dev-output.rst
index 0d46d59304b9..3efbbcc3c093 100644
--- a/Documentation/linux_tv/media/v4l/dev-output.rst
+++ b/Documentation/linux_tv/media/v4l/dev-output.rst
@@ -24,7 +24,7 @@ Devices supporting the video output interface set the
 ``V4L2_CAP_VIDEO_OUTPUT`` or ``V4L2_CAP_VIDEO_OUTPUT_MPLANE`` flag in
 the ``capabilities`` field of struct
 :ref:`v4l2_capability <v4l2-capability>` returned by the
-:ref:`VIDIOC_QUERYCAP <vidioc-querycap>` ioctl. As secondary device
+:ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>` ioctl. As secondary device
 functions they may also support the :ref:`raw VBI output <raw-vbi>`
 (``V4L2_CAP_VBI_OUTPUT``) interface. At least one of the read/write or
 streaming I/O methods must be supported. Modulators and audio outputs
@@ -62,7 +62,7 @@ defaults. An example is given in :ref:`crop`.
 To query the current image format applications set the ``type`` field of
 a struct :ref:`v4l2_format <v4l2-format>` to
 ``V4L2_BUF_TYPE_VIDEO_OUTPUT`` or ``V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE``
-and call the :ref:`VIDIOC_G_FMT <vidioc-g-fmt>` ioctl with a pointer
+and call the :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` ioctl with a pointer
 to this structure. Drivers fill the struct
 :ref:`v4l2_pix_format <v4l2-pix-format>` ``pix`` or the struct
 :ref:`v4l2_pix_format_mplane <v4l2-pix-format-mplane>` ``pix_mp``
@@ -72,12 +72,12 @@ To request different parameters applications set the ``type`` field of a
 struct :ref:`v4l2_format <v4l2-format>` as above and initialize all
 fields of the struct :ref:`v4l2_pix_format <v4l2-pix-format>`
 ``vbi`` member of the ``fmt`` union, or better just modify the results
-of ``VIDIOC_G_FMT``, and call the :ref:`VIDIOC_S_FMT <vidioc-g-fmt>`
+of ``VIDIOC_G_FMT``, and call the :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`
 ioctl with a pointer to this structure. Drivers may adjust the
 parameters and finally return the actual parameters as ``VIDIOC_G_FMT``
 does.
 
-Like ``VIDIOC_S_FMT`` the :ref:`VIDIOC_TRY_FMT <vidioc-g-fmt>` ioctl
+Like ``VIDIOC_S_FMT`` the :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` ioctl
 can be used to learn about hardware limitations without disabling I/O or
 possibly time consuming hardware preparations.
 
diff --git a/Documentation/linux_tv/media/v4l/dev-overlay.rst b/Documentation/linux_tv/media/v4l/dev-overlay.rst
index 50aed591284b..8a81e19a5d7c 100644
--- a/Documentation/linux_tv/media/v4l/dev-overlay.rst
+++ b/Documentation/linux_tv/media/v4l/dev-overlay.rst
@@ -20,7 +20,7 @@ Video overlay devices are accessed through the same character special
 files as :ref:`video capture <capture>` devices. Note the default
 function of a ``/dev/video`` device is video capturing. The overlay
 function is only available after calling the
-:ref:`VIDIOC_S_FMT <vidioc-g-fmt>` ioctl.
+:ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl.
 
 The driver may support simultaneous overlay and capturing using the
 read/write and streaming I/O methods. If so, operation at the nominal
@@ -41,7 +41,7 @@ Querying Capabilities
 Devices supporting the video overlay interface set the
 ``V4L2_CAP_VIDEO_OVERLAY`` flag in the ``capabilities`` field of struct
 :ref:`v4l2_capability <v4l2-capability>` returned by the
-:ref:`VIDIOC_QUERYCAP <vidioc-querycap>` ioctl. The overlay I/O
+:ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>` ioctl. The overlay I/O
 method specified below must be supported. Tuners and audio inputs are
 optional.
 
@@ -63,8 +63,8 @@ Setup
 Before overlay can commence applications must program the driver with
 frame buffer parameters, namely the address and size of the frame buffer
 and the image format, for example RGB 5:6:5. The
-:ref:`VIDIOC_G_FBUF <vidioc-g-fbuf>` and
-:ref:`VIDIOC_S_FBUF <vidioc-g-fbuf>` ioctls are available to get and
+:ref:`VIDIOC_G_FBUF <VIDIOC_G_FBUF>` and
+:ref:`VIDIOC_S_FBUF <VIDIOC_G_FBUF>` ioctls are available to get and
 set these parameters, respectively. The ``VIDIOC_S_FBUF`` ioctl is
 privileged because it allows to set up DMA into physical memory,
 bypassing the memory protection mechanisms of the kernel. Only the
@@ -101,8 +101,8 @@ A driver may support any (or none) of five clipping/blending methods:
 When simultaneous capturing and overlay is supported and the hardware
 prohibits different image and frame buffer formats, the format requested
 first takes precedence. The attempt to capture
-(:ref:`VIDIOC_S_FMT <vidioc-g-fmt>`) or overlay
-(:ref:`VIDIOC_S_FBUF <vidioc-g-fbuf>`) may fail with an EBUSY error
+(:ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`) or overlay
+(:ref:`VIDIOC_S_FBUF <VIDIOC_G_FBUF>`) may fail with an EBUSY error
 code or return accordingly modified parameters..
 
 
@@ -121,17 +121,17 @@ its position over the graphics surface and the clipping to be applied.
 To get the current parameters applications set the ``type`` field of a
 struct :ref:`v4l2_format <v4l2-format>` to
 ``V4L2_BUF_TYPE_VIDEO_OVERLAY`` and call the
-:ref:`VIDIOC_G_FMT <vidioc-g-fmt>` ioctl. The driver fills the
+:ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` ioctl. The driver fills the
 :c:type:`struct v4l2_window` substructure named ``win``. It is not
 possible to retrieve a previously programmed clipping list or bitmap.
 
 To program the overlay window applications set the ``type`` field of a
 struct :ref:`v4l2_format <v4l2-format>` to
 ``V4L2_BUF_TYPE_VIDEO_OVERLAY``, initialize the ``win`` substructure and
-call the :ref:`VIDIOC_S_FMT <vidioc-g-fmt>` ioctl. The driver
+call the :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl. The driver
 adjusts the parameters against hardware limits and returns the actual
 parameters as ``VIDIOC_G_FMT`` does. Like ``VIDIOC_S_FMT``, the
-:ref:`VIDIOC_TRY_FMT <vidioc-g-fmt>` ioctl can be used to learn
+:ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` ioctl can be used to learn
 about driver capabilities without actually changing driver state. Unlike
 ``VIDIOC_S_FMT`` this also works after the overlay has been enabled.
 
@@ -142,7 +142,7 @@ of the cropping rectangle. For more information see :ref:`crop`.
 When simultaneous capturing and overlay is supported and the hardware
 prohibits different image and window sizes, the size requested first
 takes precedence. The attempt to capture or overlay as well
-(:ref:`VIDIOC_S_FMT <vidioc-g-fmt>`) may fail with an EBUSY error
+(:ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`) may fail with an EBUSY error
 code or return accordingly modified parameters.
 
 
@@ -154,7 +154,7 @@ struct v4l2_window
 ``struct v4l2_rect w``
     Size and position of the window relative to the top, left corner of
     the frame buffer defined with
-    :ref:`VIDIOC_S_FBUF <vidioc-g-fbuf>`. The window can extend the
+    :ref:`VIDIOC_S_FBUF <VIDIOC_G_FBUF>`. The window can extend the
     frame buffer width and height, the ``x`` and ``y`` coordinates can
     be negative, and it can lie completely outside the frame buffer. The
     driver clips the window accordingly, or if that is not possible,
@@ -169,7 +169,7 @@ struct v4l2_window
 
 ``__u32 chromakey``
     When chroma-keying has been negotiated with
-    :ref:`VIDIOC_S_FBUF <vidioc-g-fbuf>` applications set this field
+    :ref:`VIDIOC_S_FBUF <VIDIOC_G_FBUF>` applications set this field
     to the desired pixel value for the chroma key. The format is the
     same as the pixel format of the framebuffer (struct
     :ref:`v4l2_framebuffer <v4l2-framebuffer>` ``fmt.pixelformat``
@@ -179,7 +179,7 @@ struct v4l2_window
 
 ``struct v4l2_clip * clips``
     When chroma-keying has *not* been negotiated and
-    :ref:`VIDIOC_G_FBUF <vidioc-g-fbuf>` indicated this capability,
+    :ref:`VIDIOC_G_FBUF <VIDIOC_G_FBUF>` indicated this capability,
     applications can set this field to point to an array of clipping
     rectangles.
 
@@ -192,7 +192,7 @@ applications should merge adjacent rectangles. Whether this must create
 x-y or y-x bands, or the order of rectangles, is not defined. When clip
 lists are not supported the driver ignores this field. Its contents
 after calling
-!ri!:ref:`VIDIOC_S_FMT <vidioc-g-fmt>`
+!ri!:ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`
 are undefined.
 
 ``__u32 clipcount``
@@ -204,7 +204,7 @@ are undefined.
 
 ``void * bitmap``
     When chroma-keying has *not* been negotiated and
-    :ref:`VIDIOC_G_FBUF <vidioc-g-fbuf>` indicated this capability,
+    :ref:`VIDIOC_G_FBUF <VIDIOC_G_FBUF>` indicated this capability,
     applications can set this field to point to a clipping bit mask.
 
 It must be of the same size as the window, ``w.width`` and ``w.height``.
@@ -220,7 +220,7 @@ bits like:
 where ``0`` ≤ x < ``w.width`` and ``0`` ≤ y <``w.height``. [2]_
 
 When a clipping bit mask is not supported the driver ignores this field,
-its contents after calling :ref:`VIDIOC_S_FMT <vidioc-g-fmt>` are
+its contents after calling :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` are
 undefined. When a bit mask is supported but no clipping is desired this
 field must be set to ``NULL``.
 
@@ -234,12 +234,12 @@ exceeded are undefined. [3]_
     The global alpha value used to blend the framebuffer with video
     images, if global alpha blending has been negotiated
     (``V4L2_FBUF_FLAG_GLOBAL_ALPHA``, see
-    :ref:`VIDIOC_S_FBUF <vidioc-g-fbuf>`,
+    :ref:`VIDIOC_S_FBUF <VIDIOC_G_FBUF>`,
     :ref:`framebuffer-flags`).
 
 Note this field was added in Linux 2.6.23, extending the structure.
 However the
-!ri!:ref:`VIDIOC_G/S/TRY_FMT <vidioc-g-fmt>`
+!ri!:ref:`VIDIOC_G/S/TRY_FMT <VIDIOC_G_FMT>`
 ioctls, which take a pointer to a
 !ri!:ref:`v4l2_format <v4l2-format>`
 parent structure with padding bytes at the end, are not affected.
@@ -289,7 +289,7 @@ Enabling Overlay
 ================
 
 To start or stop the frame buffer overlay applications call the
-:ref:`VIDIOC_OVERLAY <vidioc-overlay>` ioctl.
+:ref:`VIDIOC_OVERLAY <VIDIOC_OVERLAY>` ioctl.
 
 .. [1]
    A common application of two file descriptors is the XFree86
diff --git a/Documentation/linux_tv/media/v4l/dev-radio.rst b/Documentation/linux_tv/media/v4l/dev-radio.rst
index 672540105a66..955173aaf48e 100644
--- a/Documentation/linux_tv/media/v4l/dev-radio.rst
+++ b/Documentation/linux_tv/media/v4l/dev-radio.rst
@@ -21,7 +21,7 @@ Devices supporting the radio interface set the ``V4L2_CAP_RADIO`` and
 ``V4L2_CAP_TUNER`` or ``V4L2_CAP_MODULATOR`` flag in the
 ``capabilities`` field of struct
 :ref:`v4l2_capability <v4l2-capability>` returned by the
-:ref:`VIDIOC_QUERYCAP <vidioc-querycap>` ioctl. Other combinations of
+:ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>` ioctl. Other combinations of
 capability flags are reserved for future extensions.
 
 
@@ -47,8 +47,8 @@ discussed in :ref:`tuner`) with index number zero to select the radio
 frequency and to determine if a monaural or FM stereo program is
 received/emitted. Drivers switch automatically between AM and FM
 depending on the selected frequency. The
-:ref:`VIDIOC_G_TUNER <vidioc-g-tuner>` or
-:ref:`VIDIOC_G_MODULATOR <vidioc-g-modulator>` ioctl reports the
+:ref:`VIDIOC_G_TUNER <VIDIOC_G_TUNER>` or
+:ref:`VIDIOC_G_MODULATOR <VIDIOC_G_MODULATOR>` ioctl reports the
 supported frequency range.
 
 
diff --git a/Documentation/linux_tv/media/v4l/dev-raw-vbi.rst b/Documentation/linux_tv/media/v4l/dev-raw-vbi.rst
index 9ab5c4a4cad7..883ac4fbaeb6 100644
--- a/Documentation/linux_tv/media/v4l/dev-raw-vbi.rst
+++ b/Documentation/linux_tv/media/v4l/dev-raw-vbi.rst
@@ -28,7 +28,7 @@ applies to both input and output devices.
 To address the problems of finding related video and VBI devices VBI
 capturing and output is also available as device function under
 ``/dev/video``. To capture or output raw VBI data with these devices
-applications must call the :ref:`VIDIOC_S_FMT <vidioc-g-fmt>` ioctl.
+applications must call the :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl.
 Accessed as ``/dev/vbi``, raw VBI capturing or output is the default
 device function.
 
@@ -40,7 +40,7 @@ Devices supporting the raw VBI capturing or output API set the
 ``V4L2_CAP_VBI_CAPTURE`` or ``V4L2_CAP_VBI_OUTPUT`` flags, respectively,
 in the ``capabilities`` field of struct
 :ref:`v4l2_capability <v4l2-capability>` returned by the
-:ref:`VIDIOC_QUERYCAP <vidioc-querycap>` ioctl. At least one of the
+:ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>` ioctl. At least one of the
 read/write, streaming or asynchronous I/O methods must be supported. VBI
 devices may or may not have a tuner or modulator.
 
@@ -71,7 +71,7 @@ parameters and then checking if the actual parameters are suitable.
 To query the current raw VBI capture parameters applications set the
 ``type`` field of a struct :ref:`v4l2_format <v4l2-format>` to
 ``V4L2_BUF_TYPE_VBI_CAPTURE`` or ``V4L2_BUF_TYPE_VBI_OUTPUT``, and call
-the :ref:`VIDIOC_G_FMT <vidioc-g-fmt>` ioctl with a pointer to this
+the :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` ioctl with a pointer to this
 structure. Drivers fill the struct
 :ref:`v4l2_vbi_format <v4l2-vbi-format>` ``vbi`` member of the
 ``fmt`` union.
@@ -80,7 +80,7 @@ To request different parameters applications set the ``type`` field of a
 struct :ref:`v4l2_format <v4l2-format>` as above and initialize all
 fields of the struct :ref:`v4l2_vbi_format <v4l2-vbi-format>`
 ``vbi`` member of the ``fmt`` union, or better just modify the results
-of ``VIDIOC_G_FMT``, and call the :ref:`VIDIOC_S_FMT <vidioc-g-fmt>`
+of ``VIDIOC_G_FMT``, and call the :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`
 ioctl with a pointer to this structure. Drivers return an EINVAL error
 code only when the given parameters are ambiguous, otherwise they modify
 the parameters according to the hardware capabilities and return the
@@ -91,7 +91,7 @@ happen for instance when the video and VBI areas to capture would
 overlap, or when the driver supports multiple opens and another process
 already requested VBI capturing or output. Anyway, applications must
 expect other resource allocation points which may return EBUSY, at the
-:ref:`VIDIOC_STREAMON <vidioc-streamon>` ioctl and the first read(),
+:ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>` ioctl and the first read(),
 write() and select() call.
 
 VBI devices must implement both the ``VIDIOC_G_FMT`` and
@@ -339,7 +339,7 @@ A VBI device may support :ref:`read/write <rw>` and/or streaming
 The latter bears the possibility of synchronizing video and VBI data by
 using buffer timestamps.
 
-Remember the :ref:`VIDIOC_STREAMON <vidioc-streamon>` ioctl and the
+Remember the :ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>` ioctl and the
 first read(), write() and select() call can be resource allocation
 points returning an EBUSY error code if the required hardware resources
 are temporarily unavailable, for example the device is already in use by
diff --git a/Documentation/linux_tv/media/v4l/dev-rds.rst b/Documentation/linux_tv/media/v4l/dev-rds.rst
index 498752aa5eaf..af20f8fa1cdf 100644
--- a/Documentation/linux_tv/media/v4l/dev-rds.rst
+++ b/Documentation/linux_tv/media/v4l/dev-rds.rst
@@ -33,7 +33,7 @@ Querying Capabilities
 Devices supporting the RDS capturing API set the
 ``V4L2_CAP_RDS_CAPTURE`` flag in the ``capabilities`` field of struct
 :ref:`v4l2_capability <v4l2-capability>` returned by the
-:ref:`VIDIOC_QUERYCAP <vidioc-querycap>` ioctl. Any tuner that
+:ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>` ioctl. Any tuner that
 supports RDS will set the ``V4L2_TUNER_CAP_RDS`` flag in the
 ``capability`` field of struct :ref:`v4l2_tuner <v4l2-tuner>`. If the
 driver only passes RDS blocks without interpreting the data the
@@ -52,7 +52,7 @@ Whether an RDS signal is present can be detected by looking at the
 Devices supporting the RDS output API set the ``V4L2_CAP_RDS_OUTPUT``
 flag in the ``capabilities`` field of struct
 :ref:`v4l2_capability <v4l2-capability>` returned by the
-:ref:`VIDIOC_QUERYCAP <vidioc-querycap>` ioctl. Any modulator that
+:ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>` ioctl. Any modulator that
 supports RDS will set the ``V4L2_TUNER_CAP_RDS`` flag in the
 ``capability`` field of struct
 :ref:`v4l2_modulator <v4l2-modulator>`. In order to enable the RDS
diff --git a/Documentation/linux_tv/media/v4l/dev-sdr.rst b/Documentation/linux_tv/media/v4l/dev-sdr.rst
index 8e9e34b8d53a..5e4f7030f644 100644
--- a/Documentation/linux_tv/media/v4l/dev-sdr.rst
+++ b/Documentation/linux_tv/media/v4l/dev-sdr.rst
@@ -22,7 +22,7 @@ Devices supporting the SDR receiver interface set the
 ``V4L2_CAP_SDR_CAPTURE`` and ``V4L2_CAP_TUNER`` flag in the
 ``capabilities`` field of struct
 :ref:`v4l2_capability <v4l2-capability>` returned by the
-:ref:`VIDIOC_QUERYCAP <vidioc-querycap>` ioctl. That flag means the
+:ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>` ioctl. That flag means the
 device has an Analog to Digital Converter (ADC), which is a mandatory
 element for the SDR receiver.
 
@@ -30,7 +30,7 @@ Devices supporting the SDR transmitter interface set the
 ``V4L2_CAP_SDR_OUTPUT`` and ``V4L2_CAP_MODULATOR`` flag in the
 ``capabilities`` field of struct
 :ref:`v4l2_capability <v4l2-capability>` returned by the
-:ref:`VIDIOC_QUERYCAP <vidioc-querycap>` ioctl. That flag means the
+:ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>` ioctl. That flag means the
 device has an Digital to Analog Converter (DAC), which is a mandatory
 element for the SDR transmitter.
 
@@ -52,7 +52,7 @@ radio frequency. The tuner index of the RF tuner (if any) must always
 follow the SDR tuner index. Normally the SDR tuner is #0 and the RF
 tuner is #1.
 
-The :ref:`VIDIOC_S_HW_FREQ_SEEK <vidioc-s-hw-freq-seek>` ioctl is
+The :ref:`VIDIOC_S_HW_FREQ_SEEK <VIDIOC_S_HW_FREQ_SEEK>` ioctl is
 not supported.
 
 
@@ -63,7 +63,7 @@ The SDR device uses the :ref:`format <format>` ioctls to select the
 capture and output format. Both the sampling resolution and the data
 streaming format are bound to that selectable format. In addition to the
 basic :ref:`format <format>` ioctls, the
-:ref:`VIDIOC_ENUM_FMT <vidioc-enum-fmt>` ioctl must be supported as
+:ref:`VIDIOC_ENUM_FMT <VIDIOC_ENUM_FMT>` ioctl must be supported as
 well.
 
 To use the :ref:`format <format>` ioctls applications set the ``type``
diff --git a/Documentation/linux_tv/media/v4l/dev-sliced-vbi.rst b/Documentation/linux_tv/media/v4l/dev-sliced-vbi.rst
index 90d879964f52..0faf178168e4 100644
--- a/Documentation/linux_tv/media/v4l/dev-sliced-vbi.rst
+++ b/Documentation/linux_tv/media/v4l/dev-sliced-vbi.rst
@@ -21,7 +21,7 @@ Sliced VBI capture and output devices are accessed through the same
 character special files as raw VBI devices. When a driver supports both
 interfaces, the default function of a ``/dev/vbi`` device is *raw* VBI
 capturing or output, and the sliced VBI function is only available after
-calling the :ref:`VIDIOC_S_FMT <vidioc-g-fmt>` ioctl as defined
+calling the :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl as defined
 below. Likewise a ``/dev/video`` device may support the sliced VBI API,
 however the default function here is video capturing or output.
 Different file descriptors must be used to pass raw and sliced VBI data
@@ -35,7 +35,7 @@ Devices supporting the sliced VBI capturing or output API set the
 ``V4L2_CAP_SLICED_VBI_CAPTURE`` or ``V4L2_CAP_SLICED_VBI_OUTPUT`` flag
 respectively, in the ``capabilities`` field of struct
 :ref:`v4l2_capability <v4l2-capability>` returned by the
-:ref:`VIDIOC_QUERYCAP <vidioc-querycap>` ioctl. At least one of the
+:ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>` ioctl. At least one of the
 read/write, streaming or asynchronous :ref:`I/O methods <io>` must be
 supported. Sliced VBI devices may have a tuner or modulator.
 
@@ -57,10 +57,10 @@ Sliced VBI Format Negotiation
 
 To find out which data services are supported by the hardware
 applications can call the
-:ref:`VIDIOC_G_SLICED_VBI_CAP <vidioc-g-sliced-vbi-cap>` ioctl.
+:ref:`VIDIOC_G_SLICED_VBI_CAP <VIDIOC_G_SLICED_VBI_CAP>` ioctl.
 All drivers implementing the sliced VBI interface must support this
 ioctl. The results may differ from those of the
-:ref:`VIDIOC_S_FMT <vidioc-g-fmt>` ioctl when the number of VBI
+:ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl when the number of VBI
 lines the hardware can capture or output per frame, or the number of
 services it can identify on a given line are limited. For example on PAL
 line 16 the hardware may be able to look for a VPS or Teletext signal,
@@ -70,13 +70,13 @@ To determine the currently selected services applications set the
 ``type`` field of struct :ref:`v4l2_format <v4l2-format>` to
 ``V4L2_BUF_TYPE_SLICED_VBI_CAPTURE`` or
 ``V4L2_BUF_TYPE_SLICED_VBI_OUTPUT``, and the
-:ref:`VIDIOC_G_FMT <vidioc-g-fmt>` ioctl fills the ``fmt.sliced``
+:ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` ioctl fills the ``fmt.sliced``
 member, a struct
 :ref:`v4l2_sliced_vbi_format <v4l2-sliced-vbi-format>`.
 
 Applications can request different parameters by initializing or
 modifying the ``fmt.sliced`` member and calling the
-:ref:`VIDIOC_S_FMT <vidioc-g-fmt>` ioctl with a pointer to the
+:ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl with a pointer to the
 :c:type:`struct v4l2_format` structure.
 
 The sliced VBI API is more complicated than the raw VBI API because the
@@ -90,12 +90,12 @@ array according to hardware capabilities. Only if more precise control
 is needed should the programmer set the ``service_lines`` array
 explicitly.
 
-The :ref:`VIDIOC_S_FMT <vidioc-g-fmt>` ioctl modifies the parameters
+The :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl modifies the parameters
 according to hardware capabilities. When the driver allocates resources
 at this point, it may return an EBUSY error code if the required
 resources are temporarily unavailable. Other resource allocation points
 which may return EBUSY can be the
-:ref:`VIDIOC_STREAMON <vidioc-streamon>` ioctl and the first
+:ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>` ioctl and the first
 :ref:`read() <func-read>`, :ref:`write() <func-write>` and
 :ref:`select() <func-select>` call.
 
@@ -117,8 +117,8 @@ which may return EBUSY can be the
        -  :cspan:`2`
 
           If ``service_set`` is non-zero when passed with
-          :ref:`VIDIOC_S_FMT <vidioc-g-fmt>` or
-          :ref:`VIDIOC_TRY_FMT <vidioc-g-fmt>`, the ``service_lines``
+          :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` or
+          :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>`, the ``service_lines``
           array will be filled by the driver according to the services
           specified in this field. For example, if ``service_set`` is
           initialized with ``V4L2_SLICED_TELETEXT_B | V4L2_SLICED_WSS_625``,
@@ -224,8 +224,8 @@ which may return EBUSY can be the
        -  :cspan:`2` Maximum number of bytes passed by one
           :ref:`read() <func-read>` or :ref:`write() <func-write>` call,
           and the buffer size in bytes for the
-          :ref:`VIDIOC_QBUF <vidioc-qbuf>` and
-          :ref:`VIDIOC_DQBUF <vidioc-qbuf>` ioctl. Drivers set this field
+          :ref:`VIDIOC_QBUF <VIDIOC_QBUF>` and
+          :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctl. Drivers set this field
           to the size of struct
           :ref:`v4l2_sliced_vbi_data <v4l2-sliced-vbi-data>` times the
           number of non-zero elements in the returned ``service_lines``
@@ -340,11 +340,11 @@ Drivers may return an EINVAL error code when applications attempt to
 read or write data without prior format negotiation, after switching the
 video standard (which may invalidate the negotiated VBI parameters) and
 after switching the video input (which may change the video standard as
-a side effect). The :ref:`VIDIOC_S_FMT <vidioc-g-fmt>` ioctl may
+a side effect). The :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl may
 return an EBUSY error code when applications attempt to change the
 format while i/o is in progress (between a
-:ref:`VIDIOC_STREAMON <vidioc-streamon>` and
-:ref:`VIDIOC_STREAMOFF <vidioc-streamon>` call, and after the first
+:ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>` and
+:ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` call, and after the first
 :ref:`read() <func-read>` or :ref:`write() <func-write>` call).
 
 
@@ -428,12 +428,12 @@ of one video frame. The ``id`` of unused
 
 Packets are always passed in ascending line number order, without
 duplicate line numbers. The :ref:`write() <func-write>` function and
-the :ref:`VIDIOC_QBUF <vidioc-qbuf>` ioctl must return an EINVAL
+the :ref:`VIDIOC_QBUF <VIDIOC_QBUF>` ioctl must return an EINVAL
 error code when applications violate this rule. They must also return an
 EINVAL error code when applications pass an incorrect field or line
 number, or a combination of ``field``, ``line`` and ``id`` which has not
-been negotiated with the :ref:`VIDIOC_G_FMT <vidioc-g-fmt>` or
-:ref:`VIDIOC_S_FMT <vidioc-g-fmt>` ioctl. When the line numbers are
+been negotiated with the :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` or
+:ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl. When the line numbers are
 unknown the driver must pass the packets in transmitted order. The
 driver can insert empty packets with ``id`` set to zero anywhere in the
 packet array.
diff --git a/Documentation/linux_tv/media/v4l/dev-subdev.rst b/Documentation/linux_tv/media/v4l/dev-subdev.rst
index 66274eafd437..1fe594c0026f 100644
--- a/Documentation/linux_tv/media/v4l/dev-subdev.rst
+++ b/Documentation/linux_tv/media/v4l/dev-subdev.rst
@@ -86,7 +86,7 @@ Pad-level Formats
 
 Image formats are typically negotiated on video capture and output
 devices using the format and
-:ref:`selection <vidioc-subdev-g-selection>` ioctls. The driver is
+:ref:`selection <VIDIOC_SUBDEV_G_SELECTION>` ioctls. The driver is
 responsible for configuring every block in the video pipeline according
 to the requested format at the pipeline input and/or output.
 
@@ -118,18 +118,18 @@ every point in the pipeline explicitly.
 Drivers that implement the :ref:`media API <media-controller-intro>`
 can expose pad-level image format configuration to applications. When
 they do, applications can use the
-:ref:`VIDIOC_SUBDEV_G_FMT <vidioc-subdev-g-fmt>` and
-:ref:`VIDIOC_SUBDEV_S_FMT <vidioc-subdev-g-fmt>` ioctls. to
+:ref:`VIDIOC_SUBDEV_G_FMT <VIDIOC_SUBDEV_G_FMT>` and
+:ref:`VIDIOC_SUBDEV_S_FMT <VIDIOC_SUBDEV_G_FMT>` ioctls. to
 negotiate formats on a per-pad basis.
 
 Applications are responsible for configuring coherent parameters on the
 whole pipeline and making sure that connected pads have compatible
 formats. The pipeline is checked for formats mismatch at
-:ref:`VIDIOC_STREAMON <vidioc-streamon>` time, and an EPIPE error
+:ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>` time, and an EPIPE error
 code is then returned if the configuration is invalid.
 
 Pad-level image format configuration support can be tested by calling
-the :ref:`VIDIOC_SUBDEV_G_FMT <vidioc-subdev-g-fmt>` ioctl on pad
+the :ref:`VIDIOC_SUBDEV_G_FMT <VIDIOC_SUBDEV_G_FMT>` ioctl on pad
 0. If the driver returns an EINVAL error code pad-level format
 configuration is not supported by the sub-device.
 
@@ -146,8 +146,8 @@ formats enumeration only. A format negotiation mechanism is required.
 Central to the format negotiation mechanism are the get/set format
 operations. When called with the ``which`` argument set to
 ``V4L2_SUBDEV_FORMAT_TRY``, the
-:ref:`VIDIOC_SUBDEV_G_FMT <vidioc-subdev-g-fmt>` and
-:ref:`VIDIOC_SUBDEV_S_FMT <vidioc-subdev-g-fmt>` ioctls operate on
+:ref:`VIDIOC_SUBDEV_G_FMT <VIDIOC_SUBDEV_G_FMT>` and
+:ref:`VIDIOC_SUBDEV_S_FMT <VIDIOC_SUBDEV_G_FMT>` ioctls operate on
 a set of formats parameters that are not connected to the hardware
 configuration. Modifying those 'try' formats leaves the device state
 untouched (this applies to both the software state stored in the driver
@@ -155,14 +155,14 @@ and the hardware state stored in the device itself).
 
 While not kept as part of the device state, try formats are stored in
 the sub-device file handles. A
-:ref:`VIDIOC_SUBDEV_G_FMT <vidioc-subdev-g-fmt>` call will return
+:ref:`VIDIOC_SUBDEV_G_FMT <VIDIOC_SUBDEV_G_FMT>` call will return
 the last try format set *on the same sub-device file handle*. Several
 applications querying the same sub-device at the same time will thus not
 interact with each other.
 
 To find out whether a particular format is supported by the device,
 applications use the
-:ref:`VIDIOC_SUBDEV_S_FMT <vidioc-subdev-g-fmt>` ioctl. Drivers
+:ref:`VIDIOC_SUBDEV_S_FMT <VIDIOC_SUBDEV_G_FMT>` ioctl. Drivers
 verify and, if needed, change the requested ``format`` based on device
 requirements and return the possibly modified value. Applications can
 then choose to try a different format or accept the returned value and
@@ -171,7 +171,7 @@ continue.
 Formats returned by the driver during a negotiation iteration are
 guaranteed to be supported by the device. In particular, drivers
 guarantee that a returned format will not be further changed if passed
-to an :ref:`VIDIOC_SUBDEV_S_FMT <vidioc-subdev-g-fmt>` call as-is
+to an :ref:`VIDIOC_SUBDEV_S_FMT <VIDIOC_SUBDEV_G_FMT>` call as-is
 (as long as external parameters, such as formats on other pads or links'
 configuration are not changed).
 
@@ -353,7 +353,7 @@ struct :ref:`v4l2_rect <v4l2-rect>`.
 Scaling support is optional. When supported by a subdev, the crop
 rectangle on the subdev's sink pad is scaled to the size configured
 using the
-:ref:`VIDIOC_SUBDEV_S_SELECTION <vidioc-subdev-g-selection>` IOCTL
+:ref:`VIDIOC_SUBDEV_S_SELECTION <VIDIOC_SUBDEV_G_SELECTION>` IOCTL
 using ``V4L2_SEL_TGT_COMPOSE`` selection target on the same pad. If the
 subdev supports scaling but not composing, the top and left values are
 not used and must always be set to zero.
diff --git a/Documentation/linux_tv/media/v4l/diff-v4l.rst b/Documentation/linux_tv/media/v4l/diff-v4l.rst
index eef51e610c8b..0c4030d75c76 100644
--- a/Documentation/linux_tv/media/v4l/diff-v4l.rst
+++ b/Documentation/linux_tv/media/v4l/diff-v4l.rst
@@ -85,7 +85,7 @@ Querying Capabilities
 =====================
 
 The V4L ``VIDIOCGCAP`` ioctl is equivalent to V4L2's
-:ref:`VIDIOC_QUERYCAP <vidioc-querycap>`.
+:ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>`.
 
 The ``name`` field in struct :c:type:`struct video_capability` became
 ``card`` in struct :ref:`v4l2_capability <v4l2-capability>`, ``type``
@@ -182,8 +182,8 @@ introduction.
 
        -  This flag indicates if the hardware can scale images. The V4L2 API
           implies the scale factor by setting the cropping dimensions and
-          image size with the :ref:`VIDIOC_S_CROP <vidioc-g-crop>` and
-          :ref:`VIDIOC_S_FMT <vidioc-g-fmt>` ioctl, respectively. The
+          image size with the :ref:`VIDIOC_S_CROP <VIDIOC_G_CROP>` and
+          :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl, respectively. The
           driver returns the closest sizes possible. For more information on
           cropping and scaling see :ref:`crop`.
 
@@ -194,7 +194,7 @@ introduction.
        -  ``-``
 
        -  Applications can enumerate the supported image formats with the
-          :ref:`VIDIOC_ENUM_FMT <vidioc-enum-fmt>` ioctl to determine if
+          :ref:`VIDIOC_ENUM_FMT <VIDIOC_ENUM_FMT>` ioctl to determine if
           the device supports grey scale capturing only. For more
           information on image formats see :ref:`pixfmt`.
 
@@ -204,7 +204,7 @@ introduction.
 
        -  ``-``
 
-       -  Applications can call the :ref:`VIDIOC_G_CROP <vidioc-g-crop>`
+       -  Applications can call the :ref:`VIDIOC_G_CROP <VIDIOC_G_CROP>`
           ioctl to determine if the device supports capturing a subsection
           of the full picture ("cropping" in V4L2). If not, the ioctl
           returns the EINVAL error code. For more information on cropping
@@ -217,7 +217,7 @@ introduction.
        -  ``-``
 
        -  Applications can enumerate the supported image formats with the
-          :ref:`VIDIOC_ENUM_FMT <vidioc-enum-fmt>` ioctl to determine if
+          :ref:`VIDIOC_ENUM_FMT <VIDIOC_ENUM_FMT>` ioctl to determine if
           the device supports MPEG streams.
 
     -  .. row 13
@@ -248,12 +248,12 @@ introduction.
 The ``audios`` field was replaced by ``capabilities`` flag
 ``V4L2_CAP_AUDIO``, indicating *if* the device has any audio inputs or
 outputs. To determine their number applications can enumerate audio
-inputs with the :ref:`VIDIOC_G_AUDIO <vidioc-g-audio>` ioctl. The
+inputs with the :ref:`VIDIOC_G_AUDIO <VIDIOC_G_AUDIO>` ioctl. The
 audio ioctls are described in :ref:`audio`.
 
 The ``maxwidth``, ``maxheight``, ``minwidth`` and ``minheight`` fields
-were removed. Calling the :ref:`VIDIOC_S_FMT <vidioc-g-fmt>` or
-:ref:`VIDIOC_TRY_FMT <vidioc-g-fmt>` ioctl with the desired
+were removed. Calling the :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` or
+:ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` ioctl with the desired
 dimensions returns the closest size possible, taking into account the
 current video standard, cropping and scaling limitations.
 
@@ -264,9 +264,9 @@ Video Sources
 V4L provides the ``VIDIOCGCHAN`` and ``VIDIOCSCHAN`` ioctl using struct
 :c:type:`struct video_channel` to enumerate the video inputs of a V4L
 device. The equivalent V4L2 ioctls are
-:ref:`VIDIOC_ENUMINPUT <vidioc-enuminput>`,
-:ref:`VIDIOC_G_INPUT <vidioc-g-input>` and
-:ref:`VIDIOC_S_INPUT <vidioc-g-input>` using struct
+:ref:`VIDIOC_ENUMINPUT <VIDIOC_ENUMINPUT>`,
+:ref:`VIDIOC_G_INPUT <VIDIOC_G_INPUT>` and
+:ref:`VIDIOC_S_INPUT <VIDIOC_G_INPUT>` using struct
 :ref:`v4l2_input <v4l2-input>` as discussed in :ref:`video`.
 
 The ``channel`` field counting inputs was renamed to ``index``, the
@@ -328,8 +328,8 @@ Tuning
 The V4L ``VIDIOCGTUNER`` and ``VIDIOCSTUNER`` ioctl and struct
 :c:type:`struct video_tuner` can be used to enumerate the tuners of a
 V4L TV or radio device. The equivalent V4L2 ioctls are
-:ref:`VIDIOC_G_TUNER <vidioc-g-tuner>` and
-:ref:`VIDIOC_S_TUNER <vidioc-g-tuner>` using struct
+:ref:`VIDIOC_G_TUNER <VIDIOC_G_TUNER>` and
+:ref:`VIDIOC_S_TUNER <VIDIOC_G_TUNER>` using struct
 :ref:`v4l2_tuner <v4l2-tuner>`. Tuners are covered in :ref:`tuner`.
 
 The ``tuner`` field counting tuners was renamed to ``index``. The fields
@@ -360,8 +360,8 @@ the struct :ref:`v4l2_tuner <v4l2-tuner>` ``capability`` field.
 
 The ``VIDIOCGFREQ`` and ``VIDIOCSFREQ`` ioctl to change the tuner
 frequency where renamed to
-:ref:`VIDIOC_G_FREQUENCY <vidioc-g-frequency>` and
-:ref:`VIDIOC_S_FREQUENCY <vidioc-g-frequency>`. They take a pointer
+:ref:`VIDIOC_G_FREQUENCY <VIDIOC_G_FREQUENCY>` and
+:ref:`VIDIOC_S_FREQUENCY <VIDIOC_G_FREQUENCY>`. They take a pointer
 to a struct :ref:`v4l2_frequency <v4l2-frequency>` instead of an
 unsigned long integer.
 
@@ -374,9 +374,9 @@ Image Properties
 V4L2 has no equivalent of the ``VIDIOCGPICT`` and ``VIDIOCSPICT`` ioctl
 and struct :c:type:`struct video_picture`. The following fields where
 replaced by V4L2 controls accessible with the
-:ref:`VIDIOC_QUERYCTRL <vidioc-queryctrl>`,
-:ref:`VIDIOC_G_CTRL <vidioc-g-ctrl>` and
-:ref:`VIDIOC_S_CTRL <vidioc-g-ctrl>` ioctls:
+:ref:`VIDIOC_QUERYCTRL <VIDIOC_QUERYCTRL>`,
+:ref:`VIDIOC_G_CTRL <VIDIOC_G_CTRL>` and
+:ref:`VIDIOC_S_CTRL <VIDIOC_G_CTRL>` ioctls:
 
 
 
@@ -425,7 +425,7 @@ replaced by V4L2 controls accessible with the
 The V4L picture controls are assumed to range from 0 to 65535 with no
 particular reset value. The V4L2 API permits arbitrary limits and
 defaults which can be queried with the
-:ref:`VIDIOC_QUERYCTRL <vidioc-queryctrl>` ioctl. For general
+:ref:`VIDIOC_QUERYCTRL <VIDIOC_QUERYCTRL>` ioctl. For general
 information about controls see :ref:`control`.
 
 The ``depth`` (average number of bits per pixel) of a video image is
@@ -545,7 +545,7 @@ into the struct :ref:`v4l2_pix_format <v4l2-pix-format>`:
 
 
 V4L2 image formats are defined in :ref:`pixfmt`. The image format can
-be selected with the :ref:`VIDIOC_S_FMT <vidioc-g-fmt>` ioctl.
+be selected with the :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl.
 
 
 Audio
@@ -554,8 +554,8 @@ Audio
 The ``VIDIOCGAUDIO`` and ``VIDIOCSAUDIO`` ioctl and struct
 :c:type:`struct video_audio` are used to enumerate the audio inputs
 of a V4L device. The equivalent V4L2 ioctls are
-:ref:`VIDIOC_G_AUDIO <vidioc-g-audio>` and
-:ref:`VIDIOC_S_AUDIO <vidioc-g-audio>` using struct
+:ref:`VIDIOC_G_AUDIO <VIDIOC_G_AUDIO>` and
+:ref:`VIDIOC_S_AUDIO <VIDIOC_G_AUDIO>` using struct
 :ref:`v4l2_audio <v4l2-audio>` as discussed in :ref:`audio`.
 
 The ``audio`` "channel number" field counting audio inputs was renamed
@@ -576,9 +576,9 @@ information on tuners. Related to audio modes struct
 stereo input, regardless if the source is a tuner.
 
 The following fields where replaced by V4L2 controls accessible with the
-:ref:`VIDIOC_QUERYCTRL <vidioc-queryctrl>`,
-:ref:`VIDIOC_G_CTRL <vidioc-g-ctrl>` and
-:ref:`VIDIOC_S_CTRL <vidioc-g-ctrl>` ioctls:
+:ref:`VIDIOC_QUERYCTRL <VIDIOC_QUERYCTRL>`,
+:ref:`VIDIOC_G_CTRL <VIDIOC_G_CTRL>` and
+:ref:`VIDIOC_S_CTRL <VIDIOC_G_CTRL>` ioctls:
 
 
 
@@ -621,7 +621,7 @@ The following fields where replaced by V4L2 controls accessible with the
 To determine which of these controls are supported by a driver V4L
 provides the ``flags`` ``VIDEO_AUDIO_VOLUME``, ``VIDEO_AUDIO_BASS``,
 ``VIDEO_AUDIO_TREBLE`` and ``VIDEO_AUDIO_BALANCE``. In the V4L2 API the
-:ref:`VIDIOC_QUERYCTRL <vidioc-queryctrl>` ioctl reports if the
+:ref:`VIDIOC_QUERYCTRL <VIDIOC_QUERYCTRL>` ioctl reports if the
 respective control is supported. Accordingly the ``VIDEO_AUDIO_MUTABLE``
 and ``VIDEO_AUDIO_MUTE`` flags where replaced by the boolean
 ``V4L2_CID_AUDIO_MUTE`` control.
@@ -630,7 +630,7 @@ All V4L2 controls have a ``step`` attribute replacing the struct
 :c:type:`struct video_audio` ``step`` field. The V4L audio controls
 are assumed to range from 0 to 65535 with no particular reset value. The
 V4L2 API permits arbitrary limits and defaults which can be queried with
-the :ref:`VIDIOC_QUERYCTRL <vidioc-queryctrl>` ioctl. For general
+the :ref:`VIDIOC_QUERYCTRL <VIDIOC_QUERYCTRL>` ioctl. For general
 information about controls see :ref:`control`.
 
 
@@ -638,8 +638,8 @@ Frame Buffer Overlay
 ====================
 
 The V4L2 ioctls equivalent to ``VIDIOCGFBUF`` and ``VIDIOCSFBUF`` are
-:ref:`VIDIOC_G_FBUF <vidioc-g-fbuf>` and
-:ref:`VIDIOC_S_FBUF <vidioc-g-fbuf>`. The ``base`` field of struct
+:ref:`VIDIOC_G_FBUF <VIDIOC_G_FBUF>` and
+:ref:`VIDIOC_S_FBUF <VIDIOC_G_FBUF>`. The ``base`` field of struct
 :c:type:`struct video_buffer` remained unchanged, except V4L2 defines
 a flag to indicate non-destructive overlays instead of a ``NULL``
 pointer. All other fields moved into the struct
@@ -650,8 +650,8 @@ list of RGB formats and their respective color depths.
 
 Instead of the special ioctls ``VIDIOCGWIN`` and ``VIDIOCSWIN`` V4L2
 uses the general-purpose data format negotiation ioctls
-:ref:`VIDIOC_G_FMT <vidioc-g-fmt>` and
-:ref:`VIDIOC_S_FMT <vidioc-g-fmt>`. They take a pointer to a struct
+:ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` and
+:ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`. They take a pointer to a struct
 :ref:`v4l2_format <v4l2-format>` as argument. Here the ``win`` member
 of the ``fmt`` union is used, a struct
 :ref:`v4l2_window <v4l2-window>`.
@@ -678,7 +678,7 @@ has a separate ``bitmap`` pointer field for this purpose and the bitmap
 size is determined by ``w.width`` and ``w.height``.
 
 The ``VIDIOCCAPTURE`` ioctl to enable or disable overlay was renamed to
-:ref:`VIDIOC_OVERLAY <vidioc-overlay>`.
+:ref:`VIDIOC_OVERLAY <VIDIOC_OVERLAY>`.
 
 
 Cropping
@@ -687,10 +687,10 @@ Cropping
 To capture only a subsection of the full picture V4L defines the
 ``VIDIOCGCAPTURE`` and ``VIDIOCSCAPTURE`` ioctls using struct
 :c:type:`struct video_capture`. The equivalent V4L2 ioctls are
-:ref:`VIDIOC_G_CROP <vidioc-g-crop>` and
-:ref:`VIDIOC_S_CROP <vidioc-g-crop>` using struct
+:ref:`VIDIOC_G_CROP <VIDIOC_G_CROP>` and
+:ref:`VIDIOC_S_CROP <VIDIOC_G_CROP>` using struct
 :ref:`v4l2_crop <v4l2-crop>`, and the related
-:ref:`VIDIOC_CROPCAP <vidioc-cropcap>` ioctl. This is a rather
+:ref:`VIDIOC_CROPCAP <VIDIOC_CROPCAP>` ioctl. This is a rather
 complex matter, see :ref:`crop` for details.
 
 The ``x``, ``y``, ``width`` and ``height`` fields moved into struct
@@ -705,7 +705,7 @@ only the odd or even field, respectively, were replaced by
 ``field`` of struct :ref:`v4l2_pix_format <v4l2-pix-format>` and
 struct :ref:`v4l2_window <v4l2-window>`. These structures are used to
 select a capture or overlay format with the
-:ref:`VIDIOC_S_FMT <vidioc-g-fmt>` ioctl.
+:ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl.
 
 
 Reading Images, Memory Mapping
@@ -719,15 +719,15 @@ There is no essential difference between reading images from a V4L or
 V4L2 device using the :ref:`read() <func-read>` function, however V4L2
 drivers are not required to support this I/O method. Applications can
 determine if the function is available with the
-:ref:`VIDIOC_QUERYCAP <vidioc-querycap>` ioctl. All V4L2 devices
+:ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>` ioctl. All V4L2 devices
 exchanging data with applications must support the
 :ref:`select() <func-select>` and :ref:`poll() <func-poll>`
 functions.
 
 To select an image format and size, V4L provides the ``VIDIOCSPICT`` and
 ``VIDIOCSWIN`` ioctls. V4L2 uses the general-purpose data format
-negotiation ioctls :ref:`VIDIOC_G_FMT <vidioc-g-fmt>` and
-:ref:`VIDIOC_S_FMT <vidioc-g-fmt>`. They take a pointer to a struct
+negotiation ioctls :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` and
+:ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`. They take a pointer to a struct
 :ref:`v4l2_format <v4l2-format>` as argument, here the struct
 :ref:`v4l2_pix_format <v4l2-pix-format>` named ``pix`` of its
 ``fmt`` union is used.
@@ -761,7 +761,7 @@ differences.
 
        -  
        -  The image format must be selected before buffers are allocated,
-          with the :ref:`VIDIOC_S_FMT <vidioc-g-fmt>` ioctl. When no
+          with the :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl. When no
           format is selected the driver may use the last, possibly by
           another application requested format.
 
@@ -771,7 +771,7 @@ differences.
           into the driver, unless it has a module option to change the
           number when the driver module is loaded.
 
-       -  The :ref:`VIDIOC_REQBUFS <vidioc-reqbufs>` ioctl allocates the
+       -  The :ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>` ioctl allocates the
           desired number of buffers, this is a required step in the
           initialization sequence.
 
@@ -785,7 +785,7 @@ differences.
 
        -  Buffers are individually mapped. The offset and size of each
           buffer can be determined with the
-          :ref:`VIDIOC_QUERYBUF <vidioc-querybuf>` ioctl.
+          :ref:`VIDIOC_QUERYBUF <VIDIOC_QUERYBUF>` ioctl.
 
     -  .. row 5
 
@@ -800,18 +800,18 @@ differences.
           buffer has been filled.
 
        -  Drivers maintain an incoming and outgoing queue.
-          :ref:`VIDIOC_QBUF <vidioc-qbuf>` enqueues any empty buffer into
+          :ref:`VIDIOC_QBUF <VIDIOC_QBUF>` enqueues any empty buffer into
           the incoming queue. Filled buffers are dequeued from the outgoing
-          queue with the :ref:`VIDIOC_DQBUF <vidioc-qbuf>` ioctl. To wait
+          queue with the :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctl. To wait
           until filled buffers become available this function,
           :ref:`select() <func-select>` or :ref:`poll() <func-poll>` can
-          be used. The :ref:`VIDIOC_STREAMON <vidioc-streamon>` ioctl
+          be used. The :ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>` ioctl
           must be called once after enqueuing one or more buffers to start
           capturing. Its counterpart
-          :ref:`VIDIOC_STREAMOFF <vidioc-streamon>` stops capturing and
+          :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` stops capturing and
           dequeues all buffers from both queues. Applications can query the
           signal status, if known, with the
-          :ref:`VIDIOC_ENUMINPUT <vidioc-enuminput>` ioctl.
+          :ref:`VIDIOC_ENUMINPUT <VIDIOC_ENUMINPUT>` ioctl.
 
 
 For a more in-depth discussion of memory mapping and examples, see
diff --git a/Documentation/linux_tv/media/v4l/dmabuf.rst b/Documentation/linux_tv/media/v4l/dmabuf.rst
index ac14cf89fa38..bc2944c27e70 100644
--- a/Documentation/linux_tv/media/v4l/dmabuf.rst
+++ b/Documentation/linux_tv/media/v4l/dmabuf.rst
@@ -14,15 +14,15 @@ previously exported for a different or the same device (known as the
 importer role), or both. This section describes the DMABUF importer role
 API in V4L2.
 
-Refer to :ref:`DMABUF exporting <vidioc-expbuf>` for details about
+Refer to :ref:`DMABUF exporting <VIDIOC_EXPBUF>` for details about
 exporting V4L2 buffers as DMABUF file descriptors.
 
 Input and output devices support the streaming I/O method when the
 ``V4L2_CAP_STREAMING`` flag in the ``capabilities`` field of struct
 :ref:`v4l2_capability <v4l2-capability>` returned by the
-:ref:`VIDIOC_QUERYCAP <vidioc-querycap>` ioctl is set. Whether
+:ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>` ioctl is set. Whether
 importing DMA buffers through DMABUF file descriptors is supported is
-determined by calling the :ref:`VIDIOC_REQBUFS <vidioc-reqbufs>`
+determined by calling the :ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>`
 ioctl with the memory type set to ``V4L2_MEMORY_DMABUF``.
 
 This I/O method is dedicated to sharing DMA buffers between different
@@ -34,7 +34,7 @@ such file descriptor are exchanged. The descriptors and meta-information
 are passed in struct :ref:`v4l2_buffer <v4l2-buffer>` (or in struct
 :ref:`v4l2_plane <v4l2-plane>` in the multi-planar API case). The
 driver must be switched into DMABUF I/O mode by calling the
-:ref:`VIDIOC_REQBUFS <vidioc-reqbufs>` with the desired buffer type.
+:ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>` with the desired buffer type.
 
 
 .. code-block:: c
@@ -56,7 +56,7 @@ driver must be switched into DMABUF I/O mode by calling the
     }
 
 The buffer (plane) file descriptor is passed on the fly with the
-:ref:`VIDIOC_QBUF <vidioc-qbuf>` ioctl. In case of multiplanar
+:ref:`VIDIOC_QBUF <VIDIOC_QBUF>` ioctl. In case of multiplanar
 buffers, every plane can be associated with a different DMABUF
 descriptor. Although buffers are commonly cycled, applications can pass
 a different DMABUF descriptor at each ``VIDIOC_QBUF`` call.
@@ -112,11 +112,11 @@ a different DMABUF descriptor at each ``VIDIOC_QBUF`` call.
     }
 
 Captured or displayed buffers are dequeued with the
-:ref:`VIDIOC_DQBUF <vidioc-qbuf>` ioctl. The driver can unlock the
+:ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctl. The driver can unlock the
 buffer at any time between the completion of the DMA and this ioctl. The
 memory is also unlocked when
-:ref:`VIDIOC_STREAMOFF <vidioc-streamon>` is called,
-:ref:`VIDIOC_REQBUFS <vidioc-reqbufs>`, or when the device is closed.
+:ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` is called,
+:ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>`, or when the device is closed.
 
 For capturing applications it is customary to enqueue a number of empty
 buffers, to start capturing and enter the read loop. Here the
@@ -134,8 +134,8 @@ immediately with an EAGAIN error code when no buffer is available. The
 functions are always available.
 
 To start and stop capturing or displaying applications call the
-:ref:`VIDIOC_STREAMON <vidioc-streamon>` and
-:ref:`VIDIOC_STREAMOFF <vidioc-streamon>` ioctls. Note that
+:ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>` and
+:ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` ioctls. Note that
 ``VIDIOC_STREAMOFF`` removes all buffers from both queues and unlocks
 all buffers as a side effect. Since there is no notion of doing anything
 "now" on a multitasking system, if an application needs to synchronize
diff --git a/Documentation/linux_tv/media/v4l/dv-timings.rst b/Documentation/linux_tv/media/v4l/dv-timings.rst
index a347ce7cb504..d51c36ec604c 100644
--- a/Documentation/linux_tv/media/v4l/dv-timings.rst
+++ b/Documentation/linux_tv/media/v4l/dv-timings.rst
@@ -24,14 +24,14 @@ standards.
 
 To enumerate and query the attributes of the DV timings supported by a
 device applications use the
-:ref:`VIDIOC_ENUM_DV_TIMINGS <vidioc-enum-dv-timings>` and
-:ref:`VIDIOC_DV_TIMINGS_CAP <vidioc-dv-timings-cap>` ioctls. To set
+:ref:`VIDIOC_ENUM_DV_TIMINGS <VIDIOC_ENUM_DV_TIMINGS>` and
+:ref:`VIDIOC_DV_TIMINGS_CAP <VIDIOC_DV_TIMINGS_CAP>` ioctls. To set
 DV timings for the device applications use the
-:ref:`VIDIOC_S_DV_TIMINGS <vidioc-g-dv-timings>` ioctl and to get
+:ref:`VIDIOC_S_DV_TIMINGS <VIDIOC_G_DV_TIMINGS>` ioctl and to get
 current DV timings they use the
-:ref:`VIDIOC_G_DV_TIMINGS <vidioc-g-dv-timings>` ioctl. To detect
+:ref:`VIDIOC_G_DV_TIMINGS <VIDIOC_G_DV_TIMINGS>` ioctl. To detect
 the DV timings as seen by the video receiver applications use the
-:ref:`VIDIOC_QUERY_DV_TIMINGS <vidioc-query-dv-timings>` ioctl.
+:ref:`VIDIOC_QUERY_DV_TIMINGS <VIDIOC_QUERY_DV_TIMINGS>` ioctl.
 
 Applications can make use of the :ref:`input-capabilities` and
 :ref:`output-capabilities` flags to determine whether the digital
diff --git a/Documentation/linux_tv/media/v4l/extended-controls.rst b/Documentation/linux_tv/media/v4l/extended-controls.rst
index 5f9779e94cde..66333b9f60fd 100644
--- a/Documentation/linux_tv/media/v4l/extended-controls.rst
+++ b/Documentation/linux_tv/media/v4l/extended-controls.rst
@@ -39,12 +39,12 @@ The Extended Control API
 ========================
 
 Three new ioctls are available:
-:ref:`VIDIOC_G_EXT_CTRLS <vidioc-g-ext-ctrls>`,
-:ref:`VIDIOC_S_EXT_CTRLS <vidioc-g-ext-ctrls>` and
-:ref:`VIDIOC_TRY_EXT_CTRLS <vidioc-g-ext-ctrls>`. These ioctls act
+:ref:`VIDIOC_G_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>`,
+:ref:`VIDIOC_S_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` and
+:ref:`VIDIOC_TRY_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>`. These ioctls act
 on arrays of controls (as opposed to the
-:ref:`VIDIOC_G_CTRL <vidioc-g-ctrl>` and
-:ref:`VIDIOC_S_CTRL <vidioc-g-ctrl>` ioctls that act on a single
+:ref:`VIDIOC_G_CTRL <VIDIOC_G_CTRL>` and
+:ref:`VIDIOC_S_CTRL <VIDIOC_G_CTRL>` ioctls that act on a single
 control). This is needed since it is often required to atomically change
 several controls at once.
 
@@ -79,17 +79,17 @@ with compound types should only be used programmatically.
 
 Since such compound controls need to expose more information about
 themselves than is possible with
-:ref:`VIDIOC_QUERYCTRL <vidioc-queryctrl>` the
-:ref:`VIDIOC_QUERY_EXT_CTRL <vidioc-queryctrl>` ioctl was added. In
+:ref:`VIDIOC_QUERYCTRL <VIDIOC_QUERYCTRL>` the
+:ref:`VIDIOC_QUERY_EXT_CTRL <VIDIOC_QUERYCTRL>` ioctl was added. In
 particular, this ioctl gives the dimensions of the N-dimensional array
 if this control consists of more than one element.
 
 It is important to realize that due to the flexibility of controls it is
 necessary to check whether the control you want to set actually is
 supported in the driver and what the valid range of values is. So use
-the :ref:`VIDIOC_QUERYCTRL <vidioc-queryctrl>` (or
-:ref:`VIDIOC_QUERY_EXT_CTRL <vidioc-queryctrl>`) and
-:ref:`VIDIOC_QUERYMENU <vidioc-queryctrl>` ioctls to check this. Also
+the :ref:`VIDIOC_QUERYCTRL <VIDIOC_QUERYCTRL>` (or
+:ref:`VIDIOC_QUERY_EXT_CTRL <VIDIOC_QUERYCTRL>`) and
+:ref:`VIDIOC_QUERYMENU <VIDIOC_QUERYCTRL>` ioctls to check this. Also
 note that it is possible that some of the menu indices in a control of
 type ``V4L2_CTRL_TYPE_MENU`` may not be supported (``VIDIOC_QUERYMENU``
 will return an error). A good example is the list of supported MPEG
@@ -103,7 +103,7 @@ Enumerating Extended Controls
 =============================
 
 The recommended way to enumerate over the extended controls is by using
-:ref:`VIDIOC_QUERYCTRL <vidioc-queryctrl>` in combination with the
+:ref:`VIDIOC_QUERYCTRL <VIDIOC_QUERYCTRL>` in combination with the
 ``V4L2_CTRL_FLAG_NEXT_CTRL`` flag:
 
 
@@ -169,7 +169,7 @@ within a control panel.
 
 The flags field of struct :ref:`v4l2_queryctrl <v4l2-queryctrl>` also
 contains hints on the behavior of the control. See the
-:ref:`VIDIOC_QUERYCTRL <vidioc-queryctrl>` documentation for more
+:ref:`VIDIOC_QUERYCTRL <VIDIOC_QUERYCTRL>` documentation for more
 details.
 
 
@@ -198,7 +198,7 @@ Codec Control IDs
 
 ``V4L2_CID_MPEG_CLASS (class)``
     The Codec class descriptor. Calling
-    :ref:`VIDIOC_QUERYCTRL <vidioc-queryctrl>` for this control will
+    :ref:`VIDIOC_QUERYCTRL <VIDIOC_QUERYCTRL>` for this control will
     return a description of this control class. This description can be
     used as the caption of a Tab page in a GUI, for example.
 
@@ -1168,7 +1168,7 @@ Codec Control IDs
     This read-only control returns the 33-bit video Presentation Time
     Stamp as defined in ITU T-REC-H.222.0 and ISO/IEC 13818-1 of the
     currently displayed frame. This is the same PTS as is used in
-    :ref:`VIDIOC_DECODER_CMD <vidioc-decoder-cmd>`.
+    :ref:`VIDIOC_DECODER_CMD <VIDIOC_DECODER_CMD>`.
 
 .. _`v4l2-mpeg-video-dec-frame`:
 
@@ -2781,7 +2781,7 @@ Camera Control IDs
 
 ``V4L2_CID_CAMERA_CLASS (class)``
     The Camera class descriptor. Calling
-    :ref:`VIDIOC_QUERYCTRL <vidioc-queryctrl>` for this control will
+    :ref:`VIDIOC_QUERYCTRL <VIDIOC_QUERYCTRL>` for this control will
     return a description of this control class.
 
 .. _`v4l2-exposure-auto-type`:
@@ -3441,7 +3441,7 @@ FM_TX Control IDs
 
 ``V4L2_CID_FM_TX_CLASS (class)``
     The FM_TX class descriptor. Calling
-    :ref:`VIDIOC_QUERYCTRL <vidioc-queryctrl>` for this control will
+    :ref:`VIDIOC_QUERYCTRL <VIDIOC_QUERYCTRL>` for this control will
     return a description of this control class.
 
 ``V4L2_CID_RDS_TX_DEVIATION (integer)``
@@ -3870,7 +3870,7 @@ JPEG Control IDs
 
 ``V4L2_CID_JPEG_CLASS (class)``
     The JPEG class descriptor. Calling
-    :ref:`VIDIOC_QUERYCTRL <vidioc-queryctrl>` for this control will
+    :ref:`VIDIOC_QUERYCTRL <VIDIOC_QUERYCTRL>` for this control will
     return a description of this control class.
 
 ``V4L2_CID_JPEG_CHROMA_SUBSAMPLING (menu)``
@@ -4271,7 +4271,7 @@ FM_RX Control IDs
 
 ``V4L2_CID_FM_RX_CLASS (class)``
     The FM_RX class descriptor. Calling
-    :ref:`VIDIOC_QUERYCTRL <vidioc-queryctrl>` for this control will
+    :ref:`VIDIOC_QUERYCTRL <VIDIOC_QUERYCTRL>` for this control will
     return a description of this control class.
 
 ``V4L2_CID_RDS_RECEPTION (boolean)``
@@ -4369,7 +4369,7 @@ Detect Control IDs
 
 ``V4L2_CID_DETECT_CLASS (class)``
     The Detect class descriptor. Calling
-    :ref:`VIDIOC_QUERYCTRL <vidioc-queryctrl>` for this control will
+    :ref:`VIDIOC_QUERYCTRL <VIDIOC_QUERYCTRL>` for this control will
     return a description of this control class.
 
 ``V4L2_CID_DETECT_MD_MODE (menu)``
@@ -4463,7 +4463,7 @@ RF_TUNER Control IDs
 
 ``V4L2_CID_RF_TUNER_CLASS (class)``
     The RF_TUNER class descriptor. Calling
-    :ref:`VIDIOC_QUERYCTRL <vidioc-queryctrl>` for this control will
+    :ref:`VIDIOC_QUERYCTRL <VIDIOC_QUERYCTRL>` for this control will
     return a description of this control class.
 
 ``V4L2_CID_RF_TUNER_BANDWIDTH_AUTO (boolean)``
diff --git a/Documentation/linux_tv/media/v4l/field-order.rst b/Documentation/linux_tv/media/v4l/field-order.rst
index 295ec0430183..0ab52df521a8 100644
--- a/Documentation/linux_tv/media/v4l/field-order.rst
+++ b/Documentation/linux_tv/media/v4l/field-order.rst
@@ -48,7 +48,7 @@ All video capture and output devices must report the current field
 order. Some drivers may permit the selection of a different order, to
 this end applications initialize the ``field`` field of struct
 :ref:`v4l2_pix_format <v4l2-pix-format>` before calling the
-:ref:`VIDIOC_S_FMT <vidioc-g-fmt>` ioctl. If this is not desired it
+:ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl. If this is not desired it
 should have the value ``V4L2_FIELD_ANY`` (0).
 
 
@@ -73,8 +73,8 @@ should have the value ``V4L2_FIELD_ANY`` (0).
           size, and return the actual field order. Drivers must never return
           ``V4L2_FIELD_ANY``. If multiple field orders are possible the
           driver must choose one of the possible field orders during
-          :ref:`VIDIOC_S_FMT <vidioc-g-fmt>` or
-          :ref:`VIDIOC_TRY_FMT <vidioc-g-fmt>`. struct
+          :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` or
+          :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>`. struct
           :ref:`v4l2_buffer <v4l2-buffer>` ``field`` can never be
           ``V4L2_FIELD_ANY``.
 
diff --git a/Documentation/linux_tv/media/v4l/format.rst b/Documentation/linux_tv/media/v4l/format.rst
index c1e30a64c833..a754fa81f707 100644
--- a/Documentation/linux_tv/media/v4l/format.rst
+++ b/Documentation/linux_tv/media/v4l/format.rst
@@ -23,9 +23,9 @@ current selection.
 
 A single mechanism exists to negotiate all data formats using the
 aggregate struct :ref:`v4l2_format <v4l2-format>` and the
-:ref:`VIDIOC_G_FMT <vidioc-g-fmt>` and
-:ref:`VIDIOC_S_FMT <vidioc-g-fmt>` ioctls. Additionally the
-:ref:`VIDIOC_TRY_FMT <vidioc-g-fmt>` ioctl can be used to examine
+:ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` and
+:ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctls. Additionally the
+:ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` ioctl can be used to examine
 what the hardware *could* do, without actually selecting a new data
 format. The data formats supported by the V4L2 API are covered in the
 respective device section in :ref:`devices`. For a closer look at
@@ -52,7 +52,7 @@ image size.
 
 When applications omit the ``VIDIOC_S_FMT`` ioctl its locking side
 effects are implied by the next step, the selection of an I/O method
-with the :ref:`VIDIOC_REQBUFS <vidioc-reqbufs>` ioctl or implicit
+with the :ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>` ioctl or implicit
 with the first :ref:`read() <func-read>` or
 :ref:`write() <func-write>` call.
 
@@ -75,7 +75,7 @@ Apart of the generic format negotiation functions a special ioctl to
 enumerate all image formats supported by video capture, overlay or
 output devices is available. [1]_
 
-The :ref:`VIDIOC_ENUM_FMT <vidioc-enum-fmt>` ioctl must be supported
+The :ref:`VIDIOC_ENUM_FMT <VIDIOC_ENUM_FMT>` ioctl must be supported
 by all drivers exchanging image data with applications.
 
     **Important**
diff --git a/Documentation/linux_tv/media/v4l/func-mmap.rst b/Documentation/linux_tv/media/v4l/func-mmap.rst
index fb6e4cd52e24..7243142384bb 100644
--- a/Documentation/linux_tv/media/v4l/func-mmap.rst
+++ b/Documentation/linux_tv/media/v4l/func-mmap.rst
@@ -98,8 +98,8 @@ application address space, preferably at address ``start``. This latter
 address is a hint only, and is usually specified as 0.
 
 Suitable length and offset parameters are queried with the
-:ref:`VIDIOC_QUERYBUF <vidioc-querybuf>` ioctl. Buffers must be
-allocated with the :ref:`VIDIOC_REQBUFS <vidioc-reqbufs>` ioctl
+:ref:`VIDIOC_QUERYBUF <VIDIOC_QUERYBUF>` ioctl. Buffers must be
+allocated with the :ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>` ioctl
 before they can be queried.
 
 To unmap buffers the :ref:`munmap() <func-munmap>` function is used.
@@ -125,7 +125,7 @@ EINVAL
     The ``flags`` or ``prot`` value is not supported.
 
     No buffers have been allocated with the
-    :ref:`VIDIOC_REQBUFS <vidioc-reqbufs>` ioctl.
+    :ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>` ioctl.
 
 ENOMEM
     Not enough physical or virtual memory was available to complete the
diff --git a/Documentation/linux_tv/media/v4l/func-open.rst b/Documentation/linux_tv/media/v4l/func-open.rst
index 21b1dfddc118..370a6858d65d 100644
--- a/Documentation/linux_tv/media/v4l/func-open.rst
+++ b/Documentation/linux_tv/media/v4l/func-open.rst
@@ -33,7 +33,7 @@ Arguments
     devices only writing.
 
     When the ``O_NONBLOCK`` flag is given, the read() function and the
-    :ref:`VIDIOC_DQBUF <vidioc-qbuf>` ioctl will return the EAGAIN
+    :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctl will return the EAGAIN
     error code when no data is available or no buffer is in the driver
     outgoing queue, otherwise these functions block until data becomes
     available. All V4L2 drivers exchanging data with applications must
diff --git a/Documentation/linux_tv/media/v4l/func-poll.rst b/Documentation/linux_tv/media/v4l/func-poll.rst
index d3ad7b8d1a90..28a769af9309 100644
--- a/Documentation/linux_tv/media/v4l/func-poll.rst
+++ b/Documentation/linux_tv/media/v4l/func-poll.rst
@@ -30,9 +30,9 @@ output.
 
 When streaming I/O has been negotiated this function waits until a
 buffer has been filled by the capture device and can be dequeued with
-the :ref:`VIDIOC_DQBUF <vidioc-qbuf>` ioctl. For output devices this
+the :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctl. For output devices this
 function waits until the device is ready to accept a new buffer to be
-queued up with the :ref:`VIDIOC_QBUF <vidioc-qbuf>` ioctl for
+queued up with the :ref:`VIDIOC_QBUF <VIDIOC_QBUF>` ioctl for
 display. When buffers are already in the outgoing queue of the driver
 (capture) or the incoming queue isn't full (display) the function
 returns immediately.
@@ -45,17 +45,17 @@ flags in the ``revents`` field, output devices the ``POLLOUT`` and
 ``POLLWRNORM`` flags. When the function timed out it returns a value of
 zero, on failure it returns -1 and the ``errno`` variable is set
 appropriately. When the application did not call
-:ref:`VIDIOC_STREAMON <vidioc-streamon>` the :c:func:`poll()`
+:ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>` the :c:func:`poll()`
 function succeeds, but sets the ``POLLERR`` flag in the ``revents``
 field. When the application has called
-:ref:`VIDIOC_STREAMON <vidioc-streamon>` for a capture device but
-hasn't yet called :ref:`VIDIOC_QBUF <vidioc-qbuf>`, the
+:ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>` for a capture device but
+hasn't yet called :ref:`VIDIOC_QBUF <VIDIOC_QBUF>`, the
 :c:func:`poll()` function succeeds and sets the ``POLLERR`` flag in
 the ``revents`` field. For output devices this same situation will cause
 :c:func:`poll()` to succeed as well, but it sets the ``POLLOUT`` and
 ``POLLWRNORM`` flags in the ``revents`` field.
 
-If an event occurred (see :ref:`VIDIOC_DQEVENT <vidioc-dqevent>`)
+If an event occurred (see :ref:`VIDIOC_DQEVENT <VIDIOC_DQEVENT>`)
 then ``POLLPRI`` will be set in the ``revents`` field and
 :c:func:`poll()` will return.
 
diff --git a/Documentation/linux_tv/media/v4l/func-read.rst b/Documentation/linux_tv/media/v4l/func-read.rst
index b46cbbdeeab7..497bc9a9dd5a 100644
--- a/Documentation/linux_tv/media/v4l/func-read.rst
+++ b/Documentation/linux_tv/media/v4l/func-read.rst
@@ -85,8 +85,8 @@ enough. Again, the behavior when the driver runs out of free buffers
 depends on the discarding policy.
 
 Applications can get and set the number of buffers used internally by
-the driver with the :ref:`VIDIOC_G_PARM <vidioc-g-parm>` and
-:ref:`VIDIOC_S_PARM <vidioc-g-parm>` ioctls. They are optional,
+the driver with the :ref:`VIDIOC_G_PARM <VIDIOC_G_PARM>` and
+:ref:`VIDIOC_S_PARM <VIDIOC_G_PARM>` ioctls. They are optional,
 however. The discarding policy is not reported and cannot be changed.
 For minimum requirements see :ref:`devices`.
 
diff --git a/Documentation/linux_tv/media/v4l/func-select.rst b/Documentation/linux_tv/media/v4l/func-select.rst
index 7c9706838cb3..77fdf33648b3 100644
--- a/Documentation/linux_tv/media/v4l/func-select.rst
+++ b/Documentation/linux_tv/media/v4l/func-select.rst
@@ -32,17 +32,17 @@ for output.
 
 When streaming I/O has been negotiated this function waits until a
 buffer has been filled or displayed and can be dequeued with the
-:ref:`VIDIOC_DQBUF <vidioc-qbuf>` ioctl. When buffers are already in
+:ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctl. When buffers are already in
 the outgoing queue of the driver the function returns immediately.
 
 On success :c:func:`select()` returns the total number of bits set in
 the :c:type:`struct fd_set`s. When the function timed out it returns
 a value of zero. On failure it returns -1 and the ``errno`` variable is
 set appropriately. When the application did not call
-:ref:`VIDIOC_QBUF <vidioc-qbuf>` or
-:ref:`VIDIOC_STREAMON <vidioc-streamon>` yet the :c:func:`select()`
+:ref:`VIDIOC_QBUF <VIDIOC_QBUF>` or
+:ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>` yet the :c:func:`select()`
 function succeeds, setting the bit of the file descriptor in ``readfds``
-or ``writefds``, but subsequent :ref:`VIDIOC_DQBUF <vidioc-qbuf>`
+or ``writefds``, but subsequent :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>`
 calls will fail. [1]_
 
 When use of the :c:func:`read()` function has been negotiated and the
diff --git a/Documentation/linux_tv/media/v4l/hist-v4l2.rst b/Documentation/linux_tv/media/v4l/hist-v4l2.rst
index 32f999b3c1a4..ab18331710f7 100644
--- a/Documentation/linux_tv/media/v4l/hist-v4l2.rst
+++ b/Documentation/linux_tv/media/v4l/hist-v4l2.rst
@@ -38,10 +38,10 @@ enumerable.
 
 1998-10-02: The ``id`` field was removed from struct
 :c:type:`struct video_standard` and the color subcarrier fields were
-renamed. The :ref:`VIDIOC_QUERYSTD <vidioc-querystd>` ioctl was
-renamed to :ref:`VIDIOC_ENUMSTD <vidioc-enumstd>`,
-:ref:`VIDIOC_G_INPUT <vidioc-g-input>` to
-:ref:`VIDIOC_ENUMINPUT <vidioc-enuminput>`. A first draft of the
+renamed. The :ref:`VIDIOC_QUERYSTD <VIDIOC_QUERYSTD>` ioctl was
+renamed to :ref:`VIDIOC_ENUMSTD <VIDIOC_ENUMSTD>`,
+:ref:`VIDIOC_G_INPUT <VIDIOC_G_INPUT>` to
+:ref:`VIDIOC_ENUMINPUT <VIDIOC_ENUMINPUT>`. A first draft of the
 Codec API was released.
 
 1998-11-08: Many minor changes. Most symbols have been renamed. Some
@@ -52,8 +52,8 @@ material changes to struct :ref:`v4l2_capability <v4l2-capability>`.
 1998-11-14: ``V4L2_PIX_FMT_RGB24`` changed to ``V4L2_PIX_FMT_BGR24``,
 and ``V4L2_PIX_FMT_RGB32`` changed to ``V4L2_PIX_FMT_BGR32``. Audio
 controls are now accessible with the
-:ref:`VIDIOC_G_CTRL <vidioc-g-ctrl>` and
-:ref:`VIDIOC_S_CTRL <vidioc-g-ctrl>` ioctls under names starting
+:ref:`VIDIOC_G_CTRL <VIDIOC_G_CTRL>` and
+:ref:`VIDIOC_S_CTRL <VIDIOC_G_CTRL>` ioctls under names starting
 with ``V4L2_CID_AUDIO``. The ``V4L2_MAJOR`` define was removed from
 ``videodev.h`` since it was only used once in the ``videodev`` kernel
 module. The ``YUV422`` and ``YUV411`` planar image formats were added.
@@ -142,8 +142,8 @@ common Linux driver API conventions.
        int a = V4L2_XXX; err = ioctl(fd, VIDIOC_XXX, &a);
 
 4. All the different get- and set-format commands were swept into one
-   :ref:`VIDIOC_G_FMT <vidioc-g-fmt>` and
-   :ref:`VIDIOC_S_FMT <vidioc-g-fmt>` ioctl taking a union and a
+   :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` and
+   :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl taking a union and a
    type field selecting the union member as parameter. Purpose is to
    simplify the API by eliminating several ioctls and to allow new and
    driver private data streams without adding new ioctls.
@@ -246,14 +246,14 @@ correctly through the backward compatibility layer. [Solution?]
 2001-04-13: Big endian 16-bit RGB formats were added.
 
 2001-09-17: New YUV formats and the
-:ref:`VIDIOC_G_FREQUENCY <vidioc-g-frequency>` and
-:ref:`VIDIOC_S_FREQUENCY <vidioc-g-frequency>` ioctls were added.
+:ref:`VIDIOC_G_FREQUENCY <VIDIOC_G_FREQUENCY>` and
+:ref:`VIDIOC_S_FREQUENCY <VIDIOC_G_FREQUENCY>` ioctls were added.
 (The old ``VIDIOC_G_FREQ`` and ``VIDIOC_S_FREQ`` ioctls did not take
 multiple tuners into account.)
 
 2000-09-18: ``V4L2_BUF_TYPE_VBI`` was added. This may *break
-compatibility* as the :ref:`VIDIOC_G_FMT <vidioc-g-fmt>` and
-:ref:`VIDIOC_S_FMT <vidioc-g-fmt>` ioctls may fail now if the struct
+compatibility* as the :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` and
+:ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctls may fail now if the struct
 :c:type:`struct v4l2_fmt` ``type`` field does not contain
 ``V4L2_BUF_TYPE_VBI``. In the documentation of the struct
 :ref:`v4l2_vbi_format <v4l2-vbi-format>` ``offset`` field the
@@ -286,7 +286,7 @@ A number of changes were made to the raw VBI interface.
    as proposed earlier. Why this feature was dropped is unclear. This
    change may *break compatibility* with applications depending on the
    start values being positive. The use of ``EBUSY`` and ``EINVAL``
-   error codes with the :ref:`VIDIOC_S_FMT <vidioc-g-fmt>` ioctl was
+   error codes with the :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl was
    clarified. The EBUSY error code was finally documented, and the
    ``reserved2`` field which was previously mentioned only in the
    ``videodev.h`` header file.
@@ -325,7 +325,7 @@ This unnamed version was finally merged into Linux 2.5.46.
     dramatically. Note that also the size of the structure changed,
     which is encoded in the ioctl request code, thus older V4L2 devices
     will respond with an EINVAL error code to the new
-    :ref:`VIDIOC_QUERYCAP <vidioc-querycap>` ioctl.
+    :ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>` ioctl.
 
     There are new fields to identify the driver, a new RDS device
     function ``V4L2_CAP_RDS_CAPTURE``, the ``V4L2_CAP_AUDIO`` flag
@@ -401,13 +401,13 @@ This unnamed version was finally merged into Linux 2.5.46.
     supported standards with an ioctl applications can now refer to
     standards by :ref:`v4l2_std_id <v4l2-std-id>` and symbols
     defined in the ``videodev2.h`` header file. For details see
-    :ref:`standard`. The :ref:`VIDIOC_G_STD <vidioc-g-std>` and
-    :ref:`VIDIOC_S_STD <vidioc-g-std>` now take a pointer to this
-    type as argument. :ref:`VIDIOC_QUERYSTD <vidioc-querystd>` was
+    :ref:`standard`. The :ref:`VIDIOC_G_STD <VIDIOC_G_STD>` and
+    :ref:`VIDIOC_S_STD <VIDIOC_G_STD>` now take a pointer to this
+    type as argument. :ref:`VIDIOC_QUERYSTD <VIDIOC_QUERYSTD>` was
     added to autodetect the received standard, if the hardware has this
     capability. In struct :ref:`v4l2_standard <v4l2-standard>` an
     ``index`` field was added for
-    :ref:`VIDIOC_ENUMSTD <vidioc-enumstd>`. A
+    :ref:`VIDIOC_ENUMSTD <VIDIOC_ENUMSTD>`. A
     :ref:`v4l2_std_id <v4l2-std-id>` field named ``id`` was added as
     machine readable identifier, also replacing the ``transmission``
     field. The misleading ``framerate`` field was renamed to
@@ -416,7 +416,7 @@ This unnamed version was finally merged into Linux 2.5.46.
     removed.
 
     Struct :c:type:`struct v4l2_enumstd` ceased to be.
-    :ref:`VIDIOC_ENUMSTD <vidioc-enumstd>` now takes a pointer to a
+    :ref:`VIDIOC_ENUMSTD <VIDIOC_ENUMSTD>` now takes a pointer to a
     struct :ref:`v4l2_standard <v4l2-standard>` directly. The
     information which standards are supported by a particular video
     input or output moved into struct :ref:`v4l2_input <v4l2-input>`
@@ -427,9 +427,9 @@ This unnamed version was finally merged into Linux 2.5.46.
     ``category`` and ``group`` did not catch on and/or were not
     implemented as expected and therefore removed.
 
-9.  The :ref:`VIDIOC_TRY_FMT <vidioc-g-fmt>` ioctl was added to
+9.  The :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` ioctl was added to
     negotiate data formats as with
-    :ref:`VIDIOC_S_FMT <vidioc-g-fmt>`, but without the overhead of
+    :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`, but without the overhead of
     programming the hardware and regardless of I/O in progress.
 
     In struct :ref:`v4l2_format <v4l2-format>` the ``fmt`` union was
@@ -538,7 +538,7 @@ This unnamed version was finally merged into Linux 2.5.46.
     added as in struct :ref:`v4l2_format <v4l2-format>`. The
     ``VIDIOC_ENUM_FBUFFMT`` ioctl is no longer needed and was removed.
     These calls can be replaced by
-    :ref:`VIDIOC_ENUM_FMT <vidioc-enum-fmt>` with type
+    :ref:`VIDIOC_ENUM_FMT <VIDIOC_ENUM_FMT>` with type
     ``V4L2_BUF_TYPE_VIDEO_OVERLAY``.
 
 11. In struct :ref:`v4l2_pix_format <v4l2-pix-format>` the ``depth``
@@ -716,25 +716,25 @@ V4L2 2003-06-19
 
 3. The audio input and output interface was found to be incomplete.
 
-   Previously the :ref:`VIDIOC_G_AUDIO <vidioc-g-audio>` ioctl would
+   Previously the :ref:`VIDIOC_G_AUDIO <VIDIOC_G_AUDIO>` ioctl would
    enumerate the available audio inputs. An ioctl to determine the
    current audio input, if more than one combines with the current video
    input, did not exist. So ``VIDIOC_G_AUDIO`` was renamed to
    ``VIDIOC_G_AUDIO_OLD``, this ioctl was removed on Kernel 2.6.39. The
-   :ref:`VIDIOC_ENUMAUDIO <vidioc-enumaudio>` ioctl was added to
+   :ref:`VIDIOC_ENUMAUDIO <VIDIOC_ENUMAUDIO>` ioctl was added to
    enumerate audio inputs, while
-   :ref:`VIDIOC_G_AUDIO <vidioc-g-audio>` now reports the current
+   :ref:`VIDIOC_G_AUDIO <VIDIOC_G_AUDIO>` now reports the current
    audio input.
 
    The same changes were made to
-   :ref:`VIDIOC_G_AUDOUT <vidioc-g-audioout>` and
-   :ref:`VIDIOC_ENUMAUDOUT <vidioc-enumaudioout>`.
+   :ref:`VIDIOC_G_AUDOUT <VIDIOC_G_AUDIOout>` and
+   :ref:`VIDIOC_ENUMAUDOUT <VIDIOC_ENUMAUDIOout>`.
 
    Until further the "videodev" module will automatically translate
    between the old and new ioctls, but drivers and applications must be
    updated to successfully compile again.
 
-4. The :ref:`VIDIOC_OVERLAY <vidioc-overlay>` ioctl was incorrectly
+4. The :ref:`VIDIOC_OVERLAY <VIDIOC_OVERLAY>` ioctl was incorrectly
    defined with write-read parameter. It was changed to write-only,
    while the write-read version was renamed to ``VIDIOC_OVERLAY_OLD``.
    The old ioctl was removed on Kernel 2.6.39. Until further the
@@ -746,8 +746,8 @@ V4L2 2003-06-19
    rectangles define regions where *no* video shall be displayed and so
    the graphics surface can be seen.
 
-6. The :ref:`VIDIOC_S_PARM <vidioc-g-parm>` and
-   :ref:`VIDIOC_S_CTRL <vidioc-g-ctrl>` ioctls were defined with
+6. The :ref:`VIDIOC_S_PARM <VIDIOC_G_PARM>` and
+   :ref:`VIDIOC_S_CTRL <VIDIOC_G_CTRL>` ioctls were defined with
    write-only parameter, inconsistent with other ioctls modifying their
    argument. They were changed to write-read, while a ``_OLD`` suffix
    was added to the write-only versions. The old ioctls were removed on
@@ -824,7 +824,7 @@ V4L2 2003-11-05
 V4L2 in Linux 2.6.6, 2004-05-09
 ===============================
 
-1. The :ref:`VIDIOC_CROPCAP <vidioc-cropcap>` ioctl was incorrectly
+1. The :ref:`VIDIOC_CROPCAP <VIDIOC_CROPCAP>` ioctl was incorrectly
    defined with read-only parameter. It is now defined as write-read
    ioctl, while the read-only version was renamed to
    ``VIDIOC_CROPCAP_OLD``. The old ioctl was removed on Kernel 2.6.39.
@@ -852,8 +852,8 @@ V4L2 spec erratum 2004-08-01
 3. In the Current Audio Input example the ``VIDIOC_G_AUDIO`` ioctl took
    the wrong argument.
 
-4. The documentation of the :ref:`VIDIOC_QBUF <vidioc-qbuf>` and
-   :ref:`VIDIOC_DQBUF <vidioc-qbuf>` ioctls did not mention the
+4. The documentation of the :ref:`VIDIOC_QBUF <VIDIOC_QBUF>` and
+   :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctls did not mention the
    struct :ref:`v4l2_buffer <v4l2-buffer>` ``memory`` field. It was
    also missing from examples. Also on the ``VIDIOC_DQBUF`` page the EIO
    error code was not documented.
@@ -870,7 +870,7 @@ V4L2 in Linux 2.6.14
 V4L2 in Linux 2.6.15
 ====================
 
-1. The :ref:`VIDIOC_LOG_STATUS <vidioc-log-status>` ioctl was added.
+1. The :ref:`VIDIOC_LOG_STATUS <VIDIOC_LOG_STATUS>` ioctl was added.
 
 2. New video standards ``V4L2_STD_NTSC_443``, ``V4L2_STD_SECAM_LC``,
    ``V4L2_STD_SECAM_DK`` (a set of SECAM D, K and K1), and
@@ -891,9 +891,9 @@ V4L2 spec erratum 2005-11-27
 ============================
 
 The capture example in :ref:`capture-example` called the
-:ref:`VIDIOC_S_CROP <vidioc-g-crop>` ioctl without checking if
+:ref:`VIDIOC_S_CROP <VIDIOC_G_CROP>` ioctl without checking if
 cropping is supported. In the video standard selection example in
-:ref:`standard` the :ref:`VIDIOC_S_STD <vidioc-g-std>` call used
+:ref:`standard` the :ref:`VIDIOC_S_STD <VIDIOC_G_STD>` call used
 the wrong argument type.
 
 
@@ -906,7 +906,7 @@ V4L2 spec erratum 2006-01-10
    disables color decoding when it detects no color in the video signal
    to improve the image quality.)
 
-2. :ref:`VIDIOC_S_PARM <vidioc-g-parm>` is a write-read ioctl, not
+2. :ref:`VIDIOC_S_PARM <VIDIOC_G_PARM>` is a write-read ioctl, not
    write-only as stated on its reference page. The ioctl changed in 2003
    as noted above.
 
@@ -940,7 +940,7 @@ V4L2 in Linux 2.6.17
 2. A new ``V4L2_TUNER_MODE_LANG1_LANG2`` was defined to record both
    languages of a bilingual program. The use of
    ``V4L2_TUNER_MODE_STEREO`` for this purpose is deprecated now. See
-   the :ref:`VIDIOC_G_TUNER <vidioc-g-tuner>` section for details.
+   the :ref:`VIDIOC_G_TUNER <VIDIOC_G_TUNER>` section for details.
 
 
 V4L2 spec erratum 2006-09-23 (Draft 0.15)
@@ -950,16 +950,16 @@ V4L2 spec erratum 2006-09-23 (Draft 0.15)
    ``V4L2_BUF_TYPE_SLICED_VBI_OUTPUT`` of the sliced VBI interface were
    not mentioned along with other buffer types.
 
-2. In :ref:`vidioc-g-audio` it was clarified that the struct
+2. In :ref:`VIDIOC_G_AUDIO` it was clarified that the struct
    :ref:`v4l2_audio <v4l2-audio>` ``mode`` field is a flags field.
 
-3. :ref:`vidioc-querycap` did not mention the sliced VBI and radio
+3. :ref:`VIDIOC_QUERYCAP` did not mention the sliced VBI and radio
    capability flags.
 
-4. In :ref:`vidioc-g-frequency` it was clarified that applications
+4. In :ref:`VIDIOC_G_FREQUENCY` it was clarified that applications
    must initialize the tuner ``type`` field of struct
    :ref:`v4l2_frequency <v4l2-frequency>` before calling
-   :ref:`VIDIOC_S_FREQUENCY <vidioc-g-frequency>`.
+   :ref:`VIDIOC_S_FREQUENCY <VIDIOC_G_FREQUENCY>`.
 
 5. The ``reserved`` array in struct
    :ref:`v4l2_requestbuffers <v4l2-requestbuffers>` has 2 elements,
@@ -976,11 +976,11 @@ V4L2 spec erratum 2006-09-23 (Draft 0.15)
 V4L2 in Linux 2.6.18
 ====================
 
-1. New ioctls :ref:`VIDIOC_G_EXT_CTRLS <vidioc-g-ext-ctrls>`,
-   :ref:`VIDIOC_S_EXT_CTRLS <vidioc-g-ext-ctrls>` and
-   :ref:`VIDIOC_TRY_EXT_CTRLS <vidioc-g-ext-ctrls>` were added, a
+1. New ioctls :ref:`VIDIOC_G_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>`,
+   :ref:`VIDIOC_S_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` and
+   :ref:`VIDIOC_TRY_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` were added, a
    flag to skip unsupported controls with
-   :ref:`VIDIOC_QUERYCTRL <vidioc-queryctrl>`, new control types
+   :ref:`VIDIOC_QUERYCTRL <VIDIOC_QUERYCTRL>`, new control types
    ``V4L2_CTRL_TYPE_INTEGER64`` and ``V4L2_CTRL_TYPE_CTRL_CLASS``
    (:ref:`v4l2-ctrl-type`), and new control flags
    ``V4L2_CTRL_FLAG_READ_ONLY``, ``V4L2_CTRL_FLAG_UPDATE``,
@@ -995,15 +995,15 @@ V4L2 in Linux 2.6.19
    buffer type field was added replacing a reserved field. Note on
    architectures where the size of enum types differs from int types the
    size of the structure changed. The
-   :ref:`VIDIOC_G_SLICED_VBI_CAP <vidioc-g-sliced-vbi-cap>` ioctl
+   :ref:`VIDIOC_G_SLICED_VBI_CAP <VIDIOC_G_SLICED_VBI_CAP>` ioctl
    was redefined from being read-only to write-read. Applications must
    initialize the type field and clear the reserved fields now. These
    changes may *break the compatibility* with older drivers and
    applications.
 
-2. The ioctls :ref:`VIDIOC_ENUM_FRAMESIZES <vidioc-enum-framesizes>`
+2. The ioctls :ref:`VIDIOC_ENUM_FRAMESIZES <VIDIOC_ENUM_FRAMESIZES>`
    and
-   :ref:`VIDIOC_ENUM_FRAMEINTERVALS <vidioc-enum-frameintervals>`
+   :ref:`VIDIOC_ENUM_FRAMEINTERVALS <VIDIOC_ENUM_FRAMEINTERVALS>`
    were added.
 
 3. A new pixel format ``V4L2_PIX_FMT_RGB444`` (:ref:`rgb-formats`) was
@@ -1034,14 +1034,14 @@ V4L2 in Linux 2.6.22
 
 2. Three new clipping/blending methods with a global or straight or
    inverted local alpha value were added to the video overlay interface.
-   See the description of the :ref:`VIDIOC_G_FBUF <vidioc-g-fbuf>`
-   and :ref:`VIDIOC_S_FBUF <vidioc-g-fbuf>` ioctls for details.
+   See the description of the :ref:`VIDIOC_G_FBUF <VIDIOC_G_FBUF>`
+   and :ref:`VIDIOC_S_FBUF <VIDIOC_G_FBUF>` ioctls for details.
 
    A new ``global_alpha`` field was added to
    :ref:`v4l2_window <v4l2-window>`, extending the structure. This
    may *break compatibility* with applications using a struct
    :c:type:`struct v4l2_window` directly. However the
-   :ref:`VIDIOC_G/S/TRY_FMT <vidioc-g-fmt>` ioctls, which take a
+   :ref:`VIDIOC_G/S/TRY_FMT <VIDIOC_G_FMT>` ioctls, which take a
    pointer to a :ref:`v4l2_format <v4l2-format>` parent structure
    with padding bytes at the end, are not affected.
 
@@ -1100,7 +1100,7 @@ V4L2 in Linux 2.6.26
 V4L2 in Linux 2.6.27
 ====================
 
-1. The :ref:`VIDIOC_S_HW_FREQ_SEEK <vidioc-s-hw-freq-seek>` ioctl
+1. The :ref:`VIDIOC_S_HW_FREQ_SEEK <VIDIOC_S_HW_FREQ_SEEK>` ioctl
    and the ``V4L2_CAP_HW_FREQ_SEEK`` capability were added.
 
 2. The pixel formats ``V4L2_PIX_FMT_YVYU``, ``V4L2_PIX_FMT_PCA501``,
@@ -1244,9 +1244,9 @@ V4L2 in Linux 3.4
 1. Added :ref:`JPEG compression control class <jpeg-controls>`.
 
 2. Extended the DV Timings API:
-   :ref:`VIDIOC_ENUM_DV_TIMINGS <vidioc-enum-dv-timings>`,
-   :ref:`VIDIOC_QUERY_DV_TIMINGS <vidioc-query-dv-timings>` and
-   :ref:`VIDIOC_DV_TIMINGS_CAP <vidioc-dv-timings-cap>`.
+   :ref:`VIDIOC_ENUM_DV_TIMINGS <VIDIOC_ENUM_DV_TIMINGS>`,
+   :ref:`VIDIOC_QUERY_DV_TIMINGS <VIDIOC_QUERY_DV_TIMINGS>` and
+   :ref:`VIDIOC_DV_TIMINGS_CAP <VIDIOC_DV_TIMINGS_CAP>`.
 
 
 V4L2 in Linux 3.5
@@ -1256,8 +1256,8 @@ V4L2 in Linux 3.5
    V4L2_CTRL_TYPE_INTEGER_MENU.
 
 2. Added selection API for V4L2 subdev interface:
-   :ref:`VIDIOC_SUBDEV_G_SELECTION <vidioc-subdev-g-selection>` and
-   :ref:`VIDIOC_SUBDEV_S_SELECTION <vidioc-subdev-g-selection>`.
+   :ref:`VIDIOC_SUBDEV_G_SELECTION <VIDIOC_SUBDEV_G_SELECTION>` and
+   :ref:`VIDIOC_SUBDEV_S_SELECTION <VIDIOC_SUBDEV_G_SELECTION>`.
 
 3. Added ``V4L2_COLORFX_ANTIQUE``, ``V4L2_COLORFX_ART_FREEZE``,
    ``V4L2_COLORFX_AQUA``, ``V4L2_COLORFX_SILHOUETTE``,
@@ -1286,7 +1286,7 @@ V4L2 in Linux 3.6
    capabilities.
 
 3. Added support for frequency band enumerations:
-   :ref:`VIDIOC_ENUM_FREQ_BANDS <vidioc-enum-freq-bands>`.
+   :ref:`VIDIOC_ENUM_FREQ_BANDS <VIDIOC_ENUM_FREQ_BANDS>`.
 
 
 V4L2 in Linux 3.9
@@ -1308,7 +1308,7 @@ V4L2 in Linux 3.10
    capability flags V4L2_IN_CAP_PRESETS and V4L2_OUT_CAP_PRESETS.
 
 2. Added new debugging ioctl
-   :ref:`VIDIOC_DBG_G_CHIP_INFO <vidioc-dbg-g-chip-info>`.
+   :ref:`VIDIOC_DBG_G_CHIP_INFO <VIDIOC_DBG_G_CHIP_INFO>`.
 
 
 V4L2 in Linux 3.11
@@ -1343,7 +1343,7 @@ V4L2 in Linux 3.17
    format flags.
 
 2. Added compound control types and
-   :ref:`VIDIOC_QUERY_EXT_CTRL <vidioc-queryctrl>`.
+   :ref:`VIDIOC_QUERY_EXT_CTRL <VIDIOC_QUERYCTRL>`.
 
 
 V4L2 in Linux 3.18
@@ -1452,10 +1452,10 @@ Experimental API Elements
 The following V4L2 API elements are currently experimental and may
 change in the future.
 
--  :ref:`VIDIOC_DBG_G_REGISTER <vidioc-dbg-g-register>` and
-   :ref:`VIDIOC_DBG_S_REGISTER <vidioc-dbg-g-register>` ioctls.
+-  :ref:`VIDIOC_DBG_G_REGISTER <VIDIOC_DBG_G_REGISTER>` and
+   :ref:`VIDIOC_DBG_S_REGISTER <VIDIOC_DBG_G_REGISTER>` ioctls.
 
--  :ref:`VIDIOC_DBG_G_CHIP_INFO <vidioc-dbg-g-chip-info>` ioctl.
+-  :ref:`VIDIOC_DBG_G_CHIP_INFO <VIDIOC_DBG_G_CHIP_INFO>` ioctl.
 
 
 .. _obsolete:
@@ -1475,7 +1475,7 @@ should not be implemented in new drivers.
 
 -  ``VIDIOC_SUBDEV_G_CROP`` and ``VIDIOC_SUBDEV_S_CROP`` ioctls. Use
    ``VIDIOC_SUBDEV_G_SELECTION`` and ``VIDIOC_SUBDEV_S_SELECTION``,
-   :ref:`vidioc-subdev-g-selection`.
+   :ref:`VIDIOC_SUBDEV_G_SELECTION`.
 
 .. [1]
    This is not implemented in XFree86.
diff --git a/Documentation/linux_tv/media/v4l/io.rst b/Documentation/linux_tv/media/v4l/io.rst
index a7ca0d5fc5dd..2bc04e597c90 100644
--- a/Documentation/linux_tv/media/v4l/io.rst
+++ b/Documentation/linux_tv/media/v4l/io.rst
@@ -16,12 +16,12 @@ read or write will fail at any time.
 
 Other methods must be negotiated. To select the streaming I/O method
 with memory mapped or user buffers applications call the
-:ref:`VIDIOC_REQBUFS <vidioc-reqbufs>` ioctl. The asynchronous I/O
+:ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>` ioctl. The asynchronous I/O
 method is not defined yet.
 
 Video overlay can be considered another I/O method, although the
 application does not directly receive the image data. It is selected by
-initiating video overlay with the :ref:`VIDIOC_S_FMT <vidioc-g-fmt>`
+initiating video overlay with the :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`
 ioctl. For more information see :ref:`overlay`.
 
 Generally exactly one I/O method, including overlay, is associated with
diff --git a/Documentation/linux_tv/media/v4l/libv4l-introduction.rst b/Documentation/linux_tv/media/v4l/libv4l-introduction.rst
index 533ea4e18770..4fd87ec33260 100644
--- a/Documentation/linux_tv/media/v4l/libv4l-introduction.rst
+++ b/Documentation/linux_tv/media/v4l/libv4l-introduction.rst
@@ -91,17 +91,17 @@ and to enhance the image quality.
 
 In most cases, libv4l2 just passes the calls directly through to the
 v4l2 driver, intercepting the calls to
-:ref:`VIDIOC_TRY_FMT <vidioc-g-fmt>`,
-:ref:`VIDIOC_G_FMT <vidioc-g-fmt>`
-:ref:`VIDIOC_S_FMT <vidioc-g-fmt>`
-:ref:`VIDIOC_ENUM_FRAMESIZES <vidioc-enum-framesizes>` and
-:ref:`VIDIOC_ENUM_FRAMEINTERVALS <vidioc-enum-frameintervals>` in
+:ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>`,
+:ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>`
+:ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`
+:ref:`VIDIOC_ENUM_FRAMESIZES <VIDIOC_ENUM_FRAMESIZES>` and
+:ref:`VIDIOC_ENUM_FRAMEINTERVALS <VIDIOC_ENUM_FRAMEINTERVALS>` in
 order to emulate the formats
 :ref:`V4L2_PIX_FMT_BGR24 <V4L2-PIX-FMT-BGR24>`,
 :ref:`V4L2_PIX_FMT_RGB24 <V4L2-PIX-FMT-RGB24>`,
 :ref:`V4L2_PIX_FMT_YUV420 <V4L2-PIX-FMT-YUV420>`, and
 :ref:`V4L2_PIX_FMT_YVU420 <V4L2-PIX-FMT-YVU420>`, if they aren't
-available in the driver. :ref:`VIDIOC_ENUM_FMT <vidioc-enum-fmt>`
+available in the driver. :ref:`VIDIOC_ENUM_FMT <VIDIOC_ENUM_FMT>`
 keeps enumerating the hardware supported formats, plus the emulated
 formats offered by libv4l at the end.
 
diff --git a/Documentation/linux_tv/media/v4l/mmap.rst b/Documentation/linux_tv/media/v4l/mmap.rst
index 54eb3b607587..de144028ec56 100644
--- a/Documentation/linux_tv/media/v4l/mmap.rst
+++ b/Documentation/linux_tv/media/v4l/mmap.rst
@@ -9,10 +9,10 @@ Streaming I/O (Memory Mapping)
 Input and output devices support this I/O method when the
 ``V4L2_CAP_STREAMING`` flag in the ``capabilities`` field of struct
 :ref:`v4l2_capability <v4l2-capability>` returned by the
-:ref:`VIDIOC_QUERYCAP <vidioc-querycap>` ioctl is set. There are two
+:ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>` ioctl is set. There are two
 streaming methods, to determine if the memory mapping flavor is
 supported applications must call the
-:ref:`VIDIOC_REQBUFS <vidioc-reqbufs>` ioctl.
+:ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>` ioctl.
 
 Streaming is an I/O method where only pointers to buffers are exchanged
 between application and driver, the data itself is not copied. Memory
@@ -29,7 +29,7 @@ a different type of data. To access different sets at the same time
 different file descriptors must be used. [1]_
 
 To allocate device buffers applications call the
-:ref:`VIDIOC_REQBUFS <vidioc-reqbufs>` ioctl with the desired number
+:ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>` ioctl with the desired number
 of buffers and buffer type, for example ``V4L2_BUF_TYPE_VIDEO_CAPTURE``.
 This ioctl can also be used to change the number of buffers or to free
 the allocated memory, provided none of the buffers are still mapped.
@@ -37,7 +37,7 @@ the allocated memory, provided none of the buffers are still mapped.
 Before applications can access the buffers they must map them into their
 address space with the :ref:`mmap() <func-mmap>` function. The
 location of the buffers in device memory can be determined with the
-:ref:`VIDIOC_QUERYBUF <vidioc-querybuf>` ioctl. In the single-planar
+:ref:`VIDIOC_QUERYBUF <VIDIOC_QUERYBUF>` ioctl. In the single-planar
 API case, the ``m.offset`` and ``length`` returned in a struct
 :ref:`v4l2_buffer <v4l2-buffer>` are passed as sixth and second
 parameter to the :c:func:`mmap()` function. When using the
@@ -227,10 +227,10 @@ when the application runs out of free buffers, it must wait until an
 empty buffer can be dequeued and reused.
 
 To enqueue and dequeue a buffer applications use the
-:ref:`VIDIOC_QBUF <vidioc-qbuf>` and
-:ref:`VIDIOC_DQBUF <vidioc-qbuf>` ioctl. The status of a buffer being
+:ref:`VIDIOC_QBUF <VIDIOC_QBUF>` and
+:ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctl. The status of a buffer being
 mapped, enqueued, full or empty can be determined at any time using the
-:ref:`VIDIOC_QUERYBUF <vidioc-querybuf>` ioctl. Two methods exist to
+:ref:`VIDIOC_QUERYBUF <VIDIOC_QUERYBUF>` ioctl. Two methods exist to
 suspend execution of the application until one or more buffers can be
 dequeued. By default ``VIDIOC_DQBUF`` blocks when no buffer is in the
 outgoing queue. When the ``O_NONBLOCK`` flag was given to the
@@ -240,8 +240,8 @@ immediately with an EAGAIN error code when no buffer is available. The
 are always available.
 
 To start and stop capturing or output applications call the
-:ref:`VIDIOC_STREAMON <vidioc-streamon>` and
-:ref:`VIDIOC_STREAMOFF <vidioc-streamon>` ioctl. Note
+:ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>` and
+:ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` ioctl. Note
 ``VIDIOC_STREAMOFF`` removes all buffers from both queues as a side
 effect. Since there is no notion of doing anything "now" on a
 multitasking system, if an application needs to synchronize with another
@@ -258,7 +258,7 @@ the :c:func:`mmap()`, :c:func:`munmap()`, :c:func:`select()` and
 
 .. [1]
    One could use one file descriptor and set the buffer type field
-   accordingly when calling :ref:`VIDIOC_QBUF <vidioc-qbuf>` etc.,
+   accordingly when calling :ref:`VIDIOC_QBUF <VIDIOC_QBUF>` etc.,
    but it makes the :c:func:`select()` function ambiguous. We also
    like the clean approach of one file descriptor per logical stream.
    Video overlay for example is also a logical stream, although the CPU
diff --git a/Documentation/linux_tv/media/v4l/open.rst b/Documentation/linux_tv/media/v4l/open.rst
index 7df540fae201..4c34d61a5253 100644
--- a/Documentation/linux_tv/media/v4l/open.rst
+++ b/Documentation/linux_tv/media/v4l/open.rst
@@ -108,13 +108,13 @@ are comparable to an ALSA audio mixer application. Just opening a V4L2
 device should not change the state of the device. [2]_
 
 Once an application has allocated the memory buffers needed for
-streaming data (by calling the :ref:`VIDIOC_REQBUFS <vidioc-reqbufs>`
-or :ref:`VIDIOC_CREATE_BUFS <vidioc-create-bufs>` ioctls, or
+streaming data (by calling the :ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>`
+or :ref:`VIDIOC_CREATE_BUFS <VIDIOC_CREATE_BUFS>` ioctls, or
 implicitly by calling the :ref:`read() <func-read>` or
 :ref:`write() <func-write>` functions) that application (filehandle)
 becomes the owner of the device. It is no longer allowed to make changes
 that would affect the buffer sizes (e.g. by calling the
-:ref:`VIDIOC_S_FMT <vidioc-g-fmt>` ioctl) and other applications are
+:ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl) and other applications are
 no longer allowed to allocate buffers or start or stop streaming. The
 EBUSY error code will be returned instead.
 
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-013.rst b/Documentation/linux_tv/media/v4l/pixfmt-013.rst
index 384876e377b2..b3cb7c48eb74 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-013.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-013.rst
@@ -27,8 +27,8 @@ Compressed Formats
 
        -  'JPEG'
 
-       -  TBD. See also :ref:`VIDIOC_G_JPEGCOMP <vidioc-g-jpegcomp>`,
-          :ref:`VIDIOC_S_JPEGCOMP <vidioc-g-jpegcomp>`.
+       -  TBD. See also :ref:`VIDIOC_G_JPEGCOMP <VIDIOC_G_JPEGCOMP>`,
+          :ref:`VIDIOC_S_JPEGCOMP <VIDIOC_G_JPEGCOMP>`.
 
     -  .. _`V4L2-PIX-FMT-MPEG`:
 
diff --git a/Documentation/linux_tv/media/v4l/pixfmt.rst b/Documentation/linux_tv/media/v4l/pixfmt.rst
index f5148ac6d781..f2c599aaa502 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt.rst
@@ -11,9 +11,9 @@ with applications. The :c:type:`struct v4l2_pix_format` and
 format and layout of an image in memory. The former is used with the
 single-planar API, while the latter is used with the multi-planar
 version (see :ref:`planar-apis`). Image formats are negotiated with
-the :ref:`VIDIOC_S_FMT <vidioc-g-fmt>` ioctl. (The explanations here
+the :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl. (The explanations here
 focus on video capturing and output, for overlay frame buffer formats
-see also :ref:`VIDIOC_G_FBUF <vidioc-g-fbuf>`.)
+see also :ref:`VIDIOC_G_FBUF <VIDIOC_G_FBUF>`.)
 
 
 .. toctree::
diff --git a/Documentation/linux_tv/media/v4l/planar-apis.rst b/Documentation/linux_tv/media/v4l/planar-apis.rst
index 4c01adcbf525..017f412a6231 100644
--- a/Documentation/linux_tv/media/v4l/planar-apis.rst
+++ b/Documentation/linux_tv/media/v4l/planar-apis.rst
@@ -39,29 +39,29 @@ handle multi-planar formats.
 Calls that distinguish between single and multi-planar APIs
 ===========================================================
 
-:ref:`VIDIOC_QUERYCAP <vidioc-querycap>`
+:ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>`
     Two additional multi-planar capabilities are added. They can be set
     together with non-multi-planar ones for devices that handle both
     single- and multi-planar formats.
 
-:ref:`VIDIOC_G_FMT <vidioc-g-fmt>`,
-:ref:`VIDIOC_S_FMT <vidioc-g-fmt>`,
-:ref:`VIDIOC_TRY_FMT <vidioc-g-fmt>`
+:ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>`,
+:ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`,
+:ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>`
     New structures for describing multi-planar formats are added: struct
     :ref:`v4l2_pix_format_mplane <v4l2-pix-format-mplane>` and
     struct :ref:`v4l2_plane_pix_format <v4l2-plane-pix-format>`.
     Drivers may define new multi-planar formats, which have distinct
     FourCC codes from the existing single-planar ones.
 
-:ref:`VIDIOC_QBUF <vidioc-qbuf>`,
-:ref:`VIDIOC_DQBUF <vidioc-qbuf>`,
-:ref:`VIDIOC_QUERYBUF <vidioc-querybuf>`
+:ref:`VIDIOC_QBUF <VIDIOC_QBUF>`,
+:ref:`VIDIOC_DQBUF <VIDIOC_QBUF>`,
+:ref:`VIDIOC_QUERYBUF <VIDIOC_QUERYBUF>`
     A new struct :ref:`v4l2_plane <v4l2-plane>` structure for
     describing planes is added. Arrays of this structure are passed in
     the new ``m.planes`` field of struct
     :ref:`v4l2_buffer <v4l2-buffer>`.
 
-:ref:`VIDIOC_REQBUFS <vidioc-reqbufs>`
+:ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>`
     Will allocate multi-planar buffers as requested.
 
 
diff --git a/Documentation/linux_tv/media/v4l/querycap.rst b/Documentation/linux_tv/media/v4l/querycap.rst
index ce0c0e3f9b53..d8f080a68195 100644
--- a/Documentation/linux_tv/media/v4l/querycap.rst
+++ b/Documentation/linux_tv/media/v4l/querycap.rst
@@ -11,26 +11,26 @@ are equally applicable to all types of devices. Furthermore devices of
 the same type have different capabilities and this specification permits
 the omission of a few complicated and less important parts of the API.
 
-The :ref:`VIDIOC_QUERYCAP <vidioc-querycap>` ioctl is available to
+The :ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>` ioctl is available to
 check if the kernel device is compatible with this specification, and to
 query the :ref:`functions <devices>` and :ref:`I/O methods <io>`
 supported by the device.
 
-Starting with kernel version 3.1, :ref:`VIDIOC_QUERYCAP <vidioc-querycap>`
+Starting with kernel version 3.1, :ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>`
 will return the V4L2 API version used by the driver, with generally
 matches the Kernel version. There's no need of using
-:ref:`VIDIOC_QUERYCAP <vidioc-querycap>` to check if a specific ioctl
+:ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>` to check if a specific ioctl
 is supported, the V4L2 core now returns ENOTTY if a driver doesn't
 provide support for an ioctl.
 
 Other features can be queried by calling the respective ioctl, for
-example :ref:`VIDIOC_ENUMINPUT <vidioc-enuminput>` to learn about the
+example :ref:`VIDIOC_ENUMINPUT <VIDIOC_ENUMINPUT>` to learn about the
 number, types and names of video connectors on the device. Although
 abstraction is a major objective of this API, the
-:ref:`VIDIOC_QUERYCAP <vidioc-querycap>` ioctl also allows driver
+:ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>` ioctl also allows driver
 specific applications to reliably identify the driver.
 
-All V4L2 drivers must support :ref:`VIDIOC_QUERYCAP <vidioc-querycap>`.
+All V4L2 drivers must support :ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>`.
 Applications should always call this ioctl after opening the device.
 
 
diff --git a/Documentation/linux_tv/media/v4l/rw.rst b/Documentation/linux_tv/media/v4l/rw.rst
index c123d3a1bfbb..ad365a6e435d 100644
--- a/Documentation/linux_tv/media/v4l/rw.rst
+++ b/Documentation/linux_tv/media/v4l/rw.rst
@@ -10,7 +10,7 @@ Input and output devices support the :c:func:`read()` and
 :c:func:`write()` function, respectively, when the
 ``V4L2_CAP_READWRITE`` flag in the ``capabilities`` field of struct
 :ref:`v4l2_capability <v4l2-capability>` returned by the
-:ref:`VIDIOC_QUERYCAP <vidioc-querycap>` ioctl is set.
+:ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>` ioctl is set.
 
 Drivers may need the CPU to copy the data, but they may also support DMA
 to or from user memory, so this I/O method is not necessarily less
diff --git a/Documentation/linux_tv/media/v4l/selection-api-004.rst b/Documentation/linux_tv/media/v4l/selection-api-004.rst
index d023cd022295..4890815e268e 100644
--- a/Documentation/linux_tv/media/v4l/selection-api-004.rst
+++ b/Documentation/linux_tv/media/v4l/selection-api-004.rst
@@ -4,7 +4,7 @@
 Configuration
 *************
 
-Applications can use the :ref:`selection API <vidioc-g-selection>` to
+Applications can use the :ref:`selection API <VIDIOC_G_SELECTION>` to
 select an area in a video signal or a buffer, and to query for default
 settings and hardware limits.
 
diff --git a/Documentation/linux_tv/media/v4l/standard.rst b/Documentation/linux_tv/media/v4l/standard.rst
index db80861c1446..da0b8101b6cc 100644
--- a/Documentation/linux_tv/media/v4l/standard.rst
+++ b/Documentation/linux_tv/media/v4l/standard.rst
@@ -11,8 +11,8 @@ variations of standards. Each video input and output may support another
 set of standards. This set is reported by the ``std`` field of struct
 :ref:`v4l2_input <v4l2-input>` and struct
 :ref:`v4l2_output <v4l2-output>` returned by the
-:ref:`VIDIOC_ENUMINPUT <vidioc-enuminput>` and
-:ref:`VIDIOC_ENUMOUTPUT <vidioc-enumoutput>` ioctls, respectively.
+:ref:`VIDIOC_ENUMINPUT <VIDIOC_ENUMINPUT>` and
+:ref:`VIDIOC_ENUMOUTPUT <VIDIOC_ENUMOUTPUT>` ioctls, respectively.
 
 V4L2 defines one bit for each analog video standard currently in use
 worldwide, and sets aside bits for driver defined standards, e. g.
@@ -20,7 +20,7 @@ hybrid standards to watch NTSC video tapes on PAL TVs and vice versa.
 Applications can use the predefined bits to select a particular
 standard, although presenting the user a menu of supported standards is
 preferred. To enumerate and query the attributes of the supported
-standards applications use the :ref:`VIDIOC_ENUMSTD <vidioc-enumstd>`
+standards applications use the :ref:`VIDIOC_ENUMSTD <VIDIOC_ENUMSTD>`
 ioctl.
 
 Many of the defined standards are actually just variations of a few
@@ -36,10 +36,10 @@ Composite input may collapse standards, enumerating "PAL-B/G/H/I",
 "NTSC-M" and "SECAM-D/K". [1]_
 
 To query and select the standard used by the current video input or
-output applications call the :ref:`VIDIOC_G_STD <vidioc-g-std>` and
-:ref:`VIDIOC_S_STD <vidioc-g-std>` ioctl, respectively. The
+output applications call the :ref:`VIDIOC_G_STD <VIDIOC_G_STD>` and
+:ref:`VIDIOC_S_STD <VIDIOC_G_STD>` ioctl, respectively. The
 *received* standard can be sensed with the
-:ref:`VIDIOC_QUERYSTD <vidioc-querystd>` ioctl. Note that the
+:ref:`VIDIOC_QUERYSTD <VIDIOC_QUERYSTD>` ioctl. Note that the
 parameter of all these ioctls is a pointer to a
 :ref:`v4l2_std_id <v4l2-std-id>` type (a standard set), *not* an
 index into the standard enumeration. Drivers must implement all video
diff --git a/Documentation/linux_tv/media/v4l/streaming-par.rst b/Documentation/linux_tv/media/v4l/streaming-par.rst
index 53f4d7c23a8a..bb8100b6ef87 100644
--- a/Documentation/linux_tv/media/v4l/streaming-par.rst
+++ b/Documentation/linux_tv/media/v4l/streaming-par.rst
@@ -8,7 +8,7 @@ Streaming Parameters
 
 Streaming parameters are intended to optimize the video capture process
 as well as I/O. Presently applications can request a high quality
-capture mode with the :ref:`VIDIOC_S_PARM <vidioc-g-parm>` ioctl.
+capture mode with the :ref:`VIDIOC_S_PARM <VIDIOC_G_PARM>` ioctl.
 
 The current video standard determines a nominal number of frames per
 second. If less than this number of frames is to be captured or output,
@@ -23,8 +23,8 @@ internally by a driver in read/write mode. For implications see the
 section discussing the :ref:`read() <func-read>` function.
 
 To get and set the streaming parameters applications call the
-:ref:`VIDIOC_G_PARM <vidioc-g-parm>` and
-:ref:`VIDIOC_S_PARM <vidioc-g-parm>` ioctl, respectively. They take
+:ref:`VIDIOC_G_PARM <VIDIOC_G_PARM>` and
+:ref:`VIDIOC_S_PARM <VIDIOC_G_PARM>` ioctl, respectively. They take
 a pointer to a struct :ref:`v4l2_streamparm <v4l2-streamparm>`, which
 contains a union holding separate parameters for input and output
 devices.
diff --git a/Documentation/linux_tv/media/v4l/tuner.rst b/Documentation/linux_tv/media/v4l/tuner.rst
index bc22a99579e3..15c2e6c373ab 100644
--- a/Documentation/linux_tv/media/v4l/tuner.rst
+++ b/Documentation/linux_tv/media/v4l/tuner.rst
@@ -14,7 +14,7 @@ Video input devices can have one or more tuners demodulating a RF
 signal. Each tuner is associated with one or more video inputs,
 depending on the number of RF connectors on the tuner. The ``type``
 field of the respective struct :ref:`v4l2_input <v4l2-input>`
-returned by the :ref:`VIDIOC_ENUMINPUT <vidioc-enuminput>` ioctl is
+returned by the :ref:`VIDIOC_ENUMINPUT <VIDIOC_ENUMINPUT>` ioctl is
 set to ``V4L2_INPUT_TYPE_TUNER`` and its ``tuner`` field contains the
 index number of the tuner.
 
@@ -22,8 +22,8 @@ Radio input devices have exactly one tuner with index zero, no video
 inputs.
 
 To query and change tuner properties applications use the
-:ref:`VIDIOC_G_TUNER <vidioc-g-tuner>` and
-:ref:`VIDIOC_S_TUNER <vidioc-g-tuner>` ioctls, respectively. The
+:ref:`VIDIOC_G_TUNER <VIDIOC_G_TUNER>` and
+:ref:`VIDIOC_S_TUNER <VIDIOC_G_TUNER>` ioctls, respectively. The
 struct :ref:`v4l2_tuner <v4l2-tuner>` returned by ``VIDIOC_G_TUNER``
 also contains signal status information applicable when the tuner of the
 current video or radio input is queried. Note that ``VIDIOC_S_TUNER``
@@ -31,7 +31,7 @@ does not switch the current tuner, when there is more than one at all.
 The tuner is solely determined by the current video input. Drivers must
 support both ioctls and set the ``V4L2_CAP_TUNER`` flag in the struct
 :ref:`v4l2_capability <v4l2-capability>` returned by the
-:ref:`VIDIOC_QUERYCAP <vidioc-querycap>` ioctl when the device has
+:ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>` ioctl when the device has
 one or more tuners.
 
 
@@ -44,7 +44,7 @@ set or video recorder. Each modulator is associated with one or more
 video outputs, depending on the number of RF connectors on the
 modulator. The ``type`` field of the respective struct
 :ref:`v4l2_output <v4l2-output>` returned by the
-:ref:`VIDIOC_ENUMOUTPUT <vidioc-enumoutput>` ioctl is set to
+:ref:`VIDIOC_ENUMOUTPUT <VIDIOC_ENUMOUTPUT>` ioctl is set to
 ``V4L2_OUTPUT_TYPE_MODULATOR`` and its ``modulator`` field contains the
 index number of the modulator.
 
@@ -55,18 +55,18 @@ A video or radio device cannot support both a tuner and a modulator. Two
 separate device nodes will have to be used for such hardware, one that
 supports the tuner functionality and one that supports the modulator
 functionality. The reason is a limitation with the
-:ref:`VIDIOC_S_FREQUENCY <vidioc-g-frequency>` ioctl where you
+:ref:`VIDIOC_S_FREQUENCY <VIDIOC_G_FREQUENCY>` ioctl where you
 cannot specify whether the frequency is for a tuner or a modulator.
 
 To query and change modulator properties applications use the
-:ref:`VIDIOC_G_MODULATOR <vidioc-g-modulator>` and
-:ref:`VIDIOC_S_MODULATOR <vidioc-g-modulator>` ioctl. Note that
+:ref:`VIDIOC_G_MODULATOR <VIDIOC_G_MODULATOR>` and
+:ref:`VIDIOC_S_MODULATOR <VIDIOC_G_MODULATOR>` ioctl. Note that
 ``VIDIOC_S_MODULATOR`` does not switch the current modulator, when there
 is more than one at all. The modulator is solely determined by the
 current video output. Drivers must support both ioctls and set the
 ``V4L2_CAP_MODULATOR`` flag in the struct
 :ref:`v4l2_capability <v4l2-capability>` returned by the
-:ref:`VIDIOC_QUERYCAP <vidioc-querycap>` ioctl when the device has
+:ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>` ioctl when the device has
 one or more modulators.
 
 
@@ -74,8 +74,8 @@ Radio Frequency
 ===============
 
 To get and set the tuner or modulator radio frequency applications use
-the :ref:`VIDIOC_G_FREQUENCY <vidioc-g-frequency>` and
-:ref:`VIDIOC_S_FREQUENCY <vidioc-g-frequency>` ioctl which both take
+the :ref:`VIDIOC_G_FREQUENCY <VIDIOC_G_FREQUENCY>` and
+:ref:`VIDIOC_S_FREQUENCY <VIDIOC_G_FREQUENCY>` ioctl which both take
 a pointer to a struct :ref:`v4l2_frequency <v4l2-frequency>`. These
 ioctls are used for TV and radio devices alike. Drivers must support
 both ioctls when the tuner or modulator ioctls are supported, or when
diff --git a/Documentation/linux_tv/media/v4l/userp.rst b/Documentation/linux_tv/media/v4l/userp.rst
index 83558d27bd69..5433025d41d9 100644
--- a/Documentation/linux_tv/media/v4l/userp.rst
+++ b/Documentation/linux_tv/media/v4l/userp.rst
@@ -9,10 +9,10 @@ Streaming I/O (User Pointers)
 Input and output devices support this I/O method when the
 ``V4L2_CAP_STREAMING`` flag in the ``capabilities`` field of struct
 :ref:`v4l2_capability <v4l2-capability>` returned by the
-:ref:`VIDIOC_QUERYCAP <vidioc-querycap>` ioctl is set. If the
+:ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>` ioctl is set. If the
 particular user pointer method (not only memory mapping) is supported
 must be determined by calling the
-:ref:`VIDIOC_REQBUFS <vidioc-reqbufs>` ioctl.
+:ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>` ioctl.
 
 This I/O method combines advantages of the read/write and memory mapping
 methods. Buffers (planes) are allocated by the application itself, and
@@ -21,7 +21,7 @@ data are exchanged, these pointers and meta-information are passed in
 struct :ref:`v4l2_buffer <v4l2-buffer>` (or in struct
 :ref:`v4l2_plane <v4l2-plane>` in the multi-planar API case). The
 driver must be switched into user pointer I/O mode by calling the
-:ref:`VIDIOC_REQBUFS <vidioc-reqbufs>` with the desired buffer type.
+:ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>` with the desired buffer type.
 No buffers (planes) are allocated beforehand, consequently they are not
 indexed and cannot be queried like mapped buffers with the
 ``VIDIOC_QUERYBUF`` ioctl.
@@ -45,7 +45,7 @@ indexed and cannot be queried like mapped buffers with the
     }
 
 Buffer (plane) addresses and sizes are passed on the fly with the
-:ref:`VIDIOC_QBUF <vidioc-qbuf>` ioctl. Although buffers are commonly
+:ref:`VIDIOC_QBUF <VIDIOC_QBUF>` ioctl. Although buffers are commonly
 cycled, applications can pass different addresses and sizes at each
 ``VIDIOC_QBUF`` call. If required by the hardware the driver swaps
 memory pages within physical memory to create a continuous area of
@@ -55,11 +55,11 @@ to disk they are brought back and finally locked in physical memory for
 DMA. [1]_
 
 Filled or displayed buffers are dequeued with the
-:ref:`VIDIOC_DQBUF <vidioc-qbuf>` ioctl. The driver can unlock the
+:ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctl. The driver can unlock the
 memory pages at any time between the completion of the DMA and this
 ioctl. The memory is also unlocked when
-:ref:`VIDIOC_STREAMOFF <vidioc-streamon>` is called,
-:ref:`VIDIOC_REQBUFS <vidioc-reqbufs>`, or when the device is closed.
+:ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` is called,
+:ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>`, or when the device is closed.
 Applications must take care not to free buffers without dequeuing. For
 once, the buffers remain locked until further, wasting physical memory.
 Second the driver will not be notified when the memory is returned to
@@ -82,8 +82,8 @@ immediately with an EAGAIN error code when no buffer is available. The
 are always available.
 
 To start and stop capturing or output applications call the
-:ref:`VIDIOC_STREAMON <vidioc-streamon>` and
-:ref:`VIDIOC_STREAMOFF <vidioc-streamon>` ioctl. Note
+:ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>` and
+:ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` ioctl. Note
 ``VIDIOC_STREAMOFF`` removes all buffers from both queues and unlocks
 all buffers as a side effect. Since there is no notion of doing anything
 "now" on a multitasking system, if an application needs to synchronize
diff --git a/Documentation/linux_tv/media/v4l/v4l2.rst b/Documentation/linux_tv/media/v4l/v4l2.rst
index 44605ec92a50..c9ba2859ebe5 100644
--- a/Documentation/linux_tv/media/v4l/v4l2.rst
+++ b/Documentation/linux_tv/media/v4l/v4l2.rst
@@ -86,7 +86,7 @@ Revision History
 
 :revision: 4.5 / 2015-10-29 (*rr*)
 
-Extend vidioc-g-ext-ctrls;. Replace ctrl_class with a new union with
+Extend VIDIOC_G_EXT_CTRLS;. Replace ctrl_class with a new union with
 ctrl_class and which. Which is used to select the current value of the
 control or the default value.
 
diff --git a/Documentation/linux_tv/media/v4l/video.rst b/Documentation/linux_tv/media/v4l/video.rst
index fc220be52c2b..e4e543b56989 100644
--- a/Documentation/linux_tv/media/v4l/video.rst
+++ b/Documentation/linux_tv/media/v4l/video.rst
@@ -14,17 +14,17 @@ Radio devices have no video inputs or outputs.
 
 To learn about the number and attributes of the available inputs and
 outputs applications can enumerate them with the
-:ref:`VIDIOC_ENUMINPUT <vidioc-enuminput>` and
-:ref:`VIDIOC_ENUMOUTPUT <vidioc-enumoutput>` ioctl, respectively. The
+:ref:`VIDIOC_ENUMINPUT <VIDIOC_ENUMINPUT>` and
+:ref:`VIDIOC_ENUMOUTPUT <VIDIOC_ENUMOUTPUT>` ioctl, respectively. The
 struct :ref:`v4l2_input <v4l2-input>` returned by the
-:ref:`VIDIOC_ENUMINPUT <vidioc-enuminput>` ioctl also contains signal
+:ref:`VIDIOC_ENUMINPUT <VIDIOC_ENUMINPUT>` ioctl also contains signal
 :status information applicable when the current video input is queried.
 
-The :ref:`VIDIOC_G_INPUT <vidioc-g-input>` and
-:ref:`VIDIOC_G_OUTPUT <vidioc-g-output>` ioctls return the index of
+The :ref:`VIDIOC_G_INPUT <VIDIOC_G_INPUT>` and
+:ref:`VIDIOC_G_OUTPUT <VIDIOC_G_OUTPUT>` ioctls return the index of
 the current video input or output. To select a different input or output
-applications call the :ref:`VIDIOC_S_INPUT <vidioc-g-input>` and
-:ref:`VIDIOC_S_OUTPUT <vidioc-g-output>` ioctls. Drivers must
+applications call the :ref:`VIDIOC_S_INPUT <VIDIOC_G_INPUT>` and
+:ref:`VIDIOC_S_OUTPUT <VIDIOC_G_OUTPUT>` ioctls. Drivers must
 implement all the input ioctls when the device has one or more inputs,
 all the output ioctls when the device has one or more outputs.
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-create-bufs.rst b/Documentation/linux_tv/media/v4l/vidioc-create-bufs.rst
index e512fe26569e..9c2a011f389c 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-create-bufs.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-create-bufs.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-create-bufs:
+.. _VIDIOC_CREATE_BUFS:
 
 ************************
 ioctl VIDIOC_CREATE_BUFS
@@ -34,7 +34,7 @@ Description
 This ioctl is used to create buffers for :ref:`memory mapped <mmap>`
 or :ref:`user pointer <userp>` or :ref:`DMA buffer <dmabuf>` I/O. It
 can be used as an alternative or in addition to the
-:ref:`VIDIOC_REQBUFS <vidioc-reqbufs>` ioctl, when a tighter control
+:ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>` ioctl, when a tighter control
 over buffers is required. This ioctl can be called multiple times to
 create buffers of different sizes.
 
@@ -47,8 +47,8 @@ array must be zeroed.
 The ``format`` field specifies the image format that the buffers must be
 able to handle. The application has to fill in this struct
 :ref:`v4l2_format <v4l2-format>`. Usually this will be done using the
-:ref:`VIDIOC_TRY_FMT <vidioc-g-fmt>` or
-:ref:`VIDIOC_G_FMT <vidioc-g-fmt>` ioctls to ensure that the
+:ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` or
+:ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` ioctls to ensure that the
 requested format is supported by the driver. Based on the format's
 ``type`` field the requested buffer size (for single-planar) or plane
 sizes (for multi-planar formats) will be used for the allocated buffers.
diff --git a/Documentation/linux_tv/media/v4l/vidioc-cropcap.rst b/Documentation/linux_tv/media/v4l/vidioc-cropcap.rst
index 7fa9e2750457..22b5efe1d2e4 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-cropcap.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-cropcap.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-cropcap:
+.. _VIDIOC_CROPCAP:
 
 ********************
 ioctl VIDIOC_CROPCAP
diff --git a/Documentation/linux_tv/media/v4l/vidioc-dbg-g-chip-info.rst b/Documentation/linux_tv/media/v4l/vidioc-dbg-g-chip-info.rst
index 0bb92acd1729..0a92e2550ce0 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-dbg-g-chip-info.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-dbg-g-chip-info.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-dbg-g-chip-info:
+.. _VIDIOC_DBG_G_CHIP_INFO:
 
 ****************************
 ioctl VIDIOC_DBG_G_CHIP_INFO
diff --git a/Documentation/linux_tv/media/v4l/vidioc-dbg-g-register.rst b/Documentation/linux_tv/media/v4l/vidioc-dbg-g-register.rst
index 613fd256d9bc..1b86abcc44c7 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-dbg-g-register.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-dbg-g-register.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-dbg-g-register:
+.. _VIDIOC_DBG_G_REGISTER:
 
 **************************************************
 ioctl VIDIOC_DBG_G_REGISTER, VIDIOC_DBG_S_REGISTER
@@ -65,14 +65,14 @@ When ``match.type`` is ``V4L2_CHIP_MATCH_BRIDGE``, ``match.addr``
 selects the nth non-sub-device chip on the TV card. The number zero
 always selects the host chip, e. g. the chip connected to the PCI or USB
 bus. You can find out which chips are present with the
-:ref:`VIDIOC_DBG_G_CHIP_INFO <vidioc-dbg-g-chip-info>` ioctl.
+:ref:`VIDIOC_DBG_G_CHIP_INFO <VIDIOC_DBG_G_CHIP_INFO>` ioctl.
 
 When ``match.type`` is ``V4L2_CHIP_MATCH_SUBDEV``, ``match.addr``
 selects the nth sub-device.
 
 These ioctls are optional, not all drivers may support them. However
 when a driver supports these ioctls it must also support
-:ref:`VIDIOC_DBG_G_CHIP_INFO <vidioc-dbg-g-chip-info>`. Conversely
+:ref:`VIDIOC_DBG_G_CHIP_INFO <VIDIOC_DBG_G_CHIP_INFO>`. Conversely
 it may support ``VIDIOC_DBG_G_CHIP_INFO`` but not these ioctls.
 
 ``VIDIOC_DBG_G_REGISTER`` and ``VIDIOC_DBG_S_REGISTER`` were introduced
diff --git a/Documentation/linux_tv/media/v4l/vidioc-decoder-cmd.rst b/Documentation/linux_tv/media/v4l/vidioc-decoder-cmd.rst
index 77c7bdfb90df..ec9dfed09f76 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-decoder-cmd.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-decoder-cmd.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-decoder-cmd:
+.. _VIDIOC_DECODER_CMD:
 
 ************************************************
 ioctl VIDIOC_DECODER_CMD, VIDIOC_TRY_DECODER_CMD
@@ -43,11 +43,11 @@ this structure.
 The ``cmd`` field must contain the command code. Some commands use the
 ``flags`` field for additional information.
 
-A :c:func:`write()`() or :ref:`VIDIOC_STREAMON <vidioc-streamon>`
+A :c:func:`write()`() or :ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>`
 call sends an implicit START command to the decoder if it has not been
 started yet.
 
-A :c:func:`close()`() or :ref:`VIDIOC_STREAMOFF <vidioc-streamon>`
+A :c:func:`close()`() or :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>`
 call of a streaming file descriptor sends an implicit immediate STOP
 command to the decoder, and all buffered data is discarded.
 
@@ -224,7 +224,7 @@ introduced in Linux 3.3.
           new buffers produced to dequeue. This buffer may be empty,
           indicated by the driver setting the ``bytesused`` field to 0. Once
           the ``V4L2_BUF_FLAG_LAST`` flag was set, the
-          :ref:`VIDIOC_DQBUF <vidioc-qbuf>` ioctl will not block anymore,
+          :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctl will not block anymore,
           but return an EPIPE error code. If
           ``V4L2_DEC_CMD_STOP_IMMEDIATELY`` is set, then the decoder stops
           immediately (ignoring the ``pts`` value), otherwise it will keep
diff --git a/Documentation/linux_tv/media/v4l/vidioc-dqevent.rst b/Documentation/linux_tv/media/v4l/vidioc-dqevent.rst
index 108348e4df29..45320997344d 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-dqevent.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-dqevent.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-dqevent:
+.. _VIDIOC_DQEVENT:
 
 ********************
 ioctl VIDIOC_DQEVENT
@@ -226,8 +226,8 @@ call.
           :ref:`v4l2_control <v4l2-control>`.
 
           If the event is generated due to a call to
-          :ref:`VIDIOC_S_CTRL <vidioc-g-ctrl>` or
-          :ref:`VIDIOC_S_EXT_CTRLS <vidioc-g-ext-ctrls>`, then the
+          :ref:`VIDIOC_S_CTRL <VIDIOC_G_CTRL>` or
+          :ref:`VIDIOC_S_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>`, then the
           event will *not* be sent to the file handle that called the ioctl
           function. This prevents nasty feedback loops. If you *do* want to
           get the event, then set the ``V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK``
@@ -363,7 +363,7 @@ call.
 
        -  The 32-bit value of the control for 32-bit control types. This is
           0 for string controls since the value of a string cannot be passed
-          using :ref:`VIDIOC_DQEVENT <vidioc-dqevent>`.
+          using :ref:`VIDIOC_DQEVENT <VIDIOC_DQEVENT>`.
 
     -  .. row 5
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-dv-timings-cap.rst b/Documentation/linux_tv/media/v4l/vidioc-dv-timings-cap.rst
index d8222ad0df52..b5b8e41dc693 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-dv-timings-cap.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-dv-timings-cap.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-dv-timings-cap:
+.. _VIDIOC_DV_TIMINGS_CAP:
 
 *********************************************************
 ioctl VIDIOC_DV_TIMINGS_CAP, VIDIOC_SUBDEV_DV_TIMINGS_CAP
diff --git a/Documentation/linux_tv/media/v4l/vidioc-encoder-cmd.rst b/Documentation/linux_tv/media/v4l/vidioc-encoder-cmd.rst
index 018f31e38c6d..ffa363eeaa36 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-encoder-cmd.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-encoder-cmd.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-encoder-cmd:
+.. _VIDIOC_ENCODER_CMD:
 
 ************************************************
 ioctl VIDIOC_ENCODER_CMD, VIDIOC_TRY_ENCODER_CMD
@@ -48,14 +48,14 @@ currently only used by the STOP command and contains one bit: If the
 until the end of the current *Group Of Pictures*, otherwise it will stop
 immediately.
 
-A :c:func:`read()`() or :ref:`VIDIOC_STREAMON <vidioc-streamon>`
+A :c:func:`read()`() or :ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>`
 call sends an implicit START command to the encoder if it has not been
 started yet. After a STOP command, :c:func:`read()`() calls will read
 the remaining data buffered by the driver. When the buffer is empty,
 :c:func:`read()`() will return zero and the next :c:func:`read()`()
 call will restart the encoder.
 
-A :c:func:`close()`() or :ref:`VIDIOC_STREAMOFF <vidioc-streamon>`
+A :c:func:`close()`() or :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>`
 call of a streaming file descriptor sends an implicit immediate STOP to
 the encoder, and all buffered data is discarded.
 
@@ -134,7 +134,7 @@ introduced in Linux 2.6.21.
           produced to dequeue. This buffer may be empty, indicated by the
           driver setting the ``bytesused`` field to 0. Once the
           ``V4L2_BUF_FLAG_LAST`` flag was set, the
-          :ref:`VIDIOC_DQBUF <vidioc-qbuf>` ioctl will not block anymore,
+          :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctl will not block anymore,
           but return an EPIPE error code.
 
     -  .. row 3
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enum-dv-timings.rst b/Documentation/linux_tv/media/v4l/vidioc-enum-dv-timings.rst
index b328829cbf76..5b8f17422fdb 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enum-dv-timings.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enum-dv-timings.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-enum-dv-timings:
+.. _VIDIOC_ENUM_DV_TIMINGS:
 
 ***********************************************************
 ioctl VIDIOC_ENUM_DV_TIMINGS, VIDIOC_SUBDEV_ENUM_DV_TIMINGS
@@ -35,7 +35,7 @@ Description
 While some DV receivers or transmitters support a wide range of timings,
 others support only a limited number of timings. With this ioctl
 applications can enumerate a list of known supported timings. Call
-:ref:`VIDIOC_DV_TIMINGS_CAP <vidioc-dv-timings-cap>` to check if it
+:ref:`VIDIOC_DV_TIMINGS_CAP <VIDIOC_DV_TIMINGS_CAP>` to check if it
 also supports other standards or even custom timings that are not in
 this list.
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enum-fmt.rst b/Documentation/linux_tv/media/v4l/vidioc-enum-fmt.rst
index bcf7eda8bfdf..f4fc2723f01e 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enum-fmt.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enum-fmt.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-enum-fmt:
+.. _VIDIOC_ENUM_FMT:
 
 *********************
 ioctl VIDIOC_ENUM_FMT
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enum-frameintervals.rst b/Documentation/linux_tv/media/v4l/vidioc-enum-frameintervals.rst
index 245e01ff2e58..2c69866c8d9e 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enum-frameintervals.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enum-frameintervals.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-enum-frameintervals:
+.. _VIDIOC_ENUM_FRAMEINTERVALS:
 
 ********************************
 ioctl VIDIOC_ENUM_FRAMEINTERVALS
@@ -38,8 +38,8 @@ This ioctl allows applications to enumerate all frame intervals that the
 device supports for the given pixel format and frame size.
 
 The supported pixel formats and frame sizes can be obtained by using the
-:ref:`VIDIOC_ENUM_FMT <vidioc-enum-fmt>` and
-:ref:`VIDIOC_ENUM_FRAMESIZES <vidioc-enum-framesizes>` functions.
+:ref:`VIDIOC_ENUM_FMT <VIDIOC_ENUM_FMT>` and
+:ref:`VIDIOC_ENUM_FRAMESIZES <VIDIOC_ENUM_FRAMESIZES>` functions.
 
 The return value and the content of the ``v4l2_frmivalenum.type`` field
 depend on the type of frame intervals the device supports. Here are the
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enum-framesizes.rst b/Documentation/linux_tv/media/v4l/vidioc-enum-framesizes.rst
index e3d2ad50db74..9b763ca9d0d8 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enum-framesizes.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enum-framesizes.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-enum-framesizes:
+.. _VIDIOC_ENUM_FRAMESIZES:
 
 ****************************
 ioctl VIDIOC_ENUM_FRAMESIZES
@@ -39,7 +39,7 @@ and height in pixels) that the device supports for the given pixel
 format.
 
 The supported pixel formats can be obtained by using the
-:ref:`VIDIOC_ENUM_FMT <vidioc-enum-fmt>` function.
+:ref:`VIDIOC_ENUM_FMT <VIDIOC_ENUM_FMT>` function.
 
 The return value and the content of the ``v4l2_frmsizeenum.type`` field
 depend on the type of frame sizes the device supports. Here are the
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enum-freq-bands.rst b/Documentation/linux_tv/media/v4l/vidioc-enum-freq-bands.rst
index 7bb726d519be..2f5dbe0583b4 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enum-freq-bands.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enum-freq-bands.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-enum-freq-bands:
+.. _VIDIOC_ENUM_FREQ_BANDS:
 
 ****************************
 ioctl VIDIOC_ENUM_FREQ_BANDS
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enumaudio.rst b/Documentation/linux_tv/media/v4l/vidioc-enumaudio.rst
index c42e13bf0578..dcca0591864e 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enumaudio.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enumaudio.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-enumaudio:
+.. _VIDIOC_ENUMAUDIO:
 
 **********************
 ioctl VIDIOC_ENUMAUDIO
@@ -39,7 +39,7 @@ structure or return an EINVAL error code when the index is out of
 bounds. To enumerate all audio inputs applications shall begin at index
 zero, incrementing by one until the driver returns EINVAL.
 
-See :ref:`vidioc-g-audio` for a description of struct
+See :ref:`VIDIOC_G_AUDIO` for a description of struct
 :ref:`v4l2_audio <v4l2-audio>`.
 
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enumaudioout.rst b/Documentation/linux_tv/media/v4l/vidioc-enumaudioout.rst
index 54157607d90d..29735eddac5d 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enumaudioout.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enumaudioout.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-enumaudioout:
+.. _VIDIOC_ENUMAUDIOOUT:
 
 ***********************
 ioctl VIDIOC_ENUMAUDOUT
@@ -42,7 +42,7 @@ zero, incrementing by one until the driver returns EINVAL.
 Note connectors on a TV card to loop back the received audio signal to a
 sound card are not audio outputs in this sense.
 
-See :ref:`vidioc-g-audioout` for a description of struct
+See :ref:`VIDIOC_G_AUDIOout` for a description of struct
 :ref:`v4l2_audioout <v4l2-audioout>`.
 
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enuminput.rst b/Documentation/linux_tv/media/v4l/vidioc-enuminput.rst
index 32c8dac7f400..644d50679aa2 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enuminput.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enuminput.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-enuminput:
+.. _VIDIOC_ENUMINPUT:
 
 **********************
 ioctl VIDIOC_ENUMINPUT
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enumoutput.rst b/Documentation/linux_tv/media/v4l/vidioc-enumoutput.rst
index 89cccda0ccaa..6ccb3d094dc8 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enumoutput.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enumoutput.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-enumoutput:
+.. _VIDIOC_ENUMOUTPUT:
 
 ***********************
 ioctl VIDIOC_ENUMOUTPUT
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enumstd.rst b/Documentation/linux_tv/media/v4l/vidioc-enumstd.rst
index d82c49028d83..d16a9494d03b 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enumstd.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enumstd.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-enumstd:
+.. _VIDIOC_ENUMSTD:
 
 ********************
 ioctl VIDIOC_ENUMSTD
diff --git a/Documentation/linux_tv/media/v4l/vidioc-expbuf.rst b/Documentation/linux_tv/media/v4l/vidioc-expbuf.rst
index 0de48b945a01..a389cbc75970 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-expbuf.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-expbuf.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-expbuf:
+.. _VIDIOC_EXPBUF:
 
 *******************
 ioctl VIDIOC_EXPBUF
@@ -35,7 +35,7 @@ This ioctl is an extension to the :ref:`memory mapping <mmap>` I/O
 method, therefore it is available only for ``V4L2_MEMORY_MMAP`` buffers.
 It can be used to export a buffer as a DMABUF file at any time after
 buffers have been allocated with the
-:ref:`VIDIOC_REQBUFS <vidioc-reqbufs>` ioctl.
+:ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>` ioctl.
 
 To export a buffer, applications fill struct
 :ref:`v4l2_exportbuffer <v4l2-exportbuffer>`. The ``type`` field is
@@ -43,7 +43,7 @@ set to the same buffer type as was previously used with struct
 :ref:`v4l2_requestbuffers <v4l2-requestbuffers>` ``type``.
 Applications must also set the ``index`` field. Valid index numbers
 range from zero to the number of buffers allocated with
-:ref:`VIDIOC_REQBUFS <vidioc-reqbufs>` (struct
+:ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>` (struct
 :ref:`v4l2_requestbuffers <v4l2-requestbuffers>` ``count``) minus
 one. For the multi-planar API, applications set the ``plane`` field to
 the index of the plane to be exported. Valid planes range from zero to
@@ -142,8 +142,8 @@ Examples
        -  Number of the buffer, set by the application. This field is only
           used for :ref:`memory mapping <mmap>` I/O and can range from
           zero to the number of buffers allocated with the
-          :ref:`VIDIOC_REQBUFS <vidioc-reqbufs>` and/or
-          :ref:`VIDIOC_CREATE_BUFS <vidioc-create-bufs>` ioctls.
+          :ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>` and/or
+          :ref:`VIDIOC_CREATE_BUFS <VIDIOC_CREATE_BUFS>` ioctls.
 
     -  .. row 3
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-audio.rst b/Documentation/linux_tv/media/v4l/vidioc-g-audio.rst
index 05df90f084e8..2a81d01a1c00 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-audio.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-audio.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-g-audio:
+.. _VIDIOC_G_AUDIO:
 
 ************************************
 ioctl VIDIOC_G_AUDIO, VIDIOC_S_AUDIO
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-audioout.rst b/Documentation/linux_tv/media/v4l/vidioc-g-audioout.rst
index ef4dce35992e..1da1e7ad51a6 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-audioout.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-audioout.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-g-audioout:
+.. _VIDIOC_G_AUDIOOUT:
 
 **************************************
 ioctl VIDIOC_G_AUDOUT, VIDIOC_S_AUDOUT
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-crop.rst b/Documentation/linux_tv/media/v4l/vidioc-g-crop.rst
index 35f70134ac81..457a6cc6b63e 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-crop.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-crop.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-g-crop:
+.. _VIDIOC_G_CROP:
 
 **********************************
 ioctl VIDIOC_G_CROP, VIDIOC_S_CROP
@@ -66,7 +66,7 @@ vertical scaling factor.
 Finally the driver programs the hardware with the actual cropping and
 image parameters. ``VIDIOC_S_CROP`` is a write-only ioctl, it does not
 return the actual parameters. To query them applications must call
-``VIDIOC_G_CROP`` and :ref:`VIDIOC_G_FMT <vidioc-g-fmt>`. When the
+``VIDIOC_G_CROP`` and :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>`. When the
 parameters are unsuitable the application may modify the cropping or
 image parameters and repeat the cycle until satisfactory parameters have
 been negotiated.
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst b/Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst
index 6381d7c13d58..6b2b157ba9c7 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-g-ctrl:
+.. _VIDIOC_G_CTRL:
 
 **********************************
 ioctl VIDIOC_G_CTRL, VIDIOC_S_CTRL
@@ -48,9 +48,9 @@ actual new value. If the ``value`` is inappropriate for the control
 EINVAL error code is returned as well.
 
 These ioctls work only with user controls. For other control classes the
-:ref:`VIDIOC_G_EXT_CTRLS <vidioc-g-ext-ctrls>`,
-:ref:`VIDIOC_S_EXT_CTRLS <vidioc-g-ext-ctrls>` or
-:ref:`VIDIOC_TRY_EXT_CTRLS <vidioc-g-ext-ctrls>` must be used.
+:ref:`VIDIOC_G_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>`,
+:ref:`VIDIOC_S_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` or
+:ref:`VIDIOC_TRY_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` must be used.
 
 
 .. _v4l2-control:
@@ -90,7 +90,7 @@ EINVAL
     The struct :ref:`v4l2_control <v4l2-control>` ``id`` is invalid
     or the ``value`` is inappropriate for the given control (i.e. if a
     menu item is selected that is not supported by the driver according
-    to :ref:`VIDIOC_QUERYMENU <vidioc-queryctrl>`).
+    to :ref:`VIDIOC_QUERYMENU <VIDIOC_QUERYCTRL>`).
 
 ERANGE
     The struct :ref:`v4l2_control <v4l2-control>` ``value`` is out of
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-dv-timings.rst b/Documentation/linux_tv/media/v4l/vidioc-g-dv-timings.rst
index 19598b10d425..84f9db487822 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-dv-timings.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-dv-timings.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-g-dv-timings:
+.. _VIDIOC_G_DV_TIMINGS:
 
 **********************************************
 ioctl VIDIOC_G_DV_TIMINGS, VIDIOC_S_DV_TIMINGS
@@ -47,7 +47,7 @@ values are not correct, the driver returns EINVAL error code.
 The ``linux/v4l2-dv-timings.h`` header can be used to get the timings of
 the formats in the :ref:`cea861` and :ref:`vesadmt` standards. If
 the current input or output does not support DV timings (e.g. if
-:ref:`VIDIOC_ENUMINPUT <vidioc-enuminput>` does not set the
+:ref:`VIDIOC_ENUMINPUT <VIDIOC_ENUMINPUT>` does not set the
 ``V4L2_IN_CAP_DV_TIMINGS`` flag), then ENODATA error code is returned.
 
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-edid.rst b/Documentation/linux_tv/media/v4l/vidioc-g-edid.rst
index 3138cfe7a26e..26bbf060aa51 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-edid.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-edid.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-g-edid:
+.. _VIDIOC_G_EDID:
 
 ******************************************************************************
 ioctl VIDIOC_G_EDID, VIDIOC_S_EDID, VIDIOC_SUBDEV_G_EDID, VIDIOC_SUBDEV_S_EDID
@@ -44,8 +44,8 @@ with subdevice nodes (/dev/v4l-subdevX) or with video nodes
 
 When used with video nodes the ``pad`` field represents the input (for
 video capture devices) or output (for video output devices) index as is
-returned by :ref:`VIDIOC_ENUMINPUT <vidioc-enuminput>` and
-:ref:`VIDIOC_ENUMOUTPUT <vidioc-enumoutput>` respectively. When used
+returned by :ref:`VIDIOC_ENUMINPUT <VIDIOC_ENUMINPUT>` and
+:ref:`VIDIOC_ENUMOUTPUT <VIDIOC_ENUMOUTPUT>` respectively. When used
 with subdevice nodes the ``pad`` field represents the input or output
 pad of the subdevice. If there is no EDID support for the given ``pad``
 value, then the EINVAL error code will be returned.
@@ -105,8 +105,8 @@ EDID is no longer available.
 
        -  Pad for which to get/set the EDID blocks. When used with a video
           device node the pad represents the input or output index as
-          returned by :ref:`VIDIOC_ENUMINPUT <vidioc-enuminput>` and
-          :ref:`VIDIOC_ENUMOUTPUT <vidioc-enumoutput>` respectively.
+          returned by :ref:`VIDIOC_ENUMINPUT <VIDIOC_ENUMINPUT>` and
+          :ref:`VIDIOC_ENUMOUTPUT <VIDIOC_ENUMOUTPUT>` respectively.
 
     -  .. row 2
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-enc-index.rst b/Documentation/linux_tv/media/v4l/vidioc-g-enc-index.rst
index 5edf9cb46d15..68af83d964f6 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-enc-index.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-enc-index.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-g-enc-index:
+.. _VIDIOC_G_ENC_INDEX:
 
 ************************
 ioctl VIDIOC_G_ENC_INDEX
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-ext-ctrls.rst b/Documentation/linux_tv/media/v4l/vidioc-g-ext-ctrls.rst
index 66dce741a3c0..f800458d9dfe 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-ext-ctrls.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-ext-ctrls.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-g-ext-ctrls:
+.. _VIDIOC_G_EXT_CTRLS:
 
 ******************************************************************
 ioctl VIDIOC_G_EXT_CTRLS, VIDIOC_S_EXT_CTRLS, VIDIOC_TRY_EXT_CTRLS
@@ -58,14 +58,14 @@ set ``size`` to a valid value and return an ENOSPC error code. You
 should re-allocate the memory to this new size and try again. For the
 string type it is possible that the same issue occurs again if the
 string has grown in the meantime. It is recommended to call
-:ref:`VIDIOC_QUERYCTRL <vidioc-queryctrl>` first and use
+:ref:`VIDIOC_QUERYCTRL <VIDIOC_QUERYCTRL>` first and use
 ``maximum``\ +1 as the new ``size`` value. It is guaranteed that that is
 sufficient memory.
 
 N-dimensional arrays are set and retrieved row-by-row. You cannot set a
 partial array, all elements have to be set or retrieved. The total size
 is calculated as ``elems`` * ``elem_size``. These values can be obtained
-by calling :ref:`VIDIOC_QUERY_EXT_CTRL <vidioc-queryctrl>`.
+by calling :ref:`VIDIOC_QUERY_EXT_CTRL <VIDIOC_QUERYCTRL>`.
 
 To change the value of a set of controls applications initialize the
 ``id``, ``size``, ``reserved2`` and ``value/value64/string/ptr`` fields
@@ -366,8 +366,8 @@ still cause this situation.
 
        -  The class containing user controls. These controls are described
           in :ref:`control`. All controls that can be set using the
-          :ref:`VIDIOC_S_CTRL <vidioc-g-ctrl>` and
-          :ref:`VIDIOC_G_CTRL <vidioc-g-ctrl>` ioctl belong to this
+          :ref:`VIDIOC_S_CTRL <VIDIOC_G_CTRL>` and
+          :ref:`VIDIOC_G_CTRL <VIDIOC_G_CTRL>` ioctl belong to this
           class.
 
     -  .. row 2
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-fbuf.rst b/Documentation/linux_tv/media/v4l/vidioc-g-fbuf.rst
index 499881e92a28..f4703b3449b3 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-fbuf.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-fbuf.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-g-fbuf:
+.. _VIDIOC_G_FBUF:
 
 **********************************
 ioctl VIDIOC_G_FBUF, VIDIOC_S_FBUF
@@ -39,7 +39,7 @@ to get and set the framebuffer parameters for a
 :ref:`Video Overlay <overlay>` or :ref:`Video Output Overlay <osd>`
 (OSD). The type of overlay is implied by the device type (capture or
 output device) and can be determined with the
-:ref:`VIDIOC_QUERYCAP <vidioc-querycap>` ioctl. One ``/dev/videoN``
+:ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>` ioctl. One ``/dev/videoN``
 device must not support both kinds of overlay.
 
 The V4L2 API distinguishes destructive and non-destructive overlays. A
@@ -202,7 +202,7 @@ destructive video overlay.
 
        -  Drivers and applications shall ignore this field. If applicable,
           the field order is selected with the
-          :ref:`VIDIOC_S_FMT <vidioc-g-fmt>` ioctl, using the ``field``
+          :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl, using the ``field``
           field of struct :ref:`v4l2_window <v4l2-window>`.
 
     -  .. row 13
@@ -396,12 +396,12 @@ destructive video overlay.
        -  If this flag is set for a video capture device, then the driver
           will set the initial overlay size to cover the full framebuffer
           size, otherwise the existing overlay size (as set by
-          :ref:`VIDIOC_S_FMT <vidioc-g-fmt>`) will be used. Only one
+          :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`) will be used. Only one
           video capture driver (bttv) supports this flag. The use of this
           flag for capture devices is deprecated. There is no way to detect
           which drivers support this flag, so the only reliable method of
           setting the overlay size is through
-          :ref:`VIDIOC_S_FMT <vidioc-g-fmt>`. If this flag is set for a
+          :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`. If this flag is set for a
           video output device, then the video output overlay window is
           relative to the top-left corner of the framebuffer and restricted
           to the size of the framebuffer. If it is cleared, then the video
@@ -415,14 +415,14 @@ destructive video overlay.
 
        -  Use chroma-keying. The chroma-key color is determined by the
           ``chromakey`` field of struct :ref:`v4l2_window <v4l2-window>`
-          and negotiated with the :ref:`VIDIOC_S_FMT <vidioc-g-fmt>`
+          and negotiated with the :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`
           ioctl, see :ref:`overlay` and :ref:`osd`.
 
     -  .. row 4
 
        -  :cspan:`2` There are no flags to enable clipping using a list of
           clip rectangles or a bitmap. These methods are negotiated with the
-          :ref:`VIDIOC_S_FMT <vidioc-g-fmt>` ioctl, see :ref:`overlay`
+          :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl, see :ref:`overlay`
           and :ref:`osd`.
 
     -  .. row 5
@@ -447,7 +447,7 @@ destructive video overlay.
           + video pixel * (255 - alpha)) / 255. The alpha value is
           determined by the ``global_alpha`` field of struct
           :ref:`v4l2_window <v4l2-window>` and negotiated with the
-          :ref:`VIDIOC_S_FMT <vidioc-g-fmt>` ioctl, see :ref:`overlay`
+          :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl, see :ref:`overlay`
           and :ref:`osd`.
 
     -  .. row 7
@@ -471,7 +471,7 @@ destructive video overlay.
        -  Use source chroma-keying. The source chroma-key color is
           determined by the ``chromakey`` field of struct
           :ref:`v4l2_window <v4l2-window>` and negotiated with the
-          :ref:`VIDIOC_S_FMT <vidioc-g-fmt>` ioctl, see :ref:`overlay`
+          :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl, see :ref:`overlay`
           and :ref:`osd`. Both chroma-keying are mutual exclusive to each
           other, so same ``chromakey`` field of struct
           :ref:`v4l2_window <v4l2-window>` is being used.
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-fmt.rst b/Documentation/linux_tv/media/v4l/vidioc-g-fmt.rst
index ed1daa32122b..1d392e6c538d 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-fmt.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-fmt.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-g-fmt:
+.. _VIDIOC_G_FMT:
 
 ************************************************
 ioctl VIDIOC_G_FMT, VIDIOC_S_FMT, VIDIOC_TRY_FMT
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-frequency.rst b/Documentation/linux_tv/media/v4l/vidioc-g-frequency.rst
index 1d9f0fe86fb0..ce247577c3a0 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-frequency.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-frequency.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-g-frequency:
+.. _VIDIOC_G_FREQUENCY:
 
 ********************************************
 ioctl VIDIOC_G_FREQUENCY, VIDIOC_S_FREQUENCY
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-input.rst b/Documentation/linux_tv/media/v4l/vidioc-g-input.rst
index fffba83242ed..62990976ff9b 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-input.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-input.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-g-input:
+.. _VIDIOC_G_INPUT:
 
 ************************************
 ioctl VIDIOC_G_INPUT, VIDIOC_S_INPUT
@@ -47,7 +47,7 @@ applications must select an input before querying or negotiating any
 other parameters.
 
 Information about video inputs is available using the
-:ref:`VIDIOC_ENUMINPUT <vidioc-enuminput>` ioctl.
+:ref:`VIDIOC_ENUMINPUT <VIDIOC_ENUMINPUT>` ioctl.
 
 
 Return Value
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-jpegcomp.rst b/Documentation/linux_tv/media/v4l/vidioc-g-jpegcomp.rst
index 05d4ebf221e2..acd05bf0d7b6 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-jpegcomp.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-jpegcomp.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-g-jpegcomp:
+.. _VIDIOC_G_JPEGCOMP:
 
 ******************************************
 ioctl VIDIOC_G_JPEGCOMP, VIDIOC_S_JPEGCOMP
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-modulator.rst b/Documentation/linux_tv/media/v4l/vidioc-g-modulator.rst
index 3a8ae0a5891a..4399a13f94c1 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-modulator.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-modulator.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-g-modulator:
+.. _VIDIOC_G_MODULATOR:
 
 ********************************************
 ioctl VIDIOC_G_MODULATOR, VIDIOC_S_MODULATOR
@@ -57,7 +57,7 @@ initialized to zero. The term 'modulator' means SDR transmitter in this
 context.
 
 To change the radio frequency the
-:ref:`VIDIOC_S_FREQUENCY <vidioc-g-frequency>` ioctl is available.
+:ref:`VIDIOC_S_FREQUENCY <VIDIOC_G_FREQUENCY>` ioctl is available.
 
 
 .. _v4l2-modulator:
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-output.rst b/Documentation/linux_tv/media/v4l/vidioc-g-output.rst
index 8341f1f8a45c..3b9ea56e3b9e 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-output.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-output.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-g-output:
+.. _VIDIOC_G_OUTPUT:
 
 **************************************
 ioctl VIDIOC_G_OUTPUT, VIDIOC_S_OUTPUT
@@ -48,7 +48,7 @@ effects applications must select an output before querying or
 negotiating any other parameters.
 
 Information about video outputs is available using the
-:ref:`VIDIOC_ENUMOUTPUT <vidioc-enumoutput>` ioctl.
+:ref:`VIDIOC_ENUMOUTPUT <VIDIOC_ENUMOUTPUT>` ioctl.
 
 
 Return Value
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-parm.rst b/Documentation/linux_tv/media/v4l/vidioc-g-parm.rst
index 2892653b5bc4..07432d386356 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-parm.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-parm.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-g-parm:
+.. _VIDIOC_G_PARM:
 
 **********************************
 ioctl VIDIOC_G_PARM, VIDIOC_S_PARM
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-priority.rst b/Documentation/linux_tv/media/v4l/vidioc-g-priority.rst
index 0706f2f85a79..ee80c9e0c7d4 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-priority.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-priority.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-g-priority:
+.. _VIDIOC_G_PRIORITY:
 
 ******************************************
 ioctl VIDIOC_G_PRIORITY, VIDIOC_S_PRIORITY
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-selection.rst b/Documentation/linux_tv/media/v4l/vidioc-g-selection.rst
index 7846553dc4de..fd07c87a369c 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-selection.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-selection.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-g-selection:
+.. _VIDIOC_G_SELECTION:
 
 ********************************************
 ioctl VIDIOC_G_SELECTION, VIDIOC_S_SELECTION
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-sliced-vbi-cap.rst b/Documentation/linux_tv/media/v4l/vidioc-g-sliced-vbi-cap.rst
index c76f5682ad0a..8c86d2b41a5b 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-sliced-vbi-cap.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-sliced-vbi-cap.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-g-sliced-vbi-cap:
+.. _VIDIOC_G_SLICED_VBI_CAP:
 
 *****************************
 ioctl VIDIOC_G_SLICED_VBI_CAP
@@ -134,7 +134,7 @@ to write-read, in Linux 2.6.19.
           given line may be limited. For example on PAL line 16 the hardware
           may be able to look for a VPS or Teletext signal, but not both at
           the same time. Applications can learn about these limits using the
-          :ref:`VIDIOC_S_FMT <vidioc-g-fmt>` ioctl as described in
+          :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl as described in
           :ref:`sliced`.
 
     -  .. row 10
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-std.rst b/Documentation/linux_tv/media/v4l/vidioc-g-std.rst
index c01e8c1f51d0..9cbf2d2995c6 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-std.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-std.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-g-std:
+.. _VIDIOC_G_STD:
 
 ********************************
 ioctl VIDIOC_G_STD, VIDIOC_S_STD
@@ -48,7 +48,7 @@ no flags are given or the current input does not support the requested
 standard the driver returns an EINVAL error code. When the standard set
 is ambiguous drivers may return EINVAL or choose any of the requested
 standards. If the current input or output does not support standard
-video timings (e.g. if :ref:`VIDIOC_ENUMINPUT <vidioc-enuminput>`
+video timings (e.g. if :ref:`VIDIOC_ENUMINPUT <VIDIOC_ENUMINPUT>`
 does not set the ``V4L2_IN_CAP_STD`` flag), then ENODATA error code is
 returned.
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-tuner.rst b/Documentation/linux_tv/media/v4l/vidioc-g-tuner.rst
index d897f6862b9d..1ad5107a0ad5 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-tuner.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-tuner.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-g-tuner:
+.. _VIDIOC_G_TUNER:
 
 ************************************
 ioctl VIDIOC_G_TUNER, VIDIOC_S_TUNER
@@ -56,7 +56,7 @@ selected audio mode.
 to zero. The term 'tuner' means SDR receiver in this context.
 
 To change the radio frequency the
-:ref:`VIDIOC_S_FREQUENCY <vidioc-g-frequency>` ioctl is available.
+:ref:`VIDIOC_S_FREQUENCY <VIDIOC_G_FREQUENCY>` ioctl is available.
 
 
 .. _v4l2-tuner:
@@ -323,7 +323,7 @@ To change the radio frequency the
           determined from the frequency band.) The set of supported video
           standards is available from the struct
           :ref:`v4l2_input <v4l2-input>` pointing to this tuner, see the
-          description of ioctl :ref:`VIDIOC_ENUMINPUT <vidioc-enuminput>`
+          description of ioctl :ref:`VIDIOC_ENUMINPUT <VIDIOC_ENUMINPUT>`
           for details. Only ``V4L2_TUNER_ANALOG_TV`` tuners can have this
           capability.
 
@@ -425,7 +425,7 @@ To change the radio frequency the
 
        -  0x0400
 
-       -  The :ref:`VIDIOC_ENUM_FREQ_BANDS <vidioc-enum-freq-bands>`
+       -  The :ref:`VIDIOC_ENUM_FREQ_BANDS <VIDIOC_ENUM_FREQ_BANDS>`
           ioctl can be used to enumerate the available frequency bands.
 
     -  .. row 13
@@ -436,7 +436,7 @@ To change the radio frequency the
 
        -  The range to search when using the hardware seek functionality is
           programmable, see
-          :ref:`VIDIOC_S_HW_FREQ_SEEK <vidioc-s-hw-freq-seek>` for
+          :ref:`VIDIOC_S_HW_FREQ_SEEK <VIDIOC_S_HW_FREQ_SEEK>` for
           details.
 
     -  .. row 14
diff --git a/Documentation/linux_tv/media/v4l/vidioc-log-status.rst b/Documentation/linux_tv/media/v4l/vidioc-log-status.rst
index 0706274ff6a3..6df7c2fd5b6c 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-log-status.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-log-status.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-log-status:
+.. _VIDIOC_LOG_STATUS:
 
 ***********************
 ioctl VIDIOC_LOG_STATUS
diff --git a/Documentation/linux_tv/media/v4l/vidioc-overlay.rst b/Documentation/linux_tv/media/v4l/vidioc-overlay.rst
index d82d24fd7fb2..e0373a9d6f14 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-overlay.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-overlay.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-overlay:
+.. _VIDIOC_OVERLAY:
 
 ********************
 ioctl VIDIOC_OVERLAY
@@ -36,8 +36,8 @@ Applications call ``VIDIOC_OVERLAY`` to start or stop the overlay. It
 takes a pointer to an integer which must be set to zero by the
 application to stop overlay, to one to start.
 
-Drivers do not support :ref:`VIDIOC_STREAMON <vidioc-streamon>` or
-:ref:`VIDIOC_STREAMOFF <vidioc-streamon>` with
+Drivers do not support :ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>` or
+:ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` with
 ``V4L2_BUF_TYPE_VIDEO_OVERLAY``.
 
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-prepare-buf.rst b/Documentation/linux_tv/media/v4l/vidioc-prepare-buf.rst
index c29757f38066..fb3ac38b3db2 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-prepare-buf.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-prepare-buf.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-prepare-buf:
+.. _VIDIOC_PREPARE_BUF:
 
 ************************
 ioctl VIDIOC_PREPARE_BUF
diff --git a/Documentation/linux_tv/media/v4l/vidioc-qbuf.rst b/Documentation/linux_tv/media/v4l/vidioc-qbuf.rst
index 6912780b0e3d..045fa53e0417 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-qbuf.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-qbuf.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-qbuf:
+.. _VIDIOC_QBUF:
 
 *******************************
 ioctl VIDIOC_QBUF, VIDIOC_DQBUF
@@ -42,10 +42,10 @@ previously used with struct :ref:`v4l2_format <v4l2-format>` ``type``
 and struct :ref:`v4l2_requestbuffers <v4l2-requestbuffers>` ``type``.
 Applications must also set the ``index`` field. Valid index numbers
 range from zero to the number of buffers allocated with
-:ref:`VIDIOC_REQBUFS <vidioc-reqbufs>` (struct
+:ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>` (struct
 :ref:`v4l2_requestbuffers <v4l2-requestbuffers>` ``count``) minus
 one. The contents of the struct :c:type:`struct v4l2_buffer` returned
-by a :ref:`VIDIOC_QUERYBUF <vidioc-querybuf>` ioctl will do as well.
+by a :ref:`VIDIOC_QUERYBUF <VIDIOC_QUERYBUF>` ioctl will do as well.
 When the buffer is intended for output (``type`` is
 ``V4L2_BUF_TYPE_VIDEO_OUTPUT``, ``V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE``,
 or ``V4L2_BUF_TYPE_VBI_OUTPUT``) applications must also initialize the
@@ -75,8 +75,8 @@ the driver sets the ``V4L2_BUF_FLAG_QUEUED`` flag and clears the
 ``flags`` field, or it returns an error code. This ioctl locks the
 memory pages of the buffer in physical memory, they cannot be swapped
 out to disk. Buffers remain locked until dequeued, until the
-:ref:`VIDIOC_STREAMOFF <vidioc-streamon>` or
-:ref:`VIDIOC_REQBUFS <vidioc-reqbufs>` ioctl is called, or until the
+:ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` or
+:ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>` ioctl is called, or until the
 device is closed.
 
 To enqueue a :ref:`DMABUF <dmabuf>` buffer applications set the
@@ -91,8 +91,8 @@ sets the ``V4L2_BUF_FLAG_QUEUED`` flag and clears the
 buffer. Locking a buffer means passing it to a driver for a hardware
 access (usually DMA). If an application accesses (reads/writes) a locked
 buffer then the result is undefined. Buffers remain locked until
-dequeued, until the :ref:`VIDIOC_STREAMOFF <vidioc-streamon>` or
-:ref:`VIDIOC_REQBUFS <vidioc-reqbufs>` ioctl is called, or until the
+dequeued, until the :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` or
+:ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>` ioctl is called, or until the
 device is closed.
 
 Applications call the ``VIDIOC_DQBUF`` ioctl to dequeue a filled
diff --git a/Documentation/linux_tv/media/v4l/vidioc-query-dv-timings.rst b/Documentation/linux_tv/media/v4l/vidioc-query-dv-timings.rst
index 567faa73e23b..88aedbd1fcae 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-query-dv-timings.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-query-dv-timings.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-query-dv-timings:
+.. _VIDIOC_QUERY_DV_TIMINGS:
 
 *****************************
 ioctl VIDIOC_QUERY_DV_TIMINGS
@@ -56,7 +56,7 @@ the receiver could lock to the signal, but the format is unsupported
 (e.g. because the pixelclock is out of range of the hardware
 capabilities), then the driver fills in whatever timings it could find
 and returns ERANGE. In that case the application can call
-:ref:`VIDIOC_DV_TIMINGS_CAP <vidioc-dv-timings-cap>` to compare the
+:ref:`VIDIOC_DV_TIMINGS_CAP <VIDIOC_DV_TIMINGS_CAP>` to compare the
 found timings with the hardware's capabilities in order to give more
 precise feedback to the user.
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-querybuf.rst b/Documentation/linux_tv/media/v4l/vidioc-querybuf.rst
index 092ed4586a18..baa3ad6591c7 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-querybuf.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-querybuf.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-querybuf:
+.. _VIDIOC_QUERYBUF:
 
 *********************
 ioctl VIDIOC_QUERYBUF
@@ -33,7 +33,7 @@ Description
 
 This ioctl is part of the :ref:`streaming <mmap>` I/O method. It can
 be used to query the status of a buffer at any time after buffers have
-been allocated with the :ref:`VIDIOC_REQBUFS <vidioc-reqbufs>` ioctl.
+been allocated with the :ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>` ioctl.
 
 Applications set the ``type`` field of a struct
 :ref:`v4l2_buffer <v4l2-buffer>` to the same buffer type as was
@@ -41,7 +41,7 @@ previously used with struct :ref:`v4l2_format <v4l2-format>` ``type``
 and struct :ref:`v4l2_requestbuffers <v4l2-requestbuffers>` ``type``,
 and the ``index`` field. Valid index numbers range from zero to the
 number of buffers allocated with
-:ref:`VIDIOC_REQBUFS <vidioc-reqbufs>` (struct
+:ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>` (struct
 :ref:`v4l2_requestbuffers <v4l2-requestbuffers>` ``count``) minus
 one. The ``reserved`` and ``reserved2`` fields must be set to 0. When
 using the :ref:`multi-planar API <planar-apis>`, the ``m.planes``
diff --git a/Documentation/linux_tv/media/v4l/vidioc-querycap.rst b/Documentation/linux_tv/media/v4l/vidioc-querycap.rst
index 54f86443dfcc..3032a9ee1c6b 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-querycap.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-querycap.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-querycap:
+.. _VIDIOC_QUERYCAP:
 
 *********************
 ioctl VIDIOC_QUERYCAP
@@ -308,7 +308,7 @@ specification the ioctl returns an EINVAL error code.
        -  0x00000400
 
        -  The device supports the
-          :ref:`VIDIOC_S_HW_FREQ_SEEK <vidioc-s-hw-freq-seek>` ioctl
+          :ref:`VIDIOC_S_HW_FREQ_SEEK <VIDIOC_S_HW_FREQ_SEEK>` ioctl
           for hardware frequency seeking.
 
     -  .. row 15
diff --git a/Documentation/linux_tv/media/v4l/vidioc-queryctrl.rst b/Documentation/linux_tv/media/v4l/vidioc-queryctrl.rst
index 116b69c1f818..7d38a51c4f73 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-queryctrl.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-queryctrl.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-queryctrl:
+.. _VIDIOC_QUERYCTRL:
 
 ***************************************************************
 ioctl VIDIOC_QUERYCTRL, VIDIOC_QUERY_EXT_CTRL, VIDIOC_QUERYMENU
@@ -566,10 +566,10 @@ See also the examples in :ref:`control`.
           the string must be (minimum + N * step) characters long for N ≥ 0.
           These lengths do not include the terminating zero, so in order to
           pass a string of length 8 to
-          :ref:`VIDIOC_S_EXT_CTRLS <vidioc-g-ext-ctrls>` you need to
+          :ref:`VIDIOC_S_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` you need to
           set the ``size`` field of struct
           :ref:`v4l2_ext_control <v4l2-ext-control>` to 9. For
-          :ref:`VIDIOC_G_EXT_CTRLS <vidioc-g-ext-ctrls>` you can set
+          :ref:`VIDIOC_G_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` you can set
           the ``size`` field to ``maximum`` + 1. Which character encoding is
           used will depend on the string control itself and should be part
           of the control documentation.
diff --git a/Documentation/linux_tv/media/v4l/vidioc-querystd.rst b/Documentation/linux_tv/media/v4l/vidioc-querystd.rst
index 8e22ba4b9c99..1d825fff9d15 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-querystd.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-querystd.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-querystd:
+.. _VIDIOC_QUERYSTD:
 
 *********************
 ioctl VIDIOC_QUERYSTD
diff --git a/Documentation/linux_tv/media/v4l/vidioc-reqbufs.rst b/Documentation/linux_tv/media/v4l/vidioc-reqbufs.rst
index 621e3c1e054d..c17d3b0465d6 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-reqbufs.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-reqbufs.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-reqbufs:
+.. _VIDIOC_REQBUFS:
 
 ********************
 ioctl VIDIOC_REQBUFS
@@ -62,7 +62,7 @@ Applications can call ``VIDIOC_REQBUFS`` again to change the number of
 buffers, however this cannot succeed when any buffers are still mapped.
 A ``count`` value of zero frees all buffers, after aborting or finishing
 any DMA in progress, an implicit
-:ref:`VIDIOC_STREAMOFF <vidioc-streamon>`.
+:ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>`.
 
 
 .. _v4l2-requestbuffers:
diff --git a/Documentation/linux_tv/media/v4l/vidioc-s-hw-freq-seek.rst b/Documentation/linux_tv/media/v4l/vidioc-s-hw-freq-seek.rst
index 72ae6ba6bada..19c2e0afd7de 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-s-hw-freq-seek.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-s-hw-freq-seek.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-s-hw-freq-seek:
+.. _VIDIOC_S_HW_FREQ_SEEK:
 
 ***************************
 ioctl VIDIOC_S_HW_FREQ_SEEK
@@ -43,10 +43,10 @@ to tell the driver to search a specific band. If the struct
 :ref:`v4l2_tuner <v4l2-tuner>` ``capability`` field has the
 ``V4L2_TUNER_CAP_HWSEEK_PROG_LIM`` flag set, these values must fall
 within one of the bands returned by
-:ref:`VIDIOC_ENUM_FREQ_BANDS <vidioc-enum-freq-bands>`. If the
+:ref:`VIDIOC_ENUM_FREQ_BANDS <VIDIOC_ENUM_FREQ_BANDS>`. If the
 ``V4L2_TUNER_CAP_HWSEEK_PROG_LIM`` flag is not set, then these values
 must exactly match those of one of the bands returned by
-:ref:`VIDIOC_ENUM_FREQ_BANDS <vidioc-enum-freq-bands>`. If the
+:ref:`VIDIOC_ENUM_FREQ_BANDS <VIDIOC_ENUM_FREQ_BANDS>`. If the
 current frequency of the tuner does not fall within the selected band it
 will be clamped to fit in the band before the seek is started.
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-streamon.rst b/Documentation/linux_tv/media/v4l/vidioc-streamon.rst
index 0f7f6e00a759..349204d81334 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-streamon.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-streamon.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-streamon:
+.. _VIDIOC_STREAMON:
 
 ***************************************
 ioctl VIDIOC_STREAMON, VIDIOC_STREAMOFF
@@ -55,14 +55,14 @@ and it removes all buffers from the incoming and outgoing queues. That
 means all images captured but not dequeued yet will be lost, likewise
 all images enqueued for output but not transmitted yet. I/O returns to
 the same state as after calling
-:ref:`VIDIOC_REQBUFS <vidioc-reqbufs>` and can be restarted
+:ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>` and can be restarted
 accordingly.
 
-If buffers have been queued with :ref:`VIDIOC_QBUF <vidioc-qbuf>` and
+If buffers have been queued with :ref:`VIDIOC_QBUF <VIDIOC_QBUF>` and
 ``VIDIOC_STREAMOFF`` is called without ever having called
 ``VIDIOC_STREAMON``, then those queued buffers will also be removed from
 the incoming queue and all are returned to the same state as after
-calling :ref:`VIDIOC_REQBUFS <vidioc-reqbufs>` and can be restarted
+calling :ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>` and can be restarted
 accordingly.
 
 Both ioctls take a pointer to an integer, the desired buffer or stream
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-interval.rst b/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-interval.rst
index 87506d6b0e53..d9f27e32eb60 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-interval.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-interval.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-subdev-enum-frame-interval:
+.. _VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL:
 
 ***************************************
 ioctl VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL
@@ -52,7 +52,7 @@ one until EINVAL is returned.
 
 Available frame intervals may depend on the current 'try' formats at
 other pads of the sub-device, as well as on the current active links.
-See :ref:`VIDIOC_SUBDEV_G_FMT <vidioc-subdev-g-fmt>` for more
+See :ref:`VIDIOC_SUBDEV_G_FMT <VIDIOC_SUBDEV_G_FMT>` for more
 information about the try formats.
 
 Sub-devices that support the frame interval enumeration ioctl should
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-size.rst b/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-size.rst
index 7f867e2930be..49be2eefaa57 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-size.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-size.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-subdev-enum-frame-size:
+.. _VIDIOC_SUBDEV_ENUM_FRAME_SIZE:
 
 ***********************************
 ioctl VIDIOC_SUBDEV_ENUM_FRAME_SIZE
@@ -34,7 +34,7 @@ Description
 This ioctl allows applications to enumerate all frame sizes supported by
 a sub-device on the given pad for the given media bus format. Supported
 formats can be retrieved with the
-:ref:`VIDIOC_SUBDEV_ENUM_MBUS_CODE <vidioc-subdev-enum-mbus-code>`
+:ref:`VIDIOC_SUBDEV_ENUM_MBUS_CODE <VIDIOC_SUBDEV_ENUM_MBUS_CODE>`
 ioctl.
 
 To enumerate frame sizes applications initialize the ``pad``, ``which``
@@ -52,13 +52,13 @@ Not all possible sizes in given [minimum, maximum] ranges need to be
 supported. For instance, a scaler that uses a fixed-point scaling ratio
 might not be able to produce every frame size between the minimum and
 maximum values. Applications must use the
-:ref:`VIDIOC_SUBDEV_S_FMT <vidioc-subdev-g-fmt>` ioctl to try the
+:ref:`VIDIOC_SUBDEV_S_FMT <VIDIOC_SUBDEV_G_FMT>` ioctl to try the
 sub-device for an exact supported frame size.
 
 Available frame sizes may depend on the current 'try' formats at other
 pads of the sub-device, as well as on the current active links and the
 current values of V4L2 controls. See
-:ref:`VIDIOC_SUBDEV_G_FMT <vidioc-subdev-g-fmt>` for more
+:ref:`VIDIOC_SUBDEV_G_FMT <VIDIOC_SUBDEV_G_FMT>` for more
 information about try formats.
 
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-mbus-code.rst b/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-mbus-code.rst
index 97534457db6a..a9b0baba2633 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-mbus-code.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-mbus-code.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-subdev-enum-mbus-code:
+.. _VIDIOC_SUBDEV_ENUM_MBUS_CODE:
 
 **********************************
 ioctl VIDIOC_SUBDEV_ENUM_MBUS_CODE
@@ -43,7 +43,7 @@ one until EINVAL is returned.
 
 Available media bus formats may depend on the current 'try' formats at
 other pads of the sub-device, as well as on the current active links.
-See :ref:`VIDIOC_SUBDEV_G_FMT <vidioc-subdev-g-fmt>` for more
+See :ref:`VIDIOC_SUBDEV_G_FMT <VIDIOC_SUBDEV_G_FMT>` for more
 information about the try formats.
 
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subdev-g-crop.rst b/Documentation/linux_tv/media/v4l/vidioc-subdev-g-crop.rst
index e54a07c8ba1d..bef416cfe46c 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-subdev-g-crop.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-subdev-g-crop.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-subdev-g-crop:
+.. _VIDIOC_SUBDEV_G_CROP:
 
 ************************************************
 ioctl VIDIOC_SUBDEV_G_CROP, VIDIOC_SUBDEV_S_CROP
@@ -38,7 +38,7 @@ Description
 
     This is an :ref:`obsolete <obsolete>` interface and may be removed
     in the future. It is superseded by
-    :ref:`the selection API <vidioc-subdev-g-selection>`.
+    :ref:`the selection API <VIDIOC_SUBDEV_G_SELECTION>`.
 
 To retrieve the current crop rectangle applications set the ``pad``
 field of a struct :ref:`v4l2_subdev_crop <v4l2-subdev-crop>` to the
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subdev-g-fmt.rst b/Documentation/linux_tv/media/v4l/vidioc-subdev-g-fmt.rst
index 5dcbc03b4ffc..789277a2647a 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-subdev-g-fmt.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-subdev-g-fmt.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-subdev-g-fmt:
+.. _VIDIOC_SUBDEV_G_FMT:
 
 **********************************************
 ioctl VIDIOC_SUBDEV_G_FMT, VIDIOC_SUBDEV_S_FMT
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subdev-g-frame-interval.rst b/Documentation/linux_tv/media/v4l/vidioc-subdev-g-frame-interval.rst
index af0918900f8a..bcc54e2e396f 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-subdev-g-frame-interval.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-subdev-g-frame-interval.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-subdev-g-frame-interval:
+.. _VIDIOC_SUBDEV_G_FRAME_INTERVAL:
 
 ********************************************************************
 ioctl VIDIOC_SUBDEV_G_FRAME_INTERVAL, VIDIOC_SUBDEV_S_FRAME_INTERVAL
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subdev-g-selection.rst b/Documentation/linux_tv/media/v4l/vidioc-subdev-g-selection.rst
index 8e4c8e10494e..7b60c9b99aad 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-subdev-g-selection.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-subdev-g-selection.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-subdev-g-selection:
+.. _VIDIOC_SUBDEV_G_SELECTION:
 
 **********************************************************
 ioctl VIDIOC_SUBDEV_G_SELECTION, VIDIOC_SUBDEV_S_SELECTION
@@ -37,7 +37,7 @@ functionality performed by the subdevs which affect the image size. This
 currently includes cropping, scaling and composition.
 
 The selection API replaces
-:ref:`the old subdev crop API <vidioc-subdev-g-crop>`. All the
+:ref:`the old subdev crop API <VIDIOC_SUBDEV_G_CROP>`. All the
 function of the crop API, and more, are supported by the selections API.
 
 See :ref:`subdev` for more information on how each selection target
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subscribe-event.rst b/Documentation/linux_tv/media/v4l/vidioc-subscribe-event.rst
index f12981c38f63..8d0e346461e9 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-subscribe-event.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-subscribe-event.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _vidioc-subscribe-event:
+.. _VIDIOC_SUBSCRIBE_EVENT:
 
 ******************************************************
 ioctl VIDIOC_SUBSCRIBE_EVENT, VIDIOC_UNSUBSCRIBE_EVENT
@@ -33,7 +33,7 @@ Description
 ===========
 
 Subscribe or unsubscribe V4L2 event. Subscribed events are dequeued by
-using the :ref:`VIDIOC_DQEVENT <vidioc-dqevent>` ioctl.
+using the :ref:`VIDIOC_DQEVENT <VIDIOC_DQEVENT>` ioctl.
 
 
 .. _v4l2-event-subscription:
@@ -110,7 +110,7 @@ using the :ref:`VIDIOC_DQEVENT <vidioc-dqevent>` ioctl.
 
        -  If set, then events directly caused by an ioctl will also be sent
           to the filehandle that called that ioctl. For example, changing a
-          control using :ref:`VIDIOC_S_CTRL <vidioc-g-ctrl>` will cause
+          control using :ref:`VIDIOC_S_CTRL <VIDIOC_G_CTRL>` will cause
           a V4L2_EVENT_CTRL to be sent back to that same filehandle.
           Normally such events are suppressed to prevent feedback loops
           where an application changes a control to a one value and then
@@ -118,7 +118,7 @@ using the :ref:`VIDIOC_DQEVENT <vidioc-dqevent>` ioctl.
           has changed to the first value.
 
           Since it can't tell whether that event was caused by another
-          application or by the :ref:`VIDIOC_S_CTRL <vidioc-g-ctrl>`
+          application or by the :ref:`VIDIOC_S_CTRL <VIDIOC_G_CTRL>`
           call it is hard to decide whether to set the control to the value
           in the event, or ignore it.
 
-- 
2.7.4


