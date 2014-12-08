Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:35326 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753901AbaLHIat (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Dec 2014 03:30:49 -0500
From: Jurgen Kramer <gtmkramer@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Jurgen Kramer <gtmkramer@xs4all.nl>
Subject: [PATCH] Si2168: increase timeout to fix firmware loading
Date: Mon,  8 Dec 2014 09:30:44 +0100
Message-Id: <1418027444-4718-1-git-send-email-gtmkramer@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Increase si2168 cmd execute timeout to prevent firmware load failures. Tests
shows it takes up to 52ms to load the 'dvb-demod-si2168-a30-01.fw' firmware.
Increase timeout to a safe value of 70ms.

Signed-off-by: Jurgen Kramer <gtmkramer@xs4all.nl>
---
 drivers/media/dvb-frontends/si2168.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index ce9ab44..d2f1a3e 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -39,7 +39,7 @@ static int si2168_cmd_execute(struct si2168 *s, struct si2168_cmd *cmd)
 
 	if (cmd->rlen) {
 		/* wait cmd execution terminate */
-		#define TIMEOUT 50
+		#define TIMEOUT 70
 		timeout = jiffies + msecs_to_jiffies(TIMEOUT);
 		while (!time_after(jiffies, timeout)) {
 			ret = i2c_master_recv(s->client, cmd->args, cmd->rlen);
-- 
1.9.3

