Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33952 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726976AbeKFUqQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Nov 2018 15:46:16 -0500
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chen-Yu Tsai <wens@csie.org>, devel@driverdev.osuosl.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] cedrus: check if kzalloc() fails
Date: Tue,  6 Nov 2018 06:21:29 -0500
Message-Id: <b9bd5d87291191eeeef2b0611a1cc0acde52b2c9.1541503285.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As warned by static code analizer checkers:
	drivers/staging/media/sunxi/cedrus/cedrus.c: drivers/staging/media/sunxi/cedrus/cedrus.c:93 cedrus_init_ctrls() error: potential null dereference 'ctx->ctrls'.  (kzalloc returns null)

The problem is that it assumes that kzalloc() will always
succeed.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/staging/media/sunxi/cedrus/cedrus.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/media/sunxi/cedrus/cedrus.c b/drivers/staging/media/sunxi/cedrus/cedrus.c
index dd121f66fa2d..6a73a7841303 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus.c
@@ -72,6 +72,8 @@ static int cedrus_init_ctrls(struct cedrus_dev *dev, struct cedrus_ctx *ctx)
 	ctrl_size = sizeof(ctrl) * CEDRUS_CONTROLS_COUNT + 1;
 
 	ctx->ctrls = kzalloc(ctrl_size, GFP_KERNEL);
+	if (!ctx->ctrls)
+		return -ENOMEM;
 	memset(ctx->ctrls, 0, ctrl_size);
 
 	for (i = 0; i < CEDRUS_CONTROLS_COUNT; i++) {
-- 
2.19.1
