Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.220.in.ua ([89.184.67.205]:33613 "EHLO smtp.220.in.ua"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751367AbdA2SHe (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 29 Jan 2017 13:07:34 -0500
From: Oleh Kravchenko <oleg@kaa.org.ua>
To: Steven Toth <stoth@kernellabs.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jacob Johan Verkuil <hverkuil@xs4all.nl>,
        Antti Palosaari <crope@iki.fi>
Cc: Oleh Kravchenko <oleg@kaa.org.ua>
Subject: [PATCH] [media] cx231xx: Fix I2C on Internal Master 3 Bus
Date: Sun, 29 Jan 2017 20:07:31 +0200
Message-Id: <20170129180731.8708-1-oleg@kaa.org.ua>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Internal Master 3 Bus can send and receive only 4 bytes per time.

Signed-off-by: Oleh Kravchenko <oleg@kaa.org.ua>
---
 drivers/media/usb/cx231xx/cx231xx-core.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-core.c b/drivers/media/usb/cx231xx/cx231xx-core.c
index 550ec93..46646ec 100644
--- a/drivers/media/usb/cx231xx/cx231xx-core.c
+++ b/drivers/media/usb/cx231xx/cx231xx-core.c
@@ -355,7 +355,12 @@ int cx231xx_send_vendor_cmd(struct cx231xx *dev,
 	 */
 	if ((ven_req->wLength > 4) && ((ven_req->bRequest == 0x4) ||
 					(ven_req->bRequest == 0x5) ||
-					(ven_req->bRequest == 0x6))) {
+					(ven_req->bRequest == 0x6) ||
+
+					/* Internal Master 3 Bus can send
+					 * and receive only 4 bytes per time
+					 */
+					(ven_req->bRequest == 0x2))) {
 		unsend_size = 0;
 		pdata = ven_req->pBuff;
 
-- 
2.10.2

