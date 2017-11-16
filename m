Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:45393 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757965AbdKPQgx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Nov 2017 11:36:53 -0500
Received: by mail-wm0-f65.google.com with SMTP id 9so1427791wme.4
        for <linux-media@vger.kernel.org>; Thu, 16 Nov 2017 08:36:52 -0800 (PST)
From: =?UTF-8?q?Rafa=C3=ABl=20Carr=C3=A9?= <funman@videolan.org>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Rafa=C3=ABl=20Carr=C3=A9?= <funman@videolan.org>
Subject: [PATCH v2] dvb_logfunc: add a user private parameter
Date: Thu, 16 Nov 2017 17:36:42 +0100
Message-Id: <20171116163642.15716-1-funman@videolan.org>
In-Reply-To: <20171115113336.3756-1-funman@videolan.org>
References: <20171115113336.3756-1-funman@videolan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is useful if an application is using 2 different devices,
and want logging to be split by device, or if application logging
needs some private context.

Care has been taken to not break the API/ABI and only add new functions,
or only modify private structures.

A drawback is that when dvb_fe_open_flags() is called, the custom function
can not be set yet, so dvb_fe_open_flags() will log errors using the old
function without private context.

Signed-off-by: Rafaël Carré <funman@videolan.org>
---
 lib/include/libdvbv5/dvb-dev.h | 21 ++++++++++++
 lib/include/libdvbv5/dvb-log.h | 73 ++++++++++++++++++++----------------------
 lib/libdvbv5/dvb-dev.c         | 13 ++++++++
 lib/libdvbv5/dvb-fe-priv.h     |  3 ++
 lib/libdvbv5/dvb-fe.c          |  8 +++++
 utils/dvb/dvbv5-daemon.c       |  9 +++---
 6 files changed, 85 insertions(+), 42 deletions(-)

diff --git a/lib/include/libdvbv5/dvb-dev.h b/lib/include/libdvbv5/dvb-dev.h
index 55e0f065..6dbd2ae7 100644
--- a/lib/include/libdvbv5/dvb-dev.h
+++ b/lib/include/libdvbv5/dvb-dev.h
@@ -234,6 +234,27 @@ struct dvb_dev_list *dvb_get_dev_info(struct dvb_device *dvb,
  */
 void dvb_dev_stop_monitor(struct dvb_device *dvb);
 
+/**
+ * @brief Sets the DVB verbosity and log function with context private data
+ * @ingroup dvb_device
+ *
+ * @param dvb		pointer to struct dvb_device to be used
+ * @param verbose	Verbosity level of the messages that will be printed
+ * @param logfunc	Callback function to be called when a log event
+ *			happens. Can either store the event into a file or
+ *			to print it at the TUI/GUI. Can be null.
+ * @param logpriv   Private data for log function
+ *
+ * @details Sets the function to report log errors and to set the verbosity
+ *	level of debug report messages. If not called, or if logfunc is
+ *	NULL, the libdvbv5 will report error and debug messages via stderr,
+ *	and will use colors for the debug messages.
+ *
+ */
+void dvb_dev_set_logpriv(struct dvb_device *dvb,
+		     unsigned verbose,
+		     dvb_logfunc_priv logfunc, void *logpriv);
+
 /**
  * @brief Sets the DVB verbosity and log function
  * @ingroup dvb_device
diff --git a/lib/include/libdvbv5/dvb-log.h b/lib/include/libdvbv5/dvb-log.h
index 181a23c8..23cceede 100644
--- a/lib/include/libdvbv5/dvb-log.h
+++ b/lib/include/libdvbv5/dvb-log.h
@@ -43,61 +43,58 @@
 
 typedef void (*dvb_logfunc)(int level, const char *fmt, ...) __attribute__ (( format( printf, 2, 3 )));
 
+/**
+ * @typedef void (*dvb_logfunc)(void *logpriv, int level, const char *fmt, ...)
+ * @brief typedef used by dvb_fe_open2 for the log function with private context
+ * @ingroup ancillary
+ */
+
+typedef void (*dvb_logfunc_priv)(void *logpriv, int level, const char *fmt, ...);
+
 /*
  * Macros used internally inside libdvbv5 frontend part, to output logs
  */
 
 #ifndef _DOXYGEN
 
-#ifndef __DVB_FE_PRIV_H
+struct dvb_v5_fe_parms;
+/**
+ * @brief retrieve the logging function with private data from the private fe params.
+ */
+dvb_logfunc_priv dvb_get_log_priv(struct dvb_v5_fe_parms *, void **);
 
-#define dvb_log(fmt, arg...) do {\
-	parms->logfunc(LOG_INFO, fmt, ##arg); \
-} while (0)
-#define dvb_logerr(fmt, arg...) do {\
-	parms->logfunc(LOG_ERR, fmt, ##arg); \
-} while (0)
-#define dvb_logdbg(fmt, arg...) do {\
-	parms->logfunc(LOG_DEBUG, fmt, ##arg); \
-} while (0)
-#define dvb_logwarn(fmt, arg...) do {\
-	parms->logfunc(LOG_WARNING, fmt, ##arg); \
-} while (0)
-#define dvb_loginfo(fmt, arg...) do {\
-	parms->logfunc(LOG_NOTICE, fmt, ##arg); \
-} while (0)
+#ifndef __DVB_FE_PRIV_H
 
-#define dvb_perror(msg) do {\
-	parms->logfunc(LOG_ERR, "%s: %s", msg, strerror(errno)); \
+#define dvb_loglevel(level, fmt, arg...) do {\
+    void *priv;\
+    dvb_logfunc_priv f = dvb_get_log_priv(parms, &priv);\
+    if (f) {\
+        f(priv, level, fmt, ##arg);\
+    } else {\
+        parms->logfunc(level, fmt, ##arg); \
+    }\
 } while (0)
 
 #else
 
-#define dvb_log(fmt, arg...) do {\
-	parms->p.logfunc(LOG_INFO, fmt, ##arg); \
-} while (0)
-#define dvb_logerr(fmt, arg...) do {\
-	parms->p.logfunc(LOG_ERR, fmt, ##arg); \
-} while (0)
-#define dvb_logdbg(fmt, arg...) do {\
-	parms->p.logfunc(LOG_DEBUG, fmt, ##arg); \
-} while (0)
-#define dvb_logwarn(fmt, arg...) do {\
-	parms->p.logfunc(LOG_WARNING, fmt, ##arg); \
-} while (0)
-#define dvb_loginfo(fmt, arg...) do {\
-	parms->p.logfunc(LOG_NOTICE, fmt, ##arg); \
-} while (0)
 #define dvb_loglevel(level, fmt, arg...) do {\
-	parms->p.logfunc(level, fmt, ##arg); \
-} while (0)
-
-#define dvb_perror(msg) do {\
-	parms->p.logfunc(LOG_ERR, "%s: %s", msg, strerror(errno)); \
+    if (parms->logfunc_priv) {\
+        parms->logfunc_priv(parms->logpriv, level, fmt, ##arg);\
+    } else {\
+        parms->p.logfunc(level, fmt, ##arg); \
+    }\
 } while (0)
 
 #endif
 
+#define dvb_log(fmt, arg...) dvb_loglevel(LOG_INFO, fmt, ##arg)
+#define dvb_logerr(fmt, arg...) dvb_loglevel(LOG_ERR, fmt, ##arg)
+#define dvb_logdbg(fmt, arg...) dvb_loglevel(LOG_DEBUG, fmt, ##arg)
+#define dvb_logwarn(fmt, arg...) dvb_loglevel(LOG_WARNING, fmt, ##arg)
+#define dvb_loginfo(fmt, arg...) dvb_loglevel(LOG_NOTICE, fmt, ##arg)
+
+#define dvb_perror(msg) dvb_logerr("%s: %s", msg, strerror(errno))
+
 #endif /* _DOXYGEN */
 
 /**
diff --git a/lib/libdvbv5/dvb-dev.c b/lib/libdvbv5/dvb-dev.c
index e6a8fc76..9a0952b4 100644
--- a/lib/libdvbv5/dvb-dev.c
+++ b/lib/libdvbv5/dvb-dev.c
@@ -162,6 +162,19 @@ struct dvb_dev_list *dvb_dev_seek_by_adapter(struct dvb_device *d,
 	return ops->seek_by_adapter(dvb, adapter, num, type);
 }
 
+void dvb_dev_set_logpriv(struct dvb_device *dvb, unsigned verbose,
+		     dvb_logfunc_priv logfunc_priv, void *logpriv)
+{
+	struct dvb_v5_fe_parms_priv *parms = (void *)dvb->fe_parms;
+
+	/* FIXME: how to get remote logs and set verbosity? */
+	parms->p.verbose = verbose;
+	parms->logpriv = logpriv;
+
+	if (logfunc_priv != NULL)
+			parms->logfunc_priv = logfunc_priv;
+}
+
 void dvb_dev_set_log(struct dvb_device *dvb, unsigned verbose,
 		     dvb_logfunc logfunc)
 {
diff --git a/lib/libdvbv5/dvb-fe-priv.h b/lib/libdvbv5/dvb-fe-priv.h
index 5bf2b22b..239c48f8 100644
--- a/lib/libdvbv5/dvb-fe-priv.h
+++ b/lib/libdvbv5/dvb-fe-priv.h
@@ -75,6 +75,9 @@ struct dvb_v5_fe_parms_priv {
 	/* Satellite specific stuff */
 	int				high_band;
 	unsigned			freq_offset;
+
+	dvb_logfunc_priv		logfunc_priv;
+	void				*logpriv;
 };
 
 /* Functions used internally by dvb-dev.c. Aren't part of the API */
diff --git a/lib/libdvbv5/dvb-fe.c b/lib/libdvbv5/dvb-fe.c
index 39923fe4..5327df29 100644
--- a/lib/libdvbv5/dvb-fe.c
+++ b/lib/libdvbv5/dvb-fe.c
@@ -28,6 +28,7 @@
 #include <stddef.h>
 #include <time.h>
 #include <unistd.h>
+#include <stdarg.h>
 
 #include <config.h>
 
@@ -1899,3 +1900,10 @@ int dvb_fe_set_default_country(struct dvb_v5_fe_parms *p, const char *cc)
 	parms->country = dvb_country_a2_to_id(cc);
 	return (parms->country == COUNTRY_UNKNOWN) ? -EINVAL : 0;
 }
+
+dvb_logfunc_priv dvb_get_log_priv(struct dvb_v5_fe_parms *p, void **priv)
+{
+	struct dvb_v5_fe_parms_priv *parms = (void *)p;
+	*priv = parms->logpriv;
+	return parms->logfunc_priv;
+}
diff --git a/utils/dvb/dvbv5-daemon.c b/utils/dvb/dvbv5-daemon.c
index f0098c2b..c26886dd 100644
--- a/utils/dvb/dvbv5-daemon.c
+++ b/utils/dvb/dvbv5-daemon.c
@@ -553,12 +553,13 @@ static ssize_t scan_data(char *buf, int buf_size, const char *fmt, ...)
 /*
  * Remote log
  */
-void dvb_remote_log(int level, const char *fmt, ...)
+void dvb_remote_log(void *priv, int level, const char *fmt, ...)
 {
 	int ret;
 	char *buf;
 
 	va_list ap;
+	int fd = *(int*)priv;
 
 	va_start(ap, fmt);
 	ret = vasprintf(&buf, fmt, ap);
@@ -569,8 +570,8 @@ void dvb_remote_log(int level, const char *fmt, ...)
 
 	va_end(ap);
 
-	if (dvb_fd >= 0)
-		send_data(dvb_fd, "%i%s%i%s", 0, "log", level, buf);
+	if (fd >= 0)
+		send_data(fd, "%i%s%i%s", 0, "log", level, buf);
 	else
 		local_log(level, buf);
 
@@ -1486,7 +1487,7 @@ int main(int argc, char *argv[])
 	}
 
 	/* FIXME: should allow the caller to set the verbosity */
-	dvb_dev_set_log(dvb, 1, dvb_remote_log);
+	dvb_dev_set_logpriv(dvb, 1, dvb_remote_log, &dvb_fd);
 
 	/* Listen up to 5 connections */
 	listen(sockfd, 5);
-- 
2.14.1
