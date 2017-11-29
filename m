Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:46181 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752804AbdK2Kqj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 05:46:39 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        James Hogan <jhogan@kernel.org>
Subject: [PATCH 04/12] media: img-ir-hw: fix one kernel-doc comment
Date: Wed, 29 Nov 2017 05:46:25 -0500
Message-Id: <86850b9a0495b10326765f03b9e77fd46e83981c.1511952372.git.mchehab@s-opensource.com>
In-Reply-To: <46e42a303178ca1341d1ab3e0b5c1227b89b60ee.1511952372.git.mchehab@s-opensource.com>
References: <46e42a303178ca1341d1ab3e0b5c1227b89b60ee.1511952372.git.mchehab@s-opensource.com>
In-Reply-To: <46e42a303178ca1341d1ab3e0b5c1227b89b60ee.1511952372.git.mchehab@s-opensource.com>
References: <46e42a303178ca1341d1ab3e0b5c1227b89b60ee.1511952372.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Needed to suppress the following warnings:
	drivers/media/rc/img-ir/img-ir-hw.c:351: warning: No description found for parameter 'reg_timings'
	drivers/media/rc/img-ir/img-ir-hw.c:351: warning: Excess function parameter 'timings' description in 'img_ir_decoder_convert'

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/rc/img-ir/img-ir-hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/img-ir/img-ir-hw.c b/drivers/media/rc/img-ir/img-ir-hw.c
index f54bc5d23893..ec4ded84cd17 100644
--- a/drivers/media/rc/img-ir/img-ir-hw.c
+++ b/drivers/media/rc/img-ir/img-ir-hw.c
@@ -339,7 +339,7 @@ static void img_ir_decoder_preprocess(struct img_ir_decoder *decoder)
 /**
  * img_ir_decoder_convert() - Generate internal timings in decoder.
  * @decoder:	Decoder to be converted to internal timings.
- * @timings:	Timing register values.
+ * @reg_timings: Timing register values.
  * @clock_hz:	IR clock rate in Hz.
  *
  * Fills out the repeat timings and timing register values for a specific clock
-- 
2.14.3
