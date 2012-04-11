Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:60231 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab2DKM6f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Apr 2012 08:58:35 -0400
Received: by dake40 with SMTP id e40so1170236dak.11
        for <linux-media@vger.kernel.org>; Wed, 11 Apr 2012 05:58:34 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 11 Apr 2012 13:58:34 +0100
Message-ID: <CAOQWjw37pfdp89P3qX=y9XS9Dmkw40Dkr+vdhfwosgOd39u87g@mail.gmail.com>
Subject: Updated DVB-T tuning file for uk-SuttonColdfield
From: Nick Morrott <knowledgejunkie@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update as frequencies were changed in September 2011 during UK digital
switchover.


--- a/util/scan/dvb-t/uk-SuttonColdfield	Tue Apr 10 16:44:06 2012 +0200
+++ b/util/scan/dvb-t/uk-SuttonColdfield	Wed Apr 11 13:54:13 2012 +0100
@@ -1,10 +1,13 @@
-# UK, Sutton Coldfield
-# Auto-generated from http://www.dtg.org.uk/retailer/dtt_channels.html
-# and http://www.ofcom.org.uk/static/reception_advice/index.asp.html
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 634167000 8MHz 3/4 NONE QAM16 2k 1/32 NONE
-T 658167000 8MHz 2/3 NONE QAM64 2k 1/32 NONE
-T 682167000 8MHz 2/3 NONE QAM64 2k 1/32 NONE
-T 714167000 8MHz 3/4 NONE QAM16 2k 1/32 NONE
-T 722167000 8MHz 3/4 NONE QAM16 2k 1/32 NONE
-T 746000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE
+#------------------------------------------------------------------------------
+# location and provider: UK, Sutton Coldfield
+# date (yyyy-mm-dd)    : 2012-04-11
+# provided by          : Nick Morrott <knowledgejunkie at gmail dot com>
+#
+# T[2] <freq> <bw> <fec_hi> <fec_lo> <mod> <tm> <guard> <hi> [# comment]
+#------------------------------------------------------------------------------
+T  650000000  8MHz  2/3  NONE  QAM64   8k    1/32  NONE  # PSB1 BBCA
+T  674000000  8MHz  2/3  NONE  QAM64   8k    1/32  NONE  # PSB2 D3+4
+T  642000000  8MHz  2/3  NONE  QAM64   8k    1/32  NONE  # COM4 SDN
+T  618167000  8MHz  3/4  NONE  QAM64   8k    1/32  NONE  # COM6 ArqB
+T  666000000  8MHz  2/3  NONE  QAM64   8k    1/32  NONE  # COM5 ArqA
+T2 626167000  8MHz  2/3  NONE  QAM256  AUTO  AUTO  NONE  # PSB3 BBCB
(needs verifying)



Cheers,
Nick
