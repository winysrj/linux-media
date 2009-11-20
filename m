Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:42776 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751814AbZKTQcF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Nov 2009 11:32:05 -0500
Subject: Help request: switching multiple TS stream audio PIDs on the fly
 with xine-ui and mplayer
From: Chicken Shack <chicken.shack@gmx.de>
To: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Fri, 20 Nov 2009 17:32:30 +0100
Message-Id: <1258734750.11079.2.camel@brian.bconsult.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'd be really very thankful for any contribution on the following issue:

1. My motivation:
I do not like: KDE 4, kaffeine, xawtv and vdr for reasons I do not want
to discuss here.
I prefer to watch DVB-S TV with xine-ui and / or gmplayer.

2. The current state of development:
Xine-lib supports multiple audio PIDs demuxing TS streams since version
1.1.5.
Mplayer only supports one audio PID (usually the first one that it
finds).

3. My intention:
Switching audio PIDs of DVB-S streams on the fly with the appropriate
GUIs xine-ui and gmplayer.

4. My contribution:
A patch for the scan utility (part of the DVB utils) that features all
available audio PIDs
producing a _non-vdr_ output format.
This patch is not only necessary for revealing multiple audio tracks of
a DVB TV channel in case
you're producing a non-vdr channels.conf.
It also keeps up compatibility with mplayer which cannot (yet) handle
channel lists in vdr format.

--- a/scan.patch
+++ b/scan.patch
@@ -0,0 +1,88 @@
--- a/util/scan/scan.c
+++ b/util/scan/scan.c
@@ -1260,7 +1260,7 @@
 static LIST_HEAD(running_filters);
 static LIST_HEAD(waiting_filters);
 static int n_running;
-#define MAX_RUNNING 27
+#define MAX_RUNNING 10
 static struct pollfd poll_fds[MAX_RUNNING];
 static struct section_buf* poll_section_bufs[MAX_RUNNING];

@@ -2035,6 +2035,8 @@
 						    sat_number(t),
 						    s->video_pid,
 						    s->audio_pid,
+						    s->audio_lang,
+						    s->audio_num,
 						    s->service_id);
 			  default:
 				break;
--- a/util/scan/dump-zap.c
+++ b/util/scan/dump-zap.c
@@ -75,7 +75,6 @@
 		fprintf (f, "%c:", polarity);
 		fprintf (f, "%d:", sat_number);
 		fprintf (f, "%i", p->u.qpsk.symbol_rate / 1000); /* channels.conf
wants kBaud */
-		/*fprintf (f, "%s", fec_name[p->u.qpsk.fec_inner]);*/
 		break;

 	case FE_QAM:
@@ -114,12 +113,27 @@
 				 struct dvb_frontend_parameters *p,
 				 char polarity,
 				 int sat_number,
-				 uint16_t video_pid,
+				 int video_pid,
 				 uint16_t *audio_pid,
-				 uint16_t service_id)
+				 char audio_lang[][4],
+				 int audio_num,
+				 int service_id)
 {
+	int i;
+	if (video_pid || audio_pid[0]) {
 	fprintf (f, "%s:", service_name);
 	zap_dump_dvb_parameters (f, type, p, polarity, sat_number);
+		fprintf (f, ":%i:", video_pid);
+		fprintf (f, "%i", audio_pid[0]);
+		if (audio_lang && audio_lang[0][0])
+			fprintf (f, "=%.4s", audio_lang[0]);
+	        for (i = 1; i < audio_num; i++)
+	        {
+			fprintf (f, ",%i", audio_pid[i]);
+			if (audio_lang && audio_lang[i][0])
+				fprintf (f, "=%.4s", audio_lang[i]);
+		}
+		fprintf (f, ":%d", service_id);
-	fprintf (f, ":%i:%i:%i", video_pid, audio_pid[0], service_id);
 	fprintf (f, "\n");
 }
+}
--- a/util/scan/dump-zap.h
+++ b/util/scan/dump-zap.h
@@ -1,19 +1,17 @@
 #ifndef __DUMP_ZAP_H__
 #define __DUMP_ZAP_H__
-
 #include <stdint.h>
 #include <linux/dvb/frontend.h>
-
 extern void zap_dump_dvb_parameters (FILE *f, fe_type_t type,
 		struct dvb_frontend_parameters *t, char polarity, int sat);
-
 extern void zap_dump_service_parameter_set (FILE *f,
 				 const char *service_name,
 				 fe_type_t type,
-				 struct dvb_frontend_parameters *t,
+				 struct dvb_frontend_parameters *p,
 				 char polarity, int sat,
-				 uint16_t video_pid,
+				 int video_pid,
 				 uint16_t *audio_pid,
-				 uint16_t service_id);
+				 char audio_lang[][4],
+				 int audio_num,
+				 int service_id);
-
 #endif

5. Your contribution?

Who can give me hints about how and where patching xine-ui and gmplayer
appropriately so that multiple audio TS PIDS can be changed on the fly?
Who can offer appropriate patches?

Thanks


