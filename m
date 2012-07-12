Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46647 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933870Ab2GLUzQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jul 2012 16:55:16 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: hverkuil@xs4all.nl, halli manjunatha <hallimanju@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 3/5] radio-si470x: restore ctrl settings after suspend/resume
Date: Thu, 12 Jul 2012 22:55:46 +0200
Message-Id: <1342126548-19349-4-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1342126548-19349-1-git-send-email-hdegoede@redhat.com>
References: <1342126548-19349-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/radio/si470x/radio-si470x-usb.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/radio/si470x/radio-si470x-usb.c b/drivers/media/radio/si470x/radio-si470x-usb.c
index 40b963c..0204cf4 100644
--- a/drivers/media/radio/si470x/radio-si470x-usb.c
+++ b/drivers/media/radio/si470x/radio-si470x-usb.c
@@ -792,11 +792,16 @@ static int si470x_usb_driver_suspend(struct usb_interface *intf,
 static int si470x_usb_driver_resume(struct usb_interface *intf)
 {
 	struct si470x_device *radio = usb_get_intfdata(intf);
+	int ret;
 
 	dev_info(&intf->dev, "resuming now...\n");
 
 	/* start radio */
-	return si470x_start_usb(radio);
+	ret = si470x_start_usb(radio);
+	if (ret == 0)
+		v4l2_ctrl_handler_setup(&radio->hdl);
+
+	return ret;
 }
 
 
-- 
1.7.10.4

