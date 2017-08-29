Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:54202 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751270AbdH2Ubc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Aug 2017 16:31:32 -0400
Subject: [PATCH 1/3] [media] cx24113: Delete an error message for a failed
 memory allocation in cx24113_attach()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <36a5402f-c7a2-edf0-1af8-b98b0684d8e5@users.sourceforge.net>
Message-ID: <8273a111-9edf-7079-fc6a-ea674b06f43a@users.sourceforge.net>
Date: Tue, 29 Aug 2017 22:31:23 +0200
MIME-Version: 1.0
In-Reply-To: <36a5402f-c7a2-edf0-1af8-b98b0684d8e5@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 29 Aug 2017 22:08:09 +0200

Omit an extra message for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/dvb-frontends/cx24113.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/cx24113.c b/drivers/media/dvb-frontends/cx24113.c
index 0118c2658cf7..8fc7333c76b7 100644
--- a/drivers/media/dvb-frontends/cx24113.c
+++ b/drivers/media/dvb-frontends/cx24113.c
@@ -557,8 +557,7 @@ struct dvb_frontend *cx24113_attach(struct dvb_frontend *fe,
 	int rc;
-	if (state == NULL) {
-		cx_err("Unable to kzalloc\n");
+
+	if (!state)
 		goto error;
-	}
 
 	/* setup the state */
 	state->config = config;
-- 
2.14.1
