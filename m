Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40748 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462Ab3CKR0H (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 13:26:07 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] m920x: silence compiler warning
Date: Mon, 11 Mar 2013 19:25:10 +0200
Message-Id: <1363022710-27886-1-git-send-email-crope@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/usb/dvb-usb/m920x.c: In function ‘m920x_probe’:
drivers/media/usb/dvb-usb/m920x.c:91:6: warning: ‘ret’ may be used uninitialized in this function [-Wuninitialized]
drivers/media/usb/dvb-usb/m920x.c:70:6: note: ‘ret’ was declared here

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb/m920x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb/m920x.c b/drivers/media/usb/dvb-usb/m920x.c
index 92afeb2..f5e4654 100644
--- a/drivers/media/usb/dvb-usb/m920x.c
+++ b/drivers/media/usb/dvb-usb/m920x.c
@@ -67,7 +67,7 @@ static inline int m920x_write(struct usb_device *udev, u8 request,
 static inline int m920x_write_seq(struct usb_device *udev, u8 request,
 				  struct m920x_inits *seq)
 {
-	int ret;
+	int ret = 0;
 	while (seq->address) {
 		ret = m920x_write(udev, request, seq->data, seq->address);
 		if (ret != 0)
-- 
1.7.11.7

