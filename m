Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55266 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbaHJArl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Aug 2014 20:47:41 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Shuah Khan <shuah.kh@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 01/18] [media] au0828: avoid race conditions at RC stop
Date: Sat,  9 Aug 2014 21:47:07 -0300
Message-Id: <1407631644-11990-2-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1407631644-11990-1-git-send-email-m.chehab@samsung.com>
References: <1407631644-11990-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As the RC kthread can re-enable IR int, we should first
cancel the kthread and then disable IR int.

While here, remove a temporary debug printk.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/au0828/au0828-input.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-input.c b/drivers/media/usb/au0828/au0828-input.c
index f0c5672e5f56..47ef07a693af 100644
--- a/drivers/media/usb/au0828/au0828-input.c
+++ b/drivers/media/usb/au0828/au0828-input.c
@@ -253,10 +253,10 @@ static void au0828_rc_stop(struct rc_dev *rc)
 {
 	struct au0828_rc *ir = rc->priv;
 
+	cancel_delayed_work_sync(&ir->work);
+
 	/* Disable IR */
 	au8522_rc_clear(ir, 0xe0, 1 << 4);
-
-	cancel_delayed_work_sync(&ir->work);
 }
 
 static int au0828_probe_i2c_ir(struct au0828_dev *dev)
-- 
1.9.3

