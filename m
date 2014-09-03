Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44382 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079AbaICUda (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 16:33:30 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 10/46] [media] tuner-core: use true/false for boolean vars
Date: Wed,  3 Sep 2014 17:32:42 -0300
Message-Id: <4005e68c0efd4001f631ee1033c3d85b4c86407e.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using 0 or 1 for boolean, use the true/false
defines.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
index 177023200737..559f8372e2eb 100644
--- a/drivers/media/v4l2-core/tuner-core.c
+++ b/drivers/media/v4l2-core/tuner-core.c
@@ -601,7 +601,7 @@ static int tuner_probe(struct i2c_client *client,
 	t->name = "(tuner unset)";
 	t->type = UNSET;
 	t->audmode = V4L2_TUNER_MODE_STEREO;
-	t->standby = 1;
+	t->standby = true;
 	t->radio_freq = 87.5 * 16000;	/* Initial freq range */
 	t->tv_freq = 400 * 16; /* Sets freq to VHF High - needed for some PLL's to properly start */
 
-- 
1.9.3

