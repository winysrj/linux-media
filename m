Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:52744 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751227AbdH2Ude (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Aug 2017 16:33:34 -0400
Subject: [media] cx24113: Improve a size determination in cx24113_attach()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <36a5402f-c7a2-edf0-1af8-b98b0684d8e5@users.sourceforge.net>
Message-ID: <ca26f674-9d0d-9bc4-06d9-8a15c69af131@users.sourceforge.net>
Date: Tue, 29 Aug 2017 22:33:25 +0200
MIME-Version: 1.0
In-Reply-To: <36a5402f-c7a2-edf0-1af8-b98b0684d8e5@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 29 Aug 2017 22:17:25 +0200

Replace the specification of a data structure by a pointer dereference
as the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer according to the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/dvb-frontends/cx24113.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/cx24113.c b/drivers/media/dvb-frontends/cx24113.c
index 09c3fd1840f2..ee1f704f81f2 100644
--- a/drivers/media/dvb-frontends/cx24113.c
+++ b/drivers/media/dvb-frontends/cx24113.c
@@ -552,8 +552,7 @@ struct dvb_frontend *cx24113_attach(struct dvb_frontend *fe,
 		const struct cx24113_config *config, struct i2c_adapter *i2c)
 {
 	/* allocate memory for the internal state */
-	struct cx24113_state *state =
-		kzalloc(sizeof(struct cx24113_state), GFP_KERNEL);
+	struct cx24113_state *state = kzalloc(sizeof(*state), GFP_KERNEL);
 	int rc;
 
 	if (!state)
-- 
2.14.1
