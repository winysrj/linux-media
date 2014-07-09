Return-path: <linux-media-owner@vger.kernel.org>
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:33124 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750854AbaGIUgX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Jul 2014 16:36:23 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: m.chehab@samsung.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] media: em28xx - remove reset_resume interface
Date: Wed,  9 Jul 2014 14:36:03 -0600
Message-Id: <1404938163-27461-1-git-send-email-shuah.kh@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

em28xx uses resume interface as its reset_resume interface.
If usb device is reset during suspend, reset_resume doesn't
do the necessary initialization which leads to resume failure.
Many systems don't maintain do not maintain suspend current to
the USB host controllers during hibernation. Remove reset_resume
to allow disconnect to be called followed by device restore
sequence.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 15ad470..c53fa77 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3522,7 +3522,6 @@ static struct usb_driver em28xx_usb_driver = {
 	.disconnect = em28xx_usb_disconnect,
 	.suspend = em28xx_usb_suspend,
 	.resume = em28xx_usb_resume,
-	.reset_resume = em28xx_usb_resume,
 	.id_table = em28xx_id_table,
 };
 
-- 
1.7.10.4

