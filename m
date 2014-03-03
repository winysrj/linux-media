Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51496 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780AbaCCTh5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 14:37:57 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/4] [media] em28xx: update CARDLIST.em28xx
Date: Mon,  3 Mar 2014 16:37:15 -0300
Message-Id: <1393875438-1916-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some new boards got added. Update the cardlist.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 Documentation/video4linux/CARDLIST.em28xx | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/video4linux/CARDLIST.em28xx b/Documentation/video4linux/CARDLIST.em28xx
index 404ac9b5f440..cb8706be3dbe 100644
--- a/Documentation/video4linux/CARDLIST.em28xx
+++ b/Documentation/video4linux/CARDLIST.em28xx
@@ -87,3 +87,7 @@
  86 -> PCTV QuatroStick nano (520e)             (em2884)        [2013:0251]
  87 -> Terratec Cinergy HTC USB XS              (em2884)        [0ccd:008e,0ccd:00ac]
  88 -> C3 Tech Digital Duo HDTV/SDTV USB        (em2884)        [1b80:e755]
+ 89 -> Delock 61959                             (em2874)        [1b80:e1cc]
+ 90 -> KWorld USB ATSC TV Stick UB435-Q V2      (em2874)        [1b80:e346]
+ 91 -> SpeedLink Vicious And Devine Laplace webcam (em2765)        [1ae7:9003,1ae7:9004]
+ 92 -> PCTV DVB-S2 Stick (461e)                 (em28178)
-- 
1.8.5.3

