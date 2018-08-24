Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:35964 "EHLO
        srv-hp10-72.netsons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727644AbeHXULe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Aug 2018 16:11:34 -0400
From: Luca Ceresoli <luca@lucaceresoli.net>
To: linux-media@vger.kernel.org
Cc: Luca Ceresoli <luca@lucaceresoli.net>,
        Leon Luo <leonl@leopardimaging.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] media: imx274: fix error in function docs
Date: Fri, 24 Aug 2018 18:35:23 +0200
Message-Id: <20180824163525.12694-6-luca@lucaceresoli.net>
In-Reply-To: <20180824163525.12694-1-luca@lucaceresoli.net>
References: <20180824163525.12694-1-luca@lucaceresoli.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This parameter holds the number of bytes, not bits.

Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
---
 drivers/media/i2c/imx274.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/imx274.c b/drivers/media/i2c/imx274.c
index 6572d5728791..07bc41f537c5 100644
--- a/drivers/media/i2c/imx274.c
+++ b/drivers/media/i2c/imx274.c
@@ -668,7 +668,7 @@ static inline int imx274_write_reg(struct stimx274 *priv, u16 addr, u8 val)
  * @addr: Address of the LSB register.  Other registers must be
  *        consecutive, least-to-most significant.
  * @val: Value to be written to the register (cpu endianness)
- * @nbytes: Number of bits to write (range: [1..3])
+ * @nbytes: Number of bytes to write (range: [1..3])
  */
 static int imx274_write_mbreg(struct stimx274 *priv, u16 addr, u32 val,
 			      size_t nbytes)
-- 
2.17.1
