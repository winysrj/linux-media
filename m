Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39926 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755849Ab2CIPBH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Mar 2012 10:01:07 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.ifi,
	Martin Hostettler <martin@neutronstar.dyndns.org>
Subject: [PATCH v4 1/5] mt9p031: Remove duplicate media/v4l2-subdev.h include
Date: Fri,  9 Mar 2012 16:01:21 +0100
Message-Id: <1331305285-10781-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1331305285-10781-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1331305285-10781-1-git-send-email-laurent.pinchart@ideasonboard.com>
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

