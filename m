Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49754 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298AbbGIEG4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Jul 2015 00:06:56 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 11/12] tda10071: do not get_frontend() when not ready
Date: Thu,  9 Jul 2015 07:06:31 +0300
Message-Id: <1436414792-9716-11-git-send-email-crope@iki.fi>
In-Reply-To: <1436414792-9716-1-git-send-email-crope@iki.fi>
References: <1436414792-9716-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a bit hack, but returning error when driver is not tuned yet
causes DVBv5 zap stop polling DVBv5 statistics. Thus return 0 even
callback is called during invalid device state.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/tda10071.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/tda10071.c b/drivers/media/dvb-frontends/tda10071.c
index c8feb58..c661b74 100644
--- a/drivers/media/dvb-frontends/tda10071.c
+++ b/drivers/media/dvb-frontends/tda10071.c
@@ -720,7 +720,7 @@ static int tda10071_get_frontend(struct dvb_frontend *fe)
 	u8 buf[5], tmp;
 
 	if (!dev->warm || !(dev->fe_status & FE_HAS_LOCK)) {
-		ret = -EFAULT;
+		ret = 0;
 		goto error;
 	}
 
-- 
http://palosaari.fi/

