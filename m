Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:45969 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388714AbeKXDAT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Nov 2018 22:00:19 -0500
From: Andreas Pape <ap@ca-pape.de>
To: linux-media@vger.kernel.org, kieran.bingham@ideasonboard.com
Cc: Andreas Pape <ap@ca-pape.de>
Subject: [PATCH 3/3] media: stkwebcam: Bugfix for wrong return values
Date: Fri, 23 Nov 2018 17:14:54 +0100
Message-Id: <20181123161454.3215-4-ap@ca-pape.de>
In-Reply-To: <20181123161454.3215-1-ap@ca-pape.de>
References: <20181123161454.3215-1-ap@ca-pape.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

usb_control_msg returns in case of a successfully sent message the number
of sent bytes as a positive number. Don't use this value as a return value
for stk_camera_read_reg, as a non-zero return value is used as an error
condition in some cases when stk_camera_read_reg is called.

Signed-off-by: Andreas Pape <ap@ca-pape.de>
---
 drivers/media/usb/stkwebcam/stk-webcam.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/stkwebcam/stk-webcam.c b/drivers/media/usb/stkwebcam/stk-webcam.c
index c64928e36a5a..66a3665fc826 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.c
+++ b/drivers/media/usb/stkwebcam/stk-webcam.c
@@ -171,7 +171,11 @@ int stk_camera_read_reg(struct stk_camera *dev, u16 index, u8 *value)
 		*value = *buf;
 
 	kfree(buf);
-	return ret;
+
+	if (ret < 0)
+		return ret;
+	else
+		return 0;
 }
 
 static int stk_start_stream(struct stk_camera *dev)
-- 
2.17.1
