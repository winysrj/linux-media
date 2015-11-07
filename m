Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38903 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244AbbKGMWf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Nov 2015 07:22:35 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] airspy: increase USB control message buffer size
Date: Sat,  7 Nov 2015 14:22:09 +0200
Message-Id: <1446898929-6572-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Driver requested device firmware version string during probe using
only 24 byte long buffer. That buffer is too small for newer firmware
versions, which causes device firmware hang - device stops responding
to any commands after that. Increase buffer size to 128 which should
be enough for any current and future version strings.

Cc: <stable@vger.kernel.org> # 3.17+
Link: https://github.com/airspy/host/issues/27
Reported-by: Benjamin Vernoux <bvernoux@gmail.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/airspy/airspy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/airspy/airspy.c b/drivers/media/usb/airspy/airspy.c
index fcbb497..565a593 100644
--- a/drivers/media/usb/airspy/airspy.c
+++ b/drivers/media/usb/airspy/airspy.c
@@ -134,7 +134,7 @@ struct airspy {
 	int            urbs_submitted;
 
 	/* USB control message buffer */
-	#define BUF_SIZE 24
+	#define BUF_SIZE 128
 	u8 buf[BUF_SIZE];
 
 	/* Current configuration */
-- 
http://palosaari.fi/

