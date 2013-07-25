Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f47.google.com ([209.85.214.47]:48547 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678Ab3GYNKj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jul 2013 09:10:39 -0400
Received: by mail-bk0-f47.google.com with SMTP id jg1so668240bkc.6
        for <linux-media@vger.kernel.org>; Thu, 25 Jul 2013 06:10:37 -0700 (PDT)
From: Gregor Jasny <gjasny@googlemail.com>
To: linux-media@vger.kernel.org
Cc: Gregor Jasny <gjasny@googlemail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 3/4] rds-ctl: Always terminate strings properly
Date: Thu, 25 Jul 2013 15:09:33 +0200
Message-Id: <1374757774-29051-4-git-send-email-gjasny@googlemail.com>
In-Reply-To: <1374757774-29051-1-git-send-email-gjasny@googlemail.com>
References: <1374757774-29051-1-git-send-email-gjasny@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Detected by Coverity.

Signed-off-by: Gregor Jasny <gjasny@googlemail.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>
---
 utils/rds-ctl/rds-ctl.cpp | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/utils/rds-ctl/rds-ctl.cpp b/utils/rds-ctl/rds-ctl.cpp
index a9fe2a8..74972eb 100644
--- a/utils/rds-ctl/rds-ctl.cpp
+++ b/utils/rds-ctl/rds-ctl.cpp
@@ -762,13 +762,11 @@ static int parse_cl(int argc, char **argv)
 		params.options[(int)opt] = 1;
 		switch (opt) {
 		case OptSetDevice:
-			strncpy(params.fd_name, optarg, 80);
+			strncpy(params.fd_name, optarg, sizeof(params.fd_name));
 			if (optarg[0] >= '0' && optarg[0] <= '9' && strlen(optarg) <= 3) {
-				static char newdev[20];
-
-				sprintf(newdev, "/dev/radio%s", optarg);
-				strncpy(params.fd_name, newdev, 20);
+				snprintf(params.fd_name, sizeof(params.fd_name), "/dev/radio%s", optarg);
 			}
+			params.fd_name[sizeof(params.fd_name) - 1] = '\0';
 			break;
 		case OptSetFreq:
 			params.freq = strtod(optarg, NULL);
@@ -786,7 +784,8 @@ static int parse_cl(int argc, char **argv)
 		{
 			if (access(optarg, F_OK) != -1) {
 				params.filemode_active = true;
-				strncpy(params.fd_name, optarg, 80);
+				strncpy(params.fd_name, optarg, sizeof(params.fd_name));
+				params.fd_name[sizeof(params.fd_name) - 1] = '\0';
 			} else {
 				fprintf(stderr, "Unable to open file: %s\n", optarg);
 				return -1;
@@ -1006,7 +1005,8 @@ int main(int argc, char **argv)
 			fprintf(stderr, "No RDS-capable device found\n");
 			exit(1);
 		}
-		strncpy(params.fd_name, devices[0].c_str(), 80);
+		strncpy(params.fd_name, devices[0].c_str(), sizeof(params.fd_name));
+		params.fd_name[sizeof(params.fd_name) - 1] = '\0';
 		printf("Using device: %s\n", params.fd_name);
 	}
 	if ((fd = test_open(params.fd_name, O_RDONLY | O_NONBLOCK)) < 0) {
-- 
1.8.3.2

