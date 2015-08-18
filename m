Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:50624 "EHLO
	aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbbHRIjT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Aug 2015 04:39:19 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, m.szyprowski@samsung.com,
	linux-input@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	lars@opdenkamp.eu, kamil@wypas.org, linux@arm.linux.org.uk,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 2/4] sync-with-kernel
Date: Tue, 18 Aug 2015 10:36:36 +0200
Message-Id: <5c0d31e2b38822caf07b344c3f3c87dc1d2d8a22.1439886496.git.hans.verkuil@cisco.com>
In-Reply-To: <cover.1439886496.git.hans.verkuil@cisco.com>
References: <cover.1439886496.git.hans.verkuil@cisco.com>
In-Reply-To: <cover.1439886496.git.hans.verkuil@cisco.com>
References: <cover.1439886496.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 contrib/freebsd/include/linux/input.h         |   29 +
 contrib/freebsd/include/linux/v4l2-controls.h |    4 +
 include/linux/cec-funcs.h                     | 1771 +++++++++++++++++++++++++
 include/linux/cec.h                           |  781 +++++++++++
 include/linux/v4l2-controls.h                 |    4 +
 utils/keytable/parse.h                        |   18 +
 utils/keytable/rc_keymaps/lme2510             |  132 +-
 utils/keytable/rc_maps.cfg                    |    1 +
 8 files changed, 2674 insertions(+), 66 deletions(-)
 create mode 100644 include/linux/cec-funcs.h
 create mode 100644 include/linux/cec.h

diff --git a/contrib/freebsd/include/linux/input.h b/contrib/freebsd/include/linux/input.h
index 19345e1..1bc7241 100644
--- a/contrib/freebsd/include/linux/input.h
+++ b/contrib/freebsd/include/linux/input.h
@@ -786,6 +786,34 @@ struct input_keymap_entry {
 #define KEY_KBDINPUTASSIST_ACCEPT		0x264
 #define KEY_KBDINPUTASSIST_CANCEL		0x265
 
+#define KEY_RIGHT_UP			0x266
+#define KEY_RIGHT_DOWN			0x267
+#define KEY_LEFT_UP			0x268
+#define KEY_LEFT_DOWN			0x269
+#define KEY_ROOT_MENU			0x26a /* Show Device's Root Menu */
+#define KEY_MEDIA_TOP_MENU		0x26b /* Show Top Menu of the Media (e.g. DVD) */
+#define KEY_NUMERIC_11			0x26c
+#define KEY_NUMERIC_12			0x26d
+/*
+ * Toggle Audio Description: refers to an audio service that helps blind and
+ * visually impaired consumers understand the action in a program. Note: in
+ * some countries this is referred to as "Video Description".
+ */
+#define KEY_AUDIO_DESC			0x26e
+#define KEY_3D_MODE			0x26f
+#define KEY_NEXT_FAVORITE		0x270
+#define KEY_STOP_RECORD			0x271
+#define KEY_PAUSE_RECORD		0x272
+#define KEY_VOD				0x273 /* Video on Demand */
+#define KEY_UNMUTE			0x274
+#define KEY_FASTREVERSE			0x275
+#define KEY_SLOWREVERSE			0x276
+/*
+ * Control a data application associated with the currently viewed channel,
+ * e.g. teletext or data broadcast application (MHEG, MHP, HbbTV, etc.)
+ */
+#define KEY_DATA			0x275
+
 #define BTN_TRIGGER_HAPPY		0x2c0
 #define BTN_TRIGGER_HAPPY1		0x2c0
 #define BTN_TRIGGER_HAPPY2		0x2c1
@@ -1006,6 +1034,7 @@ struct input_keymap_entry {
 #define BUS_GSC			0x1A
 #define BUS_ATARI		0x1B
 #define BUS_SPI			0x1C
+#define BUS_CEC			0x1D
 
 /*
  * MT_TOOL types
diff --git a/contrib/freebsd/include/linux/v4l2-controls.h b/contrib/freebsd/include/linux/v4l2-controls.h
index 9f6e108..d448c53 100644
--- a/contrib/freebsd/include/linux/v4l2-controls.h
+++ b/contrib/freebsd/include/linux/v4l2-controls.h
@@ -174,6 +174,10 @@ enum v4l2_colorfx {
  * We reserve 16 controls for this driver. */
 #define V4L2_CID_USER_ADV7180_BASE		(V4L2_CID_USER_BASE + 0x1070)
 
+/* The base for the tc358743 driver controls.
+ * We reserve 16 controls for this driver. */
+#define V4L2_CID_USER_TC358743_BASE		(V4L2_CID_USER_BASE + 0x1080)
+
 /* MPEG-class control IDs */
 /* The MPEG controls are applicable to all codec controls
  * and the 'MPEG' part of the define is historical */
diff --git a/include/linux/cec-funcs.h b/include/linux/cec-funcs.h
new file mode 100644
index 0000000..45fb7bd
--- /dev/null
+++ b/include/linux/cec-funcs.h
@@ -0,0 +1,1771 @@
+#ifndef _CEC_FUNCS_H
+#define _CEC_FUNCS_H
+
+#include <linux/cec.h>
+
+/* One Touch Play Feature */
+static __inline__ void cec_msg_active_source(struct cec_msg *msg, __u16 phys_addr)
+{
+	msg->len = 4;
+	msg->msg[0] |= 0xf; /* broadcast */
+	msg->msg[1] = CEC_MSG_ACTIVE_SOURCE;
+	msg->msg[2] = phys_addr >> 8;
+	msg->msg[3] = phys_addr & 0xff;
+}
+
+static __inline__ void cec_ops_active_source(const struct cec_msg *msg,
+					 __u16 *phys_addr)
+{
+	*phys_addr = (msg->msg[2] << 8) | msg->msg[3];
+}
+
+static __inline__ void cec_msg_image_view_on(struct cec_msg *msg)
+{
+	msg->len = 2;
+	msg->msg[1] = CEC_MSG_IMAGE_VIEW_ON;
+}
+
+static __inline__ void cec_msg_text_view_on(struct cec_msg *msg)
+{
+	msg->len = 2;
+	msg->msg[1] = CEC_MSG_TEXT_VIEW_ON;
+}
+
+
+/* Routing Control Feature */
+static __inline__ void cec_msg_inactive_source(struct cec_msg *msg,
+					   __u16 phys_addr)
+{
+	msg->len = 4;
+	msg->msg[1] = CEC_MSG_INACTIVE_SOURCE;
+	msg->msg[2] = phys_addr >> 8;
+	msg->msg[3] = phys_addr & 0xff;
+}
+
+static __inline__ void cec_ops_inactive_source(const struct cec_msg *msg,
+					   __u16 *phys_addr)
+{
+	*phys_addr = (msg->msg[2] << 8) | msg->msg[3];
+}
+
+static __inline__ void cec_msg_request_active_source(struct cec_msg *msg,
+						 bool reply)
+{
+	msg->len = 2;
+	msg->msg[0] |= 0xf; /* broadcast */
+	msg->msg[1] = CEC_MSG_REQUEST_ACTIVE_SOURCE;
+	msg->reply = reply ? CEC_MSG_ACTIVE_SOURCE : 0;
+}
+
+static __inline__ void cec_msg_routing_information(struct cec_msg *msg,
+					       __u16 phys_addr)
+{
+	msg->len = 4;
+	msg->msg[0] |= 0xf; /* broadcast */
+	msg->msg[1] = CEC_MSG_ROUTING_INFORMATION;
+	msg->msg[2] = phys_addr >> 8;
+	msg->msg[3] = phys_addr & 0xff;
+}
+
+static __inline__ void cec_ops_routing_information(const struct cec_msg *msg,
+					       __u16 *phys_addr)
+{
+	*phys_addr = (msg->msg[2] << 8) | msg->msg[3];
+}
+
+static __inline__ void cec_msg_routing_change(struct cec_msg *msg,
+					  bool reply,
+					  __u16 orig_phys_addr,
+					  __u16 new_phys_addr)
+{
+	msg->len = 6;
+	msg->msg[0] |= 0xf; /* broadcast */
+	msg->msg[1] = CEC_MSG_ROUTING_CHANGE;
+	msg->msg[2] = orig_phys_addr >> 8;
+	msg->msg[3] = orig_phys_addr & 0xff;
+	msg->msg[4] = new_phys_addr >> 8;
+	msg->msg[5] = new_phys_addr & 0xff;
+	msg->reply = reply ? CEC_MSG_ROUTING_INFORMATION : 0;
+}
+
+static __inline__ void cec_ops_routing_change(const struct cec_msg *msg,
+					  __u16 *orig_phys_addr,
+					  __u16 *new_phys_addr)
+{
+	*orig_phys_addr = (msg->msg[2] << 8) | msg->msg[3];
+	*new_phys_addr = (msg->msg[4] << 8) | msg->msg[5];
+}
+
+static __inline__ void cec_msg_set_stream_path(struct cec_msg *msg, __u16 phys_addr)
+{
+	msg->len = 4;
+	msg->msg[0] |= 0xf; /* broadcast */
+	msg->msg[1] = CEC_MSG_SET_STREAM_PATH;
+	msg->msg[2] = phys_addr >> 8;
+	msg->msg[3] = phys_addr & 0xff;
+}
+
+static __inline__ void cec_ops_set_stream_path(const struct cec_msg *msg,
+					   __u16 *phys_addr)
+{
+	*phys_addr = (msg->msg[2] << 8) | msg->msg[3];
+}
+
+
+/* Standby Feature */
+static __inline__ void cec_msg_standby(struct cec_msg *msg)
+{
+	msg->len = 2;
+	msg->msg[1] = CEC_MSG_STANDBY;
+}
+
+
+/* One Touch Record Feature */
+static __inline__ void cec_msg_record_off(struct cec_msg *msg)
+{
+	msg->len = 2;
+	msg->msg[1] = CEC_MSG_RECORD_OFF;
+}
+
+struct cec_op_arib_data {
+	__u16 transport_id;
+	__u16 service_id;
+	__u16 orig_network_id;
+};
+
+struct cec_op_atsc_data {
+	__u16 transport_id;
+	__u16 program_number;
+};
+
+struct cec_op_dvb_data {
+	__u16 transport_id;
+	__u16 service_id;
+	__u16 orig_network_id;
+};
+
+struct cec_op_channel_data {
+	__u8 channel_number_fmt;
+	__u16 major;
+	__u16 minor;
+};
+
+struct cec_op_digital_service_id {
+	__u8 service_id_method;
+	__u8 dig_bcast_system;
+	union {
+		struct cec_op_arib_data arib;
+		struct cec_op_atsc_data atsc;
+		struct cec_op_dvb_data dvb;
+		struct cec_op_channel_data channel;
+	};
+};
+
+struct cec_op_record_src {
+	__u8 type;
+	union {
+		struct cec_op_digital_service_id digital;
+		struct {
+			__u8 ana_bcast_type;
+			__u16 ana_freq;
+			__u8 bcast_system;
+		} analog;
+		struct {
+			__u8 plug;
+		} ext_plug;
+		struct {
+			__u16 phys_addr;
+		} ext_phys_addr;
+	};
+};
+
+static __inline__ void cec_set_digital_service_id(__u8 *msg,
+	      const struct cec_op_digital_service_id *digital)
+{
+	*msg++ = (digital->service_id_method << 7) | digital->dig_bcast_system;
+	if (digital->service_id_method == CEC_OP_SERVICE_ID_METHOD_BY_CHANNEL) {
+		*msg++ = (digital->channel.channel_number_fmt << 2) |
+			 (digital->channel.major >> 8);
+		*msg++ = digital->channel.major && 0xff;
+		*msg++ = digital->channel.minor >> 8;
+		*msg++ = digital->channel.minor & 0xff;
+		*msg++ = 0;
+		*msg++ = 0;
+		return;
+	}
+	switch (digital->dig_bcast_system) {
+	case CEC_OP_DIG_SERVICE_BCAST_SYSTEM_ATSC_GEN:
+	case CEC_OP_DIG_SERVICE_BCAST_SYSTEM_ATSC_CABLE:
+	case CEC_OP_DIG_SERVICE_BCAST_SYSTEM_ATSC_SAT:
+	case CEC_OP_DIG_SERVICE_BCAST_SYSTEM_ATSC_T:
+		*msg++ = digital->atsc.transport_id >> 8;
+		*msg++ = digital->atsc.transport_id & 0xff;
+		*msg++ = digital->atsc.program_number >> 8;
+		*msg++ = digital->atsc.program_number & 0xff;
+		*msg++ = 0;
+		*msg++ = 0;
+		break;
+	default:
+		*msg++ = digital->dvb.transport_id >> 8;
+		*msg++ = digital->dvb.transport_id & 0xff;
+		*msg++ = digital->dvb.service_id >> 8;
+		*msg++ = digital->dvb.service_id & 0xff;
+		*msg++ = digital->dvb.orig_network_id >> 8;
+		*msg++ = digital->dvb.orig_network_id & 0xff;
+		break;
+	}
+}
+
+static __inline__ void cec_get_digital_service_id(const __u8 *msg,
+	      struct cec_op_digital_service_id *digital)
+{
+	digital->service_id_method = msg[0] >> 7;
+	digital->dig_bcast_system = msg[0] & 0x7f;
+	if (digital->service_id_method == CEC_OP_SERVICE_ID_METHOD_BY_CHANNEL) {
+		digital->channel.channel_number_fmt = msg[1] >> 2;
+		digital->channel.major = ((msg[1] & 3) << 6) | msg[2];
+		digital->channel.minor = (msg[3] << 8) | msg[4];
+		return;
+	}
+	digital->dvb.transport_id = (msg[1] << 8) | msg[2];
+	digital->dvb.service_id = (msg[3] << 8) | msg[4];
+	digital->dvb.orig_network_id = (msg[5] << 8) | msg[6];
+}
+
+static __inline__ void cec_msg_record_on_own(struct cec_msg *msg)
+{
+	msg->len = 3;
+	msg->msg[1] = CEC_MSG_RECORD_ON;
+	msg->msg[2] = CEC_OP_RECORD_SRC_OWN;
+}
+
+static __inline__ void cec_msg_record_on_digital(struct cec_msg *msg,
+			     const struct cec_op_digital_service_id *digital)
+{
+	msg->len = 10;
+	msg->msg[1] = CEC_MSG_RECORD_ON;
+	msg->msg[2] = CEC_OP_RECORD_SRC_DIGITAL;
+	cec_set_digital_service_id(msg->msg + 3, digital);
+}
+
+static __inline__ void cec_msg_record_on_analog(struct cec_msg *msg,
+					    __u8 ana_bcast_type,
+					    __u16 ana_freq,
+					    __u8 bcast_system)
+{
+	msg->len = 7;
+	msg->msg[1] = CEC_MSG_RECORD_ON;
+	msg->msg[2] = CEC_OP_RECORD_SRC_ANALOG;
+	msg->msg[3] = ana_bcast_type;
+	msg->msg[4] = ana_freq >> 8;
+	msg->msg[5] = ana_freq & 0xff;
+	msg->msg[6] = bcast_system;
+}
+
+static __inline__ void cec_msg_record_on_plug(struct cec_msg *msg,
+					  __u8 plug)
+{
+	msg->len = 4;
+	msg->msg[1] = CEC_MSG_RECORD_ON;
+	msg->msg[2] = CEC_OP_RECORD_SRC_EXT_PLUG;
+	msg->msg[3] = plug;
+}
+
+static __inline__ void cec_msg_record_on_phys_addr(struct cec_msg *msg,
+					       __u16 phys_addr)
+{
+	msg->len = 5;
+	msg->msg[1] = CEC_MSG_RECORD_ON;
+	msg->msg[2] = CEC_OP_RECORD_SRC_EXT_PHYS_ADDR;
+	msg->msg[3] = phys_addr >> 8;
+	msg->msg[4] = phys_addr & 0xff;
+}
+
+static __inline__ void cec_msg_record_on(struct cec_msg *msg,
+				     const struct cec_op_record_src *rec_src)
+{
+	switch (rec_src->type) {
+	case CEC_OP_RECORD_SRC_OWN:
+		cec_msg_record_on_own(msg);
+		break;
+	case CEC_OP_RECORD_SRC_DIGITAL:
+		cec_msg_record_on_digital(msg, &rec_src->digital);
+		break;
+	case CEC_OP_RECORD_SRC_ANALOG:
+		cec_msg_record_on_analog(msg,
+					 rec_src->analog.ana_bcast_type,
+					 rec_src->analog.ana_freq,
+					 rec_src->analog.bcast_system);
+		break;
+	case CEC_OP_RECORD_SRC_EXT_PLUG:
+		cec_msg_record_on_plug(msg, rec_src->ext_plug.plug);
+		break;
+	case CEC_OP_RECORD_SRC_EXT_PHYS_ADDR:
+		cec_msg_record_on_phys_addr(msg,
+					    rec_src->ext_phys_addr.phys_addr);
+		break;
+	}
+}
+
+static __inline__ void cec_ops_record_on(const struct cec_msg *msg,
+				     struct cec_op_record_src *rec_src)
+{
+	rec_src->type = msg->msg[2];
+	switch (rec_src->type) {
+	case CEC_OP_RECORD_SRC_OWN:
+		break;
+	case CEC_OP_RECORD_SRC_DIGITAL:
+		cec_get_digital_service_id(msg->msg + 3, &rec_src->digital);
+		break;
+	case CEC_OP_RECORD_SRC_ANALOG:
+		rec_src->analog.ana_bcast_type = msg->msg[3];
+		rec_src->analog.ana_freq =
+			(msg->msg[4] << 8) | msg->msg[5];
+		rec_src->analog.bcast_system = msg->msg[6];
+		break;
+	case CEC_OP_RECORD_SRC_EXT_PLUG:
+		rec_src->ext_plug.plug = msg->msg[3];
+		break;
+	case CEC_OP_RECORD_SRC_EXT_PHYS_ADDR:
+		rec_src->ext_phys_addr.phys_addr =
+			(msg->msg[3] << 8) | msg->msg[4];
+		break;
+	}
+}
+
+static __inline__ void cec_msg_record_status(struct cec_msg *msg, __u8 rec_status)
+{
+	msg->len = 3;
+	msg->msg[1] = CEC_MSG_RECORD_STATUS;
+	msg->msg[2] = rec_status;
+}
+
+static __inline__ void cec_ops_record_status(const struct cec_msg *msg,
+					 __u8 *rec_status)
+{
+	*rec_status = msg->msg[2];
+}
+
+static __inline__ void cec_msg_record_tv_screen(struct cec_msg *msg,
+					    bool reply)
+{
+	msg->len = 2;
+	msg->msg[1] = CEC_MSG_RECORD_TV_SCREEN;
+	msg->reply = reply ? CEC_MSG_RECORD_ON : 0;
+}
+
+
+/* Timer Programming Feature */
+static __inline__ void cec_msg_timer_status(struct cec_msg *msg,
+					__u8 timer_overlap_warning,
+					__u8 media_info,
+					__u8 prog_info,
+					__u8 prog_error,
+					__u8 duration_hr,
+					__u8 duration_min)
+{
+	msg->len = 3;
+	msg->msg[1] = CEC_MSG_TIMER_STATUS;
+	msg->msg[2] = (timer_overlap_warning << 7) |
+		(media_info << 5) |
+		(prog_info ? 0x10 : 0) |
+		(prog_info ? prog_info : prog_error);
+	if (prog_info == CEC_OP_PROG_INFO_NOT_ENOUGH_SPACE ||
+	    prog_info == CEC_OP_PROG_INFO_MIGHT_NOT_BE_ENOUGH_SPACE ||
+	    prog_error == CEC_OP_PROG_ERROR_DUPLICATE) {
+		msg->len += 2;
+		msg->msg[3] = ((duration_hr / 10) << 4) | (duration_hr % 10);
+		msg->msg[4] = ((duration_min / 10) << 4) | (duration_min % 10);
+	}
+}
+
+static __inline__ void cec_ops_timer_status(struct cec_msg *msg,
+					__u8 *timer_overlap_warning,
+					__u8 *media_info,
+					__u8 *prog_info,
+					__u8 *prog_error,
+					__u8 *duration_hr,
+					__u8 *duration_min)
+{
+	*timer_overlap_warning = msg->msg[2] >> 7;
+	*media_info = (msg->msg[2] >> 5) & 3;
+	if (msg->msg[2] & 0x10) {
+		*prog_info = msg->msg[2] & 0xf;
+		*prog_error = 0;
+	} else {
+		*prog_info = 0;
+		*prog_error = msg->msg[2] & 0xf;
+	}
+	if (*prog_info == CEC_OP_PROG_INFO_NOT_ENOUGH_SPACE ||
+	    *prog_info == CEC_OP_PROG_INFO_MIGHT_NOT_BE_ENOUGH_SPACE ||
+	    *prog_error == CEC_OP_PROG_ERROR_DUPLICATE) {
+		*duration_hr = (msg->msg[3] >> 4) * 10 + (msg->msg[3] & 0xf);
+		*duration_min = (msg->msg[4] >> 4) * 10 + (msg->msg[4] & 0xf);
+	} else {
+		*duration_hr = *duration_min = 0;
+	}
+}
+
+static __inline__ void cec_msg_timer_cleared_status(struct cec_msg *msg,
+						__u8 timer_cleared_status)
+{
+	msg->len = 3;
+	msg->msg[1] = CEC_MSG_TIMER_CLEARED_STATUS;
+	msg->msg[2] = timer_cleared_status;
+}
+
+static __inline__ void cec_ops_timer_cleared_status(struct cec_msg *msg,
+						__u8 *timer_cleared_status)
+{
+	*timer_cleared_status = msg->msg[2];
+}
+
+static __inline__ void cec_msg_clear_analogue_timer(struct cec_msg *msg,
+						bool reply,
+						__u8 day,
+						__u8 month,
+						__u8 start_hr,
+						__u8 start_min,
+						__u8 duration_hr,
+						__u8 duration_min,
+						__u8 recording_seq,
+						__u8 ana_bcast_type,
+						__u16 ana_freq,
+						__u8 bcast_system)
+{
+	msg->len = 13;
+	msg->msg[1] = CEC_MSG_CLEAR_ANALOGUE_TIMER;
+	msg->msg[2] = day;
+	msg->msg[3] = month;
+	/* Hours and minutes are in BCD format */
+	msg->msg[4] = ((start_hr / 10) << 4) | (start_hr % 10);
+	msg->msg[5] = ((start_min / 10) << 4) | (start_min % 10);
+	msg->msg[6] = ((duration_hr / 10) << 4) | (duration_hr % 10);
+	msg->msg[7] = ((duration_min / 10) << 4) | (duration_min % 10);
+	msg->msg[8] = recording_seq;
+	msg->msg[9] = ana_bcast_type;
+	msg->msg[10] = ana_freq >> 8;
+	msg->msg[11] = ana_freq & 0xff;
+	msg->msg[12] = bcast_system;
+	msg->reply = reply ? CEC_MSG_TIMER_CLEARED_STATUS : 0;
+}
+
+static __inline__ void cec_ops_clear_analogue_timer(struct cec_msg *msg,
+						__u8 *day,
+						__u8 *month,
+						__u8 *start_hr,
+						__u8 *start_min,
+						__u8 *duration_hr,
+						__u8 *duration_min,
+						__u8 *recording_seq,
+						__u8 *ana_bcast_type,
+						__u16 *ana_freq,
+						__u8 *bcast_system)
+{
+	*day = msg->msg[2];
+	*month = msg->msg[3];
+	/* Hours and minutes are in BCD format */
+	*start_hr = (msg->msg[4] >> 4) * 10 + (msg->msg[4] & 0xf);
+	*start_min = (msg->msg[5] >> 4) * 10 + (msg->msg[5] & 0xf);
+	*duration_hr = (msg->msg[6] >> 4) * 10 + (msg->msg[6] & 0xf);
+	*duration_min = (msg->msg[7] >> 4) * 10 + (msg->msg[7] & 0xf);
+	*recording_seq = msg->msg[8];
+	*ana_bcast_type = msg->msg[9];
+	*ana_freq = (msg->msg[10] << 8) | msg->msg[11];
+	*bcast_system = msg->msg[12];
+}
+
+static __inline__ void cec_msg_clear_digital_timer(struct cec_msg *msg,
+					       bool reply,
+					       __u8 day,
+					       __u8 month,
+					       __u8 start_hr,
+					       __u8 start_min,
+					       __u8 duration_hr,
+					       __u8 duration_min,
+					       __u8 recording_seq,
+					       const struct cec_op_digital_service_id *digital)
+{
+	msg->len = 16;
+	msg->reply = reply ? CEC_MSG_TIMER_CLEARED_STATUS : 0;
+	msg->msg[1] = CEC_MSG_CLEAR_DIGITAL_TIMER;
+	msg->msg[2] = day;
+	msg->msg[3] = month;
+	/* Hours and minutes are in BCD format */
+	msg->msg[4] = ((start_hr / 10) << 4) | (start_hr % 10);
+	msg->msg[5] = ((start_min / 10) << 4) | (start_min % 10);
+	msg->msg[6] = ((duration_hr / 10) << 4) | (duration_hr % 10);
+	msg->msg[7] = ((duration_min / 10) << 4) | (duration_min % 10);
+	msg->msg[8] = recording_seq;
+	cec_set_digital_service_id(msg->msg + 9, digital);
+}
+
+static __inline__ void cec_ops_clear_digital_timer(struct cec_msg *msg,
+					       __u8 *day,
+					       __u8 *month,
+					       __u8 *start_hr,
+					       __u8 *start_min,
+					       __u8 *duration_hr,
+					       __u8 *duration_min,
+					       __u8 *recording_seq,
+					       struct cec_op_digital_service_id *digital)
+{
+	*day = msg->msg[2];
+	*month = msg->msg[3];
+	/* Hours and minutes are in BCD format */
+	*start_hr = (msg->msg[4] >> 4) * 10 + (msg->msg[4] & 0xf);
+	*start_min = (msg->msg[5] >> 4) * 10 + (msg->msg[5] & 0xf);
+	*duration_hr = (msg->msg[6] >> 4) * 10 + (msg->msg[6] & 0xf);
+	*duration_min = (msg->msg[7] >> 4) * 10 + (msg->msg[7] & 0xf);
+	*recording_seq = msg->msg[8];
+	cec_get_digital_service_id(msg->msg + 9, digital);
+}
+
+static __inline__ void cec_msg_clear_ext_timer(struct cec_msg *msg,
+					   bool reply,
+					   __u8 day,
+					   __u8 month,
+					   __u8 start_hr,
+					   __u8 start_min,
+					   __u8 duration_hr,
+					   __u8 duration_min,
+					   __u8 recording_seq,
+					   __u8 ext_src_spec,
+					   __u8 plug,
+					   __u16 phys_addr)
+{
+	msg->len = 13;
+	msg->msg[1] = CEC_MSG_CLEAR_EXT_TIMER;
+	msg->msg[2] = day;
+	msg->msg[3] = month;
+	/* Hours and minutes are in BCD format */
+	msg->msg[4] = ((start_hr / 10) << 4) | (start_hr % 10);
+	msg->msg[5] = ((start_min / 10) << 4) | (start_min % 10);
+	msg->msg[6] = ((duration_hr / 10) << 4) | (duration_hr % 10);
+	msg->msg[7] = ((duration_min / 10) << 4) | (duration_min % 10);
+	msg->msg[8] = recording_seq;
+	msg->msg[9] = ext_src_spec;
+	msg->msg[10] = plug;
+	msg->msg[11] = phys_addr >> 8;
+	msg->msg[12] = phys_addr & 0xff;
+	msg->reply = reply ? CEC_MSG_TIMER_CLEARED_STATUS : 0;
+}
+
+static __inline__ void cec_ops_clear_ext_timer(struct cec_msg *msg,
+					   __u8 *day,
+					   __u8 *month,
+					   __u8 *start_hr,
+					   __u8 *start_min,
+					   __u8 *duration_hr,
+					   __u8 *duration_min,
+					   __u8 *recording_seq,
+					   __u8 *ext_src_spec,
+					   __u8 *plug,
+					   __u16 *phys_addr)
+{
+	*day = msg->msg[2];
+	*month = msg->msg[3];
+	/* Hours and minutes are in BCD format */
+	*start_hr = (msg->msg[4] >> 4) * 10 + (msg->msg[4] & 0xf);
+	*start_min = (msg->msg[5] >> 4) * 10 + (msg->msg[5] & 0xf);
+	*duration_hr = (msg->msg[6] >> 4) * 10 + (msg->msg[6] & 0xf);
+	*duration_min = (msg->msg[7] >> 4) * 10 + (msg->msg[7] & 0xf);
+	*recording_seq = msg->msg[8];
+	*ext_src_spec = msg->msg[9];
+	*plug = msg->msg[10];
+	*phys_addr = (msg->msg[11] << 8) | msg->msg[12];
+}
+
+static __inline__ void cec_msg_set_analogue_timer(struct cec_msg *msg,
+					      bool reply,
+					      __u8 day,
+					      __u8 month,
+					      __u8 start_hr,
+					      __u8 start_min,
+					      __u8 duration_hr,
+					      __u8 duration_min,
+					      __u8 recording_seq,
+					      __u8 ana_bcast_type,
+					      __u16 ana_freq,
+					      __u8 bcast_system)
+{
+	msg->len = 13;
+	msg->msg[1] = CEC_MSG_SET_ANALOGUE_TIMER;
+	msg->msg[2] = day;
+	msg->msg[3] = month;
+	/* Hours and minutes are in BCD format */
+	msg->msg[4] = ((start_hr / 10) << 4) | (start_hr % 10);
+	msg->msg[5] = ((start_min / 10) << 4) | (start_min % 10);
+	msg->msg[6] = ((duration_hr / 10) << 4) | (duration_hr % 10);
+	msg->msg[7] = ((duration_min / 10) << 4) | (duration_min % 10);
+	msg->msg[8] = recording_seq;
+	msg->msg[9] = ana_bcast_type;
+	msg->msg[10] = ana_freq >> 8;
+	msg->msg[11] = ana_freq & 0xff;
+	msg->msg[12] = bcast_system;
+	msg->reply = reply ? CEC_MSG_TIMER_STATUS : 0;
+}
+
+static __inline__ void cec_ops_set_analogue_timer(struct cec_msg *msg,
+					      __u8 *day,
+					      __u8 *month,
+					      __u8 *start_hr,
+					      __u8 *start_min,
+					      __u8 *duration_hr,
+					      __u8 *duration_min,
+					      __u8 *recording_seq,
+					      __u8 *ana_bcast_type,
+					      __u16 *ana_freq,
+					      __u8 *bcast_system)
+{
+	*day = msg->msg[2];
+	*month = msg->msg[3];
+	/* Hours and minutes are in BCD format */
+	*start_hr = (msg->msg[4] >> 4) * 10 + (msg->msg[4] & 0xf);
+	*start_min = (msg->msg[5] >> 4) * 10 + (msg->msg[5] & 0xf);
+	*duration_hr = (msg->msg[6] >> 4) * 10 + (msg->msg[6] & 0xf);
+	*duration_min = (msg->msg[7] >> 4) * 10 + (msg->msg[7] & 0xf);
+	*recording_seq = msg->msg[8];
+	*ana_bcast_type = msg->msg[9];
+	*ana_freq = (msg->msg[10] << 8) | msg->msg[11];
+	*bcast_system = msg->msg[12];
+}
+
+static __inline__ void cec_msg_set_digital_timer(struct cec_msg *msg,
+					     bool reply,
+					     __u8 day,
+					     __u8 month,
+					     __u8 start_hr,
+					     __u8 start_min,
+					     __u8 duration_hr,
+					     __u8 duration_min,
+					     __u8 recording_seq,
+					     const struct cec_op_digital_service_id *digital)
+{
+	msg->len = 16;
+	msg->reply = reply ? CEC_MSG_TIMER_STATUS : 0;
+	msg->msg[1] = CEC_MSG_SET_DIGITAL_TIMER;
+	msg->msg[2] = day;
+	msg->msg[3] = month;
+	/* Hours and minutes are in BCD format */
+	msg->msg[4] = ((start_hr / 10) << 4) | (start_hr % 10);
+	msg->msg[5] = ((start_min / 10) << 4) | (start_min % 10);
+	msg->msg[6] = ((duration_hr / 10) << 4) | (duration_hr % 10);
+	msg->msg[7] = ((duration_min / 10) << 4) | (duration_min % 10);
+	msg->msg[8] = recording_seq;
+	cec_set_digital_service_id(msg->msg + 9, digital);
+}
+
+static __inline__ void cec_ops_set_digital_timer(struct cec_msg *msg,
+					     __u8 *day,
+					     __u8 *month,
+					     __u8 *start_hr,
+					     __u8 *start_min,
+					     __u8 *duration_hr,
+					     __u8 *duration_min,
+					     __u8 *recording_seq,
+					     struct cec_op_digital_service_id *digital)
+{
+	*day = msg->msg[2];
+	*month = msg->msg[3];
+	/* Hours and minutes are in BCD format */
+	*start_hr = (msg->msg[4] >> 4) * 10 + (msg->msg[4] & 0xf);
+	*start_min = (msg->msg[5] >> 4) * 10 + (msg->msg[5] & 0xf);
+	*duration_hr = (msg->msg[6] >> 4) * 10 + (msg->msg[6] & 0xf);
+	*duration_min = (msg->msg[7] >> 4) * 10 + (msg->msg[7] & 0xf);
+	*recording_seq = msg->msg[8];
+	cec_get_digital_service_id(msg->msg + 9, digital);
+}
+
+static __inline__ void cec_msg_set_ext_timer(struct cec_msg *msg,
+					 bool reply,
+					 __u8 day,
+					 __u8 month,
+					 __u8 start_hr,
+					 __u8 start_min,
+					 __u8 duration_hr,
+					 __u8 duration_min,
+					 __u8 recording_seq,
+					 __u8 ext_src_spec,
+					 __u8 plug,
+					 __u16 phys_addr)
+{
+	msg->len = 13;
+	msg->msg[1] = CEC_MSG_SET_EXT_TIMER;
+	msg->msg[2] = day;
+	msg->msg[3] = month;
+	/* Hours and minutes are in BCD format */
+	msg->msg[4] = ((start_hr / 10) << 4) | (start_hr % 10);
+	msg->msg[5] = ((start_min / 10) << 4) | (start_min % 10);
+	msg->msg[6] = ((duration_hr / 10) << 4) | (duration_hr % 10);
+	msg->msg[7] = ((duration_min / 10) << 4) | (duration_min % 10);
+	msg->msg[8] = recording_seq;
+	msg->msg[9] = ext_src_spec;
+	msg->msg[10] = plug;
+	msg->msg[11] = phys_addr >> 8;
+	msg->msg[12] = phys_addr & 0xff;
+	msg->reply = reply ? CEC_MSG_TIMER_STATUS : 0;
+}
+
+static __inline__ void cec_ops_set_ext_timer(struct cec_msg *msg,
+					 __u8 *day,
+					 __u8 *month,
+					 __u8 *start_hr,
+					 __u8 *start_min,
+					 __u8 *duration_hr,
+					 __u8 *duration_min,
+					 __u8 *recording_seq,
+					 __u8 *ext_src_spec,
+					 __u8 *plug,
+					 __u16 *phys_addr)
+{
+	*day = msg->msg[2];
+	*month = msg->msg[3];
+	/* Hours and minutes are in BCD format */
+	*start_hr = (msg->msg[4] >> 4) * 10 + (msg->msg[4] & 0xf);
+	*start_min = (msg->msg[5] >> 4) * 10 + (msg->msg[5] & 0xf);
+	*duration_hr = (msg->msg[6] >> 4) * 10 + (msg->msg[6] & 0xf);
+	*duration_min = (msg->msg[7] >> 4) * 10 + (msg->msg[7] & 0xf);
+	*recording_seq = msg->msg[8];
+	*ext_src_spec = msg->msg[9];
+	*plug = msg->msg[10];
+	*phys_addr = (msg->msg[11] << 8) | msg->msg[12];
+}
+
+static __inline__ void cec_msg_set_timer_program_title(struct cec_msg *msg,
+						   const char *prog_title)
+{
+	unsigned len = strlen(prog_title);
+
+	if (len > 14)
+		len = 14;
+	msg->len = 2 + len;
+	msg->msg[1] = CEC_MSG_SET_TIMER_PROGRAM_TITLE;
+	memcpy(msg->msg + 2, prog_title, len);
+}
+
+static __inline__ void cec_ops_set_timer_program_title(const struct cec_msg *msg,
+						   char *prog_title)
+{
+	unsigned len = msg->len - 2;
+
+	if (len > 14)
+		len = 14;
+	memcpy(prog_title, msg->msg + 2, len);
+	prog_title[len] = '\0';
+}
+
+/* System Information Feature */
+static __inline__ void cec_msg_cec_version(struct cec_msg *msg, __u8 cec_version)
+{
+	msg->len = 3;
+	msg->msg[1] = CEC_MSG_CEC_VERSION;
+	msg->msg[2] = cec_version;
+}
+
+static __inline__ void cec_ops_cec_version(const struct cec_msg *msg,
+				       __u8 *cec_version)
+{
+	*cec_version = msg->msg[2];
+}
+
+static __inline__ void cec_msg_get_cec_version(struct cec_msg *msg,
+					   bool reply)
+{
+	msg->len = 2;
+	msg->msg[1] = CEC_MSG_GET_CEC_VERSION;
+	msg->reply = reply ? CEC_MSG_CEC_VERSION : 0;
+}
+
+static __inline__ void cec_msg_report_physical_addr(struct cec_msg *msg,
+						__u16 phys_addr, __u8 prim_devtype)
+{
+	msg->len = 5;
+	msg->msg[0] |= 0xf; /* broadcast */
+	msg->msg[1] = CEC_MSG_REPORT_PHYSICAL_ADDR;
+	msg->msg[2] = phys_addr >> 8;
+	msg->msg[3] = phys_addr & 0xff;
+	msg->msg[4] = prim_devtype;
+}
+
+static __inline__ void cec_ops_report_physical_addr(const struct cec_msg *msg,
+						__u16 *phys_addr, __u8 *prim_devtype)
+{
+	*phys_addr = (msg->msg[2] << 8) | msg->msg[3];
+	*prim_devtype = msg->msg[4];
+}
+
+static __inline__ void cec_msg_give_physical_addr(struct cec_msg *msg,
+					      bool reply)
+{
+	msg->len = 2;
+	msg->msg[1] = CEC_MSG_GIVE_PHYSICAL_ADDR;
+	msg->reply = reply ? CEC_MSG_REPORT_PHYSICAL_ADDR : 0;
+}
+
+static __inline__ void cec_msg_set_menu_language(struct cec_msg *msg,
+					     const char *language)
+{
+	msg->len = 5;
+	msg->msg[0] |= 0xf; /* broadcast */
+	msg->msg[1] = CEC_MSG_SET_MENU_LANGUAGE;
+	memcpy(msg->msg + 2, language, 3);
+}
+
+static __inline__ void cec_ops_set_menu_language(struct cec_msg *msg,
+					     char *language)
+{
+	memcpy(language, msg->msg + 2, 3);
+}
+
+static __inline__ void cec_msg_get_menu_language(struct cec_msg *msg,
+					     bool reply)
+{
+	msg->len = 2;
+	msg->msg[1] = CEC_MSG_GET_MENU_LANGUAGE;
+	msg->reply = reply ? CEC_MSG_SET_MENU_LANGUAGE : 0;
+}
+
+/*
+ * Assumes a single RC Profile byte and a single Device Features byte,
+ * i.e. no extended features are supported by this helper function.
+ */
+static __inline__ void cec_msg_report_features(struct cec_msg *msg,
+					   __u8 cec_version, __u8 all_device_types,
+					   __u8 rc_profile, __u8 dev_features)
+{
+	msg->len = 6;
+	msg->msg[0] |= 0xf; /* broadcast */
+	msg->msg[1] = CEC_MSG_REPORT_FEATURES;
+	msg->msg[2] = cec_version;
+	msg->msg[3] = all_device_types;
+	msg->msg[4] = rc_profile;
+	msg->msg[5] = dev_features;
+}
+
+static __inline__ void cec_ops_report_features(const struct cec_msg *msg,
+					   __u8 *cec_version, __u8 *all_device_types,
+					   const __u8 **rc_profile, const __u8 **dev_features)
+{
+	const __u8 *p = &msg->msg[4];
+
+	*cec_version = msg->msg[2];
+	*all_device_types = msg->msg[3];
+	*rc_profile = p;
+	while (p < &msg->msg[14] && (*p & CEC_OP_FEAT_EXT))
+		p++;
+	if (!(*p & CEC_OP_FEAT_EXT)) {
+		*dev_features = p + 1;
+		while (p < &msg->msg[15] && (*p & CEC_OP_FEAT_EXT))
+			p++;
+	}
+	if (*p & CEC_OP_FEAT_EXT)
+		*rc_profile = *dev_features = NULL;
+}
+
+static __inline__ void cec_msg_give_features(struct cec_msg *msg,
+					 bool reply)
+{
+	msg->len = 2;
+	msg->msg[1] = CEC_MSG_GIVE_FEATURES;
+	msg->reply = reply ? CEC_MSG_REPORT_FEATURES : 0;
+}
+
+/* Deck Control Feature */
+static __inline__ void cec_msg_deck_control(struct cec_msg *msg,
+					__u8 deck_control_mode)
+{
+	msg->len = 3;
+	msg->msg[1] = CEC_MSG_DECK_CONTROL;
+	msg->msg[2] = deck_control_mode;
+}
+
+static __inline__ void cec_ops_deck_control(struct cec_msg *msg,
+					__u8 *deck_control_mode)
+{
+	*deck_control_mode = msg->msg[2];
+}
+
+static __inline__ void cec_msg_deck_status(struct cec_msg *msg,
+				       __u8 deck_info)
+{
+	msg->len = 3;
+	msg->msg[1] = CEC_MSG_DECK_STATUS;
+	msg->msg[2] = deck_info;
+}
+
+static __inline__ void cec_ops_deck_status(struct cec_msg *msg,
+				       __u8 *deck_info)
+{
+	*deck_info = msg->msg[2];
+}
+
+static __inline__ void cec_msg_give_deck_status(struct cec_msg *msg,
+					    bool reply,
+					    __u8 status_req)
+{
+	msg->len = 3;
+	msg->msg[1] = CEC_MSG_GIVE_DECK_STATUS;
+	msg->msg[2] = status_req;
+	msg->reply = reply ? CEC_MSG_DECK_STATUS : 0;
+}
+
+static __inline__ void cec_ops_give_deck_status(struct cec_msg *msg,
+					    __u8 *status_req)
+{
+	*status_req = msg->msg[2];
+}
+
+static __inline__ void cec_msg_play(struct cec_msg *msg,
+				__u8 play_mode)
+{
+	msg->len = 3;
+	msg->msg[1] = CEC_MSG_PLAY;
+	msg->msg[2] = play_mode;
+}
+
+static __inline__ void cec_ops_play(struct cec_msg *msg,
+				__u8 *play_mode)
+{
+	*play_mode = msg->msg[2];
+}
+
+
+/* Tuner Control Feature */
+struct cec_op_tuner_device_info {
+	__u8 rec_flag;
+	__u8 tuner_display_info;
+	bool is_analog;
+	union {
+		struct cec_op_digital_service_id digital;
+		struct {
+			__u8 ana_bcast_type;
+			__u16 ana_freq;
+			__u8 bcast_system;
+		} analog;
+	};
+};
+
+static __inline__ void cec_msg_tuner_device_status_analog(struct cec_msg *msg,
+						      __u8 rec_flag,
+						      __u8 tuner_display_info,
+						      __u8 ana_bcast_type,
+						      __u16 ana_freq,
+						      __u8 bcast_system)
+{
+	msg->len = 7;
+	msg->msg[1] = CEC_MSG_TUNER_DEVICE_STATUS;
+	msg->msg[2] = (rec_flag << 7) | tuner_display_info;
+	msg->msg[3] = ana_bcast_type;
+	msg->msg[4] = ana_freq >> 8;
+	msg->msg[5] = ana_freq & 0xff;
+	msg->msg[6] = bcast_system;
+}
+
+static __inline__ void cec_msg_tuner_device_status_digital(struct cec_msg *msg,
+		   __u8 rec_flag, __u8 tuner_display_info,
+		   const struct cec_op_digital_service_id *digital)
+{
+	msg->len = 10;
+	msg->msg[1] = CEC_MSG_TUNER_DEVICE_STATUS;
+	msg->msg[2] = (rec_flag << 7) | tuner_display_info;
+	cec_set_digital_service_id(msg->msg + 3, digital);
+}
+
+static __inline__ void cec_msg_tuner_device_status(struct cec_msg *msg,
+			const struct cec_op_tuner_device_info *tuner_dev_info)
+{
+	if (tuner_dev_info->is_analog)
+		cec_msg_tuner_device_status_analog(msg,
+			tuner_dev_info->rec_flag,
+			tuner_dev_info->tuner_display_info,
+			tuner_dev_info->analog.ana_bcast_type,
+			tuner_dev_info->analog.ana_freq,
+			tuner_dev_info->analog.bcast_system);
+	else
+		cec_msg_tuner_device_status_digital(msg,
+			tuner_dev_info->rec_flag,
+			tuner_dev_info->tuner_display_info,
+			&tuner_dev_info->digital);
+}
+
+static __inline__ void cec_ops_tuner_device_status(struct cec_msg *msg,
+					       struct cec_op_tuner_device_info *tuner_dev_info)
+{
+	tuner_dev_info->is_analog = msg->len < 10;
+	tuner_dev_info->rec_flag = msg->msg[2] >> 7;
+	tuner_dev_info->tuner_display_info = msg->msg[2] & 0x7f;
+	if (tuner_dev_info->is_analog) {
+		tuner_dev_info->analog.ana_bcast_type = msg->msg[3];
+		tuner_dev_info->analog.ana_freq = (msg->msg[4] << 8) | msg->msg[5];
+		tuner_dev_info->analog.bcast_system = msg->msg[6];
+		return;
+	}
+	cec_get_digital_service_id(msg->msg + 3, &tuner_dev_info->digital);
+}
+
+static __inline__ void cec_msg_give_tuner_device_status(struct cec_msg *msg,
+						    bool reply,
+						    __u8 status_req)
+{
+	msg->len = 3;
+	msg->msg[1] = CEC_MSG_GIVE_TUNER_DEVICE_STATUS;
+	msg->msg[2] = status_req;
+	msg->reply = reply ? CEC_MSG_TUNER_DEVICE_STATUS : 0;
+}
+
+static __inline__ void cec_ops_give_tuner_device_status(struct cec_msg *msg,
+						    __u8 *status_req)
+{
+	*status_req = msg->msg[2];
+}
+
+static __inline__ void cec_msg_select_analogue_service(struct cec_msg *msg,
+						   __u8 ana_bcast_type,
+						   __u16 ana_freq,
+						   __u8 bcast_system)
+{
+	msg->len = 6;
+	msg->msg[1] = CEC_MSG_SELECT_ANALOGUE_SERVICE;
+	msg->msg[2] = ana_bcast_type;
+	msg->msg[3] = ana_freq >> 8;
+	msg->msg[4] = ana_freq & 0xff;
+	msg->msg[5] = bcast_system;
+}
+
+static __inline__ void cec_ops_select_analogue_service(struct cec_msg *msg,
+						   __u8 *ana_bcast_type,
+						   __u16 *ana_freq,
+						   __u8 *bcast_system)
+{
+	*ana_bcast_type = msg->msg[2];
+	*ana_freq = (msg->msg[3] << 8) | msg->msg[4];
+	*bcast_system = msg->msg[5];
+}
+
+static __inline__ void cec_msg_select_digital_service(struct cec_msg *msg,
+						  const struct cec_op_digital_service_id *digital)
+{
+	msg->len = 9;
+	msg->msg[1] = CEC_MSG_SELECT_DIGITAL_SERVICE;
+	cec_set_digital_service_id(msg->msg + 2, digital);
+}
+
+static __inline__ void cec_ops_select_digital_service(struct cec_msg *msg,
+						  struct cec_op_digital_service_id *digital)
+{
+	cec_get_digital_service_id(msg->msg + 2, digital);
+}
+
+static __inline__ void cec_msg_tuner_step_decrement(struct cec_msg *msg)
+{
+	msg->len = 2;
+	msg->msg[1] = CEC_MSG_TUNER_STEP_DECREMENT;
+}
+
+static __inline__ void cec_msg_tuner_step_increment(struct cec_msg *msg)
+{
+	msg->len = 2;
+	msg->msg[1] = CEC_MSG_TUNER_STEP_INCREMENT;
+}
+
+
+/* Vendor Specific Commands Feature */
+static __inline__ void cec_msg_device_vendor_id(struct cec_msg *msg, __u32 vendor_id)
+{
+	msg->len = 5;
+	msg->msg[0] |= 0xf; /* broadcast */
+	msg->msg[1] = CEC_MSG_DEVICE_VENDOR_ID;
+	msg->msg[2] = vendor_id >> 16;
+	msg->msg[3] = (vendor_id >> 8) & 0xff;
+	msg->msg[4] = vendor_id & 0xff;
+}
+
+static __inline__ void cec_ops_device_vendor_id(const struct cec_msg *msg,
+					    __u32 *vendor_id)
+{
+	*vendor_id = (msg->msg[2] << 16) | (msg->msg[3] << 8) | msg->msg[4];
+}
+
+static __inline__ void cec_msg_give_device_vendor_id(struct cec_msg *msg,
+						 bool reply)
+{
+	msg->len = 2;
+	msg->msg[1] = CEC_MSG_GIVE_DEVICE_VENDOR_ID;
+	msg->reply = reply ? CEC_MSG_DEVICE_VENDOR_ID : 0;
+}
+
+static __inline__ void cec_msg_vendor_remote_button_up(struct cec_msg *msg)
+{
+	msg->len = 2;
+	msg->msg[1] = CEC_MSG_VENDOR_REMOTE_BUTTON_UP;
+}
+
+
+/* OSD Display Feature */
+static __inline__ void cec_msg_set_osd_string(struct cec_msg *msg,
+					  __u8 disp_ctl,
+					  const char *osd)
+{
+	unsigned len = strlen(osd);
+
+	if (len > 13)
+		len = 13;
+	msg->len = 3 + len;
+	msg->msg[1] = CEC_MSG_SET_OSD_STRING;
+	msg->msg[2] = disp_ctl;
+	memcpy(msg->msg + 3, osd, len);
+}
+
+static __inline__ void cec_ops_set_osd_string(const struct cec_msg *msg,
+					  __u8 *disp_ctl,
+					  char *osd)
+{
+	unsigned len = msg->len - 3;
+
+	*disp_ctl = msg->msg[2];
+	if (len > 13)
+		len = 13;
+	memcpy(osd, msg->msg + 3, len);
+	osd[len] = '\0';
+}
+
+
+/* Device OSD Transfer Feature */
+static __inline__ void cec_msg_set_osd_name(struct cec_msg *msg, const char *name)
+{
+	unsigned len = strlen(name);
+
+	if (len > 14)
+		len = 14;
+	msg->len = 2 + len;
+	msg->msg[1] = CEC_MSG_SET_OSD_NAME;
+	memcpy(msg->msg + 2, name, len);
+}
+
+static __inline__ void cec_ops_set_osd_name(const struct cec_msg *msg,
+					char *name)
+{
+	unsigned len = msg->len - 2;
+
+	if (len > 14)
+		len = 14;
+	memcpy(name, msg->msg + 2, len);
+	name[len] = '\0';
+}
+
+static __inline__ void cec_msg_give_osd_name(struct cec_msg *msg,
+					 bool reply)
+{
+	msg->len = 2;
+	msg->msg[1] = CEC_MSG_GIVE_OSD_NAME;
+	msg->reply = reply ? CEC_MSG_SET_OSD_NAME : 0;
+}
+
+
+/* Device Menu Control Feature */
+static __inline__ void cec_msg_menu_status(struct cec_msg *msg,
+				       __u8 menu_state)
+{
+	msg->len = 3;
+	msg->msg[1] = CEC_MSG_MENU_STATUS;
+	msg->msg[2] = menu_state;
+}
+
+static __inline__ void cec_ops_menu_status(struct cec_msg *msg,
+				       __u8 *menu_state)
+{
+	*menu_state = msg->msg[2];
+}
+
+static __inline__ void cec_msg_menu_request(struct cec_msg *msg,
+					bool reply,
+					__u8 menu_req)
+{
+	msg->len = 3;
+	msg->msg[1] = CEC_MSG_MENU_REQUEST;
+	msg->msg[2] = menu_req;
+	msg->reply = reply ? CEC_MSG_MENU_STATUS : 0;
+}
+
+static __inline__ void cec_ops_menu_request(struct cec_msg *msg,
+					__u8 *menu_req)
+{
+	*menu_req = msg->msg[2];
+}
+
+static __inline__ void cec_msg_user_control_pressed(struct cec_msg *msg,
+						__u8 ui_cmd)
+{
+	msg->len = 3;
+	msg->msg[1] = CEC_MSG_USER_CONTROL_PRESSED;
+	msg->msg[2] = ui_cmd;
+}
+
+static __inline__ void cec_ops_user_control_pressed(struct cec_msg *msg,
+						__u8 *ui_cmd)
+{
+	*ui_cmd = msg->msg[2];
+}
+
+static __inline__ void cec_msg_user_control_released(struct cec_msg *msg)
+{
+	msg->len = 2;
+	msg->msg[1] = CEC_MSG_USER_CONTROL_RELEASED;
+}
+
+/* Remote Control Passthrough Feature */
+
+/* Power Status Feature */
+static __inline__ void cec_msg_report_power_status(struct cec_msg *msg,
+					       __u8 pwr_state)
+{
+	msg->len = 3;
+	msg->msg[1] = CEC_MSG_REPORT_POWER_STATUS;
+	msg->msg[2] = pwr_state;
+}
+
+static __inline__ void cec_ops_report_power_status(const struct cec_msg *msg,
+					       __u8 *pwr_state)
+{
+	*pwr_state = msg->msg[2];
+}
+
+static __inline__ void cec_msg_give_device_power_status(struct cec_msg *msg,
+						    bool reply)
+{
+	msg->len = 2;
+	msg->msg[1] = CEC_MSG_GIVE_DEVICE_POWER_STATUS;
+	msg->reply = reply ? CEC_MSG_REPORT_POWER_STATUS : 0;
+}
+
+/* General Protocol Messages */
+static __inline__ void cec_msg_feature_abort(struct cec_msg *msg,
+					 __u8 abort_msg, __u8 reason)
+{
+	msg->len = 4;
+	msg->msg[1] = CEC_MSG_FEATURE_ABORT;
+	msg->msg[2] = abort_msg;
+	msg->msg[3] = reason;
+}
+
+static __inline__ void cec_ops_feature_abort(const struct cec_msg *msg,
+					 __u8 *abort_msg, __u8 *reason)
+{
+	*abort_msg = msg->msg[2];
+	*reason = msg->msg[3];
+}
+
+/* This changes the current message into an abort message */
+static __inline__ void cec_msg_reply_abort(struct cec_msg *msg, __u8 reason)
+{
+	cec_msg_set_reply_to(msg, msg);
+	msg->len = 4;
+	msg->msg[2] = msg->msg[1];
+	msg->msg[3] = reason;
+	msg->msg[1] = CEC_MSG_FEATURE_ABORT;
+}
+
+static __inline__ void cec_msg_abort(struct cec_msg *msg)
+{
+	msg->len = 2;
+	msg->msg[1] = CEC_MSG_ABORT;
+}
+
+
+/* System Audio Control Feature */
+static __inline__ void cec_msg_report_audio_status(struct cec_msg *msg,
+					       __u8 aud_mute_status,
+					       __u8 aud_vol_status)
+{
+	msg->len = 3;
+	msg->msg[1] = CEC_MSG_REPORT_AUDIO_STATUS;
+	msg->msg[2] = (aud_mute_status << 7) | (aud_vol_status & 0x7f);
+}
+
+static __inline__ void cec_ops_report_audio_status(const struct cec_msg *msg,
+					       __u8 *aud_mute_status,
+					       __u8 *aud_vol_status)
+{
+	*aud_mute_status = msg->msg[2] >> 7;
+	*aud_vol_status = msg->msg[2] & 0x7f;
+}
+
+static __inline__ void cec_msg_give_audio_status(struct cec_msg *msg,
+					     bool reply)
+{
+	msg->len = 2;
+	msg->msg[1] = CEC_MSG_GIVE_AUDIO_STATUS;
+	msg->reply = reply ? CEC_MSG_REPORT_AUDIO_STATUS : 0;
+}
+
+static __inline__ void cec_msg_set_system_audio_mode(struct cec_msg *msg,
+						 __u8 sys_aud_status)
+{
+	msg->len = 3;
+	msg->msg[1] = CEC_MSG_SET_SYSTEM_AUDIO_MODE;
+	msg->msg[2] = sys_aud_status;
+}
+
+static __inline__ void cec_ops_set_system_audio_mode(const struct cec_msg *msg,
+						 __u8 *sys_aud_status)
+{
+	*sys_aud_status = msg->msg[2];
+}
+
+static __inline__ void cec_msg_system_audio_mode_request(struct cec_msg *msg,
+						     bool reply,
+						     __u16 phys_addr)
+{
+	msg->len = phys_addr == 0xffff ? 2 : 4;
+	msg->msg[1] = CEC_MSG_SYSTEM_AUDIO_MODE_REQUEST;
+	msg->msg[2] = phys_addr >> 8;
+	msg->msg[3] = phys_addr & 0xff;
+	msg->reply = reply ? CEC_MSG_SET_SYSTEM_AUDIO_MODE : 0;
+
+}
+
+static __inline__ void cec_ops_system_audio_mode_request(const struct cec_msg *msg,
+						     __u16 *phys_addr)
+{
+	if (msg->len < 4)
+		*phys_addr = 0xffff;
+	else
+		*phys_addr = (msg->msg[2] << 8) | msg->msg[3];
+}
+
+static __inline__ void cec_msg_system_audio_mode_status(struct cec_msg *msg,
+						    __u8 sys_aud_status)
+{
+	msg->len = 3;
+	msg->msg[1] = CEC_MSG_SYSTEM_AUDIO_MODE_STATUS;
+	msg->msg[2] = sys_aud_status;
+}
+
+static __inline__ void cec_ops_system_audio_mode_status(const struct cec_msg *msg,
+						    __u8 *sys_aud_status)
+{
+	*sys_aud_status = msg->msg[2];
+}
+
+static __inline__ void cec_msg_give_system_audio_mode_status(struct cec_msg *msg,
+							 bool reply)
+{
+	msg->len = 2;
+	msg->msg[1] = CEC_MSG_GIVE_SYSTEM_AUDIO_MODE_STATUS;
+	msg->reply = reply ? CEC_MSG_SYSTEM_AUDIO_MODE_STATUS : 0;
+}
+
+static __inline__ void cec_msg_report_short_audio_descriptor(struct cec_msg *msg,
+							 __u8 num_descriptors,
+							 const __u32 *descriptors)
+{
+	unsigned i;
+
+	msg->len = 2 + num_descriptors * 3;
+	msg->msg[1] = CEC_MSG_REPORT_SHORT_AUDIO_DESCRIPTOR;
+	for (i = 0; i < num_descriptors; i++) {
+		msg->msg[2 + i * 3] = (descriptors[i] >> 16) & 0xff;
+		msg->msg[3 + i * 3] = (descriptors[i] >> 8) & 0xff;
+		msg->msg[4 + i * 3] = descriptors[i] & 0xff;
+	}
+}
+
+static __inline__ void cec_ops_report_short_audio_descriptor(const struct cec_msg *msg,
+							 __u8 *num_descriptors,
+							 __u32 *descriptors)
+{
+	unsigned i;
+
+	*num_descriptors = (msg->len - 2) / 3;
+	for (i = 0; i < *num_descriptors; i++)
+		descriptors[i] = (msg->msg[2 + i * 3] << 16) |
+			(msg->msg[3 + i * 3] << 8) |
+			msg->msg[4 + i * 3];
+}
+
+static __inline__ void cec_msg_request_short_audio_descriptor(struct cec_msg *msg,
+							  __u8 audio_format_id,
+							  __u8 audio_format_code)
+{
+	msg->len = 3;
+	msg->msg[1] = CEC_MSG_REQUEST_SHORT_AUDIO_DESCRIPTOR;
+	msg->msg[2] = (audio_format_id << 6) | (audio_format_code & 0x3f);
+}
+
+static __inline__ void cec_ops_request_short_audio_descriptor(const struct cec_msg *msg,
+							  __u8 *audio_format_id,
+							  __u8 *audio_format_code)
+{
+	*audio_format_id = msg->msg[2] >> 6;
+	*audio_format_code = msg->msg[2] & 0x3f;
+}
+
+
+/* Audio Rate Control Feature */
+static __inline__ void cec_msg_set_audio_rate(struct cec_msg *msg,
+					  __u8 audio_rate)
+{
+	msg->len = 3;
+	msg->msg[1] = CEC_MSG_SET_AUDIO_RATE;
+	msg->msg[2] = audio_rate;
+}
+
+static __inline__ void cec_ops_set_audio_rate(const struct cec_msg *msg,
+					  __u8 *audio_rate)
+{
+	*audio_rate = msg->msg[2];
+}
+
+
+/* Audio Return Channel Control Feature */
+static __inline__ void cec_msg_report_arc_initiated(struct cec_msg *msg)
+{
+	msg->len = 2;
+	msg->msg[1] = CEC_MSG_REPORT_ARC_INITIATED;
+}
+
+static __inline__ void cec_msg_initiate_arc(struct cec_msg *msg,
+					bool reply)
+{
+	msg->len = 2;
+	msg->msg[1] = CEC_MSG_INITIATE_ARC;
+	msg->reply = reply ? CEC_MSG_REPORT_ARC_INITIATED : 0;
+}
+
+static __inline__ void cec_msg_request_arc_initiation(struct cec_msg *msg,
+						  bool reply)
+{
+	msg->len = 2;
+	msg->msg[1] = CEC_MSG_REQUEST_ARC_INITIATION;
+	msg->reply = reply ? CEC_MSG_INITIATE_ARC : 0;
+}
+
+static __inline__ void cec_msg_report_arc_terminated(struct cec_msg *msg)
+{
+	msg->len = 2;
+	msg->msg[1] = CEC_MSG_REPORT_ARC_TERMINATED;
+}
+
+static __inline__ void cec_msg_terminate_arc(struct cec_msg *msg,
+					 bool reply)
+{
+	msg->len = 2;
+	msg->msg[1] = CEC_MSG_TERMINATE_ARC;
+	msg->reply = reply ? CEC_MSG_REPORT_ARC_TERMINATED : 0;
+}
+
+static __inline__ void cec_msg_request_arc_termination(struct cec_msg *msg,
+						   bool reply)
+{
+	msg->len = 2;
+	msg->msg[1] = CEC_MSG_REQUEST_ARC_TERMINATION;
+	msg->reply = reply ? CEC_MSG_TERMINATE_ARC : 0;
+}
+
+
+/* Dynamic Audio Lipsync Feature */
+/* Only for CEC 2.0 and up */
+static __inline__ void cec_msg_report_current_latency(struct cec_msg *msg,
+						  __u16 phys_addr,
+						  __u8 video_latency,
+						  __u8 low_latency_mode,
+						  __u8 audio_out_compensated,
+						  __u8 audio_out_delay)
+{
+	msg->len = 7;
+	msg->msg[1] = CEC_MSG_REPORT_CURRENT_LATENCY;
+	msg->msg[2] = phys_addr >> 8;
+	msg->msg[3] = phys_addr & 0xff;
+	msg->msg[4] = video_latency;
+	msg->msg[5] = (low_latency_mode << 2) | audio_out_compensated;
+	msg->msg[6] = audio_out_delay;
+}
+
+static __inline__ void cec_ops_report_current_latency(const struct cec_msg *msg,
+						  __u16 *phys_addr,
+						  __u8 *video_latency,
+						  __u8 *low_latency_mode,
+						  __u8 *audio_out_compensated,
+						  __u8 *audio_out_delay)
+{
+	*phys_addr = (msg->msg[2] << 8) | msg->msg[3];
+	*video_latency = msg->msg[4];
+	*low_latency_mode = (msg->msg[5] >> 2) & 1;
+	*audio_out_compensated = msg->msg[5] & 3;
+	*audio_out_delay = msg->msg[6];
+}
+
+static __inline__ void cec_msg_request_current_latency(struct cec_msg *msg,
+						   bool reply,
+						   __u16 phys_addr)
+{
+	msg->len = 4;
+	msg->msg[1] = CEC_MSG_REQUEST_CURRENT_LATENCY;
+	msg->msg[2] = phys_addr >> 8;
+	msg->msg[3] = phys_addr & 0xff;
+	msg->reply = reply ? CEC_MSG_REPORT_CURRENT_LATENCY : 0;
+}
+
+static __inline__ void cec_ops_request_current_latency(const struct cec_msg *msg,
+						   __u16 *phys_addr)
+{
+	*phys_addr = (msg->msg[2] << 8) | msg->msg[3];
+}
+
+
+/* Capability Discovery and Control Feature */
+static __inline__ void cec_msg_cdc_hec_inquire_state(struct cec_msg *msg,
+						 __u16 phys_addr1,
+						 __u16 phys_addr2)
+{
+	msg->len = 9;
+	msg->msg[0] |= 0xf; /* broadcast */
+	msg->msg[1] = CEC_MSG_CDC_MESSAGE;
+	/* msg[2] and msg[3] (phys_addr) are filled in by the CEC framework */
+	msg->msg[4] = CEC_MSG_CDC_HEC_INQUIRE_STATE;
+	msg->msg[5] = phys_addr1 >> 8;
+	msg->msg[6] = phys_addr1 & 0xff;
+	msg->msg[7] = phys_addr2 >> 8;
+	msg->msg[8] = phys_addr2 & 0xff;
+}
+
+static __inline__ void cec_ops_cdc_hec_inquire_state(const struct cec_msg *msg,
+						 __u16 *phys_addr,
+						 __u16 *phys_addr1,
+						 __u16 *phys_addr2)
+{
+	*phys_addr = (msg->msg[2] << 8) | msg->msg[3];
+	*phys_addr1 = (msg->msg[5] << 8) | msg->msg[6];
+	*phys_addr2 = (msg->msg[7] << 8) | msg->msg[8];
+}
+
+static __inline__ void cec_msg_cdc_hec_report_state(struct cec_msg *msg,
+						__u16 target_phys_addr,
+						__u8 hec_func_state,
+						__u8 host_func_state,
+						__u8 enc_func_state,
+						__u8 cdc_errcode,
+						__u8 has_field,
+						__u16 hec_field)
+{
+	msg->len = has_field ? 10 : 8;
+	msg->msg[0] |= 0xf; /* broadcast */
+	msg->msg[1] = CEC_MSG_CDC_MESSAGE;
+	/* msg[2] and msg[3] (phys_addr) are filled in by the CEC framework */
+	msg->msg[4] = CEC_MSG_CDC_HEC_REPORT_STATE;
+	msg->msg[5] = target_phys_addr >> 8;
+	msg->msg[6] = target_phys_addr & 0xff;
+	msg->msg[7] = (hec_func_state << 6) |
+		      (host_func_state << 4) |
+		      (enc_func_state << 2) |
+		      cdc_errcode;
+	if (has_field) {
+		msg->msg[8] = hec_field >> 8;
+		msg->msg[9] = hec_field & 0xff;
+	}
+}
+
+static __inline__ void cec_ops_cdc_hec_report_state(const struct cec_msg *msg,
+						__u16 *phys_addr,
+						__u16 *target_phys_addr,
+						__u8 *hec_func_state,
+						__u8 *host_func_state,
+						__u8 *enc_func_state,
+						__u8 *cdc_errcode,
+						__u8 *has_field,
+						__u16 *hec_field)
+{
+	*phys_addr = (msg->msg[2] << 8) | msg->msg[3];
+	*target_phys_addr = (msg->msg[5] << 8) | msg->msg[6];
+	*hec_func_state = msg->msg[7] >> 6;
+	*host_func_state = (msg->msg[7] >> 4) & 3;
+	*enc_func_state = (msg->msg[7] >> 4) & 3;
+	*cdc_errcode = msg->msg[7] & 3;
+	*has_field = msg->len >= 10;
+	*hec_field = *has_field ? ((msg->msg[8] << 8) | msg->msg[9]) : 0;
+}
+
+static __inline__ void cec_msg_cdc_hec_set_state(struct cec_msg *msg,
+					     __u16 phys_addr1,
+					     __u16 phys_addr2,
+					     __u8 hec_set_state,
+					     __u16 phys_addr3,
+					     __u16 phys_addr4,
+					     __u16 phys_addr5)
+{
+	msg->len = 10;
+	msg->msg[0] |= 0xf; /* broadcast */
+	msg->msg[1] = CEC_MSG_CDC_MESSAGE;
+	/* msg[2] and msg[3] (phys_addr) are filled in by the CEC framework */
+	msg->msg[4] = CEC_MSG_CDC_HEC_INQUIRE_STATE;
+	msg->msg[5] = phys_addr1 >> 8;
+	msg->msg[6] = phys_addr1 & 0xff;
+	msg->msg[7] = phys_addr2 >> 8;
+	msg->msg[8] = phys_addr2 & 0xff;
+	msg->msg[9] = hec_set_state;
+	if (phys_addr3 != CEC_PHYS_ADDR_INVALID) {
+		msg->msg[msg->len++] = phys_addr3 >> 8;
+		msg->msg[msg->len++] = phys_addr3 & 0xff;
+		if (phys_addr4 != CEC_PHYS_ADDR_INVALID) {
+			msg->msg[msg->len++] = phys_addr4 >> 8;
+			msg->msg[msg->len++] = phys_addr4 & 0xff;
+			if (phys_addr5 != CEC_PHYS_ADDR_INVALID) {
+				msg->msg[msg->len++] = phys_addr5 >> 8;
+				msg->msg[msg->len++] = phys_addr5 & 0xff;
+			}
+		}
+	}
+}
+
+static __inline__ void cec_ops_cdc_hec_set_state(const struct cec_msg *msg,
+					     __u16 *phys_addr,
+					     __u16 *phys_addr1,
+					     __u16 *phys_addr2,
+					     __u8 *hec_set_state,
+					     __u16 *phys_addr3,
+					     __u16 *phys_addr4,
+					     __u16 *phys_addr5)
+{
+	*phys_addr = (msg->msg[2] << 8) | msg->msg[3];
+	*phys_addr1 = (msg->msg[5] << 8) | msg->msg[6];
+	*phys_addr2 = (msg->msg[7] << 8) | msg->msg[8];
+	*hec_set_state = msg->msg[9];
+	*phys_addr3 = *phys_addr4 = *phys_addr5 = CEC_PHYS_ADDR_INVALID;
+	if (msg->len >= 12)
+		*phys_addr3 = (msg->msg[10] << 8) | msg->msg[11];
+	if (msg->len >= 14)
+		*phys_addr4 = (msg->msg[12] << 8) | msg->msg[13];
+	if (msg->len >= 16)
+		*phys_addr5 = (msg->msg[14] << 8) | msg->msg[15];
+}
+
+static __inline__ void cec_msg_cdc_hec_set_state_adjacent(struct cec_msg *msg,
+						      __u16 phys_addr1,
+						      __u8 hec_set_state)
+{
+	msg->len = 8;
+	msg->msg[0] |= 0xf; /* broadcast */
+	msg->msg[1] = CEC_MSG_CDC_MESSAGE;
+	/* msg[2] and msg[3] (phys_addr) are filled in by the CEC framework */
+	msg->msg[4] = CEC_MSG_CDC_HEC_SET_STATE_ADJACENT;
+	msg->msg[5] = phys_addr1 >> 8;
+	msg->msg[6] = phys_addr1 & 0xff;
+	msg->msg[7] = hec_set_state;
+}
+
+static __inline__ void cec_ops_cdc_hec_set_state_adjacent(const struct cec_msg *msg,
+						      __u16 *phys_addr,
+						      __u16 *phys_addr1,
+						      __u8 *hec_set_state)
+{
+	*phys_addr = (msg->msg[2] << 8) | msg->msg[3];
+	*phys_addr1 = (msg->msg[5] << 8) | msg->msg[6];
+	*hec_set_state = msg->msg[7];
+}
+
+static __inline__ void cec_msg_cdc_hec_request_deactivation(struct cec_msg *msg,
+							__u16 phys_addr1,
+							__u16 phys_addr2,
+							__u16 phys_addr3)
+{
+	msg->len = 11;
+	msg->msg[0] |= 0xf; /* broadcast */
+	msg->msg[1] = CEC_MSG_CDC_MESSAGE;
+	/* msg[2] and msg[3] (phys_addr) are filled in by the CEC framework */
+	msg->msg[4] = CEC_MSG_CDC_HEC_REQUEST_DEACTIVATION;
+	msg->msg[5] = phys_addr1 >> 8;
+	msg->msg[6] = phys_addr1 & 0xff;
+	msg->msg[7] = phys_addr2 >> 8;
+	msg->msg[8] = phys_addr2 & 0xff;
+	msg->msg[9] = phys_addr3 >> 8;
+	msg->msg[10] = phys_addr3 & 0xff;
+}
+
+static __inline__ void cec_ops_cdc_hec_request_deactivation(const struct cec_msg *msg,
+							__u16 *phys_addr,
+							__u16 *phys_addr1,
+							__u16 *phys_addr2,
+							__u16 *phys_addr3)
+{
+	*phys_addr = (msg->msg[2] << 8) | msg->msg[3];
+	*phys_addr1 = (msg->msg[5] << 8) | msg->msg[6];
+	*phys_addr2 = (msg->msg[7] << 8) | msg->msg[8];
+	*phys_addr3 = (msg->msg[9] << 8) | msg->msg[10];
+}
+
+static __inline__ void cec_msg_cdc_hec_notify_alive(struct cec_msg *msg)
+{
+	msg->len = 5;
+	msg->msg[0] |= 0xf; /* broadcast */
+	msg->msg[1] = CEC_MSG_CDC_MESSAGE;
+	/* msg[2] and msg[3] (phys_addr) are filled in by the CEC framework */
+	msg->msg[4] = CEC_MSG_CDC_HEC_NOTIFY_ALIVE;
+}
+
+static __inline__ void cec_ops_cdc_hec_notify_alive(const struct cec_msg *msg,
+						__u16 *phys_addr)
+{
+	*phys_addr = (msg->msg[2] << 8) | msg->msg[3];
+}
+
+static __inline__ void cec_msg_cdc_hec_discover(struct cec_msg *msg)
+{
+	msg->len = 5;
+	msg->msg[0] |= 0xf; /* broadcast */
+	msg->msg[1] = CEC_MSG_CDC_MESSAGE;
+	/* msg[2] and msg[3] (phys_addr) are filled in by the CEC framework */
+	msg->msg[4] = CEC_MSG_CDC_HEC_DISCOVER;
+}
+
+static __inline__ void cec_ops_cdc_hec_discover(const struct cec_msg *msg,
+					    __u16 *phys_addr)
+{
+	*phys_addr = (msg->msg[2] << 8) | msg->msg[3];
+}
+
+static __inline__ void cec_msg_cdc_hpd_set_state(struct cec_msg *msg,
+					     __u8 input_port,
+					     __u8 hpd_state)
+{
+	msg->len = 6;
+	msg->msg[0] |= 0xf; /* broadcast */
+	msg->msg[1] = CEC_MSG_CDC_MESSAGE;
+	/* msg[2] and msg[3] (phys_addr) are filled in by the CEC framework */
+	msg->msg[4] = CEC_MSG_CDC_HPD_SET_STATE;
+	msg->msg[5] = (input_port << 4) | hpd_state;
+}
+
+static __inline__ void cec_ops_cdc_hpd_set_state(const struct cec_msg *msg,
+					    __u16 *phys_addr,
+					    __u8 *input_port,
+					    __u8 *hpd_state)
+{
+	*phys_addr = (msg->msg[2] << 8) | msg->msg[3];
+	*input_port = msg->msg[5] >> 4;
+	*hpd_state = msg->msg[5] & 0xf;
+}
+
+static __inline__ void cec_msg_cdc_hpd_report_state(struct cec_msg *msg,
+						__u8 hpd_state,
+						__u8 hpd_error)
+{
+	msg->len = 6;
+	msg->msg[0] |= 0xf; /* broadcast */
+	msg->msg[1] = CEC_MSG_CDC_MESSAGE;
+	/* msg[2] and msg[3] (phys_addr) are filled in by the CEC framework */
+	msg->msg[4] = CEC_MSG_CDC_HPD_REPORT_STATE;
+	msg->msg[5] = (hpd_state << 4) | hpd_error;
+}
+
+static __inline__ void cec_ops_cdc_hpd_report_state(const struct cec_msg *msg,
+						__u16 *phys_addr,
+						__u8 *hpd_state,
+						__u8 *hpd_error)
+{
+	*phys_addr = (msg->msg[2] << 8) | msg->msg[3];
+	*hpd_state = msg->msg[5] >> 4;
+	*hpd_error = msg->msg[5] & 0xf;
+}
+
+#endif
diff --git a/include/linux/cec.h b/include/linux/cec.h
new file mode 100644
index 0000000..e02c21d
--- /dev/null
+++ b/include/linux/cec.h
@@ -0,0 +1,781 @@
+#ifndef _CEC_H
+#define _CEC_H
+
+#include <linux/types.h>
+
+struct cec_msg {
+	__u64 ts;
+	__u32 len;
+	__u32 status;
+	/*
+	 * timeout (in ms) is used to timeout CEC_RECEIVE.
+	 * Set to 0 if you want to wait forever.
+	 */
+	__u32 timeout;
+	/*
+	 * The framework assigns a sequence number to messages that are sent.
+	 * This can be used to track replies to previously sent messages.
+	 */
+	__u32 sequence;
+	__u8 msg[16];
+	/*
+	 * If non-zero, then wait for a reply with this opcode.
+	 * If there was an error when sending the msg or FeatureAbort
+	 * was returned, then reply is set to 0.
+	 * If reply is non-zero upon return, then len/msg are set to
+	 * the received message.
+	 * If reply is zero upon return and status has the
+	 * CEC_TX_STATUS_FEATURE_ABORT bit set, then len/msg are set to the
+	 * received feature abort message.
+	 * If reply is zero upon return and status has the
+	 * CEC_TX_STATUS_REPLY_TIMEOUT
+	 * bit set, then no reply was seen at all.
+	 * This field is ignored with CEC_RECEIVE.
+	 * If reply is non-zero for CEC_TRANSMIT and the message is a broadcast,
+	 * then -EINVAL is returned.
+	 * if reply is non-zero, then timeout is set to 1000 (the required
+	 * maximum response time).
+	 */
+	__u8 reply;
+	__u8 reserved[35];
+};
+
+static __inline__ __u8 cec_msg_initiator(const struct cec_msg *msg)
+{
+	return msg->msg[0] >> 4;
+}
+
+static __inline__ __u8 cec_msg_destination(const struct cec_msg *msg)
+{
+	return msg->msg[0] & 0xf;
+}
+
+static __inline__ bool cec_msg_is_broadcast(const struct cec_msg *msg)
+{
+	return (msg->msg[0] & 0xf) == 0xf;
+}
+
+static __inline__ void cec_msg_init(struct cec_msg *msg,
+				__u8 initiator, __u8 destination)
+{
+	memset(msg, 0, sizeof(*msg));
+	msg->msg[0] = (initiator << 4) | destination;
+	msg->len = 1;
+}
+
+/*
+ * Set the msg destination to the orig initiator and the msg initiator to the
+ * orig destination. Note that msg and orig may be the same pointer, in which
+ * case the change is done in place.
+ */
+static __inline__ void cec_msg_set_reply_to(struct cec_msg *msg, struct cec_msg *orig)
+{
+	/* The destination becomes the initiator and vice versa */
+	msg->msg[0] = (cec_msg_destination(orig) << 4) | cec_msg_initiator(orig);
+}
+
+/* cec status field */
+#define CEC_TX_STATUS_OK		(0)
+#define CEC_TX_STATUS_ARB_LOST		(1 << 0)
+#define CEC_TX_STATUS_RETRY_TIMEOUT	(1 << 1)
+#define CEC_TX_STATUS_FEATURE_ABORT	(1 << 2)
+#define CEC_TX_STATUS_REPLY_TIMEOUT	(1 << 3)
+#define CEC_RX_STATUS_READY		(0)
+
+#define CEC_LOG_ADDR_INVALID		0xff
+#define CEC_PHYS_ADDR_INVALID		0xffff
+
+/* The maximum number of logical addresses one device can be assigned to.
+ * The CEC 2.0 spec allows for only 2 logical addresses at the moment. The
+ * Analog Devices CEC hardware supports 3. So let's go wild and go for 4. */
+#define CEC_MAX_LOG_ADDRS 4
+
+/* The logical address types that the CEC device wants to claim */
+#define CEC_LOG_ADDR_TYPE_TV		0
+#define CEC_LOG_ADDR_TYPE_RECORD	1
+#define CEC_LOG_ADDR_TYPE_TUNER		2
+#define CEC_LOG_ADDR_TYPE_PLAYBACK	3
+#define CEC_LOG_ADDR_TYPE_AUDIOSYSTEM	4
+#define CEC_LOG_ADDR_TYPE_SPECIFIC	5
+#define CEC_LOG_ADDR_TYPE_UNREGISTERED	6
+/* Switches should use UNREGISTERED.
+ * Processors should use SPECIFIC. */
+
+/*
+ * Use this if there is no vendor ID (CEC_G_VENDOR_ID) or if the vendor ID
+ * should be disabled (CEC_S_VENDOR_ID)
+ */
+#define CEC_VENDOR_ID_NONE		0xffffffff
+
+/* The CEC adapter state */
+#define CEC_ADAP_DISABLED		0
+#define CEC_ADAP_ENABLED		1
+
+/* The passthrough mode state */
+#define CEC_PASSTHROUGH_DISABLED	0
+#define CEC_PASSTHROUGH_ENABLED		1
+
+/* The monitor state */
+#define CEC_MONITOR_DISABLED		0
+#define CEC_MONITOR_ENABLED		1
+
+/* Userspace has to configure the adapter state (enable/disable) */
+#define CEC_CAP_STATE		(1 << 0)
+/* Userspace has to configure the physical address */
+#define CEC_CAP_PHYS_ADDR	(1 << 1)
+/* Userspace has to configure the logical addresses */
+#define CEC_CAP_LOG_ADDRS	(1 << 2)
+/* Userspace can transmit and receive messages */
+#define CEC_CAP_IO		(1 << 3)
+/* Userspace has to configure the vendor id */
+#define CEC_CAP_VENDOR_ID	(1 << 4)
+/*
+ * Passthrough all messages instead of processing them.
+ * Note: ARC and CDC messages are always processed.
+ */
+#define CEC_CAP_PASSTHROUGH	(1 << 5)
+/* Supports remote control */
+#define CEC_CAP_RC		(1 << 6)
+/* Supports ARC */
+#define CEC_CAP_ARC		(1 << 7)
+/* Supports CDC HPD */
+#define CEC_CAP_CDC_HPD		(1 << 8)
+/* Is a source */
+#define CEC_CAP_IS_SOURCE	(1 << 9)
+
+struct cec_caps {
+	__u32 available_log_addrs;
+	__u32 capabilities;
+	__u8 ninputs;
+	__u8  reserved[39];
+};
+
+struct cec_log_addrs {
+	__u8 cec_version;
+	__u8 num_log_addrs;
+	__u8 primary_device_type[CEC_MAX_LOG_ADDRS];
+	__u8 log_addr_type[CEC_MAX_LOG_ADDRS];
+	__u8 log_addr[CEC_MAX_LOG_ADDRS];
+	char osd_name[15];
+
+	/* CEC 2.0 */
+	__u8 all_device_types[CEC_MAX_LOG_ADDRS];
+	__u8 features[CEC_MAX_LOG_ADDRS][12];
+
+	__u8 reserved[63];
+};
+
+/* Events */
+
+/* Event that occurs when the adapter state changes */
+#define CEC_EVENT_STATE_CHANGE	1
+/* Event that occurs when inputs are connected/disconnected */
+#define CEC_EVENT_INPUTS_CHANGE	2
+/* This event is sent when messages are lost because the application
+ * didn't empty the message queue in time */
+#define CEC_EVENT_LOST_MSGS	3
+
+#define CEC_EVENT_STATE_DISABLED	0
+#define CEC_EVENT_STATE_UNCONFIGURED	1
+#define CEC_EVENT_STATE_CONFIGURING	2
+#define CEC_EVENT_STATE_CONFIGURED	3
+
+struct cec_event_state_change {
+	/* current CEC adapter state */
+	__u8 state;
+};
+
+struct cec_event_inputs_change {
+	/* bit 0 == input port 0, bit 15 == input port 15 */
+	/* currently connected input ports */
+	__u16 connected_inputs;
+	/* input ports that changed state since last event */
+	__u16 changed_inputs;
+};
+
+struct cec_event {
+	__u64 ts;
+	__u32 event;
+	__u32 reserved[7];
+	union {
+		struct cec_event_state_change state_change;
+		struct cec_event_inputs_change inputs_change;
+		__u32 raw[16];
+	};
+};
+
+/* ioctls */
+
+/* Adapter capabilities */
+#define CEC_ADAP_G_CAPS		_IOWR('a',  0, struct cec_caps)
+
+/*
+   Configure the CEC adapter. It sets the device type and which
+   logical types it will try to claim. It will return which
+   logical addresses it could actually claim.
+   An error is returned if the adapter is disabled or if there
+   is no physical address assigned.
+ */
+
+#define CEC_ADAP_G_LOG_ADDRS	_IOR ('a',  1, struct cec_log_addrs)
+#define CEC_ADAP_S_LOG_ADDRS	_IOWR('a',  2, struct cec_log_addrs)
+
+/*
+   Enable/disable the adapter. The Set state ioctl may not
+   be available if that is handled internally.
+ */
+#define CEC_ADAP_G_STATE	_IOR ('a',  3, __u32)
+#define CEC_ADAP_S_STATE	_IOW ('a',  4, __u32)
+
+/*
+   phys_addr is either 0 (if this is the CEC root device)
+   or a valid physical address obtained from the sink's EDID
+   as read by this CEC device (if this is a source device)
+   or a physical address obtained and modified from a sink
+   EDID and used for a sink CEC device.
+   If nothing is connected, then phys_addr is 0xffff.
+   See HDMI 1.4b, section 8.7 (Physical Address).
+
+   The Set ioctl may not be available if that is handled
+   internally.
+ */
+#define CEC_ADAP_G_PHYS_ADDR	_IOR ('a',  5, __u16)
+#define CEC_ADAP_S_PHYS_ADDR	_IOW ('a',  6, __u16)
+
+/*
+   Read and set the vendor ID of the CEC adapter.
+ */
+#define CEC_ADAP_G_VENDOR_ID	_IOR ('a',  7, __u32)
+#define CEC_ADAP_S_VENDOR_ID	_IOW ('a',  8, __u32)
+
+/*
+   Read and set the monitor state of the filehandle.
+ */
+#define CEC_G_MONITOR		_IOR ('a',  9, __u32)
+#define CEC_S_MONITOR		_IOW ('a', 10, __u32)
+
+/*
+   Claim message handling and set passthrough mode,
+   release message handling and get passthrough mode for
+   this filehandle.
+ */
+#define CEC_CLAIM		_IOW ('a', 11, __u32)
+#define CEC_RELEASE		_IO  ('a', 12)
+#define CEC_G_PASSTHROUGH	_IOR ('a', 13, __u32)
+
+/* Transmit/receive a CEC command */
+#define CEC_TRANSMIT		_IOWR('a', 14, struct cec_msg)
+#define CEC_RECEIVE		_IOWR('a', 15, struct cec_msg)
+
+/* Dequeue CEC events */
+#define CEC_DQEVENT		_IOWR('a', 16, struct cec_event)
+
+/* Commands */
+
+/* One Touch Play Feature */
+#define CEC_MSG_ACTIVE_SOURCE				0x82
+#define CEC_MSG_IMAGE_VIEW_ON				0x04
+#define CEC_MSG_TEXT_VIEW_ON				0x0d
+
+
+/* Routing Control Feature */
+
+/*
+ * Has also:
+ *	CEC_MSG_ACTIVE_SOURCE
+ */
+
+#define CEC_MSG_INACTIVE_SOURCE				0x9d
+#define CEC_MSG_REQUEST_ACTIVE_SOURCE			0x85
+#define CEC_MSG_ROUTING_CHANGE				0x80
+#define CEC_MSG_ROUTING_INFORMATION			0x81
+#define CEC_MSG_SET_STREAM_PATH				0x86
+
+
+/* Standby Feature */
+#define CEC_MSG_STANDBY					0x36
+
+
+/* One Touch Record Feature */
+#define CEC_MSG_RECORD_OFF				0x0b
+#define CEC_MSG_RECORD_ON				0x09
+/* Record Source Type Operand (rec_src_type) */
+#define CEC_OP_RECORD_SRC_OWN				1
+#define CEC_OP_RECORD_SRC_DIGITAL			2
+#define CEC_OP_RECORD_SRC_ANALOG			3
+#define CEC_OP_RECORD_SRC_EXT_PLUG			4
+#define CEC_OP_RECORD_SRC_EXT_PHYS_ADDR			5
+/* Service Identification Method Operand (service_id_method) */
+#define CEC_OP_SERVICE_ID_METHOD_BY_DIG_ID		0
+#define CEC_OP_SERVICE_ID_METHOD_BY_CHANNEL		1
+/* Digital Service Broadcast System Operand (dig_bcast_system) */
+#define CEC_OP_DIG_SERVICE_BCAST_SYSTEM_ARIB_GEN	0x00
+#define CEC_OP_DIG_SERVICE_BCAST_SYSTEM_ATSC_GEN	0x01
+#define CEC_OP_DIG_SERVICE_BCAST_SYSTEM_DVB_GEN		0x02
+#define CEC_OP_DIG_SERVICE_BCAST_SYSTEM_ARIB_BS		0x08
+#define CEC_OP_DIG_SERVICE_BCAST_SYSTEM_ARIB_CS		0x09
+#define CEC_OP_DIG_SERVICE_BCAST_SYSTEM_ARIB_T		0x0a
+#define CEC_OP_DIG_SERVICE_BCAST_SYSTEM_ATSC_CABLE	0x10
+#define CEC_OP_DIG_SERVICE_BCAST_SYSTEM_ATSC_SAT	0x11
+#define CEC_OP_DIG_SERVICE_BCAST_SYSTEM_ATSC_T		0x12
+#define CEC_OP_DIG_SERVICE_BCAST_SYSTEM_DVB_C		0x18
+#define CEC_OP_DIG_SERVICE_BCAST_SYSTEM_DVB_S		0x19
+#define CEC_OP_DIG_SERVICE_BCAST_SYSTEM_DVB_S2		0x1a
+#define CEC_OP_DIG_SERVICE_BCAST_SYSTEM_DVB_T		0x1b
+/* Analogue Broadcast Type Operand (ana_bcast_type) */
+#define CEC_OP_ANA_BCAST_TYPE_CABLE			0
+#define CEC_OP_ANA_BCAST_TYPE_SATELLITE			1
+#define CEC_OP_ANA_BCAST_TYPE_TERRESTRIAL		2
+/* Broadcast System Operand (bcast_system) */
+#define CEC_OP_BCAST_SYSTEM_PAL_BG			0x00
+#define CEC_OP_BCAST_SYSTEM_SECAM_LQ			0x01 /* SECAM L' */
+#define CEC_OP_BCAST_SYSTEM_PAL_M			0x02
+#define CEC_OP_BCAST_SYSTEM_NTSC_M			0x03
+#define CEC_OP_BCAST_SYSTEM_PAL_I			0x04
+#define CEC_OP_BCAST_SYSTEM_SECAM_DK			0x05
+#define CEC_OP_BCAST_SYSTEM_SECAM_BG			0x06
+#define CEC_OP_BCAST_SYSTEM_SECAM_L			0x07
+#define CEC_OP_BCAST_SYSTEM_PAL_DK			0x08
+#define CEC_OP_BCAST_SYSTEM_OTHER			0x1f
+/* Channel Number Format Operand (channel_number_fmt) */
+#define CEC_OP_CHANNEL_NUMBER_FMT_1_PART		0x01
+#define CEC_OP_CHANNEL_NUMBER_FMT_2_PART		0x02
+
+#define CEC_MSG_RECORD_STATUS				0x0a
+/* Record Status Operand (rec_status) */
+#define CEC_OP_RECORD_STATUS_CUR_SRC			0x01
+#define CEC_OP_RECORD_STATUS_DIG_SERVICE		0x02
+#define CEC_OP_RECORD_STATUS_ANA_SERVICE		0x03
+#define CEC_OP_RECORD_STATUS_EXT_INPUT			0x04
+#define CEC_OP_RECORD_STATUS_NO_DIG_SERVICE		0x05
+#define CEC_OP_RECORD_STATUS_NO_ANA_SERVICE		0x06
+#define CEC_OP_RECORD_STATUS_NO_SERVICE			0x07
+#define CEC_OP_RECORD_STATUS_INVALID_EXT_PLUG		0x09
+#define CEC_OP_RECORD_STATUS_INVALID_EXT_PHYS_ADDR	0x0a
+#define CEC_OP_RECORD_STATUS_UNSUP_CA			0x0b
+#define CEC_OP_RECORD_STATUS_NO_CA_ENTITLEMENTS		0x0c
+#define CEC_OP_RECORD_STATUS_CANT_COPY_SRC		0x0d
+#define CEC_OP_RECORD_STATUS_NO_MORE_COPIES		0x0e
+#define CEC_OP_RECORD_STATUS_NO_MEDIA			0x10
+#define CEC_OP_RECORD_STATUS_PLAYING			0x11
+#define CEC_OP_RECORD_STATUS_ALREADY_RECORDING		0x12
+#define CEC_OP_RECORD_STATUS_MEDIA_PROT			0x13
+#define CEC_OP_RECORD_STATUS_NO_SIGNAL			0x14
+#define CEC_OP_RECORD_STATUS_MEDIA_PROBLEM		0x15
+#define CEC_OP_RECORD_STATUS_NO_SPACE			0x16
+#define CEC_OP_RECORD_STATUS_PARENTAL_LOCK		0x17
+#define CEC_OP_RECORD_STATUS_TERMINATED_OK		0x1a
+#define CEC_OP_RECORD_STATUS_ALREADY_TERM		0x1b
+#define CEC_OP_RECORD_STATUS_OTHER			0x1f
+
+#define CEC_MSG_RECORD_TV_SCREEN			0x0f
+
+
+/* Timer Programming Feature */
+#define CEC_MSG_CLEAR_ANALOGUE_TIMER			0x33
+/* Recording Sequence Operand (recording_seq) */
+#define CEC_OP_REC_SEQ_SUNDAY				0x01
+#define CEC_OP_REC_SEQ_MONDAY				0x02
+#define CEC_OP_REC_SEQ_TUESDAY				0x04
+#define CEC_OP_REC_SEQ_WEDNESDAY			0x08
+#define CEC_OP_REC_SEQ_THURSDAY				0x10
+#define CEC_OP_REC_SEQ_FRIDAY				0x20
+#define CEC_OP_REC_SEQ_SATERDAY				0x40
+#define CEC_OP_REC_SEQ_ONCE_ONLY			0x00
+
+#define CEC_MSG_CLEAR_DIGITAL_TIMER			0x99
+
+#define CEC_MSG_CLEAR_EXT_TIMER				0xa1
+/* External Source Specifier Operand (ext_src_spec) */
+#define CEC_OP_EXT_SRC_PLUG				0x04
+#define CEC_OP_EXT_SRC_PHYS_ADDR			0x05
+
+#define CEC_MSG_SET_ANALOGUE_TIMER			0x34
+#define CEC_MSG_SET_DIGITAL_TIMER			0x97
+#define CEC_MSG_SET_EXT_TIMER				0xa2
+
+#define CEC_MSG_SET_TIMER_PROGRAM_TITLE			0x67
+#define CEC_MSG_TIMER_CLEARED_STATUS			0x43
+/* Timer Cleared Status Data Operand (timer_cleared_status) */
+#define CEC_OP_TIMER_CLR_STAT_RECORDING			0x00
+#define CEC_OP_TIMER_CLR_STAT_NO_MATCHING		0x01
+#define CEC_OP_TIMER_CLR_STAT_NO_INFO			0x02
+#define CEC_OP_TIMER_CLR_STAT_CLEARED			0x80
+
+#define CEC_MSG_TIMER_STATUS				0x35
+/* Timer Overlap Warning Operand (timer_overlap_warning) */
+#define CEC_OP_TIMER_OVERLAP_WARNING_NO_OVERLAP		0
+#define CEC_OP_TIMER_OVERLAP_WARNING_OVERLAP		1
+/* Media Info Operand (media_info) */
+#define CEC_OP_MEDIA_INFO_UNPROT_MEDIA			0
+#define CEC_OP_MEDIA_INFO_PROT_MEDIA			1
+#define CEC_OP_MEDIA_INFO_NO_MEDIA			2
+/* Programmed Indicator Operand (prog_indicator) */
+#define CEC_OP_PROG_IND_NOT_PROGRAMMED			0
+#define CEC_OP_PROG_IND_PROGRAMMED			1
+/* Programmed Info Operand (prog_info) */
+#define CEC_OP_PROG_INFO_ENOUGH_SPACE			0x08
+#define CEC_OP_PROG_INFO_NOT_ENOUGH_SPACE		0x09
+#define CEC_OP_PROG_INFO_MIGHT_NOT_BE_ENOUGH_SPACE	0x0b
+#define CEC_OP_PROG_INFO_NONE_AVAILABLE			0x0a
+/* Not Programmed Error Info Operand (prog_error) */
+#define CEC_OP_PROG_ERROR_NO_FREE_TIMER			0x01
+#define CEC_OP_PROG_ERROR_DATE_OUT_OF_RANGE		0x02
+#define CEC_OP_PROG_ERROR_REC_SEQ_ERROR			0x03
+#define CEC_OP_PROG_ERROR_INV_EXT_PLUG			0x04
+#define CEC_OP_PROG_ERROR_INV_EXT_PHYS_ADDR		0x05
+#define CEC_OP_PROG_ERROR_CA_UNSUPP			0x06
+#define CEC_OP_PROG_ERROR_INSUF_CA_ENTITLEMENTS		0x07
+#define CEC_OP_PROG_ERROR_RESOLUTION_UNSUPP		0x08
+#define CEC_OP_PROG_ERROR_PARENTAL_LOCK			0x09
+#define CEC_OP_PROG_ERROR_CLOCK_FAILURE			0x0a
+#define CEC_OP_PROG_ERROR_DUPLICATE			0x0e
+
+
+/* System Information Feature */
+#define CEC_MSG_CEC_VERSION				0x9e
+/* CEC Version Operand (cec_version) */
+#define CEC_OP_CEC_VERSION_1_3A				4
+#define CEC_OP_CEC_VERSION_1_4				5
+#define CEC_OP_CEC_VERSION_2_0				6
+
+#define CEC_MSG_GET_CEC_VERSION				0x9f
+#define CEC_MSG_GIVE_PHYSICAL_ADDR			0x83
+#define CEC_MSG_GET_MENU_LANGUAGE			0x91
+#define CEC_MSG_REPORT_PHYSICAL_ADDR			0x84
+/* Primary Device Type Operand (prim_devtype) */
+#define CEC_OP_PRIM_DEVTYPE_TV				0
+#define CEC_OP_PRIM_DEVTYPE_RECORD			1
+#define CEC_OP_PRIM_DEVTYPE_TUNER			3
+#define CEC_OP_PRIM_DEVTYPE_PLAYBACK			4
+#define CEC_OP_PRIM_DEVTYPE_AUDIOSYSTEM			5
+#define CEC_OP_PRIM_DEVTYPE_SWITCH			6
+#define CEC_OP_PRIM_DEVTYPE_PROCESSOR			7
+
+#define CEC_MSG_SET_MENU_LANGUAGE			0x32
+#define CEC_MSG_REPORT_FEATURES				0xa6	/* HDMI 2.0 */
+/* All Device Types Operand (all_device_types) */
+#define CEC_OP_ALL_DEVTYPE_TV				0x80
+#define CEC_OP_ALL_DEVTYPE_RECORD			0x40
+#define CEC_OP_ALL_DEVTYPE_TUNER			0x20
+#define CEC_OP_ALL_DEVTYPE_PLAYBACK			0x10
+#define CEC_OP_ALL_DEVTYPE_AUDIOSYSTEM			0x08
+#define CEC_OP_ALL_DEVTYPE_SWITCH			0x04
+/* And if you wondering what happened to PROCESSOR devices: those should
+ * be mapped to a SWITCH. */
+
+/* Valid for RC Profile and Device Feature operands */
+#define CEC_OP_FEAT_EXT					0x80	/* Extension bit */
+/* RC Profile Operand (rc_profile) */
+#define CEC_OP_FEAT_RC_TV_PROFILE_NONE			0x00
+#define CEC_OP_FEAT_RC_TV_PROFILE_1			0x02
+#define CEC_OP_FEAT_RC_TV_PROFILE_2			0x06
+#define CEC_OP_FEAT_RC_TV_PROFILE_3			0x0a
+#define CEC_OP_FEAT_RC_TV_PROFILE_4			0x0e
+#define CEC_OP_FEAT_RC_SRC_HAS_DEV_ROOT_MENU		0x50
+#define CEC_OP_FEAT_RC_SRC_HAS_DEV_SETUP_MENU		0x48
+#define CEC_OP_FEAT_RC_SRC_HAS_CONTENTS_MENU		0x44
+#define CEC_OP_FEAT_RC_SRC_HAS_MEDIA_TOP_MENU		0x42
+#define CEC_OP_FEAT_RC_SRC_HAS_MEDIA_CONTEXT_MENU	0x41
+/* Device Feature Operand (dev_features) */
+#define CEC_OP_FEAT_DEV_HAS_RECORD_TV_SCREEN		0x40
+#define CEC_OP_FEAT_DEV_HAS_SET_OSD_STRING		0x20
+#define CEC_OP_FEAT_DEV_HAS_DECK_CONTROL		0x10
+#define CEC_OP_FEAT_DEV_HAS_SET_AUDIO_RATE		0x08
+#define CEC_OP_FEAT_DEV_SINK_HAS_ARC_TX			0x04
+#define CEC_OP_FEAT_DEV_SOURCE_HAS_ARC_RX		0x02
+
+#define CEC_MSG_GIVE_FEATURES				0xa5	/* HDMI 2.0 */
+
+
+/* Deck Control Feature */
+#define CEC_MSG_DECK_CONTROL				0x42
+/* Deck Control Mode Operand (deck_control_mode) */
+#define CEC_OP_DECK_CTL_MODE_SKIP_FWD			1
+#define CEC_OP_DECK_CTL_MODE_SKIP_REV			2
+#define CEC_OP_DECK_CTL_MODE_STOP			3
+#define CEC_OP_DECK_CTL_MODE_EJECT			4
+
+#define CEC_MSG_DECK_STATUS				0x1b
+/* Deck Info Operand (deck_info) */
+#define CEC_OP_DECK_INFO_PLAY				0x11
+#define CEC_OP_DECK_INFO_RECORD				0x12
+#define CEC_OP_DECK_INFO_PLAY_REV			0x13
+#define CEC_OP_DECK_INFO_STILL				0x14
+#define CEC_OP_DECK_INFO_SLOW				0x15
+#define CEC_OP_DECK_INFO_SLOW_REV			0x16
+#define CEC_OP_DECK_INFO_FAST_FWD			0x17
+#define CEC_OP_DECK_INFO_FAST_REV			0x18
+#define CEC_OP_DECK_INFO_NO_MEDIA			0x19
+#define CEC_OP_DECK_INFO_STOP				0x1a
+#define CEC_OP_DECK_INFO_SKIP_FWD			0x1b
+#define CEC_OP_DECK_INFO_SKIP_REV			0x1c
+#define CEC_OP_DECK_INFO_INDEX_SEARCH_FWD		0x1d
+#define CEC_OP_DECK_INFO_INDEX_SEARCH_REV		0x1e
+#define CEC_OP_DECK_INFO_OTHER				0x1f
+
+#define CEC_MSG_GIVE_DECK_STATUS			0x1a
+/* Status Request Operand (status_req) */
+#define CEC_OP_STATUS_REQ_ON				1
+#define CEC_OP_STATUS_REQ_OFF				2
+#define CEC_OP_STATUS_REQ_ONCE				3
+
+#define CEC_MSG_PLAY					0x41
+/* Play Mode Operand (play_mode) */
+#define CEC_OP_PLAY_MODE_PLAY_FWD			0x24
+#define CEC_OP_PLAY_MODE_PLAY_REV			0x20
+#define CEC_OP_PLAY_MODE_PLAY_STILL			0x25
+#define CEC_OP_PLAY_MODE_PLAY_FAST_FWD_MIN		0x05
+#define CEC_OP_PLAY_MODE_PLAY_FAST_FWD_MED		0x06
+#define CEC_OP_PLAY_MODE_PLAY_FAST_FWD_MAX		0x07
+#define CEC_OP_PLAY_MODE_PLAY_FAST_REV_MIN		0x09
+#define CEC_OP_PLAY_MODE_PLAY_FAST_REV_MED		0x0a
+#define CEC_OP_PLAY_MODE_PLAY_FAST_REV_MAX		0x0b
+#define CEC_OP_PLAY_MODE_PLAY_SLOW_FWD_MIN		0x15
+#define CEC_OP_PLAY_MODE_PLAY_SLOW_FWD_MED		0x16
+#define CEC_OP_PLAY_MODE_PLAY_SLOW_FWD_MAX		0x17
+#define CEC_OP_PLAY_MODE_PLAY_SLOW_REV_MIN		0x19
+#define CEC_OP_PLAY_MODE_PLAY_SLOW_REV_MED		0x1a
+#define CEC_OP_PLAY_MODE_PLAY_SLOW_REV_MAX		0x1b
+
+
+/* Tuner Control Feature */
+#define CEC_MSG_GIVE_TUNER_DEVICE_STATUS		0x08
+#define CEC_MSG_SELECT_ANALOGUE_SERVICE			0x92
+#define CEC_MSG_SELECT_DIGITAL_SERVICE			0x93
+#define CEC_MSG_TUNER_DEVICE_STATUS			0x07
+/* Recording Flag Operand (rec_flag) */
+#define CEC_OP_REC_FLAG_USED				0
+#define CEC_OP_REC_FLAG_NOT_USED			1
+/* Tuner Display Info Operand (tuner_display_info) */
+#define CEC_OP_TUNER_DISPLAY_INFO_DIGITAL		0
+#define CEC_OP_TUNER_DISPLAY_INFO_NONE			1
+#define CEC_OP_TUNER_DISPLAY_INFO_ANALOGUE		2
+
+#define CEC_MSG_TUNER_STEP_DECREMENT			0x06
+#define CEC_MSG_TUNER_STEP_INCREMENT			0x05
+
+
+/* Vendor Specific Commands Feature */
+
+/*
+ * Has also:
+ *	CEC_MSG_CEC_VERSION
+ *	CEC_MSG_GET_CEC_VERSION
+ */
+#define CEC_MSG_DEVICE_VENDOR_ID			0x87
+#define CEC_MSG_GIVE_DEVICE_VENDOR_ID			0x8c
+#define CEC_MSG_VENDOR_COMMAND				0x89
+#define CEC_MSG_VENDOR_COMMAND_WITH_ID			0xa0
+#define CEC_MSG_VENDOR_REMOTE_BUTTON_DOWN		0x8a
+#define CEC_MSG_VENDOR_REMOTE_BUTTON_UP			0x8b
+
+
+/* OSD Display Feature */
+#define CEC_MSG_SET_OSD_STRING				0x64
+/* Display Control Operand (disp_ctl) */
+#define CEC_OP_DISP_CTL_DEFAULT				0x00
+#define CEC_OP_DISP_CTL_UNTIL_CLEARED			0x40
+#define CEC_OP_DISP_CTL_CLEAR				0x80
+
+
+/* Device OSD Transfer Feature */
+#define CEC_MSG_GIVE_OSD_NAME				0x46
+#define CEC_MSG_SET_OSD_NAME				0x47
+
+
+/* Device Menu Control Feature */
+#define CEC_MSG_MENU_REQUEST				0x8d
+/* Menu Request Type Operand (menu_req) */
+#define CEC_OP_MENU_REQUEST_ACTIVATE			0x00
+#define CEC_OP_MENU_REQUEST_DEACTIVATE			0x01
+#define CEC_OP_MENU_REQUEST_QUERY			0x02
+
+#define CEC_MSG_MENU_STATUS				0x8e
+/* Menu State Operand (menu_state) */
+#define CEC_OP_MENU_STATE_ACTIVATED			0x00
+#define CEC_OP_MENU_STATE_DEACTIVATED			0x01
+
+#define CEC_MSG_USER_CONTROL_PRESSED			0x44
+/* UI Broadcast Type Operand (ui_bcast_type) */
+#define CEC_OP_UI_BCAST_TYPE_TOGGLE_ALL			0x00
+#define CEC_OP_UI_BCAST_TYPE_TOGGLE_DIG_ANA		0x01
+#define CEC_OP_UI_BCAST_TYPE_ANALOGUE			0x10
+#define CEC_OP_UI_BCAST_TYPE_ANALOGUE_T			0x20
+#define CEC_OP_UI_BCAST_TYPE_ANALOGUE_CABLE		0x30
+#define CEC_OP_UI_BCAST_TYPE_ANALOGUE_SAT		0x40
+#define CEC_OP_UI_BCAST_TYPE_DIGITAL			0x50
+#define CEC_OP_UI_BCAST_TYPE_DIGITAL_T			0x60
+#define CEC_OP_UI_BCAST_TYPE_DIGITAL_CABLE		0x70
+#define CEC_OP_UI_BCAST_TYPE_DIGITAL_SAT		0x80
+#define CEC_OP_UI_BCAST_TYPE_DIGITAL_COM_SAT		0x90
+#define CEC_OP_UI_BCAST_TYPE_DIGITAL_COM_SAT2		0x91
+#define CEC_OP_UI_BCAST_TYPE_IP				0xa0
+/* UI Sound Presentation Control Operand (ui_snd_pres_ctl) */
+#define CEC_OP_UI_SND_PRES_CTL_DUAL_MONO		0x10
+#define CEC_OP_UI_SND_PRES_CTL_KARAOKE			0x20
+#define CEC_OP_UI_SND_PRES_CTL_DOWNMIX			0x80
+#define CEC_OP_UI_SND_PRES_CTL_REVERB			0x90
+#define CEC_OP_UI_SND_PRES_CTL_EQUALIZER		0xa0
+#define CEC_OP_UI_SND_PRES_CTL_BASS_UP			0xb1
+#define CEC_OP_UI_SND_PRES_CTL_BASS_NEUTRAL		0xb2
+#define CEC_OP_UI_SND_PRES_CTL_BASS_DOWN		0xb3
+#define CEC_OP_UI_SND_PRES_CTL_TREBLE_UP		0xc1
+#define CEC_OP_UI_SND_PRES_CTL_TREBLE_NEUTRAL		0xc2
+#define CEC_OP_UI_SND_PRES_CTL_TREBLE_DOWN		0xc3
+
+#define CEC_MSG_USER_CONTROL_RELEASED			0x45
+
+
+/* Remote Control Passthrough Feature */
+
+/*
+ * Has also:
+ *	CEC_MSG_USER_CONTROL_PRESSED
+ *	CEC_MSG_USER_CONTROL_RELEASED
+ */
+
+
+/* Power Status Feature */
+#define CEC_MSG_GIVE_DEVICE_POWER_STATUS		0x8f
+#define CEC_MSG_REPORT_POWER_STATUS			0x90
+/* Power Status Operand (pwr_state) */
+#define CEC_OP_POWER_STATUS_ON				0
+#define CEC_OP_POWER_STATUS_STANDBY			1
+#define CEC_OP_POWER_STATUS_TO_ON			2
+#define CEC_OP_POWER_STATUS_TO_STANDBY			3
+
+
+/* General Protocol Messages */
+#define CEC_MSG_FEATURE_ABORT				0x00
+/* Abort Reason Operand (reason) */
+#define CEC_OP_ABORT_UNRECOGNIZED_OP			0
+#define CEC_OP_ABORT_INCORRECT_MODE			1
+#define CEC_OP_ABORT_NO_SOURCE				2
+#define CEC_OP_ABORT_INVALID_OP				3
+#define CEC_OP_ABORT_REFUSED				4
+#define CEC_OP_ABORT_UNDETERMINED			5
+
+#define CEC_MSG_ABORT					0xff
+
+
+/* System Audio Control Feature */
+
+/*
+ * Has also:
+ *	CEC_MSG_USER_CONTROL_PRESSED
+ *	CEC_MSG_USER_CONTROL_RELEASED
+ */
+#define CEC_MSG_GIVE_AUDIO_STATUS			0x71
+#define CEC_MSG_GIVE_SYSTEM_AUDIO_MODE_STATUS		0x7d
+#define CEC_MSG_REPORT_AUDIO_STATUS			0x7a
+/* Audio Mute Status Operand (aud_mute_status) */
+#define CEC_OP_AUD_MUTE_STATUS_OFF			0
+#define CEC_OP_AUD_MUTE_STATUS_ON			1
+
+#define CEC_MSG_REPORT_SHORT_AUDIO_DESCRIPTOR		0xa3
+#define CEC_MSG_REQUEST_SHORT_AUDIO_DESCRIPTOR		0xa4
+#define CEC_MSG_SET_SYSTEM_AUDIO_MODE			0x72
+/* System Audio Status Operand (sys_aud_status) */
+#define CEC_OP_SYS_AUD_STATUS_OFF			0
+#define CEC_OP_SYS_AUD_STATUS_ON			1
+
+#define CEC_MSG_SYSTEM_AUDIO_MODE_REQUEST		0x70
+#define CEC_MSG_SYSTEM_AUDIO_MODE_STATUS		0x7e
+/* Audio Format ID Operand (audio_format_id) */
+#define CEC_OP_AUD_FMT_ID_CEA861			0
+#define CEC_OP_AUD_FMT_ID_CEA861_CXT			1
+
+
+/* Audio Rate Control Feature */
+#define CEC_MSG_SET_AUDIO_RATE				0x9a
+/* Audio Rate Operand (audio_rate) */
+#define CEC_OP_AUD_RATE_OFF				0
+#define CEC_OP_AUD_RATE_WIDE_STD			1
+#define CEC_OP_AUD_RATE_WIDE_FAST			2
+#define CEC_OP_AUD_RATE_WIDE_SLOW			3
+#define CEC_OP_AUD_RATE_NARROW_STD			4
+#define CEC_OP_AUD_RATE_NARROW_FAST			5
+#define CEC_OP_AUD_RATE_NARROW_SLOW			6
+
+
+/* Audio Return Channel Control Feature */
+#define CEC_MSG_INITIATE_ARC				0xc0
+#define CEC_MSG_REPORT_ARC_INITIATED			0xc1
+#define CEC_MSG_REPORT_ARC_TERMINATED			0xc2
+#define CEC_MSG_REQUEST_ARC_INITIATION			0xc3
+#define CEC_MSG_REQUEST_ARC_TERMINATION			0xc4
+#define CEC_MSG_TERMINATE_ARC				0xc5
+
+
+/* Dynamic Audio Lipsync Feature */
+/* Only for CEC 2.0 and up */
+#define CEC_MSG_REQUEST_CURRENT_LATENCY			0xa7
+#define CEC_MSG_REPORT_CURRENT_LATENCY			0xa8
+/* Low Latency Mode Operand (low_latency_mode) */
+#define CEC_OP_LOW_LATENCY_MODE_OFF			0
+#define CEC_OP_LOW_LATENCY_MODE_ON			1
+/* Audio Output Compensated Operand (audio_out_compensated) */
+#define CEC_OP_AUD_OUT_COMPENSATED_NA			0
+#define CEC_OP_AUD_OUT_COMPENSATED_DELAY		1
+#define CEC_OP_AUD_OUT_COMPENSATED_NO_DELAY		2
+#define CEC_OP_AUD_OUT_COMPENSATED_PARTIAL_DELAY	3
+
+
+/* Capability Discovery and Control Feature */
+#define CEC_MSG_CDC_MESSAGE				0xf8
+/* Ethernet-over-HDMI: nobody ever does this... */
+#define CEC_MSG_CDC_HEC_INQUIRE_STATE			0x00
+#define CEC_MSG_CDC_HEC_REPORT_STATE			0x01
+/* HEC Functionality State Operand (hec_func_state) */
+#define CEC_OP_HEC_FUNC_STATE_NOT_SUPPORTED		0
+#define CEC_OP_HEC_FUNC_STATE_INACTIVE			1
+#define CEC_OP_HEC_FUNC_STATE_ACTIVE			2
+#define CEC_OP_HEC_FUNC_STATE_ACTIVATION_FIELD		3
+/* Host Functionality State Operand (host_func_state) */
+#define CEC_OP_HOST_FUNC_STATE_NOT_SUPPORTED		0
+#define CEC_OP_HOST_FUNC_STATE_INACTIVE			1
+#define CEC_OP_HOST_FUNC_STATE_ACTIVE			2
+/* ENC Functionality State Operand (enc_func_state) */
+#define CEC_OP_ENC_FUNC_STATE_EXT_CON_NOT_SUPPORTED	0
+#define CEC_OP_ENC_FUNC_STATE_EXT_CON_INACTIVE		1
+#define CEC_OP_ENC_FUNC_STATE_EXT_CON_ACTIVE		2
+/* CDC Error Code Operand (cdc_errcode) */
+#define CEC_OP_CDC_ERROR_CODE_NONE			0
+#define CEC_OP_CDC_ERROR_CODE_CAP_UNSUPPORTED		1
+#define CEC_OP_CDC_ERROR_CODE_WRONG_STATE		2
+#define CEC_OP_CDC_ERROR_CODE_OTHER			3
+/* HEC Support Operand (hec_support) */
+#define CEC_OP_HEC_SUPPORT_NO				0
+#define CEC_OP_HEC_SUPPORT_YES				1
+/* HEC Activation Operand (hec_activation) */
+#define CEC_OP_HEC_ACTIVATION_ON			0
+#define CEC_OP_HEC_ACTIVATION_OFF			1
+
+#define CEC_MSG_CDC_HEC_SET_STATE_ADJACENT		0x02
+#define CEC_MSG_CDC_HEC_SET_STATE			0x03
+/* HEC Set State Operand (hec_set_state) */
+#define CEC_OP_HEC_SET_STATE_DEACTIVATE			0
+#define CEC_OP_HEC_SET_STATE_ACTIVATE			1
+
+#define CEC_MSG_CDC_HEC_REQUEST_DEACTIVATION		0x04
+#define CEC_MSG_CDC_HEC_NOTIFY_ALIVE			0x05
+#define CEC_MSG_CDC_HEC_DISCOVER			0x06
+/* Hotplug Detect messages */
+#define CEC_MSG_CDC_HPD_SET_STATE			0x10
+/* HPD State Operand (hpd_state) */
+#define CEC_OP_HPD_STATE_CP_EDID_DISABLE		0
+#define CEC_OP_HPD_STATE_CP_EDID_ENABLE			1
+#define CEC_OP_HPD_STATE_CP_EDID_DISABLE_ENABLE		2
+#define CEC_OP_HPD_STATE_EDID_DISABLE			3
+#define CEC_OP_HPD_STATE_EDID_ENABLE			4
+#define CEC_OP_HPD_STATE_EDID_DISABLE_ENABLE		5
+#define CEC_MSG_CDC_HPD_REPORT_STATE			0x11
+/* HPD Error Code Operand (hpd_error) */
+#define CEC_OP_HPD_ERROR_NONE				0
+#define CEC_OP_HPD_ERROR_INITIATOR_NOT_CAPABLE		1
+#define CEC_OP_HPD_ERROR_INITIATOR_WRONG_STATE		2
+#define CEC_OP_HPD_ERROR_OTHER				3
+#define CEC_OP_HPD_ERROR_NONE_NO_VIDEO			4
+
+#endif
diff --git a/include/linux/v4l2-controls.h b/include/linux/v4l2-controls.h
index 9f6e108..d448c53 100644
--- a/include/linux/v4l2-controls.h
+++ b/include/linux/v4l2-controls.h
@@ -174,6 +174,10 @@ enum v4l2_colorfx {
  * We reserve 16 controls for this driver. */
 #define V4L2_CID_USER_ADV7180_BASE		(V4L2_CID_USER_BASE + 0x1070)
 
+/* The base for the tc358743 driver controls.
+ * We reserve 16 controls for this driver. */
+#define V4L2_CID_USER_TC358743_BASE		(V4L2_CID_USER_BASE + 0x1080)
+
 /* MPEG-class control IDs */
 /* The MPEG controls are applicable to all codec controls
  * and the 'MPEG' part of the define is historical */
diff --git a/utils/keytable/parse.h b/utils/keytable/parse.h
index 6ada6e5..67eb1a6 100644
--- a/utils/keytable/parse.h
+++ b/utils/keytable/parse.h
@@ -518,6 +518,24 @@ struct parse_event key_events[] = {
 	{"KEY_KBDINPUTASSIST_NEXTGROUP", 0x263},
 	{"KEY_KBDINPUTASSIST_ACCEPT", 0x264},
 	{"KEY_KBDINPUTASSIST_CANCEL", 0x265},
+	{"KEY_RIGHT_UP", 0x266},
+	{"KEY_RIGHT_DOWN", 0x267},
+	{"KEY_LEFT_UP", 0x268},
+	{"KEY_LEFT_DOWN", 0x269},
+	{"KEY_ROOT_MENU", 0x26a},
+	{"KEY_MEDIA_TOP_MENU", 0x26b},
+	{"KEY_NUMERIC_11", 0x26c},
+	{"KEY_NUMERIC_12", 0x26d},
+	{"KEY_AUDIO_DESC", 0x26e},
+	{"KEY_3D_MODE", 0x26f},
+	{"KEY_NEXT_FAVORITE", 0x270},
+	{"KEY_STOP_RECORD", 0x271},
+	{"KEY_PAUSE_RECORD", 0x272},
+	{"KEY_VOD", 0x273},
+	{"KEY_UNMUTE", 0x274},
+	{"KEY_FASTREVERSE", 0x275},
+	{"KEY_SLOWREVERSE", 0x276},
+	{"KEY_DATA", 0x275},
 	{"BTN_TRIGGER_HAPPY", 0x2c0},
 	{"BTN_TRIGGER_HAPPY1", 0x2c0},
 	{"BTN_TRIGGER_HAPPY2", 0x2c1},
diff --git a/utils/keytable/rc_keymaps/lme2510 b/utils/keytable/rc_keymaps/lme2510
index 6d7b18e..1da95f8 100644
--- a/utils/keytable/rc_keymaps/lme2510
+++ b/utils/keytable/rc_keymaps/lme2510
@@ -1,67 +1,67 @@
 # table lme2510, type: NEC
-0x10ed45 KEY_0
-0x10ed5f KEY_1
-0x10ed50 KEY_2
-0x10ed5d KEY_3
-0x10ed41 KEY_4
-0x10ed0a KEY_5
-0x10ed42 KEY_6
-0x10ed47 KEY_7
-0x10ed49 KEY_8
-0x10ed05 KEY_9
-0x10ed43 KEY_POWER
-0x10ed46 KEY_SUBTITLE
-0x10ed06 KEY_PAUSE
-0x10ed03 KEY_MEDIA_REPEAT
-0x10ed02 KEY_PAUSE
-0x10ed5e KEY_VOLUMEUP
-0x10ed5c KEY_VOLUMEDOWN
-0x10ed09 KEY_CHANNELUP
-0x10ed1a KEY_CHANNELDOWN
-0x10ed1e KEY_PLAY
-0x10ed1b KEY_ZOOM
-0x10ed59 KEY_MUTE
-0x10ed5a KEY_TV
-0x10ed18 KEY_RECORD
-0x10ed07 KEY_EPG
-0x10ed01 KEY_STOP
-0xbf15 KEY_0
-0xbf08 KEY_1
-0xbf09 KEY_2
-0xbf0a KEY_3
-0xbf0c KEY_4
-0xbf0d KEY_5
-0xbf0e KEY_6
-0xbf10 KEY_7
-0xbf11 KEY_8
-0xbf12 KEY_9
-0xbf00 KEY_POWER
-0xbf04 KEY_MEDIA_REPEAT
-0xbf1a KEY_PAUSE
-0xbf02 KEY_VOLUMEUP
-0xbf06 KEY_VOLUMEDOWN
-0xbf01 KEY_CHANNELUP
-0xbf05 KEY_CHANNELDOWN
-0xbf14 KEY_ZOOM
-0xbf18 KEY_RECORD
-0xbf16 KEY_STOP
-0x1c KEY_0
-0x07 KEY_1
-0x15 KEY_2
-0x09 KEY_3
-0x16 KEY_4
-0x19 KEY_5
-0x0d KEY_6
-0x0c KEY_7
-0x18 KEY_8
-0x5e KEY_9
-0x45 KEY_POWER
-0x44 KEY_MEDIA_REPEAT
-0x4a KEY_PAUSE
-0x47 KEY_VOLUMEUP
-0x43 KEY_VOLUMEDOWN
-0x46 KEY_CHANNELUP
-0x40 KEY_CHANNELDOWN
-0x08 KEY_ZOOM
-0x42 KEY_RECORD
-0x5a KEY_STOP
+0xef12ba45 KEY_0
+0xef12a05f KEY_1
+0xef12af50 KEY_2
+0xef12a25d KEY_3
+0xef12be41 KEY_4
+0xef12f50a KEY_5
+0xef12bd42 KEY_6
+0xef12b847 KEY_7
+0xef12b649 KEY_8
+0xef12fa05 KEY_9
+0xef12bc43 KEY_POWER
+0xef12b946 KEY_SUBTITLE
+0xef12f906 KEY_PAUSE
+0xef12fc03 KEY_MEDIA_REPEAT
+0xef12fd02 KEY_PAUSE
+0xef12a15e KEY_VOLUMEUP
+0xef12a35c KEY_VOLUMEDOWN
+0xef12f609 KEY_CHANNELUP
+0xef12e51a KEY_CHANNELDOWN
+0xef12e11e KEY_PLAY
+0xef12e41b KEY_ZOOM
+0xef12a659 KEY_MUTE
+0xef12a55a KEY_TV
+0xef12e718 KEY_RECORD
+0xef12f807 KEY_EPG
+0xef12fe01 KEY_STOP
+0xff40ea15 KEY_0
+0xff40f708 KEY_1
+0xff40f609 KEY_2
+0xff40f50a KEY_3
+0xff40f30c KEY_4
+0xff40f20d KEY_5
+0xff40f10e KEY_6
+0xff40ef10 KEY_7
+0xff40ee11 KEY_8
+0xff40ed12 KEY_9
+0xff40ff00 KEY_POWER
+0xff40fb04 KEY_MEDIA_REPEAT
+0xff40e51a KEY_PAUSE
+0xff40fd02 KEY_VOLUMEUP
+0xff40f906 KEY_VOLUMEDOWN
+0xff40fe01 KEY_CHANNELUP
+0xff40fa05 KEY_CHANNELDOWN
+0xff40eb14 KEY_ZOOM
+0xff40e718 KEY_RECORD
+0xff40e916 KEY_STOP
+0xff00e31c KEY_0
+0xff00f807 KEY_1
+0xff00ea15 KEY_2
+0xff00f609 KEY_3
+0xff00e916 KEY_4
+0xff00e619 KEY_5
+0xff00f20d KEY_6
+0xff00f30c KEY_7
+0xff00e718 KEY_8
+0xff00a15e KEY_9
+0xff00ba45 KEY_POWER
+0xff00bb44 KEY_MEDIA_REPEAT
+0xff00b54a KEY_PAUSE
+0xff00b847 KEY_VOLUMEUP
+0xff00bc43 KEY_VOLUMEDOWN
+0xff00b946 KEY_CHANNELUP
+0xff00bf40 KEY_CHANNELDOWN
+0xff00f708 KEY_ZOOM
+0xff00bd42 KEY_RECORD
+0xff00a55a KEY_STOP
diff --git a/utils/keytable/rc_maps.cfg b/utils/keytable/rc_maps.cfg
index e69fd6a..3bd7197 100644
--- a/utils/keytable/rc_maps.cfg
+++ b/utils/keytable/rc_maps.cfg
@@ -50,6 +50,7 @@
 *	rc-behold-columbus       behold_columbus
 *	rc-behold                behold
 *	rc-budget-ci-old         budget_ci_old
+*	rc-cec                   cec
 *	rc-cinergy-1400          cinergy_1400
 *	rc-cinergy               cinergy
 *	rc-delock-61959          delock_61959
-- 
2.1.4

