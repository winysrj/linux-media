Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:35469 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757691AbdELKB7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 May 2017 06:01:59 -0400
Received: by mail-wr0-f194.google.com with SMTP id g12so6952015wrg.2
        for <linux-media@vger.kernel.org>; Fri, 12 May 2017 03:01:58 -0700 (PDT)
From: Johan Hovold <johan@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH] [media] usbvision: add missing USB-descriptor endianness conversions
Date: Fri, 12 May 2017 12:01:30 +0200
Message-Id: <20170512100130.1527-1-johan@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the missing endianness conversions to a debug call printing the
USB device-descriptor idVendor and idProduct fields during probe.

Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/media/usb/usbvision/usbvision-video.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/usbvision/usbvision-video.c b/drivers/media/usb/usbvision/usbvision-video.c
index f9c3325aa4d4..756322c4ac05 100644
--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -1427,8 +1427,8 @@ static int usbvision_probe(struct usb_interface *intf,
 	int model, i, ret;
 
 	PDEBUG(DBG_PROBE, "VID=%#04x, PID=%#04x, ifnum=%u",
-				dev->descriptor.idVendor,
-				dev->descriptor.idProduct, ifnum);
+				le16_to_cpu(dev->descriptor.idVendor),
+				le16_to_cpu(dev->descriptor.idProduct), ifnum);
 
 	model = devid->driver_info;
 	if (model < 0 || model >= usbvision_device_data_size) {
-- 
2.13.0
