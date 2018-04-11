Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:45221 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752103AbeDKDYL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Apr 2018 23:24:11 -0400
From: Jia-Ju Bai <baijiaju1990@gmail.com>
To: mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH 2/3] media: dvb-usb: Replace GFP_ATOMIC with GFP_KERNEL in usb_bulk_urb_init
Date: Wed, 11 Apr 2018 11:24:04 +0800
Message-Id: <1523417044-3115-1-git-send-email-baijiaju1990@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

usb_bulk_urb_init() is never called in atomic context.

The call chains ending up at usb_bulk_urb_init() are:
[1] usb_bulk_urb_init() <- usb_urb_init()
	<- dvb_usb_adapter_stream_init() <- dvb_usb_adapter_init 
	<- dvb_usb_init() <- dvb_usb_device_init() <- xxx_probe()
xxx_probe including ttusb2_probe, vp7045_usb_probe, a800_probe, and so on.
These xxx_probe() functions are set as ".probe" in struct usb_driver.
And these functions are not called in atomic context.

Despite never getting called from atomic context,
usb_bulk_urb_init() calls usb_alloc_urb() with GFP_ATOMIC,
which does not sleep for allocation.
GFP_ATOMIC is not necessary and can be replaced with GFP_KERNEL,
which can sleep and improve the possibility of sucessful allocation.

This is found by a static analysis tool named DCNS written by myself.
And I also manually check it.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/media/usb/dvb-usb/usb-urb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb/usb-urb.c b/drivers/media/usb/dvb-usb/usb-urb.c
index 8917360..d6d62e8 100644
--- a/drivers/media/usb/dvb-usb/usb-urb.c
+++ b/drivers/media/usb/dvb-usb/usb-urb.c
@@ -144,7 +144,7 @@ static int usb_bulk_urb_init(struct usb_data_stream *stream)
 
 	/* allocate the URBs */
 	for (i = 0; i < stream->props.count; i++) {
-		stream->urb_list[i] = usb_alloc_urb(0, GFP_ATOMIC);
+		stream->urb_list[i] = usb_alloc_urb(0, GFP_KERNEL);
 		if (!stream->urb_list[i]) {
 			deb_mem("not enough memory for urb_alloc_urb!.\n");
 			for (j = 0; j < i; j++)
-- 
1.9.1
