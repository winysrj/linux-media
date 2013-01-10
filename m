Return-path: <linux-media-owner@vger.kernel.org>
Received: from fep33.mx.upcmail.net ([62.179.121.51]:53060 "EHLO
	fep33.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932282Ab3AJCV2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2013 21:21:28 -0500
From: Jonathan McCrohan <jmccrohan@gmail.com>
To: Oliver Schinagl <oliver@schinagl.nl>
Cc: linux-media@vger.kernel.org,
	Jonathan McCrohan <jmccrohan@gmail.com>
Subject: [PATCH 1/2] update scan files for Ireland (ie-*)
Date: Thu, 10 Jan 2013 01:54:23 +0000
Message-Id: <1357782864-9255-2-git-send-email-jmccrohan@gmail.com>
In-Reply-To: <1357782864-9255-1-git-send-email-jmccrohan@gmail.com>
References: <1357782864-9255-1-git-send-email-jmccrohan@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ASO frequency changes; effective 24th Oct 2012.

Signed-off-by: Jonathan McCrohan <jmccrohan@gmail.com>
---
 dvb-t/ie-CairnHill     |    2 +-
 dvb-t/ie-ClermontCarn  |    6 +++---
 dvb-t/ie-Dungarvan     |    2 +-
 dvb-t/ie-HolywellHill  |    4 ++--
 dvb-t/ie-Kippure       |    2 +-
 dvb-t/ie-Maghera       |    2 +-
 dvb-t/ie-MountLeinster |    6 +++---
 dvb-t/ie-Mullaghanish  |    2 +-
 dvb-t/ie-SpurHill      |    2 +-
 dvb-t/ie-ThreeRock     |    6 +++---
 dvb-t/ie-Truskmore     |    2 +-
 dvb-t/ie-WoodcockHill  |    2 +-
 12 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/dvb-t/ie-CairnHill b/dvb-t/ie-CairnHill
index 002881a..5063ce9 100644
--- a/dvb-t/ie-CairnHill
+++ b/dvb-t/ie-CairnHill
@@ -1,5 +1,5 @@
 # Ireland, Cairn Hill
-# Generated from http://www.comreg.ie/_fileupload/File/Technical%20Parameters_20111004.xlsx
+# Generated from http://www.comreg.ie/_fileupload/Broadcast_Technical_Parameters.xlsx 
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 682000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH47: Saorview MUX1
 T 658000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH44: Saorview MUX2
diff --git a/dvb-t/ie-ClermontCarn b/dvb-t/ie-ClermontCarn
index 680ffce..df9d06b 100644
--- a/dvb-t/ie-ClermontCarn
+++ b/dvb-t/ie-ClermontCarn
@@ -1,5 +1,5 @@
 # Ireland, Clermont Carn
-# Generated from http://www.comreg.ie/_fileupload/File/Technical%20Parameters_20111004.xlsx
+# Generated from http://www.comreg.ie/_fileupload/Broadcast_Technical_Parameters.xlsx 
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 730000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH53: Saorview MUX1
-T 762000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH57: Saorview MUX2
+T 722000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH52: Saorview MUX1
+T 754000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH56: Saorview MUX2
diff --git a/dvb-t/ie-Dungarvan b/dvb-t/ie-Dungarvan
index 7f5d6a3..5bdf714 100644
--- a/dvb-t/ie-Dungarvan
+++ b/dvb-t/ie-Dungarvan
@@ -1,5 +1,5 @@
 # Ireland, Dungarvan
-# Generated from http://www.comreg.ie/_fileupload/File/Technical%20Parameters_20111004.xlsx
+# Generated from http://www.comreg.ie/_fileupload/Broadcast_Technical_Parameters.xlsx
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 746000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH55: Saorview MUX1
 T 778000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH59: Saorview MUX2
diff --git a/dvb-t/ie-HolywellHill b/dvb-t/ie-HolywellHill
index 4557ec1..a3f55be 100644
--- a/dvb-t/ie-HolywellHill
+++ b/dvb-t/ie-HolywellHill
@@ -1,5 +1,5 @@
 # Ireland, Holywell Hill
-# Generated from http://www.comreg.ie/_fileupload/File/Technical%20Parameters_20111004.xlsx
+# Generated from http://www.comreg.ie/_fileupload/Broadcast_Technical_Parameters.xlsx 
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 546000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH30: Saorview MUX1
-T 506000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH25: Saorview MUX2
+T 570000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH33: Saorview MUX2
diff --git a/dvb-t/ie-Kippure b/dvb-t/ie-Kippure
index 723f7be..aeb5d8d 100644
--- a/dvb-t/ie-Kippure
+++ b/dvb-t/ie-Kippure
@@ -1,5 +1,5 @@
 # Ireland, Kippure
-# Generated from http://www.comreg.ie/_fileupload/File/Technical%20Parameters_20111004.xlsx
+# Generated from http://www.comreg.ie/_fileupload/Broadcast_Technical_Parameters.xlsx 
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 738000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH54: Saorview MUX1
 T 770000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH58: Saorview MUX2
diff --git a/dvb-t/ie-Maghera b/dvb-t/ie-Maghera
index 8144c38..a1da82a 100644
--- a/dvb-t/ie-Maghera
+++ b/dvb-t/ie-Maghera
@@ -1,5 +1,5 @@
 # Ireland, Maghera
-# Generated from http://www.comreg.ie/_fileupload/File/Technical%20Parameters_20111004.xlsx
+# Generated from http://www.comreg.ie/_fileupload/Broadcast_Technical_Parameters.xlsx
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 690000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH48: Saorview MUX1
 T 746000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH55: Saorview MUX2
diff --git a/dvb-t/ie-MountLeinster b/dvb-t/ie-MountLeinster
index 780ac0a..e5515c2 100644
--- a/dvb-t/ie-MountLeinster
+++ b/dvb-t/ie-MountLeinster
@@ -1,5 +1,5 @@
 # Ireland, Mount Leinster
-# Generated from http://www.comreg.ie/_fileupload/File/Technical%20Parameters_20111004.xlsx
+# Generated from http://www.comreg.ie/_fileupload/Broadcast_Technical_Parameters.xlsx
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 666000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH45: Saorview MUX1
-T 618000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH39: Saorview MUX2
+T 490000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH23: Saorview MUX1
+T 514000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH26: Saorview MUX2
diff --git a/dvb-t/ie-Mullaghanish b/dvb-t/ie-Mullaghanish
index aae3e97..73e6ffe 100644
--- a/dvb-t/ie-Mullaghanish
+++ b/dvb-t/ie-Mullaghanish
@@ -1,5 +1,5 @@
 # Ireland, Mullaghanish
-# Generated from http://www.comreg.ie/_fileupload/File/Technical%20Parameters_20111004.xlsx
+# Generated from http://www.comreg.ie/_fileupload/Broadcast_Technical_Parameters.xlsx 
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 474000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH21: Saorview MUX1
 T 498000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH24: Saorview MUX2
diff --git a/dvb-t/ie-SpurHill b/dvb-t/ie-SpurHill
index e8db8a5..a211e93 100644
--- a/dvb-t/ie-SpurHill
+++ b/dvb-t/ie-SpurHill
@@ -1,5 +1,5 @@
 # Ireland, Spur Hill
-# Generated from http://www.comreg.ie/_fileupload/File/Technical%20Parameters_20111004.xlsx
+# Generated from http://www.comreg.ie/_fileupload/Broadcast_Technical_Parameters.xlsx
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 666000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH45: Saorview MUX1
 T 698000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH49: Saorview MUX2
diff --git a/dvb-t/ie-ThreeRock b/dvb-t/ie-ThreeRock
index ba4d43f..ec21a00 100644
--- a/dvb-t/ie-ThreeRock
+++ b/dvb-t/ie-ThreeRock
@@ -1,5 +1,5 @@
 # Ireland, Three Rock
-# Generated from http://www.comreg.ie/_fileupload/File/Technical%20Parameters_20111004.xlsx
+# Generated from http://www.comreg.ie/_fileupload/Broadcast_Technical_Parameters.xlsx
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 738000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH54: Saorview MUX1
-T 770000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH58: Saorview MUX2
+T 546000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH30: Saorview MUX1
+T 570000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH33: Saorview MUX2
diff --git a/dvb-t/ie-Truskmore b/dvb-t/ie-Truskmore
index 2418f16..db71c31 100644
--- a/dvb-t/ie-Truskmore
+++ b/dvb-t/ie-Truskmore
@@ -1,5 +1,5 @@
 # Ireland, Truskmore
-# Generated from http://www.comreg.ie/_fileupload/File/Technical%20Parameters_20111004.xlsx
+# Generated from http://www.comreg.ie/_fileupload/Broadcast_Technical_Parameters.xlsx 
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 730000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH53: Saorview MUX1
 T 762000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH57: Saorview MUX2
diff --git a/dvb-t/ie-WoodcockHill b/dvb-t/ie-WoodcockHill
index 6ca3d15..513dda5 100644
--- a/dvb-t/ie-WoodcockHill
+++ b/dvb-t/ie-WoodcockHill
@@ -1,5 +1,5 @@
 # Ireland, Woodcock Hill
-# Generated from http://www.comreg.ie/_fileupload/File/Technical%20Parameters_20111004.xlsx
+# Generated from http://www.comreg.ie/_fileupload/Broadcast_Technical_Parameters.xlsx 
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 682000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH47: Saorview MUX1
 T 658000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH44: Saorview MUX2
-- 
1.7.10.4

