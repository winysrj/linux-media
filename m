Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:34052 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932907AbdHVM5G (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Aug 2017 08:57:06 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: hverkuil@xs4all.nl, mchehab@kernel.org, awalls@md.metrocast.net,
        prabhakar.csengg@gmail.com, royale@zerezo.com
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH 2/4] [media] pci: constify videobuf_queue_ops structures
Date: Tue, 22 Aug 2017 18:26:34 +0530
Message-Id: <1503406596-28266-3-git-send-email-arvind.yadav.cs@gmail.com>
In-Reply-To: <1503406596-28266-1-git-send-email-arvind.yadav.cs@gmail.com>
References: <1503406596-28266-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

videobuf_queue_ops are not supposed to change at runtime. All functions
working with videobuf_queue_ops provided by <media/videobuf-core.h> work
with const videobuf_queue_ops. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/media/pci/bt8xx/bttv-driver.c | 2 +-
 drivers/media/pci/cx18/cx18-streams.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index ed319f1..c2f1ba0 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -1702,7 +1702,7 @@ static void buffer_release(struct videobuf_queue *q, struct videobuf_buffer *vb)
 	bttv_dma_free(q,fh->btv,buf);
 }
 
-static struct videobuf_queue_ops bttv_video_qops = {
+static const struct videobuf_queue_ops bttv_video_qops = {
 	.buf_setup    = buffer_setup,
 	.buf_prepare  = buffer_prepare,
 	.buf_queue    = buffer_queue,
diff --git a/drivers/media/pci/cx18/cx18-streams.c b/drivers/media/pci/cx18/cx18-streams.c
index 3c45e007..81d06c1 100644
--- a/drivers/media/pci/cx18/cx18-streams.c
+++ b/drivers/media/pci/cx18/cx18-streams.c
@@ -240,7 +240,7 @@ static void buffer_queue(struct videobuf_queue *q, struct videobuf_buffer *vb)
 	list_add_tail(&buf->vb.queue, &s->vb_capture);
 }
 
-static struct videobuf_queue_ops cx18_videobuf_qops = {
+static const struct videobuf_queue_ops cx18_videobuf_qops = {
 	.buf_setup    = buffer_setup,
 	.buf_prepare  = buffer_prepare,
 	.buf_queue    = buffer_queue,
-- 
1.9.1
