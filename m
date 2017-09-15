Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:59141 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750787AbdIOHye (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Sep 2017 03:54:34 -0400
Subject: [PATCH 5/9] [media] tm6000: Delete an unnecessary variable
 initialisation in tm6000_usb_probe()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Andi Shyti <andi.shyti@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Christophe Jaillet <christophe.jaillet@wanadoo.fr>,
        =?UTF-8?Q?David_H=c3=a4rdeman?= <david@hardeman.nu>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Santosh Kumar Singh <kumar.san1093@gmail.com>,
        Sean Young <sean@mess.org>,
        Wei Yongjun <weiyongjun1@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <2aade468-5dfd-76ee-f59f-c25864930f61@users.sourceforge.net>
Message-ID: <9c547e6f-8a78-ec7b-2054-dd64708d5823@users.sourceforge.net>
Date: Fri, 15 Sep 2017 09:53:39 +0200
MIME-Version: 1.0
In-Reply-To: <2aade468-5dfd-76ee-f59f-c25864930f61@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 14 Sep 2017 16:13:56 +0200

The local variable "rc" will be set to an appropriate value a bit later.
Thus omit the explicit initialisation at the beginning.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/tm6000/tm6000-cards.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/tm6000/tm6000-cards.c b/drivers/media/usb/tm6000/tm6000-cards.c
index 77347541904d..72dd6b80394f 100644
--- a/drivers/media/usb/tm6000/tm6000-cards.c
+++ b/drivers/media/usb/tm6000/tm6000-cards.c
@@ -1185,7 +1185,7 @@ static int tm6000_usb_probe(struct usb_interface *interface,
 {
 	struct usb_device *usbdev;
 	struct tm6000_core *dev;
-	int i, rc = 0;
+	int i, rc;
 	int nr = 0;
 	char *speed;
 
-- 
2.14.1
