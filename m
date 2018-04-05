Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:23635 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751275AbeDEK7O (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Apr 2018 06:59:14 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: tfiga@google.com, hverkuil@xs4all.nl
Subject: [v4l-utils RFC 1/6] Linux kernel header update
Date: Thu,  5 Apr 2018 13:58:14 +0300
Message-Id: <1522925899-14073-2-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1522925899-14073-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1522925899-14073-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This includes kernel headers up to Hans's request API v9 patchset.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 include/linux/cec-funcs.h       | 300 ++++++------
 include/linux/cec.h             |  40 +-
 include/linux/media.h           |   8 +
 include/linux/v4l2-dv-timings.h | 979 ++++++++++++++++++++++++++++++++++++++++
 include/linux/videodev2.h       |  14 +-
 5 files changed, 1169 insertions(+), 172 deletions(-)
 create mode 100644 include/linux/v4l2-dv-timings.h

diff --git a/include/linux/cec-funcs.h b/include/linux/cec-funcs.h
index 8997d50..6daa73d 100644
--- a/include/linux/cec-funcs.h
+++ b/include/linux/cec-funcs.h
@@ -11,7 +11,7 @@
 #include <linux/cec.h>
 
 /* One Touch Play Feature */
-static inline void cec_msg_active_source(struct cec_msg *msg, __u16 phys_addr)
+static __inline__ void cec_msg_active_source(struct cec_msg *msg, __u16 phys_addr)
 {
 	msg->len = 4;
 	msg->msg[0] |= 0xf; /* broadcast */
@@ -20,19 +20,19 @@ static inline void cec_msg_active_source(struct cec_msg *msg, __u16 phys_addr)
 	msg->msg[3] = phys_addr & 0xff;
 }
 
-static inline void cec_ops_active_source(const struct cec_msg *msg,
+static __inline__ void cec_ops_active_source(const struct cec_msg *msg,
 					 __u16 *phys_addr)
 {
 	*phys_addr = (msg->msg[2] << 8) | msg->msg[3];
 }
 
-static inline void cec_msg_image_view_on(struct cec_msg *msg)
+static __inline__ void cec_msg_image_view_on(struct cec_msg *msg)
 {
 	msg->len = 2;
 	msg->msg[1] = CEC_MSG_IMAGE_VIEW_ON;
 }
 
-static inline void cec_msg_text_view_on(struct cec_msg *msg)
+static __inline__ void cec_msg_text_view_on(struct cec_msg *msg)
 {
 	msg->len = 2;
 	msg->msg[1] = CEC_MSG_TEXT_VIEW_ON;
@@ -40,7 +40,7 @@ static inline void cec_msg_text_view_on(struct cec_msg *msg)
 
 
 /* Routing Control Feature */
-static inline void cec_msg_inactive_source(struct cec_msg *msg,
+static __inline__ void cec_msg_inactive_source(struct cec_msg *msg,
 					   __u16 phys_addr)
 {
 	msg->len = 4;
@@ -49,13 +49,13 @@ static inline void cec_msg_inactive_source(struct cec_msg *msg,
 	msg->msg[3] = phys_addr & 0xff;
 }
 
-static inline void cec_ops_inactive_source(const struct cec_msg *msg,
+static __inline__ void cec_ops_inactive_source(const struct cec_msg *msg,
 					   __u16 *phys_addr)
 {
 	*phys_addr = (msg->msg[2] << 8) | msg->msg[3];
 }
 
-static inline void cec_msg_request_active_source(struct cec_msg *msg,
+static __inline__ void cec_msg_request_active_source(struct cec_msg *msg,
 						 int reply)
 {
 	msg->len = 2;
@@ -64,7 +64,7 @@ static inline void cec_msg_request_active_source(struct cec_msg *msg,
 	msg->reply = reply ? CEC_MSG_ACTIVE_SOURCE : 0;
 }
 
-static inline void cec_msg_routing_information(struct cec_msg *msg,
+static __inline__ void cec_msg_routing_information(struct cec_msg *msg,
 					       __u16 phys_addr)
 {
 	msg->len = 4;
@@ -74,13 +74,13 @@ static inline void cec_msg_routing_information(struct cec_msg *msg,
 	msg->msg[3] = phys_addr & 0xff;
 }
 
-static inline void cec_ops_routing_information(const struct cec_msg *msg,
+static __inline__ void cec_ops_routing_information(const struct cec_msg *msg,
 					       __u16 *phys_addr)
 {
 	*phys_addr = (msg->msg[2] << 8) | msg->msg[3];
 }
 
-static inline void cec_msg_routing_change(struct cec_msg *msg,
+static __inline__ void cec_msg_routing_change(struct cec_msg *msg,
 					  int reply,
 					  __u16 orig_phys_addr,
 					  __u16 new_phys_addr)
@@ -95,7 +95,7 @@ static inline void cec_msg_routing_change(struct cec_msg *msg,
 	msg->reply = reply ? CEC_MSG_ROUTING_INFORMATION : 0;
 }
 
-static inline void cec_ops_routing_change(const struct cec_msg *msg,
+static __inline__ void cec_ops_routing_change(const struct cec_msg *msg,
 					  __u16 *orig_phys_addr,
 					  __u16 *new_phys_addr)
 {
@@ -103,7 +103,7 @@ static inline void cec_ops_routing_change(const struct cec_msg *msg,
 	*new_phys_addr = (msg->msg[4] << 8) | msg->msg[5];
 }
 
-static inline void cec_msg_set_stream_path(struct cec_msg *msg, __u16 phys_addr)
+static __inline__ void cec_msg_set_stream_path(struct cec_msg *msg, __u16 phys_addr)
 {
 	msg->len = 4;
 	msg->msg[0] |= 0xf; /* broadcast */
@@ -112,7 +112,7 @@ static inline void cec_msg_set_stream_path(struct cec_msg *msg, __u16 phys_addr)
 	msg->msg[3] = phys_addr & 0xff;
 }
 
-static inline void cec_ops_set_stream_path(const struct cec_msg *msg,
+static __inline__ void cec_ops_set_stream_path(const struct cec_msg *msg,
 					   __u16 *phys_addr)
 {
 	*phys_addr = (msg->msg[2] << 8) | msg->msg[3];
@@ -120,7 +120,7 @@ static inline void cec_ops_set_stream_path(const struct cec_msg *msg,
 
 
 /* Standby Feature */
-static inline void cec_msg_standby(struct cec_msg *msg)
+static __inline__ void cec_msg_standby(struct cec_msg *msg)
 {
 	msg->len = 2;
 	msg->msg[1] = CEC_MSG_STANDBY;
@@ -128,7 +128,7 @@ static inline void cec_msg_standby(struct cec_msg *msg)
 
 
 /* One Touch Record Feature */
-static inline void cec_msg_record_off(struct cec_msg *msg, int reply)
+static __inline__ void cec_msg_record_off(struct cec_msg *msg, int reply)
 {
 	msg->len = 2;
 	msg->msg[1] = CEC_MSG_RECORD_OFF;
@@ -187,7 +187,7 @@ struct cec_op_record_src {
 	};
 };
 
-static inline void cec_set_digital_service_id(__u8 *msg,
+static __inline__ void cec_set_digital_service_id(__u8 *msg,
 	      const struct cec_op_digital_service_id *digital)
 {
 	*msg++ = (digital->service_id_method << 7) | digital->dig_bcast_system;
@@ -224,7 +224,7 @@ static inline void cec_set_digital_service_id(__u8 *msg,
 	}
 }
 
-static inline void cec_get_digital_service_id(const __u8 *msg,
+static __inline__ void cec_get_digital_service_id(const __u8 *msg,
 	      struct cec_op_digital_service_id *digital)
 {
 	digital->service_id_method = msg[0] >> 7;
@@ -240,14 +240,14 @@ static inline void cec_get_digital_service_id(const __u8 *msg,
 	digital->dvb.orig_network_id = (msg[5] << 8) | msg[6];
 }
 
-static inline void cec_msg_record_on_own(struct cec_msg *msg)
+static __inline__ void cec_msg_record_on_own(struct cec_msg *msg)
 {
 	msg->len = 3;
 	msg->msg[1] = CEC_MSG_RECORD_ON;
 	msg->msg[2] = CEC_OP_RECORD_SRC_OWN;
 }
 
-static inline void cec_msg_record_on_digital(struct cec_msg *msg,
+static __inline__ void cec_msg_record_on_digital(struct cec_msg *msg,
 			     const struct cec_op_digital_service_id *digital)
 {
 	msg->len = 10;
@@ -256,7 +256,7 @@ static inline void cec_msg_record_on_digital(struct cec_msg *msg,
 	cec_set_digital_service_id(msg->msg + 3, digital);
 }
 
-static inline void cec_msg_record_on_analog(struct cec_msg *msg,
+static __inline__ void cec_msg_record_on_analog(struct cec_msg *msg,
 					    __u8 ana_bcast_type,
 					    __u16 ana_freq,
 					    __u8 bcast_system)
@@ -270,7 +270,7 @@ static inline void cec_msg_record_on_analog(struct cec_msg *msg,
 	msg->msg[6] = bcast_system;
 }
 
-static inline void cec_msg_record_on_plug(struct cec_msg *msg,
+static __inline__ void cec_msg_record_on_plug(struct cec_msg *msg,
 					  __u8 plug)
 {
 	msg->len = 4;
@@ -279,7 +279,7 @@ static inline void cec_msg_record_on_plug(struct cec_msg *msg,
 	msg->msg[3] = plug;
 }
 
-static inline void cec_msg_record_on_phys_addr(struct cec_msg *msg,
+static __inline__ void cec_msg_record_on_phys_addr(struct cec_msg *msg,
 					       __u16 phys_addr)
 {
 	msg->len = 5;
@@ -289,7 +289,7 @@ static inline void cec_msg_record_on_phys_addr(struct cec_msg *msg,
 	msg->msg[4] = phys_addr & 0xff;
 }
 
-static inline void cec_msg_record_on(struct cec_msg *msg,
+static __inline__ void cec_msg_record_on(struct cec_msg *msg,
 				     int reply,
 				     const struct cec_op_record_src *rec_src)
 {
@@ -317,7 +317,7 @@ static inline void cec_msg_record_on(struct cec_msg *msg,
 	msg->reply = reply ? CEC_MSG_RECORD_STATUS : 0;
 }
 
-static inline void cec_ops_record_on(const struct cec_msg *msg,
+static __inline__ void cec_ops_record_on(const struct cec_msg *msg,
 				     struct cec_op_record_src *rec_src)
 {
 	rec_src->type = msg->msg[2];
@@ -343,20 +343,20 @@ static inline void cec_ops_record_on(const struct cec_msg *msg,
 	}
 }
 
-static inline void cec_msg_record_status(struct cec_msg *msg, __u8 rec_status)
+static __inline__ void cec_msg_record_status(struct cec_msg *msg, __u8 rec_status)
 {
 	msg->len = 3;
 	msg->msg[1] = CEC_MSG_RECORD_STATUS;
 	msg->msg[2] = rec_status;
 }
 
-static inline void cec_ops_record_status(const struct cec_msg *msg,
+static __inline__ void cec_ops_record_status(const struct cec_msg *msg,
 					 __u8 *rec_status)
 {
 	*rec_status = msg->msg[2];
 }
 
-static inline void cec_msg_record_tv_screen(struct cec_msg *msg,
+static __inline__ void cec_msg_record_tv_screen(struct cec_msg *msg,
 					    int reply)
 {
 	msg->len = 2;
@@ -366,7 +366,7 @@ static inline void cec_msg_record_tv_screen(struct cec_msg *msg,
 
 
 /* Timer Programming Feature */
-static inline void cec_msg_timer_status(struct cec_msg *msg,
+static __inline__ void cec_msg_timer_status(struct cec_msg *msg,
 					__u8 timer_overlap_warning,
 					__u8 media_info,
 					__u8 prog_info,
@@ -389,7 +389,7 @@ static inline void cec_msg_timer_status(struct cec_msg *msg,
 	}
 }
 
-static inline void cec_ops_timer_status(const struct cec_msg *msg,
+static __inline__ void cec_ops_timer_status(const struct cec_msg *msg,
 					__u8 *timer_overlap_warning,
 					__u8 *media_info,
 					__u8 *prog_info,
@@ -416,7 +416,7 @@ static inline void cec_ops_timer_status(const struct cec_msg *msg,
 	}
 }
 
-static inline void cec_msg_timer_cleared_status(struct cec_msg *msg,
+static __inline__ void cec_msg_timer_cleared_status(struct cec_msg *msg,
 						__u8 timer_cleared_status)
 {
 	msg->len = 3;
@@ -424,13 +424,13 @@ static inline void cec_msg_timer_cleared_status(struct cec_msg *msg,
 	msg->msg[2] = timer_cleared_status;
 }
 
-static inline void cec_ops_timer_cleared_status(const struct cec_msg *msg,
+static __inline__ void cec_ops_timer_cleared_status(const struct cec_msg *msg,
 						__u8 *timer_cleared_status)
 {
 	*timer_cleared_status = msg->msg[2];
 }
 
-static inline void cec_msg_clear_analogue_timer(struct cec_msg *msg,
+static __inline__ void cec_msg_clear_analogue_timer(struct cec_msg *msg,
 						int reply,
 						__u8 day,
 						__u8 month,
@@ -460,7 +460,7 @@ static inline void cec_msg_clear_analogue_timer(struct cec_msg *msg,
 	msg->reply = reply ? CEC_MSG_TIMER_CLEARED_STATUS : 0;
 }
 
-static inline void cec_ops_clear_analogue_timer(const struct cec_msg *msg,
+static __inline__ void cec_ops_clear_analogue_timer(const struct cec_msg *msg,
 						__u8 *day,
 						__u8 *month,
 						__u8 *start_hr,
@@ -485,7 +485,7 @@ static inline void cec_ops_clear_analogue_timer(const struct cec_msg *msg,
 	*bcast_system = msg->msg[12];
 }
 
-static inline void cec_msg_clear_digital_timer(struct cec_msg *msg,
+static __inline__ void cec_msg_clear_digital_timer(struct cec_msg *msg,
 				int reply,
 				__u8 day,
 				__u8 month,
@@ -510,7 +510,7 @@ static inline void cec_msg_clear_digital_timer(struct cec_msg *msg,
 	cec_set_digital_service_id(msg->msg + 9, digital);
 }
 
-static inline void cec_ops_clear_digital_timer(const struct cec_msg *msg,
+static __inline__ void cec_ops_clear_digital_timer(const struct cec_msg *msg,
 				__u8 *day,
 				__u8 *month,
 				__u8 *start_hr,
@@ -531,7 +531,7 @@ static inline void cec_ops_clear_digital_timer(const struct cec_msg *msg,
 	cec_get_digital_service_id(msg->msg + 9, digital);
 }
 
-static inline void cec_msg_clear_ext_timer(struct cec_msg *msg,
+static __inline__ void cec_msg_clear_ext_timer(struct cec_msg *msg,
 					   int reply,
 					   __u8 day,
 					   __u8 month,
@@ -561,7 +561,7 @@ static inline void cec_msg_clear_ext_timer(struct cec_msg *msg,
 	msg->reply = reply ? CEC_MSG_TIMER_CLEARED_STATUS : 0;
 }
 
-static inline void cec_ops_clear_ext_timer(const struct cec_msg *msg,
+static __inline__ void cec_ops_clear_ext_timer(const struct cec_msg *msg,
 					   __u8 *day,
 					   __u8 *month,
 					   __u8 *start_hr,
@@ -586,7 +586,7 @@ static inline void cec_ops_clear_ext_timer(const struct cec_msg *msg,
 	*phys_addr = (msg->msg[11] << 8) | msg->msg[12];
 }
 
-static inline void cec_msg_set_analogue_timer(struct cec_msg *msg,
+static __inline__ void cec_msg_set_analogue_timer(struct cec_msg *msg,
 					      int reply,
 					      __u8 day,
 					      __u8 month,
@@ -616,7 +616,7 @@ static inline void cec_msg_set_analogue_timer(struct cec_msg *msg,
 	msg->reply = reply ? CEC_MSG_TIMER_STATUS : 0;
 }
 
-static inline void cec_ops_set_analogue_timer(const struct cec_msg *msg,
+static __inline__ void cec_ops_set_analogue_timer(const struct cec_msg *msg,
 					      __u8 *day,
 					      __u8 *month,
 					      __u8 *start_hr,
@@ -641,7 +641,7 @@ static inline void cec_ops_set_analogue_timer(const struct cec_msg *msg,
 	*bcast_system = msg->msg[12];
 }
 
-static inline void cec_msg_set_digital_timer(struct cec_msg *msg,
+static __inline__ void cec_msg_set_digital_timer(struct cec_msg *msg,
 			int reply,
 			__u8 day,
 			__u8 month,
@@ -666,7 +666,7 @@ static inline void cec_msg_set_digital_timer(struct cec_msg *msg,
 	cec_set_digital_service_id(msg->msg + 9, digital);
 }
 
-static inline void cec_ops_set_digital_timer(const struct cec_msg *msg,
+static __inline__ void cec_ops_set_digital_timer(const struct cec_msg *msg,
 			__u8 *day,
 			__u8 *month,
 			__u8 *start_hr,
@@ -687,7 +687,7 @@ static inline void cec_ops_set_digital_timer(const struct cec_msg *msg,
 	cec_get_digital_service_id(msg->msg + 9, digital);
 }
 
-static inline void cec_msg_set_ext_timer(struct cec_msg *msg,
+static __inline__ void cec_msg_set_ext_timer(struct cec_msg *msg,
 					 int reply,
 					 __u8 day,
 					 __u8 month,
@@ -717,7 +717,7 @@ static inline void cec_msg_set_ext_timer(struct cec_msg *msg,
 	msg->reply = reply ? CEC_MSG_TIMER_STATUS : 0;
 }
 
-static inline void cec_ops_set_ext_timer(const struct cec_msg *msg,
+static __inline__ void cec_ops_set_ext_timer(const struct cec_msg *msg,
 					 __u8 *day,
 					 __u8 *month,
 					 __u8 *start_hr,
@@ -742,7 +742,7 @@ static inline void cec_ops_set_ext_timer(const struct cec_msg *msg,
 	*phys_addr = (msg->msg[11] << 8) | msg->msg[12];
 }
 
-static inline void cec_msg_set_timer_program_title(struct cec_msg *msg,
+static __inline__ void cec_msg_set_timer_program_title(struct cec_msg *msg,
 						   const char *prog_title)
 {
 	unsigned int len = strlen(prog_title);
@@ -754,7 +754,7 @@ static inline void cec_msg_set_timer_program_title(struct cec_msg *msg,
 	memcpy(msg->msg + 2, prog_title, len);
 }
 
-static inline void cec_ops_set_timer_program_title(const struct cec_msg *msg,
+static __inline__ void cec_ops_set_timer_program_title(const struct cec_msg *msg,
 						   char *prog_title)
 {
 	unsigned int len = msg->len > 2 ? msg->len - 2 : 0;
@@ -766,20 +766,20 @@ static inline void cec_ops_set_timer_program_title(const struct cec_msg *msg,
 }
 
 /* System Information Feature */
-static inline void cec_msg_cec_version(struct cec_msg *msg, __u8 cec_version)
+static __inline__ void cec_msg_cec_version(struct cec_msg *msg, __u8 cec_version)
 {
 	msg->len = 3;
 	msg->msg[1] = CEC_MSG_CEC_VERSION;
 	msg->msg[2] = cec_version;
 }
 
-static inline void cec_ops_cec_version(const struct cec_msg *msg,
+static __inline__ void cec_ops_cec_version(const struct cec_msg *msg,
 				       __u8 *cec_version)
 {
 	*cec_version = msg->msg[2];
 }
 
-static inline void cec_msg_get_cec_version(struct cec_msg *msg,
+static __inline__ void cec_msg_get_cec_version(struct cec_msg *msg,
 					   int reply)
 {
 	msg->len = 2;
@@ -787,7 +787,7 @@ static inline void cec_msg_get_cec_version(struct cec_msg *msg,
 	msg->reply = reply ? CEC_MSG_CEC_VERSION : 0;
 }
 
-static inline void cec_msg_report_physical_addr(struct cec_msg *msg,
+static __inline__ void cec_msg_report_physical_addr(struct cec_msg *msg,
 					__u16 phys_addr, __u8 prim_devtype)
 {
 	msg->len = 5;
@@ -798,14 +798,14 @@ static inline void cec_msg_report_physical_addr(struct cec_msg *msg,
 	msg->msg[4] = prim_devtype;
 }
 
-static inline void cec_ops_report_physical_addr(const struct cec_msg *msg,
+static __inline__ void cec_ops_report_physical_addr(const struct cec_msg *msg,
 					__u16 *phys_addr, __u8 *prim_devtype)
 {
 	*phys_addr = (msg->msg[2] << 8) | msg->msg[3];
 	*prim_devtype = msg->msg[4];
 }
 
-static inline void cec_msg_give_physical_addr(struct cec_msg *msg,
+static __inline__ void cec_msg_give_physical_addr(struct cec_msg *msg,
 					      int reply)
 {
 	msg->len = 2;
@@ -813,7 +813,7 @@ static inline void cec_msg_give_physical_addr(struct cec_msg *msg,
 	msg->reply = reply ? CEC_MSG_REPORT_PHYSICAL_ADDR : 0;
 }
 
-static inline void cec_msg_set_menu_language(struct cec_msg *msg,
+static __inline__ void cec_msg_set_menu_language(struct cec_msg *msg,
 					     const char *language)
 {
 	msg->len = 5;
@@ -822,14 +822,14 @@ static inline void cec_msg_set_menu_language(struct cec_msg *msg,
 	memcpy(msg->msg + 2, language, 3);
 }
 
-static inline void cec_ops_set_menu_language(const struct cec_msg *msg,
+static __inline__ void cec_ops_set_menu_language(const struct cec_msg *msg,
 					     char *language)
 {
 	memcpy(language, msg->msg + 2, 3);
 	language[3] = '\0';
 }
 
-static inline void cec_msg_get_menu_language(struct cec_msg *msg,
+static __inline__ void cec_msg_get_menu_language(struct cec_msg *msg,
 					     int reply)
 {
 	msg->len = 2;
@@ -845,7 +845,7 @@ static inline void cec_msg_get_menu_language(struct cec_msg *msg,
  * in the future, then this function needs to be adapted or a new function
  * should be added.
  */
-static inline void cec_msg_report_features(struct cec_msg *msg,
+static __inline__ void cec_msg_report_features(struct cec_msg *msg,
 				__u8 cec_version, __u8 all_device_types,
 				__u8 rc_profile, __u8 dev_features)
 {
@@ -858,7 +858,7 @@ static inline void cec_msg_report_features(struct cec_msg *msg,
 	msg->msg[5] = dev_features;
 }
 
-static inline void cec_ops_report_features(const struct cec_msg *msg,
+static __inline__ void cec_ops_report_features(const struct cec_msg *msg,
 			__u8 *cec_version, __u8 *all_device_types,
 			const __u8 **rc_profile, const __u8 **dev_features)
 {
@@ -879,7 +879,7 @@ static inline void cec_ops_report_features(const struct cec_msg *msg,
 		*rc_profile = *dev_features = NULL;
 }
 
-static inline void cec_msg_give_features(struct cec_msg *msg,
+static __inline__ void cec_msg_give_features(struct cec_msg *msg,
 					 int reply)
 {
 	msg->len = 2;
@@ -888,7 +888,7 @@ static inline void cec_msg_give_features(struct cec_msg *msg,
 }
 
 /* Deck Control Feature */
-static inline void cec_msg_deck_control(struct cec_msg *msg,
+static __inline__ void cec_msg_deck_control(struct cec_msg *msg,
 					__u8 deck_control_mode)
 {
 	msg->len = 3;
@@ -896,13 +896,13 @@ static inline void cec_msg_deck_control(struct cec_msg *msg,
 	msg->msg[2] = deck_control_mode;
 }
 
-static inline void cec_ops_deck_control(const struct cec_msg *msg,
+static __inline__ void cec_ops_deck_control(const struct cec_msg *msg,
 					__u8 *deck_control_mode)
 {
 	*deck_control_mode = msg->msg[2];
 }
 
-static inline void cec_msg_deck_status(struct cec_msg *msg,
+static __inline__ void cec_msg_deck_status(struct cec_msg *msg,
 				       __u8 deck_info)
 {
 	msg->len = 3;
@@ -910,13 +910,13 @@ static inline void cec_msg_deck_status(struct cec_msg *msg,
 	msg->msg[2] = deck_info;
 }
 
-static inline void cec_ops_deck_status(const struct cec_msg *msg,
+static __inline__ void cec_ops_deck_status(const struct cec_msg *msg,
 				       __u8 *deck_info)
 {
 	*deck_info = msg->msg[2];
 }
 
-static inline void cec_msg_give_deck_status(struct cec_msg *msg,
+static __inline__ void cec_msg_give_deck_status(struct cec_msg *msg,
 					    int reply,
 					    __u8 status_req)
 {
@@ -926,13 +926,13 @@ static inline void cec_msg_give_deck_status(struct cec_msg *msg,
 	msg->reply = reply ? CEC_MSG_DECK_STATUS : 0;
 }
 
-static inline void cec_ops_give_deck_status(const struct cec_msg *msg,
+static __inline__ void cec_ops_give_deck_status(const struct cec_msg *msg,
 					    __u8 *status_req)
 {
 	*status_req = msg->msg[2];
 }
 
-static inline void cec_msg_play(struct cec_msg *msg,
+static __inline__ void cec_msg_play(struct cec_msg *msg,
 				__u8 play_mode)
 {
 	msg->len = 3;
@@ -940,7 +940,7 @@ static inline void cec_msg_play(struct cec_msg *msg,
 	msg->msg[2] = play_mode;
 }
 
-static inline void cec_ops_play(const struct cec_msg *msg,
+static __inline__ void cec_ops_play(const struct cec_msg *msg,
 				__u8 *play_mode)
 {
 	*play_mode = msg->msg[2];
@@ -962,7 +962,7 @@ struct cec_op_tuner_device_info {
 	};
 };
 
-static inline void cec_msg_tuner_device_status_analog(struct cec_msg *msg,
+static __inline__ void cec_msg_tuner_device_status_analog(struct cec_msg *msg,
 						      __u8 rec_flag,
 						      __u8 tuner_display_info,
 						      __u8 ana_bcast_type,
@@ -978,7 +978,7 @@ static inline void cec_msg_tuner_device_status_analog(struct cec_msg *msg,
 	msg->msg[6] = bcast_system;
 }
 
-static inline void cec_msg_tuner_device_status_digital(struct cec_msg *msg,
+static __inline__ void cec_msg_tuner_device_status_digital(struct cec_msg *msg,
 		   __u8 rec_flag, __u8 tuner_display_info,
 		   const struct cec_op_digital_service_id *digital)
 {
@@ -988,7 +988,7 @@ static inline void cec_msg_tuner_device_status_digital(struct cec_msg *msg,
 	cec_set_digital_service_id(msg->msg + 3, digital);
 }
 
-static inline void cec_msg_tuner_device_status(struct cec_msg *msg,
+static __inline__ void cec_msg_tuner_device_status(struct cec_msg *msg,
 			const struct cec_op_tuner_device_info *tuner_dev_info)
 {
 	if (tuner_dev_info->is_analog)
@@ -1005,7 +1005,7 @@ static inline void cec_msg_tuner_device_status(struct cec_msg *msg,
 			&tuner_dev_info->digital);
 }
 
-static inline void cec_ops_tuner_device_status(const struct cec_msg *msg,
+static __inline__ void cec_ops_tuner_device_status(const struct cec_msg *msg,
 				struct cec_op_tuner_device_info *tuner_dev_info)
 {
 	tuner_dev_info->is_analog = msg->len < 10;
@@ -1020,7 +1020,7 @@ static inline void cec_ops_tuner_device_status(const struct cec_msg *msg,
 	cec_get_digital_service_id(msg->msg + 3, &tuner_dev_info->digital);
 }
 
-static inline void cec_msg_give_tuner_device_status(struct cec_msg *msg,
+static __inline__ void cec_msg_give_tuner_device_status(struct cec_msg *msg,
 						    int reply,
 						    __u8 status_req)
 {
@@ -1030,13 +1030,13 @@ static inline void cec_msg_give_tuner_device_status(struct cec_msg *msg,
 	msg->reply = reply ? CEC_MSG_TUNER_DEVICE_STATUS : 0;
 }
 
-static inline void cec_ops_give_tuner_device_status(const struct cec_msg *msg,
+static __inline__ void cec_ops_give_tuner_device_status(const struct cec_msg *msg,
 						    __u8 *status_req)
 {
 	*status_req = msg->msg[2];
 }
 
-static inline void cec_msg_select_analogue_service(struct cec_msg *msg,
+static __inline__ void cec_msg_select_analogue_service(struct cec_msg *msg,
 						   __u8 ana_bcast_type,
 						   __u16 ana_freq,
 						   __u8 bcast_system)
@@ -1049,7 +1049,7 @@ static inline void cec_msg_select_analogue_service(struct cec_msg *msg,
 	msg->msg[5] = bcast_system;
 }
 
-static inline void cec_ops_select_analogue_service(const struct cec_msg *msg,
+static __inline__ void cec_ops_select_analogue_service(const struct cec_msg *msg,
 						   __u8 *ana_bcast_type,
 						   __u16 *ana_freq,
 						   __u8 *bcast_system)
@@ -1059,7 +1059,7 @@ static inline void cec_ops_select_analogue_service(const struct cec_msg *msg,
 	*bcast_system = msg->msg[5];
 }
 
-static inline void cec_msg_select_digital_service(struct cec_msg *msg,
+static __inline__ void cec_msg_select_digital_service(struct cec_msg *msg,
 				const struct cec_op_digital_service_id *digital)
 {
 	msg->len = 9;
@@ -1067,19 +1067,19 @@ static inline void cec_msg_select_digital_service(struct cec_msg *msg,
 	cec_set_digital_service_id(msg->msg + 2, digital);
 }
 
-static inline void cec_ops_select_digital_service(const struct cec_msg *msg,
+static __inline__ void cec_ops_select_digital_service(const struct cec_msg *msg,
 				struct cec_op_digital_service_id *digital)
 {
 	cec_get_digital_service_id(msg->msg + 2, digital);
 }
 
-static inline void cec_msg_tuner_step_decrement(struct cec_msg *msg)
+static __inline__ void cec_msg_tuner_step_decrement(struct cec_msg *msg)
 {
 	msg->len = 2;
 	msg->msg[1] = CEC_MSG_TUNER_STEP_DECREMENT;
 }
 
-static inline void cec_msg_tuner_step_increment(struct cec_msg *msg)
+static __inline__ void cec_msg_tuner_step_increment(struct cec_msg *msg)
 {
 	msg->len = 2;
 	msg->msg[1] = CEC_MSG_TUNER_STEP_INCREMENT;
@@ -1087,7 +1087,7 @@ static inline void cec_msg_tuner_step_increment(struct cec_msg *msg)
 
 
 /* Vendor Specific Commands Feature */
-static inline void cec_msg_device_vendor_id(struct cec_msg *msg, __u32 vendor_id)
+static __inline__ void cec_msg_device_vendor_id(struct cec_msg *msg, __u32 vendor_id)
 {
 	msg->len = 5;
 	msg->msg[0] |= 0xf; /* broadcast */
@@ -1097,13 +1097,13 @@ static inline void cec_msg_device_vendor_id(struct cec_msg *msg, __u32 vendor_id
 	msg->msg[4] = vendor_id & 0xff;
 }
 
-static inline void cec_ops_device_vendor_id(const struct cec_msg *msg,
+static __inline__ void cec_ops_device_vendor_id(const struct cec_msg *msg,
 					    __u32 *vendor_id)
 {
 	*vendor_id = (msg->msg[2] << 16) | (msg->msg[3] << 8) | msg->msg[4];
 }
 
-static inline void cec_msg_give_device_vendor_id(struct cec_msg *msg,
+static __inline__ void cec_msg_give_device_vendor_id(struct cec_msg *msg,
 						 int reply)
 {
 	msg->len = 2;
@@ -1111,7 +1111,7 @@ static inline void cec_msg_give_device_vendor_id(struct cec_msg *msg,
 	msg->reply = reply ? CEC_MSG_DEVICE_VENDOR_ID : 0;
 }
 
-static inline void cec_msg_vendor_command(struct cec_msg *msg,
+static __inline__ void cec_msg_vendor_command(struct cec_msg *msg,
 					  __u8 size, const __u8 *vendor_cmd)
 {
 	if (size > 14)
@@ -1121,7 +1121,7 @@ static inline void cec_msg_vendor_command(struct cec_msg *msg,
 	memcpy(msg->msg + 2, vendor_cmd, size);
 }
 
-static inline void cec_ops_vendor_command(const struct cec_msg *msg,
+static __inline__ void cec_ops_vendor_command(const struct cec_msg *msg,
 					  __u8 *size,
 					  const __u8 **vendor_cmd)
 {
@@ -1132,7 +1132,7 @@ static inline void cec_ops_vendor_command(const struct cec_msg *msg,
 	*vendor_cmd = msg->msg + 2;
 }
 
-static inline void cec_msg_vendor_command_with_id(struct cec_msg *msg,
+static __inline__ void cec_msg_vendor_command_with_id(struct cec_msg *msg,
 						  __u32 vendor_id, __u8 size,
 						  const __u8 *vendor_cmd)
 {
@@ -1146,7 +1146,7 @@ static inline void cec_msg_vendor_command_with_id(struct cec_msg *msg,
 	memcpy(msg->msg + 5, vendor_cmd, size);
 }
 
-static inline void cec_ops_vendor_command_with_id(const struct cec_msg *msg,
+static __inline__ void cec_ops_vendor_command_with_id(const struct cec_msg *msg,
 						  __u32 *vendor_id,  __u8 *size,
 						  const __u8 **vendor_cmd)
 {
@@ -1158,7 +1158,7 @@ static inline void cec_ops_vendor_command_with_id(const struct cec_msg *msg,
 	*vendor_cmd = msg->msg + 5;
 }
 
-static inline void cec_msg_vendor_remote_button_down(struct cec_msg *msg,
+static __inline__ void cec_msg_vendor_remote_button_down(struct cec_msg *msg,
 						     __u8 size,
 						     const __u8 *rc_code)
 {
@@ -1169,7 +1169,7 @@ static inline void cec_msg_vendor_remote_button_down(struct cec_msg *msg,
 	memcpy(msg->msg + 2, rc_code, size);
 }
 
-static inline void cec_ops_vendor_remote_button_down(const struct cec_msg *msg,
+static __inline__ void cec_ops_vendor_remote_button_down(const struct cec_msg *msg,
 						     __u8 *size,
 						     const __u8 **rc_code)
 {
@@ -1180,7 +1180,7 @@ static inline void cec_ops_vendor_remote_button_down(const struct cec_msg *msg,
 	*rc_code = msg->msg + 2;
 }
 
-static inline void cec_msg_vendor_remote_button_up(struct cec_msg *msg)
+static __inline__ void cec_msg_vendor_remote_button_up(struct cec_msg *msg)
 {
 	msg->len = 2;
 	msg->msg[1] = CEC_MSG_VENDOR_REMOTE_BUTTON_UP;
@@ -1188,7 +1188,7 @@ static inline void cec_msg_vendor_remote_button_up(struct cec_msg *msg)
 
 
 /* OSD Display Feature */
-static inline void cec_msg_set_osd_string(struct cec_msg *msg,
+static __inline__ void cec_msg_set_osd_string(struct cec_msg *msg,
 					  __u8 disp_ctl,
 					  const char *osd)
 {
@@ -1202,7 +1202,7 @@ static inline void cec_msg_set_osd_string(struct cec_msg *msg,
 	memcpy(msg->msg + 3, osd, len);
 }
 
-static inline void cec_ops_set_osd_string(const struct cec_msg *msg,
+static __inline__ void cec_ops_set_osd_string(const struct cec_msg *msg,
 					  __u8 *disp_ctl,
 					  char *osd)
 {
@@ -1217,7 +1217,7 @@ static inline void cec_ops_set_osd_string(const struct cec_msg *msg,
 
 
 /* Device OSD Transfer Feature */
-static inline void cec_msg_set_osd_name(struct cec_msg *msg, const char *name)
+static __inline__ void cec_msg_set_osd_name(struct cec_msg *msg, const char *name)
 {
 	unsigned int len = strlen(name);
 
@@ -1228,7 +1228,7 @@ static inline void cec_msg_set_osd_name(struct cec_msg *msg, const char *name)
 	memcpy(msg->msg + 2, name, len);
 }
 
-static inline void cec_ops_set_osd_name(const struct cec_msg *msg,
+static __inline__ void cec_ops_set_osd_name(const struct cec_msg *msg,
 					char *name)
 {
 	unsigned int len = msg->len > 2 ? msg->len - 2 : 0;
@@ -1239,7 +1239,7 @@ static inline void cec_ops_set_osd_name(const struct cec_msg *msg,
 	name[len] = '\0';
 }
 
-static inline void cec_msg_give_osd_name(struct cec_msg *msg,
+static __inline__ void cec_msg_give_osd_name(struct cec_msg *msg,
 					 int reply)
 {
 	msg->len = 2;
@@ -1249,7 +1249,7 @@ static inline void cec_msg_give_osd_name(struct cec_msg *msg,
 
 
 /* Device Menu Control Feature */
-static inline void cec_msg_menu_status(struct cec_msg *msg,
+static __inline__ void cec_msg_menu_status(struct cec_msg *msg,
 				       __u8 menu_state)
 {
 	msg->len = 3;
@@ -1257,13 +1257,13 @@ static inline void cec_msg_menu_status(struct cec_msg *msg,
 	msg->msg[2] = menu_state;
 }
 
-static inline void cec_ops_menu_status(const struct cec_msg *msg,
+static __inline__ void cec_ops_menu_status(const struct cec_msg *msg,
 				       __u8 *menu_state)
 {
 	*menu_state = msg->msg[2];
 }
 
-static inline void cec_msg_menu_request(struct cec_msg *msg,
+static __inline__ void cec_msg_menu_request(struct cec_msg *msg,
 					int reply,
 					__u8 menu_req)
 {
@@ -1273,7 +1273,7 @@ static inline void cec_msg_menu_request(struct cec_msg *msg,
 	msg->reply = reply ? CEC_MSG_MENU_STATUS : 0;
 }
 
-static inline void cec_ops_menu_request(const struct cec_msg *msg,
+static __inline__ void cec_ops_menu_request(const struct cec_msg *msg,
 					__u8 *menu_req)
 {
 	*menu_req = msg->msg[2];
@@ -1293,7 +1293,7 @@ struct cec_op_ui_command {
 	};
 };
 
-static inline void cec_msg_user_control_pressed(struct cec_msg *msg,
+static __inline__ void cec_msg_user_control_pressed(struct cec_msg *msg,
 					const struct cec_op_ui_command *ui_cmd)
 {
 	msg->len = 3;
@@ -1323,7 +1323,7 @@ static inline void cec_msg_user_control_pressed(struct cec_msg *msg,
 	}
 }
 
-static inline void cec_ops_user_control_pressed(const struct cec_msg *msg,
+static __inline__ void cec_ops_user_control_pressed(const struct cec_msg *msg,
 						struct cec_op_ui_command *ui_cmd)
 {
 	ui_cmd->ui_cmd = msg->msg[2];
@@ -1352,7 +1352,7 @@ static inline void cec_ops_user_control_pressed(const struct cec_msg *msg,
 	}
 }
 
-static inline void cec_msg_user_control_released(struct cec_msg *msg)
+static __inline__ void cec_msg_user_control_released(struct cec_msg *msg)
 {
 	msg->len = 2;
 	msg->msg[1] = CEC_MSG_USER_CONTROL_RELEASED;
@@ -1361,7 +1361,7 @@ static inline void cec_msg_user_control_released(struct cec_msg *msg)
 /* Remote Control Passthrough Feature */
 
 /* Power Status Feature */
-static inline void cec_msg_report_power_status(struct cec_msg *msg,
+static __inline__ void cec_msg_report_power_status(struct cec_msg *msg,
 					       __u8 pwr_state)
 {
 	msg->len = 3;
@@ -1369,13 +1369,13 @@ static inline void cec_msg_report_power_status(struct cec_msg *msg,
 	msg->msg[2] = pwr_state;
 }
 
-static inline void cec_ops_report_power_status(const struct cec_msg *msg,
+static __inline__ void cec_ops_report_power_status(const struct cec_msg *msg,
 					       __u8 *pwr_state)
 {
 	*pwr_state = msg->msg[2];
 }
 
-static inline void cec_msg_give_device_power_status(struct cec_msg *msg,
+static __inline__ void cec_msg_give_device_power_status(struct cec_msg *msg,
 						    int reply)
 {
 	msg->len = 2;
@@ -1384,7 +1384,7 @@ static inline void cec_msg_give_device_power_status(struct cec_msg *msg,
 }
 
 /* General Protocol Messages */
-static inline void cec_msg_feature_abort(struct cec_msg *msg,
+static __inline__ void cec_msg_feature_abort(struct cec_msg *msg,
 					 __u8 abort_msg, __u8 reason)
 {
 	msg->len = 4;
@@ -1393,7 +1393,7 @@ static inline void cec_msg_feature_abort(struct cec_msg *msg,
 	msg->msg[3] = reason;
 }
 
-static inline void cec_ops_feature_abort(const struct cec_msg *msg,
+static __inline__ void cec_ops_feature_abort(const struct cec_msg *msg,
 					 __u8 *abort_msg, __u8 *reason)
 {
 	*abort_msg = msg->msg[2];
@@ -1401,7 +1401,7 @@ static inline void cec_ops_feature_abort(const struct cec_msg *msg,
 }
 
 /* This changes the current message into a feature abort message */
-static inline void cec_msg_reply_feature_abort(struct cec_msg *msg, __u8 reason)
+static __inline__ void cec_msg_reply_feature_abort(struct cec_msg *msg, __u8 reason)
 {
 	cec_msg_set_reply_to(msg, msg);
 	msg->len = 4;
@@ -1410,7 +1410,7 @@ static inline void cec_msg_reply_feature_abort(struct cec_msg *msg, __u8 reason)
 	msg->msg[1] = CEC_MSG_FEATURE_ABORT;
 }
 
-static inline void cec_msg_abort(struct cec_msg *msg)
+static __inline__ void cec_msg_abort(struct cec_msg *msg)
 {
 	msg->len = 2;
 	msg->msg[1] = CEC_MSG_ABORT;
@@ -1418,7 +1418,7 @@ static inline void cec_msg_abort(struct cec_msg *msg)
 
 
 /* System Audio Control Feature */
-static inline void cec_msg_report_audio_status(struct cec_msg *msg,
+static __inline__ void cec_msg_report_audio_status(struct cec_msg *msg,
 					       __u8 aud_mute_status,
 					       __u8 aud_vol_status)
 {
@@ -1427,7 +1427,7 @@ static inline void cec_msg_report_audio_status(struct cec_msg *msg,
 	msg->msg[2] = (aud_mute_status << 7) | (aud_vol_status & 0x7f);
 }
 
-static inline void cec_ops_report_audio_status(const struct cec_msg *msg,
+static __inline__ void cec_ops_report_audio_status(const struct cec_msg *msg,
 					       __u8 *aud_mute_status,
 					       __u8 *aud_vol_status)
 {
@@ -1435,7 +1435,7 @@ static inline void cec_ops_report_audio_status(const struct cec_msg *msg,
 	*aud_vol_status = msg->msg[2] & 0x7f;
 }
 
-static inline void cec_msg_give_audio_status(struct cec_msg *msg,
+static __inline__ void cec_msg_give_audio_status(struct cec_msg *msg,
 					     int reply)
 {
 	msg->len = 2;
@@ -1443,7 +1443,7 @@ static inline void cec_msg_give_audio_status(struct cec_msg *msg,
 	msg->reply = reply ? CEC_MSG_REPORT_AUDIO_STATUS : 0;
 }
 
-static inline void cec_msg_set_system_audio_mode(struct cec_msg *msg,
+static __inline__ void cec_msg_set_system_audio_mode(struct cec_msg *msg,
 						 __u8 sys_aud_status)
 {
 	msg->len = 3;
@@ -1451,13 +1451,13 @@ static inline void cec_msg_set_system_audio_mode(struct cec_msg *msg,
 	msg->msg[2] = sys_aud_status;
 }
 
-static inline void cec_ops_set_system_audio_mode(const struct cec_msg *msg,
+static __inline__ void cec_ops_set_system_audio_mode(const struct cec_msg *msg,
 						 __u8 *sys_aud_status)
 {
 	*sys_aud_status = msg->msg[2];
 }
 
-static inline void cec_msg_system_audio_mode_request(struct cec_msg *msg,
+static __inline__ void cec_msg_system_audio_mode_request(struct cec_msg *msg,
 						     int reply,
 						     __u16 phys_addr)
 {
@@ -1469,7 +1469,7 @@ static inline void cec_msg_system_audio_mode_request(struct cec_msg *msg,
 
 }
 
-static inline void cec_ops_system_audio_mode_request(const struct cec_msg *msg,
+static __inline__ void cec_ops_system_audio_mode_request(const struct cec_msg *msg,
 						     __u16 *phys_addr)
 {
 	if (msg->len < 4)
@@ -1478,7 +1478,7 @@ static inline void cec_ops_system_audio_mode_request(const struct cec_msg *msg,
 		*phys_addr = (msg->msg[2] << 8) | msg->msg[3];
 }
 
-static inline void cec_msg_system_audio_mode_status(struct cec_msg *msg,
+static __inline__ void cec_msg_system_audio_mode_status(struct cec_msg *msg,
 						    __u8 sys_aud_status)
 {
 	msg->len = 3;
@@ -1486,13 +1486,13 @@ static inline void cec_msg_system_audio_mode_status(struct cec_msg *msg,
 	msg->msg[2] = sys_aud_status;
 }
 
-static inline void cec_ops_system_audio_mode_status(const struct cec_msg *msg,
+static __inline__ void cec_ops_system_audio_mode_status(const struct cec_msg *msg,
 						    __u8 *sys_aud_status)
 {
 	*sys_aud_status = msg->msg[2];
 }
 
-static inline void cec_msg_give_system_audio_mode_status(struct cec_msg *msg,
+static __inline__ void cec_msg_give_system_audio_mode_status(struct cec_msg *msg,
 							 int reply)
 {
 	msg->len = 2;
@@ -1500,7 +1500,7 @@ static inline void cec_msg_give_system_audio_mode_status(struct cec_msg *msg,
 	msg->reply = reply ? CEC_MSG_SYSTEM_AUDIO_MODE_STATUS : 0;
 }
 
-static inline void cec_msg_report_short_audio_descriptor(struct cec_msg *msg,
+static __inline__ void cec_msg_report_short_audio_descriptor(struct cec_msg *msg,
 					__u8 num_descriptors,
 					const __u32 *descriptors)
 {
@@ -1517,7 +1517,7 @@ static inline void cec_msg_report_short_audio_descriptor(struct cec_msg *msg,
 	}
 }
 
-static inline void cec_ops_report_short_audio_descriptor(const struct cec_msg *msg,
+static __inline__ void cec_ops_report_short_audio_descriptor(const struct cec_msg *msg,
 							 __u8 *num_descriptors,
 							 __u32 *descriptors)
 {
@@ -1532,7 +1532,7 @@ static inline void cec_ops_report_short_audio_descriptor(const struct cec_msg *m
 			msg->msg[4 + i * 3];
 }
 
-static inline void cec_msg_request_short_audio_descriptor(struct cec_msg *msg,
+static __inline__ void cec_msg_request_short_audio_descriptor(struct cec_msg *msg,
 					int reply,
 					__u8 num_descriptors,
 					const __u8 *audio_format_id,
@@ -1550,7 +1550,7 @@ static inline void cec_msg_request_short_audio_descriptor(struct cec_msg *msg,
 				  (audio_format_code[i] & 0x3f);
 }
 
-static inline void cec_ops_request_short_audio_descriptor(const struct cec_msg *msg,
+static __inline__ void cec_ops_request_short_audio_descriptor(const struct cec_msg *msg,
 					__u8 *num_descriptors,
 					__u8 *audio_format_id,
 					__u8 *audio_format_code)
@@ -1568,7 +1568,7 @@ static inline void cec_ops_request_short_audio_descriptor(const struct cec_msg *
 
 
 /* Audio Rate Control Feature */
-static inline void cec_msg_set_audio_rate(struct cec_msg *msg,
+static __inline__ void cec_msg_set_audio_rate(struct cec_msg *msg,
 					  __u8 audio_rate)
 {
 	msg->len = 3;
@@ -1576,7 +1576,7 @@ static inline void cec_msg_set_audio_rate(struct cec_msg *msg,
 	msg->msg[2] = audio_rate;
 }
 
-static inline void cec_ops_set_audio_rate(const struct cec_msg *msg,
+static __inline__ void cec_ops_set_audio_rate(const struct cec_msg *msg,
 					  __u8 *audio_rate)
 {
 	*audio_rate = msg->msg[2];
@@ -1584,13 +1584,13 @@ static inline void cec_ops_set_audio_rate(const struct cec_msg *msg,
 
 
 /* Audio Return Channel Control Feature */
-static inline void cec_msg_report_arc_initiated(struct cec_msg *msg)
+static __inline__ void cec_msg_report_arc_initiated(struct cec_msg *msg)
 {
 	msg->len = 2;
 	msg->msg[1] = CEC_MSG_REPORT_ARC_INITIATED;
 }
 
-static inline void cec_msg_initiate_arc(struct cec_msg *msg,
+static __inline__ void cec_msg_initiate_arc(struct cec_msg *msg,
 					int reply)
 {
 	msg->len = 2;
@@ -1598,7 +1598,7 @@ static inline void cec_msg_initiate_arc(struct cec_msg *msg,
 	msg->reply = reply ? CEC_MSG_REPORT_ARC_INITIATED : 0;
 }
 
-static inline void cec_msg_request_arc_initiation(struct cec_msg *msg,
+static __inline__ void cec_msg_request_arc_initiation(struct cec_msg *msg,
 						  int reply)
 {
 	msg->len = 2;
@@ -1606,13 +1606,13 @@ static inline void cec_msg_request_arc_initiation(struct cec_msg *msg,
 	msg->reply = reply ? CEC_MSG_INITIATE_ARC : 0;
 }
 
-static inline void cec_msg_report_arc_terminated(struct cec_msg *msg)
+static __inline__ void cec_msg_report_arc_terminated(struct cec_msg *msg)
 {
 	msg->len = 2;
 	msg->msg[1] = CEC_MSG_REPORT_ARC_TERMINATED;
 }
 
-static inline void cec_msg_terminate_arc(struct cec_msg *msg,
+static __inline__ void cec_msg_terminate_arc(struct cec_msg *msg,
 					 int reply)
 {
 	msg->len = 2;
@@ -1620,7 +1620,7 @@ static inline void cec_msg_terminate_arc(struct cec_msg *msg,
 	msg->reply = reply ? CEC_MSG_REPORT_ARC_TERMINATED : 0;
 }
 
-static inline void cec_msg_request_arc_termination(struct cec_msg *msg,
+static __inline__ void cec_msg_request_arc_termination(struct cec_msg *msg,
 						   int reply)
 {
 	msg->len = 2;
@@ -1631,7 +1631,7 @@ static inline void cec_msg_request_arc_termination(struct cec_msg *msg,
 
 /* Dynamic Audio Lipsync Feature */
 /* Only for CEC 2.0 and up */
-static inline void cec_msg_report_current_latency(struct cec_msg *msg,
+static __inline__ void cec_msg_report_current_latency(struct cec_msg *msg,
 						  __u16 phys_addr,
 						  __u8 video_latency,
 						  __u8 low_latency_mode,
@@ -1649,7 +1649,7 @@ static inline void cec_msg_report_current_latency(struct cec_msg *msg,
 		msg->msg[msg->len++] = audio_out_delay;
 }
 
-static inline void cec_ops_report_current_latency(const struct cec_msg *msg,
+static __inline__ void cec_ops_report_current_latency(const struct cec_msg *msg,
 						  __u16 *phys_addr,
 						  __u8 *video_latency,
 						  __u8 *low_latency_mode,
@@ -1666,7 +1666,7 @@ static inline void cec_ops_report_current_latency(const struct cec_msg *msg,
 		*audio_out_delay = 0;
 }
 
-static inline void cec_msg_request_current_latency(struct cec_msg *msg,
+static __inline__ void cec_msg_request_current_latency(struct cec_msg *msg,
 						   int reply,
 						   __u16 phys_addr)
 {
@@ -1678,7 +1678,7 @@ static inline void cec_msg_request_current_latency(struct cec_msg *msg,
 	msg->reply = reply ? CEC_MSG_REPORT_CURRENT_LATENCY : 0;
 }
 
-static inline void cec_ops_request_current_latency(const struct cec_msg *msg,
+static __inline__ void cec_ops_request_current_latency(const struct cec_msg *msg,
 						   __u16 *phys_addr)
 {
 	*phys_addr = (msg->msg[2] << 8) | msg->msg[3];
@@ -1686,7 +1686,7 @@ static inline void cec_ops_request_current_latency(const struct cec_msg *msg,
 
 
 /* Capability Discovery and Control Feature */
-static inline void cec_msg_cdc_hec_inquire_state(struct cec_msg *msg,
+static __inline__ void cec_msg_cdc_hec_inquire_state(struct cec_msg *msg,
 						 __u16 phys_addr1,
 						 __u16 phys_addr2)
 {
@@ -1701,7 +1701,7 @@ static inline void cec_msg_cdc_hec_inquire_state(struct cec_msg *msg,
 	msg->msg[8] = phys_addr2 & 0xff;
 }
 
-static inline void cec_ops_cdc_hec_inquire_state(const struct cec_msg *msg,
+static __inline__ void cec_ops_cdc_hec_inquire_state(const struct cec_msg *msg,
 						 __u16 *phys_addr,
 						 __u16 *phys_addr1,
 						 __u16 *phys_addr2)
@@ -1711,7 +1711,7 @@ static inline void cec_ops_cdc_hec_inquire_state(const struct cec_msg *msg,
 	*phys_addr2 = (msg->msg[7] << 8) | msg->msg[8];
 }
 
-static inline void cec_msg_cdc_hec_report_state(struct cec_msg *msg,
+static __inline__ void cec_msg_cdc_hec_report_state(struct cec_msg *msg,
 						__u16 target_phys_addr,
 						__u8 hec_func_state,
 						__u8 host_func_state,
@@ -1737,7 +1737,7 @@ static inline void cec_msg_cdc_hec_report_state(struct cec_msg *msg,
 	}
 }
 
-static inline void cec_ops_cdc_hec_report_state(const struct cec_msg *msg,
+static __inline__ void cec_ops_cdc_hec_report_state(const struct cec_msg *msg,
 						__u16 *phys_addr,
 						__u16 *target_phys_addr,
 						__u8 *hec_func_state,
@@ -1757,7 +1757,7 @@ static inline void cec_ops_cdc_hec_report_state(const struct cec_msg *msg,
 	*hec_field = *has_field ? ((msg->msg[8] << 8) | msg->msg[9]) : 0;
 }
 
-static inline void cec_msg_cdc_hec_set_state(struct cec_msg *msg,
+static __inline__ void cec_msg_cdc_hec_set_state(struct cec_msg *msg,
 					     __u16 phys_addr1,
 					     __u16 phys_addr2,
 					     __u8 hec_set_state,
@@ -1789,7 +1789,7 @@ static inline void cec_msg_cdc_hec_set_state(struct cec_msg *msg,
 	}
 }
 
-static inline void cec_ops_cdc_hec_set_state(const struct cec_msg *msg,
+static __inline__ void cec_ops_cdc_hec_set_state(const struct cec_msg *msg,
 					     __u16 *phys_addr,
 					     __u16 *phys_addr1,
 					     __u16 *phys_addr2,
@@ -1811,7 +1811,7 @@ static inline void cec_ops_cdc_hec_set_state(const struct cec_msg *msg,
 		*phys_addr5 = (msg->msg[14] << 8) | msg->msg[15];
 }
 
-static inline void cec_msg_cdc_hec_set_state_adjacent(struct cec_msg *msg,
+static __inline__ void cec_msg_cdc_hec_set_state_adjacent(struct cec_msg *msg,
 						      __u16 phys_addr1,
 						      __u8 hec_set_state)
 {
@@ -1825,7 +1825,7 @@ static inline void cec_msg_cdc_hec_set_state_adjacent(struct cec_msg *msg,
 	msg->msg[7] = hec_set_state;
 }
 
-static inline void cec_ops_cdc_hec_set_state_adjacent(const struct cec_msg *msg,
+static __inline__ void cec_ops_cdc_hec_set_state_adjacent(const struct cec_msg *msg,
 						      __u16 *phys_addr,
 						      __u16 *phys_addr1,
 						      __u8 *hec_set_state)
@@ -1835,7 +1835,7 @@ static inline void cec_ops_cdc_hec_set_state_adjacent(const struct cec_msg *msg,
 	*hec_set_state = msg->msg[7];
 }
 
-static inline void cec_msg_cdc_hec_request_deactivation(struct cec_msg *msg,
+static __inline__ void cec_msg_cdc_hec_request_deactivation(struct cec_msg *msg,
 							__u16 phys_addr1,
 							__u16 phys_addr2,
 							__u16 phys_addr3)
@@ -1853,7 +1853,7 @@ static inline void cec_msg_cdc_hec_request_deactivation(struct cec_msg *msg,
 	msg->msg[10] = phys_addr3 & 0xff;
 }
 
-static inline void cec_ops_cdc_hec_request_deactivation(const struct cec_msg *msg,
+static __inline__ void cec_ops_cdc_hec_request_deactivation(const struct cec_msg *msg,
 							__u16 *phys_addr,
 							__u16 *phys_addr1,
 							__u16 *phys_addr2,
@@ -1865,7 +1865,7 @@ static inline void cec_ops_cdc_hec_request_deactivation(const struct cec_msg *ms
 	*phys_addr3 = (msg->msg[9] << 8) | msg->msg[10];
 }
 
-static inline void cec_msg_cdc_hec_notify_alive(struct cec_msg *msg)
+static __inline__ void cec_msg_cdc_hec_notify_alive(struct cec_msg *msg)
 {
 	msg->len = 5;
 	msg->msg[0] |= 0xf; /* broadcast */
@@ -1874,13 +1874,13 @@ static inline void cec_msg_cdc_hec_notify_alive(struct cec_msg *msg)
 	msg->msg[4] = CEC_MSG_CDC_HEC_NOTIFY_ALIVE;
 }
 
-static inline void cec_ops_cdc_hec_notify_alive(const struct cec_msg *msg,
+static __inline__ void cec_ops_cdc_hec_notify_alive(const struct cec_msg *msg,
 						__u16 *phys_addr)
 {
 	*phys_addr = (msg->msg[2] << 8) | msg->msg[3];
 }
 
-static inline void cec_msg_cdc_hec_discover(struct cec_msg *msg)
+static __inline__ void cec_msg_cdc_hec_discover(struct cec_msg *msg)
 {
 	msg->len = 5;
 	msg->msg[0] |= 0xf; /* broadcast */
@@ -1889,13 +1889,13 @@ static inline void cec_msg_cdc_hec_discover(struct cec_msg *msg)
 	msg->msg[4] = CEC_MSG_CDC_HEC_DISCOVER;
 }
 
-static inline void cec_ops_cdc_hec_discover(const struct cec_msg *msg,
+static __inline__ void cec_ops_cdc_hec_discover(const struct cec_msg *msg,
 					    __u16 *phys_addr)
 {
 	*phys_addr = (msg->msg[2] << 8) | msg->msg[3];
 }
 
-static inline void cec_msg_cdc_hpd_set_state(struct cec_msg *msg,
+static __inline__ void cec_msg_cdc_hpd_set_state(struct cec_msg *msg,
 					     __u8 input_port,
 					     __u8 hpd_state)
 {
@@ -1907,7 +1907,7 @@ static inline void cec_msg_cdc_hpd_set_state(struct cec_msg *msg,
 	msg->msg[5] = (input_port << 4) | hpd_state;
 }
 
-static inline void cec_ops_cdc_hpd_set_state(const struct cec_msg *msg,
+static __inline__ void cec_ops_cdc_hpd_set_state(const struct cec_msg *msg,
 					    __u16 *phys_addr,
 					    __u8 *input_port,
 					    __u8 *hpd_state)
@@ -1917,7 +1917,7 @@ static inline void cec_ops_cdc_hpd_set_state(const struct cec_msg *msg,
 	*hpd_state = msg->msg[5] & 0xf;
 }
 
-static inline void cec_msg_cdc_hpd_report_state(struct cec_msg *msg,
+static __inline__ void cec_msg_cdc_hpd_report_state(struct cec_msg *msg,
 						__u8 hpd_state,
 						__u8 hpd_error)
 {
@@ -1929,7 +1929,7 @@ static inline void cec_msg_cdc_hpd_report_state(struct cec_msg *msg,
 	msg->msg[5] = (hpd_state << 4) | hpd_error;
 }
 
-static inline void cec_ops_cdc_hpd_report_state(const struct cec_msg *msg,
+static __inline__ void cec_ops_cdc_hpd_report_state(const struct cec_msg *msg,
 						__u16 *phys_addr,
 						__u8 *hpd_state,
 						__u8 *hpd_error)
diff --git a/include/linux/cec.h b/include/linux/cec.h
index 20fe091..0161700 100644
--- a/include/linux/cec.h
+++ b/include/linux/cec.h
@@ -75,7 +75,7 @@ struct cec_msg {
  * cec_msg_initiator - return the initiator's logical address.
  * @msg:	the message structure
  */
-static inline __u8 cec_msg_initiator(const struct cec_msg *msg)
+static __inline__ __u8 cec_msg_initiator(const struct cec_msg *msg)
 {
 	return msg->msg[0] >> 4;
 }
@@ -84,7 +84,7 @@ static inline __u8 cec_msg_initiator(const struct cec_msg *msg)
  * cec_msg_destination - return the destination's logical address.
  * @msg:	the message structure
  */
-static inline __u8 cec_msg_destination(const struct cec_msg *msg)
+static __inline__ __u8 cec_msg_destination(const struct cec_msg *msg)
 {
 	return msg->msg[0] & 0xf;
 }
@@ -93,7 +93,7 @@ static inline __u8 cec_msg_destination(const struct cec_msg *msg)
  * cec_msg_opcode - return the opcode of the message, -1 for poll
  * @msg:	the message structure
  */
-static inline int cec_msg_opcode(const struct cec_msg *msg)
+static __inline__ int cec_msg_opcode(const struct cec_msg *msg)
 {
 	return msg->len > 1 ? msg->msg[1] : -1;
 }
@@ -102,7 +102,7 @@ static inline int cec_msg_opcode(const struct cec_msg *msg)
  * cec_msg_is_broadcast - return true if this is a broadcast message.
  * @msg:	the message structure
  */
-static inline int cec_msg_is_broadcast(const struct cec_msg *msg)
+static __inline__ int cec_msg_is_broadcast(const struct cec_msg *msg)
 {
 	return (msg->msg[0] & 0xf) == 0xf;
 }
@@ -116,7 +116,7 @@ static inline int cec_msg_is_broadcast(const struct cec_msg *msg)
  * The whole structure is zeroed, the len field is set to 1 (i.e. a poll
  * message) and the initiator and destination are filled in.
  */
-static inline void cec_msg_init(struct cec_msg *msg,
+static __inline__ void cec_msg_init(struct cec_msg *msg,
 				__u8 initiator, __u8 destination)
 {
 	memset(msg, 0, sizeof(*msg));
@@ -133,7 +133,7 @@ static inline void cec_msg_init(struct cec_msg *msg,
  * orig destination. Note that msg and orig may be the same pointer, in which
  * case the change is done in place.
  */
-static inline void cec_msg_set_reply_to(struct cec_msg *msg,
+static __inline__ void cec_msg_set_reply_to(struct cec_msg *msg,
 					struct cec_msg *orig)
 {
 	/* The destination becomes the initiator and vice versa */
@@ -157,7 +157,7 @@ static inline void cec_msg_set_reply_to(struct cec_msg *msg,
 #define CEC_RX_STATUS_TIMEOUT		(1 << 1)
 #define CEC_RX_STATUS_FEATURE_ABORT	(1 << 2)
 
-static inline int cec_msg_status_is_ok(const struct cec_msg *msg)
+static __inline__ int cec_msg_status_is_ok(const struct cec_msg *msg)
 {
 	if (msg->tx_status && !(msg->tx_status & CEC_TX_STATUS_OK))
 		return 0;
@@ -227,47 +227,47 @@ static inline int cec_msg_status_is_ok(const struct cec_msg *msg)
 #define CEC_LOG_ADDR_MASK_SPECIFIC	(1 << CEC_LOG_ADDR_SPECIFIC)
 #define CEC_LOG_ADDR_MASK_UNREGISTERED	(1 << CEC_LOG_ADDR_UNREGISTERED)
 
-static inline int cec_has_tv(__u16 log_addr_mask)
+static __inline__ int cec_has_tv(__u16 log_addr_mask)
 {
 	return log_addr_mask & CEC_LOG_ADDR_MASK_TV;
 }
 
-static inline int cec_has_record(__u16 log_addr_mask)
+static __inline__ int cec_has_record(__u16 log_addr_mask)
 {
 	return log_addr_mask & CEC_LOG_ADDR_MASK_RECORD;
 }
 
-static inline int cec_has_tuner(__u16 log_addr_mask)
+static __inline__ int cec_has_tuner(__u16 log_addr_mask)
 {
 	return log_addr_mask & CEC_LOG_ADDR_MASK_TUNER;
 }
 
-static inline int cec_has_playback(__u16 log_addr_mask)
+static __inline__ int cec_has_playback(__u16 log_addr_mask)
 {
 	return log_addr_mask & CEC_LOG_ADDR_MASK_PLAYBACK;
 }
 
-static inline int cec_has_audiosystem(__u16 log_addr_mask)
+static __inline__ int cec_has_audiosystem(__u16 log_addr_mask)
 {
 	return log_addr_mask & CEC_LOG_ADDR_MASK_AUDIOSYSTEM;
 }
 
-static inline int cec_has_backup(__u16 log_addr_mask)
+static __inline__ int cec_has_backup(__u16 log_addr_mask)
 {
 	return log_addr_mask & CEC_LOG_ADDR_MASK_BACKUP;
 }
 
-static inline int cec_has_specific(__u16 log_addr_mask)
+static __inline__ int cec_has_specific(__u16 log_addr_mask)
 {
 	return log_addr_mask & CEC_LOG_ADDR_MASK_SPECIFIC;
 }
 
-static inline int cec_is_unregistered(__u16 log_addr_mask)
+static __inline__ int cec_is_unregistered(__u16 log_addr_mask)
 {
 	return log_addr_mask & CEC_LOG_ADDR_MASK_UNREGISTERED;
 }
 
-static inline int cec_is_unconfigured(__u16 log_addr_mask)
+static __inline__ int cec_is_unconfigured(__u16 log_addr_mask)
 {
 	return log_addr_mask == 0;
 }
@@ -999,7 +999,7 @@ struct cec_event {
 
 /* Helper functions to identify the 'special' CEC devices */
 
-static inline int cec_is_2nd_tv(const struct cec_log_addrs *las)
+static __inline__ int cec_is_2nd_tv(const struct cec_log_addrs *las)
 {
 	/*
 	 * It is a second TV if the logical address is 14 or 15 and the
@@ -1010,7 +1010,7 @@ static inline int cec_is_2nd_tv(const struct cec_log_addrs *las)
 	       las->primary_device_type[0] == CEC_OP_PRIM_DEVTYPE_TV;
 }
 
-static inline int cec_is_processor(const struct cec_log_addrs *las)
+static __inline__ int cec_is_processor(const struct cec_log_addrs *las)
 {
 	/*
 	 * It is a processor if the logical address is 12-15 and the
@@ -1021,7 +1021,7 @@ static inline int cec_is_processor(const struct cec_log_addrs *las)
 	       las->primary_device_type[0] == CEC_OP_PRIM_DEVTYPE_PROCESSOR;
 }
 
-static inline int cec_is_switch(const struct cec_log_addrs *las)
+static __inline__ int cec_is_switch(const struct cec_log_addrs *las)
 {
 	/*
 	 * It is a switch if the logical address is 15 and the
@@ -1033,7 +1033,7 @@ static inline int cec_is_switch(const struct cec_log_addrs *las)
 	       !(las->flags & CEC_LOG_ADDRS_FL_CDC_ONLY);
 }
 
-static inline int cec_is_cdc_only(const struct cec_log_addrs *las)
+static __inline__ int cec_is_cdc_only(const struct cec_log_addrs *las)
 {
 	/*
 	 * It is a CDC-only device if the logical address is 15 and the
diff --git a/include/linux/media.h b/include/linux/media.h
index 11dd72f..370e14f 100644
--- a/include/linux/media.h
+++ b/include/linux/media.h
@@ -323,11 +323,19 @@ struct media_v2_topology {
 
 /* ioctls */
 
+struct __attribute__ ((packed)) media_request_alloc {
+	__s32 fd;
+};
+
 #define MEDIA_IOC_DEVICE_INFO	_IOWR('|', 0x00, struct media_device_info)
 #define MEDIA_IOC_ENUM_ENTITIES	_IOWR('|', 0x01, struct media_entity_desc)
 #define MEDIA_IOC_ENUM_LINKS	_IOWR('|', 0x02, struct media_links_enum)
 #define MEDIA_IOC_SETUP_LINK	_IOWR('|', 0x03, struct media_link_desc)
 #define MEDIA_IOC_G_TOPOLOGY	_IOWR('|', 0x04, struct media_v2_topology)
+#define MEDIA_IOC_REQUEST_ALLOC	_IOWR('|', 0x05, struct media_request_alloc)
+
+#define MEDIA_REQUEST_IOC_QUEUE		_IO('|',  0x80)
+#define MEDIA_REQUEST_IOC_REINIT	_IO('|',  0x81)
 
 
 /*
diff --git a/include/linux/v4l2-dv-timings.h b/include/linux/v4l2-dv-timings.h
new file mode 100644
index 0000000..b52b67c
--- /dev/null
+++ b/include/linux/v4l2-dv-timings.h
@@ -0,0 +1,979 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * V4L2 DV timings header.
+ *
+ * Copyright (C) 2012-2016  Hans Verkuil <hans.verkuil@cisco.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef _V4L2_DV_TIMINGS_H
+#define _V4L2_DV_TIMINGS_H
+
+#if __GNUC__ < 4 || (__GNUC__ == 4 && (__GNUC_MINOR__ < 6))
+/* Sadly gcc versions older than 4.6 have a bug in how they initialize
+   anonymous unions where they require additional curly brackets.
+   This violates the C1x standard. This workaround adds the curly brackets
+   if needed. */
+#define V4L2_INIT_BT_TIMINGS(_width, args...) \
+	{ .bt = { _width , ## args } }
+#else
+#define V4L2_INIT_BT_TIMINGS(_width, args...) \
+	.bt = { _width , ## args }
+#endif
+
+/* CEA-861-F timings (i.e. standard HDTV timings) */
+
+#define V4L2_DV_BT_CEA_640X480P59_94 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(640, 480, 0, 0, \
+		25175000, 16, 96, 48, 10, 2, 33, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CEA861, \
+		V4L2_DV_FL_HAS_CEA861_VIC, { 0, 0 }, 1) \
+}
+
+/* Note: these are the nominal timings, for HDMI links this format is typically
+ * double-clocked to meet the minimum pixelclock requirements.  */
+#define V4L2_DV_BT_CEA_720X480I59_94 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(720, 480, 1, 0, \
+		13500000, 19, 62, 57, 4, 3, 15, 4, 3, 16, \
+		V4L2_DV_BT_STD_CEA861, \
+		V4L2_DV_FL_HALF_LINE | V4L2_DV_FL_IS_CE_VIDEO | \
+		V4L2_DV_FL_HAS_PICTURE_ASPECT | V4L2_DV_FL_HAS_CEA861_VIC, \
+		{ 4, 3 }, 6) \
+}
+
+#define V4L2_DV_BT_CEA_720X480P59_94 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(720, 480, 0, 0, \
+		27000000, 16, 62, 60, 9, 6, 30, 0, 0, 0, \
+		V4L2_DV_BT_STD_CEA861, \
+		V4L2_DV_FL_IS_CE_VIDEO | V4L2_DV_FL_HAS_PICTURE_ASPECT | \
+		V4L2_DV_FL_HAS_CEA861_VIC, { 4, 3 }, 2) \
+}
+
+/* Note: these are the nominal timings, for HDMI links this format is typically
+ * double-clocked to meet the minimum pixelclock requirements.  */
+#define V4L2_DV_BT_CEA_720X576I50 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(720, 576, 1, 0, \
+		13500000, 12, 63, 69, 2, 3, 19, 2, 3, 20, \
+		V4L2_DV_BT_STD_CEA861, \
+		V4L2_DV_FL_HALF_LINE | V4L2_DV_FL_IS_CE_VIDEO | \
+		V4L2_DV_FL_HAS_PICTURE_ASPECT | V4L2_DV_FL_HAS_CEA861_VIC, \
+		{ 4, 3 }, 21) \
+}
+
+#define V4L2_DV_BT_CEA_720X576P50 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(720, 576, 0, 0, \
+		27000000, 12, 64, 68, 5, 5, 39, 0, 0, 0, \
+		V4L2_DV_BT_STD_CEA861, \
+		V4L2_DV_FL_IS_CE_VIDEO | V4L2_DV_FL_HAS_PICTURE_ASPECT | \
+		V4L2_DV_FL_HAS_CEA861_VIC, { 4, 3 }, 17) \
+}
+
+#define V4L2_DV_BT_CEA_1280X720P24 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1280, 720, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
+		59400000, 1760, 40, 220, 5, 5, 20, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CEA861, \
+		V4L2_DV_FL_CAN_REDUCE_FPS | V4L2_DV_FL_HAS_CEA861_VIC, { 0, 0 }, 60) \
+}
+
+#define V4L2_DV_BT_CEA_1280X720P25 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1280, 720, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
+		74250000, 2420, 40, 220, 5, 5, 20, 0, 0, 0, \
+		V4L2_DV_BT_STD_CEA861, \
+		V4L2_DV_FL_IS_CE_VIDEO | V4L2_DV_FL_HAS_CEA861_VIC, { 0, 0 }, 61) \
+}
+
+#define V4L2_DV_BT_CEA_1280X720P30 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1280, 720, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
+		74250000, 1760, 40, 220, 5, 5, 20, 0, 0, 0, \
+		V4L2_DV_BT_STD_CEA861, \
+		V4L2_DV_FL_CAN_REDUCE_FPS | V4L2_DV_FL_IS_CE_VIDEO | \
+		V4L2_DV_FL_HAS_CEA861_VIC, { 0, 0 }, 62) \
+}
+
+#define V4L2_DV_BT_CEA_1280X720P50 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1280, 720, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
+		74250000, 440, 40, 220, 5, 5, 20, 0, 0, 0, \
+		V4L2_DV_BT_STD_CEA861, \
+		V4L2_DV_FL_IS_CE_VIDEO | V4L2_DV_FL_HAS_CEA861_VIC, { 0, 0 }, 19) \
+}
+
+#define V4L2_DV_BT_CEA_1280X720P60 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1280, 720, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
+		74250000, 110, 40, 220, 5, 5, 20, 0, 0, 0, \
+		V4L2_DV_BT_STD_CEA861, \
+		V4L2_DV_FL_CAN_REDUCE_FPS | V4L2_DV_FL_IS_CE_VIDEO | \
+		V4L2_DV_FL_HAS_CEA861_VIC, { 0, 0 }, 4) \
+}
+
+#define V4L2_DV_BT_CEA_1920X1080P24 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1920, 1080, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
+		74250000, 638, 44, 148, 4, 5, 36, 0, 0, 0, \
+		V4L2_DV_BT_STD_CEA861, \
+		V4L2_DV_FL_CAN_REDUCE_FPS | V4L2_DV_FL_IS_CE_VIDEO | \
+		V4L2_DV_FL_HAS_CEA861_VIC, { 0, 0 }, 32) \
+}
+
+#define V4L2_DV_BT_CEA_1920X1080P25 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1920, 1080, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
+		74250000, 528, 44, 148, 4, 5, 36, 0, 0, 0, \
+		V4L2_DV_BT_STD_CEA861, \
+		V4L2_DV_FL_IS_CE_VIDEO | V4L2_DV_FL_HAS_CEA861_VIC, { 0, 0 }, 33) \
+}
+
+#define V4L2_DV_BT_CEA_1920X1080P30 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1920, 1080, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
+		74250000, 88, 44, 148, 4, 5, 36, 0, 0, 0, \
+		V4L2_DV_BT_STD_CEA861, \
+		V4L2_DV_FL_CAN_REDUCE_FPS | V4L2_DV_FL_IS_CE_VIDEO | \
+		V4L2_DV_FL_HAS_CEA861_VIC, { 0, 0 }, 34) \
+}
+
+#define V4L2_DV_BT_CEA_1920X1080I50 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1920, 1080, 1, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
+		74250000, 528, 44, 148, 2, 5, 15, 2, 5, 16, \
+		V4L2_DV_BT_STD_CEA861, \
+		V4L2_DV_FL_HALF_LINE | V4L2_DV_FL_IS_CE_VIDEO | \
+		V4L2_DV_FL_HAS_CEA861_VIC, { 0, 0 }, 20) \
+}
+
+#define V4L2_DV_BT_CEA_1920X1080P50 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1920, 1080, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
+		148500000, 528, 44, 148, 4, 5, 36, 0, 0, 0, \
+		V4L2_DV_BT_STD_CEA861, \
+		V4L2_DV_FL_IS_CE_VIDEO | V4L2_DV_FL_HAS_CEA861_VIC, { 0, 0 }, 31) \
+}
+
+#define V4L2_DV_BT_CEA_1920X1080I60 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1920, 1080, 1, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
+		74250000, 88, 44, 148, 2, 5, 15, 2, 5, 16, \
+		V4L2_DV_BT_STD_CEA861, \
+		V4L2_DV_FL_CAN_REDUCE_FPS | \
+		V4L2_DV_FL_HALF_LINE | V4L2_DV_FL_IS_CE_VIDEO | \
+		V4L2_DV_FL_HAS_CEA861_VIC, { 0, 0 }, 5) \
+}
+
+#define V4L2_DV_BT_CEA_1920X1080P60 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1920, 1080, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
+		148500000, 88, 44, 148, 4, 5, 36, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CEA861, \
+		V4L2_DV_FL_CAN_REDUCE_FPS | V4L2_DV_FL_IS_CE_VIDEO | \
+		V4L2_DV_FL_HAS_CEA861_VIC, { 0, 0 }, 16) \
+}
+
+#define V4L2_DV_BT_CEA_3840X2160P24 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(3840, 2160, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
+		297000000, 1276, 88, 296, 8, 10, 72, 0, 0, 0, \
+		V4L2_DV_BT_STD_CEA861, \
+		V4L2_DV_FL_CAN_REDUCE_FPS | V4L2_DV_FL_IS_CE_VIDEO | \
+		V4L2_DV_FL_HAS_CEA861_VIC | V4L2_DV_FL_HAS_HDMI_VIC, \
+		{ 0, 0 }, 93, 3) \
+}
+
+#define V4L2_DV_BT_CEA_3840X2160P25 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(3840, 2160, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
+		297000000, 1056, 88, 296, 8, 10, 72, 0, 0, 0, \
+		V4L2_DV_BT_STD_CEA861, \
+		V4L2_DV_FL_IS_CE_VIDEO | V4L2_DV_FL_HAS_CEA861_VIC | \
+		V4L2_DV_FL_HAS_HDMI_VIC, { 0, 0 }, 94, 2) \
+}
+
+#define V4L2_DV_BT_CEA_3840X2160P30 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(3840, 2160, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
+		297000000, 176, 88, 296, 8, 10, 72, 0, 0, 0, \
+		V4L2_DV_BT_STD_CEA861, \
+		V4L2_DV_FL_CAN_REDUCE_FPS | V4L2_DV_FL_IS_CE_VIDEO | \
+		V4L2_DV_FL_HAS_CEA861_VIC | V4L2_DV_FL_HAS_HDMI_VIC, \
+		{ 0, 0 }, 95, 1) \
+}
+
+#define V4L2_DV_BT_CEA_3840X2160P50 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(3840, 2160, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
+		594000000, 1056, 88, 296, 8, 10, 72, 0, 0, 0, \
+		V4L2_DV_BT_STD_CEA861, \
+		V4L2_DV_FL_IS_CE_VIDEO | V4L2_DV_FL_HAS_CEA861_VIC, { 0, 0 }, 96) \
+}
+
+#define V4L2_DV_BT_CEA_3840X2160P60 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(3840, 2160, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
+		594000000, 176, 88, 296, 8, 10, 72, 0, 0, 0, \
+		V4L2_DV_BT_STD_CEA861, \
+		V4L2_DV_FL_CAN_REDUCE_FPS | V4L2_DV_FL_IS_CE_VIDEO | \
+		V4L2_DV_FL_HAS_CEA861_VIC, { 0, 0 }, 97) \
+}
+
+#define V4L2_DV_BT_CEA_4096X2160P24 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(4096, 2160, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
+		297000000, 1020, 88, 296, 8, 10, 72, 0, 0, 0, \
+		V4L2_DV_BT_STD_CEA861, \
+		V4L2_DV_FL_CAN_REDUCE_FPS | V4L2_DV_FL_IS_CE_VIDEO | \
+		V4L2_DV_FL_HAS_CEA861_VIC | V4L2_DV_FL_HAS_HDMI_VIC, \
+		{ 0, 0 }, 98, 4) \
+}
+
+#define V4L2_DV_BT_CEA_4096X2160P25 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(4096, 2160, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
+		297000000, 968, 88, 128, 8, 10, 72, 0, 0, 0, \
+		V4L2_DV_BT_STD_CEA861, \
+		V4L2_DV_FL_IS_CE_VIDEO | V4L2_DV_FL_HAS_CEA861_VIC, { 0, 0 }, 99) \
+}
+
+#define V4L2_DV_BT_CEA_4096X2160P30 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(4096, 2160, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
+		297000000, 88, 88, 128, 8, 10, 72, 0, 0, 0, \
+		V4L2_DV_BT_STD_CEA861, \
+		V4L2_DV_FL_CAN_REDUCE_FPS | V4L2_DV_FL_IS_CE_VIDEO | \
+		V4L2_DV_FL_HAS_CEA861_VIC, { 0, 0 }, 100) \
+}
+
+#define V4L2_DV_BT_CEA_4096X2160P50 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(4096, 2160, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
+		594000000, 968, 88, 128, 8, 10, 72, 0, 0, 0, \
+		V4L2_DV_BT_STD_CEA861, \
+		V4L2_DV_FL_IS_CE_VIDEO | V4L2_DV_FL_HAS_CEA861_VIC, { 0, 0 }, 101) \
+}
+
+#define V4L2_DV_BT_CEA_4096X2160P60 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(4096, 2160, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
+		594000000, 88, 88, 128, 8, 10, 72, 0, 0, 0, \
+		V4L2_DV_BT_STD_CEA861, \
+		V4L2_DV_FL_CAN_REDUCE_FPS | V4L2_DV_FL_IS_CE_VIDEO | \
+		V4L2_DV_FL_HAS_CEA861_VIC, { 0, 0 }, 102) \
+}
+
+
+/* VESA Discrete Monitor Timings as per version 1.0, revision 12 */
+
+#define V4L2_DV_BT_DMT_640X350P85 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(640, 350, 0, V4L2_DV_HSYNC_POS_POL, \
+		31500000, 32, 64, 96, 32, 3, 60, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT, 0) \
+}
+
+#define V4L2_DV_BT_DMT_640X400P85 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(640, 400, 0, V4L2_DV_VSYNC_POS_POL, \
+		31500000, 32, 64, 96, 1, 3, 41, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT, 0) \
+}
+
+#define V4L2_DV_BT_DMT_720X400P85 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(720, 400, 0, V4L2_DV_VSYNC_POS_POL, \
+		35500000, 36, 72, 108, 1, 3, 42, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT, 0) \
+}
+
+/* VGA resolutions */
+#define V4L2_DV_BT_DMT_640X480P60 V4L2_DV_BT_CEA_640X480P59_94
+
+#define V4L2_DV_BT_DMT_640X480P72 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(640, 480, 0, 0, \
+		31500000, 24, 40, 128, 9, 3, 28, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT, 0) \
+}
+
+#define V4L2_DV_BT_DMT_640X480P75 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(640, 480, 0, 0, \
+		31500000, 16, 64, 120, 1, 3, 16, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT, 0) \
+}
+
+#define V4L2_DV_BT_DMT_640X480P85 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(640, 480, 0, 0, \
+		36000000, 56, 56, 80, 1, 3, 25, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT, 0) \
+}
+
+/* SVGA resolutions */
+#define V4L2_DV_BT_DMT_800X600P56 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(800, 600, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
+		36000000, 24, 72, 128, 1, 2, 22, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT, 0) \
+}
+
+#define V4L2_DV_BT_DMT_800X600P60 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(800, 600, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
+		40000000, 40, 128, 88, 1, 4, 23, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT, 0) \
+}
+
+#define V4L2_DV_BT_DMT_800X600P72 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(800, 600, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
+		50000000, 56, 120, 64, 37, 6, 23, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT, 0) \
+}
+
+#define V4L2_DV_BT_DMT_800X600P75 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(800, 600, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
+		49500000, 16, 80, 160, 1, 3, 21, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT, 0) \
+}
+
+#define V4L2_DV_BT_DMT_800X600P85 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(800, 600, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
+		56250000, 32, 64, 152, 1, 3, 27, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT, 0) \
+}
+
+#define V4L2_DV_BT_DMT_800X600P120_RB { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(800, 600, 0, V4L2_DV_HSYNC_POS_POL, \
+		73250000, 48, 32, 80, 3, 4, 29, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CVT, \
+		V4L2_DV_FL_REDUCED_BLANKING) \
+}
+
+#define V4L2_DV_BT_DMT_848X480P60 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(848, 480, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
+		33750000, 16, 112, 112, 6, 8, 23, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT, 0) \
+}
+
+#define V4L2_DV_BT_DMT_1024X768I43 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1024, 768, 1, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
+		44900000, 8, 176, 56, 0, 4, 20, 0, 4, 21, \
+		V4L2_DV_BT_STD_DMT, 0) \
+}
+
+/* XGA resolutions */
+#define V4L2_DV_BT_DMT_1024X768P60 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1024, 768, 0, 0, \
+		65000000, 24, 136, 160, 3, 6, 29, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT, 0) \
+}
+
+#define V4L2_DV_BT_DMT_1024X768P70 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1024, 768, 0, 0, \
+		75000000, 24, 136, 144, 3, 6, 29, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT, 0) \
+}
+
+#define V4L2_DV_BT_DMT_1024X768P75 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1024, 768, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
+		78750000, 16, 96, 176, 1, 3, 28, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT, 0) \
+}
+
+#define V4L2_DV_BT_DMT_1024X768P85 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1024, 768, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
+		94500000, 48, 96, 208, 1, 3, 36, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT, 0) \
+}
+
+#define V4L2_DV_BT_DMT_1024X768P120_RB { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1024, 768, 0, V4L2_DV_HSYNC_POS_POL, \
+		115500000, 48, 32, 80, 3, 4, 38, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CVT, \
+		V4L2_DV_FL_REDUCED_BLANKING) \
+}
+
+/* XGA+ resolution */
+#define V4L2_DV_BT_DMT_1152X864P75 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1152, 864, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
+		108000000, 64, 128, 256, 1, 3, 32, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT, 0) \
+}
+
+#define V4L2_DV_BT_DMT_1280X720P60 V4L2_DV_BT_CEA_1280X720P60
+
+/* WXGA resolutions */
+#define V4L2_DV_BT_DMT_1280X768P60_RB { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1280, 768, 0, V4L2_DV_HSYNC_POS_POL, \
+		68250000, 48, 32, 80, 3, 7, 12, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CVT, \
+		V4L2_DV_FL_REDUCED_BLANKING) \
+}
+
+#define V4L2_DV_BT_DMT_1280X768P60 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1280, 768, 0, V4L2_DV_VSYNC_POS_POL, \
+		79500000, 64, 128, 192, 3, 7, 20, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CVT, 0) \
+}
+
+#define V4L2_DV_BT_DMT_1280X768P75 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1280, 768, 0, V4L2_DV_VSYNC_POS_POL, \
+		102250000, 80, 128, 208, 3, 7, 27, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CVT, 0) \
+}
+
+#define V4L2_DV_BT_DMT_1280X768P85 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1280, 768, 0, V4L2_DV_VSYNC_POS_POL, \
+		117500000, 80, 136, 216, 3, 7, 31, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CVT, 0) \
+}
+
+#define V4L2_DV_BT_DMT_1280X768P120_RB { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1280, 768, 0, V4L2_DV_HSYNC_POS_POL, \
+		140250000, 48, 32, 80, 3, 7, 35, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CVT, \
+		V4L2_DV_FL_REDUCED_BLANKING) \
+}
+
+#define V4L2_DV_BT_DMT_1280X800P60_RB { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1280, 800, 0, V4L2_DV_HSYNC_POS_POL, \
+		71000000, 48, 32, 80, 3, 6, 14, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CVT, \
+		V4L2_DV_FL_REDUCED_BLANKING) \
+}
+
+#define V4L2_DV_BT_DMT_1280X800P60 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1280, 800, 0, V4L2_DV_VSYNC_POS_POL, \
+		83500000, 72, 128, 200, 3, 6, 22, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CVT, 0) \
+}
+
+#define V4L2_DV_BT_DMT_1280X800P75 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1280, 800, 0, V4L2_DV_VSYNC_POS_POL, \
+		106500000, 80, 128, 208, 3, 6, 29, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CVT, 0) \
+}
+
+#define V4L2_DV_BT_DMT_1280X800P85 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1280, 800, 0, V4L2_DV_VSYNC_POS_POL, \
+		122500000, 80, 136, 216, 3, 6, 34, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CVT, 0) \
+}
+
+#define V4L2_DV_BT_DMT_1280X800P120_RB { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1280, 800, 0, V4L2_DV_HSYNC_POS_POL, \
+		146250000, 48, 32, 80, 3, 6, 38, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CVT, \
+		V4L2_DV_FL_REDUCED_BLANKING) \
+}
+
+#define V4L2_DV_BT_DMT_1280X960P60 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1280, 960, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
+		108000000, 96, 112, 312, 1, 3, 36, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT, 0) \
+}
+
+#define V4L2_DV_BT_DMT_1280X960P85 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1280, 960, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
+		148500000, 64, 160, 224, 1, 3, 47, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT, 0) \
+}
+
+#define V4L2_DV_BT_DMT_1280X960P120_RB { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1280, 960, 0, V4L2_DV_HSYNC_POS_POL, \
+		175500000, 48, 32, 80, 3, 4, 50, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CVT, \
+		V4L2_DV_FL_REDUCED_BLANKING) \
+}
+
+/* SXGA resolutions */
+#define V4L2_DV_BT_DMT_1280X1024P60 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1280, 1024, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
+		108000000, 48, 112, 248, 1, 3, 38, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT, 0) \
+}
+
+#define V4L2_DV_BT_DMT_1280X1024P75 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1280, 1024, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
+		135000000, 16, 144, 248, 1, 3, 38, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT, 0) \
+}
+
+#define V4L2_DV_BT_DMT_1280X1024P85 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1280, 1024, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
+		157500000, 64, 160, 224, 1, 3, 44, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT, 0) \
+}
+
+#define V4L2_DV_BT_DMT_1280X1024P120_RB { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1280, 1024, 0, V4L2_DV_HSYNC_POS_POL, \
+		187250000, 48, 32, 80, 3, 7, 50, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CVT, \
+		V4L2_DV_FL_REDUCED_BLANKING) \
+}
+
+#define V4L2_DV_BT_DMT_1360X768P60 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1360, 768, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
+		85500000, 64, 112, 256, 3, 6, 18, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT, 0) \
+}
+
+#define V4L2_DV_BT_DMT_1360X768P120_RB { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1360, 768, 0, V4L2_DV_HSYNC_POS_POL, \
+		148250000, 48, 32, 80, 3, 5, 37, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CVT, \
+		V4L2_DV_FL_REDUCED_BLANKING) \
+}
+
+#define V4L2_DV_BT_DMT_1366X768P60 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1366, 768, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
+		85500000, 70, 143, 213, 3, 3, 24, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT, 0) \
+}
+
+#define V4L2_DV_BT_DMT_1366X768P60_RB { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1366, 768, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
+		72000000, 14, 56, 64, 1, 3, 28, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT, V4L2_DV_FL_REDUCED_BLANKING) \
+}
+
+/* SXGA+ resolutions */
+#define V4L2_DV_BT_DMT_1400X1050P60_RB { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1400, 1050, 0, V4L2_DV_HSYNC_POS_POL, \
+		101000000, 48, 32, 80, 3, 4, 23, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CVT, \
+		V4L2_DV_FL_REDUCED_BLANKING) \
+}
+
+#define V4L2_DV_BT_DMT_1400X1050P60 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1400, 1050, 0, V4L2_DV_VSYNC_POS_POL, \
+		121750000, 88, 144, 232, 3, 4, 32, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CVT, 0) \
+}
+
+#define V4L2_DV_BT_DMT_1400X1050P75 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1400, 1050, 0, V4L2_DV_VSYNC_POS_POL, \
+		156000000, 104, 144, 248, 3, 4, 42, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CVT, 0) \
+}
+
+#define V4L2_DV_BT_DMT_1400X1050P85 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1400, 1050, 0, V4L2_DV_VSYNC_POS_POL, \
+		179500000, 104, 152, 256, 3, 4, 48, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CVT, 0) \
+}
+
+#define V4L2_DV_BT_DMT_1400X1050P120_RB { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1400, 1050, 0, V4L2_DV_HSYNC_POS_POL, \
+		208000000, 48, 32, 80, 3, 4, 55, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CVT, \
+		V4L2_DV_FL_REDUCED_BLANKING) \
+}
+
+/* WXGA+ resolutions */
+#define V4L2_DV_BT_DMT_1440X900P60_RB { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1440, 900, 0, V4L2_DV_HSYNC_POS_POL, \
+		88750000, 48, 32, 80, 3, 6, 17, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CVT, \
+		V4L2_DV_FL_REDUCED_BLANKING) \
+}
+
+#define V4L2_DV_BT_DMT_1440X900P60 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1440, 900, 0, V4L2_DV_VSYNC_POS_POL, \
+		106500000, 80, 152, 232, 3, 6, 25, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CVT, 0) \
+}
+
+#define V4L2_DV_BT_DMT_1440X900P75 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1440, 900, 0, V4L2_DV_VSYNC_POS_POL, \
+		136750000, 96, 152, 248, 3, 6, 33, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CVT, 0) \
+}
+
+#define V4L2_DV_BT_DMT_1440X900P85 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1440, 900, 0, V4L2_DV_VSYNC_POS_POL, \
+		157000000, 104, 152, 256, 3, 6, 39, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CVT, 0) \
+}
+
+#define V4L2_DV_BT_DMT_1440X900P120_RB { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1440, 900, 0, V4L2_DV_HSYNC_POS_POL, \
+		182750000, 48, 32, 80, 3, 6, 44, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CVT, \
+		V4L2_DV_FL_REDUCED_BLANKING) \
+}
+
+#define V4L2_DV_BT_DMT_1600X900P60_RB { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1600, 900, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
+		108000000, 24, 80, 96, 1, 3, 96, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT, V4L2_DV_FL_REDUCED_BLANKING) \
+}
+
+/* UXGA resolutions */
+#define V4L2_DV_BT_DMT_1600X1200P60 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1600, 1200, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
+		162000000, 64, 192, 304, 1, 3, 46, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT, 0) \
+}
+
+#define V4L2_DV_BT_DMT_1600X1200P65 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1600, 1200, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
+		175500000, 64, 192, 304, 1, 3, 46, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT, 0) \
+}
+
+#define V4L2_DV_BT_DMT_1600X1200P70 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1600, 1200, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
+		189000000, 64, 192, 304, 1, 3, 46, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT, 0) \
+}
+
+#define V4L2_DV_BT_DMT_1600X1200P75 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1600, 1200, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
+		202500000, 64, 192, 304, 1, 3, 46, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT, 0) \
+}
+
+#define V4L2_DV_BT_DMT_1600X1200P85 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1600, 1200, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
+		229500000, 64, 192, 304, 1, 3, 46, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT, 0) \
+}
+
+#define V4L2_DV_BT_DMT_1600X1200P120_RB { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1600, 1200, 0, V4L2_DV_HSYNC_POS_POL, \
+		268250000, 48, 32, 80, 3, 4, 64, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CVT, \
+		V4L2_DV_FL_REDUCED_BLANKING) \
+}
+
+/* WSXGA+ resolutions */
+#define V4L2_DV_BT_DMT_1680X1050P60_RB { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1680, 1050, 0, V4L2_DV_HSYNC_POS_POL, \
+		119000000, 48, 32, 80, 3, 6, 21, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CVT, \
+		V4L2_DV_FL_REDUCED_BLANKING) \
+}
+
+#define V4L2_DV_BT_DMT_1680X1050P60 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1680, 1050, 0, V4L2_DV_VSYNC_POS_POL, \
+		146250000, 104, 176, 280, 3, 6, 30, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CVT, 0) \
+}
+
+#define V4L2_DV_BT_DMT_1680X1050P75 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1680, 1050, 0, V4L2_DV_VSYNC_POS_POL, \
+		187000000, 120, 176, 296, 3, 6, 40, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CVT, 0) \
+}
+
+#define V4L2_DV_BT_DMT_1680X1050P85 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1680, 1050, 0, V4L2_DV_VSYNC_POS_POL, \
+		214750000, 128, 176, 304, 3, 6, 46, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CVT, 0) \
+}
+
+#define V4L2_DV_BT_DMT_1680X1050P120_RB { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1680, 1050, 0, V4L2_DV_HSYNC_POS_POL, \
+		245500000, 48, 32, 80, 3, 6, 53, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CVT, \
+		V4L2_DV_FL_REDUCED_BLANKING) \
+}
+
+#define V4L2_DV_BT_DMT_1792X1344P60 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1792, 1344, 0, V4L2_DV_VSYNC_POS_POL, \
+		204750000, 128, 200, 328, 1, 3, 46, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT, 0) \
+}
+
+#define V4L2_DV_BT_DMT_1792X1344P75 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1792, 1344, 0, V4L2_DV_VSYNC_POS_POL, \
+		261000000, 96, 216, 352, 1, 3, 69, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT, 0) \
+}
+
+#define V4L2_DV_BT_DMT_1792X1344P120_RB { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1792, 1344, 0, V4L2_DV_HSYNC_POS_POL, \
+		333250000, 48, 32, 80, 3, 4, 72, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CVT, \
+		V4L2_DV_FL_REDUCED_BLANKING) \
+}
+
+#define V4L2_DV_BT_DMT_1856X1392P60 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1856, 1392, 0, V4L2_DV_VSYNC_POS_POL, \
+		218250000, 96, 224, 352, 1, 3, 43, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT, 0) \
+}
+
+#define V4L2_DV_BT_DMT_1856X1392P75 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1856, 1392, 0, V4L2_DV_VSYNC_POS_POL, \
+		288000000, 128, 224, 352, 1, 3, 104, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT, 0) \
+}
+
+#define V4L2_DV_BT_DMT_1856X1392P120_RB { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1856, 1392, 0, V4L2_DV_HSYNC_POS_POL, \
+		356500000, 48, 32, 80, 3, 4, 75, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CVT, \
+		V4L2_DV_FL_REDUCED_BLANKING) \
+}
+
+#define V4L2_DV_BT_DMT_1920X1080P60 V4L2_DV_BT_CEA_1920X1080P60
+
+/* WUXGA resolutions */
+#define V4L2_DV_BT_DMT_1920X1200P60_RB { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1920, 1200, 0, V4L2_DV_HSYNC_POS_POL, \
+		154000000, 48, 32, 80, 3, 6, 26, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CVT, \
+		V4L2_DV_FL_REDUCED_BLANKING) \
+}
+
+#define V4L2_DV_BT_DMT_1920X1200P60 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1920, 1200, 0, V4L2_DV_VSYNC_POS_POL, \
+		193250000, 136, 200, 336, 3, 6, 36, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CVT, 0) \
+}
+
+#define V4L2_DV_BT_DMT_1920X1200P75 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1920, 1200, 0, V4L2_DV_VSYNC_POS_POL, \
+		245250000, 136, 208, 344, 3, 6, 46, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CVT, 0) \
+}
+
+#define V4L2_DV_BT_DMT_1920X1200P85 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1920, 1200, 0, V4L2_DV_VSYNC_POS_POL, \
+		281250000, 144, 208, 352, 3, 6, 53, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CVT, 0) \
+}
+
+#define V4L2_DV_BT_DMT_1920X1200P120_RB { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1920, 1200, 0, V4L2_DV_HSYNC_POS_POL, \
+		317000000, 48, 32, 80, 3, 6, 62, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CVT, \
+		V4L2_DV_FL_REDUCED_BLANKING) \
+}
+
+#define V4L2_DV_BT_DMT_1920X1440P60 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1920, 1440, 0, V4L2_DV_VSYNC_POS_POL, \
+		234000000, 128, 208, 344, 1, 3, 56, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT, 0) \
+}
+
+#define V4L2_DV_BT_DMT_1920X1440P75 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1920, 1440, 0, V4L2_DV_VSYNC_POS_POL, \
+		297000000, 144, 224, 352, 1, 3, 56, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT, 0) \
+}
+
+#define V4L2_DV_BT_DMT_1920X1440P120_RB { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(1920, 1440, 0, V4L2_DV_HSYNC_POS_POL, \
+		380500000, 48, 32, 80, 3, 4, 78, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CVT, \
+		V4L2_DV_FL_REDUCED_BLANKING) \
+}
+
+#define V4L2_DV_BT_DMT_2048X1152P60_RB { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(2048, 1152, 0, \
+		V4L2_DV_HSYNC_POS_POL | V4L2_DV_VSYNC_POS_POL, \
+		162000000, 26, 80, 96, 1, 3, 44, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT, V4L2_DV_FL_REDUCED_BLANKING) \
+}
+
+/* WQXGA resolutions */
+#define V4L2_DV_BT_DMT_2560X1600P60_RB { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(2560, 1600, 0, V4L2_DV_HSYNC_POS_POL, \
+		268500000, 48, 32, 80, 3, 6, 37, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CVT, \
+		V4L2_DV_FL_REDUCED_BLANKING) \
+}
+
+#define V4L2_DV_BT_DMT_2560X1600P60 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(2560, 1600, 0, V4L2_DV_VSYNC_POS_POL, \
+		348500000, 192, 280, 472, 3, 6, 49, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CVT, 0) \
+}
+
+#define V4L2_DV_BT_DMT_2560X1600P75 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(2560, 1600, 0, V4L2_DV_VSYNC_POS_POL, \
+		443250000, 208, 280, 488, 3, 6, 63, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CVT, 0) \
+}
+
+#define V4L2_DV_BT_DMT_2560X1600P85 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(2560, 1600, 0, V4L2_DV_VSYNC_POS_POL, \
+		505250000, 208, 280, 488, 3, 6, 73, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CVT, 0) \
+}
+
+#define V4L2_DV_BT_DMT_2560X1600P120_RB { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(2560, 1600, 0, V4L2_DV_HSYNC_POS_POL, \
+		552750000, 48, 32, 80, 3, 6, 85, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CVT, \
+		V4L2_DV_FL_REDUCED_BLANKING) \
+}
+
+/* 4K resolutions */
+#define V4L2_DV_BT_DMT_4096X2160P60_RB { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(4096, 2160, 0, V4L2_DV_HSYNC_POS_POL, \
+		556744000, 8, 32, 40, 48, 8, 6, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CVT, \
+		V4L2_DV_FL_REDUCED_BLANKING) \
+}
+
+#define V4L2_DV_BT_DMT_4096X2160P59_94_RB { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(4096, 2160, 0, V4L2_DV_HSYNC_POS_POL, \
+		556188000, 8, 32, 40, 48, 8, 6, 0, 0, 0, \
+		V4L2_DV_BT_STD_DMT | V4L2_DV_BT_STD_CVT, \
+		V4L2_DV_FL_REDUCED_BLANKING) \
+}
+
+/* SDI timings definitions */
+
+/* SMPTE-125M */
+#define V4L2_DV_BT_SDI_720X487I60 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(720, 487, 1, \
+		V4L2_DV_HSYNC_POS_POL, \
+		13500000, 16, 121, 0, 0, 19, 0, 0, 19, 0, \
+		V4L2_DV_BT_STD_SDI, \
+		V4L2_DV_FL_FIRST_FIELD_EXTRA_LINE) \
+}
+
+#endif
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index a9e07d7..a15c1a6 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -906,6 +906,7 @@ struct v4l2_plane {
  * @length:	size in bytes of the buffer (NOT its payload) for single-plane
  *		buffers (when type != *_MPLANE); number of elements in the
  *		planes array for multi-plane buffers
+ * @request_fd: fd of the request that this buffer should use
  *
  * Contains data exchanged by application and driver using one of the Streaming
  * I/O methods.
@@ -930,7 +931,10 @@ struct v4l2_buffer {
 	} m;
 	__u32			length;
 	__u32			reserved2;
-	__u32			reserved;
+	union {
+		__s32		request_fd;
+		__u32		reserved;
+	};
 };
 
 /*  Flags for 'flags' field */
@@ -948,6 +952,8 @@ struct v4l2_buffer {
 #define V4L2_BUF_FLAG_BFRAME			0x00000020
 /* Buffer is ready, but the data contained within is corrupted. */
 #define V4L2_BUF_FLAG_ERROR			0x00000040
+/* Buffer is added to an unqueued request */
+#define V4L2_BUF_FLAG_IN_REQUEST		0x00000080
 /* timecode field is valid */
 #define V4L2_BUF_FLAG_TIMECODE			0x00000100
 /* Buffer is prepared for queuing */
@@ -966,6 +972,8 @@ struct v4l2_buffer {
 #define V4L2_BUF_FLAG_TSTAMP_SRC_SOE		0x00010000
 /* mem2mem encoder/decoder */
 #define V4L2_BUF_FLAG_LAST			0x00100000
+/* request_fd is valid */
+#define V4L2_BUF_FLAG_REQUEST_FD		0x00800000
 
 /**
  * struct v4l2_exportbuffer - export of video buffer as DMABUF file descriptor
@@ -1586,7 +1594,8 @@ struct v4l2_ext_controls {
 	};
 	__u32 count;
 	__u32 error_idx;
-	__u32 reserved[2];
+	__s32 request_fd;
+	__u32 reserved[1];
 	struct v4l2_ext_control *controls;
 };
 
@@ -1597,6 +1606,7 @@ struct v4l2_ext_controls {
 #define V4L2_CTRL_MAX_DIMS	  (4)
 #define V4L2_CTRL_WHICH_CUR_VAL   0
 #define V4L2_CTRL_WHICH_DEF_VAL   0x0f000000
+#define V4L2_CTRL_WHICH_REQUEST   0x0f010000
 
 enum v4l2_ctrl_type {
 	V4L2_CTRL_TYPE_INTEGER	     = 1,
-- 
2.7.4
