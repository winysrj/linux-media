Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rouge.crans.org ([138.231.136.3])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <braice@braice.net>) id 1JtTD5-0004xJ-5r
	for linux-dvb@linuxtv.org; Tue, 06 May 2008 21:52:24 +0200
Received: from localhost (localhost.crans.org [127.0.0.1])
	by rouge.crans.org (Postfix) with ESMTP id 376E883A0
	for <linux-dvb@linuxtv.org>; Tue,  6 May 2008 21:52:17 +0200 (CEST)
Received: from rouge.crans.org ([10.231.136.3])
	by localhost (rouge.crans.org [10.231.136.3]) (amavisd-new, port 10024)
	with LMTP id 36bawqS54T1b for <linux-dvb@linuxtv.org>;
	Tue,  6 May 2008 21:52:16 +0200 (CEST)
Received: from [192.168.0.10] (free.braice.net [88.162.232.248])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by rouge.crans.org (Postfix) with ESMTP id 5619F8071
	for <linux-dvb@linuxtv.org>; Tue,  6 May 2008 21:52:16 +0200 (CEST)
Message-ID: <4820B6EB.9070204@braice.net>
Date: Tue, 06 May 2008 21:52:11 +0200
From: Brice DUBOST <braice@braice.net>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Content-Type: multipart/mixed; boundary="------------000801060504040907090203"
Subject: [linux-dvb] Patch for the scan utility from dvb-apps
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--------------000801060504040907090203
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hello

I wrote a patch for the scan utility

This patchs allows scan to write his output in the format asked by
mumudvb : http://mumudvb.braice.net/

The patch is joined to this mail, it is against the version 1.1.1 of
dvb-apps.

Is this patch ok for you ?

By the way I have an issue : the French DVB-T network doesn't give the
good frequencies in the SI-Tables. Is there a way to get the frequency
from the card ?

Regards



-- 
Brice

A: Yes.
 >Q: Are you sure?
 >>A: Because it reverses the logical flow of conversation.
 >>>Q: Why is top posting annoying in email?


--------------000801060504040907090203
Content-Type: text/x-diff;
 name="patch-linuxtv-dvb-apps-1.1.1-scan-mumudvb.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch-linuxtv-dvb-apps-1.1.1-scan-mumudvb.patch"

diff -uNr linuxtv-dvb-apps-1.1.1/util/scan/dump-mumudvb.c linuxtv-dvb-apps-scan-mumu/util/scan/dump-mumudvb.c
--- linuxtv-dvb-apps-1.1.1/util/scan/dump-mumudvb.c	1970-01-01 01:00:00.000000000 +0100
+++ linuxtv-dvb-apps-scan-mumu/util/scan/dump-mumudvb.c	2008-05-04 13:24:28.464941015 +0200
@@ -0,0 +1,206 @@
+#include <stdio.h>
+#include "dump-mumudvb.h"
+#include <linux/dvb/frontend.h>
+
+
+static const char *inv_name [] = {
+	"0",
+	"1",
+	"999"
+};
+
+static const char *fec_name [] = {
+	"0",
+	"12",
+	"23",
+	"34",
+	"45",
+	"56",
+	"67",
+	"78",
+	"89",
+	"999"
+};
+
+static const char *qam_name [] = {
+	"0",
+	"16",
+	"32",
+	"64",
+	"128",
+	"256",
+	"999"
+};
+
+
+static const char *bw_name [] = {
+	"8",
+	"7",
+	"6",
+	"999"
+};
+
+
+static const char *mode_name [] = {
+	"2",
+	"8",
+	"999"
+};
+
+static const char *guard_name [] = {
+	"32",
+	"16",
+	"8",
+	"4",
+	"999"
+};
+
+
+static const char *hierarchy_name [] = {
+	"0",
+	"1",
+	"2",
+	"4",
+	"999"
+};
+
+static const char *west_east_flag_name [] = {
+	"W",
+	"E"
+};
+
+void mumudvb_dump_dvb_parameters (FILE *f, fe_type_t type,
+		struct dvb_frontend_parameters *p,
+		char polarity, int orbital_pos, int we_flag)
+{
+
+	switch (type) {
+	case FE_QPSK:
+		fprintf (f, "#QPSK Modulation : DVB-S. Satellite : S%i.%i%s\n", orbital_pos/10,
+			 orbital_pos % 10, west_east_flag_name[we_flag]);
+		fprintf (f, "freq=%i\n", p->frequency / 1000);
+		fprintf (f, "pol=%c\n", polarity);
+		fprintf (f, "srate=%i\n", p->u.qpsk.symbol_rate / 1000);
+		break;
+
+	case FE_QAM:
+	  fprintf (f, "#QAM Modulation : Probably DVB-C ---------- Not Tested ----------- \n");
+		fprintf (f, "%i:", p->frequency / 1000000);
+		fprintf (f, "M%s:C:", qam_name[p->u.qam.modulation]);
+		fprintf (f, "%i:", p->u.qam.symbol_rate / 1000);
+		break;
+
+	case FE_OFDM:
+	  fprintf (f, "#OFDM Modulation : DVB-T\n");
+	  fprintf (f, "#QAM : %s ", qam_name[p->u.ofdm.constellation]);
+	  fprintf (f, "Inversion : %s ", inv_name[p->inversion]);
+	  fprintf (f, "Coderate HP : %s ", fec_name[p->u.ofdm.code_rate_HP]);
+	  fprintf (f, "Coderate LP : %s ", fec_name[p->u.ofdm.code_rate_LP]);
+	  fprintf (f, "Guard interval : %s ", guard_name[p->u.ofdm.guard_interval]);
+	  fprintf (f, "Transmission mode : %s ", mode_name[p->u.ofdm.transmission_mode]);
+	  fprintf (f, "Hierarchy : %s ", hierarchy_name[p->u.ofdm.hierarchy_information]);
+	  fprintf (f, "\n");
+	  if(p->frequency>=0xfffffff)
+	    fprintf (f, "#==========WARNING=============\n#The network provider probably returned the wrong frequency\n#You have to set manually the freq= option\n\n");
+	  else
+	    fprintf (f, "freq=%i\n", p->frequency );
+	  fprintf (f, "bandwith=%sMhz\n", bw_name[p->u.ofdm.bandwidth]);
+	  fprintf (f, "qam=auto\n");
+	  fprintf (f, "trans_mode=auto\n");
+	  fprintf (f, "guardinterval=auto\n");
+	  fprintf (f, "coderate=auto\n");
+		//		fprintf (f, ":T:27500:");
+		break;
+
+	case FE_ATSC:
+		fprintf (f, "%i:", p->frequency / 1000);
+		fprintf (f, "VDR does not support ATSC at this time");
+		break;
+
+	default:
+		fprintf (f, "Modulation : %d\n", type);
+		;
+	};
+
+}
+
+void mumudvb_dump_service_parameter_set (FILE *f,
+				 const char *service_name,
+				 const char *provider_name,
+				 fe_type_t type,
+				 struct dvb_frontend_parameters *p,
+				 char polarity,
+				 int video_pid,
+				 int pcr_pid,
+				 uint16_t *audio_pid,
+				 char audio_lang[][4],
+                                 int audio_num,
+				 int teletext_pid,
+				 int scrambled,
+				 int ac3_pid,
+                                 int service_id,
+				 int network_id,
+				 int transport_stream_id,
+				 int orbital_pos,
+				 int we_flag,
+				 int ca_select,
+				 int channel_num,
+				 int channel_num_mumudvb,
+				 int pmt_pid,
+				 int subtitling_pid)
+{
+        int i;
+
+	if (channel_num_mumudvb == 0)
+	  {
+	    fprintf (f, "#This is an automatically generated config file for mumudvb\n#Check if the ip adresses are good for you\n#You might also have to ad the card=n parameter with n the number of your DVB adapter\n\n");
+	    mumudvb_dump_dvb_parameters (f, type, p, polarity, orbital_pos, we_flag);
+	  }
+	if ((video_pid || audio_pid[0]) && ((ca_select > 0) || ((ca_select == 0) && (scrambled == 0)))) {
+	  fprintf (f, "\n#Channel : \"%s\" Provider : \"%s\" Number : %d\n", service_name, provider_name, channel_num);
+	  fprintf (f, "ip=239.200.200.2%02i\n",channel_num_mumudvb);
+	  fprintf (f, "port=1234\n");
+	  fprintf (f, "name=");
+	  if (audio_lang && audio_lang[0][0])
+		fprintf (f, "%.4s ", audio_lang[0]);
+	  fprintf (f, "%s\n", service_name);
+
+	  fprintf (f, "#Pids are the following : PMT ");
+	  if ((pcr_pid != video_pid) && (video_pid > 0)) fprintf (f, "Video PCR ");
+	  else if (video_pid > 0) fprintf (f, "Video ");
+	  for (i = 0; i < audio_num; i++)
+	    {
+	      if(audio_pid[i]) fprintf (f, "Audio ");
+	    }
+	  if (ac3_pid) fprintf (f, "AC3 ");
+	  if (teletext_pid) fprintf (f, "Text ");
+	  if (subtitling_pid) fprintf (f, "SUB ");
+	  fprintf (f, "\n");
+	  fprintf (f, "pids=");
+	  fprintf (f, "%i ", pmt_pid);
+	  if ((pcr_pid != video_pid) && (video_pid > 0))
+	    fprintf (f, "%i %i", video_pid, pcr_pid);
+	  else if (video_pid > 0)
+	    fprintf (f, "%i", video_pid);
+	  if(audio_pid[0])
+	    fprintf (f, " %i", audio_pid[0]);
+	  for (i = 1; i < audio_num; i++)
+	    {
+	      if(audio_pid[i])
+		fprintf (f, " %i", audio_pid[i]);
+	    }
+	  if (ac3_pid)
+	    {
+	      fprintf (f, " %i", ac3_pid);
+	    }
+	  if (scrambled == 1) scrambled = ca_select;
+	  if (teletext_pid)
+	    fprintf (f, " %d", teletext_pid);
+	  if (subtitling_pid)
+	    fprintf (f, " %d", subtitling_pid);
+	  //	    fprintf (f, ":%d:%d:%d:%d:%d:0", teletext_pid, scrambled,
+	  //		   service_id, network_id, transport_stream_id);
+	  fprintf (f, "\n");
+	}
+}
+
diff -uNr linuxtv-dvb-apps-1.1.1/util/scan/dump-mumudvb.h linuxtv-dvb-apps-scan-mumu/util/scan/dump-mumudvb.h
--- linuxtv-dvb-apps-1.1.1/util/scan/dump-mumudvb.h	1970-01-01 01:00:00.000000000 +0100
+++ linuxtv-dvb-apps-scan-mumu/util/scan/dump-mumudvb.h	2008-05-04 13:24:03.839096762 +0200
@@ -0,0 +1,39 @@
+#ifndef __DUMP_MUMUDVB_H__
+#define __DUMP_MUMUDVB_H__
+
+#include <stdint.h>
+#include <linux/dvb/frontend.h>
+
+extern
+void mumudvb_dump_dvb_parameters (FILE *f, fe_type_t type,
+		struct dvb_frontend_parameters *p,
+		char polarity, int orbital_pos, int we_flag);
+
+extern
+void mumudvb_dump_service_parameter_set (FILE *f,
+				 const char *service_name,
+				 const char *provider_name,
+				 fe_type_t type,
+				 struct dvb_frontend_parameters *p,
+				 char polarity,
+				 int video_pid,
+				 int pcr_pid,
+				 uint16_t *audio_pid,
+				 char audio_lang[][4],
+                                 int audio_num,
+				 int teletext_pid,
+				 int scrambled,
+				 int ac3_pid,
+                                 int service_id,
+				 int network_id,
+				 int transport_stream_id,
+				 int orbital_pos,
+				 int we_flag,
+				 int ca_select,
+				 int channel_num,
+			         int channel_num_mumudvb,
+				 int pmt_pid,
+				 int subtitling_pid);
+
+#endif
+
diff -uNr linuxtv-dvb-apps-1.1.1/util/scan/Makefile linuxtv-dvb-apps-scan-mumu/util/scan/Makefile
--- linuxtv-dvb-apps-1.1.1/util/scan/Makefile	2006-05-18 01:34:53.000000000 +0200
+++ linuxtv-dvb-apps-scan-mumu/util/scan/Makefile	2008-05-04 13:30:28.291877015 +0200
@@ -3,7 +3,7 @@
 CFLAGS = -MD -g -Wall -O2 -I../../include
 LFLAGS = -g -Wall
 
-OBJS = diseqc.o dump-zap.o dump-vdr.o scan.o lnb.o section.o atsc_psip_section.o
+OBJS = diseqc.o dump-mumudvb.o dump-zap.o dump-vdr.o scan.o lnb.o section.o atsc_psip_section.o
 SRCS = $(OBJS:.o=.c)
 
 TARGET = scan
diff -uNr linuxtv-dvb-apps-1.1.1/util/scan/scan.c linuxtv-dvb-apps-scan-mumu/util/scan/scan.c
--- linuxtv-dvb-apps-1.1.1/util/scan/scan.c	2006-05-18 01:33:25.000000000 +0200
+++ linuxtv-dvb-apps-scan-mumu/util/scan/scan.c	2008-05-04 13:25:41.183405766 +0200
@@ -41,6 +41,7 @@
 #include "diseqc.h"
 #include "dump-zap.h"
 #include "dump-vdr.h"
+#include "dump-mumudvb.h"
 #include "scan.h"
 #include "lnb.h"
 
@@ -79,7 +80,8 @@
 enum format {
         OUTPUT_ZAP,
         OUTPUT_VDR,
-	OUTPUT_PIDS
+	OUTPUT_PIDS,
+	OUTPUT_MUMUDVB
 };
 static enum format output_format = OUTPUT_ZAP;
 static int output_format_set = 0;
@@ -528,6 +530,7 @@
 		t->other_f[i] = f * 10;
 		buf += 4;
 	}
+
 }
 
 static void parse_service_descriptor (const unsigned char *buf, struct service *s)
@@ -1923,6 +1926,7 @@
 	int n = 0, i;
 	char sn[20];
         int anon_services = 0;
+        int channel_num_mumudvb = 0;
 
 	list_for_each(p1, &scanned_transponders) {
 		t = list_entry(p1, struct transponder, list);
@@ -1938,6 +1942,7 @@
 		t = list_entry(p1, struct transponder, list);
 		if (t->wrong_frequency)
 			continue;
+		channel_num_mumudvb = 0;
 		list_for_each(p2, &t->services) {
 			s = list_entry(p2, struct service, list);
 
@@ -2001,6 +2006,34 @@
 						    vdr_dump_channum,
 						    s->channel_num);
 				break;
+			  case OUTPUT_MUMUDVB:
+				mumudvb_dump_service_parameter_set (stdout,
+						    s->service_name,
+						    s->provider_name,
+						    t->type,
+						    &t->param,
+						    sat_polarisation(t),
+						    s->video_pid,
+						    s->pcr_pid,
+						    s->audio_pid,
+						    s->audio_lang,
+						    s->audio_num,
+						    s->teletext_pid,
+						    s->scrambled,
+						    //FIXME: s->subtitling_pid
+						    s->ac3_pid,
+						    s->service_id,
+						    t->network_id,
+						    s->transport_stream_id,
+						    t->orbital_pos,
+						    t->we_flag,
+						    ca_select,
+						    s->channel_num,
+						    channel_num_mumudvb,
+						    s->pmt_pid,
+						    s->subtitling_pid);
+				channel_num_mumudvb++;
+				break;
 			  case OUTPUT_ZAP:
 				zap_dump_service_parameter_set (stdout,
 						    s->service_name,
@@ -2013,7 +2046,7 @@
 						    s->service_id);
 			  default:
 				break;
-			  }
+			}
 		}
 	}
 	info("Done.\n");
@@ -2065,7 +2098,7 @@
 	"	-n	evaluate NIT-other for full network scan (slow!)\n"
 	"	-5	multiply all filter timeouts by factor 5\n"
 	"		for non-DVB-compliant section repitition rates\n"
-	"	-o fmt	output format: 'zap' (default), 'vdr' or 'pids' (default with -c)\n"
+	"	-o fmt	output format: 'zap' (default), 'vdr', 'mumudvb' or 'pids' (default with -c)\n"
 	"	-x N	Conditional Axcess, (default 1)\n"
 	"		N=0 gets only FTA channels\n"
 	"		N=xxx sets ca field in vdr output to :xxx:\n"
@@ -2158,6 +2191,7 @@
                         if      (strcmp(optarg, "zap") == 0) output_format = OUTPUT_ZAP;
                         else if (strcmp(optarg, "vdr") == 0) output_format = OUTPUT_VDR;
                         else if (strcmp(optarg, "pids") == 0) output_format = OUTPUT_PIDS;
+                        else if (strcmp(optarg, "mumudvb") == 0) output_format = OUTPUT_MUMUDVB;
                         else {
 				bad_usage(argv[0], 0);
 				return -1;
@@ -2280,6 +2314,7 @@
 	switch (output_format) {
 		case OUTPUT_PIDS:
 		case OUTPUT_VDR:
+		case OUTPUT_MUMUDVB:
 			vdr_dump_dvb_parameters(f, t->type, &t->param,
 					sat_polarisation (t), t->orbital_pos, t->we_flag);
 			break;


--------------000801060504040907090203
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------000801060504040907090203--
