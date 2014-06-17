Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-111.synserver.de ([212.40.185.111]:1073 "EHLO
	smtp-out-111.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754825AbaFQLwi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jun 2014 07:52:38 -0400
From: Lars-Peter Clausen <lars@metafoo.de>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] [media] adv7604: Update recommended writes for the adv7611
Date: Tue, 17 Jun 2014 13:52:24 +0200
Message-Id: <1403005944-27745-1-git-send-email-lars@metafoo.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update the recommended writes to those mentioned in the Rev 1.5 version of the
ADV7611 Register Settings Recommendations document released by Analog Devices.
The document does not mention why the recommended settings have been updated,
but presumably those are more fine tuned settings that can enhance performance
in some cases.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/media/i2c/adv7604.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 1778d32..d4fa213 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2588,8 +2588,11 @@ static const struct adv7604_reg_seq adv7604_recommended_settings_hdmi[] = {
 };
 
 static const struct adv7604_reg_seq adv7611_recommended_settings_hdmi[] = {
+	/* ADV7611 Register Settings Recommendations Rev 1.5, May 2014 */
 	{ ADV7604_REG(ADV7604_PAGE_CP, 0x6c), 0x00 },
-	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x6f), 0x0c },
+	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x9b), 0x03 },
+	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x6f), 0x08 },
+	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x85), 0x1f },
 	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x87), 0x70 },
 	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x57), 0xda },
 	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x58), 0x01 },
-- 
1.8.0

