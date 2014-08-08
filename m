Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49765 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756019AbaHHKnz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Aug 2014 06:43:55 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/3] au0828: avoid race conditions at RC stop
Date: Fri,  8 Aug 2014 07:43:45 -0300
Message-Id: <1407494627-1555-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As the RC kthread can re-enable IR int, we should first
cancel the kthread and then disable IR int.

While here, remove a temporary debug printk.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/au0828/au0828-input.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-input.c b/drivers/media/usb/au0828/au0828-input.c
index b4475706dfd2..f8631b9b33d6 100644
--- a/drivers/media/usb/au0828/au0828-input.c
+++ b/drivers/media/usb/au0828/au0828-input.c
@@ -254,12 +254,10 @@ static void au0828_rc_stop(struct rc_dev *rc)
 {
 	struct au0828_rc *ir = rc->priv;
 
-printk("%s\n", __func__);
+	cancel_delayed_work_sync(&ir->work);
 
 	/* Disable IR */
 	au8522_rc_clear(ir, 0xe0, 1 << 4);
-
-	cancel_delayed_work_sync(&ir->work);
 }
 
 static int au0828_probe_i2c_ir(struct au0828_dev *dev)
-- 
1.9.3

