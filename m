Return-path: <linux-media-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:35436 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752138AbcJKOyn (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Oct 2016 10:54:43 -0400
From: Brian Starkey <brian.starkey@arm.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        liviu.dudau@arm.com, robdclark@gmail.com, hverkuil@xs4all.nl,
        eric@anholt.net, ville.syrjala@linux.intel.com, daniel@ffwll.ch
Subject: [RFC PATCH 02/11] drm/fb-helper: Skip writeback connectors
Date: Tue, 11 Oct 2016 15:53:59 +0100
Message-Id: <1476197648-24918-3-git-send-email-brian.starkey@arm.com>
In-Reply-To: <1476197648-24918-1-git-send-email-brian.starkey@arm.com>
References: <1476197648-24918-1-git-send-email-brian.starkey@arm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Writeback connectors aren't much use to the fbdev helpers, as they won't
show anything to the user. Skip them when looking for candidate output
configurations.

Signed-off-by: Brian Starkey <brian.starkey@arm.com>
---
 drivers/gpu/drm/drm_fb_helper.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index 03414bd..dedf6e7 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -2016,6 +2016,10 @@ static int drm_pick_crtcs(struct drm_fb_helper *fb_helper,
 	if (modes[n] == NULL)
 		return best_score;
 
+	/* Writeback connectors aren't much use for fbdev */
+	if (connector->connector_type == DRM_MODE_CONNECTOR_WRITEBACK)
+		return best_score;
+
 	crtcs = kzalloc(fb_helper->connector_count *
 			sizeof(struct drm_fb_helper_crtc *), GFP_KERNEL);
 	if (!crtcs)
-- 
1.7.9.5

