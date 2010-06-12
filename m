Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv-hp4.netsons.net ([94.141.22.26]:44703 "EHLO
	SRV-HP4.netsons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481Ab0FLHVS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Jun 2010 03:21:18 -0400
Received: from localhost ([127.0.0.1] helo=webmail.ftp21.eu)
	by SRV-HP4.netsons.net with esmtpa (Exim 4.69)
	(envelope-from <ftp21@ftp21.eu>)
	id 1ONL1p-0002Rt-51
	for linux-media@vger.kernel.org; Sat, 12 Jun 2010 09:21:17 +0200
Message-ID: <178db73905f6be8c2e18984451a9f539.squirrel@webmail.ftp21.eu>
Date: Sat, 12 Jun 2010 09:21:17 +0200
Subject: [PATCH] Add the IT LCN for DVB-T
From: ftp21@ftp21.eu
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20100612092117_81744"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

------=_20100612092117_81744
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

Hello dear list

I write a patch for scan.c to add the LCN for the IT DVB-T.
This patch add the option -I.This option work like the -u option


My little contribute:)

Valerio 'ftp21'
------=_20100612092117_81744
Content-Type: text/x-patch; name="it_lcn.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="it_lcn.patch"

--- scan.c	2010-06-09 13:22:32.560820169 +0200
+++ scan_modificato.c	2010-06-09 13:17:52.600818827 +0200
@@ -59,6 +59,7 @@
 static int get_other_nits;
 static int vdr_dump_provider;
 static int vdr_dump_channum;
+static int country;
 static int no_ATSC_PSIP;
 static int ATSC_type=1;
 static int ca_select = -1;
@@ -344,7 +345,7 @@
 	info("Network Name '%.*s'\n", len, buf + 2);
 }
 
-static void parse_terrestrial_uk_channel_number (const unsigned char *buf, void *dummy)
+static void parse_terrestrial_uk_channel_number (const unsigned char *buf, void *dummy,int c)
 {
 	(void)dummy;
 
@@ -361,8 +362,18 @@
 	// desc id, desc len, (service id, service number)
 	buf += 2;
 	for (i = 0; i < n; i++) {
-		service_id = (buf[0]<<8)|(buf[1]&0xff);
-		channel_num = ((buf[2]&0x03)<<8)|(buf[3]&0xff);
+		switch(c){
+			case 1:
+			//UK LCN
+				service_id = (buf[0]<<8)|(buf[1]&0xff);
+				channel_num = ((buf[2]&0x03)<<8)|(buf[3]&0xff);
+				break;
+			case 2:
+			//IT LCN
+				service_id=(buf[0] << 8) | buf[1];	
+				channel_num=((buf[2] & 0x03) << 8) | buf[3];
+				break;
+		}
 		debug("Service ID 0x%x has channel number %d ", service_id, channel_num);
 		list_for_each(p1, &scanned_transponders) {
 			t = list_entry(p1, struct transponder, list);
@@ -695,7 +706,7 @@
 			 * so we parse this only if the user says so to avoid
 			 * problems when 0x83 is something entirely different... */
 			if (t == NIT && vdr_dump_channum)
-				parse_terrestrial_uk_channel_number (buf, data);
+				parse_terrestrial_uk_channel_number (buf, data,country);
 			break;
 
 		default:
@@ -2115,6 +2126,7 @@
 	"	-l lnb-type (DVB-S Only) (use -l help to print types) or \n"
 	"	-l low[,high[,switch]] in Mhz\n"
 	"	-u      UK DVB-T Freeview channel numbering for VDR\n\n"
+	"	-I      IT DVB-T channel numbering for VDR\n\n"
 	"	-P do not use ATSC PSIP tables for scanning\n"
 	"	    (but only PAT and PMT) (applies for ATSC only)\n"
 	"	-A N	check for ATSC 1=Terrestrial [default], 2=Cable or 3=both\n"
@@ -2166,7 +2178,7 @@
 
 	/* start with default lnb type */
 	lnb_type = *lnb_enum(0);
-	while ((opt = getopt(argc, argv, "5cnpa:f:d:s:o:x:e:t:i:l:vquPA:U")) != -1) {
+	while ((opt = getopt(argc, argv, "5cnpa:f:d:s:o:x:e:t:i:l:vquIPA:U")) != -1) {
 		switch (opt) {
 		case 'a':
 			adapter = strtoul(optarg, NULL, 0);
@@ -2230,6 +2242,13 @@
 				verbosity = 0;
 			break;
 		case 'u':
+			//uk lcn
+			country=1;
+			vdr_dump_channum = 1;
+			break;
+		case 'I':
+			//it lcn			
+			country=2;
 			vdr_dump_channum = 1;
 			break;
 		case 'P':
------=_20100612092117_81744--


