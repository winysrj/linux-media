Return-path: <linux-media-owner@vger.kernel.org>
Received: from [31.36.214.240] ([31.36.214.240]:39086 "EHLO
        val.bonstra.fr.eu.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1753035AbeDHVVH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 8 Apr 2018 17:21:07 -0400
From: Hugo Grostabussiat <bonstra@bonstra.fr.eu.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org,
        Hugo Grostabussiat <bonstra@bonstra.fr.eu.org>
Subject: [PATCH v2 3/6] usbtv: Use V4L2 defines to select capture resolution
Date: Sun,  8 Apr 2018 23:11:58 +0200
Message-Id: <20180408211201.27452-4-bonstra@bonstra.fr.eu.org>
In-Reply-To: <20180408211201.27452-1-bonstra@bonstra.fr.eu.org>
References: <20180224182419.15670-1-bonstra@bonstra.fr.eu.org>
 <20180408211201.27452-1-bonstra@bonstra.fr.eu.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make use of the V4L2_STD_525_60 and V4L2_STD_625_50 defines to
determine the vertical resolution to use when capturing.

V4L2_STD_525_60 (resp. V4L2_STD_625_50) is the set of standards using
525 (resp. 625) lines per frame, independently of the color encoding.

Signed-off-by: Hugo Grostabussiat <bonstra@bonstra.fr.eu.org>
---
 drivers/media/usb/usbtv/usbtv-video.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/media/usb/usbtv/usbtv-video.c b/drivers/media/usb/usbtv/usbtv-video.c
index 6b0a10173388..29e245083247 100644
--- a/drivers/media/usb/usbtv/usbtv-video.c
+++ b/drivers/media/usb/usbtv/usbtv-video.c
@@ -54,12 +54,7 @@ static struct usbtv_norm_params norm_params[] = {
 		.cap_height = 480,
 	},
 	{
-		.norm = V4L2_STD_PAL,
-		.cap_width = 720,
-		.cap_height = 576,
-	},
-	{
-		.norm = V4L2_STD_SECAM,
+		.norm = V4L2_STD_625_50,
 		.cap_width = 720,
 		.cap_height = 576,
 	}
-- 
2.17.0
