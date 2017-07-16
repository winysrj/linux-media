Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35313 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751268AbdGPOxP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 16 Jul 2017 10:53:15 -0400
Received: by mail-wm0-f67.google.com with SMTP id u23so18845112wma.2
        for <linux-media@vger.kernel.org>; Sun, 16 Jul 2017 07:53:14 -0700 (PDT)
From: Philipp Zabel <philipp.zabel@gmail.com>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 2/3] [media] uvcvideo: flag variable length control on Oculus Rift CV1 Sensor
Date: Sun, 16 Jul 2017 16:53:04 +0200
Message-Id: <20170716145305.19934-2-philipp.zabel@gmail.com>
In-Reply-To: <20170716145305.19934-1-philipp.zabel@gmail.com>
References: <20170716145305.19934-1-philipp.zabel@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The extension unit controls with selectors 11 and 12 are used to make the
eSP770u webcam controller issue SPI transfers to configure the nRF51288
radio or to read the flash storage. Depending on internal state controlled
by selector 11, selector 12 reports different lengths.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/usb/uvc/uvc_ctrl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index 43e8851cc381..1d60321a6777 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -1613,6 +1613,9 @@ static void uvc_ctrl_fixup_xu_info(struct uvc_device *dev,
 			UVC_CTRL_FLAG_GET_MIN | UVC_CTRL_FLAG_GET_MAX |
 			UVC_CTRL_FLAG_GET_DEF | UVC_CTRL_FLAG_SET_CUR |
 			UVC_CTRL_FLAG_AUTO_UPDATE },
+		{ { USB_DEVICE(0x2833, 0x0211) }, 4, 12,
+			UVC_CTRL_FLAG_GET_RANGE | UVC_CTRL_FLAG_SET_CUR |
+			UVC_CTRL_FLAG_VARIABLE_LEN },
 	};
 
 	unsigned int i;
-- 
2.13.2
