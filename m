Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:56058 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753721AbaCYSUa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Mar 2014 14:20:30 -0400
Received: by mail-ee0-f44.google.com with SMTP id e49so768266eek.31
        for <linux-media@vger.kernel.org>; Tue, 25 Mar 2014 11:20:28 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 01/11] libdvbv5: support info info log via dvb_loginfo
Date: Tue, 25 Mar 2014 19:19:51 +0100
Message-Id: <1395771601-3509-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dvb_loginfo log support without setting output color.

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/dvb-log.h  |  3 +++
 lib/libdvbv5/dvb-log.c | 26 +++++++++++++-------------
 2 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/lib/include/dvb-log.h b/lib/include/dvb-log.h
index a72adce..755167a 100644
--- a/lib/include/dvb-log.h
+++ b/lib/include/dvb-log.h
@@ -38,6 +38,9 @@ typedef void (*dvb_logfunc)(int level, const char *fmt, ...) __attribute__ (( fo
 #define dvb_logwarn(fmt, arg...) do {\
 	parms->logfunc(LOG_WARNING, fmt, ##arg); \
 } while (0)
+#define dvb_loginfo(fmt, arg...) do {\
+	parms->logfunc(LOG_NOTICE, fmt, ##arg); \
+} while (0)
 
 
 #define dvb_perror(msg) do {\
diff --git a/lib/libdvbv5/dvb-log.c b/lib/libdvbv5/dvb-log.c
index 87d92f2..8bb34ca 100644
--- a/lib/libdvbv5/dvb-log.c
+++ b/lib/libdvbv5/dvb-log.c
@@ -30,15 +30,15 @@ static const struct loglevel {
 	const char *color;
 	int fd;
 } loglevels[9] = {
-	{"EMERG   ", "\033[31m", STDERR_FILENO },
-	{"ALERT   ", "\033[31m", STDERR_FILENO },
-	{"CRITICAL", "\033[31m", STDERR_FILENO },
-	{"ERROR   ", "\033[31m", STDERR_FILENO },
-	{"WARNING ", "\033[33m", STDOUT_FILENO },
-	{"NOTICE  ", "\033[36m", STDOUT_FILENO },
-	{"INFO    ", "\033[36m", STDOUT_FILENO },
-	{"DEBUG   ", "\033[32m", STDOUT_FILENO },
-	{"",         "\033[0m",  STDOUT_FILENO },
+	{"EMERG    ", "\033[31m", STDERR_FILENO },
+	{"ALERT    ", "\033[31m", STDERR_FILENO },
+	{"CRITICAL ", "\033[31m", STDERR_FILENO },
+	{"ERROR    ", "\033[31m", STDERR_FILENO },
+	{"WARNING  ", "\033[33m", STDOUT_FILENO },
+	{"",          "\033[36m", STDOUT_FILENO }, /* NOTICE */
+	{"",          NULL,       STDOUT_FILENO }, /* INFO */
+	{"DEBUG    ", "\033[32m", STDOUT_FILENO },
+	{"",          "\033[0m",  STDOUT_FILENO }, /* reset*/
 };
 #define LOG_COLOROFF 8
 
@@ -49,14 +49,14 @@ void dvb_default_log(int level, const char *fmt, ...)
 	va_list ap;
 	va_start(ap, fmt);
 	FILE *out = stdout;
-	if(STDERR_FILENO == loglevels[level].fd)
+	if (STDERR_FILENO == loglevels[level].fd)
 		out = stderr;
-	if(isatty(loglevels[level].fd))
+	if (loglevels[level].color && isatty(loglevels[level].fd))
 		fputs(loglevels[level].color, out);
-	fprintf(out, "%s ", loglevels[level].name);
+	fprintf(out, "%s", loglevels[level].name);
 	vfprintf(out, fmt, ap);
 	fprintf(out, "\n");
-	if(isatty(loglevels[level].fd))
+	if(loglevels[level].color && isatty(loglevels[level].fd))
 		fputs(loglevels[LOG_COLOROFF].color, out);
 	va_end(ap);
 }
-- 
1.8.3.2

