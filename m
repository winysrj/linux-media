Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:47118 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759473AbbBIKS0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Feb 2015 05:18:26 -0500
From: Luis de Bethencourt <luis@debethencourt.com>
Date: Mon, 9 Feb 2015 10:16:25 +0000
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, hdegoede@redhat.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH] gpsca: remove the risk of a division by zero
Message-ID: <20150209101625.GA28331@biggie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by Peter Kovar, there's a potential risk of a division by zero on
calls to jpeg_set_qual() when quality is zero.

As quality can't be 0 or lower than that, add an extra clause to cover this
special case.

Signed-off-by: Luis de Bethencourt <luis.bg@samsung.com>
---
 drivers/media/usb/gspca/topro.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/gspca/topro.c b/drivers/media/usb/gspca/topro.c
index 5fcd1ee..c70ff40 100644
--- a/drivers/media/usb/gspca/topro.c
+++ b/drivers/media/usb/gspca/topro.c
@@ -969,7 +969,9 @@ static void jpeg_set_qual(u8 *jpeg_hdr,
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
2.1.3

