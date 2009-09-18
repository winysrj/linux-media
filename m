Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:51400 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757341AbZIRXFz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Sep 2009 19:05:55 -0400
Received: by ewy2 with SMTP id 2so1731048ewy.17
        for <linux-media@vger.kernel.org>; Fri, 18 Sep 2009 16:05:58 -0700 (PDT)
Message-ID: <4AB41406.6020106@gmail.com>
Date: Sat, 19 Sep 2009 01:13:10 +0200
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] V4L/DVB (9367): kmalloc failure ignored in lgdt3304_attach()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Prevent NULL dereference if kmalloc() fails.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Found with sed: http://kernelnewbies.org/roelkluin

Build tested.

diff --git a/drivers/media/dvb/frontends/lgdt3304.c b/drivers/media/dvb/frontends/lgdt3304.c
index eb72a98..e334b5d 100644
--- a/drivers/media/dvb/frontends/lgdt3304.c
+++ b/drivers/media/dvb/frontends/lgdt3304.c
@@ -363,6 +363,8 @@ struct dvb_frontend* lgdt3304_attach(const struct lgdt3304_config *config,
 
 	struct lgdt3304_state *state;
 	state = kzalloc(sizeof(struct lgdt3304_state), GFP_KERNEL);
+	if (state == NULL)
+		return NULL;
 	state->addr = config->i2c_address;
 	state->i2c = i2c;
 
diff --git a/drivers/media/dvb/frontends/s921_module.c b/drivers/media/dvb/frontends/s921_module.c
index 3f5a0e1..3156b64 100644
--- a/drivers/media/dvb/frontends/s921_module.c
+++ b/drivers/media/dvb/frontends/s921_module.c
@@ -169,6 +169,8 @@ struct dvb_frontend* s921_attach(const struct s921_config *config,
 
 	struct s921_state *state;
 	state = kzalloc(sizeof(struct s921_state), GFP_KERNEL);
+	if (state == NULL)
+		return NULL;
 
 	state->addr = config->i2c_address;
 	state->i2c = i2c;
