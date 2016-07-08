Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:34319 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751016AbcGHIgc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Jul 2016 04:36:32 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id E1FF4180C71
	for <linux-media@vger.kernel.org>; Fri,  8 Jul 2016 10:36:26 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cec-funcs.h: add missing const modifier
Message-ID: <1572381f-f82d-1867-2317-637478d79ab8@xs4all.nl>
Date: Fri, 8 Jul 2016 10:36:26 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The cec_ops_* functions never touch cec_msg, so mark it as const.

This was done for some of the cec_ops_ functions, but not all.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/include/linux/cec-funcs.h b/include/linux/cec-funcs.h
index 1948600..dfb945a 100644
--- a/include/linux/cec-funcs.h
+++ b/include/linux/cec-funcs.h
@@ -420,7 +420,7 @@ static inline void cec_msg_timer_status(struct cec_msg *msg,
 	}
 }

-static inline void cec_ops_timer_status(struct cec_msg *msg,
+static inline void cec_ops_timer_status(const struct cec_msg *msg,
 					__u8 *timer_overlap_warning,
 					__u8 *media_info,
 					__u8 *prog_info,
@@ -455,7 +455,7 @@ static inline void cec_msg_timer_cleared_status(struct cec_msg *msg,
 	msg->msg[2] = timer_cleared_status;
 }

-static inline void cec_ops_timer_cleared_status(struct cec_msg *msg,
+static inline void cec_ops_timer_cleared_status(const struct cec_msg *msg,
 						__u8 *timer_cleared_status)
 {
 	*timer_cleared_status = msg->msg[2];
@@ -491,7 +491,7 @@ static inline void cec_msg_clear_analogue_timer(struct cec_msg *msg,
 	msg->reply = reply ? CEC_MSG_TIMER_CLEARED_STATUS : 0;
 }

-static inline void cec_ops_clear_analogue_timer(struct cec_msg *msg,
+static inline void cec_ops_clear_analogue_timer(const struct cec_msg *msg,
 						__u8 *day,
 						__u8 *month,
 						__u8 *start_hr,
@@ -541,7 +541,7 @@ static inline void cec_msg_clear_digital_timer(struct cec_msg *msg,
 	cec_set_digital_service_id(msg->msg + 9, digital);
 }

-static inline void cec_ops_clear_digital_timer(struct cec_msg *msg,
+static inline void cec_ops_clear_digital_timer(const struct cec_msg *msg,
 				__u8 *day,
 				__u8 *month,
 				__u8 *start_hr,
@@ -592,7 +592,7 @@ static inline void cec_msg_clear_ext_timer(struct cec_msg *msg,
 	msg->reply = reply ? CEC_MSG_TIMER_CLEARED_STATUS : 0;
 }

-static inline void cec_ops_clear_ext_timer(struct cec_msg *msg,
+static inline void cec_ops_clear_ext_timer(const struct cec_msg *msg,
 					   __u8 *day,
 					   __u8 *month,
 					   __u8 *start_hr,
@@ -647,7 +647,7 @@ static inline void cec_msg_set_analogue_timer(struct cec_msg *msg,
 	msg->reply = reply ? CEC_MSG_TIMER_STATUS : 0;
 }

-static inline void cec_ops_set_analogue_timer(struct cec_msg *msg,
+static inline void cec_ops_set_analogue_timer(const struct cec_msg *msg,
 					      __u8 *day,
 					      __u8 *month,
 					      __u8 *start_hr,
@@ -697,7 +697,7 @@ static inline void cec_msg_set_digital_timer(struct cec_msg *msg,
 	cec_set_digital_service_id(msg->msg + 9, digital);
 }

-static inline void cec_ops_set_digital_timer(struct cec_msg *msg,
+static inline void cec_ops_set_digital_timer(const struct cec_msg *msg,
 			__u8 *day,
 			__u8 *month,
 			__u8 *start_hr,
@@ -748,7 +748,7 @@ static inline void cec_msg_set_ext_timer(struct cec_msg *msg,
 	msg->reply = reply ? CEC_MSG_TIMER_STATUS : 0;
 }

-static inline void cec_ops_set_ext_timer(struct cec_msg *msg,
+static inline void cec_ops_set_ext_timer(const struct cec_msg *msg,
 					 __u8 *day,
 					 __u8 *month,
 					 __u8 *start_hr,
@@ -853,7 +853,7 @@ static inline void cec_msg_set_menu_language(struct cec_msg *msg,
 	memcpy(msg->msg + 2, language, 3);
 }

-static inline void cec_ops_set_menu_language(struct cec_msg *msg,
+static inline void cec_ops_set_menu_language(const struct cec_msg *msg,
 					     char *language)
 {
 	memcpy(language, msg->msg + 2, 3);
@@ -926,7 +926,7 @@ static inline void cec_msg_deck_control(struct cec_msg *msg,
 	msg->msg[2] = deck_control_mode;
 }

-static inline void cec_ops_deck_control(struct cec_msg *msg,
+static inline void cec_ops_deck_control(const struct cec_msg *msg,
 					__u8 *deck_control_mode)
 {
 	*deck_control_mode = msg->msg[2];
@@ -940,7 +940,7 @@ static inline void cec_msg_deck_status(struct cec_msg *msg,
 	msg->msg[2] = deck_info;
 }

-static inline void cec_ops_deck_status(struct cec_msg *msg,
+static inline void cec_ops_deck_status(const struct cec_msg *msg,
 				       __u8 *deck_info)
 {
 	*deck_info = msg->msg[2];
@@ -956,7 +956,7 @@ static inline void cec_msg_give_deck_status(struct cec_msg *msg,
 	msg->reply = reply ? CEC_MSG_DECK_STATUS : 0;
 }

-static inline void cec_ops_give_deck_status(struct cec_msg *msg,
+static inline void cec_ops_give_deck_status(const struct cec_msg *msg,
 					    __u8 *status_req)
 {
 	*status_req = msg->msg[2];
@@ -970,7 +970,7 @@ static inline void cec_msg_play(struct cec_msg *msg,
 	msg->msg[2] = play_mode;
 }

-static inline void cec_ops_play(struct cec_msg *msg,
+static inline void cec_ops_play(const struct cec_msg *msg,
 				__u8 *play_mode)
 {
 	*play_mode = msg->msg[2];
@@ -1035,7 +1035,7 @@ static inline void cec_msg_tuner_device_status(struct cec_msg *msg,
 			&tuner_dev_info->digital);
 }

-static inline void cec_ops_tuner_device_status(struct cec_msg *msg,
+static inline void cec_ops_tuner_device_status(const struct cec_msg *msg,
 				struct cec_op_tuner_device_info *tuner_dev_info)
 {
 	tuner_dev_info->is_analog = msg->len < 10;
@@ -1060,7 +1060,7 @@ static inline void cec_msg_give_tuner_device_status(struct cec_msg *msg,
 	msg->reply = reply ? CEC_MSG_TUNER_DEVICE_STATUS : 0;
 }

-static inline void cec_ops_give_tuner_device_status(struct cec_msg *msg,
+static inline void cec_ops_give_tuner_device_status(const struct cec_msg *msg,
 						    __u8 *status_req)
 {
 	*status_req = msg->msg[2];
@@ -1079,7 +1079,7 @@ static inline void cec_msg_select_analogue_service(struct cec_msg *msg,
 	msg->msg[5] = bcast_system;
 }

-static inline void cec_ops_select_analogue_service(struct cec_msg *msg,
+static inline void cec_ops_select_analogue_service(const struct cec_msg *msg,
 						   __u8 *ana_bcast_type,
 						   __u16 *ana_freq,
 						   __u8 *bcast_system)
@@ -1097,7 +1097,7 @@ static inline void cec_msg_select_digital_service(struct cec_msg *msg,
 	cec_set_digital_service_id(msg->msg + 2, digital);
 }

-static inline void cec_ops_select_digital_service(struct cec_msg *msg,
+static inline void cec_ops_select_digital_service(const struct cec_msg *msg,
 				struct cec_op_digital_service_id *digital)
 {
 	cec_get_digital_service_id(msg->msg + 2, digital);
@@ -1218,7 +1218,7 @@ static inline void cec_msg_menu_status(struct cec_msg *msg,
 	msg->msg[2] = menu_state;
 }

-static inline void cec_ops_menu_status(struct cec_msg *msg,
+static inline void cec_ops_menu_status(const struct cec_msg *msg,
 				       __u8 *menu_state)
 {
 	*menu_state = msg->msg[2];
@@ -1234,7 +1234,7 @@ static inline void cec_msg_menu_request(struct cec_msg *msg,
 	msg->reply = reply ? CEC_MSG_MENU_STATUS : 0;
 }

-static inline void cec_ops_menu_request(struct cec_msg *msg,
+static inline void cec_ops_menu_request(const struct cec_msg *msg,
 					__u8 *menu_req)
 {
 	*menu_req = msg->msg[2];
@@ -1284,7 +1284,7 @@ static inline void cec_msg_user_control_pressed(struct cec_msg *msg,
 	}
 }

-static inline void cec_ops_user_control_pressed(struct cec_msg *msg,
+static inline void cec_ops_user_control_pressed(const struct cec_msg *msg,
 						struct cec_op_ui_command *ui_cmd)
 {
 	ui_cmd->ui_cmd = msg->msg[2];
