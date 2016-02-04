Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39256 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093AbcBDP6s (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Feb 2016 10:58:48 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 5/7] [media] mb86a20s: get rid of dummy get_frontend()
Date: Thu,  4 Feb 2016 13:57:30 -0200
Message-Id: <ff54e73fc89550573fc37c06a9e2f378fb1d3d1d.1454600641.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1454600641.git.mchehab@osg.samsung.com>
References: <cover.1454600641.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1454600641.git.mchehab@osg.samsung.com>
References: <cover.1454600641.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is not needed, as the core handles well if get_frontend()
is not present.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/dvb-frontends/mb86a20s.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index cfc005ee11d8..fb88dddaf3a3 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -2028,16 +2028,6 @@ static int mb86a20s_read_signal_strength_from_cache(struct dvb_frontend *fe,
 	return 0;
 }
 
-static int mb86a20s_get_frontend_dummy(struct dvb_frontend *fe)
-{
-	/*
-	 * get_frontend is now handled together with other stats
-	 * retrival, when read_status() is called, as some statistics
-	 * will depend on the layers detection.
-	 */
-	return 0;
-};
-
 static int mb86a20s_tune(struct dvb_frontend *fe,
 			bool re_tune,
 			unsigned int mode_flags,
@@ -2136,7 +2126,6 @@ static struct dvb_frontend_ops mb86a20s_ops = {
 
 	.init = mb86a20s_initfe,
 	.set_frontend = mb86a20s_set_frontend,
-	.get_frontend = mb86a20s_get_frontend_dummy,
 	.read_status = mb86a20s_read_status_and_stats,
 	.read_signal_strength = mb86a20s_read_signal_strength_from_cache,
 	.tune = mb86a20s_tune,
-- 
2.5.0


