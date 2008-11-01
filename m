Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-1.orange.nl ([193.252.22.241])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <michel@verbraak.org>) id 1KwI8q-000061-9c
	for linux-dvb@linuxtv.org; Sat, 01 Nov 2008 16:11:56 +0100
Message-ID: <490C7194.8060603@verbraak.org>
Date: Sat, 01 Nov 2008 16:11:16 +0100
From: Michel Verbraak <michel@verbraak.org>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org, Alex Betis <alex.betis@gmail.com>
References: <c74595dc0810251452s65154902td934e87560cad9f0@mail.gmail.com>
In-Reply-To: <c74595dc0810251452s65154902td934e87560cad9f0@mail.gmail.com>
Content-Type: multipart/mixed; boundary="------------070906020500030301010803"
Subject: Re: [linux-dvb] [ANNOUNCE] scan-s2 is available, please test
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
--------------070906020500030301010803
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Alex,

Tested your scan-s2 with a Technisat HD2 card.

Scanning works. But some channels are reported twice with different 
frequency. I found an error which is fixed by the patch file named 
scan.c.diff1.

I would also like to propose the following change (see file scan.c.diff2 
or scan.c.diff which includes both patches). This change makes it 
possible to only scan for DVB-S channels or DVB-S2 channels or both. 
This is done by specifying lines starting with S or S2 in the input file.

example input file:
# Astra 19.2E SDT info service transponder
# freq pol sr fec
S 12522000 H 22000000 2/3       <only DVB-S channels are scanned>
S 11914000 H 27500000 AUTO
S 10743750 H 22000000 5/6
S 12187500 H 27500000 3/4
S 12343500 H 27500000 3/4
S 12515250 H 22000000 5/6
S 12574250 H 22000000 5/6
S2 12522000 H 22000000 AUTO    <only DVB-S2 channels are scanned>
S2 11914000 H 27500000 AUTO

I hope this is usefull.

Regards,

Michel.

--------------070906020500030301010803
Content-Type: text/plain;
 name="scan.c.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scan.c.diff"

--- scan-s2-88afcf030566/scan.c.orig	2008-11-01 10:09:43.000000000 +0100
+++ scan-s2-88afcf030566/scan.c	2008-11-01 15:55:14.000000000 +0100
@@ -906,10 +906,7 @@
 				// New transponder
 				t = alloc_transponder(tn.frequency);
 
-				// For sattelites start with DVB-S, it will switch to DVB-S2 if DVB-S gives no results
-				if(current_tp->delivery_system == SYS_DVBS || current_tp->delivery_system == SYS_DVBS2) {
-					tn.delivery_system = SYS_DVBS;
-				}
+				tn.delivery_system = current_tp->delivery_system;
 
 				copy_transponder(t, &tn);
 			}
@@ -1578,7 +1575,10 @@
 			if_freq = abs(t->frequency - lnb_type.low_val);
 		}
 		if (verbosity >= 2)
+                   if (t->delivery_system == SYS_DVBS)
 			dprintf(1,"DVB-S IF freq is %d\n", if_freq);
+                  else if (t->delivery_system == SYS_DVBS2)
+			dprintf(1,"DVB-S2 IF freq is %d\n", if_freq);
 	}
 
 
@@ -1640,7 +1640,8 @@
 			// get the actual parameters from the driver for that channel
 			if ((ioctl(frontend_fd, FE_GET_PROPERTY, &cmdseq)) == -1) {
 				perror("FE_GET_PROPERTY failed");
-				return;
+        			t->last_tuning_failed = 1;
+				return -1;
 			}
 
 			t->delivery_system = p[0].u.data;
@@ -1722,12 +1723,6 @@
 
 		rc = tune_to_transponder(frontend_fd, t);
 
-		// If scan failed and it's a DVB-S system, try DVB-S2 before giving up
-		if (rc != 0 && t->delivery_system == SYS_DVBS) {
-			t->delivery_system = SYS_DVBS2;
-			rc = tune_to_transponder(frontend_fd, t);
-		}
-
 		if (rc == 0) {
 			return 0;
 		}
@@ -1992,6 +1987,42 @@
 				t->frequency,
 				pol[0], t->symbol_rate, fec2str(t->fec), rolloff2str(t->rolloff), qam2str(t->modulation));
 		}
+		else if (sscanf(buf, "S2 %u %1[HVLR] %u %4s %4s %6s\n", &f, pol, &sr, fec, rolloff, qam) >= 3) {
+			t = alloc_transponder(f);
+			t->delivery_system = SYS_DVBS2;
+			t->modulation = QAM_AUTO;
+			t->rolloff = ROLLOFF_AUTO;
+			t->fec = FEC_AUTO;
+			switch(pol[0]) 
+			{
+			case 'H':
+			case 'L':
+				t->polarisation = POLARISATION_HORIZONTAL;
+				break;
+			default:
+				t->polarisation = POLARISATION_VERTICAL;;
+				break;
+			}
+			t->inversion = spectral_inversion;
+			t->symbol_rate = sr;
+
+			// parse optional parameters
+			if(strlen(fec) > 0) {
+				t->fec = str2fec(fec);
+			}
+
+			if(strlen(rolloff) > 0) {
+				t->rolloff = str2rolloff(rolloff);
+			}
+
+			if(strlen(qam) > 0) {
+				t->modulation = str2qam(qam);
+			}
+
+			info("initial transponder %u %c %d %s %s %s\n",
+				t->frequency,
+				pol[0], t->symbol_rate, fec2str(t->fec), rolloff2str(t->rolloff), qam2str(t->modulation));
+		}
 		else if (sscanf(buf, "C %u %u %4s %6s\n", &f, &sr, fec, qam) >= 2) {
 			t = alloc_transponder(f);
 			t->delivery_system = SYS_DVBC_ANNEX_AC;

--------------070906020500030301010803
Content-Type: text/plain;
 name="scan.c.diff1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scan.c.diff1"

--- scan-s2-88afcf030566/scan.c.orig	2008-11-01 10:09:43.000000000 +0100
+++ scan-s2-88afcf030566/scan.c	2008-11-01 15:55:14.000000000 +0100
@@ -1640,7 +1640,8 @@
 			// get the actual parameters from the driver for that channel
 			if ((ioctl(frontend_fd, FE_GET_PROPERTY, &cmdseq)) == -1) {
 				perror("FE_GET_PROPERTY failed");
-				return;
+        			t->last_tuning_failed = 1;
+				return -1;
 			}
 
 			t->delivery_system = p[0].u.data;

--------------070906020500030301010803
Content-Type: text/plain;
 name="scan.c.diff2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scan.c.diff2"

--- scan-s2-88afcf030566/scan.c.orig	2008-11-01 10:09:43.000000000 +0100
+++ scan-s2-88afcf030566/scan.c	2008-11-01 15:55:14.000000000 +0100
@@ -906,10 +906,7 @@
 				// New transponder
 				t = alloc_transponder(tn.frequency);
 
-				// For sattelites start with DVB-S, it will switch to DVB-S2 if DVB-S gives no results
-				if(current_tp->delivery_system == SYS_DVBS || current_tp->delivery_system == SYS_DVBS2) {
-					tn.delivery_system = SYS_DVBS;
-				}
+				tn.delivery_system = current_tp->delivery_system;
 
 				copy_transponder(t, &tn);
 			}
@@ -1578,7 +1575,10 @@
 			if_freq = abs(t->frequency - lnb_type.low_val);
 		}
 		if (verbosity >= 2)
+                   if (t->delivery_system == SYS_DVBS)
 			dprintf(1,"DVB-S IF freq is %d\n", if_freq);
+                  else if (t->delivery_system == SYS_DVBS2)
+			dprintf(1,"DVB-S2 IF freq is %d\n", if_freq);
 	}
 
 
@@ -1722,12 +1723,6 @@
 
 		rc = tune_to_transponder(frontend_fd, t);
 
-		// If scan failed and it's a DVB-S system, try DVB-S2 before giving up
-		if (rc != 0 && t->delivery_system == SYS_DVBS) {
-			t->delivery_system = SYS_DVBS2;
-			rc = tune_to_transponder(frontend_fd, t);
-		}
-
 		if (rc == 0) {
 			return 0;
 		}
@@ -1992,6 +1987,42 @@
 				t->frequency,
 				pol[0], t->symbol_rate, fec2str(t->fec), rolloff2str(t->rolloff), qam2str(t->modulation));
 		}
+		else if (sscanf(buf, "S2 %u %1[HVLR] %u %4s %4s %6s\n", &f, pol, &sr, fec, rolloff, qam) >= 3) {
+			t = alloc_transponder(f);
+			t->delivery_system = SYS_DVBS2;
+			t->modulation = QAM_AUTO;
+			t->rolloff = ROLLOFF_AUTO;
+			t->fec = FEC_AUTO;
+			switch(pol[0]) 
+			{
+			case 'H':
+			case 'L':
+				t->polarisation = POLARISATION_HORIZONTAL;
+				break;
+			default:
+				t->polarisation = POLARISATION_VERTICAL;;
+				break;
+			}
+			t->inversion = spectral_inversion;
+			t->symbol_rate = sr;
+
+			// parse optional parameters
+			if(strlen(fec) > 0) {
+				t->fec = str2fec(fec);
+			}
+
+			if(strlen(rolloff) > 0) {
+				t->rolloff = str2rolloff(rolloff);
+			}
+
+			if(strlen(qam) > 0) {
+				t->modulation = str2qam(qam);
+			}
+
+			info("initial transponder %u %c %d %s %s %s\n",
+				t->frequency,
+				pol[0], t->symbol_rate, fec2str(t->fec), rolloff2str(t->rolloff), qam2str(t->modulation));
+		}
 		else if (sscanf(buf, "C %u %u %4s %6s\n", &f, &sr, fec, qam) >= 2) {
 			t = alloc_transponder(f);
 			t->delivery_system = SYS_DVBC_ANNEX_AC;

--------------070906020500030301010803
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------070906020500030301010803--
