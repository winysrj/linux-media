Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.74]:49425 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388714AbeKXDAM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Nov 2018 22:00:12 -0500
From: Andreas Pape <ap@ca-pape.de>
To: linux-media@vger.kernel.org, kieran.bingham@ideasonboard.com
Cc: Andreas Pape <ap@ca-pape.de>
Subject: [PATCH 1/3] media: stkwebcam: Support for ASUS A6VM notebook added.
Date: Fri, 23 Nov 2018 17:14:52 +0100
Message-Id: <20181123161454.3215-2-ap@ca-pape.de>
In-Reply-To: <20181123161454.3215-1-ap@ca-pape.de>
References: <20181123161454.3215-1-ap@ca-pape.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ASUS A6VM notebook has a built in stk11xx webcam which is mounted
in a way that the video is vertically and horizontally flipped.
Therefore this notebook is added to the special handling in the driver
to automatically flip the video into the correct orientation.

Signed-off-by: Andreas Pape <ap@ca-pape.de>
---
 drivers/media/usb/stkwebcam/stk-webcam.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/usb/stkwebcam/stk-webcam.c b/drivers/media/usb/stkwebcam/stk-webcam.c
index e11d5d5b7c26..e61427e50525 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.c
+++ b/drivers/media/usb/stkwebcam/stk-webcam.c
@@ -116,6 +116,13 @@ static const struct dmi_system_id stk_upside_down_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "T12Rg-H")
 		}
 	},
+	{
+		.ident = "ASUS A6VM",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "A6VM")
+		}
+	},
 	{}
 };
 
-- 
2.17.1
