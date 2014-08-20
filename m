Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1782 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252AbaHTW7o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Aug 2014 18:59:44 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 08/29] opera1: fix sparse warnings
Date: Thu, 21 Aug 2014 00:59:07 +0200
Message-Id: <1408575568-20562-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl>
References: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/usb/dvb-usb/opera1.c:557:29: warning: restricted __le16 degrades to integer
drivers/media/usb/dvb-usb/opera1.c:558:33: warning: restricted __le16 degrades to integer

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/dvb-usb/opera1.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/opera1.c b/drivers/media/usb/dvb-usb/opera1.c
index 16ba90a..14a2119 100644
--- a/drivers/media/usb/dvb-usb/opera1.c
+++ b/drivers/media/usb/dvb-usb/opera1.c
@@ -554,8 +554,8 @@ static int opera1_probe(struct usb_interface *intf,
 {
 	struct usb_device *udev = interface_to_usbdev(intf);
 
-	if (udev->descriptor.idProduct == USB_PID_OPERA1_WARM &&
-		udev->descriptor.idVendor == USB_VID_OPERA1 &&
+	if (le16_to_cpu(udev->descriptor.idProduct) == USB_PID_OPERA1_WARM &&
+	    le16_to_cpu(udev->descriptor.idVendor) == USB_VID_OPERA1 &&
 		opera1_xilinx_load_firmware(udev, "dvb-usb-opera1-fpga-01.fw") != 0
 	    ) {
 		return -EINVAL;
-- 
2.1.0.rc1

