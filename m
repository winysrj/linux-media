Return-path: <linux-media-owner@vger.kernel.org>
Received: from kelvin.aketzu.net ([81.22.244.161]:53787 "EHLO
	kelvin.aketzu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbZBBS5d (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Feb 2009 13:57:33 -0500
Date: Mon, 2 Feb 2009 20:57:31 +0200
From: Anssi Kolehmainen <anssi@aketzu.net>
To: linux-media@vger.kernel.org
Subject: [PATCH] support for channel numbers in scan with Finnish DVB-C
	Welho
Message-ID: <20090202185731.GU11079@aketzu.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="pQhZXvAqiZgbeUkD"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--pQhZXvAqiZgbeUkD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

Attached is small patch to enable channel numbering for FI DVB-C Welho
(similar to UK Freeview). Works for me though resulting list needs to be
sorted before using or else VDR gets channel numbers wrong.

-- 
Anssi Kolehmainen
anssi.kolehmainen@iki.fi
040-5085390

--pQhZXvAqiZgbeUkD
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="welho-channelnum.patch"

diff -r 98d3c06e5ef9 util/scan/scan.c
--- a/util/scan/scan.c	Tue Jan 27 12:39:11 2009 +0100
+++ b/util/scan/scan.c	Mon Feb 02 20:52:30 2009 +0200
@@ -363,6 +363,16 @@
 		}
 		buf += 4;
 	}
+}
+
+static void parse_cable_fi_channel_number (const unsigned char *buf, struct service *s)
+{
+	//We should have four bytes of data
+	if (buf[1] != 0x04)
+		return;
+
+	s->channel_num = buf[3];
+	verbosedebug("Channel number is %d\n", s->channel_num);
 }
 
 
@@ -685,6 +695,13 @@
 			 * problems when 0x83 is something entirely different... */
 			if (t == NIT && vdr_dump_channum)
 				parse_terrestrial_uk_channel_number (buf, data);
+			break;
+		
+		case 0x91:
+			/* 0x91 is also in private range so parse only when we want
+			 * channel numbers */
+			if (t == SDT && vdr_dump_channum)
+				parse_cable_fi_channel_number (buf, data);
 			break;
 
 		default:
@@ -2103,7 +2120,7 @@
 	"		Vdr version 1.3.x and up implies -p.\n"
 	"	-l lnb-type (DVB-S Only) (use -l help to print types) or \n"
 	"	-l low[,high[,switch]] in Mhz\n"
-	"	-u      UK DVB-T Freeview channel numbering for VDR\n\n"
+	"	-u      UK DVB-T Freeview / FI DVB-C Welho channel numbering for VDR\n\n"
 	"	-P do not use ATSC PSIP tables for scanning\n"
 	"	    (but only PAT and PMT) (applies for ATSC only)\n"
 	"	-A N	check for ATSC 1=Terrestrial [default], 2=Cable or 3=both\n"

--pQhZXvAqiZgbeUkD--
