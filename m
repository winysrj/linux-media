Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44396 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756142AbaICUdb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 16:33:31 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 29/46] [media] lm3560: simplify a boolean test
Date: Wed,  3 Sep 2014 17:33:01 -0300
Message-Id: <e89f7e626fdfe9e7dd2fb8ffc49092d84dfa7785.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

lml33dpatch is boolean. So, the possible values are
true or false.

Instead of using if (lml33dpath), just use
if (!lml33dpath).

That allows a faster mental parsing when analyzing the
code.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/pci/zoran/zoran_device.c b/drivers/media/pci/zoran/zoran_device.c
index bf34b93f23ee..b6801e035ea4 100644
--- a/drivers/media/pci/zoran/zoran_device.c
+++ b/drivers/media/pci/zoran/zoran_device.c
@@ -682,7 +682,7 @@ set_videobus_dir (struct zoran *zr,
 	switch (zr->card.type) {
 	case LML33:
 	case LML33R10:
-		if (lml33dpath == 0)
+		if (!lml33dpath)
 			GPIO(zr, 5, val);
 		else
 			GPIO(zr, 5, 1);
-- 
1.9.3

