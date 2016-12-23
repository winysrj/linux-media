Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:34516 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758095AbcLWTe6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Dec 2016 14:34:58 -0500
Received: by mail-pg0-f66.google.com with SMTP id b1so1390808pgc.1
        for <linux-media@vger.kernel.org>; Fri, 23 Dec 2016 11:34:58 -0800 (PST)
From: Shyam Saini <mayhs11saini@gmail.com>
To: mchehab@kernel.org
Cc: wsa-dev@sang-engineering.com, hans.verkuil@cisco.com,
        gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        Shyam Saini <mayhs11saini@gmail.com>
Subject: [PATCH] media: usb: cpia2: Use kmemdup instead of kmalloc and memcpy
Date: Sat, 24 Dec 2016 01:04:36 +0530
Message-Id: <1482521676-884-1-git-send-email-mayhs11saini@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When some other buffer is immediately copied into allocated region.
Replace calls to kmalloc followed by a memcpy with a direct
call to kmemdup.

Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>
---
 drivers/media/usb/cpia2/cpia2_usb.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/usb/cpia2/cpia2_usb.c b/drivers/media/usb/cpia2/cpia2_usb.c
index 37f9b30..ce36331 100644
--- a/drivers/media/usb/cpia2/cpia2_usb.c
+++ b/drivers/media/usb/cpia2/cpia2_usb.c
@@ -551,12 +551,10 @@ static int write_packet(struct usb_device *udev,
 	if (!registers || size <= 0)
 		return -EINVAL;
 
-	buf = kmalloc(size, GFP_KERNEL);
+	buf = kmemdup(registers, size, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
-	memcpy(buf, registers, size);
-
 	ret = usb_control_msg(udev,
 			       usb_sndctrlpipe(udev, 0),
 			       request,
-- 
2.7.4

