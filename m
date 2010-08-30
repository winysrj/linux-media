Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50033 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754799Ab0H3Iwz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Aug 2010 04:52:55 -0400
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: lirc-list@lists.sourceforge.net
Cc: Jarod Wilson <jarod@wilsonet.com>, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 3/7] IR: fix duty cycle capability
Date: Mon, 30 Aug 2010 11:52:23 +0300
Message-Id: <1283158348-7429-4-git-send-email-maximlevitsky@gmail.com>
In-Reply-To: <1283158348-7429-1-git-send-email-maximlevitsky@gmail.com>
References: <1283158348-7429-1-git-send-email-maximlevitsky@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Due to typo lirc bridge enabled wrong capability.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/media/IR/ir-lirc-codec.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/IR/ir-lirc-codec.c b/drivers/media/IR/ir-lirc-codec.c
index 77b5946..e63f757 100644
--- a/drivers/media/IR/ir-lirc-codec.c
+++ b/drivers/media/IR/ir-lirc-codec.c
@@ -267,7 +267,7 @@ static int ir_lirc_register(struct input_dev *input_dev)
 			features |= LIRC_CAN_SET_SEND_CARRIER;
 
 		if (ir_dev->props->s_tx_duty_cycle)
-			features |= LIRC_CAN_SET_REC_DUTY_CYCLE;
+			features |= LIRC_CAN_SET_SEND_DUTY_CYCLE;
 	}
 
 	if (ir_dev->props->s_rx_carrier_range)
-- 
1.7.0.4

