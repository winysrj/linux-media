Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:55928 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757963AbeDXNTK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 09:19:10 -0400
From: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Brad Love <brad@nextdimension.cc>,
        Michael Ira Krufky <mkrufky@linuxtv.org>,
        Hans Verkuil <hansverk@cisco.com>,
        Thomas Meyer <thomas@m3y3r.de>, linux-media@vger.kernel.org
Subject: [PATCH] media: lgdt3306a: fix lgdt3306a_search()'s return type
Date: Tue, 24 Apr 2018 15:19:04 +0200
Message-Id: <20180424131907.5817-1-luc.vanoostenryck@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The method dvb_frontend_ops::search() is defined as
returning an 'enum dvbfe_search', but the implementation in this
driver returns an 'int'.

Fix this by returning 'enum dvbfe_search' in this driver too.

Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
---
 drivers/media/dvb-frontends/lgdt3306a.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/lgdt3306a.c b/drivers/media/dvb-frontends/lgdt3306a.c
index 7eb4e1469..32de82447 100644
--- a/drivers/media/dvb-frontends/lgdt3306a.c
+++ b/drivers/media/dvb-frontends/lgdt3306a.c
@@ -1784,7 +1784,7 @@ static int lgdt3306a_get_tune_settings(struct dvb_frontend *fe,
 	return 0;
 }
 
-static int lgdt3306a_search(struct dvb_frontend *fe)
+static enum dvbfe_search lgdt3306a_search(struct dvb_frontend *fe)
 {
 	enum fe_status status = 0;
 	int ret;
-- 
2.17.0
