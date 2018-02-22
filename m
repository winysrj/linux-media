Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:37320 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933523AbeBVRzI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Feb 2018 12:55:08 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Tim Harvey <tharvey@gateworks.com>
Subject: [PATCH] tda1997x: get rid of an unused var
Date: Thu, 22 Feb 2018 12:55:02 -0500
Message-Id: <4395fb475a27ddcb33c27380e132ef5354ff67c6.1519322100.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

1 warning regressions:
  + drivers/media/i2c/tda1997x.c: warning: variable 'last_irq_status' set but not used [-Wunused-but-set-variable]:  => 1421:17

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/i2c/tda1997x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/tda1997x.c b/drivers/media/i2c/tda1997x.c
index a480aafecbf6..3021913c28fa 100644
--- a/drivers/media/i2c/tda1997x.c
+++ b/drivers/media/i2c/tda1997x.c
@@ -1418,13 +1418,13 @@ static void tda1997x_irq_rate(struct tda1997x_state *state, u8 *flags)
 	struct v4l2_subdev *sd = &state->sd;
 	u8 reg, source;
 
-	u8 irq_status, last_irq_status;
+	u8 irq_status;
 
 	source = io_read(sd, REG_INT_FLG_CLR_RATE);
 	io_write(sd, REG_INT_FLG_CLR_RATE, source);
 
 	/* read status regs */
-	last_irq_status = irq_status = tda1997x_read_activity_status_regs(sd);
+	irq_status = tda1997x_read_activity_status_regs(sd);
 
 	/*
 	 * read clock status reg until INT_FLG_CLR_RATE is still 0
-- 
2.14.3
