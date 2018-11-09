Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:37679 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727667AbeKIXS3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Nov 2018 18:18:29 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] vivid: free bitmap_cap when updating std/timings/etc.
Message-ID: <87284cfc-feea-41fe-cbbd-879a14ae8a6b@xs4all.nl>
Date: Fri, 9 Nov 2018 14:37:44 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When vivid_update_format_cap() is called it should free any overlay
bitmap since the compose size will change.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Reported-by: syzbot+0cc8e3cc63ca373722c6@syzkaller.appspotmail.com
---
 drivers/media/platform/vivid/vivid-vid-cap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index 9c8e8be81ce3..46d4e53ce763 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -451,6 +451,8 @@ void vivid_update_format_cap(struct vivid_dev *dev, bool keep_controls)
 		tpg_s_rgb_range(&dev->tpg, v4l2_ctrl_g_ctrl(dev->rgb_range_cap));
 		break;
 	}
+	vfree(dev->bitmap_cap);
+	dev->bitmap_cap = NULL;
 	vivid_update_quality(dev);
 	tpg_reset_source(&dev->tpg, dev->src_rect.width, dev->src_rect.height, dev->field_cap);
 	dev->crop_cap = dev->src_rect;
-- 
2.19.1
