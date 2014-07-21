Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44958 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932320AbaGURzO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jul 2014 13:55:14 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2] mb86a20s: fix ISDB-T mode handling
Date: Mon, 21 Jul 2014 14:55:05 -0300
Message-Id: <1405965305-22074-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver was reporting an incorrect mode, when mode 2
is selected.

While testing it, noticed that neither mode 1 or guard
interval 1/32 is supported by this device. Document it,
and ensure that it will report _AUTO when it doesn't lock,
in order to not report a wrong detection to userspace.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/mb86a20s.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index 227a420f7069..b931179c70a4 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -711,11 +711,10 @@ static int mb86a20s_get_frontend(struct dvb_frontend *fe)
 	rc = mb86a20s_readreg(state, 0x07);
 	if (rc < 0)
 		return rc;
+	c->transmission_mode = TRANSMISSION_MODE_AUTO;
 	if ((rc & 0x60) == 0x20) {
-		switch (rc & 0x0c >> 2) {
-		case 0:
-			c->transmission_mode = TRANSMISSION_MODE_2K;
-			break;
+		/* Only modes 2 and 3 are supported */
+		switch ((rc >> 2) & 0x03) {
 		case 1:
 			c->transmission_mode = TRANSMISSION_MODE_4K;
 			break;
@@ -724,7 +723,9 @@ static int mb86a20s_get_frontend(struct dvb_frontend *fe)
 			break;
 		}
 	}
+	c->guard_interval = GUARD_INTERVAL_AUTO;
 	if (!(rc & 0x10)) {
+		/* Guard interval 1/32 is not supported */
 		switch (rc & 0x3) {
 		case 0:
 			c->guard_interval = GUARD_INTERVAL_1_4;
-- 
1.9.3

