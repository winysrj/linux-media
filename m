Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway30.websitewelcome.com ([192.185.149.4]:38938 "EHLO
        gateway30.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750751AbdEIVw5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 May 2017 17:52:57 -0400
Received: from cm5.websitewelcome.com (cm5.websitewelcome.com [108.167.139.22])
        by gateway30.websitewelcome.com (Postfix) with ESMTP id D6F4F156A8
        for <linux-media@vger.kernel.org>; Tue,  9 May 2017 16:30:23 -0500 (CDT)
Date: Tue, 9 May 2017 16:30:21 -0500
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] media: usb: au0828: remove dead code
Message-ID: <20170509213021.GA4486@embeddedgus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Local variable _ret_ is assigned to a constant value and it is never
updated again. Remove this variable and the dead code it guards.

Addresses-Coverity-ID: 112968
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/media/usb/au0828/au0828-video.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 16f9125..abc80b0 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -809,16 +809,10 @@ static void au0828_analog_stream_reset(struct au0828_dev *dev)
  */
 static int au0828_stream_interrupt(struct au0828_dev *dev)
 {
-	int ret = 0;
-
 	dev->stream_state = STREAM_INTERRUPT;
 	if (test_bit(DEV_DISCONNECTED, &dev->dev_state))
 		return -ENODEV;
-	else if (ret) {
-		set_bit(DEV_MISCONFIGURED, &dev->dev_state);
-		dprintk(1, "%s device is misconfigured!\n", __func__);
-		return ret;
-	}
+
 	return 0;
 }
 
-- 
2.5.0
