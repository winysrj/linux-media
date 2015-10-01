Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:35810 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756735AbbJAUZY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Oct 2015 16:25:24 -0400
Received: by lbwr8 with SMTP id r8so15918539lbw.2
        for <linux-media@vger.kernel.org>; Thu, 01 Oct 2015 13:25:23 -0700 (PDT)
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] drxd: use kzalloc in drxd_attach()
Date: Thu,  1 Oct 2015 22:25:15 +0200
Message-Id: <1443731116-23618-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This saves a little .text and removes the sizeof(...) style
inconsistency. Use sizeof(*state) in accordance with CodingStyle.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/media/dvb-frontends/drxd_hard.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/drxd_hard.c b/drivers/media/dvb-frontends/drxd_hard.c
index 34b9441840da..445a15c2714f 100644
--- a/drivers/media/dvb-frontends/drxd_hard.c
+++ b/drivers/media/dvb-frontends/drxd_hard.c
@@ -2950,10 +2950,9 @@ struct dvb_frontend *drxd_attach(const struct drxd_config *config,
 {
 	struct drxd_state *state = NULL;
 
-	state = kmalloc(sizeof(struct drxd_state), GFP_KERNEL);
+	state = kzalloc(sizeof(*state), GFP_KERNEL);
 	if (!state)
 		return NULL;
-	memset(state, 0, sizeof(*state));
 
 	state->ops = drxd_ops;
 	state->dev = dev;
-- 
2.1.3

