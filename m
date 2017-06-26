Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway30.websitewelcome.com ([50.116.127.1]:19337 "EHLO
        gateway30.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751453AbdF0Air (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Jun 2017 20:38:47 -0400
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway30.websitewelcome.com (Postfix) with ESMTP id C490D1BB4A
        for <linux-media@vger.kernel.org>; Mon, 26 Jun 2017 18:50:16 -0500 (CDT)
Date: Mon, 26 Jun 2017 18:50:16 -0500
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] dvb-frontends: mb86a16: remove useless variables in
 signal_det()
Message-ID: <20170626235015.GA21708@embeddedgus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove useless variables wait_t and wait_sym and code related.

Also, fix some coding style issues.

Addresses-Coverity-ID: 1226947
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/media/dvb-frontends/mb86a16.c | 25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

diff --git a/drivers/media/dvb-frontends/mb86a16.c b/drivers/media/dvb-frontends/mb86a16.c
index 9bb122c..dfe322e 100644
--- a/drivers/media/dvb-frontends/mb86a16.c
+++ b/drivers/media/dvb-frontends/mb86a16.c
@@ -415,27 +415,21 @@ static int signal_det(struct mb86a16_state *state,
 		      int smrt,
 		      unsigned char *SIG)
 {
-
-	int ret ;
-	int smrtd ;
-	int wait_sym ;
-
-	u32 wait_t;
-	unsigned char S[3] ;
-	int i ;
+	int ret;
+	int smrtd;
+	unsigned char S[3];
+	int i;
 
 	if (*SIG > 45) {
 		if (CNTM_set(state, 2, 1, 2) < 0) {
 			dprintk(verbose, MB86A16_ERROR, 1, "CNTM set Error");
 			return -1;
 		}
-		wait_sym = 40000;
 	} else {
 		if (CNTM_set(state, 3, 1, 2) < 0) {
 			dprintk(verbose, MB86A16_ERROR, 1, "CNTM set Error");
 			return -1;
 		}
-		wait_sym = 80000;
 	}
 	for (i = 0; i < 3; i++) {
 		if (i == 0)
@@ -447,22 +441,17 @@ static int signal_det(struct mb86a16_state *state,
 		smrt_info_get(state, smrtd);
 		smrt_set(state, smrtd);
 		srst(state);
-		wait_t = (wait_sym + 99 * smrtd / 100) / smrtd;
-		if (wait_t == 0)
-			wait_t = 1;
 		msleep_interruptible(10);
 		if (mb86a16_read(state, 0x37, &(S[i])) != 2) {
 			dprintk(verbose, MB86A16_ERROR, 1, "I2C transfer error");
 			return -EREMOTEIO;
 		}
 	}
-	if ((S[1] > S[0] * 112 / 100) &&
-	    (S[1] > S[2] * 112 / 100)) {
-
+	if ((S[1] > S[0] * 112 / 100) && (S[1] > S[2] * 112 / 100))
 		ret = 1;
-	} else {
+	else
 		ret = 0;
-	}
+
 	*SIG = S[1];
 
 	if (CNTM_set(state, 0, 1, 2) < 0) {
-- 
2.5.0
