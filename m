Return-path: <linux-media-owner@vger.kernel.org>
Received: from top.free-electrons.com ([176.31.233.9]:55479 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751335AbaDQM3W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Apr 2014 08:29:22 -0400
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH v2] media: stk1160: Avoid stack-allocated buffer for control URBs
Date: Thu, 17 Apr 2014 09:28:20 -0300
Message-Id: <1397737700-1081-1-git-send-email-ezequiel.garcia@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently stk1160_read_reg() uses a stack-allocated char to get the
read control value. This is wrong because usb_control_msg() requires
a kmalloc-ed buffer.

This commit fixes such issue by kmalloc'ating a 1-byte buffer to receive
the read value.

While here, let's remove the urb_buf array which was meant for a similar
purpose, but never really used.

Cc: Alan Stern <stern@rowland.harvard.edu>
Reported-by: Sander Eikelenboom <linux@eikelenboom.it>
Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
---
 drivers/media/usb/stk1160/stk1160-core.c | 10 +++++++++-
 drivers/media/usb/stk1160/stk1160.h      |  1 -
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/stk1160/stk1160-core.c b/drivers/media/usb/stk1160/stk1160-core.c
index 34a26e0..03504dc 100644
--- a/drivers/media/usb/stk1160/stk1160-core.c
+++ b/drivers/media/usb/stk1160/stk1160-core.c
@@ -67,17 +67,25 @@ int stk1160_read_reg(struct stk1160 *dev, u16 reg, u8 *value)
 {
 	int ret;
 	int pipe = usb_rcvctrlpipe(dev->udev, 0);
+	u8 *buf;
 
 	*value = 0;
+
+	buf = kmalloc(sizeof(u8), GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
 	ret = usb_control_msg(dev->udev, pipe, 0x00,
 			USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-			0x00, reg, value, sizeof(u8), HZ);
+			0x00, reg, buf, sizeof(u8), HZ);
 	if (ret < 0) {
 		stk1160_err("read failed on reg 0x%x (%d)\n",
 			reg, ret);
+		kfree(buf);
 		return ret;
 	}
 
+	*value = *buf;
+	kfree(buf);
 	return 0;
 }
 
diff --git a/drivers/media/usb/stk1160/stk1160.h b/drivers/media/usb/stk1160/stk1160.h
index 05b05b1..abdea48 100644
--- a/drivers/media/usb/stk1160/stk1160.h
+++ b/drivers/media/usb/stk1160/stk1160.h
@@ -143,7 +143,6 @@ struct stk1160 {
 	int num_alt;
 
 	struct stk1160_isoc_ctl isoc_ctl;
-	char urb_buf[255];	 /* urb control msg buffer */
 
 	/* frame properties */
 	int width;		  /* current frame width */
-- 
1.9.1

