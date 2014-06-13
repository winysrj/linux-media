Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40840 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753226AbaFMWlo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jun 2014 18:41:44 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/3] si2168: add one missing parenthesis
Date: Sat, 14 Jun 2014 01:41:25 +0300
Message-Id: <1402699287-21615-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix following warnings:
si2168_cmd_execute() warn: add some parenthesis here?
si2168_cmd_execute() warn: maybe use && instead of &

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/si2168.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 8637d2e..f205736 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -60,7 +60,7 @@ static int si2168_cmd_execute(struct si2168 *s, struct si2168_cmd *cmd)
 				jiffies_to_msecs(jiffies) -
 				(jiffies_to_msecs(timeout) - TIMEOUT));
 
-		if (!(cmd->args[0] >> 7) & 0x01) {
+		if (!((cmd->args[0] >> 7) & 0x01)) {
 			ret = -ETIMEDOUT;
 			goto err_mutex_unlock;
 		}
-- 
1.9.3

