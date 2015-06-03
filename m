Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33562 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862AbbFCLeQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Jun 2015 07:34:16 -0400
Subject: [PATCH] ts2020: Copy loop_through from the config to the internal
 data
From: David Howells <dhowells@redhat.com>
To: crope@iki.fi
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Date: Wed, 03 Jun 2015 12:34:13 +0100
Message-ID: <20150603113413.31994.35192.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Copy the loop_through setting from the ts2020_config struct to the internal
ts2020_priv struct so that it can actually be used.

Whilst we're at it, group the bitfields together in the same order in both
structs so that the compiler has a good chance to copy them in one go.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/media/dvb-frontends/ts2020.c |    3 ++-
 drivers/media/dvb-frontends/ts2020.h |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/ts2020.c b/drivers/media/dvb-frontends/ts2020.c
index 80ae039..8c997d0 100644
--- a/drivers/media/dvb-frontends/ts2020.c
+++ b/drivers/media/dvb-frontends/ts2020.c
@@ -37,6 +37,7 @@ struct ts2020_priv {
 	/* i2c details */
 	struct i2c_adapter *i2c;
 	int i2c_address;
+	bool loop_through:1;
 	u8 clk_out:2;
 	u8 clk_out_div:5;
 	u32 frequency_div; /* LO output divider switch frequency */
@@ -44,7 +45,6 @@ struct ts2020_priv {
 #define TS2020_M88TS2020 0
 #define TS2020_M88TS2022 1
 	u8 tuner;
-	u8 loop_through:1;
 };
 
 struct ts2020_reg_val {
@@ -582,6 +582,7 @@ static int ts2020_probe(struct i2c_client *client,
 
 	dev->i2c = client->adapter;
 	dev->i2c_address = client->addr;
+	dev->loop_through = pdata->loop_through;
 	dev->clk_out = pdata->clk_out;
 	dev->clk_out_div = pdata->clk_out_div;
 	dev->frequency_div = pdata->frequency_div;
diff --git a/drivers/media/dvb-frontends/ts2020.h b/drivers/media/dvb-frontends/ts2020.h
index 3779724..002bc0a 100644
--- a/drivers/media/dvb-frontends/ts2020.h
+++ b/drivers/media/dvb-frontends/ts2020.h
@@ -32,7 +32,7 @@ struct ts2020_config {
 	/*
 	 * RF loop-through
 	 */
-	u8 loop_through:1;
+	bool loop_through:1;
 
 	/*
 	 * clock output

