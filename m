Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:55647 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756165Ab2ESKTv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 May 2012 06:19:51 -0400
Received: by wibhj8 with SMTP id hj8so885809wib.1
        for <linux-media@vger.kernel.org>; Sat, 19 May 2012 03:19:50 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 4/5] log functions for dvb-fe and libsat
Date: Sat, 19 May 2012 12:18:51 +0200
Message-Id: <1337422732-2001-4-git-send-email-neolynx@gmail.com>
In-Reply-To: <1337422732-2001-1-git-send-email-neolynx@gmail.com>
References: <1337422732-2001-1-git-send-email-neolynx@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 lib/include/dvb-fe.h  |   19 +++++++++
 lib/libdvbv5/dvb-fe.c |   99 +++++++++++++++++++++++++++++++------------------
 lib/libdvbv5/libsat.c |    4 +-
 3 files changed, 84 insertions(+), 38 deletions(-)

diff --git a/lib/include/dvb-fe.h b/lib/include/dvb-fe.h
index b4c5279..3fdae4f 100644
--- a/lib/include/dvb-fe.h
+++ b/lib/include/dvb-fe.h
@@ -32,6 +32,16 @@
 #include "dvb-frontend.h"
 #include "libsat.h"
 
+#define dvb_log(fmt, arg...) do {\
+  parms->logfunc(fmt, ##arg); \
+   } while (0)
+#define dvb_logerr(fmt, arg...) do {\
+  parms->logerrfunc(fmt, ##arg); \
+  } while (0)
+#define dvb_perror(msg) do {\
+  parms->logerrfunc("%s: %s", msg, strerror(errno)); \
+  } while (0)
+
 #define ARRAY_SIZE(x)	(sizeof(x)/sizeof((x)[0]))
 
 #define MAX_DELIVERY_SYSTEMS	20
@@ -61,6 +71,8 @@ struct dvb_v5_stats {
 	struct dtv_property		prop[DTV_MAX_STATS];
 };
 
+typedef void (*dvb_logfunc)(const char *fmt, ...);
+
 struct dvb_v5_fe_parms {
 	int				fd;
 	char				*fname;
@@ -85,6 +97,9 @@ struct dvb_v5_fe_parms {
 	int				high_band;
 	unsigned			diseqc_wait;
 	unsigned			freq_offset;
+
+        dvb_logfunc                     logfunc;
+        dvb_logfunc                     logerrfunc;
 };
 
 
@@ -96,6 +111,10 @@ extern "C" {
 
 struct dvb_v5_fe_parms *dvb_fe_open(int adapter, int frontend,
 				    unsigned verbose, unsigned use_legacy_call);
+struct dvb_v5_fe_parms *dvb_fe_open2(int adapter, int frontend,
+				    unsigned verbose, unsigned use_legacy_call,
+                                    dvb_logfunc logfunc,
+                                    dvb_logfunc logerrfunc);
 void dvb_fe_close(struct dvb_v5_fe_parms *parms);
 
 /* Get/set delivery system parameters */
diff --git a/lib/libdvbv5/dvb-fe.c b/lib/libdvbv5/dvb-fe.c
index 8f27e1a..655814a 100644
--- a/lib/libdvbv5/dvb-fe.c
+++ b/lib/libdvbv5/dvb-fe.c
@@ -24,7 +24,27 @@
 #include <stddef.h>
 #include <stdio.h>
 #include <unistd.h>
+#include <stdarg.h>
 
+void dvb_default_log(const char *fmt, ...)
+{
+  va_list ap;
+  va_start( ap, fmt );
+  printf( "libdvbv5: " );
+  vprintf( fmt, ap );
+  printf( "\n" );
+  va_end( ap );
+}
+
+void dvb_default_logerr(const char *fmt, ...)
+{
+  va_list ap;
+  va_start( ap, fmt );
+  fprintf (stderr, "libdvbv5: ");
+  vfprintf( stderr, fmt, ap );
+  fprintf (stderr, "\n");
+  va_end( ap );
+}
 
 static void dvb_v5_free(struct dvb_v5_fe_parms *parms)
 {
@@ -37,6 +57,14 @@ static void dvb_v5_free(struct dvb_v5_fe_parms *parms)
 struct dvb_v5_fe_parms *dvb_fe_open(int adapter, int frontend, unsigned verbose,
 				    unsigned use_legacy_call)
 {
+  return dvb_fe_open2(adapter, frontend, verbose, use_legacy_call,
+                      dvb_default_log, dvb_default_logerr);
+}
+
+struct dvb_v5_fe_parms *dvb_fe_open2(int adapter, int frontend, unsigned verbose,
+				    unsigned use_legacy_call, dvb_logfunc logfunc,
+                                    dvb_logfunc logerrfunc)
+{
 	int fd, i;
 	char *fname;
 	struct dtv_properties dtv_prop;
@@ -44,18 +72,18 @@ struct dvb_v5_fe_parms *dvb_fe_open(int adapter, int frontend, unsigned verbose,
 
 	asprintf(&fname, "/dev/dvb/adapter%i/frontend%i", adapter, frontend);
 	if (!fname) {
-		perror("fname malloc");
+		logerrfunc("fname calloc: %s", strerror(errno));
 		return NULL;
 	}
 
 	fd = open(fname, O_RDWR, 0);
 	if (fd == -1) {
-		fprintf(stderr, "%s while opening %s\n", strerror(errno), fname);
+		logerrfunc("%s while opening %s", strerror(errno), fname);
 		return NULL;
 	}
 	parms = calloc(sizeof(*parms), 1);
 	if (!parms) {
-		perror("parms calloc");
+		logerrfunc("parms calloc: %s", strerror(errno));
 		close(fd);
 		return NULL;
 	}
@@ -63,9 +91,11 @@ struct dvb_v5_fe_parms *dvb_fe_open(int adapter, int frontend, unsigned verbose,
 	parms->verbose = verbose;
 	parms->fd = fd;
 	parms->sat_number = -1;
+        parms->logfunc = logfunc;
+        parms->logerrfunc = logerrfunc;
 
 	if (ioctl(fd, FE_GET_INFO, &parms->info) == -1) {
-		perror("FE_GET_INFO");
+		dvb_perror("FE_GET_INFO");
 		dvb_v5_free(parms);
 		close(fd);
 		return NULL;
@@ -74,13 +104,12 @@ struct dvb_v5_fe_parms *dvb_fe_open(int adapter, int frontend, unsigned verbose,
 	if (verbose) {
 		fe_caps_t caps = parms->info.caps;
 
-		printf("Device %s (%s) capabilities:\n\t",
+		dvb_log("Device %s (%s) capabilities:",
 			parms->info.name, fname);
 		for (i = 0; i < ARRAY_SIZE(fe_caps_name); i++) {
 			if (caps & fe_caps_name[i].idx)
-				printf ("%s ", fe_caps_name[i].name);
+				dvb_log ("     %s", fe_caps_name[i].name);
 		}
-		printf("\n");
 	}
 
 	parms->dvb_prop[0].cmd = DTV_API_VERSION;
@@ -97,7 +126,7 @@ struct dvb_v5_fe_parms *dvb_fe_open(int adapter, int frontend, unsigned verbose,
 	parms->version = parms->dvb_prop[0].u.data;
 	parms->current_sys = parms->dvb_prop[1].u.data;
 	if (verbose)
-		printf ("DVB API Version %d.%d, Current v5 delivery system: %s\n",
+		dvb_log ("DVB API Version %d.%d, Current v5 delivery system: %s",
 			parms->version / 256,
 			parms->version % 256,
 			delivery_system_name[parms->current_sys]);
@@ -139,7 +168,7 @@ struct dvb_v5_fe_parms *dvb_fe_open(int adapter, int frontend, unsigned verbose,
 			break;
 		}
 		if (!parms->num_systems) {
-			fprintf(stderr, "delivery system not detected\n");
+			dvb_logerr("delivery system not detected");
 			dvb_v5_free(parms);
 			close(fd);
 			return NULL;
@@ -150,7 +179,7 @@ struct dvb_v5_fe_parms *dvb_fe_open(int adapter, int frontend, unsigned verbose,
 		dtv_prop.num = 1;
 		dtv_prop.props = parms->dvb_prop;
 		if (ioctl(fd, FE_GET_PROPERTY, &dtv_prop) == -1) {
-			perror("FE_GET_PROPERTY");
+			dvb_perror("FE_GET_PROPERTY");
 			dvb_v5_free(parms);
 			close(fd);
 			return NULL;
@@ -160,7 +189,7 @@ struct dvb_v5_fe_parms *dvb_fe_open(int adapter, int frontend, unsigned verbose,
 			parms->systems[i] = parms->dvb_prop[0].u.buffer.data[i];
 
 		if (parms->num_systems == 0) {
-			fprintf(stderr, "driver died while trying to set the delivery system\n");
+			dvb_logerr("driver died while trying to set the delivery system");
 			dvb_v5_free(parms);
 			close(fd);
 			return NULL;
@@ -168,19 +197,18 @@ struct dvb_v5_fe_parms *dvb_fe_open(int adapter, int frontend, unsigned verbose,
 	}
 
 	if (verbose) {
-		printf("Supported delivery system%s: ",
+		dvb_log("Supported delivery system%s: ",
 		       (parms->num_systems > 1) ? "s" : "");
 		for (i = 0; i < parms->num_systems; i++) {
 			if (parms->systems[i] == parms->current_sys)
-				printf ("[%s] ",
+				dvb_log ("    [%s]",
 					delivery_system_name[parms->systems[i]]);
 			else
-				printf ("%s ",
+				dvb_log ("     %s",
 					delivery_system_name[parms->systems[i]]);
 		}
-		printf("\n");
 		if (use_legacy_call)
-			printf("Warning: ISDB-T, ISDB-S, DMB-TH and DSS will be miss-detected by a DVBv3 call\n");
+			dvb_log("Warning: ISDB-T, ISDB-S, DMB-TH and DSS will be miss-detected by a DVBv3 call");
 	}
 
 	/*
@@ -259,7 +287,7 @@ int dvb_set_sys(struct dvb_v5_fe_parms *parms,
 		prop.props = dvb_prop;
 
 		if (ioctl(parms->fd, FE_SET_PROPERTY, &prop) == -1) {
-			perror("Set delivery system");
+			dvb_perror("Set delivery system");
 			return errno;
 		}
 		parms->current_sys = sys;
@@ -437,7 +465,7 @@ int dvb_fe_retrieve_parm(struct dvb_v5_fe_parms *parms,
 		*value = parms->dvb_prop[i].u.data;
 		return 0;
 	}
-	fprintf(stderr, "command %s (%d) not found during retrieve\n",
+	dvb_logerr("command %s (%d) not found during retrieve",
 		dvb_cmd_name(cmd), cmd);
 
 	return EINVAL;
@@ -453,7 +481,7 @@ int dvb_fe_store_parm(struct dvb_v5_fe_parms *parms,
 		parms->dvb_prop[i].u.data = value;
 		return 0;
 	}
-	fprintf(stderr, "command %s (%d) not found during store\n",
+	dvb_logerr("command %s (%d) not found during store",
 		dvb_cmd_name(cmd), cmd);
 
 	return EINVAL;
@@ -498,7 +526,7 @@ int dvb_fe_get_parms(struct dvb_v5_fe_parms *parms)
 	prop.num = n;
 	if (!parms->legacy_fe) {
 		if (ioctl(parms->fd, FE_GET_PROPERTY, &prop) == -1) {
-			perror("FE_GET_PROPERTY");
+			dvb_perror("FE_GET_PROPERTY");
 			return errno;
 		}
 		if (parms->verbose) {
@@ -510,7 +538,7 @@ int dvb_fe_get_parms(struct dvb_v5_fe_parms *parms)
 	}
 	/* DVBv3 call */
 	if (ioctl(parms->fd, FE_GET_FRONTEND, &v3_parms) == -1) {
-		perror("FE_GET_FRONTEND");
+		dvb_perror("FE_GET_FRONTEND");
 		return errno;
 	}
 
@@ -575,7 +603,7 @@ int dvb_fe_set_parms(struct dvb_v5_fe_parms *parms)
 
 	if (!parms->legacy_fe) {
 		if (ioctl(parms->fd, FE_SET_PROPERTY, &prop) == -1) {
-			perror("FE_SET_PROPERTY");
+			dvb_perror("FE_SET_PROPERTY");
 			if (parms->verbose)
 				dvb_fe_prt_parms(stderr, parms);
 			return errno;
@@ -617,7 +645,7 @@ int dvb_fe_set_parms(struct dvb_v5_fe_parms *parms)
 		return -EINVAL;
 	}
 	if (ioctl(parms->fd, FE_SET_FRONTEND, &v3_parms) == -1) {
-		perror("FE_SET_FRONTEND");
+		dvb_perror("FE_SET_FRONTEND");
 		if (parms->verbose)
 			dvb_fe_prt_parms(stderr, parms);
 		return errno;
@@ -640,8 +668,8 @@ int dvb_fe_retrieve_stats(struct dvb_v5_fe_parms *parms,
 		*value = parms->stats.prop[i].u.data;
 		return 0;
 	}
-	fprintf(stderr, "%s not found on retrieve\n",
-		dvb_v5_name[cmd]);
+	dvb_logerr("%s not found on retrieve",
+		dvb_cmd_name(cmd));
 
 	return EINVAL;
 }
@@ -656,8 +684,8 @@ int dvb_fe_store_stats(struct dvb_v5_fe_parms *parms,
 		parms->stats.prop[i].u.data = value;
 		return 0;
 	}
-	fprintf(stderr, "%s not found on store\n",
-		dvb_v5_name[cmd]);
+	dvb_logerr("%s not found on store",
+		dvb_cmd_name(cmd));
 
 	return EINVAL;
 }
@@ -675,7 +703,7 @@ int dvb_fe_get_stats(struct dvb_v5_fe_parms *parms)
 	int i;
 
 	if (ioctl(parms->fd, FE_READ_STATUS, &status) == -1) {
-		perror("FE_READ_STATUS");
+		dvb_perror("FE_READ_STATUS");
 		status = -1;
 	}
 	dvb_fe_store_stats(parms, DTV_STATUS, status);
@@ -698,12 +726,12 @@ int dvb_fe_get_stats(struct dvb_v5_fe_parms *parms)
 
 
 	if (parms->verbose > 1) {
-		printf("Status: ");
+		dvb_log("Status: ");
 		for (i = 0; i < ARRAY_SIZE(fe_status_name); i++) {
 			if (status & fe_status_name[i].idx)
-				printf ("%s ", fe_status_name[i].name);
+				dvb_log ("    %s", fe_status_name[i].name);
 		}
-		printf("BER: %d, Strength: %d, SNR: %d, UCB: %d\n",
+		dvb_log("BER: %d, Strength: %d, SNR: %d, UCB: %d",
 		       ber, strength, snr, ucb);
 	}
 	return status;
@@ -722,17 +750,16 @@ int dvb_fe_get_event(struct dvb_v5_fe_parms *parms)
 	}
 
 	if (ioctl(parms->fd, FE_GET_EVENT, &event) == -1) {
-		perror("FE_GET_EVENT");
+		dvb_perror("FE_GET_EVENT");
 		return -1;
 	}
 	status = event.status;
 	if (parms->verbose > 1) {
-		printf("Status: ");
+		dvb_log("Status: ");
 		for (i = 0; i < ARRAY_SIZE(fe_status_name); i++) {
 			if (status & fe_status_name[i].idx)
-				printf ("%s ", fe_status_name[i].name);
+				dvb_log ("    %s", fe_status_name[i].name);
 		}
-		printf("\n");
 	}
 	dvb_fe_store_stats(parms, DTV_STATUS, status);
 
@@ -861,7 +888,7 @@ int dvb_fe_diseqc_reply(struct dvb_v5_fe_parms *parms, unsigned *len, char *buf,
 
 	rc = ioctl(parms->fd, FE_DISEQC_RECV_SLAVE_REPLY, reply);
 	if (rc == -1) {
-		perror("FE_DISEQC_RECV_SLAVE_REPLY");
+		dvb_perror("FE_DISEQC_RECV_SLAVE_REPLY");
 		return errno;
 	}
 
diff --git a/lib/libdvbv5/libsat.c b/lib/libdvbv5/libsat.c
index 25057a6..164059f 100644
--- a/lib/libdvbv5/libsat.c
+++ b/lib/libdvbv5/libsat.c
@@ -298,7 +298,7 @@ static int dvbsat_diseqc_set_input(struct dvb_v5_fe_parms *parms, uint16_t t)
 		high_band = 1;
 	} else {
 		if (sat_number < 0) {
-			fprintf(stderr, "Need a satellite number for DISEqC\n");
+			dvb_logerr("Need a satellite number for DISEqC");
 			return -EINVAL;
 		}
 
@@ -358,7 +358,7 @@ int dvb_sat_set_parms(struct dvb_v5_fe_parms *parms)
 	dvb_fe_retrieve_parm(parms, DTV_FREQUENCY, &freq);
 
 	if (!lnb) {
-		fprintf(stderr, "Need a LNBf to work\n");
+		dvb_logerr("Need a LNBf to work");
 		return -EINVAL;
 	}
 
-- 
1.7.2.5

