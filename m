Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:60318 "EHLO
        homiemail-a58.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751730AbeBAWEn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Feb 2018 17:04:43 -0500
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH v2 2/9] em28xx: Bulk transfer implementation fix
Date: Thu,  1 Feb 2018 16:04:37 -0600
Message-Id: <1517522677-21211-1-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1515110659-20145-3-git-send-email-brad@nextdimension.cc>
References: <1515110659-20145-3-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Set appropriate bulk/ISOC transfer multiplier on capture start.
This sets ISOC transfer to USB endpoint configuration
This sets bulk transfer to 48128 bytes (188 * 256)

The bulk multiplier is maximum allowed according to Empia.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
Changes since v1
- use ISOC endpoint configuration instead of constant
- removed TS2 from comment

  drivers/media/usb/em28xx/em28xx-core.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index ef38e56..6727d14 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -638,6 +638,19 @@ int em28xx_capture_start(struct em28xx *dev, int start)
 	    dev->chip_id == CHIP_ID_EM28174 ||
 	    dev->chip_id == CHIP_ID_EM28178) {
 		/* The Transport Stream Enable Register moved in em2874 */
+		if (dev->dvb_xfer_bulk) {
+			/* Max Tx Size = 188 * 256 = 48128 - LCM(188,512) * 2 */
+			em28xx_write_reg(dev, (dev->ts == PRIMARY_TS) ?
+					EM2874_R5D_TS1_PKT_SIZE :
+					EM2874_R5E_TS2_PKT_SIZE,
+					0xFF);
+		} else {
+			/* ISOC Maximum Transfer Size = 188 * 5 */
+			em28xx_write_reg(dev, (dev->ts == PRIMARY_TS) ?
+					EM2874_R5D_TS1_PKT_SIZE :
+					EM2874_R5E_TS2_PKT_SIZE,
+					dev->dvb_max_pkt_size_isoc / 188);
+		}
 		if (dev->ts == PRIMARY_TS)
 			rc = em28xx_write_reg_bits(dev,
 				EM2874_R5F_TS_ENABLE,
-- 
2.7.4
