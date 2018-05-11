Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:41727 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752563AbeEKOSP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 May 2018 10:18:15 -0400
From: Colin King <colin.king@canonical.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: dvb_frontends: fix spelling mistake: "unexpcted" -> "unexpected"
Date: Fri, 11 May 2018 15:18:13 +0100
Message-Id: <20180511141813.26739-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in dprintk message text

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/dvb-frontends/l64781.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/l64781.c b/drivers/media/dvb-frontends/l64781.c
index e056f36e6f0c..249c18761e6e 100644
--- a/drivers/media/dvb-frontends/l64781.c
+++ b/drivers/media/dvb-frontends/l64781.c
@@ -546,7 +546,7 @@ struct dvb_frontend* l64781_attach(const struct l64781_config* config,
 
 	/* Responds to all reads with 0 */
 	if (l64781_readreg(state, 0x1a) != 0) {
-		dprintk("Read 1 returned unexpcted value\n");
+		dprintk("Read 1 returned unexpected value\n");
 		goto error;
 	}
 
@@ -555,7 +555,7 @@ struct dvb_frontend* l64781_attach(const struct l64781_config* config,
 
 	/* Responds with register default value */
 	if (l64781_readreg(state, 0x1a) != 0xa1) {
-		dprintk("Read 2 returned unexpcted value\n");
+		dprintk("Read 2 returned unexpected value\n");
 		goto error;
 	}
 
-- 
2.17.0
