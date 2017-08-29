Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:56890 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751237AbdH2Ucl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Aug 2017 16:32:41 -0400
Subject: [PATCH 2/3] [media] cx24113: Return directly after a failed kzalloc()
 in cx24113_attach()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <36a5402f-c7a2-edf0-1af8-b98b0684d8e5@users.sourceforge.net>
Message-ID: <935e3259-e764-8395-84c8-def879f0bbbc@users.sourceforge.net>
Date: Tue, 29 Aug 2017 22:32:30 +0200
MIME-Version: 1.0
In-Reply-To: <36a5402f-c7a2-edf0-1af8-b98b0684d8e5@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 29 Aug 2017 22:10:49 +0200

Return directly after a call of the function "kzalloc" failed
at the beginning.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/dvb-frontends/cx24113.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/cx24113.c b/drivers/media/dvb-frontends/cx24113.c
index 8fc7333c76b7..09c3fd1840f2 100644
--- a/drivers/media/dvb-frontends/cx24113.c
+++ b/drivers/media/dvb-frontends/cx24113.c
@@ -557,7 +557,7 @@ struct dvb_frontend *cx24113_attach(struct dvb_frontend *fe,
 	int rc;
 
 	if (!state)
-		goto error;
+		return NULL;
 
 	/* setup the state */
 	state->config = config;
-- 
2.14.1
