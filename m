Return-path: <mchehab@pedra>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:33294 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932504Ab1C3O0p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Mar 2011 10:26:45 -0400
Subject: [PATCH] rc-core: fix winbond-cir issues
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: mchehab@redhat.com, skandalfo@gmail.com
Date: Wed, 30 Mar 2011 16:20:14 +0200
Message-ID: <20110330141952.11373.16400.stgit@felix.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The conversion of winbond-cir to use rc-core seems to have missed a
a few bits and pieces which were in my local tree. Kudos to
Juan Jes√∫s Garc√≠a de Soria Lucena <skandalfo@gmail.com> for noticing.

Signed-off-by: David H√§rdeman <david@hardeman.nu>
---
 drivers/media/rc/winbond-cir.c |   20 +++++---------------
 1 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
index 186de55..16f4178 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -7,7 +7,7 @@
  *  with minor modifications.
  *
  *  Original Author: David H‰rdeman <david@hardeman.nu>
- *     Copyright (C) 2009 - 2010 David H‰rdeman <david@hardeman.nu>
+ *     Copyright (C) 2009 - 2011 David H‰rdeman <david@hardeman.nu>
  *
  *  Dedicated to my daughter Matilda, without whose loving attention this
  *  driver would have been finished in half the time and with a fraction
@@ -629,18 +629,8 @@ wbcir_init_hw(struct wbcir_data *data)
 	/* prescaler 1.0, tx/rx fifo lvl 16 */
 	outb(0x30, data->sbase + WBCIR_REG_SP3_EXCR2);
 
-	/* Set baud divisor to generate one byte per bit/cell */
-	switch (protocol) {
-	case IR_PROTOCOL_RC5:
-		outb(0xA7, data->sbase + WBCIR_REG_SP3_BGDL);
-		break;
-	case IR_PROTOCOL_RC6:
-		outb(0x53, data->sbase + WBCIR_REG_SP3_BGDL);
-		break;
-	case IR_PROTOCOL_NEC:
-		outb(0x69, data->sbase + WBCIR_REG_SP3_BGDL);
-		break;
-	}
+	/* Set baud divisor to sample every 10 us */
+	outb(0x0F, data->sbase + WBCIR_REG_SP3_BGDL);
 	outb(0x00, data->sbase + WBCIR_REG_SP3_BGDH);
 
 	/* Set CEIR mode */
@@ -649,9 +639,9 @@ wbcir_init_hw(struct wbcir_data *data)
 	inb(data->sbase + WBCIR_REG_SP3_LSR); /* Clear LSR */
 	inb(data->sbase + WBCIR_REG_SP3_MSR); /* Clear MSR */
 
-	/* Disable RX demod, run-length encoding/decoding, set freq span */
+	/* Disable RX demod, enable run-length enc/dec, set freq span */
 	wbcir_select_bank(data, WBCIR_BANK_7);
-	outb(0x10, data->sbase + WBCIR_REG_SP3_RCCFG);
+	outb(0x90, data->sbase + WBCIR_REG_SP3_RCCFG);
 
 	/* Disable timer */
 	wbcir_select_bank(data, WBCIR_BANK_4);

