Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:61094 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281Ab1KLP4J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Nov 2011 10:56:09 -0500
Received: by wwi18 with SMTP id 18so3286178wwi.1
        for <linux-media@vger.kernel.org>; Sat, 12 Nov 2011 07:56:08 -0800 (PST)
Message-ID: <4ebe9717.5b6be30a.26ea.ffff9ad7@mx.google.com>
Subject: [PATCH 6/7] af9013 Stop OFSM while channel changing.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Sat, 12 Nov 2011 15:56:03 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To minimise corruptions on channel change.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/frontends/af9013.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/frontends/af9013.c b/drivers/media/dvb/frontends/af9013.c
index 38a6ea2..6a5b40c 100644
--- a/drivers/media/dvb/frontends/af9013.c
+++ b/drivers/media/dvb/frontends/af9013.c
@@ -629,6 +629,10 @@ static int af9013_set_frontend(struct dvb_frontend *fe,
 		params->u.ofdm.bandwidth);
 
 	state->frequency = params->frequency;
+	/* Stop OFSM */
+	ret = af9013_write_reg(state, 0xffff, 1);
+	if (ret)
+		goto error;
 
 	/* program tuner */
 	if (mutex_lock_interruptible(state->fe_mutex) < 0)
-- 
1.7.5.4




