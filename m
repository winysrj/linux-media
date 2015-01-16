Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:57530 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbbAPSgu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jan 2015 13:36:50 -0500
Received: by mail-la0-f43.google.com with SMTP id q1so5015032lam.2
        for <linux-media@vger.kernel.org>; Fri, 16 Jan 2015 10:36:49 -0800 (PST)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCHv2] si2168: return error if set_frontend is called with invalid parameters
Date: Fri, 16 Jan 2015 20:36:38 +0200
Message-Id: <1421433398-1541-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch is based on Antti's silabs branch.

According to dvb-frontend.h set_frontend may be called with bandwidth_hz set to 
0 if automatic bandwidth is required. Si2168 does not support automatic 
bandwidth and does not declare FE_CAN_BANDWIDTH_AUTO in caps.

This patch will change the behaviour in a way that EINVAL is returned if 
bandwidth_hz is 0.

v2: remove error message, remove line break to comply with coding style.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/dvb-frontends/si2168.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 7f966f3..85acc54 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -180,7 +180,10 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
 		goto err;
 	}
 
-	if (c->bandwidth_hz <= 5000000)
+	if (c->bandwidth_hz == 0) {
+		ret = -EINVAL;
+		goto err;
+	} else if (c->bandwidth_hz <= 5000000)
 		bandwidth = 0x05;
 	else if (c->bandwidth_hz <= 6000000)
 		bandwidth = 0x06;
-- 
1.9.1

