Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:57244 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727095AbeINXiT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Sep 2018 19:38:19 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 3/4] media: em28xx: fix input name for Terratec AV 350
Date: Fri, 14 Sep 2018 15:22:33 -0300
Message-Id: <878961938591640ca84b327df760f467cb2c0c5e.1536949178.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1536949178.git.mchehab+samsung@kernel.org>
References: <cover.1536949178.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1536949178.git.mchehab+samsung@kernel.org>
References: <cover.1536949178.git.mchehab+samsung@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using a register value, use an AMUX name, as otherwise
VIDIOC_G_AUDIO would fail.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index e9ab1fbc8f0d..2a3f3e237d05 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2141,13 +2141,13 @@ const struct em28xx_board em28xx_boards[] = {
 		.input           = { {
 			.type     = EM28XX_VMUX_COMPOSITE,
 			.vmux     = TVP5150_COMPOSITE1,
-			.amux     = EM28XX_AUDIO_SRC_LINE,
+			.amux     = EM28XX_AMUX_LINE_IN,
 			.gpio     = terratec_av350_unmute_gpio,
 
 		}, {
 			.type     = EM28XX_VMUX_SVIDEO,
 			.vmux     = TVP5150_SVIDEO,
-			.amux     = EM28XX_AUDIO_SRC_LINE,
+			.amux     = EM28XX_AMUX_LINE_IN,
 			.gpio     = terratec_av350_unmute_gpio,
 		} },
 	},
-- 
2.17.1
