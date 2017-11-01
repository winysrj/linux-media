Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:44026 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933404AbdKAVGU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Nov 2017 17:06:20 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH v2 26/26] media: mb86a16: avoid division by zero
Date: Wed,  1 Nov 2017 17:06:03 -0400
Message-Id: <5ec788acbc0aea0843fb5c024519f9b802228da6.1509569763.git.mchehab@s-opensource.com>
In-Reply-To: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
In-Reply-To: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As warned by smatch:
	drivers/media/dvb-frontends/mb86a16.c:1690 mb86a16_read_ber() error: uninitialized symbol 'timer'.
	drivers/media/dvb-frontends/mb86a16.c:1706 mb86a16_read_ber() error: uninitialized symbol 'timer'.

There is a potential risk of doing a division by zero if
timer is not handled well. Enforce it by setting a bit mask
for the values used to select the timer.

While here, optimize the logic to prevent uneeded tests.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/mb86a16.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb-frontends/mb86a16.c b/drivers/media/dvb-frontends/mb86a16.c
index f1aad52094c3..5d2bb76bc07a 100644
--- a/drivers/media/dvb-frontends/mb86a16.c
+++ b/drivers/media/dvb-frontends/mb86a16.c
@@ -1677,15 +1677,15 @@ static int mb86a16_read_ber(struct dvb_frontend *fe, u32 *ber)
 			 * the deinterleaver output.
 			 * monitored BER is expressed as a 20 bit output in total
 			 */
-			ber_rst = ber_mon >> 3;
+			ber_rst = (ber_mon >> 3) & 0x03;
 			*ber = (((ber_msb << 8) | ber_mid) << 8) | ber_lsb;
 			if (ber_rst == 0)
 				timer =  12500000;
-			if (ber_rst == 1)
+			else if (ber_rst == 1)
 				timer =  25000000;
-			if (ber_rst == 2)
+			else if (ber_rst == 2)
 				timer =  50000000;
-			if (ber_rst == 3)
+			else /* ber_rst == 3 */
 				timer = 100000000;
 
 			*ber /= timer;
@@ -1697,11 +1697,11 @@ static int mb86a16_read_ber(struct dvb_frontend *fe, u32 *ber)
 			 * QPSK demodulator output.
 			 * monitored BER is expressed as a 24 bit output in total
 			 */
-			ber_tim = ber_mon >> 1;
+			ber_tim = (ber_mon >> 1) & 0x01;
 			*ber = (((ber_msb << 8) | ber_mid) << 8) | ber_lsb;
 			if (ber_tim == 0)
 				timer = 16;
-			if (ber_tim == 1)
+			else /* ber_tim == 1 */
 				timer = 24;
 
 			*ber /= 2 ^ timer;
-- 
2.13.6
