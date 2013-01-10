Return-path: <linux-media-owner@vger.kernel.org>
Received: from fep33.mx.upcmail.net ([62.179.121.51]:53060 "EHLO
	fep33.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932168Ab3AJCVZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2013 21:21:25 -0500
From: Jonathan McCrohan <jmccrohan@gmail.com>
To: Oliver Schinagl <oliver@schinagl.nl>
Cc: linux-media@vger.kernel.org,
	Jonathan McCrohan <jmccrohan@gmail.com>
Subject: [PATCH 2/2] update scan files for Ireland (ie-*)
Date: Thu, 10 Jan 2013 01:54:24 +0000
Message-Id: <1357782864-9255-3-git-send-email-jmccrohan@gmail.com>
In-Reply-To: <1357782864-9255-1-git-send-email-jmccrohan@gmail.com>
References: <1357782864-9255-1-git-send-email-jmccrohan@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix erroneous transmission parameters

Signed-off-by: Jonathan McCrohan <jmccrohan@gmail.com>
---
 dvb-t/ie-CairnHill    |    4 ++--
 dvb-t/ie-Dungarvan    |    4 ++--
 dvb-t/ie-Kippure      |    4 ++--
 dvb-t/ie-Maghera      |    4 ++--
 dvb-t/ie-Mullaghanish |    4 ++--
 dvb-t/ie-SpurHill     |    4 ++--
 dvb-t/ie-Truskmore    |    4 ++--
 dvb-t/ie-WoodcockHill |    4 ++--
 8 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/dvb-t/ie-CairnHill b/dvb-t/ie-CairnHill
index 5063ce9..b36272f 100644
--- a/dvb-t/ie-CairnHill
+++ b/dvb-t/ie-CairnHill
@@ -1,5 +1,5 @@
 # Ireland, Cairn Hill
 # Generated from http://www.comreg.ie/_fileupload/Broadcast_Technical_Parameters.xlsx 
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 682000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH47: Saorview MUX1
-T 658000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH44: Saorview MUX2
+T 682000000 8MHz 3/4 NONE QAM64 8k 1/32 NONE # CH47: Saorview MUX1
+T 658000000 8MHz 3/4 NONE QAM64 8k 1/32 NONE # CH44: Saorview MUX2
diff --git a/dvb-t/ie-Dungarvan b/dvb-t/ie-Dungarvan
index 5bdf714..f415097 100644
--- a/dvb-t/ie-Dungarvan
+++ b/dvb-t/ie-Dungarvan
@@ -1,5 +1,5 @@
 # Ireland, Dungarvan
 # Generated from http://www.comreg.ie/_fileupload/Broadcast_Technical_Parameters.xlsx
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 746000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH55: Saorview MUX1
-T 778000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH59: Saorview MUX2
+T 746000000 8MHz 3/4 NONE QAM64 8k 1/32 NONE # CH55: Saorview MUX1
+T 778000000 8MHz 3/4 NONE QAM64 8k 1/32 NONE # CH59: Saorview MUX2
diff --git a/dvb-t/ie-Kippure b/dvb-t/ie-Kippure
index aeb5d8d..56ad12a 100644
--- a/dvb-t/ie-Kippure
+++ b/dvb-t/ie-Kippure
@@ -1,5 +1,5 @@
 # Ireland, Kippure
 # Generated from http://www.comreg.ie/_fileupload/Broadcast_Technical_Parameters.xlsx 
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 738000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH54: Saorview MUX1
-T 770000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH58: Saorview MUX2
+T 738000000 8MHz 3/4 NONE QAM64 8k 1/32 NONE # CH54: Saorview MUX1
+T 770000000 8MHz 3/4 NONE QAM64 8k 1/32 NONE # CH58: Saorview MUX2
diff --git a/dvb-t/ie-Maghera b/dvb-t/ie-Maghera
index a1da82a..11c08b7 100644
--- a/dvb-t/ie-Maghera
+++ b/dvb-t/ie-Maghera
@@ -1,5 +1,5 @@
 # Ireland, Maghera
 # Generated from http://www.comreg.ie/_fileupload/Broadcast_Technical_Parameters.xlsx
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 690000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH48: Saorview MUX1
-T 746000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH55: Saorview MUX2
+T 690000000 8MHz 3/4 NONE QAM64 8k 1/32 NONE # CH48: Saorview MUX1
+T 746000000 8MHz 3/4 NONE QAM64 8k 1/32 NONE # CH55: Saorview MUX2
diff --git a/dvb-t/ie-Mullaghanish b/dvb-t/ie-Mullaghanish
index 73e6ffe..35dc5dd 100644
--- a/dvb-t/ie-Mullaghanish
+++ b/dvb-t/ie-Mullaghanish
@@ -1,5 +1,5 @@
 # Ireland, Mullaghanish
 # Generated from http://www.comreg.ie/_fileupload/Broadcast_Technical_Parameters.xlsx 
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 474000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH21: Saorview MUX1
-T 498000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH24: Saorview MUX2
+T 474000000 8MHz 3/4 NONE QAM64 8k 1/32 NONE # CH21: Saorview MUX1
+T 498000000 8MHz 3/4 NONE QAM64 8k 1/32 NONE # CH24: Saorview MUX2
diff --git a/dvb-t/ie-SpurHill b/dvb-t/ie-SpurHill
index a211e93..7566d82 100644
--- a/dvb-t/ie-SpurHill
+++ b/dvb-t/ie-SpurHill
@@ -1,5 +1,5 @@
 # Ireland, Spur Hill
 # Generated from http://www.comreg.ie/_fileupload/Broadcast_Technical_Parameters.xlsx
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 666000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH45: Saorview MUX1
-T 698000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH49: Saorview MUX2
+T 666000000 8MHz 3/4 NONE QAM64 8k 1/32 NONE # CH45: Saorview MUX1
+T 698000000 8MHz 3/4 NONE QAM64 8k 1/32 NONE # CH49: Saorview MUX2
diff --git a/dvb-t/ie-Truskmore b/dvb-t/ie-Truskmore
index db71c31..178bfe3 100644
--- a/dvb-t/ie-Truskmore
+++ b/dvb-t/ie-Truskmore
@@ -1,5 +1,5 @@
 # Ireland, Truskmore
 # Generated from http://www.comreg.ie/_fileupload/Broadcast_Technical_Parameters.xlsx 
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 730000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH53: Saorview MUX1
-T 762000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH57: Saorview MUX2
+T 730000000 8MHz 3/4 NONE QAM64 8k 1/32 NONE # CH53: Saorview MUX1
+T 762000000 8MHz 3/4 NONE QAM64 8k 1/32 NONE # CH57: Saorview MUX2
diff --git a/dvb-t/ie-WoodcockHill b/dvb-t/ie-WoodcockHill
index 513dda5..08c1d5b 100644
--- a/dvb-t/ie-WoodcockHill
+++ b/dvb-t/ie-WoodcockHill
@@ -1,5 +1,5 @@
 # Ireland, Woodcock Hill
 # Generated from http://www.comreg.ie/_fileupload/Broadcast_Technical_Parameters.xlsx 
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 682000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH47: Saorview MUX1
-T 658000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH44: Saorview MUX2
+T 682000000 8MHz 3/4 NONE QAM64 8k 1/32 NONE # CH47: Saorview MUX1
+T 658000000 8MHz 3/4 NONE QAM64 8k 1/32 NONE # CH44: Saorview MUX2
-- 
1.7.10.4

