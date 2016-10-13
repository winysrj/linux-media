Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:65058 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933289AbcJMQob (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Oct 2016 12:44:31 -0400
Subject: [PATCH 15/18] [media] RedRat3: Delete two variables in
 redrat3_set_timeout()
To: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>,
        Wolfram Sang <wsa-dev@sang-engineering.com>
References: <566ABCD9.1060404@users.sourceforge.net>
 <81cef537-4ad0-3a74-8bde-94707dcd03f4@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <13722bff-ec67-0282-b779-52c78b5667f8@users.sourceforge.net>
Date: Thu, 13 Oct 2016 18:43:58 +0200
MIME-Version: 1.0
In-Reply-To: <81cef537-4ad0-3a74-8bde-94707dcd03f4@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 13 Oct 2016 15:40:33 +0200

* Use the data structure members "dev" and "udev" directly
  without assigning them to intermediate variables.
  Thus delete the extra variable definitions at the beginning.

* Fix indentation for the parameters of two function calls.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/rc/redrat3.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 055f214..e46a92a 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -476,8 +476,6 @@ static u32 redrat3_get_timeout(struct redrat3_dev *rr3)
 static int redrat3_set_timeout(struct rc_dev *rc_dev, unsigned int timeoutns)
 {
 	struct redrat3_dev *rr3 = rc_dev->priv;
-	struct usb_device *udev = rr3->udev;
-	struct device *dev = rr3->dev;
 	__be32 *timeout;
 	int ret;
 
@@ -486,13 +484,17 @@ static int redrat3_set_timeout(struct rc_dev *rc_dev, unsigned int timeoutns)
 		return -ENOMEM;
 
 	*timeout = cpu_to_be32(redrat3_us_to_len(timeoutns / 1000));
-	ret = usb_control_msg(udev, usb_sndctrlpipe(udev, 0), RR3_SET_IR_PARAM,
-		     USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
-		     RR3_IR_IO_SIG_TIMEOUT, 0, timeout, sizeof(*timeout),
-		     HZ * 25);
-	dev_dbg(dev, "set ir parm timeout %d ret 0x%02x\n",
-						be32_to_cpu(*timeout), ret);
-
+	ret = usb_control_msg(rr3->udev,
+			      usb_sndctrlpipe(rr3->udev, 0),
+			      RR3_SET_IR_PARAM,
+			      USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
+			      RR3_IR_IO_SIG_TIMEOUT,
+			      0,
+			      timeout,
+			      sizeof(*timeout),
+			      HZ * 25);
+	dev_dbg(rr3->dev, "set ir parm timeout %d ret 0x%02x\n",
+		be32_to_cpu(*timeout), ret);
 	if (ret == sizeof(*timeout)) {
 		rr3->hw_timeout = timeoutns / 1000;
 		ret = 0;
-- 
2.10.1

