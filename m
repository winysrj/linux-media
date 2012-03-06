Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45055 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030385Ab2CFMJa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Mar 2012 07:09:30 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Martin Hostettler <martin@neutronstar.dyndns.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH 1/5] mt9p031: Remove duplicate media/v4l2-subdev.h include
Date: Tue,  6 Mar 2012 13:09:42 +0100
Message-Id: <1331035786-8938-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1331035786-8938-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1331035786-8938-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Danny Kukawka <danny.kukawka@bisect.de>

drivers/media/video/mt9p031.c included 'media/v4l2-subdev.h' twice,
remove the duplicate.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/mt9p031.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/mt9p031.c b/drivers/media/video/mt9p031.c
index 93c3ec7..dd937df 100644
--- a/drivers/media/video/mt9p031.c
+++ b/drivers/media/video/mt9p031.c
@@ -19,7 +19,6 @@
 #include <linux/log2.h>
 #include <linux/pm.h>
 #include <linux/slab.h>
-#include <media/v4l2-subdev.h>
 #include <linux/videodev2.h>
 
 #include <media/mt9p031.h>
-- 
1.7.3.4

