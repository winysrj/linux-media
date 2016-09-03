Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:38858 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753471AbcICRGX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 3 Sep 2016 13:06:23 -0400
From: Colin King <colin.king@canonical.com>
To: Jemma Denson <jdenson@gmail.com>,
        Patrick Boettcher <patrick.boettcher@posteo.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] [media] cx24120: do not allow an invalid delivery system types
Date: Sat,  3 Sep 2016 18:04:17 +0100
Message-Id: <20160903170417.14061-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

cx24120_set_frontend currently allows invalid delivery system types
other than SYS_DVBS2 and SYS_DVBS.  Fix this by returning -EINVAL
for invalid values.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/dvb-frontends/cx24120.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/cx24120.c b/drivers/media/dvb-frontends/cx24120.c
index 066ee38..3112a32 100644
--- a/drivers/media/dvb-frontends/cx24120.c
+++ b/drivers/media/dvb-frontends/cx24120.c
@@ -1154,8 +1154,7 @@ static int cx24120_set_frontend(struct dvb_frontend *fe)
 		dev_dbg(&state->i2c->dev,
 			"delivery system(%d) not supported\n",
 			c->delivery_system);
-		ret = -EINVAL;
-		break;
+		return -EINVAL;
 	}
 
 	state->dnxt.delsys = c->delivery_system;
-- 
2.9.3

