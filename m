Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60214 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752334AbaLFVfN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Dec 2014 16:35:13 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 08/22] si2168: change stream id debug log formatter
Date: Sat,  6 Dec 2014 23:34:42 +0200
Message-Id: <1417901696-5517-8-git-send-email-crope@iki.fi>
In-Reply-To: <1417901696-5517-1-git-send-email-crope@iki.fi>
References: <1417901696-5517-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change formatter from signed to unsigned as stream_id is 32bit
unsigned variable.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/si2168.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index e51676c..b4a6096 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -155,10 +155,10 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
 	u8 bandwidth, delivery_system;
 
 	dev_dbg(&client->dev,
-			"delivery_system=%u modulation=%u frequency=%u bandwidth_hz=%u symbol_rate=%u inversion=%u, stream_id=%d\n",
-			c->delivery_system, c->modulation,
-			c->frequency, c->bandwidth_hz, c->symbol_rate,
-			c->inversion, c->stream_id);
+			"delivery_system=%u modulation=%u frequency=%u bandwidth_hz=%u symbol_rate=%u inversion=%u stream_id=%u\n",
+			c->delivery_system, c->modulation, c->frequency,
+			c->bandwidth_hz, c->symbol_rate, c->inversion,
+			c->stream_id);
 
 	if (!dev->active) {
 		ret = -EAGAIN;
-- 
http://palosaari.fi/

