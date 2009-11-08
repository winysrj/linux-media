Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02d.mail.t-online.hu ([84.2.42.7]:52836 "EHLO
	mail02d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324AbZKHMcs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Nov 2009 07:32:48 -0500
Message-ID: <4AF6BA72.4070809@freemail.hu>
Date: Sun, 08 Nov 2009 13:32:50 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] v4l2-dbg: report fail reason to the user
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

Report the fail reason to the user when writing a register even if
the verbose mode is switched off.

Remove duplicated code ioctl() call which may cause different ioctl()
function call in case of verbose and non verbose if not handled carefully.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -r 19c0469c02c3 v4l2-apps/util/v4l2-dbg.cpp
--- a/v4l2-apps/util/v4l2-dbg.cpp	Sat Nov 07 15:51:01 2009 -0200
+++ b/v4l2-apps/util/v4l2-dbg.cpp	Sun Nov 08 14:13:52 2009 +0100
@@ -354,13 +354,14 @@
 {
 	int retVal;

-	if (!options[OptVerbose]) return ioctl(fd, request, parm);
 	retVal = ioctl(fd, request, parm);
-	printf("%s: ", name);
-	if (retVal < 0)
-		printf("failed: %s\n", strerror(errno));
-	else
-		printf("ok\n");
+	if (options[OptVerbose]) {
+		printf("%s: ", name);
+		if (retVal < 0)
+			printf("failed: %s\n", strerror(errno));
+		else
+			printf("ok\n");
+	}

 	return retVal;
 }
@@ -586,8 +587,9 @@

 				printf(" set to 0x%llx\n", set_reg.val);
 			} else {
-				printf("Failed to set register 0x%08llx value 0x%llx\n",
-					set_reg.reg, set_reg.val);
+				printf("Failed to set register 0x%08llx value 0x%llx: "
+					"%s\n",
+					set_reg.reg, set_reg.val, strerror(errno));
 			}
 			set_reg.reg++;
 		}
