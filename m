Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:52561 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965000AbdIZL24 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 07:28:56 -0400
Subject: [PATCH 2/6] [media] tda8261: Improve a size determination in
 tda8261_attach()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <15d74bee-7467-4687-24e1-3501c22f6d75@users.sourceforge.net>
Message-ID: <2225a61b-d990-e2fd-2217-5d860ed86a24@users.sourceforge.net>
Date: Tue, 26 Sep 2017 13:28:51 +0200
MIME-Version: 1.0
In-Reply-To: <15d74bee-7467-4687-24e1-3501c22f6d75@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 26 Sep 2017 12:06:19 +0200

* The script "checkpatch.pl" pointed information out like the following.

  ERROR: do not use assignment in if condition

  Thus fix an affected source code place.

* Replace the specification of a data structure by a pointer dereference
  as the parameter for the operator "sizeof" to make the corresponding size
  determination a bit safer according to the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/dvb-frontends/tda8261.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/tda8261.c b/drivers/media/dvb-frontends/tda8261.c
index 5a8a9b6b8107..5269a170c84e 100644
--- a/drivers/media/dvb-frontends/tda8261.c
+++ b/drivers/media/dvb-frontends/tda8261.c
@@ -185,7 +185,8 @@ struct dvb_frontend *tda8261_attach(struct dvb_frontend *fe,
 {
 	struct tda8261_state *state = NULL;
 
-	if ((state = kzalloc(sizeof (struct tda8261_state), GFP_KERNEL)) == NULL)
+	state = kzalloc(sizeof(*state), GFP_KERNEL);
+	if (!state)
 		goto exit;
 
 	state->config		= config;
-- 
2.14.1
