Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39088 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbaGZO7S (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Jul 2014 10:59:18 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 2/4] [media] update cx23885 and em28xx cardlists
Date: Sat, 26 Jul 2014 11:59:06 -0300
Message-Id: <1406386748-8874-2-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1406386748-8874-1-git-send-email-m.chehab@samsung.com>
References: <1406386748-8874-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A few new devices were added. Update the lists accordingly.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 Documentation/video4linux/CARDLIST.cx23885 | 2 ++
 Documentation/video4linux/CARDLIST.em28xx  | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/video4linux/CARDLIST.cx23885 b/Documentation/video4linux/CARDLIST.cx23885
index fc009d0ee7d6..a74eeccfe700 100644
--- a/Documentation/video4linux/CARDLIST.cx23885
+++ b/Documentation/video4linux/CARDLIST.cx23885
@@ -41,3 +41,5 @@
  40 -> TurboSight TBS 6981                                 [6981:8888]
  41 -> TurboSight TBS 6980                                 [6980:8888]
  42 -> Leadtek Winfast PxPVR2200                           [107d:6f21]
+ 43 -> Hauppauge ImpactVCB-e                               [0070:7133]
+ 44 -> DViCO FusionHDTV DVB-T Dual Express2                [18ac:db98]
diff --git a/Documentation/video4linux/CARDLIST.em28xx b/Documentation/video4linux/CARDLIST.em28xx
index 5a3ddcd340d3..bc3351bb48b4 100644
--- a/Documentation/video4linux/CARDLIST.em28xx
+++ b/Documentation/video4linux/CARDLIST.em28xx
@@ -77,7 +77,7 @@
  76 -> KWorld PlusTV 340U or UB435-Q (ATSC)     (em2870)        [1b80:a340]
  77 -> EM2874 Leadership ISDBT                  (em2874)
  78 -> PCTV nanoStick T2 290e                   (em28174)
- 79 -> Terratec Cinergy H5                      (em2884)        [0ccd:10a2,0ccd:10ad,0ccd:10b6]
+ 79 -> Terratec Cinergy H5                      (em2884)        [eb1a:2885,0ccd:10a2,0ccd:10ad,0ccd:10b6]
  80 -> PCTV DVB-S2 Stick (460e)                 (em28174)
  81 -> Hauppauge WinTV HVR 930C                 (em2884)        [2040:1605]
  82 -> Terratec Cinergy HTC Stick               (em2884)        [0ccd:00b2]
-- 
1.9.3

