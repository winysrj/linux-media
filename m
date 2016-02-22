Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37527 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbcBVTJb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2016 14:09:31 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mike Isely <isely@pobox.com>
Subject: [PATCH 1/9] [media] pvrusb2-io: no need to check if sp is not NULL
Date: Mon, 22 Feb 2016 16:09:15 -0300
Message-Id: <4340d9c3cc750cc30918b5de6bf16de2722f7d1b.1456167652.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The buffer_complete() routine assumes that sp is not NULL,
otherwise it will fail completely. Btw, this is also
assumed at pvr2_buffer_queue(), with is the routine that
setups the URB handling.

So, remove the bogus for the callback at buffer_complete.

This fix this smatch warning:
	drivers/media/usb/pvrusb2/pvrusb2-io.c:476 buffer_complete() warn: variable dereferenced before check 'sp' (see line 472)

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/usb/pvrusb2/pvrusb2-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/pvrusb2/pvrusb2-io.c b/drivers/media/usb/pvrusb2/pvrusb2-io.c
index d860344de84e..e68ce24f27e3 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-io.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-io.c
@@ -473,7 +473,7 @@ static void buffer_complete(struct urb *urb)
 	}
 	spin_unlock_irqrestore(&sp->list_lock,irq_flags);
 	pvr2_buffer_set_ready(bp);
-	if (sp && sp->callback_func) {
+	if (sp->callback_func) {
 		sp->callback_func(sp->callback_data);
 	}
 }
-- 
2.5.0

