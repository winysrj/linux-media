Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753076AbcAVKyF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jan 2016 05:54:05 -0500
From: Hans de Goede <hdegoede@redhat.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	klucznik <klucznik0@op.pl>, Hans de Goede <hdegoede@redhat.com>,
	stable@vger.kernel.org
Subject: [PATCH] pwc: Add USB id for Philips Spc880nc webcam
Date: Fri, 22 Jan 2016 11:53:55 +0100
Message-Id: <1453460035-17062-2-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1453460035-17062-1-git-send-email-hdegoede@redhat.com>
References: <1453460035-17062-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cc: stable@vger.kernel.org
Reported-by: klucznik <klucznik0@op.pl>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/usb/pwc/pwc-if.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
index 086cf1c..18aed5d 100644
--- a/drivers/media/usb/pwc/pwc-if.c
+++ b/drivers/media/usb/pwc/pwc-if.c
@@ -91,6 +91,7 @@ static const struct usb_device_id pwc_device_table [] = {
 	{ USB_DEVICE(0x0471, 0x0312) },
 	{ USB_DEVICE(0x0471, 0x0313) }, /* the 'new' 720K */
 	{ USB_DEVICE(0x0471, 0x0329) }, /* Philips SPC 900NC PC Camera */
+	{ USB_DEVICE(0x0471, 0x032C) }, /* Philips SPC 880NC PC Camera */
 	{ USB_DEVICE(0x069A, 0x0001) }, /* Askey */
 	{ USB_DEVICE(0x046D, 0x08B0) }, /* Logitech QuickCam Pro 3000 */
 	{ USB_DEVICE(0x046D, 0x08B1) }, /* Logitech QuickCam Notebook Pro */
@@ -810,6 +811,11 @@ static int usb_pwc_probe(struct usb_interface *intf, const struct usb_device_id
 			name = "Philips SPC 900NC webcam";
 			type_id = 740;
 			break;
+		case 0x032C:
+			PWC_INFO("Philips SPC 880NC USB webcam detected.\n");
+			name = "Philips SPC 880NC webcam";
+			type_id = 740;
+			break;
 		default:
 			return -ENODEV;
 			break;
-- 
2.5.0

