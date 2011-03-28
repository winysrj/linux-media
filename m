Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:16912 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753245Ab1C1O3v (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Mar 2011 10:29:51 -0400
Message-ID: <4D909B59.9040809@redhat.com>
Date: Mon, 28 Mar 2011 11:29:45 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: wk <handygewinnspiel@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [w_scan PATCH] Add Brazil support on w_scan
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

While w_scan Country table has entries for Brazil, they're currently
not handled.

Brazil uses ISDB-T standard (also called SBTVD) for terrestrial
transmissions. Thanks to the way DVB drivers implement ISDB-T,
DVB API v3 calls are handled as if it were DVB-T, and this works
fine for broadcast TV. However, it uses a 6MHz frequency table
close to the one used in US. However, ISDB-T requires a frequency
shift of 142,857 Hz in order to get the central OFTM carrier.

Cable operators use DVB-C, but as they migrated from a PAL/M 6MHz
frequency table identical to NTSC IRC one, DVB-C channels are also
spaced with 6MHz, and the symbol rate is lower than what's found
with 7/8MHz.

For Satellite, Brazil uses DVB-S/DVB-S2 standards on both C and Ku
bands, but, as I currently don't have a Satellite dish, I couldn't 
test if w_scan works for it, but I suspect that no changes are needed
for DVB-S.

This patch adds support for both ISDB-T and DVB-C @6MHz used in
Brazil, and adds a new bit rate of 5.2170 MSymbol/s, found on QAM256
transmissions at some Brazilian cable operators.

While here, fix compilation with kernels 2.6.39 and later, where the
old V4L1 API were removed (so, linux/videodev.h doesn't exist anymore).
This is needed to compile it on Fedora 15 beta.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff -r 1bd9736b45fe w_scan-20110206/countries.c
--- a/w_scan-20110206/countries.c	Tue Mar 22 23:19:49 2011 -0300
+++ b/w_scan-20110206/countries.c	Mon Mar 28 11:11:28 2011 -0300
@@ -31,7 +31,7 @@
 #include <string.h>
 #include <unistd.h>
 #include <stdlib.h>
-#include <linux/videodev.h>
+#include <linux/videodev2.h>
 #include <linux/dvb/frontend.h>
 
 #ifdef VDRVERSNUM
@@ -136,6 +136,20 @@
                                 }
                         break;
                 
+		case	BR:	// Brazil
+                        switch(*dvb) {    
+                                case FE_QAM:
+                                        *frontend_type = FE_QAM;
+                                        info("DVB cable\n");
+                                        break;
+                                default:
+                                        *frontend_type = FE_OFDM;
+                                        info("ISDB-T (SBTVD)\n");
+                                        break;               
+                                }
+                        break;
+
+
                 case    US:     //      UNITED STATES
                 case    CA:     //      CANADA
                         *frontend_type = FE_ATSC;
@@ -245,6 +259,18 @@
                                 info("QAM US/CA\n");    
                                 }
                         break;
+		case	BR:
+                        switch(*dvb) {    
+                                case FE_QAM:
+					*channellist = DVBC_BR;
+                                        info("Brazil, cable\n");
+                                        break;
+                                default:
+					*channellist = ISDBT_6MHZ;
+                                        info("Brazil, terrestrial\n");
+                                        break;               
+                                }
+                        break;
                 //******************************************************************//    
                 default:
                         info("Country identifier %s not defined. Using default freq lists.\n", country);
@@ -278,6 +304,23 @@
                         case 14 ... 69: return  389000000;
                         default:        return  SKIP_CHANNEL;
                         }
+        case ISDBT_6MHZ: // ISDB-T, 6 MHz central frequencies
+                switch (channel) {
+			// Channels 7-13 are reserved but aren't used yet
+                        case 14 ... 69: return  389000000 + 142857;
+                        default:        return  SKIP_CHANNEL;
+                        }
+	case DVBC_BR: //BRAZIL - same range as ATSC IRC
+                switch (channel) {
+                        case 02 ... 04:   return   45000000;
+                        case 05 ... 06:   return   49000000;
+                        case 07 ... 13:   return  135000000;
+                        case 14 ... 22:   return   39000000;
+                        case 23 ... 94:   return   81000000;
+                        case 95 ... 99:   return -477000000;
+                        case 100 ... 133: return   51000000;
+                        default:          return SKIP_CHANNEL; 
+                        }
         case DVBT_AU: //AUSTRALIA, 7MHz step list
                 switch (channel) {
                         case 05 ... 12: return  142500000;
@@ -321,6 +364,8 @@
  */
 int freq_step(int channel, int channellist) {
 switch (channellist) {
+        case ISDBT_6MHZ:
+        case DVBC_BR:
         case ATSC_QAM:
         case ATSC_VSB: return  6000000; // atsc, 6MHz step
         case DVBT_AU:  return  7000000; // dvb-t australia, 7MHz step
diff -r 1bd9736b45fe w_scan-20110206/countries.h
--- a/w_scan-20110206/countries.h	Tue Mar 22 23:19:49 2011 -0300
+++ b/w_scan-20110206/countries.h	Mon Mar 28 11:11:28 2011 -0300
@@ -43,6 +43,8 @@
         DVBC_QAM                = 7,
         DVBC_FI                 = 8,
         DVBC_FR                 = 9,
+	DVBC_BR			= 10,
+	ISDBT_6MHZ		= 11,
         USERLIST                = 999
 };
 
diff -r 1bd9736b45fe w_scan-20110206/scan.c
--- a/w_scan-20110206/scan.c	Tue Mar 22 23:19:49 2011 -0300
+++ b/w_scan-20110206/scan.c	Mon Mar 28 11:11:28 2011 -0300
@@ -1914,6 +1914,7 @@
 		case 14:		return 5483000;
 		case 15:		return 6956000;
 		case 16:		return 6956500;
+		case 17:		return 5217000;		// Used in Brazil DVB-C @ 6MHz Bandwidth
 		default:		return 0;
 		}
 }
@@ -1985,6 +1986,10 @@
 		dvbc_symbolrate_min=dvbc_symbolrate_max=0;
 		break;
 	case FE_QAM:
+		// 6MHz DVB-C uses lower symbol rates
+		if (freq_step(channel, this_channellist) == 6000000) {
+			dvbc_symbolrate_min=dvbc_symbolrate_max=17;
+		}
 		break;
 	case FE_QPSK:
 		// channel means here: transponder,
@@ -2555,7 +2560,7 @@
 	"			enables scan of symbolrates\n"
 	"			6111, 6250, 6790, 6811, 5900,\n"
 	"			5000, 3450, 4000, 6950, 7000,\n"
-	"			6952, 6956, 6956.5\n"
+	"			6952, 6956, 6956.5, 5.217\n"
 	"		2 = extended QAM scan (enable QAM128)\n"
 	"			recommended for Nethterlands and Finland\n"
 	"		NOTE: extended scan will be *slow*\n"
@@ -2577,6 +2582,7 @@
 	"			14 = 5.4830 MSymbol/s\n"
 	"			15 = 6.9560 MSymbol/s\n"
 	"			16 = 6.9565 MSymbol/s\n"
+	"			17 = 5.2170 MSymbol/s\n"
 	"		NOTE: for experienced users only!!\n"
 	".................DVB-S/S2................\n"
 	"	-l <LNB type>\n"
@@ -2657,7 +2663,7 @@
 		case 'e': //extended scan flags
 			ext = strtoul(optarg, NULL, 0);
 			if (ext & 0x01)
-				dvbc_symbolrate_max = 16;
+				dvbc_symbolrate_max = 17;
 			if (ext & 0x02) {
 				modulation_max = 2;
 				modulation_flags |= MOD_OVERRIDE_MAX;
