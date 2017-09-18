Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:61684 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750868AbdIRUMh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Sep 2017 16:12:37 -0400
Subject: [PATCH 2/2] [media] vicam: Return directly after a failed kmalloc()
 in vicam_dostream()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <78839a2c-2076-f480-79d3-e783d2f8c0bf@users.sourceforge.net>
Message-ID: <a03c7497-3c98-7ba9-368e-7e1f5296144b@users.sourceforge.net>
Date: Mon, 18 Sep 2017 22:12:26 +0200
MIME-Version: 1.0
In-Reply-To: <78839a2c-2076-f480-79d3-e783d2f8c0bf@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 18 Sep 2017 21:56:55 +0200

* Return directly after a call of the function "kmalloc" failed
  at the beginning.

* Delete the jump target "exit" which became unnecessary
  with this refactoring.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/gspca/vicam.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/gspca/vicam.c b/drivers/media/usb/gspca/vicam.c
index 15b6887a8e97..11508ab283cd 100644
--- a/drivers/media/usb/gspca/vicam.c
+++ b/drivers/media/usb/gspca/vicam.c
@@ -184,7 +184,7 @@ static void vicam_dostream(struct work_struct *work)
 		   HEADER_SIZE;
 	buffer = kmalloc(frame_sz, GFP_KERNEL | GFP_DMA);
 	if (!buffer)
-		goto exit;
+		return;
 
 	while (gspca_dev->present && gspca_dev->streaming) {
 #ifdef CONFIG_PM
@@ -205,7 +205,7 @@ static void vicam_dostream(struct work_struct *work)
 				frame_sz - HEADER_SIZE);
 		gspca_frame_add(gspca_dev, LAST_PACKET, NULL, 0);
 	}
-exit:
+
 	kfree(buffer);
 }
 
-- 
2.14.1
