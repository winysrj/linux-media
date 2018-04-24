Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35473 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758010AbeDXNT0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 09:19:26 -0400
From: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        linux-media@vger.kernel.org
Subject: [PATCH] media: cx24123: fix cx24123_get_algo()'s return type
Date: Tue, 24 Apr 2018 15:19:20 +0200
Message-Id: <20180424131922.6019-1-luc.vanoostenryck@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The method dvb_frontend_ops::get_frontend_algo() is defined as
returning an 'enum dvbfe_algo', but the implementation in this
driver returns an 'int'.

Fix this by returning 'enum dvbfe_algo' in this driver too.

Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
---
 drivers/media/dvb-frontends/cx24123.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/cx24123.c b/drivers/media/dvb-frontends/cx24123.c
index 228ba1f4b..bf33e7390 100644
--- a/drivers/media/dvb-frontends/cx24123.c
+++ b/drivers/media/dvb-frontends/cx24123.c
@@ -1005,7 +1005,7 @@ static int cx24123_tune(struct dvb_frontend *fe,
 	return retval;
 }
 
-static int cx24123_get_algo(struct dvb_frontend *fe)
+static enum dvbfe_algo cx24123_get_algo(struct dvb_frontend *fe)
 {
 	return DVBFE_ALGO_HW;
 }
-- 
2.17.0
