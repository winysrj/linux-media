Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50462 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752600AbbFFL7J (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Jun 2015 07:59:09 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 5/8] ts2020: Add a comment about lifetime of on-stack pdata in ts2020_attach()
Date: Sat,  6 Jun 2015 14:58:45 +0300
Message-Id: <1433591928-30915-5-git-send-email-crope@iki.fi>
In-Reply-To: <1433591928-30915-1-git-send-email-crope@iki.fi>
References: <1433591928-30915-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: David Howells <dhowells@redhat.com>

ts2020_attach() allocates a variable pdata on the stack and then passes a
pointer to it to i2c_new_device() which stashes the pointer in persistent
structures.

Add a comment to the effect that this isn't actually an error because the
contents of the variable are only used in ts2020_probe() and this is only
called ts2020_attach()'s stack frame exists.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/ts2020.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/dvb-frontends/ts2020.c b/drivers/media/dvb-frontends/ts2020.c
index 797112b..f674717 100644
--- a/drivers/media/dvb-frontends/ts2020.c
+++ b/drivers/media/dvb-frontends/ts2020.c
@@ -363,6 +363,8 @@ struct dvb_frontend *ts2020_attach(struct dvb_frontend *fe,
 {
 	struct i2c_client *client;
 	struct i2c_board_info board_info;
+
+	/* This is only used by ts2020_probe() so can be on the stack */
 	struct ts2020_config pdata;
 
 	memcpy(&pdata, config, sizeof(pdata));
-- 
http://palosaari.fi/

