Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:45506 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933787Ab0DHXEk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Apr 2010 19:04:40 -0400
Subject: [PATCH 3/4] Add NECx support to ir-core
To: mchehab@redhat.com
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: linux-input@vger.kernel.org, linux-media@vger.kernel.org
Date: Fri, 09 Apr 2010 01:04:35 +0200
Message-ID: <20100408230435.14453.56505.stgit@localhost.localdomain>
In-Reply-To: <20100408230246.14453.97377.stgit@localhost.localdomain>
References: <20100408230246.14453.97377.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds NECx support to drivers/media/IR/ir-nec-decoder.c

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/IR/ir-nec-decoder.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/media/IR/ir-nec-decoder.c b/drivers/media/IR/ir-nec-decoder.c
index f22d1af..d128c19 100644
--- a/drivers/media/IR/ir-nec-decoder.c
+++ b/drivers/media/IR/ir-nec-decoder.c
@@ -18,6 +18,7 @@
 #define NEC_NBITS		32
 #define NEC_UNIT		562500  /* ns */
 #define NEC_HEADER_PULSE	PULSE(16)
+#define NECX_HEADER_PULSE	PULSE(8) /* Less common NEC variant */
 #define NEC_HEADER_SPACE	SPACE(8)
 #define NEC_REPEAT_SPACE	SPACE(4)
 #define NEC_BIT_PULSE		PULSE(1)
@@ -152,7 +153,7 @@ static int ir_nec_decode(struct input_dev *input_dev, s64 duration)
 	switch (data->state) {
 
 	case STATE_INACTIVE:
-		if (u == NEC_HEADER_PULSE) {
+		if (u == NEC_HEADER_PULSE || u == NECX_HEADER_PULSE) {
 			data->count = 0;
 			data->state = STATE_HEADER_SPACE;
 		}

