Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:56407 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754220AbdK2Kqr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 05:46:47 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sean Young <sean@mess.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        James Hogan <jhogan@kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>
Subject: [PATCH 10/12] media: ir-nec-decoder: fix kernel-doc parameters
Date: Wed, 29 Nov 2017 05:46:31 -0500
Message-Id: <64dc6829a0080e3c8e70d52a98e9b0e30d968bd8.1511952372.git.mchehab@s-opensource.com>
In-Reply-To: <46e42a303178ca1341d1ab3e0b5c1227b89b60ee.1511952372.git.mchehab@s-opensource.com>
References: <46e42a303178ca1341d1ab3e0b5c1227b89b60ee.1511952372.git.mchehab@s-opensource.com>
In-Reply-To: <46e42a303178ca1341d1ab3e0b5c1227b89b60ee.1511952372.git.mchehab@s-opensource.com>
References: <46e42a303178ca1341d1ab3e0b5c1227b89b60ee.1511952372.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some parameters aren't correctly identified, as noticed by
those warnings:
	drivers/media/rc/ir-nec-decoder.c:49: warning: No description found for parameter 'ev'
	drivers/media/rc/ir-nec-decoder.c:49: warning: Excess function parameter 'duration' description in 'ir_nec_decode'
	drivers/media/rc/ir-nec-decoder.c:189: warning: Excess function parameter 'raw' description in 'ir_nec_scancode_to_raw'

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/rc/ir-nec-decoder.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
index a95d09acc22a..6880c190dcd2 100644
--- a/drivers/media/rc/ir-nec-decoder.c
+++ b/drivers/media/rc/ir-nec-decoder.c
@@ -41,7 +41,7 @@ enum nec_state {
 /**
  * ir_nec_decode() - Decode one NEC pulse or space
  * @dev:	the struct rc_dev descriptor of the device
- * @duration:	the struct ir_raw_event descriptor of the pulse/space
+ * @ev:		the struct ir_raw_event descriptor of the pulse/space
  *
  * This function returns -EINVAL if the pulse violates the state machine
  */
@@ -183,7 +183,6 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
  * ir_nec_scancode_to_raw() - encode an NEC scancode ready for modulation.
  * @protocol:	specific protocol to use
  * @scancode:	a single NEC scancode.
- * @raw:	raw data to be modulated.
  */
 static u32 ir_nec_scancode_to_raw(enum rc_proto protocol, u32 scancode)
 {
-- 
2.14.3
