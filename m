Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:38767 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932916AbdHVM5K (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Aug 2017 08:57:10 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: hverkuil@xs4all.nl, mchehab@kernel.org, awalls@md.metrocast.net,
        prabhakar.csengg@gmail.com, royale@zerezo.com
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH 3/4] [media] platform: constify videobuf_queue_ops structures
Date: Tue, 22 Aug 2017 18:26:35 +0530
Message-Id: <1503406596-28266-4-git-send-email-arvind.yadav.cs@gmail.com>
In-Reply-To: <1503406596-28266-1-git-send-email-arvind.yadav.cs@gmail.com>
References: <1503406596-28266-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

videobuf_queue_ops are not supposed to change at runtime. All functions
working with videobuf_queue_ops provided by <media/videobuf-core.h> work
with const videobuf_queue_ops. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/media/platform/davinci/vpfe_capture.c | 2 +-
 drivers/media/platform/fsl-viu.c              | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
index b1bf4a7..6792da1 100644
--- a/drivers/media/platform/davinci/vpfe_capture.c
+++ b/drivers/media/platform/davinci/vpfe_capture.c
@@ -1288,7 +1288,7 @@ static void vpfe_videobuf_release(struct videobuf_queue *vq,
 	vb->state = VIDEOBUF_NEEDS_INIT;
 }
 
-static struct videobuf_queue_ops vpfe_videobuf_qops = {
+static const struct videobuf_queue_ops vpfe_videobuf_qops = {
 	.buf_setup      = vpfe_videobuf_setup,
 	.buf_prepare    = vpfe_videobuf_prepare,
 	.buf_queue      = vpfe_videobuf_queue,
diff --git a/drivers/media/platform/fsl-viu.c b/drivers/media/platform/fsl-viu.c
index 97e164b..2aac8e8 100644
--- a/drivers/media/platform/fsl-viu.c
+++ b/drivers/media/platform/fsl-viu.c
@@ -549,7 +549,7 @@ static void buffer_release(struct videobuf_queue *vq,
 	free_buffer(vq, buf);
 }
 
-static struct videobuf_queue_ops viu_video_qops = {
+static const struct videobuf_queue_ops viu_video_qops = {
 	.buf_setup      = buffer_setup,
 	.buf_prepare    = buffer_prepare,
 	.buf_queue      = buffer_queue,
-- 
1.9.1
