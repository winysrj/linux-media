Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44855 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593AbcGDLrZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 07:47:25 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 12/51] Documentation: linux_tv: simplify references
Date: Mon,  4 Jul 2016 08:46:33 -0300
Message-Id: <54570090c3f23c597a35910232387a009b5c1218.1467629489.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are lots of internal references in the form:
	:ref:`foo <foo>`

Simplify them to be just: :ref:`foo`.

Patch generated via this small script:

for j in $(find . -name '*.rst'); do echo $j; perl -ne 'if (m/\`(\S+)\s*\<(\S+)\>\`/) { if (!($1=~'http') && $1 eq $2) { s,\s*\<(\S+)\>,,; } } print $_' <$j >a && mv a $j; done

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../media/dvb/FE_DISHNETWORK_SEND_LEGACY_CMD.rst   |  2 +-
 Documentation/linux_tv/media/dvb/FE_GET_EVENT.rst  |  2 +-
 .../linux_tv/media/dvb/FE_GET_FRONTEND.rst         |  4 +-
 Documentation/linux_tv/media/dvb/FE_READ_BER.rst   |  4 +-
 .../linux_tv/media/dvb/FE_READ_SIGNAL_STRENGTH.rst |  4 +-
 Documentation/linux_tv/media/dvb/FE_READ_SNR.rst   |  4 +-
 .../media/dvb/FE_READ_UNCORRECTED_BLOCKS.rst       |  4 +-
 .../linux_tv/media/dvb/FE_SET_FRONTEND.rst         |  8 +--
 .../linux_tv/media/dvb/audio_function_calls.rst    |  2 +-
 .../linux_tv/media/dvb/dvb-fe-read-status.rst      |  4 +-
 .../media/dvb/frontend-stat-properties.rst         |  2 +-
 .../linux_tv/media/dvb/frontend_f_open.rst         |  2 +-
 .../linux_tv/media/dvb/query-dvb-frontend-info.rst |  2 +-
 .../linux_tv/media/dvb/video_function_calls.rst    | 14 ++--
 Documentation/linux_tv/media/v4l/app-pri.rst       |  4 +-
 Documentation/linux_tv/media/v4l/audio.rst         | 14 ++--
 Documentation/linux_tv/media/v4l/buffer.rst        | 26 ++++----
 Documentation/linux_tv/media/v4l/control.rst       |  8 +--
 Documentation/linux_tv/media/v4l/crop.rst          |  6 +-
 Documentation/linux_tv/media/v4l/dev-capture.rst   |  6 +-
 Documentation/linux_tv/media/v4l/dev-codec.rst     |  2 +-
 Documentation/linux_tv/media/v4l/dev-event.rst     |  4 +-
 Documentation/linux_tv/media/v4l/dev-osd.rst       |  6 +-
 Documentation/linux_tv/media/v4l/dev-output.rst    |  4 +-
 Documentation/linux_tv/media/v4l/dev-overlay.rst   | 14 ++--
 Documentation/linux_tv/media/v4l/dev-radio.rst     |  6 +-
 Documentation/linux_tv/media/v4l/dev-raw-vbi.rst   |  8 +--
 Documentation/linux_tv/media/v4l/dev-rds.rst       |  4 +-
 Documentation/linux_tv/media/v4l/dev-sdr.rst       | 16 ++---
 .../linux_tv/media/v4l/dev-sliced-vbi.rst          | 18 +++---
 Documentation/linux_tv/media/v4l/dev-subdev.rst    | 10 +--
 Documentation/linux_tv/media/v4l/dev-teletext.rst  |  2 +-
 Documentation/linux_tv/media/v4l/diff-v4l.rst      | 58 ++++++++---------
 Documentation/linux_tv/media/v4l/dmabuf.rst        | 12 ++--
 Documentation/linux_tv/media/v4l/dv-timings.rst    |  8 +--
 .../linux_tv/media/v4l/extended-controls.rst       | 28 ++++----
 Documentation/linux_tv/media/v4l/format.rst        |  6 +-
 Documentation/linux_tv/media/v4l/func-mmap.rst     |  6 +-
 Documentation/linux_tv/media/v4l/func-poll.rst     | 10 +--
 Documentation/linux_tv/media/v4l/func-read.rst     |  2 +-
 Documentation/linux_tv/media/v4l/func-select.rst   |  4 +-
 Documentation/linux_tv/media/v4l/hist-v4l2.rst     | 74 +++++++++++-----------
 Documentation/linux_tv/media/v4l/io.rst            |  2 +-
 .../linux_tv/media/v4l/libv4l-introduction.rst     |  8 +--
 Documentation/linux_tv/media/v4l/mmap.rst          | 16 ++---
 Documentation/linux_tv/media/v4l/open.rst          |  4 +-
 Documentation/linux_tv/media/v4l/pixfmt-013.rst    |  2 +-
 .../linux_tv/media/v4l/pixfmt-packed-rgb.rst       |  2 +-
 Documentation/linux_tv/media/v4l/pixfmt.rst        |  2 +-
 Documentation/linux_tv/media/v4l/planar-apis.rst   | 10 +--
 Documentation/linux_tv/media/v4l/querycap.rst      | 12 ++--
 Documentation/linux_tv/media/v4l/rw.rst            |  2 +-
 Documentation/linux_tv/media/v4l/standard.rst      | 10 +--
 Documentation/linux_tv/media/v4l/streaming-par.rst |  2 +-
 Documentation/linux_tv/media/v4l/tuner.rst         | 14 ++--
 Documentation/linux_tv/media/v4l/userp.rst         | 12 ++--
 Documentation/linux_tv/media/v4l/video.rst         | 10 +--
 .../linux_tv/media/v4l/vidioc-create-bufs.rst      |  4 +-
 .../linux_tv/media/v4l/vidioc-dbg-g-chip-info.rst  |  2 +-
 .../linux_tv/media/v4l/vidioc-dbg-g-register.rst   |  6 +-
 .../linux_tv/media/v4l/vidioc-decoder-cmd.rst      |  2 +-
 .../linux_tv/media/v4l/vidioc-dqevent.rst          |  2 +-
 .../linux_tv/media/v4l/vidioc-encoder-cmd.rst      |  2 +-
 .../linux_tv/media/v4l/vidioc-enum-dv-timings.rst  |  2 +-
 .../media/v4l/vidioc-enum-frameintervals.rst       |  4 +-
 .../linux_tv/media/v4l/vidioc-enum-framesizes.rst  |  2 +-
 Documentation/linux_tv/media/v4l/vidioc-expbuf.rst |  8 +--
 Documentation/linux_tv/media/v4l/vidioc-g-crop.rst |  2 +-
 Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst |  2 +-
 .../linux_tv/media/v4l/vidioc-g-dv-timings.rst     |  2 +-
 Documentation/linux_tv/media/v4l/vidioc-g-edid.rst |  8 +--
 .../linux_tv/media/v4l/vidioc-g-ext-ctrls.rst      |  4 +-
 Documentation/linux_tv/media/v4l/vidioc-g-fbuf.rst |  2 +-
 .../linux_tv/media/v4l/vidioc-g-input.rst          |  2 +-
 .../linux_tv/media/v4l/vidioc-g-output.rst         |  2 +-
 Documentation/linux_tv/media/v4l/vidioc-g-std.rst  |  2 +-
 .../linux_tv/media/v4l/vidioc-g-tuner.rst          |  8 +--
 .../linux_tv/media/v4l/vidioc-overlay.rst          |  2 +-
 Documentation/linux_tv/media/v4l/vidioc-qbuf.rst   |  8 +--
 .../linux_tv/media/v4l/vidioc-query-dv-timings.rst |  2 +-
 .../linux_tv/media/v4l/vidioc-querybuf.rst         |  4 +-
 .../linux_tv/media/v4l/vidioc-querycap.rst         |  2 +-
 .../linux_tv/media/v4l/vidioc-queryctrl.rst        |  2 +-
 .../linux_tv/media/v4l/vidioc-s-hw-freq-seek.rst   |  4 +-
 .../linux_tv/media/v4l/vidioc-streamon.rst         |  6 +-
 .../v4l/vidioc-subdev-enum-frame-interval.rst      |  2 +-
 .../media/v4l/vidioc-subdev-enum-frame-size.rst    |  4 +-
 .../media/v4l/vidioc-subdev-enum-mbus-code.rst     |  2 +-
 .../linux_tv/media/v4l/vidioc-subdev-g-crop.rst    |  2 +-
 .../linux_tv/media/v4l/vidioc-subscribe-event.rst  |  2 +-
 90 files changed, 321 insertions(+), 321 deletions(-)

diff --git a/Documentation/linux_tv/media/dvb/FE_DISHNETWORK_SEND_LEGACY_CMD.rst b/Documentation/linux_tv/media/dvb/FE_DISHNETWORK_SEND_LEGACY_CMD.rst
index f4effaab9a1a..a01cafad8d3c 100644
--- a/Documentation/linux_tv/media/dvb/FE_DISHNETWORK_SEND_LEGACY_CMD.rst
+++ b/Documentation/linux_tv/media/dvb/FE_DISHNETWORK_SEND_LEGACY_CMD.rst
@@ -20,7 +20,7 @@ dishes were already legacy in 2004.
 SYNOPSIS
 
 int ioctl(int fd, int request =
-:ref:`FE_DISHNETWORK_SEND_LEGACY_CMD <FE_DISHNETWORK_SEND_LEGACY_CMD>`,
+:ref:`FE_DISHNETWORK_SEND_LEGACY_CMD`,
 unsigned long cmd);
 
 PARAMETERS
diff --git a/Documentation/linux_tv/media/dvb/FE_GET_EVENT.rst b/Documentation/linux_tv/media/dvb/FE_GET_EVENT.rst
index 75eab893c184..8d1caedd2f97 100644
--- a/Documentation/linux_tv/media/dvb/FE_GET_EVENT.rst
+++ b/Documentation/linux_tv/media/dvb/FE_GET_EVENT.rst
@@ -38,7 +38,7 @@ PARAMETERS
 
        -  int request
 
-       -  Equals :ref:`FE_GET_EVENT <FE_GET_EVENT>` for this command.
+       -  Equals :ref:`FE_GET_EVENT` for this command.
 
     -  .. row 3
 
diff --git a/Documentation/linux_tv/media/dvb/FE_GET_FRONTEND.rst b/Documentation/linux_tv/media/dvb/FE_GET_FRONTEND.rst
index 30c85cf0423c..2e60b239d1da 100644
--- a/Documentation/linux_tv/media/dvb/FE_GET_FRONTEND.rst
+++ b/Documentation/linux_tv/media/dvb/FE_GET_FRONTEND.rst
@@ -14,7 +14,7 @@ this command, read-only access to the device is sufficient.
 SYNOPSIS
 
 int ioctl(int fd, int request =
-:ref:`FE_GET_FRONTEND <FE_GET_FRONTEND>`, struct
+:ref:`FE_GET_FRONTEND`, struct
 dvb_frontend_parameters *p);
 
 PARAMETERS
@@ -36,7 +36,7 @@ PARAMETERS
 
        -  int request
 
-       -  Equals :ref:`FE_SET_FRONTEND <FE_SET_FRONTEND>` for this
+       -  Equals :ref:`FE_SET_FRONTEND` for this
           command.
 
     -  .. row 3
diff --git a/Documentation/linux_tv/media/dvb/FE_READ_BER.rst b/Documentation/linux_tv/media/dvb/FE_READ_BER.rst
index e21451886dc2..935c0e50b0fd 100644
--- a/Documentation/linux_tv/media/dvb/FE_READ_BER.rst
+++ b/Documentation/linux_tv/media/dvb/FE_READ_BER.rst
@@ -14,7 +14,7 @@ access to the device is sufficient.
 
 SYNOPSIS
 
-int ioctl(int fd, int request = :ref:`FE_READ_BER <FE_READ_BER>`,
+int ioctl(int fd, int request = :ref:`FE_READ_BER`,
 uint32_t *ber);
 
 PARAMETERS
@@ -36,7 +36,7 @@ PARAMETERS
 
        -  int request
 
-       -  Equals :ref:`FE_READ_BER <FE_READ_BER>` for this command.
+       -  Equals :ref:`FE_READ_BER` for this command.
 
     -  .. row 3
 
diff --git a/Documentation/linux_tv/media/dvb/FE_READ_SIGNAL_STRENGTH.rst b/Documentation/linux_tv/media/dvb/FE_READ_SIGNAL_STRENGTH.rst
index 3e34bea21b6c..01180e20e4d4 100644
--- a/Documentation/linux_tv/media/dvb/FE_READ_SIGNAL_STRENGTH.rst
+++ b/Documentation/linux_tv/media/dvb/FE_READ_SIGNAL_STRENGTH.rst
@@ -15,7 +15,7 @@ to the device is sufficient.
 SYNOPSIS
 
 int ioctl( int fd, int request =
-:ref:`FE_READ_SIGNAL_STRENGTH <FE_READ_SIGNAL_STRENGTH>`,
+:ref:`FE_READ_SIGNAL_STRENGTH`,
 uint16_t *strength);
 
 PARAMETERS
@@ -38,7 +38,7 @@ PARAMETERS
        -  int request
 
        -  Equals
-          :ref:`FE_READ_SIGNAL_STRENGTH <FE_READ_SIGNAL_STRENGTH>`
+          :ref:`FE_READ_SIGNAL_STRENGTH`
           for this command.
 
     -  .. row 3
diff --git a/Documentation/linux_tv/media/dvb/FE_READ_SNR.rst b/Documentation/linux_tv/media/dvb/FE_READ_SNR.rst
index b8a639706e9e..0ccc7d71d8a4 100644
--- a/Documentation/linux_tv/media/dvb/FE_READ_SNR.rst
+++ b/Documentation/linux_tv/media/dvb/FE_READ_SNR.rst
@@ -14,7 +14,7 @@ to the device is sufficient.
 
 SYNOPSIS
 
-int ioctl(int fd, int request = :ref:`FE_READ_SNR <FE_READ_SNR>`,
+int ioctl(int fd, int request = :ref:`FE_READ_SNR`,
 uint16_t *snr);
 
 PARAMETERS
@@ -36,7 +36,7 @@ PARAMETERS
 
        -  int request
 
-       -  Equals :ref:`FE_READ_SNR <FE_READ_SNR>` for this command.
+       -  Equals :ref:`FE_READ_SNR` for this command.
 
     -  .. row 3
 
diff --git a/Documentation/linux_tv/media/dvb/FE_READ_UNCORRECTED_BLOCKS.rst b/Documentation/linux_tv/media/dvb/FE_READ_UNCORRECTED_BLOCKS.rst
index 261eb20ddadf..3827c7b953e1 100644
--- a/Documentation/linux_tv/media/dvb/FE_READ_UNCORRECTED_BLOCKS.rst
+++ b/Documentation/linux_tv/media/dvb/FE_READ_UNCORRECTED_BLOCKS.rst
@@ -17,7 +17,7 @@ sufficient.
 SYNOPSIS
 
 int ioctl( int fd, int request =
-:ref:`FE_READ_UNCORRECTED_BLOCKS <FE_READ_UNCORRECTED_BLOCKS>`,
+:ref:`FE_READ_UNCORRECTED_BLOCKS`,
 uint32_t *ublocks);
 
 PARAMETERS
@@ -40,7 +40,7 @@ PARAMETERS
        -  int request
 
        -  Equals
-          :ref:`FE_READ_UNCORRECTED_BLOCKS <FE_READ_UNCORRECTED_BLOCKS>`
+          :ref:`FE_READ_UNCORRECTED_BLOCKS`
           for this command.
 
     -  .. row 3
diff --git a/Documentation/linux_tv/media/dvb/FE_SET_FRONTEND.rst b/Documentation/linux_tv/media/dvb/FE_SET_FRONTEND.rst
index 885f9e3ceb59..f18e12cb3dff 100644
--- a/Documentation/linux_tv/media/dvb/FE_SET_FRONTEND.rst
+++ b/Documentation/linux_tv/media/dvb/FE_SET_FRONTEND.rst
@@ -12,8 +12,8 @@ This ioctl call starts a tuning operation using specified parameters.
 The result of this call will be successful if the parameters were valid
 and the tuning could be initiated. The result of the tuning operation in
 itself, however, will arrive asynchronously as an event (see
-documentation for :ref:`FE_GET_EVENT <FE_GET_EVENT>` and
-FrontendEvent.) If a new :ref:`FE_SET_FRONTEND <FE_SET_FRONTEND>`
+documentation for :ref:`FE_GET_EVENT` and
+FrontendEvent.) If a new :ref:`FE_SET_FRONTEND`
 operation is initiated before the previous one was completed, the
 previous operation will be aborted in favor of the new one. This command
 requires read/write access to the device.
@@ -21,7 +21,7 @@ requires read/write access to the device.
 SYNOPSIS
 
 int ioctl(int fd, int request =
-:ref:`FE_SET_FRONTEND <FE_SET_FRONTEND>`, struct
+:ref:`FE_SET_FRONTEND`, struct
 dvb_frontend_parameters *p);
 
 PARAMETERS
@@ -43,7 +43,7 @@ PARAMETERS
 
        -  int request
 
-       -  Equals :ref:`FE_SET_FRONTEND <FE_SET_FRONTEND>` for this
+       -  Equals :ref:`FE_SET_FRONTEND` for this
           command.
 
     -  .. row 3
diff --git a/Documentation/linux_tv/media/dvb/audio_function_calls.rst b/Documentation/linux_tv/media/dvb/audio_function_calls.rst
index d1a5b5970b71..a68149e16116 100644
--- a/Documentation/linux_tv/media/dvb/audio_function_calls.rst
+++ b/Documentation/linux_tv/media/dvb/audio_function_calls.rst
@@ -456,7 +456,7 @@ AUDIO_SET_MUTE
 DESCRIPTION
 
 This ioctl is for DVB devices only. To control a V4L2 decoder use the
-V4L2 :ref:`VIDIOC_DECODER_CMD <VIDIOC_DECODER_CMD>` with the
+V4L2 :ref:`VIDIOC_DECODER_CMD` with the
 ``V4L2_DEC_CMD_START_MUTE_AUDIO`` flag instead.
 
 This ioctl call asks the audio device to mute the stream that is
diff --git a/Documentation/linux_tv/media/dvb/dvb-fe-read-status.rst b/Documentation/linux_tv/media/dvb/dvb-fe-read-status.rst
index 12d8749e9e05..e36cd134007e 100644
--- a/Documentation/linux_tv/media/dvb/dvb-fe-read-status.rst
+++ b/Documentation/linux_tv/media/dvb/dvb-fe-read-status.rst
@@ -12,10 +12,10 @@ tuner lock status and provide statistics about the quality of the
 signal.
 
 The information about the frontend tuner locking status can be queried
-using :ref:`FE_READ_STATUS <FE_READ_STATUS>`.
+using :ref:`FE_READ_STATUS`.
 
 Signal statistics are provided via
-:ref:`FE_GET_PROPERTY <FE_GET_PROPERTY>`. Please note that several
+:ref:`FE_GET_PROPERTY`. Please note that several
 statistics require the demodulator to be fully locked (e. g. with
 FE_HAS_LOCK bit set). See
 :ref:`Frontend statistics indicators <frontend-stat-properties>` for
diff --git a/Documentation/linux_tv/media/dvb/frontend-stat-properties.rst b/Documentation/linux_tv/media/dvb/frontend-stat-properties.rst
index 36461d65a661..7f3999db3e5d 100644
--- a/Documentation/linux_tv/media/dvb/frontend-stat-properties.rst
+++ b/Documentation/linux_tv/media/dvb/frontend-stat-properties.rst
@@ -234,7 +234,7 @@ measurement was taken.
 
 It can be used to calculate the PER indicator, by dividing
 :ref:`DTV_STAT_ERROR_BLOCK_COUNT <DTV-STAT-ERROR-BLOCK-COUNT>` by
-:ref:`DTV-STAT-TOTAL-BLOCK-COUNT <DTV-STAT-TOTAL-BLOCK-COUNT>`.
+:ref:`DTV-STAT-TOTAL-BLOCK-COUNT`.
 
 Possible scales for this metric are:
 
diff --git a/Documentation/linux_tv/media/dvb/frontend_f_open.rst b/Documentation/linux_tv/media/dvb/frontend_f_open.rst
index 676ae922338d..91ac9ef8c356 100644
--- a/Documentation/linux_tv/media/dvb/frontend_f_open.rst
+++ b/Documentation/linux_tv/media/dvb/frontend_f_open.rst
@@ -49,7 +49,7 @@ Description
 This system call opens a named frontend device
 (``/dev/dvb/adapter?/frontend?``) for subsequent use. Usually the first
 thing to do after a successful open is to find out the frontend type
-with :ref:`FE_GET_INFO <FE_GET_INFO>`.
+with :ref:`FE_GET_INFO`.
 
 The device can be opened in read-only mode, which only allows monitoring
 of device status and statistics, or read/write mode, which allows any
diff --git a/Documentation/linux_tv/media/dvb/query-dvb-frontend-info.rst b/Documentation/linux_tv/media/dvb/query-dvb-frontend-info.rst
index 4a4fd5af6e0f..a3da1b8376bc 100644
--- a/Documentation/linux_tv/media/dvb/query-dvb-frontend-info.rst
+++ b/Documentation/linux_tv/media/dvb/query-dvb-frontend-info.rst
@@ -8,7 +8,7 @@ Querying frontend information
 
 Usually, the first thing to do when the frontend is opened is to check
 the frontend capabilities. This is done using
-:ref:`FE_GET_INFO <FE_GET_INFO>`. This ioctl will enumerate the
+:ref:`FE_GET_INFO`. This ioctl will enumerate the
 DVB API version and other characteristics about the frontend, and can be
 opened either in read only or read/write mode.
 
diff --git a/Documentation/linux_tv/media/dvb/video_function_calls.rst b/Documentation/linux_tv/media/dvb/video_function_calls.rst
index 98c90dcdb587..78917bdf51ed 100644
--- a/Documentation/linux_tv/media/dvb/video_function_calls.rst
+++ b/Documentation/linux_tv/media/dvb/video_function_calls.rst
@@ -239,7 +239,7 @@ VIDEO_STOP
 DESCRIPTION
 
 This ioctl is for DVB devices only. To control a V4L2 decoder use the
-V4L2 :ref:`VIDIOC_DECODER_CMD <VIDIOC_DECODER_CMD>` instead.
+V4L2 :ref:`VIDIOC_DECODER_CMD` instead.
 
 This ioctl call asks the Video Device to stop playing the current
 stream. Depending on the input parameter, the screen can be blanked out
@@ -302,7 +302,7 @@ VIDEO_PLAY
 DESCRIPTION
 
 This ioctl is for DVB devices only. To control a V4L2 decoder use the
-V4L2 :ref:`VIDIOC_DECODER_CMD <VIDIOC_DECODER_CMD>` instead.
+V4L2 :ref:`VIDIOC_DECODER_CMD` instead.
 
 This ioctl call asks the Video Device to start playing a video stream
 from the selected source.
@@ -348,7 +348,7 @@ VIDEO_FREEZE
 DESCRIPTION
 
 This ioctl is for DVB devices only. To control a V4L2 decoder use the
-V4L2 :ref:`VIDIOC_DECODER_CMD <VIDIOC_DECODER_CMD>` instead.
+V4L2 :ref:`VIDIOC_DECODER_CMD` instead.
 
 This ioctl call suspends the live video stream being played. Decoding
 and playing are frozen. It is then possible to restart the decoding and
@@ -398,7 +398,7 @@ VIDEO_CONTINUE
 DESCRIPTION
 
 This ioctl is for DVB devices only. To control a V4L2 decoder use the
-V4L2 :ref:`VIDIOC_DECODER_CMD <VIDIOC_DECODER_CMD>` instead.
+V4L2 :ref:`VIDIOC_DECODER_CMD` instead.
 
 This ioctl call restarts decoding and playing processes of the video
 stream which was played before a call to VIDEO_FREEZE was made.
@@ -763,7 +763,7 @@ VIDEO_GET_EVENT
 DESCRIPTION
 
 This ioctl is for DVB devices only. To get events from a V4L2 decoder
-use the V4L2 :ref:`VIDIOC_DQEVENT <VIDIOC_DQEVENT>` ioctl instead.
+use the V4L2 :ref:`VIDIOC_DQEVENT` ioctl instead.
 
 This ioctl call returns an event of type video_event if available. If
 an event is not available, the behavior depends on whether the device is
@@ -844,11 +844,11 @@ DESCRIPTION
 
 This ioctl is obsolete. Do not use in new drivers. For V4L2 decoders
 this ioctl has been replaced by the
-:ref:`VIDIOC_DECODER_CMD <VIDIOC_DECODER_CMD>` ioctl.
+:ref:`VIDIOC_DECODER_CMD` ioctl.
 
 This ioctl commands the decoder. The ``video_command`` struct is a
 subset of the ``v4l2_decoder_cmd`` struct, so refer to the
-:ref:`VIDIOC_DECODER_CMD <VIDIOC_DECODER_CMD>` documentation for
+:ref:`VIDIOC_DECODER_CMD` documentation for
 more information.
 
 SYNOPSIS
diff --git a/Documentation/linux_tv/media/v4l/app-pri.rst b/Documentation/linux_tv/media/v4l/app-pri.rst
index bc50afca95fc..4faf9042f612 100644
--- a/Documentation/linux_tv/media/v4l/app-pri.rst
+++ b/Documentation/linux_tv/media/v4l/app-pri.rst
@@ -16,14 +16,14 @@ applications and automatically regain control of the device at a later
 time.
 
 Since these features cannot be implemented entirely in user space V4L2
-defines the :ref:`VIDIOC_G_PRIORITY <VIDIOC_G_PRIORITY>` and
+defines the :ref:`VIDIOC_G_PRIORITY` and
 :ref:`VIDIOC_S_PRIORITY <VIDIOC_G_PRIORITY>` ioctls to request and
 query the access priority associate with a file descriptor. Opening a
 device assigns a medium priority, compatible with earlier versions of
 V4L2 and drivers not supporting these ioctls. Applications requiring a
 different priority will usually call :ref:`VIDIOC_S_PRIORITY
 <VIDIOC_G_PRIORITY>` after verifying the device with the
-:ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>` ioctl.
+:ref:`VIDIOC_QUERYCAP` ioctl.
 
 Ioctls changing driver properties, such as
 :ref:`VIDIOC_S_INPUT <VIDIOC_G_INPUT>`, return an EBUSY error code
diff --git a/Documentation/linux_tv/media/v4l/audio.rst b/Documentation/linux_tv/media/v4l/audio.rst
index fa6bf5ad8d32..21db1b97b83c 100644
--- a/Documentation/linux_tv/media/v4l/audio.rst
+++ b/Documentation/linux_tv/media/v4l/audio.rst
@@ -27,18 +27,18 @@ number, starting at zero, of one audio input or output.
 
 To learn about the number and attributes of the available inputs and
 outputs applications can enumerate them with the
-:ref:`VIDIOC_ENUMAUDIO <VIDIOC_ENUMAUDIO>` and
+:ref:`VIDIOC_ENUMAUDIO` and
 :ref:`VIDIOC_ENUMAUDOUT <VIDIOC_ENUMAUDIOout>` ioctl, respectively.
 The struct :ref:`v4l2_audio <v4l2-audio>` returned by the
-:ref:`VIDIOC_ENUMAUDIO <VIDIOC_ENUMAUDIO>` ioctl also contains signal
+:ref:`VIDIOC_ENUMAUDIO` ioctl also contains signal
 :status information applicable when the current audio input is queried.
 
-The :ref:`VIDIOC_G_AUDIO <VIDIOC_G_AUDIO>` and
+The :ref:`VIDIOC_G_AUDIO` and
 :ref:`VIDIOC_G_AUDOUT <VIDIOC_G_AUDIOout>` ioctls report the current
 audio input and output, respectively. Note that, unlike
-:ref:`VIDIOC_G_INPUT <VIDIOC_G_INPUT>` and
-:ref:`VIDIOC_G_OUTPUT <VIDIOC_G_OUTPUT>` these ioctls return a
-structure as :ref:`VIDIOC_ENUMAUDIO <VIDIOC_ENUMAUDIO>` and
+:ref:`VIDIOC_G_INPUT` and
+:ref:`VIDIOC_G_OUTPUT` these ioctls return a
+structure as :ref:`VIDIOC_ENUMAUDIO` and
 :ref:`VIDIOC_ENUMAUDOUT <VIDIOC_ENUMAUDIOout>` do, not just an index.
 
 To select an audio input and change its properties applications call the
@@ -51,7 +51,7 @@ multiple selectable audio inputs, all audio output ioctls when the
 device has multiple selectable audio outputs. When the device has any
 audio inputs or outputs the driver must set the ``V4L2_CAP_AUDIO`` flag
 in the struct :ref:`v4l2_capability <v4l2-capability>` returned by
-the :ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>` ioctl.
+the :ref:`VIDIOC_QUERYCAP` ioctl.
 
 
 .. code-block:: c
diff --git a/Documentation/linux_tv/media/v4l/buffer.rst b/Documentation/linux_tv/media/v4l/buffer.rst
index 7d96ab74500f..374e9ba6b4bb 100644
--- a/Documentation/linux_tv/media/v4l/buffer.rst
+++ b/Documentation/linux_tv/media/v4l/buffer.rst
@@ -12,8 +12,8 @@ planes, while the buffer structure acts as a container for the planes.
 Only pointers to buffers (planes) are exchanged, the data itself is not
 copied. These pointers, together with meta-information like timestamps
 or field parity, are stored in a struct :c:type:`struct v4l2_buffer`,
-argument to the :ref:`VIDIOC_QUERYBUF <VIDIOC_QUERYBUF>`,
-:ref:`VIDIOC_QBUF <VIDIOC_QBUF>` and
+argument to the :ref:`VIDIOC_QUERYBUF`,
+:ref:`VIDIOC_QBUF` and
 :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctl. In the multi-planar API,
 some plane-specific members of struct :c:type:`struct v4l2_buffer`,
 such as pointers and sizes for each plane, are stored in struct
@@ -52,10 +52,10 @@ buffer.
        -  Number of the buffer, set by the application except when calling
           :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>`, then it is set by the
           driver. This field can range from zero to the number of buffers
-          allocated with the :ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>` ioctl
+          allocated with the :ref:`VIDIOC_REQBUFS` ioctl
           (struct :ref:`v4l2_requestbuffers <v4l2-requestbuffers>`
           ``count``), plus any buffers allocated with
-          :ref:`VIDIOC_CREATE_BUFS <VIDIOC_CREATE_BUFS>` minus one.
+          :ref:`VIDIOC_CREATE_BUFS` minus one.
 
     -  .. row 2
 
@@ -243,8 +243,8 @@ buffer.
        -  
        -  Size of the buffer (not the payload) in bytes for the
           single-planar API. This is set by the driver based on the calls to
-          :ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>` and/or
-          :ref:`VIDIOC_CREATE_BUFS <VIDIOC_CREATE_BUFS>`. For the
+          :ref:`VIDIOC_REQBUFS` and/or
+          :ref:`VIDIOC_CREATE_BUFS`. For the
           multi-planar API the application sets this to the number of
           elements in the ``planes`` array. The driver will fill in the
           actual number of valid elements in that array.
@@ -303,8 +303,8 @@ buffer.
        -  
        -  Size in bytes of the plane (not its payload). This is set by the
           driver based on the calls to
-          :ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>` and/or
-          :ref:`VIDIOC_CREATE_BUFS <VIDIOC_CREATE_BUFS>`.
+          :ref:`VIDIOC_REQBUFS` and/or
+          :ref:`VIDIOC_CREATE_BUFS`.
 
     -  .. row 3
 
@@ -506,8 +506,8 @@ buffer.
        -  The buffer resides in device memory and has been mapped into the
           application's address space, see :ref:`mmap` for details.
           Drivers set or clear this flag when the
-          :ref:`VIDIOC_QUERYBUF <VIDIOC_QUERYBUF>`,
-          :ref:`VIDIOC_QBUF <VIDIOC_QBUF>` or
+          :ref:`VIDIOC_QUERYBUF`,
+          :ref:`VIDIOC_QBUF` or
           :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctl is called. Set by the
           driver.
 
@@ -609,9 +609,9 @@ buffer.
 
        -  The buffer has been prepared for I/O and can be queued by the
           application. Drivers set or clear this flag when the
-          :ref:`VIDIOC_QUERYBUF <VIDIOC_QUERYBUF>`,
+          :ref:`VIDIOC_QUERYBUF`,
           :ref:`VIDIOC_PREPARE_BUF <VIDIOC_QBUF>`,
-          :ref:`VIDIOC_QBUF <VIDIOC_QBUF>` or
+          :ref:`VIDIOC_QBUF` or
           :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctl is called.
 
     -  .. row 10
@@ -645,7 +645,7 @@ buffer.
 
        -  Last buffer produced by the hardware. mem2mem codec drivers set
           this flag on the capture queue for the last buffer when the
-          :ref:`VIDIOC_QUERYBUF <VIDIOC_QUERYBUF>` or
+          :ref:`VIDIOC_QUERYBUF` or
           :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctl is called. Due to
           hardware limitations, the last buffer may be empty. In this case
           the driver will set the ``bytesused`` field to 0, regardless of
diff --git a/Documentation/linux_tv/media/v4l/control.rst b/Documentation/linux_tv/media/v4l/control.rst
index 3e5c650707ae..02bd455a2616 100644
--- a/Documentation/linux_tv/media/v4l/control.rst
+++ b/Documentation/linux_tv/media/v4l/control.rst
@@ -47,7 +47,7 @@ changed or generally never without application request.
 
 V4L2 specifies an event mechanism to notify applications when controls
 change value (see
-:ref:`VIDIOC_SUBSCRIBE_EVENT <VIDIOC_SUBSCRIBE_EVENT>`, event
+:ref:`VIDIOC_SUBSCRIBE_EVENT`, event
 ``V4L2_EVENT_CTRL``), panel applications might want to make use of that
 in order to always reflect the correct control value.
 
@@ -362,9 +362,9 @@ Control IDs
     and version, see :ref:`querycap`.
 
 Applications can enumerate the available controls with the
-:ref:`VIDIOC_QUERYCTRL <VIDIOC_QUERYCTRL>` and
+:ref:`VIDIOC_QUERYCTRL` and
 :ref:`VIDIOC_QUERYMENU <VIDIOC_QUERYCTRL>` ioctls, get and set a
-control value with the :ref:`VIDIOC_G_CTRL <VIDIOC_G_CTRL>` and
+control value with the :ref:`VIDIOC_G_CTRL` and
 :ref:`VIDIOC_S_CTRL <VIDIOC_G_CTRL>` ioctls. Drivers must implement
 ``VIDIOC_QUERYCTRL``, ``VIDIOC_G_CTRL`` and ``VIDIOC_S_CTRL`` when the
 device has one or more controls, ``VIDIOC_QUERYMENU`` when it has one or
@@ -522,7 +522,7 @@ more menu type controls.
    the real IDs.
 
    Many applications today still use the ``V4L2_CID_PRIVATE_BASE`` IDs
-   instead of using :ref:`VIDIOC_QUERYCTRL <VIDIOC_QUERYCTRL>` with
+   instead of using :ref:`VIDIOC_QUERYCTRL` with
    the ``V4L2_CTRL_FLAG_NEXT_CTRL`` flag to enumerate all IDs, so
    support for ``V4L2_CID_PRIVATE_BASE`` is still around.
 
diff --git a/Documentation/linux_tv/media/v4l/crop.rst b/Documentation/linux_tv/media/v4l/crop.rst
index 94f2d0e77ed8..41a5efaaa679 100644
--- a/Documentation/linux_tv/media/v4l/crop.rst
+++ b/Documentation/linux_tv/media/v4l/crop.rst
@@ -14,8 +14,8 @@ offset into a video signal.
 
 Applications can use the following API to select an area in the video
 signal, query the default area and the hardware limits. *Despite their
-name, the :ref:`VIDIOC_CROPCAP <VIDIOC_CROPCAP>`,
-:ref:`VIDIOC_G_CROP <VIDIOC_G_CROP>` and
+name, the :ref:`VIDIOC_CROPCAP`,
+:ref:`VIDIOC_G_CROP` and
 :ref:`VIDIOC_S_CROP <VIDIOC_G_CROP>` ioctls apply to input as well
 as output devices.*
 
@@ -23,7 +23,7 @@ Scaling requires a source and a target. On a video capture or overlay
 device the source is the video signal, and the cropping ioctls determine
 the area actually sampled. The target are images read by the application
 or overlaid onto the graphics screen. Their size (and position for an
-overlay) is negotiated with the :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>`
+overlay) is negotiated with the :ref:`VIDIOC_G_FMT`
 and :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctls.
 
 On a video output device the source are the images passed in by the
diff --git a/Documentation/linux_tv/media/v4l/dev-capture.rst b/Documentation/linux_tv/media/v4l/dev-capture.rst
index fd6357c995aa..eb5c1522905d 100644
--- a/Documentation/linux_tv/media/v4l/dev-capture.rst
+++ b/Documentation/linux_tv/media/v4l/dev-capture.rst
@@ -25,7 +25,7 @@ Devices supporting the video capture interface set the
 ``V4L2_CAP_VIDEO_CAPTURE`` or ``V4L2_CAP_VIDEO_CAPTURE_MPLANE`` flag in
 the ``capabilities`` field of struct
 :ref:`v4l2_capability <v4l2-capability>` returned by the
-:ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>` ioctl. As secondary device
+:ref:`VIDIOC_QUERYCAP` ioctl. As secondary device
 functions they may also support the :ref:`video overlay <overlay>`
 (``V4L2_CAP_VIDEO_OVERLAY``) and the :ref:`raw VBI capture <raw-vbi>`
 (``V4L2_CAP_VBI_CAPTURE``) interface. At least one of the read/write or
@@ -37,7 +37,7 @@ Supplemental Functions
 ======================
 
 Video capture devices shall support :ref:`audio input <audio>`,
-:ref:`tuner <tuner>`, :ref:`controls <control>`,
+:ref:`tuner`, :ref:`controls <control>`,
 :ref:`cropping and scaling <crop>` and
 :ref:`streaming parameter <streaming-par>` ioctls as needed. The
 :ref:`video input <video>` and :ref:`video standard <standard>`
@@ -65,7 +65,7 @@ To query the current image format applications set the ``type`` field of
 a struct :ref:`v4l2_format <v4l2-format>` to
 ``V4L2_BUF_TYPE_VIDEO_CAPTURE`` or
 ``V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE`` and call the
-:ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` ioctl with a pointer to this
+:ref:`VIDIOC_G_FMT` ioctl with a pointer to this
 structure. Drivers fill the struct
 :ref:`v4l2_pix_format <v4l2-pix-format>` ``pix`` or the struct
 :ref:`v4l2_pix_format_mplane <v4l2-pix-format-mplane>` ``pix_mp``
diff --git a/Documentation/linux_tv/media/v4l/dev-codec.rst b/Documentation/linux_tv/media/v4l/dev-codec.rst
index 1540755b1735..170954acc049 100644
--- a/Documentation/linux_tv/media/v4l/dev-codec.rst
+++ b/Documentation/linux_tv/media/v4l/dev-codec.rst
@@ -15,7 +15,7 @@ A memory-to-memory video node acts just like a normal video node, but it
 supports both output (sending frames from memory to the codec hardware)
 and capture (receiving the processed frames from the codec hardware into
 memory) stream I/O. An application will have to setup the stream I/O for
-both sides and finally call :ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>`
+both sides and finally call :ref:`VIDIOC_STREAMON`
 for both capture and output to start the codec.
 
 Video compression codecs use the MPEG controls to setup their codec
diff --git a/Documentation/linux_tv/media/v4l/dev-event.rst b/Documentation/linux_tv/media/v4l/dev-event.rst
index 5d21c6873b1a..385a8a342903 100644
--- a/Documentation/linux_tv/media/v4l/dev-event.rst
+++ b/Documentation/linux_tv/media/v4l/dev-event.rst
@@ -14,9 +14,9 @@ events.
 
 To receive events, the events the user is interested in first must be
 subscribed using the
-:ref:`VIDIOC_SUBSCRIBE_EVENT <VIDIOC_SUBSCRIBE_EVENT>` ioctl. Once
+:ref:`VIDIOC_SUBSCRIBE_EVENT` ioctl. Once
 an event is subscribed, the events of subscribed types are dequeueable
-using the :ref:`VIDIOC_DQEVENT <VIDIOC_DQEVENT>` ioctl. Events may be
+using the :ref:`VIDIOC_DQEVENT` ioctl. Events may be
 unsubscribed using VIDIOC_UNSUBSCRIBE_EVENT ioctl. The special event
 type V4L2_EVENT_ALL may be used to unsubscribe all the events the
 driver supports.
diff --git a/Documentation/linux_tv/media/v4l/dev-osd.rst b/Documentation/linux_tv/media/v4l/dev-osd.rst
index 93fb8f309091..27d2cfbf3d9c 100644
--- a/Documentation/linux_tv/media/v4l/dev-osd.rst
+++ b/Documentation/linux_tv/media/v4l/dev-osd.rst
@@ -26,7 +26,7 @@ Querying Capabilities
 Devices supporting the *Video Output Overlay* interface set the
 ``V4L2_CAP_VIDEO_OUTPUT_OVERLAY`` flag in the ``capabilities`` field of
 struct :ref:`v4l2_capability <v4l2-capability>` returned by the
-:ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>` ioctl.
+:ref:`VIDIOC_QUERYCAP` ioctl.
 
 
 Framebuffer
@@ -36,7 +36,7 @@ Contrary to the *Video Overlay* interface the framebuffer is normally
 implemented on the TV card and not the graphics card. On Linux it is
 accessible as a framebuffer device (``/dev/fbN``). Given a V4L2 device,
 applications can find the corresponding framebuffer device by calling
-the :ref:`VIDIOC_G_FBUF <VIDIOC_G_FBUF>` ioctl. It returns, amongst
+the :ref:`VIDIOC_G_FBUF` ioctl. It returns, amongst
 other information, the physical address of the framebuffer in the
 ``base`` field of struct :ref:`v4l2_framebuffer <v4l2-framebuffer>`.
 The framebuffer device ioctl ``FBIOGET_FSCREENINFO`` returns the same
@@ -115,7 +115,7 @@ clipping/blending method to be used for the overlay. To get the current
 parameters applications set the ``type`` field of a struct
 :ref:`v4l2_format <v4l2-format>` to
 ``V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY`` and call the
-:ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` ioctl. The driver fills the
+:ref:`VIDIOC_G_FMT` ioctl. The driver fills the
 :c:type:`struct v4l2_window` substructure named ``win``. It is not
 possible to retrieve a previously programmed clipping list or bitmap.
 
diff --git a/Documentation/linux_tv/media/v4l/dev-output.rst b/Documentation/linux_tv/media/v4l/dev-output.rst
index 3efbbcc3c093..1ca0e5873a86 100644
--- a/Documentation/linux_tv/media/v4l/dev-output.rst
+++ b/Documentation/linux_tv/media/v4l/dev-output.rst
@@ -24,7 +24,7 @@ Devices supporting the video output interface set the
 ``V4L2_CAP_VIDEO_OUTPUT`` or ``V4L2_CAP_VIDEO_OUTPUT_MPLANE`` flag in
 the ``capabilities`` field of struct
 :ref:`v4l2_capability <v4l2-capability>` returned by the
-:ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>` ioctl. As secondary device
+:ref:`VIDIOC_QUERYCAP` ioctl. As secondary device
 functions they may also support the :ref:`raw VBI output <raw-vbi>`
 (``V4L2_CAP_VBI_OUTPUT``) interface. At least one of the read/write or
 streaming I/O methods must be supported. Modulators and audio outputs
@@ -62,7 +62,7 @@ defaults. An example is given in :ref:`crop`.
 To query the current image format applications set the ``type`` field of
 a struct :ref:`v4l2_format <v4l2-format>` to
 ``V4L2_BUF_TYPE_VIDEO_OUTPUT`` or ``V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE``
-and call the :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` ioctl with a pointer
+and call the :ref:`VIDIOC_G_FMT` ioctl with a pointer
 to this structure. Drivers fill the struct
 :ref:`v4l2_pix_format <v4l2-pix-format>` ``pix`` or the struct
 :ref:`v4l2_pix_format_mplane <v4l2-pix-format-mplane>` ``pix_mp``
diff --git a/Documentation/linux_tv/media/v4l/dev-overlay.rst b/Documentation/linux_tv/media/v4l/dev-overlay.rst
index 8a81e19a5d7c..acbcfb4cbe57 100644
--- a/Documentation/linux_tv/media/v4l/dev-overlay.rst
+++ b/Documentation/linux_tv/media/v4l/dev-overlay.rst
@@ -41,7 +41,7 @@ Querying Capabilities
 Devices supporting the video overlay interface set the
 ``V4L2_CAP_VIDEO_OVERLAY`` flag in the ``capabilities`` field of struct
 :ref:`v4l2_capability <v4l2-capability>` returned by the
-:ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>` ioctl. The overlay I/O
+:ref:`VIDIOC_QUERYCAP` ioctl. The overlay I/O
 method specified below must be supported. Tuners and audio inputs are
 optional.
 
@@ -50,7 +50,7 @@ Supplemental Functions
 ======================
 
 Video overlay devices shall support :ref:`audio input <audio>`,
-:ref:`tuner <tuner>`, :ref:`controls <control>`,
+:ref:`tuner`, :ref:`controls <control>`,
 :ref:`cropping and scaling <crop>` and
 :ref:`streaming parameter <streaming-par>` ioctls as needed. The
 :ref:`video input <video>` and :ref:`video standard <standard>`
@@ -63,7 +63,7 @@ Setup
 Before overlay can commence applications must program the driver with
 frame buffer parameters, namely the address and size of the frame buffer
 and the image format, for example RGB 5:6:5. The
-:ref:`VIDIOC_G_FBUF <VIDIOC_G_FBUF>` and
+:ref:`VIDIOC_G_FBUF` and
 :ref:`VIDIOC_S_FBUF <VIDIOC_G_FBUF>` ioctls are available to get and
 set these parameters, respectively. The ``VIDIOC_S_FBUF`` ioctl is
 privileged because it allows to set up DMA into physical memory,
@@ -121,7 +121,7 @@ its position over the graphics surface and the clipping to be applied.
 To get the current parameters applications set the ``type`` field of a
 struct :ref:`v4l2_format <v4l2-format>` to
 ``V4L2_BUF_TYPE_VIDEO_OVERLAY`` and call the
-:ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` ioctl. The driver fills the
+:ref:`VIDIOC_G_FMT` ioctl. The driver fills the
 :c:type:`struct v4l2_window` substructure named ``win``. It is not
 possible to retrieve a previously programmed clipping list or bitmap.
 
@@ -179,7 +179,7 @@ struct v4l2_window
 
 ``struct v4l2_clip * clips``
     When chroma-keying has *not* been negotiated and
-    :ref:`VIDIOC_G_FBUF <VIDIOC_G_FBUF>` indicated this capability,
+    :ref:`VIDIOC_G_FBUF` indicated this capability,
     applications can set this field to point to an array of clipping
     rectangles.
 
@@ -204,7 +204,7 @@ are undefined.
 
 ``void * bitmap``
     When chroma-keying has *not* been negotiated and
-    :ref:`VIDIOC_G_FBUF <VIDIOC_G_FBUF>` indicated this capability,
+    :ref:`VIDIOC_G_FBUF` indicated this capability,
     applications can set this field to point to a clipping bit mask.
 
 It must be of the same size as the window, ``w.width`` and ``w.height``.
@@ -289,7 +289,7 @@ Enabling Overlay
 ================
 
 To start or stop the frame buffer overlay applications call the
-:ref:`VIDIOC_OVERLAY <VIDIOC_OVERLAY>` ioctl.
+:ref:`VIDIOC_OVERLAY` ioctl.
 
 .. [1]
    A common application of two file descriptors is the XFree86
diff --git a/Documentation/linux_tv/media/v4l/dev-radio.rst b/Documentation/linux_tv/media/v4l/dev-radio.rst
index 955173aaf48e..7a0d25a143a6 100644
--- a/Documentation/linux_tv/media/v4l/dev-radio.rst
+++ b/Documentation/linux_tv/media/v4l/dev-radio.rst
@@ -21,7 +21,7 @@ Devices supporting the radio interface set the ``V4L2_CAP_RADIO`` and
 ``V4L2_CAP_TUNER`` or ``V4L2_CAP_MODULATOR`` flag in the
 ``capabilities`` field of struct
 :ref:`v4l2_capability <v4l2-capability>` returned by the
-:ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>` ioctl. Other combinations of
+:ref:`VIDIOC_QUERYCAP` ioctl. Other combinations of
 capability flags are reserved for future extensions.
 
 
@@ -47,8 +47,8 @@ discussed in :ref:`tuner`) with index number zero to select the radio
 frequency and to determine if a monaural or FM stereo program is
 received/emitted. Drivers switch automatically between AM and FM
 depending on the selected frequency. The
-:ref:`VIDIOC_G_TUNER <VIDIOC_G_TUNER>` or
-:ref:`VIDIOC_G_MODULATOR <VIDIOC_G_MODULATOR>` ioctl reports the
+:ref:`VIDIOC_G_TUNER` or
+:ref:`VIDIOC_G_MODULATOR` ioctl reports the
 supported frequency range.
 
 
diff --git a/Documentation/linux_tv/media/v4l/dev-raw-vbi.rst b/Documentation/linux_tv/media/v4l/dev-raw-vbi.rst
index 883ac4fbaeb6..ca61dde3ad38 100644
--- a/Documentation/linux_tv/media/v4l/dev-raw-vbi.rst
+++ b/Documentation/linux_tv/media/v4l/dev-raw-vbi.rst
@@ -40,7 +40,7 @@ Devices supporting the raw VBI capturing or output API set the
 ``V4L2_CAP_VBI_CAPTURE`` or ``V4L2_CAP_VBI_OUTPUT`` flags, respectively,
 in the ``capabilities`` field of struct
 :ref:`v4l2_capability <v4l2-capability>` returned by the
-:ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>` ioctl. At least one of the
+:ref:`VIDIOC_QUERYCAP` ioctl. At least one of the
 read/write, streaming or asynchronous I/O methods must be supported. VBI
 devices may or may not have a tuner or modulator.
 
@@ -71,7 +71,7 @@ parameters and then checking if the actual parameters are suitable.
 To query the current raw VBI capture parameters applications set the
 ``type`` field of a struct :ref:`v4l2_format <v4l2-format>` to
 ``V4L2_BUF_TYPE_VBI_CAPTURE`` or ``V4L2_BUF_TYPE_VBI_OUTPUT``, and call
-the :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` ioctl with a pointer to this
+the :ref:`VIDIOC_G_FMT` ioctl with a pointer to this
 structure. Drivers fill the struct
 :ref:`v4l2_vbi_format <v4l2-vbi-format>` ``vbi`` member of the
 ``fmt`` union.
@@ -91,7 +91,7 @@ happen for instance when the video and VBI areas to capture would
 overlap, or when the driver supports multiple opens and another process
 already requested VBI capturing or output. Anyway, applications must
 expect other resource allocation points which may return EBUSY, at the
-:ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>` ioctl and the first read(),
+:ref:`VIDIOC_STREAMON` ioctl and the first read(),
 write() and select() call.
 
 VBI devices must implement both the ``VIDIOC_G_FMT`` and
@@ -339,7 +339,7 @@ A VBI device may support :ref:`read/write <rw>` and/or streaming
 The latter bears the possibility of synchronizing video and VBI data by
 using buffer timestamps.
 
-Remember the :ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>` ioctl and the
+Remember the :ref:`VIDIOC_STREAMON` ioctl and the
 first read(), write() and select() call can be resource allocation
 points returning an EBUSY error code if the required hardware resources
 are temporarily unavailable, for example the device is already in use by
diff --git a/Documentation/linux_tv/media/v4l/dev-rds.rst b/Documentation/linux_tv/media/v4l/dev-rds.rst
index af20f8fa1cdf..223df4971405 100644
--- a/Documentation/linux_tv/media/v4l/dev-rds.rst
+++ b/Documentation/linux_tv/media/v4l/dev-rds.rst
@@ -33,7 +33,7 @@ Querying Capabilities
 Devices supporting the RDS capturing API set the
 ``V4L2_CAP_RDS_CAPTURE`` flag in the ``capabilities`` field of struct
 :ref:`v4l2_capability <v4l2-capability>` returned by the
-:ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>` ioctl. Any tuner that
+:ref:`VIDIOC_QUERYCAP` ioctl. Any tuner that
 supports RDS will set the ``V4L2_TUNER_CAP_RDS`` flag in the
 ``capability`` field of struct :ref:`v4l2_tuner <v4l2-tuner>`. If the
 driver only passes RDS blocks without interpreting the data the
@@ -52,7 +52,7 @@ Whether an RDS signal is present can be detected by looking at the
 Devices supporting the RDS output API set the ``V4L2_CAP_RDS_OUTPUT``
 flag in the ``capabilities`` field of struct
 :ref:`v4l2_capability <v4l2-capability>` returned by the
-:ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>` ioctl. Any modulator that
+:ref:`VIDIOC_QUERYCAP` ioctl. Any modulator that
 supports RDS will set the ``V4L2_TUNER_CAP_RDS`` flag in the
 ``capability`` field of struct
 :ref:`v4l2_modulator <v4l2-modulator>`. In order to enable the RDS
diff --git a/Documentation/linux_tv/media/v4l/dev-sdr.rst b/Documentation/linux_tv/media/v4l/dev-sdr.rst
index 5e4f7030f644..0cae31c93dd0 100644
--- a/Documentation/linux_tv/media/v4l/dev-sdr.rst
+++ b/Documentation/linux_tv/media/v4l/dev-sdr.rst
@@ -22,7 +22,7 @@ Devices supporting the SDR receiver interface set the
 ``V4L2_CAP_SDR_CAPTURE`` and ``V4L2_CAP_TUNER`` flag in the
 ``capabilities`` field of struct
 :ref:`v4l2_capability <v4l2-capability>` returned by the
-:ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>` ioctl. That flag means the
+:ref:`VIDIOC_QUERYCAP` ioctl. That flag means the
 device has an Analog to Digital Converter (ADC), which is a mandatory
 element for the SDR receiver.
 
@@ -30,7 +30,7 @@ Devices supporting the SDR transmitter interface set the
 ``V4L2_CAP_SDR_OUTPUT`` and ``V4L2_CAP_MODULATOR`` flag in the
 ``capabilities`` field of struct
 :ref:`v4l2_capability <v4l2-capability>` returned by the
-:ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>` ioctl. That flag means the
+:ref:`VIDIOC_QUERYCAP` ioctl. That flag means the
 device has an Digital to Analog Converter (DAC), which is a mandatory
 element for the SDR transmitter.
 
@@ -42,7 +42,7 @@ Supplemental Functions
 ======================
 
 SDR devices can support :ref:`controls <control>`, and must support
-the :ref:`tuner <tuner>` ioctls. Tuner ioctls are used for setting the
+the :ref:`tuner` ioctls. Tuner ioctls are used for setting the
 ADC/DAC sampling rate (sampling frequency) and the possible radio
 frequency (RF).
 
@@ -52,21 +52,21 @@ radio frequency. The tuner index of the RF tuner (if any) must always
 follow the SDR tuner index. Normally the SDR tuner is #0 and the RF
 tuner is #1.
 
-The :ref:`VIDIOC_S_HW_FREQ_SEEK <VIDIOC_S_HW_FREQ_SEEK>` ioctl is
+The :ref:`VIDIOC_S_HW_FREQ_SEEK` ioctl is
 not supported.
 
 
 Data Format Negotiation
 =======================
 
-The SDR device uses the :ref:`format <format>` ioctls to select the
+The SDR device uses the :ref:`format` ioctls to select the
 capture and output format. Both the sampling resolution and the data
 streaming format are bound to that selectable format. In addition to the
-basic :ref:`format <format>` ioctls, the
-:ref:`VIDIOC_ENUM_FMT <VIDIOC_ENUM_FMT>` ioctl must be supported as
+basic :ref:`format` ioctls, the
+:ref:`VIDIOC_ENUM_FMT` ioctl must be supported as
 well.
 
-To use the :ref:`format <format>` ioctls applications set the ``type``
+To use the :ref:`format` ioctls applications set the ``type``
 field of a struct :ref:`v4l2_format <v4l2-format>` to
 ``V4L2_BUF_TYPE_SDR_CAPTURE`` or ``V4L2_BUF_TYPE_SDR_OUTPUT`` and use
 the struct :ref:`v4l2_sdr_format <v4l2-sdr-format>` ``sdr`` member
diff --git a/Documentation/linux_tv/media/v4l/dev-sliced-vbi.rst b/Documentation/linux_tv/media/v4l/dev-sliced-vbi.rst
index 0faf178168e4..d53353afbedf 100644
--- a/Documentation/linux_tv/media/v4l/dev-sliced-vbi.rst
+++ b/Documentation/linux_tv/media/v4l/dev-sliced-vbi.rst
@@ -35,7 +35,7 @@ Devices supporting the sliced VBI capturing or output API set the
 ``V4L2_CAP_SLICED_VBI_CAPTURE`` or ``V4L2_CAP_SLICED_VBI_OUTPUT`` flag
 respectively, in the ``capabilities`` field of struct
 :ref:`v4l2_capability <v4l2-capability>` returned by the
-:ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>` ioctl. At least one of the
+:ref:`VIDIOC_QUERYCAP` ioctl. At least one of the
 read/write, streaming or asynchronous :ref:`I/O methods <io>` must be
 supported. Sliced VBI devices may have a tuner or modulator.
 
@@ -45,7 +45,7 @@ Supplemental Functions
 
 Sliced VBI devices shall support :ref:`video input or output <video>`
 and :ref:`tuner or modulator <tuner>` ioctls if they have these
-capabilities, and they may support :ref:`control <control>` ioctls.
+capabilities, and they may support :ref:`control` ioctls.
 The :ref:`video standard <standard>` ioctls provide information vital
 to program a sliced VBI device, therefore must be supported.
 
@@ -57,7 +57,7 @@ Sliced VBI Format Negotiation
 
 To find out which data services are supported by the hardware
 applications can call the
-:ref:`VIDIOC_G_SLICED_VBI_CAP <VIDIOC_G_SLICED_VBI_CAP>` ioctl.
+:ref:`VIDIOC_G_SLICED_VBI_CAP` ioctl.
 All drivers implementing the sliced VBI interface must support this
 ioctl. The results may differ from those of the
 :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl when the number of VBI
@@ -70,7 +70,7 @@ To determine the currently selected services applications set the
 ``type`` field of struct :ref:`v4l2_format <v4l2-format>` to
 ``V4L2_BUF_TYPE_SLICED_VBI_CAPTURE`` or
 ``V4L2_BUF_TYPE_SLICED_VBI_OUTPUT``, and the
-:ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` ioctl fills the ``fmt.sliced``
+:ref:`VIDIOC_G_FMT` ioctl fills the ``fmt.sliced``
 member, a struct
 :ref:`v4l2_sliced_vbi_format <v4l2-sliced-vbi-format>`.
 
@@ -95,7 +95,7 @@ according to hardware capabilities. When the driver allocates resources
 at this point, it may return an EBUSY error code if the required
 resources are temporarily unavailable. Other resource allocation points
 which may return EBUSY can be the
-:ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>` ioctl and the first
+:ref:`VIDIOC_STREAMON` ioctl and the first
 :ref:`read() <func-read>`, :ref:`write() <func-write>` and
 :ref:`select() <func-select>` call.
 
@@ -224,7 +224,7 @@ which may return EBUSY can be the
        -  :cspan:`2` Maximum number of bytes passed by one
           :ref:`read() <func-read>` or :ref:`write() <func-write>` call,
           and the buffer size in bytes for the
-          :ref:`VIDIOC_QBUF <VIDIOC_QBUF>` and
+          :ref:`VIDIOC_QBUF` and
           :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctl. Drivers set this field
           to the size of struct
           :ref:`v4l2_sliced_vbi_data <v4l2-sliced-vbi-data>` times the
@@ -343,7 +343,7 @@ after switching the video input (which may change the video standard as
 a side effect). The :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl may
 return an EBUSY error code when applications attempt to change the
 format while i/o is in progress (between a
-:ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>` and
+:ref:`VIDIOC_STREAMON` and
 :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` call, and after the first
 :ref:`read() <func-read>` or :ref:`write() <func-write>` call).
 
@@ -428,11 +428,11 @@ of one video frame. The ``id`` of unused
 
 Packets are always passed in ascending line number order, without
 duplicate line numbers. The :ref:`write() <func-write>` function and
-the :ref:`VIDIOC_QBUF <VIDIOC_QBUF>` ioctl must return an EINVAL
+the :ref:`VIDIOC_QBUF` ioctl must return an EINVAL
 error code when applications violate this rule. They must also return an
 EINVAL error code when applications pass an incorrect field or line
 number, or a combination of ``field``, ``line`` and ``id`` which has not
-been negotiated with the :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` or
+been negotiated with the :ref:`VIDIOC_G_FMT` or
 :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl. When the line numbers are
 unknown the driver must pass the packets in transmitted order. The
 driver can insert empty packets with ``id`` set to zero anywhere in the
diff --git a/Documentation/linux_tv/media/v4l/dev-subdev.rst b/Documentation/linux_tv/media/v4l/dev-subdev.rst
index 1fe594c0026f..67732da53be5 100644
--- a/Documentation/linux_tv/media/v4l/dev-subdev.rst
+++ b/Documentation/linux_tv/media/v4l/dev-subdev.rst
@@ -118,18 +118,18 @@ every point in the pipeline explicitly.
 Drivers that implement the :ref:`media API <media-controller-intro>`
 can expose pad-level image format configuration to applications. When
 they do, applications can use the
-:ref:`VIDIOC_SUBDEV_G_FMT <VIDIOC_SUBDEV_G_FMT>` and
+:ref:`VIDIOC_SUBDEV_G_FMT` and
 :ref:`VIDIOC_SUBDEV_S_FMT <VIDIOC_SUBDEV_G_FMT>` ioctls. to
 negotiate formats on a per-pad basis.
 
 Applications are responsible for configuring coherent parameters on the
 whole pipeline and making sure that connected pads have compatible
 formats. The pipeline is checked for formats mismatch at
-:ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>` time, and an EPIPE error
+:ref:`VIDIOC_STREAMON` time, and an EPIPE error
 code is then returned if the configuration is invalid.
 
 Pad-level image format configuration support can be tested by calling
-the :ref:`VIDIOC_SUBDEV_G_FMT <VIDIOC_SUBDEV_G_FMT>` ioctl on pad
+the :ref:`VIDIOC_SUBDEV_G_FMT` ioctl on pad
 0. If the driver returns an EINVAL error code pad-level format
 configuration is not supported by the sub-device.
 
@@ -146,7 +146,7 @@ formats enumeration only. A format negotiation mechanism is required.
 Central to the format negotiation mechanism are the get/set format
 operations. When called with the ``which`` argument set to
 ``V4L2_SUBDEV_FORMAT_TRY``, the
-:ref:`VIDIOC_SUBDEV_G_FMT <VIDIOC_SUBDEV_G_FMT>` and
+:ref:`VIDIOC_SUBDEV_G_FMT` and
 :ref:`VIDIOC_SUBDEV_S_FMT <VIDIOC_SUBDEV_G_FMT>` ioctls operate on
 a set of formats parameters that are not connected to the hardware
 configuration. Modifying those 'try' formats leaves the device state
@@ -155,7 +155,7 @@ and the hardware state stored in the device itself).
 
 While not kept as part of the device state, try formats are stored in
 the sub-device file handles. A
-:ref:`VIDIOC_SUBDEV_G_FMT <VIDIOC_SUBDEV_G_FMT>` call will return
+:ref:`VIDIOC_SUBDEV_G_FMT` call will return
 the last try format set *on the same sub-device file handle*. Several
 applications querying the same sub-device at the same time will thus not
 interact with each other.
diff --git a/Documentation/linux_tv/media/v4l/dev-teletext.rst b/Documentation/linux_tv/media/v4l/dev-teletext.rst
index ed69e0fb6371..501e68077af2 100644
--- a/Documentation/linux_tv/media/v4l/dev-teletext.rst
+++ b/Documentation/linux_tv/media/v4l/dev-teletext.rst
@@ -31,7 +31,7 @@ them. So the decision was made to finally remove support for the
 Teletext API in kernel 2.6.37.
 
 Modern devices all use the :ref:`raw <raw-vbi>` or
-:ref:`sliced <sliced>` VBI API.
+:ref:`sliced` VBI API.
 
 
 .. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/diff-v4l.rst b/Documentation/linux_tv/media/v4l/diff-v4l.rst
index 0c4030d75c76..06fdd877d77d 100644
--- a/Documentation/linux_tv/media/v4l/diff-v4l.rst
+++ b/Documentation/linux_tv/media/v4l/diff-v4l.rst
@@ -85,7 +85,7 @@ Querying Capabilities
 =====================
 
 The V4L ``VIDIOCGCAP`` ioctl is equivalent to V4L2's
-:ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>`.
+:ref:`VIDIOC_QUERYCAP`.
 
 The ``name`` field in struct :c:type:`struct video_capability` became
 ``card`` in struct :ref:`v4l2_capability <v4l2-capability>`, ``type``
@@ -194,7 +194,7 @@ introduction.
        -  ``-``
 
        -  Applications can enumerate the supported image formats with the
-          :ref:`VIDIOC_ENUM_FMT <VIDIOC_ENUM_FMT>` ioctl to determine if
+          :ref:`VIDIOC_ENUM_FMT` ioctl to determine if
           the device supports grey scale capturing only. For more
           information on image formats see :ref:`pixfmt`.
 
@@ -204,7 +204,7 @@ introduction.
 
        -  ``-``
 
-       -  Applications can call the :ref:`VIDIOC_G_CROP <VIDIOC_G_CROP>`
+       -  Applications can call the :ref:`VIDIOC_G_CROP`
           ioctl to determine if the device supports capturing a subsection
           of the full picture ("cropping" in V4L2). If not, the ioctl
           returns the EINVAL error code. For more information on cropping
@@ -217,7 +217,7 @@ introduction.
        -  ``-``
 
        -  Applications can enumerate the supported image formats with the
-          :ref:`VIDIOC_ENUM_FMT <VIDIOC_ENUM_FMT>` ioctl to determine if
+          :ref:`VIDIOC_ENUM_FMT` ioctl to determine if
           the device supports MPEG streams.
 
     -  .. row 13
@@ -248,7 +248,7 @@ introduction.
 The ``audios`` field was replaced by ``capabilities`` flag
 ``V4L2_CAP_AUDIO``, indicating *if* the device has any audio inputs or
 outputs. To determine their number applications can enumerate audio
-inputs with the :ref:`VIDIOC_G_AUDIO <VIDIOC_G_AUDIO>` ioctl. The
+inputs with the :ref:`VIDIOC_G_AUDIO` ioctl. The
 audio ioctls are described in :ref:`audio`.
 
 The ``maxwidth``, ``maxheight``, ``minwidth`` and ``minheight`` fields
@@ -264,8 +264,8 @@ Video Sources
 V4L provides the ``VIDIOCGCHAN`` and ``VIDIOCSCHAN`` ioctl using struct
 :c:type:`struct video_channel` to enumerate the video inputs of a V4L
 device. The equivalent V4L2 ioctls are
-:ref:`VIDIOC_ENUMINPUT <VIDIOC_ENUMINPUT>`,
-:ref:`VIDIOC_G_INPUT <VIDIOC_G_INPUT>` and
+:ref:`VIDIOC_ENUMINPUT`,
+:ref:`VIDIOC_G_INPUT` and
 :ref:`VIDIOC_S_INPUT <VIDIOC_G_INPUT>` using struct
 :ref:`v4l2_input <v4l2-input>` as discussed in :ref:`video`.
 
@@ -328,7 +328,7 @@ Tuning
 The V4L ``VIDIOCGTUNER`` and ``VIDIOCSTUNER`` ioctl and struct
 :c:type:`struct video_tuner` can be used to enumerate the tuners of a
 V4L TV or radio device. The equivalent V4L2 ioctls are
-:ref:`VIDIOC_G_TUNER <VIDIOC_G_TUNER>` and
+:ref:`VIDIOC_G_TUNER` and
 :ref:`VIDIOC_S_TUNER <VIDIOC_G_TUNER>` using struct
 :ref:`v4l2_tuner <v4l2-tuner>`. Tuners are covered in :ref:`tuner`.
 
@@ -360,7 +360,7 @@ the struct :ref:`v4l2_tuner <v4l2-tuner>` ``capability`` field.
 
 The ``VIDIOCGFREQ`` and ``VIDIOCSFREQ`` ioctl to change the tuner
 frequency where renamed to
-:ref:`VIDIOC_G_FREQUENCY <VIDIOC_G_FREQUENCY>` and
+:ref:`VIDIOC_G_FREQUENCY` and
 :ref:`VIDIOC_S_FREQUENCY <VIDIOC_G_FREQUENCY>`. They take a pointer
 to a struct :ref:`v4l2_frequency <v4l2-frequency>` instead of an
 unsigned long integer.
@@ -374,8 +374,8 @@ Image Properties
 V4L2 has no equivalent of the ``VIDIOCGPICT`` and ``VIDIOCSPICT`` ioctl
 and struct :c:type:`struct video_picture`. The following fields where
 replaced by V4L2 controls accessible with the
-:ref:`VIDIOC_QUERYCTRL <VIDIOC_QUERYCTRL>`,
-:ref:`VIDIOC_G_CTRL <VIDIOC_G_CTRL>` and
+:ref:`VIDIOC_QUERYCTRL`,
+:ref:`VIDIOC_G_CTRL` and
 :ref:`VIDIOC_S_CTRL <VIDIOC_G_CTRL>` ioctls:
 
 
@@ -425,7 +425,7 @@ replaced by V4L2 controls accessible with the
 The V4L picture controls are assumed to range from 0 to 65535 with no
 particular reset value. The V4L2 API permits arbitrary limits and
 defaults which can be queried with the
-:ref:`VIDIOC_QUERYCTRL <VIDIOC_QUERYCTRL>` ioctl. For general
+:ref:`VIDIOC_QUERYCTRL` ioctl. For general
 information about controls see :ref:`control`.
 
 The ``depth`` (average number of bits per pixel) of a video image is
@@ -554,7 +554,7 @@ Audio
 The ``VIDIOCGAUDIO`` and ``VIDIOCSAUDIO`` ioctl and struct
 :c:type:`struct video_audio` are used to enumerate the audio inputs
 of a V4L device. The equivalent V4L2 ioctls are
-:ref:`VIDIOC_G_AUDIO <VIDIOC_G_AUDIO>` and
+:ref:`VIDIOC_G_AUDIO` and
 :ref:`VIDIOC_S_AUDIO <VIDIOC_G_AUDIO>` using struct
 :ref:`v4l2_audio <v4l2-audio>` as discussed in :ref:`audio`.
 
@@ -576,8 +576,8 @@ information on tuners. Related to audio modes struct
 stereo input, regardless if the source is a tuner.
 
 The following fields where replaced by V4L2 controls accessible with the
-:ref:`VIDIOC_QUERYCTRL <VIDIOC_QUERYCTRL>`,
-:ref:`VIDIOC_G_CTRL <VIDIOC_G_CTRL>` and
+:ref:`VIDIOC_QUERYCTRL`,
+:ref:`VIDIOC_G_CTRL` and
 :ref:`VIDIOC_S_CTRL <VIDIOC_G_CTRL>` ioctls:
 
 
@@ -621,7 +621,7 @@ The following fields where replaced by V4L2 controls accessible with the
 To determine which of these controls are supported by a driver V4L
 provides the ``flags`` ``VIDEO_AUDIO_VOLUME``, ``VIDEO_AUDIO_BASS``,
 ``VIDEO_AUDIO_TREBLE`` and ``VIDEO_AUDIO_BALANCE``. In the V4L2 API the
-:ref:`VIDIOC_QUERYCTRL <VIDIOC_QUERYCTRL>` ioctl reports if the
+:ref:`VIDIOC_QUERYCTRL` ioctl reports if the
 respective control is supported. Accordingly the ``VIDEO_AUDIO_MUTABLE``
 and ``VIDEO_AUDIO_MUTE`` flags where replaced by the boolean
 ``V4L2_CID_AUDIO_MUTE`` control.
@@ -630,7 +630,7 @@ All V4L2 controls have a ``step`` attribute replacing the struct
 :c:type:`struct video_audio` ``step`` field. The V4L audio controls
 are assumed to range from 0 to 65535 with no particular reset value. The
 V4L2 API permits arbitrary limits and defaults which can be queried with
-the :ref:`VIDIOC_QUERYCTRL <VIDIOC_QUERYCTRL>` ioctl. For general
+the :ref:`VIDIOC_QUERYCTRL` ioctl. For general
 information about controls see :ref:`control`.
 
 
@@ -638,7 +638,7 @@ Frame Buffer Overlay
 ====================
 
 The V4L2 ioctls equivalent to ``VIDIOCGFBUF`` and ``VIDIOCSFBUF`` are
-:ref:`VIDIOC_G_FBUF <VIDIOC_G_FBUF>` and
+:ref:`VIDIOC_G_FBUF` and
 :ref:`VIDIOC_S_FBUF <VIDIOC_G_FBUF>`. The ``base`` field of struct
 :c:type:`struct video_buffer` remained unchanged, except V4L2 defines
 a flag to indicate non-destructive overlays instead of a ``NULL``
@@ -650,7 +650,7 @@ list of RGB formats and their respective color depths.
 
 Instead of the special ioctls ``VIDIOCGWIN`` and ``VIDIOCSWIN`` V4L2
 uses the general-purpose data format negotiation ioctls
-:ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` and
+:ref:`VIDIOC_G_FMT` and
 :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`. They take a pointer to a struct
 :ref:`v4l2_format <v4l2-format>` as argument. Here the ``win`` member
 of the ``fmt`` union is used, a struct
@@ -678,7 +678,7 @@ has a separate ``bitmap`` pointer field for this purpose and the bitmap
 size is determined by ``w.width`` and ``w.height``.
 
 The ``VIDIOCCAPTURE`` ioctl to enable or disable overlay was renamed to
-:ref:`VIDIOC_OVERLAY <VIDIOC_OVERLAY>`.
+:ref:`VIDIOC_OVERLAY`.
 
 
 Cropping
@@ -687,10 +687,10 @@ Cropping
 To capture only a subsection of the full picture V4L defines the
 ``VIDIOCGCAPTURE`` and ``VIDIOCSCAPTURE`` ioctls using struct
 :c:type:`struct video_capture`. The equivalent V4L2 ioctls are
-:ref:`VIDIOC_G_CROP <VIDIOC_G_CROP>` and
+:ref:`VIDIOC_G_CROP` and
 :ref:`VIDIOC_S_CROP <VIDIOC_G_CROP>` using struct
 :ref:`v4l2_crop <v4l2-crop>`, and the related
-:ref:`VIDIOC_CROPCAP <VIDIOC_CROPCAP>` ioctl. This is a rather
+:ref:`VIDIOC_CROPCAP` ioctl. This is a rather
 complex matter, see :ref:`crop` for details.
 
 The ``x``, ``y``, ``width`` and ``height`` fields moved into struct
@@ -719,14 +719,14 @@ There is no essential difference between reading images from a V4L or
 V4L2 device using the :ref:`read() <func-read>` function, however V4L2
 drivers are not required to support this I/O method. Applications can
 determine if the function is available with the
-:ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>` ioctl. All V4L2 devices
+:ref:`VIDIOC_QUERYCAP` ioctl. All V4L2 devices
 exchanging data with applications must support the
 :ref:`select() <func-select>` and :ref:`poll() <func-poll>`
 functions.
 
 To select an image format and size, V4L provides the ``VIDIOCSPICT`` and
 ``VIDIOCSWIN`` ioctls. V4L2 uses the general-purpose data format
-negotiation ioctls :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` and
+negotiation ioctls :ref:`VIDIOC_G_FMT` and
 :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`. They take a pointer to a struct
 :ref:`v4l2_format <v4l2-format>` as argument, here the struct
 :ref:`v4l2_pix_format <v4l2-pix-format>` named ``pix`` of its
@@ -771,7 +771,7 @@ differences.
           into the driver, unless it has a module option to change the
           number when the driver module is loaded.
 
-       -  The :ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>` ioctl allocates the
+       -  The :ref:`VIDIOC_REQBUFS` ioctl allocates the
           desired number of buffers, this is a required step in the
           initialization sequence.
 
@@ -785,7 +785,7 @@ differences.
 
        -  Buffers are individually mapped. The offset and size of each
           buffer can be determined with the
-          :ref:`VIDIOC_QUERYBUF <VIDIOC_QUERYBUF>` ioctl.
+          :ref:`VIDIOC_QUERYBUF` ioctl.
 
     -  .. row 5
 
@@ -800,18 +800,18 @@ differences.
           buffer has been filled.
 
        -  Drivers maintain an incoming and outgoing queue.
-          :ref:`VIDIOC_QBUF <VIDIOC_QBUF>` enqueues any empty buffer into
+          :ref:`VIDIOC_QBUF` enqueues any empty buffer into
           the incoming queue. Filled buffers are dequeued from the outgoing
           queue with the :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctl. To wait
           until filled buffers become available this function,
           :ref:`select() <func-select>` or :ref:`poll() <func-poll>` can
-          be used. The :ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>` ioctl
+          be used. The :ref:`VIDIOC_STREAMON` ioctl
           must be called once after enqueuing one or more buffers to start
           capturing. Its counterpart
           :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` stops capturing and
           dequeues all buffers from both queues. Applications can query the
           signal status, if known, with the
-          :ref:`VIDIOC_ENUMINPUT <VIDIOC_ENUMINPUT>` ioctl.
+          :ref:`VIDIOC_ENUMINPUT` ioctl.
 
 
 For a more in-depth discussion of memory mapping and examples, see
diff --git a/Documentation/linux_tv/media/v4l/dmabuf.rst b/Documentation/linux_tv/media/v4l/dmabuf.rst
index bc2944c27e70..773d39308fd6 100644
--- a/Documentation/linux_tv/media/v4l/dmabuf.rst
+++ b/Documentation/linux_tv/media/v4l/dmabuf.rst
@@ -20,9 +20,9 @@ exporting V4L2 buffers as DMABUF file descriptors.
 Input and output devices support the streaming I/O method when the
 ``V4L2_CAP_STREAMING`` flag in the ``capabilities`` field of struct
 :ref:`v4l2_capability <v4l2-capability>` returned by the
-:ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>` ioctl is set. Whether
+:ref:`VIDIOC_QUERYCAP` ioctl is set. Whether
 importing DMA buffers through DMABUF file descriptors is supported is
-determined by calling the :ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>`
+determined by calling the :ref:`VIDIOC_REQBUFS`
 ioctl with the memory type set to ``V4L2_MEMORY_DMABUF``.
 
 This I/O method is dedicated to sharing DMA buffers between different
@@ -34,7 +34,7 @@ such file descriptor are exchanged. The descriptors and meta-information
 are passed in struct :ref:`v4l2_buffer <v4l2-buffer>` (or in struct
 :ref:`v4l2_plane <v4l2-plane>` in the multi-planar API case). The
 driver must be switched into DMABUF I/O mode by calling the
-:ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>` with the desired buffer type.
+:ref:`VIDIOC_REQBUFS` with the desired buffer type.
 
 
 .. code-block:: c
@@ -56,7 +56,7 @@ driver must be switched into DMABUF I/O mode by calling the
     }
 
 The buffer (plane) file descriptor is passed on the fly with the
-:ref:`VIDIOC_QBUF <VIDIOC_QBUF>` ioctl. In case of multiplanar
+:ref:`VIDIOC_QBUF` ioctl. In case of multiplanar
 buffers, every plane can be associated with a different DMABUF
 descriptor. Although buffers are commonly cycled, applications can pass
 a different DMABUF descriptor at each ``VIDIOC_QBUF`` call.
@@ -116,7 +116,7 @@ Captured or displayed buffers are dequeued with the
 buffer at any time between the completion of the DMA and this ioctl. The
 memory is also unlocked when
 :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` is called,
-:ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>`, or when the device is closed.
+:ref:`VIDIOC_REQBUFS`, or when the device is closed.
 
 For capturing applications it is customary to enqueue a number of empty
 buffers, to start capturing and enter the read loop. Here the
@@ -134,7 +134,7 @@ immediately with an EAGAIN error code when no buffer is available. The
 functions are always available.
 
 To start and stop capturing or displaying applications call the
-:ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>` and
+:ref:`VIDIOC_STREAMON` and
 :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` ioctls. Note that
 ``VIDIOC_STREAMOFF`` removes all buffers from both queues and unlocks
 all buffers as a side effect. Since there is no notion of doing anything
diff --git a/Documentation/linux_tv/media/v4l/dv-timings.rst b/Documentation/linux_tv/media/v4l/dv-timings.rst
index d51c36ec604c..4b22b1b0fccb 100644
--- a/Documentation/linux_tv/media/v4l/dv-timings.rst
+++ b/Documentation/linux_tv/media/v4l/dv-timings.rst
@@ -24,14 +24,14 @@ standards.
 
 To enumerate and query the attributes of the DV timings supported by a
 device applications use the
-:ref:`VIDIOC_ENUM_DV_TIMINGS <VIDIOC_ENUM_DV_TIMINGS>` and
-:ref:`VIDIOC_DV_TIMINGS_CAP <VIDIOC_DV_TIMINGS_CAP>` ioctls. To set
+:ref:`VIDIOC_ENUM_DV_TIMINGS` and
+:ref:`VIDIOC_DV_TIMINGS_CAP` ioctls. To set
 DV timings for the device applications use the
 :ref:`VIDIOC_S_DV_TIMINGS <VIDIOC_G_DV_TIMINGS>` ioctl and to get
 current DV timings they use the
-:ref:`VIDIOC_G_DV_TIMINGS <VIDIOC_G_DV_TIMINGS>` ioctl. To detect
+:ref:`VIDIOC_G_DV_TIMINGS` ioctl. To detect
 the DV timings as seen by the video receiver applications use the
-:ref:`VIDIOC_QUERY_DV_TIMINGS <VIDIOC_QUERY_DV_TIMINGS>` ioctl.
+:ref:`VIDIOC_QUERY_DV_TIMINGS` ioctl.
 
 Applications can make use of the :ref:`input-capabilities` and
 :ref:`output-capabilities` flags to determine whether the digital
diff --git a/Documentation/linux_tv/media/v4l/extended-controls.rst b/Documentation/linux_tv/media/v4l/extended-controls.rst
index 66333b9f60fd..9a10edc50fa0 100644
--- a/Documentation/linux_tv/media/v4l/extended-controls.rst
+++ b/Documentation/linux_tv/media/v4l/extended-controls.rst
@@ -39,11 +39,11 @@ The Extended Control API
 ========================
 
 Three new ioctls are available:
-:ref:`VIDIOC_G_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>`,
+:ref:`VIDIOC_G_EXT_CTRLS`,
 :ref:`VIDIOC_S_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` and
 :ref:`VIDIOC_TRY_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>`. These ioctls act
 on arrays of controls (as opposed to the
-:ref:`VIDIOC_G_CTRL <VIDIOC_G_CTRL>` and
+:ref:`VIDIOC_G_CTRL` and
 :ref:`VIDIOC_S_CTRL <VIDIOC_G_CTRL>` ioctls that act on a single
 control). This is needed since it is often required to atomically change
 several controls at once.
@@ -79,7 +79,7 @@ with compound types should only be used programmatically.
 
 Since such compound controls need to expose more information about
 themselves than is possible with
-:ref:`VIDIOC_QUERYCTRL <VIDIOC_QUERYCTRL>` the
+:ref:`VIDIOC_QUERYCTRL` the
 :ref:`VIDIOC_QUERY_EXT_CTRL <VIDIOC_QUERYCTRL>` ioctl was added. In
 particular, this ioctl gives the dimensions of the N-dimensional array
 if this control consists of more than one element.
@@ -87,7 +87,7 @@ if this control consists of more than one element.
 It is important to realize that due to the flexibility of controls it is
 necessary to check whether the control you want to set actually is
 supported in the driver and what the valid range of values is. So use
-the :ref:`VIDIOC_QUERYCTRL <VIDIOC_QUERYCTRL>` (or
+the :ref:`VIDIOC_QUERYCTRL` (or
 :ref:`VIDIOC_QUERY_EXT_CTRL <VIDIOC_QUERYCTRL>`) and
 :ref:`VIDIOC_QUERYMENU <VIDIOC_QUERYCTRL>` ioctls to check this. Also
 note that it is possible that some of the menu indices in a control of
@@ -103,7 +103,7 @@ Enumerating Extended Controls
 =============================
 
 The recommended way to enumerate over the extended controls is by using
-:ref:`VIDIOC_QUERYCTRL <VIDIOC_QUERYCTRL>` in combination with the
+:ref:`VIDIOC_QUERYCTRL` in combination with the
 ``V4L2_CTRL_FLAG_NEXT_CTRL`` flag:
 
 
@@ -169,7 +169,7 @@ within a control panel.
 
 The flags field of struct :ref:`v4l2_queryctrl <v4l2-queryctrl>` also
 contains hints on the behavior of the control. See the
-:ref:`VIDIOC_QUERYCTRL <VIDIOC_QUERYCTRL>` documentation for more
+:ref:`VIDIOC_QUERYCTRL` documentation for more
 details.
 
 
@@ -198,7 +198,7 @@ Codec Control IDs
 
 ``V4L2_CID_MPEG_CLASS (class)``
     The Codec class descriptor. Calling
-    :ref:`VIDIOC_QUERYCTRL <VIDIOC_QUERYCTRL>` for this control will
+    :ref:`VIDIOC_QUERYCTRL` for this control will
     return a description of this control class. This description can be
     used as the caption of a Tab page in a GUI, for example.
 
@@ -1168,7 +1168,7 @@ Codec Control IDs
     This read-only control returns the 33-bit video Presentation Time
     Stamp as defined in ITU T-REC-H.222.0 and ISO/IEC 13818-1 of the
     currently displayed frame. This is the same PTS as is used in
-    :ref:`VIDIOC_DECODER_CMD <VIDIOC_DECODER_CMD>`.
+    :ref:`VIDIOC_DECODER_CMD`.
 
 .. _`v4l2-mpeg-video-dec-frame`:
 
@@ -2781,7 +2781,7 @@ Camera Control IDs
 
 ``V4L2_CID_CAMERA_CLASS (class)``
     The Camera class descriptor. Calling
-    :ref:`VIDIOC_QUERYCTRL <VIDIOC_QUERYCTRL>` for this control will
+    :ref:`VIDIOC_QUERYCTRL` for this control will
     return a description of this control class.
 
 .. _`v4l2-exposure-auto-type`:
@@ -3441,7 +3441,7 @@ FM_TX Control IDs
 
 ``V4L2_CID_FM_TX_CLASS (class)``
     The FM_TX class descriptor. Calling
-    :ref:`VIDIOC_QUERYCTRL <VIDIOC_QUERYCTRL>` for this control will
+    :ref:`VIDIOC_QUERYCTRL` for this control will
     return a description of this control class.
 
 ``V4L2_CID_RDS_TX_DEVIATION (integer)``
@@ -3870,7 +3870,7 @@ JPEG Control IDs
 
 ``V4L2_CID_JPEG_CLASS (class)``
     The JPEG class descriptor. Calling
-    :ref:`VIDIOC_QUERYCTRL <VIDIOC_QUERYCTRL>` for this control will
+    :ref:`VIDIOC_QUERYCTRL` for this control will
     return a description of this control class.
 
 ``V4L2_CID_JPEG_CHROMA_SUBSAMPLING (menu)``
@@ -4271,7 +4271,7 @@ FM_RX Control IDs
 
 ``V4L2_CID_FM_RX_CLASS (class)``
     The FM_RX class descriptor. Calling
-    :ref:`VIDIOC_QUERYCTRL <VIDIOC_QUERYCTRL>` for this control will
+    :ref:`VIDIOC_QUERYCTRL` for this control will
     return a description of this control class.
 
 ``V4L2_CID_RDS_RECEPTION (boolean)``
@@ -4369,7 +4369,7 @@ Detect Control IDs
 
 ``V4L2_CID_DETECT_CLASS (class)``
     The Detect class descriptor. Calling
-    :ref:`VIDIOC_QUERYCTRL <VIDIOC_QUERYCTRL>` for this control will
+    :ref:`VIDIOC_QUERYCTRL` for this control will
     return a description of this control class.
 
 ``V4L2_CID_DETECT_MD_MODE (menu)``
@@ -4463,7 +4463,7 @@ RF_TUNER Control IDs
 
 ``V4L2_CID_RF_TUNER_CLASS (class)``
     The RF_TUNER class descriptor. Calling
-    :ref:`VIDIOC_QUERYCTRL <VIDIOC_QUERYCTRL>` for this control will
+    :ref:`VIDIOC_QUERYCTRL` for this control will
     return a description of this control class.
 
 ``V4L2_CID_RF_TUNER_BANDWIDTH_AUTO (boolean)``
diff --git a/Documentation/linux_tv/media/v4l/format.rst b/Documentation/linux_tv/media/v4l/format.rst
index a754fa81f707..46f740a0092e 100644
--- a/Documentation/linux_tv/media/v4l/format.rst
+++ b/Documentation/linux_tv/media/v4l/format.rst
@@ -23,7 +23,7 @@ current selection.
 
 A single mechanism exists to negotiate all data formats using the
 aggregate struct :ref:`v4l2_format <v4l2-format>` and the
-:ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` and
+:ref:`VIDIOC_G_FMT` and
 :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctls. Additionally the
 :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` ioctl can be used to examine
 what the hardware *could* do, without actually selecting a new data
@@ -52,7 +52,7 @@ image size.
 
 When applications omit the ``VIDIOC_S_FMT`` ioctl its locking side
 effects are implied by the next step, the selection of an I/O method
-with the :ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>` ioctl or implicit
+with the :ref:`VIDIOC_REQBUFS` ioctl or implicit
 with the first :ref:`read() <func-read>` or
 :ref:`write() <func-write>` call.
 
@@ -75,7 +75,7 @@ Apart of the generic format negotiation functions a special ioctl to
 enumerate all image formats supported by video capture, overlay or
 output devices is available. [1]_
 
-The :ref:`VIDIOC_ENUM_FMT <VIDIOC_ENUM_FMT>` ioctl must be supported
+The :ref:`VIDIOC_ENUM_FMT` ioctl must be supported
 by all drivers exchanging image data with applications.
 
     **Important**
diff --git a/Documentation/linux_tv/media/v4l/func-mmap.rst b/Documentation/linux_tv/media/v4l/func-mmap.rst
index 7243142384bb..b908c0253c07 100644
--- a/Documentation/linux_tv/media/v4l/func-mmap.rst
+++ b/Documentation/linux_tv/media/v4l/func-mmap.rst
@@ -98,8 +98,8 @@ application address space, preferably at address ``start``. This latter
 address is a hint only, and is usually specified as 0.
 
 Suitable length and offset parameters are queried with the
-:ref:`VIDIOC_QUERYBUF <VIDIOC_QUERYBUF>` ioctl. Buffers must be
-allocated with the :ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>` ioctl
+:ref:`VIDIOC_QUERYBUF` ioctl. Buffers must be
+allocated with the :ref:`VIDIOC_REQBUFS` ioctl
 before they can be queried.
 
 To unmap buffers the :ref:`munmap() <func-munmap>` function is used.
@@ -125,7 +125,7 @@ EINVAL
     The ``flags`` or ``prot`` value is not supported.
 
     No buffers have been allocated with the
-    :ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>` ioctl.
+    :ref:`VIDIOC_REQBUFS` ioctl.
 
 ENOMEM
     Not enough physical or virtual memory was available to complete the
diff --git a/Documentation/linux_tv/media/v4l/func-poll.rst b/Documentation/linux_tv/media/v4l/func-poll.rst
index 28a769af9309..782531fe964c 100644
--- a/Documentation/linux_tv/media/v4l/func-poll.rst
+++ b/Documentation/linux_tv/media/v4l/func-poll.rst
@@ -32,7 +32,7 @@ When streaming I/O has been negotiated this function waits until a
 buffer has been filled by the capture device and can be dequeued with
 the :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctl. For output devices this
 function waits until the device is ready to accept a new buffer to be
-queued up with the :ref:`VIDIOC_QBUF <VIDIOC_QBUF>` ioctl for
+queued up with the :ref:`VIDIOC_QBUF` ioctl for
 display. When buffers are already in the outgoing queue of the driver
 (capture) or the incoming queue isn't full (display) the function
 returns immediately.
@@ -45,17 +45,17 @@ flags in the ``revents`` field, output devices the ``POLLOUT`` and
 ``POLLWRNORM`` flags. When the function timed out it returns a value of
 zero, on failure it returns -1 and the ``errno`` variable is set
 appropriately. When the application did not call
-:ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>` the :c:func:`poll()`
+:ref:`VIDIOC_STREAMON` the :c:func:`poll()`
 function succeeds, but sets the ``POLLERR`` flag in the ``revents``
 field. When the application has called
-:ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>` for a capture device but
-hasn't yet called :ref:`VIDIOC_QBUF <VIDIOC_QBUF>`, the
+:ref:`VIDIOC_STREAMON` for a capture device but
+hasn't yet called :ref:`VIDIOC_QBUF`, the
 :c:func:`poll()` function succeeds and sets the ``POLLERR`` flag in
 the ``revents`` field. For output devices this same situation will cause
 :c:func:`poll()` to succeed as well, but it sets the ``POLLOUT`` and
 ``POLLWRNORM`` flags in the ``revents`` field.
 
-If an event occurred (see :ref:`VIDIOC_DQEVENT <VIDIOC_DQEVENT>`)
+If an event occurred (see :ref:`VIDIOC_DQEVENT`)
 then ``POLLPRI`` will be set in the ``revents`` field and
 :c:func:`poll()` will return.
 
diff --git a/Documentation/linux_tv/media/v4l/func-read.rst b/Documentation/linux_tv/media/v4l/func-read.rst
index 497bc9a9dd5a..0eae26288189 100644
--- a/Documentation/linux_tv/media/v4l/func-read.rst
+++ b/Documentation/linux_tv/media/v4l/func-read.rst
@@ -85,7 +85,7 @@ enough. Again, the behavior when the driver runs out of free buffers
 depends on the discarding policy.
 
 Applications can get and set the number of buffers used internally by
-the driver with the :ref:`VIDIOC_G_PARM <VIDIOC_G_PARM>` and
+the driver with the :ref:`VIDIOC_G_PARM` and
 :ref:`VIDIOC_S_PARM <VIDIOC_G_PARM>` ioctls. They are optional,
 however. The discarding policy is not reported and cannot be changed.
 For minimum requirements see :ref:`devices`.
diff --git a/Documentation/linux_tv/media/v4l/func-select.rst b/Documentation/linux_tv/media/v4l/func-select.rst
index 77fdf33648b3..77302800e6ca 100644
--- a/Documentation/linux_tv/media/v4l/func-select.rst
+++ b/Documentation/linux_tv/media/v4l/func-select.rst
@@ -39,8 +39,8 @@ On success :c:func:`select()` returns the total number of bits set in
 the :c:type:`struct fd_set`s. When the function timed out it returns
 a value of zero. On failure it returns -1 and the ``errno`` variable is
 set appropriately. When the application did not call
-:ref:`VIDIOC_QBUF <VIDIOC_QBUF>` or
-:ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>` yet the :c:func:`select()`
+:ref:`VIDIOC_QBUF` or
+:ref:`VIDIOC_STREAMON` yet the :c:func:`select()`
 function succeeds, setting the bit of the file descriptor in ``readfds``
 or ``writefds``, but subsequent :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>`
 calls will fail. [1]_
diff --git a/Documentation/linux_tv/media/v4l/hist-v4l2.rst b/Documentation/linux_tv/media/v4l/hist-v4l2.rst
index ab18331710f7..4bd621b3aa03 100644
--- a/Documentation/linux_tv/media/v4l/hist-v4l2.rst
+++ b/Documentation/linux_tv/media/v4l/hist-v4l2.rst
@@ -38,10 +38,10 @@ enumerable.
 
 1998-10-02: The ``id`` field was removed from struct
 :c:type:`struct video_standard` and the color subcarrier fields were
-renamed. The :ref:`VIDIOC_QUERYSTD <VIDIOC_QUERYSTD>` ioctl was
-renamed to :ref:`VIDIOC_ENUMSTD <VIDIOC_ENUMSTD>`,
-:ref:`VIDIOC_G_INPUT <VIDIOC_G_INPUT>` to
-:ref:`VIDIOC_ENUMINPUT <VIDIOC_ENUMINPUT>`. A first draft of the
+renamed. The :ref:`VIDIOC_QUERYSTD` ioctl was
+renamed to :ref:`VIDIOC_ENUMSTD`,
+:ref:`VIDIOC_G_INPUT` to
+:ref:`VIDIOC_ENUMINPUT`. A first draft of the
 Codec API was released.
 
 1998-11-08: Many minor changes. Most symbols have been renamed. Some
@@ -52,7 +52,7 @@ material changes to struct :ref:`v4l2_capability <v4l2-capability>`.
 1998-11-14: ``V4L2_PIX_FMT_RGB24`` changed to ``V4L2_PIX_FMT_BGR24``,
 and ``V4L2_PIX_FMT_RGB32`` changed to ``V4L2_PIX_FMT_BGR32``. Audio
 controls are now accessible with the
-:ref:`VIDIOC_G_CTRL <VIDIOC_G_CTRL>` and
+:ref:`VIDIOC_G_CTRL` and
 :ref:`VIDIOC_S_CTRL <VIDIOC_G_CTRL>` ioctls under names starting
 with ``V4L2_CID_AUDIO``. The ``V4L2_MAJOR`` define was removed from
 ``videodev.h`` since it was only used once in the ``videodev`` kernel
@@ -142,7 +142,7 @@ common Linux driver API conventions.
        int a = V4L2_XXX; err = ioctl(fd, VIDIOC_XXX, &a);
 
 4. All the different get- and set-format commands were swept into one
-   :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` and
+   :ref:`VIDIOC_G_FMT` and
    :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl taking a union and a
    type field selecting the union member as parameter. Purpose is to
    simplify the API by eliminating several ioctls and to allow new and
@@ -246,13 +246,13 @@ correctly through the backward compatibility layer. [Solution?]
 2001-04-13: Big endian 16-bit RGB formats were added.
 
 2001-09-17: New YUV formats and the
-:ref:`VIDIOC_G_FREQUENCY <VIDIOC_G_FREQUENCY>` and
+:ref:`VIDIOC_G_FREQUENCY` and
 :ref:`VIDIOC_S_FREQUENCY <VIDIOC_G_FREQUENCY>` ioctls were added.
 (The old ``VIDIOC_G_FREQ`` and ``VIDIOC_S_FREQ`` ioctls did not take
 multiple tuners into account.)
 
 2000-09-18: ``V4L2_BUF_TYPE_VBI`` was added. This may *break
-compatibility* as the :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` and
+compatibility* as the :ref:`VIDIOC_G_FMT` and
 :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctls may fail now if the struct
 :c:type:`struct v4l2_fmt` ``type`` field does not contain
 ``V4L2_BUF_TYPE_VBI``. In the documentation of the struct
@@ -325,7 +325,7 @@ This unnamed version was finally merged into Linux 2.5.46.
     dramatically. Note that also the size of the structure changed,
     which is encoded in the ioctl request code, thus older V4L2 devices
     will respond with an EINVAL error code to the new
-    :ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>` ioctl.
+    :ref:`VIDIOC_QUERYCAP` ioctl.
 
     There are new fields to identify the driver, a new RDS device
     function ``V4L2_CAP_RDS_CAPTURE``, the ``V4L2_CAP_AUDIO`` flag
@@ -401,13 +401,13 @@ This unnamed version was finally merged into Linux 2.5.46.
     supported standards with an ioctl applications can now refer to
     standards by :ref:`v4l2_std_id <v4l2-std-id>` and symbols
     defined in the ``videodev2.h`` header file. For details see
-    :ref:`standard`. The :ref:`VIDIOC_G_STD <VIDIOC_G_STD>` and
+    :ref:`standard`. The :ref:`VIDIOC_G_STD` and
     :ref:`VIDIOC_S_STD <VIDIOC_G_STD>` now take a pointer to this
-    type as argument. :ref:`VIDIOC_QUERYSTD <VIDIOC_QUERYSTD>` was
+    type as argument. :ref:`VIDIOC_QUERYSTD` was
     added to autodetect the received standard, if the hardware has this
     capability. In struct :ref:`v4l2_standard <v4l2-standard>` an
     ``index`` field was added for
-    :ref:`VIDIOC_ENUMSTD <VIDIOC_ENUMSTD>`. A
+    :ref:`VIDIOC_ENUMSTD`. A
     :ref:`v4l2_std_id <v4l2-std-id>` field named ``id`` was added as
     machine readable identifier, also replacing the ``transmission``
     field. The misleading ``framerate`` field was renamed to
@@ -416,7 +416,7 @@ This unnamed version was finally merged into Linux 2.5.46.
     removed.
 
     Struct :c:type:`struct v4l2_enumstd` ceased to be.
-    :ref:`VIDIOC_ENUMSTD <VIDIOC_ENUMSTD>` now takes a pointer to a
+    :ref:`VIDIOC_ENUMSTD` now takes a pointer to a
     struct :ref:`v4l2_standard <v4l2-standard>` directly. The
     information which standards are supported by a particular video
     input or output moved into struct :ref:`v4l2_input <v4l2-input>`
@@ -538,7 +538,7 @@ This unnamed version was finally merged into Linux 2.5.46.
     added as in struct :ref:`v4l2_format <v4l2-format>`. The
     ``VIDIOC_ENUM_FBUFFMT`` ioctl is no longer needed and was removed.
     These calls can be replaced by
-    :ref:`VIDIOC_ENUM_FMT <VIDIOC_ENUM_FMT>` with type
+    :ref:`VIDIOC_ENUM_FMT` with type
     ``V4L2_BUF_TYPE_VIDEO_OVERLAY``.
 
 11. In struct :ref:`v4l2_pix_format <v4l2-pix-format>` the ``depth``
@@ -716,14 +716,14 @@ V4L2 2003-06-19
 
 3. The audio input and output interface was found to be incomplete.
 
-   Previously the :ref:`VIDIOC_G_AUDIO <VIDIOC_G_AUDIO>` ioctl would
+   Previously the :ref:`VIDIOC_G_AUDIO` ioctl would
    enumerate the available audio inputs. An ioctl to determine the
    current audio input, if more than one combines with the current video
    input, did not exist. So ``VIDIOC_G_AUDIO`` was renamed to
    ``VIDIOC_G_AUDIO_OLD``, this ioctl was removed on Kernel 2.6.39. The
-   :ref:`VIDIOC_ENUMAUDIO <VIDIOC_ENUMAUDIO>` ioctl was added to
+   :ref:`VIDIOC_ENUMAUDIO` ioctl was added to
    enumerate audio inputs, while
-   :ref:`VIDIOC_G_AUDIO <VIDIOC_G_AUDIO>` now reports the current
+   :ref:`VIDIOC_G_AUDIO` now reports the current
    audio input.
 
    The same changes were made to
@@ -734,7 +734,7 @@ V4L2 2003-06-19
    between the old and new ioctls, but drivers and applications must be
    updated to successfully compile again.
 
-4. The :ref:`VIDIOC_OVERLAY <VIDIOC_OVERLAY>` ioctl was incorrectly
+4. The :ref:`VIDIOC_OVERLAY` ioctl was incorrectly
    defined with write-read parameter. It was changed to write-only,
    while the write-read version was renamed to ``VIDIOC_OVERLAY_OLD``.
    The old ioctl was removed on Kernel 2.6.39. Until further the
@@ -824,7 +824,7 @@ V4L2 2003-11-05
 V4L2 in Linux 2.6.6, 2004-05-09
 ===============================
 
-1. The :ref:`VIDIOC_CROPCAP <VIDIOC_CROPCAP>` ioctl was incorrectly
+1. The :ref:`VIDIOC_CROPCAP` ioctl was incorrectly
    defined with read-only parameter. It is now defined as write-read
    ioctl, while the read-only version was renamed to
    ``VIDIOC_CROPCAP_OLD``. The old ioctl was removed on Kernel 2.6.39.
@@ -852,7 +852,7 @@ V4L2 spec erratum 2004-08-01
 3. In the Current Audio Input example the ``VIDIOC_G_AUDIO`` ioctl took
    the wrong argument.
 
-4. The documentation of the :ref:`VIDIOC_QBUF <VIDIOC_QBUF>` and
+4. The documentation of the :ref:`VIDIOC_QBUF` and
    :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctls did not mention the
    struct :ref:`v4l2_buffer <v4l2-buffer>` ``memory`` field. It was
    also missing from examples. Also on the ``VIDIOC_DQBUF`` page the EIO
@@ -870,7 +870,7 @@ V4L2 in Linux 2.6.14
 V4L2 in Linux 2.6.15
 ====================
 
-1. The :ref:`VIDIOC_LOG_STATUS <VIDIOC_LOG_STATUS>` ioctl was added.
+1. The :ref:`VIDIOC_LOG_STATUS` ioctl was added.
 
 2. New video standards ``V4L2_STD_NTSC_443``, ``V4L2_STD_SECAM_LC``,
    ``V4L2_STD_SECAM_DK`` (a set of SECAM D, K and K1), and
@@ -940,7 +940,7 @@ V4L2 in Linux 2.6.17
 2. A new ``V4L2_TUNER_MODE_LANG1_LANG2`` was defined to record both
    languages of a bilingual program. The use of
    ``V4L2_TUNER_MODE_STEREO`` for this purpose is deprecated now. See
-   the :ref:`VIDIOC_G_TUNER <VIDIOC_G_TUNER>` section for details.
+   the :ref:`VIDIOC_G_TUNER` section for details.
 
 
 V4L2 spec erratum 2006-09-23 (Draft 0.15)
@@ -976,11 +976,11 @@ V4L2 spec erratum 2006-09-23 (Draft 0.15)
 V4L2 in Linux 2.6.18
 ====================
 
-1. New ioctls :ref:`VIDIOC_G_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>`,
+1. New ioctls :ref:`VIDIOC_G_EXT_CTRLS`,
    :ref:`VIDIOC_S_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` and
    :ref:`VIDIOC_TRY_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` were added, a
    flag to skip unsupported controls with
-   :ref:`VIDIOC_QUERYCTRL <VIDIOC_QUERYCTRL>`, new control types
+   :ref:`VIDIOC_QUERYCTRL`, new control types
    ``V4L2_CTRL_TYPE_INTEGER64`` and ``V4L2_CTRL_TYPE_CTRL_CLASS``
    (:ref:`v4l2-ctrl-type`), and new control flags
    ``V4L2_CTRL_FLAG_READ_ONLY``, ``V4L2_CTRL_FLAG_UPDATE``,
@@ -995,15 +995,15 @@ V4L2 in Linux 2.6.19
    buffer type field was added replacing a reserved field. Note on
    architectures where the size of enum types differs from int types the
    size of the structure changed. The
-   :ref:`VIDIOC_G_SLICED_VBI_CAP <VIDIOC_G_SLICED_VBI_CAP>` ioctl
+   :ref:`VIDIOC_G_SLICED_VBI_CAP` ioctl
    was redefined from being read-only to write-read. Applications must
    initialize the type field and clear the reserved fields now. These
    changes may *break the compatibility* with older drivers and
    applications.
 
-2. The ioctls :ref:`VIDIOC_ENUM_FRAMESIZES <VIDIOC_ENUM_FRAMESIZES>`
+2. The ioctls :ref:`VIDIOC_ENUM_FRAMESIZES`
    and
-   :ref:`VIDIOC_ENUM_FRAMEINTERVALS <VIDIOC_ENUM_FRAMEINTERVALS>`
+   :ref:`VIDIOC_ENUM_FRAMEINTERVALS`
    were added.
 
 3. A new pixel format ``V4L2_PIX_FMT_RGB444`` (:ref:`rgb-formats`) was
@@ -1034,7 +1034,7 @@ V4L2 in Linux 2.6.22
 
 2. Three new clipping/blending methods with a global or straight or
    inverted local alpha value were added to the video overlay interface.
-   See the description of the :ref:`VIDIOC_G_FBUF <VIDIOC_G_FBUF>`
+   See the description of the :ref:`VIDIOC_G_FBUF`
    and :ref:`VIDIOC_S_FBUF <VIDIOC_G_FBUF>` ioctls for details.
 
    A new ``global_alpha`` field was added to
@@ -1100,7 +1100,7 @@ V4L2 in Linux 2.6.26
 V4L2 in Linux 2.6.27
 ====================
 
-1. The :ref:`VIDIOC_S_HW_FREQ_SEEK <VIDIOC_S_HW_FREQ_SEEK>` ioctl
+1. The :ref:`VIDIOC_S_HW_FREQ_SEEK` ioctl
    and the ``V4L2_CAP_HW_FREQ_SEEK`` capability were added.
 
 2. The pixel formats ``V4L2_PIX_FMT_YVYU``, ``V4L2_PIX_FMT_PCA501``,
@@ -1244,9 +1244,9 @@ V4L2 in Linux 3.4
 1. Added :ref:`JPEG compression control class <jpeg-controls>`.
 
 2. Extended the DV Timings API:
-   :ref:`VIDIOC_ENUM_DV_TIMINGS <VIDIOC_ENUM_DV_TIMINGS>`,
-   :ref:`VIDIOC_QUERY_DV_TIMINGS <VIDIOC_QUERY_DV_TIMINGS>` and
-   :ref:`VIDIOC_DV_TIMINGS_CAP <VIDIOC_DV_TIMINGS_CAP>`.
+   :ref:`VIDIOC_ENUM_DV_TIMINGS`,
+   :ref:`VIDIOC_QUERY_DV_TIMINGS` and
+   :ref:`VIDIOC_DV_TIMINGS_CAP`.
 
 
 V4L2 in Linux 3.5
@@ -1256,7 +1256,7 @@ V4L2 in Linux 3.5
    V4L2_CTRL_TYPE_INTEGER_MENU.
 
 2. Added selection API for V4L2 subdev interface:
-   :ref:`VIDIOC_SUBDEV_G_SELECTION <VIDIOC_SUBDEV_G_SELECTION>` and
+   :ref:`VIDIOC_SUBDEV_G_SELECTION` and
    :ref:`VIDIOC_SUBDEV_S_SELECTION <VIDIOC_SUBDEV_G_SELECTION>`.
 
 3. Added ``V4L2_COLORFX_ANTIQUE``, ``V4L2_COLORFX_ART_FREEZE``,
@@ -1286,7 +1286,7 @@ V4L2 in Linux 3.6
    capabilities.
 
 3. Added support for frequency band enumerations:
-   :ref:`VIDIOC_ENUM_FREQ_BANDS <VIDIOC_ENUM_FREQ_BANDS>`.
+   :ref:`VIDIOC_ENUM_FREQ_BANDS`.
 
 
 V4L2 in Linux 3.9
@@ -1308,7 +1308,7 @@ V4L2 in Linux 3.10
    capability flags V4L2_IN_CAP_PRESETS and V4L2_OUT_CAP_PRESETS.
 
 2. Added new debugging ioctl
-   :ref:`VIDIOC_DBG_G_CHIP_INFO <VIDIOC_DBG_G_CHIP_INFO>`.
+   :ref:`VIDIOC_DBG_G_CHIP_INFO`.
 
 
 V4L2 in Linux 3.11
@@ -1452,10 +1452,10 @@ Experimental API Elements
 The following V4L2 API elements are currently experimental and may
 change in the future.
 
--  :ref:`VIDIOC_DBG_G_REGISTER <VIDIOC_DBG_G_REGISTER>` and
+-  :ref:`VIDIOC_DBG_G_REGISTER` and
    :ref:`VIDIOC_DBG_S_REGISTER <VIDIOC_DBG_G_REGISTER>` ioctls.
 
--  :ref:`VIDIOC_DBG_G_CHIP_INFO <VIDIOC_DBG_G_CHIP_INFO>` ioctl.
+-  :ref:`VIDIOC_DBG_G_CHIP_INFO` ioctl.
 
 
 .. _obsolete:
diff --git a/Documentation/linux_tv/media/v4l/io.rst b/Documentation/linux_tv/media/v4l/io.rst
index 2bc04e597c90..651d4530c703 100644
--- a/Documentation/linux_tv/media/v4l/io.rst
+++ b/Documentation/linux_tv/media/v4l/io.rst
@@ -16,7 +16,7 @@ read or write will fail at any time.
 
 Other methods must be negotiated. To select the streaming I/O method
 with memory mapped or user buffers applications call the
-:ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>` ioctl. The asynchronous I/O
+:ref:`VIDIOC_REQBUFS` ioctl. The asynchronous I/O
 method is not defined yet.
 
 Video overlay can be considered another I/O method, although the
diff --git a/Documentation/linux_tv/media/v4l/libv4l-introduction.rst b/Documentation/linux_tv/media/v4l/libv4l-introduction.rst
index 4fd87ec33260..bc3eb48e1d9f 100644
--- a/Documentation/linux_tv/media/v4l/libv4l-introduction.rst
+++ b/Documentation/linux_tv/media/v4l/libv4l-introduction.rst
@@ -92,16 +92,16 @@ and to enhance the image quality.
 In most cases, libv4l2 just passes the calls directly through to the
 v4l2 driver, intercepting the calls to
 :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>`,
-:ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>`
+:ref:`VIDIOC_G_FMT`
 :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`
-:ref:`VIDIOC_ENUM_FRAMESIZES <VIDIOC_ENUM_FRAMESIZES>` and
-:ref:`VIDIOC_ENUM_FRAMEINTERVALS <VIDIOC_ENUM_FRAMEINTERVALS>` in
+:ref:`VIDIOC_ENUM_FRAMESIZES` and
+:ref:`VIDIOC_ENUM_FRAMEINTERVALS` in
 order to emulate the formats
 :ref:`V4L2_PIX_FMT_BGR24 <V4L2-PIX-FMT-BGR24>`,
 :ref:`V4L2_PIX_FMT_RGB24 <V4L2-PIX-FMT-RGB24>`,
 :ref:`V4L2_PIX_FMT_YUV420 <V4L2-PIX-FMT-YUV420>`, and
 :ref:`V4L2_PIX_FMT_YVU420 <V4L2-PIX-FMT-YVU420>`, if they aren't
-available in the driver. :ref:`VIDIOC_ENUM_FMT <VIDIOC_ENUM_FMT>`
+available in the driver. :ref:`VIDIOC_ENUM_FMT`
 keeps enumerating the hardware supported formats, plus the emulated
 formats offered by libv4l at the end.
 
diff --git a/Documentation/linux_tv/media/v4l/mmap.rst b/Documentation/linux_tv/media/v4l/mmap.rst
index de144028ec56..2013e882f0d4 100644
--- a/Documentation/linux_tv/media/v4l/mmap.rst
+++ b/Documentation/linux_tv/media/v4l/mmap.rst
@@ -9,10 +9,10 @@ Streaming I/O (Memory Mapping)
 Input and output devices support this I/O method when the
 ``V4L2_CAP_STREAMING`` flag in the ``capabilities`` field of struct
 :ref:`v4l2_capability <v4l2-capability>` returned by the
-:ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>` ioctl is set. There are two
+:ref:`VIDIOC_QUERYCAP` ioctl is set. There are two
 streaming methods, to determine if the memory mapping flavor is
 supported applications must call the
-:ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>` ioctl.
+:ref:`VIDIOC_REQBUFS` ioctl.
 
 Streaming is an I/O method where only pointers to buffers are exchanged
 between application and driver, the data itself is not copied. Memory
@@ -29,7 +29,7 @@ a different type of data. To access different sets at the same time
 different file descriptors must be used. [1]_
 
 To allocate device buffers applications call the
-:ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>` ioctl with the desired number
+:ref:`VIDIOC_REQBUFS` ioctl with the desired number
 of buffers and buffer type, for example ``V4L2_BUF_TYPE_VIDEO_CAPTURE``.
 This ioctl can also be used to change the number of buffers or to free
 the allocated memory, provided none of the buffers are still mapped.
@@ -37,7 +37,7 @@ the allocated memory, provided none of the buffers are still mapped.
 Before applications can access the buffers they must map them into their
 address space with the :ref:`mmap() <func-mmap>` function. The
 location of the buffers in device memory can be determined with the
-:ref:`VIDIOC_QUERYBUF <VIDIOC_QUERYBUF>` ioctl. In the single-planar
+:ref:`VIDIOC_QUERYBUF` ioctl. In the single-planar
 API case, the ``m.offset`` and ``length`` returned in a struct
 :ref:`v4l2_buffer <v4l2-buffer>` are passed as sixth and second
 parameter to the :c:func:`mmap()` function. When using the
@@ -227,10 +227,10 @@ when the application runs out of free buffers, it must wait until an
 empty buffer can be dequeued and reused.
 
 To enqueue and dequeue a buffer applications use the
-:ref:`VIDIOC_QBUF <VIDIOC_QBUF>` and
+:ref:`VIDIOC_QBUF` and
 :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctl. The status of a buffer being
 mapped, enqueued, full or empty can be determined at any time using the
-:ref:`VIDIOC_QUERYBUF <VIDIOC_QUERYBUF>` ioctl. Two methods exist to
+:ref:`VIDIOC_QUERYBUF` ioctl. Two methods exist to
 suspend execution of the application until one or more buffers can be
 dequeued. By default ``VIDIOC_DQBUF`` blocks when no buffer is in the
 outgoing queue. When the ``O_NONBLOCK`` flag was given to the
@@ -240,7 +240,7 @@ immediately with an EAGAIN error code when no buffer is available. The
 are always available.
 
 To start and stop capturing or output applications call the
-:ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>` and
+:ref:`VIDIOC_STREAMON` and
 :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` ioctl. Note
 ``VIDIOC_STREAMOFF`` removes all buffers from both queues as a side
 effect. Since there is no notion of doing anything "now" on a
@@ -258,7 +258,7 @@ the :c:func:`mmap()`, :c:func:`munmap()`, :c:func:`select()` and
 
 .. [1]
    One could use one file descriptor and set the buffer type field
-   accordingly when calling :ref:`VIDIOC_QBUF <VIDIOC_QBUF>` etc.,
+   accordingly when calling :ref:`VIDIOC_QBUF` etc.,
    but it makes the :c:func:`select()` function ambiguous. We also
    like the clean approach of one file descriptor per logical stream.
    Video overlay for example is also a logical stream, although the CPU
diff --git a/Documentation/linux_tv/media/v4l/open.rst b/Documentation/linux_tv/media/v4l/open.rst
index 4c34d61a5253..ec6b456e37f0 100644
--- a/Documentation/linux_tv/media/v4l/open.rst
+++ b/Documentation/linux_tv/media/v4l/open.rst
@@ -108,8 +108,8 @@ are comparable to an ALSA audio mixer application. Just opening a V4L2
 device should not change the state of the device. [2]_
 
 Once an application has allocated the memory buffers needed for
-streaming data (by calling the :ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>`
-or :ref:`VIDIOC_CREATE_BUFS <VIDIOC_CREATE_BUFS>` ioctls, or
+streaming data (by calling the :ref:`VIDIOC_REQBUFS`
+or :ref:`VIDIOC_CREATE_BUFS` ioctls, or
 implicitly by calling the :ref:`read() <func-read>` or
 :ref:`write() <func-write>` functions) that application (filehandle)
 becomes the owner of the device. It is no longer allowed to make changes
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-013.rst b/Documentation/linux_tv/media/v4l/pixfmt-013.rst
index b3cb7c48eb74..7584cb2e5702 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-013.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-013.rst
@@ -27,7 +27,7 @@ Compressed Formats
 
        -  'JPEG'
 
-       -  TBD. See also :ref:`VIDIOC_G_JPEGCOMP <VIDIOC_G_JPEGCOMP>`,
+       -  TBD. See also :ref:`VIDIOC_G_JPEGCOMP`,
           :ref:`VIDIOC_S_JPEGCOMP <VIDIOC_G_JPEGCOMP>`.
 
     -  .. _`V4L2-PIX-FMT-MPEG`:
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-packed-rgb.rst b/Documentation/linux_tv/media/v4l/pixfmt-packed-rgb.rst
index 2caf9ccea69a..2b4a6c725d4c 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-packed-rgb.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-packed-rgb.rst
@@ -967,7 +967,7 @@ XBGR) must be used instead of an alpha format.
 
 The XRGB and XBGR formats contain undefined bits (-). Applications,
 devices and drivers must ignore those bits, for both
-:ref:`capture <capture>` and :ref:`output <output>` devices.
+:ref:`capture` and :ref:`output` devices.
 
 **Byte Order..**
 
diff --git a/Documentation/linux_tv/media/v4l/pixfmt.rst b/Documentation/linux_tv/media/v4l/pixfmt.rst
index f2c599aaa502..b0e6a95a7205 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt.rst
@@ -13,7 +13,7 @@ single-planar API, while the latter is used with the multi-planar
 version (see :ref:`planar-apis`). Image formats are negotiated with
 the :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl. (The explanations here
 focus on video capturing and output, for overlay frame buffer formats
-see also :ref:`VIDIOC_G_FBUF <VIDIOC_G_FBUF>`.)
+see also :ref:`VIDIOC_G_FBUF`.)
 
 
 .. toctree::
diff --git a/Documentation/linux_tv/media/v4l/planar-apis.rst b/Documentation/linux_tv/media/v4l/planar-apis.rst
index 017f412a6231..0546210f868f 100644
--- a/Documentation/linux_tv/media/v4l/planar-apis.rst
+++ b/Documentation/linux_tv/media/v4l/planar-apis.rst
@@ -39,12 +39,12 @@ handle multi-planar formats.
 Calls that distinguish between single and multi-planar APIs
 ===========================================================
 
-:ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>`
+:ref:`VIDIOC_QUERYCAP`
     Two additional multi-planar capabilities are added. They can be set
     together with non-multi-planar ones for devices that handle both
     single- and multi-planar formats.
 
-:ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>`,
+:ref:`VIDIOC_G_FMT`,
 :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`,
 :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>`
     New structures for describing multi-planar formats are added: struct
@@ -53,15 +53,15 @@ Calls that distinguish between single and multi-planar APIs
     Drivers may define new multi-planar formats, which have distinct
     FourCC codes from the existing single-planar ones.
 
-:ref:`VIDIOC_QBUF <VIDIOC_QBUF>`,
+:ref:`VIDIOC_QBUF`,
 :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>`,
-:ref:`VIDIOC_QUERYBUF <VIDIOC_QUERYBUF>`
+:ref:`VIDIOC_QUERYBUF`
     A new struct :ref:`v4l2_plane <v4l2-plane>` structure for
     describing planes is added. Arrays of this structure are passed in
     the new ``m.planes`` field of struct
     :ref:`v4l2_buffer <v4l2-buffer>`.
 
-:ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>`
+:ref:`VIDIOC_REQBUFS`
     Will allocate multi-planar buffers as requested.
 
 
diff --git a/Documentation/linux_tv/media/v4l/querycap.rst b/Documentation/linux_tv/media/v4l/querycap.rst
index d8f080a68195..bb905eb82c08 100644
--- a/Documentation/linux_tv/media/v4l/querycap.rst
+++ b/Documentation/linux_tv/media/v4l/querycap.rst
@@ -11,26 +11,26 @@ are equally applicable to all types of devices. Furthermore devices of
 the same type have different capabilities and this specification permits
 the omission of a few complicated and less important parts of the API.
 
-The :ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>` ioctl is available to
+The :ref:`VIDIOC_QUERYCAP` ioctl is available to
 check if the kernel device is compatible with this specification, and to
 query the :ref:`functions <devices>` and :ref:`I/O methods <io>`
 supported by the device.
 
-Starting with kernel version 3.1, :ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>`
+Starting with kernel version 3.1, :ref:`VIDIOC_QUERYCAP`
 will return the V4L2 API version used by the driver, with generally
 matches the Kernel version. There's no need of using
-:ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>` to check if a specific ioctl
+:ref:`VIDIOC_QUERYCAP` to check if a specific ioctl
 is supported, the V4L2 core now returns ENOTTY if a driver doesn't
 provide support for an ioctl.
 
 Other features can be queried by calling the respective ioctl, for
-example :ref:`VIDIOC_ENUMINPUT <VIDIOC_ENUMINPUT>` to learn about the
+example :ref:`VIDIOC_ENUMINPUT` to learn about the
 number, types and names of video connectors on the device. Although
 abstraction is a major objective of this API, the
-:ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>` ioctl also allows driver
+:ref:`VIDIOC_QUERYCAP` ioctl also allows driver
 specific applications to reliably identify the driver.
 
-All V4L2 drivers must support :ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>`.
+All V4L2 drivers must support :ref:`VIDIOC_QUERYCAP`.
 Applications should always call this ioctl after opening the device.
 
 
diff --git a/Documentation/linux_tv/media/v4l/rw.rst b/Documentation/linux_tv/media/v4l/rw.rst
index ad365a6e435d..c840ee0fd14c 100644
--- a/Documentation/linux_tv/media/v4l/rw.rst
+++ b/Documentation/linux_tv/media/v4l/rw.rst
@@ -10,7 +10,7 @@ Input and output devices support the :c:func:`read()` and
 :c:func:`write()` function, respectively, when the
 ``V4L2_CAP_READWRITE`` flag in the ``capabilities`` field of struct
 :ref:`v4l2_capability <v4l2-capability>` returned by the
-:ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>` ioctl is set.
+:ref:`VIDIOC_QUERYCAP` ioctl is set.
 
 Drivers may need the CPU to copy the data, but they may also support DMA
 to or from user memory, so this I/O method is not necessarily less
diff --git a/Documentation/linux_tv/media/v4l/standard.rst b/Documentation/linux_tv/media/v4l/standard.rst
index da0b8101b6cc..3c0f6cb97f13 100644
--- a/Documentation/linux_tv/media/v4l/standard.rst
+++ b/Documentation/linux_tv/media/v4l/standard.rst
@@ -11,8 +11,8 @@ variations of standards. Each video input and output may support another
 set of standards. This set is reported by the ``std`` field of struct
 :ref:`v4l2_input <v4l2-input>` and struct
 :ref:`v4l2_output <v4l2-output>` returned by the
-:ref:`VIDIOC_ENUMINPUT <VIDIOC_ENUMINPUT>` and
-:ref:`VIDIOC_ENUMOUTPUT <VIDIOC_ENUMOUTPUT>` ioctls, respectively.
+:ref:`VIDIOC_ENUMINPUT` and
+:ref:`VIDIOC_ENUMOUTPUT` ioctls, respectively.
 
 V4L2 defines one bit for each analog video standard currently in use
 worldwide, and sets aside bits for driver defined standards, e. g.
@@ -20,7 +20,7 @@ hybrid standards to watch NTSC video tapes on PAL TVs and vice versa.
 Applications can use the predefined bits to select a particular
 standard, although presenting the user a menu of supported standards is
 preferred. To enumerate and query the attributes of the supported
-standards applications use the :ref:`VIDIOC_ENUMSTD <VIDIOC_ENUMSTD>`
+standards applications use the :ref:`VIDIOC_ENUMSTD`
 ioctl.
 
 Many of the defined standards are actually just variations of a few
@@ -36,10 +36,10 @@ Composite input may collapse standards, enumerating "PAL-B/G/H/I",
 "NTSC-M" and "SECAM-D/K". [1]_
 
 To query and select the standard used by the current video input or
-output applications call the :ref:`VIDIOC_G_STD <VIDIOC_G_STD>` and
+output applications call the :ref:`VIDIOC_G_STD` and
 :ref:`VIDIOC_S_STD <VIDIOC_G_STD>` ioctl, respectively. The
 *received* standard can be sensed with the
-:ref:`VIDIOC_QUERYSTD <VIDIOC_QUERYSTD>` ioctl. Note that the
+:ref:`VIDIOC_QUERYSTD` ioctl. Note that the
 parameter of all these ioctls is a pointer to a
 :ref:`v4l2_std_id <v4l2-std-id>` type (a standard set), *not* an
 index into the standard enumeration. Drivers must implement all video
diff --git a/Documentation/linux_tv/media/v4l/streaming-par.rst b/Documentation/linux_tv/media/v4l/streaming-par.rst
index bb8100b6ef87..10420478a3b0 100644
--- a/Documentation/linux_tv/media/v4l/streaming-par.rst
+++ b/Documentation/linux_tv/media/v4l/streaming-par.rst
@@ -23,7 +23,7 @@ internally by a driver in read/write mode. For implications see the
 section discussing the :ref:`read() <func-read>` function.
 
 To get and set the streaming parameters applications call the
-:ref:`VIDIOC_G_PARM <VIDIOC_G_PARM>` and
+:ref:`VIDIOC_G_PARM` and
 :ref:`VIDIOC_S_PARM <VIDIOC_G_PARM>` ioctl, respectively. They take
 a pointer to a struct :ref:`v4l2_streamparm <v4l2-streamparm>`, which
 contains a union holding separate parameters for input and output
diff --git a/Documentation/linux_tv/media/v4l/tuner.rst b/Documentation/linux_tv/media/v4l/tuner.rst
index 15c2e6c373ab..b1be27bd297e 100644
--- a/Documentation/linux_tv/media/v4l/tuner.rst
+++ b/Documentation/linux_tv/media/v4l/tuner.rst
@@ -14,7 +14,7 @@ Video input devices can have one or more tuners demodulating a RF
 signal. Each tuner is associated with one or more video inputs,
 depending on the number of RF connectors on the tuner. The ``type``
 field of the respective struct :ref:`v4l2_input <v4l2-input>`
-returned by the :ref:`VIDIOC_ENUMINPUT <VIDIOC_ENUMINPUT>` ioctl is
+returned by the :ref:`VIDIOC_ENUMINPUT` ioctl is
 set to ``V4L2_INPUT_TYPE_TUNER`` and its ``tuner`` field contains the
 index number of the tuner.
 
@@ -22,7 +22,7 @@ Radio input devices have exactly one tuner with index zero, no video
 inputs.
 
 To query and change tuner properties applications use the
-:ref:`VIDIOC_G_TUNER <VIDIOC_G_TUNER>` and
+:ref:`VIDIOC_G_TUNER` and
 :ref:`VIDIOC_S_TUNER <VIDIOC_G_TUNER>` ioctls, respectively. The
 struct :ref:`v4l2_tuner <v4l2-tuner>` returned by ``VIDIOC_G_TUNER``
 also contains signal status information applicable when the tuner of the
@@ -31,7 +31,7 @@ does not switch the current tuner, when there is more than one at all.
 The tuner is solely determined by the current video input. Drivers must
 support both ioctls and set the ``V4L2_CAP_TUNER`` flag in the struct
 :ref:`v4l2_capability <v4l2-capability>` returned by the
-:ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>` ioctl when the device has
+:ref:`VIDIOC_QUERYCAP` ioctl when the device has
 one or more tuners.
 
 
@@ -44,7 +44,7 @@ set or video recorder. Each modulator is associated with one or more
 video outputs, depending on the number of RF connectors on the
 modulator. The ``type`` field of the respective struct
 :ref:`v4l2_output <v4l2-output>` returned by the
-:ref:`VIDIOC_ENUMOUTPUT <VIDIOC_ENUMOUTPUT>` ioctl is set to
+:ref:`VIDIOC_ENUMOUTPUT` ioctl is set to
 ``V4L2_OUTPUT_TYPE_MODULATOR`` and its ``modulator`` field contains the
 index number of the modulator.
 
@@ -59,14 +59,14 @@ functionality. The reason is a limitation with the
 cannot specify whether the frequency is for a tuner or a modulator.
 
 To query and change modulator properties applications use the
-:ref:`VIDIOC_G_MODULATOR <VIDIOC_G_MODULATOR>` and
+:ref:`VIDIOC_G_MODULATOR` and
 :ref:`VIDIOC_S_MODULATOR <VIDIOC_G_MODULATOR>` ioctl. Note that
 ``VIDIOC_S_MODULATOR`` does not switch the current modulator, when there
 is more than one at all. The modulator is solely determined by the
 current video output. Drivers must support both ioctls and set the
 ``V4L2_CAP_MODULATOR`` flag in the struct
 :ref:`v4l2_capability <v4l2-capability>` returned by the
-:ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>` ioctl when the device has
+:ref:`VIDIOC_QUERYCAP` ioctl when the device has
 one or more modulators.
 
 
@@ -74,7 +74,7 @@ Radio Frequency
 ===============
 
 To get and set the tuner or modulator radio frequency applications use
-the :ref:`VIDIOC_G_FREQUENCY <VIDIOC_G_FREQUENCY>` and
+the :ref:`VIDIOC_G_FREQUENCY` and
 :ref:`VIDIOC_S_FREQUENCY <VIDIOC_G_FREQUENCY>` ioctl which both take
 a pointer to a struct :ref:`v4l2_frequency <v4l2-frequency>`. These
 ioctls are used for TV and radio devices alike. Drivers must support
diff --git a/Documentation/linux_tv/media/v4l/userp.rst b/Documentation/linux_tv/media/v4l/userp.rst
index 5433025d41d9..a5426d10ceb8 100644
--- a/Documentation/linux_tv/media/v4l/userp.rst
+++ b/Documentation/linux_tv/media/v4l/userp.rst
@@ -9,10 +9,10 @@ Streaming I/O (User Pointers)
 Input and output devices support this I/O method when the
 ``V4L2_CAP_STREAMING`` flag in the ``capabilities`` field of struct
 :ref:`v4l2_capability <v4l2-capability>` returned by the
-:ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>` ioctl is set. If the
+:ref:`VIDIOC_QUERYCAP` ioctl is set. If the
 particular user pointer method (not only memory mapping) is supported
 must be determined by calling the
-:ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>` ioctl.
+:ref:`VIDIOC_REQBUFS` ioctl.
 
 This I/O method combines advantages of the read/write and memory mapping
 methods. Buffers (planes) are allocated by the application itself, and
@@ -21,7 +21,7 @@ data are exchanged, these pointers and meta-information are passed in
 struct :ref:`v4l2_buffer <v4l2-buffer>` (or in struct
 :ref:`v4l2_plane <v4l2-plane>` in the multi-planar API case). The
 driver must be switched into user pointer I/O mode by calling the
-:ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>` with the desired buffer type.
+:ref:`VIDIOC_REQBUFS` with the desired buffer type.
 No buffers (planes) are allocated beforehand, consequently they are not
 indexed and cannot be queried like mapped buffers with the
 ``VIDIOC_QUERYBUF`` ioctl.
@@ -45,7 +45,7 @@ indexed and cannot be queried like mapped buffers with the
     }
 
 Buffer (plane) addresses and sizes are passed on the fly with the
-:ref:`VIDIOC_QBUF <VIDIOC_QBUF>` ioctl. Although buffers are commonly
+:ref:`VIDIOC_QBUF` ioctl. Although buffers are commonly
 cycled, applications can pass different addresses and sizes at each
 ``VIDIOC_QBUF`` call. If required by the hardware the driver swaps
 memory pages within physical memory to create a continuous area of
@@ -59,7 +59,7 @@ Filled or displayed buffers are dequeued with the
 memory pages at any time between the completion of the DMA and this
 ioctl. The memory is also unlocked when
 :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` is called,
-:ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>`, or when the device is closed.
+:ref:`VIDIOC_REQBUFS`, or when the device is closed.
 Applications must take care not to free buffers without dequeuing. For
 once, the buffers remain locked until further, wasting physical memory.
 Second the driver will not be notified when the memory is returned to
@@ -82,7 +82,7 @@ immediately with an EAGAIN error code when no buffer is available. The
 are always available.
 
 To start and stop capturing or output applications call the
-:ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>` and
+:ref:`VIDIOC_STREAMON` and
 :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` ioctl. Note
 ``VIDIOC_STREAMOFF`` removes all buffers from both queues and unlocks
 all buffers as a side effect. Since there is no notion of doing anything
diff --git a/Documentation/linux_tv/media/v4l/video.rst b/Documentation/linux_tv/media/v4l/video.rst
index e4e543b56989..9f2dc4ee4fcd 100644
--- a/Documentation/linux_tv/media/v4l/video.rst
+++ b/Documentation/linux_tv/media/v4l/video.rst
@@ -14,14 +14,14 @@ Radio devices have no video inputs or outputs.
 
 To learn about the number and attributes of the available inputs and
 outputs applications can enumerate them with the
-:ref:`VIDIOC_ENUMINPUT <VIDIOC_ENUMINPUT>` and
-:ref:`VIDIOC_ENUMOUTPUT <VIDIOC_ENUMOUTPUT>` ioctl, respectively. The
+:ref:`VIDIOC_ENUMINPUT` and
+:ref:`VIDIOC_ENUMOUTPUT` ioctl, respectively. The
 struct :ref:`v4l2_input <v4l2-input>` returned by the
-:ref:`VIDIOC_ENUMINPUT <VIDIOC_ENUMINPUT>` ioctl also contains signal
+:ref:`VIDIOC_ENUMINPUT` ioctl also contains signal
 :status information applicable when the current video input is queried.
 
-The :ref:`VIDIOC_G_INPUT <VIDIOC_G_INPUT>` and
-:ref:`VIDIOC_G_OUTPUT <VIDIOC_G_OUTPUT>` ioctls return the index of
+The :ref:`VIDIOC_G_INPUT` and
+:ref:`VIDIOC_G_OUTPUT` ioctls return the index of
 the current video input or output. To select a different input or output
 applications call the :ref:`VIDIOC_S_INPUT <VIDIOC_G_INPUT>` and
 :ref:`VIDIOC_S_OUTPUT <VIDIOC_G_OUTPUT>` ioctls. Drivers must
diff --git a/Documentation/linux_tv/media/v4l/vidioc-create-bufs.rst b/Documentation/linux_tv/media/v4l/vidioc-create-bufs.rst
index 9c2a011f389c..9220bcea1259 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-create-bufs.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-create-bufs.rst
@@ -34,7 +34,7 @@ Description
 This ioctl is used to create buffers for :ref:`memory mapped <mmap>`
 or :ref:`user pointer <userp>` or :ref:`DMA buffer <dmabuf>` I/O. It
 can be used as an alternative or in addition to the
-:ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>` ioctl, when a tighter control
+:ref:`VIDIOC_REQBUFS` ioctl, when a tighter control
 over buffers is required. This ioctl can be called multiple times to
 create buffers of different sizes.
 
@@ -48,7 +48,7 @@ The ``format`` field specifies the image format that the buffers must be
 able to handle. The application has to fill in this struct
 :ref:`v4l2_format <v4l2-format>`. Usually this will be done using the
 :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` or
-:ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` ioctls to ensure that the
+:ref:`VIDIOC_G_FMT` ioctls to ensure that the
 requested format is supported by the driver. Based on the format's
 ``type`` field the requested buffer size (for single-planar) or plane
 sizes (for multi-planar formats) will be used for the allocated buffers.
diff --git a/Documentation/linux_tv/media/v4l/vidioc-dbg-g-chip-info.rst b/Documentation/linux_tv/media/v4l/vidioc-dbg-g-chip-info.rst
index 0a92e2550ce0..12c2e5df48ac 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-dbg-g-chip-info.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-dbg-g-chip-info.rst
@@ -33,7 +33,7 @@ Description
 
     **Note**
 
-    This is an :ref:`experimental <experimental>` interface and may
+    This is an :ref:`experimental` interface and may
     change in the future.
 
 For driver debugging purposes this ioctl allows test applications to
diff --git a/Documentation/linux_tv/media/v4l/vidioc-dbg-g-register.rst b/Documentation/linux_tv/media/v4l/vidioc-dbg-g-register.rst
index 1b86abcc44c7..b50c1be72f15 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-dbg-g-register.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-dbg-g-register.rst
@@ -36,7 +36,7 @@ Description
 
     **Note**
 
-    This is an :ref:`experimental <experimental>` interface and may
+    This is an :ref:`experimental` interface and may
     change in the future.
 
 For driver debugging purposes these ioctls allow test applications to
@@ -65,14 +65,14 @@ When ``match.type`` is ``V4L2_CHIP_MATCH_BRIDGE``, ``match.addr``
 selects the nth non-sub-device chip on the TV card. The number zero
 always selects the host chip, e. g. the chip connected to the PCI or USB
 bus. You can find out which chips are present with the
-:ref:`VIDIOC_DBG_G_CHIP_INFO <VIDIOC_DBG_G_CHIP_INFO>` ioctl.
+:ref:`VIDIOC_DBG_G_CHIP_INFO` ioctl.
 
 When ``match.type`` is ``V4L2_CHIP_MATCH_SUBDEV``, ``match.addr``
 selects the nth sub-device.
 
 These ioctls are optional, not all drivers may support them. However
 when a driver supports these ioctls it must also support
-:ref:`VIDIOC_DBG_G_CHIP_INFO <VIDIOC_DBG_G_CHIP_INFO>`. Conversely
+:ref:`VIDIOC_DBG_G_CHIP_INFO`. Conversely
 it may support ``VIDIOC_DBG_G_CHIP_INFO`` but not these ioctls.
 
 ``VIDIOC_DBG_G_REGISTER`` and ``VIDIOC_DBG_S_REGISTER`` were introduced
diff --git a/Documentation/linux_tv/media/v4l/vidioc-decoder-cmd.rst b/Documentation/linux_tv/media/v4l/vidioc-decoder-cmd.rst
index ec9dfed09f76..a56c5fc1ed6f 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-decoder-cmd.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-decoder-cmd.rst
@@ -43,7 +43,7 @@ this structure.
 The ``cmd`` field must contain the command code. Some commands use the
 ``flags`` field for additional information.
 
-A :c:func:`write()`() or :ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>`
+A :c:func:`write()`() or :ref:`VIDIOC_STREAMON`
 call sends an implicit START command to the decoder if it has not been
 started yet.
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-dqevent.rst b/Documentation/linux_tv/media/v4l/vidioc-dqevent.rst
index 45320997344d..9e41fc818b90 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-dqevent.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-dqevent.rst
@@ -363,7 +363,7 @@ call.
 
        -  The 32-bit value of the control for 32-bit control types. This is
           0 for string controls since the value of a string cannot be passed
-          using :ref:`VIDIOC_DQEVENT <VIDIOC_DQEVENT>`.
+          using :ref:`VIDIOC_DQEVENT`.
 
     -  .. row 5
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-encoder-cmd.rst b/Documentation/linux_tv/media/v4l/vidioc-encoder-cmd.rst
index ffa363eeaa36..43c7a3928e7b 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-encoder-cmd.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-encoder-cmd.rst
@@ -48,7 +48,7 @@ currently only used by the STOP command and contains one bit: If the
 until the end of the current *Group Of Pictures*, otherwise it will stop
 immediately.
 
-A :c:func:`read()`() or :ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>`
+A :c:func:`read()`() or :ref:`VIDIOC_STREAMON`
 call sends an implicit START command to the encoder if it has not been
 started yet. After a STOP command, :c:func:`read()`() calls will read
 the remaining data buffered by the driver. When the buffer is empty,
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enum-dv-timings.rst b/Documentation/linux_tv/media/v4l/vidioc-enum-dv-timings.rst
index 5b8f17422fdb..07462519cbf4 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enum-dv-timings.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enum-dv-timings.rst
@@ -35,7 +35,7 @@ Description
 While some DV receivers or transmitters support a wide range of timings,
 others support only a limited number of timings. With this ioctl
 applications can enumerate a list of known supported timings. Call
-:ref:`VIDIOC_DV_TIMINGS_CAP <VIDIOC_DV_TIMINGS_CAP>` to check if it
+:ref:`VIDIOC_DV_TIMINGS_CAP` to check if it
 also supports other standards or even custom timings that are not in
 this list.
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enum-frameintervals.rst b/Documentation/linux_tv/media/v4l/vidioc-enum-frameintervals.rst
index 2c69866c8d9e..a9182898b6dc 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enum-frameintervals.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enum-frameintervals.rst
@@ -38,8 +38,8 @@ This ioctl allows applications to enumerate all frame intervals that the
 device supports for the given pixel format and frame size.
 
 The supported pixel formats and frame sizes can be obtained by using the
-:ref:`VIDIOC_ENUM_FMT <VIDIOC_ENUM_FMT>` and
-:ref:`VIDIOC_ENUM_FRAMESIZES <VIDIOC_ENUM_FRAMESIZES>` functions.
+:ref:`VIDIOC_ENUM_FMT` and
+:ref:`VIDIOC_ENUM_FRAMESIZES` functions.
 
 The return value and the content of the ``v4l2_frmivalenum.type`` field
 depend on the type of frame intervals the device supports. Here are the
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enum-framesizes.rst b/Documentation/linux_tv/media/v4l/vidioc-enum-framesizes.rst
index 9b763ca9d0d8..5e171dbc975c 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enum-framesizes.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enum-framesizes.rst
@@ -39,7 +39,7 @@ and height in pixels) that the device supports for the given pixel
 format.
 
 The supported pixel formats can be obtained by using the
-:ref:`VIDIOC_ENUM_FMT <VIDIOC_ENUM_FMT>` function.
+:ref:`VIDIOC_ENUM_FMT` function.
 
 The return value and the content of the ``v4l2_frmsizeenum.type`` field
 depend on the type of frame sizes the device supports. Here are the
diff --git a/Documentation/linux_tv/media/v4l/vidioc-expbuf.rst b/Documentation/linux_tv/media/v4l/vidioc-expbuf.rst
index a389cbc75970..e71925f3f13e 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-expbuf.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-expbuf.rst
@@ -35,7 +35,7 @@ This ioctl is an extension to the :ref:`memory mapping <mmap>` I/O
 method, therefore it is available only for ``V4L2_MEMORY_MMAP`` buffers.
 It can be used to export a buffer as a DMABUF file at any time after
 buffers have been allocated with the
-:ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>` ioctl.
+:ref:`VIDIOC_REQBUFS` ioctl.
 
 To export a buffer, applications fill struct
 :ref:`v4l2_exportbuffer <v4l2-exportbuffer>`. The ``type`` field is
@@ -43,7 +43,7 @@ set to the same buffer type as was previously used with struct
 :ref:`v4l2_requestbuffers <v4l2-requestbuffers>` ``type``.
 Applications must also set the ``index`` field. Valid index numbers
 range from zero to the number of buffers allocated with
-:ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>` (struct
+:ref:`VIDIOC_REQBUFS` (struct
 :ref:`v4l2_requestbuffers <v4l2-requestbuffers>` ``count``) minus
 one. For the multi-planar API, applications set the ``plane`` field to
 the index of the plane to be exported. Valid planes range from zero to
@@ -142,8 +142,8 @@ Examples
        -  Number of the buffer, set by the application. This field is only
           used for :ref:`memory mapping <mmap>` I/O and can range from
           zero to the number of buffers allocated with the
-          :ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>` and/or
-          :ref:`VIDIOC_CREATE_BUFS <VIDIOC_CREATE_BUFS>` ioctls.
+          :ref:`VIDIOC_REQBUFS` and/or
+          :ref:`VIDIOC_CREATE_BUFS` ioctls.
 
     -  .. row 3
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-crop.rst b/Documentation/linux_tv/media/v4l/vidioc-g-crop.rst
index 457a6cc6b63e..e66f8c213535 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-crop.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-crop.rst
@@ -66,7 +66,7 @@ vertical scaling factor.
 Finally the driver programs the hardware with the actual cropping and
 image parameters. ``VIDIOC_S_CROP`` is a write-only ioctl, it does not
 return the actual parameters. To query them applications must call
-``VIDIOC_G_CROP`` and :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>`. When the
+``VIDIOC_G_CROP`` and :ref:`VIDIOC_G_FMT`. When the
 parameters are unsuitable the application may modify the cropping or
 image parameters and repeat the cycle until satisfactory parameters have
 been negotiated.
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst b/Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst
index 6b2b157ba9c7..2c2677a76462 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst
@@ -48,7 +48,7 @@ actual new value. If the ``value`` is inappropriate for the control
 EINVAL error code is returned as well.
 
 These ioctls work only with user controls. For other control classes the
-:ref:`VIDIOC_G_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>`,
+:ref:`VIDIOC_G_EXT_CTRLS`,
 :ref:`VIDIOC_S_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` or
 :ref:`VIDIOC_TRY_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` must be used.
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-dv-timings.rst b/Documentation/linux_tv/media/v4l/vidioc-g-dv-timings.rst
index 84f9db487822..8a7fa1c0facf 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-dv-timings.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-dv-timings.rst
@@ -47,7 +47,7 @@ values are not correct, the driver returns EINVAL error code.
 The ``linux/v4l2-dv-timings.h`` header can be used to get the timings of
 the formats in the :ref:`cea861` and :ref:`vesadmt` standards. If
 the current input or output does not support DV timings (e.g. if
-:ref:`VIDIOC_ENUMINPUT <VIDIOC_ENUMINPUT>` does not set the
+:ref:`VIDIOC_ENUMINPUT` does not set the
 ``V4L2_IN_CAP_DV_TIMINGS`` flag), then ENODATA error code is returned.
 
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-edid.rst b/Documentation/linux_tv/media/v4l/vidioc-g-edid.rst
index 26bbf060aa51..0bd8f1ba84d2 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-edid.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-edid.rst
@@ -44,8 +44,8 @@ with subdevice nodes (/dev/v4l-subdevX) or with video nodes
 
 When used with video nodes the ``pad`` field represents the input (for
 video capture devices) or output (for video output devices) index as is
-returned by :ref:`VIDIOC_ENUMINPUT <VIDIOC_ENUMINPUT>` and
-:ref:`VIDIOC_ENUMOUTPUT <VIDIOC_ENUMOUTPUT>` respectively. When used
+returned by :ref:`VIDIOC_ENUMINPUT` and
+:ref:`VIDIOC_ENUMOUTPUT` respectively. When used
 with subdevice nodes the ``pad`` field represents the input or output
 pad of the subdevice. If there is no EDID support for the given ``pad``
 value, then the EINVAL error code will be returned.
@@ -105,8 +105,8 @@ EDID is no longer available.
 
        -  Pad for which to get/set the EDID blocks. When used with a video
           device node the pad represents the input or output index as
-          returned by :ref:`VIDIOC_ENUMINPUT <VIDIOC_ENUMINPUT>` and
-          :ref:`VIDIOC_ENUMOUTPUT <VIDIOC_ENUMOUTPUT>` respectively.
+          returned by :ref:`VIDIOC_ENUMINPUT` and
+          :ref:`VIDIOC_ENUMOUTPUT` respectively.
 
     -  .. row 2
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-ext-ctrls.rst b/Documentation/linux_tv/media/v4l/vidioc-g-ext-ctrls.rst
index f800458d9dfe..cebaa6ea1ba9 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-ext-ctrls.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-ext-ctrls.rst
@@ -58,7 +58,7 @@ set ``size`` to a valid value and return an ENOSPC error code. You
 should re-allocate the memory to this new size and try again. For the
 string type it is possible that the same issue occurs again if the
 string has grown in the meantime. It is recommended to call
-:ref:`VIDIOC_QUERYCTRL <VIDIOC_QUERYCTRL>` first and use
+:ref:`VIDIOC_QUERYCTRL` first and use
 ``maximum``\ +1 as the new ``size`` value. It is guaranteed that that is
 sufficient memory.
 
@@ -367,7 +367,7 @@ still cause this situation.
        -  The class containing user controls. These controls are described
           in :ref:`control`. All controls that can be set using the
           :ref:`VIDIOC_S_CTRL <VIDIOC_G_CTRL>` and
-          :ref:`VIDIOC_G_CTRL <VIDIOC_G_CTRL>` ioctl belong to this
+          :ref:`VIDIOC_G_CTRL` ioctl belong to this
           class.
 
     -  .. row 2
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-fbuf.rst b/Documentation/linux_tv/media/v4l/vidioc-g-fbuf.rst
index f4703b3449b3..0d9b6972bc44 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-fbuf.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-fbuf.rst
@@ -39,7 +39,7 @@ to get and set the framebuffer parameters for a
 :ref:`Video Overlay <overlay>` or :ref:`Video Output Overlay <osd>`
 (OSD). The type of overlay is implied by the device type (capture or
 output device) and can be determined with the
-:ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>` ioctl. One ``/dev/videoN``
+:ref:`VIDIOC_QUERYCAP` ioctl. One ``/dev/videoN``
 device must not support both kinds of overlay.
 
 The V4L2 API distinguishes destructive and non-destructive overlays. A
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-input.rst b/Documentation/linux_tv/media/v4l/vidioc-g-input.rst
index 62990976ff9b..d0abf6231b7d 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-input.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-input.rst
@@ -47,7 +47,7 @@ applications must select an input before querying or negotiating any
 other parameters.
 
 Information about video inputs is available using the
-:ref:`VIDIOC_ENUMINPUT <VIDIOC_ENUMINPUT>` ioctl.
+:ref:`VIDIOC_ENUMINPUT` ioctl.
 
 
 Return Value
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-output.rst b/Documentation/linux_tv/media/v4l/vidioc-g-output.rst
index 3b9ea56e3b9e..a38d6a118cf4 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-output.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-output.rst
@@ -48,7 +48,7 @@ effects applications must select an output before querying or
 negotiating any other parameters.
 
 Information about video outputs is available using the
-:ref:`VIDIOC_ENUMOUTPUT <VIDIOC_ENUMOUTPUT>` ioctl.
+:ref:`VIDIOC_ENUMOUTPUT` ioctl.
 
 
 Return Value
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-std.rst b/Documentation/linux_tv/media/v4l/vidioc-g-std.rst
index 9cbf2d2995c6..fa9da29e0657 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-std.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-std.rst
@@ -48,7 +48,7 @@ no flags are given or the current input does not support the requested
 standard the driver returns an EINVAL error code. When the standard set
 is ambiguous drivers may return EINVAL or choose any of the requested
 standards. If the current input or output does not support standard
-video timings (e.g. if :ref:`VIDIOC_ENUMINPUT <VIDIOC_ENUMINPUT>`
+video timings (e.g. if :ref:`VIDIOC_ENUMINPUT`
 does not set the ``V4L2_IN_CAP_STD`` flag), then ENODATA error code is
 returned.
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-tuner.rst b/Documentation/linux_tv/media/v4l/vidioc-g-tuner.rst
index 1ad5107a0ad5..1e01010fd2e2 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-tuner.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-tuner.rst
@@ -215,7 +215,7 @@ To change the radio frequency the
 
           The selected audio mode, see :ref:`tuner-audmode` for valid
           values. The audio mode does not affect audio subprogram detection,
-          and like a :ref:`control <control>` it does not automatically
+          and like a :ref:`control` it does not automatically
           change unless the requested mode is invalid or unsupported. See
           :ref:`tuner-matrix` for possible results when the selected and
           received audio programs do not match.
@@ -323,7 +323,7 @@ To change the radio frequency the
           determined from the frequency band.) The set of supported video
           standards is available from the struct
           :ref:`v4l2_input <v4l2-input>` pointing to this tuner, see the
-          description of ioctl :ref:`VIDIOC_ENUMINPUT <VIDIOC_ENUMINPUT>`
+          description of ioctl :ref:`VIDIOC_ENUMINPUT`
           for details. Only ``V4L2_TUNER_ANALOG_TV`` tuners can have this
           capability.
 
@@ -425,7 +425,7 @@ To change the radio frequency the
 
        -  0x0400
 
-       -  The :ref:`VIDIOC_ENUM_FREQ_BANDS <VIDIOC_ENUM_FREQ_BANDS>`
+       -  The :ref:`VIDIOC_ENUM_FREQ_BANDS`
           ioctl can be used to enumerate the available frequency bands.
 
     -  .. row 13
@@ -436,7 +436,7 @@ To change the radio frequency the
 
        -  The range to search when using the hardware seek functionality is
           programmable, see
-          :ref:`VIDIOC_S_HW_FREQ_SEEK <VIDIOC_S_HW_FREQ_SEEK>` for
+          :ref:`VIDIOC_S_HW_FREQ_SEEK` for
           details.
 
     -  .. row 14
diff --git a/Documentation/linux_tv/media/v4l/vidioc-overlay.rst b/Documentation/linux_tv/media/v4l/vidioc-overlay.rst
index e0373a9d6f14..fe9084147b93 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-overlay.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-overlay.rst
@@ -36,7 +36,7 @@ Applications call ``VIDIOC_OVERLAY`` to start or stop the overlay. It
 takes a pointer to an integer which must be set to zero by the
 application to stop overlay, to one to start.
 
-Drivers do not support :ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>` or
+Drivers do not support :ref:`VIDIOC_STREAMON` or
 :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` with
 ``V4L2_BUF_TYPE_VIDEO_OVERLAY``.
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-qbuf.rst b/Documentation/linux_tv/media/v4l/vidioc-qbuf.rst
index 045fa53e0417..57a0bc470f36 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-qbuf.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-qbuf.rst
@@ -42,10 +42,10 @@ previously used with struct :ref:`v4l2_format <v4l2-format>` ``type``
 and struct :ref:`v4l2_requestbuffers <v4l2-requestbuffers>` ``type``.
 Applications must also set the ``index`` field. Valid index numbers
 range from zero to the number of buffers allocated with
-:ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>` (struct
+:ref:`VIDIOC_REQBUFS` (struct
 :ref:`v4l2_requestbuffers <v4l2-requestbuffers>` ``count``) minus
 one. The contents of the struct :c:type:`struct v4l2_buffer` returned
-by a :ref:`VIDIOC_QUERYBUF <VIDIOC_QUERYBUF>` ioctl will do as well.
+by a :ref:`VIDIOC_QUERYBUF` ioctl will do as well.
 When the buffer is intended for output (``type`` is
 ``V4L2_BUF_TYPE_VIDEO_OUTPUT``, ``V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE``,
 or ``V4L2_BUF_TYPE_VBI_OUTPUT``) applications must also initialize the
@@ -76,7 +76,7 @@ the driver sets the ``V4L2_BUF_FLAG_QUEUED`` flag and clears the
 memory pages of the buffer in physical memory, they cannot be swapped
 out to disk. Buffers remain locked until dequeued, until the
 :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` or
-:ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>` ioctl is called, or until the
+:ref:`VIDIOC_REQBUFS` ioctl is called, or until the
 device is closed.
 
 To enqueue a :ref:`DMABUF <dmabuf>` buffer applications set the
@@ -92,7 +92,7 @@ buffer. Locking a buffer means passing it to a driver for a hardware
 access (usually DMA). If an application accesses (reads/writes) a locked
 buffer then the result is undefined. Buffers remain locked until
 dequeued, until the :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` or
-:ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>` ioctl is called, or until the
+:ref:`VIDIOC_REQBUFS` ioctl is called, or until the
 device is closed.
 
 Applications call the ``VIDIOC_DQBUF`` ioctl to dequeue a filled
diff --git a/Documentation/linux_tv/media/v4l/vidioc-query-dv-timings.rst b/Documentation/linux_tv/media/v4l/vidioc-query-dv-timings.rst
index 88aedbd1fcae..ba78f7e5bbe8 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-query-dv-timings.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-query-dv-timings.rst
@@ -56,7 +56,7 @@ the receiver could lock to the signal, but the format is unsupported
 (e.g. because the pixelclock is out of range of the hardware
 capabilities), then the driver fills in whatever timings it could find
 and returns ERANGE. In that case the application can call
-:ref:`VIDIOC_DV_TIMINGS_CAP <VIDIOC_DV_TIMINGS_CAP>` to compare the
+:ref:`VIDIOC_DV_TIMINGS_CAP` to compare the
 found timings with the hardware's capabilities in order to give more
 precise feedback to the user.
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-querybuf.rst b/Documentation/linux_tv/media/v4l/vidioc-querybuf.rst
index baa3ad6591c7..744cd9da45a3 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-querybuf.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-querybuf.rst
@@ -33,7 +33,7 @@ Description
 
 This ioctl is part of the :ref:`streaming <mmap>` I/O method. It can
 be used to query the status of a buffer at any time after buffers have
-been allocated with the :ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>` ioctl.
+been allocated with the :ref:`VIDIOC_REQBUFS` ioctl.
 
 Applications set the ``type`` field of a struct
 :ref:`v4l2_buffer <v4l2-buffer>` to the same buffer type as was
@@ -41,7 +41,7 @@ previously used with struct :ref:`v4l2_format <v4l2-format>` ``type``
 and struct :ref:`v4l2_requestbuffers <v4l2-requestbuffers>` ``type``,
 and the ``index`` field. Valid index numbers range from zero to the
 number of buffers allocated with
-:ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>` (struct
+:ref:`VIDIOC_REQBUFS` (struct
 :ref:`v4l2_requestbuffers <v4l2-requestbuffers>` ``count``) minus
 one. The ``reserved`` and ``reserved2`` fields must be set to 0. When
 using the :ref:`multi-planar API <planar-apis>`, the ``m.planes``
diff --git a/Documentation/linux_tv/media/v4l/vidioc-querycap.rst b/Documentation/linux_tv/media/v4l/vidioc-querycap.rst
index 3032a9ee1c6b..74589501b95d 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-querycap.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-querycap.rst
@@ -308,7 +308,7 @@ specification the ioctl returns an EINVAL error code.
        -  0x00000400
 
        -  The device supports the
-          :ref:`VIDIOC_S_HW_FREQ_SEEK <VIDIOC_S_HW_FREQ_SEEK>` ioctl
+          :ref:`VIDIOC_S_HW_FREQ_SEEK` ioctl
           for hardware frequency seeking.
 
     -  .. row 15
diff --git a/Documentation/linux_tv/media/v4l/vidioc-queryctrl.rst b/Documentation/linux_tv/media/v4l/vidioc-queryctrl.rst
index 7d38a51c4f73..2b11efc3d257 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-queryctrl.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-queryctrl.rst
@@ -569,7 +569,7 @@ See also the examples in :ref:`control`.
           :ref:`VIDIOC_S_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` you need to
           set the ``size`` field of struct
           :ref:`v4l2_ext_control <v4l2-ext-control>` to 9. For
-          :ref:`VIDIOC_G_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` you can set
+          :ref:`VIDIOC_G_EXT_CTRLS` you can set
           the ``size`` field to ``maximum`` + 1. Which character encoding is
           used will depend on the string control itself and should be part
           of the control documentation.
diff --git a/Documentation/linux_tv/media/v4l/vidioc-s-hw-freq-seek.rst b/Documentation/linux_tv/media/v4l/vidioc-s-hw-freq-seek.rst
index 19c2e0afd7de..cd59ba9ab1b0 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-s-hw-freq-seek.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-s-hw-freq-seek.rst
@@ -43,10 +43,10 @@ to tell the driver to search a specific band. If the struct
 :ref:`v4l2_tuner <v4l2-tuner>` ``capability`` field has the
 ``V4L2_TUNER_CAP_HWSEEK_PROG_LIM`` flag set, these values must fall
 within one of the bands returned by
-:ref:`VIDIOC_ENUM_FREQ_BANDS <VIDIOC_ENUM_FREQ_BANDS>`. If the
+:ref:`VIDIOC_ENUM_FREQ_BANDS`. If the
 ``V4L2_TUNER_CAP_HWSEEK_PROG_LIM`` flag is not set, then these values
 must exactly match those of one of the bands returned by
-:ref:`VIDIOC_ENUM_FREQ_BANDS <VIDIOC_ENUM_FREQ_BANDS>`. If the
+:ref:`VIDIOC_ENUM_FREQ_BANDS`. If the
 current frequency of the tuner does not fall within the selected band it
 will be clamped to fit in the band before the seek is started.
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-streamon.rst b/Documentation/linux_tv/media/v4l/vidioc-streamon.rst
index 349204d81334..7663339d30be 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-streamon.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-streamon.rst
@@ -55,14 +55,14 @@ and it removes all buffers from the incoming and outgoing queues. That
 means all images captured but not dequeued yet will be lost, likewise
 all images enqueued for output but not transmitted yet. I/O returns to
 the same state as after calling
-:ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>` and can be restarted
+:ref:`VIDIOC_REQBUFS` and can be restarted
 accordingly.
 
-If buffers have been queued with :ref:`VIDIOC_QBUF <VIDIOC_QBUF>` and
+If buffers have been queued with :ref:`VIDIOC_QBUF` and
 ``VIDIOC_STREAMOFF`` is called without ever having called
 ``VIDIOC_STREAMON``, then those queued buffers will also be removed from
 the incoming queue and all are returned to the same state as after
-calling :ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>` and can be restarted
+calling :ref:`VIDIOC_REQBUFS` and can be restarted
 accordingly.
 
 Both ioctls take a pointer to an integer, the desired buffer or stream
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-interval.rst b/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-interval.rst
index d9f27e32eb60..ab1368786038 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-interval.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-interval.rst
@@ -52,7 +52,7 @@ one until EINVAL is returned.
 
 Available frame intervals may depend on the current 'try' formats at
 other pads of the sub-device, as well as on the current active links.
-See :ref:`VIDIOC_SUBDEV_G_FMT <VIDIOC_SUBDEV_G_FMT>` for more
+See :ref:`VIDIOC_SUBDEV_G_FMT` for more
 information about the try formats.
 
 Sub-devices that support the frame interval enumeration ioctl should
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-size.rst b/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-size.rst
index 49be2eefaa57..e08de6040757 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-size.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-size.rst
@@ -34,7 +34,7 @@ Description
 This ioctl allows applications to enumerate all frame sizes supported by
 a sub-device on the given pad for the given media bus format. Supported
 formats can be retrieved with the
-:ref:`VIDIOC_SUBDEV_ENUM_MBUS_CODE <VIDIOC_SUBDEV_ENUM_MBUS_CODE>`
+:ref:`VIDIOC_SUBDEV_ENUM_MBUS_CODE`
 ioctl.
 
 To enumerate frame sizes applications initialize the ``pad``, ``which``
@@ -58,7 +58,7 @@ sub-device for an exact supported frame size.
 Available frame sizes may depend on the current 'try' formats at other
 pads of the sub-device, as well as on the current active links and the
 current values of V4L2 controls. See
-:ref:`VIDIOC_SUBDEV_G_FMT <VIDIOC_SUBDEV_G_FMT>` for more
+:ref:`VIDIOC_SUBDEV_G_FMT` for more
 information about try formats.
 
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-mbus-code.rst b/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-mbus-code.rst
index a9b0baba2633..0daf410c1546 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-mbus-code.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-mbus-code.rst
@@ -43,7 +43,7 @@ one until EINVAL is returned.
 
 Available media bus formats may depend on the current 'try' formats at
 other pads of the sub-device, as well as on the current active links.
-See :ref:`VIDIOC_SUBDEV_G_FMT <VIDIOC_SUBDEV_G_FMT>` for more
+See :ref:`VIDIOC_SUBDEV_G_FMT` for more
 information about the try formats.
 
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subdev-g-crop.rst b/Documentation/linux_tv/media/v4l/vidioc-subdev-g-crop.rst
index bef416cfe46c..6fb1ea143f9e 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-subdev-g-crop.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-subdev-g-crop.rst
@@ -36,7 +36,7 @@ Description
 
     **Note**
 
-    This is an :ref:`obsolete <obsolete>` interface and may be removed
+    This is an :ref:`obsolete` interface and may be removed
     in the future. It is superseded by
     :ref:`the selection API <VIDIOC_SUBDEV_G_SELECTION>`.
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subscribe-event.rst b/Documentation/linux_tv/media/v4l/vidioc-subscribe-event.rst
index 8d0e346461e9..182353f544eb 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-subscribe-event.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-subscribe-event.rst
@@ -33,7 +33,7 @@ Description
 ===========
 
 Subscribe or unsubscribe V4L2 event. Subscribed events are dequeued by
-using the :ref:`VIDIOC_DQEVENT <VIDIOC_DQEVENT>` ioctl.
+using the :ref:`VIDIOC_DQEVENT` ioctl.
 
 
 .. _v4l2-event-subscription:
-- 
2.7.4


