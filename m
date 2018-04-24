Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:50880 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758020AbeDXNTj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 09:19:39 -0400
From: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: [PATCH] media: s921: fix s921_get_algo()'s return type
Date: Tue, 24 Apr 2018 15:19:34 +0200
Message-Id: <20180424131936.6220-1-luc.vanoostenryck@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The method dvb_frontend_ops::get_frontend_algo() is defined as
returning an 'enum dvbfe_algo', but the implementation in this
driver returns an 'int'.

Fix this by returning 'enum dvbfe_algo' in this driver too.

Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
---
 drivers/media/dvb-frontends/s921.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/s921.c b/drivers/media/dvb-frontends/s921.c
index 2d75ede77..6c9015236 100644
--- a/drivers/media/dvb-frontends/s921.c
+++ b/drivers/media/dvb-frontends/s921.c
@@ -464,7 +464,7 @@ static int s921_tune(struct dvb_frontend *fe,
 	return rc;
 }
 
-static int s921_get_algo(struct dvb_frontend *fe)
+static enum dvbfe_algo s921_get_algo(struct dvb_frontend *fe)
 {
 	return DVBFE_ALGO_HW;
 }
-- 
2.17.0
