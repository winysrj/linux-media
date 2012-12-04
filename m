Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.hauppauge.com ([167.206.143.4]:1609 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab2LDQIG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Dec 2012 11:08:06 -0500
From: Michael Krufky <mkrufky@linuxtv.org>
To: linux-media@vger.kernel.org
Cc: dheitmueller@kernellabs.com, Michael Krufky <mkrufky@linuxtv.org>
Subject: [PATCH 2/2] au0828: break au0828_card_setup() down into smaller functions
Date: Tue,  4 Dec 2012 11:07:45 -0500
Message-Id: <1354637265-23335-2-git-send-email-mkrufky@linuxtv.org>
In-Reply-To: <1354637265-23335-1-git-send-email-mkrufky@linuxtv.org>
References: <1354637265-23335-1-git-send-email-mkrufky@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pull the analog frontend setup code out of au0828_card_setup into its
own seperate function, au0828_card_analog_fe_setup().

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
---
 drivers/media/usb/au0828/au0828-cards.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-cards.c b/drivers/media/usb/au0828/au0828-cards.c
index 7b5b742..88e35df 100644
--- a/drivers/media/usb/au0828/au0828-cards.c
+++ b/drivers/media/usb/au0828/au0828-cards.c
@@ -185,14 +185,11 @@ static void hauppauge_eeprom(struct au0828_dev *dev, u8 *eeprom_data)
 	       __func__, tv.model);
 }
 
+void au0828_card_analog_fe_setup(struct au0828_dev *dev);
+
 void au0828_card_setup(struct au0828_dev *dev)
 {
 	static u8 eeprom[256];
-#ifdef CONFIG_VIDEO_AU0828_V4L2
-	struct tuner_setup tun_setup;
-	struct v4l2_subdev *sd;
-	unsigned int mode_mask = T_ANALOG_TV;
-#endif
 
 	dprintk(1, "%s()\n", __func__);
 
@@ -213,7 +210,16 @@ void au0828_card_setup(struct au0828_dev *dev)
 		break;
 	}
 
+	au0828_card_analog_fe_setup(dev);
+}
+
+void au0828_card_analog_fe_setup(struct au0828_dev *dev)
+{
 #ifdef CONFIG_VIDEO_AU0828_V4L2
+	struct tuner_setup tun_setup;
+	struct v4l2_subdev *sd;
+	unsigned int mode_mask = T_ANALOG_TV;
+
 	if (AUVI_INPUT(0).type != AU0828_VMUX_UNDEFINED) {
 		/* Load the analog demodulator driver (note this would need to
 		   be abstracted out if we ever need to support a different
-- 
1.7.10.4

