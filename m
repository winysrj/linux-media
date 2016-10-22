Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50961 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756125AbcJVWwK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 22 Oct 2016 18:52:10 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5/5] gspca-cardlist.rst: update camera names
Date: Sat, 22 Oct 2016 20:52:04 -0200
Message-Id: <cf0055f782ea384ccea922391e353f9c2b4e00f9.1477176498.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1477176498.git.mchehab@s-opensource.com>
References: <cover.1477176498.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1477176498.git.mchehab@s-opensource.com>
References: <cover.1477176498.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For those cameras that were missing descriptions, update using
some web research:
	https://cateee.net/lkddb/web-lkddb/USB_GSPCA_STV0680.html
	https://cateee.net/lkddb/web-lkddb/USB_GSPCA_ZC3XX.html
	https://cateee.net/lkddb/web-lkddb/USB_GSPCA_KINECT.html
	https://cateee.net/lkddb/web-lkddb/USB_GSPCA_SPCA561.html
	https://cateee.net/lkddb/web-lkddb/USB_GSPCA_VICAM.html
	https://cateee.net/lkddb/web-lkddb/USB_GSPCA_DTCS033.html
	https://bugs.launchpad.net/ubuntu/+source/linux/+bug/564979
	https://cateee.net/lkddb/web-lkddb/USB_GSPCA_PAC7302.html
	https://cateee.net/lkddb/web-lkddb/USB_GSPCA_SONIXB.html
	https://cateee.net/lkddb/web-lkddb/USB_GSPCA_SONIXJ.html

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/v4l-drivers/gspca-cardlist.rst | 50 +++++++++++-----------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/Documentation/media/v4l-drivers/gspca-cardlist.rst b/Documentation/media/v4l-drivers/gspca-cardlist.rst
index 474d7418f86a..e18d87e80d78 100644
--- a/Documentation/media/v4l-drivers/gspca-cardlist.rst
+++ b/Documentation/media/v4l-drivers/gspca-cardlist.rst
@@ -18,7 +18,7 @@ spca501         040a:0002	Kodak DVC-325
 spca500         040a:0300	Kodak EZ200
 zc3xx           041e:041e	Creative WebCam Live!
 ov519           041e:4003	Video Blaster WebCam Go Plus
-stv0680         041e:4007
+stv0680         041e:4007	Go Mini
 spca500         041e:400a	Creative PC-CAM 300
 sunplus         041e:400b	Creative PC-CAM 600
 sunplus         041e:4012	PC-Cam350
@@ -30,7 +30,7 @@ zc3xx           041e:401c	Creative NX
 spca505         041e:401d	Creative Webcam NX ULTRA
 zc3xx           041e:401e	Creative Nx Pro
 zc3xx           041e:401f	Creative Webcam Notebook PD1171
-zc3xx           041e:4022
+zc3xx           041e:4022	Webcam NX Pro
 pac207          041e:4028	Creative Webcam Vista Plus
 zc3xx           041e:4029	Creative WebCam Vista Pro
 zc3xx           041e:4034	Creative Instant P0620
@@ -69,9 +69,9 @@ sn9c20x         045e:00f4	LifeCam VX-6000 (SN9C20x + OV9650)
 sonixj          045e:00f5	MicroSoft VX3000
 sonixj          045e:00f7	MicroSoft VX1000
 ov519           045e:028c	Micro$oft xbox cam
-kinect          045e:02ae
-kinect          045e:02bf
-spca508         0461:0815	Micro Innovation IC200
+kinect          045e:02ae	Xbox NUI Camera
+kinect          045e:02bf	Kinect for Windows NUI Camera
+spca561         0461:0815	Micro Innovations IC200 Webcam
 sunplus         0461:0821	Fujifilm MV-1
 zc3xx           0461:0a00	MicroInnovation WebCam320
 stv06xx         046D:08F0	QuickCamMessenger
@@ -136,7 +136,7 @@ sunplus         04a5:3008	Benq DC 1500
 sunplus         04a5:300a	Benq DC 3410
 spca500         04a5:300c	Benq DC 1016
 benq            04a5:3035	Benq DC E300
-vicam           04c1:009d
+vicam           04c1:009d	HomeConnect Webcam [vicam]
 konica          04c8:0720	IntelYC 76
 finepix         04cb:0104	Fujifilm FinePix 4800
 finepix         04cb:0109	Fujifilm FinePix A202
@@ -183,11 +183,11 @@ sunplus         0546:3155	Polaroid PDC3070
 sunplus         0546:3191	Polaroid Ion 80
 sunplus         0546:3273	Polaroid PDC2030
 touptek         0547:6801	TTUCMOS08000KPB, AS MU800
-dtcs033         0547:7303
+dtcs033         0547:7303	Anchor Chips, Inc
 ov519           054c:0154	Sonny toy4
 ov519           054c:0155	Sonny toy5
 cpia1           0553:0002	CPIA CPiA (version1) based cameras
-stv0680         0553:0202
+stv0680         0553:0202	STV0680 Camera
 zc3xx           055f:c005	Mustek Wcam300A
 spca500         055f:c200	Mustek Gsmart 300
 sunplus         055f:c211	Kowa Bs888e Microcamera
@@ -222,7 +222,7 @@ sunplus         05da:1018	Digital Dream Enigma 1.3
 stk014          05e1:0893	Syntek DV4000
 gl860           05e3:0503	Genesys Logic PC Camera
 gl860           05e3:f191	Genesys Logic PC Camera
-vicam           0602:1001
+vicam           0602:1001	ViCam Webcam
 spca561         060b:a001	Maxell Compact Pc PM3
 zc3xx           0698:2003	CTX M730V built in
 topro           06a2:0003	TP6800 PC Camera, CmoX CX0342 webcam
@@ -234,7 +234,7 @@ spca500         06bd:0404	Agfa CL20
 spca500         06be:0800	Optimedia
 nw80x           06be:d001	EZCam Pro p35u
 sunplus         06d6:0031	Trust 610 LCD PowerC@m Zoom
-sunplus         06d6:0041
+sunplus         06d6:0041	Aashima Technology B.V.
 spca506         06e1:a190	ADS Instant VCD
 ov534           06f8:3002	Hercules Blog Webcam
 ov534_9         06f8:3003	Hercules Dualpix HD Weblog
@@ -297,7 +297,7 @@ pac7311         093a:260f	SnakeCam
 pac7302         093a:2620	Apollo AC-905
 pac7302         093a:2621	PAC731x
 pac7302         093a:2622	Genius Eye 312
-pac7302         093a:2623
+pac7302         093a:2623	Pixart Imaging, Inc.
 pac7302         093a:2624	PAC7302
 pac7302         093a:2625	Genius iSlim 310
 pac7302         093a:2626	Labtec 2200
@@ -307,9 +307,9 @@ pac7302         093a:2629	Genious iSlim 300
 pac7302         093a:262a	Webcam 300k
 pac7302         093a:262c	Philips SPC 230 NC
 jl2005bcd       0979:0227	Various brands, 19 known cameras supported
-jeilinj         0979:0270
+jeilinj         0979:0270	Sakar 57379
 jeilinj         0979:0280	Sportscam DV15, Sakar 57379
-zc3xx           0ac8:0301
+zc3xx           0ac8:0301	Web Camera
 zc3xx           0ac8:0302	Z-star Vimicro zc0302
 vc032x          0ac8:0321	Vimicro generic vc0321
 vc032x          0ac8:0323	Vimicro Vc0323
@@ -336,19 +336,19 @@ sonixb          0c45:6025	Xcam Shanga
 sonixb          0c45:6027	GeniusEye 310
 sonixb          0c45:6028	Sonix Btc Pc380
 sonixb          0c45:6029	spcaCam@150
-sonixb          0c45:602a
+sonixb          0c45:602a	Meade ETX-105EC Camera
 sonixb          0c45:602c	Generic Sonix OV7630
 sonixb          0c45:602d	LIC-200 LG
 sonixb          0c45:602e	Genius VideoCam Messenger
 sonixj          0c45:6040	Speed NVC 350K
 sonixj          0c45:607c	Sonix sn9c102p Hv7131R
-sonixb          0c45:6083
-sonixb          0c45:608c
-sonixb          0c45:608f
-sonixb          0c45:60a8
-sonixb          0c45:60aa
-sonixb          0c45:60af
-sonixb          0c45:60b0
+sonixb          0c45:6083	VideoCAM Look
+sonixb          0c45:608c	VideoCAM Look
+sonixb          0c45:608f	PC Camera (SN9C103 + OV7630)
+sonixb          0c45:60a8	VideoCAM Look
+sonixb          0c45:60aa	VideoCAM Look
+sonixb          0c45:60af	VideoCAM Look
+sonixb          0c45:60b0	Genius VideoCam Look
 sonixj          0c45:60c0	Sangha Sn535
 sonixj          0c45:60ce	USB-PC-Camera-168 (TALK-5067)
 sonixj          0c45:60ec	SN9C105+MO4000
@@ -365,13 +365,13 @@ sonixj          0c45:6128	Microdia/Sonix SNP325
 sonixj          0c45:612a	Avant Camera
 sonixj          0c45:612b	Speed-Link REFLECT2
 sonixj          0c45:612c	Typhoon Rasy Cam 1.3MPix
-sonixj          0c45:612e
+sonixj          0c45:612e	PC Camera (SN9C110)
 sonixj          0c45:6130	Sonix Pccam
 sonixj          0c45:6138	Sn9c120 Mo4000
 sonixj          0c45:613a	Microdia Sonix PC Camera
 sonixj          0c45:613b	Surfer SN-206
 sonixj          0c45:613c	Sonix Pccam168
-sonixj          0c45:613e
+sonixj          0c45:613e	PC Camera (SN9C120)
 sonixj          0c45:6142	Hama PC-Webcam AC-150
 sonixj          0c45:6143	Sonix Pccam168
 sonixj          0c45:6148	Digitus DA-70811/ZSMC USB PC Camera ZS211/Microdia
@@ -411,11 +411,11 @@ etoms           102c:6251	Qcam xxxxxx VGA
 ov519           1046:9967	W9967CF/W9968CF WebCam IC, Video Blaster WebCam Go
 zc3xx           10fd:0128	Typhoon Webshot II USB 300k 0x0128
 spca561         10fd:7e50	FlyCam Usb 100
-zc3xx           10fd:804d
+zc3xx           10fd:804d	Typhoon Webshot II Webcam [zc0301]
 zc3xx           10fd:8050	Typhoon Webshot II USB 300k
 ov534           1415:2000	Sony HD Eye for PS3 (SLEH 00201)
 pac207          145f:013a	Trust WB-1300N
-pac7302         145f:013c
+pac7302         145f:013c	Trust
 sn9c20x         145f:013d	Trust WB-3600R
 vc032x          15b8:6001	HP 2.0 Megapixel
 vc032x          15b8:6002	HP 2.0 Megapixel rz406aa
-- 
2.7.4


