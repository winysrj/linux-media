Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f169.google.com ([209.85.160.169]:63533 "EHLO
	mail-yk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792AbaIHMvv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Sep 2014 08:51:51 -0400
From: Morgan Phillips <winter2718@gmail.com>
To: brijohn@gmail.com
Cc: hdegoede@redhat.com, m.chehab@samsung.com,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Morgan Phillips <winter2718@gmail.com>
Subject: [PATCH] [media]: sn9c20x: fix checkpatch warning: sizeof cmatrix should be sizeof(cmatrix)
Date: Mon,  8 Sep 2014 07:49:47 -0500
Message-Id: <1410180587-3518-1-git-send-email-winter2718@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Morgan Phillips <winter2718@gmail.com>
---
 drivers/media/usb/gspca/sn9c20x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/gspca/sn9c20x.c b/drivers/media/usb/gspca/sn9c20x.c
index 41a9a89..dd120d4 100644
--- a/drivers/media/usb/gspca/sn9c20x.c
+++ b/drivers/media/usb/gspca/sn9c20x.c
@@ -1297,7 +1297,7 @@ static void set_cmatrix(struct gspca_dev *gspca_dev,
 	s32 hue_coord, hue_index = 180 + hue;
 	u8 cmatrix[21];
 
-	memset(cmatrix, 0, sizeof cmatrix);
+	memset(cmatrix, 0, sizeof(cmatrix));
 	cmatrix[2] = (contrast * 0x25 / 0x100) + 0x26;
 	cmatrix[0] = 0x13 + (cmatrix[2] - 0x26) * 0x13 / 0x25;
 	cmatrix[4] = 0x07 + (cmatrix[2] - 0x26) * 0x07 / 0x25;
-- 
1.9.1

