Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:55960 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752509AbZF0PPt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Jun 2009 11:15:49 -0400
Content-Type: text/plain; charset="iso-8859-1"
Date: Sat, 27 Jun 2009 17:15:47 +0200
From: "Hans Werner" <HWerner4@gmx.de>
Message-ID: <20090627151547.42070@gmx.net>
MIME-Version: 1.0
Subject: [PATCH] w_scan: allow frontend and demux selection
To: linux-media@vger.kernel.org, handygewinnspiel@gmx.de
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


I found a problem with w_scan. With the following system
(2x HVR-4000):

/dev/dvb/adapter0/frontend0 : DVB-S/S2
/dev/dvb/adapter0/frontend1 : DVB-T
/dev/dvb/adapter1/frontend0 : DVB-S/S2
/dev/dvb/adapter1/frontend1 : DVB-T

there is no way to do a (DVB-T) scan on adapter1/frontend1 because 
1)the automatic selector will always choose adapter0/frontend1
and 
2)the -a option (manual adapter) always forces frontend = 0.

Here's a patch for w_scan which allows one to precisely choose
which frontend is scanned by adding options to specify frontend (-n)
and demux (-d), to be used with the existing adapter (-a) option.

Hans

Signed-off-by: Hans Werner <hwerner4@gmx.de>

--- scan.c.orig	2009-06-26 23:56:15.000000000 +0100
+++ scan.c	2009-06-27 15:33:43.000000000 +0100
@@ -2418,7 +2418,9 @@
 	"		6 = VDR-1.6.x (default)\n"
 	"		7 = VDR-1.7.x\n"
 	".................Device..................\n"
-	"	-a N	use device /dev/dvb/adapterN/ [default: auto detect]\n"
+	"	-a A    use adapter A  /dev/dvb/adapterA/frontend0 [default: auto detect]\n"
+	"	-n N	(with -a ) use frontend N /dev/dvb/adapterA/frontendN [default: auto detect]\n"
+	"	-d D	(with -a ) use demux D    /dev/dvb/adapterA/demuxD [default: auto detect]\n"
 	"	-F	use long filter timeout\n"
 	"	-t N	tuning timeout\n"
 	"		1 = fastest [default]\n"
@@ -2520,11 +2522,17 @@
 	flags.version = version;
 	start_time = time(NULL);
 
-	while ((opt = getopt(argc, argv, "a:c:e:f:hi:kl:o:p:qr:s:t:vxA:D:E:FHI:O:PQ:R:S:T:VX")) != -1) {
+	while ((opt = getopt(argc, argv, "a:n:d:c:e:f:hi:kl:o:p:qr:s:t:vxA:D:E:FHI:O:PQ:R:S:T:VX")) != -1) {
 		switch (opt) {
 		case 'a': //adapter
 			adapter = strtoul(optarg, NULL, 0);
 			break;
+		case 'n': //frontend
+			frontend = strtoul(optarg, NULL, 0);
+			break;
+		case 'd': //demux
+			demux = strtoul(optarg, NULL, 0);
+			break;
 		case 'c': //country setting
 			country=strdup(optarg);
 			if (0 == strcasecmp(country, "?")) {
-- 
Release early, release often.

GRATIS für alle GMX-Mitglieder: Die maxdome Movie-FLAT!
Jetzt freischalten unter http://portal.gmx.net/de/go/maxdome01
