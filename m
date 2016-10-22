Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50963 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756146AbcJVWwK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 22 Oct 2016 18:52:10 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 4/5] gspca-cardlist.rst: update cardlist from drivers USB IDs
Date: Sat, 22 Oct 2016 20:52:03 -0200
Message-Id: <8944c9004e4d5f0cd1bb5d6a7c61c0dca2e5b3e0.1477176498.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1477176498.git.mchehab@s-opensource.com>
References: <cover.1477176498.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1477176498.git.mchehab@s-opensource.com>
References: <cover.1477176498.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several missing USB IDs that are defined on gspca
drivers. Add them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/v4l-drivers/gspca-cardlist.rst | 44 ++++++++++++++++++++--
 1 file changed, 41 insertions(+), 3 deletions(-)

diff --git a/Documentation/media/v4l-drivers/gspca-cardlist.rst b/Documentation/media/v4l-drivers/gspca-cardlist.rst
index 76a1c6389b2e..474d7418f86a 100644
--- a/Documentation/media/v4l-drivers/gspca-cardlist.rst
+++ b/Documentation/media/v4l-drivers/gspca-cardlist.rst
@@ -11,12 +11,14 @@ The modules for the gspca webcam drivers are:
 =========	=========	===================================================================
 spca501         0000:0000	MystFromOri Unknown Camera
 spca508         0130:0130	Clone Digital Webcam 11043
+se401           03e8:0004	Endpoints/AoxSE401
 zc3xx           03f0:1b07	HP Premium Starter Cam
 m5602           0402:5602	ALi Video Camera Controller
 spca501         040a:0002	Kodak DVC-325
 spca500         040a:0300	Kodak EZ200
 zc3xx           041e:041e	Creative WebCam Live!
 ov519           041e:4003	Video Blaster WebCam Go Plus
+stv0680         041e:4007
 spca500         041e:400a	Creative PC-CAM 300
 sunplus         041e:400b	Creative PC-CAM 600
 sunplus         041e:4012	PC-Cam350
@@ -28,6 +30,7 @@ zc3xx           041e:401c	Creative NX
 spca505         041e:401d	Creative Webcam NX ULTRA
 zc3xx           041e:401e	Creative Nx Pro
 zc3xx           041e:401f	Creative Webcam Notebook PD1171
+zc3xx           041e:4022
 pac207          041e:4028	Creative Webcam Vista Plus
 zc3xx           041e:4029	Creative WebCam Vista Pro
 zc3xx           041e:4034	Creative Instant P0620
@@ -49,6 +52,7 @@ ov519           041e:4061	Creative Live! VISTA VF0400
 ov519           041e:4064	Creative Live! VISTA VF0420
 ov519           041e:4067	Creative Live! Cam Video IM (VF0350)
 ov519           041e:4068	Creative Live! VISTA VF0470
+sn9c2028        0458:7003	GeniusVideocam Live v2
 spca561         0458:7004	Genius VideoCAM Express V2
 sn9c2028        0458:7005	Genius Smart 300, version 2
 sunplus         0458:7006	Genius Dsc 1.3 Smart
@@ -65,12 +69,17 @@ sn9c20x         045e:00f4	LifeCam VX-6000 (SN9C20x + OV9650)
 sonixj          045e:00f5	MicroSoft VX3000
 sonixj          045e:00f7	MicroSoft VX1000
 ov519           045e:028c	Micro$oft xbox cam
+kinect          045e:02ae
+kinect          045e:02bf
 spca508         0461:0815	Micro Innovation IC200
 sunplus         0461:0821	Fujifilm MV-1
 zc3xx           0461:0a00	MicroInnovation WebCam320
-stv06xx         046d:0840	QuickCam Express
-stv06xx         046d:0850	LEGO cam / QuickCam Web
-stv06xx         046d:0870	Dexxa WebCam USB
+stv06xx         046D:08F0	QuickCamMessenger
+stv06xx         046D:08F5	QuickCamCommunicate
+stv06xx         046D:08F6	QuickCamMessenger (new)
+stv06xx         046d:0840	QuickCamExpress
+stv06xx         046d:0850	LEGOcam / QuickCam Web
+stv06xx         046d:0870	DexxaWebCam USB
 spca500         046d:0890	Logitech QuickCam traveler
 vc032x          046d:0892	Logitech Orbicam
 vc032x          046d:0896	Logitech Orbicam
@@ -109,6 +118,7 @@ spca561         046d:092e	Logitech QC Elch2
 spca561         046d:092f	Logitech QuickCam Express Plus
 sunplus         046d:0960	Logitech ClickSmart 420
 nw80x           046d:d001	Logitech QuickCam Pro (dark focus ring)
+se401           0471:030b	PhilipsPCVC665K
 sunplus         0471:0322	Philips DMVC1300K
 zc3xx           0471:0325	Philips SPC 200 NC
 zc3xx           0471:0326	Philips SPC 300 NC
@@ -117,12 +127,17 @@ sonixj          0471:0328	Philips SPC 700 NC
 zc3xx           0471:032d	Philips SPC 210 NC
 zc3xx           0471:032e	Philips SPC 315 NC
 sonixj          0471:0330	Philips SPC 710 NC
+se401           047d:5001	Kensington67014
+se401           047d:5002	Kensington6701(5/7)
+se401           047d:5003	Kensington67016
 spca501         0497:c001	Smile International
 sunplus         04a5:3003	Benq DC 1300
 sunplus         04a5:3008	Benq DC 1500
 sunplus         04a5:300a	Benq DC 3410
 spca500         04a5:300c	Benq DC 1016
 benq            04a5:3035	Benq DC E300
+vicam           04c1:009d
+konica          04c8:0720	IntelYC 76
 finepix         04cb:0104	Fujifilm FinePix 4800
 finepix         04cb:0109	Fujifilm FinePix A202
 finepix         04cb:010b	Fujifilm FinePix A203
@@ -167,9 +182,12 @@ tv8532          0545:8333	Veo Stingray
 sunplus         0546:3155	Polaroid PDC3070
 sunplus         0546:3191	Polaroid Ion 80
 sunplus         0546:3273	Polaroid PDC2030
+touptek         0547:6801	TTUCMOS08000KPB, AS MU800
+dtcs033         0547:7303
 ov519           054c:0154	Sonny toy4
 ov519           054c:0155	Sonny toy5
 cpia1           0553:0002	CPIA CPiA (version1) based cameras
+stv0680         0553:0202
 zc3xx           055f:c005	Mustek Wcam300A
 spca500         055f:c200	Mustek Gsmart 300
 sunplus         055f:c211	Kowa Bs888e Microcamera
@@ -204,6 +222,7 @@ sunplus         05da:1018	Digital Dream Enigma 1.3
 stk014          05e1:0893	Syntek DV4000
 gl860           05e3:0503	Genesys Logic PC Camera
 gl860           05e3:f191	Genesys Logic PC Camera
+vicam           0602:1001
 spca561         060b:a001	Maxell Compact Pc PM3
 zc3xx           0698:2003	CTX M730V built in
 topro           06a2:0003	TP6800 PC Camera, CmoX CX0342 webcam
@@ -215,6 +234,7 @@ spca500         06bd:0404	Agfa CL20
 spca500         06be:0800	Optimedia
 nw80x           06be:d001	EZCam Pro p35u
 sunplus         06d6:0031	Trust 610 LCD PowerC@m Zoom
+sunplus         06d6:0041
 spca506         06e1:a190	ADS Instant VCD
 ov534           06f8:3002	Hercules Blog Webcam
 ov534_9         06f8:3003	Hercules Dualpix HD Weblog
@@ -277,6 +297,7 @@ pac7311         093a:260f	SnakeCam
 pac7302         093a:2620	Apollo AC-905
 pac7302         093a:2621	PAC731x
 pac7302         093a:2622	Genius Eye 312
+pac7302         093a:2623
 pac7302         093a:2624	PAC7302
 pac7302         093a:2625	Genius iSlim 310
 pac7302         093a:2626	Labtec 2200
@@ -286,7 +307,9 @@ pac7302         093a:2629	Genious iSlim 300
 pac7302         093a:262a	Webcam 300k
 pac7302         093a:262c	Philips SPC 230 NC
 jl2005bcd       0979:0227	Various brands, 19 known cameras supported
+jeilinj         0979:0270
 jeilinj         0979:0280	Sportscam DV15, Sakar 57379
+zc3xx           0ac8:0301
 zc3xx           0ac8:0302	Z-star Vimicro zc0302
 vc032x          0ac8:0321	Vimicro generic vc0321
 vc032x          0ac8:0323	Vimicro Vc0323
@@ -310,13 +333,22 @@ sonixb          0c45:6011	Microdia PC Camera (SN9C102)
 sonixb          0c45:6019	Generic Sonix OV7630
 sonixb          0c45:6024	Generic Sonix Tas5130c
 sonixb          0c45:6025	Xcam Shanga
+sonixb          0c45:6027	GeniusEye 310
 sonixb          0c45:6028	Sonix Btc Pc380
 sonixb          0c45:6029	spcaCam@150
+sonixb          0c45:602a
 sonixb          0c45:602c	Generic Sonix OV7630
 sonixb          0c45:602d	LIC-200 LG
 sonixb          0c45:602e	Genius VideoCam Messenger
 sonixj          0c45:6040	Speed NVC 350K
 sonixj          0c45:607c	Sonix sn9c102p Hv7131R
+sonixb          0c45:6083
+sonixb          0c45:608c
+sonixb          0c45:608f
+sonixb          0c45:60a8
+sonixb          0c45:60aa
+sonixb          0c45:60af
+sonixb          0c45:60b0
 sonixj          0c45:60c0	Sangha Sn535
 sonixj          0c45:60ce	USB-PC-Camera-168 (TALK-5067)
 sonixj          0c45:60ec	SN9C105+MO4000
@@ -333,11 +365,13 @@ sonixj          0c45:6128	Microdia/Sonix SNP325
 sonixj          0c45:612a	Avant Camera
 sonixj          0c45:612b	Speed-Link REFLECT2
 sonixj          0c45:612c	Typhoon Rasy Cam 1.3MPix
+sonixj          0c45:612e
 sonixj          0c45:6130	Sonix Pccam
 sonixj          0c45:6138	Sn9c120 Mo4000
 sonixj          0c45:613a	Microdia Sonix PC Camera
 sonixj          0c45:613b	Surfer SN-206
 sonixj          0c45:613c	Sonix Pccam168
+sonixj          0c45:613e
 sonixj          0c45:6142	Hama PC-Webcam AC-150
 sonixj          0c45:6143	Sonix Pccam168
 sonixj          0c45:6148	Digitus DA-70811/ZSMC USB PC Camera ZS211/Microdia
@@ -377,15 +411,19 @@ etoms           102c:6251	Qcam xxxxxx VGA
 ov519           1046:9967	W9967CF/W9968CF WebCam IC, Video Blaster WebCam Go
 zc3xx           10fd:0128	Typhoon Webshot II USB 300k 0x0128
 spca561         10fd:7e50	FlyCam Usb 100
+zc3xx           10fd:804d
 zc3xx           10fd:8050	Typhoon Webshot II USB 300k
 ov534           1415:2000	Sony HD Eye for PS3 (SLEH 00201)
 pac207          145f:013a	Trust WB-1300N
+pac7302         145f:013c
 sn9c20x         145f:013d	Trust WB-3600R
 vc032x          15b8:6001	HP 2.0 Megapixel
 vc032x          15b8:6002	HP 2.0 Megapixel rz406aa
+stk1135         174f:6a31	ASUSlaptop, MT9M112 sensor
 spca501         1776:501c	Arowana 300K CMOS Camera
 t613            17a1:0128	TASCORP JPEG Webcam, NGS Cyclops
 vc032x          17ef:4802	Lenovo Vc0323+MI1310_SOC
+pac7302         1ae7:2001	SpeedLinkSnappy Mic SL-6825-SBK
 pac207          2001:f115	D-Link DSB-C120
 sq905c          2770:9050	Disney pix micro (CIF)
 sq905c          2770:9051	Lego Bionicle
-- 
2.7.4


