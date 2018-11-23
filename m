Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.73]:46667 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388714AbeKXDAR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Nov 2018 22:00:17 -0500
From: Andreas Pape <ap@ca-pape.de>
To: linux-media@vger.kernel.org, kieran.bingham@ideasonboard.com
Cc: Andreas Pape <ap@ca-pape.de>
Subject: [PATCH 2/3] media: stkwebcam: Bugfix for not correctly initialized camera
Date: Fri, 23 Nov 2018 17:14:53 +0100
Message-Id: <20181123161454.3215-3-ap@ca-pape.de>
In-Reply-To: <20181123161454.3215-1-ap@ca-pape.de>
References: <20181123161454.3215-1-ap@ca-pape.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

stk_start_stream can only be called successfully if stk_initialise and
stk_setup_format are called before. When using e.g. cheese it was observed
that stk_initialise and stk_setup_format have not been called before which
leads to no picture in that software whereas other tools like guvcview
worked flawlessly. This patch solves the issue when using e.g. cheese.

Signed-off-by: Andreas Pape <ap@ca-pape.de>
---
 drivers/media/usb/stkwebcam/stk-webcam.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/stkwebcam/stk-webcam.c b/drivers/media/usb/stkwebcam/stk-webcam.c
index e61427e50525..c64928e36a5a 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.c
+++ b/drivers/media/usb/stkwebcam/stk-webcam.c
@@ -1155,6 +1155,8 @@ static int stk_vidioc_streamon(struct file *filp,
 	if (dev->sio_bufs == NULL)
 		return -EINVAL;
 	dev->sequence = 0;
+	stk_initialise(dev);
+	stk_setup_format(dev);
 	return stk_start_stream(dev);
 }
 
-- 
2.17.1
