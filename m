Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:53852 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbZKLHXk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Nov 2009 02:23:40 -0500
Message-ID: <4AFBB7FD.5090607@freemail.hu>
Date: Thu, 12 Nov 2009 08:23:41 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Hans de Goede <hdegoede@redhat.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] v4l2-dbg: report fail reason to the user
References: <4AF6BA72.4070809@freemail.hu> <200911091116.06578.hverkuil@xs4all.nl> <4AF8F8EB.8090705@freemail.hu>
In-Reply-To: <4AF8F8EB.8090705@freemail.hu>
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
diff -r 60f784aa071d v4l2-apps/util/v4l2-dbg.cpp
--- a/v4l2-apps/util/v4l2-dbg.cpp	Wed Nov 11 18:28:53 2009 +0100
+++ b/v4l2-apps/util/v4l2-dbg.cpp	Thu Nov 12 08:21:20 2009 +0100
@@ -353,14 +353,21 @@
 static int doioctl(int fd, int request, void *parm, const char *name)
 {
 	int retVal;
+	int ioctl_errno;

 	if (!options[OptVerbose]) return ioctl(fd, request, parm);
 	retVal = ioctl(fd, request, parm);
-	printf("%s: ", name);
-	if (retVal < 0)
-		printf("failed: %s\n", strerror(errno));
-	else
-		printf("ok\n");
+	if (options[OptVerbose]) {
+		/* Save errno because printf() may modify it */
+		ioctl_errno = errno;
+		printf("%s: ", name);
+		if (retVal < 0)
+			printf("failed: %s\n", strerror(errno));
+		else
+			printf("ok\n");
+		/* Restore errno for caller's use */
+		errno = ioctl_errno;
+	}

 	return retVal;
 }
@@ -586,8 +593,8 @@

 				printf(" set to 0x%llx\n", set_reg.val);
 			} else {
-				printf("Failed to set register 0x%08llx value 0x%llx\n",
-					set_reg.reg, set_reg.val);
+				printf("Failed to set register 0x%08llx value 0x%llx: %s\n",
+					set_reg.reg, set_reg.val, strerror(errno));
 			}
 			set_reg.reg++;
 		}
