Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:54035 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756341AbaLJPfq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Dec 2014 10:35:46 -0500
Message-ID: <54886846.7060905@xs4all.nl>
Date: Wed, 10 Dec 2014 16:35:34 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH for v3.19] sh_veu: v4l2_dev wasn't set
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The v4l2_dev field of struct video_device must be set correctly.
This was never done for this driver, so no video nodes were created
anymore.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/sh_veu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/sh_veu.c b/drivers/media/platform/sh_veu.c
index be3b3bc..54cb88a 100644
--- a/drivers/media/platform/sh_veu.c
+++ b/drivers/media/platform/sh_veu.c
@@ -1179,6 +1179,7 @@ static int sh_veu_probe(struct platform_device *pdev)
 	}
 
 	*vdev = sh_veu_videodev;
+	vdev->v4l2_dev = &veu->v4l2_dev;
 	spin_lock_init(&veu->lock);
 	mutex_init(&veu->fop_lock);
 	vdev->lock = &veu->fop_lock;
-- 
2.1.3

