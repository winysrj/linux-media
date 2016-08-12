Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-1.goneo.de ([85.220.129.38]:44200 "EHLO smtp3-1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022AbcHLOtU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Aug 2016 10:49:20 -0400
From: Markus Heiser <markus.heiser@darmarit.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jani Nikula <jani.nikula@intel.com>
Cc: Markus Heiser <markus.heiser@darmarIT.de>,
	Jonathan Corbet <corbet@lwn.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 3/3] doc-rst: migrated media build to parseheaders directive
Date: Fri, 12 Aug 2016 16:48:44 +0200
Message-Id: <1471013324-18914-4-git-send-email-markus.heiser@darmarit.de>
In-Reply-To: <1471013324-18914-1-git-send-email-markus.heiser@darmarit.de>
References: <1471013324-18914-1-git-send-email-markus.heiser@darmarit.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Heiser <markus.heiser@darmarIT.de>

Remove the media-Makefile and migrate the ".. kernel-include::"
directive to the new ".. parse-header::" directive.

Signed-off-by: Markus Heiser <markus.heiser@darmarIT.de>
---
 Documentation/Makefile.sphinx                      |   1 -
 Documentation/media/Makefile                       |  60 ---
 Documentation/media/audio.h.rst.exceptions         |  20 -
 Documentation/media/ca.h.rst.exceptions            |  24 -
 Documentation/media/cec.h.rst.exceptions           | 492 -------------------
 Documentation/media/dmx.h.rst.exceptions           |  63 ---
 Documentation/media/frontend.h.rst.exceptions      |  47 --
 Documentation/media/lirc.h.rst.exceptions          |  43 --
 Documentation/media/media.h.rst.exceptions         |  30 --
 Documentation/media/net.h.rst.exceptions           |  11 -
 Documentation/media/uapi/cec/cec-header.rst        |   4 +-
 Documentation/media/uapi/cec/cec.h.exceptions      | 492 +++++++++++++++++++
 Documentation/media/uapi/dvb/audio.h.exceptions    |  20 +
 Documentation/media/uapi/dvb/audio_h.rst           |   3 +-
 Documentation/media/uapi/dvb/ca.h.exceptions       |  24 +
 Documentation/media/uapi/dvb/ca_h.rst              |   3 +-
 Documentation/media/uapi/dvb/dmx.h.exceptions      |  63 +++
 Documentation/media/uapi/dvb/dmx_h.rst             |   3 +-
 Documentation/media/uapi/dvb/frontend.h.exceptions |  47 ++
 Documentation/media/uapi/dvb/frontend_h.rst        |   3 +-
 Documentation/media/uapi/dvb/net.h.exceptions      |  11 +
 Documentation/media/uapi/dvb/net_h.rst             |   3 +-
 Documentation/media/uapi/dvb/video.h.exceptions    |  40 ++
 Documentation/media/uapi/dvb/video_h.rst           |   3 +-
 Documentation/media/uapi/mediactl/media-header.rst |   4 +-
 .../media/uapi/mediactl/media.h.exceptions         |  30 ++
 Documentation/media/uapi/rc/lirc-header.rst        |   3 +-
 Documentation/media/uapi/rc/lirc.h.exceptions      |  43 ++
 Documentation/media/uapi/v4l/videodev.rst          |   3 +-
 .../media/uapi/v4l/videodev2.h.exceptions          | 535 +++++++++++++++++++++
 Documentation/media/video.h.rst.exceptions         |  40 --
 Documentation/media/videodev2.h.rst.exceptions     | 535 ---------------------
 32 files changed, 1325 insertions(+), 1378 deletions(-)
 delete mode 100644 Documentation/media/Makefile
 delete mode 100644 Documentation/media/audio.h.rst.exceptions
 delete mode 100644 Documentation/media/ca.h.rst.exceptions
 delete mode 100644 Documentation/media/cec.h.rst.exceptions
 delete mode 100644 Documentation/media/dmx.h.rst.exceptions
 delete mode 100644 Documentation/media/frontend.h.rst.exceptions
 delete mode 100644 Documentation/media/lirc.h.rst.exceptions
 delete mode 100644 Documentation/media/media.h.rst.exceptions
 delete mode 100644 Documentation/media/net.h.rst.exceptions
 create mode 100644 Documentation/media/uapi/cec/cec.h.exceptions
 create mode 100644 Documentation/media/uapi/dvb/audio.h.exceptions
 create mode 100644 Documentation/media/uapi/dvb/ca.h.exceptions
 create mode 100644 Documentation/media/uapi/dvb/dmx.h.exceptions
 create mode 100644 Documentation/media/uapi/dvb/frontend.h.exceptions
 create mode 100644 Documentation/media/uapi/dvb/net.h.exceptions
 create mode 100644 Documentation/media/uapi/dvb/video.h.exceptions
 create mode 100644 Documentation/media/uapi/mediactl/media.h.exceptions
 create mode 100644 Documentation/media/uapi/rc/lirc.h.exceptions
 create mode 100644 Documentation/media/uapi/v4l/videodev2.h.exceptions
 delete mode 100644 Documentation/media/video.h.rst.exceptions
 delete mode 100644 Documentation/media/videodev2.h.rst.exceptions

diff --git a/Documentation/Makefile.sphinx b/Documentation/Makefile.sphinx
index 857f1e2..4daec04 100644
--- a/Documentation/Makefile.sphinx
+++ b/Documentation/Makefile.sphinx
@@ -41,7 +41,6 @@ quiet_cmd_sphinx = SPHINX  $@
       cmd_sphinx = BUILDDIR=$(BUILDDIR) $(SPHINXBUILD) -b $2 $(ALLSPHINXOPTS) $(BUILDDIR)/$2
 
 htmldocs:
-	$(MAKE) BUILDDIR=$(BUILDDIR) -f $(srctree)/Documentation/media/Makefile $@
 	$(call cmd,sphinx,html)
 
 pdfdocs:
diff --git a/Documentation/media/Makefile b/Documentation/media/Makefile
deleted file mode 100644
index 39e2d76..0000000
--- a/Documentation/media/Makefile
+++ /dev/null
@@ -1,60 +0,0 @@
-# Generate the *.h.rst files from uAPI headers
-
-PARSER = $(srctree)/Documentation/sphinx/parse-headers.pl
-UAPI = $(srctree)/include/uapi/linux
-KAPI = $(srctree)/include/linux
-SRC_DIR=$(srctree)/Documentation/media
-
-FILES = audio.h.rst ca.h.rst dmx.h.rst frontend.h.rst net.h.rst video.h.rst \
-	  videodev2.h.rst media.h.rst cec.h.rst lirc.h.rst
-
-TARGETS := $(addprefix $(BUILDDIR)/, $(FILES))
-
-htmldocs: $(BUILDDIR) ${TARGETS}
-
-$(BUILDDIR):
-	$(Q)mkdir -p $@
-
-# Rule to convert a .h file to inline RST documentation
-
-gen_rst = \
-	echo ${PARSER} $< $@ $(SRC_DIR)/$(notdir $@).exceptions; \
-	${PARSER} $< $@ $(SRC_DIR)/$(notdir $@).exceptions
-
-quiet_gen_rst = echo '  PARSE   $(patsubst $(srctree)/%,%,$<)'; \
-	${PARSER} $< $@ $(SRC_DIR)/$(notdir $@).exceptions
-
-silent_gen_rst = ${gen_rst}
-
-$(BUILDDIR)/audio.h.rst: ${UAPI}/dvb/audio.h ${PARSER} $(SRC_DIR)/audio.h.rst.exceptions
-	@$($(quiet)gen_rst)
-
-$(BUILDDIR)/ca.h.rst: ${UAPI}/dvb/ca.h ${PARSER} $(SRC_DIR)/ca.h.rst.exceptions
-	@$($(quiet)gen_rst)
-
-$(BUILDDIR)/dmx.h.rst: ${UAPI}/dvb/dmx.h ${PARSER} $(SRC_DIR)/dmx.h.rst.exceptions
-	@$($(quiet)gen_rst)
-
-$(BUILDDIR)/frontend.h.rst: ${UAPI}/dvb/frontend.h ${PARSER} $(SRC_DIR)/frontend.h.rst.exceptions
-	@$($(quiet)gen_rst)
-
-$(BUILDDIR)/net.h.rst: ${UAPI}/dvb/net.h ${PARSER} $(SRC_DIR)/net.h.rst.exceptions
-	@$($(quiet)gen_rst)
-
-$(BUILDDIR)/video.h.rst: ${UAPI}/dvb/video.h ${PARSER} $(SRC_DIR)/video.h.rst.exceptions
-	@$($(quiet)gen_rst)
-
-$(BUILDDIR)/videodev2.h.rst: ${UAPI}/videodev2.h ${PARSER} $(SRC_DIR)/videodev2.h.rst.exceptions
-	@$($(quiet)gen_rst)
-
-$(BUILDDIR)/media.h.rst: ${UAPI}/media.h ${PARSER} $(SRC_DIR)/media.h.rst.exceptions
-	@$($(quiet)gen_rst)
-
-$(BUILDDIR)/cec.h.rst: ${KAPI}/cec.h ${PARSER} $(SRC_DIR)/cec.h.rst.exceptions
-	@$($(quiet)gen_rst)
-
-$(BUILDDIR)/lirc.h.rst: ${UAPI}/lirc.h ${PARSER} $(SRC_DIR)/lirc.h.rst.exceptions
-	@$($(quiet)gen_rst)
-
-cleandocs:
-	-rm ${TARGETS}
diff --git a/Documentation/media/audio.h.rst.exceptions b/Documentation/media/audio.h.rst.exceptions
deleted file mode 100644
index 8330edc..0000000
--- a/Documentation/media/audio.h.rst.exceptions
+++ /dev/null
@@ -1,20 +0,0 @@
-# Ignore header name
-ignore define _DVBAUDIO_H_
-
-# Typedef pointing to structs
-replace typedef audio_karaoke_t audio-karaoke
-
-# Undocumented audio caps, as this is a deprecated API anyway
-ignore define AUDIO_CAP_DTS
-ignore define AUDIO_CAP_LPCM
-ignore define AUDIO_CAP_MP1
-ignore define AUDIO_CAP_MP2
-ignore define AUDIO_CAP_MP3
-ignore define AUDIO_CAP_AAC
-ignore define AUDIO_CAP_OGG
-ignore define AUDIO_CAP_SDDS
-ignore define AUDIO_CAP_AC3
-
-# some typedefs should point to struct/enums
-replace typedef audio_mixer_t audio-mixer
-replace typedef audio_status_t audio-status
diff --git a/Documentation/media/ca.h.rst.exceptions b/Documentation/media/ca.h.rst.exceptions
deleted file mode 100644
index 09c13be..0000000
--- a/Documentation/media/ca.h.rst.exceptions
+++ /dev/null
@@ -1,24 +0,0 @@
-# Ignore header name
-ignore define _DVBCA_H_
-
-# struct ca_slot_info defines
-replace define CA_CI ca-slot-info
-replace define CA_CI_LINK ca-slot-info
-replace define CA_CI_PHYS ca-slot-info
-replace define CA_DESCR ca-slot-info
-replace define CA_SC ca-slot-info
-replace define CA_CI_MODULE_PRESENT ca-slot-info
-replace define CA_CI_MODULE_READY ca-slot-info
-
-# struct ca_descr_info defines
-replace define CA_ECD ca-descr-info
-replace define CA_NDS ca-descr-info
-replace define CA_DSS ca-descr-info
-
-# some typedefs should point to struct/enums
-replace typedef ca_pid_t ca-pid
-replace typedef ca_slot_info_t ca-slot-info
-replace typedef ca_descr_info_t ca-descr-info
-replace typedef ca_caps_t ca-caps
-replace typedef ca_msg_t ca-msg
-replace typedef ca_descr_t ca-descr
diff --git a/Documentation/media/cec.h.rst.exceptions b/Documentation/media/cec.h.rst.exceptions
deleted file mode 100644
index b793394..0000000
--- a/Documentation/media/cec.h.rst.exceptions
+++ /dev/null
@@ -1,492 +0,0 @@
-# Ignore header name
-ignore define _CEC_UAPI_H
-
-# Rename some symbols, to avoid namespace conflicts
-replace struct cec_event_state_change cec-event-state-change_s
-replace struct cec_event_lost_msgs cec-event-lost-msgs_s
-replace enum cec_mode_initiator cec-mode-initiator_e
-replace enum cec_mode_follower cec-mode-follower_e
-
-# define macros to ignore
-
-ignore define CEC_MAX_MSG_SIZE
-ignore define CEC_MAX_LOG_ADDRS
-
-ignore define CEC_LOG_ADDR_MASK_TV
-ignore define CEC_LOG_ADDR_MASK_RECORD
-ignore define CEC_LOG_ADDR_MASK_TUNER
-ignore define CEC_LOG_ADDR_MASK_PLAYBACK
-ignore define CEC_LOG_ADDR_MASK_AUDIOSYSTEM
-ignore define CEC_LOG_ADDR_MASK_BACKUP
-ignore define CEC_LOG_ADDR_MASK_SPECIFIC
-ignore define CEC_LOG_ADDR_MASK_UNREGISTERED
-
-# Shouldn't them be documented?
-ignore define CEC_LOG_ADDR_INVALID
-ignore define CEC_PHYS_ADDR_INVALID
-
-ignore define CEC_VENDOR_ID_NONE
-
-ignore define CEC_MODE_INITIATOR_MSK
-ignore define CEC_MODE_FOLLOWER_MSK
-
-ignore define CEC_EVENT_FL_INITIAL_STATE
-
-# Part of CEC 2.0 spec - shouldn't be documented too?
-ignore define CEC_LOG_ADDR_TV
-ignore define CEC_LOG_ADDR_RECORD_1
-ignore define CEC_LOG_ADDR_RECORD_2
-ignore define CEC_LOG_ADDR_TUNER_1
-ignore define CEC_LOG_ADDR_PLAYBACK_1
-ignore define CEC_LOG_ADDR_AUDIOSYSTEM
-ignore define CEC_LOG_ADDR_TUNER_2
-ignore define CEC_LOG_ADDR_TUNER_3
-ignore define CEC_LOG_ADDR_PLAYBACK_2
-ignore define CEC_LOG_ADDR_RECORD_3
-ignore define CEC_LOG_ADDR_TUNER_4
-ignore define CEC_LOG_ADDR_PLAYBACK_3
-ignore define CEC_LOG_ADDR_BACKUP_1
-ignore define CEC_LOG_ADDR_BACKUP_2
-ignore define CEC_LOG_ADDR_SPECIFIC
-ignore define CEC_LOG_ADDR_UNREGISTERED
-ignore define CEC_LOG_ADDR_BROADCAST
-
-# IMHO, those should also be documented
-
-ignore define CEC_MSG_ACTIVE_SOURCE
-ignore define CEC_MSG_IMAGE_VIEW_ON
-ignore define CEC_MSG_TEXT_VIEW_ON
-
-ignore define CEC_MSG_INACTIVE_SOURCE
-ignore define CEC_MSG_REQUEST_ACTIVE_SOURCE
-ignore define CEC_MSG_ROUTING_CHANGE
-ignore define CEC_MSG_ROUTING_INFORMATION
-ignore define CEC_MSG_SET_STREAM_PATH
-
-ignore define CEC_MSG_STANDBY
-
-ignore define CEC_MSG_RECORD_OFF
-ignore define CEC_MSG_RECORD_ON
-
-ignore define CEC_OP_RECORD_SRC_OWN
-ignore define CEC_OP_RECORD_SRC_DIGITAL
-ignore define CEC_OP_RECORD_SRC_ANALOG
-ignore define CEC_OP_RECORD_SRC_EXT_PLUG
-ignore define CEC_OP_RECORD_SRC_EXT_PHYS_ADDR
-
-ignore define CEC_OP_SERVICE_ID_METHOD_BY_DIG_ID
-ignore define CEC_OP_SERVICE_ID_METHOD_BY_CHANNEL
-
-ignore define CEC_OP_DIG_SERVICE_BCAST_SYSTEM_ARIB_GEN
-ignore define CEC_OP_DIG_SERVICE_BCAST_SYSTEM_ATSC_GEN
-ignore define CEC_OP_DIG_SERVICE_BCAST_SYSTEM_DVB_GEN
-ignore define CEC_OP_DIG_SERVICE_BCAST_SYSTEM_ARIB_BS
-ignore define CEC_OP_DIG_SERVICE_BCAST_SYSTEM_ARIB_CS
-ignore define CEC_OP_DIG_SERVICE_BCAST_SYSTEM_ARIB_T
-ignore define CEC_OP_DIG_SERVICE_BCAST_SYSTEM_ATSC_CABLE
-ignore define CEC_OP_DIG_SERVICE_BCAST_SYSTEM_ATSC_SAT
-ignore define CEC_OP_DIG_SERVICE_BCAST_SYSTEM_ATSC_T
-ignore define CEC_OP_DIG_SERVICE_BCAST_SYSTEM_DVB_C
-ignore define CEC_OP_DIG_SERVICE_BCAST_SYSTEM_DVB_S
-ignore define CEC_OP_DIG_SERVICE_BCAST_SYSTEM_DVB_S2
-ignore define CEC_OP_DIG_SERVICE_BCAST_SYSTEM_DVB_T
-
-ignore define CEC_OP_ANA_BCAST_TYPE_CABLE
-ignore define CEC_OP_ANA_BCAST_TYPE_SATELLITE
-ignore define CEC_OP_ANA_BCAST_TYPE_TERRESTRIAL
-
-ignore define CEC_OP_BCAST_SYSTEM_PAL_BG
-ignore define CEC_OP_BCAST_SYSTEM_SECAM_LQ
-ignore define CEC_OP_BCAST_SYSTEM_PAL_M
-ignore define CEC_OP_BCAST_SYSTEM_NTSC_M
-ignore define CEC_OP_BCAST_SYSTEM_PAL_I
-ignore define CEC_OP_BCAST_SYSTEM_SECAM_DK
-ignore define CEC_OP_BCAST_SYSTEM_SECAM_BG
-ignore define CEC_OP_BCAST_SYSTEM_SECAM_L
-ignore define CEC_OP_BCAST_SYSTEM_PAL_DK
-ignore define CEC_OP_BCAST_SYSTEM_OTHER
-
-ignore define CEC_OP_CHANNEL_NUMBER_FMT_1_PART
-ignore define CEC_OP_CHANNEL_NUMBER_FMT_2_PART
-
-ignore define CEC_MSG_RECORD_STATUS
-
-ignore define CEC_OP_RECORD_STATUS_CUR_SRC
-ignore define CEC_OP_RECORD_STATUS_DIG_SERVICE
-ignore define CEC_OP_RECORD_STATUS_ANA_SERVICE
-ignore define CEC_OP_RECORD_STATUS_EXT_INPUT
-ignore define CEC_OP_RECORD_STATUS_NO_DIG_SERVICE
-ignore define CEC_OP_RECORD_STATUS_NO_ANA_SERVICE
-ignore define CEC_OP_RECORD_STATUS_NO_SERVICE
-ignore define CEC_OP_RECORD_STATUS_INVALID_EXT_PLUG
-ignore define CEC_OP_RECORD_STATUS_INVALID_EXT_PHYS_ADDR
-ignore define CEC_OP_RECORD_STATUS_UNSUP_CA
-ignore define CEC_OP_RECORD_STATUS_NO_CA_ENTITLEMENTS
-ignore define CEC_OP_RECORD_STATUS_CANT_COPY_SRC
-ignore define CEC_OP_RECORD_STATUS_NO_MORE_COPIES
-ignore define CEC_OP_RECORD_STATUS_NO_MEDIA
-ignore define CEC_OP_RECORD_STATUS_PLAYING
-ignore define CEC_OP_RECORD_STATUS_ALREADY_RECORDING
-ignore define CEC_OP_RECORD_STATUS_MEDIA_PROT
-ignore define CEC_OP_RECORD_STATUS_NO_SIGNAL
-ignore define CEC_OP_RECORD_STATUS_MEDIA_PROBLEM
-ignore define CEC_OP_RECORD_STATUS_NO_SPACE
-ignore define CEC_OP_RECORD_STATUS_PARENTAL_LOCK
-ignore define CEC_OP_RECORD_STATUS_TERMINATED_OK
-ignore define CEC_OP_RECORD_STATUS_ALREADY_TERM
-ignore define CEC_OP_RECORD_STATUS_OTHER
-
-ignore define CEC_MSG_RECORD_TV_SCREEN
-
-ignore define CEC_MSG_CLEAR_ANALOGUE_TIMER
-
-ignore define CEC_OP_REC_SEQ_SUNDAY
-ignore define CEC_OP_REC_SEQ_MONDAY
-ignore define CEC_OP_REC_SEQ_TUESDAY
-ignore define CEC_OP_REC_SEQ_WEDNESDAY
-ignore define CEC_OP_REC_SEQ_THURSDAY
-ignore define CEC_OP_REC_SEQ_FRIDAY
-ignore define CEC_OP_REC_SEQ_SATERDAY
-ignore define CEC_OP_REC_SEQ_ONCE_ONLY
-
-ignore define CEC_MSG_CLEAR_DIGITAL_TIMER
-
-ignore define CEC_MSG_CLEAR_EXT_TIMER
-
-ignore define CEC_OP_EXT_SRC_PLUG
-ignore define CEC_OP_EXT_SRC_PHYS_ADDR
-
-ignore define CEC_MSG_SET_ANALOGUE_TIMER
-ignore define CEC_MSG_SET_DIGITAL_TIMER
-ignore define CEC_MSG_SET_EXT_TIMER
-
-ignore define CEC_MSG_SET_TIMER_PROGRAM_TITLE
-ignore define CEC_MSG_TIMER_CLEARED_STATUS
-
-ignore define CEC_OP_TIMER_CLR_STAT_RECORDING
-ignore define CEC_OP_TIMER_CLR_STAT_NO_MATCHING
-ignore define CEC_OP_TIMER_CLR_STAT_NO_INFO
-ignore define CEC_OP_TIMER_CLR_STAT_CLEARED
-
-ignore define CEC_MSG_TIMER_STATUS
-
-ignore define CEC_OP_TIMER_OVERLAP_WARNING_NO_OVERLAP
-ignore define CEC_OP_TIMER_OVERLAP_WARNING_OVERLAP
-
-ignore define CEC_OP_MEDIA_INFO_UNPROT_MEDIA
-ignore define CEC_OP_MEDIA_INFO_PROT_MEDIA
-ignore define CEC_OP_MEDIA_INFO_NO_MEDIA
-
-ignore define CEC_OP_PROG_IND_NOT_PROGRAMMED
-ignore define CEC_OP_PROG_IND_PROGRAMMED
-
-ignore define CEC_OP_PROG_INFO_ENOUGH_SPACE
-ignore define CEC_OP_PROG_INFO_NOT_ENOUGH_SPACE
-ignore define CEC_OP_PROG_INFO_MIGHT_NOT_BE_ENOUGH_SPACE
-ignore define CEC_OP_PROG_INFO_NONE_AVAILABLE
-
-ignore define CEC_OP_PROG_ERROR_NO_FREE_TIMER
-ignore define CEC_OP_PROG_ERROR_DATE_OUT_OF_RANGE
-ignore define CEC_OP_PROG_ERROR_REC_SEQ_ERROR
-ignore define CEC_OP_PROG_ERROR_INV_EXT_PLUG
-ignore define CEC_OP_PROG_ERROR_INV_EXT_PHYS_ADDR
-ignore define CEC_OP_PROG_ERROR_CA_UNSUPP
-ignore define CEC_OP_PROG_ERROR_INSUF_CA_ENTITLEMENTS
-ignore define CEC_OP_PROG_ERROR_RESOLUTION_UNSUPP
-ignore define CEC_OP_PROG_ERROR_PARENTAL_LOCK
-ignore define CEC_OP_PROG_ERROR_CLOCK_FAILURE
-ignore define CEC_OP_PROG_ERROR_DUPLICATE
-
-ignore define CEC_MSG_CEC_VERSION
-
-ignore define CEC_OP_CEC_VERSION_1_3A
-ignore define CEC_OP_CEC_VERSION_1_4
-ignore define CEC_OP_CEC_VERSION_2_0
-
-ignore define CEC_MSG_GET_CEC_VERSION
-ignore define CEC_MSG_GIVE_PHYSICAL_ADDR
-ignore define CEC_MSG_GET_MENU_LANGUAGE
-ignore define CEC_MSG_REPORT_PHYSICAL_ADDR
-
-ignore define CEC_OP_PRIM_DEVTYPE_TV
-ignore define CEC_OP_PRIM_DEVTYPE_RECORD
-ignore define CEC_OP_PRIM_DEVTYPE_TUNER
-ignore define CEC_OP_PRIM_DEVTYPE_PLAYBACK
-ignore define CEC_OP_PRIM_DEVTYPE_AUDIOSYSTEM
-ignore define CEC_OP_PRIM_DEVTYPE_SWITCH
-ignore define CEC_OP_PRIM_DEVTYPE_PROCESSOR
-
-ignore define CEC_MSG_SET_MENU_LANGUAGE
-ignore define CEC_MSG_REPORT_FEATURES
-
-ignore define CEC_OP_ALL_DEVTYPE_TV
-ignore define CEC_OP_ALL_DEVTYPE_RECORD
-ignore define CEC_OP_ALL_DEVTYPE_TUNER
-ignore define CEC_OP_ALL_DEVTYPE_PLAYBACK
-ignore define CEC_OP_ALL_DEVTYPE_AUDIOSYSTEM
-ignore define CEC_OP_ALL_DEVTYPE_SWITCH
-
-ignore define CEC_OP_FEAT_EXT
-
-ignore define CEC_OP_FEAT_RC_TV_PROFILE_NONE
-ignore define CEC_OP_FEAT_RC_TV_PROFILE_1
-ignore define CEC_OP_FEAT_RC_TV_PROFILE_2
-ignore define CEC_OP_FEAT_RC_TV_PROFILE_3
-ignore define CEC_OP_FEAT_RC_TV_PROFILE_4
-ignore define CEC_OP_FEAT_RC_SRC_HAS_DEV_ROOT_MENU
-ignore define CEC_OP_FEAT_RC_SRC_HAS_DEV_SETUP_MENU
-ignore define CEC_OP_FEAT_RC_SRC_HAS_CONTENTS_MENU
-ignore define CEC_OP_FEAT_RC_SRC_HAS_MEDIA_TOP_MENU
-ignore define CEC_OP_FEAT_RC_SRC_HAS_MEDIA_CONTEXT_MENU
-
-ignore define CEC_OP_FEAT_DEV_HAS_RECORD_TV_SCREEN
-ignore define CEC_OP_FEAT_DEV_HAS_SET_OSD_STRING
-ignore define CEC_OP_FEAT_DEV_HAS_DECK_CONTROL
-ignore define CEC_OP_FEAT_DEV_HAS_SET_AUDIO_RATE
-ignore define CEC_OP_FEAT_DEV_SINK_HAS_ARC_TX
-ignore define CEC_OP_FEAT_DEV_SOURCE_HAS_ARC_RX
-
-ignore define CEC_MSG_GIVE_FEATURES
-
-ignore define CEC_MSG_DECK_CONTROL
-
-ignore define CEC_OP_DECK_CTL_MODE_SKIP_FWD
-ignore define CEC_OP_DECK_CTL_MODE_SKIP_REV
-ignore define CEC_OP_DECK_CTL_MODE_STOP
-ignore define CEC_OP_DECK_CTL_MODE_EJECT
-
-ignore define CEC_MSG_DECK_STATUS
-
-ignore define CEC_OP_DECK_INFO_PLAY
-ignore define CEC_OP_DECK_INFO_RECORD
-ignore define CEC_OP_DECK_INFO_PLAY_REV
-ignore define CEC_OP_DECK_INFO_STILL
-ignore define CEC_OP_DECK_INFO_SLOW
-ignore define CEC_OP_DECK_INFO_SLOW_REV
-ignore define CEC_OP_DECK_INFO_FAST_FWD
-ignore define CEC_OP_DECK_INFO_FAST_REV
-ignore define CEC_OP_DECK_INFO_NO_MEDIA
-ignore define CEC_OP_DECK_INFO_STOP
-ignore define CEC_OP_DECK_INFO_SKIP_FWD
-ignore define CEC_OP_DECK_INFO_SKIP_REV
-ignore define CEC_OP_DECK_INFO_INDEX_SEARCH_FWD
-ignore define CEC_OP_DECK_INFO_INDEX_SEARCH_REV
-ignore define CEC_OP_DECK_INFO_OTHER
-
-ignore define CEC_MSG_GIVE_DECK_STATUS
-
-ignore define CEC_OP_STATUS_REQ_ON
-ignore define CEC_OP_STATUS_REQ_OFF
-ignore define CEC_OP_STATUS_REQ_ONCE
-
-ignore define CEC_MSG_PLAY
-
-ignore define CEC_OP_PLAY_MODE_PLAY_FWD
-ignore define CEC_OP_PLAY_MODE_PLAY_REV
-ignore define CEC_OP_PLAY_MODE_PLAY_STILL
-ignore define CEC_OP_PLAY_MODE_PLAY_FAST_FWD_MIN
-ignore define CEC_OP_PLAY_MODE_PLAY_FAST_FWD_MED
-ignore define CEC_OP_PLAY_MODE_PLAY_FAST_FWD_MAX
-ignore define CEC_OP_PLAY_MODE_PLAY_FAST_REV_MIN
-ignore define CEC_OP_PLAY_MODE_PLAY_FAST_REV_MED
-ignore define CEC_OP_PLAY_MODE_PLAY_FAST_REV_MAX
-ignore define CEC_OP_PLAY_MODE_PLAY_SLOW_FWD_MIN
-ignore define CEC_OP_PLAY_MODE_PLAY_SLOW_FWD_MED
-ignore define CEC_OP_PLAY_MODE_PLAY_SLOW_FWD_MAX
-ignore define CEC_OP_PLAY_MODE_PLAY_SLOW_REV_MIN
-ignore define CEC_OP_PLAY_MODE_PLAY_SLOW_REV_MED
-ignore define CEC_OP_PLAY_MODE_PLAY_SLOW_REV_MAX
-
-ignore define CEC_MSG_GIVE_TUNER_DEVICE_STATUS
-ignore define CEC_MSG_SELECT_ANALOGUE_SERVICE
-ignore define CEC_MSG_SELECT_DIGITAL_SERVICE
-ignore define CEC_MSG_TUNER_DEVICE_STATUS
-
-ignore define CEC_OP_REC_FLAG_USED
-ignore define CEC_OP_REC_FLAG_NOT_USED
-
-ignore define CEC_OP_TUNER_DISPLAY_INFO_DIGITAL
-ignore define CEC_OP_TUNER_DISPLAY_INFO_NONE
-ignore define CEC_OP_TUNER_DISPLAY_INFO_ANALOGUE
-
-ignore define CEC_MSG_TUNER_STEP_DECREMENT
-ignore define CEC_MSG_TUNER_STEP_INCREMENT
-
-ignore define CEC_MSG_DEVICE_VENDOR_ID
-ignore define CEC_MSG_GIVE_DEVICE_VENDOR_ID
-ignore define CEC_MSG_VENDOR_COMMAND
-ignore define CEC_MSG_VENDOR_COMMAND_WITH_ID
-ignore define CEC_MSG_VENDOR_REMOTE_BUTTON_DOWN
-ignore define CEC_MSG_VENDOR_REMOTE_BUTTON_UP
-
-ignore define CEC_MSG_SET_OSD_STRING
-
-ignore define CEC_OP_DISP_CTL_DEFAULT
-ignore define CEC_OP_DISP_CTL_UNTIL_CLEARED
-ignore define CEC_OP_DISP_CTL_CLEAR
-
-ignore define CEC_MSG_GIVE_OSD_NAME
-ignore define CEC_MSG_SET_OSD_NAME
-
-ignore define CEC_MSG_MENU_REQUEST
-
-ignore define CEC_OP_MENU_REQUEST_ACTIVATE
-ignore define CEC_OP_MENU_REQUEST_DEACTIVATE
-ignore define CEC_OP_MENU_REQUEST_QUERY
-
-ignore define CEC_MSG_MENU_STATUS
-
-ignore define CEC_OP_MENU_STATE_ACTIVATED
-ignore define CEC_OP_MENU_STATE_DEACTIVATED
-
-ignore define CEC_MSG_USER_CONTROL_PRESSED
-
-ignore define CEC_OP_UI_BCAST_TYPE_TOGGLE_ALL
-ignore define CEC_OP_UI_BCAST_TYPE_TOGGLE_DIG_ANA
-ignore define CEC_OP_UI_BCAST_TYPE_ANALOGUE
-ignore define CEC_OP_UI_BCAST_TYPE_ANALOGUE_T
-ignore define CEC_OP_UI_BCAST_TYPE_ANALOGUE_CABLE
-ignore define CEC_OP_UI_BCAST_TYPE_ANALOGUE_SAT
-ignore define CEC_OP_UI_BCAST_TYPE_DIGITAL
-ignore define CEC_OP_UI_BCAST_TYPE_DIGITAL_T
-ignore define CEC_OP_UI_BCAST_TYPE_DIGITAL_CABLE
-ignore define CEC_OP_UI_BCAST_TYPE_DIGITAL_SAT
-ignore define CEC_OP_UI_BCAST_TYPE_DIGITAL_COM_SAT
-ignore define CEC_OP_UI_BCAST_TYPE_DIGITAL_COM_SAT2
-ignore define CEC_OP_UI_BCAST_TYPE_IP
-
-ignore define CEC_OP_UI_SND_PRES_CTL_DUAL_MONO
-ignore define CEC_OP_UI_SND_PRES_CTL_KARAOKE
-ignore define CEC_OP_UI_SND_PRES_CTL_DOWNMIX
-ignore define CEC_OP_UI_SND_PRES_CTL_REVERB
-ignore define CEC_OP_UI_SND_PRES_CTL_EQUALIZER
-ignore define CEC_OP_UI_SND_PRES_CTL_BASS_UP
-ignore define CEC_OP_UI_SND_PRES_CTL_BASS_NEUTRAL
-ignore define CEC_OP_UI_SND_PRES_CTL_BASS_DOWN
-ignore define CEC_OP_UI_SND_PRES_CTL_TREBLE_UP
-ignore define CEC_OP_UI_SND_PRES_CTL_TREBLE_NEUTRAL
-ignore define CEC_OP_UI_SND_PRES_CTL_TREBLE_DOWN
-
-ignore define CEC_MSG_USER_CONTROL_RELEASED
-
-ignore define CEC_MSG_GIVE_DEVICE_POWER_STATUS
-ignore define CEC_MSG_REPORT_POWER_STATUS
-
-ignore define CEC_OP_POWER_STATUS_ON
-ignore define CEC_OP_POWER_STATUS_STANDBY
-ignore define CEC_OP_POWER_STATUS_TO_ON
-ignore define CEC_OP_POWER_STATUS_TO_STANDBY
-
-ignore define CEC_MSG_FEATURE_ABORT
-
-ignore define CEC_OP_ABORT_UNRECOGNIZED_OP
-ignore define CEC_OP_ABORT_INCORRECT_MODE
-ignore define CEC_OP_ABORT_NO_SOURCE
-ignore define CEC_OP_ABORT_INVALID_OP
-ignore define CEC_OP_ABORT_REFUSED
-ignore define CEC_OP_ABORT_UNDETERMINED
-
-ignore define CEC_MSG_ABORT
-
-ignore define CEC_MSG_GIVE_AUDIO_STATUS
-ignore define CEC_MSG_GIVE_SYSTEM_AUDIO_MODE_STATUS
-ignore define CEC_MSG_REPORT_AUDIO_STATUS
-
-ignore define CEC_OP_AUD_MUTE_STATUS_OFF
-ignore define CEC_OP_AUD_MUTE_STATUS_ON
-
-ignore define CEC_MSG_REPORT_SHORT_AUDIO_DESCRIPTOR
-ignore define CEC_MSG_REQUEST_SHORT_AUDIO_DESCRIPTOR
-ignore define CEC_MSG_SET_SYSTEM_AUDIO_MODE
-
-ignore define CEC_OP_SYS_AUD_STATUS_OFF
-ignore define CEC_OP_SYS_AUD_STATUS_ON
-
-ignore define CEC_MSG_SYSTEM_AUDIO_MODE_REQUEST
-ignore define CEC_MSG_SYSTEM_AUDIO_MODE_STATUS
-
-ignore define CEC_OP_AUD_FMT_ID_CEA861
-ignore define CEC_OP_AUD_FMT_ID_CEA861_CXT
-
-ignore define CEC_MSG_SET_AUDIO_RATE
-
-ignore define CEC_OP_AUD_RATE_OFF
-ignore define CEC_OP_AUD_RATE_WIDE_STD
-ignore define CEC_OP_AUD_RATE_WIDE_FAST
-ignore define CEC_OP_AUD_RATE_WIDE_SLOW
-ignore define CEC_OP_AUD_RATE_NARROW_STD
-ignore define CEC_OP_AUD_RATE_NARROW_FAST
-ignore define CEC_OP_AUD_RATE_NARROW_SLOW
-
-ignore define CEC_MSG_INITIATE_ARC
-ignore define CEC_MSG_REPORT_ARC_INITIATED
-ignore define CEC_MSG_REPORT_ARC_TERMINATED
-ignore define CEC_MSG_REQUEST_ARC_INITIATION
-ignore define CEC_MSG_REQUEST_ARC_TERMINATION
-ignore define CEC_MSG_TERMINATE_ARC
-
-ignore define CEC_MSG_REQUEST_CURRENT_LATENCY
-ignore define CEC_MSG_REPORT_CURRENT_LATENCY
-
-ignore define CEC_OP_LOW_LATENCY_MODE_OFF
-ignore define CEC_OP_LOW_LATENCY_MODE_ON
-
-ignore define CEC_OP_AUD_OUT_COMPENSATED_NA
-ignore define CEC_OP_AUD_OUT_COMPENSATED_DELAY
-ignore define CEC_OP_AUD_OUT_COMPENSATED_NO_DELAY
-ignore define CEC_OP_AUD_OUT_COMPENSATED_PARTIAL_DELAY
-
-ignore define CEC_MSG_CDC_MESSAGE
-
-ignore define CEC_MSG_CDC_HEC_INQUIRE_STATE
-ignore define CEC_MSG_CDC_HEC_REPORT_STATE
-
-ignore define CEC_OP_HEC_FUNC_STATE_NOT_SUPPORTED
-ignore define CEC_OP_HEC_FUNC_STATE_INACTIVE
-ignore define CEC_OP_HEC_FUNC_STATE_ACTIVE
-ignore define CEC_OP_HEC_FUNC_STATE_ACTIVATION_FIELD
-
-ignore define CEC_OP_HOST_FUNC_STATE_NOT_SUPPORTED
-ignore define CEC_OP_HOST_FUNC_STATE_INACTIVE
-ignore define CEC_OP_HOST_FUNC_STATE_ACTIVE
-
-ignore define CEC_OP_ENC_FUNC_STATE_EXT_CON_NOT_SUPPORTED
-ignore define CEC_OP_ENC_FUNC_STATE_EXT_CON_INACTIVE
-ignore define CEC_OP_ENC_FUNC_STATE_EXT_CON_ACTIVE
-
-ignore define CEC_OP_CDC_ERROR_CODE_NONE
-ignore define CEC_OP_CDC_ERROR_CODE_CAP_UNSUPPORTED
-ignore define CEC_OP_CDC_ERROR_CODE_WRONG_STATE
-ignore define CEC_OP_CDC_ERROR_CODE_OTHER
-
-ignore define CEC_OP_HEC_SUPPORT_NO
-ignore define CEC_OP_HEC_SUPPORT_YES
-
-ignore define CEC_OP_HEC_ACTIVATION_ON
-ignore define CEC_OP_HEC_ACTIVATION_OFF
-
-ignore define CEC_MSG_CDC_HEC_SET_STATE_ADJACENT
-ignore define CEC_MSG_CDC_HEC_SET_STATE
-
-ignore define CEC_OP_HEC_SET_STATE_DEACTIVATE
-ignore define CEC_OP_HEC_SET_STATE_ACTIVATE
-
-ignore define CEC_MSG_CDC_HEC_REQUEST_DEACTIVATION
-ignore define CEC_MSG_CDC_HEC_NOTIFY_ALIVE
-ignore define CEC_MSG_CDC_HEC_DISCOVER
-
-ignore define CEC_MSG_CDC_HPD_SET_STATE
-
-ignore define CEC_OP_HPD_STATE_CP_EDID_DISABLE
-ignore define CEC_OP_HPD_STATE_CP_EDID_ENABLE
-ignore define CEC_OP_HPD_STATE_CP_EDID_DISABLE_ENABLE
-ignore define CEC_OP_HPD_STATE_EDID_DISABLE
-ignore define CEC_OP_HPD_STATE_EDID_ENABLE
-ignore define CEC_OP_HPD_STATE_EDID_DISABLE_ENABLE
-ignore define CEC_MSG_CDC_HPD_REPORT_STATE
-
-ignore define CEC_OP_HPD_ERROR_NONE
-ignore define CEC_OP_HPD_ERROR_INITIATOR_NOT_CAPABLE
-ignore define CEC_OP_HPD_ERROR_INITIATOR_WRONG_STATE
-ignore define CEC_OP_HPD_ERROR_OTHER
-ignore define CEC_OP_HPD_ERROR_NONE_NO_VIDEO
diff --git a/Documentation/media/dmx.h.rst.exceptions b/Documentation/media/dmx.h.rst.exceptions
deleted file mode 100644
index 8200653..0000000
--- a/Documentation/media/dmx.h.rst.exceptions
+++ /dev/null
@@ -1,63 +0,0 @@
-# Ignore header name
-ignore define _UAPI_DVBDMX_H_
-
-# Ignore limit constants
-ignore define DMX_FILTER_SIZE
-
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
-
-# Ignore obsolete symbols
-ignore define DMX_PES_AUDIO
-ignore define DMX_PES_VIDEO
-ignore define DMX_PES_TELETEXT
-ignore define DMX_PES_SUBTITLE
-ignore define DMX_PES_PCR
-
-# dmx_input_t symbols
-replace enum dmx_input dmx-input-t
-replace symbol DMX_IN_FRONTEND dmx-input-t
-replace symbol DMX_IN_DVR dmx-input-t
-
-# dmx_source_t symbols
-replace enum dmx_source dmx-source-t
-replace symbol DMX_SOURCE_FRONT0 dmx-source-t
-replace symbol DMX_SOURCE_FRONT1 dmx-source-t
-replace symbol DMX_SOURCE_FRONT2 dmx-source-t
-replace symbol DMX_SOURCE_FRONT3 dmx-source-t
-replace symbol DMX_SOURCE_DVR0 dmx-source-t
-replace symbol DMX_SOURCE_DVR1 dmx-source-t
-replace symbol DMX_SOURCE_DVR2 dmx-source-t
-replace symbol DMX_SOURCE_DVR3 dmx-source-t
-
-
-# Flags for struct dmx_sct_filter_params
-replace define DMX_CHECK_CRC dmx-sct-filter-params
-replace define DMX_ONESHOT dmx-sct-filter-params
-replace define DMX_IMMEDIATE_START dmx-sct-filter-params
-replace define DMX_KERNEL_CLIENT dmx-sct-filter-params
-
-# some typedefs should point to struct/enums
-replace typedef dmx_caps_t dmx-caps
-replace typedef dmx_filter_t dmx-filter
diff --git a/Documentation/media/frontend.h.rst.exceptions b/Documentation/media/frontend.h.rst.exceptions
deleted file mode 100644
index 60f2cbb..0000000
--- a/Documentation/media/frontend.h.rst.exceptions
+++ /dev/null
@@ -1,47 +0,0 @@
-# Ignore header name
-ignore define _DVBFRONTEND_H_
-
-# Group layer A-C symbols together
-replace define DTV_ISDBT_LAYERA_FEC dtv-isdbt-layer-fec
-replace define DTV_ISDBT_LAYERB_FEC dtv-isdbt-layer-fec
-replace define DTV_ISDBT_LAYERC_FEC dtv-isdbt-layer-fec
-replace define DTV_ISDBT_LAYERA_MODULATION dtv-isdbt-layer-modulation
-replace define DTV_ISDBT_LAYERB_MODULATION dtv-isdbt-layer-modulation
-replace define DTV_ISDBT_LAYERC_MODULATION dtv-isdbt-layer-modulation
-replace define DTV_ISDBT_LAYERA_SEGMENT_COUNT dtv-isdbt-layer-segment-count
-replace define DTV_ISDBT_LAYERB_SEGMENT_COUNT dtv-isdbt-layer-segment-count
-replace define DTV_ISDBT_LAYERC_SEGMENT_COUNT dtv-isdbt-layer-segment-count
-replace define DTV_ISDBT_LAYERA_TIME_INTERLEAVING dtv-isdbt-layer-time-interleaving
-replace define DTV_ISDBT_LAYERB_TIME_INTERLEAVING dtv-isdbt-layer-time-interleaving
-replace define DTV_ISDBT_LAYERC_TIME_INTERLEAVING dtv-isdbt-layer-time-interleaving
-
-# Ignore legacy defines
-ignore define DTV_ISDBS_TS_ID_LEGACY
-ignore define SYS_DVBC_ANNEX_AC
-ignore define SYS_DMBTH
-
-# Ignore limits
-ignore define DTV_MAX_COMMAND
-ignore define MAX_DTV_STATS
-ignore define DTV_IOCTL_MAX_MSGS
-
-# Stats enum is documented altogether
-replace enum fecap_scale_params frontend-stat-properties
-replace symbol FE_SCALE_COUNTER frontend-stat-properties
-replace symbol FE_SCALE_DECIBEL frontend-stat-properties
-replace symbol FE_SCALE_NOT_AVAILABLE frontend-stat-properties
-replace symbol FE_SCALE_RELATIVE frontend-stat-properties
-
-# the same reference is used for both get and set ioctls
-replace ioctl FE_SET_PROPERTY FE_GET_PROPERTY
-
-# Ignore struct used only internally at Kernel
-ignore struct dtv_cmds_h
-
-# Typedefs that use the enum reference
-replace typedef fe_sec_voltage_t fe-sec-voltage
-
-# Replaces for flag constants
-replace define FE_TUNE_MODE_ONESHOT fe_set_frontend_tune_mode
-replace define LNA_AUTO dtv-lna
-replace define NO_STREAM_ID_FILTER dtv-stream-id
diff --git a/Documentation/media/lirc.h.rst.exceptions b/Documentation/media/lirc.h.rst.exceptions
deleted file mode 100644
index 246c850..0000000
--- a/Documentation/media/lirc.h.rst.exceptions
+++ /dev/null
@@ -1,43 +0,0 @@
-# Ignore header name
-ignore define _LINUX_LIRC_H
-
-# Ignore helper macros
-
-ignore define lirc_t
-
-ignore define LIRC_SPACE
-ignore define LIRC_PULSE
-ignore define LIRC_FREQUENCY
-ignore define LIRC_TIMEOUT
-ignore define LIRC_VALUE
-ignore define LIRC_MODE2
-ignore define LIRC_IS_SPACE
-ignore define LIRC_IS_PULSE
-ignore define LIRC_IS_FREQUENCY
-ignore define LIRC_IS_TIMEOUT
-
-ignore define LIRC_MODE2SEND
-ignore define LIRC_SEND2MODE
-ignore define LIRC_MODE2REC
-ignore define LIRC_REC2MODE
-
-ignore define LIRC_CAN_SEND
-ignore define LIRC_CAN_REC
-
-ignore define LIRC_CAN_SEND_MASK
-ignore define LIRC_CAN_REC_MASK
-ignore define LIRC_CAN_SET_REC_DUTY_CYCLE
-
-# Undocumented macros
-
-ignore define PULSE_BIT
-ignore define PULSE_MASK
-
-ignore define LIRC_MODE2_SPACE
-ignore define LIRC_MODE2_PULSE
-ignore define LIRC_MODE2_TIMEOUT
-
-ignore define LIRC_VALUE_MASK
-ignore define LIRC_MODE2_MASK
-
-ignore define LIRC_MODE_RAW
diff --git a/Documentation/media/media.h.rst.exceptions b/Documentation/media/media.h.rst.exceptions
deleted file mode 100644
index 83d7f7c..0000000
--- a/Documentation/media/media.h.rst.exceptions
+++ /dev/null
@@ -1,30 +0,0 @@
-# Ignore header name
-ignore define __LINUX_MEDIA_H
-
-# Ignore macros
-ignore define MEDIA_API_VERSION
-ignore define MEDIA_ENT_F_BASE
-ignore define MEDIA_ENT_F_OLD_BASE
-ignore define MEDIA_ENT_F_OLD_SUBDEV_BASE
-ignore define MEDIA_INTF_T_DVB_BASE
-ignore define MEDIA_INTF_T_V4L_BASE
-ignore define MEDIA_INTF_T_ALSA_BASE
-
-#ignore legacy entity type macros
-ignore define MEDIA_ENT_TYPE_SHIFT
-ignore define MEDIA_ENT_TYPE_MASK
-ignore define MEDIA_ENT_SUBTYPE_MASK
-ignore define MEDIA_ENT_T_DEVNODE_UNKNOWN
-ignore define MEDIA_ENT_T_DEVNODE
-ignore define MEDIA_ENT_T_DEVNODE_V4L
-ignore define MEDIA_ENT_T_DEVNODE_FB
-ignore define MEDIA_ENT_T_DEVNODE_ALSA
-ignore define MEDIA_ENT_T_DEVNODE_DVB
-ignore define MEDIA_ENT_T_UNKNOWN
-ignore define MEDIA_ENT_T_V4L2_VIDEO
-ignore define MEDIA_ENT_T_V4L2_SUBDEV
-ignore define MEDIA_ENT_T_V4L2_SUBDEV_SENSOR
-ignore define MEDIA_ENT_T_V4L2_SUBDEV_FLASH
-ignore define MEDIA_ENT_T_V4L2_SUBDEV_LENS
-ignore define MEDIA_ENT_T_V4L2_SUBDEV_DECODER
-ignore define MEDIA_ENT_T_V4L2_SUBDEV_TUNER
diff --git a/Documentation/media/net.h.rst.exceptions b/Documentation/media/net.h.rst.exceptions
deleted file mode 100644
index 30a2674..0000000
--- a/Documentation/media/net.h.rst.exceptions
+++ /dev/null
@@ -1,11 +0,0 @@
-# Ignore header name
-ignore define _DVBNET_H_
-
-# Ignore old ioctls/structs
-ignore ioctl __NET_ADD_IF_OLD
-ignore ioctl __NET_GET_IF_OLD
-ignore struct __dvb_net_if_old
-
-# Macros used at struct dvb_net_if
-replace define DVB_NET_FEEDTYPE_MPE dvb-net-if
-replace define DVB_NET_FEEDTYPE_ULE dvb-net-if
diff --git a/Documentation/media/uapi/cec/cec-header.rst b/Documentation/media/uapi/cec/cec-header.rst
index d5a9a28..0f7104f 100644
--- a/Documentation/media/uapi/cec/cec-header.rst
+++ b/Documentation/media/uapi/cec/cec-header.rst
@@ -6,5 +6,5 @@
 CEC Header File
 ***************
 
-.. kernel-include:: $BUILDDIR/cec.h.rst
-
+.. parse-header:: include/linux/cec.h
+   :exceptions: cec.h.exceptions
diff --git a/Documentation/media/uapi/cec/cec.h.exceptions b/Documentation/media/uapi/cec/cec.h.exceptions
new file mode 100644
index 0000000..b793394
--- /dev/null
+++ b/Documentation/media/uapi/cec/cec.h.exceptions
@@ -0,0 +1,492 @@
+# Ignore header name
+ignore define _CEC_UAPI_H
+
+# Rename some symbols, to avoid namespace conflicts
+replace struct cec_event_state_change cec-event-state-change_s
+replace struct cec_event_lost_msgs cec-event-lost-msgs_s
+replace enum cec_mode_initiator cec-mode-initiator_e
+replace enum cec_mode_follower cec-mode-follower_e
+
+# define macros to ignore
+
+ignore define CEC_MAX_MSG_SIZE
+ignore define CEC_MAX_LOG_ADDRS
+
+ignore define CEC_LOG_ADDR_MASK_TV
+ignore define CEC_LOG_ADDR_MASK_RECORD
+ignore define CEC_LOG_ADDR_MASK_TUNER
+ignore define CEC_LOG_ADDR_MASK_PLAYBACK
+ignore define CEC_LOG_ADDR_MASK_AUDIOSYSTEM
+ignore define CEC_LOG_ADDR_MASK_BACKUP
+ignore define CEC_LOG_ADDR_MASK_SPECIFIC
+ignore define CEC_LOG_ADDR_MASK_UNREGISTERED
+
+# Shouldn't them be documented?
+ignore define CEC_LOG_ADDR_INVALID
+ignore define CEC_PHYS_ADDR_INVALID
+
+ignore define CEC_VENDOR_ID_NONE
+
+ignore define CEC_MODE_INITIATOR_MSK
+ignore define CEC_MODE_FOLLOWER_MSK
+
+ignore define CEC_EVENT_FL_INITIAL_STATE
+
+# Part of CEC 2.0 spec - shouldn't be documented too?
+ignore define CEC_LOG_ADDR_TV
+ignore define CEC_LOG_ADDR_RECORD_1
+ignore define CEC_LOG_ADDR_RECORD_2
+ignore define CEC_LOG_ADDR_TUNER_1
+ignore define CEC_LOG_ADDR_PLAYBACK_1
+ignore define CEC_LOG_ADDR_AUDIOSYSTEM
+ignore define CEC_LOG_ADDR_TUNER_2
+ignore define CEC_LOG_ADDR_TUNER_3
+ignore define CEC_LOG_ADDR_PLAYBACK_2
+ignore define CEC_LOG_ADDR_RECORD_3
+ignore define CEC_LOG_ADDR_TUNER_4
+ignore define CEC_LOG_ADDR_PLAYBACK_3
+ignore define CEC_LOG_ADDR_BACKUP_1
+ignore define CEC_LOG_ADDR_BACKUP_2
+ignore define CEC_LOG_ADDR_SPECIFIC
+ignore define CEC_LOG_ADDR_UNREGISTERED
+ignore define CEC_LOG_ADDR_BROADCAST
+
+# IMHO, those should also be documented
+
+ignore define CEC_MSG_ACTIVE_SOURCE
+ignore define CEC_MSG_IMAGE_VIEW_ON
+ignore define CEC_MSG_TEXT_VIEW_ON
+
+ignore define CEC_MSG_INACTIVE_SOURCE
+ignore define CEC_MSG_REQUEST_ACTIVE_SOURCE
+ignore define CEC_MSG_ROUTING_CHANGE
+ignore define CEC_MSG_ROUTING_INFORMATION
+ignore define CEC_MSG_SET_STREAM_PATH
+
+ignore define CEC_MSG_STANDBY
+
+ignore define CEC_MSG_RECORD_OFF
+ignore define CEC_MSG_RECORD_ON
+
+ignore define CEC_OP_RECORD_SRC_OWN
+ignore define CEC_OP_RECORD_SRC_DIGITAL
+ignore define CEC_OP_RECORD_SRC_ANALOG
+ignore define CEC_OP_RECORD_SRC_EXT_PLUG
+ignore define CEC_OP_RECORD_SRC_EXT_PHYS_ADDR
+
+ignore define CEC_OP_SERVICE_ID_METHOD_BY_DIG_ID
+ignore define CEC_OP_SERVICE_ID_METHOD_BY_CHANNEL
+
+ignore define CEC_OP_DIG_SERVICE_BCAST_SYSTEM_ARIB_GEN
+ignore define CEC_OP_DIG_SERVICE_BCAST_SYSTEM_ATSC_GEN
+ignore define CEC_OP_DIG_SERVICE_BCAST_SYSTEM_DVB_GEN
+ignore define CEC_OP_DIG_SERVICE_BCAST_SYSTEM_ARIB_BS
+ignore define CEC_OP_DIG_SERVICE_BCAST_SYSTEM_ARIB_CS
+ignore define CEC_OP_DIG_SERVICE_BCAST_SYSTEM_ARIB_T
+ignore define CEC_OP_DIG_SERVICE_BCAST_SYSTEM_ATSC_CABLE
+ignore define CEC_OP_DIG_SERVICE_BCAST_SYSTEM_ATSC_SAT
+ignore define CEC_OP_DIG_SERVICE_BCAST_SYSTEM_ATSC_T
+ignore define CEC_OP_DIG_SERVICE_BCAST_SYSTEM_DVB_C
+ignore define CEC_OP_DIG_SERVICE_BCAST_SYSTEM_DVB_S
+ignore define CEC_OP_DIG_SERVICE_BCAST_SYSTEM_DVB_S2
+ignore define CEC_OP_DIG_SERVICE_BCAST_SYSTEM_DVB_T
+
+ignore define CEC_OP_ANA_BCAST_TYPE_CABLE
+ignore define CEC_OP_ANA_BCAST_TYPE_SATELLITE
+ignore define CEC_OP_ANA_BCAST_TYPE_TERRESTRIAL
+
+ignore define CEC_OP_BCAST_SYSTEM_PAL_BG
+ignore define CEC_OP_BCAST_SYSTEM_SECAM_LQ
+ignore define CEC_OP_BCAST_SYSTEM_PAL_M
+ignore define CEC_OP_BCAST_SYSTEM_NTSC_M
+ignore define CEC_OP_BCAST_SYSTEM_PAL_I
+ignore define CEC_OP_BCAST_SYSTEM_SECAM_DK
+ignore define CEC_OP_BCAST_SYSTEM_SECAM_BG
+ignore define CEC_OP_BCAST_SYSTEM_SECAM_L
+ignore define CEC_OP_BCAST_SYSTEM_PAL_DK
+ignore define CEC_OP_BCAST_SYSTEM_OTHER
+
+ignore define CEC_OP_CHANNEL_NUMBER_FMT_1_PART
+ignore define CEC_OP_CHANNEL_NUMBER_FMT_2_PART
+
+ignore define CEC_MSG_RECORD_STATUS
+
+ignore define CEC_OP_RECORD_STATUS_CUR_SRC
+ignore define CEC_OP_RECORD_STATUS_DIG_SERVICE
+ignore define CEC_OP_RECORD_STATUS_ANA_SERVICE
+ignore define CEC_OP_RECORD_STATUS_EXT_INPUT
+ignore define CEC_OP_RECORD_STATUS_NO_DIG_SERVICE
+ignore define CEC_OP_RECORD_STATUS_NO_ANA_SERVICE
+ignore define CEC_OP_RECORD_STATUS_NO_SERVICE
+ignore define CEC_OP_RECORD_STATUS_INVALID_EXT_PLUG
+ignore define CEC_OP_RECORD_STATUS_INVALID_EXT_PHYS_ADDR
+ignore define CEC_OP_RECORD_STATUS_UNSUP_CA
+ignore define CEC_OP_RECORD_STATUS_NO_CA_ENTITLEMENTS
+ignore define CEC_OP_RECORD_STATUS_CANT_COPY_SRC
+ignore define CEC_OP_RECORD_STATUS_NO_MORE_COPIES
+ignore define CEC_OP_RECORD_STATUS_NO_MEDIA
+ignore define CEC_OP_RECORD_STATUS_PLAYING
+ignore define CEC_OP_RECORD_STATUS_ALREADY_RECORDING
+ignore define CEC_OP_RECORD_STATUS_MEDIA_PROT
+ignore define CEC_OP_RECORD_STATUS_NO_SIGNAL
+ignore define CEC_OP_RECORD_STATUS_MEDIA_PROBLEM
+ignore define CEC_OP_RECORD_STATUS_NO_SPACE
+ignore define CEC_OP_RECORD_STATUS_PARENTAL_LOCK
+ignore define CEC_OP_RECORD_STATUS_TERMINATED_OK
+ignore define CEC_OP_RECORD_STATUS_ALREADY_TERM
+ignore define CEC_OP_RECORD_STATUS_OTHER
+
+ignore define CEC_MSG_RECORD_TV_SCREEN
+
+ignore define CEC_MSG_CLEAR_ANALOGUE_TIMER
+
+ignore define CEC_OP_REC_SEQ_SUNDAY
+ignore define CEC_OP_REC_SEQ_MONDAY
+ignore define CEC_OP_REC_SEQ_TUESDAY
+ignore define CEC_OP_REC_SEQ_WEDNESDAY
+ignore define CEC_OP_REC_SEQ_THURSDAY
+ignore define CEC_OP_REC_SEQ_FRIDAY
+ignore define CEC_OP_REC_SEQ_SATERDAY
+ignore define CEC_OP_REC_SEQ_ONCE_ONLY
+
+ignore define CEC_MSG_CLEAR_DIGITAL_TIMER
+
+ignore define CEC_MSG_CLEAR_EXT_TIMER
+
+ignore define CEC_OP_EXT_SRC_PLUG
+ignore define CEC_OP_EXT_SRC_PHYS_ADDR
+
+ignore define CEC_MSG_SET_ANALOGUE_TIMER
+ignore define CEC_MSG_SET_DIGITAL_TIMER
+ignore define CEC_MSG_SET_EXT_TIMER
+
+ignore define CEC_MSG_SET_TIMER_PROGRAM_TITLE
+ignore define CEC_MSG_TIMER_CLEARED_STATUS
+
+ignore define CEC_OP_TIMER_CLR_STAT_RECORDING
+ignore define CEC_OP_TIMER_CLR_STAT_NO_MATCHING
+ignore define CEC_OP_TIMER_CLR_STAT_NO_INFO
+ignore define CEC_OP_TIMER_CLR_STAT_CLEARED
+
+ignore define CEC_MSG_TIMER_STATUS
+
+ignore define CEC_OP_TIMER_OVERLAP_WARNING_NO_OVERLAP
+ignore define CEC_OP_TIMER_OVERLAP_WARNING_OVERLAP
+
+ignore define CEC_OP_MEDIA_INFO_UNPROT_MEDIA
+ignore define CEC_OP_MEDIA_INFO_PROT_MEDIA
+ignore define CEC_OP_MEDIA_INFO_NO_MEDIA
+
+ignore define CEC_OP_PROG_IND_NOT_PROGRAMMED
+ignore define CEC_OP_PROG_IND_PROGRAMMED
+
+ignore define CEC_OP_PROG_INFO_ENOUGH_SPACE
+ignore define CEC_OP_PROG_INFO_NOT_ENOUGH_SPACE
+ignore define CEC_OP_PROG_INFO_MIGHT_NOT_BE_ENOUGH_SPACE
+ignore define CEC_OP_PROG_INFO_NONE_AVAILABLE
+
+ignore define CEC_OP_PROG_ERROR_NO_FREE_TIMER
+ignore define CEC_OP_PROG_ERROR_DATE_OUT_OF_RANGE
+ignore define CEC_OP_PROG_ERROR_REC_SEQ_ERROR
+ignore define CEC_OP_PROG_ERROR_INV_EXT_PLUG
+ignore define CEC_OP_PROG_ERROR_INV_EXT_PHYS_ADDR
+ignore define CEC_OP_PROG_ERROR_CA_UNSUPP
+ignore define CEC_OP_PROG_ERROR_INSUF_CA_ENTITLEMENTS
+ignore define CEC_OP_PROG_ERROR_RESOLUTION_UNSUPP
+ignore define CEC_OP_PROG_ERROR_PARENTAL_LOCK
+ignore define CEC_OP_PROG_ERROR_CLOCK_FAILURE
+ignore define CEC_OP_PROG_ERROR_DUPLICATE
+
+ignore define CEC_MSG_CEC_VERSION
+
+ignore define CEC_OP_CEC_VERSION_1_3A
+ignore define CEC_OP_CEC_VERSION_1_4
+ignore define CEC_OP_CEC_VERSION_2_0
+
+ignore define CEC_MSG_GET_CEC_VERSION
+ignore define CEC_MSG_GIVE_PHYSICAL_ADDR
+ignore define CEC_MSG_GET_MENU_LANGUAGE
+ignore define CEC_MSG_REPORT_PHYSICAL_ADDR
+
+ignore define CEC_OP_PRIM_DEVTYPE_TV
+ignore define CEC_OP_PRIM_DEVTYPE_RECORD
+ignore define CEC_OP_PRIM_DEVTYPE_TUNER
+ignore define CEC_OP_PRIM_DEVTYPE_PLAYBACK
+ignore define CEC_OP_PRIM_DEVTYPE_AUDIOSYSTEM
+ignore define CEC_OP_PRIM_DEVTYPE_SWITCH
+ignore define CEC_OP_PRIM_DEVTYPE_PROCESSOR
+
+ignore define CEC_MSG_SET_MENU_LANGUAGE
+ignore define CEC_MSG_REPORT_FEATURES
+
+ignore define CEC_OP_ALL_DEVTYPE_TV
+ignore define CEC_OP_ALL_DEVTYPE_RECORD
+ignore define CEC_OP_ALL_DEVTYPE_TUNER
+ignore define CEC_OP_ALL_DEVTYPE_PLAYBACK
+ignore define CEC_OP_ALL_DEVTYPE_AUDIOSYSTEM
+ignore define CEC_OP_ALL_DEVTYPE_SWITCH
+
+ignore define CEC_OP_FEAT_EXT
+
+ignore define CEC_OP_FEAT_RC_TV_PROFILE_NONE
+ignore define CEC_OP_FEAT_RC_TV_PROFILE_1
+ignore define CEC_OP_FEAT_RC_TV_PROFILE_2
+ignore define CEC_OP_FEAT_RC_TV_PROFILE_3
+ignore define CEC_OP_FEAT_RC_TV_PROFILE_4
+ignore define CEC_OP_FEAT_RC_SRC_HAS_DEV_ROOT_MENU
+ignore define CEC_OP_FEAT_RC_SRC_HAS_DEV_SETUP_MENU
+ignore define CEC_OP_FEAT_RC_SRC_HAS_CONTENTS_MENU
+ignore define CEC_OP_FEAT_RC_SRC_HAS_MEDIA_TOP_MENU
+ignore define CEC_OP_FEAT_RC_SRC_HAS_MEDIA_CONTEXT_MENU
+
+ignore define CEC_OP_FEAT_DEV_HAS_RECORD_TV_SCREEN
+ignore define CEC_OP_FEAT_DEV_HAS_SET_OSD_STRING
+ignore define CEC_OP_FEAT_DEV_HAS_DECK_CONTROL
+ignore define CEC_OP_FEAT_DEV_HAS_SET_AUDIO_RATE
+ignore define CEC_OP_FEAT_DEV_SINK_HAS_ARC_TX
+ignore define CEC_OP_FEAT_DEV_SOURCE_HAS_ARC_RX
+
+ignore define CEC_MSG_GIVE_FEATURES
+
+ignore define CEC_MSG_DECK_CONTROL
+
+ignore define CEC_OP_DECK_CTL_MODE_SKIP_FWD
+ignore define CEC_OP_DECK_CTL_MODE_SKIP_REV
+ignore define CEC_OP_DECK_CTL_MODE_STOP
+ignore define CEC_OP_DECK_CTL_MODE_EJECT
+
+ignore define CEC_MSG_DECK_STATUS
+
+ignore define CEC_OP_DECK_INFO_PLAY
+ignore define CEC_OP_DECK_INFO_RECORD
+ignore define CEC_OP_DECK_INFO_PLAY_REV
+ignore define CEC_OP_DECK_INFO_STILL
+ignore define CEC_OP_DECK_INFO_SLOW
+ignore define CEC_OP_DECK_INFO_SLOW_REV
+ignore define CEC_OP_DECK_INFO_FAST_FWD
+ignore define CEC_OP_DECK_INFO_FAST_REV
+ignore define CEC_OP_DECK_INFO_NO_MEDIA
+ignore define CEC_OP_DECK_INFO_STOP
+ignore define CEC_OP_DECK_INFO_SKIP_FWD
+ignore define CEC_OP_DECK_INFO_SKIP_REV
+ignore define CEC_OP_DECK_INFO_INDEX_SEARCH_FWD
+ignore define CEC_OP_DECK_INFO_INDEX_SEARCH_REV
+ignore define CEC_OP_DECK_INFO_OTHER
+
+ignore define CEC_MSG_GIVE_DECK_STATUS
+
+ignore define CEC_OP_STATUS_REQ_ON
+ignore define CEC_OP_STATUS_REQ_OFF
+ignore define CEC_OP_STATUS_REQ_ONCE
+
+ignore define CEC_MSG_PLAY
+
+ignore define CEC_OP_PLAY_MODE_PLAY_FWD
+ignore define CEC_OP_PLAY_MODE_PLAY_REV
+ignore define CEC_OP_PLAY_MODE_PLAY_STILL
+ignore define CEC_OP_PLAY_MODE_PLAY_FAST_FWD_MIN
+ignore define CEC_OP_PLAY_MODE_PLAY_FAST_FWD_MED
+ignore define CEC_OP_PLAY_MODE_PLAY_FAST_FWD_MAX
+ignore define CEC_OP_PLAY_MODE_PLAY_FAST_REV_MIN
+ignore define CEC_OP_PLAY_MODE_PLAY_FAST_REV_MED
+ignore define CEC_OP_PLAY_MODE_PLAY_FAST_REV_MAX
+ignore define CEC_OP_PLAY_MODE_PLAY_SLOW_FWD_MIN
+ignore define CEC_OP_PLAY_MODE_PLAY_SLOW_FWD_MED
+ignore define CEC_OP_PLAY_MODE_PLAY_SLOW_FWD_MAX
+ignore define CEC_OP_PLAY_MODE_PLAY_SLOW_REV_MIN
+ignore define CEC_OP_PLAY_MODE_PLAY_SLOW_REV_MED
+ignore define CEC_OP_PLAY_MODE_PLAY_SLOW_REV_MAX
+
+ignore define CEC_MSG_GIVE_TUNER_DEVICE_STATUS
+ignore define CEC_MSG_SELECT_ANALOGUE_SERVICE
+ignore define CEC_MSG_SELECT_DIGITAL_SERVICE
+ignore define CEC_MSG_TUNER_DEVICE_STATUS
+
+ignore define CEC_OP_REC_FLAG_USED
+ignore define CEC_OP_REC_FLAG_NOT_USED
+
+ignore define CEC_OP_TUNER_DISPLAY_INFO_DIGITAL
+ignore define CEC_OP_TUNER_DISPLAY_INFO_NONE
+ignore define CEC_OP_TUNER_DISPLAY_INFO_ANALOGUE
+
+ignore define CEC_MSG_TUNER_STEP_DECREMENT
+ignore define CEC_MSG_TUNER_STEP_INCREMENT
+
+ignore define CEC_MSG_DEVICE_VENDOR_ID
+ignore define CEC_MSG_GIVE_DEVICE_VENDOR_ID
+ignore define CEC_MSG_VENDOR_COMMAND
+ignore define CEC_MSG_VENDOR_COMMAND_WITH_ID
+ignore define CEC_MSG_VENDOR_REMOTE_BUTTON_DOWN
+ignore define CEC_MSG_VENDOR_REMOTE_BUTTON_UP
+
+ignore define CEC_MSG_SET_OSD_STRING
+
+ignore define CEC_OP_DISP_CTL_DEFAULT
+ignore define CEC_OP_DISP_CTL_UNTIL_CLEARED
+ignore define CEC_OP_DISP_CTL_CLEAR
+
+ignore define CEC_MSG_GIVE_OSD_NAME
+ignore define CEC_MSG_SET_OSD_NAME
+
+ignore define CEC_MSG_MENU_REQUEST
+
+ignore define CEC_OP_MENU_REQUEST_ACTIVATE
+ignore define CEC_OP_MENU_REQUEST_DEACTIVATE
+ignore define CEC_OP_MENU_REQUEST_QUERY
+
+ignore define CEC_MSG_MENU_STATUS
+
+ignore define CEC_OP_MENU_STATE_ACTIVATED
+ignore define CEC_OP_MENU_STATE_DEACTIVATED
+
+ignore define CEC_MSG_USER_CONTROL_PRESSED
+
+ignore define CEC_OP_UI_BCAST_TYPE_TOGGLE_ALL
+ignore define CEC_OP_UI_BCAST_TYPE_TOGGLE_DIG_ANA
+ignore define CEC_OP_UI_BCAST_TYPE_ANALOGUE
+ignore define CEC_OP_UI_BCAST_TYPE_ANALOGUE_T
+ignore define CEC_OP_UI_BCAST_TYPE_ANALOGUE_CABLE
+ignore define CEC_OP_UI_BCAST_TYPE_ANALOGUE_SAT
+ignore define CEC_OP_UI_BCAST_TYPE_DIGITAL
+ignore define CEC_OP_UI_BCAST_TYPE_DIGITAL_T
+ignore define CEC_OP_UI_BCAST_TYPE_DIGITAL_CABLE
+ignore define CEC_OP_UI_BCAST_TYPE_DIGITAL_SAT
+ignore define CEC_OP_UI_BCAST_TYPE_DIGITAL_COM_SAT
+ignore define CEC_OP_UI_BCAST_TYPE_DIGITAL_COM_SAT2
+ignore define CEC_OP_UI_BCAST_TYPE_IP
+
+ignore define CEC_OP_UI_SND_PRES_CTL_DUAL_MONO
+ignore define CEC_OP_UI_SND_PRES_CTL_KARAOKE
+ignore define CEC_OP_UI_SND_PRES_CTL_DOWNMIX
+ignore define CEC_OP_UI_SND_PRES_CTL_REVERB
+ignore define CEC_OP_UI_SND_PRES_CTL_EQUALIZER
+ignore define CEC_OP_UI_SND_PRES_CTL_BASS_UP
+ignore define CEC_OP_UI_SND_PRES_CTL_BASS_NEUTRAL
+ignore define CEC_OP_UI_SND_PRES_CTL_BASS_DOWN
+ignore define CEC_OP_UI_SND_PRES_CTL_TREBLE_UP
+ignore define CEC_OP_UI_SND_PRES_CTL_TREBLE_NEUTRAL
+ignore define CEC_OP_UI_SND_PRES_CTL_TREBLE_DOWN
+
+ignore define CEC_MSG_USER_CONTROL_RELEASED
+
+ignore define CEC_MSG_GIVE_DEVICE_POWER_STATUS
+ignore define CEC_MSG_REPORT_POWER_STATUS
+
+ignore define CEC_OP_POWER_STATUS_ON
+ignore define CEC_OP_POWER_STATUS_STANDBY
+ignore define CEC_OP_POWER_STATUS_TO_ON
+ignore define CEC_OP_POWER_STATUS_TO_STANDBY
+
+ignore define CEC_MSG_FEATURE_ABORT
+
+ignore define CEC_OP_ABORT_UNRECOGNIZED_OP
+ignore define CEC_OP_ABORT_INCORRECT_MODE
+ignore define CEC_OP_ABORT_NO_SOURCE
+ignore define CEC_OP_ABORT_INVALID_OP
+ignore define CEC_OP_ABORT_REFUSED
+ignore define CEC_OP_ABORT_UNDETERMINED
+
+ignore define CEC_MSG_ABORT
+
+ignore define CEC_MSG_GIVE_AUDIO_STATUS
+ignore define CEC_MSG_GIVE_SYSTEM_AUDIO_MODE_STATUS
+ignore define CEC_MSG_REPORT_AUDIO_STATUS
+
+ignore define CEC_OP_AUD_MUTE_STATUS_OFF
+ignore define CEC_OP_AUD_MUTE_STATUS_ON
+
+ignore define CEC_MSG_REPORT_SHORT_AUDIO_DESCRIPTOR
+ignore define CEC_MSG_REQUEST_SHORT_AUDIO_DESCRIPTOR
+ignore define CEC_MSG_SET_SYSTEM_AUDIO_MODE
+
+ignore define CEC_OP_SYS_AUD_STATUS_OFF
+ignore define CEC_OP_SYS_AUD_STATUS_ON
+
+ignore define CEC_MSG_SYSTEM_AUDIO_MODE_REQUEST
+ignore define CEC_MSG_SYSTEM_AUDIO_MODE_STATUS
+
+ignore define CEC_OP_AUD_FMT_ID_CEA861
+ignore define CEC_OP_AUD_FMT_ID_CEA861_CXT
+
+ignore define CEC_MSG_SET_AUDIO_RATE
+
+ignore define CEC_OP_AUD_RATE_OFF
+ignore define CEC_OP_AUD_RATE_WIDE_STD
+ignore define CEC_OP_AUD_RATE_WIDE_FAST
+ignore define CEC_OP_AUD_RATE_WIDE_SLOW
+ignore define CEC_OP_AUD_RATE_NARROW_STD
+ignore define CEC_OP_AUD_RATE_NARROW_FAST
+ignore define CEC_OP_AUD_RATE_NARROW_SLOW
+
+ignore define CEC_MSG_INITIATE_ARC
+ignore define CEC_MSG_REPORT_ARC_INITIATED
+ignore define CEC_MSG_REPORT_ARC_TERMINATED
+ignore define CEC_MSG_REQUEST_ARC_INITIATION
+ignore define CEC_MSG_REQUEST_ARC_TERMINATION
+ignore define CEC_MSG_TERMINATE_ARC
+
+ignore define CEC_MSG_REQUEST_CURRENT_LATENCY
+ignore define CEC_MSG_REPORT_CURRENT_LATENCY
+
+ignore define CEC_OP_LOW_LATENCY_MODE_OFF
+ignore define CEC_OP_LOW_LATENCY_MODE_ON
+
+ignore define CEC_OP_AUD_OUT_COMPENSATED_NA
+ignore define CEC_OP_AUD_OUT_COMPENSATED_DELAY
+ignore define CEC_OP_AUD_OUT_COMPENSATED_NO_DELAY
+ignore define CEC_OP_AUD_OUT_COMPENSATED_PARTIAL_DELAY
+
+ignore define CEC_MSG_CDC_MESSAGE
+
+ignore define CEC_MSG_CDC_HEC_INQUIRE_STATE
+ignore define CEC_MSG_CDC_HEC_REPORT_STATE
+
+ignore define CEC_OP_HEC_FUNC_STATE_NOT_SUPPORTED
+ignore define CEC_OP_HEC_FUNC_STATE_INACTIVE
+ignore define CEC_OP_HEC_FUNC_STATE_ACTIVE
+ignore define CEC_OP_HEC_FUNC_STATE_ACTIVATION_FIELD
+
+ignore define CEC_OP_HOST_FUNC_STATE_NOT_SUPPORTED
+ignore define CEC_OP_HOST_FUNC_STATE_INACTIVE
+ignore define CEC_OP_HOST_FUNC_STATE_ACTIVE
+
+ignore define CEC_OP_ENC_FUNC_STATE_EXT_CON_NOT_SUPPORTED
+ignore define CEC_OP_ENC_FUNC_STATE_EXT_CON_INACTIVE
+ignore define CEC_OP_ENC_FUNC_STATE_EXT_CON_ACTIVE
+
+ignore define CEC_OP_CDC_ERROR_CODE_NONE
+ignore define CEC_OP_CDC_ERROR_CODE_CAP_UNSUPPORTED
+ignore define CEC_OP_CDC_ERROR_CODE_WRONG_STATE
+ignore define CEC_OP_CDC_ERROR_CODE_OTHER
+
+ignore define CEC_OP_HEC_SUPPORT_NO
+ignore define CEC_OP_HEC_SUPPORT_YES
+
+ignore define CEC_OP_HEC_ACTIVATION_ON
+ignore define CEC_OP_HEC_ACTIVATION_OFF
+
+ignore define CEC_MSG_CDC_HEC_SET_STATE_ADJACENT
+ignore define CEC_MSG_CDC_HEC_SET_STATE
+
+ignore define CEC_OP_HEC_SET_STATE_DEACTIVATE
+ignore define CEC_OP_HEC_SET_STATE_ACTIVATE
+
+ignore define CEC_MSG_CDC_HEC_REQUEST_DEACTIVATION
+ignore define CEC_MSG_CDC_HEC_NOTIFY_ALIVE
+ignore define CEC_MSG_CDC_HEC_DISCOVER
+
+ignore define CEC_MSG_CDC_HPD_SET_STATE
+
+ignore define CEC_OP_HPD_STATE_CP_EDID_DISABLE
+ignore define CEC_OP_HPD_STATE_CP_EDID_ENABLE
+ignore define CEC_OP_HPD_STATE_CP_EDID_DISABLE_ENABLE
+ignore define CEC_OP_HPD_STATE_EDID_DISABLE
+ignore define CEC_OP_HPD_STATE_EDID_ENABLE
+ignore define CEC_OP_HPD_STATE_EDID_DISABLE_ENABLE
+ignore define CEC_MSG_CDC_HPD_REPORT_STATE
+
+ignore define CEC_OP_HPD_ERROR_NONE
+ignore define CEC_OP_HPD_ERROR_INITIATOR_NOT_CAPABLE
+ignore define CEC_OP_HPD_ERROR_INITIATOR_WRONG_STATE
+ignore define CEC_OP_HPD_ERROR_OTHER
+ignore define CEC_OP_HPD_ERROR_NONE_NO_VIDEO
diff --git a/Documentation/media/uapi/dvb/audio.h.exceptions b/Documentation/media/uapi/dvb/audio.h.exceptions
new file mode 100644
index 0000000..8330edc
--- /dev/null
+++ b/Documentation/media/uapi/dvb/audio.h.exceptions
@@ -0,0 +1,20 @@
+# Ignore header name
+ignore define _DVBAUDIO_H_
+
+# Typedef pointing to structs
+replace typedef audio_karaoke_t audio-karaoke
+
+# Undocumented audio caps, as this is a deprecated API anyway
+ignore define AUDIO_CAP_DTS
+ignore define AUDIO_CAP_LPCM
+ignore define AUDIO_CAP_MP1
+ignore define AUDIO_CAP_MP2
+ignore define AUDIO_CAP_MP3
+ignore define AUDIO_CAP_AAC
+ignore define AUDIO_CAP_OGG
+ignore define AUDIO_CAP_SDDS
+ignore define AUDIO_CAP_AC3
+
+# some typedefs should point to struct/enums
+replace typedef audio_mixer_t audio-mixer
+replace typedef audio_status_t audio-status
diff --git a/Documentation/media/uapi/dvb/audio_h.rst b/Documentation/media/uapi/dvb/audio_h.rst
index e00c301..456c442 100644
--- a/Documentation/media/uapi/dvb/audio_h.rst
+++ b/Documentation/media/uapi/dvb/audio_h.rst
@@ -6,4 +6,5 @@
 DVB Audio Header File
 *********************
 
-.. kernel-include:: $BUILDDIR/audio.h.rst
+.. parse-header:: include/uapi/linux/dvb/audio.h
+   :exceptions: audio.h.exceptions
diff --git a/Documentation/media/uapi/dvb/ca.h.exceptions b/Documentation/media/uapi/dvb/ca.h.exceptions
new file mode 100644
index 0000000..09c13be
--- /dev/null
+++ b/Documentation/media/uapi/dvb/ca.h.exceptions
@@ -0,0 +1,24 @@
+# Ignore header name
+ignore define _DVBCA_H_
+
+# struct ca_slot_info defines
+replace define CA_CI ca-slot-info
+replace define CA_CI_LINK ca-slot-info
+replace define CA_CI_PHYS ca-slot-info
+replace define CA_DESCR ca-slot-info
+replace define CA_SC ca-slot-info
+replace define CA_CI_MODULE_PRESENT ca-slot-info
+replace define CA_CI_MODULE_READY ca-slot-info
+
+# struct ca_descr_info defines
+replace define CA_ECD ca-descr-info
+replace define CA_NDS ca-descr-info
+replace define CA_DSS ca-descr-info
+
+# some typedefs should point to struct/enums
+replace typedef ca_pid_t ca-pid
+replace typedef ca_slot_info_t ca-slot-info
+replace typedef ca_descr_info_t ca-descr-info
+replace typedef ca_caps_t ca-caps
+replace typedef ca_msg_t ca-msg
+replace typedef ca_descr_t ca-descr
diff --git a/Documentation/media/uapi/dvb/ca_h.rst b/Documentation/media/uapi/dvb/ca_h.rst
index f513592..0f81256 100644
--- a/Documentation/media/uapi/dvb/ca_h.rst
+++ b/Documentation/media/uapi/dvb/ca_h.rst
@@ -6,4 +6,5 @@
 DVB Conditional Access Header File
 **********************************
 
-.. kernel-include:: $BUILDDIR/ca.h.rst
+.. parse-header:: include/uapi/linux/dvb/ca.h
+   :exceptions: ca.h.exceptions
diff --git a/Documentation/media/uapi/dvb/dmx.h.exceptions b/Documentation/media/uapi/dvb/dmx.h.exceptions
new file mode 100644
index 0000000..8200653
--- /dev/null
+++ b/Documentation/media/uapi/dvb/dmx.h.exceptions
@@ -0,0 +1,63 @@
+# Ignore header name
+ignore define _UAPI_DVBDMX_H_
+
+# Ignore limit constants
+ignore define DMX_FILTER_SIZE
+
+# dmx-pes-type-t enum symbols
+replace enum dmx_ts_pes dmx-pes-type-t
+replace symbol DMX_PES_AUDIO0 dmx-pes-type-t
+replace symbol DMX_PES_VIDEO0 dmx-pes-type-t
+replace symbol DMX_PES_TELETEXT0 dmx-pes-type-t
+replace symbol DMX_PES_SUBTITLE0 dmx-pes-type-t
+replace symbol DMX_PES_PCR0 dmx-pes-type-t
+replace symbol DMX_PES_AUDIO1 dmx-pes-type-t
+replace symbol DMX_PES_VIDEO1 dmx-pes-type-t
+replace symbol DMX_PES_TELETEXT1 dmx-pes-type-t
+replace symbol DMX_PES_SUBTITLE1 dmx-pes-type-t
+replace symbol DMX_PES_PCR1 dmx-pes-type-t
+replace symbol DMX_PES_AUDIO2 dmx-pes-type-t
+replace symbol DMX_PES_VIDEO2 dmx-pes-type-t
+replace symbol DMX_PES_TELETEXT2 dmx-pes-type-t
+replace symbol DMX_PES_SUBTITLE2 dmx-pes-type-t
+replace symbol DMX_PES_PCR2 dmx-pes-type-t
+replace symbol DMX_PES_AUDIO3 dmx-pes-type-t
+replace symbol DMX_PES_VIDEO3 dmx-pes-type-t
+replace symbol DMX_PES_TELETEXT3 dmx-pes-type-t
+replace symbol DMX_PES_SUBTITLE3 dmx-pes-type-t
+replace symbol DMX_PES_PCR3 dmx-pes-type-t
+replace symbol DMX_PES_OTHER dmx-pes-type-t
+
+# Ignore obsolete symbols
+ignore define DMX_PES_AUDIO
+ignore define DMX_PES_VIDEO
+ignore define DMX_PES_TELETEXT
+ignore define DMX_PES_SUBTITLE
+ignore define DMX_PES_PCR
+
+# dmx_input_t symbols
+replace enum dmx_input dmx-input-t
+replace symbol DMX_IN_FRONTEND dmx-input-t
+replace symbol DMX_IN_DVR dmx-input-t
+
+# dmx_source_t symbols
+replace enum dmx_source dmx-source-t
+replace symbol DMX_SOURCE_FRONT0 dmx-source-t
+replace symbol DMX_SOURCE_FRONT1 dmx-source-t
+replace symbol DMX_SOURCE_FRONT2 dmx-source-t
+replace symbol DMX_SOURCE_FRONT3 dmx-source-t
+replace symbol DMX_SOURCE_DVR0 dmx-source-t
+replace symbol DMX_SOURCE_DVR1 dmx-source-t
+replace symbol DMX_SOURCE_DVR2 dmx-source-t
+replace symbol DMX_SOURCE_DVR3 dmx-source-t
+
+
+# Flags for struct dmx_sct_filter_params
+replace define DMX_CHECK_CRC dmx-sct-filter-params
+replace define DMX_ONESHOT dmx-sct-filter-params
+replace define DMX_IMMEDIATE_START dmx-sct-filter-params
+replace define DMX_KERNEL_CLIENT dmx-sct-filter-params
+
+# some typedefs should point to struct/enums
+replace typedef dmx_caps_t dmx-caps
+replace typedef dmx_filter_t dmx-filter
diff --git a/Documentation/media/uapi/dvb/dmx_h.rst b/Documentation/media/uapi/dvb/dmx_h.rst
index 4fd1704..7e79b28 100644
--- a/Documentation/media/uapi/dvb/dmx_h.rst
+++ b/Documentation/media/uapi/dvb/dmx_h.rst
@@ -6,4 +6,5 @@
 DVB Demux Header File
 *********************
 
-.. kernel-include:: $BUILDDIR/dmx.h.rst
+.. parse-header:: include/uapi/linux/dvb/dmx.h
+   :exceptions: dmx.h.exceptions
diff --git a/Documentation/media/uapi/dvb/frontend.h.exceptions b/Documentation/media/uapi/dvb/frontend.h.exceptions
new file mode 100644
index 0000000..60f2cbb
--- /dev/null
+++ b/Documentation/media/uapi/dvb/frontend.h.exceptions
@@ -0,0 +1,47 @@
+# Ignore header name
+ignore define _DVBFRONTEND_H_
+
+# Group layer A-C symbols together
+replace define DTV_ISDBT_LAYERA_FEC dtv-isdbt-layer-fec
+replace define DTV_ISDBT_LAYERB_FEC dtv-isdbt-layer-fec
+replace define DTV_ISDBT_LAYERC_FEC dtv-isdbt-layer-fec
+replace define DTV_ISDBT_LAYERA_MODULATION dtv-isdbt-layer-modulation
+replace define DTV_ISDBT_LAYERB_MODULATION dtv-isdbt-layer-modulation
+replace define DTV_ISDBT_LAYERC_MODULATION dtv-isdbt-layer-modulation
+replace define DTV_ISDBT_LAYERA_SEGMENT_COUNT dtv-isdbt-layer-segment-count
+replace define DTV_ISDBT_LAYERB_SEGMENT_COUNT dtv-isdbt-layer-segment-count
+replace define DTV_ISDBT_LAYERC_SEGMENT_COUNT dtv-isdbt-layer-segment-count
+replace define DTV_ISDBT_LAYERA_TIME_INTERLEAVING dtv-isdbt-layer-time-interleaving
+replace define DTV_ISDBT_LAYERB_TIME_INTERLEAVING dtv-isdbt-layer-time-interleaving
+replace define DTV_ISDBT_LAYERC_TIME_INTERLEAVING dtv-isdbt-layer-time-interleaving
+
+# Ignore legacy defines
+ignore define DTV_ISDBS_TS_ID_LEGACY
+ignore define SYS_DVBC_ANNEX_AC
+ignore define SYS_DMBTH
+
+# Ignore limits
+ignore define DTV_MAX_COMMAND
+ignore define MAX_DTV_STATS
+ignore define DTV_IOCTL_MAX_MSGS
+
+# Stats enum is documented altogether
+replace enum fecap_scale_params frontend-stat-properties
+replace symbol FE_SCALE_COUNTER frontend-stat-properties
+replace symbol FE_SCALE_DECIBEL frontend-stat-properties
+replace symbol FE_SCALE_NOT_AVAILABLE frontend-stat-properties
+replace symbol FE_SCALE_RELATIVE frontend-stat-properties
+
+# the same reference is used for both get and set ioctls
+replace ioctl FE_SET_PROPERTY FE_GET_PROPERTY
+
+# Ignore struct used only internally at Kernel
+ignore struct dtv_cmds_h
+
+# Typedefs that use the enum reference
+replace typedef fe_sec_voltage_t fe-sec-voltage
+
+# Replaces for flag constants
+replace define FE_TUNE_MODE_ONESHOT fe_set_frontend_tune_mode
+replace define LNA_AUTO dtv-lna
+replace define NO_STREAM_ID_FILTER dtv-stream-id
diff --git a/Documentation/media/uapi/dvb/frontend_h.rst b/Documentation/media/uapi/dvb/frontend_h.rst
index 15fca04..f019cbc 100644
--- a/Documentation/media/uapi/dvb/frontend_h.rst
+++ b/Documentation/media/uapi/dvb/frontend_h.rst
@@ -6,4 +6,5 @@
 DVB Frontend Header File
 ************************
 
-.. kernel-include:: $BUILDDIR/frontend.h.rst
+.. parse-header:: include/uapi/linux/dvb/frontend.h
+   :exceptions: frontend.h.exceptions
diff --git a/Documentation/media/uapi/dvb/net.h.exceptions b/Documentation/media/uapi/dvb/net.h.exceptions
new file mode 100644
index 0000000..30a2674
--- /dev/null
+++ b/Documentation/media/uapi/dvb/net.h.exceptions
@@ -0,0 +1,11 @@
+# Ignore header name
+ignore define _DVBNET_H_
+
+# Ignore old ioctls/structs
+ignore ioctl __NET_ADD_IF_OLD
+ignore ioctl __NET_GET_IF_OLD
+ignore struct __dvb_net_if_old
+
+# Macros used at struct dvb_net_if
+replace define DVB_NET_FEEDTYPE_MPE dvb-net-if
+replace define DVB_NET_FEEDTYPE_ULE dvb-net-if
diff --git a/Documentation/media/uapi/dvb/net_h.rst b/Documentation/media/uapi/dvb/net_h.rst
index 7bcf5ba..37ad102 100644
--- a/Documentation/media/uapi/dvb/net_h.rst
+++ b/Documentation/media/uapi/dvb/net_h.rst
@@ -6,4 +6,5 @@
 DVB Network Header File
 ***********************
 
-.. kernel-include:: $BUILDDIR/net.h.rst
+.. parse-header:: include/uapi/linux/dvb/net.h
+   :exceptions: net.h.exceptions
diff --git a/Documentation/media/uapi/dvb/video.h.exceptions b/Documentation/media/uapi/dvb/video.h.exceptions
new file mode 100644
index 0000000..8866145
--- /dev/null
+++ b/Documentation/media/uapi/dvb/video.h.exceptions
@@ -0,0 +1,40 @@
+# Ignore header name
+ignore define _UAPI_DVBVIDEO_H_
+
+# This is a deprecated obscure API. Just ignore things we don't know
+ignore define VIDEO_CMD_PLAY
+ignore define VIDEO_CMD_STOP
+ignore define VIDEO_CMD_FREEZE
+ignore define VIDEO_CMD_CONTINUE
+ignore define VIDEO_CMD_FREEZE_TO_BLACK
+ignore define VIDEO_CMD_STOP_TO_BLACK
+ignore define VIDEO_CMD_STOP_IMMEDIATELY
+ignore define VIDEO_PLAY_FMT_NONE
+ignore define VIDEO_PLAY_FMT_GOP
+ignore define VIDEO_VSYNC_FIELD_UNKNOWN
+ignore define VIDEO_VSYNC_FIELD_ODD
+ignore define VIDEO_VSYNC_FIELD_EVEN
+ignore define VIDEO_VSYNC_FIELD_PROGRESSIVE
+ignore define VIDEO_EVENT_SIZE_CHANGED
+ignore define VIDEO_EVENT_FRAME_RATE_CHANGED
+ignore define VIDEO_EVENT_DECODER_STOPPED
+ignore define VIDEO_EVENT_VSYNC
+ignore define VIDEO_CAP_MPEG1
+ignore define VIDEO_CAP_MPEG2
+ignore define VIDEO_CAP_SYS
+ignore define VIDEO_CAP_PROG
+ignore define VIDEO_CAP_SPU
+ignore define VIDEO_CAP_NAVI
+ignore define VIDEO_CAP_CSS
+
+# some typedefs should point to struct/enums
+replace typedef video_format_t video-format
+replace typedef video_system_t video-system
+replace typedef video_displayformat_t video-displayformat
+replace typedef video_size_t video-size
+replace typedef video_stream_source_t video-stream-source
+replace typedef video_play_state_t video-play-state
+replace typedef video_highlight_t video-highlight
+replace typedef video_spu_t video-spu
+replace typedef video_spu_palette_t video-spu-palette
+replace typedef video_navi_pack_t video-navi-pack
diff --git a/Documentation/media/uapi/dvb/video_h.rst b/Documentation/media/uapi/dvb/video_h.rst
index 3f39b0c..e24e306 100644
--- a/Documentation/media/uapi/dvb/video_h.rst
+++ b/Documentation/media/uapi/dvb/video_h.rst
@@ -6,4 +6,5 @@
 DVB Video Header File
 *********************
 
-.. kernel-include:: $BUILDDIR/video.h.rst
+.. parse-header:: include/uapi/linux/dvb/video.h
+   :exceptions: video.h.exceptions
diff --git a/Documentation/media/uapi/mediactl/media-header.rst b/Documentation/media/uapi/mediactl/media-header.rst
index 96f7b01..6f6937b 100644
--- a/Documentation/media/uapi/mediactl/media-header.rst
+++ b/Documentation/media/uapi/mediactl/media-header.rst
@@ -6,5 +6,5 @@
 Media Controller Header File
 ****************************
 
-.. kernel-include:: $BUILDDIR/media.h.rst
-
+.. parse-header:: include/uapi/linux/media.h
+   :exceptions: media.h.exceptions
diff --git a/Documentation/media/uapi/mediactl/media.h.exceptions b/Documentation/media/uapi/mediactl/media.h.exceptions
new file mode 100644
index 0000000..83d7f7c
--- /dev/null
+++ b/Documentation/media/uapi/mediactl/media.h.exceptions
@@ -0,0 +1,30 @@
+# Ignore header name
+ignore define __LINUX_MEDIA_H
+
+# Ignore macros
+ignore define MEDIA_API_VERSION
+ignore define MEDIA_ENT_F_BASE
+ignore define MEDIA_ENT_F_OLD_BASE
+ignore define MEDIA_ENT_F_OLD_SUBDEV_BASE
+ignore define MEDIA_INTF_T_DVB_BASE
+ignore define MEDIA_INTF_T_V4L_BASE
+ignore define MEDIA_INTF_T_ALSA_BASE
+
+#ignore legacy entity type macros
+ignore define MEDIA_ENT_TYPE_SHIFT
+ignore define MEDIA_ENT_TYPE_MASK
+ignore define MEDIA_ENT_SUBTYPE_MASK
+ignore define MEDIA_ENT_T_DEVNODE_UNKNOWN
+ignore define MEDIA_ENT_T_DEVNODE
+ignore define MEDIA_ENT_T_DEVNODE_V4L
+ignore define MEDIA_ENT_T_DEVNODE_FB
+ignore define MEDIA_ENT_T_DEVNODE_ALSA
+ignore define MEDIA_ENT_T_DEVNODE_DVB
+ignore define MEDIA_ENT_T_UNKNOWN
+ignore define MEDIA_ENT_T_V4L2_VIDEO
+ignore define MEDIA_ENT_T_V4L2_SUBDEV
+ignore define MEDIA_ENT_T_V4L2_SUBDEV_SENSOR
+ignore define MEDIA_ENT_T_V4L2_SUBDEV_FLASH
+ignore define MEDIA_ENT_T_V4L2_SUBDEV_LENS
+ignore define MEDIA_ENT_T_V4L2_SUBDEV_DECODER
+ignore define MEDIA_ENT_T_V4L2_SUBDEV_TUNER
diff --git a/Documentation/media/uapi/rc/lirc-header.rst b/Documentation/media/uapi/rc/lirc-header.rst
index 487fe00..b1fa2b5 100644
--- a/Documentation/media/uapi/rc/lirc-header.rst
+++ b/Documentation/media/uapi/rc/lirc-header.rst
@@ -6,5 +6,6 @@
 LIRC Header File
 ****************
 
-.. kernel-include:: $BUILDDIR/lirc.h.rst
+.. parse-header:: include/uapi/linux/lirc.h
+   :exceptions: lirc.h.exceptions
 
diff --git a/Documentation/media/uapi/rc/lirc.h.exceptions b/Documentation/media/uapi/rc/lirc.h.exceptions
new file mode 100644
index 0000000..246c850
--- /dev/null
+++ b/Documentation/media/uapi/rc/lirc.h.exceptions
@@ -0,0 +1,43 @@
+# Ignore header name
+ignore define _LINUX_LIRC_H
+
+# Ignore helper macros
+
+ignore define lirc_t
+
+ignore define LIRC_SPACE
+ignore define LIRC_PULSE
+ignore define LIRC_FREQUENCY
+ignore define LIRC_TIMEOUT
+ignore define LIRC_VALUE
+ignore define LIRC_MODE2
+ignore define LIRC_IS_SPACE
+ignore define LIRC_IS_PULSE
+ignore define LIRC_IS_FREQUENCY
+ignore define LIRC_IS_TIMEOUT
+
+ignore define LIRC_MODE2SEND
+ignore define LIRC_SEND2MODE
+ignore define LIRC_MODE2REC
+ignore define LIRC_REC2MODE
+
+ignore define LIRC_CAN_SEND
+ignore define LIRC_CAN_REC
+
+ignore define LIRC_CAN_SEND_MASK
+ignore define LIRC_CAN_REC_MASK
+ignore define LIRC_CAN_SET_REC_DUTY_CYCLE
+
+# Undocumented macros
+
+ignore define PULSE_BIT
+ignore define PULSE_MASK
+
+ignore define LIRC_MODE2_SPACE
+ignore define LIRC_MODE2_PULSE
+ignore define LIRC_MODE2_TIMEOUT
+
+ignore define LIRC_VALUE_MASK
+ignore define LIRC_MODE2_MASK
+
+ignore define LIRC_MODE_RAW
diff --git a/Documentation/media/uapi/v4l/videodev.rst b/Documentation/media/uapi/v4l/videodev.rst
index b9ee467..2cbfc18 100644
--- a/Documentation/media/uapi/v4l/videodev.rst
+++ b/Documentation/media/uapi/v4l/videodev.rst
@@ -6,4 +6,5 @@
 Video For Linux Two Header File
 *******************************
 
-.. kernel-include:: $BUILDDIR/videodev2.h.rst
+.. parse-header:: include/uapi/linux/videodev2.h
+   :exceptions: videodev2.h.exceptions
diff --git a/Documentation/media/uapi/v4l/videodev2.h.exceptions b/Documentation/media/uapi/v4l/videodev2.h.exceptions
new file mode 100644
index 0000000..9bb9a6c
--- /dev/null
+++ b/Documentation/media/uapi/v4l/videodev2.h.exceptions
@@ -0,0 +1,535 @@
+# Ignore header name
+ignore define _UAPI__LINUX_VIDEODEV2_H
+
+#
+# The cross reference valitator for videodev2.h DocBook never cared
+# about enum symbols or defines. Yet, they're all (or almost all?)
+# handled inside V4L API sections. So, for now, it is safe to just
+# ignore. This should be revisited, as validating it helps to avoid
+# having something not documented at the uAPI.
+#
+
+# Those symbols should not be used by uAPI - don't document them
+ignore symbol V4L2_BUF_TYPE_PRIVATE
+ignore symbol V4L2_TUNER_DIGITAL_TV
+ignore symbol V4L2_COLORSPACE_BT878
+
+# Documented enum v4l2_field
+replace symbol V4L2_FIELD_ALTERNATE v4l2-field
+replace symbol V4L2_FIELD_ANY v4l2-field
+replace symbol V4L2_FIELD_BOTTOM v4l2-field
+replace symbol V4L2_FIELD_INTERLACED v4l2-field
+replace symbol V4L2_FIELD_INTERLACED_BT v4l2-field
+replace symbol V4L2_FIELD_INTERLACED_TB v4l2-field
+replace symbol V4L2_FIELD_NONE v4l2-field
+replace symbol V4L2_FIELD_SEQ_BT v4l2-field
+replace symbol V4L2_FIELD_SEQ_TB v4l2-field
+replace symbol V4L2_FIELD_TOP v4l2-field
+
+# Documented enum v4l2_buf_type
+replace symbol V4L2_BUF_TYPE_SDR_CAPTURE v4l2-buf-type
+replace symbol V4L2_BUF_TYPE_SDR_OUTPUT v4l2-buf-type
+replace symbol V4L2_BUF_TYPE_SLICED_VBI_CAPTURE v4l2-buf-type
+replace symbol V4L2_BUF_TYPE_SLICED_VBI_OUTPUT v4l2-buf-type
+replace symbol V4L2_BUF_TYPE_VBI_CAPTURE v4l2-buf-type
+replace symbol V4L2_BUF_TYPE_VBI_OUTPUT v4l2-buf-type
+replace symbol V4L2_BUF_TYPE_VIDEO_CAPTURE v4l2-buf-type
+replace symbol V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE v4l2-buf-type
+replace symbol V4L2_BUF_TYPE_VIDEO_OUTPUT v4l2-buf-type
+replace symbol V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE v4l2-buf-type
+replace symbol V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY v4l2-buf-type
+replace symbol V4L2_BUF_TYPE_VIDEO_OVERLAY v4l2-buf-type
+
+# Documented enum v4l2_tuner_type
+replace symbol V4L2_TUNER_ANALOG_TV v4l2-tuner-type
+replace symbol V4L2_TUNER_RADIO v4l2-tuner-type
+replace symbol V4L2_TUNER_RF v4l2-tuner-type
+replace symbol V4L2_TUNER_SDR v4l2-tuner-type
+
+# Documented enum v4l2_memory
+replace symbol V4L2_MEMORY_DMABUF v4l2-memory
+replace symbol V4L2_MEMORY_MMAP v4l2-memory
+replace symbol V4L2_MEMORY_OVERLAY v4l2-memory
+replace symbol V4L2_MEMORY_USERPTR v4l2-memory
+
+# Documented enum v4l2_colorspace
+replace symbol V4L2_COLORSPACE_470_SYSTEM_BG v4l2-colorspace
+replace symbol V4L2_COLORSPACE_470_SYSTEM_M v4l2-colorspace
+replace symbol V4L2_COLORSPACE_ADOBERGB v4l2-colorspace
+replace symbol V4L2_COLORSPACE_BT2020 v4l2-colorspace
+replace symbol V4L2_COLORSPACE_DCI_P3 v4l2-colorspace
+replace symbol V4L2_COLORSPACE_DEFAULT v4l2-colorspace
+replace symbol V4L2_COLORSPACE_JPEG v4l2-colorspace
+replace symbol V4L2_COLORSPACE_RAW v4l2-colorspace
+replace symbol V4L2_COLORSPACE_REC709 v4l2-colorspace
+replace symbol V4L2_COLORSPACE_SMPTE170M v4l2-colorspace
+replace symbol V4L2_COLORSPACE_SMPTE240M v4l2-colorspace
+replace symbol V4L2_COLORSPACE_SRGB v4l2-colorspace
+
+# Documented enum v4l2_xfer_func
+replace symbol V4L2_XFER_FUNC_709 v4l2-xfer-func
+replace symbol V4L2_XFER_FUNC_ADOBERGB v4l2-xfer-func
+replace symbol V4L2_XFER_FUNC_DCI_P3 v4l2-xfer-func
+replace symbol V4L2_XFER_FUNC_DEFAULT v4l2-xfer-func
+replace symbol V4L2_XFER_FUNC_NONE v4l2-xfer-func
+replace symbol V4L2_XFER_FUNC_SMPTE2084 v4l2-xfer-func
+replace symbol V4L2_XFER_FUNC_SMPTE240M v4l2-xfer-func
+replace symbol V4L2_XFER_FUNC_SRGB v4l2-xfer-func
+
+# Documented enum v4l2_ycbcr_encoding
+replace symbol V4L2_YCBCR_ENC_601 v4l2-ycbcr-encoding
+replace symbol V4L2_YCBCR_ENC_709 v4l2-ycbcr-encoding
+replace symbol V4L2_YCBCR_ENC_BT2020 v4l2-ycbcr-encoding
+replace symbol V4L2_YCBCR_ENC_BT2020_CONST_LUM v4l2-ycbcr-encoding
+replace symbol V4L2_YCBCR_ENC_DEFAULT v4l2-ycbcr-encoding
+replace symbol V4L2_YCBCR_ENC_SYCC v4l2-ycbcr-encoding
+replace symbol V4L2_YCBCR_ENC_XV601 v4l2-ycbcr-encoding
+replace symbol V4L2_YCBCR_ENC_XV709 v4l2-ycbcr-encoding
+replace symbol V4L2_YCBCR_ENC_SMPTE240M v4l2-ycbcr-encoding
+
+# Documented enum v4l2_quantization
+replace symbol V4L2_QUANTIZATION_DEFAULT v4l2-quantization
+replace symbol V4L2_QUANTIZATION_FULL_RANGE v4l2-quantization
+replace symbol V4L2_QUANTIZATION_LIM_RANGE v4l2-quantization
+
+# Documented enum v4l2_priority
+replace symbol V4L2_PRIORITY_BACKGROUND v4l2-priority
+replace symbol V4L2_PRIORITY_DEFAULT v4l2-priority
+replace symbol V4L2_PRIORITY_INTERACTIVE v4l2-priority
+replace symbol V4L2_PRIORITY_RECORD v4l2-priority
+replace symbol V4L2_PRIORITY_UNSET v4l2-priority
+
+# Documented enum v4l2_frmsizetypes
+replace symbol V4L2_FRMSIZE_TYPE_CONTINUOUS v4l2-frmsizetypes
+replace symbol V4L2_FRMSIZE_TYPE_DISCRETE v4l2-frmsizetypes
+replace symbol V4L2_FRMSIZE_TYPE_STEPWISE v4l2-frmsizetypes
+
+# Documented enum frmivaltypes
+replace symbol V4L2_FRMIVAL_TYPE_CONTINUOUS v4l2-frmivaltypes
+replace symbol V4L2_FRMIVAL_TYPE_DISCRETE v4l2-frmivaltypes
+replace symbol V4L2_FRMIVAL_TYPE_STEPWISE v4l2-frmivaltypes
+
+# Documented enum v4l2-ctrl-type
+replace symbol V4L2_CTRL_COMPOUND_TYPES vidioc_queryctrl
+
+replace symbol V4L2_CTRL_TYPE_BITMASK v4l2-ctrl-type
+replace symbol V4L2_CTRL_TYPE_BOOLEAN v4l2-ctrl-type
+replace symbol V4L2_CTRL_TYPE_BUTTON v4l2-ctrl-type
+replace symbol V4L2_CTRL_TYPE_CTRL_CLASS v4l2-ctrl-type
+replace symbol V4L2_CTRL_TYPE_INTEGER v4l2-ctrl-type
+replace symbol V4L2_CTRL_TYPE_INTEGER64 v4l2-ctrl-type
+replace symbol V4L2_CTRL_TYPE_INTEGER_MENU v4l2-ctrl-type
+replace symbol V4L2_CTRL_TYPE_MENU v4l2-ctrl-type
+replace symbol V4L2_CTRL_TYPE_STRING v4l2-ctrl-type
+replace symbol V4L2_CTRL_TYPE_U16 v4l2-ctrl-type
+replace symbol V4L2_CTRL_TYPE_U32 v4l2-ctrl-type
+replace symbol V4L2_CTRL_TYPE_U8 v4l2-ctrl-type
+
+# V4L2 capability defines
+replace define V4L2_CAP_VIDEO_CAPTURE device-capabilities
+replace define V4L2_CAP_VIDEO_CAPTURE_MPLANE device-capabilities
+replace define V4L2_CAP_VIDEO_OUTPUT device-capabilities
+replace define V4L2_CAP_VIDEO_OUTPUT_MPLANE device-capabilities
+replace define V4L2_CAP_VIDEO_M2M device-capabilities
+replace define V4L2_CAP_VIDEO_M2M_MPLANE device-capabilities
+replace define V4L2_CAP_VIDEO_OVERLAY device-capabilities
+replace define V4L2_CAP_VBI_CAPTURE device-capabilities
+replace define V4L2_CAP_VBI_OUTPUT device-capabilities
+replace define V4L2_CAP_SLICED_VBI_CAPTURE device-capabilities
+replace define V4L2_CAP_SLICED_VBI_OUTPUT device-capabilities
+replace define V4L2_CAP_RDS_CAPTURE device-capabilities
+replace define V4L2_CAP_VIDEO_OUTPUT_OVERLAY device-capabilities
+replace define V4L2_CAP_HW_FREQ_SEEK device-capabilities
+replace define V4L2_CAP_RDS_OUTPUT device-capabilities
+replace define V4L2_CAP_TUNER device-capabilities
+replace define V4L2_CAP_AUDIO device-capabilities
+replace define V4L2_CAP_RADIO device-capabilities
+replace define V4L2_CAP_MODULATOR device-capabilities
+replace define V4L2_CAP_SDR_CAPTURE device-capabilities
+replace define V4L2_CAP_EXT_PIX_FORMAT device-capabilities
+replace define V4L2_CAP_SDR_OUTPUT device-capabilities
+replace define V4L2_CAP_READWRITE device-capabilities
+replace define V4L2_CAP_ASYNCIO device-capabilities
+replace define V4L2_CAP_STREAMING device-capabilities
+replace define V4L2_CAP_DEVICE_CAPS device-capabilities
+
+# V4L2 pix flags
+replace define V4L2_PIX_FMT_PRIV_MAGIC v4l2-pix-format
+replace define V4L2_PIX_FMT_FLAG_PREMUL_ALPHA reserved-formats
+
+# V4L2 format flags
+replace define V4L2_FMT_FLAG_COMPRESSED fmtdesc-flags
+replace define V4L2_FMT_FLAG_EMULATED fmtdesc-flags
+
+# V4L2 tymecode types
+replace define V4L2_TC_TYPE_24FPS timecode-type
+replace define V4L2_TC_TYPE_25FPS timecode-type
+replace define V4L2_TC_TYPE_30FPS timecode-type
+replace define V4L2_TC_TYPE_50FPS timecode-type
+replace define V4L2_TC_TYPE_60FPS timecode-type
+
+# V4L2 tymecode flags
+replace define V4L2_TC_FLAG_DROPFRAME timecode-flags
+replace define V4L2_TC_FLAG_COLORFRAME timecode-flags
+replace define V4L2_TC_USERBITS_field timecode-flags
+replace define V4L2_TC_USERBITS_USERDEFINED timecode-flags
+replace define V4L2_TC_USERBITS_8BITCHARS timecode-flags
+
+# V4L2 JPEG markers
+replace define V4L2_JPEG_MARKER_DHT jpeg-markers
+replace define V4L2_JPEG_MARKER_DQT jpeg-markers
+replace define V4L2_JPEG_MARKER_DRI jpeg-markers
+replace define V4L2_JPEG_MARKER_COM jpeg-markers
+replace define V4L2_JPEG_MARKER_APP jpeg-markers
+
+# V4L2 framebuffer caps and flags
+
+replace define V4L2_FBUF_CAP_EXTERNOVERLAY framebuffer-cap
+replace define V4L2_FBUF_CAP_CHROMAKEY framebuffer-cap
+replace define V4L2_FBUF_CAP_LIST_CLIPPING framebuffer-cap
+replace define V4L2_FBUF_CAP_BITMAP_CLIPPING framebuffer-cap
+replace define V4L2_FBUF_CAP_LOCAL_ALPHA framebuffer-cap
+replace define V4L2_FBUF_CAP_GLOBAL_ALPHA framebuffer-cap
+replace define V4L2_FBUF_CAP_LOCAL_INV_ALPHA framebuffer-cap
+replace define V4L2_FBUF_CAP_SRC_CHROMAKEY framebuffer-cap
+
+replace define V4L2_FBUF_FLAG_PRIMARY framebuffer-flags
+replace define V4L2_FBUF_FLAG_OVERLAY framebuffer-flags
+replace define V4L2_FBUF_FLAG_CHROMAKEY framebuffer-flags
+replace define V4L2_FBUF_FLAG_LOCAL_ALPHA framebuffer-flags
+replace define V4L2_FBUF_FLAG_GLOBAL_ALPHA framebuffer-flags
+replace define V4L2_FBUF_FLAG_LOCAL_INV_ALPHA framebuffer-flags
+replace define V4L2_FBUF_FLAG_SRC_CHROMAKEY framebuffer-flags
+
+# Used on VIDIOC_G_PARM
+
+replace define V4L2_MODE_HIGHQUALITY parm-flags
+replace define V4L2_CAP_TIMEPERFRAME v4l2-captureparm
+
+# The V4L2_STD_foo are all defined at v4l2_std_id table
+
+replace define V4L2_STD_PAL_B v4l2-std-id
+replace define V4L2_STD_PAL_B1 v4l2-std-id
+replace define V4L2_STD_PAL_G v4l2-std-id
+replace define V4L2_STD_PAL_H v4l2-std-id
+replace define V4L2_STD_PAL_I v4l2-std-id
+replace define V4L2_STD_PAL_D v4l2-std-id
+replace define V4L2_STD_PAL_D1 v4l2-std-id
+replace define V4L2_STD_PAL_K v4l2-std-id
+replace define V4L2_STD_PAL_M v4l2-std-id
+replace define V4L2_STD_PAL_N v4l2-std-id
+replace define V4L2_STD_PAL_Nc v4l2-std-id
+replace define V4L2_STD_PAL_60 v4l2-std-id
+replace define V4L2_STD_NTSC_M v4l2-std-id
+replace define V4L2_STD_NTSC_M_JP v4l2-std-id
+replace define V4L2_STD_NTSC_443 v4l2-std-id
+replace define V4L2_STD_NTSC_M_KR v4l2-std-id
+replace define V4L2_STD_SECAM_B v4l2-std-id
+replace define V4L2_STD_SECAM_D v4l2-std-id
+replace define V4L2_STD_SECAM_G v4l2-std-id
+replace define V4L2_STD_SECAM_H v4l2-std-id
+replace define V4L2_STD_SECAM_K v4l2-std-id
+replace define V4L2_STD_SECAM_K1 v4l2-std-id
+replace define V4L2_STD_SECAM_L v4l2-std-id
+replace define V4L2_STD_SECAM_LC v4l2-std-id
+replace define V4L2_STD_ATSC_8_VSB v4l2-std-id
+replace define V4L2_STD_ATSC_16_VSB v4l2-std-id
+replace define V4L2_STD_NTSC v4l2-std-id
+replace define V4L2_STD_SECAM_DK v4l2-std-id
+replace define V4L2_STD_SECAM v4l2-std-id
+replace define V4L2_STD_PAL_BG v4l2-std-id
+replace define V4L2_STD_PAL_DK v4l2-std-id
+replace define V4L2_STD_PAL v4l2-std-id
+replace define V4L2_STD_B v4l2-std-id
+replace define V4L2_STD_G v4l2-std-id
+replace define V4L2_STD_H v4l2-std-id
+replace define V4L2_STD_L v4l2-std-id
+replace define V4L2_STD_GH v4l2-std-id
+replace define V4L2_STD_DK v4l2-std-id
+replace define V4L2_STD_BG v4l2-std-id
+replace define V4L2_STD_MN v4l2-std-id
+replace define V4L2_STD_MTS v4l2-std-id
+replace define V4L2_STD_525_60 v4l2-std-id
+replace define V4L2_STD_625_50 v4l2-std-id
+replace define V4L2_STD_ATSC v4l2-std-id
+replace define V4L2_STD_UNKNOWN v4l2-std-id
+replace define V4L2_STD_ALL v4l2-std-id
+
+# V4L2 DT BT timings definitions
+
+replace define V4L2_DV_PROGRESSIVE v4l2-bt-timings
+replace define V4L2_DV_INTERLACED v4l2-bt-timings
+
+replace define V4L2_DV_VSYNC_POS_POL v4l2-bt-timings
+replace define V4L2_DV_HSYNC_POS_POL v4l2-bt-timings
+
+replace define V4L2_DV_BT_STD_CEA861 dv-bt-standards
+replace define V4L2_DV_BT_STD_DMT dv-bt-standards
+replace define V4L2_DV_BT_STD_CVT dv-bt-standards
+replace define V4L2_DV_BT_STD_GTF dv-bt-standards
+
+replace define V4L2_DV_FL_REDUCED_BLANKING dv-bt-standards
+replace define V4L2_DV_FL_CAN_REDUCE_FPS dv-bt-standards
+replace define V4L2_DV_FL_REDUCED_FPS dv-bt-standards
+replace define V4L2_DV_FL_HALF_LINE dv-bt-standards
+replace define V4L2_DV_FL_IS_CE_VIDEO dv-bt-standards
+
+replace define V4L2_DV_BT_656_1120 dv-timing-types
+
+replace define V4L2_DV_BT_CAP_INTERLACED framebuffer-cap
+replace define V4L2_DV_BT_CAP_PROGRESSIVE framebuffer-cap
+replace define V4L2_DV_BT_CAP_REDUCED_BLANKING framebuffer-cap
+replace define V4L2_DV_BT_CAP_CUSTOM framebuffer-cap
+
+# V4L2 input
+
+replace define V4L2_INPUT_TYPE_TUNER input-type
+replace define V4L2_INPUT_TYPE_CAMERA input-type
+
+replace define V4L2_IN_ST_NO_POWER input-status
+replace define V4L2_IN_ST_NO_SIGNAL input-status
+replace define V4L2_IN_ST_NO_COLOR input-status
+replace define V4L2_IN_ST_HFLIP input-status
+replace define V4L2_IN_ST_VFLIP input-status
+replace define V4L2_IN_ST_NO_H_LOCK input-status
+replace define V4L2_IN_ST_COLOR_KILL input-status
+replace define V4L2_IN_ST_NO_SYNC input-status
+replace define V4L2_IN_ST_NO_EQU input-status
+replace define V4L2_IN_ST_NO_CARRIER input-status
+replace define V4L2_IN_ST_MACROVISION input-status
+replace define V4L2_IN_ST_NO_ACCESS input-status
+replace define V4L2_IN_ST_VTR input-status
+
+replace define V4L2_IN_CAP_DV_TIMINGS input-capabilities
+replace define V4L2_IN_CAP_STD input-capabilities
+replace define V4L2_IN_CAP_NATIVE_SIZE input-capabilities
+
+# V4L2 output
+
+replace define V4L2_OUTPUT_TYPE_MODULATOR output-type
+replace define V4L2_OUTPUT_TYPE_ANALOG output-type
+replace define V4L2_OUTPUT_TYPE_ANALOGVGAOVERLAY output-type
+
+replace define V4L2_OUT_CAP_DV_TIMINGS output-capabilities
+replace define V4L2_OUT_CAP_STD output-capabilities
+replace define V4L2_OUT_CAP_NATIVE_SIZE output-capabilities
+
+# V4L2 control flags
+
+replace define V4L2_CTRL_FLAG_DISABLED control-flags
+replace define V4L2_CTRL_FLAG_GRABBED control-flags
+replace define V4L2_CTRL_FLAG_READ_ONLY control-flags
+replace define V4L2_CTRL_FLAG_UPDATE control-flags
+replace define V4L2_CTRL_FLAG_INACTIVE control-flags
+replace define V4L2_CTRL_FLAG_SLIDER control-flags
+replace define V4L2_CTRL_FLAG_WRITE_ONLY control-flags
+replace define V4L2_CTRL_FLAG_VOLATILE control-flags
+replace define V4L2_CTRL_FLAG_HAS_PAYLOAD control-flags
+replace define V4L2_CTRL_FLAG_EXECUTE_ON_WRITE control-flags
+
+replace define V4L2_CTRL_FLAG_NEXT_CTRL control
+replace define V4L2_CTRL_FLAG_NEXT_COMPOUND control
+replace define V4L2_CID_PRIVATE_BASE control
+
+# V4L2 tuner
+
+replace define V4L2_TUNER_CAP_LOW tuner-capability
+replace define V4L2_TUNER_CAP_NORM tuner-capability
+replace define V4L2_TUNER_CAP_HWSEEK_BOUNDED tuner-capability
+replace define V4L2_TUNER_CAP_HWSEEK_WRAP tuner-capability
+replace define V4L2_TUNER_CAP_STEREO tuner-capability
+replace define V4L2_TUNER_CAP_LANG2 tuner-capability
+replace define V4L2_TUNER_CAP_SAP tuner-capability
+replace define V4L2_TUNER_CAP_LANG1 tuner-capability
+replace define V4L2_TUNER_CAP_RDS tuner-capability
+replace define V4L2_TUNER_CAP_RDS_BLOCK_IO tuner-capability
+replace define V4L2_TUNER_CAP_RDS_CONTROLS tuner-capability
+replace define V4L2_TUNER_CAP_FREQ_BANDS tuner-capability
+replace define V4L2_TUNER_CAP_HWSEEK_PROG_LIM tuner-capability
+replace define V4L2_TUNER_CAP_1HZ tuner-capability
+
+replace define V4L2_TUNER_SUB_MONO tuner-rxsubchans
+replace define V4L2_TUNER_SUB_STEREO tuner-rxsubchans
+replace define V4L2_TUNER_SUB_LANG2 tuner-rxsubchans
+replace define V4L2_TUNER_SUB_SAP tuner-rxsubchans
+replace define V4L2_TUNER_SUB_LANG1 tuner-rxsubchans
+replace define V4L2_TUNER_SUB_RDS tuner-rxsubchans
+
+replace define V4L2_TUNER_MODE_MONO tuner-audmode
+replace define V4L2_TUNER_MODE_STEREO tuner-audmode
+replace define V4L2_TUNER_MODE_LANG2 tuner-audmode
+replace define V4L2_TUNER_MODE_SAP tuner-audmode
+replace define V4L2_TUNER_MODE_LANG1 tuner-audmode
+replace define V4L2_TUNER_MODE_LANG1_LANG2 tuner-audmode
+
+replace define V4L2_BAND_MODULATION_VSB band-modulation
+replace define V4L2_BAND_MODULATION_FM band-modulation
+replace define V4L2_BAND_MODULATION_AM band-modulation
+
+replace define V4L2_RDS_BLOCK_MSK v4l2-rds-block
+replace define V4L2_RDS_BLOCK_A v4l2-rds-block
+replace define V4L2_RDS_BLOCK_B v4l2-rds-block
+replace define V4L2_RDS_BLOCK_C v4l2-rds-block
+replace define V4L2_RDS_BLOCK_D v4l2-rds-block
+replace define V4L2_RDS_BLOCK_C_ALT v4l2-rds-block
+replace define V4L2_RDS_BLOCK_INVALID v4l2-rds-block
+replace define V4L2_RDS_BLOCK_CORRECTED v4l2-rds-block
+replace define V4L2_RDS_BLOCK_ERROR v4l2-rds-block
+
+# V4L2 audio
+
+replace define V4L2_AUDCAP_STEREO audio-capability
+replace define V4L2_AUDCAP_AVL audio-capability
+
+replace define V4L2_AUDMODE_AVL audio-mode
+
+# MPEG
+
+replace define V4L2_ENC_IDX_FRAME_I v4l2-enc-idx
+replace define V4L2_ENC_IDX_FRAME_P v4l2-enc-idx
+replace define V4L2_ENC_IDX_FRAME_B v4l2-enc-idx
+replace define V4L2_ENC_IDX_FRAME_MASK v4l2-enc-idx
+replace define V4L2_ENC_IDX_ENTRIES v4l2-enc-idx
+
+replace define V4L2_ENC_CMD_START encoder-cmds
+replace define V4L2_ENC_CMD_STOP encoder-cmds
+replace define V4L2_ENC_CMD_PAUSE encoder-cmds
+replace define V4L2_ENC_CMD_RESUME encoder-cmds
+
+replace define V4L2_ENC_CMD_STOP_AT_GOP_END encoder-flags
+
+replace define V4L2_DEC_CMD_START decoder-cmds
+replace define V4L2_DEC_CMD_STOP decoder-cmds
+replace define V4L2_DEC_CMD_PAUSE decoder-cmds
+replace define V4L2_DEC_CMD_RESUME decoder-cmds
+
+replace define V4L2_DEC_CMD_START_MUTE_AUDIO decoder-cmds
+replace define V4L2_DEC_CMD_PAUSE_TO_BLACK decoder-cmds
+replace define V4L2_DEC_CMD_STOP_TO_BLACK decoder-cmds
+replace define V4L2_DEC_CMD_STOP_IMMEDIATELY decoder-cmds
+
+replace define V4L2_DEC_START_FMT_NONE decoder-cmds
+replace define V4L2_DEC_START_FMT_GOP decoder-cmds
+
+# V4L2 VBI
+
+replace define V4L2_VBI_UNSYNC vbifmt-flags
+replace define V4L2_VBI_INTERLACED vbifmt-flags
+
+replace define V4L2_VBI_ITU_525_F1_START v4l2-vbi-format
+replace define V4L2_VBI_ITU_525_F2_START v4l2-vbi-format
+replace define V4L2_VBI_ITU_625_F1_START v4l2-vbi-format
+replace define V4L2_VBI_ITU_625_F2_START v4l2-vbi-format
+
+
+replace define V4L2_SLICED_TELETEXT_B vbi-services
+replace define V4L2_SLICED_VPS vbi-services
+replace define V4L2_SLICED_CAPTION_525 vbi-services
+replace define V4L2_SLICED_WSS_625 vbi-services
+replace define V4L2_SLICED_VBI_525 vbi-services
+replace define V4L2_SLICED_VBI_625 vbi-services
+
+replace define V4L2_MPEG_VBI_IVTV_TELETEXT_B ITV0-Line-Identifier-Constants
+replace define V4L2_MPEG_VBI_IVTV_CAPTION_525 ITV0-Line-Identifier-Constants
+replace define V4L2_MPEG_VBI_IVTV_WSS_625 ITV0-Line-Identifier-Constants
+replace define V4L2_MPEG_VBI_IVTV_VPS ITV0-Line-Identifier-Constants
+
+replace define V4L2_MPEG_VBI_IVTV_MAGIC0 v4l2-mpeg-vbi-fmt-ivtv-magic
+replace define V4L2_MPEG_VBI_IVTV_MAGIC1 v4l2-mpeg-vbi-fmt-ivtv-magic
+
+# V4L2 events
+
+replace define V4L2_EVENT_ALL event-type
+replace define V4L2_EVENT_VSYNC event-type
+replace define V4L2_EVENT_EOS event-type
+replace define V4L2_EVENT_CTRL event-type
+replace define V4L2_EVENT_FRAME_SYNC event-type
+replace define V4L2_EVENT_SOURCE_CHANGE event-type
+replace define V4L2_EVENT_MOTION_DET event-type
+replace define V4L2_EVENT_PRIVATE_START event-type
+
+replace define V4L2_EVENT_CTRL_CH_VALUE ctrl-changes-flags
+replace define V4L2_EVENT_CTRL_CH_FLAGS ctrl-changes-flags
+replace define V4L2_EVENT_CTRL_CH_RANGE ctrl-changes-flags
+
+replace define V4L2_EVENT_SRC_CH_RESOLUTION src-changes-flags
+
+replace define V4L2_EVENT_MD_FL_HAVE_FRAME_SEQ v4l2-event-motion-det
+
+replace define V4L2_EVENT_SUB_FL_SEND_INITIAL event-flags
+replace define V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK event-flags
+
+# V4L2 debugging
+replace define V4L2_CHIP_MATCH_BRIDGE vidioc_dbg_g_register
+replace define V4L2_CHIP_MATCH_SUBDEV vidioc_dbg_g_register
+replace define V4L2_CHIP_MATCH_HOST vidioc_dbg_g_register
+replace define V4L2_CHIP_MATCH_I2C_DRIVER vidioc_dbg_g_register
+replace define V4L2_CHIP_MATCH_I2C_ADDR vidioc_dbg_g_register
+replace define V4L2_CHIP_MATCH_AC97 vidioc_dbg_g_register
+
+replace define V4L2_CHIP_FL_READABLE vidioc_dbg_g_register
+replace define V4L2_CHIP_FL_WRITABLE vidioc_dbg_g_register
+
+# Ignore reserved ioctl and ancillary macros
+
+ignore define VIDEO_MAX_FRAME
+ignore define VIDEO_MAX_PLANES
+ignore define v4l2_fourcc
+ignore define v4l2_fourcc_be
+ignore define V4L2_FIELD_HAS_TOP
+ignore define V4L2_FIELD_HAS_BOTTOM
+ignore define V4L2_FIELD_HAS_BOTH
+ignore define V4L2_FIELD_HAS_T_OR_B
+ignore define V4L2_TYPE_IS_MULTIPLANAR
+ignore define V4L2_TYPE_IS_OUTPUT
+ignore define V4L2_TUNER_ADC
+ignore define V4L2_MAP_COLORSPACE_DEFAULT
+ignore define V4L2_MAP_XFER_FUNC_DEFAULT
+ignore define V4L2_MAP_YCBCR_ENC_DEFAULT
+ignore define V4L2_DV_BT_BLANKING_WIDTH
+ignore define V4L2_DV_BT_FRAME_WIDTH
+ignore define V4L2_DV_BT_BLANKING_HEIGHT
+ignore define V4L2_DV_BT_FRAME_HEIGHT
+ignore define V4L2_IN_CAP_CUSTOM_TIMINGS
+ignore define V4L2_CTRL_ID_MASK
+ignore define V4L2_CTRL_ID2CLASS
+ignore define V4L2_CTRL_ID2WHICH
+ignore define V4L2_CTRL_DRIVER_PRIV
+ignore define V4L2_CTRL_MAX_DIMS
+ignore define V4L2_CTRL_WHICH_CUR_VAL
+ignore define V4L2_CTRL_WHICH_DEF_VAL
+ignore define V4L2_OUT_CAP_CUSTOM_TIMINGS
+ignore define V4L2_CID_MAX_CTRLS
+
+ignore ioctl VIDIOC_RESERVED
+ignore define BASE_VIDIOC_PRIVATE
+
+# Associate ioctls with their counterparts
+replace ioctl VIDIOC_DBG_S_REGISTER vidioc_dbg_g_register
+replace ioctl VIDIOC_DQBUF vidioc_qbuf
+replace ioctl VIDIOC_S_AUDOUT vidioc_g_audout
+replace ioctl VIDIOC_S_CROP vidioc_g_crop
+replace ioctl VIDIOC_S_CTRL vidioc_g_ctrl
+replace ioctl VIDIOC_S_DV_TIMINGS vidioc_g_dv_timings
+replace ioctl VIDIOC_S_EDID vidioc_g_edid
+replace ioctl VIDIOC_S_EXT_CTRLS vidioc_g_ext_ctrls
+replace ioctl VIDIOC_S_FBUF vidioc_g_fbuf
+replace ioctl VIDIOC_S_FMT vidioc_g_fmt
+replace ioctl VIDIOC_S_FREQUENCY vidioc_g_frequency
+replace ioctl VIDIOC_S_INPUT vidioc_g_input
+replace ioctl VIDIOC_S_JPEGCOMP vidioc_g_jpegcomp
+replace ioctl VIDIOC_S_MODULATOR vidioc_g_modulator
+replace ioctl VIDIOC_S_OUTPUT vidioc_g_output
+replace ioctl VIDIOC_S_PARM vidioc_g_parm
+replace ioctl VIDIOC_S_PRIORITY vidioc_g_priority
+replace ioctl VIDIOC_S_SELECTION vidioc_g_selection
+replace ioctl VIDIOC_S_STD vidioc_g_std
+replace ioctl VIDIOC_S_AUDIO vidioc_g_audio
+replace ioctl VIDIOC_S_TUNER vidioc_g_tuner
+replace ioctl VIDIOC_TRY_DECODER_CMD vidioc_decoder_cmd
+replace ioctl VIDIOC_TRY_ENCODER_CMD vidioc_encoder_cmd
+replace ioctl VIDIOC_TRY_EXT_CTRLS vidioc_g_ext_ctrls
+replace ioctl VIDIOC_TRY_FMT vidioc_g_fmt
+replace ioctl VIDIOC_STREAMOFF vidioc_streamon
+replace ioctl VIDIOC_QUERY_EXT_CTRL vidioc_queryctrl
+replace ioctl VIDIOC_QUERYMENU vidioc_queryctrl
diff --git a/Documentation/media/video.h.rst.exceptions b/Documentation/media/video.h.rst.exceptions
deleted file mode 100644
index 8866145..0000000
--- a/Documentation/media/video.h.rst.exceptions
+++ /dev/null
@@ -1,40 +0,0 @@
-# Ignore header name
-ignore define _UAPI_DVBVIDEO_H_
-
-# This is a deprecated obscure API. Just ignore things we don't know
-ignore define VIDEO_CMD_PLAY
-ignore define VIDEO_CMD_STOP
-ignore define VIDEO_CMD_FREEZE
-ignore define VIDEO_CMD_CONTINUE
-ignore define VIDEO_CMD_FREEZE_TO_BLACK
-ignore define VIDEO_CMD_STOP_TO_BLACK
-ignore define VIDEO_CMD_STOP_IMMEDIATELY
-ignore define VIDEO_PLAY_FMT_NONE
-ignore define VIDEO_PLAY_FMT_GOP
-ignore define VIDEO_VSYNC_FIELD_UNKNOWN
-ignore define VIDEO_VSYNC_FIELD_ODD
-ignore define VIDEO_VSYNC_FIELD_EVEN
-ignore define VIDEO_VSYNC_FIELD_PROGRESSIVE
-ignore define VIDEO_EVENT_SIZE_CHANGED
-ignore define VIDEO_EVENT_FRAME_RATE_CHANGED
-ignore define VIDEO_EVENT_DECODER_STOPPED
-ignore define VIDEO_EVENT_VSYNC
-ignore define VIDEO_CAP_MPEG1
-ignore define VIDEO_CAP_MPEG2
-ignore define VIDEO_CAP_SYS
-ignore define VIDEO_CAP_PROG
-ignore define VIDEO_CAP_SPU
-ignore define VIDEO_CAP_NAVI
-ignore define VIDEO_CAP_CSS
-
-# some typedefs should point to struct/enums
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
diff --git a/Documentation/media/videodev2.h.rst.exceptions b/Documentation/media/videodev2.h.rst.exceptions
deleted file mode 100644
index 9bb9a6c..0000000
--- a/Documentation/media/videodev2.h.rst.exceptions
+++ /dev/null
@@ -1,535 +0,0 @@
-# Ignore header name
-ignore define _UAPI__LINUX_VIDEODEV2_H
-
-#
-# The cross reference valitator for videodev2.h DocBook never cared
-# about enum symbols or defines. Yet, they're all (or almost all?)
-# handled inside V4L API sections. So, for now, it is safe to just
-# ignore. This should be revisited, as validating it helps to avoid
-# having something not documented at the uAPI.
-#
-
-# Those symbols should not be used by uAPI - don't document them
-ignore symbol V4L2_BUF_TYPE_PRIVATE
-ignore symbol V4L2_TUNER_DIGITAL_TV
-ignore symbol V4L2_COLORSPACE_BT878
-
-# Documented enum v4l2_field
-replace symbol V4L2_FIELD_ALTERNATE v4l2-field
-replace symbol V4L2_FIELD_ANY v4l2-field
-replace symbol V4L2_FIELD_BOTTOM v4l2-field
-replace symbol V4L2_FIELD_INTERLACED v4l2-field
-replace symbol V4L2_FIELD_INTERLACED_BT v4l2-field
-replace symbol V4L2_FIELD_INTERLACED_TB v4l2-field
-replace symbol V4L2_FIELD_NONE v4l2-field
-replace symbol V4L2_FIELD_SEQ_BT v4l2-field
-replace symbol V4L2_FIELD_SEQ_TB v4l2-field
-replace symbol V4L2_FIELD_TOP v4l2-field
-
-# Documented enum v4l2_buf_type
-replace symbol V4L2_BUF_TYPE_SDR_CAPTURE v4l2-buf-type
-replace symbol V4L2_BUF_TYPE_SDR_OUTPUT v4l2-buf-type
-replace symbol V4L2_BUF_TYPE_SLICED_VBI_CAPTURE v4l2-buf-type
-replace symbol V4L2_BUF_TYPE_SLICED_VBI_OUTPUT v4l2-buf-type
-replace symbol V4L2_BUF_TYPE_VBI_CAPTURE v4l2-buf-type
-replace symbol V4L2_BUF_TYPE_VBI_OUTPUT v4l2-buf-type
-replace symbol V4L2_BUF_TYPE_VIDEO_CAPTURE v4l2-buf-type
-replace symbol V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE v4l2-buf-type
-replace symbol V4L2_BUF_TYPE_VIDEO_OUTPUT v4l2-buf-type
-replace symbol V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE v4l2-buf-type
-replace symbol V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY v4l2-buf-type
-replace symbol V4L2_BUF_TYPE_VIDEO_OVERLAY v4l2-buf-type
-
-# Documented enum v4l2_tuner_type
-replace symbol V4L2_TUNER_ANALOG_TV v4l2-tuner-type
-replace symbol V4L2_TUNER_RADIO v4l2-tuner-type
-replace symbol V4L2_TUNER_RF v4l2-tuner-type
-replace symbol V4L2_TUNER_SDR v4l2-tuner-type
-
-# Documented enum v4l2_memory
-replace symbol V4L2_MEMORY_DMABUF v4l2-memory
-replace symbol V4L2_MEMORY_MMAP v4l2-memory
-replace symbol V4L2_MEMORY_OVERLAY v4l2-memory
-replace symbol V4L2_MEMORY_USERPTR v4l2-memory
-
-# Documented enum v4l2_colorspace
-replace symbol V4L2_COLORSPACE_470_SYSTEM_BG v4l2-colorspace
-replace symbol V4L2_COLORSPACE_470_SYSTEM_M v4l2-colorspace
-replace symbol V4L2_COLORSPACE_ADOBERGB v4l2-colorspace
-replace symbol V4L2_COLORSPACE_BT2020 v4l2-colorspace
-replace symbol V4L2_COLORSPACE_DCI_P3 v4l2-colorspace
-replace symbol V4L2_COLORSPACE_DEFAULT v4l2-colorspace
-replace symbol V4L2_COLORSPACE_JPEG v4l2-colorspace
-replace symbol V4L2_COLORSPACE_RAW v4l2-colorspace
-replace symbol V4L2_COLORSPACE_REC709 v4l2-colorspace
-replace symbol V4L2_COLORSPACE_SMPTE170M v4l2-colorspace
-replace symbol V4L2_COLORSPACE_SMPTE240M v4l2-colorspace
-replace symbol V4L2_COLORSPACE_SRGB v4l2-colorspace
-
-# Documented enum v4l2_xfer_func
-replace symbol V4L2_XFER_FUNC_709 v4l2-xfer-func
-replace symbol V4L2_XFER_FUNC_ADOBERGB v4l2-xfer-func
-replace symbol V4L2_XFER_FUNC_DCI_P3 v4l2-xfer-func
-replace symbol V4L2_XFER_FUNC_DEFAULT v4l2-xfer-func
-replace symbol V4L2_XFER_FUNC_NONE v4l2-xfer-func
-replace symbol V4L2_XFER_FUNC_SMPTE2084 v4l2-xfer-func
-replace symbol V4L2_XFER_FUNC_SMPTE240M v4l2-xfer-func
-replace symbol V4L2_XFER_FUNC_SRGB v4l2-xfer-func
-
-# Documented enum v4l2_ycbcr_encoding
-replace symbol V4L2_YCBCR_ENC_601 v4l2-ycbcr-encoding
-replace symbol V4L2_YCBCR_ENC_709 v4l2-ycbcr-encoding
-replace symbol V4L2_YCBCR_ENC_BT2020 v4l2-ycbcr-encoding
-replace symbol V4L2_YCBCR_ENC_BT2020_CONST_LUM v4l2-ycbcr-encoding
-replace symbol V4L2_YCBCR_ENC_DEFAULT v4l2-ycbcr-encoding
-replace symbol V4L2_YCBCR_ENC_SYCC v4l2-ycbcr-encoding
-replace symbol V4L2_YCBCR_ENC_XV601 v4l2-ycbcr-encoding
-replace symbol V4L2_YCBCR_ENC_XV709 v4l2-ycbcr-encoding
-replace symbol V4L2_YCBCR_ENC_SMPTE240M v4l2-ycbcr-encoding
-
-# Documented enum v4l2_quantization
-replace symbol V4L2_QUANTIZATION_DEFAULT v4l2-quantization
-replace symbol V4L2_QUANTIZATION_FULL_RANGE v4l2-quantization
-replace symbol V4L2_QUANTIZATION_LIM_RANGE v4l2-quantization
-
-# Documented enum v4l2_priority
-replace symbol V4L2_PRIORITY_BACKGROUND v4l2-priority
-replace symbol V4L2_PRIORITY_DEFAULT v4l2-priority
-replace symbol V4L2_PRIORITY_INTERACTIVE v4l2-priority
-replace symbol V4L2_PRIORITY_RECORD v4l2-priority
-replace symbol V4L2_PRIORITY_UNSET v4l2-priority
-
-# Documented enum v4l2_frmsizetypes
-replace symbol V4L2_FRMSIZE_TYPE_CONTINUOUS v4l2-frmsizetypes
-replace symbol V4L2_FRMSIZE_TYPE_DISCRETE v4l2-frmsizetypes
-replace symbol V4L2_FRMSIZE_TYPE_STEPWISE v4l2-frmsizetypes
-
-# Documented enum frmivaltypes
-replace symbol V4L2_FRMIVAL_TYPE_CONTINUOUS v4l2-frmivaltypes
-replace symbol V4L2_FRMIVAL_TYPE_DISCRETE v4l2-frmivaltypes
-replace symbol V4L2_FRMIVAL_TYPE_STEPWISE v4l2-frmivaltypes
-
-# Documented enum v4l2-ctrl-type
-replace symbol V4L2_CTRL_COMPOUND_TYPES vidioc_queryctrl
-
-replace symbol V4L2_CTRL_TYPE_BITMASK v4l2-ctrl-type
-replace symbol V4L2_CTRL_TYPE_BOOLEAN v4l2-ctrl-type
-replace symbol V4L2_CTRL_TYPE_BUTTON v4l2-ctrl-type
-replace symbol V4L2_CTRL_TYPE_CTRL_CLASS v4l2-ctrl-type
-replace symbol V4L2_CTRL_TYPE_INTEGER v4l2-ctrl-type
-replace symbol V4L2_CTRL_TYPE_INTEGER64 v4l2-ctrl-type
-replace symbol V4L2_CTRL_TYPE_INTEGER_MENU v4l2-ctrl-type
-replace symbol V4L2_CTRL_TYPE_MENU v4l2-ctrl-type
-replace symbol V4L2_CTRL_TYPE_STRING v4l2-ctrl-type
-replace symbol V4L2_CTRL_TYPE_U16 v4l2-ctrl-type
-replace symbol V4L2_CTRL_TYPE_U32 v4l2-ctrl-type
-replace symbol V4L2_CTRL_TYPE_U8 v4l2-ctrl-type
-
-# V4L2 capability defines
-replace define V4L2_CAP_VIDEO_CAPTURE device-capabilities
-replace define V4L2_CAP_VIDEO_CAPTURE_MPLANE device-capabilities
-replace define V4L2_CAP_VIDEO_OUTPUT device-capabilities
-replace define V4L2_CAP_VIDEO_OUTPUT_MPLANE device-capabilities
-replace define V4L2_CAP_VIDEO_M2M device-capabilities
-replace define V4L2_CAP_VIDEO_M2M_MPLANE device-capabilities
-replace define V4L2_CAP_VIDEO_OVERLAY device-capabilities
-replace define V4L2_CAP_VBI_CAPTURE device-capabilities
-replace define V4L2_CAP_VBI_OUTPUT device-capabilities
-replace define V4L2_CAP_SLICED_VBI_CAPTURE device-capabilities
-replace define V4L2_CAP_SLICED_VBI_OUTPUT device-capabilities
-replace define V4L2_CAP_RDS_CAPTURE device-capabilities
-replace define V4L2_CAP_VIDEO_OUTPUT_OVERLAY device-capabilities
-replace define V4L2_CAP_HW_FREQ_SEEK device-capabilities
-replace define V4L2_CAP_RDS_OUTPUT device-capabilities
-replace define V4L2_CAP_TUNER device-capabilities
-replace define V4L2_CAP_AUDIO device-capabilities
-replace define V4L2_CAP_RADIO device-capabilities
-replace define V4L2_CAP_MODULATOR device-capabilities
-replace define V4L2_CAP_SDR_CAPTURE device-capabilities
-replace define V4L2_CAP_EXT_PIX_FORMAT device-capabilities
-replace define V4L2_CAP_SDR_OUTPUT device-capabilities
-replace define V4L2_CAP_READWRITE device-capabilities
-replace define V4L2_CAP_ASYNCIO device-capabilities
-replace define V4L2_CAP_STREAMING device-capabilities
-replace define V4L2_CAP_DEVICE_CAPS device-capabilities
-
-# V4L2 pix flags
-replace define V4L2_PIX_FMT_PRIV_MAGIC v4l2-pix-format
-replace define V4L2_PIX_FMT_FLAG_PREMUL_ALPHA reserved-formats
-
-# V4L2 format flags
-replace define V4L2_FMT_FLAG_COMPRESSED fmtdesc-flags
-replace define V4L2_FMT_FLAG_EMULATED fmtdesc-flags
-
-# V4L2 tymecode types
-replace define V4L2_TC_TYPE_24FPS timecode-type
-replace define V4L2_TC_TYPE_25FPS timecode-type
-replace define V4L2_TC_TYPE_30FPS timecode-type
-replace define V4L2_TC_TYPE_50FPS timecode-type
-replace define V4L2_TC_TYPE_60FPS timecode-type
-
-# V4L2 tymecode flags
-replace define V4L2_TC_FLAG_DROPFRAME timecode-flags
-replace define V4L2_TC_FLAG_COLORFRAME timecode-flags
-replace define V4L2_TC_USERBITS_field timecode-flags
-replace define V4L2_TC_USERBITS_USERDEFINED timecode-flags
-replace define V4L2_TC_USERBITS_8BITCHARS timecode-flags
-
-# V4L2 JPEG markers
-replace define V4L2_JPEG_MARKER_DHT jpeg-markers
-replace define V4L2_JPEG_MARKER_DQT jpeg-markers
-replace define V4L2_JPEG_MARKER_DRI jpeg-markers
-replace define V4L2_JPEG_MARKER_COM jpeg-markers
-replace define V4L2_JPEG_MARKER_APP jpeg-markers
-
-# V4L2 framebuffer caps and flags
-
-replace define V4L2_FBUF_CAP_EXTERNOVERLAY framebuffer-cap
-replace define V4L2_FBUF_CAP_CHROMAKEY framebuffer-cap
-replace define V4L2_FBUF_CAP_LIST_CLIPPING framebuffer-cap
-replace define V4L2_FBUF_CAP_BITMAP_CLIPPING framebuffer-cap
-replace define V4L2_FBUF_CAP_LOCAL_ALPHA framebuffer-cap
-replace define V4L2_FBUF_CAP_GLOBAL_ALPHA framebuffer-cap
-replace define V4L2_FBUF_CAP_LOCAL_INV_ALPHA framebuffer-cap
-replace define V4L2_FBUF_CAP_SRC_CHROMAKEY framebuffer-cap
-
-replace define V4L2_FBUF_FLAG_PRIMARY framebuffer-flags
-replace define V4L2_FBUF_FLAG_OVERLAY framebuffer-flags
-replace define V4L2_FBUF_FLAG_CHROMAKEY framebuffer-flags
-replace define V4L2_FBUF_FLAG_LOCAL_ALPHA framebuffer-flags
-replace define V4L2_FBUF_FLAG_GLOBAL_ALPHA framebuffer-flags
-replace define V4L2_FBUF_FLAG_LOCAL_INV_ALPHA framebuffer-flags
-replace define V4L2_FBUF_FLAG_SRC_CHROMAKEY framebuffer-flags
-
-# Used on VIDIOC_G_PARM
-
-replace define V4L2_MODE_HIGHQUALITY parm-flags
-replace define V4L2_CAP_TIMEPERFRAME v4l2-captureparm
-
-# The V4L2_STD_foo are all defined at v4l2_std_id table
-
-replace define V4L2_STD_PAL_B v4l2-std-id
-replace define V4L2_STD_PAL_B1 v4l2-std-id
-replace define V4L2_STD_PAL_G v4l2-std-id
-replace define V4L2_STD_PAL_H v4l2-std-id
-replace define V4L2_STD_PAL_I v4l2-std-id
-replace define V4L2_STD_PAL_D v4l2-std-id
-replace define V4L2_STD_PAL_D1 v4l2-std-id
-replace define V4L2_STD_PAL_K v4l2-std-id
-replace define V4L2_STD_PAL_M v4l2-std-id
-replace define V4L2_STD_PAL_N v4l2-std-id
-replace define V4L2_STD_PAL_Nc v4l2-std-id
-replace define V4L2_STD_PAL_60 v4l2-std-id
-replace define V4L2_STD_NTSC_M v4l2-std-id
-replace define V4L2_STD_NTSC_M_JP v4l2-std-id
-replace define V4L2_STD_NTSC_443 v4l2-std-id
-replace define V4L2_STD_NTSC_M_KR v4l2-std-id
-replace define V4L2_STD_SECAM_B v4l2-std-id
-replace define V4L2_STD_SECAM_D v4l2-std-id
-replace define V4L2_STD_SECAM_G v4l2-std-id
-replace define V4L2_STD_SECAM_H v4l2-std-id
-replace define V4L2_STD_SECAM_K v4l2-std-id
-replace define V4L2_STD_SECAM_K1 v4l2-std-id
-replace define V4L2_STD_SECAM_L v4l2-std-id
-replace define V4L2_STD_SECAM_LC v4l2-std-id
-replace define V4L2_STD_ATSC_8_VSB v4l2-std-id
-replace define V4L2_STD_ATSC_16_VSB v4l2-std-id
-replace define V4L2_STD_NTSC v4l2-std-id
-replace define V4L2_STD_SECAM_DK v4l2-std-id
-replace define V4L2_STD_SECAM v4l2-std-id
-replace define V4L2_STD_PAL_BG v4l2-std-id
-replace define V4L2_STD_PAL_DK v4l2-std-id
-replace define V4L2_STD_PAL v4l2-std-id
-replace define V4L2_STD_B v4l2-std-id
-replace define V4L2_STD_G v4l2-std-id
-replace define V4L2_STD_H v4l2-std-id
-replace define V4L2_STD_L v4l2-std-id
-replace define V4L2_STD_GH v4l2-std-id
-replace define V4L2_STD_DK v4l2-std-id
-replace define V4L2_STD_BG v4l2-std-id
-replace define V4L2_STD_MN v4l2-std-id
-replace define V4L2_STD_MTS v4l2-std-id
-replace define V4L2_STD_525_60 v4l2-std-id
-replace define V4L2_STD_625_50 v4l2-std-id
-replace define V4L2_STD_ATSC v4l2-std-id
-replace define V4L2_STD_UNKNOWN v4l2-std-id
-replace define V4L2_STD_ALL v4l2-std-id
-
-# V4L2 DT BT timings definitions
-
-replace define V4L2_DV_PROGRESSIVE v4l2-bt-timings
-replace define V4L2_DV_INTERLACED v4l2-bt-timings
-
-replace define V4L2_DV_VSYNC_POS_POL v4l2-bt-timings
-replace define V4L2_DV_HSYNC_POS_POL v4l2-bt-timings
-
-replace define V4L2_DV_BT_STD_CEA861 dv-bt-standards
-replace define V4L2_DV_BT_STD_DMT dv-bt-standards
-replace define V4L2_DV_BT_STD_CVT dv-bt-standards
-replace define V4L2_DV_BT_STD_GTF dv-bt-standards
-
-replace define V4L2_DV_FL_REDUCED_BLANKING dv-bt-standards
-replace define V4L2_DV_FL_CAN_REDUCE_FPS dv-bt-standards
-replace define V4L2_DV_FL_REDUCED_FPS dv-bt-standards
-replace define V4L2_DV_FL_HALF_LINE dv-bt-standards
-replace define V4L2_DV_FL_IS_CE_VIDEO dv-bt-standards
-
-replace define V4L2_DV_BT_656_1120 dv-timing-types
-
-replace define V4L2_DV_BT_CAP_INTERLACED framebuffer-cap
-replace define V4L2_DV_BT_CAP_PROGRESSIVE framebuffer-cap
-replace define V4L2_DV_BT_CAP_REDUCED_BLANKING framebuffer-cap
-replace define V4L2_DV_BT_CAP_CUSTOM framebuffer-cap
-
-# V4L2 input
-
-replace define V4L2_INPUT_TYPE_TUNER input-type
-replace define V4L2_INPUT_TYPE_CAMERA input-type
-
-replace define V4L2_IN_ST_NO_POWER input-status
-replace define V4L2_IN_ST_NO_SIGNAL input-status
-replace define V4L2_IN_ST_NO_COLOR input-status
-replace define V4L2_IN_ST_HFLIP input-status
-replace define V4L2_IN_ST_VFLIP input-status
-replace define V4L2_IN_ST_NO_H_LOCK input-status
-replace define V4L2_IN_ST_COLOR_KILL input-status
-replace define V4L2_IN_ST_NO_SYNC input-status
-replace define V4L2_IN_ST_NO_EQU input-status
-replace define V4L2_IN_ST_NO_CARRIER input-status
-replace define V4L2_IN_ST_MACROVISION input-status
-replace define V4L2_IN_ST_NO_ACCESS input-status
-replace define V4L2_IN_ST_VTR input-status
-
-replace define V4L2_IN_CAP_DV_TIMINGS input-capabilities
-replace define V4L2_IN_CAP_STD input-capabilities
-replace define V4L2_IN_CAP_NATIVE_SIZE input-capabilities
-
-# V4L2 output
-
-replace define V4L2_OUTPUT_TYPE_MODULATOR output-type
-replace define V4L2_OUTPUT_TYPE_ANALOG output-type
-replace define V4L2_OUTPUT_TYPE_ANALOGVGAOVERLAY output-type
-
-replace define V4L2_OUT_CAP_DV_TIMINGS output-capabilities
-replace define V4L2_OUT_CAP_STD output-capabilities
-replace define V4L2_OUT_CAP_NATIVE_SIZE output-capabilities
-
-# V4L2 control flags
-
-replace define V4L2_CTRL_FLAG_DISABLED control-flags
-replace define V4L2_CTRL_FLAG_GRABBED control-flags
-replace define V4L2_CTRL_FLAG_READ_ONLY control-flags
-replace define V4L2_CTRL_FLAG_UPDATE control-flags
-replace define V4L2_CTRL_FLAG_INACTIVE control-flags
-replace define V4L2_CTRL_FLAG_SLIDER control-flags
-replace define V4L2_CTRL_FLAG_WRITE_ONLY control-flags
-replace define V4L2_CTRL_FLAG_VOLATILE control-flags
-replace define V4L2_CTRL_FLAG_HAS_PAYLOAD control-flags
-replace define V4L2_CTRL_FLAG_EXECUTE_ON_WRITE control-flags
-
-replace define V4L2_CTRL_FLAG_NEXT_CTRL control
-replace define V4L2_CTRL_FLAG_NEXT_COMPOUND control
-replace define V4L2_CID_PRIVATE_BASE control
-
-# V4L2 tuner
-
-replace define V4L2_TUNER_CAP_LOW tuner-capability
-replace define V4L2_TUNER_CAP_NORM tuner-capability
-replace define V4L2_TUNER_CAP_HWSEEK_BOUNDED tuner-capability
-replace define V4L2_TUNER_CAP_HWSEEK_WRAP tuner-capability
-replace define V4L2_TUNER_CAP_STEREO tuner-capability
-replace define V4L2_TUNER_CAP_LANG2 tuner-capability
-replace define V4L2_TUNER_CAP_SAP tuner-capability
-replace define V4L2_TUNER_CAP_LANG1 tuner-capability
-replace define V4L2_TUNER_CAP_RDS tuner-capability
-replace define V4L2_TUNER_CAP_RDS_BLOCK_IO tuner-capability
-replace define V4L2_TUNER_CAP_RDS_CONTROLS tuner-capability
-replace define V4L2_TUNER_CAP_FREQ_BANDS tuner-capability
-replace define V4L2_TUNER_CAP_HWSEEK_PROG_LIM tuner-capability
-replace define V4L2_TUNER_CAP_1HZ tuner-capability
-
-replace define V4L2_TUNER_SUB_MONO tuner-rxsubchans
-replace define V4L2_TUNER_SUB_STEREO tuner-rxsubchans
-replace define V4L2_TUNER_SUB_LANG2 tuner-rxsubchans
-replace define V4L2_TUNER_SUB_SAP tuner-rxsubchans
-replace define V4L2_TUNER_SUB_LANG1 tuner-rxsubchans
-replace define V4L2_TUNER_SUB_RDS tuner-rxsubchans
-
-replace define V4L2_TUNER_MODE_MONO tuner-audmode
-replace define V4L2_TUNER_MODE_STEREO tuner-audmode
-replace define V4L2_TUNER_MODE_LANG2 tuner-audmode
-replace define V4L2_TUNER_MODE_SAP tuner-audmode
-replace define V4L2_TUNER_MODE_LANG1 tuner-audmode
-replace define V4L2_TUNER_MODE_LANG1_LANG2 tuner-audmode
-
-replace define V4L2_BAND_MODULATION_VSB band-modulation
-replace define V4L2_BAND_MODULATION_FM band-modulation
-replace define V4L2_BAND_MODULATION_AM band-modulation
-
-replace define V4L2_RDS_BLOCK_MSK v4l2-rds-block
-replace define V4L2_RDS_BLOCK_A v4l2-rds-block
-replace define V4L2_RDS_BLOCK_B v4l2-rds-block
-replace define V4L2_RDS_BLOCK_C v4l2-rds-block
-replace define V4L2_RDS_BLOCK_D v4l2-rds-block
-replace define V4L2_RDS_BLOCK_C_ALT v4l2-rds-block
-replace define V4L2_RDS_BLOCK_INVALID v4l2-rds-block
-replace define V4L2_RDS_BLOCK_CORRECTED v4l2-rds-block
-replace define V4L2_RDS_BLOCK_ERROR v4l2-rds-block
-
-# V4L2 audio
-
-replace define V4L2_AUDCAP_STEREO audio-capability
-replace define V4L2_AUDCAP_AVL audio-capability
-
-replace define V4L2_AUDMODE_AVL audio-mode
-
-# MPEG
-
-replace define V4L2_ENC_IDX_FRAME_I v4l2-enc-idx
-replace define V4L2_ENC_IDX_FRAME_P v4l2-enc-idx
-replace define V4L2_ENC_IDX_FRAME_B v4l2-enc-idx
-replace define V4L2_ENC_IDX_FRAME_MASK v4l2-enc-idx
-replace define V4L2_ENC_IDX_ENTRIES v4l2-enc-idx
-
-replace define V4L2_ENC_CMD_START encoder-cmds
-replace define V4L2_ENC_CMD_STOP encoder-cmds
-replace define V4L2_ENC_CMD_PAUSE encoder-cmds
-replace define V4L2_ENC_CMD_RESUME encoder-cmds
-
-replace define V4L2_ENC_CMD_STOP_AT_GOP_END encoder-flags
-
-replace define V4L2_DEC_CMD_START decoder-cmds
-replace define V4L2_DEC_CMD_STOP decoder-cmds
-replace define V4L2_DEC_CMD_PAUSE decoder-cmds
-replace define V4L2_DEC_CMD_RESUME decoder-cmds
-
-replace define V4L2_DEC_CMD_START_MUTE_AUDIO decoder-cmds
-replace define V4L2_DEC_CMD_PAUSE_TO_BLACK decoder-cmds
-replace define V4L2_DEC_CMD_STOP_TO_BLACK decoder-cmds
-replace define V4L2_DEC_CMD_STOP_IMMEDIATELY decoder-cmds
-
-replace define V4L2_DEC_START_FMT_NONE decoder-cmds
-replace define V4L2_DEC_START_FMT_GOP decoder-cmds
-
-# V4L2 VBI
-
-replace define V4L2_VBI_UNSYNC vbifmt-flags
-replace define V4L2_VBI_INTERLACED vbifmt-flags
-
-replace define V4L2_VBI_ITU_525_F1_START v4l2-vbi-format
-replace define V4L2_VBI_ITU_525_F2_START v4l2-vbi-format
-replace define V4L2_VBI_ITU_625_F1_START v4l2-vbi-format
-replace define V4L2_VBI_ITU_625_F2_START v4l2-vbi-format
-
-
-replace define V4L2_SLICED_TELETEXT_B vbi-services
-replace define V4L2_SLICED_VPS vbi-services
-replace define V4L2_SLICED_CAPTION_525 vbi-services
-replace define V4L2_SLICED_WSS_625 vbi-services
-replace define V4L2_SLICED_VBI_525 vbi-services
-replace define V4L2_SLICED_VBI_625 vbi-services
-
-replace define V4L2_MPEG_VBI_IVTV_TELETEXT_B ITV0-Line-Identifier-Constants
-replace define V4L2_MPEG_VBI_IVTV_CAPTION_525 ITV0-Line-Identifier-Constants
-replace define V4L2_MPEG_VBI_IVTV_WSS_625 ITV0-Line-Identifier-Constants
-replace define V4L2_MPEG_VBI_IVTV_VPS ITV0-Line-Identifier-Constants
-
-replace define V4L2_MPEG_VBI_IVTV_MAGIC0 v4l2-mpeg-vbi-fmt-ivtv-magic
-replace define V4L2_MPEG_VBI_IVTV_MAGIC1 v4l2-mpeg-vbi-fmt-ivtv-magic
-
-# V4L2 events
-
-replace define V4L2_EVENT_ALL event-type
-replace define V4L2_EVENT_VSYNC event-type
-replace define V4L2_EVENT_EOS event-type
-replace define V4L2_EVENT_CTRL event-type
-replace define V4L2_EVENT_FRAME_SYNC event-type
-replace define V4L2_EVENT_SOURCE_CHANGE event-type
-replace define V4L2_EVENT_MOTION_DET event-type
-replace define V4L2_EVENT_PRIVATE_START event-type
-
-replace define V4L2_EVENT_CTRL_CH_VALUE ctrl-changes-flags
-replace define V4L2_EVENT_CTRL_CH_FLAGS ctrl-changes-flags
-replace define V4L2_EVENT_CTRL_CH_RANGE ctrl-changes-flags
-
-replace define V4L2_EVENT_SRC_CH_RESOLUTION src-changes-flags
-
-replace define V4L2_EVENT_MD_FL_HAVE_FRAME_SEQ v4l2-event-motion-det
-
-replace define V4L2_EVENT_SUB_FL_SEND_INITIAL event-flags
-replace define V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK event-flags
-
-# V4L2 debugging
-replace define V4L2_CHIP_MATCH_BRIDGE vidioc_dbg_g_register
-replace define V4L2_CHIP_MATCH_SUBDEV vidioc_dbg_g_register
-replace define V4L2_CHIP_MATCH_HOST vidioc_dbg_g_register
-replace define V4L2_CHIP_MATCH_I2C_DRIVER vidioc_dbg_g_register
-replace define V4L2_CHIP_MATCH_I2C_ADDR vidioc_dbg_g_register
-replace define V4L2_CHIP_MATCH_AC97 vidioc_dbg_g_register
-
-replace define V4L2_CHIP_FL_READABLE vidioc_dbg_g_register
-replace define V4L2_CHIP_FL_WRITABLE vidioc_dbg_g_register
-
-# Ignore reserved ioctl and ancillary macros
-
-ignore define VIDEO_MAX_FRAME
-ignore define VIDEO_MAX_PLANES
-ignore define v4l2_fourcc
-ignore define v4l2_fourcc_be
-ignore define V4L2_FIELD_HAS_TOP
-ignore define V4L2_FIELD_HAS_BOTTOM
-ignore define V4L2_FIELD_HAS_BOTH
-ignore define V4L2_FIELD_HAS_T_OR_B
-ignore define V4L2_TYPE_IS_MULTIPLANAR
-ignore define V4L2_TYPE_IS_OUTPUT
-ignore define V4L2_TUNER_ADC
-ignore define V4L2_MAP_COLORSPACE_DEFAULT
-ignore define V4L2_MAP_XFER_FUNC_DEFAULT
-ignore define V4L2_MAP_YCBCR_ENC_DEFAULT
-ignore define V4L2_DV_BT_BLANKING_WIDTH
-ignore define V4L2_DV_BT_FRAME_WIDTH
-ignore define V4L2_DV_BT_BLANKING_HEIGHT
-ignore define V4L2_DV_BT_FRAME_HEIGHT
-ignore define V4L2_IN_CAP_CUSTOM_TIMINGS
-ignore define V4L2_CTRL_ID_MASK
-ignore define V4L2_CTRL_ID2CLASS
-ignore define V4L2_CTRL_ID2WHICH
-ignore define V4L2_CTRL_DRIVER_PRIV
-ignore define V4L2_CTRL_MAX_DIMS
-ignore define V4L2_CTRL_WHICH_CUR_VAL
-ignore define V4L2_CTRL_WHICH_DEF_VAL
-ignore define V4L2_OUT_CAP_CUSTOM_TIMINGS
-ignore define V4L2_CID_MAX_CTRLS
-
-ignore ioctl VIDIOC_RESERVED
-ignore define BASE_VIDIOC_PRIVATE
-
-# Associate ioctls with their counterparts
-replace ioctl VIDIOC_DBG_S_REGISTER vidioc_dbg_g_register
-replace ioctl VIDIOC_DQBUF vidioc_qbuf
-replace ioctl VIDIOC_S_AUDOUT vidioc_g_audout
-replace ioctl VIDIOC_S_CROP vidioc_g_crop
-replace ioctl VIDIOC_S_CTRL vidioc_g_ctrl
-replace ioctl VIDIOC_S_DV_TIMINGS vidioc_g_dv_timings
-replace ioctl VIDIOC_S_EDID vidioc_g_edid
-replace ioctl VIDIOC_S_EXT_CTRLS vidioc_g_ext_ctrls
-replace ioctl VIDIOC_S_FBUF vidioc_g_fbuf
-replace ioctl VIDIOC_S_FMT vidioc_g_fmt
-replace ioctl VIDIOC_S_FREQUENCY vidioc_g_frequency
-replace ioctl VIDIOC_S_INPUT vidioc_g_input
-replace ioctl VIDIOC_S_JPEGCOMP vidioc_g_jpegcomp
-replace ioctl VIDIOC_S_MODULATOR vidioc_g_modulator
-replace ioctl VIDIOC_S_OUTPUT vidioc_g_output
-replace ioctl VIDIOC_S_PARM vidioc_g_parm
-replace ioctl VIDIOC_S_PRIORITY vidioc_g_priority
-replace ioctl VIDIOC_S_SELECTION vidioc_g_selection
-replace ioctl VIDIOC_S_STD vidioc_g_std
-replace ioctl VIDIOC_S_AUDIO vidioc_g_audio
-replace ioctl VIDIOC_S_TUNER vidioc_g_tuner
-replace ioctl VIDIOC_TRY_DECODER_CMD vidioc_decoder_cmd
-replace ioctl VIDIOC_TRY_ENCODER_CMD vidioc_encoder_cmd
-replace ioctl VIDIOC_TRY_EXT_CTRLS vidioc_g_ext_ctrls
-replace ioctl VIDIOC_TRY_FMT vidioc_g_fmt
-replace ioctl VIDIOC_STREAMOFF vidioc_streamon
-replace ioctl VIDIOC_QUERY_EXT_CTRL vidioc_queryctrl
-replace ioctl VIDIOC_QUERYMENU vidioc_queryctrl
-- 
2.7.4

