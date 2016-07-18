Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59540 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbcGRSar (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 14:30:47 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 03/18] [media] doc-rst: add documentation for tuners
Date: Mon, 18 Jul 2016 15:30:25 -0300
Message-Id: <d197a370d88846a4103966a8e224cd9cc9f5278f.1468865380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468865380.git.mchehab@s-opensource.com>
References: <cover.1468865380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468865380.git.mchehab@s-opensource.com>
References: <cover.1468865380.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert bttv/Tuners to ReST and add it to the media/v4l-drivers book.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/v4l-drivers/index.rst  |  1 +
 Documentation/media/v4l-drivers/tuners.rst | 90 ++++++++++++++++++------------
 2 files changed, 54 insertions(+), 37 deletions(-)

diff --git a/Documentation/media/v4l-drivers/index.rst b/Documentation/media/v4l-drivers/index.rst
index 6cb19b24271e..53bc53c948ab 100644
--- a/Documentation/media/v4l-drivers/index.rst
+++ b/Documentation/media/v4l-drivers/index.rst
@@ -21,6 +21,7 @@ License".
 
 	fourcc
 	v4l-with-ir
+	tuners
 	cardlist
 	bttv
 	cafe_ccic
diff --git a/Documentation/media/v4l-drivers/tuners.rst b/Documentation/media/v4l-drivers/tuners.rst
index 0a371d349542..c3e8a1cf64a6 100644
--- a/Documentation/media/v4l-drivers/tuners.rst
+++ b/Documentation/media/v4l-drivers/tuners.rst
@@ -1,19 +1,26 @@
-1) Tuner Programming
-====================
+Tuner drivers
+=============
+
+Simple tuner Programming
+------------------------
+
 There are some flavors of Tuner programming APIs.
 These differ mainly by the bandswitch byte.
 
-    L= LG_API       (VHF_LO=0x01, VHF_HI=0x02, UHF=0x08, radio=0x04)
-    P= PHILIPS_API  (VHF_LO=0xA0, VHF_HI=0x90, UHF=0x30, radio=0x04)
-    T= TEMIC_API    (VHF_LO=0x02, VHF_HI=0x04, UHF=0x01)
-    A= ALPS_API     (VHF_LO=0x14, VHF_HI=0x12, UHF=0x11)
-    M= PHILIPS_MK3  (VHF_LO=0x01, VHF_HI=0x02, UHF=0x04, radio=0x19)
+- L= LG_API       (VHF_LO=0x01, VHF_HI=0x02, UHF=0x08, radio=0x04)
+- P= PHILIPS_API  (VHF_LO=0xA0, VHF_HI=0x90, UHF=0x30, radio=0x04)
+- T= TEMIC_API    (VHF_LO=0x02, VHF_HI=0x04, UHF=0x01)
+- A= ALPS_API     (VHF_LO=0x14, VHF_HI=0x12, UHF=0x11)
+- M= PHILIPS_MK3  (VHF_LO=0x01, VHF_HI=0x02, UHF=0x04, radio=0x19)
 
-2) Tuner Manufacturers
-======================
+Tuner Manufacturers
+-------------------
 
-SAMSUNG Tuner identification: (e.g. TCPM9091PD27)
-  TCP [ABCJLMNQ] 90[89][125] [DP] [ACD] 27 [ABCD]
+- SAMSUNG Tuner identification: (e.g. TCPM9091PD27)
+
+.. code-block:: none
+
+ TCP [ABCJLMNQ] 90[89][125] [DP] [ACD] 27 [ABCD]
  [ABCJLMNQ]:
    A= BG+DK
    B= BG
@@ -37,9 +44,12 @@ SAMSUNG Tuner identification: (e.g. TCPM9091PD27)
  [ABCD]:
    3-wire/I2C tuning, 2-band/3-band
 
- These Tuners are PHILIPS_API compatible.
+These Tuners are PHILIPS_API compatible.
 
 Philips Tuner identification: (e.g. FM1216MF)
+
+.. code-block:: none
+
   F[IRMQ]12[1345]6{MF|ME|MP}
   F[IRMQ]:
    FI12x6: Tuner Series
@@ -63,6 +73,9 @@ Philips Tuner identification: (e.g. FM1216MF)
   MK3 series introduced in 2002 w/ PHILIPS_MK3_API
 
 Temic Tuner identification: (.e.g 4006FH5)
+
+.. code-block:: none
+
    4[01][0136][269]F[HYNR]5
     40x2: Tuner (5V/33V), TEMIC_API.
     40x6: Tuner 5V
@@ -82,34 +95,37 @@ Temic Tuner identification: (.e.g 4006FH5)
   Note: Only 40x2 series has TEMIC_API, all newer tuners have PHILIPS_API.
 
 LG Innotek Tuner:
-  TPI8NSR11 : NTSC J/M    (TPI8NSR01 w/FM)  (P,210/497)
-  TPI8PSB11 : PAL B/G     (TPI8PSB01 w/FM)  (P,170/450)
-  TAPC-I701 : PAL I       (TAPC-I001 w/FM)  (P,170/450)
-  TPI8PSB12 : PAL D/K+B/G (TPI8PSB02 w/FM)  (P,170/450)
-  TAPC-H701P: NTSC_JP     (TAPC-H001P w/FM) (L,170/450)
-  TAPC-G701P: PAL B/G     (TAPC-G001P w/FM) (L,170/450)
-  TAPC-W701P: PAL I       (TAPC-W001P w/FM) (L,170/450)
-  TAPC-Q703P: PAL D/K     (TAPC-Q001P w/FM) (L,170/450)
-  TAPC-Q704P: PAL D/K+I   (L,170/450)
-  TAPC-G702P: PAL D/K+B/G (L,170/450)
 
-  TADC-H002F: NTSC (L,175/410?; 2-B, C-W+11, W+12-69)
-  TADC-M201D: PAL D/K+B/G+I (L,143/425)  (sound control at I2C address 0xc8)
-  TADC-T003F: NTSC Taiwan  (L,175/410?; 2-B, C-W+11, W+12-69)
-  Suffix:
-    P= Standard phono female socket
-    D= IEC female socket
-    F= F-connector
+- TPI8NSR11 : NTSC J/M    (TPI8NSR01 w/FM)  (P,210/497)
+- TPI8PSB11 : PAL B/G     (TPI8PSB01 w/FM)  (P,170/450)
+- TAPC-I701 : PAL I       (TAPC-I001 w/FM)  (P,170/450)
+- TPI8PSB12 : PAL D/K+B/G (TPI8PSB02 w/FM)  (P,170/450)
+- TAPC-H701P: NTSC_JP     (TAPC-H001P w/FM) (L,170/450)
+- TAPC-G701P: PAL B/G     (TAPC-G001P w/FM) (L,170/450)
+- TAPC-W701P: PAL I       (TAPC-W001P w/FM) (L,170/450)
+- TAPC-Q703P: PAL D/K     (TAPC-Q001P w/FM) (L,170/450)
+- TAPC-Q704P: PAL D/K+I   (L,170/450)
+- TAPC-G702P: PAL D/K+B/G (L,170/450)
+
+- TADC-H002F: NTSC (L,175/410?; 2-B, C-W+11, W+12-69)
+- TADC-M201D: PAL D/K+B/G+I (L,143/425)  (sound control at I2C address 0xc8)
+- TADC-T003F: NTSC Taiwan  (L,175/410?; 2-B, C-W+11, W+12-69)
+
+Suffix:
+  - P= Standard phono female socket
+  - D= IEC female socket
+  - F= F-connector
 
 Other Tuners:
-TCL2002MB-1 : PAL BG + DK       =TUNER_LG_PAL_NEW_TAPC
-TCL2002MB-1F: PAL BG + DK w/FM  =PHILIPS_PAL
-TCL2002MI-2 : PAL I		= ??
+
+- TCL2002MB-1 : PAL BG + DK       =TUNER_LG_PAL_NEW_TAPC
+- TCL2002MB-1F: PAL BG + DK w/FM  =PHILIPS_PAL
+- TCL2002MI-2 : PAL I		= ??
 
 ALPS Tuners:
-   Most are LG_API compatible
-   TSCH6 has ALPS_API (TSCH5 ?)
-   TSBE1 has extra API 05,02,08 Control_byte=0xCB Source:(1)
 
-Lit.
-(1) conexant100029b-PCI-Decoder-ApplicationNote.pdf
+- Most are LG_API compatible
+- TSCH6 has ALPS_API (TSCH5 ?)
+- TSBE1 has extra API 05,02,08 Control_byte=0xCB Source:[#f1]_
+
+.. [#f1] conexant100029b-PCI-Decoder-ApplicationNote.pdf
-- 
2.7.4


