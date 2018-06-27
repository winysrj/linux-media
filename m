Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:44598 "EHLO
        homiemail-a125.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S964870AbeF0PcH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Jun 2018 11:32:07 -0400
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org, mchehab@infradead.org,
        parker.l.reed@gmail.com
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 1/2] em28xx: Remove duplicate PID
Date: Wed, 27 Jun 2018 10:32:00 -0500
Message-Id: <1530113521-26749-2-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1530113521-26749-1-git-send-email-brad@nextdimension.cc>
References: <1530113521-26749-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Half-revert: commit 5b1a270d224b ("media: dvb: add alternative USB PID for Hauppauge WinTV-soloHD")'

The PID already exists on the line above.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 6c84383..c8d60e4 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2688,8 +2688,6 @@ struct usb_device_id em28xx_id_table[] = {
 			.driver_info = EM28178_BOARD_PCTV_292E },
 	{ USB_DEVICE(0x2040, 0x8268), /* Hauppauge Retail WinTV-soloHD Bulk */
 			.driver_info = EM28178_BOARD_PCTV_292E },
-	{ USB_DEVICE(0x2040, 0x8268), /* Hauppauge WinTV-soloHD alt. PID */
-			.driver_info = EM28178_BOARD_PCTV_292E },
 	{ USB_DEVICE(0x0413, 0x6f07),
 			.driver_info = EM2861_BOARD_LEADTEK_VC100 },
 	{ USB_DEVICE(0xeb1a, 0x8179),
-- 
2.7.4
