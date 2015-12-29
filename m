Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:65441 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538AbbL2Lhb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Dec 2015 06:37:31 -0500
Subject: [PATCH] [media] msi2500: Delete an unnecessary check in
 msi2500_set_usb_adc()
References: <566ABCD9.1060404@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
To: linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <5682706C.5010504@users.sourceforge.net>
Date: Tue, 29 Dec 2015 12:37:16 +0100
MIME-Version: 1.0
In-Reply-To: <566ABCD9.1060404@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 29 Dec 2015 12:32:41 +0100

This issue was detected by using the Coccinelle software.

Return the value from a call of the msi2500_ctrl_msg() function
without using an extra check for the variable "ret" at the end.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/msi2500/msi2500.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/usb/msi2500/msi2500.c b/drivers/media/usb/msi2500/msi2500.c
index c104315..2d33033 100644
--- a/drivers/media/usb/msi2500/msi2500.c
+++ b/drivers/media/usb/msi2500/msi2500.c
@@ -839,8 +839,6 @@ static int msi2500_set_usb_adc(struct msi2500_dev *dev)
 		goto err;
 
 	ret = msi2500_ctrl_msg(dev, CMD_WREG, reg3);
-	if (ret)
-		goto err;
 err:
 	return ret;
 }
-- 
2.6.3

