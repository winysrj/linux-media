Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:60756 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750757AbdIRTfJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Sep 2017 15:35:09 -0400
To: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH] [media] sq905: Delete an error message for a failed memory
 allocation in sq905_dostream()
Message-ID: <a0e659c0-38b8-cbb1-7207-85440273fc66@users.sourceforge.net>
Date: Mon, 18 Sep 2017 21:34:56 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 18 Sep 2017 21:30:58 +0200

Omit an extra message for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/gspca/sq905.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/usb/gspca/sq905.c b/drivers/media/usb/gspca/sq905.c
index f1da34a10ce8..ca8cdd753a2b 100644
--- a/drivers/media/usb/gspca/sq905.c
+++ b/drivers/media/usb/gspca/sq905.c
@@ -218,10 +218,8 @@ static void sq905_dostream(struct work_struct *work)
 	u8 *buffer;
 
 	buffer = kmalloc(SQ905_MAX_TRANSFER, GFP_KERNEL | GFP_DMA);
-	if (!buffer) {
-		pr_err("Couldn't allocate USB buffer\n");
+	if (!buffer)
 		goto quit_stream;
-	}
 
 	frame_sz = gspca_dev->cam.cam_mode[gspca_dev->curr_mode].sizeimage
 			+ FRAME_HEADER_LEN;
-- 
2.14.1
