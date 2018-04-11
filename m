Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:35322 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752334AbeDKDX4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Apr 2018 23:23:56 -0400
From: Jia-Ju Bai <baijiaju1990@gmail.com>
To: mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH 1/3] media: dvb-usb: Replace GFP_ATOMIC with GFP_KERNEL in usb_allocate_stream_buffers
Date: Wed, 11 Apr 2018 11:23:49 +0800
Message-Id: <1523417029-3069-1-git-send-email-baijiaju1990@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

usb_allocate_stream_buffers() is never called in atomic context.

The call chains ending up at usb_allocate_stream_buffers() are:
[1] usb_allocate_stream_buffers() <- usb_bulk_urb_init() <- usb_urb_init()
	<- dvb_usb_adapter_stream_init() <- dvb_usb_adapter_init 
	<- dvb_usb_init() <- dvb_usb_device_init() <- xxx_probe()
[2] usb_allocate_stream_buffers() <- usb_isoc_urb_init() <- usb_urb_init()
	<- dvb_usb_adapter_stream_init() <- dvb_usb_adapter_init 
	<- dvb_usb_init() <- dvb_usb_device_init() <- xxx_probe()
xxx_probe including ttusb2_probe, vp7045_usb_probe, a800_probe, and so on.
These xxx_probe() functions are set as ".probe" in struct usb_driver.
And these functions are not called in atomic context.

Despite never getting called from atomic context,
usb_allocate_stream_buffers() calls usb_alloc_coherent() with GFP_ATOMIC,
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
index 8917360..96be721 100644
--- a/drivers/media/usb/dvb-usb/usb-urb.c
+++ b/drivers/media/usb/dvb-usb/usb-urb.c
@@ -117,7 +117,7 @@ static int usb_allocate_stream_buffers(struct usb_data_stream *stream, int num,
 	for (stream->buf_num = 0; stream->buf_num < num; stream->buf_num++) {
 		deb_mem("allocating buffer %d\n",stream->buf_num);
 		if (( stream->buf_list[stream->buf_num] =
-					usb_alloc_coherent(stream->udev, size, GFP_ATOMIC,
+					usb_alloc_coherent(stream->udev, size, GFP_KERNEL,
 					&stream->dma_addr[stream->buf_num]) ) == NULL) {
 			deb_mem("not enough memory for urb-buffer allocation.\n");
 			usb_free_stream_buffers(stream);
-- 
1.9.1
