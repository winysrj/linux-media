Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:34583 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758415AbbDWVLd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Apr 2015 17:11:33 -0400
Received: by laat2 with SMTP id t2so21980859laa.1
        for <linux-media@vger.kernel.org>; Thu, 23 Apr 2015 14:11:31 -0700 (PDT)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 03/12] si2157: support selection of IF interface
Date: Fri, 24 Apr 2015 00:11:02 +0300
Message-Id: <1429823471-21835-3-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1429823471-21835-1-git-send-email-olli.salonen@iki.fi>
References: <1429823471-21835-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The chips supported by the si2157 driver have two IF outputs (either
pins 12+13 or pins 9+11). Instead of hardcoding the output to be used
add an option to choose which output shall be used.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/tuners/si2157.c      | 4 +++-
 drivers/media/tuners/si2157.h      | 6 ++++++
 drivers/media/tuners/si2157_priv.h | 1 +
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index d74ae26..cdaf687 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -298,7 +298,8 @@ static int si2157_set_params(struct dvb_frontend *fe)
 	if (dev->chiptype == SI2157_CHIPTYPE_SI2146)
 		memcpy(cmd.args, "\x14\x00\x02\x07\x00\x01", 6);
 	else
-		memcpy(cmd.args, "\x14\x00\x02\x07\x01\x00", 6);
+		memcpy(cmd.args, "\x14\x00\x02\x07\x00\x00", 6);
+	cmd.args[4] = dev->if_port;
 	cmd.wlen = 6;
 	cmd.rlen = 4;
 	ret = si2157_cmd_execute(client, &cmd);
@@ -378,6 +379,7 @@ static int si2157_probe(struct i2c_client *client,
 	i2c_set_clientdata(client, dev);
 	dev->fe = cfg->fe;
 	dev->inversion = cfg->inversion;
+	dev->if_port = cfg->if_port;
 	dev->fw_loaded = false;
 	dev->chiptype = (u8)id->driver_data;
 	dev->if_frequency = 5000000; /* default value of property 0x0706 */
diff --git a/drivers/media/tuners/si2157.h b/drivers/media/tuners/si2157.h
index a564c4a..4db97ab 100644
--- a/drivers/media/tuners/si2157.h
+++ b/drivers/media/tuners/si2157.h
@@ -34,6 +34,12 @@ struct si2157_config {
 	 * Spectral Inversion
 	 */
 	bool inversion;
+
+	/*
+	 * Port selection
+	 * Select the RF interface to use (pins 9+11 or 12+13)
+	 */
+	u8 if_port;
 };
 
 #endif
diff --git a/drivers/media/tuners/si2157_priv.h b/drivers/media/tuners/si2157_priv.h
index cd8fa5b..71a5f8c 100644
--- a/drivers/media/tuners/si2157_priv.h
+++ b/drivers/media/tuners/si2157_priv.h
@@ -28,6 +28,7 @@ struct si2157_dev {
 	bool fw_loaded;
 	bool inversion;
 	u8 chiptype;
+	u8 if_port;
 	u32 if_frequency;
 };
 
-- 
1.9.1

