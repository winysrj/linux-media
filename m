Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:55900 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751902AbcLLLRD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Dec 2016 06:17:03 -0500
Received: from axis700.grange ([89.0.199.8]) by mail.gmx.com (mrgmx001
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0MGAdz-1cSGQk43gV-00F9rF for
 <linux-media@vger.kernel.org>; Mon, 12 Dec 2016 12:17:02 +0100
Received: from 200r.grange (200r.grange [192.168.1.16])
        by axis700.grange (Postfix) with ESMTP id B478B8B120
        for <linux-media@vger.kernel.org>; Mon, 12 Dec 2016 12:17:05 +0100 (CET)
From: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        stable@vger.kernel.org
Subject: [PATCH v3 3/4] uvcvideo: fix a wrong macro
Date: Mon, 12 Dec 2016 12:16:51 +0100
Message-Id: <1481541412-1186-4-git-send-email-guennadi.liakhovetski@intel.com>
In-Reply-To: <1481541412-1186-1-git-send-email-guennadi.liakhovetski@intel.com>
References: <1481541412-1186-1-git-send-email-guennadi.liakhovetski@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Don't mix up UVC_BUF_STATE_* and VB2_BUF_STATE_* codes.

Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
Cc: stable@vger.kernel.org
---
 drivers/media/usb/uvc/uvc_queue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
index c119551..b9ef31c 100644
--- a/drivers/media/usb/uvc/uvc_queue.c
+++ b/drivers/media/usb/uvc/uvc_queue.c
@@ -412,7 +412,7 @@ struct uvc_buffer *uvc_queue_next_buffer(struct uvc_video_queue *queue,
 		nextbuf = NULL;
 	spin_unlock_irqrestore(&queue->irqlock, flags);
 
-	buf->state = buf->error ? VB2_BUF_STATE_ERROR : UVC_BUF_STATE_DONE;
+	buf->state = buf->error ? UVC_BUF_STATE_ERROR : UVC_BUF_STATE_DONE;
 	vb2_set_plane_payload(&buf->buf.vb2_buf, 0, buf->bytesused);
 	vb2_buffer_done(&buf->buf.vb2_buf, VB2_BUF_STATE_DONE);
 
-- 
1.9.3

