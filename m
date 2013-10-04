Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3934 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741Ab3JDLqb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Oct 2013 07:46:31 -0400
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr1.xs4all.nl (8.13.8/8.13.8) with ESMTP id r94BkRER007621
	for <linux-media@vger.kernel.org>; Fri, 4 Oct 2013 13:46:30 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id B2A6C2A0769
	for <linux-media@vger.kernel.org>; Fri,  4 Oct 2013 13:46:23 +0200 (CEST)
Message-ID: <524EAA8F.6030809@xs4all.nl>
Date: Fri, 04 Oct 2013 13:46:23 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] dvb-apps: fix compiler warnings
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes all remaining dvb-apps compiler warnings:

test_video.c:322:2: warning: format ‘%d’ expects argument of type ‘int’, but argument 2 has type ‘ssize_t’ [-Wformat=]
dvbscan.c:128:6: warning: variable ‘output_type’ set but not used [-Wunused-but-set-variable]
dvbscan.c:126:6: warning: variable ‘uk_ordering’ set but not used [-Wunused-but-set-variable]
dvbscan.c:124:32: warning: variable ‘inversion’ set but not used [-Wunused-but-set-variable]
dvbscan_dvb.c:27:44: warning: unused parameter ‘fe’ [-Wunused-parameter]
dvbscan_atsc.c:27:45: warning: unused parameter ‘fe’ [-Wunused-parameter]

Make.rules has been updated to remove the deprecated -W flag which caused the last
two warnings (I see no reason to give warnings for unused parameters).

A printf was updated to fix a type mismatch and dvbscan.c was updated to fix several
'set but not used' warnings. I decided not to remove the ignored options just in case
some scripts might use them, but I did document in the usage message that those options
are ignored.

Fixing this should allow the daily build to produce an OK message, I hope.

Regards,

	Hans

diff -r 3ee111da5b3a Make.rules
--- a/Make.rules	Mon May 13 15:49:02 2013 +0530
+++ b/Make.rules	Fri Oct 04 13:40:18 2013 +0200
@@ -1,6 +1,6 @@
 # build rules for linuxtv.org dvb-apps
 
-CFLAGS ?= -g -Wall -W -Wshadow -Wpointer-arith -Wstrict-prototypes
+CFLAGS ?= -g -Wall -Wshadow -Wpointer-arith -Wstrict-prototypes
 
 ifneq ($(lib_name),)
 
diff -r 3ee111da5b3a test/test_video.c
--- a/test/test_video.c	Mon May 13 15:49:02 2013 +0530
+++ b/test/test_video.c	Fri Oct 04 13:40:18 2013 +0200
@@ -319,7 +319,7 @@
 		return;
 	}
 
-	printf("read: %d bytes\n",read(filefd,sp.iFrame,sp.size));
+	printf("read: %zd bytes\n",read(filefd,sp.iFrame,sp.size));
 	videoStillPicture(fd,&sp);
 
 	sleep(3);
diff -r 3ee111da5b3a util/dvbscan/dvbscan.c
--- a/util/dvbscan/dvbscan.c	Mon May 13 15:49:02 2013 +0530
+++ b/util/dvbscan/dvbscan.c	Fri Oct 04 13:40:18 2013 +0200
@@ -74,8 +74,8 @@
 		"						Dual LO, H:5150MHz, V:5750MHz.\n"
 		"			 * One of the sec definitions from the secfile if supplied\n"
 		" -satpos <position>	Specify DISEQC switch position for DVB-S.\n"
-		" -inversion <on|off|auto> Specify inversion (default: auto).\n"
-		" -uk-ordering 		Use UK DVB-T channel ordering if present.\n"
+		" -inversion <on|off|auto> Specify inversion (default: auto) (note: this option is ignored).\n"
+		" -uk-ordering 		Use UK DVB-T channel ordering if present (note: this option is ignored).\n"
 		" -timeout <secs>	Specify filter timeout to use (standard specced values will be used by default)\n"
 		" -filter <filter>	Specify service filter, a comma seperated list of the following tokens:\n"
 		" 			 (If no filter is supplied, all services will be output)\n"
@@ -83,10 +83,11 @@
 		"			 * radio - Output radio channels\n"
 		"			 * other - Output other channels\n"
 		"			 * encrypted - Output encrypted channels\n"
-		" -out raw <filename>|-	 Output in raw format to <filename> or stdout\n"
+		" -out raw <filename>|-	Output in raw format to <filename> or stdout\n"
 		"      channels <filename>|-  Output in channels.conf format to <filename> or stdout.\n"
 		"      vdr12 <filename>|- Output in vdr 1.2.x format to <filename> or stdout.\n"
 		"      vdr13 <filename>|- Output in vdr 1.3.x format to <filename> or stdout.\n"
+		"			Note: this option is ignored.\n"
 		" <initial scan file>\n";
 	fprintf(stderr, "%s\n", _usage);
 
@@ -121,11 +122,11 @@
 	char *secfile = NULL;
 	char *secid = NULL;
 	int satpos = 0;
-	enum dvbfe_spectral_inversion inversion = DVBFE_INVERSION_AUTO;
+	//enum dvbfe_spectral_inversion inversion = DVBFE_INVERSION_AUTO;
 	int service_filter = -1;
-	int uk_ordering = 0;
+	//int uk_ordering = 0;
 	int timeout = 5;
-	int output_type = OUTPUT_TYPE_RAW;
+	//int output_type = OUTPUT_TYPE_RAW;
 	char *output_filename = NULL;
 	char *scan_filename = NULL;
 	struct dvbsec_config sec;
@@ -172,11 +173,11 @@
 			if ((argc - argpos) < 2)
 				usage();
 			if (!strcmp(argv[argpos+1], "off")) {
-				inversion = DVBFE_INVERSION_OFF;
+				//inversion = DVBFE_INVERSION_OFF;
 			} else if (!strcmp(argv[argpos+1], "on")) {
-				inversion = DVBFE_INVERSION_ON;
+				//inversion = DVBFE_INVERSION_ON;
 			} else if (!strcmp(argv[argpos+1], "auto")) {
-				inversion = DVBFE_INVERSION_AUTO;
+				//inversion = DVBFE_INVERSION_AUTO;
 			} else {
 				usage();
 			}
@@ -184,7 +185,7 @@
 		} else if (!strcmp(argv[argpos], "-uk-ordering")) {
 			if ((argc - argpos) < 1)
 				usage();
-			uk_ordering = 1;
+			//uk_ordering = 1;
 		} else if (!strcmp(argv[argpos], "-timeout")) {
 			if ((argc - argpos) < 2)
 				usage();
@@ -212,13 +213,13 @@
 			if ((argc - argpos) < 3)
 				usage();
 			if (!strcmp(argv[argpos+1], "raw")) {
-				output_type = OUTPUT_TYPE_RAW;
+				//output_type = OUTPUT_TYPE_RAW;
 			} else if (!strcmp(argv[argpos+1], "channels")) {
-				output_type = OUTPUT_TYPE_CHANNELS;
+				//output_type = OUTPUT_TYPE_CHANNELS;
 			} else if (!strcmp(argv[argpos+1], "vdr12")) {
-				output_type = OUTPUT_TYPE_VDR12;
+				//output_type = OUTPUT_TYPE_VDR12;
 			} else if (!strcmp(argv[argpos+1], "vdr13")) {
-				output_type = OUTPUT_TYPE_VDR13;
+				//output_type = OUTPUT_TYPE_VDR13;
 			} else {
 				usage();
 			}
