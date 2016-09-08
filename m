Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44094 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965682AbcIHMEY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 08:04:24 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Nick Dyer <nick@shmanahar.org>
Subject: [PATCH 15/47] [media] docs-rst: convert uAPI structs to C domain
Date: Thu,  8 Sep 2016 09:03:37 -0300
Message-Id: <649eb31d423f77fd1dd6939479b8b8a4ed40842c.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

instead of declaring the uAPI structs using usual refs, e. g.:
	.. _foo-struct:

Use the C domain way:
	.. c:type:: foo_struct

This way, the kAPI documentation can use cross-references to
point to the uAPI symbols.

That solves about ~100 undefined warnings like:
	WARNING: c:type reference target not found: foo_struct

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/kapi/v4l2-event.rst            |   6 +-
 .../media/uapi/cec/cec-ioc-adap-g-caps.rst         |   4 +-
 .../media/uapi/cec/cec-ioc-adap-g-log-addrs.rst    |   2 +-
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst   |   2 +-
 Documentation/media/uapi/cec/cec-ioc-receive.rst   |   2 +-
 Documentation/media/uapi/dvb/audio_data_types.rst  |   6 +-
 Documentation/media/uapi/dvb/ca_data_types.rst     |  12 +--
 Documentation/media/uapi/dvb/dmx_types.rst         |  10 +-
 Documentation/media/uapi/dvb/dtv-fe-stats.rst      |   2 +-
 Documentation/media/uapi/dvb/dtv-properties.rst    |   2 +-
 Documentation/media/uapi/dvb/dtv-property.rst      |   2 +-
 Documentation/media/uapi/dvb/dtv-stats.rst         |   2 +-
 .../media/uapi/dvb/dvb-frontend-event.rst          |   2 +-
 .../media/uapi/dvb/dvb-frontend-parameters.rst     |  10 +-
 Documentation/media/uapi/dvb/dvbproperty.rst       |   2 +-
 .../media/uapi/dvb/fe-diseqc-recv-slave-reply.rst  |   4 +-
 .../media/uapi/dvb/fe-diseqc-send-master-cmd.rst   |   4 +-
 Documentation/media/uapi/dvb/fe-get-info.rst       |   4 +-
 Documentation/media/uapi/dvb/fe-get-property.rst   |   2 +-
 Documentation/media/uapi/dvb/fe-type-t.rst         |   4 +-
 .../media/uapi/dvb/frontend-stat-properties.rst    |   2 +-
 Documentation/media/uapi/dvb/net-add-if.rst        |   6 +-
 Documentation/media/uapi/dvb/net-get-if.rst        |   6 +-
 Documentation/media/uapi/dvb/video_types.rst       |  16 +--
 .../media/uapi/mediactl/media-ioc-device-info.rst  |   4 +-
 .../uapi/mediactl/media-ioc-enum-entities.rst      |   6 +-
 .../media/uapi/mediactl/media-ioc-enum-links.rst   |  22 ++---
 .../media/uapi/mediactl/media-ioc-g-topology.rst   |  14 +--
 .../media/uapi/mediactl/media-ioc-setup-link.rst   |   4 +-
 Documentation/media/uapi/v4l/audio.rst             |  12 +--
 Documentation/media/uapi/v4l/buffer.rst            |  40 ++++----
 Documentation/media/uapi/v4l/crop.rst              |  14 +--
 Documentation/media/uapi/v4l/dev-capture.rst       |  16 +--
 Documentation/media/uapi/v4l/dev-osd.rst           |  18 ++--
 Documentation/media/uapi/v4l/dev-output.rst        |  16 +--
 Documentation/media/uapi/v4l/dev-overlay.rst       |  22 ++---
 Documentation/media/uapi/v4l/dev-radio.rst         |   2 +-
 Documentation/media/uapi/v4l/dev-raw-vbi.rst       |  14 +--
 Documentation/media/uapi/v4l/dev-rds.rst           |  14 +--
 Documentation/media/uapi/v4l/dev-sdr.rst           |  12 +--
 Documentation/media/uapi/v4l/dev-sliced-vbi.rst    |  36 +++----
 Documentation/media/uapi/v4l/dev-subdev.rst        |   4 +-
 Documentation/media/uapi/v4l/dev-touch.rst         |   2 +-
 Documentation/media/uapi/v4l/diff-v4l.rst          |  66 ++++++-------
 Documentation/media/uapi/v4l/dmabuf.rst            |   8 +-
 Documentation/media/uapi/v4l/extended-controls.rst |  10 +-
 Documentation/media/uapi/v4l/field-order.rst       |   8 +-
 Documentation/media/uapi/v4l/format.rst            |   2 +-
 Documentation/media/uapi/v4l/func-mmap.rst         |   8 +-
 Documentation/media/uapi/v4l/func-munmap.rst       |   4 +-
 Documentation/media/uapi/v4l/hist-v4l2.rst         | 108 ++++++++++-----------
 Documentation/media/uapi/v4l/mmap.rst              |  12 +--
 Documentation/media/uapi/v4l/pixfmt-002.rst        |   6 +-
 Documentation/media/uapi/v4l/pixfmt-003.rst        |  22 ++---
 Documentation/media/uapi/v4l/pixfmt-006.rst        |   4 +-
 Documentation/media/uapi/v4l/pixfmt.rst            |   4 +-
 Documentation/media/uapi/v4l/planar-apis.rst       |   8 +-
 Documentation/media/uapi/v4l/rw.rst                |   2 +-
 Documentation/media/uapi/v4l/selection-api-005.rst |  10 +-
 Documentation/media/uapi/v4l/standard.rst          |   8 +-
 Documentation/media/uapi/v4l/streaming-par.rst     |   2 +-
 Documentation/media/uapi/v4l/tuner.rst             |  10 +-
 Documentation/media/uapi/v4l/userp.rst             |   8 +-
 Documentation/media/uapi/v4l/v4l2.rst              |   6 +-
 Documentation/media/uapi/v4l/video.rst             |   2 +-
 .../media/uapi/v4l/vidioc-create-bufs.rst          |   8 +-
 Documentation/media/uapi/v4l/vidioc-cropcap.rst    |   6 +-
 .../media/uapi/v4l/vidioc-dbg-g-chip-info.rst      |   4 +-
 .../media/uapi/v4l/vidioc-dbg-g-register.rst       |   6 +-
 .../media/uapi/v4l/vidioc-decoder-cmd.rst          |   6 +-
 Documentation/media/uapi/v4l/vidioc-dqevent.rst    |  40 ++++----
 .../media/uapi/v4l/vidioc-dv-timings-cap.rst       |  10 +-
 .../media/uapi/v4l/vidioc-encoder-cmd.rst          |   4 +-
 .../media/uapi/v4l/vidioc-enum-dv-timings.rst      |  10 +-
 Documentation/media/uapi/v4l/vidioc-enum-fmt.rst   |   6 +-
 .../media/uapi/v4l/vidioc-enum-frameintervals.rst  |  16 +--
 .../media/uapi/v4l/vidioc-enum-framesizes.rst      |  12 +--
 .../media/uapi/v4l/vidioc-enum-freq-bands.rst      |  14 +--
 Documentation/media/uapi/v4l/vidioc-enumaudio.rst  |   4 +-
 .../media/uapi/v4l/vidioc-enumaudioout.rst         |   4 +-
 Documentation/media/uapi/v4l/vidioc-enuminput.rst  |   8 +-
 Documentation/media/uapi/v4l/vidioc-enumoutput.rst |   8 +-
 Documentation/media/uapi/v4l/vidioc-enumstd.rst    |  12 +--
 Documentation/media/uapi/v4l/vidioc-expbuf.rst     |  12 +--
 Documentation/media/uapi/v4l/vidioc-g-audio.rst    |   6 +-
 Documentation/media/uapi/v4l/vidioc-g-audioout.rst |   6 +-
 Documentation/media/uapi/v4l/vidioc-g-crop.rst     |  10 +-
 Documentation/media/uapi/v4l/vidioc-g-ctrl.rst     |  10 +-
 .../media/uapi/v4l/vidioc-g-dv-timings.rst         |  10 +-
 .../media/uapi/v4l/vidioc-g-enc-index.rst          |   8 +-
 .../media/uapi/v4l/vidioc-g-ext-ctrls.rst          |  26 ++---
 Documentation/media/uapi/v4l/vidioc-g-fbuf.rst     |  18 ++--
 Documentation/media/uapi/v4l/vidioc-g-fmt.rst      |  24 ++---
 .../media/uapi/v4l/vidioc-g-frequency.rst          |  20 ++--
 Documentation/media/uapi/v4l/vidioc-g-input.rst    |   2 +-
 Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst |   2 +-
 .../media/uapi/v4l/vidioc-g-modulator.rst          |   8 +-
 Documentation/media/uapi/v4l/vidioc-g-output.rst   |   2 +-
 Documentation/media/uapi/v4l/vidioc-g-parm.rst     |  22 ++---
 .../media/uapi/v4l/vidioc-g-selection.rst          |  28 +++---
 .../media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst     |   4 +-
 Documentation/media/uapi/v4l/vidioc-g-std.rst      |   4 +-
 Documentation/media/uapi/v4l/vidioc-g-tuner.rst    |  12 +--
 .../media/uapi/v4l/vidioc-prepare-buf.rst          |   2 +-
 Documentation/media/uapi/v4l/vidioc-qbuf.rst       |  20 ++--
 .../media/uapi/v4l/vidioc-query-dv-timings.rst     |   2 +-
 Documentation/media/uapi/v4l/vidioc-querybuf.rst   |  14 +--
 Documentation/media/uapi/v4l/vidioc-querycap.rst   |   8 +-
 Documentation/media/uapi/v4l/vidioc-queryctrl.rst  |   4 +-
 Documentation/media/uapi/v4l/vidioc-reqbufs.rst    |   6 +-
 .../media/uapi/v4l/vidioc-s-hw-freq-seek.rst       |  22 ++---
 Documentation/media/uapi/v4l/vidioc-streamon.rst   |   2 +-
 .../uapi/v4l/vidioc-subdev-enum-frame-interval.rst |   2 +-
 .../media/uapi/v4l/vidioc-subdev-g-crop.rst        |   2 +-
 .../uapi/v4l/vidioc-subdev-g-frame-interval.rst    |   2 +-
 .../media/uapi/v4l/vidioc-subdev-g-selection.rst   |   2 +-
 .../media/uapi/v4l/vidioc-subscribe-event.rst      |   2 +-
 117 files changed, 603 insertions(+), 603 deletions(-)

diff --git a/Documentation/media/kapi/v4l2-event.rst b/Documentation/media/kapi/v4l2-event.rst
index f962686a7b63..9a5e31546ae3 100644
--- a/Documentation/media/kapi/v4l2-event.rst
+++ b/Documentation/media/kapi/v4l2-event.rst
@@ -40,7 +40,7 @@ A good example of these ``replace``/``merge`` callbacks is in v4l2-event.c:
 In order to queue events to video device, drivers should call:
 
 	:c:func:`v4l2_event_queue <v4l2_event_queue>`
-	(:c:type:`vdev <video_device>`, :ref:`ev <v4l2-event>`)
+	(:c:type:`vdev <video_device>`, :c:type:`ev <v4l2_event>`)
 
 The driver's only responsibility is to fill in the type and the data fields.
 The other fields will be filled in by V4L2.
@@ -51,7 +51,7 @@ Event subscription
 Subscribing to an event is via:
 
 	:c:func:`v4l2_event_subscribe <v4l2_event_subscribe>`
-	(:c:type:`fh <v4l2_fh>`, :ref:`sub <v4l2-event-subscription>` ,
+	(:c:type:`fh <v4l2_fh>`, :c:type:`sub <v4l2_event_subscription>` ,
 	elems, :c:type:`ops <v4l2_subscribed_event_ops>`)
 
 
@@ -86,7 +86,7 @@ Unsubscribing an event
 Unsubscribing to an event is via:
 
 	:c:func:`v4l2_event_unsubscribe <v4l2_event_unsubscribe>`
-	(:c:type:`fh <v4l2_fh>`, :ref:`sub <v4l2-event-subscription>`)
+	(:c:type:`fh <v4l2_fh>`, :c:type:`sub <v4l2_event_subscription>`)
 
 This function is used to implement :c:type:`video_device`->
 :c:type:`ioctl_ops <v4l2_ioctl_ops>`-> ``vidioc_unsubscribe_event``.
diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
index 14d7f6a19455..a35dca281178 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
@@ -36,12 +36,12 @@ Description
 
 All cec devices must support :ref:`ioctl CEC_ADAP_G_CAPS <CEC_ADAP_G_CAPS>`. To query
 device information, applications call the ioctl with a pointer to a
-struct :ref:`cec_caps <cec-caps>`. The driver fills the structure and
+struct :c:type:`cec_caps`. The driver fills the structure and
 returns the information to the application. The ioctl never fails.
 
 .. tabularcolumns:: |p{1.2cm}|p{2.5cm}|p{13.8cm}|
 
-.. _cec-caps:
+.. c:type:: cec_caps
 
 .. flat-table:: struct cec_caps
     :header-rows:  0
diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
index 1a920109072c..bd0756ff022e 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
@@ -68,7 +68,7 @@ logical address types are already defined will return with error ``EBUSY``.
 
 .. tabularcolumns:: |p{1.0cm}|p{7.5cm}|p{8.0cm}|
 
-.. _cec-log-addrs:
+.. c:type:: cec_log_addrs
 
 .. cssclass:: longtable
 
diff --git a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
index b7f104802045..10228eb0fd4a 100644
--- a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
@@ -105,7 +105,7 @@ it is guaranteed that the state did change in between the two events.
 
 .. tabularcolumns:: |p{1.0cm}|p{4.2cm}|p{2.5cm}|p{8.8cm}|
 
-.. _cec-event:
+.. c:type:: cec_event
 
 .. flat-table:: struct cec_event
     :header-rows:  0
diff --git a/Documentation/media/uapi/cec/cec-ioc-receive.rst b/Documentation/media/uapi/cec/cec-ioc-receive.rst
index 025a3851ab76..f015f1259b27 100644
--- a/Documentation/media/uapi/cec/cec-ioc-receive.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-receive.rst
@@ -76,7 +76,7 @@ result.
 
 .. tabularcolumns:: |p{1.0cm}|p{3.5cm}|p{13.0cm}|
 
-.. _cec-msg:
+.. c:type:: cec_msg
 
 .. cssclass:: longtable
 
diff --git a/Documentation/media/uapi/dvb/audio_data_types.rst b/Documentation/media/uapi/dvb/audio_data_types.rst
index 4a53127eb13a..0b14c2dfc98c 100644
--- a/Documentation/media/uapi/dvb/audio_data_types.rst
+++ b/Documentation/media/uapi/dvb/audio_data_types.rst
@@ -71,7 +71,7 @@ the following values.
     } audio_channel_select_t;
 
 
-.. _audio-status:
+.. c:type:: audio_status
 
 struct audio_status
 ===================
@@ -93,7 +93,7 @@ about various states of the playback operation.
     } audio_status_t;
 
 
-.. _audio-mixer:
+.. c:type:: audio_mixer
 
 struct audio_mixer
 ==================
@@ -132,7 +132,7 @@ following bits set according to the hardwares capabilities.
      #define AUDIO_CAP_AC3  256
 
 
-.. _audio-karaoke:
+.. c:type:: audio_karaoke
 
 struct audio_karaoke
 ====================
diff --git a/Documentation/media/uapi/dvb/ca_data_types.rst b/Documentation/media/uapi/dvb/ca_data_types.rst
index 025f910ae945..d9e27c77426c 100644
--- a/Documentation/media/uapi/dvb/ca_data_types.rst
+++ b/Documentation/media/uapi/dvb/ca_data_types.rst
@@ -7,7 +7,7 @@ CA Data Types
 *************
 
 
-.. _ca-slot-info:
+.. c:type:: ca_slot_info
 
 ca_slot_info_t
 ==============
@@ -31,7 +31,7 @@ ca_slot_info_t
     } ca_slot_info_t;
 
 
-.. _ca-descr-info:
+.. c:type:: ca_descr_info
 
 ca_descr_info_t
 ===============
@@ -48,7 +48,7 @@ ca_descr_info_t
     } ca_descr_info_t;
 
 
-.. _ca-caps:
+.. c:type:: ca_caps
 
 ca_caps_t
 =========
@@ -64,7 +64,7 @@ ca_caps_t
      } ca_cap_t;
 
 
-.. _ca-msg:
+.. c:type:: ca_msg
 
 ca_msg_t
 ========
@@ -81,7 +81,7 @@ ca_msg_t
     } ca_msg_t;
 
 
-.. _ca-descr:
+.. c:type:: ca_descr
 
 ca_descr_t
 ==========
@@ -96,7 +96,7 @@ ca_descr_t
     } ca_descr_t;
 
 
-.. _ca-pid:
+.. c:type:: ca_pid
 
 ca-pid
 ======
diff --git a/Documentation/media/uapi/dvb/dmx_types.rst b/Documentation/media/uapi/dvb/dmx_types.rst
index efd564035958..65de705fa1ef 100644
--- a/Documentation/media/uapi/dvb/dmx_types.rst
+++ b/Documentation/media/uapi/dvb/dmx_types.rst
@@ -120,7 +120,7 @@ dmx_pes_type_t
     } dmx_pes_type_t;
 
 
-.. _dmx-filter:
+.. c:type:: dmx_filter
 
 struct dmx_filter
 =================
@@ -136,7 +136,7 @@ struct dmx_filter
     } dmx_filter_t;
 
 
-.. _dmx-sct-filter-params:
+.. c:type:: dmx_sct_filter_params
 
 struct dmx_sct_filter_params
 ============================
@@ -157,7 +157,7 @@ struct dmx_sct_filter_params
     };
 
 
-.. _dmx-pes-filter-params:
+.. c:type:: dmx_pes_filter_params
 
 struct dmx_pes_filter_params
 ============================
@@ -194,7 +194,7 @@ struct dmx_event
      };
 
 
-.. _dmx-stc:
+.. c:type:: dmx_stc
 
 struct dmx_stc
 ==============
@@ -209,7 +209,7 @@ struct dmx_stc
     };
 
 
-.. _dmx-caps:
+.. c:type:: dmx_caps
 
 struct dmx_caps
 ===============
diff --git a/Documentation/media/uapi/dvb/dtv-fe-stats.rst b/Documentation/media/uapi/dvb/dtv-fe-stats.rst
index 7c105e2ab27e..e8a02a1f138d 100644
--- a/Documentation/media/uapi/dvb/dtv-fe-stats.rst
+++ b/Documentation/media/uapi/dvb/dtv-fe-stats.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _dtv-fe-stats:
+.. c:type:: dtv_fe_stats
 
 *******************
 struct dtv_fe_stats
diff --git a/Documentation/media/uapi/dvb/dtv-properties.rst b/Documentation/media/uapi/dvb/dtv-properties.rst
index c13be5de4302..48c4e834ad11 100644
--- a/Documentation/media/uapi/dvb/dtv-properties.rst
+++ b/Documentation/media/uapi/dvb/dtv-properties.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _dtv-properties:
+.. c:type:: dtv_properties
 
 *********************
 struct dtv_properties
diff --git a/Documentation/media/uapi/dvb/dtv-property.rst b/Documentation/media/uapi/dvb/dtv-property.rst
index 5073a49def2a..3ddc3474b00e 100644
--- a/Documentation/media/uapi/dvb/dtv-property.rst
+++ b/Documentation/media/uapi/dvb/dtv-property.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _dtv-property:
+.. c:type:: dtv_property
 
 *******************
 struct dtv_property
diff --git a/Documentation/media/uapi/dvb/dtv-stats.rst b/Documentation/media/uapi/dvb/dtv-stats.rst
index 2cfdca00f164..35239e72bf74 100644
--- a/Documentation/media/uapi/dvb/dtv-stats.rst
+++ b/Documentation/media/uapi/dvb/dtv-stats.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _dtv-stats:
+.. c:type:: dtv_stats
 
 ****************
 struct dtv_stats
diff --git a/Documentation/media/uapi/dvb/dvb-frontend-event.rst b/Documentation/media/uapi/dvb/dvb-frontend-event.rst
index 78e72feaa178..2088bc6cacd8 100644
--- a/Documentation/media/uapi/dvb/dvb-frontend-event.rst
+++ b/Documentation/media/uapi/dvb/dvb-frontend-event.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _dvb-frontend-event:
+.. c:type:: dvb_frontend_event
 
 ***************
 frontend events
diff --git a/Documentation/media/uapi/dvb/dvb-frontend-parameters.rst b/Documentation/media/uapi/dvb/dvb-frontend-parameters.rst
index 16cb581d5cff..bf31411fc9df 100644
--- a/Documentation/media/uapi/dvb/dvb-frontend-parameters.rst
+++ b/Documentation/media/uapi/dvb/dvb-frontend-parameters.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _dvb-frontend-parameters:
+.. c:type:: dvb_frontend_parameters
 
 *******************
 frontend parameters
@@ -49,7 +49,7 @@ frontends the ``frequency`` specifies the absolute frequency and is
 given in Hz.
 
 
-.. _dvb-qpsk-parameters:
+.. c:type:: dvb_qpsk_parameters
 
 QPSK parameters
 ===============
@@ -66,7 +66,7 @@ structure:
      };
 
 
-.. _dvb-qam-parameters:
+.. c:type:: dvb_qam_parameters
 
 QAM parameters
 ==============
@@ -83,7 +83,7 @@ for cable QAM frontend you use the ``dvb_qam_parameters`` structure:
      };
 
 
-.. _dvb-vsb-parameters:
+.. c:type:: dvb_vsb_parameters
 
 VSB parameters
 ==============
@@ -98,7 +98,7 @@ ATSC frontends are supported by the ``dvb_vsb_parameters`` structure:
     };
 
 
-.. _dvb-ofdm-parameters:
+.. c:type:: dvb_ofdm_parameters
 
 OFDM parameters
 ===============
diff --git a/Documentation/media/uapi/dvb/dvbproperty.rst b/Documentation/media/uapi/dvb/dvbproperty.rst
index a5a859a45381..906f3e651e10 100644
--- a/Documentation/media/uapi/dvb/dvbproperty.rst
+++ b/Documentation/media/uapi/dvb/dvbproperty.rst
@@ -23,7 +23,7 @@ union/struct based approach, in favor of a properties set approach.
 .. note::
 
    On Linux DVB API version 3, setting a frontend were done via
-   :ref:`struct dvb_frontend_parameters <dvb-frontend-parameters>`.
+   :c:type:`struct dvb_frontend_parameters <dvb_frontend_parameters>`.
    This got replaced on version 5 (also called "S2API", as this API were
    added originally_enabled to provide support for DVB-S2), because the
    old API has a very limited support to new standards and new hardware.
diff --git a/Documentation/media/uapi/dvb/fe-diseqc-recv-slave-reply.rst b/Documentation/media/uapi/dvb/fe-diseqc-recv-slave-reply.rst
index e1b6da08b3a1..9fda5546d8c1 100644
--- a/Documentation/media/uapi/dvb/fe-diseqc-recv-slave-reply.rst
+++ b/Documentation/media/uapi/dvb/fe-diseqc-recv-slave-reply.rst
@@ -27,7 +27,7 @@ Arguments
 
 ``argp``
     pointer to struct
-    :ref:`dvb_diseqc_slave_reply <dvb-diseqc-slave-reply>`
+    :c:type:`dvb_diseqc_slave_reply`
 
 
 Description
@@ -35,7 +35,7 @@ Description
 
 Receives reply from a DiSEqC 2.0 command.
 
-.. _dvb-diseqc-slave-reply:
+.. c:type:: dvb_diseqc_slave_reply
 
 struct dvb_diseqc_slave_reply
 -----------------------------
diff --git a/Documentation/media/uapi/dvb/fe-diseqc-send-master-cmd.rst b/Documentation/media/uapi/dvb/fe-diseqc-send-master-cmd.rst
index ea090cbeaae0..72cb4ebd95c0 100644
--- a/Documentation/media/uapi/dvb/fe-diseqc-send-master-cmd.rst
+++ b/Documentation/media/uapi/dvb/fe-diseqc-send-master-cmd.rst
@@ -27,7 +27,7 @@ Arguments
 
 ``argp``
     pointer to struct
-    :ref:`dvb_diseqc_master_cmd <dvb-diseqc-master-cmd>`
+    :c:type:`dvb_diseqc_master_cmd`
 
 
 Description
@@ -35,7 +35,7 @@ Description
 
 Sends a DiSEqC command to the antenna subsystem.
 
-.. _dvb-diseqc-master-cmd:
+.. c:type:: dvb_diseqc_master_cmd
 
 struct dvb_diseqc_master_cmd
 ============================
diff --git a/Documentation/media/uapi/dvb/fe-get-info.rst b/Documentation/media/uapi/dvb/fe-get-info.rst
index c367b5ab023c..3557b756ef27 100644
--- a/Documentation/media/uapi/dvb/fe-get-info.rst
+++ b/Documentation/media/uapi/dvb/fe-get-info.rst
@@ -27,7 +27,7 @@ Arguments
 
 ``argp``
     pointer to struct struct
-    :ref:`dvb_frontend_info <dvb-frontend-info>`
+    :c:type:`dvb_frontend_info`
 
 
 Description
@@ -40,7 +40,7 @@ takes a pointer to dvb_frontend_info which is filled by the driver.
 When the driver is not compatible with this specification the ioctl
 returns an error.
 
-.. _dvb-frontend-info:
+.. c:type:: dvb_frontend_info
 
 struct dvb_frontend_info
 ========================
diff --git a/Documentation/media/uapi/dvb/fe-get-property.rst b/Documentation/media/uapi/dvb/fe-get-property.rst
index 51daf016a8eb..015d4db597b5 100644
--- a/Documentation/media/uapi/dvb/fe-get-property.rst
+++ b/Documentation/media/uapi/dvb/fe-get-property.rst
@@ -29,7 +29,7 @@ Arguments
     File descriptor returned by :ref:`open() <frontend_f_open>`.
 
 ``argp``
-    pointer to struct :ref:`dtv_properties <dtv-properties>`
+    pointer to struct :c:type:`dtv_properties`
 
 
 Description
diff --git a/Documentation/media/uapi/dvb/fe-type-t.rst b/Documentation/media/uapi/dvb/fe-type-t.rst
index fa377fe9e104..03a6c75bf5de 100644
--- a/Documentation/media/uapi/dvb/fe-type-t.rst
+++ b/Documentation/media/uapi/dvb/fe-type-t.rst
@@ -78,7 +78,7 @@ at the above, as they're supported via the new
 ioctl's, using the :ref:`DTV_DELIVERY_SYSTEM <DTV-DELIVERY-SYSTEM>`
 parameter.
 
-In the old days, struct :ref:`dvb_frontend_info <dvb-frontend-info>`
+In the old days, struct :c:type:`dvb_frontend_info`
 used to contain ``fe_type_t`` field to indicate the delivery systems,
 filled with either FE_QPSK, FE_QAM, FE_OFDM or FE_ATSC. While this
 is still filled to keep backward compatibility, the usage of this field
@@ -87,7 +87,7 @@ devices support multiple delivery systems. Please use
 :ref:`DTV_ENUM_DELSYS <DTV-ENUM-DELSYS>` instead.
 
 On devices that support multiple delivery systems, struct
-:ref:`dvb_frontend_info <dvb-frontend-info>`::``fe_type_t`` is
+:c:type:`dvb_frontend_info`::``fe_type_t`` is
 filled with the currently standard, as selected by the last call to
 :ref:`FE_SET_PROPERTY <FE_GET_PROPERTY>` using the
 :ref:`DTV_DELIVERY_SYSTEM <DTV-DELIVERY-SYSTEM>` property.
diff --git a/Documentation/media/uapi/dvb/frontend-stat-properties.rst b/Documentation/media/uapi/dvb/frontend-stat-properties.rst
index 0fc4aaa304ff..e73754fd0631 100644
--- a/Documentation/media/uapi/dvb/frontend-stat-properties.rst
+++ b/Documentation/media/uapi/dvb/frontend-stat-properties.rst
@@ -20,7 +20,7 @@ standards, up to 3 groups of statistics can be provided, and
 plus one metric per each carrier group (called "layer" on ISDB).
 
 So, in order to be consistent with other delivery systems, the first
-value at :ref:`dtv_property.stat.dtv_stats <dtv-stats>` array refers
+value at :c:type:`dtv_property.stat.dtv_stats <dtv_stats>` array refers
 to the global metric. The other elements of the array represent each
 layer, starting from layer A(index 1), layer B (index 2) and so on.
 
diff --git a/Documentation/media/uapi/dvb/net-add-if.rst b/Documentation/media/uapi/dvb/net-add-if.rst
index dfb4509f816c..dbe80c91bdb0 100644
--- a/Documentation/media/uapi/dvb/net-add-if.rst
+++ b/Documentation/media/uapi/dvb/net-add-if.rst
@@ -26,7 +26,7 @@ Arguments
     File descriptor returned by :ref:`open() <frontend_f_open>`.
 
 ``net_if``
-    pointer to struct :ref:`dvb_net_if <dvb-net-if>`
+    pointer to struct :c:type:`dvb_net_if`
 
 
 Description
@@ -38,7 +38,7 @@ ULE) and the interface number for the new interface to be created. When
 the system call successfully returns, a new virtual network interface is
 created.
 
-The struct :ref:`dvb_net_if <dvb-net-if>`::ifnum field will be
+The struct :c:type:`dvb_net_if`::ifnum field will be
 filled with the number of the created interface.
 
 
@@ -47,7 +47,7 @@ filled with the number of the created interface.
 struct dvb_net_if description
 =============================
 
-.. _dvb-net-if:
+.. c:type:: dvb_net_if
 
 .. flat-table:: struct dvb_net_if
     :header-rows:  1
diff --git a/Documentation/media/uapi/dvb/net-get-if.rst b/Documentation/media/uapi/dvb/net-get-if.rst
index dd9d6a3c4a2b..1bb8ee0cbced 100644
--- a/Documentation/media/uapi/dvb/net-get-if.rst
+++ b/Documentation/media/uapi/dvb/net-get-if.rst
@@ -26,15 +26,15 @@ Arguments
     File descriptor returned by :ref:`open() <frontend_f_open>`.
 
 ``net_if``
-    pointer to struct :ref:`dvb_net_if <dvb-net-if>`
+    pointer to struct :c:type:`dvb_net_if`
 
 
 Description
 ===========
 
 The NET_GET_IF ioctl uses the interface number given by the struct
-:ref:`dvb_net_if <dvb-net-if>`::ifnum field and fills the content of
-struct :ref:`dvb_net_if <dvb-net-if>` with the packet ID and
+:c:type:`dvb_net_if`::ifnum field and fills the content of
+struct :c:type:`dvb_net_if` with the packet ID and
 encapsulation type used on such interface. If the interface was not
 created yet with :ref:`NET_ADD_IF <net>`, it will return -1 and fill
 the ``errno`` with ``EINVAL`` error code.
diff --git a/Documentation/media/uapi/dvb/video_types.rst b/Documentation/media/uapi/dvb/video_types.rst
index 671f365ceeb4..640a21de6b8a 100644
--- a/Documentation/media/uapi/dvb/video_types.rst
+++ b/Documentation/media/uapi/dvb/video_types.rst
@@ -95,7 +95,7 @@ representing the state of video playback.
     } video_play_state_t;
 
 
-.. _video-command:
+.. c:type:: video_command
 
 struct video_command
 ====================
@@ -146,7 +146,7 @@ video_size_t
     } video_size_t;
 
 
-.. _video-event:
+.. c:type:: video_event
 
 struct video_event
 ==================
@@ -172,7 +172,7 @@ VIDEO_GET_EVENT call.
     };
 
 
-.. _video-status:
+.. c:type:: video_status
 
 struct video_status
 ===================
@@ -203,7 +203,7 @@ case the source video format is not the same as the format of the output
 device.
 
 
-.. _video-still-picture:
+.. c:type:: video_still_picture
 
 struct video_still_picture
 ==========================
@@ -271,7 +271,7 @@ output. The following system types can be set:
     } video_system_t;
 
 
-.. _video-highlight:
+.. c:type:: video_highlight
 
 struct video_highlight
 ======================
@@ -302,7 +302,7 @@ information. The call expects the following format for that information:
      } video_highlight_t;
 
 
-.. _video-spu:
+.. c:type:: video_spu
 
 struct video_spu
 ================
@@ -320,7 +320,7 @@ to the following format:
      } video_spu_t;
 
 
-.. _video-spu-palette:
+.. c:type:: video_spu_palette
 
 struct video_spu_palette
 ========================
@@ -338,7 +338,7 @@ VIDEO_SPU_PALETTE:
      } video_spu_palette_t;
 
 
-.. _video-navi-pack:
+.. c:type:: video_navi_pack
 
 struct video_navi_pack
 ======================
diff --git a/Documentation/media/uapi/mediactl/media-ioc-device-info.rst b/Documentation/media/uapi/mediactl/media-ioc-device-info.rst
index 412014110570..f690f9afc470 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-device-info.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-device-info.rst
@@ -33,12 +33,12 @@ Description
 
 All media devices must support the ``MEDIA_IOC_DEVICE_INFO`` ioctl. To
 query device information, applications call the ioctl with a pointer to
-a struct :ref:`media_device_info <media-device-info>`. The driver
+a struct :c:type:`media_device_info`. The driver
 fills the structure and returns the information to the application. The
 ioctl never fails.
 
 
-.. _media-device-info:
+.. c:type:: media_device_info
 
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
diff --git a/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst b/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst
index 628e91aeda97..0fd329279bef 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-enum-entities.rst
@@ -32,7 +32,7 @@ Description
 ===========
 
 To query the attributes of an entity, applications set the id field of a
-struct :ref:`media_entity_desc <media-entity-desc>` structure and
+struct :c:type:`media_entity_desc` structure and
 call the MEDIA_IOC_ENUM_ENTITIES ioctl with a pointer to this
 structure. The driver fills the rest of the structure or returns an
 EINVAL error code when the id is invalid.
@@ -49,7 +49,7 @@ enumerate entities by calling MEDIA_IOC_ENUM_ENTITIES with increasing
 id's until they get an error.
 
 
-.. _media-entity-desc:
+.. c:type:: media_entity_desc
 
 .. tabularcolumns:: |p{1.5cm}|p{1.5cm}|p{1.5cm}|p{1.5cm}|p{11.5cm}|
 
@@ -195,5 +195,5 @@ appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
 
 EINVAL
-    The struct :ref:`media_entity_desc <media-entity-desc>` ``id``
+    The struct :c:type:`media_entity_desc` ``id``
     references a non-existing entity.
diff --git a/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst b/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst
index c81765f14b9f..d05be16ffaf6 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst
@@ -32,10 +32,10 @@ Description
 ===========
 
 To enumerate pads and/or links for a given entity, applications set the
-entity field of a struct :ref:`media_links_enum <media-links-enum>`
+entity field of a struct :c:type:`media_links_enum`
 structure and initialize the struct
-:ref:`media_pad_desc <media-pad-desc>` and struct
-:ref:`media_link_desc <media-link-desc>` structure arrays pointed by
+:c:type:`media_pad_desc` and struct
+:c:type:`media_link_desc` structure arrays pointed by
 the ``pads`` and ``links`` fields. They then call the
 MEDIA_IOC_ENUM_LINKS ioctl with a pointer to this structure.
 
@@ -53,7 +53,7 @@ Only forward links that originate at one of the entity's source pads are
 returned during the enumeration process.
 
 
-.. _media-links-enum:
+.. c:type:: media_links_enum
 
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
@@ -73,7 +73,7 @@ returned during the enumeration process.
 
     -  .. row 2
 
-       -  struct :ref:`media_pad_desc <media-pad-desc>`
+       -  struct :c:type:`media_pad_desc`
 
        -  \*\ ``pads``
 
@@ -82,7 +82,7 @@ returned during the enumeration process.
 
     -  .. row 3
 
-       -  struct :ref:`media_link_desc <media-link-desc>`
+       -  struct :c:type:`media_link_desc`
 
        -  \*\ ``links``
 
@@ -91,7 +91,7 @@ returned during the enumeration process.
 
 
 
-.. _media-pad-desc:
+.. c:type:: media_pad_desc
 
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
@@ -127,7 +127,7 @@ returned during the enumeration process.
 
 
 
-.. _media-link-desc:
+.. c:type:: media_link_desc
 
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
@@ -139,7 +139,7 @@ returned during the enumeration process.
 
     -  .. row 1
 
-       -  struct :ref:`media_pad_desc <media-pad-desc>`
+       -  struct :c:type:`media_pad_desc`
 
        -  ``source``
 
@@ -147,7 +147,7 @@ returned during the enumeration process.
 
     -  .. row 2
 
-       -  struct :ref:`media_pad_desc <media-pad-desc>`
+       -  struct :c:type:`media_pad_desc`
 
        -  ``sink``
 
@@ -170,5 +170,5 @@ appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
 
 EINVAL
-    The struct :ref:`media_links_enum <media-links-enum>` ``id``
+    The struct :c:type:`media_links_enum` ``id``
     references a non-existing entity.
diff --git a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
index c246df06ff7f..0b26fd865b72 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-g-topology.rst
@@ -33,7 +33,7 @@ Description
 
 The typical usage of this ioctl is to call it twice. On the first call,
 the structure defined at struct
-:ref:`media_v2_topology <media-v2-topology>` should be zeroed. At
+:c:type:`media_v2_topology` should be zeroed. At
 return, if no errors happen, this ioctl will return the
 ``topology_version`` and the total number of entities, interfaces, pads
 and links.
@@ -48,7 +48,7 @@ desired arrays with the media graph elements.
 
 .. tabularcolumns:: |p{1.6cm}|p{3.2cm}|p{12.7cm}|
 
-.. _media-v2-topology:
+.. c:type:: media_v2_topology
 
 .. flat-table:: struct media_v2_topology
     :header-rows:  0
@@ -143,7 +143,7 @@ desired arrays with the media graph elements.
 
 .. tabularcolumns:: |p{1.6cm}|p{3.2cm}|p{12.7cm}|
 
-.. _media-v2-entity:
+.. c:type:: media_v2_entity
 
 .. flat-table:: struct media_v2_entity
     :header-rows:  0
@@ -187,7 +187,7 @@ desired arrays with the media graph elements.
 
 .. tabularcolumns:: |p{1.6cm}|p{3.2cm}|p{12.7cm}|
 
-.. _media-v2-interface:
+.. c:type:: media_v2_interface
 
 .. flat-table:: struct media_v2_interface
     :header-rows:  0
@@ -239,7 +239,7 @@ desired arrays with the media graph elements.
 
 .. tabularcolumns:: |p{1.6cm}|p{3.2cm}|p{12.7cm}|
 
-.. _media-v2-intf-devnode:
+.. c:type:: media_v2_intf_devnode
 
 .. flat-table:: struct media_v2_interface
     :header-rows:  0
@@ -266,7 +266,7 @@ desired arrays with the media graph elements.
 
 .. tabularcolumns:: |p{1.6cm}|p{3.2cm}|p{12.7cm}|
 
-.. _media-v2-pad:
+.. c:type:: media_v2_pad
 
 .. flat-table:: struct media_v2_pad
     :header-rows:  0
@@ -310,7 +310,7 @@ desired arrays with the media graph elements.
 
 .. tabularcolumns:: |p{1.6cm}|p{3.2cm}|p{12.7cm}|
 
-.. _media-v2-link:
+.. c:type:: media_v2_link
 
 .. flat-table:: struct media_v2_pad
     :header-rows:  0
diff --git a/Documentation/media/uapi/mediactl/media-ioc-setup-link.rst b/Documentation/media/uapi/mediactl/media-ioc-setup-link.rst
index 35a189e19962..ae5194940100 100644
--- a/Documentation/media/uapi/mediactl/media-ioc-setup-link.rst
+++ b/Documentation/media/uapi/mediactl/media-ioc-setup-link.rst
@@ -32,7 +32,7 @@ Description
 ===========
 
 To change link properties applications fill a struct
-:ref:`media_link_desc <media-link-desc>` with link identification
+:c:type:`media_link_desc` with link identification
 information (source and sink pad) and the new requested link flags. They
 then call the MEDIA_IOC_SETUP_LINK ioctl with a pointer to that
 structure.
@@ -61,6 +61,6 @@ appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
 
 EINVAL
-    The struct :ref:`media_link_desc <media-link-desc>` references a
+    The struct :c:type:`media_link_desc` references a
     non-existing link, or the link is immutable and an attempt to modify
     its configuration was made.
diff --git a/Documentation/media/uapi/v4l/audio.rst b/Documentation/media/uapi/v4l/audio.rst
index b8059fb05372..5ec99a2809fe 100644
--- a/Documentation/media/uapi/v4l/audio.rst
+++ b/Documentation/media/uapi/v4l/audio.rst
@@ -21,15 +21,15 @@ more than one video input or output. Assumed two composite video inputs
 and two audio inputs exist, there may be up to four valid combinations.
 The relation of video and audio connectors is defined in the
 ``audioset`` field of the respective struct
-:ref:`v4l2_input <v4l2-input>` or struct
-:ref:`v4l2_output <v4l2-output>`, where each bit represents the index
+:c:type:`v4l2_input` or struct
+:c:type:`v4l2_output`, where each bit represents the index
 number, starting at zero, of one audio input or output.
 
 To learn about the number and attributes of the available inputs and
 outputs applications can enumerate them with the
 :ref:`VIDIOC_ENUMAUDIO` and
 :ref:`VIDIOC_ENUMAUDOUT <VIDIOC_ENUMAUDOUT>` ioctl, respectively.
-The struct :ref:`v4l2_audio <v4l2-audio>` returned by the
+The struct :c:type:`v4l2_audio` returned by the
 :ref:`VIDIOC_ENUMAUDIO` ioctl also contains signal
 :status information applicable when the current audio input is queried.
 
@@ -53,7 +53,7 @@ Drivers must implement all audio input ioctls when the device has
 multiple selectable audio inputs, all audio output ioctls when the
 device has multiple selectable audio outputs. When the device has any
 audio inputs or outputs the driver must set the ``V4L2_CAP_AUDIO`` flag
-in the struct :ref:`v4l2_capability <v4l2-capability>` returned by
+in the struct :c:type:`v4l2_capability` returned by
 the :ref:`VIDIOC_QUERYCAP` ioctl.
 
 
@@ -91,7 +91,7 @@ Example: Switching to the first audio input
     }
 
 .. [#f1]
-   Actually struct :ref:`v4l2_audio <v4l2-audio>` ought to have a
-   ``tuner`` field like struct :ref:`v4l2_input <v4l2-input>`, not
+   Actually struct :c:type:`v4l2_audio` ought to have a
+   ``tuner`` field like struct :c:type:`v4l2_input`, not
    only making the API more consistent but also permitting radio devices
    with multiple tuners.
diff --git a/Documentation/media/uapi/v4l/buffer.rst b/Documentation/media/uapi/v4l/buffer.rst
index 7bab30b59eae..a52a586b0b41 100644
--- a/Documentation/media/uapi/v4l/buffer.rst
+++ b/Documentation/media/uapi/v4l/buffer.rst
@@ -11,14 +11,14 @@ the Streaming I/O methods. In the multi-planar API, the data is held in
 planes, while the buffer structure acts as a container for the planes.
 Only pointers to buffers (planes) are exchanged, the data itself is not
 copied. These pointers, together with meta-information like timestamps
-or field parity, are stored in a struct :ref:`struct v4l2_buffer <v4l2-buffer>`,
+or field parity, are stored in a struct :c:type:`struct v4l2_buffer <v4l2_buffer>`,
 argument to the :ref:`VIDIOC_QUERYBUF`,
 :ref:`VIDIOC_QBUF` and
 :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctl. In the multi-planar API,
-some plane-specific members of struct :ref:`struct v4l2_buffer <v4l2-buffer>`,
+some plane-specific members of struct :c:type:`struct v4l2_buffer <v4l2_buffer>`,
 such as pointers and sizes for each plane, are stored in struct
-:ref:`struct v4l2_plane <v4l2-plane>` instead. In that case, struct
-:ref:`struct v4l2_buffer <v4l2-buffer>` contains an array of plane structures.
+:c:type:`struct v4l2_plane <v4l2_plane>` instead. In that case, struct
+:c:type:`struct v4l2_buffer <v4l2_buffer>` contains an array of plane structures.
 
 Dequeued video buffers come with timestamps. The driver decides at which
 part of the frame and with which clock the timestamp is taken. Please
@@ -34,7 +34,7 @@ flags are copied from the OUTPUT video buffer to the CAPTURE video
 buffer.
 
 
-.. _v4l2-buffer:
+.. c:type:: v4l2_buffer
 
 struct v4l2_buffer
 ==================
@@ -60,7 +60,7 @@ struct v4l2_buffer
 	  :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>`, then it is set by the
 	  driver. This field can range from zero to the number of buffers
 	  allocated with the :ref:`VIDIOC_REQBUFS` ioctl
-	  (struct :ref:`v4l2_requestbuffers <v4l2-requestbuffers>`
+	  (struct :c:type:`v4l2_requestbuffers`
 	  ``count``), plus any buffers allocated with
 	  :ref:`VIDIOC_CREATE_BUFS` minus one.
 
@@ -72,8 +72,8 @@ struct v4l2_buffer
 
        -
        -  Type of the buffer, same as struct
-	  :ref:`v4l2_format <v4l2-format>` ``type`` or struct
-	  :ref:`v4l2_requestbuffers <v4l2-requestbuffers>` ``type``, set
+	  :c:type:`v4l2_format` ``type`` or struct
+	  :c:type:`v4l2_requestbuffers` ``type``, set
 	  by the application. See :ref:`v4l2-buf-type`
 
     -  .. row 3
@@ -134,7 +134,7 @@ struct v4l2_buffer
 
     -  .. row 7
 
-       -  struct :ref:`v4l2_timecode <v4l2-timecode>`
+       -  struct :c:type:`v4l2_timecode`
 
        -  ``timecode``
 
@@ -229,9 +229,9 @@ struct v4l2_buffer
        -  ``*planes``
 
        -  When using the multi-planar API, contains a userspace pointer to
-	  an array of struct :ref:`v4l2_plane <v4l2-plane>`. The size of
+	  an array of struct :c:type:`v4l2_plane`. The size of
 	  the array should be put in the ``length`` field of this
-	  :ref:`struct v4l2_buffer <v4l2-buffer>` structure.
+	  :c:type:`struct v4l2_buffer <v4l2_buffer>` structure.
 
     -  .. row 15
 
@@ -281,7 +281,7 @@ struct v4l2_buffer
 
 
 
-.. _v4l2-plane:
+.. c:type:: v4l2_plane
 
 struct v4l2_plane
 =================
@@ -344,10 +344,10 @@ struct v4l2_plane
        -  ``mem_offset``
 
        -  When the memory type in the containing struct
-	  :ref:`v4l2_buffer <v4l2-buffer>` is ``V4L2_MEMORY_MMAP``, this
+	  :c:type:`v4l2_buffer` is ``V4L2_MEMORY_MMAP``, this
 	  is the value that should be passed to :ref:`mmap() <func-mmap>`,
 	  similar to the ``offset`` field in struct
-	  :ref:`v4l2_buffer <v4l2-buffer>`.
+	  :c:type:`v4l2_buffer`.
 
     -  .. row 5
 
@@ -357,7 +357,7 @@ struct v4l2_plane
        -  ``userptr``
 
        -  When the memory type in the containing struct
-	  :ref:`v4l2_buffer <v4l2-buffer>` is ``V4L2_MEMORY_USERPTR``,
+	  :c:type:`v4l2_buffer` is ``V4L2_MEMORY_USERPTR``,
 	  this is a userspace pointer to the memory allocated for this plane
 	  by an application.
 
@@ -369,9 +369,9 @@ struct v4l2_plane
        -  ``fd``
 
        -  When the memory type in the containing struct
-	  :ref:`v4l2_buffer <v4l2-buffer>` is ``V4L2_MEMORY_DMABUF``,
+	  :c:type:`v4l2_buffer` is ``V4L2_MEMORY_DMABUF``,
 	  this is a file descriptor associated with a DMABUF buffer, similar
-	  to the ``fd`` field in struct :ref:`v4l2_buffer <v4l2-buffer>`.
+	  to the ``fd`` field in struct :c:type:`v4l2_buffer`.
 
     -  .. row 7
 
@@ -823,13 +823,13 @@ enum v4l2_memory
 Timecodes
 =========
 
-The :ref:`struct v4l2_timecode <v4l2-timecode>` structure is designed to hold a
+The :c:type:`struct v4l2_timecode <v4l2_timecode>` structure is designed to hold a
 :ref:`smpte12m` or similar timecode. (struct
 :c:type:`struct timeval` timestamps are stored in struct
-:ref:`v4l2_buffer <v4l2-buffer>` field ``timestamp``.)
+:c:type:`v4l2_buffer` field ``timestamp``.)
 
 
-.. _v4l2-timecode:
+.. c:type:: v4l2_timecode
 
 struct v4l2_timecode
 --------------------
diff --git a/Documentation/media/uapi/v4l/crop.rst b/Documentation/media/uapi/v4l/crop.rst
index 4622884b06ea..3ea733a8eef8 100644
--- a/Documentation/media/uapi/v4l/crop.rst
+++ b/Documentation/media/uapi/v4l/crop.rst
@@ -65,7 +65,7 @@ Cropping Structures
 
 For capture devices the coordinates of the top left corner, width and
 height of the area which can be sampled is given by the ``bounds``
-substructure of the struct :ref:`v4l2_cropcap <v4l2-cropcap>` returned
+substructure of the struct :c:type:`v4l2_cropcap` returned
 by the :ref:`VIDIOC_CROPCAP <VIDIOC_CROPCAP>` ioctl. To support a wide
 range of hardware this specification does not define an origin or units.
 However by convention drivers should horizontally count unscaled samples
@@ -77,8 +77,8 @@ can capture both fields.
 
 The top left corner, width and height of the source rectangle, that is
 the area actually sampled, is given by struct
-:ref:`v4l2_crop <v4l2-crop>` using the same coordinate system as
-struct :ref:`v4l2_cropcap <v4l2-cropcap>`. Applications can use the
+:c:type:`v4l2_crop` using the same coordinate system as
+struct :c:type:`v4l2_cropcap`. Applications can use the
 :ref:`VIDIOC_G_CROP <VIDIOC_G_CROP>` and :ref:`VIDIOC_S_CROP <VIDIOC_G_CROP>`
 ioctls to get and set this rectangle. It must lie completely within the
 capture boundaries and the driver may further adjust the requested size
@@ -86,7 +86,7 @@ and/or position according to hardware limitations.
 
 Each capture device has a default source rectangle, given by the
 ``defrect`` substructure of struct
-:ref:`v4l2_cropcap <v4l2-cropcap>`. The center of this rectangle
+:c:type:`v4l2_cropcap`. The center of this rectangle
 shall align with the center of the active picture area of the video
 signal, and cover what the driver writer considers the complete picture.
 Drivers shall reset the source rectangle to the default when the driver
@@ -104,11 +104,11 @@ Video hardware can have various cropping, insertion and scaling
 limitations. It may only scale up or down, support only discrete scaling
 factors, or have different scaling abilities in horizontal and vertical
 direction. Also it may not support scaling at all. At the same time the
-struct :ref:`v4l2_crop <v4l2-crop>` rectangle may have to be aligned,
+struct :c:type:`v4l2_crop` rectangle may have to be aligned,
 and both the source and target rectangles may have arbitrary upper and
 lower size limits. In particular the maximum ``width`` and ``height`` in
-struct :ref:`v4l2_crop <v4l2-crop>` may be smaller than the struct
-:ref:`v4l2_cropcap <v4l2-cropcap>`. ``bounds`` area. Therefore, as
+struct :c:type:`v4l2_crop` may be smaller than the struct
+:c:type:`v4l2_cropcap`. ``bounds`` area. Therefore, as
 usual, drivers are expected to adjust the requested parameters and
 return the actual values selected.
 
diff --git a/Documentation/media/uapi/v4l/dev-capture.rst b/Documentation/media/uapi/v4l/dev-capture.rst
index 8d049471e1c2..32b32055d070 100644
--- a/Documentation/media/uapi/v4l/dev-capture.rst
+++ b/Documentation/media/uapi/v4l/dev-capture.rst
@@ -26,7 +26,7 @@ Querying Capabilities
 Devices supporting the video capture interface set the
 ``V4L2_CAP_VIDEO_CAPTURE`` or ``V4L2_CAP_VIDEO_CAPTURE_MPLANE`` flag in
 the ``capabilities`` field of struct
-:ref:`v4l2_capability <v4l2-capability>` returned by the
+:c:type:`v4l2_capability` returned by the
 :ref:`VIDIOC_QUERYCAP` ioctl. As secondary device
 functions they may also support the :ref:`video overlay <overlay>`
 (``V4L2_CAP_VIDEO_OVERLAY``) and the :ref:`raw VBI capture <raw-vbi>`
@@ -64,18 +64,18 @@ Cropping initialization at minimum requires to reset the parameters to
 defaults. An example is given in :ref:`crop`.
 
 To query the current image format applications set the ``type`` field of
-a struct :ref:`v4l2_format <v4l2-format>` to
+a struct :c:type:`v4l2_format` to
 ``V4L2_BUF_TYPE_VIDEO_CAPTURE`` or
 ``V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE`` and call the
 :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` ioctl with a pointer to this
 structure. Drivers fill the struct
-:ref:`v4l2_pix_format <v4l2-pix-format>` ``pix`` or the struct
-:ref:`v4l2_pix_format_mplane <v4l2-pix-format-mplane>` ``pix_mp``
+:c:type:`v4l2_pix_format` ``pix`` or the struct
+:c:type:`v4l2_pix_format_mplane` ``pix_mp``
 member of the ``fmt`` union.
 
 To request different parameters applications set the ``type`` field of a
-struct :ref:`v4l2_format <v4l2-format>` as above and initialize all
-fields of the struct :ref:`v4l2_pix_format <v4l2-pix-format>`
+struct :c:type:`v4l2_format` as above and initialize all
+fields of the struct :c:type:`v4l2_pix_format`
 ``vbi`` member of the ``fmt`` union, or better just modify the results
 of :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>`, and call the :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`
 ioctl with a pointer to this structure. Drivers may adjust the
@@ -86,8 +86,8 @@ Like :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` the :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>`
 can be used to learn about hardware limitations without disabling I/O or
 possibly time consuming hardware preparations.
 
-The contents of struct :ref:`v4l2_pix_format <v4l2-pix-format>` and
-struct :ref:`v4l2_pix_format_mplane <v4l2-pix-format-mplane>` are
+The contents of struct :c:type:`v4l2_pix_format` and
+struct :c:type:`v4l2_pix_format_mplane` are
 discussed in :ref:`pixfmt`. See also the specification of the
 :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>`, :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` and :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` ioctls for
 details. Video capture devices must implement both the :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>`
diff --git a/Documentation/media/uapi/v4l/dev-osd.rst b/Documentation/media/uapi/v4l/dev-osd.rst
index 4e1ee79ec334..a6aaf28807a4 100644
--- a/Documentation/media/uapi/v4l/dev-osd.rst
+++ b/Documentation/media/uapi/v4l/dev-osd.rst
@@ -28,7 +28,7 @@ Querying Capabilities
 
 Devices supporting the *Video Output Overlay* interface set the
 ``V4L2_CAP_VIDEO_OUTPUT_OVERLAY`` flag in the ``capabilities`` field of
-struct :ref:`v4l2_capability <v4l2-capability>` returned by the
+struct :c:type:`v4l2_capability` returned by the
 :ref:`VIDIOC_QUERYCAP` ioctl.
 
 
@@ -41,7 +41,7 @@ accessible as a framebuffer device (``/dev/fbN``). Given a V4L2 device,
 applications can find the corresponding framebuffer device by calling
 the :ref:`VIDIOC_G_FBUF <VIDIOC_G_FBUF>` ioctl. It returns, amongst
 other information, the physical address of the framebuffer in the
-``base`` field of struct :ref:`v4l2_framebuffer <v4l2-framebuffer>`.
+``base`` field of struct :c:type:`v4l2_framebuffer`.
 The framebuffer device ioctl ``FBIOGET_FSCREENINFO`` returns the same
 address in the ``smem_start`` field of struct
 :c:type:`struct fb_fix_screeninfo`. The ``FBIOGET_FSCREENINFO``
@@ -114,18 +114,18 @@ sizes and positions of these rectangles. Further drivers may support any
 (or none) of the clipping/blending methods defined for the
 :ref:`Video Overlay <overlay>` interface.
 
-A struct :ref:`v4l2_window <v4l2-window>` defines the size of the
+A struct :c:type:`v4l2_window` defines the size of the
 source rectangle, its position in the framebuffer and the
 clipping/blending method to be used for the overlay. To get the current
 parameters applications set the ``type`` field of a struct
-:ref:`v4l2_format <v4l2-format>` to
+:c:type:`v4l2_format` to
 ``V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY`` and call the
 :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` ioctl. The driver fills the
-:ref:`struct v4l2_window <v4l2-window>` substructure named ``win``. It is not
+:c:type:`struct v4l2_window <v4l2_window>` substructure named ``win``. It is not
 possible to retrieve a previously programmed clipping list or bitmap.
 
 To program the source rectangle applications set the ``type`` field of a
-struct :ref:`v4l2_format <v4l2-format>` to
+struct :c:type:`v4l2_format` to
 ``V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY``, initialize the ``win``
 substructure and call the :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl.
 The driver adjusts the parameters against hardware limits and returns
@@ -134,10 +134,10 @@ the :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` ioctl can be used to learn
 about driver capabilities without actually changing driver state. Unlike
 :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` this also works after the overlay has been enabled.
 
-A struct :ref:`v4l2_crop <v4l2-crop>` defines the size and position
+A struct :c:type:`v4l2_crop` defines the size and position
 of the target rectangle. The scaling factor of the overlay is implied by
-the width and height given in struct :ref:`v4l2_window <v4l2-window>`
-and struct :ref:`v4l2_crop <v4l2-crop>`. The cropping API applies to
+the width and height given in struct :c:type:`v4l2_window`
+and struct :c:type:`v4l2_crop`. The cropping API applies to
 *Video Output* and *Video Output Overlay* devices in the same way as to
 *Video Capture* and *Video Overlay* devices, merely reversing the
 direction of the data flow. For more information see :ref:`crop`.
diff --git a/Documentation/media/uapi/v4l/dev-output.rst b/Documentation/media/uapi/v4l/dev-output.rst
index dfb8207c21cc..25ae8ec96fdf 100644
--- a/Documentation/media/uapi/v4l/dev-output.rst
+++ b/Documentation/media/uapi/v4l/dev-output.rst
@@ -25,7 +25,7 @@ Querying Capabilities
 Devices supporting the video output interface set the
 ``V4L2_CAP_VIDEO_OUTPUT`` or ``V4L2_CAP_VIDEO_OUTPUT_MPLANE`` flag in
 the ``capabilities`` field of struct
-:ref:`v4l2_capability <v4l2-capability>` returned by the
+:c:type:`v4l2_capability` returned by the
 :ref:`VIDIOC_QUERYCAP` ioctl. As secondary device
 functions they may also support the :ref:`raw VBI output <raw-vbi>`
 (``V4L2_CAP_VBI_OUTPUT``) interface. At least one of the read/write or
@@ -62,17 +62,17 @@ Cropping initialization at minimum requires to reset the parameters to
 defaults. An example is given in :ref:`crop`.
 
 To query the current image format applications set the ``type`` field of
-a struct :ref:`v4l2_format <v4l2-format>` to
+a struct :c:type:`v4l2_format` to
 ``V4L2_BUF_TYPE_VIDEO_OUTPUT`` or ``V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE``
 and call the :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` ioctl with a pointer
 to this structure. Drivers fill the struct
-:ref:`v4l2_pix_format <v4l2-pix-format>` ``pix`` or the struct
-:ref:`v4l2_pix_format_mplane <v4l2-pix-format-mplane>` ``pix_mp``
+:c:type:`v4l2_pix_format` ``pix`` or the struct
+:c:type:`v4l2_pix_format_mplane` ``pix_mp``
 member of the ``fmt`` union.
 
 To request different parameters applications set the ``type`` field of a
-struct :ref:`v4l2_format <v4l2-format>` as above and initialize all
-fields of the struct :ref:`v4l2_pix_format <v4l2-pix-format>`
+struct :c:type:`v4l2_format` as above and initialize all
+fields of the struct :c:type:`v4l2_pix_format`
 ``vbi`` member of the ``fmt`` union, or better just modify the results
 of :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>`, and call the :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`
 ioctl with a pointer to this structure. Drivers may adjust the
@@ -83,8 +83,8 @@ Like :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` the :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>`
 can be used to learn about hardware limitations without disabling I/O or
 possibly time consuming hardware preparations.
 
-The contents of struct :ref:`v4l2_pix_format <v4l2-pix-format>` and
-struct :ref:`v4l2_pix_format_mplane <v4l2-pix-format-mplane>` are
+The contents of struct :c:type:`v4l2_pix_format` and
+struct :c:type:`v4l2_pix_format_mplane` are
 discussed in :ref:`pixfmt`. See also the specification of the
 :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>`, :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` and :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` ioctls for
 details. Video output devices must implement both the :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>`
diff --git a/Documentation/media/uapi/v4l/dev-overlay.rst b/Documentation/media/uapi/v4l/dev-overlay.rst
index 50e2d52fcae6..4962947bd8a2 100644
--- a/Documentation/media/uapi/v4l/dev-overlay.rst
+++ b/Documentation/media/uapi/v4l/dev-overlay.rst
@@ -43,7 +43,7 @@ Querying Capabilities
 
 Devices supporting the video overlay interface set the
 ``V4L2_CAP_VIDEO_OVERLAY`` flag in the ``capabilities`` field of struct
-:ref:`v4l2_capability <v4l2-capability>` returned by the
+:c:type:`v4l2_capability` returned by the
 :ref:`VIDIOC_QUERYCAP` ioctl. The overlay I/O
 method specified below must be supported. Tuners and audio inputs are
 optional.
@@ -119,17 +119,17 @@ at minimum requires to reset the parameters to defaults. An example is
 given in :ref:`crop`.
 
 The overlay window is described by a struct
-:ref:`v4l2_window <v4l2-window>`. It defines the size of the image,
+:c:type:`v4l2_window`. It defines the size of the image,
 its position over the graphics surface and the clipping to be applied.
 To get the current parameters applications set the ``type`` field of a
-struct :ref:`v4l2_format <v4l2-format>` to
+struct :c:type:`v4l2_format` to
 ``V4L2_BUF_TYPE_VIDEO_OVERLAY`` and call the
 :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` ioctl. The driver fills the
-:ref:`struct v4l2_window <v4l2-window>` substructure named ``win``. It is not
+:c:type:`struct v4l2_window <v4l2_window>` substructure named ``win``. It is not
 possible to retrieve a previously programmed clipping list or bitmap.
 
 To program the overlay window applications set the ``type`` field of a
-struct :ref:`v4l2_format <v4l2-format>` to
+struct :c:type:`v4l2_format` to
 ``V4L2_BUF_TYPE_VIDEO_OVERLAY``, initialize the ``win`` substructure and
 call the :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl. The driver
 adjusts the parameters against hardware limits and returns the actual
@@ -139,7 +139,7 @@ about driver capabilities without actually changing driver state. Unlike
 :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` this also works after the overlay has been enabled.
 
 The scaling factor of the overlaid image is implied by the width and
-height given in struct :ref:`v4l2_window <v4l2-window>` and the size
+height given in struct :c:type:`v4l2_window` and the size
 of the cropping rectangle. For more information see :ref:`crop`.
 
 When simultaneous capturing and overlay is supported and the hardware
@@ -149,7 +149,7 @@ takes precedence. The attempt to capture or overlay as well
 code or return accordingly modified parameters.
 
 
-.. _v4l2-window:
+.. c:type:: v4l2_window
 
 struct v4l2_window
 ------------------
@@ -175,7 +175,7 @@ struct v4l2_window
     :ref:`VIDIOC_S_FBUF <VIDIOC_G_FBUF>` applications set this field
     to the desired pixel value for the chroma key. The format is the
     same as the pixel format of the framebuffer (struct
-    :ref:`v4l2_framebuffer <v4l2-framebuffer>` ``fmt.pixelformat``
+    :c:type:`v4l2_framebuffer` ``fmt.pixelformat``
     field), with bytes in host order. E. g. for
     :ref:`V4L2_PIX_FMT_BGR24 <V4L2-PIX-FMT-BGR32>` the value should
     be 0xRRGGBB on a little endian, 0xBBGGRR on a big endian host.
@@ -242,11 +242,11 @@ exceeded are undefined. [#f3]_
 
    This field was added in Linux 2.6.23, extending the
    structure. However the :ref:`VIDIOC_[G|S|TRY]_FMT <VIDIOC_G_FMT>`
-   ioctls, which take a pointer to a :ref:`v4l2_format <v4l2-format>`
+   ioctls, which take a pointer to a :c:type:`v4l2_format`
    parent structure with padding bytes at the end, are not affected.
 
 
-.. _v4l2-clip:
+.. c:type:: v4l2_clip
 
 struct v4l2_clip [#f4]_
 -----------------------
@@ -262,7 +262,7 @@ struct v4l2_clip [#f4]_
     linked list of clipping rectangles.
 
 
-.. _v4l2-rect:
+.. c:type:: v4l2_rect
 
 struct v4l2_rect
 ----------------
diff --git a/Documentation/media/uapi/v4l/dev-radio.rst b/Documentation/media/uapi/v4l/dev-radio.rst
index 5ff7cded2591..2b5b836574eb 100644
--- a/Documentation/media/uapi/v4l/dev-radio.rst
+++ b/Documentation/media/uapi/v4l/dev-radio.rst
@@ -20,7 +20,7 @@ Querying Capabilities
 Devices supporting the radio interface set the ``V4L2_CAP_RADIO`` and
 ``V4L2_CAP_TUNER`` or ``V4L2_CAP_MODULATOR`` flag in the
 ``capabilities`` field of struct
-:ref:`v4l2_capability <v4l2-capability>` returned by the
+:c:type:`v4l2_capability` returned by the
 :ref:`VIDIOC_QUERYCAP` ioctl. Other combinations of
 capability flags are reserved for future extensions.
 
diff --git a/Documentation/media/uapi/v4l/dev-raw-vbi.rst b/Documentation/media/uapi/v4l/dev-raw-vbi.rst
index 3cf44869a425..26ec24a94103 100644
--- a/Documentation/media/uapi/v4l/dev-raw-vbi.rst
+++ b/Documentation/media/uapi/v4l/dev-raw-vbi.rst
@@ -39,7 +39,7 @@ Querying Capabilities
 Devices supporting the raw VBI capturing or output API set the
 ``V4L2_CAP_VBI_CAPTURE`` or ``V4L2_CAP_VBI_OUTPUT`` flags, respectively,
 in the ``capabilities`` field of struct
-:ref:`v4l2_capability <v4l2-capability>` returned by the
+:c:type:`v4l2_capability` returned by the
 :ref:`VIDIOC_QUERYCAP` ioctl. At least one of the
 read/write, streaming or asynchronous I/O methods must be supported. VBI
 devices may or may not have a tuner or modulator.
@@ -69,16 +69,16 @@ always ensure they really get what they want, requesting reasonable
 parameters and then checking if the actual parameters are suitable.
 
 To query the current raw VBI capture parameters applications set the
-``type`` field of a struct :ref:`v4l2_format <v4l2-format>` to
+``type`` field of a struct :c:type:`v4l2_format` to
 ``V4L2_BUF_TYPE_VBI_CAPTURE`` or ``V4L2_BUF_TYPE_VBI_OUTPUT``, and call
 the :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` ioctl with a pointer to this
 structure. Drivers fill the struct
-:ref:`v4l2_vbi_format <v4l2-vbi-format>` ``vbi`` member of the
+:c:type:`v4l2_vbi_format` ``vbi`` member of the
 ``fmt`` union.
 
 To request different parameters applications set the ``type`` field of a
-struct :ref:`v4l2_format <v4l2-format>` as above and initialize all
-fields of the struct :ref:`v4l2_vbi_format <v4l2-vbi-format>`
+struct :c:type:`v4l2_format` as above and initialize all
+fields of the struct :c:type:`v4l2_vbi_format`
 ``vbi`` member of the ``fmt`` union, or better just modify the results
 of :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>`, and call the :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`
 ioctl with a pointer to this structure. Drivers return an ``EINVAL`` error
@@ -101,7 +101,7 @@ and always returns default parameters as :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` does
 
 .. tabularcolumns:: |p{2.4cm}|p{4.4cm}|p{10.7cm}|
 
-.. _v4l2-vbi-format:
+.. c:type:: v4l2_vbi_format
 
 .. cssclass:: longtable
 
@@ -204,7 +204,7 @@ and always returns default parameters as :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` does
 	  To initialize the ``start`` and ``count`` fields, applications
 	  must first determine the current video standard selection. The
 	  :ref:`v4l2_std_id <v4l2-std-id>` or the ``framelines`` field
-	  of struct :ref:`v4l2_standard <v4l2-standard>` can be evaluated
+	  of struct :c:type:`v4l2_standard` can be evaluated
 	  for this purpose.
 
     -  .. row 8
diff --git a/Documentation/media/uapi/v4l/dev-rds.rst b/Documentation/media/uapi/v4l/dev-rds.rst
index 841761a3ea59..4a8e1d2efd06 100644
--- a/Documentation/media/uapi/v4l/dev-rds.rst
+++ b/Documentation/media/uapi/v4l/dev-rds.rst
@@ -34,10 +34,10 @@ Querying Capabilities
 
 Devices supporting the RDS capturing API set the
 ``V4L2_CAP_RDS_CAPTURE`` flag in the ``capabilities`` field of struct
-:ref:`v4l2_capability <v4l2-capability>` returned by the
+:c:type:`v4l2_capability` returned by the
 :ref:`VIDIOC_QUERYCAP` ioctl. Any tuner that
 supports RDS will set the ``V4L2_TUNER_CAP_RDS`` flag in the
-``capability`` field of struct :ref:`v4l2_tuner <v4l2-tuner>`. If the
+``capability`` field of struct :c:type:`v4l2_tuner`. If the
 driver only passes RDS blocks without interpreting the data the
 ``V4L2_TUNER_CAP_RDS_BLOCK_IO`` flag has to be set, see
 :ref:`Reading RDS data <reading-rds-data>`. For future use the flag
@@ -48,19 +48,19 @@ linux-media mailing list:
 `https://linuxtv.org/lists.php <https://linuxtv.org/lists.php>`__.
 
 Whether an RDS signal is present can be detected by looking at the
-``rxsubchans`` field of struct :ref:`v4l2_tuner <v4l2-tuner>`: the
+``rxsubchans`` field of struct :c:type:`v4l2_tuner`: the
 ``V4L2_TUNER_SUB_RDS`` will be set if RDS data was detected.
 
 Devices supporting the RDS output API set the ``V4L2_CAP_RDS_OUTPUT``
 flag in the ``capabilities`` field of struct
-:ref:`v4l2_capability <v4l2-capability>` returned by the
+:c:type:`v4l2_capability` returned by the
 :ref:`VIDIOC_QUERYCAP` ioctl. Any modulator that
 supports RDS will set the ``V4L2_TUNER_CAP_RDS`` flag in the
 ``capability`` field of struct
-:ref:`v4l2_modulator <v4l2-modulator>`. In order to enable the RDS
+:c:type:`v4l2_modulator`. In order to enable the RDS
 transmission one must set the ``V4L2_TUNER_SUB_RDS`` bit in the
 ``txsubchans`` field of struct
-:ref:`v4l2_modulator <v4l2-modulator>`. If the driver only passes RDS
+:c:type:`v4l2_modulator`. If the driver only passes RDS
 blocks without interpreting the data the ``V4L2_TUNER_CAP_RDS_BLOCK_IO``
 flag has to be set. If the tuner is capable of handling RDS entities
 like program identification codes and radio text, the flag
@@ -93,7 +93,7 @@ RDS datastructures
 ==================
 
 
-.. _v4l2-rds-data:
+.. c:type:: v4l2_rds_data
 
 .. tabularcolumns:: |p{2.5cm}|p{2.5cm}|p{12.5cm}|
 
diff --git a/Documentation/media/uapi/v4l/dev-sdr.rst b/Documentation/media/uapi/v4l/dev-sdr.rst
index 3b6aa2a58430..5f82d760e188 100644
--- a/Documentation/media/uapi/v4l/dev-sdr.rst
+++ b/Documentation/media/uapi/v4l/dev-sdr.rst
@@ -21,7 +21,7 @@ Querying Capabilities
 Devices supporting the SDR receiver interface set the
 ``V4L2_CAP_SDR_CAPTURE`` and ``V4L2_CAP_TUNER`` flag in the
 ``capabilities`` field of struct
-:ref:`v4l2_capability <v4l2-capability>` returned by the
+:c:type:`v4l2_capability` returned by the
 :ref:`VIDIOC_QUERYCAP` ioctl. That flag means the
 device has an Analog to Digital Converter (ADC), which is a mandatory
 element for the SDR receiver.
@@ -29,7 +29,7 @@ element for the SDR receiver.
 Devices supporting the SDR transmitter interface set the
 ``V4L2_CAP_SDR_OUTPUT`` and ``V4L2_CAP_MODULATOR`` flag in the
 ``capabilities`` field of struct
-:ref:`v4l2_capability <v4l2-capability>` returned by the
+:c:type:`v4l2_capability` returned by the
 :ref:`VIDIOC_QUERYCAP` ioctl. That flag means the
 device has an Digital to Analog Converter (DAC), which is a mandatory
 element for the SDR transmitter.
@@ -67,18 +67,18 @@ basic :ref:`format` ioctls, the
 well.
 
 To use the :ref:`format` ioctls applications set the ``type``
-field of a struct :ref:`v4l2_format <v4l2-format>` to
+field of a struct :c:type:`v4l2_format` to
 ``V4L2_BUF_TYPE_SDR_CAPTURE`` or ``V4L2_BUF_TYPE_SDR_OUTPUT`` and use
-the struct :ref:`v4l2_sdr_format <v4l2-sdr-format>` ``sdr`` member
+the struct :c:type:`v4l2_sdr_format` ``sdr`` member
 of the ``fmt`` union as needed per the desired operation. Currently
 there is two fields, ``pixelformat`` and ``buffersize``, of struct
-struct :ref:`v4l2_sdr_format <v4l2-sdr-format>` which are used.
+struct :c:type:`v4l2_sdr_format` which are used.
 Content of the ``pixelformat`` is V4L2 FourCC code of the data format.
 The ``buffersize`` field is maximum buffer size in bytes required for
 data transfer, set by the driver in order to inform application.
 
 
-.. _v4l2-sdr-format:
+.. c:type:: v4l2_sdr_format
 
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
diff --git a/Documentation/media/uapi/v4l/dev-sliced-vbi.rst b/Documentation/media/uapi/v4l/dev-sliced-vbi.rst
index 86d2d698d2af..2a979aa138bd 100644
--- a/Documentation/media/uapi/v4l/dev-sliced-vbi.rst
+++ b/Documentation/media/uapi/v4l/dev-sliced-vbi.rst
@@ -34,7 +34,7 @@ Querying Capabilities
 Devices supporting the sliced VBI capturing or output API set the
 ``V4L2_CAP_SLICED_VBI_CAPTURE`` or ``V4L2_CAP_SLICED_VBI_OUTPUT`` flag
 respectively, in the ``capabilities`` field of struct
-:ref:`v4l2_capability <v4l2-capability>` returned by the
+:c:type:`v4l2_capability` returned by the
 :ref:`VIDIOC_QUERYCAP` ioctl. At least one of the
 read/write, streaming or asynchronous :ref:`I/O methods <io>` must be
 supported. Sliced VBI devices may have a tuner or modulator.
@@ -67,17 +67,17 @@ line 16 the hardware may be able to look for a VPS or Teletext signal,
 but not both at the same time.
 
 To determine the currently selected services applications set the
-``type`` field of struct :ref:`v4l2_format <v4l2-format>` to
+``type`` field of struct :c:type:`v4l2_format` to
 ``V4L2_BUF_TYPE_SLICED_VBI_CAPTURE`` or
 ``V4L2_BUF_TYPE_SLICED_VBI_OUTPUT``, and the
 :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` ioctl fills the ``fmt.sliced``
 member, a struct
-:ref:`v4l2_sliced_vbi_format <v4l2-sliced-vbi-format>`.
+:c:type:`v4l2_sliced_vbi_format`.
 
 Applications can request different parameters by initializing or
 modifying the ``fmt.sliced`` member and calling the
 :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl with a pointer to the
-:ref:`struct v4l2_format <v4l2-format>` structure.
+:c:type:`struct v4l2_format <v4l2_format>` structure.
 
 The sliced VBI API is more complicated than the raw VBI API because the
 hardware must be told which VBI service to expect on each scan line. Not
@@ -100,7 +100,7 @@ which may return ``EBUSY`` can be the
 :ref:`select() <func-select>` call.
 
 
-.. _v4l2-sliced-vbi-format:
+.. c:type:: v4l2_sliced_vbi_format
 
 struct v4l2_sliced_vbi_format
 -----------------------------
@@ -233,7 +233,7 @@ struct v4l2_sliced_vbi_format
 	  :ref:`VIDIOC_QBUF` and
 	  :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctl. Drivers set this field
 	  to the size of struct
-	  :ref:`v4l2_sliced_vbi_data <v4l2-sliced-vbi-data>` times the
+	  :c:type:`v4l2_sliced_vbi_data` times the
 	  number of non-zero elements in the returned ``service_lines``
 	  array (that is the number of lines potentially carrying data).
 
@@ -376,14 +376,14 @@ Reading and writing sliced VBI data
 
 A single :ref:`read() <func-read>` or :ref:`write() <func-write>`
 call must pass all data belonging to one video frame. That is an array
-of :ref:`struct v4l2_sliced_vbi_data <v4l2-sliced-vbi-data>` structures with one or
+of :c:type:`struct v4l2_sliced_vbi_data <v4l2_sliced_vbi_data>` structures with one or
 more elements and a total size not exceeding ``io_size`` bytes. Likewise
 in streaming I/O mode one buffer of ``io_size`` bytes must contain data
 of one video frame. The ``id`` of unused
-:ref:`struct v4l2_sliced_vbi_data <v4l2-sliced-vbi-data>` elements must be zero.
+:c:type:`struct v4l2_sliced_vbi_data <v4l2_sliced_vbi_data>` elements must be zero.
 
 
-.. _v4l2-sliced-vbi-data:
+.. c:type:: v4l2_sliced_vbi_data
 
 struct v4l2_sliced_vbi_data
 ---------------------------
@@ -561,7 +561,7 @@ refer to the MPEG-2 specifications for details on those packet headers.)
 
 The payload of the MPEG-2 *Private Stream 1 PES* packets that contain
 sliced VBI data is specified by struct
-:ref:`v4l2_mpeg_vbi_fmt_ivtv <v4l2-mpeg-vbi-fmt-ivtv>`. The
+:c:type:`v4l2_mpeg_vbi_fmt_ivtv`. The
 payload is variable length, depending on the actual number of lines of
 sliced VBI data present in a video frame. The payload may be padded at
 the end with unspecified fill bytes to align the end of the payload to a
@@ -570,7 +570,7 @@ with 18 lines/field with 43 bytes of data/line and a 4 byte magic
 number).
 
 
-.. _v4l2-mpeg-vbi-fmt-ivtv:
+.. c:type:: v4l2_mpeg_vbi_fmt_ivtv
 
 struct v4l2_mpeg_vbi_fmt_ivtv
 -----------------------------
@@ -604,7 +604,7 @@ struct v4l2_mpeg_vbi_fmt_ivtv
     -  .. row 3
 
        -
-       -  struct :ref:`v4l2_mpeg_vbi_itv0 <v4l2-mpeg-vbi-itv0>`
+       -  struct :c:type:`v4l2_mpeg_vbi_itv0`
 
        -  ``itv0``
 
@@ -655,7 +655,7 @@ Magic Constants for struct v4l2_mpeg_vbi_fmt_ivtv magic field
        -  "itv0"
 
        -  Indicates the ``itv0`` member of the union in struct
-	  :ref:`v4l2_mpeg_vbi_fmt_ivtv <v4l2-mpeg-vbi-fmt-ivtv>` is
+	  :c:type:`v4l2_mpeg_vbi_fmt_ivtv` is
 	  valid.
 
     -  .. row 3
@@ -665,12 +665,12 @@ Magic Constants for struct v4l2_mpeg_vbi_fmt_ivtv magic field
        -  "ITV0"
 
        -  Indicates the ``ITV0`` member of the union in struct
-	  :ref:`v4l2_mpeg_vbi_fmt_ivtv <v4l2-mpeg-vbi-fmt-ivtv>` is
+	  :c:type:`v4l2_mpeg_vbi_fmt_ivtv` is
 	  valid and that 36 lines of sliced VBI data are present.
 
 
 
-.. _v4l2-mpeg-vbi-itv0:
+.. c:type:: v4l2_mpeg_vbi_itv0
 
 struct v4l2_mpeg_vbi_itv0
 -------------------------
@@ -711,7 +711,7 @@ struct v4l2_mpeg_vbi_itv0
     -  .. row 2
 
        -  struct
-	  :ref:`v4l2_mpeg_vbi_itv0_line <v4l2-mpeg-vbi-itv0-line>`
+	  :c:type:`v4l2_mpeg_vbi_itv0_line`
 
        -  ``line``\ [35]
 
@@ -745,7 +745,7 @@ struct v4l2_mpeg_vbi_ITV0
     -  .. row 1
 
        -  struct
-	  :ref:`v4l2_mpeg_vbi_itv0_line <v4l2-mpeg-vbi-itv0-line>`
+	  :c:type:`v4l2_mpeg_vbi_itv0_line`
 
        -  ``line``\ [36]
 
@@ -756,7 +756,7 @@ struct v4l2_mpeg_vbi_ITV0
 
 
 
-.. _v4l2-mpeg-vbi-itv0-line:
+.. c:type:: v4l2_mpeg_vbi_itv0_line
 
 struct v4l2_mpeg_vbi_itv0_line
 ------------------------------
diff --git a/Documentation/media/uapi/v4l/dev-subdev.rst b/Documentation/media/uapi/v4l/dev-subdev.rst
index 1045b3c61031..6dc7f13780ba 100644
--- a/Documentation/media/uapi/v4l/dev-subdev.rst
+++ b/Documentation/media/uapi/v4l/dev-subdev.rst
@@ -341,7 +341,7 @@ It can also be used as part of digital zoom implementations to select
 the area of the image that will be scaled up.
 
 Crop settings are defined by a crop rectangle and represented in a
-struct :ref:`v4l2_rect <v4l2-rect>` by the coordinates of the top
+struct :c:type:`v4l2_rect` by the coordinates of the top
 left corner and the rectangle size. Both the coordinates and sizes are
 expressed in pixels.
 
@@ -357,7 +357,7 @@ sub-device for processing.
 The scaling operation changes the size of the image by scaling it to new
 dimensions. The scaling ratio isn't specified explicitly, but is implied
 from the original and scaled image sizes. Both sizes are represented by
-struct :ref:`v4l2_rect <v4l2-rect>`.
+struct :c:type:`v4l2_rect`.
 
 Scaling support is optional. When supported by a subdev, the crop
 rectangle on the subdev's sink pad is scaled to the size configured
diff --git a/Documentation/media/uapi/v4l/dev-touch.rst b/Documentation/media/uapi/v4l/dev-touch.rst
index 1f4e75243a47..98797f255ce0 100644
--- a/Documentation/media/uapi/v4l/dev-touch.rst
+++ b/Documentation/media/uapi/v4l/dev-touch.rst
@@ -41,7 +41,7 @@ Querying Capabilities
 
 Devices supporting the touch interface set the ``V4L2_CAP_VIDEO_CAPTURE`` flag
 and the ``V4L2_CAP_TOUCH`` flag in the ``capabilities`` field of
-:ref:`v4l2_capability <v4l2-capability>` returned by the
+:c:type:`v4l2_capability` returned by the
 :ref:`VIDIOC_QUERYCAP` ioctl.
 
 At least one of the read/write or streaming I/O methods must be
diff --git a/Documentation/media/uapi/v4l/diff-v4l.rst b/Documentation/media/uapi/v4l/diff-v4l.rst
index 93263e477127..93794e015e7c 100644
--- a/Documentation/media/uapi/v4l/diff-v4l.rst
+++ b/Documentation/media/uapi/v4l/diff-v4l.rst
@@ -88,7 +88,7 @@ The V4L ``VIDIOCGCAP`` ioctl is equivalent to V4L2's
 :ref:`VIDIOC_QUERYCAP`.
 
 The ``name`` field in struct :c:type:`struct video_capability` became
-``card`` in struct :ref:`v4l2_capability <v4l2-capability>`, ``type``
+``card`` in struct :c:type:`v4l2_capability`, ``type``
 was replaced by ``capabilities``. Note V4L2 does not distinguish between
 device types like this, better think of basic video input, video output
 and radio devices supporting a set of related functions like video
@@ -108,7 +108,7 @@ introduction.
 
        -  ``struct video_capability`` ``type``
 
-       -  struct :ref:`v4l2_capability <v4l2-capability>`
+       -  struct :c:type:`v4l2_capability`
 	  ``capabilities`` flags
 
        -  Purpose
@@ -150,7 +150,7 @@ introduction.
        -  ``VID_TYPE_CHROMAKEY``
 
        -  ``V4L2_FBUF_CAP_CHROMAKEY`` in field ``capability`` of struct
-	  :ref:`v4l2_framebuffer <v4l2-framebuffer>`
+	  :c:type:`v4l2_framebuffer`
 
        -  Whether chromakey overlay is supported. For more information on
 	  overlay see :ref:`overlay`.
@@ -161,7 +161,7 @@ introduction.
 
        -  ``V4L2_FBUF_CAP_LIST_CLIPPING`` and
 	  ``V4L2_FBUF_CAP_BITMAP_CLIPPING`` in field ``capability`` of
-	  struct :ref:`v4l2_framebuffer <v4l2-framebuffer>`
+	  struct :c:type:`v4l2_framebuffer`
 
        -  Whether clipping the overlaid image is supported, see
 	  :ref:`overlay`.
@@ -171,7 +171,7 @@ introduction.
        -  ``VID_TYPE_FRAMERAM``
 
        -  ``V4L2_FBUF_CAP_EXTERNOVERLAY`` *not set* in field ``capability``
-	  of struct :ref:`v4l2_framebuffer <v4l2-framebuffer>`
+	  of struct :c:type:`v4l2_framebuffer`
 
        -  Whether overlay overwrites frame buffer memory, see
 	  :ref:`overlay`.
@@ -269,7 +269,7 @@ device. The equivalent V4L2 ioctls are
 :ref:`VIDIOC_ENUMINPUT`,
 :ref:`VIDIOC_G_INPUT <VIDIOC_G_INPUT>` and
 :ref:`VIDIOC_S_INPUT <VIDIOC_G_INPUT>` using struct
-:ref:`v4l2_input <v4l2-input>` as discussed in :ref:`video`.
+:c:type:`v4l2_input` as discussed in :ref:`video`.
 
 The ``channel`` field counting inputs was renamed to ``index``, the
 video input types were renamed as follows:
@@ -285,7 +285,7 @@ video input types were renamed as follows:
 
        -  struct :c:type:`struct video_channel` ``type``
 
-       -  struct :ref:`v4l2_input <v4l2-input>` ``type``
+       -  struct :c:type:`v4l2_input` ``type``
 
     -  .. row 2
 
@@ -305,7 +305,7 @@ input, V4L2 assumes each video input is connected to at most one tuner.
 However a tuner can have more than one input, i. e. RF connectors, and a
 device can have multiple tuners. The index number of the tuner
 associated with the input, if any, is stored in field ``tuner`` of
-struct :ref:`v4l2_input <v4l2-input>`. Enumeration of tuners is
+struct :c:type:`v4l2_input`. Enumeration of tuners is
 discussed in :ref:`tuner`.
 
 The redundant ``VIDEO_VC_TUNER`` flag was dropped. Video inputs
@@ -332,7 +332,7 @@ The V4L ``VIDIOCGTUNER`` and ``VIDIOCSTUNER`` ioctl and struct
 V4L TV or radio device. The equivalent V4L2 ioctls are
 :ref:`VIDIOC_G_TUNER <VIDIOC_G_TUNER>` and
 :ref:`VIDIOC_S_TUNER <VIDIOC_G_TUNER>` using struct
-:ref:`v4l2_tuner <v4l2-tuner>`. Tuners are covered in :ref:`tuner`.
+:c:type:`v4l2_tuner`. Tuners are covered in :ref:`tuner`.
 
 The ``tuner`` field counting tuners was renamed to ``index``. The fields
 ``name``, ``rangelow`` and ``rangehigh`` remained unchanged.
@@ -340,7 +340,7 @@ The ``tuner`` field counting tuners was renamed to ``index``. The fields
 The ``VIDEO_TUNER_PAL``, ``VIDEO_TUNER_NTSC`` and ``VIDEO_TUNER_SECAM``
 flags indicating the supported video standards were dropped. This
 information is now contained in the associated struct
-:ref:`v4l2_input <v4l2-input>`. No replacement exists for the
+:c:type:`v4l2_input`. No replacement exists for the
 ``VIDEO_TUNER_NORM`` flag indicating whether the video standard can be
 switched. The ``mode`` field to select a different video standard was
 replaced by a whole new set of ioctls and structures described in
@@ -353,18 +353,18 @@ Japan with numbers 3-6 (sic).
 The ``VIDEO_TUNER_STEREO_ON`` flag indicating stereo reception became
 ``V4L2_TUNER_SUB_STEREO`` in field ``rxsubchans``. This field also
 permits the detection of monaural and bilingual audio, see the
-definition of struct :ref:`v4l2_tuner <v4l2-tuner>` for details.
+definition of struct :c:type:`v4l2_tuner` for details.
 Presently no replacement exists for the ``VIDEO_TUNER_RDS_ON`` and
 ``VIDEO_TUNER_MBS_ON`` flags.
 
 The ``VIDEO_TUNER_LOW`` flag was renamed to ``V4L2_TUNER_CAP_LOW`` in
-the struct :ref:`v4l2_tuner <v4l2-tuner>` ``capability`` field.
+the struct :c:type:`v4l2_tuner` ``capability`` field.
 
 The ``VIDIOCGFREQ`` and ``VIDIOCSFREQ`` ioctl to change the tuner
 frequency where renamed to
 :ref:`VIDIOC_G_FREQUENCY <VIDIOC_G_FREQUENCY>` and
 :ref:`VIDIOC_S_FREQUENCY <VIDIOC_G_FREQUENCY>`. They take a pointer
-to a struct :ref:`v4l2_frequency <v4l2-frequency>` instead of an
+to a struct :c:type:`v4l2_frequency` instead of an
 unsigned long integer.
 
 
@@ -434,7 +434,7 @@ The ``depth`` (average number of bits per pixel) of a video image is
 implied by the selected image format. V4L2 does not explicitly provide
 such information assuming applications recognizing the format are aware
 of the image depth and others need not know. The ``palette`` field moved
-into the struct :ref:`v4l2_pix_format <v4l2-pix-format>`:
+into the struct :c:type:`v4l2_pix_format`:
 
 
 
@@ -447,7 +447,7 @@ into the struct :ref:`v4l2_pix_format <v4l2-pix-format>`:
 
        -  struct :c:type:`struct video_picture` ``palette``
 
-       -  struct :ref:`v4l2_pix_format <v4l2-pix-format>` ``pixfmt``
+       -  struct :c:type:`v4l2_pix_format` ``pixfmt``
 
     -  .. row 2
 
@@ -558,7 +558,7 @@ The ``VIDIOCGAUDIO`` and ``VIDIOCSAUDIO`` ioctl and struct
 of a V4L device. The equivalent V4L2 ioctls are
 :ref:`VIDIOC_G_AUDIO <VIDIOC_G_AUDIO>` and
 :ref:`VIDIOC_S_AUDIO <VIDIOC_G_AUDIO>` using struct
-:ref:`v4l2_audio <v4l2-audio>` as discussed in :ref:`audio`.
+:c:type:`v4l2_audio` as discussed in :ref:`audio`.
 
 The ``audio`` "channel number" field counting audio inputs was renamed
 to ``index``.
@@ -571,10 +571,10 @@ standard is BTSC ``VIDEO_SOUND_LANG2`` refers to SAP and
 specification, there is no way to query the selected mode. On
 ``VIDIOCGAUDIO`` the driver returns the *actually received* audio
 programmes in this field. In the V4L2 API this information is stored in
-the struct :ref:`v4l2_tuner <v4l2-tuner>` ``rxsubchans`` and
+the struct :c:type:`v4l2_tuner` ``rxsubchans`` and
 ``audmode`` fields, respectively. See :ref:`tuner` for more
 information on tuners. Related to audio modes struct
-:ref:`v4l2_audio <v4l2-audio>` also reports if this is a mono or
+:c:type:`v4l2_audio` also reports if this is a mono or
 stereo input, regardless if the source is a tuner.
 
 The following fields where replaced by V4L2 controls accessible with the
@@ -645,8 +645,8 @@ The V4L2 ioctls equivalent to ``VIDIOCGFBUF`` and ``VIDIOCSFBUF`` are
 :c:type:`struct video_buffer` remained unchanged, except V4L2 defines
 a flag to indicate non-destructive overlays instead of a ``NULL``
 pointer. All other fields moved into the struct
-:ref:`v4l2_pix_format <v4l2-pix-format>` ``fmt`` substructure of
-struct :ref:`v4l2_framebuffer <v4l2-framebuffer>`. The ``depth``
+:c:type:`v4l2_pix_format` ``fmt`` substructure of
+struct :c:type:`v4l2_framebuffer`. The ``depth``
 field was replaced by ``pixelformat``. See :ref:`pixfmt-rgb` for a
 list of RGB formats and their respective color depths.
 
@@ -654,23 +654,23 @@ Instead of the special ioctls ``VIDIOCGWIN`` and ``VIDIOCSWIN`` V4L2
 uses the general-purpose data format negotiation ioctls
 :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` and
 :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`. They take a pointer to a struct
-:ref:`v4l2_format <v4l2-format>` as argument. Here the ``win`` member
+:c:type:`v4l2_format` as argument. Here the ``win`` member
 of the ``fmt`` union is used, a struct
-:ref:`v4l2_window <v4l2-window>`.
+:c:type:`v4l2_window`.
 
 The ``x``, ``y``, ``width`` and ``height`` fields of struct
 :c:type:`struct video_window` moved into struct
-:ref:`v4l2_rect <v4l2-rect>` substructure ``w`` of struct
+:c:type:`v4l2_rect` substructure ``w`` of struct
 :c:type:`struct v4l2_window`. The ``chromakey``, ``clips``, and
 ``clipcount`` fields remained unchanged. Struct
 :c:type:`struct video_clip` was renamed to struct
-:ref:`v4l2_clip <v4l2-clip>`, also containing a struct
+:c:type:`v4l2_clip`, also containing a struct
 :c:type:`struct v4l2_rect`, but the semantics are still the same.
 
 The ``VIDEO_WINDOW_INTERLACE`` flag was dropped. Instead applications
 must set the ``field`` field to ``V4L2_FIELD_ANY`` or
 ``V4L2_FIELD_INTERLACED``. The ``VIDEO_WINDOW_CHROMAKEY`` flag moved
-into struct :ref:`v4l2_framebuffer <v4l2-framebuffer>`, under the new
+into struct :c:type:`v4l2_framebuffer`, under the new
 name ``V4L2_FBUF_FLAG_CHROMAKEY``.
 
 In V4L, storing a bitmap pointer in ``clips`` and setting ``clipcount``
@@ -691,12 +691,12 @@ To capture only a subsection of the full picture V4L defines the
 :c:type:`struct video_capture`. The equivalent V4L2 ioctls are
 :ref:`VIDIOC_G_CROP <VIDIOC_G_CROP>` and
 :ref:`VIDIOC_S_CROP <VIDIOC_G_CROP>` using struct
-:ref:`v4l2_crop <v4l2-crop>`, and the related
+:c:type:`v4l2_crop`, and the related
 :ref:`VIDIOC_CROPCAP` ioctl. This is a rather
 complex matter, see :ref:`crop` for details.
 
 The ``x``, ``y``, ``width`` and ``height`` fields moved into struct
-:ref:`v4l2_rect <v4l2-rect>` substructure ``c`` of struct
+:c:type:`v4l2_rect` substructure ``c`` of struct
 :c:type:`struct v4l2_crop`. The ``decimation`` field was dropped. In
 the V4L2 API the scaling factor is implied by the size of the cropping
 rectangle and the size of the captured or overlaid image.
@@ -704,8 +704,8 @@ rectangle and the size of the captured or overlaid image.
 The ``VIDEO_CAPTURE_ODD`` and ``VIDEO_CAPTURE_EVEN`` flags to capture
 only the odd or even field, respectively, were replaced by
 ``V4L2_FIELD_TOP`` and ``V4L2_FIELD_BOTTOM`` in the field named
-``field`` of struct :ref:`v4l2_pix_format <v4l2-pix-format>` and
-struct :ref:`v4l2_window <v4l2-window>`. These structures are used to
+``field`` of struct :c:type:`v4l2_pix_format` and
+struct :c:type:`v4l2_window`. These structures are used to
 select a capture or overlay format with the
 :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl.
 
@@ -730,8 +730,8 @@ To select an image format and size, V4L provides the ``VIDIOCSPICT`` and
 ``VIDIOCSWIN`` ioctls. V4L2 uses the general-purpose data format
 negotiation ioctls :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` and
 :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`. They take a pointer to a struct
-:ref:`v4l2_format <v4l2-format>` as argument, here the struct
-:ref:`v4l2_pix_format <v4l2-pix-format>` named ``pix`` of its
+:c:type:`v4l2_format` as argument, here the struct
+:c:type:`v4l2_pix_format` named ``pix`` of its
 ``fmt`` union is used.
 
 For more information about the V4L2 read interface see :ref:`rw`.
@@ -838,7 +838,7 @@ with the following parameters:
 
     -  .. row 1
 
-       -  struct :ref:`v4l2_vbi_format <v4l2-vbi-format>`
+       -  struct :c:type:`v4l2_vbi_format`
 
        -  V4L, BTTV driver
 
@@ -896,7 +896,7 @@ interface specified in :ref:`raw-vbi`.
 An ``offset`` field does not exist, ``sample_format`` is supposed to be
 ``VIDEO_PALETTE_RAW``, equivalent to ``V4L2_PIX_FMT_GREY``. The
 remaining fields are probably equivalent to struct
-:ref:`v4l2_vbi_format <v4l2-vbi-format>`.
+:c:type:`v4l2_vbi_format`.
 
 Apparently only the Zoran (ZR 36120) driver implements these ioctls. The
 semantics differ from those specified for V4L2 in two ways. The
diff --git a/Documentation/media/uapi/v4l/dmabuf.rst b/Documentation/media/uapi/v4l/dmabuf.rst
index 675768f7c66a..4e980a7e9c9c 100644
--- a/Documentation/media/uapi/v4l/dmabuf.rst
+++ b/Documentation/media/uapi/v4l/dmabuf.rst
@@ -19,7 +19,7 @@ exporting V4L2 buffers as DMABUF file descriptors.
 
 Input and output devices support the streaming I/O method when the
 ``V4L2_CAP_STREAMING`` flag in the ``capabilities`` field of struct
-:ref:`v4l2_capability <v4l2-capability>` returned by the
+:c:type:`v4l2_capability` returned by the
 :ref:`VIDIOC_QUERYCAP <VIDIOC_QUERYCAP>` ioctl is set. Whether
 importing DMA buffers through DMABUF file descriptors is supported is
 determined by calling the :ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>`
@@ -31,8 +31,8 @@ DRM). Buffers (planes) are allocated by a driver on behalf of an
 application. Next, these buffers are exported to the application as file
 descriptors using an API which is specific for an allocator driver. Only
 such file descriptor are exchanged. The descriptors and meta-information
-are passed in struct :ref:`v4l2_buffer <v4l2-buffer>` (or in struct
-:ref:`v4l2_plane <v4l2-plane>` in the multi-planar API case). The
+are passed in struct :c:type:`v4l2_buffer` (or in struct
+:c:type:`v4l2_plane` in the multi-planar API case). The
 driver must be switched into DMABUF I/O mode by calling the
 :ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>` with the desired buffer type.
 
@@ -151,7 +151,7 @@ To start and stop capturing or displaying applications call the
    both queues and unlocks all buffers as a side effect. Since there is no
    notion of doing anything "now" on a multitasking system, if an
    application needs to synchronize with another event it should examine
-   the struct :ref:`v4l2_buffer <v4l2-buffer>` ``timestamp`` of captured or
+   the struct :c:type:`v4l2_buffer` ``timestamp`` of captured or
    outputted buffers.
 
 Drivers implementing DMABUF importing I/O must support the
diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
index 1f1518e4859d..75359739eb52 100644
--- a/Documentation/media/uapi/v4l/extended-controls.rst
+++ b/Documentation/media/uapi/v4l/extended-controls.rst
@@ -49,7 +49,7 @@ control). This is needed since it is often required to atomically change
 several controls at once.
 
 Each of the new ioctls expects a pointer to a struct
-:ref:`v4l2_ext_controls <v4l2-ext-controls>`. This structure
+:c:type:`v4l2_ext_controls`. This structure
 contains a pointer to the control array, a count of the number of
 controls in that array and a control class. Control classes are used to
 group similar controls into a single class. For example, control class
@@ -65,12 +65,12 @@ It is also possible to use an empty control array (``count`` == 0) to check
 whether the specified control class is supported.
 
 The control array is a struct
-:ref:`v4l2_ext_control <v4l2-ext-control>` array. The
-:ref:`struct v4l2_ext_control <v4l2-ext-control>` structure is very similar to
-struct :ref:`v4l2_control <v4l2-control>`, except for the fact that
+:c:type:`v4l2_ext_control` array. The
+:c:type:`struct v4l2_ext_control <v4l2_ext_control>` structure is very similar to
+struct :c:type:`v4l2_control`, except for the fact that
 it also allows for 64-bit values and pointers to be passed.
 
-Since the struct :ref:`v4l2_ext_control <v4l2-ext-control>` supports
+Since the struct :c:type:`v4l2_ext_control` supports
 pointers it is now also possible to have controls with compound types
 such as N-dimensional arrays and/or structures. You need to specify the
 ``V4L2_CTRL_FLAG_NEXT_COMPOUND`` when enumerating controls to actually
diff --git a/Documentation/media/uapi/v4l/field-order.rst b/Documentation/media/uapi/v4l/field-order.rst
index 95e9d2a41f1d..1fa082f34c6f 100644
--- a/Documentation/media/uapi/v4l/field-order.rst
+++ b/Documentation/media/uapi/v4l/field-order.rst
@@ -47,7 +47,7 @@ clearer.
 All video capture and output devices must report the current field
 order. Some drivers may permit the selection of a different order, to
 this end applications initialize the ``field`` field of struct
-:ref:`v4l2_pix_format <v4l2-pix-format>` before calling the
+:c:type:`v4l2_pix_format` before calling the
 :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl. If this is not desired it
 should have the value ``V4L2_FIELD_ANY`` (0).
 
@@ -80,7 +80,7 @@ enum v4l2_field
 	  driver must choose one of the possible field orders during
 	  :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` or
 	  :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>`. struct
-	  :ref:`v4l2_buffer <v4l2-buffer>` ``field`` can never be
+	  :c:type:`v4l2_buffer` ``field`` can never be
 	  ``V4L2_FIELD_ANY``.
 
     -  .. row 2
@@ -156,12 +156,12 @@ enum v4l2_field
 	  temporal order, i. e. the older one first. To indicate the field
 	  parity (whether the current field is a top or bottom field) the
 	  driver or application, depending on data direction, must set
-	  struct :ref:`v4l2_buffer <v4l2-buffer>` ``field`` to
+	  struct :c:type:`v4l2_buffer` ``field`` to
 	  ``V4L2_FIELD_TOP`` or ``V4L2_FIELD_BOTTOM``. Any two successive
 	  fields pair to build a frame. If fields are successive, without
 	  any dropped fields between them (fields can drop individually),
 	  can be determined from the struct
-	  :ref:`v4l2_buffer <v4l2-buffer>` ``sequence`` field. This
+	  :c:type:`v4l2_buffer` ``sequence`` field. This
 	  format cannot be selected when using the read/write I/O method
 	  since there is no way to communicate if a field was a top or
 	  bottom field.
diff --git a/Documentation/media/uapi/v4l/format.rst b/Documentation/media/uapi/v4l/format.rst
index 7c73278849ca..452c6d59cad5 100644
--- a/Documentation/media/uapi/v4l/format.rst
+++ b/Documentation/media/uapi/v4l/format.rst
@@ -22,7 +22,7 @@ to satisfy the request. Of course applications can also just query the
 current selection.
 
 A single mechanism exists to negotiate all data formats using the
-aggregate struct :ref:`v4l2_format <v4l2-format>` and the
+aggregate struct :c:type:`v4l2_format` and the
 :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` and
 :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctls. Additionally the
 :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` ioctl can be used to examine
diff --git a/Documentation/media/uapi/v4l/func-mmap.rst b/Documentation/media/uapi/v4l/func-mmap.rst
index bd19cef952f5..6d2ce539bd72 100644
--- a/Documentation/media/uapi/v4l/func-mmap.rst
+++ b/Documentation/media/uapi/v4l/func-mmap.rst
@@ -37,9 +37,9 @@ Arguments
 ``length``
     Length of the memory area to map. This must be the same value as
     returned by the driver in the struct
-    :ref:`v4l2_buffer <v4l2-buffer>` ``length`` field for the
+    :c:type:`v4l2_buffer` ``length`` field for the
     single-planar API, and the same value as returned by the driver in
-    the struct :ref:`v4l2_plane <v4l2-plane>` ``length`` field for
+    the struct :c:type:`v4l2_plane` ``length`` field for
     the multi-planar API.
 
 ``prot``
@@ -92,9 +92,9 @@ Arguments
 ``offset``
     Offset of the buffer in device memory. This must be the same value
     as returned by the driver in the struct
-    :ref:`v4l2_buffer <v4l2-buffer>` ``m`` union ``offset`` field for
+    :c:type:`v4l2_buffer` ``m`` union ``offset`` field for
     the single-planar API, and the same value as returned by the driver
-    in the struct :ref:`v4l2_plane <v4l2-plane>` ``m`` union
+    in the struct :c:type:`v4l2_plane` ``m`` union
     ``mem_offset`` field for the multi-planar API.
 
 
diff --git a/Documentation/media/uapi/v4l/func-munmap.rst b/Documentation/media/uapi/v4l/func-munmap.rst
index a1a4d8cb6c4b..c2f4043d7d2b 100644
--- a/Documentation/media/uapi/v4l/func-munmap.rst
+++ b/Documentation/media/uapi/v4l/func-munmap.rst
@@ -34,9 +34,9 @@ Arguments
 ``length``
     Length of the mapped buffer. This must be the same value as given to
     :ref:`mmap() <func-mmap>` and returned by the driver in the struct
-    :ref:`v4l2_buffer <v4l2-buffer>` ``length`` field for the
+    :c:type:`v4l2_buffer` ``length`` field for the
     single-planar API and in the struct
-    :ref:`v4l2_plane <v4l2-plane>` ``length`` field for the
+    :c:type:`v4l2_plane` ``length`` field for the
     multi-planar API.
 
 
diff --git a/Documentation/media/uapi/v4l/hist-v4l2.rst b/Documentation/media/uapi/v4l/hist-v4l2.rst
index 3ba1c0c2df1a..a84895968349 100644
--- a/Documentation/media/uapi/v4l/hist-v4l2.rst
+++ b/Documentation/media/uapi/v4l/hist-v4l2.rst
@@ -45,7 +45,7 @@ renamed to :ref:`VIDIOC_ENUMSTD`,
 Codec API was released.
 
 1998-11-08: Many minor changes. Most symbols have been renamed. Some
-material changes to struct :ref:`v4l2_capability <v4l2-capability>`.
+material changes to struct :c:type:`v4l2_capability`.
 
 1998-11-12: The read/write directon of some ioctls was misdefined.
 
@@ -117,7 +117,7 @@ to simplify the API, while making it more extensible and following
 common Linux driver API conventions.
 
 1. Some typos in ``V4L2_FMT_FLAG`` symbols were fixed. struct
-   :ref:`v4l2_clip <v4l2-clip>` was changed for compatibility with
+   :c:type:`v4l2_clip` was changed for compatibility with
    v4l. (1999-08-30)
 
 2. ``V4L2_TUNER_SUB_LANG1`` was added. (1999-09-05)
@@ -152,14 +152,14 @@ common Linux driver API conventions.
    ``VIDIOC_G_INFMT``, ``VIDIOC_S_OUTFMT``, ``VIDIOC_G_OUTFMT``,
    ``VIDIOC_S_VBIFMT`` and ``VIDIOC_G_VBIFMT``. The image format
    structure :c:type:`struct v4l2_format` was renamed to struct
-   :ref:`v4l2_pix_format <v4l2-pix-format>`, while struct
-   :ref:`v4l2_format <v4l2-format>` is now the envelopping structure
+   :c:type:`v4l2_pix_format`, while struct
+   :c:type:`v4l2_format` is now the envelopping structure
    for all format negotiations.
 
 5. Similar to the changes above, the ``VIDIOC_G_PARM`` and
    ``VIDIOC_S_PARM`` ioctls were merged with ``VIDIOC_G_OUTPARM`` and
    ``VIDIOC_S_OUTPARM``. A ``type`` field in the new struct
-   :ref:`v4l2_streamparm <v4l2-streamparm>` selects the respective
+   :c:type:`v4l2_streamparm` selects the respective
    union member.
 
    This change obsoletes the ``VIDIOC_G_OUTPARM`` and
@@ -178,7 +178,7 @@ common Linux driver API conventions.
    categories might have a greater separation, or may even appear in
    separate windows.
 
-7. The struct :ref:`v4l2_buffer <v4l2-buffer>` ``timestamp`` was
+7. The struct :c:type:`v4l2_buffer` ``timestamp`` was
    changed to a 64 bit integer, containing the sampling or output time
    of the frame in nanoseconds. Additionally timestamps will be in
    absolute system time, not starting from zero at the beginning of a
@@ -202,7 +202,7 @@ common Linux driver API conventions.
    return a 64-bit integer.
 
 8. A ``sequence`` field was added to struct
-   :ref:`v4l2_buffer <v4l2-buffer>`. The ``sequence`` field counts
+   :c:type:`v4l2_buffer`. The ``sequence`` field counts
    captured frames, it is ignored by output devices. When a capture
    driver drops a frame, the sequence number of that frame is skipped.
 
@@ -210,7 +210,7 @@ common Linux driver API conventions.
 V4L2 Version 0.20 incremental changes
 =====================================
 
-1999-12-23: In struct :ref:`v4l2_vbi_format <v4l2-vbi-format>` the
+1999-12-23: In struct :c:type:`v4l2_vbi_format` the
 ``reserved1`` field became ``offset``. Previously drivers were required
 to clear the ``reserved1`` field.
 
@@ -256,7 +256,7 @@ compatibility* as the :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` and
 :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctls may fail now if the struct
 :c:type:`struct v4l2_fmt` ``type`` field does not contain
 ``V4L2_BUF_TYPE_VBI``. In the documentation of the struct
-:ref:`v4l2_vbi_format <v4l2-vbi-format>` ``offset`` field the
+:c:type:`v4l2_vbi_format` ``offset`` field the
 ambiguous phrase "rising edge" was changed to "leading edge".
 
 
@@ -321,7 +321,7 @@ This unnamed version was finally merged into Linux 2.5.46.
     until the application attempts to initiate a data exchange, see
     :ref:`open`.
 
-3.  The struct :ref:`v4l2_capability <v4l2-capability>` changed
+3.  The struct :c:type:`v4l2_capability` changed
     dramatically. Note that also the size of the structure changed,
     which is encoded in the ioctl request code, thus older V4L2 devices
     will respond with an ``EINVAL`` error code to the new
@@ -354,7 +354,7 @@ This unnamed version was finally merged into Linux 2.5.46.
     ``V4L2_FLAG_MONOCHROME`` flag was removed, this information is
     available as described in :ref:`format`.
 
-4.  In struct :ref:`v4l2_input <v4l2-input>` the ``assoc_audio``
+4.  In struct :c:type:`v4l2_input` the ``assoc_audio``
     field and the ``capability`` field and its only flag
     ``V4L2_INPUT_CAP_AUDIO`` was replaced by the new ``audioset`` field.
     Instead of linking one video input to one audio input this field
@@ -363,11 +363,11 @@ This unnamed version was finally merged into Linux 2.5.46.
     New fields are ``tuner`` (reversing the former link from tuners to
     video inputs), ``std`` and ``status``.
 
-    Accordingly struct :ref:`v4l2_output <v4l2-output>` lost its
+    Accordingly struct :c:type:`v4l2_output` lost its
     ``capability`` and ``assoc_audio`` fields. ``audioset``,
     ``modulator`` and ``std`` where added instead.
 
-5.  The struct :ref:`v4l2_audio <v4l2-audio>` field ``audio`` was
+5.  The struct :c:type:`v4l2_audio` field ``audio`` was
     renamed to ``index``, for consistency with other structures. A new
     capability flag ``V4L2_AUDCAP_STEREO`` was added to indicated if the
     audio input in question supports stereo sound.
@@ -376,20 +376,20 @@ This unnamed version was finally merged into Linux 2.5.46.
     (However the same applies to AVL which is still there.)
 
     Again for consistency the struct
-    :ref:`v4l2_audioout <v4l2-audioout>` field ``audio`` was renamed
+    :c:type:`v4l2_audioout` field ``audio`` was renamed
     to ``index``.
 
-6.  The struct :ref:`v4l2_tuner <v4l2-tuner>` ``input`` field was
+6.  The struct :c:type:`v4l2_tuner` ``input`` field was
     replaced by an ``index`` field, permitting devices with multiple
     tuners. The link between video inputs and tuners is now reversed,
     inputs point to their tuner. The ``std`` substructure became a
     simple set (more about this below) and moved into struct
-    :ref:`v4l2_input <v4l2-input>`. A ``type`` field was added.
+    :c:type:`v4l2_input`. A ``type`` field was added.
 
-    Accordingly in struct :ref:`v4l2_modulator <v4l2-modulator>` the
+    Accordingly in struct :c:type:`v4l2_modulator` the
     ``output`` was replaced by an ``index`` field.
 
-    In struct :ref:`v4l2_frequency <v4l2-frequency>` the ``port``
+    In struct :c:type:`v4l2_frequency` the ``port``
     field was replaced by a ``tuner`` field containing the respective
     tuner or modulator index number. A tuner ``type`` field was added
     and the ``reserved`` field became larger for future extensions
@@ -405,7 +405,7 @@ This unnamed version was finally merged into Linux 2.5.46.
     :ref:`VIDIOC_S_STD <VIDIOC_G_STD>` now take a pointer to this
     type as argument. :ref:`VIDIOC_QUERYSTD` was
     added to autodetect the received standard, if the hardware has this
-    capability. In struct :ref:`v4l2_standard <v4l2-standard>` an
+    capability. In struct :c:type:`v4l2_standard` an
     ``index`` field was added for
     :ref:`VIDIOC_ENUMSTD`. A
     :ref:`v4l2_std_id <v4l2-std-id>` field named ``id`` was added as
@@ -417,10 +417,10 @@ This unnamed version was finally merged into Linux 2.5.46.
 
     Struct :c:type:`struct v4l2_enumstd` ceased to be.
     :ref:`VIDIOC_ENUMSTD` now takes a pointer to a
-    struct :ref:`v4l2_standard <v4l2-standard>` directly. The
+    struct :c:type:`v4l2_standard` directly. The
     information which standards are supported by a particular video
-    input or output moved into struct :ref:`v4l2_input <v4l2-input>`
-    and struct :ref:`v4l2_output <v4l2-output>` fields named ``std``,
+    input or output moved into struct :c:type:`v4l2_input`
+    and struct :c:type:`v4l2_output` fields named ``std``,
     respectively.
 
 8.  The struct :ref:`v4l2_queryctrl <v4l2-queryctrl>` fields
@@ -432,8 +432,8 @@ This unnamed version was finally merged into Linux 2.5.46.
     :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`, but without the overhead of
     programming the hardware and regardless of I/O in progress.
 
-    In struct :ref:`v4l2_format <v4l2-format>` the ``fmt`` union was
-    extended to contain struct :ref:`v4l2_window <v4l2-window>`. All
+    In struct :c:type:`v4l2_format` the ``fmt`` union was
+    extended to contain struct :c:type:`v4l2_window`. All
     image format negotiations are now possible with ``VIDIOC_G_FMT``,
     ``VIDIOC_S_FMT`` and ``VIDIOC_TRY_FMT``; ioctl. The ``VIDIOC_G_WIN``
     and ``VIDIOC_S_WIN`` ioctls to prepare for a video overlay were
@@ -533,15 +533,15 @@ This unnamed version was finally merged into Linux 2.5.46.
 	   -  ``V4L2_BUF_TYPE_PRIVATE`` (but this is deprecated)
 
 
-10. In struct :ref:`v4l2_fmtdesc <v4l2-fmtdesc>` a enum
+10. In struct :c:type:`v4l2_fmtdesc` a enum
     :ref:`v4l2_buf_type <v4l2-buf-type>` field named ``type`` was
-    added as in struct :ref:`v4l2_format <v4l2-format>`. The
+    added as in struct :c:type:`v4l2_format`. The
     ``VIDIOC_ENUM_FBUFFMT`` ioctl is no longer needed and was removed.
     These calls can be replaced by
     :ref:`VIDIOC_ENUM_FMT` with type
     ``V4L2_BUF_TYPE_VIDEO_OVERLAY``.
 
-11. In struct :ref:`v4l2_pix_format <v4l2-pix-format>` the ``depth``
+11. In struct :c:type:`v4l2_pix_format` the ``depth``
     field was removed, assuming applications which recognize the format
     by its four-character-code already know the color depth, and others
     do not care about it. The same rationale lead to the removal of the
@@ -620,7 +620,7 @@ This unnamed version was finally merged into Linux 2.5.46.
     ``V4L2_COLORSPACE_BT878``, ``V4L2_COLORSPACE_470_SYSTEM_M`` or
     ``V4L2_COLORSPACE_470_SYSTEM_BG`` replaces ``V4L2_FMT_CS_601YUV``.
 
-12. In struct :ref:`v4l2_requestbuffers <v4l2-requestbuffers>` the
+12. In struct :c:type:`v4l2_requestbuffers` the
     ``type`` field was properly defined as enum
     :ref:`v4l2_buf_type <v4l2-buf-type>`. Buffer types changed as
     mentioned above. A new ``memory`` field of type enum
@@ -628,7 +628,7 @@ This unnamed version was finally merged into Linux 2.5.46.
     I/O methods using buffers allocated by the driver or the
     application. See :ref:`io` for details.
 
-13. In struct :ref:`v4l2_buffer <v4l2-buffer>` the ``type`` field was
+13. In struct :c:type:`v4l2_buffer` the ``type`` field was
     properly defined as enum :ref:`v4l2_buf_type <v4l2-buf-type>`.
     Buffer types changed as mentioned above. A ``field`` field of type
     enum :ref:`v4l2_field <v4l2-field>` was added to indicate if a
@@ -648,7 +648,7 @@ This unnamed version was finally merged into Linux 2.5.46.
     indeed allocated in device memory rather than DMA-able system
     memory. It was barely useful and so was removed.
 
-14. In struct :ref:`v4l2_framebuffer <v4l2-framebuffer>` the
+14. In struct :c:type:`v4l2_framebuffer` the
     ``base[3]`` array anticipating double- and triple-buffering in
     off-screen video memory, however without defining a synchronization
     mechanism, was replaced by a single pointer. The
@@ -659,13 +659,13 @@ This unnamed version was finally merged into Linux 2.5.46.
     ``V4L2_FBUF_CAP_LIST_CLIPPING`` and
     ``V4L2_FBUF_CAP_BITMAP_CLIPPING``.
 
-15. In struct :ref:`v4l2_clip <v4l2-clip>` the ``x``, ``y``,
+15. In struct :c:type:`v4l2_clip` the ``x``, ``y``,
     ``width`` and ``height`` field moved into a ``c`` substructure of
-    type struct :ref:`v4l2_rect <v4l2-rect>`. The ``x`` and ``y``
+    type struct :c:type:`v4l2_rect`. The ``x`` and ``y``
     fields were renamed to ``left`` and ``top``, i. e. offsets to a
     context dependent origin.
 
-16. In struct :ref:`v4l2_window <v4l2-window>` the ``x``, ``y``,
+16. In struct :c:type:`v4l2_window` the ``x``, ``y``,
     ``width`` and ``height`` field moved into a ``w`` substructure as
     above. A ``field`` field of type %v4l2-field; was added to
     distinguish between field and frame (interlaced) overlay.
@@ -678,21 +678,21 @@ This unnamed version was finally merged into Linux 2.5.46.
     :c:type:`struct v4l2_cropcap` and :c:type:`struct v4l2_crop`
     where redefined for this purpose. See :ref:`crop` for details.
 
-18. In struct :ref:`v4l2_vbi_format <v4l2-vbi-format>` the
+18. In struct :c:type:`v4l2_vbi_format` the
     ``SAMPLE_FORMAT`` field now contains a four-character-code as used
     to identify video image formats and ``V4L2_PIX_FMT_GREY`` replaces
     the ``V4L2_VBI_SF_UBYTE`` define. The ``reserved`` field was
     extended.
 
-19. In struct :ref:`v4l2_captureparm <v4l2-captureparm>` the type of
+19. In struct :c:type:`v4l2_captureparm` the type of
     the ``timeperframe`` field changed from unsigned long to struct
-    :ref:`v4l2_fract <v4l2-fract>`. This allows the accurate
+    :c:type:`v4l2_fract`. This allows the accurate
     expression of multiples of the NTSC-M frame rate 30000 / 1001. A new
     field ``readbuffers`` was added to control the driver behaviour in
     read I/O mode.
 
     Similar changes were made to struct
-    :ref:`v4l2_outputparm <v4l2-outputparm>`.
+    :c:type:`v4l2_outputparm`.
 
 20. The struct :c:type:`struct v4l2_performance` and
     ``VIDIOC_G_PERF`` ioctl were dropped. Except when using the
@@ -834,7 +834,7 @@ V4L2 in Linux 2.6.8
 ===================
 
 1. A new field ``input`` (former ``reserved[0]``) was added to the
-   struct :ref:`v4l2_buffer <v4l2-buffer>` structure. Purpose of this
+   struct :c:type:`v4l2_buffer` structure. Purpose of this
    field is to alternate between video inputs (e. g. cameras) in step
    with the video capturing process. This function must be enabled with
    the new ``V4L2_BUF_FLAG_INPUT`` flag. The ``flags`` field is no
@@ -854,7 +854,7 @@ V4L2 spec erratum 2004-08-01
 
 4. The documentation of the :ref:`VIDIOC_QBUF` and
    :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctls did not mention the
-   struct :ref:`v4l2_buffer <v4l2-buffer>` ``memory`` field. It was
+   struct :c:type:`v4l2_buffer` ``memory`` field. It was
    also missing from examples. Also on the ``VIDIOC_DQBUF`` page the ``EIO``
    error code was not documented.
 
@@ -901,7 +901,7 @@ V4L2 spec erratum 2006-01-10
 ============================
 
 1. The ``V4L2_IN_ST_COLOR_KILL`` flag in struct
-   :ref:`v4l2_input <v4l2-input>` not only indicates if the color
+   :c:type:`v4l2_input` not only indicates if the color
    killer is enabled, but also if it is active. (The color killer
    disables color decoding when it detects no color in the video signal
    to improve the image quality.)
@@ -914,16 +914,16 @@ V4L2 spec erratum 2006-01-10
 V4L2 spec erratum 2006-02-03
 ============================
 
-1. In struct :ref:`v4l2_captureparm <v4l2-captureparm>` and struct
-   :ref:`v4l2_outputparm <v4l2-outputparm>` the ``timeperframe``
+1. In struct :c:type:`v4l2_captureparm` and struct
+   :c:type:`v4l2_outputparm` the ``timeperframe``
    field gives the time in seconds, not microseconds.
 
 
 V4L2 spec erratum 2006-02-04
 ============================
 
-1. The ``clips`` field in struct :ref:`v4l2_window <v4l2-window>`
-   must point to an array of struct :ref:`v4l2_clip <v4l2-clip>`, not
+1. The ``clips`` field in struct :c:type:`v4l2_window`
+   must point to an array of struct :c:type:`v4l2_clip`, not
    a linked list, because drivers ignore the struct
    :c:type:`struct v4l2_clip`. ``next`` pointer.
 
@@ -951,18 +951,18 @@ V4L2 spec erratum 2006-09-23 (Draft 0.15)
    not mentioned along with other buffer types.
 
 2. In :ref:`VIDIOC_G_AUDIO <VIDIOC_G_AUDIO>` it was clarified that the struct
-   :ref:`v4l2_audio <v4l2-audio>` ``mode`` field is a flags field.
+   :c:type:`v4l2_audio` ``mode`` field is a flags field.
 
 3. :ref:`VIDIOC_QUERYCAP` did not mention the sliced VBI and radio
    capability flags.
 
 4. In :ref:`VIDIOC_G_FREQUENCY <VIDIOC_G_FREQUENCY>` it was clarified that applications
    must initialize the tuner ``type`` field of struct
-   :ref:`v4l2_frequency <v4l2-frequency>` before calling
+   :c:type:`v4l2_frequency` before calling
    :ref:`VIDIOC_S_FREQUENCY <VIDIOC_G_FREQUENCY>`.
 
 5. The ``reserved`` array in struct
-   :ref:`v4l2_requestbuffers <v4l2-requestbuffers>` has 2 elements,
+   :c:type:`v4l2_requestbuffers` has 2 elements,
    not 32.
 
 6. In :ref:`output` and :ref:`raw-vbi` the device file names
@@ -991,7 +991,7 @@ V4L2 in Linux 2.6.18
 V4L2 in Linux 2.6.19
 ====================
 
-1. In struct :ref:`v4l2_sliced_vbi_cap <v4l2-sliced-vbi-cap>` a
+1. In struct :c:type:`v4l2_sliced_vbi_cap` a
    buffer type field was added replacing a reserved field. Note on
    architectures where the size of enum types differs from int types the
    size of the structure changed. The
@@ -1038,15 +1038,15 @@ V4L2 in Linux 2.6.22
    and :ref:`VIDIOC_S_FBUF <VIDIOC_G_FBUF>` ioctls for details.
 
    A new ``global_alpha`` field was added to
-   :ref:`v4l2_window <v4l2-window>`, extending the structure. This
+   :c:type:`v4l2_window`, extending the structure. This
    may *break compatibility* with applications using a struct
    :c:type:`struct v4l2_window` directly. However the
    :ref:`VIDIOC_G/S/TRY_FMT <VIDIOC_G_FMT>` ioctls, which take a
-   pointer to a :ref:`v4l2_format <v4l2-format>` parent structure
+   pointer to a :c:type:`v4l2_format` parent structure
    with padding bytes at the end, are not affected.
 
 3. The format of the ``chromakey`` field in struct
-   :ref:`v4l2_window <v4l2-window>` changed from "host order RGB32"
+   :c:type:`v4l2_window` changed from "host order RGB32"
    to a pixel value in the same format as the framebuffer. This may
    *break compatibility* with existing applications. Drivers supporting
    the "host order RGB32" format are not known.
@@ -1339,7 +1339,7 @@ V4L2 in Linux 3.16
 V4L2 in Linux 3.17
 ==================
 
-1. Extended struct :ref:`v4l2_pix_format <v4l2-pix-format>`. Added
+1. Extended struct :c:type:`v4l2_pix_format`. Added
    format flags.
 
 2. Added compound control types and
@@ -1359,8 +1359,8 @@ V4L2 in Linux 3.19
 1. Rewrote Colorspace chapter, added new enum
    :ref:`v4l2_ycbcr_encoding <v4l2-ycbcr-encoding>` and enum
    :ref:`v4l2_quantization <v4l2-quantization>` fields to struct
-   :ref:`v4l2_pix_format <v4l2-pix-format>`, struct
-   :ref:`v4l2_pix_format_mplane <v4l2-pix-format-mplane>` and
+   :c:type:`v4l2_pix_format`, struct
+   :c:type:`v4l2_pix_format_mplane` and
    struct :ref:`v4l2_mbus_framefmt <v4l2-mbus-framefmt>`.
 
 
diff --git a/Documentation/media/uapi/v4l/mmap.rst b/Documentation/media/uapi/v4l/mmap.rst
index 7ad5d5e76163..670596c1a4f7 100644
--- a/Documentation/media/uapi/v4l/mmap.rst
+++ b/Documentation/media/uapi/v4l/mmap.rst
@@ -8,7 +8,7 @@ Streaming I/O (Memory Mapping)
 
 Input and output devices support this I/O method when the
 ``V4L2_CAP_STREAMING`` flag in the ``capabilities`` field of struct
-:ref:`v4l2_capability <v4l2-capability>` returned by the
+:c:type:`v4l2_capability` returned by the
 :ref:`VIDIOC_QUERYCAP` ioctl is set. There are two
 streaming methods, to determine if the memory mapping flavor is
 supported applications must call the :ref:`VIDIOC_REQBUFS` ioctl
@@ -39,10 +39,10 @@ address space with the :ref:`mmap() <func-mmap>` function. The
 location of the buffers in device memory can be determined with the
 :ref:`VIDIOC_QUERYBUF` ioctl. In the single-planar
 API case, the ``m.offset`` and ``length`` returned in a struct
-:ref:`v4l2_buffer <v4l2-buffer>` are passed as sixth and second
+:c:type:`v4l2_buffer` are passed as sixth and second
 parameter to the :ref:`mmap() <func-mmap>` function. When using the
-multi-planar API, struct :ref:`v4l2_buffer <v4l2-buffer>` contains an
-array of struct :ref:`v4l2_plane <v4l2-plane>` structures, each
+multi-planar API, struct :c:type:`v4l2_buffer` contains an
+array of struct :c:type:`v4l2_plane` structures, each
 containing its own ``m.offset`` and ``length``. When using the
 multi-planar API, every plane of every buffer has to be mapped
 separately, so the number of calls to :ref:`mmap() <func-mmap>` should
@@ -218,7 +218,7 @@ to function, apart of this no limit exists on the number of buffers
 applications can enqueue in advance, or dequeue and process. They can
 also enqueue in a different order than buffers have been dequeued, and
 the driver can *fill* enqueued *empty* buffers in any order.  [#f2]_ The
-index number of a buffer (struct :ref:`v4l2_buffer <v4l2-buffer>`
+index number of a buffer (struct :c:type:`v4l2_buffer`
 ``index``) plays no role here, it only identifies the buffer.
 
 Initially all mapped buffers are in dequeued state, inaccessible by the
@@ -251,7 +251,7 @@ To start and stop capturing or output applications call the
    removes all buffers from both queues as a side effect. Since there is
    no notion of doing anything "now" on a multitasking system, if an
    application needs to synchronize with another event it should examine
-   the struct ::ref:`v4l2_buffer <v4l2-buffer>` ``timestamp`` of captured
+   the struct ::c:type:`v4l2_buffer` ``timestamp`` of captured
    or outputted buffers.
 
 Drivers implementing memory mapping I/O must support the
diff --git a/Documentation/media/uapi/v4l/pixfmt-002.rst b/Documentation/media/uapi/v4l/pixfmt-002.rst
index 58e872f66a07..789937900d14 100644
--- a/Documentation/media/uapi/v4l/pixfmt-002.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-002.rst
@@ -6,7 +6,7 @@ Single-planar format structure
 
 .. tabularcolumns:: |p{4.0cm}|p{2.5cm}|p{11.0cm}|
 
-.. _v4l2-pix-format:
+.. c:type:: v4l2_pix_format
 
 .. cssclass:: longtable
 
@@ -136,7 +136,7 @@ Single-planar format structure
        -  ``priv``
 
        -  This field indicates whether the remaining fields of the
-	  :ref:`struct v4l2_pix_format <v4l2-pix-format>` structure, also called the
+	  :c:type:`struct v4l2_pix_format <v4l2_pix_format>` structure, also called the
 	  extended fields, are valid. When set to
 	  ``V4L2_PIX_FMT_PRIV_MAGIC``, it indicates that the extended fields
 	  have been correctly initialized. When set to any other value it
@@ -152,7 +152,7 @@ Single-planar format structure
 	  To use the extended fields, applications must set the ``priv``
 	  field to ``V4L2_PIX_FMT_PRIV_MAGIC``, initialize all the extended
 	  fields and zero the unused bytes of the
-	  :ref:`struct v4l2_format <v4l2-format>` ``raw_data`` field.
+	  :c:type:`struct v4l2_format <v4l2_format>` ``raw_data`` field.
 
 	  When the ``priv`` field isn't set to ``V4L2_PIX_FMT_PRIV_MAGIC``
 	  drivers must act as if all the extended fields were set to zero.
diff --git a/Documentation/media/uapi/v4l/pixfmt-003.rst b/Documentation/media/uapi/v4l/pixfmt-003.rst
index 6ec8ce639764..b214b818baa7 100644
--- a/Documentation/media/uapi/v4l/pixfmt-003.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-003.rst
@@ -4,17 +4,17 @@
 Multi-planar format structures
 ******************************
 
-The :ref:`struct v4l2_plane_pix_format <v4l2-plane-pix-format>` structures define size
+The :c:type:`struct v4l2_plane_pix_format <v4l2_plane_pix_format>` structures define size
 and layout for each of the planes in a multi-planar format. The
-:ref:`struct v4l2_pix_format_mplane <v4l2-pix-format-mplane>` structure contains
+:c:type:`struct v4l2_pix_format_mplane <v4l2_pix_format_mplane>` structure contains
 information common to all planes (such as image width and height) and an
-array of :ref:`struct v4l2_plane_pix_format <v4l2-plane-pix-format>` structures,
+array of :c:type:`struct v4l2_plane_pix_format <v4l2_plane_pix_format>` structures,
 describing all planes of that format.
 
 
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
-.. _v4l2-plane-pix-format:
+.. c:type:: v4l2_plane_pix_format
 
 .. flat-table:: struct v4l2_plane_pix_format
     :header-rows:  0
@@ -37,7 +37,7 @@ describing all planes of that format.
        -  ``bytesperline``
 
        -  Distance in bytes between the leftmost pixels in two adjacent
-	  lines. See struct :ref:`v4l2_pix_format <v4l2-pix-format>`.
+	  lines. See struct :c:type:`v4l2_pix_format`.
 
     -  .. row 3
 
@@ -51,7 +51,7 @@ describing all planes of that format.
 
 .. tabularcolumns:: |p{4.4cm}|p{5.6cm}|p{7.5cm}|
 
-.. _v4l2-pix-format-mplane:
+.. c:type:: v4l2_pix_format_mplane
 
 .. flat-table:: struct v4l2_pix_format_mplane
     :header-rows:  0
@@ -66,7 +66,7 @@ describing all planes of that format.
        -  ``width``
 
        -  Image width in pixels. See struct
-	  :ref:`v4l2_pix_format <v4l2-pix-format>`.
+	  :c:type:`v4l2_pix_format`.
 
     -  .. row 2
 
@@ -75,7 +75,7 @@ describing all planes of that format.
        -  ``height``
 
        -  Image height in pixels. See struct
-	  :ref:`v4l2_pix_format <v4l2-pix-format>`.
+	  :c:type:`v4l2_pix_format`.
 
     -  .. row 3
 
@@ -92,7 +92,7 @@ describing all planes of that format.
 
        -  ``field``
 
-       -  See struct :ref:`v4l2_pix_format <v4l2-pix-format>`.
+       -  See struct :c:type:`v4l2_pix_format`.
 
     -  .. row 5
 
@@ -100,11 +100,11 @@ describing all planes of that format.
 
        -  ``colorspace``
 
-       -  See struct :ref:`v4l2_pix_format <v4l2-pix-format>`.
+       -  See struct :c:type:`v4l2_pix_format`.
 
     -  .. row 6
 
-       -  struct :ref:`v4l2_plane_pix_format <v4l2-plane-pix-format>`
+       -  struct :c:type:`v4l2_plane_pix_format`
 
        -  ``plane_fmt[VIDEO_MAX_PLANES]``
 
diff --git a/Documentation/media/uapi/v4l/pixfmt-006.rst b/Documentation/media/uapi/v4l/pixfmt-006.rst
index 574294ec0a89..a97fc28e039d 100644
--- a/Documentation/media/uapi/v4l/pixfmt-006.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-006.rst
@@ -15,8 +15,8 @@ transfer functions. The third is the Y'CbCr encoding identifier (enum
 non-standard Y'CbCr encodings and the fourth is the quantization
 identifier (enum :ref:`v4l2_quantization <v4l2-quantization>`) to
 specify non-standard quantization methods. Most of the time only the
-colorspace field of struct :ref:`v4l2_pix_format <v4l2-pix-format>`
-or struct :ref:`v4l2_pix_format_mplane <v4l2-pix-format-mplane>`
+colorspace field of struct :c:type:`v4l2_pix_format`
+or struct :c:type:`v4l2_pix_format_mplane`
 needs to be filled in.
 
 .. note::
diff --git a/Documentation/media/uapi/v4l/pixfmt.rst b/Documentation/media/uapi/v4l/pixfmt.rst
index 6866bcb7d229..a6b7871e39e7 100644
--- a/Documentation/media/uapi/v4l/pixfmt.rst
+++ b/Documentation/media/uapi/v4l/pixfmt.rst
@@ -6,8 +6,8 @@
 Image Formats
 #############
 The V4L2 API was primarily designed for devices exchanging image data
-with applications. The :ref:`struct v4l2_pix_format <v4l2-pix-format>` and
-:ref:`struct v4l2_pix_format_mplane <v4l2-pix-format-mplane>` structures define the
+with applications. The :c:type:`struct v4l2_pix_format <v4l2_pix_format>` and
+:c:type:`struct v4l2_pix_format_mplane <v4l2_pix_format_mplane>` structures define the
 format and layout of an image in memory. The former is used with the
 single-planar API, while the latter is used with the multi-planar
 version (see :ref:`planar-apis`). Image formats are negotiated with
diff --git a/Documentation/media/uapi/v4l/planar-apis.rst b/Documentation/media/uapi/v4l/planar-apis.rst
index 5fe2e1188230..bd0f88b01c9a 100644
--- a/Documentation/media/uapi/v4l/planar-apis.rst
+++ b/Documentation/media/uapi/v4l/planar-apis.rst
@@ -46,16 +46,16 @@ Calls that distinguish between single and multi-planar APIs
 
 :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>`, :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`, :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>`
     New structures for describing multi-planar formats are added: struct
-    :ref:`v4l2_pix_format_mplane <v4l2-pix-format-mplane>` and
-    struct :ref:`v4l2_plane_pix_format <v4l2-plane-pix-format>`.
+    :c:type:`v4l2_pix_format_mplane` and
+    struct :c:type:`v4l2_plane_pix_format`.
     Drivers may define new multi-planar formats, which have distinct
     FourCC codes from the existing single-planar ones.
 
 :ref:`VIDIOC_QBUF <VIDIOC_QBUF>`, :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>`, :ref:`VIDIOC_QUERYBUF <VIDIOC_QUERYBUF>`
-    A new struct :ref:`v4l2_plane <v4l2-plane>` structure for
+    A new struct :c:type:`v4l2_plane` structure for
     describing planes is added. Arrays of this structure are passed in
     the new ``m.planes`` field of struct
-    :ref:`v4l2_buffer <v4l2-buffer>`.
+    :c:type:`v4l2_buffer`.
 
 :ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>`
     Will allocate multi-planar buffers as requested.
diff --git a/Documentation/media/uapi/v4l/rw.rst b/Documentation/media/uapi/v4l/rw.rst
index dcac379c484f..91596c0cc2f3 100644
--- a/Documentation/media/uapi/v4l/rw.rst
+++ b/Documentation/media/uapi/v4l/rw.rst
@@ -9,7 +9,7 @@ Read/Write
 Input and output devices support the :ref:`read() <func-read>` and
 :ref:`write() <func-write>` function, respectively, when the
 ``V4L2_CAP_READWRITE`` flag in the ``capabilities`` field of struct
-:ref:`v4l2_capability <v4l2-capability>` returned by the
+:c:type:`v4l2_capability` returned by the
 :ref:`VIDIOC_QUERYCAP` ioctl is set.
 
 Drivers may need the CPU to copy the data, but they may also support DMA
diff --git a/Documentation/media/uapi/v4l/selection-api-005.rst b/Documentation/media/uapi/v4l/selection-api-005.rst
index 94731a13efdb..5b47a28ac6d7 100644
--- a/Documentation/media/uapi/v4l/selection-api-005.rst
+++ b/Documentation/media/uapi/v4l/selection-api-005.rst
@@ -16,19 +16,19 @@ cropping from an image inside a memory buffer. The application could
 configure a capture device to fill only a part of an image by abusing
 V4L2 API. Cropping a smaller image from a larger one is achieved by
 setting the field ``bytesperline`` at struct
-:ref:`v4l2_pix_format <v4l2-pix-format>`.
+:c:type:`v4l2_pix_format`.
 Introducing an image offsets could be done by modifying field ``m_userptr``
 at struct
-:ref:`v4l2_buffer <v4l2-buffer>` before calling
+:c:type:`v4l2_buffer` before calling
 :ref:`VIDIOC_QBUF`. Those operations should be avoided because they are not
 portable (endianness), and do not work for macroblock and Bayer formats
 and mmap buffers. The selection API deals with configuration of buffer
 cropping/composing in a clear, intuitive and portable way. Next, with
 the selection API the concepts of the padded target and constraints
-flags are introduced. Finally, struct :ref:`v4l2_crop <v4l2-crop>`
-and struct :ref:`v4l2_cropcap <v4l2-cropcap>` have no reserved
+flags are introduced. Finally, struct :c:type:`v4l2_crop`
+and struct :c:type:`v4l2_cropcap` have no reserved
 fields. Therefore there is no way to extend their functionality. The new
-struct :ref:`v4l2_selection <v4l2-selection>` provides a lot of place
+struct :c:type:`v4l2_selection` provides a lot of place
 for future extensions. Driver developers are encouraged to implement
 only selection API. The former cropping API would be simulated using the
 new one.
diff --git a/Documentation/media/uapi/v4l/standard.rst b/Documentation/media/uapi/v4l/standard.rst
index 2320008f6063..75a14895aed7 100644
--- a/Documentation/media/uapi/v4l/standard.rst
+++ b/Documentation/media/uapi/v4l/standard.rst
@@ -9,8 +9,8 @@ Video Standards
 Video devices typically support one or more different video standards or
 variations of standards. Each video input and output may support another
 set of standards. This set is reported by the ``std`` field of struct
-:ref:`v4l2_input <v4l2-input>` and struct
-:ref:`v4l2_output <v4l2-output>` returned by the
+:c:type:`v4l2_input` and struct
+:c:type:`v4l2_output` returned by the
 :ref:`VIDIOC_ENUMINPUT` and
 :ref:`VIDIOC_ENUMOUTPUT` ioctls, respectively.
 
@@ -58,8 +58,8 @@ output device which is:
 -  that does not support the video standard formats at all.
 
 Here the driver shall set the ``std`` field of struct
-:ref:`v4l2_input <v4l2-input>` and struct
-:ref:`v4l2_output <v4l2-output>` to zero and the :ref:`VIDIOC_G_STD <VIDIOC_G_STD>`,
+:c:type:`v4l2_input` and struct
+:c:type:`v4l2_output` to zero and the :ref:`VIDIOC_G_STD <VIDIOC_G_STD>`,
 :ref:`VIDIOC_S_STD <VIDIOC_G_STD>`, :ref:`VIDIOC_QUERYSTD` and :ref:`VIDIOC_ENUMSTD` ioctls
 shall return the ``ENOTTY`` error code or the ``EINVAL`` error code.
 
diff --git a/Documentation/media/uapi/v4l/streaming-par.rst b/Documentation/media/uapi/v4l/streaming-par.rst
index b07b0f0b35d4..f9b93c53f75c 100644
--- a/Documentation/media/uapi/v4l/streaming-par.rst
+++ b/Documentation/media/uapi/v4l/streaming-par.rst
@@ -25,7 +25,7 @@ section discussing the :ref:`read() <func-read>` function.
 To get and set the streaming parameters applications call the
 :ref:`VIDIOC_G_PARM <VIDIOC_G_PARM>` and
 :ref:`VIDIOC_S_PARM <VIDIOC_G_PARM>` ioctl, respectively. They take
-a pointer to a struct :ref:`v4l2_streamparm <v4l2-streamparm>`, which
+a pointer to a struct :c:type:`v4l2_streamparm`, which
 contains a union holding separate parameters for input and output
 devices.
 
diff --git a/Documentation/media/uapi/v4l/tuner.rst b/Documentation/media/uapi/v4l/tuner.rst
index c3df65c2e320..4064841d8963 100644
--- a/Documentation/media/uapi/v4l/tuner.rst
+++ b/Documentation/media/uapi/v4l/tuner.rst
@@ -13,7 +13,7 @@ Tuners
 Video input devices can have one or more tuners demodulating a RF
 signal. Each tuner is associated with one or more video inputs,
 depending on the number of RF connectors on the tuner. The ``type``
-field of the respective struct :ref:`v4l2_input <v4l2-input>`
+field of the respective struct :c:type:`v4l2_input`
 returned by the :ref:`VIDIOC_ENUMINPUT` ioctl is
 set to ``V4L2_INPUT_TYPE_TUNER`` and its ``tuner`` field contains the
 index number of the tuner.
@@ -24,7 +24,7 @@ inputs.
 To query and change tuner properties applications use the
 :ref:`VIDIOC_G_TUNER <VIDIOC_G_TUNER>` and
 :ref:`VIDIOC_S_TUNER <VIDIOC_G_TUNER>` ioctls, respectively. The
-struct :ref:`v4l2_tuner <v4l2-tuner>` returned by :ref:`VIDIOC_G_TUNER <VIDIOC_G_TUNER>`
+struct :c:type:`v4l2_tuner` returned by :ref:`VIDIOC_G_TUNER <VIDIOC_G_TUNER>`
 also contains signal status information applicable when the tuner of the
 current video or radio input is queried.
 
@@ -46,7 +46,7 @@ video signal for radiation or connection to the antenna input of a TV
 set or video recorder. Each modulator is associated with one or more
 video outputs, depending on the number of RF connectors on the
 modulator. The ``type`` field of the respective struct
-:ref:`v4l2_output <v4l2-output>` returned by the
+:c:type:`v4l2_output` returned by the
 :ref:`VIDIOC_ENUMOUTPUT` ioctl is set to
 ``V4L2_OUTPUT_TYPE_MODULATOR`` and its ``modulator`` field contains the
 index number of the modulator.
@@ -68,7 +68,7 @@ To query and change modulator properties applications use the
 is more than one at all. The modulator is solely determined by the
 current video output. Drivers must support both ioctls and set the
 ``V4L2_CAP_MODULATOR`` flag in the struct
-:ref:`v4l2_capability <v4l2-capability>` returned by the
+:c:type:`v4l2_capability` returned by the
 :ref:`VIDIOC_QUERYCAP` ioctl when the device has
 one or more modulators.
 
@@ -79,7 +79,7 @@ Radio Frequency
 To get and set the tuner or modulator radio frequency applications use
 the :ref:`VIDIOC_G_FREQUENCY <VIDIOC_G_FREQUENCY>` and
 :ref:`VIDIOC_S_FREQUENCY <VIDIOC_G_FREQUENCY>` ioctl which both take
-a pointer to a struct :ref:`v4l2_frequency <v4l2-frequency>`. These
+a pointer to a struct :c:type:`v4l2_frequency`. These
 ioctls are used for TV and radio devices alike. Drivers must support
 both ioctls when the tuner or modulator ioctls are supported, or when
 the device is a radio device.
diff --git a/Documentation/media/uapi/v4l/userp.rst b/Documentation/media/uapi/v4l/userp.rst
index 0371e068c50b..dc2893a60d65 100644
--- a/Documentation/media/uapi/v4l/userp.rst
+++ b/Documentation/media/uapi/v4l/userp.rst
@@ -8,7 +8,7 @@ Streaming I/O (User Pointers)
 
 Input and output devices support this I/O method when the
 ``V4L2_CAP_STREAMING`` flag in the ``capabilities`` field of struct
-:ref:`v4l2_capability <v4l2-capability>` returned by the
+:c:type:`v4l2_capability` returned by the
 :ref:`VIDIOC_QUERYCAP` ioctl is set. If the
 particular user pointer method (not only memory mapping) is supported
 must be determined by calling the :ref:`VIDIOC_REQBUFS` ioctl
@@ -18,8 +18,8 @@ This I/O method combines advantages of the read/write and memory mapping
 methods. Buffers (planes) are allocated by the application itself, and
 can reside for example in virtual or shared memory. Only pointers to
 data are exchanged, these pointers and meta-information are passed in
-struct :ref:`v4l2_buffer <v4l2-buffer>` (or in struct
-:ref:`v4l2_plane <v4l2-plane>` in the multi-planar API case). The
+struct :c:type:`v4l2_buffer` (or in struct
+:c:type:`v4l2_plane` in the multi-planar API case). The
 driver must be switched into user pointer I/O mode by calling the
 :ref:`VIDIOC_REQBUFS` with the desired buffer type.
 No buffers (planes) are allocated beforehand, consequently they are not
@@ -94,7 +94,7 @@ To start and stop capturing or output applications call the
    both queues and unlocks all buffers as a side effect. Since there is no
    notion of doing anything "now" on a multitasking system, if an
    application needs to synchronize with another event it should examine
-   the struct :ref:`v4l2_buffer <v4l2-buffer>` ``timestamp`` of captured or
+   the struct :c:type:`v4l2_buffer` ``timestamp`` of captured or
    outputted buffers.
 
 Drivers implementing user pointer I/O must support the
diff --git a/Documentation/media/uapi/v4l/v4l2.rst b/Documentation/media/uapi/v4l/v4l2.rst
index 5e41a8505301..785d4cdd2f85 100644
--- a/Documentation/media/uapi/v4l/v4l2.rst
+++ b/Documentation/media/uapi/v4l/v4l2.rst
@@ -114,14 +114,14 @@ DVB device nodes. Add support for Tuner sub-device.
 Rewrote Colorspace chapter, added new enum
 :ref:`v4l2_ycbcr_encoding <v4l2-ycbcr-encoding>` and enum
 :ref:`v4l2_quantization <v4l2-quantization>` fields to struct
-:ref:`v4l2_pix_format <v4l2-pix-format>`, struct
-:ref:`v4l2_pix_format_mplane <v4l2-pix-format-mplane>` and struct
+:c:type:`v4l2_pix_format`, struct
+:c:type:`v4l2_pix_format_mplane` and struct
 :ref:`v4l2_mbus_framefmt <v4l2-mbus-framefmt>`.
 
 
 :revision: 3.17 / 2014-08-04 (*lp, hv*)
 
-Extended struct :ref:`v4l2_pix_format <v4l2-pix-format>`. Added
+Extended struct :c:type:`v4l2_pix_format`. Added
 format flags. Added compound control types and VIDIOC_QUERY_EXT_CTRL.
 
 
diff --git a/Documentation/media/uapi/v4l/video.rst b/Documentation/media/uapi/v4l/video.rst
index d3f00715fbc1..a205fb87d566 100644
--- a/Documentation/media/uapi/v4l/video.rst
+++ b/Documentation/media/uapi/v4l/video.rst
@@ -16,7 +16,7 @@ To learn about the number and attributes of the available inputs and
 outputs applications can enumerate them with the
 :ref:`VIDIOC_ENUMINPUT` and
 :ref:`VIDIOC_ENUMOUTPUT` ioctl, respectively. The
-struct :ref:`v4l2_input <v4l2-input>` returned by the
+struct :c:type:`v4l2_input` returned by the
 :ref:`VIDIOC_ENUMINPUT` ioctl also contains signal
 :status information applicable when the current video input is queried.
 
diff --git a/Documentation/media/uapi/v4l/vidioc-create-bufs.rst b/Documentation/media/uapi/v4l/vidioc-create-bufs.rst
index dc75f21e4b4c..c53fdcc3666a 100644
--- a/Documentation/media/uapi/v4l/vidioc-create-bufs.rst
+++ b/Documentation/media/uapi/v4l/vidioc-create-bufs.rst
@@ -39,14 +39,14 @@ over buffers is required. This ioctl can be called multiple times to
 create buffers of different sizes.
 
 To allocate the device buffers applications must initialize the relevant
-fields of the :ref:`struct v4l2_create_buffers <v4l2-create-buffers>` structure. The
+fields of the :c:type:`struct v4l2_create_buffers <v4l2_create_buffers>` structure. The
 ``count`` field must be set to the number of requested buffers, the
 ``memory`` field specifies the requested I/O method and the ``reserved``
 array must be zeroed.
 
 The ``format`` field specifies the image format that the buffers must be
 able to handle. The application has to fill in this struct
-:ref:`v4l2_format <v4l2-format>`. Usually this will be done using the
+:c:type:`v4l2_format`. Usually this will be done using the
 :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` or
 :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` ioctls to ensure that the
 requested format is supported by the driver. Based on the format's
@@ -71,7 +71,7 @@ the ``index`` fields respectively. On return ``count`` can be smaller
 than the number requested.
 
 
-.. _v4l2-create-buffers:
+.. c:type:: v4l2_create_buffers
 
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
@@ -115,7 +115,7 @@ than the number requested.
 
     -  .. row 4
 
-       -  struct :ref:`v4l2_format <v4l2-format>`
+       -  struct :c:type:`v4l2_format`
 
        -  ``format``
 
diff --git a/Documentation/media/uapi/v4l/vidioc-cropcap.rst b/Documentation/media/uapi/v4l/vidioc-cropcap.rst
index 9b7c99eef717..945596fcd65f 100644
--- a/Documentation/media/uapi/v4l/vidioc-cropcap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-cropcap.rst
@@ -50,7 +50,7 @@ support cropping and/or scaling and/or have non-square pixels, and for
 overlay devices.
 
 
-.. _v4l2-cropcap:
+.. c:type:: v4l2_cropcap
 
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
@@ -98,7 +98,7 @@ overlay devices.
 
     -  .. row 4
 
-       -  struct :ref:`v4l2_fract <v4l2-fract>`
+       -  struct :c:type:`v4l2_fract`
 
        -  ``pixelaspect``
 
@@ -165,7 +165,7 @@ appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
 
 EINVAL
-    The struct :ref:`v4l2_cropcap <v4l2-cropcap>` ``type`` is
+    The struct :c:type:`v4l2_cropcap` ``type`` is
     invalid.
 
 ENODATA
diff --git a/Documentation/media/uapi/v4l/vidioc-dbg-g-chip-info.rst b/Documentation/media/uapi/v4l/vidioc-dbg-g-chip-info.rst
index 9c97527dc2cf..f9d76f3d519d 100644
--- a/Documentation/media/uapi/v4l/vidioc-dbg-g-chip-info.rst
+++ b/Documentation/media/uapi/v4l/vidioc-dbg-g-chip-info.rst
@@ -48,7 +48,7 @@ Additionally the Linux kernel must be compiled with the
 
 To query the driver applications must initialize the ``match.type`` and
 ``match.addr`` or ``match.name`` fields of a struct
-:ref:`v4l2_dbg_chip_info <v4l2-dbg-chip-info>` and call
+:c:type:`v4l2_dbg_chip_info` and call
 :ref:`VIDIOC_DBG_G_CHIP_INFO` with a pointer to this structure. On success
 the driver stores information about the selected chip in the ``name``
 and ``flags`` fields.
@@ -124,7 +124,7 @@ instructions.
 
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
-.. _v4l2-dbg-chip-info:
+.. c:type:: v4l2_dbg_chip_info
 
 .. flat-table:: struct v4l2_dbg_chip_info
     :header-rows:  0
diff --git a/Documentation/media/uapi/v4l/vidioc-dbg-g-register.rst b/Documentation/media/uapi/v4l/vidioc-dbg-g-register.rst
index 6eeb0de24b50..08f3c510e440 100644
--- a/Documentation/media/uapi/v4l/vidioc-dbg-g-register.rst
+++ b/Documentation/media/uapi/v4l/vidioc-dbg-g-register.rst
@@ -49,7 +49,7 @@ superuser privileges. Additionally the Linux kernel must be compiled
 with the ``CONFIG_VIDEO_ADV_DEBUG`` option to enable these ioctls.
 
 To write a register applications must initialize all fields of a struct
-:ref:`v4l2_dbg_register <v4l2-dbg-register>` except for ``size`` and
+:c:type:`v4l2_dbg_register` except for ``size`` and
 call ``VIDIOC_DBG_S_REGISTER`` with a pointer to this structure. The
 ``match.type`` and ``match.addr`` or ``match.name`` fields select a chip
 on the TV card, the ``reg`` field specifies a register number and the
@@ -87,7 +87,7 @@ instructions.
 
 .. tabularcolumns:: |p{3.5cm}|p{3.5cm}|p{3.5cm}|p{7.0cm}|
 
-.. _v4l2-dbg-match:
+.. c:type:: v4l2_dbg_match
 
 .. flat-table:: struct v4l2_dbg_match
     :header-rows:  0
@@ -131,7 +131,7 @@ instructions.
 
 
 
-.. _v4l2-dbg-register:
+.. c:type:: v4l2_dbg_register
 
 .. flat-table:: struct v4l2_dbg_register
     :header-rows:  0
diff --git a/Documentation/media/uapi/v4l/vidioc-decoder-cmd.rst b/Documentation/media/uapi/v4l/vidioc-decoder-cmd.rst
index 6077caac6086..cade4603e138 100644
--- a/Documentation/media/uapi/v4l/vidioc-decoder-cmd.rst
+++ b/Documentation/media/uapi/v4l/vidioc-decoder-cmd.rst
@@ -30,7 +30,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
-    pointer to struct :ref:`v4l2_decoder_cmd <v4l2-decoder-cmd>`.
+    pointer to struct :c:type:`v4l2_decoder_cmd`.
 
 
 Description
@@ -40,7 +40,7 @@ These ioctls control an audio/video (usually MPEG-) decoder.
 ``VIDIOC_DECODER_CMD`` sends a command to the decoder,
 ``VIDIOC_TRY_DECODER_CMD`` can be used to try a command without actually
 executing it. To send a command applications must initialize all fields
-of a struct :ref:`v4l2_decoder_cmd <v4l2-decoder-cmd>` and call
+of a struct :c:type:`v4l2_decoder_cmd` and call
 ``VIDIOC_DECODER_CMD`` or ``VIDIOC_TRY_DECODER_CMD`` with a pointer to
 this structure.
 
@@ -61,7 +61,7 @@ introduced in Linux 3.3.
 
 .. tabularcolumns:: |p{1.1cm}|p{2.4cm}|p{1.2cm}|p{1.6cm}|p{10.6cm}|
 
-.. _v4l2-decoder-cmd:
+.. c:type:: v4l2_decoder_cmd
 
 .. cssclass:: longtable
 
diff --git a/Documentation/media/uapi/v4l/vidioc-dqevent.rst b/Documentation/media/uapi/v4l/vidioc-dqevent.rst
index 067e0aa27918..cf0e98f5112f 100644
--- a/Documentation/media/uapi/v4l/vidioc-dqevent.rst
+++ b/Documentation/media/uapi/v4l/vidioc-dqevent.rst
@@ -32,7 +32,7 @@ Description
 ===========
 
 Dequeue an event from a video device. No input is required for this
-ioctl. All the fields of the struct :ref:`v4l2_event <v4l2-event>`
+ioctl. All the fields of the struct :c:type:`v4l2_event`
 structure are filled by the driver. The file handle will also receive
 exceptions which the application may get by e.g. using the select system
 call.
@@ -40,7 +40,7 @@ call.
 
 .. tabularcolumns:: |p{3.0cm}|p{4.3cm}|p{2.5cm}|p{7.7cm}|
 
-.. _v4l2-event:
+.. c:type:: v4l2_event
 
 .. cssclass: longtable
 
@@ -71,7 +71,7 @@ call.
     -  .. row 3
 
        -
-       -  struct :ref:`v4l2_event_vsync <v4l2-event-vsync>`
+       -  struct :c:type:`v4l2_event_vsync`
 
        -  ``vsync``
 
@@ -80,7 +80,7 @@ call.
     -  .. row 4
 
        -
-       -  struct :ref:`v4l2_event_ctrl <v4l2-event-ctrl>`
+       -  struct :c:type:`v4l2_event_ctrl`
 
        -  ``ctrl``
 
@@ -89,7 +89,7 @@ call.
     -  .. row 5
 
        -
-       -  struct :ref:`v4l2_event_frame_sync <v4l2-event-frame-sync>`
+       -  struct :c:type:`v4l2_event_frame_sync`
 
        -  ``frame_sync``
 
@@ -98,7 +98,7 @@ call.
     -  .. row 6
 
        -
-       -  struct :ref:`v4l2_event_motion_det <v4l2-event-motion-det>`
+       -  struct :c:type:`v4l2_event_motion_det`
 
        -  ``motion_det``
 
@@ -107,7 +107,7 @@ call.
     -  .. row 7
 
        -
-       -  struct :ref:`v4l2_event_src_change <v4l2-event-src-change>`
+       -  struct :c:type:`v4l2_event_src_change`
 
        -  ``src_change``
 
@@ -205,7 +205,7 @@ call.
        -  1
 
        -  This event is triggered on the vertical sync. This event has a
-	  struct :ref:`v4l2_event_vsync <v4l2-event-vsync>` associated
+	  struct :c:type:`v4l2_event_vsync` associated
 	  with it.
 
     -  .. row 3
@@ -228,10 +228,10 @@ call.
 	  which you want to receive events. This event is triggered if the
 	  control's value changes, if a button control is pressed or if the
 	  control's flags change. This event has a struct
-	  :ref:`v4l2_event_ctrl <v4l2-event-ctrl>` associated with it.
+	  :c:type:`v4l2_event_ctrl` associated with it.
 	  This struct contains much of the same information as struct
 	  :ref:`v4l2_queryctrl <v4l2-queryctrl>` and struct
-	  :ref:`v4l2_control <v4l2-control>`.
+	  :c:type:`v4l2_control`.
 
 	  If the event is generated due to a call to
 	  :ref:`VIDIOC_S_CTRL <VIDIOC_G_CTRL>` or
@@ -243,7 +243,7 @@ call.
 
 	  This event type will ensure that no information is lost when more
 	  events are raised than there is room internally. In that case the
-	  struct :ref:`v4l2_event_ctrl <v4l2-event-ctrl>` of the
+	  struct :c:type:`v4l2_event_ctrl` of the
 	  second-oldest event is kept, but the ``changes`` field of the
 	  second-oldest event is ORed with the ``changes`` field of the
 	  oldest event.
@@ -256,13 +256,13 @@ call.
 
        -  Triggered immediately when the reception of a frame has begun.
 	  This event has a struct
-	  :ref:`v4l2_event_frame_sync <v4l2-event-frame-sync>`
+	  :c:type:`v4l2_event_frame_sync`
 	  associated with it.
 
 	  If the hardware needs to be stopped in the case of a buffer
 	  underrun it might not be able to generate this event. In such
 	  cases the ``frame_sequence`` field in struct
-	  :ref:`v4l2_event_frame_sync <v4l2-event-frame-sync>` will not
+	  :c:type:`v4l2_event_frame_sync` will not
 	  be incremented. This causes two consecutive frame sequence numbers
 	  to have n times frame interval in between them.
 
@@ -281,7 +281,7 @@ call.
 	  receive events.
 
 	  This event has a struct
-	  :ref:`v4l2_event_src_change <v4l2-event-src-change>`
+	  :c:type:`v4l2_event_src_change`
 	  associated with it. The ``changes`` bitfield denotes what has
 	  changed for the subscribed pad. If multiple events occurred before
 	  application could dequeue them, then the changes will have the
@@ -295,7 +295,7 @@ call.
 
        -  Triggered whenever the motion detection state for one or more of
 	  the regions changes. This event has a struct
-	  :ref:`v4l2_event_motion_det <v4l2-event-motion-det>`
+	  :c:type:`v4l2_event_motion_det`
 	  associated with it.
 
     -  .. row 8
@@ -310,7 +310,7 @@ call.
 
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
-.. _v4l2-event-vsync:
+.. c:type:: v4l2_event_vsync
 
 .. flat-table:: struct v4l2_event_vsync
     :header-rows:  0
@@ -330,7 +330,7 @@ call.
 
 .. tabularcolumns:: |p{3.5cm}|p{3.0cm}|p{1.8cm}|p{8.5cm}|
 
-.. _v4l2-event-ctrl:
+.. c:type:: v4l2_event_ctrl
 
 .. flat-table:: struct v4l2_event_ctrl
     :header-rows:  0
@@ -439,7 +439,7 @@ call.
 
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
-.. _v4l2-event-frame-sync:
+.. c:type:: v4l2_event_frame_sync
 
 .. flat-table:: struct v4l2_event_frame_sync
     :header-rows:  0
@@ -459,7 +459,7 @@ call.
 
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
-.. _v4l2-event-src-change:
+.. c:type:: v4l2_event_src_change
 
 .. flat-table:: struct v4l2_event_src_change
     :header-rows:  0
@@ -480,7 +480,7 @@ call.
 
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
-.. _v4l2-event-motion-det:
+.. c:type:: v4l2_event_motion_det
 
 .. flat-table:: struct v4l2_event_motion_det
     :header-rows:  0
diff --git a/Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst b/Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst
index 741718baf14b..7cb78a0067ac 100644
--- a/Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst
@@ -36,7 +36,7 @@ Description
 
 To query the capabilities of the DV receiver/transmitter applications
 initialize the ``pad`` field to 0, zero the reserved array of struct
-:ref:`v4l2_dv_timings_cap <v4l2-dv-timings-cap>` and call the
+:c:type:`v4l2_dv_timings_cap` and call the
 ``VIDIOC_DV_TIMINGS_CAP`` ioctl on a video node and the driver will fill
 in the structure.
 
@@ -50,14 +50,14 @@ queried by calling the ``VIDIOC_SUBDEV_DV_TIMINGS_CAP`` ioctl directly
 on a subdevice node. The capabilities are specific to inputs (for DV
 receivers) or outputs (for DV transmitters), applications must specify
 the desired pad number in the struct
-:ref:`v4l2_dv_timings_cap <v4l2-dv-timings-cap>` ``pad`` field and
+:c:type:`v4l2_dv_timings_cap` ``pad`` field and
 zero the ``reserved`` array. Attempts to query capabilities on a pad
 that doesn't support them will return an ``EINVAL`` error code.
 
 
 .. tabularcolumns:: |p{1.2cm}|p{3.0cm}|p{13.3cm}|
 
-.. _v4l2-bt-timings-cap:
+.. c:type:: v4l2_bt_timings_cap
 
 .. flat-table:: struct v4l2_bt_timings_cap
     :header-rows:  0
@@ -144,7 +144,7 @@ that doesn't support them will return an ``EINVAL`` error code.
 
 .. tabularcolumns:: |p{1.0cm}|p{3.5cm}|p{3.5cm}|p{9.5cm}|
 
-.. _v4l2-dv-timings-cap:
+.. c:type:: v4l2_dv_timings_cap
 
 .. flat-table:: struct v4l2_dv_timings_cap
     :header-rows:  0
@@ -190,7 +190,7 @@ that doesn't support them will return an ``EINVAL`` error code.
     -  .. row 5
 
        -
-       -  struct :ref:`v4l2_bt_timings_cap <v4l2-bt-timings-cap>`
+       -  struct :c:type:`v4l2_bt_timings_cap`
 
        -  ``bt``
 
diff --git a/Documentation/media/uapi/v4l/vidioc-encoder-cmd.rst b/Documentation/media/uapi/v4l/vidioc-encoder-cmd.rst
index 802eac3ca9ec..b724ec36a25c 100644
--- a/Documentation/media/uapi/v4l/vidioc-encoder-cmd.rst
+++ b/Documentation/media/uapi/v4l/vidioc-encoder-cmd.rst
@@ -40,7 +40,7 @@ These ioctls control an audio/video (usually MPEG-) encoder.
 executing it.
 
 To send a command applications must initialize all fields of a struct
-:ref:`v4l2_encoder_cmd <v4l2-encoder-cmd>` and call
+:c:type:`v4l2_encoder_cmd` and call
 ``VIDIOC_ENCODER_CMD`` or ``VIDIOC_TRY_ENCODER_CMD`` with a pointer to
 this structure.
 
@@ -67,7 +67,7 @@ introduced in Linux 2.6.21.
 
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
-.. _v4l2-encoder-cmd:
+.. c:type:: v4l2_encoder_cmd
 
 .. flat-table:: struct v4l2_encoder_cmd
     :header-rows:  0
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-dv-timings.rst b/Documentation/media/uapi/v4l/vidioc-enum-dv-timings.rst
index db9613c9b4bd..dfe4d737b0aa 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-dv-timings.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-dv-timings.rst
@@ -43,7 +43,7 @@ this list.
 
 To query the available timings, applications initialize the ``index``
 field, set the ``pad`` field to 0, zero the reserved array of struct
-:ref:`v4l2_enum_dv_timings <v4l2-enum-dv-timings>` and call the
+:c:type:`v4l2_enum_dv_timings` and call the
 ``VIDIOC_ENUM_DV_TIMINGS`` ioctl on a video node with a pointer to this
 structure. Drivers fill the rest of the structure or return an ``EINVAL``
 error code when the index is out of bounds. To enumerate all supported
@@ -60,12 +60,12 @@ by calling the ``VIDIOC_SUBDEV_ENUM_DV_TIMINGS`` ioctl directly on a
 subdevice node. The DV timings are specific to inputs (for DV receivers)
 or outputs (for DV transmitters), applications must specify the desired
 pad number in the struct
-:ref:`v4l2_enum_dv_timings <v4l2-enum-dv-timings>` ``pad`` field.
+:c:type:`v4l2_enum_dv_timings` ``pad`` field.
 Attempts to enumerate timings on a pad that doesn't support them will
 return an ``EINVAL`` error code.
 
 
-.. _v4l2-enum-dv-timings:
+.. c:type:: v4l2_enum_dv_timings
 
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
@@ -104,7 +104,7 @@ return an ``EINVAL`` error code.
 
     -  .. row 4
 
-       -  struct :ref:`v4l2_dv_timings <v4l2-dv-timings>`
+       -  struct :c:type:`v4l2_dv_timings`
 
        -  ``timings``
 
@@ -119,7 +119,7 @@ appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
 
 EINVAL
-    The struct :ref:`v4l2_enum_dv_timings <v4l2-enum-dv-timings>`
+    The struct :c:type:`v4l2_enum_dv_timings`
     ``index`` is out of bounds or the ``pad`` number is invalid.
 
 ENODATA
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst b/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
index 1a4834934085..1df8fccf067f 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
@@ -32,7 +32,7 @@ Description
 ===========
 
 To enumerate image formats applications initialize the ``type`` and
-``index`` field of struct :ref:`v4l2_fmtdesc <v4l2-fmtdesc>` and call
+``index`` field of struct :c:type:`v4l2_fmtdesc` and call
 the :ref:`VIDIOC_ENUM_FMT` ioctl with a pointer to this structure. Drivers
 fill the rest of the structure or return an ``EINVAL`` error code. All
 formats are enumerable by beginning at index zero and incrementing by
@@ -46,7 +46,7 @@ one until ``EINVAL`` is returned.
 
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
-.. _v4l2-fmtdesc:
+.. c:type:: v4l2_fmtdesc
 
 .. flat-table:: struct v4l2_fmtdesc
     :header-rows:  0
@@ -167,5 +167,5 @@ appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
 
 EINVAL
-    The struct :ref:`v4l2_fmtdesc <v4l2-fmtdesc>` ``type`` is not
+    The struct :c:type:`v4l2_fmtdesc` ``type`` is not
     supported or the ``index`` is out of bounds.
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-frameintervals.rst b/Documentation/media/uapi/v4l/vidioc-enum-frameintervals.rst
index f9bb6fb4ca8e..07e94420c4c5 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-frameintervals.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-frameintervals.rst
@@ -26,7 +26,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
-    Pointer to a struct :ref:`v4l2_frmivalenum <v4l2-frmivalenum>`
+    Pointer to a struct :c:type:`v4l2_frmivalenum`
     structure that contains a pixel format and size and receives a frame
     interval.
 
@@ -101,7 +101,7 @@ the application, *OUT* denotes values that the driver fills in. The
 application should zero out all members except for the *IN* fields.
 
 
-.. _v4l2-frmival-stepwise:
+.. c:type:: v4l2_frmival_stepwise
 
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
@@ -113,7 +113,7 @@ application should zero out all members except for the *IN* fields.
 
     -  .. row 1
 
-       -  struct :ref:`v4l2_fract <v4l2-fract>`
+       -  struct :c:type:`v4l2_fract`
 
        -  ``min``
 
@@ -121,7 +121,7 @@ application should zero out all members except for the *IN* fields.
 
     -  .. row 2
 
-       -  struct :ref:`v4l2_fract <v4l2-fract>`
+       -  struct :c:type:`v4l2_fract`
 
        -  ``max``
 
@@ -129,7 +129,7 @@ application should zero out all members except for the *IN* fields.
 
     -  .. row 3
 
-       -  struct :ref:`v4l2_fract <v4l2-fract>`
+       -  struct :c:type:`v4l2_fract`
 
        -  ``step``
 
@@ -137,7 +137,7 @@ application should zero out all members except for the *IN* fields.
 
 
 
-.. _v4l2-frmivalenum:
+.. c:type:: v4l2_frmivalenum
 
 .. flat-table:: struct v4l2_frmivalenum
     :header-rows:  0
@@ -200,7 +200,7 @@ application should zero out all members except for the *IN* fields.
     -  .. row 7
 
        -
-       -  struct :ref:`v4l2_fract <v4l2-fract>`
+       -  struct :c:type:`v4l2_fract`
 
        -  ``discrete``
 
@@ -209,7 +209,7 @@ application should zero out all members except for the *IN* fields.
     -  .. row 8
 
        -
-       -  struct :ref:`v4l2_frmival_stepwise <v4l2-frmival-stepwise>`
+       -  struct :c:type:`v4l2_frmival_stepwise`
 
        -  ``stepwise``
 
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-framesizes.rst b/Documentation/media/uapi/v4l/vidioc-enum-framesizes.rst
index 4fb19b75abf1..a4ddfe9f8956 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-framesizes.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-framesizes.rst
@@ -26,7 +26,7 @@ Arguments
     File descriptor returned by :ref:`open() <func-open>`.
 
 ``argp``
-    Pointer to a struct :ref:`v4l2_frmsizeenum <v4l2-frmsizeenum>`
+    Pointer to a struct :c:type:`v4l2_frmsizeenum`
     that contains an index and pixel format and receives a frame width
     and height.
 
@@ -90,7 +90,7 @@ the application, *OUT* denotes values that the driver fills in. The
 application should zero out all members except for the *IN* fields.
 
 
-.. _v4l2-frmsize-discrete:
+.. c:type:: v4l2_frmsize_discrete
 
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
@@ -118,7 +118,7 @@ application should zero out all members except for the *IN* fields.
 
 
 
-.. _v4l2-frmsize-stepwise:
+.. c:type:: v4l2_frmsize_stepwise
 
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
@@ -178,7 +178,7 @@ application should zero out all members except for the *IN* fields.
 
 
 
-.. _v4l2-frmsizeenum:
+.. c:type:: v4l2_frmsizeenum
 
 .. flat-table:: struct v4l2_frmsizeenum
     :header-rows:  0
@@ -223,7 +223,7 @@ application should zero out all members except for the *IN* fields.
     -  .. row 5
 
        -
-       -  struct :ref:`v4l2_frmsize_discrete <v4l2-frmsize-discrete>`
+       -  struct :c:type:`v4l2_frmsize_discrete`
 
        -  ``discrete``
 
@@ -232,7 +232,7 @@ application should zero out all members except for the *IN* fields.
     -  .. row 6
 
        -
-       -  struct :ref:`v4l2_frmsize_stepwise <v4l2-frmsize-stepwise>`
+       -  struct :c:type:`v4l2_frmsize_stepwise`
 
        -  ``stepwise``
 
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst b/Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst
index 60ae938d5ef8..c38478227031 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst
@@ -34,7 +34,7 @@ Description
 Enumerates the frequency bands that a tuner or modulator supports. To do
 this applications initialize the ``tuner``, ``type`` and ``index``
 fields, and zero out the ``reserved`` array of a struct
-:ref:`v4l2_frequency_band <v4l2-frequency-band>` and call the
+:c:type:`v4l2_frequency_band` and call the
 :ref:`VIDIOC_ENUM_FREQ_BANDS` ioctl with a pointer to this structure.
 
 This ioctl is supported if the ``V4L2_TUNER_CAP_FREQ_BANDS`` capability
@@ -43,7 +43,7 @@ of the corresponding tuner/modulator is set.
 
 .. tabularcolumns:: |p{2.9cm}|p{2.9cm}|p{5.8cm}|p{2.9cm}|p{3.0cm}|
 
-.. _v4l2-frequency-band:
+.. c:type:: v4l2_frequency_band
 
 .. flat-table:: struct v4l2_frequency_band
     :header-rows:  0
@@ -58,10 +58,10 @@ of the corresponding tuner/modulator is set.
        -  ``tuner``
 
        -  The tuner or modulator index number. This is the same value as in
-	  the struct :ref:`v4l2_input <v4l2-input>` ``tuner`` field and
-	  the struct :ref:`v4l2_tuner <v4l2-tuner>` ``index`` field, or
-	  the struct :ref:`v4l2_output <v4l2-output>` ``modulator`` field
-	  and the struct :ref:`v4l2_modulator <v4l2-modulator>` ``index``
+	  the struct :c:type:`v4l2_input` ``tuner`` field and
+	  the struct :c:type:`v4l2_tuner` ``index`` field, or
+	  the struct :c:type:`v4l2_output` ``modulator`` field
+	  and the struct :c:type:`v4l2_modulator` ``index``
 	  field.
 
     -  .. row 2
@@ -71,7 +71,7 @@ of the corresponding tuner/modulator is set.
        -  ``type``
 
        -  The tuner type. This is the same value as in the struct
-	  :ref:`v4l2_tuner <v4l2-tuner>` ``type`` field. The type must be
+	  :c:type:`v4l2_tuner` ``type`` field. The type must be
 	  set to ``V4L2_TUNER_RADIO`` for ``/dev/radioX`` device nodes, and
 	  to ``V4L2_TUNER_ANALOG_TV`` for all others. Set this field to
 	  ``V4L2_TUNER_RADIO`` for modulators (currently only radio
diff --git a/Documentation/media/uapi/v4l/vidioc-enumaudio.rst b/Documentation/media/uapi/v4l/vidioc-enumaudio.rst
index c9d9eb60551e..74bc3ed0bdd8 100644
--- a/Documentation/media/uapi/v4l/vidioc-enumaudio.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enumaudio.rst
@@ -33,14 +33,14 @@ Description
 
 To query the attributes of an audio input applications initialize the
 ``index`` field and zero out the ``reserved`` array of a struct
-:ref:`v4l2_audio <v4l2-audio>` and call the :ref:`VIDIOC_ENUMAUDIO`
+:c:type:`v4l2_audio` and call the :ref:`VIDIOC_ENUMAUDIO`
 ioctl with a pointer to this structure. Drivers fill the rest of the
 structure or return an ``EINVAL`` error code when the index is out of
 bounds. To enumerate all audio inputs applications shall begin at index
 zero, incrementing by one until the driver returns ``EINVAL``.
 
 See :ref:`VIDIOC_G_AUDIO <VIDIOC_G_AUDIO>` for a description of struct
-:ref:`v4l2_audio <v4l2-audio>`.
+:c:type:`v4l2_audio`.
 
 
 Return Value
diff --git a/Documentation/media/uapi/v4l/vidioc-enumaudioout.rst b/Documentation/media/uapi/v4l/vidioc-enumaudioout.rst
index a7a27327fe88..4470a1ece5cf 100644
--- a/Documentation/media/uapi/v4l/vidioc-enumaudioout.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enumaudioout.rst
@@ -33,7 +33,7 @@ Description
 
 To query the attributes of an audio output applications initialize the
 ``index`` field and zero out the ``reserved`` array of a struct
-:ref:`v4l2_audioout <v4l2-audioout>` and call the ``VIDIOC_G_AUDOUT``
+:c:type:`v4l2_audioout` and call the ``VIDIOC_G_AUDOUT``
 ioctl with a pointer to this structure. Drivers fill the rest of the
 structure or return an ``EINVAL`` error code when the index is out of
 bounds. To enumerate all audio outputs applications shall begin at index
@@ -45,7 +45,7 @@ zero, incrementing by one until the driver returns ``EINVAL``.
     to a sound card are not audio outputs in this sense.
 
 See :ref:`VIDIOC_G_AUDIOout <VIDIOC_G_AUDOUT>` for a description of struct
-:ref:`v4l2_audioout <v4l2-audioout>`.
+:c:type:`v4l2_audioout`.
 
 
 Return Value
diff --git a/Documentation/media/uapi/v4l/vidioc-enuminput.rst b/Documentation/media/uapi/v4l/vidioc-enuminput.rst
index 8f6c603819d8..be03e04e3dac 100644
--- a/Documentation/media/uapi/v4l/vidioc-enuminput.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enuminput.rst
@@ -32,7 +32,7 @@ Description
 ===========
 
 To query the attributes of a video input applications initialize the
-``index`` field of struct :ref:`v4l2_input <v4l2-input>` and call the
+``index`` field of struct :c:type:`v4l2_input` and call the
 :ref:`VIDIOC_ENUMINPUT` ioctl with a pointer to this structure. Drivers
 fill the rest of the structure or return an ``EINVAL`` error code when the
 index is out of bounds. To enumerate all inputs applications shall begin
@@ -41,7 +41,7 @@ at index zero, incrementing by one until the driver returns ``EINVAL``.
 
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
-.. _v4l2-input:
+.. c:type:: v4l2_input
 
 .. flat-table:: struct v4l2_input
     :header-rows:  0
@@ -104,7 +104,7 @@ at index zero, incrementing by one until the driver returns ``EINVAL``.
        -  Capture devices can have zero or more tuners (RF demodulators).
 	  When the ``type`` is set to ``V4L2_INPUT_TYPE_TUNER`` this is an
 	  RF connector and this field identifies the tuner. It corresponds
-	  to struct :ref:`v4l2_tuner <v4l2-tuner>` field ``index``. For
+	  to struct :c:type:`v4l2_tuner` field ``index``. For
 	  details on tuners see :ref:`tuner`.
 
     -  .. row 6
@@ -377,5 +377,5 @@ appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
 
 EINVAL
-    The struct :ref:`v4l2_input <v4l2-input>` ``index`` is out of
+    The struct :c:type:`v4l2_input` ``index`` is out of
     bounds.
diff --git a/Documentation/media/uapi/v4l/vidioc-enumoutput.rst b/Documentation/media/uapi/v4l/vidioc-enumoutput.rst
index d660c37d3516..763066ab99b6 100644
--- a/Documentation/media/uapi/v4l/vidioc-enumoutput.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enumoutput.rst
@@ -32,7 +32,7 @@ Description
 ===========
 
 To query the attributes of a video outputs applications initialize the
-``index`` field of struct :ref:`v4l2_output <v4l2-output>` and call
+``index`` field of struct :c:type:`v4l2_output` and call
 the :ref:`VIDIOC_ENUMOUTPUT` ioctl with a pointer to this structure.
 Drivers fill the rest of the structure or return an ``EINVAL`` error code
 when the index is out of bounds. To enumerate all outputs applications
@@ -42,7 +42,7 @@ EINVAL.
 
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
-.. _v4l2-output:
+.. c:type:: v4l2_output
 
 .. flat-table:: struct v4l2_output
     :header-rows:  0
@@ -105,7 +105,7 @@ EINVAL.
        -  Output devices can have zero or more RF modulators. When the
 	  ``type`` is ``V4L2_OUTPUT_TYPE_MODULATOR`` this is an RF connector
 	  and this field identifies the modulator. It corresponds to struct
-	  :ref:`v4l2_modulator <v4l2-modulator>` field ``index``. For
+	  :c:type:`v4l2_modulator` field ``index``. For
 	  details on modulators see :ref:`tuner`.
 
     -  .. row 6
@@ -222,5 +222,5 @@ appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
 
 EINVAL
-    The struct :ref:`v4l2_output <v4l2-output>` ``index`` is out of
+    The struct :c:type:`v4l2_output` ``index`` is out of
     bounds.
diff --git a/Documentation/media/uapi/v4l/vidioc-enumstd.rst b/Documentation/media/uapi/v4l/vidioc-enumstd.rst
index 5bd85932d33b..eaac7a2e14c4 100644
--- a/Documentation/media/uapi/v4l/vidioc-enumstd.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enumstd.rst
@@ -33,7 +33,7 @@ Description
 
 To query the attributes of a video standard, especially a custom (driver
 defined) one, applications initialize the ``index`` field of struct
-:ref:`v4l2_standard <v4l2-standard>` and call the :ref:`VIDIOC_ENUMSTD`
+:c:type:`v4l2_standard` and call the :ref:`VIDIOC_ENUMSTD`
 ioctl with a pointer to this structure. Drivers fill the rest of the
 structure or return an ``EINVAL`` error code when the index is out of
 bounds. To enumerate all standards applications shall begin at index
@@ -42,7 +42,7 @@ enumerate a different set of standards after switching the video input
 or output. [#f1]_
 
 
-.. _v4l2-standard:
+.. c:type:: v4l2_standard
 
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
@@ -71,7 +71,7 @@ or output. [#f1]_
 	  set as custom standards. Multiple bits can be set if the hardware
 	  does not distinguish between these standards, however separate
 	  indices do not indicate the opposite. The ``id`` must be unique.
-	  No other enumerated :ref:`struct v4l2_standard <v4l2-standard>` structure,
+	  No other enumerated :c:type:`struct v4l2_standard <v4l2_standard>` structure,
 	  for this input or output anyway, can contain the same set of bits.
 
     -  .. row 3
@@ -86,7 +86,7 @@ or output. [#f1]_
 
     -  .. row 4
 
-       -  struct :ref:`v4l2_fract <v4l2-fract>`
+       -  struct :c:type:`v4l2_fract`
 
        -  ``frameperiod``
 
@@ -112,7 +112,7 @@ or output. [#f1]_
 
 
 
-.. _v4l2-fract:
+.. c:type:: v4l2_fract
 
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
@@ -411,7 +411,7 @@ appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
 
 EINVAL
-    The struct :ref:`v4l2_standard <v4l2-standard>` ``index`` is out
+    The struct :c:type:`v4l2_standard` ``index`` is out
     of bounds.
 
 ENODATA
diff --git a/Documentation/media/uapi/v4l/vidioc-expbuf.rst b/Documentation/media/uapi/v4l/vidioc-expbuf.rst
index f7b8d643fd28..650757ad8aed 100644
--- a/Documentation/media/uapi/v4l/vidioc-expbuf.rst
+++ b/Documentation/media/uapi/v4l/vidioc-expbuf.rst
@@ -38,13 +38,13 @@ buffers have been allocated with the
 :ref:`VIDIOC_REQBUFS` ioctl.
 
 To export a buffer, applications fill struct
-:ref:`v4l2_exportbuffer <v4l2-exportbuffer>`. The ``type`` field is
+:c:type:`v4l2_exportbuffer`. The ``type`` field is
 set to the same buffer type as was previously used with struct
-:ref:`v4l2_requestbuffers <v4l2-requestbuffers>` ``type``.
+:c:type:`v4l2_requestbuffers` ``type``.
 Applications must also set the ``index`` field. Valid index numbers
 range from zero to the number of buffers allocated with
 :ref:`VIDIOC_REQBUFS` (struct
-:ref:`v4l2_requestbuffers <v4l2-requestbuffers>` ``count``) minus
+:c:type:`v4l2_requestbuffers` ``count``) minus
 one. For the multi-planar API, applications set the ``plane`` field to
 the index of the plane to be exported. Valid planes range from zero to
 the maximal number of valid planes for the currently active format. For
@@ -114,7 +114,7 @@ Examples
     }
 
 
-.. _v4l2-exportbuffer:
+.. c:type:: v4l2_exportbuffer
 
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
@@ -131,8 +131,8 @@ Examples
        -  ``type``
 
        -  Type of the buffer, same as struct
-	  :ref:`v4l2_format <v4l2-format>` ``type`` or struct
-	  :ref:`v4l2_requestbuffers <v4l2-requestbuffers>` ``type``, set
+	  :c:type:`v4l2_format` ``type`` or struct
+	  :c:type:`v4l2_requestbuffers` ``type``, set
 	  by the application. See :ref:`v4l2-buf-type`
 
     -  .. row 2
diff --git a/Documentation/media/uapi/v4l/vidioc-g-audio.rst b/Documentation/media/uapi/v4l/vidioc-g-audio.rst
index 224a09c2c53d..ebf2514464fc 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-audio.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-audio.rst
@@ -35,7 +35,7 @@ Description
 ===========
 
 To query the current audio input applications zero out the ``reserved``
-array of a struct :ref:`v4l2_audio <v4l2-audio>` and call the
+array of a struct :c:type:`v4l2_audio` and call the
 :ref:`VIDIOC_G_AUDIO <VIDIOC_G_AUDIO>` ioctl with a pointer to this structure. Drivers fill
 the rest of the structure or return an ``EINVAL`` error code when the device
 has no audio inputs, or none which combine with the current video input.
@@ -43,7 +43,7 @@ has no audio inputs, or none which combine with the current video input.
 Audio inputs have one writable property, the audio mode. To select the
 current audio input *and* change the audio mode, applications initialize
 the ``index`` and ``mode`` fields, and the ``reserved`` array of a
-:ref:`struct v4l2_audio <v4l2-audio>` structure and call the :ref:`VIDIOC_S_AUDIO <VIDIOC_G_AUDIO>`
+:c:type:`struct v4l2_audio <v4l2_audio>` structure and call the :ref:`VIDIOC_S_AUDIO <VIDIOC_G_AUDIO>`
 ioctl. Drivers may switch to a different audio mode if the request
 cannot be satisfied. However, this is a write-only ioctl, it does not
 return the actual new audio mode.
@@ -51,7 +51,7 @@ return the actual new audio mode.
 
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
-.. _v4l2-audio:
+.. c:type:: v4l2_audio
 
 .. flat-table:: struct v4l2_audio
     :header-rows:  0
diff --git a/Documentation/media/uapi/v4l/vidioc-g-audioout.rst b/Documentation/media/uapi/v4l/vidioc-g-audioout.rst
index da8db3b42262..b21794300efd 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-audioout.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-audioout.rst
@@ -35,7 +35,7 @@ Description
 ===========
 
 To query the current audio output applications zero out the ``reserved``
-array of a struct :ref:`v4l2_audioout <v4l2-audioout>` and call the
+array of a struct :c:type:`v4l2_audioout` and call the
 ``VIDIOC_G_AUDOUT`` ioctl with a pointer to this structure. Drivers fill
 the rest of the structure or return an ``EINVAL`` error code when the device
 has no audio inputs, or none which combine with the current video
@@ -44,7 +44,7 @@ output.
 Audio outputs have no writable properties. Nevertheless, to select the
 current audio output applications can initialize the ``index`` field and
 ``reserved`` array (which in the future may contain writable properties)
-of a :ref:`struct v4l2_audioout <v4l2-audioout>` structure and call the
+of a :c:type:`struct v4l2_audioout <v4l2_audioout>` structure and call the
 ``VIDIOC_S_AUDOUT`` ioctl. Drivers switch to the requested output or
 return the ``EINVAL`` error code when the index is out of bounds. This is a
 write-only ioctl, it does not return the current audio output attributes
@@ -56,7 +56,7 @@ as ``VIDIOC_G_AUDOUT`` does.
    to a sound card are not audio outputs in this sense.
 
 
-.. _v4l2-audioout:
+.. c:type:: v4l2_audioout
 
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-crop.rst b/Documentation/media/uapi/v4l/vidioc-g-crop.rst
index 1689b0c523d7..b99032e59ebe 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-crop.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-crop.rst
@@ -35,13 +35,13 @@ Description
 ===========
 
 To query the cropping rectangle size and position applications set the
-``type`` field of a :ref:`struct v4l2_crop <v4l2-crop>` structure to the
+``type`` field of a :c:type:`struct v4l2_crop <v4l2_crop>` structure to the
 respective buffer (stream) type and call the :ref:`VIDIOC_G_CROP <VIDIOC_G_CROP>` ioctl
 with a pointer to this structure. The driver fills the rest of the
 structure or returns the ``EINVAL`` error code if cropping is not supported.
 
 To change the cropping rectangle applications initialize the ``type``
-and struct :ref:`v4l2_rect <v4l2-rect>` substructure named ``c`` of a
+and struct :c:type:`v4l2_rect` substructure named ``c`` of a
 v4l2_crop structure and call the :ref:`VIDIOC_S_CROP <VIDIOC_G_CROP>` ioctl with a pointer
 to this structure.
 
@@ -75,7 +75,7 @@ When cropping is not supported then no parameters are changed and
 :ref:`VIDIOC_S_CROP <VIDIOC_G_CROP>` returns the ``EINVAL`` error code.
 
 
-.. _v4l2-crop:
+.. c:type:: v4l2_crop
 
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
@@ -98,12 +98,12 @@ When cropping is not supported then no parameters are changed and
 
     -  .. row 2
 
-       -  struct :ref:`v4l2_rect <v4l2-rect>`
+       -  struct :c:type:`v4l2_rect`
 
        -  ``c``
 
        -  Cropping rectangle. The same co-ordinate system as for struct
-	  :ref:`v4l2_cropcap <v4l2-cropcap>` ``bounds`` is used.
+	  :c:type:`v4l2_cropcap` ``bounds`` is used.
 
 
 Return Value
diff --git a/Documentation/media/uapi/v4l/vidioc-g-ctrl.rst b/Documentation/media/uapi/v4l/vidioc-g-ctrl.rst
index 6ced76016246..53a6ebe6f744 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-ctrl.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-ctrl.rst
@@ -35,10 +35,10 @@ Description
 ===========
 
 To get the current value of a control applications initialize the ``id``
-field of a struct :ref:`struct v4l2_control <v4l2-control>` and call the
+field of a struct :c:type:`struct v4l2_control <v4l2_control>` and call the
 :ref:`VIDIOC_G_CTRL <VIDIOC_G_CTRL>` ioctl with a pointer to this structure. To change the
 value of a control applications initialize the ``id`` and ``value``
-fields of a struct :ref:`struct v4l2_control <v4l2-control>` and call the
+fields of a struct :c:type:`struct v4l2_control <v4l2_control>` and call the
 :ref:`VIDIOC_S_CTRL <VIDIOC_G_CTRL>` ioctl.
 
 When the ``id`` is invalid drivers return an ``EINVAL`` error code. When the
@@ -55,7 +55,7 @@ These ioctls work only with user controls. For other control classes the
 :ref:`VIDIOC_TRY_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` must be used.
 
 
-.. _v4l2-control:
+.. c:type:: v4l2_control
 
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
@@ -90,13 +90,13 @@ appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
 
 EINVAL
-    The struct :ref:`v4l2_control <v4l2-control>` ``id`` is invalid
+    The struct :c:type:`v4l2_control` ``id`` is invalid
     or the ``value`` is inappropriate for the given control (i.e. if a
     menu item is selected that is not supported by the driver according
     to :ref:`VIDIOC_QUERYMENU <VIDIOC_QUERYCTRL>`).
 
 ERANGE
-    The struct :ref:`v4l2_control <v4l2-control>` ``value`` is out of
+    The struct :c:type:`v4l2_control` ``value`` is out of
     bounds.
 
 EBUSY
diff --git a/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst b/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
index f143a6b3d927..379f2be0bc92 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
@@ -44,8 +44,8 @@ To set DV timings for the input or output, applications use the
 :ref:`VIDIOC_S_DV_TIMINGS <VIDIOC_G_DV_TIMINGS>` ioctl and to get the current timings,
 applications use the :ref:`VIDIOC_G_DV_TIMINGS <VIDIOC_G_DV_TIMINGS>` ioctl. The detailed timing
 information is filled in using the structure struct
-:ref:`v4l2_dv_timings <v4l2-dv-timings>`. These ioctls take a
-pointer to the struct :ref:`v4l2_dv_timings <v4l2-dv-timings>`
+:c:type:`v4l2_dv_timings`. These ioctls take a
+pointer to the struct :c:type:`v4l2_dv_timings`
 structure as argument. If the ioctl is not supported or the timing
 values are not correct, the driver returns ``EINVAL`` error code.
 
@@ -76,7 +76,7 @@ EBUSY
 
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
-.. _v4l2-bt-timings:
+.. c:type:: v4l2_bt_timings
 
 .. flat-table:: struct v4l2_bt_timings
     :header-rows:  0
@@ -239,7 +239,7 @@ EBUSY
 
 .. tabularcolumns:: |p{3.5cm}|p{3.5cm}|p{7.0cm}|p{3.5cm}|
 
-.. _v4l2-dv-timings:
+.. c:type:: v4l2_dv_timings
 
 .. flat-table:: struct v4l2_dv_timings
     :header-rows:  0
@@ -266,7 +266,7 @@ EBUSY
     -  .. row 3
 
        -
-       -  struct :ref:`v4l2_bt_timings <v4l2-bt-timings>`
+       -  struct :c:type:`v4l2_bt_timings`
 
        -  ``bt``
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-enc-index.rst b/Documentation/media/uapi/v4l/vidioc-g-enc-index.rst
index 3decb810c8bb..6b5727439db2 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-enc-index.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-enc-index.rst
@@ -37,7 +37,7 @@ driver, which is useful for random access into the stream without
 decoding it.
 
 To read the data applications must call :ref:`VIDIOC_G_ENC_INDEX <VIDIOC_G_ENC_INDEX>` with a
-pointer to a struct :ref:`v4l2_enc_idx <v4l2-enc-idx>`. On success
+pointer to a struct :c:type:`v4l2_enc_idx`. On success
 the driver fills the ``entry`` array, stores the number of elements
 written in the ``entries`` field, and initializes the ``entries_cap``
 field.
@@ -57,7 +57,7 @@ video elementary streams.
 
 .. tabularcolumns:: |p{3.5cm}|p{5.6cm}|p{8.4cm}|
 
-.. _v4l2-enc-idx:
+.. c:type:: v4l2_enc_idx
 
 .. flat-table:: struct v4l2_enc_idx
     :header-rows:  0
@@ -93,7 +93,7 @@ video elementary streams.
 
     -  .. row 4
 
-       -  struct :ref:`v4l2_enc_idx_entry <v4l2-enc-idx-entry>`
+       -  struct :c:type:`v4l2_enc_idx_entry`
 
        -  ``entry``\ [``V4L2_ENC_IDX_ENTRIES``]
 
@@ -105,7 +105,7 @@ video elementary streams.
 
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
-.. _v4l2-enc-idx-entry:
+.. c:type:: v4l2_enc_idx_entry
 
 .. flat-table:: struct v4l2_enc_idx_entry
     :header-rows:  0
diff --git a/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst b/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
index ee72c69f902a..01561ddfe73b 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
@@ -46,13 +46,13 @@ to the same control class.
 
 Applications must always fill in the ``count``, ``which``, ``controls``
 and ``reserved`` fields of struct
-:ref:`v4l2_ext_controls <v4l2-ext-controls>`, and initialize the
-struct :ref:`v4l2_ext_control <v4l2-ext-control>` array pointed to
+:c:type:`v4l2_ext_controls`, and initialize the
+struct :c:type:`v4l2_ext_control` array pointed to
 by the ``controls`` fields.
 
 To get the current value of a set of controls applications initialize
 the ``id``, ``size`` and ``reserved2`` fields of each struct
-:ref:`v4l2_ext_control <v4l2-ext-control>` and call the
+:c:type:`v4l2_ext_control` and call the
 :ref:`VIDIOC_G_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` ioctl. String controls controls must also set the
 ``string`` field. Controls of compound types
 (``V4L2_CTRL_FLAG_HAS_PAYLOAD`` is set) must set the ``ptr`` field.
@@ -74,14 +74,14 @@ by calling :ref:`VIDIOC_QUERY_EXT_CTRL <VIDIOC_QUERYCTRL>`.
 
 To change the value of a set of controls applications initialize the
 ``id``, ``size``, ``reserved2`` and ``value/value64/string/ptr`` fields
-of each struct :ref:`v4l2_ext_control <v4l2-ext-control>` and call
+of each struct :c:type:`v4l2_ext_control` and call
 the :ref:`VIDIOC_S_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` ioctl. The controls will only be set if *all*
 control values are valid.
 
 To check if a set of controls have correct values applications
 initialize the ``id``, ``size``, ``reserved2`` and
 ``value/value64/string/ptr`` fields of each struct
-:ref:`v4l2_ext_control <v4l2-ext-control>` and call the
+:c:type:`v4l2_ext_control` and call the
 :ref:`VIDIOC_TRY_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` ioctl. It is up to the driver whether wrong
 values are automatically adjusted to a valid value or if an error is
 returned.
@@ -90,7 +90,7 @@ When the ``id`` or ``which`` is invalid drivers return an ``EINVAL`` error
 code. When the value is out of bounds drivers can choose to take the
 closest valid value or return an ``ERANGE`` error code, whatever seems more
 appropriate. In the first case the new value is set in struct
-:ref:`v4l2_ext_control <v4l2-ext-control>`. If the new control value
+:c:type:`v4l2_ext_control`. If the new control value
 is inappropriate (e.g. the given menu index is not supported by the menu
 control), then this will also result in an ``EINVAL`` error code error.
 
@@ -102,7 +102,7 @@ still cause this situation.
 
 .. tabularcolumns:: |p{1.2cm}|p{3.0cm}|p{1.5cm}|p{11.8cm}|
 
-.. _v4l2-ext-control:
+.. c:type:: v4l2_ext_control
 
 .. cssclass: longtable
 
@@ -236,7 +236,7 @@ still cause this situation.
 
 .. tabularcolumns:: |p{4.0cm}|p{2.0cm}|p{2.0cm}|p{8.5cm}|
 
-.. _v4l2-ext-controls:
+.. c:type:: v4l2_ext_controls
 
 .. cssclass:: longtable
 
@@ -362,7 +362,7 @@ still cause this situation.
 
     -  .. row 7
 
-       -  struct :ref:`v4l2_ext_control <v4l2-ext-control>` *
+       -  struct :c:type:`v4l2_ext_control` *
 
        -  ``controls``
 
@@ -483,17 +483,17 @@ appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
 
 EINVAL
-    The struct :ref:`v4l2_ext_control <v4l2-ext-control>` ``id`` is
-    invalid, the struct :ref:`v4l2_ext_controls <v4l2-ext-controls>`
+    The struct :c:type:`v4l2_ext_control` ``id`` is
+    invalid, the struct :c:type:`v4l2_ext_controls`
     ``which`` is invalid, or the struct
-    :ref:`v4l2_ext_control <v4l2-ext-control>` ``value`` was
+    :c:type:`v4l2_ext_control` ``value`` was
     inappropriate (e.g. the given menu index is not supported by the
     driver). This error code is also returned by the
     :ref:`VIDIOC_S_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` and :ref:`VIDIOC_TRY_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` ioctls if two or
     more control values are in conflict.
 
 ERANGE
-    The struct :ref:`v4l2_ext_control <v4l2-ext-control>` ``value``
+    The struct :c:type:`v4l2_ext_control` ``value``
     is out of bounds.
 
 EBUSY
diff --git a/Documentation/media/uapi/v4l/vidioc-g-fbuf.rst b/Documentation/media/uapi/v4l/vidioc-g-fbuf.rst
index 00f783692752..7ade2f7d62be 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-fbuf.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-fbuf.rst
@@ -49,13 +49,13 @@ VGA signal or graphics into a video signal. *Video Output Overlays* are
 always non-destructive.
 
 To get the current parameters applications call the :ref:`VIDIOC_G_FBUF <VIDIOC_G_FBUF>`
-ioctl with a pointer to a :ref:`struct v4l2_framebuffer <v4l2-framebuffer>`
+ioctl with a pointer to a :c:type:`struct v4l2_framebuffer <v4l2_framebuffer>`
 structure. The driver fills all fields of the structure or returns an
 EINVAL error code when overlays are not supported.
 
 To set the parameters for a *Video Output Overlay*, applications must
 initialize the ``flags`` field of a struct
-:ref:`struct v4l2_framebuffer <v4l2-framebuffer>`. Since the framebuffer is
+:c:type:`struct v4l2_framebuffer <v4l2_framebuffer>`. Since the framebuffer is
 implemented on the TV card all other parameters are determined by the
 driver. When an application calls :ref:`VIDIOC_S_FBUF <VIDIOC_G_FBUF>` with a pointer to
 this structure, the driver prepares for the overlay and returns the
@@ -77,7 +77,7 @@ destructive video overlay.
 
 .. tabularcolumns:: |p{3.5cm}|p{3.5cm}|p{3.5cm}|p{7.0cm}|
 
-.. _v4l2-framebuffer:
+.. c:type:: v4l2_framebuffer
 
 .. cssclass:: longtable
 
@@ -172,7 +172,7 @@ destructive video overlay.
        -
        -
        -  For *non-destructive Video Overlays* this field only defines a
-	  format for the struct :ref:`v4l2_window <v4l2-window>`
+	  format for the struct :c:type:`v4l2_window`
 	  ``chromakey`` field.
 
     -  .. row 10
@@ -207,7 +207,7 @@ destructive video overlay.
        -  Drivers and applications shall ignore this field. If applicable,
 	  the field order is selected with the
 	  :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl, using the ``field``
-	  field of struct :ref:`v4l2_window <v4l2-window>`.
+	  field of struct :c:type:`v4l2_window`.
 
     -  .. row 13
 
@@ -422,7 +422,7 @@ destructive video overlay.
        -  0x0004
 
        -  Use chroma-keying. The chroma-key color is determined by the
-	  ``chromakey`` field of struct :ref:`v4l2_window <v4l2-window>`
+	  ``chromakey`` field of struct :c:type:`v4l2_window`
 	  and negotiated with the :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`
 	  ioctl, see :ref:`overlay` and :ref:`osd`.
 
@@ -454,7 +454,7 @@ destructive video overlay.
 	  images. The blend function is: output = (framebuffer pixel * alpha
 	  + video pixel * (255 - alpha)) / 255. The alpha value is
 	  determined by the ``global_alpha`` field of struct
-	  :ref:`v4l2_window <v4l2-window>` and negotiated with the
+	  :c:type:`v4l2_window` and negotiated with the
 	  :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl, see :ref:`overlay`
 	  and :ref:`osd`.
 
@@ -478,11 +478,11 @@ destructive video overlay.
 
        -  Use source chroma-keying. The source chroma-key color is
 	  determined by the ``chromakey`` field of struct
-	  :ref:`v4l2_window <v4l2-window>` and negotiated with the
+	  :c:type:`v4l2_window` and negotiated with the
 	  :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl, see :ref:`overlay`
 	  and :ref:`osd`. Both chroma-keying are mutual exclusive to each
 	  other, so same ``chromakey`` field of struct
-	  :ref:`v4l2_window <v4l2-window>` is being used.
+	  :c:type:`v4l2_window` is being used.
 
 
 Return Value
diff --git a/Documentation/media/uapi/v4l/vidioc-g-fmt.rst b/Documentation/media/uapi/v4l/vidioc-g-fmt.rst
index ebeb7e9a48ea..dd6c062d267c 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-fmt.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-fmt.rst
@@ -40,15 +40,15 @@ These ioctls are used to negotiate the format of data (typically image
 format) exchanged between driver and application.
 
 To query the current parameters applications set the ``type`` field of a
-struct :ref:`struct v4l2_format <v4l2-format>` to the respective buffer (stream)
+struct :c:type:`struct v4l2_format <v4l2_format>` to the respective buffer (stream)
 type. For example video capture devices use
 ``V4L2_BUF_TYPE_VIDEO_CAPTURE`` or
 ``V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE``. When the application calls the
 :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` ioctl with a pointer to this structure the driver fills
 the respective member of the ``fmt`` union. In case of video capture
 devices that is either the struct
-:ref:`v4l2_pix_format <v4l2-pix-format>` ``pix`` or the struct
-:ref:`v4l2_pix_format_mplane <v4l2-pix-format-mplane>` ``pix_mp``
+:c:type:`v4l2_pix_format` ``pix`` or the struct
+:c:type:`v4l2_pix_format_mplane` ``pix_mp``
 member. When the requested buffer type is not supported drivers return
 an ``EINVAL`` error code.
 
@@ -58,7 +58,7 @@ For details see the documentation of the various devices types in
 :ref:`devices`. Good practice is to query the current parameters
 first, and to modify only those parameters not suitable for the
 application. When the application calls the :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl with
-a pointer to a :ref:`struct v4l2_format <v4l2-format>` structure the driver
+a pointer to a :c:type:`struct v4l2_format <v4l2_format>` structure the driver
 checks and adjusts the parameters against hardware abilities. Drivers
 should not return an error code unless the ``type`` field is invalid,
 this is a mechanism to fathom device capabilities and to approach
@@ -85,7 +85,7 @@ The format as returned by :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` must be identical
 :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` returns for the same input or output.
 
 
-.. _v4l2-format:
+.. c:type:: v4l2_format
 
 .. tabularcolumns::  |p{1.2cm}|p{4.3cm}|p{3.0cm}|p{9.0cm}|
 
@@ -112,7 +112,7 @@ The format as returned by :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` must be identical
     -  .. row 3
 
        -
-       -  struct :ref:`v4l2_pix_format <v4l2-pix-format>`
+       -  struct :c:type:`v4l2_pix_format`
 
        -  ``pix``
 
@@ -122,7 +122,7 @@ The format as returned by :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` must be identical
     -  .. row 4
 
        -
-       -  struct :ref:`v4l2_pix_format_mplane <v4l2-pix-format-mplane>`
+       -  struct :c:type:`v4l2_pix_format_mplane`
 
        -  ``pix_mp``
 
@@ -133,7 +133,7 @@ The format as returned by :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` must be identical
     -  .. row 5
 
        -
-       -  struct :ref:`v4l2_window <v4l2-window>`
+       -  struct :c:type:`v4l2_window`
 
        -  ``win``
 
@@ -143,7 +143,7 @@ The format as returned by :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` must be identical
     -  .. row 6
 
        -
-       -  struct :ref:`v4l2_vbi_format <v4l2-vbi-format>`
+       -  struct :c:type:`v4l2_vbi_format`
 
        -  ``vbi``
 
@@ -154,7 +154,7 @@ The format as returned by :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` must be identical
     -  .. row 7
 
        -
-       -  struct :ref:`v4l2_sliced_vbi_format <v4l2-sliced-vbi-format>`
+       -  struct :c:type:`v4l2_sliced_vbi_format`
 
        -  ``sliced``
 
@@ -164,7 +164,7 @@ The format as returned by :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` must be identical
     -  .. row 8
 
        -
-       -  struct :ref:`v4l2_sdr_format <v4l2-sdr-format>`
+       -  struct :c:type:`v4l2_sdr_format`
 
        -  ``sdr``
 
@@ -189,5 +189,5 @@ appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
 
 EINVAL
-    The struct :ref:`v4l2_format <v4l2-format>` ``type`` field is
+    The struct :c:type:`v4l2_format` ``type`` field is
     invalid or the requested buffer type not supported.
diff --git a/Documentation/media/uapi/v4l/vidioc-g-frequency.rst b/Documentation/media/uapi/v4l/vidioc-g-frequency.rst
index d517c7bb2182..9cbe70098b2b 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-frequency.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-frequency.rst
@@ -36,7 +36,7 @@ Description
 
 To get the current tuner or modulator radio frequency applications set
 the ``tuner`` field of a struct
-:ref:`v4l2_frequency <v4l2-frequency>` to the respective tuner or
+:c:type:`v4l2_frequency` to the respective tuner or
 modulator number (only input devices have tuners, only output devices
 have modulators), zero out the ``reserved`` array and call the
 :ref:`VIDIOC_G_FREQUENCY <VIDIOC_G_FREQUENCY>` ioctl with a pointer to this structure. The
@@ -44,7 +44,7 @@ driver stores the current frequency in the ``frequency`` field.
 
 To change the current tuner or modulator radio frequency applications
 initialize the ``tuner``, ``type`` and ``frequency`` fields, and the
-``reserved`` array of a struct :ref:`v4l2_frequency <v4l2-frequency>`
+``reserved`` array of a struct :c:type:`v4l2_frequency`
 and call the :ref:`VIDIOC_S_FREQUENCY <VIDIOC_G_FREQUENCY>` ioctl with a pointer to this
 structure. When the requested frequency is not possible the driver
 assumes the closest possible value. However :ref:`VIDIOC_S_FREQUENCY <VIDIOC_G_FREQUENCY>` is a
@@ -53,7 +53,7 @@ write-only ioctl, it does not return the actual new frequency.
 
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
-.. _v4l2-frequency:
+.. c:type:: v4l2_frequency
 
 .. flat-table:: struct v4l2_frequency
     :header-rows:  0
@@ -68,10 +68,10 @@ write-only ioctl, it does not return the actual new frequency.
        -  ``tuner``
 
        -  The tuner or modulator index number. This is the same value as in
-	  the struct :ref:`v4l2_input <v4l2-input>` ``tuner`` field and
-	  the struct :ref:`v4l2_tuner <v4l2-tuner>` ``index`` field, or
-	  the struct :ref:`v4l2_output <v4l2-output>` ``modulator`` field
-	  and the struct :ref:`v4l2_modulator <v4l2-modulator>` ``index``
+	  the struct :c:type:`v4l2_input` ``tuner`` field and
+	  the struct :c:type:`v4l2_tuner` ``index`` field, or
+	  the struct :c:type:`v4l2_output` ``modulator`` field
+	  and the struct :c:type:`v4l2_modulator` ``index``
 	  field.
 
     -  .. row 2
@@ -81,7 +81,7 @@ write-only ioctl, it does not return the actual new frequency.
        -  ``type``
 
        -  The tuner type. This is the same value as in the struct
-	  :ref:`v4l2_tuner <v4l2-tuner>` ``type`` field. The type must be
+	  :c:type:`v4l2_tuner` ``type`` field. The type must be
 	  set to ``V4L2_TUNER_RADIO`` for ``/dev/radioX`` device nodes, and
 	  to ``V4L2_TUNER_ANALOG_TV`` for all others. Set this field to
 	  ``V4L2_TUNER_RADIO`` for modulators (currently only radio
@@ -94,8 +94,8 @@ write-only ioctl, it does not return the actual new frequency.
        -  ``frequency``
 
        -  Tuning frequency in units of 62.5 kHz, or if the struct
-	  :ref:`v4l2_tuner <v4l2-tuner>` or struct
-	  :ref:`v4l2_modulator <v4l2-modulator>` ``capability`` flag
+	  :c:type:`v4l2_tuner` or struct
+	  :c:type:`v4l2_modulator` ``capability`` flag
 	  ``V4L2_TUNER_CAP_LOW`` is set, in units of 62.5 Hz. A 1 Hz unit is
 	  used when the ``capability`` flag ``V4L2_TUNER_CAP_1HZ`` is set.
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-input.rst b/Documentation/media/uapi/v4l/vidioc-g-input.rst
index 32735d20066c..1364a918fbce 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-input.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-input.rst
@@ -37,7 +37,7 @@ Description
 To query the current video input applications call the
 :ref:`VIDIOC_G_INPUT <VIDIOC_G_INPUT>` ioctl with a pointer to an integer where the driver
 stores the number of the input, as in the struct
-:ref:`v4l2_input <v4l2-input>` ``index`` field. This ioctl will fail
+:c:type:`v4l2_input` ``index`` field. This ioctl will fail
 only when there are no video inputs, returning ``EINVAL``.
 
 To select a video input applications store the number of the desired
diff --git a/Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst b/Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst
index 387c71c209bc..c56c5bc7beb5 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst
@@ -56,7 +56,7 @@ encoding. You usually do want to add them.
 
 .. tabularcolumns:: |p{1.2cm}|p{3.0cm}|p{13.3cm}|
 
-.. _v4l2-jpegcompression:
+.. c:type:: v4l2_jpegcompression
 
 .. flat-table:: struct v4l2_jpegcompression
     :header-rows:  0
diff --git a/Documentation/media/uapi/v4l/vidioc-g-modulator.rst b/Documentation/media/uapi/v4l/vidioc-g-modulator.rst
index c7729e67e8d9..5d209efa0965 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-modulator.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-modulator.rst
@@ -36,7 +36,7 @@ Description
 
 To query the attributes of a modulator applications initialize the
 ``index`` field and zero out the ``reserved`` array of a struct
-:ref:`v4l2_modulator <v4l2-modulator>` and call the
+:c:type:`v4l2_modulator` and call the
 :ref:`VIDIOC_G_MODULATOR <VIDIOC_G_MODULATOR>` ioctl with a pointer to this structure. Drivers
 fill the rest of the structure or return an ``EINVAL`` error code when the
 index is out of bounds. To enumerate all modulators applications shall
@@ -62,7 +62,7 @@ To change the radio frequency the
 
 .. tabularcolumns:: |p{2.9cm}|p{2.9cm}|p{5.8cm}|p{2.9cm}|p{3.0cm}|
 
-.. _v4l2-modulator:
+.. c:type:: v4l2_modulator
 
 .. flat-table:: struct v4l2_modulator
     :header-rows:  0
@@ -95,7 +95,7 @@ To change the radio frequency the
        -  ``capability``
 
        -  Modulator capability flags. No flags are defined for this field,
-	  the tuner flags in struct :ref:`v4l2_tuner <v4l2-tuner>` are
+	  the tuner flags in struct :c:type:`v4l2_tuner` are
 	  used accordingly. The audio flags indicate the ability to encode
 	  audio subprograms. They will *not* change for example with the
 	  current video standard.
@@ -260,5 +260,5 @@ appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
 
 EINVAL
-    The struct :ref:`v4l2_modulator <v4l2-modulator>` ``index`` is
+    The struct :c:type:`v4l2_modulator` ``index`` is
     out of bounds.
diff --git a/Documentation/media/uapi/v4l/vidioc-g-output.rst b/Documentation/media/uapi/v4l/vidioc-g-output.rst
index e0613e2d667f..7750948fc61b 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-output.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-output.rst
@@ -37,7 +37,7 @@ Description
 To query the current video output applications call the
 :ref:`VIDIOC_G_OUTPUT <VIDIOC_G_OUTPUT>` ioctl with a pointer to an integer where the driver
 stores the number of the output, as in the struct
-:ref:`v4l2_output <v4l2-output>` ``index`` field. This ioctl will
+:c:type:`v4l2_output` ``index`` field. This ioctl will
 fail only when there are no video outputs, returning the ``EINVAL`` error
 code.
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-parm.rst b/Documentation/media/uapi/v4l/vidioc-g-parm.rst
index 9e9af1dd4f29..021b96ee641d 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-parm.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-parm.rst
@@ -47,13 +47,13 @@ section discussing the :ref:`read() <func-read>` function.
 
 To get and set the streaming parameters applications call the
 :ref:`VIDIOC_G_PARM <VIDIOC_G_PARM>` and :ref:`VIDIOC_S_PARM <VIDIOC_G_PARM>` ioctl, respectively. They take a
-pointer to a struct :ref:`struct v4l2_streamparm <v4l2-streamparm>` which contains a
+pointer to a struct :c:type:`struct v4l2_streamparm <v4l2_streamparm>` which contains a
 union holding separate parameters for input and output devices.
 
 
 .. tabularcolumns:: |p{3.5cm}|p{3.5cm}|p{3.5cm}|p{7.0cm}|
 
-.. _v4l2-streamparm:
+.. c:type:: v4l2_streamparm
 
 .. flat-table:: struct v4l2_streamparm
     :header-rows:  0
@@ -69,7 +69,7 @@ union holding separate parameters for input and output devices.
 
        -
        -  The buffer (stream) type, same as struct
-	  :ref:`v4l2_format <v4l2-format>` ``type``, set by the
+	  :c:type:`v4l2_format` ``type``, set by the
 	  application. See :ref:`v4l2-buf-type`
 
     -  .. row 2
@@ -84,7 +84,7 @@ union holding separate parameters for input and output devices.
     -  .. row 3
 
        -
-       -  struct :ref:`v4l2_captureparm <v4l2-captureparm>`
+       -  struct :c:type:`v4l2_captureparm`
 
        -  ``capture``
 
@@ -94,7 +94,7 @@ union holding separate parameters for input and output devices.
     -  .. row 4
 
        -
-       -  struct :ref:`v4l2_outputparm <v4l2-outputparm>`
+       -  struct :c:type:`v4l2_outputparm`
 
        -  ``output``
 
@@ -114,7 +114,7 @@ union holding separate parameters for input and output devices.
 
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
-.. _v4l2-captureparm:
+.. c:type:: v4l2_captureparm
 
 .. flat-table:: struct v4l2_captureparm
     :header-rows:  0
@@ -140,7 +140,7 @@ union holding separate parameters for input and output devices.
 
     -  .. row 3
 
-       -  struct :ref:`v4l2_fract <v4l2-fract>`
+       -  struct :c:type:`v4l2_fract`
 
        -  ``timeperframe``
 
@@ -151,7 +151,7 @@ union holding separate parameters for input and output devices.
 	  Applications store here the desired frame period, drivers return
 	  the actual frame period, which must be greater or equal to the
 	  nominal frame period determined by the current video standard
-	  (struct :ref:`v4l2_standard <v4l2-standard>` ``frameperiod``
+	  (struct :c:type:`v4l2_standard` ``frameperiod``
 	  field). Changing the video standard (also implicitly by switching
 	  the video input) may reset this parameter to the nominal frame
 	  period. To reset manually applications can just set this field to
@@ -197,7 +197,7 @@ union holding separate parameters for input and output devices.
 
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
-.. _v4l2-outputparm:
+.. c:type:: v4l2_outputparm
 
 .. flat-table:: struct v4l2_outputparm
     :header-rows:  0
@@ -223,7 +223,7 @@ union holding separate parameters for input and output devices.
 
     -  .. row 3
 
-       -  struct :ref:`v4l2_fract <v4l2-fract>`
+       -  struct :c:type:`v4l2_fract`
 
        -  ``timeperframe``
 
@@ -241,7 +241,7 @@ union holding separate parameters for input and output devices.
 	  Applications store here the desired frame period, drivers return
 	  the actual frame period, which must be greater or equal to the
 	  nominal frame period determined by the current video standard
-	  (struct :ref:`v4l2_standard <v4l2-standard>` ``frameperiod``
+	  (struct :c:type:`v4l2_standard` ``frameperiod``
 	  field). Changing the video standard (also implicitly by switching
 	  the video output) may reset this parameter to the nominal frame
 	  period. To reset manually applications can just set this field to
diff --git a/Documentation/media/uapi/v4l/vidioc-g-selection.rst b/Documentation/media/uapi/v4l/vidioc-g-selection.rst
index 85b5afa48474..af38b2568e3b 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-selection.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-selection.rst
@@ -41,43 +41,43 @@ Description
 The ioctls are used to query and configure selection rectangles.
 
 To query the cropping (composing) rectangle set struct
-:ref:`v4l2_selection <v4l2-selection>` ``type`` field to the
+:c:type:`v4l2_selection` ``type`` field to the
 respective buffer type. Do not use the multiplanar buffer types. Use
 ``V4L2_BUF_TYPE_VIDEO_CAPTURE`` instead of
 ``V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE`` and use
 ``V4L2_BUF_TYPE_VIDEO_OUTPUT`` instead of
 ``V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE``. The next step is setting the
-value of struct :ref:`v4l2_selection <v4l2-selection>` ``target``
+value of struct :c:type:`v4l2_selection` ``target``
 field to ``V4L2_SEL_TGT_CROP`` (``V4L2_SEL_TGT_COMPOSE``). Please refer
 to table :ref:`v4l2-selections-common` or :ref:`selection-api` for
 additional targets. The ``flags`` and ``reserved`` fields of struct
-:ref:`v4l2_selection <v4l2-selection>` are ignored and they must be
+:c:type:`v4l2_selection` are ignored and they must be
 filled with zeros. The driver fills the rest of the structure or returns
 EINVAL error code if incorrect buffer type or target was used. If
 cropping (composing) is not supported then the active rectangle is not
 mutable and it is always equal to the bounds rectangle. Finally, the
-struct :ref:`v4l2_rect <v4l2-rect>` ``r`` rectangle is filled with
+struct :c:type:`v4l2_rect` ``r`` rectangle is filled with
 the current cropping (composing) coordinates. The coordinates are
 expressed in driver-dependent units. The only exception are rectangles
 for images in raw formats, whose coordinates are always expressed in
 pixels.
 
 To change the cropping (composing) rectangle set the struct
-:ref:`v4l2_selection <v4l2-selection>` ``type`` field to the
+:c:type:`v4l2_selection` ``type`` field to the
 respective buffer type. Do not use multiplanar buffers. Use
 ``V4L2_BUF_TYPE_VIDEO_CAPTURE`` instead of
 ``V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE``. Use
 ``V4L2_BUF_TYPE_VIDEO_OUTPUT`` instead of
 ``V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE``. The next step is setting the
-value of struct :ref:`v4l2_selection <v4l2-selection>` ``target`` to
+value of struct :c:type:`v4l2_selection` ``target`` to
 ``V4L2_SEL_TGT_CROP`` (``V4L2_SEL_TGT_COMPOSE``). Please refer to table
 :ref:`v4l2-selections-common` or :ref:`selection-api` for additional
-targets. The struct :ref:`v4l2_rect <v4l2-rect>` ``r`` rectangle need
+targets. The struct :c:type:`v4l2_rect` ``r`` rectangle need
 to be set to the desired active area. Field struct
-:ref:`v4l2_selection <v4l2-selection>` ``reserved`` is ignored and
+:c:type:`v4l2_selection` ``reserved`` is ignored and
 must be filled with zeros. The driver may adjust coordinates of the
 requested rectangle. An application may introduce constraints to control
-rounding behaviour. The struct :ref:`v4l2_selection <v4l2-selection>`
+rounding behaviour. The struct :c:type:`v4l2_selection`
 ``flags`` field must be set to one of the following:
 
 -  ``0`` - The driver can adjust the rectangle size freely and shall
@@ -102,7 +102,7 @@ horizontal and vertical offset and sizes are chosen according to
 following priority:
 
 1. Satisfy constraints from struct
-   :ref:`v4l2_selection <v4l2-selection>` ``flags``.
+   :c:type:`v4l2_selection` ``flags``.
 
 2. Adjust width, height, left, and top to hardware limits and
    alignments.
@@ -115,7 +115,7 @@ following priority:
 5. Keep horizontal and vertical offset as close as possible to original
    ones.
 
-On success the struct :ref:`v4l2_rect <v4l2-rect>` ``r`` field
+On success the struct :c:type:`v4l2_rect` ``r`` field
 contains the adjusted rectangle. When the parameters are unsuitable the
 application may modify the cropping (composing) or image parameters and
 repeat the cycle until satisfactory parameters have been negotiated. If
@@ -140,7 +140,7 @@ Selection targets and flags are documented in
 
 
 
-.. _v4l2-selection:
+.. c:type:: v4l2_selection
 
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
@@ -179,7 +179,7 @@ Selection targets and flags are documented in
 
     -  .. row 4
 
-       -  struct :ref:`v4l2_rect <v4l2-rect>`
+       -  struct :c:type:`v4l2_rect`
 
        -  ``r``
 
@@ -207,7 +207,7 @@ EINVAL
     supported, or the ``flags`` argument is not valid.
 
 ERANGE
-    It is not possible to adjust struct :ref:`v4l2_rect <v4l2-rect>`
+    It is not possible to adjust struct :c:type:`v4l2_rect`
     ``r`` rectangle to satisfy all constraints given in the ``flags``
     argument.
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst b/Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst
index abda04b07999..4df7227e0490 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst
@@ -33,7 +33,7 @@ Description
 
 To find out which data services are supported by a sliced VBI capture or
 output device, applications initialize the ``type`` field of a struct
-:ref:`v4l2_sliced_vbi_cap <v4l2-sliced-vbi-cap>`, clear the
+:c:type:`v4l2_sliced_vbi_cap`, clear the
 ``reserved`` array and call the :ref:`VIDIOC_G_SLICED_VBI_CAP <VIDIOC_G_SLICED_VBI_CAP>` ioctl. The
 driver fills in the remaining fields or returns an ``EINVAL`` error code if
 the sliced VBI API is unsupported or ``type`` is invalid.
@@ -44,7 +44,7 @@ the sliced VBI API is unsupported or ``type`` is invalid.
    to write-read, in Linux 2.6.19.
 
 
-.. _v4l2-sliced-vbi-cap:
+.. c:type:: v4l2_sliced_vbi_cap
 
 .. tabularcolumns:: |p{1.2cm}|p{4.2cm}|p{4.1cm}|p{4.0cm}|p{4.0cm}|
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-std.rst b/Documentation/media/uapi/v4l/vidioc-g-std.rst
index 91162f5ea6b2..c351eb9f6b0e 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-std.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-std.rst
@@ -38,9 +38,9 @@ To query and select the current video standard applications use the
 :ref:`VIDIOC_G_STD <VIDIOC_G_STD>` and :ref:`VIDIOC_S_STD <VIDIOC_G_STD>` ioctls which take a pointer to a
 :ref:`v4l2_std_id <v4l2-std-id>` type as argument. :ref:`VIDIOC_G_STD <VIDIOC_G_STD>`
 can return a single flag or a set of flags as in struct
-:ref:`v4l2_standard <v4l2-standard>` field ``id``. The flags must be
+:c:type:`v4l2_standard` field ``id``. The flags must be
 unambiguous such that they appear in only one enumerated
-:ref:`struct v4l2_standard <v4l2-standard>` structure.
+:c:type:`struct v4l2_standard <v4l2_standard>` structure.
 
 :ref:`VIDIOC_S_STD <VIDIOC_G_STD>` accepts one or more flags, being a write-only ioctl it
 does not return the actual new standard as :ref:`VIDIOC_G_STD <VIDIOC_G_STD>` does. When
diff --git a/Documentation/media/uapi/v4l/vidioc-g-tuner.rst b/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
index 4658a4715a5e..01b7f26bf22f 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
@@ -36,7 +36,7 @@ Description
 
 To query the attributes of a tuner applications initialize the ``index``
 field and zero out the ``reserved`` array of a struct
-:ref:`v4l2_tuner <v4l2-tuner>` and call the ``VIDIOC_G_TUNER`` ioctl
+:c:type:`v4l2_tuner` and call the ``VIDIOC_G_TUNER`` ioctl
 with a pointer to this structure. Drivers fill the rest of the structure
 or return an ``EINVAL`` error code when the index is out of bounds. To
 enumerate all tuners applications shall begin at index zero,
@@ -61,7 +61,7 @@ To change the radio frequency the
 
  .. tabularcolumns:: |p{1.3cm}|p{3.0cm}|p{6.6cm}|p{6.6cm}|
 
-.. _v4l2-tuner:
+.. c:type:: v4l2_tuner
 
 .. cssclass:: longtable
 
@@ -116,7 +116,7 @@ To change the radio frequency the
 
 	  If multiple frequency bands are supported, then ``capability`` is
 	  the union of all ``capability`` fields of each struct
-	  :ref:`v4l2_frequency_band <v4l2-frequency-band>`.
+	  :c:type:`v4l2_frequency_band`.
 
     -  .. row 5
 
@@ -226,7 +226,7 @@ To change the radio frequency the
 	  received audio programs do not match.
 
 	  Currently this is the only field of struct
-	  :ref:`struct v4l2_tuner <v4l2-tuner>` applications can change.
+	  :c:type:`struct v4l2_tuner <v4l2_tuner>` applications can change.
 
     -  .. row 15
 
@@ -337,7 +337,7 @@ To change the radio frequency the
 	  multi-standard because the video standard is automatically
 	  determined from the frequency band.) The set of supported video
 	  standards is available from the struct
-	  :ref:`v4l2_input <v4l2-input>` pointing to this tuner, see the
+	  :c:type:`v4l2_input` pointing to this tuner, see the
 	  description of ioctl :ref:`VIDIOC_ENUMINPUT`
 	  for details. Only ``V4L2_TUNER_ANALOG_TV`` tuners can have this
 	  capability.
@@ -730,7 +730,7 @@ appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
 
 EINVAL
-    The struct :ref:`v4l2_tuner <v4l2-tuner>` ``index`` is out of
+    The struct :c:type:`v4l2_tuner` ``index`` is out of
     bounds.
 
 .. [#f1]
diff --git a/Documentation/media/uapi/v4l/vidioc-prepare-buf.rst b/Documentation/media/uapi/v4l/vidioc-prepare-buf.rst
index c3f6c1c615f6..c20e1c7d5f89 100644
--- a/Documentation/media/uapi/v4l/vidioc-prepare-buf.rst
+++ b/Documentation/media/uapi/v4l/vidioc-prepare-buf.rst
@@ -40,7 +40,7 @@ operations are not required, the application can use one of
 ``V4L2_BUF_FLAG_NO_CACHE_INVALIDATE`` and
 ``V4L2_BUF_FLAG_NO_CACHE_CLEAN`` flags to skip the respective step.
 
-The :ref:`struct v4l2_buffer <v4l2-buffer>` structure is specified in
+The :c:type:`struct v4l2_buffer <v4l2_buffer>` structure is specified in
 :ref:`buffer`.
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-qbuf.rst b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
index dd3f2e069fcb..727238fc2337 100644
--- a/Documentation/media/uapi/v4l/vidioc-qbuf.rst
+++ b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
@@ -39,14 +39,14 @@ Applications call the ``VIDIOC_QBUF`` ioctl to enqueue an empty
 The semantics depend on the selected I/O method.
 
 To enqueue a buffer applications set the ``type`` field of a struct
-:ref:`v4l2_buffer <v4l2-buffer>` to the same buffer type as was
-previously used with struct :ref:`v4l2_format <v4l2-format>` ``type``
-and struct :ref:`v4l2_requestbuffers <v4l2-requestbuffers>` ``type``.
+:c:type:`v4l2_buffer` to the same buffer type as was
+previously used with struct :c:type:`v4l2_format` ``type``
+and struct :c:type:`v4l2_requestbuffers` ``type``.
 Applications must also set the ``index`` field. Valid index numbers
 range from zero to the number of buffers allocated with
 :ref:`VIDIOC_REQBUFS` (struct
-:ref:`v4l2_requestbuffers <v4l2-requestbuffers>` ``count``) minus
-one. The contents of the struct :ref:`struct v4l2_buffer <v4l2-buffer>` returned
+:c:type:`v4l2_requestbuffers` ``count``) minus
+one. The contents of the struct :c:type:`struct v4l2_buffer <v4l2_buffer>` returned
 by a :ref:`VIDIOC_QUERYBUF` ioctl will do as well.
 When the buffer is intended for output (``type`` is
 ``V4L2_BUF_TYPE_VIDEO_OUTPUT``, ``V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE``,
@@ -56,7 +56,7 @@ for details. Applications must also set ``flags`` to 0. The
 ``reserved2`` and ``reserved`` fields must be set to 0. When using the
 :ref:`multi-planar API <planar-apis>`, the ``m.planes`` field must
 contain a userspace pointer to a filled-in array of struct
-:ref:`v4l2_plane <v4l2-plane>` and the ``length`` field must be set
+:c:type:`v4l2_plane` and the ``length`` field must be set
 to the number of elements in that array.
 
 To enqueue a :ref:`memory mapped <mmap>` buffer applications set the
@@ -70,7 +70,7 @@ To enqueue a :ref:`user pointer <userp>` buffer applications set the
 ``memory`` field to ``V4L2_MEMORY_USERPTR``, the ``m.userptr`` field to
 the address of the buffer and ``length`` to its size. When the
 multi-planar API is used, ``m.userptr`` and ``length`` members of the
-passed array of struct :ref:`v4l2_plane <v4l2-plane>` have to be used
+passed array of struct :c:type:`v4l2_plane` have to be used
 instead. When ``VIDIOC_QBUF`` is called with a pointer to this structure
 the driver sets the ``V4L2_BUF_FLAG_QUEUED`` flag and clears the
 ``V4L2_BUF_FLAG_MAPPED`` and ``V4L2_BUF_FLAG_DONE`` flags in the
@@ -85,7 +85,7 @@ To enqueue a :ref:`DMABUF <dmabuf>` buffer applications set the
 ``memory`` field to ``V4L2_MEMORY_DMABUF`` and the ``m.fd`` field to a
 file descriptor associated with a DMABUF buffer. When the multi-planar
 API is used the ``m.fd`` fields of the passed array of struct
-:ref:`v4l2_plane <v4l2-plane>` have to be used instead. When
+:c:type:`v4l2_plane` have to be used instead. When
 ``VIDIOC_QBUF`` is called with a pointer to this structure the driver
 sets the ``V4L2_BUF_FLAG_QUEUED`` flag and clears the
 ``V4L2_BUF_FLAG_MAPPED`` and ``V4L2_BUF_FLAG_DONE`` flags in the
@@ -100,7 +100,7 @@ device is closed.
 Applications call the ``VIDIOC_DQBUF`` ioctl to dequeue a filled
 (capturing) or displayed (output) buffer from the driver's outgoing
 queue. They just set the ``type``, ``memory`` and ``reserved`` fields of
-a struct :ref:`v4l2_buffer <v4l2-buffer>` as above, when
+a struct :c:type:`v4l2_buffer` as above, when
 ``VIDIOC_DQBUF`` is called with a pointer to this structure the driver
 fills the remaining fields or returns an error code. The driver may also
 set ``V4L2_BUF_FLAG_ERROR`` in the ``flags`` field. It indicates a
@@ -114,7 +114,7 @@ queue. When the ``O_NONBLOCK`` flag was given to the
 :ref:`open() <func-open>` function, ``VIDIOC_DQBUF`` returns
 immediately with an ``EAGAIN`` error code when no buffer is available.
 
-The :ref:`struct v4l2_buffer <v4l2-buffer>` structure is specified in
+The :c:type:`struct v4l2_buffer <v4l2_buffer>` structure is specified in
 :ref:`buffer`.
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-query-dv-timings.rst b/Documentation/media/uapi/v4l/vidioc-query-dv-timings.rst
index 230ebcb8aa4b..0d16853b1b51 100644
--- a/Documentation/media/uapi/v4l/vidioc-query-dv-timings.rst
+++ b/Documentation/media/uapi/v4l/vidioc-query-dv-timings.rst
@@ -37,7 +37,7 @@ Description
 The hardware may be able to detect the current DV timings automatically,
 similar to sensing the video standard. To do so, applications call
 :ref:`VIDIOC_QUERY_DV_TIMINGS` with a pointer to a struct
-:ref:`v4l2_dv_timings <v4l2-dv-timings>`. Once the hardware detects
+:c:type:`v4l2_dv_timings`. Once the hardware detects
 the timings, it will fill in the timings structure.
 
 .. note::
diff --git a/Documentation/media/uapi/v4l/vidioc-querybuf.rst b/Documentation/media/uapi/v4l/vidioc-querybuf.rst
index 8edfc7931ec6..1edd76c06e0a 100644
--- a/Documentation/media/uapi/v4l/vidioc-querybuf.rst
+++ b/Documentation/media/uapi/v4l/vidioc-querybuf.rst
@@ -36,17 +36,17 @@ be used to query the status of a buffer at any time after buffers have
 been allocated with the :ref:`VIDIOC_REQBUFS` ioctl.
 
 Applications set the ``type`` field of a struct
-:ref:`v4l2_buffer <v4l2-buffer>` to the same buffer type as was
-previously used with struct :ref:`v4l2_format <v4l2-format>` ``type``
-and struct :ref:`v4l2_requestbuffers <v4l2-requestbuffers>` ``type``,
+:c:type:`v4l2_buffer` to the same buffer type as was
+previously used with struct :c:type:`v4l2_format` ``type``
+and struct :c:type:`v4l2_requestbuffers` ``type``,
 and the ``index`` field. Valid index numbers range from zero to the
 number of buffers allocated with
 :ref:`VIDIOC_REQBUFS` (struct
-:ref:`v4l2_requestbuffers <v4l2-requestbuffers>` ``count``) minus
+:c:type:`v4l2_requestbuffers` ``count``) minus
 one. The ``reserved`` and ``reserved2`` fields must be set to 0. When
 using the :ref:`multi-planar API <planar-apis>`, the ``m.planes``
 field must contain a userspace pointer to an array of struct
-:ref:`v4l2_plane <v4l2-plane>` and the ``length`` field has to be set
+:c:type:`v4l2_plane` and the ``length`` field has to be set
 to the number of elements in that array. After calling
 :ref:`VIDIOC_QUERYBUF` with a pointer to this structure drivers return an
 error code or fill the rest of the structure.
@@ -59,11 +59,11 @@ set to the current I/O method. For the single-planar API, the
 device memory, the ``length`` field its size. For the multi-planar API,
 fields ``m.mem_offset`` and ``length`` in the ``m.planes`` array
 elements will be used instead and the ``length`` field of struct
-:ref:`v4l2_buffer <v4l2-buffer>` is set to the number of filled-in
+:c:type:`v4l2_buffer` is set to the number of filled-in
 array elements. The driver may or may not set the remaining fields and
 flags, they are meaningless in this context.
 
-The :ref:`struct v4l2_buffer <v4l2-buffer>` structure is specified in
+The :c:type:`struct v4l2_buffer <v4l2_buffer>` structure is specified in
 :ref:`buffer`.
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-querycap.rst b/Documentation/media/uapi/v4l/vidioc-querycap.rst
index 97a394bbcc9c..2824ead350b9 100644
--- a/Documentation/media/uapi/v4l/vidioc-querycap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-querycap.rst
@@ -34,14 +34,14 @@ Description
 All V4L2 devices support the ``VIDIOC_QUERYCAP`` ioctl. It is used to
 identify kernel devices compatible with this specification and to obtain
 information about driver and hardware capabilities. The ioctl takes a
-pointer to a struct :ref:`v4l2_capability <v4l2-capability>` which is
+pointer to a struct :c:type:`v4l2_capability` which is
 filled by the driver. When the driver is not compatible with this
 specification the ioctl returns an ``EINVAL`` error code.
 
 
 .. tabularcolumns:: |p{1.5cm}|p{2.5cm}|p{13cm}|
 
-.. _v4l2-capability:
+.. c:type:: v4l2_capability
 
 .. flat-table:: struct v4l2_capability
     :header-rows:  0
@@ -373,7 +373,7 @@ specification the ioctl returns an ``EINVAL`` error code.
        -  0x00200000
 
        -  The device supports the struct
-	  :ref:`v4l2_pix_format <v4l2-pix-format>` extended fields.
+	  :c:type:`v4l2_pix_format` extended fields.
 
     -  .. row 22
 
@@ -435,6 +435,6 @@ appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
 
 .. [#f1]
-   The struct :ref:`v4l2_framebuffer <v4l2-framebuffer>` lacks an
+   The struct :c:type:`v4l2_framebuffer` lacks an
    enum :ref:`v4l2_buf_type <v4l2-buf-type>` field, therefore the
    type of overlay is implied by the driver capabilities.
diff --git a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
index db3ad928ec1c..ef32e28e57c7 100644
--- a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
+++ b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
@@ -592,7 +592,7 @@ See also the examples in :ref:`control`.
 	  pass a string of length 8 to
 	  :ref:`VIDIOC_S_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` you need to
 	  set the ``size`` field of struct
-	  :ref:`v4l2_ext_control <v4l2-ext-control>` to 9. For
+	  :c:type:`v4l2_ext_control` to 9. For
 	  :ref:`VIDIOC_G_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` you can set
 	  the ``size`` field to ``maximum`` + 1. Which character encoding is
 	  used will depend on the string control itself and should be part
@@ -769,7 +769,7 @@ See also the examples in :ref:`control`.
 
        -  This control has a pointer type, so its value has to be accessed
 	  using one of the pointer fields of struct
-	  :ref:`v4l2_ext_control <v4l2-ext-control>`. This flag is set
+	  :c:type:`v4l2_ext_control`. This flag is set
 	  for controls that are an array, string, or have a compound type.
 	  In all cases you have to set a pointer to memory containing the
 	  payload of the control.
diff --git a/Documentation/media/uapi/v4l/vidioc-reqbufs.rst b/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
index 39c9bf8af47a..195f0a3d783c 100644
--- a/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
+++ b/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
@@ -43,7 +43,7 @@ configures the driver into DMABUF I/O mode without performing any direct
 allocation.
 
 To allocate device buffers applications initialize all fields of the
-:ref:`struct v4l2_requestbuffers <v4l2-requestbuffers>` structure. They set the ``type``
+:c:type:`struct v4l2_requestbuffers <v4l2_requestbuffers>` structure. They set the ``type``
 field to the respective stream or buffer type, the ``count`` field to
 the desired number of buffers, ``memory`` must be set to the requested
 I/O method and the ``reserved`` array must be zeroed. When the ioctl is
@@ -65,7 +65,7 @@ any DMA in progress, an implicit
 :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>`.
 
 
-.. _v4l2-requestbuffers:
+.. c:type:: v4l2_requestbuffers
 
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
@@ -90,7 +90,7 @@ any DMA in progress, an implicit
        -  ``type``
 
        -  Type of the stream or buffers, this is the same as the struct
-	  :ref:`v4l2_format <v4l2-format>` ``type`` field. See
+	  :c:type:`v4l2_format` ``type`` field. See
 	  :ref:`v4l2-buf-type` for valid values.
 
     -  .. row 3
diff --git a/Documentation/media/uapi/v4l/vidioc-s-hw-freq-seek.rst b/Documentation/media/uapi/v4l/vidioc-s-hw-freq-seek.rst
index efbe3a1f1134..e33969b9d3da 100644
--- a/Documentation/media/uapi/v4l/vidioc-s-hw-freq-seek.rst
+++ b/Documentation/media/uapi/v4l/vidioc-s-hw-freq-seek.rst
@@ -35,12 +35,12 @@ Start a hardware frequency seek from the current frequency. To do this
 applications initialize the ``tuner``, ``type``, ``seek_upward``,
 ``wrap_around``, ``spacing``, ``rangelow`` and ``rangehigh`` fields, and
 zero out the ``reserved`` array of a struct
-:ref:`v4l2_hw_freq_seek <v4l2-hw-freq-seek>` and call the
+:c:type:`v4l2_hw_freq_seek` and call the
 ``VIDIOC_S_HW_FREQ_SEEK`` ioctl with a pointer to this structure.
 
 The ``rangelow`` and ``rangehigh`` fields can be set to a non-zero value
 to tell the driver to search a specific band. If the struct
-:ref:`v4l2_tuner <v4l2-tuner>` ``capability`` field has the
+:c:type:`v4l2_tuner` ``capability`` field has the
 ``V4L2_TUNER_CAP_HWSEEK_PROG_LIM`` flag set, these values must fall
 within one of the bands returned by
 :ref:`VIDIOC_ENUM_FREQ_BANDS`. If the
@@ -61,7 +61,7 @@ error code is returned and no seek takes place.
 
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
-.. _v4l2-hw-freq-seek:
+.. c:type:: v4l2_hw_freq_seek
 
 .. flat-table:: struct v4l2_hw_freq_seek
     :header-rows:  0
@@ -76,8 +76,8 @@ error code is returned and no seek takes place.
        -  ``tuner``
 
        -  The tuner index number. This is the same value as in the struct
-	  :ref:`v4l2_input <v4l2-input>` ``tuner`` field and the struct
-	  :ref:`v4l2_tuner <v4l2-tuner>` ``index`` field.
+	  :c:type:`v4l2_input` ``tuner`` field and the struct
+	  :c:type:`v4l2_tuner` ``index`` field.
 
     -  .. row 2
 
@@ -86,7 +86,7 @@ error code is returned and no seek takes place.
        -  ``type``
 
        -  The tuner type. This is the same value as in the struct
-	  :ref:`v4l2_tuner <v4l2-tuner>` ``type`` field. See
+	  :c:type:`v4l2_tuner` ``type`` field. See
 	  :ref:`v4l2-tuner-type`
 
     -  .. row 3
@@ -105,7 +105,7 @@ error code is returned and no seek takes place.
        -  ``wrap_around``
 
        -  If non-zero, wrap around when at the end of the frequency range,
-	  else stop seeking. The struct :ref:`v4l2_tuner <v4l2-tuner>`
+	  else stop seeking. The struct :c:type:`v4l2_tuner`
 	  ``capability`` field will tell you what the hardware supports.
 
     -  .. row 5
@@ -126,9 +126,9 @@ error code is returned and no seek takes place.
 
        -  If non-zero, the lowest tunable frequency of the band to search in
 	  units of 62.5 kHz, or if the struct
-	  :ref:`v4l2_tuner <v4l2-tuner>` ``capability`` field has the
+	  :c:type:`v4l2_tuner` ``capability`` field has the
 	  ``V4L2_TUNER_CAP_LOW`` flag set, in units of 62.5 Hz or if the
-	  struct :ref:`v4l2_tuner <v4l2-tuner>` ``capability`` field has
+	  struct :c:type:`v4l2_tuner` ``capability`` field has
 	  the ``V4L2_TUNER_CAP_1HZ`` flag set, in units of 1 Hz. If
 	  ``rangelow`` is zero a reasonable default value is used.
 
@@ -140,9 +140,9 @@ error code is returned and no seek takes place.
 
        -  If non-zero, the highest tunable frequency of the band to search
 	  in units of 62.5 kHz, or if the struct
-	  :ref:`v4l2_tuner <v4l2-tuner>` ``capability`` field has the
+	  :c:type:`v4l2_tuner` ``capability`` field has the
 	  ``V4L2_TUNER_CAP_LOW`` flag set, in units of 62.5 Hz or if the
-	  struct :ref:`v4l2_tuner <v4l2-tuner>` ``capability`` field has
+	  struct :c:type:`v4l2_tuner` ``capability`` field has
 	  the ``V4L2_TUNER_CAP_1HZ`` flag set, in units of 1 Hz. If
 	  ``rangehigh`` is zero a reasonable default value is used.
 
diff --git a/Documentation/media/uapi/v4l/vidioc-streamon.rst b/Documentation/media/uapi/v4l/vidioc-streamon.rst
index 25dfaa44af3b..972d5b3c74aa 100644
--- a/Documentation/media/uapi/v4l/vidioc-streamon.rst
+++ b/Documentation/media/uapi/v4l/vidioc-streamon.rst
@@ -69,7 +69,7 @@ accordingly.
 
 Both ioctls take a pointer to an integer, the desired buffer or stream
 type. This is the same as struct
-:ref:`v4l2_requestbuffers <v4l2-requestbuffers>` ``type``.
+:c:type:`v4l2_requestbuffers` ``type``.
 
 If ``VIDIOC_STREAMON`` is called when streaming is already in progress,
 or if ``VIDIOC_STREAMOFF`` is called when streaming is already stopped,
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst b/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst
index 3df2099ceeb9..db7145016571 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst
@@ -113,7 +113,7 @@ multiple pads of the same sub-device is not defined.
 
     -  .. row 6
 
-       -  struct :ref:`v4l2_fract <v4l2-fract>`
+       -  struct :c:type:`v4l2_fract`
 
        -  ``interval``
 
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-g-crop.rst b/Documentation/media/uapi/v4l/vidioc-subdev-g-crop.rst
index b0fb5203e65f..80517ec8a847 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-g-crop.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-g-crop.rst
@@ -100,7 +100,7 @@ modified format should be as close as possible to the original request.
 
     -  .. row 3
 
-       -  struct :ref:`v4l2_rect <v4l2-rect>`
+       -  struct :c:type:`v4l2_rect`
 
        -  ``rect``
 
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-g-frame-interval.rst b/Documentation/media/uapi/v4l/vidioc-subdev-g-frame-interval.rst
index f8405bf344fa..7580174a6ed1 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-g-frame-interval.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-g-frame-interval.rst
@@ -87,7 +87,7 @@ the same sub-device is not defined.
 
     -  .. row 2
 
-       -  struct :ref:`v4l2_fract <v4l2-fract>`
+       -  struct :c:type:`v4l2_fract`
 
        -  ``interval``
 
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-g-selection.rst b/Documentation/media/uapi/v4l/vidioc-subdev-g-selection.rst
index 697fc40434cc..d581ff6cf458 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-g-selection.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-g-selection.rst
@@ -110,7 +110,7 @@ Selection targets and flags are documented in
 
     -  .. row 5
 
-       -  struct :ref:`v4l2_rect <v4l2-rect>`
+       -  struct :c:type:`v4l2_rect`
 
        -  ``r``
 
diff --git a/Documentation/media/uapi/v4l/vidioc-subscribe-event.rst b/Documentation/media/uapi/v4l/vidioc-subscribe-event.rst
index 04eee095952b..0202a78cbeb0 100644
--- a/Documentation/media/uapi/v4l/vidioc-subscribe-event.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subscribe-event.rst
@@ -41,7 +41,7 @@ using the :ref:`VIDIOC_DQEVENT` ioctl.
 
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
-.. _v4l2-event-subscription:
+.. c:type:: v4l2_event_subscription
 
 .. flat-table:: struct v4l2_event_subscription
     :header-rows:  0
-- 
2.7.4


