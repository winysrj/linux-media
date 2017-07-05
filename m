Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway30.websitewelcome.com ([192.185.192.34]:18005 "EHLO
        gateway30.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751680AbdGEScP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Jul 2017 14:32:15 -0400
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway30.websitewelcome.com (Postfix) with ESMTP id 3F6C7253E6
        for <linux-media@vger.kernel.org>; Wed,  5 Jul 2017 13:07:30 -0500 (CDT)
Date: Wed, 5 Jul 2017 13:07:29 -0500
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Kyungmin Park <kyungmin.park@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] s5k5baf: remove unnecessary static in s5k5baf_get_selection()
Message-ID: <20170705180729.GA10314@embeddedgus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove unnecessary static on local variable rtype.
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
  27765    5656     320   33741    83cd drivers/media/i2c/s5k5baf.o

after:
   text    data     bss     dec     hex filename
  27733    5600     256   33589    8335 drivers/media/i2c/s5k5baf.o


Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/media/i2c/s5k5baf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/s5k5baf.c b/drivers/media/i2c/s5k5baf.c
index 962051b..f01722d 100644
--- a/drivers/media/i2c/s5k5baf.c
+++ b/drivers/media/i2c/s5k5baf.c
@@ -1374,7 +1374,7 @@ static int s5k5baf_get_selection(struct v4l2_subdev *sd,
 				 struct v4l2_subdev_pad_config *cfg,
 				 struct v4l2_subdev_selection *sel)
 {
-	static enum selection_rect rtype;
+	enum selection_rect rtype;
 	struct s5k5baf *state = to_s5k5baf(sd);
 
 	rtype = s5k5baf_get_sel_rect(sel->pad, sel->target);
-- 
2.5.0
