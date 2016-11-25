Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:46496 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750764AbcKYFL3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Nov 2016 00:11:29 -0500
From: Shailendra Verma <shailendra.v@samsung.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Shailendra Verma <shailendra.v@samsung.com>,
        Shailendra Verma <shailendra.capricorn@gmail.com>
Cc: vidushi.koul@samsung.com
Subject: [PATCH] Media: platform: vsp1: - Do not forget to call
Date: Fri, 25 Nov 2016 10:37:57 +0530
Message-id: <1480050477-21189-1-git-send-email-shailendra.v@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2_fh_init is already done.So call the v4l2_fh_exit in error condition
before returing from the function.

Signed-off-by: Shailendra Verma <shailendra.v@samsung.com>
---
 drivers/media/platform/vsp1/vsp1_video.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index d351b9c..cc58163 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -1044,6 +1044,7 @@ static int vsp1_video_open(struct file *file)
 	ret = vsp1_device_get(video->vsp1);
 	if (ret < 0) {
 		v4l2_fh_del(vfh);
+		v4l2_fh_exit(vfh);
 		kfree(vfh);
 	}
 
-- 
1.7.9.5

