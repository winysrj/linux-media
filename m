Return-path: <mchehab@pedra>
Received: from mailfe04.c2i.net ([212.247.154.98]:34477 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752286Ab1CNJAv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2011 05:00:51 -0400
To: linux-media@vger.kernel.org
Subject: Add support for [non-standard?] DiSEqC switch "MAXIMUM DiSEqC 4/1"
Cc: vdr@linuxtv.org
From: Hans Petter Selasky <hselasky@c2i.net>
Date: Mon, 14 Mar 2011 09:55:18 +0100
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_2fdfNP86jWb1gLz"
Message-Id: <201103140955.18217.hselasky@c2i.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--Boundary-00=_2fdfNP86jWb1gLz
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

The local guy over here mounted what he claimed is a fully standard 4/1
DiSEqC switch which works with every sat-receiver around. After some
brief investigation, it appears this DiSEqC switch is using a non-standard?
scheme, which is not supported by w_scan nor vdr. Correct me if I'm wrong.

To get the switch working with VDR I need an option to turn off the switch
power. This is part of the sequence to program the switch.

I've attached patches for w_scan and VDR to work with the DiSEqC
switch I've got. I don't have any documentation on the switch. All the
programming was the result of two days of reverse engineering. And I did
not open the switch either :-)

Manufacturer homepage:
http://www.kjaerulff1.com/en-gb/p/30_maximum_diseqc_41_switch

Information needed for VDR's diseqc.conf

#
# Full sequence for LNB-A
#
LNB.A 11700 V  9750 t F W45 v W15 W45 F W45 v W15 W45 t W45
LNB.A 99999 V 10600 t F W45 v W15 W45 F W45 v W15 W45 T W45
LNB.A 11700 H  9750 t F W45 V W15 W45 F W45 V W15 W45 t W45
LNB.A 99999 H 10600 t F W45 V W15 W45 F W45 V W15 W45 T W45

#
# Full sequence for LNB-B
#
LNB.B 11700 V  9750 t F W45 v W15 [E0 10 26] W45 F W45 v W15 [E0 10 26] W45 t W45
LNB.B 99999 V 10600 t F W45 v W15 [E0 10 26] W45 F W45 v W15 [E0 10 26] W45 T W45
LNB.B 11700 H  9750 t F W45 V W15 [E0 10 26] W45 F W45 V W15 [E0 10 26] W45 t W45
LNB.B 99999 H 10600 t F W45 V W15 [E0 10 26] W45 F W45 V W15 [E0 10 26] W45 T W45

#
# Full sequence for LNB-C
#
LNB.C 11700 V  9750 t F W45 v W15 [E0 10 27] W45 F W45 v W15 [E0 10 27] W45 t W45
LNB.C 99999 V 10600 t F W45 v W15 [E0 10 27] W45 F W45 v W15 [E0 10 27] W45 T W45
LNB.C 11700 H  9750 t F W45 V W15 [E0 10 27] W45 F W45 V W15 [E0 10 27] W45 t W45
LNB.C 99999 H 10600 t F W45 V W15 [E0 10 27] W45 F W45 V W15 [E0 10 27] W45 T W45

#
# Full sequence for LNB-D
#
LNB.D 11700 V  9750 t F W45 v W15 [E0 10 27] W45 F W45 v W15 [E0 10 26] W45 F W45 v W15 [E0 10 27] W45 F W45 v W15 [E0 10 26] W45 t W45
LNB.D 99999 V 10600 t F W45 v W15 [E0 10 27] W45 F W45 v W15 [E0 10 26] W45 F W45 v W15 [E0 10 27] W45 F W45 v W15 [E0 10 26] W45 T W45
LNB.D 11700 H  9750 t F W45 V W15 [E0 10 27] W45 F W45 V W15 [E0 10 26] W45 F W45 V W15 [E0 10 27] W45 F W45 V W15 [E0 10 26] W45 t W45
LNB.D 99999 H 10600 t F W45 V W15 [E0 10 27] W45 F W45 V W15 [E0 10 26] W45 F W45 V W15 [E0 10 27] W45 F W45 V W15 [E0 10 26] W45 T W45


Good luck!

I hope the patches can be included into VDR and w_scan. Not sure if this is the right list to post the patches.

--HPS

--Boundary-00=_2fdfNP86jWb1gLz
Content-Type: text/x-patch;
  charset="us-ascii";
  name="kjaerulff1_vdr.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="kjaerulff1_vdr.diff"

diff -u -r work.orig/vdr-1.7.16/diseqc.c work/vdr-1.7.16/diseqc.c
--- work.orig/vdr-1.7.16/diseqc.c	2011-03-13 15:01:52.000000000 +0100
+++ work/vdr-1.7.16/diseqc.c	2011-03-13 15:02:26.000000000 +0100
@@ -137,6 +137,7 @@
           case ' ': break;
           case 't': return daToneOff;
           case 'T': return daToneOn;
+          case 'F': return daVoltageOff;
           case 'v': return daVoltage13;
           case 'V': return daVoltage18;
           case 'A': return daMiniA;
diff -u -r work.orig/vdr-1.7.16/diseqc.conf work/vdr-1.7.16/diseqc.conf
--- work.orig/vdr-1.7.16/diseqc.conf	2011-03-13 15:01:52.000000000 +0100
+++ work/vdr-1.7.16/diseqc.conf	2011-03-13 15:02:40.000000000 +0100
@@ -14,6 +14,7 @@
 # command:
 #   t         tone off
 #   T         tone on
+#   F         voltage off (0V)
 #   v         voltage low (13V)
 #   V         voltage high (18V)
 #   A         mini A
diff -u -r work.orig/vdr-1.7.16/diseqc.h work/vdr-1.7.16/diseqc.h
--- work.orig/vdr-1.7.16/diseqc.h	2011-03-13 15:01:52.000000000 +0100
+++ work/vdr-1.7.16/diseqc.h	2011-03-13 15:02:49.000000000 +0100
@@ -18,6 +18,7 @@
     daNone,
     daToneOff,
     daToneOn,
+    daVoltageOff,
     daVoltage13,
     daVoltage18,
     daMiniA,
diff -u -r work.orig/vdr-1.7.16/dvbdevice.c work/vdr-1.7.16/dvbdevice.c
--- work.orig/vdr-1.7.16/dvbdevice.c	2011-03-13 15:01:52.000000000 +0100
+++ work/vdr-1.7.16/dvbdevice.c	2011-03-13 15:03:14.000000000 +0100
@@ -402,6 +402,7 @@
                     case cDiseqc::daNone:      break;
                     case cDiseqc::daToneOff:   CHECK(ioctl(fd_frontend, FE_SET_TONE, SEC_TONE_OFF)); break;
                     case cDiseqc::daToneOn:    CHECK(ioctl(fd_frontend, FE_SET_TONE, SEC_TONE_ON)); break;
+                    case cDiseqc::daVoltageOff: CHECK(ioctl(fd_frontend, FE_SET_VOLTAGE, SEC_VOLTAGE_OFF)); break;
                     case cDiseqc::daVoltage13: CHECK(ioctl(fd_frontend, FE_SET_VOLTAGE, SEC_VOLTAGE_13)); break;
                     case cDiseqc::daVoltage18: CHECK(ioctl(fd_frontend, FE_SET_VOLTAGE, SEC_VOLTAGE_18)); break;
                     case cDiseqc::daMiniA:     CHECK(ioctl(fd_frontend, FE_DISEQC_SEND_BURST, SEC_MINI_A)); break;
diff -u -r work.orig/vdr-1.7.16/include/vdr/diseqc.h work/vdr-1.7.16/include/vdr/diseqc.h
--- work.orig/vdr-1.7.16/include/vdr/diseqc.h	2011-03-13 15:01:52.000000000 +0100
+++ work/vdr-1.7.16/include/vdr/diseqc.h	2011-03-13 15:02:49.000000000 +0100
@@ -18,6 +18,7 @@
     daNone,
     daToneOff,
     daToneOn,
+    daVoltageOff,
     daVoltage13,
     daVoltage18,
     daMiniA,

--Boundary-00=_2fdfNP86jWb1gLz
Content-Type: text/x-patch;
  charset="us-ascii";
  name="kjaerulff1_w_scan.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="kjaerulff1_w_scan.diff"

diff -u -r --exclude='*~' work.orig/w_scan-20110206/diseqc.c work/w_scan-20110206/diseqc.c
--- work.orig/w_scan-20110206/diseqc.c	2011-03-13 12:22:21.000000000 +0100
+++ work/w_scan-20110206/diseqc.c	2011-03-13 14:19:36.000000000 +0100
@@ -157,6 +157,10 @@
 	{ { { MASTER_CMD_NO_RESPONSE, ADDR_ANY_LNB, CMD_WR_N1_UNCOMMITTED, 0xff, 0x00, 0x00 }, 4 }, 20 }
 };
 
+struct diseqc_cmd kjaerulff1_switch_cmds[] = {
+	{ { { MASTER_CMD_NO_RESPONSE, ADDR_ANY_LNB, 0x26, 0x00, 0x00, 0x00 }, 3 }, 20 },
+	{ { { MASTER_CMD_NO_RESPONSE, ADDR_ANY_LNB, 0x27, 0x00, 0x00, 0x00 }, 3 }, 20 },
+};
 
 /******************************************************************************
  * only indices for positioning cmds[] - non standardized.
@@ -453,6 +457,48 @@
 	return err;
 }
 
+int setup_kjaerulff1_switch (int frontend_fd, int switch_pos, int voltage_18, int hiband)
+{
+	int err = 0;
+	int voltage = voltage_18 ? SEC_VOLTAGE_18 : SEC_VOLTAGE_13;
+	int tone = hiband ? SEC_TONE_ON : SEC_TONE_OFF;
+	int n;
+
+	if (switch_pos < 0 || switch_pos > 3)
+		return (-EINVAL);
+
+	err |= ioctl(frontend_fd, FE_SET_TONE, (int)SEC_TONE_OFF);
+
+	for (n = 0; n != 2; n++) {
+
+		err |= ioctl(frontend_fd, FE_SET_VOLTAGE, (int)SEC_VOLTAGE_OFF);
+		usleep(45000);
+		err |= ioctl(frontend_fd, FE_SET_VOLTAGE, voltage);
+		usleep(15000);
+		if (switch_pos == 1)
+			err |= ioctl(frontend_fd, FE_DISEQC_SEND_MASTER_CMD, &kjaerulff1_switch_cmds[0].cmd);
+		if (switch_pos == 2 || switch_pos == 3)
+			err |= ioctl(frontend_fd, FE_DISEQC_SEND_MASTER_CMD, &kjaerulff1_switch_cmds[1].cmd);
+		usleep(45000);
+
+		if (switch_pos == 3) {
+			err |= ioctl(frontend_fd, FE_SET_VOLTAGE, (int)SEC_VOLTAGE_OFF);
+			usleep(45000);
+			err |= ioctl(frontend_fd, FE_SET_VOLTAGE, voltage);
+			usleep(15000);
+			err |= ioctl(frontend_fd, FE_DISEQC_SEND_MASTER_CMD, &kjaerulff1_switch_cmds[0].cmd);
+			usleep(45000);
+		}
+	}
+
+	err |= ioctl(frontend_fd, FE_SET_TONE, tone);
+
+	if (err)
+		return (-EINVAL);
+
+	return (0);
+}
+
 int setup_switch (int frontend_fd, int switch_pos, int voltage_18, int hiband, int uncommitted_switch_pos)
 {
 	int i;
diff -u -r --exclude='*~' work.orig/w_scan-20110206/diseqc.h work/w_scan-20110206/diseqc.h
--- work.orig/w_scan-20110206/diseqc.h	2011-03-13 12:22:21.000000000 +0100
+++ work/w_scan-20110206/diseqc.h	2011-03-13 12:38:18.000000000 +0100
@@ -20,6 +20,7 @@
 /*
 *   set up the switch to position/voltage/tone
 */
+int setup_kjaerulff1_switch (int frontend_fd, int switch_pos, int voltage_18, int hiband);
 int setup_switch (int frontend_fd, int switch_pos, int voltage_18, int freq, int uncommitted_switch_pos);
 int rotate_rotor (int frontend_fd, int * from, int to, uint8_t voltage_18, uint8_t hiband);
 
diff -u -r --exclude='*~' work.orig/w_scan-20110206/scan.c work/w_scan-20110206/scan.c
--- work.orig/w_scan-20110206/scan.c	2011-03-13 12:22:21.000000000 +0100
+++ work/w_scan-20110206/scan.c	2011-03-13 14:23:27.000000000 +0100
@@ -113,6 +113,7 @@
 static int committed_switch = 0;		// 20090320: DVB-S/S2, DISEQC committed switch position
 static int uncommitted_switch = 0;		// 20090320: DVB-S/S2, DISEQC uncommitted switch position
 static struct lnb_types_st this_lnb;		// 20090320: DVB-S/S2, LNB type, initialized in main to 'UNIVERSAL'
+static int kjaerulff1_switch_pos = -1;		// 20110313: Non-standard Kjaerulff1 switch type
 
 time_t start_time = 0;
 
@@ -1619,7 +1620,12 @@
 					if (t->param.frequency >= this_lnb.switch_val)
 						switch_to_high_band++;
 
-					setup_switch (frontend_fd, committed_switch,
+					if (kjaerulff1_switch_pos > -1)
+					      setup_kjaerulff1_switch (frontend_fd, kjaerulff1_switch_pos,
+						t->param.u.qpsk.polarization == POLARIZATION_VERTICAL ? 0 : 1,
+					        switch_to_high_band);
+					else
+					      setup_switch (frontend_fd, committed_switch,
 						t->param.u.qpsk.polarization == POLARIZATION_VERTICAL ? 0 : 1,
 						switch_to_high_band, uncommitted_switch);
 
@@ -2584,6 +2590,7 @@
 	"			? for list\n"
 	"	-D Nc	use DiSEqC committed switch position N\n"
 	"	-D Nu	use DiSEqC uncommitted switch position N\n"
+	"	-K N	use non-standard Kjaerulff1 switch position N\n"
 	"	-p <file>\n"
 	"		use DiSEqC rotor Position file\n"
 	"	-r N use Rotor position N (needs -s)\n"
@@ -2642,7 +2649,7 @@
 	flags.version = version;
 	start_time = time(NULL);
 
-	while ((opt = getopt(argc, argv, "a:c:e:f:hi:kl:o:p:qr:s:t:vxA:D:E:FHI:LMO:PQ:R:S:T:VX")) != -1) {
+	while ((opt = getopt(argc, argv, "a:c:e:f:hi:kl:o:p:qr:s:t:vxA:D:E:FHI:K:LMO:PQ:R:S:T:VX")) != -1) {
 		switch (opt) {
 		case 'a': //adapter
 			adapter = strtoul(optarg, NULL, 0);
@@ -2682,6 +2689,11 @@
 		case 'k': //kaffeine output
 			output_format = OUTPUT_KAFFEINE;
 			break;
+		case 'K':
+			kjaerulff1_switch_pos = strtoul(optarg, NULL, 0);
+			if (kjaerulff1_switch_pos > 3 || kjaerulff1_switch_pos < 0)
+				fatal("kjaerulff1 switch position needs to be in the range [0..3]!\n");
+			break;
 		case 'l': //satellite lnb type
 			if (strcmp(optarg, "?") == 0) {
 				struct lnb_types_st * p;
@@ -3169,6 +3181,8 @@
 			info("using DiSEqC committed switch %d\n", committed_switch);
 		if (uncommitted_switch > 0)
 			info("using DiSEqC uncommitted switch %d\n", uncommitted_switch);
+		if (kjaerulff1_switch_pos > -1)
+			info("using DiSEqC Kjaerulff1 switch %d\n", kjaerulff1_switch_pos);
 		/* grrr...
 		 * DVB API v5 doesnt allow checking for
 		 * S2 capabilities fec3/5, fec9/10, PSK_8,


--Boundary-00=_2fdfNP86jWb1gLz--
