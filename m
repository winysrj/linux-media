Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60724 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564Ab3KBQdk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Nov 2013 12:33:40 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Krufky <mkrufky@kernellabs.com>
Subject: [PATCHv2 28/29] mxl111sf: Don't use dynamic static allocation
Date: Sat,  2 Nov 2013 11:31:36 -0200
Message-Id: <1383399097-11615-29-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1383399097-11615-1-git-send-email-m.chehab@samsung.com>
References: <1383399097-11615-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dynamic static allocation is evil, as Kernel stack is too low, and
compilation complains about it on some archs:

	drivers/media/usb/dvb-usb-v2/mxl111sf.c:74:1: warning: 'mxl111sf_ctrl_msg' uses dynamic stack allocation [enabled by default]

Instead, let's enforce a limit for the buffer to be the max size of
a control URB payload data (80 bytes).

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Michael Krufky <mkrufky@kernellabs.com>
---
 drivers/media/usb/dvb-usb-v2/mxl111sf.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf.c b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
index e97964ef7f56..6538fd54c84e 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
@@ -57,7 +57,12 @@ int mxl111sf_ctrl_msg(struct dvb_usb_device *d,
 {
 	int wo = (rbuf == NULL || rlen == 0); /* write-only */
 	int ret;
-	u8 sndbuf[1+wlen];
+	u8 sndbuf[80];
+
+	if (1 + wlen > sizeof(sndbuf)) {
+		pr_warn("%s: len=%d is too big!\n", __func__, wlen);
+		return -EREMOTEIO;
+	}
 
 	pr_debug("%s(wlen = %d, rlen = %d)\n", __func__, wlen, rlen);
 
-- 
1.8.3.1

