Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53242 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754889AbbEUTXM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2015 15:23:12 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCHv2 1/5] m88ds3103: do not return error from get_frontend() when not ready
Date: Thu, 21 May 2015 22:22:48 +0300
Message-Id: <1432236172-13964-2-git-send-email-crope@iki.fi>
In-Reply-To: <1432236172-13964-1-git-send-email-crope@iki.fi>
References: <1432236172-13964-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Do not return error from get_frontend() when status is queried, but
device is not ready. dvbv5-zap has habit to call that IOCTL before
device is tuned and it also refuses to use DVBv5 statistic after
that...

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/m88ds3103.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index d3d928e..03dceb5 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -742,7 +742,7 @@ static int m88ds3103_get_frontend(struct dvb_frontend *fe)
 	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
 
 	if (!priv->warm || !(priv->fe_status & FE_HAS_LOCK)) {
-		ret = -EAGAIN;
+		ret = 0;
 		goto err;
 	}
 
-- 
http://palosaari.fi/

