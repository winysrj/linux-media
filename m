Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:35003 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752111AbdDIBe1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 8 Apr 2017 21:34:27 -0400
From: Geliang Tang <geliangtang@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Geliang Tang <geliangtang@gmail.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/12] [media] saa7146: use setup_timer
Date: Sun,  9 Apr 2017 09:33:58 +0800
Message-Id: <56788f7b11a8395f4c9914dab7d92f71e16390c0.1490953290.git.geliangtang@gmail.com>
In-Reply-To: <77c0fb26d214e023a99afc948c71d6edd9284205.1490953290.git.geliangtang@gmail.com>
References: <77c0fb26d214e023a99afc948c71d6edd9284205.1490953290.git.geliangtang@gmail.com>
In-Reply-To: <77c0fb26d214e023a99afc948c71d6edd9284205.1490953290.git.geliangtang@gmail.com>
References: <77c0fb26d214e023a99afc948c71d6edd9284205.1490953290.git.geliangtang@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use setup_timer() instead of init_timer() to simplify the code.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 drivers/media/common/saa7146/saa7146_vbi.c   | 5 ++---
 drivers/media/common/saa7146/saa7146_video.c | 5 ++---
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/media/common/saa7146/saa7146_vbi.c b/drivers/media/common/saa7146/saa7146_vbi.c
index 4923751..3553ac4 100644
--- a/drivers/media/common/saa7146/saa7146_vbi.c
+++ b/drivers/media/common/saa7146/saa7146_vbi.c
@@ -365,9 +365,8 @@ static void vbi_init(struct saa7146_dev *dev, struct saa7146_vv *vv)
 
 	INIT_LIST_HEAD(&vv->vbi_dmaq.queue);
 
-	init_timer(&vv->vbi_dmaq.timeout);
-	vv->vbi_dmaq.timeout.function = saa7146_buffer_timeout;
-	vv->vbi_dmaq.timeout.data     = (unsigned long)(&vv->vbi_dmaq);
+	setup_timer(&vv->vbi_dmaq.timeout, saa7146_buffer_timeout,
+		    (unsigned long)(&vv->vbi_dmaq));
 	vv->vbi_dmaq.dev              = dev;
 
 	init_waitqueue_head(&vv->vbi_wq);
diff --git a/drivers/media/common/saa7146/saa7146_video.c b/drivers/media/common/saa7146/saa7146_video.c
index e034bcf..b3b29d4 100644
--- a/drivers/media/common/saa7146/saa7146_video.c
+++ b/drivers/media/common/saa7146/saa7146_video.c
@@ -1201,9 +1201,8 @@ static void video_init(struct saa7146_dev *dev, struct saa7146_vv *vv)
 {
 	INIT_LIST_HEAD(&vv->video_dmaq.queue);
 
-	init_timer(&vv->video_dmaq.timeout);
-	vv->video_dmaq.timeout.function = saa7146_buffer_timeout;
-	vv->video_dmaq.timeout.data     = (unsigned long)(&vv->video_dmaq);
+	setup_timer(&vv->video_dmaq.timeout, saa7146_buffer_timeout,
+		    (unsigned long)(&vv->video_dmaq));
 	vv->video_dmaq.dev              = dev;
 
 	/* set some default values */
-- 
2.9.3
