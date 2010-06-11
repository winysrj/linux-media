Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <ftp21@ftp21.eu>) id 1ON9nb-0000qD-SU
	for linux-dvb@linuxtv.org; Fri, 11 Jun 2010 21:21:52 +0200
Received: from srv-hp4.netsons.net ([94.141.22.26])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-a) with esmtps
	[TLSv1:AES256-SHA:256] for <linux-dvb@linuxtv.org>
	id 1ON9nb-0000Io-Ax; Fri, 11 Jun 2010 21:21:51 +0200
Received: from localhost ([127.0.0.1] helo=webmail.ftp21.eu)
	by SRV-HP4.netsons.net with esmtpa (Exim 4.69)
	(envelope-from <ftp21@ftp21.eu>) id 1ON9nZ-0004bg-6J
	for linux-dvb@linuxtv.org; Fri, 11 Jun 2010 21:21:49 +0200
Message-ID: <c4b9aa936d62fffa788706cbc079c1ae.squirrel@webmail.ftp21.eu>
Date: Fri, 11 Jun 2010 21:21:49 +0200
From: ftp21@ftp21.eu
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20100611212149_58833"
Subject: [linux-dvb] [PATCH] Add the IT LCN for DVB-T
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

------=_20100611212149_58833
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

Hello developers
I write a patch for scan.c to add the LCN for the IT DVB-IT

This patch add the option -I and work if the -o vdr is enabled


My little contribute for a big project :)
Valerio 'ftp21'
------=_20100611212149_58833
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
------=_20100611212149_58833
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
------=_20100611212149_58833--
