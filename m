Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway36.websitewelcome.com ([50.116.125.2]:18925 "EHLO
        gateway36.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752095AbdHLSRD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 Aug 2017 14:17:03 -0400
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway36.websitewelcome.com (Postfix) with ESMTP id D24D34013C1A0
        for <linux-media@vger.kernel.org>; Sat, 12 Aug 2017 12:31:00 -0500 (CDT)
Date: Sat, 12 Aug 2017 12:30:59 -0500
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Julia Lawall <julia.lawall@lip6.fr>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] au0828: fix unbalanced lock/unlock in au0828_usb_probe
Message-ID: <20170812173059.GA20047@embeddedgus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Call mutex_unlock and free dev on failure.

Reported-by: Julia Lawall <julia.lawall@lip6.fr>
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/media/usb/au0828/au0828-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 739df61..cd363a2 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -628,6 +628,8 @@ static int au0828_usb_probe(struct usb_interface *interface,
 	if (retval) {
 		pr_err("%s() au0282_dev_register failed to register on V4L2\n",
 			__func__);
+		mutex_unlock(&dev->lock);
+		kfree(dev);
 		goto done;
 	}
 
-- 
2.5.0
