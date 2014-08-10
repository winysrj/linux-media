Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55267 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbaHJArl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Aug 2014 20:47:41 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Shuah Khan <shuah.kh@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 02/18] [media] au0828: handle IR int during suspend/resume
Date: Sat,  9 Aug 2014 21:47:08 -0300
Message-Id: <1407631644-11990-3-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1407631644-11990-1-git-send-email-m.chehab@samsung.com>
References: <1407631644-11990-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It doesn't make sense to handle an IR code given before
suspending after the device resume. So, turn off IR
int while suspending.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/au0828/au0828-input.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/usb/au0828/au0828-input.c b/drivers/media/usb/au0828/au0828-input.c
index 47ef07a693af..7a5437a4d938 100644
--- a/drivers/media/usb/au0828/au0828-input.c
+++ b/drivers/media/usb/au0828/au0828-input.c
@@ -380,6 +380,9 @@ int au0828_rc_suspend(struct au0828_dev *dev)
 
 	cancel_delayed_work_sync(&ir->work);
 
+	/* Disable IR */
+	au8522_rc_clear(ir, 0xe0, 1 << 4);
+
 	return 0;
 }
 
@@ -390,6 +393,9 @@ int au0828_rc_resume(struct au0828_dev *dev)
 	if (!ir)
 		return 0;
 
+	/* Enable IR */
+	au8522_rc_set(ir, 0xe0, 1 << 4);
+
 	schedule_delayed_work(&ir->work, msecs_to_jiffies(ir->polling));
 
 	return 0;
-- 
1.9.3

