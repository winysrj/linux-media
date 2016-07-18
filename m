Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59575 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbcGRSau (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 14:30:50 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Kees Cook <keescook@chromium.org>, linux-doc@vger.kernel.org
Subject: [PATCH 14/18] [media] cx88.rst: add contents from not-in-cx2388x-datasheet.txt
Date: Mon, 18 Jul 2016 15:30:36 -0300
Message-Id: <2b8de4eabc41ef702ba381a4aa14e3a21b75254e.1468865380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468865380.git.mchehab@s-opensource.com>
References: <cover.1468865380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468865380.git.mchehab@s-opensource.com>
References: <cover.1468865380.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are some information about missing/wrong documentation at
cx231xx datasheet. Add it to the cx88 chapter.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/v4l-drivers/cx88.rst           | 42 ++++++++++++++++++++++
 .../video4linux/not-in-cx2388x-datasheet.txt       | 41 ---------------------
 2 files changed, 42 insertions(+), 41 deletions(-)
 delete mode 100644 Documentation/video4linux/not-in-cx2388x-datasheet.txt

diff --git a/Documentation/media/v4l-drivers/cx88.rst b/Documentation/media/v4l-drivers/cx88.rst
index ac83292776da..c89dbfa5f9d6 100644
--- a/Documentation/media/v4l-drivers/cx88.rst
+++ b/Documentation/media/v4l-drivers/cx88.rst
@@ -55,4 +55,46 @@ the driver.  What to do then?
        know which one the card has you can also have a look at the
        list in CARDLIST.tuner
 
+Documentation missing at the cx88 datasheet
+-------------------------------------------
 
+MO_OUTPUT_FORMAT (0x310164)
+
+.. code-block:: none
+
+  Previous default from DScaler: 0x1c1f0008
+  Digit 8: 31-28
+  28: PREVREMOD = 1
+
+  Digit 7: 27-24 (0xc = 12 = b1100 )
+  27: COMBALT = 1
+  26: PAL_INV_PHASE
+    (DScaler apparently set this to 1, resulted in sucky picture)
+
+  Digits 6,5: 23-16
+  25-16: COMB_RANGE = 0x1f [default] (9 bits -> max 512)
+
+  Digit 4: 15-12
+  15: DISIFX = 0
+  14: INVCBF = 0
+  13: DISADAPT = 0
+  12: NARROWADAPT = 0
+
+  Digit 3: 11-8
+  11: FORCE2H
+  10: FORCEREMD
+  9: NCHROMAEN
+  8: NREMODEN
+
+  Digit 2: 7-4
+  7-6: YCORE
+  5-4: CCORE
+
+  Digit 1: 3-0
+  3: RANGE = 1
+  2: HACTEXT
+  1: HSFMT
+
+0x47 is the sync byte for MPEG-2 transport stream packets.
+Datasheet incorrectly states to use 47 decimal. 188 is the length.
+All DVB compliant frontends output packets with this start code.
diff --git a/Documentation/video4linux/not-in-cx2388x-datasheet.txt b/Documentation/video4linux/not-in-cx2388x-datasheet.txt
deleted file mode 100644
index edbfe744d21d..000000000000
--- a/Documentation/video4linux/not-in-cx2388x-datasheet.txt
+++ /dev/null
@@ -1,41 +0,0 @@
-=================================================================================
-MO_OUTPUT_FORMAT (0x310164)
-
-  Previous default from DScaler: 0x1c1f0008
-  Digit 8: 31-28
-  28: PREVREMOD = 1
-
-  Digit 7: 27-24 (0xc = 12 = b1100 )
-  27: COMBALT = 1
-  26: PAL_INV_PHASE
-    (DScaler apparently set this to 1, resulted in sucky picture)
-
-  Digits 6,5: 23-16
-  25-16: COMB_RANGE = 0x1f [default] (9 bits -> max 512)
-
-  Digit 4: 15-12
-  15: DISIFX = 0
-  14: INVCBF = 0
-  13: DISADAPT = 0
-  12: NARROWADAPT = 0
-
-  Digit 3: 11-8
-  11: FORCE2H
-  10: FORCEREMD
-  9: NCHROMAEN
-  8: NREMODEN
-
-  Digit 2: 7-4
-  7-6: YCORE
-  5-4: CCORE
-
-  Digit 1: 3-0
-  3: RANGE = 1
-  2: HACTEXT
-  1: HSFMT
-
-0x47 is the sync byte for MPEG-2 transport stream packets.
-Datasheet incorrectly states to use 47 decimal. 188 is the length.
-All DVB compliant frontends output packets with this start code.
-
-=================================================================================
-- 
2.7.4


