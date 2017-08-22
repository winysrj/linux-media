Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:37496 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932849AbdHVM5O (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Aug 2017 08:57:14 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: hverkuil@xs4all.nl, mchehab@kernel.org, awalls@md.metrocast.net,
        prabhakar.csengg@gmail.com, royale@zerezo.com
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH 4/4] [media] usb: constify videobuf_queue_ops structures
Date: Tue, 22 Aug 2017 18:26:36 +0530
Message-Id: <1503406596-28266-5-git-send-email-arvind.yadav.cs@gmail.com>
In-Reply-To: <1503406596-28266-1-git-send-email-arvind.yadav.cs@gmail.com>
References: <1503406596-28266-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

videobuf_queue_ops are not supposed to change at runtime. All functions
working with videobuf_queue_ops provided by <media/videobuf-core.h> work
with const videobuf_queue_ops. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/media/usb/cx231xx/cx231xx-417.c   | 2 +-
 drivers/media/usb/cx231xx/cx231xx-video.c | 2 +-
 drivers/media/usb/tm6000/tm6000-video.c   | 2 +-
 drivers/media/usb/zr364xx/zr364xx.c       | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-417.c b/drivers/media/usb/cx231xx/cx231xx-417.c
index 509d971..2b16808 100644
--- a/drivers/media/usb/cx231xx/cx231xx-417.c
+++ b/drivers/media/usb/cx231xx/cx231xx-417.c
@@ -1490,7 +1490,7 @@ static void bb_buf_release(struct videobuf_queue *q,
 	free_buffer(q, buf);
 }
 
-static struct videobuf_queue_ops cx231xx_qops = {
+static const struct videobuf_queue_ops cx231xx_qops = {
 	.buf_setup    = bb_buf_setup,
 	.buf_prepare  = bb_buf_prepare,
 	.buf_queue    = bb_buf_queue,
diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index f67f868..179b848 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -859,7 +859,7 @@ static void buffer_release(struct videobuf_queue *vq,
 	free_buffer(vq, buf);
 }
 
-static struct videobuf_queue_ops cx231xx_video_qops = {
+static const struct videobuf_queue_ops cx231xx_video_qops = {
 	.buf_setup = buffer_setup,
 	.buf_prepare = buffer_prepare,
 	.buf_queue = buffer_queue,
diff --git a/drivers/media/usb/tm6000/tm6000-video.c b/drivers/media/usb/tm6000/tm6000-video.c
index 7e960d0..35925f1 100644
--- a/drivers/media/usb/tm6000/tm6000-video.c
+++ b/drivers/media/usb/tm6000/tm6000-video.c
@@ -801,7 +801,7 @@ static void buffer_release(struct videobuf_queue *vq, struct videobuf_buffer *vb
 	free_buffer(vq, buf);
 }
 
-static struct videobuf_queue_ops tm6000_video_qops = {
+static const struct videobuf_queue_ops tm6000_video_qops = {
 	.buf_setup      = buffer_setup,
 	.buf_prepare    = buffer_prepare,
 	.buf_queue      = buffer_queue,
diff --git a/drivers/media/usb/zr364xx/zr364xx.c b/drivers/media/usb/zr364xx/zr364xx.c
index efdcd5b..24d5860 100644
--- a/drivers/media/usb/zr364xx/zr364xx.c
+++ b/drivers/media/usb/zr364xx/zr364xx.c
@@ -439,7 +439,7 @@ static void buffer_release(struct videobuf_queue *vq,
 	free_buffer(vq, buf);
 }
 
-static struct videobuf_queue_ops zr364xx_video_qops = {
+static const struct videobuf_queue_ops zr364xx_video_qops = {
 	.buf_setup = buffer_setup,
 	.buf_prepare = buffer_prepare,
 	.buf_queue = buffer_queue,
-- 
1.9.1
