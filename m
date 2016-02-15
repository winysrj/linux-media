Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43592 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002AbcBOWOE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2016 17:14:04 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id DBFA4C0BBE7C
	for <linux-media@vger.kernel.org>; Mon, 15 Feb 2016 22:14:03 +0000 (UTC)
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH xawtv3] alevtd: Drop supplementary group IDs when dropping privileges
Date: Mon, 15 Feb 2016 23:13:58 +0100
Message-Id: <1455574438-27640-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Noticed by rpmlint, seek POS36-C on the web for details about the problem.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 vbistuff/alevtd.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/vbistuff/alevtd.c b/vbistuff/alevtd.c
index c6211d3..2df4886 100644
--- a/vbistuff/alevtd.c
+++ b/vbistuff/alevtd.c
@@ -168,8 +168,10 @@ fix_ug(void)
     }
 
     /* set group */
-    if (getegid() != gr->gr_gid || getgid() != gr->gr_gid)
+    if (getegid() != gr->gr_gid || getgid() != gr->gr_gid) {
+        setgroups(0, NULL);
 	setgid(gr->gr_gid);
+    }
     if (getegid() != gr->gr_gid || getgid() != gr->gr_gid) {
 	xerror(LOG_ERR,"setgid failed",NULL);
 	exit(1);
@@ -177,8 +179,10 @@ fix_ug(void)
     strncpy(group,gr->gr_name,16);
 
     /* set user */
-    if (geteuid() != pw->pw_uid || getuid() != pw->pw_uid)
+    if (geteuid() != pw->pw_uid || getuid() != pw->pw_uid) {
+        setgroups(0, NULL);
 	setuid(pw->pw_uid);
+    }
     if (geteuid() != pw->pw_uid || getuid() != pw->pw_uid) {
 	xerror(LOG_ERR,"setuid failed",NULL);
 	exit(1);
-- 
2.7.1

