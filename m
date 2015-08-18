Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-3.cisco.com ([173.38.203.53]:22808 "EHLO
	aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbbHRIjJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Aug 2015 04:39:09 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, m.szyprowski@samsung.com,
	linux-input@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	lars@opdenkamp.eu, kamil@wypas.org, linux@arm.linux.org.uk,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 3/4] cec-compliance: add new CEC compliance utility
Date: Tue, 18 Aug 2015 10:36:37 +0200
Message-Id: <4531e89907ecd5ec380ce7d527f432288322c3ec.1439886496.git.hans.verkuil@cisco.com>
In-Reply-To: <cover.1439886496.git.hans.verkuil@cisco.com>
References: <cover.1439886496.git.hans.verkuil@cisco.com>
In-Reply-To: <cover.1439886496.git.hans.verkuil@cisco.com>
References: <cover.1439886496.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This utility will attempt to test whether the CEC protocol was
implemented correctly.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 configure.ac                            |   1 +
 utils/Makefile.am                       |   1 +
 utils/cec-compliance/Makefile.am        |   3 +
 utils/cec-compliance/cec-compliance.cpp | 926 ++++++++++++++++++++++++++++++++
 utils/cec-compliance/cec-compliance.h   |  87 +++
 5 files changed, 1018 insertions(+)
 create mode 100644 utils/cec-compliance/Makefile.am
 create mode 100644 utils/cec-compliance/cec-compliance.cpp
 create mode 100644 utils/cec-compliance/cec-compliance.h

diff --git a/configure.ac b/configure.ac
index d4e312c..12c2eb9 100644
--- a/configure.ac
+++ b/configure.ac
@@ -26,6 +26,7 @@ AC_CONFIG_FILES([Makefile
 	utils/keytable/Makefile
 	utils/media-ctl/Makefile
 	utils/rds/Makefile
+	utils/cec-compliance/Makefile
 	utils/v4l2-compliance/Makefile
 	utils/v4l2-ctl/Makefile
 	utils/v4l2-dbg/Makefile
diff --git a/utils/Makefile.am b/utils/Makefile.am
index 31b2979..c78e97b 100644
--- a/utils/Makefile.am
+++ b/utils/Makefile.am
@@ -5,6 +5,7 @@ SUBDIRS = \
 	decode_tm6000 \
 	keytable \
 	media-ctl \
+	cec-compliance \
 	v4l2-compliance \
 	v4l2-ctl \
 	v4l2-dbg \
diff --git a/utils/cec-compliance/Makefile.am b/utils/cec-compliance/Makefile.am
new file mode 100644
index 0000000..da4c0ef
--- /dev/null
+++ b/utils/cec-compliance/Makefile.am
@@ -0,0 +1,3 @@
+bin_PROGRAMS = cec-compliance
+
+cec_compliance_SOURCES = cec-compliance.cpp
diff --git a/utils/cec-compliance/cec-compliance.cpp b/utils/cec-compliance/cec-compliance.cpp
new file mode 100644
index 0000000..59db8ab
--- /dev/null
+++ b/utils/cec-compliance/cec-compliance.cpp
@@ -0,0 +1,926 @@
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
+#include <config.h>
+
+#include "cec-compliance.h"
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
+	OptHelp = 'h',
+	OptNoWarnings = 'n',
+	OptTrace = 'T',
+	OptVerbose = 'v',
+	OptVendorID = 'V',
+
+	OptTV,
+	OptRecord,
+	OptTuner,
+	OptPlayback,
+	OptAudio,
+	OptProcessor,
+	OptSwitch,
+	OptCDCOnly,
+	OptUnregistered,
+	OptLast = 256
+};
+
+static char options[OptLast];
+
+static int app_result;
+static int tests_total, tests_ok;
+
+bool show_info;
+bool show_warnings = true;
+unsigned warnings;
+
+static struct option long_options[] = {
+	{"device", required_argument, 0, OptSetDevice},
+	{"help", no_argument, 0, OptHelp},
+	{"no-warnings", no_argument, 0, OptNoWarnings},
+	{"trace", no_argument, 0, OptTrace},
+	{"verbose", no_argument, 0, OptVerbose},
+	{"phys-addr", required_argument, 0, OptPhysAddr},
+	{"vendor-id", required_argument, 0, OptVendorID},
+
+	{"tv", no_argument, 0, OptTV},
+	{"record", no_argument, 0, OptRecord},
+	{"tuner", no_argument, 0, OptTuner},
+	{"playback", no_argument, 0, OptPlayback},
+	{"audio", no_argument, 0, OptAudio},
+	{"processor", no_argument, 0, OptProcessor},
+	{"switch", no_argument, 0, OptSwitch},
+	{"cdc-only", no_argument, 0, OptCDCOnly},
+	{"unregistered", no_argument, 0, OptUnregistered},
+	{0, 0, 0, 0}
+};
+
+static void usage(void)
+{
+	printf("Usage:\n"
+	       "  -d, --device=<dev> Use device <dev> instead of /dev/cec0\n"
+	       "                     If <dev> starts with a digit, then /dev/cec<dev> is used.\n"
+	       "  -h, --help         Display this help message\n"
+	       "  -n, --no-warnings  Turn off warning messages.\n"
+	       "  -T, --trace        Trace all called ioctls.\n"
+	       "  -v, --verbose      Turn on verbose reporting.\n"
+	       "  -a, --phys-addr=<addr>\n"
+	       "		     Use this physical address.\n"
+	       "  -V, --vendor-id=<id>\n"
+	       "		     Use this vendor ID.\n"
+	       "  --tv               This is a TV\n"
+	       "  --record           This is a recording device\n"
+	       "  --tuner            This is a tuner device\n"
+	       "  --playback         This is a playback device\n"
+	       "  --audio            This is an audio system device\n"
+	       "  --processor        This is a processor device\n"
+	       "  --switch           This is a pure CEC switch\n"
+	       "  --cdc-only         This is a CDC-only device\n"
+	       "  --unregistered     This is an unregistered device\n"
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
+	return s.erase(s.length() - 2, 2);
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
+	if (retval < 0)
+		app_result = -1;
+
+	return retval == -1 ? e : (retval ? -1 : 0);
+}
+
+const char *ok(int res)
+{
+	static char buf[100];
+
+	if (res == ENOTTY) {
+		strcpy(buf, "OK (Not Supported)");
+		res = 0;
+	} else {
+		strcpy(buf, "OK");
+	}
+	tests_total++;
+	if (res) {
+		app_result = res;
+		sprintf(buf, "FAIL");
+	} else {
+		tests_ok++;
+	}
+	return buf;
+}
+
+int check_0(const void *p, int len)
+{
+	const __u8 *q = (const __u8 *)p;
+
+	while (len--)
+		if (*q++)
+			return 1;
+	return 0;
+}
+
+static int testCap(struct node *node)
+{
+	struct cec_caps caps;
+
+	memset(&caps, 0xff, sizeof(caps));
+	// Must always be there
+	fail_on_test(doioctl(node, CEC_ADAP_G_CAPS, &caps));
+	fail_on_test(check_0(caps.reserved, sizeof(caps.reserved)));
+	fail_on_test(caps.available_log_addrs == 0 ||
+		     caps.available_log_addrs > CEC_MAX_LOG_ADDRS);
+	fail_on_test((caps.capabilities & CEC_CAP_PASSTHROUGH) &&
+		     !(caps.capabilities & CEC_CAP_IO));
+	return 0;
+}
+
+static int testAdapPhysAddr(struct node *node, __u16 set_phys_addr)
+{
+	__u16 pa = 0xefff;
+
+	fail_on_test(doioctl(node, CEC_ADAP_G_PHYS_ADDR, &pa));
+	fail_on_test(pa == 0xefff);
+	if (node->caps & CEC_CAP_PHYS_ADDR) {
+		fail_on_test(doioctl(node, CEC_ADAP_S_PHYS_ADDR, &set_phys_addr));
+		fail_on_test(doioctl(node, CEC_ADAP_G_PHYS_ADDR, &pa));
+		fail_on_test(pa != set_phys_addr);
+	} else {
+		fail_on_test(doioctl(node, CEC_ADAP_S_PHYS_ADDR, &pa) != ENOTTY);
+	}
+	return 0;
+}
+
+static int testVendorID(struct node *node, __u32 set_vendor_id)
+{
+	__u32 vendor_id = 0xeeeeeeee;
+
+	fail_on_test(doioctl(node, CEC_ADAP_G_VENDOR_ID, &vendor_id));
+	fail_on_test(vendor_id == 0xeeeeeeee);
+	fail_on_test(vendor_id != CEC_VENDOR_ID_NONE &&
+		     (vendor_id & 0xff000000));
+	if (node->caps & CEC_CAP_VENDOR_ID) {
+		vendor_id = 0xeeeeeeee;
+		fail_on_test(doioctl(node, CEC_ADAP_S_VENDOR_ID, &vendor_id) != EINVAL);
+		fail_on_test(doioctl(node, CEC_ADAP_S_VENDOR_ID, &set_vendor_id));
+		fail_on_test(doioctl(node, CEC_ADAP_G_VENDOR_ID, &vendor_id));
+		fail_on_test(vendor_id != set_vendor_id);
+	} else {
+		fail_on_test(doioctl(node, CEC_ADAP_S_VENDOR_ID, &vendor_id) != ENOTTY);
+	}
+	return 0;
+}
+
+static int testAdapState(struct node *node)
+{
+	__u32 state = 0xffffffff;
+
+	fail_on_test(doioctl(node, CEC_ADAP_G_STATE, &state));
+	fail_on_test(state > CEC_ADAP_ENABLED);
+	if (node->caps & CEC_CAP_STATE) {
+		state = CEC_ADAP_DISABLED;
+		fail_on_test(doioctl(node, CEC_ADAP_S_STATE, &state));
+		fail_on_test(doioctl(node, CEC_ADAP_G_STATE, &state));
+		fail_on_test(state != CEC_ADAP_DISABLED);
+		state = CEC_ADAP_ENABLED;
+		fail_on_test(doioctl(node, CEC_ADAP_S_STATE, &state));
+		fail_on_test(doioctl(node, CEC_ADAP_G_STATE, &state));
+		fail_on_test(state != CEC_ADAP_ENABLED);
+
+		/*
+		 * Do this again, thus guaranteeing that there is always
+		 * a disabled -> enabled and an enabled -> disabled state
+		 * transition tested.
+		 */
+		state = CEC_ADAP_DISABLED;
+		fail_on_test(doioctl(node, CEC_ADAP_S_STATE, &state));
+		fail_on_test(doioctl(node, CEC_ADAP_G_STATE, &state));
+		fail_on_test(state != CEC_ADAP_DISABLED);
+		state = CEC_ADAP_ENABLED;
+		fail_on_test(doioctl(node, CEC_ADAP_S_STATE, &state));
+		fail_on_test(doioctl(node, CEC_ADAP_G_STATE, &state));
+		fail_on_test(state != CEC_ADAP_ENABLED);
+	} else {
+		fail_on_test(doioctl(node, CEC_ADAP_S_STATE, &state) != ENOTTY);
+	}
+	return 0;
+}
+
+static int testAdapLogAddrs(struct node *node, unsigned flags,
+			    const char *osd_name)
+{
+	struct cec_log_addrs laddrs;
+
+	memset(&laddrs, 0xff, sizeof(laddrs));
+	fail_on_test(doioctl(node, CEC_ADAP_G_LOG_ADDRS, &laddrs));
+	fail_on_test(check_0(laddrs.reserved, sizeof(laddrs.reserved)));
+	fail_on_test(laddrs.cec_version != CEC_OP_CEC_VERSION_1_4 &&
+		     laddrs.cec_version != CEC_OP_CEC_VERSION_2_0);
+	fail_on_test(laddrs.num_log_addrs > CEC_MAX_LOG_ADDRS);
+	if (node->caps & CEC_CAP_LOG_ADDRS) {
+		memset(&laddrs, 0, sizeof(laddrs));
+		fail_on_test(doioctl(node, CEC_ADAP_S_LOG_ADDRS, &laddrs));
+		fail_on_test(laddrs.num_log_addrs != 0);
+		fail_on_test(doioctl(node, CEC_ADAP_G_LOG_ADDRS, &laddrs));
+		fail_on_test(laddrs.num_log_addrs != 0);
+
+		memset(&laddrs, 0, sizeof(laddrs));
+		laddrs.cec_version = CEC_OP_CEC_VERSION_2_0;
+		strcpy(laddrs.osd_name, osd_name);
+		for (unsigned i = 0; i < 8; i++) {
+			unsigned la_type;
+			unsigned all_dev_type;
+
+			if (!(flags & (1 << i)))
+				continue;
+			fail_on_test(laddrs.num_log_addrs == node->available_log_addrs);
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
+		fail_on_test(doioctl(node, CEC_ADAP_S_LOG_ADDRS, &laddrs));
+		fail_on_test(laddrs.num_log_addrs == 0 ||
+			     laddrs.num_log_addrs > CEC_MAX_LOG_ADDRS);
+		node->num_log_addrs = laddrs.num_log_addrs;
+		memcpy(node->log_addr, laddrs.log_addr, laddrs.num_log_addrs);
+		fail_on_test(doioctl(node, CEC_ADAP_S_LOG_ADDRS, &laddrs) != EBUSY);
+	} else {
+		node->num_log_addrs = laddrs.num_log_addrs;
+		memcpy(node->log_addr, laddrs.log_addr, laddrs.num_log_addrs);
+		fail_on_test(doioctl(node, CEC_ADAP_S_LOG_ADDRS, &laddrs) != ENOTTY);
+	}
+	return 0;
+}
+
+static int testTopologyDevice(struct node *node, unsigned i, unsigned la)
+{
+	struct cec_msg msg = { };
+	char osd_name[15];
+
+	printf("\tSystem Information for device %d (%s) from device %d (%s):\n",
+	       i, la2s(i), la, la2s(la));
+
+	cec_msg_init(&msg, la, i);
+	cec_msg_get_cec_version(&msg, true);
+	fail_on_test(doioctl(node, CEC_TRANSMIT, &msg));
+	printf("\t\tCEC Version                : ");
+	if (msg.status)
+		warn("%s\n", status2s(msg.status).c_str());
+	else
+		printf("%s\n", version2s(msg.msg[2]));
+
+	cec_msg_init(&msg, la, i);
+	cec_msg_give_physical_addr(&msg, true);
+	doioctl(node, CEC_TRANSMIT, &msg);
+	printf("\t\tPhysical Address           : ");
+	if (msg.status) {
+		warn("\n%s\n", status2s(msg.status).c_str());
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
+		warn("\n%s\n", status2s(msg.status).c_str());
+	else
+		printf("0x%02x%02x%02x\n",
+		       msg.msg[2], msg.msg[3], msg.msg[4]);
+
+	cec_msg_init(&msg, la, i);
+	cec_msg_give_device_power_status(&msg, true);
+	doioctl(node, CEC_TRANSMIT, &msg);
+	printf("\t\tPower Status               : ");
+	if (msg.status)
+		warn("\n%s\n", status2s(msg.status).c_str());
+	else
+		printf("%s\n", power_status2s(msg.msg[2]));
+
+	cec_msg_init(&msg, la, i);
+	cec_msg_give_osd_name(&msg, true);
+	doioctl(node, CEC_TRANSMIT, &msg);
+	cec_ops_set_osd_name(&msg, osd_name);
+	printf("\t\tOSD Name                   : ");
+	if (msg.status)
+		warn("\n%s\n", status2s(msg.status).c_str());
+	else
+		printf("%s\n", osd_name);
+	return 0;
+}
+
+static int testTopology(struct node *node)
+{
+	struct cec_msg msg = { };
+	struct cec_log_addrs laddrs = { };
+
+	fail_on_test(doioctl(node, CEC_ADAP_G_LOG_ADDRS, &laddrs));
+
+	if (!(node->caps & CEC_CAP_IO)) {
+		cec_msg_init(&msg, 0xf, 0);
+		fail_on_test(doioctl(node, CEC_TRANSMIT, &msg) != ENOTTY);
+		return -ENOTTY;
+	}
+
+	for (unsigned i = 0; i < 15; i++) {
+		int ret;
+
+		cec_msg_init(&msg, 0xf, i);
+		ret = doioctl(node, CEC_TRANSMIT, &msg);
+
+		switch (msg.status) {
+		case CEC_TX_STATUS_OK:
+			fail_on_test(testTopologyDevice(node, i, laddrs.log_addr[0]));
+			break;
+		case CEC_TX_STATUS_ARB_LOST:
+			warn("tx arbitration lost for addr %d\n", i);
+			break;
+		case CEC_TX_STATUS_RETRY_TIMEOUT:
+			break;
+		default:
+			return fail("ret ? %d\n", ret);
+		}
+	}
+	return 0;
+}
+
+static int testARC(struct node *node)
+{
+	struct cec_msg msg = { };
+	struct cec_log_addrs laddrs = { };
+	unsigned la;
+	unsigned i;
+
+	fail_on_test(doioctl(node, CEC_ADAP_G_LOG_ADDRS, &laddrs));
+	la = laddrs.log_addr[0];
+
+	for (i = 0; i < 15; i++) {
+		if (i == la)
+			continue;
+		cec_msg_init(&msg, la, i);
+		cec_msg_initiate_arc(&msg, true);
+		fail_on_test(doioctl(node, CEC_TRANSMIT, &msg));
+		if (msg.status == 0) {
+			cec_msg_init(&msg, la, i);
+			cec_msg_terminate_arc(&msg, true);
+			msg.reply = CEC_MSG_REPORT_ARC_TERMINATED;
+			fail_on_test(doioctl(node, CEC_TRANSMIT, &msg));
+			fail_on_test(msg.status);
+			printf("logical address %d supports ARC\n", i);
+		} else {
+			printf("logical address %d doesn't support ARC\n", i);
+		}
+	}
+	return 0;
+}
+
+int main(int argc, char **argv)
+{
+	const char *device = "/dev/cec0";	/* -d device */
+	char short_options[26 * 2 * 2 + 1];
+	__u32 vendor_id;
+	__u32 set_vendor_id = 0x000c03; /* HDMI LLC vendor ID */
+	__u16 phys_addr;
+	__u16 set_phys_addr = 0;
+	int idx = 0;
+	int fd = -1;
+	int ch;
+	int i;
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
+
+		short_options[idx] = 0;
+		ch = getopt_long(argc, argv, short_options,
+				 long_options, &option_index);
+		if (ch == -1)
+			break;
+
+		options[(int)ch] = 1;
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
+		case OptNoWarnings:
+			show_warnings = false;
+			break;
+		case OptVerbose:
+			show_info = true;
+			break;
+		case OptPhysAddr:
+			set_phys_addr = strtoul(optarg, NULL, 0);
+			break;
+		case OptVendorID:
+			set_vendor_id = strtoul(optarg, NULL, 0) & 0x00ffffff;
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
+	if (flags == 0)
+		flags |= 1 << CEC_OP_PRIM_DEVTYPE_TV;
+
+	printf("Driver Info:\n");
+	printf("\tCapabilities               : 0x%08x\n", caps.capabilities);
+	printf("%s", caps2s(caps.capabilities).c_str());
+	printf("\tInputs                     : %u\n", caps.ninputs);
+	printf("\tAvailable Logical Addresses: %u\n",
+	       caps.available_log_addrs);
+
+	doioctl(&node, CEC_ADAP_G_PHYS_ADDR, &phys_addr);
+	printf("\tPhysical Address           : %x.%x.%x.%x\n",
+	       phys_addr >> 12, (phys_addr >> 8) & 0xf,
+	       (phys_addr >> 4) & 0xf, phys_addr & 0xf);
+	if (!options[OptPhysAddr] && phys_addr == CEC_PHYS_ADDR_INVALID &&
+	    (node.caps & CEC_CAP_PHYS_ADDR))
+		warn("Perhaps you should use option --phys-addr?\n");
+
+	doioctl(&node, CEC_ADAP_G_VENDOR_ID, &vendor_id);
+	if (vendor_id != CEC_VENDOR_ID_NONE)
+		printf("\tVendor ID                  : 0x%06x\n", vendor_id);
+
+	__u32 adap_state;
+	doioctl(&node, CEC_ADAP_G_STATE, &adap_state);
+	printf("\tAdapter State              : %s\n", adap_state ? "Enabled" : "Disabled");
+
+	struct cec_log_addrs laddrs = { };
+	doioctl(&node, CEC_ADAP_G_LOG_ADDRS, &laddrs);
+	printf("\tCEC Version                : %s\n", version2s(laddrs.cec_version));
+	printf("\tLogical Addresses          : %u\n", laddrs.num_log_addrs);
+	for (unsigned i = 0; i < laddrs.num_log_addrs; i++) {
+		printf("\t  Logical Address          : %d\n",
+		       laddrs.log_addr[i]);
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
+
+	printf("\nCompliance test for device %s:\n\n", device);
+
+	/* Required ioctls */
+
+	printf("Required ioctls:\n");
+	printf("\ttest CEC_ADAP_G_CAPS: %s\n", ok(testCap(&node)));
+	if (options[OptPhysAddr] || phys_addr == CEC_PHYS_ADDR_INVALID)
+		phys_addr = set_phys_addr;
+	printf("\ttest CEC_ADAP_G/S_PHYS_ADDR: %s\n", ok(testAdapPhysAddr(&node, phys_addr)));
+	if (options[OptVendorID] || vendor_id == CEC_VENDOR_ID_NONE)
+		vendor_id = set_vendor_id;
+	printf("\ttest CEC_ADAP_G/S_VENDOR_ID: %s\n", ok(testVendorID(&node, vendor_id)));
+	printf("\ttest CEC_ADAP_G/S_STATE: %s\n", ok(testAdapState(&node)));
+	printf("\ttest CEC_ADAP_G/S_LOG_ADDRS: %s\n", ok(testAdapLogAddrs(&node, flags, osd_name)));
+	printf("\ttest CEC topology discovery: %s\n", ok(testTopology(&node)));
+	printf("\ttest CEC ARC: %s\n", ok(testARC(&node)));
+	printf("\n");
+
+	/* Final test report */
+
+	close(fd);
+	printf("Total: %d, Succeeded: %d, Failed: %d, Warnings: %d\n",
+			tests_total, tests_ok, tests_total - tests_ok, warnings);
+	exit(app_result);
+}
diff --git a/utils/cec-compliance/cec-compliance.h b/utils/cec-compliance/cec-compliance.h
new file mode 100644
index 0000000..cd02c24
--- /dev/null
+++ b/utils/cec-compliance/cec-compliance.h
@@ -0,0 +1,87 @@
+/*
+    CEC API compliance test tool.
+
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
+#ifndef _CEC_COMPLIANCE_H_
+#define _CEC_COMPLIANCE_H_
+
+#include <stdarg.h>
+#include <cerrno>
+#include <string>
+#include <linux/cec-funcs.h>
+
+extern bool show_info;
+extern bool show_warnings;
+extern unsigned warnings;
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
+#define info(fmt, args...) 					\
+	do {							\
+		if (show_info)					\
+ 			printf("\t\tinfo: " fmt, ##args);	\
+	} while (0)
+
+#define warn(fmt, args...) 					\
+	do {							\
+		warnings++;					\
+		if (show_warnings)				\
+ 			printf("\t\twarn: %s(%d): " fmt, __FILE__, __LINE__, ##args);	\
+	} while (0)
+
+#define warn_once(fmt, args...)						\
+	do {								\
+		static bool show;					\
+									\
+		if (!show) {						\
+			show = true;					\
+			warnings++;					\
+			if (show_warnings)				\
+				printf("\t\twarn: %s(%d): " fmt,	\
+					__FILE__, __LINE__, ##args); 	\
+		}							\
+	} while (0)
+
+#define fail(fmt, args...) 						\
+({ 									\
+ 	printf("\t\tfail: %s(%d): " fmt, __FILE__, __LINE__, ##args);	\
+	1;								\
+})
+
+#define fail_on_test(test) 				\
+	do {						\
+	 	if (test)				\
+			return fail("%s\n", #test);	\
+	} while (0)
+
+int cec_named_ioctl(int fd, const char *name,
+		    unsigned long int request, void *parm);
+
+#define doioctl(n, r, p) cec_named_ioctl((n)->fd, #r, r, p)
+
+const char *ok(int res);
+
+// CEC core tests
+int testCore(struct node *node);
+
+#endif
-- 
2.1.4

