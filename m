Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44878 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753969AbbBZV3k (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Feb 2015 16:29:40 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Jurgen Kramer <gtmkramer@xs4all.nl>, <stable@vger.kernel.org>
Subject: [PATCH] Si2168: increase timeout to fix firmware loading
Date: Thu, 26 Feb 2015 23:28:53 +0200
Message-Id: <1424986133-5105-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jurgen Kramer <gtmkramer@xs4all.nl>

Increase si2168 cmd execute timeout to prevent firmware load failures. Tests
shows it takes up to 52ms to load the 'dvb-demod-si2168-a30-01.fw' firmware.
Increase timeout to a safe value of 70ms.

Cc: <stable@vger.kernel.org> # v3.16+
Signed-off-by: Jurgen Kramer <gtmkramer@xs4all.nl>
Reviewed-by: Antti Palosaari <crope@iki.fi>
---
Patch for stable 3.16+

That patch is already applied to master as commit 551c33e729f654ecfaed00ad399f5d2a631b72cb
There was some mistake and Cc stable tag I added to patchwork [1] was lost.

[1] https://patchwork.linuxtv.org/patch/27382/
---
 drivers/media/dvb-frontends/si2168.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 2e3cdcf..fbc1fa8 100644
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
http://palosaari.fi/

