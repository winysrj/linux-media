Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:42481 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754052Ab3GOHcV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jul 2013 03:32:21 -0400
From: oliver+list@schinagl.nl
To: linux-media@vger.kernel.org
Cc: CrazyCat <crazycat69@narod.ru>,
	Oliver Schinagl <oliver@schinagl.nl>
Subject: [PATCH 4/4] New DVB-T2 muxes for Russia, Ukraine.
Date: Mon, 15 Jul 2013 09:28:51 +0200
Message-Id: <1373873331-31829-4-git-send-email-oliver+list@schinagl.nl>
In-Reply-To: <1373873331-31829-1-git-send-email-oliver+list@schinagl.nl>
References: <1373873331-31829-1-git-send-email-oliver+list@schinagl.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: CrazyCat <crazycat69@narod.ru>


Signed-off-by: Oliver Schinagl <oliver@schinagl.nl>
---
 dvb-t/ru-Krasnodar   | 6 ++++++
 dvb-t/ru-Novosibirsk | 2 +-
 dvb-t/ru-Volgodonsk  | 6 ++++++
 dvb-t/ua-Kharkov     | 2 +-
 dvb-t/ua-Kiev        | 6 ++++++
 dvb-t/ua-Lozovaya    | 2 +-
 dvb-t/ua-Odessa      | 6 ++++++
 7 files changed, 27 insertions(+), 3 deletions(-)
 create mode 100644 dvb-t/ru-Krasnodar
 create mode 100644 dvb-t/ru-Volgodonsk
 create mode 100644 dvb-t/ua-Kiev
 create mode 100644 dvb-t/ua-Odessa

diff --git a/dvb-t/ru-Krasnodar b/dvb-t/ru-Krasnodar
new file mode 100644
index 0000000..51d58d0
--- /dev/null
+++ b/dvb-t/ru-Krasnodar
@@ -0,0 +1,6 @@
+# Russia, Krasnodar
+# std freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy plp_id
+T2 618000000 8MHz 4/5 NONE QAM64 32k AUTO NONE 0
+T2 618000000 8MHz 4/5 NONE QAM64 32k AUTO NONE 1
+T2 618000000 8MHz 4/5 NONE QAM64 32k AUTO NONE 2
+T2 618000000 8MHz 4/5 NONE QAM64 32k AUTO NONE 3
diff --git a/dvb-t/ru-Novosibirsk b/dvb-t/ru-Novosibirsk
index 8e88c21..443c7e4 100644
--- a/dvb-t/ru-Novosibirsk
+++ b/dvb-t/ru-Novosibirsk
@@ -1,5 +1,5 @@
 # Russia, Novosibirsk
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# std freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy plp_id
 T2 530000000 8MHz 4/5 NONE QAM64 32k AUTO NONE 0
 T2 530000000 8MHz 4/5 NONE QAM64 32k AUTO NONE 1
 T2 530000000 8MHz 4/5 NONE QAM64 32k AUTO NONE 2
diff --git a/dvb-t/ru-Volgodonsk b/dvb-t/ru-Volgodonsk
new file mode 100644
index 0000000..2089a70
--- /dev/null
+++ b/dvb-t/ru-Volgodonsk
@@ -0,0 +1,6 @@
+# Russia, Volgodonsk
+# std freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy plp_id
+T2 650000000 8MHz 4/5 NONE QAM64 32k AUTO NONE 0
+T2 650000000 8MHz 4/5 NONE QAM64 32k AUTO NONE 1
+T2 650000000 8MHz 4/5 NONE QAM64 32k AUTO NONE 2
+T2 650000000 8MHz 4/5 NONE QAM64 32k AUTO NONE 3
diff --git a/dvb-t/ua-Kharkov b/dvb-t/ua-Kharkov
index 8c1cc65..c206c90 100644
--- a/dvb-t/ua-Kharkov
+++ b/dvb-t/ua-Kharkov
@@ -1,5 +1,5 @@
 # Ukraine, Kharkov
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# std freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy plp_id
 T2 554000000 8MHz 3/5 NONE QAM256 32k 1/16 NONE
 T2 586000000 8MHz 3/5 NONE QAM256 32k 1/16 NONE
 T2 690000000 8MHz 3/5 NONE QAM256 32k 1/16 NONE
diff --git a/dvb-t/ua-Kiev b/dvb-t/ua-Kiev
new file mode 100644
index 0000000..6db2d56
--- /dev/null
+++ b/dvb-t/ua-Kiev
@@ -0,0 +1,6 @@
+# Ukraine, Kiev
+# std freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy plp_id
+T2 526000000 8MHz 3/5 NONE QAM256 32k 1/16 NONE
+T2 538000000 8MHz 3/5 NONE QAM256 32k 1/16 NONE
+T2 554000000 8MHz 3/5 NONE QAM256 32k 1/16 NONE
+T2 698000000 8MHz 3/5 NONE QAM256 32k 1/16 NONE
diff --git a/dvb-t/ua-Lozovaya b/dvb-t/ua-Lozovaya
index c2d2378..a0bfc09 100644
--- a/dvb-t/ua-Lozovaya
+++ b/dvb-t/ua-Lozovaya
@@ -1,5 +1,5 @@
 # Ukraine, Lozovaya
-# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+# std freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy plp_id
 T2 554000000 8MHz 3/5 NONE QAM256 32k 1/16 NONE
 T2 746000000 8MHz 3/5 NONE QAM256 32k 1/16 NONE
 T2 754000000 8MHz 3/5 NONE QAM256 32k 1/16 NONE
diff --git a/dvb-t/ua-Odessa b/dvb-t/ua-Odessa
new file mode 100644
index 0000000..2420279
--- /dev/null
+++ b/dvb-t/ua-Odessa
@@ -0,0 +1,6 @@
+# Ukraine, Odessa
+# std freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy plp_id
+T2 490000000 8MHz 3/5 NONE QAM256 32k 1/16 NONE
+T2 562000000 8MHz 3/5 NONE QAM256 32k 1/16 NONE
+T2 618000000 8MHz 3/5 NONE QAM256 32k 1/16 NONE
+T2 650000000 8MHz 3/5 NONE QAM256 32k 1/16 NONE
-- 
1.8.1.5

