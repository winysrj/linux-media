Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:32810 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932486Ab2HGCrt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2012 22:47:49 -0400
Received: by mail-vc0-f174.google.com with SMTP id fk26so3432645vcb.19
        for <linux-media@vger.kernel.org>; Mon, 06 Aug 2012 19:47:49 -0700 (PDT)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 04/24] au0828: Make the s_reg and g_reg advanced debug calls work against the bridge
Date: Mon,  6 Aug 2012 22:46:54 -0400
Message-Id: <1344307634-11673-5-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1344307634-11673-1-git-send-email-dheitmueller@kernellabs.com>
References: <1344307634-11673-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The g_reg and s_reg calls worked properly if acting on subdev registers (such
as the au8522), but didn't work against the au0828 itself.  Copy the logic
over from em28xx.

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
---
 drivers/media/video/au0828/au0828-video.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/au0828/au0828-video.c b/drivers/media/video/au0828/au0828-video.c
index ac3dd73..6e30c09 100644
--- a/drivers/media/video/au0828/au0828-video.c
+++ b/drivers/media/video/au0828/au0828-video.c
@@ -1717,8 +1717,12 @@ static int vidioc_g_register(struct file *file, void *priv,
 		v4l2_device_call_all(&dev->v4l2_dev, 0, core, g_register, reg);
 		return 0;
 	default:
-		return -EINVAL;
+		if (!v4l2_chip_match_host(&reg->match))
+			return -EINVAL;
 	}
+
+	reg->val = au0828_read(dev, reg->reg);
+	return 0;
 }
 
 static int vidioc_s_register(struct file *file, void *priv,
@@ -1732,9 +1736,10 @@ static int vidioc_s_register(struct file *file, void *priv,
 		v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_register, reg);
 		return 0;
 	default:
-		return -EINVAL;
+		if (!v4l2_chip_match_host(&reg->match))
+			return -EINVAL;
 	}
-	return 0;
+	return au0828_writereg(dev, reg->reg, reg->val);
 }
 #endif
 
-- 
1.7.1

