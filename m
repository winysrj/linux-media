Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:58242 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751851AbdITTM6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 15:12:58 -0400
Subject: [PATCH 2/3] [media] dvb-ttusb-budget: Improve two size determinations
 in ttusb_probe()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <1ad3c3ce-3738-fee1-2ee5-37142fa1bc70@users.sourceforge.net>
Message-ID: <404d5faa-432b-9649-4b9e-f0cdf1c18338@users.sourceforge.net>
Date: Wed, 20 Sep 2017 21:12:39 +0200
MIME-Version: 1.0
In-Reply-To: <1ad3c3ce-3738-fee1-2ee5-37142fa1bc70@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 20 Sep 2017 20:46:11 +0200

* The script "checkpatch.pl" pointed information out like the following.

  ERROR: do not use assignment in if condition

  Thus fix an affected source code place.

* Replace the specification of data structures by variable references
  as the parameter for the operator "sizeof" to make the corresponding size
  determination a bit safer according to the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c b/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
index 38394c9ecc67..fef3c8554e91 100644
--- a/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
+++ b/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
@@ -1657,7 +1657,8 @@ static int ttusb_probe(struct usb_interface *intf, const struct usb_device_id *i
 
 	if (intf->altsetting->desc.bInterfaceNumber != 1) return -ENODEV;
 
-	if (!(ttusb = kzalloc(sizeof(struct ttusb), GFP_KERNEL)))
+	ttusb = kzalloc(sizeof(*ttusb), GFP_KERNEL);
+	if (!ttusb)
 		return -ENOMEM;
 
 	ttusb->dev = udev;
@@ -1692,7 +1693,7 @@ static int ttusb_probe(struct usb_interface *intf, const struct usb_device_id *i
 	ttusb->adapter.priv = ttusb;
 
 	/* i2c */
-	memset(&ttusb->i2c_adap, 0, sizeof(struct i2c_adapter));
+	memset(&ttusb->i2c_adap, 0, sizeof(ttusb->i2c_adap));
 	strcpy(ttusb->i2c_adap.name, "TTUSB DEC");
 
 	i2c_set_adapdata(&ttusb->i2c_adap, ttusb);
-- 
2.14.1
