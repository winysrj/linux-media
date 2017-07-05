Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway20.websitewelcome.com ([192.185.61.9]:43404 "EHLO
        gateway20.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752040AbdGETKa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Jul 2017 15:10:30 -0400
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway20.websitewelcome.com (Postfix) with ESMTP id 3230A400FF923
        for <linux-media@vger.kernel.org>; Wed,  5 Jul 2017 13:23:56 -0500 (CDT)
Date: Wed, 5 Jul 2017 13:23:55 -0500
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] tuners: remove unnecessary static in simple_dvb_configure()
Message-ID: <20170705182355.GA13493@embeddedgus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove unnecessary static on local variable t_params.
Such variable is initialized before being used,
on every execution path throughout the function.
The static has no benefit and, removing it reduces
the code size.

This issue was detected using Coccinelle and the following semantic patch:

@bad exists@
position p;
identifier x;
type T;
@@

static T x@p;
...
x = <+...x...+>

@@
identifier x;
expression e;
type T;
position p != bad.p;
@@

-static
 T x@p;
 ... when != x
     when strict
?x = e;

In the following log you can see the difference in the code size. Also,
there is a significant difference in the bss segment. This log is the
output of the size command, before and after the code change:

before:
   text    data     bss     dec     hex filename
  23314    3640     832   27786    6c8a drivers/media/tuners/tuner-simple.o

after:
   text    data     bss     dec     hex filename
  23257    3552     768   27577    6bb9 drivers/media/tuners/tuner-simple.o

Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/media/tuners/tuner-simple.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/tuners/tuner-simple.c b/drivers/media/tuners/tuner-simple.c
index 3339b13..cf44d36 100644
--- a/drivers/media/tuners/tuner-simple.c
+++ b/drivers/media/tuners/tuner-simple.c
@@ -846,7 +846,7 @@ static u32 simple_dvb_configure(struct dvb_frontend *fe, u8 *buf,
 	/* This function returns the tuned frequency on success, 0 on error */
 	struct tuner_simple_priv *priv = fe->tuner_priv;
 	struct tunertype *tun = priv->tun;
-	static struct tuner_params *t_params;
+	struct tuner_params *t_params;
 	u8 config, cb;
 	u32 div;
 	int ret;
-- 
2.5.0
