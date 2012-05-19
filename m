Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63799 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758008Ab2ESXjp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 May 2012 19:39:45 -0400
Received: by wgbdr13 with SMTP id dr13so3827457wgb.1
        for <linux-media@vger.kernel.org>; Sat, 19 May 2012 16:39:44 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 3/3] log levels
Date: Sun, 20 May 2012 01:38:54 +0200
Message-Id: <1337470734-14935-3-git-send-email-neolynx@gmail.com>
In-Reply-To: <1337470734-14935-1-git-send-email-neolynx@gmail.com>
References: <1337470734-14935-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/dvb-fe.h  |   13 ++++-----
 lib/libdvbv5/dvb-fe.c |   62 ++++++++++++++++++++++++++++++-------------------
 2 files changed, 44 insertions(+), 31 deletions(-)

diff --git a/lib/include/dvb-fe.h b/lib/include/dvb-fe.h
index 0133ff3..df448c3 100644
--- a/lib/include/dvb-fe.h
+++ b/lib/include/dvb-fe.h
@@ -29,17 +29,18 @@
 #include <fcntl.h>
 #include <sys/ioctl.h>
 #include <string.h>
+#include <syslog.h>
 #include "dvb-frontend.h"
 #include "dvb-sat.h"
 
 #define dvb_log(fmt, arg...) do {\
-  parms->logfunc(fmt, ##arg); \
+  parms->logfunc(LOG_INFO, fmt, ##arg); \
    } while (0)
 #define dvb_logerr(fmt, arg...) do {\
-  parms->logerrfunc(fmt, ##arg); \
+  parms->logfunc(LOG_ERR, fmt, ##arg); \
   } while (0)
 #define dvb_perror(msg) do {\
-  parms->logerrfunc("%s: %s", msg, strerror(errno)); \
+  parms->logfunc(LOG_ERR, "%s: %s", msg, strerror(errno)); \
   } while (0)
 
 #define ARRAY_SIZE(x)	(sizeof(x)/sizeof((x)[0]))
@@ -71,7 +72,7 @@ struct dvb_v5_stats {
 	struct dtv_property		prop[DTV_MAX_STATS];
 };
 
-typedef void (*dvb_logfunc)(const char *fmt, ...);
+typedef void (*dvb_logfunc)(int level, const char *fmt, ...);
 
 struct dvb_v5_fe_parms {
 	int				fd;
@@ -99,7 +100,6 @@ struct dvb_v5_fe_parms {
 	unsigned			freq_offset;
 
         dvb_logfunc                     logfunc;
-        dvb_logfunc                     logerrfunc;
 };
 
 
@@ -113,8 +113,7 @@ struct dvb_v5_fe_parms *dvb_fe_open(int adapter, int frontend,
 				    unsigned verbose, unsigned use_legacy_call);
 struct dvb_v5_fe_parms *dvb_fe_open2(int adapter, int frontend,
 				    unsigned verbose, unsigned use_legacy_call,
-                                    dvb_logfunc logfunc,
-                                    dvb_logfunc logerrfunc);
+                                    dvb_logfunc logfunc);
 void dvb_fe_close(struct dvb_v5_fe_parms *parms);
 
 /* Get/set delivery system parameters */
diff --git a/lib/libdvbv5/dvb-fe.c b/lib/libdvbv5/dvb-fe.c
index 100f262..f670595 100644
--- a/lib/libdvbv5/dvb-fe.c
+++ b/lib/libdvbv5/dvb-fe.c
@@ -26,24 +26,40 @@
 #include <unistd.h>
 #include <stdarg.h>
 
-void dvb_default_log(const char *fmt, ...)
-{
-  va_list ap;
-  va_start( ap, fmt );
-  printf( "libdvbv5: " );
-  vprintf( fmt, ap );
-  printf( "\n" );
-  va_end( ap );
-}
+static const struct loglevel {
+	const char *name;
+	const char *color;
+	int fd;
+} loglevels[9] = {
+	{"EMERG   ", "\033[31m", STDERR_FILENO },
+	{"ALERT   ", "\033[31m", STDERR_FILENO },
+	{"CRITICAL", "\033[31m", STDERR_FILENO },
+	{"ERROR   ", "\033[31m", STDERR_FILENO },
+	{"WARNING ", "\033[33m", STDOUT_FILENO },
+	{"NOTICE  ", "\033[36m", STDOUT_FILENO },
+	{"INFO    ", "\033[36m", STDOUT_FILENO },
+	{"DEBUG   ", "\033[32m", STDOUT_FILENO },
+	{"",         "\033[0m",  STDOUT_FILENO },
+};
+#define LOG_COLOROFF 8
 
-void dvb_default_logerr(const char *fmt, ...)
+void dvb_default_log(int level, const char *fmt, ...)
 {
-  va_list ap;
-  va_start( ap, fmt );
-  fprintf (stderr, "libdvbv5: ");
-  vfprintf( stderr, fmt, ap );
-  fprintf (stderr, "\n");
-  va_end( ap );
+	if(level > sizeof(loglevels) / sizeof(struct loglevel) - 2) // ignore LOG_COLOROFF as well
+		level = LOG_INFO;
+	va_list ap;
+	va_start(ap, fmt);
+	FILE *out = stdout;
+	if(STDERR_FILENO == loglevels[level].fd)
+		out = stderr;
+	if(isatty(loglevels[level].fd))
+		fprintf(out, loglevels[level].color);
+	fprintf(out, "%s ", loglevels[level].name);
+	vfprintf(out, fmt, ap);
+	fprintf(out, "\n");
+	if(isatty(loglevels[level].fd))
+		fprintf(out, loglevels[LOG_COLOROFF].color);
+	va_end(ap);
 }
 
 static void dvb_v5_free(struct dvb_v5_fe_parms *parms)
@@ -58,12 +74,11 @@ struct dvb_v5_fe_parms *dvb_fe_open(int adapter, int frontend, unsigned verbose,
 				    unsigned use_legacy_call)
 {
   return dvb_fe_open2(adapter, frontend, verbose, use_legacy_call,
-                      dvb_default_log, dvb_default_logerr);
+                      dvb_default_log);
 }
 
 struct dvb_v5_fe_parms *dvb_fe_open2(int adapter, int frontend, unsigned verbose,
-				    unsigned use_legacy_call, dvb_logfunc logfunc,
-                                    dvb_logfunc logerrfunc)
+				    unsigned use_legacy_call, dvb_logfunc logfunc)
 {
 	int fd, i;
 	char *fname;
@@ -72,18 +87,18 @@ struct dvb_v5_fe_parms *dvb_fe_open2(int adapter, int frontend, unsigned verbose
 
 	asprintf(&fname, "/dev/dvb/adapter%i/frontend%i", adapter, frontend);
 	if (!fname) {
-		logerrfunc("fname calloc: %s", strerror(errno));
+		logfunc(LOG_ERR, "fname calloc: %s", strerror(errno));
 		return NULL;
 	}
 
 	fd = open(fname, O_RDWR, 0);
 	if (fd == -1) {
-		logerrfunc("%s while opening %s", strerror(errno), fname);
+		logfunc(LOG_ERR, "%s while opening %s", strerror(errno), fname);
 		return NULL;
 	}
 	parms = calloc(sizeof(*parms), 1);
 	if (!parms) {
-		logerrfunc("parms calloc: %s", strerror(errno));
+		logfunc(LOG_ERR, "parms calloc: %s", strerror(errno));
 		close(fd);
 		return NULL;
 	}
@@ -92,7 +107,6 @@ struct dvb_v5_fe_parms *dvb_fe_open2(int adapter, int frontend, unsigned verbose
 	parms->fd = fd;
 	parms->sat_number = -1;
         parms->logfunc = logfunc;
-        parms->logerrfunc = logerrfunc;
 
 	if (ioctl(fd, FE_GET_INFO, &parms->info) == -1) {
 		dvb_perror("FE_GET_INFO");
-- 
1.7.2.5

