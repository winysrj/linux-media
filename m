Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35399 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932290AbaHGQKe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Aug 2014 12:10:34 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/3] au0828: no need to sleep at the IR code.
Date: Thu,  7 Aug 2014 13:10:24 -0300
Message-Id: <1407427826-12886-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This sleep was doing some debouncing on the original driver.
This is not needed on Linux, because the RC core and the input
layer already takes care of it.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/au0828/au0828-input.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-input.c b/drivers/media/usb/au0828/au0828-input.c
index d527446d008f..53d2c59355f2 100644
--- a/drivers/media/usb/au0828/au0828-input.c
+++ b/drivers/media/usb/au0828/au0828-input.c
@@ -136,8 +136,6 @@ static int au0828_get_key_au8522(struct au0828_rc *ir)
 	/* Disable IR */
 	au8522_rc_clear(ir, 0xe0, 1 << 4);
 
-	usleep_range(45000, 46000);
-
 	/* Enable IR */
 	au8522_rc_set(ir, 0xe0, 1 << 4);
 
-- 
1.9.3

