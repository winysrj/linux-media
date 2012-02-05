Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:64062 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613Ab2BECVK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Feb 2012 21:21:10 -0500
Received: by werb13 with SMTP id b13so3546062wer.19
        for <linux-media@vger.kernel.org>; Sat, 04 Feb 2012 18:21:09 -0800 (PST)
Message-ID: <4F2DE790.9080805@gmail.com>
Date: Sun, 05 Feb 2012 02:21:04 +0000
From: Jonathan McCrohan <jmccrohan@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: dvb-apps: add scan files for Ireland (ie-*)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

# HG changeset patch
# User Jonathan McCrohan <jmccrohan@gmail.com>
# Date 1328407970 0
# Node ID 068772e2c579c9e8c32c81d2e7b5b6978e6afe7f
# Parent  69fc03702a6489ae46c50a3a5514df714d3832e8
add scan files for Ireland (ie-*)

Signed-off-by: Jonathan McCrohan <jmccrohan@gmail.com>

diff -r 69fc03702a64 -r 068772e2c579 util/scan/dvb-t/ie-CairnHill
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/ie-CairnHill	Sun Feb 05 02:12:50 2012 +0000
@@ -0,0 +1,4 @@
+# Ireland, Cairn Hill
+# Generated from http://www.rtenl.ie/wp-content/uploads/2011/12/SAORVIEW-Frequencies-Rev-1.0.pdf
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 682000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH47: Saorview
diff -r 69fc03702a64 -r 068772e2c579 util/scan/dvb-t/ie-ClermontCarn
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/ie-ClermontCarn	Sun Feb 05 02:12:50 2012 +0000
@@ -0,0 +1,4 @@
+# Ireland, Clermont Carn
+# Generated from http://www.rtenl.ie/wp-content/uploads/2011/12/SAORVIEW-Frequencies-Rev-1.0.pdf
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 730000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH53: Saorview
diff -r 69fc03702a64 -r 068772e2c579 util/scan/dvb-t/ie-Dungarvan
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/ie-Dungarvan	Sun Feb 05 02:12:50 2012 +0000
@@ -0,0 +1,4 @@
+# Ireland, Dungarvan
+# Generated from http://www.rtenl.ie/wp-content/uploads/2011/12/SAORVIEW-Frequencies-Rev-1.0.pdf
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 746000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH55: Saorview
diff -r 69fc03702a64 -r 068772e2c579 util/scan/dvb-t/ie-HolywellHill
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/ie-HolywellHill	Sun Feb 05 02:12:50 2012 +0000
@@ -0,0 +1,4 @@
+# Ireland, Holywell Hill
+# Generated from http://www.rtenl.ie/wp-content/uploads/2011/12/SAORVIEW-Frequencies-Rev-1.0.pdf
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 546000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH30: Saorview
diff -r 69fc03702a64 -r 068772e2c579 util/scan/dvb-t/ie-Kippure
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/ie-Kippure	Sun Feb 05 02:12:50 2012 +0000
@@ -0,0 +1,4 @@
+# Ireland, Kippure
+# Generated from http://www.rtenl.ie/wp-content/uploads/2011/12/SAORVIEW-Frequencies-Rev-1.0.pdf
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 738000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH54: Saorview
diff -r 69fc03702a64 -r 068772e2c579 util/scan/dvb-t/ie-Maghera
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/ie-Maghera	Sun Feb 05 02:12:50 2012 +0000
@@ -0,0 +1,4 @@
+# Ireland, Maghera 
+# Generated from http://www.rtenl.ie/wp-content/uploads/2011/12/SAORVIEW-Frequencies-Rev-1.0.pdf
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 690000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH48: Saorview
diff -r 69fc03702a64 -r 068772e2c579 util/scan/dvb-t/ie-MountLeinster
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/ie-MountLeinster	Sun Feb 05 02:12:50 2012 +0000
@@ -0,0 +1,4 @@
+# Ireland, Mount Leinster 
+# Generated from http://www.rtenl.ie/wp-content/uploads/2011/12/SAORVIEW-Frequencies-Rev-1.0.pdf
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 666000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH45: Saorview
diff -r 69fc03702a64 -r 068772e2c579 util/scan/dvb-t/ie-Mullaghanish
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/ie-Mullaghanish	Sun Feb 05 02:12:50 2012 +0000
@@ -0,0 +1,4 @@
+# Ireland, Mullaghanish 
+# Generated from http://www.rtenl.ie/wp-content/uploads/2011/12/SAORVIEW-Frequencies-Rev-1.0.pdf
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 474000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH21: Saorview
diff -r 69fc03702a64 -r 068772e2c579 util/scan/dvb-t/ie-SpurHill
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/ie-SpurHill	Sun Feb 05 02:12:50 2012 +0000
@@ -0,0 +1,4 @@
+# Ireland, Spur Hill 
+# Generated from http://www.rtenl.ie/wp-content/uploads/2011/12/SAORVIEW-Frequencies-Rev-1.0.pdf
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 666000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH45: Saorview
diff -r 69fc03702a64 -r 068772e2c579 util/scan/dvb-t/ie-ThreeRock
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/ie-ThreeRock	Sun Feb 05 02:12:50 2012 +0000
@@ -0,0 +1,4 @@
+# Ireland, Three Rock
+# Generated from http://www.rtenl.ie/wp-content/uploads/2011/12/SAORVIEW-Frequencies-Rev-1.0.pdf
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 738000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH54: Saorview
diff -r 69fc03702a64 -r 068772e2c579 util/scan/dvb-t/ie-Truskmore
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/ie-Truskmore	Sun Feb 05 02:12:50 2012 +0000
@@ -0,0 +1,4 @@
+# Ireland, Truskmore
+# Generated from http://www.rtenl.ie/wp-content/uploads/2011/12/SAORVIEW-Frequencies-Rev-1.0.pdf
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 730000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH53: Saorview
diff -r 69fc03702a64 -r 068772e2c579 util/scan/dvb-t/ie-WoodcockHill
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/scan/dvb-t/ie-WoodcockHill	Sun Feb 05 02:12:50 2012 +0000
@@ -0,0 +1,4 @@
+# Ireland, Woodcock Hill
+# Generated from http://www.rtenl.ie/wp-content/uploads/2011/12/SAORVIEW-Frequencies-Rev-1.0.pdf
+# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
+T 682000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE # CH47: Saorview
