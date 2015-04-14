Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:35534 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932962AbbDNQv2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Apr 2015 12:51:28 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH] [media] v4l: vb2: remove unused variable
Date: Tue, 14 Apr 2015 22:21:16 +0530
Message-Id: <1429030276-3646-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This variable was not being used anywhere.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 drivers/media/v4l2-core/videobuf2-core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index c11aee7..d3f7bf0 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -3225,7 +3225,6 @@ EXPORT_SYMBOL_GPL(vb2_thread_start);
 int vb2_thread_stop(struct vb2_queue *q)
 {
 	struct vb2_threadio_data *threadio = q->threadio;
-	struct vb2_fileio_data *fileio = q->fileio;
 	int err;
 
 	if (threadio == NULL)
-- 
1.8.1.2

