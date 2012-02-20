Return-path: <linux-media-owner@vger.kernel.org>
Received: from multi.imgtec.com ([194.200.65.239]:42975 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051Ab2BTKN5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Feb 2012 05:13:57 -0500
Message-ID: <4F421CE2.4010004@imgtec.com>
Date: Mon, 20 Feb 2012 10:13:54 +0000
From: James Hogan <james.hogan@imgtec.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Paul Gortmaker <paul.gortmaker@windriver.com>,
	<linux-media@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] media: ir-sony-decoder: 15bit function decode fix
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The raw Sony IR decoder decodes 15bit messages slightly incorrectly.
To decode the function number, it shifts the bits right by 7 so that the
function is in bits 7:1, masks with 0xFD (0b11111101), and does an 8 bit
reverse so it ends up in bits 6:0. The mask should be 0xFE to correspond
with bits 7:1 (0b11111110).

The old mask had the effect of dropping the MSB of the function number
from bit 6, and leaving the LSB of the device number in bit 7.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---

(note, i don't have a 15bit sony remote to test this with, but i'm
pretty confident of it's correctness based on this:
http://picprojects.org.uk/projects/sirc/sonysirc.pdf )

 drivers/media/rc/ir-sony-decoder.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/rc/ir-sony-decoder.c b/drivers/media/rc/ir-sony-decoder.c
index d5e2b50..dab98b3 100644
--- a/drivers/media/rc/ir-sony-decoder.c
+++ b/drivers/media/rc/ir-sony-decoder.c
@@ -130,7 +130,7 @@ static int ir_sony_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		case 15:
 			device    = bitrev8((data->bits >>  0) & 0xFF);
 			subdevice = 0;
-			function  = bitrev8((data->bits >>  7) & 0xFD);
+			function  = bitrev8((data->bits >>  7) & 0xFE);
 			break;
 		case 20:
 			device    = bitrev8((data->bits >>  5) & 0xF8);
-- 
1.7.2.3


