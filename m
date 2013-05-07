Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:55801 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908Ab3EGQYl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 May 2013 12:24:41 -0400
Received: by mail-wi0-f171.google.com with SMTP id l13so3980427wie.10
        for <linux-media@vger.kernel.org>; Tue, 07 May 2013 09:24:40 -0700 (PDT)
From: Konke Radlow <koradlow@gmail.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, hdegoede@redhat.com
Subject: [RFC PATCH 2/4] rds-ctl.cpp: added functionality to print RDS-EON information
Date: Tue,  7 May 2013 17:24:21 +0100
Message-Id: <63291557e0c1b342aea66fc33ef900cf22051db3.1367943797.git.koradlow@gmail.com>
In-Reply-To: <1367943863-28803-1-git-send-email-koradlow@gmail.com>
References: <1367943863-28803-1-git-send-email-koradlow@gmail.com>
In-Reply-To: <43cedfcd3ab893d4efbf97587ee0fe6640ee3d39.1367943797.git.koradlow@gmail.com>
References: <43cedfcd3ab893d4efbf97587ee0fe6640ee3d39.1367943797.git.koradlow@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Konke Radlow <koradlow@gmail.com>
---
 utils/rds-ctl/rds-ctl.cpp |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/utils/rds-ctl/rds-ctl.cpp b/utils/rds-ctl/rds-ctl.cpp
index de76d9f..51536cf 100644
--- a/utils/rds-ctl/rds-ctl.cpp
+++ b/utils/rds-ctl/rds-ctl.cpp
@@ -550,6 +550,33 @@ static void print_rds_af(const struct v4l2_rds_af_set *af_set)
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
+			printf("\nTP(ON %02i): %s" ,i ,eon_set->eon[i].tp? "yes":"no");
+		if (eon_set->eon[i].valid_fields & V4L2_RDS_TA)
+			printf("\nTA(ON %02i): %s",i ,eon_set->eon[i].tp? "yes":"no");
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
@@ -662,6 +689,8 @@ static void read_rds_from_fd(const int fd)
 
 	/* try to receive and decode RDS data */
 	read_rds(rds_handle, fd, params.wait_limit);
+	if (rds_handle->valid_fields & V4L2_RDS_EON)
+		print_rds_eon(&rds_handle->rds_eon);
 	print_rds_statistics(&rds_handle->rds_statistics);
 
 	v4l2_rds_destroy(rds_handle);
-- 
1.7.10.4

