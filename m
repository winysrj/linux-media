Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:43004 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750955AbeCZGG1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Mar 2018 02:06:27 -0400
From: Kai-Heng Feng <kai.heng.feng@canonical.com>
To: mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Subject: [PATCH] media: cx231xx: Add support for AverMedia DVD EZMaker 7
Date: Mon, 26 Mar 2018 14:06:16 +0800
Message-Id: <20180326060616.5354-1-kai.heng.feng@canonical.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

User reports AverMedia DVD EZMaker 7 can be driven by VIDEO_GRABBER.
Add the device to the id_table to make it work.

BugLink: https://bugs.launchpad.net/bugs/1620762
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
 drivers/media/usb/cx231xx/cx231xx-cards.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index f9ec7fedcd5b..da01c5125acb 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -945,6 +945,9 @@ struct usb_device_id cx231xx_id_table[] = {
 	 .driver_info = CX231XX_BOARD_CNXT_RDE_250},
 	{USB_DEVICE(0x0572, 0x58A0),
 	 .driver_info = CX231XX_BOARD_CNXT_RDU_250},
+	/* AverMedia DVD EZMaker 7 */
+	{USB_DEVICE(0x07ca, 0xc039),
+	 .driver_info = CX231XX_BOARD_CNXT_VIDEO_GRABBER},
 	{USB_DEVICE(0x2040, 0xb110),
 	 .driver_info = CX231XX_BOARD_HAUPPAUGE_USB2_FM_PAL},
 	{USB_DEVICE(0x2040, 0xb111),
-- 
2.15.1
