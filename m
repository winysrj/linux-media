Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38553 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771Ab2HWUdH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Aug 2012 16:33:07 -0400
Received: by yenl14 with SMTP id l14so290742yen.19
        for <linux-media@vger.kernel.org>; Thu, 23 Aug 2012 13:33:06 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH] stk1160: Remove unused 'ifnum' variable
Date: Thu, 23 Aug 2012 17:32:57 -0300
Message-Id: <1345753977-14239-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since ifnum is not used anywhere it is safe to remove it.
This was spotted by Hans's media_tree daily build.

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/usb/stk1160/stk1160-core.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/stk1160/stk1160-core.c b/drivers/media/usb/stk1160/stk1160-core.c
index 74236fd..b627408 100644
--- a/drivers/media/usb/stk1160/stk1160-core.c
+++ b/drivers/media/usb/stk1160/stk1160-core.c
@@ -256,14 +256,12 @@ static int stk1160_scan_usb(struct usb_interface *intf, struct usb_device *udev,
 static int stk1160_probe(struct usb_interface *interface,
 		const struct usb_device_id *id)
 {
-	int ifnum;
 	int rc = 0;
 
 	unsigned int *alt_max_pkt_size;	/* array of wMaxPacketSize */
 	struct usb_device *udev;
 	struct stk1160 *dev;
 
-	ifnum = interface->altsetting[0].desc.bInterfaceNumber;
 	udev = interface_to_usbdev(interface);
 
 	/*
-- 
1.7.4.4

