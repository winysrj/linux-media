Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3.goneo.de ([85.220.129.37]:53276 "EHLO smtp3.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550AbcCJOIK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2016 09:08:10 -0500
Received: from localhost (localhost [127.0.0.1])
	by smtp3.goneo.de (Postfix) with ESMTP id 20CDF23EE9A
	for <linux-media@vger.kernel.org>; Thu, 10 Mar 2016 15:08:05 +0100 (CET)
Received: from smtp3.goneo.de ([127.0.0.1])
	by localhost (smtp3.goneo.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id efWvLomLNaRb for <linux-media@vger.kernel.org>;
	Thu, 10 Mar 2016 15:07:49 +0100 (CET)
Received: from sol.fritz.box (dyndsl-095-033-016-200.ewe-ip-backbone.de [95.33.16.200])
	by smtp3.goneo.de (Postfix) with ESMTPSA id 84D6723EFCB
	for <linux-media@vger.kernel.org>; Thu, 10 Mar 2016 15:07:49 +0100 (CET)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: DVBv5 Tools: VDR support seems to be broken (recommended patch)
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <19129703-C076-47F7-BEFF-8A57D172132D@darmarit.de>
Date: Thu, 10 Mar 2016 15:07:48 +0100
Content-Transfer-Encoding: 8BIT
Message-Id: <EFEC860B-B1FC-499D-911C-61DC3C0A9517@darmarit.de>
References: <19129703-C076-47F7-BEFF-8A57D172132D@darmarit.de>
To: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi (Mauro),

below you will find my recommended patch for the broken 
VDR format (libdvbv5/dvb-vdr-format.c).

There is only one point I have a doubt: I have no ATSC 
experience (I'am in Europe/germ), so I simply added 
an "A" at the field "satellite pos.". This is what 
the w_scan tool does and this tool works fine with
the vdr (please correct me if I'am wrong).

My test-case was the same as mentioned in the first
mail (see below). Which means, I haven't tested with
vdr, only with mpv.

Is there anyone how can take up this patch? 
... may be Mauro, the originator of vdr support?

With best regards

 -- M --


diff --git a/lib/libdvbv5/dvb-vdr-format.c b/lib/libdvbv5/dvb-vdr-format.c
index 176a927..5151ebc 100644
--- a/lib/libdvbv5/dvb-vdr-format.c
+++ b/lib/libdvbv5/dvb-vdr-format.c
@@ -310,13 +310,14 @@ int dvb_write_format_vdr(const char *fname,
 		fprintf(fp, "%s", entry->channel);
 		if (entry->vchannel)
 			fprintf(fp, ",%s", entry->vchannel);
+		fprintf(fp, ":");
 
 		/*
 		 * Output frequency:
 		 *	in kHz for terrestrial/cable
 		 *	in MHz for satellite
 		 */
-		fprintf(fp, ":%i:", freq / 1000);
+		fprintf(fp, "%i:", freq / 1000);
 
 		/* Output modulation parameters */
 		fmt = &formats[i];
@@ -350,20 +351,28 @@ int dvb_write_format_vdr(const char *fname,
 
 			fprintf(fp, "%s", table->table[data]);
 		}
-
-		/* Output format type */
-		fprintf(fp, ":%s:", id);
+		fprintf(fp, ":");
 
 		/*
-		 * Output satellite location
-		 * FIXME: probably require some adjustments to match the
-		 *	  format expected by VDR.
+		 * Output sources configuration for VDR
+		 *
+		 *   S (satellite) xy.z (orbital position in degrees) E or W (east or west)
+                 *
+                 *   FIXME: in case of ATSC we use "A", this is what w_scan does
 		 */
-		switch(delsys) {
-		case SYS_DVBS:
-		case SYS_DVBS2:
-			fprintf(fp, "%s:", entry->location);
+
+		if (entry->location) {
+		  switch(delsys) {
+		  case SYS_DVBS:
+		  case SYS_DVBS2:
+		    fprintf(fp, "%s", entry->location);	  break;
+		  default:
+		    fprintf(fp, "%s", id);		  break;
+		  }
+		} else {
+		  fprintf(fp, "%s", id);
 		}
+		fprintf(fp, ":");
 
 		/* Output symbol rate */
 		srate = 27500000;
@@ -408,10 +417,16 @@ int dvb_write_format_vdr(const char *fname,
 		/* Output Service ID */
 		fprintf(fp, "%d:", entry->service_id);
 
-		/* Output SID, NID, TID and RID */
-		fprintf(fp, "0:0:0:");
+		/* Output Network ID */
+		fprintf(fp, "0:");
+
+		/* Output Transport Stream ID */
+		fprintf(fp, "0:");
 
-		fprintf(fp, "\n");
+		/* Output Radio ID
+		   this is the last entry, tagged bei a new line (not a colon!)
+		 */
+		fprintf(fp, "0\n");
 		line++;
 	};
 	fclose (fp);


-- M --

--

Mit freundlichem Gruss

    -- M.Heiser --

 ---------------------------------------------------------------------
 darmarIT // IT solutions & services
 ---------------------------------------------------------------------

 Darius Biss & Markus Heiser GbR
 Wattenscheider Weg 2
 28199 Bremen

 phone	: +49 (0) 4792 987 946 9
 fax	: +49 (0) 421 433 498 7
 mobil	: +49 (0) 157 316 2222 4

 e-mail : markus.heiser@darmarIT.de
 web    : http://www.darmarIT.de

 ---------------------------------------------------------------------



Am 09.03.2016 um 16:43 schrieb Markus Heiser <markus.heiser@darmarIT.de>:

> Hi,
> 
> I tested DVBv5 tools, creating vdr channel lists. My first attemp
> was to convert a dvbv5 channel list:
> 
> <SNIP> -----------------------------
> # file: test_convert_in.conf
> #
> # converted with: dvb-format-convert -I DVBV5 -O VDR  test_convert_in.conf test_convert_out.conf
> #
> [Das Erste HD]
> 	SERVICE_ID = 10301
> 	VIDEO_PID = 5101
> 	AUDIO_PID = 5102 5103 5106 5108
> 	PID_0b = 5172 2171
> 	PID_06 = 5105 5104
> 	PID_05 = 1170
> 	LNB = UNIVERSAL
> 	FREQUENCY = 11494000
> 	INVERSION = OFF
> 	SYMBOL_RATE = 22000488
> 	INNER_FEC = 2/3
> 	MODULATION = PSK/8
> 	PILOT = ON
> 	ROLLOFF = 35
> 	POLARIZATION = HORIZONTAL
> 	STREAM_ID = 0
> 	DELIVERY_SYSTEM = DVBS2
> <SNAP> -----------------------------
> 
> 
> this results in a strange VDR channel (test_convert_out.conf):
> 
> 
> <SNIP> -----------------------------
> Das Erste HD:11494:S1HC23I0M5N1O35:S:(null):22000:5101:5102,5103,5106,5108:0:0:10301:0:0:0:
> <SNAP> -----------------------------
> 
> 
> so I created an other (vdr) channel-file (test123.conf) to see how 
> to fix the problem:
> 
> 
> <SNIP> -----------------------------
> # file test123.conf
> #
> # tested with: mpv -v --dvbin-file=test123.conf dvb://"Das Erste HD fixed"
> #
> Das Erste HD:11494:S1HC23I0M5N1O35:S:(null):22000:5101:5102,5103,5106,5108:0:0:10301:0:0:0:
> #
> # dropping "(null):" and delete last ":" fixed the problem for mpv
> #
> Das Erste HD fixed:11494:S1HC23I0M5N1O35:S:22000:5101:5102,5103,5106,5108:0:0:10301:0:0:0
> <SNAP> -----------------------------
> 
> 
> refering to the VDR Wikis ...
> 
> * LinuxTV: http://www.linuxtv.org/vdrwiki/index.php/Syntax_of_channels.conf
> * german comunity Wiki: http://www.vdr-wiki.de/wiki/index.php/Channels.conf#Parameter_ab_VDR-1.7.4
> 
> ... there is no field at position [4] / in between "Source"
> and "SRate" which might have a value ... I suppose the '(null):'
> is the result of pointing to *nothing* ...
> 
> An other mistake is the ending colon (":") at the line. It is not
> explicit specified but adding an collon to the end of an channel
> entry will prevent players (like mpv or mplayer) from parsing the
> line (they will ignore these lines).
> 
> At least: generating a channel list with
> 
>  dvbv5-scan --output-format=vdr ...
> 
> will result in the same defective channel entry, containing
> "(null):" and the leading collon ":".
> 
> If I can help -- e.g. testing -- please contact me.
> 
> Regards
> 
>  --M----
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

