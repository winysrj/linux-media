Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:36604 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751369AbdFXQDI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Jun 2017 12:03:08 -0400
Received: by mail-wr0-f193.google.com with SMTP id 77so19974649wrb.3
        for <linux-media@vger.kernel.org>; Sat, 24 Jun 2017 09:03:07 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: rjkm@metzlerbros.de, jasmin@anw.at
Subject: [PATCH 2/9] [media] dvb-frontends/stv0910: Fix possible buffer overflow
Date: Sat, 24 Jun 2017 18:02:54 +0200
Message-Id: <20170624160301.17710-3-d.scheller.oss@gmail.com>
In-Reply-To: <20170624160301.17710-1-d.scheller.oss@gmail.com>
References: <20170624160301.17710-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Fixes smatch error:

  drivers/media/dvb-frontends/stv0910.c:715 DVBS2_nBCH() error: buffer overflow 'nBCH[FECType]' 2 <= 28

Also, fixes the nBCH array table by adding the DUMMY_PLF element at the top
to match the enums (table element order was off by one before).

Patch sent upstream aswell.

Cc: Ralph Metzler <rjkm@metzlerbros.de>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/stv0910.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/stv0910.c b/drivers/media/dvb-frontends/stv0910.c
index 8cb4b30f3a81..a5eac1a3a048 100644
--- a/drivers/media/dvb-frontends/stv0910.c
+++ b/drivers/media/dvb-frontends/stv0910.c
@@ -680,6 +680,7 @@ static int GetBitErrorRateS(struct stv *state, u32 *BERNumerator,
 static u32 DVBS2_nBCH(enum DVBS2_ModCod ModCod, enum DVBS2_FECType FECType)
 {
 	static u32 nBCH[][2] = {
+		{    0,     0}, /* DUMMY_PLF */
 		{16200,  3240}, /* QPSK_1_4, */
 		{21600,  5400}, /* QPSK_1_3, */
 		{25920,  6480}, /* QPSK_2_5, */
@@ -712,7 +713,7 @@ static u32 DVBS2_nBCH(enum DVBS2_ModCod ModCod, enum DVBS2_FECType FECType)
 
 	if (ModCod >= DVBS2_QPSK_1_4 &&
 	    ModCod <= DVBS2_32APSK_9_10 && FECType <= DVBS2_16K)
-		return nBCH[FECType][ModCod];
+		return nBCH[ModCod][FECType];
 	return 64800;
 }
 
-- 
2.13.0
