Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:63988 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752566AbbL1V5B (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Dec 2015 16:57:01 -0500
Subject: [PATCH] [media] au0828: Refactoring for start_urb_transfer()
References: <566ABCD9.1060404@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
To: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <5681B01F.4070401@users.sourceforge.net>
Date: Mon, 28 Dec 2015 22:56:47 +0100
MIME-Version: 1.0
In-Reply-To: <566ABCD9.1060404@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 28 Dec 2015 22:52:48 +0100

This issue was detected by using the Coccinelle software.

1. Let us return directly if a buffer allocation failed.

2. Delete the jump label "err" then.

3. Drop the explicit initialisation for the variable "ret"
   at the beginning.

4. Return zero as a constant at the end.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/au0828/au0828-dvb.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-dvb.c b/drivers/media/usb/au0828/au0828-dvb.c
index cd542b4..e5f1e20 100644
--- a/drivers/media/usb/au0828/au0828-dvb.c
+++ b/drivers/media/usb/au0828/au0828-dvb.c
@@ -181,7 +181,7 @@ static int stop_urb_transfer(struct au0828_dev *dev)
 static int start_urb_transfer(struct au0828_dev *dev)
 {
 	struct urb *purb;
-	int i, ret = -ENOMEM;
+	int i, ret;
 
 	dprintk(2, "%s()\n", __func__);
 
@@ -194,7 +194,7 @@ static int start_urb_transfer(struct au0828_dev *dev)
 
 		dev->urbs[i] = usb_alloc_urb(0, GFP_KERNEL);
 		if (!dev->urbs[i])
-			goto err;
+			return -ENOMEM;
 
 		purb = dev->urbs[i];
 
@@ -207,9 +207,10 @@ static int start_urb_transfer(struct au0828_dev *dev)
 		if (!purb->transfer_buffer) {
 			usb_free_urb(purb);
 			dev->urbs[i] = NULL;
+			ret = -ENOMEM;
 			pr_err("%s: failed big buffer allocation, err = %d\n",
 			       __func__, ret);
-			goto err;
+			return ret;
 		}
 
 		purb->status = -EINPROGRESS;
@@ -235,10 +236,7 @@ static int start_urb_transfer(struct au0828_dev *dev)
 	}
 
 	dev->urb_streaming = true;
-	ret = 0;
-
-err:
-	return ret;
+	return 0;
 }
 
 static void au0828_start_transport(struct au0828_dev *dev)
-- 
2.6.3

