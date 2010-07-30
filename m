Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53717 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758379Ab0G3CRv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jul 2010 22:17:51 -0400
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: lirc-list@lists.sourceforge.net
Cc: Jarod Wilson <jarod@wilsonet.com>, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 07/13] IR: NECX: support repeat
Date: Fri, 30 Jul 2010 05:17:09 +0300
Message-Id: <1280456235-2024-8-git-send-email-maximlevitsky@gmail.com>
In-Reply-To: <1280456235-2024-1-git-send-email-maximlevitsky@gmail.com>
References: <1280456235-2024-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds support for repeat detecting for NECX variant
Tested with uneversal remote

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/media/IR/ir-core-priv.h   |    1 +
 drivers/media/IR/ir-nec-decoder.c |   16 ++++++++++++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/media/IR/ir-core-priv.h b/drivers/media/IR/ir-core-priv.h
index dc26e2b..494e1f8 100644
--- a/drivers/media/IR/ir-core-priv.h
+++ b/drivers/media/IR/ir-core-priv.h
@@ -45,6 +45,7 @@ struct ir_raw_event_ctrl {
 		int state;
 		unsigned count;
 		u32 bits;
+		bool is_nec_x;
 	} nec;
 	struct rc5_dec {
 		int state;
diff --git a/drivers/media/IR/ir-nec-decoder.c b/drivers/media/IR/ir-nec-decoder.c
index 1c0cf03..59127b1 100644
--- a/drivers/media/IR/ir-nec-decoder.c
+++ b/drivers/media/IR/ir-nec-decoder.c
@@ -26,6 +26,7 @@
 #define NEC_BIT_1_SPACE		(3  * NEC_UNIT)
 #define	NEC_TRAILER_PULSE	(1  * NEC_UNIT)
 #define	NEC_TRAILER_SPACE	(10 * NEC_UNIT) /* even longer in reality */
+#define NECX_REPEAT_BITS	1
 
 enum nec_state {
 	STATE_INACTIVE,
@@ -67,8 +68,11 @@ static int ir_nec_decode(struct input_dev *input_dev, struct ir_raw_event ev)
 		if (!ev.pulse)
 			break;
 
-		if (!eq_margin(ev.duration, NEC_HEADER_PULSE, NEC_UNIT / 2) &&
-		    !eq_margin(ev.duration, NECX_HEADER_PULSE, NEC_UNIT / 2))
+		if (eq_margin(ev.duration, NEC_HEADER_PULSE, NEC_UNIT / 2))
+			data->is_nec_x = false;
+		else if (eq_margin(ev.duration, NECX_HEADER_PULSE, NEC_UNIT / 2))
+			data->is_nec_x = true;
+		else
 			break;
 
 		data->count = 0;
@@ -105,6 +109,14 @@ static int ir_nec_decode(struct input_dev *input_dev, struct ir_raw_event ev)
 		if (ev.pulse)
 			break;
 
+		if (geq_margin(ev.duration, NEC_TRAILER_SPACE, NEC_UNIT / 2) &&
+			data->is_nec_x && data->count == NECX_REPEAT_BITS) {
+				IR_dprintk(1, "Repeat last key\n");
+				ir_repeat(input_dev);
+				data->state = STATE_INACTIVE;
+				return 0;
+			}
+
 		data->bits <<= 1;
 		if (eq_margin(ev.duration, NEC_BIT_1_SPACE, NEC_UNIT / 2))
 			data->bits |= 1;
-- 
1.7.0.4

