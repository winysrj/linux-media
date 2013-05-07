Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:51702 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758776Ab3EGQYm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 May 2013 12:24:42 -0400
Received: by mail-wg0-f49.google.com with SMTP id j13so804186wgh.28
        for <linux-media@vger.kernel.org>; Tue, 07 May 2013 09:24:41 -0700 (PDT)
From: Konke Radlow <koradlow@gmail.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, hdegoede@redhat.com
Subject: [RFC PATCH 4/4] rds-ctl.cpp: added functionality to print RDS-TMC tuning information
Date: Tue,  7 May 2013 17:24:23 +0100
Message-Id: <d18d327782b3c3ca2aaffaee16cb91b8acdbf10a.1367943797.git.koradlow@gmail.com>
In-Reply-To: <1367943863-28803-1-git-send-email-koradlow@gmail.com>
References: <1367943863-28803-1-git-send-email-koradlow@gmail.com>
In-Reply-To: <43cedfcd3ab893d4efbf97587ee0fe6640ee3d39.1367943797.git.koradlow@gmail.com>
References: <43cedfcd3ab893d4efbf97587ee0fe6640ee3d39.1367943797.git.koradlow@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Konke Radlow <koradlow@gmail.com>
---
 utils/rds-ctl/rds-ctl.cpp |   28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/utils/rds-ctl/rds-ctl.cpp b/utils/rds-ctl/rds-ctl.cpp
index 51536cf..445c11f 100644
--- a/utils/rds-ctl/rds-ctl.cpp
+++ b/utils/rds-ctl/rds-ctl.cpp
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
@@ -636,8 +660,10 @@ static void print_rds_data(const struct v4l2_rds *handle, uint32_t updated_field
 		print_rds_af(&handle->rds_af);
 	if (params.options[OptPrintBlock])
 		printf("\n");
-	if (params.options[OptTMC])
+	if (params.options[OptTMC]) {
 		print_rds_tmc(handle, updated_fields);
+		print_rds_tmc_tuning(handle, updated_fields);
+	}
 }
 
 static void read_rds(struct v4l2_rds *handle, const int fd, const int wait_limit)
-- 
1.7.10.4

