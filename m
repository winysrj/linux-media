Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:42472 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754052Ab3GOHcT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jul 2013 03:32:19 -0400
From: oliver+list@schinagl.nl
To: linux-media@vger.kernel.org
Cc: CrazyCat <crazycat69@narod.ru>,
	Oliver Schinagl <oliver@schinagl.nl>
Subject: [PATCH 1/4] Some multistream transponders. Some DVB-T2 muxes for RU and UA.
Date: Mon, 15 Jul 2013 09:28:48 +0200
Message-Id: <1373873331-31829-1-git-send-email-oliver+list@schinagl.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: CrazyCat <crazycat69@narod.ru>


Signed-off-by: Oliver Schinagl <oliver@schinagl.nl>
---
 dvb-s/Astra-31.5E           |  5 +++++
 dvb-s/Atlantic-Bird-1-12.5W |  4 ++++
 dvb-s/Intelsat-12-45.0E     | 10 ++++++++++
 dvb-t/ru-Novosibirsk        |  6 ++++++
 dvb-t/ua-Kharkov            |  6 ++++++
 dvb-t/ua-Lozovaya           |  6 ++++++
 6 files changed, 37 insertions(+)
 create mode 100644 dvb-s/Astra-31.5E
 create mode 100644 dvb-s/Intelsat-12-45.0E
 create mode 100644 dvb-t/ru-Novosibirsk
 create mode 100644 dvb-t/ua-Kharkov
 create mode 100644 dvb-t/ua-Lozovaya

diff --git a/dvb-s/Astra-31.5E b/dvb-s/Astra-31.5E
new file mode 100644
index 0000000..021bbaa
--- /dev/null
+++ b/dvb-s/Astra-31.5E
@@ -0,0 +1,5 @@
+S2 11993000 H 27500000 AUTO AUTO 8PSK 10
+S2 11993000 H 27500000 AUTO AUTO 8PSK 20
+S2 12148000 H 27500000 AUTO AUTO 8PSK 30
+S2 12148000 H 27500000 AUTO AUTO 8PSK 40
+S1 12304000 H 27500000 AUTO AUTO QPSK
diff --git a/dvb-s/Atlantic-Bird-1-12.5W b/dvb-s/Atlantic-Bird-1-12.5W
index 6735d70..f6b7f33 100644
--- a/dvb-s/Atlantic-Bird-1-12.5W
+++ b/dvb-s/Atlantic-Bird-1-12.5W
@@ -26,5 +26,9 @@ S 12604000 H 1481000 3/4
 S 12655000 H 4285000 3/4
 S 12659000 H 2141000 3/4
 S 12662000 V 3928000 3/4
+S2 12718000 H 36510000 AUTO AUTO 8PSK 33
+S2 12718000 H 36510000 AUTO AUTO 8PSK 34
+S2 12718000 H 36510000 AUTO AUTO 8PSK 35
+S2 12718000 H 36510000 AUTO AUTO 8PSK 36
 S 12720000 V 1808000 3/4
 S 12743000 V 3214000 3/4
diff --git a/dvb-s/Intelsat-12-45.0E b/dvb-s/Intelsat-12-45.0E
new file mode 100644
index 0000000..555beb5
--- /dev/null
+++ b/dvb-s/Intelsat-12-45.0E
@@ -0,0 +1,10 @@
+S2 11469000 V 30000000 3/4 20 8PSK
+S2 11496000 V 7299000 2/3 20 8PSK
+S1 11518000 V 2959000 7/8 35 QPSK
+S1 11524000 V 5787000 3/4 35 QPSK
+S2 11551000 V 30000000 3/4 20 8PSK
+S2 11592000 V 30000000 3/4 20 8PSK 2
+S2 11592000 V 30000000 3/4 20 8PSK 3
+S2 11592000 V 30000000 3/4 20 8PSK 4
+S2 11633000 V 30000000 3/4 20 8PSK
+S2 11674000 V 30000000 3/4 20 8PSK
diff --git a/dvb-t/ru-Novosibirsk b/dvb-t/ru-Novosibirsk
new file mode 100644
index 0000000..8e88c21
--- /dev/null
+++ b/dvb-t/ru-Novosibirsk
@@ -0,0 +1,6 @@
+# Russia, Novosibirsk
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T2 530000000 8MHz 4/5 NONE QAM64 32k AUTO NONE 0
+T2 530000000 8MHz 4/5 NONE QAM64 32k AUTO NONE 1
+T2 530000000 8MHz 4/5 NONE QAM64 32k AUTO NONE 2
+T2 530000000 8MHz 4/5 NONE QAM64 32k AUTO NONE 3
diff --git a/dvb-t/ua-Kharkov b/dvb-t/ua-Kharkov
new file mode 100644
index 0000000..8c1cc65
--- /dev/null
+++ b/dvb-t/ua-Kharkov
@@ -0,0 +1,6 @@
+# Ukraine, Kharkov
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T2 554000000 8MHz 3/5 NONE QAM256 32k 1/16 NONE
+T2 586000000 8MHz 3/5 NONE QAM256 32k 1/16 NONE
+T2 690000000 8MHz 3/5 NONE QAM256 32k 1/16 NONE
+T2 770000000 8MHz 3/5 NONE QAM256 32k 1/16 NONE
diff --git a/dvb-t/ua-Lozovaya b/dvb-t/ua-Lozovaya
new file mode 100644
index 0000000..c2d2378
--- /dev/null
+++ b/dvb-t/ua-Lozovaya
@@ -0,0 +1,6 @@
+# Ukraine, Lozovaya
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T2 554000000 8MHz 3/5 NONE QAM256 32k 1/16 NONE
+T2 746000000 8MHz 3/5 NONE QAM256 32k 1/16 NONE
+T2 754000000 8MHz 3/5 NONE QAM256 32k 1/16 NONE
+T2 778000000 8MHz 3/5 NONE QAM256 32k 1/16 NONE
-- 
1.8.1.5

