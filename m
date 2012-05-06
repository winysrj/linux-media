Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1073 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482Ab2EFM2o (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 May 2012 08:28:44 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 12/17] gscpa_zc3xx: Disable the highest quality setting as it is not usable
Date: Sun,  6 May 2012 14:28:26 +0200
Message-Id: <f9aa206cc2ea9257086e6023edac350022fced4a.1336305565.git.hans.verkuil@cisco.com>
In-Reply-To: <1336307311-10227-1-git-send-email-hverkuil@xs4all.nl>
References: <1336307311-10227-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <a5a075c580858f4484be5c4cfadd195492858505.1336305565.git.hans.verkuil@cisco.com>
References: <a5a075c580858f4484be5c4cfadd195492858505.1336305565.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans de Goede <hdegoede@redhat.com>

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

