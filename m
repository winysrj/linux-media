Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:65257 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbbAPMff (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jan 2015 07:35:35 -0500
Received: by mail-lb0-f179.google.com with SMTP id z11so18212553lbi.10
        for <linux-media@vger.kernel.org>; Fri, 16 Jan 2015 04:35:34 -0800 (PST)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 1/2] si2168: return error if set_frontend is called with invalid parameters
Date: Fri, 16 Jan 2015 14:35:19 +0200
Message-Id: <1421411720-2364-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch should is based on Antti's silabs branch.

According to dvb-frontend.h set_frontend may be called with bandwidth_hz set to 0 if automatic bandwidth is required. Si2168 does not support automatic bandwidth and does not declare FE_CAN_BANDWIDTH_AUTO in caps.

This patch will change the behaviour in a way that EINVAL is returned if bandwidth_hz is 0.

Cc-to: Antti Palosaari <crope@iki.fi>
Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/dvb-frontends/si2168.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 7f966f3..7fef5ab 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -180,7 +180,12 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
 		goto err;
 	}
 
-	if (c->bandwidth_hz <= 5000000)
+	if (c->bandwidth_hz == 0) {
+		ret = -EINVAL;
+		dev_err(&client->dev, "automatic bandwidth not supported");
+		goto err;
+	}
+	else if (c->bandwidth_hz <= 5000000)
 		bandwidth = 0x05;
 	else if (c->bandwidth_hz <= 6000000)
 		bandwidth = 0x06;
-- 
1.9.1

