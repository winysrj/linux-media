Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52956 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757476Ab0DFSSs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Apr 2010 14:18:48 -0400
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o36IIlA9019236
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 6 Apr 2010 14:18:48 -0400
Date: Tue, 6 Apr 2010 15:18:01 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 19/26] ir-nec-decoder: Cleanups
Message-ID: <20100406151801.3367584c@pedra>
In-Reply-To: <cover.1270577768.git.mchehab@redhat.com>
References: <cover.1270577768.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove dead code and properly name a few constants

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/IR/ir-nec-decoder.c b/drivers/media/IR/ir-nec-decoder.c
index 33b260f..087211c 100644
--- a/drivers/media/IR/ir-nec-decoder.c
+++ b/drivers/media/IR/ir-nec-decoder.c
@@ -14,38 +14,14 @@
 
 #include <media/ir-core.h>
 
+#define NEC_NBITS		32
 #define NEC_UNIT		559979 /* ns */
 #define NEC_HEADER_MARK		(16 * NEC_UNIT)
 #define NEC_HEADER_SPACE	(8 * NEC_UNIT)
 #define NEC_REPEAT_SPACE	(4 * NEC_UNIT)
 #define NEC_MARK		(NEC_UNIT)
-#define NEC_0_SYMBOL		(NEC_UNIT)
-#define NEC_1_SYMBOL		(3 * NEC_UNIT)
-
-/* Start time: 4.5 ms + 560 us of the next pulse */
-#define MIN_START_TIME	(3900000 + 560000)
-#define MAX_START_TIME	(5100000 + 560000)
-
-/* Bit 1 time: 2.25ms us */
-#define MIN_BIT1_TIME	2050000
-#define MAX_BIT1_TIME	2450000
-
-/* Bit 0 time: 1.12ms us */
-#define MIN_BIT0_TIME	920000
-#define MAX_BIT0_TIME	1320000
-
-/* Total IR code is 110 ms, including the 9 ms for the start pulse */
-#define MAX_NEC_TIME	4000000
-
-/* Total IR code is 110 ms, including the 9 ms for the start pulse */
-#define MIN_REPEAT_TIME	99000000
-#define MAX_REPEAT_TIME	112000000
-
-/* Repeat time: 2.25ms us */
-#define MIN_REPEAT_START_TIME	2050000
-#define MAX_REPEAT_START_TIME	3000000
-
-#define REPEAT_TIME	240 /* ms */
+#define NEC_0_SPACE		(NEC_UNIT)
+#define NEC_1_SPACE		(3 * NEC_UNIT)
 
 /* Used to register nec_decoder clients */
 static LIST_HEAD(decoder_list);
@@ -223,11 +199,11 @@ static int handle_event(struct input_dev *input_dev,
 		if (last_bit)
 			goto err;
 
-		if ((ev->delta.tv_nsec >= NEC_0_SYMBOL - NEC_UNIT / 2) &&
-		    (ev->delta.tv_nsec < NEC_0_SYMBOL + NEC_UNIT / 2))
+		if ((ev->delta.tv_nsec >= NEC_0_SPACE - NEC_UNIT / 2) &&
+		    (ev->delta.tv_nsec < NEC_0_SPACE + NEC_UNIT / 2))
 			bit = 0;
-		else if ((ev->delta.tv_nsec >= NEC_1_SYMBOL - NEC_UNIT / 2) &&
-		         (ev->delta.tv_nsec < NEC_1_SYMBOL + NEC_UNIT / 2))
+		else if ((ev->delta.tv_nsec >= NEC_1_SPACE - NEC_UNIT / 2) &&
+		         (ev->delta.tv_nsec < NEC_1_SPACE + NEC_UNIT / 2))
 			bit = 1;
 		else {
 			IR_dprintk(1, "Decode failed at %d-th bit (%s) @%luus\n",
@@ -256,7 +232,7 @@ static int handle_event(struct input_dev *input_dev,
 				data->nec_code.not_command |= 1 << (shift - 24);
 			}
 		}
-		if (++data->count == 32) {
+		if (++data->count == NEC_NBITS) {
 			u32 scancode;
 			/*
 			 * Fixme: may need to accept Extended NEC protocol?
-- 
1.6.6.1


