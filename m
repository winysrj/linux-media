Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:52891 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751458AbeFWPgV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 23 Jun 2018 11:36:21 -0400
Received: by mail-wm0-f68.google.com with SMTP id p126-v6so4934841wmb.2
        for <linux-media@vger.kernel.org>; Sat, 23 Jun 2018 08:36:21 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: mchehab@kernel.org, mchehab@s-opensource.com
Cc: linux-media@vger.kernel.org
Subject: [PATCH 02/19] [media] dvb-frontends/stv0910: cast the BER denominator shift exp to ULL
Date: Sat, 23 Jun 2018 17:35:58 +0200
Message-Id: <20180623153615.27630-3-d.scheller.oss@gmail.com>
In-Reply-To: <20180623153615.27630-1-d.scheller.oss@gmail.com>
References: <20180623153615.27630-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

To avoid miscalculations related to the BER denominator, the shift
expression needs to be casted as ULL.

Picked up from the upstream dddvb GIT.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/stv0910.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv0910.c b/drivers/media/dvb-frontends/stv0910.c
index 41444fa1c0bb..91b21eb59531 100644
--- a/drivers/media/dvb-frontends/stv0910.c
+++ b/drivers/media/dvb-frontends/stv0910.c
@@ -682,8 +682,8 @@ static int get_bit_error_rate_s(struct stv *state, u32 *bernumerator,
 		return -EINVAL;
 
 	if ((regs[0] & 0x80) == 0) {
-		state->last_berdenominator = 1 << ((state->berscale * 2) +
-						  10 + 3);
+		state->last_berdenominator = 1ULL << ((state->berscale * 2) +
+						     10 + 3);
 		state->last_bernumerator = ((u32)(regs[0] & 0x7F) << 16) |
 			((u32)regs[1] << 8) | regs[2];
 		if (state->last_bernumerator < 256 && state->berscale < 6) {
-- 
2.16.4
