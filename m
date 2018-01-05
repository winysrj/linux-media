Return-path: <linux-media-owner@vger.kernel.org>
Received: from hapkido.dreamhost.com ([66.33.216.122]:43541 "EHLO
        hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751116AbeAEAFR (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Jan 2018 19:05:17 -0500
Received: from homiemail-a116.g.dreamhost.com (sub5.mail.dreamhost.com [208.113.200.129])
        by hapkido.dreamhost.com (Postfix) with ESMTP id 699118ED86
        for <linux-media@vger.kernel.org>; Thu,  4 Jan 2018 16:05:17 -0800 (PST)
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 6/9] em28xx: Enable Hauppauge SoloHD rebranded 292e SE
Date: Thu,  4 Jan 2018 18:04:16 -0600
Message-Id: <1515110659-20145-7-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1515110659-20145-1-git-send-email-brad@nextdimension.cc>
References: <1515110659-20145-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a missing device to the driver table.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 34c693a..66d4c3a 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2619,6 +2619,8 @@ struct usb_device_id em28xx_id_table[] = {
 			.driver_info = EM28178_BOARD_PCTV_461E },
 	{ USB_DEVICE(0x2013, 0x025f),
 			.driver_info = EM28178_BOARD_PCTV_292E },
+	{ USB_DEVICE(0x2013, 0x0264), /* Hauppauge WinTV-soloHD 292e SE */
+			.driver_info = EM28178_BOARD_PCTV_292E },
 	{ USB_DEVICE(0x2040, 0x0264), /* Hauppauge WinTV-soloHD Isoc */
 			.driver_info = EM28178_BOARD_PCTV_292E },
 	{ USB_DEVICE(0x2040, 0x8264), /* Hauppauge OEM Generic WinTV-soloHD Bulk */
-- 
2.7.4
