Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:37458 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932893AbdHVM5C (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Aug 2017 08:57:02 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: hverkuil@xs4all.nl, mchehab@kernel.org, awalls@md.metrocast.net,
        prabhakar.csengg@gmail.com, royale@zerezo.com
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH 1/4] [media] saa7146: constify videobuf_queue_ops structures
Date: Tue, 22 Aug 2017 18:26:33 +0530
Message-Id: <1503406596-28266-2-git-send-email-arvind.yadav.cs@gmail.com>
In-Reply-To: <1503406596-28266-1-git-send-email-arvind.yadav.cs@gmail.com>
References: <1503406596-28266-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

videobuf_queue_ops are not supposed to change at runtime. All functions
working with videobuf_queue_ops provided by <media/videobuf-core.h> work
with const videobuf_queue_ops. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/media/common/saa7146/saa7146_vbi.c   | 2 +-
 drivers/media/common/saa7146/saa7146_video.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/common/saa7146/saa7146_vbi.c b/drivers/media/common/saa7146/saa7146_vbi.c
index 3553ac4..d79e4d7 100644
--- a/drivers/media/common/saa7146/saa7146_vbi.c
+++ b/drivers/media/common/saa7146/saa7146_vbi.c
@@ -308,7 +308,7 @@ static void buffer_release(struct videobuf_queue *q, struct videobuf_buffer *vb)
 	saa7146_dma_free(dev,q,buf);
 }
 
-static struct videobuf_queue_ops vbi_qops = {
+static const struct videobuf_queue_ops vbi_qops = {
 	.buf_setup    = buffer_setup,
 	.buf_prepare  = buffer_prepare,
 	.buf_queue    = buffer_queue,
diff --git a/drivers/media/common/saa7146/saa7146_video.c b/drivers/media/common/saa7146/saa7146_video.c
index b3b29d4..37b4654 100644
--- a/drivers/media/common/saa7146/saa7146_video.c
+++ b/drivers/media/common/saa7146/saa7146_video.c
@@ -1187,7 +1187,7 @@ static void buffer_release(struct videobuf_queue *q, struct videobuf_buffer *vb)
 	release_all_pagetables(dev, buf);
 }
 
-static struct videobuf_queue_ops video_qops = {
+static const struct videobuf_queue_ops video_qops = {
 	.buf_setup    = buffer_setup,
 	.buf_prepare  = buffer_prepare,
 	.buf_queue    = buffer_queue,
-- 
1.9.1
