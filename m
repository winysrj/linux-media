Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:25393 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757341AbZIRXKj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Sep 2009 19:10:39 -0400
Received: by ey-out-2122.google.com with SMTP id d26so107417eyd.19
        for <linux-media@vger.kernel.org>; Fri, 18 Sep 2009 16:10:42 -0700 (PDT)
Message-ID: <4AB41522.5080204@gmail.com>
Date: Sat, 19 Sep 2009 01:17:54 +0200
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>, linux-media@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] GSPCA: kmalloc failure ignored in sd_start()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Prevent NULL dereference if kmalloc() fails.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Found with sed: http://kernelnewbies.org/roelkluin

diff --git a/drivers/media/video/gspca/jeilinj.c b/drivers/media/video/gspca/jeilinj.c
index dbfa3ed..a11c97e 100644
--- a/drivers/media/video/gspca/jeilinj.c
+++ b/drivers/media/video/gspca/jeilinj.c
@@ -312,6 +312,8 @@ static int sd_start(struct gspca_dev *gspca_dev)
 
 	/* create the JPEG header */
 	dev->jpeg_hdr = kmalloc(JPEG_HDR_SZ, GFP_KERNEL);
+	if (dev->jpeg_hdr == NULL)
+		return -ENOMEM;
 	jpeg_define(dev->jpeg_hdr, gspca_dev->height, gspca_dev->width,
 			0x21);          /* JPEG 422 */
 	jpeg_set_qual(dev->jpeg_hdr, dev->quality);
