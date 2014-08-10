Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55296 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbaHJArh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Aug 2014 20:47:37 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Shuah Khan <shuah.kh@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 10/18] [media] au0828: Remove a bad whitespace
Date: Sat,  9 Aug 2014 21:47:16 -0300
Message-Id: <1407631644-11990-11-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1407631644-11990-1-git-send-email-m.chehab@samsung.com>
References: <1407631644-11990-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/au0828/au0828-dvb.c   | 0
 drivers/media/usb/au0828/au0828-input.c | 2 +-
 2 files changed, 1 insertion(+), 1 deletion(-)
 mode change 100755 => 100644 drivers/media/usb/au0828/au0828-dvb.c

diff --git a/drivers/media/usb/au0828/au0828-dvb.c b/drivers/media/usb/au0828/au0828-dvb.c
old mode 100755
new mode 100644
diff --git a/drivers/media/usb/au0828/au0828-input.c b/drivers/media/usb/au0828/au0828-input.c
index 7a5437a4d938..5efb83977f39 100644
--- a/drivers/media/usb/au0828/au0828-input.c
+++ b/drivers/media/usb/au0828/au0828-input.c
@@ -133,7 +133,7 @@ static int au0828_get_key_au8522(struct au0828_rc *ir)
 	rc = au8522_rc_read(ir, 0xe1, -1, buf, 1);
 	if (rc < 0 || !(buf[0] & (1 << 4))) {
 		/* Be sure that IR is enabled */
-	        au8522_rc_set(ir, 0xe0, 1 << 4);
+		au8522_rc_set(ir, 0xe0, 1 << 4);
 		return 0;
 	}
 
-- 
1.9.3

