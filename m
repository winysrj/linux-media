Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38193 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755427Ab2HUNIn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Aug 2012 09:08:43 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] qt1010: do not change frequency during init
Date: Tue, 21 Aug 2012 16:08:20 +0300
Message-Id: <1345554500-31641-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changing cached frequency during init is something no-no.
Make it behave a little bit better. After that device could
survive from suspend/resume when streaming is ongoing.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/qt1010.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/tuners/qt1010.c b/drivers/media/tuners/qt1010.c
index bdc39e1..74e7d4c 100644
--- a/drivers/media/tuners/qt1010.c
+++ b/drivers/media/tuners/qt1010.c
@@ -395,7 +395,8 @@ static int qt1010_init(struct dvb_frontend *fe)
 		if ((err = qt1010_init_meas2(priv, i, &tmpval)))
 			return err;
 
-	c->frequency = 545000000; /* Sigmatek DVB-110 545000000 */
+	if (!c->frequency)
+		c->frequency = 545000000; /* Sigmatek DVB-110 545000000 */
 				      /* MSI Megasky 580 GL861 533000000 */
 	return qt1010_set_params(fe);
 }
-- 
1.7.11.4

