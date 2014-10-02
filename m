Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50544 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751566AbaJBIqo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Oct 2014 04:46:44 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCH v2 18/18] smiapp: Update PLL when setting format
Date: Thu,  2 Oct 2014 11:46:08 +0300
Message-Id: <1412239568-8524-19-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1412239568-8524-1-git-send-email-sakari.ailus@iki.fi>
References: <1412239568-8524-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The media bus format BPP does affect PLL. Recalculate PLL if the format
changes.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 87d4d5a..c938778 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -1776,7 +1776,7 @@ static int smiapp_set_format_source(struct v4l2_subdev *subdev,
 		__fls(*valid_link_freqs), ~*valid_link_freqs,
 		__ffs(*valid_link_freqs));
 
-	return 0;
+	return smiapp_pll_update(sensor);
 }
 
 static int smiapp_set_format(struct v4l2_subdev *subdev,
-- 
1.7.10.4

