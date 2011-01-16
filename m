Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60887 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792Ab1APTW6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Jan 2011 14:22:58 -0500
Received: by iwn9 with SMTP id 9so4087897iwn.19
        for <linux-media@vger.kernel.org>; Sun, 16 Jan 2011 11:22:57 -0800 (PST)
From: Pawel Osciak <pawel@osciak.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, Pawel Osciak <pawel@osciak.com>
Subject: [PATCH for 2.6.38] [media] Fix double free of video_device in mem2mem_testdev
Date: Sun, 16 Jan 2011 11:22:20 -0800
Message-Id: <1295205740-14462-1-git-send-email-pawel@osciak.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

video_device is already being freed in video_device.release callback on
release.

Signed-off-by: Pawel Osciak <pawel@osciak.com>
Reported-by: Roland Kletzing <devzero@web.de>
---
 drivers/media/video/mem2mem_testdev.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/mem2mem_testdev.c b/drivers/media/video/mem2mem_testdev.c
index 6ab2d4f..e1f96ea 100644
--- a/drivers/media/video/mem2mem_testdev.c
+++ b/drivers/media/video/mem2mem_testdev.c
@@ -996,7 +996,6 @@ static int m2mtest_remove(struct platform_device *pdev)
 	v4l2_m2m_release(dev->m2m_dev);
 	del_timer_sync(&dev->timer);
 	video_unregister_device(dev->vfd);
-	video_device_release(dev->vfd);
 	v4l2_device_unregister(&dev->v4l2_dev);
 	kfree(dev);
 
-- 
1.7.3.5

