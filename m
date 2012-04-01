Return-path: <linux-media-owner@vger.kernel.org>
Received: from cassarossa.samfundet.no ([129.241.93.19]:40788 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988Ab2DAPyD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Apr 2012 11:54:03 -0400
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: linux-media@vger.kernel.org
Cc: "Steinar H. Gunderson" <sesse@samfundet.no>
Subject: [PATCH 02/11] Clear out MANTIS_INT_RISCSTAT when printing status bits.
Date: Sun,  1 Apr 2012 17:53:42 +0200
Message-Id: <1333295631-31866-2-git-send-email-sgunderson@bigfoot.com>
In-Reply-To: <20120401155330.GA31901@uio.no>
References: <20120401155330.GA31901@uio.no>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Steinar H. Gunderson" <sesse@samfundet.no>

Clear out MANTIS_INT_RISCSTAT for debugging, so that status words
from the RISC do not show up as "Unknown" bits in the debug display.

Signed-off-by: Steinar H. Gunderson <sesse@samfundet.no>
---
 drivers/media/dvb/mantis/mantis_cards.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb/mantis/mantis_cards.c b/drivers/media/dvb/mantis/mantis_cards.c
index c6c51bd..8e12801 100644
--- a/drivers/media/dvb/mantis/mantis_cards.c
+++ b/drivers/media/dvb/mantis/mantis_cards.c
@@ -141,7 +141,8 @@ static irqreturn_t mantis_irq_handler(int irq, void *dev_id)
 		wake_up(&mantis->i2c_wq);
 	}
 	mmwrite(stat, MANTIS_INT_STAT);
-	stat &= ~(MANTIS_INT_RISCEN   | MANTIS_INT_I2CDONE |
+	stat &= ~(MANTIS_INT_RISCSTAT |
+	          MANTIS_INT_RISCEN   | MANTIS_INT_I2CDONE |
 		  MANTIS_INT_I2CRACK  | MANTIS_INT_PCMCIA7 |
 		  MANTIS_INT_PCMCIA6  | MANTIS_INT_PCMCIA5 |
 		  MANTIS_INT_PCMCIA4  | MANTIS_INT_PCMCIA3 |
-- 
1.7.9.5

