Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:35473 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757839Ab2KAMmH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Nov 2012 08:42:07 -0400
Received: by mail-gh0-f174.google.com with SMTP id g15so459258ghb.19
        for <linux-media@vger.kernel.org>; Thu, 01 Nov 2012 05:42:06 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: <linux-media@vger.kernel.org>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>,
	Andrea Anacleto <andreaanacleto@libero.it>,
	Arvydas Sidorenko <asido4@gmail.com>,
	Jaime Velasco Juan <jsagarribay@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH] stkwebcam: Fix sparse warning on undeclared symbol
Date: Thu,  1 Nov 2012 09:42:00 -0300
Message-Id: <1351773720-22639-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The sparse warning is:
"drivers/media/usb/stkwebcam/stk-webcam.c:59:5:
warning: symbol 'first_init' was not declared. Should it be static?"

Declare variable 'first_init' as static and local to the function.
Found by Hans Verkuil's daily build. Tested by compilation only.

Cc: Andrea Anacleto <andreaanacleto@libero.it>
Cc: Arvydas Sidorenko <asido4@gmail.com>
Cc: Jaime Velasco Juan <jsagarribay@gmail.com>
Cc: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
Ouch, there doesn't seem to be an active maintainer for this.
If anyone has a device and can give it a try, it would be nice.
The change is pretty simple anyway.

Also, why the heck do we need this first_init?
To prevent the led from blinking on udev first open?

 drivers/media/usb/stkwebcam/stk-webcam.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/stkwebcam/stk-webcam.c b/drivers/media/usb/stkwebcam/stk-webcam.c
index 86a0fc5..5d3c032 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.c
+++ b/drivers/media/usb/stkwebcam/stk-webcam.c
@@ -54,10 +54,6 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jaime Velasco Juan <jsagarribay@gmail.com> and Nicolas VIVIEN");
 MODULE_DESCRIPTION("Syntek DC1125 webcam driver");
 
-
-/* bool for webcam LED management */
-int first_init = 1;
-
 /* Some cameras have audio interfaces, we aren't interested in those */
 static struct usb_device_id stkwebcam_table[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x174f, 0xa311, 0xff, 0xff, 0xff) },
@@ -554,6 +550,7 @@ static void stk_free_buffers(struct stk_camera *dev)
 
 static int v4l_stk_open(struct file *fp)
 {
+	static int first_init = 1; /* webcam LED management */
 	struct stk_camera *dev;
 	struct video_device *vdev;
 
-- 
1.7.8.6

