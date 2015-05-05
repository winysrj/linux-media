Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:34804 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761109AbbEEQyn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 May 2015 12:54:43 -0400
Received: by lbcga7 with SMTP id ga7so133648645lbc.1
        for <linux-media@vger.kernel.org>; Tue, 05 May 2015 09:54:42 -0700 (PDT)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH v4 3/6] si2168: add I2C error handling
Date: Tue,  5 May 2015 19:54:16 +0300
Message-Id: <1430844859-24947-4-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1430844859-24947-1-git-send-email-olli.salonen@iki.fi>
References: <1430844859-24947-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Return error from si2168_cmd_execute in case the demodulator returns an 
error.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/dvb-frontends/si2168.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 29a5936..b68ab34 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -60,6 +60,12 @@ static int si2168_cmd_execute(struct i2c_client *client, struct si2168_cmd *cmd)
 				jiffies_to_msecs(jiffies) -
 				(jiffies_to_msecs(timeout) - TIMEOUT));
 
+		/* error bit set? */
+		if ((cmd->args[0] >> 6) & 0x01) {
+			ret = -EREMOTEIO;
+			goto err_mutex_unlock;
+		}
+
 		if (!((cmd->args[0] >> 7) & 0x01)) {
 			ret = -ETIMEDOUT;
 			goto err_mutex_unlock;
-- 
1.9.1

