Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:44674 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751141AbdKEOZX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 5 Nov 2017 09:25:23 -0500
From: Matthias Schwarzott <zzam@gentoo.org>
To: mchehab@kernel.org, linux-media@vger.kernel.org
Cc: Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH 07/15] si2165: Write const value for lock timeout
Date: Sun,  5 Nov 2017 15:25:03 +0100
Message-Id: <20171105142511.16563-7-zzam@gentoo.org>
In-Reply-To: <20171105142511.16563-1-zzam@gentoo.org>
References: <20171105142511.16563-1-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The lock timeout should not depend on the bandwidth.
It should be either constant or depend on xtal frequency.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/dvb-frontends/si2165.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2165.c b/drivers/media/dvb-frontends/si2165.c
index f8d7595a25d4..0b801bad5802 100644
--- a/drivers/media/dvb-frontends/si2165.c
+++ b/drivers/media/dvb-frontends/si2165.c
@@ -850,7 +850,6 @@ static int si2165_set_frontend_dvbc(struct dvb_frontend *fe)
 	int ret;
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	const u32 dvb_rate = p->symbol_rate;
-	const u32 bw_hz = p->bandwidth_hz;
 
 	if (!state->has_dvbc)
 		return -EINVAL;
@@ -867,7 +866,7 @@ static int si2165_set_frontend_dvbc(struct dvb_frontend *fe)
 	if (ret < 0)
 		return ret;
 
-	ret = si2165_writereg32(state, REG_LOCK_TIMEOUT, bw_hz);
+	ret = si2165_writereg32(state, REG_LOCK_TIMEOUT, 0x007a1200);
 	if (ret < 0)
 		return ret;
 
-- 
2.15.0
