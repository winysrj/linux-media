Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-3.cisco.com ([173.38.203.53]:59070 "EHLO
	aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbbHRIjL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Aug 2015 04:39:11 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, m.szyprowski@samsung.com,
	linux-input@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	lars@opdenkamp.eu, kamil@wypas.org, linux@arm.linux.org.uk,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 4/4] cec-ctl: CEC control utility
Date: Tue, 18 Aug 2015 10:36:38 +0200
Message-Id: <03572635a9c679b9c84fb75bcc482a2e0c2dc513.1439886496.git.hans.verkuil@cisco.com>
In-Reply-To: <cover.1439886496.git.hans.verkuil@cisco.com>
References: <cover.1439886496.git.hans.verkuil@cisco.com>
In-Reply-To: <cover.1439886496.git.hans.verkuil@cisco.com>
References: <cover.1439886496.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Generic CEC utility that can be used to send/receive/monitor CEC
messages.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 configure.ac              |    1 +
 utils/Makefile.am         |    1 +
 utils/cec-ctl/Makefile.am |    8 +
 utils/cec-ctl/cec-ctl.cpp | 1296 +++++++++++++++++++++++++++++++++++++++++++++
 utils/cec-ctl/msg2ctl.pl  |  430 +++++++++++++++
 5 files changed, 1736 insertions(+)
 create mode 100644 utils/cec-ctl/Makefile.am
 create mode 100644 utils/cec-ctl/cec-ctl.cpp
 create mode 100644 utils/cec-ctl/msg2ctl.pl

diff --git a/configure.ac b/configure.ac
index 12c2eb9..72d59bd 100644
--- a/configure.ac
+++ b/configure.ac
@@ -27,6 +27,7 @@ AC_CONFIG_FILES([Makefile
 	utils/media-ctl/Makefile
 	utils/rds/Makefile
 	utils/cec-compliance/Makefile
+	utils/cec-ctl/Makefile
 	utils/v4l2-compliance/Makefile
 	utils/v4l2-ctl/Makefile
 	utils/v4l2-dbg/Makefile
diff --git a/utils/Makefile.am b/utils/Makefile.am
index c78e97b..617abf1 100644
--- a/utils/Makefile.am
+++ b/utils/Makefile.am
@@ -6,6 +6,7 @@ SUBDIRS = \
 	keytable \
 	media-ctl \
 	cec-compliance \
+	cec-ctl \
 	v4l2-compliance \
 	v4l2-ctl \
 	v4l2-dbg \
diff --git a/utils/cec-ctl/Makefile.am b/utils/cec-ctl/Makefile.am
new file mode 100644
index 0000000..378d7db
--- /dev/null
+++ b/utils/cec-ctl/Makefile.am
@@ -0,0 +1,8 @@
+bin_PROGRAMS = cec-ctl
+
+cec_ctl_SOURCES = cec-ctl.cpp
+
+cec-ctl.cpp: cec-ctl-gen.h
+
+cec-ctl-gen.h: msg2ctl.pl ../../include/linux/cec.h ../../include/linux/cec-funcs.h
+	msg2ctl.pl ../../include/linux/cec.h ../../include/linux/cec-funcs.h >cec-ctl-gen.h
diff --git a/utils/cec-ctl/cec-ctl.cpp b/utils/cec-ctl/cec-ctl.cpp
new file mode 100644
index 0000000..6a1edb5
--- /dev/null
+++ b/utils/cec-ctl/cec-ctl.cpp
@@ -0,0 +1,1296 @@
+/*
+    Copyright 2015 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
+    Author: Hans Verkuil <hans.verkuil@cisco.com>
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; either version 2 of the License, or
+    (at your option) any later version.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+    GNU General Public License for more details.
+ */
+
+#include <unistd.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <string.h>
+#include <inttypes.h>
+#include <getopt.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <ctype.h>
+#include <errno.h>
+#include <sys/ioctl.h>
+#include <stdarg.h>
+#include <cerrno>
+#include <string>
+#include <vector>
+#include <linux/cec-funcs.h>
+#include <config.h>
+
+#define CEC_MAX_ARGS 16
+
+#define xstr(s) str(s)
+#define str(s) #s
+
+struct cec_enum_values {
+	const char *type_name;
+	__u8 value;
+};
+
+enum cec_types {
+	CEC_TYPE_U8,
+	CEC_TYPE_U16,
+	CEC_TYPE_U32,
+	CEC_TYPE_STRING,
+	CEC_TYPE_ENUM,
+};
+
+struct arg {
+	enum cec_types type;
+	__u8 num_enum_values;
+	const struct cec_enum_values *values;
+};
+
+static const struct arg arg_u8 = {
+	CEC_TYPE_U8,
+};
+
+static const struct arg arg_u16 = {
+	CEC_TYPE_U16,
+};
+
+static const struct arg arg_u32 = {
+	CEC_TYPE_U32,
+};
+
+static const struct arg arg_string = {
+	CEC_TYPE_STRING,
+};
+
+static const struct cec_enum_values type_ui_cmd[] = {
+	{ "Select", 0x00 },
+	{ "Up", 0x01 },
+	{ "Down", 0x02 },
+	{ "Left", 0x03 },
+	{ "Right", 0x04 },
+	{ "Right-Up", 0x05 },
+	{ "Right-Down", 0x06 },
+	{ "Left-Up", 0x07 },
+	{ "Left-Down", 0x08 },
+	{ "Device Root Menu", 0x09 },
+	{ "Device Setup Menu", 0x0a },
+	{ "Contents Menu", 0x0b },
+	{ "Favorite Menu", 0x0c },
+	{ "Back", 0x0d },
+	{ "Media Top Menu", 0x10 },
+	{ "Media Context-sensitive Menu", 0x11 },
+	{ "Number Entry Mode", 0x1d },
+	{ "Number 11", 0x1e },
+	{ "Number 12", 0x1f },
+	{ "Number 0 or Number 10", 0x20 },
+	{ "Number 1", 0x21 },
+	{ "Number 2", 0x22 },
+	{ "Number 3", 0x23 },
+	{ "Number 4", 0x24 },
+	{ "Number 5", 0x25 },
+	{ "Number 6", 0x26 },
+	{ "Number 7", 0x27 },
+	{ "Number 8", 0x28 },
+	{ "Number 9", 0x29 },
+	{ "Dot", 0x2a },
+	{ "Enter", 0x2b },
+	{ "Clear", 0x2c },
+	{ "Next Favorite", 0x2f },
+	{ "Channel Up", 0x30 },
+	{ "Channel Down", 0x31 },
+	{ "Previous Channel", 0x32 },
+	{ "Sound Select", 0x33 },
+	{ "Input Select", 0x34 },
+	{ "Display Information", 0x35 },
+	{ "Help", 0x36 },
+	{ "Page Up", 0x37 },
+	{ "Page Down", 0x38 },
+	{ "Power", 0x40 },
+	{ "Volume Up", 0x41 },
+	{ "Volume Down", 0x42 },
+	{ "Mute", 0x43 },
+	{ "Play", 0x44 },
+	{ "Stop", 0x45 },
+	{ "Pause", 0x46 },
+	{ "Record", 0x47 },
+	{ "Rewind", 0x48 },
+	{ "Fast forward", 0x49 },
+	{ "Eject", 0x4a },
+	{ "Skip Forward", 0x4b },
+	{ "Skip Backward", 0x4c },
+	{ "Stop-Record", 0x4d },
+	{ "Pause-Record", 0x4e },
+	{ "Angle", 0x50 },
+	{ "Sub picture", 0x51 },
+	{ "Video on Demand", 0x52 },
+	{ "Electronic Program Guide", 0x53 },
+	{ "Timer Programming", 0x54 },
+	{ "Initial Configuration", 0x55 },
+	{ "Select Broadcast Type", 0x56 },
+	{ "Select Sound Presentation", 0x57 },
+	{ "Audio Description", 0x58 },
+	{ "Internet", 0x59 },
+	{ "3D Mode", 0x5a },
+	{ "Play Function", 0x60 },
+	{ "Pause-Play Function", 0x61 },
+	{ "Record Function", 0x62 },
+	{ "Pause-Record Function", 0x63 },
+	{ "Stop Function", 0x64 },
+	{ "Mute Function", 0x65 },
+	{ "Restore Volume Function", 0x66 },
+	{ "Tune Function", 0x67 },
+	{ "Select Media Function", 0x68 },
+	{ "Select A/V Input Function", 0x69 },
+	{ "Select Audio Input Function", 0x6a },
+	{ "Power Toggle Function", 0x6b },
+	{ "Power Off Function", 0x6c },
+	{ "Power On Function", 0x6d },
+	{ "F1 (Blue)", 0x71 },
+	{ "F2 (Red)", 0x72 },
+	{ "F3 (Green)", 0x73 },
+	{ "F4 (Yellow)", 0x74 },
+	{ "F5", 0x75 },
+	{ "Data", 0x76 },
+};
+
+static const struct arg arg_rc_ui_cmd = {
+	CEC_TYPE_ENUM, sizeof(type_ui_cmd) / sizeof(type_ui_cmd[0]), type_ui_cmd
+};
+
+struct message {
+	__u8 msg;
+	unsigned option;
+	__u8 num_args;
+	const char *arg_names[CEC_MAX_ARGS+1];
+	const struct arg *args[CEC_MAX_ARGS];
+	const char *msg_name;
+};
+
+static struct cec_op_digital_service_id *args2digital_service_id(__u8 service_id_method,
+								 __u8 dig_bcast_system,
+								 __u16 transport_id,
+								 __u16 service_id,
+								 __u16 orig_network_id,
+								 __u16 program_number,
+								 __u8 channel_number_fmt,
+								 __u16 major,
+								 __u16 minor)
+{
+	static struct cec_op_digital_service_id dsid;
+
+	dsid.service_id_method = service_id_method;
+	dsid.dig_bcast_system = dig_bcast_system;
+	if (service_id_method == CEC_OP_SERVICE_ID_METHOD_BY_CHANNEL) {
+		dsid.channel.channel_number_fmt = channel_number_fmt;
+		dsid.channel.major = major;
+		dsid.channel.minor = minor;
+		return &dsid;
+	}
+	switch (dig_bcast_system) {
+	case CEC_OP_DIG_SERVICE_BCAST_SYSTEM_ATSC_GEN:
+	case CEC_OP_DIG_SERVICE_BCAST_SYSTEM_ATSC_CABLE:
+	case CEC_OP_DIG_SERVICE_BCAST_SYSTEM_ATSC_SAT:
+	case CEC_OP_DIG_SERVICE_BCAST_SYSTEM_ATSC_T:
+		dsid.atsc.transport_id = transport_id;
+		dsid.atsc.program_number = program_number;
+		break;
+	default:
+		dsid.dvb.transport_id = transport_id;
+		dsid.dvb.service_id = service_id;
+		dsid.dvb.orig_network_id = orig_network_id;
+		break;
+	}
+	return &dsid;
+}
+
+static int parse_subopt(char **subs, const char * const *subopts, char **value)
+{
+	int opt = getsubopt(subs, (char * const *)subopts, value);
+
+	if (opt == -1) {
+		fprintf(stderr, "Invalid suboptions specified\n");
+		return -1;
+	}
+	if (*value == NULL) {
+		fprintf(stderr, "No value given to suboption <%s>\n",
+				subopts[opt]);
+		return -1;
+	}
+	return opt;
+}
+
+static unsigned parse_enum(const char *value, const struct arg *a)
+{
+	if (isdigit(*value))
+		return strtoul(optarg, NULL, 0);
+	for (int i = 0; i < a->num_enum_values; i++) {
+		if (!strcmp(value, a->values[i].type_name))
+			return a->values[i].value;
+	}
+	return 0;
+}
+
+static char options[512];
+
+static std::string status2s(unsigned stat)
+{
+	std::string s;
+
+	if (stat & CEC_TX_STATUS_ARB_LOST)
+		s += "ArbitrationLost ";
+	if (stat & CEC_TX_STATUS_REPLY_TIMEOUT)
+		s += "ReplyTimeout ";
+	if (stat & CEC_TX_STATUS_RETRY_TIMEOUT)
+		s += "RetryTimeout ";
+	if (stat & CEC_TX_STATUS_FEATURE_ABORT)
+		s += "FeatureAbort ";
+	return s;
+}
+
+static void log_arg(const struct arg *arg, const char *arg_name, __u32 val)
+{
+	unsigned i;
+
+	switch (arg->type) {
+	case CEC_TYPE_ENUM:
+		for (i = 0; i < arg->num_enum_values; i++) {
+			if (arg->values[i].value == val) {
+				printf("\t%s: %s (0x%02x)\n", arg_name,
+				       arg->values[i].type_name, val);
+				return;
+			}
+		}
+		/* fall through */
+	case CEC_TYPE_U8:
+		printf("\t%s: %u (0x%02x)\n", arg_name, val, val);
+		return;
+	case CEC_TYPE_U16:
+		if (strstr(arg_name, "phys-addr"))
+			printf("\t%s: %x.%x.%x.%x\n", arg_name,
+			       val >> 12, (val >> 8) & 0xf, (val >> 4) & 0xf, val & 0xf);
+		else
+			printf("\t%s: %u (0x%04x)\n", arg_name, val, val);
+		return;
+	case CEC_TYPE_U32:
+		printf("\t%s: %u (0x%08x)\n", arg_name, val, val);
+		return;
+	default:
+		break;
+	}
+	printf("\t%s: unknown type\n", arg_name);
+}
+
+static void log_arg(const struct arg *arg, const char *arg_name,
+		    const char *s)
+{
+	switch (arg->type) {
+	case CEC_TYPE_STRING:
+		printf("\t%s: %s\n", arg_name, s);
+		return;
+	default:
+		break;
+	}
+	printf("\t%s: unknown type\n", arg_name);
+}
+
+static const struct cec_enum_values type_rec_src_type[] = {
+	{ "own", CEC_OP_RECORD_SRC_OWN },
+	{ "digital", CEC_OP_RECORD_SRC_DIGITAL },
+	{ "analog", CEC_OP_RECORD_SRC_ANALOG },
+	{ "ext-plug", CEC_OP_RECORD_SRC_EXT_PLUG },
+	{ "ext-phys-addr", CEC_OP_RECORD_SRC_EXT_PHYS_ADDR },
+};
+
+static const struct arg arg_rec_src_type = {
+	CEC_TYPE_ENUM, 5, type_rec_src_type
+};
+
+static void log_digital(const char *arg_name, const struct cec_op_digital_service_id *digital);
+static void log_rec_src(const char *arg_name, const struct cec_op_record_src *rec_src);
+static void log_tuner_dev_info(const char *arg_name, const struct cec_op_tuner_device_info *tuner_dev_info);
+static void log_features(const struct arg *arg, const char *arg_name, const __u8 *p);
+
+#include "cec-ctl-gen.h"
+
+static void log_digital(const char *arg_name, const struct cec_op_digital_service_id *digital)
+{
+	log_arg(&arg_service_id_method, "service-id-method", digital->service_id_method);
+	log_arg(&arg_dig_bcast_system, "dig-bcast-system", digital->dig_bcast_system);
+	if (digital->service_id_method == CEC_OP_SERVICE_ID_METHOD_BY_CHANNEL) {
+		log_arg(&arg_channel_number_fmt, "channel-number-fmt", digital->channel.channel_number_fmt);
+		log_arg(&arg_u16, "major", digital->channel.major);
+		log_arg(&arg_u16, "minor", digital->channel.minor);
+		return;
+	}
+
+	switch (digital->dig_bcast_system) {
+	case CEC_OP_DIG_SERVICE_BCAST_SYSTEM_ATSC_GEN:
+	case CEC_OP_DIG_SERVICE_BCAST_SYSTEM_ATSC_CABLE:
+	case CEC_OP_DIG_SERVICE_BCAST_SYSTEM_ATSC_SAT:
+	case CEC_OP_DIG_SERVICE_BCAST_SYSTEM_ATSC_T:
+		log_arg(&arg_u16, "transport-id", digital->atsc.transport_id);
+		log_arg(&arg_u16, "program-number", digital->atsc.program_number);
+		break;
+	default:
+		log_arg(&arg_u16, "transport-id", digital->dvb.transport_id);
+		log_arg(&arg_u16, "service-id", digital->dvb.service_id);
+		log_arg(&arg_u16, "orig-network-id", digital->dvb.orig_network_id);
+		break;
+	}
+}
+
+static void log_rec_src(const char *arg_name, const struct cec_op_record_src *rec_src)
+{
+	log_arg(&arg_rec_src_type, "rec-src-type", rec_src->type);
+	switch (rec_src->type) {
+	case CEC_OP_RECORD_SRC_OWN:
+	default:
+		break;
+	case CEC_OP_RECORD_SRC_DIGITAL:
+		log_digital(arg_name, &rec_src->digital);
+		break;
+	case CEC_OP_RECORD_SRC_ANALOG:
+		log_arg(&arg_ana_bcast_type, "ana-bcast-type", rec_src->analog.ana_bcast_type);
+		log_arg(&arg_u16, "ana-freq", rec_src->analog.ana_freq);
+		log_arg(&arg_bcast_system, "bcast-system", rec_src->analog.bcast_system);
+		break;
+	case CEC_OP_RECORD_SRC_EXT_PLUG:
+		log_arg(&arg_u8, "plug", rec_src->ext_plug.plug);
+		break;
+	case CEC_OP_RECORD_SRC_EXT_PHYS_ADDR:
+		log_arg(&arg_u16, "phys-addr", rec_src->ext_phys_addr.phys_addr);
+		break;
+	}
+}
+
+static void log_tuner_dev_info(const char *arg_name, const struct cec_op_tuner_device_info *tuner_dev_info)
+{
+	log_arg(&arg_rec_flag, "rec-flag", tuner_dev_info->rec_flag);
+	log_arg(&arg_tuner_display_info, "tuner-display-info", tuner_dev_info->tuner_display_info);
+	if (tuner_dev_info->is_analog) {
+		log_arg(&arg_ana_bcast_type, "ana-bcast-type", tuner_dev_info->analog.ana_bcast_type);
+		log_arg(&arg_u16, "ana-freq", tuner_dev_info->analog.ana_freq);
+		log_arg(&arg_bcast_system, "bcast-system", tuner_dev_info->analog.bcast_system);
+	} else {
+		log_digital(arg_name, &tuner_dev_info->digital);
+	}
+}
+
+static void log_features(const struct arg *arg,
+			 const char *arg_name, const __u8 *p)
+{
+	do {
+		log_arg(arg, arg_name, (__u32)((*p) & ~CEC_OP_FEAT_EXT));
+	} while ((*p++) & CEC_OP_FEAT_EXT);
+}
+
+/* Short option list
+
+   Please keep in alphabetical order.
+   That makes it easier to see which short options are still free.
+
+   In general the lower case is used to set something and the upper
+   case is used to retrieve a setting. */
+enum Option {
+	OptPhysAddr = 'a',
+	OptClear = 'C',
+	OptSetDevice = 'd',
+	OptAdapDisable = 'D',
+	OptAdapEnable = 'E',
+	OptFrom = 'f',
+	OptHelp = 'h',
+	OptMonitor = 'm',
+	OptNoReply = 'n',
+	OptShowTopology = 'S',
+	OptTo = 't',
+	OptTrace = 'T',
+	OptVerbose = 'v',
+	OptVendorID = 'V',
+
+	OptTV = 128,
+	OptRecord,
+	OptTuner,
+	OptPlayback,
+	OptAudio,
+	OptProcessor,
+	OptSwitch,
+	OptCDCOnly,
+	OptUnregistered,
+	OptCECVersion1_4,
+	CEC_FEATURE_OPTIONS
+};
+
+struct node {
+	int fd;
+	const char *device;
+	unsigned caps;
+	unsigned available_log_addrs;
+	unsigned num_log_addrs;
+	__u8 log_addr[CEC_MAX_LOG_ADDRS];
+};
+
+#define doioctl(n, r, p) cec_named_ioctl((n)->fd, #r, r, p)
+
+bool show_info;
+
+typedef std::vector<cec_msg> msg_vec;
+
+static const struct message *opt2message[OptLast - OptMessages];
+
+static void init_messages()
+{
+	for (unsigned i = 0; messages[i].msg_name; i++)
+		opt2message[messages[i].option - OptMessages] = &messages[i];
+}
+
+static struct option long_options[] = {
+	{ "device", required_argument, 0, OptSetDevice },
+	{ "help", no_argument, 0, OptHelp },
+	{ "trace", no_argument, 0, OptTrace },
+	{ "verbose", no_argument, 0, OptVerbose },
+	{ "phys-addr", required_argument, 0, OptPhysAddr },
+	{ "vendor-id", required_argument, 0, OptVendorID },
+	{ "cec-version-1.4", no_argument, 0, OptCECVersion1_4 },
+	{ "enable", no_argument, 0, OptAdapEnable },
+	{ "disable", no_argument, 0, OptAdapDisable },
+	{ "clear", no_argument, 0, OptClear },
+	{ "monitor", no_argument, 0, OptMonitor },
+	{ "no-reply", no_argument, 0, OptNoReply },
+	{ "to", required_argument, 0, OptTo },
+	{ "from", required_argument, 0, OptFrom },
+	{ "show-topology", no_argument, 0, OptShowTopology },
+
+	{ "tv", no_argument, 0, OptTV },
+	{ "record", no_argument, 0, OptRecord },
+	{ "tuner", no_argument, 0, OptTuner },
+	{ "playback", no_argument, 0, OptPlayback },
+	{ "audio", no_argument, 0, OptAudio },
+	{ "processor", no_argument, 0, OptProcessor },
+	{ "switch", no_argument, 0, OptSwitch },
+	{ "cdc-only", no_argument, 0, OptCDCOnly },
+	{ "unregistered", no_argument, 0, OptUnregistered },
+	{ "help-all", no_argument, 0, OptHelpAll },
+
+	CEC_LONG_OPTS
+
+	{ 0, 0, 0, 0 }
+};
+
+static void usage(void)
+{
+	printf("Usage:\n"
+	       "  -d, --device=<dev> Use device <dev> instead of /dev/cec0\n"
+	       "                     If <dev> starts with a digit, then /dev/cec<dev> is used.\n"
+	       "  -h, --help         Display this help message\n"
+	       "  -T, --trace        Trace all called ioctls.\n"
+	       "  -v, --verbose      Turn on verbose reporting.\n"
+	       "  -a, --phys-addr=<addr>\n"
+	       "		     Use this physical address.\n"
+	       "  -D, --disable      Disable CEC adapter.\n"
+	       "  -E, --enable       Enable CEC adapter.\n"
+	       "  -C, --clear        Clear all logical addresses.\n"
+	       "  -m, --monitor      Monitor CEC traffic.\n"
+	       "  -V, --vendor-id=<id>\n"
+	       "		     Use this vendor ID.\n"
+	       "  -n, --no-reply     Don't wait for a reply.\n"
+	       "  -S, --show-topology Show the CEC topology.\n"
+	       "  -t, --to=<la>      Send message to the given logical address.\n"
+	       "  -f, --from=<la>    Send message from the given logical address.\n"
+	       "                     By default use the first assigned logical address.\n"
+	       "  --cec-version-1.4  Use CEC Version 1.4 instead of 2.0\n"
+	       "  --tv               This is a TV\n"
+	       "  --record           This is a recording device\n"
+	       "  --tuner            This is a tuner device\n"
+	       "  --playback         This is a playback device\n"
+	       "  --audio            This is an audio system device\n"
+	       "  --processor        This is a processor device\n"
+	       "  --switch           This is a pure CEC switch\n"
+	       "  --cdc-only         This is a CDC-only device\n"
+	       "  --unregistered     This is an unregistered device\n"
+	       "\n"
+	       "  --help-all                          Show all messages\n"
+	       CEC_USAGE
+	       );
+}
+
+static std::string caps2s(unsigned caps)
+{
+	std::string s;
+
+	if (caps & CEC_CAP_STATE)
+		s += "\t\tState\n";
+	if (caps & CEC_CAP_PHYS_ADDR)
+		s += "\t\tPhysical Address\n";
+	if (caps & CEC_CAP_LOG_ADDRS)
+		s += "\t\tLogical Addresses\n";
+	if (caps & CEC_CAP_IO)
+		s += "\t\tI/O\n";
+	if (caps & CEC_CAP_VENDOR_ID)
+		s += "\t\tVendor ID\n";
+	if (caps & CEC_CAP_PASSTHROUGH)
+		s += "\t\tPassthrough\n";
+	if (caps & CEC_CAP_RC)
+		s += "\t\tRemote Control Support\n";
+	if (caps & CEC_CAP_ARC)
+		s += "\t\tAudio Return Channel\n";
+	if (caps & CEC_CAP_CDC_HPD)
+		s += "\t\tCapability Discovery and Control HPD\n";
+	if (caps & CEC_CAP_IS_SOURCE)
+		s += "\t\tIs Source\n";
+	return s;
+}
+
+static const char *version2s(unsigned version)
+{
+	switch (version) {
+	case CEC_OP_CEC_VERSION_1_3A:
+		return "1.3a";
+	case CEC_OP_CEC_VERSION_1_4:
+		return "1.4";
+	case CEC_OP_CEC_VERSION_2_0:
+		return "2.0";
+	default:
+		return "Unknown";
+	}
+}
+
+static const char *power_status2s(unsigned status)
+{
+	switch (status) {
+	case CEC_OP_POWER_STATUS_ON:
+		return "On";
+	case CEC_OP_POWER_STATUS_STANDBY:
+		return "Standby";
+	case CEC_OP_POWER_STATUS_TO_ON:
+		return "In Transition Standby to On";
+	case CEC_OP_POWER_STATUS_TO_STANDBY:
+		return "In Transition On to Standby";
+	default:
+		return "Unknown";
+	}
+}
+
+static const char *prim_type2s(unsigned type)
+{
+	switch (type) {
+	case CEC_OP_PRIM_DEVTYPE_TV:
+		return "TV";
+	case CEC_OP_PRIM_DEVTYPE_RECORD:
+		return "Record";
+	case CEC_OP_PRIM_DEVTYPE_TUNER:
+		return "Tuner";
+	case CEC_OP_PRIM_DEVTYPE_PLAYBACK:
+		return "Playback";
+	case CEC_OP_PRIM_DEVTYPE_AUDIOSYSTEM:
+		return "Audio System";
+	case CEC_OP_PRIM_DEVTYPE_SWITCH:
+		return "Switch";
+	case CEC_OP_PRIM_DEVTYPE_PROCESSOR:
+		return "Processor";
+	default:
+		return "Unknown";
+	}
+}
+
+static const char *la_type2s(unsigned type)
+{
+	switch (type) {
+	case CEC_LOG_ADDR_TYPE_TV:
+		return "TV";
+	case CEC_LOG_ADDR_TYPE_RECORD:
+		return "Record";
+	case CEC_LOG_ADDR_TYPE_TUNER:
+		return "Tuner";
+	case CEC_LOG_ADDR_TYPE_PLAYBACK:
+		return "Playback";
+	case CEC_LOG_ADDR_TYPE_AUDIOSYSTEM:
+		return "Audio System";
+	case CEC_LOG_ADDR_TYPE_SPECIFIC:
+		return "Specific";
+	case CEC_LOG_ADDR_TYPE_UNREGISTERED:
+		return "Unregistered";
+	default:
+		return "Unknown";
+	}
+}
+
+static const char *la2s(unsigned la)
+{
+	switch (la & 0xf) {
+	case 0:
+		return "TV";
+	case 1:
+		return "Recording Device 1";
+	case 2:
+		return "Recording Device 2";
+	case 3:
+		return "Tuner 1";
+	case 4:
+		return "Playback Device 1";
+	case 5:
+		return "Audio System";
+	case 6:
+		return "Tuner 2";
+	case 7:
+		return "Tuner 3";
+	case 8:
+		return "Playback Device 2";
+	case 9:
+		return "Playback Device 3";
+	case 10:
+		return "Tuner 4";
+	case 11:
+		return "Playback Device 3";
+	case 12:
+		return "Reserved 1";
+	case 13:
+		return "Reserved 2";
+	case 14:
+		return "Specific";
+	case 15:
+	default:
+		return "Unregistered";
+	}
+}
+
+static std::string all_dev_types2s(unsigned types)
+{
+	std::string s;
+
+	if (types & CEC_OP_ALL_DEVTYPE_TV)
+		s += "TV, ";
+	if (types & CEC_OP_ALL_DEVTYPE_RECORD)
+		s += "Record, ";
+	if (types & CEC_OP_ALL_DEVTYPE_TUNER)
+		s += "Tuner, ";
+	if (types & CEC_OP_ALL_DEVTYPE_PLAYBACK)
+		s += "Playback, ";
+	if (types & CEC_OP_ALL_DEVTYPE_AUDIOSYSTEM)
+		s += "Audio System, ";
+	if (types & CEC_OP_ALL_DEVTYPE_SWITCH)
+		s += "Switch, ";
+	if (s.length())
+		return s.erase(s.length() - 2, 2);
+	return s;
+}
+
+static std::string rc_src_prof2s(unsigned prof)
+{
+	std::string s;
+
+	prof &= 0x1f;
+	if (prof == 0)
+		return "\t\tNone\n";
+	if (prof & CEC_OP_FEAT_RC_SRC_HAS_DEV_ROOT_MENU)
+		s += "\t\tSource Has Device Root Menu\n";
+	if (prof & CEC_OP_FEAT_RC_SRC_HAS_DEV_SETUP_MENU)
+		s += "\t\tSource Has Device Setup Menu\n";
+	if (prof & CEC_OP_FEAT_RC_SRC_HAS_MEDIA_CONTEXT_MENU)
+		s += "\t\tSource Has Contents Menu\n";
+	if (prof & CEC_OP_FEAT_RC_SRC_HAS_MEDIA_TOP_MENU)
+		s += "\t\tSource Has Media Top Menu\n";
+	if (prof & CEC_OP_FEAT_RC_SRC_HAS_MEDIA_CONTEXT_MENU)
+		s += "\t\tSource Has Media Context-Sensitive Menu\n";
+	return s;
+}
+
+static std::string dev_feat2s(unsigned feat)
+{
+	std::string s;
+
+	feat &= 0x3e;
+	if (feat == 0)
+		return "\t\tNone\n";
+	if (feat & CEC_OP_FEAT_DEV_HAS_RECORD_TV_SCREEN)
+		s += "\t\tTV Supports <Record TV Screen>\n";
+	if (feat & CEC_OP_FEAT_DEV_HAS_SET_OSD_STRING)
+		s += "\t\tTV Supports <Set OSD String>\n";
+	if (feat & CEC_OP_FEAT_DEV_HAS_DECK_CONTROL)
+		s += "\t\tSupports Deck Control\n";
+	if (feat & CEC_OP_FEAT_DEV_HAS_SET_AUDIO_RATE)
+		s += "\t\tSource Supports <Set Audio Rate>\n";
+	if (feat & CEC_OP_FEAT_DEV_SINK_HAS_ARC_TX)
+		s += "\t\tSink Supports ARC Tx\n";
+	if (feat & CEC_OP_FEAT_DEV_SOURCE_HAS_ARC_RX)
+		s += "\t\tSource Supports ARC Rx\n";
+	return s;
+}
+
+static const char *event_state2s(__u8 state)
+{
+	switch (state) {
+	case CEC_EVENT_STATE_DISABLED:
+		return "Disabled";
+	case CEC_EVENT_STATE_UNCONFIGURED:
+		return "Unconfigured";
+	case CEC_EVENT_STATE_CONFIGURING:
+		return "Configuring";
+	case CEC_EVENT_STATE_CONFIGURED:
+		return "Configured";
+	default:
+		return "Unknown";
+	}
+}
+
+int cec_named_ioctl(int fd, const char *name,
+		    unsigned long int request, void *parm)
+{
+	int retval = ioctl(fd, request, parm);
+	int e;
+
+	e = retval == 0 ? 0 : errno;
+	if (options[OptTrace])
+		printf("\t\t%s returned %d (%s)\n",
+			name, retval, strerror(e));
+
+	return retval == -1 ? e : (retval ? -1 : 0);
+}
+
+static void log_event(struct cec_event &ev)
+{
+	switch (ev.event) {
+	case CEC_EVENT_STATE_CHANGE:
+		printf("Event: State Change: %s\n",
+		       event_state2s(ev.state_change.state));
+		break;
+	case CEC_EVENT_INPUTS_CHANGE:
+		printf("Event: Inputs Change: Connected: 0x%04x Changed: 0x%04x\n",
+		       ev.inputs_change.connected_inputs,
+		       ev.inputs_change.changed_inputs);
+		break;
+	case CEC_EVENT_LOST_MSGS:
+		printf("Event: Lost Messages\n");
+		break;
+	default:
+		printf("Event: Unknown (0x%x)\n", ev.event);
+		break;
+	}
+	printf("\tTimestamp: %llu.%09llus\n", ev.ts / 1000000000, ev.ts % 1000000000);
+}
+
+static int showTopologyDevice(struct node *node, unsigned i, unsigned la)
+{
+	struct cec_msg msg;
+	char osd_name[15];
+
+	printf("\tSystem Information for device %d (%s) from device %d (%s):\n",
+	       i, la2s(i), la, la2s(la));
+
+	cec_msg_init(&msg, la, i);
+	cec_msg_get_cec_version(&msg, true);
+	doioctl(node, CEC_TRANSMIT, &msg);
+	printf("\t\tCEC Version                : %s\n",
+	       msg.status ? status2s(msg.status).c_str() : version2s(msg.msg[2]));
+
+	cec_msg_init(&msg, la, i);
+	cec_msg_give_physical_addr(&msg, true);
+	doioctl(node, CEC_TRANSMIT, &msg);
+	printf("\t\tPhysical Address           : ");
+	if (msg.status) {
+		printf("%s\n", status2s(msg.status).c_str());
+	} else {
+		__u16 phys_addr = (msg.msg[2] << 8) | msg.msg[3];
+
+		printf("%x.%x.%x.%x\n",
+		       phys_addr >> 12, (phys_addr >> 8) & 0xf,
+		       (phys_addr >> 4) & 0xf, phys_addr & 0xf);
+		printf("\t\tPrimary Device Type        : %s\n",
+		       prim_type2s(msg.msg[4]));
+	}
+
+	cec_msg_init(&msg, la, i);
+	cec_msg_give_device_vendor_id(&msg, true);
+	doioctl(node, CEC_TRANSMIT, &msg);
+	printf("\t\tVendor ID                  : ");
+	if (msg.status)
+		printf("%s\n", status2s(msg.status).c_str());
+	else
+		printf("0x%02x%02x%02x\n",
+		       msg.msg[2], msg.msg[3], msg.msg[4]);
+
+	cec_msg_init(&msg, la, i);
+	cec_msg_give_device_power_status(&msg, true);
+	doioctl(node, CEC_TRANSMIT, &msg);
+	printf("\t\tPower Status               : %s\n",
+	       msg.status ? status2s(msg.status).c_str() : power_status2s(msg.msg[2]));
+
+	cec_msg_init(&msg, la, i);
+	cec_msg_give_osd_name(&msg, true);
+	doioctl(node, CEC_TRANSMIT, &msg);
+	cec_ops_set_osd_name(&msg, osd_name);
+	printf("\t\tOSD Name                   : %s\n",
+	       msg.status ? status2s(msg.status).c_str() : osd_name);
+	return 0;
+}
+
+static int showTopology(struct node *node)
+{
+	struct cec_msg msg = { };
+	struct cec_log_addrs laddrs = { };
+
+	if (!(node->caps & CEC_CAP_IO))
+		return -ENOTTY;
+
+	doioctl(node, CEC_ADAP_G_LOG_ADDRS, &laddrs);
+
+	for (unsigned i = 0; i < 15; i++) {
+		int ret;
+
+		cec_msg_init(&msg, 0xf, i);
+		ret = doioctl(node, CEC_TRANSMIT, &msg);
+
+		switch (msg.status) {
+		case CEC_TX_STATUS_OK:
+			showTopologyDevice(node, i, laddrs.log_addr[0]);
+			break;
+		case CEC_TX_STATUS_ARB_LOST:
+			if (show_info)
+				printf("\t\ttx arbitration lost for addr %d\n", i);
+			break;
+		case CEC_TX_STATUS_RETRY_TIMEOUT:
+			break;
+		default:
+			if (show_info)
+				printf("\t\tunknown status %d\n", ret);
+			break;
+		}
+	}
+	return 0;
+}
+
+int main(int argc, char **argv)
+{
+	const char *device = "/dev/cec0";	/* -d device */
+	const message *opt;
+	msg_vec msgs;
+	char short_options[26 * 2 * 2 + 1];
+	__u32 vendor_id;
+	__u32 adap_state;
+	__u16 phys_addr;
+	__u8 from = 0, to = 0;
+	bool reply = true;
+	int idx = 0;
+	int fd = -1;
+	int ch;
+	int i;
+
+	init_messages();
+
+	for (i = 0; long_options[i].name; i++) {
+		if (!isalpha(long_options[i].val))
+			continue;
+		short_options[idx++] = long_options[i].val;
+		if (long_options[i].has_arg == required_argument)
+			short_options[idx++] = ':';
+	}
+	while (1) {
+		int option_index = 0;
+		struct cec_msg msg;
+
+		short_options[idx] = 0;
+		ch = getopt_long(argc, argv, short_options,
+				 long_options, &option_index);
+		if (ch == -1)
+			break;
+
+		if (ch > OptMessages)
+			cec_msg_init(&msg, 0, 0);
+		options[(int)ch] = 1;
+
+		switch (ch) {
+		case OptHelp:
+			usage();
+			return 0;
+		case OptSetDevice:
+			device = optarg;
+			if (device[0] >= '0' && device[0] <= '9' && strlen(device) <= 3) {
+				static char newdev[20];
+
+				sprintf(newdev, "/dev/cec%s", device);
+				device = newdev;
+			}
+			break;
+		case OptVerbose:
+			show_info = true;
+			break;
+		case OptFrom:
+			from = strtoul(optarg, NULL, 0) & 0xf;
+			break;
+		case OptTo:
+			to = strtoul(optarg, NULL, 0) & 0xf;
+			break;
+		case OptNoReply:
+			reply = false;
+			break;
+		case OptPhysAddr:
+			phys_addr = strtoul(optarg, NULL, 0);
+			break;
+		case OptVendorID:
+			vendor_id = strtoul(optarg, NULL, 0) & 0x00ffffff;
+			break;
+		case OptAdapDisable:
+			adap_state = CEC_ADAP_DISABLED;
+			break;
+		case OptAdapEnable:
+			adap_state = CEC_ADAP_ENABLED;
+			break;
+		case OptSwitch:
+			if (options[OptCDCOnly] || options[OptUnregistered]) {
+				fprintf(stderr, "--switch cannot be combined with --cdc-only or --unregistered.\n");
+				usage();
+				return 1;
+			}
+			break;
+		case OptCDCOnly:
+			if (options[OptSwitch] || options[OptUnregistered]) {
+				fprintf(stderr, "--cdc-only cannot be combined with --switch or --unregistered.\n");
+				usage();
+				return 1;
+			}
+			break;
+		case OptUnregistered:
+			if (options[OptCDCOnly] || options[OptSwitch]) {
+				fprintf(stderr, "--unregistered cannot be combined with --cdc-only or --switch.\n");
+				usage();
+				return 1;
+			}
+			break;
+		case ':':
+			fprintf(stderr, "Option '%s' requires a value\n",
+				argv[optind]);
+			usage();
+			return 1;
+		case '?':
+			if (argv[optind])
+				fprintf(stderr, "Unknown argument '%s'\n", argv[optind]);
+			usage();
+			return 1;
+		default:
+			if (ch >= OptHelpAll) {
+				usage_options(ch);
+				exit(0);
+			}
+			if (ch < OptMessages)
+				break;
+			opt = opt2message[ch - OptMessages];
+			parse_msg_args(msg, reply, opt, ch);
+			msgs.push_back(msg);
+			break;
+		}
+	}
+	if (optind < argc) {
+		printf("unknown arguments: ");
+		while (optind < argc)
+			printf("%s ", argv[optind++]);
+		printf("\n");
+		usage();
+		return 1;
+	}
+
+	if ((fd = open(device, O_RDWR)) < 0) {
+		fprintf(stderr, "Failed to open %s: %s\n", device,
+			strerror(errno));
+		exit(1);
+	}
+
+	struct node node;
+	struct cec_caps caps = { };
+
+	node.fd = fd;
+	node.device = device;
+	doioctl(&node, CEC_ADAP_G_CAPS, &caps);
+	node.caps = caps.capabilities;
+	node.available_log_addrs = caps.available_log_addrs;
+
+	unsigned flags = 0;
+	const char *osd_name;
+
+	if (options[OptTV])
+		osd_name = "TV";
+	else if (options[OptRecord])
+		osd_name = "Record";
+	else if (options[OptPlayback])
+		osd_name = "Playback";
+	else if (options[OptTuner])
+		osd_name = "Tuner";
+	else if (options[OptAudio])
+		osd_name = "Audio System";
+	else if (options[OptProcessor])
+		osd_name = "Processor";
+	else if (options[OptSwitch] || options[OptCDCOnly] || options[OptUnregistered])
+		osd_name = "";
+	else
+		osd_name = "TV";
+
+	if (options[OptTV])
+		flags |= 1 << CEC_OP_PRIM_DEVTYPE_TV;
+	if (options[OptRecord])
+		flags |= 1 << CEC_OP_PRIM_DEVTYPE_RECORD;
+	if (options[OptTuner])
+		flags |= 1 << CEC_OP_PRIM_DEVTYPE_TUNER;
+	if (options[OptPlayback])
+		flags |= 1 << CEC_OP_PRIM_DEVTYPE_PLAYBACK;
+	if (options[OptAudio])
+		flags |= 1 << CEC_OP_PRIM_DEVTYPE_AUDIOSYSTEM;
+	if (options[OptProcessor])
+		flags |= 1 << CEC_OP_PRIM_DEVTYPE_PROCESSOR;
+	if (options[OptSwitch] || options[OptCDCOnly] || options[OptUnregistered])
+		flags |= 1 << CEC_OP_PRIM_DEVTYPE_SWITCH;
+
+	printf("Driver Info:\n");
+	printf("\tCapabilities               : 0x%08x\n", caps.capabilities);
+	printf("%s", caps2s(caps.capabilities).c_str());
+	printf("\tInputs                     : %u\n", caps.ninputs);
+	printf("\tAvailable Logical Addresses: %u\n",
+	       caps.available_log_addrs);
+
+	if ((node.caps & CEC_CAP_LOG_ADDRS) && options[OptClear]) {
+		struct cec_log_addrs laddrs = { };
+
+		doioctl(&node, CEC_ADAP_S_LOG_ADDRS, &laddrs);
+	}
+
+	if ((node.caps & CEC_CAP_PHYS_ADDR) && options[OptPhysAddr])
+		doioctl(&node, CEC_ADAP_S_PHYS_ADDR, &phys_addr);
+	doioctl(&node, CEC_ADAP_G_PHYS_ADDR, &phys_addr);
+	printf("\tPhysical Address           : %x.%x.%x.%x\n",
+	       phys_addr >> 12, (phys_addr >> 8) & 0xf,
+	       (phys_addr >> 4) & 0xf, phys_addr & 0xf);
+	if (!options[OptPhysAddr] && phys_addr == 0xffff &&
+	    (node.caps & CEC_CAP_PHYS_ADDR))
+		printf("Perhaps you should use option --phys-addr?\n");
+
+	if (node.caps & CEC_CAP_VENDOR_ID) {
+		if (!options[OptVendorID]) {
+			doioctl(&node, CEC_ADAP_G_VENDOR_ID, &vendor_id);
+			if (vendor_id == CEC_VENDOR_ID_NONE)
+				vendor_id = 0x000c03; /* HDMI LLC vendor ID */
+		}
+		doioctl(&node, CEC_ADAP_S_VENDOR_ID, &vendor_id);
+	}
+	doioctl(&node, CEC_ADAP_G_VENDOR_ID, &vendor_id);
+	if (vendor_id != CEC_VENDOR_ID_NONE)
+		printf("\tVendor ID                  : 0x%06x\n", vendor_id);
+
+	if ((node.caps & CEC_CAP_STATE) &&
+	    (options[OptAdapEnable] || options[OptAdapDisable]))
+		doioctl(&node, CEC_ADAP_S_STATE, &adap_state);
+	doioctl(&node, CEC_ADAP_G_STATE, &adap_state);
+	printf("\tAdapter State              : %s\n", adap_state ? "Enabled" : "Disabled");
+	if (adap_state == CEC_ADAP_DISABLED)
+		return 0;
+
+	if ((node.caps & CEC_CAP_LOG_ADDRS) && flags) {
+		struct cec_log_addrs laddrs;
+
+		memset(&laddrs, 0, sizeof(laddrs));
+		doioctl(&node, CEC_ADAP_S_LOG_ADDRS, &laddrs);
+		memset(&laddrs, 0, sizeof(laddrs));
+
+		laddrs.cec_version = options[OptCECVersion1_4] ?
+			CEC_OP_CEC_VERSION_1_4 : CEC_OP_CEC_VERSION_2_0;
+		strcpy(laddrs.osd_name, osd_name);
+
+		for (unsigned i = 0; i < 8; i++) {
+			unsigned la_type;
+			unsigned all_dev_type;
+
+			if (!(flags & (1 << i)))
+				continue;
+			if (laddrs.num_log_addrs == node.available_log_addrs) {
+				fprintf(stderr, "Attempt to define too many logical addresses\n");
+				exit(-1);
+			}
+			switch (i) {
+			case CEC_OP_PRIM_DEVTYPE_TV:
+				la_type = CEC_LOG_ADDR_TYPE_TV;
+				all_dev_type = CEC_OP_ALL_DEVTYPE_TV;
+				break;
+			case CEC_OP_PRIM_DEVTYPE_RECORD:
+				la_type = CEC_LOG_ADDR_TYPE_RECORD;
+				all_dev_type = CEC_OP_ALL_DEVTYPE_RECORD;
+				break;
+			case CEC_OP_PRIM_DEVTYPE_TUNER:
+				la_type = CEC_LOG_ADDR_TYPE_TUNER;
+				all_dev_type = CEC_OP_ALL_DEVTYPE_TUNER;
+				break;
+			case CEC_OP_PRIM_DEVTYPE_PLAYBACK:
+				la_type = CEC_LOG_ADDR_TYPE_PLAYBACK;
+				all_dev_type = CEC_OP_ALL_DEVTYPE_PLAYBACK;
+				break;
+			case CEC_OP_PRIM_DEVTYPE_AUDIOSYSTEM:
+				la_type = CEC_LOG_ADDR_TYPE_AUDIOSYSTEM;
+				all_dev_type = CEC_OP_ALL_DEVTYPE_AUDIOSYSTEM;
+				break;
+			case CEC_OP_PRIM_DEVTYPE_PROCESSOR:
+				la_type = CEC_LOG_ADDR_TYPE_SPECIFIC;
+				all_dev_type = CEC_OP_ALL_DEVTYPE_SWITCH;
+				break;
+			case CEC_OP_PRIM_DEVTYPE_SWITCH:
+			default:
+				la_type = CEC_LOG_ADDR_TYPE_UNREGISTERED;
+				all_dev_type = CEC_OP_ALL_DEVTYPE_SWITCH;
+				break;
+			}
+			laddrs.log_addr_type[laddrs.num_log_addrs] = la_type;
+			laddrs.all_device_types[laddrs.num_log_addrs] = all_dev_type;
+			laddrs.primary_device_type[laddrs.num_log_addrs++] = i;
+		}
+
+		doioctl(&node, CEC_ADAP_S_LOG_ADDRS, &laddrs);
+	}
+
+	struct cec_log_addrs laddrs = { };
+	doioctl(&node, CEC_ADAP_G_LOG_ADDRS, &laddrs);
+	node.num_log_addrs = laddrs.num_log_addrs;
+	printf("\tCEC Version                : %s\n", version2s(laddrs.cec_version));
+	printf("\tLogical Addresses          : %u\n", laddrs.num_log_addrs);
+	for (unsigned i = 0; i < laddrs.num_log_addrs; i++) {
+		printf("\n\t  Logical Address          : %d (%s)\n",
+		       laddrs.log_addr[i], la2s(laddrs.log_addr[i]));
+		printf("\t    Primary Device Type    : %s\n",
+		       prim_type2s(laddrs.primary_device_type[i]));
+		printf("\t    Logical Address Type   : %s\n",
+		       la_type2s(laddrs.log_addr_type[i]));
+		if (laddrs.cec_version < CEC_OP_CEC_VERSION_2_0)
+			continue;
+		printf("\t    All Device Types       : %s\n",
+		       all_dev_types2s(laddrs.all_device_types[i]).c_str());
+
+		bool is_dev_feat = false;
+		for (unsigned idx = 0; idx < sizeof(laddrs.features[0]); idx++) {
+			__u8 byte = laddrs.features[i][idx];
+
+			if (!is_dev_feat) {
+				if (byte & 0x40) {
+					printf("\t    RC Source Profile      :\n%s\n",
+					       rc_src_prof2s(byte).c_str());
+				} else {
+					const char *s = "Reserved";
+
+					switch (byte & 0xf) {
+					case 0:
+						s = "None";
+						break;
+					case 2:
+						s = "RC Profile 1";
+						break;
+					case 6:
+						s = "RC Profile 2";
+						break;
+					case 10:
+						s = "RC Profile 3";
+						break;
+					case 14:
+						s = "RC Profile 4";
+						break;
+					}
+					printf("\t    RC TV Profile          : %s\n", s);
+				}
+			} else {
+				printf("\t    Device Features        :\n%s",
+				       dev_feat2s(byte).c_str());
+			}
+			if (byte & CEC_OP_FEAT_EXT)
+				continue;
+			if (!is_dev_feat)
+				is_dev_feat = true;
+			else
+				break;
+		}
+	}
+	if (node.num_log_addrs == 0) {
+		if (options[OptMonitor])
+			goto monitor;
+		return 0;
+	}
+	printf("\n");
+
+	if (!options[OptFrom])
+		from = laddrs.log_addr[0];
+
+	if (options[OptShowTopology])
+		showTopology(&node);
+
+	for (msg_vec::iterator iter = msgs.begin(); iter != msgs.end(); ++iter) {
+		if (!options[OptTo]) {
+			fprintf(stderr, "attempting to send message without --to\n");
+			exit(1);
+		}
+		struct cec_msg msg = *iter;
+		bool has_reply = msg.reply;
+
+		printf("\nTransmit from %s to %s (%d to %d):\n",
+		       la2s(from), to == 0xf ? "all" : la2s(to), from, to);
+		msg.msg[0] |= (from << 4) | to;
+		log_msg(msg);
+		if (doioctl(&node, CEC_TRANSMIT, &msg))
+			continue;
+		if (has_reply) {
+			printf("Received from %s (%d):\n", la2s(cec_msg_initiator(&msg)),
+			       cec_msg_initiator(&msg));
+			log_msg(msg);
+		} else {
+			printf("\t%s\n", status2s(msg.status).c_str());
+		}
+		printf("\tTimestamp: %llu.%09llus\n", msg.ts / 1000000000, msg.ts % 1000000000);
+	}
+
+monitor:
+	if (options[OptMonitor]) {
+		__u32 monitor = CEC_MONITOR_ENABLED;
+		fd_set rd_fds;
+		fd_set ex_fds;
+		int fd = node.fd;
+
+		printf("\n");
+		doioctl(&node, CEC_S_MONITOR, &monitor);
+
+		fcntl(fd, F_SETFL, fcntl(fd, F_GETFL) | O_NONBLOCK);
+		while (1) {
+			int res;
+
+			FD_ZERO(&rd_fds);
+			FD_ZERO(&ex_fds);
+			FD_SET(fd, &rd_fds);
+			FD_SET(fd, &ex_fds);
+			res = select(fd + 1, &rd_fds, NULL, &ex_fds, NULL);
+			if (res <= 0)
+				break;
+			if (FD_ISSET(fd, &rd_fds)) {
+				struct cec_msg msg = { };
+				__u8 from, to;
+
+				if (doioctl(&node, CEC_RECEIVE, &msg))
+					continue;
+
+				from = cec_msg_initiator(&msg);
+				to = cec_msg_destination(&msg);
+				printf("\nReceived from %s to %s (%d to %d):\n",
+				       la2s(from), to == 0xf ? "all" : la2s(to), from, to);
+				log_msg(msg);
+				printf("\tTimestamp: %llu.%09llus\n", msg.ts / 1000000000, msg.ts % 1000000000);
+			}
+			if (FD_ISSET(fd, &ex_fds)) {
+				struct cec_event ev;
+
+				if (doioctl(&node, CEC_DQEVENT, &ev))
+					continue;
+				log_event(ev);
+			}
+		}
+	}
+
+	close(fd);
+	return 0;
+}
diff --git a/utils/cec-ctl/msg2ctl.pl b/utils/cec-ctl/msg2ctl.pl
new file mode 100644
index 0000000..af42905
--- /dev/null
+++ b/utils/cec-ctl/msg2ctl.pl
@@ -0,0 +1,430 @@
+#!/usr/bin/perl
+
+sub maxprefix {
+	my $p = shift(@_);
+	for (@_) {
+		chop $p until /^\Q$p/;
+	}
+	$p =~ s/_[^_]*$/_/;
+	$p = "CEC_OP_CEC_" if ($p =~ /CEC_OP_CEC_VERSION_/);
+	return $p;
+}
+
+sub process_func
+{
+	my $feature = shift;
+	my $func = shift;
+	my $func_args = $func;
+	$func =~ s/\(.*//;
+	my $msg = $func;
+	$msg =~ s/([a-z])/\U\1/g;
+	$func =~ s/cec_msg//;
+	my $opt = $func;
+	$opt =~ s/_([a-z])/\U\1/g;
+	$func_args =~ s/.*\((.*)\).*/\1/;
+	my $has_reply = $func_args =~ /^bool reply/;
+	$func_args =~ s/^bool reply,? ?//;
+	my $arg_names;
+	my $arg_ptrs;
+	my $name, $type, $size;
+	my $msg_dash_name, $msg_lc_name;
+	my @enum, $val;
+	my $usage;
+	my $has_digital = $func_args =~ /cec_op_digital_service_id/;
+
+	my @ops_args = split(/, */, $func_args);
+	if ($has_digital) {
+		$func_args =~ s/const struct cec_op_digital_service_id \*digital/__u8 service_id_method, __u8 dig_bcast_system, __u16 transport_id, __u16 service_id, __u16 orig_network_id, __u16 program_number, __u8 channel_number_fmt, __u16 major, __u16 minor/;
+	}
+	my @args = split(/, */, $func_args);
+	my $has_struct = $func_args =~ /struct/;
+	return if ($func_args =~ /__u\d+\s*\*/);
+
+	my $cec_msg = $msg;
+	while ($cec_msg ne "" && !exists($msgs{$cec_msg})) {
+		$cec_msg =~ s/_[^_]*$//;
+	}
+	return if ($cec_msg eq "");
+
+	my $msg_name = $cec_msg;
+	$msg_name =~ s/CEC_MSG_//;
+	$msg_dash_name = $msg;
+	$msg_dash_name =~ s/CEC_MSG_//;
+	$msg_dash_name =~ s/([A-Z])/\l\1/g;
+	$msg_dash_name =~ s/_/-/g;
+	$msg_lc_name = $msg;
+	$msg_lc_name =~ s/([A-Z])/\l\1/g;
+
+	if ($cec_msg eq $msg) {
+		if ($cec_msg =~ /_CDC_/ && !$cdc_case) {
+			$cdc_case = 1;
+			$logswitch .= "\tcase CEC_MSG_CDC_MESSAGE:\n";
+			$logswitch .= "\tswitch (msg.msg[4]) {\n";
+		}
+		if (@args == 0) {
+			$logswitch .= "\tcase $cec_msg:\n";
+			$logswitch .= "\t\tprintf(\"$cec_msg:\\n\");\n";
+			$logswitch .= "\t\tbreak;\n\n";
+		} else {
+			$logswitch .= "\tcase $cec_msg: {\n";
+			foreach (@ops_args) {
+				($type, $name) = /(.*?) ?([a-zA-Z_]\w+)$/;
+				if ($type =~ /struct .*\*/) {
+					$type =~ s/ \*//;
+					$type =~ s/const //;
+				}
+				if ($name eq "rc_profile" || $name eq "dev_features") {
+					$logswitch .= "\t\tconst __u8 *$name = NULL;\n";
+				} elsif ($type eq "const char *") {
+					$logswitch .= "\t\tchar $name\[16\];\n";
+				} else {
+					$logswitch .= "\t\t$type $name;\n";
+				}
+			}
+			if ($cdc_case) {
+				$logswitch .= "\t\t__u16 phys_addr;\n";
+			}
+			my $ops_lc_name = $msg_lc_name;
+			$ops_lc_name =~ s/^cec_msg/cec_ops/;
+			$logswitch .= "\n\t\t$ops_lc_name(&msg";
+			if ($cdc_case) {
+				$logswitch .= ", &phys_addr";
+			}
+			foreach (@ops_args) {
+				($type, $name) = /(.*?) ?([a-zA-Z_]\w+)$/;
+				if ($type eq "const char *") {
+					$logswitch .= ", $name";
+				} else {
+					$logswitch .= ", &$name";
+				}
+			}
+			$logswitch .= ");\n";
+			$logswitch .= "\t\tprintf(\"$cec_msg:\\n\");\n";
+			if ($cdc_case) {
+				$logswitch .= "\t\tlog_arg(&arg_phys_addr, \"phys-addr\", phys_addr);\n";
+			}
+			foreach (@ops_args) {
+				($type, $name) = /(.*?) ?([a-zA-Z_]\w+)$/;
+				my $dash_name = $name;
+				$dash_name =~ s/_/-/g;
+				if ($name eq "rc_profile" || $name eq "dev_features") {
+					$logswitch .= "\t\tlog_features(&arg_$name, \"$dash_name\", $name);\n";
+				} elsif ($name eq "digital") {
+					$logswitch .= "\t\tlog_digital(\"$dash_name\", &$name);\n";
+				} elsif ($name eq "rec_src") {
+					$logswitch .= "\t\tlog_rec_src(\"$dash_name\", &$name);\n";
+				} elsif ($name eq "tuner_dev_info") {
+					$logswitch .= "\t\tlog_tuner_dev_info(\"$dash_name\", &$name);\n";
+				} elsif ($name eq "ui_cmd") {
+					$logswitch .= "\t\tlog_arg(&arg_rc_$name, \"$dash_name\", $name);\n";
+				} else {
+					$logswitch .= "\t\tlog_arg(&arg_$name, \"$dash_name\", $name);\n";
+				}
+			}
+			$logswitch .= "\t\tbreak;\n\t}\n";
+		}
+	}
+	return if $has_struct;
+
+	$options .= "\tOpt$opt,\n";
+	$messages .= "\t\t$cec_msg,\n";
+	$messages .= "\t\tOpt$opt,\n";
+	if (@args == 0) {
+		$messages .= "\t\t0, { }, { },\n";
+		$long_opts .= "\t{ \"$msg_dash_name\", no_argument, 0, Opt$opt }, \\\n";
+		$usage .= "\t\"  --" . sprintf("%-30s", $msg_dash_name) . "Send $msg_name message (\" xstr($cec_msg) \")\\n\"\n";
+		$usage_msg{$msg} = $usage;
+		$switch .= "\tcase Opt$opt: {\n";
+		$switch .= "\t\t$msg_lc_name(&msg";
+		$switch .= ", reply" if $has_reply;
+		$switch .= ");\n\t\tbreak;\n\t}\n\n";
+	} else {
+		$long_opts .= "\t{ \"$msg_dash_name\", required_argument, 0, Opt$opt }, \\\n";
+		$usage .= "\t\"  --$msg_dash_name";
+		my $prefix = "\t\"    " . sprintf("%-30s", " ");
+		my $sep = "=";
+		foreach (@args) {
+			($type, $name) = /(.*?) ?([a-zA-Z_]\w+)$/;
+			$name =~ s/_/-/g;
+			$usage .= "$sep$name=<val>";
+			$sep = ",";
+		}
+		$usage .= "\\n\"\n";
+		foreach (@args) {
+			($type, $name) = /(.*?) ?([a-zA-Z_]\w+)$/;
+			@enum = @{$types{$name}};
+			next if !scalar(@enum);
+			$name =~ s/_/-/g;
+			$usage .= $prefix . "'$name' can have these values:\\n\"\n";
+			my $common_prefix = maxprefix(@enum);
+			foreach (@enum) {
+				my $e = $_;
+				s/^$common_prefix//;
+				s/([A-Z])/\l\1/g;
+				s/_/-/g;
+				$usage .= $prefix . "    $_ (\" xstr($e) \")\\n\"\n";
+			}
+		}
+		$usage .= $prefix . "Send $msg_name message (\" xstr($cec_msg) \")\\n\"\n";
+		$usage_msg{$msg} = $usage;
+		$switch .= "\tcase Opt$opt: {\n";
+		foreach (@args) {
+			($type, $name) = /(.*?) ?([a-zA-Z_]\w+)$/;
+			if ($type =~ /char/) {
+				$switch .= "\t\tconst char *$name = \"\";\n";
+			} else {
+				$switch .= "\t\t$type $name = 0;\n";
+			}
+		}
+		$switch .= "\n\t\twhile (*subs != '\\0') {\n";
+		$switch .= "\t\t\tswitch (parse_subopt(&subs, opt->arg_names, &value)) {\n";
+		my $cnt = 0;
+		foreach (@args) {
+			($type, $name) = /(.*?) ?([a-zA-Z_]\w+)$/;
+			@enum = @{$types{$name}};
+			$switch .= "\t\t\tcase $cnt:\n";
+			$cnt++;
+			if ($type =~ /char/) {
+				$switch .= "\t\t\t\t$name = value;\n";
+			} elsif (scalar(@enum)) {
+				$switch .= "\t\t\t\t$name = parse_enum(value, opt->args\[1\]);\n";
+			} else {
+				$switch .= "\t\t\t\t$name = strtol(value, 0L, 0);\n";
+			}
+			$switch .= "\t\t\t\tbreak;\n";
+		}
+		$switch .= "\t\t\tdefault:\n";
+		$switch .= "\t\t\t\texit(1);\n";
+		$switch .= "\t\t\t}\n\t\t}\n";
+		$switch .= "\t\t$msg_lc_name(&msg";
+		$switch .= ", reply" if $has_reply;
+		foreach (@args) {
+			($type, $name) = /(.*?) ?([a-zA-Z_]\w+)$/;
+			$switch .= ", $name";
+		}
+		$switch .= ");\n\t\tbreak;\n\t}\n\n";
+
+		foreach (@args) {
+			($type, $name) = /(.*?) ?([a-zA-Z_]\w+)$/;
+			if ($arg_names ne "") {
+				$arg_names .= ", ";
+				$arg_ptrs .= ", ";
+			}
+			$arg_ptrs .= "&arg_$name";
+			$name =~ s/_/-/g;
+			$arg_names .= '"' . $name . '"';
+		}
+		$size = $#args + 1;
+		$messages .= "\t\t$size, { $arg_names },\n";
+		$messages .= "\t\t{ $arg_ptrs },\n";
+		foreach (@args) {
+			($type, $name) = /(.*?) ?([a-zA-Z_]\w+)$/;
+			@enum = @{$types{$name}};
+			$size = scalar(@enum);
+
+			if ($size && !defined($created_enum{$name})) {
+				$created_enum{$name} = 1;
+				$enums .= "static const struct cec_enum_values type_$name\[\] = {\n";
+				my $common_prefix = maxprefix(@enum);
+				foreach (@enum) {
+					$val = $_;
+					s/^$common_prefix//;
+					s/([A-Z])/\l\1/g;
+					s/_/-/g;
+					$enums .= "\t{ \"$_\", $val },\n";
+				}
+				$enums .= "};\n\n";
+			}
+			if (!defined($created_arg{$name})) {
+				$created_arg{$name} = 1;
+				if ($type eq "__u8" && $size) {
+					$arg_structs .= "static const struct arg arg_$name = {\n";
+					$arg_structs .= "\tCEC_TYPE_ENUM, $size, type_$name\n};\n\n";
+				} elsif ($type eq "__u8") {
+					$arg_structs .= "#define arg_$name arg_u8\n";
+				} elsif ($type eq "__u16") {
+					$arg_structs .= "#define arg_$name arg_u16\n";
+				} elsif ($type eq "__u32") {
+					$arg_structs .= "#define arg_$name arg_u32\n";
+				} elsif ($type eq "const char *") {
+					$arg_structs .= "#define arg_$name arg_string\n";
+				}
+			}
+		}
+	}
+	$messages .= "\t\t\"$msg_name\"\n";
+	$messages .= "\t}, {\n";
+	$feature_usage{$feature} .= $usage;
+}
+
+while (<>) {
+	last if /\/\* Commands \*\//;
+}
+
+$comment = 0;
+$has_also = 0;
+$operand_name = "";
+$feature = "";
+
+while (<>) {
+	chomp;
+	last if /_CEC_FUNCS_H/;
+	if (/^\/\*.*Feature \*\/$/) {
+		($feature) = /^\/\* (.*) Feature/;
+	}
+	if ($operand_name ne "" && !/^#define/) {
+		@{$types{$operand_name}} = @ops;
+		undef @ops;
+		$operand_name = "";
+	}
+	if (/\/\*.*Operand \((.*)\)/) {
+		$operand_name = $1;
+		next;
+	}
+	s/\/\*.*\*\///;
+	if ($comment) {
+		if ($has_also) {
+			if (/CEC_MSG/) {
+				($also_msg) = /(CEC_MSG\S+)/;
+				push @{$feature_also{$feature}}, $also_msg;
+			}
+		} elsif (/^ \* Has also:$/) {
+			$has_also = 1;
+		}
+		$has_also = 0 if (/\*\//);
+		next unless /\*\//;
+		$comment = 0;
+		s/^.*\*\///;
+	}
+	if (/\/\*/) {
+		$comment = 1;
+		$has_also = 0;
+		next;
+	}
+	next if /^\s*$/;
+	if (/^\#define/) {
+		($name, $val) = /define (\S+)\s+(\S+)/;
+		if ($name =~ /^CEC_MSG/) {
+			$msgs{$name} = 1;
+		} elsif ($operand_name ne "" && $name =~ /^CEC_OP/) {
+			push @ops, $name;
+		}
+		next;
+	}
+}
+
+while (<>) {
+	chomp;
+	if (/^\/\*.*Feature \*\/$/) {
+		($feature) = /^\/\* (.*) Feature/;
+	}
+	s/\/\*.*\*\///;
+	if ($comment) {
+		next unless /\*\//;
+		$comment = 0;
+		s/^.*\*\///;
+	}
+	if (/\/\*/) {
+		$comment = 1;
+		next;
+	}
+	next if /^\s*$/;
+	next if /cec_msg_reply_abort/;
+	if (/^static __inline__ void cec_msg.*\(.*\)/) {
+		s/static\s__inline__\svoid\s//;
+		s/struct cec_msg \*msg, //;
+		s/struct cec_msg \*msg//;
+		process_func($feature, $_);
+		next;
+	}
+	if (/^static __inline__ void cec_msg/) {
+		$func = $_;
+		next;
+	}
+	if ($func ne "") {
+		$func .= $_;
+		next unless /\)$/;
+		$func =~ s/\s+/ /g;
+		$func =~ s/static\s__inline__\svoid\s//;
+		$func =~ s/struct cec_msg \*msg, //;
+		$func =~ s/struct cec_msg \*msg//;
+		process_func($feature, $func);
+		$func = "";
+	}
+}
+
+$options .= "\tOptHelpAll,\n";
+
+foreach (sort keys %feature_usage) {
+	$name = $_;
+	s/ /_/g;
+	s/([A-Z])/\l\1/g;
+	$usage_var = $_ . "_usage";
+	printf "static const char *$usage_var =\n";
+	$usage = $feature_usage{$name};
+	foreach (@{$feature_also{$name}}) {
+		$usage .= $feature_usage{$_};
+	}
+	chop $usage;
+	printf "%s;\n\n", $usage;
+	s/_/-/g;
+	$help_features .= sprintf("\t\"  --help-%-28s Show messages for the $name feature\\n\" \\\n", $_);
+	$opt = "OptHelp" . $name;
+	$opt =~ s/ //g;
+	$help .= "\tif (options[OptHelpAll] || options\[$opt\]) {\n";
+	$help .= "\t\tprintf(\"$name Feature:\\n\");\n";
+	$help .= "\t\tprintf(\"\%s\\n\", $usage_var);\n\t}\n";
+	$options .= "\t$opt,\n";
+	$long_opts .= "\t{ \"help-$_\", no_argument, 0, $opt }, \\\n";
+}
+
+print "enum {\n\tOptMessages = 255,\n";
+printf "%s\n\tOptLast = 512\n};\n\n", $options;
+
+printf "#define CEC_LONG_OPTS \\\n%s\n\n", $long_opts;
+printf "#define CEC_OPT_FEATURES \\\n%s\n\n", $opt_features;
+printf "#define CEC_USAGE \\\n%s\n\n", $help_features;
+printf "%s%s\n", $enums, $arg_structs;
+printf "static const struct message messages[] = {\n\t{\n";
+printf "%s\t}\n};\n\n", $messages;
+printf "static void usage_options(int ch)\n{\n";
+printf "%s}\n\n", $help;
+printf "static void parse_msg_args(struct cec_msg &msg, bool reply, const message *opt, int ch)\n{\n";
+printf "\tchar *value, *subs = optarg;\n\n";
+printf "\tswitch (ch) {\n";
+$switch =~ s/service_id_method, dig_bcast_system, transport_id, service_id, orig_network_id, program_number, channel_number_fmt, major, minor/args2digital_service_id(service_id_method, dig_bcast_system, transport_id, service_id, orig_network_id, program_number, channel_number_fmt, major, minor)/g;
+printf "%s", $switch;
+printf "\t}\n};\n\n";
+
+print <<'EOF';
+static void log_msg(struct cec_msg &msg)
+{
+	if (msg.len == 1)
+		printf("CEC_MSG_POLL:\n");
+	if (msg.status && msg.status != CEC_TX_STATUS_FEATURE_ABORT) {
+		printf("\t%s\n", status2s(msg.status).c_str());
+		return;
+	}
+	if (msg.len == 1)
+		return;
+
+	switch (msg.msg[1]) {
+EOF
+printf "%s", $logswitch;
+print <<'EOF';
+	default: {
+		__u16 phys_addr = (msg.msg[2] << 8) | msg.msg[3];
+
+		printf("CDC MSG 0x%02x, %d bytes payload\n", msg.msg[4], msg.len - 5);
+		log_arg(&arg_u16, "phys-addr", phys_addr);
+		break;
+	}
+	}
+	break;
+
+	default:
+		printf("MSG %02x, %d bytes payload\n", msg.msg[1], msg.len - 2);
+		break;
+	}
+}
+EOF
-- 
2.1.4

