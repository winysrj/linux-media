Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:57337 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753379AbcGDIf0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jul 2016 04:35:26 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 06/14] mcam-core: use v4l2_s_ctrl instead of the s_ctrl op
Date: Mon,  4 Jul 2016 10:35:02 +0200
Message-Id: <1467621310-8203-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1467621310-8203-1-git-send-email-hverkuil@xs4all.nl>
References: <1467621310-8203-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This op is deprecated and should not be used anymore.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Jonathan Corbet <corbet@lwn.net>
---
 drivers/media/platform/marvell-ccic/mcam-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 9b878de..b0a575f 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -973,7 +973,7 @@ static int mcam_cam_set_flip(struct mcam_camera *cam)
 	memset(&ctrl, 0, sizeof(ctrl));
 	ctrl.id = V4L2_CID_VFLIP;
 	ctrl.value = flip;
-	return sensor_call(cam, core, s_ctrl, &ctrl);
+	return v4l2_s_ctrl(NULL, cam->sensor->ctrl_handler, &ctrl);
 }
 
 
-- 
2.8.1

