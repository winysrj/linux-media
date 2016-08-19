Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42957 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754893AbcHSU2B (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 16:28:01 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Markus Heiser <markus.heiser@darmarIT.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-doc@vger.kernel.org
Subject: [PATCH 1/6] [media] docs-next: stop abusing on the cpp domain
Date: Fri, 19 Aug 2016 17:27:48 -0300
Message-Id: <c3aa86b43448a2fd56e984b102ef3244f8d63332.1471636893.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471636893.git.mchehab@s-opensource.com>
References: <cover.1471636893.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471636893.git.mchehab@s-opensource.com>
References: <cover.1471636893.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that we have an override for the c domain that will do
the right thing for the Kernel, stop abusing on the cpp
domain.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/conf_nitpick.py                | 33 +++++++++++-----------
 Documentation/media/kapi/dtv-core.rst              |  2 +-
 Documentation/media/kapi/v4l2-dev.rst              |  4 +--
 Documentation/media/kapi/v4l2-fh.rst               |  4 +--
 Documentation/media/kapi/v4l2-subdev.rst           |  2 +-
 Documentation/media/uapi/cec/cec-func-close.rst    |  2 +-
 Documentation/media/uapi/cec/cec-func-ioctl.rst    |  2 +-
 Documentation/media/uapi/cec/cec-func-open.rst     |  2 +-
 Documentation/media/uapi/cec/cec-func-poll.rst     |  2 +-
 .../media/uapi/cec/cec-ioc-adap-g-caps.rst         |  2 +-
 .../media/uapi/cec/cec-ioc-adap-g-log-addrs.rst    |  2 +-
 .../media/uapi/cec/cec-ioc-adap-g-phys-addr.rst    |  2 +-
 Documentation/media/uapi/cec/cec-ioc-g-mode.rst    |  2 +-
 Documentation/media/uapi/cec/cec-ioc-receive.rst   |  2 +-
 .../uapi/dvb/audio-bilingual-channel-select.rst    |  2 +-
 .../media/uapi/dvb/audio-channel-select.rst        |  2 +-
 .../media/uapi/dvb/audio-clear-buffer.rst          |  2 +-
 Documentation/media/uapi/dvb/audio-continue.rst    |  2 +-
 Documentation/media/uapi/dvb/audio-fclose.rst      |  2 +-
 Documentation/media/uapi/dvb/audio-fopen.rst       |  2 +-
 Documentation/media/uapi/dvb/audio-fwrite.rst      |  2 +-
 .../media/uapi/dvb/audio-get-capabilities.rst      |  2 +-
 Documentation/media/uapi/dvb/audio-get-pts.rst     |  2 +-
 Documentation/media/uapi/dvb/audio-get-status.rst  |  2 +-
 Documentation/media/uapi/dvb/audio-pause.rst       |  2 +-
 Documentation/media/uapi/dvb/audio-play.rst        |  2 +-
 .../media/uapi/dvb/audio-select-source.rst         |  2 +-
 .../media/uapi/dvb/audio-set-attributes.rst        |  2 +-
 Documentation/media/uapi/dvb/audio-set-av-sync.rst |  2 +-
 .../media/uapi/dvb/audio-set-bypass-mode.rst       |  2 +-
 Documentation/media/uapi/dvb/audio-set-ext-id.rst  |  2 +-
 Documentation/media/uapi/dvb/audio-set-id.rst      |  2 +-
 Documentation/media/uapi/dvb/audio-set-karaoke.rst |  2 +-
 Documentation/media/uapi/dvb/audio-set-mixer.rst   |  2 +-
 Documentation/media/uapi/dvb/audio-set-mute.rst    |  2 +-
 .../media/uapi/dvb/audio-set-streamtype.rst        |  2 +-
 Documentation/media/uapi/dvb/audio-stop.rst        |  2 +-
 Documentation/media/uapi/dvb/ca-fclose.rst         |  2 +-
 Documentation/media/uapi/dvb/ca-fopen.rst          |  2 +-
 Documentation/media/uapi/dvb/ca-get-cap.rst        |  2 +-
 Documentation/media/uapi/dvb/ca-get-descr-info.rst |  2 +-
 Documentation/media/uapi/dvb/ca-get-msg.rst        |  2 +-
 Documentation/media/uapi/dvb/ca-get-slot-info.rst  |  2 +-
 Documentation/media/uapi/dvb/ca-reset.rst          |  2 +-
 Documentation/media/uapi/dvb/ca-send-msg.rst       |  2 +-
 Documentation/media/uapi/dvb/ca-set-descr.rst      |  2 +-
 Documentation/media/uapi/dvb/ca-set-pid.rst        |  2 +-
 Documentation/media/uapi/dvb/dmx-add-pid.rst       |  2 +-
 Documentation/media/uapi/dvb/dmx-fclose.rst        |  2 +-
 Documentation/media/uapi/dvb/dmx-fopen.rst         |  2 +-
 Documentation/media/uapi/dvb/dmx-fread.rst         |  2 +-
 Documentation/media/uapi/dvb/dmx-fwrite.rst        |  2 +-
 Documentation/media/uapi/dvb/dmx-get-caps.rst      |  2 +-
 Documentation/media/uapi/dvb/dmx-get-event.rst     |  2 +-
 Documentation/media/uapi/dvb/dmx-get-pes-pids.rst  |  2 +-
 Documentation/media/uapi/dvb/dmx-get-stc.rst       |  2 +-
 Documentation/media/uapi/dvb/dmx-remove-pid.rst    |  2 +-
 .../media/uapi/dvb/dmx-set-buffer-size.rst         |  2 +-
 Documentation/media/uapi/dvb/dmx-set-filter.rst    |  2 +-
 .../media/uapi/dvb/dmx-set-pes-filter.rst          |  2 +-
 Documentation/media/uapi/dvb/dmx-set-source.rst    |  2 +-
 Documentation/media/uapi/dvb/dmx-start.rst         |  2 +-
 Documentation/media/uapi/dvb/dmx-stop.rst          |  2 +-
 .../media/uapi/dvb/fe-diseqc-recv-slave-reply.rst  |  2 +-
 .../media/uapi/dvb/fe-diseqc-reset-overload.rst    |  2 +-
 .../media/uapi/dvb/fe-diseqc-send-burst.rst        |  2 +-
 .../media/uapi/dvb/fe-diseqc-send-master-cmd.rst   |  2 +-
 .../uapi/dvb/fe-dishnetwork-send-legacy-cmd.rst    |  2 +-
 .../media/uapi/dvb/fe-enable-high-lnb-voltage.rst  |  2 +-
 Documentation/media/uapi/dvb/fe-get-event.rst      |  2 +-
 Documentation/media/uapi/dvb/fe-get-frontend.rst   |  2 +-
 Documentation/media/uapi/dvb/fe-get-info.rst       |  2 +-
 Documentation/media/uapi/dvb/fe-get-property.rst   |  2 +-
 Documentation/media/uapi/dvb/fe-read-ber.rst       |  2 +-
 .../media/uapi/dvb/fe-read-signal-strength.rst     |  2 +-
 Documentation/media/uapi/dvb/fe-read-snr.rst       |  2 +-
 Documentation/media/uapi/dvb/fe-read-status.rst    |  2 +-
 .../media/uapi/dvb/fe-read-uncorrected-blocks.rst  |  2 +-
 .../media/uapi/dvb/fe-set-frontend-tune-mode.rst   |  2 +-
 Documentation/media/uapi/dvb/fe-set-frontend.rst   |  2 +-
 Documentation/media/uapi/dvb/fe-set-tone.rst       |  2 +-
 Documentation/media/uapi/dvb/fe-set-voltage.rst    |  2 +-
 Documentation/media/uapi/dvb/frontend_f_close.rst  |  2 +-
 Documentation/media/uapi/dvb/frontend_f_open.rst   |  2 +-
 Documentation/media/uapi/dvb/net-add-if.rst        |  2 +-
 Documentation/media/uapi/dvb/net-get-if.rst        |  2 +-
 Documentation/media/uapi/dvb/net-remove-if.rst     |  2 +-
 .../media/uapi/dvb/video-clear-buffer.rst          |  2 +-
 Documentation/media/uapi/dvb/video-command.rst     |  2 +-
 Documentation/media/uapi/dvb/video-continue.rst    |  2 +-
 .../media/uapi/dvb/video-fast-forward.rst          |  2 +-
 Documentation/media/uapi/dvb/video-fclose.rst      |  2 +-
 Documentation/media/uapi/dvb/video-fopen.rst       |  2 +-
 Documentation/media/uapi/dvb/video-freeze.rst      |  2 +-
 Documentation/media/uapi/dvb/video-fwrite.rst      |  2 +-
 .../media/uapi/dvb/video-get-capabilities.rst      |  2 +-
 Documentation/media/uapi/dvb/video-get-event.rst   |  2 +-
 .../media/uapi/dvb/video-get-frame-count.rst       |  2 +-
 .../media/uapi/dvb/video-get-frame-rate.rst        |  2 +-
 Documentation/media/uapi/dvb/video-get-navi.rst    |  2 +-
 Documentation/media/uapi/dvb/video-get-pts.rst     |  2 +-
 Documentation/media/uapi/dvb/video-get-size.rst    |  2 +-
 Documentation/media/uapi/dvb/video-get-status.rst  |  2 +-
 Documentation/media/uapi/dvb/video-play.rst        |  2 +-
 .../media/uapi/dvb/video-select-source.rst         |  2 +-
 .../media/uapi/dvb/video-set-attributes.rst        |  2 +-
 Documentation/media/uapi/dvb/video-set-blank.rst   |  2 +-
 .../media/uapi/dvb/video-set-display-format.rst    |  2 +-
 Documentation/media/uapi/dvb/video-set-format.rst  |  2 +-
 .../media/uapi/dvb/video-set-highlight.rst         |  2 +-
 Documentation/media/uapi/dvb/video-set-id.rst      |  2 +-
 .../media/uapi/dvb/video-set-spu-palette.rst       |  2 +-
 Documentation/media/uapi/dvb/video-set-spu.rst     |  2 +-
 .../media/uapi/dvb/video-set-streamtype.rst        |  2 +-
 Documentation/media/uapi/dvb/video-set-system.rst  |  2 +-
 Documentation/media/uapi/dvb/video-slowmotion.rst  |  2 +-
 .../media/uapi/dvb/video-stillpicture.rst          |  2 +-
 Documentation/media/uapi/dvb/video-stop.rst        |  2 +-
 Documentation/media/uapi/dvb/video-try-command.rst |  2 +-
 .../media/uapi/mediactl/media-func-close.rst       |  2 +-
 .../media/uapi/mediactl/media-func-ioctl.rst       |  2 +-
 .../media/uapi/mediactl/media-func-open.rst        |  2 +-
 .../media/uapi/mediactl/media-ioc-device-info.rst  |  2 +-
 .../uapi/mediactl/media-ioc-enum-entities.rst      |  2 +-
 .../media/uapi/mediactl/media-ioc-enum-links.rst   |  2 +-
 .../media/uapi/mediactl/media-ioc-g-topology.rst   |  2 +-
 .../media/uapi/mediactl/media-ioc-setup-link.rst   |  2 +-
 Documentation/media/uapi/rc/lirc-get-features.rst  |  2 +-
 Documentation/media/uapi/rc/lirc-get-length.rst    |  2 +-
 Documentation/media/uapi/rc/lirc-get-rec-mode.rst  |  2 +-
 .../media/uapi/rc/lirc-get-rec-resolution.rst      |  2 +-
 Documentation/media/uapi/rc/lirc-get-send-mode.rst |  2 +-
 Documentation/media/uapi/rc/lirc-get-timeout.rst   |  2 +-
 Documentation/media/uapi/rc/lirc-read.rst          |  2 +-
 .../uapi/rc/lirc-set-measure-carrier-mode.rst      |  2 +-
 .../media/uapi/rc/lirc-set-rec-carrier-range.rst   |  2 +-
 .../media/uapi/rc/lirc-set-rec-carrier.rst         |  2 +-
 .../media/uapi/rc/lirc-set-rec-timeout-reports.rst |  2 +-
 .../media/uapi/rc/lirc-set-rec-timeout.rst         |  2 +-
 .../media/uapi/rc/lirc-set-send-carrier.rst        |  2 +-
 .../media/uapi/rc/lirc-set-send-duty-cycle.rst     |  2 +-
 .../media/uapi/rc/lirc-set-transmitter-mask.rst    |  2 +-
 .../media/uapi/rc/lirc-set-wideband-receiver.rst   |  2 +-
 Documentation/media/uapi/rc/lirc-write.rst         |  2 +-
 Documentation/media/uapi/v4l/func-close.rst        |  2 +-
 Documentation/media/uapi/v4l/func-ioctl.rst        |  2 +-
 Documentation/media/uapi/v4l/func-mmap.rst         |  2 +-
 Documentation/media/uapi/v4l/func-munmap.rst       |  2 +-
 Documentation/media/uapi/v4l/func-open.rst         |  2 +-
 Documentation/media/uapi/v4l/func-poll.rst         |  2 +-
 Documentation/media/uapi/v4l/func-read.rst         |  2 +-
 Documentation/media/uapi/v4l/func-select.rst       |  2 +-
 Documentation/media/uapi/v4l/func-write.rst        |  2 +-
 .../media/uapi/v4l/vidioc-create-bufs.rst          |  2 +-
 Documentation/media/uapi/v4l/vidioc-cropcap.rst    |  2 +-
 .../media/uapi/v4l/vidioc-dbg-g-chip-info.rst      |  2 +-
 .../media/uapi/v4l/vidioc-dbg-g-register.rst       |  4 +--
 .../media/uapi/v4l/vidioc-decoder-cmd.rst          |  2 +-
 Documentation/media/uapi/v4l/vidioc-dqevent.rst    |  2 +-
 .../media/uapi/v4l/vidioc-dv-timings-cap.rst       |  2 +-
 .../media/uapi/v4l/vidioc-encoder-cmd.rst          |  2 +-
 .../media/uapi/v4l/vidioc-enum-dv-timings.rst      |  2 +-
 Documentation/media/uapi/v4l/vidioc-enum-fmt.rst   |  2 +-
 .../media/uapi/v4l/vidioc-enum-frameintervals.rst  |  2 +-
 .../media/uapi/v4l/vidioc-enum-framesizes.rst      |  2 +-
 .../media/uapi/v4l/vidioc-enum-freq-bands.rst      |  2 +-
 Documentation/media/uapi/v4l/vidioc-enumaudio.rst  |  2 +-
 .../media/uapi/v4l/vidioc-enumaudioout.rst         |  2 +-
 Documentation/media/uapi/v4l/vidioc-enuminput.rst  |  2 +-
 Documentation/media/uapi/v4l/vidioc-enumoutput.rst |  2 +-
 Documentation/media/uapi/v4l/vidioc-enumstd.rst    |  2 +-
 Documentation/media/uapi/v4l/vidioc-expbuf.rst     |  2 +-
 Documentation/media/uapi/v4l/vidioc-g-audio.rst    |  4 +--
 Documentation/media/uapi/v4l/vidioc-g-audioout.rst |  4 +--
 Documentation/media/uapi/v4l/vidioc-g-crop.rst     |  4 +--
 Documentation/media/uapi/v4l/vidioc-g-ctrl.rst     |  2 +-
 .../media/uapi/v4l/vidioc-g-dv-timings.rst         |  2 +-
 Documentation/media/uapi/v4l/vidioc-g-edid.rst     |  2 +-
 .../media/uapi/v4l/vidioc-g-enc-index.rst          |  2 +-
 .../media/uapi/v4l/vidioc-g-ext-ctrls.rst          |  2 +-
 Documentation/media/uapi/v4l/vidioc-g-fbuf.rst     |  4 +--
 Documentation/media/uapi/v4l/vidioc-g-fmt.rst      |  2 +-
 .../media/uapi/v4l/vidioc-g-frequency.rst          |  4 +--
 Documentation/media/uapi/v4l/vidioc-g-input.rst    |  2 +-
 Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst |  4 +--
 .../media/uapi/v4l/vidioc-g-modulator.rst          |  4 +--
 Documentation/media/uapi/v4l/vidioc-g-output.rst   |  2 +-
 Documentation/media/uapi/v4l/vidioc-g-parm.rst     |  2 +-
 Documentation/media/uapi/v4l/vidioc-g-priority.rst |  4 +--
 .../media/uapi/v4l/vidioc-g-selection.rst          |  2 +-
 .../media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst     |  2 +-
 Documentation/media/uapi/v4l/vidioc-g-std.rst      |  4 +--
 Documentation/media/uapi/v4l/vidioc-g-tuner.rst    |  4 +--
 Documentation/media/uapi/v4l/vidioc-log-status.rst |  2 +-
 Documentation/media/uapi/v4l/vidioc-overlay.rst    |  2 +-
 .../media/uapi/v4l/vidioc-prepare-buf.rst          |  2 +-
 Documentation/media/uapi/v4l/vidioc-qbuf.rst       |  2 +-
 .../media/uapi/v4l/vidioc-query-dv-timings.rst     |  2 +-
 Documentation/media/uapi/v4l/vidioc-querybuf.rst   |  2 +-
 Documentation/media/uapi/v4l/vidioc-querycap.rst   |  2 +-
 Documentation/media/uapi/v4l/vidioc-queryctrl.rst  |  6 ++--
 Documentation/media/uapi/v4l/vidioc-querystd.rst   |  2 +-
 Documentation/media/uapi/v4l/vidioc-reqbufs.rst    |  2 +-
 .../media/uapi/v4l/vidioc-s-hw-freq-seek.rst       |  2 +-
 Documentation/media/uapi/v4l/vidioc-streamon.rst   |  2 +-
 .../uapi/v4l/vidioc-subdev-enum-frame-interval.rst |  2 +-
 .../uapi/v4l/vidioc-subdev-enum-frame-size.rst     |  2 +-
 .../uapi/v4l/vidioc-subdev-enum-mbus-code.rst      |  2 +-
 .../media/uapi/v4l/vidioc-subdev-g-crop.rst        |  4 +--
 .../media/uapi/v4l/vidioc-subdev-g-fmt.rst         |  2 +-
 .../uapi/v4l/vidioc-subdev-g-frame-interval.rst    |  2 +-
 .../media/uapi/v4l/vidioc-subdev-g-selection.rst   |  2 +-
 .../media/uapi/v4l/vidioc-subscribe-event.rst      |  2 +-
 213 files changed, 244 insertions(+), 245 deletions(-)

diff --git a/Documentation/media/conf_nitpick.py b/Documentation/media/conf_nitpick.py
index 11beac2e68fb..227deee68c88 100644
--- a/Documentation/media/conf_nitpick.py
+++ b/Documentation/media/conf_nitpick.py
@@ -39,55 +39,54 @@ nitpick_ignore = [
     ("c:func", "write"),
     ("c:type", "atomic_t"),
     ("c:type", "bool"),
+    ("c:type", "boolean"),
     ("c:type", "buf_queue"),
     ("c:type", "device"),
     ("c:type", "device_driver"),
     ("c:type", "device_node"),
     ("c:type", "enum"),
+    ("c:type", "fd"),
+    ("c:type", "fd_set"),
     ("c:type", "file"),
     ("c:type", "i2c_adapter"),
     ("c:type", "i2c_board_info"),
     ("c:type", "i2c_client"),
+    ("c:type", "int16_t"),
     ("c:type", "ktime_t"),
     ("c:type", "led_classdev_flash"),
     ("c:type", "list_head"),
     ("c:type", "lock_class_key"),
     ("c:type", "module"),
     ("c:type", "mutex"),
+    ("c:type", "NULL"),
+    ("c:type", "off_t"),
     ("c:type", "pci_dev"),
     ("c:type", "pdvbdev"),
+    ("c:type", "pollfd"),
     ("c:type", "poll_table_struct"),
     ("c:type", "s32"),
     ("c:type", "s64"),
     ("c:type", "sd"),
+    ("c:type", "size_t"),
     ("c:type", "spi_board_info"),
     ("c:type", "spi_device"),
     ("c:type", "spi_master"),
+    ("c:type", "ssize_t"),
     ("c:type", "struct fb_fix_screeninfo"),
     ("c:type", "struct pollfd"),
     ("c:type", "struct timeval"),
     ("c:type", "struct video_capability"),
+    ("c:type", "timeval"),
+    ("c:type", "__u16"),
     ("c:type", "u16"),
+    ("c:type", "__u32"),
     ("c:type", "u32"),
+    ("c:type", "__u64"),
     ("c:type", "u64"),
     ("c:type", "u8"),
+    ("c:type", "uint16_t"),
+    ("c:type", "uint32_t"),
     ("c:type", "union"),
     ("c:type", "usb_device"),
-
-    ("cpp:type", "boolean"),
-    ("cpp:type", "fd"),
-    ("cpp:type", "fd_set"),
-    ("cpp:type", "int16_t"),
-    ("cpp:type", "NULL"),
-    ("cpp:type", "off_t"),
-    ("cpp:type", "pollfd"),
-    ("cpp:type", "size_t"),
-    ("cpp:type", "ssize_t"),
-    ("cpp:type", "timeval"),
-    ("cpp:type", "__u16"),
-    ("cpp:type", "__u32"),
-    ("cpp:type", "__u64"),
-    ("cpp:type", "uint16_t"),
-    ("cpp:type", "uint32_t"),
-    ("cpp:type", "video_system_t"),
+    ("c:type", "video_system_t"),
 ]
diff --git a/Documentation/media/kapi/dtv-core.rst b/Documentation/media/kapi/dtv-core.rst
index dd96e846fef9..41df9f144fcb 100644
--- a/Documentation/media/kapi/dtv-core.rst
+++ b/Documentation/media/kapi/dtv-core.rst
@@ -121,7 +121,7 @@ triggered by a hardware interrupt, it is recommended to use the Linux
 bottom half mechanism or start a tasklet instead of making the callback
 function call directly from a hardware interrupt.
 
-This mechanism is implemented by :c:func:`dmx_ts_cb()` and :cpp:func:`dmx_section_cb()`
+This mechanism is implemented by :c:func:`dmx_ts_cb()` and :c:func:`dmx_section_cb()`
 callbacks.
 
 .. kernel-doc:: drivers/media/dvb-core/demux.h
diff --git a/Documentation/media/kapi/v4l2-dev.rst b/Documentation/media/kapi/v4l2-dev.rst
index cdfcf0bc78be..821b835be3c8 100644
--- a/Documentation/media/kapi/v4l2-dev.rst
+++ b/Documentation/media/kapi/v4l2-dev.rst
@@ -166,7 +166,7 @@ something.
 In the case of :ref:`videobuf2 <vb2_framework>` you will need to implement the
 ``wait_prepare()`` and ``wait_finish()`` callbacks to unlock/lock if applicable.
 If you use the ``queue->lock`` pointer, then you can use the helper functions
-:c:func:`vb2_ops_wait_prepare` and :cpp:func:`vb2_ops_wait_finish`.
+:c:func:`vb2_ops_wait_prepare` and :c:func:`vb2_ops_wait_finish`.
 
 The implementation of a hotplug disconnect should also take the lock from
 :c:type:`video_device` before calling v4l2_device_disconnect. If you are also
@@ -334,7 +334,7 @@ And this function:
 
 returns the video_device belonging to the file struct.
 
-The :c:func:`video_devdata` function combines :cpp:func:`video_get_drvdata`
+The :c:func:`video_devdata` function combines :c:func:`video_get_drvdata`
 with :c:func:`video_devdata`:
 
 	:c:func:`video_drvdata <video_drvdata>`
diff --git a/Documentation/media/kapi/v4l2-fh.rst b/Documentation/media/kapi/v4l2-fh.rst
index 9e87d5ca3e4a..3ee64adf4635 100644
--- a/Documentation/media/kapi/v4l2-fh.rst
+++ b/Documentation/media/kapi/v4l2-fh.rst
@@ -21,8 +21,8 @@ function by the driver.
 In many cases the struct :c:type:`v4l2_fh` will be embedded in a larger
 structure. In that case you should call:
 
-#) :c:func:`v4l2_fh_init` and :cpp:func:`v4l2_fh_add` in ``open()``
-#) :c:func:`v4l2_fh_del` and :cpp:func:`v4l2_fh_exit` in ``release()``
+#) :c:func:`v4l2_fh_init` and :c:func:`v4l2_fh_add` in ``open()``
+#) :c:func:`v4l2_fh_del` and :c:func:`v4l2_fh_exit` in ``release()``
 
 Drivers can extract their own file handle structure by using the container_of
 macro.
diff --git a/Documentation/media/kapi/v4l2-subdev.rst b/Documentation/media/kapi/v4l2-subdev.rst
index d767b61e9842..fcecce01a35c 100644
--- a/Documentation/media/kapi/v4l2-subdev.rst
+++ b/Documentation/media/kapi/v4l2-subdev.rst
@@ -27,7 +27,7 @@ methods.
 Bridges might also need to store per-subdev private data, such as a pointer to
 bridge-specific per-subdev private data. The :c:type:`v4l2_subdev` structure
 provides host private data for that purpose that can be accessed with
-:c:func:`v4l2_get_subdev_hostdata` and :cpp:func:`v4l2_set_subdev_hostdata`.
+:c:func:`v4l2_get_subdev_hostdata` and :c:func:`v4l2_set_subdev_hostdata`.
 
 From the bridge driver perspective, you load the sub-device module and somehow
 obtain the :c:type:`v4l2_subdev` pointer. For i2c devices this is easy: you call
diff --git a/Documentation/media/uapi/cec/cec-func-close.rst b/Documentation/media/uapi/cec/cec-func-close.rst
index bdbb9e545ae4..c763496b243f 100644
--- a/Documentation/media/uapi/cec/cec-func-close.rst
+++ b/Documentation/media/uapi/cec/cec-func-close.rst
@@ -20,7 +20,7 @@ Synopsis
     #include <unistd.h>
 
 
-.. cpp:function:: int close( int fd )
+.. c:function:: int close( int fd )
 
 Arguments
 =========
diff --git a/Documentation/media/uapi/cec/cec-func-ioctl.rst b/Documentation/media/uapi/cec/cec-func-ioctl.rst
index 170bdd56211e..116132b19515 100644
--- a/Documentation/media/uapi/cec/cec-func-ioctl.rst
+++ b/Documentation/media/uapi/cec/cec-func-ioctl.rst
@@ -19,7 +19,7 @@ Synopsis
     #include <sys/ioctl.h>
 
 
-.. cpp:function:: int ioctl( int fd, int request, void *argp )
+.. c:function:: int ioctl( int fd, int request, void *argp )
 
 Arguments
 =========
diff --git a/Documentation/media/uapi/cec/cec-func-open.rst b/Documentation/media/uapi/cec/cec-func-open.rst
index 3d55e9f2f64d..33e5b5379fa3 100644
--- a/Documentation/media/uapi/cec/cec-func-open.rst
+++ b/Documentation/media/uapi/cec/cec-func-open.rst
@@ -19,7 +19,7 @@ Synopsis
     #include <fcntl.h>
 
 
-.. cpp:function:: int open( const char *device_name, int flags )
+.. c:function:: int open( const char *device_name, int flags )
 
 
 Arguments
diff --git a/Documentation/media/uapi/cec/cec-func-poll.rst b/Documentation/media/uapi/cec/cec-func-poll.rst
index 5d1e0525056e..a5225185f98c 100644
--- a/Documentation/media/uapi/cec/cec-func-poll.rst
+++ b/Documentation/media/uapi/cec/cec-func-poll.rst
@@ -20,7 +20,7 @@ Synopsis
     #include <sys/poll.h>
 
 
-.. cpp:function:: int poll( struct pollfd *ufds, unsigned int nfds, int timeout )
+.. c:function:: int poll( struct pollfd *ufds, unsigned int nfds, int timeout )
 
 Arguments
 =========
diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
index 89ba813e577c..cc68e0dcea7e 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
@@ -14,7 +14,7 @@ CEC_ADAP_G_CAPS - Query device capabilities
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct cec_caps *argp )
+.. c:function:: int ioctl( int fd, int request, struct cec_caps *argp )
 
 Arguments
 =========
diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
index 42f8e856ec55..9de2a005f6fb 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
@@ -17,7 +17,7 @@ CEC_ADAP_G_LOG_ADDRS, CEC_ADAP_S_LOG_ADDRS - Get or set the logical addresses
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct cec_log_addrs *argp )
+.. c:function:: int ioctl( int fd, int request, struct cec_log_addrs *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst
index c50aa3ee1e0d..9502d6f25798 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst
@@ -17,7 +17,7 @@ CEC_ADAP_G_PHYS_ADDR, CEC_ADAP_S_PHYS_ADDR - Get or set the physical address
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, __u16 *argp )
+.. c:function:: int ioctl( int fd, int request, __u16 *argp )
 
 Arguments
 =========
diff --git a/Documentation/media/uapi/cec/cec-ioc-g-mode.rst b/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
index b75ed7057f7c..a33522267d47 100644
--- a/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
@@ -13,7 +13,7 @@ CEC_G_MODE, CEC_S_MODE - Get or set exclusive use of the CEC adapter
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, __u32 *argp )
+.. c:function:: int ioctl( int fd, int request, __u32 *argp )
 
 Arguments
 =========
diff --git a/Documentation/media/uapi/cec/cec-ioc-receive.rst b/Documentation/media/uapi/cec/cec-ioc-receive.rst
index a7074a967f8d..e31f62a19a3c 100644
--- a/Documentation/media/uapi/cec/cec-ioc-receive.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-receive.rst
@@ -16,7 +16,7 @@ CEC_RECEIVE, CEC_TRANSMIT - Receive or transmit a CEC message
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct cec_msg *argp )
+.. c:function:: int ioctl( int fd, int request, struct cec_msg *argp )
 
 Arguments
 =========
diff --git a/Documentation/media/uapi/dvb/audio-bilingual-channel-select.rst b/Documentation/media/uapi/dvb/audio-bilingual-channel-select.rst
index dbe20ff38e83..841c9759d5e0 100644
--- a/Documentation/media/uapi/dvb/audio-bilingual-channel-select.rst
+++ b/Documentation/media/uapi/dvb/audio-bilingual-channel-select.rst
@@ -15,7 +15,7 @@ AUDIO_BILINGUAL_CHANNEL_SELECT
 Synopsis
 --------
 
-.. cpp:function:: int ioctl(int fd, int request = AUDIO_BILINGUAL_CHANNEL_SELECT, audio_channel_select_t)
+.. c:function:: int ioctl(int fd, int request = AUDIO_BILINGUAL_CHANNEL_SELECT, audio_channel_select_t)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/audio-channel-select.rst b/Documentation/media/uapi/dvb/audio-channel-select.rst
index 69df4c0f2fb2..f2dd79903c49 100644
--- a/Documentation/media/uapi/dvb/audio-channel-select.rst
+++ b/Documentation/media/uapi/dvb/audio-channel-select.rst
@@ -15,7 +15,7 @@ AUDIO_CHANNEL_SELECT
 Synopsis
 --------
 
-.. cpp:function:: int ioctl(int fd, int request = AUDIO_CHANNEL_SELECT, audio_channel_select_t)
+.. c:function:: int ioctl(int fd, int request = AUDIO_CHANNEL_SELECT, audio_channel_select_t)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/audio-clear-buffer.rst b/Documentation/media/uapi/dvb/audio-clear-buffer.rst
index a3dec29bdc69..a576c6b160a4 100644
--- a/Documentation/media/uapi/dvb/audio-clear-buffer.rst
+++ b/Documentation/media/uapi/dvb/audio-clear-buffer.rst
@@ -15,7 +15,7 @@ AUDIO_CLEAR_BUFFER
 Synopsis
 --------
 
-.. cpp:function:: int  ioctl(int fd, int request = AUDIO_CLEAR_BUFFER)
+.. c:function:: int  ioctl(int fd, int request = AUDIO_CLEAR_BUFFER)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/audio-continue.rst b/Documentation/media/uapi/dvb/audio-continue.rst
index 053627dd61e7..b513a39f0935 100644
--- a/Documentation/media/uapi/dvb/audio-continue.rst
+++ b/Documentation/media/uapi/dvb/audio-continue.rst
@@ -15,7 +15,7 @@ AUDIO_CONTINUE
 Synopsis
 --------
 
-.. cpp:function:: int  ioctl(int fd, int request = AUDIO_CONTINUE)
+.. c:function:: int  ioctl(int fd, int request = AUDIO_CONTINUE)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/audio-fclose.rst b/Documentation/media/uapi/dvb/audio-fclose.rst
index e5d4225cd9d7..e515fb353a14 100644
--- a/Documentation/media/uapi/dvb/audio-fclose.rst
+++ b/Documentation/media/uapi/dvb/audio-fclose.rst
@@ -15,7 +15,7 @@ DVB audio close()
 Synopsis
 --------
 
-.. cpp:function:: int  close(int fd)
+.. c:function:: int  close(int fd)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/audio-fopen.rst b/Documentation/media/uapi/dvb/audio-fopen.rst
index 3ef4fd62ffb6..b629956bca5d 100644
--- a/Documentation/media/uapi/dvb/audio-fopen.rst
+++ b/Documentation/media/uapi/dvb/audio-fopen.rst
@@ -15,7 +15,7 @@ DVB audio open()
 Synopsis
 --------
 
-.. cpp:function:: int  open(const char *deviceName, int flags)
+.. c:function:: int  open(const char *deviceName, int flags)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/audio-fwrite.rst b/Documentation/media/uapi/dvb/audio-fwrite.rst
index ca95b9be0c2a..f9307053064f 100644
--- a/Documentation/media/uapi/dvb/audio-fwrite.rst
+++ b/Documentation/media/uapi/dvb/audio-fwrite.rst
@@ -15,7 +15,7 @@ DVB audio write()
 Synopsis
 --------
 
-.. cpp:function:: size_t write(int fd, const void *buf, size_t count)
+.. c:function:: size_t write(int fd, const void *buf, size_t count)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/audio-get-capabilities.rst b/Documentation/media/uapi/dvb/audio-get-capabilities.rst
index e274a8d53785..8b6fdc664f9d 100644
--- a/Documentation/media/uapi/dvb/audio-get-capabilities.rst
+++ b/Documentation/media/uapi/dvb/audio-get-capabilities.rst
@@ -15,7 +15,7 @@ AUDIO_GET_CAPABILITIES
 Synopsis
 --------
 
-.. cpp:function:: int ioctl(int fd, int request = AUDIO_GET_CAPABILITIES, unsigned int *cap)
+.. c:function:: int ioctl(int fd, int request = AUDIO_GET_CAPABILITIES, unsigned int *cap)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/audio-get-pts.rst b/Documentation/media/uapi/dvb/audio-get-pts.rst
index 5f875508b833..246c78c003de 100644
--- a/Documentation/media/uapi/dvb/audio-get-pts.rst
+++ b/Documentation/media/uapi/dvb/audio-get-pts.rst
@@ -15,7 +15,7 @@ AUDIO_GET_PTS
 Synopsis
 --------
 
-.. cpp:function:: int ioctl(int fd, int request = AUDIO_GET_PTS, __u64 *pts)
+.. c:function:: int ioctl(int fd, int request = AUDIO_GET_PTS, __u64 *pts)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/audio-get-status.rst b/Documentation/media/uapi/dvb/audio-get-status.rst
index cbd822773d85..b0a550af87b3 100644
--- a/Documentation/media/uapi/dvb/audio-get-status.rst
+++ b/Documentation/media/uapi/dvb/audio-get-status.rst
@@ -15,7 +15,7 @@ AUDIO_GET_STATUS
 Synopsis
 --------
 
-.. cpp:function:: int ioctl(int fd, int request = AUDIO_GET_STATUS, struct audio_status *status)
+.. c:function:: int ioctl(int fd, int request = AUDIO_GET_STATUS, struct audio_status *status)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/audio-pause.rst b/Documentation/media/uapi/dvb/audio-pause.rst
index 9ca263e90c6c..86652c3bca06 100644
--- a/Documentation/media/uapi/dvb/audio-pause.rst
+++ b/Documentation/media/uapi/dvb/audio-pause.rst
@@ -15,7 +15,7 @@ AUDIO_PAUSE
 Synopsis
 --------
 
-.. cpp:function:: int  ioctl(int fd, int request = AUDIO_PAUSE)
+.. c:function:: int  ioctl(int fd, int request = AUDIO_PAUSE)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/audio-play.rst b/Documentation/media/uapi/dvb/audio-play.rst
index db4d7203acc5..1af708375821 100644
--- a/Documentation/media/uapi/dvb/audio-play.rst
+++ b/Documentation/media/uapi/dvb/audio-play.rst
@@ -15,7 +15,7 @@ AUDIO_PLAY
 Synopsis
 --------
 
-.. cpp:function:: int  ioctl(int fd, int request = AUDIO_PLAY)
+.. c:function:: int  ioctl(int fd, int request = AUDIO_PLAY)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/audio-select-source.rst b/Documentation/media/uapi/dvb/audio-select-source.rst
index b806d806a46f..3e873d9cb345 100644
--- a/Documentation/media/uapi/dvb/audio-select-source.rst
+++ b/Documentation/media/uapi/dvb/audio-select-source.rst
@@ -15,7 +15,7 @@ AUDIO_SELECT_SOURCE
 Synopsis
 --------
 
-.. cpp:function:: int ioctl(int fd, int request = AUDIO_SELECT_SOURCE, audio_stream_source_t source)
+.. c:function:: int ioctl(int fd, int request = AUDIO_SELECT_SOURCE, audio_stream_source_t source)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/audio-set-attributes.rst b/Documentation/media/uapi/dvb/audio-set-attributes.rst
index 18667cea2cdf..43ff50279742 100644
--- a/Documentation/media/uapi/dvb/audio-set-attributes.rst
+++ b/Documentation/media/uapi/dvb/audio-set-attributes.rst
@@ -15,7 +15,7 @@ AUDIO_SET_ATTRIBUTES
 Synopsis
 --------
 
-.. cpp:function:: int ioctl(fd, int request = AUDIO_SET_ATTRIBUTES, audio_attributes_t attr )
+.. c:function:: int ioctl(fd, int request = AUDIO_SET_ATTRIBUTES, audio_attributes_t attr )
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/audio-set-av-sync.rst b/Documentation/media/uapi/dvb/audio-set-av-sync.rst
index 6f7e26fa4cd1..4ecfb75d28f1 100644
--- a/Documentation/media/uapi/dvb/audio-set-av-sync.rst
+++ b/Documentation/media/uapi/dvb/audio-set-av-sync.rst
@@ -15,7 +15,7 @@ AUDIO_SET_AV_SYNC
 Synopsis
 --------
 
-.. cpp:function:: int  ioctl(int fd, int request = AUDIO_SET_AV_SYNC, boolean state)
+.. c:function:: int  ioctl(int fd, int request = AUDIO_SET_AV_SYNC, boolean state)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/audio-set-bypass-mode.rst b/Documentation/media/uapi/dvb/audio-set-bypass-mode.rst
index 30bcaca14c3f..b21d142ec31c 100644
--- a/Documentation/media/uapi/dvb/audio-set-bypass-mode.rst
+++ b/Documentation/media/uapi/dvb/audio-set-bypass-mode.rst
@@ -15,7 +15,7 @@ AUDIO_SET_BYPASS_MODE
 Synopsis
 --------
 
-.. cpp:function:: int ioctl(int fd, int request = AUDIO_SET_BYPASS_MODE, boolean mode)
+.. c:function:: int ioctl(int fd, int request = AUDIO_SET_BYPASS_MODE, boolean mode)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/audio-set-ext-id.rst b/Documentation/media/uapi/dvb/audio-set-ext-id.rst
index 049414db8ef6..1b5b8893a00b 100644
--- a/Documentation/media/uapi/dvb/audio-set-ext-id.rst
+++ b/Documentation/media/uapi/dvb/audio-set-ext-id.rst
@@ -15,7 +15,7 @@ AUDIO_SET_EXT_ID
 Synopsis
 --------
 
-.. cpp:function:: int  ioctl(fd, int request = AUDIO_SET_EXT_ID, int id)
+.. c:function:: int  ioctl(fd, int request = AUDIO_SET_EXT_ID, int id)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/audio-set-id.rst b/Documentation/media/uapi/dvb/audio-set-id.rst
index a664dc1955cb..fed99eae52cb 100644
--- a/Documentation/media/uapi/dvb/audio-set-id.rst
+++ b/Documentation/media/uapi/dvb/audio-set-id.rst
@@ -15,7 +15,7 @@ AUDIO_SET_ID
 Synopsis
 --------
 
-.. cpp:function:: int  ioctl(int fd, int request = AUDIO_SET_ID, int id)
+.. c:function:: int  ioctl(int fd, int request = AUDIO_SET_ID, int id)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/audio-set-karaoke.rst b/Documentation/media/uapi/dvb/audio-set-karaoke.rst
index b55f8380b9cd..ebb2d41bbec3 100644
--- a/Documentation/media/uapi/dvb/audio-set-karaoke.rst
+++ b/Documentation/media/uapi/dvb/audio-set-karaoke.rst
@@ -15,7 +15,7 @@ AUDIO_SET_KARAOKE
 Synopsis
 --------
 
-.. cpp:function:: int ioctl(fd, int request = AUDIO_SET_KARAOKE, audio_karaoke_t *karaoke)
+.. c:function:: int ioctl(fd, int request = AUDIO_SET_KARAOKE, audio_karaoke_t *karaoke)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/audio-set-mixer.rst b/Documentation/media/uapi/dvb/audio-set-mixer.rst
index 67821729c2b6..ce4b2a63917e 100644
--- a/Documentation/media/uapi/dvb/audio-set-mixer.rst
+++ b/Documentation/media/uapi/dvb/audio-set-mixer.rst
@@ -15,7 +15,7 @@ AUDIO_SET_MIXER
 Synopsis
 --------
 
-.. cpp:function:: int ioctl(int fd, int request = AUDIO_SET_MIXER, audio_mixer_t *mix)
+.. c:function:: int ioctl(int fd, int request = AUDIO_SET_MIXER, audio_mixer_t *mix)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/audio-set-mute.rst b/Documentation/media/uapi/dvb/audio-set-mute.rst
index ebaba95ee278..a2469267508b 100644
--- a/Documentation/media/uapi/dvb/audio-set-mute.rst
+++ b/Documentation/media/uapi/dvb/audio-set-mute.rst
@@ -15,7 +15,7 @@ AUDIO_SET_MUTE
 Synopsis
 --------
 
-.. cpp:function:: int  ioctl(int fd, int request = AUDIO_SET_MUTE, boolean state)
+.. c:function:: int  ioctl(int fd, int request = AUDIO_SET_MUTE, boolean state)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/audio-set-streamtype.rst b/Documentation/media/uapi/dvb/audio-set-streamtype.rst
index dfb9a6c00d88..4b13c9b9dffe 100644
--- a/Documentation/media/uapi/dvb/audio-set-streamtype.rst
+++ b/Documentation/media/uapi/dvb/audio-set-streamtype.rst
@@ -15,7 +15,7 @@ AUDIO_SET_STREAMTYPE
 Synopsis
 --------
 
-.. cpp:function:: int  ioctl(fd, int request = AUDIO_SET_STREAMTYPE, int type)
+.. c:function:: int  ioctl(fd, int request = AUDIO_SET_STREAMTYPE, int type)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/audio-stop.rst b/Documentation/media/uapi/dvb/audio-stop.rst
index 449127e3f2aa..d9430978096f 100644
--- a/Documentation/media/uapi/dvb/audio-stop.rst
+++ b/Documentation/media/uapi/dvb/audio-stop.rst
@@ -15,7 +15,7 @@ AUDIO_STOP
 Synopsis
 --------
 
-.. cpp:function:: int ioctl(int fd, int request = AUDIO_STOP)
+.. c:function:: int ioctl(int fd, int request = AUDIO_STOP)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/ca-fclose.rst b/Documentation/media/uapi/dvb/ca-fclose.rst
index 16d7a1e76193..f2ea50b87485 100644
--- a/Documentation/media/uapi/dvb/ca-fclose.rst
+++ b/Documentation/media/uapi/dvb/ca-fclose.rst
@@ -15,7 +15,7 @@ DVB CA close()
 Synopsis
 --------
 
-.. cpp:function:: int  close(int fd)
+.. c:function:: int  close(int fd)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/ca-fopen.rst b/Documentation/media/uapi/dvb/ca-fopen.rst
index 9960fc76189c..8085a73e81c5 100644
--- a/Documentation/media/uapi/dvb/ca-fopen.rst
+++ b/Documentation/media/uapi/dvb/ca-fopen.rst
@@ -15,7 +15,7 @@ DVB CA open()
 Synopsis
 --------
 
-.. cpp:function:: int  open(const char *deviceName, int flags)
+.. c:function:: int  open(const char *deviceName, int flags)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/ca-get-cap.rst b/Documentation/media/uapi/dvb/ca-get-cap.rst
index 891fbf2d9a84..55e49fd93c2c 100644
--- a/Documentation/media/uapi/dvb/ca-get-cap.rst
+++ b/Documentation/media/uapi/dvb/ca-get-cap.rst
@@ -15,7 +15,7 @@ CA_GET_CAP
 Synopsis
 --------
 
-.. cpp:function:: int  ioctl(fd, int request = CA_GET_CAP, ca_caps_t *)
+.. c:function:: int  ioctl(fd, int request = CA_GET_CAP, ca_caps_t *)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/ca-get-descr-info.rst b/Documentation/media/uapi/dvb/ca-get-descr-info.rst
index cf8e8242db66..e546e58ef7f8 100644
--- a/Documentation/media/uapi/dvb/ca-get-descr-info.rst
+++ b/Documentation/media/uapi/dvb/ca-get-descr-info.rst
@@ -15,7 +15,7 @@ CA_GET_DESCR_INFO
 Synopsis
 --------
 
-.. cpp:function:: int  ioctl(fd, int request = CA_GET_DESCR_INFO, ca_descr_info_t *)
+.. c:function:: int  ioctl(fd, int request = CA_GET_DESCR_INFO, ca_descr_info_t *)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/ca-get-msg.rst b/Documentation/media/uapi/dvb/ca-get-msg.rst
index 56004d5ea3ab..e0d2c8853e63 100644
--- a/Documentation/media/uapi/dvb/ca-get-msg.rst
+++ b/Documentation/media/uapi/dvb/ca-get-msg.rst
@@ -15,7 +15,7 @@ CA_GET_MSG
 Synopsis
 --------
 
-.. cpp:function:: int  ioctl(fd, int request = CA_GET_MSG, ca_msg_t *)
+.. c:function:: int  ioctl(fd, int request = CA_GET_MSG, ca_msg_t *)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/ca-get-slot-info.rst b/Documentation/media/uapi/dvb/ca-get-slot-info.rst
index 9fea28ccad0f..6c46a5395f45 100644
--- a/Documentation/media/uapi/dvb/ca-get-slot-info.rst
+++ b/Documentation/media/uapi/dvb/ca-get-slot-info.rst
@@ -15,7 +15,7 @@ CA_GET_SLOT_INFO
 Synopsis
 --------
 
-.. cpp:function:: int  ioctl(fd, int request = CA_GET_SLOT_INFO, ca_slot_info_t *)
+.. c:function:: int  ioctl(fd, int request = CA_GET_SLOT_INFO, ca_slot_info_t *)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/ca-reset.rst b/Documentation/media/uapi/dvb/ca-reset.rst
index d5a50088fc2d..a91f969318fb 100644
--- a/Documentation/media/uapi/dvb/ca-reset.rst
+++ b/Documentation/media/uapi/dvb/ca-reset.rst
@@ -15,7 +15,7 @@ CA_RESET
 Synopsis
 --------
 
-.. cpp:function:: int  ioctl(fd, int request = CA_RESET)
+.. c:function:: int  ioctl(fd, int request = CA_RESET)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/ca-send-msg.rst b/Documentation/media/uapi/dvb/ca-send-msg.rst
index 18974e61e788..5e4fd4f7b683 100644
--- a/Documentation/media/uapi/dvb/ca-send-msg.rst
+++ b/Documentation/media/uapi/dvb/ca-send-msg.rst
@@ -15,7 +15,7 @@ CA_SEND_MSG
 Synopsis
 --------
 
-.. cpp:function:: int  ioctl(fd, int request = CA_SEND_MSG, ca_msg_t *)
+.. c:function:: int  ioctl(fd, int request = CA_SEND_MSG, ca_msg_t *)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/ca-set-descr.rst b/Documentation/media/uapi/dvb/ca-set-descr.rst
index 293e6da5059f..2822718d655b 100644
--- a/Documentation/media/uapi/dvb/ca-set-descr.rst
+++ b/Documentation/media/uapi/dvb/ca-set-descr.rst
@@ -15,7 +15,7 @@ CA_SET_DESCR
 Synopsis
 --------
 
-.. cpp:function:: int  ioctl(fd, int request = CA_SET_DESCR, ca_descr_t *)
+.. c:function:: int  ioctl(fd, int request = CA_SET_DESCR, ca_descr_t *)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/ca-set-pid.rst b/Documentation/media/uapi/dvb/ca-set-pid.rst
index 5afa2fae3206..1ea95c7ef4e6 100644
--- a/Documentation/media/uapi/dvb/ca-set-pid.rst
+++ b/Documentation/media/uapi/dvb/ca-set-pid.rst
@@ -15,7 +15,7 @@ CA_SET_PID
 Synopsis
 --------
 
-.. cpp:function:: int  ioctl(fd, int request = CA_SET_PID, ca_pid_t *)
+.. c:function:: int  ioctl(fd, int request = CA_SET_PID, ca_pid_t *)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/dmx-add-pid.rst b/Documentation/media/uapi/dvb/dmx-add-pid.rst
index 6343035653ac..37f5ee43d523 100644
--- a/Documentation/media/uapi/dvb/dmx-add-pid.rst
+++ b/Documentation/media/uapi/dvb/dmx-add-pid.rst
@@ -15,7 +15,7 @@ DMX_ADD_PID
 Synopsis
 --------
 
-.. cpp:function:: int ioctl(fd, int request = DMX_ADD_PID, __u16 *)
+.. c:function:: int ioctl(fd, int request = DMX_ADD_PID, __u16 *)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/dmx-fclose.rst b/Documentation/media/uapi/dvb/dmx-fclose.rst
index f54c2a1220c1..e442881481a2 100644
--- a/Documentation/media/uapi/dvb/dmx-fclose.rst
+++ b/Documentation/media/uapi/dvb/dmx-fclose.rst
@@ -15,7 +15,7 @@ DVB demux close()
 Synopsis
 --------
 
-.. cpp:function:: int close(int fd)
+.. c:function:: int close(int fd)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/dmx-fopen.rst b/Documentation/media/uapi/dvb/dmx-fopen.rst
index 76dbb42713ad..7e640fa860c3 100644
--- a/Documentation/media/uapi/dvb/dmx-fopen.rst
+++ b/Documentation/media/uapi/dvb/dmx-fopen.rst
@@ -15,7 +15,7 @@ DVB demux open()
 Synopsis
 --------
 
-.. cpp:function:: int open(const char *deviceName, int flags)
+.. c:function:: int open(const char *deviceName, int flags)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/dmx-fread.rst b/Documentation/media/uapi/dvb/dmx-fread.rst
index 266c9ca259c9..efa2a01096c1 100644
--- a/Documentation/media/uapi/dvb/dmx-fread.rst
+++ b/Documentation/media/uapi/dvb/dmx-fread.rst
@@ -15,7 +15,7 @@ DVB demux read()
 Synopsis
 --------
 
-.. cpp:function:: size_t read(int fd, void *buf, size_t count)
+.. c:function:: size_t read(int fd, void *buf, size_t count)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/dmx-fwrite.rst b/Documentation/media/uapi/dvb/dmx-fwrite.rst
index 3d76470bef60..c05a44c4535f 100644
--- a/Documentation/media/uapi/dvb/dmx-fwrite.rst
+++ b/Documentation/media/uapi/dvb/dmx-fwrite.rst
@@ -15,7 +15,7 @@ DVB demux write()
 Synopsis
 --------
 
-.. cpp:function:: ssize_t write(int fd, const void *buf, size_t count)
+.. c:function:: ssize_t write(int fd, const void *buf, size_t count)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/dmx-get-caps.rst b/Documentation/media/uapi/dvb/dmx-get-caps.rst
index d0549eb7fbd3..20e3d6e55d30 100644
--- a/Documentation/media/uapi/dvb/dmx-get-caps.rst
+++ b/Documentation/media/uapi/dvb/dmx-get-caps.rst
@@ -15,7 +15,7 @@ DMX_GET_CAPS
 Synopsis
 --------
 
-.. cpp:function:: int ioctl(fd, int request = DMX_GET_CAPS, dmx_caps_t *)
+.. c:function:: int ioctl(fd, int request = DMX_GET_CAPS, dmx_caps_t *)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/dmx-get-event.rst b/Documentation/media/uapi/dvb/dmx-get-event.rst
index 6a7550c63bb5..81a7c7fedd47 100644
--- a/Documentation/media/uapi/dvb/dmx-get-event.rst
+++ b/Documentation/media/uapi/dvb/dmx-get-event.rst
@@ -15,7 +15,7 @@ DMX_GET_EVENT
 Synopsis
 --------
 
-.. cpp:function:: int ioctl( int fd, int request = DMX_GET_EVENT, struct dmx_event *ev)
+.. c:function:: int ioctl( int fd, int request = DMX_GET_EVENT, struct dmx_event *ev)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/dmx-get-pes-pids.rst b/Documentation/media/uapi/dvb/dmx-get-pes-pids.rst
index ba5d30c913c8..8b1fbf5d2c81 100644
--- a/Documentation/media/uapi/dvb/dmx-get-pes-pids.rst
+++ b/Documentation/media/uapi/dvb/dmx-get-pes-pids.rst
@@ -15,7 +15,7 @@ DMX_GET_PES_PIDS
 Synopsis
 --------
 
-.. cpp:function:: int ioctl(fd, int request = DMX_GET_PES_PIDS, __u16[5])
+.. c:function:: int ioctl(fd, int request = DMX_GET_PES_PIDS, __u16[5])
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/dmx-get-stc.rst b/Documentation/media/uapi/dvb/dmx-get-stc.rst
index bd477bb67082..616c745a0418 100644
--- a/Documentation/media/uapi/dvb/dmx-get-stc.rst
+++ b/Documentation/media/uapi/dvb/dmx-get-stc.rst
@@ -15,7 +15,7 @@ DMX_GET_STC
 Synopsis
 --------
 
-.. cpp:function:: int ioctl( int fd, int request = DMX_GET_STC, struct dmx_stc *stc)
+.. c:function:: int ioctl( int fd, int request = DMX_GET_STC, struct dmx_stc *stc)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/dmx-remove-pid.rst b/Documentation/media/uapi/dvb/dmx-remove-pid.rst
index c8f038b40074..ed1a49ce9fc2 100644
--- a/Documentation/media/uapi/dvb/dmx-remove-pid.rst
+++ b/Documentation/media/uapi/dvb/dmx-remove-pid.rst
@@ -15,7 +15,7 @@ DMX_REMOVE_PID
 Synopsis
 --------
 
-.. cpp:function:: int ioctl(fd, int request = DMX_REMOVE_PID, __u16 *)
+.. c:function:: int ioctl(fd, int request = DMX_REMOVE_PID, __u16 *)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/dmx-set-buffer-size.rst b/Documentation/media/uapi/dvb/dmx-set-buffer-size.rst
index 8ae48cf39cda..012b9e9792be 100644
--- a/Documentation/media/uapi/dvb/dmx-set-buffer-size.rst
+++ b/Documentation/media/uapi/dvb/dmx-set-buffer-size.rst
@@ -15,7 +15,7 @@ DMX_SET_BUFFER_SIZE
 Synopsis
 --------
 
-.. cpp:function:: int ioctl( int fd, int request = DMX_SET_BUFFER_SIZE, unsigned long size)
+.. c:function:: int ioctl( int fd, int request = DMX_SET_BUFFER_SIZE, unsigned long size)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/dmx-set-filter.rst b/Documentation/media/uapi/dvb/dmx-set-filter.rst
index 8c929fa9b98c..d079d8b39597 100644
--- a/Documentation/media/uapi/dvb/dmx-set-filter.rst
+++ b/Documentation/media/uapi/dvb/dmx-set-filter.rst
@@ -15,7 +15,7 @@ DMX_SET_FILTER
 Synopsis
 --------
 
-.. cpp:function:: int ioctl( int fd, int request = DMX_SET_FILTER, struct dmx_sct_filter_params *params)
+.. c:function:: int ioctl( int fd, int request = DMX_SET_FILTER, struct dmx_sct_filter_params *params)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/dmx-set-pes-filter.rst b/Documentation/media/uapi/dvb/dmx-set-pes-filter.rst
index d71db779b6fd..1f774624383f 100644
--- a/Documentation/media/uapi/dvb/dmx-set-pes-filter.rst
+++ b/Documentation/media/uapi/dvb/dmx-set-pes-filter.rst
@@ -15,7 +15,7 @@ DMX_SET_PES_FILTER
 Synopsis
 --------
 
-.. cpp:function:: int ioctl( int fd, int request = DMX_SET_PES_FILTER, struct dmx_pes_filter_params *params)
+.. c:function:: int ioctl( int fd, int request = DMX_SET_PES_FILTER, struct dmx_pes_filter_params *params)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/dmx-set-source.rst b/Documentation/media/uapi/dvb/dmx-set-source.rst
index 99a8d5c82756..7aa4dfe3cdc5 100644
--- a/Documentation/media/uapi/dvb/dmx-set-source.rst
+++ b/Documentation/media/uapi/dvb/dmx-set-source.rst
@@ -15,7 +15,7 @@ DMX_SET_SOURCE
 Synopsis
 --------
 
-.. cpp:function:: int ioctl(fd, int request = DMX_SET_SOURCE, dmx_source_t *)
+.. c:function:: int ioctl(fd, int request = DMX_SET_SOURCE, dmx_source_t *)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/dmx-start.rst b/Documentation/media/uapi/dvb/dmx-start.rst
index 959b5eee2647..d494f6b03dbc 100644
--- a/Documentation/media/uapi/dvb/dmx-start.rst
+++ b/Documentation/media/uapi/dvb/dmx-start.rst
@@ -15,7 +15,7 @@ DMX_START
 Synopsis
 --------
 
-.. cpp:function:: int ioctl( int fd, int request = DMX_START)
+.. c:function:: int ioctl( int fd, int request = DMX_START)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/dmx-stop.rst b/Documentation/media/uapi/dvb/dmx-stop.rst
index 7e4bf09fc83e..f9157dd6a8fe 100644
--- a/Documentation/media/uapi/dvb/dmx-stop.rst
+++ b/Documentation/media/uapi/dvb/dmx-stop.rst
@@ -15,7 +15,7 @@ DMX_STOP
 Synopsis
 --------
 
-.. cpp:function:: int ioctl( int fd, int request = DMX_STOP)
+.. c:function:: int ioctl( int fd, int request = DMX_STOP)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/fe-diseqc-recv-slave-reply.rst b/Documentation/media/uapi/dvb/fe-diseqc-recv-slave-reply.rst
index 7b32566b77a3..7bf1145b58a8 100644
--- a/Documentation/media/uapi/dvb/fe-diseqc-recv-slave-reply.rst
+++ b/Documentation/media/uapi/dvb/fe-diseqc-recv-slave-reply.rst
@@ -15,7 +15,7 @@ FE_DISEQC_RECV_SLAVE_REPLY - Receives reply from a DiSEqC 2.0 command
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct dvb_diseqc_slave_reply *argp )
+.. c:function:: int ioctl( int fd, int request, struct dvb_diseqc_slave_reply *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/fe-diseqc-reset-overload.rst b/Documentation/media/uapi/dvb/fe-diseqc-reset-overload.rst
index cab157054c13..13bac53bd248 100644
--- a/Documentation/media/uapi/dvb/fe-diseqc-reset-overload.rst
+++ b/Documentation/media/uapi/dvb/fe-diseqc-reset-overload.rst
@@ -15,7 +15,7 @@ FE_DISEQC_RESET_OVERLOAD - Restores the power to the antenna subsystem, if it wa
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, NULL )
+.. c:function:: int ioctl( int fd, int request, NULL )
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/fe-diseqc-send-burst.rst b/Documentation/media/uapi/dvb/fe-diseqc-send-burst.rst
index 9b476545ef89..d1e9f31ff347 100644
--- a/Documentation/media/uapi/dvb/fe-diseqc-send-burst.rst
+++ b/Documentation/media/uapi/dvb/fe-diseqc-send-burst.rst
@@ -15,7 +15,7 @@ FE_DISEQC_SEND_BURST - Sends a 22KHz tone burst for 2x1 mini DiSEqC satellite se
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, enum fe_sec_mini_cmd *tone )
+.. c:function:: int ioctl( int fd, int request, enum fe_sec_mini_cmd *tone )
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/fe-diseqc-send-master-cmd.rst b/Documentation/media/uapi/dvb/fe-diseqc-send-master-cmd.rst
index 865914bf4efe..3b27d9cc544d 100644
--- a/Documentation/media/uapi/dvb/fe-diseqc-send-master-cmd.rst
+++ b/Documentation/media/uapi/dvb/fe-diseqc-send-master-cmd.rst
@@ -15,7 +15,7 @@ FE_DISEQC_SEND_MASTER_CMD - Sends a DiSEqC command
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct dvb_diseqc_master_cmd *argp )
+.. c:function:: int ioctl( int fd, int request, struct dvb_diseqc_master_cmd *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/fe-dishnetwork-send-legacy-cmd.rst b/Documentation/media/uapi/dvb/fe-dishnetwork-send-legacy-cmd.rst
index d47e9dbf558a..5ebab0ef9138 100644
--- a/Documentation/media/uapi/dvb/fe-dishnetwork-send-legacy-cmd.rst
+++ b/Documentation/media/uapi/dvb/fe-dishnetwork-send-legacy-cmd.rst
@@ -15,7 +15,7 @@ FE_DISHNETWORK_SEND_LEGACY_CMD
 Synopsis
 ========
 
-.. cpp:function:: int  ioctl(int fd, int request = FE_DISHNETWORK_SEND_LEGACY_CMD, unsigned long cmd)
+.. c:function:: int  ioctl(int fd, int request = FE_DISHNETWORK_SEND_LEGACY_CMD, unsigned long cmd)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/fe-enable-high-lnb-voltage.rst b/Documentation/media/uapi/dvb/fe-enable-high-lnb-voltage.rst
index de99bf5fbf0e..a485bf259ed2 100644
--- a/Documentation/media/uapi/dvb/fe-enable-high-lnb-voltage.rst
+++ b/Documentation/media/uapi/dvb/fe-enable-high-lnb-voltage.rst
@@ -15,7 +15,7 @@ FE_ENABLE_HIGH_LNB_VOLTAGE - Select output DC level between normal LNBf voltages
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, unsigned int high )
+.. c:function:: int ioctl( int fd, int request, unsigned int high )
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/fe-get-event.rst b/Documentation/media/uapi/dvb/fe-get-event.rst
index ffa3d04c6bd4..79beb1b9da3b 100644
--- a/Documentation/media/uapi/dvb/fe-get-event.rst
+++ b/Documentation/media/uapi/dvb/fe-get-event.rst
@@ -15,7 +15,7 @@ FE_GET_EVENT
 Synopsis
 ========
 
-.. cpp:function:: int  ioctl(int fd, int request = QPSK_GET_EVENT, struct dvb_frontend_event *ev)
+.. c:function:: int  ioctl(int fd, int request = QPSK_GET_EVENT, struct dvb_frontend_event *ev)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/fe-get-frontend.rst b/Documentation/media/uapi/dvb/fe-get-frontend.rst
index 5d2df808df18..fdf0d1440add 100644
--- a/Documentation/media/uapi/dvb/fe-get-frontend.rst
+++ b/Documentation/media/uapi/dvb/fe-get-frontend.rst
@@ -15,7 +15,7 @@ FE_GET_FRONTEND
 Synopsis
 ========
 
-.. cpp:function:: int ioctl(int fd, int request = FE_GET_FRONTEND, struct dvb_frontend_parameters *p)
+.. c:function:: int ioctl(int fd, int request = FE_GET_FRONTEND, struct dvb_frontend_parameters *p)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/fe-get-info.rst b/Documentation/media/uapi/dvb/fe-get-info.rst
index 87ff3f62050d..8768179cb812 100644
--- a/Documentation/media/uapi/dvb/fe-get-info.rst
+++ b/Documentation/media/uapi/dvb/fe-get-info.rst
@@ -15,7 +15,7 @@ FE_GET_INFO - Query DVB frontend capabilities and returns information about the
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct dvb_frontend_info *argp )
+.. c:function:: int ioctl( int fd, int request, struct dvb_frontend_info *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/fe-get-property.rst b/Documentation/media/uapi/dvb/fe-get-property.rst
index 749daafe6b21..12042c7ae693 100644
--- a/Documentation/media/uapi/dvb/fe-get-property.rst
+++ b/Documentation/media/uapi/dvb/fe-get-property.rst
@@ -15,7 +15,7 @@ FE_SET_PROPERTY - FE_GET_PROPERTY - FE_SET_PROPERTY sets one or more frontend pr
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct dtv_properties *argp )
+.. c:function:: int ioctl( int fd, int request, struct dtv_properties *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/fe-read-ber.rst b/Documentation/media/uapi/dvb/fe-read-ber.rst
index c2b5b417f5fb..3262441385ff 100644
--- a/Documentation/media/uapi/dvb/fe-read-ber.rst
+++ b/Documentation/media/uapi/dvb/fe-read-ber.rst
@@ -14,7 +14,7 @@ FE_READ_BER
 Synopsis
 ========
 
-.. cpp:function:: int  ioctl(int fd, int request = FE_READ_BER, uint32_t *ber)
+.. c:function:: int  ioctl(int fd, int request = FE_READ_BER, uint32_t *ber)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/fe-read-signal-strength.rst b/Documentation/media/uapi/dvb/fe-read-signal-strength.rst
index 0cdee2effc97..fcaadcb537fb 100644
--- a/Documentation/media/uapi/dvb/fe-read-signal-strength.rst
+++ b/Documentation/media/uapi/dvb/fe-read-signal-strength.rst
@@ -15,7 +15,7 @@ FE_READ_SIGNAL_STRENGTH
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request = FE_READ_SIGNAL_STRENGTH, uint16_t *strength)
+.. c:function:: int ioctl( int fd, int request = FE_READ_SIGNAL_STRENGTH, uint16_t *strength)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/fe-read-snr.rst b/Documentation/media/uapi/dvb/fe-read-snr.rst
index 5394f9ae90f4..837af2de9f6f 100644
--- a/Documentation/media/uapi/dvb/fe-read-snr.rst
+++ b/Documentation/media/uapi/dvb/fe-read-snr.rst
@@ -15,7 +15,7 @@ FE_READ_SNR
 Synopsis
 ========
 
-.. cpp:function:: int  ioctl(int fd, int request = FE_READ_SNR, int16_t *snr)
+.. c:function:: int  ioctl(int fd, int request = FE_READ_SNR, int16_t *snr)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/fe-read-status.rst b/Documentation/media/uapi/dvb/fe-read-status.rst
index def8160d6807..b00bdc8a2e04 100644
--- a/Documentation/media/uapi/dvb/fe-read-status.rst
+++ b/Documentation/media/uapi/dvb/fe-read-status.rst
@@ -15,7 +15,7 @@ FE_READ_STATUS - Returns status information about the front-end. This call only
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, unsigned int *status )
+.. c:function:: int ioctl( int fd, int request, unsigned int *status )
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/fe-read-uncorrected-blocks.rst b/Documentation/media/uapi/dvb/fe-read-uncorrected-blocks.rst
index 5c29c058dfdc..6b753846a008 100644
--- a/Documentation/media/uapi/dvb/fe-read-uncorrected-blocks.rst
+++ b/Documentation/media/uapi/dvb/fe-read-uncorrected-blocks.rst
@@ -15,7 +15,7 @@ FE_READ_UNCORRECTED_BLOCKS
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request =FE_READ_UNCORRECTED_BLOCKS, uint32_t *ublocks)
+.. c:function:: int ioctl( int fd, int request =FE_READ_UNCORRECTED_BLOCKS, uint32_t *ublocks)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/fe-set-frontend-tune-mode.rst b/Documentation/media/uapi/dvb/fe-set-frontend-tune-mode.rst
index 411abcf4de58..4461aeb46ebb 100644
--- a/Documentation/media/uapi/dvb/fe-set-frontend-tune-mode.rst
+++ b/Documentation/media/uapi/dvb/fe-set-frontend-tune-mode.rst
@@ -15,7 +15,7 @@ FE_SET_FRONTEND_TUNE_MODE - Allow setting tuner mode flags to the frontend.
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, unsigned int flags )
+.. c:function:: int ioctl( int fd, int request, unsigned int flags )
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/fe-set-frontend.rst b/Documentation/media/uapi/dvb/fe-set-frontend.rst
index 7cb70c38d534..4e66da0af6fd 100644
--- a/Documentation/media/uapi/dvb/fe-set-frontend.rst
+++ b/Documentation/media/uapi/dvb/fe-set-frontend.rst
@@ -15,7 +15,7 @@ FE_SET_FRONTEND
 Synopsis
 ========
 
-.. cpp:function:: int ioctl(int fd, int request = FE_SET_FRONTEND, struct dvb_frontend_parameters *p)
+.. c:function:: int ioctl(int fd, int request = FE_SET_FRONTEND, struct dvb_frontend_parameters *p)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/fe-set-tone.rst b/Documentation/media/uapi/dvb/fe-set-tone.rst
index 545e2afba2c0..a00fcaadecd1 100644
--- a/Documentation/media/uapi/dvb/fe-set-tone.rst
+++ b/Documentation/media/uapi/dvb/fe-set-tone.rst
@@ -15,7 +15,7 @@ FE_SET_TONE - Sets/resets the generation of the continuous 22kHz tone.
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, enum fe_sec_tone_mode *tone )
+.. c:function:: int ioctl( int fd, int request, enum fe_sec_tone_mode *tone )
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/fe-set-voltage.rst b/Documentation/media/uapi/dvb/fe-set-voltage.rst
index 2b19086b660a..05baf77e0301 100644
--- a/Documentation/media/uapi/dvb/fe-set-voltage.rst
+++ b/Documentation/media/uapi/dvb/fe-set-voltage.rst
@@ -15,7 +15,7 @@ FE_SET_VOLTAGE - Allow setting the DC level sent to the antenna subsystem.
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, enum fe_sec_voltage *voltage )
+.. c:function:: int ioctl( int fd, int request, enum fe_sec_voltage *voltage )
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/frontend_f_close.rst b/Documentation/media/uapi/dvb/frontend_f_close.rst
index 5cce9262084c..8746eec2b97d 100644
--- a/Documentation/media/uapi/dvb/frontend_f_close.rst
+++ b/Documentation/media/uapi/dvb/frontend_f_close.rst
@@ -20,7 +20,7 @@ Synopsis
     #include <unistd.h>
 
 
-.. cpp:function:: int close( int fd )
+.. c:function:: int close( int fd )
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/frontend_f_open.rst b/Documentation/media/uapi/dvb/frontend_f_open.rst
index e0c55345f524..5810e96abf89 100644
--- a/Documentation/media/uapi/dvb/frontend_f_open.rst
+++ b/Documentation/media/uapi/dvb/frontend_f_open.rst
@@ -20,7 +20,7 @@ Synopsis
     #include <fcntl.h>
 
 
-.. cpp:function:: int open( const char *device_name, int flags )
+.. c:function:: int open( const char *device_name, int flags )
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/net-add-if.rst b/Documentation/media/uapi/dvb/net-add-if.rst
index 2b990d0e0fe1..ebde02b9a3ec 100644
--- a/Documentation/media/uapi/dvb/net-add-if.rst
+++ b/Documentation/media/uapi/dvb/net-add-if.rst
@@ -15,7 +15,7 @@ NET_ADD_IF - Creates a new network interface for a given Packet ID.
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct dvb_net_if *net_if )
+.. c:function:: int ioctl( int fd, int request, struct dvb_net_if *net_if )
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/net-get-if.rst b/Documentation/media/uapi/dvb/net-get-if.rst
index 92b884143ccd..17cfcda22da3 100644
--- a/Documentation/media/uapi/dvb/net-get-if.rst
+++ b/Documentation/media/uapi/dvb/net-get-if.rst
@@ -15,7 +15,7 @@ NET_GET_IF - Read the configuration data of an interface created via - :ref:`NET
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct dvb_net_if *net_if )
+.. c:function:: int ioctl( int fd, int request, struct dvb_net_if *net_if )
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/net-remove-if.rst b/Documentation/media/uapi/dvb/net-remove-if.rst
index d374c1d63d06..447dd4299965 100644
--- a/Documentation/media/uapi/dvb/net-remove-if.rst
+++ b/Documentation/media/uapi/dvb/net-remove-if.rst
@@ -15,7 +15,7 @@ NET_REMOVE_IF - Removes a network interface.
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, int ifnum )
+.. c:function:: int ioctl( int fd, int request, int ifnum )
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-clear-buffer.rst b/Documentation/media/uapi/dvb/video-clear-buffer.rst
index 7c85aa06f013..dd227ad85546 100644
--- a/Documentation/media/uapi/dvb/video-clear-buffer.rst
+++ b/Documentation/media/uapi/dvb/video-clear-buffer.rst
@@ -15,7 +15,7 @@ VIDEO_CLEAR_BUFFER
 Synopsis
 --------
 
-.. cpp:function:: int ioctl(fd, int request = VIDEO_CLEAR_BUFFER)
+.. c:function:: int ioctl(fd, int request = VIDEO_CLEAR_BUFFER)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-command.rst b/Documentation/media/uapi/dvb/video-command.rst
index b1634f722cbd..42a98a47e323 100644
--- a/Documentation/media/uapi/dvb/video-command.rst
+++ b/Documentation/media/uapi/dvb/video-command.rst
@@ -15,7 +15,7 @@ VIDEO_COMMAND
 Synopsis
 --------
 
-.. cpp:function:: int ioctl(int fd, int request = VIDEO_COMMAND, struct video_command *cmd)
+.. c:function:: int ioctl(int fd, int request = VIDEO_COMMAND, struct video_command *cmd)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-continue.rst b/Documentation/media/uapi/dvb/video-continue.rst
index c5acc094986f..2a6444a4f4dc 100644
--- a/Documentation/media/uapi/dvb/video-continue.rst
+++ b/Documentation/media/uapi/dvb/video-continue.rst
@@ -15,7 +15,7 @@ VIDEO_CONTINUE
 Synopsis
 --------
 
-.. cpp:function:: int ioctl(fd, int request = VIDEO_CONTINUE)
+.. c:function:: int ioctl(fd, int request = VIDEO_CONTINUE)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-fast-forward.rst b/Documentation/media/uapi/dvb/video-fast-forward.rst
index db338e9f5379..0b3a27a22d30 100644
--- a/Documentation/media/uapi/dvb/video-fast-forward.rst
+++ b/Documentation/media/uapi/dvb/video-fast-forward.rst
@@ -15,7 +15,7 @@ VIDEO_FAST_FORWARD
 Synopsis
 --------
 
-.. cpp:function:: int ioctl(fd, int request = VIDEO_FAST_FORWARD, int nFrames)
+.. c:function:: int ioctl(fd, int request = VIDEO_FAST_FORWARD, int nFrames)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-fclose.rst b/Documentation/media/uapi/dvb/video-fclose.rst
index ebeaade0c351..b4dd5ea676b9 100644
--- a/Documentation/media/uapi/dvb/video-fclose.rst
+++ b/Documentation/media/uapi/dvb/video-fclose.rst
@@ -15,7 +15,7 @@ dvb video close()
 Synopsis
 --------
 
-.. cpp:function:: int close(int fd)
+.. c:function:: int close(int fd)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-fopen.rst b/Documentation/media/uapi/dvb/video-fopen.rst
index 9addca95516e..5b73ca9f7bed 100644
--- a/Documentation/media/uapi/dvb/video-fopen.rst
+++ b/Documentation/media/uapi/dvb/video-fopen.rst
@@ -15,7 +15,7 @@ dvb video open()
 Synopsis
 --------
 
-.. cpp:function:: int open(const char *deviceName, int flags)
+.. c:function:: int open(const char *deviceName, int flags)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-freeze.rst b/Documentation/media/uapi/dvb/video-freeze.rst
index d3d0dc31281a..12e04df990b7 100644
--- a/Documentation/media/uapi/dvb/video-freeze.rst
+++ b/Documentation/media/uapi/dvb/video-freeze.rst
@@ -15,7 +15,7 @@ VIDEO_FREEZE
 Synopsis
 --------
 
-.. cpp:function:: int ioctl(fd, int request = VIDEO_FREEZE)
+.. c:function:: int ioctl(fd, int request = VIDEO_FREEZE)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-fwrite.rst b/Documentation/media/uapi/dvb/video-fwrite.rst
index 045038f4181e..da03db4be8de 100644
--- a/Documentation/media/uapi/dvb/video-fwrite.rst
+++ b/Documentation/media/uapi/dvb/video-fwrite.rst
@@ -15,7 +15,7 @@ dvb video write()
 Synopsis
 --------
 
-.. cpp:function:: size_t write(int fd, const void *buf, size_t count)
+.. c:function:: size_t write(int fd, const void *buf, size_t count)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-get-capabilities.rst b/Documentation/media/uapi/dvb/video-get-capabilities.rst
index 94cbbba478a8..5515dd40a1c1 100644
--- a/Documentation/media/uapi/dvb/video-get-capabilities.rst
+++ b/Documentation/media/uapi/dvb/video-get-capabilities.rst
@@ -15,7 +15,7 @@ VIDEO_GET_CAPABILITIES
 Synopsis
 --------
 
-.. cpp:function:: int ioctl(fd, int request = VIDEO_GET_CAPABILITIES, unsigned int *cap)
+.. c:function:: int ioctl(fd, int request = VIDEO_GET_CAPABILITIES, unsigned int *cap)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-get-event.rst b/Documentation/media/uapi/dvb/video-get-event.rst
index a1484a226518..d43459915179 100644
--- a/Documentation/media/uapi/dvb/video-get-event.rst
+++ b/Documentation/media/uapi/dvb/video-get-event.rst
@@ -15,7 +15,7 @@ VIDEO_GET_EVENT
 Synopsis
 --------
 
-.. cpp:function:: int ioctl(fd, int request = VIDEO_GET_EVENT, struct video_event *ev)
+.. c:function:: int ioctl(fd, int request = VIDEO_GET_EVENT, struct video_event *ev)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-get-frame-count.rst b/Documentation/media/uapi/dvb/video-get-frame-count.rst
index 4ff100c2ee95..a55f7a1d52ac 100644
--- a/Documentation/media/uapi/dvb/video-get-frame-count.rst
+++ b/Documentation/media/uapi/dvb/video-get-frame-count.rst
@@ -15,7 +15,7 @@ VIDEO_GET_FRAME_COUNT
 Synopsis
 --------
 
-.. cpp:function:: int ioctl(int fd, int request = VIDEO_GET_FRAME_COUNT, __u64 *pts)
+.. c:function:: int ioctl(int fd, int request = VIDEO_GET_FRAME_COUNT, __u64 *pts)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-get-frame-rate.rst b/Documentation/media/uapi/dvb/video-get-frame-rate.rst
index 131def962305..a137b6589599 100644
--- a/Documentation/media/uapi/dvb/video-get-frame-rate.rst
+++ b/Documentation/media/uapi/dvb/video-get-frame-rate.rst
@@ -15,7 +15,7 @@ VIDEO_GET_FRAME_RATE
 Synopsis
 --------
 
-.. cpp:function:: int ioctl(int fd, int request = VIDEO_GET_FRAME_RATE, unsigned int *rate)
+.. c:function:: int ioctl(int fd, int request = VIDEO_GET_FRAME_RATE, unsigned int *rate)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-get-navi.rst b/Documentation/media/uapi/dvb/video-get-navi.rst
index 6c3034fe5fa2..ccb2552722f0 100644
--- a/Documentation/media/uapi/dvb/video-get-navi.rst
+++ b/Documentation/media/uapi/dvb/video-get-navi.rst
@@ -15,7 +15,7 @@ VIDEO_GET_NAVI
 Synopsis
 --------
 
-.. cpp:function:: int ioctl(fd, int request = VIDEO_GET_NAVI , video_navi_pack_t *navipack)
+.. c:function:: int ioctl(fd, int request = VIDEO_GET_NAVI , video_navi_pack_t *navipack)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-get-pts.rst b/Documentation/media/uapi/dvb/video-get-pts.rst
index 082612243bbb..c1ad9576963d 100644
--- a/Documentation/media/uapi/dvb/video-get-pts.rst
+++ b/Documentation/media/uapi/dvb/video-get-pts.rst
@@ -15,7 +15,7 @@ VIDEO_GET_PTS
 Synopsis
 --------
 
-.. cpp:function:: int ioctl(int fd, int request = VIDEO_GET_PTS, __u64 *pts)
+.. c:function:: int ioctl(int fd, int request = VIDEO_GET_PTS, __u64 *pts)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-get-size.rst b/Documentation/media/uapi/dvb/video-get-size.rst
index c75e3c47c471..70fb266e3ed8 100644
--- a/Documentation/media/uapi/dvb/video-get-size.rst
+++ b/Documentation/media/uapi/dvb/video-get-size.rst
@@ -15,7 +15,7 @@ VIDEO_GET_SIZE
 Synopsis
 --------
 
-.. cpp:function:: int ioctl(int fd, int request = VIDEO_GET_SIZE, video_size_t *size)
+.. c:function:: int ioctl(int fd, int request = VIDEO_GET_SIZE, video_size_t *size)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-get-status.rst b/Documentation/media/uapi/dvb/video-get-status.rst
index ab9c2236df7e..5fd5b37942ec 100644
--- a/Documentation/media/uapi/dvb/video-get-status.rst
+++ b/Documentation/media/uapi/dvb/video-get-status.rst
@@ -15,7 +15,7 @@ VIDEO_GET_STATUS
 Synopsis
 --------
 
-.. cpp:function:: int ioctl(fd, int request = VIDEO_GET_STATUS, struct video_status *status)
+.. c:function:: int ioctl(fd, int request = VIDEO_GET_STATUS, struct video_status *status)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-play.rst b/Documentation/media/uapi/dvb/video-play.rst
index 943c4b755372..103d0ad3341a 100644
--- a/Documentation/media/uapi/dvb/video-play.rst
+++ b/Documentation/media/uapi/dvb/video-play.rst
@@ -15,7 +15,7 @@ VIDEO_PLAY
 Synopsis
 --------
 
-.. cpp:function:: int ioctl(fd, int request = VIDEO_PLAY)
+.. c:function:: int ioctl(fd, int request = VIDEO_PLAY)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-select-source.rst b/Documentation/media/uapi/dvb/video-select-source.rst
index 0ee0d03dbeb2..f03c544668f5 100644
--- a/Documentation/media/uapi/dvb/video-select-source.rst
+++ b/Documentation/media/uapi/dvb/video-select-source.rst
@@ -15,7 +15,7 @@ VIDEO_SELECT_SOURCE
 Synopsis
 --------
 
-.. cpp:function:: int ioctl(fd, int request = VIDEO_SELECT_SOURCE, video_stream_source_t source)
+.. c:function:: int ioctl(fd, int request = VIDEO_SELECT_SOURCE, video_stream_source_t source)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-set-attributes.rst b/Documentation/media/uapi/dvb/video-set-attributes.rst
index 326c5c876e80..9de0d9c7c9ca 100644
--- a/Documentation/media/uapi/dvb/video-set-attributes.rst
+++ b/Documentation/media/uapi/dvb/video-set-attributes.rst
@@ -15,7 +15,7 @@ VIDEO_SET_ATTRIBUTES
 Synopsis
 --------
 
-.. cpp:function:: int ioctl(fd, int request = VIDEO_SET_ATTRIBUTE ,video_attributes_t vattr)
+.. c:function:: int ioctl(fd, int request = VIDEO_SET_ATTRIBUTE ,video_attributes_t vattr)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-set-blank.rst b/Documentation/media/uapi/dvb/video-set-blank.rst
index 142ea8817380..d8b94c9b56b9 100644
--- a/Documentation/media/uapi/dvb/video-set-blank.rst
+++ b/Documentation/media/uapi/dvb/video-set-blank.rst
@@ -15,7 +15,7 @@ VIDEO_SET_BLANK
 Synopsis
 --------
 
-.. cpp:function:: int ioctl(fd, int request = VIDEO_SET_BLANK, boolean mode)
+.. c:function:: int ioctl(fd, int request = VIDEO_SET_BLANK, boolean mode)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-set-display-format.rst b/Documentation/media/uapi/dvb/video-set-display-format.rst
index 2061ab064977..c1fb7c75b4a8 100644
--- a/Documentation/media/uapi/dvb/video-set-display-format.rst
+++ b/Documentation/media/uapi/dvb/video-set-display-format.rst
@@ -15,7 +15,7 @@ VIDEO_SET_DISPLAY_FORMAT
 Synopsis
 --------
 
-.. cpp:function:: int ioctl(fd, int request = VIDEO_SET_DISPLAY_FORMAT, video_display_format_t format)
+.. c:function:: int ioctl(fd, int request = VIDEO_SET_DISPLAY_FORMAT, video_display_format_t format)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-set-format.rst b/Documentation/media/uapi/dvb/video-set-format.rst
index 53d66ec462ca..257a3c2a4627 100644
--- a/Documentation/media/uapi/dvb/video-set-format.rst
+++ b/Documentation/media/uapi/dvb/video-set-format.rst
@@ -15,7 +15,7 @@ VIDEO_SET_FORMAT
 Synopsis
 --------
 
-.. cpp:function:: int ioctl(fd, int request = VIDEO_SET_FORMAT, video_format_t format)
+.. c:function:: int ioctl(fd, int request = VIDEO_SET_FORMAT, video_format_t format)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-set-highlight.rst b/Documentation/media/uapi/dvb/video-set-highlight.rst
index 374f5d895b4d..6ff11af71355 100644
--- a/Documentation/media/uapi/dvb/video-set-highlight.rst
+++ b/Documentation/media/uapi/dvb/video-set-highlight.rst
@@ -15,7 +15,7 @@ VIDEO_SET_HIGHLIGHT
 Synopsis
 --------
 
-.. cpp:function:: int ioctl(fd, int request = VIDEO_SET_HIGHLIGHT ,video_highlight_t *vhilite)
+.. c:function:: int ioctl(fd, int request = VIDEO_SET_HIGHLIGHT ,video_highlight_t *vhilite)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-set-id.rst b/Documentation/media/uapi/dvb/video-set-id.rst
index 9c002d5399ad..61993ab354ca 100644
--- a/Documentation/media/uapi/dvb/video-set-id.rst
+++ b/Documentation/media/uapi/dvb/video-set-id.rst
@@ -15,7 +15,7 @@ VIDEO_SET_ID
 Synopsis
 --------
 
-.. cpp:function:: int ioctl(int fd, int request = VIDEO_SET_ID, int id)
+.. c:function:: int ioctl(int fd, int request = VIDEO_SET_ID, int id)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-set-spu-palette.rst b/Documentation/media/uapi/dvb/video-set-spu-palette.rst
index 4b80b6f56219..ae9e0da5fd0b 100644
--- a/Documentation/media/uapi/dvb/video-set-spu-palette.rst
+++ b/Documentation/media/uapi/dvb/video-set-spu-palette.rst
@@ -15,7 +15,7 @@ VIDEO_SET_SPU_PALETTE
 Synopsis
 --------
 
-.. cpp:function:: int ioctl(fd, int request = VIDEO_SET_SPU_PALETTE, video_spu_palette_t *palette )
+.. c:function:: int ioctl(fd, int request = VIDEO_SET_SPU_PALETTE, video_spu_palette_t *palette )
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-set-spu.rst b/Documentation/media/uapi/dvb/video-set-spu.rst
index a6f6924f10c4..ce2860574f20 100644
--- a/Documentation/media/uapi/dvb/video-set-spu.rst
+++ b/Documentation/media/uapi/dvb/video-set-spu.rst
@@ -15,7 +15,7 @@ VIDEO_SET_SPU
 Synopsis
 --------
 
-.. cpp:function:: int ioctl(fd, int request = VIDEO_SET_SPU , video_spu_t *spu)
+.. c:function:: int ioctl(fd, int request = VIDEO_SET_SPU , video_spu_t *spu)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-set-streamtype.rst b/Documentation/media/uapi/dvb/video-set-streamtype.rst
index 75b2e7a6e829..a2055369f0cd 100644
--- a/Documentation/media/uapi/dvb/video-set-streamtype.rst
+++ b/Documentation/media/uapi/dvb/video-set-streamtype.rst
@@ -15,7 +15,7 @@ VIDEO_SET_STREAMTYPE
 Synopsis
 --------
 
-.. cpp:function:: int ioctl(fd, int request = VIDEO_SET_STREAMTYPE, int type)
+.. c:function:: int ioctl(fd, int request = VIDEO_SET_STREAMTYPE, int type)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-set-system.rst b/Documentation/media/uapi/dvb/video-set-system.rst
index 9ae0df1f5813..f84906a7d1f4 100644
--- a/Documentation/media/uapi/dvb/video-set-system.rst
+++ b/Documentation/media/uapi/dvb/video-set-system.rst
@@ -15,7 +15,7 @@ VIDEO_SET_SYSTEM
 Synopsis
 --------
 
-.. cpp:function:: int ioctl(fd, int request = VIDEO_SET_SYSTEM , video_system_t system)
+.. c:function:: int ioctl(fd, int request = VIDEO_SET_SYSTEM , video_system_t system)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-slowmotion.rst b/Documentation/media/uapi/dvb/video-slowmotion.rst
index 905712844f6a..c8cc85af590b 100644
--- a/Documentation/media/uapi/dvb/video-slowmotion.rst
+++ b/Documentation/media/uapi/dvb/video-slowmotion.rst
@@ -15,7 +15,7 @@ VIDEO_SLOWMOTION
 Synopsis
 --------
 
-.. cpp:function:: int ioctl(fd, int request = VIDEO_SLOWMOTION, int nFrames)
+.. c:function:: int ioctl(fd, int request = VIDEO_SLOWMOTION, int nFrames)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-stillpicture.rst b/Documentation/media/uapi/dvb/video-stillpicture.rst
index ed3a2f53b998..053cdbba4ed4 100644
--- a/Documentation/media/uapi/dvb/video-stillpicture.rst
+++ b/Documentation/media/uapi/dvb/video-stillpicture.rst
@@ -15,7 +15,7 @@ VIDEO_STILLPICTURE
 Synopsis
 --------
 
-.. cpp:function:: int ioctl(fd, int request = VIDEO_STILLPICTURE, struct video_still_picture *sp)
+.. c:function:: int ioctl(fd, int request = VIDEO_STILLPICTURE, struct video_still_picture *sp)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-stop.rst b/Documentation/media/uapi/dvb/video-stop.rst
index ad8d59e06004..4e7fbab4b8bc 100644
--- a/Documentation/media/uapi/dvb/video-stop.rst
+++ b/Documentation/media/uapi/dvb/video-stop.rst
@@ -15,7 +15,7 @@ VIDEO_STOP
 Synopsis
 --------
 
-.. cpp:function:: int ioctl(fd, int request = VIDEO_STOP, boolean mode)
+.. c:function:: int ioctl(fd, int request = VIDEO_STOP, boolean mode)
 
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/video-try-command.rst b/Documentation/media/uapi/dvb/video-try-command.rst
index df96c2d7fc6b..be21fb01bd0f 100644
--- a/Documentation/media/uapi/dvb/video-try-command.rst
+++ b/Documentation/media/uapi/dvb/video-try-command.rst
@@ -15,7 +15,7 @@ VIDEO_TRY_COMMAND
 Synopsis
 --------
 
-.. cpp:function:: int ioctl(int fd, int request = VIDEO_TRY_COMMAND, struct video_command *cmd)
+.. c:function:: int ioctl(int fd, int request = VIDEO_TRY_COMMAND, struct video_command *cmd)
 
 
 Arguments
diff --git a/Documentation/media/uapi/mediactl/media-func-close.rst b/Documentation/media/uapi/mediactl/media-func-close.rst
index 39ef70ac8656..c13220c2696e 100644
--- a/Documentation/media/uapi/mediactl/media-func-close.rst
+++ b/Documentation/media/uapi/mediactl/media-func-close.rst
@@ -20,7 +20,7 @@ Synopsis
     #include <unistd.h>
 
 
-.. cpp:function:: int close( int fd )
+.. c:function:: int close( int fd )
 
 
 Arguments
diff --git a/Documentation/media/uapi/mediactl/media-func-ioctl.rst b/Documentation/media/uapi/mediactl/media-func-ioctl.rst
index 9d1b23133edf..6fa0a8e65af5 100644
--- a/Documentation/media/uapi/mediactl/media-func-ioctl.rst
+++ b/Documentation/media/uapi/mediactl/media-func-ioctl.rst
@@ -20,7 +20,7 @@ Synopsis
     #include <sys/ioctl.h>
 
 
-.. cpp:function:: int ioctl( int fd, int request, void *argp )
+.. c:function:: int ioctl( int fd, int request, void *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/mediactl/media-func-open.rst b/Documentation/media/uapi/mediactl/media-func-open.rst
index 2b2ecd85b995..aa77ba32db21 100644
--- a/Documentation/media/uapi/mediactl/media-func-open.rst
+++ b/Documentation/media/uapi/mediactl/media-func-open.rst
@@ -20,7 +20,7 @@ Synopsis
     #include <fcntl.h>
 
 
-.. cpp:function:: int open( const char *device_name, int flags )
+.. c:function:: int open( const char *device_name, int flags )
 
 
 Arguments
diff --git a/Documentation/media/uapi/mediactl/media-ioc-device-info.rst b/Documentation/media/uapi/mediactl/media-ioc-device-info.rst
index 567f5515a791..e8c97abed394 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-device-info.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-device-info.rst
@@ -15,7 +15,7 @@ MEDIA_IOC_DEVICE_INFO - Query device information
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct media_device_info *argp )
+.. c:function:: int ioctl( int fd, int request, struct media_device_info *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst b/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst
index a51c4cc9f6d3..a621b08187ea 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst
@@ -15,7 +15,7 @@ MEDIA_IOC_ENUM_ENTITIES - Enumerate entities and their properties
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct media_entity_desc *argp )
+.. c:function:: int ioctl( int fd, int request, struct media_entity_desc *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst b/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst
index f4334f5765c6..d07629ba44db 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst
@@ -15,7 +15,7 @@ MEDIA_IOC_ENUM_LINKS - Enumerate all pads and links for a given entity
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct media_links_enum *argp )
+.. c:function:: int ioctl( int fd, int request, struct media_links_enum *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
index c836d64df03b..d01a4528cb47 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
@@ -15,7 +15,7 @@ MEDIA_IOC_G_TOPOLOGY - Enumerate the graph topology and graph element properties
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct media_v2_topology *argp )
+.. c:function:: int ioctl( int fd, int request, struct media_v2_topology *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/mediactl/media-ioc-setup-link.rst b/Documentation/media/uapi/mediactl/media-ioc-setup-link.rst
index e02fe23de9de..10be4c546f33 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-setup-link.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-setup-link.rst
@@ -15,7 +15,7 @@ MEDIA_IOC_SETUP_LINK - Modify the properties of a link
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct media_link_desc *argp )
+.. c:function:: int ioctl( int fd, int request, struct media_link_desc *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/rc/lirc-get-features.rst b/Documentation/media/uapi/rc/lirc-get-features.rst
index e763ebfb2cb1..d0c8a426aa16 100644
--- a/Documentation/media/uapi/rc/lirc-get-features.rst
+++ b/Documentation/media/uapi/rc/lirc-get-features.rst
@@ -14,7 +14,7 @@ LIRC_GET_FEATURES - Get the underlying hardware device's features
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, __u32 *features)
+.. c:function:: int ioctl( int fd, int request, __u32 *features)
 
 Arguments
 =========
diff --git a/Documentation/media/uapi/rc/lirc-get-length.rst b/Documentation/media/uapi/rc/lirc-get-length.rst
index d11c3d3f2c06..44c6e8923b40 100644
--- a/Documentation/media/uapi/rc/lirc-get-length.rst
+++ b/Documentation/media/uapi/rc/lirc-get-length.rst
@@ -14,7 +14,7 @@ LIRC_GET_LENGTH - Retrieves the code length in bits.
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, __u32 *length )
+.. c:function:: int ioctl( int fd, int request, __u32 *length )
 
 Arguments
 =========
diff --git a/Documentation/media/uapi/rc/lirc-get-rec-mode.rst b/Documentation/media/uapi/rc/lirc-get-rec-mode.rst
index 586860c36791..445c618771f4 100644
--- a/Documentation/media/uapi/rc/lirc-get-rec-mode.rst
+++ b/Documentation/media/uapi/rc/lirc-get-rec-mode.rst
@@ -15,7 +15,7 @@ LIRC_GET_REC_MODE/LIRC_GET_REC_MODE - Get/set supported receive modes.
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, __u32 rx_modes)
+.. c:function:: int ioctl( int fd, int request, __u32 rx_modes)
 
 Arguments
 =========
diff --git a/Documentation/media/uapi/rc/lirc-get-rec-resolution.rst b/Documentation/media/uapi/rc/lirc-get-rec-resolution.rst
index 6ef1723878b4..3ac3a8199c29 100644
--- a/Documentation/media/uapi/rc/lirc-get-rec-resolution.rst
+++ b/Documentation/media/uapi/rc/lirc-get-rec-resolution.rst
@@ -14,7 +14,7 @@ LIRC_GET_REC_RESOLUTION - Obtain the value of receive resolution, in microsecond
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, __u32 *microseconds)
+.. c:function:: int ioctl( int fd, int request, __u32 *microseconds)
 
 Arguments
 =========
diff --git a/Documentation/media/uapi/rc/lirc-get-send-mode.rst b/Documentation/media/uapi/rc/lirc-get-send-mode.rst
index 3e1d96122ff2..5e40b7bc1c1f 100644
--- a/Documentation/media/uapi/rc/lirc-get-send-mode.rst
+++ b/Documentation/media/uapi/rc/lirc-get-send-mode.rst
@@ -15,7 +15,7 @@ LIRC_GET_SEND_MODE/LIRC_SET_SEND_MODE - Get/set supported transmit mode.
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, __u32 *tx_modes )
+.. c:function:: int ioctl( int fd, int request, __u32 *tx_modes )
 
 Arguments
 =========
diff --git a/Documentation/media/uapi/rc/lirc-get-timeout.rst b/Documentation/media/uapi/rc/lirc-get-timeout.rst
index 6b8238f1f30e..0d103f899350 100644
--- a/Documentation/media/uapi/rc/lirc-get-timeout.rst
+++ b/Documentation/media/uapi/rc/lirc-get-timeout.rst
@@ -16,7 +16,7 @@ range for IR receive.
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, __u32 *timeout)
+.. c:function:: int ioctl( int fd, int request, __u32 *timeout)
 
 Arguments
 =========
diff --git a/Documentation/media/uapi/rc/lirc-read.rst b/Documentation/media/uapi/rc/lirc-read.rst
index 8d4e9b6e507d..c5b5e1db7cad 100644
--- a/Documentation/media/uapi/rc/lirc-read.rst
+++ b/Documentation/media/uapi/rc/lirc-read.rst
@@ -20,7 +20,7 @@ Synopsis
     #include <unistd.h>
 
 
-.. cpp:function:: ssize_t read( int fd, void *buf, size_t count )
+.. c:function:: ssize_t read( int fd, void *buf, size_t count )
 
 
 Arguments
diff --git a/Documentation/media/uapi/rc/lirc-set-measure-carrier-mode.rst b/Documentation/media/uapi/rc/lirc-set-measure-carrier-mode.rst
index e145d9d1902d..ee0b46b44c24 100644
--- a/Documentation/media/uapi/rc/lirc-set-measure-carrier-mode.rst
+++ b/Documentation/media/uapi/rc/lirc-set-measure-carrier-mode.rst
@@ -14,7 +14,7 @@ LIRC_SET_MEASURE_CARRIER_MODE - enable or disable measure mode
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, __u32 *enable )
+.. c:function:: int ioctl( int fd, int request, __u32 *enable )
 
 Arguments
 =========
diff --git a/Documentation/media/uapi/rc/lirc-set-rec-carrier-range.rst b/Documentation/media/uapi/rc/lirc-set-rec-carrier-range.rst
index 7cce9c8ba361..44814a5163e6 100644
--- a/Documentation/media/uapi/rc/lirc-set-rec-carrier-range.rst
+++ b/Documentation/media/uapi/rc/lirc-set-rec-carrier-range.rst
@@ -15,7 +15,7 @@ IR receive.
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, __u32 *frequency )
+.. c:function:: int ioctl( int fd, int request, __u32 *frequency )
 
 Arguments
 =========
diff --git a/Documentation/media/uapi/rc/lirc-set-rec-carrier.rst b/Documentation/media/uapi/rc/lirc-set-rec-carrier.rst
index 17ddb4723caa..c3508b7fd441 100644
--- a/Documentation/media/uapi/rc/lirc-set-rec-carrier.rst
+++ b/Documentation/media/uapi/rc/lirc-set-rec-carrier.rst
@@ -15,7 +15,7 @@ LIRC_SET_REC_CARRIER - Set carrier used to modulate IR receive.
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, __u32 *frequency )
+.. c:function:: int ioctl( int fd, int request, __u32 *frequency )
 
 Arguments
 =========
diff --git a/Documentation/media/uapi/rc/lirc-set-rec-timeout-reports.rst b/Documentation/media/uapi/rc/lirc-set-rec-timeout-reports.rst
index 0c7f85d0ce3b..676e7698b882 100644
--- a/Documentation/media/uapi/rc/lirc-set-rec-timeout-reports.rst
+++ b/Documentation/media/uapi/rc/lirc-set-rec-timeout-reports.rst
@@ -14,7 +14,7 @@ LIRC_SET_REC_TIMEOUT_REPORTS - enable or disable timeout reports for IR receive
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, __u32 *enable )
+.. c:function:: int ioctl( int fd, int request, __u32 *enable )
 
 Arguments
 =========
diff --git a/Documentation/media/uapi/rc/lirc-set-rec-timeout.rst b/Documentation/media/uapi/rc/lirc-set-rec-timeout.rst
index ffc88f9fcd52..f54026a14c4f 100644
--- a/Documentation/media/uapi/rc/lirc-set-rec-timeout.rst
+++ b/Documentation/media/uapi/rc/lirc-set-rec-timeout.rst
@@ -14,7 +14,7 @@ LIRC_SET_REC_TIMEOUT - sets the integer value for IR inactivity timeout.
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, __u32 *timeout )
+.. c:function:: int ioctl( int fd, int request, __u32 *timeout )
 
 Arguments
 =========
diff --git a/Documentation/media/uapi/rc/lirc-set-send-carrier.rst b/Documentation/media/uapi/rc/lirc-set-send-carrier.rst
index 4314d4c86ced..fa4df86d7698 100644
--- a/Documentation/media/uapi/rc/lirc-set-send-carrier.rst
+++ b/Documentation/media/uapi/rc/lirc-set-send-carrier.rst
@@ -15,7 +15,7 @@ LIRC_SET_SEND_CARRIER - Set send carrier used to modulate IR TX.
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, __u32 *frequency )
+.. c:function:: int ioctl( int fd, int request, __u32 *frequency )
 
 Arguments
 =========
diff --git a/Documentation/media/uapi/rc/lirc-set-send-duty-cycle.rst b/Documentation/media/uapi/rc/lirc-set-send-duty-cycle.rst
index 48e7bb15fb69..7a7d2730d727 100644
--- a/Documentation/media/uapi/rc/lirc-set-send-duty-cycle.rst
+++ b/Documentation/media/uapi/rc/lirc-set-send-duty-cycle.rst
@@ -15,7 +15,7 @@ IR transmit.
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, __u32 *duty_cycle)
+.. c:function:: int ioctl( int fd, int request, __u32 *duty_cycle)
 
 Arguments
 =========
diff --git a/Documentation/media/uapi/rc/lirc-set-transmitter-mask.rst b/Documentation/media/uapi/rc/lirc-set-transmitter-mask.rst
index 2b35e21b9bb9..179b835e5b53 100644
--- a/Documentation/media/uapi/rc/lirc-set-transmitter-mask.rst
+++ b/Documentation/media/uapi/rc/lirc-set-transmitter-mask.rst
@@ -14,7 +14,7 @@ LIRC_SET_TRANSMITTER_MASK - Enables send codes on a given set of transmitters
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, __u32 *mask )
+.. c:function:: int ioctl( int fd, int request, __u32 *mask )
 
 Arguments
 =========
diff --git a/Documentation/media/uapi/rc/lirc-set-wideband-receiver.rst b/Documentation/media/uapi/rc/lirc-set-wideband-receiver.rst
index b9d582fd7df1..4a9101be40aa 100644
--- a/Documentation/media/uapi/rc/lirc-set-wideband-receiver.rst
+++ b/Documentation/media/uapi/rc/lirc-set-wideband-receiver.rst
@@ -14,7 +14,7 @@ LIRC_SET_WIDEBAND_RECEIVER - enable wide band receiver.
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, __u32 *enable )
+.. c:function:: int ioctl( int fd, int request, __u32 *enable )
 
 Arguments
 =========
diff --git a/Documentation/media/uapi/rc/lirc-write.rst b/Documentation/media/uapi/rc/lirc-write.rst
index dcba3b1bee6e..631d961813d1 100644
--- a/Documentation/media/uapi/rc/lirc-write.rst
+++ b/Documentation/media/uapi/rc/lirc-write.rst
@@ -20,7 +20,7 @@ Synopsis
     #include <unistd.h>
 
 
-.. cpp:function:: ssize_t write( int fd, void *buf, size_t count )
+.. c:function:: ssize_t write( int fd, void *buf, size_t count )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/func-close.rst b/Documentation/media/uapi/v4l/func-close.rst
index 926a2ccc32e5..148fc009d033 100644
--- a/Documentation/media/uapi/v4l/func-close.rst
+++ b/Documentation/media/uapi/v4l/func-close.rst
@@ -20,7 +20,7 @@ Synopsis
     #include <unistd.h>
 
 
-.. cpp:function:: int close( int fd )
+.. c:function:: int close( int fd )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/func-ioctl.rst b/Documentation/media/uapi/v4l/func-ioctl.rst
index 5632f48fce1b..c207f0727cf1 100644
--- a/Documentation/media/uapi/v4l/func-ioctl.rst
+++ b/Documentation/media/uapi/v4l/func-ioctl.rst
@@ -20,7 +20,7 @@ Synopsis
     #include <sys/ioctl.h>
 
 
-.. cpp:function:: int ioctl( int fd, int request, void *argp )
+.. c:function:: int ioctl( int fd, int request, void *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/func-mmap.rst b/Documentation/media/uapi/v4l/func-mmap.rst
index 639fef5b4f78..e30b2981028f 100644
--- a/Documentation/media/uapi/v4l/func-mmap.rst
+++ b/Documentation/media/uapi/v4l/func-mmap.rst
@@ -21,7 +21,7 @@ Synopsis
     #include <sys/mman.h>
 
 
-.. cpp:function:: void *mmap( void *start, size_t length, int prot, int flags, int fd, off_t offset )
+.. c:function:: void *mmap( void *start, size_t length, int prot, int flags, int fd, off_t offset )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/func-munmap.rst b/Documentation/media/uapi/v4l/func-munmap.rst
index c29c03f21279..51eafb215838 100644
--- a/Documentation/media/uapi/v4l/func-munmap.rst
+++ b/Documentation/media/uapi/v4l/func-munmap.rst
@@ -21,7 +21,7 @@ Synopsis
     #include <sys/mman.h>
 
 
-.. cpp:function:: int munmap( void *start, size_t length )
+.. c:function:: int munmap( void *start, size_t length )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/func-open.rst b/Documentation/media/uapi/v4l/func-open.rst
index 06bcadc269a4..1d9e75d4960a 100644
--- a/Documentation/media/uapi/v4l/func-open.rst
+++ b/Documentation/media/uapi/v4l/func-open.rst
@@ -20,7 +20,7 @@ Synopsis
     #include <fcntl.h>
 
 
-.. cpp:function:: int open( const char *device_name, int flags )
+.. c:function:: int open( const char *device_name, int flags )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/func-poll.rst b/Documentation/media/uapi/v4l/func-poll.rst
index e6ceb712b783..da0edfcf9b9b 100644
--- a/Documentation/media/uapi/v4l/func-poll.rst
+++ b/Documentation/media/uapi/v4l/func-poll.rst
@@ -20,7 +20,7 @@ Synopsis
     #include <sys/poll.h>
 
 
-.. cpp:function:: int poll( struct pollfd *ufds, unsigned int nfds, int timeout )
+.. c:function:: int poll( struct pollfd *ufds, unsigned int nfds, int timeout )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/func-read.rst b/Documentation/media/uapi/v4l/func-read.rst
index 9a2aa5210233..9c5b4be926db 100644
--- a/Documentation/media/uapi/v4l/func-read.rst
+++ b/Documentation/media/uapi/v4l/func-read.rst
@@ -20,7 +20,7 @@ Synopsis
     #include <unistd.h>
 
 
-.. cpp:function:: ssize_t read( int fd, void *buf, size_t count )
+.. c:function:: ssize_t read( int fd, void *buf, size_t count )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/func-select.rst b/Documentation/media/uapi/v4l/func-select.rst
index 7798384ae396..78fa66b984d3 100644
--- a/Documentation/media/uapi/v4l/func-select.rst
+++ b/Documentation/media/uapi/v4l/func-select.rst
@@ -22,7 +22,7 @@ Synopsis
     #include <unistd.h>
 
 
-.. cpp:function:: int select( int nfds, fd_set *readfds, fd_set *writefds, fd_set *exceptfds, struct timeval *timeout )
+.. c:function:: int select( int nfds, fd_set *readfds, fd_set *writefds, fd_set *exceptfds, struct timeval *timeout )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/func-write.rst b/Documentation/media/uapi/v4l/func-write.rst
index a3bc9b26fe56..c9351a0efd99 100644
--- a/Documentation/media/uapi/v4l/func-write.rst
+++ b/Documentation/media/uapi/v4l/func-write.rst
@@ -20,7 +20,7 @@ Synopsis
     #include <unistd.h>
 
 
-.. cpp:function:: ssize_t write( int fd, void *buf, size_t count )
+.. c:function:: ssize_t write( int fd, void *buf, size_t count )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-create-bufs.rst b/Documentation/media/uapi/v4l/vidioc-create-bufs.rst
index b4b16aebac98..d5107466b2c5 100644
--- a/Documentation/media/uapi/v4l/vidioc-create-bufs.rst
+++ b/Documentation/media/uapi/v4l/vidioc-create-bufs.rst
@@ -15,7 +15,7 @@ VIDIOC_CREATE_BUFS - Create buffers for Memory Mapped or User Pointer or DMA Buf
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct v4l2_create_buffers *argp )
+.. c:function:: int ioctl( int fd, int request, struct v4l2_create_buffers *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-cropcap.rst b/Documentation/media/uapi/v4l/vidioc-cropcap.rst
index e3d853356438..30a0493f404a 100644
--- a/Documentation/media/uapi/v4l/vidioc-cropcap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-cropcap.rst
@@ -15,7 +15,7 @@ VIDIOC_CROPCAP - Information about the video cropping and scaling abilities
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct v4l2_cropcap *argp )
+.. c:function:: int ioctl( int fd, int request, struct v4l2_cropcap *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-dbg-g-chip-info.rst b/Documentation/media/uapi/v4l/vidioc-dbg-g-chip-info.rst
index 4c30b2268c70..f0310afe6606 100644
--- a/Documentation/media/uapi/v4l/vidioc-dbg-g-chip-info.rst
+++ b/Documentation/media/uapi/v4l/vidioc-dbg-g-chip-info.rst
@@ -15,7 +15,7 @@ VIDIOC_DBG_G_CHIP_INFO - Identify the chips on a TV card
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct v4l2_dbg_chip_info *argp )
+.. c:function:: int ioctl( int fd, int request, struct v4l2_dbg_chip_info *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-dbg-g-register.rst b/Documentation/media/uapi/v4l/vidioc-dbg-g-register.rst
index cb6a878a60ea..2b508e8faa4b 100644
--- a/Documentation/media/uapi/v4l/vidioc-dbg-g-register.rst
+++ b/Documentation/media/uapi/v4l/vidioc-dbg-g-register.rst
@@ -15,9 +15,9 @@ VIDIOC_DBG_G_REGISTER - VIDIOC_DBG_S_REGISTER - Read or write hardware registers
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct v4l2_dbg_register *argp )
+.. c:function:: int ioctl( int fd, int request, struct v4l2_dbg_register *argp )
 
-.. cpp:function:: int ioctl( int fd, int request, const struct v4l2_dbg_register *argp )
+.. c:function:: int ioctl( int fd, int request, const struct v4l2_dbg_register *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-decoder-cmd.rst b/Documentation/media/uapi/v4l/vidioc-decoder-cmd.rst
index 63acf4e59530..1d918ade637e 100644
--- a/Documentation/media/uapi/v4l/vidioc-decoder-cmd.rst
+++ b/Documentation/media/uapi/v4l/vidioc-decoder-cmd.rst
@@ -15,7 +15,7 @@ VIDIOC_DECODER_CMD - VIDIOC_TRY_DECODER_CMD - Execute an decoder command
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct v4l2_decoder_cmd *argp )
+.. c:function:: int ioctl( int fd, int request, struct v4l2_decoder_cmd *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-dqevent.rst b/Documentation/media/uapi/v4l/vidioc-dqevent.rst
index e5be2a5518af..c2c2a3337d09 100644
--- a/Documentation/media/uapi/v4l/vidioc-dqevent.rst
+++ b/Documentation/media/uapi/v4l/vidioc-dqevent.rst
@@ -15,7 +15,7 @@ VIDIOC_DQEVENT - Dequeue event
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct v4l2_event *argp )
+.. c:function:: int ioctl( int fd, int request, struct v4l2_event *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst b/Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst
index 7054e36e061f..110e5783938d 100644
--- a/Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst
@@ -15,7 +15,7 @@ VIDIOC_DV_TIMINGS_CAP - VIDIOC_SUBDEV_DV_TIMINGS_CAP - The capabilities of the D
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct v4l2_dv_timings_cap *argp )
+.. c:function:: int ioctl( int fd, int request, struct v4l2_dv_timings_cap *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-encoder-cmd.rst b/Documentation/media/uapi/v4l/vidioc-encoder-cmd.rst
index 795d9215017a..756a85f78f31 100644
--- a/Documentation/media/uapi/v4l/vidioc-encoder-cmd.rst
+++ b/Documentation/media/uapi/v4l/vidioc-encoder-cmd.rst
@@ -15,7 +15,7 @@ VIDIOC_ENCODER_CMD - VIDIOC_TRY_ENCODER_CMD - Execute an encoder command
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct v4l2_encoder_cmd *argp )
+.. c:function:: int ioctl( int fd, int request, struct v4l2_encoder_cmd *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-dv-timings.rst b/Documentation/media/uapi/v4l/vidioc-enum-dv-timings.rst
index c386045885f2..2ca25a58ae4c 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-dv-timings.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-dv-timings.rst
@@ -15,7 +15,7 @@ VIDIOC_ENUM_DV_TIMINGS - VIDIOC_SUBDEV_ENUM_DV_TIMINGS - Enumerate supported Dig
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct v4l2_enum_dv_timings *argp )
+.. c:function:: int ioctl( int fd, int request, struct v4l2_enum_dv_timings *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst b/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
index da0b888c01cb..eca4614a1b13 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
@@ -15,7 +15,7 @@ VIDIOC_ENUM_FMT - Enumerate image formats
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct v4l2_fmtdesc *argp )
+.. c:function:: int ioctl( int fd, int request, struct v4l2_fmtdesc *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-frameintervals.rst b/Documentation/media/uapi/v4l/vidioc-enum-frameintervals.rst
index 7541158e16d2..39fbbb391c99 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-frameintervals.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-frameintervals.rst
@@ -15,7 +15,7 @@ VIDIOC_ENUM_FRAMEINTERVALS - Enumerate frame intervals
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct v4l2_frmivalenum *argp )
+.. c:function:: int ioctl( int fd, int request, struct v4l2_frmivalenum *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-framesizes.rst b/Documentation/media/uapi/v4l/vidioc-enum-framesizes.rst
index 1c23da3f26bc..1d428f88f329 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-framesizes.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-framesizes.rst
@@ -15,7 +15,7 @@ VIDIOC_ENUM_FRAMESIZES - Enumerate frame sizes
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct v4l2_frmsizeenum *argp )
+.. c:function:: int ioctl( int fd, int request, struct v4l2_frmsizeenum *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst b/Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst
index 8fac84d839f4..5fe84357d9cd 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst
@@ -15,7 +15,7 @@ VIDIOC_ENUM_FREQ_BANDS - Enumerate supported frequency bands
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct v4l2_frequency_band *argp )
+.. c:function:: int ioctl( int fd, int request, struct v4l2_frequency_band *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-enumaudio.rst b/Documentation/media/uapi/v4l/vidioc-enumaudio.rst
index bfdc3533240d..3127b9062d96 100644
--- a/Documentation/media/uapi/v4l/vidioc-enumaudio.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enumaudio.rst
@@ -15,7 +15,7 @@ VIDIOC_ENUMAUDIO - Enumerate audio inputs
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct v4l2_audio *argp )
+.. c:function:: int ioctl( int fd, int request, struct v4l2_audio *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-enumaudioout.rst b/Documentation/media/uapi/v4l/vidioc-enumaudioout.rst
index 3112b43242f2..4cbba134e773 100644
--- a/Documentation/media/uapi/v4l/vidioc-enumaudioout.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enumaudioout.rst
@@ -15,7 +15,7 @@ VIDIOC_ENUMAUDOUT - Enumerate audio outputs
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct v4l2_audioout *argp )
+.. c:function:: int ioctl( int fd, int request, struct v4l2_audioout *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-enuminput.rst b/Documentation/media/uapi/v4l/vidioc-enuminput.rst
index f8188070335e..075cdf2c5749 100644
--- a/Documentation/media/uapi/v4l/vidioc-enuminput.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enuminput.rst
@@ -15,7 +15,7 @@ VIDIOC_ENUMINPUT - Enumerate video inputs
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct v4l2_input *argp )
+.. c:function:: int ioctl( int fd, int request, struct v4l2_input *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-enumoutput.rst b/Documentation/media/uapi/v4l/vidioc-enumoutput.rst
index 6d50b297b0aa..d2c1d4eaaf47 100644
--- a/Documentation/media/uapi/v4l/vidioc-enumoutput.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enumoutput.rst
@@ -15,7 +15,7 @@ VIDIOC_ENUMOUTPUT - Enumerate video outputs
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct v4l2_output *argp )
+.. c:function:: int ioctl( int fd, int request, struct v4l2_output *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-enumstd.rst b/Documentation/media/uapi/v4l/vidioc-enumstd.rst
index 2735b0496e9e..73c2358185a4 100644
--- a/Documentation/media/uapi/v4l/vidioc-enumstd.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enumstd.rst
@@ -15,7 +15,7 @@ VIDIOC_ENUMSTD - Enumerate supported video standards
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct v4l2_standard *argp )
+.. c:function:: int ioctl( int fd, int request, struct v4l2_standard *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-expbuf.rst b/Documentation/media/uapi/v4l/vidioc-expbuf.rst
index 67f72ced2a00..5e2db6efce38 100644
--- a/Documentation/media/uapi/v4l/vidioc-expbuf.rst
+++ b/Documentation/media/uapi/v4l/vidioc-expbuf.rst
@@ -15,7 +15,7 @@ VIDIOC_EXPBUF - Export a buffer as a DMABUF file descriptor.
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct v4l2_exportbuffer *argp )
+.. c:function:: int ioctl( int fd, int request, struct v4l2_exportbuffer *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-g-audio.rst b/Documentation/media/uapi/v4l/vidioc-g-audio.rst
index 703091ba1391..787668482198 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-audio.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-audio.rst
@@ -15,9 +15,9 @@ VIDIOC_G_AUDIO - VIDIOC_S_AUDIO - Query or select the current audio input and it
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct v4l2_audio *argp )
+.. c:function:: int ioctl( int fd, int request, struct v4l2_audio *argp )
 
-.. cpp:function:: int ioctl( int fd, int request, const struct v4l2_audio *argp )
+.. c:function:: int ioctl( int fd, int request, const struct v4l2_audio *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-g-audioout.rst b/Documentation/media/uapi/v4l/vidioc-g-audioout.rst
index 1420ddebefd0..ed5ccca8797d 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-audioout.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-audioout.rst
@@ -15,9 +15,9 @@ VIDIOC_G_AUDOUT - VIDIOC_S_AUDOUT - Query or select the current audio output
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct v4l2_audioout *argp )
+.. c:function:: int ioctl( int fd, int request, struct v4l2_audioout *argp )
 
-.. cpp:function:: int ioctl( int fd, int request, const struct v4l2_audioout *argp )
+.. c:function:: int ioctl( int fd, int request, const struct v4l2_audioout *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-g-crop.rst b/Documentation/media/uapi/v4l/vidioc-g-crop.rst
index 08df93224a38..2b171b5c003e 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-crop.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-crop.rst
@@ -15,9 +15,9 @@ VIDIOC_G_CROP - VIDIOC_S_CROP - Get or set the current cropping rectangle
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct v4l2_crop *argp )
+.. c:function:: int ioctl( int fd, int request, struct v4l2_crop *argp )
 
-.. cpp:function:: int ioctl( int fd, int request, const struct v4l2_crop *argp )
+.. c:function:: int ioctl( int fd, int request, const struct v4l2_crop *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-g-ctrl.rst b/Documentation/media/uapi/v4l/vidioc-g-ctrl.rst
index e585b04b3f00..8eeb33916a7c 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-ctrl.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-ctrl.rst
@@ -15,7 +15,7 @@ VIDIOC_G_CTRL - VIDIOC_S_CTRL - Get or set the value of a control
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct v4l2_control *argp )
+.. c:function:: int ioctl( int fd, int request, struct v4l2_control *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst b/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
index 013f49210de9..401a9ad2ad7b 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
@@ -15,7 +15,7 @@ VIDIOC_G_DV_TIMINGS - VIDIOC_S_DV_TIMINGS - VIDIOC_SUBDEV_G_DV_TIMINGS - VIDIOC_
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct v4l2_dv_timings *argp )
+.. c:function:: int ioctl( int fd, int request, struct v4l2_dv_timings *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-g-edid.rst b/Documentation/media/uapi/v4l/vidioc-g-edid.rst
index 721d17fc829e..0940d46ad007 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-edid.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-edid.rst
@@ -15,7 +15,7 @@ VIDIOC_G_EDID - VIDIOC_S_EDID - VIDIOC_SUBDEV_G_EDID - VIDIOC_SUBDEV_S_EDID - Ge
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct v4l2_edid *argp )
+.. c:function:: int ioctl( int fd, int request, struct v4l2_edid *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-g-enc-index.rst b/Documentation/media/uapi/v4l/vidioc-g-enc-index.rst
index 64e74786babf..479993e1fbbf 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-enc-index.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-enc-index.rst
@@ -15,7 +15,7 @@ VIDIOC_G_ENC_INDEX - Get meta data about a compressed video stream
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct v4l2_enc_idx *argp )
+.. c:function:: int ioctl( int fd, int request, struct v4l2_enc_idx *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst b/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
index f0d33298f329..d0ddf3094c16 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
@@ -15,7 +15,7 @@ VIDIOC_G_EXT_CTRLS - VIDIOC_S_EXT_CTRLS - VIDIOC_TRY_EXT_CTRLS - Get or set the
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct v4l2_ext_controls *argp )
+.. c:function:: int ioctl( int fd, int request, struct v4l2_ext_controls *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-g-fbuf.rst b/Documentation/media/uapi/v4l/vidioc-g-fbuf.rst
index 562505c5db0b..e7a6e14adb4f 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-fbuf.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-fbuf.rst
@@ -15,9 +15,9 @@ VIDIOC_G_FBUF - VIDIOC_S_FBUF - Get or set frame buffer overlay parameters
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct v4l2_framebuffer *argp )
+.. c:function:: int ioctl( int fd, int request, struct v4l2_framebuffer *argp )
 
-.. cpp:function:: int ioctl( int fd, int request, const struct v4l2_framebuffer *argp )
+.. c:function:: int ioctl( int fd, int request, const struct v4l2_framebuffer *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-g-fmt.rst b/Documentation/media/uapi/v4l/vidioc-g-fmt.rst
index 94e42ac3d4d8..46e5b4de10bc 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-fmt.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-fmt.rst
@@ -15,7 +15,7 @@ VIDIOC_G_FMT - VIDIOC_S_FMT - VIDIOC_TRY_FMT - Get or set the data format, try a
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct v4l2_format *argp )
+.. c:function:: int ioctl( int fd, int request, struct v4l2_format *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-g-frequency.rst b/Documentation/media/uapi/v4l/vidioc-g-frequency.rst
index c0468ff3546e..0810aec0e7b7 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-frequency.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-frequency.rst
@@ -15,9 +15,9 @@ VIDIOC_G_FREQUENCY - VIDIOC_S_FREQUENCY - Get or set tuner or modulator radio fr
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct v4l2_frequency *argp )
+.. c:function:: int ioctl( int fd, int request, struct v4l2_frequency *argp )
 
-.. cpp:function:: int ioctl( int fd, int request, const struct v4l2_frequency *argp )
+.. c:function:: int ioctl( int fd, int request, const struct v4l2_frequency *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-g-input.rst b/Documentation/media/uapi/v4l/vidioc-g-input.rst
index 29e22f6f8028..de87712f0336 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-input.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-input.rst
@@ -15,7 +15,7 @@ VIDIOC_G_INPUT - VIDIOC_S_INPUT - Query or select the current video input
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, int *argp )
+.. c:function:: int ioctl( int fd, int request, int *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst b/Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst
index a5a997db7a33..9800037b5ba0 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst
@@ -15,9 +15,9 @@ VIDIOC_G_JPEGCOMP - VIDIOC_S_JPEGCOMP
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, v4l2_jpegcompression *argp )
+.. c:function:: int ioctl( int fd, int request, v4l2_jpegcompression *argp )
 
-.. cpp:function:: int ioctl( int fd, int request, const v4l2_jpegcompression *argp )
+.. c:function:: int ioctl( int fd, int request, const v4l2_jpegcompression *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-g-modulator.rst b/Documentation/media/uapi/v4l/vidioc-g-modulator.rst
index 0b362fc8ec29..4f8d2babe79a 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-modulator.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-modulator.rst
@@ -15,9 +15,9 @@ VIDIOC_G_MODULATOR - VIDIOC_S_MODULATOR - Get or set modulator attributes
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct v4l2_modulator *argp )
+.. c:function:: int ioctl( int fd, int request, struct v4l2_modulator *argp )
 
-.. cpp:function:: int ioctl( int fd, int request, const struct v4l2_modulator *argp )
+.. c:function:: int ioctl( int fd, int request, const struct v4l2_modulator *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-g-output.rst b/Documentation/media/uapi/v4l/vidioc-g-output.rst
index ae0ad577ba97..1b7fffe7f075 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-output.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-output.rst
@@ -15,7 +15,7 @@ VIDIOC_G_OUTPUT - VIDIOC_S_OUTPUT - Query or select the current video output
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, int *argp )
+.. c:function:: int ioctl( int fd, int request, int *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-g-parm.rst b/Documentation/media/uapi/v4l/vidioc-g-parm.rst
index 1b044613ab68..000109a0c86d 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-parm.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-parm.rst
@@ -15,7 +15,7 @@ VIDIOC_G_PARM - VIDIOC_S_PARM - Get or set streaming parameters
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, v4l2_streamparm *argp )
+.. c:function:: int ioctl( int fd, int request, v4l2_streamparm *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-g-priority.rst b/Documentation/media/uapi/v4l/vidioc-g-priority.rst
index 3f021e6b9d0d..cafa7d099b86 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-priority.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-priority.rst
@@ -15,9 +15,9 @@ VIDIOC_G_PRIORITY - VIDIOC_S_PRIORITY - Query or request the access priority ass
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, enum v4l2_priority *argp )
+.. c:function:: int ioctl( int fd, int request, enum v4l2_priority *argp )
 
-.. cpp:function:: int ioctl( int fd, int request, const enum v4l2_priority *argp )
+.. c:function:: int ioctl( int fd, int request, const enum v4l2_priority *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-g-selection.rst b/Documentation/media/uapi/v4l/vidioc-g-selection.rst
index 8e72f93a358e..e01e92549032 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-selection.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-selection.rst
@@ -15,7 +15,7 @@ VIDIOC_G_SELECTION - VIDIOC_S_SELECTION - Get or set one of the selection rectan
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct v4l2_selection *argp )
+.. c:function:: int ioctl( int fd, int request, struct v4l2_selection *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst b/Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst
index 740324e6e5db..62072ffc11e5 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst
@@ -15,7 +15,7 @@ VIDIOC_G_SLICED_VBI_CAP - Query sliced VBI capabilities
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct v4l2_sliced_vbi_cap *argp )
+.. c:function:: int ioctl( int fd, int request, struct v4l2_sliced_vbi_cap *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-g-std.rst b/Documentation/media/uapi/v4l/vidioc-g-std.rst
index 5c2b861f8d26..4fd57e7ed0d1 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-std.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-std.rst
@@ -15,9 +15,9 @@ VIDIOC_G_STD - VIDIOC_S_STD - Query or select the video standard of the current
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, v4l2_std_id *argp )
+.. c:function:: int ioctl( int fd, int request, v4l2_std_id *argp )
 
-.. cpp:function:: int ioctl( int fd, int request, const v4l2_std_id *argp )
+.. c:function:: int ioctl( int fd, int request, const v4l2_std_id *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-g-tuner.rst b/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
index 9798a1a86e97..30ff994e5618 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
@@ -15,9 +15,9 @@ VIDIOC_G_TUNER - VIDIOC_S_TUNER - Get or set tuner attributes
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct v4l2_tuner *argp )
+.. c:function:: int ioctl( int fd, int request, struct v4l2_tuner *argp )
 
-.. cpp:function:: int ioctl( int fd, int request, const struct v4l2_tuner *argp )
+.. c:function:: int ioctl( int fd, int request, const struct v4l2_tuner *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-log-status.rst b/Documentation/media/uapi/v4l/vidioc-log-status.rst
index 66fc352c0ffa..6cf7904dd34c 100644
--- a/Documentation/media/uapi/v4l/vidioc-log-status.rst
+++ b/Documentation/media/uapi/v4l/vidioc-log-status.rst
@@ -15,7 +15,7 @@ VIDIOC_LOG_STATUS - Log driver status information
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request )
+.. c:function:: int ioctl( int fd, int request )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-overlay.rst b/Documentation/media/uapi/v4l/vidioc-overlay.rst
index 191dbc144ef7..e7a3956cba3d 100644
--- a/Documentation/media/uapi/v4l/vidioc-overlay.rst
+++ b/Documentation/media/uapi/v4l/vidioc-overlay.rst
@@ -15,7 +15,7 @@ VIDIOC_OVERLAY - Start or stop video overlay
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, const int *argp )
+.. c:function:: int ioctl( int fd, int request, const int *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-prepare-buf.rst b/Documentation/media/uapi/v4l/vidioc-prepare-buf.rst
index 79076dff46fd..0baa692edd33 100644
--- a/Documentation/media/uapi/v4l/vidioc-prepare-buf.rst
+++ b/Documentation/media/uapi/v4l/vidioc-prepare-buf.rst
@@ -15,7 +15,7 @@ VIDIOC_PREPARE_BUF - Prepare a buffer for I/O
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct v4l2_buffer *argp )
+.. c:function:: int ioctl( int fd, int request, struct v4l2_buffer *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-qbuf.rst b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
index 31c360d7d1a6..ec5cb57d4acf 100644
--- a/Documentation/media/uapi/v4l/vidioc-qbuf.rst
+++ b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
@@ -15,7 +15,7 @@ VIDIOC_QBUF - VIDIOC_DQBUF - Exchange a buffer with the driver
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct v4l2_buffer *argp )
+.. c:function:: int ioctl( int fd, int request, struct v4l2_buffer *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-query-dv-timings.rst b/Documentation/media/uapi/v4l/vidioc-query-dv-timings.rst
index 6a87f44cdf3f..c262b0a0ef4a 100644
--- a/Documentation/media/uapi/v4l/vidioc-query-dv-timings.rst
+++ b/Documentation/media/uapi/v4l/vidioc-query-dv-timings.rst
@@ -15,7 +15,7 @@ VIDIOC_QUERY_DV_TIMINGS - VIDIOC_SUBDEV_QUERY_DV_TIMINGS - Sense the DV preset r
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct v4l2_dv_timings *argp )
+.. c:function:: int ioctl( int fd, int request, struct v4l2_dv_timings *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-querybuf.rst b/Documentation/media/uapi/v4l/vidioc-querybuf.rst
index 32af6f7b5060..f180c42883fa 100644
--- a/Documentation/media/uapi/v4l/vidioc-querybuf.rst
+++ b/Documentation/media/uapi/v4l/vidioc-querybuf.rst
@@ -15,7 +15,7 @@ VIDIOC_QUERYBUF - Query the status of a buffer
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct v4l2_buffer *argp )
+.. c:function:: int ioctl( int fd, int request, struct v4l2_buffer *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-querycap.rst b/Documentation/media/uapi/v4l/vidioc-querycap.rst
index 5b9922e83c58..c821a6c77ab5 100644
--- a/Documentation/media/uapi/v4l/vidioc-querycap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-querycap.rst
@@ -15,7 +15,7 @@ VIDIOC_QUERYCAP - Query device capabilities
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct v4l2_capability *argp )
+.. c:function:: int ioctl( int fd, int request, struct v4l2_capability *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
index 6e4912f2e3a4..25c7c035cccc 100644
--- a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
+++ b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
@@ -15,11 +15,11 @@ VIDIOC_QUERYCTRL - VIDIOC_QUERY_EXT_CTRL - VIDIOC_QUERYMENU - Enumerate controls
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct v4l2_queryctrl *argp )
+.. c:function:: int ioctl( int fd, int request, struct v4l2_queryctrl *argp )
 
-.. cpp:function:: int ioctl( int fd, int request, struct v4l2_query_ext_ctrl *argp )
+.. c:function:: int ioctl( int fd, int request, struct v4l2_query_ext_ctrl *argp )
 
-.. cpp:function:: int ioctl( int fd, int request, struct v4l2_querymenu *argp )
+.. c:function:: int ioctl( int fd, int request, struct v4l2_querymenu *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-querystd.rst b/Documentation/media/uapi/v4l/vidioc-querystd.rst
index cb03d249417c..9324659cebc6 100644
--- a/Documentation/media/uapi/v4l/vidioc-querystd.rst
+++ b/Documentation/media/uapi/v4l/vidioc-querystd.rst
@@ -15,7 +15,7 @@ VIDIOC_QUERYSTD - Sense the video standard received by the current input
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, v4l2_std_id *argp )
+.. c:function:: int ioctl( int fd, int request, v4l2_std_id *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-reqbufs.rst b/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
index 8be9343802dc..2078b0b00a9e 100644
--- a/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
+++ b/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
@@ -15,7 +15,7 @@ VIDIOC_REQBUFS - Initiate Memory Mapping, User Pointer I/O or DMA buffer I/O
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct v4l2_requestbuffers *argp )
+.. c:function:: int ioctl( int fd, int request, struct v4l2_requestbuffers *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-s-hw-freq-seek.rst b/Documentation/media/uapi/v4l/vidioc-s-hw-freq-seek.rst
index 2bc10ebb12a4..765a8453103f 100644
--- a/Documentation/media/uapi/v4l/vidioc-s-hw-freq-seek.rst
+++ b/Documentation/media/uapi/v4l/vidioc-s-hw-freq-seek.rst
@@ -15,7 +15,7 @@ VIDIOC_S_HW_FREQ_SEEK - Perform a hardware frequency seek
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct v4l2_hw_freq_seek *argp )
+.. c:function:: int ioctl( int fd, int request, struct v4l2_hw_freq_seek *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-streamon.rst b/Documentation/media/uapi/v4l/vidioc-streamon.rst
index 7fa4362f9a81..d27afa21b925 100644
--- a/Documentation/media/uapi/v4l/vidioc-streamon.rst
+++ b/Documentation/media/uapi/v4l/vidioc-streamon.rst
@@ -15,7 +15,7 @@ VIDIOC_STREAMON - VIDIOC_STREAMOFF - Start or stop streaming I/O
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, const int *argp )
+.. c:function:: int ioctl( int fd, int request, const int *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst b/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst
index 1c853f3f5676..290ba88eb208 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst
@@ -15,7 +15,7 @@ VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL - Enumerate frame intervals
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct v4l2_subdev_frame_interval_enum * argp )
+.. c:function:: int ioctl( int fd, int request, struct v4l2_subdev_frame_interval_enum * argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-size.rst b/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-size.rst
index e1bcc69f67db..d26709184369 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-size.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-size.rst
@@ -15,7 +15,7 @@ VIDIOC_SUBDEV_ENUM_FRAME_SIZE - Enumerate media bus frame sizes
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct v4l2_subdev_frame_size_enum * argp )
+.. c:function:: int ioctl( int fd, int request, struct v4l2_subdev_frame_size_enum * argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-enum-mbus-code.rst b/Documentation/media/uapi/v4l/vidioc-subdev-enum-mbus-code.rst
index 418d543ebbbf..a1dabf071437 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-enum-mbus-code.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-enum-mbus-code.rst
@@ -15,7 +15,7 @@ VIDIOC_SUBDEV_ENUM_MBUS_CODE - Enumerate media bus formats
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct v4l2_subdev_mbus_code_enum * argp )
+.. c:function:: int ioctl( int fd, int request, struct v4l2_subdev_mbus_code_enum * argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-g-crop.rst b/Documentation/media/uapi/v4l/vidioc-subdev-g-crop.rst
index 7caa04e1c2a8..c3e32c94937b 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-g-crop.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-g-crop.rst
@@ -15,9 +15,9 @@ VIDIOC_SUBDEV_G_CROP - VIDIOC_SUBDEV_S_CROP - Get or set the crop rectangle on a
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct v4l2_subdev_crop *argp )
+.. c:function:: int ioctl( int fd, int request, struct v4l2_subdev_crop *argp )
 
-.. cpp:function:: int ioctl( int fd, int request, const struct v4l2_subdev_crop *argp )
+.. c:function:: int ioctl( int fd, int request, const struct v4l2_subdev_crop *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-g-fmt.rst b/Documentation/media/uapi/v4l/vidioc-subdev-g-fmt.rst
index f5e9b40b22f4..55b113de91bb 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-g-fmt.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-g-fmt.rst
@@ -15,7 +15,7 @@ VIDIOC_SUBDEV_G_FMT - VIDIOC_SUBDEV_S_FMT - Get or set the data format on a subd
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct v4l2_subdev_format *argp )
+.. c:function:: int ioctl( int fd, int request, struct v4l2_subdev_format *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-g-frame-interval.rst b/Documentation/media/uapi/v4l/vidioc-subdev-g-frame-interval.rst
index 2df2d8635f2b..056af63b9cfa 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-g-frame-interval.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-g-frame-interval.rst
@@ -15,7 +15,7 @@ VIDIOC_SUBDEV_G_FRAME_INTERVAL - VIDIOC_SUBDEV_S_FRAME_INTERVAL - Get or set the
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct v4l2_subdev_frame_interval *argp )
+.. c:function:: int ioctl( int fd, int request, struct v4l2_subdev_frame_interval *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-g-selection.rst b/Documentation/media/uapi/v4l/vidioc-subdev-g-selection.rst
index c59a32e0cc20..5c1626a4feaf 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-g-selection.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-g-selection.rst
@@ -15,7 +15,7 @@ VIDIOC_SUBDEV_G_SELECTION - VIDIOC_SUBDEV_S_SELECTION - Get or set selection rec
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct v4l2_subdev_selection *argp )
+.. c:function:: int ioctl( int fd, int request, struct v4l2_subdev_selection *argp )
 
 
 Arguments
diff --git a/Documentation/media/uapi/v4l/vidioc-subscribe-event.rst b/Documentation/media/uapi/v4l/vidioc-subscribe-event.rst
index 71079746ddac..7015bb283a6a 100644
--- a/Documentation/media/uapi/v4l/vidioc-subscribe-event.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subscribe-event.rst
@@ -16,7 +16,7 @@ VIDIOC_SUBSCRIBE_EVENT - VIDIOC_UNSUBSCRIBE_EVENT - Subscribe or unsubscribe eve
 Synopsis
 ========
 
-.. cpp:function:: int ioctl( int fd, int request, struct v4l2_event_subscription *argp )
+.. c:function:: int ioctl( int fd, int request, struct v4l2_event_subscription *argp )
 
 
 Arguments
-- 
2.7.4


