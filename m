Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34817 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbdJOSy4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 15 Oct 2017 14:54:56 -0400
Received: by mail-wm0-f66.google.com with SMTP id b189so6038834wmd.2
        for <linux-media@vger.kernel.org>; Sun, 15 Oct 2017 11:54:56 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH RESEND] media: mxl5xx: fix tuning logic
Date: Sun, 15 Oct 2017 20:54:52 +0200
Message-Id: <20171015185452.13775-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab <mchehab@s-opensource.com>

The tuning logic is broken with regards to status report:
it relies on a previously-cached value that may not be valid
if retuned.

Change the logic to always read the status.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Acked-by: Daniel Scheller <d.scheller@gmx.net>
---
Resend (ref. https://patchwork.linuxtv.org/patch/43541/) so this doesn't
get lost - this fix really should go in.

 drivers/media/dvb-frontends/mxl5xx.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/media/dvb-frontends/mxl5xx.c b/drivers/media/dvb-frontends/mxl5xx.c
index 676c96c216c3..4b449a6943c5 100644
--- a/drivers/media/dvb-frontends/mxl5xx.c
+++ b/drivers/media/dvb-frontends/mxl5xx.c
@@ -636,16 +636,9 @@ static int tune(struct dvb_frontend *fe, bool re_tune,
 		if (r)
 			return r;
 		state->tune_time = jiffies;
-		return 0;
 	}
-	if (*status & FE_HAS_LOCK)
-		return 0;
 
-	r = read_status(fe, status);
-	if (r)
-		return r;
-
-	return 0;
+	return read_status(fe, status);
 }
 
 static enum fe_code_rate conv_fec(enum MXL_HYDRA_FEC_E fec)
-- 
2.13.6
