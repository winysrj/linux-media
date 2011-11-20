Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993Ab1KTO4a (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Nov 2011 09:56:30 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAKEuTLm013366
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 20 Nov 2011 09:56:29 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 3/8] [media] em28xx: Fix some Terratec entries (H5 and XS)
Date: Sun, 20 Nov 2011 12:56:13 -0200
Message-Id: <1321800978-27912-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1321800978-27912-2-git-send-email-mchehab@redhat.com>
References: <1321800978-27912-1-git-send-email-mchehab@redhat.com>
 <1321800978-27912-2-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by  Andreas Oberritter <obi@linuxtv.org>, changeset
33ba28eebc3e1758e6adc1fcec9e1e3151bac453 did the wrong thing.

Fix it to properly reflect the entries for Terratec H5 revs 1 and 2,
and restore Terratec XS entry.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 Documentation/video4linux/CARDLIST.em28xx |    6 +++---
 drivers/media/video/em28xx/em28xx-cards.c |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/video4linux/CARDLIST.em28xx b/Documentation/video4linux/CARDLIST.em28xx
index d8c8544..7734b2c 100644
--- a/Documentation/video4linux/CARDLIST.em28xx
+++ b/Documentation/video4linux/CARDLIST.em28xx
@@ -11,7 +11,7 @@
  10 -> Hauppauge WinTV HVR 900                  (em2880)        [2040:6500]
  11 -> Terratec Hybrid XS                       (em2880)
  12 -> Kworld PVR TV 2800 RF                    (em2820/em2840)
- 13 -> Terratec Prodigy XS                      (em2880)        [0ccd:10ad]
+ 13 -> Terratec Prodigy XS                      (em2880)
  14 -> SIIG AVTuner-PVR / Pixelview Prolink PlayTV USB 2.0 (em2820/em2840)
  15 -> V-Gear PocketTV                          (em2800)
  16 -> Hauppauge WinTV HVR 950                  (em2883)        [2040:6513,2040:6517,2040:651b]
@@ -41,7 +41,7 @@
  40 -> Plextor ConvertX PX-TV100U               (em2861)        [093b:a005]
  41 -> Kworld 350 U DVB-T                       (em2870)        [eb1a:e350]
  42 -> Kworld 355 U DVB-T                       (em2870)        [eb1a:e355,eb1a:e357]
- 43 -> Terratec Cinergy T XS                    (em2870)
+ 43 -> Terratec Cinergy T XS                    (em2870)        [0ccd:0043]
  44 -> Terratec Cinergy T XS (MT2060)           (em2870)
  45 -> Pinnacle PCTV DVB-T                      (em2870)
  46 -> Compro, VideoMate U3                     (em2870)        [185b:2870]
@@ -76,5 +76,5 @@
  76 -> KWorld PlusTV 340U or UB435-Q (ATSC)     (em2870)        [1b80:a340]
  77 -> EM2874 Leadership ISDBT                  (em2874)
  78 -> PCTV nanoStick T2 290e                   (em28174)
- 79 -> Terratec Cinergy H5                      (em2884)        [0ccd:0043,0ccd:10a2]
+ 79 -> Terratec Cinergy H5                      (em2884)        [0ccd:10a2,0ccd:10ad]
  80 -> PCTV DVB-S2 Stick (460e)                 (em28174)
diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index 9b747c2..19a5be3 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -1914,11 +1914,11 @@ struct usb_device_id em28xx_id_table[] = {
 	{ USB_DEVICE(0x0ccd, 0x0042),
 			.driver_info = EM2882_BOARD_TERRATEC_HYBRID_XS },
 	{ USB_DEVICE(0x0ccd, 0x0043),
+			.driver_info = EM2870_BOARD_TERRATEC_XS },
+	{ USB_DEVICE(0x0ccd, 0x10a2),	/* H5 Rev. 1 */
 			.driver_info = EM2884_BOARD_TERRATEC_H5 },
-	{ USB_DEVICE(0x0ccd, 0x10a2),	/* Rev. 1 */
+	{ USB_DEVICE(0x0ccd, 0x10ad),	/* H5 Rev. 2 */
 			.driver_info = EM2884_BOARD_TERRATEC_H5 },
-	{ USB_DEVICE(0x0ccd, 0x10ad),	/* Rev. 2 */
-			.driver_info = EM2880_BOARD_TERRATEC_PRODIGY_XS },
 	{ USB_DEVICE(0x0ccd, 0x0084),
 			.driver_info = EM2860_BOARD_TERRATEC_AV350 },
 	{ USB_DEVICE(0x0ccd, 0x0096),
-- 
1.7.7.1

