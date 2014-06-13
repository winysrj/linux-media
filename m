Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49628 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753222AbaFMWlo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jun 2014 18:41:44 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/3] si2157: add one missing parenthesis
Date: Sat, 14 Jun 2014 01:41:26 +0300
Message-Id: <1402699287-21615-2-git-send-email-crope@iki.fi>
In-Reply-To: <1402699287-21615-1-git-send-email-crope@iki.fi>
References: <1402699287-21615-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix following warnings:
si2157_cmd_execute() warn: add some parenthesis here?
si2157_cmd_execute() warn: maybe use && instead of &

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/si2157.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index 271a752..fa4cc7b 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -57,7 +57,7 @@ static int si2157_cmd_execute(struct si2157 *s, struct si2157_cmd *cmd)
 			jiffies_to_msecs(jiffies) -
 			(jiffies_to_msecs(timeout) - TIMEOUT));
 
-	if (!(buf[0] >> 7) & 0x01) {
+	if (!((buf[0] >> 7) & 0x01)) {
 		ret = -ETIMEDOUT;
 		goto err_mutex_unlock;
 	} else {
-- 
1.9.3

