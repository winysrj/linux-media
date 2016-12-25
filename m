Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:49344 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750797AbcLYS3z (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Dec 2016 13:29:55 -0500
Subject: [PATCH 01/19] [media] uvc_driver: Use kmalloc_array() in
 uvc_simplify_fraction()
To: linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <47aa4314-74ec-b2bf-ee3b-aad4d6e9f0a2@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <67e337ba-f2e0-48ac-f6b9-e7e392eb92d7@users.sourceforge.net>
Date: Sun, 25 Dec 2016 19:29:46 +0100
MIME-Version: 1.0
In-Reply-To: <47aa4314-74ec-b2bf-ee3b-aad4d6e9f0a2@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 24 Dec 2016 21:10:16 +0100

A multiplication for the size determination of a memory allocation
indicated that an array data structure should be processed.
Thus use the corresponding function "kmalloc_array".

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/uvc/uvc_driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 04bf35063c4c..a64b5029f262 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -253,7 +253,7 @@ void uvc_simplify_fraction(uint32_t *numerator, uint32_t *denominator,
 	uint32_t x, y, r;
 	unsigned int i, n;
 
-	an = kmalloc(n_terms * sizeof *an, GFP_KERNEL);
+	an = kmalloc_array(n_terms, sizeof(*an), GFP_KERNEL);
 	if (an == NULL)
 		return;
 
-- 
2.11.0

