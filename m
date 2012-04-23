Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33507 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430Ab2DWN7K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Apr 2012 09:59:10 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH] v4l: aptina-pll: Round up minimum multiplier factor value properly
Date: Mon, 23 Apr 2012 15:59:25 +0200
Message-Id: <1335189565-23617-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The mf_low value must be a multiple of mf_inc. Round it up to the
nearest mf_inc multiple after computing it.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/aptina-pll.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/aptina-pll.c b/drivers/media/video/aptina-pll.c
index 0bd3813..8153a44 100644
--- a/drivers/media/video/aptina-pll.c
+++ b/drivers/media/video/aptina-pll.c
@@ -148,9 +148,8 @@ int aptina_pll_calculate(struct device *dev,
 		unsigned int mf_high;
 		unsigned int mf_low;
 
-		mf_low = max(roundup(mf_min, mf_inc),
-			     DIV_ROUND_UP(pll->ext_clock * p1,
-			       limits->int_clock_max * div));
+		mf_low = roundup(max(mf_min, DIV_ROUND_UP(pll->ext_clock * p1,
+					limits->int_clock_max * div)), mf_inc);
 		mf_high = min(mf_max, pll->ext_clock * p1 /
 			      (limits->int_clock_min * div));
 
-- 
Regards,

Laurent Pinchart

