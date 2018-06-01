Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:35294 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752333AbeFAQJ6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Jun 2018 12:09:58 -0400
From: Ivan Bornyakov <brnkv.i1@gmail.com>
To: mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ivan Bornyakov <brnkv.i1@gmail.com>
Subject: [PATCH] media: stv090x: fix if-else order
Date: Fri,  1 Jun 2018 19:12:21 +0300
Message-Id: <20180601161221.24807-1-brnkv.i1@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is this code:

	if (v >= 0x20) {
		...
	} else if (v < 0x20) {
		...
	} else if (v > 0x30) {
		/* this branch is impossible */
	}

It would be sensibly for last branch to be on the top.

Signed-off-by: Ivan Bornyakov <brnkv.i1@gmail.com>
---
 drivers/media/dvb-frontends/stv090x.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv090x.c b/drivers/media/dvb-frontends/stv090x.c
index 9133f65d4623..d70eb311ebaf 100644
--- a/drivers/media/dvb-frontends/stv090x.c
+++ b/drivers/media/dvb-frontends/stv090x.c
@@ -4841,7 +4841,11 @@ static int stv090x_setup(struct dvb_frontend *fe)
 	}
 
 	state->internal->dev_ver = stv090x_read_reg(state, STV090x_MID);
-	if (state->internal->dev_ver >= 0x20) {
+	if (state->internal->dev_ver > 0x30) {
+		/* we shouldn't bail out from here */
+		dprintk(FE_ERROR, 1, "INFO: Cut: 0x%02x probably incomplete support!",
+			state->internal->dev_ver);
+	} else if (state->internal->dev_ver >= 0x20) {
 		if (stv090x_write_reg(state, STV090x_TSGENERAL, 0x0c) < 0)
 			goto err;
 
@@ -4857,10 +4861,6 @@ static int stv090x_setup(struct dvb_frontend *fe)
 			state->internal->dev_ver);
 
 		goto err;
-	} else if (state->internal->dev_ver > 0x30) {
-		/* we shouldn't bail out from here */
-		dprintk(FE_ERROR, 1, "INFO: Cut: 0x%02x probably incomplete support!",
-			state->internal->dev_ver);
 	}
 
 	/* ADC1 range */
-- 
2.16.4
