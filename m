Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:64781 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751494AbcLLLQ7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Dec 2016 06:16:59 -0500
Received: from axis700.grange ([89.0.199.8]) by mail.gmx.com (mrgmx101
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0M4ScS-1cZ33D2F2q-00yiZ4 for
 <linux-media@vger.kernel.org>; Mon, 12 Dec 2016 12:16:55 +0100
Received: from 200r.grange (200r.grange [192.168.1.16])
        by axis700.grange (Postfix) with ESMTP id 7D0EF8B113
        for <linux-media@vger.kernel.org>; Mon, 12 Dec 2016 12:17:05 +0100 (CET)
From: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH v3 2/4] uvcvideo: (cosmetic) remove a superfluous assignment
Date: Mon, 12 Dec 2016 12:16:50 +0100
Message-Id: <1481541412-1186-3-git-send-email-guennadi.liakhovetski@intel.com>
In-Reply-To: <1481541412-1186-1-git-send-email-guennadi.liakhovetski@intel.com>
References: <1481541412-1186-1-git-send-email-guennadi.liakhovetski@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Remove a superfluous assignment to a local variable at the end of a
function.

Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
---
 drivers/media/usb/uvc/uvc_video.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index b5589d5..51b5ae5 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1262,8 +1262,7 @@ static void uvc_video_decode_bulk(struct urb *urb, struct uvc_streaming *stream,
 			uvc_video_decode_end(stream, buf, stream->bulk.header,
 				stream->bulk.payload_size);
 			if (buf->state == UVC_BUF_STATE_READY)
-				buf = uvc_queue_next_buffer(&stream->queue,
-							    buf);
+				uvc_queue_next_buffer(&stream->queue, buf);
 		}
 
 		stream->bulk.header_size = 0;
-- 
1.9.3

