Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37247 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751088AbaKFUyr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 6 Nov 2014 15:54:47 -0500
Received: from valkosipuli.retiisi.org.uk (vihersipuli.retiisi.org.uk [IPv6:2001:1bc8:102:7fc9::84:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id B0A7C60098
	for <linux-media@vger.kernel.org>; Thu,  6 Nov 2014 22:54:44 +0200 (EET)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/1] smiapp: Only some selection targets are settable
Date: Thu,  6 Nov 2014 22:54:14 +0200
Message-Id: <1415307254-23330-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Setting a non-settable selection target caused BUG() to be called. The check
for valid selections only takes the selection target into account, but does
not tell whether it may be set, or only get. Fix the issue by simply
returning an error to the user.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/i2c/smiapp/smiapp-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index bcc5866..506bfde 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2259,7 +2259,7 @@ static int smiapp_set_selection(struct v4l2_subdev *subdev,
 		ret = smiapp_set_compose(subdev, fh, sel);
 		break;
 	default:
-		BUG();
+		ret = -EINVAL;
 	}
 
 	mutex_unlock(&sensor->mutex);
-- 
1.7.10.4

