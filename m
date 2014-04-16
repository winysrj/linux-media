Return-path: <linux-media-owner@vger.kernel.org>
Received: from forward1h.mail.yandex.net ([84.201.187.146]:57975 "EHLO
	forward1h.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbaDPUWH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Apr 2014 16:22:07 -0400
Received: from smtp4h.mail.yandex.net (smtp4h.mail.yandex.net [84.201.186.21])
	by forward1h.mail.yandex.net (Yandex) with ESMTP id C52B59E1156
	for <linux-media@vger.kernel.org>; Thu, 17 Apr 2014 00:22:04 +0400 (MSK)
Received: from smtp4h.mail.yandex.net (localhost [127.0.0.1])
	by smtp4h.mail.yandex.net (Yandex) with ESMTP id 934072C3534
	for <linux-media@vger.kernel.org>; Thu, 17 Apr 2014 00:22:04 +0400 (MSK)
From: CrazyCat <crazycat69@narod.ru>
To: linux-media@vger.kernel.org
Subject: [PATCH] technisat-sub2: Fix stream curruption on high bitrate
Date: Wed, 16 Apr 2014 23:22:01 +0300
Message-ID: <3539618.frtlsOTgfg@ubuntu>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix stream curruption on high bitrate (>60mbit).

Signed-off-by: Evgeny Plehov <EvgenyPlehov@ukr.net>
---
 drivers/media/usb/dvb-usb/technisat-usb2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb/technisat-usb2.c b/drivers/media/usb/dvb-usb/technisat-usb2.c
index 420198f..4604c084 100644
--- a/drivers/media/usb/dvb-usb/technisat-usb2.c
+++ b/drivers/media/usb/dvb-usb/technisat-usb2.c
@@ -711,7 +711,7 @@ static struct dvb_usb_device_properties technisat_usb2_devices = {
 					.isoc = {
 						.framesperurb = 32,
 						.framesize = 2048,
-						.interval = 3,
+						.interval = 1,
 					}
 				}
 			},
-- 
1.7.9.5

