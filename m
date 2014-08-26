Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44167 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755798AbaHZVzW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Aug 2014 17:55:22 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 24/35] [media] exynos4-is/media-dev: get rid of a warning for a dead code
Date: Tue, 26 Aug 2014 18:55:00 -0300
Message-Id: <1409090111-8290-25-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
References: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/platform/exynos4-is/media-dev.c: In function 'fimc_md_link_notify':
drivers/media/platform/exynos4-is/media-dev.c:1102:4: warning: suggest braces around empty body in an 'else' statement [-Wempty-body]
    ; /* TODO: Link state change validation */
    ^

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/platform/exynos4-is/media-dev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 344718df5c62..54c49d5e7690 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -1098,8 +1098,10 @@ static int fimc_md_link_notify(struct media_link *link, unsigned int flags,
 	if (notification == MEDIA_DEV_NOTIFY_PRE_LINK_CH) {
 		if (!(flags & MEDIA_LNK_FL_ENABLED))
 			ret = __fimc_md_modify_pipelines(sink, false);
+#if 0
 		else
-			; /* TODO: Link state change validation */
+			/* TODO: Link state change validation */
+#endif
 	/* After link activation */
 	} else if (notification == MEDIA_DEV_NOTIFY_POST_LINK_CH &&
 		   (link->flags & MEDIA_LNK_FL_ENABLED)) {
-- 
1.9.3

