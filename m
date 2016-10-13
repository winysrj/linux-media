Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:52352 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756893AbcJMQbF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Oct 2016 12:31:05 -0400
Subject: [PATCH 07/18] [media] RedRat3: Improve another size determination in
 redrat3_reset()
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
Message-ID: <35a71a36-7542-68a9-c33c-55df256efc57@users.sourceforge.net>
Date: Thu, 13 Oct 2016 18:28:32 +0200
MIME-Version: 1.0
In-Reply-To: <81cef537-4ad0-3a74-8bde-94707dcd03f4@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 13 Oct 2016 13:23:22 +0200

Replace the specification of a data type by a pointer dereference
as the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/rc/redrat3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 0ac96a4..5832e6f 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -510,7 +510,7 @@ static void redrat3_reset(struct redrat3_dev *rr3)
 	struct device *dev = rr3->dev;
 	int rc, rxpipe, txpipe;
 	u8 *val;
-	int len = sizeof(u8);
+	size_t const len = sizeof(*val);
 
 	rxpipe = usb_rcvctrlpipe(udev, 0);
 	txpipe = usb_sndctrlpipe(udev, 0);
-- 
2.10.1

