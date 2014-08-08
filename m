Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49764 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183AbaHHKnz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Aug 2014 06:43:55 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 2/3] au0828: handle IR int during suspend/resume
Date: Fri,  8 Aug 2014 07:43:46 -0300
Message-Id: <1407494627-1555-2-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1407494627-1555-1-git-send-email-m.chehab@samsung.com>
References: <1407494627-1555-1-git-send-email-m.chehab@samsung.com>
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
index f8631b9b33d6..4e2c26a5b004 100644
--- a/drivers/media/usb/au0828/au0828-input.c
+++ b/drivers/media/usb/au0828/au0828-input.c
@@ -383,6 +383,9 @@ int au0828_rc_suspend(struct au0828_dev *dev)
 
 	cancel_delayed_work_sync(&ir->work);
 
+	/* Disable IR */
+	au8522_rc_clear(ir, 0xe0, 1 << 4);
+
 	return 0;
 }
 
@@ -393,6 +396,9 @@ int au0828_rc_resume(struct au0828_dev *dev)
 	if (!ir)
 		return 0;
 
+	/* Enable IR */
+	au8522_rc_set(ir, 0xe0, 1 << 4);
+
 	schedule_delayed_work(&ir->work, msecs_to_jiffies(ir->polling));
 
 	return 0;
-- 
1.9.3

