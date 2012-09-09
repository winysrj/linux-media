Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42428 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188Ab2IISBm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Sep 2012 14:01:42 -0400
Received: by eekc1 with SMTP id c1so640416eek.19
        for <linux-media@vger.kernel.org>; Sun, 09 Sep 2012 11:01:41 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: hdegoede@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 1/6] gspca_pac7302: add support for device 1ae7:2001 Speedlink Snappy Microphone SL-6825-SBK
Date: Sun,  9 Sep 2012 20:02:19 +0200
Message-Id: <1347213744-8509-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
Cc: stable@kernel.org
---
 drivers/media/usb/gspca/pac7302.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/usb/gspca/pac7302.c b/drivers/media/usb/gspca/pac7302.c
index 4877f7a..e906f56 100644
--- a/drivers/media/usb/gspca/pac7302.c
+++ b/drivers/media/usb/gspca/pac7302.c
@@ -905,6 +905,7 @@ static const struct usb_device_id device_table[] = {
 	{USB_DEVICE(0x093a, 0x262a)},
 	{USB_DEVICE(0x093a, 0x262c)},
 	{USB_DEVICE(0x145f, 0x013c)},
+	{USB_DEVICE(0x1ae7, 0x2001)}, /* SpeedLink Snappy Mic SL-6825-SBK */
 	{}
 };
 MODULE_DEVICE_TABLE(usb, device_table);
-- 
1.7.7

