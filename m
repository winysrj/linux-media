Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44394 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756140AbaICUdb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 16:33:31 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 32/46] [media] e4000: simplify boolean tests
Date: Wed,  3 Sep 2014 17:33:04 -0300
Message-Id: <86da9d3c8d8ced8d61c8c57b774da2e7f7a2a4ef.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using if (foo == false), just use
if (!foo).

That allows a faster mental parsing when analyzing the
code.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/tuners/e4000.c b/drivers/media/tuners/e4000.c
index 90d93348f20c..cd9cf643f602 100644
--- a/drivers/media/tuners/e4000.c
+++ b/drivers/media/tuners/e4000.c
@@ -400,7 +400,7 @@ static int e4000_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
 	struct e4000 *s = container_of(ctrl->handler, struct e4000, hdl);
 	int ret;
 
-	if (s->active == false)
+	if (!s->active)
 		return 0;
 
 	switch (ctrl->id) {
@@ -423,7 +423,7 @@ static int e4000_s_ctrl(struct v4l2_ctrl *ctrl)
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
 
-	if (s->active == false)
+	if (!s->active)
 		return 0;
 
 	switch (ctrl->id) {
-- 
1.9.3

