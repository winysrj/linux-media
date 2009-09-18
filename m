Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:55605 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758744AbZIRXEO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Sep 2009 19:04:14 -0400
Received: by ewy2 with SMTP id 2so1730409ewy.17
        for <linux-media@vger.kernel.org>; Fri, 18 Sep 2009 16:04:17 -0700 (PDT)
Message-ID: <4AB413A1.3070306@gmail.com>
Date: Sat, 19 Sep 2009 01:11:29 +0200
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] V4L/DVB (11380): kzalloc failure ignored in au8522_probe()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Prevent NULL dereference if kzalloc() fails.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Found with sed: http://kernelnewbies.org/roelkluin

Build tested.

diff --git a/drivers/media/dvb/frontends/au8522_decoder.c b/drivers/media/dvb/frontends/au8522_decoder.c
index 9e9a755..74981ee 100644
--- a/drivers/media/dvb/frontends/au8522_decoder.c
+++ b/drivers/media/dvb/frontends/au8522_decoder.c
@@ -792,6 +792,11 @@ static int au8522_probe(struct i2c_client *client,
 	}
 
 	demod_config = kzalloc(sizeof(struct au8522_config), GFP_KERNEL);
+	if (demod_config == NULL) {
+		if (instance == 1)
+			kfree(state);
+		return -ENOMEM;
+	}
 	demod_config->demod_address = 0x8e >> 1;
 
 	state->config = demod_config;
