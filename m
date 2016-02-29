Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbcB2TR6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Feb 2016 14:17:58 -0500
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Wesley Post <pa4wdh@xs4all.nl>, Hans Verkuil <hverkuil@xs4all.nl>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 1/2] gspca: Fix ov519 i2c r/w not working when connected to a xhci host
Date: Mon, 29 Feb 2016 20:17:51 +0100
Message-Id: <1456773472-8334-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wesley Post <pa4wdh@xs4all.nl>

Fix the ov519 driver not working (unable to talk to the sensor) when
plugged into a xhci host. The root cause here is that uhci/ohci/ehci
hosts typically will send any pending async requests every milli-second
and then go to sleep for the rest if the milli-second, where as xhci hosts
send them immediately, causing things to go too fast for the ov519 bridge.

This commit adds a few delays fixing this.

Tested-by: Wesley Post <pa4wdh@xs4all.nl>
Signed-off-by: Wesley Post <pa4wdh@xs4all.nl>
[hdegoede@redhat.com: Also add delays to w996Xcf.c, as that needs them too]
Tested-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/usb/gspca/ov519.c   | 9 +++++++++
 drivers/media/usb/gspca/w996Xcf.c | 8 ++++++++
 2 files changed, 17 insertions(+)

diff --git a/drivers/media/usb/gspca/ov519.c b/drivers/media/usb/gspca/ov519.c
index c95f32a..eb668e7 100644
--- a/drivers/media/usb/gspca/ov519.c
+++ b/drivers/media/usb/gspca/ov519.c
@@ -2042,6 +2042,9 @@ static void reg_w(struct sd *sd, u16 index, u16 value)
 	if (sd->gspca_dev.usb_err < 0)
 		return;
 
+	/* Avoid things going to fast for the bridge with a xhci host */
+	udelay(150);
+
 	switch (sd->bridge) {
 	case BRIDGE_OV511:
 	case BRIDGE_OV511PLUS:
@@ -2103,6 +2106,8 @@ static int reg_r(struct sd *sd, u16 index)
 		req = 1;
 	}
 
+	/* Avoid things going to fast for the bridge with a xhci host */
+	udelay(150);
 	ret = usb_control_msg(sd->gspca_dev.dev,
 			usb_rcvctrlpipe(sd->gspca_dev.dev, 0),
 			req,
@@ -2131,6 +2136,8 @@ static int reg_r8(struct sd *sd,
 	if (sd->gspca_dev.usb_err < 0)
 		return -1;
 
+	/* Avoid things going to fast for the bridge with a xhci host */
+	udelay(150);
 	ret = usb_control_msg(sd->gspca_dev.dev,
 			usb_rcvctrlpipe(sd->gspca_dev.dev, 0),
 			1,			/* REQ_IO */
@@ -2187,6 +2194,8 @@ static void ov518_reg_w32(struct sd *sd, u16 index, u32 value, int n)
 
 	*((__le32 *) sd->gspca_dev.usb_buf) = __cpu_to_le32(value);
 
+	/* Avoid things going to fast for the bridge with a xhci host */
+	udelay(150);
 	ret = usb_control_msg(sd->gspca_dev.dev,
 			usb_sndctrlpipe(sd->gspca_dev.dev, 0),
 			1 /* REG_IO */,
diff --git a/drivers/media/usb/gspca/w996Xcf.c b/drivers/media/usb/gspca/w996Xcf.c
index fb9fe2e..896f1b2 100644
--- a/drivers/media/usb/gspca/w996Xcf.c
+++ b/drivers/media/usb/gspca/w996Xcf.c
@@ -79,6 +79,8 @@ static void w9968cf_write_fsb(struct sd *sd, u16* data)
 	value = *data++;
 	memcpy(sd->gspca_dev.usb_buf, data, 6);
 
+	/* Avoid things going to fast for the bridge with a xhci host */
+	udelay(150);
 	ret = usb_control_msg(udev, usb_sndctrlpipe(udev, 0), 0,
 			      USB_TYPE_VENDOR | USB_DIR_OUT | USB_RECIP_DEVICE,
 			      value, 0x06, sd->gspca_dev.usb_buf, 6, 500);
@@ -99,6 +101,9 @@ static void w9968cf_write_sb(struct sd *sd, u16 value)
 	if (sd->gspca_dev.usb_err < 0)
 		return;
 
+	/* Avoid things going to fast for the bridge with a xhci host */
+	udelay(150);
+
 	/* We don't use reg_w here, as that would cause all writes when
 	   bitbanging i2c to be logged, making the logs impossible to read */
 	ret = usb_control_msg(sd->gspca_dev.dev,
@@ -126,6 +131,9 @@ static int w9968cf_read_sb(struct sd *sd)
 	if (sd->gspca_dev.usb_err < 0)
 		return -1;
 
+	/* Avoid things going to fast for the bridge with a xhci host */
+	udelay(150);
+
 	/* We don't use reg_r here, as the w9968cf is special and has 16
 	   bit registers instead of 8 bit */
 	ret = usb_control_msg(sd->gspca_dev.dev,
-- 
2.7.2

