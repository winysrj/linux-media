Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52613 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515AbaLFVfP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Dec 2014 16:35:15 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 20/22] si2157: print firmware version
Date: Sat,  6 Dec 2014 23:34:54 +0200
Message-Id: <1417901696-5517-20-git-send-email-crope@iki.fi>
In-Reply-To: <1417901696-5517-1-git-send-email-crope@iki.fi>
References: <1417901696-5517-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Firmware version could be printed similarly than si2168 driver does.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/si2157.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index 3f9aa7a..6ae7620 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -184,6 +184,17 @@ skip_fw_download:
 	if (ret)
 		goto err;
 
+	/* query firmware version */
+	memcpy(cmd.args, "\x11", 1);
+	cmd.wlen = 1;
+	cmd.rlen = 10;
+	ret = si2157_cmd_execute(client, &cmd);
+	if (ret)
+		goto err;
+
+	dev_info(&client->dev, "firmware version: %c.%c.%d\n",
+			cmd.args[6], cmd.args[7], cmd.args[8]);
+
 	dev->fw_loaded = true;
 
 warm:
-- 
http://palosaari.fi/

