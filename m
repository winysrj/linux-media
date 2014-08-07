Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49208 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757254AbaHGNqj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Aug 2014 09:46:39 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] au0828-input: Be sure that IR is enabled at polling
Date: Thu,  7 Aug 2014 10:46:30 -0300
Message-Id: <1407419190-10031-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When the DVB code sets the frontend, it disables the IR
INT, probably due to some hardware bug, as there's no code
there at au8522 frontend that writes on register 0xe0.

Fixing it at au8522 code is hard, as it doesn't know if the
IR is enabled or disabled, and just restoring the value of
register 0xe0 could cause other nasty effects. So, better
to add a hack at au0828-input polling interval to enable int,
if disabled.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/au0828/au0828-input.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-input.c b/drivers/media/usb/au0828/au0828-input.c
index 94d29c2a6fcf..b4475706dfd2 100644
--- a/drivers/media/usb/au0828/au0828-input.c
+++ b/drivers/media/usb/au0828/au0828-input.c
@@ -94,14 +94,19 @@ static int au8522_rc_read(struct au0828_rc *ir, u16 reg, int val,
 static int au8522_rc_andor(struct au0828_rc *ir, u16 reg, u8 mask, u8 value)
 {
 	int rc;
-	char buf;
+	char buf, oldbuf;
 
 	rc = au8522_rc_read(ir, reg, -1, &buf, 1);
 	if (rc < 0)
 		return rc;
 
+	oldbuf = buf;
 	buf = (buf & ~mask) | (value & mask);
 
+	/* Nothing to do, just return */
+	if (buf == oldbuf)
+		return 0;
+
 	return au8522_rc_write(ir, reg, buf);
 }
 
@@ -127,8 +132,11 @@ static int au0828_get_key_au8522(struct au0828_rc *ir)
 
 	/* Check IR int */
 	rc = au8522_rc_read(ir, 0xe1, -1, buf, 1);
-	if (rc < 0 || !(buf[0] & (1 << 4)))
+	if (rc < 0 || !(buf[0] & (1 << 4))) {
+		/* Be sure that IR is enabled */
+	        au8522_rc_set(ir, 0xe0, 1 << 4);
 		return 0;
+	}
 
 	/* Something arrived. Get the data */
 	rc = au8522_rc_read(ir, 0xe3, 0x11, buf, sizeof(buf));
-- 
1.9.3

