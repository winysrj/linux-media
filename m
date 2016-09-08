Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43891 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965325AbcIHMET (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 08:04:19 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>
Subject: [PATCH 27/47] [media] docs-rst exceptions: use C domain references for DVB headers
Date: Thu,  8 Sep 2016 09:03:49 -0300
Message-Id: <9d8cbbdccd4e723dd80abee094380b96126f737d.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that we moved away from the :ref: type of references,
we need to update the exceptions lists.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/audio.h.rst.exceptions         |  6 +-
 Documentation/media/ca.h.rst.exceptions            | 32 ++++----
 Documentation/media/dmx.h.rst.exceptions           | 85 +++++++++++-----------
 Documentation/media/frontend.h.rst.exceptions      |  8 +-
 Documentation/media/intro.rst                      |  2 +-
 Documentation/media/net.h.rst.exceptions           |  4 +-
 .../uapi/dvb/audio-bilingual-channel-select.rst    |  2 +-
 .../media/uapi/dvb/audio-channel-select.rst        |  2 +-
 .../media/uapi/dvb/audio-select-source.rst         |  2 +-
 .../media/uapi/dvb/audio-set-attributes.rst        |  2 +-
 Documentation/media/uapi/dvb/audio-set-karaoke.rst |  2 +-
 Documentation/media/uapi/dvb/audio-set-mixer.rst   |  2 +-
 Documentation/media/uapi/dvb/audio_data_types.rst  | 31 +-------
 Documentation/media/uapi/dvb/dmx_types.rst         | 39 ++++------
 Documentation/media/uapi/dvb/fe-bandwidth-t.rst    |  5 +-
 .../media/uapi/dvb/fe-diseqc-recv-slave-reply.rst  |  3 -
 .../media/uapi/dvb/fe-diseqc-send-burst.rst        |  9 +--
 .../media/uapi/dvb/fe-diseqc-send-master-cmd.rst   |  4 +-
 Documentation/media/uapi/dvb/fe-get-info.rst       | 11 +--
 Documentation/media/uapi/dvb/fe-read-status.rst    |  8 +-
 Documentation/media/uapi/dvb/fe-set-tone.rst       |  9 +--
 Documentation/media/uapi/dvb/fe-set-voltage.rst    |  4 +-
 Documentation/media/uapi/dvb/fe-type-t.rst         |  4 +-
 .../media/uapi/dvb/fe_property_parameters.rst      | 69 ++++++------------
 Documentation/media/uapi/dvb/net-add-if.rst        |  6 --
 Documentation/media/video.h.rst.exceptions         | 20 ++---
 26 files changed, 144 insertions(+), 227 deletions(-)

diff --git a/Documentation/media/audio.h.rst.exceptions b/Documentation/media/audio.h.rst.exceptions
index 8330edcd906d..f40f3cbfe4c9 100644
--- a/Documentation/media/audio.h.rst.exceptions
+++ b/Documentation/media/audio.h.rst.exceptions
@@ -2,7 +2,7 @@
 ignore define _DVBAUDIO_H_
 
 # Typedef pointing to structs
-replace typedef audio_karaoke_t audio-karaoke
+replace typedef audio_karaoke_t :c:type:`audio_karaoke`
 
 # Undocumented audio caps, as this is a deprecated API anyway
 ignore define AUDIO_CAP_DTS
@@ -16,5 +16,5 @@ ignore define AUDIO_CAP_SDDS
 ignore define AUDIO_CAP_AC3
 
 # some typedefs should point to struct/enums
-replace typedef audio_mixer_t audio-mixer
-replace typedef audio_status_t audio-status
+replace typedef audio_mixer_t :c:type:`audio_mixer`
+replace typedef audio_status_t :c:type:`audio_status`
diff --git a/Documentation/media/ca.h.rst.exceptions b/Documentation/media/ca.h.rst.exceptions
index 09c13be67527..d7c9fed8c004 100644
--- a/Documentation/media/ca.h.rst.exceptions
+++ b/Documentation/media/ca.h.rst.exceptions
@@ -2,23 +2,23 @@
 ignore define _DVBCA_H_
 
 # struct ca_slot_info defines
-replace define CA_CI ca-slot-info
-replace define CA_CI_LINK ca-slot-info
-replace define CA_CI_PHYS ca-slot-info
-replace define CA_DESCR ca-slot-info
-replace define CA_SC ca-slot-info
-replace define CA_CI_MODULE_PRESENT ca-slot-info
-replace define CA_CI_MODULE_READY ca-slot-info
+replace define CA_CI :c:type:`ca_slot_info`
+replace define CA_CI_LINK :c:type:`ca_slot_info`
+replace define CA_CI_PHYS :c:type:`ca_slot_info`
+replace define CA_DESCR :c:type:`ca_slot_info`
+replace define CA_SC :c:type:`ca_slot_info`
+replace define CA_CI_MODULE_PRESENT :c:type:`ca_slot_info`
+replace define CA_CI_MODULE_READY :c:type:`ca_slot_info`
 
 # struct ca_descr_info defines
-replace define CA_ECD ca-descr-info
-replace define CA_NDS ca-descr-info
-replace define CA_DSS ca-descr-info
+replace define CA_ECD :c:type:`ca_descr_info`
+replace define CA_NDS :c:type:`ca_descr_info`
+replace define CA_DSS :c:type:`ca_descr_info`
 
 # some typedefs should point to struct/enums
-replace typedef ca_pid_t ca-pid
-replace typedef ca_slot_info_t ca-slot-info
-replace typedef ca_descr_info_t ca-descr-info
-replace typedef ca_caps_t ca-caps
-replace typedef ca_msg_t ca-msg
-replace typedef ca_descr_t ca-descr
+replace typedef ca_pid_t :c:type:`ca_pid`
+replace typedef ca_slot_info_t :c:type:`ca_slot_info`
+replace typedef ca_descr_info_t :c:type:`ca_descr_info`
+replace typedef ca_caps_t :c:type:`ca_caps`
+replace typedef ca_msg_t :c:type:`ca_msg`
+replace typedef ca_descr_t :c:type:`ca_descr`
diff --git a/Documentation/media/dmx.h.rst.exceptions b/Documentation/media/dmx.h.rst.exceptions
index 8200653839d2..2fdb458564ba 100644
--- a/Documentation/media/dmx.h.rst.exceptions
+++ b/Documentation/media/dmx.h.rst.exceptions
@@ -4,29 +4,29 @@ ignore define _UAPI_DVBDMX_H_
 # Ignore limit constants
 ignore define DMX_FILTER_SIZE
 
-# dmx-pes-type-t enum symbols
-replace enum dmx_ts_pes dmx-pes-type-t
-replace symbol DMX_PES_AUDIO0 dmx-pes-type-t
-replace symbol DMX_PES_VIDEO0 dmx-pes-type-t
-replace symbol DMX_PES_TELETEXT0 dmx-pes-type-t
-replace symbol DMX_PES_SUBTITLE0 dmx-pes-type-t
-replace symbol DMX_PES_PCR0 dmx-pes-type-t
-replace symbol DMX_PES_AUDIO1 dmx-pes-type-t
-replace symbol DMX_PES_VIDEO1 dmx-pes-type-t
-replace symbol DMX_PES_TELETEXT1 dmx-pes-type-t
-replace symbol DMX_PES_SUBTITLE1 dmx-pes-type-t
-replace symbol DMX_PES_PCR1 dmx-pes-type-t
-replace symbol DMX_PES_AUDIO2 dmx-pes-type-t
-replace symbol DMX_PES_VIDEO2 dmx-pes-type-t
-replace symbol DMX_PES_TELETEXT2 dmx-pes-type-t
-replace symbol DMX_PES_SUBTITLE2 dmx-pes-type-t
-replace symbol DMX_PES_PCR2 dmx-pes-type-t
-replace symbol DMX_PES_AUDIO3 dmx-pes-type-t
-replace symbol DMX_PES_VIDEO3 dmx-pes-type-t
-replace symbol DMX_PES_TELETEXT3 dmx-pes-type-t
-replace symbol DMX_PES_SUBTITLE3 dmx-pes-type-t
-replace symbol DMX_PES_PCR3 dmx-pes-type-t
-replace symbol DMX_PES_OTHER dmx-pes-type-t
+# dmx_pes_type_t enum symbols
+replace enum dmx_ts_pes :c:type:`dmx_pes_type`
+replace symbol DMX_PES_AUDIO0 :c:type:`dmx_pes_type`
+replace symbol DMX_PES_VIDEO0 :c:type:`dmx_pes_type`
+replace symbol DMX_PES_TELETEXT0 :c:type:`dmx_pes_type`
+replace symbol DMX_PES_SUBTITLE0 :c:type:`dmx_pes_type`
+replace symbol DMX_PES_PCR0 :c:type:`dmx_pes_type`
+replace symbol DMX_PES_AUDIO1 :c:type:`dmx_pes_type`
+replace symbol DMX_PES_VIDEO1 :c:type:`dmx_pes_type`
+replace symbol DMX_PES_TELETEXT1 :c:type:`dmx_pes_type`
+replace symbol DMX_PES_SUBTITLE1 :c:type:`dmx_pes_type`
+replace symbol DMX_PES_PCR1 :c:type:`dmx_pes_type`
+replace symbol DMX_PES_AUDIO2 :c:type:`dmx_pes_type`
+replace symbol DMX_PES_VIDEO2 :c:type:`dmx_pes_type`
+replace symbol DMX_PES_TELETEXT2 :c:type:`dmx_pes_type`
+replace symbol DMX_PES_SUBTITLE2 :c:type:`dmx_pes_type`
+replace symbol DMX_PES_PCR2 :c:type:`dmx_pes_type`
+replace symbol DMX_PES_AUDIO3 :c:type:`dmx_pes_type`
+replace symbol DMX_PES_VIDEO3 :c:type:`dmx_pes_type`
+replace symbol DMX_PES_TELETEXT3 :c:type:`dmx_pes_type`
+replace symbol DMX_PES_SUBTITLE3 :c:type:`dmx_pes_type`
+replace symbol DMX_PES_PCR3 :c:type:`dmx_pes_type`
+replace symbol DMX_PES_OTHER :c:type:`dmx_pes_type`
 
 # Ignore obsolete symbols
 ignore define DMX_PES_AUDIO
@@ -36,28 +36,31 @@ ignore define DMX_PES_SUBTITLE
 ignore define DMX_PES_PCR
 
 # dmx_input_t symbols
-replace enum dmx_input dmx-input-t
-replace symbol DMX_IN_FRONTEND dmx-input-t
-replace symbol DMX_IN_DVR dmx-input-t
+replace enum dmx_input :c:type:`dmx_input`
+replace symbol DMX_IN_FRONTEND :c:type:`dmx_input`
+replace symbol DMX_IN_DVR :c:type:`dmx_input`
 
 # dmx_source_t symbols
-replace enum dmx_source dmx-source-t
-replace symbol DMX_SOURCE_FRONT0 dmx-source-t
-replace symbol DMX_SOURCE_FRONT1 dmx-source-t
-replace symbol DMX_SOURCE_FRONT2 dmx-source-t
-replace symbol DMX_SOURCE_FRONT3 dmx-source-t
-replace symbol DMX_SOURCE_DVR0 dmx-source-t
-replace symbol DMX_SOURCE_DVR1 dmx-source-t
-replace symbol DMX_SOURCE_DVR2 dmx-source-t
-replace symbol DMX_SOURCE_DVR3 dmx-source-t
+replace enum dmx_source :c:type:`dmx_source`
+replace symbol DMX_SOURCE_FRONT0 :c:type:`dmx_source`
+replace symbol DMX_SOURCE_FRONT1 :c:type:`dmx_source`
+replace symbol DMX_SOURCE_FRONT2 :c:type:`dmx_source`
+replace symbol DMX_SOURCE_FRONT3 :c:type:`dmx_source`
+replace symbol DMX_SOURCE_DVR0 :c:type:`dmx_source`
+replace symbol DMX_SOURCE_DVR1 :c:type:`dmx_source`
+replace symbol DMX_SOURCE_DVR2 :c:type:`dmx_source`
+replace symbol DMX_SOURCE_DVR3 :c:type:`dmx_source`
 
 
 # Flags for struct dmx_sct_filter_params
-replace define DMX_CHECK_CRC dmx-sct-filter-params
-replace define DMX_ONESHOT dmx-sct-filter-params
-replace define DMX_IMMEDIATE_START dmx-sct-filter-params
-replace define DMX_KERNEL_CLIENT dmx-sct-filter-params
+replace define DMX_CHECK_CRC :c:type:`dmx_sct_filter_params`
+replace define DMX_ONESHOT :c:type:`dmx_sct_filter_params`
+replace define DMX_IMMEDIATE_START :c:type:`dmx_sct_filter_params`
+replace define DMX_KERNEL_CLIENT :c:type:`dmx_sct_filter_params`
 
 # some typedefs should point to struct/enums
-replace typedef dmx_caps_t dmx-caps
-replace typedef dmx_filter_t dmx-filter
+replace typedef dmx_caps_t :c:type:`dmx_caps`
+replace typedef dmx_filter_t :c:type:`dmx_filter`
+replace typedef dmx_pes_type_t :c:type:`dmx_pes_type`
+replace typedef dmx_input_t :c:type:`dmx_input`
+replace typedef dmx_source_t :c:type:`dmx_source`
diff --git a/Documentation/media/frontend.h.rst.exceptions b/Documentation/media/frontend.h.rst.exceptions
index 60f2cbb92656..7656770f1936 100644
--- a/Documentation/media/frontend.h.rst.exceptions
+++ b/Documentation/media/frontend.h.rst.exceptions
@@ -26,22 +26,22 @@ ignore define MAX_DTV_STATS
 ignore define DTV_IOCTL_MAX_MSGS
 
 # Stats enum is documented altogether
-replace enum fecap_scale_params frontend-stat-properties
+replace enum fecap_scale_params :ref:`frontend-stat-properties`
 replace symbol FE_SCALE_COUNTER frontend-stat-properties
 replace symbol FE_SCALE_DECIBEL frontend-stat-properties
 replace symbol FE_SCALE_NOT_AVAILABLE frontend-stat-properties
 replace symbol FE_SCALE_RELATIVE frontend-stat-properties
 
 # the same reference is used for both get and set ioctls
-replace ioctl FE_SET_PROPERTY FE_GET_PROPERTY
+replace ioctl FE_SET_PROPERTY :c:type:`FE_GET_PROPERTY`
 
 # Ignore struct used only internally at Kernel
 ignore struct dtv_cmds_h
 
 # Typedefs that use the enum reference
-replace typedef fe_sec_voltage_t fe-sec-voltage
+replace typedef fe_sec_voltage_t :c:type:`fe_sec_voltage`
 
 # Replaces for flag constants
-replace define FE_TUNE_MODE_ONESHOT fe_set_frontend_tune_mode
+replace define FE_TUNE_MODE_ONESHOT :c:func:`FE_SET_FRONTEND_TUNE_MODE`
 replace define LNA_AUTO dtv-lna
 replace define NO_STREAM_ID_FILTER dtv-stream-id
diff --git a/Documentation/media/intro.rst b/Documentation/media/intro.rst
index be90bda5b3f3..f6086c159772 100644
--- a/Documentation/media/intro.rst
+++ b/Documentation/media/intro.rst
@@ -30,7 +30,7 @@ divided into five parts.
    called as DVB API, in fact it covers several different video standards
    including DVB-T/T2, DVB-S/S2, DVB-C, ATSC, ISDB-T, ISDB-S, DTMB, etc. The
    complete list of supported standards can be found at
-   :ref:`fe-delivery-system-t`.
+   :c:type:`fe_delivery_system`.
 
 3. The :ref:`third part <remote_controllers>` covers the Remote Controller API.
 
diff --git a/Documentation/media/net.h.rst.exceptions b/Documentation/media/net.h.rst.exceptions
index 30a267483aa9..afe6bef91567 100644
--- a/Documentation/media/net.h.rst.exceptions
+++ b/Documentation/media/net.h.rst.exceptions
@@ -7,5 +7,5 @@ ignore ioctl __NET_GET_IF_OLD
 ignore struct __dvb_net_if_old
 
 # Macros used at struct dvb_net_if
-replace define DVB_NET_FEEDTYPE_MPE dvb-net-if
-replace define DVB_NET_FEEDTYPE_ULE dvb-net-if
+replace define DVB_NET_FEEDTYPE_MPE :c:type:`dvb_net_if`
+replace define DVB_NET_FEEDTYPE_ULE :c:type:`dvb_net_if`
diff --git a/Documentation/media/uapi/dvb/audio-bilingual-channel-select.rst b/Documentation/media/uapi/dvb/audio-bilingual-channel-select.rst
index e048ee8f4d65..1279bd21dbd0 100644
--- a/Documentation/media/uapi/dvb/audio-bilingual-channel-select.rst
+++ b/Documentation/media/uapi/dvb/audio-bilingual-channel-select.rst
@@ -16,7 +16,7 @@ AUDIO_BILINGUAL_CHANNEL_SELECT
 Synopsis
 --------
 
-.. c:function:: int ioctl(int fd, AUDIO_BILINGUAL_CHANNEL_SELECT, audio_channel_select_t)
+.. c:function:: int ioctl(int fd, AUDIO_BILINGUAL_CHANNEL_SELECT, struct *audio_channel_select)
     :name: AUDIO_BILINGUAL_CHANNEL_SELECT
 
 
diff --git a/Documentation/media/uapi/dvb/audio-channel-select.rst b/Documentation/media/uapi/dvb/audio-channel-select.rst
index 03dcdbbfbbc6..2ceb4efebdf0 100644
--- a/Documentation/media/uapi/dvb/audio-channel-select.rst
+++ b/Documentation/media/uapi/dvb/audio-channel-select.rst
@@ -16,7 +16,7 @@ AUDIO_CHANNEL_SELECT
 Synopsis
 --------
 
-.. c:function:: int ioctl(int fd, AUDIO_CHANNEL_SELECT, audio_channel_select_t)
+.. c:function:: int ioctl(int fd, AUDIO_CHANNEL_SELECT, struct *audio_channel_select)
     :name: AUDIO_CHANNEL_SELECT
 
 
diff --git a/Documentation/media/uapi/dvb/audio-select-source.rst b/Documentation/media/uapi/dvb/audio-select-source.rst
index e4ea98787619..c0434a0bd324 100644
--- a/Documentation/media/uapi/dvb/audio-select-source.rst
+++ b/Documentation/media/uapi/dvb/audio-select-source.rst
@@ -16,7 +16,7 @@ AUDIO_SELECT_SOURCE
 Synopsis
 --------
 
-.. c:function:: int ioctl(int fd, AUDIO_SELECT_SOURCE, audio_stream_source_t source)
+.. c:function:: int ioctl(int fd, AUDIO_SELECT_SOURCE, struct audio_stream_source *source)
     :name: AUDIO_SELECT_SOURCE
 
 
diff --git a/Documentation/media/uapi/dvb/audio-set-attributes.rst b/Documentation/media/uapi/dvb/audio-set-attributes.rst
index ad89a37cf83c..f0c6153ca80f 100644
--- a/Documentation/media/uapi/dvb/audio-set-attributes.rst
+++ b/Documentation/media/uapi/dvb/audio-set-attributes.rst
@@ -17,7 +17,7 @@ AUDIO_SET_ATTRIBUTES
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, AUDIO_SET_ATTRIBUTES, audio_attributes_t attr )
+.. c:function:: int ioctl(fd, AUDIO_SET_ATTRIBUTES, struct audio_attributes *attr )
     :name: AUDIO_SET_ATTRIBUTES
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/audio-set-karaoke.rst b/Documentation/media/uapi/dvb/audio-set-karaoke.rst
index 78571abdd93a..c759952d88aa 100644
--- a/Documentation/media/uapi/dvb/audio-set-karaoke.rst
+++ b/Documentation/media/uapi/dvb/audio-set-karaoke.rst
@@ -16,7 +16,7 @@ AUDIO_SET_KARAOKE
 Synopsis
 --------
 
-.. c:function:: int ioctl(fd, AUDIO_SET_KARAOKE, audio_karaoke_t *karaoke)
+.. c:function:: int ioctl(fd, AUDIO_SET_KARAOKE, struct audio_karaoke *karaoke)
     :name: AUDIO_SET_KARAOKE
 
 
diff --git a/Documentation/media/uapi/dvb/audio-set-mixer.rst b/Documentation/media/uapi/dvb/audio-set-mixer.rst
index 657bd89b8a6a..248aab8c8909 100644
--- a/Documentation/media/uapi/dvb/audio-set-mixer.rst
+++ b/Documentation/media/uapi/dvb/audio-set-mixer.rst
@@ -16,7 +16,7 @@ AUDIO_SET_MIXER
 Synopsis
 --------
 
-.. c:function:: int ioctl(int fd, AUDIO_SET_MIXER, audio_mixer_t *mix)
+.. c:function:: int ioctl(int fd, AUDIO_SET_MIXER, struct audio_mixer *mix)
     :name: AUDIO_SET_MIXER
 
 Arguments
diff --git a/Documentation/media/uapi/dvb/audio_data_types.rst b/Documentation/media/uapi/dvb/audio_data_types.rst
index 0b14c2dfc98c..6b93359d64f7 100644
--- a/Documentation/media/uapi/dvb/audio_data_types.rst
+++ b/Documentation/media/uapi/dvb/audio_data_types.rst
@@ -9,11 +9,7 @@ Audio Data Types
 This section describes the structures, data types and defines used when
 talking to the audio device.
 
-
-.. _audio-stream-source-t:
-
-audio_stream_source_t
-=====================
+.. c:type:: audio_stream_source
 
 The audio stream source is set through the AUDIO_SELECT_SOURCE call
 and can take the following values, depending on whether we are replaying
@@ -33,10 +29,7 @@ AUDIO_SOURCE_MEMORY is selected the stream comes from the application
 through the ``write()`` system call.
 
 
-.. _audio-play-state-t:
-
-audio_play_state_t
-==================
+.. c:type:: audio_play_state
 
 The following values can be returned by the AUDIO_GET_STATUS call
 representing the state of audio playback.
@@ -51,10 +44,7 @@ representing the state of audio playback.
     } audio_play_state_t;
 
 
-.. _audio-channel-select-t:
-
-audio_channel_select_t
-======================
+.. c:type:: audio_channel_select
 
 The audio channel selected via AUDIO_CHANNEL_SELECT is determined by
 the following values.
@@ -73,9 +63,6 @@ the following values.
 
 .. c:type:: audio_status
 
-struct audio_status
-===================
-
 The AUDIO_GET_STATUS call returns the following structure informing
 about various states of the playback operation.
 
@@ -95,9 +82,6 @@ about various states of the playback operation.
 
 .. c:type:: audio_mixer
 
-struct audio_mixer
-==================
-
 The following structure is used by the AUDIO_SET_MIXER call to set the
 audio volume.
 
@@ -131,12 +115,8 @@ following bits set according to the hardwares capabilities.
      #define AUDIO_CAP_SDDS 128
      #define AUDIO_CAP_AC3  256
 
-
 .. c:type:: audio_karaoke
 
-struct audio_karaoke
-====================
-
 The ioctl AUDIO_SET_KARAOKE uses the following format:
 
 
@@ -155,10 +135,7 @@ into the left channel and Vocal2 into the right channel at 100% each. Ff
 Melody is non-zero, the melody channel gets mixed into left and right.
 
 
-.. _audio-attributes-t:
-
-audio attributes
-================
+.. c:type:: audio_attributes
 
 The following attributes can be set by a call to AUDIO_SET_ATTRIBUTES:
 
diff --git a/Documentation/media/uapi/dvb/dmx_types.rst b/Documentation/media/uapi/dvb/dmx_types.rst
index 65de705fa1ef..80dd659860d7 100644
--- a/Documentation/media/uapi/dvb/dmx_types.rst
+++ b/Documentation/media/uapi/dvb/dmx_types.rst
@@ -6,16 +6,13 @@
 Demux Data Types
 ****************
 
-
-.. _dmx-output-t:
-
 Output for the demux
 ====================
 
+.. c:type:: dmx_output
+
 .. tabularcolumns:: |p{5.0cm}|p{12.5cm}|
 
-.. _dmx-output:
-
 .. flat-table:: enum dmx_output
     :header-rows:  1
     :stub-columns: 0
@@ -66,12 +63,10 @@ Output for the demux
 	  from the DMX device.
 
 
-
-.. _dmx-input-t:
-
 dmx_input_t
 ===========
 
+.. c:type:: dmx_input
 
 .. code-block:: c
 
@@ -82,11 +77,11 @@ dmx_input_t
     } dmx_input_t;
 
 
-.. _dmx-pes-type-t:
-
 dmx_pes_type_t
 ==============
 
+.. c:type:: dmx_pes_type
+
 
 .. code-block:: c
 
@@ -120,11 +115,10 @@ dmx_pes_type_t
     } dmx_pes_type_t;
 
 
-.. c:type:: dmx_filter
-
 struct dmx_filter
 =================
 
+.. c:type:: dmx_filter
 
 .. code-block:: c
 
@@ -157,11 +151,10 @@ struct dmx_sct_filter_params
     };
 
 
-.. c:type:: dmx_pes_filter_params
-
 struct dmx_pes_filter_params
 ============================
 
+.. c:type:: dmx_pes_filter_params
 
 .. code-block:: c
 
@@ -175,11 +168,10 @@ struct dmx_pes_filter_params
     };
 
 
-.. _dmx-event:
-
 struct dmx_event
 ================
 
+.. c:type:: dmx_event
 
 .. code-block:: c
 
@@ -194,11 +186,10 @@ struct dmx_event
      };
 
 
-.. c:type:: dmx_stc
-
 struct dmx_stc
 ==============
 
+.. c:type:: dmx_stc
 
 .. code-block:: c
 
@@ -209,11 +200,10 @@ struct dmx_stc
     };
 
 
-.. c:type:: dmx_caps
-
 struct dmx_caps
 ===============
 
+.. c:type:: dmx_caps
 
 .. code-block:: c
 
@@ -223,15 +213,14 @@ struct dmx_caps
     } dmx_caps_t;
 
 
-.. _dmx-source-t:
-
-enum dmx_source_t
-=================
+enum dmx_source
+===============
 
+.. c:type:: dmx_source
 
 .. code-block:: c
 
-    typedef enum {
+    typedef enum dmx_source {
 	DMX_SOURCE_FRONT0 = 0,
 	DMX_SOURCE_FRONT1,
 	DMX_SOURCE_FRONT2,
diff --git a/Documentation/media/uapi/dvb/fe-bandwidth-t.rst b/Documentation/media/uapi/dvb/fe-bandwidth-t.rst
index 8edaf1a8fbc8..70256180e9b3 100644
--- a/Documentation/media/uapi/dvb/fe-bandwidth-t.rst
+++ b/Documentation/media/uapi/dvb/fe-bandwidth-t.rst
@@ -1,13 +1,10 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _fe-bandwidth-t:
-
 ******************
 Frontend bandwidth
 ******************
 
-
-.. _fe-bandwidth:
+.. c:type:: fe_bandwidth
 
 .. flat-table:: enum fe_bandwidth
     :header-rows:  1
diff --git a/Documentation/media/uapi/dvb/fe-diseqc-recv-slave-reply.rst b/Documentation/media/uapi/dvb/fe-diseqc-recv-slave-reply.rst
index 9fda5546d8c1..302db2857f90 100644
--- a/Documentation/media/uapi/dvb/fe-diseqc-recv-slave-reply.rst
+++ b/Documentation/media/uapi/dvb/fe-diseqc-recv-slave-reply.rst
@@ -37,9 +37,6 @@ Receives reply from a DiSEqC 2.0 command.
 
 .. c:type:: dvb_diseqc_slave_reply
 
-struct dvb_diseqc_slave_reply
------------------------------
-
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
 .. flat-table:: struct dvb_diseqc_slave_reply
diff --git a/Documentation/media/uapi/dvb/fe-diseqc-send-burst.rst b/Documentation/media/uapi/dvb/fe-diseqc-send-burst.rst
index 0e55614bc987..26272f2860bc 100644
--- a/Documentation/media/uapi/dvb/fe-diseqc-send-burst.rst
+++ b/Documentation/media/uapi/dvb/fe-diseqc-send-burst.rst
@@ -26,7 +26,7 @@ Arguments
     File descriptor returned by :ref:`open() <frontend_f_open>`.
 
 ``tone``
-    pointer to enum :ref:`fe_sec_mini_cmd <fe-sec-mini-cmd>`
+    pointer to enum :c:type:`fe_sec_mini_cmd`
 
 
 Description
@@ -39,12 +39,7 @@ read/write permissions.
 It provides support for what's specified at
 `Digital Satellite Equipment Control (DiSEqC) - Simple "ToneBurst" Detection Circuit specification. <http://www.eutelsat.com/files/contributed/satellites/pdf/Diseqc/associated%20docs/simple_tone_burst_detec.pdf>`__
 
-.. _fe-sec-mini-cmd-t:
-
-enum fe_sec_mini_cmd
-====================
-
-.. _fe-sec-mini-cmd:
+.. c:type:: fe_sec_mini_cmd
 
 .. flat-table:: enum fe_sec_mini_cmd
     :header-rows:  1
diff --git a/Documentation/media/uapi/dvb/fe-diseqc-send-master-cmd.rst b/Documentation/media/uapi/dvb/fe-diseqc-send-master-cmd.rst
index 72cb4ebd95c0..bbcab3df39b5 100644
--- a/Documentation/media/uapi/dvb/fe-diseqc-send-master-cmd.rst
+++ b/Documentation/media/uapi/dvb/fe-diseqc-send-master-cmd.rst
@@ -35,11 +35,9 @@ Description
 
 Sends a DiSEqC command to the antenna subsystem.
 
+
 .. c:type:: dvb_diseqc_master_cmd
 
-struct dvb_diseqc_master_cmd
-============================
-
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
 .. flat-table:: struct dvb_diseqc_master_cmd
diff --git a/Documentation/media/uapi/dvb/fe-get-info.rst b/Documentation/media/uapi/dvb/fe-get-info.rst
index 3557b756ef27..e3d64b251f61 100644
--- a/Documentation/media/uapi/dvb/fe-get-info.rst
+++ b/Documentation/media/uapi/dvb/fe-get-info.rst
@@ -42,9 +42,6 @@ returns an error.
 
 .. c:type:: dvb_frontend_info
 
-struct dvb_frontend_info
-========================
-
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
 .. flat-table:: struct dvb_frontend_info
@@ -137,7 +134,7 @@ struct dvb_frontend_info
 
     -  .. row 11
 
-       -  enum :ref:`fe_caps <fe-caps>`
+       -  enum :c:type:`fe_caps`
 
        -  caps
 
@@ -150,18 +147,16 @@ struct dvb_frontend_info
    systems. They're specified in kHz for Satellite systems
 
 
-.. _fe-caps-t:
-
 frontend capabilities
 =====================
 
 Capabilities describe what a frontend can do. Some capabilities are
 supported only on some specific frontend types.
 
+.. c:type:: fe_caps
+
 .. tabularcolumns:: |p{6.5cm}|p{11.0cm}|
 
-.. _fe-caps:
-
 .. flat-table:: enum fe_caps
     :header-rows:  1
     :stub-columns: 0
diff --git a/Documentation/media/uapi/dvb/fe-read-status.rst b/Documentation/media/uapi/dvb/fe-read-status.rst
index c65cec3a35c9..812f086c20f5 100644
--- a/Documentation/media/uapi/dvb/fe-read-status.rst
+++ b/Documentation/media/uapi/dvb/fe-read-status.rst
@@ -27,7 +27,7 @@ Arguments
 
 ``status``
     pointer to a bitmask integer filled with the values defined by enum
-    :ref:`fe_status <fe-status>`.
+    :c:type:`fe_status`.
 
 
 Description
@@ -45,14 +45,14 @@ written.
    future.
 
 
-.. _fe-status-t:
-
 int fe_status
 =============
 
 The fe_status parameter is used to indicate the current state and/or
 state changes of the frontend hardware. It is produced using the enum
-:ref:`fe_status <fe-status>` values on a bitmask
+:c:type:`fe_status` values on a bitmask
+
+.. c:type:: fe_status
 
 .. tabularcolumns:: |p{3.5cm}|p{14.0cm}|
 
diff --git a/Documentation/media/uapi/dvb/fe-set-tone.rst b/Documentation/media/uapi/dvb/fe-set-tone.rst
index 4cfd532d3dc5..bea193234cb4 100644
--- a/Documentation/media/uapi/dvb/fe-set-tone.rst
+++ b/Documentation/media/uapi/dvb/fe-set-tone.rst
@@ -26,7 +26,7 @@ Arguments
     File descriptor returned by :ref:`open() <frontend_f_open>`.
 
 ``tone``
-    pointer to enum :ref:`fe_sec_tone_mode <fe-sec-tone-mode>`
+    pointer to enum :c:type:`fe_sec_tone_mode`
 
 
 Description
@@ -45,12 +45,7 @@ this is done using the DiSEqC ioctls.
    capability of selecting the band. So, it is recommended that applications
    would change to SEC_TONE_OFF when the device is not used.
 
-.. _fe-sec-tone-mode-t:
-
-enum fe_sec_tone_mode
-=====================
-
-.. _fe-sec-tone-mode:
+.. c:type:: fe_sec_tone_mode
 
 .. flat-table:: enum fe_sec_tone_mode
     :header-rows:  1
diff --git a/Documentation/media/uapi/dvb/fe-set-voltage.rst b/Documentation/media/uapi/dvb/fe-set-voltage.rst
index b8b23c51ec7d..fcf6f38ef18e 100644
--- a/Documentation/media/uapi/dvb/fe-set-voltage.rst
+++ b/Documentation/media/uapi/dvb/fe-set-voltage.rst
@@ -26,10 +26,10 @@ Arguments
     File descriptor returned by :ref:`open() <frontend_f_open>`.
 
 ``voltage``
-    pointer to enum :ref:`fe_sec_voltage <fe-sec-voltage>`
+    pointer to enum :c:type:`fe_sec_voltage`
 
     Valid values are described at enum
-    :ref:`fe_sec_voltage <fe-sec-voltage>`.
+    :c:type:`fe_sec_voltage`.
 
 
 Description
diff --git a/Documentation/media/uapi/dvb/fe-type-t.rst b/Documentation/media/uapi/dvb/fe-type-t.rst
index 03a6c75bf5de..548b965188d0 100644
--- a/Documentation/media/uapi/dvb/fe-type-t.rst
+++ b/Documentation/media/uapi/dvb/fe-type-t.rst
@@ -1,7 +1,5 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _fe-type-t:
-
 *************
 Frontend type
 *************
@@ -11,7 +9,7 @@ modulation used in transmission. The fontend types are given by
 fe_type_t type, defined as:
 
 
-.. _fe-type:
+.. c:type:: fe_type
 
 .. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
 
diff --git a/Documentation/media/uapi/dvb/fe_property_parameters.rst b/Documentation/media/uapi/dvb/fe_property_parameters.rst
index 304ac1a3c2ff..7bb7559c4500 100644
--- a/Documentation/media/uapi/dvb/fe_property_parameters.rst
+++ b/Documentation/media/uapi/dvb/fe_property_parameters.rst
@@ -68,10 +68,10 @@ DTV_MODULATION
 
 Specifies the frontend modulation type for delivery systems that
 supports more than one modulation type. The modulation can be one of the
-types defined by enum :ref:`fe_modulation <fe-modulation>`.
+types defined by enum :c:type:`fe_modulation`.
 
 
-.. _fe-modulation-t:
+.. c:type:: fe_modulation
 
 Modulation property
 -------------------
@@ -82,8 +82,6 @@ enum contains the values used by the Kernel. Please note that not all
 modulations are supported by a given standard.
 
 
-.. _fe-modulation:
-
 .. flat-table:: enum fe_modulation
     :header-rows:  1
     :stub-columns: 0
@@ -251,8 +249,7 @@ DTV_INVERSION
 
 Specifies if the frontend should do spectral inversion or not.
 
-
-.. _fe-spectral-inversion-t:
+.. c:type:: fe_spectral_inversion
 
 enum fe_modulation: Frontend spectral inversion
 -----------------------------------------------
@@ -264,8 +261,6 @@ support, the DVB core will try to lock at the carrier first with
 inversion off. If it fails, it will try to enable inversion.
 
 
-.. _fe-spectral-inversion:
-
 .. flat-table:: enum fe_modulation
     :header-rows:  1
     :stub-columns: 0
@@ -327,15 +322,11 @@ DTV_INNER_FEC
 
 Used cable/satellite transmissions. The acceptable values are:
 
-
-.. _fe-code-rate-t:
+.. c:type:: fe_code_rate
 
 enum fe_code_rate: type of the Forward Error Correction.
 --------------------------------------------------------
 
-
-.. _fe-code-rate:
-
 .. flat-table:: enum fe_code_rate
     :header-rows:  1
     :stub-columns: 0
@@ -464,7 +455,7 @@ voltage has to be switched consistently to the DiSEqC commands as
 described in the DiSEqC spec.
 
 
-.. _fe-sec-voltage:
+.. c:type:: fe_sec_voltage
 
 .. flat-table:: enum fe_sec_voltage
     :header-rows:  1
@@ -519,14 +510,12 @@ DTV_PILOT
 Sets DVB-S2 pilot
 
 
-.. _fe-pilot-t:
+.. c:type:: fe_pilot
 
 fe_pilot type
 -------------
 
 
-.. _fe-pilot:
-
 .. flat-table:: enum fe_pilot
     :header-rows:  1
     :stub-columns: 0
@@ -572,14 +561,12 @@ DTV_ROLLOFF
 Sets DVB-S2 rolloff
 
 
-.. _fe-rolloff-t:
+.. c:type:: fe_rolloff
 
 fe_rolloff type
 ---------------
 
 
-.. _fe-rolloff:
-
 .. flat-table:: enum fe_rolloff
     :header-rows:  1
     :stub-columns: 0
@@ -657,7 +644,7 @@ DTV_DELIVERY_SYSTEM
 Specifies the type of Delivery system
 
 
-.. _fe-delivery-system-t:
+.. c:type:: fe_delivery_system
 
 fe_delivery_system type
 -----------------------
@@ -665,8 +652,6 @@ fe_delivery_system type
 Possible values:
 
 
-.. _fe-delivery-system:
-
 .. flat-table:: enum fe_delivery_system
     :header-rows:  1
     :stub-columns: 0
@@ -1098,7 +1083,7 @@ The values here are referring to what can be found in the
 TMCC-structure, as shown in the table below.
 
 
-.. _isdbt-layer-interleaving-table:
+.. c:type:: isdbt_layer_interleaving_table
 
 .. flat-table:: ISDB-T time interleaving modes
     :header-rows:  0
@@ -1235,7 +1220,7 @@ Possible values are:
 
 .. tabularcolumns:: |p{5.0cm}|p{12.5cm}|
 
-.. _atscmh-rs-frame-mode:
+.. c:type:: atscmh_rs_frame_mode
 
 .. flat-table:: enum atscmh_rs_frame_mode
     :header-rows:  1
@@ -1279,7 +1264,7 @@ Reed Solomon(RS) frame ensemble.
 Possible values are:
 
 
-.. _atscmh-rs-frame-ensemble:
+.. c:type:: atscmh_rs_frame_ensemble
 
 .. flat-table:: enum atscmh_rs_frame_ensemble
     :header-rows:  1
@@ -1328,7 +1313,7 @@ Reed Solomon (RS) code mode (primary).
 Possible values are:
 
 
-.. _atscmh-rs-code-mode:
+.. c:type:: atscmh_rs_code_mode
 
 .. flat-table:: enum atscmh_rs_code_mode
     :header-rows:  1
@@ -1383,7 +1368,7 @@ DTV_ATSCMH_RS_CODE_MODE_SEC
 Reed Solomon (RS) code mode (secondary).
 
 Possible values are the same as documented on enum
-:ref:`atscmh_rs_code_mode <atscmh-rs-code-mode>`:
+:c:type:`atscmh_rs_code_mode`:
 
 
 .. _DTV-ATSCMH-SCCC-BLOCK-MODE:
@@ -1397,7 +1382,7 @@ Possible values are:
 
 .. tabularcolumns:: |p{4.5cm}|p{13.0cm}|
 
-.. _atscmh-sccc-block-mode:
+.. c:type:: atscmh_sccc_block_mode
 
 .. flat-table:: enum atscmh_scc_block_mode
     :header-rows:  1
@@ -1448,7 +1433,7 @@ Series Concatenated Convolutional Code Rate.
 Possible values are:
 
 
-.. _atscmh-sccc-code-mode:
+.. c:type:: atscmh_sccc_code_mode
 
 .. flat-table:: enum atscmh_sccc_code_mode
     :header-rows:  1
@@ -1495,7 +1480,7 @@ DTV_ATSCMH_SCCC_CODE_MODE_B
 Series Concatenated Convolutional Code Rate.
 
 Possible values are the same as documented on enum
-:ref:`atscmh_sccc_code_mode <atscmh-sccc-code-mode>`.
+:c:type:`atscmh_sccc_code_mode`.
 
 
 .. _DTV-ATSCMH-SCCC-CODE-MODE-C:
@@ -1506,7 +1491,7 @@ DTV_ATSCMH_SCCC_CODE_MODE_C
 Series Concatenated Convolutional Code Rate.
 
 Possible values are the same as documented on enum
-:ref:`atscmh_sccc_code_mode <atscmh-sccc-code-mode>`.
+:c:type:`atscmh_sccc_code_mode`.
 
 
 .. _DTV-ATSCMH-SCCC-CODE-MODE-D:
@@ -1517,7 +1502,7 @@ DTV_ATSCMH_SCCC_CODE_MODE_D
 Series Concatenated Convolutional Code Rate.
 
 Possible values are the same as documented on enum
-:ref:`atscmh_sccc_code_mode <atscmh-sccc-code-mode>`.
+:c:type:`atscmh_sccc_code_mode`.
 
 
 .. _DTV-API-VERSION:
@@ -1534,7 +1519,7 @@ DTV_CODE_RATE_HP
 ================
 
 Used on terrestrial transmissions. The acceptable values are the ones
-described at :ref:`fe_transmit_mode_t <fe-transmit-mode-t>`.
+described at :c:type:`fe_transmit_mode`.
 
 
 .. _DTV-CODE-RATE-LP:
@@ -1543,7 +1528,7 @@ DTV_CODE_RATE_LP
 ================
 
 Used on terrestrial transmissions. The acceptable values are the ones
-described at :ref:`fe_transmit_mode_t <fe-transmit-mode-t>`.
+described at :c:type:`fe_transmit_mode`.
 
 
 .. _DTV-GUARD-INTERVAL:
@@ -1554,14 +1539,12 @@ DTV_GUARD_INTERVAL
 Possible values are:
 
 
-.. _fe-guard-interval-t:
+.. c:type:: fe_guard_interval
 
 Modulation guard interval
 -------------------------
 
 
-.. _fe-guard-interval:
-
 .. flat-table:: enum fe_guard_interval
     :header-rows:  1
     :stub-columns: 0
@@ -1683,15 +1666,13 @@ Specifies the number of carriers used by the standard. This is used only
 on OFTM-based standards, e. g. DVB-T/T2, ISDB-T, DTMB
 
 
-.. _fe-transmit-mode-t:
+.. c:type:: fe_transmit_mode
 
 enum fe_transmit_mode: Number of carriers per channel
 -----------------------------------------------------
 
 .. tabularcolumns:: |p{5.0cm}|p{12.5cm}|
 
-.. _fe-transmit-mode:
-
 .. flat-table:: enum fe_transmit_mode
     :header-rows:  1
     :stub-columns: 0
@@ -1801,14 +1782,12 @@ DTV_HIERARCHY
 Frontend hierarchy
 
 
-.. _fe-hierarchy-t:
+.. c:type:: fe_hierarchy
 
 Frontend hierarchy
 ------------------
 
 
-.. _fe-hierarchy:
-
 .. flat-table:: enum fe_hierarchy
     :header-rows:  1
     :stub-columns: 0
@@ -1914,7 +1893,7 @@ DTV_INTERLEAVING
 Time interleaving to be used. Currently, used only on DTMB.
 
 
-.. _fe-interleaving:
+.. c:type:: fe_interleaving
 
 .. flat-table:: enum fe_interleaving
     :header-rows:  1
diff --git a/Documentation/media/uapi/dvb/net-add-if.rst b/Documentation/media/uapi/dvb/net-add-if.rst
index dbe80c91bdb0..82ce2438213f 100644
--- a/Documentation/media/uapi/dvb/net-add-if.rst
+++ b/Documentation/media/uapi/dvb/net-add-if.rst
@@ -41,12 +41,6 @@ created.
 The struct :c:type:`dvb_net_if`::ifnum field will be
 filled with the number of the created interface.
 
-
-.. _dvb-net-if-t:
-
-struct dvb_net_if description
-=============================
-
 .. c:type:: dvb_net_if
 
 .. flat-table:: struct dvb_net_if
diff --git a/Documentation/media/video.h.rst.exceptions b/Documentation/media/video.h.rst.exceptions
index 8866145e8269..a91aa884ce0e 100644
--- a/Documentation/media/video.h.rst.exceptions
+++ b/Documentation/media/video.h.rst.exceptions
@@ -28,13 +28,13 @@ ignore define VIDEO_CAP_NAVI
 ignore define VIDEO_CAP_CSS
 
 # some typedefs should point to struct/enums
-replace typedef video_format_t video-format
-replace typedef video_system_t video-system
-replace typedef video_displayformat_t video-displayformat
-replace typedef video_size_t video-size
-replace typedef video_stream_source_t video-stream-source
-replace typedef video_play_state_t video-play-state
-replace typedef video_highlight_t video-highlight
-replace typedef video_spu_t video-spu
-replace typedef video_spu_palette_t video-spu-palette
-replace typedef video_navi_pack_t video-navi-pack
+replace typedef video_format_t :c:type:`video_format`
+replace typedef video_system_t :c:type:`video_system`
+replace typedef video_displayformat_t :c:type:`video_displayformat`
+replace typedef video_size_t :c:type:`video_size`
+replace typedef video_stream_source_t :c:type:`video_stream_source`
+replace typedef video_play_state_t :c:type:`video_play_state`
+replace typedef video_highlight_t :c:type:`video_highlight`
+replace typedef video_spu_t :c:type:`video_spu`
+replace typedef video_spu_palette_t :c:type:`video_spu_palette`
+replace typedef video_navi_pack_t :c:type:`video_navi_pack`
-- 
2.7.4


