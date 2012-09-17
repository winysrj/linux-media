Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:63906 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478Ab2IQNtl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Sep 2012 09:49:41 -0400
Received: by ggdk6 with SMTP id k6so1434646ggd.19
        for <linux-media@vger.kernel.org>; Mon, 17 Sep 2012 06:49:41 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	<linux-media@vger.kernel.org>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 3/4] vivi: Add return code check at vb2_queue_init()
Date: Mon, 17 Sep 2012 10:49:38 -0300
Message-Id: <1347889778-15152-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This function returns an integer and it's mandatory
to check the return code.

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/platform/vivi.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/media/platform/vivi.c b/drivers/media/platform/vivi.c
index fca8019..c1401dd 100644
--- a/drivers/media/platform/vivi.c
+++ b/drivers/media/platform/vivi.c
@@ -1313,7 +1313,9 @@ static int __init vivi_create_instance(int inst)
 	q->ops = &vivi_video_qops;
 	q->mem_ops = &vb2_vmalloc_memops;
 
-	vb2_queue_init(q);
+	ret = vb2_queue_init(q);
+	if (ret)
+		goto unreg_dev;
 
 	mutex_init(&dev->mutex);
 
-- 
1.7.8.6

