Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:55809 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab3FDTPL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Jun 2013 15:15:11 -0400
Received: by mail-wg0-f41.google.com with SMTP id k13so4183272wgh.0
        for <linux-media@vger.kernel.org>; Tue, 04 Jun 2013 12:15:10 -0700 (PDT)
From: Konke Radlow <koradlow@gmail.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, hdegoede@redhat.com
Subject: [RFC PATCHv2 2/3] rds-ctl: support RDS-EON and TMC-tuning info
Date: Tue,  4 Jun 2013 20:15:02 +0100
Message-Id: <487ee6388633195ff256b3208696e6403c5f0ffd.1370373234.git.koradlow@gmail.com>
In-Reply-To: <1370373303-6605-1-git-send-email-koradlow@gmail.com>
References: <1370373303-6605-1-git-send-email-koradlow@gmail.com>
In-Reply-To: <2668df294d662dbf33ebae87bc06fd063ea4cfd2.1370373234.git.koradlow@gmail.com>
References: <2668df294d662dbf33ebae87bc06fd063ea4cfd2.1370373234.git.koradlow@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Konke Radlow <koradlow@gmail.com>

rds-ctl.cpp: added functionality to print RDS-EON information

Signed-off-by: Konke Radlow <koradlow@gmail.com>

rds-ctl.cpp: added functionality to print RDS-TMC tuning information

Signed-off-by: Konke Radlow <koradlow@gmail.com>

rds-ctl.cpp: clarify option description, change
trigger condition for printing TMC Tuning information

Signed-off-by: Konke Radlow <koradlow@gmail.com>
---
 utils/rds-ctl/rds-ctl.cpp |   59 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 57 insertions(+), 2 deletions(-)

diff --git a/utils/rds-ctl/rds-ctl.cpp b/utils/rds-ctl/rds-ctl.cpp
index 191cfee..d894ec1 100644
--- a/utils/rds-ctl/rds-ctl.cpp
+++ b/utils/rds-ctl/rds-ctl.cpp
@@ -130,7 +130,7 @@ static void usage_hint(void)
 static void usage_common(void)
 {
 	printf("\nGeneral/Common options:\n"
-	       "  --all              display all information available\n"
+	       "  --all              display all device information available\n"
 	       "  -D, --info         show driver info [VIDIOC_QUERYCAP]\n"
 	       "  -d, --device=<dev> use device <dev>\n"
 	       "                     if <dev> is a single digit, then /dev/radio<dev> is used\n"
@@ -172,7 +172,7 @@ static void usage_rds(void)
 	       "                     <default>: 5000 ms\n"
 	       "  --print-block      prints all valid RDS fields, whenever a value is updated\n"
 	       "                     instead of printing only updated values\n"
-	       "  --tmc              enables decoding of TMC (Traffic Message Channel) data\n"
+	       "  --tmc              print information about TMC (Traffic Message Channel) messages\n"
 	       "  --silent           only set the result code, do not print any messages\n"
 	       "  --verbose          turn on verbose mode - every received RDS group\n"
 	       "                     will be printed\n"
@@ -517,6 +517,30 @@ static void print_rds_tmc(const struct v4l2_rds *handle, uint32_t updated_fields
 	}
 }
 
+static void print_rds_tmc_tuning(const struct v4l2_rds *handle, uint32_t updated_fields)
+{
+	const struct v4l2_tmc_tuning *tuning = &handle->tmc.tuning;
+	const struct v4l2_tmc_station *station;
+	
+	if (updated_fields & V4L2_RDS_TMC_TUNING) {
+		printf("\nTMC Service provider: %s, %u alternative stations\n", handle->tmc.spn, tuning->station_cnt);
+		for (int i = 0; i < tuning->station_cnt; i++) {
+			station = &tuning->station[i];
+			printf("PI(ON %02u) = %04x, AFs: %u, mapped AFs: %u \n", i, station->pi,
+					station->afi.af_size, station->afi.mapped_af_size);
+			for (int j = 0; j < station->afi.af_size; j++)
+				printf("        AF%02d: %.1fMHz\n", j, station->afi.af[j] / 1000000.0);
+			for (int k = 0; k < station->afi.mapped_af_size; k++)
+				printf("        m_AF%02d: %.1fMHz => %.1fMHz\n", k,
+						station->afi.mapped_af_tuning[k] / 1000000.0,
+						station->afi.mapped_af[k] / 1000000.0);
+			if (station->ltn != 0 || station->msg != 0 || station-> sid != 0)
+				printf("        ltn: %02x, msg: %02x, sid: %02x\n", station->ltn,
+						station->msg, station->sid);
+		}
+	}
+}
+
 static void print_rds_statistics(const struct v4l2_rds_statistics *statistics)
 {
 	printf("\n\nRDS Statistics: \n");
@@ -557,6 +581,33 @@ static void print_rds_af(const struct v4l2_rds_af_set *af_set)
 	}
 }
 
+static void print_rds_eon(const struct v4l2_rds_eon_set *eon_set)
+{
+	int counter = 0;
+
+	printf("\n\nEnhanced Other Network information: %u channels", eon_set->size);
+	for (int i = 0; i < eon_set->size; i++, counter++) {
+		if (eon_set->eon[i].valid_fields & V4L2_RDS_PI)
+			printf("\nPI(ON %02i) =  %04x", i, eon_set->eon[i].pi);
+		if (eon_set->eon[i].valid_fields & V4L2_RDS_PS)
+			printf("\nPS(ON %02i) =  %s", i, eon_set->eon[i].ps);
+		if (eon_set->eon[i].valid_fields & V4L2_RDS_PTY)
+			printf("\nPTY(ON %02i) =  %0u", i, eon_set->eon[i].pty);
+		if (eon_set->eon[i].valid_fields & V4L2_RDS_LSF)
+			printf("\nLSF(ON %02i) =  %0u", i, eon_set->eon[i].lsf);
+		if (eon_set->eon[i].valid_fields & V4L2_RDS_AF)
+			printf("\nPTY(ON %02i) =  %0u", i, eon_set->eon[i].pty);
+		if (eon_set->eon[i].valid_fields & V4L2_RDS_TP)
+			printf("\nTP(ON %02i): %s", i, eon_set->eon[i].tp? "yes":"no");
+		if (eon_set->eon[i].valid_fields & V4L2_RDS_TA)
+			printf("\nTA(ON %02i): %s", i, eon_set->eon[i].tp? "yes":"no");
+		if (eon_set->eon[i].valid_fields & V4L2_RDS_AF) {
+			printf("\nAF(ON %02i): size=%i", i, eon_set->eon[i].af.size);
+			print_rds_af(&(eon_set->eon[i].af));
+		}
+	}
+}
+
 static void print_rds_pi(const struct v4l2_rds *handle)
 {
 	printf("\nArea Coverage: %s", v4l2_rds_get_coverage_str(handle));
@@ -614,6 +665,8 @@ static void print_rds_data(const struct v4l2_rds *handle, uint32_t updated_field
 	}
 	if (updated_fields & V4L2_RDS_AF && handle->valid_fields & V4L2_RDS_AF)
 		print_rds_af(&handle->rds_af);
+	if (updated_fields & V4L2_RDS_TMC_TUNING && handle->valid_fields & V4L2_RDS_TMC_TUNING);
+		print_rds_tmc_tuning(handle, updated_fields);
 	if (params.options[OptPrintBlock])
 		printf("\n");
 	if (params.options[OptTMC])
@@ -669,6 +722,8 @@ static void read_rds_from_fd(const int fd)
 
 	/* try to receive and decode RDS data */
 	read_rds(rds_handle, fd, params.wait_limit);
+	if (rds_handle->valid_fields & V4L2_RDS_EON)
+		print_rds_eon(&rds_handle->rds_eon);
 	print_rds_statistics(&rds_handle->rds_statistics);
 
 	v4l2_rds_destroy(rds_handle);
-- 
1.7.10.4

