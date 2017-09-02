Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:37605 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752469AbdIBLnV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 2 Sep 2017 07:43:21 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/2] keytable: if the protocols cannot be changed, don't try
Date: Sat,  2 Sep 2017 12:43:19 +0100
Message-Id: <20170902114319.9879-2-sean@mess.org>
In-Reply-To: <20170902114319.9879-1-sean@mess.org>
References: <20170902114319.9879-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Note that if an invalid protocol was selected, we already get the error
"Invalid protocols selected".

Signed-off-by: Sean Young <sean@mess.org>
---
 utils/keytable/keytable.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/utils/keytable/keytable.c b/utils/keytable/keytable.c
index 7b0d1acb..1fd545b0 100644
--- a/utils/keytable/keytable.c
+++ b/utils/keytable/keytable.c
@@ -23,6 +23,7 @@
 #include <linux/input.h>
 #include <sys/ioctl.h>
 #include <sys/types.h>
+#include <sys/stat.h>
 #include <dirent.h>
 #include <argp.h>
 #include <stdbool.h>
@@ -991,10 +992,14 @@ static int v2_set_protocols(struct rc_device *rc_dev)
 {
 	FILE *fp;
 	char name[4096];
+	struct stat st;
 
 	strcpy(name, rc_dev->sysfs_name);
 	strcat(name, "/protocols");
 
+	if (!stat(name, &st) && !(st.st_mode & 0222))
+		return 0;
+
 	fp = fopen(name, "w");
 	if (!fp) {
 		perror(name);
-- 
2.13.5
