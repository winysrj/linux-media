Return-path: <linux-media-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:48324 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751965Ab0BVJpK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 04:45:10 -0500
Message-ID: <4B825223.7030904@ladisch.de>
Date: Mon, 22 Feb 2010 10:45:07 +0100
From: Clemens Ladisch <clemens@ladisch.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] cx88-alsa: prevent out-of-range volume setting
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ensure that volume values are always in the allowed range.  Otherwise,
it would be possible to set other bits in the AUD_VOL_CTL register or to
get a wrong sign in the AUD_BAL_CTL register.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>

--- linux/drivers/media/video/cx88/cx88-alsa.c
+++ linux/drivers/media/video/cx88/cx88-alsa.c
@@ -583,16 +583,18 @@ static int snd_cx88_volume_put(struct sn
 {
 	snd_cx88_card_t *chip = snd_kcontrol_chip(kcontrol);
 	struct cx88_core *core=chip->core;
-	int v, b;
+	int left, right, v, b;
 	int changed = 0;
 	u32 old;
 
-	b = value->value.integer.value[1] - value->value.integer.value[0];
+	left = value->value.integer.value[0] & 0x3f;
+	right = value->value.integer.value[1] & 0x3f;
+	b = right - left;
 	if (b < 0) {
-	    v = 0x3f - value->value.integer.value[0];
+	    v = 0x3f - left;
 	    b = (-b) | 0x40;
 	} else {
-	    v = 0x3f - value->value.integer.value[1];
+	    v = 0x3f - right;
 	}
 	/* Do we really know this will always be called with IRQs on? */
 	spin_lock_irq(&chip->reg_lock);
