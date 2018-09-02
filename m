Return-path: <linux-media-owner@vger.kernel.org>
Received: from vps.deutnet.info ([92.222.219.9]:50136 "EHLO vps.deutnet.info"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727541AbeIBR1k (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 2 Sep 2018 13:27:40 -0400
Date: Sun, 2 Sep 2018 14:36:40 +0200
From: Alexandre GRIVEAUX <agriveaux@deutnet.info>
To: mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        agriveaux@deutnet.info
Subject: [PATCH] [media] saa7134: add P7131_4871 analog inputs
Message-ID: <20180902123640.4xiyc66rdazzubvo@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The saa7134 Tiger board has a front panel connector at the back (labeled
panel 2 on the PCB), with S-VIDEO, composite and audio.

This patch adds those inputs.

Signed-off-by: Alexandre GRIVEAUX <agriveaux@deutnet.info>
---
 drivers/media/pci/saa7134/saa7134-cards.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/media/pci/saa7134/saa7134-cards.c b/drivers/media/pci/saa7134/saa7134-cards.c
index 9d6688a82b50..40ce033cb884 100644
--- a/drivers/media/pci/saa7134/saa7134-cards.c
+++ b/drivers/media/pci/saa7134/saa7134-cards.c
@@ -3628,6 +3628,21 @@ struct saa7134_board saa7134_boards[] = {
 			.vmux   = 1,
 			.amux   = TV,
 			.gpio   = 0x0200000,
+		},{
+			.type = SAA7134_INPUT_COMPOSITE1,
+			.vmux = 3,
+			.amux = LINE2,
+			.gpio = 0x0200000,
+		},{
+			.type = SAA7134_INPUT_COMPOSITE2,
+			.vmux = 0,
+			.amux = LINE2,
+			.gpio = 0x0200000,
+		},{
+			.type = SAA7134_INPUT_SVIDEO,
+			.vmux = 8,
+			.amux = LINE2,
+			.gpio = 0x0200000,
 		}},
 	},
 	[SAA7134_BOARD_ASUSTeK_P7131_HYBRID_LNA] = {
-- 
2.11.0
