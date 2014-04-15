Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:15929 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbaDOJ2B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Apr 2014 05:28:01 -0400
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-samsung-soc@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, robh+dt@kernel.org, inki.dae@samsung.com,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	t.figa@samsung.com, b.zolnierkie@samsung.com,
	jy0922.shim@samsung.com, rahul.sharma@samsung.com,
	pawel.moll@arm.com, Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCHv2 2/4] drm: exynos: mixer: fix using usleep() in atomic context
Date: Tue, 15 Apr 2014 11:27:18 +0200
Message-id: <1397554040-4037-3-git-send-email-t.stanislaws@samsung.com>
In-reply-to: <1397554040-4037-1-git-send-email-t.stanislaws@samsung.com>
References: <1397554040-4037-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes calling usleep_range() after taking reg_slock
using spin_lock_irqsave(). The mdelay() is used instead.
Waiting in atomic context is not the best idea in general.
Hopefully, waiting occurs only when Video Processor fails
to reset correctly.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_mixer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/exynos/exynos_mixer.c b/drivers/gpu/drm/exynos/exynos_mixer.c
index ce28881..e3306c8 100644
--- a/drivers/gpu/drm/exynos/exynos_mixer.c
+++ b/drivers/gpu/drm/exynos/exynos_mixer.c
@@ -615,7 +615,7 @@ static void vp_win_reset(struct mixer_context *ctx)
 		/* waiting until VP_SRESET_PROCESSING is 0 */
 		if (~vp_reg_read(res, VP_SRESET) & VP_SRESET_PROCESSING)
 			break;
-		usleep_range(10000, 12000);
+		mdelay(10);
 	}
 	WARN(tries == 0, "failed to reset Video Processor\n");
 }
-- 
1.7.9.5

