Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:34198 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751537AbdK2TIt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 14:08:49 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 14/22] media: mt2063: fix some kernel-doc warnings
Date: Wed, 29 Nov 2017 14:08:32 -0500
Message-Id: <5d76cae255a3c177257c3e4e0860ba232d8d4517.1511982439.git.mchehab@s-opensource.com>
In-Reply-To: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
References: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
In-Reply-To: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
References: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix those warnings:
	drivers/media/tuners/mt2063.c:1413: warning: No description found for parameter 'f_ref'
	drivers/media/tuners/mt2063.c:1413: warning: Excess function parameter 'f_Ref' description in 'MT2063_fLO_FractionalTerm'
	drivers/media/tuners/mt2063.c:1476: warning: Excess function parameter 'f_Avoid' description in 'MT2063_CalcLO2Mult'

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/tuners/mt2063.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/tuners/mt2063.c b/drivers/media/tuners/mt2063.c
index 8b39d8dc97a0..5c87c5c6a455 100644
--- a/drivers/media/tuners/mt2063.c
+++ b/drivers/media/tuners/mt2063.c
@@ -1397,9 +1397,9 @@ static u32 MT2063_Round_fLO(u32 f_LO, u32 f_LO_Step, u32 f_ref)
  *                        risk of overflow.  It accurately calculates
  *                        f_ref * num / denom to within 1 HZ with fixed math.
  *
- * @num :	Fractional portion of the multiplier
+ * @f_ref:	SRO frequency.
+ * @num:	Fractional portion of the multiplier
  * @denom:	denominator portion of the ratio
- * @f_Ref:	SRO frequency.
  *
  * This calculation handles f_ref as two separate 14-bit fields.
  * Therefore, a maximum value of 2^28-1 may safely be used for f_ref.
@@ -1464,8 +1464,6 @@ static u32 MT2063_CalcLO1Mult(u32 *Div,
  * @f_LO:	desired LO frequency.
  * @f_LO_Step:	Minimum step size for the LO (in Hz).
  * @f_Ref:	SRO frequency.
- * @f_Avoid:	Range of PLL frequencies to avoid near
- *		integer multiples of f_Ref (in Hz).
  *
  * Returns: Recalculated LO frequency.
  */
-- 
2.14.3
