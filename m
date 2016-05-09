Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42461 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbcEIRSB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 May 2016 13:18:01 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 2/2] [media] em28xx: add missing USB IDs
Date: Mon,  9 May 2016 14:16:19 -0300
Message-Id: <628288d08a6162aa50e4dbd5918a9867b4c40e2f.1462814171.git.mchehab@osg.samsung.com>
In-Reply-To: <685f11097ab21221d734a259f2ba20684ffe3f05.1462814171.git.mchehab@osg.samsung.com>
References: <685f11097ab21221d734a259f2ba20684ffe3f05.1462814171.git.mchehab@osg.samsung.com>
In-Reply-To: <685f11097ab21221d734a259f2ba20684ffe3f05.1462814171.git.mchehab@osg.samsung.com>
References: <685f11097ab21221d734a259f2ba20684ffe3f05.1462814171.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add missing USB id's for em281xx devices.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 Documentation/video4linux/CARDLIST.em28xx | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/video4linux/CARDLIST.em28xx b/Documentation/video4linux/CARDLIST.em28xx
index ae9d5a852305..82eb4e4b6f69 100644
--- a/Documentation/video4linux/CARDLIST.em28xx
+++ b/Documentation/video4linux/CARDLIST.em28xx
@@ -76,9 +76,9 @@
  75 -> Dikom DK300                              (em2882)
  76 -> KWorld PlusTV 340U or UB435-Q (ATSC)     (em2870)        [1b80:a340]
  77 -> EM2874 Leadership ISDBT                  (em2874)
- 78 -> PCTV nanoStick T2 290e                   (em28174)
+ 78 -> PCTV nanoStick T2 290e                   (em28174)       [2013:024f]
  79 -> Terratec Cinergy H5                      (em2884)        [eb1a:2885,0ccd:10a2,0ccd:10ad,0ccd:10b6]
- 80 -> PCTV DVB-S2 Stick (460e)                 (em28174)
+ 80 -> PCTV DVB-S2 Stick (460e)                 (em28174)       [2013:024c]
  81 -> Hauppauge WinTV HVR 930C                 (em2884)        [2040:1605]
  82 -> Terratec Cinergy HTC Stick               (em2884)        [0ccd:00b2]
  83 -> Honestech Vidbox NW03                    (em2860)        [eb1a:5006]
@@ -90,10 +90,10 @@
  89 -> Delock 61959                             (em2874)        [1b80:e1cc]
  90 -> KWorld USB ATSC TV Stick UB435-Q V2      (em2874)        [1b80:e346]
  91 -> SpeedLink Vicious And Devine Laplace webcam (em2765)        [1ae7:9003,1ae7:9004]
- 92 -> PCTV DVB-S2 Stick (461e)                 (em28178)
+ 92 -> PCTV DVB-S2 Stick (461e)                 (em28178)       [2013:0258]
  93 -> KWorld USB ATSC TV Stick UB435-Q V3      (em2874)        [1b80:e34c]
- 94 -> PCTV tripleStick (292e)                  (em28178)
+ 94 -> PCTV tripleStick (292e)                  (em28178)       [2013:025f,2040:0264]
  95 -> Leadtek VC100                            (em2861)        [0413:6f07]
- 96 -> Terratec Cinergy T2 Stick HD             (em28178)
+ 96 -> Terratec Cinergy T2 Stick HD             (em28178)       [eb1a:8179]
  97 -> Elgato EyeTV Hybrid 2008 INT             (em2884)        [0fd9:0018]
- 98 -> PLEX PX-BCUD                             (em28178)
+ 98 -> PLEX PX-BCUD                             (em28178)       [3275:0085]
-- 
2.5.5

