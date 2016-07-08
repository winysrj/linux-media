Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41319 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154AbcGHNEB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 09:04:01 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: corbet@lwn.net, markus.heiser@darmarIT.de,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 09/54] doc-rst: linux_tv: don't use uppercases for syscall sections
Date: Fri,  8 Jul 2016 10:03:01 -0300
Message-Id: <15e7d6158e60a16561a10303d507d6c3fab15c98.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On the syscall conversions, we used uppercase for the sections,
but this is too bold. So, convert them to Camel Case, as it
looks visually better.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../media/dvb/audio-bilingual-channel-select.rst   | 11 +++++-----
 .../linux_tv/media/dvb/audio-channel-select.rst    | 11 +++++-----
 .../linux_tv/media/dvb/audio-clear-buffer.rst      | 11 +++++-----
 .../linux_tv/media/dvb/audio-continue.rst          | 11 +++++-----
 Documentation/linux_tv/media/dvb/audio-fclose.rst  | 11 +++++-----
 Documentation/linux_tv/media/dvb/audio-fopen.rst   | 11 +++++-----
 Documentation/linux_tv/media/dvb/audio-fwrite.rst  | 11 +++++-----
 .../linux_tv/media/dvb/audio-get-capabilities.rst  | 11 +++++-----
 Documentation/linux_tv/media/dvb/audio-get-pts.rst | 11 +++++-----
 .../linux_tv/media/dvb/audio-get-status.rst        | 11 +++++-----
 Documentation/linux_tv/media/dvb/audio-pause.rst   | 11 +++++-----
 Documentation/linux_tv/media/dvb/audio-play.rst    | 11 +++++-----
 .../linux_tv/media/dvb/audio-select-source.rst     | 11 +++++-----
 .../linux_tv/media/dvb/audio-set-attributes.rst    | 11 +++++-----
 .../linux_tv/media/dvb/audio-set-av-sync.rst       | 11 +++++-----
 .../linux_tv/media/dvb/audio-set-bypass-mode.rst   | 11 +++++-----
 .../linux_tv/media/dvb/audio-set-ext-id.rst        | 11 +++++-----
 Documentation/linux_tv/media/dvb/audio-set-id.rst  | 11 +++++-----
 .../linux_tv/media/dvb/audio-set-karaoke.rst       | 11 +++++-----
 .../linux_tv/media/dvb/audio-set-mixer.rst         | 11 +++++-----
 .../linux_tv/media/dvb/audio-set-mute.rst          | 11 +++++-----
 .../linux_tv/media/dvb/audio-set-streamtype.rst    | 11 +++++-----
 Documentation/linux_tv/media/dvb/audio-stop.rst    | 11 +++++-----
 Documentation/linux_tv/media/dvb/ca-fclose.rst     | 11 +++++-----
 Documentation/linux_tv/media/dvb/ca-fopen.rst      | 11 +++++-----
 Documentation/linux_tv/media/dvb/ca-get-cap.rst    | 11 +++++-----
 .../linux_tv/media/dvb/ca-get-descr-info.rst       | 11 +++++-----
 Documentation/linux_tv/media/dvb/ca-get-msg.rst    | 11 +++++-----
 .../linux_tv/media/dvb/ca-get-slot-info.rst        | 11 +++++-----
 Documentation/linux_tv/media/dvb/ca-reset.rst      | 11 +++++-----
 Documentation/linux_tv/media/dvb/ca-send-msg.rst   | 11 +++++-----
 Documentation/linux_tv/media/dvb/ca-set-descr.rst  | 11 +++++-----
 Documentation/linux_tv/media/dvb/ca-set-pid.rst    | 11 +++++-----
 Documentation/linux_tv/media/dvb/dmx-add-pid.rst   | 11 +++++-----
 Documentation/linux_tv/media/dvb/dmx-fclose.rst    | 11 +++++-----
 Documentation/linux_tv/media/dvb/dmx-fopen.rst     | 11 +++++-----
 Documentation/linux_tv/media/dvb/dmx-fread.rst     | 11 +++++-----
 Documentation/linux_tv/media/dvb/dmx-fwrite.rst    | 11 +++++-----
 Documentation/linux_tv/media/dvb/dmx-get-caps.rst  | 11 +++++-----
 Documentation/linux_tv/media/dvb/dmx-get-event.rst | 11 +++++-----
 .../linux_tv/media/dvb/dmx-get-pes-pids.rst        | 11 +++++-----
 Documentation/linux_tv/media/dvb/dmx-get-stc.rst   | 11 +++++-----
 .../linux_tv/media/dvb/dmx-remove-pid.rst          | 11 +++++-----
 .../linux_tv/media/dvb/dmx-set-buffer-size.rst     | 11 +++++-----
 .../linux_tv/media/dvb/dmx-set-filter.rst          | 11 +++++-----
 .../linux_tv/media/dvb/dmx-set-pes-filter.rst      | 11 +++++-----
 .../linux_tv/media/dvb/dmx-set-source.rst          | 11 +++++-----
 Documentation/linux_tv/media/dvb/dmx-start.rst     | 11 +++++-----
 Documentation/linux_tv/media/dvb/dmx-stop.rst      | 11 +++++-----
 .../media/dvb/fe-diseqc-recv-slave-reply.rst       | 12 ++++++-----
 .../media/dvb/fe-diseqc-reset-overload.rst         | 11 +++++-----
 .../linux_tv/media/dvb/fe-diseqc-send-burst.rst    | 12 ++++++-----
 .../media/dvb/fe-diseqc-send-master-cmd.rst        | 11 +++++-----
 .../media/dvb/fe-dishnetwork-send-legacy-cmd.rst   | 11 +++++-----
 .../media/dvb/fe-enable-high-lnb-voltage.rst       | 11 +++++-----
 Documentation/linux_tv/media/dvb/fe-get-event.rst  | 11 +++++-----
 .../linux_tv/media/dvb/fe-get-frontend.rst         | 11 +++++-----
 Documentation/linux_tv/media/dvb/fe-get-info.rst   | 12 ++++++-----
 .../linux_tv/media/dvb/fe-get-property.rst         | 11 +++++-----
 Documentation/linux_tv/media/dvb/fe-read-ber.rst   | 24 ++++++++++++++--------
 .../linux_tv/media/dvb/fe-read-signal-strength.rst | 11 +++++-----
 Documentation/linux_tv/media/dvb/fe-read-snr.rst   | 11 +++++-----
 .../linux_tv/media/dvb/fe-read-status.rst          | 12 ++++++-----
 .../media/dvb/fe-read-uncorrected-blocks.rst       | 11 +++++-----
 .../media/dvb/fe-set-frontend-tune-mode.rst        | 11 +++++-----
 .../linux_tv/media/dvb/fe-set-frontend.rst         | 11 +++++-----
 Documentation/linux_tv/media/dvb/fe-set-tone.rst   | 12 ++++++-----
 .../linux_tv/media/dvb/fe-set-voltage.rst          | 11 +++++-----
 .../linux_tv/media/dvb/frontend_f_close.rst        | 11 +++++-----
 .../linux_tv/media/dvb/frontend_f_open.rst         | 11 +++++-----
 Documentation/linux_tv/media/dvb/net-add-if.rst    | 11 +++++-----
 Documentation/linux_tv/media/dvb/net-get-if.rst    | 11 +++++-----
 Documentation/linux_tv/media/dvb/net-remove-if.rst | 11 +++++-----
 .../linux_tv/media/dvb/video-clear-buffer.rst      | 11 +++++-----
 Documentation/linux_tv/media/dvb/video-command.rst | 11 +++++-----
 .../linux_tv/media/dvb/video-continue.rst          | 11 +++++-----
 .../linux_tv/media/dvb/video-fast-forward.rst      | 11 +++++-----
 Documentation/linux_tv/media/dvb/video-fclose.rst  | 11 +++++-----
 Documentation/linux_tv/media/dvb/video-fopen.rst   | 11 +++++-----
 Documentation/linux_tv/media/dvb/video-freeze.rst  | 11 +++++-----
 Documentation/linux_tv/media/dvb/video-fwrite.rst  | 11 +++++-----
 .../linux_tv/media/dvb/video-get-capabilities.rst  | 11 +++++-----
 .../linux_tv/media/dvb/video-get-event.rst         | 11 +++++-----
 .../linux_tv/media/dvb/video-get-frame-count.rst   | 11 +++++-----
 .../linux_tv/media/dvb/video-get-frame-rate.rst    | 11 +++++-----
 .../linux_tv/media/dvb/video-get-navi.rst          | 11 +++++-----
 Documentation/linux_tv/media/dvb/video-get-pts.rst | 11 +++++-----
 .../linux_tv/media/dvb/video-get-size.rst          | 11 +++++-----
 .../linux_tv/media/dvb/video-get-status.rst        | 11 +++++-----
 Documentation/linux_tv/media/dvb/video-play.rst    | 11 +++++-----
 .../linux_tv/media/dvb/video-select-source.rst     | 11 +++++-----
 .../linux_tv/media/dvb/video-set-attributes.rst    | 11 +++++-----
 .../linux_tv/media/dvb/video-set-blank.rst         | 11 +++++-----
 .../media/dvb/video-set-display-format.rst         | 11 +++++-----
 .../linux_tv/media/dvb/video-set-format.rst        | 11 +++++-----
 .../linux_tv/media/dvb/video-set-highlight.rst     | 11 +++++-----
 Documentation/linux_tv/media/dvb/video-set-id.rst  | 11 +++++-----
 .../linux_tv/media/dvb/video-set-spu-palette.rst   | 11 +++++-----
 Documentation/linux_tv/media/dvb/video-set-spu.rst | 11 +++++-----
 .../linux_tv/media/dvb/video-set-streamtype.rst    | 11 +++++-----
 .../linux_tv/media/dvb/video-set-system.rst        | 11 +++++-----
 .../linux_tv/media/dvb/video-slowmotion.rst        | 11 +++++-----
 .../linux_tv/media/dvb/video-stillpicture.rst      | 11 +++++-----
 Documentation/linux_tv/media/dvb/video-stop.rst    | 11 +++++-----
 .../linux_tv/media/dvb/video-try-command.rst       | 11 +++++-----
 .../linux_tv/media/mediactl/media-func-close.rst   | 11 +++++-----
 .../linux_tv/media/mediactl/media-func-ioctl.rst   | 11 +++++-----
 .../linux_tv/media/mediactl/media-func-open.rst    | 11 +++++-----
 .../media/mediactl/media-ioc-device-info.rst       | 11 +++++-----
 .../media/mediactl/media-ioc-enum-entities.rst     | 11 +++++-----
 .../media/mediactl/media-ioc-enum-links.rst        | 11 +++++-----
 .../media/mediactl/media-ioc-g-topology.rst        | 11 +++++-----
 .../media/mediactl/media-ioc-setup-link.rst        | 11 +++++-----
 Documentation/linux_tv/media/v4l/func-close.rst    | 11 +++++-----
 Documentation/linux_tv/media/v4l/func-ioctl.rst    | 11 +++++-----
 Documentation/linux_tv/media/v4l/func-mmap.rst     | 11 +++++-----
 Documentation/linux_tv/media/v4l/func-munmap.rst   | 11 +++++-----
 Documentation/linux_tv/media/v4l/func-open.rst     | 11 +++++-----
 Documentation/linux_tv/media/v4l/func-poll.rst     | 11 +++++-----
 Documentation/linux_tv/media/v4l/func-read.rst     | 11 +++++-----
 Documentation/linux_tv/media/v4l/func-select.rst   | 11 +++++-----
 Documentation/linux_tv/media/v4l/func-write.rst    | 11 +++++-----
 .../linux_tv/media/v4l/vidioc-create-bufs.rst      | 11 +++++-----
 .../linux_tv/media/v4l/vidioc-cropcap.rst          | 11 +++++-----
 .../linux_tv/media/v4l/vidioc-dbg-g-chip-info.rst  | 11 +++++-----
 .../linux_tv/media/v4l/vidioc-dbg-g-register.rst   | 11 +++++-----
 .../linux_tv/media/v4l/vidioc-decoder-cmd.rst      | 11 +++++-----
 .../linux_tv/media/v4l/vidioc-dqevent.rst          | 11 +++++-----
 .../linux_tv/media/v4l/vidioc-dv-timings-cap.rst   | 11 +++++-----
 .../linux_tv/media/v4l/vidioc-encoder-cmd.rst      | 11 +++++-----
 .../linux_tv/media/v4l/vidioc-enum-dv-timings.rst  | 11 +++++-----
 .../linux_tv/media/v4l/vidioc-enum-fmt.rst         | 11 +++++-----
 .../media/v4l/vidioc-enum-frameintervals.rst       | 11 +++++-----
 .../linux_tv/media/v4l/vidioc-enum-framesizes.rst  | 11 +++++-----
 .../linux_tv/media/v4l/vidioc-enum-freq-bands.rst  | 11 +++++-----
 .../linux_tv/media/v4l/vidioc-enumaudio.rst        | 11 +++++-----
 .../linux_tv/media/v4l/vidioc-enumaudioout.rst     | 11 +++++-----
 .../linux_tv/media/v4l/vidioc-enuminput.rst        | 11 +++++-----
 .../linux_tv/media/v4l/vidioc-enumoutput.rst       | 11 +++++-----
 .../linux_tv/media/v4l/vidioc-enumstd.rst          | 11 +++++-----
 Documentation/linux_tv/media/v4l/vidioc-expbuf.rst | 11 +++++-----
 .../linux_tv/media/v4l/vidioc-g-audio.rst          | 11 +++++-----
 .../linux_tv/media/v4l/vidioc-g-audioout.rst       | 11 +++++-----
 Documentation/linux_tv/media/v4l/vidioc-g-crop.rst | 11 +++++-----
 Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst | 11 +++++-----
 .../linux_tv/media/v4l/vidioc-g-dv-timings.rst     | 11 +++++-----
 Documentation/linux_tv/media/v4l/vidioc-g-edid.rst | 11 +++++-----
 .../linux_tv/media/v4l/vidioc-g-enc-index.rst      | 11 +++++-----
 .../linux_tv/media/v4l/vidioc-g-ext-ctrls.rst      | 11 +++++-----
 Documentation/linux_tv/media/v4l/vidioc-g-fbuf.rst | 11 +++++-----
 Documentation/linux_tv/media/v4l/vidioc-g-fmt.rst  | 11 +++++-----
 .../linux_tv/media/v4l/vidioc-g-frequency.rst      | 11 +++++-----
 .../linux_tv/media/v4l/vidioc-g-input.rst          | 11 +++++-----
 .../linux_tv/media/v4l/vidioc-g-jpegcomp.rst       | 11 +++++-----
 .../linux_tv/media/v4l/vidioc-g-modulator.rst      | 11 +++++-----
 .../linux_tv/media/v4l/vidioc-g-output.rst         | 11 +++++-----
 Documentation/linux_tv/media/v4l/vidioc-g-parm.rst | 11 +++++-----
 .../linux_tv/media/v4l/vidioc-g-priority.rst       | 11 +++++-----
 .../linux_tv/media/v4l/vidioc-g-selection.rst      | 11 +++++-----
 .../linux_tv/media/v4l/vidioc-g-sliced-vbi-cap.rst | 11 +++++-----
 Documentation/linux_tv/media/v4l/vidioc-g-std.rst  | 11 +++++-----
 .../linux_tv/media/v4l/vidioc-g-tuner.rst          | 11 +++++-----
 .../linux_tv/media/v4l/vidioc-log-status.rst       | 11 +++++-----
 .../linux_tv/media/v4l/vidioc-overlay.rst          | 11 +++++-----
 .../linux_tv/media/v4l/vidioc-prepare-buf.rst      | 11 +++++-----
 Documentation/linux_tv/media/v4l/vidioc-qbuf.rst   | 11 +++++-----
 .../linux_tv/media/v4l/vidioc-query-dv-timings.rst | 11 +++++-----
 .../linux_tv/media/v4l/vidioc-querybuf.rst         | 11 +++++-----
 .../linux_tv/media/v4l/vidioc-querycap.rst         | 11 +++++-----
 .../linux_tv/media/v4l/vidioc-queryctrl.rst        | 11 +++++-----
 .../linux_tv/media/v4l/vidioc-querystd.rst         | 11 +++++-----
 .../linux_tv/media/v4l/vidioc-reqbufs.rst          | 11 +++++-----
 .../linux_tv/media/v4l/vidioc-s-hw-freq-seek.rst   | 11 +++++-----
 .../linux_tv/media/v4l/vidioc-streamon.rst         | 11 +++++-----
 .../v4l/vidioc-subdev-enum-frame-interval.rst      | 11 +++++-----
 .../media/v4l/vidioc-subdev-enum-frame-size.rst    | 11 +++++-----
 .../media/v4l/vidioc-subdev-enum-mbus-code.rst     | 11 +++++-----
 .../linux_tv/media/v4l/vidioc-subdev-g-crop.rst    | 11 +++++-----
 .../linux_tv/media/v4l/vidioc-subdev-g-fmt.rst     | 11 +++++-----
 .../media/v4l/vidioc-subdev-g-frame-interval.rst   | 11 +++++-----
 .../media/v4l/vidioc-subdev-g-selection.rst        | 11 +++++-----
 .../linux_tv/media/v4l/vidioc-subscribe-event.rst  | 11 +++++-----
 182 files changed, 1107 insertions(+), 913 deletions(-)

diff --git a/Documentation/linux_tv/media/dvb/audio-bilingual-channel-select.rst b/Documentation/linux_tv/media/dvb/audio-bilingual-channel-select.rst
index dda1695e28a9..841c9759d5e0 100644
--- a/Documentation/linux_tv/media/dvb/audio-bilingual-channel-select.rst
+++ b/Documentation/linux_tv/media/dvb/audio-bilingual-channel-select.rst
@@ -6,18 +6,19 @@
 AUDIO_BILINGUAL_CHANNEL_SELECT
 ==============================
 
-NAME
+Name
 ----
 
 AUDIO_BILINGUAL_CHANNEL_SELECT
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int ioctl(int fd, int request = AUDIO_BILINGUAL_CHANNEL_SELECT, audio_channel_select_t)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -44,7 +45,7 @@ ARGUMENTS
        -  Select the output format of the audio (mono left/right, stereo).
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl is obsolete. Do not use in new drivers. It has been replaced
@@ -55,7 +56,7 @@ This ioctl call asks the Audio Device to select the requested channel
 for bilingual streams if possible.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/audio-channel-select.rst b/Documentation/linux_tv/media/dvb/audio-channel-select.rst
index f7f9766d3902..f2dd79903c49 100644
--- a/Documentation/linux_tv/media/dvb/audio-channel-select.rst
+++ b/Documentation/linux_tv/media/dvb/audio-channel-select.rst
@@ -6,18 +6,19 @@
 AUDIO_CHANNEL_SELECT
 ====================
 
-NAME
+Name
 ----
 
 AUDIO_CHANNEL_SELECT
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int ioctl(int fd, int request = AUDIO_CHANNEL_SELECT, audio_channel_select_t)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -44,7 +45,7 @@ ARGUMENTS
        -  Select the output format of the audio (mono left/right, stereo).
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl is for DVB devices only. To control a V4L2 decoder use the
@@ -54,7 +55,7 @@ This ioctl call asks the Audio Device to select the requested channel if
 possible.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/audio-clear-buffer.rst b/Documentation/linux_tv/media/dvb/audio-clear-buffer.rst
index 97cb3d98f20d..a576c6b160a4 100644
--- a/Documentation/linux_tv/media/dvb/audio-clear-buffer.rst
+++ b/Documentation/linux_tv/media/dvb/audio-clear-buffer.rst
@@ -6,18 +6,19 @@
 AUDIO_CLEAR_BUFFER
 ==================
 
-NAME
+Name
 ----
 
 AUDIO_CLEAR_BUFFER
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int  ioctl(int fd, int request = AUDIO_CLEAR_BUFFER)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -38,14 +39,14 @@ ARGUMENTS
        -  Equals AUDIO_CLEAR_BUFFER for this command.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl call asks the Audio Device to clear all software and hardware
 buffers of the audio decoder device.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/audio-continue.rst b/Documentation/linux_tv/media/dvb/audio-continue.rst
index 1f3d5c35b7ce..b513a39f0935 100644
--- a/Documentation/linux_tv/media/dvb/audio-continue.rst
+++ b/Documentation/linux_tv/media/dvb/audio-continue.rst
@@ -6,18 +6,19 @@
 AUDIO_CONTINUE
 ==============
 
-NAME
+Name
 ----
 
 AUDIO_CONTINUE
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int  ioctl(int fd, int request = AUDIO_CONTINUE)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -38,14 +39,14 @@ ARGUMENTS
        -  Equals AUDIO_CONTINUE for this command.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl restarts the decoding and playing process previously paused
 with AUDIO_PAUSE command.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/audio-fclose.rst b/Documentation/linux_tv/media/dvb/audio-fclose.rst
index 80d9cde4c926..e515fb353a14 100644
--- a/Documentation/linux_tv/media/dvb/audio-fclose.rst
+++ b/Documentation/linux_tv/media/dvb/audio-fclose.rst
@@ -6,18 +6,19 @@
 DVB audio close()
 =================
 
-NAME
+Name
 ----
 
 DVB audio close()
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int  close(int fd)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -32,13 +33,13 @@ ARGUMENTS
        -  File descriptor returned by a previous call to open().
 
 
-DESCRIPTION
+Description
 -----------
 
 This system call closes a previously opened audio device.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 .. flat-table::
diff --git a/Documentation/linux_tv/media/dvb/audio-fopen.rst b/Documentation/linux_tv/media/dvb/audio-fopen.rst
index 6596d6427c1f..46a15950439f 100644
--- a/Documentation/linux_tv/media/dvb/audio-fopen.rst
+++ b/Documentation/linux_tv/media/dvb/audio-fopen.rst
@@ -6,18 +6,19 @@
 DVB audio open()
 ================
 
-NAME
+Name
 ----
 
 DVB audio open()
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int  open(const char *deviceName, int flags)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -58,7 +59,7 @@ ARGUMENTS
        -  (blocking mode is the default)
 
 
-DESCRIPTION
+Description
 -----------
 
 This system call opens a named audio device (e.g.
@@ -76,7 +77,7 @@ in O_RDONLY mode, the only ioctl call that can be used is
 AUDIO_GET_STATUS. All other call will return with an error code.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 .. flat-table::
diff --git a/Documentation/linux_tv/media/dvb/audio-fwrite.rst b/Documentation/linux_tv/media/dvb/audio-fwrite.rst
index 9aa9583a3267..f9307053064f 100644
--- a/Documentation/linux_tv/media/dvb/audio-fwrite.rst
+++ b/Documentation/linux_tv/media/dvb/audio-fwrite.rst
@@ -6,18 +6,19 @@
 DVB audio write()
 =================
 
-NAME
+Name
 ----
 
 DVB audio write()
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: size_t write(int fd, const void *buf, size_t count)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -44,7 +45,7 @@ ARGUMENTS
        -  Size of buf.
 
 
-DESCRIPTION
+Description
 -----------
 
 This system call can only be used if AUDIO_SOURCE_MEMORY is selected
@@ -54,7 +55,7 @@ until buffer space is available. The amount of data to be transferred is
 implied by count.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 .. flat-table::
diff --git a/Documentation/linux_tv/media/dvb/audio-get-capabilities.rst b/Documentation/linux_tv/media/dvb/audio-get-capabilities.rst
index 32e55bbc4d03..8b6fdc664f9d 100644
--- a/Documentation/linux_tv/media/dvb/audio-get-capabilities.rst
+++ b/Documentation/linux_tv/media/dvb/audio-get-capabilities.rst
@@ -6,18 +6,19 @@
 AUDIO_GET_CAPABILITIES
 ======================
 
-NAME
+Name
 ----
 
 AUDIO_GET_CAPABILITIES
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int ioctl(int fd, int request = AUDIO_GET_CAPABILITIES, unsigned int *cap)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -44,14 +45,14 @@ ARGUMENTS
        -  Returns a bit array of supported sound formats.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl call asks the Audio Device to tell us about the decoding
 capabilities of the audio hardware.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/audio-get-pts.rst b/Documentation/linux_tv/media/dvb/audio-get-pts.rst
index a8e2ef5a107d..246c78c003de 100644
--- a/Documentation/linux_tv/media/dvb/audio-get-pts.rst
+++ b/Documentation/linux_tv/media/dvb/audio-get-pts.rst
@@ -6,18 +6,19 @@
 AUDIO_GET_PTS
 =============
 
-NAME
+Name
 ----
 
 AUDIO_GET_PTS
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int ioctl(int fd, int request = AUDIO_GET_PTS, __u64 *pts)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -49,7 +50,7 @@ ARGUMENTS
 	  decoded frame or the last PTS extracted by the PES parser.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl is obsolete. Do not use in new drivers. If you need this
@@ -60,7 +61,7 @@ This ioctl call asks the Audio Device to return the current PTS
 timestamp.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/audio-get-status.rst b/Documentation/linux_tv/media/dvb/audio-get-status.rst
index b9a2850b577a..b0a550af87b3 100644
--- a/Documentation/linux_tv/media/dvb/audio-get-status.rst
+++ b/Documentation/linux_tv/media/dvb/audio-get-status.rst
@@ -6,18 +6,19 @@
 AUDIO_GET_STATUS
 ================
 
-NAME
+Name
 ----
 
 AUDIO_GET_STATUS
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int ioctl(int fd, int request = AUDIO_GET_STATUS, struct audio_status *status)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -44,14 +45,14 @@ ARGUMENTS
        -  Returns the current state of Audio Device.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl call asks the Audio Device to return the current state of the
 Audio Device.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/audio-pause.rst b/Documentation/linux_tv/media/dvb/audio-pause.rst
index 8b1517b54272..86652c3bca06 100644
--- a/Documentation/linux_tv/media/dvb/audio-pause.rst
+++ b/Documentation/linux_tv/media/dvb/audio-pause.rst
@@ -6,18 +6,19 @@
 AUDIO_PAUSE
 ===========
 
-NAME
+Name
 ----
 
 AUDIO_PAUSE
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int  ioctl(int fd, int request = AUDIO_PAUSE)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -38,7 +39,7 @@ ARGUMENTS
        -  Equals AUDIO_PAUSE for this command.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl call suspends the audio stream being played. Decoding and
@@ -46,7 +47,7 @@ playing are paused. It is then possible to restart again decoding and
 playing process of the audio stream using AUDIO_CONTINUE command.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/audio-play.rst b/Documentation/linux_tv/media/dvb/audio-play.rst
index 22bd35007b25..1af708375821 100644
--- a/Documentation/linux_tv/media/dvb/audio-play.rst
+++ b/Documentation/linux_tv/media/dvb/audio-play.rst
@@ -6,18 +6,19 @@
 AUDIO_PLAY
 ==========
 
-NAME
+Name
 ----
 
 AUDIO_PLAY
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int  ioctl(int fd, int request = AUDIO_PLAY)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -38,14 +39,14 @@ ARGUMENTS
        -  Equals AUDIO_PLAY for this command.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl call asks the Audio Device to start playing an audio stream
 from the selected source.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/audio-select-source.rst b/Documentation/linux_tv/media/dvb/audio-select-source.rst
index 2242e6f0b6ad..3e873d9cb345 100644
--- a/Documentation/linux_tv/media/dvb/audio-select-source.rst
+++ b/Documentation/linux_tv/media/dvb/audio-select-source.rst
@@ -6,18 +6,19 @@
 AUDIO_SELECT_SOURCE
 ===================
 
-NAME
+Name
 ----
 
 AUDIO_SELECT_SOURCE
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int ioctl(int fd, int request = AUDIO_SELECT_SOURCE, audio_stream_source_t source)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -44,7 +45,7 @@ ARGUMENTS
        -  Indicates the source that shall be used for the Audio stream.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl call informs the audio device which source shall be used for
@@ -53,7 +54,7 @@ AUDIO_SOURCE_MEMORY is selected, the data is fed to the Audio Device
 through the write command.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/audio-set-attributes.rst b/Documentation/linux_tv/media/dvb/audio-set-attributes.rst
index 820c8b2e2298..43ff50279742 100644
--- a/Documentation/linux_tv/media/dvb/audio-set-attributes.rst
+++ b/Documentation/linux_tv/media/dvb/audio-set-attributes.rst
@@ -6,18 +6,19 @@
 AUDIO_SET_ATTRIBUTES
 ====================
 
-NAME
+Name
 ----
 
 AUDIO_SET_ATTRIBUTES
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int ioctl(fd, int request = AUDIO_SET_ATTRIBUTES, audio_attributes_t attr )
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -44,14 +45,14 @@ ARGUMENTS
        -  audio attributes according to section ??
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl is intended for DVD playback and allows you to set certain
 information about the audio stream.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/audio-set-av-sync.rst b/Documentation/linux_tv/media/dvb/audio-set-av-sync.rst
index 3f5ac9a87bc8..4ecfb75d28f1 100644
--- a/Documentation/linux_tv/media/dvb/audio-set-av-sync.rst
+++ b/Documentation/linux_tv/media/dvb/audio-set-av-sync.rst
@@ -6,18 +6,19 @@
 AUDIO_SET_AV_SYNC
 =================
 
-NAME
+Name
 ----
 
 AUDIO_SET_AV_SYNC
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int  ioctl(int fd, int request = AUDIO_SET_AV_SYNC, boolean state)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -54,14 +55,14 @@ ARGUMENTS
        -  FALSE AV-sync OFF
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl call asks the Audio Device to turn ON or OFF A/V
 synchronization.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/audio-set-bypass-mode.rst b/Documentation/linux_tv/media/dvb/audio-set-bypass-mode.rst
index 9377342c646d..b21d142ec31c 100644
--- a/Documentation/linux_tv/media/dvb/audio-set-bypass-mode.rst
+++ b/Documentation/linux_tv/media/dvb/audio-set-bypass-mode.rst
@@ -6,18 +6,19 @@
 AUDIO_SET_BYPASS_MODE
 =====================
 
-NAME
+Name
 ----
 
 AUDIO_SET_BYPASS_MODE
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int ioctl(int fd, int request = AUDIO_SET_BYPASS_MODE, boolean mode)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -55,7 +56,7 @@ ARGUMENTS
        -  FALSE Bypass is enabled
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl call asks the Audio Device to bypass the Audio decoder and
@@ -65,7 +66,7 @@ DigitalTM streams are automatically forwarded by the DVB subsystem if
 the hardware can handle it.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/audio-set-ext-id.rst b/Documentation/linux_tv/media/dvb/audio-set-ext-id.rst
index 38a255289e8c..1b5b8893a00b 100644
--- a/Documentation/linux_tv/media/dvb/audio-set-ext-id.rst
+++ b/Documentation/linux_tv/media/dvb/audio-set-ext-id.rst
@@ -6,18 +6,19 @@
 AUDIO_SET_EXT_ID
 ================
 
-NAME
+Name
 ----
 
 AUDIO_SET_EXT_ID
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int  ioctl(fd, int request = AUDIO_SET_EXT_ID, int id)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -44,14 +45,14 @@ ARGUMENTS
        -  audio sub_stream_id
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl can be used to set the extension id for MPEG streams in DVD
 playback. Only the first 3 bits are recognized.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/audio-set-id.rst b/Documentation/linux_tv/media/dvb/audio-set-id.rst
index 60eeee07d244..fed99eae52cb 100644
--- a/Documentation/linux_tv/media/dvb/audio-set-id.rst
+++ b/Documentation/linux_tv/media/dvb/audio-set-id.rst
@@ -6,18 +6,19 @@
 AUDIO_SET_ID
 ============
 
-NAME
+Name
 ----
 
 AUDIO_SET_ID
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int  ioctl(int fd, int request = AUDIO_SET_ID, int id)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -44,7 +45,7 @@ ARGUMENTS
        -  audio sub-stream id
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl selects which sub-stream is to be decoded if a program or
@@ -56,7 +57,7 @@ substream id of the audio stream and only the first 5 bits are
 recognized.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/audio-set-karaoke.rst b/Documentation/linux_tv/media/dvb/audio-set-karaoke.rst
index 28138222582a..ebb2d41bbec3 100644
--- a/Documentation/linux_tv/media/dvb/audio-set-karaoke.rst
+++ b/Documentation/linux_tv/media/dvb/audio-set-karaoke.rst
@@ -6,18 +6,19 @@
 AUDIO_SET_KARAOKE
 =================
 
-NAME
+Name
 ----
 
 AUDIO_SET_KARAOKE
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int ioctl(fd, int request = AUDIO_SET_KARAOKE, audio_karaoke_t *karaoke)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -44,13 +45,13 @@ ARGUMENTS
        -  karaoke settings according to section ??.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl allows one to set the mixer settings for a karaoke DVD.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/audio-set-mixer.rst b/Documentation/linux_tv/media/dvb/audio-set-mixer.rst
index 8d5a6f375419..ce4b2a63917e 100644
--- a/Documentation/linux_tv/media/dvb/audio-set-mixer.rst
+++ b/Documentation/linux_tv/media/dvb/audio-set-mixer.rst
@@ -6,18 +6,19 @@
 AUDIO_SET_MIXER
 ===============
 
-NAME
+Name
 ----
 
 AUDIO_SET_MIXER
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int ioctl(int fd, int request = AUDIO_SET_MIXER, audio_mixer_t *mix)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -44,13 +45,13 @@ ARGUMENTS
        -  mixer settings.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl lets you adjust the mixer settings of the audio decoder.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/audio-set-mute.rst b/Documentation/linux_tv/media/dvb/audio-set-mute.rst
index a002d0d7128d..a2469267508b 100644
--- a/Documentation/linux_tv/media/dvb/audio-set-mute.rst
+++ b/Documentation/linux_tv/media/dvb/audio-set-mute.rst
@@ -6,18 +6,19 @@
 AUDIO_SET_MUTE
 ==============
 
-NAME
+Name
 ----
 
 AUDIO_SET_MUTE
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int  ioctl(int fd, int request = AUDIO_SET_MUTE, boolean state)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -54,7 +55,7 @@ ARGUMENTS
        -  FALSE Audio Un-mute
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl is for DVB devices only. To control a V4L2 decoder use the
@@ -65,7 +66,7 @@ This ioctl call asks the audio device to mute the stream that is
 currently being played.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/audio-set-streamtype.rst b/Documentation/linux_tv/media/dvb/audio-set-streamtype.rst
index a971d43e01cc..4b13c9b9dffe 100644
--- a/Documentation/linux_tv/media/dvb/audio-set-streamtype.rst
+++ b/Documentation/linux_tv/media/dvb/audio-set-streamtype.rst
@@ -6,18 +6,19 @@
 AUDIO_SET_STREAMTYPE
 ====================
 
-NAME
+Name
 ----
 
 AUDIO_SET_STREAMTYPE
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int  ioctl(fd, int request = AUDIO_SET_STREAMTYPE, int type)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -44,7 +45,7 @@ ARGUMENTS
        -  stream type
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl tells the driver which kind of audio stream to expect. This
@@ -52,7 +53,7 @@ is useful if the stream offers several audio sub-streams like LPCM and
 AC3.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/audio-stop.rst b/Documentation/linux_tv/media/dvb/audio-stop.rst
index 558ff2b1effb..d9430978096f 100644
--- a/Documentation/linux_tv/media/dvb/audio-stop.rst
+++ b/Documentation/linux_tv/media/dvb/audio-stop.rst
@@ -6,18 +6,19 @@
 AUDIO_STOP
 ==========
 
-NAME
+Name
 ----
 
 AUDIO_STOP
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int ioctl(int fd, int request = AUDIO_STOP)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -38,14 +39,14 @@ ARGUMENTS
        -  Equals AUDIO_STOP for this command.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl call asks the Audio Device to stop playing the current
 stream.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/ca-fclose.rst b/Documentation/linux_tv/media/dvb/ca-fclose.rst
index a093e8dd3182..16d7a1e76193 100644
--- a/Documentation/linux_tv/media/dvb/ca-fclose.rst
+++ b/Documentation/linux_tv/media/dvb/ca-fclose.rst
@@ -6,18 +6,19 @@
 DVB CA close()
 ==============
 
-NAME
+Name
 ----
 
 DVB CA close()
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. cpp:function:: int  close(int fd)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -32,13 +33,13 @@ ARGUMENTS
        -  File descriptor returned by a previous call to open().
 
 
-DESCRIPTION
+Description
 -----------
 
 This system call closes a previously opened audio device.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 .. flat-table::
diff --git a/Documentation/linux_tv/media/dvb/ca-fopen.rst b/Documentation/linux_tv/media/dvb/ca-fopen.rst
index a9bf45a921e9..f284461cce20 100644
--- a/Documentation/linux_tv/media/dvb/ca-fopen.rst
+++ b/Documentation/linux_tv/media/dvb/ca-fopen.rst
@@ -6,18 +6,19 @@
 DVB CA open()
 =============
 
-NAME
+Name
 ----
 
 DVB CA open()
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. cpp:function:: int  open(const char *deviceName, int flags)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -58,7 +59,7 @@ ARGUMENTS
        -  (blocking mode is the default)
 
 
-DESCRIPTION
+Description
 -----------
 
 This system call opens a named ca device (e.g. /dev/ost/ca) for
@@ -75,7 +76,7 @@ user can open the CA Device in O_RDWR mode. All other attempts to open
 the device in this mode will fail, and an error code will be returned.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 .. flat-table::
diff --git a/Documentation/linux_tv/media/dvb/ca-get-cap.rst b/Documentation/linux_tv/media/dvb/ca-get-cap.rst
index b026d4769730..891fbf2d9a84 100644
--- a/Documentation/linux_tv/media/dvb/ca-get-cap.rst
+++ b/Documentation/linux_tv/media/dvb/ca-get-cap.rst
@@ -6,18 +6,19 @@
 CA_GET_CAP
 ==========
 
-NAME
+Name
 ----
 
 CA_GET_CAP
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. cpp:function:: int  ioctl(fd, int request = CA_GET_CAP, ca_caps_t *)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -44,13 +45,13 @@ ARGUMENTS
        -  Undocumented.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl is undocumented. Documentation is welcome.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/ca-get-descr-info.rst b/Documentation/linux_tv/media/dvb/ca-get-descr-info.rst
index 446afe89af82..cf8e8242db66 100644
--- a/Documentation/linux_tv/media/dvb/ca-get-descr-info.rst
+++ b/Documentation/linux_tv/media/dvb/ca-get-descr-info.rst
@@ -6,18 +6,19 @@
 CA_GET_DESCR_INFO
 =================
 
-NAME
+Name
 ----
 
 CA_GET_DESCR_INFO
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. cpp:function:: int  ioctl(fd, int request = CA_GET_DESCR_INFO, ca_descr_info_t *)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -44,13 +45,13 @@ ARGUMENTS
        -  Undocumented.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl is undocumented. Documentation is welcome.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/ca-get-msg.rst b/Documentation/linux_tv/media/dvb/ca-get-msg.rst
index 44c944a700c0..56004d5ea3ab 100644
--- a/Documentation/linux_tv/media/dvb/ca-get-msg.rst
+++ b/Documentation/linux_tv/media/dvb/ca-get-msg.rst
@@ -6,18 +6,19 @@
 CA_GET_MSG
 ==========
 
-NAME
+Name
 ----
 
 CA_GET_MSG
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. cpp:function:: int  ioctl(fd, int request = CA_GET_MSG, ca_msg_t *)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -44,13 +45,13 @@ ARGUMENTS
        -  Undocumented.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl is undocumented. Documentation is welcome.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/ca-get-slot-info.rst b/Documentation/linux_tv/media/dvb/ca-get-slot-info.rst
index e1e580341dad..9fea28ccad0f 100644
--- a/Documentation/linux_tv/media/dvb/ca-get-slot-info.rst
+++ b/Documentation/linux_tv/media/dvb/ca-get-slot-info.rst
@@ -6,18 +6,19 @@
 CA_GET_SLOT_INFO
 ================
 
-NAME
+Name
 ----
 
 CA_GET_SLOT_INFO
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. cpp:function:: int  ioctl(fd, int request = CA_GET_SLOT_INFO, ca_slot_info_t *)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -44,13 +45,13 @@ ARGUMENTS
        -  Undocumented.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl is undocumented. Documentation is welcome.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/ca-reset.rst b/Documentation/linux_tv/media/dvb/ca-reset.rst
index ff58c62fb0a5..d5a50088fc2d 100644
--- a/Documentation/linux_tv/media/dvb/ca-reset.rst
+++ b/Documentation/linux_tv/media/dvb/ca-reset.rst
@@ -6,18 +6,19 @@
 CA_RESET
 ========
 
-NAME
+Name
 ----
 
 CA_RESET
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. cpp:function:: int  ioctl(fd, int request = CA_RESET)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -38,13 +39,13 @@ ARGUMENTS
        -  Equals CA_RESET for this command.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl is undocumented. Documentation is welcome.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/ca-send-msg.rst b/Documentation/linux_tv/media/dvb/ca-send-msg.rst
index 9d9b8d2520c1..18974e61e788 100644
--- a/Documentation/linux_tv/media/dvb/ca-send-msg.rst
+++ b/Documentation/linux_tv/media/dvb/ca-send-msg.rst
@@ -6,18 +6,19 @@
 CA_SEND_MSG
 ===========
 
-NAME
+Name
 ----
 
 CA_SEND_MSG
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. cpp:function:: int  ioctl(fd, int request = CA_SEND_MSG, ca_msg_t *)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -44,13 +45,13 @@ ARGUMENTS
        -  Undocumented.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl is undocumented. Documentation is welcome.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/ca-set-descr.rst b/Documentation/linux_tv/media/dvb/ca-set-descr.rst
index e992dd52432d..293e6da5059f 100644
--- a/Documentation/linux_tv/media/dvb/ca-set-descr.rst
+++ b/Documentation/linux_tv/media/dvb/ca-set-descr.rst
@@ -6,18 +6,19 @@
 CA_SET_DESCR
 ============
 
-NAME
+Name
 ----
 
 CA_SET_DESCR
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. cpp:function:: int  ioctl(fd, int request = CA_SET_DESCR, ca_descr_t *)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -44,13 +45,13 @@ ARGUMENTS
        -  Undocumented.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl is undocumented. Documentation is welcome.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/ca-set-pid.rst b/Documentation/linux_tv/media/dvb/ca-set-pid.rst
index e7e3891fa65e..5afa2fae3206 100644
--- a/Documentation/linux_tv/media/dvb/ca-set-pid.rst
+++ b/Documentation/linux_tv/media/dvb/ca-set-pid.rst
@@ -6,18 +6,19 @@
 CA_SET_PID
 ==========
 
-NAME
+Name
 ----
 
 CA_SET_PID
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. cpp:function:: int  ioctl(fd, int request = CA_SET_PID, ca_pid_t *)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -44,13 +45,13 @@ ARGUMENTS
        -  Undocumented.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl is undocumented. Documentation is welcome.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/dmx-add-pid.rst b/Documentation/linux_tv/media/dvb/dmx-add-pid.rst
index 36bca4f9317c..37f5ee43d523 100644
--- a/Documentation/linux_tv/media/dvb/dmx-add-pid.rst
+++ b/Documentation/linux_tv/media/dvb/dmx-add-pid.rst
@@ -6,18 +6,19 @@
 DMX_ADD_PID
 ===========
 
-NAME
+Name
 ----
 
 DMX_ADD_PID
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int ioctl(fd, int request = DMX_ADD_PID, __u16 *)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -44,7 +45,7 @@ ARGUMENTS
        -  PID number to be filtered.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl call allows to add multiple PIDs to a transport stream filter
@@ -52,7 +53,7 @@ previously set up with DMX_SET_PES_FILTER and output equal to
 DMX_OUT_TSDEMUX_TAP.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/dmx-fclose.rst b/Documentation/linux_tv/media/dvb/dmx-fclose.rst
index 7889d0b76f7d..e442881481a2 100644
--- a/Documentation/linux_tv/media/dvb/dmx-fclose.rst
+++ b/Documentation/linux_tv/media/dvb/dmx-fclose.rst
@@ -6,18 +6,19 @@
 DVB demux close()
 =================
 
-NAME
+Name
 ----
 
 DVB demux close()
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int close(int fd)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -32,14 +33,14 @@ ARGUMENTS
        -  File descriptor returned by a previous call to open().
 
 
-DESCRIPTION
+Description
 -----------
 
 This system call deactivates and deallocates a filter that was
 previously allocated via the open() call.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 .. flat-table::
diff --git a/Documentation/linux_tv/media/dvb/dmx-fopen.rst b/Documentation/linux_tv/media/dvb/dmx-fopen.rst
index 1e1dbc57c64d..7e640fa860c3 100644
--- a/Documentation/linux_tv/media/dvb/dmx-fopen.rst
+++ b/Documentation/linux_tv/media/dvb/dmx-fopen.rst
@@ -6,18 +6,19 @@
 DVB demux open()
 ================
 
-NAME
+Name
 ----
 
 DVB demux open()
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int open(const char *deviceName, int flags)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -53,7 +54,7 @@ ARGUMENTS
        -  (blocking mode is the default)
 
 
-DESCRIPTION
+Description
 -----------
 
 This system call, used with a device name of /dev/dvb/adapter0/demux0,
@@ -74,7 +75,7 @@ blocking mode can later be put into non-blocking mode (and vice versa)
 using the F_SETFL command of the fcntl system call.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 .. flat-table::
diff --git a/Documentation/linux_tv/media/dvb/dmx-fread.rst b/Documentation/linux_tv/media/dvb/dmx-fread.rst
index 55d9bc7f424d..92f7a0632766 100644
--- a/Documentation/linux_tv/media/dvb/dmx-fread.rst
+++ b/Documentation/linux_tv/media/dvb/dmx-fread.rst
@@ -6,18 +6,19 @@
 DVB demux read()
 ================
 
-NAME
+Name
 ----
 
 DVB demux read()
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: size_t read(int fd, void *buf, size_t count)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -44,7 +45,7 @@ ARGUMENTS
        -  Size of buf.
 
 
-DESCRIPTION
+Description
 -----------
 
 This system call returns filtered data, which might be section or PES
@@ -53,7 +54,7 @@ circular buffer to buf. The maximum amount of data to be transferred is
 implied by count.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 .. flat-table::
diff --git a/Documentation/linux_tv/media/dvb/dmx-fwrite.rst b/Documentation/linux_tv/media/dvb/dmx-fwrite.rst
index f39743684966..8d2632205c29 100644
--- a/Documentation/linux_tv/media/dvb/dmx-fwrite.rst
+++ b/Documentation/linux_tv/media/dvb/dmx-fwrite.rst
@@ -6,18 +6,19 @@
 DVB demux write()
 =================
 
-NAME
+Name
 ----
 
 DVB demux write()
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: ssize_t write(int fd, const void *buf, size_t count)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -44,7 +45,7 @@ ARGUMENTS
        -  Size of buf.
 
 
-DESCRIPTION
+Description
 -----------
 
 This system call is only provided by the logical device
@@ -55,7 +56,7 @@ in the corresponding physical demux device, /dev/dvb/adapter0/demux0.
 The amount of data to be transferred is implied by count.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 .. flat-table::
diff --git a/Documentation/linux_tv/media/dvb/dmx-get-caps.rst b/Documentation/linux_tv/media/dvb/dmx-get-caps.rst
index 8c8ae48a93da..20e3d6e55d30 100644
--- a/Documentation/linux_tv/media/dvb/dmx-get-caps.rst
+++ b/Documentation/linux_tv/media/dvb/dmx-get-caps.rst
@@ -6,18 +6,19 @@
 DMX_GET_CAPS
 ============
 
-NAME
+Name
 ----
 
 DMX_GET_CAPS
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int ioctl(fd, int request = DMX_GET_CAPS, dmx_caps_t *)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -44,13 +45,13 @@ ARGUMENTS
        -  Undocumented.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl is undocumented. Documentation is welcome.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/dmx-get-event.rst b/Documentation/linux_tv/media/dvb/dmx-get-event.rst
index ab2ab2ed3bed..81a7c7fedd47 100644
--- a/Documentation/linux_tv/media/dvb/dmx-get-event.rst
+++ b/Documentation/linux_tv/media/dvb/dmx-get-event.rst
@@ -6,18 +6,19 @@
 DMX_GET_EVENT
 =============
 
-NAME
+Name
 ----
 
 DMX_GET_EVENT
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int ioctl( int fd, int request = DMX_GET_EVENT, struct dmx_event *ev)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -44,7 +45,7 @@ ARGUMENTS
        -  Pointer to the location where the event is to be stored.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl call returns an event if available. If an event is not
@@ -54,7 +55,7 @@ errno set to ``EWOULDBLOCK``. In the former case, the call blocks until an
 event becomes available.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/dmx-get-pes-pids.rst b/Documentation/linux_tv/media/dvb/dmx-get-pes-pids.rst
index cf0d8a6463fb..8b1fbf5d2c81 100644
--- a/Documentation/linux_tv/media/dvb/dmx-get-pes-pids.rst
+++ b/Documentation/linux_tv/media/dvb/dmx-get-pes-pids.rst
@@ -6,18 +6,19 @@
 DMX_GET_PES_PIDS
 ================
 
-NAME
+Name
 ----
 
 DMX_GET_PES_PIDS
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int ioctl(fd, int request = DMX_GET_PES_PIDS, __u16[5])
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -44,13 +45,13 @@ ARGUMENTS
        -  Undocumented.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl is undocumented. Documentation is welcome.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/dmx-get-stc.rst b/Documentation/linux_tv/media/dvb/dmx-get-stc.rst
index 35dd691dee09..616c745a0418 100644
--- a/Documentation/linux_tv/media/dvb/dmx-get-stc.rst
+++ b/Documentation/linux_tv/media/dvb/dmx-get-stc.rst
@@ -6,18 +6,19 @@
 DMX_GET_STC
 ===========
 
-NAME
+Name
 ----
 
 DMX_GET_STC
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int ioctl( int fd, int request = DMX_GET_STC, struct dmx_stc *stc)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -44,7 +45,7 @@ ARGUMENTS
        -  Pointer to the location where the stc is to be stored.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl call returns the current value of the system time counter
@@ -55,7 +56,7 @@ in form of a ratio with a 64 bit numerator and a 32 bit denominator, so
 the real 90kHz STC value is stc->stc / stc->base .
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/dmx-remove-pid.rst b/Documentation/linux_tv/media/dvb/dmx-remove-pid.rst
index 859e1a14de54..ed1a49ce9fc2 100644
--- a/Documentation/linux_tv/media/dvb/dmx-remove-pid.rst
+++ b/Documentation/linux_tv/media/dvb/dmx-remove-pid.rst
@@ -6,18 +6,19 @@
 DMX_REMOVE_PID
 ==============
 
-NAME
+Name
 ----
 
 DMX_REMOVE_PID
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int ioctl(fd, int request = DMX_REMOVE_PID, __u16 *)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -44,7 +45,7 @@ ARGUMENTS
        -  PID of the PES filter to be removed.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl call allows to remove a PID when multiple PIDs are set on a
@@ -53,7 +54,7 @@ equal to DMX_OUT_TSDEMUX_TAP, created via either
 DMX_SET_PES_FILTER or DMX_ADD_PID.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/dmx-set-buffer-size.rst b/Documentation/linux_tv/media/dvb/dmx-set-buffer-size.rst
index cf6b32f4e361..012b9e9792be 100644
--- a/Documentation/linux_tv/media/dvb/dmx-set-buffer-size.rst
+++ b/Documentation/linux_tv/media/dvb/dmx-set-buffer-size.rst
@@ -6,18 +6,19 @@
 DMX_SET_BUFFER_SIZE
 ===================
 
-NAME
+Name
 ----
 
 DMX_SET_BUFFER_SIZE
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int ioctl( int fd, int request = DMX_SET_BUFFER_SIZE, unsigned long size)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -44,7 +45,7 @@ ARGUMENTS
        -  Size of circular buffer.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl call is used to set the size of the circular buffer used for
@@ -53,7 +54,7 @@ this function is not called a buffer size of 2 \* 4096 bytes will be
 used.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/dmx-set-filter.rst b/Documentation/linux_tv/media/dvb/dmx-set-filter.rst
index 0aad102f3151..d079d8b39597 100644
--- a/Documentation/linux_tv/media/dvb/dmx-set-filter.rst
+++ b/Documentation/linux_tv/media/dvb/dmx-set-filter.rst
@@ -6,18 +6,19 @@
 DMX_SET_FILTER
 ==============
 
-NAME
+Name
 ----
 
 DMX_SET_FILTER
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int ioctl( int fd, int request = DMX_SET_FILTER, struct dmx_sct_filter_params *params)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -44,7 +45,7 @@ ARGUMENTS
        -  Pointer to structure containing filter parameters.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl call sets up a filter according to the filter and mask
@@ -59,7 +60,7 @@ DMX_START ioctl call). If a filter was previously set-up, this filter
 will be canceled, and the receive buffer will be flushed.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/dmx-set-pes-filter.rst b/Documentation/linux_tv/media/dvb/dmx-set-pes-filter.rst
index 3dccd7cd0a64..910869ebdefd 100644
--- a/Documentation/linux_tv/media/dvb/dmx-set-pes-filter.rst
+++ b/Documentation/linux_tv/media/dvb/dmx-set-pes-filter.rst
@@ -6,18 +6,19 @@
 DMX_SET_PES_FILTER
 ==================
 
-NAME
+Name
 ----
 
 DMX_SET_PES_FILTER
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int ioctl( int fd, int request = DMX_SET_PES_FILTER, struct dmx_pes_filter_params *params)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -44,7 +45,7 @@ ARGUMENTS
        -  Pointer to structure containing filter parameters.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl call sets up a PES filter according to the parameters
@@ -53,7 +54,7 @@ packet identifier (PID), i.e. no PES header or payload filtering
 capability is supported.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/dmx-set-source.rst b/Documentation/linux_tv/media/dvb/dmx-set-source.rst
index 13045327857f..7aa4dfe3cdc5 100644
--- a/Documentation/linux_tv/media/dvb/dmx-set-source.rst
+++ b/Documentation/linux_tv/media/dvb/dmx-set-source.rst
@@ -6,18 +6,19 @@
 DMX_SET_SOURCE
 ==============
 
-NAME
+Name
 ----
 
 DMX_SET_SOURCE
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int ioctl(fd, int request = DMX_SET_SOURCE, dmx_source_t *)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -44,13 +45,13 @@ ARGUMENTS
        -  Undocumented.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl is undocumented. Documentation is welcome.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/dmx-start.rst b/Documentation/linux_tv/media/dvb/dmx-start.rst
index c62e2ad17a6a..cc316d00343d 100644
--- a/Documentation/linux_tv/media/dvb/dmx-start.rst
+++ b/Documentation/linux_tv/media/dvb/dmx-start.rst
@@ -6,18 +6,19 @@
 DMX_START
 =========
 
-NAME
+Name
 ----
 
 DMX_START
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int ioctl( int fd, int request = DMX_START)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -38,14 +39,14 @@ ARGUMENTS
        -  Equals DMX_START for this command.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl call is used to start the actual filtering operation defined
 via the ioctl calls DMX_SET_FILTER or DMX_SET_PES_FILTER.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/dmx-stop.rst b/Documentation/linux_tv/media/dvb/dmx-stop.rst
index ff9df400f71f..f9157dd6a8fe 100644
--- a/Documentation/linux_tv/media/dvb/dmx-stop.rst
+++ b/Documentation/linux_tv/media/dvb/dmx-stop.rst
@@ -6,18 +6,19 @@
 DMX_STOP
 ========
 
-NAME
+Name
 ----
 
 DMX_STOP
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int ioctl( int fd, int request = DMX_STOP)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -38,7 +39,7 @@ ARGUMENTS
        -  Equals DMX_STOP for this command.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl call is used to stop the actual filtering operation defined
@@ -46,7 +47,7 @@ via the ioctl calls DMX_SET_FILTER or DMX_SET_PES_FILTER and
 started via the DMX_START command.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/fe-diseqc-recv-slave-reply.rst b/Documentation/linux_tv/media/dvb/fe-diseqc-recv-slave-reply.rst
index 7ddbce6bcd7e..7bd02ac7bff4 100644
--- a/Documentation/linux_tv/media/dvb/fe-diseqc-recv-slave-reply.rst
+++ b/Documentation/linux_tv/media/dvb/fe-diseqc-recv-slave-reply.rst
@@ -6,18 +6,19 @@
 ioctl FE_DISEQC_RECV_SLAVE_REPLY
 ********************************
 
-NAME
+Name
 ====
 
 FE_DISEQC_RECV_SLAVE_REPLY - Receives reply from a DiSEqC 2.0 command
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct dvb_diseqc_slave_reply *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -31,7 +32,7 @@ ARGUMENTS
     :ref:`dvb_diseqc_slave_reply <dvb-diseqc-slave-reply>`
 
 
-DESCRIPTION
+Description
 ===========
 
 Receives reply from a DiSEqC 2.0 command.
@@ -73,7 +74,8 @@ struct dvb_diseqc_slave_reply
        -  Return from ioctl after timeout ms with errorcode when no message
 	  was received
 
-RETURN VALUE
+
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/fe-diseqc-reset-overload.rst b/Documentation/linux_tv/media/dvb/fe-diseqc-reset-overload.rst
index 236c25c9f7bd..cab157054c13 100644
--- a/Documentation/linux_tv/media/dvb/fe-diseqc-reset-overload.rst
+++ b/Documentation/linux_tv/media/dvb/fe-diseqc-reset-overload.rst
@@ -6,18 +6,19 @@
 ioctl FE_DISEQC_RESET_OVERLOAD
 ******************************
 
-NAME
+Name
 ====
 
 FE_DISEQC_RESET_OVERLOAD - Restores the power to the antenna subsystem, if it was powered off due - to power overload.
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, NULL )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -27,7 +28,7 @@ ARGUMENTS
     FE_DISEQC_RESET_OVERLOAD
 
 
-DESCRIPTION
+Description
 ===========
 
 If the bus has been automatically powered off due to power overload,
@@ -36,7 +37,7 @@ read/write access to the device. This call has no effect if the device
 is manually powered off. Not all DVB adapters support this ioctl.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/fe-diseqc-send-burst.rst b/Documentation/linux_tv/media/dvb/fe-diseqc-send-burst.rst
index 806ee5a9df68..c022cc290067 100644
--- a/Documentation/linux_tv/media/dvb/fe-diseqc-send-burst.rst
+++ b/Documentation/linux_tv/media/dvb/fe-diseqc-send-burst.rst
@@ -6,18 +6,19 @@
 ioctl FE_DISEQC_SEND_BURST
 **************************
 
-NAME
+Name
 ====
 
 FE_DISEQC_SEND_BURST - Sends a 22KHz tone burst for 2x1 mini DiSEqC satellite selection.
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. c:function:: int ioctl( int fd, int request, enum fe_sec_mini_cmd *tone )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -30,7 +31,7 @@ ARGUMENTS
     pointer to enum :ref:`fe_sec_mini_cmd <fe-sec-mini-cmd>`
 
 
-DESCRIPTION
+Description
 ===========
 
 This ioctl is used to set the generation of a 22kHz tone burst for mini
@@ -74,7 +75,8 @@ enum fe_sec_mini_cmd
 
        -  Sends a mini-DiSEqC 22kHz '1' Data Burst to select satellite-B
 
-RETURN VALUE
+
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/fe-diseqc-send-master-cmd.rst b/Documentation/linux_tv/media/dvb/fe-diseqc-send-master-cmd.rst
index 519e91bd47fd..dc83b4f2e586 100644
--- a/Documentation/linux_tv/media/dvb/fe-diseqc-send-master-cmd.rst
+++ b/Documentation/linux_tv/media/dvb/fe-diseqc-send-master-cmd.rst
@@ -6,18 +6,19 @@
 ioctl FE_DISEQC_SEND_MASTER_CMD
 *******************************
 
-NAME
+Name
 ====
 
 FE_DISEQC_SEND_MASTER_CMD - Sends a DiSEqC command
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct dvb_diseqc_master_cmd *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -31,13 +32,13 @@ ARGUMENTS
     :ref:`dvb_diseqc_master_cmd <dvb-diseqc-master-cmd>`
 
 
-DESCRIPTION
+Description
 ===========
 
 Sends a DiSEqC command to the antenna subsystem.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/fe-dishnetwork-send-legacy-cmd.rst b/Documentation/linux_tv/media/dvb/fe-dishnetwork-send-legacy-cmd.rst
index 9435f45f58c3..4b60a42dd52c 100644
--- a/Documentation/linux_tv/media/dvb/fe-dishnetwork-send-legacy-cmd.rst
+++ b/Documentation/linux_tv/media/dvb/fe-dishnetwork-send-legacy-cmd.rst
@@ -6,18 +6,19 @@
 FE_DISHNETWORK_SEND_LEGACY_CMD
 ******************************
 
-NAME
+Name
 ====
 
 FE_DISHNETWORK_SEND_LEGACY_CMD
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. c:function:: int  ioctl(int fd, int request = FE_DISHNETWORK_SEND_LEGACY_CMD, unsigned long cmd)
 
 
-ARGUMENTS
+Arguments
 =========
 
 .. flat-table::
@@ -32,7 +33,7 @@ ARGUMENTS
        -  sends the specified raw cmd to the dish via DISEqC.
 
 
-DESCRIPTION
+Description
 ===========
 
 WARNING: This is a very obscure legacy command, used only at stv0299
@@ -45,7 +46,7 @@ As support for this ioctl were added in 2004, this means that such
 dishes were already legacy in 2004.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/fe-enable-high-lnb-voltage.rst b/Documentation/linux_tv/media/dvb/fe-enable-high-lnb-voltage.rst
index 27f49823e67d..de99bf5fbf0e 100644
--- a/Documentation/linux_tv/media/dvb/fe-enable-high-lnb-voltage.rst
+++ b/Documentation/linux_tv/media/dvb/fe-enable-high-lnb-voltage.rst
@@ -6,18 +6,19 @@
 ioctl FE_ENABLE_HIGH_LNB_VOLTAGE
 ********************************
 
-NAME
+Name
 ====
 
 FE_ENABLE_HIGH_LNB_VOLTAGE - Select output DC level between normal LNBf voltages or higher LNBf - voltages.
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, unsigned int high )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -35,7 +36,7 @@ ARGUMENTS
        to compensate for long antenna cables.
 
 
-DESCRIPTION
+Description
 ===========
 
 Select output DC level between normal LNBf voltages or higher LNBf
@@ -43,7 +44,7 @@ voltages between 0 (normal) or a value grater than 0 for higher
 voltages.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/fe-get-event.rst b/Documentation/linux_tv/media/dvb/fe-get-event.rst
index 3d858107b6f9..79beb1b9da3b 100644
--- a/Documentation/linux_tv/media/dvb/fe-get-event.rst
+++ b/Documentation/linux_tv/media/dvb/fe-get-event.rst
@@ -6,18 +6,19 @@
 FE_GET_EVENT
 ************
 
-NAME
+Name
 ====
 
 FE_GET_EVENT
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. c:function:: int  ioctl(int fd, int request = QPSK_GET_EVENT, struct dvb_frontend_event *ev)
 
 
-ARGUMENTS
+Arguments
 =========
 
 .. flat-table::
@@ -49,7 +50,7 @@ ARGUMENTS
        -  if any, is to be stored.
 
 
-DESCRIPTION
+Description
 ===========
 
 This ioctl call returns a frontend event if available. If an event is
@@ -59,7 +60,7 @@ with errno set to ``EWOULDBLOCK``. In the former case, the call blocks until
 an event becomes available.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/fe-get-frontend.rst b/Documentation/linux_tv/media/dvb/fe-get-frontend.rst
index 7084070bfe77..fdf0d1440add 100644
--- a/Documentation/linux_tv/media/dvb/fe-get-frontend.rst
+++ b/Documentation/linux_tv/media/dvb/fe-get-frontend.rst
@@ -6,18 +6,19 @@
 FE_GET_FRONTEND
 ***************
 
-NAME
+Name
 ====
 
 FE_GET_FRONTEND
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. c:function:: int ioctl(int fd, int request = FE_GET_FRONTEND, struct dvb_frontend_parameters *p)
 
 
-ARGUMENTS
+Arguments
 =========
 
 .. flat-table::
@@ -45,14 +46,14 @@ ARGUMENTS
        -  Points to parameters for tuning operation.
 
 
-DESCRIPTION
+Description
 ===========
 
 This ioctl call queries the currently effective frontend parameters. For
 this command, read-only access to the device is sufficient.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/fe-get-info.rst b/Documentation/linux_tv/media/dvb/fe-get-info.rst
index 1efb242d7f4a..8ef1ed7bbf68 100644
--- a/Documentation/linux_tv/media/dvb/fe-get-info.rst
+++ b/Documentation/linux_tv/media/dvb/fe-get-info.rst
@@ -6,18 +6,19 @@
 ioctl FE_GET_INFO
 *****************
 
-NAME
+Name
 ====
 
 FE_GET_INFO - Query DVB frontend capabilities and returns information about the - front-end. This call only requires read-only access to the device
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct dvb_frontend_info *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -31,7 +32,7 @@ ARGUMENTS
     :ref:`dvb_frontend_info <dvb-frontend-info>`
 
 
-DESCRIPTION
+Description
 ===========
 
 All DVB frontend devices support the ``FE_GET_INFO`` ioctl. It is used
@@ -418,7 +419,8 @@ supported only on some specific frontend types.
 
        -  The frontend can stop spurious TS data output
 
-RETURN VALUE
+
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/fe-get-property.rst b/Documentation/linux_tv/media/dvb/fe-get-property.rst
index c470105dcd15..749daafe6b21 100644
--- a/Documentation/linux_tv/media/dvb/fe-get-property.rst
+++ b/Documentation/linux_tv/media/dvb/fe-get-property.rst
@@ -6,18 +6,19 @@
 ioctl FE_SET_PROPERTY, FE_GET_PROPERTY
 **************************************
 
-NAME
+Name
 ====
 
 FE_SET_PROPERTY - FE_GET_PROPERTY - FE_SET_PROPERTY sets one or more frontend properties. - FE_GET_PROPERTY returns one or more frontend properties.
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct dtv_properties *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -30,7 +31,7 @@ ARGUMENTS
     pointer to struct :ref:`dtv_properties <dtv-properties>`
 
 
-DESCRIPTION
+Description
 ===========
 
 All DVB frontend devices support the ``FE_SET_PROPERTY`` and
@@ -59,7 +60,7 @@ depends on the delivery system and on the device:
    -  This call only requires read-only access to the device.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/fe-read-ber.rst b/Documentation/linux_tv/media/dvb/fe-read-ber.rst
index 39cf656a4ca0..3262441385ff 100644
--- a/Documentation/linux_tv/media/dvb/fe-read-ber.rst
+++ b/Documentation/linux_tv/media/dvb/fe-read-ber.rst
@@ -6,19 +6,19 @@
 FE_READ_BER
 ***********
 
-Description
------------
+Name
+====
 
-This ioctl call returns the bit error rate for the signal currently
-received/demodulated by the front-end. For this command, read-only
-access to the device is sufficient.
+FE_READ_BER
 
-SYNOPSIS
+Synopsis
+========
 
 .. c:function:: int  ioctl(int fd, int request = FE_READ_BER, uint32_t *ber)
 
+
 Arguments
-----------
+=========
 
 .. flat-table::
     :header-rows:  0
@@ -44,8 +44,16 @@ Arguments
        -  The bit error rate is stored into \*ber.
 
 
+Description
+===========
+
+This ioctl call returns the bit error rate for the signal currently
+received/demodulated by the front-end. For this command, read-only
+access to the device is sufficient.
+
+
 Return Value
-------------
+============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
diff --git a/Documentation/linux_tv/media/dvb/fe-read-signal-strength.rst b/Documentation/linux_tv/media/dvb/fe-read-signal-strength.rst
index 7f6f47f4d30e..fcaadcb537fb 100644
--- a/Documentation/linux_tv/media/dvb/fe-read-signal-strength.rst
+++ b/Documentation/linux_tv/media/dvb/fe-read-signal-strength.rst
@@ -6,18 +6,19 @@
 FE_READ_SIGNAL_STRENGTH
 ***********************
 
-NAME
+Name
 ====
 
 FE_READ_SIGNAL_STRENGTH
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. c:function:: int ioctl( int fd, int request = FE_READ_SIGNAL_STRENGTH, uint16_t *strength)
 
 
-ARGUMENTS
+Arguments
 =========
 
 .. flat-table::
@@ -46,7 +47,7 @@ ARGUMENTS
        -  The signal strength value is stored into \*strength.
 
 
-DESCRIPTION
+Description
 ===========
 
 This ioctl call returns the signal strength value for the signal
@@ -54,7 +55,7 @@ currently received by the front-end. For this command, read-only access
 to the device is sufficient.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/fe-read-snr.rst b/Documentation/linux_tv/media/dvb/fe-read-snr.rst
index 3ecaeb8007f4..837af2de9f6f 100644
--- a/Documentation/linux_tv/media/dvb/fe-read-snr.rst
+++ b/Documentation/linux_tv/media/dvb/fe-read-snr.rst
@@ -6,18 +6,19 @@
 FE_READ_SNR
 ***********
 
-NAME
+Name
 ====
 
 FE_READ_SNR
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. c:function:: int  ioctl(int fd, int request = FE_READ_SNR, int16_t *snr)
 
 
-ARGUMENTS
+Arguments
 =========
 
 .. flat-table::
@@ -44,7 +45,7 @@ ARGUMENTS
        -  The signal-to-noise ratio is stored into \*snr.
 
 
-DESCRIPTION
+Description
 ===========
 
 This ioctl call returns the signal-to-noise ratio for the signal
@@ -52,7 +53,7 @@ currently received by the front-end. For this command, read-only access
 to the device is sufficient.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/fe-read-status.rst b/Documentation/linux_tv/media/dvb/fe-read-status.rst
index 697598d30976..544ce49ee091 100644
--- a/Documentation/linux_tv/media/dvb/fe-read-status.rst
+++ b/Documentation/linux_tv/media/dvb/fe-read-status.rst
@@ -6,18 +6,19 @@
 ioctl FE_READ_STATUS
 ********************
 
-NAME
+Name
 ====
 
 FE_READ_STATUS - Returns status information about the front-end. This call only requires - read-only access to the device
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, unsigned int *status )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -31,7 +32,7 @@ ARGUMENTS
     :ref:`fe_status <fe-status>`.
 
 
-DESCRIPTION
+Description
 ===========
 
 All DVB frontend devices support the ``FE_READ_STATUS`` ioctl. It is
@@ -125,7 +126,8 @@ state changes of the frontend hardware. It is produced using the enum
        -  The frontend was reinitialized, application is recommended to
 	  reset DiSEqC, tone and parameters
 
-RETURN VALUE
+
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/fe-read-uncorrected-blocks.rst b/Documentation/linux_tv/media/dvb/fe-read-uncorrected-blocks.rst
index 31ec4c35dd51..6b753846a008 100644
--- a/Documentation/linux_tv/media/dvb/fe-read-uncorrected-blocks.rst
+++ b/Documentation/linux_tv/media/dvb/fe-read-uncorrected-blocks.rst
@@ -6,18 +6,19 @@
 FE_READ_UNCORRECTED_BLOCKS
 **************************
 
-NAME
+Name
 ====
 
 FE_READ_UNCORRECTED_BLOCKS
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. c:function:: int ioctl( int fd, int request =FE_READ_UNCORRECTED_BLOCKS, uint32_t *ublocks)
 
 
-ARGUMENTS
+Arguments
 =========
 
 .. flat-table::
@@ -46,7 +47,7 @@ ARGUMENTS
        -  The total number of uncorrected blocks seen by the driver so far.
 
 
-DESCRIPTION
+Description
 ===========
 
 This ioctl call returns the number of uncorrected blocks detected by the
@@ -56,7 +57,7 @@ calculated. For this command, read-only access to the device is
 sufficient.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/fe-set-frontend-tune-mode.rst b/Documentation/linux_tv/media/dvb/fe-set-frontend-tune-mode.rst
index 1db22c426b8c..411abcf4de58 100644
--- a/Documentation/linux_tv/media/dvb/fe-set-frontend-tune-mode.rst
+++ b/Documentation/linux_tv/media/dvb/fe-set-frontend-tune-mode.rst
@@ -6,18 +6,19 @@
 ioctl FE_SET_FRONTEND_TUNE_MODE
 *******************************
 
-NAME
+Name
 ====
 
 FE_SET_FRONTEND_TUNE_MODE - Allow setting tuner mode flags to the frontend.
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, unsigned int flags )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -39,14 +40,14 @@ ARGUMENTS
        device is reopened read-write.
 
 
-DESCRIPTION
+Description
 ===========
 
 Allow setting tuner mode flags to the frontend, between 0 (normal) or
 FE_TUNE_MODE_ONESHOT mode
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/fe-set-frontend.rst b/Documentation/linux_tv/media/dvb/fe-set-frontend.rst
index 06edd97e7e53..4e66da0af6fd 100644
--- a/Documentation/linux_tv/media/dvb/fe-set-frontend.rst
+++ b/Documentation/linux_tv/media/dvb/fe-set-frontend.rst
@@ -6,18 +6,19 @@
 FE_SET_FRONTEND
 ***************
 
-NAME
+Name
 ====
 
 FE_SET_FRONTEND
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. c:function:: int ioctl(int fd, int request = FE_SET_FRONTEND, struct dvb_frontend_parameters *p)
 
 
-ARGUMENTS
+Arguments
 =========
 
 .. flat-table::
@@ -45,7 +46,7 @@ ARGUMENTS
        -  Points to parameters for tuning operation.
 
 
-DESCRIPTION
+Description
 ===========
 
 This ioctl call starts a tuning operation using specified parameters.
@@ -59,7 +60,7 @@ previous operation will be aborted in favor of the new one. This command
 requires read/write access to the device.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/fe-set-tone.rst b/Documentation/linux_tv/media/dvb/fe-set-tone.rst
index 18677f205954..12aedb69395d 100644
--- a/Documentation/linux_tv/media/dvb/fe-set-tone.rst
+++ b/Documentation/linux_tv/media/dvb/fe-set-tone.rst
@@ -6,18 +6,19 @@
 ioctl FE_SET_TONE
 *****************
 
-NAME
+Name
 ====
 
 FE_SET_TONE - Sets/resets the generation of the continuous 22kHz tone.
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. c:function:: int ioctl( int fd, int request, enum fe_sec_tone_mode *tone )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -30,7 +31,7 @@ ARGUMENTS
     pointer to enum :ref:`fe_sec_tone_mode <fe-sec-tone-mode>`
 
 
-DESCRIPTION
+Description
 ===========
 
 This ioctl is used to set the generation of the continuous 22kHz tone.
@@ -81,7 +82,8 @@ enum fe_sec_tone_mode
        -  Don't send a 22kHz tone to the antenna (except if the
 	  FE_DISEQC_* ioctls are called)
 
-RETURN VALUE
+
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/fe-set-voltage.rst b/Documentation/linux_tv/media/dvb/fe-set-voltage.rst
index 4fd30ee53f5b..ec8dbf4e266c 100644
--- a/Documentation/linux_tv/media/dvb/fe-set-voltage.rst
+++ b/Documentation/linux_tv/media/dvb/fe-set-voltage.rst
@@ -6,18 +6,19 @@
 ioctl FE_SET_VOLTAGE
 ********************
 
-NAME
+Name
 ====
 
 FE_SET_VOLTAGE - Allow setting the DC level sent to the antenna subsystem.
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. c:function:: int ioctl( int fd, int request, enum fe_sec_voltage *voltage )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -33,7 +34,7 @@ ARGUMENTS
     :ref:`fe_sec_voltage <fe-sec-voltage>`.
 
 
-DESCRIPTION
+Description
 ===========
 
 This ioctl allows to set the DC voltage level sent through the antenna
@@ -54,7 +55,7 @@ the voltage to SEC_VOLTAGE_OFF while the device is not is used is
 recommended.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/frontend_f_close.rst b/Documentation/linux_tv/media/dvb/frontend_f_close.rst
index 7946673d071a..5cce9262084c 100644
--- a/Documentation/linux_tv/media/dvb/frontend_f_close.rst
+++ b/Documentation/linux_tv/media/dvb/frontend_f_close.rst
@@ -6,12 +6,13 @@
 DVB frontend close()
 ********************
 
-NAME
+Name
 ====
 
 fe-close - Close a frontend device
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. code-block:: c
@@ -22,14 +23,14 @@ SYNOPSIS
 .. cpp:function:: int close( int fd )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
 
-DESCRIPTION
+Description
 ===========
 
 This system call closes a previously opened front-end device. After
@@ -37,7 +38,7 @@ closing a front-end device, its corresponding hardware might be powered
 down automatically.
 
 
-RETURN VALUE
+Return Value
 ============
 
 The function returns 0 on success, -1 on failure and the ``errno`` is
diff --git a/Documentation/linux_tv/media/dvb/frontend_f_open.rst b/Documentation/linux_tv/media/dvb/frontend_f_open.rst
index 97ca34b94d05..e0c55345f524 100644
--- a/Documentation/linux_tv/media/dvb/frontend_f_open.rst
+++ b/Documentation/linux_tv/media/dvb/frontend_f_open.rst
@@ -6,12 +6,13 @@
 DVB frontend open()
 *******************
 
-NAME
+Name
 ====
 
 fe-open - Open a frontend device
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. code-block:: c
@@ -22,7 +23,7 @@ SYNOPSIS
 .. cpp:function:: int open( const char *device_name, int flags )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``device_name``
@@ -44,7 +45,7 @@ ARGUMENTS
     Other flags have no effect.
 
 
-DESCRIPTION
+Description
 ===========
 
 This system call opens a named frontend device
@@ -70,7 +71,7 @@ powered up, and that other front-ends may have been powered down to make
 that possible.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success :ref:`open() <frontend_f_open>` returns the new file descriptor.
diff --git a/Documentation/linux_tv/media/dvb/net-add-if.rst b/Documentation/linux_tv/media/dvb/net-add-if.rst
index dc9735d871ee..2b990d0e0fe1 100644
--- a/Documentation/linux_tv/media/dvb/net-add-if.rst
+++ b/Documentation/linux_tv/media/dvb/net-add-if.rst
@@ -6,18 +6,19 @@
 ioctl NET_ADD_IF
 ****************
 
-NAME
+Name
 ====
 
 NET_ADD_IF - Creates a new network interface for a given Packet ID.
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct dvb_net_if *net_if )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -30,7 +31,7 @@ ARGUMENTS
     pointer to struct :ref:`dvb_net_if <dvb-net-if>`
 
 
-DESCRIPTION
+Description
 ===========
 
 The NET_ADD_IF ioctl system call selects the Packet ID (PID) that
@@ -82,7 +83,7 @@ struct dvb_net_if description
 	  ``DVB_NET_FEEDTYPE_ULE`` for ULE encoding.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/net-get-if.rst b/Documentation/linux_tv/media/dvb/net-get-if.rst
index 16dfe78eb77f..92b884143ccd 100644
--- a/Documentation/linux_tv/media/dvb/net-get-if.rst
+++ b/Documentation/linux_tv/media/dvb/net-get-if.rst
@@ -6,18 +6,19 @@
 ioctl NET_GET_IF
 ****************
 
-NAME
+Name
 ====
 
 NET_GET_IF - Read the configuration data of an interface created via - :ref:`NET_ADD_IF <net>`.
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct dvb_net_if *net_if )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -30,7 +31,7 @@ ARGUMENTS
     pointer to struct :ref:`dvb_net_if <dvb-net-if>`
 
 
-DESCRIPTION
+Description
 ===========
 
 The NET_GET_IF ioctl uses the interface number given by the struct
@@ -41,7 +42,7 @@ created yet with :ref:`NET_ADD_IF <net>`, it will return -1 and fill
 the ``errno`` with ``EINVAL`` error code.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/net-remove-if.rst b/Documentation/linux_tv/media/dvb/net-remove-if.rst
index c4177833ecf6..d374c1d63d06 100644
--- a/Documentation/linux_tv/media/dvb/net-remove-if.rst
+++ b/Documentation/linux_tv/media/dvb/net-remove-if.rst
@@ -6,18 +6,19 @@
 ioctl NET_REMOVE_IF
 *******************
 
-NAME
+Name
 ====
 
 NET_REMOVE_IF - Removes a network interface.
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, int ifnum )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -30,14 +31,14 @@ ARGUMENTS
     number of the interface to be removed
 
 
-DESCRIPTION
+Description
 ===========
 
 The NET_REMOVE_IF ioctl deletes an interface previously created via
 :ref:`NET_ADD_IF <net>`.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/video-clear-buffer.rst b/Documentation/linux_tv/media/dvb/video-clear-buffer.rst
index e6d2825f4c9b..dd227ad85546 100644
--- a/Documentation/linux_tv/media/dvb/video-clear-buffer.rst
+++ b/Documentation/linux_tv/media/dvb/video-clear-buffer.rst
@@ -6,18 +6,19 @@
 VIDEO_CLEAR_BUFFER
 ==================
 
-NAME
+Name
 ----
 
 VIDEO_CLEAR_BUFFER
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int ioctl(fd, int request = VIDEO_CLEAR_BUFFER)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -38,14 +39,14 @@ ARGUMENTS
        -  Equals VIDEO_CLEAR_BUFFER for this command.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl call clears all video buffers in the driver and in the
 decoder hardware.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/video-command.rst b/Documentation/linux_tv/media/dvb/video-command.rst
index 1743f40145ff..42a98a47e323 100644
--- a/Documentation/linux_tv/media/dvb/video-command.rst
+++ b/Documentation/linux_tv/media/dvb/video-command.rst
@@ -6,18 +6,19 @@
 VIDEO_COMMAND
 =============
 
-NAME
+Name
 ----
 
 VIDEO_COMMAND
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int ioctl(int fd, int request = VIDEO_COMMAND, struct video_command *cmd)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -44,7 +45,7 @@ ARGUMENTS
        -  Commands the decoder.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl is obsolete. Do not use in new drivers. For V4L2 decoders
@@ -57,7 +58,7 @@ subset of the ``v4l2_decoder_cmd`` struct, so refer to the
 more information.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/video-continue.rst b/Documentation/linux_tv/media/dvb/video-continue.rst
index 453a87dfb40d..2a6444a4f4dc 100644
--- a/Documentation/linux_tv/media/dvb/video-continue.rst
+++ b/Documentation/linux_tv/media/dvb/video-continue.rst
@@ -6,18 +6,19 @@
 VIDEO_CONTINUE
 ==============
 
-NAME
+Name
 ----
 
 VIDEO_CONTINUE
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int ioctl(fd, int request = VIDEO_CONTINUE)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -38,7 +39,7 @@ ARGUMENTS
        -  Equals VIDEO_CONTINUE for this command.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl is for DVB devices only. To control a V4L2 decoder use the
@@ -48,7 +49,7 @@ This ioctl call restarts decoding and playing processes of the video
 stream which was played before a call to VIDEO_FREEZE was made.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/video-fast-forward.rst b/Documentation/linux_tv/media/dvb/video-fast-forward.rst
index 586a23bb5cfd..0b3a27a22d30 100644
--- a/Documentation/linux_tv/media/dvb/video-fast-forward.rst
+++ b/Documentation/linux_tv/media/dvb/video-fast-forward.rst
@@ -6,18 +6,19 @@
 VIDEO_FAST_FORWARD
 ==================
 
-NAME
+Name
 ----
 
 VIDEO_FAST_FORWARD
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int ioctl(fd, int request = VIDEO_FAST_FORWARD, int nFrames)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -44,7 +45,7 @@ ARGUMENTS
        -  The number of frames to skip.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl call asks the Video Device to skip decoding of N number of
@@ -52,7 +53,7 @@ I-frames. This call can only be used if VIDEO_SOURCE_MEMORY is
 selected.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/video-fclose.rst b/Documentation/linux_tv/media/dvb/video-fclose.rst
index e98673768d2b..b4dd5ea676b9 100644
--- a/Documentation/linux_tv/media/dvb/video-fclose.rst
+++ b/Documentation/linux_tv/media/dvb/video-fclose.rst
@@ -6,18 +6,19 @@
 dvb video close()
 =================
 
-NAME
+Name
 ----
 
 dvb video close()
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int close(int fd)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -32,13 +33,13 @@ ARGUMENTS
        -  File descriptor returned by a previous call to open().
 
 
-DESCRIPTION
+Description
 -----------
 
 This system call closes a previously opened video device.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 .. flat-table::
diff --git a/Documentation/linux_tv/media/dvb/video-fopen.rst b/Documentation/linux_tv/media/dvb/video-fopen.rst
index 3c30fef2aab6..31d4d62b2c7c 100644
--- a/Documentation/linux_tv/media/dvb/video-fopen.rst
+++ b/Documentation/linux_tv/media/dvb/video-fopen.rst
@@ -6,18 +6,19 @@
 dvb video open()
 ================
 
-NAME
+Name
 ----
 
 dvb video open()
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int open(const char *deviceName, int flags)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -58,7 +59,7 @@ ARGUMENTS
        -  (blocking mode is the default)
 
 
-DESCRIPTION
+Description
 -----------
 
 This system call opens a named video device (e.g.
@@ -78,7 +79,7 @@ ioctl call that can be used is VIDEO_GET_STATUS. All other call will
 return an error code.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 .. flat-table::
diff --git a/Documentation/linux_tv/media/dvb/video-freeze.rst b/Documentation/linux_tv/media/dvb/video-freeze.rst
index 8fbc7835382c..12e04df990b7 100644
--- a/Documentation/linux_tv/media/dvb/video-freeze.rst
+++ b/Documentation/linux_tv/media/dvb/video-freeze.rst
@@ -6,18 +6,19 @@
 VIDEO_FREEZE
 ============
 
-NAME
+Name
 ----
 
 VIDEO_FREEZE
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int ioctl(fd, int request = VIDEO_FREEZE)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -38,7 +39,7 @@ ARGUMENTS
        -  Equals VIDEO_FREEZE for this command.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl is for DVB devices only. To control a V4L2 decoder use the
@@ -52,7 +53,7 @@ VIDEO_SELECT_SOURCE, the DVB subsystem will not decode any more data
 until the ioctl call VIDEO_CONTINUE or VIDEO_PLAY is performed.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/video-fwrite.rst b/Documentation/linux_tv/media/dvb/video-fwrite.rst
index f56c89caef32..da03db4be8de 100644
--- a/Documentation/linux_tv/media/dvb/video-fwrite.rst
+++ b/Documentation/linux_tv/media/dvb/video-fwrite.rst
@@ -6,18 +6,19 @@
 dvb video write()
 =================
 
-NAME
+Name
 ----
 
 dvb video write()
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: size_t write(int fd, const void *buf, size_t count)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -44,7 +45,7 @@ ARGUMENTS
        -  Size of buf.
 
 
-DESCRIPTION
+Description
 -----------
 
 This system call can only be used if VIDEO_SOURCE_MEMORY is selected
@@ -54,7 +55,7 @@ is not specified the function will block until buffer space is
 available. The amount of data to be transferred is implied by count.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 .. flat-table::
diff --git a/Documentation/linux_tv/media/dvb/video-get-capabilities.rst b/Documentation/linux_tv/media/dvb/video-get-capabilities.rst
index 5666ae7f20c0..5515dd40a1c1 100644
--- a/Documentation/linux_tv/media/dvb/video-get-capabilities.rst
+++ b/Documentation/linux_tv/media/dvb/video-get-capabilities.rst
@@ -6,18 +6,19 @@
 VIDEO_GET_CAPABILITIES
 ======================
 
-NAME
+Name
 ----
 
 VIDEO_GET_CAPABILITIES
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int ioctl(fd, int request = VIDEO_GET_CAPABILITIES, unsigned int *cap)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -44,7 +45,7 @@ ARGUMENTS
        -  Pointer to a location where to store the capability information.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl call asks the video device about its decoding capabilities.
@@ -52,7 +53,7 @@ On success it returns and integer which has bits set according to the
 defines in section ??.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/video-get-event.rst b/Documentation/linux_tv/media/dvb/video-get-event.rst
index b08ca148ecdc..d43459915179 100644
--- a/Documentation/linux_tv/media/dvb/video-get-event.rst
+++ b/Documentation/linux_tv/media/dvb/video-get-event.rst
@@ -6,18 +6,19 @@
 VIDEO_GET_EVENT
 ===============
 
-NAME
+Name
 ----
 
 VIDEO_GET_EVENT
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int ioctl(fd, int request = VIDEO_GET_EVENT, struct video_event *ev)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -44,7 +45,7 @@ ARGUMENTS
        -  Points to the location where the event, if any, is to be stored.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl is for DVB devices only. To get events from a V4L2 decoder
@@ -62,7 +63,7 @@ specified as the wake-up condition. Read-only permissions are sufficient
 for this ioctl call.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/video-get-frame-count.rst b/Documentation/linux_tv/media/dvb/video-get-frame-count.rst
index 97ec05810154..a55f7a1d52ac 100644
--- a/Documentation/linux_tv/media/dvb/video-get-frame-count.rst
+++ b/Documentation/linux_tv/media/dvb/video-get-frame-count.rst
@@ -6,18 +6,19 @@
 VIDEO_GET_FRAME_COUNT
 =====================
 
-NAME
+Name
 ----
 
 VIDEO_GET_FRAME_COUNT
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int ioctl(int fd, int request = VIDEO_GET_FRAME_COUNT, __u64 *pts)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -45,7 +46,7 @@ ARGUMENTS
 	  started.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl is obsolete. Do not use in new drivers. For V4L2 decoders
@@ -56,7 +57,7 @@ This ioctl call asks the Video Device to return the number of displayed
 frames since the decoder was started.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/video-get-frame-rate.rst b/Documentation/linux_tv/media/dvb/video-get-frame-rate.rst
index 62a85be537ab..a137b6589599 100644
--- a/Documentation/linux_tv/media/dvb/video-get-frame-rate.rst
+++ b/Documentation/linux_tv/media/dvb/video-get-frame-rate.rst
@@ -6,18 +6,19 @@
 VIDEO_GET_FRAME_RATE
 ====================
 
-NAME
+Name
 ----
 
 VIDEO_GET_FRAME_RATE
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int ioctl(int fd, int request = VIDEO_GET_FRAME_RATE, unsigned int *rate)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -44,13 +45,13 @@ ARGUMENTS
        -  Returns the framerate in number of frames per 1000 seconds.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl call asks the Video Device to return the current framerate.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/video-get-navi.rst b/Documentation/linux_tv/media/dvb/video-get-navi.rst
index 95dea513bc48..ccb2552722f0 100644
--- a/Documentation/linux_tv/media/dvb/video-get-navi.rst
+++ b/Documentation/linux_tv/media/dvb/video-get-navi.rst
@@ -6,18 +6,19 @@
 VIDEO_GET_NAVI
 ==============
 
-NAME
+Name
 ----
 
 VIDEO_GET_NAVI
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int ioctl(fd, int request = VIDEO_GET_NAVI , video_navi_pack_t *navipack)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -44,7 +45,7 @@ ARGUMENTS
        -  PCI or DSI pack (private stream 2) according to section ??.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl returns navigational information from the DVD stream. This is
@@ -52,7 +53,7 @@ especially needed if an encoded stream has to be decoded by the
 hardware.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/video-get-pts.rst b/Documentation/linux_tv/media/dvb/video-get-pts.rst
index f56e02a1f447..c1ad9576963d 100644
--- a/Documentation/linux_tv/media/dvb/video-get-pts.rst
+++ b/Documentation/linux_tv/media/dvb/video-get-pts.rst
@@ -6,18 +6,19 @@
 VIDEO_GET_PTS
 =============
 
-NAME
+Name
 ----
 
 VIDEO_GET_PTS
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int ioctl(int fd, int request = VIDEO_GET_PTS, __u64 *pts)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -49,7 +50,7 @@ ARGUMENTS
 	  decoded frame or the last PTS extracted by the PES parser.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl is obsolete. Do not use in new drivers. For V4L2 decoders
@@ -60,7 +61,7 @@ This ioctl call asks the Video Device to return the current PTS
 timestamp.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/video-get-size.rst b/Documentation/linux_tv/media/dvb/video-get-size.rst
index cbdf976223e5..70fb266e3ed8 100644
--- a/Documentation/linux_tv/media/dvb/video-get-size.rst
+++ b/Documentation/linux_tv/media/dvb/video-get-size.rst
@@ -6,18 +6,19 @@
 VIDEO_GET_SIZE
 ==============
 
-NAME
+Name
 ----
 
 VIDEO_GET_SIZE
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int ioctl(int fd, int request = VIDEO_GET_SIZE, video_size_t *size)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -44,13 +45,13 @@ ARGUMENTS
        -  Returns the size and aspect ratio.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl returns the size and aspect ratio.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/video-get-status.rst b/Documentation/linux_tv/media/dvb/video-get-status.rst
index 25344bf0ea7b..5fd5b37942ec 100644
--- a/Documentation/linux_tv/media/dvb/video-get-status.rst
+++ b/Documentation/linux_tv/media/dvb/video-get-status.rst
@@ -6,18 +6,19 @@
 VIDEO_GET_STATUS
 ================
 
-NAME
+Name
 ----
 
 VIDEO_GET_STATUS
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int ioctl(fd, int request = VIDEO_GET_STATUS, struct video_status *status)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -44,14 +45,14 @@ ARGUMENTS
        -  Returns the current status of the Video Device.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl call asks the Video Device to return the current status of
 the device.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/video-play.rst b/Documentation/linux_tv/media/dvb/video-play.rst
index 18252d9d2ce6..103d0ad3341a 100644
--- a/Documentation/linux_tv/media/dvb/video-play.rst
+++ b/Documentation/linux_tv/media/dvb/video-play.rst
@@ -6,18 +6,19 @@
 VIDEO_PLAY
 ==========
 
-NAME
+Name
 ----
 
 VIDEO_PLAY
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int ioctl(fd, int request = VIDEO_PLAY)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -38,7 +39,7 @@ ARGUMENTS
        -  Equals VIDEO_PLAY for this command.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl is for DVB devices only. To control a V4L2 decoder use the
@@ -48,7 +49,7 @@ This ioctl call asks the Video Device to start playing a video stream
 from the selected source.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/video-select-source.rst b/Documentation/linux_tv/media/dvb/video-select-source.rst
index 2e76af3d468b..f03c544668f5 100644
--- a/Documentation/linux_tv/media/dvb/video-select-source.rst
+++ b/Documentation/linux_tv/media/dvb/video-select-source.rst
@@ -6,18 +6,19 @@
 VIDEO_SELECT_SOURCE
 ===================
 
-NAME
+Name
 ----
 
 VIDEO_SELECT_SOURCE
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int ioctl(fd, int request = VIDEO_SELECT_SOURCE, video_stream_source_t source)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -44,7 +45,7 @@ ARGUMENTS
        -  Indicates which source shall be used for the Video stream.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl is for DVB devices only. This ioctl was also supported by the
@@ -56,7 +57,7 @@ the input data. The possible sources are demux or memory. If memory is
 selected, the data is fed to the video device through the write command.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/video-set-attributes.rst b/Documentation/linux_tv/media/dvb/video-set-attributes.rst
index 6de9378ce1c7..9de0d9c7c9ca 100644
--- a/Documentation/linux_tv/media/dvb/video-set-attributes.rst
+++ b/Documentation/linux_tv/media/dvb/video-set-attributes.rst
@@ -6,18 +6,19 @@
 VIDEO_SET_ATTRIBUTES
 ====================
 
-NAME
+Name
 ----
 
 VIDEO_SET_ATTRIBUTES
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int ioctl(fd, int request = VIDEO_SET_ATTRIBUTE ,video_attributes_t vattr)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -44,7 +45,7 @@ ARGUMENTS
        -  video attributes according to section ??.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl is intended for DVD playback and allows you to set certain
@@ -53,7 +54,7 @@ information, but the call also tells the hardware to prepare for DVD
 playback.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/video-set-blank.rst b/Documentation/linux_tv/media/dvb/video-set-blank.rst
index 62b46b8b2d02..d8b94c9b56b9 100644
--- a/Documentation/linux_tv/media/dvb/video-set-blank.rst
+++ b/Documentation/linux_tv/media/dvb/video-set-blank.rst
@@ -6,18 +6,19 @@
 VIDEO_SET_BLANK
 ===============
 
-NAME
+Name
 ----
 
 VIDEO_SET_BLANK
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int ioctl(fd, int request = VIDEO_SET_BLANK, boolean mode)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -49,13 +50,13 @@ ARGUMENTS
        -  FALSE: Show last decoded frame.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl call asks the Video Device to blank out the picture.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/video-set-display-format.rst b/Documentation/linux_tv/media/dvb/video-set-display-format.rst
index 7aec080638de..c1fb7c75b4a8 100644
--- a/Documentation/linux_tv/media/dvb/video-set-display-format.rst
+++ b/Documentation/linux_tv/media/dvb/video-set-display-format.rst
@@ -6,18 +6,19 @@
 VIDEO_SET_DISPLAY_FORMAT
 ========================
 
-NAME
+Name
 ----
 
 VIDEO_SET_DISPLAY_FORMAT
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int ioctl(fd, int request = VIDEO_SET_DISPLAY_FORMAT, video_display_format_t format)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -44,14 +45,14 @@ ARGUMENTS
        -  Selects the video format to be used.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl call asks the Video Device to select the video format to be
 applied by the MPEG chip on the video.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/video-set-format.rst b/Documentation/linux_tv/media/dvb/video-set-format.rst
index af126d2de8c3..257a3c2a4627 100644
--- a/Documentation/linux_tv/media/dvb/video-set-format.rst
+++ b/Documentation/linux_tv/media/dvb/video-set-format.rst
@@ -6,18 +6,19 @@
 VIDEO_SET_FORMAT
 ================
 
-NAME
+Name
 ----
 
 VIDEO_SET_FORMAT
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int ioctl(fd, int request = VIDEO_SET_FORMAT, video_format_t format)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -44,7 +45,7 @@ ARGUMENTS
        -  video format of TV as defined in section ??.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl sets the screen format (aspect ratio) of the connected output
@@ -52,7 +53,7 @@ device (TV) so that the output of the decoder can be adjusted
 accordingly.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/video-set-highlight.rst b/Documentation/linux_tv/media/dvb/video-set-highlight.rst
index d8628d282740..6ff11af71355 100644
--- a/Documentation/linux_tv/media/dvb/video-set-highlight.rst
+++ b/Documentation/linux_tv/media/dvb/video-set-highlight.rst
@@ -6,18 +6,19 @@
 VIDEO_SET_HIGHLIGHT
 ===================
 
-NAME
+Name
 ----
 
 VIDEO_SET_HIGHLIGHT
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int ioctl(fd, int request = VIDEO_SET_HIGHLIGHT ,video_highlight_t *vhilite)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -44,14 +45,14 @@ ARGUMENTS
        -  SPU Highlight information according to section ??.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl sets the SPU highlight information for the menu access of a
 DVD.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/video-set-id.rst b/Documentation/linux_tv/media/dvb/video-set-id.rst
index 31ca41f8b6af..61993ab354ca 100644
--- a/Documentation/linux_tv/media/dvb/video-set-id.rst
+++ b/Documentation/linux_tv/media/dvb/video-set-id.rst
@@ -6,18 +6,19 @@
 VIDEO_SET_ID
 ============
 
-NAME
+Name
 ----
 
 VIDEO_SET_ID
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int ioctl(int fd, int request = VIDEO_SET_ID, int id)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -44,14 +45,14 @@ ARGUMENTS
        -  video sub-stream id
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl selects which sub-stream is to be decoded if a program or
 system stream is sent to the video device.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/video-set-spu-palette.rst b/Documentation/linux_tv/media/dvb/video-set-spu-palette.rst
index b3b727fec64b..ae9e0da5fd0b 100644
--- a/Documentation/linux_tv/media/dvb/video-set-spu-palette.rst
+++ b/Documentation/linux_tv/media/dvb/video-set-spu-palette.rst
@@ -6,18 +6,19 @@
 VIDEO_SET_SPU_PALETTE
 =====================
 
-NAME
+Name
 ----
 
 VIDEO_SET_SPU_PALETTE
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int ioctl(fd, int request = VIDEO_SET_SPU_PALETTE, video_spu_palette_t *palette )
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -44,13 +45,13 @@ ARGUMENTS
        -  SPU palette according to section ??.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl sets the SPU color palette.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/video-set-spu.rst b/Documentation/linux_tv/media/dvb/video-set-spu.rst
index d00d0b5272d7..ce2860574f20 100644
--- a/Documentation/linux_tv/media/dvb/video-set-spu.rst
+++ b/Documentation/linux_tv/media/dvb/video-set-spu.rst
@@ -6,18 +6,19 @@
 VIDEO_SET_SPU
 =============
 
-NAME
+Name
 ----
 
 VIDEO_SET_SPU
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int ioctl(fd, int request = VIDEO_SET_SPU , video_spu_t *spu)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -45,14 +46,14 @@ ARGUMENTS
 	  ??.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl activates or deactivates SPU decoding in a DVD input stream.
 It can only be used, if the driver is able to handle a DVD stream.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/video-set-streamtype.rst b/Documentation/linux_tv/media/dvb/video-set-streamtype.rst
index 6875ff8db77e..a2055369f0cd 100644
--- a/Documentation/linux_tv/media/dvb/video-set-streamtype.rst
+++ b/Documentation/linux_tv/media/dvb/video-set-streamtype.rst
@@ -6,18 +6,19 @@
 VIDEO_SET_STREAMTYPE
 ====================
 
-NAME
+Name
 ----
 
 VIDEO_SET_STREAMTYPE
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int ioctl(fd, int request = VIDEO_SET_STREAMTYPE, int type)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -44,7 +45,7 @@ ARGUMENTS
        -  stream type
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl tells the driver which kind of stream to expect being written
@@ -52,7 +53,7 @@ to it. If this call is not used the default of video PES is used. Some
 drivers might not support this call and always expect PES.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/video-set-system.rst b/Documentation/linux_tv/media/dvb/video-set-system.rst
index 7fcd1a1fb78b..f84906a7d1f4 100644
--- a/Documentation/linux_tv/media/dvb/video-set-system.rst
+++ b/Documentation/linux_tv/media/dvb/video-set-system.rst
@@ -6,18 +6,19 @@
 VIDEO_SET_SYSTEM
 ================
 
-NAME
+Name
 ----
 
 VIDEO_SET_SYSTEM
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int ioctl(fd, int request = VIDEO_SET_SYSTEM , video_system_t system)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -44,7 +45,7 @@ ARGUMENTS
        -  video system of TV output.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl sets the television output format. The format (see section
@@ -53,7 +54,7 @@ hardware is not able to display the requested format the call will
 return an error.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/video-slowmotion.rst b/Documentation/linux_tv/media/dvb/video-slowmotion.rst
index 6472abb1e42d..c8cc85af590b 100644
--- a/Documentation/linux_tv/media/dvb/video-slowmotion.rst
+++ b/Documentation/linux_tv/media/dvb/video-slowmotion.rst
@@ -6,18 +6,19 @@
 VIDEO_SLOWMOTION
 ================
 
-NAME
+Name
 ----
 
 VIDEO_SLOWMOTION
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int ioctl(fd, int request = VIDEO_SLOWMOTION, int nFrames)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -44,7 +45,7 @@ ARGUMENTS
        -  The number of times to repeat each frame.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl call asks the video device to repeat decoding frames N number
@@ -52,7 +53,7 @@ of times. This call can only be used if VIDEO_SOURCE_MEMORY is
 selected.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/video-stillpicture.rst b/Documentation/linux_tv/media/dvb/video-stillpicture.rst
index 93c9c30bcdd3..053cdbba4ed4 100644
--- a/Documentation/linux_tv/media/dvb/video-stillpicture.rst
+++ b/Documentation/linux_tv/media/dvb/video-stillpicture.rst
@@ -6,18 +6,19 @@
 VIDEO_STILLPICTURE
 ==================
 
-NAME
+Name
 ----
 
 VIDEO_STILLPICTURE
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int ioctl(fd, int request = VIDEO_STILLPICTURE, struct video_still_picture *sp)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -44,7 +45,7 @@ ARGUMENTS
        -  Pointer to a location where an I-frame and size is stored.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl call asks the Video Device to display a still picture
@@ -52,7 +53,7 @@ This ioctl call asks the Video Device to display a still picture
 NULL, then the current displayed still picture is blanked.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/video-stop.rst b/Documentation/linux_tv/media/dvb/video-stop.rst
index 2dbf464d85bb..4e7fbab4b8bc 100644
--- a/Documentation/linux_tv/media/dvb/video-stop.rst
+++ b/Documentation/linux_tv/media/dvb/video-stop.rst
@@ -6,18 +6,19 @@
 VIDEO_STOP
 ==========
 
-NAME
+Name
 ----
 
 VIDEO_STOP
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int ioctl(fd, int request = VIDEO_STOP, boolean mode)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -54,7 +55,7 @@ ARGUMENTS
        -  FALSE: Show last decoded frame.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl is for DVB devices only. To control a V4L2 decoder use the
@@ -65,7 +66,7 @@ stream. Depending on the input parameter, the screen can be blanked out
 or displaying the last decoded frame.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/video-try-command.rst b/Documentation/linux_tv/media/dvb/video-try-command.rst
index b30cfcd05682..be21fb01bd0f 100644
--- a/Documentation/linux_tv/media/dvb/video-try-command.rst
+++ b/Documentation/linux_tv/media/dvb/video-try-command.rst
@@ -6,18 +6,19 @@
 VIDEO_TRY_COMMAND
 =================
 
-NAME
+Name
 ----
 
 VIDEO_TRY_COMMAND
 
-SYNOPSIS
+
+Synopsis
 --------
 
 .. c:function:: int ioctl(int fd, int request = VIDEO_TRY_COMMAND, struct video_command *cmd)
 
 
-ARGUMENTS
+Arguments
 ---------
 
 .. flat-table::
@@ -44,7 +45,7 @@ ARGUMENTS
        -  Try a decoder command.
 
 
-DESCRIPTION
+Description
 -----------
 
 This ioctl is obsolete. Do not use in new drivers. For V4L2 decoders
@@ -57,7 +58,7 @@ subset of the ``v4l2_decoder_cmd`` struct, so refer to the
 for more information.
 
 
-RETURN VALUE
+Return Value
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/mediactl/media-func-close.rst b/Documentation/linux_tv/media/mediactl/media-func-close.rst
index 7ec0baa83482..3f3d9bb1f32a 100644
--- a/Documentation/linux_tv/media/mediactl/media-func-close.rst
+++ b/Documentation/linux_tv/media/mediactl/media-func-close.rst
@@ -6,12 +6,13 @@
 media close()
 *************
 
-NAME
+Name
 ====
 
 media-close - Close a media device
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. code-block:: c
@@ -22,21 +23,21 @@ SYNOPSIS
 .. cpp:function:: int close( int fd )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
 
-DESCRIPTION
+Description
 ===========
 
 Closes the media device. Resources associated with the file descriptor
 are freed. The device configuration remain unchanged.
 
 
-RETURN VALUE
+Return Value
 ============
 
 :ref:`close() <func-close>` returns 0 on success. On error, -1 is returned, and
diff --git a/Documentation/linux_tv/media/mediactl/media-func-ioctl.rst b/Documentation/linux_tv/media/mediactl/media-func-ioctl.rst
index 0d8f706b7e74..1b28e2d20de4 100644
--- a/Documentation/linux_tv/media/mediactl/media-func-ioctl.rst
+++ b/Documentation/linux_tv/media/mediactl/media-func-ioctl.rst
@@ -6,12 +6,13 @@
 media ioctl()
 *************
 
-NAME
+Name
 ====
 
 media-ioctl - Control a media device
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. code-block:: c
@@ -22,7 +23,7 @@ SYNOPSIS
 .. cpp:function:: int ioctl( int fd, int request, void *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -36,7 +37,7 @@ ARGUMENTS
     Pointer to a request-specific structure.
 
 
-DESCRIPTION
+Description
 ===========
 
 The :ref:`ioctl() <func-ioctl>` function manipulates media device parameters.
@@ -52,7 +53,7 @@ requests, their respective function and parameters are specified in
 :ref:`media-user-func`.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/mediactl/media-func-open.rst b/Documentation/linux_tv/media/mediactl/media-func-open.rst
index 353114fcb7ca..43b9ddc5c38f 100644
--- a/Documentation/linux_tv/media/mediactl/media-func-open.rst
+++ b/Documentation/linux_tv/media/mediactl/media-func-open.rst
@@ -6,12 +6,13 @@
 media open()
 ************
 
-NAME
+Name
 ====
 
 media-open - Open a media device
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. code-block:: c
@@ -22,7 +23,7 @@ SYNOPSIS
 .. cpp:function:: int open( const char *device_name, int flags )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``device_name``
@@ -33,7 +34,7 @@ ARGUMENTS
     Other flags have no effect.
 
 
-DESCRIPTION
+Description
 ===========
 
 To open a media device applications call :ref:`open() <func-open>` with the
@@ -45,7 +46,7 @@ configuration will result in an error, and ``errno`` will be set to
 EBADF.
 
 
-RETURN VALUE
+Return Value
 ============
 
 :ref:`open() <func-open>` returns the new file descriptor on success. On error,
diff --git a/Documentation/linux_tv/media/mediactl/media-ioc-device-info.rst b/Documentation/linux_tv/media/mediactl/media-ioc-device-info.rst
index 52fe981a4036..cee8312bde7d 100644
--- a/Documentation/linux_tv/media/mediactl/media-ioc-device-info.rst
+++ b/Documentation/linux_tv/media/mediactl/media-ioc-device-info.rst
@@ -6,18 +6,19 @@
 ioctl MEDIA_IOC_DEVICE_INFO
 ***************************
 
-NAME
+Name
 ====
 
 MEDIA_IOC_DEVICE_INFO - Query device information
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct media_device_info *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -29,7 +30,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 All media devices must support the ``MEDIA_IOC_DEVICE_INFO`` ioctl. To
@@ -133,7 +134,7 @@ used instead. The ``bus_info`` field is guaranteed to be unique, but can
 vary across reboots or device unplug/replug.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/mediactl/media-ioc-enum-entities.rst b/Documentation/linux_tv/media/mediactl/media-ioc-enum-entities.rst
index 5d11572d4848..f11c45ad7278 100644
--- a/Documentation/linux_tv/media/mediactl/media-ioc-enum-entities.rst
+++ b/Documentation/linux_tv/media/mediactl/media-ioc-enum-entities.rst
@@ -6,18 +6,19 @@
 ioctl MEDIA_IOC_ENUM_ENTITIES
 *****************************
 
-NAME
+Name
 ====
 
 MEDIA_IOC_ENUM_ENTITIES - Enumerate entities and their properties
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct media_entity_desc *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -29,7 +30,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 To query the attributes of an entity, applications set the id field of a
@@ -183,7 +184,7 @@ id's until they get an error.
        -
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/mediactl/media-ioc-enum-links.rst b/Documentation/linux_tv/media/mediactl/media-ioc-enum-links.rst
index 88bf10b35ff0..cc3cc3d2400b 100644
--- a/Documentation/linux_tv/media/mediactl/media-ioc-enum-links.rst
+++ b/Documentation/linux_tv/media/mediactl/media-ioc-enum-links.rst
@@ -6,18 +6,19 @@
 ioctl MEDIA_IOC_ENUM_LINKS
 **************************
 
-NAME
+Name
 ====
 
 MEDIA_IOC_ENUM_LINKS - Enumerate all pads and links for a given entity
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct media_links_enum *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -29,7 +30,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 To enumerate pads and/or links for a given entity, applications set the
@@ -159,7 +160,7 @@ returned during the enumeration process.
        -  Link flags, see :ref:`media-link-flag` for more details.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/mediactl/media-ioc-g-topology.rst b/Documentation/linux_tv/media/mediactl/media-ioc-g-topology.rst
index 34d46010c971..badcdf6133e2 100644
--- a/Documentation/linux_tv/media/mediactl/media-ioc-g-topology.rst
+++ b/Documentation/linux_tv/media/mediactl/media-ioc-g-topology.rst
@@ -6,18 +6,19 @@
 ioctl MEDIA_IOC_G_TOPOLOGY
 **************************
 
-NAME
+Name
 ====
 
 MEDIA_IOC_G_TOPOLOGY - Enumerate the graph topology and graph element properties
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct media_v2_topology *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -29,7 +30,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 The typical usage of this ioctl is to call it twice. On the first call,
@@ -410,7 +411,7 @@ desired arrays with the media graph elements.
 	  this array to zero.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/mediactl/media-ioc-setup-link.rst b/Documentation/linux_tv/media/mediactl/media-ioc-setup-link.rst
index f02edbcd3048..57ae5bcc646a 100644
--- a/Documentation/linux_tv/media/mediactl/media-ioc-setup-link.rst
+++ b/Documentation/linux_tv/media/mediactl/media-ioc-setup-link.rst
@@ -6,18 +6,19 @@
 ioctl MEDIA_IOC_SETUP_LINK
 **************************
 
-NAME
+Name
 ====
 
 MEDIA_IOC_SETUP_LINK - Modify the properties of a link
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct media_link_desc *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -29,7 +30,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 To change link properties applications fill a struct
@@ -54,7 +55,7 @@ If the specified link can't be found the driver returns with an ``EINVAL``
 error code.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/func-close.rst b/Documentation/linux_tv/media/v4l/func-close.rst
index 81401cd26d12..926a2ccc32e5 100644
--- a/Documentation/linux_tv/media/v4l/func-close.rst
+++ b/Documentation/linux_tv/media/v4l/func-close.rst
@@ -6,12 +6,13 @@
 V4L2 close()
 ************
 
-NAME
+Name
 ====
 
 v4l2-close - Close a V4L2 device
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. code-block:: c
@@ -22,14 +23,14 @@ SYNOPSIS
 .. cpp:function:: int close( int fd )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
 
-DESCRIPTION
+Description
 ===========
 
 Closes the device. Any I/O in progress is terminated and resources
@@ -38,7 +39,7 @@ parameters, current input or output, control values or other properties
 remain unchanged.
 
 
-RETURN VALUE
+Return Value
 ============
 
 The function returns 0 on success, -1 on failure and the ``errno`` is
diff --git a/Documentation/linux_tv/media/v4l/func-ioctl.rst b/Documentation/linux_tv/media/v4l/func-ioctl.rst
index 91917e976dd0..5632f48fce1b 100644
--- a/Documentation/linux_tv/media/v4l/func-ioctl.rst
+++ b/Documentation/linux_tv/media/v4l/func-ioctl.rst
@@ -6,12 +6,13 @@
 V4L2 ioctl()
 ************
 
-NAME
+Name
 ====
 
 v4l2-ioctl - Program a V4L2 device
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. code-block:: c
@@ -22,7 +23,7 @@ SYNOPSIS
 .. cpp:function:: int ioctl( int fd, int request, void *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -36,7 +37,7 @@ ARGUMENTS
     Pointer to a function parameter, usually a structure.
 
 
-DESCRIPTION
+Description
 ===========
 
 The :ref:`ioctl() <func-ioctl>` function is used to program V4L2 devices. The
@@ -50,7 +51,7 @@ All V4L2 ioctl requests, their respective function and parameters are
 specified in :ref:`user-func`.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/func-mmap.rst b/Documentation/linux_tv/media/v4l/func-mmap.rst
index 01a45e217265..3502c2afd894 100644
--- a/Documentation/linux_tv/media/v4l/func-mmap.rst
+++ b/Documentation/linux_tv/media/v4l/func-mmap.rst
@@ -6,12 +6,13 @@
 V4L2 mmap()
 ***********
 
-NAME
+Name
 ====
 
 v4l2-mmap - Map device memory into application address space
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. code-block:: c
@@ -23,7 +24,7 @@ SYNOPSIS
 .. cpp:function:: void *mmap( void *start, size_t length, int prot, int flags, int fd, off_t offset )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``start``
@@ -90,7 +91,7 @@ ARGUMENTS
     ``mem_offset`` field for the multi-planar API.
 
 
-DESCRIPTION
+Description
 ===========
 
 The :ref:`mmap() <func-mmap>` function asks to map ``length`` bytes starting at
@@ -106,7 +107,7 @@ before they can be queried.
 To unmap buffers the :ref:`munmap() <func-munmap>` function is used.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success :ref:`mmap() <func-mmap>` returns a pointer to the mapped buffer. On
diff --git a/Documentation/linux_tv/media/v4l/func-munmap.rst b/Documentation/linux_tv/media/v4l/func-munmap.rst
index a6e7a6def558..c29c03f21279 100644
--- a/Documentation/linux_tv/media/v4l/func-munmap.rst
+++ b/Documentation/linux_tv/media/v4l/func-munmap.rst
@@ -6,12 +6,13 @@
 V4L2 munmap()
 *************
 
-NAME
+Name
 ====
 
 v4l2-munmap - Unmap device memory
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. code-block:: c
@@ -23,7 +24,7 @@ SYNOPSIS
 .. cpp:function:: int munmap( void *start, size_t length )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``start``
@@ -39,14 +40,14 @@ ARGUMENTS
     multi-planar API.
 
 
-DESCRIPTION
+Description
 ===========
 
 Unmaps a previously with the :ref:`mmap() <func-mmap>` function mapped
 buffer and frees it, if possible.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success :ref:`munmap() <func-munmap>` returns 0, on failure -1 and the
diff --git a/Documentation/linux_tv/media/v4l/func-open.rst b/Documentation/linux_tv/media/v4l/func-open.rst
index 152174e6f646..06bcadc269a4 100644
--- a/Documentation/linux_tv/media/v4l/func-open.rst
+++ b/Documentation/linux_tv/media/v4l/func-open.rst
@@ -6,12 +6,13 @@
 V4L2 open()
 ***********
 
-NAME
+Name
 ====
 
 v4l2-open - Open a V4L2 device
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. code-block:: c
@@ -22,7 +23,7 @@ SYNOPSIS
 .. cpp:function:: int open( const char *device_name, int flags )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``device_name``
@@ -43,7 +44,7 @@ ARGUMENTS
     Other flags have no effect.
 
 
-DESCRIPTION
+Description
 ===========
 
 To open a V4L2 device applications call :ref:`open() <func-open>` with the
@@ -54,7 +55,7 @@ driver they will be reset to default values, drivers are never in an
 undefined state.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success :ref:`open() <func-open>` returns the new file descriptor. On error
diff --git a/Documentation/linux_tv/media/v4l/func-poll.rst b/Documentation/linux_tv/media/v4l/func-poll.rst
index 8632e05ff5b2..e6ceb712b783 100644
--- a/Documentation/linux_tv/media/v4l/func-poll.rst
+++ b/Documentation/linux_tv/media/v4l/func-poll.rst
@@ -6,12 +6,13 @@
 V4L2 poll()
 ***********
 
-NAME
+Name
 ====
 
 v4l2-poll - Wait for some event on a file descriptor
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. code-block:: c
@@ -22,12 +23,12 @@ SYNOPSIS
 .. cpp:function:: int poll( struct pollfd *ufds, unsigned int nfds, int timeout )
 
 
-ARGUMENTS
+Arguments
 =========
 
 
 
-DESCRIPTION
+Description
 ===========
 
 With the :ref:`poll() <func-poll>` function applications can suspend execution
@@ -90,7 +91,7 @@ function.
 For more details see the :ref:`poll() <func-poll>` manual page.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success, :ref:`poll() <func-poll>` returns the number structures which have
diff --git a/Documentation/linux_tv/media/v4l/func-read.rst b/Documentation/linux_tv/media/v4l/func-read.rst
index c4f0e8ab9e14..9a2aa5210233 100644
--- a/Documentation/linux_tv/media/v4l/func-read.rst
+++ b/Documentation/linux_tv/media/v4l/func-read.rst
@@ -6,12 +6,13 @@
 V4L2 read()
 ***********
 
-NAME
+Name
 ====
 
 v4l2-read - Read from a V4L2 device
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. code-block:: c
@@ -22,7 +23,7 @@ SYNOPSIS
 .. cpp:function:: ssize_t read( int fd, void *buf, size_t count )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -32,7 +33,7 @@ ARGUMENTS
 ``count``
 
 
-DESCRIPTION
+Description
 ===========
 
 :ref:`read() <func-read>` attempts to read up to ``count`` bytes from file
@@ -92,7 +93,7 @@ however. The discarding policy is not reported and cannot be changed.
 For minimum requirements see :ref:`devices`.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success, the number of bytes read is returned. It is not an error if
diff --git a/Documentation/linux_tv/media/v4l/func-select.rst b/Documentation/linux_tv/media/v4l/func-select.rst
index 34ade67d0f68..954dd00b8301 100644
--- a/Documentation/linux_tv/media/v4l/func-select.rst
+++ b/Documentation/linux_tv/media/v4l/func-select.rst
@@ -6,12 +6,13 @@
 V4L2 select()
 *************
 
-NAME
+Name
 ====
 
 v4l2-select - Synchronous I/O multiplexing
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. code-block:: c
@@ -24,12 +25,12 @@ SYNOPSIS
 .. cpp:function:: int select( int nfds, fd_set *readfds, fd_set *writefds, fd_set *exceptfds, struct timeval *timeout )
 
 
-ARGUMENTS
+Arguments
 =========
 
 
 
-DESCRIPTION
+Description
 ===========
 
 With the :ref:`select() <func-select>` function applications can suspend
@@ -71,7 +72,7 @@ function.
 For more details see the :ref:`select() <func-select>` manual page.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success, :ref:`select() <func-select>` returns the number of descriptors
diff --git a/Documentation/linux_tv/media/v4l/func-write.rst b/Documentation/linux_tv/media/v4l/func-write.rst
index 6609f191af76..a3bc9b26fe56 100644
--- a/Documentation/linux_tv/media/v4l/func-write.rst
+++ b/Documentation/linux_tv/media/v4l/func-write.rst
@@ -6,12 +6,13 @@
 V4L2 write()
 ************
 
-NAME
+Name
 ====
 
 v4l2-write - Write to a V4L2 device
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. code-block:: c
@@ -22,7 +23,7 @@ SYNOPSIS
 .. cpp:function:: ssize_t write( int fd, void *buf, size_t count )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -32,7 +33,7 @@ ARGUMENTS
 ``count``
 
 
-DESCRIPTION
+Description
 ===========
 
 :ref:`write() <func-write>` writes up to ``count`` bytes to the device
@@ -47,7 +48,7 @@ Sliced Teletext or Closed Caption data is not repeated, the driver
 inserts a blank line instead.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success, the number of bytes written are returned. Zero indicates
diff --git a/Documentation/linux_tv/media/v4l/vidioc-create-bufs.rst b/Documentation/linux_tv/media/v4l/vidioc-create-bufs.rst
index fe179197536d..abdc0b4d83d5 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-create-bufs.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-create-bufs.rst
@@ -6,18 +6,19 @@
 ioctl VIDIOC_CREATE_BUFS
 ************************
 
-NAME
+Name
 ====
 
 VIDIOC_CREATE_BUFS - Create buffers for Memory Mapped or User Pointer or DMA Buffer I/O
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_create_buffers *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -29,7 +30,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 This ioctl is used to create buffers for :ref:`memory mapped <mmap>`
@@ -130,7 +131,7 @@ than the number requested.
 	  must set the array to zero.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-cropcap.rst b/Documentation/linux_tv/media/v4l/vidioc-cropcap.rst
index 17ae3aa738b0..8dcbe6d26219 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-cropcap.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-cropcap.rst
@@ -6,18 +6,19 @@
 ioctl VIDIOC_CROPCAP
 ********************
 
-NAME
+Name
 ====
 
 VIDIOC_CROPCAP - Information about the video cropping and scaling abilities
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_cropcap *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -29,7 +30,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 Applications use this function to query the cropping limits, the pixel
@@ -154,7 +155,7 @@ overlay devices.
        -  Height of the rectangle, in pixels.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-dbg-g-chip-info.rst b/Documentation/linux_tv/media/v4l/vidioc-dbg-g-chip-info.rst
index 913c6d47d821..efa911c0fb19 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-dbg-g-chip-info.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-dbg-g-chip-info.rst
@@ -6,18 +6,19 @@
 ioctl VIDIOC_DBG_G_CHIP_INFO
 ****************************
 
-NAME
+Name
 ====
 
 VIDIOC_DBG_G_CHIP_INFO - Identify the chips on a TV card
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_dbg_chip_info *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -29,7 +30,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
     **Note**
@@ -192,7 +193,7 @@ instructions.
        -  Match the nth sub-device.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-dbg-g-register.rst b/Documentation/linux_tv/media/v4l/vidioc-dbg-g-register.rst
index 185a011a117c..345aa321f380 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-dbg-g-register.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-dbg-g-register.rst
@@ -6,12 +6,13 @@
 ioctl VIDIOC_DBG_G_REGISTER, VIDIOC_DBG_S_REGISTER
 **************************************************
 
-NAME
+Name
 ====
 
 VIDIOC_DBG_G_REGISTER - VIDIOC_DBG_S_REGISTER - Read or write hardware registers
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_dbg_register *argp )
@@ -19,7 +20,7 @@ SYNOPSIS
 .. cpp:function:: int ioctl( int fd, int request, const struct v4l2_dbg_register *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -31,7 +32,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
     **Note**
@@ -196,7 +197,7 @@ instructions.
        -  Match the nth sub-device.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-decoder-cmd.rst b/Documentation/linux_tv/media/v4l/vidioc-decoder-cmd.rst
index bb6d9b8cf122..2a36e91b57b9 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-decoder-cmd.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-decoder-cmd.rst
@@ -6,18 +6,19 @@
 ioctl VIDIOC_DECODER_CMD, VIDIOC_TRY_DECODER_CMD
 ************************************************
 
-NAME
+Name
 ====
 
 VIDIOC_DECODER_CMD - VIDIOC_TRY_DECODER_CMD - Execute an decoder command
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_decoder_cmd *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -29,7 +30,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 These ioctls control an audio/video (usually MPEG-) decoder.
@@ -255,7 +256,7 @@ introduced in Linux 3.3.
 	  flags are defined for this command.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-dqevent.rst b/Documentation/linux_tv/media/v4l/vidioc-dqevent.rst
index 850cb5ed0015..73c0d5be62ee 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-dqevent.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-dqevent.rst
@@ -6,18 +6,19 @@
 ioctl VIDIOC_DQEVENT
 ********************
 
-NAME
+Name
 ====
 
 VIDIOC_DQEVENT - Dequeue event
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_event *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -29,7 +30,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 Dequeue an event from a video device. No input is required for this
@@ -564,7 +565,7 @@ call.
 	  decoder.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-dv-timings-cap.rst b/Documentation/linux_tv/media/v4l/vidioc-dv-timings-cap.rst
index 61fef531363c..b56cdef7673e 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-dv-timings-cap.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-dv-timings-cap.rst
@@ -6,18 +6,19 @@
 ioctl VIDIOC_DV_TIMINGS_CAP, VIDIOC_SUBDEV_DV_TIMINGS_CAP
 *********************************************************
 
-NAME
+Name
 ====
 
 VIDIOC_DV_TIMINGS_CAP - VIDIOC_SUBDEV_DV_TIMINGS_CAP - The capabilities of the Digital Video receiver/transmitter
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_dv_timings_cap *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -29,7 +30,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 To query the capabilities of the DV receiver/transmitter applications
@@ -241,7 +242,7 @@ that doesn't support them will return an ``EINVAL`` error code.
 	  the standards set in the ``standards`` field.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-encoder-cmd.rst b/Documentation/linux_tv/media/v4l/vidioc-encoder-cmd.rst
index 1991014fd6b5..69bd9b4e0e56 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-encoder-cmd.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-encoder-cmd.rst
@@ -6,18 +6,19 @@
 ioctl VIDIOC_ENCODER_CMD, VIDIOC_TRY_ENCODER_CMD
 ************************************************
 
-NAME
+Name
 ====
 
 VIDIOC_ENCODER_CMD - VIDIOC_TRY_ENCODER_CMD - Execute an encoder command
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_encoder_cmd *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -29,7 +30,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 These ioctls control an audio/video (usually MPEG-) encoder.
@@ -179,7 +180,7 @@ introduced in Linux 2.6.21.
 	  rather than immediately.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enum-dv-timings.rst b/Documentation/linux_tv/media/v4l/vidioc-enum-dv-timings.rst
index 41fa4313c1c2..f0dd0c4ca7d0 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enum-dv-timings.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enum-dv-timings.rst
@@ -6,18 +6,19 @@
 ioctl VIDIOC_ENUM_DV_TIMINGS, VIDIOC_SUBDEV_ENUM_DV_TIMINGS
 ***********************************************************
 
-NAME
+Name
 ====
 
 VIDIOC_ENUM_DV_TIMINGS - VIDIOC_SUBDEV_ENUM_DV_TIMINGS - Enumerate supported Digital Video timings
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_enum_dv_timings *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -29,7 +30,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 While some DV receivers or transmitters support a wide range of timings,
@@ -103,7 +104,7 @@ return an ``EINVAL`` error code.
        -  The timings.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enum-fmt.rst b/Documentation/linux_tv/media/v4l/vidioc-enum-fmt.rst
index 3b935b07837a..257c624e27be 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enum-fmt.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enum-fmt.rst
@@ -6,18 +6,19 @@
 ioctl VIDIOC_ENUM_FMT
 *********************
 
-NAME
+Name
 ====
 
 VIDIOC_ENUM_FMT - Enumerate image formats
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_fmtdesc *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -29,7 +30,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 To enumerate image formats applications initialize the ``type`` and
@@ -151,7 +152,7 @@ formats may be different.
 	  format instead for better performance.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enum-frameintervals.rst b/Documentation/linux_tv/media/v4l/vidioc-enum-frameintervals.rst
index 3336a166b878..5d5de535a0fe 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enum-frameintervals.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enum-frameintervals.rst
@@ -6,18 +6,19 @@
 ioctl VIDIOC_ENUM_FRAMEINTERVALS
 ********************************
 
-NAME
+Name
 ====
 
 VIDIOC_ENUM_FRAMEINTERVALS - Enumerate frame intervals
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_frmivalenum *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -32,7 +33,7 @@ ARGUMENTS
     interval.
 
 
-DESCRIPTION
+Description
 ===========
 
 This ioctl allows applications to enumerate all frame intervals that the
@@ -265,7 +266,7 @@ Enums
        -  Step-wise defined frame interval.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enum-framesizes.rst b/Documentation/linux_tv/media/v4l/vidioc-enum-framesizes.rst
index d01fffaeda04..d3b2e97df6c9 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enum-framesizes.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enum-framesizes.rst
@@ -6,18 +6,19 @@
 ioctl VIDIOC_ENUM_FRAMESIZES
 ****************************
 
-NAME
+Name
 ====
 
 VIDIOC_ENUM_FRAMESIZES - Enumerate frame sizes
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_frmsizeenum *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -32,7 +33,7 @@ ARGUMENTS
     and height.
 
 
-DESCRIPTION
+Description
 ===========
 
 This ioctl allows applications to enumerate all frame sizes (i. e. width
@@ -282,7 +283,7 @@ Enums
        -  Step-wise defined frame size.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enum-freq-bands.rst b/Documentation/linux_tv/media/v4l/vidioc-enum-freq-bands.rst
index 7fdde4be282c..ea754f4f5532 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enum-freq-bands.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enum-freq-bands.rst
@@ -6,18 +6,19 @@
 ioctl VIDIOC_ENUM_FREQ_BANDS
 ****************************
 
-NAME
+Name
 ====
 
 VIDIOC_ENUM_FREQ_BANDS - Enumerate supported frequency bands
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_frequency_band *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -29,7 +30,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 Enumerates the frequency bands that a tuner or modulator supports. To do
@@ -177,7 +178,7 @@ of the corresponding tuner/modulator is set.
        -  Amplitude Modulation, commonly used for analog radio.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enumaudio.rst b/Documentation/linux_tv/media/v4l/vidioc-enumaudio.rst
index f833e581f7c3..bfdc3533240d 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enumaudio.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enumaudio.rst
@@ -6,18 +6,19 @@
 ioctl VIDIOC_ENUMAUDIO
 **********************
 
-NAME
+Name
 ====
 
 VIDIOC_ENUMAUDIO - Enumerate audio inputs
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_audio *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -29,7 +30,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 To query the attributes of an audio input applications initialize the
@@ -44,7 +45,7 @@ See :ref:`VIDIOC_G_AUDIO <VIDIOC_G_AUDIO>` for a description of struct
 :ref:`v4l2_audio <v4l2-audio>`.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enumaudioout.rst b/Documentation/linux_tv/media/v4l/vidioc-enumaudioout.rst
index f2caf6c71f44..4c1756319c09 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enumaudioout.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enumaudioout.rst
@@ -6,18 +6,19 @@
 ioctl VIDIOC_ENUMAUDOUT
 ***********************
 
-NAME
+Name
 ====
 
 VIDIOC_ENUMAUDOUT - Enumerate audio outputs
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_audioout *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -29,7 +30,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 To query the attributes of an audio output applications initialize the
@@ -47,7 +48,7 @@ See :ref:`VIDIOC_G_AUDIOout <VIDIOC_G_AUDIOout>` for a description of struct
 :ref:`v4l2_audioout <v4l2-audioout>`.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enuminput.rst b/Documentation/linux_tv/media/v4l/vidioc-enuminput.rst
index 01a1cadc71d2..c1fc2e1f1d98 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enuminput.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enuminput.rst
@@ -6,18 +6,19 @@
 ioctl VIDIOC_ENUMINPUT
 **********************
 
-NAME
+Name
 ====
 
 VIDIOC_ENUMINPUT - Enumerate video inputs
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_input *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -29,7 +30,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 To query the attributes of a video input applications initialize the
@@ -354,7 +355,7 @@ at index zero, incrementing by one until the driver returns ``EINVAL``.
 	  :ref:`v4l2-selections-common`.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enumoutput.rst b/Documentation/linux_tv/media/v4l/vidioc-enumoutput.rst
index 99c70e54c4d6..82fc9d3b237f 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enumoutput.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enumoutput.rst
@@ -6,18 +6,19 @@
 ioctl VIDIOC_ENUMOUTPUT
 ***********************
 
-NAME
+Name
 ====
 
 VIDIOC_ENUMOUTPUT - Enumerate video outputs
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_output *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -29,7 +30,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 To query the attributes of a video outputs applications initialize the
@@ -209,7 +210,7 @@ EINVAL.
 	  :ref:`v4l2-selections-common`.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enumstd.rst b/Documentation/linux_tv/media/v4l/vidioc-enumstd.rst
index e74514ea4437..ce911c81bd3d 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enumstd.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enumstd.rst
@@ -6,18 +6,19 @@
 ioctl VIDIOC_ENUMSTD
 ********************
 
-NAME
+Name
 ====
 
 VIDIOC_ENUMSTD - Enumerate supported video standards
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_standard *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -29,7 +30,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 To query the attributes of a video standard, especially a custom (driver
@@ -385,7 +386,7 @@ support digital TV. See also the Linux DVB API at
        -  + 6.5  [8]_
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-expbuf.rst b/Documentation/linux_tv/media/v4l/vidioc-expbuf.rst
index 2c08a349ab45..ded708e647fa 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-expbuf.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-expbuf.rst
@@ -6,18 +6,19 @@
 ioctl VIDIOC_EXPBUF
 *******************
 
-NAME
+Name
 ====
 
 VIDIOC_EXPBUF - Export a buffer as a DMABUF file descriptor.
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_exportbuffer *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -29,7 +30,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 This ioctl is an extension to the :ref:`memory mapping <mmap>` I/O
@@ -184,7 +185,7 @@ Examples
 	  the array to zero.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-audio.rst b/Documentation/linux_tv/media/v4l/vidioc-g-audio.rst
index 02db00a31722..cccbcdb8c463 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-audio.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-audio.rst
@@ -6,12 +6,13 @@
 ioctl VIDIOC_G_AUDIO, VIDIOC_S_AUDIO
 ************************************
 
-NAME
+Name
 ====
 
 VIDIOC_G_AUDIO - VIDIOC_S_AUDIO - Query or select the current audio input and its attributes
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_audio *argp )
@@ -19,7 +20,7 @@ SYNOPSIS
 .. cpp:function:: int ioctl( int fd, int request, const struct v4l2_audio *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -31,7 +32,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 To query the current audio input applications zero out the ``reserved``
@@ -149,7 +150,7 @@ return the actual new audio mode.
        -  AVL mode is on.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-audioout.rst b/Documentation/linux_tv/media/v4l/vidioc-g-audioout.rst
index 9265be57d0f9..e36b5a116332 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-audioout.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-audioout.rst
@@ -6,12 +6,13 @@
 ioctl VIDIOC_G_AUDOUT, VIDIOC_S_AUDOUT
 **************************************
 
-NAME
+Name
 ====
 
 VIDIOC_G_AUDOUT - VIDIOC_S_AUDOUT - Query or select the current audio output
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_audioout *argp )
@@ -19,7 +20,7 @@ SYNOPSIS
 .. cpp:function:: int ioctl( int fd, int request, const struct v4l2_audioout *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -31,7 +32,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 To query the current audio output applications zero out the ``reserved``
@@ -108,7 +109,7 @@ sound card are not audio outputs in this sense.
 	  the array to zero.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-crop.rst b/Documentation/linux_tv/media/v4l/vidioc-g-crop.rst
index 206fdd5f825f..6cf76497937c 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-crop.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-crop.rst
@@ -6,12 +6,13 @@
 ioctl VIDIOC_G_CROP, VIDIOC_S_CROP
 **********************************
 
-NAME
+Name
 ====
 
 VIDIOC_G_CROP - VIDIOC_S_CROP - Get or set the current cropping rectangle
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_crop *argp )
@@ -19,7 +20,7 @@ SYNOPSIS
 .. cpp:function:: int ioctl( int fd, int request, const struct v4l2_crop *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -31,7 +32,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 To query the cropping rectangle size and position applications set the
@@ -104,7 +105,7 @@ When cropping is not supported then no parameters are changed and
 	  :ref:`v4l2_cropcap <v4l2-cropcap>` ``bounds`` is used.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst b/Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst
index 50fddb140288..ee929f692ebe 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst
@@ -6,18 +6,19 @@
 ioctl VIDIOC_G_CTRL, VIDIOC_S_CTRL
 **********************************
 
-NAME
+Name
 ====
 
 VIDIOC_G_CTRL - VIDIOC_S_CTRL - Get or set the value of a control
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_control *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -29,7 +30,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 To get the current value of a control applications initialize the ``id``
@@ -78,7 +79,7 @@ These ioctls work only with user controls. For other control classes the
        -  New value or current value.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-dv-timings.rst b/Documentation/linux_tv/media/v4l/vidioc-g-dv-timings.rst
index f6e7fd261ebc..0dd93d1ee284 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-dv-timings.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-dv-timings.rst
@@ -6,18 +6,19 @@
 ioctl VIDIOC_G_DV_TIMINGS, VIDIOC_S_DV_TIMINGS
 **********************************************
 
-NAME
+Name
 ====
 
 VIDIOC_G_DV_TIMINGS - VIDIOC_S_DV_TIMINGS - VIDIOC_SUBDEV_G_DV_TIMINGS - VIDIOC_SUBDEV_S_DV_TIMINGS - Get or set DV timings for input or output
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_dv_timings *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -30,7 +31,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 To set DV timings for the input or output, applications use the
@@ -49,7 +50,7 @@ the current input or output does not support DV timings (e.g. if
 ``V4L2_IN_CAP_DV_TIMINGS`` flag), then ``ENODATA`` error code is returned.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-edid.rst b/Documentation/linux_tv/media/v4l/vidioc-g-edid.rst
index 1414026f5740..907b2c1764a3 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-edid.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-edid.rst
@@ -6,18 +6,19 @@
 ioctl VIDIOC_G_EDID, VIDIOC_S_EDID, VIDIOC_SUBDEV_G_EDID, VIDIOC_SUBDEV_S_EDID
 ******************************************************************************
 
-NAME
+Name
 ====
 
 VIDIOC_G_EDID - VIDIOC_S_EDID - VIDIOC_SUBDEV_G_EDID - VIDIOC_SUBDEV_S_EDID - Get or set the EDID of a video receiver/transmitter
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_edid *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -30,7 +31,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 These ioctls can be used to get or set an EDID associated with an input
@@ -143,7 +144,7 @@ EDID is no longer available.
 	  ``blocks`` * 128.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-enc-index.rst b/Documentation/linux_tv/media/v4l/vidioc-g-enc-index.rst
index 16f0e8135952..f0f41ac56b80 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-enc-index.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-enc-index.rst
@@ -6,18 +6,19 @@
 ioctl VIDIOC_G_ENC_INDEX
 ************************
 
-NAME
+Name
 ====
 
 VIDIOC_G_ENC_INDEX - Get meta data about a compressed video stream
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_enc_idx *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -29,7 +30,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 The :ref:`VIDIOC_G_ENC_INDEX <VIDIOC_G_ENC_INDEX>` ioctl provides meta data about a compressed
@@ -201,7 +202,7 @@ video elementary streams.
 	  type.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-ext-ctrls.rst b/Documentation/linux_tv/media/v4l/vidioc-g-ext-ctrls.rst
index 2f69b1cf804b..96b6eaca755c 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-ext-ctrls.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-ext-ctrls.rst
@@ -6,18 +6,19 @@
 ioctl VIDIOC_G_EXT_CTRLS, VIDIOC_S_EXT_CTRLS, VIDIOC_TRY_EXT_CTRLS
 ******************************************************************
 
-NAME
+Name
 ====
 
 VIDIOC_G_EXT_CTRLS - VIDIOC_S_EXT_CTRLS - VIDIOC_TRY_EXT_CTRLS - Get or set the value of several controls, try control values
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_ext_controls *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -30,7 +31,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 These ioctls allow the caller to get or set multiple controls
@@ -451,7 +452,7 @@ still cause this situation.
 	  described in :ref:`rf-tuner-controls`.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-fbuf.rst b/Documentation/linux_tv/media/v4l/vidioc-g-fbuf.rst
index 4d0799414420..ef4592c338ef 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-fbuf.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-fbuf.rst
@@ -6,12 +6,13 @@
 ioctl VIDIOC_G_FBUF, VIDIOC_S_FBUF
 **********************************
 
-NAME
+Name
 ====
 
 VIDIOC_G_FBUF - VIDIOC_S_FBUF - Get or set frame buffer overlay parameters
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_framebuffer *argp )
@@ -19,7 +20,7 @@ SYNOPSIS
 .. cpp:function:: int ioctl( int fd, int request, const struct v4l2_framebuffer *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -31,7 +32,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 Applications can use the :ref:`VIDIOC_G_FBUF <VIDIOC_G_FBUF>` and :ref:`VIDIOC_S_FBUF <VIDIOC_G_FBUF>` ioctl
@@ -477,7 +478,7 @@ destructive video overlay.
 	  :ref:`v4l2_window <v4l2-window>` is being used.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-fmt.rst b/Documentation/linux_tv/media/v4l/vidioc-g-fmt.rst
index aede100b668b..ee6f11978fd6 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-fmt.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-fmt.rst
@@ -6,18 +6,19 @@
 ioctl VIDIOC_G_FMT, VIDIOC_S_FMT, VIDIOC_TRY_FMT
 ************************************************
 
-NAME
+Name
 ====
 
 VIDIOC_G_FMT - VIDIOC_S_FMT - VIDIOC_TRY_FMT - Get or set the data format, try a format
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_format *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -29,7 +30,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 These ioctls are used to negotiate the format of data (typically image
@@ -175,7 +176,7 @@ The format as returned by :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` must be identical
        -  Place holder for future extensions.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-frequency.rst b/Documentation/linux_tv/media/v4l/vidioc-g-frequency.rst
index 2b921cda2e4d..a1fd2a870de4 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-frequency.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-frequency.rst
@@ -6,12 +6,13 @@
 ioctl VIDIOC_G_FREQUENCY, VIDIOC_S_FREQUENCY
 ********************************************
 
-NAME
+Name
 ====
 
 VIDIOC_G_FREQUENCY - VIDIOC_S_FREQUENCY - Get or set tuner or modulator radio frequency
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_frequency *argp )
@@ -19,7 +20,7 @@ SYNOPSIS
 .. cpp:function:: int ioctl( int fd, int request, const struct v4l2_frequency *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -31,7 +32,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 To get the current tuner or modulator radio frequency applications set
@@ -107,7 +108,7 @@ write-only ioctl, it does not return the actual new frequency.
 	  the array to zero.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-input.rst b/Documentation/linux_tv/media/v4l/vidioc-g-input.rst
index e069ba3952ea..29e22f6f8028 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-input.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-input.rst
@@ -6,18 +6,19 @@
 ioctl VIDIOC_G_INPUT, VIDIOC_S_INPUT
 ************************************
 
-NAME
+Name
 ====
 
 VIDIOC_G_INPUT - VIDIOC_S_INPUT - Query or select the current video input
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, int *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -29,7 +30,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 To query the current video input applications call the
@@ -50,7 +51,7 @@ Information about video inputs is available using the
 :ref:`VIDIOC_ENUMINPUT` ioctl.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-jpegcomp.rst b/Documentation/linux_tv/media/v4l/vidioc-g-jpegcomp.rst
index c8d3a3b53a51..f5bf8b7915ed 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-jpegcomp.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-jpegcomp.rst
@@ -6,12 +6,13 @@
 ioctl VIDIOC_G_JPEGCOMP, VIDIOC_S_JPEGCOMP
 ******************************************
 
-NAME
+Name
 ====
 
 VIDIOC_G_JPEGCOMP - VIDIOC_S_JPEGCOMP
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, v4l2_jpegcompression *argp )
@@ -19,7 +20,7 @@ SYNOPSIS
 .. cpp:function:: int ioctl( int fd, int request, const v4l2_jpegcompression *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -31,7 +32,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 These ioctls are **deprecated**. New drivers and applications should use
@@ -175,7 +176,7 @@ encoding. You usually do want to add them.
        -  App segment, driver will always use APP0
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-modulator.rst b/Documentation/linux_tv/media/v4l/vidioc-g-modulator.rst
index 21b9fea34b8c..05d83610bdc5 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-modulator.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-modulator.rst
@@ -6,12 +6,13 @@
 ioctl VIDIOC_G_MODULATOR, VIDIOC_S_MODULATOR
 ********************************************
 
-NAME
+Name
 ====
 
 VIDIOC_G_MODULATOR - VIDIOC_S_MODULATOR - Get or set modulator attributes
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_modulator *argp )
@@ -19,7 +20,7 @@ SYNOPSIS
 .. cpp:function:: int ioctl( int fd, int request, const struct v4l2_modulator *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -31,7 +32,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 To query the attributes of a modulator applications initialize the
@@ -242,7 +243,7 @@ To change the radio frequency the
        -  Enable the RDS encoder for a radio FM transmitter.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-output.rst b/Documentation/linux_tv/media/v4l/vidioc-g-output.rst
index c9fb075ec5d1..ae0ad577ba97 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-output.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-output.rst
@@ -6,18 +6,19 @@
 ioctl VIDIOC_G_OUTPUT, VIDIOC_S_OUTPUT
 **************************************
 
-NAME
+Name
 ====
 
 VIDIOC_G_OUTPUT - VIDIOC_S_OUTPUT - Query or select the current video output
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, int *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -29,7 +30,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 To query the current video output applications call the
@@ -51,7 +52,7 @@ Information about video outputs is available using the
 :ref:`VIDIOC_ENUMOUTPUT` ioctl.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-parm.rst b/Documentation/linux_tv/media/v4l/vidioc-g-parm.rst
index 964e3b8ce275..7116e0decddc 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-parm.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-parm.rst
@@ -6,18 +6,19 @@
 ioctl VIDIOC_G_PARM, VIDIOC_S_PARM
 **********************************
 
-NAME
+Name
 ====
 
 VIDIOC_G_PARM - VIDIOC_S_PARM - Get or set streaming parameters
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, v4l2_streamparm *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -29,7 +30,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 The current video standard determines a nominal number of frames per
@@ -340,7 +341,7 @@ union holding separate parameters for input and output devices.
 	  -  Capture might only work through the :ref:`read() <func-read>` call.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-priority.rst b/Documentation/linux_tv/media/v4l/vidioc-g-priority.rst
index 8255f2469cd9..4419195661f1 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-priority.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-priority.rst
@@ -6,12 +6,13 @@
 ioctl VIDIOC_G_PRIORITY, VIDIOC_S_PRIORITY
 ******************************************
 
-NAME
+Name
 ====
 
 VIDIOC_G_PRIORITY - VIDIOC_S_PRIORITY - Query or request the access priority associated with a file descriptor
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. c:function:: int ioctl( int fd, int request, enum v4l2_priority *argp )
@@ -19,7 +20,7 @@ SYNOPSIS
 .. c:function:: int ioctl( int fd, int request, const enum v4l2_priority *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -32,7 +33,7 @@ ARGUMENTS
     Pointer to an enum v4l2_priority type.
 
 
-DESCRIPTION
+Description
 ===========
 
 To query the current access priority applications call the
@@ -102,7 +103,7 @@ with a pointer to this variable.
 	  applications which must not be interrupted, like video recording.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-selection.rst b/Documentation/linux_tv/media/v4l/vidioc-g-selection.rst
index c4164eaafca8..953931fabd00 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-selection.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-selection.rst
@@ -6,18 +6,19 @@
 ioctl VIDIOC_G_SELECTION, VIDIOC_S_SELECTION
 ********************************************
 
-NAME
+Name
 ====
 
 VIDIOC_G_SELECTION - VIDIOC_S_SELECTION - Get or set one of the selection rectangles
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_selection *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -29,7 +30,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 The ioctls are used to query and configure selection rectangles.
@@ -187,7 +188,7 @@ Selection targets and flags are documented in
 	  this array.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-sliced-vbi-cap.rst b/Documentation/linux_tv/media/v4l/vidioc-g-sliced-vbi-cap.rst
index 466760241fdb..76dd4ba3254f 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-sliced-vbi-cap.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-sliced-vbi-cap.rst
@@ -6,18 +6,19 @@
 ioctl VIDIOC_G_SLICED_VBI_CAP
 *****************************
 
-NAME
+Name
 ====
 
 VIDIOC_G_SLICED_VBI_CAP - Query sliced VBI capabilities
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_sliced_vbi_cap *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -29,7 +30,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 To find out which data services are supported by a sliced VBI capture or
@@ -264,7 +265,7 @@ to write-read, in Linux 2.6.19.
        -  :cspan:`2` Set of services applicable to 625 line systems.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-std.rst b/Documentation/linux_tv/media/v4l/vidioc-g-std.rst
index 4fbc9e9bfeb8..5c2b861f8d26 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-std.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-std.rst
@@ -6,12 +6,13 @@
 ioctl VIDIOC_G_STD, VIDIOC_S_STD
 ********************************
 
-NAME
+Name
 ====
 
 VIDIOC_G_STD - VIDIOC_S_STD - Query or select the video standard of the current input
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, v4l2_std_id *argp )
@@ -19,7 +20,7 @@ SYNOPSIS
 .. cpp:function:: int ioctl( int fd, int request, const v4l2_std_id *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -31,7 +32,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 To query and select the current video standard applications use the
@@ -53,7 +54,7 @@ does not set the ``V4L2_IN_CAP_STD`` flag), then ``ENODATA`` error code is
 returned.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-tuner.rst b/Documentation/linux_tv/media/v4l/vidioc-g-tuner.rst
index fe904db57597..a8d7ebd73e8a 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-tuner.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-tuner.rst
@@ -6,12 +6,13 @@
 ioctl VIDIOC_G_TUNER, VIDIOC_S_TUNER
 ************************************
 
-NAME
+Name
 ====
 
 VIDIOC_G_TUNER - VIDIOC_S_TUNER - Get or set tuner attributes
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_tuner *argp )
@@ -19,7 +20,7 @@ SYNOPSIS
 .. cpp:function:: int ioctl( int fd, int request, const struct v4l2_tuner *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -31,7 +32,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 To query the attributes of a tuner applications initialize the ``index``
@@ -692,7 +693,7 @@ To change the radio frequency the
        -  Lang1/Lang2 (preferred) or Lang1/Lang1
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-log-status.rst b/Documentation/linux_tv/media/v4l/vidioc-log-status.rst
index d96d5e4f242a..66fc352c0ffa 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-log-status.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-log-status.rst
@@ -6,23 +6,24 @@
 ioctl VIDIOC_LOG_STATUS
 ***********************
 
-NAME
+Name
 ====
 
 VIDIOC_LOG_STATUS - Log driver status information
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request )
 
 
-ARGUMENTS
+Arguments
 =========
 
 
 
-DESCRIPTION
+Description
 ===========
 
 As the video/audio devices become more complicated it becomes harder to
@@ -37,7 +38,7 @@ This ioctl is optional and not all drivers support it. It was introduced
 in Linux 2.6.15.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-overlay.rst b/Documentation/linux_tv/media/v4l/vidioc-overlay.rst
index cd58a34a7ee8..191dbc144ef7 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-overlay.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-overlay.rst
@@ -6,18 +6,19 @@
 ioctl VIDIOC_OVERLAY
 ********************
 
-NAME
+Name
 ====
 
 VIDIOC_OVERLAY - Start or stop video overlay
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, const int *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -29,7 +30,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 This ioctl is part of the :ref:`video overlay <overlay>` I/O method.
@@ -42,7 +43,7 @@ Drivers do not support :ref:`VIDIOC_STREAMON` or
 ``V4L2_BUF_TYPE_VIDEO_OVERLAY``.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-prepare-buf.rst b/Documentation/linux_tv/media/v4l/vidioc-prepare-buf.rst
index 0f51082f8c93..79076dff46fd 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-prepare-buf.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-prepare-buf.rst
@@ -6,18 +6,19 @@
 ioctl VIDIOC_PREPARE_BUF
 ************************
 
-NAME
+Name
 ====
 
 VIDIOC_PREPARE_BUF - Prepare a buffer for I/O
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_buffer *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -29,7 +30,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 Applications can optionally call the :ref:`VIDIOC_PREPARE_BUF` ioctl to
@@ -45,7 +46,7 @@ The :ref:`struct v4l2_buffer <v4l2-buffer>` structure is specified in
 :ref:`buffer`.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-qbuf.rst b/Documentation/linux_tv/media/v4l/vidioc-qbuf.rst
index bf41f30cf9c4..9870d243131a 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-qbuf.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-qbuf.rst
@@ -6,18 +6,19 @@
 ioctl VIDIOC_QBUF, VIDIOC_DQBUF
 *******************************
 
-NAME
+Name
 ====
 
 VIDIOC_QBUF - VIDIOC_DQBUF - Exchange a buffer with the driver
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_buffer *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -29,7 +30,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 Applications call the ``VIDIOC_QBUF`` ioctl to enqueue an empty
@@ -116,7 +117,7 @@ The :ref:`struct v4l2_buffer <v4l2-buffer>` structure is specified in
 :ref:`buffer`.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-query-dv-timings.rst b/Documentation/linux_tv/media/v4l/vidioc-query-dv-timings.rst
index 38295fd5f1ad..338b80df5b9b 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-query-dv-timings.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-query-dv-timings.rst
@@ -6,18 +6,19 @@
 ioctl VIDIOC_QUERY_DV_TIMINGS
 *****************************
 
-NAME
+Name
 ====
 
 VIDIOC_QUERY_DV_TIMINGS - VIDIOC_SUBDEV_QUERY_DV_TIMINGS - Sense the DV preset received by the current input
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_dv_timings *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -29,7 +30,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 The hardware may be able to detect the current DV timings automatically,
@@ -61,7 +62,7 @@ found timings with the hardware's capabilities in order to give more
 precise feedback to the user.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-querybuf.rst b/Documentation/linux_tv/media/v4l/vidioc-querybuf.rst
index 6454c302644d..32af6f7b5060 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-querybuf.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-querybuf.rst
@@ -6,18 +6,19 @@
 ioctl VIDIOC_QUERYBUF
 *********************
 
-NAME
+Name
 ====
 
 VIDIOC_QUERYBUF - Query the status of a buffer
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_buffer *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -29,7 +30,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 This ioctl is part of the :ref:`streaming <mmap>` I/O method. It can
@@ -68,7 +69,7 @@ The :ref:`struct v4l2_buffer <v4l2-buffer>` structure is specified in
 :ref:`buffer`.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-querycap.rst b/Documentation/linux_tv/media/v4l/vidioc-querycap.rst
index 406c5eb34034..f0271f834ac1 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-querycap.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-querycap.rst
@@ -6,18 +6,19 @@
 ioctl VIDIOC_QUERYCAP
 *********************
 
-NAME
+Name
 ====
 
 VIDIOC_QUERYCAP - Query device capabilities
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_capability *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -29,7 +30,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 All V4L2 devices support the ``VIDIOC_QUERYCAP`` ioctl. It is used to
@@ -420,7 +421,7 @@ specification the ioctl returns an ``EINVAL`` error code.
 	  ``device_caps`` field.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-queryctrl.rst b/Documentation/linux_tv/media/v4l/vidioc-queryctrl.rst
index 4e0eb7b04fd2..0f27e712eec9 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-queryctrl.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-queryctrl.rst
@@ -6,12 +6,13 @@
 ioctls VIDIOC_QUERYCTRL, VIDIOC_QUERY_EXT_CTRL and VIDIOC_QUERYMENU
 *******************************************************************
 
-NAME
+Name
 ====
 
 VIDIOC_QUERYCTRL - VIDIOC_QUERY_EXT_CTRL - VIDIOC_QUERYMENU - Enumerate controls and menu control items
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_queryctrl *argp )
@@ -21,7 +22,7 @@ SYNOPSIS
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_querymenu *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -33,7 +34,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 To query the attributes of a control applications set the ``id`` field
@@ -753,7 +754,7 @@ See also the examples in :ref:`control`.
 	  ``V4L2_CTRL_TYPE_BUTTON`` have this flag set.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-querystd.rst b/Documentation/linux_tv/media/v4l/vidioc-querystd.rst
index fe540f80ef60..5bf62775c740 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-querystd.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-querystd.rst
@@ -6,18 +6,19 @@
 ioctl VIDIOC_QUERYSTD
 *********************
 
-NAME
+Name
 ====
 
 VIDIOC_QUERYSTD - Sense the video standard received by the current input
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, v4l2_std_id *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -29,7 +30,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 The hardware may be able to detect the current video standard
@@ -54,7 +55,7 @@ standard is valid they will have to stop streaming, set the new
 standard, allocate new buffers and start streaming again.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-reqbufs.rst b/Documentation/linux_tv/media/v4l/vidioc-reqbufs.rst
index 2e27708fd7a6..c25b0719c2ff 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-reqbufs.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-reqbufs.rst
@@ -6,18 +6,19 @@
 ioctl VIDIOC_REQBUFS
 ********************
 
-NAME
+Name
 ====
 
 VIDIOC_REQBUFS - Initiate Memory Mapping or User Pointer I/O
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_requestbuffers *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -29,7 +30,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 This ioctl is used to initiate :ref:`memory mapped <mmap>`,
@@ -112,7 +113,7 @@ any DMA in progress, an implicit
 	  must set the array to zero.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-s-hw-freq-seek.rst b/Documentation/linux_tv/media/v4l/vidioc-s-hw-freq-seek.rst
index 068a67e8a523..5fd332a5bfee 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-s-hw-freq-seek.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-s-hw-freq-seek.rst
@@ -6,18 +6,19 @@
 ioctl VIDIOC_S_HW_FREQ_SEEK
 ***************************
 
-NAME
+Name
 ====
 
 VIDIOC_S_HW_FREQ_SEEK - Perform a hardware frequency seek
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_hw_freq_seek *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -29,7 +30,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 Start a hardware frequency seek from the current frequency. To do this
@@ -155,7 +156,7 @@ error code is returned and no seek takes place.
 	  zero.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-streamon.rst b/Documentation/linux_tv/media/v4l/vidioc-streamon.rst
index 0e6b750f8718..e87500e608e1 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-streamon.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-streamon.rst
@@ -6,18 +6,19 @@
 ioctl VIDIOC_STREAMON, VIDIOC_STREAMOFF
 ***************************************
 
-NAME
+Name
 ====
 
 VIDIOC_STREAMON - VIDIOC_STREAMOFF - Start or stop streaming I/O
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, const int *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -29,7 +30,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 The ``VIDIOC_STREAMON`` and ``VIDIOC_STREAMOFF`` ioctl start and stop
@@ -81,7 +82,7 @@ no notion of starting or stopping "now". Buffer timestamps can be used
 to synchronize with other events.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-interval.rst b/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-interval.rst
index 0d2b690cf8bc..0aa6482a91a6 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-interval.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-interval.rst
@@ -6,18 +6,19 @@
 ioctl VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL
 ***************************************
 
-NAME
+Name
 ====
 
 VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL - Enumerate frame intervals
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_subdev_frame_interval_enum * argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -29,7 +30,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 This ioctl lets applications enumerate available frame intervals on a
@@ -137,7 +138,7 @@ multiple pads of the same sub-device is not defined.
 	  the array to zero.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-size.rst b/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-size.rst
index c52a02df5b16..7a5811b71b68 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-size.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-size.rst
@@ -6,18 +6,19 @@
 ioctl VIDIOC_SUBDEV_ENUM_FRAME_SIZE
 ***********************************
 
-NAME
+Name
 ====
 
 VIDIOC_SUBDEV_ENUM_FRAME_SIZE - Enumerate media bus frame sizes
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_subdev_frame_size_enum * argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -29,7 +30,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 This ioctl allows applications to enumerate all frame sizes supported by
@@ -147,7 +148,7 @@ information about try formats.
 	  the array to zero.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-mbus-code.rst b/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-mbus-code.rst
index 1ff173e502f7..bc0531eb56fa 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-mbus-code.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-mbus-code.rst
@@ -6,18 +6,19 @@
 ioctl VIDIOC_SUBDEV_ENUM_MBUS_CODE
 **********************************
 
-NAME
+Name
 ====
 
 VIDIOC_SUBDEV_ENUM_MBUS_CODE - Enumerate media bus formats
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_subdev_mbus_code_enum * argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -29,7 +30,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 To enumerate media bus formats available at a given sub-device pad
@@ -100,7 +101,7 @@ information about the try formats.
 	  the array to zero.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subdev-g-crop.rst b/Documentation/linux_tv/media/v4l/vidioc-subdev-g-crop.rst
index 94bffa78c486..690034a391d3 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-subdev-g-crop.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-subdev-g-crop.rst
@@ -6,12 +6,13 @@
 ioctl VIDIOC_SUBDEV_G_CROP, VIDIOC_SUBDEV_S_CROP
 ************************************************
 
-NAME
+Name
 ====
 
 VIDIOC_SUBDEV_G_CROP - VIDIOC_SUBDEV_S_CROP - Get or set the crop rectangle on a subdev pad
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_subdev_crop *argp )
@@ -19,7 +20,7 @@ SYNOPSIS
 .. cpp:function:: int ioctl( int fd, int request, const struct v4l2_subdev_crop *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -31,7 +32,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
     **Note**
@@ -114,7 +115,7 @@ modified format should be as close as possible to the original request.
 	  the array to zero.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subdev-g-fmt.rst b/Documentation/linux_tv/media/v4l/vidioc-subdev-g-fmt.rst
index 13615c0d0392..90e2a6635ebc 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-subdev-g-fmt.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-subdev-g-fmt.rst
@@ -6,18 +6,19 @@
 ioctl VIDIOC_SUBDEV_G_FMT, VIDIOC_SUBDEV_S_FMT
 **********************************************
 
-NAME
+Name
 ====
 
 VIDIOC_SUBDEV_G_FMT - VIDIOC_SUBDEV_S_FMT - Get or set the data format on a subdev pad
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_subdev_format *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -29,7 +30,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 These ioctls are used to negotiate the frame format at specific subdev
@@ -144,7 +145,7 @@ should be as close as possible to the original request.
        -  Active formats, applied to the hardware.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subdev-g-frame-interval.rst b/Documentation/linux_tv/media/v4l/vidioc-subdev-g-frame-interval.rst
index 05f5bfb3f1ca..d8a1cabbd272 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-subdev-g-frame-interval.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-subdev-g-frame-interval.rst
@@ -6,18 +6,19 @@
 ioctl VIDIOC_SUBDEV_G_FRAME_INTERVAL, VIDIOC_SUBDEV_S_FRAME_INTERVAL
 ********************************************************************
 
-NAME
+Name
 ====
 
 VIDIOC_SUBDEV_G_FRAME_INTERVAL - VIDIOC_SUBDEV_S_FRAME_INTERVAL - Get or set the frame interval on a subdev pad
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_subdev_frame_interval *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -30,7 +31,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 These ioctls are used to get and set the frame interval at specific
@@ -100,7 +101,7 @@ the same sub-device is not defined.
 	  the array to zero.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subdev-g-selection.rst b/Documentation/linux_tv/media/v4l/vidioc-subdev-g-selection.rst
index dd0dab7d7e42..50838a4a429e 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-subdev-g-selection.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-subdev-g-selection.rst
@@ -6,18 +6,19 @@
 ioctl VIDIOC_SUBDEV_G_SELECTION, VIDIOC_SUBDEV_S_SELECTION
 **********************************************************
 
-NAME
+Name
 ====
 
 VIDIOC_SUBDEV_G_SELECTION - VIDIOC_SUBDEV_S_SELECTION - Get or set selection rectangles on a subdev pad
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_subdev_selection *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -29,7 +30,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 The selections are used to configure various image processing
@@ -122,7 +123,7 @@ Selection targets and flags are documented in
 	  the array to zero.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subscribe-event.rst b/Documentation/linux_tv/media/v4l/vidioc-subscribe-event.rst
index 2ecce157f852..a027f602de3d 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-subscribe-event.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-subscribe-event.rst
@@ -6,18 +6,19 @@
 ioctl VIDIOC_SUBSCRIBE_EVENT, VIDIOC_UNSUBSCRIBE_EVENT
 ******************************************************
 
-NAME
+Name
 ====
 
 VIDIOC_SUBSCRIBE_EVENT - VIDIOC_UNSUBSCRIBE_EVENT - Subscribe or unsubscribe event
 
-SYNOPSIS
+
+Synopsis
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_event_subscription *argp )
 
 
-ARGUMENTS
+Arguments
 =========
 
 ``fd``
@@ -29,7 +30,7 @@ ARGUMENTS
 ``argp``
 
 
-DESCRIPTION
+Description
 ===========
 
 Subscribe or unsubscribe V4L2 event. Subscribed events are dequeued by
@@ -126,7 +127,7 @@ using the :ref:`VIDIOC_DQEVENT` ioctl.
 	  situations like that.
 
 
-RETURN VALUE
+Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
-- 
2.7.4

