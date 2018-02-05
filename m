Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway34.websitewelcome.com ([192.185.149.105]:47216 "EHLO
        gateway34.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751597AbeBEUGk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Feb 2018 15:06:40 -0500
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id 647843BFA5
        for <linux-media@vger.kernel.org>; Mon,  5 Feb 2018 14:06:39 -0600 (CST)
Date: Mon, 5 Feb 2018 14:06:37 -0600
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH v2 1/8] rtl2832: use 64-bit arithmetic instead of 32-bit in
 rtl2832_set_frontend
Message-ID: <381d67326e15bfbb588947d13def3f6a1571db85.1517856716.git.gustavo@embeddedor.com>
References: <cover.1517856716.git.gustavo@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1517856716.git.gustavo@embeddedor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add suffix ULL to constant 7 in order to give the compiler complete
information about the proper arithmetic to use. Notice that this
constant is used in a context that expects an expression of type
u64 (64 bits, unsigned).

The expression dev->pdata->clk * 7 is currently being evaluated
using 32-bit arithmetic.

Addresses-Coverity-ID: 1271223
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
Changes in v2:
 - Update subject and changelog to better reflect the proposed code changes.
 - Add suffix ULL to constant instead of casting a variable.

 drivers/media/dvb-frontends/rtl2832.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index 94bf5b7..fa3b816 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -498,7 +498,7 @@ static int rtl2832_set_frontend(struct dvb_frontend *fe)
 	* RSAMP_RATIO = floor(CrystalFreqHz * 7 * pow(2, 22)
 	*	/ ConstWithBandwidthMode)
 	*/
-	num = dev->pdata->clk * 7;
+	num = dev->pdata->clk * 7ULL;
 	num *= 0x400000;
 	num = div_u64(num, bw_mode);
 	resamp_ratio =  num & 0x3ffffff;
@@ -511,7 +511,7 @@ static int rtl2832_set_frontend(struct dvb_frontend *fe)
 	*	/ (CrystalFreqHz * 7))
 	*/
 	num = bw_mode << 20;
-	num2 = dev->pdata->clk * 7;
+	num2 = dev->pdata->clk * 7ULL;
 	num = div_u64(num, num2);
 	num = -num;
 	cfreq_off_ratio = num & 0xfffff;
-- 
2.7.4
