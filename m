Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56927 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752594AbaGHFx1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Jul 2014 01:53:27 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/4] tda10071: fix spec inversion reporting
Date: Tue,  8 Jul 2014 08:53:05 +0300
Message-Id: <1404798786-28361-3-git-send-email-crope@iki.fi>
In-Reply-To: <1404798786-28361-1-git-send-email-crope@iki.fi>
References: <1404798786-28361-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Inversion ON was reported as inversion OFF and vice versa.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/tda10071.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/tda10071.c b/drivers/media/dvb-frontends/tda10071.c
index 49874e7..d590798 100644
--- a/drivers/media/dvb-frontends/tda10071.c
+++ b/drivers/media/dvb-frontends/tda10071.c
@@ -838,10 +838,10 @@ static int tda10071_get_frontend(struct dvb_frontend *fe)
 
 	switch ((buf[1] >> 0) & 0x01) {
 	case 0:
-		c->inversion = INVERSION_OFF;
+		c->inversion = INVERSION_ON;
 		break;
 	case 1:
-		c->inversion = INVERSION_ON;
+		c->inversion = INVERSION_OFF;
 		break;
 	}
 
-- 
1.9.3

