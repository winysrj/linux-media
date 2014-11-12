Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53286 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934007AbaKLETl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Nov 2014 23:19:41 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/9] mn88473: implement DVB-T mode
Date: Wed, 12 Nov 2014 06:19:25 +0200
Message-Id: <1415765971-24378-4-git-send-email-crope@iki.fi>
In-Reply-To: <1415765971-24378-1-git-send-email-crope@iki.fi>
References: <1415765971-24378-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement DVB-T mode.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/mn88473.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/mn88473.c b/drivers/media/dvb-frontends/mn88473.c
index 68bfb65..cda0bdb 100644
--- a/drivers/media/dvb-frontends/mn88473.c
+++ b/drivers/media/dvb-frontends/mn88473.c
@@ -132,6 +132,13 @@ static int mn88473_set_frontend(struct dvb_frontend *fe)
 	}
 
 	switch (c->delivery_system) {
+	case SYS_DVBT:
+		delivery_system = 0x02;
+		if (c->bandwidth_hz <= 7000000)
+			memcpy(params, "\x2e\xcb\xfb\xc8\x00\x00\x17\x0a\x17\x0a", 10);
+		else if (c->bandwidth_hz <= 8000000)
+			memcpy(params, "\x2e\xcb\xfb\xaf\x00\x00\x11\xec\x11\xec", 10);
+		break;
 	case SYS_DVBT2:
 		delivery_system = 0x03;
 		if (c->bandwidth_hz <= 7000000)
@@ -194,10 +201,12 @@ static int mn88473_set_frontend(struct dvb_frontend *fe)
 	ret = mn88473_wregs(dev, 0x1c2d, "\x3b", 1);
 	ret = mn88473_wregs(dev, 0x1c2e, "\x00", 1);
 	ret = mn88473_wregs(dev, 0x1c56, "\x0d", 1);
+	ret = mn88473_wregs(dev, 0x1801, "\xba", 1);
 	ret = mn88473_wregs(dev, 0x1802, "\x13", 1);
 	ret = mn88473_wregs(dev, 0x1803, "\x80", 1);
 	ret = mn88473_wregs(dev, 0x1804, "\xba", 1);
 	ret = mn88473_wregs(dev, 0x1805, "\x91", 1);
+	ret = mn88473_wregs(dev, 0x1807, "\xe7", 1);
 	ret = mn88473_wregs(dev, 0x1808, "\x28", 1);
 	ret = mn88473_wregs(dev, 0x180a, "\x1a", 1);
 	ret = mn88473_wregs(dev, 0x1813, "\x1f", 1);
@@ -382,7 +391,7 @@ err:
 EXPORT_SYMBOL(mn88473_attach);
 
 static struct dvb_frontend_ops mn88473_ops = {
-	.delsys = {SYS_DVBT2, SYS_DVBC_ANNEX_AC},
+	.delsys = {SYS_DVBT, SYS_DVBT2, SYS_DVBC_ANNEX_AC},
 	.info = {
 		.name = "Panasonic MN88473",
 		.caps =	FE_CAN_FEC_1_2			|
-- 
http://palosaari.fi/

