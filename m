Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41361 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159AbcGHNEI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 09:04:08 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: corbet@lwn.net, markus.heiser@darmarIT.de,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 10/54] doc-rst: linux_tv: use :cpp:function:: on all syscalls
Date: Fri,  8 Jul 2016 10:03:02 -0300
Message-Id: <5929cb1769b1171d063c2ec108f5fb66d3239889.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that we have one syscall per page, using :cpp:function::
cleans up almost all warnings, with is a great thing.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../media/dvb/audio-bilingual-channel-select.rst     |  2 +-
 .../linux_tv/media/dvb/audio-channel-select.rst      |  2 +-
 .../linux_tv/media/dvb/audio-clear-buffer.rst        |  2 +-
 Documentation/linux_tv/media/dvb/audio-continue.rst  |  2 +-
 Documentation/linux_tv/media/dvb/audio-fclose.rst    |  2 +-
 Documentation/linux_tv/media/dvb/audio-fopen.rst     |  2 +-
 Documentation/linux_tv/media/dvb/audio-fwrite.rst    |  2 +-
 .../linux_tv/media/dvb/audio-get-capabilities.rst    |  2 +-
 Documentation/linux_tv/media/dvb/audio-get-pts.rst   |  2 +-
 .../linux_tv/media/dvb/audio-get-status.rst          |  2 +-
 Documentation/linux_tv/media/dvb/audio-pause.rst     |  2 +-
 Documentation/linux_tv/media/dvb/audio-play.rst      |  2 +-
 .../linux_tv/media/dvb/audio-select-source.rst       |  2 +-
 .../linux_tv/media/dvb/audio-set-attributes.rst      |  2 +-
 .../linux_tv/media/dvb/audio-set-av-sync.rst         |  2 +-
 .../linux_tv/media/dvb/audio-set-bypass-mode.rst     |  2 +-
 .../linux_tv/media/dvb/audio-set-ext-id.rst          |  2 +-
 Documentation/linux_tv/media/dvb/audio-set-id.rst    |  2 +-
 .../linux_tv/media/dvb/audio-set-karaoke.rst         |  2 +-
 Documentation/linux_tv/media/dvb/audio-set-mixer.rst |  2 +-
 Documentation/linux_tv/media/dvb/audio-set-mute.rst  |  2 +-
 .../linux_tv/media/dvb/audio-set-streamtype.rst      |  2 +-
 Documentation/linux_tv/media/dvb/audio-stop.rst      |  2 +-
 Documentation/linux_tv/media/dvb/dmx-add-pid.rst     |  2 +-
 Documentation/linux_tv/media/dvb/dmx-fclose.rst      |  2 +-
 Documentation/linux_tv/media/dvb/dmx-fopen.rst       |  2 +-
 Documentation/linux_tv/media/dvb/dmx-fread.rst       |  2 +-
 Documentation/linux_tv/media/dvb/dmx-fwrite.rst      |  2 +-
 Documentation/linux_tv/media/dvb/dmx-get-caps.rst    |  2 +-
 Documentation/linux_tv/media/dvb/dmx-get-event.rst   |  2 +-
 .../linux_tv/media/dvb/dmx-get-pes-pids.rst          |  2 +-
 Documentation/linux_tv/media/dvb/dmx-get-stc.rst     |  2 +-
 Documentation/linux_tv/media/dvb/dmx-remove-pid.rst  |  2 +-
 .../linux_tv/media/dvb/dmx-set-buffer-size.rst       |  2 +-
 Documentation/linux_tv/media/dvb/dmx-set-filter.rst  |  2 +-
 .../linux_tv/media/dvb/dmx-set-pes-filter.rst        |  2 +-
 Documentation/linux_tv/media/dvb/dmx-set-source.rst  |  2 +-
 Documentation/linux_tv/media/dvb/dmx-start.rst       |  2 +-
 Documentation/linux_tv/media/dvb/dmx-stop.rst        |  2 +-
 .../linux_tv/media/dvb/fe-diseqc-send-burst.rst      |  2 +-
 .../linux_tv/media/dvb/fe-diseqc-send-master-cmd.rst | 20 +++++++++++---------
 .../media/dvb/fe-dishnetwork-send-legacy-cmd.rst     |  2 +-
 Documentation/linux_tv/media/dvb/fe-get-event.rst    |  2 +-
 Documentation/linux_tv/media/dvb/fe-get-frontend.rst |  2 +-
 Documentation/linux_tv/media/dvb/fe-read-ber.rst     |  2 +-
 .../linux_tv/media/dvb/fe-read-signal-strength.rst   |  2 +-
 Documentation/linux_tv/media/dvb/fe-read-snr.rst     |  2 +-
 .../media/dvb/fe-read-uncorrected-blocks.rst         |  2 +-
 Documentation/linux_tv/media/dvb/fe-set-frontend.rst |  2 +-
 Documentation/linux_tv/media/dvb/fe-set-tone.rst     |  2 +-
 Documentation/linux_tv/media/dvb/fe-set-voltage.rst  |  2 +-
 .../linux_tv/media/dvb/video-clear-buffer.rst        |  2 +-
 Documentation/linux_tv/media/dvb/video-command.rst   |  2 +-
 Documentation/linux_tv/media/dvb/video-continue.rst  |  2 +-
 .../linux_tv/media/dvb/video-fast-forward.rst        |  2 +-
 Documentation/linux_tv/media/dvb/video-fclose.rst    |  2 +-
 Documentation/linux_tv/media/dvb/video-fopen.rst     |  2 +-
 Documentation/linux_tv/media/dvb/video-freeze.rst    |  2 +-
 Documentation/linux_tv/media/dvb/video-fwrite.rst    |  2 +-
 .../linux_tv/media/dvb/video-get-capabilities.rst    |  2 +-
 Documentation/linux_tv/media/dvb/video-get-event.rst |  2 +-
 .../linux_tv/media/dvb/video-get-frame-count.rst     |  2 +-
 .../linux_tv/media/dvb/video-get-frame-rate.rst      |  2 +-
 Documentation/linux_tv/media/dvb/video-get-navi.rst  |  2 +-
 Documentation/linux_tv/media/dvb/video-get-pts.rst   |  2 +-
 Documentation/linux_tv/media/dvb/video-get-size.rst  |  2 +-
 .../linux_tv/media/dvb/video-get-status.rst          |  2 +-
 Documentation/linux_tv/media/dvb/video-play.rst      |  2 +-
 .../linux_tv/media/dvb/video-select-source.rst       |  2 +-
 .../linux_tv/media/dvb/video-set-attributes.rst      |  2 +-
 Documentation/linux_tv/media/dvb/video-set-blank.rst |  2 +-
 .../linux_tv/media/dvb/video-set-display-format.rst  |  2 +-
 .../linux_tv/media/dvb/video-set-format.rst          |  2 +-
 .../linux_tv/media/dvb/video-set-highlight.rst       |  2 +-
 Documentation/linux_tv/media/dvb/video-set-id.rst    |  2 +-
 .../linux_tv/media/dvb/video-set-spu-palette.rst     |  2 +-
 Documentation/linux_tv/media/dvb/video-set-spu.rst   |  2 +-
 .../linux_tv/media/dvb/video-set-streamtype.rst      |  2 +-
 .../linux_tv/media/dvb/video-set-system.rst          |  2 +-
 .../linux_tv/media/dvb/video-slowmotion.rst          |  2 +-
 .../linux_tv/media/dvb/video-stillpicture.rst        |  2 +-
 Documentation/linux_tv/media/dvb/video-stop.rst      |  2 +-
 .../linux_tv/media/dvb/video-try-command.rst         |  2 +-
 .../linux_tv/media/v4l/vidioc-g-priority.rst         |  4 ++--
 84 files changed, 95 insertions(+), 93 deletions(-)

diff --git a/Documentation/linux_tv/media/dvb/audio-bilingual-channel-select.rst b/Documentation/linux_tv/media/dvb/audio-bilingual-channel-select.rst
index 841c9759d5e0..dbe20ff38e83 100644
--- a/Documentation/linux_tv/media/dvb/audio-bilingual-channel-select.rst
+++ b/Documentation/linux_tv/media/dvb/audio-bilingual-channel-select.rst
@@ -15,7 +15,7 @@ AUDIO_BILINGUAL_CHANNEL_SELECT
 Synopsis
 --------
 
-.. c:function:: int ioctl(int fd, int request = AUDIO_BILINGUAL_CHANNEL_SELECT, audio_channel_select_t)
+.. cpp:function:: int ioctl(int fd, int request = AUDIO_BILINGUAL_CHANNEL_SELECT, audio_channel_select_t)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/audio-channel-select.rst b/Documentation/linux_tv/media/dvb/audio-channel-select.rst
index f2dd79903c49..69df4c0f2fb2 100644
--- a/Documentation/linux_tv/media/dvb/audio-channel-select.rst
+++ b/Documentation/linux_tv/media/dvb/audio-channel-select.rst
@@ -15,7 +15,7 @@ AUDIO_CHANNEL_SELECT
 Synopsis
 --------
 
-.. c:function:: int ioctl(int fd, int request = AUDIO_CHANNEL_SELECT, audio_channel_select_t)
+.. cpp:function:: int ioctl(int fd, int request = AUDIO_CHANNEL_SELECT, audio_channel_select_t)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/audio-clear-buffer.rst b/Documentation/linux_tv/media/dvb/audio-clear-buffer.rst
index a576c6b160a4..a3dec29bdc69 100644
--- a/Documentation/linux_tv/media/dvb/audio-clear-buffer.rst
+++ b/Documentation/linux_tv/media/dvb/audio-clear-buffer.rst
@@ -15,7 +15,7 @@ AUDIO_CLEAR_BUFFER
 Synopsis
 --------
 
-.. c:function:: int  ioctl(int fd, int request = AUDIO_CLEAR_BUFFER)
+.. cpp:function:: int  ioctl(int fd, int request = AUDIO_CLEAR_BUFFER)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/audio-continue.rst b/Documentation/linux_tv/media/dvb/audio-continue.rst
index b513a39f0935..053627dd61e7 100644
--- a/Documentation/linux_tv/media/dvb/audio-continue.rst
+++ b/Documentation/linux_tv/media/dvb/audio-continue.rst
@@ -15,7 +15,7 @@ AUDIO_CONTINUE
 Synopsis
 --------
 
-.. c:function:: int  ioctl(int fd, int request = AUDIO_CONTINUE)
+.. cpp:function:: int  ioctl(int fd, int request = AUDIO_CONTINUE)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/audio-fclose.rst b/Documentation/linux_tv/media/dvb/audio-fclose.rst
index e515fb353a14..e5d4225cd9d7 100644
--- a/Documentation/linux_tv/media/dvb/audio-fclose.rst
+++ b/Documentation/linux_tv/media/dvb/audio-fclose.rst
@@ -15,7 +15,7 @@ DVB audio close()
 Synopsis
 --------
 
-.. c:function:: int  close(int fd)
+.. cpp:function:: int  close(int fd)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/audio-fopen.rst b/Documentation/linux_tv/media/dvb/audio-fopen.rst
index 46a15950439f..ec3b23aa79b3 100644
--- a/Documentation/linux_tv/media/dvb/audio-fopen.rst
+++ b/Documentation/linux_tv/media/dvb/audio-fopen.rst
@@ -15,7 +15,7 @@ DVB audio open()
 Synopsis
 --------
 
-.. c:function:: int  open(const char *deviceName, int flags)
+.. cpp:function:: int  open(const char *deviceName, int flags)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/audio-fwrite.rst b/Documentation/linux_tv/media/dvb/audio-fwrite.rst
index f9307053064f..ca95b9be0c2a 100644
--- a/Documentation/linux_tv/media/dvb/audio-fwrite.rst
+++ b/Documentation/linux_tv/media/dvb/audio-fwrite.rst
@@ -15,7 +15,7 @@ DVB audio write()
 Synopsis
 --------
 
-.. c:function:: size_t write(int fd, const void *buf, size_t count)
+.. cpp:function:: size_t write(int fd, const void *buf, size_t count)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/audio-get-capabilities.rst b/Documentation/linux_tv/media/dvb/audio-get-capabilities.rst
index 8b6fdc664f9d..e274a8d53785 100644
--- a/Documentation/linux_tv/media/dvb/audio-get-capabilities.rst
+++ b/Documentation/linux_tv/media/dvb/audio-get-capabilities.rst
@@ -15,7 +15,7 @@ AUDIO_GET_CAPABILITIES
 Synopsis
 --------
 
-.. c:function:: int ioctl(int fd, int request = AUDIO_GET_CAPABILITIES, unsigned int *cap)
+.. cpp:function:: int ioctl(int fd, int request = AUDIO_GET_CAPABILITIES, unsigned int *cap)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/audio-get-pts.rst b/Documentation/linux_tv/media/dvb/audio-get-pts.rst
index 246c78c003de..5f875508b833 100644
--- a/Documentation/linux_tv/media/dvb/audio-get-pts.rst
+++ b/Documentation/linux_tv/media/dvb/audio-get-pts.rst
@@ -15,7 +15,7 @@ AUDIO_GET_PTS
 Synopsis
 --------
 
-.. c:function:: int ioctl(int fd, int request = AUDIO_GET_PTS, __u64 *pts)
+.. cpp:function:: int ioctl(int fd, int request = AUDIO_GET_PTS, __u64 *pts)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/audio-get-status.rst b/Documentation/linux_tv/media/dvb/audio-get-status.rst
index b0a550af87b3..cbd822773d85 100644
--- a/Documentation/linux_tv/media/dvb/audio-get-status.rst
+++ b/Documentation/linux_tv/media/dvb/audio-get-status.rst
@@ -15,7 +15,7 @@ AUDIO_GET_STATUS
 Synopsis
 --------
 
-.. c:function:: int ioctl(int fd, int request = AUDIO_GET_STATUS, struct audio_status *status)
+.. cpp:function:: int ioctl(int fd, int request = AUDIO_GET_STATUS, struct audio_status *status)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/audio-pause.rst b/Documentation/linux_tv/media/dvb/audio-pause.rst
index 86652c3bca06..9ca263e90c6c 100644
--- a/Documentation/linux_tv/media/dvb/audio-pause.rst
+++ b/Documentation/linux_tv/media/dvb/audio-pause.rst
@@ -15,7 +15,7 @@ AUDIO_PAUSE
 Synopsis
 --------
 
-.. c:function:: int  ioctl(int fd, int request = AUDIO_PAUSE)
+.. cpp:function:: int  ioctl(int fd, int request = AUDIO_PAUSE)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/audio-play.rst b/Documentation/linux_tv/media/dvb/audio-play.rst
index 1af708375821..db4d7203acc5 100644
--- a/Documentation/linux_tv/media/dvb/audio-play.rst
+++ b/Documentation/linux_tv/media/dvb/audio-play.rst
@@ -15,7 +15,7 @@ AUDIO_PLAY
 Synopsis
 --------
 
-.. c:function:: int  ioctl(int fd, int request = AUDIO_PLAY)
+.. cpp:function:: int  ioctl(int fd, int request = AUDIO_PLAY)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/audio-select-source.rst b/Documentation/linux_tv/media/dvb/audio-select-source.rst
index 3e873d9cb345..b806d806a46f 100644
--- a/Documentation/linux_tv/media/dvb/audio-select-source.rst
+++ b/Documentation/linux_tv/media/dvb/audio-select-source.rst
@@ -15,7 +15,7 @@ AUDIO_SELECT_SOURCE
 Synopsis
 --------
 
-.. c:function:: int ioctl(int fd, int request = AUDIO_SELECT_SOURCE, audio_stream_source_t source)
+.. cpp:function:: int ioctl(int fd, int request = AUDIO_SELECT_SOURCE, audio_stream_source_t source)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/audio-set-attributes.rst b/Documentation/linux_tv/media/dvb/audio-set-attributes.rst
index 43ff50279742..18667cea2cdf 100644
--- a/Documentation/linux_tv/media/dvb/audio-set-attributes.rst
+++ b/Documentation/linux_tv/media/dvb/audio-set-attributes.rst
@@ -15,7 +15,7 @@ AUDIO_SET_ATTRIBUTES
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = AUDIO_SET_ATTRIBUTES, audio_attributes_t attr )
+.. cpp:function:: int ioctl(fd, int request = AUDIO_SET_ATTRIBUTES, audio_attributes_t attr )
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/audio-set-av-sync.rst b/Documentation/linux_tv/media/dvb/audio-set-av-sync.rst
index 4ecfb75d28f1..6f7e26fa4cd1 100644
--- a/Documentation/linux_tv/media/dvb/audio-set-av-sync.rst
+++ b/Documentation/linux_tv/media/dvb/audio-set-av-sync.rst
@@ -15,7 +15,7 @@ AUDIO_SET_AV_SYNC
 Synopsis
 --------
 
-.. c:function:: int  ioctl(int fd, int request = AUDIO_SET_AV_SYNC, boolean state)
+.. cpp:function:: int  ioctl(int fd, int request = AUDIO_SET_AV_SYNC, boolean state)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/audio-set-bypass-mode.rst b/Documentation/linux_tv/media/dvb/audio-set-bypass-mode.rst
index b21d142ec31c..30bcaca14c3f 100644
--- a/Documentation/linux_tv/media/dvb/audio-set-bypass-mode.rst
+++ b/Documentation/linux_tv/media/dvb/audio-set-bypass-mode.rst
@@ -15,7 +15,7 @@ AUDIO_SET_BYPASS_MODE
 Synopsis
 --------
 
-.. c:function:: int ioctl(int fd, int request = AUDIO_SET_BYPASS_MODE, boolean mode)
+.. cpp:function:: int ioctl(int fd, int request = AUDIO_SET_BYPASS_MODE, boolean mode)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/audio-set-ext-id.rst b/Documentation/linux_tv/media/dvb/audio-set-ext-id.rst
index 1b5b8893a00b..049414db8ef6 100644
--- a/Documentation/linux_tv/media/dvb/audio-set-ext-id.rst
+++ b/Documentation/linux_tv/media/dvb/audio-set-ext-id.rst
@@ -15,7 +15,7 @@ AUDIO_SET_EXT_ID
 Synopsis
 --------
 
-.. c:function:: int  ioctl(fd, int request = AUDIO_SET_EXT_ID, int id)
+.. cpp:function:: int  ioctl(fd, int request = AUDIO_SET_EXT_ID, int id)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/audio-set-id.rst b/Documentation/linux_tv/media/dvb/audio-set-id.rst
index fed99eae52cb..a664dc1955cb 100644
--- a/Documentation/linux_tv/media/dvb/audio-set-id.rst
+++ b/Documentation/linux_tv/media/dvb/audio-set-id.rst
@@ -15,7 +15,7 @@ AUDIO_SET_ID
 Synopsis
 --------
 
-.. c:function:: int  ioctl(int fd, int request = AUDIO_SET_ID, int id)
+.. cpp:function:: int  ioctl(int fd, int request = AUDIO_SET_ID, int id)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/audio-set-karaoke.rst b/Documentation/linux_tv/media/dvb/audio-set-karaoke.rst
index ebb2d41bbec3..b55f8380b9cd 100644
--- a/Documentation/linux_tv/media/dvb/audio-set-karaoke.rst
+++ b/Documentation/linux_tv/media/dvb/audio-set-karaoke.rst
@@ -15,7 +15,7 @@ AUDIO_SET_KARAOKE
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = AUDIO_SET_KARAOKE, audio_karaoke_t *karaoke)
+.. cpp:function:: int ioctl(fd, int request = AUDIO_SET_KARAOKE, audio_karaoke_t *karaoke)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/audio-set-mixer.rst b/Documentation/linux_tv/media/dvb/audio-set-mixer.rst
index ce4b2a63917e..67821729c2b6 100644
--- a/Documentation/linux_tv/media/dvb/audio-set-mixer.rst
+++ b/Documentation/linux_tv/media/dvb/audio-set-mixer.rst
@@ -15,7 +15,7 @@ AUDIO_SET_MIXER
 Synopsis
 --------
 
-.. c:function:: int ioctl(int fd, int request = AUDIO_SET_MIXER, audio_mixer_t *mix)
+.. cpp:function:: int ioctl(int fd, int request = AUDIO_SET_MIXER, audio_mixer_t *mix)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/audio-set-mute.rst b/Documentation/linux_tv/media/dvb/audio-set-mute.rst
index a2469267508b..ebaba95ee278 100644
--- a/Documentation/linux_tv/media/dvb/audio-set-mute.rst
+++ b/Documentation/linux_tv/media/dvb/audio-set-mute.rst
@@ -15,7 +15,7 @@ AUDIO_SET_MUTE
 Synopsis
 --------
 
-.. c:function:: int  ioctl(int fd, int request = AUDIO_SET_MUTE, boolean state)
+.. cpp:function:: int  ioctl(int fd, int request = AUDIO_SET_MUTE, boolean state)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/audio-set-streamtype.rst b/Documentation/linux_tv/media/dvb/audio-set-streamtype.rst
index 4b13c9b9dffe..dfb9a6c00d88 100644
--- a/Documentation/linux_tv/media/dvb/audio-set-streamtype.rst
+++ b/Documentation/linux_tv/media/dvb/audio-set-streamtype.rst
@@ -15,7 +15,7 @@ AUDIO_SET_STREAMTYPE
 Synopsis
 --------
 
-.. c:function:: int  ioctl(fd, int request = AUDIO_SET_STREAMTYPE, int type)
+.. cpp:function:: int  ioctl(fd, int request = AUDIO_SET_STREAMTYPE, int type)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/audio-stop.rst b/Documentation/linux_tv/media/dvb/audio-stop.rst
index d9430978096f..449127e3f2aa 100644
--- a/Documentation/linux_tv/media/dvb/audio-stop.rst
+++ b/Documentation/linux_tv/media/dvb/audio-stop.rst
@@ -15,7 +15,7 @@ AUDIO_STOP
 Synopsis
 --------
 
-.. c:function:: int ioctl(int fd, int request = AUDIO_STOP)
+.. cpp:function:: int ioctl(int fd, int request = AUDIO_STOP)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/dmx-add-pid.rst b/Documentation/linux_tv/media/dvb/dmx-add-pid.rst
index 37f5ee43d523..6343035653ac 100644
--- a/Documentation/linux_tv/media/dvb/dmx-add-pid.rst
+++ b/Documentation/linux_tv/media/dvb/dmx-add-pid.rst
@@ -15,7 +15,7 @@ DMX_ADD_PID
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = DMX_ADD_PID, __u16 *)
+.. cpp:function:: int ioctl(fd, int request = DMX_ADD_PID, __u16 *)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/dmx-fclose.rst b/Documentation/linux_tv/media/dvb/dmx-fclose.rst
index e442881481a2..f54c2a1220c1 100644
--- a/Documentation/linux_tv/media/dvb/dmx-fclose.rst
+++ b/Documentation/linux_tv/media/dvb/dmx-fclose.rst
@@ -15,7 +15,7 @@ DVB demux close()
 Synopsis
 --------
 
-.. c:function:: int close(int fd)
+.. cpp:function:: int close(int fd)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/dmx-fopen.rst b/Documentation/linux_tv/media/dvb/dmx-fopen.rst
index 7e640fa860c3..76dbb42713ad 100644
--- a/Documentation/linux_tv/media/dvb/dmx-fopen.rst
+++ b/Documentation/linux_tv/media/dvb/dmx-fopen.rst
@@ -15,7 +15,7 @@ DVB demux open()
 Synopsis
 --------
 
-.. c:function:: int open(const char *deviceName, int flags)
+.. cpp:function:: int open(const char *deviceName, int flags)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/dmx-fread.rst b/Documentation/linux_tv/media/dvb/dmx-fread.rst
index 92f7a0632766..d25b19e4f696 100644
--- a/Documentation/linux_tv/media/dvb/dmx-fread.rst
+++ b/Documentation/linux_tv/media/dvb/dmx-fread.rst
@@ -15,7 +15,7 @@ DVB demux read()
 Synopsis
 --------
 
-.. c:function:: size_t read(int fd, void *buf, size_t count)
+.. cpp:function:: size_t read(int fd, void *buf, size_t count)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/dmx-fwrite.rst b/Documentation/linux_tv/media/dvb/dmx-fwrite.rst
index 8d2632205c29..9efd81a1b5c8 100644
--- a/Documentation/linux_tv/media/dvb/dmx-fwrite.rst
+++ b/Documentation/linux_tv/media/dvb/dmx-fwrite.rst
@@ -15,7 +15,7 @@ DVB demux write()
 Synopsis
 --------
 
-.. c:function:: ssize_t write(int fd, const void *buf, size_t count)
+.. cpp:function:: ssize_t write(int fd, const void *buf, size_t count)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/dmx-get-caps.rst b/Documentation/linux_tv/media/dvb/dmx-get-caps.rst
index 20e3d6e55d30..d0549eb7fbd3 100644
--- a/Documentation/linux_tv/media/dvb/dmx-get-caps.rst
+++ b/Documentation/linux_tv/media/dvb/dmx-get-caps.rst
@@ -15,7 +15,7 @@ DMX_GET_CAPS
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = DMX_GET_CAPS, dmx_caps_t *)
+.. cpp:function:: int ioctl(fd, int request = DMX_GET_CAPS, dmx_caps_t *)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/dmx-get-event.rst b/Documentation/linux_tv/media/dvb/dmx-get-event.rst
index 81a7c7fedd47..6a7550c63bb5 100644
--- a/Documentation/linux_tv/media/dvb/dmx-get-event.rst
+++ b/Documentation/linux_tv/media/dvb/dmx-get-event.rst
@@ -15,7 +15,7 @@ DMX_GET_EVENT
 Synopsis
 --------
 
-.. c:function:: int ioctl( int fd, int request = DMX_GET_EVENT, struct dmx_event *ev)
+.. cpp:function:: int ioctl( int fd, int request = DMX_GET_EVENT, struct dmx_event *ev)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/dmx-get-pes-pids.rst b/Documentation/linux_tv/media/dvb/dmx-get-pes-pids.rst
index 8b1fbf5d2c81..ba5d30c913c8 100644
--- a/Documentation/linux_tv/media/dvb/dmx-get-pes-pids.rst
+++ b/Documentation/linux_tv/media/dvb/dmx-get-pes-pids.rst
@@ -15,7 +15,7 @@ DMX_GET_PES_PIDS
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = DMX_GET_PES_PIDS, __u16[5])
+.. cpp:function:: int ioctl(fd, int request = DMX_GET_PES_PIDS, __u16[5])
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/dmx-get-stc.rst b/Documentation/linux_tv/media/dvb/dmx-get-stc.rst
index 616c745a0418..bd477bb67082 100644
--- a/Documentation/linux_tv/media/dvb/dmx-get-stc.rst
+++ b/Documentation/linux_tv/media/dvb/dmx-get-stc.rst
@@ -15,7 +15,7 @@ DMX_GET_STC
 Synopsis
 --------
 
-.. c:function:: int ioctl( int fd, int request = DMX_GET_STC, struct dmx_stc *stc)
+.. cpp:function:: int ioctl( int fd, int request = DMX_GET_STC, struct dmx_stc *stc)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/dmx-remove-pid.rst b/Documentation/linux_tv/media/dvb/dmx-remove-pid.rst
index ed1a49ce9fc2..c8f038b40074 100644
--- a/Documentation/linux_tv/media/dvb/dmx-remove-pid.rst
+++ b/Documentation/linux_tv/media/dvb/dmx-remove-pid.rst
@@ -15,7 +15,7 @@ DMX_REMOVE_PID
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = DMX_REMOVE_PID, __u16 *)
+.. cpp:function:: int ioctl(fd, int request = DMX_REMOVE_PID, __u16 *)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/dmx-set-buffer-size.rst b/Documentation/linux_tv/media/dvb/dmx-set-buffer-size.rst
index 012b9e9792be..8ae48cf39cda 100644
--- a/Documentation/linux_tv/media/dvb/dmx-set-buffer-size.rst
+++ b/Documentation/linux_tv/media/dvb/dmx-set-buffer-size.rst
@@ -15,7 +15,7 @@ DMX_SET_BUFFER_SIZE
 Synopsis
 --------
 
-.. c:function:: int ioctl( int fd, int request = DMX_SET_BUFFER_SIZE, unsigned long size)
+.. cpp:function:: int ioctl( int fd, int request = DMX_SET_BUFFER_SIZE, unsigned long size)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/dmx-set-filter.rst b/Documentation/linux_tv/media/dvb/dmx-set-filter.rst
index d079d8b39597..8c929fa9b98c 100644
--- a/Documentation/linux_tv/media/dvb/dmx-set-filter.rst
+++ b/Documentation/linux_tv/media/dvb/dmx-set-filter.rst
@@ -15,7 +15,7 @@ DMX_SET_FILTER
 Synopsis
 --------
 
-.. c:function:: int ioctl( int fd, int request = DMX_SET_FILTER, struct dmx_sct_filter_params *params)
+.. cpp:function:: int ioctl( int fd, int request = DMX_SET_FILTER, struct dmx_sct_filter_params *params)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/dmx-set-pes-filter.rst b/Documentation/linux_tv/media/dvb/dmx-set-pes-filter.rst
index 910869ebdefd..addc321011ce 100644
--- a/Documentation/linux_tv/media/dvb/dmx-set-pes-filter.rst
+++ b/Documentation/linux_tv/media/dvb/dmx-set-pes-filter.rst
@@ -15,7 +15,7 @@ DMX_SET_PES_FILTER
 Synopsis
 --------
 
-.. c:function:: int ioctl( int fd, int request = DMX_SET_PES_FILTER, struct dmx_pes_filter_params *params)
+.. cpp:function:: int ioctl( int fd, int request = DMX_SET_PES_FILTER, struct dmx_pes_filter_params *params)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/dmx-set-source.rst b/Documentation/linux_tv/media/dvb/dmx-set-source.rst
index 7aa4dfe3cdc5..99a8d5c82756 100644
--- a/Documentation/linux_tv/media/dvb/dmx-set-source.rst
+++ b/Documentation/linux_tv/media/dvb/dmx-set-source.rst
@@ -15,7 +15,7 @@ DMX_SET_SOURCE
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = DMX_SET_SOURCE, dmx_source_t *)
+.. cpp:function:: int ioctl(fd, int request = DMX_SET_SOURCE, dmx_source_t *)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/dmx-start.rst b/Documentation/linux_tv/media/dvb/dmx-start.rst
index cc316d00343d..9835d1e78400 100644
--- a/Documentation/linux_tv/media/dvb/dmx-start.rst
+++ b/Documentation/linux_tv/media/dvb/dmx-start.rst
@@ -15,7 +15,7 @@ DMX_START
 Synopsis
 --------
 
-.. c:function:: int ioctl( int fd, int request = DMX_START)
+.. cpp:function:: int ioctl( int fd, int request = DMX_START)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/dmx-stop.rst b/Documentation/linux_tv/media/dvb/dmx-stop.rst
index f9157dd6a8fe..7e4bf09fc83e 100644
--- a/Documentation/linux_tv/media/dvb/dmx-stop.rst
+++ b/Documentation/linux_tv/media/dvb/dmx-stop.rst
@@ -15,7 +15,7 @@ DMX_STOP
 Synopsis
 --------
 
-.. c:function:: int ioctl( int fd, int request = DMX_STOP)
+.. cpp:function:: int ioctl( int fd, int request = DMX_STOP)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/fe-diseqc-send-burst.rst b/Documentation/linux_tv/media/dvb/fe-diseqc-send-burst.rst
index c022cc290067..11d441c6f237 100644
--- a/Documentation/linux_tv/media/dvb/fe-diseqc-send-burst.rst
+++ b/Documentation/linux_tv/media/dvb/fe-diseqc-send-burst.rst
@@ -15,7 +15,7 @@ FE_DISEQC_SEND_BURST - Sends a 22KHz tone burst for 2x1 mini DiSEqC satellite se
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, enum fe_sec_mini_cmd *tone )
+.. cpp:function:: int ioctl( int fd, int request, enum fe_sec_mini_cmd *tone )
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/fe-diseqc-send-master-cmd.rst b/Documentation/linux_tv/media/dvb/fe-diseqc-send-master-cmd.rst
index dc83b4f2e586..58a5e6ac10bd 100644
--- a/Documentation/linux_tv/media/dvb/fe-diseqc-send-master-cmd.rst
+++ b/Documentation/linux_tv/media/dvb/fe-diseqc-send-master-cmd.rst
@@ -37,17 +37,11 @@ Description
 
 Sends a DiSEqC command to the antenna subsystem.
 
-
-Return Value
-============
-
-On success 0 is returned, on error -1 and the ``errno`` variable is set
-appropriately. The generic error codes are described at the
-:ref:`Generic Error Codes <gen-errors>` chapter.
-
-
 .. _dvb-diseqc-master-cmd:
 
+struct dvb_diseqc_master_cmd
+============================
+
 .. flat-table:: struct dvb_diseqc_master_cmd
     :header-rows:  0
     :stub-columns: 0
@@ -69,3 +63,11 @@ appropriately. The generic error codes are described at the
        -  msg_len
 
        -  Length of the DiSEqC message. Valid values are 3 to 6
+
+Return Value
+============
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
+
diff --git a/Documentation/linux_tv/media/dvb/fe-dishnetwork-send-legacy-cmd.rst b/Documentation/linux_tv/media/dvb/fe-dishnetwork-send-legacy-cmd.rst
index 4b60a42dd52c..9f71b39de0c2 100644
--- a/Documentation/linux_tv/media/dvb/fe-dishnetwork-send-legacy-cmd.rst
+++ b/Documentation/linux_tv/media/dvb/fe-dishnetwork-send-legacy-cmd.rst
@@ -15,7 +15,7 @@ FE_DISHNETWORK_SEND_LEGACY_CMD
 Synopsis
 ========
 
-.. c:function:: int  ioctl(int fd, int request = FE_DISHNETWORK_SEND_LEGACY_CMD, unsigned long cmd)
+.. cpp:function:: int  ioctl(int fd, int request = FE_DISHNETWORK_SEND_LEGACY_CMD, unsigned long cmd)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/fe-get-event.rst b/Documentation/linux_tv/media/dvb/fe-get-event.rst
index 79beb1b9da3b..ffa3d04c6bd4 100644
--- a/Documentation/linux_tv/media/dvb/fe-get-event.rst
+++ b/Documentation/linux_tv/media/dvb/fe-get-event.rst
@@ -15,7 +15,7 @@ FE_GET_EVENT
 Synopsis
 ========
 
-.. c:function:: int  ioctl(int fd, int request = QPSK_GET_EVENT, struct dvb_frontend_event *ev)
+.. cpp:function:: int  ioctl(int fd, int request = QPSK_GET_EVENT, struct dvb_frontend_event *ev)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/fe-get-frontend.rst b/Documentation/linux_tv/media/dvb/fe-get-frontend.rst
index fdf0d1440add..5d2df808df18 100644
--- a/Documentation/linux_tv/media/dvb/fe-get-frontend.rst
+++ b/Documentation/linux_tv/media/dvb/fe-get-frontend.rst
@@ -15,7 +15,7 @@ FE_GET_FRONTEND
 Synopsis
 ========
 
-.. c:function:: int ioctl(int fd, int request = FE_GET_FRONTEND, struct dvb_frontend_parameters *p)
+.. cpp:function:: int ioctl(int fd, int request = FE_GET_FRONTEND, struct dvb_frontend_parameters *p)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/fe-read-ber.rst b/Documentation/linux_tv/media/dvb/fe-read-ber.rst
index 3262441385ff..c2b5b417f5fb 100644
--- a/Documentation/linux_tv/media/dvb/fe-read-ber.rst
+++ b/Documentation/linux_tv/media/dvb/fe-read-ber.rst
@@ -14,7 +14,7 @@ FE_READ_BER
 Synopsis
 ========
 
-.. c:function:: int  ioctl(int fd, int request = FE_READ_BER, uint32_t *ber)
+.. cpp:function:: int  ioctl(int fd, int request = FE_READ_BER, uint32_t *ber)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/fe-read-signal-strength.rst b/Documentation/linux_tv/media/dvb/fe-read-signal-strength.rst
index fcaadcb537fb..0cdee2effc97 100644
--- a/Documentation/linux_tv/media/dvb/fe-read-signal-strength.rst
+++ b/Documentation/linux_tv/media/dvb/fe-read-signal-strength.rst
@@ -15,7 +15,7 @@ FE_READ_SIGNAL_STRENGTH
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request = FE_READ_SIGNAL_STRENGTH, uint16_t *strength)
+.. cpp:function:: int ioctl( int fd, int request = FE_READ_SIGNAL_STRENGTH, uint16_t *strength)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/fe-read-snr.rst b/Documentation/linux_tv/media/dvb/fe-read-snr.rst
index 837af2de9f6f..5394f9ae90f4 100644
--- a/Documentation/linux_tv/media/dvb/fe-read-snr.rst
+++ b/Documentation/linux_tv/media/dvb/fe-read-snr.rst
@@ -15,7 +15,7 @@ FE_READ_SNR
 Synopsis
 ========
 
-.. c:function:: int  ioctl(int fd, int request = FE_READ_SNR, int16_t *snr)
+.. cpp:function:: int  ioctl(int fd, int request = FE_READ_SNR, int16_t *snr)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/fe-read-uncorrected-blocks.rst b/Documentation/linux_tv/media/dvb/fe-read-uncorrected-blocks.rst
index 6b753846a008..5c29c058dfdc 100644
--- a/Documentation/linux_tv/media/dvb/fe-read-uncorrected-blocks.rst
+++ b/Documentation/linux_tv/media/dvb/fe-read-uncorrected-blocks.rst
@@ -15,7 +15,7 @@ FE_READ_UNCORRECTED_BLOCKS
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request =FE_READ_UNCORRECTED_BLOCKS, uint32_t *ublocks)
+.. cpp:function:: int ioctl( int fd, int request =FE_READ_UNCORRECTED_BLOCKS, uint32_t *ublocks)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/fe-set-frontend.rst b/Documentation/linux_tv/media/dvb/fe-set-frontend.rst
index 4e66da0af6fd..7cb70c38d534 100644
--- a/Documentation/linux_tv/media/dvb/fe-set-frontend.rst
+++ b/Documentation/linux_tv/media/dvb/fe-set-frontend.rst
@@ -15,7 +15,7 @@ FE_SET_FRONTEND
 Synopsis
 ========
 
-.. c:function:: int ioctl(int fd, int request = FE_SET_FRONTEND, struct dvb_frontend_parameters *p)
+.. cpp:function:: int ioctl(int fd, int request = FE_SET_FRONTEND, struct dvb_frontend_parameters *p)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/fe-set-tone.rst b/Documentation/linux_tv/media/dvb/fe-set-tone.rst
index 12aedb69395d..16bf6b73f8d5 100644
--- a/Documentation/linux_tv/media/dvb/fe-set-tone.rst
+++ b/Documentation/linux_tv/media/dvb/fe-set-tone.rst
@@ -15,7 +15,7 @@ FE_SET_TONE - Sets/resets the generation of the continuous 22kHz tone.
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, enum fe_sec_tone_mode *tone )
+.. cpp:function:: int ioctl( int fd, int request, enum fe_sec_tone_mode *tone )
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/fe-set-voltage.rst b/Documentation/linux_tv/media/dvb/fe-set-voltage.rst
index ec8dbf4e266c..517f79bdbb4b 100644
--- a/Documentation/linux_tv/media/dvb/fe-set-voltage.rst
+++ b/Documentation/linux_tv/media/dvb/fe-set-voltage.rst
@@ -15,7 +15,7 @@ FE_SET_VOLTAGE - Allow setting the DC level sent to the antenna subsystem.
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, enum fe_sec_voltage *voltage )
+.. cpp:function:: int ioctl( int fd, int request, enum fe_sec_voltage *voltage )
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/video-clear-buffer.rst b/Documentation/linux_tv/media/dvb/video-clear-buffer.rst
index dd227ad85546..7c85aa06f013 100644
--- a/Documentation/linux_tv/media/dvb/video-clear-buffer.rst
+++ b/Documentation/linux_tv/media/dvb/video-clear-buffer.rst
@@ -15,7 +15,7 @@ VIDEO_CLEAR_BUFFER
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = VIDEO_CLEAR_BUFFER)
+.. cpp:function:: int ioctl(fd, int request = VIDEO_CLEAR_BUFFER)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/video-command.rst b/Documentation/linux_tv/media/dvb/video-command.rst
index 42a98a47e323..b1634f722cbd 100644
--- a/Documentation/linux_tv/media/dvb/video-command.rst
+++ b/Documentation/linux_tv/media/dvb/video-command.rst
@@ -15,7 +15,7 @@ VIDEO_COMMAND
 Synopsis
 --------
 
-.. c:function:: int ioctl(int fd, int request = VIDEO_COMMAND, struct video_command *cmd)
+.. cpp:function:: int ioctl(int fd, int request = VIDEO_COMMAND, struct video_command *cmd)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/video-continue.rst b/Documentation/linux_tv/media/dvb/video-continue.rst
index 2a6444a4f4dc..c5acc094986f 100644
--- a/Documentation/linux_tv/media/dvb/video-continue.rst
+++ b/Documentation/linux_tv/media/dvb/video-continue.rst
@@ -15,7 +15,7 @@ VIDEO_CONTINUE
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = VIDEO_CONTINUE)
+.. cpp:function:: int ioctl(fd, int request = VIDEO_CONTINUE)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/video-fast-forward.rst b/Documentation/linux_tv/media/dvb/video-fast-forward.rst
index 0b3a27a22d30..db338e9f5379 100644
--- a/Documentation/linux_tv/media/dvb/video-fast-forward.rst
+++ b/Documentation/linux_tv/media/dvb/video-fast-forward.rst
@@ -15,7 +15,7 @@ VIDEO_FAST_FORWARD
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = VIDEO_FAST_FORWARD, int nFrames)
+.. cpp:function:: int ioctl(fd, int request = VIDEO_FAST_FORWARD, int nFrames)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/video-fclose.rst b/Documentation/linux_tv/media/dvb/video-fclose.rst
index b4dd5ea676b9..ebeaade0c351 100644
--- a/Documentation/linux_tv/media/dvb/video-fclose.rst
+++ b/Documentation/linux_tv/media/dvb/video-fclose.rst
@@ -15,7 +15,7 @@ dvb video close()
 Synopsis
 --------
 
-.. c:function:: int close(int fd)
+.. cpp:function:: int close(int fd)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/video-fopen.rst b/Documentation/linux_tv/media/dvb/video-fopen.rst
index 31d4d62b2c7c..9e5471557b83 100644
--- a/Documentation/linux_tv/media/dvb/video-fopen.rst
+++ b/Documentation/linux_tv/media/dvb/video-fopen.rst
@@ -15,7 +15,7 @@ dvb video open()
 Synopsis
 --------
 
-.. c:function:: int open(const char *deviceName, int flags)
+.. cpp:function:: int open(const char *deviceName, int flags)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/video-freeze.rst b/Documentation/linux_tv/media/dvb/video-freeze.rst
index 12e04df990b7..d3d0dc31281a 100644
--- a/Documentation/linux_tv/media/dvb/video-freeze.rst
+++ b/Documentation/linux_tv/media/dvb/video-freeze.rst
@@ -15,7 +15,7 @@ VIDEO_FREEZE
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = VIDEO_FREEZE)
+.. cpp:function:: int ioctl(fd, int request = VIDEO_FREEZE)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/video-fwrite.rst b/Documentation/linux_tv/media/dvb/video-fwrite.rst
index da03db4be8de..045038f4181e 100644
--- a/Documentation/linux_tv/media/dvb/video-fwrite.rst
+++ b/Documentation/linux_tv/media/dvb/video-fwrite.rst
@@ -15,7 +15,7 @@ dvb video write()
 Synopsis
 --------
 
-.. c:function:: size_t write(int fd, const void *buf, size_t count)
+.. cpp:function:: size_t write(int fd, const void *buf, size_t count)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/video-get-capabilities.rst b/Documentation/linux_tv/media/dvb/video-get-capabilities.rst
index 5515dd40a1c1..94cbbba478a8 100644
--- a/Documentation/linux_tv/media/dvb/video-get-capabilities.rst
+++ b/Documentation/linux_tv/media/dvb/video-get-capabilities.rst
@@ -15,7 +15,7 @@ VIDEO_GET_CAPABILITIES
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = VIDEO_GET_CAPABILITIES, unsigned int *cap)
+.. cpp:function:: int ioctl(fd, int request = VIDEO_GET_CAPABILITIES, unsigned int *cap)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/video-get-event.rst b/Documentation/linux_tv/media/dvb/video-get-event.rst
index d43459915179..a1484a226518 100644
--- a/Documentation/linux_tv/media/dvb/video-get-event.rst
+++ b/Documentation/linux_tv/media/dvb/video-get-event.rst
@@ -15,7 +15,7 @@ VIDEO_GET_EVENT
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = VIDEO_GET_EVENT, struct video_event *ev)
+.. cpp:function:: int ioctl(fd, int request = VIDEO_GET_EVENT, struct video_event *ev)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/video-get-frame-count.rst b/Documentation/linux_tv/media/dvb/video-get-frame-count.rst
index a55f7a1d52ac..4ff100c2ee95 100644
--- a/Documentation/linux_tv/media/dvb/video-get-frame-count.rst
+++ b/Documentation/linux_tv/media/dvb/video-get-frame-count.rst
@@ -15,7 +15,7 @@ VIDEO_GET_FRAME_COUNT
 Synopsis
 --------
 
-.. c:function:: int ioctl(int fd, int request = VIDEO_GET_FRAME_COUNT, __u64 *pts)
+.. cpp:function:: int ioctl(int fd, int request = VIDEO_GET_FRAME_COUNT, __u64 *pts)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/video-get-frame-rate.rst b/Documentation/linux_tv/media/dvb/video-get-frame-rate.rst
index a137b6589599..131def962305 100644
--- a/Documentation/linux_tv/media/dvb/video-get-frame-rate.rst
+++ b/Documentation/linux_tv/media/dvb/video-get-frame-rate.rst
@@ -15,7 +15,7 @@ VIDEO_GET_FRAME_RATE
 Synopsis
 --------
 
-.. c:function:: int ioctl(int fd, int request = VIDEO_GET_FRAME_RATE, unsigned int *rate)
+.. cpp:function:: int ioctl(int fd, int request = VIDEO_GET_FRAME_RATE, unsigned int *rate)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/video-get-navi.rst b/Documentation/linux_tv/media/dvb/video-get-navi.rst
index ccb2552722f0..6c3034fe5fa2 100644
--- a/Documentation/linux_tv/media/dvb/video-get-navi.rst
+++ b/Documentation/linux_tv/media/dvb/video-get-navi.rst
@@ -15,7 +15,7 @@ VIDEO_GET_NAVI
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = VIDEO_GET_NAVI , video_navi_pack_t *navipack)
+.. cpp:function:: int ioctl(fd, int request = VIDEO_GET_NAVI , video_navi_pack_t *navipack)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/video-get-pts.rst b/Documentation/linux_tv/media/dvb/video-get-pts.rst
index c1ad9576963d..082612243bbb 100644
--- a/Documentation/linux_tv/media/dvb/video-get-pts.rst
+++ b/Documentation/linux_tv/media/dvb/video-get-pts.rst
@@ -15,7 +15,7 @@ VIDEO_GET_PTS
 Synopsis
 --------
 
-.. c:function:: int ioctl(int fd, int request = VIDEO_GET_PTS, __u64 *pts)
+.. cpp:function:: int ioctl(int fd, int request = VIDEO_GET_PTS, __u64 *pts)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/video-get-size.rst b/Documentation/linux_tv/media/dvb/video-get-size.rst
index 70fb266e3ed8..c75e3c47c471 100644
--- a/Documentation/linux_tv/media/dvb/video-get-size.rst
+++ b/Documentation/linux_tv/media/dvb/video-get-size.rst
@@ -15,7 +15,7 @@ VIDEO_GET_SIZE
 Synopsis
 --------
 
-.. c:function:: int ioctl(int fd, int request = VIDEO_GET_SIZE, video_size_t *size)
+.. cpp:function:: int ioctl(int fd, int request = VIDEO_GET_SIZE, video_size_t *size)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/video-get-status.rst b/Documentation/linux_tv/media/dvb/video-get-status.rst
index 5fd5b37942ec..ab9c2236df7e 100644
--- a/Documentation/linux_tv/media/dvb/video-get-status.rst
+++ b/Documentation/linux_tv/media/dvb/video-get-status.rst
@@ -15,7 +15,7 @@ VIDEO_GET_STATUS
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = VIDEO_GET_STATUS, struct video_status *status)
+.. cpp:function:: int ioctl(fd, int request = VIDEO_GET_STATUS, struct video_status *status)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/video-play.rst b/Documentation/linux_tv/media/dvb/video-play.rst
index 103d0ad3341a..943c4b755372 100644
--- a/Documentation/linux_tv/media/dvb/video-play.rst
+++ b/Documentation/linux_tv/media/dvb/video-play.rst
@@ -15,7 +15,7 @@ VIDEO_PLAY
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = VIDEO_PLAY)
+.. cpp:function:: int ioctl(fd, int request = VIDEO_PLAY)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/video-select-source.rst b/Documentation/linux_tv/media/dvb/video-select-source.rst
index f03c544668f5..0ee0d03dbeb2 100644
--- a/Documentation/linux_tv/media/dvb/video-select-source.rst
+++ b/Documentation/linux_tv/media/dvb/video-select-source.rst
@@ -15,7 +15,7 @@ VIDEO_SELECT_SOURCE
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = VIDEO_SELECT_SOURCE, video_stream_source_t source)
+.. cpp:function:: int ioctl(fd, int request = VIDEO_SELECT_SOURCE, video_stream_source_t source)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/video-set-attributes.rst b/Documentation/linux_tv/media/dvb/video-set-attributes.rst
index 9de0d9c7c9ca..326c5c876e80 100644
--- a/Documentation/linux_tv/media/dvb/video-set-attributes.rst
+++ b/Documentation/linux_tv/media/dvb/video-set-attributes.rst
@@ -15,7 +15,7 @@ VIDEO_SET_ATTRIBUTES
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = VIDEO_SET_ATTRIBUTE ,video_attributes_t vattr)
+.. cpp:function:: int ioctl(fd, int request = VIDEO_SET_ATTRIBUTE ,video_attributes_t vattr)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/video-set-blank.rst b/Documentation/linux_tv/media/dvb/video-set-blank.rst
index d8b94c9b56b9..142ea8817380 100644
--- a/Documentation/linux_tv/media/dvb/video-set-blank.rst
+++ b/Documentation/linux_tv/media/dvb/video-set-blank.rst
@@ -15,7 +15,7 @@ VIDEO_SET_BLANK
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = VIDEO_SET_BLANK, boolean mode)
+.. cpp:function:: int ioctl(fd, int request = VIDEO_SET_BLANK, boolean mode)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/video-set-display-format.rst b/Documentation/linux_tv/media/dvb/video-set-display-format.rst
index c1fb7c75b4a8..2061ab064977 100644
--- a/Documentation/linux_tv/media/dvb/video-set-display-format.rst
+++ b/Documentation/linux_tv/media/dvb/video-set-display-format.rst
@@ -15,7 +15,7 @@ VIDEO_SET_DISPLAY_FORMAT
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = VIDEO_SET_DISPLAY_FORMAT, video_display_format_t format)
+.. cpp:function:: int ioctl(fd, int request = VIDEO_SET_DISPLAY_FORMAT, video_display_format_t format)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/video-set-format.rst b/Documentation/linux_tv/media/dvb/video-set-format.rst
index 257a3c2a4627..53d66ec462ca 100644
--- a/Documentation/linux_tv/media/dvb/video-set-format.rst
+++ b/Documentation/linux_tv/media/dvb/video-set-format.rst
@@ -15,7 +15,7 @@ VIDEO_SET_FORMAT
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = VIDEO_SET_FORMAT, video_format_t format)
+.. cpp:function:: int ioctl(fd, int request = VIDEO_SET_FORMAT, video_format_t format)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/video-set-highlight.rst b/Documentation/linux_tv/media/dvb/video-set-highlight.rst
index 6ff11af71355..374f5d895b4d 100644
--- a/Documentation/linux_tv/media/dvb/video-set-highlight.rst
+++ b/Documentation/linux_tv/media/dvb/video-set-highlight.rst
@@ -15,7 +15,7 @@ VIDEO_SET_HIGHLIGHT
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = VIDEO_SET_HIGHLIGHT ,video_highlight_t *vhilite)
+.. cpp:function:: int ioctl(fd, int request = VIDEO_SET_HIGHLIGHT ,video_highlight_t *vhilite)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/video-set-id.rst b/Documentation/linux_tv/media/dvb/video-set-id.rst
index 61993ab354ca..9c002d5399ad 100644
--- a/Documentation/linux_tv/media/dvb/video-set-id.rst
+++ b/Documentation/linux_tv/media/dvb/video-set-id.rst
@@ -15,7 +15,7 @@ VIDEO_SET_ID
 Synopsis
 --------
 
-.. c:function:: int ioctl(int fd, int request = VIDEO_SET_ID, int id)
+.. cpp:function:: int ioctl(int fd, int request = VIDEO_SET_ID, int id)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/video-set-spu-palette.rst b/Documentation/linux_tv/media/dvb/video-set-spu-palette.rst
index ae9e0da5fd0b..4b80b6f56219 100644
--- a/Documentation/linux_tv/media/dvb/video-set-spu-palette.rst
+++ b/Documentation/linux_tv/media/dvb/video-set-spu-palette.rst
@@ -15,7 +15,7 @@ VIDEO_SET_SPU_PALETTE
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = VIDEO_SET_SPU_PALETTE, video_spu_palette_t *palette )
+.. cpp:function:: int ioctl(fd, int request = VIDEO_SET_SPU_PALETTE, video_spu_palette_t *palette )
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/video-set-spu.rst b/Documentation/linux_tv/media/dvb/video-set-spu.rst
index ce2860574f20..a6f6924f10c4 100644
--- a/Documentation/linux_tv/media/dvb/video-set-spu.rst
+++ b/Documentation/linux_tv/media/dvb/video-set-spu.rst
@@ -15,7 +15,7 @@ VIDEO_SET_SPU
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = VIDEO_SET_SPU , video_spu_t *spu)
+.. cpp:function:: int ioctl(fd, int request = VIDEO_SET_SPU , video_spu_t *spu)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/video-set-streamtype.rst b/Documentation/linux_tv/media/dvb/video-set-streamtype.rst
index a2055369f0cd..75b2e7a6e829 100644
--- a/Documentation/linux_tv/media/dvb/video-set-streamtype.rst
+++ b/Documentation/linux_tv/media/dvb/video-set-streamtype.rst
@@ -15,7 +15,7 @@ VIDEO_SET_STREAMTYPE
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = VIDEO_SET_STREAMTYPE, int type)
+.. cpp:function:: int ioctl(fd, int request = VIDEO_SET_STREAMTYPE, int type)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/video-set-system.rst b/Documentation/linux_tv/media/dvb/video-set-system.rst
index f84906a7d1f4..9ae0df1f5813 100644
--- a/Documentation/linux_tv/media/dvb/video-set-system.rst
+++ b/Documentation/linux_tv/media/dvb/video-set-system.rst
@@ -15,7 +15,7 @@ VIDEO_SET_SYSTEM
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = VIDEO_SET_SYSTEM , video_system_t system)
+.. cpp:function:: int ioctl(fd, int request = VIDEO_SET_SYSTEM , video_system_t system)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/video-slowmotion.rst b/Documentation/linux_tv/media/dvb/video-slowmotion.rst
index c8cc85af590b..905712844f6a 100644
--- a/Documentation/linux_tv/media/dvb/video-slowmotion.rst
+++ b/Documentation/linux_tv/media/dvb/video-slowmotion.rst
@@ -15,7 +15,7 @@ VIDEO_SLOWMOTION
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = VIDEO_SLOWMOTION, int nFrames)
+.. cpp:function:: int ioctl(fd, int request = VIDEO_SLOWMOTION, int nFrames)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/video-stillpicture.rst b/Documentation/linux_tv/media/dvb/video-stillpicture.rst
index 053cdbba4ed4..ed3a2f53b998 100644
--- a/Documentation/linux_tv/media/dvb/video-stillpicture.rst
+++ b/Documentation/linux_tv/media/dvb/video-stillpicture.rst
@@ -15,7 +15,7 @@ VIDEO_STILLPICTURE
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = VIDEO_STILLPICTURE, struct video_still_picture *sp)
+.. cpp:function:: int ioctl(fd, int request = VIDEO_STILLPICTURE, struct video_still_picture *sp)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/video-stop.rst b/Documentation/linux_tv/media/dvb/video-stop.rst
index 4e7fbab4b8bc..ad8d59e06004 100644
--- a/Documentation/linux_tv/media/dvb/video-stop.rst
+++ b/Documentation/linux_tv/media/dvb/video-stop.rst
@@ -15,7 +15,7 @@ VIDEO_STOP
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, int request = VIDEO_STOP, boolean mode)
+.. cpp:function:: int ioctl(fd, int request = VIDEO_STOP, boolean mode)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/dvb/video-try-command.rst b/Documentation/linux_tv/media/dvb/video-try-command.rst
index be21fb01bd0f..df96c2d7fc6b 100644
--- a/Documentation/linux_tv/media/dvb/video-try-command.rst
+++ b/Documentation/linux_tv/media/dvb/video-try-command.rst
@@ -15,7 +15,7 @@ VIDEO_TRY_COMMAND
 Synopsis
 --------
 
-.. c:function:: int ioctl(int fd, int request = VIDEO_TRY_COMMAND, struct video_command *cmd)
+.. cpp:function:: int ioctl(int fd, int request = VIDEO_TRY_COMMAND, struct video_command *cmd)
 
 
 Arguments
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-priority.rst b/Documentation/linux_tv/media/v4l/vidioc-g-priority.rst
index 4419195661f1..9f774ce400a4 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-priority.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-priority.rst
@@ -15,9 +15,9 @@ VIDIOC_G_PRIORITY - VIDIOC_S_PRIORITY - Query or request the access priority ass
 Synopsis
 ========
 
-.. c:function:: int ioctl( int fd, int request, enum v4l2_priority *argp )
+.. cpp:function:: int ioctl( int fd, int request, enum v4l2_priority *argp )
 
-.. c:function:: int ioctl( int fd, int request, const enum v4l2_priority *argp )
+.. cpp:function:: int ioctl( int fd, int request, const enum v4l2_priority *argp )
 
 
 Arguments
-- 
2.7.4

