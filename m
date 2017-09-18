Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:55736 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750964AbdIRULk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Sep 2017 16:11:40 -0400
Subject: [PATCH 1/2] [media] vicam: Delete an error message for a failed
 memory allocation in vicam_dostream()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <78839a2c-2076-f480-79d3-e783d2f8c0bf@users.sourceforge.net>
Message-ID: <51554497-b44a-d05d-d32b-02430ee96302@users.sourceforge.net>
Date: Mon, 18 Sep 2017 22:11:30 +0200
MIME-Version: 1.0
In-Reply-To: <78839a2c-2076-f480-79d3-e783d2f8c0bf@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 18 Sep 2017 21:48:55 +0200

Omit an extra message for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/gspca/vicam.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/usb/gspca/vicam.c b/drivers/media/usb/gspca/vicam.c
index 554b90ef2200..15b6887a8e97 100644
--- a/drivers/media/usb/gspca/vicam.c
+++ b/drivers/media/usb/gspca/vicam.c
@@ -183,10 +183,8 @@ static void vicam_dostream(struct work_struct *work)
 	frame_sz = gspca_dev->cam.cam_mode[gspca_dev->curr_mode].sizeimage +
 		   HEADER_SIZE;
 	buffer = kmalloc(frame_sz, GFP_KERNEL | GFP_DMA);
-	if (!buffer) {
-		pr_err("Couldn't allocate USB buffer\n");
+	if (!buffer)
 		goto exit;
-	}
 
 	while (gspca_dev->present && gspca_dev->streaming) {
 #ifdef CONFIG_PM
-- 
2.14.1
