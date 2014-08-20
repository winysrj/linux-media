Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3456 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271AbaHTW7q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Aug 2014 18:59:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 10/29] go7007: fix sparse warnings
Date: Thu, 21 Aug 2014 00:59:09 +0200
Message-Id: <1408575568-20562-11-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl>
References: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/usb/go7007/go7007-usb.c:699:30: warning: cast to restricted __le16
drivers/media/usb/go7007/go7007-usb.c:769:38: warning: cast to restricted __le16
drivers/media/usb/go7007/go7007-usb.c:770:39: warning: cast to restricted __le16

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/go7007/go7007-usb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/go7007/go7007-usb.c b/drivers/media/usb/go7007/go7007-usb.c
index ece27ec..3f986e1 100644
--- a/drivers/media/usb/go7007/go7007-usb.c
+++ b/drivers/media/usb/go7007/go7007-usb.c
@@ -696,7 +696,7 @@ static int go7007_usb_ezusb_write_interrupt(struct go7007 *go,
 				sizeof(status_reg), timeout);
 		if (r < 0)
 			break;
-		status_reg = le16_to_cpu(*((u16 *)go->usb_buf));
+		status_reg = le16_to_cpu(*((__le16 *)go->usb_buf));
 		if (!(status_reg & 0x0010))
 			break;
 		msleep(10);
@@ -751,7 +751,7 @@ static int go7007_usb_onboard_write_interrupt(struct go7007 *go,
 static void go7007_usb_readinterrupt_complete(struct urb *urb)
 {
 	struct go7007 *go = (struct go7007 *)urb->context;
-	u16 *regs = (u16 *)urb->transfer_buffer;
+	__le16 *regs = (__le16 *)urb->transfer_buffer;
 	int status = urb->status;
 
 	if (status) {
-- 
2.1.0.rc1

