Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:41921 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751741AbbF2KoH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jun 2015 06:44:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, m.szyprowski@samsung.com,
	linux-input@vger.kernel.org, lars@opdenkamp.eu,
	linux-samsung-soc@vger.kernel.org, kamil@wypas.org,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 4/4] cec-ctl: CEC control utility
Date: Mon, 29 Jun 2015 12:43:16 +0200
Message-Id: <1435574596-38029-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1435574596-38029-1-git-send-email-hverkuil@xs4all.nl>
References: <1435574596-38029-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Generic CEC utility that can be used to send/receive/monitor CEC
messages.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 configure.ac              |    1 +
 utils/Makefile.am         |    1 +
 utils/cec-ctl/Makefile.am |    8 +
 utils/cec-ctl/cec-ctl.cpp | 1000 +++++++++++++++++++++++++++++++++++++++++++++
 utils/cec-ctl/msg2ctl.pl  |  330 +++++++++++++++
 5 files changed, 1340 insertions(+)
 create mode 100644 utils/cec-ctl/Makefile.am
 create mode 100644 utils/cec-ctl/cec-ctl.cpp
 create mode 100755 utils/cec-ctl/msg2ctl.pl

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
index 0000000..1d0f663
--- /dev/null
+++ b/utils/cec-ctl/cec-ctl.cpp
@@ -0,0 +1,1000 @@
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
+#include "cec-ctl-gen.h"
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
+	OptSetDevice = 'd',
+	OptAdapDisable = 'D',
+	OptAdapEnable = 'E',
+	OptFrom = 'f',
+	OptHelp = 'h',
+	OptNoReply = 'n',
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
+static const struct message *msg2message[256];
+static const struct message *opt2message[OptLast - OptMessages];
+
+static void init_messages()
+{
+	for (unsigned i = 0; messages[i].msg_name; i++) {
+		opt2message[messages[i].option - OptMessages] = &messages[i];
+		msg2message[messages[i].msg] = &messages[i];
+	}
+}
+
+static struct option long_options[] = {
+	{ "device", required_argument, 0, OptSetDevice },
+	{ "help", no_argument, 0, OptHelp },
+	{ "trace", no_argument, 0, OptTrace },
+	{ "verbose", no_argument, 0, OptVerbose},
+	{ "phys-addr", required_argument, 0, OptPhysAddr },
+	{ "vendor-id", required_argument, 0, OptVendorID },
+	{ "cec-version-1.4", no_argument, 0, OptCECVersion1_4 },
+	{ "enable", no_argument, 0, OptAdapEnable },
+	{ "disable", no_argument, 0, OptAdapDisable },
+	{ "no-reply", no_argument, 0, OptNoReply },
+	{ "to", required_argument, 0, OptTo },
+	{ "from", required_argument, 0, OptFrom },
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
+	       "  -V, --vendor-id=<id>\n"
+	       "		     Use this vendor ID.\n"
+	       "  -n, --no-reply     Don't wait for a reply.\n"
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
+	if (caps & CEC_CAP_TRANSMIT)
+		s += "\t\tTransmit\n";
+	if (caps & CEC_CAP_RECEIVE)
+		s += "\t\tReceive\n";
+	if (caps & CEC_CAP_VENDOR_ID)
+		s += "\t\tVendor ID\n";
+	if (caps & CEC_CAP_PASSTHROUGH)
+		s += "\t\tPassthrough\n";
+	if (caps & CEC_CAP_RC)
+		s += "\t\tRemote Control Support\n";
+	if (caps & CEC_CAP_ARC)
+		s += "\t\tAudio Return Channel\n";
+	if (caps & CEC_CAP_CDC)
+		s += "\t\tCapability Discovery and Control\n";
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
+static std::string la_flags2s(unsigned flags)
+{
+	std::string s;
+
+	if (flags & CEC_LOG_ADDRS_FL_HANDLE_MSGS)
+		s += "Userspace Handles Messages";
+	return s;
+}
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
+static std::string all_dev_types2s(unsigned types)
+{
+	std::string s;
+
+	if (types & CEC_FL_ALL_DEVTYPE_TV)
+		s += "TV, ";
+	if (types & CEC_FL_ALL_DEVTYPE_RECORD)
+		s += "Record, ";
+	if (types & CEC_FL_ALL_DEVTYPE_TUNER)
+		s += "Tuner, ";
+	if (types & CEC_FL_ALL_DEVTYPE_PLAYBACK)
+		s += "Playback, ";
+	if (types & CEC_FL_ALL_DEVTYPE_AUDIOSYSTEM)
+		s += "Audio System, ";
+	if (types & CEC_FL_ALL_DEVTYPE_SWITCH)
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
+static bool validMsgStatus(const struct cec_msg &msg)
+{
+	if (msg.status == 0)
+		return true;
+	std::string s = status2s(msg.status);
+	printf("\t\t%s\n", s.c_str());
+	return false;
+}
+
+static int showTopologyDevice(struct node *node, unsigned i, unsigned la)
+{
+	struct cec_msg msg = { };
+
+	printf("\tSystem Information for device %d (%s) from device %d (%s):\n",
+	       i, la2s(i), la, la2s(la));
+
+	msg.len = 2;
+	msg.msg[0] = (la << 4) | (i & 0xf);
+	msg.msg[1] = CEC_MSG_GET_CEC_VERSION;
+	msg.reply = CEC_MSG_CEC_VERSION;
+	doioctl(node, CEC_TRANSMIT, &msg);
+	if (validMsgStatus(msg))
+		printf("\t\tCEC Version                : %s\n", version2s(msg.msg[2]));
+
+	msg.len = 2;
+	msg.msg[0] = (la << 4) | (i & 0xf);
+	msg.msg[1] = CEC_MSG_GIVE_PHYSICAL_ADDR;
+	msg.reply = CEC_MSG_REPORT_PHYSICAL_ADDR;
+	doioctl(node, CEC_TRANSMIT, &msg);
+	validMsgStatus(msg);
+	__u16 phys_addr = (msg.msg[2] << 8) | msg.msg[3];
+	printf("\t\tPhysical Address           : %x.%x.%x.%x\n",
+	       phys_addr >> 12, (phys_addr >> 8) & 0xf,
+	       (phys_addr >> 4) & 0xf, phys_addr & 0xf);
+	printf("\t\tPrimary Device Type        : %s\n",
+	       prim_type2s(msg.msg[4]));
+
+	msg.len = 2;
+	msg.msg[0] = (la << 4) | (i & 0xf);
+	msg.msg[1] = CEC_MSG_GIVE_DEVICE_VENDOR_ID;
+	msg.reply = CEC_MSG_DEVICE_VENDOR_ID;
+	doioctl(node, CEC_TRANSMIT, &msg);
+	if (validMsgStatus(msg))
+		printf("\t\tVendor ID                  : 0x%02x%02x%02x\n",
+		       msg.msg[2], msg.msg[3], msg.msg[4]);
+
+	msg.len = 2;
+	msg.msg[0] = (la << 4) | (i & 0xf);
+	msg.msg[1] = CEC_MSG_GIVE_DEVICE_POWER_STATUS;
+	msg.reply = CEC_MSG_REPORT_POWER_STATUS;
+	doioctl(node, CEC_TRANSMIT, &msg);
+	if (validMsgStatus(msg))
+		printf("\t\tPower Status               : %s\n",
+			power_status2s(msg.msg[2]));
+
+	msg.len = 2;
+	msg.msg[0] = (la << 4) | (i & 0xf);
+	msg.msg[1] = CEC_MSG_GIVE_OSD_NAME;
+	msg.reply = CEC_MSG_SET_OSD_NAME;
+	doioctl(node, CEC_TRANSMIT, &msg);
+	if (validMsgStatus(msg)) {
+		char s[15];
+
+		memset(s, 0, sizeof(s));
+		memcpy(s, msg.msg + 2, msg.len - 2);
+		printf("\t\tOSD Name                   : %s\n", s);
+	}
+	return 0;
+}
+
+static int showTopology(struct node *node)
+{
+	struct cec_msg msg = { };
+	struct cec_log_addrs laddrs = { };
+
+	doioctl(node, CEC_G_ADAP_LOG_ADDRS, &laddrs);
+
+	if (!(node->caps & CEC_CAP_TRANSMIT)) {
+		msg.len = 1;
+		msg.msg[0] = 15 << 4;
+		doioctl(node, CEC_TRANSMIT, &msg);
+		return -ENOTTY;
+	}
+
+	for (unsigned i = 0; i < 15; i++) {
+		int ret;
+
+		msg.len = 1;
+		msg.msg[0] = (15 << 4) | (i & 0xf);
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
+#if 0
+static int testARC(struct node *node)
+{
+	struct cec_msg msg = { };
+	struct cec_log_addrs laddrs = { };
+	unsigned la;
+	unsigned i;
+
+	doioctl(node, CEC_G_ADAP_LOG_ADDRS, &laddrs);
+	la = laddrs.log_addr[0];
+
+	for (i = 0; i < 15; i++) {
+		if (i == la)
+			continue;
+		msg.len = 2;
+		msg.msg[0] = (la << 4) | (i & 0xf);
+		msg.msg[1] = CEC_MSG_INITIATE_ARC;
+		msg.reply = CEC_MSG_REPORT_ARC_INITIATED;
+		doioctl(node, CEC_TRANSMIT, &msg);
+		if (msg.status == 0) {
+			msg.len = 2;
+			msg.msg[0] = (la << 4) | (i & 0xf);
+			msg.msg[1] = CEC_MSG_TERMINATE_ARC;
+			msg.reply = CEC_MSG_REPORT_ARC_TERMINATED;
+			doioctl(node, CEC_TRANSMIT, &msg);
+			printf("logical address %d supports ARC\n", i);
+		} else {
+			printf("logical address %d doesn't support ARC\n", i);
+		}
+	}
+	return 0;
+}
+#endif
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
+			adap_state = CEC_STATE_DISABLED;
+			break;
+		case OptAdapEnable:
+			adap_state = CEC_STATE_ENABLED;
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
+	doioctl(&node, CEC_G_CAPS, &caps);
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
+	printf("\tAvailable Logical Addresses: %u\n",
+	       caps.available_log_addrs);
+
+	if ((node.caps & CEC_CAP_PHYS_ADDR) && options[OptPhysAddr])
+		doioctl(&node, CEC_S_ADAP_PHYS_ADDR, &phys_addr);
+	doioctl(&node, CEC_G_ADAP_PHYS_ADDR, &phys_addr);
+	printf("\tPhysical Address           : %x.%x.%x.%x\n",
+	       phys_addr >> 12, (phys_addr >> 8) & 0xf,
+	       (phys_addr >> 4) & 0xf, phys_addr & 0xf);
+	if (!options[OptPhysAddr] && phys_addr == 0xffff &&
+	    (node.caps & CEC_CAP_PHYS_ADDR))
+		printf("Perhaps you should use option --phys-addr?\n");
+
+	if (node.caps & CEC_CAP_VENDOR_ID) {
+		if (!options[OptVendorID]) {
+			doioctl(&node, CEC_G_VENDOR_ID, &vendor_id);
+			if (vendor_id == CEC_VENDOR_ID_NONE)
+				vendor_id = 0x000c03; /* HDMI LLC vendor ID */
+		}
+		doioctl(&node, CEC_S_VENDOR_ID, &vendor_id);
+	}
+	doioctl(&node, CEC_G_VENDOR_ID, &vendor_id);
+	if (vendor_id != CEC_VENDOR_ID_NONE)
+		printf("\tVendor ID                  : 0x%06x\n", vendor_id);
+
+	if ((node.caps & CEC_CAP_STATE) &&
+	    (options[OptAdapEnable] || options[OptAdapDisable]))
+		doioctl(&node, CEC_S_ADAP_STATE, &adap_state);
+	doioctl(&node, CEC_G_ADAP_STATE, &adap_state);
+	printf("\tAdapter State              : %s\n", adap_state ? "Enabled" : "Disabled");
+	if (adap_state == CEC_STATE_DISABLED)
+		return 0;
+
+	if ((node.caps & CEC_CAP_LOG_ADDRS) && flags) {
+		struct cec_log_addrs laddrs;
+
+		memset(&laddrs, 0, sizeof(laddrs));
+		doioctl(&node, CEC_S_ADAP_LOG_ADDRS, &laddrs);
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
+				all_dev_type = CEC_FL_ALL_DEVTYPE_TV;
+				break;
+			case CEC_OP_PRIM_DEVTYPE_RECORD:
+				la_type = CEC_LOG_ADDR_TYPE_RECORD;
+				all_dev_type = CEC_FL_ALL_DEVTYPE_RECORD;
+				break;
+			case CEC_OP_PRIM_DEVTYPE_TUNER:
+				la_type = CEC_LOG_ADDR_TYPE_TUNER;
+				all_dev_type = CEC_FL_ALL_DEVTYPE_TUNER;
+				break;
+			case CEC_OP_PRIM_DEVTYPE_PLAYBACK:
+				la_type = CEC_LOG_ADDR_TYPE_PLAYBACK;
+				all_dev_type = CEC_FL_ALL_DEVTYPE_PLAYBACK;
+				break;
+			case CEC_OP_PRIM_DEVTYPE_AUDIOSYSTEM:
+				la_type = CEC_LOG_ADDR_TYPE_AUDIOSYSTEM;
+				all_dev_type = CEC_FL_ALL_DEVTYPE_AUDIOSYSTEM;
+				break;
+			case CEC_OP_PRIM_DEVTYPE_PROCESSOR:
+				la_type = CEC_LOG_ADDR_TYPE_SPECIFIC;
+				all_dev_type = CEC_FL_ALL_DEVTYPE_SWITCH;
+				break;
+			case CEC_OP_PRIM_DEVTYPE_SWITCH:
+			default:
+				la_type = CEC_LOG_ADDR_TYPE_UNREGISTERED;
+				all_dev_type = CEC_FL_ALL_DEVTYPE_SWITCH;
+				break;
+			}
+			laddrs.log_addr_type[laddrs.num_log_addrs] = la_type;
+			laddrs.all_device_types[laddrs.num_log_addrs] = all_dev_type;
+			laddrs.flags[laddrs.num_log_addrs] = CEC_LOG_ADDRS_FL_HANDLE_MSGS;
+			laddrs.primary_device_type[laddrs.num_log_addrs++] = i;
+		}
+
+		doioctl(&node, CEC_S_ADAP_LOG_ADDRS, &laddrs);
+	}
+
+	struct cec_log_addrs laddrs = { };
+	doioctl(&node, CEC_G_ADAP_LOG_ADDRS, &laddrs);
+	node.num_log_addrs = laddrs.num_log_addrs;
+	printf("\tCEC Version                : %s\n", version2s(laddrs.cec_version));
+	printf("\tLogical Addresses          : %u\n", laddrs.num_log_addrs);
+	for (unsigned i = 0; i < laddrs.num_log_addrs; i++) {
+		printf("\t  Logical Address          : %d\n",
+		       laddrs.log_addr[i]);
+		printf("\t    Primary Device Type    : %s\n",
+		       prim_type2s(laddrs.primary_device_type[i]));
+		printf("\t    Logical Address Type   : %s\n",
+		       la_type2s(laddrs.log_addr_type[i]));
+		printf("\t    Flags                  : %s\n",
+		       la_flags2s(laddrs.flags[i]).c_str());
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
+				printf("\t    Device Features        :\n%s\n",
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
+	if (node.num_log_addrs == 0)
+		return 0;
+	if (!options[OptFrom])
+		from = laddrs.log_addr[0];
+
+	showTopology(&node);
+
+	for (msg_vec::iterator iter = msgs.begin(); iter != msgs.end(); ++iter) {
+		if (!options[OptTo]) {
+			fprintf(stderr, "attempting to send message without --to\n");
+			exit(1);
+		}
+		struct cec_msg msg = *iter;
+
+		opt = msg2message[msg.msg[1]];
+
+		printf("Transmit %s\n", opt->msg_name);
+		msg.msg[0] |= (from << 4) | to;
+		doioctl(&node, CEC_TRANSMIT, &msg);
+		validMsgStatus(msg);
+	}
+
+	close(fd);
+	return 0;
+}
diff --git a/utils/cec-ctl/msg2ctl.pl b/utils/cec-ctl/msg2ctl.pl
new file mode 100755
index 0000000..0611696
--- /dev/null
+++ b/utils/cec-ctl/msg2ctl.pl
@@ -0,0 +1,330 @@
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
+	if ($has_digital) {
+		$func_args =~ s/const struct cec_op_digital_service_id \*digital/__u8 service_id_method, __u8 dig_bcast_system, __u16 transport_id, __u16 service_id, __u16 orig_network_id, __u16 program_number, __u8 channel_number_fmt, __u16 major, __u16 minor/;
+	}
+	my @args = split(/, */, $func_args);
+	return if ($func_args =~ /struct/);
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
+	$options .= "\tOpt$opt,\n";
+	$messages .= "\t\t$cec_msg,\n";
+	$messages .= "\t\tOpt$opt,\n";
+	if (@args == 0) {
+		$messages .= "\t\t0, { }, { },\n";
+		$long_opts .= "\t{ \"$msg_dash_name\", no_argument, 0, Opt$opt }, \\\n";
+		$usage .= "\t\"  --" . sprintf("%-30s", $msg_dash_name) . "Send $msg_name message\\n\"\n";
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
+			($type, $name) = /(.*?) ?([a-zA-Z_]+)$/;
+			$name =~ s/_/-/g;
+			$usage .= "$sep$name=<val>";
+			$sep = ",";
+		}
+		$usage .= "\\n\"\n";
+		foreach (@args) {
+			($type, $name) = /(.*?) ?([a-zA-Z_]+)$/;
+			@enum = @{$types{$name}};
+			next if !scalar(@enum);
+			$name =~ s/_/-/g;
+			$usage .= $prefix . "'$name' can have these values:\\n\"\n";
+			my $common_prefix = maxprefix(@enum);
+			foreach (@enum) {
+				s/^$common_prefix//;
+				s/([A-Z])/\l\1/g;
+				s/_/-/g;
+				$usage .= $prefix . "    $_\\n\"\n";
+			}
+		}
+		$usage .= $prefix . "Send $msg_name message\\n\"\n";
+		$usage_msg{$msg} = $usage;
+		$switch .= "\tcase Opt$opt: {\n";
+		foreach (@args) {
+			($type, $name) = /(.*?) ?([a-zA-Z_]+)$/;
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
+			($type, $name) = /(.*?) ?([a-zA-Z_]+)$/;
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
+			($type, $name) = /(.*?) ?([a-zA-Z_]+)$/;
+			$switch .= ", $name";
+		}
+		$switch .= ");\n\t\tbreak;\n\t}\n\n";
+
+		foreach (@args) {
+			($type, $name) = /(.*?) ?([a-zA-Z_]+)$/;
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
+			($type, $name) = /(.*?) ?([a-zA-Z_]+)$/;
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
+				$arg_structs .= "static const struct arg arg_$name = {\n";
+				if ($type eq "__u8") {
+					if ($size) {
+						$arg_structs .= "\tCEC_TYPE_ENUM, $size, type_$name\n";
+					} else {
+						$arg_structs .= "\tCEC_TYPE_U8,\n";
+					}
+				} elsif ($type eq "__u16") {
+					$arg_structs .= "\tCEC_TYPE_U16,\n";
+				} elsif ($type eq "__u32") {
+					$arg_structs .= "\tCEC_TYPE_U32,\n";
+				} elsif ($type eq "const char *") {
+					$arg_structs .= "\tCEC_TYPE_STRING,\n";
+				}
+				$arg_structs .= "};\n\n";
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
+	last if /\/\* Events \*\//;
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
+	last if /_CEC_FUNCS_H/;
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
-- 
2.1.4

