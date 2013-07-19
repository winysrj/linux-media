Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1-out2.atlantis.sk ([80.94.52.71]:53077 "EHLO
	mail-1-out2.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704Ab3GSRqn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jul 2013 13:46:43 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 2/2] radio-aztech: Implement signal strength detection and fix stereo detection
Date: Fri, 19 Jul 2013 19:46:18 +0200
Message-Id: <1374255978-1362-2-git-send-email-linux@rainbow-software.org>
In-Reply-To: <1374255978-1362-1-git-send-email-linux@rainbow-software.org>
References: <1374255978-1362-1-git-send-email-linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Current stereo detection code is wrong - it reads TUNED bit instead of STEREO bit.
Fix that and implement signal strength detection too.
Also remove useless s_stereo functionn.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/media/radio/radio-aztech.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/media/radio/radio-aztech.c b/drivers/media/radio/radio-aztech.c
index 2f5671f..705dd6f 100644
--- a/drivers/media/radio/radio-aztech.c
+++ b/drivers/media/radio/radio-aztech.c
@@ -94,21 +94,16 @@ static int aztech_s_frequency(struct radio_isa_card *isa, u32 freq)
 	return 0;
 }
 
-/* thanks to Michael Dwyer for giving me a dose of clues in
- * the signal strength department..
- *
- * This card has a stereo bit - bit 0 set = mono, not set = stereo
- */
 static u32 aztech_g_rxsubchans(struct radio_isa_card *isa)
 {
-	if (inb(isa->io) & 1)
+	if (inb(isa->io) & AZTECH_BIT_MONO)
 		return V4L2_TUNER_SUB_MONO;
 	return V4L2_TUNER_SUB_STEREO;
 }
 
-static int aztech_s_stereo(struct radio_isa_card *isa, bool stereo)
+static u32 aztech_g_signal(struct radio_isa_card *isa)
 {
-	return aztech_s_frequency(isa, isa->freq);
+	return (inb(isa->io) & AZTECH_BIT_NOT_TUNED) ? 0 : 0xffff;
 }
 
 static int aztech_s_mute_volume(struct radio_isa_card *isa, bool mute, int vol)
@@ -126,8 +121,8 @@ static const struct radio_isa_ops aztech_ops = {
 	.alloc = aztech_alloc,
 	.s_mute_volume = aztech_s_mute_volume,
 	.s_frequency = aztech_s_frequency,
-	.s_stereo = aztech_s_stereo,
 	.g_rxsubchans = aztech_g_rxsubchans,
+	.g_signal = aztech_g_signal,
 };
 
 static const int aztech_ioports[] = { 0x350, 0x358 };
-- 
Ondrej Zary

