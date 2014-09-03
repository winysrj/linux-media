Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44273 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755840AbaICUd1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 16:33:27 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH 05/46] [media] s5k5baf: remove an uneeded semicolon
Date: Wed,  3 Sep 2014 17:32:37 -0300
Message-Id: <b9d2fee78022e0e41d311cb7e7a00d68e951ce09.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We don't use semicolons after curly braces in the middle of the
code.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/i2c/s5k5baf.c b/drivers/media/i2c/s5k5baf.c
index 564f05f2c9ef..0e461a6fd065 100644
--- a/drivers/media/i2c/s5k5baf.c
+++ b/drivers/media/i2c/s5k5baf.c
@@ -816,7 +816,7 @@ static void s5k5baf_hw_find_min_fiv(struct s5k5baf *state)
 				 "error setting frame interval: %d\n", err);
 			state->error = -EINVAL;
 		}
-	};
+	}
 	v4l2_err(&state->sd, "cannot find correct frame interval\n");
 	state->error = -ERANGE;
 }
-- 
1.9.3

