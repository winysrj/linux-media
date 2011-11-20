Return-path: <linux-media-owner@vger.kernel.org>
Received: from urchin.earth.li ([212.13.204.73]:36556 "EHLO urchin.earth.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752561Ab1KTSMM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Nov 2011 13:12:12 -0500
Received: from nick (helo=localhost)
	by urchin.earth.li with local-esmtp (Exim 4.72)
	(envelope-from <v4l@gagravarr.org>)
	id 1RSBXO-0000sh-H1
	for linux-media@vger.kernel.org; Sun, 20 Nov 2011 17:50:42 +0000
Date: Sun, 20 Nov 2011 17:50:42 +0000 (GMT)
From: Nick Burch <v4l@gagravarr.org>
To: linux-media@vger.kernel.org
Subject: [PATCH] Update dvb-t scan frequencies for uk-Oxford, following
 digital switchover
Message-ID: <alpine.DEB.2.00.1111201746210.32047@urchin.earth.li>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All

The scan channels file in dvb-apps/util/scan/dvb-t/uk-Oxford needs to be 
updated with the new frequencies for Oxford, UK, following the digital 
switchover here that happend a short time ago.

Based on some public information, w_scan and some trial+error, I believe 
the patch below will update the file to the new frequencies

Cheers
Nick

------------

--- a/util/scan/dvb-t/uk-Oxford	Fri Oct 07 01:26:04 2011 +0530
+++ b/util/scan/dvb-t/uk-Oxford	Sun Nov 20 17:44:17 2011 +0000
@@ -1,10 +1,26 @@
  # UK, Oxford
-# Auto-generated from http://www.dtg.org.uk/retailer/dtt_channels.html
-# and http://www.ofcom.org.uk/static/reception_advice/index.asp.html
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 578000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE
-T 850000000 8MHz 2/3 NONE QAM64 2k 1/32 NONE
+#
+# Post-Switchover, found from a mixture of w_scan, trial+error
+# and http://www.ukfree.tv/txdetail.php?a=SP567105
+
+# Local Channels, C51, details still TBA
  T 713833000 8MHz 2/3 NONE QAM64 2k 1/32 NONE
-T 721833000 8MHz 3/4 NONE QAM16 2k 1/32 NONE
-T 690000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE
-T 538000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE
+
+# PSB1 BBC-A, C53+. Apparently 730.2 but actually looks to be 730.167
+T 730167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
+
+# ArqB (COM6), C55, 746.0
+T 746000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
+
+# PSB3 BBC-B, C57, 256QAM DVB-T2, TBA
+# May well be wrong, needs a DVB-T2 tuner to be sure!
+T 762000000 8MHz 2/3 NONE QAM256 8k 1/32 NONE
+
+# ArqA (COM5), C59-, Apparently 777.8 but actually looks to be 777.833
+T 777833000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
+
+# PSB2, D3+4, C60-, Apparently 785.0 but actually looks to be 785.833
+T 785833000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
+
+# SDN (COM4), C62, 802.0
+T 802000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE

------------

