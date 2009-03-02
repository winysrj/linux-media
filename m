Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.235]:1309 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbZCBCWk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Mar 2009 21:22:40 -0500
MIME-Version: 1.0
Date: Mon, 2 Mar 2009 11:22:38 +0900
Message-ID: <5e9665e10903011822i5afbf588x8e9fc9596d94519a@mail.gmail.com>
Subject: [OMAPZOOM][PATCH] CAM: Make PACK8 mode on CCDC work only with
	CCIR-656
From: "DongSoo(Nathaniel) Kim" <dongsoo.kim@gmail.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Cc: svadivu@ti.com, p-kulkarni@ti.com, dongsoo45.kim@samsung.com,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	=?EUC-KR?B?sejH/MHY?= <riverful.kim@samsung.com>,
	"jongse.won@samsung.com" <jongse.won@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Besides the patch I've posted couple of hours ago, there is one more
thing in omap3 ispccdc.c.
According to omap3 datasheet, PACK8 could be enabled only when
CCDC_SYN_MODE is with CCIR-656 mode.
If you try to use external camera module with ITU-R.601 mode without
this patch, you could face weird data from your camera interface.
Please find following patch, and any comments will be welcomed.

Cheers,

Nate

>From 23425c97233c93f9b572351d8a93a13ae3cb3188 Mon Sep 17 00:00:00 2001
From: Dongsoo Kim <dongsoo45.kim@samsung.com>
Date: Mon, 2 Mar 2009 11:01:14 +0900
Subject: [PATCH 2/2] CAM: Make PACK8 mode on CCDC work only with CCIR-656
 Signed-off-by: Dongsoo Kim <dongsoo45.kim@samsung.com>

---
 drivers/media/video/isp/ispccdc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/isp/ispccdc.c
b/drivers/media/video/isp/ispccdc.c
index 8f7e896..2945c6f 100644
--- a/drivers/media/video/isp/ispccdc.c
+++ b/drivers/media/video/isp/ispccdc.c
@@ -762,7 +762,8 @@ void ispccdc_config_sync_if(struct ispccdc_syncif syncif)
 	switch (syncif.datsz) {
 	case DAT8:
 		syn_mode |= ISPCCDC_SYN_MODE_DATSIZ_8;
-		syn_mode |= ISPCCDC_SYN_MODE_PACK8; /* Added by MMS */
+		if (syncif.bt_r656_en)
+			syn_mode |= ISPCCDC_SYN_MODE_PACK8; /* Added by MMS */
 		break;
 	case DAT10:
 		syn_mode |= ISPCCDC_SYN_MODE_DATSIZ_10;
-- 
1.5.4.3


-- 
========================================================
DongSoo(Nathaniel), Kim
Engineer
Mobile S/W Platform Lab. S/W centre
Telecommunication R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
========================================================
