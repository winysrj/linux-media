Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:49540 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753185AbcKDOTe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 Nov 2016 10:19:34 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cec.h/cec-funcs.h: don't use bool in public headers
Message-ID: <905c071b-5b14-f7e8-5a1f-2505cde5c5da@xs4all.nl>
Date: Fri, 4 Nov 2016 15:19:30 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace bool by int or __u8 (when used in a struct).

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
  include/uapi/linux/cec-funcs.h | 70 
+++++++++++++++++++++---------------------
  include/uapi/linux/cec.h       | 37 +++++++++++-----------
  2 files changed, 54 insertions(+), 53 deletions(-)

diff --git a/include/uapi/linux/cec-funcs.h b/include/uapi/linux/cec-funcs.h
index 1a1de21..3cbc327 100644
--- a/include/uapi/linux/cec-funcs.h
+++ b/include/uapi/linux/cec-funcs.h
@@ -84,7 +84,7 @@ static inline void cec_ops_inactive_source(const 
struct cec_msg *msg,
  }

  static inline void cec_msg_request_active_source(struct cec_msg *msg,
-						 bool reply)
+						 int reply)
  {
  	msg->len = 2;
  	msg->msg[0] |= 0xf; /* broadcast */
@@ -109,7 +109,7 @@ static inline void cec_ops_routing_information(const 
struct cec_msg *msg,
  }

  static inline void cec_msg_routing_change(struct cec_msg *msg,
-					  bool reply,
+					  int reply,
  					  __u16 orig_phys_addr,
  					  __u16 new_phys_addr)
  {
@@ -156,7 +156,7 @@ static inline void cec_msg_standby(struct cec_msg *msg)


  /* One Touch Record Feature */
-static inline void cec_msg_record_off(struct cec_msg *msg, bool reply)
+static inline void cec_msg_record_off(struct cec_msg *msg, int reply)
  {
  	msg->len = 2;
  	msg->msg[1] = CEC_MSG_RECORD_OFF;
@@ -318,7 +318,7 @@ static inline void 
cec_msg_record_on_phys_addr(struct cec_msg *msg,
  }

  static inline void cec_msg_record_on(struct cec_msg *msg,
-				     bool reply,
+				     int reply,
  				     const struct cec_op_record_src *rec_src)
  {
  	switch (rec_src->type) {
@@ -385,7 +385,7 @@ static inline void cec_ops_record_status(const 
struct cec_msg *msg,
  }

  static inline void cec_msg_record_tv_screen(struct cec_msg *msg,
-					    bool reply)
+					    int reply)
  {
  	msg->len = 2;
  	msg->msg[1] = CEC_MSG_RECORD_TV_SCREEN;
@@ -459,7 +459,7 @@ static inline void 
cec_ops_timer_cleared_status(const struct cec_msg *msg,
  }

  static inline void cec_msg_clear_analogue_timer(struct cec_msg *msg,
-						bool reply,
+						int reply,
  						__u8 day,
  						__u8 month,
  						__u8 start_hr,
@@ -514,7 +514,7 @@ static inline void 
cec_ops_clear_analogue_timer(const struct cec_msg *msg,
  }

  static inline void cec_msg_clear_digital_timer(struct cec_msg *msg,
-				bool reply,
+				int reply,
  				__u8 day,
  				__u8 month,
  				__u8 start_hr,
@@ -560,7 +560,7 @@ static inline void cec_ops_clear_digital_timer(const 
struct cec_msg *msg,
  }

  static inline void cec_msg_clear_ext_timer(struct cec_msg *msg,
-					   bool reply,
+					   int reply,
  					   __u8 day,
  					   __u8 month,
  					   __u8 start_hr,
@@ -615,7 +615,7 @@ static inline void cec_ops_clear_ext_timer(const 
struct cec_msg *msg,
  }

  static inline void cec_msg_set_analogue_timer(struct cec_msg *msg,
-					      bool reply,
+					      int reply,
  					      __u8 day,
  					      __u8 month,
  					      __u8 start_hr,
@@ -670,7 +670,7 @@ static inline void cec_ops_set_analogue_timer(const 
struct cec_msg *msg,
  }

  static inline void cec_msg_set_digital_timer(struct cec_msg *msg,
-			bool reply,
+			int reply,
  			__u8 day,
  			__u8 month,
  			__u8 start_hr,
@@ -716,7 +716,7 @@ static inline void cec_ops_set_digital_timer(const 
struct cec_msg *msg,
  }

  static inline void cec_msg_set_ext_timer(struct cec_msg *msg,
-					 bool reply,
+					 int reply,
  					 __u8 day,
  					 __u8 month,
  					 __u8 start_hr,
@@ -808,7 +808,7 @@ static inline void cec_ops_cec_version(const struct 
cec_msg *msg,
  }

  static inline void cec_msg_get_cec_version(struct cec_msg *msg,
-					   bool reply)
+					   int reply)
  {
  	msg->len = 2;
  	msg->msg[1] = CEC_MSG_GET_CEC_VERSION;
@@ -834,7 +834,7 @@ static inline void 
cec_ops_report_physical_addr(const struct cec_msg *msg,
  }

  static inline void cec_msg_give_physical_addr(struct cec_msg *msg,
-					      bool reply)
+					      int reply)
  {
  	msg->len = 2;
  	msg->msg[1] = CEC_MSG_GIVE_PHYSICAL_ADDR;
@@ -858,7 +858,7 @@ static inline void cec_ops_set_menu_language(const 
struct cec_msg *msg,
  }

  static inline void cec_msg_get_menu_language(struct cec_msg *msg,
-					     bool reply)
+					     int reply)
  {
  	msg->len = 2;
  	msg->msg[1] = CEC_MSG_GET_MENU_LANGUAGE;
@@ -907,7 +907,7 @@ static inline void cec_ops_report_features(const 
struct cec_msg *msg,
  }

  static inline void cec_msg_give_features(struct cec_msg *msg,
-					 bool reply)
+					 int reply)
  {
  	msg->len = 2;
  	msg->msg[1] = CEC_MSG_GIVE_FEATURES;
@@ -944,7 +944,7 @@ static inline void cec_ops_deck_status(const struct 
cec_msg *msg,
  }

  static inline void cec_msg_give_deck_status(struct cec_msg *msg,
-					    bool reply,
+					    int reply,
  					    __u8 status_req)
  {
  	msg->len = 3;
@@ -978,7 +978,7 @@ static inline void cec_ops_play(const struct cec_msg 
*msg,
  struct cec_op_tuner_device_info {
  	__u8 rec_flag;
  	__u8 tuner_display_info;
-	bool is_analog;
+	__u8 is_analog;
  	union {
  		struct cec_op_digital_service_id digital;
  		struct {
@@ -1048,7 +1048,7 @@ static inline void 
cec_ops_tuner_device_status(const struct cec_msg *msg,
  }

  static inline void cec_msg_give_tuner_device_status(struct cec_msg *msg,
-						    bool reply,
+						    int reply,
  						    __u8 status_req)
  {
  	msg->len = 3;
@@ -1131,7 +1131,7 @@ static inline void cec_ops_device_vendor_id(const 
struct cec_msg *msg,
  }

  static inline void cec_msg_give_device_vendor_id(struct cec_msg *msg,
-						 bool reply)
+						 int reply)
  {
  	msg->len = 2;
  	msg->msg[1] = CEC_MSG_GIVE_DEVICE_VENDOR_ID;
@@ -1267,7 +1267,7 @@ static inline void cec_ops_set_osd_name(const 
struct cec_msg *msg,
  }

  static inline void cec_msg_give_osd_name(struct cec_msg *msg,
-					 bool reply)
+					 int reply)
  {
  	msg->len = 2;
  	msg->msg[1] = CEC_MSG_GIVE_OSD_NAME;
@@ -1291,7 +1291,7 @@ static inline void cec_ops_menu_status(const 
struct cec_msg *msg,
  }

  static inline void cec_msg_menu_request(struct cec_msg *msg,
-					bool reply,
+					int reply,
  					__u8 menu_req)
  {
  	msg->len = 3;
@@ -1308,7 +1308,7 @@ static inline void cec_ops_menu_request(const 
struct cec_msg *msg,

  struct cec_op_ui_command {
  	__u8 ui_cmd;
-	bool has_opt_arg;
+	__u8 has_opt_arg;
  	union {
  		struct cec_op_channel_data channel_identifier;
  		__u8 ui_broadcast_type;
@@ -1354,7 +1354,7 @@ static inline void 
cec_ops_user_control_pressed(const struct cec_msg *msg,
  						struct cec_op_ui_command *ui_cmd)
  {
  	ui_cmd->ui_cmd = msg->msg[2];
-	ui_cmd->has_opt_arg = false;
+	ui_cmd->has_opt_arg = 0;
  	if (msg->len == 3)
  		return;
  	switch (ui_cmd->ui_cmd) {
@@ -1366,12 +1366,12 @@ static inline void 
cec_ops_user_control_pressed(const struct cec_msg *msg,
  	case 0x6a:
  		/* The optional operand is one byte for all these ui commands */
  		ui_cmd->play_mode = msg->msg[3];
-		ui_cmd->has_opt_arg = true;
+		ui_cmd->has_opt_arg = 1;
  		break;
  	case 0x67:
  		if (msg->len < 7)
  			break;
-		ui_cmd->has_opt_arg = true;
+		ui_cmd->has_opt_arg = 1;
  		ui_cmd->channel_identifier.channel_number_fmt = msg->msg[3] >> 2;
  		ui_cmd->channel_identifier.major = ((msg->msg[3] & 3) << 6) | 
msg->msg[4];
  		ui_cmd->channel_identifier.minor = (msg->msg[5] << 8) | msg->msg[6];
@@ -1403,7 +1403,7 @@ static inline void 
cec_ops_report_power_status(const struct cec_msg *msg,
  }

  static inline void cec_msg_give_device_power_status(struct cec_msg *msg,
-						    bool reply)
+						    int reply)
  {
  	msg->len = 2;
  	msg->msg[1] = CEC_MSG_GIVE_DEVICE_POWER_STATUS;
@@ -1463,7 +1463,7 @@ static inline void 
cec_ops_report_audio_status(const struct cec_msg *msg,
  }

  static inline void cec_msg_give_audio_status(struct cec_msg *msg,
-					     bool reply)
+					     int reply)
  {
  	msg->len = 2;
  	msg->msg[1] = CEC_MSG_GIVE_AUDIO_STATUS;
@@ -1485,7 +1485,7 @@ static inline void 
cec_ops_set_system_audio_mode(const struct cec_msg *msg,
  }

  static inline void cec_msg_system_audio_mode_request(struct cec_msg *msg,
-						     bool reply,
+						     int reply,
  						     __u16 phys_addr)
  {
  	msg->len = phys_addr == 0xffff ? 2 : 4;
@@ -1520,7 +1520,7 @@ static inline void 
cec_ops_system_audio_mode_status(const struct cec_msg *msg,
  }

  static inline void cec_msg_give_system_audio_mode_status(struct 
cec_msg *msg,
-							 bool reply)
+							 int reply)
  {
  	msg->len = 2;
  	msg->msg[1] = CEC_MSG_GIVE_SYSTEM_AUDIO_MODE_STATUS;
@@ -1560,7 +1560,7 @@ static inline void 
cec_ops_report_short_audio_descriptor(const struct cec_msg *m
  }

  static inline void cec_msg_request_short_audio_descriptor(struct 
cec_msg *msg,
-					bool reply,
+					int reply,
  					__u8 num_descriptors,
  					const __u8 *audio_format_id,
  					const __u8 *audio_format_code)
@@ -1618,7 +1618,7 @@ static inline void 
cec_msg_report_arc_initiated(struct cec_msg *msg)
  }

  static inline void cec_msg_initiate_arc(struct cec_msg *msg,
-					bool reply)
+					int reply)
  {
  	msg->len = 2;
  	msg->msg[1] = CEC_MSG_INITIATE_ARC;
@@ -1626,7 +1626,7 @@ static inline void cec_msg_initiate_arc(struct 
cec_msg *msg,
  }

  static inline void cec_msg_request_arc_initiation(struct cec_msg *msg,
-						  bool reply)
+						  int reply)
  {
  	msg->len = 2;
  	msg->msg[1] = CEC_MSG_REQUEST_ARC_INITIATION;
@@ -1640,7 +1640,7 @@ static inline void 
cec_msg_report_arc_terminated(struct cec_msg *msg)
  }

  static inline void cec_msg_terminate_arc(struct cec_msg *msg,
-					 bool reply)
+					 int reply)
  {
  	msg->len = 2;
  	msg->msg[1] = CEC_MSG_TERMINATE_ARC;
@@ -1648,7 +1648,7 @@ static inline void cec_msg_terminate_arc(struct 
cec_msg *msg,
  }

  static inline void cec_msg_request_arc_termination(struct cec_msg *msg,
-						   bool reply)
+						   int reply)
  {
  	msg->len = 2;
  	msg->msg[1] = CEC_MSG_REQUEST_ARC_TERMINATION;
@@ -1690,7 +1690,7 @@ static inline void 
cec_ops_report_current_latency(const struct cec_msg *msg,
  }

  static inline void cec_msg_request_current_latency(struct cec_msg *msg,
-						   bool reply,
+						   int reply,
  						   __u16 phys_addr)
  {
  	msg->len = 4;
diff --git a/include/uapi/linux/cec.h b/include/uapi/linux/cec.h
index f4ec0af..14b6f24 100644
--- a/include/uapi/linux/cec.h
+++ b/include/uapi/linux/cec.h
@@ -37,6 +37,7 @@
  #define _CEC_UAPI_H

  #include <linux/types.h>
+#include <linux/string.h>

  #define CEC_MAX_MSG_SIZE	16

@@ -129,7 +130,7 @@ static inline int cec_msg_opcode(const struct 
cec_msg *msg)
   * cec_msg_is_broadcast - return true if this is a broadcast message.
   * @msg:	the message structure
   */
-static inline bool cec_msg_is_broadcast(const struct cec_msg *msg)
+static inline int cec_msg_is_broadcast(const struct cec_msg *msg)
  {
  	return (msg->msg[0] & 0xf) == 0xf;
  }
@@ -184,14 +185,14 @@ static inline void cec_msg_set_reply_to(struct 
cec_msg *msg,
  #define CEC_RX_STATUS_TIMEOUT		(1 << 1)
  #define CEC_RX_STATUS_FEATURE_ABORT	(1 << 2)

-static inline bool cec_msg_status_is_ok(const struct cec_msg *msg)
+static inline int cec_msg_status_is_ok(const struct cec_msg *msg)
  {
  	if (msg->tx_status && !(msg->tx_status & CEC_TX_STATUS_OK))
-		return false;
+		return 0;
  	if (msg->rx_status && !(msg->rx_status & CEC_RX_STATUS_OK))
-		return false;
+		return 0;
  	if (!msg->tx_status && !msg->rx_status)
-		return false;
+		return 0;
  	return !(msg->rx_status & CEC_RX_STATUS_FEATURE_ABORT);
  }

@@ -254,47 +255,47 @@ static inline bool cec_msg_status_is_ok(const 
struct cec_msg *msg)
  #define CEC_LOG_ADDR_MASK_SPECIFIC	(1 << CEC_LOG_ADDR_SPECIFIC)
  #define CEC_LOG_ADDR_MASK_UNREGISTERED	(1 << CEC_LOG_ADDR_UNREGISTERED)

-static inline bool cec_has_tv(__u16 log_addr_mask)
+static inline int cec_has_tv(__u16 log_addr_mask)
  {
  	return log_addr_mask & CEC_LOG_ADDR_MASK_TV;
  }

-static inline bool cec_has_record(__u16 log_addr_mask)
+static inline int cec_has_record(__u16 log_addr_mask)
  {
  	return log_addr_mask & CEC_LOG_ADDR_MASK_RECORD;
  }

-static inline bool cec_has_tuner(__u16 log_addr_mask)
+static inline int cec_has_tuner(__u16 log_addr_mask)
  {
  	return log_addr_mask & CEC_LOG_ADDR_MASK_TUNER;
  }

-static inline bool cec_has_playback(__u16 log_addr_mask)
+static inline int cec_has_playback(__u16 log_addr_mask)
  {
  	return log_addr_mask & CEC_LOG_ADDR_MASK_PLAYBACK;
  }

-static inline bool cec_has_audiosystem(__u16 log_addr_mask)
+static inline int cec_has_audiosystem(__u16 log_addr_mask)
  {
  	return log_addr_mask & CEC_LOG_ADDR_MASK_AUDIOSYSTEM;
  }

-static inline bool cec_has_backup(__u16 log_addr_mask)
+static inline int cec_has_backup(__u16 log_addr_mask)
  {
  	return log_addr_mask & CEC_LOG_ADDR_MASK_BACKUP;
  }

-static inline bool cec_has_specific(__u16 log_addr_mask)
+static inline int cec_has_specific(__u16 log_addr_mask)
  {
  	return log_addr_mask & CEC_LOG_ADDR_MASK_SPECIFIC;
  }

-static inline bool cec_is_unregistered(__u16 log_addr_mask)
+static inline int cec_is_unregistered(__u16 log_addr_mask)
  {
  	return log_addr_mask & CEC_LOG_ADDR_MASK_UNREGISTERED;
  }

-static inline bool cec_is_unconfigured(__u16 log_addr_mask)
+static inline int cec_is_unconfigured(__u16 log_addr_mask)
  {
  	return log_addr_mask == 0;
  }
@@ -1016,7 +1017,7 @@ struct cec_event {

  /* Helper functions to identify the 'special' CEC devices */

-static inline bool cec_is_2nd_tv(const struct cec_log_addrs *las)
+static inline int cec_is_2nd_tv(const struct cec_log_addrs *las)
  {
  	/*
  	 * It is a second TV if the logical address is 14 or 15 and the
@@ -1027,7 +1028,7 @@ static inline bool cec_is_2nd_tv(const struct 
cec_log_addrs *las)
  	       las->primary_device_type[0] == CEC_OP_PRIM_DEVTYPE_TV;
  }

-static inline bool cec_is_processor(const struct cec_log_addrs *las)
+static inline int cec_is_processor(const struct cec_log_addrs *las)
  {
  	/*
  	 * It is a processor if the logical address is 12-15 and the
@@ -1038,7 +1039,7 @@ static inline bool cec_is_processor(const struct 
cec_log_addrs *las)
  	       las->primary_device_type[0] == CEC_OP_PRIM_DEVTYPE_PROCESSOR;
  }

-static inline bool cec_is_switch(const struct cec_log_addrs *las)
+static inline int cec_is_switch(const struct cec_log_addrs *las)
  {
  	/*
  	 * It is a switch if the logical address is 15 and the
@@ -1050,7 +1051,7 @@ static inline bool cec_is_switch(const struct 
cec_log_addrs *las)
  	       !(las->flags & CEC_LOG_ADDRS_FL_CDC_ONLY);
  }

-static inline bool cec_is_cdc_only(const struct cec_log_addrs *las)
+static inline int cec_is_cdc_only(const struct cec_log_addrs *las)
  {
  	/*
  	 * It is a CDC-only device if the logical address is 15 and the
-- 
2.10.1

