Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:51246 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab2JHMf5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Oct 2012 08:35:57 -0400
Received: by mail-qa0-f46.google.com with SMTP id c26so2027391qad.19
        for <linux-media@vger.kernel.org>; Mon, 08 Oct 2012 05:35:56 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 8 Oct 2012 20:35:56 +0800
Message-ID: <CAPgLHd-CygOpRcPTy65dn66HCNjsHi+Sf1v1aC2Azcqd0e3Wxw@mail.gmail.com>
Subject: [PATCH] dvb-frontends: fix potential NULL pointer dereference in stv0900_set_mclk()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: mchehab@infradead.org
Cc: yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The dereference should be moved below the NULL test.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/media/dvb-frontends/stv0900_core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv0900_core.c b/drivers/media/dvb-frontends/stv0900_core.c
index 7f1bada..274a71c 100644
--- a/drivers/media/dvb-frontends/stv0900_core.c
+++ b/drivers/media/dvb-frontends/stv0900_core.c
@@ -300,15 +300,15 @@ static enum fe_stv0900_error stv0900_set_mclk(struct stv0900_internal *intp, u32
 {
 	u32 m_div, clk_sel;
 
-	dprintk("%s: Mclk set to %d, Quartz = %d\n", __func__, mclk,
-			intp->quartz);
-
 	if (intp == NULL)
 		return STV0900_INVALID_HANDLE;
 
 	if (intp->errs)
 		return STV0900_I2C_ERROR;
 
+	dprintk("%s: Mclk set to %d, Quartz = %d\n", __func__, mclk,
+			intp->quartz);
+
 	clk_sel = ((stv0900_get_bits(intp, F0900_SELX1RATIO) == 1) ? 4 : 6);
 	m_div = ((clk_sel * mclk) / intp->quartz) - 1;
 	stv0900_write_bits(intp, F0900_M_DIV, m_div);

