Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40160 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725853AbeJaBJA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Oct 2018 21:09:00 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2CBEF7FDED
        for <linux-media@vger.kernel.org>; Tue, 30 Oct 2018 16:14:54 +0000 (UTC)
Received: from wingsuit.redhat.com (ovpn-117-230.ams2.redhat.com [10.36.117.230])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 92B1110841E0
        for <linux-media@vger.kernel.org>; Tue, 30 Oct 2018 16:14:53 +0000 (UTC)
From: Victor Toso <victortoso@redhat.com>
To: linux-media@vger.kernel.org
Subject: [PATCH dvb v1 1/4] af9033: Remove duplicated switch statement
Date: Tue, 30 Oct 2018 17:14:48 +0100
Message-Id: <20181030161451.4560-2-victortoso@redhat.com>
In-Reply-To: <20181030161451.4560-1-victortoso@redhat.com>
References: <20181030161451.4560-1-victortoso@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Victor Toso <me@victortoso.com>

The switch before set is_af9035 or is_it9135 which makes the second
switch redundant. Keeping the comment as to avoid sleep on IT9135.

Signed-off-by: Victor Toso <me@victortoso.com>
---
 drivers/media/dvb-frontends/af9033.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index 0cd57013ea25..23b831ce3439 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -1137,16 +1137,8 @@ static int af9033_probe(struct i2c_client *client,
 		 buf[4], buf[5], buf[6], buf[7]);
 
 	/* Sleep as chip seems to be partly active by default */
-	switch (dev->cfg.tuner) {
-	case AF9033_TUNER_IT9135_38:
-	case AF9033_TUNER_IT9135_51:
-	case AF9033_TUNER_IT9135_52:
-	case AF9033_TUNER_IT9135_60:
-	case AF9033_TUNER_IT9135_61:
-	case AF9033_TUNER_IT9135_62:
-		/* IT9135 did not like to sleep at that early */
-		break;
-	default:
+	/* IT9135 did not like to sleep at that early */
+	if (dev->is_af9035) {
 		ret = regmap_write(dev->regmap, 0x80004c, 0x01);
 		if (ret)
 			goto err_regmap_exit;
-- 
2.17.2
