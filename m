Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52911 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbcGIOKT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Jul 2016 10:10:19 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH] [media] doc-rst: add CEC header file to the documentation
Date: Sat,  9 Jul 2016 11:10:07 -0300
Message-Id: <96f69e0eef290dc617c04a31972fb0e82f588711.1468073373.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adding the header file is interesting for several reasons:

1) It makes MC documentation consistend with other parts;
2) The header file can be used as a quick index to all API
   elements;
3) The cross-reference check helps to identify symbols that
   aren't documented.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/Makefile                       |   6 +-
 Documentation/media/cec.h.rst.exceptions           | 492 +++++++++++++++++++++
 Documentation/media/uapi/cec/cec-api.rst           |   1 +
 Documentation/media/uapi/cec/cec-header.rst        |  10 +
 .../media/uapi/cec/cec-ioc-adap-g-caps.rst         |  12 +-
 .../media/uapi/cec/cec-ioc-adap-g-log-addrs.rst    |  54 +--
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst   |  14 +-
 Documentation/media/uapi/cec/cec-ioc-g-mode.rst    |  58 +--
 Documentation/media/uapi/cec/cec-ioc-receive.rst   |  32 +-
 9 files changed, 593 insertions(+), 86 deletions(-)
 create mode 100644 Documentation/media/cec.h.rst.exceptions
 create mode 100644 Documentation/media/uapi/cec/cec-header.rst

diff --git a/Documentation/media/Makefile b/Documentation/media/Makefile
index cfab8e4f36e1..bcb9eb5921aa 100644
--- a/Documentation/media/Makefile
+++ b/Documentation/media/Makefile
@@ -2,10 +2,11 @@
 
 PARSER = $(srctree)/Documentation/sphinx/parse-headers.pl
 UAPI = $(srctree)/include/uapi/linux
+KAPI = $(srctree)/include/linux
 SRC_DIR=$(srctree)/Documentation/media
 
 FILES = audio.h.rst ca.h.rst dmx.h.rst frontend.h.rst net.h.rst video.h.rst \
-	  videodev2.h.rst media.h.rst
+	  videodev2.h.rst media.h.rst cec.h.rst
 
 TARGETS := $(addprefix $(BUILDDIR)/, $(FILES))
 
@@ -49,5 +50,8 @@ $(BUILDDIR)/videodev2.h.rst: ${UAPI}/videodev2.h ${PARSER} $(SRC_DIR)/videodev2.
 $(BUILDDIR)/media.h.rst: ${UAPI}/media.h ${PARSER} $(SRC_DIR)/media.h.rst.exceptions
 	@$($(quiet)gen_rst)
 
+$(BUILDDIR)/cec.h.rst: ${KAPI}/cec.h ${PARSER} $(SRC_DIR)/cec.h.rst.exceptions
+	@$($(quiet)gen_rst)
+
 cleandocs:
 	-rm ${TARGETS}
diff --git a/Documentation/media/cec.h.rst.exceptions b/Documentation/media/cec.h.rst.exceptions
new file mode 100644
index 000000000000..b79339433718
--- /dev/null
+++ b/Documentation/media/cec.h.rst.exceptions
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
diff --git a/Documentation/media/uapi/cec/cec-api.rst b/Documentation/media/uapi/cec/cec-api.rst
index 7b7942281a60..f40103fefddc 100644
--- a/Documentation/media/uapi/cec/cec-api.rst
+++ b/Documentation/media/uapi/cec/cec-api.rst
@@ -69,6 +69,7 @@ Function Reference
     cec-ioc-dqevent
     cec-ioc-g-mode
     cec-ioc-receive
+    cec-header
 
 
 **********************
diff --git a/Documentation/media/uapi/cec/cec-header.rst b/Documentation/media/uapi/cec/cec-header.rst
new file mode 100644
index 000000000000..d5a9a2828274
--- /dev/null
+++ b/Documentation/media/uapi/cec/cec-header.rst
@@ -0,0 +1,10 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _cec_header:
+
+***************
+CEC Header File
+***************
+
+.. kernel-include:: $BUILDDIR/cec.h.rst
+
diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
index eefec7b4f6bb..6cf959ee6929 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
@@ -93,7 +93,7 @@ returns the information to the application. The ioctl never fails.
     :widths:       3 1 8
 
 
-    -  .. _`CEC_CAP_PHYS_ADDR`:
+    -  .. _`CEC-CAP-PHYS-ADDR`:
 
        -  ``CEC_CAP_PHYS_ADDR``
 
@@ -105,7 +105,7 @@ returns the information to the application. The ioctl never fails.
           handled by the kernel whenever the EDID is set (for an HDMI
           receiver) or read (for an HDMI transmitter).
 
-    -  .. _`CEC_CAP_LOG_ADDRS`:
+    -  .. _`CEC-CAP-LOG-ADDRS`:
 
        -  ``CEC_CAP_LOG_ADDRS``
 
@@ -116,7 +116,7 @@ returns the information to the application. The ioctl never fails.
           this capability isn't set, then the kernel will have configured
           this.
 
-    -  .. _`CEC_CAP_TRANSMIT`:
+    -  .. _`CEC-CAP-TRANSMIT`:
 
        -  ``CEC_CAP_TRANSMIT``
 
@@ -129,7 +129,7 @@ returns the information to the application. The ioctl never fails.
           capability isn't set, then the kernel will handle all CEC
           transmits and process all CEC messages it receives.
 
-    -  .. _`CEC_CAP_PASSTHROUGH`:
+    -  .. _`CEC-CAP-PASSTHROUGH`:
 
        -  ``CEC_CAP_PASSTHROUGH``
 
@@ -138,7 +138,7 @@ returns the information to the application. The ioctl never fails.
        -  Userspace can use the passthrough mode by calling
           :ref:`CEC_S_MODE`.
 
-    -  .. _`CEC_CAP_RC`:
+    -  .. _`CEC-CAP-RC`:
 
        -  ``CEC_CAP_RC``
 
@@ -146,7 +146,7 @@ returns the information to the application. The ioctl never fails.
 
        -  This adapter supports the remote control protocol.
 
-    -  .. _`CEC_CAP_MONITOR_ALL`:
+    -  .. _`CEC-CAP-MONITOR-ALL`:
 
        -  ``CEC_CAP_MONITOR_ALL``
 
diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
index 28955d20652f..322df752465f 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
@@ -93,7 +93,7 @@ by a file handle in initiator mode (see
        -  The CEC version that this adapter shall use. See
           :ref:`cec-versions`. Used to implement the
           ``CEC_MSG_CEC_VERSION`` and ``CEC_MSG_REPORT_FEATURES`` messages.
-          Note that :ref:`CEC_OP_CEC_VERSION_1_3A <CEC_OP_CEC_VERSION_1_3A>` is not allowed by the CEC
+          Note that :ref:`CEC_OP_CEC_VERSION_1_3A <CEC-OP-CEC-VERSION-1-3A>` is not allowed by the CEC
           framework.
 
     -  .. row 4
@@ -161,7 +161,7 @@ by a file handle in initiator mode (see
        -  Logical address types. See :ref:`cec-log-addr-types` for
           possible types. The driver will update this with the actual
           logical address type that it claimed (e.g. it may have to fallback
-          to :ref:`CEC_LOG_ADDR_TYPE_UNREGISTERED <CEC_LOG_ADDR_TYPE_UNREGISTERED>`).
+          to :ref:`CEC_LOG_ADDR_TYPE_UNREGISTERED <CEC-LOG-ADDR-TYPE-UNREGISTERED>`).
 
     -  .. row 10
 
@@ -172,7 +172,7 @@ by a file handle in initiator mode (see
        -  CEC 2.0 specific: all device types. See
           :ref:`cec-all-dev-types-flags`. Used to implement the
           ``CEC_MSG_REPORT_FEATURES`` message. This field is ignored if
-          ``cec_version`` < :ref:`CEC_OP_CEC_VERSION_2_0 <CEC_OP_CEC_VERSION_2_0>`.
+          ``cec_version`` < :ref:`CEC_OP_CEC_VERSION_2_0 <CEC-OP-CEC-VERSION-2-0>`.
 
     -  .. row 11
 
@@ -183,7 +183,7 @@ by a file handle in initiator mode (see
        -  Features for each logical address. Used to implement the
           ``CEC_MSG_REPORT_FEATURES`` message. The 12 bytes include both the
           RC Profile and the Device Features. This field is ignored if
-          ``cec_version`` < :ref:`CEC_OP_CEC_VERSION_2_0 <CEC_OP_CEC_VERSION_2_0>`.
+          ``cec_version`` < :ref:`CEC_OP_CEC_VERSION_2_0 <CEC-OP-CEC-VERSION-2-0>`.
 
 
 
@@ -195,7 +195,7 @@ by a file handle in initiator mode (see
     :widths:       3 1 4
 
 
-    -  .. _`CEC_OP_CEC_VERSION_1_3A`:
+    -  .. _`CEC-OP-CEC-VERSION-1-3A`:
 
        -  ``CEC_OP_CEC_VERSION_1_3A``
 
@@ -203,7 +203,7 @@ by a file handle in initiator mode (see
 
        -  CEC version according to the HDMI 1.3a standard.
 
-    -  .. _`CEC_OP_CEC_VERSION_1_4B`:
+    -  .. _`CEC-OP-CEC-VERSION-1-4B`:
 
        -  ``CEC_OP_CEC_VERSION_1_4B``
 
@@ -211,7 +211,7 @@ by a file handle in initiator mode (see
 
        -  CEC version according to the HDMI 1.4b standard.
 
-    -  .. _`CEC_OP_CEC_VERSION_2_0`:
+    -  .. _`CEC-OP-CEC-VERSION-2-0`:
 
        -  ``CEC_OP_CEC_VERSION_2_0``
 
@@ -229,7 +229,7 @@ by a file handle in initiator mode (see
     :widths:       3 1 4
 
 
-    -  .. _`CEC_OP_PRIM_DEVTYPE_TV`:
+    -  .. _`CEC-OP-PRIM-DEVTYPE-TV`:
 
        -  ``CEC_OP_PRIM_DEVTYPE_TV``
 
@@ -237,7 +237,7 @@ by a file handle in initiator mode (see
 
        -  Use for a TV.
 
-    -  .. _`CEC_OP_PRIM_DEVTYPE_RECORD`:
+    -  .. _`CEC-OP-PRIM-DEVTYPE-RECORD`:
 
        -  ``CEC_OP_PRIM_DEVTYPE_RECORD``
 
@@ -245,7 +245,7 @@ by a file handle in initiator mode (see
 
        -  Use for a recording device.
 
-    -  .. _`CEC_OP_PRIM_DEVTYPE_TUNER`:
+    -  .. _`CEC-OP-PRIM-DEVTYPE-TUNER`:
 
        -  ``CEC_OP_PRIM_DEVTYPE_TUNER``
 
@@ -253,7 +253,7 @@ by a file handle in initiator mode (see
 
        -  Use for a device with a tuner.
 
-    -  .. _`CEC_OP_PRIM_DEVTYPE_PLAYBACK`:
+    -  .. _`CEC-OP-PRIM-DEVTYPE-PLAYBACK`:
 
        -  ``CEC_OP_PRIM_DEVTYPE_PLAYBACK``
 
@@ -261,7 +261,7 @@ by a file handle in initiator mode (see
 
        -  Use for a playback device.
 
-    -  .. _`CEC_OP_PRIM_DEVTYPE_AUDIOSYSTEM`:
+    -  .. _`CEC-OP-PRIM-DEVTYPE-AUDIOSYSTEM`:
 
        -  ``CEC_OP_PRIM_DEVTYPE_AUDIOSYSTEM``
 
@@ -269,7 +269,7 @@ by a file handle in initiator mode (see
 
        -  Use for an audio system (e.g. an audio/video receiver).
 
-    -  .. _`CEC_OP_PRIM_DEVTYPE_SWITCH`:
+    -  .. _`CEC-OP-PRIM-DEVTYPE-SWITCH`:
 
        -  ``CEC_OP_PRIM_DEVTYPE_SWITCH``
 
@@ -277,7 +277,7 @@ by a file handle in initiator mode (see
 
        -  Use for a CEC switch.
 
-    -  .. _`CEC_OP_PRIM_DEVTYPE_VIDEOPROC`:
+    -  .. _`CEC-OP-PRIM-DEVTYPE-VIDEOPROC`:
 
        -  ``CEC_OP_PRIM_DEVTYPE_VIDEOPROC``
 
@@ -295,7 +295,7 @@ by a file handle in initiator mode (see
     :widths:       3 1 16
 
 
-    -  .. _`CEC_LOG_ADDR_TYPE_TV`:
+    -  .. _`CEC-LOG-ADDR-TYPE-TV`:
 
        -  ``CEC_LOG_ADDR_TYPE_TV``
 
@@ -303,7 +303,7 @@ by a file handle in initiator mode (see
 
        -  Use for a TV.
 
-    -  .. _`CEC_LOG_ADDR_TYPE_RECORD`:
+    -  .. _`CEC-LOG-ADDR-TYPE-RECORD`:
 
        -  ``CEC_LOG_ADDR_TYPE_RECORD``
 
@@ -311,7 +311,7 @@ by a file handle in initiator mode (see
 
        -  Use for a recording device.
 
-    -  .. _`CEC_LOG_ADDR_TYPE_TUNER`:
+    -  .. _`CEC-LOG-ADDR-TYPE-TUNER`:
 
        -  ``CEC_LOG_ADDR_TYPE_TUNER``
 
@@ -319,7 +319,7 @@ by a file handle in initiator mode (see
 
        -  Use for a tuner device.
 
-    -  .. _`CEC_LOG_ADDR_TYPE_PLAYBACK`:
+    -  .. _`CEC-LOG-ADDR-TYPE-PLAYBACK`:
 
        -  ``CEC_LOG_ADDR_TYPE_PLAYBACK``
 
@@ -327,7 +327,7 @@ by a file handle in initiator mode (see
 
        -  Use for a playback device.
 
-    -  .. _`CEC_LOG_ADDR_TYPE_AUDIOSYSTEM`:
+    -  .. _`CEC-LOG-ADDR-TYPE-AUDIOSYSTEM`:
 
        -  ``CEC_LOG_ADDR_TYPE_AUDIOSYSTEM``
 
@@ -335,7 +335,7 @@ by a file handle in initiator mode (see
 
        -  Use for an audio system device.
 
-    -  .. _`CEC_LOG_ADDR_TYPE_SPECIFIC`:
+    -  .. _`CEC-LOG-ADDR-TYPE-SPECIFIC`:
 
        -  ``CEC_LOG_ADDR_TYPE_SPECIFIC``
 
@@ -343,7 +343,7 @@ by a file handle in initiator mode (see
 
        -  Use for a second TV or for a video processor device.
 
-    -  .. _`CEC_LOG_ADDR_TYPE_UNREGISTERED`:
+    -  .. _`CEC-LOG-ADDR-TYPE-UNREGISTERED`:
 
        -  ``CEC_LOG_ADDR_TYPE_UNREGISTERED``
 
@@ -363,7 +363,7 @@ by a file handle in initiator mode (see
     :widths:       3 1 4
 
 
-    -  .. _`CEC_OP_ALL_DEVTYPE_TV`:
+    -  .. _`CEC-OP-ALL-DEVTYPE-TV`:
 
        -  ``CEC_OP_ALL_DEVTYPE_TV``
 
@@ -371,7 +371,7 @@ by a file handle in initiator mode (see
 
        -  This supports the TV type.
 
-    -  .. _`CEC_OP_ALL_DEVTYPE_RECORD`:
+    -  .. _`CEC-OP-ALL-DEVTYPE-RECORD`:
 
        -  ``CEC_OP_ALL_DEVTYPE_RECORD``
 
@@ -379,7 +379,7 @@ by a file handle in initiator mode (see
 
        -  This supports the Recording type.
 
-    -  .. _`CEC_OP_ALL_DEVTYPE_TUNER`:
+    -  .. _`CEC-OP-ALL-DEVTYPE-TUNER`:
 
        -  ``CEC_OP_ALL_DEVTYPE_TUNER``
 
@@ -387,7 +387,7 @@ by a file handle in initiator mode (see
 
        -  This supports the Tuner type.
 
-    -  .. _`CEC_OP_ALL_DEVTYPE_PLAYBACK`:
+    -  .. _`CEC-OP-ALL-DEVTYPE-PLAYBACK`:
 
        -  ``CEC_OP_ALL_DEVTYPE_PLAYBACK``
 
@@ -395,7 +395,7 @@ by a file handle in initiator mode (see
 
        -  This supports the Playback type.
 
-    -  .. _`CEC_OP_ALL_DEVTYPE_AUDIOSYSTEM`:
+    -  .. _`CEC-OP-ALL-DEVTYPE-AUDIOSYSTEM`:
 
        -  ``CEC_OP_ALL_DEVTYPE_AUDIOSYSTEM``
 
@@ -403,7 +403,7 @@ by a file handle in initiator mode (see
 
        -  This supports the Audio System type.
 
-    -  .. _`CEC_OP_ALL_DEVTYPE_SWITCH`:
+    -  .. _`CEC-OP-ALL-DEVTYPE-SWITCH`:
 
        -  ``CEC_OP_ALL_DEVTYPE_SWITCH``
 
diff --git a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
index 07f22cec5762..204bc18d69a9 100644
--- a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
@@ -50,7 +50,7 @@ the intermediate state changes were lost but it is guaranteed that the
 state did change in between the two events.
 
 
-.. _cec-event-state-change:
+.. _cec-event-state-change_s:
 
 .. flat-table:: struct cec_event_state_change
     :header-rows:  0
@@ -76,7 +76,7 @@ state did change in between the two events.
 
 
 
-.. _cec-event-lost-msgs:
+.. _cec-event-lost-msgs_s:
 
 .. flat-table:: struct cec_event_lost_msgs
     :header-rows:  0
@@ -156,7 +156,7 @@ state did change in between the two events.
 
        -  ``state_change``
 
-       -  The new adapter state as sent by the :ref:`CEC_EVENT_STATE_CHANGE <CEC_EVENT_STATE_CHANGE>`
+       -  The new adapter state as sent by the :ref:`CEC_EVENT_STATE_CHANGE <CEC-EVENT-STATE-CHANGE>`
           event.
 
     -  .. row 6
@@ -166,7 +166,7 @@ state did change in between the two events.
 
        -  ``lost_msgs``
 
-       -  The number of lost messages as sent by the :ref:`CEC_EVENT_LOST_MSGS <CEC_EVENT_LOST_MSGS>`
+       -  The number of lost messages as sent by the :ref:`CEC_EVENT_LOST_MSGS <CEC-EVENT-LOST-MSGS>`
           event.
 
 
@@ -179,7 +179,7 @@ state did change in between the two events.
     :widths:       3 1 16
 
 
-    -  .. _CEC_EVENT_STATE_CHANGE:
+    -  .. _`CEC-EVENT-STATE-CHANGE`:
 
        -  ``CEC_EVENT_STATE_CHANGE``
 
@@ -189,7 +189,7 @@ state did change in between the two events.
           called an initial event will be generated for that filehandle with
           the CEC Adapter's state at that time.
 
-    -  .. _CEC_EVENT_LOST_MSGS:
+    -  .. _`CEC-EVENT-LOST-MSGS`:
 
        -  ``CEC_EVENT_LOST_MSGS``
 
@@ -208,7 +208,7 @@ state did change in between the two events.
     :widths:       3 1 8
 
 
-    -  .. _CEC_EVENT_FL_INITIAL_VALUE:
+    -  .. _`CEC-EVENT-FL-INITIAL-VALUE`:
 
        -  ``CEC_EVENT_FL_INITIAL_VALUE``
 
diff --git a/Documentation/media/uapi/cec/cec-ioc-g-mode.rst b/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
index d0605d876423..c11de2f4ddf0 100644
--- a/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
@@ -74,7 +74,7 @@ always call :ref:`CEC_TRANSMIT`.
 Available initiator modes are:
 
 
-.. _cec-mode-initiator:
+.. _cec-mode-initiator_e:
 
 .. flat-table:: Initiator Modes
     :header-rows:  0
@@ -82,7 +82,7 @@ Available initiator modes are:
     :widths:       3 1 16
 
 
-    -  .. _`CEC_MODE_NO_INITIATOR`:
+    -  .. _`CEC-MODE-NO-INITIATOR`:
 
        -  ``CEC_MODE_NO_INITIATOR``
 
@@ -91,7 +91,7 @@ Available initiator modes are:
        -  This is not an initiator, i.e. it cannot transmit CEC messages or
           make any other changes to the CEC adapter.
 
-    -  .. _`CEC_MODE_INITIATOR`:
+    -  .. _`CEC-MODE-INITIATOR`:
 
        -  ``CEC_MODE_INITIATOR``
 
@@ -101,7 +101,7 @@ Available initiator modes are:
           it can transmit CEC messages and make changes to the CEC adapter,
           unless there is an exclusive initiator.
 
-    -  .. _`CEC_MODE_EXCL_INITIATOR`:
+    -  .. _`CEC-MODE-EXCL-INITIATOR`:
 
        -  ``CEC_MODE_EXCL_INITIATOR``
 
@@ -117,7 +117,7 @@ Available initiator modes are:
 Available follower modes are:
 
 
-.. _cec-mode-follower:
+.. _cec-mode-follower_e:
 
 .. flat-table:: Follower Modes
     :header-rows:  0
@@ -125,7 +125,7 @@ Available follower modes are:
     :widths:       3 1 16
 
 
-    -  .. _`CEC_MODE_NO_FOLLOWER`:
+    -  .. _`CEC-MODE-NO-FOLLOWER`:
 
        -  ``CEC_MODE_NO_FOLLOWER``
 
@@ -133,7 +133,7 @@ Available follower modes are:
 
        -  This is not a follower (the default when the device is opened).
 
-    -  .. _`CEC_MODE_FOLLOWER`:
+    -  .. _`CEC-MODE-FOLLOWER`:
 
        -  ``CEC_MODE_FOLLOWER``
 
@@ -141,10 +141,10 @@ Available follower modes are:
 
        -  This is a follower and it will receive CEC messages unless there
           is an exclusive follower. You cannot become a follower if
-          :ref:`CEC_CAP_TRANSMIT <CEC_CAP_TRANSMIT>` is not set or if :ref:`CEC_MODE_NO_INITIATOR <CEC_MODE_NO_INITIATOR>`
+          :ref:`CEC_CAP_TRANSMIT <CEC-CAP-TRANSMIT>` is not set or if :ref:`CEC-MODE-NO-INITIATOR <CEC-MODE-NO-INITIATOR>`
           was specified, EINVAL error code is returned in that case.
 
-    -  .. _`CEC_MODE_EXCL_FOLLOWER`:
+    -  .. _`CEC-MODE-EXCL-FOLLOWER`:
 
        -  ``CEC_MODE_EXCL_FOLLOWER``
 
@@ -154,10 +154,10 @@ Available follower modes are:
           receive CEC messages for processing. If someone else is already
           the exclusive follower then an attempt to become one will return
           the EBUSY error code error. You cannot become a follower if
-          :ref:`CEC_CAP_TRANSMIT <CEC_CAP_TRANSMIT>` is not set or if :ref:`CEC_MODE_NO_INITIATOR <CEC_MODE_NO_INITIATOR>`
+          :ref:`CEC_CAP_TRANSMIT <CEC-CAP-TRANSMIT>` is not set or if :ref:`CEC-MODE-NO-INITIATOR <CEC-MODE-NO-INITIATOR>`
           was specified, EINVAL error code is returned in that case.
 
-    -  .. _`CEC_MODE_EXCL_FOLLOWER_PASSTHRU`:
+    -  .. _`CEC-MODE-EXCL-FOLLOWER-PASSTHRU`:
 
        -  ``CEC_MODE_EXCL_FOLLOWER_PASSTHRU``
 
@@ -169,18 +169,18 @@ Available follower modes are:
           to handle most core messages instead of relying on the CEC
           framework for that. If someone else is already the exclusive
           follower then an attempt to become one will return the EBUSY error
-          code error. You cannot become a follower if :ref:`CEC_CAP_TRANSMIT <CEC_CAP_TRANSMIT>`
-          is not set or if :ref:`CEC_MODE_NO_INITIATOR <CEC_MODE_NO_INITIATOR>` was specified, EINVAL
+          code error. You cannot become a follower if :ref:`CEC_CAP_TRANSMIT <CEC-CAP-TRANSMIT>`
+          is not set or if :ref:`CEC_MODE_NO_INITIATOR <CEC-MODE-NO-INITIATOR>` was specified, EINVAL
           error code is returned in that case.
 
-    -  .. _`CEC_MODE_MONITOR`:
+    -  .. _`CEC-MODE-MONITOR`:
 
        -  ``CEC_MODE_MONITOR``
 
        -  0xe0
 
        -  Put the file descriptor into monitor mode. Can only be used in
-          combination with :ref:`CEC_MODE_NO_INITIATOR <CEC_MODE_NO_INITIATOR>`, otherwise EINVAL error
+          combination with :ref:`CEC_MODE_NO_INITIATOR <CEC-MODE-NO-INITIATOR>`, otherwise EINVAL error
           code will be returned. In monitor mode all messages this CEC
           device transmits and all messages it receives (both broadcast
           messages and directed messages for one its logical addresses) will
@@ -188,19 +188,19 @@ Available follower modes are:
           allowed if the process has the ``CAP_NET_ADMIN`` capability. If
           that is not set, then EPERM error code is returned.
 
-    -  .. _`CEC_MODE_MONITOR_ALL`:
+    -  .. _`CEC-MODE-MONITOR-ALL`:
 
        -  ``CEC_MODE_MONITOR_ALL``
 
        -  0xf0
 
        -  Put the file descriptor into 'monitor all' mode. Can only be used
-          in combination with :ref:`CEC_MODE_NO_INITIATOR <CEC_MODE_NO_INITIATOR>`, otherwise EINVAL
+          in combination with :ref:`CEC_MODE_NO_INITIATOR <CEC-MODE-NO-INITIATOR>`, otherwise EINVAL
           error code will be returned. In 'monitor all' mode all messages
           this CEC device transmits and all messages it receives, including
           directed messages for other CEC devices will be reported. This is
           very useful for debugging, but not all devices support this. This
-          mode requires that the :ref:`CEC_CAP_MONITOR_ALL <CEC_CAP_MONITOR_ALL>` capability is set,
+          mode requires that the :ref:`CEC_CAP_MONITOR_ALL <CEC-CAP-MONITOR-ALL>` capability is set,
           otherwise EINVAL error code is returned. This is only allowed if
           the process has the ``CAP_NET_ADMIN`` capability. If that is not
           set, then EPERM error code is returned.
@@ -217,7 +217,7 @@ Core message processing details:
     :widths: 1 8
 
 
-    -  .. _`CEC_MSG_GET_CEC_VERSION`:
+    -  .. _`CEC-MSG-GET-CEC-VERSION`:
 
        -  ``CEC_MSG_GET_CEC_VERSION``
 
@@ -226,7 +226,7 @@ Core message processing details:
           set with
           :ref:`CEC_ADAP_S_LOG_ADDRS`.
 
-    -  .. _`CEC_MSG_GIVE_DEVICE_VENDOR_ID`:
+    -  .. _`CEC-MSG-GIVE-DEVICE-VENDOR-ID`:
 
        -  ``CEC_MSG_GIVE_DEVICE_VENDOR_ID``
 
@@ -235,7 +235,7 @@ Core message processing details:
           set with
           :ref:`CEC_ADAP_S_LOG_ADDRS`.
 
-    -  .. _`CEC_MSG_ABORT`:
+    -  .. _`CEC-MSG-ABORT`:
 
        -  ``CEC_MSG_ABORT``
 
@@ -243,7 +243,7 @@ Core message processing details:
           userspace, otherwise the core will return a feature refused
           message as per the specification.
 
-    -  .. _`CEC_MSG_GIVE_PHYSICAL_ADDR`:
+    -  .. _`CEC-MSG-GIVE-PHYSICAL-ADDR`:
 
        -  ``CEC_MSG_GIVE_PHYSICAL_ADDR``
 
@@ -251,7 +251,7 @@ Core message processing details:
           userspace, otherwise the core will report the current physical
           address.
 
-    -  .. _`CEC_MSG_GIVE_OSD_NAME`:
+    -  .. _`CEC-MSG-GIVE-OSD-NAME`:
 
        -  ``CEC_MSG_GIVE_OSD_NAME``
 
@@ -260,7 +260,7 @@ Core message processing details:
           was set with
           :ref:`CEC_ADAP_S_LOG_ADDRS`.
 
-    -  .. _`CEC_MSG_GIVE_FEATURES`:
+    -  .. _`CEC-MSG-GIVE-FEATURES`:
 
        -  ``CEC_MSG_GIVE_FEATURES``
 
@@ -270,21 +270,21 @@ Core message processing details:
           :ref:`CEC_ADAP_S_LOG_ADDRS` or
           the message is ignore if the CEC version was older than 2.0.
 
-    -  .. _`CEC_MSG_USER_CONTROL_PRESSED`:
+    -  .. _`CEC-MSG-USER-CONTROL-PRESSED`:
 
        -  ``CEC_MSG_USER_CONTROL_PRESSED``
 
-       -  If :ref:`CEC_CAP_RC <CEC_CAP_RC>` is set, then generate a remote control key
+       -  If :ref:`CEC_CAP_RC <CEC-CAP-RC>` is set, then generate a remote control key
           press. This message is always passed on to userspace.
 
-    -  .. _`CEC_MSG_USER_CONTROL_RELEASED`:
+    -  .. _`CEC-MSG-USER-CONTROL-RELEASED`:
 
        -  ``CEC_MSG_USER_CONTROL_RELEASED``
 
-       -  If :ref:`CEC_CAP_RC <CEC_CAP_RC>` is set, then generate a remote control key
+       -  If :ref:`CEC_CAP_RC <CEC-CAP-RC>` is set, then generate a remote control key
           release. This message is always passed on to userspace.
 
-    -  .. _`CEC_MSG_REPORT_PHYSICAL_ADDR`:
+    -  .. _`CEC-MSG-REPORT-PHYSICAL-ADDR`:
 
        -  ``CEC_MSG_REPORT_PHYSICAL_ADDR``
 
diff --git a/Documentation/media/uapi/cec/cec-ioc-receive.rst b/Documentation/media/uapi/cec/cec-ioc-receive.rst
index c5533795595c..2bc2d6091f53 100644
--- a/Documentation/media/uapi/cec/cec-ioc-receive.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-receive.rst
@@ -161,7 +161,7 @@ queue, then it will return -1 and set errno to the EBUSY error code.
           message) and ``timeout`` is non-zero is specifically allowed to
           send a message and wait up to ``timeout`` milliseconds for a
           Feature Abort reply. In this case ``rx_status`` will either be set
-          to :ref:`CEC_RX_STATUS_TIMEOUT <CEC_RX_STATUS_TIMEOUT>` or :ref:`CEC_RX_STATUS_FEATURE_ABORT <CEC_RX_STATUS_FEATURE_ABORT>`.
+          to :ref:`CEC_RX_STATUS_TIMEOUT <CEC-RX-STATUS-TIMEOUT>` or :ref:`CEC_RX_STATUS-FEATURE-ABORT <CEC-RX-STATUS-FEATURE-ABORT>`.
 
     -  .. row 10
 
@@ -172,7 +172,7 @@ queue, then it will return -1 and set errno to the EBUSY error code.
        -  A counter of the number of transmit attempts that resulted in the
           Arbitration Lost error. This is only set if the hardware supports
           this, otherwise it is always 0. This counter is only valid if the
-          :ref:`CEC_TX_STATUS_ARB_LOST <CEC_TX_STATUS_ARB_LOST>` status bit is set.
+          :ref:`CEC_TX_STATUS_ARB_LOST <CEC-TX-STATUS-ARB-LOST>` status bit is set.
 
     -  .. row 11
 
@@ -183,7 +183,7 @@ queue, then it will return -1 and set errno to the EBUSY error code.
        -  A counter of the number of transmit attempts that resulted in the
           Not Acknowledged error. This is only set if the hardware supports
           this, otherwise it is always 0. This counter is only valid if the
-          :ref:`CEC_TX_STATUS_NACK <CEC_TX_STATUS_NACK>` status bit is set.
+          :ref:`CEC_TX_STATUS_NACK <CEC-TX-STATUS-NACK>` status bit is set.
 
     -  .. row 12
 
@@ -194,7 +194,7 @@ queue, then it will return -1 and set errno to the EBUSY error code.
        -  A counter of the number of transmit attempts that resulted in the
           Arbitration Lost error. This is only set if the hardware supports
           this, otherwise it is always 0. This counter is only valid if the
-          :ref:`CEC_TX_STATUS_LOW_DRIVE <CEC_TX_STATUS_LOW_DRIVE>` status bit is set.
+          :ref:`CEC_TX_STATUS_LOW_DRIVE <CEC-TX-STATUS-LOW-DRIVE>` status bit is set.
 
     -  .. row 13
 
@@ -205,7 +205,7 @@ queue, then it will return -1 and set errno to the EBUSY error code.
        -  A counter of the number of transmit errors other than Arbitration
           Lost or Not Acknowledged. This is only set if the hardware
           supports this, otherwise it is always 0. This counter is only
-          valid if the :ref:`CEC_TX_STATUS_ERROR <CEC_TX_STATUS_ERROR>` status bit is set.
+          valid if the :ref:`CEC_TX_STATUS_ERROR <CEC-TX-STATUS-ERROR>` status bit is set.
 
 
 
@@ -217,18 +217,18 @@ queue, then it will return -1 and set errno to the EBUSY error code.
     :widths:       3 1 16
 
 
-    -  .. _`CEC_TX_STATUS_OK`:
+    -  .. _`CEC-TX-STATUS-OK`:
 
        -  ``CEC_TX_STATUS_OK``
 
        -  0x01
 
        -  The message was transmitted successfully. This is mutually
-          exclusive with :ref:`CEC_TX_STATUS_MAX_RETRIES <CEC_TX_STATUS_MAX_RETRIES>`. Other bits can still
+          exclusive with :ref:`CEC_TX_STATUS_MAX_RETRIES <CEC-TX-STATUS-MAX-RETRIES>`. Other bits can still
           be set if earlier attempts met with failure before the transmit
           was eventually successful.
 
-    -  .. _`CEC_TX_STATUS_ARB_LOST`:
+    -  .. _`CEC-TX-STATUS-ARB-LOST`:
 
        -  ``CEC_TX_STATUS_ARB_LOST``
 
@@ -236,7 +236,7 @@ queue, then it will return -1 and set errno to the EBUSY error code.
 
        -  CEC line arbitration was lost.
 
-    -  .. _`CEC_TX_STATUS_NACK`:
+    -  .. _`CEC-TX-STATUS-NACK`:
 
        -  ``CEC_TX_STATUS_NACK``
 
@@ -244,7 +244,7 @@ queue, then it will return -1 and set errno to the EBUSY error code.
 
        -  Message was not acknowledged.
 
-    -  .. _`CEC_TX_STATUS_LOW_DRIVE`:
+    -  .. _`CEC-TX-STATUS-LOW-DRIVE`:
 
        -  ``CEC_TX_STATUS_LOW_DRIVE``
 
@@ -254,7 +254,7 @@ queue, then it will return -1 and set errno to the EBUSY error code.
           follower detected an error on the bus and requests a
           retransmission.
 
-    -  .. _`CEC_TX_STATUS_ERROR`:
+    -  .. _`CEC-TX-STATUS-ERROR`:
 
        -  ``CEC_TX_STATUS_ERROR``
 
@@ -265,14 +265,14 @@ queue, then it will return -1 and set errno to the EBUSY error code.
           error occurred, or because the hardware tested for other
           conditions besides those two.
 
-    -  .. _`CEC_TX_STATUS_MAX_RETRIES`:
+    -  .. _`CEC-TX-STATUS-MAX-RETRIES`:
 
        -  ``CEC_TX_STATUS_MAX_RETRIES``
 
        -  0x20
 
        -  The transmit failed after one or more retries. This status bit is
-          mutually exclusive with :ref:`CEC_TX_STATUS_OK <CEC_TX_STATUS_OK>`. Other bits can still
+          mutually exclusive with :ref:`CEC_TX_STATUS_OK <CEC-TX-STATUS-OK>`. Other bits can still
           be set to explain which failures were seen.
 
 
@@ -285,7 +285,7 @@ queue, then it will return -1 and set errno to the EBUSY error code.
     :widths:       3 1 16
 
 
-    -  .. _`CEC_RX_STATUS_OK`:
+    -  .. _`CEC-RX-STATUS-OK`:
 
        -  ``CEC_RX_STATUS_OK``
 
@@ -293,7 +293,7 @@ queue, then it will return -1 and set errno to the EBUSY error code.
 
        -  The message was received successfully.
 
-    -  .. _CEC_RX_STATUS_TIMEOUT:
+    -  .. _`CEC-RX-STATUS-TIMEOUT`:
 
        -  ``CEC_RX_STATUS_TIMEOUT``
 
@@ -301,7 +301,7 @@ queue, then it will return -1 and set errno to the EBUSY error code.
 
        -  The reply to an earlier transmitted message timed out.
 
-    -  .. _`CEC_RX_STATUS_FEATURE_ABORT`:
+    -  .. _`CEC-RX-STATUS-FEATURE-ABORT`:
 
        -  ``CEC_RX_STATUS_FEATURE_ABORT``
 
-- 
2.7.4

