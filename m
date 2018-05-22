Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway24.websitewelcome.com ([192.185.50.45]:34542 "EHLO
        gateway24.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751268AbeEVRLf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 May 2018 13:11:35 -0400
Received: from cm15.websitewelcome.com (cm15.websitewelcome.com [100.42.49.9])
        by gateway24.websitewelcome.com (Postfix) with ESMTP id A6DE1216364
        for <linux-media@vger.kernel.org>; Tue, 22 May 2018 12:09:37 -0500 (CDT)
Date: Tue, 22 May 2018 12:09:22 -0500
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] au8522: remove duplicate code
Message-ID: <20180522170922.GA30834@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This code has been there for nine years now, and it has been
working "good enough" since then [1].

Remove duplicate code by getting rid of the if-else statement.

[1] https://marc.info/?l=linux-kernel&m=152693550225081&w=2

Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/media/dvb-frontends/au8522_decoder.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/media/dvb-frontends/au8522_decoder.c b/drivers/media/dvb-frontends/au8522_decoder.c
index 343dc92..f285096 100644
--- a/drivers/media/dvb-frontends/au8522_decoder.c
+++ b/drivers/media/dvb-frontends/au8522_decoder.c
@@ -280,14 +280,12 @@ static void setup_decoder_defaults(struct au8522_state *state, bool is_svideo)
 			AU8522_TOREGAAGC_REG0E5H_CVBS);
 	au8522_writereg(state, AU8522_REG016H, AU8522_REG016H_CVBS);
 
-	if (is_svideo) {
-		/* Despite what the table says, for the HVR-950q we still need
-		   to be in CVBS mode for the S-Video input (reason unknown). */
-		/* filter_coef_type = 3; */
-		filter_coef_type = 5;
-	} else {
-		filter_coef_type = 5;
-	}
+	/*
+	 * Despite what the table says, for the HVR-950q we still need
+	 * to be in CVBS mode for the S-Video input (reason unknown).
+	 */
+	/* filter_coef_type = 3; */
+	filter_coef_type = 5;
 
 	/* Load the Video Decoder Filter Coefficients */
 	for (i = 0; i < NUM_FILTER_COEF; i++) {
-- 
2.7.4
