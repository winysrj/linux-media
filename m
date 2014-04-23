Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59571 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbaDWNFX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Apr 2014 09:05:23 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] Documentation: Update cardlists
Date: Wed, 23 Apr 2014 10:05:17 -0300
Message-Id: <1398258317-9503-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Two new devices were added, but the cardlists weren't updated.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 Documentation/video4linux/CARDLIST.bttv   | 1 +
 Documentation/video4linux/CARDLIST.em28xx | 1 +
 2 files changed, 2 insertions(+)

diff --git a/Documentation/video4linux/CARDLIST.bttv b/Documentation/video4linux/CARDLIST.bttv
index 2f6e93597ce0..b092c0a14df2 100644
--- a/Documentation/video4linux/CARDLIST.bttv
+++ b/Documentation/video4linux/CARDLIST.bttv
@@ -164,3 +164,4 @@
 163 -> Bt848 Capture 14MHz
 164 -> CyberVision CV06 (SV)
 165 -> Kworld V-Stream Xpert TV PVR878
+166 -> PCI-8604PW
diff --git a/Documentation/video4linux/CARDLIST.em28xx b/Documentation/video4linux/CARDLIST.em28xx
index e085b1243b45..5a3ddcd340d3 100644
--- a/Documentation/video4linux/CARDLIST.em28xx
+++ b/Documentation/video4linux/CARDLIST.em28xx
@@ -92,3 +92,4 @@
  91 -> SpeedLink Vicious And Devine Laplace webcam (em2765)        [1ae7:9003,1ae7:9004]
  92 -> PCTV DVB-S2 Stick (461e)                 (em28178)
  93 -> KWorld USB ATSC TV Stick UB435-Q V3      (em2874)        [1b80:e34c]
+ 94 -> PCTV tripleStick (292e)                  (em28178)
-- 
1.9.0

