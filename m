Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:60955 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751039AbdH3HXS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Aug 2017 03:23:18 -0400
Subject: [PATCH 5/6] [media] cx24116: Delete an unnecessary variable
 initialisation in cx24116_attach()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <d01b4a11-6e93-bc40-72de-dab9ce7b997a@users.sourceforge.net>
Message-ID: <86ad8f11-90b6-4930-8243-ab2e0e0c7650@users.sourceforge.net>
Date: Wed, 30 Aug 2017 09:23:13 +0200
MIME-Version: 1.0
In-Reply-To: <d01b4a11-6e93-bc40-72de-dab9ce7b997a@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 30 Aug 2017 08:30:12 +0200

The variable "state" will be set to an appropriate pointer a bit later.
Thus omit the explicit initialisation at the beginning.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/dvb-frontends/cx24116.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/cx24116.c b/drivers/media/dvb-frontends/cx24116.c
index 74d610207bf2..902a60d2e1b5 100644
--- a/drivers/media/dvb-frontends/cx24116.c
+++ b/drivers/media/dvb-frontends/cx24116.c
@@ -1117,7 +1117,7 @@ static const struct dvb_frontend_ops cx24116_ops;
 struct dvb_frontend *cx24116_attach(const struct cx24116_config *config,
 	struct i2c_adapter *i2c)
 {
-	struct cx24116_state *state = NULL;
+	struct cx24116_state *state;
 	int ret;
 
 	dprintk("%s\n", __func__);
-- 
2.14.1
