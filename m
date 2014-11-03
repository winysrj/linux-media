Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49775 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934AbaKCVkI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Nov 2014 16:40:08 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] si2168: do not print device is warm every-time when opened
Date: Mon,  3 Nov 2014 23:39:02 +0200
Message-Id: <1415050742-17146-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It repeated "found a 'Silicon Labs Si2168' in warm state" everytime
when device was opened. Message is aimed to point out firmware is
downloaded, up and running. So print it only in case firmware download
is performed.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/si2168.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 1cd93be..7bac748 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -498,10 +498,9 @@ static int si2168_init(struct dvb_frontend *fe)
 
 	s->fw_loaded = true;
 
-warm:
 	dev_info(&s->client->dev, "found a '%s' in warm state\n",
 			si2168_ops.info.name);
-
+warm:
 	s->active = true;
 
 	return 0;
-- 
http://palosaari.fi/

