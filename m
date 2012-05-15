Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:57699 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932696Ab2EOVwc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 May 2012 17:52:32 -0400
Received: by weyu7 with SMTP id u7so38877wey.19
        for <linux-media@vger.kernel.org>; Tue, 15 May 2012 14:52:31 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH] renamings and librarization
Date: Tue, 15 May 2012 23:52:09 +0200
Message-Id: <1337118729-8350-1-git-send-email-neolynx@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 lib/include/dvb-fe.h           |    4 ++--
 lib/include/dvb-file.h         |   12 ++++++++++--
 lib/include/dvb-frontend.h     |    2 +-
 lib/include/libsat.h           |   27 +++++++++++++++++++++------
 lib/libdvbv5/dvb-file.c        |    2 +-
 lib/libdvbv5/libsat.c          |   20 +++++++++++++++-----
 utils/dvb/dvb-format-convert.c |    2 +-
 utils/dvb/dvbv5-scan.c         |    8 ++++----
 utils/dvb/dvbv5-zap.c          |    2 +-
 9 files changed, 56 insertions(+), 23 deletions(-)

diff --git a/lib/include/dvb-fe.h b/lib/include/dvb-fe.h
index 5150ebf..dbcd720 100644
--- a/lib/include/dvb-fe.h
+++ b/lib/include/dvb-fe.h
@@ -74,12 +74,12 @@ struct dvb_v5_fe_parms {
 	struct dvb_v5_stats		stats;
 
 	/* Satellite specific stuff, specified by the library client */
-	struct dvb_satellite_lnb	*lnb;
+	struct dvbsat_lnb       	*lnb;
 	int				sat_number;
 	unsigned			freq_bpf;
 
 	/* Satellite specific stuff, used internally */
-	enum polarization		pol;
+	enum dvbsat_polarization        pol;
 	int				high_band;
 	unsigned			diseqc_wait;
 	unsigned			freq_offset;
diff --git a/lib/include/dvb-file.h b/lib/include/dvb-file.h
index 7e0803e..ed74eef 100644
--- a/lib/include/dvb-file.h
+++ b/lib/include/dvb-file.h
@@ -34,7 +34,7 @@ struct dvb_entry {
 
 	char *location;
 
-	enum polarization pol;
+	enum dvbsat_polarization pol;
 	int sat_number;
 	unsigned freq_bpf;
 	unsigned diseqc_wait;
@@ -91,6 +91,10 @@ enum file_formats {
 
 struct dvb_descriptors;
 
+#ifdef __cplusplus
+extern "C" {
+#endif
+
 static inline void dvb_file_free(struct dvb_file *dvb_file)
 {
 	struct dvb_entry *entry = dvb_file->first_entry, *next;
@@ -145,10 +149,14 @@ int store_dvb_channel(struct dvb_file **dvb_file,
 		      int get_detected, int get_nit);
 int parse_delsys(const char *name);
 enum file_formats parse_format(const char *name);
-struct dvb_file *read_file_format(const char *fname,
+struct dvb_file *dvb_read_file_format(const char *fname,
 					   uint32_t delsys,
 					   enum file_formats format);
 int write_file_format(const char *fname,
 		      struct dvb_file *dvb_file,
 		      uint32_t delsys,
 		      enum file_formats format);
+
+#ifdef __cplusplus
+}
+#endif
diff --git a/lib/include/dvb-frontend.h b/lib/include/dvb-frontend.h
index 7e7cb64..3ccaf24 100644
--- a/lib/include/dvb-frontend.h
+++ b/lib/include/dvb-frontend.h
@@ -328,7 +328,7 @@ typedef enum fe_pilot {
 	PILOT_AUTO,
 } fe_pilot_t;
 
-typedef enum fe_rolloff {
+typedef enum fe_rolloff { // FIXME: move to libsat.h ?
 	ROLLOFF_35, /* Implied value in DVB-S, default for DVB-S2 */
 	ROLLOFF_20,
 	ROLLOFF_25,
diff --git a/lib/include/libsat.h b/lib/include/libsat.h
index cb78cbb..690fe61 100644
--- a/lib/include/libsat.h
+++ b/lib/include/libsat.h
@@ -17,7 +17,10 @@
  * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
  */
 
-enum polarization {
+#ifndef _libsat_
+#define _libsat_
+
+enum dvbsat_polarization {
 	POLARIZATION_OFF	= 0,
 	POLARIZATION_H		= 1,
 	POLARIZATION_V		= 2,
@@ -25,26 +28,38 @@ enum polarization {
 	POLARIZATION_R		= 4,
 };
 
-struct dvb_satellite_freqrange {
+struct dvbsat_freqrange {
 	unsigned low, high;
 };
 
-struct dvb_satellite_lnb {
+struct dvbsat_lnb {
 	char *name;
 	char *alias;
 	unsigned lowfreq, highfreq;
 
 	unsigned rangeswitch;
 
-	struct dvb_satellite_freqrange freqrange[2];
+	struct dvbsat_freqrange freqrange[2];
 };
 
-struct dvb_v5_fe_parms *parms;
+struct dvb_v5_fe_parms;
+
+extern const char *dvbsat_polarization_name[5];
+
+#ifdef __cplusplus
+extern "C" {
+#endif
 
 /* From libsat.c */
 int search_lnb(char *name);
 int print_lnb(int i);
 void print_all_lnb(void);
-struct dvb_satellite_lnb *get_lnb(int i);
+struct dvbsat_lnb *get_lnb(int i);
 int dvb_satellite_set_parms(struct dvb_v5_fe_parms *parms);
 int dvb_satellite_get_parms(struct dvb_v5_fe_parms *parms);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
diff --git a/lib/libdvbv5/dvb-file.c b/lib/libdvbv5/dvb-file.c
index e1f2195..b54c049 100644
--- a/lib/libdvbv5/dvb-file.c
+++ b/lib/libdvbv5/dvb-file.c
@@ -1077,7 +1077,7 @@ int parse_delsys(const char *name)
 	return -1;
 }
 
-struct dvb_file *read_file_format(const char *fname,
+struct dvb_file *dvb_read_file_format(const char *fname,
 				  uint32_t delsys,
 				  enum file_formats format)
 {
diff --git a/lib/libdvbv5/libsat.c b/lib/libdvbv5/libsat.c
index d155686..253e92e 100644
--- a/lib/libdvbv5/libsat.c
+++ b/lib/libdvbv5/libsat.c
@@ -24,7 +24,7 @@
 
 #include "dvb-fe.h"
 
-struct dvb_satellite_lnb lnb[] = {
+struct dvbsat_lnb lnb[] = {
 	{
 		.name = "Europe",
 		.alias = "UNIVERSAL",
@@ -130,7 +130,7 @@ void print_all_lnb(void)
 	}
 }
 
-struct dvb_satellite_lnb *get_lnb(int i)
+struct dvbsat_lnb *get_lnb(int i)
 {
 	if (i >= ARRAY_SIZE(lnb))
 		return NULL;
@@ -212,6 +212,8 @@ static void dvbsat_diseqc_prep_frame_addr(struct diseqc_cmd *cmd,
 	cmd->address = diseqc_addr[type];
 }
 
+struct dvb_v5_fe_parms *parms; // legacy code, used for parms->fd, FIXME anyway
+
 /* Inputs are numbered from 1 to 16, according with the spec */
 static int dvbsat_diseqc_write_to_port_group(struct diseqc_cmd *cmd,
 					     int high_band,
@@ -269,7 +271,7 @@ static int dvbsat_scr_odu_channel_change(struct diseqc_cmd *cmd,
 static int dvbsat_diseqc_set_input(struct dvb_v5_fe_parms *parms, uint16_t t)
 {
 	int rc;
-        enum polarization pol = parms->pol;
+        enum dvbsat_polarization pol = parms->pol;
 	int pol_v = (pol == POLARIZATION_V) || (pol == POLARIZATION_R);
 	int high_band = parms->high_band;
 	int sat_number = parms->sat_number;
@@ -343,8 +345,8 @@ static int dvbsat_diseqc_set_input(struct dvb_v5_fe_parms *parms, uint16_t t)
 
 int dvb_satellite_set_parms(struct dvb_v5_fe_parms *parms)
 {
-	struct dvb_satellite_lnb *lnb = parms->lnb;
-        enum polarization pol = parms->pol;
+	struct dvbsat_lnb *lnb = parms->lnb;
+        enum dvbsat_polarization pol = parms->pol;
 	uint32_t freq;
 	uint16_t t = 0;
 	uint32_t voltage = SEC_VOLTAGE_13;
@@ -407,3 +409,11 @@ int dvb_satellite_get_parms(struct dvb_v5_fe_parms *parms)
 
 	return 0;
 }
+
+const char *dvbsat_polarization_name[5] = {
+	"OFF",
+	"H",
+	"V",
+	"L",
+	"R",
+};
diff --git a/utils/dvb/dvb-format-convert.c b/utils/dvb/dvb-format-convert.c
index 799fe8f..6db5219 100644
--- a/utils/dvb/dvb-format-convert.c
+++ b/utils/dvb/dvb-format-convert.c
@@ -79,7 +79,7 @@ static int convert_file(struct arguments *args)
 
 	printf("Reading file %s\n", args->input_file);
 
-	dvb_file = read_file_format(args->input_file, args->delsys,
+	dvb_file = dvb_read_file_format(args->input_file, args->delsys,
 				    args->input_format);
 	if (!dvb_file) {
 		fprintf(stderr, "Error reading file %s\n", args->input_file);
diff --git a/utils/dvb/dvbv5-scan.c b/utils/dvb/dvbv5-scan.c
index 48e083b..125e285 100644
--- a/utils/dvb/dvbv5-scan.c
+++ b/utils/dvb/dvbv5-scan.c
@@ -130,7 +130,7 @@ static int check_frontend(struct dvb_v5_fe_parms *parms, int timeout)
 static int new_freq_is_needed(struct dvb_entry *entry,
 			      struct dvb_entry *last_entry,
 			      uint32_t freq,
-			      enum polarization pol,
+			      enum dvbsat_polarization pol,
 			      int shift)
 {
 	int i;
@@ -260,7 +260,7 @@ static void add_other_freq_entries(struct dvb_file *dvb_file,
 {
 	int i;
 	uint32_t freq, shift = 0;
-	enum polarization pol = POLARIZATION_OFF;
+	enum dvbsat_polarization pol = POLARIZATION_OFF;
 
 	if (!dvb_desc->nit_table.frequency)
 		return;
@@ -307,7 +307,7 @@ static int run_scan(struct arguments *args,
 		sys = SYS_UNDEFINED;
 		break;
 	}
-	dvb_file = read_file_format(args->confname, sys,
+	dvb_file = dvb_read_file_format(args->confname, sys,
 				    args->input_format);
 	if (!dvb_file)
 		return -2;
@@ -557,7 +557,7 @@ int main(int argc, char **argv)
 	if (verbose)
 		fprintf(stderr, "using demux '%s'\n", args.demux_dev);
 
-	parms = dvb_fe_open(args.adapter, args.frontend, verbose, 0);
+	struct dvb_v5_fe_parms *parms = dvb_fe_open(args.adapter, args.frontend, verbose, 0);
 	if (!parms)
 		return -1;
 	if (lnb >= 0)
diff --git a/utils/dvb/dvbv5-zap.c b/utils/dvb/dvbv5-zap.c
index c32a6ba..01bf5d9 100644
--- a/utils/dvb/dvbv5-zap.c
+++ b/utils/dvb/dvbv5-zap.c
@@ -128,7 +128,7 @@ static int parse(struct arguments *args,
 		sys = SYS_UNDEFINED;
 		break;
 	}
-	dvb_file = read_file_format(args->confname, sys,
+	dvb_file = dvb_read_file_format(args->confname, sys,
 				    args->input_format);
 	if (!dvb_file)
 		return -2;
-- 
1.7.2.5

