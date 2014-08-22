Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40502 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756085AbaHVK6a (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Aug 2014 06:58:30 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Nibble Max <nibble.max@gmail.com>,
	Olli Salonen <olli.salonen@iki.fi>,
	Evgeny Plehov <EvgenyPlehov@ukr.net>,
	CrazyCat <crazycat69@narod.ru>, Antti Palosaari <crope@iki.fi>
Subject: [GIT PULL FINAL 10/21] si2168: DVB-T2 PLP selection implemented
Date: Fri, 22 Aug 2014 13:58:02 +0300
Message-Id: <1408705093-5167-11-git-send-email-crope@iki.fi>
In-Reply-To: <1408705093-5167-1-git-send-email-crope@iki.fi>
References: <1408705093-5167-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: CrazyCat <crazycat69@narod.ru>

DVB-T2 PLP selection implemented for Si2168 demod.
Tested with PCTV 292e.

Signed-off-by: Evgeny Plehov <EvgenyPlehov@ukr.net>
Reviewed-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/si2168.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 97614db..55a4212 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -167,10 +167,10 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
 	u8 bandwidth, delivery_system;
 
 	dev_dbg(&s->client->dev,
-			"delivery_system=%u modulation=%u frequency=%u bandwidth_hz=%u symbol_rate=%u inversion=%u\n",
+			"delivery_system=%u modulation=%u frequency=%u bandwidth_hz=%u symbol_rate=%u inversion=%u, stream_id=%d\n",
 			c->delivery_system, c->modulation,
 			c->frequency, c->bandwidth_hz, c->symbol_rate,
-			c->inversion);
+			c->inversion, c->stream_id);
 
 	if (!s->active) {
 		ret = -EAGAIN;
@@ -234,6 +234,18 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
+	if (c->delivery_system == SYS_DVBT2) {
+		/* select PLP */
+		cmd.args[0] = 0x52;
+		cmd.args[1] = c->stream_id & 0xff;
+		cmd.args[2] = c->stream_id == NO_STREAM_ID_FILTER ? 0 : 1;
+		cmd.wlen = 3;
+		cmd.rlen = 1;
+		ret = si2168_cmd_execute(s, &cmd);
+		if (ret)
+			goto err;
+	}
+
 	memcpy(cmd.args, "\x51\x03", 2);
 	cmd.wlen = 2;
 	cmd.rlen = 12;
-- 
http://palosaari.fi/

