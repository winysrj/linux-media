Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.hauppauge.com ([167.206.143.4]:4910 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259Ab2K1Qf0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Nov 2012 11:35:26 -0500
From: Michael Krufky <mkrufky@linuxtv.org>
To: linux-media@vger.kernel.org
Cc: Michael Krufky <mkrufky@linuxtv.org>
Subject: [PATCH 2/2] au0828: update model matrix entries for 72261, 72271 & 72281
Date: Wed, 28 Nov 2012 11:35:01 -0500
Message-Id: <1354120501-4819-2-git-send-email-mkrufky@linuxtv.org>
In-Reply-To: <1354120501-4819-1-git-send-email-mkrufky@linuxtv.org>
References: <1354120501-4819-1-git-send-email-mkrufky@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
---
 drivers/media/usb/au0828/au0828-cards.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-cards.c b/drivers/media/usb/au0828/au0828-cards.c
index d12bdd3..cf309d8 100644
--- a/drivers/media/usb/au0828/au0828-cards.c
+++ b/drivers/media/usb/au0828/au0828-cards.c
@@ -169,8 +169,9 @@ static void hauppauge_eeprom(struct au0828_dev *dev, u8 *eeprom_data)
 	case 72231: /* WinTV-HVR950q (OEM, IR, ATSC/QAM and analog video */
 	case 72241: /* WinTV-HVR950q (OEM, No IR, ATSC/QAM and analog video */
 	case 72251: /* WinTV-HVR950q (Retail, IR, ATSC/QAM and analog video */
-	case 72261: /* WinTV-HVR950q (OEM, IR, ATSC/QAM and analog video */
-	case 72281: /* WinTV-HVR950q (OEM, No IR, ATSC/QAM */
+	case 72261: /* WinTV-HVR950q (OEM, No IR, ATSC/QAM and analog video */
+	case 72271: /* WinTV-HVR950q (OEM, No IR, ATSC/QAM and analog video */
+	case 72281: /* WinTV-HVR950q (OEM, No IR, ATSC/QAM and analog video */
 	case 72301: /* WinTV-HVR850 (Retail, IR, ATSC and analog video */
 	case 72500: /* WinTV-HVR950q (OEM, No IR, ATSC/QAM */
 		break;
-- 
1.7.10.4

