Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49144 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650AbaDGOB2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Apr 2014 10:01:28 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] [media] gpsca: remove the risk of a division by zero
Date: Mon,  7 Apr 2014 11:01:19 -0300
Message-Id: <1396879279-31299-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by Coverity, there's a potential risk of a division
by zero on some calls to jpeg_set_qual(), if quality is zero.

As quality can't be 0 or lower than that, adds an extra clause
to cover this special case.

Coverity reports: CID#11922280, CID#11922293, CID#11922295

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/gspca/jpeg.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/gspca/jpeg.h b/drivers/media/usb/gspca/jpeg.h
index ab54910418b4..0aa2b671faa4 100644
--- a/drivers/media/usb/gspca/jpeg.h
+++ b/drivers/media/usb/gspca/jpeg.h
@@ -154,7 +154,9 @@ static void jpeg_set_qual(u8 *jpeg_hdr,
 {
 	int i, sc;
 
-	if (quality < 50)
+	if (quality <= 0)
+		sc = 5000;
+	else if (quality < 50)
 		sc = 5000 / quality;
 	else
 		sc = 200 - quality * 2;
-- 
1.9.0

