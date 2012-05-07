Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757614Ab2EGTUh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 May 2012 15:20:37 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: hverkuil@xs4all.nl, Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 12/23] gspca_zc3xx: Disable the highest quality setting as it is not usable
Date: Mon,  7 May 2012 21:01:23 +0200
Message-Id: <1336417294-4566-13-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1336417294-4566-1-git-send-email-hdegoede@redhat.com>
References: <1336417294-4566-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Even with BRC the highest quality setting is not usable, BRC strips so
much data from each MCU that the quality becomes worse then using a lower
quality setting to begin with.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/gspca/zc3xx.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/gspca/zc3xx.c b/drivers/media/video/gspca/zc3xx.c
index 18ef68d..a8282b8 100644
--- a/drivers/media/video/gspca/zc3xx.c
+++ b/drivers/media/video/gspca/zc3xx.c
@@ -194,7 +194,7 @@ static const struct ctrl sd_ctrls[NCTRLS] = {
 		.type    = V4L2_CTRL_TYPE_INTEGER,
 		.name    = "Compression Quality",
 		.minimum = 50,
-		.maximum = 94,
+		.maximum = 87,
 		.step    = 1,
 		.default_value = 75,
 	    },
@@ -241,8 +241,11 @@ static const struct v4l2_pix_format sif_mode[] = {
 		.priv = 0},
 };
 
-/* bridge reg08 bits 1-2 -> JPEG quality conversion table */
-static u8 jpeg_qual[] = {50, 75, 87, 94};
+/*
+ * Bridge reg08 bits 1-2 -> JPEG quality conversion table. Note the highest
+ * quality setting is not usable as USB 1 does not have enough bandwidth.
+ */
+static u8 jpeg_qual[] = {50, 75, 87, /* 94 */};
 
 /* usb exchanges */
 struct usb_action {
-- 
1.7.10

