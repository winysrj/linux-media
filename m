Return-path: <linux-media-owner@vger.kernel.org>
Received: from top.free-electrons.com ([176.31.233.9]:32952 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754761AbaGVMXz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jul 2014 08:23:55 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Thierry Reding <thierry.reding@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org,
	Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH 5/5] drm: panel: simple-panel: add bus format information for foxlink panel
Date: Tue, 22 Jul 2014 14:23:47 +0200
Message-Id: <1406031827-12432-6-git-send-email-boris.brezillon@free-electrons.com>
In-Reply-To: <1406031827-12432-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1406031827-12432-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Foxlink's fl500wvr00-a0t supports RGB888 format.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 drivers/gpu/drm/panel/panel-simple.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index 42fd6d1..f1e49fd 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -428,6 +428,7 @@ static const struct panel_desc foxlink_fl500wvr00_a0t = {
 		.width = 108,
 		.height = 65,
 	},
+	.bus_format = VIDEO_BUS_FMT_RGB888_1X24,
 };
 
 static const struct drm_display_mode lg_lp129qe_mode = {
-- 
1.8.3.2

