Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42951 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754617AbcHSU2A (ORCPT
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
Subject: [PATCH 3/6] [media] docs-rst: Convert DVB uAPI to use C function references
Date: Fri, 19 Aug 2016 17:27:50 -0300
Message-Id: <f786825a0951182291984e01377139ab20dfce94.1471636893.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471636893.git.mchehab@s-opensource.com>
References: <cover.1471636893.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471636893.git.mchehab@s-opensource.com>
References: <cover.1471636893.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Name all ioctl references and make them match the ioctls that
are documented. That will improve the cross-reference index,
as it will have all ioctls and syscalls there.

While here, improve the documentation, marking the deprecated
ioctls, and making the non-deprecated ones more like the rest
of the media book.

Also, add a notice for ioctls that still require documentation.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../uapi/dvb/audio-bilingual-channel-select.rst    | 15 ++----
 .../media/uapi/dvb/audio-channel-select.rst        | 14 ++----
 .../media/uapi/dvb/audio-clear-buffer.rst          | 12 ++---
 Documentation/media/uapi/dvb/audio-continue.rst    | 11 ++---
 Documentation/media/uapi/dvb/audio-fclose.rst      |  4 +-
 Documentation/media/uapi/dvb/audio-fopen.rst       |  4 +-
 Documentation/media/uapi/dvb/audio-fwrite.rst      |  2 +
 .../media/uapi/dvb/audio-get-capabilities.rst      | 14 ++----
 Documentation/media/uapi/dvb/audio-get-pts.rst     | 14 ++----
 Documentation/media/uapi/dvb/audio-get-status.rst  | 14 ++----
 Documentation/media/uapi/dvb/audio-pause.rst       | 11 ++---
 Documentation/media/uapi/dvb/audio-play.rst        | 11 ++---
 .../media/uapi/dvb/audio-select-source.rst         | 14 ++----
 .../media/uapi/dvb/audio-set-attributes.rst        | 16 +++----
 Documentation/media/uapi/dvb/audio-set-av-sync.rst | 24 +++-------
 .../media/uapi/dvb/audio-set-bypass-mode.rst       | 25 +++-------
 Documentation/media/uapi/dvb/audio-set-ext-id.rst  | 15 ++----
 Documentation/media/uapi/dvb/audio-set-id.rst      | 15 ++----
 Documentation/media/uapi/dvb/audio-set-karaoke.rst | 14 ++----
 Documentation/media/uapi/dvb/audio-set-mixer.rst   | 15 ++----
 Documentation/media/uapi/dvb/audio-set-mute.rst    | 24 +++-------
 .../media/uapi/dvb/audio-set-streamtype.rst        | 14 ++----
 Documentation/media/uapi/dvb/audio-stop.rst        | 11 ++---
 Documentation/media/uapi/dvb/ca-fclose.rst         | 18 ++------
 Documentation/media/uapi/dvb/ca-fopen.rst          | 53 ++++++++--------------
 Documentation/media/uapi/dvb/ca-get-cap.rst        | 30 +++---------
 Documentation/media/uapi/dvb/ca-get-descr-info.rst | 31 +++----------
 Documentation/media/uapi/dvb/ca-get-msg.rst        | 30 +++---------
 Documentation/media/uapi/dvb/ca-get-slot-info.rst  | 30 +++---------
 Documentation/media/uapi/dvb/ca-reset.rst          | 24 ++--------
 Documentation/media/uapi/dvb/ca-send-msg.rst       | 30 +++---------
 Documentation/media/uapi/dvb/ca-set-descr.rst      | 30 +++---------
 Documentation/media/uapi/dvb/ca-set-pid.rst        | 30 +++---------
 Documentation/media/uapi/dvb/dmx-add-pid.rst       | 28 +++---------
 Documentation/media/uapi/dvb/dmx-fclose.rst        | 14 ++----
 Documentation/media/uapi/dvb/dmx-fopen.rst         | 47 ++++++++-----------
 Documentation/media/uapi/dvb/dmx-fread.rst         | 29 +++---------
 Documentation/media/uapi/dvb/dmx-fwrite.rst        | 30 +++---------
 Documentation/media/uapi/dvb/dmx-get-caps.rst      | 31 +++----------
 Documentation/media/uapi/dvb/dmx-get-event.rst     | 28 +++---------
 Documentation/media/uapi/dvb/dmx-get-pes-pids.rst  | 31 +++----------
 Documentation/media/uapi/dvb/dmx-get-stc.rst       | 31 +++----------
 Documentation/media/uapi/dvb/dmx-remove-pid.rst    | 28 +++---------
 .../media/uapi/dvb/dmx-set-buffer-size.rst         | 29 +++---------
 Documentation/media/uapi/dvb/dmx-set-filter.rst    | 28 +++---------
 .../media/uapi/dvb/dmx-set-pes-filter.rst          | 27 +++--------
 Documentation/media/uapi/dvb/dmx-set-source.rst    | 29 +++---------
 Documentation/media/uapi/dvb/dmx-start.rst         | 22 ++-------
 Documentation/media/uapi/dvb/dmx-stop.rst          | 22 ++-------
 .../media/uapi/dvb/fe-diseqc-recv-slave-reply.rst  |  6 +--
 .../media/uapi/dvb/fe-diseqc-reset-overload.rst    |  7 +--
 .../media/uapi/dvb/fe-diseqc-send-burst.rst        |  6 +--
 .../media/uapi/dvb/fe-diseqc-send-master-cmd.rst   |  6 +--
 .../uapi/dvb/fe-dishnetwork-send-legacy-cmd.rst    | 16 +++----
 .../media/uapi/dvb/fe-enable-high-lnb-voltage.rst  |  6 +--
 Documentation/media/uapi/dvb/fe-get-event.rst      | 35 ++++----------
 Documentation/media/uapi/dvb/fe-get-frontend.rst   | 30 ++++--------
 Documentation/media/uapi/dvb/fe-get-info.rst       |  6 +--
 Documentation/media/uapi/dvb/fe-get-property.rst   |  9 ++--
 Documentation/media/uapi/dvb/fe-read-ber.rst       | 30 ++++--------
 .../media/uapi/dvb/fe-read-signal-strength.rst     | 31 +++----------
 Documentation/media/uapi/dvb/fe-read-snr.rst       | 29 +++---------
 Documentation/media/uapi/dvb/fe-read-status.rst    |  6 +--
 .../media/uapi/dvb/fe-read-uncorrected-blocks.rst  | 31 +++----------
 .../media/uapi/dvb/fe-set-frontend-tune-mode.rst   |  6 +--
 Documentation/media/uapi/dvb/fe-set-frontend.rst   | 31 ++++---------
 Documentation/media/uapi/dvb/fe-set-tone.rst       |  6 +--
 Documentation/media/uapi/dvb/fe-set-voltage.rst    |  6 +--
 Documentation/media/uapi/dvb/frontend_f_close.rst  |  4 +-
 Documentation/media/uapi/dvb/frontend_f_open.rst   |  2 +-
 Documentation/media/uapi/dvb/net-add-if.rst        |  6 +--
 Documentation/media/uapi/dvb/net-get-if.rst        |  6 +--
 Documentation/media/uapi/dvb/net-remove-if.rst     |  6 +--
 .../media/uapi/dvb/video-clear-buffer.rst          |  4 +-
 Documentation/media/uapi/dvb/video-command.rst     |  4 +-
 Documentation/media/uapi/dvb/video-continue.rst    |  4 +-
 .../media/uapi/dvb/video-fast-forward.rst          |  4 +-
 Documentation/media/uapi/dvb/video-fclose.rst      |  1 +
 Documentation/media/uapi/dvb/video-fopen.rst       |  1 +
 Documentation/media/uapi/dvb/video-freeze.rst      |  4 +-
 Documentation/media/uapi/dvb/video-fwrite.rst      |  1 +
 .../media/uapi/dvb/video-get-capabilities.rst      |  4 +-
 Documentation/media/uapi/dvb/video-get-event.rst   |  4 +-
 .../media/uapi/dvb/video-get-frame-count.rst       |  4 +-
 .../media/uapi/dvb/video-get-frame-rate.rst        |  4 +-
 Documentation/media/uapi/dvb/video-get-navi.rst    |  4 +-
 Documentation/media/uapi/dvb/video-get-pts.rst     |  4 +-
 Documentation/media/uapi/dvb/video-get-size.rst    |  4 +-
 Documentation/media/uapi/dvb/video-get-status.rst  |  4 +-
 Documentation/media/uapi/dvb/video-play.rst        |  4 +-
 .../media/uapi/dvb/video-select-source.rst         |  4 +-
 .../media/uapi/dvb/video-set-attributes.rst        |  4 +-
 Documentation/media/uapi/dvb/video-set-blank.rst   |  4 +-
 .../media/uapi/dvb/video-set-display-format.rst    |  4 +-
 Documentation/media/uapi/dvb/video-set-format.rst  |  4 +-
 .../media/uapi/dvb/video-set-highlight.rst         |  4 +-
 Documentation/media/uapi/dvb/video-set-id.rst      |  4 +-
 .../media/uapi/dvb/video-set-spu-palette.rst       |  4 +-
 Documentation/media/uapi/dvb/video-set-spu.rst     |  4 +-
 .../media/uapi/dvb/video-set-streamtype.rst        |  4 +-
 Documentation/media/uapi/dvb/video-set-system.rst  |  4 +-
 Documentation/media/uapi/dvb/video-slowmotion.rst  |  4 +-
 .../media/uapi/dvb/video-stillpicture.rst          |  4 +-
 Documentation/media/uapi/dvb/video-stop.rst        |  4 +-
 Documentation/media/uapi/dvb/video-try-command.rst |  4 +-
 105 files changed, 474 insertions(+), 1045 deletions(-)

diff --git a/Documentation/media/uapi/dvb/audio-bilingual-channel-select.rst b/Documentation/media/uapi/dvb/audio-bilingual-channel-select.rst
index 841c9759d5e0..e048ee8f4d65 100644
--- a/Documentation/media/uapi/dvb/audio-bilingual-channel-select.rst
+++ b/Documentation/media/uapi/dvb/audio-bilingual-channel-select.rst
@@ -11,11 +11,13 @@ Name
 
 AUDIO_BILINGUAL_CHANNEL_SELECT
 
+.. attention:: This ioctl is deprecated
 
 Synopsis
 --------
 
-.. c:function:: int ioctl(int fd, int request = AUDIO_BILINGUAL_CHANNEL_SELECT, audio_channel_select_t)
+.. c:function:: int ioctl(int fd, AUDIO_BILINGUAL_CHANNEL_SELECT, audio_channel_select_t)
+    :name: AUDIO_BILINGUAL_CHANNEL_SELECT
 
 
 Arguments
@@ -25,20 +27,13 @@ Arguments
     :header-rows:  0
     :stub-columns: 0
 
-
-    -  .. row 1
+    -
 
        -  int fd
 
        -  File descriptor returned by a previous call to open().
 
-    -  .. row 2
-
-       -  int request
-
-       -  Equals AUDIO_BILINGUAL_CHANNEL_SELECT for this command.
-
-    -  .. row 3
+    -
 
        -  audio_channel_select_t ch
 
diff --git a/Documentation/media/uapi/dvb/audio-channel-select.rst b/Documentation/media/uapi/dvb/audio-channel-select.rst
index f2dd79903c49..03dcdbbfbbc6 100644
--- a/Documentation/media/uapi/dvb/audio-channel-select.rst
+++ b/Documentation/media/uapi/dvb/audio-channel-select.rst
@@ -11,11 +11,13 @@ Name
 
 AUDIO_CHANNEL_SELECT
 
+.. attention:: This ioctl is deprecated
 
 Synopsis
 --------
 
-.. c:function:: int ioctl(int fd, int request = AUDIO_CHANNEL_SELECT, audio_channel_select_t)
+.. c:function:: int ioctl(int fd, AUDIO_CHANNEL_SELECT, audio_channel_select_t)
+    :name: AUDIO_CHANNEL_SELECT
 
 
 Arguments
@@ -26,19 +28,13 @@ Arguments
     :stub-columns: 0
 
 
-    -  .. row 1
+    -
 
        -  int fd
 
        -  File descriptor returned by a previous call to open().
 
-    -  .. row 2
-
-       -  int request
-
-       -  Equals AUDIO_CHANNEL_SELECT for this command.
-
-    -  .. row 3
+    -
 
        -  audio_channel_select_t ch
 
diff --git a/Documentation/media/uapi/dvb/audio-clear-buffer.rst b/Documentation/media/uapi/dvb/audio-clear-buffer.rst
index a576c6b160a4..f6bed67cb070 100644
--- a/Documentation/media/uapi/dvb/audio-clear-buffer.rst
+++ b/Documentation/media/uapi/dvb/audio-clear-buffer.rst
@@ -11,12 +11,13 @@ Name
 
 AUDIO_CLEAR_BUFFER
 
+.. attention:: This ioctl is deprecated
 
 Synopsis
 --------
 
-.. c:function:: int  ioctl(int fd, int request = AUDIO_CLEAR_BUFFER)
-
+.. c:function:: int  ioctl(int fd, AUDIO_CLEAR_BUFFER)
+    :name: AUDIO_CLEAR_BUFFER
 
 Arguments
 ---------
@@ -32,13 +33,6 @@ Arguments
 
        -  File descriptor returned by a previous call to open().
 
-    -  .. row 2
-
-       -  int request
-
-       -  Equals AUDIO_CLEAR_BUFFER for this command.
-
-
 Description
 -----------
 
diff --git a/Documentation/media/uapi/dvb/audio-continue.rst b/Documentation/media/uapi/dvb/audio-continue.rst
index b513a39f0935..ca587869306e 100644
--- a/Documentation/media/uapi/dvb/audio-continue.rst
+++ b/Documentation/media/uapi/dvb/audio-continue.rst
@@ -11,11 +11,13 @@ Name
 
 AUDIO_CONTINUE
 
+.. attention:: This ioctl is deprecated
 
 Synopsis
 --------
 
-.. c:function:: int  ioctl(int fd, int request = AUDIO_CONTINUE)
+.. c:function:: int  ioctl(int fd, AUDIO_CONTINUE)
+    :name: AUDIO_CONTINUE
 
 
 Arguments
@@ -32,13 +34,6 @@ Arguments
 
        -  File descriptor returned by a previous call to open().
 
-    -  .. row 2
-
-       -  int request
-
-       -  Equals AUDIO_CONTINUE for this command.
-
-
 Description
 -----------
 
diff --git a/Documentation/media/uapi/dvb/audio-fclose.rst b/Documentation/media/uapi/dvb/audio-fclose.rst
index e515fb353a14..4df24c8d74ed 100644
--- a/Documentation/media/uapi/dvb/audio-fclose.rst
+++ b/Documentation/media/uapi/dvb/audio-fclose.rst
@@ -11,11 +11,13 @@ Name
 
 DVB audio close()
 
+.. attention:: This ioctl is deprecated
 
 Synopsis
 --------
 
-.. c:function:: int  close(int fd)
+.. c:function:: int close(int fd)
+    :name: dvb-audio-close
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/audio-fopen.rst b/Documentation/media/uapi/dvb/audio-fopen.rst
index b629956bca5d..a802c2e0dc6a 100644
--- a/Documentation/media/uapi/dvb/audio-fopen.rst
+++ b/Documentation/media/uapi/dvb/audio-fopen.rst
@@ -11,11 +11,13 @@ Name
 
 DVB audio open()
 
+.. attention:: This ioctl is deprecated
 
 Synopsis
 --------
 
-.. c:function:: int  open(const char *deviceName, int flags)
+.. c:function:: int open(const char *deviceName, int flags)
+    :name: dvb-audio-open
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/audio-fwrite.rst b/Documentation/media/uapi/dvb/audio-fwrite.rst
index f9307053064f..8882cad7d165 100644
--- a/Documentation/media/uapi/dvb/audio-fwrite.rst
+++ b/Documentation/media/uapi/dvb/audio-fwrite.rst
@@ -11,11 +11,13 @@ Name
 
 DVB audio write()
 
+.. attention:: This ioctl is deprecated
 
 Synopsis
 --------
 
 .. c:function:: size_t write(int fd, const void *buf, size_t count)
+    :name: dvb-audio-write
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/audio-get-capabilities.rst b/Documentation/media/uapi/dvb/audio-get-capabilities.rst
index 8b6fdc664f9d..0d867f189c22 100644
--- a/Documentation/media/uapi/dvb/audio-get-capabilities.rst
+++ b/Documentation/media/uapi/dvb/audio-get-capabilities.rst
@@ -11,11 +11,13 @@ Name
 
 AUDIO_GET_CAPABILITIES
 
+.. attention:: This ioctl is deprecated
 
 Synopsis
 --------
 
-.. c:function:: int ioctl(int fd, int request = AUDIO_GET_CAPABILITIES, unsigned int *cap)
+.. c:function:: int ioctl(int fd, AUDIO_GET_CAPABILITIES, unsigned int *cap)
+    :name: AUDIO_GET_CAPABILITIES
 
 
 Arguments
@@ -26,19 +28,13 @@ Arguments
     :stub-columns: 0
 
 
-    -  .. row 1
+    -
 
        -  int fd
 
        -  File descriptor returned by a previous call to open().
 
-    -  .. row 2
-
-       -  int request
-
-       -  Equals AUDIO_GET_CAPABILITIES for this command.
-
-    -  .. row 3
+    -
 
        -  unsigned int \*cap
 
diff --git a/Documentation/media/uapi/dvb/audio-get-pts.rst b/Documentation/media/uapi/dvb/audio-get-pts.rst
index 246c78c003de..2d1396b003de 100644
--- a/Documentation/media/uapi/dvb/audio-get-pts.rst
+++ b/Documentation/media/uapi/dvb/audio-get-pts.rst
@@ -11,11 +11,13 @@ Name
 
 AUDIO_GET_PTS
 
+.. attention:: This ioctl is deprecated
 
 Synopsis
 --------
 
-.. c:function:: int ioctl(int fd, int request = AUDIO_GET_PTS, __u64 *pts)
+.. c:function:: int ioctl(int fd, AUDIO_GET_PTS, __u64 *pts)
+    :name: AUDIO_GET_PTS
 
 
 Arguments
@@ -26,19 +28,13 @@ Arguments
     :stub-columns: 0
 
 
-    -  .. row 1
+    -
 
        -  int fd
 
        -  File descriptor returned by a previous call to open().
 
-    -  .. row 2
-
-       -  int request
-
-       -  Equals AUDIO_GET_PTS for this command.
-
-    -  .. row 3
+    -
 
        -  __u64 \*pts
 
diff --git a/Documentation/media/uapi/dvb/audio-get-status.rst b/Documentation/media/uapi/dvb/audio-get-status.rst
index b0a550af87b3..857b058325f1 100644
--- a/Documentation/media/uapi/dvb/audio-get-status.rst
+++ b/Documentation/media/uapi/dvb/audio-get-status.rst
@@ -11,11 +11,13 @@ Name
 
 AUDIO_GET_STATUS
 
+.. attention:: This ioctl is deprecated
 
 Synopsis
 --------
 
-.. c:function:: int ioctl(int fd, int request = AUDIO_GET_STATUS, struct audio_status *status)
+.. c:function:: int ioctl(int fd, AUDIO_GET_STATUS, struct audio_status *status)
+    :name: AUDIO_GET_STATUS
 
 
 Arguments
@@ -26,19 +28,13 @@ Arguments
     :stub-columns: 0
 
 
-    -  .. row 1
+    -
 
        -  int fd
 
        -  File descriptor returned by a previous call to open().
 
-    -  .. row 2
-
-       -  int request
-
-       -  Equals AUDIO_GET_STATUS for this command.
-
-    -  .. row 3
+    -
 
        -  struct audio_status \*status
 
diff --git a/Documentation/media/uapi/dvb/audio-pause.rst b/Documentation/media/uapi/dvb/audio-pause.rst
index 86652c3bca06..c7310dffbff2 100644
--- a/Documentation/media/uapi/dvb/audio-pause.rst
+++ b/Documentation/media/uapi/dvb/audio-pause.rst
@@ -11,12 +11,13 @@ Name
 
 AUDIO_PAUSE
 
+.. attention:: This ioctl is deprecated
 
 Synopsis
 --------
 
-.. c:function:: int  ioctl(int fd, int request = AUDIO_PAUSE)
-
+.. c:function:: int  ioctl(int fd, AUDIO_PAUSE)
+    :name: AUDIO_PAUSE
 
 Arguments
 ---------
@@ -32,12 +33,6 @@ Arguments
 
        -  File descriptor returned by a previous call to open().
 
-    -  .. row 2
-
-       -  int request
-
-       -  Equals AUDIO_PAUSE for this command.
-
 
 Description
 -----------
diff --git a/Documentation/media/uapi/dvb/audio-play.rst b/Documentation/media/uapi/dvb/audio-play.rst
index 1af708375821..943b5eec9f28 100644
--- a/Documentation/media/uapi/dvb/audio-play.rst
+++ b/Documentation/media/uapi/dvb/audio-play.rst
@@ -11,11 +11,13 @@ Name
 
 AUDIO_PLAY
 
+.. attention:: This ioctl is deprecated
 
 Synopsis
 --------
 
-.. c:function:: int  ioctl(int fd, int request = AUDIO_PLAY)
+.. c:function:: int  ioctl(int fd, AUDIO_PLAY)
+    :name: AUDIO_PLAY
 
 
 Arguments
@@ -32,13 +34,6 @@ Arguments
 
        -  File descriptor returned by a previous call to open().
 
-    -  .. row 2
-
-       -  int request
-
-       -  Equals AUDIO_PLAY for this command.
-
-
 Description
 -----------
 
diff --git a/Documentation/media/uapi/dvb/audio-select-source.rst b/Documentation/media/uapi/dvb/audio-select-source.rst
index 3e873d9cb345..e4ea98787619 100644
--- a/Documentation/media/uapi/dvb/audio-select-source.rst
+++ b/Documentation/media/uapi/dvb/audio-select-source.rst
@@ -11,11 +11,13 @@ Name
 
 AUDIO_SELECT_SOURCE
 
+.. attention:: This ioctl is deprecated
 
 Synopsis
 --------
 
-.. c:function:: int ioctl(int fd, int request = AUDIO_SELECT_SOURCE, audio_stream_source_t source)
+.. c:function:: int ioctl(int fd, AUDIO_SELECT_SOURCE, audio_stream_source_t source)
+    :name: AUDIO_SELECT_SOURCE
 
 
 Arguments
@@ -26,19 +28,13 @@ Arguments
     :stub-columns: 0
 
 
-    -  .. row 1
+    -
 
        -  int fd
 
        -  File descriptor returned by a previous call to open().
 
-    -  .. row 2
-
-       -  int request
-
-       -  Equals AUDIO_SELECT_SOURCE for this command.
-
-    -  .. row 3
+    -
 
        -  audio_stream_source_t source
 
diff --git a/Documentation/media/uapi/dvb/audio-set-attributes.rst b/Documentation/media/uapi/dvb/audio-set-attributes.rst
index 43ff50279742..ad89a37cf83c 100644
--- a/Documentation/media/uapi/dvb/audio-set-attributes.rst
+++ b/Documentation/media/uapi/dvb/audio-set-attributes.rst
@@ -11,12 +11,14 @@ Name
 
 AUDIO_SET_ATTRIBUTES
 
+.. attention:: This ioctl is deprecated
+
 
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = AUDIO_SET_ATTRIBUTES, audio_attributes_t attr )
-
+.. c:function:: int ioctl(fd, AUDIO_SET_ATTRIBUTES, audio_attributes_t attr )
+    :name: AUDIO_SET_ATTRIBUTES
 
 Arguments
 ---------
@@ -26,19 +28,13 @@ Arguments
     :stub-columns: 0
 
 
-    -  .. row 1
+    -
 
        -  int fd
 
        -  File descriptor returned by a previous call to open().
 
-    -  .. row 2
-
-       -  int request
-
-       -  Equals AUDIO_SET_ATTRIBUTES for this command.
-
-    -  .. row 3
+    -
 
        -  audio_attributes_t attr
 
diff --git a/Documentation/media/uapi/dvb/audio-set-av-sync.rst b/Documentation/media/uapi/dvb/audio-set-av-sync.rst
index 4ecfb75d28f1..0cef4917d2cf 100644
--- a/Documentation/media/uapi/dvb/audio-set-av-sync.rst
+++ b/Documentation/media/uapi/dvb/audio-set-av-sync.rst
@@ -11,11 +11,13 @@ Name
 
 AUDIO_SET_AV_SYNC
 
+.. attention:: This ioctl is deprecated
 
 Synopsis
 --------
 
-.. c:function:: int  ioctl(int fd, int request = AUDIO_SET_AV_SYNC, boolean state)
+.. c:function:: int  ioctl(int fd, AUDIO_SET_AV_SYNC, boolean state)
+    :name: AUDIO_SET_AV_SYNC
 
 
 Arguments
@@ -26,33 +28,21 @@ Arguments
     :stub-columns: 0
 
 
-    -  .. row 1
+    -
 
        -  int fd
 
        -  File descriptor returned by a previous call to open().
 
-    -  .. row 2
-
-       -  int request
-
-       -  Equals AUDIO_AV_SYNC for this command.
-
-    -  .. row 3
+    -
 
        -  boolean state
 
        -  Tells the DVB subsystem if A/V synchronization shall be ON or OFF.
 
-    -  .. row 4
+          TRUE: AV-sync ON
 
-       -
-       -  TRUE AV-sync ON
-
-    -  .. row 5
-
-       -
-       -  FALSE AV-sync OFF
+          FALSE: AV-sync OFF
 
 
 Description
diff --git a/Documentation/media/uapi/dvb/audio-set-bypass-mode.rst b/Documentation/media/uapi/dvb/audio-set-bypass-mode.rst
index b21d142ec31c..b063c496c2eb 100644
--- a/Documentation/media/uapi/dvb/audio-set-bypass-mode.rst
+++ b/Documentation/media/uapi/dvb/audio-set-bypass-mode.rst
@@ -11,12 +11,13 @@ Name
 
 AUDIO_SET_BYPASS_MODE
 
+.. attention:: This ioctl is deprecated
 
 Synopsis
 --------
 
-.. c:function:: int ioctl(int fd, int request = AUDIO_SET_BYPASS_MODE, boolean mode)
-
+.. c:function:: int ioctl(int fd, AUDIO_SET_BYPASS_MODE, boolean mode)
+    :name: AUDIO_SET_BYPASS_MODE
 
 Arguments
 ---------
@@ -26,34 +27,22 @@ Arguments
     :stub-columns: 0
 
 
-    -  .. row 1
+    -
 
        -  int fd
 
        -  File descriptor returned by a previous call to open().
 
-    -  .. row 2
-
-       -  int request
-
-       -  Equals AUDIO_SET_BYPASS_MODE for this command.
-
-    -  .. row 3
+    -
 
        -  boolean mode
 
        -  Enables or disables the decoding of the current Audio stream in
 	  the DVB subsystem.
 
-    -  .. row 4
+          TRUE: Bypass is disabled
 
-       -
-       -  TRUE Bypass is disabled
-
-    -  .. row 5
-
-       -
-       -  FALSE Bypass is enabled
+          FALSE: Bypass is enabled
 
 
 Description
diff --git a/Documentation/media/uapi/dvb/audio-set-ext-id.rst b/Documentation/media/uapi/dvb/audio-set-ext-id.rst
index 1b5b8893a00b..8503c47f26bd 100644
--- a/Documentation/media/uapi/dvb/audio-set-ext-id.rst
+++ b/Documentation/media/uapi/dvb/audio-set-ext-id.rst
@@ -11,12 +11,13 @@ Name
 
 AUDIO_SET_EXT_ID
 
+.. attention:: This ioctl is deprecated
 
 Synopsis
 --------
 
-.. c:function:: int  ioctl(fd, int request = AUDIO_SET_EXT_ID, int id)
-
+.. c:function:: int  ioctl(fd, AUDIO_SET_EXT_ID, int id)
+    :name: AUDIO_SET_EXT_ID
 
 Arguments
 ---------
@@ -26,19 +27,13 @@ Arguments
     :stub-columns: 0
 
 
-    -  .. row 1
+    -
 
        -  int fd
 
        -  File descriptor returned by a previous call to open().
 
-    -  .. row 2
-
-       -  int request
-
-       -  Equals AUDIO_SET_EXT_ID for this command.
-
-    -  .. row 3
+    -
 
        -  int id
 
diff --git a/Documentation/media/uapi/dvb/audio-set-id.rst b/Documentation/media/uapi/dvb/audio-set-id.rst
index fed99eae52cb..8b1081d24473 100644
--- a/Documentation/media/uapi/dvb/audio-set-id.rst
+++ b/Documentation/media/uapi/dvb/audio-set-id.rst
@@ -11,12 +11,13 @@ Name
 
 AUDIO_SET_ID
 
+.. attention:: This ioctl is deprecated
 
 Synopsis
 --------
 
-.. c:function:: int  ioctl(int fd, int request = AUDIO_SET_ID, int id)
-
+.. c:function:: int  ioctl(int fd, AUDIO_SET_ID, int id)
+    :name: AUDIO_SET_ID
 
 Arguments
 ---------
@@ -26,19 +27,13 @@ Arguments
     :stub-columns: 0
 
 
-    -  .. row 1
+    -
 
        -  int fd
 
        -  File descriptor returned by a previous call to open().
 
-    -  .. row 2
-
-       -  int request
-
-       -  Equals AUDIO_SET_ID for this command.
-
-    -  .. row 3
+    -
 
        -  int id
 
diff --git a/Documentation/media/uapi/dvb/audio-set-karaoke.rst b/Documentation/media/uapi/dvb/audio-set-karaoke.rst
index ebb2d41bbec3..78571abdd93a 100644
--- a/Documentation/media/uapi/dvb/audio-set-karaoke.rst
+++ b/Documentation/media/uapi/dvb/audio-set-karaoke.rst
@@ -11,11 +11,13 @@ Name
 
 AUDIO_SET_KARAOKE
 
+.. attention:: This ioctl is deprecated
 
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = AUDIO_SET_KARAOKE, audio_karaoke_t *karaoke)
+.. c:function:: int ioctl(fd, AUDIO_SET_KARAOKE, audio_karaoke_t *karaoke)
+    :name: AUDIO_SET_KARAOKE
 
 
 Arguments
@@ -26,19 +28,13 @@ Arguments
     :stub-columns: 0
 
 
-    -  .. row 1
+    -
 
        -  int fd
 
        -  File descriptor returned by a previous call to open().
 
-    -  .. row 2
-
-       -  int request
-
-       -  Equals AUDIO_SET_KARAOKE for this command.
-
-    -  .. row 3
+    -
 
        -  audio_karaoke_t \*karaoke
 
diff --git a/Documentation/media/uapi/dvb/audio-set-mixer.rst b/Documentation/media/uapi/dvb/audio-set-mixer.rst
index ce4b2a63917e..657bd89b8a6a 100644
--- a/Documentation/media/uapi/dvb/audio-set-mixer.rst
+++ b/Documentation/media/uapi/dvb/audio-set-mixer.rst
@@ -11,12 +11,13 @@ Name
 
 AUDIO_SET_MIXER
 
+.. attention:: This ioctl is deprecated
 
 Synopsis
 --------
 
-.. c:function:: int ioctl(int fd, int request = AUDIO_SET_MIXER, audio_mixer_t *mix)
-
+.. c:function:: int ioctl(int fd, AUDIO_SET_MIXER, audio_mixer_t *mix)
+    :name: AUDIO_SET_MIXER
 
 Arguments
 ---------
@@ -26,19 +27,13 @@ Arguments
     :stub-columns: 0
 
 
-    -  .. row 1
+    -
 
        -  int fd
 
        -  File descriptor returned by a previous call to open().
 
-    -  .. row 2
-
-       -  int request
-
-       -  Equals AUDIO_SET_ID for this command.
-
-    -  .. row 3
+    -
 
        -  audio_mixer_t \*mix
 
diff --git a/Documentation/media/uapi/dvb/audio-set-mute.rst b/Documentation/media/uapi/dvb/audio-set-mute.rst
index a2469267508b..897e7228f4d8 100644
--- a/Documentation/media/uapi/dvb/audio-set-mute.rst
+++ b/Documentation/media/uapi/dvb/audio-set-mute.rst
@@ -11,11 +11,13 @@ Name
 
 AUDIO_SET_MUTE
 
+.. attention:: This ioctl is deprecated
 
 Synopsis
 --------
 
-.. c:function:: int  ioctl(int fd, int request = AUDIO_SET_MUTE, boolean state)
+.. c:function:: int  ioctl(int fd, AUDIO_SET_MUTE, boolean state)
+    :name: AUDIO_SET_MUTE
 
 
 Arguments
@@ -26,33 +28,21 @@ Arguments
     :stub-columns: 0
 
 
-    -  .. row 1
+    -
 
        -  int fd
 
        -  File descriptor returned by a previous call to open().
 
-    -  .. row 2
-
-       -  int request
-
-       -  Equals AUDIO_SET_MUTE for this command.
-
-    -  .. row 3
+    -
 
        -  boolean state
 
        -  Indicates if audio device shall mute or not.
 
-    -  .. row 4
+          TRUE: Audio Mute
 
-       -
-       -  TRUE Audio Mute
-
-    -  .. row 5
-
-       -
-       -  FALSE Audio Un-mute
+          FALSE: Audio Un-mute
 
 
 Description
diff --git a/Documentation/media/uapi/dvb/audio-set-streamtype.rst b/Documentation/media/uapi/dvb/audio-set-streamtype.rst
index 4b13c9b9dffe..46c0362ac71d 100644
--- a/Documentation/media/uapi/dvb/audio-set-streamtype.rst
+++ b/Documentation/media/uapi/dvb/audio-set-streamtype.rst
@@ -11,11 +11,13 @@ Name
 
 AUDIO_SET_STREAMTYPE
 
+.. attention:: This ioctl is deprecated
 
 Synopsis
 --------
 
-.. c:function:: int  ioctl(fd, int request = AUDIO_SET_STREAMTYPE, int type)
+.. c:function:: int  ioctl(fd, AUDIO_SET_STREAMTYPE, int type)
+    :name: AUDIO_SET_STREAMTYPE
 
 
 Arguments
@@ -26,19 +28,13 @@ Arguments
     :stub-columns: 0
 
 
-    -  .. row 1
+    -
 
        -  int fd
 
        -  File descriptor returned by a previous call to open().
 
-    -  .. row 2
-
-       -  int request
-
-       -  Equals AUDIO_SET_STREAMTYPE for this command.
-
-    -  .. row 3
+    -
 
        -  int type
 
diff --git a/Documentation/media/uapi/dvb/audio-stop.rst b/Documentation/media/uapi/dvb/audio-stop.rst
index d9430978096f..dd6c3b6826ec 100644
--- a/Documentation/media/uapi/dvb/audio-stop.rst
+++ b/Documentation/media/uapi/dvb/audio-stop.rst
@@ -11,12 +11,13 @@ Name
 
 AUDIO_STOP
 
+.. attention:: This ioctl is deprecated
 
 Synopsis
 --------
 
-.. c:function:: int ioctl(int fd, int request = AUDIO_STOP)
-
+.. c:function:: int ioctl(int fd, AUDIO_STOP)
+    :name: AUDIO_STOP
 
 Arguments
 ---------
@@ -32,12 +33,6 @@ Arguments
 
        -  File descriptor returned by a previous call to open().
 
-    -  .. row 2
-
-       -  int request
-
-       -  Equals AUDIO_STOP for this command.
-
 
 Description
 -----------
diff --git a/Documentation/media/uapi/dvb/ca-fclose.rst b/Documentation/media/uapi/dvb/ca-fclose.rst
index f2ea50b87485..5ecefa4abc3d 100644
--- a/Documentation/media/uapi/dvb/ca-fclose.rst
+++ b/Documentation/media/uapi/dvb/ca-fclose.rst
@@ -15,28 +15,20 @@ DVB CA close()
 Synopsis
 --------
 
-.. c:function:: int  close(int fd)
+.. c:function:: int close(int fd)
+    :name: dvb-ca-close
 
 
 Arguments
 ---------
 
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
+``fd``
+  File descriptor returned by a previous call to :c:func:`open() <dvb-ca-open>`.
 
 Description
 -----------
 
-This system call closes a previously opened audio device.
+This system call closes a previously opened CA device.
 
 
 Return Value
diff --git a/Documentation/media/uapi/dvb/ca-fopen.rst b/Documentation/media/uapi/dvb/ca-fopen.rst
index 8085a73e81c5..3d2819751446 100644
--- a/Documentation/media/uapi/dvb/ca-fopen.rst
+++ b/Documentation/media/uapi/dvb/ca-fopen.rst
@@ -15,48 +15,35 @@ DVB CA open()
 Synopsis
 --------
 
-.. c:function:: int  open(const char *deviceName, int flags)
+.. c:function:: int open(const char *name, int flags)
+    :name: dvb-ca-open
 
 
 Arguments
 ---------
 
+``name``
+  Name of specific DVB CA device.
+
+``flags``
+  A bit-wise OR of the following flags:
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
 
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
+    -
+       - O_RDONLY
+       - read-only access
+
+    -
+       - O_RDWR
+       - read/write access
+
+    -
+       - O_NONBLOCK
+       - open in non-blocking mode
+         (blocking mode is the default)
 
 
 Description
diff --git a/Documentation/media/uapi/dvb/ca-get-cap.rst b/Documentation/media/uapi/dvb/ca-get-cap.rst
index 55e49fd93c2c..3486805b62a9 100644
--- a/Documentation/media/uapi/dvb/ca-get-cap.rst
+++ b/Documentation/media/uapi/dvb/ca-get-cap.rst
@@ -15,40 +15,24 @@ CA_GET_CAP
 Synopsis
 --------
 
-.. c:function:: int  ioctl(fd, int request = CA_GET_CAP, ca_caps_t *)
+.. c:function:: int ioctl(fd, CA_GET_CAP, ca_caps_t *caps)
+    :name: CA_GET_CAP
 
 
 Arguments
 ---------
 
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
+``fd``
+  File descriptor returned by a previous call to :c:func:`open() <dvb-ca-open>`.
 
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
+``caps``
+  Undocumented.
 
 
 Description
 -----------
 
-This ioctl is undocumented. Documentation is welcome.
+.. note:: This ioctl is undocumented. Documentation is welcome.
 
 
 Return Value
diff --git a/Documentation/media/uapi/dvb/ca-get-descr-info.rst b/Documentation/media/uapi/dvb/ca-get-descr-info.rst
index e546e58ef7f8..b007f10b4910 100644
--- a/Documentation/media/uapi/dvb/ca-get-descr-info.rst
+++ b/Documentation/media/uapi/dvb/ca-get-descr-info.rst
@@ -15,40 +15,23 @@ CA_GET_DESCR_INFO
 Synopsis
 --------
 
-.. c:function:: int  ioctl(fd, int request = CA_GET_DESCR_INFO, ca_descr_info_t *)
-
+.. c:function:: int  ioctl(fd, CA_GET_DESCR_INFO, ca_descr_info_t *desc)
+    :name: CA_GET_DESCR_INFO
 
 Arguments
 ---------
 
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
+``fd``
+  File descriptor returned by a previous call to :c:func:`open() <dvb-ca-open>`.
 
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
+``desc``
+  Undocumented.
 
 
 Description
 -----------
 
-This ioctl is undocumented. Documentation is welcome.
+.. note:: This ioctl is undocumented. Documentation is welcome.
 
 
 Return Value
diff --git a/Documentation/media/uapi/dvb/ca-get-msg.rst b/Documentation/media/uapi/dvb/ca-get-msg.rst
index e0d2c8853e63..880995230909 100644
--- a/Documentation/media/uapi/dvb/ca-get-msg.rst
+++ b/Documentation/media/uapi/dvb/ca-get-msg.rst
@@ -15,40 +15,24 @@ CA_GET_MSG
 Synopsis
 --------
 
-.. c:function:: int  ioctl(fd, int request = CA_GET_MSG, ca_msg_t *)
+.. c:function:: int ioctl(fd, CA_GET_MSG, ca_msg_t *msg)
+    :name: CA_GET_MSG
 
 
 Arguments
 ---------
 
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
+``fd``
+  File descriptor returned by a previous call to :c:func:`open() <dvb-ca-open>`.
 
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
+``msg``
+  Undocumented.
 
 
 Description
 -----------
 
-This ioctl is undocumented. Documentation is welcome.
+.. note:: This ioctl is undocumented. Documentation is welcome.
 
 
 Return Value
diff --git a/Documentation/media/uapi/dvb/ca-get-slot-info.rst b/Documentation/media/uapi/dvb/ca-get-slot-info.rst
index 6c46a5395f45..fcecd80e30d4 100644
--- a/Documentation/media/uapi/dvb/ca-get-slot-info.rst
+++ b/Documentation/media/uapi/dvb/ca-get-slot-info.rst
@@ -15,40 +15,24 @@ CA_GET_SLOT_INFO
 Synopsis
 --------
 
-.. c:function:: int  ioctl(fd, int request = CA_GET_SLOT_INFO, ca_slot_info_t *)
+.. c:function:: int ioctl(fd, CA_GET_SLOT_INFO, ca_slot_info_t *info)
+    :name: CA_GET_SLOT_INFO
 
 
 Arguments
 ---------
 
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
+``fd``
+  File descriptor returned by a previous call to :c:func:`open() <cec-open>`.
 
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
+``info``
+  Undocumented.
 
 
 Description
 -----------
 
-This ioctl is undocumented. Documentation is welcome.
+.. note:: This ioctl is undocumented. Documentation is welcome.
 
 
 Return Value
diff --git a/Documentation/media/uapi/dvb/ca-reset.rst b/Documentation/media/uapi/dvb/ca-reset.rst
index a91f969318fb..477313121a65 100644
--- a/Documentation/media/uapi/dvb/ca-reset.rst
+++ b/Documentation/media/uapi/dvb/ca-reset.rst
@@ -15,34 +15,20 @@ CA_RESET
 Synopsis
 --------
 
-.. c:function:: int  ioctl(fd, int request = CA_RESET)
+.. c:function:: int ioctl(fd, CA_RESET)
+    :name: CA_RESET
 
 
 Arguments
 ---------
 
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
+``fd``
+  File descriptor returned by a previous call to :c:func:`open() <cec-open>`.
 
 Description
 -----------
 
-This ioctl is undocumented. Documentation is welcome.
+.. note:: This ioctl is undocumented. Documentation is welcome.
 
 
 Return Value
diff --git a/Documentation/media/uapi/dvb/ca-send-msg.rst b/Documentation/media/uapi/dvb/ca-send-msg.rst
index 5e4fd4f7b683..0c42b10cf4f4 100644
--- a/Documentation/media/uapi/dvb/ca-send-msg.rst
+++ b/Documentation/media/uapi/dvb/ca-send-msg.rst
@@ -15,40 +15,24 @@ CA_SEND_MSG
 Synopsis
 --------
 
-.. c:function:: int  ioctl(fd, int request = CA_SEND_MSG, ca_msg_t *)
+.. c:function:: int ioctl(fd, CA_SEND_MSG, ca_msg_t *msg)
+    :name: CA_SEND_MSG
 
 
 Arguments
 ---------
 
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
+``fd``
+  File descriptor returned by a previous call to :c:func:`open() <cec-open>`.
 
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
+``msg``
+  Undocumented.
 
 
 Description
 -----------
 
-This ioctl is undocumented. Documentation is welcome.
+.. note:: This ioctl is undocumented. Documentation is welcome.
 
 
 Return Value
diff --git a/Documentation/media/uapi/dvb/ca-set-descr.rst b/Documentation/media/uapi/dvb/ca-set-descr.rst
index 2822718d655b..63dcc2b751ef 100644
--- a/Documentation/media/uapi/dvb/ca-set-descr.rst
+++ b/Documentation/media/uapi/dvb/ca-set-descr.rst
@@ -15,40 +15,24 @@ CA_SET_DESCR
 Synopsis
 --------
 
-.. c:function:: int  ioctl(fd, int request = CA_SET_DESCR, ca_descr_t *)
+.. c:function:: int ioctl(fd, CA_SET_DESCR, ca_descr_t *desc)
+    :name:
 
 
 Arguments
 ---------
 
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
+``fd``
+  File descriptor returned by a previous call to :c:func:`open() <cec-open>`.
 
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
+``msg``
+  Undocumented.
 
 
 Description
 -----------
 
-This ioctl is undocumented. Documentation is welcome.
+.. note:: This ioctl is undocumented. Documentation is welcome.
 
 
 Return Value
diff --git a/Documentation/media/uapi/dvb/ca-set-pid.rst b/Documentation/media/uapi/dvb/ca-set-pid.rst
index 1ea95c7ef4e6..8e13ad9595d3 100644
--- a/Documentation/media/uapi/dvb/ca-set-pid.rst
+++ b/Documentation/media/uapi/dvb/ca-set-pid.rst
@@ -15,40 +15,24 @@ CA_SET_PID
 Synopsis
 --------
 
-.. c:function:: int  ioctl(fd, int request = CA_SET_PID, ca_pid_t *)
+.. c:function:: int ioctl(fd, CA_SET_PID, ca_pid_t *pid)
+    :name: CA_SET_PID
 
 
 Arguments
 ---------
 
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
+``fd``
+  File descriptor returned by a previous call to :c:func:`open() <dvb-ca-open>`.
 
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
+``pid``
+  Undocumented.
 
 
 Description
 -----------
 
-This ioctl is undocumented. Documentation is welcome.
+.. note:: This ioctl is undocumented. Documentation is welcome.
 
 
 Return Value
diff --git a/Documentation/media/uapi/dvb/dmx-add-pid.rst b/Documentation/media/uapi/dvb/dmx-add-pid.rst
index 37f5ee43d523..689cd1fc9142 100644
--- a/Documentation/media/uapi/dvb/dmx-add-pid.rst
+++ b/Documentation/media/uapi/dvb/dmx-add-pid.rst
@@ -15,34 +15,18 @@ DMX_ADD_PID
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = DMX_ADD_PID, __u16 *)
+.. c:function:: int ioctl(fd, DMX_ADD_PID, __u16 *pid)
+    :name: DMX_ADD_PID
 
 
 Arguments
 ---------
 
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
+``fd``
+    File descriptor returned by :c:func:`open() <dvb-dmx-open>`.
 
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
+``pid``
+   PID number to be filtered.
 
 
 Description
diff --git a/Documentation/media/uapi/dvb/dmx-fclose.rst b/Documentation/media/uapi/dvb/dmx-fclose.rst
index e442881481a2..ca93c23cde6d 100644
--- a/Documentation/media/uapi/dvb/dmx-fclose.rst
+++ b/Documentation/media/uapi/dvb/dmx-fclose.rst
@@ -16,22 +16,14 @@ Synopsis
 --------
 
 .. c:function:: int close(int fd)
+    :name: dvb-dmx-close
 
 
 Arguments
 ---------
 
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
+``fd``
+  File descriptor returned by a previous call to :c:func:`open() <dvb-ca-open>`.
 
 Description
 -----------
diff --git a/Documentation/media/uapi/dvb/dmx-fopen.rst b/Documentation/media/uapi/dvb/dmx-fopen.rst
index 7e640fa860c3..a697e33c32ea 100644
--- a/Documentation/media/uapi/dvb/dmx-fopen.rst
+++ b/Documentation/media/uapi/dvb/dmx-fopen.rst
@@ -16,42 +16,33 @@ Synopsis
 --------
 
 .. c:function:: int open(const char *deviceName, int flags)
-
+    :name: dvb-dmx-open
 
 Arguments
 ---------
 
+``name``
+  Name of specific DVB demux device.
+
+``flags``
+  A bit-wise OR of the following flags:
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
 
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
+    -
+       - O_RDONLY
+       - read-only access
+
+    -
+       - O_RDWR
+       - read/write access
+
+    -
+       - O_NONBLOCK
+       - open in non-blocking mode
+         (blocking mode is the default)
 
 
 Description
diff --git a/Documentation/media/uapi/dvb/dmx-fread.rst b/Documentation/media/uapi/dvb/dmx-fread.rst
index efa2a01096c1..e8c7f4db353f 100644
--- a/Documentation/media/uapi/dvb/dmx-fread.rst
+++ b/Documentation/media/uapi/dvb/dmx-fread.rst
@@ -16,34 +16,19 @@ Synopsis
 --------
 
 .. c:function:: size_t read(int fd, void *buf, size_t count)
-
+    :name: dvb-dmx-read
 
 Arguments
 ---------
 
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
+``fd``
+  File descriptor returned by a previous call to :c:func:`open() <dvb-ca-open>`.
 
+ ``buf``
+   Buffer to be filled
 
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
+``count``
+   Max number of bytes to read
 
 Description
 -----------
diff --git a/Documentation/media/uapi/dvb/dmx-fwrite.rst b/Documentation/media/uapi/dvb/dmx-fwrite.rst
index c05a44c4535f..8a90dfe28307 100644
--- a/Documentation/media/uapi/dvb/dmx-fwrite.rst
+++ b/Documentation/media/uapi/dvb/dmx-fwrite.rst
@@ -16,34 +16,19 @@ Synopsis
 --------
 
 .. c:function:: ssize_t write(int fd, const void *buf, size_t count)
-
+    :name: dvb-dmx-write
 
 Arguments
 ---------
 
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
+``fd``
+  File descriptor returned by a previous call to :c:func:`open() <dvb-ca-open>`.
 
+``buf``
+     Buffer with data to be written
 
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
+``count``
+    Number of bytes at the buffer
 
 Description
 -----------
@@ -65,7 +50,6 @@ Return Value
     :header-rows:  0
     :stub-columns: 0
 
-
     -  .. row 1
 
        -  ``EWOULDBLOCK``
diff --git a/Documentation/media/uapi/dvb/dmx-get-caps.rst b/Documentation/media/uapi/dvb/dmx-get-caps.rst
index 20e3d6e55d30..aaf084a245fd 100644
--- a/Documentation/media/uapi/dvb/dmx-get-caps.rst
+++ b/Documentation/media/uapi/dvb/dmx-get-caps.rst
@@ -15,40 +15,23 @@ DMX_GET_CAPS
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = DMX_GET_CAPS, dmx_caps_t *)
-
+.. c:function:: int ioctl(fd, DMX_GET_CAPS, dmx_caps_t *caps)
+    :name: DMX_GET_CAPS
 
 Arguments
 ---------
 
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
+``fd``
+    File descriptor returned by :c:func:`open() <dvb-dmx-open>`.
 
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
+``caps``
+    Undocumented.
 
 
 Description
 -----------
 
-This ioctl is undocumented. Documentation is welcome.
+.. note:: This ioctl is undocumented. Documentation is welcome.
 
 
 Return Value
diff --git a/Documentation/media/uapi/dvb/dmx-get-event.rst b/Documentation/media/uapi/dvb/dmx-get-event.rst
index 81a7c7fedd47..8be626c29158 100644
--- a/Documentation/media/uapi/dvb/dmx-get-event.rst
+++ b/Documentation/media/uapi/dvb/dmx-get-event.rst
@@ -15,34 +15,18 @@ DMX_GET_EVENT
 Synopsis
 --------
 
-.. c:function:: int ioctl( int fd, int request = DMX_GET_EVENT, struct dmx_event *ev)
+.. c:function:: int ioctl( int fd, DMX_GET_EVENT, struct dmx_event *ev)
+    :name: DMX_GET_EVENT
 
 
 Arguments
 ---------
 
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
+``fd``
+    File descriptor returned by :c:func:`open() <dvb-dmx-open>`.
 
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
+``ev``
+    Pointer to the location where the event is to be stored.
 
 
 Description
diff --git a/Documentation/media/uapi/dvb/dmx-get-pes-pids.rst b/Documentation/media/uapi/dvb/dmx-get-pes-pids.rst
index 8b1fbf5d2c81..b31634a1cca4 100644
--- a/Documentation/media/uapi/dvb/dmx-get-pes-pids.rst
+++ b/Documentation/media/uapi/dvb/dmx-get-pes-pids.rst
@@ -15,40 +15,23 @@ DMX_GET_PES_PIDS
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = DMX_GET_PES_PIDS, __u16[5])
-
+.. c:function:: int ioctl(fd, DMX_GET_PES_PIDS, __u16 pids[5])
+    :name: DMX_GET_PES_PIDS
 
 Arguments
 ---------
 
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
+``fd``
+    File descriptor returned by :c:func:`open() <dvb-dmx-open>`.
 
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
+``pids``
+    Undocumented.
 
 
 Description
 -----------
 
-This ioctl is undocumented. Documentation is welcome.
+.. note:: This ioctl is undocumented. Documentation is welcome.
 
 
 Return Value
diff --git a/Documentation/media/uapi/dvb/dmx-get-stc.rst b/Documentation/media/uapi/dvb/dmx-get-stc.rst
index 616c745a0418..9fc501e8128a 100644
--- a/Documentation/media/uapi/dvb/dmx-get-stc.rst
+++ b/Documentation/media/uapi/dvb/dmx-get-stc.rst
@@ -15,34 +15,17 @@ DMX_GET_STC
 Synopsis
 --------
 
-.. c:function:: int ioctl( int fd, int request = DMX_GET_STC, struct dmx_stc *stc)
-
+.. c:function:: int ioctl( int fd, DMX_GET_STC, struct dmx_stc *stc)
+    :name: DMX_GET_STC
 
 Arguments
 ---------
 
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
+``fd``
+    File descriptor returned by :c:func:`open() <dvb-dmx-open>`.
 
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
+``stc``
+    Pointer to the location where the stc is to be stored.
 
 
 Description
@@ -63,8 +46,6 @@ On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
 
-
-
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/dvb/dmx-remove-pid.rst b/Documentation/media/uapi/dvb/dmx-remove-pid.rst
index ed1a49ce9fc2..e411495c619c 100644
--- a/Documentation/media/uapi/dvb/dmx-remove-pid.rst
+++ b/Documentation/media/uapi/dvb/dmx-remove-pid.rst
@@ -15,34 +15,18 @@ DMX_REMOVE_PID
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = DMX_REMOVE_PID, __u16 *)
+.. c:function:: int ioctl(fd, DMX_REMOVE_PID, __u16 *pid)
+    :name: DMX_REMOVE_PID
 
 
 Arguments
 ---------
 
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
+``fd``
+    File descriptor returned by :c:func:`open() <dvb-dmx-open>`.
 
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
+``pid``
+    PID of the PES filter to be removed.
 
 
 Description
diff --git a/Documentation/media/uapi/dvb/dmx-set-buffer-size.rst b/Documentation/media/uapi/dvb/dmx-set-buffer-size.rst
index 012b9e9792be..f2f7379f29ed 100644
--- a/Documentation/media/uapi/dvb/dmx-set-buffer-size.rst
+++ b/Documentation/media/uapi/dvb/dmx-set-buffer-size.rst
@@ -15,35 +15,18 @@ DMX_SET_BUFFER_SIZE
 Synopsis
 --------
 
-.. c:function:: int ioctl( int fd, int request = DMX_SET_BUFFER_SIZE, unsigned long size)
+.. c:function:: int ioctl( int fd, DMX_SET_BUFFER_SIZE, unsigned long size)
+    :name: DMX_SET_BUFFER_SIZE
 
 
 Arguments
 ---------
 
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
+``fd``
+    File descriptor returned by :c:func:`open() <dvb-dmx-open>`.
 
+``size``
+    Unsigned long size
 
 Description
 -----------
diff --git a/Documentation/media/uapi/dvb/dmx-set-filter.rst b/Documentation/media/uapi/dvb/dmx-set-filter.rst
index d079d8b39597..1d50c803d69a 100644
--- a/Documentation/media/uapi/dvb/dmx-set-filter.rst
+++ b/Documentation/media/uapi/dvb/dmx-set-filter.rst
@@ -15,34 +15,18 @@ DMX_SET_FILTER
 Synopsis
 --------
 
-.. c:function:: int ioctl( int fd, int request = DMX_SET_FILTER, struct dmx_sct_filter_params *params)
-
+.. c:function:: int ioctl( int fd, DMX_SET_FILTER, struct dmx_sct_filter_params *params)
+    :name: DMX_SET_FILTER
 
 Arguments
 ---------
 
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
+``fd``
+    File descriptor returned by :c:func:`open() <dvb-dmx-open>`.
 
+``params``
 
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
+    Pointer to structure containing filter parameters.
 
 
 Description
diff --git a/Documentation/media/uapi/dvb/dmx-set-pes-filter.rst b/Documentation/media/uapi/dvb/dmx-set-pes-filter.rst
index 1f774624383f..145451d04f7d 100644
--- a/Documentation/media/uapi/dvb/dmx-set-pes-filter.rst
+++ b/Documentation/media/uapi/dvb/dmx-set-pes-filter.rst
@@ -15,34 +15,19 @@ DMX_SET_PES_FILTER
 Synopsis
 --------
 
-.. c:function:: int ioctl( int fd, int request = DMX_SET_PES_FILTER, struct dmx_pes_filter_params *params)
+.. c:function:: int ioctl( int fd, DMX_SET_PES_FILTER, struct dmx_pes_filter_params *params)
+    :name: DMX_SET_PES_FILTER
 
 
 Arguments
 ---------
 
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
 
+``fd``
+    File descriptor returned by :c:func:`open() <dvb-dmx-open>`.
 
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
+``params``
+    Pointer to structure containing filter parameters.
 
 
 Description
diff --git a/Documentation/media/uapi/dvb/dmx-set-source.rst b/Documentation/media/uapi/dvb/dmx-set-source.rst
index 7aa4dfe3cdc5..a232fd6e5f52 100644
--- a/Documentation/media/uapi/dvb/dmx-set-source.rst
+++ b/Documentation/media/uapi/dvb/dmx-set-source.rst
@@ -15,40 +15,25 @@ DMX_SET_SOURCE
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = DMX_SET_SOURCE, dmx_source_t *)
+.. c:function:: int ioctl(fd, DMX_SET_SOURCE, dmx_source_t *src)
+    :name: DMX_SET_SOURCE
 
 
 Arguments
 ---------
 
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
 
+``fd``
+    File descriptor returned by :c:func:`open() <dvb-dmx-open>`.
 
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
+``src``
+   Undocumented.
 
 
 Description
 -----------
 
-This ioctl is undocumented. Documentation is welcome.
+.. note:: This ioctl is undocumented. Documentation is welcome.
 
 
 Return Value
diff --git a/Documentation/media/uapi/dvb/dmx-start.rst b/Documentation/media/uapi/dvb/dmx-start.rst
index d494f6b03dbc..641f3e017fb1 100644
--- a/Documentation/media/uapi/dvb/dmx-start.rst
+++ b/Documentation/media/uapi/dvb/dmx-start.rst
@@ -15,29 +15,15 @@ DMX_START
 Synopsis
 --------
 
-.. c:function:: int ioctl( int fd, int request = DMX_START)
+.. c:function:: int ioctl( int fd, DMX_START)
+    :name: DMX_START
 
 
 Arguments
 ---------
 
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
+``fd``
+    File descriptor returned by :c:func:`open() <dvb-dmx-open>`.
 
 Description
 -----------
diff --git a/Documentation/media/uapi/dvb/dmx-stop.rst b/Documentation/media/uapi/dvb/dmx-stop.rst
index f9157dd6a8fe..569a3df44923 100644
--- a/Documentation/media/uapi/dvb/dmx-stop.rst
+++ b/Documentation/media/uapi/dvb/dmx-stop.rst
@@ -15,29 +15,15 @@ DMX_STOP
 Synopsis
 --------
 
-.. c:function:: int ioctl( int fd, int request = DMX_STOP)
+.. c:function:: int ioctl( int fd, DMX_STOP)
+    :name: DMX_STOP
 
 
 Arguments
 ---------
 
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
+``fd``
+    File descriptor returned by :c:func:`open() <dvb-dmx-open>`.
 
 Description
 -----------
diff --git a/Documentation/media/uapi/dvb/fe-diseqc-recv-slave-reply.rst b/Documentation/media/uapi/dvb/fe-diseqc-recv-slave-reply.rst
index 7bf1145b58a8..e1b6da08b3a1 100644
--- a/Documentation/media/uapi/dvb/fe-diseqc-recv-slave-reply.rst
+++ b/Documentation/media/uapi/dvb/fe-diseqc-recv-slave-reply.rst
@@ -15,7 +15,8 @@ FE_DISEQC_RECV_SLAVE_REPLY - Receives reply from a DiSEqC 2.0 command
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct dvb_diseqc_slave_reply *argp )
+.. c:function:: int ioctl( int fd, FE_DISEQC_RECV_SLAVE_REPLY, struct dvb_diseqc_slave_reply *argp )
+    :name: FE_DISEQC_RECV_SLAVE_REPLY
 
 
 Arguments
@@ -24,9 +25,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <frontend_f_open>`.
 
-``request``
-    FE_DISEQC_RECV_SLAVE_REPLY
-
 ``argp``
     pointer to struct
     :ref:`dvb_diseqc_slave_reply <dvb-diseqc-slave-reply>`
diff --git a/Documentation/media/uapi/dvb/fe-diseqc-reset-overload.rst b/Documentation/media/uapi/dvb/fe-diseqc-reset-overload.rst
index 13bac53bd248..75116f283faf 100644
--- a/Documentation/media/uapi/dvb/fe-diseqc-reset-overload.rst
+++ b/Documentation/media/uapi/dvb/fe-diseqc-reset-overload.rst
@@ -15,7 +15,8 @@ FE_DISEQC_RESET_OVERLOAD - Restores the power to the antenna subsystem, if it wa
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, NULL )
+.. c:function:: int ioctl( int fd, FE_DISEQC_RESET_OVERLOAD, NULL )
+    :name: FE_DISEQC_RESET_OVERLOAD
 
 
 Arguments
@@ -24,10 +25,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <frontend_f_open>`.
 
-``request``
-    FE_DISEQC_RESET_OVERLOAD
-
-
 Description
 ===========
 
diff --git a/Documentation/media/uapi/dvb/fe-diseqc-send-burst.rst b/Documentation/media/uapi/dvb/fe-diseqc-send-burst.rst
index d1e9f31ff347..0e55614bc987 100644
--- a/Documentation/media/uapi/dvb/fe-diseqc-send-burst.rst
+++ b/Documentation/media/uapi/dvb/fe-diseqc-send-burst.rst
@@ -15,7 +15,8 @@ FE_DISEQC_SEND_BURST - Sends a 22KHz tone burst for 2x1 mini DiSEqC satellite se
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, enum fe_sec_mini_cmd *tone )
+.. c:function:: int ioctl( int fd, FE_DISEQC_SEND_BURST, enum fe_sec_mini_cmd *tone )
+    :name: FE_DISEQC_SEND_BURST
 
 
 Arguments
@@ -24,9 +25,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <frontend_f_open>`.
 
-``request``
-    FE_DISEQC_SEND_BURST
-
 ``tone``
     pointer to enum :ref:`fe_sec_mini_cmd <fe-sec-mini-cmd>`
 
diff --git a/Documentation/media/uapi/dvb/fe-diseqc-send-master-cmd.rst b/Documentation/media/uapi/dvb/fe-diseqc-send-master-cmd.rst
index 3b27d9cc544d..ea090cbeaae0 100644
--- a/Documentation/media/uapi/dvb/fe-diseqc-send-master-cmd.rst
+++ b/Documentation/media/uapi/dvb/fe-diseqc-send-master-cmd.rst
@@ -15,7 +15,8 @@ FE_DISEQC_SEND_MASTER_CMD - Sends a DiSEqC command
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct dvb_diseqc_master_cmd *argp )
+.. c:function:: int ioctl( int fd, FE_DISEQC_SEND_MASTER_CMD, struct dvb_diseqc_master_cmd *argp )
+    :name: FE_DISEQC_SEND_MASTER_CMD
 
 
 Arguments
@@ -24,9 +25,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <frontend_f_open>`.
 
-``request``
-    FE_DISEQC_SEND_MASTER_CMD
-
 ``argp``
     pointer to struct
     :ref:`dvb_diseqc_master_cmd <dvb-diseqc-master-cmd>`
diff --git a/Documentation/media/uapi/dvb/fe-dishnetwork-send-legacy-cmd.rst b/Documentation/media/uapi/dvb/fe-dishnetwork-send-legacy-cmd.rst
index 5ebab0ef9138..f41371f12456 100644
--- a/Documentation/media/uapi/dvb/fe-dishnetwork-send-legacy-cmd.rst
+++ b/Documentation/media/uapi/dvb/fe-dishnetwork-send-legacy-cmd.rst
@@ -15,22 +15,18 @@ FE_DISHNETWORK_SEND_LEGACY_CMD
 Synopsis
 ========
 
-.. c:function:: int  ioctl(int fd, int request = FE_DISHNETWORK_SEND_LEGACY_CMD, unsigned long cmd)
+.. c:function:: int  ioctl(int fd, FE_DISHNETWORK_SEND_LEGACY_CMD, unsigned long cmd)
+    :name: FE_DISHNETWORK_SEND_LEGACY_CMD
 
 
 Arguments
 =========
 
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
+``fd``
+    File descriptor returned by :c:func:`open() <dvb-fe-open>`.
 
-
-    -  .. row 1
-
-       -  unsigned long cmd
-
-       -  sends the specified raw cmd to the dish via DISEqC.
+``cmd``
+    Sends the specified raw cmd to the dish via DISEqC.
 
 
 Description
diff --git a/Documentation/media/uapi/dvb/fe-enable-high-lnb-voltage.rst b/Documentation/media/uapi/dvb/fe-enable-high-lnb-voltage.rst
index a485bf259ed2..bacafbc462d2 100644
--- a/Documentation/media/uapi/dvb/fe-enable-high-lnb-voltage.rst
+++ b/Documentation/media/uapi/dvb/fe-enable-high-lnb-voltage.rst
@@ -15,7 +15,8 @@ FE_ENABLE_HIGH_LNB_VOLTAGE - Select output DC level between normal LNBf voltages
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, unsigned int high )
+.. c:function:: int ioctl( int fd, FE_ENABLE_HIGH_LNB_VOLTAGE, unsigned int high )
+    :name: FE_ENABLE_HIGH_LNB_VOLTAGE
 
 
 Arguments
@@ -24,9 +25,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <frontend_f_open>`.
 
-``request``
-    FE_ENABLE_HIGH_LNB_VOLTAGE
-
 ``high``
     Valid flags:
 
diff --git a/Documentation/media/uapi/dvb/fe-get-event.rst b/Documentation/media/uapi/dvb/fe-get-event.rst
index 79beb1b9da3b..8a719c33073d 100644
--- a/Documentation/media/uapi/dvb/fe-get-event.rst
+++ b/Documentation/media/uapi/dvb/fe-get-event.rst
@@ -11,43 +11,24 @@ Name
 
 FE_GET_EVENT
 
+.. attention:: This ioctl is deprecated.
+
 
 Synopsis
 ========
 
-.. c:function:: int  ioctl(int fd, int request = QPSK_GET_EVENT, struct dvb_frontend_event *ev)
+.. c:function:: int  ioctl(int fd, FE_GET_EVENT, struct dvb_frontend_event *ev)
+    :name: FE_GET_EVENT
 
 
 Arguments
 =========
 
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
+``fd``
+    File descriptor returned by :c:func:`open() <dvb-fe-open>`.
 
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
-       -  Equals :ref:`FE_GET_EVENT` for this command.
-
-    -  .. row 3
-
-       -  struct dvb_frontend_event \*ev
-
-       -  Points to the location where the event,
-
-    -  .. row 4
-
-       -
-       -  if any, is to be stored.
+``ev``
+    Points to the location where the event, if any, is to be stored.
 
 
 Description
diff --git a/Documentation/media/uapi/dvb/fe-get-frontend.rst b/Documentation/media/uapi/dvb/fe-get-frontend.rst
index fdf0d1440add..d53a3f8237c3 100644
--- a/Documentation/media/uapi/dvb/fe-get-frontend.rst
+++ b/Documentation/media/uapi/dvb/fe-get-frontend.rst
@@ -11,39 +11,25 @@ Name
 
 FE_GET_FRONTEND
 
+.. attention:: This ioctl is deprecated.
+
 
 Synopsis
 ========
 
-.. c:function:: int ioctl(int fd, int request = FE_GET_FRONTEND, struct dvb_frontend_parameters *p)
+.. c:function:: int ioctl(int fd, FE_GET_FRONTEND, struct dvb_frontend_parameters *p)
+    :name: FE_GET_FRONTEND
 
 
 Arguments
 =========
 
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
+``fd``
+    File descriptor returned by :c:func:`open() <dvb-fe-open>`.
 
 
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
-       -  Equals :ref:`FE_SET_FRONTEND` for this
-	  command.
-
-    -  .. row 3
-
-       -  struct dvb_frontend_parameters \*p
-
-       -  Points to parameters for tuning operation.
+``p``
+    Points to parameters for tuning operation.
 
 
 Description
diff --git a/Documentation/media/uapi/dvb/fe-get-info.rst b/Documentation/media/uapi/dvb/fe-get-info.rst
index 8768179cb812..c367b5ab023c 100644
--- a/Documentation/media/uapi/dvb/fe-get-info.rst
+++ b/Documentation/media/uapi/dvb/fe-get-info.rst
@@ -15,7 +15,8 @@ FE_GET_INFO - Query DVB frontend capabilities and returns information about the
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct dvb_frontend_info *argp )
+.. c:function:: int ioctl( int fd, FE_GET_INFO, struct dvb_frontend_info *argp )
+    :name: FE_GET_INFO
 
 
 Arguments
@@ -24,9 +25,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <frontend_f_open>`.
 
-``request``
-    FE_GET_INFO
-
 ``argp``
     pointer to struct struct
     :ref:`dvb_frontend_info <dvb-frontend-info>`
diff --git a/Documentation/media/uapi/dvb/fe-get-property.rst b/Documentation/media/uapi/dvb/fe-get-property.rst
index 12042c7ae693..51daf016a8eb 100644
--- a/Documentation/media/uapi/dvb/fe-get-property.rst
+++ b/Documentation/media/uapi/dvb/fe-get-property.rst
@@ -15,7 +15,11 @@ FE_SET_PROPERTY - FE_GET_PROPERTY - FE_SET_PROPERTY sets one or more frontend pr
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct dtv_properties *argp )
+.. c:function:: int ioctl( int fd, FE_GET_PROPERTY, struct dtv_properties *argp )
+    :name: FE_GET_PROPERTY
+
+.. c:function:: int ioctl( int fd, FE_SET_PROPERTY, struct dtv_properties *argp )
+    :name: FE_SET_PROPERTY
 
 
 Arguments
@@ -24,9 +28,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <frontend_f_open>`.
 
-``request``
-    FE_SET_PROPERTY, FE_GET_PROPERTY
-
 ``argp``
     pointer to struct :ref:`dtv_properties <dtv-properties>`
 
diff --git a/Documentation/media/uapi/dvb/fe-read-ber.rst b/Documentation/media/uapi/dvb/fe-read-ber.rst
index 3262441385ff..e54972ad5250 100644
--- a/Documentation/media/uapi/dvb/fe-read-ber.rst
+++ b/Documentation/media/uapi/dvb/fe-read-ber.rst
@@ -11,37 +11,23 @@ Name
 
 FE_READ_BER
 
+.. attention:: This ioctl is deprecated.
+
 Synopsis
 ========
 
-.. c:function:: int  ioctl(int fd, int request = FE_READ_BER, uint32_t *ber)
+.. c:function:: int  ioctl(int fd, FE_READ_BER, uint32_t *ber)
+    :name: FE_READ_BER
 
 
 Arguments
 =========
 
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
+``fd``
+    File descriptor returned by :c:func:`open() <dvb-fe-open>`.
 
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
-       -  Equals :ref:`FE_READ_BER` for this command.
-
-    -  .. row 3
-
-       -  uint32_t \*ber
-
-       -  The bit error rate is stored into \*ber.
+``ber``
+    The bit error rate is stored into \*ber.
 
 
 Description
diff --git a/Documentation/media/uapi/dvb/fe-read-signal-strength.rst b/Documentation/media/uapi/dvb/fe-read-signal-strength.rst
index fcaadcb537fb..4b13c4757744 100644
--- a/Documentation/media/uapi/dvb/fe-read-signal-strength.rst
+++ b/Documentation/media/uapi/dvb/fe-read-signal-strength.rst
@@ -11,40 +11,23 @@ Name
 
 FE_READ_SIGNAL_STRENGTH
 
+.. attention:: This ioctl is deprecated.
 
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request = FE_READ_SIGNAL_STRENGTH, uint16_t *strength)
+.. c:function:: int ioctl( int fd, FE_READ_SIGNAL_STRENGTH, uint16_t *strength)
+    :name: FE_READ_SIGNAL_STRENGTH
 
 
 Arguments
 =========
 
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
+``fd``
+    File descriptor returned by :c:func:`open() <dvb-fe-open>`.
 
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
-       -  Equals
-	  :ref:`FE_READ_SIGNAL_STRENGTH`
-	  for this command.
-
-    -  .. row 3
-
-       -  uint16_t \*strength
-
-       -  The signal strength value is stored into \*strength.
+``strength``
+    The signal strength value is stored into \*strength.
 
 
 Description
diff --git a/Documentation/media/uapi/dvb/fe-read-snr.rst b/Documentation/media/uapi/dvb/fe-read-snr.rst
index 837af2de9f6f..2aed487f5c99 100644
--- a/Documentation/media/uapi/dvb/fe-read-snr.rst
+++ b/Documentation/media/uapi/dvb/fe-read-snr.rst
@@ -11,38 +11,23 @@ Name
 
 FE_READ_SNR
 
+.. attention:: This ioctl is deprecated.
 
 Synopsis
 ========
 
-.. c:function:: int  ioctl(int fd, int request = FE_READ_SNR, int16_t *snr)
+.. c:function:: int  ioctl(int fd, FE_READ_SNR, int16_t *snr)
+    :name: FE_READ_SNR
 
 
 Arguments
 =========
 
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
+``fd``
+    File descriptor returned by :c:func:`open() <dvb-fe-open>`.
 
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
-       -  Equals :ref:`FE_READ_SNR` for this command.
-
-    -  .. row 3
-
-       -  uint16_t \*snr
-
-       -  The signal-to-noise ratio is stored into \*snr.
+``snr``
+    The signal-to-noise ratio is stored into \*snr.
 
 
 Description
diff --git a/Documentation/media/uapi/dvb/fe-read-status.rst b/Documentation/media/uapi/dvb/fe-read-status.rst
index b00bdc8a2e04..c65cec3a35c9 100644
--- a/Documentation/media/uapi/dvb/fe-read-status.rst
+++ b/Documentation/media/uapi/dvb/fe-read-status.rst
@@ -15,7 +15,8 @@ FE_READ_STATUS - Returns status information about the front-end. This call only
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, unsigned int *status )
+.. c:function:: int ioctl( int fd, FE_READ_STATUS, unsigned int *status )
+    :name: FE_READ_STATUS
 
 
 Arguments
@@ -24,9 +25,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <frontend_f_open>`.
 
-``request``
-    FE_READ_STATUS
-
 ``status``
     pointer to a bitmask integer filled with the values defined by enum
     :ref:`fe_status <fe-status>`.
diff --git a/Documentation/media/uapi/dvb/fe-read-uncorrected-blocks.rst b/Documentation/media/uapi/dvb/fe-read-uncorrected-blocks.rst
index 6b753846a008..46687c123402 100644
--- a/Documentation/media/uapi/dvb/fe-read-uncorrected-blocks.rst
+++ b/Documentation/media/uapi/dvb/fe-read-uncorrected-blocks.rst
@@ -11,40 +11,23 @@ Name
 
 FE_READ_UNCORRECTED_BLOCKS
 
+.. attention:: This ioctl is deprecated.
 
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request =FE_READ_UNCORRECTED_BLOCKS, uint32_t *ublocks)
+.. c:function:: int ioctl( int fd, FE_READ_UNCORRECTED_BLOCKS, uint32_t *ublocks)
+    :name: FE_READ_UNCORRECTED_BLOCKS
 
 
 Arguments
 =========
 
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
+``fd``
+    File descriptor returned by :c:func:`open() <dvb-fe-open>`.
 
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
-       -  Equals
-	  :ref:`FE_READ_UNCORRECTED_BLOCKS`
-	  for this command.
-
-    -  .. row 3
-
-       -  uint32_t \*ublocks
-
-       -  The total number of uncorrected blocks seen by the driver so far.
+``ublocks``
+    The total number of uncorrected blocks seen by the driver so far.
 
 
 Description
diff --git a/Documentation/media/uapi/dvb/fe-set-frontend-tune-mode.rst b/Documentation/media/uapi/dvb/fe-set-frontend-tune-mode.rst
index 4461aeb46ebb..1d5878da2f41 100644
--- a/Documentation/media/uapi/dvb/fe-set-frontend-tune-mode.rst
+++ b/Documentation/media/uapi/dvb/fe-set-frontend-tune-mode.rst
@@ -15,7 +15,8 @@ FE_SET_FRONTEND_TUNE_MODE - Allow setting tuner mode flags to the frontend.
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, unsigned int flags )
+.. c:function:: int ioctl( int fd, FE_SET_FRONTEND_TUNE_MODE, unsigned int flags )
+    :name: FE_SET_FRONTEND_TUNE_MODE
 
 
 Arguments
@@ -24,9 +25,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <frontend_f_open>`.
 
-``request``
-    FE_SET_FRONTEND_TUNE_MODE
-
 ``flags``
     Valid flags:
 
diff --git a/Documentation/media/uapi/dvb/fe-set-frontend.rst b/Documentation/media/uapi/dvb/fe-set-frontend.rst
index 4e66da0af6fd..7f97dce9aee6 100644
--- a/Documentation/media/uapi/dvb/fe-set-frontend.rst
+++ b/Documentation/media/uapi/dvb/fe-set-frontend.rst
@@ -6,6 +6,8 @@
 FE_SET_FRONTEND
 ***************
 
+.. attention:: This ioctl is deprecated.
+
 Name
 ====
 
@@ -15,35 +17,18 @@ FE_SET_FRONTEND
 Synopsis
 ========
 
-.. c:function:: int ioctl(int fd, int request = FE_SET_FRONTEND, struct dvb_frontend_parameters *p)
+.. c:function:: int ioctl(int fd, FE_SET_FRONTEND, struct dvb_frontend_parameters *p)
+    :name: FE_SET_FRONTEND
 
 
 Arguments
 =========
 
-.. flat-table::
-    :header-rows:  0
-    :stub-columns: 0
+``fd``
+    File descriptor returned by :c:func:`open() <dvb-fe-open>`.
 
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
-       -  Equals :ref:`FE_SET_FRONTEND` for this
-	  command.
-
-    -  .. row 3
-
-       -  struct dvb_frontend_parameters \*p
-
-       -  Points to parameters for tuning operation.
+``p``
+    Points to parameters for tuning operation.
 
 
 Description
diff --git a/Documentation/media/uapi/dvb/fe-set-tone.rst b/Documentation/media/uapi/dvb/fe-set-tone.rst
index a00fcaadecd1..4cfd532d3dc5 100644
--- a/Documentation/media/uapi/dvb/fe-set-tone.rst
+++ b/Documentation/media/uapi/dvb/fe-set-tone.rst
@@ -15,7 +15,8 @@ FE_SET_TONE - Sets/resets the generation of the continuous 22kHz tone.
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, enum fe_sec_tone_mode *tone )
+.. c:function:: int ioctl( int fd, FE_SET_TONE, enum fe_sec_tone_mode *tone )
+    :name: FE_SET_TONE
 
 
 Arguments
@@ -24,9 +25,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <frontend_f_open>`.
 
-``request``
-    FE_SET_TONE
-
 ``tone``
     pointer to enum :ref:`fe_sec_tone_mode <fe-sec-tone-mode>`
 
diff --git a/Documentation/media/uapi/dvb/fe-set-voltage.rst b/Documentation/media/uapi/dvb/fe-set-voltage.rst
index 05baf77e0301..b8b23c51ec7d 100644
--- a/Documentation/media/uapi/dvb/fe-set-voltage.rst
+++ b/Documentation/media/uapi/dvb/fe-set-voltage.rst
@@ -15,7 +15,8 @@ FE_SET_VOLTAGE - Allow setting the DC level sent to the antenna subsystem.
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, enum fe_sec_voltage *voltage )
+.. c:function:: int ioctl( int fd, FE_SET_VOLTAGE, enum fe_sec_voltage *voltage )
+    :name: FE_SET_VOLTAGE
 
 
 Arguments
@@ -24,9 +25,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <frontend_f_open>`.
 
-``request``
-    FE_SET_VOLTAGE
-
 ``voltage``
     pointer to enum :ref:`fe_sec_voltage <fe-sec-voltage>`
 
diff --git a/Documentation/media/uapi/dvb/frontend_f_close.rst b/Documentation/media/uapi/dvb/frontend_f_close.rst
index 8746eec2b97d..f3b04b60246c 100644
--- a/Documentation/media/uapi/dvb/frontend_f_close.rst
+++ b/Documentation/media/uapi/dvb/frontend_f_close.rst
@@ -21,13 +21,13 @@ Synopsis
 
 
 .. c:function:: int close( int fd )
-
+    :name: dvb-fe-close
 
 Arguments
 =========
 
 ``fd``
-    File descriptor returned by :ref:`open() <func-open>`.
+    File descriptor returned by :c:func:`open() <dvb-fe-open>`.
 
 
 Description
diff --git a/Documentation/media/uapi/dvb/frontend_f_open.rst b/Documentation/media/uapi/dvb/frontend_f_open.rst
index 5810e96abf89..690eb375bdc1 100644
--- a/Documentation/media/uapi/dvb/frontend_f_open.rst
+++ b/Documentation/media/uapi/dvb/frontend_f_open.rst
@@ -21,7 +21,7 @@ Synopsis
 
 
 .. c:function:: int open( const char *device_name, int flags )
-
+    :name: dvb-fe-open
 
 Arguments
 =========
diff --git a/Documentation/media/uapi/dvb/net-add-if.rst b/Documentation/media/uapi/dvb/net-add-if.rst
index ebde02b9a3ec..dfb4509f816c 100644
--- a/Documentation/media/uapi/dvb/net-add-if.rst
+++ b/Documentation/media/uapi/dvb/net-add-if.rst
@@ -15,7 +15,8 @@ NET_ADD_IF - Creates a new network interface for a given Packet ID.
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct dvb_net_if *net_if )
+.. c:function:: int ioctl( int fd, NET_ADD_IF, struct dvb_net_if *net_if )
+    :name: NET_ADD_IF
 
 
 Arguments
@@ -24,9 +25,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <frontend_f_open>`.
 
-``request``
-    FE_SET_TONE
-
 ``net_if``
     pointer to struct :ref:`dvb_net_if <dvb-net-if>`
 
diff --git a/Documentation/media/uapi/dvb/net-get-if.rst b/Documentation/media/uapi/dvb/net-get-if.rst
index 17cfcda22da3..dd9d6a3c4a2b 100644
--- a/Documentation/media/uapi/dvb/net-get-if.rst
+++ b/Documentation/media/uapi/dvb/net-get-if.rst
@@ -15,7 +15,8 @@ NET_GET_IF - Read the configuration data of an interface created via - :ref:`NET
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, struct dvb_net_if *net_if )
+.. c:function:: int ioctl( int fd, NET_GET_IF, struct dvb_net_if *net_if )
+    :name: NET_GET_IF
 
 
 Arguments
@@ -24,9 +25,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <frontend_f_open>`.
 
-``request``
-    FE_SET_TONE
-
 ``net_if``
     pointer to struct :ref:`dvb_net_if <dvb-net-if>`
 
diff --git a/Documentation/media/uapi/dvb/net-remove-if.rst b/Documentation/media/uapi/dvb/net-remove-if.rst
index 447dd4299965..646af23a925a 100644
--- a/Documentation/media/uapi/dvb/net-remove-if.rst
+++ b/Documentation/media/uapi/dvb/net-remove-if.rst
@@ -15,7 +15,8 @@ NET_REMOVE_IF - Removes a network interface.
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, int ifnum )
+.. c:function:: int ioctl( int fd, NET_REMOVE_IF, int ifnum )
+    :name: NET_REMOVE_IF
 
 
 Arguments
@@ -24,9 +25,6 @@ Arguments
 ``fd``
     File descriptor returned by :ref:`open() <frontend_f_open>`.
 
-``request``
-    FE_SET_TONE
-
 ``net_if``
     number of the interface to be removed
 
diff --git a/Documentation/media/uapi/dvb/video-clear-buffer.rst b/Documentation/media/uapi/dvb/video-clear-buffer.rst
index dd227ad85546..2e51a78a69f1 100644
--- a/Documentation/media/uapi/dvb/video-clear-buffer.rst
+++ b/Documentation/media/uapi/dvb/video-clear-buffer.rst
@@ -11,11 +11,13 @@ Name
 
 VIDEO_CLEAR_BUFFER
 
+.. attention:: This ioctl is deprecated.
 
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = VIDEO_CLEAR_BUFFER)
+.. c:function:: int ioctl(fd, VIDEO_CLEAR_BUFFER)
+    :name: VIDEO_CLEAR_BUFFER
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-command.rst b/Documentation/media/uapi/dvb/video-command.rst
index 42a98a47e323..4772562036f1 100644
--- a/Documentation/media/uapi/dvb/video-command.rst
+++ b/Documentation/media/uapi/dvb/video-command.rst
@@ -11,11 +11,13 @@ Name
 
 VIDEO_COMMAND
 
+.. attention:: This ioctl is deprecated.
 
 Synopsis
 --------
 
-.. c:function:: int ioctl(int fd, int request = VIDEO_COMMAND, struct video_command *cmd)
+.. c:function:: int ioctl(int fd, VIDEO_COMMAND, struct video_command *cmd)
+    :name: VIDEO_COMMAND
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-continue.rst b/Documentation/media/uapi/dvb/video-continue.rst
index 2a6444a4f4dc..030c2ec98869 100644
--- a/Documentation/media/uapi/dvb/video-continue.rst
+++ b/Documentation/media/uapi/dvb/video-continue.rst
@@ -11,11 +11,13 @@ Name
 
 VIDEO_CONTINUE
 
+.. attention:: This ioctl is deprecated.
 
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = VIDEO_CONTINUE)
+.. c:function:: int ioctl(fd, VIDEO_CONTINUE)
+    :name: VIDEO_CONTINUE
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-fast-forward.rst b/Documentation/media/uapi/dvb/video-fast-forward.rst
index 0b3a27a22d30..70a53e110335 100644
--- a/Documentation/media/uapi/dvb/video-fast-forward.rst
+++ b/Documentation/media/uapi/dvb/video-fast-forward.rst
@@ -11,11 +11,13 @@ Name
 
 VIDEO_FAST_FORWARD
 
+.. attention:: This ioctl is deprecated.
 
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = VIDEO_FAST_FORWARD, int nFrames)
+.. c:function:: int ioctl(fd, VIDEO_FAST_FORWARD, int nFrames)
+    :name: VIDEO_FAST_FORWARD
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-fclose.rst b/Documentation/media/uapi/dvb/video-fclose.rst
index b4dd5ea676b9..8a997ae6f6a7 100644
--- a/Documentation/media/uapi/dvb/video-fclose.rst
+++ b/Documentation/media/uapi/dvb/video-fclose.rst
@@ -11,6 +11,7 @@ Name
 
 dvb video close()
 
+.. attention:: This ioctl is deprecated.
 
 Synopsis
 --------
diff --git a/Documentation/media/uapi/dvb/video-fopen.rst b/Documentation/media/uapi/dvb/video-fopen.rst
index 5b73ca9f7bed..203a2c56f10a 100644
--- a/Documentation/media/uapi/dvb/video-fopen.rst
+++ b/Documentation/media/uapi/dvb/video-fopen.rst
@@ -11,6 +11,7 @@ Name
 
 dvb video open()
 
+.. attention:: This ioctl is deprecated.
 
 Synopsis
 --------
diff --git a/Documentation/media/uapi/dvb/video-freeze.rst b/Documentation/media/uapi/dvb/video-freeze.rst
index 12e04df990b7..9cef65a02e8d 100644
--- a/Documentation/media/uapi/dvb/video-freeze.rst
+++ b/Documentation/media/uapi/dvb/video-freeze.rst
@@ -11,11 +11,13 @@ Name
 
 VIDEO_FREEZE
 
+.. attention:: This ioctl is deprecated.
 
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = VIDEO_FREEZE)
+.. c:function:: int ioctl(fd, VIDEO_FREEZE)
+    :name: VIDEO_FREEZE
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-fwrite.rst b/Documentation/media/uapi/dvb/video-fwrite.rst
index da03db4be8de..cfe7c57dcfc7 100644
--- a/Documentation/media/uapi/dvb/video-fwrite.rst
+++ b/Documentation/media/uapi/dvb/video-fwrite.rst
@@ -11,6 +11,7 @@ Name
 
 dvb video write()
 
+.. attention:: This ioctl is deprecated.
 
 Synopsis
 --------
diff --git a/Documentation/media/uapi/dvb/video-get-capabilities.rst b/Documentation/media/uapi/dvb/video-get-capabilities.rst
index 5515dd40a1c1..6987f659a1ad 100644
--- a/Documentation/media/uapi/dvb/video-get-capabilities.rst
+++ b/Documentation/media/uapi/dvb/video-get-capabilities.rst
@@ -11,11 +11,13 @@ Name
 
 VIDEO_GET_CAPABILITIES
 
+.. attention:: This ioctl is deprecated.
 
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = VIDEO_GET_CAPABILITIES, unsigned int *cap)
+.. c:function:: int ioctl(fd, VIDEO_GET_CAPABILITIES, unsigned int *cap)
+    :name: VIDEO_GET_CAPABILITIES
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-get-event.rst b/Documentation/media/uapi/dvb/video-get-event.rst
index d43459915179..8c0c622c380b 100644
--- a/Documentation/media/uapi/dvb/video-get-event.rst
+++ b/Documentation/media/uapi/dvb/video-get-event.rst
@@ -11,11 +11,13 @@ Name
 
 VIDEO_GET_EVENT
 
+.. attention:: This ioctl is deprecated.
 
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = VIDEO_GET_EVENT, struct video_event *ev)
+.. c:function:: int ioctl(fd, VIDEO_GET_EVENT, struct video_event *ev)
+    :name: VIDEO_GET_EVENT
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-get-frame-count.rst b/Documentation/media/uapi/dvb/video-get-frame-count.rst
index a55f7a1d52ac..0ffe22cd6108 100644
--- a/Documentation/media/uapi/dvb/video-get-frame-count.rst
+++ b/Documentation/media/uapi/dvb/video-get-frame-count.rst
@@ -11,11 +11,13 @@ Name
 
 VIDEO_GET_FRAME_COUNT
 
+.. attention:: This ioctl is deprecated.
 
 Synopsis
 --------
 
-.. c:function:: int ioctl(int fd, int request = VIDEO_GET_FRAME_COUNT, __u64 *pts)
+.. c:function:: int ioctl(int fd, VIDEO_GET_FRAME_COUNT, __u64 *pts)
+    :name: VIDEO_GET_FRAME_COUNT
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-get-frame-rate.rst b/Documentation/media/uapi/dvb/video-get-frame-rate.rst
index a137b6589599..400042a854cf 100644
--- a/Documentation/media/uapi/dvb/video-get-frame-rate.rst
+++ b/Documentation/media/uapi/dvb/video-get-frame-rate.rst
@@ -11,11 +11,13 @@ Name
 
 VIDEO_GET_FRAME_RATE
 
+.. attention:: This ioctl is deprecated.
 
 Synopsis
 --------
 
-.. c:function:: int ioctl(int fd, int request = VIDEO_GET_FRAME_RATE, unsigned int *rate)
+.. c:function:: int ioctl(int fd, VIDEO_GET_FRAME_RATE, unsigned int *rate)
+    :name: VIDEO_GET_FRAME_RATE
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-get-navi.rst b/Documentation/media/uapi/dvb/video-get-navi.rst
index ccb2552722f0..b8de9ccf38c2 100644
--- a/Documentation/media/uapi/dvb/video-get-navi.rst
+++ b/Documentation/media/uapi/dvb/video-get-navi.rst
@@ -11,11 +11,13 @@ Name
 
 VIDEO_GET_NAVI
 
+.. attention:: This ioctl is deprecated.
 
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = VIDEO_GET_NAVI , video_navi_pack_t *navipack)
+.. c:function:: int ioctl(fd, VIDEO_GET_NAVI , video_navi_pack_t *navipack)
+    :name: VIDEO_GET_NAVI
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-get-pts.rst b/Documentation/media/uapi/dvb/video-get-pts.rst
index c1ad9576963d..c73f86f1d35b 100644
--- a/Documentation/media/uapi/dvb/video-get-pts.rst
+++ b/Documentation/media/uapi/dvb/video-get-pts.rst
@@ -11,11 +11,13 @@ Name
 
 VIDEO_GET_PTS
 
+.. attention:: This ioctl is deprecated.
 
 Synopsis
 --------
 
-.. c:function:: int ioctl(int fd, int request = VIDEO_GET_PTS, __u64 *pts)
+.. c:function:: int ioctl(int fd, VIDEO_GET_PTS, __u64 *pts)
+    :name: VIDEO_GET_PTS
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-get-size.rst b/Documentation/media/uapi/dvb/video-get-size.rst
index 70fb266e3ed8..ce8b4c6b41a5 100644
--- a/Documentation/media/uapi/dvb/video-get-size.rst
+++ b/Documentation/media/uapi/dvb/video-get-size.rst
@@ -11,11 +11,13 @@ Name
 
 VIDEO_GET_SIZE
 
+.. attention:: This ioctl is deprecated.
 
 Synopsis
 --------
 
-.. c:function:: int ioctl(int fd, int request = VIDEO_GET_SIZE, video_size_t *size)
+.. c:function:: int ioctl(int fd, VIDEO_GET_SIZE, video_size_t *size)
+    :name: VIDEO_GET_SIZE
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-get-status.rst b/Documentation/media/uapi/dvb/video-get-status.rst
index 5fd5b37942ec..7b6a278b5246 100644
--- a/Documentation/media/uapi/dvb/video-get-status.rst
+++ b/Documentation/media/uapi/dvb/video-get-status.rst
@@ -11,11 +11,13 @@ Name
 
 VIDEO_GET_STATUS
 
+.. attention:: This ioctl is deprecated.
 
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = VIDEO_GET_STATUS, struct video_status *status)
+.. c:function:: int ioctl(fd, VIDEO_GET_STATUS, struct video_status *status)
+    :name: VIDEO_GET_STATUS
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-play.rst b/Documentation/media/uapi/dvb/video-play.rst
index 103d0ad3341a..3f66ae3b7e35 100644
--- a/Documentation/media/uapi/dvb/video-play.rst
+++ b/Documentation/media/uapi/dvb/video-play.rst
@@ -11,11 +11,13 @@ Name
 
 VIDEO_PLAY
 
+.. attention:: This ioctl is deprecated.
 
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = VIDEO_PLAY)
+.. c:function:: int ioctl(fd, VIDEO_PLAY)
+    :name: VIDEO_PLAY
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-select-source.rst b/Documentation/media/uapi/dvb/video-select-source.rst
index f03c544668f5..eaa1088f07da 100644
--- a/Documentation/media/uapi/dvb/video-select-source.rst
+++ b/Documentation/media/uapi/dvb/video-select-source.rst
@@ -11,11 +11,13 @@ Name
 
 VIDEO_SELECT_SOURCE
 
+.. attention:: This ioctl is deprecated.
 
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = VIDEO_SELECT_SOURCE, video_stream_source_t source)
+.. c:function:: int ioctl(fd, VIDEO_SELECT_SOURCE, video_stream_source_t source)
+    :name: VIDEO_SELECT_SOURCE
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-set-attributes.rst b/Documentation/media/uapi/dvb/video-set-attributes.rst
index 9de0d9c7c9ca..8901520d7e43 100644
--- a/Documentation/media/uapi/dvb/video-set-attributes.rst
+++ b/Documentation/media/uapi/dvb/video-set-attributes.rst
@@ -11,11 +11,13 @@ Name
 
 VIDEO_SET_ATTRIBUTES
 
+.. attention:: This ioctl is deprecated.
 
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = VIDEO_SET_ATTRIBUTE ,video_attributes_t vattr)
+.. c:function:: int ioctl(fd, VIDEO_SET_ATTRIBUTE ,video_attributes_t vattr)
+    :name: VIDEO_SET_ATTRIBUTE
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-set-blank.rst b/Documentation/media/uapi/dvb/video-set-blank.rst
index d8b94c9b56b9..3858c69496a5 100644
--- a/Documentation/media/uapi/dvb/video-set-blank.rst
+++ b/Documentation/media/uapi/dvb/video-set-blank.rst
@@ -11,11 +11,13 @@ Name
 
 VIDEO_SET_BLANK
 
+.. attention:: This ioctl is deprecated.
 
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = VIDEO_SET_BLANK, boolean mode)
+.. c:function:: int ioctl(fd, VIDEO_SET_BLANK, boolean mode)
+    :name: VIDEO_SET_BLANK
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-set-display-format.rst b/Documentation/media/uapi/dvb/video-set-display-format.rst
index c1fb7c75b4a8..6abf19479939 100644
--- a/Documentation/media/uapi/dvb/video-set-display-format.rst
+++ b/Documentation/media/uapi/dvb/video-set-display-format.rst
@@ -11,11 +11,13 @@ Name
 
 VIDEO_SET_DISPLAY_FORMAT
 
+.. attention:: This ioctl is deprecated.
 
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = VIDEO_SET_DISPLAY_FORMAT, video_display_format_t format)
+.. c:function:: int ioctl(fd, VIDEO_SET_DISPLAY_FORMAT, video_display_format_t format)
+    :name: VIDEO_SET_DISPLAY_FORMAT
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-set-format.rst b/Documentation/media/uapi/dvb/video-set-format.rst
index 257a3c2a4627..117618525538 100644
--- a/Documentation/media/uapi/dvb/video-set-format.rst
+++ b/Documentation/media/uapi/dvb/video-set-format.rst
@@ -11,11 +11,13 @@ Name
 
 VIDEO_SET_FORMAT
 
+.. attention:: This ioctl is deprecated.
 
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = VIDEO_SET_FORMAT, video_format_t format)
+.. c:function:: int ioctl(fd, VIDEO_SET_FORMAT, video_format_t format)
+    :name: VIDEO_SET_FORMAT
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-set-highlight.rst b/Documentation/media/uapi/dvb/video-set-highlight.rst
index 6ff11af71355..d93b69eef15b 100644
--- a/Documentation/media/uapi/dvb/video-set-highlight.rst
+++ b/Documentation/media/uapi/dvb/video-set-highlight.rst
@@ -11,11 +11,13 @@ Name
 
 VIDEO_SET_HIGHLIGHT
 
+.. attention:: This ioctl is deprecated.
 
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = VIDEO_SET_HIGHLIGHT ,video_highlight_t *vhilite)
+.. c:function:: int ioctl(fd, VIDEO_SET_HIGHLIGHT ,video_highlight_t *vhilite)
+    :name: VIDEO_SET_HIGHLIGHT
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-set-id.rst b/Documentation/media/uapi/dvb/video-set-id.rst
index 61993ab354ca..18f66875ae3f 100644
--- a/Documentation/media/uapi/dvb/video-set-id.rst
+++ b/Documentation/media/uapi/dvb/video-set-id.rst
@@ -11,11 +11,13 @@ Name
 
 VIDEO_SET_ID
 
+.. attention:: This ioctl is deprecated.
 
 Synopsis
 --------
 
-.. c:function:: int ioctl(int fd, int request = VIDEO_SET_ID, int id)
+.. c:function:: int ioctl(int fd, VIDEO_SET_ID, int id)
+    :name: VIDEO_SET_ID
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-set-spu-palette.rst b/Documentation/media/uapi/dvb/video-set-spu-palette.rst
index ae9e0da5fd0b..b24f7882089a 100644
--- a/Documentation/media/uapi/dvb/video-set-spu-palette.rst
+++ b/Documentation/media/uapi/dvb/video-set-spu-palette.rst
@@ -11,11 +11,13 @@ Name
 
 VIDEO_SET_SPU_PALETTE
 
+.. attention:: This ioctl is deprecated.
 
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = VIDEO_SET_SPU_PALETTE, video_spu_palette_t *palette )
+.. c:function:: int ioctl(fd, VIDEO_SET_SPU_PALETTE, video_spu_palette_t *palette )
+    :name: VIDEO_SET_SPU_PALETTE
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-set-spu.rst b/Documentation/media/uapi/dvb/video-set-spu.rst
index ce2860574f20..2a7f0625de38 100644
--- a/Documentation/media/uapi/dvb/video-set-spu.rst
+++ b/Documentation/media/uapi/dvb/video-set-spu.rst
@@ -11,11 +11,13 @@ Name
 
 VIDEO_SET_SPU
 
+.. attention:: This ioctl is deprecated.
 
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = VIDEO_SET_SPU , video_spu_t *spu)
+.. c:function:: int ioctl(fd, VIDEO_SET_SPU , video_spu_t *spu)
+    :name: VIDEO_SET_SPU
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-set-streamtype.rst b/Documentation/media/uapi/dvb/video-set-streamtype.rst
index a2055369f0cd..02a3c2e4e67c 100644
--- a/Documentation/media/uapi/dvb/video-set-streamtype.rst
+++ b/Documentation/media/uapi/dvb/video-set-streamtype.rst
@@ -11,11 +11,13 @@ Name
 
 VIDEO_SET_STREAMTYPE
 
+.. attention:: This ioctl is deprecated.
 
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = VIDEO_SET_STREAMTYPE, int type)
+.. c:function:: int ioctl(fd, VIDEO_SET_STREAMTYPE, int type)
+    :name: VIDEO_SET_STREAMTYPE
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-set-system.rst b/Documentation/media/uapi/dvb/video-set-system.rst
index f84906a7d1f4..e39cbe080ef7 100644
--- a/Documentation/media/uapi/dvb/video-set-system.rst
+++ b/Documentation/media/uapi/dvb/video-set-system.rst
@@ -11,11 +11,13 @@ Name
 
 VIDEO_SET_SYSTEM
 
+.. attention:: This ioctl is deprecated.
 
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = VIDEO_SET_SYSTEM , video_system_t system)
+.. c:function:: int ioctl(fd, VIDEO_SET_SYSTEM , video_system_t system)
+    :name: VIDEO_SET_SYSTEM
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-slowmotion.rst b/Documentation/media/uapi/dvb/video-slowmotion.rst
index c8cc85af590b..bd3d1a4070d9 100644
--- a/Documentation/media/uapi/dvb/video-slowmotion.rst
+++ b/Documentation/media/uapi/dvb/video-slowmotion.rst
@@ -11,11 +11,13 @@ Name
 
 VIDEO_SLOWMOTION
 
+.. attention:: This ioctl is deprecated.
 
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = VIDEO_SLOWMOTION, int nFrames)
+.. c:function:: int ioctl(fd, VIDEO_SLOWMOTION, int nFrames)
+    :name: VIDEO_SLOWMOTION
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-stillpicture.rst b/Documentation/media/uapi/dvb/video-stillpicture.rst
index 053cdbba4ed4..6f943f5e27bd 100644
--- a/Documentation/media/uapi/dvb/video-stillpicture.rst
+++ b/Documentation/media/uapi/dvb/video-stillpicture.rst
@@ -11,11 +11,13 @@ Name
 
 VIDEO_STILLPICTURE
 
+.. attention:: This ioctl is deprecated.
 
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = VIDEO_STILLPICTURE, struct video_still_picture *sp)
+.. c:function:: int ioctl(fd, VIDEO_STILLPICTURE, struct video_still_picture *sp)
+    :name: VIDEO_STILLPICTURE
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-stop.rst b/Documentation/media/uapi/dvb/video-stop.rst
index 4e7fbab4b8bc..fb827effb276 100644
--- a/Documentation/media/uapi/dvb/video-stop.rst
+++ b/Documentation/media/uapi/dvb/video-stop.rst
@@ -11,11 +11,13 @@ Name
 
 VIDEO_STOP
 
+.. attention:: This ioctl is deprecated.
 
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = VIDEO_STOP, boolean mode)
+.. c:function:: int ioctl(fd, VIDEO_STOP, boolean mode)
+    :name: VIDEO_STOP
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-try-command.rst b/Documentation/media/uapi/dvb/video-try-command.rst
index be21fb01bd0f..008e6a9ab696 100644
--- a/Documentation/media/uapi/dvb/video-try-command.rst
+++ b/Documentation/media/uapi/dvb/video-try-command.rst
@@ -11,11 +11,13 @@ Name
 
 VIDEO_TRY_COMMAND
 
+.. attention:: This ioctl is deprecated.
 
 Synopsis
 --------
 
-.. c:function:: int ioctl(int fd, int request = VIDEO_TRY_COMMAND, struct video_command *cmd)
+.. c:function:: int ioctl(int fd, VIDEO_TRY_COMMAND, struct video_command *cmd)
+    :name: VIDEO_TRY_COMMAND
 
 
 Arguments
-- 
2.7.4


