Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41330 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174AbcGHNEC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 09:04:02 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: corbet@lwn.net, markus.heiser@darmarIT.de,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 02/54] doc-rst: linux_tv: reformat all syscall pages
Date: Fri,  8 Jul 2016 10:02:54 -0300
Message-Id: <586027cefac593d1a17f86e2236694357ebc6670.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
MIME-Version: 1.0
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=true
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The syscall pages are written to be used also as man-pages.

However, they don't match the format used by kernel-doc
generated pages from DocBook. Rewrite them to match it.

One side effect is that now all such pages at the book
will have the same format, reducing the format differences
between DVB and the other parts of the book.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../media/dvb/FE_DISHNETWORK_SEND_LEGACY_CMD.rst   |  39 ++++----
 Documentation/linux_tv/media/dvb/FE_GET_EVENT.rst  |  33 ++++---
 .../linux_tv/media/dvb/FE_GET_FRONTEND.rst         |  27 ++---
 .../linux_tv/media/dvb/FE_READ_SIGNAL_STRENGTH.rst |  29 +++---
 Documentation/linux_tv/media/dvb/FE_READ_SNR.rst   |  29 +++---
 .../media/dvb/FE_READ_UNCORRECTED_BLOCKS.rst       |  33 ++++---
 .../linux_tv/media/dvb/FE_SET_FRONTEND.rst         |  41 ++++----
 .../media/dvb/audio-bilingual-channel-select.rst   |  34 ++++---
 .../linux_tv/media/dvb/audio-channel-select.rst    |  32 +++---
 .../linux_tv/media/dvb/audio-clear-buffer.rst      |  26 ++---
 .../linux_tv/media/dvb/audio-continue.rst          |  26 ++---
 Documentation/linux_tv/media/dvb/audio-fclose.rst  |  27 ++---
 Documentation/linux_tv/media/dvb/audio-fopen.rst   | 109 +++++++++++----------
 Documentation/linux_tv/media/dvb/audio-fwrite.rst  |  35 +++----
 .../linux_tv/media/dvb/audio-get-capabilities.rst  |  26 ++---
 Documentation/linux_tv/media/dvb/audio-get-pts.rst |  34 ++++---
 .../linux_tv/media/dvb/audio-get-status.rst        |  26 ++---
 Documentation/linux_tv/media/dvb/audio-pause.rst   |  28 +++---
 Documentation/linux_tv/media/dvb/audio-play.rst    |  26 ++---
 .../linux_tv/media/dvb/audio-select-source.rst     |  30 +++---
 .../linux_tv/media/dvb/audio-set-attributes.rst    |  27 ++---
 .../linux_tv/media/dvb/audio-set-av-sync.rst       |  26 ++---
 .../linux_tv/media/dvb/audio-set-bypass-mode.rst   |  32 +++---
 .../linux_tv/media/dvb/audio-set-ext-id.rst        |  27 ++---
 Documentation/linux_tv/media/dvb/audio-set-id.rst  |  36 ++++---
 .../linux_tv/media/dvb/audio-set-karaoke.rst       |  22 +++--
 .../linux_tv/media/dvb/audio-set-mixer.rst         |  24 +++--
 .../linux_tv/media/dvb/audio-set-mute.rst          |  34 ++++---
 .../linux_tv/media/dvb/audio-set-streamtype.rst    |  29 +++---
 Documentation/linux_tv/media/dvb/audio-stop.rst    |  26 ++---
 Documentation/linux_tv/media/dvb/ca-fclose.rst     |  27 ++---
 Documentation/linux_tv/media/dvb/ca-fopen.rst      |  49 ++++-----
 Documentation/linux_tv/media/dvb/ca-get-cap.rst    |  24 +++--
 .../linux_tv/media/dvb/ca-get-descr-info.rst       |  24 +++--
 Documentation/linux_tv/media/dvb/ca-get-msg.rst    |  24 +++--
 .../linux_tv/media/dvb/ca-get-slot-info.rst        |  24 +++--
 Documentation/linux_tv/media/dvb/ca-reset.rst      |  24 +++--
 Documentation/linux_tv/media/dvb/ca-send-msg.rst   |  24 +++--
 Documentation/linux_tv/media/dvb/ca-set-descr.rst  |  24 +++--
 Documentation/linux_tv/media/dvb/ca-set-pid.rst    |  22 +++--
 Documentation/linux_tv/media/dvb/dmx-add-pid.rst   |  28 +++---
 Documentation/linux_tv/media/dvb/dmx-fclose.rst    |  29 +++---
 Documentation/linux_tv/media/dvb/dmx-fopen.rst     |  99 ++++++++++---------
 Documentation/linux_tv/media/dvb/dmx-fread.rst     |  33 ++++---
 Documentation/linux_tv/media/dvb/dmx-fwrite.rst    |  37 +++----
 Documentation/linux_tv/media/dvb/dmx-get-caps.rst  |  24 +++--
 Documentation/linux_tv/media/dvb/dmx-get-event.rst |  33 ++++---
 .../linux_tv/media/dvb/dmx-get-pes-pids.rst        |  24 +++--
 Documentation/linux_tv/media/dvb/dmx-get-stc.rst   |  35 ++++---
 .../linux_tv/media/dvb/dmx-remove-pid.rst          |  28 +++---
 .../linux_tv/media/dvb/dmx-set-buffer-size.rst     |  30 +++---
 .../linux_tv/media/dvb/dmx-set-filter.rst          |  42 ++++----
 .../linux_tv/media/dvb/dmx-set-pes-filter.rst      |  31 +++---
 .../linux_tv/media/dvb/dmx-set-source.rst          |  24 +++--
 Documentation/linux_tv/media/dvb/dmx-start.rst     |  27 ++---
 Documentation/linux_tv/media/dvb/dmx-stop.rst      |  28 +++---
 .../media/dvb/fe-diseqc-recv-slave-reply.rst       |  15 +--
 .../media/dvb/fe-diseqc-reset-overload.rst         |  16 +--
 .../linux_tv/media/dvb/fe-diseqc-send-burst.rst    |  15 +--
 .../media/dvb/fe-diseqc-send-master-cmd.rst        |  15 +--
 .../media/dvb/fe-enable-high-lnb-voltage.rst       |  16 +--
 Documentation/linux_tv/media/dvb/fe-get-info.rst   |  16 +--
 .../linux_tv/media/dvb/fe-get-property.rst         |  17 ++--
 .../linux_tv/media/dvb/fe-read-status.rst          |  16 +--
 .../media/dvb/fe-set-frontend-tune-mode.rst        |  15 +--
 Documentation/linux_tv/media/dvb/fe-set-tone.rst   |  15 +--
 .../linux_tv/media/dvb/fe-set-voltage.rst          |  15 +--
 .../linux_tv/media/dvb/frontend_f_close.rst        |  15 +--
 .../linux_tv/media/dvb/frontend_f_open.rst         |  15 +--
 Documentation/linux_tv/media/dvb/net-add-if.rst    |  15 +--
 Documentation/linux_tv/media/dvb/net-get-if.rst    |  17 ++--
 Documentation/linux_tv/media/dvb/net-remove-if.rst |  15 +--
 .../linux_tv/media/dvb/video-clear-buffer.rst      |  26 ++---
 Documentation/linux_tv/media/dvb/video-command.rst |  38 +++----
 .../linux_tv/media/dvb/video-continue.rst          |  32 +++---
 .../linux_tv/media/dvb/video-fast-forward.rst      |  29 +++---
 Documentation/linux_tv/media/dvb/video-fclose.rst  |  27 ++---
 Documentation/linux_tv/media/dvb/video-fopen.rst   | 107 ++++++++++----------
 Documentation/linux_tv/media/dvb/video-freeze.rst  |  40 ++++----
 Documentation/linux_tv/media/dvb/video-fwrite.rst  |  35 +++----
 .../linux_tv/media/dvb/video-get-capabilities.rst  |  28 +++---
 .../linux_tv/media/dvb/video-get-event.rst         |  79 ++++++++-------
 .../linux_tv/media/dvb/video-get-frame-count.rst   |  34 ++++---
 .../linux_tv/media/dvb/video-get-frame-rate.rst    |  24 +++--
 .../linux_tv/media/dvb/video-get-navi.rst          |  29 +++---
 Documentation/linux_tv/media/dvb/video-get-pts.rst |  34 ++++---
 .../linux_tv/media/dvb/video-get-size.rst          |  24 +++--
 .../linux_tv/media/dvb/video-get-status.rst        |  26 ++---
 Documentation/linux_tv/media/dvb/video-play.rst    |  32 +++---
 .../linux_tv/media/dvb/video-select-source.rst     |  36 ++++---
 .../linux_tv/media/dvb/video-set-attributes.rst    |  28 +++---
 .../linux_tv/media/dvb/video-set-blank.rst         |  24 +++--
 .../media/dvb/video-set-display-format.rst         |  26 ++---
 .../linux_tv/media/dvb/video-set-format.rst        |  29 +++---
 .../linux_tv/media/dvb/video-set-highlight.rst     |  26 ++---
 Documentation/linux_tv/media/dvb/video-set-id.rst  |  27 ++---
 .../linux_tv/media/dvb/video-set-spu-palette.rst   |  25 ++---
 Documentation/linux_tv/media/dvb/video-set-spu.rst |  27 ++---
 .../linux_tv/media/dvb/video-set-streamtype.rst    |  28 +++---
 .../linux_tv/media/dvb/video-set-system.rst        |  31 +++---
 .../linux_tv/media/dvb/video-slowmotion.rst        |  29 +++---
 .../linux_tv/media/dvb/video-stillpicture.rst      |  28 +++---
 Documentation/linux_tv/media/dvb/video-stop.rst    |  34 ++++---
 .../linux_tv/media/dvb/video-try-command.rst       |  38 +++----
 .../linux_tv/media/mediactl/media-func-close.rst   |  15 +--
 .../linux_tv/media/mediactl/media-func-ioctl.rst   |  15 +--
 .../linux_tv/media/mediactl/media-func-open.rst    |  15 +--
 .../media/mediactl/media-ioc-device-info.rst       |  15 +--
 .../media/mediactl/media-ioc-enum-entities.rst     |  16 +--
 .../media/mediactl/media-ioc-enum-links.rst        |  16 +--
 .../media/mediactl/media-ioc-g-topology.rst        |  16 +--
 .../media/mediactl/media-ioc-setup-link.rst        |  15 +--
 Documentation/linux_tv/media/v4l/func-close.rst    |  15 +--
 Documentation/linux_tv/media/v4l/func-ioctl.rst    |  15 +--
 Documentation/linux_tv/media/v4l/func-mmap.rst     |  15 +--
 Documentation/linux_tv/media/v4l/func-munmap.rst   |  15 +--
 Documentation/linux_tv/media/v4l/func-open.rst     |  15 +--
 Documentation/linux_tv/media/v4l/func-poll.rst     |  18 ++--
 Documentation/linux_tv/media/v4l/func-read.rst     |  15 +--
 Documentation/linux_tv/media/v4l/func-select.rst   |  18 ++--
 Documentation/linux_tv/media/v4l/func-write.rst    |  15 +--
 .../linux_tv/media/v4l/vidioc-create-bufs.rst      |  16 +--
 .../linux_tv/media/v4l/vidioc-cropcap.rst          |  16 +--
 .../linux_tv/media/v4l/vidioc-dbg-g-chip-info.rst  |  16 +--
 .../linux_tv/media/v4l/vidioc-dbg-g-register.rst   |  17 ++--
 .../linux_tv/media/v4l/vidioc-decoder-cmd.rst      |  17 ++--
 .../linux_tv/media/v4l/vidioc-dqevent.rst          |  16 +--
 .../linux_tv/media/v4l/vidioc-dv-timings-cap.rst   |  17 ++--
 .../linux_tv/media/v4l/vidioc-encoder-cmd.rst      |  17 ++--
 .../linux_tv/media/v4l/vidioc-enum-dv-timings.rst  |  17 ++--
 .../linux_tv/media/v4l/vidioc-enum-fmt.rst         |  16 +--
 .../media/v4l/vidioc-enum-frameintervals.rst       |  16 +--
 .../linux_tv/media/v4l/vidioc-enum-framesizes.rst  |  16 +--
 .../linux_tv/media/v4l/vidioc-enum-freq-bands.rst  |  16 +--
 .../linux_tv/media/v4l/vidioc-enumaudio.rst        |  15 +--
 .../linux_tv/media/v4l/vidioc-enumaudioout.rst     |  15 +--
 .../linux_tv/media/v4l/vidioc-enuminput.rst        |  16 +--
 .../linux_tv/media/v4l/vidioc-enumoutput.rst       |  16 +--
 .../linux_tv/media/v4l/vidioc-enumstd.rst          |  16 +--
 Documentation/linux_tv/media/v4l/vidioc-expbuf.rst |  16 +--
 .../linux_tv/media/v4l/vidioc-g-audio.rst          |  17 ++--
 .../linux_tv/media/v4l/vidioc-g-audioout.rst       |  17 ++--
 Documentation/linux_tv/media/v4l/vidioc-g-crop.rst |  17 ++--
 Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst |  17 ++--
 .../linux_tv/media/v4l/vidioc-g-dv-timings.rst     |  18 ++--
 Documentation/linux_tv/media/v4l/vidioc-g-edid.rst |  19 ++--
 .../linux_tv/media/v4l/vidioc-g-enc-index.rst      |  16 +--
 .../linux_tv/media/v4l/vidioc-g-ext-ctrls.rst      |  18 ++--
 Documentation/linux_tv/media/v4l/vidioc-g-fbuf.rst |  17 ++--
 Documentation/linux_tv/media/v4l/vidioc-g-fmt.rst  |  18 ++--
 .../linux_tv/media/v4l/vidioc-g-frequency.rst      |  17 ++--
 .../linux_tv/media/v4l/vidioc-g-input.rst          |  16 +--
 .../linux_tv/media/v4l/vidioc-g-jpegcomp.rst       |  15 +--
 .../linux_tv/media/v4l/vidioc-g-modulator.rst      |  17 ++--
 .../linux_tv/media/v4l/vidioc-g-output.rst         |  16 +--
 Documentation/linux_tv/media/v4l/vidioc-g-parm.rst |  17 ++--
 .../linux_tv/media/v4l/vidioc-g-priority.rst       |  17 ++--
 .../linux_tv/media/v4l/vidioc-g-selection.rst      |  17 ++--
 .../linux_tv/media/v4l/vidioc-g-sliced-vbi-cap.rst |  16 +--
 Documentation/linux_tv/media/v4l/vidioc-g-std.rst  |  16 +--
 .../linux_tv/media/v4l/vidioc-g-tuner.rst          |  17 ++--
 .../linux_tv/media/v4l/vidioc-log-status.rst       |  18 ++--
 .../linux_tv/media/v4l/vidioc-overlay.rst          |  15 +--
 .../linux_tv/media/v4l/vidioc-prepare-buf.rst      |  15 +--
 Documentation/linux_tv/media/v4l/vidioc-qbuf.rst   |  16 +--
 .../linux_tv/media/v4l/vidioc-query-dv-timings.rst |  16 +--
 .../linux_tv/media/v4l/vidioc-querybuf.rst         |  15 +--
 .../linux_tv/media/v4l/vidioc-querycap.rst         |  16 +--
 .../linux_tv/media/v4l/vidioc-queryctrl.rst        |  18 ++--
 .../linux_tv/media/v4l/vidioc-querystd.rst         |  15 +--
 .../linux_tv/media/v4l/vidioc-reqbufs.rst          |  16 +--
 .../linux_tv/media/v4l/vidioc-s-hw-freq-seek.rst   |  16 +--
 .../linux_tv/media/v4l/vidioc-streamon.rst         |  16 +--
 .../v4l/vidioc-subdev-enum-frame-interval.rst      |  16 +--
 .../media/v4l/vidioc-subdev-enum-frame-size.rst    |  16 +--
 .../media/v4l/vidioc-subdev-enum-mbus-code.rst     |  16 +--
 .../linux_tv/media/v4l/vidioc-subdev-g-crop.rst    |  17 ++--
 .../linux_tv/media/v4l/vidioc-subdev-g-fmt.rst     |  18 ++--
 .../media/v4l/vidioc-subdev-g-frame-interval.rst   |  17 ++--
 .../media/v4l/vidioc-subdev-g-selection.rst        |  17 ++--
 .../linux_tv/media/v4l/vidioc-subscribe-event.rst  |  17 ++--
 181 files changed, 2364 insertions(+), 2007 deletions(-)

diff --git a/Documentation/linux_tv/media/dvb/FE_DISHNETWORK_SEND_LEGACY_CMD.rst b/Documentation/linux_tv/media/dvb/FE_DISHNETWORK_SEND_LEGACY_CMD.rst
index ff94ac9122d0..9435f45f58c3 100644
--- a/Documentation/linux_tv/media/dvb/FE_DISHNETWORK_SEND_LEGACY_CMD.rst
+++ b/Documentation/linux_tv/media/dvb/FE_DISHNETWORK_SEND_LEGACY_CMD.rst
@@ -6,27 +6,19 @@
 FE_DISHNETWORK_SEND_LEGACY_CMD
 ******************************
 
-Description
------------
+NAME
+====
 
-WARNING: This is a very obscure legacy command, used only at stv0299
-driver. Should not be used on newer drivers.
+FE_DISHNETWORK_SEND_LEGACY_CMD
 
-It provides a non-standard method for selecting Diseqc voltage on the
-frontend, for Dish Network legacy switches.
-
-As support for this ioctl were added in 2004, this means that such
-dishes were already legacy in 2004.
-
-Synopsis
---------
+SYNOPSIS
+========
 
 .. c:function:: int  ioctl(int fd, int request = FE_DISHNETWORK_SEND_LEGACY_CMD, unsigned long cmd)
 
-Arguments
-----------
-
 
+ARGUMENTS
+=========
 
 .. flat-table::
     :header-rows:  0
@@ -40,8 +32,21 @@ Arguments
        -  sends the specified raw cmd to the dish via DISEqC.
 
 
-Return Value
-------------
+DESCRIPTION
+===========
+
+WARNING: This is a very obscure legacy command, used only at stv0299
+driver. Should not be used on newer drivers.
+
+It provides a non-standard method for selecting Diseqc voltage on the
+frontend, for Dish Network legacy switches.
+
+As support for this ioctl were added in 2004, this means that such
+dishes were already legacy in 2004.
+
+
+RETURN VALUE
+============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
diff --git a/Documentation/linux_tv/media/dvb/FE_GET_EVENT.rst b/Documentation/linux_tv/media/dvb/FE_GET_EVENT.rst
index 24352b26a201..3d858107b6f9 100644
--- a/Documentation/linux_tv/media/dvb/FE_GET_EVENT.rst
+++ b/Documentation/linux_tv/media/dvb/FE_GET_EVENT.rst
@@ -6,24 +6,19 @@
 FE_GET_EVENT
 ************
 
-Description
------------
+NAME
+====
 
-This ioctl call returns a frontend event if available. If an event is
-not available, the behavior depends on whether the device is in blocking
-or non-blocking mode. In the latter case, the call fails immediately
-with errno set to ``EWOULDBLOCK``. In the former case, the call blocks until
-an event becomes available.
+FE_GET_EVENT
 
-Synopsis
---------
+SYNOPSIS
+========
 
 .. c:function:: int  ioctl(int fd, int request = QPSK_GET_EVENT, struct dvb_frontend_event *ev)
 
-Arguments
-----------
-
 
+ARGUMENTS
+=========
 
 .. flat-table::
     :header-rows:  0
@@ -54,8 +49,18 @@ Arguments
        -  if any, is to be stored.
 
 
-Return Value
-------------
+DESCRIPTION
+===========
+
+This ioctl call returns a frontend event if available. If an event is
+not available, the behavior depends on whether the device is in blocking
+or non-blocking mode. In the latter case, the call fails immediately
+with errno set to ``EWOULDBLOCK``. In the former case, the call blocks until
+an event becomes available.
+
+
+RETURN VALUE
+============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
diff --git a/Documentation/linux_tv/media/dvb/FE_GET_FRONTEND.rst b/Documentation/linux_tv/media/dvb/FE_GET_FRONTEND.rst
index d8dbcc7741d4..7084070bfe77 100644
--- a/Documentation/linux_tv/media/dvb/FE_GET_FRONTEND.rst
+++ b/Documentation/linux_tv/media/dvb/FE_GET_FRONTEND.rst
@@ -6,21 +6,19 @@
 FE_GET_FRONTEND
 ***************
 
-Description
------------
+NAME
+====
 
-This ioctl call queries the currently effective frontend parameters. For
-this command, read-only access to the device is sufficient.
+FE_GET_FRONTEND
 
-Synopsis
---------
+SYNOPSIS
+========
 
 .. c:function:: int ioctl(int fd, int request = FE_GET_FRONTEND, struct dvb_frontend_parameters *p)
 
-Arguments
-----------
-
 
+ARGUMENTS
+=========
 
 .. flat-table::
     :header-rows:  0
@@ -47,8 +45,15 @@ Arguments
        -  Points to parameters for tuning operation.
 
 
-Return Value
-------------
+DESCRIPTION
+===========
+
+This ioctl call queries the currently effective frontend parameters. For
+this command, read-only access to the device is sufficient.
+
+
+RETURN VALUE
+============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
diff --git a/Documentation/linux_tv/media/dvb/FE_READ_SIGNAL_STRENGTH.rst b/Documentation/linux_tv/media/dvb/FE_READ_SIGNAL_STRENGTH.rst
index 4adea9274d37..7f6f47f4d30e 100644
--- a/Documentation/linux_tv/media/dvb/FE_READ_SIGNAL_STRENGTH.rst
+++ b/Documentation/linux_tv/media/dvb/FE_READ_SIGNAL_STRENGTH.rst
@@ -6,22 +6,19 @@
 FE_READ_SIGNAL_STRENGTH
 ***********************
 
-Description
------------
+NAME
+====
 
-This ioctl call returns the signal strength value for the signal
-currently received by the front-end. For this command, read-only access
-to the device is sufficient.
+FE_READ_SIGNAL_STRENGTH
 
-Synopsis
---------
+SYNOPSIS
+========
 
 .. c:function:: int ioctl( int fd, int request = FE_READ_SIGNAL_STRENGTH, uint16_t *strength)
 
-Arguments
-----------
-
 
+ARGUMENTS
+=========
 
 .. flat-table::
     :header-rows:  0
@@ -49,8 +46,16 @@ Arguments
        -  The signal strength value is stored into \*strength.
 
 
-Return Value
-------------
+DESCRIPTION
+===========
+
+This ioctl call returns the signal strength value for the signal
+currently received by the front-end. For this command, read-only access
+to the device is sufficient.
+
+
+RETURN VALUE
+============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
diff --git a/Documentation/linux_tv/media/dvb/FE_READ_SNR.rst b/Documentation/linux_tv/media/dvb/FE_READ_SNR.rst
index 11b4f72d684e..3ecaeb8007f4 100644
--- a/Documentation/linux_tv/media/dvb/FE_READ_SNR.rst
+++ b/Documentation/linux_tv/media/dvb/FE_READ_SNR.rst
@@ -6,22 +6,19 @@
 FE_READ_SNR
 ***********
 
-Description
------------
+NAME
+====
 
-This ioctl call returns the signal-to-noise ratio for the signal
-currently received by the front-end. For this command, read-only access
-to the device is sufficient.
+FE_READ_SNR
 
-Synopsis
---------
+SYNOPSIS
+========
 
 .. c:function:: int  ioctl(int fd, int request = FE_READ_SNR, int16_t *snr)
 
-Arguments
-----------
-
 
+ARGUMENTS
+=========
 
 .. flat-table::
     :header-rows:  0
@@ -47,8 +44,16 @@ Arguments
        -  The signal-to-noise ratio is stored into \*snr.
 
 
-Return Value
-------------
+DESCRIPTION
+===========
+
+This ioctl call returns the signal-to-noise ratio for the signal
+currently received by the front-end. For this command, read-only access
+to the device is sufficient.
+
+
+RETURN VALUE
+============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
diff --git a/Documentation/linux_tv/media/dvb/FE_READ_UNCORRECTED_BLOCKS.rst b/Documentation/linux_tv/media/dvb/FE_READ_UNCORRECTED_BLOCKS.rst
index cb35a416b1e4..31ec4c35dd51 100644
--- a/Documentation/linux_tv/media/dvb/FE_READ_UNCORRECTED_BLOCKS.rst
+++ b/Documentation/linux_tv/media/dvb/FE_READ_UNCORRECTED_BLOCKS.rst
@@ -6,24 +6,19 @@
 FE_READ_UNCORRECTED_BLOCKS
 **************************
 
-Description
------------
+NAME
+====
 
-This ioctl call returns the number of uncorrected blocks detected by the
-device driver during its lifetime. For meaningful measurements, the
-increment in block count during a specific time interval should be
-calculated. For this command, read-only access to the device is
-sufficient.
+FE_READ_UNCORRECTED_BLOCKS
 
-Synopsis
---------
+SYNOPSIS
+========
 
 .. c:function:: int ioctl( int fd, int request =FE_READ_UNCORRECTED_BLOCKS, uint32_t *ublocks)
 
-Arguments
-----------
-
 
+ARGUMENTS
+=========
 
 .. flat-table::
     :header-rows:  0
@@ -51,8 +46,18 @@ Arguments
        -  The total number of uncorrected blocks seen by the driver so far.
 
 
-Return Value
-------------
+DESCRIPTION
+===========
+
+This ioctl call returns the number of uncorrected blocks detected by the
+device driver during its lifetime. For meaningful measurements, the
+increment in block count during a specific time interval should be
+calculated. For this command, read-only access to the device is
+sufficient.
+
+
+RETURN VALUE
+============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
diff --git a/Documentation/linux_tv/media/dvb/FE_SET_FRONTEND.rst b/Documentation/linux_tv/media/dvb/FE_SET_FRONTEND.rst
index 98970961da7b..0cce39666773 100644
--- a/Documentation/linux_tv/media/dvb/FE_SET_FRONTEND.rst
+++ b/Documentation/linux_tv/media/dvb/FE_SET_FRONTEND.rst
@@ -6,28 +6,19 @@
 FE_SET_FRONTEND
 ***************
 
-Description
------------
+NAME
+====
 
-This ioctl call starts a tuning operation using specified parameters.
-The result of this call will be successful if the parameters were valid
-and the tuning could be initiated. The result of the tuning operation in
-itself, however, will arrive asynchronously as an event (see
-documentation for :ref:`FE_GET_EVENT` and
-FrontendEvent.) If a new :ref:`FE_SET_FRONTEND`
-operation is initiated before the previous one was completed, the
-previous operation will be aborted in favor of the new one. This command
-requires read/write access to the device.
+FE_SET_FRONTEND
 
-Synopsis
---------
+SYNOPSIS
+========
 
 .. c:function:: int ioctl(int fd, int request = FE_SET_FRONTEND, struct dvb_frontend_parameters *p)
 
-Arguments
-----------
-
 
+ARGUMENTS
+=========
 
 .. flat-table::
     :header-rows:  0
@@ -54,8 +45,22 @@ Arguments
        -  Points to parameters for tuning operation.
 
 
-Return Value
-------------
+DESCRIPTION
+===========
+
+This ioctl call starts a tuning operation using specified parameters.
+The result of this call will be successful if the parameters were valid
+and the tuning could be initiated. The result of the tuning operation in
+itself, however, will arrive asynchronously as an event (see
+documentation for :ref:`FE_GET_EVENT` and
+FrontendEvent.) If a new :ref:`FE_SET_FRONTEND`
+operation is initiated before the previous one was completed, the
+previous operation will be aborted in favor of the new one. This command
+requires read/write access to the device.
+
+
+RETURN VALUE
+============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
diff --git a/Documentation/linux_tv/media/dvb/audio-bilingual-channel-select.rst b/Documentation/linux_tv/media/dvb/audio-bilingual-channel-select.rst
index b965932fe20c..dda1695e28a9 100644
--- a/Documentation/linux_tv/media/dvb/audio-bilingual-channel-select.rst
+++ b/Documentation/linux_tv/media/dvb/audio-bilingual-channel-select.rst
@@ -2,28 +2,23 @@
 
 .. _AUDIO_BILINGUAL_CHANNEL_SELECT:
 
+==============================
 AUDIO_BILINGUAL_CHANNEL_SELECT
 ==============================
 
-Description
------------
-
-This ioctl is obsolete. Do not use in new drivers. It has been replaced
-by the V4L2 ``V4L2_CID_MPEG_AUDIO_DEC_MULTILINGUAL_PLAYBACK`` control
-for MPEG decoders controlled through V4L2.
+NAME
+----
 
-This ioctl call asks the Audio Device to select the requested channel
-for bilingual streams if possible.
+AUDIO_BILINGUAL_CHANNEL_SELECT
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int ioctl(int fd, int request = AUDIO_BILINGUAL_CHANNEL_SELECT, audio_channel_select_t)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -49,11 +44,20 @@ Arguments
        -  Select the output format of the audio (mono left/right, stereo).
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl is obsolete. Do not use in new drivers. It has been replaced
+by the V4L2 ``V4L2_CID_MPEG_AUDIO_DEC_MULTILINGUAL_PLAYBACK`` control
+for MPEG decoders controlled through V4L2.
+
+This ioctl call asks the Audio Device to select the requested channel
+for bilingual streams if possible.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
diff --git a/Documentation/linux_tv/media/dvb/audio-channel-select.rst b/Documentation/linux_tv/media/dvb/audio-channel-select.rst
index d570ff1f7d3a..f7f9766d3902 100644
--- a/Documentation/linux_tv/media/dvb/audio-channel-select.rst
+++ b/Documentation/linux_tv/media/dvb/audio-channel-select.rst
@@ -2,27 +2,23 @@
 
 .. _AUDIO_CHANNEL_SELECT:
 
+====================
 AUDIO_CHANNEL_SELECT
 ====================
 
-Description
------------
-
-This ioctl is for DVB devices only. To control a V4L2 decoder use the
-V4L2 ``V4L2_CID_MPEG_AUDIO_DEC_PLAYBACK`` control instead.
+NAME
+----
 
-This ioctl call asks the Audio Device to select the requested channel if
-possible.
+AUDIO_CHANNEL_SELECT
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int ioctl(int fd, int request = AUDIO_CHANNEL_SELECT, audio_channel_select_t)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -48,11 +44,19 @@ Arguments
        -  Select the output format of the audio (mono left/right, stereo).
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl is for DVB devices only. To control a V4L2 decoder use the
+V4L2 ``V4L2_CID_MPEG_AUDIO_DEC_PLAYBACK`` control instead.
+
+This ioctl call asks the Audio Device to select the requested channel if
+possible.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
diff --git a/Documentation/linux_tv/media/dvb/audio-clear-buffer.rst b/Documentation/linux_tv/media/dvb/audio-clear-buffer.rst
index 6c94cc7402a9..97cb3d98f20d 100644
--- a/Documentation/linux_tv/media/dvb/audio-clear-buffer.rst
+++ b/Documentation/linux_tv/media/dvb/audio-clear-buffer.rst
@@ -2,24 +2,23 @@
 
 .. _AUDIO_CLEAR_BUFFER:
 
+==================
 AUDIO_CLEAR_BUFFER
 ==================
 
-Description
------------
+NAME
+----
 
-This ioctl call asks the Audio Device to clear all software and hardware
-buffers of the audio decoder device.
+AUDIO_CLEAR_BUFFER
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int  ioctl(int fd, int request = AUDIO_CLEAR_BUFFER)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -39,11 +38,16 @@ Arguments
        -  Equals AUDIO_CLEAR_BUFFER for this command.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl call asks the Audio Device to clear all software and hardware
+buffers of the audio decoder device.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
diff --git a/Documentation/linux_tv/media/dvb/audio-continue.rst b/Documentation/linux_tv/media/dvb/audio-continue.rst
index 8b91cf950765..1f3d5c35b7ce 100644
--- a/Documentation/linux_tv/media/dvb/audio-continue.rst
+++ b/Documentation/linux_tv/media/dvb/audio-continue.rst
@@ -2,24 +2,23 @@
 
 .. _AUDIO_CONTINUE:
 
+==============
 AUDIO_CONTINUE
 ==============
 
-Description
------------
+NAME
+----
 
-This ioctl restarts the decoding and playing process previously paused
-with AUDIO_PAUSE command.
+AUDIO_CONTINUE
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int  ioctl(int fd, int request = AUDIO_CONTINUE)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -39,11 +38,16 @@ Arguments
        -  Equals AUDIO_CONTINUE for this command.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl restarts the decoding and playing process previously paused
+with AUDIO_PAUSE command.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
diff --git a/Documentation/linux_tv/media/dvb/audio-fclose.rst b/Documentation/linux_tv/media/dvb/audio-fclose.rst
index fb855dd9cbcb..80d9cde4c926 100644
--- a/Documentation/linux_tv/media/dvb/audio-fclose.rst
+++ b/Documentation/linux_tv/media/dvb/audio-fclose.rst
@@ -2,23 +2,23 @@
 
 .. _audio_fclose:
 
+=================
 DVB audio close()
 =================
 
-Description
------------
+NAME
+----
 
-This system call closes a previously opened audio device.
+DVB audio close()
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int  close(int fd)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -32,11 +32,15 @@ Arguments
        -  File descriptor returned by a previous call to open().
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This system call closes a previously opened audio device.
+
+
+RETURN VALUE
 ------------
 
-
-
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
@@ -47,6 +51,3 @@ Return Value
        -  ``EBADF``
 
        -  fd is not a valid open file descriptor.
-
-
-
diff --git a/Documentation/linux_tv/media/dvb/audio-fopen.rst b/Documentation/linux_tv/media/dvb/audio-fopen.rst
index 5d3d7d941567..6596d6427c1f 100644
--- a/Documentation/linux_tv/media/dvb/audio-fopen.rst
+++ b/Documentation/linux_tv/media/dvb/audio-fopen.rst
@@ -2,10 +2,63 @@
 
 .. _audio_fopen:
 
+================
 DVB audio open()
 ================
 
-Description
+NAME
+----
+
+DVB audio open()
+
+SYNOPSIS
+--------
+
+.. c:function:: int  open(const char *deviceName, int flags)
+
+
+ARGUMENTS
+---------
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
+DESCRIPTION
 -----------
 
 This system call opens a named audio device (e.g.
@@ -22,59 +75,10 @@ fail, and an error code will be returned. If the Audio Device is opened
 in O_RDONLY mode, the only ioctl call that can be used is
 AUDIO_GET_STATUS. All other call will return with an error code.
 
-Synopsis
---------
 
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
+RETURN VALUE
 ------------
 
-
-
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
@@ -97,6 +101,3 @@ Return Value
        -  ``EINVAL``
 
        -  Invalid argument.
-
-
-
diff --git a/Documentation/linux_tv/media/dvb/audio-fwrite.rst b/Documentation/linux_tv/media/dvb/audio-fwrite.rst
index 9921f3a16d45..9aa9583a3267 100644
--- a/Documentation/linux_tv/media/dvb/audio-fwrite.rst
+++ b/Documentation/linux_tv/media/dvb/audio-fwrite.rst
@@ -2,27 +2,23 @@
 
 .. _audio_fwrite:
 
+=================
 DVB audio write()
 =================
 
-Description
------------
+NAME
+----
 
-This system call can only be used if AUDIO_SOURCE_MEMORY is selected
-in the ioctl call AUDIO_SELECT_SOURCE. The data provided shall be in
-PES format. If O_NONBLOCK is not specified the function will block
-until buffer space is available. The amount of data to be transferred is
-implied by count.
+DVB audio write()
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: size_t write(int fd, const void *buf, size_t count)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -48,11 +44,19 @@ Arguments
        -  Size of buf.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This system call can only be used if AUDIO_SOURCE_MEMORY is selected
+in the ioctl call AUDIO_SELECT_SOURCE. The data provided shall be in
+PES format. If O_NONBLOCK is not specified the function will block
+until buffer space is available. The amount of data to be transferred is
+implied by count.
+
+
+RETURN VALUE
 ------------
 
-
-
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
@@ -75,6 +79,3 @@ Return Value
        -  ``EBADF``
 
        -  fd is not a valid open file descriptor.
-
-
-
diff --git a/Documentation/linux_tv/media/dvb/audio-get-capabilities.rst b/Documentation/linux_tv/media/dvb/audio-get-capabilities.rst
index 84b9f073344b..32e55bbc4d03 100644
--- a/Documentation/linux_tv/media/dvb/audio-get-capabilities.rst
+++ b/Documentation/linux_tv/media/dvb/audio-get-capabilities.rst
@@ -2,24 +2,23 @@
 
 .. _AUDIO_GET_CAPABILITIES:
 
+======================
 AUDIO_GET_CAPABILITIES
 ======================
 
-Description
------------
+NAME
+----
 
-This ioctl call asks the Audio Device to tell us about the decoding
-capabilities of the audio hardware.
+AUDIO_GET_CAPABILITIES
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int ioctl(int fd, int request = AUDIO_GET_CAPABILITIES, unsigned int *cap)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -45,11 +44,16 @@ Arguments
        -  Returns a bit array of supported sound formats.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl call asks the Audio Device to tell us about the decoding
+capabilities of the audio hardware.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
diff --git a/Documentation/linux_tv/media/dvb/audio-get-pts.rst b/Documentation/linux_tv/media/dvb/audio-get-pts.rst
index 3cd31741e728..a8e2ef5a107d 100644
--- a/Documentation/linux_tv/media/dvb/audio-get-pts.rst
+++ b/Documentation/linux_tv/media/dvb/audio-get-pts.rst
@@ -2,28 +2,23 @@
 
 .. _AUDIO_GET_PTS:
 
+=============
 AUDIO_GET_PTS
 =============
 
-Description
------------
-
-This ioctl is obsolete. Do not use in new drivers. If you need this
-functionality, then please contact the linux-media mailing list
-(`https://linuxtv.org/lists.php <https://linuxtv.org/lists.php>`__).
+NAME
+----
 
-This ioctl call asks the Audio Device to return the current PTS
-timestamp.
+AUDIO_GET_PTS
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int ioctl(int fd, int request = AUDIO_GET_PTS, __u64 *pts)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -54,11 +49,20 @@ Arguments
 	  decoded frame or the last PTS extracted by the PES parser.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl is obsolete. Do not use in new drivers. If you need this
+functionality, then please contact the linux-media mailing list
+(`https://linuxtv.org/lists.php <https://linuxtv.org/lists.php>`__).
+
+This ioctl call asks the Audio Device to return the current PTS
+timestamp.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
diff --git a/Documentation/linux_tv/media/dvb/audio-get-status.rst b/Documentation/linux_tv/media/dvb/audio-get-status.rst
index be0937fbff0c..b9a2850b577a 100644
--- a/Documentation/linux_tv/media/dvb/audio-get-status.rst
+++ b/Documentation/linux_tv/media/dvb/audio-get-status.rst
@@ -2,24 +2,23 @@
 
 .. _AUDIO_GET_STATUS:
 
+================
 AUDIO_GET_STATUS
 ================
 
-Description
------------
+NAME
+----
 
-This ioctl call asks the Audio Device to return the current state of the
-Audio Device.
+AUDIO_GET_STATUS
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int ioctl(int fd, int request = AUDIO_GET_STATUS, struct audio_status *status)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -45,11 +44,16 @@ Arguments
        -  Returns the current state of Audio Device.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl call asks the Audio Device to return the current state of the
+Audio Device.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
diff --git a/Documentation/linux_tv/media/dvb/audio-pause.rst b/Documentation/linux_tv/media/dvb/audio-pause.rst
index 2d1c7e880ad0..8b1517b54272 100644
--- a/Documentation/linux_tv/media/dvb/audio-pause.rst
+++ b/Documentation/linux_tv/media/dvb/audio-pause.rst
@@ -2,25 +2,23 @@
 
 .. _AUDIO_PAUSE:
 
+===========
 AUDIO_PAUSE
 ===========
 
-Description
------------
+NAME
+----
 
-This ioctl call suspends the audio stream being played. Decoding and
-playing are paused. It is then possible to restart again decoding and
-playing process of the audio stream using AUDIO_CONTINUE command.
+AUDIO_PAUSE
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int  ioctl(int fd, int request = AUDIO_PAUSE)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -40,11 +38,17 @@ Arguments
        -  Equals AUDIO_PAUSE for this command.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl call suspends the audio stream being played. Decoding and
+playing are paused. It is then possible to restart again decoding and
+playing process of the audio stream using AUDIO_CONTINUE command.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
diff --git a/Documentation/linux_tv/media/dvb/audio-play.rst b/Documentation/linux_tv/media/dvb/audio-play.rst
index 116cc27be82c..22bd35007b25 100644
--- a/Documentation/linux_tv/media/dvb/audio-play.rst
+++ b/Documentation/linux_tv/media/dvb/audio-play.rst
@@ -2,24 +2,23 @@
 
 .. _AUDIO_PLAY:
 
+==========
 AUDIO_PLAY
 ==========
 
-Description
------------
+NAME
+----
 
-This ioctl call asks the Audio Device to start playing an audio stream
-from the selected source.
+AUDIO_PLAY
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int  ioctl(int fd, int request = AUDIO_PLAY)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -39,11 +38,16 @@ Arguments
        -  Equals AUDIO_PLAY for this command.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl call asks the Audio Device to start playing an audio stream
+from the selected source.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
diff --git a/Documentation/linux_tv/media/dvb/audio-select-source.rst b/Documentation/linux_tv/media/dvb/audio-select-source.rst
index 9d6367e7ff6f..2242e6f0b6ad 100644
--- a/Documentation/linux_tv/media/dvb/audio-select-source.rst
+++ b/Documentation/linux_tv/media/dvb/audio-select-source.rst
@@ -2,26 +2,23 @@
 
 .. _AUDIO_SELECT_SOURCE:
 
+===================
 AUDIO_SELECT_SOURCE
 ===================
 
-Description
------------
+NAME
+----
 
-This ioctl call informs the audio device which source shall be used for
-the input data. The possible sources are demux or memory. If
-AUDIO_SOURCE_MEMORY is selected, the data is fed to the Audio Device
-through the write command.
+AUDIO_SELECT_SOURCE
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int ioctl(int fd, int request = AUDIO_SELECT_SOURCE, audio_stream_source_t source)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -47,11 +44,18 @@ Arguments
        -  Indicates the source that shall be used for the Audio stream.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl call informs the audio device which source shall be used for
+the input data. The possible sources are demux or memory. If
+AUDIO_SOURCE_MEMORY is selected, the data is fed to the Audio Device
+through the write command.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
diff --git a/Documentation/linux_tv/media/dvb/audio-set-attributes.rst b/Documentation/linux_tv/media/dvb/audio-set-attributes.rst
index a03774015b40..ea08cea6aa78 100644
--- a/Documentation/linux_tv/media/dvb/audio-set-attributes.rst
+++ b/Documentation/linux_tv/media/dvb/audio-set-attributes.rst
@@ -2,24 +2,23 @@
 
 .. _AUDIO_SET_ATTRIBUTES:
 
+====================
 AUDIO_SET_ATTRIBUTES
 ====================
 
-Description
------------
+NAME
+----
 
-This ioctl is intended for DVD playback and allows you to set certain
-information about the audio stream.
+AUDIO_SET_ATTRIBUTES
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int ioctl(fd, int request = AUDIO_SET_ATTRIBUTES, audio_attributes_t attr )
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -45,7 +44,14 @@ Arguments
        -  audio attributes according to section ??
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl is intended for DVD playback and allows you to set certain
+information about the audio stream.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
@@ -64,6 +70,3 @@ appropriately. The generic error codes are described at the
        -  ``EINVAL``
 
        -  attr is not a valid or supported attribute setting.
-
-
-
diff --git a/Documentation/linux_tv/media/dvb/audio-set-av-sync.rst b/Documentation/linux_tv/media/dvb/audio-set-av-sync.rst
index 7aa27ab34d91..3f5ac9a87bc8 100644
--- a/Documentation/linux_tv/media/dvb/audio-set-av-sync.rst
+++ b/Documentation/linux_tv/media/dvb/audio-set-av-sync.rst
@@ -2,24 +2,23 @@
 
 .. _AUDIO_SET_AV_SYNC:
 
+=================
 AUDIO_SET_AV_SYNC
 =================
 
-Description
------------
+NAME
+----
 
-This ioctl call asks the Audio Device to turn ON or OFF A/V
-synchronization.
+AUDIO_SET_AV_SYNC
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int  ioctl(int fd, int request = AUDIO_SET_AV_SYNC, boolean state)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -55,11 +54,16 @@ Arguments
        -  FALSE AV-sync OFF
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl call asks the Audio Device to turn ON or OFF A/V
+synchronization.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
diff --git a/Documentation/linux_tv/media/dvb/audio-set-bypass-mode.rst b/Documentation/linux_tv/media/dvb/audio-set-bypass-mode.rst
index 3a0c21a667fa..9377342c646d 100644
--- a/Documentation/linux_tv/media/dvb/audio-set-bypass-mode.rst
+++ b/Documentation/linux_tv/media/dvb/audio-set-bypass-mode.rst
@@ -2,27 +2,23 @@
 
 .. _AUDIO_SET_BYPASS_MODE:
 
+=====================
 AUDIO_SET_BYPASS_MODE
 =====================
 
-Description
------------
+NAME
+----
 
-This ioctl call asks the Audio Device to bypass the Audio decoder and
-forward the stream without decoding. This mode shall be used if streams
-that can’t be handled by the DVB system shall be decoded. Dolby
-DigitalTM streams are automatically forwarded by the DVB subsystem if
-the hardware can handle it.
+AUDIO_SET_BYPASS_MODE
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int ioctl(int fd, int request = AUDIO_SET_BYPASS_MODE, boolean mode)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -59,11 +55,19 @@ Arguments
        -  FALSE Bypass is enabled
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl call asks the Audio Device to bypass the Audio decoder and
+forward the stream without decoding. This mode shall be used if streams
+that can’t be handled by the DVB system shall be decoded. Dolby
+DigitalTM streams are automatically forwarded by the DVB subsystem if
+the hardware can handle it.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
diff --git a/Documentation/linux_tv/media/dvb/audio-set-ext-id.rst b/Documentation/linux_tv/media/dvb/audio-set-ext-id.rst
index bda4c92df27f..456b05267f29 100644
--- a/Documentation/linux_tv/media/dvb/audio-set-ext-id.rst
+++ b/Documentation/linux_tv/media/dvb/audio-set-ext-id.rst
@@ -2,24 +2,23 @@
 
 .. _AUDIO_SET_EXT_ID:
 
+================
 AUDIO_SET_EXT_ID
 ================
 
-Description
------------
+NAME
+----
 
-This ioctl can be used to set the extension id for MPEG streams in DVD
-playback. Only the first 3 bits are recognized.
+AUDIO_SET_EXT_ID
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int  ioctl(fd, int request = AUDIO_SET_EXT_ID, int id)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -45,7 +44,14 @@ Arguments
        -  audio sub_stream_id
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl can be used to set the extension id for MPEG streams in DVD
+playback. Only the first 3 bits are recognized.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
@@ -64,6 +70,3 @@ appropriately. The generic error codes are described at the
        -  ``EINVAL``
 
        -  id is not a valid id.
-
-
-
diff --git a/Documentation/linux_tv/media/dvb/audio-set-id.rst b/Documentation/linux_tv/media/dvb/audio-set-id.rst
index e545f9dad407..60eeee07d244 100644
--- a/Documentation/linux_tv/media/dvb/audio-set-id.rst
+++ b/Documentation/linux_tv/media/dvb/audio-set-id.rst
@@ -2,29 +2,23 @@
 
 .. _AUDIO_SET_ID:
 
+============
 AUDIO_SET_ID
 ============
 
-Description
------------
+NAME
+----
 
-This ioctl selects which sub-stream is to be decoded if a program or
-system stream is sent to the video device. If no audio stream type is
-set the id has to be in [0xC0,0xDF] for MPEG sound, in [0x80,0x87] for
-AC3 and in [0xA0,0xA7] for LPCM. More specifications may follow for
-other stream types. If the stream type is set the id just specifies the
-substream id of the audio stream and only the first 5 bits are
-recognized.
+AUDIO_SET_ID
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int  ioctl(int fd, int request = AUDIO_SET_ID, int id)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -50,11 +44,21 @@ Arguments
        -  audio sub-stream id
 
 
-Return Value
+DESCRIPTION
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
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
diff --git a/Documentation/linux_tv/media/dvb/audio-set-karaoke.rst b/Documentation/linux_tv/media/dvb/audio-set-karaoke.rst
index 75a02e4db0a1..07453ceae40f 100644
--- a/Documentation/linux_tv/media/dvb/audio-set-karaoke.rst
+++ b/Documentation/linux_tv/media/dvb/audio-set-karaoke.rst
@@ -2,23 +2,23 @@
 
 .. _AUDIO_SET_KARAOKE:
 
+=================
 AUDIO_SET_KARAOKE
 =================
 
-Description
------------
+NAME
+----
 
-This ioctl allows one to set the mixer settings for a karaoke DVD.
+AUDIO_SET_KARAOKE
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int ioctl(fd, int request = AUDIO_SET_KARAOKE, audio_karaoke_t *karaoke)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -44,7 +44,13 @@ Arguments
        -  karaoke settings according to section ??.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl allows one to set the mixer settings for a karaoke DVD.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/audio-set-mixer.rst b/Documentation/linux_tv/media/dvb/audio-set-mixer.rst
index 9360d20e759e..8d5a6f375419 100644
--- a/Documentation/linux_tv/media/dvb/audio-set-mixer.rst
+++ b/Documentation/linux_tv/media/dvb/audio-set-mixer.rst
@@ -2,23 +2,23 @@
 
 .. _AUDIO_SET_MIXER:
 
+===============
 AUDIO_SET_MIXER
 ===============
 
-Description
------------
+NAME
+----
 
-This ioctl lets you adjust the mixer settings of the audio decoder.
+AUDIO_SET_MIXER
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int ioctl(int fd, int request = AUDIO_SET_MIXER, audio_mixer_t *mix)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -44,11 +44,15 @@ Arguments
        -  mixer settings.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl lets you adjust the mixer settings of the audio decoder.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
diff --git a/Documentation/linux_tv/media/dvb/audio-set-mute.rst b/Documentation/linux_tv/media/dvb/audio-set-mute.rst
index eb6622b63e2b..a002d0d7128d 100644
--- a/Documentation/linux_tv/media/dvb/audio-set-mute.rst
+++ b/Documentation/linux_tv/media/dvb/audio-set-mute.rst
@@ -2,28 +2,23 @@
 
 .. _AUDIO_SET_MUTE:
 
+==============
 AUDIO_SET_MUTE
 ==============
 
-Description
------------
-
-This ioctl is for DVB devices only. To control a V4L2 decoder use the
-V4L2 :ref:`VIDIOC_DECODER_CMD` with the
-``V4L2_DEC_CMD_START_MUTE_AUDIO`` flag instead.
+NAME
+----
 
-This ioctl call asks the audio device to mute the stream that is
-currently being played.
+AUDIO_SET_MUTE
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int  ioctl(int fd, int request = AUDIO_SET_MUTE, boolean state)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -59,11 +54,20 @@ Arguments
        -  FALSE Audio Un-mute
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl is for DVB devices only. To control a V4L2 decoder use the
+V4L2 :ref:`VIDIOC_DECODER_CMD` with the
+``V4L2_DEC_CMD_START_MUTE_AUDIO`` flag instead.
+
+This ioctl call asks the audio device to mute the stream that is
+currently being played.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
diff --git a/Documentation/linux_tv/media/dvb/audio-set-streamtype.rst b/Documentation/linux_tv/media/dvb/audio-set-streamtype.rst
index 6fc7c8dfccf8..a971d43e01cc 100644
--- a/Documentation/linux_tv/media/dvb/audio-set-streamtype.rst
+++ b/Documentation/linux_tv/media/dvb/audio-set-streamtype.rst
@@ -2,25 +2,23 @@
 
 .. _AUDIO_SET_STREAMTYPE:
 
+====================
 AUDIO_SET_STREAMTYPE
 ====================
 
-Description
------------
+NAME
+----
 
-This ioctl tells the driver which kind of audio stream to expect. This
-is useful if the stream offers several audio sub-streams like LPCM and
-AC3.
+AUDIO_SET_STREAMTYPE
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int  ioctl(fd, int request = AUDIO_SET_STREAMTYPE, int type)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -46,7 +44,15 @@ Arguments
        -  stream type
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl tells the driver which kind of audio stream to expect. This
+is useful if the stream offers several audio sub-streams like LPCM and
+AC3.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
@@ -65,6 +71,3 @@ appropriately. The generic error codes are described at the
        -  ``EINVAL``
 
        -  type is not a valid or supported stream type.
-
-
-
diff --git a/Documentation/linux_tv/media/dvb/audio-stop.rst b/Documentation/linux_tv/media/dvb/audio-stop.rst
index 57e95c453350..558ff2b1effb 100644
--- a/Documentation/linux_tv/media/dvb/audio-stop.rst
+++ b/Documentation/linux_tv/media/dvb/audio-stop.rst
@@ -2,24 +2,23 @@
 
 .. _AUDIO_STOP:
 
+==========
 AUDIO_STOP
 ==========
 
-Description
------------
+NAME
+----
 
-This ioctl call asks the Audio Device to stop playing the current
-stream.
+AUDIO_STOP
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int ioctl(int fd, int request = AUDIO_STOP)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -39,11 +38,16 @@ Arguments
        -  Equals AUDIO_STOP for this command.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl call asks the Audio Device to stop playing the current
+stream.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
diff --git a/Documentation/linux_tv/media/dvb/ca-fclose.rst b/Documentation/linux_tv/media/dvb/ca-fclose.rst
index c7797c726c6b..a093e8dd3182 100644
--- a/Documentation/linux_tv/media/dvb/ca-fclose.rst
+++ b/Documentation/linux_tv/media/dvb/ca-fclose.rst
@@ -2,23 +2,23 @@
 
 .. _ca_fclose:
 
+==============
 DVB CA close()
 ==============
 
-Description
------------
+NAME
+----
 
-This system call closes a previously opened audio device.
+DVB CA close()
 
-Synopsis
+SYNOPSIS
 --------
 
 .. cpp:function:: int  close(int fd)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -32,11 +32,15 @@ Arguments
        -  File descriptor returned by a previous call to open().
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This system call closes a previously opened audio device.
+
+
+RETURN VALUE
 ------------
 
-
-
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
@@ -47,6 +51,3 @@ Return Value
        -  ``EBADF``
 
        -  fd is not a valid open file descriptor.
-
-
-
diff --git a/Documentation/linux_tv/media/dvb/ca-fopen.rst b/Documentation/linux_tv/media/dvb/ca-fopen.rst
index 316209439f88..a9bf45a921e9 100644
--- a/Documentation/linux_tv/media/dvb/ca-fopen.rst
+++ b/Documentation/linux_tv/media/dvb/ca-fopen.rst
@@ -2,34 +2,23 @@
 
 .. _ca_fopen:
 
+=============
 DVB CA open()
 =============
 
-Description
------------
-
-This system call opens a named ca device (e.g. /dev/ost/ca) for
-subsequent use.
+NAME
+----
 
-When an open() call has succeeded, the device will be ready for use. The
-significance of blocking or non-blocking mode is described in the
-documentation for functions where there is a difference. It does not
-affect the semantics of the open() call itself. A device opened in
-blocking mode can later be put into non-blocking mode (and vice versa)
-using the F_SETFL command of the fcntl system call. This is a standard
-system call, documented in the Linux manual page for fcntl. Only one
-user can open the CA Device in O_RDWR mode. All other attempts to open
-the device in this mode will fail, and an error code will be returned.
+DVB CA open()
 
-Synopsis
+SYNOPSIS
 --------
 
 .. cpp:function:: int  open(const char *deviceName, int flags)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -69,11 +58,26 @@ Arguments
        -  (blocking mode is the default)
 
 
-Return Value
+DESCRIPTION
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
+
+RETURN VALUE
 ------------
 
-
-
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
@@ -102,6 +106,3 @@ Return Value
        -  ``EINVAL``
 
        -  Invalid argument.
-
-
-
diff --git a/Documentation/linux_tv/media/dvb/ca-get-cap.rst b/Documentation/linux_tv/media/dvb/ca-get-cap.rst
index 9155e0b445ff..b026d4769730 100644
--- a/Documentation/linux_tv/media/dvb/ca-get-cap.rst
+++ b/Documentation/linux_tv/media/dvb/ca-get-cap.rst
@@ -2,23 +2,23 @@
 
 .. _CA_GET_CAP:
 
+==========
 CA_GET_CAP
 ==========
 
-Description
------------
+NAME
+----
 
-This ioctl is undocumented. Documentation is welcome.
+CA_GET_CAP
 
-Synopsis
+SYNOPSIS
 --------
 
 .. cpp:function:: int  ioctl(fd, int request = CA_GET_CAP, ca_caps_t *)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -44,11 +44,15 @@ Arguments
        -  Undocumented.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl is undocumented. Documentation is welcome.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
diff --git a/Documentation/linux_tv/media/dvb/ca-get-descr-info.rst b/Documentation/linux_tv/media/dvb/ca-get-descr-info.rst
index cf5e3b1d8358..446afe89af82 100644
--- a/Documentation/linux_tv/media/dvb/ca-get-descr-info.rst
+++ b/Documentation/linux_tv/media/dvb/ca-get-descr-info.rst
@@ -2,23 +2,23 @@
 
 .. _CA_GET_DESCR_INFO:
 
+=================
 CA_GET_DESCR_INFO
 =================
 
-Description
------------
+NAME
+----
 
-This ioctl is undocumented. Documentation is welcome.
+CA_GET_DESCR_INFO
 
-Synopsis
+SYNOPSIS
 --------
 
 .. cpp:function:: int  ioctl(fd, int request = CA_GET_DESCR_INFO, ca_descr_info_t *)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -44,11 +44,15 @@ Arguments
        -  Undocumented.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl is undocumented. Documentation is welcome.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
diff --git a/Documentation/linux_tv/media/dvb/ca-get-msg.rst b/Documentation/linux_tv/media/dvb/ca-get-msg.rst
index 994d73a59992..44c944a700c0 100644
--- a/Documentation/linux_tv/media/dvb/ca-get-msg.rst
+++ b/Documentation/linux_tv/media/dvb/ca-get-msg.rst
@@ -2,23 +2,23 @@
 
 .. _CA_GET_MSG:
 
+==========
 CA_GET_MSG
 ==========
 
-Description
------------
+NAME
+----
 
-This ioctl is undocumented. Documentation is welcome.
+CA_GET_MSG
 
-Synopsis
+SYNOPSIS
 --------
 
 .. cpp:function:: int  ioctl(fd, int request = CA_GET_MSG, ca_msg_t *)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -44,11 +44,15 @@ Arguments
        -  Undocumented.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl is undocumented. Documentation is welcome.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
diff --git a/Documentation/linux_tv/media/dvb/ca-get-slot-info.rst b/Documentation/linux_tv/media/dvb/ca-get-slot-info.rst
index 8c123aaf5538..e1e580341dad 100644
--- a/Documentation/linux_tv/media/dvb/ca-get-slot-info.rst
+++ b/Documentation/linux_tv/media/dvb/ca-get-slot-info.rst
@@ -2,23 +2,23 @@
 
 .. _CA_GET_SLOT_INFO:
 
+================
 CA_GET_SLOT_INFO
 ================
 
-Description
------------
+NAME
+----
 
-This ioctl is undocumented. Documentation is welcome.
+CA_GET_SLOT_INFO
 
-Synopsis
+SYNOPSIS
 --------
 
 .. cpp:function:: int  ioctl(fd, int request = CA_GET_SLOT_INFO, ca_slot_info_t *)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -44,11 +44,15 @@ Arguments
        -  Undocumented.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl is undocumented. Documentation is welcome.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
diff --git a/Documentation/linux_tv/media/dvb/ca-reset.rst b/Documentation/linux_tv/media/dvb/ca-reset.rst
index 4fa2597ea983..ff58c62fb0a5 100644
--- a/Documentation/linux_tv/media/dvb/ca-reset.rst
+++ b/Documentation/linux_tv/media/dvb/ca-reset.rst
@@ -2,23 +2,23 @@
 
 .. _CA_RESET:
 
+========
 CA_RESET
 ========
 
-Description
------------
+NAME
+----
 
-This ioctl is undocumented. Documentation is welcome.
+CA_RESET
 
-Synopsis
+SYNOPSIS
 --------
 
 .. cpp:function:: int  ioctl(fd, int request = CA_RESET)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -38,11 +38,15 @@ Arguments
        -  Equals CA_RESET for this command.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl is undocumented. Documentation is welcome.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
diff --git a/Documentation/linux_tv/media/dvb/ca-send-msg.rst b/Documentation/linux_tv/media/dvb/ca-send-msg.rst
index cb9249561d8a..9d9b8d2520c1 100644
--- a/Documentation/linux_tv/media/dvb/ca-send-msg.rst
+++ b/Documentation/linux_tv/media/dvb/ca-send-msg.rst
@@ -2,23 +2,23 @@
 
 .. _CA_SEND_MSG:
 
+===========
 CA_SEND_MSG
 ===========
 
-Description
------------
+NAME
+----
 
-This ioctl is undocumented. Documentation is welcome.
+CA_SEND_MSG
 
-Synopsis
+SYNOPSIS
 --------
 
 .. cpp:function:: int  ioctl(fd, int request = CA_SEND_MSG, ca_msg_t *)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -44,11 +44,15 @@ Arguments
        -  Undocumented.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl is undocumented. Documentation is welcome.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
diff --git a/Documentation/linux_tv/media/dvb/ca-set-descr.rst b/Documentation/linux_tv/media/dvb/ca-set-descr.rst
index 5b56e414da24..e992dd52432d 100644
--- a/Documentation/linux_tv/media/dvb/ca-set-descr.rst
+++ b/Documentation/linux_tv/media/dvb/ca-set-descr.rst
@@ -2,23 +2,23 @@
 
 .. _CA_SET_DESCR:
 
+============
 CA_SET_DESCR
 ============
 
-Description
------------
+NAME
+----
 
-This ioctl is undocumented. Documentation is welcome.
+CA_SET_DESCR
 
-Synopsis
+SYNOPSIS
 --------
 
 .. cpp:function:: int  ioctl(fd, int request = CA_SET_DESCR, ca_descr_t *)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -44,11 +44,15 @@ Arguments
        -  Undocumented.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl is undocumented. Documentation is welcome.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
diff --git a/Documentation/linux_tv/media/dvb/ca-set-pid.rst b/Documentation/linux_tv/media/dvb/ca-set-pid.rst
index 3d4b7e823c15..e7e3891fa65e 100644
--- a/Documentation/linux_tv/media/dvb/ca-set-pid.rst
+++ b/Documentation/linux_tv/media/dvb/ca-set-pid.rst
@@ -2,23 +2,23 @@
 
 .. _CA_SET_PID:
 
+==========
 CA_SET_PID
 ==========
 
-Description
------------
+NAME
+----
 
-This ioctl is undocumented. Documentation is welcome.
+CA_SET_PID
 
-Synopsis
+SYNOPSIS
 --------
 
 .. cpp:function:: int  ioctl(fd, int request = CA_SET_PID, ca_pid_t *)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -44,7 +44,13 @@ Arguments
        -  Undocumented.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl is undocumented. Documentation is welcome.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/dmx-add-pid.rst b/Documentation/linux_tv/media/dvb/dmx-add-pid.rst
index d6fd0a351a51..36bca4f9317c 100644
--- a/Documentation/linux_tv/media/dvb/dmx-add-pid.rst
+++ b/Documentation/linux_tv/media/dvb/dmx-add-pid.rst
@@ -2,25 +2,23 @@
 
 .. _DMX_ADD_PID:
 
+===========
 DMX_ADD_PID
 ===========
 
-Description
------------
+NAME
+----
 
-This ioctl call allows to add multiple PIDs to a transport stream filter
-previously set up with DMX_SET_PES_FILTER and output equal to
-DMX_OUT_TSDEMUX_TAP.
+DMX_ADD_PID
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int ioctl(fd, int request = DMX_ADD_PID, __u16 *)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -46,11 +44,17 @@ Arguments
        -  PID number to be filtered.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl call allows to add multiple PIDs to a transport stream filter
+previously set up with DMX_SET_PES_FILTER and output equal to
+DMX_OUT_TSDEMUX_TAP.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
diff --git a/Documentation/linux_tv/media/dvb/dmx-fclose.rst b/Documentation/linux_tv/media/dvb/dmx-fclose.rst
index 079e944b8fc8..7889d0b76f7d 100644
--- a/Documentation/linux_tv/media/dvb/dmx-fclose.rst
+++ b/Documentation/linux_tv/media/dvb/dmx-fclose.rst
@@ -2,24 +2,23 @@
 
 .. _dmx_fclose:
 
+=================
 DVB demux close()
 =================
 
-Description
------------
+NAME
+----
 
-This system call deactivates and deallocates a filter that was
-previously allocated via the open() call.
+DVB demux close()
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int close(int fd)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -33,11 +32,16 @@ Arguments
        -  File descriptor returned by a previous call to open().
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This system call deactivates and deallocates a filter that was
+previously allocated via the open() call.
+
+
+RETURN VALUE
 ------------
 
-
-
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
@@ -48,6 +52,3 @@ Return Value
        -  ``EBADF``
 
        -  fd is not a valid open file descriptor.
-
-
-
diff --git a/Documentation/linux_tv/media/dvb/dmx-fopen.rst b/Documentation/linux_tv/media/dvb/dmx-fopen.rst
index 9d6d84d7b608..1e1dbc57c64d 100644
--- a/Documentation/linux_tv/media/dvb/dmx-fopen.rst
+++ b/Documentation/linux_tv/media/dvb/dmx-fopen.rst
@@ -2,10 +2,58 @@
 
 .. _dmx_fopen:
 
+================
 DVB demux open()
 ================
 
-Description
+NAME
+----
+
+DVB demux open()
+
+SYNOPSIS
+--------
+
+.. c:function:: int open(const char *deviceName, int flags)
+
+
+ARGUMENTS
+---------
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
+DESCRIPTION
 -----------
 
 This system call, used with a device name of /dev/dvb/adapter0/demux0,
@@ -25,54 +73,10 @@ affect the semantics of the open() call itself. A device opened in
 blocking mode can later be put into non-blocking mode (and vice versa)
 using the F_SETFL command of the fcntl system call.
 
-Synopsis
---------
 
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
+RETURN VALUE
 ------------
 
-
-
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
@@ -101,6 +105,3 @@ Return Value
        -  ``ENOMEM``
 
        -  The driver failed to allocate enough memory.
-
-
-
diff --git a/Documentation/linux_tv/media/dvb/dmx-fread.rst b/Documentation/linux_tv/media/dvb/dmx-fread.rst
index 66811dbe6dac..55d9bc7f424d 100644
--- a/Documentation/linux_tv/media/dvb/dmx-fread.rst
+++ b/Documentation/linux_tv/media/dvb/dmx-fread.rst
@@ -2,26 +2,23 @@
 
 .. _dmx_fread:
 
+================
 DVB demux read()
 ================
 
-Description
------------
+NAME
+----
 
-This system call returns filtered data, which might be section or PES
-data. The filtered data is transferred from the driver’s internal
-circular buffer to buf. The maximum amount of data to be transferred is
-implied by count.
+DVB demux read()
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: size_t read(int fd, void *buf, size_t count)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -47,11 +44,18 @@ Arguments
        -  Size of buf.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This system call returns filtered data, which might be section or PES
+data. The filtered data is transferred from the driver’s internal
+circular buffer to buf. The maximum amount of data to be transferred is
+implied by count.
+
+
+RETURN VALUE
 ------------
 
-
-
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
@@ -101,6 +105,3 @@ Return Value
 
        -  The driver failed to write to the callers buffer due to an invalid
 	  \*buf pointer.
-
-
-
diff --git a/Documentation/linux_tv/media/dvb/dmx-fwrite.rst b/Documentation/linux_tv/media/dvb/dmx-fwrite.rst
index 57aef82c77b2..f39743684966 100644
--- a/Documentation/linux_tv/media/dvb/dmx-fwrite.rst
+++ b/Documentation/linux_tv/media/dvb/dmx-fwrite.rst
@@ -2,28 +2,23 @@
 
 .. _dmx_fwrite:
 
+=================
 DVB demux write()
 =================
 
-Description
------------
+NAME
+----
 
-This system call is only provided by the logical device
-/dev/dvb/adapter0/dvr0, associated with the physical demux device that
-provides the actual DVR functionality. It is used for replay of a
-digitally recorded Transport Stream. Matching filters have to be defined
-in the corresponding physical demux device, /dev/dvb/adapter0/demux0.
-The amount of data to be transferred is implied by count.
+DVB demux write()
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: ssize_t write(int fd, const void *buf, size_t count)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -49,11 +44,20 @@ Arguments
        -  Size of buf.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This system call is only provided by the logical device
+/dev/dvb/adapter0/dvr0, associated with the physical demux device that
+provides the actual DVR functionality. It is used for replay of a
+digitally recorded Transport Stream. Matching filters have to be defined
+in the corresponding physical demux device, /dev/dvb/adapter0/demux0.
+The amount of data to be transferred is implied by count.
+
+
+RETURN VALUE
 ------------
 
-
-
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
@@ -82,6 +86,3 @@ Return Value
        -  ``EBADF``
 
        -  fd is not a valid open file descriptor.
-
-
-
diff --git a/Documentation/linux_tv/media/dvb/dmx-get-caps.rst b/Documentation/linux_tv/media/dvb/dmx-get-caps.rst
index 56bba7b3fc6c..8c8ae48a93da 100644
--- a/Documentation/linux_tv/media/dvb/dmx-get-caps.rst
+++ b/Documentation/linux_tv/media/dvb/dmx-get-caps.rst
@@ -2,23 +2,23 @@
 
 .. _DMX_GET_CAPS:
 
+============
 DMX_GET_CAPS
 ============
 
-Description
------------
+NAME
+----
 
-This ioctl is undocumented. Documentation is welcome.
+DMX_GET_CAPS
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int ioctl(fd, int request = DMX_GET_CAPS, dmx_caps_t *)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -44,11 +44,15 @@ Arguments
        -  Undocumented.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl is undocumented. Documentation is welcome.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
diff --git a/Documentation/linux_tv/media/dvb/dmx-get-event.rst b/Documentation/linux_tv/media/dvb/dmx-get-event.rst
index 8664d43f4334..ab2ab2ed3bed 100644
--- a/Documentation/linux_tv/media/dvb/dmx-get-event.rst
+++ b/Documentation/linux_tv/media/dvb/dmx-get-event.rst
@@ -2,27 +2,23 @@
 
 .. _DMX_GET_EVENT:
 
+=============
 DMX_GET_EVENT
 =============
 
-Description
------------
+NAME
+----
 
-This ioctl call returns an event if available. If an event is not
-available, the behavior depends on whether the device is in blocking or
-non-blocking mode. In the latter case, the call fails immediately with
-errno set to ``EWOULDBLOCK``. In the former case, the call blocks until an
-event becomes available.
+DMX_GET_EVENT
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int ioctl( int fd, int request = DMX_GET_EVENT, struct dmx_event *ev)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -48,7 +44,17 @@ Arguments
        -  Pointer to the location where the event is to be stored.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl call returns an event if available. If an event is not
+available, the behavior depends on whether the device is in blocking or
+non-blocking mode. In the latter case, the call fails immediately with
+errno set to ``EWOULDBLOCK``. In the former case, the call blocks until an
+event becomes available.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
@@ -67,6 +73,3 @@ appropriately. The generic error codes are described at the
        -  ``EWOULDBLOCK``
 
        -  There is no event pending, and the device is in non-blocking mode.
-
-
-
diff --git a/Documentation/linux_tv/media/dvb/dmx-get-pes-pids.rst b/Documentation/linux_tv/media/dvb/dmx-get-pes-pids.rst
index 39d6ae6db620..cf0d8a6463fb 100644
--- a/Documentation/linux_tv/media/dvb/dmx-get-pes-pids.rst
+++ b/Documentation/linux_tv/media/dvb/dmx-get-pes-pids.rst
@@ -2,23 +2,23 @@
 
 .. _DMX_GET_PES_PIDS:
 
+================
 DMX_GET_PES_PIDS
 ================
 
-Description
------------
+NAME
+----
 
-This ioctl is undocumented. Documentation is welcome.
+DMX_GET_PES_PIDS
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int ioctl(fd, int request = DMX_GET_PES_PIDS, __u16[5])
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -44,11 +44,15 @@ Arguments
        -  Undocumented.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl is undocumented. Documentation is welcome.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
diff --git a/Documentation/linux_tv/media/dvb/dmx-get-stc.rst b/Documentation/linux_tv/media/dvb/dmx-get-stc.rst
index 6081d959b4ad..35dd691dee09 100644
--- a/Documentation/linux_tv/media/dvb/dmx-get-stc.rst
+++ b/Documentation/linux_tv/media/dvb/dmx-get-stc.rst
@@ -2,28 +2,23 @@
 
 .. _DMX_GET_STC:
 
+===========
 DMX_GET_STC
 ===========
 
-Description
------------
+NAME
+----
 
-This ioctl call returns the current value of the system time counter
-(which is driven by a PES filter of type DMX_PES_PCR). Some hardware
-supports more than one STC, so you must specify which one by setting the
-num field of stc before the ioctl (range 0...n). The result is returned
-in form of a ratio with a 64 bit numerator and a 32 bit denominator, so
-the real 90kHz STC value is stc->stc / stc->base .
+DMX_GET_STC
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int ioctl( int fd, int request = DMX_GET_STC, struct dmx_stc *stc)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -49,7 +44,18 @@ Arguments
        -  Pointer to the location where the stc is to be stored.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl call returns the current value of the system time counter
+(which is driven by a PES filter of type DMX_PES_PCR). Some hardware
+supports more than one STC, so you must specify which one by setting the
+num field of stc before the ioctl (range 0...n). The result is returned
+in form of a ratio with a 64 bit numerator and a 32 bit denominator, so
+the real 90kHz STC value is stc->stc / stc->base .
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
@@ -68,6 +74,3 @@ appropriately. The generic error codes are described at the
        -  ``EINVAL``
 
        -  Invalid stc number.
-
-
-
diff --git a/Documentation/linux_tv/media/dvb/dmx-remove-pid.rst b/Documentation/linux_tv/media/dvb/dmx-remove-pid.rst
index 9e38eb8db6f8..859e1a14de54 100644
--- a/Documentation/linux_tv/media/dvb/dmx-remove-pid.rst
+++ b/Documentation/linux_tv/media/dvb/dmx-remove-pid.rst
@@ -2,26 +2,23 @@
 
 .. _DMX_REMOVE_PID:
 
+==============
 DMX_REMOVE_PID
 ==============
 
-Description
------------
+NAME
+----
 
-This ioctl call allows to remove a PID when multiple PIDs are set on a
-transport stream filter, e. g. a filter previously set up with output
-equal to DMX_OUT_TSDEMUX_TAP, created via either
-DMX_SET_PES_FILTER or DMX_ADD_PID.
+DMX_REMOVE_PID
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int ioctl(fd, int request = DMX_REMOVE_PID, __u16 *)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -47,7 +44,16 @@ Arguments
        -  PID of the PES filter to be removed.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl call allows to remove a PID when multiple PIDs are set on a
+transport stream filter, e. g. a filter previously set up with output
+equal to DMX_OUT_TSDEMUX_TAP, created via either
+DMX_SET_PES_FILTER or DMX_ADD_PID.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/dmx-set-buffer-size.rst b/Documentation/linux_tv/media/dvb/dmx-set-buffer-size.rst
index a5074a6ac48e..cf6b32f4e361 100644
--- a/Documentation/linux_tv/media/dvb/dmx-set-buffer-size.rst
+++ b/Documentation/linux_tv/media/dvb/dmx-set-buffer-size.rst
@@ -2,26 +2,23 @@
 
 .. _DMX_SET_BUFFER_SIZE:
 
+===================
 DMX_SET_BUFFER_SIZE
 ===================
 
-Description
------------
+NAME
+----
 
-This ioctl call is used to set the size of the circular buffer used for
-filtered data. The default size is two maximum sized sections, i.e. if
-this function is not called a buffer size of 2 \* 4096 bytes will be
-used.
+DMX_SET_BUFFER_SIZE
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int ioctl( int fd, int request = DMX_SET_BUFFER_SIZE, unsigned long size)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -47,11 +44,18 @@ Arguments
        -  Size of circular buffer.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl call is used to set the size of the circular buffer used for
+filtered data. The default size is two maximum sized sections, i.e. if
+this function is not called a buffer size of 2 \* 4096 bytes will be
+used.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
diff --git a/Documentation/linux_tv/media/dvb/dmx-set-filter.rst b/Documentation/linux_tv/media/dvb/dmx-set-filter.rst
index 548af600d635..0aad102f3151 100644
--- a/Documentation/linux_tv/media/dvb/dmx-set-filter.rst
+++ b/Documentation/linux_tv/media/dvb/dmx-set-filter.rst
@@ -2,32 +2,23 @@
 
 .. _DMX_SET_FILTER:
 
+==============
 DMX_SET_FILTER
 ==============
 
-Description
------------
+NAME
+----
 
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
+DMX_SET_FILTER
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int ioctl( int fd, int request = DMX_SET_FILTER, struct dmx_sct_filter_params *params)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -53,11 +44,24 @@ Arguments
        -  Pointer to structure containing filter parameters.
 
 
-Return Value
+DESCRIPTION
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
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
diff --git a/Documentation/linux_tv/media/dvb/dmx-set-pes-filter.rst b/Documentation/linux_tv/media/dvb/dmx-set-pes-filter.rst
index 7d9b6dabc772..3dccd7cd0a64 100644
--- a/Documentation/linux_tv/media/dvb/dmx-set-pes-filter.rst
+++ b/Documentation/linux_tv/media/dvb/dmx-set-pes-filter.rst
@@ -2,26 +2,23 @@
 
 .. _DMX_SET_PES_FILTER:
 
+==================
 DMX_SET_PES_FILTER
 ==================
 
-Description
------------
+NAME
+----
 
-This ioctl call sets up a PES filter according to the parameters
-provided. By a PES filter is meant a filter that is based just on the
-packet identifier (PID), i.e. no PES header or payload filtering
-capability is supported.
+DMX_SET_PES_FILTER
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int ioctl( int fd, int request = DMX_SET_PES_FILTER, struct dmx_pes_filter_params *params)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -47,7 +44,16 @@ Arguments
        -  Pointer to structure containing filter parameters.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl call sets up a PES filter according to the parameters
+provided. By a PES filter is meant a filter that is based just on the
+packet identifier (PID), i.e. no PES header or payload filtering
+capability is supported.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
@@ -69,6 +75,3 @@ appropriately. The generic error codes are described at the
 	  There are active filters filtering data from another input source.
 	  Make sure that these filters are stopped before starting this
 	  filter.
-
-
-
diff --git a/Documentation/linux_tv/media/dvb/dmx-set-source.rst b/Documentation/linux_tv/media/dvb/dmx-set-source.rst
index e97b1c962ed6..13045327857f 100644
--- a/Documentation/linux_tv/media/dvb/dmx-set-source.rst
+++ b/Documentation/linux_tv/media/dvb/dmx-set-source.rst
@@ -2,23 +2,23 @@
 
 .. _DMX_SET_SOURCE:
 
+==============
 DMX_SET_SOURCE
 ==============
 
-Description
------------
+NAME
+----
 
-This ioctl is undocumented. Documentation is welcome.
+DMX_SET_SOURCE
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int ioctl(fd, int request = DMX_SET_SOURCE, dmx_source_t *)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -44,11 +44,15 @@ Arguments
        -  Undocumented.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl is undocumented. Documentation is welcome.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
diff --git a/Documentation/linux_tv/media/dvb/dmx-start.rst b/Documentation/linux_tv/media/dvb/dmx-start.rst
index dd446da18f97..c62e2ad17a6a 100644
--- a/Documentation/linux_tv/media/dvb/dmx-start.rst
+++ b/Documentation/linux_tv/media/dvb/dmx-start.rst
@@ -2,24 +2,23 @@
 
 .. _DMX_START:
 
+=========
 DMX_START
 =========
 
-Description
------------
+NAME
+----
 
-This ioctl call is used to start the actual filtering operation defined
-via the ioctl calls DMX_SET_FILTER or DMX_SET_PES_FILTER.
+DMX_START
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int ioctl( int fd, int request = DMX_START)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -39,7 +38,14 @@ Arguments
        -  Equals DMX_START for this command.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl call is used to start the actual filtering operation defined
+via the ioctl calls DMX_SET_FILTER or DMX_SET_PES_FILTER.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
@@ -68,6 +74,3 @@ appropriately. The generic error codes are described at the
 	  There are active filters filtering data from another input source.
 	  Make sure that these filters are stopped before starting this
 	  filter.
-
-
-
diff --git a/Documentation/linux_tv/media/dvb/dmx-stop.rst b/Documentation/linux_tv/media/dvb/dmx-stop.rst
index 150c9f79b55f..ff9df400f71f 100644
--- a/Documentation/linux_tv/media/dvb/dmx-stop.rst
+++ b/Documentation/linux_tv/media/dvb/dmx-stop.rst
@@ -2,25 +2,23 @@
 
 .. _DMX_STOP:
 
+========
 DMX_STOP
 ========
 
-Description
------------
+NAME
+----
 
-This ioctl call is used to stop the actual filtering operation defined
-via the ioctl calls DMX_SET_FILTER or DMX_SET_PES_FILTER and
-started via the DMX_START command.
+DMX_STOP
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int ioctl( int fd, int request = DMX_STOP)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -40,11 +38,17 @@ Arguments
        -  Equals DMX_STOP for this command.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl call is used to stop the actual filtering operation defined
+via the ioctl calls DMX_SET_FILTER or DMX_SET_PES_FILTER and
+started via the DMX_START command.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
diff --git a/Documentation/linux_tv/media/dvb/fe-diseqc-recv-slave-reply.rst b/Documentation/linux_tv/media/dvb/fe-diseqc-recv-slave-reply.rst
index 67e53787cc1e..60241c6e68a8 100644
--- a/Documentation/linux_tv/media/dvb/fe-diseqc-recv-slave-reply.rst
+++ b/Documentation/linux_tv/media/dvb/fe-diseqc-recv-slave-reply.rst
@@ -6,17 +6,18 @@
 ioctl FE_DISEQC_RECV_SLAVE_REPLY
 ********************************
 
-*man FE_DISEQC_RECV_SLAVE_REPLY(2)*
+NAME
+====
 
-Receives reply from a DiSEqC 2.0 command
+FE_DISEQC_RECV_SLAVE_REPLY - Receives reply from a DiSEqC 2.0 command
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct dvb_diseqc_slave_reply *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -30,12 +31,14 @@ Arguments
     :ref:`dvb_diseqc_slave_reply <dvb-diseqc-slave-reply>`
 
 
-Description
+DESCRIPTION
 ===========
 
 Receives reply from a DiSEqC 2.0 command.
 
+
 RETURN VALUE
+============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
diff --git a/Documentation/linux_tv/media/dvb/fe-diseqc-reset-overload.rst b/Documentation/linux_tv/media/dvb/fe-diseqc-reset-overload.rst
index 2c64eab598b8..236c25c9f7bd 100644
--- a/Documentation/linux_tv/media/dvb/fe-diseqc-reset-overload.rst
+++ b/Documentation/linux_tv/media/dvb/fe-diseqc-reset-overload.rst
@@ -6,18 +6,18 @@
 ioctl FE_DISEQC_RESET_OVERLOAD
 ******************************
 
-*man FE_DISEQC_RESET_OVERLOAD(2)*
+NAME
+====
 
-Restores the power to the antenna subsystem, if it was powered off due
-to power overload.
+FE_DISEQC_RESET_OVERLOAD - Restores the power to the antenna subsystem, if it was powered off due - to power overload.
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, NULL )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -27,7 +27,7 @@ Arguments
     FE_DISEQC_RESET_OVERLOAD
 
 
-Description
+DESCRIPTION
 ===========
 
 If the bus has been automatically powered off due to power overload,
@@ -35,7 +35,9 @@ this ioctl call restores the power to the bus. The call requires
 read/write access to the device. This call has no effect if the device
 is manually powered off. Not all DVB adapters support this ioctl.
 
+
 RETURN VALUE
+============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
diff --git a/Documentation/linux_tv/media/dvb/fe-diseqc-send-burst.rst b/Documentation/linux_tv/media/dvb/fe-diseqc-send-burst.rst
index 35de0278a064..dea9cdff0469 100644
--- a/Documentation/linux_tv/media/dvb/fe-diseqc-send-burst.rst
+++ b/Documentation/linux_tv/media/dvb/fe-diseqc-send-burst.rst
@@ -6,17 +6,18 @@
 ioctl FE_DISEQC_SEND_BURST
 **************************
 
-*man FE_DISEQC_SEND_BURST(2)*
+NAME
+====
 
-Sends a 22KHz tone burst for 2x1 mini DiSEqC satellite selection.
+FE_DISEQC_SEND_BURST - Sends a 22KHz tone burst for 2x1 mini DiSEqC satellite selection.
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. c:function:: int ioctl( int fd, int request, enum fe_sec_mini_cmd *tone )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -29,7 +30,7 @@ Arguments
     pointer to enum :ref:`fe_sec_mini_cmd <fe-sec-mini-cmd>`
 
 
-Description
+DESCRIPTION
 ===========
 
 This ioctl is used to set the generation of a 22kHz tone burst for mini
@@ -39,7 +40,9 @@ read/write permissions.
 It provides support for what's specified at
 `Digital Satellite Equipment Control (DiSEqC) - Simple "ToneBurst" Detection Circuit specification. <http://www.eutelsat.com/files/contributed/satellites/pdf/Diseqc/associated%20docs/simple_tone_burst_detec.pdf>`__
 
+
 RETURN VALUE
+============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
diff --git a/Documentation/linux_tv/media/dvb/fe-diseqc-send-master-cmd.rst b/Documentation/linux_tv/media/dvb/fe-diseqc-send-master-cmd.rst
index 04c6cc8ae070..519e91bd47fd 100644
--- a/Documentation/linux_tv/media/dvb/fe-diseqc-send-master-cmd.rst
+++ b/Documentation/linux_tv/media/dvb/fe-diseqc-send-master-cmd.rst
@@ -6,17 +6,18 @@
 ioctl FE_DISEQC_SEND_MASTER_CMD
 *******************************
 
-*man FE_DISEQC_SEND_MASTER_CMD(2)*
+NAME
+====
 
-Sends a DiSEqC command
+FE_DISEQC_SEND_MASTER_CMD - Sends a DiSEqC command
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct dvb_diseqc_master_cmd *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -30,12 +31,14 @@ Arguments
     :ref:`dvb_diseqc_master_cmd <dvb-diseqc-master-cmd>`
 
 
-Description
+DESCRIPTION
 ===========
 
 Sends a DiSEqC command to the antenna subsystem.
 
+
 RETURN VALUE
+============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
diff --git a/Documentation/linux_tv/media/dvb/fe-enable-high-lnb-voltage.rst b/Documentation/linux_tv/media/dvb/fe-enable-high-lnb-voltage.rst
index 669dbd6e79b8..27f49823e67d 100644
--- a/Documentation/linux_tv/media/dvb/fe-enable-high-lnb-voltage.rst
+++ b/Documentation/linux_tv/media/dvb/fe-enable-high-lnb-voltage.rst
@@ -6,18 +6,18 @@
 ioctl FE_ENABLE_HIGH_LNB_VOLTAGE
 ********************************
 
-*man FE_ENABLE_HIGH_LNB_VOLTAGE(2)*
+NAME
+====
 
-Select output DC level between normal LNBf voltages or higher LNBf
-voltages.
+FE_ENABLE_HIGH_LNB_VOLTAGE - Select output DC level between normal LNBf voltages or higher LNBf - voltages.
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, unsigned int high )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -35,14 +35,16 @@ Arguments
        to compensate for long antenna cables.
 
 
-Description
+DESCRIPTION
 ===========
 
 Select output DC level between normal LNBf voltages or higher LNBf
 voltages between 0 (normal) or a value grater than 0 for higher
 voltages.
 
+
 RETURN VALUE
+============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
diff --git a/Documentation/linux_tv/media/dvb/fe-get-info.rst b/Documentation/linux_tv/media/dvb/fe-get-info.rst
index 97743d9418ac..d97218805851 100644
--- a/Documentation/linux_tv/media/dvb/fe-get-info.rst
+++ b/Documentation/linux_tv/media/dvb/fe-get-info.rst
@@ -6,18 +6,18 @@
 ioctl FE_GET_INFO
 *****************
 
-*man FE_GET_INFO(2)*
+NAME
+====
 
-Query DVB frontend capabilities and returns information about the
-front-end. This call only requires read-only access to the device
+FE_GET_INFO - Query DVB frontend capabilities and returns information about the - front-end. This call only requires read-only access to the device
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct dvb_frontend_info *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -31,7 +31,7 @@ Arguments
     :ref:`dvb_frontend_info <dvb-frontend-info>`
 
 
-Description
+DESCRIPTION
 ===========
 
 All DVB frontend devices support the ``FE_GET_INFO`` ioctl. It is used
@@ -41,7 +41,9 @@ takes a pointer to dvb_frontend_info which is filled by the driver.
 When the driver is not compatible with this specification the ioctl
 returns an error.
 
+
 RETURN VALUE
+============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
diff --git a/Documentation/linux_tv/media/dvb/fe-get-property.rst b/Documentation/linux_tv/media/dvb/fe-get-property.rst
index 0edc9291fc70..c470105dcd15 100644
--- a/Documentation/linux_tv/media/dvb/fe-get-property.rst
+++ b/Documentation/linux_tv/media/dvb/fe-get-property.rst
@@ -6,19 +6,18 @@
 ioctl FE_SET_PROPERTY, FE_GET_PROPERTY
 **************************************
 
-*man FE_SET_PROPERTY(2)*
+NAME
+====
 
-FE_GET_PROPERTY
-FE_SET_PROPERTY sets one or more frontend properties.
-FE_GET_PROPERTY returns one or more frontend properties.
+FE_SET_PROPERTY - FE_GET_PROPERTY - FE_SET_PROPERTY sets one or more frontend properties. - FE_GET_PROPERTY returns one or more frontend properties.
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct dtv_properties *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -31,7 +30,7 @@ Arguments
     pointer to struct :ref:`dtv_properties <dtv-properties>`
 
 
-Description
+DESCRIPTION
 ===========
 
 All DVB frontend devices support the ``FE_SET_PROPERTY`` and
@@ -59,7 +58,9 @@ depends on the delivery system and on the device:
 
    -  This call only requires read-only access to the device.
 
+
 RETURN VALUE
+============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
diff --git a/Documentation/linux_tv/media/dvb/fe-read-status.rst b/Documentation/linux_tv/media/dvb/fe-read-status.rst
index 56347eed3703..ac6f23869530 100644
--- a/Documentation/linux_tv/media/dvb/fe-read-status.rst
+++ b/Documentation/linux_tv/media/dvb/fe-read-status.rst
@@ -6,18 +6,18 @@
 ioctl FE_READ_STATUS
 ********************
 
-*man FE_READ_STATUS(2)*
+NAME
+====
 
-Returns status information about the front-end. This call only requires
-read-only access to the device
+FE_READ_STATUS - Returns status information about the front-end. This call only requires - read-only access to the device
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, unsigned int *status )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -31,7 +31,7 @@ Arguments
     :ref:`fe_status <fe-status>`.
 
 
-Description
+DESCRIPTION
 ===========
 
 All DVB frontend devices support the ``FE_READ_STATUS`` ioctl. It is
@@ -43,7 +43,9 @@ NOTE: the size of status is actually sizeof(enum fe_status), with
 varies according with the architecture. This needs to be fixed in the
 future.
 
+
 RETURN VALUE
+============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
diff --git a/Documentation/linux_tv/media/dvb/fe-set-frontend-tune-mode.rst b/Documentation/linux_tv/media/dvb/fe-set-frontend-tune-mode.rst
index aeecb947fa70..1db22c426b8c 100644
--- a/Documentation/linux_tv/media/dvb/fe-set-frontend-tune-mode.rst
+++ b/Documentation/linux_tv/media/dvb/fe-set-frontend-tune-mode.rst
@@ -6,17 +6,18 @@
 ioctl FE_SET_FRONTEND_TUNE_MODE
 *******************************
 
-*man FE_SET_FRONTEND_TUNE_MODE(2)*
+NAME
+====
 
-Allow setting tuner mode flags to the frontend.
+FE_SET_FRONTEND_TUNE_MODE - Allow setting tuner mode flags to the frontend.
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, unsigned int flags )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -38,13 +39,15 @@ Arguments
        device is reopened read-write.
 
 
-Description
+DESCRIPTION
 ===========
 
 Allow setting tuner mode flags to the frontend, between 0 (normal) or
 FE_TUNE_MODE_ONESHOT mode
 
+
 RETURN VALUE
+============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
diff --git a/Documentation/linux_tv/media/dvb/fe-set-tone.rst b/Documentation/linux_tv/media/dvb/fe-set-tone.rst
index 5e80ee9988b0..afe8b750fca6 100644
--- a/Documentation/linux_tv/media/dvb/fe-set-tone.rst
+++ b/Documentation/linux_tv/media/dvb/fe-set-tone.rst
@@ -6,17 +6,18 @@
 ioctl FE_SET_TONE
 *****************
 
-*man FE_SET_TONE(2)*
+NAME
+====
 
-Sets/resets the generation of the continuous 22kHz tone.
+FE_SET_TONE - Sets/resets the generation of the continuous 22kHz tone.
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. c:function:: int ioctl( int fd, int request, enum fe_sec_tone_mode *tone )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -29,7 +30,7 @@ Arguments
     pointer to enum :ref:`fe_sec_tone_mode <fe-sec-tone-mode>`
 
 
-Description
+DESCRIPTION
 ===========
 
 This ioctl is used to set the generation of the continuous 22kHz tone.
@@ -45,7 +46,9 @@ a tone may interfere on other devices, as they may lose the capability
 of selecting the band. So, it is recommended that applications would
 change to SEC_TONE_OFF when the device is not used.
 
+
 RETURN VALUE
+============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
diff --git a/Documentation/linux_tv/media/dvb/fe-set-voltage.rst b/Documentation/linux_tv/media/dvb/fe-set-voltage.rst
index 63c5f401e808..4fd30ee53f5b 100644
--- a/Documentation/linux_tv/media/dvb/fe-set-voltage.rst
+++ b/Documentation/linux_tv/media/dvb/fe-set-voltage.rst
@@ -6,17 +6,18 @@
 ioctl FE_SET_VOLTAGE
 ********************
 
-*man FE_SET_VOLTAGE(2)*
+NAME
+====
 
-Allow setting the DC level sent to the antenna subsystem.
+FE_SET_VOLTAGE - Allow setting the DC level sent to the antenna subsystem.
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. c:function:: int ioctl( int fd, int request, enum fe_sec_voltage *voltage )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -32,7 +33,7 @@ Arguments
     :ref:`fe_sec_voltage <fe-sec-voltage>`.
 
 
-Description
+DESCRIPTION
 ===========
 
 This ioctl allows to set the DC voltage level sent through the antenna
@@ -52,7 +53,9 @@ capability of setting polarization or IF. So, on those cases, setting
 the voltage to SEC_VOLTAGE_OFF while the device is not is used is
 recommended.
 
+
 RETURN VALUE
+============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
diff --git a/Documentation/linux_tv/media/dvb/frontend_f_close.rst b/Documentation/linux_tv/media/dvb/frontend_f_close.rst
index 8ca7f723ffc3..7946673d071a 100644
--- a/Documentation/linux_tv/media/dvb/frontend_f_close.rst
+++ b/Documentation/linux_tv/media/dvb/frontend_f_close.rst
@@ -6,12 +6,12 @@
 DVB frontend close()
 ********************
 
-*man fe-close(2)*
+NAME
+====
 
-Close a frontend device
+fe-close - Close a frontend device
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. code-block:: c
@@ -21,14 +21,15 @@ Synopsis
 
 .. cpp:function:: int close( int fd )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
 
-Description
+DESCRIPTION
 ===========
 
 This system call closes a previously opened front-end device. After
@@ -36,7 +37,7 @@ closing a front-end device, its corresponding hardware might be powered
 down automatically.
 
 
-Return Value
+RETURN VALUE
 ============
 
 The function returns 0 on success, -1 on failure and the ``errno`` is
diff --git a/Documentation/linux_tv/media/dvb/frontend_f_open.rst b/Documentation/linux_tv/media/dvb/frontend_f_open.rst
index d28c64514433..97ca34b94d05 100644
--- a/Documentation/linux_tv/media/dvb/frontend_f_open.rst
+++ b/Documentation/linux_tv/media/dvb/frontend_f_open.rst
@@ -6,12 +6,12 @@
 DVB frontend open()
 *******************
 
-*man fe-open(2)*
+NAME
+====
 
-Open a frontend device
+fe-open - Open a frontend device
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. code-block:: c
@@ -21,7 +21,8 @@ Synopsis
 
 .. cpp:function:: int open( const char *device_name, int flags )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``device_name``
@@ -43,7 +44,7 @@ Arguments
     Other flags have no effect.
 
 
-Description
+DESCRIPTION
 ===========
 
 This system call opens a named frontend device
@@ -69,7 +70,7 @@ powered up, and that other front-ends may have been powered down to make
 that possible.
 
 
-Return Value
+RETURN VALUE
 ============
 
 On success :ref:`open() <frontend_f_open>` returns the new file descriptor.
diff --git a/Documentation/linux_tv/media/dvb/net-add-if.rst b/Documentation/linux_tv/media/dvb/net-add-if.rst
index da0e7870c5d9..dc9735d871ee 100644
--- a/Documentation/linux_tv/media/dvb/net-add-if.rst
+++ b/Documentation/linux_tv/media/dvb/net-add-if.rst
@@ -6,17 +6,18 @@
 ioctl NET_ADD_IF
 ****************
 
-*man NET_ADD_IF(2)*
+NAME
+====
 
-Creates a new network interface for a given Packet ID.
+NET_ADD_IF - Creates a new network interface for a given Packet ID.
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct dvb_net_if *net_if )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -29,7 +30,7 @@ Arguments
     pointer to struct :ref:`dvb_net_if <dvb-net-if>`
 
 
-Description
+DESCRIPTION
 ===========
 
 The NET_ADD_IF ioctl system call selects the Packet ID (PID) that
@@ -80,7 +81,9 @@ struct dvb_net_if description
 	  ``DVB_NET_FEEDTYPE_MPE`` for MPE encoding or
 	  ``DVB_NET_FEEDTYPE_ULE`` for ULE encoding.
 
+
 RETURN VALUE
+============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
diff --git a/Documentation/linux_tv/media/dvb/net-get-if.rst b/Documentation/linux_tv/media/dvb/net-get-if.rst
index 4581763b920e..16dfe78eb77f 100644
--- a/Documentation/linux_tv/media/dvb/net-get-if.rst
+++ b/Documentation/linux_tv/media/dvb/net-get-if.rst
@@ -1,24 +1,23 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-
 .. _NET_GET_IF:
 
 ****************
 ioctl NET_GET_IF
 ****************
 
-*man NET_GET_IF(2)*
+NAME
+====
 
-Read the configuration data of an interface created via
-:ref:`NET_ADD_IF <net>`.
+NET_GET_IF - Read the configuration data of an interface created via - :ref:`NET_ADD_IF <net>`.
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct dvb_net_if *net_if )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -31,7 +30,7 @@ Arguments
     pointer to struct :ref:`dvb_net_if <dvb-net-if>`
 
 
-Description
+DESCRIPTION
 ===========
 
 The NET_GET_IF ioctl uses the interface number given by the struct
@@ -41,7 +40,9 @@ encapsulation type used on such interface. If the interface was not
 created yet with :ref:`NET_ADD_IF <net>`, it will return -1 and fill
 the ``errno`` with ``EINVAL`` error code.
 
+
 RETURN VALUE
+============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
diff --git a/Documentation/linux_tv/media/dvb/net-remove-if.rst b/Documentation/linux_tv/media/dvb/net-remove-if.rst
index 15a5d49f7a80..c4177833ecf6 100644
--- a/Documentation/linux_tv/media/dvb/net-remove-if.rst
+++ b/Documentation/linux_tv/media/dvb/net-remove-if.rst
@@ -6,17 +6,18 @@
 ioctl NET_REMOVE_IF
 *******************
 
-*man NET_REMOVE_IF(2)*
+NAME
+====
 
-Removes a network interface.
+NET_REMOVE_IF - Removes a network interface.
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, int ifnum )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -29,13 +30,15 @@ Arguments
     number of the interface to be removed
 
 
-Description
+DESCRIPTION
 ===========
 
 The NET_REMOVE_IF ioctl deletes an interface previously created via
 :ref:`NET_ADD_IF <net>`.
 
+
 RETURN VALUE
+============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
diff --git a/Documentation/linux_tv/media/dvb/video-clear-buffer.rst b/Documentation/linux_tv/media/dvb/video-clear-buffer.rst
index 65efef3cc0fc..e6d2825f4c9b 100644
--- a/Documentation/linux_tv/media/dvb/video-clear-buffer.rst
+++ b/Documentation/linux_tv/media/dvb/video-clear-buffer.rst
@@ -2,24 +2,23 @@
 
 .. _VIDEO_CLEAR_BUFFER:
 
+==================
 VIDEO_CLEAR_BUFFER
 ==================
 
-Description
------------
+NAME
+----
 
-This ioctl call clears all video buffers in the driver and in the
-decoder hardware.
+VIDEO_CLEAR_BUFFER
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int ioctl(fd, int request = VIDEO_CLEAR_BUFFER)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -39,11 +38,16 @@ Arguments
        -  Equals VIDEO_CLEAR_BUFFER for this command.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl call clears all video buffers in the driver and in the
+decoder hardware.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
diff --git a/Documentation/linux_tv/media/dvb/video-command.rst b/Documentation/linux_tv/media/dvb/video-command.rst
index 855a646a0f93..1743f40145ff 100644
--- a/Documentation/linux_tv/media/dvb/video-command.rst
+++ b/Documentation/linux_tv/media/dvb/video-command.rst
@@ -2,30 +2,23 @@
 
 .. _VIDEO_COMMAND:
 
+=============
 VIDEO_COMMAND
 =============
 
-Description
------------
-
-This ioctl is obsolete. Do not use in new drivers. For V4L2 decoders
-this ioctl has been replaced by the
-:ref:`VIDIOC_DECODER_CMD` ioctl.
+NAME
+----
 
-This ioctl commands the decoder. The ``video_command`` struct is a
-subset of the ``v4l2_decoder_cmd`` struct, so refer to the
-:ref:`VIDIOC_DECODER_CMD` documentation for
-more information.
+VIDEO_COMMAND
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int ioctl(int fd, int request = VIDEO_COMMAND, struct video_command *cmd)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -51,11 +44,22 @@ Arguments
        -  Commands the decoder.
 
 
-Return Value
+DESCRIPTION
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
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
diff --git a/Documentation/linux_tv/media/dvb/video-continue.rst b/Documentation/linux_tv/media/dvb/video-continue.rst
index 9d0f70b7c340..453a87dfb40d 100644
--- a/Documentation/linux_tv/media/dvb/video-continue.rst
+++ b/Documentation/linux_tv/media/dvb/video-continue.rst
@@ -2,27 +2,23 @@
 
 .. _VIDEO_CONTINUE:
 
+==============
 VIDEO_CONTINUE
 ==============
 
-Description
------------
-
-This ioctl is for DVB devices only. To control a V4L2 decoder use the
-V4L2 :ref:`VIDIOC_DECODER_CMD` instead.
+NAME
+----
 
-This ioctl call restarts decoding and playing processes of the video
-stream which was played before a call to VIDEO_FREEZE was made.
+VIDEO_CONTINUE
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int ioctl(fd, int request = VIDEO_CONTINUE)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -42,11 +38,19 @@ Arguments
        -  Equals VIDEO_CONTINUE for this command.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl is for DVB devices only. To control a V4L2 decoder use the
+V4L2 :ref:`VIDIOC_DECODER_CMD` instead.
+
+This ioctl call restarts decoding and playing processes of the video
+stream which was played before a call to VIDEO_FREEZE was made.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
diff --git a/Documentation/linux_tv/media/dvb/video-fast-forward.rst b/Documentation/linux_tv/media/dvb/video-fast-forward.rst
index 3cf7d2d9d817..586a23bb5cfd 100644
--- a/Documentation/linux_tv/media/dvb/video-fast-forward.rst
+++ b/Documentation/linux_tv/media/dvb/video-fast-forward.rst
@@ -2,25 +2,23 @@
 
 .. _VIDEO_FAST_FORWARD:
 
+==================
 VIDEO_FAST_FORWARD
 ==================
 
-Description
------------
+NAME
+----
 
-This ioctl call asks the Video Device to skip decoding of N number of
-I-frames. This call can only be used if VIDEO_SOURCE_MEMORY is
-selected.
+VIDEO_FAST_FORWARD
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int ioctl(fd, int request = VIDEO_FAST_FORWARD, int nFrames)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -46,7 +44,15 @@ Arguments
        -  The number of frames to skip.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl call asks the Video Device to skip decoding of N number of
+I-frames. This call can only be used if VIDEO_SOURCE_MEMORY is
+selected.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
@@ -65,6 +71,3 @@ appropriately. The generic error codes are described at the
        -  ``EPERM``
 
        -  Mode VIDEO_SOURCE_MEMORY not selected.
-
-
-
diff --git a/Documentation/linux_tv/media/dvb/video-fclose.rst b/Documentation/linux_tv/media/dvb/video-fclose.rst
index c9fc6560cb43..e98673768d2b 100644
--- a/Documentation/linux_tv/media/dvb/video-fclose.rst
+++ b/Documentation/linux_tv/media/dvb/video-fclose.rst
@@ -2,23 +2,23 @@
 
 .. _video_fclose:
 
+=================
 dvb video close()
 =================
 
-Description
------------
+NAME
+----
 
-This system call closes a previously opened video device.
+dvb video close()
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int close(int fd)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -32,11 +32,15 @@ Arguments
        -  File descriptor returned by a previous call to open().
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This system call closes a previously opened video device.
+
+
+RETURN VALUE
 ------------
 
-
-
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
@@ -47,6 +51,3 @@ Return Value
        -  ``EBADF``
 
        -  fd is not a valid open file descriptor.
-
-
-
diff --git a/Documentation/linux_tv/media/dvb/video-fopen.rst b/Documentation/linux_tv/media/dvb/video-fopen.rst
index 9de94d4f69dd..3c30fef2aab6 100644
--- a/Documentation/linux_tv/media/dvb/video-fopen.rst
+++ b/Documentation/linux_tv/media/dvb/video-fopen.rst
@@ -2,10 +2,63 @@
 
 .. _video_fopen:
 
+================
 dvb video open()
 ================
 
-Description
+NAME
+----
+
+dvb video open()
+
+SYNOPSIS
+--------
+
+.. c:function:: int open(const char *deviceName, int flags)
+
+
+ARGUMENTS
+---------
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
+DESCRIPTION
 -----------
 
 This system call opens a named video device (e.g.
@@ -24,57 +77,10 @@ returned. If the Video Device is opened in O_RDONLY mode, the only
 ioctl call that can be used is VIDEO_GET_STATUS. All other call will
 return an error code.
 
-Synopsis
---------
 
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
+RETURN VALUE
 ------------
 
-
-
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
@@ -103,6 +109,3 @@ Return Value
        -  ``EINVAL``
 
        -  Invalid argument.
-
-
-
diff --git a/Documentation/linux_tv/media/dvb/video-freeze.rst b/Documentation/linux_tv/media/dvb/video-freeze.rst
index d384e329b661..8fbc7835382c 100644
--- a/Documentation/linux_tv/media/dvb/video-freeze.rst
+++ b/Documentation/linux_tv/media/dvb/video-freeze.rst
@@ -2,31 +2,23 @@
 
 .. _VIDEO_FREEZE:
 
+============
 VIDEO_FREEZE
 ============
 
-Description
------------
-
-This ioctl is for DVB devices only. To control a V4L2 decoder use the
-V4L2 :ref:`VIDIOC_DECODER_CMD` instead.
+NAME
+----
 
-This ioctl call suspends the live video stream being played. Decoding
-and playing are frozen. It is then possible to restart the decoding and
-playing process of the video stream using the VIDEO_CONTINUE command.
-If VIDEO_SOURCE_MEMORY is selected in the ioctl call
-VIDEO_SELECT_SOURCE, the DVB subsystem will not decode any more data
-until the ioctl call VIDEO_CONTINUE or VIDEO_PLAY is performed.
+VIDEO_FREEZE
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int ioctl(fd, int request = VIDEO_FREEZE)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -46,11 +38,23 @@ Arguments
        -  Equals VIDEO_FREEZE for this command.
 
 
-Return Value
+DESCRIPTION
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
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
diff --git a/Documentation/linux_tv/media/dvb/video-fwrite.rst b/Documentation/linux_tv/media/dvb/video-fwrite.rst
index 398bbeaeaf8b..f56c89caef32 100644
--- a/Documentation/linux_tv/media/dvb/video-fwrite.rst
+++ b/Documentation/linux_tv/media/dvb/video-fwrite.rst
@@ -2,27 +2,23 @@
 
 .. _video_fwrite:
 
+=================
 dvb video write()
 =================
 
-Description
------------
+NAME
+----
 
-This system call can only be used if VIDEO_SOURCE_MEMORY is selected
-in the ioctl call VIDEO_SELECT_SOURCE. The data provided shall be in
-PES format, unless the capability allows other formats. If O_NONBLOCK
-is not specified the function will block until buffer space is
-available. The amount of data to be transferred is implied by count.
+dvb video write()
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: size_t write(int fd, const void *buf, size_t count)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -48,11 +44,19 @@ Arguments
        -  Size of buf.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This system call can only be used if VIDEO_SOURCE_MEMORY is selected
+in the ioctl call VIDEO_SELECT_SOURCE. The data provided shall be in
+PES format, unless the capability allows other formats. If O_NONBLOCK
+is not specified the function will block until buffer space is
+available. The amount of data to be transferred is implied by count.
+
+
+RETURN VALUE
 ------------
 
-
-
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
@@ -75,6 +79,3 @@ Return Value
        -  ``EBADF``
 
        -  fd is not a valid open file descriptor.
-
-
-
diff --git a/Documentation/linux_tv/media/dvb/video-get-capabilities.rst b/Documentation/linux_tv/media/dvb/video-get-capabilities.rst
index 7b5dcc523a69..5666ae7f20c0 100644
--- a/Documentation/linux_tv/media/dvb/video-get-capabilities.rst
+++ b/Documentation/linux_tv/media/dvb/video-get-capabilities.rst
@@ -2,25 +2,23 @@
 
 .. _VIDEO_GET_CAPABILITIES:
 
+======================
 VIDEO_GET_CAPABILITIES
 ======================
 
-Description
------------
+NAME
+----
 
-This ioctl call asks the video device about its decoding capabilities.
-On success it returns and integer which has bits set according to the
-defines in section ??.
+VIDEO_GET_CAPABILITIES
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int ioctl(fd, int request = VIDEO_GET_CAPABILITIES, unsigned int *cap)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -46,11 +44,17 @@ Arguments
        -  Pointer to a location where to store the capability information.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl call asks the video device about its decoding capabilities.
+On success it returns and integer which has bits set according to the
+defines in section ??.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
diff --git a/Documentation/linux_tv/media/dvb/video-get-event.rst b/Documentation/linux_tv/media/dvb/video-get-event.rst
index b958652cac7b..3240cd6da6f6 100644
--- a/Documentation/linux_tv/media/dvb/video-get-event.rst
+++ b/Documentation/linux_tv/media/dvb/video-get-event.rst
@@ -2,10 +2,49 @@
 
 .. _VIDEO_GET_EVENT:
 
+===============
 VIDEO_GET_EVENT
 ===============
 
-Description
+NAME
+----
+
+VIDEO_GET_EVENT
+
+SYNOPSIS
+--------
+
+.. c:function:: int ioctl(fd, int request = VIDEO_GET_EVENT, struct video_event *ev)
+
+
+ARGUMENTS
+---------
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
+DESCRIPTION
 -----------
 
 This ioctl is for DVB devices only. To get events from a V4L2 decoder
@@ -22,41 +61,8 @@ included in the exceptfds argument, and for poll(), POLLPRI should be
 specified as the wake-up condition. Read-only permissions are sufficient
 for this ioctl call.
 
-Synopsis
---------
 
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
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
@@ -81,6 +87,3 @@ appropriately. The generic error codes are described at the
        -  ``EOVERFLOW``
 
        -  Overflow in event queue - one or more events were lost.
-
-
-
diff --git a/Documentation/linux_tv/media/dvb/video-get-frame-count.rst b/Documentation/linux_tv/media/dvb/video-get-frame-count.rst
index c7c140f2467a..97ec05810154 100644
--- a/Documentation/linux_tv/media/dvb/video-get-frame-count.rst
+++ b/Documentation/linux_tv/media/dvb/video-get-frame-count.rst
@@ -2,28 +2,23 @@
 
 .. _VIDEO_GET_FRAME_COUNT:
 
+=====================
 VIDEO_GET_FRAME_COUNT
 =====================
 
-Description
------------
-
-This ioctl is obsolete. Do not use in new drivers. For V4L2 decoders
-this ioctl has been replaced by the ``V4L2_CID_MPEG_VIDEO_DEC_FRAME``
-control.
+NAME
+----
 
-This ioctl call asks the Video Device to return the number of displayed
-frames since the decoder was started.
+VIDEO_GET_FRAME_COUNT
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int ioctl(int fd, int request = VIDEO_GET_FRAME_COUNT, __u64 *pts)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -50,11 +45,20 @@ Arguments
 	  started.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl is obsolete. Do not use in new drivers. For V4L2 decoders
+this ioctl has been replaced by the ``V4L2_CID_MPEG_VIDEO_DEC_FRAME``
+control.
+
+This ioctl call asks the Video Device to return the number of displayed
+frames since the decoder was started.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
diff --git a/Documentation/linux_tv/media/dvb/video-get-frame-rate.rst b/Documentation/linux_tv/media/dvb/video-get-frame-rate.rst
index bfd09385cb31..62a85be537ab 100644
--- a/Documentation/linux_tv/media/dvb/video-get-frame-rate.rst
+++ b/Documentation/linux_tv/media/dvb/video-get-frame-rate.rst
@@ -2,23 +2,23 @@
 
 .. _VIDEO_GET_FRAME_RATE:
 
+====================
 VIDEO_GET_FRAME_RATE
 ====================
 
-Description
------------
+NAME
+----
 
-This ioctl call asks the Video Device to return the current framerate.
+VIDEO_GET_FRAME_RATE
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int ioctl(int fd, int request = VIDEO_GET_FRAME_RATE, unsigned int *rate)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -44,11 +44,15 @@ Arguments
        -  Returns the framerate in number of frames per 1000 seconds.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl call asks the Video Device to return the current framerate.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
diff --git a/Documentation/linux_tv/media/dvb/video-get-navi.rst b/Documentation/linux_tv/media/dvb/video-get-navi.rst
index 62451fc03924..95dea513bc48 100644
--- a/Documentation/linux_tv/media/dvb/video-get-navi.rst
+++ b/Documentation/linux_tv/media/dvb/video-get-navi.rst
@@ -2,25 +2,23 @@
 
 .. _VIDEO_GET_NAVI:
 
+==============
 VIDEO_GET_NAVI
 ==============
 
-Description
------------
+NAME
+----
 
-This ioctl returns navigational information from the DVD stream. This is
-especially needed if an encoded stream has to be decoded by the
-hardware.
+VIDEO_GET_NAVI
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int ioctl(fd, int request = VIDEO_GET_NAVI , video_navi_pack_t *navipack)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -46,7 +44,15 @@ Arguments
        -  PCI or DSI pack (private stream 2) according to section ??.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl returns navigational information from the DVD stream. This is
+especially needed if an encoded stream has to be decoded by the
+hardware.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
@@ -65,6 +71,3 @@ appropriately. The generic error codes are described at the
        -  ``EFAULT``
 
        -  driver is not able to return navigational information
-
-
-
diff --git a/Documentation/linux_tv/media/dvb/video-get-pts.rst b/Documentation/linux_tv/media/dvb/video-get-pts.rst
index 67b929753963..f56e02a1f447 100644
--- a/Documentation/linux_tv/media/dvb/video-get-pts.rst
+++ b/Documentation/linux_tv/media/dvb/video-get-pts.rst
@@ -2,28 +2,23 @@
 
 .. _VIDEO_GET_PTS:
 
+=============
 VIDEO_GET_PTS
 =============
 
-Description
------------
-
-This ioctl is obsolete. Do not use in new drivers. For V4L2 decoders
-this ioctl has been replaced by the ``V4L2_CID_MPEG_VIDEO_DEC_PTS``
-control.
+NAME
+----
 
-This ioctl call asks the Video Device to return the current PTS
-timestamp.
+VIDEO_GET_PTS
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int ioctl(int fd, int request = VIDEO_GET_PTS, __u64 *pts)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -54,11 +49,20 @@ Arguments
 	  decoded frame or the last PTS extracted by the PES parser.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl is obsolete. Do not use in new drivers. For V4L2 decoders
+this ioctl has been replaced by the ``V4L2_CID_MPEG_VIDEO_DEC_PTS``
+control.
+
+This ioctl call asks the Video Device to return the current PTS
+timestamp.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
diff --git a/Documentation/linux_tv/media/dvb/video-get-size.rst b/Documentation/linux_tv/media/dvb/video-get-size.rst
index 0e16d91838ac..cbdf976223e5 100644
--- a/Documentation/linux_tv/media/dvb/video-get-size.rst
+++ b/Documentation/linux_tv/media/dvb/video-get-size.rst
@@ -2,23 +2,23 @@
 
 .. _VIDEO_GET_SIZE:
 
+==============
 VIDEO_GET_SIZE
 ==============
 
-Description
------------
+NAME
+----
 
-This ioctl returns the size and aspect ratio.
+VIDEO_GET_SIZE
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int ioctl(int fd, int request = VIDEO_GET_SIZE, video_size_t *size)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -44,11 +44,15 @@ Arguments
        -  Returns the size and aspect ratio.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl returns the size and aspect ratio.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
diff --git a/Documentation/linux_tv/media/dvb/video-get-status.rst b/Documentation/linux_tv/media/dvb/video-get-status.rst
index fd9e591de5df..25344bf0ea7b 100644
--- a/Documentation/linux_tv/media/dvb/video-get-status.rst
+++ b/Documentation/linux_tv/media/dvb/video-get-status.rst
@@ -2,24 +2,23 @@
 
 .. _VIDEO_GET_STATUS:
 
+================
 VIDEO_GET_STATUS
 ================
 
-Description
------------
+NAME
+----
 
-This ioctl call asks the Video Device to return the current status of
-the device.
+VIDEO_GET_STATUS
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int ioctl(fd, int request = VIDEO_GET_STATUS, struct video_status *status)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -45,11 +44,16 @@ Arguments
        -  Returns the current status of the Video Device.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl call asks the Video Device to return the current status of
+the device.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
diff --git a/Documentation/linux_tv/media/dvb/video-play.rst b/Documentation/linux_tv/media/dvb/video-play.rst
index da328ed2b4a0..18252d9d2ce6 100644
--- a/Documentation/linux_tv/media/dvb/video-play.rst
+++ b/Documentation/linux_tv/media/dvb/video-play.rst
@@ -2,27 +2,23 @@
 
 .. _VIDEO_PLAY:
 
+==========
 VIDEO_PLAY
 ==========
 
-Description
------------
-
-This ioctl is for DVB devices only. To control a V4L2 decoder use the
-V4L2 :ref:`VIDIOC_DECODER_CMD` instead.
+NAME
+----
 
-This ioctl call asks the Video Device to start playing a video stream
-from the selected source.
+VIDEO_PLAY
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int ioctl(fd, int request = VIDEO_PLAY)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -42,11 +38,19 @@ Arguments
        -  Equals VIDEO_PLAY for this command.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl is for DVB devices only. To control a V4L2 decoder use the
+V4L2 :ref:`VIDIOC_DECODER_CMD` instead.
+
+This ioctl call asks the Video Device to start playing a video stream
+from the selected source.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
diff --git a/Documentation/linux_tv/media/dvb/video-select-source.rst b/Documentation/linux_tv/media/dvb/video-select-source.rst
index 41fc728508c0..2e76af3d468b 100644
--- a/Documentation/linux_tv/media/dvb/video-select-source.rst
+++ b/Documentation/linux_tv/media/dvb/video-select-source.rst
@@ -2,29 +2,23 @@
 
 .. _VIDEO_SELECT_SOURCE:
 
+===================
 VIDEO_SELECT_SOURCE
 ===================
 
-Description
------------
-
-This ioctl is for DVB devices only. This ioctl was also supported by the
-V4L2 ivtv driver, but that has been replaced by the ivtv-specific
-``IVTV_IOC_PASSTHROUGH_MODE`` ioctl.
+NAME
+----
 
-This ioctl call informs the video device which source shall be used for
-the input data. The possible sources are demux or memory. If memory is
-selected, the data is fed to the video device through the write command.
+VIDEO_SELECT_SOURCE
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int ioctl(fd, int request = VIDEO_SELECT_SOURCE, video_stream_source_t source)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -50,11 +44,21 @@ Arguments
        -  Indicates which source shall be used for the Video stream.
 
 
-Return Value
+DESCRIPTION
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
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
diff --git a/Documentation/linux_tv/media/dvb/video-set-attributes.rst b/Documentation/linux_tv/media/dvb/video-set-attributes.rst
index 255efe0872d1..6de9378ce1c7 100644
--- a/Documentation/linux_tv/media/dvb/video-set-attributes.rst
+++ b/Documentation/linux_tv/media/dvb/video-set-attributes.rst
@@ -2,26 +2,23 @@
 
 .. _VIDEO_SET_ATTRIBUTES:
 
+====================
 VIDEO_SET_ATTRIBUTES
 ====================
 
-Description
------------
+NAME
+----
 
-This ioctl is intended for DVD playback and allows you to set certain
-information about the stream. Some hardware may not need this
-information, but the call also tells the hardware to prepare for DVD
-playback.
+VIDEO_SET_ATTRIBUTES
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int ioctl(fd, int request = VIDEO_SET_ATTRIBUTE ,video_attributes_t vattr)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -47,7 +44,16 @@ Arguments
        -  video attributes according to section ??.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl is intended for DVD playback and allows you to set certain
+information about the stream. Some hardware may not need this
+information, but the call also tells the hardware to prepare for DVD
+playback.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/dvb/video-set-blank.rst b/Documentation/linux_tv/media/dvb/video-set-blank.rst
index 0ed2afdf4b72..62b46b8b2d02 100644
--- a/Documentation/linux_tv/media/dvb/video-set-blank.rst
+++ b/Documentation/linux_tv/media/dvb/video-set-blank.rst
@@ -2,23 +2,23 @@
 
 .. _VIDEO_SET_BLANK:
 
+===============
 VIDEO_SET_BLANK
 ===============
 
-Description
------------
+NAME
+----
 
-This ioctl call asks the Video Device to blank out the picture.
+VIDEO_SET_BLANK
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int ioctl(fd, int request = VIDEO_SET_BLANK, boolean mode)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -49,11 +49,15 @@ Arguments
        -  FALSE: Show last decoded frame.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl call asks the Video Device to blank out the picture.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
diff --git a/Documentation/linux_tv/media/dvb/video-set-display-format.rst b/Documentation/linux_tv/media/dvb/video-set-display-format.rst
index af55cefbd3c0..7aec080638de 100644
--- a/Documentation/linux_tv/media/dvb/video-set-display-format.rst
+++ b/Documentation/linux_tv/media/dvb/video-set-display-format.rst
@@ -2,24 +2,23 @@
 
 .. _VIDEO_SET_DISPLAY_FORMAT:
 
+========================
 VIDEO_SET_DISPLAY_FORMAT
 ========================
 
-Description
------------
+NAME
+----
 
-This ioctl call asks the Video Device to select the video format to be
-applied by the MPEG chip on the video.
+VIDEO_SET_DISPLAY_FORMAT
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int ioctl(fd, int request = VIDEO_SET_DISPLAY_FORMAT, video_display_format_t format)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -45,11 +44,16 @@ Arguments
        -  Selects the video format to be used.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl call asks the Video Device to select the video format to be
+applied by the MPEG chip on the video.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
diff --git a/Documentation/linux_tv/media/dvb/video-set-format.rst b/Documentation/linux_tv/media/dvb/video-set-format.rst
index aea4d913c760..af126d2de8c3 100644
--- a/Documentation/linux_tv/media/dvb/video-set-format.rst
+++ b/Documentation/linux_tv/media/dvb/video-set-format.rst
@@ -2,25 +2,23 @@
 
 .. _VIDEO_SET_FORMAT:
 
+================
 VIDEO_SET_FORMAT
 ================
 
-Description
------------
+NAME
+----
 
-This ioctl sets the screen format (aspect ratio) of the connected output
-device (TV) so that the output of the decoder can be adjusted
-accordingly.
+VIDEO_SET_FORMAT
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int ioctl(fd, int request = VIDEO_SET_FORMAT, video_format_t format)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -46,7 +44,15 @@ Arguments
        -  video format of TV as defined in section ??.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl sets the screen format (aspect ratio) of the connected output
+device (TV) so that the output of the decoder can be adjusted
+accordingly.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
@@ -65,6 +71,3 @@ appropriately. The generic error codes are described at the
        -  ``EINVAL``
 
        -  format is not a valid video format.
-
-
-
diff --git a/Documentation/linux_tv/media/dvb/video-set-highlight.rst b/Documentation/linux_tv/media/dvb/video-set-highlight.rst
index e92b7ac28f23..d8628d282740 100644
--- a/Documentation/linux_tv/media/dvb/video-set-highlight.rst
+++ b/Documentation/linux_tv/media/dvb/video-set-highlight.rst
@@ -2,24 +2,23 @@
 
 .. _VIDEO_SET_HIGHLIGHT:
 
+===================
 VIDEO_SET_HIGHLIGHT
 ===================
 
-Description
------------
+NAME
+----
 
-This ioctl sets the SPU highlight information for the menu access of a
-DVD.
+VIDEO_SET_HIGHLIGHT
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int ioctl(fd, int request = VIDEO_SET_HIGHLIGHT ,video_highlight_t *vhilite)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -45,11 +44,16 @@ Arguments
        -  SPU Highlight information according to section ??.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl sets the SPU highlight information for the menu access of a
+DVD.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
diff --git a/Documentation/linux_tv/media/dvb/video-set-id.rst b/Documentation/linux_tv/media/dvb/video-set-id.rst
index 5a58405fba42..31ca41f8b6af 100644
--- a/Documentation/linux_tv/media/dvb/video-set-id.rst
+++ b/Documentation/linux_tv/media/dvb/video-set-id.rst
@@ -2,24 +2,23 @@
 
 .. _VIDEO_SET_ID:
 
+============
 VIDEO_SET_ID
 ============
 
-Description
------------
+NAME
+----
 
-This ioctl selects which sub-stream is to be decoded if a program or
-system stream is sent to the video device.
+VIDEO_SET_ID
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int ioctl(int fd, int request = VIDEO_SET_ID, int id)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -45,7 +44,14 @@ Arguments
        -  video sub-stream id
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl selects which sub-stream is to be decoded if a program or
+system stream is sent to the video device.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
@@ -64,6 +70,3 @@ appropriately. The generic error codes are described at the
        -  ``EINVAL``
 
        -  Invalid sub-stream id.
-
-
-
diff --git a/Documentation/linux_tv/media/dvb/video-set-spu-palette.rst b/Documentation/linux_tv/media/dvb/video-set-spu-palette.rst
index 3fb338ee7420..b3b727fec64b 100644
--- a/Documentation/linux_tv/media/dvb/video-set-spu-palette.rst
+++ b/Documentation/linux_tv/media/dvb/video-set-spu-palette.rst
@@ -2,23 +2,23 @@
 
 .. _VIDEO_SET_SPU_PALETTE:
 
+=====================
 VIDEO_SET_SPU_PALETTE
 =====================
 
-Description
------------
+NAME
+----
 
-This ioctl sets the SPU color palette.
+VIDEO_SET_SPU_PALETTE
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int ioctl(fd, int request = VIDEO_SET_SPU_PALETTE, video_spu_palette_t *palette )
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -44,7 +44,13 @@ Arguments
        -  SPU palette according to section ??.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl sets the SPU color palette.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
@@ -63,6 +69,3 @@ appropriately. The generic error codes are described at the
        -  ``EINVAL``
 
        -  input is not a valid palette or driver doesn’t handle SPU.
-
-
-
diff --git a/Documentation/linux_tv/media/dvb/video-set-spu.rst b/Documentation/linux_tv/media/dvb/video-set-spu.rst
index 863c6248fab9..d00d0b5272d7 100644
--- a/Documentation/linux_tv/media/dvb/video-set-spu.rst
+++ b/Documentation/linux_tv/media/dvb/video-set-spu.rst
@@ -2,24 +2,23 @@
 
 .. _VIDEO_SET_SPU:
 
+=============
 VIDEO_SET_SPU
 =============
 
-Description
------------
+NAME
+----
 
-This ioctl activates or deactivates SPU decoding in a DVD input stream.
-It can only be used, if the driver is able to handle a DVD stream.
+VIDEO_SET_SPU
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int ioctl(fd, int request = VIDEO_SET_SPU , video_spu_t *spu)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -46,7 +45,14 @@ Arguments
 	  ??.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl activates or deactivates SPU decoding in a DVD input stream.
+It can only be used, if the driver is able to handle a DVD stream.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
@@ -65,6 +71,3 @@ appropriately. The generic error codes are described at the
        -  ``EINVAL``
 
        -  input is not a valid spu setting or driver cannot handle SPU.
-
-
-
diff --git a/Documentation/linux_tv/media/dvb/video-set-streamtype.rst b/Documentation/linux_tv/media/dvb/video-set-streamtype.rst
index c412051cc073..6875ff8db77e 100644
--- a/Documentation/linux_tv/media/dvb/video-set-streamtype.rst
+++ b/Documentation/linux_tv/media/dvb/video-set-streamtype.rst
@@ -2,25 +2,23 @@
 
 .. _VIDEO_SET_STREAMTYPE:
 
+====================
 VIDEO_SET_STREAMTYPE
 ====================
 
-Description
------------
+NAME
+----
 
-This ioctl tells the driver which kind of stream to expect being written
-to it. If this call is not used the default of video PES is used. Some
-drivers might not support this call and always expect PES.
+VIDEO_SET_STREAMTYPE
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int ioctl(fd, int request = VIDEO_SET_STREAMTYPE, int type)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -46,11 +44,17 @@ Arguments
        -  stream type
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl tells the driver which kind of stream to expect being written
+to it. If this call is not used the default of video PES is used. Some
+drivers might not support this call and always expect PES.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
diff --git a/Documentation/linux_tv/media/dvb/video-set-system.rst b/Documentation/linux_tv/media/dvb/video-set-system.rst
index 70bff8a1c53a..7fcd1a1fb78b 100644
--- a/Documentation/linux_tv/media/dvb/video-set-system.rst
+++ b/Documentation/linux_tv/media/dvb/video-set-system.rst
@@ -2,26 +2,23 @@
 
 .. _VIDEO_SET_SYSTEM:
 
+================
 VIDEO_SET_SYSTEM
 ================
 
-Description
------------
+NAME
+----
 
-This ioctl sets the television output format. The format (see section
-??) may vary from the color format of the displayed MPEG stream. If the
-hardware is not able to display the requested format the call will
-return an error.
+VIDEO_SET_SYSTEM
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int ioctl(fd, int request = VIDEO_SET_SYSTEM , video_system_t system)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -47,7 +44,16 @@ Arguments
        -  video system of TV output.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl sets the television output format. The format (see section
+??) may vary from the color format of the displayed MPEG stream. If the
+hardware is not able to display the requested format the call will
+return an error.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
@@ -66,6 +72,3 @@ appropriately. The generic error codes are described at the
        -  ``EINVAL``
 
        -  system is not a valid or supported video system.
-
-
-
diff --git a/Documentation/linux_tv/media/dvb/video-slowmotion.rst b/Documentation/linux_tv/media/dvb/video-slowmotion.rst
index e04ad5776683..6472abb1e42d 100644
--- a/Documentation/linux_tv/media/dvb/video-slowmotion.rst
+++ b/Documentation/linux_tv/media/dvb/video-slowmotion.rst
@@ -2,25 +2,23 @@
 
 .. _VIDEO_SLOWMOTION:
 
+================
 VIDEO_SLOWMOTION
 ================
 
-Description
------------
+NAME
+----
 
-This ioctl call asks the video device to repeat decoding frames N number
-of times. This call can only be used if VIDEO_SOURCE_MEMORY is
-selected.
+VIDEO_SLOWMOTION
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int ioctl(fd, int request = VIDEO_SLOWMOTION, int nFrames)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -46,7 +44,15 @@ Arguments
        -  The number of times to repeat each frame.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl call asks the video device to repeat decoding frames N number
+of times. This call can only be used if VIDEO_SOURCE_MEMORY is
+selected.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
@@ -65,6 +71,3 @@ appropriately. The generic error codes are described at the
        -  ``EPERM``
 
        -  Mode VIDEO_SOURCE_MEMORY not selected.
-
-
-
diff --git a/Documentation/linux_tv/media/dvb/video-stillpicture.rst b/Documentation/linux_tv/media/dvb/video-stillpicture.rst
index 94ae66c1d97b..93c9c30bcdd3 100644
--- a/Documentation/linux_tv/media/dvb/video-stillpicture.rst
+++ b/Documentation/linux_tv/media/dvb/video-stillpicture.rst
@@ -2,25 +2,23 @@
 
 .. _VIDEO_STILLPICTURE:
 
+==================
 VIDEO_STILLPICTURE
 ==================
 
-Description
------------
+NAME
+----
 
-This ioctl call asks the Video Device to display a still picture
-(I-frame). The input data shall contain an I-frame. If the pointer is
-NULL, then the current displayed still picture is blanked.
+VIDEO_STILLPICTURE
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int ioctl(fd, int request = VIDEO_STILLPICTURE, struct video_still_picture *sp)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -46,11 +44,17 @@ Arguments
        -  Pointer to a location where an I-frame and size is stored.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl call asks the Video Device to display a still picture
+(I-frame). The input data shall contain an I-frame. If the pointer is
+NULL, then the current displayed still picture is blanked.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
diff --git a/Documentation/linux_tv/media/dvb/video-stop.rst b/Documentation/linux_tv/media/dvb/video-stop.rst
index fd5288727911..2dbf464d85bb 100644
--- a/Documentation/linux_tv/media/dvb/video-stop.rst
+++ b/Documentation/linux_tv/media/dvb/video-stop.rst
@@ -2,28 +2,23 @@
 
 .. _VIDEO_STOP:
 
+==========
 VIDEO_STOP
 ==========
 
-Description
------------
-
-This ioctl is for DVB devices only. To control a V4L2 decoder use the
-V4L2 :ref:`VIDIOC_DECODER_CMD` instead.
+NAME
+----
 
-This ioctl call asks the Video Device to stop playing the current
-stream. Depending on the input parameter, the screen can be blanked out
-or displaying the last decoded frame.
+VIDEO_STOP
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int ioctl(fd, int request = VIDEO_STOP, boolean mode)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -59,11 +54,20 @@ Arguments
        -  FALSE: Show last decoded frame.
 
 
-Return Value
+DESCRIPTION
+-----------
+
+This ioctl is for DVB devices only. To control a V4L2 decoder use the
+V4L2 :ref:`VIDIOC_DECODER_CMD` instead.
+
+This ioctl call asks the Video Device to stop playing the current
+stream. Depending on the input parameter, the screen can be blanked out
+or displaying the last decoded frame.
+
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
diff --git a/Documentation/linux_tv/media/dvb/video-try-command.rst b/Documentation/linux_tv/media/dvb/video-try-command.rst
index 57eff3daf7bd..b30cfcd05682 100644
--- a/Documentation/linux_tv/media/dvb/video-try-command.rst
+++ b/Documentation/linux_tv/media/dvb/video-try-command.rst
@@ -2,30 +2,23 @@
 
 .. _VIDEO_TRY_COMMAND:
 
+=================
 VIDEO_TRY_COMMAND
 =================
 
-Description
------------
-
-This ioctl is obsolete. Do not use in new drivers. For V4L2 decoders
-this ioctl has been replaced by the
-:ref:`VIDIOC_TRY_DECODER_CMD <VIDIOC_DECODER_CMD>` ioctl.
+NAME
+----
 
-This ioctl tries a decoder command. The ``video_command`` struct is a
-subset of the ``v4l2_decoder_cmd`` struct, so refer to the
-:ref:`VIDIOC_TRY_DECODER_CMD <VIDIOC_DECODER_CMD>` documentation
-for more information.
+VIDEO_TRY_COMMAND
 
-Synopsis
+SYNOPSIS
 --------
 
 .. c:function:: int ioctl(int fd, int request = VIDEO_TRY_COMMAND, struct video_command *cmd)
 
-Arguments
-----------
-
 
+ARGUMENTS
+---------
 
 .. flat-table::
     :header-rows:  0
@@ -51,11 +44,22 @@ Arguments
        -  Try a decoder command.
 
 
-Return Value
+DESCRIPTION
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
+
+RETURN VALUE
 ------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
-
-
diff --git a/Documentation/linux_tv/media/mediactl/media-func-close.rst b/Documentation/linux_tv/media/mediactl/media-func-close.rst
index 109b831e4047..7ec0baa83482 100644
--- a/Documentation/linux_tv/media/mediactl/media-func-close.rst
+++ b/Documentation/linux_tv/media/mediactl/media-func-close.rst
@@ -6,12 +6,12 @@
 media close()
 *************
 
-*man media-close(2)*
+NAME
+====
 
-Close a media device
+media-close - Close a media device
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. code-block:: c
@@ -21,21 +21,22 @@ Synopsis
 
 .. cpp:function:: int close( int fd )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
 
-Description
+DESCRIPTION
 ===========
 
 Closes the media device. Resources associated with the file descriptor
 are freed. The device configuration remain unchanged.
 
 
-Return Value
+RETURN VALUE
 ============
 
 :ref:`close() <func-close>` returns 0 on success. On error, -1 is returned, and
diff --git a/Documentation/linux_tv/media/mediactl/media-func-ioctl.rst b/Documentation/linux_tv/media/mediactl/media-func-ioctl.rst
index c56ccb9c9b39..0d8f706b7e74 100644
--- a/Documentation/linux_tv/media/mediactl/media-func-ioctl.rst
+++ b/Documentation/linux_tv/media/mediactl/media-func-ioctl.rst
@@ -6,12 +6,12 @@
 media ioctl()
 *************
 
-*man media-ioctl(2)*
+NAME
+====
 
-Control a media device
+media-ioctl - Control a media device
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. code-block:: c
@@ -21,7 +21,8 @@ Synopsis
 
 .. cpp:function:: int ioctl( int fd, int request, void *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -35,7 +36,7 @@ Arguments
     Pointer to a request-specific structure.
 
 
-Description
+DESCRIPTION
 ===========
 
 The :ref:`ioctl() <func-ioctl>` function manipulates media device parameters.
@@ -51,7 +52,7 @@ requests, their respective function and parameters are specified in
 :ref:`media-user-func`.
 
 
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/mediactl/media-func-open.rst b/Documentation/linux_tv/media/mediactl/media-func-open.rst
index 627860b33ae2..353114fcb7ca 100644
--- a/Documentation/linux_tv/media/mediactl/media-func-open.rst
+++ b/Documentation/linux_tv/media/mediactl/media-func-open.rst
@@ -6,12 +6,12 @@
 media open()
 ************
 
-*man media-open(2)*
+NAME
+====
 
-Open a media device
+media-open - Open a media device
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. code-block:: c
@@ -21,7 +21,8 @@ Synopsis
 
 .. cpp:function:: int open( const char *device_name, int flags )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``device_name``
@@ -32,7 +33,7 @@ Arguments
     Other flags have no effect.
 
 
-Description
+DESCRIPTION
 ===========
 
 To open a media device applications call :ref:`open() <func-open>` with the
@@ -44,7 +45,7 @@ configuration will result in an error, and ``errno`` will be set to
 EBADF.
 
 
-Return Value
+RETURN VALUE
 ============
 
 :ref:`open() <func-open>` returns the new file descriptor on success. On error,
diff --git a/Documentation/linux_tv/media/mediactl/media-ioc-device-info.rst b/Documentation/linux_tv/media/mediactl/media-ioc-device-info.rst
index 8339e193ba8b..52fe981a4036 100644
--- a/Documentation/linux_tv/media/mediactl/media-ioc-device-info.rst
+++ b/Documentation/linux_tv/media/mediactl/media-ioc-device-info.rst
@@ -6,17 +6,18 @@
 ioctl MEDIA_IOC_DEVICE_INFO
 ***************************
 
-*man MEDIA_IOC_DEVICE_INFO(2)*
+NAME
+====
 
-Query device information
+MEDIA_IOC_DEVICE_INFO - Query device information
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct media_device_info *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -28,7 +29,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 All media devices must support the ``MEDIA_IOC_DEVICE_INFO`` ioctl. To
@@ -132,7 +133,7 @@ used instead. The ``bus_info`` field is guaranteed to be unique, but can
 vary across reboots or device unplug/replug.
 
 
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/mediactl/media-ioc-enum-entities.rst b/Documentation/linux_tv/media/mediactl/media-ioc-enum-entities.rst
index 6e0a0c27ba2f..5d11572d4848 100644
--- a/Documentation/linux_tv/media/mediactl/media-ioc-enum-entities.rst
+++ b/Documentation/linux_tv/media/mediactl/media-ioc-enum-entities.rst
@@ -6,17 +6,18 @@
 ioctl MEDIA_IOC_ENUM_ENTITIES
 *****************************
 
-*man MEDIA_IOC_ENUM_ENTITIES(2)*
+NAME
+====
 
-Enumerate entities and their properties
+MEDIA_IOC_ENUM_ENTITIES - Enumerate entities and their properties
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct media_entity_desc *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -28,7 +29,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 To query the attributes of an entity, applications set the id field of a
@@ -182,8 +183,7 @@ id's until they get an error.
        -
 
 
-
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/mediactl/media-ioc-enum-links.rst b/Documentation/linux_tv/media/mediactl/media-ioc-enum-links.rst
index 30dd7e2a7051..88bf10b35ff0 100644
--- a/Documentation/linux_tv/media/mediactl/media-ioc-enum-links.rst
+++ b/Documentation/linux_tv/media/mediactl/media-ioc-enum-links.rst
@@ -6,17 +6,18 @@
 ioctl MEDIA_IOC_ENUM_LINKS
 **************************
 
-*man MEDIA_IOC_ENUM_LINKS(2)*
+NAME
+====
 
-Enumerate all pads and links for a given entity
+MEDIA_IOC_ENUM_LINKS - Enumerate all pads and links for a given entity
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct media_links_enum *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -28,7 +29,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 To enumerate pads and/or links for a given entity, applications set the
@@ -158,8 +159,7 @@ returned during the enumeration process.
        -  Link flags, see :ref:`media-link-flag` for more details.
 
 
-
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/mediactl/media-ioc-g-topology.rst b/Documentation/linux_tv/media/mediactl/media-ioc-g-topology.rst
index 1c360bf7c9b0..34d46010c971 100644
--- a/Documentation/linux_tv/media/mediactl/media-ioc-g-topology.rst
+++ b/Documentation/linux_tv/media/mediactl/media-ioc-g-topology.rst
@@ -6,17 +6,18 @@
 ioctl MEDIA_IOC_G_TOPOLOGY
 **************************
 
-*man MEDIA_IOC_G_TOPOLOGY(2)*
+NAME
+====
 
-Enumerate the graph topology and graph element properties
+MEDIA_IOC_G_TOPOLOGY - Enumerate the graph topology and graph element properties
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct media_v2_topology *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -28,7 +29,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 The typical usage of this ioctl is to call it twice. On the first call,
@@ -409,8 +410,7 @@ desired arrays with the media graph elements.
 	  this array to zero.
 
 
-
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/mediactl/media-ioc-setup-link.rst b/Documentation/linux_tv/media/mediactl/media-ioc-setup-link.rst
index 135fa782dcd2..f02edbcd3048 100644
--- a/Documentation/linux_tv/media/mediactl/media-ioc-setup-link.rst
+++ b/Documentation/linux_tv/media/mediactl/media-ioc-setup-link.rst
@@ -6,17 +6,18 @@
 ioctl MEDIA_IOC_SETUP_LINK
 **************************
 
-*man MEDIA_IOC_SETUP_LINK(2)*
+NAME
+====
 
-Modify the properties of a link
+MEDIA_IOC_SETUP_LINK - Modify the properties of a link
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct media_link_desc *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -28,7 +29,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 To change link properties applications fill a struct
@@ -53,7 +54,7 @@ If the specified link can't be found the driver returns with an ``EINVAL``
 error code.
 
 
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/func-close.rst b/Documentation/linux_tv/media/v4l/func-close.rst
index fac5ec14a8e6..81401cd26d12 100644
--- a/Documentation/linux_tv/media/v4l/func-close.rst
+++ b/Documentation/linux_tv/media/v4l/func-close.rst
@@ -6,12 +6,12 @@
 V4L2 close()
 ************
 
-*man v4l2-close(2)*
+NAME
+====
 
-Close a V4L2 device
+v4l2-close - Close a V4L2 device
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. code-block:: c
@@ -21,14 +21,15 @@ Synopsis
 
 .. cpp:function:: int close( int fd )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
 
 
-Description
+DESCRIPTION
 ===========
 
 Closes the device. Any I/O in progress is terminated and resources
@@ -37,7 +38,7 @@ parameters, current input or output, control values or other properties
 remain unchanged.
 
 
-Return Value
+RETURN VALUE
 ============
 
 The function returns 0 on success, -1 on failure and the ``errno`` is
diff --git a/Documentation/linux_tv/media/v4l/func-ioctl.rst b/Documentation/linux_tv/media/v4l/func-ioctl.rst
index fafec5f56a36..91917e976dd0 100644
--- a/Documentation/linux_tv/media/v4l/func-ioctl.rst
+++ b/Documentation/linux_tv/media/v4l/func-ioctl.rst
@@ -6,12 +6,12 @@
 V4L2 ioctl()
 ************
 
-*man v4l2-ioctl(2)*
+NAME
+====
 
-Program a V4L2 device
+v4l2-ioctl - Program a V4L2 device
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. code-block:: c
@@ -21,7 +21,8 @@ Synopsis
 
 .. cpp:function:: int ioctl( int fd, int request, void *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -35,7 +36,7 @@ Arguments
     Pointer to a function parameter, usually a structure.
 
 
-Description
+DESCRIPTION
 ===========
 
 The :ref:`ioctl() <func-ioctl>` function is used to program V4L2 devices. The
@@ -49,7 +50,7 @@ All V4L2 ioctl requests, their respective function and parameters are
 specified in :ref:`user-func`.
 
 
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/func-mmap.rst b/Documentation/linux_tv/media/v4l/func-mmap.rst
index 345ac3005c8f..01a45e217265 100644
--- a/Documentation/linux_tv/media/v4l/func-mmap.rst
+++ b/Documentation/linux_tv/media/v4l/func-mmap.rst
@@ -6,12 +6,12 @@
 V4L2 mmap()
 ***********
 
-*man v4l2-mmap(2)*
+NAME
+====
 
-Map device memory into application address space
+v4l2-mmap - Map device memory into application address space
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. code-block:: c
@@ -22,7 +22,8 @@ Synopsis
 
 .. cpp:function:: void *mmap( void *start, size_t length, int prot, int flags, int fd, off_t offset )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``start``
@@ -89,7 +90,7 @@ Arguments
     ``mem_offset`` field for the multi-planar API.
 
 
-Description
+DESCRIPTION
 ===========
 
 The :ref:`mmap() <func-mmap>` function asks to map ``length`` bytes starting at
@@ -105,7 +106,7 @@ before they can be queried.
 To unmap buffers the :ref:`munmap() <func-munmap>` function is used.
 
 
-Return Value
+RETURN VALUE
 ============
 
 On success :ref:`mmap() <func-mmap>` returns a pointer to the mapped buffer. On
diff --git a/Documentation/linux_tv/media/v4l/func-munmap.rst b/Documentation/linux_tv/media/v4l/func-munmap.rst
index f87eb387f499..a6e7a6def558 100644
--- a/Documentation/linux_tv/media/v4l/func-munmap.rst
+++ b/Documentation/linux_tv/media/v4l/func-munmap.rst
@@ -6,12 +6,12 @@
 V4L2 munmap()
 *************
 
-*man v4l2-munmap(2)*
+NAME
+====
 
-Unmap device memory
+v4l2-munmap - Unmap device memory
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. code-block:: c
@@ -22,7 +22,8 @@ Synopsis
 
 .. cpp:function:: int munmap( void *start, size_t length )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``start``
@@ -38,14 +39,14 @@ Arguments
     multi-planar API.
 
 
-Description
+DESCRIPTION
 ===========
 
 Unmaps a previously with the :ref:`mmap() <func-mmap>` function mapped
 buffer and frees it, if possible.
 
 
-Return Value
+RETURN VALUE
 ============
 
 On success :ref:`munmap() <func-munmap>` returns 0, on failure -1 and the
diff --git a/Documentation/linux_tv/media/v4l/func-open.rst b/Documentation/linux_tv/media/v4l/func-open.rst
index 705175be80e6..152174e6f646 100644
--- a/Documentation/linux_tv/media/v4l/func-open.rst
+++ b/Documentation/linux_tv/media/v4l/func-open.rst
@@ -6,12 +6,12 @@
 V4L2 open()
 ***********
 
-*man v4l2-open(2)*
+NAME
+====
 
-Open a V4L2 device
+v4l2-open - Open a V4L2 device
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. code-block:: c
@@ -21,7 +21,8 @@ Synopsis
 
 .. cpp:function:: int open( const char *device_name, int flags )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``device_name``
@@ -42,7 +43,7 @@ Arguments
     Other flags have no effect.
 
 
-Description
+DESCRIPTION
 ===========
 
 To open a V4L2 device applications call :ref:`open() <func-open>` with the
@@ -53,7 +54,7 @@ driver they will be reset to default values, drivers are never in an
 undefined state.
 
 
-Return Value
+RETURN VALUE
 ============
 
 On success :ref:`open() <func-open>` returns the new file descriptor. On error
diff --git a/Documentation/linux_tv/media/v4l/func-poll.rst b/Documentation/linux_tv/media/v4l/func-poll.rst
index 27f381d75de1..8632e05ff5b2 100644
--- a/Documentation/linux_tv/media/v4l/func-poll.rst
+++ b/Documentation/linux_tv/media/v4l/func-poll.rst
@@ -6,12 +6,12 @@
 V4L2 poll()
 ***********
 
-*man v4l2-poll(2)*
+NAME
+====
 
-Wait for some event on a file descriptor
+v4l2-poll - Wait for some event on a file descriptor
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. code-block:: c
@@ -21,7 +21,13 @@ Synopsis
 
 .. cpp:function:: int poll( struct pollfd *ufds, unsigned int nfds, int timeout )
 
-Description
+
+ARGUMENTS
+=========
+
+
+
+DESCRIPTION
 ===========
 
 With the :ref:`poll() <func-poll>` function applications can suspend execution
@@ -84,7 +90,7 @@ function.
 For more details see the :ref:`poll() <func-poll>` manual page.
 
 
-Return Value
+RETURN VALUE
 ============
 
 On success, :ref:`poll() <func-poll>` returns the number structures which have
diff --git a/Documentation/linux_tv/media/v4l/func-read.rst b/Documentation/linux_tv/media/v4l/func-read.rst
index 75985f664da7..c4f0e8ab9e14 100644
--- a/Documentation/linux_tv/media/v4l/func-read.rst
+++ b/Documentation/linux_tv/media/v4l/func-read.rst
@@ -6,12 +6,12 @@
 V4L2 read()
 ***********
 
-*man v4l2-read(2)*
+NAME
+====
 
-Read from a V4L2 device
+v4l2-read - Read from a V4L2 device
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. code-block:: c
@@ -21,7 +21,8 @@ Synopsis
 
 .. cpp:function:: ssize_t read( int fd, void *buf, size_t count )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -31,7 +32,7 @@ Arguments
 ``count``
 
 
-Description
+DESCRIPTION
 ===========
 
 :ref:`read() <func-read>` attempts to read up to ``count`` bytes from file
@@ -91,7 +92,7 @@ however. The discarding policy is not reported and cannot be changed.
 For minimum requirements see :ref:`devices`.
 
 
-Return Value
+RETURN VALUE
 ============
 
 On success, the number of bytes read is returned. It is not an error if
diff --git a/Documentation/linux_tv/media/v4l/func-select.rst b/Documentation/linux_tv/media/v4l/func-select.rst
index 57089f5cc6cd..34ade67d0f68 100644
--- a/Documentation/linux_tv/media/v4l/func-select.rst
+++ b/Documentation/linux_tv/media/v4l/func-select.rst
@@ -6,12 +6,12 @@
 V4L2 select()
 *************
 
-*man v4l2-select(2)*
+NAME
+====
 
-Synchronous I/O multiplexing
+v4l2-select - Synchronous I/O multiplexing
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. code-block:: c
@@ -23,7 +23,13 @@ Synopsis
 
 .. cpp:function:: int select( int nfds, fd_set *readfds, fd_set *writefds, fd_set *exceptfds, struct timeval *timeout )
 
-Description
+
+ARGUMENTS
+=========
+
+
+
+DESCRIPTION
 ===========
 
 With the :ref:`select() <func-select>` function applications can suspend
@@ -65,7 +71,7 @@ function.
 For more details see the :ref:`select() <func-select>` manual page.
 
 
-Return Value
+RETURN VALUE
 ============
 
 On success, :ref:`select() <func-select>` returns the number of descriptors
diff --git a/Documentation/linux_tv/media/v4l/func-write.rst b/Documentation/linux_tv/media/v4l/func-write.rst
index a4b093ba15c3..6609f191af76 100644
--- a/Documentation/linux_tv/media/v4l/func-write.rst
+++ b/Documentation/linux_tv/media/v4l/func-write.rst
@@ -6,12 +6,12 @@
 V4L2 write()
 ************
 
-*man v4l2-write(2)*
+NAME
+====
 
-Write to a V4L2 device
+v4l2-write - Write to a V4L2 device
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. code-block:: c
@@ -21,7 +21,8 @@ Synopsis
 
 .. cpp:function:: ssize_t write( int fd, void *buf, size_t count )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -31,7 +32,7 @@ Arguments
 ``count``
 
 
-Description
+DESCRIPTION
 ===========
 
 :ref:`write() <func-write>` writes up to ``count`` bytes to the device
@@ -46,7 +47,7 @@ Sliced Teletext or Closed Caption data is not repeated, the driver
 inserts a blank line instead.
 
 
-Return Value
+RETURN VALUE
 ============
 
 On success, the number of bytes written are returned. Zero indicates
diff --git a/Documentation/linux_tv/media/v4l/vidioc-create-bufs.rst b/Documentation/linux_tv/media/v4l/vidioc-create-bufs.rst
index 5ba95ac0a5ce..fe179197536d 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-create-bufs.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-create-bufs.rst
@@ -6,17 +6,18 @@
 ioctl VIDIOC_CREATE_BUFS
 ************************
 
-*man VIDIOC_CREATE_BUFS(2)*
+NAME
+====
 
-Create buffers for Memory Mapped or User Pointer or DMA Buffer I/O
+VIDIOC_CREATE_BUFS - Create buffers for Memory Mapped or User Pointer or DMA Buffer I/O
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_create_buffers *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -28,7 +29,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 This ioctl is used to create buffers for :ref:`memory mapped <mmap>`
@@ -129,8 +130,7 @@ than the number requested.
 	  must set the array to zero.
 
 
-
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-cropcap.rst b/Documentation/linux_tv/media/v4l/vidioc-cropcap.rst
index 2e2a24f652a3..17ae3aa738b0 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-cropcap.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-cropcap.rst
@@ -6,17 +6,18 @@
 ioctl VIDIOC_CROPCAP
 ********************
 
-*man VIDIOC_CROPCAP(2)*
+NAME
+====
 
-Information about the video cropping and scaling abilities
+VIDIOC_CROPCAP - Information about the video cropping and scaling abilities
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_cropcap *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -28,7 +29,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 Applications use this function to query the cropping limits, the pixel
@@ -153,8 +154,7 @@ overlay devices.
        -  Height of the rectangle, in pixels.
 
 
-
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-dbg-g-chip-info.rst b/Documentation/linux_tv/media/v4l/vidioc-dbg-g-chip-info.rst
index 7cc3bd42ccd4..913c6d47d821 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-dbg-g-chip-info.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-dbg-g-chip-info.rst
@@ -6,17 +6,18 @@
 ioctl VIDIOC_DBG_G_CHIP_INFO
 ****************************
 
-*man VIDIOC_DBG_G_CHIP_INFO(2)*
+NAME
+====
 
-Identify the chips on a TV card
+VIDIOC_DBG_G_CHIP_INFO - Identify the chips on a TV card
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_dbg_chip_info *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -28,7 +29,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
     **Note**
@@ -191,8 +192,7 @@ instructions.
        -  Match the nth sub-device.
 
 
-
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-dbg-g-register.rst b/Documentation/linux_tv/media/v4l/vidioc-dbg-g-register.rst
index f83a83b48cd6..185a011a117c 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-dbg-g-register.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-dbg-g-register.rst
@@ -6,20 +6,20 @@
 ioctl VIDIOC_DBG_G_REGISTER, VIDIOC_DBG_S_REGISTER
 **************************************************
 
-*man VIDIOC_DBG_G_REGISTER(2)*
+NAME
+====
 
-VIDIOC_DBG_S_REGISTER
-Read or write hardware registers
+VIDIOC_DBG_G_REGISTER - VIDIOC_DBG_S_REGISTER - Read or write hardware registers
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_dbg_register *argp )
 
 .. cpp:function:: int ioctl( int fd, int request, const struct v4l2_dbg_register *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -31,7 +31,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
     **Note**
@@ -196,8 +196,7 @@ instructions.
        -  Match the nth sub-device.
 
 
-
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-decoder-cmd.rst b/Documentation/linux_tv/media/v4l/vidioc-decoder-cmd.rst
index c1d82336a60a..bb6d9b8cf122 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-decoder-cmd.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-decoder-cmd.rst
@@ -6,18 +6,18 @@
 ioctl VIDIOC_DECODER_CMD, VIDIOC_TRY_DECODER_CMD
 ************************************************
 
-*man VIDIOC_DECODER_CMD(2)*
+NAME
+====
 
-VIDIOC_TRY_DECODER_CMD
-Execute an decoder command
+VIDIOC_DECODER_CMD - VIDIOC_TRY_DECODER_CMD - Execute an decoder command
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_decoder_cmd *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -29,7 +29,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 These ioctls control an audio/video (usually MPEG-) decoder.
@@ -255,8 +255,7 @@ introduced in Linux 3.3.
 	  flags are defined for this command.
 
 
-
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-dqevent.rst b/Documentation/linux_tv/media/v4l/vidioc-dqevent.rst
index 4d813a903693..850cb5ed0015 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-dqevent.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-dqevent.rst
@@ -6,17 +6,18 @@
 ioctl VIDIOC_DQEVENT
 ********************
 
-*man VIDIOC_DQEVENT(2)*
+NAME
+====
 
-Dequeue event
+VIDIOC_DQEVENT - Dequeue event
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_event *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -28,7 +29,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 Dequeue an event from a video device. No input is required for this
@@ -563,8 +564,7 @@ call.
 	  decoder.
 
 
-
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-dv-timings-cap.rst b/Documentation/linux_tv/media/v4l/vidioc-dv-timings-cap.rst
index 475dbb75aef3..61fef531363c 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-dv-timings-cap.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-dv-timings-cap.rst
@@ -6,18 +6,18 @@
 ioctl VIDIOC_DV_TIMINGS_CAP, VIDIOC_SUBDEV_DV_TIMINGS_CAP
 *********************************************************
 
-*man VIDIOC_DV_TIMINGS_CAP(2)*
+NAME
+====
 
-VIDIOC_SUBDEV_DV_TIMINGS_CAP
-The capabilities of the Digital Video receiver/transmitter
+VIDIOC_DV_TIMINGS_CAP - VIDIOC_SUBDEV_DV_TIMINGS_CAP - The capabilities of the Digital Video receiver/transmitter
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_dv_timings_cap *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -29,7 +29,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 To query the capabilities of the DV receiver/transmitter applications
@@ -241,8 +241,7 @@ that doesn't support them will return an ``EINVAL`` error code.
 	  the standards set in the ``standards`` field.
 
 
-
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-encoder-cmd.rst b/Documentation/linux_tv/media/v4l/vidioc-encoder-cmd.rst
index 78c014ded43b..1991014fd6b5 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-encoder-cmd.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-encoder-cmd.rst
@@ -6,18 +6,18 @@
 ioctl VIDIOC_ENCODER_CMD, VIDIOC_TRY_ENCODER_CMD
 ************************************************
 
-*man VIDIOC_ENCODER_CMD(2)*
+NAME
+====
 
-VIDIOC_TRY_ENCODER_CMD
-Execute an encoder command
+VIDIOC_ENCODER_CMD - VIDIOC_TRY_ENCODER_CMD - Execute an encoder command
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_encoder_cmd *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -29,7 +29,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 These ioctls control an audio/video (usually MPEG-) encoder.
@@ -179,8 +179,7 @@ introduced in Linux 2.6.21.
 	  rather than immediately.
 
 
-
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enum-dv-timings.rst b/Documentation/linux_tv/media/v4l/vidioc-enum-dv-timings.rst
index 5aa2db9076a0..41fa4313c1c2 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enum-dv-timings.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enum-dv-timings.rst
@@ -6,18 +6,18 @@
 ioctl VIDIOC_ENUM_DV_TIMINGS, VIDIOC_SUBDEV_ENUM_DV_TIMINGS
 ***********************************************************
 
-*man VIDIOC_ENUM_DV_TIMINGS(2)*
+NAME
+====
 
-VIDIOC_SUBDEV_ENUM_DV_TIMINGS
-Enumerate supported Digital Video timings
+VIDIOC_ENUM_DV_TIMINGS - VIDIOC_SUBDEV_ENUM_DV_TIMINGS - Enumerate supported Digital Video timings
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_enum_dv_timings *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -29,7 +29,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 While some DV receivers or transmitters support a wide range of timings,
@@ -103,8 +103,7 @@ return an ``EINVAL`` error code.
        -  The timings.
 
 
-
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enum-fmt.rst b/Documentation/linux_tv/media/v4l/vidioc-enum-fmt.rst
index 5cc97ce281ef..3b935b07837a 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enum-fmt.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enum-fmt.rst
@@ -6,17 +6,18 @@
 ioctl VIDIOC_ENUM_FMT
 *********************
 
-*man VIDIOC_ENUM_FMT(2)*
+NAME
+====
 
-Enumerate image formats
+VIDIOC_ENUM_FMT - Enumerate image formats
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_fmtdesc *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -28,7 +29,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 To enumerate image formats applications initialize the ``type`` and
@@ -150,8 +151,7 @@ formats may be different.
 	  format instead for better performance.
 
 
-
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enum-frameintervals.rst b/Documentation/linux_tv/media/v4l/vidioc-enum-frameintervals.rst
index 29cf2fa5ba87..3336a166b878 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enum-frameintervals.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enum-frameintervals.rst
@@ -6,17 +6,18 @@
 ioctl VIDIOC_ENUM_FRAMEINTERVALS
 ********************************
 
-*man VIDIOC_ENUM_FRAMEINTERVALS(2)*
+NAME
+====
 
-Enumerate frame intervals
+VIDIOC_ENUM_FRAMEINTERVALS - Enumerate frame intervals
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_frmivalenum *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -31,7 +32,7 @@ Arguments
     interval.
 
 
-Description
+DESCRIPTION
 ===========
 
 This ioctl allows applications to enumerate all frame intervals that the
@@ -264,8 +265,7 @@ Enums
        -  Step-wise defined frame interval.
 
 
-
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enum-framesizes.rst b/Documentation/linux_tv/media/v4l/vidioc-enum-framesizes.rst
index 396cdcf44c7e..d01fffaeda04 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enum-framesizes.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enum-framesizes.rst
@@ -6,17 +6,18 @@
 ioctl VIDIOC_ENUM_FRAMESIZES
 ****************************
 
-*man VIDIOC_ENUM_FRAMESIZES(2)*
+NAME
+====
 
-Enumerate frame sizes
+VIDIOC_ENUM_FRAMESIZES - Enumerate frame sizes
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_frmsizeenum *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -31,7 +32,7 @@ Arguments
     and height.
 
 
-Description
+DESCRIPTION
 ===========
 
 This ioctl allows applications to enumerate all frame sizes (i. e. width
@@ -281,8 +282,7 @@ Enums
        -  Step-wise defined frame size.
 
 
-
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enum-freq-bands.rst b/Documentation/linux_tv/media/v4l/vidioc-enum-freq-bands.rst
index da3bda140965..7fdde4be282c 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enum-freq-bands.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enum-freq-bands.rst
@@ -6,17 +6,18 @@
 ioctl VIDIOC_ENUM_FREQ_BANDS
 ****************************
 
-*man VIDIOC_ENUM_FREQ_BANDS(2)*
+NAME
+====
 
-Enumerate supported frequency bands
+VIDIOC_ENUM_FREQ_BANDS - Enumerate supported frequency bands
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_frequency_band *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -28,7 +29,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 Enumerates the frequency bands that a tuner or modulator supports. To do
@@ -176,8 +177,7 @@ of the corresponding tuner/modulator is set.
        -  Amplitude Modulation, commonly used for analog radio.
 
 
-
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enumaudio.rst b/Documentation/linux_tv/media/v4l/vidioc-enumaudio.rst
index 9573e54271fc..f833e581f7c3 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enumaudio.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enumaudio.rst
@@ -6,17 +6,18 @@
 ioctl VIDIOC_ENUMAUDIO
 **********************
 
-*man VIDIOC_ENUMAUDIO(2)*
+NAME
+====
 
-Enumerate audio inputs
+VIDIOC_ENUMAUDIO - Enumerate audio inputs
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_audio *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -28,7 +29,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 To query the attributes of an audio input applications initialize the
@@ -43,7 +44,7 @@ See :ref:`VIDIOC_G_AUDIO <VIDIOC_G_AUDIO>` for a description of struct
 :ref:`v4l2_audio <v4l2-audio>`.
 
 
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enumaudioout.rst b/Documentation/linux_tv/media/v4l/vidioc-enumaudioout.rst
index 82ffb3194ed3..f2caf6c71f44 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enumaudioout.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enumaudioout.rst
@@ -6,17 +6,18 @@
 ioctl VIDIOC_ENUMAUDOUT
 ***********************
 
-*man VIDIOC_ENUMAUDOUT(2)*
+NAME
+====
 
-Enumerate audio outputs
+VIDIOC_ENUMAUDOUT - Enumerate audio outputs
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_audioout *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -28,7 +29,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 To query the attributes of an audio output applications initialize the
@@ -46,7 +47,7 @@ See :ref:`VIDIOC_G_AUDIOout <VIDIOC_G_AUDIOout>` for a description of struct
 :ref:`v4l2_audioout <v4l2-audioout>`.
 
 
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enuminput.rst b/Documentation/linux_tv/media/v4l/vidioc-enuminput.rst
index d27556c112bb..01a1cadc71d2 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enuminput.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enuminput.rst
@@ -6,17 +6,18 @@
 ioctl VIDIOC_ENUMINPUT
 **********************
 
-*man VIDIOC_ENUMINPUT(2)*
+NAME
+====
 
-Enumerate video inputs
+VIDIOC_ENUMINPUT - Enumerate video inputs
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_input *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -28,7 +29,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 To query the attributes of a video input applications initialize the
@@ -353,8 +354,7 @@ at index zero, incrementing by one until the driver returns ``EINVAL``.
 	  :ref:`v4l2-selections-common`.
 
 
-
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enumoutput.rst b/Documentation/linux_tv/media/v4l/vidioc-enumoutput.rst
index a0a9a375ef3f..99c70e54c4d6 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enumoutput.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enumoutput.rst
@@ -6,17 +6,18 @@
 ioctl VIDIOC_ENUMOUTPUT
 ***********************
 
-*man VIDIOC_ENUMOUTPUT(2)*
+NAME
+====
 
-Enumerate video outputs
+VIDIOC_ENUMOUTPUT - Enumerate video outputs
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_output *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -28,7 +29,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 To query the attributes of a video outputs applications initialize the
@@ -208,8 +209,7 @@ EINVAL.
 	  :ref:`v4l2-selections-common`.
 
 
-
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enumstd.rst b/Documentation/linux_tv/media/v4l/vidioc-enumstd.rst
index 718b29510eeb..e74514ea4437 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enumstd.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enumstd.rst
@@ -6,17 +6,18 @@
 ioctl VIDIOC_ENUMSTD
 ********************
 
-*man VIDIOC_ENUMSTD(2)*
+NAME
+====
 
-Enumerate supported video standards
+VIDIOC_ENUMSTD - Enumerate supported video standards
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_standard *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -28,7 +29,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 To query the attributes of a video standard, especially a custom (driver
@@ -384,8 +385,7 @@ support digital TV. See also the Linux DVB API at
        -  + 6.5  [8]_
 
 
-
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-expbuf.rst b/Documentation/linux_tv/media/v4l/vidioc-expbuf.rst
index 548b15a841c3..2c08a349ab45 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-expbuf.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-expbuf.rst
@@ -6,17 +6,18 @@
 ioctl VIDIOC_EXPBUF
 *******************
 
-*man VIDIOC_EXPBUF(2)*
+NAME
+====
 
-Export a buffer as a DMABUF file descriptor.
+VIDIOC_EXPBUF - Export a buffer as a DMABUF file descriptor.
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_exportbuffer *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -28,7 +29,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 This ioctl is an extension to the :ref:`memory mapping <mmap>` I/O
@@ -183,8 +184,7 @@ Examples
 	  the array to zero.
 
 
-
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-audio.rst b/Documentation/linux_tv/media/v4l/vidioc-g-audio.rst
index d0bdc2d36734..02db00a31722 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-audio.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-audio.rst
@@ -6,20 +6,20 @@
 ioctl VIDIOC_G_AUDIO, VIDIOC_S_AUDIO
 ************************************
 
-*man VIDIOC_G_AUDIO(2)*
+NAME
+====
 
-VIDIOC_S_AUDIO
-Query or select the current audio input and its attributes
+VIDIOC_G_AUDIO - VIDIOC_S_AUDIO - Query or select the current audio input and its attributes
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_audio *argp )
 
 .. cpp:function:: int ioctl( int fd, int request, const struct v4l2_audio *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -31,7 +31,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 To query the current audio input applications zero out the ``reserved``
@@ -149,8 +149,7 @@ return the actual new audio mode.
        -  AVL mode is on.
 
 
-
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-audioout.rst b/Documentation/linux_tv/media/v4l/vidioc-g-audioout.rst
index 7f13b6fbb73d..9265be57d0f9 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-audioout.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-audioout.rst
@@ -6,20 +6,20 @@
 ioctl VIDIOC_G_AUDOUT, VIDIOC_S_AUDOUT
 **************************************
 
-*man VIDIOC_G_AUDOUT(2)*
+NAME
+====
 
-VIDIOC_S_AUDOUT
-Query or select the current audio output
+VIDIOC_G_AUDOUT - VIDIOC_S_AUDOUT - Query or select the current audio output
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_audioout *argp )
 
 .. cpp:function:: int ioctl( int fd, int request, const struct v4l2_audioout *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -31,7 +31,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 To query the current audio output applications zero out the ``reserved``
@@ -108,8 +108,7 @@ sound card are not audio outputs in this sense.
 	  the array to zero.
 
 
-
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-crop.rst b/Documentation/linux_tv/media/v4l/vidioc-g-crop.rst
index a368636b305d..206fdd5f825f 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-crop.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-crop.rst
@@ -6,20 +6,20 @@
 ioctl VIDIOC_G_CROP, VIDIOC_S_CROP
 **********************************
 
-*man VIDIOC_G_CROP(2)*
+NAME
+====
 
-VIDIOC_S_CROP
-Get or set the current cropping rectangle
+VIDIOC_G_CROP - VIDIOC_S_CROP - Get or set the current cropping rectangle
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_crop *argp )
 
 .. cpp:function:: int ioctl( int fd, int request, const struct v4l2_crop *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -31,7 +31,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 To query the cropping rectangle size and position applications set the
@@ -104,8 +104,7 @@ When cropping is not supported then no parameters are changed and
 	  :ref:`v4l2_cropcap <v4l2-cropcap>` ``bounds`` is used.
 
 
-
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst b/Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst
index db1e7b252147..50fddb140288 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst
@@ -6,18 +6,18 @@
 ioctl VIDIOC_G_CTRL, VIDIOC_S_CTRL
 **********************************
 
-*man VIDIOC_G_CTRL(2)*
+NAME
+====
 
-VIDIOC_S_CTRL
-Get or set the value of a control
+VIDIOC_G_CTRL - VIDIOC_S_CTRL - Get or set the value of a control
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_control *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -29,7 +29,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 To get the current value of a control applications initialize the ``id``
@@ -78,8 +78,7 @@ These ioctls work only with user controls. For other control classes the
        -  New value or current value.
 
 
-
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-dv-timings.rst b/Documentation/linux_tv/media/v4l/vidioc-g-dv-timings.rst
index 8c72b2d461d3..f6e7fd261ebc 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-dv-timings.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-dv-timings.rst
@@ -6,20 +6,18 @@
 ioctl VIDIOC_G_DV_TIMINGS, VIDIOC_S_DV_TIMINGS
 **********************************************
 
-*man VIDIOC_G_DV_TIMINGS(2)*
+NAME
+====
 
-VIDIOC_S_DV_TIMINGS
-VIDIOC_SUBDEV_G_DV_TIMINGS
-VIDIOC_SUBDEV_S_DV_TIMINGS
-Get or set DV timings for input or output
+VIDIOC_G_DV_TIMINGS - VIDIOC_S_DV_TIMINGS - VIDIOC_SUBDEV_G_DV_TIMINGS - VIDIOC_SUBDEV_S_DV_TIMINGS - Get or set DV timings for input or output
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_dv_timings *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -32,7 +30,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 To set DV timings for the input or output, applications use the
@@ -51,7 +49,7 @@ the current input or output does not support DV timings (e.g. if
 ``V4L2_IN_CAP_DV_TIMINGS`` flag), then ``ENODATA`` error code is returned.
 
 
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-edid.rst b/Documentation/linux_tv/media/v4l/vidioc-g-edid.rst
index cbed4805f017..1414026f5740 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-edid.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-edid.rst
@@ -6,20 +6,18 @@
 ioctl VIDIOC_G_EDID, VIDIOC_S_EDID, VIDIOC_SUBDEV_G_EDID, VIDIOC_SUBDEV_S_EDID
 ******************************************************************************
 
-*man VIDIOC_G_EDID(2)*
+NAME
+====
 
-VIDIOC_S_EDID
-VIDIOC_SUBDEV_G_EDID
-VIDIOC_SUBDEV_S_EDID
-Get or set the EDID of a video receiver/transmitter
+VIDIOC_G_EDID - VIDIOC_S_EDID - VIDIOC_SUBDEV_G_EDID - VIDIOC_SUBDEV_S_EDID - Get or set the EDID of a video receiver/transmitter
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_edid *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -32,7 +30,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 These ioctls can be used to get or set an EDID associated with an input
@@ -145,8 +143,7 @@ EDID is no longer available.
 	  ``blocks`` * 128.
 
 
-
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-enc-index.rst b/Documentation/linux_tv/media/v4l/vidioc-g-enc-index.rst
index 0ae21890dd61..16f0e8135952 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-enc-index.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-enc-index.rst
@@ -6,17 +6,18 @@
 ioctl VIDIOC_G_ENC_INDEX
 ************************
 
-*man VIDIOC_G_ENC_INDEX(2)*
+NAME
+====
 
-Get meta data about a compressed video stream
+VIDIOC_G_ENC_INDEX - Get meta data about a compressed video stream
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_enc_idx *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -28,7 +29,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 The :ref:`VIDIOC_G_ENC_INDEX <VIDIOC_G_ENC_INDEX>` ioctl provides meta data about a compressed
@@ -200,8 +201,7 @@ video elementary streams.
 	  type.
 
 
-
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-ext-ctrls.rst b/Documentation/linux_tv/media/v4l/vidioc-g-ext-ctrls.rst
index 9a2cc1b98c43..2f69b1cf804b 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-ext-ctrls.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-ext-ctrls.rst
@@ -6,19 +6,18 @@
 ioctl VIDIOC_G_EXT_CTRLS, VIDIOC_S_EXT_CTRLS, VIDIOC_TRY_EXT_CTRLS
 ******************************************************************
 
-*man VIDIOC_G_EXT_CTRLS(2)*
+NAME
+====
 
-VIDIOC_S_EXT_CTRLS
-VIDIOC_TRY_EXT_CTRLS
-Get or set the value of several controls, try control values
+VIDIOC_G_EXT_CTRLS - VIDIOC_S_EXT_CTRLS - VIDIOC_TRY_EXT_CTRLS - Get or set the value of several controls, try control values
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_ext_controls *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -31,7 +30,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 These ioctls allow the caller to get or set multiple controls
@@ -452,8 +451,7 @@ still cause this situation.
 	  described in :ref:`rf-tuner-controls`.
 
 
-
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-fbuf.rst b/Documentation/linux_tv/media/v4l/vidioc-g-fbuf.rst
index 05a477f4925c..4d0799414420 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-fbuf.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-fbuf.rst
@@ -6,20 +6,20 @@
 ioctl VIDIOC_G_FBUF, VIDIOC_S_FBUF
 **********************************
 
-*man VIDIOC_G_FBUF(2)*
+NAME
+====
 
-VIDIOC_S_FBUF
-Get or set frame buffer overlay parameters
+VIDIOC_G_FBUF - VIDIOC_S_FBUF - Get or set frame buffer overlay parameters
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_framebuffer *argp )
 
 .. cpp:function:: int ioctl( int fd, int request, const struct v4l2_framebuffer *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -31,7 +31,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 Applications can use the :ref:`VIDIOC_G_FBUF <VIDIOC_G_FBUF>` and :ref:`VIDIOC_S_FBUF <VIDIOC_G_FBUF>` ioctl
@@ -477,8 +477,7 @@ destructive video overlay.
 	  :ref:`v4l2_window <v4l2-window>` is being used.
 
 
-
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-fmt.rst b/Documentation/linux_tv/media/v4l/vidioc-g-fmt.rst
index 4e56ff72ddcb..aede100b668b 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-fmt.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-fmt.rst
@@ -6,19 +6,18 @@
 ioctl VIDIOC_G_FMT, VIDIOC_S_FMT, VIDIOC_TRY_FMT
 ************************************************
 
-*man VIDIOC_G_FMT(2)*
+NAME
+====
 
-VIDIOC_S_FMT
-VIDIOC_TRY_FMT
-Get or set the data format, try a format
+VIDIOC_G_FMT - VIDIOC_S_FMT - VIDIOC_TRY_FMT - Get or set the data format, try a format
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_format *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -30,7 +29,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 These ioctls are used to negotiate the format of data (typically image
@@ -176,8 +175,7 @@ The format as returned by :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` must be identical
        -  Place holder for future extensions.
 
 
-
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-frequency.rst b/Documentation/linux_tv/media/v4l/vidioc-g-frequency.rst
index e5c49033b5a1..2b921cda2e4d 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-frequency.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-frequency.rst
@@ -6,20 +6,20 @@
 ioctl VIDIOC_G_FREQUENCY, VIDIOC_S_FREQUENCY
 ********************************************
 
-*man VIDIOC_G_FREQUENCY(2)*
+NAME
+====
 
-VIDIOC_S_FREQUENCY
-Get or set tuner or modulator radio frequency
+VIDIOC_G_FREQUENCY - VIDIOC_S_FREQUENCY - Get or set tuner or modulator radio frequency
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_frequency *argp )
 
 .. cpp:function:: int ioctl( int fd, int request, const struct v4l2_frequency *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -31,7 +31,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 To get the current tuner or modulator radio frequency applications set
@@ -107,8 +107,7 @@ write-only ioctl, it does not return the actual new frequency.
 	  the array to zero.
 
 
-
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-input.rst b/Documentation/linux_tv/media/v4l/vidioc-g-input.rst
index aae135ea2a77..e069ba3952ea 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-input.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-input.rst
@@ -6,18 +6,18 @@
 ioctl VIDIOC_G_INPUT, VIDIOC_S_INPUT
 ************************************
 
-*man VIDIOC_G_INPUT(2)*
+NAME
+====
 
-VIDIOC_S_INPUT
-Query or select the current video input
+VIDIOC_G_INPUT - VIDIOC_S_INPUT - Query or select the current video input
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, int *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -29,7 +29,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 To query the current video input applications call the
@@ -50,7 +50,7 @@ Information about video inputs is available using the
 :ref:`VIDIOC_ENUMINPUT` ioctl.
 
 
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-jpegcomp.rst b/Documentation/linux_tv/media/v4l/vidioc-g-jpegcomp.rst
index cea36cf3af17..c8d3a3b53a51 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-jpegcomp.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-jpegcomp.rst
@@ -6,18 +6,20 @@
 ioctl VIDIOC_G_JPEGCOMP, VIDIOC_S_JPEGCOMP
 ******************************************
 
-*man VIDIOC_G_JPEGCOMP(2)*
+NAME
+====
 
-VIDIOC_S_JPEGCOMP
+VIDIOC_G_JPEGCOMP - VIDIOC_S_JPEGCOMP
 
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, v4l2_jpegcompression *argp )
 
 .. cpp:function:: int ioctl( int fd, int request, const v4l2_jpegcompression *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -29,7 +31,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 These ioctls are **deprecated**. New drivers and applications should use
@@ -173,8 +175,7 @@ encoding. You usually do want to add them.
        -  App segment, driver will always use APP0
 
 
-
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-modulator.rst b/Documentation/linux_tv/media/v4l/vidioc-g-modulator.rst
index 7fe256319682..21b9fea34b8c 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-modulator.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-modulator.rst
@@ -6,20 +6,20 @@
 ioctl VIDIOC_G_MODULATOR, VIDIOC_S_MODULATOR
 ********************************************
 
-*man VIDIOC_G_MODULATOR(2)*
+NAME
+====
 
-VIDIOC_S_MODULATOR
-Get or set modulator attributes
+VIDIOC_G_MODULATOR - VIDIOC_S_MODULATOR - Get or set modulator attributes
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_modulator *argp )
 
 .. cpp:function:: int ioctl( int fd, int request, const struct v4l2_modulator *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -31,7 +31,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 To query the attributes of a modulator applications initialize the
@@ -242,8 +242,7 @@ To change the radio frequency the
        -  Enable the RDS encoder for a radio FM transmitter.
 
 
-
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-output.rst b/Documentation/linux_tv/media/v4l/vidioc-g-output.rst
index cd0646eb7539..c9fb075ec5d1 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-output.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-output.rst
@@ -6,18 +6,18 @@
 ioctl VIDIOC_G_OUTPUT, VIDIOC_S_OUTPUT
 **************************************
 
-*man VIDIOC_G_OUTPUT(2)*
+NAME
+====
 
-VIDIOC_S_OUTPUT
-Query or select the current video output
+VIDIOC_G_OUTPUT - VIDIOC_S_OUTPUT - Query or select the current video output
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, int *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -29,7 +29,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 To query the current video output applications call the
@@ -51,7 +51,7 @@ Information about video outputs is available using the
 :ref:`VIDIOC_ENUMOUTPUT` ioctl.
 
 
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-parm.rst b/Documentation/linux_tv/media/v4l/vidioc-g-parm.rst
index 7dbf1b5e918e..964e3b8ce275 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-parm.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-parm.rst
@@ -6,18 +6,18 @@
 ioctl VIDIOC_G_PARM, VIDIOC_S_PARM
 **********************************
 
-*man VIDIOC_G_PARM(2)*
+NAME
+====
 
-VIDIOC_S_PARM
-Get or set streaming parameters
+VIDIOC_G_PARM - VIDIOC_S_PARM - Get or set streaming parameters
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, v4l2_streamparm *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -29,7 +29,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 The current video standard determines a nominal number of frames per
@@ -340,8 +340,7 @@ union holding separate parameters for input and output devices.
 	  -  Capture might only work through the :ref:`read() <func-read>` call.
 
 
-
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-priority.rst b/Documentation/linux_tv/media/v4l/vidioc-g-priority.rst
index 1551f3139899..8255f2469cd9 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-priority.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-priority.rst
@@ -6,20 +6,20 @@
 ioctl VIDIOC_G_PRIORITY, VIDIOC_S_PRIORITY
 ******************************************
 
-*man VIDIOC_G_PRIORITY(2)*
+NAME
+====
 
-VIDIOC_S_PRIORITY
-Query or request the access priority associated with a file descriptor
+VIDIOC_G_PRIORITY - VIDIOC_S_PRIORITY - Query or request the access priority associated with a file descriptor
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. c:function:: int ioctl( int fd, int request, enum v4l2_priority *argp )
 
 .. c:function:: int ioctl( int fd, int request, const enum v4l2_priority *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -32,7 +32,7 @@ Arguments
     Pointer to an enum v4l2_priority type.
 
 
-Description
+DESCRIPTION
 ===========
 
 To query the current access priority applications call the
@@ -102,8 +102,7 @@ with a pointer to this variable.
 	  applications which must not be interrupted, like video recording.
 
 
-
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-selection.rst b/Documentation/linux_tv/media/v4l/vidioc-g-selection.rst
index 609510a03cde..c4164eaafca8 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-selection.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-selection.rst
@@ -6,18 +6,18 @@
 ioctl VIDIOC_G_SELECTION, VIDIOC_S_SELECTION
 ********************************************
 
-*man VIDIOC_G_SELECTION(2)*
+NAME
+====
 
-VIDIOC_S_SELECTION
-Get or set one of the selection rectangles
+VIDIOC_G_SELECTION - VIDIOC_S_SELECTION - Get or set one of the selection rectangles
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_selection *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -29,7 +29,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 The ioctls are used to query and configure selection rectangles.
@@ -187,8 +187,7 @@ Selection targets and flags are documented in
 	  this array.
 
 
-
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-sliced-vbi-cap.rst b/Documentation/linux_tv/media/v4l/vidioc-g-sliced-vbi-cap.rst
index 39d297836824..466760241fdb 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-sliced-vbi-cap.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-sliced-vbi-cap.rst
@@ -6,17 +6,18 @@
 ioctl VIDIOC_G_SLICED_VBI_CAP
 *****************************
 
-*man VIDIOC_G_SLICED_VBI_CAP(2)*
+NAME
+====
 
-Query sliced VBI capabilities
+VIDIOC_G_SLICED_VBI_CAP - Query sliced VBI capabilities
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_sliced_vbi_cap *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -28,7 +29,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 To find out which data services are supported by a sliced VBI capture or
@@ -263,8 +264,7 @@ to write-read, in Linux 2.6.19.
        -  :cspan:`2` Set of services applicable to 625 line systems.
 
 
-
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-std.rst b/Documentation/linux_tv/media/v4l/vidioc-g-std.rst
index e1e3bb7fa726..4fbc9e9bfeb8 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-std.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-std.rst
@@ -6,20 +6,20 @@
 ioctl VIDIOC_G_STD, VIDIOC_S_STD
 ********************************
 
-*man VIDIOC_G_STD(2)*
+NAME
+====
 
-VIDIOC_S_STD
-Query or select the video standard of the current input
+VIDIOC_G_STD - VIDIOC_S_STD - Query or select the video standard of the current input
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, v4l2_std_id *argp )
 
 .. cpp:function:: int ioctl( int fd, int request, const v4l2_std_id *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -31,7 +31,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 To query and select the current video standard applications use the
@@ -53,7 +53,7 @@ does not set the ``V4L2_IN_CAP_STD`` flag), then ``ENODATA`` error code is
 returned.
 
 
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-tuner.rst b/Documentation/linux_tv/media/v4l/vidioc-g-tuner.rst
index eee4acfcf3cf..fe904db57597 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-tuner.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-tuner.rst
@@ -6,20 +6,20 @@
 ioctl VIDIOC_G_TUNER, VIDIOC_S_TUNER
 ************************************
 
-*man VIDIOC_G_TUNER(2)*
+NAME
+====
 
-VIDIOC_S_TUNER
-Get or set tuner attributes
+VIDIOC_G_TUNER - VIDIOC_S_TUNER - Get or set tuner attributes
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_tuner *argp )
 
 .. cpp:function:: int ioctl( int fd, int request, const struct v4l2_tuner *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -31,7 +31,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 To query the attributes of a tuner applications initialize the ``index``
@@ -692,8 +692,7 @@ To change the radio frequency the
        -  Lang1/Lang2 (preferred) or Lang1/Lang1
 
 
-
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-log-status.rst b/Documentation/linux_tv/media/v4l/vidioc-log-status.rst
index afff82efe392..d96d5e4f242a 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-log-status.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-log-status.rst
@@ -6,17 +6,23 @@
 ioctl VIDIOC_LOG_STATUS
 ***********************
 
-*man VIDIOC_LOG_STATUS(2)*
+NAME
+====
 
-Log driver status information
+VIDIOC_LOG_STATUS - Log driver status information
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request )
 
-Description
+
+ARGUMENTS
+=========
+
+
+
+DESCRIPTION
 ===========
 
 As the video/audio devices become more complicated it becomes harder to
@@ -31,7 +37,7 @@ This ioctl is optional and not all drivers support it. It was introduced
 in Linux 2.6.15.
 
 
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-overlay.rst b/Documentation/linux_tv/media/v4l/vidioc-overlay.rst
index 41ddeea5537f..cd58a34a7ee8 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-overlay.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-overlay.rst
@@ -6,17 +6,18 @@
 ioctl VIDIOC_OVERLAY
 ********************
 
-*man VIDIOC_OVERLAY(2)*
+NAME
+====
 
-Start or stop video overlay
+VIDIOC_OVERLAY - Start or stop video overlay
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, const int *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -28,7 +29,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 This ioctl is part of the :ref:`video overlay <overlay>` I/O method.
@@ -41,7 +42,7 @@ Drivers do not support :ref:`VIDIOC_STREAMON` or
 ``V4L2_BUF_TYPE_VIDEO_OVERLAY``.
 
 
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-prepare-buf.rst b/Documentation/linux_tv/media/v4l/vidioc-prepare-buf.rst
index 2c88d3cedecf..0f51082f8c93 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-prepare-buf.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-prepare-buf.rst
@@ -6,17 +6,18 @@
 ioctl VIDIOC_PREPARE_BUF
 ************************
 
-*man VIDIOC_PREPARE_BUF(2)*
+NAME
+====
 
-Prepare a buffer for I/O
+VIDIOC_PREPARE_BUF - Prepare a buffer for I/O
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_buffer *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -28,7 +29,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 Applications can optionally call the :ref:`VIDIOC_PREPARE_BUF` ioctl to
@@ -44,7 +45,7 @@ The :ref:`struct v4l2_buffer <v4l2-buffer>` structure is specified in
 :ref:`buffer`.
 
 
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-qbuf.rst b/Documentation/linux_tv/media/v4l/vidioc-qbuf.rst
index 88179f8019fa..bf41f30cf9c4 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-qbuf.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-qbuf.rst
@@ -6,18 +6,18 @@
 ioctl VIDIOC_QBUF, VIDIOC_DQBUF
 *******************************
 
-*man VIDIOC_QBUF(2)*
+NAME
+====
 
-VIDIOC_DQBUF
-Exchange a buffer with the driver
+VIDIOC_QBUF - VIDIOC_DQBUF - Exchange a buffer with the driver
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_buffer *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -29,7 +29,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 Applications call the ``VIDIOC_QBUF`` ioctl to enqueue an empty
@@ -116,7 +116,7 @@ The :ref:`struct v4l2_buffer <v4l2-buffer>` structure is specified in
 :ref:`buffer`.
 
 
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-query-dv-timings.rst b/Documentation/linux_tv/media/v4l/vidioc-query-dv-timings.rst
index 6a37b6503399..38295fd5f1ad 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-query-dv-timings.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-query-dv-timings.rst
@@ -6,18 +6,18 @@
 ioctl VIDIOC_QUERY_DV_TIMINGS
 *****************************
 
-*man VIDIOC_QUERY_DV_TIMINGS(2)*
+NAME
+====
 
-VIDIOC_SUBDEV_QUERY_DV_TIMINGS
-Sense the DV preset received by the current input
+VIDIOC_QUERY_DV_TIMINGS - VIDIOC_SUBDEV_QUERY_DV_TIMINGS - Sense the DV preset received by the current input
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_dv_timings *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -29,7 +29,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 The hardware may be able to detect the current DV timings automatically,
@@ -61,7 +61,7 @@ found timings with the hardware's capabilities in order to give more
 precise feedback to the user.
 
 
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-querybuf.rst b/Documentation/linux_tv/media/v4l/vidioc-querybuf.rst
index 2fae7021b511..6454c302644d 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-querybuf.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-querybuf.rst
@@ -6,17 +6,18 @@
 ioctl VIDIOC_QUERYBUF
 *********************
 
-*man VIDIOC_QUERYBUF(2)*
+NAME
+====
 
-Query the status of a buffer
+VIDIOC_QUERYBUF - Query the status of a buffer
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_buffer *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -28,7 +29,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 This ioctl is part of the :ref:`streaming <mmap>` I/O method. It can
@@ -67,7 +68,7 @@ The :ref:`struct v4l2_buffer <v4l2-buffer>` structure is specified in
 :ref:`buffer`.
 
 
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-querycap.rst b/Documentation/linux_tv/media/v4l/vidioc-querycap.rst
index 0051c483a323..406c5eb34034 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-querycap.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-querycap.rst
@@ -6,17 +6,18 @@
 ioctl VIDIOC_QUERYCAP
 *********************
 
-*man VIDIOC_QUERYCAP(2)*
+NAME
+====
 
-Query device capabilities
+VIDIOC_QUERYCAP - Query device capabilities
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_capability *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -28,7 +29,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 All V4L2 devices support the ``VIDIOC_QUERYCAP`` ioctl. It is used to
@@ -419,8 +420,7 @@ specification the ioctl returns an ``EINVAL`` error code.
 	  ``device_caps`` field.
 
 
-
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-queryctrl.rst b/Documentation/linux_tv/media/v4l/vidioc-queryctrl.rst
index 93e524c7e38d..4e0eb7b04fd2 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-queryctrl.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-queryctrl.rst
@@ -6,14 +6,12 @@
 ioctls VIDIOC_QUERYCTRL, VIDIOC_QUERY_EXT_CTRL and VIDIOC_QUERYMENU
 *******************************************************************
 
-*man VIDIOC_QUERYCTRL(2)*
+NAME
+====
 
-VIDIOC_QUERY_EXT_CTRL
-VIDIOC_QUERYMENU
-Enumerate controls and menu control items
+VIDIOC_QUERYCTRL - VIDIOC_QUERY_EXT_CTRL - VIDIOC_QUERYMENU - Enumerate controls and menu control items
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_queryctrl *argp )
@@ -22,7 +20,8 @@ Synopsis
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_querymenu *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -34,7 +33,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 To query the attributes of a control applications set the ``id`` field
@@ -754,8 +753,7 @@ See also the examples in :ref:`control`.
 	  ``V4L2_CTRL_TYPE_BUTTON`` have this flag set.
 
 
-
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-querystd.rst b/Documentation/linux_tv/media/v4l/vidioc-querystd.rst
index 8d6769f2b5c6..fe540f80ef60 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-querystd.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-querystd.rst
@@ -6,17 +6,18 @@
 ioctl VIDIOC_QUERYSTD
 *********************
 
-*man VIDIOC_QUERYSTD(2)*
+NAME
+====
 
-Sense the video standard received by the current input
+VIDIOC_QUERYSTD - Sense the video standard received by the current input
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, v4l2_std_id *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -28,7 +29,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 The hardware may be able to detect the current video standard
@@ -53,7 +54,7 @@ standard is valid they will have to stop streaming, set the new
 standard, allocate new buffers and start streaming again.
 
 
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-reqbufs.rst b/Documentation/linux_tv/media/v4l/vidioc-reqbufs.rst
index 6803f21c8f4f..2e27708fd7a6 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-reqbufs.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-reqbufs.rst
@@ -6,17 +6,18 @@
 ioctl VIDIOC_REQBUFS
 ********************
 
-*man VIDIOC_REQBUFS(2)*
+NAME
+====
 
-Initiate Memory Mapping or User Pointer I/O
+VIDIOC_REQBUFS - Initiate Memory Mapping or User Pointer I/O
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_requestbuffers *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -28,7 +29,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 This ioctl is used to initiate :ref:`memory mapped <mmap>`,
@@ -111,8 +112,7 @@ any DMA in progress, an implicit
 	  must set the array to zero.
 
 
-
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-s-hw-freq-seek.rst b/Documentation/linux_tv/media/v4l/vidioc-s-hw-freq-seek.rst
index efa5e930b3bb..068a67e8a523 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-s-hw-freq-seek.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-s-hw-freq-seek.rst
@@ -6,17 +6,18 @@
 ioctl VIDIOC_S_HW_FREQ_SEEK
 ***************************
 
-*man VIDIOC_S_HW_FREQ_SEEK(2)*
+NAME
+====
 
-Perform a hardware frequency seek
+VIDIOC_S_HW_FREQ_SEEK - Perform a hardware frequency seek
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_hw_freq_seek *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -28,7 +29,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 Start a hardware frequency seek from the current frequency. To do this
@@ -154,8 +155,7 @@ error code is returned and no seek takes place.
 	  zero.
 
 
-
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-streamon.rst b/Documentation/linux_tv/media/v4l/vidioc-streamon.rst
index c3ea38c6cb5b..0e6b750f8718 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-streamon.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-streamon.rst
@@ -6,18 +6,18 @@
 ioctl VIDIOC_STREAMON, VIDIOC_STREAMOFF
 ***************************************
 
-*man VIDIOC_STREAMON(2)*
+NAME
+====
 
-VIDIOC_STREAMOFF
-Start or stop streaming I/O
+VIDIOC_STREAMON - VIDIOC_STREAMOFF - Start or stop streaming I/O
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, const int *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -29,7 +29,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 The ``VIDIOC_STREAMON`` and ``VIDIOC_STREAMOFF`` ioctl start and stop
@@ -81,7 +81,7 @@ no notion of starting or stopping "now". Buffer timestamps can be used
 to synchronize with other events.
 
 
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-interval.rst b/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-interval.rst
index d22926a6257b..0d2b690cf8bc 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-interval.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-interval.rst
@@ -6,17 +6,18 @@
 ioctl VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL
 ***************************************
 
-*man VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL(2)*
+NAME
+====
 
-Enumerate frame intervals
+VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL - Enumerate frame intervals
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_subdev_frame_interval_enum * argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -28,7 +29,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 This ioctl lets applications enumerate available frame intervals on a
@@ -136,8 +137,7 @@ multiple pads of the same sub-device is not defined.
 	  the array to zero.
 
 
-
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-size.rst b/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-size.rst
index 91738510b122..c52a02df5b16 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-size.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-size.rst
@@ -6,17 +6,18 @@
 ioctl VIDIOC_SUBDEV_ENUM_FRAME_SIZE
 ***********************************
 
-*man VIDIOC_SUBDEV_ENUM_FRAME_SIZE(2)*
+NAME
+====
 
-Enumerate media bus frame sizes
+VIDIOC_SUBDEV_ENUM_FRAME_SIZE - Enumerate media bus frame sizes
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_subdev_frame_size_enum * argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -28,7 +29,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 This ioctl allows applications to enumerate all frame sizes supported by
@@ -146,8 +147,7 @@ information about try formats.
 	  the array to zero.
 
 
-
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-mbus-code.rst b/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-mbus-code.rst
index da0d0407346c..1ff173e502f7 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-mbus-code.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-mbus-code.rst
@@ -6,17 +6,18 @@
 ioctl VIDIOC_SUBDEV_ENUM_MBUS_CODE
 **********************************
 
-*man VIDIOC_SUBDEV_ENUM_MBUS_CODE(2)*
+NAME
+====
 
-Enumerate media bus formats
+VIDIOC_SUBDEV_ENUM_MBUS_CODE - Enumerate media bus formats
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_subdev_mbus_code_enum * argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -28,7 +29,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 To enumerate media bus formats available at a given sub-device pad
@@ -99,8 +100,7 @@ information about the try formats.
 	  the array to zero.
 
 
-
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subdev-g-crop.rst b/Documentation/linux_tv/media/v4l/vidioc-subdev-g-crop.rst
index eb13718a4654..94bffa78c486 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-subdev-g-crop.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-subdev-g-crop.rst
@@ -6,20 +6,20 @@
 ioctl VIDIOC_SUBDEV_G_CROP, VIDIOC_SUBDEV_S_CROP
 ************************************************
 
-*man VIDIOC_SUBDEV_G_CROP(2)*
+NAME
+====
 
-VIDIOC_SUBDEV_S_CROP
-Get or set the crop rectangle on a subdev pad
+VIDIOC_SUBDEV_G_CROP - VIDIOC_SUBDEV_S_CROP - Get or set the crop rectangle on a subdev pad
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_subdev_crop *argp )
 
 .. cpp:function:: int ioctl( int fd, int request, const struct v4l2_subdev_crop *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -31,7 +31,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
     **Note**
@@ -114,8 +114,7 @@ modified format should be as close as possible to the original request.
 	  the array to zero.
 
 
-
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subdev-g-fmt.rst b/Documentation/linux_tv/media/v4l/vidioc-subdev-g-fmt.rst
index 9de901ad7cdd..13615c0d0392 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-subdev-g-fmt.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-subdev-g-fmt.rst
@@ -6,18 +6,18 @@
 ioctl VIDIOC_SUBDEV_G_FMT, VIDIOC_SUBDEV_S_FMT
 **********************************************
 
-*man VIDIOC_SUBDEV_G_FMT(2)*
+NAME
+====
 
-VIDIOC_SUBDEV_S_FMT
-Get or set the data format on a subdev pad
+VIDIOC_SUBDEV_G_FMT - VIDIOC_SUBDEV_S_FMT - Get or set the data format on a subdev pad
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_subdev_format *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -29,7 +29,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 These ioctls are used to negotiate the frame format at specific subdev
@@ -144,8 +144,7 @@ should be as close as possible to the original request.
        -  Active formats, applied to the hardware.
 
 
-
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
@@ -164,7 +163,6 @@ EINVAL
     references a non-existing format.
 
 
-Return Value
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subdev-g-frame-interval.rst b/Documentation/linux_tv/media/v4l/vidioc-subdev-g-frame-interval.rst
index 947fbf0f9a23..05f5bfb3f1ca 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-subdev-g-frame-interval.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-subdev-g-frame-interval.rst
@@ -6,18 +6,18 @@
 ioctl VIDIOC_SUBDEV_G_FRAME_INTERVAL, VIDIOC_SUBDEV_S_FRAME_INTERVAL
 ********************************************************************
 
-*man VIDIOC_SUBDEV_G_FRAME_INTERVAL(2)*
+NAME
+====
 
-VIDIOC_SUBDEV_S_FRAME_INTERVAL
-Get or set the frame interval on a subdev pad
+VIDIOC_SUBDEV_G_FRAME_INTERVAL - VIDIOC_SUBDEV_S_FRAME_INTERVAL - Get or set the frame interval on a subdev pad
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_subdev_frame_interval *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -30,7 +30,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 These ioctls are used to get and set the frame interval at specific
@@ -100,8 +100,7 @@ the same sub-device is not defined.
 	  the array to zero.
 
 
-
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subdev-g-selection.rst b/Documentation/linux_tv/media/v4l/vidioc-subdev-g-selection.rst
index fa6dcccd0a2b..dd0dab7d7e42 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-subdev-g-selection.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-subdev-g-selection.rst
@@ -6,18 +6,18 @@
 ioctl VIDIOC_SUBDEV_G_SELECTION, VIDIOC_SUBDEV_S_SELECTION
 **********************************************************
 
-*man VIDIOC_SUBDEV_G_SELECTION(2)*
+NAME
+====
 
-VIDIOC_SUBDEV_S_SELECTION
-Get or set selection rectangles on a subdev pad
+VIDIOC_SUBDEV_G_SELECTION - VIDIOC_SUBDEV_S_SELECTION - Get or set selection rectangles on a subdev pad
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_subdev_selection *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -29,7 +29,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 The selections are used to configure various image processing
@@ -122,8 +122,7 @@ Selection targets and flags are documented in
 	  the array to zero.
 
 
-
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subscribe-event.rst b/Documentation/linux_tv/media/v4l/vidioc-subscribe-event.rst
index 8beba56d62b9..2ecce157f852 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-subscribe-event.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-subscribe-event.rst
@@ -6,18 +6,18 @@
 ioctl VIDIOC_SUBSCRIBE_EVENT, VIDIOC_UNSUBSCRIBE_EVENT
 ******************************************************
 
-*man VIDIOC_SUBSCRIBE_EVENT(2)*
+NAME
+====
 
-VIDIOC_UNSUBSCRIBE_EVENT
-Subscribe or unsubscribe event
+VIDIOC_SUBSCRIBE_EVENT - VIDIOC_UNSUBSCRIBE_EVENT - Subscribe or unsubscribe event
 
-
-Synopsis
+SYNOPSIS
 ========
 
 .. cpp:function:: int ioctl( int fd, int request, struct v4l2_event_subscription *argp )
 
-Arguments
+
+ARGUMENTS
 =========
 
 ``fd``
@@ -29,7 +29,7 @@ Arguments
 ``argp``
 
 
-Description
+DESCRIPTION
 ===========
 
 Subscribe or unsubscribe V4L2 event. Subscribed events are dequeued by
@@ -126,8 +126,7 @@ using the :ref:`VIDIOC_DQEVENT` ioctl.
 	  situations like that.
 
 
-
-Return Value
+RETURN VALUE
 ============
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
-- 
2.7.4

