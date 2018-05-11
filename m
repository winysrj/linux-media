Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:37260 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750746AbeEKASp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 May 2018 20:18:45 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: Lubomir Rintel <lkundrak@v3.sk>
Cc: Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH] usbtv: Implement wait_prepare and wait_finish
Date: Thu, 10 May 2018 21:17:20 -0300
Message-Id: <20180511001720.6007-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver is currently specifying a vb2_queue lock,
which means it straightforward to implement wait_prepare
and wait_finish.

Having these callbacks releases the queue lock while blocking,
which improves latency by allowing for example streamoff
or qbuf operations while waiting in dqbuf.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
Compile tested only.

 drivers/media/usb/usbtv/usbtv-video.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/usbtv/usbtv-video.c b/drivers/media/usb/usbtv/usbtv-video.c
index 3668a04359e8..0c0d0ef71573 100644
--- a/drivers/media/usb/usbtv/usbtv-video.c
+++ b/drivers/media/usb/usbtv/usbtv-video.c
@@ -698,6 +698,8 @@ static const struct vb2_ops usbtv_vb2_ops = {
 	.buf_queue = usbtv_buf_queue,
 	.start_streaming = usbtv_start_streaming,
 	.stop_streaming = usbtv_stop_streaming,
+	.wait_prepare = vb2_ops_wait_prepare,
+	.wait_finish = vb2_ops_wait_finish,
 };
 
 static int usbtv_s_ctrl(struct v4l2_ctrl *ctrl)
-- 
2.16.3
