Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:41515 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224Ab3JDOsc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Oct 2013 10:48:32 -0400
Received: by mail-we0-f171.google.com with SMTP id p61so4745635wes.30
        for <linux-media@vger.kernel.org>; Fri, 04 Oct 2013 07:48:30 -0700 (PDT)
From: Luis Alves <ljalvs@gmail.com>
To: linux-media@vger.kernel.org
Cc: mkrufky@linuxtv.org, crope@iki.fi, mchehab@infradead.org,
	Luis Alves <ljalvs@gmail.com>
Subject: [PATCH] cx24117: Prevent mutex to be stuck on locked state if FE init fails.
Date: Fri,  4 Oct 2013 15:48:35 +0100
Message-Id: <1380898115-30071-1-git-send-email-ljalvs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
This patch will fix the situation where the mutex was left in a locked state if for some reason the FE init failed.

Regards,
Luis


Signed-off-by: Luis Alves <ljalvs@gmail.com>
---
 drivers/media/dvb-frontends/cx24117.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb-frontends/cx24117.c b/drivers/media/dvb-frontends/cx24117.c
index 9087309..476b422 100644
--- a/drivers/media/dvb-frontends/cx24117.c
+++ b/drivers/media/dvb-frontends/cx24117.c
@@ -1238,11 +1238,11 @@ static int cx24117_initfe(struct dvb_frontend *fe)
 	cmd.len = 3;
 	ret = cx24117_cmd_execute_nolock(fe, &cmd);
 	if (ret != 0)
-		return ret;
+		goto exit;
 
 	ret = cx24117_diseqc_init(fe);
 	if (ret != 0)
-		return ret;
+		goto exit;
 
 	/* CMD 3C */
 	cmd.args[0] = 0x3c;
@@ -1252,7 +1252,7 @@ static int cx24117_initfe(struct dvb_frontend *fe)
 	cmd.len = 4;
 	ret = cx24117_cmd_execute_nolock(fe, &cmd);
 	if (ret != 0)
-		return ret;
+		goto exit;
 
 	/* CMD 34 */
 	cmd.args[0] = 0x34;
@@ -1260,9 +1260,8 @@ static int cx24117_initfe(struct dvb_frontend *fe)
 	cmd.args[2] = CX24117_OCC;
 	cmd.len = 3;
 	ret = cx24117_cmd_execute_nolock(fe, &cmd);
-	if (ret != 0)
-		return ret;
 
+exit:
 	mutex_unlock(&state->priv->fe_lock);
 
 	return ret;
-- 
1.7.9.5

