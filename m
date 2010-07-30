Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45907 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758488Ab0G3LjP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jul 2010 07:39:15 -0400
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: lirc-list@lists.sourceforge.net
Cc: Jarod Wilson <jarod@wilsonet.com>, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 06/13] IR: nec decoder: fix repeat.
Date: Fri, 30 Jul 2010 14:38:46 +0300
Message-Id: <1280489933-20865-7-git-send-email-maximlevitsky@gmail.com>
In-Reply-To: <1280489933-20865-1-git-send-email-maximlevitsky@gmail.com>
References: <1280489933-20865-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Repeat space is 4 units, not 8.
Current code would never trigger a repeat.

However that isn't true for NECX, so repeat there
must be handled differently.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/media/IR/ir-nec-decoder.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/IR/ir-nec-decoder.c b/drivers/media/IR/ir-nec-decoder.c
index 52e0f37..1c0cf03 100644
--- a/drivers/media/IR/ir-nec-decoder.c
+++ b/drivers/media/IR/ir-nec-decoder.c
@@ -20,7 +20,7 @@
 #define NEC_HEADER_PULSE	(16 * NEC_UNIT)
 #define NECX_HEADER_PULSE	(8  * NEC_UNIT) /* Less common NEC variant */
 #define NEC_HEADER_SPACE	(8  * NEC_UNIT)
-#define NEC_REPEAT_SPACE	(8  * NEC_UNIT)
+#define NEC_REPEAT_SPACE	(4  * NEC_UNIT)
 #define NEC_BIT_PULSE		(1  * NEC_UNIT)
 #define NEC_BIT_0_SPACE		(1  * NEC_UNIT)
 #define NEC_BIT_1_SPACE		(3  * NEC_UNIT)
-- 
1.7.0.4

