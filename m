Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:38836 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932287AbdKOLdn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Nov 2017 06:33:43 -0500
Received: by mail-wm0-f66.google.com with SMTP id z3so2329602wme.3
        for <linux-media@vger.kernel.org>; Wed, 15 Nov 2017 03:33:43 -0800 (PST)
Received: from localhost.localdomain ([62.147.246.169])
        by smtp.gmail.com with ESMTPSA id m37sm24217424wrm.4.2017.11.15.03.33.40
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 Nov 2017 03:33:40 -0800 (PST)
From: =?UTF-8?q?Rafa=C3=ABl=20Carr=C3=A9?= <funman@videolan.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/2] dvb_logfunc: add a user private parameter
Date: Wed, 15 Nov 2017 12:33:35 +0100
Message-Id: <20171115113336.3756-1-funman@videolan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 lib/include/libdvbv5/dvb-dev.h |  3 ++-
 lib/include/libdvbv5/dvb-fe.h  |  9 +++++++--
 lib/include/libdvbv5/dvb-log.h | 33 +++++++++++++++++----------------
 lib/libdvbv5/dvb-dev.c         |  3 ++-
 lib/libdvbv5/dvb-fe.c          | 15 ++++++++-------
 lib/libdvbv5/dvb-log.c         |  3 ++-
 utils/dvb/dvb-fe-tool.c        |  2 +-
 utils/dvb/dvbv5-daemon.c       |  9 +++++----
 utils/dvb/dvbv5-scan.c         |  2 +-
 utils/dvb/dvbv5-zap.c          |  2 +-
 10 files changed, 46 insertions(+), 35 deletions(-)

diff --git a/lib/include/libdvbv5/dvb-dev.h b/lib/include/libdvbv5/dvb-dev.h
index 55e0f065..396fcd07 100644
--- a/lib/include/libdvbv5/dvb-dev.h
+++ b/lib/include/libdvbv5/dvb-dev.h
@@ -243,6 +243,7 @@ void dvb_dev_stop_monitor(struct dvb_device *dvb);
  * @param logfunc	Callback function to be called when a log event
  *			happens. Can either store the event into a file or
  *			to print it at the TUI/GUI. Can be null.
+ * @param logpriv   Private data for log function
  *
  * @details Sets the function to report log errors and to set the verbosity
  *	level of debug report messages. If not called, or if logfunc is
@@ -252,7 +253,7 @@ void dvb_dev_stop_monitor(struct dvb_device *dvb);
  */
 void dvb_dev_set_log(struct dvb_device *dvb,
 		     unsigned verbose,
-		     dvb_logfunc logfunc);
+		     dvb_logfunc logfunc, void *logpriv);
 
 /**
  * @brief Opens a dvb device
diff --git a/lib/include/libdvbv5/dvb-fe.h b/lib/include/libdvbv5/dvb-fe.h
index 1d3565ec..107cb03d 100644
--- a/lib/include/libdvbv5/dvb-fe.h
+++ b/lib/include/libdvbv5/dvb-fe.h
@@ -107,6 +107,7 @@
  * @param freq_bpf		SCR/Unicable band-pass filter frequency to use, in kHz
  * @param verbose		Verbosity level of the library (RW)
  * @param dvb_logfunc		Function used to write log messages (RO)
+ * @param logpriv			Private data for logging function (RO)
  * @param default_charset	Name of the charset used by the DVB standard (RW)
  * @param output_charset	Name of the charset to output (system specific) (RW)
  *
@@ -140,7 +141,8 @@ struct dvb_v5_fe_parms {
 
 	/* Function to write DVB logs */
 	unsigned			verbose;
-	dvb_logfunc                     logfunc;
+	dvb_logfunc			logfunc;
+	void				*logpriv;
 
 	/* Charsets to be used by the conversion utilities */
 	char				*default_charset;
@@ -176,6 +178,7 @@ struct dvb_v5_fe_parms *dvb_fe_dummy(void);
  *				happens. Can either store the event into a file
  *				or to print it at the TUI/GUI. If NULL, the
  *				library will use its internal handler.
+ * @param logpriv		Private data for dvb_logfunc
  * @param flags			Flags to be passed to open. Currently only two
  *				flags are supported: O_RDONLY or O_RDWR.
  *				Using O_NONBLOCK may hit unexpected issues.
@@ -195,6 +198,7 @@ struct dvb_v5_fe_parms *dvb_fe_open_flags(int adapter, int frontend,
 					  unsigned verbose,
 					  unsigned use_legacy_call,
 					  dvb_logfunc logfunc,
+					  void *logpriv,
 					  int flags);
 
 /**
@@ -231,6 +235,7 @@ struct dvb_v5_fe_parms *dvb_fe_open(int adapter, int frontend,
  * @param logfunc		Callback function to be called when a log event
  *				happens. Can either store the event into a file
  *				or to print it at the TUI/GUI.
+ * @param logpriv		Private data for dvb_logfunc
  *
  * @details This function should be called before using any other function at
  * the frontend library (or the other alternatives: dvb_fe_open() or
@@ -240,7 +245,7 @@ struct dvb_v5_fe_parms *dvb_fe_open(int adapter, int frontend,
  */
 struct dvb_v5_fe_parms *dvb_fe_open2(int adapter, int frontend,
 				    unsigned verbose, unsigned use_legacy_call,
-				    dvb_logfunc logfunc);
+				    dvb_logfunc logfunc, void *logpriv);
 
 /**
  * @brief Closes the frontend and frees allocated resources
diff --git a/lib/include/libdvbv5/dvb-log.h b/lib/include/libdvbv5/dvb-log.h
index 181a23c8..beba7aba 100644
--- a/lib/include/libdvbv5/dvb-log.h
+++ b/lib/include/libdvbv5/dvb-log.h
@@ -36,12 +36,12 @@
  */
 
 /**
- * @typedef void (*dvb_logfunc)(int level, const char *fmt, ...)
+ * @typedef void (*dvb_logfunc)(void *logpriv, int level, const char *fmt, ...)
  * @brief typedef used by dvb_fe_open2 for the log function
  * @ingroup ancillary
  */
 
-typedef void (*dvb_logfunc)(int level, const char *fmt, ...) __attribute__ (( format( printf, 2, 3 )));
+typedef void (*dvb_logfunc)(void *logpriv, int level, const char *fmt, ...) __attribute__ (( format( printf, 3, 4 )));
 
 /*
  * Macros used internally inside libdvbv5 frontend part, to output logs
@@ -52,48 +52,48 @@ typedef void (*dvb_logfunc)(int level, const char *fmt, ...) __attribute__ (( fo
 #ifndef __DVB_FE_PRIV_H
 
 #define dvb_log(fmt, arg...) do {\
-	parms->logfunc(LOG_INFO, fmt, ##arg); \
+	parms->logfunc(parms->logpriv, LOG_INFO, fmt, ##arg); \
 } while (0)
 #define dvb_logerr(fmt, arg...) do {\
-	parms->logfunc(LOG_ERR, fmt, ##arg); \
+	parms->logfunc(parms->logpriv, LOG_ERR, fmt, ##arg); \
 } while (0)
 #define dvb_logdbg(fmt, arg...) do {\
-	parms->logfunc(LOG_DEBUG, fmt, ##arg); \
+	parms->logfunc(parms->logpriv, LOG_DEBUG, fmt, ##arg); \
 } while (0)
 #define dvb_logwarn(fmt, arg...) do {\
-	parms->logfunc(LOG_WARNING, fmt, ##arg); \
+	parms->logfunc(parms->logpriv, LOG_WARNING, fmt, ##arg); \
 } while (0)
 #define dvb_loginfo(fmt, arg...) do {\
-	parms->logfunc(LOG_NOTICE, fmt, ##arg); \
+	parms->logfunc(parms->logpriv, LOG_NOTICE, fmt, ##arg); \
 } while (0)
 
 #define dvb_perror(msg) do {\
-	parms->logfunc(LOG_ERR, "%s: %s", msg, strerror(errno)); \
+	parms->logfunc(parms->logpriv, LOG_ERR, "%s: %s", msg, strerror(errno)); \
 } while (0)
 
 #else
 
 #define dvb_log(fmt, arg...) do {\
-	parms->p.logfunc(LOG_INFO, fmt, ##arg); \
+	parms->p.logfunc(parms->p.logpriv, LOG_INFO, fmt, ##arg); \
 } while (0)
 #define dvb_logerr(fmt, arg...) do {\
-	parms->p.logfunc(LOG_ERR, fmt, ##arg); \
+	parms->p.logfunc(parms->p.logpriv, LOG_ERR, fmt, ##arg); \
 } while (0)
 #define dvb_logdbg(fmt, arg...) do {\
-	parms->p.logfunc(LOG_DEBUG, fmt, ##arg); \
+	parms->p.logfunc(parms->p.logpriv, LOG_DEBUG, fmt, ##arg); \
 } while (0)
 #define dvb_logwarn(fmt, arg...) do {\
-	parms->p.logfunc(LOG_WARNING, fmt, ##arg); \
+	parms->p.logfunc(parms->p.logpriv, LOG_WARNING, fmt, ##arg); \
 } while (0)
 #define dvb_loginfo(fmt, arg...) do {\
-	parms->p.logfunc(LOG_NOTICE, fmt, ##arg); \
+	parms->p.logfunc(parms->p.logpriv, LOG_NOTICE, fmt, ##arg); \
 } while (0)
 #define dvb_loglevel(level, fmt, arg...) do {\
-	parms->p.logfunc(level, fmt, ##arg); \
+	parms->p.logfunc(parms->p.logpriv, level, fmt, ##arg); \
 } while (0)
 
 #define dvb_perror(msg) do {\
-	parms->p.logfunc(LOG_ERR, "%s: %s", msg, strerror(errno)); \
+	parms->p.logfunc(parms->p.logpriv, LOG_ERR, "%s: %s", msg, strerror(errno)); \
 } while (0)
 
 #endif
@@ -105,9 +105,10 @@ typedef void (*dvb_logfunc)(int level, const char *fmt, ...) __attribute__ (( fo
  *	  if the library client doesn't desire to override with something else.
  * @ingroup ancillary
  *
+ * @param logpriv 		private data, unused by the default function
  * @param level		level of the message, as defined at syslog.h
  * @param fmt		format string (same as format string on sprintf)
  */
-void dvb_default_log(int level, const char *fmt, ...) __attribute__ (( format( printf, 2, 3 )));
+void dvb_default_log(void *logpriv, int level, const char *fmt, ...) __attribute__ (( format( printf, 3, 4 )));
 
 #endif
diff --git a/lib/libdvbv5/dvb-dev.c b/lib/libdvbv5/dvb-dev.c
index 447c9fd5..d642c49c 100644
--- a/lib/libdvbv5/dvb-dev.c
+++ b/lib/libdvbv5/dvb-dev.c
@@ -163,12 +163,13 @@ struct dvb_dev_list *dvb_dev_seek_by_adapter(struct dvb_device *d,
 }
 
 void dvb_dev_set_log(struct dvb_device *dvb, unsigned verbose,
-		     dvb_logfunc logfunc)
+		     dvb_logfunc logfunc, void *logpriv)
 {
 	struct dvb_v5_fe_parms_priv *parms = (void *)dvb->fe_parms;
 
 	/* FIXME: how to get remote logs and set verbosity? */
 	parms->p.verbose = verbose;
+	parms->p.logpriv = logpriv;
 
 	if (logfunc != NULL)
 			parms->p.logfunc = logfunc;
diff --git a/lib/libdvbv5/dvb-fe.c b/lib/libdvbv5/dvb-fe.c
index 5cad6955..1088df7e 100644
--- a/lib/libdvbv5/dvb-fe.c
+++ b/lib/libdvbv5/dvb-fe.c
@@ -113,22 +113,22 @@ struct dvb_v5_fe_parms *dvb_fe_open(int adapter, int frontend,
 						  unsigned use_legacy_call)
 {
 	return dvb_fe_open_flags(adapter, frontend, verbose, use_legacy_call,
-				 NULL, O_RDWR);
+				 NULL, NULL, O_RDWR);
 
 }
 
 struct dvb_v5_fe_parms *dvb_fe_open2(int adapter, int frontend,
 				    unsigned verbose, unsigned use_legacy_call,
-				    dvb_logfunc logfunc)
+				    dvb_logfunc logfunc, void *logpriv)
 {
 	return dvb_fe_open_flags(adapter, frontend, verbose, use_legacy_call,
-				 logfunc, O_RDWR);
+				 logfunc, logpriv, O_RDWR);
 }
 
 struct dvb_v5_fe_parms *dvb_fe_open_flags(int adapter, int frontend,
 					  unsigned verbose,
 					  unsigned use_legacy_call,
-					  dvb_logfunc logfunc,
+					  dvb_logfunc logfunc, void *logpriv,
 					  int flags)
 {
 	int ret;
@@ -147,7 +147,7 @@ struct dvb_v5_fe_parms *dvb_fe_open_flags(int adapter, int frontend,
 	dvb_dev = dvb_dev_seek_by_adapter(dvb, adapter, frontend,
 				     DVB_DEVICE_FRONTEND);
 	if (!dvb_dev) {
-		logfunc(LOG_ERR, _("adapter %d, frontend %d not found"),
+		logfunc(logpriv, LOG_ERR, _("adapter %d, frontend %d not found"),
 			adapter, frontend);
 		dvb_dev_free(dvb);
 		return NULL;
@@ -155,12 +155,12 @@ struct dvb_v5_fe_parms *dvb_fe_open_flags(int adapter, int frontend,
 	fname = strdup(dvb_dev->path);
 	dvb_dev_free(dvb);
 	if (!fname) {
-		logfunc(LOG_ERR, _("fname calloc: %s"), strerror(errno));
+		logfunc(logpriv, LOG_ERR, _("fname calloc: %s"), strerror(errno));
 		return NULL;
 	}
 	parms = calloc(sizeof(*parms), 1);
 	if (!parms) {
-		logfunc(LOG_ERR, _("parms calloc: %s"), strerror(errno));
+		logfunc(logpriv, LOG_ERR, _("parms calloc: %s"), strerror(errno));
 		free(fname);
 		return NULL;
 	}
@@ -168,6 +168,7 @@ struct dvb_v5_fe_parms *dvb_fe_open_flags(int adapter, int frontend,
 	parms->p.default_charset = "iso-8859-1";
 	parms->p.output_charset = "utf-8";
 	parms->p.logfunc = logfunc;
+	parms->p.logpriv = logpriv;
 	parms->p.lna = LNA_AUTO;
 	parms->p.sat_number = -1;
 	parms->p.abort = 0;
diff --git a/lib/libdvbv5/dvb-log.c b/lib/libdvbv5/dvb-log.c
index f92da5f8..c5cf0b64 100644
--- a/lib/libdvbv5/dvb-log.c
+++ b/lib/libdvbv5/dvb-log.c
@@ -55,8 +55,9 @@ static const struct loglevel {
 };
 #define LOG_COLOROFF 8
 
-void dvb_default_log(int level, const char *fmt, ...)
+void dvb_default_log(void *logpriv, int level, const char *fmt, ...)
 {
+    (void)logpriv; /* unused by default function */
 	if(level > sizeof(loglevels) / sizeof(struct loglevel) - 2) // ignore LOG_COLOROFF as well
 		level = LOG_INFO;
 	va_list ap;
diff --git a/utils/dvb/dvb-fe-tool.c b/utils/dvb/dvb-fe-tool.c
index ef2fee16..1d5f19ad 100644
--- a/utils/dvb/dvb-fe-tool.c
+++ b/utils/dvb/dvb-fe-tool.c
@@ -349,7 +349,7 @@ int main(int argc, char *argv[])
 			return -1;
 	}
 
-	dvb_dev_set_log(dvb, verbose, NULL);
+	dvb_dev_set_log(dvb, verbose, NULL, NULL);
 	if (device_mon) {
 		dvb_dev_find(dvb, &dev_change_monitor, NULL);
 		while (1) {
diff --git a/utils/dvb/dvbv5-daemon.c b/utils/dvb/dvbv5-daemon.c
index 23b2e456..58485ac6 100644
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
+    int fd = *(int*)priv;
 
 	va_start(ap, fmt);
 	ret = vasprintf(&buf, fmt, ap);
@@ -569,8 +570,8 @@ void dvb_remote_log(int level, const char *fmt, ...)
 
 	va_end(ap);
 
-	if (dvb_fd > 0)
-		send_data(dvb_fd, "%i%s%i%s", 0, "log", level, buf);
+	if (fd > 0)
+		send_data(fd, "%i%s%i%s", 0, "log", level, buf);
 	else
 		local_log(level, buf);
 
@@ -1486,7 +1487,7 @@ int main(int argc, char *argv[])
 	}
 
 	/* FIXME: should allow the caller to set the verbosity */
-	dvb_dev_set_log(dvb, 1, dvb_remote_log);
+	dvb_dev_set_log(dvb, 1, dvb_remote_log, &dvb_fd);
 
 	/* Listen up to 5 connections */
 	listen(sockfd, 5);
diff --git a/utils/dvb/dvbv5-scan.c b/utils/dvb/dvbv5-scan.c
index a9b131e1..49b1b657 100644
--- a/utils/dvb/dvbv5-scan.c
+++ b/utils/dvb/dvbv5-scan.c
@@ -520,7 +520,7 @@ int main(int argc, char **argv)
 	dvb = dvb_dev_alloc();
 	if (!dvb)
 		return -1;
-	dvb_dev_set_log(dvb, verbose, NULL);
+	dvb_dev_set_log(dvb, verbose, NULL, NULL);
 	dvb_dev_find(dvb, NULL, NULL);
 	parms = dvb->fe_parms;
 
diff --git a/utils/dvb/dvbv5-zap.c b/utils/dvb/dvbv5-zap.c
index a88500d1..b2eb5aa4 100644
--- a/utils/dvb/dvbv5-zap.c
+++ b/utils/dvb/dvbv5-zap.c
@@ -884,7 +884,7 @@ int main(int argc, char **argv)
 			return -1;
 	}
 
-	dvb_dev_set_log(dvb, args.verbose, NULL);
+	dvb_dev_set_log(dvb, args.verbose, NULL, NULL);
 	dvb_dev_find(dvb, NULL, NULL);
 	parms = dvb->fe_parms;
 
-- 
2.14.1
