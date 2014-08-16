Return-path: <linux-media-owner@vger.kernel.org>
Received: from forward7l.mail.yandex.net ([84.201.143.140]:46435 "EHLO
	forward7l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbaHPVkd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Aug 2014 17:40:33 -0400
From: CrazyCat <crazycat69@narod.ru>
To: linux-media <linux-media@vger.kernel.org>
Cc: Antti Palosaari <crope@iki.fi>
Subject: Re: [PATCH] si2168: DVB-T2 PLP selection implemented
Date: Sun, 17 Aug 2014 00:33:14 +0300
Message-ID: <7423442.VCBAbZjIjj@computer>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DVB-T2 PLP selection implemented for Si2168 demod.
Tested with PCTV 292e.

Signed-off-by: Evgeny Plehov <EvgenyPlehov@ukr.net>
---
 drivers/media/dvb-frontends/si2168.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 37f3f92..9c41281 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -168,10 +168,10 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
 	u8 bandwidth, delivery_system;
 
 	dev_dbg(&s->client->dev,
-			"%s: delivery_system=%u modulation=%u frequency=%u bandwidth_hz=%u symbol_rate=%u inversion=%u\n",
+			"%s: delivery_system=%u modulation=%u frequency=%u bandwidth_hz=%u symbol_rate=%u inversion=%u, stream_id=%d\n",
 			__func__, c->delivery_system, c->modulation,
 			c->frequency, c->bandwidth_hz, c->symbol_rate,
-			c->inversion);
+			c->inversion, c->stream_id);
 
 	if (!s->active) {
 		ret = -EAGAIN;
@@ -235,6 +235,18 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
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
1.9.1

