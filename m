Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34661 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932429Ab2EPT17 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 May 2012 15:27:59 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so1058531wgb.1
        for <linux-media@vger.kernel.org>; Wed, 16 May 2012 12:27:58 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 2/2] refactored for user properties
Date: Wed, 16 May 2012 21:27:21 +0200
Message-Id: <1337196441-15180-2-git-send-email-neolynx@gmail.com>
In-Reply-To: <1337196441-15180-1-git-send-email-neolynx@gmail.com>
References: <1337196441-15180-1-git-send-email-neolynx@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 lib/include/dvb-fe.h                        |    4 +-
 lib/include/dvb-file.h                      |   13 +-
 lib/include/dvb-v5-std.h                    |   70 ++
 lib/include/libsat.h                        |    8 +-
 lib/libdvbv5/Makefile.am                    |    4 +-
 lib/libdvbv5/descriptors.c                  |    1 +
 lib/libdvbv5/dvb-fe.c                       |    2 +-
 lib/libdvbv5/dvb-file.c                     |   93 ++-
 lib/libdvbv5/dvb-legacy-channel-format.c    |    2 +
 lib/libdvbv5/{dvb-v5-std.h => dvb-v5-std.c} |   27 +-
 lib/libdvbv5/dvb-v5.c                       |  230 +++++++
 lib/libdvbv5/dvb-v5.h                       |  245 +-------
 lib/libdvbv5/dvb-zap-format.c               |    1 +
 lib/libdvbv5/dvb_frontend.h                 |  436 +++++++++++++
 lib/libdvbv5/gen_dvb_structs.pl             |  899 ++++++++++++++-------------
 lib/libdvbv5/libsat.c                       |    7 +-
 utils/dvb/dvbv5-scan.c                      |    5 +-
 17 files changed, 1331 insertions(+), 716 deletions(-)
 create mode 100644 lib/include/dvb-v5-std.h
 rename lib/libdvbv5/{dvb-v5-std.h => dvb-v5-std.c} (88%)
 create mode 100644 lib/libdvbv5/dvb-v5.c
 create mode 100644 lib/libdvbv5/dvb_frontend.h

diff --git a/lib/include/dvb-fe.h b/lib/include/dvb-fe.h
index fbb5ff0..28350d9 100644
--- a/lib/include/dvb-fe.h
+++ b/lib/include/dvb-fe.h
@@ -81,7 +81,7 @@ struct dvb_v5_fe_parms {
 	unsigned			freq_bpf;
 
 	/* Satellite specific stuff, used internally */
-	enum dvbsat_polarization        pol;
+	//enum dvb_sat_polarization       pol;
 	int				high_band;
 	unsigned			diseqc_wait;
 	unsigned			freq_offset;
@@ -164,7 +164,7 @@ int dvb_fe_diseqc_reply(struct dvb_v5_fe_parms *parms, unsigned *len, char *buf,
 
 extern const unsigned fe_bandwidth_name[8];
 extern const char *dvb_v5_name[46];
-extern const void *dvbv5_attr_names[];
+extern const void *dvb_v5_attr_names[];
 extern const char *delivery_system_name[20];
 
 #endif
diff --git a/lib/include/dvb-file.h b/lib/include/dvb-file.h
index b86d4bf..7a605b3 100644
--- a/lib/include/dvb-file.h
+++ b/lib/include/dvb-file.h
@@ -35,7 +35,7 @@ struct dvb_entry {
 
 	char *location;
 
-	enum dvbsat_polarization pol;
+//	enum dvbsat_polarization pol;
 	int sat_number;
 	unsigned freq_bpf;
 	unsigned diseqc_wait;
@@ -78,17 +78,6 @@ enum file_formats {
 
 #define PTABLE(a) .table = a, .size=ARRAY_SIZE(a)
 
-/* FAKE DTV codes, for internal usage */
-#define DTV_POLARIZATION        (DTV_MAX_COMMAND + 200)
-#define DTV_VIDEO_PID           (DTV_MAX_COMMAND + 201)
-#define DTV_AUDIO_PID           (DTV_MAX_COMMAND + 202)
-#define DTV_SERVICE_ID          (DTV_MAX_COMMAND + 203)
-#define DTV_CH_NAME             (DTV_MAX_COMMAND + 204)
-#define DTV_VCHANNEL            (DTV_MAX_COMMAND + 205)
-#define DTV_SAT_NUMBER          (DTV_MAX_COMMAND + 206)
-#define DTV_DISEQC_WAIT         (DTV_MAX_COMMAND + 207)
-#define DTV_DISEQC_LNB          (DTV_MAX_COMMAND + 208)
-#define DTV_FREQ_BPF            (DTV_MAX_COMMAND + 209)
 
 struct dvb_descriptors;
 
diff --git a/lib/include/dvb-v5-std.h b/lib/include/dvb-v5-std.h
new file mode 100644
index 0000000..1145734
--- /dev/null
+++ b/lib/include/dvb-v5-std.h
@@ -0,0 +1,70 @@
+/*
+ * Copyright (c) 2011-2012 - Mauro Carvalho Chehab <mchehab@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation version 2
+ * of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
+ * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
+ *
+ * Per-delivery system properties, according with the specs:
+ * 	http://linuxtv.org/downloads/v4l-dvb-apis/FE_GET_SET_PROPERTY.html
+ */
+#ifndef _DVB_V5_STD_H
+#define _DVB_V5_STD_H
+
+#include <stddef.h>
+#include "dvb-frontend.h"
+
+extern const unsigned int sys_dvbt_props[];
+extern const unsigned int sys_dvbt2_props[];
+extern const unsigned int sys_isdbt_props[];
+extern const unsigned int sys_atsc_props[];
+extern const unsigned int sys_dvbc_annex_ac_props[];
+extern const unsigned int sys_dvbc_annex_b_props[];
+extern const unsigned int sys_dvbs_props[];
+extern const unsigned int sys_dvbs2_props[];
+extern const unsigned int sys_turbo_props[];
+extern const unsigned int sys_isdbs_props[];
+extern const unsigned int *dvb_v5_delivery_system[];
+extern const void *dvb_v5_attr_names[];
+
+/* User DTV codes, for internal usage */
+
+#define DTV_USER_COMMAND_START 256
+
+#define DTV_POLARIZATION        (DTV_USER_COMMAND_START + 0)
+#define DTV_VIDEO_PID           (DTV_USER_COMMAND_START + 1)
+#define DTV_AUDIO_PID           (DTV_USER_COMMAND_START + 2)
+#define DTV_SERVICE_ID          (DTV_USER_COMMAND_START + 3)
+#define DTV_CH_NAME             (DTV_USER_COMMAND_START + 4)
+#define DTV_VCHANNEL            (DTV_USER_COMMAND_START + 5)
+#define DTV_SAT_NUMBER          (DTV_USER_COMMAND_START + 6)
+#define DTV_DISEQC_WAIT         (DTV_USER_COMMAND_START + 7)
+#define DTV_DISEQC_LNB          (DTV_USER_COMMAND_START + 8)
+#define DTV_FREQ_BPF            (DTV_USER_COMMAND_START + 9)
+#define DTV_MAX_USER_COMMAND    DTV_FREQ_BPF
+
+enum dvb_sat_polarization {
+	POLARIZATION_OFF	= 0,
+	POLARIZATION_H		= 1,
+	POLARIZATION_V		= 2,
+	POLARIZATION_L		= 3,
+	POLARIZATION_R		= 4,
+};
+
+extern const char *dvb_sat_pol_name[6];
+extern const char *dvb_user_name[2];
+extern const void *dvb_user_attr_names[];
+
+#endif
+
diff --git a/lib/include/libsat.h b/lib/include/libsat.h
index 42530ff..3879914 100644
--- a/lib/include/libsat.h
+++ b/lib/include/libsat.h
@@ -19,13 +19,7 @@
 #ifndef _LIBSAT_H
 #define _LIBSAT_H
 
-enum dvbsat_polarization {
-	POLARIZATION_OFF	= 0,
-	POLARIZATION_H		= 1,
-	POLARIZATION_V		= 2,
-	POLARIZATION_L		= 3,
-	POLARIZATION_R		= 4,
-};
+#include "dvb-v5-std.h"
 
 struct dvbsat_freqrange {
 	unsigned low, high;
diff --git a/lib/libdvbv5/Makefile.am b/lib/libdvbv5/Makefile.am
index 6f1545d..0a94311 100644
--- a/lib/libdvbv5/Makefile.am
+++ b/lib/libdvbv5/Makefile.am
@@ -4,7 +4,9 @@ libdvbv5_la_SOURCES = \
   dvb-demux.c ../include/dvb-demux.h \
   dvb-fe.c ../include/dvb-fe.h \
   dvb-file.c ../include/dvb-file.h \
-  ../include/dvb-frontend.h  dvb-v5.h  dvb-v5-std.h \
+  ../include/dvb-frontend.h \
+  dvb-v5.h dvb-v5.c \
+  ../include/dvb-v5-std.h dvb-v5-std.c \
   dvb-legacy-channel-format.c \
   dvb-zap-format.c \
   descriptors.c descriptors.h \
diff --git a/lib/libdvbv5/descriptors.c b/lib/libdvbv5/descriptors.c
index 09e9245..549965a 100644
--- a/lib/libdvbv5/descriptors.c
+++ b/lib/libdvbv5/descriptors.c
@@ -26,6 +26,7 @@
 #include "descriptors.h"
 #include "parse_string.h"
 #include "dvb-frontend.h"
+#include "dvb-v5-std.h"
 
 static char *default_charset = "iso-8859-1";
 static char *output_charset = "utf-8";
diff --git a/lib/libdvbv5/dvb-fe.c b/lib/libdvbv5/dvb-fe.c
index 663caa6..91713e2 100644
--- a/lib/libdvbv5/dvb-fe.c
+++ b/lib/libdvbv5/dvb-fe.c
@@ -385,7 +385,7 @@ void dvb_fe_prt_parms(FILE *fp, const struct dvb_v5_fe_parms *parms)
 	int i;
 
 	for (i = 0; i < parms->n_props; i++) {
-		const char * const *attr_name = dvbv5_attr_names[parms->dvb_prop[i].cmd];
+		const char * const *attr_name = dvb_v5_attr_names[parms->dvb_prop[i].cmd];
 		if (attr_name) {
 			int j;
 
diff --git a/lib/libdvbv5/dvb-file.c b/lib/libdvbv5/dvb-file.c
index b54c049..d7cf13e 100644
--- a/lib/libdvbv5/dvb-file.c
+++ b/lib/libdvbv5/dvb-file.c
@@ -24,6 +24,7 @@
 #include <unistd.h>
 
 #include "dvb-file.h"
+#include "dvb-v5-std.h"
 #include "libscan.h"
 
 static const char *parm_name(const struct parse_table *table)
@@ -150,12 +151,12 @@ struct dvb_file *parse_format_oneline(const char *fname,
 				}
 				if (table->prop == DTV_BANDWIDTH_HZ)
 					j = fe_bandwidth_name[j];
-				if (table->prop == DTV_POLARIZATION) {
-					entry->pol = j;
-				} else {
+				/*if (table->prop == DTV_POLARIZATION) {*/
+					/*entry->pol = j;*/
+				/*} else {*/
 					entry->props[entry->n_props].cmd = table->prop;
 					entry->props[entry->n_props++].u.data = j;
-				}
+				/*}*/
 			} else {
 				long v = atol(p);
 				if (table->mult_factor)
@@ -369,13 +370,6 @@ error:
 }
 
 
-static const char *pol_name[] = {
-	[POLARIZATION_H] = "HORIZONTAL",
-	[POLARIZATION_V] = "VERTICAL",
-	[POLARIZATION_L] = "LEFT",
-	[POLARIZATION_R] = "RIGHT",
-};
-
 #define CHANNEL "CHANNEL"
 
 static int fill_entry(struct dvb_entry *entry, char *key, char *value)
@@ -383,18 +377,17 @@ static int fill_entry(struct dvb_entry *entry, char *key, char *value)
 	int i, j, len, type = 0;
 	int is_video = 0, is_audio = 0, n_prop;
 	uint16_t *pid = NULL;
-	char *p;
+        char *p;
 
+	/* Handle the DVBv5 DTV_foo properties */
 	for (i = 0; i < ARRAY_SIZE(dvb_v5_name); i++) {
 		if (!dvb_v5_name[i])
 			continue;
 		if (!strcasecmp(key, dvb_v5_name[i]))
 			break;
 	}
-
-	/* Handle the DVBv5 DTV_foo properties */
 	if (i < ARRAY_SIZE(dvb_v5_name)) {
-		const char * const *attr_name = dvbv5_attr_names[i];
+		const char * const *attr_name = dvb_v5_attr_names[i];
 		n_prop = entry->n_props;
 		entry->props[n_prop].cmd = i;
 		if (!attr_name || !*attr_name)
@@ -411,6 +404,31 @@ static int fill_entry(struct dvb_entry *entry, char *key, char *value)
 		return 0;
 	}
 
+	/* Handle the DVB extra DTV_foo properties */
+	for (i = 0; i < ARRAY_SIZE(dvb_user_name); i++) {
+		if (!dvb_user_name[i])
+			continue;
+		if (!strcasecmp(key, dvb_user_name[i]))
+			break;
+	}
+	if (i < ARRAY_SIZE(dvb_user_name)) {
+		const char * const *attr_name = dvb_user_attr_names[i];
+		n_prop = entry->n_props;
+		entry->props[n_prop].cmd = i + DTV_USER_COMMAND_START;
+		if (!attr_name || !*attr_name)
+			entry->props[n_prop].u.data = atol(value);
+		else {
+			for (j = 0; attr_name[j]; j++)
+				if (!strcasecmp(value, attr_name[j]))
+					break;
+			if (!attr_name[j])
+				return -2;
+			entry->props[n_prop].u.data = j + DTV_USER_COMMAND_START;
+		}
+		entry->n_props++;
+		return 0;
+	}
+
 	/* Handle the other properties */
 
 	if (!strcasecmp(key, "SERVICE_ID")) {
@@ -447,7 +465,7 @@ static int fill_entry(struct dvb_entry *entry, char *key, char *value)
 		is_video = 1;
 	else if (!strcasecmp(key, "AUDIO_PID"))
 		is_audio = 1;
-	else if (!strcasecmp(key, "POLARIZATION")) {
+	/*else if (!strcasecmp(key, "POLARIZATION")) {
 		entry->service_id = atol(value);
 		for (j = 0; ARRAY_SIZE(pol_name); j++)
 			if (!strcasecmp(value, pol_name[j]))
@@ -456,7 +474,7 @@ static int fill_entry(struct dvb_entry *entry, char *key, char *value)
 			return -2;
 		entry->pol = j;
 		return 0;
-	} else if (!strncasecmp(key,"PID_", 4)){
+	}*/ else if (!strncasecmp(key,"PID_", 4)){
 		type = strtol(&key[4], NULL, 16);
 		if (!type)
 			return 0;
@@ -666,10 +684,10 @@ int write_dvb_file(const char *fname, struct dvb_file *dvb_file)
 			fprintf(fp, "\n");
 		}
 
-		if (entry->pol != POLARIZATION_OFF) {
-			fprintf(fp, "\tPOLARIZATION = %s\n",
-				pol_name[entry->pol]);
-		}
+		/*if (entry->pol != POLARIZATION_OFF) {*/
+			/*fprintf(fp, "\tPOLARIZATION = %s\n",*/
+				/*pol_name[entry->pol]);*/
+		/*}*/
 
 		if (entry->sat_number >= 0) {
 			fprintf(fp, "\tSAT_NUMBER = %d\n",
@@ -689,7 +707,7 @@ int write_dvb_file(const char *fname, struct dvb_file *dvb_file)
 				fprintf(fp, "\tLNB = %s\n", entry->lnb);
 
 		for (i = 0; i < entry->n_props; i++) {
-			const char * const *attr_name = dvbv5_attr_names[entry->props[i].cmd];
+			const char * const *attr_name = dvb_v5_attr_names[entry->props[i].cmd];
 			if (attr_name) {
 				int j;
 
@@ -710,6 +728,31 @@ int write_dvb_file(const char *fname, struct dvb_file *dvb_file)
 					*attr_name);
 		}
 		fprintf(fp, "\n");
+
+		for (i = 0; i < entry->n_props; i++) {
+                  if (entry->props[i].cmd < DTV_USER_COMMAND_START)
+                    continue;
+			const char * const *attr_name = dvb_user_attr_names[entry->props[i].cmd - DTV_USER_COMMAND_START];
+			if (attr_name) {
+				int j;
+
+				for (j = 0; j < entry->props[i].u.data; j++) {
+					if (!*attr_name)
+						break;
+					attr_name++;
+				}
+			}
+
+			if (!attr_name || !*attr_name)
+				fprintf(fp, "\t%s = %u\n",
+					dvb_user_name[entry->props[i].cmd - DTV_USER_COMMAND_START],
+					entry->props[i].u.data);
+			else
+				fprintf(fp, "\t%s = %s\n",
+					dvb_user_name[entry->props[i].cmd - DTV_USER_COMMAND_START],
+					*attr_name);
+		}
+		fprintf(fp, "\n");
 	}
 	fclose(fp);
 	return 0;
@@ -806,7 +849,9 @@ static void handle_std_specific_parms(struct dvb_entry *entry,
 				 nit_table->frequency[0]);
 		store_entry_prop(entry, DTV_MODULATION,
 				 nit_table->modulation);
-		entry->pol = nit_table->pol;
+		/*entry->pol = nit_table->pol;*/
+		store_entry_prop(entry, DTV_POLARIZATION,
+				 nit_table->pol);
 		store_entry_prop(entry, DTV_DELIVERY_SYSTEM,
 				 nit_table->delivery_system);
 		store_entry_prop(entry, DTV_SYMBOL_RATE,
@@ -936,7 +981,7 @@ int store_dvb_channel(struct dvb_file **dvb_file,
 
 		entry->vchannel = dvb_vchannel(dvb_desc, i);
 
-		entry->pol = parms->pol;
+		/*entry->pol = parms->pol;*/
 		entry->sat_number = parms->sat_number;
 		entry->freq_bpf = parms->freq_bpf;
 		entry->diseqc_wait = parms->diseqc_wait;
diff --git a/lib/libdvbv5/dvb-legacy-channel-format.c b/lib/libdvbv5/dvb-legacy-channel-format.c
index 53f821b..d05e3d2 100644
--- a/lib/libdvbv5/dvb-legacy-channel-format.c
+++ b/lib/libdvbv5/dvb-legacy-channel-format.c
@@ -22,6 +22,7 @@
 #include <string.h>
 
 #include "dvb-file.h"
+#include "dvb-v5-std.h"
 
 /*
  * Standard channel.conf format for DVB-T, DVB-C, DVB-S and ATSC
@@ -97,6 +98,7 @@ static const char *channel_parse_hierarchy[] = {
 };
 
 static const char *channel_parse_polarization[] = {
+	[POLARIZATION_OFF] = "-",
 	[POLARIZATION_H] = "H",
 	[POLARIZATION_V] = "V",
 	[POLARIZATION_L] = "L",
diff --git a/lib/libdvbv5/dvb-v5-std.h b/lib/libdvbv5/dvb-v5-std.c
similarity index 88%
rename from lib/libdvbv5/dvb-v5-std.h
rename to lib/libdvbv5/dvb-v5-std.c
index 045162c..ec588b1 100644
--- a/lib/libdvbv5/dvb-v5-std.h
+++ b/lib/libdvbv5/dvb-v5-std.c
@@ -19,11 +19,9 @@
  * Per-delivery system properties, according with the specs:
  * 	http://linuxtv.org/downloads/v4l-dvb-apis/FE_GET_SET_PROPERTY.html
  */
-#ifndef _DVB_V5_STD_H
-#define _DVB_V5_STD_H
 
-#include <stddef.h>
-#include "dvb-frontend.h"
+#include "dvb-v5-std.h"
+#include "dvb-v5.h"
 
 const unsigned int sys_dvbt_props[] = {
 	DTV_FREQUENCY,
@@ -166,7 +164,7 @@ const unsigned int *dvb_v5_delivery_system[] = {
 	[SYS_UNDEFINED] =     NULL,
 };
 
-const void *dvbv5_attr_names[] = {
+const void *dvb_v5_attr_names[] = {
 	[0 ...DTV_MAX_COMMAND ] = NULL,
 	[DTV_CODE_RATE_HP]		= fe_code_rate_name,
 	[DTV_CODE_RATE_LP]		= fe_code_rate_name,
@@ -189,5 +187,22 @@ const void *dvbv5_attr_names[] = {
 	[DTV_DELIVERY_SYSTEM]		= delivery_system_name,
 };
 
-#endif
+const char *dvb_sat_pol_name[6] = {
+	[POLARIZATION_OFF] = "OFF",
+	[POLARIZATION_H] = "HORIZONTAL",
+	[POLARIZATION_V] = "VERTICAL",
+	[POLARIZATION_L] = "LEFT",
+	[POLARIZATION_R] = "RIGHT",
+        [5] = NULL,
+};
+
+const char *dvb_user_name[2] = {
+	[DTV_POLARIZATION - DTV_USER_COMMAND_START] =                    "POLARIZATION",
+        [1] = NULL,
+};
+
+const void *dvb_user_attr_names[] = {
+	[0 ... DTV_MAX_USER_COMMAND - DTV_USER_COMMAND_START] = NULL,
+	[DTV_POLARIZATION - DTV_USER_COMMAND_START]           = dvb_sat_pol_name,
+};
 
diff --git a/lib/libdvbv5/dvb-v5.c b/lib/libdvbv5/dvb-v5.c
new file mode 100644
index 0000000..7b9760c
--- /dev/null
+++ b/lib/libdvbv5/dvb-v5.c
@@ -0,0 +1,230 @@
+/*
+ * File auto-generated from the kernel sources. Please, don't edit it
+ */
+#include "dvb-v5.h"
+struct fe_caps_name fe_caps_name[30] = {
+	{ FE_CAN_2G_MODULATION,          "CAN_2G_MODULATION" },
+	{ FE_CAN_8VSB,                   "CAN_8VSB" },
+	{ FE_CAN_16VSB,                  "CAN_16VSB" },
+	{ FE_CAN_BANDWIDTH_AUTO,         "CAN_BANDWIDTH_AUTO" },
+	{ FE_CAN_FEC_1_2,                "CAN_FEC_1_2" },
+	{ FE_CAN_FEC_2_3,                "CAN_FEC_2_3" },
+	{ FE_CAN_FEC_3_4,                "CAN_FEC_3_4" },
+	{ FE_CAN_FEC_4_5,                "CAN_FEC_4_5" },
+	{ FE_CAN_FEC_5_6,                "CAN_FEC_5_6" },
+	{ FE_CAN_FEC_6_7,                "CAN_FEC_6_7" },
+	{ FE_CAN_FEC_7_8,                "CAN_FEC_7_8" },
+	{ FE_CAN_FEC_8_9,                "CAN_FEC_8_9" },
+	{ FE_CAN_FEC_AUTO,               "CAN_FEC_AUTO" },
+	{ FE_CAN_GUARD_INTERVAL_AUTO,    "CAN_GUARD_INTERVAL_AUTO" },
+	{ FE_CAN_HIERARCHY_AUTO,         "CAN_HIERARCHY_AUTO" },
+	{ FE_CAN_INVERSION_AUTO,         "CAN_INVERSION_AUTO" },
+	{ FE_CAN_MUTE_TS,                "CAN_MUTE_TS" },
+	{ FE_CAN_QAM_16,                 "CAN_QAM_16" },
+	{ FE_CAN_QAM_32,                 "CAN_QAM_32" },
+	{ FE_CAN_QAM_64,                 "CAN_QAM_64" },
+	{ FE_CAN_QAM_128,                "CAN_QAM_128" },
+	{ FE_CAN_QAM_256,                "CAN_QAM_256" },
+	{ FE_CAN_QAM_AUTO,               "CAN_QAM_AUTO" },
+	{ FE_CAN_QPSK,                   "CAN_QPSK" },
+	{ FE_CAN_RECOVER,                "CAN_RECOVER" },
+	{ FE_CAN_TRANSMISSION_MODE_AUTO, "CAN_TRANSMISSION_MODE_AUTO" },
+	{ FE_CAN_TURBO_FEC,              "CAN_TURBO_FEC" },
+	{ FE_HAS_EXTENDED_CAPS,          "HAS_EXTENDED_CAPS" },
+	{ FE_IS_STUPID,                  "IS_STUPID" },
+	{ FE_NEEDS_BENDING,              "NEEDS_BENDING" },
+};
+
+struct fe_status_name fe_status_name[7] = {
+	{ FE_HAS_CARRIER, "CARRIER" },
+	{ FE_HAS_LOCK,    "LOCK" },
+	{ FE_HAS_SIGNAL,  "SIGNAL" },
+	{ FE_HAS_SYNC,    "SYNC" },
+	{ FE_HAS_VITERBI, "VITERBI" },
+	{ FE_REINIT,      "REINIT" },
+	{ FE_TIMEDOUT,    "TIMEDOUT" },
+};
+
+const char *fe_code_rate_name[13] = {
+	[FEC_1_2] =  "1/2",
+	[FEC_2_3] =  "2/3",
+	[FEC_3_4] =  "3/4",
+	[FEC_3_5] =  "3/5",
+	[FEC_4_5] =  "4/5",
+	[FEC_5_6] =  "5/6",
+	[FEC_6_7] =  "6/7",
+	[FEC_7_8] =  "7/8",
+	[FEC_8_9] =  "8/9",
+	[FEC_9_10] = "9/10",
+	[FEC_AUTO] = "AUTO",
+	[FEC_NONE] = "NONE",
+	[12] = NULL,
+};
+
+const char *fe_modulation_name[14] = {
+	[APSK_16] =  "APSK/16",
+	[APSK_32] =  "APSK/32",
+	[DQPSK] =    "DQPSK",
+	[PSK_8] =    "PSK/8",
+	[QAM_16] =   "QAM/16",
+	[QAM_32] =   "QAM/32",
+	[QAM_64] =   "QAM/64",
+	[QAM_128] =  "QAM/128",
+	[QAM_256] =  "QAM/256",
+	[QAM_AUTO] = "QAM/AUTO",
+	[QPSK] =     "QPSK",
+	[VSB_8] =    "VSB/8",
+	[VSB_16] =   "VSB/16",
+	[13] = NULL,
+};
+
+const char *fe_transmission_mode_name[8] = {
+	[TRANSMISSION_MODE_1K] =   "1K",
+	[TRANSMISSION_MODE_2K] =   "2K",
+	[TRANSMISSION_MODE_4K] =   "4K",
+	[TRANSMISSION_MODE_8K] =   "8K",
+	[TRANSMISSION_MODE_16K] =  "16K",
+	[TRANSMISSION_MODE_32K] =  "32K",
+	[TRANSMISSION_MODE_AUTO] = "AUTO",
+	[7] = NULL,
+};
+
+const unsigned fe_bandwidth_name[8] = {
+	[BANDWIDTH_1_712_MHZ] = 1712000,
+	[BANDWIDTH_5_MHZ] =     5000000,
+	[BANDWIDTH_6_MHZ] =     6000000,
+	[BANDWIDTH_7_MHZ] =     7000000,
+	[BANDWIDTH_8_MHZ] =     8000000,
+	[BANDWIDTH_10_MHZ] =    10000000,
+	[BANDWIDTH_AUTO] =      0,
+	[7] = 0,
+};
+
+const char *fe_guard_interval_name[9] = {
+	[GUARD_INTERVAL_1_4] =    "1/4",
+	[GUARD_INTERVAL_1_8] =    "1/8",
+	[GUARD_INTERVAL_1_16] =   "1/16",
+	[GUARD_INTERVAL_1_32] =   "1/32",
+	[GUARD_INTERVAL_1_128] =  "1/128",
+	[GUARD_INTERVAL_19_128] = "19/128",
+	[GUARD_INTERVAL_19_256] = "19/256",
+	[GUARD_INTERVAL_AUTO] =   "AUTO",
+	[8] = NULL,
+};
+
+const char *fe_hierarchy_name[6] = {
+	[HIERARCHY_1] =    "1",
+	[HIERARCHY_2] =    "2",
+	[HIERARCHY_4] =    "4",
+	[HIERARCHY_AUTO] = "AUTO",
+	[HIERARCHY_NONE] = "NONE",
+	[5] = NULL,
+};
+
+const char *fe_voltage_name[4] = {
+	[SEC_VOLTAGE_13] =  "13",
+	[SEC_VOLTAGE_18] =  "18",
+	[SEC_VOLTAGE_OFF] = "OFF",
+	[3] = NULL,
+};
+
+const char *fe_tone_name[3] = {
+	[SEC_TONE_OFF] = "OFF",
+	[SEC_TONE_ON] =  "ON",
+	[2] = NULL,
+};
+
+const char *fe_inversion_name[4] = {
+	[INVERSION_AUTO] = "AUTO",
+	[INVERSION_OFF] =  "OFF",
+	[INVERSION_ON] =   "ON",
+	[3] = NULL,
+};
+
+const char *fe_pilot_name[4] = {
+	[PILOT_AUTO] = "AUTO",
+	[PILOT_OFF] =  "OFF",
+	[PILOT_ON] =   "ON",
+	[3] = NULL,
+};
+
+const char *fe_rolloff_name[5] = {
+	[ROLLOFF_20] =   "20",
+	[ROLLOFF_25] =   "25",
+	[ROLLOFF_35] =   "35",
+	[ROLLOFF_AUTO] = "AUTO",
+	[4] = NULL,
+};
+
+const char *dvb_v5_name[46] = {
+	[DTV_API_VERSION] =                    "API_VERSION",
+	[DTV_BANDWIDTH_HZ] =                   "BANDWIDTH_HZ",
+	[DTV_CLEAR] =                          "CLEAR",
+	[DTV_CODE_RATE_HP] =                   "CODE_RATE_HP",
+	[DTV_CODE_RATE_LP] =                   "CODE_RATE_LP",
+	[DTV_DELIVERY_SYSTEM] =                "DELIVERY_SYSTEM",
+	[DTV_DISEQC_MASTER] =                  "DISEQC_MASTER",
+	[DTV_DISEQC_SLAVE_REPLY] =             "DISEQC_SLAVE_REPLY",
+	[DTV_DVBT2_PLP_ID] =                   "DVBT2_PLP_ID",
+	[DTV_ENUM_DELSYS] =                    "ENUM_DELSYS",
+	[DTV_FE_CAPABILITY] =                  "FE_CAPABILITY",
+	[DTV_FE_CAPABILITY_COUNT] =            "FE_CAPABILITY_COUNT",
+	[DTV_FREQUENCY] =                      "FREQUENCY",
+	[DTV_GUARD_INTERVAL] =                 "GUARD_INTERVAL",
+	[DTV_HIERARCHY] =                      "HIERARCHY",
+	[DTV_INNER_FEC] =                      "INNER_FEC",
+	[DTV_INVERSION] =                      "INVERSION",
+	[DTV_ISDBS_TS_ID] =                    "ISDBS_TS_ID",
+	[DTV_ISDBT_LAYERA_FEC] =               "ISDBT_LAYERA_FEC",
+	[DTV_ISDBT_LAYERA_MODULATION] =        "ISDBT_LAYERA_MODULATION",
+	[DTV_ISDBT_LAYERA_SEGMENT_COUNT] =     "ISDBT_LAYERA_SEGMENT_COUNT",
+	[DTV_ISDBT_LAYERA_TIME_INTERLEAVING] = "ISDBT_LAYERA_TIME_INTERLEAVING",
+	[DTV_ISDBT_LAYERB_FEC] =               "ISDBT_LAYERB_FEC",
+	[DTV_ISDBT_LAYERB_MODULATION] =        "ISDBT_LAYERB_MODULATION",
+	[DTV_ISDBT_LAYERB_SEGMENT_COUNT] =     "ISDBT_LAYERB_SEGMENT_COUNT",
+	[DTV_ISDBT_LAYERB_TIME_INTERLEAVING] = "ISDBT_LAYERB_TIME_INTERLEAVING",
+	[DTV_ISDBT_LAYERC_FEC] =               "ISDBT_LAYERC_FEC",
+	[DTV_ISDBT_LAYERC_MODULATION] =        "ISDBT_LAYERC_MODULATION",
+	[DTV_ISDBT_LAYERC_SEGMENT_COUNT] =     "ISDBT_LAYERC_SEGMENT_COUNT",
+	[DTV_ISDBT_LAYERC_TIME_INTERLEAVING] = "ISDBT_LAYERC_TIME_INTERLEAVING",
+	[DTV_ISDBT_LAYER_ENABLED] =            "ISDBT_LAYER_ENABLED",
+	[DTV_ISDBT_PARTIAL_RECEPTION] =        "ISDBT_PARTIAL_RECEPTION",
+	[DTV_ISDBT_SB_SEGMENT_COUNT] =         "ISDBT_SB_SEGMENT_COUNT",
+	[DTV_ISDBT_SB_SEGMENT_IDX] =           "ISDBT_SB_SEGMENT_IDX",
+	[DTV_ISDBT_SB_SUBCHANNEL_ID] =         "ISDBT_SB_SUBCHANNEL_ID",
+	[DTV_ISDBT_SOUND_BROADCASTING] =       "ISDBT_SOUND_BROADCASTING",
+	[DTV_MODULATION] =                     "MODULATION",
+	[DTV_PILOT] =                          "PILOT",
+	[DTV_ROLLOFF] =                        "ROLLOFF",
+	[DTV_SYMBOL_RATE] =                    "SYMBOL_RATE",
+	[DTV_TONE] =                           "TONE",
+	[DTV_TRANSMISSION_MODE] =              "TRANSMISSION_MODE",
+	[DTV_TUNE] =                           "TUNE",
+	[DTV_UNDEFINED] =                      "UNDEFINED",
+	[DTV_VOLTAGE] =                        "VOLTAGE",
+	[45] = NULL,
+};
+
+const char *delivery_system_name[20] = {
+	[SYS_ATSC] =         "ATSC",
+	[SYS_ATSCMH] =       "ATSCMH",
+	[SYS_CMMB] =         "CMMB",
+	[SYS_DAB] =          "DAB",
+	[SYS_DMBTH] =        "DMBTH",
+	[SYS_DSS] =          "DSS",
+	[SYS_DVBC_ANNEX_A] = "DVBC/ANNEX_A",
+	[SYS_DVBC_ANNEX_B] = "DVBC/ANNEX_B",
+	[SYS_DVBC_ANNEX_C] = "DVBC/ANNEX_C",
+	[SYS_DVBH] =         "DVBH",
+	[SYS_DVBS] =         "DVBS",
+	[SYS_DVBS2] =        "DVBS2",
+	[SYS_DVBT] =         "DVBT",
+	[SYS_DVBT2] =        "DVBT2",
+	[SYS_ISDBC] =        "ISDBC",
+	[SYS_ISDBS] =        "ISDBS",
+	[SYS_ISDBT] =        "ISDBT",
+	[SYS_TURBO] =        "TURBO",
+	[SYS_UNDEFINED] =    "UNDEFINED",
+	[19] = NULL,
+};
+
diff --git a/lib/libdvbv5/dvb-v5.h b/lib/libdvbv5/dvb-v5.h
index 6610552..e389519 100644
--- a/lib/libdvbv5/dvb-v5.h
+++ b/lib/libdvbv5/dvb-v5.h
@@ -3,241 +3,28 @@
  */
 #ifndef _DVB_V5_CONSTS_H
 #define _DVB_V5_CONSTS_H
-
-#include <stddef.h>
-#include "dvb-frontend.h"
-
+#include "dvb_frontend.h"
 struct fe_caps_name {
 	unsigned  idx;
 	char *name;
-} fe_caps_name[30] = {
-	{ FE_CAN_2G_MODULATION,          "CAN_2G_MODULATION" },
-	{ FE_CAN_8VSB,                   "CAN_8VSB" },
-	{ FE_CAN_16VSB,                  "CAN_16VSB" },
-	{ FE_CAN_BANDWIDTH_AUTO,         "CAN_BANDWIDTH_AUTO" },
-	{ FE_CAN_FEC_1_2,                "CAN_FEC_1_2" },
-	{ FE_CAN_FEC_2_3,                "CAN_FEC_2_3" },
-	{ FE_CAN_FEC_3_4,                "CAN_FEC_3_4" },
-	{ FE_CAN_FEC_4_5,                "CAN_FEC_4_5" },
-	{ FE_CAN_FEC_5_6,                "CAN_FEC_5_6" },
-	{ FE_CAN_FEC_6_7,                "CAN_FEC_6_7" },
-	{ FE_CAN_FEC_7_8,                "CAN_FEC_7_8" },
-	{ FE_CAN_FEC_8_9,                "CAN_FEC_8_9" },
-	{ FE_CAN_FEC_AUTO,               "CAN_FEC_AUTO" },
-	{ FE_CAN_GUARD_INTERVAL_AUTO,    "CAN_GUARD_INTERVAL_AUTO" },
-	{ FE_CAN_HIERARCHY_AUTO,         "CAN_HIERARCHY_AUTO" },
-	{ FE_CAN_INVERSION_AUTO,         "CAN_INVERSION_AUTO" },
-	{ FE_CAN_MUTE_TS,                "CAN_MUTE_TS" },
-	{ FE_CAN_QAM_16,                 "CAN_QAM_16" },
-	{ FE_CAN_QAM_32,                 "CAN_QAM_32" },
-	{ FE_CAN_QAM_64,                 "CAN_QAM_64" },
-	{ FE_CAN_QAM_128,                "CAN_QAM_128" },
-	{ FE_CAN_QAM_256,                "CAN_QAM_256" },
-	{ FE_CAN_QAM_AUTO,               "CAN_QAM_AUTO" },
-	{ FE_CAN_QPSK,                   "CAN_QPSK" },
-	{ FE_CAN_RECOVER,                "CAN_RECOVER" },
-	{ FE_CAN_TRANSMISSION_MODE_AUTO, "CAN_TRANSMISSION_MODE_AUTO" },
-	{ FE_CAN_TURBO_FEC,              "CAN_TURBO_FEC" },
-	{ FE_HAS_EXTENDED_CAPS,          "HAS_EXTENDED_CAPS" },
-	{ FE_IS_STUPID,                  "IS_STUPID" },
-	{ FE_NEEDS_BENDING,              "NEEDS_BENDING" },
 };
-
+extern struct fe_caps_name fe_caps_name[30];
 struct fe_status_name {
 	unsigned  idx;
 	char *name;
-} fe_status_name[7] = {
-	{ FE_HAS_CARRIER, "CARRIER" },
-	{ FE_HAS_LOCK,    "LOCK" },
-	{ FE_HAS_SIGNAL,  "SIGNAL" },
-	{ FE_HAS_SYNC,    "SYNC" },
-	{ FE_HAS_VITERBI, "VITERBI" },
-	{ FE_REINIT,      "REINIT" },
-	{ FE_TIMEDOUT,    "TIMEDOUT" },
 };
-
-const char *fe_code_rate_name[13] = {
-	[FEC_1_2] =  "1/2",
-	[FEC_2_3] =  "2/3",
-	[FEC_3_4] =  "3/4",
-	[FEC_3_5] =  "3/5",
-	[FEC_4_5] =  "4/5",
-	[FEC_5_6] =  "5/6",
-	[FEC_6_7] =  "6/7",
-	[FEC_7_8] =  "7/8",
-	[FEC_8_9] =  "8/9",
-	[FEC_9_10] = "9/10",
-	[FEC_AUTO] = "AUTO",
-	[FEC_NONE] = "NONE",
-	[12] = NULL,
-};
-
-const char *fe_modulation_name[14] = {
-	[APSK_16] =  "APSK/16",
-	[APSK_32] =  "APSK/32",
-	[DQPSK] =    "DQPSK",
-	[PSK_8] =    "PSK/8",
-	[QAM_16] =   "QAM/16",
-	[QAM_32] =   "QAM/32",
-	[QAM_64] =   "QAM/64",
-	[QAM_128] =  "QAM/128",
-	[QAM_256] =  "QAM/256",
-	[QAM_AUTO] = "QAM/AUTO",
-	[QPSK] =     "QPSK",
-	[VSB_8] =    "VSB/8",
-	[VSB_16] =   "VSB/16",
-	[13] = NULL,
-};
-
-const char *fe_transmission_mode_name[8] = {
-	[TRANSMISSION_MODE_1K] =   "1K",
-	[TRANSMISSION_MODE_2K] =   "2K",
-	[TRANSMISSION_MODE_4K] =   "4K",
-	[TRANSMISSION_MODE_8K] =   "8K",
-	[TRANSMISSION_MODE_16K] =  "16K",
-	[TRANSMISSION_MODE_32K] =  "32K",
-	[TRANSMISSION_MODE_AUTO] = "AUTO",
-	[7] = NULL,
-};
-
-const unsigned fe_bandwidth_name[8] = {
-	[BANDWIDTH_1_712_MHZ] = 1712000,
-	[BANDWIDTH_5_MHZ] =     5000000,
-	[BANDWIDTH_6_MHZ] =     6000000,
-	[BANDWIDTH_7_MHZ] =     7000000,
-	[BANDWIDTH_8_MHZ] =     8000000,
-	[BANDWIDTH_10_MHZ] =    10000000,
-	[BANDWIDTH_AUTO] =      0,
-	[7] = 0,
-};
-
-const char *fe_guard_interval_name[9] = {
-	[GUARD_INTERVAL_1_4] =    "1/4",
-	[GUARD_INTERVAL_1_8] =    "1/8",
-	[GUARD_INTERVAL_1_16] =   "1/16",
-	[GUARD_INTERVAL_1_32] =   "1/32",
-	[GUARD_INTERVAL_1_128] =  "1/128",
-	[GUARD_INTERVAL_19_128] = "19/128",
-	[GUARD_INTERVAL_19_256] = "19/256",
-	[GUARD_INTERVAL_AUTO] =   "AUTO",
-	[8] = NULL,
-};
-
-const char *fe_hierarchy_name[6] = {
-	[HIERARCHY_1] =    "1",
-	[HIERARCHY_2] =    "2",
-	[HIERARCHY_4] =    "4",
-	[HIERARCHY_AUTO] = "AUTO",
-	[HIERARCHY_NONE] = "NONE",
-	[5] = NULL,
-};
-
-const char *fe_voltage_name[4] = {
-	[SEC_VOLTAGE_13] =  "13",
-	[SEC_VOLTAGE_18] =  "18",
-	[SEC_VOLTAGE_OFF] = "OFF",
-	[3] = NULL,
-};
-
-const char *fe_tone_name[3] = {
-	[SEC_TONE_OFF] = "OFF",
-	[SEC_TONE_ON] =  "ON",
-	[2] = NULL,
-};
-
-const char *fe_inversion_name[4] = {
-	[INVERSION_AUTO] = "AUTO",
-	[INVERSION_OFF] =  "OFF",
-	[INVERSION_ON] =   "ON",
-	[3] = NULL,
-};
-
-const char *fe_pilot_name[4] = {
-	[PILOT_AUTO] = "AUTO",
-	[PILOT_OFF] =  "OFF",
-	[PILOT_ON] =   "ON",
-	[3] = NULL,
-};
-
-const char *fe_rolloff_name[5] = {
-	[ROLLOFF_20] =   "20",
-	[ROLLOFF_25] =   "25",
-	[ROLLOFF_35] =   "35",
-	[ROLLOFF_AUTO] = "AUTO",
-	[4] = NULL,
-};
-
-const char *dvb_v5_name[46] = {
-	[DTV_API_VERSION] =                    "API_VERSION",
-	[DTV_BANDWIDTH_HZ] =                   "BANDWIDTH_HZ",
-	[DTV_CLEAR] =                          "CLEAR",
-	[DTV_CODE_RATE_HP] =                   "CODE_RATE_HP",
-	[DTV_CODE_RATE_LP] =                   "CODE_RATE_LP",
-	[DTV_DELIVERY_SYSTEM] =                "DELIVERY_SYSTEM",
-	[DTV_DISEQC_MASTER] =                  "DISEQC_MASTER",
-	[DTV_DISEQC_SLAVE_REPLY] =             "DISEQC_SLAVE_REPLY",
-	[DTV_DVBT2_PLP_ID] =                   "DVBT2_PLP_ID",
-	[DTV_ENUM_DELSYS] =                    "ENUM_DELSYS",
-	[DTV_FE_CAPABILITY] =                  "FE_CAPABILITY",
-	[DTV_FE_CAPABILITY_COUNT] =            "FE_CAPABILITY_COUNT",
-	[DTV_FREQUENCY] =                      "FREQUENCY",
-	[DTV_GUARD_INTERVAL] =                 "GUARD_INTERVAL",
-	[DTV_HIERARCHY] =                      "HIERARCHY",
-	[DTV_INNER_FEC] =                      "INNER_FEC",
-	[DTV_INVERSION] =                      "INVERSION",
-	[DTV_ISDBS_TS_ID] =                    "ISDBS_TS_ID",
-	[DTV_ISDBT_LAYERA_FEC] =               "ISDBT_LAYERA_FEC",
-	[DTV_ISDBT_LAYERA_MODULATION] =        "ISDBT_LAYERA_MODULATION",
-	[DTV_ISDBT_LAYERA_SEGMENT_COUNT] =     "ISDBT_LAYERA_SEGMENT_COUNT",
-	[DTV_ISDBT_LAYERA_TIME_INTERLEAVING] = "ISDBT_LAYERA_TIME_INTERLEAVING",
-	[DTV_ISDBT_LAYERB_FEC] =               "ISDBT_LAYERB_FEC",
-	[DTV_ISDBT_LAYERB_MODULATION] =        "ISDBT_LAYERB_MODULATION",
-	[DTV_ISDBT_LAYERB_SEGMENT_COUNT] =     "ISDBT_LAYERB_SEGMENT_COUNT",
-	[DTV_ISDBT_LAYERB_TIME_INTERLEAVING] = "ISDBT_LAYERB_TIME_INTERLEAVING",
-	[DTV_ISDBT_LAYERC_FEC] =               "ISDBT_LAYERC_FEC",
-	[DTV_ISDBT_LAYERC_MODULATION] =        "ISDBT_LAYERC_MODULATION",
-	[DTV_ISDBT_LAYERC_SEGMENT_COUNT] =     "ISDBT_LAYERC_SEGMENT_COUNT",
-	[DTV_ISDBT_LAYERC_TIME_INTERLEAVING] = "ISDBT_LAYERC_TIME_INTERLEAVING",
-	[DTV_ISDBT_LAYER_ENABLED] =            "ISDBT_LAYER_ENABLED",
-	[DTV_ISDBT_PARTIAL_RECEPTION] =        "ISDBT_PARTIAL_RECEPTION",
-	[DTV_ISDBT_SB_SEGMENT_COUNT] =         "ISDBT_SB_SEGMENT_COUNT",
-	[DTV_ISDBT_SB_SEGMENT_IDX] =           "ISDBT_SB_SEGMENT_IDX",
-	[DTV_ISDBT_SB_SUBCHANNEL_ID] =         "ISDBT_SB_SUBCHANNEL_ID",
-	[DTV_ISDBT_SOUND_BROADCASTING] =       "ISDBT_SOUND_BROADCASTING",
-	[DTV_MODULATION] =                     "MODULATION",
-	[DTV_PILOT] =                          "PILOT",
-	[DTV_ROLLOFF] =                        "ROLLOFF",
-	[DTV_SYMBOL_RATE] =                    "SYMBOL_RATE",
-	[DTV_TONE] =                           "TONE",
-	[DTV_TRANSMISSION_MODE] =              "TRANSMISSION_MODE",
-	[DTV_TUNE] =                           "TUNE",
-	[DTV_UNDEFINED] =                      "UNDEFINED",
-	[DTV_VOLTAGE] =                        "VOLTAGE",
-	[45] = NULL,
-};
-
-const char *delivery_system_name[20] = {
-	[SYS_ATSC] =         "ATSC",
-	[SYS_ATSCMH] =       "ATSCMH",
-	[SYS_CMMB] =         "CMMB",
-	[SYS_DAB] =          "DAB",
-	[SYS_DMBTH] =        "DMBTH",
-	[SYS_DSS] =          "DSS",
-	[SYS_DVBC_ANNEX_A] = "DVBC/ANNEX_A",
-	[SYS_DVBC_ANNEX_B] = "DVBC/ANNEX_B",
-	[SYS_DVBC_ANNEX_C] = "DVBC/ANNEX_C",
-	[SYS_DVBH] =         "DVBH",
-	[SYS_DVBS] =         "DVBS",
-	[SYS_DVBS2] =        "DVBS2",
-	[SYS_DVBT] =         "DVBT",
-	[SYS_DVBT2] =        "DVBT2",
-	[SYS_ISDBC] =        "ISDBC",
-	[SYS_ISDBS] =        "ISDBS",
-	[SYS_ISDBT] =        "ISDBT",
-	[SYS_TURBO] =        "TURBO",
-	[SYS_UNDEFINED] =    "UNDEFINED",
-	[19] = NULL,
-};
-
+extern struct fe_status_name fe_status_name[7];
+const char *fe_code_rate_name[13];
+const char *fe_modulation_name[14];
+const char *fe_transmission_mode_name[8];
+const unsigned fe_bandwidth_name[8];
+const char *fe_guard_interval_name[9];
+const char *fe_hierarchy_name[6];
+const char *fe_voltage_name[4];
+const char *fe_tone_name[3];
+const char *fe_inversion_name[4];
+const char *fe_pilot_name[4];
+const char *fe_rolloff_name[5];
+const char *dvb_v5_name[46];
+const char *delivery_system_name[20];
 #endif
-
diff --git a/lib/libdvbv5/dvb-zap-format.c b/lib/libdvbv5/dvb-zap-format.c
index 876395a..b087d76 100644
--- a/lib/libdvbv5/dvb-zap-format.c
+++ b/lib/libdvbv5/dvb-zap-format.c
@@ -23,6 +23,7 @@
 #include <string.h>
 
 #include "dvb-file.h"
+#include "dvb-v5-std.h"
 
 /*
  * Standard channel.conf format for DVB-T, DVB-C, DVB-S and ATSC
diff --git a/lib/libdvbv5/dvb_frontend.h b/lib/libdvbv5/dvb_frontend.h
new file mode 100644
index 0000000..cb4428a
--- /dev/null
+++ b/lib/libdvbv5/dvb_frontend.h
@@ -0,0 +1,436 @@
+/*
+ * frontend.h
+ *
+ * Copyright (C) 2000 Marcus Metzler <marcus@convergence.de>
+ *		    Ralph  Metzler <ralph@convergence.de>
+ *		    Holger Waechtler <holger@convergence.de>
+ *		    Andre Draszik <ad@convergence.de>
+ *		    for convergence integrated media GmbH
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU Lesser General Public License
+ * as published by the Free Software Foundation; either version 2.1
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU Lesser General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+ *
+ */
+
+#ifndef _DVBFRONTEND_H_
+#define _DVBFRONTEND_H_
+
+#include <linux/types.h>
+
+typedef enum fe_type {
+	FE_QPSK,
+	FE_QAM,
+	FE_OFDM,
+	FE_ATSC
+} fe_type_t;
+
+
+typedef enum fe_caps {
+	FE_IS_STUPID			= 0,
+	FE_CAN_INVERSION_AUTO		= 0x1,
+	FE_CAN_FEC_1_2			= 0x2,
+	FE_CAN_FEC_2_3			= 0x4,
+	FE_CAN_FEC_3_4			= 0x8,
+	FE_CAN_FEC_4_5			= 0x10,
+	FE_CAN_FEC_5_6			= 0x20,
+	FE_CAN_FEC_6_7			= 0x40,
+	FE_CAN_FEC_7_8			= 0x80,
+	FE_CAN_FEC_8_9			= 0x100,
+	FE_CAN_FEC_AUTO			= 0x200,
+	FE_CAN_QPSK			= 0x400,
+	FE_CAN_QAM_16			= 0x800,
+	FE_CAN_QAM_32			= 0x1000,
+	FE_CAN_QAM_64			= 0x2000,
+	FE_CAN_QAM_128			= 0x4000,
+	FE_CAN_QAM_256			= 0x8000,
+	FE_CAN_QAM_AUTO			= 0x10000,
+	FE_CAN_TRANSMISSION_MODE_AUTO	= 0x20000,
+	FE_CAN_BANDWIDTH_AUTO		= 0x40000,
+	FE_CAN_GUARD_INTERVAL_AUTO	= 0x80000,
+	FE_CAN_HIERARCHY_AUTO		= 0x100000,
+	FE_CAN_8VSB			= 0x200000,
+	FE_CAN_16VSB			= 0x400000,
+	FE_HAS_EXTENDED_CAPS		= 0x800000,   /* We need more bitspace for newer APIs, indicate this. */
+	FE_CAN_TURBO_FEC		= 0x8000000,  /* frontend supports "turbo fec modulation" */
+	FE_CAN_2G_MODULATION		= 0x10000000, /* frontend supports "2nd generation modulation" (DVB-S2) */
+	FE_NEEDS_BENDING		= 0x20000000, /* not supported anymore, don't use (frontend requires frequency bending) */
+	FE_CAN_RECOVER			= 0x40000000, /* frontend can recover from a cable unplug automatically */
+	FE_CAN_MUTE_TS			= 0x80000000  /* frontend can stop spurious TS data output */
+} fe_caps_t;
+
+
+struct dvb_frontend_info {
+	char       name[128];
+	fe_type_t  type;			/* DEPRECATED. Use DTV_ENUM_DELSYS instead */
+	__u32      frequency_min;
+	__u32      frequency_max;
+	__u32      frequency_stepsize;
+	__u32      frequency_tolerance;
+	__u32      symbol_rate_min;
+	__u32      symbol_rate_max;
+	__u32      symbol_rate_tolerance;	/* ppm */
+	__u32      notifier_delay;		/* DEPRECATED */
+	fe_caps_t  caps;
+};
+
+
+/**
+ *  Check out the DiSEqC bus spec available on http://www.eutelsat.org/ for
+ *  the meaning of this struct...
+ */
+struct dvb_diseqc_master_cmd {
+	__u8 msg [6];	/*  { framing, address, command, data [3] } */
+	__u8 msg_len;	/*  valid values are 3...6  */
+};
+
+
+struct dvb_diseqc_slave_reply {
+	__u8 msg [4];	/*  { framing, data [3] } */
+	__u8 msg_len;	/*  valid values are 0...4, 0 means no msg  */
+	int  timeout;	/*  return from ioctl after timeout ms with */
+};			/*  errorcode when no message was received  */
+
+
+typedef enum fe_sec_voltage {
+	SEC_VOLTAGE_13,
+	SEC_VOLTAGE_18,
+	SEC_VOLTAGE_OFF
+} fe_sec_voltage_t;
+
+
+typedef enum fe_sec_tone_mode {
+	SEC_TONE_ON,
+	SEC_TONE_OFF
+} fe_sec_tone_mode_t;
+
+
+typedef enum fe_sec_mini_cmd {
+	SEC_MINI_A,
+	SEC_MINI_B
+} fe_sec_mini_cmd_t;
+
+
+typedef enum fe_status {
+	FE_HAS_SIGNAL	= 0x01,   /* found something above the noise level */
+	FE_HAS_CARRIER	= 0x02,   /* found a DVB signal  */
+	FE_HAS_VITERBI	= 0x04,   /* FEC is stable  */
+	FE_HAS_SYNC	= 0x08,   /* found sync bytes  */
+	FE_HAS_LOCK	= 0x10,   /* everything's working... */
+	FE_TIMEDOUT	= 0x20,   /* no lock within the last ~2 seconds */
+	FE_REINIT	= 0x40    /* frontend was reinitialized,  */
+} fe_status_t;			  /* application is recommended to reset */
+				  /* DiSEqC, tone and parameters */
+
+typedef enum fe_spectral_inversion {
+	INVERSION_OFF,
+	INVERSION_ON,
+	INVERSION_AUTO
+} fe_spectral_inversion_t;
+
+
+typedef enum fe_code_rate {
+	FEC_NONE = 0,
+	FEC_1_2,
+	FEC_2_3,
+	FEC_3_4,
+	FEC_4_5,
+	FEC_5_6,
+	FEC_6_7,
+	FEC_7_8,
+	FEC_8_9,
+	FEC_AUTO,
+	FEC_3_5,
+	FEC_9_10,
+} fe_code_rate_t;
+
+
+typedef enum fe_modulation {
+	QPSK,
+	QAM_16,
+	QAM_32,
+	QAM_64,
+	QAM_128,
+	QAM_256,
+	QAM_AUTO,
+	VSB_8,
+	VSB_16,
+	PSK_8,
+	APSK_16,
+	APSK_32,
+	DQPSK,
+} fe_modulation_t;
+
+typedef enum fe_transmit_mode {
+	TRANSMISSION_MODE_2K,
+	TRANSMISSION_MODE_8K,
+	TRANSMISSION_MODE_AUTO,
+	TRANSMISSION_MODE_4K,
+	TRANSMISSION_MODE_1K,
+	TRANSMISSION_MODE_16K,
+	TRANSMISSION_MODE_32K,
+} fe_transmit_mode_t;
+
+#if defined(__DVB_CORE__) || !defined (__KERNEL__)
+typedef enum fe_bandwidth {
+	BANDWIDTH_8_MHZ,
+	BANDWIDTH_7_MHZ,
+	BANDWIDTH_6_MHZ,
+	BANDWIDTH_AUTO,
+	BANDWIDTH_5_MHZ,
+	BANDWIDTH_10_MHZ,
+	BANDWIDTH_1_712_MHZ,
+} fe_bandwidth_t;
+#endif
+
+typedef enum fe_guard_interval {
+	GUARD_INTERVAL_1_32,
+	GUARD_INTERVAL_1_16,
+	GUARD_INTERVAL_1_8,
+	GUARD_INTERVAL_1_4,
+	GUARD_INTERVAL_AUTO,
+	GUARD_INTERVAL_1_128,
+	GUARD_INTERVAL_19_128,
+	GUARD_INTERVAL_19_256,
+} fe_guard_interval_t;
+
+
+typedef enum fe_hierarchy {
+	HIERARCHY_NONE,
+	HIERARCHY_1,
+	HIERARCHY_2,
+	HIERARCHY_4,
+	HIERARCHY_AUTO
+} fe_hierarchy_t;
+
+
+#if defined(__DVB_CORE__) || !defined (__KERNEL__)
+struct dvb_qpsk_parameters {
+	__u32		symbol_rate;  /* symbol rate in Symbols per second */
+	fe_code_rate_t	fec_inner;    /* forward error correction (see above) */
+};
+
+struct dvb_qam_parameters {
+	__u32		symbol_rate; /* symbol rate in Symbols per second */
+	fe_code_rate_t	fec_inner;   /* forward error correction (see above) */
+	fe_modulation_t	modulation;  /* modulation type (see above) */
+};
+
+struct dvb_vsb_parameters {
+	fe_modulation_t	modulation;  /* modulation type (see above) */
+};
+
+struct dvb_ofdm_parameters {
+	fe_bandwidth_t      bandwidth;
+	fe_code_rate_t      code_rate_HP;  /* high priority stream code rate */
+	fe_code_rate_t      code_rate_LP;  /* low priority stream code rate */
+	fe_modulation_t     constellation; /* modulation type (see above) */
+	fe_transmit_mode_t  transmission_mode;
+	fe_guard_interval_t guard_interval;
+	fe_hierarchy_t      hierarchy_information;
+};
+
+
+struct dvb_frontend_parameters {
+	__u32 frequency;     /* (absolute) frequency in Hz for QAM/OFDM/ATSC */
+			     /* intermediate frequency in kHz for QPSK */
+	fe_spectral_inversion_t inversion;
+	union {
+		struct dvb_qpsk_parameters qpsk;
+		struct dvb_qam_parameters  qam;
+		struct dvb_ofdm_parameters ofdm;
+		struct dvb_vsb_parameters vsb;
+	} u;
+};
+
+struct dvb_frontend_event {
+	fe_status_t status;
+	struct dvb_frontend_parameters parameters;
+};
+#endif
+
+/* S2API Commands */
+#define DTV_UNDEFINED		0
+#define DTV_TUNE		1
+#define DTV_CLEAR		2
+#define DTV_FREQUENCY		3
+#define DTV_MODULATION		4
+#define DTV_BANDWIDTH_HZ	5
+#define DTV_INVERSION		6
+#define DTV_DISEQC_MASTER	7
+#define DTV_SYMBOL_RATE		8
+#define DTV_INNER_FEC		9
+#define DTV_VOLTAGE		10
+#define DTV_TONE		11
+#define DTV_PILOT		12
+#define DTV_ROLLOFF		13
+#define DTV_DISEQC_SLAVE_REPLY	14
+
+/* Basic enumeration set for querying unlimited capabilities */
+#define DTV_FE_CAPABILITY_COUNT	15
+#define DTV_FE_CAPABILITY	16
+#define DTV_DELIVERY_SYSTEM	17
+
+/* ISDB-T and ISDB-Tsb */
+#define DTV_ISDBT_PARTIAL_RECEPTION	18
+#define DTV_ISDBT_SOUND_BROADCASTING	19
+
+#define DTV_ISDBT_SB_SUBCHANNEL_ID	20
+#define DTV_ISDBT_SB_SEGMENT_IDX	21
+#define DTV_ISDBT_SB_SEGMENT_COUNT	22
+
+#define DTV_ISDBT_LAYERA_FEC			23
+#define DTV_ISDBT_LAYERA_MODULATION		24
+#define DTV_ISDBT_LAYERA_SEGMENT_COUNT		25
+#define DTV_ISDBT_LAYERA_TIME_INTERLEAVING	26
+
+#define DTV_ISDBT_LAYERB_FEC			27
+#define DTV_ISDBT_LAYERB_MODULATION		28
+#define DTV_ISDBT_LAYERB_SEGMENT_COUNT		29
+#define DTV_ISDBT_LAYERB_TIME_INTERLEAVING	30
+
+#define DTV_ISDBT_LAYERC_FEC			31
+#define DTV_ISDBT_LAYERC_MODULATION		32
+#define DTV_ISDBT_LAYERC_SEGMENT_COUNT		33
+#define DTV_ISDBT_LAYERC_TIME_INTERLEAVING	34
+
+#define DTV_API_VERSION		35
+
+#define DTV_CODE_RATE_HP	36
+#define DTV_CODE_RATE_LP	37
+#define DTV_GUARD_INTERVAL	38
+#define DTV_TRANSMISSION_MODE	39
+#define DTV_HIERARCHY		40
+
+#define DTV_ISDBT_LAYER_ENABLED	41
+
+#define DTV_ISDBS_TS_ID		42
+
+#define DTV_DVBT2_PLP_ID	43
+
+#define DTV_ENUM_DELSYS		44
+
+#define DTV_MAX_COMMAND				DTV_ENUM_DELSYS
+
+typedef enum fe_pilot {
+	PILOT_ON,
+	PILOT_OFF,
+	PILOT_AUTO,
+} fe_pilot_t;
+
+typedef enum fe_rolloff {
+	ROLLOFF_35, /* Implied value in DVB-S, default for DVB-S2 */
+	ROLLOFF_20,
+	ROLLOFF_25,
+	ROLLOFF_AUTO,
+} fe_rolloff_t;
+
+typedef enum fe_delivery_system {
+	SYS_UNDEFINED,
+	SYS_DVBC_ANNEX_A,
+	SYS_DVBC_ANNEX_B,
+	SYS_DVBT,
+	SYS_DSS,
+	SYS_DVBS,
+	SYS_DVBS2,
+	SYS_DVBH,
+	SYS_ISDBT,
+	SYS_ISDBS,
+	SYS_ISDBC,
+	SYS_ATSC,
+	SYS_ATSCMH,
+	SYS_DMBTH,
+	SYS_CMMB,
+	SYS_DAB,
+	SYS_DVBT2,
+	SYS_TURBO,
+	SYS_DVBC_ANNEX_C,
+} fe_delivery_system_t;
+
+
+#define SYS_DVBC_ANNEX_AC	SYS_DVBC_ANNEX_A
+
+
+struct dtv_cmds_h {
+	char	*name;		/* A display name for debugging purposes */
+
+	__u32	cmd;		/* A unique ID */
+
+	/* Flags */
+	__u32	set:1;		/* Either a set or get property */
+	__u32	buffer:1;	/* Does this property use the buffer? */
+	__u32	reserved:30;	/* Align */
+};
+
+struct dtv_property {
+	__u32 cmd;
+	__u32 reserved[3];
+	union {
+		__u32 data;
+		struct {
+			__u8 data[32];
+			__u32 len;
+			__u32 reserved1[3];
+			void *reserved2;
+		} buffer;
+	} u;
+	int result;
+} __attribute__ ((packed));
+
+/* num of properties cannot exceed DTV_IOCTL_MAX_MSGS per ioctl */
+#define DTV_IOCTL_MAX_MSGS 64
+
+struct dtv_properties {
+	__u32 num;
+	struct dtv_property *props;
+};
+
+#define FE_SET_PROPERTY		   _IOW('o', 82, struct dtv_properties)
+#define FE_GET_PROPERTY		   _IOR('o', 83, struct dtv_properties)
+
+
+/**
+ * When set, this flag will disable any zigzagging or other "normal" tuning
+ * behaviour. Additionally, there will be no automatic monitoring of the lock
+ * status, and hence no frontend events will be generated. If a frontend device
+ * is closed, this flag will be automatically turned off when the device is
+ * reopened read-write.
+ */
+#define FE_TUNE_MODE_ONESHOT 0x01
+
+
+#define FE_GET_INFO		   _IOR('o', 61, struct dvb_frontend_info)
+
+#define FE_DISEQC_RESET_OVERLOAD   _IO('o', 62)
+#define FE_DISEQC_SEND_MASTER_CMD  _IOW('o', 63, struct dvb_diseqc_master_cmd)
+#define FE_DISEQC_RECV_SLAVE_REPLY _IOR('o', 64, struct dvb_diseqc_slave_reply)
+#define FE_DISEQC_SEND_BURST       _IO('o', 65)  /* fe_sec_mini_cmd_t */
+
+#define FE_SET_TONE		   _IO('o', 66)  /* fe_sec_tone_mode_t */
+#define FE_SET_VOLTAGE		   _IO('o', 67)  /* fe_sec_voltage_t */
+#define FE_ENABLE_HIGH_LNB_VOLTAGE _IO('o', 68)  /* int */
+
+#define FE_READ_STATUS		   _IOR('o', 69, fe_status_t)
+#define FE_READ_BER		   _IOR('o', 70, __u32)
+#define FE_READ_SIGNAL_STRENGTH    _IOR('o', 71, __u16)
+#define FE_READ_SNR		   _IOR('o', 72, __u16)
+#define FE_READ_UNCORRECTED_BLOCKS _IOR('o', 73, __u32)
+
+#define FE_SET_FRONTEND		   _IOW('o', 76, struct dvb_frontend_parameters)
+#define FE_GET_FRONTEND		   _IOR('o', 77, struct dvb_frontend_parameters)
+#define FE_SET_FRONTEND_TUNE_MODE  _IO('o', 81) /* unsigned int */
+#define FE_GET_EVENT		   _IOR('o', 78, struct dvb_frontend_event)
+
+#define FE_DISHNETWORK_SEND_LEGACY_CMD _IO('o', 80) /* unsigned int */
+
+#endif /*_DVBFRONTEND_H_*/
diff --git a/lib/libdvbv5/gen_dvb_structs.pl b/lib/libdvbv5/gen_dvb_structs.pl
index 7ed9645..99e8c44 100755
--- a/lib/libdvbv5/gen_dvb_structs.pl
+++ b/lib/libdvbv5/gen_dvb_structs.pl
@@ -3,21 +3,21 @@ use strict;
 use File::Copy;
 
 use constant {
-	NORMAL => 0,
-	FE_CAPS => 1,
-	FE_STATUS => 2,
-	FE_CODERATE => 3,
-	FE_MODULATION => 4,
-	FE_TMODE => 5,
-	FE_BW => 6,
-	FE_GINTERVAL => 7,
-	FE_HIERARCHY => 8,
-	FE_DTS => 9,
-	FE_VOLTAGE => 10,
-	FE_TONE => 11,
-	FE_INVERSION => 12,
-	FE_PILOT => 13,
-	FE_ROLLOFF => 14,
+  NORMAL => 0,
+  FE_CAPS => 1,
+  FE_STATUS => 2,
+  FE_CODERATE => 3,
+  FE_MODULATION => 4,
+  FE_TMODE => 5,
+  FE_BW => 6,
+  FE_GINTERVAL => 7,
+  FE_HIERARCHY => 8,
+  FE_DTS => 9,
+  FE_VOLTAGE => 10,
+  FE_TONE => 11,
+  FE_INVERSION => 12,
+  FE_PILOT => 13,
+  FE_ROLLOFF => 14,
 };
 
 my $dir = shift or die "Please specify the kernel include directory.";
@@ -47,412 +47,425 @@ my %fe_rolloff;
 
 sub gen_fe($)
 {
-	my $file = shift;
-
-	my $mode = 0;
-
-	open IN, "<$file" or die "Can't open $file";
-
-	while (<IN>) {
-		#
-		# Mode FE_CAPS
-		#
-		if (m/typedef enum fe_caps\ {/) {
-			$mode = FE_CAPS;
-			next;
-		}
-		if ($mode == FE_CAPS) {
-			if (m/\} fe_caps_t;/) {
-				$mode = NORMAL;
-				next;
-			}
-			if (m/(FE_)([^\s,=]+)/) {
-				my $macro = "$1$2";
-				my $name = $2;
-
-				$fe_caps{$macro} = $name;
-			}
-		}
-		#
-		# Mode FE_STATUS
-		#
-		if (m/typedef enum fe_status\ {/) {
-			$mode = FE_STATUS;
-			next;
-		}
-		if ($mode == FE_STATUS) {
-			if (m/\} fe_status_t;/) {
-				$mode = NORMAL;
-				next;
-			}
-			if (m/(FE_)([^\s,=]+)/) {
-				my $macro = "$1$2";
-				my $name = $2;
-
-				$name =~ s/HAS_//;
-
-				$fe_status{$macro} = $name;
-			}
-		}
-		#
-		# Mode FE_CODERATE
-		#
-		if (m/typedef enum fe_code_rate \{/) {
-			$mode = FE_CODERATE;
-			next;
-		}
-		if ($mode == FE_CODERATE) {
-			if (m/\} fe_code_rate_t;/) {
-				$mode = NORMAL;
-				next;
-			}
-			if (m/(FEC_)([^\s,]+)/) {
-				my $macro = "$1$2";
-				my $name = $2;
-				$name =~ s,_,/,;
-
-				$fe_code_rate{$macro} = $name;
-			}
-		}
-		#
-		# Mode FE_MODULATION
-		#
-		if (m/typedef enum fe_modulation \{/) {
-			$mode = FE_MODULATION;
-			next;
-		}
-		if ($mode == FE_MODULATION) {
-			if (m/\} fe_modulation_t;/) {
-				$mode = NORMAL;
-				next;
-			}
-			if (m/\t([^\s,=]+)/) {
-				my $macro = "$1";
-				my $name = $1;
-				$name =~ s,_,/,;
-
-				$fe_modulation{$macro} = $name;
-			}
-		}
-		#
-		# Mode FE_TMODE
-		#
-		if (m/typedef enum fe_transmit_mode \{/) {
-			$mode = FE_TMODE;
-			next;
-		}
-		if ($mode == FE_TMODE) {
-			if (m/\} fe_transmit_mode_t;/) {
-				$mode = NORMAL;
-				next;
-			}
-			if (m/(TRANSMISSION_MODE_)([^\s,=]+)/) {
-				my $macro = "$1$2";
-				my $name = $2;
-				$name =~ s,_,/,;
-
-				$fe_t_mode{$macro} = $name;
-			}
-		}
-		#
-		# Mode FE_BW
-		#
-		if (m/typedef enum fe_bandwidth \{/) {
-			$mode = FE_BW;
-			next;
-		}
-		if ($mode == FE_BW) {
-			if (m/\} fe_bandwidth_t;/) {
-				$mode = NORMAL;
-				next;
-			}
-			if (m/(BANDWIDTH_)([^\s]+)(_MHZ)/) {
-				my $macro = "$1$2$3";
-				my $name = $2;
-				$name =~ s,_,.,;
-				$name *= 1000000;
-
-				$fe_bw{$macro} = $name;
-			} elsif (m/(BANDWIDTH_)([^\s,=]+)/) {
-				my $macro = "$1$2$3";
-				my $name = 0;
-
-				$fe_bw{$macro} = $name;
-			}
-		}
-		#
-		# Mode FE_GINTERVAL
-		#
-		if (m/typedef enum fe_guard_interval \{/) {
-			$mode = FE_GINTERVAL;
-			next;
-		}
-		if ($mode == FE_GINTERVAL) {
-			if (m/\} fe_guard_interval_t;/) {
-				$mode = NORMAL;
-				next;
-			}
-			if (m/(GUARD_INTERVAL_)([^\s,=]+)/) {
-				my $macro = "$1$2";
-				my $name = $2;
-				$name =~ s,_,/,;
-
-				$fe_guard_interval{$macro} = $name;
-			}
-		}
-		#
-		# Mode FE_HIERARCHY
-		#
-		if (m/typedef enum fe_hierarchy \{/) {
-			$mode = FE_HIERARCHY;
-			next;
-		}
-		if ($mode == FE_HIERARCHY) {
-			if (m/\} fe_hierarchy_t;/) {
-				$mode = NORMAL;
-				next;
-			}
-			if (m/(HIERARCHY_)([^\s,=]+)/) {
-				my $macro = "$1$2";
-				my $name = $2;
-				$name =~ s,_,/,;
-
-				$fe_hierarchy{$macro} = $name;
-			}
-		}
-		#
-		# Mode FE_VOLTAGE
-		#
-		if (m/typedef enum fe_sec_voltage \{/) {
-			$mode = FE_VOLTAGE;
-			next;
-		}
-		if ($mode == FE_VOLTAGE) {
-			if (m/\} fe_sec_voltage_t;/) {
-				$mode = NORMAL;
-				next;
-			}
-			if (m/(SEC_VOLTAGE_)([^\s,]+)/) {
-				my $macro = "$1$2";
-				my $name = $2;
-				$name =~ s,_,/,;
-
-				$fe_voltage{$macro} = $name;
-			}
-		}
-		#
-		# Mode FE_TONE
-		#
-		if (m/typedef enum fe_sec_tone_mode \{/) {
-			$mode = FE_TONE;
-			next;
-		}
-		if ($mode == FE_TONE) {
-			if (m/\} fe_sec_tone_mode_t;/) {
-				$mode = NORMAL;
-				next;
-			}
-			if (m/(SEC_TONE_)([^\s,]+)/) {
-				my $macro = "$1$2";
-				my $name = $2;
-				$name =~ s,_,/,;
-
-				$fe_tone{$macro} = $name;
-			}
-		}
-		#
-		# Mode FE_INVERSION
-		#
-		if (m/typedef enum fe_spectral_inversion \{/) {
-			$mode = FE_INVERSION;
-			next;
-		}
-		if ($mode == FE_INVERSION) {
-			if (m/\} fe_spectral_inversion_t;/) {
-				$mode = NORMAL;
-				next;
-			}
-			if (m/(INVERSION_)([^\s,]+)/) {
-				my $macro = "$1$2";
-				my $name = $2;
-				$name =~ s,_,/,;
-
-				$fe_inversion{$macro} = $name;
-			}
-		}
-		#
-		# Mode FE_PILOT
-		#
-		if (m/typedef enum fe_pilot \{/) {
-			$mode = FE_PILOT;
-			next;
-		}
-		if ($mode == FE_PILOT) {
-			if (m/\} fe_pilot_t;/) {
-				$mode = NORMAL;
-				next;
-			}
-			if (m/(PILOT_)([^\s,]+)/) {
-				my $macro = "$1$2";
-				my $name = $2;
-				$name =~ s,_,/,;
-
-				$fe_pilot{$macro} = $name;
-			}
-		}
-		#
-		# Mode FE_ROLLOFF
-		#
-		if (m/typedef enum fe_rolloff \{/) {
-			$mode =FE_ROLLOFF;
-			next;
-		}
-		if ($mode == FE_ROLLOFF) {
-			if (m/\} fe_rolloff_t;/) {
-				$mode = NORMAL;
-				next;
-			}
-			if (m/(ROLLOFF_)([^\s,]+)/) {
-				my $macro = "$1$2";
-				my $name = $2;
-				$name =~ s,_,/,;
-
-				$fe_rolloff{$macro} = $name;
-			}
-		}
-		#
-		# DTV macros
-		#
-		if (m/\#define\s+(DTV_)([^\s]+)\s+\d+/) {
-			next if ($2 eq "IOCTL_MAX_MSGS");
-
-			my $macro = "$1$2";
-			my $name = $2;
-			$dvb_v5{$macro} = $name;
-		}
-		#
-		# Mode FE_DTS
-		#
-		if (m/typedef enum fe_delivery_system \{/) {
-			$mode = FE_DTS;
-			next;
-		}
-		if ($mode == FE_DTS) {
-			if (m/\} fe_delivery_system_t;/) {
-				$mode = NORMAL;
-				next;
-			}
-			if (m/(SYS_)([^\s,=]+)/) {
-				my $macro = "$1$2";
-				my $name = $2;
-				$name =~ s,_,/,;
-
-				$fe_delivery_system{$macro} = $name;
-			}
-		}
-	}
-
-	close IN;
+  my $file = shift;
+
+  my $mode = 0;
+
+  open IN, "<$file" or die "Can't open $file";
+
+  while (<IN>) {
+    #
+    # Mode FE_CAPS
+    #
+    if (m/typedef enum fe_caps\ {/) {
+      $mode = FE_CAPS;
+      next;
+    }
+    if ($mode == FE_CAPS) {
+      if (m/\} fe_caps_t;/) {
+        $mode = NORMAL;
+        next;
+      }
+      if (m/(FE_)([^\s,=]+)/) {
+        my $macro = "$1$2";
+        my $name = $2;
+
+        $fe_caps{$macro} = $name;
+      }
+    }
+    #
+    # Mode FE_STATUS
+    #
+    if (m/typedef enum fe_status\ {/) {
+      $mode = FE_STATUS;
+      next;
+    }
+    if ($mode == FE_STATUS) {
+      if (m/\} fe_status_t;/) {
+        $mode = NORMAL;
+        next;
+      }
+      if (m/(FE_)([^\s,=]+)/) {
+        my $macro = "$1$2";
+        my $name = $2;
+
+        $name =~ s/HAS_//;
+
+        $fe_status{$macro} = $name;
+      }
+    }
+    #
+    # Mode FE_CODERATE
+    #
+    if (m/typedef enum fe_code_rate \{/) {
+      $mode = FE_CODERATE;
+      next;
+    }
+    if ($mode == FE_CODERATE) {
+      if (m/\} fe_code_rate_t;/) {
+        $mode = NORMAL;
+        next;
+      }
+      if (m/(FEC_)([^\s,]+)/) {
+        my $macro = "$1$2";
+        my $name = $2;
+        $name =~ s,_,/,;
+
+        $fe_code_rate{$macro} = $name;
+      }
+    }
+    #
+    # Mode FE_MODULATION
+    #
+    if (m/typedef enum fe_modulation \{/) {
+      $mode = FE_MODULATION;
+      next;
+    }
+    if ($mode == FE_MODULATION) {
+      if (m/\} fe_modulation_t;/) {
+        $mode = NORMAL;
+        next;
+      }
+      if (m/\t([^\s,=]+)/) {
+        my $macro = "$1";
+        my $name = $1;
+        $name =~ s,_,/,;
+
+        $fe_modulation{$macro} = $name;
+      }
+    }
+    #
+    # Mode FE_TMODE
+    #
+    if (m/typedef enum fe_transmit_mode \{/) {
+      $mode = FE_TMODE;
+      next;
+    }
+    if ($mode == FE_TMODE) {
+      if (m/\} fe_transmit_mode_t;/) {
+        $mode = NORMAL;
+        next;
+      }
+      if (m/(TRANSMISSION_MODE_)([^\s,=]+)/) {
+        my $macro = "$1$2";
+        my $name = $2;
+        $name =~ s,_,/,;
+
+        $fe_t_mode{$macro} = $name;
+      }
+    }
+    #
+    # Mode FE_BW
+    #
+    if (m/typedef enum fe_bandwidth \{/) {
+      $mode = FE_BW;
+      next;
+    }
+    if ($mode == FE_BW) {
+      if (m/\} fe_bandwidth_t;/) {
+        $mode = NORMAL;
+        next;
+      }
+      if (m/(BANDWIDTH_)([^\s]+)(_MHZ)/) {
+        my $macro = "$1$2$3";
+        my $name = $2;
+        $name =~ s,_,.,;
+        $name *= 1000000;
+
+        $fe_bw{$macro} = $name;
+      } elsif (m/(BANDWIDTH_)([^\s,=]+)/) {
+        my $macro = "$1$2$3";
+        my $name = 0;
+
+        $fe_bw{$macro} = $name;
+      }
+    }
+    #
+    # Mode FE_GINTERVAL
+    #
+    if (m/typedef enum fe_guard_interval \{/) {
+      $mode = FE_GINTERVAL;
+      next;
+    }
+    if ($mode == FE_GINTERVAL) {
+      if (m/\} fe_guard_interval_t;/) {
+        $mode = NORMAL;
+        next;
+      }
+      if (m/(GUARD_INTERVAL_)([^\s,=]+)/) {
+        my $macro = "$1$2";
+        my $name = $2;
+        $name =~ s,_,/,;
+
+        $fe_guard_interval{$macro} = $name;
+      }
+    }
+    #
+    # Mode FE_HIERARCHY
+    #
+    if (m/typedef enum fe_hierarchy \{/) {
+      $mode = FE_HIERARCHY;
+      next;
+    }
+    if ($mode == FE_HIERARCHY) {
+      if (m/\} fe_hierarchy_t;/) {
+        $mode = NORMAL;
+        next;
+      }
+      if (m/(HIERARCHY_)([^\s,=]+)/) {
+        my $macro = "$1$2";
+        my $name = $2;
+        $name =~ s,_,/,;
+
+        $fe_hierarchy{$macro} = $name;
+      }
+    }
+    #
+    # Mode FE_VOLTAGE
+    #
+    if (m/typedef enum fe_sec_voltage \{/) {
+      $mode = FE_VOLTAGE;
+      next;
+    }
+    if ($mode == FE_VOLTAGE) {
+      if (m/\} fe_sec_voltage_t;/) {
+        $mode = NORMAL;
+        next;
+      }
+      if (m/(SEC_VOLTAGE_)([^\s,]+)/) {
+        my $macro = "$1$2";
+        my $name = $2;
+        $name =~ s,_,/,;
+
+        $fe_voltage{$macro} = $name;
+      }
+    }
+    #
+    # Mode FE_TONE
+    #
+    if (m/typedef enum fe_sec_tone_mode \{/) {
+      $mode = FE_TONE;
+      next;
+    }
+    if ($mode == FE_TONE) {
+      if (m/\} fe_sec_tone_mode_t;/) {
+        $mode = NORMAL;
+        next;
+      }
+      if (m/(SEC_TONE_)([^\s,]+)/) {
+        my $macro = "$1$2";
+        my $name = $2;
+        $name =~ s,_,/,;
+
+        $fe_tone{$macro} = $name;
+      }
+    }
+    #
+    # Mode FE_INVERSION
+    #
+    if (m/typedef enum fe_spectral_inversion \{/) {
+      $mode = FE_INVERSION;
+      next;
+    }
+    if ($mode == FE_INVERSION) {
+      if (m/\} fe_spectral_inversion_t;/) {
+        $mode = NORMAL;
+        next;
+      }
+      if (m/(INVERSION_)([^\s,]+)/) {
+        my $macro = "$1$2";
+        my $name = $2;
+        $name =~ s,_,/,;
+
+        $fe_inversion{$macro} = $name;
+      }
+    }
+    #
+    # Mode FE_PILOT
+    #
+    if (m/typedef enum fe_pilot \{/) {
+      $mode = FE_PILOT;
+      next;
+    }
+    if ($mode == FE_PILOT) {
+      if (m/\} fe_pilot_t;/) {
+        $mode = NORMAL;
+        next;
+      }
+      if (m/(PILOT_)([^\s,]+)/) {
+        my $macro = "$1$2";
+        my $name = $2;
+        $name =~ s,_,/,;
+
+        $fe_pilot{$macro} = $name;
+      }
+    }
+    #
+    # Mode FE_ROLLOFF
+    #
+    if (m/typedef enum fe_rolloff \{/) {
+      $mode =FE_ROLLOFF;
+      next;
+    }
+    if ($mode == FE_ROLLOFF) {
+      if (m/\} fe_rolloff_t;/) {
+        $mode = NORMAL;
+        next;
+      }
+      if (m/(ROLLOFF_)([^\s,]+)/) {
+        my $macro = "$1$2";
+        my $name = $2;
+        $name =~ s,_,/,;
+
+        $fe_rolloff{$macro} = $name;
+      }
+    }
+    #
+    # DTV macros
+    #
+    if (m/\#define\s+(DTV_)([^\s]+)\s+\d+/) {
+      next if ($2 eq "IOCTL_MAX_MSGS");
+
+      my $macro = "$1$2";
+      my $name = $2;
+      $dvb_v5{$macro} = $name;
+    }
+    #
+    # Mode FE_DTS
+    #
+    if (m/typedef enum fe_delivery_system \{/) {
+      $mode = FE_DTS;
+      next;
+    }
+    if ($mode == FE_DTS) {
+      if (m/\} fe_delivery_system_t;/) {
+        $mode = NORMAL;
+        next;
+      }
+      if (m/(SYS_)([^\s,=]+)/) {
+        my $macro = "$1$2";
+        my $name = $2;
+        $name =~ s,_,/,;
+
+        $fe_delivery_system{$macro} = $name;
+      }
+    }
+  }
+
+  close IN;
 }
 
 sub sort_func {
-	my $aa = $a;
-	my $bb = $b;
-
-	my $str_a;
-	my $str_b;
-
-	while ($aa && $bb) {
-		# Strings before a number
-		if ($aa =~ /^([^\d]+)\d/) { $str_a = $1 } else { $str_a = "" };
-		if ($bb =~ /^([^\d]+)\d/) { $str_b = $1 } else { $str_b = "" };
-		if ($str_a && $str_b) {
-			my $cmp = $str_a cmp $str_b;
-
-			return $cmp if ($cmp);
-
-			$aa =~ s/^($str_a)//;
-			$bb =~ s/^($str_b)//;
-			next;
-		}
-
-		# Numbers
-		if ($aa =~ /^(\d+)/) { $str_a = $1 } else { $str_a = "" };
-		if ($bb =~ /^(\d+)/) { $str_b = $1 } else { $str_b = "" };
-		if ($str_a && $str_b) {
-			my $cmp = $str_a <=> $str_b;
-
-			return $cmp if ($cmp);
-
-			$aa =~ s/^($str_a)//;
-			$bb =~ s/^($str_b)//;
-			next;
-		}
-		last;
-	}
-
-	return $a cmp $b;
+  my $aa = $a;
+  my $bb = $b;
+
+  my $str_a;
+  my $str_b;
+
+  while ($aa && $bb) {
+    # Strings before a number
+    if ($aa =~ /^([^\d]+)\d/) { $str_a = $1 } else { $str_a = "" };
+    if ($bb =~ /^([^\d]+)\d/) { $str_b = $1 } else { $str_b = "" };
+    if ($str_a && $str_b) {
+      my $cmp = $str_a cmp $str_b;
+
+      return $cmp if ($cmp);
+
+      $aa =~ s/^($str_a)//;
+      $bb =~ s/^($str_b)//;
+      next;
+    }
+
+    # Numbers
+    if ($aa =~ /^(\d+)/) { $str_a = $1 } else { $str_a = "" };
+    if ($bb =~ /^(\d+)/) { $str_b = $1 } else { $str_b = "" };
+    if ($str_a && $str_b) {
+      my $cmp = $str_a <=> $str_b;
+
+      return $cmp if ($cmp);
+
+      $aa =~ s/^($str_a)//;
+      $bb =~ s/^($str_b)//;
+      next;
+    }
+    last;
+  }
+
+  return $a cmp $b;
 }
 
-sub output_arrays($$$$)
+sub output_arrays($$$$$)
 {
-	my $name = shift;
-	my $struct = shift;
-	my $type = shift;
-	my $bitmap = shift;
-
-	my $size = keys(%$struct);
-	my $max;
-
-	return if (%$struct == 0);
-
-	$type .= " " if (!($type =~ m/\*$/));
-
-	if ($bitmap) {
-		printf OUT "struct %s {\n\t\%s idx;\n\tchar *name;\n} %s[%i] = {\n",
-			$name, $type, $name, $size;
-	} else {
-		printf OUT "const %s%s[%i] = {\n", $type, $name, $size + 1;
-	}
-
-	foreach my $i (sort keys %$struct) {
-		my $len = length($i);
-		$max = $len if ($len > $max);
-	}
-
-	foreach my $i (sort sort_func keys %$struct) {
-		if ($bitmap) {
-			printf OUT "\t{ %s, ", $i;
-		} else {
-			printf OUT "\t[%s] = ", $i;
-		}
-		my $len = length($i);
-		while ($len < $max) {
-			print OUT " ";
-			$len++;
-		}
-		if ($bitmap) {
-			printf OUT "\"%s\" },\n", $struct->{$i};
-		} else {
-			if ($type eq "char *") {
-				printf OUT "\"%s\",\n", $struct->{$i};
-			} else {
-				printf OUT "%s,\n", $struct->{$i};
-			}
-		}
-	}
-
-	if (!$bitmap) {
-		printf OUT "\t[%s] = ", $size;
-		if ($type eq "char *") {
-			printf OUT "NULL,\n";
-		} else {
-			printf OUT "0,\n";
-		}
-	}
-
-
-	printf OUT "};\n\n";
+  my $name = shift;
+  my $struct = shift;
+  my $type = shift;
+  my $bitmap = shift;
+  my $decl = shift;
+
+  my $size = keys(%$struct);
+  my $max;
+
+  return if (%$struct == 0);
+
+  $type .= " " if (!($type =~ m/\*$/));
+
+  if ($bitmap) {
+    printf OUT "struct %s", $name;
+    if ($decl) {
+      printf OUT " {\n\t\%s idx;\n\tchar *name;\n}", $type;
+    }
+    if ($decl) {
+      printf OUT ";\nextern struct %s", $name;
+    }
+    printf OUT " %s[%i]", $name, $size;
+  } else {
+    printf OUT "const %s%s[%i]", $type, $name, $size + 1;
+  }
+
+  if ($decl) {
+    printf OUT ";\n";
+  } else {
+    printf OUT " = {\n";
+
+    foreach my $i (sort keys %$struct) {
+      my $len = length($i);
+      $max = $len if ($len > $max);
+    }
+
+    foreach my $i (sort sort_func keys %$struct) {
+      if ($bitmap) {
+        printf OUT "\t{ %s, ", $i;
+      } else {
+        printf OUT "\t[%s] = ", $i;
+      }
+      my $len = length($i);
+      while ($len < $max) {
+        print OUT " ";
+        $len++;
+      }
+      if ($bitmap) {
+        printf OUT "\"%s\" },\n", $struct->{$i};
+      } else {
+        if ($type eq "char *") {
+          printf OUT "\"%s\",\n", $struct->{$i};
+        } else {
+          printf OUT "%s,\n", $struct->{$i};
+        }
+      }
+    }
+
+    if (!$bitmap) {
+      printf OUT "\t[%s] = ", $size;
+      if ($type eq "char *") {
+        printf OUT "NULL,\n";
+      } else {
+        printf OUT "0,\n";
+      }
+    }
+
+
+    printf OUT "};\n\n";
+  }
 }
 
 my $fe_file = "$dir/linux/dvb/frontend.h";
@@ -470,21 +483,47 @@ print OUT <<EOF;
 #define _DVB_V5_CONSTS_H
 #include "dvb_frontend.h"
 EOF
-output_arrays ("fe_caps_name", \%fe_caps, "unsigned", 1);
-output_arrays ("fe_status_name", \%fe_status, "unsigned", 1);
-output_arrays ("fe_code_rate_name", \%fe_code_rate, "char *", 0);
-output_arrays ("fe_modulation_name", \%fe_modulation, "char *", 0);
-output_arrays ("fe_transmission_mode_name", \%fe_t_mode, "char *", 0);
-output_arrays ("fe_bandwidth_name", \%fe_bw, "unsigned", 0);
-output_arrays ("fe_guard_interval_name", \%fe_guard_interval, "char *", 0);
-output_arrays ("fe_hierarchy_name", \%fe_hierarchy, "char *", 0);
-output_arrays ("fe_voltage_name", \%fe_voltage, "char *", 0);
-output_arrays ("fe_tone_name", \%fe_tone, "char *", 0);
-output_arrays ("fe_inversion_name", \%fe_inversion, "char *", 0);
-output_arrays ("fe_pilot_name", \%fe_pilot, "char *", 0);
-output_arrays ("fe_rolloff_name", \%fe_rolloff, "char *", 0);
-output_arrays ("dvb_v5_name", \%dvb_v5, "char *", 0);
-output_arrays ("delivery_system_name", \%fe_delivery_system, "char *", 0);
+output_arrays ("fe_caps_name", \%fe_caps, "unsigned", 1, 1);
+output_arrays ("fe_status_name", \%fe_status, "unsigned", 1, 1);
+output_arrays ("fe_code_rate_name", \%fe_code_rate, "char *", 0, 1);
+output_arrays ("fe_modulation_name", \%fe_modulation, "char *", 0, 1);
+output_arrays ("fe_transmission_mode_name", \%fe_t_mode, "char *", 0, 1);
+output_arrays ("fe_bandwidth_name", \%fe_bw, "unsigned", 0, 1);
+output_arrays ("fe_guard_interval_name", \%fe_guard_interval, "char *", 0, 1);
+output_arrays ("fe_hierarchy_name", \%fe_hierarchy, "char *", 0, 1);
+output_arrays ("fe_voltage_name", \%fe_voltage, "char *", 0, 1);
+output_arrays ("fe_tone_name", \%fe_tone, "char *", 0, 1);
+output_arrays ("fe_inversion_name", \%fe_inversion, "char *", 0, 1);
+output_arrays ("fe_pilot_name", \%fe_pilot, "char *", 0, 1);
+output_arrays ("fe_rolloff_name", \%fe_rolloff, "char *", 0, 1);
+output_arrays ("dvb_v5_name", \%dvb_v5, "char *", 0, 1);
+output_arrays ("delivery_system_name", \%fe_delivery_system, "char *", 0, 1);
 printf OUT "#endif\n";
 
 close OUT;
+
+# Generate a source file with the API conversions
+open OUT, ">dvb-v5.c" or die "Can't write on dvb-v5.c";
+print OUT <<EOF;
+/*
+ * File auto-generated from the kernel sources. Please, don't edit it
+ */
+#include "dvb-v5.h"
+EOF
+output_arrays ("fe_caps_name", \%fe_caps, "unsigned", 1, 0);
+output_arrays ("fe_status_name", \%fe_status, "unsigned", 1, 0);
+output_arrays ("fe_code_rate_name", \%fe_code_rate, "char *", 0, 0);
+output_arrays ("fe_modulation_name", \%fe_modulation, "char *", 0, 0);
+output_arrays ("fe_transmission_mode_name", \%fe_t_mode, "char *", 0, 0);
+output_arrays ("fe_bandwidth_name", \%fe_bw, "unsigned", 0, 0);
+output_arrays ("fe_guard_interval_name", \%fe_guard_interval, "char *", 0, 0);
+output_arrays ("fe_hierarchy_name", \%fe_hierarchy, "char *", 0, 0);
+output_arrays ("fe_voltage_name", \%fe_voltage, "char *", 0, 0);
+output_arrays ("fe_tone_name", \%fe_tone, "char *", 0, 0);
+output_arrays ("fe_inversion_name", \%fe_inversion, "char *", 0, 0);
+output_arrays ("fe_pilot_name", \%fe_pilot, "char *", 0, 0);
+output_arrays ("fe_rolloff_name", \%fe_rolloff, "char *", 0, 0);
+output_arrays ("dvb_v5_name", \%dvb_v5, "char *", 0, 0);
+output_arrays ("delivery_system_name", \%fe_delivery_system, "char *", 0, 0);
+
+close OUT;
diff --git a/lib/libdvbv5/libsat.c b/lib/libdvbv5/libsat.c
index 253e92e..e99cc25 100644
--- a/lib/libdvbv5/libsat.c
+++ b/lib/libdvbv5/libsat.c
@@ -23,6 +23,7 @@
 #include <unistd.h>
 
 #include "dvb-fe.h"
+#include "dvb-v5-std.h"
 
 struct dvbsat_lnb lnb[] = {
 	{
@@ -271,7 +272,8 @@ static int dvbsat_scr_odu_channel_change(struct diseqc_cmd *cmd,
 static int dvbsat_diseqc_set_input(struct dvb_v5_fe_parms *parms, uint16_t t)
 {
 	int rc;
-        enum dvbsat_polarization pol = parms->pol;
+        enum dvb_sat_polarization pol;
+        dvb_fe_retrieve_parm(parms, DTV_POLARIZATION,& pol);
 	int pol_v = (pol == POLARIZATION_V) || (pol == POLARIZATION_R);
 	int high_band = parms->high_band;
 	int sat_number = parms->sat_number;
@@ -346,7 +348,8 @@ static int dvbsat_diseqc_set_input(struct dvb_v5_fe_parms *parms, uint16_t t)
 int dvb_satellite_set_parms(struct dvb_v5_fe_parms *parms)
 {
 	struct dvbsat_lnb *lnb = parms->lnb;
-        enum dvbsat_polarization pol = parms->pol;
+        enum dvb_sat_polarization pol;
+        dvb_fe_retrieve_parm(parms, DTV_POLARIZATION,& pol);
 	uint32_t freq;
 	uint16_t t = 0;
 	uint32_t voltage = SEC_VOLTAGE_13;
diff --git a/utils/dvb/dvbv5-scan.c b/utils/dvb/dvbv5-scan.c
index 125e285..256fb00 100644
--- a/utils/dvb/dvbv5-scan.c
+++ b/utils/dvb/dvbv5-scan.c
@@ -35,6 +35,7 @@
 #include <linux/dvb/dmx.h>
 #include "dvb-file.h"
 #include "dvb-demux.h"
+#include "dvb-v5-std.h"
 #include "libscan.h"
 
 #define PROGRAM_NAME	"dvbv5-scan"
@@ -130,7 +131,7 @@ static int check_frontend(struct dvb_v5_fe_parms *parms, int timeout)
 static int new_freq_is_needed(struct dvb_entry *entry,
 			      struct dvb_entry *last_entry,
 			      uint32_t freq,
-			      enum dvbsat_polarization pol,
+			      enum dvb_sat_polarization pol,
 			      int shift)
 {
 	int i;
@@ -260,7 +261,7 @@ static void add_other_freq_entries(struct dvb_file *dvb_file,
 {
 	int i;
 	uint32_t freq, shift = 0;
-	enum dvbsat_polarization pol = POLARIZATION_OFF;
+	enum dvb_sat_polarization pol = POLARIZATION_OFF;
 
 	if (!dvb_desc->nit_table.frequency)
 		return;
-- 
1.7.2.5

