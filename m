Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41917 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbcGESk1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jul 2016 14:40:27 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 1/8] doc-rst: linux_tv: split DVB function call documentation
Date: Tue,  5 Jul 2016 14:59:17 -0300
Message-Id: <47d23e363fb034f32551f5fe85add77ceba98d3b.1467740686.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=true
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just like V4L, split the DVB function calls into one file per
system call. This is a requirement for the man pages creator
on Sphinx to work, and makes the document easier to maintain.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../media/dvb/audio-bilingual-channel-select.rst   |   59 +
 .../linux_tv/media/dvb/audio-channel-select.rst    |   58 +
 .../linux_tv/media/dvb/audio-clear-buffer.rst      |   49 +
 .../linux_tv/media/dvb/audio-continue.rst          |   49 +
 Documentation/linux_tv/media/dvb/audio-fclose.rst  |   52 +
 Documentation/linux_tv/media/dvb/audio-fopen.rst   |  102 +
 Documentation/linux_tv/media/dvb/audio-fwrite.rst  |   80 +
 .../linux_tv/media/dvb/audio-get-capabilities.rst  |   55 +
 Documentation/linux_tv/media/dvb/audio-get-pts.rst |   64 +
 .../linux_tv/media/dvb/audio-get-status.rst        |   55 +
 Documentation/linux_tv/media/dvb/audio-pause.rst   |   50 +
 Documentation/linux_tv/media/dvb/audio-play.rst    |   49 +
 .../linux_tv/media/dvb/audio-select-source.rst     |   57 +
 .../linux_tv/media/dvb/audio-set-attributes.rst    |   69 +
 .../linux_tv/media/dvb/audio-set-av-sync.rst       |   65 +
 .../linux_tv/media/dvb/audio-set-bypass-mode.rst   |   69 +
 .../linux_tv/media/dvb/audio-set-ext-id.rst        |   69 +
 Documentation/linux_tv/media/dvb/audio-set-id.rst  |   60 +
 .../linux_tv/media/dvb/audio-set-karaoke.rst       |   65 +
 .../linux_tv/media/dvb/audio-set-mixer.rst         |   54 +
 .../linux_tv/media/dvb/audio-set-mute.rst          |   69 +
 .../linux_tv/media/dvb/audio-set-streamtype.rst    |   70 +
 Documentation/linux_tv/media/dvb/audio-stop.rst    |   49 +
 .../linux_tv/media/dvb/audio_function_calls.rst    | 1399 +-------------
 Documentation/linux_tv/media/dvb/ca-fclose.rst     |   52 +
 Documentation/linux_tv/media/dvb/ca-fopen.rst      |  107 ++
 Documentation/linux_tv/media/dvb/ca-get-cap.rst    |   54 +
 .../linux_tv/media/dvb/ca-get-descr-info.rst       |   54 +
 Documentation/linux_tv/media/dvb/ca-get-msg.rst    |   54 +
 .../linux_tv/media/dvb/ca-get-slot-info.rst        |   54 +
 Documentation/linux_tv/media/dvb/ca-reset.rst      |   48 +
 Documentation/linux_tv/media/dvb/ca-send-msg.rst   |   54 +
 Documentation/linux_tv/media/dvb/ca-set-descr.rst  |   54 +
 Documentation/linux_tv/media/dvb/ca-set-pid.rst    |   52 +
 .../linux_tv/media/dvb/ca_function_calls.rst       |  577 +-----
 Documentation/linux_tv/media/dvb/dmx-add-pid.rst   |   56 +
 Documentation/linux_tv/media/dvb/dmx-fclose.rst    |   53 +
 Documentation/linux_tv/media/dvb/dmx-fopen.rst     |  106 ++
 Documentation/linux_tv/media/dvb/dmx-fread.rst     |  106 ++
 Documentation/linux_tv/media/dvb/dmx-fwrite.rst    |   87 +
 Documentation/linux_tv/media/dvb/dmx-get-caps.rst  |   54 +
 Documentation/linux_tv/media/dvb/dmx-get-event.rst |   72 +
 .../linux_tv/media/dvb/dmx-get-pes-pids.rst        |   54 +
 Documentation/linux_tv/media/dvb/dmx-get-stc.rst   |   73 +
 .../linux_tv/media/dvb/dmx-remove-pid.rst          |   55 +
 .../linux_tv/media/dvb/dmx-set-buffer-size.rst     |   57 +
 .../linux_tv/media/dvb/dmx-set-filter.rst          |   63 +
 .../linux_tv/media/dvb/dmx-set-pes-filter.rst      |   74 +
 .../linux_tv/media/dvb/dmx-set-source.rst          |   54 +
 Documentation/linux_tv/media/dvb/dmx-start.rst     |   73 +
 Documentation/linux_tv/media/dvb/dmx-stop.rst      |   50 +
 Documentation/linux_tv/media/dvb/dmx_fcalls.rst    | 1075 +----------
 Documentation/linux_tv/media/dvb/net-add-if.rst    |   87 +
 Documentation/linux_tv/media/dvb/net-get-if.rst    |   48 +
 Documentation/linux_tv/media/dvb/net-remove-if.rst |   42 +
 Documentation/linux_tv/media/dvb/net.rst           |  180 +-
 .../linux_tv/media/dvb/video-clear-buffer.rst      |   49 +
 Documentation/linux_tv/media/dvb/video-command.rst |   61 +
 .../linux_tv/media/dvb/video-continue.rst          |   52 +
 .../linux_tv/media/dvb/video-fast-forward.rst      |   70 +
 Documentation/linux_tv/media/dvb/video-fclose.rst  |   52 +
 Documentation/linux_tv/media/dvb/video-fopen.rst   |  108 ++
 Documentation/linux_tv/media/dvb/video-freeze.rst  |   56 +
 Documentation/linux_tv/media/dvb/video-fwrite.rst  |   80 +
 .../linux_tv/media/dvb/video-get-capabilities.rst  |   56 +
 .../linux_tv/media/dvb/video-get-event.rst         |   86 +
 .../linux_tv/media/dvb/video-get-frame-count.rst   |   60 +
 .../linux_tv/media/dvb/video-get-frame-rate.rst    |   54 +
 .../linux_tv/media/dvb/video-get-navi.rst          |   70 +
 Documentation/linux_tv/media/dvb/video-get-pts.rst |   64 +
 .../linux_tv/media/dvb/video-get-size.rst          |   54 +
 .../linux_tv/media/dvb/video-get-status.rst        |   55 +
 Documentation/linux_tv/media/dvb/video-play.rst    |   52 +
 .../linux_tv/media/dvb/video-select-source.rst     |   60 +
 .../linux_tv/media/dvb/video-set-attributes.rst    |   68 +
 .../linux_tv/media/dvb/video-set-blank.rst         |   59 +
 .../media/dvb/video-set-display-format.rst         |   55 +
 .../linux_tv/media/dvb/video-set-format.rst        |   70 +
 .../linux_tv/media/dvb/video-set-highlight.rst     |   55 +
 Documentation/linux_tv/media/dvb/video-set-id.rst  |   69 +
 .../linux_tv/media/dvb/video-set-spu-palette.rst   |   68 +
 Documentation/linux_tv/media/dvb/video-set-spu.rst |   70 +
 .../linux_tv/media/dvb/video-set-streamtype.rst    |   56 +
 .../linux_tv/media/dvb/video-set-system.rst        |   71 +
 .../linux_tv/media/dvb/video-slowmotion.rst        |   70 +
 .../linux_tv/media/dvb/video-stillpicture.rst      |   56 +
 Documentation/linux_tv/media/dvb/video-stop.rst    |   69 +
 .../linux_tv/media/dvb/video-try-command.rst       |   61 +
 .../linux_tv/media/dvb/video_function_calls.rst    | 2008 +-------------------
 89 files changed, 5399 insertions(+), 5141 deletions(-)
 create mode 100644 Documentation/linux_tv/media/dvb/audio-bilingual-channel-select.rst
 create mode 100644 Documentation/linux_tv/media/dvb/audio-channel-select.rst
 create mode 100644 Documentation/linux_tv/media/dvb/audio-clear-buffer.rst
 create mode 100644 Documentation/linux_tv/media/dvb/audio-continue.rst
 create mode 100644 Documentation/linux_tv/media/dvb/audio-fclose.rst
 create mode 100644 Documentation/linux_tv/media/dvb/audio-fopen.rst
 create mode 100644 Documentation/linux_tv/media/dvb/audio-fwrite.rst
 create mode 100644 Documentation/linux_tv/media/dvb/audio-get-capabilities.rst
 create mode 100644 Documentation/linux_tv/media/dvb/audio-get-pts.rst
 create mode 100644 Documentation/linux_tv/media/dvb/audio-get-status.rst
 create mode 100644 Documentation/linux_tv/media/dvb/audio-pause.rst
 create mode 100644 Documentation/linux_tv/media/dvb/audio-play.rst
 create mode 100644 Documentation/linux_tv/media/dvb/audio-select-source.rst
 create mode 100644 Documentation/linux_tv/media/dvb/audio-set-attributes.rst
 create mode 100644 Documentation/linux_tv/media/dvb/audio-set-av-sync.rst
 create mode 100644 Documentation/linux_tv/media/dvb/audio-set-bypass-mode.rst
 create mode 100644 Documentation/linux_tv/media/dvb/audio-set-ext-id.rst
 create mode 100644 Documentation/linux_tv/media/dvb/audio-set-id.rst
 create mode 100644 Documentation/linux_tv/media/dvb/audio-set-karaoke.rst
 create mode 100644 Documentation/linux_tv/media/dvb/audio-set-mixer.rst
 create mode 100644 Documentation/linux_tv/media/dvb/audio-set-mute.rst
 create mode 100644 Documentation/linux_tv/media/dvb/audio-set-streamtype.rst
 create mode 100644 Documentation/linux_tv/media/dvb/audio-stop.rst
 create mode 100644 Documentation/linux_tv/media/dvb/ca-fclose.rst
 create mode 100644 Documentation/linux_tv/media/dvb/ca-fopen.rst
 create mode 100644 Documentation/linux_tv/media/dvb/ca-get-cap.rst
 create mode 100644 Documentation/linux_tv/media/dvb/ca-get-descr-info.rst
 create mode 100644 Documentation/linux_tv/media/dvb/ca-get-msg.rst
 create mode 100644 Documentation/linux_tv/media/dvb/ca-get-slot-info.rst
 create mode 100644 Documentation/linux_tv/media/dvb/ca-reset.rst
 create mode 100644 Documentation/linux_tv/media/dvb/ca-send-msg.rst
 create mode 100644 Documentation/linux_tv/media/dvb/ca-set-descr.rst
 create mode 100644 Documentation/linux_tv/media/dvb/ca-set-pid.rst
 create mode 100644 Documentation/linux_tv/media/dvb/dmx-add-pid.rst
 create mode 100644 Documentation/linux_tv/media/dvb/dmx-fclose.rst
 create mode 100644 Documentation/linux_tv/media/dvb/dmx-fopen.rst
 create mode 100644 Documentation/linux_tv/media/dvb/dmx-fread.rst
 create mode 100644 Documentation/linux_tv/media/dvb/dmx-fwrite.rst
 create mode 100644 Documentation/linux_tv/media/dvb/dmx-get-caps.rst
 create mode 100644 Documentation/linux_tv/media/dvb/dmx-get-event.rst
 create mode 100644 Documentation/linux_tv/media/dvb/dmx-get-pes-pids.rst
 create mode 100644 Documentation/linux_tv/media/dvb/dmx-get-stc.rst
 create mode 100644 Documentation/linux_tv/media/dvb/dmx-remove-pid.rst
 create mode 100644 Documentation/linux_tv/media/dvb/dmx-set-buffer-size.rst
 create mode 100644 Documentation/linux_tv/media/dvb/dmx-set-filter.rst
 create mode 100644 Documentation/linux_tv/media/dvb/dmx-set-pes-filter.rst
 create mode 100644 Documentation/linux_tv/media/dvb/dmx-set-source.rst
 create mode 100644 Documentation/linux_tv/media/dvb/dmx-start.rst
 create mode 100644 Documentation/linux_tv/media/dvb/dmx-stop.rst
 create mode 100644 Documentation/linux_tv/media/dvb/net-add-if.rst
 create mode 100644 Documentation/linux_tv/media/dvb/net-get-if.rst
 create mode 100644 Documentation/linux_tv/media/dvb/net-remove-if.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-clear-buffer.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-command.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-continue.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-fast-forward.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-fclose.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-fopen.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-freeze.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-fwrite.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-get-capabilities.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-get-event.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-get-frame-count.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-get-frame-rate.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-get-navi.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-get-pts.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-get-size.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-get-status.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-play.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-select-source.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-set-attributes.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-set-blank.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-set-display-format.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-set-format.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-set-highlight.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-set-id.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-set-spu-palette.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-set-spu.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-set-streamtype.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-set-system.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-slowmotion.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-stillpicture.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-stop.rst
 create mode 100644 Documentation/linux_tv/media/dvb/video-try-command.rst

diff --git a/Documentation/linux_tv/media/dvb/audio-bilingual-channel-select.rst b/Documentation/linux_tv/media/dvb/audio-bilingual-channel-select.rst
new file mode 100644
index 000000000000..b965932fe20c
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/audio-bilingual-channel-select.rst
@@ -0,0 +1,59 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _AUDIO_BILINGUAL_CHANNEL_SELECT:
+
+AUDIO_BILINGUAL_CHANNEL_SELECT
+==============================
+
+Description
+-----------
+
+This ioctl is obsolete. Do not use in new drivers. It has been replaced
+by the V4L2 ``V4L2_CID_MPEG_AUDIO_DEC_MULTILINGUAL_PLAYBACK`` control
+for MPEG decoders controlled through V4L2.
+
+This ioctl call asks the Audio Device to select the requested channel
+for bilingual streams if possible.
+
+Synopsis
+--------
+
+.. c:function:: int ioctl(int fd, int request = AUDIO_BILINGUAL_CHANNEL_SELECT, audio_channel_select_t)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals AUDIO_BILINGUAL_CHANNEL_SELECT for this command.
+
+    -  .. row 3
+
+       -  audio_channel_select_t ch
+
+       -  Select the output format of the audio (mono left/right, stereo).
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
diff --git a/Documentation/linux_tv/media/dvb/audio-channel-select.rst b/Documentation/linux_tv/media/dvb/audio-channel-select.rst
new file mode 100644
index 000000000000..d570ff1f7d3a
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/audio-channel-select.rst
@@ -0,0 +1,58 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _AUDIO_CHANNEL_SELECT:
+
+AUDIO_CHANNEL_SELECT
+====================
+
+Description
+-----------
+
+This ioctl is for DVB devices only. To control a V4L2 decoder use the
+V4L2 ``V4L2_CID_MPEG_AUDIO_DEC_PLAYBACK`` control instead.
+
+This ioctl call asks the Audio Device to select the requested channel if
+possible.
+
+Synopsis
+--------
+
+.. c:function:: int ioctl(int fd, int request = AUDIO_CHANNEL_SELECT, audio_channel_select_t)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals AUDIO_CHANNEL_SELECT for this command.
+
+    -  .. row 3
+
+       -  audio_channel_select_t ch
+
+       -  Select the output format of the audio (mono left/right, stereo).
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
diff --git a/Documentation/linux_tv/media/dvb/audio-clear-buffer.rst b/Documentation/linux_tv/media/dvb/audio-clear-buffer.rst
new file mode 100644
index 000000000000..6c94cc7402a9
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/audio-clear-buffer.rst
@@ -0,0 +1,49 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _AUDIO_CLEAR_BUFFER:
+
+AUDIO_CLEAR_BUFFER
+==================
+
+Description
+-----------
+
+This ioctl call asks the Audio Device to clear all software and hardware
+buffers of the audio decoder device.
+
+Synopsis
+--------
+
+.. c:function:: int  ioctl(int fd, int request = AUDIO_CLEAR_BUFFER)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals AUDIO_CLEAR_BUFFER for this command.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
diff --git a/Documentation/linux_tv/media/dvb/audio-continue.rst b/Documentation/linux_tv/media/dvb/audio-continue.rst
new file mode 100644
index 000000000000..8b91cf950765
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/audio-continue.rst
@@ -0,0 +1,49 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _AUDIO_CONTINUE:
+
+AUDIO_CONTINUE
+==============
+
+Description
+-----------
+
+This ioctl restarts the decoding and playing process previously paused
+with AUDIO_PAUSE command.
+
+Synopsis
+--------
+
+.. c:function:: int  ioctl(int fd, int request = AUDIO_CONTINUE)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals AUDIO_CONTINUE for this command.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
diff --git a/Documentation/linux_tv/media/dvb/audio-fclose.rst b/Documentation/linux_tv/media/dvb/audio-fclose.rst
new file mode 100644
index 000000000000..fb855dd9cbcb
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/audio-fclose.rst
@@ -0,0 +1,52 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _audio_fclose:
+
+DVB audio close()
+=================
+
+Description
+-----------
+
+This system call closes a previously opened audio device.
+
+Synopsis
+--------
+
+.. c:function:: int  close(int fd)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+
+Return Value
+------------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  ``EBADF``
+
+       -  fd is not a valid open file descriptor.
+
+
+
diff --git a/Documentation/linux_tv/media/dvb/audio-fopen.rst b/Documentation/linux_tv/media/dvb/audio-fopen.rst
new file mode 100644
index 000000000000..5d3d7d941567
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/audio-fopen.rst
@@ -0,0 +1,102 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _audio_fopen:
+
+DVB audio open()
+================
+
+Description
+-----------
+
+This system call opens a named audio device (e.g.
+/dev/dvb/adapter0/audio0) for subsequent use. When an open() call has
+succeeded, the device will be ready for use. The significance of
+blocking or non-blocking mode is described in the documentation for
+functions where there is a difference. It does not affect the semantics
+of the open() call itself. A device opened in blocking mode can later be
+put into non-blocking mode (and vice versa) using the F_SETFL command
+of the fcntl system call. This is a standard system call, documented in
+the Linux manual page for fcntl. Only one user can open the Audio Device
+in O_RDWR mode. All other attempts to open the device in this mode will
+fail, and an error code will be returned. If the Audio Device is opened
+in O_RDONLY mode, the only ioctl call that can be used is
+AUDIO_GET_STATUS. All other call will return with an error code.
+
+Synopsis
+--------
+
+.. c:function:: int  open(const char *deviceName, int flags)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  const char \*deviceName
+
+       -  Name of specific audio device.
+
+    -  .. row 2
+
+       -  int flags
+
+       -  A bit-wise OR of the following flags:
+
+    -  .. row 3
+
+       -
+       -  O_RDONLY read-only access
+
+    -  .. row 4
+
+       -
+       -  O_RDWR read/write access
+
+    -  .. row 5
+
+       -
+       -  O_NONBLOCK open in non-blocking mode
+
+    -  .. row 6
+
+       -
+       -  (blocking mode is the default)
+
+
+Return Value
+------------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  ``ENODEV``
+
+       -  Device driver not loaded/available.
+
+    -  .. row 2
+
+       -  ``EBUSY``
+
+       -  Device or resource busy.
+
+    -  .. row 3
+
+       -  ``EINVAL``
+
+       -  Invalid argument.
+
+
+
diff --git a/Documentation/linux_tv/media/dvb/audio-fwrite.rst b/Documentation/linux_tv/media/dvb/audio-fwrite.rst
new file mode 100644
index 000000000000..9921f3a16d45
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/audio-fwrite.rst
@@ -0,0 +1,80 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _audio_fwrite:
+
+DVB audio write()
+=================
+
+Description
+-----------
+
+This system call can only be used if AUDIO_SOURCE_MEMORY is selected
+in the ioctl call AUDIO_SELECT_SOURCE. The data provided shall be in
+PES format. If O_NONBLOCK is not specified the function will block
+until buffer space is available. The amount of data to be transferred is
+implied by count.
+
+Synopsis
+--------
+
+.. c:function:: size_t write(int fd, const void *buf, size_t count)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  void \*buf
+
+       -  Pointer to the buffer containing the PES data.
+
+    -  .. row 3
+
+       -  size_t count
+
+       -  Size of buf.
+
+
+Return Value
+------------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  ``EPERM``
+
+       -  Mode AUDIO_SOURCE_MEMORY not selected.
+
+    -  .. row 2
+
+       -  ``ENOMEM``
+
+       -  Attempted to write more data than the internal buffer can hold.
+
+    -  .. row 3
+
+       -  ``EBADF``
+
+       -  fd is not a valid open file descriptor.
+
+
+
diff --git a/Documentation/linux_tv/media/dvb/audio-get-capabilities.rst b/Documentation/linux_tv/media/dvb/audio-get-capabilities.rst
new file mode 100644
index 000000000000..84b9f073344b
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/audio-get-capabilities.rst
@@ -0,0 +1,55 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _AUDIO_GET_CAPABILITIES:
+
+AUDIO_GET_CAPABILITIES
+======================
+
+Description
+-----------
+
+This ioctl call asks the Audio Device to tell us about the decoding
+capabilities of the audio hardware.
+
+Synopsis
+--------
+
+.. c:function:: int ioctl(int fd, int request = AUDIO_GET_CAPABILITIES, unsigned int *cap)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals AUDIO_GET_CAPABILITIES for this command.
+
+    -  .. row 3
+
+       -  unsigned int \*cap
+
+       -  Returns a bit array of supported sound formats.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
diff --git a/Documentation/linux_tv/media/dvb/audio-get-pts.rst b/Documentation/linux_tv/media/dvb/audio-get-pts.rst
new file mode 100644
index 000000000000..3cd31741e728
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/audio-get-pts.rst
@@ -0,0 +1,64 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _AUDIO_GET_PTS:
+
+AUDIO_GET_PTS
+=============
+
+Description
+-----------
+
+This ioctl is obsolete. Do not use in new drivers. If you need this
+functionality, then please contact the linux-media mailing list
+(`https://linuxtv.org/lists.php <https://linuxtv.org/lists.php>`__).
+
+This ioctl call asks the Audio Device to return the current PTS
+timestamp.
+
+Synopsis
+--------
+
+.. c:function:: int ioctl(int fd, int request = AUDIO_GET_PTS, __u64 *pts)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals AUDIO_GET_PTS for this command.
+
+    -  .. row 3
+
+       -  __u64 \*pts
+
+       -  Returns the 33-bit timestamp as defined in ITU T-REC-H.222.0 /
+	  ISO/IEC 13818-1.
+
+	  The PTS should belong to the currently played frame if possible,
+	  but may also be a value close to it like the PTS of the last
+	  decoded frame or the last PTS extracted by the PES parser.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
diff --git a/Documentation/linux_tv/media/dvb/audio-get-status.rst b/Documentation/linux_tv/media/dvb/audio-get-status.rst
new file mode 100644
index 000000000000..be0937fbff0c
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/audio-get-status.rst
@@ -0,0 +1,55 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _AUDIO_GET_STATUS:
+
+AUDIO_GET_STATUS
+================
+
+Description
+-----------
+
+This ioctl call asks the Audio Device to return the current state of the
+Audio Device.
+
+Synopsis
+--------
+
+.. c:function:: int ioctl(int fd, int request = AUDIO_GET_STATUS, struct audio_status *status)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals AUDIO_GET_STATUS for this command.
+
+    -  .. row 3
+
+       -  struct audio_status \*status
+
+       -  Returns the current state of Audio Device.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
diff --git a/Documentation/linux_tv/media/dvb/audio-pause.rst b/Documentation/linux_tv/media/dvb/audio-pause.rst
new file mode 100644
index 000000000000..2d1c7e880ad0
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/audio-pause.rst
@@ -0,0 +1,50 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _AUDIO_PAUSE:
+
+AUDIO_PAUSE
+===========
+
+Description
+-----------
+
+This ioctl call suspends the audio stream being played. Decoding and
+playing are paused. It is then possible to restart again decoding and
+playing process of the audio stream using AUDIO_CONTINUE command.
+
+Synopsis
+--------
+
+.. c:function:: int  ioctl(int fd, int request = AUDIO_PAUSE)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals AUDIO_PAUSE for this command.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
diff --git a/Documentation/linux_tv/media/dvb/audio-play.rst b/Documentation/linux_tv/media/dvb/audio-play.rst
new file mode 100644
index 000000000000..116cc27be82c
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/audio-play.rst
@@ -0,0 +1,49 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _AUDIO_PLAY:
+
+AUDIO_PLAY
+==========
+
+Description
+-----------
+
+This ioctl call asks the Audio Device to start playing an audio stream
+from the selected source.
+
+Synopsis
+--------
+
+.. c:function:: int  ioctl(int fd, int request = AUDIO_PLAY)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals AUDIO_PLAY for this command.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
diff --git a/Documentation/linux_tv/media/dvb/audio-select-source.rst b/Documentation/linux_tv/media/dvb/audio-select-source.rst
new file mode 100644
index 000000000000..9d6367e7ff6f
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/audio-select-source.rst
@@ -0,0 +1,57 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _AUDIO_SELECT_SOURCE:
+
+AUDIO_SELECT_SOURCE
+===================
+
+Description
+-----------
+
+This ioctl call informs the audio device which source shall be used for
+the input data. The possible sources are demux or memory. If
+AUDIO_SOURCE_MEMORY is selected, the data is fed to the Audio Device
+through the write command.
+
+Synopsis
+--------
+
+.. c:function:: int ioctl(int fd, int request = AUDIO_SELECT_SOURCE, audio_stream_source_t source)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals AUDIO_SELECT_SOURCE for this command.
+
+    -  .. row 3
+
+       -  audio_stream_source_t source
+
+       -  Indicates the source that shall be used for the Audio stream.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
diff --git a/Documentation/linux_tv/media/dvb/audio-set-attributes.rst b/Documentation/linux_tv/media/dvb/audio-set-attributes.rst
new file mode 100644
index 000000000000..a03774015b40
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/audio-set-attributes.rst
@@ -0,0 +1,69 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _AUDIO_SET_ATTRIBUTES:
+
+AUDIO_SET_ATTRIBUTES
+====================
+
+Description
+-----------
+
+This ioctl is intended for DVD playback and allows you to set certain
+information about the audio stream.
+
+Synopsis
+--------
+
+.. c:function:: int ioctl(fd, int request = AUDIO_SET_ATTRIBUTES, audio_attributes_t attr )
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals AUDIO_SET_ATTRIBUTES for this command.
+
+    -  .. row 3
+
+       -  audio_attributes_t attr
+
+       -  audio attributes according to section ??
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  ``EINVAL``
+
+       -  attr is not a valid or supported attribute setting.
+
+
+
diff --git a/Documentation/linux_tv/media/dvb/audio-set-av-sync.rst b/Documentation/linux_tv/media/dvb/audio-set-av-sync.rst
new file mode 100644
index 000000000000..7aa27ab34d91
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/audio-set-av-sync.rst
@@ -0,0 +1,65 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _AUDIO_SET_AV_SYNC:
+
+AUDIO_SET_AV_SYNC
+=================
+
+Description
+-----------
+
+This ioctl call asks the Audio Device to turn ON or OFF A/V
+synchronization.
+
+Synopsis
+--------
+
+.. c:function:: int  ioctl(int fd, int request = AUDIO_SET_AV_SYNC, boolean state)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals AUDIO_AV_SYNC for this command.
+
+    -  .. row 3
+
+       -  boolean state
+
+       -  Tells the DVB subsystem if A/V synchronization shall be ON or OFF.
+
+    -  .. row 4
+
+       -
+       -  TRUE AV-sync ON
+
+    -  .. row 5
+
+       -
+       -  FALSE AV-sync OFF
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
diff --git a/Documentation/linux_tv/media/dvb/audio-set-bypass-mode.rst b/Documentation/linux_tv/media/dvb/audio-set-bypass-mode.rst
new file mode 100644
index 000000000000..3a0c21a667fa
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/audio-set-bypass-mode.rst
@@ -0,0 +1,69 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _AUDIO_SET_BYPASS_MODE:
+
+AUDIO_SET_BYPASS_MODE
+=====================
+
+Description
+-----------
+
+This ioctl call asks the Audio Device to bypass the Audio decoder and
+forward the stream without decoding. This mode shall be used if streams
+that can’t be handled by the DVB system shall be decoded. Dolby
+DigitalTM streams are automatically forwarded by the DVB subsystem if
+the hardware can handle it.
+
+Synopsis
+--------
+
+.. c:function:: int ioctl(int fd, int request = AUDIO_SET_BYPASS_MODE, boolean mode)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals AUDIO_SET_BYPASS_MODE for this command.
+
+    -  .. row 3
+
+       -  boolean mode
+
+       -  Enables or disables the decoding of the current Audio stream in
+	  the DVB subsystem.
+
+    -  .. row 4
+
+       -
+       -  TRUE Bypass is disabled
+
+    -  .. row 5
+
+       -
+       -  FALSE Bypass is enabled
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
diff --git a/Documentation/linux_tv/media/dvb/audio-set-ext-id.rst b/Documentation/linux_tv/media/dvb/audio-set-ext-id.rst
new file mode 100644
index 000000000000..bda4c92df27f
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/audio-set-ext-id.rst
@@ -0,0 +1,69 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _AUDIO_SET_EXT_ID:
+
+AUDIO_SET_EXT_ID
+================
+
+Description
+-----------
+
+This ioctl can be used to set the extension id for MPEG streams in DVD
+playback. Only the first 3 bits are recognized.
+
+Synopsis
+--------
+
+.. c:function:: int  ioctl(fd, int request = AUDIO_SET_EXT_ID, int id)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals AUDIO_SET_EXT_ID for this command.
+
+    -  .. row 3
+
+       -  int id
+
+       -  audio sub_stream_id
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  ``EINVAL``
+
+       -  id is not a valid id.
+
+
+
diff --git a/Documentation/linux_tv/media/dvb/audio-set-id.rst b/Documentation/linux_tv/media/dvb/audio-set-id.rst
new file mode 100644
index 000000000000..e545f9dad407
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/audio-set-id.rst
@@ -0,0 +1,60 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _AUDIO_SET_ID:
+
+AUDIO_SET_ID
+============
+
+Description
+-----------
+
+This ioctl selects which sub-stream is to be decoded if a program or
+system stream is sent to the video device. If no audio stream type is
+set the id has to be in [0xC0,0xDF] for MPEG sound, in [0x80,0x87] for
+AC3 and in [0xA0,0xA7] for LPCM. More specifications may follow for
+other stream types. If the stream type is set the id just specifies the
+substream id of the audio stream and only the first 5 bits are
+recognized.
+
+Synopsis
+--------
+
+.. c:function:: int  ioctl(int fd, int request = AUDIO_SET_ID, int id)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals AUDIO_SET_ID for this command.
+
+    -  .. row 3
+
+       -  int id
+
+       -  audio sub-stream id
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
diff --git a/Documentation/linux_tv/media/dvb/audio-set-karaoke.rst b/Documentation/linux_tv/media/dvb/audio-set-karaoke.rst
new file mode 100644
index 000000000000..75a02e4db0a1
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/audio-set-karaoke.rst
@@ -0,0 +1,65 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _AUDIO_SET_KARAOKE:
+
+AUDIO_SET_KARAOKE
+=================
+
+Description
+-----------
+
+This ioctl allows one to set the mixer settings for a karaoke DVD.
+
+Synopsis
+--------
+
+.. c:function:: int ioctl(fd, int request = AUDIO_SET_KARAOKE, audio_karaoke_t *karaoke)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals AUDIO_SET_KARAOKE for this command.
+
+    -  .. row 3
+
+       -  audio_karaoke_t \*karaoke
+
+       -  karaoke settings according to section ??.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  ``EINVAL``
+
+       -  karaoke is not a valid or supported karaoke setting.
diff --git a/Documentation/linux_tv/media/dvb/audio-set-mixer.rst b/Documentation/linux_tv/media/dvb/audio-set-mixer.rst
new file mode 100644
index 000000000000..9360d20e759e
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/audio-set-mixer.rst
@@ -0,0 +1,54 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _AUDIO_SET_MIXER:
+
+AUDIO_SET_MIXER
+===============
+
+Description
+-----------
+
+This ioctl lets you adjust the mixer settings of the audio decoder.
+
+Synopsis
+--------
+
+.. c:function:: int ioctl(int fd, int request = AUDIO_SET_MIXER, audio_mixer_t *mix)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals AUDIO_SET_ID for this command.
+
+    -  .. row 3
+
+       -  audio_mixer_t \*mix
+
+       -  mixer settings.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
diff --git a/Documentation/linux_tv/media/dvb/audio-set-mute.rst b/Documentation/linux_tv/media/dvb/audio-set-mute.rst
new file mode 100644
index 000000000000..eb6622b63e2b
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/audio-set-mute.rst
@@ -0,0 +1,69 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _AUDIO_SET_MUTE:
+
+AUDIO_SET_MUTE
+==============
+
+Description
+-----------
+
+This ioctl is for DVB devices only. To control a V4L2 decoder use the
+V4L2 :ref:`VIDIOC_DECODER_CMD` with the
+``V4L2_DEC_CMD_START_MUTE_AUDIO`` flag instead.
+
+This ioctl call asks the audio device to mute the stream that is
+currently being played.
+
+Synopsis
+--------
+
+.. c:function:: int  ioctl(int fd, int request = AUDIO_SET_MUTE, boolean state)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals AUDIO_SET_MUTE for this command.
+
+    -  .. row 3
+
+       -  boolean state
+
+       -  Indicates if audio device shall mute or not.
+
+    -  .. row 4
+
+       -
+       -  TRUE Audio Mute
+
+    -  .. row 5
+
+       -
+       -  FALSE Audio Un-mute
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
diff --git a/Documentation/linux_tv/media/dvb/audio-set-streamtype.rst b/Documentation/linux_tv/media/dvb/audio-set-streamtype.rst
new file mode 100644
index 000000000000..6fc7c8dfccf8
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/audio-set-streamtype.rst
@@ -0,0 +1,70 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _AUDIO_SET_STREAMTYPE:
+
+AUDIO_SET_STREAMTYPE
+====================
+
+Description
+-----------
+
+This ioctl tells the driver which kind of audio stream to expect. This
+is useful if the stream offers several audio sub-streams like LPCM and
+AC3.
+
+Synopsis
+--------
+
+.. c:function:: int  ioctl(fd, int request = AUDIO_SET_STREAMTYPE, int type)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals AUDIO_SET_STREAMTYPE for this command.
+
+    -  .. row 3
+
+       -  int type
+
+       -  stream type
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  ``EINVAL``
+
+       -  type is not a valid or supported stream type.
+
+
+
diff --git a/Documentation/linux_tv/media/dvb/audio-stop.rst b/Documentation/linux_tv/media/dvb/audio-stop.rst
new file mode 100644
index 000000000000..57e95c453350
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/audio-stop.rst
@@ -0,0 +1,49 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _AUDIO_STOP:
+
+AUDIO_STOP
+==========
+
+Description
+-----------
+
+This ioctl call asks the Audio Device to stop playing the current
+stream.
+
+Synopsis
+--------
+
+.. c:function:: int ioctl(int fd, int request = AUDIO_STOP)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals AUDIO_STOP for this command.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
diff --git a/Documentation/linux_tv/media/dvb/audio_function_calls.rst b/Documentation/linux_tv/media/dvb/audio_function_calls.rst
index 8eec97d836ea..0bb56f0cfed4 100644
--- a/Documentation/linux_tv/media/dvb/audio_function_calls.rst
+++ b/Documentation/linux_tv/media/dvb/audio_function_calls.rst
@@ -6,1376 +6,29 @@
 Audio Function Calls
 ********************
 
-
-.. _audio_fopen:
-
-DVB audio open()
-================
-
-Description
------------
-
-This system call opens a named audio device (e.g.
-/dev/dvb/adapter0/audio0) for subsequent use. When an open() call has
-succeeded, the device will be ready for use. The significance of
-blocking or non-blocking mode is described in the documentation for
-functions where there is a difference. It does not affect the semantics
-of the open() call itself. A device opened in blocking mode can later be
-put into non-blocking mode (and vice versa) using the F_SETFL command
-of the fcntl system call. This is a standard system call, documented in
-the Linux manual page for fcntl. Only one user can open the Audio Device
-in O_RDWR mode. All other attempts to open the device in this mode will
-fail, and an error code will be returned. If the Audio Device is opened
-in O_RDONLY mode, the only ioctl call that can be used is
-AUDIO_GET_STATUS. All other call will return with an error code.
-
-Synopsis
---------
-
-.. c:function:: int  open(const char *deviceName, int flags)
-
-Arguments
-----------
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
-       -  const char \*deviceName
-
-       -  Name of specific audio device.
-
-    -  .. row 2
-
-       -  int flags
-
-       -  A bit-wise OR of the following flags:
-
-    -  .. row 3
-
-       -
-       -  O_RDONLY read-only access
-
-    -  .. row 4
-
-       -
-       -  O_RDWR read/write access
-
-    -  .. row 5
-
-       -
-       -  O_NONBLOCK open in non-blocking mode
-
-    -  .. row 6
-
-       -
-       -  (blocking mode is the default)
-
-
-Return Value
-------------
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
-       -  ``ENODEV``
-
-       -  Device driver not loaded/available.
-
-    -  .. row 2
-
-       -  ``EBUSY``
-
-       -  Device or resource busy.
-
-    -  .. row 3
-
-       -  ``EINVAL``
-
-       -  Invalid argument.
-
-
-
-.. _audio_fclose:
-
-DVB audio close()
-=================
-
-Description
------------
-
-This system call closes a previously opened audio device.
-
-Synopsis
---------
-
-.. c:function:: int  close(int fd)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-
-Return Value
-------------
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
-       -  ``EBADF``
-
-       -  fd is not a valid open file descriptor.
-
-
-
-.. _audio_fwrite:
-
-DVB audio write()
-=================
-
-Description
------------
-
-This system call can only be used if AUDIO_SOURCE_MEMORY is selected
-in the ioctl call AUDIO_SELECT_SOURCE. The data provided shall be in
-PES format. If O_NONBLOCK is not specified the function will block
-until buffer space is available. The amount of data to be transferred is
-implied by count.
-
-Synopsis
---------
-
-.. c:function:: size_t write(int fd, const void *buf, size_t count)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  void \*buf
-
-       -  Pointer to the buffer containing the PES data.
-
-    -  .. row 3
-
-       -  size_t count
-
-       -  Size of buf.
-
-
-Return Value
-------------
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
-       -  ``EPERM``
-
-       -  Mode AUDIO_SOURCE_MEMORY not selected.
-
-    -  .. row 2
-
-       -  ``ENOMEM``
-
-       -  Attempted to write more data than the internal buffer can hold.
-
-    -  .. row 3
-
-       -  ``EBADF``
-
-       -  fd is not a valid open file descriptor.
-
-
-
-.. _AUDIO_STOP:
-
-AUDIO_STOP
-==========
-
-Description
------------
-
-This ioctl call asks the Audio Device to stop playing the current
-stream.
-
-Synopsis
---------
-
-.. c:function:: int ioctl(int fd, int request = AUDIO_STOP)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals AUDIO_STOP for this command.
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
-.. _AUDIO_PLAY:
-
-AUDIO_PLAY
-==========
-
-Description
------------
-
-This ioctl call asks the Audio Device to start playing an audio stream
-from the selected source.
-
-Synopsis
---------
-
-.. c:function:: int  ioctl(int fd, int request = AUDIO_PLAY)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals AUDIO_PLAY for this command.
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
-.. _AUDIO_PAUSE:
-
-AUDIO_PAUSE
-===========
-
-Description
------------
-
-This ioctl call suspends the audio stream being played. Decoding and
-playing are paused. It is then possible to restart again decoding and
-playing process of the audio stream using AUDIO_CONTINUE command.
-
-Synopsis
---------
-
-.. c:function:: int  ioctl(int fd, int request = AUDIO_PAUSE)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals AUDIO_PAUSE for this command.
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
-.. _AUDIO_CONTINUE:
-
-AUDIO_CONTINUE
-==============
-
-Description
------------
-
-This ioctl restarts the decoding and playing process previously paused
-with AUDIO_PAUSE command.
-
-Synopsis
---------
-
-.. c:function:: int  ioctl(int fd, int request = AUDIO_CONTINUE)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals AUDIO_CONTINUE for this command.
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
-.. _AUDIO_SELECT_SOURCE:
-
-AUDIO_SELECT_SOURCE
-===================
-
-Description
------------
-
-This ioctl call informs the audio device which source shall be used for
-the input data. The possible sources are demux or memory. If
-AUDIO_SOURCE_MEMORY is selected, the data is fed to the Audio Device
-through the write command.
-
-Synopsis
---------
-
-.. c:function:: int ioctl(int fd, int request = AUDIO_SELECT_SOURCE, audio_stream_source_t source)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals AUDIO_SELECT_SOURCE for this command.
-
-    -  .. row 3
-
-       -  audio_stream_source_t source
-
-       -  Indicates the source that shall be used for the Audio stream.
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
-.. _AUDIO_SET_MUTE:
-
-AUDIO_SET_MUTE
-==============
-
-Description
------------
-
-This ioctl is for DVB devices only. To control a V4L2 decoder use the
-V4L2 :ref:`VIDIOC_DECODER_CMD` with the
-``V4L2_DEC_CMD_START_MUTE_AUDIO`` flag instead.
-
-This ioctl call asks the audio device to mute the stream that is
-currently being played.
-
-Synopsis
---------
-
-.. c:function:: int  ioctl(int fd, int request = AUDIO_SET_MUTE, boolean state)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals AUDIO_SET_MUTE for this command.
-
-    -  .. row 3
-
-       -  boolean state
-
-       -  Indicates if audio device shall mute or not.
-
-    -  .. row 4
-
-       -
-       -  TRUE Audio Mute
-
-    -  .. row 5
-
-       -
-       -  FALSE Audio Un-mute
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
-.. _AUDIO_SET_AV_SYNC:
-
-AUDIO_SET_AV_SYNC
-=================
-
-Description
------------
-
-This ioctl call asks the Audio Device to turn ON or OFF A/V
-synchronization.
-
-Synopsis
---------
-
-.. c:function:: int  ioctl(int fd, int request = AUDIO_SET_AV_SYNC, boolean state)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals AUDIO_AV_SYNC for this command.
-
-    -  .. row 3
-
-       -  boolean state
-
-       -  Tells the DVB subsystem if A/V synchronization shall be ON or OFF.
-
-    -  .. row 4
-
-       -
-       -  TRUE AV-sync ON
-
-    -  .. row 5
-
-       -
-       -  FALSE AV-sync OFF
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
-.. _AUDIO_SET_BYPASS_MODE:
-
-AUDIO_SET_BYPASS_MODE
-=====================
-
-Description
------------
-
-This ioctl call asks the Audio Device to bypass the Audio decoder and
-forward the stream without decoding. This mode shall be used if streams
-that can’t be handled by the DVB system shall be decoded. Dolby
-DigitalTM streams are automatically forwarded by the DVB subsystem if
-the hardware can handle it.
-
-Synopsis
---------
-
-.. c:function:: int ioctl(int fd, int request = AUDIO_SET_BYPASS_MODE, boolean mode)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals AUDIO_SET_BYPASS_MODE for this command.
-
-    -  .. row 3
-
-       -  boolean mode
-
-       -  Enables or disables the decoding of the current Audio stream in
-	  the DVB subsystem.
-
-    -  .. row 4
-
-       -
-       -  TRUE Bypass is disabled
-
-    -  .. row 5
-
-       -
-       -  FALSE Bypass is enabled
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
-.. _AUDIO_CHANNEL_SELECT:
-
-AUDIO_CHANNEL_SELECT
-====================
-
-Description
------------
-
-This ioctl is for DVB devices only. To control a V4L2 decoder use the
-V4L2 ``V4L2_CID_MPEG_AUDIO_DEC_PLAYBACK`` control instead.
-
-This ioctl call asks the Audio Device to select the requested channel if
-possible.
-
-Synopsis
---------
-
-.. c:function:: int ioctl(int fd, int request = AUDIO_CHANNEL_SELECT, audio_channel_select_t)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals AUDIO_CHANNEL_SELECT for this command.
-
-    -  .. row 3
-
-       -  audio_channel_select_t ch
-
-       -  Select the output format of the audio (mono left/right, stereo).
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
-.. _AUDIO_BILINGUAL_CHANNEL_SELECT:
-
-AUDIO_BILINGUAL_CHANNEL_SELECT
-==============================
-
-Description
------------
-
-This ioctl is obsolete. Do not use in new drivers. It has been replaced
-by the V4L2 ``V4L2_CID_MPEG_AUDIO_DEC_MULTILINGUAL_PLAYBACK`` control
-for MPEG decoders controlled through V4L2.
-
-This ioctl call asks the Audio Device to select the requested channel
-for bilingual streams if possible.
-
-Synopsis
---------
-
-.. c:function:: int ioctl(int fd, int request = AUDIO_BILINGUAL_CHANNEL_SELECT, audio_channel_select_t)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals AUDIO_BILINGUAL_CHANNEL_SELECT for this command.
-
-    -  .. row 3
-
-       -  audio_channel_select_t ch
-
-       -  Select the output format of the audio (mono left/right, stereo).
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
-.. _AUDIO_GET_PTS:
-
-AUDIO_GET_PTS
-=============
-
-Description
------------
-
-This ioctl is obsolete. Do not use in new drivers. If you need this
-functionality, then please contact the linux-media mailing list
-(`https://linuxtv.org/lists.php <https://linuxtv.org/lists.php>`__).
-
-This ioctl call asks the Audio Device to return the current PTS
-timestamp.
-
-Synopsis
---------
-
-.. c:function:: int ioctl(int fd, int request = AUDIO_GET_PTS, __u64 *pts)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals AUDIO_GET_PTS for this command.
-
-    -  .. row 3
-
-       -  __u64 \*pts
-
-       -  Returns the 33-bit timestamp as defined in ITU T-REC-H.222.0 /
-	  ISO/IEC 13818-1.
-
-	  The PTS should belong to the currently played frame if possible,
-	  but may also be a value close to it like the PTS of the last
-	  decoded frame or the last PTS extracted by the PES parser.
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
-.. _AUDIO_GET_STATUS:
-
-AUDIO_GET_STATUS
-================
-
-Description
------------
-
-This ioctl call asks the Audio Device to return the current state of the
-Audio Device.
-
-Synopsis
---------
-
-.. c:function:: int ioctl(int fd, int request = AUDIO_GET_STATUS, struct audio_status *status)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals AUDIO_GET_STATUS for this command.
-
-    -  .. row 3
-
-       -  struct audio_status \*status
-
-       -  Returns the current state of Audio Device.
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
-.. _AUDIO_GET_CAPABILITIES:
-
-AUDIO_GET_CAPABILITIES
-======================
-
-Description
------------
-
-This ioctl call asks the Audio Device to tell us about the decoding
-capabilities of the audio hardware.
-
-Synopsis
---------
-
-.. c:function:: int ioctl(int fd, int request = AUDIO_GET_CAPABILITIES, unsigned int *cap)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals AUDIO_GET_CAPABILITIES for this command.
-
-    -  .. row 3
-
-       -  unsigned int \*cap
-
-       -  Returns a bit array of supported sound formats.
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
-.. _AUDIO_CLEAR_BUFFER:
-
-AUDIO_CLEAR_BUFFER
-==================
-
-Description
------------
-
-This ioctl call asks the Audio Device to clear all software and hardware
-buffers of the audio decoder device.
-
-Synopsis
---------
-
-.. c:function:: int  ioctl(int fd, int request = AUDIO_CLEAR_BUFFER)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals AUDIO_CLEAR_BUFFER for this command.
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
-.. _AUDIO_SET_ID:
-
-AUDIO_SET_ID
-============
-
-Description
------------
-
-This ioctl selects which sub-stream is to be decoded if a program or
-system stream is sent to the video device. If no audio stream type is
-set the id has to be in [0xC0,0xDF] for MPEG sound, in [0x80,0x87] for
-AC3 and in [0xA0,0xA7] for LPCM. More specifications may follow for
-other stream types. If the stream type is set the id just specifies the
-substream id of the audio stream and only the first 5 bits are
-recognized.
-
-Synopsis
---------
-
-.. c:function:: int  ioctl(int fd, int request = AUDIO_SET_ID, int id)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals AUDIO_SET_ID for this command.
-
-    -  .. row 3
-
-       -  int id
-
-       -  audio sub-stream id
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
-.. _AUDIO_SET_MIXER:
-
-AUDIO_SET_MIXER
-===============
-
-Description
------------
-
-This ioctl lets you adjust the mixer settings of the audio decoder.
-
-Synopsis
---------
-
-.. c:function:: int ioctl(int fd, int request = AUDIO_SET_MIXER, audio_mixer_t *mix)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals AUDIO_SET_ID for this command.
-
-    -  .. row 3
-
-       -  audio_mixer_t \*mix
-
-       -  mixer settings.
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
-.. _AUDIO_SET_STREAMTYPE:
-
-AUDIO_SET_STREAMTYPE
-====================
-
-Description
------------
-
-This ioctl tells the driver which kind of audio stream to expect. This
-is useful if the stream offers several audio sub-streams like LPCM and
-AC3.
-
-Synopsis
---------
-
-.. c:function:: int  ioctl(fd, int request = AUDIO_SET_STREAMTYPE, int type)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals AUDIO_SET_STREAMTYPE for this command.
-
-    -  .. row 3
-
-       -  int type
-
-       -  stream type
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
-       -  type is not a valid or supported stream type.
-
-
-
-.. _AUDIO_SET_EXT_ID:
-
-AUDIO_SET_EXT_ID
-================
-
-Description
------------
-
-This ioctl can be used to set the extension id for MPEG streams in DVD
-playback. Only the first 3 bits are recognized.
-
-Synopsis
---------
-
-.. c:function:: int  ioctl(fd, int request = AUDIO_SET_EXT_ID, int id)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals AUDIO_SET_EXT_ID for this command.
-
-    -  .. row 3
-
-       -  int id
-
-       -  audio sub_stream_id
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
-       -  id is not a valid id.
-
-
-
-.. _AUDIO_SET_ATTRIBUTES:
-
-AUDIO_SET_ATTRIBUTES
-====================
-
-Description
------------
-
-This ioctl is intended for DVD playback and allows you to set certain
-information about the audio stream.
-
-Synopsis
---------
-
-.. c:function:: int ioctl(fd, int request = AUDIO_SET_ATTRIBUTES, audio_attributes_t attr )
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals AUDIO_SET_ATTRIBUTES for this command.
-
-    -  .. row 3
-
-       -  audio_attributes_t attr
-
-       -  audio attributes according to section ??
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
-       -  attr is not a valid or supported attribute setting.
-
-
-
-.. _AUDIO_SET_KARAOKE:
-
-AUDIO_SET_KARAOKE
-=================
-
-Description
------------
-
-This ioctl allows one to set the mixer settings for a karaoke DVD.
-
-Synopsis
---------
-
-.. c:function:: int ioctl(fd, int request = AUDIO_SET_KARAOKE, audio_karaoke_t *karaoke)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals AUDIO_SET_KARAOKE for this command.
-
-    -  .. row 3
-
-       -  audio_karaoke_t \*karaoke
-
-       -  karaoke settings according to section ??.
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
-       -  karaoke is not a valid or supported karaoke setting.
+.. toctree::
+    :maxdepth: 1
+
+    audio-fopen
+    audio-fclose
+    audio-fwrite
+    audio-stop
+    audio-play
+    audio-pause
+    audio-continue
+    audio-select-source
+    audio-set-mute
+    audio-set-av-sync
+    audio-set-bypass-mode
+    audio-channel-select
+    audio-bilingual-channel-select
+    audio-get-pts
+    audio-get-status
+    audio-get-capabilities
+    audio-clear-buffer
+    audio-set-id
+    audio-set-mixer
+    audio-set-streamtype
+    audio-set-ext-id
+    audio-set-attributes
+    audio-set-karaoke
diff --git a/Documentation/linux_tv/media/dvb/ca-fclose.rst b/Documentation/linux_tv/media/dvb/ca-fclose.rst
new file mode 100644
index 000000000000..c7797c726c6b
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/ca-fclose.rst
@@ -0,0 +1,52 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _ca_fclose:
+
+DVB CA close()
+==============
+
+Description
+-----------
+
+This system call closes a previously opened audio device.
+
+Synopsis
+--------
+
+.. cpp:function:: int  close(int fd)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+
+Return Value
+------------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  ``EBADF``
+
+       -  fd is not a valid open file descriptor.
+
+
+
diff --git a/Documentation/linux_tv/media/dvb/ca-fopen.rst b/Documentation/linux_tv/media/dvb/ca-fopen.rst
new file mode 100644
index 000000000000..316209439f88
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/ca-fopen.rst
@@ -0,0 +1,107 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _ca_fopen:
+
+DVB CA open()
+=============
+
+Description
+-----------
+
+This system call opens a named ca device (e.g. /dev/ost/ca) for
+subsequent use.
+
+When an open() call has succeeded, the device will be ready for use. The
+significance of blocking or non-blocking mode is described in the
+documentation for functions where there is a difference. It does not
+affect the semantics of the open() call itself. A device opened in
+blocking mode can later be put into non-blocking mode (and vice versa)
+using the F_SETFL command of the fcntl system call. This is a standard
+system call, documented in the Linux manual page for fcntl. Only one
+user can open the CA Device in O_RDWR mode. All other attempts to open
+the device in this mode will fail, and an error code will be returned.
+
+Synopsis
+--------
+
+.. cpp:function:: int  open(const char *deviceName, int flags)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  const char \*deviceName
+
+       -  Name of specific video device.
+
+    -  .. row 2
+
+       -  int flags
+
+       -  A bit-wise OR of the following flags:
+
+    -  .. row 3
+
+       -
+       -  O_RDONLY read-only access
+
+    -  .. row 4
+
+       -
+       -  O_RDWR read/write access
+
+    -  .. row 5
+
+       -
+       -  O_NONBLOCK open in non-blocking mode
+
+    -  .. row 6
+
+       -
+       -  (blocking mode is the default)
+
+
+Return Value
+------------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  ``ENODEV``
+
+       -  Device driver not loaded/available.
+
+    -  .. row 2
+
+       -  ``EINTERNAL``
+
+       -  Internal error.
+
+    -  .. row 3
+
+       -  ``EBUSY``
+
+       -  Device or resource busy.
+
+    -  .. row 4
+
+       -  ``EINVAL``
+
+       -  Invalid argument.
+
+
+
diff --git a/Documentation/linux_tv/media/dvb/ca-get-cap.rst b/Documentation/linux_tv/media/dvb/ca-get-cap.rst
new file mode 100644
index 000000000000..9155e0b445ff
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/ca-get-cap.rst
@@ -0,0 +1,54 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _CA_GET_CAP:
+
+CA_GET_CAP
+==========
+
+Description
+-----------
+
+This ioctl is undocumented. Documentation is welcome.
+
+Synopsis
+--------
+
+.. cpp:function:: int  ioctl(fd, int request = CA_GET_CAP, ca_caps_t *)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals CA_GET_CAP for this command.
+
+    -  .. row 3
+
+       -  ca_caps_t *
+
+       -  Undocumented.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
diff --git a/Documentation/linux_tv/media/dvb/ca-get-descr-info.rst b/Documentation/linux_tv/media/dvb/ca-get-descr-info.rst
new file mode 100644
index 000000000000..cf5e3b1d8358
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/ca-get-descr-info.rst
@@ -0,0 +1,54 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _CA_GET_DESCR_INFO:
+
+CA_GET_DESCR_INFO
+=================
+
+Description
+-----------
+
+This ioctl is undocumented. Documentation is welcome.
+
+Synopsis
+--------
+
+.. cpp:function:: int  ioctl(fd, int request = CA_GET_DESCR_INFO, ca_descr_info_t *)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals CA_GET_DESCR_INFO for this command.
+
+    -  .. row 3
+
+       -  ca_descr_info_t \*
+
+       -  Undocumented.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
diff --git a/Documentation/linux_tv/media/dvb/ca-get-msg.rst b/Documentation/linux_tv/media/dvb/ca-get-msg.rst
new file mode 100644
index 000000000000..994d73a59992
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/ca-get-msg.rst
@@ -0,0 +1,54 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _CA_GET_MSG:
+
+CA_GET_MSG
+==========
+
+Description
+-----------
+
+This ioctl is undocumented. Documentation is welcome.
+
+Synopsis
+--------
+
+.. cpp:function:: int  ioctl(fd, int request = CA_GET_MSG, ca_msg_t *)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals CA_GET_MSG for this command.
+
+    -  .. row 3
+
+       -  ca_msg_t \*
+
+       -  Undocumented.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
diff --git a/Documentation/linux_tv/media/dvb/ca-get-slot-info.rst b/Documentation/linux_tv/media/dvb/ca-get-slot-info.rst
new file mode 100644
index 000000000000..8c123aaf5538
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/ca-get-slot-info.rst
@@ -0,0 +1,54 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _CA_GET_SLOT_INFO:
+
+CA_GET_SLOT_INFO
+================
+
+Description
+-----------
+
+This ioctl is undocumented. Documentation is welcome.
+
+Synopsis
+--------
+
+.. cpp:function:: int  ioctl(fd, int request = CA_GET_SLOT_INFO, ca_slot_info_t *)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals CA_GET_SLOT_INFO for this command.
+
+    -  .. row 3
+
+       -  ca_slot_info_t \*
+
+       -  Undocumented.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
diff --git a/Documentation/linux_tv/media/dvb/ca-reset.rst b/Documentation/linux_tv/media/dvb/ca-reset.rst
new file mode 100644
index 000000000000..4fa2597ea983
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/ca-reset.rst
@@ -0,0 +1,48 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _CA_RESET:
+
+CA_RESET
+========
+
+Description
+-----------
+
+This ioctl is undocumented. Documentation is welcome.
+
+Synopsis
+--------
+
+.. cpp:function:: int  ioctl(fd, int request = CA_RESET)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals CA_RESET for this command.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
diff --git a/Documentation/linux_tv/media/dvb/ca-send-msg.rst b/Documentation/linux_tv/media/dvb/ca-send-msg.rst
new file mode 100644
index 000000000000..cb9249561d8a
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/ca-send-msg.rst
@@ -0,0 +1,54 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _CA_SEND_MSG:
+
+CA_SEND_MSG
+===========
+
+Description
+-----------
+
+This ioctl is undocumented. Documentation is welcome.
+
+Synopsis
+--------
+
+.. cpp:function:: int  ioctl(fd, int request = CA_SEND_MSG, ca_msg_t *)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals CA_SEND_MSG for this command.
+
+    -  .. row 3
+
+       -  ca_msg_t \*
+
+       -  Undocumented.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
diff --git a/Documentation/linux_tv/media/dvb/ca-set-descr.rst b/Documentation/linux_tv/media/dvb/ca-set-descr.rst
new file mode 100644
index 000000000000..5b56e414da24
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/ca-set-descr.rst
@@ -0,0 +1,54 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _CA_SET_DESCR:
+
+CA_SET_DESCR
+============
+
+Description
+-----------
+
+This ioctl is undocumented. Documentation is welcome.
+
+Synopsis
+--------
+
+.. cpp:function:: int  ioctl(fd, int request = CA_SET_DESCR, ca_descr_t *)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals CA_SET_DESCR for this command.
+
+    -  .. row 3
+
+       -  ca_descr_t \*
+
+       -  Undocumented.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
diff --git a/Documentation/linux_tv/media/dvb/ca-set-pid.rst b/Documentation/linux_tv/media/dvb/ca-set-pid.rst
new file mode 100644
index 000000000000..3d4b7e823c15
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/ca-set-pid.rst
@@ -0,0 +1,52 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _CA_SET_PID:
+
+CA_SET_PID
+==========
+
+Description
+-----------
+
+This ioctl is undocumented. Documentation is welcome.
+
+Synopsis
+--------
+
+.. cpp:function:: int  ioctl(fd, int request = CA_SET_PID, ca_pid_t *)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals CA_SET_PID for this command.
+
+    -  .. row 3
+
+       -  ca_pid_t \*
+
+       -  Undocumented.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/linux_tv/media/dvb/ca_function_calls.rst b/Documentation/linux_tv/media/dvb/ca_function_calls.rst
index 754e612de70f..c085a0ebbc05 100644
--- a/Documentation/linux_tv/media/dvb/ca_function_calls.rst
+++ b/Documentation/linux_tv/media/dvb/ca_function_calls.rst
@@ -6,567 +6,16 @@
 CA Function Calls
 *****************
 
-
-.. _ca_fopen:
-
-DVB CA open()
-=============
-
-Description
------------
-
-This system call opens a named ca device (e.g. /dev/ost/ca) for
-subsequent use.
-
-When an open() call has succeeded, the device will be ready for use. The
-significance of blocking or non-blocking mode is described in the
-documentation for functions where there is a difference. It does not
-affect the semantics of the open() call itself. A device opened in
-blocking mode can later be put into non-blocking mode (and vice versa)
-using the F_SETFL command of the fcntl system call. This is a standard
-system call, documented in the Linux manual page for fcntl. Only one
-user can open the CA Device in O_RDWR mode. All other attempts to open
-the device in this mode will fail, and an error code will be returned.
-
-Synopsis
---------
-
-.. cpp:function:: int  open(const char *deviceName, int flags)
-
-Arguments
-----------
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
-       -  const char \*deviceName
-
-       -  Name of specific video device.
-
-    -  .. row 2
-
-       -  int flags
-
-       -  A bit-wise OR of the following flags:
-
-    -  .. row 3
-
-       -
-       -  O_RDONLY read-only access
-
-    -  .. row 4
-
-       -
-       -  O_RDWR read/write access
-
-    -  .. row 5
-
-       -
-       -  O_NONBLOCK open in non-blocking mode
-
-    -  .. row 6
-
-       -
-       -  (blocking mode is the default)
-
-
-Return Value
-------------
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
-       -  ``ENODEV``
-
-       -  Device driver not loaded/available.
-
-    -  .. row 2
-
-       -  ``EINTERNAL``
-
-       -  Internal error.
-
-    -  .. row 3
-
-       -  ``EBUSY``
-
-       -  Device or resource busy.
-
-    -  .. row 4
-
-       -  ``EINVAL``
-
-       -  Invalid argument.
-
-
-
-.. _ca_fclose:
-
-DVB CA close()
-==============
-
-Description
------------
-
-This system call closes a previously opened audio device.
-
-Synopsis
---------
-
-.. cpp:function:: int  close(int fd)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-
-Return Value
-------------
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
-       -  ``EBADF``
-
-       -  fd is not a valid open file descriptor.
-
-
-
-.. _CA_RESET:
-
-CA_RESET
-========
-
-Description
------------
-
-This ioctl is undocumented. Documentation is welcome.
-
-Synopsis
---------
-
-.. cpp:function:: int  ioctl(fd, int request = CA_RESET)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals CA_RESET for this command.
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
-.. _CA_GET_CAP:
-
-CA_GET_CAP
-==========
-
-Description
------------
-
-This ioctl is undocumented. Documentation is welcome.
-
-Synopsis
---------
-
-.. cpp:function:: int  ioctl(fd, int request = CA_GET_CAP, ca_caps_t *)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals CA_GET_CAP for this command.
-
-    -  .. row 3
-
-       -  ca_caps_t *
-
-       -  Undocumented.
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
-.. _CA_GET_SLOT_INFO:
-
-CA_GET_SLOT_INFO
-================
-
-Description
------------
-
-This ioctl is undocumented. Documentation is welcome.
-
-Synopsis
---------
-
-.. cpp:function:: int  ioctl(fd, int request = CA_GET_SLOT_INFO, ca_slot_info_t *)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals CA_GET_SLOT_INFO for this command.
-
-    -  .. row 3
-
-       -  ca_slot_info_t \*
-
-       -  Undocumented.
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
-.. _CA_GET_DESCR_INFO:
-
-CA_GET_DESCR_INFO
-=================
-
-Description
------------
-
-This ioctl is undocumented. Documentation is welcome.
-
-Synopsis
---------
-
-.. cpp:function:: int  ioctl(fd, int request = CA_GET_DESCR_INFO, ca_descr_info_t *)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals CA_GET_DESCR_INFO for this command.
-
-    -  .. row 3
-
-       -  ca_descr_info_t \*
-
-       -  Undocumented.
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
-.. _CA_GET_MSG:
-
-CA_GET_MSG
-==========
-
-Description
------------
-
-This ioctl is undocumented. Documentation is welcome.
-
-Synopsis
---------
-
-.. cpp:function:: int  ioctl(fd, int request = CA_GET_MSG, ca_msg_t *)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals CA_GET_MSG for this command.
-
-    -  .. row 3
-
-       -  ca_msg_t \*
-
-       -  Undocumented.
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
-.. _CA_SEND_MSG:
-
-CA_SEND_MSG
-===========
-
-Description
------------
-
-This ioctl is undocumented. Documentation is welcome.
-
-Synopsis
---------
-
-.. cpp:function:: int  ioctl(fd, int request = CA_SEND_MSG, ca_msg_t *)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals CA_SEND_MSG for this command.
-
-    -  .. row 3
-
-       -  ca_msg_t \*
-
-       -  Undocumented.
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
-.. _CA_SET_DESCR:
-
-CA_SET_DESCR
-============
-
-Description
------------
-
-This ioctl is undocumented. Documentation is welcome.
-
-Synopsis
---------
-
-.. cpp:function:: int  ioctl(fd, int request = CA_SET_DESCR, ca_descr_t *)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals CA_SET_DESCR for this command.
-
-    -  .. row 3
-
-       -  ca_descr_t \*
-
-       -  Undocumented.
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
-.. _CA_SET_PID:
-
-CA_SET_PID
-==========
-
-Description
------------
-
-This ioctl is undocumented. Documentation is welcome.
-
-Synopsis
---------
-
-.. cpp:function:: int  ioctl(fd, int request = CA_SET_PID, ca_pid_t *)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals CA_SET_PID for this command.
-
-    -  .. row 3
-
-       -  ca_pid_t \*
-
-       -  Undocumented.
-
-
-Return Value
-------------
-
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
-:ref:`Generic Error Codes <gen-errors>` chapter.
+.. toctree::
+    :maxdepth: 1
+
+    ca-fopen
+    ca-fclose
+    ca-reset
+    ca-get-cap
+    ca-get-slot-info
+    ca-get-descr-info
+    ca-get-msg
+    ca-send-msg
+    ca-set-descr
+    ca-set-pid
diff --git a/Documentation/linux_tv/media/dvb/dmx-add-pid.rst b/Documentation/linux_tv/media/dvb/dmx-add-pid.rst
new file mode 100644
index 000000000000..d6fd0a351a51
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/dmx-add-pid.rst
@@ -0,0 +1,56 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _DMX_ADD_PID:
+
+DMX_ADD_PID
+===========
+
+Description
+-----------
+
+This ioctl call allows to add multiple PIDs to a transport stream filter
+previously set up with DMX_SET_PES_FILTER and output equal to
+DMX_OUT_TSDEMUX_TAP.
+
+Synopsis
+--------
+
+.. c:function:: int ioctl(fd, int request = DMX_ADD_PID, __u16 *)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals DMX_ADD_PID for this command.
+
+    -  .. row 3
+
+       -  __u16 *
+
+       -  PID number to be filtered.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
diff --git a/Documentation/linux_tv/media/dvb/dmx-fclose.rst b/Documentation/linux_tv/media/dvb/dmx-fclose.rst
new file mode 100644
index 000000000000..079e944b8fc8
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/dmx-fclose.rst
@@ -0,0 +1,53 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _dmx_fclose:
+
+DVB demux close()
+=================
+
+Description
+-----------
+
+This system call deactivates and deallocates a filter that was
+previously allocated via the open() call.
+
+Synopsis
+--------
+
+.. c:function:: int close(int fd)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+
+Return Value
+------------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  ``EBADF``
+
+       -  fd is not a valid open file descriptor.
+
+
+
diff --git a/Documentation/linux_tv/media/dvb/dmx-fopen.rst b/Documentation/linux_tv/media/dvb/dmx-fopen.rst
new file mode 100644
index 000000000000..9d6d84d7b608
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/dmx-fopen.rst
@@ -0,0 +1,106 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _dmx_fopen:
+
+DVB demux open()
+================
+
+Description
+-----------
+
+This system call, used with a device name of /dev/dvb/adapter0/demux0,
+allocates a new filter and returns a handle which can be used for
+subsequent control of that filter. This call has to be made for each
+filter to be used, i.e. every returned file descriptor is a reference to
+a single filter. /dev/dvb/adapter0/dvr0 is a logical device to be used
+for retrieving Transport Streams for digital video recording. When
+reading from this device a transport stream containing the packets from
+all PES filters set in the corresponding demux device
+(/dev/dvb/adapter0/demux0) having the output set to DMX_OUT_TS_TAP. A
+recorded Transport Stream is replayed by writing to this device.
+
+The significance of blocking or non-blocking mode is described in the
+documentation for functions where there is a difference. It does not
+affect the semantics of the open() call itself. A device opened in
+blocking mode can later be put into non-blocking mode (and vice versa)
+using the F_SETFL command of the fcntl system call.
+
+Synopsis
+--------
+
+.. c:function:: int open(const char *deviceName, int flags)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  const char \*deviceName
+
+       -  Name of demux device.
+
+    -  .. row 2
+
+       -  int flags
+
+       -  A bit-wise OR of the following flags:
+
+    -  .. row 3
+
+       -
+       -  O_RDWR read/write access
+
+    -  .. row 4
+
+       -
+       -  O_NONBLOCK open in non-blocking mode
+
+    -  .. row 5
+
+       -
+       -  (blocking mode is the default)
+
+
+Return Value
+------------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  ``ENODEV``
+
+       -  Device driver not loaded/available.
+
+    -  .. row 2
+
+       -  ``EINVAL``
+
+       -  Invalid argument.
+
+    -  .. row 3
+
+       -  ``EMFILE``
+
+       -  “Too many open files”, i.e. no more filters available.
+
+    -  .. row 4
+
+       -  ``ENOMEM``
+
+       -  The driver failed to allocate enough memory.
+
+
+
diff --git a/Documentation/linux_tv/media/dvb/dmx-fread.rst b/Documentation/linux_tv/media/dvb/dmx-fread.rst
new file mode 100644
index 000000000000..66811dbe6dac
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/dmx-fread.rst
@@ -0,0 +1,106 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _dmx_fread:
+
+DVB demux read()
+================
+
+Description
+-----------
+
+This system call returns filtered data, which might be section or PES
+data. The filtered data is transferred from the driver’s internal
+circular buffer to buf. The maximum amount of data to be transferred is
+implied by count.
+
+Synopsis
+--------
+
+.. c:function:: size_t read(int fd, void *buf, size_t count)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  void \*buf
+
+       -  Pointer to the buffer to be used for returned filtered data.
+
+    -  .. row 3
+
+       -  size_t count
+
+       -  Size of buf.
+
+
+Return Value
+------------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  ``EWOULDBLOCK``
+
+       -  No data to return and O_NONBLOCK was specified.
+
+    -  .. row 2
+
+       -  ``EBADF``
+
+       -  fd is not a valid open file descriptor.
+
+    -  .. row 3
+
+       -  ``ECRC``
+
+       -  Last section had a CRC error - no data returned. The buffer is
+	  flushed.
+
+    -  .. row 4
+
+       -  ``EOVERFLOW``
+
+       -
+
+    -  .. row 5
+
+       -
+       -  The filtered data was not read from the buffer in due time,
+	  resulting in non-read data being lost. The buffer is flushed.
+
+    -  .. row 6
+
+       -  ``ETIMEDOUT``
+
+       -  The section was not loaded within the stated timeout period. See
+	  ioctl DMX_SET_FILTER for how to set a timeout.
+
+    -  .. row 7
+
+       -  ``EFAULT``
+
+       -  The driver failed to write to the callers buffer due to an invalid
+	  \*buf pointer.
+
+
+
diff --git a/Documentation/linux_tv/media/dvb/dmx-fwrite.rst b/Documentation/linux_tv/media/dvb/dmx-fwrite.rst
new file mode 100644
index 000000000000..57aef82c77b2
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/dmx-fwrite.rst
@@ -0,0 +1,87 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _dmx_fwrite:
+
+DVB demux write()
+=================
+
+Description
+-----------
+
+This system call is only provided by the logical device
+/dev/dvb/adapter0/dvr0, associated with the physical demux device that
+provides the actual DVR functionality. It is used for replay of a
+digitally recorded Transport Stream. Matching filters have to be defined
+in the corresponding physical demux device, /dev/dvb/adapter0/demux0.
+The amount of data to be transferred is implied by count.
+
+Synopsis
+--------
+
+.. c:function:: ssize_t write(int fd, const void *buf, size_t count)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  void \*buf
+
+       -  Pointer to the buffer containing the Transport Stream.
+
+    -  .. row 3
+
+       -  size_t count
+
+       -  Size of buf.
+
+
+Return Value
+------------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  ``EWOULDBLOCK``
+
+       -  No data was written. This might happen if O_NONBLOCK was
+	  specified and there is no more buffer space available (if
+	  O_NONBLOCK is not specified the function will block until buffer
+	  space is available).
+
+    -  .. row 2
+
+       -  ``EBUSY``
+
+       -  This error code indicates that there are conflicting requests. The
+	  corresponding demux device is setup to receive data from the
+	  front- end. Make sure that these filters are stopped and that the
+	  filters with input set to DMX_IN_DVR are started.
+
+    -  .. row 3
+
+       -  ``EBADF``
+
+       -  fd is not a valid open file descriptor.
+
+
+
diff --git a/Documentation/linux_tv/media/dvb/dmx-get-caps.rst b/Documentation/linux_tv/media/dvb/dmx-get-caps.rst
new file mode 100644
index 000000000000..56bba7b3fc6c
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/dmx-get-caps.rst
@@ -0,0 +1,54 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _DMX_GET_CAPS:
+
+DMX_GET_CAPS
+============
+
+Description
+-----------
+
+This ioctl is undocumented. Documentation is welcome.
+
+Synopsis
+--------
+
+.. c:function:: int ioctl(fd, int request = DMX_GET_CAPS, dmx_caps_t *)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals DMX_GET_CAPS for this command.
+
+    -  .. row 3
+
+       -  dmx_caps_t *
+
+       -  Undocumented.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
diff --git a/Documentation/linux_tv/media/dvb/dmx-get-event.rst b/Documentation/linux_tv/media/dvb/dmx-get-event.rst
new file mode 100644
index 000000000000..8664d43f4334
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/dmx-get-event.rst
@@ -0,0 +1,72 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _DMX_GET_EVENT:
+
+DMX_GET_EVENT
+=============
+
+Description
+-----------
+
+This ioctl call returns an event if available. If an event is not
+available, the behavior depends on whether the device is in blocking or
+non-blocking mode. In the latter case, the call fails immediately with
+errno set to ``EWOULDBLOCK``. In the former case, the call blocks until an
+event becomes available.
+
+Synopsis
+--------
+
+.. c:function:: int ioctl( int fd, int request = DMX_GET_EVENT, struct dmx_event *ev)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals DMX_GET_EVENT for this command.
+
+    -  .. row 3
+
+       -  struct dmx_event \*ev
+
+       -  Pointer to the location where the event is to be stored.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  ``EWOULDBLOCK``
+
+       -  There is no event pending, and the device is in non-blocking mode.
+
+
+
diff --git a/Documentation/linux_tv/media/dvb/dmx-get-pes-pids.rst b/Documentation/linux_tv/media/dvb/dmx-get-pes-pids.rst
new file mode 100644
index 000000000000..39d6ae6db620
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/dmx-get-pes-pids.rst
@@ -0,0 +1,54 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _DMX_GET_PES_PIDS:
+
+DMX_GET_PES_PIDS
+================
+
+Description
+-----------
+
+This ioctl is undocumented. Documentation is welcome.
+
+Synopsis
+--------
+
+.. c:function:: int ioctl(fd, int request = DMX_GET_PES_PIDS, __u16[5])
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals DMX_GET_PES_PIDS for this command.
+
+    -  .. row 3
+
+       -  __u16[5]
+
+       -  Undocumented.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
diff --git a/Documentation/linux_tv/media/dvb/dmx-get-stc.rst b/Documentation/linux_tv/media/dvb/dmx-get-stc.rst
new file mode 100644
index 000000000000..6081d959b4ad
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/dmx-get-stc.rst
@@ -0,0 +1,73 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _DMX_GET_STC:
+
+DMX_GET_STC
+===========
+
+Description
+-----------
+
+This ioctl call returns the current value of the system time counter
+(which is driven by a PES filter of type DMX_PES_PCR). Some hardware
+supports more than one STC, so you must specify which one by setting the
+num field of stc before the ioctl (range 0...n). The result is returned
+in form of a ratio with a 64 bit numerator and a 32 bit denominator, so
+the real 90kHz STC value is stc->stc / stc->base .
+
+Synopsis
+--------
+
+.. c:function:: int ioctl( int fd, int request = DMX_GET_STC, struct dmx_stc *stc)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals DMX_GET_STC for this command.
+
+    -  .. row 3
+
+       -  struct dmx_stc \*stc
+
+       -  Pointer to the location where the stc is to be stored.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  ``EINVAL``
+
+       -  Invalid stc number.
+
+
+
diff --git a/Documentation/linux_tv/media/dvb/dmx-remove-pid.rst b/Documentation/linux_tv/media/dvb/dmx-remove-pid.rst
new file mode 100644
index 000000000000..9e38eb8db6f8
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/dmx-remove-pid.rst
@@ -0,0 +1,55 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _DMX_REMOVE_PID:
+
+DMX_REMOVE_PID
+==============
+
+Description
+-----------
+
+This ioctl call allows to remove a PID when multiple PIDs are set on a
+transport stream filter, e. g. a filter previously set up with output
+equal to DMX_OUT_TSDEMUX_TAP, created via either
+DMX_SET_PES_FILTER or DMX_ADD_PID.
+
+Synopsis
+--------
+
+.. c:function:: int ioctl(fd, int request = DMX_REMOVE_PID, __u16 *)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals DMX_REMOVE_PID for this command.
+
+    -  .. row 3
+
+       -  __u16 *
+
+       -  PID of the PES filter to be removed.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/linux_tv/media/dvb/dmx-set-buffer-size.rst b/Documentation/linux_tv/media/dvb/dmx-set-buffer-size.rst
new file mode 100644
index 000000000000..a5074a6ac48e
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/dmx-set-buffer-size.rst
@@ -0,0 +1,57 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _DMX_SET_BUFFER_SIZE:
+
+DMX_SET_BUFFER_SIZE
+===================
+
+Description
+-----------
+
+This ioctl call is used to set the size of the circular buffer used for
+filtered data. The default size is two maximum sized sections, i.e. if
+this function is not called a buffer size of 2 \* 4096 bytes will be
+used.
+
+Synopsis
+--------
+
+.. c:function:: int ioctl( int fd, int request = DMX_SET_BUFFER_SIZE, unsigned long size)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals DMX_SET_BUFFER_SIZE for this command.
+
+    -  .. row 3
+
+       -  unsigned long size
+
+       -  Size of circular buffer.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
diff --git a/Documentation/linux_tv/media/dvb/dmx-set-filter.rst b/Documentation/linux_tv/media/dvb/dmx-set-filter.rst
new file mode 100644
index 000000000000..548af600d635
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/dmx-set-filter.rst
@@ -0,0 +1,63 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _DMX_SET_FILTER:
+
+DMX_SET_FILTER
+==============
+
+Description
+-----------
+
+This ioctl call sets up a filter according to the filter and mask
+parameters provided. A timeout may be defined stating number of seconds
+to wait for a section to be loaded. A value of 0 means that no timeout
+should be applied. Finally there is a flag field where it is possible to
+state whether a section should be CRC-checked, whether the filter should
+be a ”one-shot” filter, i.e. if the filtering operation should be
+stopped after the first section is received, and whether the filtering
+operation should be started immediately (without waiting for a
+DMX_START ioctl call). If a filter was previously set-up, this filter
+will be canceled, and the receive buffer will be flushed.
+
+Synopsis
+--------
+
+.. c:function:: int ioctl( int fd, int request = DMX_SET_FILTER, struct dmx_sct_filter_params *params)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals DMX_SET_FILTER for this command.
+
+    -  .. row 3
+
+       -  struct dmx_sct_filter_params \*params
+
+       -  Pointer to structure containing filter parameters.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
diff --git a/Documentation/linux_tv/media/dvb/dmx-set-pes-filter.rst b/Documentation/linux_tv/media/dvb/dmx-set-pes-filter.rst
new file mode 100644
index 000000000000..7d9b6dabc772
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/dmx-set-pes-filter.rst
@@ -0,0 +1,74 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _DMX_SET_PES_FILTER:
+
+DMX_SET_PES_FILTER
+==================
+
+Description
+-----------
+
+This ioctl call sets up a PES filter according to the parameters
+provided. By a PES filter is meant a filter that is based just on the
+packet identifier (PID), i.e. no PES header or payload filtering
+capability is supported.
+
+Synopsis
+--------
+
+.. c:function:: int ioctl( int fd, int request = DMX_SET_PES_FILTER, struct dmx_pes_filter_params *params)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals DMX_SET_PES_FILTER for this command.
+
+    -  .. row 3
+
+       -  struct dmx_pes_filter_params \*params
+
+       -  Pointer to structure containing filter parameters.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  ``EBUSY``
+
+       -  This error code indicates that there are conflicting requests.
+	  There are active filters filtering data from another input source.
+	  Make sure that these filters are stopped before starting this
+	  filter.
+
+
+
diff --git a/Documentation/linux_tv/media/dvb/dmx-set-source.rst b/Documentation/linux_tv/media/dvb/dmx-set-source.rst
new file mode 100644
index 000000000000..e97b1c962ed6
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/dmx-set-source.rst
@@ -0,0 +1,54 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _DMX_SET_SOURCE:
+
+DMX_SET_SOURCE
+==============
+
+Description
+-----------
+
+This ioctl is undocumented. Documentation is welcome.
+
+Synopsis
+--------
+
+.. c:function:: int ioctl(fd, int request = DMX_SET_SOURCE, dmx_source_t *)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals DMX_SET_SOURCE for this command.
+
+    -  .. row 3
+
+       -  dmx_source_t *
+
+       -  Undocumented.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
diff --git a/Documentation/linux_tv/media/dvb/dmx-start.rst b/Documentation/linux_tv/media/dvb/dmx-start.rst
new file mode 100644
index 000000000000..dd446da18f97
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/dmx-start.rst
@@ -0,0 +1,73 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _DMX_START:
+
+DMX_START
+=========
+
+Description
+-----------
+
+This ioctl call is used to start the actual filtering operation defined
+via the ioctl calls DMX_SET_FILTER or DMX_SET_PES_FILTER.
+
+Synopsis
+--------
+
+.. c:function:: int ioctl( int fd, int request = DMX_START)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals DMX_START for this command.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  ``EINVAL``
+
+       -  Invalid argument, i.e. no filtering parameters provided via the
+	  DMX_SET_FILTER or DMX_SET_PES_FILTER functions.
+
+    -  .. row 2
+
+       -  ``EBUSY``
+
+       -  This error code indicates that there are conflicting requests.
+	  There are active filters filtering data from another input source.
+	  Make sure that these filters are stopped before starting this
+	  filter.
+
+
+
diff --git a/Documentation/linux_tv/media/dvb/dmx-stop.rst b/Documentation/linux_tv/media/dvb/dmx-stop.rst
new file mode 100644
index 000000000000..150c9f79b55f
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/dmx-stop.rst
@@ -0,0 +1,50 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _DMX_STOP:
+
+DMX_STOP
+========
+
+Description
+-----------
+
+This ioctl call is used to stop the actual filtering operation defined
+via the ioctl calls DMX_SET_FILTER or DMX_SET_PES_FILTER and
+started via the DMX_START command.
+
+Synopsis
+--------
+
+.. c:function:: int ioctl( int fd, int request = DMX_STOP)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals DMX_STOP for this command.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
diff --git a/Documentation/linux_tv/media/dvb/dmx_fcalls.rst b/Documentation/linux_tv/media/dvb/dmx_fcalls.rst
index 14335f2d2e3b..77a1554d9834 100644
--- a/Documentation/linux_tv/media/dvb/dmx_fcalls.rst
+++ b/Documentation/linux_tv/media/dvb/dmx_fcalls.rst
@@ -6,1059 +6,22 @@
 Demux Function Calls
 ********************
 
-
-.. _dmx_fopen:
-
-DVB demux open()
-================
-
-Description
------------
-
-This system call, used with a device name of /dev/dvb/adapter0/demux0,
-allocates a new filter and returns a handle which can be used for
-subsequent control of that filter. This call has to be made for each
-filter to be used, i.e. every returned file descriptor is a reference to
-a single filter. /dev/dvb/adapter0/dvr0 is a logical device to be used
-for retrieving Transport Streams for digital video recording. When
-reading from this device a transport stream containing the packets from
-all PES filters set in the corresponding demux device
-(/dev/dvb/adapter0/demux0) having the output set to DMX_OUT_TS_TAP. A
-recorded Transport Stream is replayed by writing to this device.
-
-The significance of blocking or non-blocking mode is described in the
-documentation for functions where there is a difference. It does not
-affect the semantics of the open() call itself. A device opened in
-blocking mode can later be put into non-blocking mode (and vice versa)
-using the F_SETFL command of the fcntl system call.
-
-Synopsis
---------
-
-.. c:function:: int open(const char *deviceName, int flags)
-
-Arguments
-----------
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
-       -  const char \*deviceName
-
-       -  Name of demux device.
-
-    -  .. row 2
-
-       -  int flags
-
-       -  A bit-wise OR of the following flags:
-
-    -  .. row 3
-
-       -
-       -  O_RDWR read/write access
-
-    -  .. row 4
-
-       -
-       -  O_NONBLOCK open in non-blocking mode
-
-    -  .. row 5
-
-       -
-       -  (blocking mode is the default)
-
-
-Return Value
-------------
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
-       -  ``ENODEV``
-
-       -  Device driver not loaded/available.
-
-    -  .. row 2
-
-       -  ``EINVAL``
-
-       -  Invalid argument.
-
-    -  .. row 3
-
-       -  ``EMFILE``
-
-       -  “Too many open files”, i.e. no more filters available.
-
-    -  .. row 4
-
-       -  ``ENOMEM``
-
-       -  The driver failed to allocate enough memory.
-
-
-
-.. _dmx_fclose:
-
-DVB demux close()
-=================
-
-Description
------------
-
-This system call deactivates and deallocates a filter that was
-previously allocated via the open() call.
-
-Synopsis
---------
-
-.. c:function:: int close(int fd)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-
-Return Value
-------------
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
-       -  ``EBADF``
-
-       -  fd is not a valid open file descriptor.
-
-
-
-.. _dmx_fread:
-
-DVB demux read()
-================
-
-Description
------------
-
-This system call returns filtered data, which might be section or PES
-data. The filtered data is transferred from the driver’s internal
-circular buffer to buf. The maximum amount of data to be transferred is
-implied by count.
-
-Synopsis
---------
-
-.. c:function:: size_t read(int fd, void *buf, size_t count)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  void \*buf
-
-       -  Pointer to the buffer to be used for returned filtered data.
-
-    -  .. row 3
-
-       -  size_t count
-
-       -  Size of buf.
-
-
-Return Value
-------------
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
-       -  ``EWOULDBLOCK``
-
-       -  No data to return and O_NONBLOCK was specified.
-
-    -  .. row 2
-
-       -  ``EBADF``
-
-       -  fd is not a valid open file descriptor.
-
-    -  .. row 3
-
-       -  ``ECRC``
-
-       -  Last section had a CRC error - no data returned. The buffer is
-	  flushed.
-
-    -  .. row 4
-
-       -  ``EOVERFLOW``
-
-       -
-
-    -  .. row 5
-
-       -
-       -  The filtered data was not read from the buffer in due time,
-	  resulting in non-read data being lost. The buffer is flushed.
-
-    -  .. row 6
-
-       -  ``ETIMEDOUT``
-
-       -  The section was not loaded within the stated timeout period. See
-	  ioctl DMX_SET_FILTER for how to set a timeout.
-
-    -  .. row 7
-
-       -  ``EFAULT``
-
-       -  The driver failed to write to the callers buffer due to an invalid
-	  \*buf pointer.
-
-
-
-.. _dmx_fwrite:
-
-DVB demux write()
-=================
-
-Description
------------
-
-This system call is only provided by the logical device
-/dev/dvb/adapter0/dvr0, associated with the physical demux device that
-provides the actual DVR functionality. It is used for replay of a
-digitally recorded Transport Stream. Matching filters have to be defined
-in the corresponding physical demux device, /dev/dvb/adapter0/demux0.
-The amount of data to be transferred is implied by count.
-
-Synopsis
---------
-
-.. c:function:: ssize_t write(int fd, const void *buf, size_t count)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  void \*buf
-
-       -  Pointer to the buffer containing the Transport Stream.
-
-    -  .. row 3
-
-       -  size_t count
-
-       -  Size of buf.
-
-
-Return Value
-------------
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
-       -  ``EWOULDBLOCK``
-
-       -  No data was written. This might happen if O_NONBLOCK was
-	  specified and there is no more buffer space available (if
-	  O_NONBLOCK is not specified the function will block until buffer
-	  space is available).
-
-    -  .. row 2
-
-       -  ``EBUSY``
-
-       -  This error code indicates that there are conflicting requests. The
-	  corresponding demux device is setup to receive data from the
-	  front- end. Make sure that these filters are stopped and that the
-	  filters with input set to DMX_IN_DVR are started.
-
-    -  .. row 3
-
-       -  ``EBADF``
-
-       -  fd is not a valid open file descriptor.
-
-
-
-.. _DMX_START:
-
-DMX_START
-=========
-
-Description
------------
-
-This ioctl call is used to start the actual filtering operation defined
-via the ioctl calls DMX_SET_FILTER or DMX_SET_PES_FILTER.
-
-Synopsis
---------
-
-.. c:function:: int ioctl( int fd, int request = DMX_START)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals DMX_START for this command.
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
-       -  Invalid argument, i.e. no filtering parameters provided via the
-	  DMX_SET_FILTER or DMX_SET_PES_FILTER functions.
-
-    -  .. row 2
-
-       -  ``EBUSY``
-
-       -  This error code indicates that there are conflicting requests.
-	  There are active filters filtering data from another input source.
-	  Make sure that these filters are stopped before starting this
-	  filter.
-
-
-
-.. _DMX_STOP:
-
-DMX_STOP
-========
-
-Description
------------
-
-This ioctl call is used to stop the actual filtering operation defined
-via the ioctl calls DMX_SET_FILTER or DMX_SET_PES_FILTER and
-started via the DMX_START command.
-
-Synopsis
---------
-
-.. c:function:: int ioctl( int fd, int request = DMX_STOP)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals DMX_STOP for this command.
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
-.. _DMX_SET_FILTER:
-
-DMX_SET_FILTER
-==============
-
-Description
------------
-
-This ioctl call sets up a filter according to the filter and mask
-parameters provided. A timeout may be defined stating number of seconds
-to wait for a section to be loaded. A value of 0 means that no timeout
-should be applied. Finally there is a flag field where it is possible to
-state whether a section should be CRC-checked, whether the filter should
-be a ”one-shot” filter, i.e. if the filtering operation should be
-stopped after the first section is received, and whether the filtering
-operation should be started immediately (without waiting for a
-DMX_START ioctl call). If a filter was previously set-up, this filter
-will be canceled, and the receive buffer will be flushed.
-
-Synopsis
---------
-
-.. c:function:: int ioctl( int fd, int request = DMX_SET_FILTER, struct dmx_sct_filter_params *params)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals DMX_SET_FILTER for this command.
-
-    -  .. row 3
-
-       -  struct dmx_sct_filter_params \*params
-
-       -  Pointer to structure containing filter parameters.
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
-.. _DMX_SET_PES_FILTER:
-
-DMX_SET_PES_FILTER
-==================
-
-Description
------------
-
-This ioctl call sets up a PES filter according to the parameters
-provided. By a PES filter is meant a filter that is based just on the
-packet identifier (PID), i.e. no PES header or payload filtering
-capability is supported.
-
-Synopsis
---------
-
-.. c:function:: int ioctl( int fd, int request = DMX_SET_PES_FILTER, struct dmx_pes_filter_params *params)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals DMX_SET_PES_FILTER for this command.
-
-    -  .. row 3
-
-       -  struct dmx_pes_filter_params \*params
-
-       -  Pointer to structure containing filter parameters.
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
-       -  ``EBUSY``
-
-       -  This error code indicates that there are conflicting requests.
-	  There are active filters filtering data from another input source.
-	  Make sure that these filters are stopped before starting this
-	  filter.
-
-
-
-.. _DMX_SET_BUFFER_SIZE:
-
-DMX_SET_BUFFER_SIZE
-===================
-
-Description
------------
-
-This ioctl call is used to set the size of the circular buffer used for
-filtered data. The default size is two maximum sized sections, i.e. if
-this function is not called a buffer size of 2 \* 4096 bytes will be
-used.
-
-Synopsis
---------
-
-.. c:function:: int ioctl( int fd, int request = DMX_SET_BUFFER_SIZE, unsigned long size)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals DMX_SET_BUFFER_SIZE for this command.
-
-    -  .. row 3
-
-       -  unsigned long size
-
-       -  Size of circular buffer.
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
-.. _DMX_GET_EVENT:
-
-DMX_GET_EVENT
-=============
-
-Description
------------
-
-This ioctl call returns an event if available. If an event is not
-available, the behavior depends on whether the device is in blocking or
-non-blocking mode. In the latter case, the call fails immediately with
-errno set to ``EWOULDBLOCK``. In the former case, the call blocks until an
-event becomes available.
-
-Synopsis
---------
-
-.. c:function:: int ioctl( int fd, int request = DMX_GET_EVENT, struct dmx_event *ev)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals DMX_GET_EVENT for this command.
-
-    -  .. row 3
-
-       -  struct dmx_event \*ev
-
-       -  Pointer to the location where the event is to be stored.
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
-       -  ``EWOULDBLOCK``
-
-       -  There is no event pending, and the device is in non-blocking mode.
-
-
-
-.. _DMX_GET_STC:
-
-DMX_GET_STC
-===========
-
-Description
------------
-
-This ioctl call returns the current value of the system time counter
-(which is driven by a PES filter of type DMX_PES_PCR). Some hardware
-supports more than one STC, so you must specify which one by setting the
-num field of stc before the ioctl (range 0...n). The result is returned
-in form of a ratio with a 64 bit numerator and a 32 bit denominator, so
-the real 90kHz STC value is stc->stc / stc->base .
-
-Synopsis
---------
-
-.. c:function:: int ioctl( int fd, int request = DMX_GET_STC, struct dmx_stc *stc)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals DMX_GET_STC for this command.
-
-    -  .. row 3
-
-       -  struct dmx_stc \*stc
-
-       -  Pointer to the location where the stc is to be stored.
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
-       -  Invalid stc number.
-
-
-
-.. _DMX_GET_PES_PIDS:
-
-DMX_GET_PES_PIDS
-================
-
-Description
------------
-
-This ioctl is undocumented. Documentation is welcome.
-
-Synopsis
---------
-
-.. c:function:: int ioctl(fd, int request = DMX_GET_PES_PIDS, __u16[5])
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals DMX_GET_PES_PIDS for this command.
-
-    -  .. row 3
-
-       -  __u16[5]
-
-       -  Undocumented.
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
-.. _DMX_GET_CAPS:
-
-DMX_GET_CAPS
-============
-
-Description
------------
-
-This ioctl is undocumented. Documentation is welcome.
-
-Synopsis
---------
-
-.. c:function:: int ioctl(fd, int request = DMX_GET_CAPS, dmx_caps_t *)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals DMX_GET_CAPS for this command.
-
-    -  .. row 3
-
-       -  dmx_caps_t *
-
-       -  Undocumented.
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
-.. _DMX_SET_SOURCE:
-
-DMX_SET_SOURCE
-==============
-
-Description
------------
-
-This ioctl is undocumented. Documentation is welcome.
-
-Synopsis
---------
-
-.. c:function:: int ioctl(fd, int request = DMX_SET_SOURCE, dmx_source_t *)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals DMX_SET_SOURCE for this command.
-
-    -  .. row 3
-
-       -  dmx_source_t *
-
-       -  Undocumented.
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
-.. _DMX_ADD_PID:
-
-DMX_ADD_PID
-===========
-
-Description
------------
-
-This ioctl call allows to add multiple PIDs to a transport stream filter
-previously set up with DMX_SET_PES_FILTER and output equal to
-DMX_OUT_TSDEMUX_TAP.
-
-Synopsis
---------
-
-.. c:function:: int ioctl(fd, int request = DMX_ADD_PID, __u16 *)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals DMX_ADD_PID for this command.
-
-    -  .. row 3
-
-       -  __u16 *
-
-       -  PID number to be filtered.
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
-.. _DMX_REMOVE_PID:
-
-DMX_REMOVE_PID
-==============
-
-Description
------------
-
-This ioctl call allows to remove a PID when multiple PIDs are set on a
-transport stream filter, e. g. a filter previously set up with output
-equal to DMX_OUT_TSDEMUX_TAP, created via either
-DMX_SET_PES_FILTER or DMX_ADD_PID.
-
-Synopsis
---------
-
-.. c:function:: int ioctl(fd, int request = DMX_REMOVE_PID, __u16 *)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals DMX_REMOVE_PID for this command.
-
-    -  .. row 3
-
-       -  __u16 *
-
-       -  PID of the PES filter to be removed.
-
-
-Return Value
-------------
-
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
-:ref:`Generic Error Codes <gen-errors>` chapter.
+.. toctree::
+    :maxdepth: 1
+
+    dmx-fopen
+    dmx-fclose
+    dmx-fread
+    dmx-fwrite
+    dmx-start
+    dmx-stop
+    dmx-set-filter
+    dmx-set-pes-filter
+    dmx-set-buffer-size
+    dmx-get-event
+    dmx-get-stc
+    dmx-get-pes-pids
+    dmx-get-caps
+    dmx-set-source
+    dmx-add-pid
+    dmx-remove-pid
diff --git a/Documentation/linux_tv/media/dvb/net-add-if.rst b/Documentation/linux_tv/media/dvb/net-add-if.rst
new file mode 100644
index 000000000000..da0e7870c5d9
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/net-add-if.rst
@@ -0,0 +1,87 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _NET_ADD_IF:
+
+****************
+ioctl NET_ADD_IF
+****************
+
+*man NET_ADD_IF(2)*
+
+Creates a new network interface for a given Packet ID.
+
+
+Synopsis
+========
+
+.. cpp:function:: int ioctl( int fd, int request, struct dvb_net_if *net_if )
+
+Arguments
+=========
+
+``fd``
+    File descriptor returned by :ref:`open() <frontend_f_open>`.
+
+``request``
+    FE_SET_TONE
+
+``net_if``
+    pointer to struct :ref:`dvb_net_if <dvb-net-if>`
+
+
+Description
+===========
+
+The NET_ADD_IF ioctl system call selects the Packet ID (PID) that
+contains a TCP/IP traffic, the type of encapsulation to be used (MPE or
+ULE) and the interface number for the new interface to be created. When
+the system call successfully returns, a new virtual network interface is
+created.
+
+The struct :ref:`dvb_net_if <dvb-net-if>`::ifnum field will be
+filled with the number of the created interface.
+
+
+.. _dvb-net-if-t:
+
+struct dvb_net_if description
+=============================
+
+.. _dvb-net-if:
+
+.. flat-table:: struct dvb_net_if
+    :header-rows:  1
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  ID
+
+       -  Description
+
+    -  .. row 2
+
+       -  pid
+
+       -  Packet ID (PID) of the MPEG-TS that contains data
+
+    -  .. row 3
+
+       -  ifnum
+
+       -  number of the DVB interface.
+
+    -  .. row 4
+
+       -  feedtype
+
+       -  Encapsulation type of the feed. It can be:
+	  ``DVB_NET_FEEDTYPE_MPE`` for MPE encoding or
+	  ``DVB_NET_FEEDTYPE_ULE`` for ULE encoding.
+
+RETURN VALUE
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/linux_tv/media/dvb/net-get-if.rst b/Documentation/linux_tv/media/dvb/net-get-if.rst
new file mode 100644
index 000000000000..4581763b920e
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/net-get-if.rst
@@ -0,0 +1,48 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+
+.. _NET_GET_IF:
+
+****************
+ioctl NET_GET_IF
+****************
+
+*man NET_GET_IF(2)*
+
+Read the configuration data of an interface created via
+:ref:`NET_ADD_IF <net>`.
+
+
+Synopsis
+========
+
+.. cpp:function:: int ioctl( int fd, int request, struct dvb_net_if *net_if )
+
+Arguments
+=========
+
+``fd``
+    File descriptor returned by :ref:`open() <frontend_f_open>`.
+
+``request``
+    FE_SET_TONE
+
+``net_if``
+    pointer to struct :ref:`dvb_net_if <dvb-net-if>`
+
+
+Description
+===========
+
+The NET_GET_IF ioctl uses the interface number given by the struct
+:ref:`dvb_net_if <dvb-net-if>`::ifnum field and fills the content of
+struct :ref:`dvb_net_if <dvb-net-if>` with the packet ID and
+encapsulation type used on such interface. If the interface was not
+created yet with :ref:`NET_ADD_IF <net>`, it will return -1 and fill
+the ``errno`` with ``EINVAL`` error code.
+
+RETURN VALUE
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/linux_tv/media/dvb/net-remove-if.rst b/Documentation/linux_tv/media/dvb/net-remove-if.rst
new file mode 100644
index 000000000000..15a5d49f7a80
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/net-remove-if.rst
@@ -0,0 +1,42 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _NET_REMOVE_IF:
+
+*******************
+ioctl NET_REMOVE_IF
+*******************
+
+*man NET_REMOVE_IF(2)*
+
+Removes a network interface.
+
+
+Synopsis
+========
+
+.. cpp:function:: int ioctl( int fd, int request, int ifnum )
+
+Arguments
+=========
+
+``fd``
+    File descriptor returned by :ref:`open() <frontend_f_open>`.
+
+``request``
+    FE_SET_TONE
+
+``net_if``
+    number of the interface to be removed
+
+
+Description
+===========
+
+The NET_REMOVE_IF ioctl deletes an interface previously created via
+:ref:`NET_ADD_IF <net>`.
+
+RETURN VALUE
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/linux_tv/media/dvb/net.rst b/Documentation/linux_tv/media/dvb/net.rst
index c5c42e43d277..eca42dd53261 100644
--- a/Documentation/linux_tv/media/dvb/net.rst
+++ b/Documentation/linux_tv/media/dvb/net.rst
@@ -32,179 +32,9 @@ header.
 DVB net Function Calls
 ######################
 
-.. _NET_ADD_IF:
+.. toctree::
+    :maxdepth: 1
 
-****************
-ioctl NET_ADD_IF
-****************
-
-*man NET_ADD_IF(2)*
-
-Creates a new network interface for a given Packet ID.
-
-
-Synopsis
-========
-
-.. cpp:function:: int ioctl( int fd, int request, struct dvb_net_if *net_if )
-
-Arguments
-=========
-
-``fd``
-    File descriptor returned by :ref:`open() <frontend_f_open>`.
-
-``request``
-    FE_SET_TONE
-
-``net_if``
-    pointer to struct :ref:`dvb_net_if <dvb-net-if>`
-
-
-Description
-===========
-
-The NET_ADD_IF ioctl system call selects the Packet ID (PID) that
-contains a TCP/IP traffic, the type of encapsulation to be used (MPE or
-ULE) and the interface number for the new interface to be created. When
-the system call successfully returns, a new virtual network interface is
-created.
-
-The struct :ref:`dvb_net_if <dvb-net-if>`::ifnum field will be
-filled with the number of the created interface.
-
-RETURN VALUE
-
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
-:ref:`Generic Error Codes <gen-errors>` chapter.
-
-
-.. _dvb-net-if-t:
-
-struct dvb_net_if description
-=============================
-
-
-.. _dvb-net-if:
-
-.. flat-table:: struct dvb_net_if
-    :header-rows:  1
-    :stub-columns: 0
-
-
-    -  .. row 1
-
-       -  ID
-
-       -  Description
-
-    -  .. row 2
-
-       -  pid
-
-       -  Packet ID (PID) of the MPEG-TS that contains data
-
-    -  .. row 3
-
-       -  ifnum
-
-       -  number of the DVB interface.
-
-    -  .. row 4
-
-       -  feedtype
-
-       -  Encapsulation type of the feed. It can be:
-	  ``DVB_NET_FEEDTYPE_MPE`` for MPE encoding or
-	  ``DVB_NET_FEEDTYPE_ULE`` for ULE encoding.
-
-
-
-.. _NET_REMOVE_IF:
-
-*******************
-ioctl NET_REMOVE_IF
-*******************
-
-*man NET_REMOVE_IF(2)*
-
-Removes a network interface.
-
-
-Synopsis
-========
-
-.. cpp:function:: int ioctl( int fd, int request, int ifnum )
-
-Arguments
-=========
-
-``fd``
-    File descriptor returned by :ref:`open() <frontend_f_open>`.
-
-``request``
-    FE_SET_TONE
-
-``net_if``
-    number of the interface to be removed
-
-
-Description
-===========
-
-The NET_REMOVE_IF ioctl deletes an interface previously created via
-:ref:`NET_ADD_IF <net>`.
-
-RETURN VALUE
-
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
-:ref:`Generic Error Codes <gen-errors>` chapter.
-
-
-.. _NET_GET_IF:
-
-****************
-ioctl NET_GET_IF
-****************
-
-*man NET_GET_IF(2)*
-
-Read the configuration data of an interface created via
-:ref:`NET_ADD_IF <net>`.
-
-
-Synopsis
-========
-
-.. cpp:function:: int ioctl( int fd, int request, struct dvb_net_if *net_if )
-
-Arguments
-=========
-
-``fd``
-    File descriptor returned by :ref:`open() <frontend_f_open>`.
-
-``request``
-    FE_SET_TONE
-
-``net_if``
-    pointer to struct :ref:`dvb_net_if <dvb-net-if>`
-
-
-Description
-===========
-
-The NET_GET_IF ioctl uses the interface number given by the struct
-:ref:`dvb_net_if <dvb-net-if>`::ifnum field and fills the content of
-struct :ref:`dvb_net_if <dvb-net-if>` with the packet ID and
-encapsulation type used on such interface. If the interface was not
-created yet with :ref:`NET_ADD_IF <net>`, it will return -1 and fill
-the ``errno`` with ``EINVAL`` error code.
-
-RETURN VALUE
-
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
-:ref:`Generic Error Codes <gen-errors>` chapter.
+    net-add-if
+    net-remove-if
+    net-get-if
diff --git a/Documentation/linux_tv/media/dvb/video-clear-buffer.rst b/Documentation/linux_tv/media/dvb/video-clear-buffer.rst
new file mode 100644
index 000000000000..65efef3cc0fc
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/video-clear-buffer.rst
@@ -0,0 +1,49 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _VIDEO_CLEAR_BUFFER:
+
+VIDEO_CLEAR_BUFFER
+==================
+
+Description
+-----------
+
+This ioctl call clears all video buffers in the driver and in the
+decoder hardware.
+
+Synopsis
+--------
+
+.. c:function:: int ioctl(fd, int request = VIDEO_CLEAR_BUFFER)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals VIDEO_CLEAR_BUFFER for this command.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
diff --git a/Documentation/linux_tv/media/dvb/video-command.rst b/Documentation/linux_tv/media/dvb/video-command.rst
new file mode 100644
index 000000000000..855a646a0f93
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/video-command.rst
@@ -0,0 +1,61 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _VIDEO_COMMAND:
+
+VIDEO_COMMAND
+=============
+
+Description
+-----------
+
+This ioctl is obsolete. Do not use in new drivers. For V4L2 decoders
+this ioctl has been replaced by the
+:ref:`VIDIOC_DECODER_CMD` ioctl.
+
+This ioctl commands the decoder. The ``video_command`` struct is a
+subset of the ``v4l2_decoder_cmd`` struct, so refer to the
+:ref:`VIDIOC_DECODER_CMD` documentation for
+more information.
+
+Synopsis
+--------
+
+.. c:function:: int ioctl(int fd, int request = VIDEO_COMMAND, struct video_command *cmd)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals VIDEO_COMMAND for this command.
+
+    -  .. row 3
+
+       -  struct video_command \*cmd
+
+       -  Commands the decoder.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
diff --git a/Documentation/linux_tv/media/dvb/video-continue.rst b/Documentation/linux_tv/media/dvb/video-continue.rst
new file mode 100644
index 000000000000..9d0f70b7c340
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/video-continue.rst
@@ -0,0 +1,52 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _VIDEO_CONTINUE:
+
+VIDEO_CONTINUE
+==============
+
+Description
+-----------
+
+This ioctl is for DVB devices only. To control a V4L2 decoder use the
+V4L2 :ref:`VIDIOC_DECODER_CMD` instead.
+
+This ioctl call restarts decoding and playing processes of the video
+stream which was played before a call to VIDEO_FREEZE was made.
+
+Synopsis
+--------
+
+.. c:function:: int ioctl(fd, int request = VIDEO_CONTINUE)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals VIDEO_CONTINUE for this command.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
diff --git a/Documentation/linux_tv/media/dvb/video-fast-forward.rst b/Documentation/linux_tv/media/dvb/video-fast-forward.rst
new file mode 100644
index 000000000000..3cf7d2d9d817
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/video-fast-forward.rst
@@ -0,0 +1,70 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _VIDEO_FAST_FORWARD:
+
+VIDEO_FAST_FORWARD
+==================
+
+Description
+-----------
+
+This ioctl call asks the Video Device to skip decoding of N number of
+I-frames. This call can only be used if VIDEO_SOURCE_MEMORY is
+selected.
+
+Synopsis
+--------
+
+.. c:function:: int ioctl(fd, int request = VIDEO_FAST_FORWARD, int nFrames)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals VIDEO_FAST_FORWARD for this command.
+
+    -  .. row 3
+
+       -  int nFrames
+
+       -  The number of frames to skip.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  ``EPERM``
+
+       -  Mode VIDEO_SOURCE_MEMORY not selected.
+
+
+
diff --git a/Documentation/linux_tv/media/dvb/video-fclose.rst b/Documentation/linux_tv/media/dvb/video-fclose.rst
new file mode 100644
index 000000000000..c9fc6560cb43
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/video-fclose.rst
@@ -0,0 +1,52 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _video_fclose:
+
+dvb video close()
+=================
+
+Description
+-----------
+
+This system call closes a previously opened video device.
+
+Synopsis
+--------
+
+.. c:function:: int close(int fd)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+
+Return Value
+------------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  ``EBADF``
+
+       -  fd is not a valid open file descriptor.
+
+
+
diff --git a/Documentation/linux_tv/media/dvb/video-fopen.rst b/Documentation/linux_tv/media/dvb/video-fopen.rst
new file mode 100644
index 000000000000..9de94d4f69dd
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/video-fopen.rst
@@ -0,0 +1,108 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _video_fopen:
+
+dvb video open()
+================
+
+Description
+-----------
+
+This system call opens a named video device (e.g.
+/dev/dvb/adapter0/video0) for subsequent use.
+
+When an open() call has succeeded, the device will be ready for use. The
+significance of blocking or non-blocking mode is described in the
+documentation for functions where there is a difference. It does not
+affect the semantics of the open() call itself. A device opened in
+blocking mode can later be put into non-blocking mode (and vice versa)
+using the F_SETFL command of the fcntl system call. This is a standard
+system call, documented in the Linux manual page for fcntl. Only one
+user can open the Video Device in O_RDWR mode. All other attempts to
+open the device in this mode will fail, and an error-code will be
+returned. If the Video Device is opened in O_RDONLY mode, the only
+ioctl call that can be used is VIDEO_GET_STATUS. All other call will
+return an error code.
+
+Synopsis
+--------
+
+.. c:function:: int open(const char *deviceName, int flags)
+
+Arguments
+----------
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  const char \*deviceName
+
+       -  Name of specific video device.
+
+    -  .. row 2
+
+       -  int flags
+
+       -  A bit-wise OR of the following flags:
+
+    -  .. row 3
+
+       -
+       -  O_RDONLY read-only access
+
+    -  .. row 4
+
+       -
+       -  O_RDWR read/write access
+
+    -  .. row 5
+
+       -
+       -  O_NONBLOCK open in non-blocking mode
+
+    -  .. row 6
+
+       -
+       -  (blocking mode is the default)
+
+
+Return Value
+------------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  ``ENODEV``
+
+       -  Device driver not loaded/available.
+
+    -  .. row 2
+
+       -  ``EINTERNAL``
+
+       -  Internal error.
+
+    -  .. row 3
+
+       -  ``EBUSY``
+
+       -  Device or resource busy.
+
+    -  .. row 4
+
+       -  ``EINVAL``
+
+       -  Invalid argument.
+
+
+
diff --git a/Documentation/linux_tv/media/dvb/video-freeze.rst b/Documentation/linux_tv/media/dvb/video-freeze.rst
new file mode 100644
index 000000000000..d384e329b661
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/video-freeze.rst
@@ -0,0 +1,56 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _VIDEO_FREEZE:
+
+VIDEO_FREEZE
+============
+
+Description
+-----------
+
+This ioctl is for DVB devices only. To control a V4L2 decoder use the
+V4L2 :ref:`VIDIOC_DECODER_CMD` instead.
+
+This ioctl call suspends the live video stream being played. Decoding
+and playing are frozen. It is then possible to restart the decoding and
+playing process of the video stream using the VIDEO_CONTINUE command.
+If VIDEO_SOURCE_MEMORY is selected in the ioctl call
+VIDEO_SELECT_SOURCE, the DVB subsystem will not decode any more data
+until the ioctl call VIDEO_CONTINUE or VIDEO_PLAY is performed.
+
+Synopsis
+--------
+
+.. c:function:: int ioctl(fd, int request = VIDEO_FREEZE)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals VIDEO_FREEZE for this command.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
diff --git a/Documentation/linux_tv/media/dvb/video-fwrite.rst b/Documentation/linux_tv/media/dvb/video-fwrite.rst
new file mode 100644
index 000000000000..398bbeaeaf8b
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/video-fwrite.rst
@@ -0,0 +1,80 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _video_fwrite:
+
+dvb video write()
+=================
+
+Description
+-----------
+
+This system call can only be used if VIDEO_SOURCE_MEMORY is selected
+in the ioctl call VIDEO_SELECT_SOURCE. The data provided shall be in
+PES format, unless the capability allows other formats. If O_NONBLOCK
+is not specified the function will block until buffer space is
+available. The amount of data to be transferred is implied by count.
+
+Synopsis
+--------
+
+.. c:function:: size_t write(int fd, const void *buf, size_t count)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  void \*buf
+
+       -  Pointer to the buffer containing the PES data.
+
+    -  .. row 3
+
+       -  size_t count
+
+       -  Size of buf.
+
+
+Return Value
+------------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  ``EPERM``
+
+       -  Mode VIDEO_SOURCE_MEMORY not selected.
+
+    -  .. row 2
+
+       -  ``ENOMEM``
+
+       -  Attempted to write more data than the internal buffer can hold.
+
+    -  .. row 3
+
+       -  ``EBADF``
+
+       -  fd is not a valid open file descriptor.
+
+
+
diff --git a/Documentation/linux_tv/media/dvb/video-get-capabilities.rst b/Documentation/linux_tv/media/dvb/video-get-capabilities.rst
new file mode 100644
index 000000000000..7b5dcc523a69
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/video-get-capabilities.rst
@@ -0,0 +1,56 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _VIDEO_GET_CAPABILITIES:
+
+VIDEO_GET_CAPABILITIES
+======================
+
+Description
+-----------
+
+This ioctl call asks the video device about its decoding capabilities.
+On success it returns and integer which has bits set according to the
+defines in section ??.
+
+Synopsis
+--------
+
+.. c:function:: int ioctl(fd, int request = VIDEO_GET_CAPABILITIES, unsigned int *cap)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals VIDEO_GET_CAPABILITIES for this command.
+
+    -  .. row 3
+
+       -  unsigned int \*cap
+
+       -  Pointer to a location where to store the capability information.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
diff --git a/Documentation/linux_tv/media/dvb/video-get-event.rst b/Documentation/linux_tv/media/dvb/video-get-event.rst
new file mode 100644
index 000000000000..b958652cac7b
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/video-get-event.rst
@@ -0,0 +1,86 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _VIDEO_GET_EVENT:
+
+VIDEO_GET_EVENT
+===============
+
+Description
+-----------
+
+This ioctl is for DVB devices only. To get events from a V4L2 decoder
+use the V4L2 :ref:`VIDIOC_DQEVENT` ioctl instead.
+
+This ioctl call returns an event of type video_event if available. If
+an event is not available, the behavior depends on whether the device is
+in blocking or non-blocking mode. In the latter case, the call fails
+immediately with errno set to ``EWOULDBLOCK``. In the former case, the call
+blocks until an event becomes available. The standard Linux poll()
+and/or select() system calls can be used with the device file descriptor
+to watch for new events. For select(), the file descriptor should be
+included in the exceptfds argument, and for poll(), POLLPRI should be
+specified as the wake-up condition. Read-only permissions are sufficient
+for this ioctl call.
+
+Synopsis
+--------
+
+.. c:function:: int ioctl(fd, int request = VIDEO_GET_EVENT, struct video_event *ev)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals VIDEO_GET_EVENT for this command.
+
+    -  .. row 3
+
+       -  struct video_event \*ev
+
+       -  Points to the location where the event, if any, is to be stored.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  ``EWOULDBLOCK``
+
+       -  There is no event pending, and the device is in non-blocking mode.
+
+    -  .. row 2
+
+       -  ``EOVERFLOW``
+
+       -  Overflow in event queue - one or more events were lost.
+
+
+
diff --git a/Documentation/linux_tv/media/dvb/video-get-frame-count.rst b/Documentation/linux_tv/media/dvb/video-get-frame-count.rst
new file mode 100644
index 000000000000..c7c140f2467a
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/video-get-frame-count.rst
@@ -0,0 +1,60 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _VIDEO_GET_FRAME_COUNT:
+
+VIDEO_GET_FRAME_COUNT
+=====================
+
+Description
+-----------
+
+This ioctl is obsolete. Do not use in new drivers. For V4L2 decoders
+this ioctl has been replaced by the ``V4L2_CID_MPEG_VIDEO_DEC_FRAME``
+control.
+
+This ioctl call asks the Video Device to return the number of displayed
+frames since the decoder was started.
+
+Synopsis
+--------
+
+.. c:function:: int ioctl(int fd, int request = VIDEO_GET_FRAME_COUNT, __u64 *pts)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals VIDEO_GET_FRAME_COUNT for this command.
+
+    -  .. row 3
+
+       -  __u64 \*pts
+
+       -  Returns the number of frames displayed since the decoder was
+	  started.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
diff --git a/Documentation/linux_tv/media/dvb/video-get-frame-rate.rst b/Documentation/linux_tv/media/dvb/video-get-frame-rate.rst
new file mode 100644
index 000000000000..bfd09385cb31
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/video-get-frame-rate.rst
@@ -0,0 +1,54 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _VIDEO_GET_FRAME_RATE:
+
+VIDEO_GET_FRAME_RATE
+====================
+
+Description
+-----------
+
+This ioctl call asks the Video Device to return the current framerate.
+
+Synopsis
+--------
+
+.. c:function:: int ioctl(int fd, int request = VIDEO_GET_FRAME_RATE, unsigned int *rate)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals VIDEO_GET_FRAME_RATE for this command.
+
+    -  .. row 3
+
+       -  unsigned int \*rate
+
+       -  Returns the framerate in number of frames per 1000 seconds.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
diff --git a/Documentation/linux_tv/media/dvb/video-get-navi.rst b/Documentation/linux_tv/media/dvb/video-get-navi.rst
new file mode 100644
index 000000000000..62451fc03924
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/video-get-navi.rst
@@ -0,0 +1,70 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _VIDEO_GET_NAVI:
+
+VIDEO_GET_NAVI
+==============
+
+Description
+-----------
+
+This ioctl returns navigational information from the DVD stream. This is
+especially needed if an encoded stream has to be decoded by the
+hardware.
+
+Synopsis
+--------
+
+.. c:function:: int ioctl(fd, int request = VIDEO_GET_NAVI , video_navi_pack_t *navipack)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals VIDEO_GET_NAVI for this command.
+
+    -  .. row 3
+
+       -  video_navi_pack_t \*navipack
+
+       -  PCI or DSI pack (private stream 2) according to section ??.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  ``EFAULT``
+
+       -  driver is not able to return navigational information
+
+
+
diff --git a/Documentation/linux_tv/media/dvb/video-get-pts.rst b/Documentation/linux_tv/media/dvb/video-get-pts.rst
new file mode 100644
index 000000000000..67b929753963
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/video-get-pts.rst
@@ -0,0 +1,64 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _VIDEO_GET_PTS:
+
+VIDEO_GET_PTS
+=============
+
+Description
+-----------
+
+This ioctl is obsolete. Do not use in new drivers. For V4L2 decoders
+this ioctl has been replaced by the ``V4L2_CID_MPEG_VIDEO_DEC_PTS``
+control.
+
+This ioctl call asks the Video Device to return the current PTS
+timestamp.
+
+Synopsis
+--------
+
+.. c:function:: int ioctl(int fd, int request = VIDEO_GET_PTS, __u64 *pts)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals VIDEO_GET_PTS for this command.
+
+    -  .. row 3
+
+       -  __u64 \*pts
+
+       -  Returns the 33-bit timestamp as defined in ITU T-REC-H.222.0 /
+	  ISO/IEC 13818-1.
+
+	  The PTS should belong to the currently played frame if possible,
+	  but may also be a value close to it like the PTS of the last
+	  decoded frame or the last PTS extracted by the PES parser.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
diff --git a/Documentation/linux_tv/media/dvb/video-get-size.rst b/Documentation/linux_tv/media/dvb/video-get-size.rst
new file mode 100644
index 000000000000..0e16d91838ac
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/video-get-size.rst
@@ -0,0 +1,54 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _VIDEO_GET_SIZE:
+
+VIDEO_GET_SIZE
+==============
+
+Description
+-----------
+
+This ioctl returns the size and aspect ratio.
+
+Synopsis
+--------
+
+.. c:function:: int ioctl(int fd, int request = VIDEO_GET_SIZE, video_size_t *size)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals VIDEO_GET_SIZE for this command.
+
+    -  .. row 3
+
+       -  video_size_t \*size
+
+       -  Returns the size and aspect ratio.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
diff --git a/Documentation/linux_tv/media/dvb/video-get-status.rst b/Documentation/linux_tv/media/dvb/video-get-status.rst
new file mode 100644
index 000000000000..fd9e591de5df
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/video-get-status.rst
@@ -0,0 +1,55 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _VIDEO_GET_STATUS:
+
+VIDEO_GET_STATUS
+================
+
+Description
+-----------
+
+This ioctl call asks the Video Device to return the current status of
+the device.
+
+Synopsis
+--------
+
+.. c:function:: int ioctl(fd, int request = VIDEO_GET_STATUS, struct video_status *status)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals VIDEO_GET_STATUS for this command.
+
+    -  .. row 3
+
+       -  struct video_status \*status
+
+       -  Returns the current status of the Video Device.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
diff --git a/Documentation/linux_tv/media/dvb/video-play.rst b/Documentation/linux_tv/media/dvb/video-play.rst
new file mode 100644
index 000000000000..da328ed2b4a0
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/video-play.rst
@@ -0,0 +1,52 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _VIDEO_PLAY:
+
+VIDEO_PLAY
+==========
+
+Description
+-----------
+
+This ioctl is for DVB devices only. To control a V4L2 decoder use the
+V4L2 :ref:`VIDIOC_DECODER_CMD` instead.
+
+This ioctl call asks the Video Device to start playing a video stream
+from the selected source.
+
+Synopsis
+--------
+
+.. c:function:: int ioctl(fd, int request = VIDEO_PLAY)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals VIDEO_PLAY for this command.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
diff --git a/Documentation/linux_tv/media/dvb/video-select-source.rst b/Documentation/linux_tv/media/dvb/video-select-source.rst
new file mode 100644
index 000000000000..41fc728508c0
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/video-select-source.rst
@@ -0,0 +1,60 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _VIDEO_SELECT_SOURCE:
+
+VIDEO_SELECT_SOURCE
+===================
+
+Description
+-----------
+
+This ioctl is for DVB devices only. This ioctl was also supported by the
+V4L2 ivtv driver, but that has been replaced by the ivtv-specific
+``IVTV_IOC_PASSTHROUGH_MODE`` ioctl.
+
+This ioctl call informs the video device which source shall be used for
+the input data. The possible sources are demux or memory. If memory is
+selected, the data is fed to the video device through the write command.
+
+Synopsis
+--------
+
+.. c:function:: int ioctl(fd, int request = VIDEO_SELECT_SOURCE, video_stream_source_t source)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals VIDEO_SELECT_SOURCE for this command.
+
+    -  .. row 3
+
+       -  video_stream_source_t source
+
+       -  Indicates which source shall be used for the Video stream.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
diff --git a/Documentation/linux_tv/media/dvb/video-set-attributes.rst b/Documentation/linux_tv/media/dvb/video-set-attributes.rst
new file mode 100644
index 000000000000..255efe0872d1
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/video-set-attributes.rst
@@ -0,0 +1,68 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _VIDEO_SET_ATTRIBUTES:
+
+VIDEO_SET_ATTRIBUTES
+====================
+
+Description
+-----------
+
+This ioctl is intended for DVD playback and allows you to set certain
+information about the stream. Some hardware may not need this
+information, but the call also tells the hardware to prepare for DVD
+playback.
+
+Synopsis
+--------
+
+.. c:function:: int ioctl(fd, int request = VIDEO_SET_ATTRIBUTE ,video_attributes_t vattr)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals VIDEO_SET_ATTRIBUTE for this command.
+
+    -  .. row 3
+
+       -  video_attributes_t vattr
+
+       -  video attributes according to section ??.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  ``EINVAL``
+
+       -  input is not a valid attribute setting.
diff --git a/Documentation/linux_tv/media/dvb/video-set-blank.rst b/Documentation/linux_tv/media/dvb/video-set-blank.rst
new file mode 100644
index 000000000000..0ed2afdf4b72
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/video-set-blank.rst
@@ -0,0 +1,59 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _VIDEO_SET_BLANK:
+
+VIDEO_SET_BLANK
+===============
+
+Description
+-----------
+
+This ioctl call asks the Video Device to blank out the picture.
+
+Synopsis
+--------
+
+.. c:function:: int ioctl(fd, int request = VIDEO_SET_BLANK, boolean mode)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals VIDEO_SET_BLANK for this command.
+
+    -  .. row 3
+
+       -  boolean mode
+
+       -  TRUE: Blank screen when stop.
+
+    -  .. row 4
+
+       -
+       -  FALSE: Show last decoded frame.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
diff --git a/Documentation/linux_tv/media/dvb/video-set-display-format.rst b/Documentation/linux_tv/media/dvb/video-set-display-format.rst
new file mode 100644
index 000000000000..af55cefbd3c0
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/video-set-display-format.rst
@@ -0,0 +1,55 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _VIDEO_SET_DISPLAY_FORMAT:
+
+VIDEO_SET_DISPLAY_FORMAT
+========================
+
+Description
+-----------
+
+This ioctl call asks the Video Device to select the video format to be
+applied by the MPEG chip on the video.
+
+Synopsis
+--------
+
+.. c:function:: int ioctl(fd, int request = VIDEO_SET_DISPLAY_FORMAT, video_display_format_t format)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals VIDEO_SET_DISPLAY_FORMAT for this command.
+
+    -  .. row 3
+
+       -  video_display_format_t format
+
+       -  Selects the video format to be used.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
diff --git a/Documentation/linux_tv/media/dvb/video-set-format.rst b/Documentation/linux_tv/media/dvb/video-set-format.rst
new file mode 100644
index 000000000000..aea4d913c760
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/video-set-format.rst
@@ -0,0 +1,70 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _VIDEO_SET_FORMAT:
+
+VIDEO_SET_FORMAT
+================
+
+Description
+-----------
+
+This ioctl sets the screen format (aspect ratio) of the connected output
+device (TV) so that the output of the decoder can be adjusted
+accordingly.
+
+Synopsis
+--------
+
+.. c:function:: int ioctl(fd, int request = VIDEO_SET_FORMAT, video_format_t format)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals VIDEO_SET_FORMAT for this command.
+
+    -  .. row 3
+
+       -  video_format_t format
+
+       -  video format of TV as defined in section ??.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  ``EINVAL``
+
+       -  format is not a valid video format.
+
+
+
diff --git a/Documentation/linux_tv/media/dvb/video-set-highlight.rst b/Documentation/linux_tv/media/dvb/video-set-highlight.rst
new file mode 100644
index 000000000000..e92b7ac28f23
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/video-set-highlight.rst
@@ -0,0 +1,55 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _VIDEO_SET_HIGHLIGHT:
+
+VIDEO_SET_HIGHLIGHT
+===================
+
+Description
+-----------
+
+This ioctl sets the SPU highlight information for the menu access of a
+DVD.
+
+Synopsis
+--------
+
+.. c:function:: int ioctl(fd, int request = VIDEO_SET_HIGHLIGHT ,video_highlight_t *vhilite)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals VIDEO_SET_HIGHLIGHT for this command.
+
+    -  .. row 3
+
+       -  video_highlight_t \*vhilite
+
+       -  SPU Highlight information according to section ??.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
diff --git a/Documentation/linux_tv/media/dvb/video-set-id.rst b/Documentation/linux_tv/media/dvb/video-set-id.rst
new file mode 100644
index 000000000000..5a58405fba42
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/video-set-id.rst
@@ -0,0 +1,69 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _VIDEO_SET_ID:
+
+VIDEO_SET_ID
+============
+
+Description
+-----------
+
+This ioctl selects which sub-stream is to be decoded if a program or
+system stream is sent to the video device.
+
+Synopsis
+--------
+
+.. c:function:: int ioctl(int fd, int request = VIDEO_SET_ID, int id)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals VIDEO_SET_ID for this command.
+
+    -  .. row 3
+
+       -  int id
+
+       -  video sub-stream id
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  ``EINVAL``
+
+       -  Invalid sub-stream id.
+
+
+
diff --git a/Documentation/linux_tv/media/dvb/video-set-spu-palette.rst b/Documentation/linux_tv/media/dvb/video-set-spu-palette.rst
new file mode 100644
index 000000000000..3fb338ee7420
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/video-set-spu-palette.rst
@@ -0,0 +1,68 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _VIDEO_SET_SPU_PALETTE:
+
+VIDEO_SET_SPU_PALETTE
+=====================
+
+Description
+-----------
+
+This ioctl sets the SPU color palette.
+
+Synopsis
+--------
+
+.. c:function:: int ioctl(fd, int request = VIDEO_SET_SPU_PALETTE, video_spu_palette_t *palette )
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals VIDEO_SET_SPU_PALETTE for this command.
+
+    -  .. row 3
+
+       -  video_spu_palette_t \*palette
+
+       -  SPU palette according to section ??.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  ``EINVAL``
+
+       -  input is not a valid palette or driver doesn’t handle SPU.
+
+
+
diff --git a/Documentation/linux_tv/media/dvb/video-set-spu.rst b/Documentation/linux_tv/media/dvb/video-set-spu.rst
new file mode 100644
index 000000000000..863c6248fab9
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/video-set-spu.rst
@@ -0,0 +1,70 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _VIDEO_SET_SPU:
+
+VIDEO_SET_SPU
+=============
+
+Description
+-----------
+
+This ioctl activates or deactivates SPU decoding in a DVD input stream.
+It can only be used, if the driver is able to handle a DVD stream.
+
+Synopsis
+--------
+
+.. c:function:: int ioctl(fd, int request = VIDEO_SET_SPU , video_spu_t *spu)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals VIDEO_SET_SPU for this command.
+
+    -  .. row 3
+
+       -  video_spu_t \*spu
+
+       -  SPU decoding (de)activation and subid setting according to section
+	  ??.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  ``EINVAL``
+
+       -  input is not a valid spu setting or driver cannot handle SPU.
+
+
+
diff --git a/Documentation/linux_tv/media/dvb/video-set-streamtype.rst b/Documentation/linux_tv/media/dvb/video-set-streamtype.rst
new file mode 100644
index 000000000000..c412051cc073
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/video-set-streamtype.rst
@@ -0,0 +1,56 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _VIDEO_SET_STREAMTYPE:
+
+VIDEO_SET_STREAMTYPE
+====================
+
+Description
+-----------
+
+This ioctl tells the driver which kind of stream to expect being written
+to it. If this call is not used the default of video PES is used. Some
+drivers might not support this call and always expect PES.
+
+Synopsis
+--------
+
+.. c:function:: int ioctl(fd, int request = VIDEO_SET_STREAMTYPE, int type)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals VIDEO_SET_STREAMTYPE for this command.
+
+    -  .. row 3
+
+       -  int type
+
+       -  stream type
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
diff --git a/Documentation/linux_tv/media/dvb/video-set-system.rst b/Documentation/linux_tv/media/dvb/video-set-system.rst
new file mode 100644
index 000000000000..70bff8a1c53a
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/video-set-system.rst
@@ -0,0 +1,71 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _VIDEO_SET_SYSTEM:
+
+VIDEO_SET_SYSTEM
+================
+
+Description
+-----------
+
+This ioctl sets the television output format. The format (see section
+??) may vary from the color format of the displayed MPEG stream. If the
+hardware is not able to display the requested format the call will
+return an error.
+
+Synopsis
+--------
+
+.. c:function:: int ioctl(fd, int request = VIDEO_SET_SYSTEM , video_system_t system)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals VIDEO_SET_FORMAT for this command.
+
+    -  .. row 3
+
+       -  video_system_t system
+
+       -  video system of TV output.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  ``EINVAL``
+
+       -  system is not a valid or supported video system.
+
+
+
diff --git a/Documentation/linux_tv/media/dvb/video-slowmotion.rst b/Documentation/linux_tv/media/dvb/video-slowmotion.rst
new file mode 100644
index 000000000000..e04ad5776683
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/video-slowmotion.rst
@@ -0,0 +1,70 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _VIDEO_SLOWMOTION:
+
+VIDEO_SLOWMOTION
+================
+
+Description
+-----------
+
+This ioctl call asks the video device to repeat decoding frames N number
+of times. This call can only be used if VIDEO_SOURCE_MEMORY is
+selected.
+
+Synopsis
+--------
+
+.. c:function:: int ioctl(fd, int request = VIDEO_SLOWMOTION, int nFrames)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals VIDEO_SLOWMOTION for this command.
+
+    -  .. row 3
+
+       -  int nFrames
+
+       -  The number of times to repeat each frame.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  ``EPERM``
+
+       -  Mode VIDEO_SOURCE_MEMORY not selected.
+
+
+
diff --git a/Documentation/linux_tv/media/dvb/video-stillpicture.rst b/Documentation/linux_tv/media/dvb/video-stillpicture.rst
new file mode 100644
index 000000000000..94ae66c1d97b
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/video-stillpicture.rst
@@ -0,0 +1,56 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _VIDEO_STILLPICTURE:
+
+VIDEO_STILLPICTURE
+==================
+
+Description
+-----------
+
+This ioctl call asks the Video Device to display a still picture
+(I-frame). The input data shall contain an I-frame. If the pointer is
+NULL, then the current displayed still picture is blanked.
+
+Synopsis
+--------
+
+.. c:function:: int ioctl(fd, int request = VIDEO_STILLPICTURE, struct video_still_picture *sp)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals VIDEO_STILLPICTURE for this command.
+
+    -  .. row 3
+
+       -  struct video_still_picture \*sp
+
+       -  Pointer to a location where an I-frame and size is stored.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
diff --git a/Documentation/linux_tv/media/dvb/video-stop.rst b/Documentation/linux_tv/media/dvb/video-stop.rst
new file mode 100644
index 000000000000..fd5288727911
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/video-stop.rst
@@ -0,0 +1,69 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _VIDEO_STOP:
+
+VIDEO_STOP
+==========
+
+Description
+-----------
+
+This ioctl is for DVB devices only. To control a V4L2 decoder use the
+V4L2 :ref:`VIDIOC_DECODER_CMD` instead.
+
+This ioctl call asks the Video Device to stop playing the current
+stream. Depending on the input parameter, the screen can be blanked out
+or displaying the last decoded frame.
+
+Synopsis
+--------
+
+.. c:function:: int ioctl(fd, int request = VIDEO_STOP, boolean mode)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals VIDEO_STOP for this command.
+
+    -  .. row 3
+
+       -  Boolean mode
+
+       -  Indicates how the screen shall be handled.
+
+    -  .. row 4
+
+       -
+       -  TRUE: Blank screen when stop.
+
+    -  .. row 5
+
+       -
+       -  FALSE: Show last decoded frame.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
diff --git a/Documentation/linux_tv/media/dvb/video-try-command.rst b/Documentation/linux_tv/media/dvb/video-try-command.rst
new file mode 100644
index 000000000000..57eff3daf7bd
--- /dev/null
+++ b/Documentation/linux_tv/media/dvb/video-try-command.rst
@@ -0,0 +1,61 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _VIDEO_TRY_COMMAND:
+
+VIDEO_TRY_COMMAND
+=================
+
+Description
+-----------
+
+This ioctl is obsolete. Do not use in new drivers. For V4L2 decoders
+this ioctl has been replaced by the
+:ref:`VIDIOC_TRY_DECODER_CMD <VIDIOC_DECODER_CMD>` ioctl.
+
+This ioctl tries a decoder command. The ``video_command`` struct is a
+subset of the ``v4l2_decoder_cmd`` struct, so refer to the
+:ref:`VIDIOC_TRY_DECODER_CMD <VIDIOC_DECODER_CMD>` documentation
+for more information.
+
+Synopsis
+--------
+
+.. c:function:: int ioctl(int fd, int request = VIDEO_TRY_COMMAND, struct video_command *cmd)
+
+Arguments
+----------
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+
+    -  .. row 1
+
+       -  int fd
+
+       -  File descriptor returned by a previous call to open().
+
+    -  .. row 2
+
+       -  int request
+
+       -  Equals VIDEO_TRY_COMMAND for this command.
+
+    -  .. row 3
+
+       -  struct video_command \*cmd
+
+       -  Try a decoder command.
+
+
+Return Value
+------------
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
+
diff --git a/Documentation/linux_tv/media/dvb/video_function_calls.rst b/Documentation/linux_tv/media/dvb/video_function_calls.rst
index a337fbf51bc0..68588ac7fecb 100644
--- a/Documentation/linux_tv/media/dvb/video_function_calls.rst
+++ b/Documentation/linux_tv/media/dvb/video_function_calls.rst
@@ -6,1976 +6,38 @@
 Video Function Calls
 ********************
 
-
-.. _video_fopen:
-
-dvb video open()
-================
-
-Description
------------
-
-This system call opens a named video device (e.g.
-/dev/dvb/adapter0/video0) for subsequent use.
-
-When an open() call has succeeded, the device will be ready for use. The
-significance of blocking or non-blocking mode is described in the
-documentation for functions where there is a difference. It does not
-affect the semantics of the open() call itself. A device opened in
-blocking mode can later be put into non-blocking mode (and vice versa)
-using the F_SETFL command of the fcntl system call. This is a standard
-system call, documented in the Linux manual page for fcntl. Only one
-user can open the Video Device in O_RDWR mode. All other attempts to
-open the device in this mode will fail, and an error-code will be
-returned. If the Video Device is opened in O_RDONLY mode, the only
-ioctl call that can be used is VIDEO_GET_STATUS. All other call will
-return an error code.
-
-Synopsis
---------
-
-.. c:function:: int open(const char *deviceName, int flags)
-
-Arguments
-----------
-
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
-
-
-    -  .. row 1
-
-       -  const char \*deviceName
-
-       -  Name of specific video device.
-
-    -  .. row 2
-
-       -  int flags
-
-       -  A bit-wise OR of the following flags:
-
-    -  .. row 3
-
-       -
-       -  O_RDONLY read-only access
-
-    -  .. row 4
-
-       -
-       -  O_RDWR read/write access
-
-    -  .. row 5
-
-       -
-       -  O_NONBLOCK open in non-blocking mode
-
-    -  .. row 6
-
-       -
-       -  (blocking mode is the default)
-
-
-Return Value
-------------
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
-       -  ``ENODEV``
-
-       -  Device driver not loaded/available.
-
-    -  .. row 2
-
-       -  ``EINTERNAL``
-
-       -  Internal error.
-
-    -  .. row 3
-
-       -  ``EBUSY``
-
-       -  Device or resource busy.
-
-    -  .. row 4
-
-       -  ``EINVAL``
-
-       -  Invalid argument.
-
-
-
-.. _video_fclose:
-
-dvb video close()
-=================
-
-Description
------------
-
-This system call closes a previously opened video device.
-
-Synopsis
---------
-
-.. c:function:: int close(int fd)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-
-Return Value
-------------
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
-       -  ``EBADF``
-
-       -  fd is not a valid open file descriptor.
-
-
-
-.. _video_fwrite:
-
-dvb video write()
-=================
-
-Description
------------
-
-This system call can only be used if VIDEO_SOURCE_MEMORY is selected
-in the ioctl call VIDEO_SELECT_SOURCE. The data provided shall be in
-PES format, unless the capability allows other formats. If O_NONBLOCK
-is not specified the function will block until buffer space is
-available. The amount of data to be transferred is implied by count.
-
-Synopsis
---------
-
-.. c:function:: size_t write(int fd, const void *buf, size_t count)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  void \*buf
-
-       -  Pointer to the buffer containing the PES data.
-
-    -  .. row 3
-
-       -  size_t count
-
-       -  Size of buf.
-
-
-Return Value
-------------
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
-       -  ``EPERM``
-
-       -  Mode VIDEO_SOURCE_MEMORY not selected.
-
-    -  .. row 2
-
-       -  ``ENOMEM``
-
-       -  Attempted to write more data than the internal buffer can hold.
-
-    -  .. row 3
-
-       -  ``EBADF``
-
-       -  fd is not a valid open file descriptor.
-
-
-
-.. _VIDEO_STOP:
-
-VIDEO_STOP
-==========
-
-Description
------------
-
-This ioctl is for DVB devices only. To control a V4L2 decoder use the
-V4L2 :ref:`VIDIOC_DECODER_CMD` instead.
-
-This ioctl call asks the Video Device to stop playing the current
-stream. Depending on the input parameter, the screen can be blanked out
-or displaying the last decoded frame.
-
-Synopsis
---------
-
-.. c:function:: int ioctl(fd, int request = VIDEO_STOP, boolean mode)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals VIDEO_STOP for this command.
-
-    -  .. row 3
-
-       -  Boolean mode
-
-       -  Indicates how the screen shall be handled.
-
-    -  .. row 4
-
-       -
-       -  TRUE: Blank screen when stop.
-
-    -  .. row 5
-
-       -
-       -  FALSE: Show last decoded frame.
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
-.. _VIDEO_PLAY:
-
-VIDEO_PLAY
-==========
-
-Description
------------
-
-This ioctl is for DVB devices only. To control a V4L2 decoder use the
-V4L2 :ref:`VIDIOC_DECODER_CMD` instead.
-
-This ioctl call asks the Video Device to start playing a video stream
-from the selected source.
-
-Synopsis
---------
-
-.. c:function:: int ioctl(fd, int request = VIDEO_PLAY)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals VIDEO_PLAY for this command.
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
-.. _VIDEO_FREEZE:
-
-VIDEO_FREEZE
-============
-
-Description
------------
-
-This ioctl is for DVB devices only. To control a V4L2 decoder use the
-V4L2 :ref:`VIDIOC_DECODER_CMD` instead.
-
-This ioctl call suspends the live video stream being played. Decoding
-and playing are frozen. It is then possible to restart the decoding and
-playing process of the video stream using the VIDEO_CONTINUE command.
-If VIDEO_SOURCE_MEMORY is selected in the ioctl call
-VIDEO_SELECT_SOURCE, the DVB subsystem will not decode any more data
-until the ioctl call VIDEO_CONTINUE or VIDEO_PLAY is performed.
-
-Synopsis
---------
-
-.. c:function:: int ioctl(fd, int request = VIDEO_FREEZE)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals VIDEO_FREEZE for this command.
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
-.. _VIDEO_CONTINUE:
-
-VIDEO_CONTINUE
-==============
-
-Description
------------
-
-This ioctl is for DVB devices only. To control a V4L2 decoder use the
-V4L2 :ref:`VIDIOC_DECODER_CMD` instead.
-
-This ioctl call restarts decoding and playing processes of the video
-stream which was played before a call to VIDEO_FREEZE was made.
-
-Synopsis
---------
-
-.. c:function:: int ioctl(fd, int request = VIDEO_CONTINUE)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals VIDEO_CONTINUE for this command.
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
-.. _VIDEO_SELECT_SOURCE:
-
-VIDEO_SELECT_SOURCE
-===================
-
-Description
------------
-
-This ioctl is for DVB devices only. This ioctl was also supported by the
-V4L2 ivtv driver, but that has been replaced by the ivtv-specific
-``IVTV_IOC_PASSTHROUGH_MODE`` ioctl.
-
-This ioctl call informs the video device which source shall be used for
-the input data. The possible sources are demux or memory. If memory is
-selected, the data is fed to the video device through the write command.
-
-Synopsis
---------
-
-.. c:function:: int ioctl(fd, int request = VIDEO_SELECT_SOURCE, video_stream_source_t source)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals VIDEO_SELECT_SOURCE for this command.
-
-    -  .. row 3
-
-       -  video_stream_source_t source
-
-       -  Indicates which source shall be used for the Video stream.
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
-.. _VIDEO_SET_BLANK:
-
-VIDEO_SET_BLANK
-===============
-
-Description
------------
-
-This ioctl call asks the Video Device to blank out the picture.
-
-Synopsis
---------
-
-.. c:function:: int ioctl(fd, int request = VIDEO_SET_BLANK, boolean mode)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals VIDEO_SET_BLANK for this command.
-
-    -  .. row 3
-
-       -  boolean mode
-
-       -  TRUE: Blank screen when stop.
-
-    -  .. row 4
-
-       -
-       -  FALSE: Show last decoded frame.
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
-.. _VIDEO_GET_STATUS:
-
-VIDEO_GET_STATUS
-================
-
-Description
------------
-
-This ioctl call asks the Video Device to return the current status of
-the device.
-
-Synopsis
---------
-
-.. c:function:: int ioctl(fd, int request = VIDEO_GET_STATUS, struct video_status *status)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals VIDEO_GET_STATUS for this command.
-
-    -  .. row 3
-
-       -  struct video_status \*status
-
-       -  Returns the current status of the Video Device.
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
-.. _VIDEO_GET_FRAME_COUNT:
-
-VIDEO_GET_FRAME_COUNT
-=====================
-
-Description
------------
-
-This ioctl is obsolete. Do not use in new drivers. For V4L2 decoders
-this ioctl has been replaced by the ``V4L2_CID_MPEG_VIDEO_DEC_FRAME``
-control.
-
-This ioctl call asks the Video Device to return the number of displayed
-frames since the decoder was started.
-
-Synopsis
---------
-
-.. c:function:: int ioctl(int fd, int request = VIDEO_GET_FRAME_COUNT, __u64 *pts)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals VIDEO_GET_FRAME_COUNT for this command.
-
-    -  .. row 3
-
-       -  __u64 \*pts
-
-       -  Returns the number of frames displayed since the decoder was
-	  started.
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
-.. _VIDEO_GET_PTS:
-
-VIDEO_GET_PTS
-=============
-
-Description
------------
-
-This ioctl is obsolete. Do not use in new drivers. For V4L2 decoders
-this ioctl has been replaced by the ``V4L2_CID_MPEG_VIDEO_DEC_PTS``
-control.
-
-This ioctl call asks the Video Device to return the current PTS
-timestamp.
-
-Synopsis
---------
-
-.. c:function:: int ioctl(int fd, int request = VIDEO_GET_PTS, __u64 *pts)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals VIDEO_GET_PTS for this command.
-
-    -  .. row 3
-
-       -  __u64 \*pts
-
-       -  Returns the 33-bit timestamp as defined in ITU T-REC-H.222.0 /
-	  ISO/IEC 13818-1.
-
-	  The PTS should belong to the currently played frame if possible,
-	  but may also be a value close to it like the PTS of the last
-	  decoded frame or the last PTS extracted by the PES parser.
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
-.. _VIDEO_GET_FRAME_RATE:
-
-VIDEO_GET_FRAME_RATE
-====================
-
-Description
------------
-
-This ioctl call asks the Video Device to return the current framerate.
-
-Synopsis
---------
-
-.. c:function:: int ioctl(int fd, int request = VIDEO_GET_FRAME_RATE, unsigned int *rate)
-
-Arguments
-----------
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
-Return Value
-------------
-
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
-:ref:`Generic Error Codes <gen-errors>` chapter.
-
-
-.. _VIDEO_GET_EVENT:
-
-VIDEO_GET_EVENT
-===============
-
-Description
------------
-
-This ioctl is for DVB devices only. To get events from a V4L2 decoder
-use the V4L2 :ref:`VIDIOC_DQEVENT` ioctl instead.
-
-This ioctl call returns an event of type video_event if available. If
-an event is not available, the behavior depends on whether the device is
-in blocking or non-blocking mode. In the latter case, the call fails
-immediately with errno set to ``EWOULDBLOCK``. In the former case, the call
-blocks until an event becomes available. The standard Linux poll()
-and/or select() system calls can be used with the device file descriptor
-to watch for new events. For select(), the file descriptor should be
-included in the exceptfds argument, and for poll(), POLLPRI should be
-specified as the wake-up condition. Read-only permissions are sufficient
-for this ioctl call.
-
-Synopsis
---------
-
-.. c:function:: int ioctl(fd, int request = VIDEO_GET_EVENT, struct video_event *ev)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals VIDEO_GET_EVENT for this command.
-
-    -  .. row 3
-
-       -  struct video_event \*ev
-
-       -  Points to the location where the event, if any, is to be stored.
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
-       -  ``EWOULDBLOCK``
-
-       -  There is no event pending, and the device is in non-blocking mode.
-
-    -  .. row 2
-
-       -  ``EOVERFLOW``
-
-       -  Overflow in event queue - one or more events were lost.
-
-
-
-.. _VIDEO_COMMAND:
-
-VIDEO_COMMAND
-=============
-
-Description
------------
-
-This ioctl is obsolete. Do not use in new drivers. For V4L2 decoders
-this ioctl has been replaced by the
-:ref:`VIDIOC_DECODER_CMD` ioctl.
-
-This ioctl commands the decoder. The ``video_command`` struct is a
-subset of the ``v4l2_decoder_cmd`` struct, so refer to the
-:ref:`VIDIOC_DECODER_CMD` documentation for
-more information.
-
-Synopsis
---------
-
-.. c:function:: int ioctl(int fd, int request = VIDEO_COMMAND, struct video_command *cmd)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals VIDEO_COMMAND for this command.
-
-    -  .. row 3
-
-       -  struct video_command \*cmd
-
-       -  Commands the decoder.
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
-.. _VIDEO_TRY_COMMAND:
-
-VIDEO_TRY_COMMAND
-=================
-
-Description
------------
-
-This ioctl is obsolete. Do not use in new drivers. For V4L2 decoders
-this ioctl has been replaced by the
-:ref:`VIDIOC_TRY_DECODER_CMD <VIDIOC_DECODER_CMD>` ioctl.
-
-This ioctl tries a decoder command. The ``video_command`` struct is a
-subset of the ``v4l2_decoder_cmd`` struct, so refer to the
-:ref:`VIDIOC_TRY_DECODER_CMD <VIDIOC_DECODER_CMD>` documentation
-for more information.
-
-Synopsis
---------
-
-.. c:function:: int ioctl(int fd, int request = VIDEO_TRY_COMMAND, struct video_command *cmd)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals VIDEO_TRY_COMMAND for this command.
-
-    -  .. row 3
-
-       -  struct video_command \*cmd
-
-       -  Try a decoder command.
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
-.. _VIDEO_GET_SIZE:
-
-VIDEO_GET_SIZE
-==============
-
-Description
------------
-
-This ioctl returns the size and aspect ratio.
-
-Synopsis
---------
-
-.. c:function:: int ioctl(int fd, int request = VIDEO_GET_SIZE, video_size_t *size)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals VIDEO_GET_SIZE for this command.
-
-    -  .. row 3
-
-       -  video_size_t \*size
-
-       -  Returns the size and aspect ratio.
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
-.. _VIDEO_SET_DISPLAY_FORMAT:
-
-VIDEO_SET_DISPLAY_FORMAT
-========================
-
-Description
------------
-
-This ioctl call asks the Video Device to select the video format to be
-applied by the MPEG chip on the video.
-
-Synopsis
---------
-
-.. c:function:: int ioctl(fd, int request = VIDEO_SET_DISPLAY_FORMAT, video_display_format_t format)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals VIDEO_SET_DISPLAY_FORMAT for this command.
-
-    -  .. row 3
-
-       -  video_display_format_t format
-
-       -  Selects the video format to be used.
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
-.. _VIDEO_STILLPICTURE:
-
-VIDEO_STILLPICTURE
-==================
-
-Description
------------
-
-This ioctl call asks the Video Device to display a still picture
-(I-frame). The input data shall contain an I-frame. If the pointer is
-NULL, then the current displayed still picture is blanked.
-
-Synopsis
---------
-
-.. c:function:: int ioctl(fd, int request = VIDEO_STILLPICTURE, struct video_still_picture *sp)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals VIDEO_STILLPICTURE for this command.
-
-    -  .. row 3
-
-       -  struct video_still_picture \*sp
-
-       -  Pointer to a location where an I-frame and size is stored.
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
-.. _VIDEO_FAST_FORWARD:
-
-VIDEO_FAST_FORWARD
-==================
-
-Description
------------
-
-This ioctl call asks the Video Device to skip decoding of N number of
-I-frames. This call can only be used if VIDEO_SOURCE_MEMORY is
-selected.
-
-Synopsis
---------
-
-.. c:function:: int ioctl(fd, int request = VIDEO_FAST_FORWARD, int nFrames)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals VIDEO_FAST_FORWARD for this command.
-
-    -  .. row 3
-
-       -  int nFrames
-
-       -  The number of frames to skip.
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
-       -  ``EPERM``
-
-       -  Mode VIDEO_SOURCE_MEMORY not selected.
-
-
-
-.. _VIDEO_SLOWMOTION:
-
-VIDEO_SLOWMOTION
-================
-
-Description
------------
-
-This ioctl call asks the video device to repeat decoding frames N number
-of times. This call can only be used if VIDEO_SOURCE_MEMORY is
-selected.
-
-Synopsis
---------
-
-.. c:function:: int ioctl(fd, int request = VIDEO_SLOWMOTION, int nFrames)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals VIDEO_SLOWMOTION for this command.
-
-    -  .. row 3
-
-       -  int nFrames
-
-       -  The number of times to repeat each frame.
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
-       -  ``EPERM``
-
-       -  Mode VIDEO_SOURCE_MEMORY not selected.
-
-
-
-.. _VIDEO_GET_CAPABILITIES:
-
-VIDEO_GET_CAPABILITIES
-======================
-
-Description
------------
-
-This ioctl call asks the video device about its decoding capabilities.
-On success it returns and integer which has bits set according to the
-defines in section ??.
-
-Synopsis
---------
-
-.. c:function:: int ioctl(fd, int request = VIDEO_GET_CAPABILITIES, unsigned int *cap)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals VIDEO_GET_CAPABILITIES for this command.
-
-    -  .. row 3
-
-       -  unsigned int \*cap
-
-       -  Pointer to a location where to store the capability information.
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
-.. _VIDEO_SET_ID:
-
-VIDEO_SET_ID
-============
-
-Description
------------
-
-This ioctl selects which sub-stream is to be decoded if a program or
-system stream is sent to the video device.
-
-Synopsis
---------
-
-.. c:function:: int ioctl(int fd, int request = VIDEO_SET_ID, int id)
-
-Arguments
-----------
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
-
-
-
-.. _VIDEO_CLEAR_BUFFER:
-
-VIDEO_CLEAR_BUFFER
-==================
-
-Description
------------
-
-This ioctl call clears all video buffers in the driver and in the
-decoder hardware.
-
-Synopsis
---------
-
-.. c:function:: int ioctl(fd, int request = VIDEO_CLEAR_BUFFER)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals VIDEO_CLEAR_BUFFER for this command.
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
-.. _VIDEO_SET_STREAMTYPE:
-
-VIDEO_SET_STREAMTYPE
-====================
-
-Description
------------
-
-This ioctl tells the driver which kind of stream to expect being written
-to it. If this call is not used the default of video PES is used. Some
-drivers might not support this call and always expect PES.
-
-Synopsis
---------
-
-.. c:function:: int ioctl(fd, int request = VIDEO_SET_STREAMTYPE, int type)
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals VIDEO_SET_STREAMTYPE for this command.
-
-    -  .. row 3
-
-       -  int type
-
-       -  stream type
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
-.. _VIDEO_SET_FORMAT:
-
-VIDEO_SET_FORMAT
-================
-
-Description
------------
-
-This ioctl sets the screen format (aspect ratio) of the connected output
-device (TV) so that the output of the decoder can be adjusted
-accordingly.
-
-Synopsis
---------
-
-.. c:function:: int ioctl(fd, int request = VIDEO_SET_FORMAT, video_format_t format)
-
-Arguments
-----------
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
-       -  video_format_t format
-
-       -  video format of TV as defined in section ??.
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
-       -  format is not a valid video format.
-
-
-
-.. _VIDEO_SET_SYSTEM:
-
-VIDEO_SET_SYSTEM
-================
-
-Description
------------
-
-This ioctl sets the television output format. The format (see section
-??) may vary from the color format of the displayed MPEG stream. If the
-hardware is not able to display the requested format the call will
-return an error.
-
-Synopsis
---------
-
-.. c:function:: int ioctl(fd, int request = VIDEO_SET_SYSTEM , video_system_t system)
-
-Arguments
-----------
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
-
-
-
-.. _VIDEO_SET_HIGHLIGHT:
-
-VIDEO_SET_HIGHLIGHT
-===================
-
-Description
------------
-
-This ioctl sets the SPU highlight information for the menu access of a
-DVD.
-
-Synopsis
---------
-
-.. c:function:: int ioctl(fd, int request = VIDEO_SET_HIGHLIGHT ,video_highlight_t *vhilite)
-
-Arguments
-----------
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
-Return Value
-------------
-
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
-:ref:`Generic Error Codes <gen-errors>` chapter.
-
-
-.. _VIDEO_SET_SPU:
-
-VIDEO_SET_SPU
-=============
-
-Description
------------
-
-This ioctl activates or deactivates SPU decoding in a DVD input stream.
-It can only be used, if the driver is able to handle a DVD stream.
-
-Synopsis
---------
-
-.. c:function:: int ioctl(fd, int request = VIDEO_SET_SPU , video_spu_t *spu)
-
-Arguments
-----------
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
-
-
-
-.. _VIDEO_SET_SPU_PALETTE:
-
-VIDEO_SET_SPU_PALETTE
-=====================
-
-Description
------------
-
-This ioctl sets the SPU color palette.
-
-Synopsis
---------
-
-.. c:function:: int ioctl(fd, int request = VIDEO_SET_SPU_PALETTE, video_spu_palette_t *palette )
-
-Arguments
-----------
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
-       -  int fd
-
-       -  File descriptor returned by a previous call to open().
-
-    -  .. row 2
-
-       -  int request
-
-       -  Equals VIDEO_SET_SPU_PALETTE for this command.
-
-    -  .. row 3
-
-       -  video_spu_palette_t \*palette
-
-       -  SPU palette according to section ??.
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
-       -  input is not a valid palette or driver doesn’t handle SPU.
-
-
-
-.. _VIDEO_GET_NAVI:
-
-VIDEO_GET_NAVI
-==============
-
-Description
------------
-
-This ioctl returns navigational information from the DVD stream. This is
-especially needed if an encoded stream has to be decoded by the
-hardware.
-
-Synopsis
---------
-
-.. c:function:: int ioctl(fd, int request = VIDEO_GET_NAVI , video_navi_pack_t *navipack)
-
-Arguments
-----------
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
-
-
-
-.. _VIDEO_SET_ATTRIBUTES:
-
-VIDEO_SET_ATTRIBUTES
-====================
-
-Description
------------
-
-This ioctl is intended for DVD playback and allows you to set certain
-information about the stream. Some hardware may not need this
-information, but the call also tells the hardware to prepare for DVD
-playback.
-
-Synopsis
---------
-
-.. c:function:: int ioctl(fd, int request = VIDEO_SET_ATTRIBUTE ,video_attributes_t vattr)
-
-Arguments
-----------
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
+.. toctree::
+    :maxdepth: 1
+
+    video-fopen
+    video-fclose
+    video-fwrite
+    video-stop
+    video-play
+    video-freeze
+    video-continue
+    video-select-source
+    video-set-blank
+    video-get-status
+    video-get-frame-count
+    video-get-pts
+    video-get-frame-rate
+    video-get-event
+    video-command
+    video-try-command
+    video-get-size
+    video-set-display-format
+    video-stillpicture
+    video-fast-forward
+    video-slowmotion
+    video-get-capabilities
+    video-set-id
+    video-clear-buffer
+    video-set-streamtype
+    video-set-format
+    video-set-system
+    video-set-highlight
+    video-set-spu
+    video-set-spu-palette
+    video-get-navi
+    video-set-attributes
-- 
2.7.4

